# 饥荒创意工坊深度研读报告：45 Inventory Slots（物品栏底层插槽拓扑扩容与双排布局重构）

- **模组标识**：`786556008` (`45 Inventory Slots`)
- **作者**：fmo080308
- **版本**：v1.4.1
- **领域分类**：全端联机模组（`all_clients_require_mod = true`）、`inventory_classified` 网络实体同步变长扩展（`net_entity` 动态注册）、`inventorybar` 双排分层排版重构、`makereadonly` 官方安全沙盒规避
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与多层物品栏 UI 贴图）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版（DST）中，玩家原生背包槽位被固化为 15 格（单排横向排列）。直接粗暴修改 `MAXITEMSLOTS` 常量会导致大量联机崩溃或客机同步失败：
1. **网络同步断裂**：官方客户端与服务端依赖 `inventory_classified` 预先分配的网络同步实体列表（`_items`），超出 15 格的物品在客机上完全不可见、无法交互；
2. **只读保护报错**：官方引擎在 `inventory._ctor` 中对 `maxslots` 实施了 `makereadonly(self, "maxslots")` 严格保护；
3. **UI 溢出穿屏**：单排横向排列若扩容至 45 格，物品栏将直接横跨两倍屏幕宽度，遮挡侧边与主界面。

`45 Inventory Slots` 是饥荒工坊中**物品栏架构重构（Inventory Architecture Rework）的集大成者**：
- **网络实体拓扑补全**：动态为 `inventory_classified` 追加网络变量 `net_entity`，打通超长槽位的客机双向同步管道；
- **分层双排矩阵布局（Dual-Row Layout Matrix）**：将 45 个格子自适应切分为 `toprow` 与 `bottomrow`，并重构九宫切片背景（`ThreeSlice`）；
- **背包与主包平铺兼容**：在扩容 45 格的同时完美保持玩家背包装备（Backpack）的悬停、存取与独立栏位监听。

---

## 二、四大硬核核心技术解构

### 1. `inventory_classified` 动态网络变量扩展（Net Entity Expansion）
- **底层痛点**：原生 `inventory_classified.lua` 只注册了 15 个 `net_entity`。如果服务端强行往第 16~45 槽位塞入物品，客户端由于没有对应的网络变量句柄，无法监听 `items[i]dirty` 事件，造成客户端严重幽灵物品。
- **解法**：在 `inventory_classified` 预制体初始化切面中实施动态增量补齐：
  ```lua
  local function addItemSlotNetvarsInInventory(inst)
      if (#inst._items < MAXITEMSLOTS) then
          for i = #inst._items + 1, MAXITEMSLOTS do
              -- 动态构建标准网络变量实体，绑定专属 dirty 监听标识
              table.insert(inst._items, net_entity(inst.GUID, "inventory._items[" .. tostring(i) .. "]", "items[" .. tostring(i) .. "]dirty"))
          end
      end
  end
  AddPrefabPostInit("inventory_classified", addItemSlotNetvarsInInventory)
  ```
  这一步彻底打通了任意槽位数量（25、45 乃至 99）的客机网络同步生命线！

### 2. 规避官方只读安全沙盒（`makereadonly` Bypass）
- 官方在 `inventory:ctor` 执行后，会针对 `maxslots` 加上 `makereadonly` 保护，后续任何赋值都会抛出 `attempt to modify a readonly table`。
- MOD 采取在 `inventory._ctor` 构造函数执行阶段实施劫持，在官方施加只读锁之前，先一步将 `self.maxslots` 赋值为用户配置的槽位值（15 / 25 / 45），随后再让官方调用 `makereadonly`，合法合规地锁死新上限！

### 3. 双排式 UI 视口矩阵排版（Dual-Row Inventory Matrix）
- 45 个格子若横向单行排列将超出屏幕边界。MOD 在 `inventorybar:Rebuild` 中重构出分行容器：
  ```lua
  self.toprow = self.root:AddChild(Widget("toprow"))
  self.bottomrow = self.root:AddChild(Widget("bottomrow"))
  self.bottomrow:SetPosition(0, - W - SEP, 0)
  ```
  通过等分除法将前半部分格子放入上排，后半部分放入下排，居中对齐，并在底层垫上自适应拉伸的九宫格贴图（`ThreeSlice`），兼顾美观与操作效率。

### 4. 背包容器（Backpack）事件代理与无缝衔接
- 解决了大容量主包开启时，穿戴背包物品栏错位的问题。MOD 监听 `BackpackGet` 与 `BackpackLose`，将玩家身上的背包装备物品栏无缝拼接在双排物品栏的右翼或独立挂架上，不破坏原版的背包交互手感。

---

## 三、避坑实战经验

1. **`all_clients_require_mod = true` 强制联机同步**：
   - 此类重构底层网络实体（`net_entity`）的 Mod，客户端与服务端必须拥有完全相同的槽位数量配置。如果客机没有安装该 Mod，客机进入游戏时由于反序列化网络包长度不匹配，会立即崩溃断开连接。
2. **`inventory_replica:GetNumSlots` 同步重写**：
   - 客户端大量 UI（如动作指示、制造栏材料检查）不直接读服务端 `inventory`，而是读取 `inst.replica.inventory:GetNumSlots()`。必须同步拦截重写该接口返回新的 `MAXITEMSLOTS`，否则制作栏在判定材料时只会检查前 15 格！
