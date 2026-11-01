# 饥荒一线工坊深度研读 Skill：多阶段高阶 BOSS 状态机打断与仇恨软锁定机制
- **来源工程**：`神话书说 (1991746508 / Myth Words)` 与 `smallAn.md 工业案例`
- **核心逻辑对应**：`scripts/prefabs/blackbear.lua`、`scripts/brains/blackbearbrain.lua`、`SGblackbear.lua`
- **领域分类**：高阶怪物/BOSS AI 设计、StateGraph 强制打断与无敌帧治理、群体仇恨锁定与防卡顿脱战
---
## 一、核心实现原理与架构全貌
饥荒中设计一个具备商业级体验的高阶 BOSS，最大的挑战不是堆砌数值，而是处理**多人联机围殴下的动作被打断（硬直死锁）**、**转阶段动画期间被冰冻/催眠异常打断**、以及**无限制追击玩家导致的虚空寻路崩服**。神话书说的黑风怪与辟寒大王体系提供了标准规范：
### 1. 阈值触发转阶段与状态机霸体无敌帧
- **痛点**：BOSS 在血量降至 50% 准备施展咆哮或狂暴时，若被多名玩家同时冰冻杖、排箫或武器硬直打断，会导致转阶段标志位已置为 true，但对应动画和技能逻辑完全丢失。
- **工业级解法**：
  - 在 `healthdelta` 回调中触发转阶段后，立即通过 `inst.sg:GoToState("roar")` 强制切入。
  - 在 StateGraph 的 `roar` 状态中，打上两组关键 Tag：
    - `inst.sg:AddStateTag("busy")`: 屏蔽常规攻击与移动指令。
    - `inst.sg:AddStateTag("nosleep")` 与 `inst.sg:AddStateTag("nofreeze")`: 临时免疫催眠与冰冻，确保转阶段关键动画帧完整执行。
### 2. 行为树（Brain）权重分流与条件节点闭环
- **架构**：采用 `PriorityNode` 进行高优先级拦截。
  - 第一优先级：狂暴且未处于 `busy` 时，距离目标一定范围内强制施放范围技能（如 `groundpound` 地震波）；
  - 第二优先级：标准 `ChaseAndAttack` 追击与普攻；
  - 第三优先级：失去目标时的巡逻锚点漫步（`Wander`）。
### 3. 地震震慑与装备剥离的安全判定
- 范围伤害函数中必须使用 `TheSim:FindEntities` 严格设置过滤标签 `{ "INLIMBO", "flight", "FX" }`。
- 对被击中玩家触发震落装备（`DropEverything`）时，只震落手持武器（`eslot == EQUIPSLOTS.HANDS`），避免将玩家整个背包和护符震落导致客户端不同步。
---
## 二、标准化生产级代码范式 (可直接复用)
-- ==============================================================================
-- 范式 1：高阶 BOSS 状态机状态定义与免疫标签配置 (SGboss.lua)
-- ==============================================================================
local states = {
    State{
        name = "roar",
        tags = { "busy", "nosleep", "nofreeze", "epic", "jumping" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("roar")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bearger/taunt")
            -- 全屏摄像机震动反馈
            ShakeAllCameras(CAMERASHAKE.FULL, 0.7, 0.02, 0.5, inst, 40)
        end,
        timeline = {
            TimeEvent(10 * FRAMES, function(inst)
                -- 核心技能点：地面冲击与范围震慑
                if inst.DoGroundPound then
                    inst:DoGroundPound()
                end
            end),
        },
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
}
-- ==============================================================================
-- 范式 2：BOSS 实体预制体定义与血量监听 (custom_boss.lua)
-- ==============================================================================
local function OnHealthDelta(inst, data)
    if not inst.components.health:IsDead() then
        local percent = data.newpercent
        -- 50% 血量转阶段判定 (使用布尔锁防止反复触发)
        if percent < 0.5 and not inst.is_enraged then
            inst.is_enraged = true
            -- 强制切入霸体咆哮
            inst.sg:GoToState("roar")
            -- 狂暴属性加成
            inst.components.combat:SetDefaultDamage(150)
            inst.components.combat:SetAttackPeriod(2.0)
            inst.components.locomotor.runspeed = 10
        end
    end
end
local function RetargetFn(inst)
    -- 智能检索 15 码内非幽灵、非隐匿的玩家
    return FindEntity(
        inst,
        15,
        function(guy)
            return inst.components.combat:CanTarget(guy) and not guy:HasTag("playerghost")
        end,
        { "_combat", "character" },
        { "INLIMBO", "FX" }
    )
end
local function KeepTargetFn(inst, target)
    -- 离开 30 码或目标死亡时安全释放仇恨
    return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) < 900
end
---
## 三、踩坑与避错实战指南
1. **`KeepTargetFn` 缺失导致的全图追杀崩服**：
   - 饥荒怪物如果只写 `SetRetargetFunction` 而不配置 `SetKeepTargetFunction`，一旦玩家通过传送杖或虫洞飞到地图另一端，BOSS 会保持目标并在服务器后台进行每帧数千次的超远距离寻路计算，直接拉爆 CPU。务必设置安全脱战平方距离（如 `900` 即 30 码）。
2. **`INLIMBO` 实体击打导致坏档**：
   - 在范围伤害（AOE）遍历实体时，绝对不能碰处于 `INLIMBO`（背包中/被装入箱子）状态的物体，否则会导致存放在玩家包裹内的物品受到伤害，触发无效物理销毁，引发世界保存时数据结构断裂！
## 五、进阶拓扑演进与变体分支
### 变体演进：附魔拓展补丁 (Mod 3605108247)
- **变体场景与切面**：收录来自工坊 Mod 3605108247 (附魔拓展补丁) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3605108247)
-- ============================================================================
local GLOBAL = GLOBAL
-- 事件监听方式：最安全的过滤方法
AddPrefabPostInit("killerbee", function(inst)
   -- 将配置获取移到函数外部，避免每次创建都调用
    if not GLOBAL.TheNet:GetIsServer() then return end
    -- 使用缓存的配置值
    local config_value = GLOBAL.KillerBeeEnchantDropsEnabled
    if config_value == nil then
        config_value = GetModConfigData("ENABLE_KILLERBEE_ENCHANT_DROPS") or false
        GLOBAL.KillerBeeEnchantDropsEnabled = config_value
    end
    if not inst.components.lootdropper then
        return
    end
    print("[KillerBee Event] 加载杀人蜂事件过滤...")
    -- 获取配置
    local function GetConfig()
        if GetModConfigData then
            local success, result = pcall(GetModConfigData, "ENABLE_KILLERBEE_ENCHANT_DROPS")
            if success then
                return result
            end
        end
        return false
    end
    local config_value = GetConfig()
    print("[KillerBee Event] 杀人蜂配置: " .. (config_value and "允许掉落" or "禁止掉落"))
    if config_value then
        return
    end
    -- 过滤列表
    local FILTER_ITEMS = {
        "hh_effect_stone",
        "hh_essence",
        "hh_remove_stone", 
        "hh_effect_tally",
    }
    -- 监听掉落生成事件
    inst:ListenForEvent("spawnloot", function(inst, data)
        if not data or not data.item then
            return
        end
        local item_prefab = data.item.prefab
        for _, filter_item in ipairs(FILTER_ITEMS) do
            if item_prefab == filter_item then
                print("[KillerBee Event] 🚫 销毁杀人蜂掉落的附魔石: " .. tostring(item_prefab))
                data.item:Remove()
                break
            end
        end
    end)
    print("[KillerBee Event] 杀人蜂事件过滤加载完成")
end)
`
### 变体演进：移除BOSS间仇恨 (Mod 2819087689)
- **变体场景与切面**：收录来自工坊 Mod 2819087689 (`移除BOSS间仇恨`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2819087689)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:combat
AddComponentPostInit("combat",CombatPostInit)
-- 大触手不打BOSS
AddPrefabPostInit("bigshadowtentacle", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:AddTag("epic")
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:bigshadowtentacle
-- 大触手不打BOSS
AddPrefabPostInit("bigshadowtentacle", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:AddTag("epic")
end)
`
### 变体演进：小恶魔plus (Mod 3730144014)
- **变体场景与切面**：收录来自工坊 Mod 3730144014 (`小恶魔plus`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3730144014)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:wortox_soul_spawn
`
--------------------------------------------------------------------------
AddPrefabPostInit("wortox_soul_spawn", function(inst)
  if not GLOBAL.TheWorld.ismastersim then
    return
  end
  inst.SoulSpearTick = SoulSpearTick
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wortox_soul
--------------------------------------------------------------------------
AddPrefabPostInit("wortox_soul", function(inst)
  if not GLOBAL.TheWorld.ismastersim then
    return
  end
  inst:ListenForEvent("ondropped", function(inst)
    if not GetModConfigData("BOMB_ENABLED") then
      return
    end
    -- 取消原版治疗+移除定时器
    if inst._task then
      inst._task:Cancel()
      inst._task = nil
    end
    -- 禁止拾取
    if inst.components.inventoryitem then
      inst.components.inventoryitem.canbepickedup = false
    end
    -- 1秒后治疗，治疗完毕立即爆炸
    inst._task = inst:DoTaskInTime(TUNING.WORTOX_SOUL_HEAL_DELAY, function()
      inst._task = nil
      wortox_soul_common.DoHeal(inst)
      local x, y, z = inst.Transform:GetWorldPosition()
      GLOBAL.SpawnPrefab("explode_small").Transform:SetPosition(x, y, z)
      -- 镜头闪白 + 震动（参考火药爆炸效果）
      for _, player in ipairs(GLOBAL.AllPlayers) do
        local distSq = player:GetDistanceSqToInst(inst)
        local k = math.max(0, math.min(1, distSq / 400))
        local intensity = k * 0.75 * (k - 2) + 0.75
        if intensity > 0 then
          player:ScreenFlash(intensity)
          player:ShakeCamera(GLOBAL.CAMERASHAKE.FULL, .7, .02, intensity / 2)
        end
      end
      -- 范围爆炸伤害
      local ents = GLOBAL.TheSim:FindEntities(x, y, z, TUNING.GUNPOWDER_RANGE, { "_combat", "_health" }, { "INLIMBO", "player" })
      for _, ent in ipairs(ents) do
        if ent ~= inst and ent:IsValid() and not ent:IsInLimbo()
            and ent.components.health and not ent.components.health:IsDead()
            and ent.components.combat and ent.components.combat:CanBeAttacked() then
          local dmg = TUNING.GUNPOWDER_DAMAGE
          if ent.components.explosiveresist then
            dmg = dmg * (1 - ent.components.explosiveresist:GetResistance())
            ent.components.explosiveresist:OnExplosiveDamage(dmg, inst)
          end
          ent.components.combat:GetAttacked(inst, dmg)
        end
      end
      inst:Remove()
    end)
  end)
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
-- 阻止未受挑衅的中立生物主动攻击带 buff 的沃托克斯
AddComponentPostInit("combat", function(self)
  local _CanTarget = self.CanTarget
  self.CanTarget = function(combat, target)
    if target and target:HasTag(GLOMGOOP_BUFF_TAG) then
      local recent_threshold = 5
      if combat.last_hitby ~= target or (GLOBAL.GetTime() - (combat.last_hitby_time or 0)) > recent_threshold then
        return false
      end
    end
    return _CanTarget(combat, target)
  end
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:pigman
-- pigman 的拒绝逻辑在 onaccept 回调 (OnGetItemFromPlayer) 中检查 giver:HasTag("monster")
AddPrefabPostInit("pigman", function(inst)
  if not GLOBAL.TheWorld.ismastersim then return end
  local trader = inst.components.trader
  if trader then
    local _OnAccept = trader.onaccept
    trader.onaccept = function(inst, giver, item)
      if giver and giver:HasTag(GLOMGOOP_BUFF_TAG) then
        return TemporarilyHideDemon(giver, _OnAccept, inst, giver, item)
      end
      return _OnAccept(inst, giver, item)
    end
  end
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:pigking
-- pigking 在 trader.test 中检查给予者标签
AddPrefabPostInit("pigking", function(inst)
  if not GLOBAL.TheWorld.ismastersim then return end
  local trader = inst.components.trader
  if trader then
    local _Test = trader.test
    trader.test = function(inst, item, giver)
      if giver and giver:HasTag(GLOMGOOP_BUFF_TAG) then
        return TemporarilyHideDemon(giver, _Test, inst, item, giver)
      end
      return _Test(inst, item, giver)
    end
  end
end)
### 变体演进：Roman (Mod 3820783686)
- **变体场景与切面**：收录来自工坊 Mod 3820783686 (`Roman`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820783686)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:eater
AddComponentPostInit("eater", function(self)
	function self:SetCanEatShadows()
		table.insert(self.preferseating, FOODTYPE.SHADOW)
		table.insert(self.caneat, FOODTYPE.SHADOW)
		self.inst:AddTag(FOODTYPE.SHADOW.."_eater")
	end
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:nightmarefuel
AddPrefabPostInit("nightmarefuel", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.SHADOW
	inst.components.edible.healthvalue = 0--CHANGE THESE 3 VALUES TO ANYTHING YOU WANT
	inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = -10
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
AddComponentPostInit("combat",function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    local oldbonusdamagefn = inst.bonusdamagefn
    inst.bonusdamagefn = function(attacker, target, damage, weapon)
        local bonus = 0
        if oldbonusdamagefn then
            bonus = oldbonusdamagefn(attacker, target, damage, weapon) or 0
        end
        -- things above are just for compatibility
        -- notice that shadow chesspieces has no "shadow" or "shadowcreature" tag
        if target.prefab == CHARACTER_PREFAB and (attacker:HasTag("shadow") or attacker:HasTag("shadowchesspiece")) then
            bonus = bonus - (damage + bonus) * DAMAGE_RESISTENCE
        end
        return bonus
    end
end)
`
### 变体演进：Better Skill Affinity Wortox (Mod 3721858089)
- **变体场景与切面**：收录来自工坊 Mod 3721858089 (`Better Skill Affinity Wortox`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3721858089)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:voidcloth_scythe
AddPrefabPostInit("voidcloth_scythe", function(inst)
    if not GLOBAL.TheWorld or not GLOBAL.TheWorld.ismastersim then
      return
    end
    inst:DoTaskInTime(0, function()
        if inst.components.weapon == nil then
            return
        end
        inst.components.weapon:SetOnAttack(function(inst, attacker, target)
            TryToSparkOn(target, attacker)
            if attacker ~= nil
                and attacker.components ~= nil
                and attacker.components.skilltreeupdater
                and attacker.components.skilltreeupdater:IsActivated("wortox_allegiance_shadow")
                and attacker.finishportalhoptask ~= nil
            then
                -- 50% chance
                if math.random() < 0.5 then
                    attacker:TryToPortalHop(1, false)
                end
                -- AoE da arma (sua versão custom)
                inst:DoShadowAoE(attacker, target)
            end
        end)
    end)
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
AddComponentPostInit("combat", function(self)
    local old = self.GetAttacked
    function self:GetAttacked(attacker, damage, weapon, stimuli, ...)
        local inst = self.inst
        if inst == nil or inst.components == nil then
            return old(self, attacker, damage, weapon, stimuli, ...)
        end
        local inv = inst.components.inventory
        if inst:HasTag("player")
            and not HasLunarSet(inst)
            and HasLunarAffiliation(inst)
            and inst.finishportalhoptask ~= nil
        then
            -- BLOQUEIA DANO
            damage = 0
            inst.components.health:DoDelta(0)
            inst:PushEvent("wortox_lunar_blocked", {
                attacker = attacker,
                weapon = weapon
            })
            inst:TryToPortalHop(1, false)
            return old(self, attacker, 0, weapon, stimuli, ...)
        end
        return old(self, attacker, damage, weapon, stimuli, ...)
    end
end)
`
### 变体演进：Wurt And Merm AI Tweaks (Mod 2070498017)
- **变体场景与切面**：收录来自工坊 Mod 2070498017 (`Wurt And Merm AI Tweaks`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2070498017)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:merm
if smarter_merm then
	AddPrefabPostInit("merm", SmarterMerm)
	AddPrefabPostInit("mermguard", SmarterMerm)
end
require "behaviours/runaway"
local RunAway = GLOBAL.RunAway
local dodgechance = GetModConfigData('MERM_EPIC_DODGE_CHANCE')
local function DumpBT(bnode, indent)
	local s = ""
	for i=1,indent do
		s = s.."|   "
	end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:mermguard
	AddPrefabPostInit("merm", SmarterMerm)
	AddPrefabPostInit("mermguard", SmarterMerm)
end
require "behaviours/runaway"
local RunAway = GLOBAL.RunAway
local dodgechance = GetModConfigData('MERM_EPIC_DODGE_CHANCE')
local function DumpBT(bnode, indent)
	local s = ""
	for i=1,indent do
		s = s.."|   "
	end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:mermbrain
if smarter_merm then
	AddBrainPostInit('mermbrain', BetterMermBrain)
	AddBrainPostInit('mermguardbrain', BetterMermBrain)
end
local easing = require('easing')
local function WurtSanityFn(inst)
	-- Negate moisture sanity loss + a bit gain
	local moisturedelta = -easing.inSine(
		inst.components.moisture:GetMoisture(),
		0,
		TUNING.MOISTURE_SANITY_PENALTY_MAX,
		inst.components.moisture:GetMaxMoisture()
	) + easing.inSine(
		inst.components.moisture:GetMoisture(),
		0,
		TUNING.SANITYAURA_SMALL_TINY,
		inst.components.moisture:GetMaxMoisture()
	)
	local overheatdelta = 0
	if inst.components.temperature:IsOverheating() then
		overheatdelta = -TUNING.SANITYAURA_MED
	end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:mermguardbrain
	AddBrainPostInit('mermbrain', BetterMermBrain)
	AddBrainPostInit('mermguardbrain', BetterMermBrain)
end
local easing = require('easing')
local function WurtSanityFn(inst)
	-- Negate moisture sanity loss + a bit gain
	local moisturedelta = -easing.inSine(
		inst.components.moisture:GetMoisture(),
		0,
		TUNING.MOISTURE_SANITY_PENALTY_MAX,
		inst.components.moisture:GetMaxMoisture()
	) + easing.inSine(
		inst.components.moisture:GetMoisture(),
		0,
		TUNING.SANITYAURA_SMALL_TINY,
		inst.components.moisture:GetMaxMoisture()
	)
	local overheatdelta = 0
	if inst.components.temperature:IsOverheating() then
		overheatdelta = -TUNING.SANITYAURA_MED
	end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wurt
if enable then
	AddPrefabPostInit('wurt', WurtMod)
end
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local NUMBERFONT = GLOBAL.NUMBERFONT
local ANCHOR_MIDDLE = GLOBAL.ANCHOR_MIDDLE
local MermKingStatus = Class(Widget, function(self, owner, name)
	Widget._ctor(self, "MermKingStatus")
    self.owner = owner
	self.name = name
	self:SetScale(1, 1, 1)
	self.hunger_num = self:AddChild(Text(NUMBERFONT, 25))
	self.hunger_num:SetHAlign(ANCHOR_MIDDLE)
	self.hunger_num:SetPosition(3, 10, 0)
	self.health_num = self:AddChild(Text(NUMBERFONT, 25))
	self.health_num:SetHAlign(ANCHOR_MIDDLE)
	self.health_num:SetPosition(3, -10, 0)
end)
`
### 变体演进：伤害显示 (Mod 2952056856)
- **变体场景与切面**：收录来自工坊 Mod 2952056856 (`伤害显示`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2952056856)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:health
AddComponentPostInit("health", function(Health, inst)
	inst:ListenForEvent("healthdelta", function(inst, data)
		if inst.components.health then
			local amount = data.newpercent * inst.components.health.maxhealth - data.oldpercent * inst.components.health.maxhealth
			if data.amount and math.abs(data.amount) < math.abs(amount) then
				amount = data.amount
			end
			if amount == 0 then
				return
			end
			if math.abs(amount) > TUNING.SHOW_NUMBERS_THRESHOLD then
				if not (TUNING.SHOW_DAMAGE_ONLY and amount > 0) then
					local CDI = GLOBAL.SpawnPrefab("dmgind")
					CDI.Transform:SetPosition(inst.Transform:GetWorldPosition())
					CDI.isheal:set_local(false)
					CDI.isheal:set(amount > 0)
					CDI.indicator:set_local(0)
					CDI.indicator:set(math.abs(amount))
				end
			end
		end
	end)
end)
`
### 变体演进：受到任何伤害都被击飞！ (Mod 3723296222)
- **变体场景与切面**：收录来自工坊 Mod 3723296222 (`受到任何伤害都被击飞！`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3723296222)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:combat
    -- 新版普通攻击直接调用内部入口；仅包装一层，避免外层转发时重复击飞。
    AddComponentPostInit('combat', function(self)
        local getAttackedName = self.GetAttacked_Internal ~= nil and "GetAttacked_Internal" or "GetAttacked"
        local _GetAttacked = self[getAttackedName]
        self[getAttackedName] = function(self, attacker, damage, weapon, stimuli, spdamage, ...)
            KOO_knockover(attacker, self.inst)
            return _GetAttacked(self, attacker, damage, weapon, stimuli, spdamage, ...)
        end
    end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:health
    --hook health 的dodelta函数
    AddComponentPostInit('health', function(self)
        local _DoDelta = self.DoDelta
        function self:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
            if amount < 0 and cause ~= "drowning" and self.inst:IsValid() then
                KOO_knockover(afflicter, self.inst)
            end
            return _DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        end
    end)
`
### 变体演进：显示攻击范围 [Display Attack Range] (Mod 3756859423)
- **变体场景与切面**：收录来自工坊 Mod 3756859423 (`显示攻击范围 [Display Attack Range]`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3756859423)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:combat
-- Register postinits
AddComponentPostInit("combat", function(self, inst)
    if GLOBAL.TheSim:GetGameID() == "DST" then
        if GLOBAL.TheWorld.ismastersim then
            DidCombat(self)
        end
    else
        -- DS single-player
        DidCombat(self)
    end
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:projectile
AddComponentPostInit("projectile", function(self, inst)
    if not GetModConfigData("Projectile") then return end
    if GLOBAL.TheSim:GetGameID() == "DST" then
        if GLOBAL.TheWorld.ismastersim then
            DidProjectile(self)
        end
    else
        DidProjectile(self)
    end
end)
`
### 变体演进：null (Mod 3620271154)
- **变体场景与切面**：收录来自工坊 Mod 3620271154 (`null`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3620271154)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:health
	end
	AddComponentPostInit("health", function(self, inst)
		inst:ListenForEvent("healthdelta", function(inst)
			if check_in_player_range(inst) then
				local current_hp, max_hp = self.currenthealth, self.maxhealth
				if current_hp and max_hp then
					showme_health:GiveHealthBar_insight(inst, tonumber(current_hp), tonumber(max_hp),
						current_hp .. max_hp)
				end
			end
		end)
	end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified
end)
AddPrefabPostInit("player_classified", function(inst)
	if not showme_health.showme then return end
	inst:ListenForEvent("showme_hint_dirty2", function(inst)
		showme_health:ShowMeHintDirty(inst.net_showme_hint2:value())
	end)
end)
`
### 变体演进：世界生成兼容 (Mod 3798999176)
- **变体场景与切面**：收录来自工坊 Mod 3798999176 (`世界生成兼容`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3798999176)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:combat
local function InstallCombatReplicaGuard()
    AddComponentPostInit("combat", function(combat)
        if combat == nil or combat._wgc_set_last_target_guarded then
            return
        end
        local original_set_last_target = combat.SetLastTarget
        if type(original_set_last_target) ~= "function" then
            return
        end
        combat._wgc_set_last_target_guarded = true
        combat.SetLastTarget = function(self, target)
            local valid_target = target ~= nil and target:IsValid()
            self.lasttargetGUID = valid_target and target.GUID or nil
            local replica = self.inst ~= nil and self.inst.replica or nil
            if replica == nil or replica.combat == nil then
                return
            end
            replica.combat:SetLastTarget(valid_target and target or nil)
        end
    end)
end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:chimineafire
    -- melter scales the effective snow-clearing radius with the flame level.
    AddPrefabPostInit("chimineafire", function(inst)
        AddWinterlandsSnowMelter(inst, GetWinterlandsSnowRange(1))
    end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:obsidianfirefire
    -- scaling as a normal firepit, but give it a 25% larger base range.
    AddPrefabPostInit("obsidianfirefire", function(inst)
        AddWinterlandsSnowMelter(inst, GetWinterlandsSnowRange(1.25))
    end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:polarbear
if MAMMOTH_PEACE_ENABLED then
    AddPrefabPostInit("polarbear", InstallPolarBearMammothCompatibility)
end
-- Track both forms; vanilla transfers the paired targets on every swap.
local cave_link = require("wgc_cave_link")
if CAVE_FUSION_ENABLED then
    AddPrefabPostInit("tentacle_pillar", cave_link.Attach)
    AddPrefabPostInit("tentacle_pillar_hole", cave_link.Attach)
end
local function PairFusionCaveHoles()
    if not CAVE_FUSION_ENABLED
        or _G.TheWorld == nil
        or not _G.TheWorld.ismastersim
        or not _G.TheWorld:HasTag("cave") then
        return
    end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:tentacle_pillar
if CAVE_FUSION_ENABLED then
    AddPrefabPostInit("tentacle_pillar", cave_link.Attach)
    AddPrefabPostInit("tentacle_pillar_hole", cave_link.Attach)
end
local function PairFusionCaveHoles()
    if not CAVE_FUSION_ENABLED
        or _G.TheWorld == nil
        or not _G.TheWorld.ismastersim
        or not _G.TheWorld:HasTag("cave") then
        return
    end
`
### 变体演进：Abigail Attack Shadow Creature (Mod 2337896196)
- **变体场景与切面**：收录来自工坊 Mod 2337896196 (`Abigail Attack Shadow Creature`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2337896196)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddPrefabPostInit:abigail
AddPrefabPostInit("abigail", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	local function wendyinsane(inst)
		if inst._playerlink ~= nil and inst._playerlink.components.sanity:IsInsane() then
			inst:AddTag("crazy")
		else
			inst:RemoveTag("crazy") 
		end
	end
	local function OnKill(inst, data)
		local victim = data.victim
		if victim and victim:HasTag("shadow") then
			if inst._playerlink ~= nil and victim.sanityreward ~= nil then
				inst._playerlink.components.sanity:DoDelta(victim.sanityreward / SANITY_REWARD)
			end
		end
	end
	if ATTACK_SHADOW == 1 then
		inst:AddTag("crazy")
	elseif ATTACK_SHADOW == 2 then
		inst:DoPeriodicTask(1, wendyinsane)
	end
	inst:ListenForEvent("killed", OnKill)
end)
--Code by ptr from klei forum
AddComponentPostInit("combat", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    local oldbonusdamagefn = inst.bonusdamagefn
    inst.bonusdamagefn = function(attacker, target, damage, weapon)
        local bonus = 0
        if oldbonusdamagefn then
            bonus = oldbonusdamagefn(attacker, target, damage, weapon) or 0
        end
		--abigail damage 50% resist damage
		if target.prefab == "abigail" and (attacker:HasTag("shadow") or attacker:HasTag("shadowchesspiece")) then
            bonus = bonus - (damage + bonus) * RESIST_DAMAGE
        end
		--abigail damage reduce 20%
		if attacker.prefab == "abigail" and (target:HasTag("shadow")) then
            bonus = bonus - (damage + bonus) * DAMAGE_REDUCTION
        end
        return bonus
    end
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
--Code by ptr from klei forum
AddComponentPostInit("combat", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    local oldbonusdamagefn = inst.bonusdamagefn
    inst.bonusdamagefn = function(attacker, target, damage, weapon)
        local bonus = 0
        if oldbonusdamagefn then
            bonus = oldbonusdamagefn(attacker, target, damage, weapon) or 0
        end
		--abigail damage 50% resist damage
		if target.prefab == "abigail" and (attacker:HasTag("shadow") or attacker:HasTag("shadowchesspiece")) then
            bonus = bonus - (damage + bonus) * RESIST_DAMAGE
        end
		--abigail damage reduce 20%
		if attacker.prefab == "abigail" and (target:HasTag("shadow")) then
            bonus = bonus - (damage + bonus) * DAMAGE_REDUCTION
        end
        return bonus
    end
end)
`
### 变体演进：Health Bar and Buff - Client (Mod 2316507379)
- **变体场景与切面**：收录来自工坊 Mod 2316507379 (`Health Bar and Buff - Client`) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2316507379)
-- ============================================================================
local GLOBAL = GLOBAL
-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit(
    "playercontroller",
    function(self, inst)
        if inst ~= GLOBAL.ThePlayer then
            return
        end
        ThePlayer = GLOBAL.ThePlayer
        local function ModLefc(act)
            if act.action == ACTIONS.EAT then
                local item = ThePlayer.replica.inventory:GetActiveItem()
                InsertFood(item)
            elseif act.action == ACTIONS.GIVE and act.target.prefab == "beefalo" and #BeefFood == 0 then
				local item = ThePlayer.replica.inventory:GetActiveItem()
				local Spoil = GetPerishValue(item)
                InsertBeefFood(item, act.target,Spoil)
			elseif act.action == ACTIONS.BRUSH and act.target.prefab == "beefalo" and #BeefFood == 0 then
				if act.target.BeefWiget then act.target.BeefWiget:OnBrushed() end
			end
            return false
        end
        local PlayerControllerOnLeftClick = self.OnLeftClick
        self.OnLeftClick = function(self, down)
            local act = self:GetLeftMouseAction()
            if act then
                ModLefc(act)
            end
            return PlayerControllerOnLeftClick(self, down)
        end
        ThePlayer.PreviousAnimTimer = 0
        ThePlayer.PreviousAnim = ""
        ThePlayer.RecordedAnim = false
        ThePlayer.StartedAttack = false
        ThePlayer:DoPeriodicTask(GLOBAL.FRAMES, AnimationRecordMain)
    end
)
AddPlayerPostInit(
    function(inst)
        if inst ~= nil and inst ~= GLOBAL.ThePlayer then
            inst:DoTaskInTime(
                0,
                function(inst)
                    if inst:HasTag("player") and inst ~= GLOBAL.ThePlayer then
                        inst.PreviousAnimTimer = 0
                        inst.PreviousAnim = ""
                        inst.RecordedAnim = false
                        inst.StartedAttack = false
                        inst:DoPeriodicTask(GLOBAL.FRAMES, AnimationRecordSub)
                    end
                end
            )
        end
    end
)
AddClassPostConstruct(
    "components/inventory_replica",
    function(self)
        local InFromTile = self.UseItemFromInvTile
        self.UseItemFromInvTile = function(self, item)
            InsertFood(item)
            InFromTile(self, item)
        end
    end
)
local function ShowHp()
    local ents = GLOBAL.Ents
    for i, ent in pairs(ents) do
        if MobList[ent.prefab] ~= nil then
            AddInst(ent)
        end
    end
end
local function HideHp()
    for inst, data in pairs(MonitorList) do
        if data.Timer > 0 then
            data.Timer = 0
            data.Enti:Hide()
        end
    end
end
local function Switch(Label)
    MdEnable = not MdEnable
    HideHp()
end
local function AddIndicator(self)
    local original_CreateOverlays = self.CreateOverlays
    local original_OnMouseButton = self.OnMouseButton
    -- normalize position in logic coords game, default center screen
    local Buffpos = {x = 0, y = 0, hanchor = GLOBAL.ANCHOR_RIGHT, vanchor = GLOBAL.ANCHOR_BOTTOM}
    local Controlpos = {x = 0, y = 0, hanchor = GLOBAL.ANCHOR_LEFT, vanchor = GLOBAL.ANCHOR_TOP}
    self.CreateOverlays = function(owner)
        original_CreateOverlays(self, self.owner)
        --BuffEffect
        self.buffeffect = self.under_root:AddChild(Widget("buffeffect_root"))
        self.buffeffect:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
        self.buffeffect:SetHAnchor(Buffpos.hanchor)
        self.buffeffect:SetVAnchor(Buffpos.vanchor)
        self.buffeffect:SetPosition(Buffpos.x, Buffpos.y)
        self.buffeffect = self.buffeffect:AddChild(buffeffect())
        self.buffeffect:SetScale(1)
        SignBuff = self.buffeffect
        --ModSETTING
        if inbut then
            self.sccontrol = self.under_root:AddChild(Widget("sccontrol_root"))
            self.sccontrol:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
            self.sccontrol:SetHAnchor(Controlpos.hanchor)
            self.sccontrol:SetVAnchor(Controlpos.vanchor)
            self.sccontrol:SetPosition(Controlpos.x, Controlpos.y)
            self.sccontrol = self.sccontrol:AddChild(sccontrol())
            self.sccontrol:SetScale(1)
            self.sccontrol:Install(modname)
            self.sccontrol.OnReconfig = ReConfig
            self.sccontrol.ShowHp = ShowHp
            self.sccontrol.HideHp = HideHp
            self.sccontrol.Switch = Switch
            SignControl = self.sccontrol
        end
    end
end
AddClassPostConstruct("screens/playerhud", AddIndicator)
local AbiAtk = {
    "attack1_loop",
    "attack2_loop",
    "attack3_loop",
    "attack1_pre",
    "attack2_pre",
    "attack3_pre"
}
local function EXtend(inst)
    if inst.AbiDmgBuff ~= nil then
        inst.AbiDmgBuff:Cancel()
    end
    inst.AbiDmgBuff =
        inst:DoTaskInTime(
        TUNING.ABIGAIL_VEX_DURATION,
        function()
            inst.AbiDbuff = false
        end
    )
end
local function validfn(inst, target)
    if target:HasTag("player") or target:HasTag("ghost") or target:HasTag("noauradamage") then
        return false
    end
    if MobList[target.prefab] and not MobList[target.prefab].AbiFriend then
        return true
    end
    return false
end
local auraexcludetags = {
    "noauradamage",
    "INLIMBO",
    "notarget",
    "noattack",
    "flight",
    "invisible",
    "playerghost",
    "shadowcreature",
    "companion"
}
local function DoAbiAttack(inst, damage)
    local range = 4
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, range, nil, auraexcludetags)
    for i, ent in ipairs(ents) do
        if ent ~= inst and validfn(inst, ent) then
            if not (ent.AnimState and ent.AnimState:IsCurrentAnimation("death")) or (not ent.Lasthit) then
                local dam = GetModifiDamage(damage, ent)
                if SummonShow == 3 then
                    SpawnDamage(ent, tostring(round(dam)), 1)
                end
                ent.AbiDbuff = true
                EXtend(ent)
                AddInst(ent, dam, SummonShow < 2)
            else
                ent.Lasthit = true
            end
        end
    end
end
local ABIGAIL_DAMAGE = {
    15,
    25,
    40
}
local function GetAbiDmg(dmg)
    return ABIGAIL_DAMAGE[dmg]
end
AddPrefabPostInit(
    "abigail_attack_fx",
    function(inst)
        local LastRecordTick = nil
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                local Animz = true
                for i, animate in ipairs(AbiAtk) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        local CurTime = GLOBAL:GetTime()
                        if LastRecordTick == nil then
                            LastRecordTick = CurTime
                        end
                        local Ticks = round((CurTime - LastRecordTick) / GLOBAL.FRAMES)
                        if Ticks % 29 == 0 then
                            local dmg = GetAbiDmg((i - 1) % 3 + 1)
                            DoAbiAttack(inst, dmg)
                        end
                        Animz = false
                    end
                end
                if Animz then
                    LastRecordTick = nil
                end
            end
        )
    end
)
local function ShadowLevelItem(inst)
    if inst then
        if not WPFetch:IsInCache(inst) then
            WPFetch:AddItemToCache(inst)
        end
    end
    if inst.prefab then
        local Durability =
            inst.replica.inventoryitem.classified.percentused or inst.replica.inventoryitem.classified.perish or
            inst.replica.inventoryitem.classified.recharge or
            inst.replica.inventoryitem.classified.rechargetime
        if Durability ~= nil and Durability:value() == 0 then
            return 0
        end
    end
    local ShadowLevel = WPFetch:GetShadowLevel(inst) or 0
    return ShadowLevel
end
local function GetShadowLevel(owner)
    if owner == nil then
        return 0
    end
    local userid = owner.userid
    local data = TheNet:GetClientTableForUser(userid)
    local Lv = 0
    if owner.userid == ThePlayer.userid then
        for slot, body in pairs(EQUIPSLOTS) do
            ItemDta = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(body)
            if ItemDta then
                local Itm = ItemDta.prefab
                if Itm then
					if Itm == "tophat" then
						if owner.ShadowHat then Lv = Lv + TUNING.MAGICIAN_TOPHAT_SHADOW_LEVEL end
					else 
						local Tlv = ShadowLevelItem(Itm) or TUNING[string.upper(Itm) .. "_SHADOW_LEVEL"] or 0
						Lv = Lv + Tlv
					end
				end
            end
        end
        return Lv
    elseif owner ~= nil and owner.prefab == "waxwell" then
        for i = 1, require("equipslotutil").Count() do
            if data.equip[i] then
                local EquipString = string.gsub(data.equip[i], "%s+", "")
                if EquipString ~= "" then
                    local Itm = GetPrefabFromSkin(EquipString) or EquipString
                    if Itm then
						if Itm == "tophat" then
							if owner.ShadowHat then Lv = Lv + TUNING.MAGICIAN_TOPHAT_SHADOW_LEVEL end
						else 
							local Tlv = ShadowLevelItem(Itm) or TUNING[string.upper(Itm) .. "_SHADOW_LEVEL"] or 0
							Lv = Lv + Tlv
						end
                    end
                end
            end
        end
        return Lv
    else
        return 0
    end
end
local ShadowPre = {
    "atk_pre",
    "lunge_pre",
    "emerge"
}
local ShadowAtk = {
    "atk",
    "lunge_loop",
    "atk_loop"
}
local function IsNearTarget(inst, target, range)
	if inst.Transform and target.Transform then
		return inst:IsNear(target, range + target:GetPhysicsRadius(0))
	end
	return false
end
local function IsLeaderNear(inst, leader, target, range)
	if inst.Transform and leader.Transform then
		return inst:IsNear(leader, range) or (target ~= nil and IsNearTarget(leader, target, range))
	end
	return false
end
AddPrefabPostInit(
    "shadowprotector",
    function(inst)
        inst.StartedAttack = false
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                if inst.replica.combat:GetTarget() ~= nil then
                    inst.TheTarget = inst.replica.combat:GetTarget()
                end
                local Target = inst.replica.combat:GetTarget() or inst.TheTarget
                local Owner
                if inst.replica.follower then
                    Owner = inst.replica.follower:GetLeader()
                end
                for i, animate in ipairs(ShadowPre) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        inst.StartedAttack = true
                    end
                end
                for i, animate in ipairs(ShadowAtk) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        local frameCount = 3
                        local DmgMult = 1
                        if animate == "lunge_loop" then
                            frameCount = 3
                            DmgMult = 1.5
                        end
                        if
                            inst.AnimState:GetCurrentAnimationTime() > GLOBAL.FRAMES * frameCount and inst.StartedAttack and
                                Target and
                                (not PredictHit or CanHit(inst.replica.combat, Target))
                         then
                            local Damg = TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE
                            if Owner ~= nil and Owner.entity then
                                if
                                    IsLeaderNear(
                                        inst,
                                        Owner,
                                        Target,
                                        TUNING.SHADOWWAXWELL_PROTECTOR_SHADOW_LEADER_RADIUS
                                    )
                                 then
                                    Damg =
                                        (TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE +
                                        TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE_BONUS_PER_LEVEL * GetShadowLevel(Owner))
                                end
                            end
                            Damg = DmgMult * Damg
                            Damg = GetModifiDamage(Damg, Target)
							if Target.AbiDbuff then
								Damg = Damg * TUNING.ABIGAIL_VEX_DAMAGE_MOD
							end
                            if SummonShow == 3 then
                                SpawnDamage(Target, tostring(round(Damg)), 1)
                            end
                            AddInst(Target, Damg, SummonShow < 2)
                            inst.StartedAttack = false
                        end
                    end
                end
            end
        )
    end
)
AddPrefabPostInit(
    "tophat_shadow_fx",
    function(inst)
        inst:DoTaskInTime(
            GLOBAL.FRAMES,
            function()
                local Summonner =  GLOBAL.FindEntity(inst,2,function(bff)
					return (bff.prefab == "waxwell" ) 
					end,nil,{ "INLIMBO", "noauradamage" })	
				if Summonner then Summonner.ShadowHat = true end
				inst:ListenForEvent("onremove", function()
					if Summonner then Summonner.ShadowHat = false end
				end)
            end
        )
    end
)
AddPrefabPostInit(
    "alterguardianhat_projectile",
    function(inst)
        inst.StartedAttack = true
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                if inst.replica.combat:GetTarget() ~= nil then
                    inst.TheTarget = inst.replica.combat:GetTarget()
                end
                if inst.TheTarget == nil and inst.replica.follower then
                    local Owner = inst.replica.follower:GetLeader()
                    if Owner and Owner.replica.combat then
                        inst.TheTarget = Owner.replica.combat:GetTarget()
                    end
                end
                local Target = inst.replica.combat:GetTarget() or inst.TheTarget
                if inst.AnimState:IsCurrentAnimation("mutate") then
                    local frameCount = 2
                    if
                        inst.AnimState:GetCurrentAnimationTime() > GLOBAL.FRAMES * frameCount and inst.StartedAttack and
                            Target and
                            (not PredictHit or CanHit(inst.replica.combat, Target))
                     then
                        local Damg = TUNING.ALTERGUARDIANHAT_GESTALT_DAMAGE
                        Damg = GetModifiDamage(Damg, Target)
						if Target.AbiDbuff then
							Damg = Damg * TUNING.ABIGAIL_VEX_DAMAGE_MOD
						end
                        if SummonShow == 3 then
                            SpawnDamage(Target, tostring(round(Damg)), 1)
                        end
                        AddInst(Target, Damg, SummonShow < 2)
                        inst.StartedAttack = false
                    end
                end
            end
        )
    end
)
AddPrefabPostInit(
    "shadowtentacle",
    function(inst)
        inst.StartedAttack = 2
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                if inst.replica.combat:GetTarget() ~= nil then
                    inst.TheTarget = inst.replica.combat:GetTarget()
                end
                local Target = inst.replica.combat:GetTarget() or inst.TheTarget
                for i, animate in ipairs(ShadowPre) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        inst.StartedAttack = 0
                    end
                end
                for i, animate in ipairs(ShadowAtk) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        local CurFrame = math.floor(inst.AnimState:GetCurrentAnimationTime() / GLOBAL.FRAMES)
                        if
                            (CurFrame == 8 or CurFrame == 18) and inst.StartedAttack < 2 and Target and
                                (not PredictHit or CanHit(inst.replica.combat, Target))
                         then
                            local Damg = TUNING.TENTACLE_DAMAGE
                            Damg = GetModifiDamage(Damg, Target)
							if Target.AbiDbuff then
								Damg = Damg * TUNING.ABIGAIL_VEX_DAMAGE_MOD
							end
                            if SummonShow == 3 then
                                SpawnDamage(Target, tostring(round(Damg)), 1)
                            end
                            AddInst(Target, Damg, SummonShow < 2)
                            inst.StartedAttack = inst.StartedAttack + 1
                        end
                    end
                end
            end
        )
    end
)
AddPrefabPostInit(
    "lunarplanttentacle",
    function(inst)
        inst.StartedAttack = false
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                if inst.replica.combat:GetTarget() ~= nil then
                    inst.TheTarget = inst.replica.combat:GetTarget()
                end
                local Target = inst.replica.combat:GetTarget() or inst.TheTarget
				if inst.AnimState:IsCurrentAnimation("atk") then
					local CurFrame = math.floor(inst.AnimState:GetCurrentAnimationTime() / GLOBAL.FRAMES)
					if (CurFrame >= 15) and not inst.StartedAttack  and Target and (not PredictHit or CanHit(inst.replica.combat, Target)) then
						local Damg = TUNING.LUNARPLANTTENTACLE_DAMAGE
						Damg = GetModifiDamage(Damg, Target)
						if Target.AbiDbuff then
							Damg = Damg * TUNING.ABIGAIL_VEX_DAMAGE_MOD
						end
						if SummonShow == 3 then
							SpawnDamage(Target, tostring(round(Damg)), 1)
						end
						AddInst(Target, Damg, SummonShow < 2)
						local SpDamg = TUNING.LUNARPLANTTENTACLE_PLANARDAMAGE
						SpDamg = GetModifiDamage(SpDamg, Target, true)
						if SummonShow == 3 then
							SpawnDamage(Target, tostring(round(SpDamg)), 1)
						end
						AddInst(Target, SpDamg, SummonShow < 2)
						inst.StartedAttack = true
					end
				end
            end
        )
    end
)
AddPrefabPostInit(
    "beeguard",
    function(inst)
        inst.StartedAttack = false
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                if inst.replica.combat:GetTarget() ~= nil then
                    inst.TheTarget = inst.replica.combat:GetTarget()
                end
                local Target = inst.replica.combat:GetTarget() or inst.TheTarget
                if Target and Target:HasTag("player") then
                    return
                end
                if inst.AnimState:IsCurrentAnimation("atk") then
                    local frameCount = 13
                    if inst.AnimState:GetCurrentAnimationTime() < GLOBAL.FRAMES * 2 then
                        inst.StartedAttack = true
                    end
                    if
                        inst.AnimState:GetCurrentAnimationTime() > GLOBAL.FRAMES * frameCount and inst.StartedAttack and
                            Target and
                            (not PredictHit or CanHit(inst.replica.combat, Target))
                     then
                        local Damg = TUNING.BEEGUARD_DAMAGE
                        Damg = GetModifiDamage(Damg, Target)
						if Target.AbiDbuff then
							Damg = Damg * TUNING.ABIGAIL_VEX_DAMAGE_MOD
						end
                        if SummonShow == 3 then
                            SpawnDamage(Target, tostring(round(Damg)), 1)
                        end
                        AddInst(Target, Damg, SummonShow < 2)
                        inst.StartedAttack = false
                    end
                end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:abigail_attack_fx
AddPrefabPostInit(
    "abigail_attack_fx",
    function(inst)
        local LastRecordTick = nil
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                local Animz = true
                for i, animate in ipairs(AbiAtk) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        local CurTime = GLOBAL:GetTime()
                        if LastRecordTick == nil then
                            LastRecordTick = CurTime
                        end
                        local Ticks = round((CurTime - LastRecordTick) / GLOBAL.FRAMES)
                        if Ticks % 29 == 0 then
                            local dmg = GetAbiDmg((i - 1) % 3 + 1)
                            DoAbiAttack(inst, dmg)
                        end
                        Animz = false
                    end
                end
                if Animz then
                    LastRecordTick = nil
                end
            end
        )
    end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shadowprotector
AddPrefabPostInit(
    "shadowprotector",
    function(inst)
        inst.StartedAttack = false
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                if inst.replica.combat:GetTarget() ~= nil then
                    inst.TheTarget = inst.replica.combat:GetTarget()
                end
                local Target = inst.replica.combat:GetTarget() or inst.TheTarget
                local Owner
                if inst.replica.follower then
                    Owner = inst.replica.follower:GetLeader()
                end
                for i, animate in ipairs(ShadowPre) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        inst.StartedAttack = true
                    end
                end
                for i, animate in ipairs(ShadowAtk) do
                    if inst.AnimState:IsCurrentAnimation(animate) then
                        local frameCount = 3
                        local DmgMult = 1
                        if animate == "lunge_loop" then
                            frameCount = 3
                            DmgMult = 1.5
                        end
                        if
                            inst.AnimState:GetCurrentAnimationTime() > GLOBAL.FRAMES * frameCount and inst.StartedAttack and
                                Target and
                                (not PredictHit or CanHit(inst.replica.combat, Target))
                         then
                            local Damg = TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE
                            if Owner ~= nil and Owner.entity then
                                if
                                    IsLeaderNear(
                                        inst,
                                        Owner,
                                        Target,
                                        TUNING.SHADOWWAXWELL_PROTECTOR_SHADOW_LEADER_RADIUS
                                    )
                                 then
                                    Damg =
                                        (TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE +
                                        TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE_BONUS_PER_LEVEL * GetShadowLevel(Owner))
                                end
                            end
                            Damg = DmgMult * Damg
                            Damg = GetModifiDamage(Damg, Target)
							if Target.AbiDbuff then
								Damg = Damg * TUNING.ABIGAIL_VEX_DAMAGE_MOD
							end
                            if SummonShow == 3 then
                                SpawnDamage(Target, tostring(round(Damg)), 1)
                            end
                            AddInst(Target, Damg, SummonShow < 2)
                            inst.StartedAttack = false
                        end
                    end
                end
            end
        )
    end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:tophat_shadow_fx
AddPrefabPostInit(
    "tophat_shadow_fx",
    function(inst)
        inst:DoTaskInTime(
            GLOBAL.FRAMES,
            function()
                local Summonner =  GLOBAL.FindEntity(inst,2,function(bff)
					return (bff.prefab == "waxwell" ) 
					end,nil,{ "INLIMBO", "noauradamage" })	
				if Summonner then Summonner.ShadowHat = true end
				inst:ListenForEvent("onremove", function()
					if Summonner then Summonner.ShadowHat = false end
				end)
            end
        )
    end
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:alterguardianhat_projectile
AddPrefabPostInit(
    "alterguardianhat_projectile",
    function(inst)
        inst.StartedAttack = true
        inst:DoPeriodicTask(
            GLOBAL.FRAMES,
            function()
                if inst.replica.combat:GetTarget() ~= nil then
                    inst.TheTarget = inst.replica.combat:GetTarget()
                end
                if inst.TheTarget == nil and inst.replica.follower then
                    local Owner = inst.replica.follower:GetLeader()
                    if Owner and Owner.replica.combat then
                        inst.TheTarget = Owner.replica.combat:GetTarget()
                    end
                end
                local Target = inst.replica.combat:GetTarget() or inst.TheTarget
                if inst.AnimState:IsCurrentAnimation("mutate") then
                    local frameCount = 2
                    if
                        inst.AnimState:GetCurrentAnimationTime() > GLOBAL.FRAMES * frameCount and inst.StartedAttack and
                            Target and
                            (not PredictHit or CanHit(inst.replica.combat, Target))
                     then
                        local Damg = TUNING.ALTERGUARDIANHAT_GESTALT_DAMAGE
                        Damg = GetModifiDamage(Damg, Target)
						if Target.AbiDbuff then
							Damg = Damg * TUNING.ABIGAIL_VEX_DAMAGE_MOD
						end
                        if SummonShow == 3 then
                            SpawnDamage(Target, tostring(round(Damg)), 1)
                        end
                        AddInst(Target, Damg, SummonShow < 2)
                        inst.StartedAttack = false
                    end
                end
            end
        )
    end
`
