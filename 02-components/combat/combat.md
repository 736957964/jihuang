# Combat 战斗组件

> 源码: `scripts/components/combat.lua`

## 概述

Combat 组件是 DST 战斗系统的核心，负责管理实体的攻击行为、目标选择、伤害计算和战斗状态。几乎所有能攻击或被攻击的实体都需要挂载此组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `attackrange` | number | `3` | 攻击范围 |
| `hitrange` | number | `3` | 命中判定范围 |
| `areahitrange` | number | `nil` | 范围攻击半径（设置后启用AOE） |
| `areahitdamagepercent` | number | `nil` | AOE伤害百分比（0~1，默认1） |
| `hitarc` | number | `nil` | 攻击扇形角度（弧度制，nil=360度） |
| `defaultdamage` | number | `0` | 默认空手伤害 |
| `min_attack_period` | number | `4` | 最小攻击间隔（秒） |
| `canattack` | boolean | `true` | 是否能攻击 |
| `forcefacing` | boolean | `true` | 攻击时是否强制面向目标 |
| `target` | Entity | `nil` | 当前目标 |
| `lasttargetGUID` | GUID | `nil` | 上一个目标的GUID |
| `panic_thresh` | number | `nil` | 恐慌阈值（血量低于此值触发恐慌） |
| `damagemultiplier` | number | `nil` | 伤害倍率（默认1） |
| `damagebonus` | number | `nil` | 伤害加成（固定值，不受倍率影响） |
| `playerdamagepercent` | number | `nil` | NPC对玩家伤害倍率（仅空手时生效） |
| `pvp_damagemod` | number | `nil` | PVP伤害修正 |
| `ignorehitrange` | boolean | `nil` | 是否忽略命中距离检测 |
| `noimpactsound` | boolean | `nil` | 是否禁用受击音效 |
| `tough` | boolean | `nil` | 是否坚韧（需要特定条件才能造成伤害） |
| `playerstunlock` | enum | `nil` | 玩家眩晕锁定设置（PLAYERSTUNLOCK枚举） |
| `hiteffectsymbol` | string | `"marker"` | 命中特效附着点 |
| `nextbattlecrytime` | number | `nil` | 下次战吼时间 |
| `battlecryenabled` | boolean | `true` | 是否启用战吼 |
| `lastwasattackedtime` | number | `0` | 上次被攻击时间 |
| `laststartattacktime` | number | `0` | 上次开始攻击时间 |
| `lastdoattacktime` | number | `nil` | 上次执行攻击时间 |
| `lastattacker` | Entity | `nil` | 上次攻击者 |
| `lastattacktype` | string | `nil` | 上次攻击类型（"projectile" 或 nil） |
| `laststimuli` | string | `nil` | 上次攻击刺激类型 |
| `lastwasattackedbytargettime` | number | `0` | 上次被目标攻击的时间 |

### 回调函数属性

| 属性名 | 说明 |
|--------|------|
| `onhitfn` | 被命中时回调 `fn(inst, attacker, damage, spdamage)` |
| `onhitotherfn` | 命中他人时回调 `fn(attacker, target, damage, stimuli, weapon, damageresolved, spdamage, redirected)` |
| `keeptargetfn` | 保持目标判定函数 `fn(inst, target) -> bool` |
| `shouldaggrofn` | 自定义仇恨判定 `fn(inst, target) -> bool` |
| `shouldrecoilfn` | 自定义弹反判定 `fn(inst, attacker, weapon, damage) -> bool, remaining_damage` |
| `bonusdamagefn` | 额外伤害计算 `fn(attacker, target, damage, weapon) -> number` |
| `targetfn` | 重定向目标函数 `fn(inst) -> newtarget, forcechange` |
| `redirectdamagefn` | 伤害重定向 `fn(inst, attacker, damage, weapon, stimuli, spdamage) -> redirect_target` |
| `customdamagemultfn` | 自定义伤害倍率 `fn(inst, target, weapon, multiplier, mount) -> number` |
| `customspdamagemultfn` | 自定义特殊伤害倍率 |
| `workmultiplierfn` | 工作倍率函数 |
| `cansuggesttargetfn` | 是否接受建议目标 `fn(inst, target) -> bool` |

### SourceModifierList

| 属性名 | 说明 |
|--------|------|
| `externaldamagemultipliers` | 对外伤害倍率列表（支持多源叠加） |
| `externaldamagetakenmultipliers` | 承受伤害倍率列表（护甲减免后） |
| `conditionexternaldamagetakenmultipliers` | 条件性额外承受伤害倍率 |

## 方法

### 目标管理

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetTarget(target)` | — | 设置攻击目标，自动验证合法性 |
| `DropTarget(hasnexttarget)` | — | 丢弃当前目标 |
| `EngageTarget(target, oldtarget)` | — | 内部：接战目标，追踪事件 |
| `SuggestTarget(target)` | boolean | 建议目标（若当前无目标则设置） |
| `ShareTarget(target, range, fn, maxnum, musttags)` | — | 共享目标给附近友军 |
| `TargetIs(target)` | boolean | 检查是否是该目标 |
| `HasTarget()` | boolean | 是否有当前目标 |
| `IsValidTarget(target)` | boolean | 目标是否有效（委托给replica） |
| `ValidateTarget()` | boolean | 验证并清理无效目标 |
| `IsRecentTarget(target)` | boolean | 是否是最近目标（当前或上一个） |
| `SetLastTarget(target)` | — | 记录上一个目标 |
| `SetKeepTargetFunction(fn)` | — | 设置保持目标判定函数 |
| `TryRetarget()` | — | 尝试切换目标（通过targetfn） |
| `SetRetargetFunction(period, fn)` | — | 设置定期重定向目标 |
| `GiveUp()` | — | 放弃战斗（说话+丢目标） |

### 攻击行为

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `TryAttack(target)` | boolean | 尝试攻击（发送doattack事件） |
| `ForceAttack()` | boolean | 强制攻击 |
| `StartAttack()` | — | 开始攻击（面向目标+启动冷却） |
| `CancelAttack()` | — | 取消攻击（重置冷却） |
| `DoAttack(targ, weapon, projectile, stimuli, instancemult, instrangeoverride, instpos)` | — | 执行攻击（计算伤害+命中检测+AOE） |
| `CanAttack(target)` | boolean, should_give_up | 能否攻击 |
| `LocomotorCanAttack(reached_dest, target)` | boolean, invalid, in_cooldown | 移动系统中检查攻击条件 |
| `CanHitTarget(target, weapon)` | boolean | 能否命中目标（距离+弧角检测） |
| `CanExtinguishTarget(target, weapon)` | boolean | 能否灭火目标 |
| `CanLightTarget(target, weapon)` | boolean | 能否点燃目标 |
| `CanBeAttacked(attacker)` | boolean | 能否被攻击者攻击（委托给replica） |

### 冷却与范围

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `InCooldown()` | boolean | 是否在攻击冷却中 |
| `GetCooldown()` | number | 获取剩余冷却时间 |
| `ResetCooldown()` | — | 重置冷却 |
| `RestartCooldown()` | — | 重新开始冷却 |
| `OverrideCooldown(cd)` | — | 覆盖冷却时间 |
| `SetAttackPeriod(period)` | — | 设置攻击间隔 |
| `SetRange(attack, hit)` | — | 设置攻击范围 |
| `SetHitArc(arc)` | — | 设置攻击扇形角度 |
| `GetAttackRange()` | number | 获取攻击范围（含武器加成） |
| `GetHitRange()` | number | 获取命中范围 |
| `CalcAttackRangeSq(target)` | number | 计算攻击范围平方 |
| `CalcHitRangeSq(target)` | number | 计算命中范围平方 |
| `ClearAttackTemps()` | — | 清除临时攻击参数 |

### 伤害计算

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `CalcDamage(target, weapon, multiplier)` | damage, spdamage | 计算伤害（核心伤害公式） |
| `SetDefaultDamage(damage)` | — | 设置默认空手伤害 |
| `GetWeapon()` | Entity/nil | 获取手持武器 |
| `SetPlayerStunlock(stunlock)` | — | 设置玩家眩晕锁定 |
| `GetLastAttackedTime()` | number | 获取上次被攻击时间 |
| `BlankOutAttacks(fortime)` | — | 暂停攻击能力一段时间 |

### 范围攻击

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetAreaDamage(range, percent, areahitcheck)` | — | 设置范围攻击 |
| `EnableAreaDamage(enable)` | — | 启用/禁用范围攻击 |
| `DoAreaAttack(target, range, weapon, validfn, stimuli, excludetags, onlyontarget)` | number | 执行范围攻击，返回命中数 |

### 伤害反射

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `CalcReflectedDamage(targ, dmg, weapon, stimuli, reflect_list, spdmg)` | reflected_dmg, reflected_spdmg | 计算反伤 |

### 仇恨系统

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `ShouldAggro(target, ignore_forbidden)` | boolean | 是否应该仇恨目标 |
| `SetShouldAggroFn(fn)` | — | 设置仇恨判定函数 |
| `AddNoAggroTag(tag)` | — | 添加不仇恨标签 |
| `RemoveNoAggroTag(tag)` | — | 移除不仇恨标签 |
| `SetNoAggroTags(tags)` | — | 设置不仇恨标签列表 |
| `SetShouldAvoidAggro(target)` | — | 临时避免仇恨某目标 |
| `RemoveShouldAvoidAggro(target)` | — | 移除临时避免仇恨 |

### 其他

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `GetAttacked(attacker, damage, weapon, stimuli, spdamage)` | boolean | 被攻击处理（核心流程） |
| `BattleCry()` | — | 发出战吼 |
| `ResetBattleCryCooldown(t)` | — | 重置战吼冷却 |
| `SetHurtSound(sound)` | — | 设置受伤音效 |
| `SetOnHit(fn)` | — | 设置被命中回调 |
| `SetCanSuggestTargetFn(fn)` | — | 设置建议目标回调 |
| `SetRequiresToughCombat(tough)` | — | 设置坚韧战斗要求 |
| `SetShouldRecoilFn(fn)` | — | 设置弹反判定函数 |
| `GetBattleCryString(target)` | string, strid | 获取战吼字符串（可重写） |
| `GetGiveUpString(target)` | string, strid | 获取放弃战斗字符串（可重写） |
| `GetImpactSound(target, weapon)` | string | 获取受击音效 |
| `CanBeAlly(guy)` | boolean | 是否可能是友军 |
| `IsAlly(guy)` | boolean | 是否是友军 |
| `GetDebugString()` | string | 获取调试字符串 |
| `OnEntitySleep()` | — | 实体休眠时清理重定向任务 |
| `OnEntityWake()` | — | 实体唤醒时恢复重定向任务 |
| `OnUpdate(dt)` | — | 每帧更新（检查keeptargetfn） |
| `OnRemoveFromEntity()` | — | 移除时清理 |

## 事件

### 推送事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `newcombattarget` | 获取新目标 | `{target, oldtarget}` |
| `droppedtarget` | 丢弃目标 | `{target}` |
| `losttarget` | 目标丢失（keeptargetfn返回false） | — |
| `giveuptarget` | 放弃战斗 | `{target}` |
| `attacked` | 被攻击 | `{attacker, damage, damageresolved, original_damage, weapon, stimuli, spdamage, redirected}` |
| `blocked` | 攻击被格挡 | `{attacker, damage, spdamage, original_damage}` |
| `doattack` | 请求执行攻击 | `{target}` |
| `onattackother` | 攻击其他实体 | `{target, weapon, projectile, stimuli}` |
| `onhitother` | 命中其他实体（由攻击者推送） | `{target, damage, damageresolved, stimuli, spdamage, weapon, redirected}` |
| `onmissother` | 未命中目标 | `{target, weapon}` |
| `onareaattackother` | AOE命中 | `{target, weapon, stimuli}` |
| `weapontooweak` | 武器太弱无法造成伤害 | — |
| `killed` | 击杀目标（由被击杀者推送） | `{victim, attacker}` |
| `recoil_off` | 弹反卸力 | `{target}` |

### 监听事件

| 事件名 | 来源 | 处理 |
|--------|------|------|
| `knockback` | — | `CommonHandlers.ResetHitRecoveryDelay` |
| `enterlimbo` | 目标 | `DropTarget` |
| `onremove` | 目标 | `DropTarget` |
| `transfercombattarget` | 目标 | 转移目标 |
| `leaderchanged` | 目标 | 友军检查 |

## 使用示例

```lua
-- 基本战斗设置
inst.components.combat:SetDefaultDamage(30)
inst.components.combat:SetRange(3, 4)
inst.components.combat:SetAttackPeriod(2)

-- 设置AOE攻击
inst.components.combat:SetAreaDamage(2, 0.5) -- 半径2，50%伤害

-- 设置被命中回调
inst.components.combat:SetOnHit(function(inst, attacker, damage)
    if attacker and attacker:HasTag("monster") then
        inst.components.combat:SuggestTarget(attacker)
    end
end)

-- 自定义仇恨判定
inst.components.combat:SetShouldAggroFn(function(inst, target)
    return not target:HasTag("wall")
end)

-- 添加禁止攻击标签
inst.components.combat:AddNoAggroTag("smallbird")

-- 设置坚韧（需要特殊武器才能造成伤害）
inst.components.combat:SetRequiresToughCombat(true)

-- 伤害倍率（2倍伤害）
inst.components.combat.externaldamagemultipliers:SetModifier("night", 2)

-- 恐慌阈值
inst.components.combat.panic_thresh = 0.3 -- 30%血量时恐慌
```

## 伤害计算流程

`DoAttack` 是核心攻击流程，按以下顺序执行：

1. **范围检测** — 检查目标是否在攻击范围内
2. **弹反检测** — 调用目标的 `ShouldRecoil`
3. **事件推送** — `onattackother`
4. **远程武器处理** — projectile / complexprojectile / LaunchProjectile
5. **伤害计算** — `CalcDamage`（考虑武器、倍率、电击加成、PVP修正）
6. **反伤计算** — `CalcReflectedDamage`
7. **伤害应用** — 目标的 `GetAttacked`
8. **武器磨损** — `weapon:OnAttack`
9. **AOE处理** — `DoAreaAttack`
10. **反伤应用** — 对攻击者造成反伤

## 被攻击处理流程

`GetAttacked` 处理被攻击的完整流程：

1. **死亡检查** — 已死亡则返回
2. **伤害重定向** — `redirectdamagefn`
3. **弹反处理** — `ShouldRecoil`
4. **闪避** — `attackdodger:Dodge`
5. **护甲减免** — `inventory:ApplyDamage`
6. **鞍具减免** — `saddler:ApplyDamage`
7. **伤害类型抗性** — `damagetyperesist`
8. **额外伤害倍率** — `conditionexternaldamagetakenmultipliers`
9. **无敌检测** — `IsInvincible`
10. **额外伤害** — `bonusdamagefn`
11. **平面实体** — `planarentity:AbsorbDamage`
12. **特殊伤害** — `SpDamageUtil`
13. **应用伤害** — `health:DoDelta`
14. **事件推送** — `attacked` / `blocked`
