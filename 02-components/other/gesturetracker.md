# GestureTracker 手势追踪组件

> 源码: `scripts/components/gesturetracker.lua`

## 概述

GestureTracker 追踪实体的手势/表情动作状态（如招手、跳舞等社交动作）。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `current_gesture` | string/nil | `nil` | 当前手势 |
| `ongesturechange` | function/nil | `nil` | 手势变更回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetGesture(gesture)` | — | 设置当前手势 |
| `GetGesture()` | string/nil | 获取当前手势 |
| `ClearGesture()` | — | 清除手势 |

## 使用示例

```lua
inst:AddComponent("gesturetracker")
inst.components.gesturetracker:SetGesture("wave")  -- 招手
inst.components.gesturetracker:SetGesture("dance") -- 跳舞
inst.components.gesturetracker:ClearGesture()       -- 停止
```
