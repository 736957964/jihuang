# 饥荒创意工坊深度研读报告：Show Me（属性信息与实体嗅探）

- **模组标识**：`666155465` (`Show Me / 属性信息显伤`)
- **作者**：Star, +Serp
- **版本**：v0.58
- **领域分类**：服务端实体属性嗅探、紧凑 ASCII 字节编码网络协议、客机 Hoverer 动态字符串拦截、跨 Mod 生态自适应（Insight / Combined Status / Health Bar）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 1900+ 行 `modmain.lua` 与多语言切面文件）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，诸如“锅里正在煮什么、箱子里食物多久腐烂、生物当前血量/攻击力/仇恨值、装备剩余百分比”等数据，**全部严格封装在服务端的 components 中**。普通客户端在不作弊或无权限的情况下，鼠标悬停（Hover）只能看到原版的预制体名字，数据极度匮乏。

`Show Me` 作为统治饥荒社区近十年的神级信息 Mod，其核心成就不是简单的数值读取，而是设计了一套**高压缩率的单字节 ASCII 序列化网络通道**与**对 `widgets/hoverer` 的无侵入式切面拦截**，在保证极低网络带宽的前提下，向玩家端无缝传递了上百种复合实体状态！

---

## 二、四大硬核核心技术解构

### 1. 紧凑单字符 ASCII 协议与多态参数编码（Compact Byte-Packing Protocol）
- **痛点**：若服务端向客户端发送 JSON 或完整文本（例如 `"Damage: 68, Freshness: 98%"`），高频鼠标悬停会产生极其沉重的网络下行包，引发客机网络卡顿与服务器丢包。
- **神级解法**：自定义基于 ASCII 字符集的紧凑字典编码（`encodeFirstSymbol` 与 `decodeFirstSymbol`）：
  - 每一个属性类型对应一个唯一的单字节字符（如 `A` 代表 Armor、`D` 代表 Damage、`H` 代表 Health、`P` 代表 Perish 腐烂时间）；
  - 格式：`<HeaderChar><Param1>;<Param2>...`；
  - 字符 `@` 作为非格式化原始字串的转义符，`\2` 作为尾部信息隔离符。
  每个网络报文由数十字节直接缩减为 **4~8 个字节**，带宽利用率达到工业极致！

### 2. 客户端 Hoverer 切面拦截（Hover Text Interception）
- 原版饥荒客户端鼠标滑过实体时，由 `widgets/hoverer` 组件调用 `self.text:SetString(str)` 渲染提示。
- **Show Me 切面**：
  在客户端 Hook `Hoverer.OnUpdate` 或拦截 `self.text.SetString`：
  ```lua
  local old_SetString = self.text.SetString
  self.text.SetString = function(self, str, ...)
      -- 探测当前是否有待展示的 ShowMe 压缩报文
      -- 命中时将解码后的属性列表无缝拼接到名字下方
      local enhanced_str = DecodeAndAppendInfo(str)
      return old_SetString(self, enhanced_str, ...)
  end
  ```
  实现了客户端无论是否安装界面美化 Mod，均能零冲突浮动显示实体数据。

### 3. 全局生态互斥与智能退让（Mod Conflict Sniffing）
`Show Me` 内部构建了一套极其强大的 Mod 嗅探引擎（`GetAllModNames` 与 `SearchForModsByName`）：
- 检查是否存在 `Health Bar` 或 `Health Info`：若已存在专职血条 Mod，自动将 `need_send_hp` 置为 false，主动放弃血量字符串发送，杜绝信息叠层冗余；
- 检查是否存在 `Combined Status`：自动联动温度换算规则（`AOS_Temperature_fn`），支持华氏度/摄氏度的双向自动对齐。

### 4. 料理烹饪与作物压力综合诊断（CrockPot & Farm Plant Stress）
- 针对烹饪锅（`stewer`），服务端通过模拟配方判定（`cooking.recipes`）在锅盖盖上的瞬间，预先推算出成品质（如 `cookpot: "meatballs"`）；
- 针对联机版农场植物（Farm Plant），遍历其底层 7 种压力源 Tag（水分缺、养料缺、害虫、过度拥挤、非应季），直接转换成玩家看得懂的诊断建议。

---

## 三、避坑实战经验

1. **`Networking_Say` 与网络 RPC 的频次节流（Rate Limiting）**：
   - 鼠标悬停如果不断向服务端触发检查请求，会导致服务端 CPU 飙升。MOD 维护了客户端检查缓存 `target_cache` 与时间戳（TTL 0.5s），只有当鼠标真正静止在目标上超过阈值时才发起同步。
2. **多语言字串表的动态注入顺序**：
   - 多语言文件（如 `showme_chs.lua`）在注入时，不能直接改写 `MY_STRINGS` 的数组 key（因为网络解码依赖数字索引 `idx`）。只能重写内部的文本映射字段，否则会导致客机将“攻击力”错误翻译为“腐烂时间”。
