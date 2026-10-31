# 饥荒创意工坊深度研读报告：Increased Stack Size（堆叠上限调整与全局切面）

- **模组标识**：`374550642` (`Increased Stack Size / 堆叠上限调整`)
- **作者**：ChaosMind42
- **版本**：v2.3
- **领域分类**：全局 TUNING 常量注入、`AddPrefabPostInitAny` 全预制体切面、`stackable` 组件动态分级映射、服务端权威防崩
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 `modmain.lua` 与完整配置表）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，背包空间极其紧张。修改堆叠数量看似简单，但市面上大量劣质 Mod 往往直接粗暴地把所有物品一律写死为 999，导致官方原生设计为单体或小堆叠的物品（如某些特定微型颗粒 Pellet、大件原木 Large Item、中件蔬菜 Medium Item）比例失调，甚至引发其他 Mod 自定义容器的容量溢出。

`Increased Stack Size` 的工业级设计精髓在于：**严格遵循官方五级梯队（Large / Medium / Small / Tiny / Pellet）分层映射**，并提供了**静默 Tuning 注入**与**`AddPrefabPostInitAny` 动态强改（Force Overwrite）**两种运行模式。

---

## 二、四大硬核核心技术解构

### 1. 五级梯队分层映射模型（Five-Tier Stack Hierarchy）
饥荒官方底层将可堆叠物品划分为五个严格层级：
1. `STACK_SIZE_LARGEITEM`：大尺寸物品（原版默认 10）
2. `STACK_SIZE_MEDITEM`：中尺寸物品（原版默认 20）
3. `STACK_SIZE_SMALLITEM`：小尺寸物品（原版默认 40）
4. `STACK_SIZE_TINYITEM`：微小尺寸物品（原版默认 60）
5. `STACK_SIZE_PELLET`：球团颗粒类（原版默认 120）

MOD 在启动阶段优先重写 `TUNING` 常量表：
```lua
TUNING.STACK_SIZE_LARGEITEM = NEW_STACK_VALUES[1]
TUNING.STACK_SIZE_MEDITEM   = NEW_STACK_VALUES[2]
TUNING.STACK_SIZE_SMALLITEM = NEW_STACK_VALUES[3]
TUNING.STACK_SIZE_TINYITEM  = NEW_STACK_VALUES[4]
TUNING.STACK_SIZE_PELLET    = NEW_STACK_VALUES[5]
```
这种方式是**最高效、侵入性最低的**，凡是按照官方规范在 Prefab 中书写 `inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM` 的物品，在初始化时自动吃到新配置，无需额外的运行时 Hook 开销！

### 2. `AddPrefabPostInitAny` 与非标物品区间逼近算法（Interval Approximation）
- **痛点**：大量第三方 Mod 开发者没有使用 `TUNING` 常量，而是在自己的 Prefab 里硬编码写死了 `inst.components.stackable.maxsize = 20` 或 `50`。
- **解法**：开启 `FORCE_STACKSIZES` 后，MOD 注册了 `AddPrefabPostInitAny`：
  ```lua
  AddPrefabPostInitAny(function(inst)
      if not GLOBAL.TheWorld.ismastersim then return end
      local s = inst.components.stackable
      if s == nil then return end
      -- 智能映射算法
      local newSize = getNewStackSize(currentSize, currentStackValues)
      if newSize and newSize ~= currentSize then
          s.maxsize = newSize
      end
  end)
  ```
  在 `getNewStackSize` 中：
  - 若刚好等于旧版某个档位（10/20/40/60/120），精准替换为对应新档位；
  - 若为非标数字，采用区间单调逼近（`if size <= v then return v end`），将其平滑映射到最贴合的容量区间，避免极端畸变。

### 3. 主客机环境隔离（Master Sim Guard）
- 修改组件的 `maxsize` 属于世界权威状态（Authoritative State）。在 `AddPrefabPostInitAny` 第一行必须严格校验：
  ```lua
  if not GLOBAL.TheWorld.ismastersim then return end
  ```
  客机只需要通过 `replica.stackable` 接收网络同步的堆叠数与槽位显示，绝对禁止在客机重复执行修改。

### 4. 配置健壮性断言防御（Config Assertion）
在从用户配置获取输入时，MOD 加入了严密的断言：
```lua
assert(type(v) == "number", "Stack config value is not a number")
assert(v >= 1, "Stack config value must be >= 1")
```
防止玩家误填非数字或小于 1 的数值导致引擎除以零崩溃。

---

## 三、避坑实战经验

1. **`AddPrefabPostInitAny` 的性能损耗防范**：
   - `AddPrefabPostInitAny` 会在全图每一个实体生成时触发（每分钟成百上千次）。回调内部的第一句必须是 `local s = inst.components.stackable if s == nil then return end`，快速短路返回，严禁在无 stackable 组件的实体上执行复杂的正则或表遍历。
2. **已有存档中已存在物品的兼容性**：
   - 修改 `s.maxsize` 只会影响后续堆叠合并与新生成的物品。若原地上已有堆叠超过旧上限的物品，引擎在拆分时会自动按新上限处理，不会导致坏档。
