# 饥荒创意工坊深度研读报告：Island Adventures（海难/热带群岛工业级移植）

- **模组标识**：`1467214795` (`Island Adventures - Shipwrecked / 岛屿冒险`)
- **作者阵容**：The Island Adventures Team
- **版本**：v1.0.63
- **领域分类**：超大型 DLC 工业级重构移植、跨陆海交互距离预测补偿（Shore-Ocean Arrive Dist）、闭包深度穿透黑客（UpvalueHacker）、水体世界地块与音效重映射
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 200MB 全量生态资产、核心路由架构与 Upvalue 工具库）

---

## 一、架构全貌与顶层设计思想

`Island Adventures` 是饥荒联机版工坊最具技术野心与工程深度的全量 DLC 移植项目。它将单机版《海难（Shipwrecked）》完整的海洋群岛生态、造船航行、热带季节与火山机制，**完全按照联机版的主客机双端预测规范**重写了一遍。

### 1. 为什么它是工业级教科书？
- 传统小 Mod 往往通过暴力覆盖函数或替换官方预制体来实现功能，极易导致与其他 Mod 冲突。
- `Island Adventures` 坚持**非破坏性接入（Non-destructive Injection）**：无论是地皮定义、航行动作、生物 AI 还是海岸交互，全部采用模块化分流（`main/actions`, `main/componentactions`, `main/postinit`），并基于闭包嗅探工具动态注入，展现了当代饥荒 Modding 的巅峰工程水准。

---

## 二、四大硬核核心技术解构

### 1. 海陆边缘交互距离动态补偿（Shore-Ocean Arrive Dist Compensation）
- **痛点**：在联机版中，玩家站在陆地上想要采集海里的青口贝（Mussel Farm）或用竹竿刺鱼时，饥荒底层 Locomotor 移动器会判定目标位于不可行走的海洋地皮（Ocean Tile），导致角色在海边无限原地踱步打转，无法触发交互。
- **解法**：在 `ACTIONS.PICK.extra_arrive_dist` 与自定义 `STICK` 动作中注入动态海岸判决：
  ```lua
  local function IsTargetOnShoreFromDoer(doer, target_x, target_y, target_z)
      return TheWorld.Map:IsOceanTileAtPoint(target_x, 0, target_z)
          and not TheWorld.Map:IsPassableAtPoint(target_x, 0, target_z)
          and doer:IsOnPassablePoint()
  end
  ```
  当且仅当“执行者在陆地可通行点、目标在不可通行的海洋地块”时，动态返还额外的交互距离 `0.5 + distance` 或 `1.5`，完美解决了跨海陆交互的卡死难题！

### 2. 多层嵌套闭包嗅探与修改器（Upvalue Hacker）
官方原版许多核心逻辑（例如官方组件的内部局部变量、状态机内的局部事件）被封装在局部函数（Upvalue）中，官方没有暴露全局接口。
- **IAUpvalueHacker 实现精髓**：
  结合 `debug.getupvalue` 与 `debug.setupvalue`，实现了**带源码路径正则过滤与递归防循环遍历（Cycle-Free Recursive Upvalue Search）**：
  ```lua
  IAUpvalueHacker.FindUpvalue(fn, name, fnfile, valuefile)
  ```
  能够沿着函数指针深度向下追溯 3~5 层闭包，在不篡改原版全局引用的情况下，精准捕获并热替换深层核心变量，达成最高级别的兼容性。

### 3. 世界地皮与全量音效重映射（World Tile & Sound Remapping）
- 引入 `tiledefs_util` 动态扩展海难专属地皮（沙滩 Sand、石板 Slate、岩浆等），配合 `RemapSoundEvent`：
  ```lua
  RemapSoundEvent("dontstarve/movement/ia_run_sand", "ia/movement/walk_sand")
  ```
  在不碰触引擎物理核心的前提下，为联机版赋予了全新的脚步与环境音效体验。

### 4. 跨 MOD 协议契约（Insight Compat）
- 自带 `main/insight_compat.lua`，为主流信息显示 Mod（Insight）暴露海难专属实体的特殊数据槽（如火山活跃度、章鱼王贡品计数），树立了社区大型 Mod 间互相尊重的良好协作范本。

---

## 三、避坑实战经验

1. **热重载（HotReloading）环境下的 Action 重复注册保护**：
   - 调试大型 Mod 时经常触发代码热重载。如果直接无脑调用 `AddAction(ACTION)`，会导致引擎报 Action ID 重复注册的致命错误。必须像海难工程一样做防御：
     ```lua
     local is_reloading = rawget(_G, "HotReloading")
     if not is_reloading then
         IAENV.AddAction(ACTION)
     end
     ```
2. **`extra_arrive_dist` 的链式传递**：
   - 扩展已有动作（如 `ACTIONS.PICK`）的到达距离时，切忌直接覆盖返回值！必须先缓存 `local _PICKextra_arrive_dist = ACTIONS.PICK.extra_arrive_dist`，并在回调中优先合并前一个 Mod 赋予的距离，否则会导致农场自动采集类 Mod 彻底失效。
