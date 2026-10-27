# GhostlyBond 灵魂绑定组件

> 源码: `scripts/components/ghostlybond.lua`

## 概述

GhostlyBond 管理实体与灵魂之间的绑定关系，用于作祟（haunt）后的链接追踪。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `bonded` | Entity/nil | `nil` | 绑定的灵魂实体 |
| `bondtype` | string | — | 绑定类型 |
| `bondtime` | number | `0` | 绑定时间 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetBond(ghost)` | — | 设置绑定灵魂 |
| `ClearBond()` | — | 清除绑定 |
| `GetBonded()` | Entity/nil | 获取绑定的灵魂 |
| `IsBonded()` | boolean | 是否有绑定 |

## 使用示例

```lua
inst:AddComponent("ghostlybond")
-- 通常由作祟系统自动管理，一般不手动操作
```
