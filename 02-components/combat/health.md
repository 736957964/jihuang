# Health 组件

> 源码: `scripts/components/health.lua`

## 概述

Health 组件管理实体的生命值系统，包括血量、无敌状态、火伤、月灼、惩罚血量、生命恢复等。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `maxhealth` | `number` | `100` | 最大生命值 |
| `minhealth` | `number` | `0` | 最小生命值 |
| `currenthealth` | `number` | `maxhealth` | 当前生命值 |
| `invincible` | `boolean` | `false` | 是否无敌 |
| `nofadeout` | `boolean` | `false` | 死亡时是否不渐隐消失 |
| `canmurder` | `boolean` | `true` | 是否可被谋杀 |
| `canheal` | `boolean` | `true` | 是否可被治疗 |
| `penalty` | `number` | `0` | 生命惩罚比例 (0~1) |
| `disable_penalty` | `boolean` | `!TUNING.HEALTH_PENALTY_ENABLED` | 是否禁用惩罚 |
| `fire_damage_scale` | `number` | `1` | 火伤缩放倍率 |
| `fire_timestart` | `number` | `1` | 火伤开始延迟(秒) |
| `absorb` | `number` | `0` | **已废弃** — 请用 `externalabsorbmodifiers` |
| `playerabsorb` | `number` | `0` | **已废弃** — 请用 `externalabsorbmodifiers` |
| `externalabsorbmodifiers` | `SourceModifierList` | 加法叠加 | 外部吸收修正器 |
| `externalreductionmodifiers` | `SourceModifierList` | 加法叠加 | 外部伤害减免修正器 |
| `externalfiredamagemultipliers` | `SourceModifierList` | — | 火伤倍率修正器 |
| `takingfiredamage` | `boolean` | `false` | 是否正在受火伤 |

## 方法

### 生命值操作

| 方法 | 说明 |
|------|------|
| `SetMaxHealth(amount)` | 设置最大生命值，同时将当前生命值设为 `amount` |
| `SetMinHealth(amount)` | 设置最小生命值 |
| `SetCurrentHealth(amount)` | 直接设置当前生命值 |
| `SetVal(val, cause, afflicter)` | 设置生命值，触发 `healthdelta` 事件 |
| `SetPercent(percent, overtime, cause)` | 按百分比设置生命值 |
| `GetPercent()` | 获取生命值百分比 `currenthealth / maxhealth` |
| `GetPercentWithPenalty()` | 考虑惩罚后的百分比 |
| `GetMaxWithPenalty()` | 考虑惩罚后的最大生命值 `maxhealth * (1 - penalty)` |
| `IsHurt()` | 是否受伤（当前 < 最大） |
| `IsDead()` | 是否死亡（`currenthealth <= 0`） |
| `Kill()` | 杀死实体（调用 DoDelta 扣除剩余生命） |
| `ForceKill()` | 强制杀死（无视无敌） |

### 伤害/治疗

| 方法 | 说明 |
|------|------|
| `DoDelta(delta, overtime, cause, ignore_invincible, afflicter, ignore_absorb)` | 增减生命值。正值治疗，负值伤害。核心方法 |
| `DoFireDamage(amount, doer, instant)` | 火焰伤害（考虑火伤缩放和每秒上限） |
| `GetFireDamageScale()` | 获取当前火伤倍率 |
| `SetMaxDamageTakenPerHit(maxdamagetakenperhit)` | 设置单次伤害上限（传入负数） |
| `ForceUpdateHUD(overtime)` | 强制更新HUD显示 |

### 无敌/惩罚

| 方法 | 说明 |
|------|------|
| `SetInvincible(val)` | 设置无敌状态，推送 `invincibletoggle` 事件 |
| `IsInvincible()` | 是否无敌 |
| `SetPenalty(penalty)` | 设置生命惩罚比例 |
| `DeltaPenalty(delta)` | 增减惩罚值 |
| `GetPenaltyPercent()` | 获取惩罚百分比 |
| `RecalculatePenalty()` | **已废弃** |

### 生命恢复

| 方法 | 说明 |
|------|------|
| `StartRegen(amount, period, interruptcurrentregen)` | 开始持续回血 |
| `StopRegen()` | 停止回血 |
| `AddRegenSource(source, amount, period, key)` | 添加回血来源（支持多个来源叠加） |
| `RemoveRegenSource(source, key)` | 移除回血来源 |

### 月灼

| 方法 | 说明 |
|------|------|
| `RegisterLunarBurnSource(source, flags)` | 注册月灼来源 |
| `UnregisterLunarBurnSource(source)` | 取消注册月灼来源 |
| `GetLunarBurnFlags()` | 获取月灼标记 |
| `CalcLunarBurnFlags()` | 计算当前月灼标记组合 |

### 吸收

| 方法 | 说明 |
|------|------|
| `SetAbsorptionAmount(amount)` | **已废弃** — 设置吸收值 |
| `SetAbsorptionAmountFromPlayer(amount)` | **已废弃** — 设置玩家吸收值 |

### 其他

| 方法 | 说明 |
|------|------|
| `CanFadeOut()` | 死亡时是否可渐隐消失 |
| `GetDebugString()` | 获取调试字符串 |

## 事件

| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `healthdelta` | 生命值变化时 | `{ oldpercent, newpercent, cause, afflicter, amount }` |
| `invincibletoggle` | 无敌状态切换时 | `{ invincible = bool }` |
| `startfiredamage` | 开始受火伤 | `{ low = bool }` |
| `stopfiredamage` | 停止受火伤 | — |
| `changefiredamage` | 火伤强度变化 | `{ low = bool }` |
| `firedamage` | 受到一次火伤 | — |
| `startlunarburn` | 开始月灼 | `flags` |
| `stoplunarburn` | 停止月灼 | — |

## 使用示例

```lua
-- 设置生命值
inst.components.health:SetMaxHealth(200)

-- 造成伤害
inst.components.health:DoDelta(-30, false, "monster", nil, attacker)

-- 治疗
inst.components.health:DoDelta(20)

-- 检查死亡
if inst.components.health:IsDead() then
    inst:Remove()
end

-- 设置无敌
inst.components.health:SetInvincible(true)

-- 添加持续回血
inst.components.health:AddRegenSource("my_source", 1, 1)

-- 设置生命惩罚（最大生命减少25%）
inst.components.health:SetPenalty(0.25)
```
