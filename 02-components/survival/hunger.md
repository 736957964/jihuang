# Hunger 饥饿组件

> 源码: `scripts/components/hunger.lua`

## 概述

Hunger 组件管理角色的饥饿值，包括饥饿速率、饱食度消耗和饥饿伤害。是角色的三大核心属性之一。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `max` | number | `100` | 最大饥饿值 |
| `current` | number | `100` | 当前饥饿值 |
| `hungerrate` | number | `1` | 饥饿消耗速率倍率 |
| `hurtrate` | number | `1` | 饥饿伤害速率倍率 |
| `burning` | boolean | `true` | 是否在消耗饥饿值 |
| `burnrate` | number | `1` | **已弃用**，使用 `burnratemodifiers` |
| `burnratemodifiers` | SourceModifierList | — | 消耗速率修正列表 |
| `overridestarvefn` | function | `nil` | 自定义饥饿处理 `fn(inst, dt)` |
| `redirect` | function | `nil` | 饥饿值变化重定向 `fn(inst, delta, overtime)` |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetMax(amount)` | — | 设置最大饥饿值（同时重置当前值） |
| `SetRate(rate)` | — | 设置饥饿消耗速率 |
| `SetKillRate(rate)` | — | 设置饥饿伤害速率 |
| `SetOverrideStarveFn(fn)` | — | 设置自定义饥饿处理（替代默认扣血） |
| `IsPaused()` | boolean | 饥饿是否暂停 |
| `IsStarving()` | boolean | 是否在饥饿状态（current <= 0） |
| `Pause()` | — | 暂停饥饿消耗 |
| `Resume()` | — | 恢复饥饿消耗 |
| `GetPercent()` | number | 获取饥饿百分比（0~1） |
| `SetPercent(p, overtime)` | — | 按百分比设置饥饿值 |
| `SetCurrent(current, overtime)` | — | 设置当前饥饿值 |
| `DoDelta(delta, overtime, ignore_invincible)` | — | 改变饥饿值（正值增加，负值减少） |
| `DoDec(dt, ignore_damage)` | — | 每秒衰减处理（内部调用） |
| `LongUpdate(dt)` | — | 长时间更新（跳过伤害） |
| `TransferComponent(newinst)` | — | 将饥饿百分比转移到新实体 |
| `OnSave()` | table/nil | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |
| `OnRemoveFromEntity()` | — | 清理定时任务 |
| `GetDebugString()` | string | 调试字符串 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `hungerdelta` | 饥饿值变化 | `{oldpercent, newpercent, overtime, delta}` |
| `startstarving` | 开始饥饿（从 >0 变为 <=0） | — |
| `stopstarving` | 停止饥饿（从 <=0 变为 >0） | — |

## 使用示例

```lua
-- 基本设置
inst.components.hunger:SetMax(150)
inst.components.hunger:SetRate(1.5)  -- 1.5倍消耗速度

-- 暂停/恢复饥饿
inst.components.hunger:Pause()
inst.components.hunger:Resume()

-- 直接改变饥饿值
inst.components.hunger:DoDelta(20)       -- 增加20
inst.components.hunger:DoDelta(-10, true) -- 减少10（标记为overtime）

-- 按百分比设置
inst.components.hunger:SetPercent(0.5)  -- 设置为50%

-- 修改消耗速率
inst.components.hunger.burnratemodifiers:SetModifier("night", 1.5)  -- 夜间1.5倍消耗

-- 自定义饥饿处理
inst.components.hunger:SetOverrideStarveFn(function(inst, dt)
    -- 不扣血，而是减速
    if inst.components.locomotor then
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "starving", 0.7)
    end
end)

-- 饥饿值重定向（韦伯的蜘蛛等）
inst.components.hunger.redirect = function(inst, delta, overtime)
    -- 将饥饿变化重定向到其他处理
end
```

## 饥饿消耗公式

每秒消耗量 = `hungerrate * burnrate * burnratemodifiers:Get() * dt`

- `hungerrate`：基础消耗速率（`SetRate` 设置）
- `burnrate`：**已弃用**的消耗倍率
- `burnratemodifiers`：SourceModifierList 修正值
- 饥饿归零后，按 `hurtrate * dt` 扣血（除非设置了 `overridestarvefn`）
