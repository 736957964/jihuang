# Inventory 物品栏组件

> 源码: `scripts/components/inventory.lua`

## 概述

Inventory 组件管理实体的物品栏系统，包括物品槽位、装备槽位、活跃物品、容器交互、物品拾取/丢弃/给予等核心功能。所有玩家和可携带物品的实体都需要此组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `maxslots` | number | `GetMaxItemSlots()` | 最大物品槽位数（取决于游戏模式） |
| `itemslots` | table | `{}` | 物品槽位表 `{[slot_num]=item}` |
| `equipslots` | table | `{}` | 装备槽位表 `{[EQUIPSLOTS.XXX]=item}` |
| `activeitem` | Entity | `nil` | 当前活跃物品（手持/使用中） |
| `isopen` | boolean | `false` | 物品栏是否打开 |
| `isvisible` | boolean | `false` | 物品栏是否可见 |
| `acceptsstacks` | boolean | `true` | 是否接受堆叠 |
| `ignorescangoincontainer` | boolean | `false` | 是否忽略容器进入限制 |
| `dropondeath` | boolean | `true` | 死亡时是否掉落物品 |
| `heavylifting` | boolean | `false` | 是否在搬运重物 |
| `floaterheld` | boolean | `nil` | 是否持有漂浮物 |
| `opencontainers` | table | `{}` | 打开的容器列表 |
| `opencontainerproxies` | table | `{}` | 打开的容器代理列表 |

### 行为标志

| 属性名 | 说明 |
|--------|------|
| `ignoreoverflow` | 忽略溢出 |
| `ignorespoverflow` | 忽略特殊溢出 |
| `ignoreclosedspoverflow` | 忽略已关闭特殊溢出 |
| `ignorefull` | 忽略物品栏满 |
| `silentfull` | 静默物品栏满 |
| `ignoresound` | 忽略音效 |
| `ignorecombat` | 忽略战斗（跳过护甲减免） |
| `thiefproof` | 防偷窃 |
| `force_no_insulation` | 强制不绝缘（电击） |
| `noheavylifting` | 禁止搬运重物 |

### SourceModifierList

| 属性名 | 说明 |
|--------|------|
| `isexternallyinsulated` | 外部绝缘状态（布尔叠加） |

## 方法

### 物品查询

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `NumItems()` | number | 物品槽位中物品数量 |
| `NumStackedItems()` | number | 物品槽位中堆叠后总数量 |
| `GetNumSlots()` | number | 获取最大槽位数 |
| `GetActiveItem()` | Entity/nil | 获取当前活跃物品 |
| `GetItemInSlot(slot)` | Entity/nil | 获取指定槽位物品 |
| `GetEquippedItem(eslot)` | Entity/nil | 获取指定装备槽物品 |
| `GetFirstItemInAnySlot()` | Entity/nil | 获取第一个槽位物品 |
| `GetItemSlot(item)` | number/nil | 获取物品所在槽位号 |
| `IsHolding(item, checkcontainer)` | boolean | 是否持有某物品 |
| `IsItemEquipped(item)` | boolean | 某物品是否已装备 |
| `HasAnyEquipment()` | boolean | 是否有任何装备 |
| `IsWearingArmor()` | boolean | 是否穿戴护甲 |
| `ArmorHasTag(tag)` | boolean | 护甲是否有某标签 |
| `EquipHasTag(tag)` | boolean | 任意装备是否有某标签 |
| `EquipHasSpDefenseForType(sptype)` | boolean | 装备是否有某特殊防御 |
| `IsHeavyLifting()` | boolean | 是否搬运重物 |
| `IsFloaterHeld()` | boolean | 是否持有漂浮物 |
| `AcceptsStacks()` | boolean | 是否接受堆叠 |
| `IgnoresCanGoInContainer()` | boolean | 是否忽略容器限制 |
| `IsThiefProof()` | boolean | 是否防偷窃 |
| `FindItem(fn)` | Entity/nil | 查找第一个匹配物品 |
| `FindItems(fn)` | table | 查找所有匹配物品 |
| `ForEachItem(fn, ...)` | — | 遍历所有物品槽物品 |
| `ForEachEquipment(fn, ...)` | — | 遍历所有装备 |
| `ForEachItemSlot(fn, ...)` | — | 遍历所有物品槽 |
| `ForEachWetableItem(fn, ...)` | — | 遍历所有可潮湿物品 |

### 物品操作

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `GiveItem(item, slot, src_pos, check_full)` | boolean | 将物品放入物品栏 |
| `RemoveItemBySlot(slot, keepoverstacked)` | Entity/nil | 从槽位移除物品 |
| `DropItem(item, wholestack, randomdir, pos, keepoverstacked)` | Entity/nil | 丢弃物品到世界 |
| `DropEverything(with_active, randomdir, keepequip, keepitem)` | — | 丢弃所有物品 |
| `TakeItemInSlot(slot, src_pos, src_inv)` | — | 从指定槽位拿取物品 |
| `GiveActiveItem(item, slot)` | — | 设置活跃物品 |
| `SetActiveItem(item)` | — | 设置活跃物品 |
| `DropActiveItem()` | Entity/nil | 丢弃活跃物品 |
| `ReturnActiveItem(slot, stack_mod)` | — | 归还活跃物品到物品栏 |
| `ReturnActiveActionItem(item, instant)` | — | 归还活跃动作物品 |
| `SelectActiveItemFromSlot(slot)` | — | 从槽位选择活跃物品 |
| `SelectActiveItemFromEquipSlot(slot)` | — | 从装备槽选择活跃物品 |
| `CombineActiveStackWithSlot(slot, stack_mod)` | — | 活跃物品与槽位堆叠合并 |

### 装备操作

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Equip(item, old_to_active)` | boolean | 装备物品 |
| `Unequip(eslot, slip, force)` | Entity/nil | 卸下装备 |
| `SwapEquipment(other, equipslot_to_swap, force)` | boolean | 与另一实体交换装备 |

### 容器操作

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `OpenContainer(container, ...)` | — | 打开容器 |
| `CloseContainer(container)` | — | 关闭容器 |
| `IsOpened(container)` | boolean | 容器是否已打开 |

### 伤害与防御

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `ApplyDamage(damage, attacker, weapon, spdamage)` | damage, spdamage | 应用伤害减免（护甲+防具） |
| `IsInsulated()` | boolean | 是否电击绝缘 |

### 其他

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `CanTakeItemInSlot(item, slot)` | boolean | 物品能否放入指定槽位 |
| `TransferInventory(receiver)` | — | 转移物品栏到另一实体 |
| `EnableDropOnDeath()` | — | 启用死亡掉落 |
| `DisableDropOnDeath()` | — | 禁用死亡掉落 |
| `ForceNoInsulated(force)` | — | 强制不绝缘 |
| `OnSave()` | data, references | 保存数据 |
| `OnLoad(data, newents)` | — | 加载数据 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `death` | 死亡（自动掉落物品） | — |
| `player_despawn` | 玩家消失 | — |

## 使用示例

```lua
-- 给予物品
local sword = SpawnPrefab("spear")
if inst.components.inventory:GiveItem(sword) then
    print("武器已放入物品栏")
end

-- 装备物品
local hat = SpawnPrefab("strawhat")
if inst.components.inventory:Equip(hat) then
    print("帽子已装备")
end

-- 获取装备
local body_armor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)

-- 获取手持物品
local active = inst.components.inventory:GetActiveItem()

-- 卸下装备
local old_hat = inst.components.inventory:Unequip(EQUIPSLOTS.HEAD)

-- 丢弃物品
inst.components.inventory:DropItem(sword)

-- 查找物品
local food = inst.components.inventory:FindItem(function(item)
    return item.components.edible ~= nil
end)

-- 查找所有特定prefab
local gems = inst.components.inventory:FindItems(function(item)
    return item.prefab == "redgem"
end)

-- 禁用死亡掉落
inst.components.inventory:DisableDropOnDeath()

-- 防止偷窃
inst.components.inventory.thiefproof = true

-- 打开容器
inst.components.inventory:OpenContainer(chest)
inst.components.inventory:CloseContainer(chest)
```

## 物品栏操作流程

### GiveItem 流程
1. 检查 `item` 是否有效且有 `inventoryitem` 组件
2. 检查是否能堆叠到已有物品上（`stackable`）
3. 查找空槽位
4. 将物品放入 `itemslots[slot]`
5. 设置物品父实体和所有者
6. 推送相关事件

### DropItem 流程
1. 从 `itemslots` 或 `equipslots` 移除
2. 如果 `wholestack`，丢弃整个堆叠
3. 在世界中生成物品
4. 设置位置（随机偏移或指定位置）

### ApplyDamage 伤害减免流程
1. 遍历所有装备，收集有 `armor` 组件的
2. 对每个护甲：检查 `CanResist` → `GetAbsorption` → 计算减免
3. 扣护甲耐久 `TakeDamage`
4. 应用特殊防御 `SpDamageUtil`
5. 返回减免后的伤害
