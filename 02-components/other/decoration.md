# Decoration 装饰组件

> 源码: `scripts/components/decoration.lua`

## 概述

Decoration 将实体标记为装饰物，使其不参与碰撞、不受物理影响，仅用于视觉表现。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `decor_type` | string | — | 装饰类型 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetType(decor_type)` | — | 设置装饰类型 |

## 使用示例

```lua
-- 生成装饰物（如雕像、墓碑外观等）
local decor = SpawnPrefab("statue_marble")
decor:AddComponent("decoration")
decor.components.decoration:SetType("STATUE")
-- 装饰物不参与游戏逻辑，仅用于视觉展示
```
