# Hauntable / PlayerHauntable 作祟组件

> 源码: `scripts/components/hauntable.lua` / `scripts/components/playerhauntable.lua`

## 概述

Hauntable 定义实体可被幽灵玩家作祟（haunt）时触发的效果。PlayerHauntable 专为玩家实体设计。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `onhauntfn` | function/nil | `nil` | 作祟回调 |
| `hauntable` | boolean | `true` | 是否可被作祟 |
| `cooldown` | number | `0` | 冷却时间 |
| `chance` | number | `1` | 作祟成功率 |

## 方法 (Hauntable)

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetOnHaunt(fn)` | — | 设置作祟回调 |
| `SetHauntCooldown(time)` | — | 设置冷却时间 |
| `DoHaunt(doer)` | boolean | 执行作祟 |

## 使用示例

### 作祟触发效果

```lua
inst:AddComponent("hauntable")
inst.components.hauntable:SetOnHaunt(function(inst, doer)
    if math.random() < 0.5 then
        inst.components.burnable:Ignite()
        return true  -- 成功作祟
    end
    return false  -- 作祟失败
end)
```

### 设置冷却

```lua
inst.components.hauntable:SetHauntCooldown(10)  -- 10秒冷却
```

### 作祟成功率

```lua
inst.components.hauntable.chance = 0.3  -- 30%成功率
```

### PlayerHauntable

```lua
-- 玩家死后可被其他幽灵作祟
inst:AddComponent("playerhauntable")
-- 一般不需要手动设置，游戏自动处理
```
