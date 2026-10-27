# Explosive / Gunpowder 爆炸组件

> 源码: `scripts/components/explosive.lua` / `scripts/components/gunpowder.lua`

## 概述

Explosive 管理爆炸行为（范围伤害、破坏结构）。Gunpowder 是火药专用的爆炸管理组件。

## Explosive

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `explosiverange` | number | `3` | 爆炸范围 |
| `explosivedamage` | number | `100` | 爆炸伤害 |
| `buildingdamage` | number | `100` | 对建筑伤害 |
| `onexplodefn` | function/nil | `nil` | 爆炸回调 |
| `exploded` | boolean | `false` | 是否已爆炸 |

### 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetRange(range)` | — | 设置爆炸范围 |
| `SetDamage(damage)` | — | 设置伤害 |
| `SetBuildingDamage(damage)` | — | 设置建筑伤害 |
| `SetOnExplode(fn)` | — | 设置爆炸回调 |
| `OnBurnt()` | — | 被烧毁时触发爆炸 |
| `Explode()` | — | 手动引爆 |

## Gunpowder

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `damage_radius` | number | — | 伤害半径 |
| `structure_damage` | number | — | 建筑伤害 |

## 使用示例

### 爆炸物

```lua
inst:AddComponent("explosive")
inst.components.explosive.explosiverange = 6
inst.components.explosive.explosivedamage = 200
inst.components.explosive.buildingdamage = 50
inst.components.explosive:SetOnExplode(function(inst)
    SpawnPrefab("explode_fx").Transform:SetPosition(inst:GetPosition())
end)
```

### 火药

```lua
inst:AddComponent("gunpowder")
inst.components.gunpowder.damage_radius = 4
inst.components.gunpowder.structure_damage = 100
```
