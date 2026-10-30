# 饥荒一线工坊深度研读 Skill：Extra Equip Slots 槽位扩展与网络数据同构机制

- **工坊 ID**：375850593 (`Extra Equip Slots`)
- **领域分类**：网络同步实体侵入式扩展、Replica 客户端预测、`inventory_classified` 缓存重写、HUD 物品栏布局自适应
- **研读源码**：`modmain.lua`

---

## 一、核心实现原理与硬核突破点

原版饥荒联机版的装备槽位被严格写死在 `EQUIPSLOTS = { HANDS="hands", HEAD="head", BODY="body" }`。要在多人联机下扩展出 **BACK（背包槽）** 与 **NECK（护符/项链槽）**，绝不仅仅是加两张贴图，而是必须攻破以下底层难关：

### 1. 全局枚举与 ID 双射重建
- 饥荒底层的 RPC 与网络实体传输装备槽位时，大量依赖 `EQUIPSLOT_IDS` 映射整数 ID。
- 该 MOD 动态重新遍历 `GLOBAL.EQUIPSLOTS`：
  ```lua
  GLOBAL.EQUIPSLOTS = {
      HANDS = "hands",
      HEAD = "head",
      BODY = "body",
      BACK = "back",
      NECK = "neck",
  }
  GLOBAL.EQUIPSLOT_IDS = {}
  local slot = 0
  for k, v in pairs(GLOBAL.EQUIPSLOTS) do
      slot = slot + 1
      GLOBAL.EQUIPSLOT_IDS[v] = slot
  end
  ```

### 2. 重生判定拦截（resurrectable 组件复写）
- 原版重生护符（Amulet）复活逻辑写死在判定 BODY 槽位。扩展后，护符被移至 NECK 槽。
- MOD 精准 Hook 了 `resurrectable` 的 3 大关键函数：
  - `FindClosestResurrector`: 增加判定 `inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)`
  - `CanResurrect`: 同样放行 NECK 槽上的 amulet
  - `DoResurrect`: 触发玩家状态机直接切入 `amulet_rebirth` 并在服务端重塑实体。

### 3. `inventory_classified` 客户端预测与溢出容器（Overflow）重定向
- **联机版最大痛点**：客户端背包栏能够看到背包装备在独立槽位，但制作配方时，配方检查逻辑（`inventory:Has(...)`）是由专属网络实体 `inventory_classified` 在客户端独立维护和计算的！如果不改写 `inventory_classified`，玩家背着背包做东西，制作栏会判定材料不足！
- **MOD 解法**：通过 `AddPrefabPostInit("inventory_classified", function(inst) ... end)` 拦截 `Has(inst, prefab, amount)`。
  - 获取 `overflow = GetOverflowContainer(inst)`。
  - 将 `BACK` 槽所携带的容器物品实时并入客户端拥有的材料总量计算中（`count = count + overflowcount`）。

### 4. `widgets/inventorybar` 的双端自适应排版数学计算
- 不定长装备槽位与检查按钮（Inspect Control）的坐标排布具有极高数学美感：
  ```lua
  local W = 68
  local SEP = 12
  local INTERSEP = 28
  local inventory = self.owner.replica.inventory
  local num_slots = inventory:GetNumSlots()
  local num_equip = #self.equipslotinfo
  local num_buttons = self.controller_build and 0 or 1
  local num_slotintersep = math.ceil(num_slots / 5)
  local num_equipintersep = num_buttons > 0 and 1 or 0
  local total_w = (num_slots + num_equip + num_buttons) * W 
      + (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP 
      + (num_slotintersep + num_equipintersep) * INTERSEP
  ```
  精准计算出在不同手柄/键鼠配置下总宽度，并将自检按钮居中在最右侧 `(total_w - W) * .5 + 3`。

---

## 二、标准化生产级代码范式

```lua
-- ==============================================================================
-- 范式：跨端背包槽位安全扩展与制作栏数据预测同步
-- ==============================================================================

-- 1. 扩展全局槽位枚举
GLOBAL.EQUIPSLOTS.BACK = "back"
GLOBAL.EQUIPSLOTS.NECK = "neck"
GLOBAL.EQUIPSLOT_IDS = GLOBAL.EQUIPSLOT_IDS or {}
local id = 0
for _, slotName in pairs(GLOBAL.EQUIPSLOTS) do
    id = id + 1
    GLOBAL.EQUIPSLOT_IDS[slotName] = id
end

-- 2. 服务端 Inventory 溢出容器定向
AddComponentPostInit("inventory", function(self, inst)
    local old_GetOverflowContainer = self.GetOverflowContainer
    self.GetOverflowContainer = function(self)
        if self.ignoreoverflow then return nil end
        -- 优先判定新 BACK 槽中的背包
        local item = self:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
        if item ~= nil and item.components.container ~= nil then
            return item.components.container
        end
        return old_GetOverflowContainer(self)
    end
end)

-- 3. 客户端 inventory_classified 材料检测补丁
AddPrefabPostInit("inventory_classified", function(inst)
    local old_Has = inst.Has
    inst.Has = function(self, prefab, amount)
        local has, count = old_Has(self, prefab, amount)
        if has then return true, count end

        -- 如果主背包材料不够，继续跨入 BACK 槽容器检索
        local backItem = self:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
        local overflow = backItem ~= nil and backItem.replica.container or nil
        if overflow ~= nil then
            local oHas, oCount = overflow:Has(prefab, amount - count)
            count = count + oCount
            return count >= amount, count
        end
        return false, count
    end
end)
```

---

## 三、踩坑与避错指南

1. **`inventory_classified` 只能在客户端读取 Replica**：
   - 绝不要在 `inventory_classified` 内部尝试读取 `item.components.container`，因为非主机客户端上 `components` 为 nil，必须统一读取 `item.replica.container`！
2. **护符消耗状态机动画必须双端匹配**：
   - 触发复活时，原版是走 `amulet_rebirth` state。调用 `inst.sg:GoToState("amulet_rebirth")` 前必须确认服务端与客户端都存在该 state，否则角色会变成无动作 T-pose 漂移。
