# Occupier 占用组件

> 源码: `scripts/components/occupier.lua`

## 概述

Occupier 管理实体在物品栏槽位/容器中的占用关系，用于标记物品放在地面上的占用空间。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `occupiesfloor` | boolean | `false` | 是否占用地面空间 |
| `floorspacing` | number | `0` | 地面间距 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetFloorSpacing(spacing)` | — | 设置地面间距 |

## 使用示例

```lua
inst:AddComponent("occupier")
inst.components.occupier.occupiesfloor = true
inst.components.occupier:SetFloorSpacing(1.5)
-- 物品放在地上时占用一定空间，防止与其他物品重叠
```
