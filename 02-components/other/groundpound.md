# GroundPound 地面震荡组件

> 源码: `scripts/components/groundpound.lua`

## 概述

GroundPound 管理地面震荡/重击效果（如Boss砸地），对范围内实体造成伤害和击退。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `radius` | number | `3` | 震荡半径 |
| `damage` | number | `100` | 震荡伤害 |
| `numrings` | number | `1` | 震荡波纹数 |
| `ringdelay` | number | `0.3` | 波纹间隔 |
| `destroyer` | boolean | `false` | 是否破坏结构 |
| `groundpoundringfn` | function/nil | `nil` | 每环回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetRadius(radius)` | — | 设置震荡半径 |
| `SetDamage(damage)` | — | 设置震荡伤害 |
| `SetNumRings(n)` | — | 设置波纹数量 |
| `SetRingDelay(delay)` | — | 设置波纹间隔 |
| `SetDestroyer(destroyer)` | — | 设置是否破坏结构 |
| `SetOnRing(fn)` | — | 设置每环回调 |
| `GroundPound()` | — | 执行地面震荡 |

## 使用示例

### Boss 砸地

```lua
inst:AddComponent("groundpound")
inst.components.groundpound.radius = 6
inst.components.groundpound.damage = 150
inst.components.groundpound.numrings = 3        -- 3个波纹
inst.components.groundpound.ringdelay = 0.5      -- 每0.5秒一个波纹
inst.components.groundpound.destroyer = true     -- 破坏结构

-- 在状态机中调用
inst.components.groundpound:GroundPound()
```

### 每环特效

```lua
inst.components.groundpound:SetOnRing(function(inst, ring)
    -- 每环触发
    SpawnPrefab("groundpound_fx").Transform:SetPosition(inst:GetPosition())
end)
```

### 简单震荡

```lua
inst:AddComponent("groundpound")
inst.components.groundpound.radius = 3
inst.components.groundpound.damage = 50
inst.components.groundpound:GroundPound()
```
