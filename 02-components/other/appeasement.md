# Appeasement 安抚组件

> 源码: `scripts/components/appeasement.lua`

## 概述

Appeasement 管理敌对生物的安抚机制（如喂食蜘蛛后不再攻击）。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `duration` | number | `TUNING.APPEASEMENT_DURATION` | 安抚持续时间 |
| `appeasementtype` | string | — | 安抚类型标识 |
| `onappeased` | function/nil | `nil` | 被安抚时的回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Appease(appeaser)` | — | 安抚实体 |
| `IsAppeased()` | boolean | 是否处于安抚状态 |
| `GetTimeRemaining()` | number | 安抚剩余时间 |
| `SetDuration(duration)` | — | 设置安抚持续时间 |

## 使用示例

### 喂食安抚

```lua
inst:AddComponent("appeasement")
inst.components.appeasement.duration = TUNING.TOTAL_DAY_TIME * 0.25  -- 0.25天

-- 在喂食回调中调用
inst.components.appeasement:Appease(doer)
```

### 检查安抚状态

```lua
if inst.components.appeasement and inst.components.appeasement:IsAppeased() then
    -- 被安抚中，不攻击
    return
end
```
