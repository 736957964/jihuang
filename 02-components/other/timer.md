# Timer 定时器组件

> 源码: `scripts/components/timer.lua`

## 概述

Timer 提供简单的倒计时功能，倒计时结束后触发回调。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `task` | task/nil | `nil` | 当前定时任务 |
| `taskinfo` | table/nil | `nil` | 任务信息 |
| `start_time` | number | `0` | 开始时间 |
| `end_time` | number | `0` | 结束时间 |
| `paused_time` | number/nil | `nil` | 暂停时间 |
| `max_time` | number | — | 最大持续时间 |
| `elapsed_time` | number | `0` | 已流逝时间 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `StartTimer(name, time)` | — | 启动计时器 |
| `StopTimer(name)` | — | 停止计时器 |
| `PauseTimer()` | — | 暂停计时器 |
| `ResumeTimer()` | — | 恢复计时器 |
| `GetTimeRemaining()` | number | 获取剩余时间 |
| `GetTimeElapsed()` | number | 获取已过时间 |
| `GetPercent()` | number | 获取完成百分比（0~1） |
| `IsPaused()` | boolean | 是否已暂停 |
| `OnTimerDone(name)` | — | 计时结束（触发回调） |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `timerdone` | 计时器结束时 | `{name}` |
| `timerupdate` | 计时器更新时 | — |

## 使用示例

### 定时销毁

```lua
inst:AddComponent("timer")
inst.components.timer:StartTimer("decay", TUNING.TOTAL_DAY_TIME * 3)  -- 3天后
inst:ListenForEvent("timerdone", function(inst, data)
    if data.name == "decay" then
        inst:Remove()
    end
end)
```

### 多阶段计时

```lua
inst:AddComponent("timer")
inst.components.timer:StartTimer("stage1", 10)
inst:ListenForEvent("timerdone", function(inst, data)
    if data.name == "stage1" then
        inst.components.timer:StartTimer("stage2", 20)  -- 阶段2
    elseif data.name == "stage2" then
        inst:Remove()
    end
end)
```

### 暂停/恢复

```lua
inst.components.timer:PauseTimer()   -- 暂停
inst.components.timer:ResumeTimer()  -- 恢复
```
