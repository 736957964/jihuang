# Pinnable 可标记组件

> 源码: `scripts/components/pinnable.lua`

## 概述

Pinnable 管理地图上的标记功能，允许实体在地图上被标记追踪。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `pinned` | boolean | `false` | 是否已被标记 |
| `pinimage` | string/nil | `nil` | 标记图标 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Pin()` | — | 添加标记 |
| `Unpin()` | — | 移除标记 |
| `IsPinned()` | boolean | 是否已标记 |
| `SetPinImage(image)` | — | 设置标记图标 |

## 使用示例

```lua
inst:AddComponent("pinnable")
inst.components.pinnable:SetPinImage("map_icon.tex")
inst.components.pinnable:Pin()  -- 在地图上显示标记
```
