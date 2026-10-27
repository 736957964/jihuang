# WidgetFavorite 收藏组件

> 源码: `scripts/components/widgetfavorite.lua`

## 概述

WidgetFavorite 管理物品的"收藏"状态，用于制作栏中的收藏功能。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `favorited` | boolean | `false` | 是否已收藏 |
| `onfavoritedchange` | function/nil | `nil` | 收藏状态变更回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetFavorited(state)` | — | 设置收藏状态 |
| `IsFavorited()` | boolean | 是否已收藏 |
| `ToggleFavorite()` | — | 切换收藏状态 |

## 使用示例

```lua
inst:AddComponent("widgetfavorite")
inst.components.widgetfavorite:SetFavorited(true)   -- 收藏
inst.components.widgetfavorite:ToggleFavorite()     -- 切换
local is_fav = inst.components.widgetfavorite:IsFavorited()
```
