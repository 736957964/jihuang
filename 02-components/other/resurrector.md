# Resurrector 复活组件

> 源码: `scripts/components/resurrector.lua`

## 概述

Resurrector 管理复活机制。附在复活祭坛、生命护符等可复活实体上。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `resurrectfn` | function/nil | `nil` | 复活回调函数 |
| `used` | boolean | `false` | 是否已被使用 |
| `active` | boolean | `true` | 是否可用 |
| `sanitypenalty` | number | — | 复活后理智惩罚 |
| `healthpenalty` | number | — | 复活后生命惩罚 |
| `fastresurrection` | boolean | `false` | 是否快速复活 |
| `resurrectsound` | string/nil | `nil` | 复活音效 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetResurrectFn(fn)` | — | 设置复活回调 |
| `Resurrect(doer)` | — | 执行复活 |
| `IsActive()` | boolean | 是否可用 |
| `SetActive(active)` | — | 设置可用状态 |
| `SetPenalties(sanity, health)` | — | 设置复活惩罚 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

### 复活祭坛

```lua
inst:AddComponent("resurrector")
inst.components.resurrector.sanitypenalty = TUNING.RESURRECT_SANITY_PENALTY
inst.components.resurrector.healthpenalty = TUNING.RESURRECT_HEALTH_PENALTY
```

### 生命护符

```lua
inst:AddComponent("resurrector")
inst.components.resurrector:SetOnResurrect(function(inst, doer)
    inst:Remove()  -- 复活后护符消失
end)
inst.components.resurrector.healthpenalty = 0
inst.components.resurrector.sanitypenalty = 0
```

### 自定义复活

```lua
inst:AddComponent("resurrector")
inst.components.resurrector:SetResurrectFn(function(inst, doer)
    doer.Transform:SetPosition(inst.Transform:GetWorldPosition())
    doer.components.health:SetPercent(0.5)
    doer.components.sanity:SetPercent(0.5)
end)
```
