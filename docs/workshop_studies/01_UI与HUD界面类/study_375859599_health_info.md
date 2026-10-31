# 饥荒创意工坊深度研读报告：Health Info（非侵入式动作字串注入与网络同步架构）

- **模组标识**：`375859599` (`Health Info / 简明实体血量与动态伤害飘字`)
- **作者**：Nubs, star
- **版本**：v2.2.04
- **领域分类**：动作字串切面拦截（`BufferedAction:GetActionString`）、黑白名单极速哈希分流（`black_white_lists.lua`）、非侵入式网络广播与跨版本兼容（DS/DST/Hamlet/RoG）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与预置名单）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中显示生物血量，最粗暴的做法往往是直接在 `GetDisplayName` 或 `Hoverer` 界面强行追加文本，但这会导致两大严重问题：
1. **字符串拼接污染游戏逻辑**：很多官方逻辑依赖 `inst:GetDisplayName()` 匹配名字，血量注入名字后会导致官方任务检测、烹饪锅判定或成就系统因名字不匹配而崩溃；
2. **客机端无权威血量组件**：普通小怪在客户端没有 `health` 组件，客机直接读会报错。

`Health Info` 堪称饥荒生态在**轻量级非侵入式交互拦截与网络变量广播**上的典范巨作：
1. **动作与交互字串上下文单次改写（Transient Action Overwrite）**：拦截 `playercontroller:GetLeftMouseAction` 与 `BufferedAction:GetActionString`，仅在渲染屏幕悬浮交互词（如 `Attack Spider <100 / 100>`）的瞬间注入血量，绝不修改底层的 `GetDisplayName`；
2. **递归调用防护锁（`DISABLE_HELATHINFO_RECURSIVE`）**：在字符串格式化过程中设置执行栈标记，防止由于其他 Mod 交叉拦截引发无限递归栈溢出（Stack Overflow）；
3. **黑白名单静态 O(1) 过滤管线**：内置数十种不需要血量的实体（落叶、阴影、地面特效、建筑残骸）哈希黑名单，极大减轻每帧索敌计算负载。

---

## 二、四大硬核核心技术解构

### 1. `BufferedAction:GetActionString` 瞬时切面与上下文生命周期
- **痛点**：若修改实体的 `GetDisplayName`，会导致 `ThePlayer.components.talker:Say("I killed a "..target:GetDisplayName())` 变成 `"I killed a Spider <0/100>"`，极其突兀。
- **解法**：通过上下文标记控制瞬时重写：
  ```lua
  local SHOULD_OVERWRITE_ACTION = nil

  InjectFull(controller, "GetLeftMouseAction", function(lmb)
      if lmb and not (lmb.target and lmb.invobject == nil and lmb.target ~= lmb.doer) then
          -- 标记当前动作需要注入血量
          SHOULD_OVERWRITE_ACTION = true
      end
      return lmb
  end)

  InjectFull(_G.BufferedAction, "GetActionString", function(str, self)
      if SHOULD_OVERWRITE_ACTION then
          if self.target and DISABLE_HELATHINFO_RECURSIVE == 0 then
              if TheNet ~= nil and self.target.health_info then
                  str = t.AddString(str, self.target.health_info, self.target.health_info_max)
              end
          end
          -- 消费后立即置空，杜绝状态污染！
          SHOULD_OVERWRITE_ACTION = nil
      end
      return str
  end)
  ```
  只有当鼠标悬浮并生成交互指令提示词的一瞬间，血量才会附加在动词之后，鼠标划开后状态瞬间归零。

### 2. 双端网络轻量同步（`net_ushortint` 优化）
- 在 DST 服务端：
  - 对白名单生物挂载微型网络分类器，将当前血量与最大血量通过 `net_ushortint` 压缩广播；
  - 客户端监听到变化后，直接存入实体的 `inst.health_info` 临时字段；
  - 客户端在无需实例化完整 `health` 组件的情况下，毫秒级读取权威生命值。

### 3. 正则反向剪裁器（`CUT_PATTERN`）
- 考虑到部分其他 UI 模组或官方代码可能会二次捕获处理该动作文本，MOD 提供了强悍的正向构造器与反向剔除正则：
  ```lua
  local type_patterns = { "%d+%%", "%d+ / [?%d]+ %d+%%", "%d+ %(±%d+%%%)" }
  type_patterns[0] = "%d+ / [?%d]+"
  local CUT_PATTERN = "^(.*) " .. (ds ~= "" and "%" .. ds or "") .. tostring(type_patterns[show_type]) .. (de ~= "" and "%" .. de or "") .. "$"
  ```
  外部模组调用 `string.match(str, CUT_PATTERN)` 可以毫秒级剥离出纯净的原始动作名，展现了教科书级的 API 开放与兼容性思维。

### 4. 浮动公差与模糊血量（Chance Fluctuation Engine）
- 为满足硬核受苦玩家的拟真需求，MOD 支持 `random_health_value`（如 $\pm 10\%$ 模糊显示）：
  通过正弦与哈希种子对实体当前生命值进行微量扰动，呈现为 `<90 (±10%)>`，既提供了信息参考，又保留了战斗悬念。

---

## 三、避坑实战经验

1. **`GetActionString` 拦截必须清理逃逸分支**：
   - 如果玩家右键点击取消动作，或者在 `GetLeftMouseAction` 触发后没有实际执行动作，`SHOULD_OVERWRITE_ACTION` 可能会遗留在上下文里，导致下一次无关操作（如打开箱子）误带上前一个怪物的血量。
   - **防御手段**：必须在 `GetRightMouseAction` 与 `DoAction` 中无条件执行 `SHOULD_OVERWRITE_ACTION = nil`，确保每一次动作生命周期严格闭环。
2. **黑名单过滤性能收益**：
   - 饥荒世界中存在成千上万个不需要显示血量的装饰实体（草屑、脚印、粒子发射器）。若对每个实体都跑一遍 Tag 检索，会严重消耗帧时间。先查哈希表 `BLACK_FILTER_CACHED[prefab]` 是工业级模组保证 60 帧满帧运行的关键基石。
