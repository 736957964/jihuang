# Sanity 理智组件

> 源码: `scripts/components/sanity.lua`

## 概述

Sanity 组件管理角色的理智/精神值，包含两种模式：**疯狂模式(Insanity)** 和 **启蒙模式(Lunacy)**。理智值受光照、装扮、潮湿、灵光和幽灵等多种因素影响。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `max` | number | `100` | 最大理智值 |
| `current` | number | `100` | 当前理智值 |
| `mode` | enum | `SANITY_MODE_INSANITY` | 理智模式（0=疯狂, 1=启蒙） |
| `sane` | boolean | `true` | 是否理智正常 |
| `rate` | number | `0` | 当前理智变化速率 |
| `ratescale` | enum | `RATE_SCALE.NEUTRAL` | 速率规模（UI箭头显示） |
| `rate_modifier` | number | `1` | 速率全局修正 |
| `dapperness` | number | `0` | 基础装扮值 |
| `dapperness_mult` | number | `1` | 装扮倍率 |
| `penalty` | number | `0` | 最大理智惩罚（0~1） |
| `night_drain_mult` | number | `1` | 夜间理智流失倍率 |
| `neg_aura_mult` | number | `1` | **已弃用**，负面灵光倍率 |
| `neg_aura_absorb` | number | `0` | 负面灵光吸收量 |
| `ghost_drain_mult` | number | `0` | 幽灵理智流失倍率 |
| `custom_rate_fn` | function | `nil` | 自定义速率计算 `fn(inst, dt) -> delta` |
| `redirect` | function | `nil` | 理智变化重定向 |
| `ignore` | boolean | `nil` | 是否忽略理智变化 |
| `inducedinsanity` | boolean | `nil` | 是否被诱导疯狂 |
| `inducedlunacy` | boolean | `nil` | 是否被诱导启蒙 |
| `onSane` | function | `nil` | 恢复理智回调 |
| `onInsane` | function | `nil` | 陷入疯狂回调 |
| `onEnlightened` | function | `nil` | 陷入启蒙回调 |

### SourceModifierList

| 属性名 | 说明 |
|--------|------|
| `burnratemodifiers` | 消耗速率修正（已弃用） |
| `externalmodifiers` | 外部修正值（加法叠加） |
| `_lunacy_sources` | 启蒙模式源（布尔叠加） |
| `neg_aura_modifiers` | 负面灵光倍率修正 |
| `neg_aura_immune_sources` | 负面灵光免疫 |
| `sanity_aura_immune_sources` | 全部灵光免疫 |
| `player_ghost_immune_sources` | 幽灵理智流失免疫 |
| `light_drain_immune_sources` | 光照理智流失免疫 |

### 表格属性

| 属性名 | 说明 |
|--------|------|
| `sanity_penalties` | 理智惩罚表 `{[key]=penalty_value}` |
| `sanity_aura_immunities` | 特定灵光免疫 `{[tag]=SourceModifierList}` |
| `inducedinsanity_sources` | 诱导疯狂源 |
| `inducedlunacy_sources` | 诱导启蒙源 |
| `opencontainers` | 打开的容器 |

## 方法

### 状态查询

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `IsSane()` | boolean | 是否理智正常（考虑模式+诱导状态） |
| `IsInsane()` | boolean | 是否疯狂 |
| `IsEnlightened()` | boolean | 是否启蒙 |
| `IsCrazy()` | boolean | **已弃用**，同 `IsInsane` |
| `IsInsanityMode()` | boolean | 是否疯狂模式 |
| `IsLunacyMode()` | boolean | 是否启蒙模式 |
| `GetSanityMode()` | enum | 获取当前模式 |
| `IsPaused()` | — | (无此方法，检查ignore) |

### 数值操作

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetMax(amount)` | — | 设置最大理智值 |
| `SetCurrent(amount)` | — | 设置当前值 |
| `GetPercent()` | number | 获取显示用百分比（考虑诱导状态） |
| `GetRealPercent()` | number | 获取真实百分比 |
| `GetPercentWithPenalty()` | number | 获取含惩罚的百分比 |
| `GetPenaltyPercent()` | number | 获取惩罚百分比 |
| `GetMaxWithPenalty()` | number | 获取惩罚后最大值 |
| `SetPercent(per, overtime)` | — | 按百分比设置 |
| `DoDelta(delta, overtime)` | — | 改变理智值 |
| `GetRateScale()` | enum | 获取速率规模 |
| `GetAuraMultipliers()` | number | 获取负面灵光倍率 |

### 模式与免疫

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `EnableLunacy(enable, source)` | — | 启用/禁用启蒙模式 |
| `SetSanityMode(mode)` | — | **已弃用**，使用 `EnableLunacy` |
| `SetInducedInsanity(src, val)` | — | 设置诱导疯狂 |
| `SetInducedLunacy(src, val)` | — | 设置诱导启蒙 |
| `SetFullAuraImmunity(immunity, source)` | — | 全灵光免疫 |
| `SetNegativeAuraImmunity(immunity, source)` | — | 负面灵光免疫 |
| `SetPlayerGhostImmunity(immunity, source)` | — | 幽灵流失免疫 |
| `SetLightDrainImmune(immunity, source)` | — | 光照流失免疫 |
| `AddSanityAuraImmunity(tag, source)` | — | 对特定tag灵光免疫 |
| `RemoveSanityAuraImmunity(tag, source)` | — | 移除特定tag灵光免疫 |

### 惩罚与修正

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `AddSanityPenalty(key, mod)` | — | 添加理智惩罚（减少最大值） |
| `RemoveSanityPenalty(key)` | — | 移除理智惩罚 |
| `RecalculatePenalty()` | — | 重新计算惩罚值 |

### 其他

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Recalc(dt)` | — | 每帧重新计算理智变化 |
| `RecalcGhostDrain()` | — | 重新计算幽灵流失 |
| `TransferComponent(newinst)` | — | 转移到新实体 |
| `LongUpdate(dt)` | — | 长时间更新 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `sanitydelta` | 理智值变化 | `{oldpercent, newpercent, overtime, sanitymode}` |
| `gosane` | 恢复理智 | — |
| `goinsane` | 陷入疯狂 | — |
| `goenlightened` | 陷入启蒙 | — |
| `sanitymodechanged` | 模式切换 | `{mode}` |
| `inducedinsanity` | 诱导疯狂变化 | `val` |
| `inducedlunacy` | 诱导启蒙变化 | `val` |

## 理智阈值

| 阈值 | 常量 | 值 | 说明 |
|------|------|----|------|
| 陷入疯狂 | `TUNING.SANITY_BECOME_INSANE_THRESH` | 0.30 | 低于30%变为疯狂 |
| 恢复理智 | `TUNING.SANITY_BECOME_SANE_THRESH` | 0.35 | 高于35%恢复理智 |
| 陷入启蒙 | `TUNING.SANITY_BECOME_ENLIGHTENED_THRESH` | — | 高于阈值陷入启蒙 |
| 失去启蒙 | `TUNING.SANITY_LOSE_ENLIGHTENMENT_THRESH` | — | 低于阈值恢复正常 |

## 理智变化公式

`Recalc` 每帧计算理智变化率：

```
rate = (dapper_delta + moisture_delta + light_delta + aura_delta + ghost_delta + externalmodifiers) * rate_modifier + custom_rate_fn
```

### 各因素说明

- **dapper_delta** = `(dapperness + 装备装扮总和) * dapperness_mult * TUNING.SANITY_DAPPERNESS`
- **moisture_delta** = 潮湿惩罚（基于潮湿百分比的正弦缓入曲线）
- **light_delta** = 光照影响（白天/夜晚亮光/暗光/全暗）
- **aura_delta** = 周围灵光总和（含负面灵光倍率和免疫判定）
- **ghost_delta** = `TUNING.SANITY_GHOST_PLAYER_DRAIN * ghost_drain_mult`

## 使用示例

```lua
-- 基本设置
inst.components.sanity:SetMax(200)
inst.components.sanity.night_drain_mult = 0.5  -- 夜间流失减半

-- 添加理智惩罚（减少最大值）
inst.components.sanity:AddSanityPenalty("resurrection", 0.25)  -- 减少25%最大理智

-- 灵光免疫
inst.components.sanity:SetNegativeAuraImmunity(true, "my_mod")

-- 特定灵光免疫（如温蒂对幽灵免疫）
inst.components.sanity:AddSanityAuraImmunity("ghost", inst)

-- 启用启蒙模式
inst.components.sanity:EnableLunacy(true, "lunar_island")

-- 自定义速率计算
inst.components.sanity.custom_rate_fn = function(inst, dt)
    if TheWorld.state.iswinter then
        return -0.5  -- 冬天额外流失
    end
    return 0
end

-- 监听理智变化
inst:ListenForEvent("sanitydelta", function(inst, data)
    if data.newpercent < 0.3 then
        -- 低理智特效
    end
end)

-- 诱导疯狂（如暗影操控器）
inst.components.sanity:SetInducedInsanity(inst, true)
```
