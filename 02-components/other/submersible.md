# Submersible 可浸没组件

> 源码: `scripts/components/submersible.lua`

## 概述

Submersible 管理实体在水中的浸没状态（如船、码头等）。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `submerged` | boolean | `false` | 是否已浸没 |
| `onsubmergefn` | function/nil | `nil` | 浸没回调 |
| `onemergefn` | function/nil | `nil` | 浮出回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Submerge()` | — | 浸没 |
| `Emerge()` | — | 浮出 |
| `IsSubmerged()` | boolean | 是否浸没 |
| `SetOnSubmerge(fn)` | — | 设置浸没回调 |
| `SetOnEmerge(fn)` | — | 设置浮出回调 |

## 使用示例

```lua
inst:AddComponent("submersible")
inst.components.submersible:SetOnSubmerge(function(inst)
    inst.AnimState:PlayAnimation("sink")
end)
inst.components.submersible:SetOnEmerge(function(inst)
    inst.AnimState:PlayAnimation("emerge")
end)

-- 触发浸没
inst.components.submersible:Submerge()
```
