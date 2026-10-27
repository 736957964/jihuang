# Propagator 传播组件

> 源码: `scripts/components/propagator.lua`

## 概述

Propagator 管理火焰/疾病等效果的传播行为，控制实体之间相互引燃/感染。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `propagaterange` | number | `3` | 传播范围 |
| `damages` | boolean | `true` | 是否造成伤害 |
| `damageamount` | number | `5` | 每次伤害量 |
| `damageinterval` | number | `1` | 伤害间隔（秒） |
| `decayrate` | number | `1` | 衰减率 |
| `heatoutput` | number | `0` | 热量输出 |
| `flashpoint` | number | `30` | 闪点（触发燃烧的温度） |
| `propagatesound` | string/nil | `nil` | 传播音效 |
| `pauseSound` | string/nil | `nil` | 暂停音效 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetPropagateRange(range)` | — | 设置传播范围 |
| `SetFlashPoint(temp)` | — | 设置闪点温度 |
| `StartSpreading()` | — | 开始传播 |
| `StopSpreading()` | — | 停止传播 |
| `StartSmoldering()` | — | 开始阴燃 |
| `StopSmoldering()` | — | 停止阴燃 |
| `IsSmoldering()` | boolean | 是否阴燃中 |

## 使用示例

### 可燃物设置传播

```lua
inst:AddComponent("propagator")
inst.components.propagator.propagaterange = 4        -- 4格范围传播
inst.components.propagator.flashpoint = 30            -- 30度闪点
inst.components.propagator.heatoutput = 10            -- 热量输出
inst.components.propagator:StartSpreading()
```

### 疾病传播

```lua
inst:AddComponent("propagator")
inst.components.propagator.propagaterange = 2
inst.components.propagator.damageamount = 1
inst.components.propagator.damageinterval = 5  -- 每5秒传播一次
inst.components.propagator:StartSpreading()
```

### 阴燃

```lua
inst.components.propagator:StartSmoldering()
-- 物体开始阴燃（冒烟），一段时间后可能燃烧
```
