# Map 地图组件

> 源码: `scripts/components/map.lua`

## 概述

Map 管理实体在世界地图上的显示和探索状态。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `minimapicon` | string/nil | `nil` | 小地图图标 |
| `mapscreenscale` | number | `1` | 地图图标缩放 |
| `onminimapfn` | function/nil | `nil` | 地图绘制回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetMiniMapIcon(icon)` | — | 设置小地图图标 |
| `SetMapScreenScale(scale)` | — | 设置地图图标缩放 |
| `SetOnMiniMap(fn)` | — | 设置地图绘制回调 |

## 使用示例

```lua
inst:AddComponent("map")
inst.components.map:SetMiniMapIcon("pig_house.tex")
inst.components.map:SetMapScreenScale(0.8)
```
