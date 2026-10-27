# Equippable 可装备组件

> 源码: `scripts/components/equippable.lua`

## 概述

Equippable 管理物品的装备/卸下行为，包括装备槽位、行走速度、精神值加成、防水值等。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `isequipped` | boolean | `false` | 是否已装备 |
| `equipslot` | number | `EQUIPSLOTS.HANDS` | 装备槽位 |
| `onequipfn` | function/nil | `nil` | 装备时回调 |
| `onunequipfn` | function/nil | `nil` | 卸下时回调 |
| `onpocketfn` | function/nil | `nil` | 放入口袋时回调 |
| `equipstack` | boolean | `false` | 是否装备整堆物品 |
| `walkspeedmult` | number | `1` | 行走速度倍率 |
| `dapperness` | number | `0` | 精神值加成（静态值） |
| `dapperfn` | function/nil | `nil` | 精神值加成（动态函数） |
| `insulated` | boolean | `false` | 是否电绝缘 |
| `equippedmoisture` | number | `0` | 当前装备防水值 |
| `maxequippedmoisture` | number | `0` | 最大装备防水值 |
| `preventunequipping` | boolean | `false` | 是否阻止卸下 |
| `restrictedtag` | string/nil | `nil` | 限制只有特定tag实体可装备 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetOnEquip(fn)` | — | 设置装备回调 |
| `SetOnUnequip(fn)` | — | 设置卸下回调 |
| `SetOnPocket(fn)` | — | 设置口袋回调 |
| `SetDappernessFn(fn)` | — | 设置动态精神值计算函数 |
| `IsInsulated()` | boolean | 是否电绝缘 |
| `Equip(owner)` | — | 装备 |
| `Unequip(owner)` | — | 卸下 |
| `GetEquippedMoisture()` | number | 获取装备防水值 |
| `GetMaxEquippedMoisture()` | number | 获取最大防水值 |
| `SetWalkSpeedMult(mult)` | — | 设置行走速度倍率 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 事件

装备和卸下通过 `onequipfn` / `onunequipfn` 回调触发，不直接推送事件。

## 槽位常量

| 常量 | 说明 |
|------|------|
| `EQUIPSLOTS.HANDS` | 手部 |
| `EQUIPSLOTS.HEAD` | 头部 |
| `EQUIPSLOTS.BODY` | 身体 |
| `EQUIPSLOTS.NECK` | 颈部 |
| `EQUIPSLOTS.FACE` | 面部 |
| `EQUIPSLOTS.FEET` | 脚部 |

## 使用示例

### 基础装备物品

```lua
inst:AddComponent("equippable")
inst.components.equippable.equipslot = EQUIPSLOTS.HEAD  -- 头部装备
inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED  -- 精神值加成
```

### 装备/卸下回调

```lua
inst:AddComponent("equippable")
inst.components.equippable:SetOnEquip(function(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_myitem", "swap_hat")
    owner.components.combat.damagemultiplier = 1.5  -- 装备时伤害+50%
end)

inst.components.equippable:SetOnUnequip(function(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.components.combat.damagemultiplier = 1.0  -- 卸下时恢复
end)
```

### 动态精神值

```lua
inst.components.equippable:SetDappernessFn(function(inst, owner)
    return owner.components.sanity:GetPercent() < 0.3 and TUNING.DAPPERNESS_HUGE or 0
    -- 理智低于30%时大幅增加精神值
end)
```

### 防水装备

```lua
inst:AddComponent("equippable")
inst.components.equippable.equippedmoisture = 0.6  -- 60%防水
inst.components.equippable.maxequippedmoisture = 0.6
```

### 行走速度加成

```lua
inst:AddComponent("equippable")
inst.components.equippable.walkspeedmult = 1.25  -- 行走速度+25%
```

### 阻止卸下

```lua
inst.components.equippable.preventunequipping = true
-- 玩家无法主动卸下此装备（如诅咒物品）
```

### 限制装备者

```lua
inst.components.equippable.restrictedtag = "mycharacter"
-- 只有携带 "mycharacter" 标签的角色才能装备
```
