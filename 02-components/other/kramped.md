# Kramped 坎普斯触发组件

> 源码: `scripts/components/kramped.lua`

## 概述

Kramped 追踪玩家的"淘气值"系统，当淘气值达到阈值时触发坎普斯出现。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `naughtiness` | number | `0` | 当前淘气值 |
| `threshold` | number | `TUNING.KRAMPUS_THRESHOLD` | 触发阈值 |
| `decayrate` | number | `TUNING.KRAMPUS_DECAY_RATE` | 淘气值衰减率 |
| `onkrampusspawn` | function/nil | `nil` | 坎普斯出现回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `AddNaughtiness(amount)` | — | 增加淘气值 |
| `GetNaughtiness()` | number | 获取淘气值 |
| `SetThreshold(threshold)` | — | 设置触发阈值 |
| `SetOnKrampusSpawn(fn)` | — | 设置坎普斯出现回调 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

```lua
-- 玩家击杀无辜生物时增加淘气值
inst.components.kramped:AddNaughtiness(TUNING.KRAMPUS_NAUGHTINESS_FROM_KILLING_GLOMER)

-- 检查淘气值
if inst.components.kramped:GetNaughtiness() > 30 then
    print("坎普斯要来了！")
end
```
