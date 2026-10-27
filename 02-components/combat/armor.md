# Armor 防具组件

> 源码: `scripts/components/armor.lua`

## 概述

Armor 组件赋予物品防具能力，控制伤害吸收率、耐久度、弱点/抗性等。穿戴此组件的物品被装备后可减免伤害。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `condition` | number | `100` | 当前耐久度 |
| `maxcondition` | number | `100` | 最大耐久度 |
| `absorb_percent` | number | `nil` | 伤害吸收百分比（0~1，如0.8=吸收80%） |
| `tags` | table | `nil` | 抵抗标签列表（仅当攻击者/武器有这些标签时才生效） |
| `weakness` | table | `nil` | 弱点表 `{[tag]=bonus_damage}` |
| `indestructible` | boolean | `nil` | 是否不可摧毁 |
| `conditionlossmultipliers` | SourceModifierList | — | 耐久损耗倍率列表 |
| `onfinished` | function | `nil` | 耐久耗尽回调 `fn(inst)` |
| `keeponfinished` | boolean | `nil` | 耐久耗尽后是否保留物品 |
| `ontakedamage` | function | `nil` | 受到伤害回调 `fn(inst, damage_amount)` |
| `onrepair` | function | `nil` | 修复回调 `fn(inst, amount)` |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `InitCondition(amount, absorb_percent)` | — | 初始化耐久和吸收率 |
| `InitIndestructible(absorb_percent)` | — | 初始化为不可摧毁 |
| `IsIndestructible()` | boolean | 是否不可摧毁 |
| `IsDamaged()` | boolean | 是否已损坏 |
| `GetPercent()` | number | 获取耐久百分比（0~1） |
| `GetAbsorption(attacker, weapon)` | number/nil | 获取实际吸收率（考虑tags匹配） |
| `SetAbsorption(absorb_percent)` | — | 设置吸收率 |
| `SetCondition(amount)` | — | 设置耐久度（0以下触发销毁） |
| `SetPercent(amount)` | — | 按百分比设置耐久 |
| `SetTags(tags)` | — | 设置抵抗标签 |
| `SetOnFinished(fn)` | — | 设置耐久耗尽回调 |
| `SetKeepOnFinished(keep)` | — | 设置耐久耗尽后是否保留 |
| `CanResist(attacker, weapon)` | boolean | 能否抵抗（tags匹配检测） |
| `AddWeakness(tag, bonus_damage)` | — | 添加弱点（tag=攻击者/武器标签） |
| `RemoveWeakness(tag)` | — | 移除弱点 |
| `GetBonusDamage(attacker, weapon)` | number | 获取弱点额外伤害 |
| `TakeDamage(damage_amount)` | — | 承受伤害（扣耐久） |
| `Repair(amount)` | — | 修复耐久 |
| `GetDebugString()` | string | 调试字符串 |
| `OnSave()` | table/nil | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `percentusedchange` | 耐久度变化时 | `{percent}` |
| `armordamaged` | 防具受损 | `damage_amount` |
| `armorbroke` | 防具破碎（由owner推送） | `{armor}` |

## 生命周期

| 回调 | 说明 |
|------|------|
| 构造函数 | 监听 `percentusedchange`，耐久归零且被装备时通知owner |

## 使用示例

### 基础防具

```lua
local function fn()
    local inst = CreateEntity()
    -- ... 基础设置 ...
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(315, 0.8)  -- 315耐久，吸收80%伤害
end
```

### 木甲（有标签抵抗）

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(315, 0.8)
    inst.components.armor:SetTags({"physical"})  -- 只抵抗物理攻击
end
```

### 有弱点的防具

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(500, 0.7)
    -- 被火焰攻击时额外承受50%伤害
    inst.components.armor:AddWeakness("fire", 0.5)
end
```

### 不可摧毁的防具

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("armor")
    inst.components.armor:InitIndestructible(0.9)  -- 吸收90%，永不损坏
end
```

### 耐久耗尽后保留

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(100, 0.6)
    inst.components.armor:SetKeepOnFinished(true)  -- 破损后不删除
    inst.components.armor:SetOnFinished(function(inst)
        -- 破损后变成其他状态
        inst.prefab = "broken_armor"
    end)
end
```

### 带修复功能的防具

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(200, 0.7)
    inst.components.armor.onrepair = function(inst, amount)
        -- 修复时播放特效
        inst.SoundEmitter:PlaySound("dontstarve/common/repair")
    end
end
```

## 伤害吸收流程

当穿戴此防具的实体被攻击时，`inventory:ApplyDamage` 会调用：

1. 检查 `CanResist(attacker, weapon)` — tags匹配
2. 若匹配，获取 `absorb_percent` 作为吸收率
3. 按吸收率减免伤害
4. 按减免后的伤害量扣耐久：`TakeDamage(damage_amount)`
5. 耐久归零时自动移除（除非 `keeponfinished=true`）
