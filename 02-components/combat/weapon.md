# Weapon 武器组件

> 源码: `scripts/components/weapon.lua`

## 概述

Weapon 组件赋予物品武器能力，控制伤害、攻击范围、特效和投射物等属性。手持物品挂载此组件后即可用于攻击。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `damage` | number/function | `10` | 基础伤害（可为函数 `fn(inst, attacker, target) -> number`） |
| `attackrange` | number | `nil` | 额外攻击范围（在combat基础上加） |
| `hitrange` | number | `nil` | 额外命中范围 |
| `onattack` | function | `nil` | 攻击时回调 `fn(inst, attacker, target)` |
| `onprojectilelaunch` | function | `nil` | 投射物发射前回调 `fn(inst, attacker, target)` |
| `onprojectilelaunched` | function | `nil` | 投射物发射后回调 `fn(inst, attacker, target, proj)` |
| `projectile` | string | `nil` | 投射物prefab名（设置后变远程武器） |
| `projectile_offset` | number | `nil` | 投射物生成偏移 |
| `stimuli` | string | `nil` | 攻击刺激类型（"electric"等） |
| `electric_damage_mult` | number | `nil` | 电击伤害倍率 |
| `electric_wet_damage_mult` | number | `nil` | 潮湿电击伤害倍率 |
| `tough` | boolean | `nil` | 是否坚韧武器（可攻击tough目标） |
| `overridestimulifn` | function | `nil` | 覆盖刺激类型判定 `fn(weapon, attacker, target) -> string` |
| `attackwear` | number | `1` | 每次攻击耐久消耗系数 |
| `attackwearmultipliers` | SourceModifierList | — | 攻击磨损倍率列表 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetDamage(dmg)` | — | 设置基础伤害 |
| `SetRange(attack, hit)` | — | 设置额外攻击/命中范围 |
| `SetOnAttack(fn)` | — | 设置攻击回调 |
| `SetOnProjectileLaunch(fn)` | — | 设置投射物发射前回调 |
| `SetOnProjectileLaunched(fn)` | — | 设置投射物发射后回调 |
| `SetProjectile(projectile)` | — | 设置投射物prefab（变远程） |
| `SetProjectileOffset(offset)` | — | 设置投射物生成偏移 |
| `SetElectric(damage_mult, wet_damage_mult)` | — | 设置为电击武器 |
| `SetOverrideStimuliFn(fn)` | — | 设置覆盖刺激类型函数 |
| `CanRangedAttack()` | boolean | 是否能远程攻击 |
| `GetDamage(attacker, target)` | damage, spdamage | 计算伤害（含damagetypebonus） |
| `OnAttack(attacker, target, projectile)` | — | 攻击后处理（回调+耐久消耗） |
| `LaunchProjectile(attacker, target)` | — | 发射投射物 |
| `EnableToughFight(tough)` | — | 启用坚韧战斗能力 |
| `CanDoToughFight()` | boolean | 是否能坚韧战斗 |
| `SetAttackCallback(fn)` | — | **已弃用**，同 `SetOnAttack` |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `weapononattack` | 每次攻击命中后 | `{attacker, target}` |

## 生命周期

| 回调 | 说明 |
|------|------|
| `OnRemoveFromEntity()` | 移除时清除 `"weapon"` tag，重置 attackrange |

## 网络同步

修改 `attackrange` 会自动同步到 `inst.replica.inventoryitem:SetAttackRange()`。

## 使用示例

### 基础近战武器

```lua
local function fn()
    local inst = CreateEntity()
    -- ... 基础设置 ...
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)  -- 伤害34
    -- 不设置attackrange，使用combat默认攻击范围
end
```

### 远程武器（投射物）

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(20)
    inst.components.weapon:SetRange(8, 10)  -- 额外攻击/命中范围
    inst.components.weapon:SetProjectile("my_projectile")  -- 投射物prefab
    inst.components.weapon:SetOnProjectileLaunched(function(inst, attacker, target, proj)
        -- 发射后回调
    end)
end
```

### 电击武器

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(30)
    inst.components.weapon:SetElectric(2, 3)  -- 2倍电击，潮湿3倍
    inst:AddTag("electric")
end
```

### 有攻击特效的武器

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(42)
    inst.components.weapon:SetOnAttack(function(inst, attacker, target)
        -- 攻击时附加火焰
        if target and target.components.burnable then
            target.components.burnable:Ignite()
        end
        -- 播放特效
        attacker.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    end)
end
```

### 动态伤害武器

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("weapon")
    -- damage 可以是函数
    inst.components.weapon:SetDamage(function(inst, attacker, target)
        -- 根据攻击者血量变化伤害
        if attacker.components.health then
            local hp_percent = attacker.components.health:GetPercent()
            return 20 + (1 - hp_percent) * 30  -- 血量越低伤害越高
        end
        return 20
    end)
end
```

### 坚韧武器（攻击tough目标）

```lua
local function fn()
    local inst = CreateEntity()
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50)
    inst.components.weapon:EnableToughFight(true)  -- 可攻击tough目标
    inst:AddTag("toughfighter")
end
```

## 攻击范围机制

- `combat.attackrange`（默认3）+ `weapon.attackrange` = 实际攻击范围
- 不设置 `weapon.attackrange` 则使用 combat 默认值
- 长矛：`weapon.attackrange = 1`，实际范围 = 4
