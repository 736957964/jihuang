# Teleporter / BlinkStaff / HomeSeeker 传送组件

> 源码: `scripts/components/teleporter.lua` / `blinkstaff.lua` / `homeseeker.lua`

## 概述

这三个组件共同管理传送机制。Teleporter 定义传送目标和逻辑，BlinkStaff 实现瞬移法杖，HomeSeeker 实现"寻家"传送。

## Teleporter

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `target` | Entity/nil | `nil` | 传送目标 |
| `onactivateteleporterfn` | function/nil | `nil` | 激活回调 |
| `onteleportfn` | function/nil | `nil` | 传送回调 |

### 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetTarget(target)` | — | 设置传送目标 |
| `Teleport(doer)` | — | 执行传送 |
| `SetOnTeleport(fn)` | — | 设置传送回调 |

## BlinkStaff

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `range` | number | — | 瞬移范围 |
| `onblinkfn` | function/nil | `nil` | 瞬移回调 |

### 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Blink(pt, doer)` | — | 瞬移到指定点 |
| `SetRange(range)` | — | 设置范围 |

## HomeSeeker

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `home` | Entity/nil | `nil` | 家的位置 |
| `onsethomefn` | function/nil | `nil` | 设置家回调 |
| `ongohomefn` | function/nil | `nil` | 回家回调 |

## 使用示例

### 传送点

```lua
-- 传送门
inst:AddComponent("teleporter")
inst.components.teleporter:SetTarget(another_portal)

-- 传送法杖
inst:AddComponent("blinkstaff")
inst.components.blinkstaff.range = 20
```

### 寻家（如切斯特）

```lua
inst:AddComponent("homeseeker")
inst.components.homeseeker:SetHome(owner)
-- 离开一定距离后自动回到主人身边
```
