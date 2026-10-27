# Transformable 可变形组件

> 源码: `scripts/components/transformable.lua`

## 概述

Transformable 管理实体的变形能力（如韦伯变成蜘蛛、满月变身等）。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `ontransformfn` | function/nil | `nil` | 变形回调 |
| `ontransformbackfn` | function/nil | `nil` | 恢复回调 |
| `transformconditionfn` | function/nil | `nil` | 变形条件检查函数 |
| `transformstate` | string/nil | `nil` | 当前变形状态 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetOnTransform(fn)` | — | 设置变形回调 |
| `SetOnTransformBack(fn)` | — | 设置恢复回调 |
| `SetTransformCondition(fn)` | — | 设置变形条件函数 |
| `Transform()` | — | 执行变形 |
| `TransformBack()` | — | 恢复变形 |
| `CanTransform()` | boolean | 检查是否可以变形 |
| `IsTransformed()` | boolean | 是否处于变形状态 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

### 满月变形

```lua
inst:AddComponent("transformable")
inst.components.transformable:SetOnTransform(function(inst)
    inst.AnimState:SetBuild("werebeaver")
    inst.components.combat.defaultdamage = 27
end)
inst.components.transformable:SetOnTransformBack(function(inst)
    inst.AnimState:SetBuild("woodie")
    inst.components.combat.defaultdamage = 10
end)
inst.components.transformable:SetTransformCondition(function(inst)
    return TheWorld.state.isfullmoon
end)
```

### 手动触发变形

```lua
inst.components.transformable:Transform()  -- 变形
inst.components.transformable:TransformBack()  -- 恢复
```
