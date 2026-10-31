# 饥荒一线工坊深度研读 Skill：客户端协程动作队列与框选批量调度架构

- **工坊 ID**：1608191708 (`ActionQueue Reborn`)
- **领域分类**：客户端纯净预测（Client-Only）、协程流水线（Thread Coroutine）、动作队列安全步进、手控打断应急响应（Walk Interruption）
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“自动砍树、批量收割、一键修墙、自动走位攻击”等增强类 MOD 时，最安全稳定的架构是**纯客户端协程调度器**：
1. 客户端使用 `inst:StartThread` 维持可挂起循环，避免阻塞游戏主线程；
2. 动作发出后，等待角色进入对应的 StateGraph 动作帧再步进下一个；
3. 随时监听移动控制输入，按下移动键瞬间终止队列。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：纯客户端通用动作队列调度执行器 (scripts/tools/client_action_scheduler.lua)
-- ==============================================================================

local ClientActionScheduler = Class(function(self, inst)
    self.inst = inst
    self.queue = {}
    self.running_thread = nil
    self.is_active = false
end)

--- 压入一个预处理动作 (BufferedAction)
function ClientActionScheduler:Enqueue(act)
    if act and act:IsValid() then
        table.insert(self.queue, act)
    end
end

--- 清空队列并强行杀死执行协程
function ClientActionScheduler:Abort()
    self.queue = {}
    if self.running_thread then
        GLOBAL.KillThread(self.running_thread)
        self.running_thread = nil
    end
    self.is_active = false
end

--- 检查玩家是否正在手动按键移动 (急停打断检测)
function ClientActionScheduler:IsManualInterrupt()
    local controller = self.inst.components.playercontroller
    if controller and controller:IsEnabled() then
        -- 检测玩家是否有移动意图 (WASD 或手柄摇杆)
        return controller:IsAnyOfControlsPressed(
            GLOBAL.CONTROL_MOVE_UP,
            GLOBAL.CONTROL_MOVE_DOWN,
            GLOBAL.CONTROL_MOVE_LEFT,
            GLOBAL.CONTROL_MOVE_RIGHT
        )
    end
    return false
end

--- 启动协程执行动作管线
function ClientActionScheduler:Start()
    if self.running_thread or #self.queue == 0 then return end
    self.is_active = true

    self.running_thread = self.inst:StartThread(function()
        while #self.queue > 0 do
            -- 1. 手控急停打断检测
            if self:IsManualInterrupt() then
                self:Abort()
                break
            end

            -- 2. 取出队头动作
            local act = table.remove(self.queue, 1)

            -- 3. 校验实体合法性
            if act and act.target and act.target:IsValid() and not act.target:IsInLimbo() then
                -- 客户端向服务端下发动作意图
                local playercontroller = self.inst.components.playercontroller
                if playercontroller then
                    playercontroller:DoAction(act)
                end

                -- 4. 协程节流挂起：等待角色进入 Busy 动作帧或至少等待网络回包 (默认 0.15~0.25 秒)
                GLOBAL.Sleep(0.2)

                -- 5. 等待当前动作彻底完成 (Busy 状态解除)
                while self.inst.sg and self.inst.sg:HasStateTag("busy") do
                    if self:IsManualInterrupt() then
                        self:Abort()
                        return
                    end
                    GLOBAL.Sleep(0.05)
                end
            end
        end

        self.running_thread = nil
        self.is_active = false
    end)
end

return ClientActionScheduler
```

---

## 三、避坑与生产安全准则

1. **绝对禁止在主线程使用无挂起的 `while` 循环调度**：
   - 必须通过 `ThePlayer:StartThread` 启动协程，并在动作之间使用 `GLOBAL.Sleep()` 挂起。如果在主循环中直接 `while` 派发几十个动作，会导致游戏界面直接卡死，且服务端会判定高频发包为恶意攻击而断开客机连接。
2. **`IsInLimbo()` 目标状态检查**：
   - 目标实体可能在排队等待期间被队友捡走、被火烧掉或掉入虚空（InLimbo）。在 `DoAction` 之前，必须严格执行 `not act.target:IsInLimbo()`，否则会引发寻路模块访问空位置崩溃。


## 五、进阶拓扑演进与变体分支

### 变体演进：海钓随机物品 (Mod 2710978964)
- **变体场景与切面**：收录来自工坊 Mod 2710978964 (海钓随机物品) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2710978964)
-- ============================================================================
local GLOBAL = GLOBAL

    -- 2、 扩展mod 添加代码
    --[[AddPrefabPostInit("world", function(inst) 
        inst:DoTaskInTime(0,function() 
            if rawget(GLOBAL, "Set_OF_loot") then
                Set_OF_loot(function(t1,t2)
                    -- 向海钓原版 掉落物表添加新内容。
                    -- 事件表 添加自定义事件
                    table.insert(t1.events, {chance = 0.01, item = "fishingsurprised", name = "自定义事件名称", eventF = function() end})
                end)
            end 
        end) 
    end)]]
`


### 变体演进：Move!!Dragonfly (Mod 3670669065)
- **变体场景与切面**：收录来自工坊 Mod 3670669065 (Move!!Dragonfly) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3670669065，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

GlassicAPI.SetOnequipSkinItem = function(name, data)
	ENV.AddPrefabPostInit(name, set_onquip_skin_item(unpack(data)))
end

-- The common init fn for skinned prefabs.
--[[usage:
	CreatePrefabskin("skin_name", {
		...,
		init_fn = GlassicAPI.BasicInitFn,
		...,
	})
--]]
GlassicAPI.BasicInitFn = function(inst)
`


### 变体演进：真-神之火腿 (Mod 3684078343)
- **变体场景与切面**：收录来自工坊 Mod 3684078343 (真-神之火腿) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3684078343)
-- ============================================================================
local GLOBAL = GLOBAL

--人物皮肤的init_fn 和 clear_fn
AddComponentPostInit(
    'skinner',
    function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s, skinname, ...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst, old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst, new)
                end
                oldfn(s, skinname, ...)
            end
        end
    end
`


### 变体演进：真-神之火腿 (Mod 3705975335)
- **变体场景与切面**：收录来自工坊 Mod 3705975335 (真-神之火腿) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3705975335)
-- ============================================================================
local GLOBAL = GLOBAL

--人物皮肤的init_fn 和 clear_fn
AddComponentPostInit(
    'skinner',
    function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s, skinname, ...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst, old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst, new)
                end
                oldfn(s, skinname, ...)
            end
        end
    end
`


### 变体演进：小型拖拉机 (Mod 3748361628)
- **变体场景与切面**：收录来自工坊 Mod 3748361628 (小型拖拉机) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3748361628)
-- ============================================================================
local GLOBAL = GLOBAL

AddStategraphPostInit("wilson", function(self)
	local oldEAThandlers = self.actionhandlers[ACTIONS.EAT].deststate
	self.actionhandlers[ACTIONS.EAT].deststate = function(inst, action)
		local nowsg = inst.sg ~= nil and inst.sg.currentstate and inst.sg.currentstate.name
		if nowsg and nowsg == "tractor_sg" then
			inst:PushEvent("tractor_sg_eat")
			return "tractor_sg_eat" --实际上没这个sg
		end
		return oldEAThandlers(inst, action)
	end
	--ACTIONS.RUMMAGE
	local oldRUMMAGEhandlers = self.actionhandlers[ACTIONS.RUMMAGE].deststate
	self.actionhandlers[ACTIONS.RUMMAGE].deststate = function(inst, action)
		local nowsg = inst.sg ~= nil and inst.sg.currentstate and inst.sg.currentstate.name
		if nowsg and nowsg == "tractor_sg" then
			inst:PushEvent("tractor_sg_rummage")
			return "tractor_sg_rummage" --实际上没这个sg
		end
		return oldRUMMAGEhandlers(inst, action)
	end
	--ACTIONS.ACTION_OPEN_TRACTOR
	local oldACTION_OPEN_TRACTORhandlers = self.actionhandlers[ACTIONS.ACTION_OPEN_TRACTOR].deststate
	self.actionhandlers[ACTIONS.ACTION_OPEN_TRACTOR].deststate = function(inst, action)
		local nowsg = inst.sg ~= nil and inst.sg.currentstate and inst.sg.currentstate.name
		if nowsg and nowsg == "tractor_sg" then
			inst:PushEvent("tractor_sg_opencontainer")
			return "tractor_sg_ACTION_OPEN_TRACTOR" --实际上没这个sg
		end
		return oldACTION_OPEN_TRACTORhandlers(inst, action)
	end
end)
`


### 变体演进：远野汉娜 漂浮魔法 (Mod 3811163578)
- **变体场景与切面**：收录来自工坊 Mod 3811163578 (远野汉娜 漂浮魔法) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3811163578，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

local kind = name
    AddPrefabPostInit(kind, function(inst)
        if not TheWorld.ismastersim then return end
        inst:DoTaskInTime(0, function()
            if inst:IsValid() then Registry.AddTarget(kind, inst) end
        end)
        inst:ListenForEvent("onremove", function() Registry.RemoveTarget(kind, inst) end)
        if kind == "hermitcrab" then
            inst:ListenForEvent("friend_level_changed", function()
                local levels = inst.components.friendlevels
                if levels ~= nil then
                    for _, writer in pairs(Registry.writers) do writer:OnHermitLevel(levels:GetLevel()) end
                end
            end)
        end
    end)
`


### 变体演进：宁恩 (Mod 3814062294)
- **变体场景与切面**：收录来自工坊 Mod 3814062294 (宁恩) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814062294)
-- ============================================================================
local GLOBAL = GLOBAL

-- Server
AddStategraphPostInit(
	"wilson",
	function(sg)
		NingEnStates(sg)
	end
)

AddStategraphState("wilson", NingEnPreHop())

AddStategraphState("wilson", NingEnPostHop())

-- Client
AddStategraphPostInit(
	"wilson_client",
	function(sg)
`


### 变体演进：饥荒RPG (Mod 3820674954)
- **变体场景与切面**：收录来自工坊 Mod 3820674954 (饥荒RPG) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820674954，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

for _, prefab in ipairs(FRIDGE_PREFABS) do
	AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("modifier_enchantable")
		if not GLOBAL.TheWorld or not GLOBAL.TheWorld.ismastersim then
			return inst
		end

		if inst.components.modifier == nil then
			inst:AddComponent("modifier")
		end

		return inst
	end)
`


### 变体演进：[DST] Montfluv（the Sealed Abyss） (Mod 3825012187)
- **变体场景与切面**：收录来自工坊 Mod 3825012187 ([DST] Montfluv（the Sealed Abyss）) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3825012187，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

AddPrefabPostInit("world", function(inst)
    local map = getmetatable(inst.Map).__index
    if map == nil then
        return
    end

    local function realm_passable(x, y, z)
        return IsInShHollow(x, y, z)
    end

    local OldIsAboveGroundAtPoint = map.IsAboveGroundAtPoint
    map.IsAboveGroundAtPoint = function(self, x, y, z, ...)
        if realm_passable(x, y, z) then
            return true
        end
        return OldIsAboveGroundAtPoint(self, x, y, z, ...)
    end

    local OldIsPassableAtPoint = map.IsPassableAtPoint
    map.IsPassableAtPoint = function(self, x, y, z, ...)
        if realm_passable(x, y, z) then
            return true
        end
        return OldIsPassableAtPoint(self, x, y, z, ...)
    end

    local OldIsVisualGroundAtPoint = map.IsVisualGroundAtPoint
    map.IsVisualGroundAtPoint = function(self, x, y, z, ...)
        if realm_passable(x, y, z) then
            return true
        end
        return OldIsVisualGroundAtPoint(self, x, y, z, ...)
    end

    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("ms_playerdespawnanddelete", function(world, player)
        if player ~= nil and player._sh_hollow_focus ~= nil then
            player.sh_hollow_spawn_delete = true
            player._sh_hollow_focus:set(nil)
        end
    end)
end)
`


### 变体演进：咒终对决拓展 (Mod 3825229017)
- **变体场景与切面**：收录来自工坊 Mod 3825229017 (咒终对决拓展) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3825229017，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

AddPrefabPostInit("daywalker", function(inst)
    if not TheWorld.ismastersim then return end
    for _, loot in ipairs(LootTables["daywalker"]) do
        if loot[1] == "ud_dreadstonesword_blueprint" then return end
    end
    table.insert(LootTables["daywalker"], { "ud_dreadstonesword_blueprint", 1.0 })
end)
`


### 变体演进：Real Witch (Mod 3828396407)
- **变体场景与切面**：收录来自工坊 Mod 3828396407 (Real Witch) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3828396407)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("witchbroom", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	local _MakeLiving = inst.MakeLiving
	inst.MakeLiving = function(inst)
		_MakeLiving(inst)
		local owner = inst.components.inventoryitem.owner
		if owner ~= nil and owner.isplayer then
			QueueUpdate(owner)
		end
	end
end)

local Drownable = require("components/drownable")
`


### 变体演进：Cook (Mod 3829489944)
- **变体场景与切面**：收录来自工坊 Mod 3829489944 (Cook) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3829489944，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

if GetModConfigData("Fish") then
    AddPrefabPostInit("fishingrod", function(inst)
        local fr = inst.components.fishingrod
        if fr then
            if fr.waittime then
                fr.waittime = math.max(0.1, fr.waittime * 0.8)
            end
            if fr.reeltime then
                fr.reeltime = math.max(0.1, fr.reeltime * 0.8)
            end
        end
    end)
`



### 变体演进：杂草战争增强版 (Mod 2071037011)
- **变体场景与切面**：收录来自工坊 Mod 2071037011 (`杂草战争增强版`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2071037011)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:healthtrigger
AddReplicableComponent("scaler")
AddComponentPostInit("healthtrigger", function(self)
    self.AddTrigger = function(self, amount, fn, override)
        if self.triggers[amount] and not override then
            local _oldTriggerFN = self.triggers[amount]
            self.triggers[amount] = function(inst)
                _oldTriggerFN(inst)
                fn(inst)
            end
        else
            self.triggers[amount] = fn
        end
    end
    self.RemoveTrigger = function(self, amount)
        self.triggers[amount] = nil
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:scaler
end)
AddComponentPostInit("scaler", function(self)
    self.base_scale = 1
    self.damage_mult = 1
    self.current_scale = 1
    -- Physics Parameters
    self.base_rad = nil
    self.current_rad = nil
    self.current_height = nil
    self.base_mass = nil
    self.current_mass = nil
    self.base_shadow = nil
    self.current_shadow = nil
    self.source = nil

    -- Controls the rate at which these increase based on the given scale. Default is 1 to 1 with the scalar.
    self.rad_rate = 1
    self.height_rate = 1
    self.mass_rate = 1
    self.shadow_rate = 1
    self.inst.replica.scaler:SetScale(1)

    self.ApplyScale = function(self)
        local mults, adds, flats = self:GetScalerBuffs()
        self.scale = mults * adds -- + flats -- Not supporting flats for now
        self.inst.replica.scaler:SetScale(self.scale)
        self.current_scale = self.base_scale * self.scale
        self.inst.Transform:SetScale(self.current_scale,self.current_scale,self.current_scale)

        if self.base_rad then
            self.current_rad = self.base_rad * self.scale * self.rad_rate
            self.current_height = (self.base_height or 2) * self.scale * self.height_rate
            local pos = self.inst:GetPosition()
            self.inst.Physics:SetCapsule(self.current_rad, self.current_height)
            self.inst.Transform:SetPosition(pos:Get())
        end

        if self.base_mass then
            self.current_mass = self.base_mass * self.scale * self.mass_rate
            self.inst.Physics:SetMass(self.current_mass)
        end

        if self.base_shadow then
            self.current_shadow = {self.base_shadow[1] * self.scale * self.shadow_rate, self.base_shadow[2] * self.scale * self.shadow_rate}
            self.inst.DynamicShadow:SetSize(unpack(self.current_shadow))
        end

        if self.inst.components.combat then
            --self.inst.components.combat:UpdateRange()
            local weapon = self.inst.components.combat:GetWeapon()
            if weapon then
                weapon.components.weapon:UpdateAltAttackRange(nil, nil, self.inst)
            end
        end

        if self.OnApplyScale then
            self.OnApplyScale(self.inst, self.current_scale, self.scale)
        end
    end

    self.GetScalerBuffs = function(self)
        local source = self.source
        local mults, adds, flats = self:GetSourceBuffs()
        if self.inst.components.buffable then
            local scaler_mults, scaler_adds, scaler_flats = self.inst.components.buffable:GetStatBuffs({"scaler"})
            mults = mults * scaler_mults
            adds = adds + scaler_adds - 1 -- Offset for the sources scaler buff
            flats = flats + scaler_flats
        end
        return mults, adds, flats
    end

    self.GetSourceBuffs = function(self, checking_source)
        local source = self.source
        local mults = 1
        local adds = 1
        local flats = 0
        if source then
            -- Retrieve the sources source
            if source.components.scaler and source.components.scaler.source then
                return source.components.scaler:GetSourceBuffs()
                -- Return the sources current scaler buffs
            elseif source.components.buffable then
                return source.components.buffable:GetStatBuffs({"scaler"})
            end
        end
        return mults, adds, flats
    end

    -- force_update is true by default
    self.SetSource = function(self, source, force_update)
        self.source = source
        if force_update == nil or force_update then
            self:ApplyScale()
        end
    end
    self.SetBaseScale = function(self, scale)
        self.base_scale = scale or self.base_scale
    end
    self.SetBaseRadius = function(self, radius)
        self.base_rad = radius or self.base_rad
    end
    self.SetBaseHeight = function(self, height)
        self.base_height = height or self.base_height
    end
    self.SetBaseMass = function(self, mass)
        self.base_mass = mass or self.base_mass
    end
    self.SetBaseShadow = function(self, shadow)
        self.base_shadow = shadow or self.base_shadow
    end
    self.SetRadiusRate = function(self, rate)
        self.rad_rate = rate or self.rad_rate
    end
    self.SetHeightRate = function(self, rate)
        self.height_rate = rate or self.height_rate
    end
    self.SetMassRate = function(self, rate)
        self.mass_rate = rate or self.mass_rate
    end
    self.SetShadowRate = function(self, rate)
        self.shadow_rate = rate or self.shadow_rate
    end
end)
AddComponentPostInit("revivablecorpse", function(self)
    self.revivable = _G.net_bool(self.inst.GUID, "revivablecorpse.revivable")
    self.SetRevivable = function(self, val)
        self.revivable:set(val)
    end
    self:SetRevivable(true)

    local _oldCanBeRevivedBy = self.CanBeRevivedBy
    self.CanBeRevivedBy = function(self, reviver)
        return self.revivable:value() and _oldCanBeRevivedBy(self, reviver)
    end

    self.base_revive_health_percent = 1
    self.SetBaseReviveHealthPercent = function(self, percent)
        if self.ismastersim then
            self.base_revive_health_percent = percent or self.base_revive_health_percent
        end
    end

    self.revivers_mult = 1
    self.GetReviveHealthPercent = function(self)
        if self.ismastersim then
            return self.health_override or self.revive_health_percet * self.base_revive_health_percent * (self.revivers_mult or 1)
        end
    end

    local _oldSetCorpse = self.SetCorpse
    self.SetCorpse = function(self, corpse)
        if self.ismastersim and not corpse then
            self.reviving = false
            self.health_override = nil
            self.revivers_mult = 1
            self.inst:PushEvent("revived")
        end
        _oldSetCorpse(self, corpse)
    end

    local _oldRevive = self.Revive
    self.Revive = function(self, reviver, health_override)
        if not self:IsReviving() then
            _oldRevive(self, reviver)
            if self.ismastersim then
                self.reviving = true
                self.health_override = health_override
                self.revivers_mult = reviver and reviver.components.corpsereviver and reviver.components.corpsereviver:GetReviveHealthPercentMult() or 1
            end
        end
    end

    self.reviving = false
    self.IsReviving = function(self)
        return self.reviving
    end

    self.IsCorpse = function(self)
        return self.inst:HasTag("corpse")
    end

    self.revive_charges = {}
    self.revive_priority = {}
    self.AddCharge = function(self, source, health, on_revive_fn, priority)
        if not self.revive_charges[source] then
            self.revive_charges[source] = true
            table.insert(self.revive_priority, {source = source, health = health, on_revive_fn = on_revive_fn, priority = priority})
            table.sort(self.revive_priority, function(a, b)
                return a.priority < b.priority
            end)
            -- Check to see if charge should be immediately used.
            self:ConsumeCharge()
        end
    end

    self.RemoveCharge = function(self, source)
        if self.revive_charges[source] then
            self.revive_charges[source] = nil
            for i,data in pairs(self.revive_priority) do
                if data.source == source then
                    table.remove(self.revive_priority, i)
                    break
                end
            end
        end
    end

    self.HasReviveCharges = function(self)
        return #self.revive_priority > 0
    end

    local REVIVE_DELAY = 3 -- Ensure the owner is completely dead before attempting to revive.
    self.ConsumeCharge = function(self)
        if self.inst.components.health:IsDead() and not self:IsReviving() and #self.revive_priority > 0 then
            self.inst:DoTaskInTime(self.inst.sg.currentstate.name ~= "corpse" and REVIVE_DELAY or 0, function()
                local revive_data = table.remove(self.revive_priority, 1)
                self:Revive(revive_data.source, revive_data.health)
                if revive_data.on_revive_fn then
                    revive_data.on_revive_fn(self.inst)
                end
                self.revive_charges[revive_data.source] = nil
            end)
        end
    end

    self.inst:ListenForEvent("death", function()
        self:ConsumeCharge()
    end)
end)

local Image = require("widgets/image")
local Text = require("widgets/text")
UI = nil



MonstWork={--设置生物对月台造成的伤害
    ["rook"]={work=2},
    --["hollow_knight"]={work=2},
    ["deerclops"]={work=3},
    ["moose"]={work=2},
    ["bearger"]={work=4},
    ["minotaur"]={work=9},
    ["dragonfly"]={work=5},
    ["shadow_rook"]={work=2},
    ["shadow_knight"]={work=2},
    ["malbatross"]={work=3},
    ["beequeen"]={work=5},
    ["klaus"]={work=5},
    ["boarilla"]={work=5},

}

CHANCES={
    CHANCE_Base={
        rock1=1,--岩石
        rock2=1,--岩石
        rocks=5,--石头
        flint=5,--燧石
        townportaltalisman = 2 ,--沙之石
        cutgrass=5,--草
        twigs=5,--树枝

    },
    CHANCE_Weapon={
        nightstick=5,--晨星锤
        armorwood=5,--木甲
        hambat = 5 , --火腿棒
        armormarble=5,--大理石甲

    },
    CHANCE_Food={
        lightbulb=30, --荧光果
        bananapop= 30 , --香蕉冻
        meatballs=70,--肉丸
        smallmeat_dried=70,--小风干肉
        jellybean=20,--彩虹糖豆
        stuffedeggplant=70,--酿茄子
        voltgoatjelly= 30 , --伏特羊肉冻

    },
    CHANCE_Seed={
        tillweed_seeds=5,--犁地草种子
        firenettles_seeds=5,--火荨麻种子
        forgetmelots_seeds=5,--忘我草种子
        ivy_seeds=5,--针刺旋花种子
        seeds=5,--普通种子
    },
    CHANCE_rare={
        gift=5,--礼物包裹
        wetpouch=5,--绿洲包裹
        greenstaff=5,--拆解魔杖
        sunkenchest=5,--沉底宝箱
    },
    CHANCE_Biuld={
        build_icebox=30,--冰箱
        build_cookpot=30,--锅
        build_birdcage=30,--鸟笼
        build_lightning_rod=30,--避雷针
        build_firesuppressor=30,--a
        build_saltbox=30,--盐盒
        build_wardrobe=30,--衣柜
        build_firepit=30,
        build_researchlab3=30,--魔法科技
        build_pighouse=30,--猪房
    },
    CHANCE_Animal={
        smallbird= 10,--小鸟
        snurtle=10,--蜗牛龟
        slurtle=10,--蜗牛龟
        pigman=10,--鱼人
        spore_medium = 5 ,--红色孢子
        spore_small = 5 ,--绿色孢子
        spore_tall = 5 ,--蓝色孢子
        lureplant = 5 ,--食人花
        lightflier = 5 , --球状光虫
        fireflies = 5 ,--萤火虫
        rabbit = 3 ,--兔子
        mole = 2 ,--鼹鼠
        moonbutterfly = 1, --月娥
    },
    CHANCE_Other={
        silk=5,--蜘蛛丝
        minerhat=20,--矿工帽
        book_tentacles=10,--触手的召唤
        book_horticulture=10,--园艺学
        book_birds=10,--世界鸟类大全
        heatrock=   10 ,--暖石
        portabletent_item = 10   , --帐篷卷
        sleepbomb= 10   , --睡袋
        sewing_tape	= 10   ,--可靠的胶布
        waterballoon	= 10   ,--水球
        miniboatlantern = 10   ,--漂浮灯笼
        miniflare = 10   ,-- 信号弹
        soil_amender=10,--瓶装肥料
        hore=10,--牛角
        shell_cluster=10,--贝壳堆
        magic_blueprint=10,--空白蓝图
        firecrackers=10,--红鞭炮
        spidergland=10,--蜘蛛腺
        amulet=10,--重生
        torch=10,--火把
        redlantern  = 10   ,--红灯笼
        sleepbomb = 10 ,--催眠袋
    },
    CHANCE_Monster={
        shark=1,--"鲨鱼"
        deerclops=2,--巨鹿
       -- bearger=1,--熊
        ghost=50,--幽灵
        merm=50,--鱼人
        spider=50,--蜘蛛
        beefalo=50,--牛
        --leif=20,--树精
        leif_sparse=20,--树精2
        worm=30,--蠕虫
        deciduoustree=8,--桦栗树
        gingerbreadwarg=8,--狼
    }
}
CHANCE_Type={
    CHANCE_Base=80,
    CHANCE_Weapon=15,
    CHANCE_Food=5,
    CHANCE_Seed=10,
    CHANCE_rare=7,
    CHANCE_Biuld=20,
    CHANCE_Animal=5,
    CHANCE_Other=10,
    CHANCE_Monster=5,
}
TSCHEST={
    --怪物和武器
    deerAndruins={"armorruins","ruins_bat","deerclops","ruinshat"},	--巨鹿和三件套
    bearAndruins={"armorruins","ruins_bat","bearger","ruinshat"},--熊大和三件套
    mooseAndruins={"armorruins","ruins_bat","ruinshat","moose"},--鹿鸭和三件套
    monkeyChest={"palmcone_seed","dock_kit_blueprint","boat_cannon_kit_blueprint","cannonball_rock_item_blueprint"},--猴子岛蓝图包
    --武器
    ruins={"armorruins","ruins_bat","ruinshat"},--三件套
    --怪物

    shark={"shark"},
    Hat={"hivehat","walrushat","beefalohat","watermelonhat"},--帽子
    --种子包
    Seeds={"tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds","tillweed_seeds"},
    Seeds2={"firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds","firenettles_seeds"},
    Seeds3={"ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds","ivy_seeds"},

    --其它
    slot_cap = {"red_cap","green_cap","blue_cap"},
    waterplant_pack={"waterplant_bomb","waterplant_bomb","waterplant_bomb","waterplant_bomb","waterplant_bomb","waterplant_bomb","waterplant_bomb"},
    gemPack={"redgem","redgem","redgem","redgem","purplegem","purplegem","purplegem","purplegem","bluegem","bluegem","bluegem","bluegem"},
}
TSCHEST_LOOT={
    monkeyChest=5,
    deerAndruins=1,
    bearAndruins=1,
    mooseAndruins=1,
    shark=2,

    ruins=5,
    sunkenchest=5,
    gift=5,
    gemPack=5,
    Seeds=5,
    Seeds2=5,
    Seeds3=5,
    Hat=5,
    waterplant_pack=5,
    ----------OK LIST
    slot_cap = 1,

}
Gifts={
    BasePack={
        maxwell_smoke=1,
        cutreeds=8,
        cutgrass=10,
        rocks=8,--石头
        flint=8,--燧石
        log=10,--木头
        silk=20,--蜘蛛丝
    },
    farm_Pack={
        maxwell_smoke=1,
        farm_plow_item=6,
        golden_farm_hoe=3,
    },
    moonrocknugget={
        maxwell_smoke=1,
        moonrocknugget=5,

    },
    staffPack={
        maxwell_smoke=1,
        telestaff=1,--传送魔杖
        orangestaff=1,--懒人魔杖
        yellowstaff=1,--唤星者魔杖
    },
    amuletPack={
        maxwell_smoke=1,
        amulet=1,
        blueamulet=1,
        greenamulet=1,--建造护符
        purpleamulet=1,--梦魇护符
        yellowamulet=1,--魔光护符
    },
    mushroombomb_dark={--炸弹礼物
        maxwell_smoke=1,
        mushroombomb_dark=10
    },
    poop={
        toadstool_cap_absorbfx=1,
        poop=20,
    },
    flower={
        flower=20,
        ghostflower=20,
    },
    madscience_lab={
        sleepbomb_burst=1,
        --madscience_lab=1,
    },
    ancient_altar={
        stalker_shield3=1,
        ancient_altar=1,
    },
    beemine_maxwell={
        beemine_maxwell=3,
    },
    engineerPack={
        sewing_tape=10,
        fireflies=5,
        bugnet=1,
    },
    monkeyPack1={
        dock_kit_blueprint=1,
    },
    monkeyPack2={
        boat_cannon_kit_blueprint=1,
    },
    monkeyPack3={
        cannonball_rock_item_blueprint=1,
    },
    monkeyPack4={
        palmcone_scale=1,
    },
    --[[TODO:
    Buff_YellowAsh={
        "nofollow_mushroomsprout_glow",--头皮屑
        "nofollow_small_puff",--移动速度
        "attackbf_sleepbomb_burst",--范围攻击
        "yefollow_ghostlyelixir_fastregen"--爱心buff
    },
    ]]--
}
Gifts_Random={
    monkeyPack1=10,
    monkeyPack2=10,
    monkeyPack3=10,
    monkeyPack4=10,
    BasePack=10,
    farm_Pack=10,
    sunkenchest=10,
    gift=10,
    krampus_sack=10,--小偷背包
    amuletPack=5,--护符
    eyebrellahat=5,--眼球伞
    statue_marble=2,--大理石雕像
    mushroombomb_dark=10,--炸弹礼物
    ancient_altar=1,--远古科技
    klaus_sack=10,--赃物袋
    poop=2,--大便
    flower=3,--花
    moonrocknugget=5,--月石
    beemine_maxwell=5,--蚊子礼物
    engineerPack=5,--工程师包
    terrarium=20,--泰拉瑞亚眼球boss召唤物
}

local function updateTwinHealth()
    local Days=TheWorld.state.cycles + 1 --天数
    print("~~~~~~~~~Days:"..tostring(Days))
    --普通眼球一天加5000
    TUNING.EYEOFTERROR_HEALTH = 5000 * Days
    --双子魔眼血量一天加一万
    TUNING.TWIN1_HEALTH = 10000 * Days
    TUNING.TWIN2_HEALTH = 10000 * Days
    --勿忘我价格递减
    local price = 1000 - (Days-1) * 50
    if price < 0 then
        price = 20
    end
    RecoveryList["forgetmelots"] = price
end

local function addHelloWidget(self)

	self.ui_bg = self:AddChild(Image("images/ui_coin.xml", "ui_coin_bg.tex"))
	self.ui_bg:SetScale(0.7)
	self.ui_bg:SetVAnchor(1)
	self.ui_bg:SetHAnchor(1)
	self.ui_bg:SetPosition(100, -40, 0)
	--self.ui_bg:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.ui_tx = self.ui_bg:AddChild(Text(BODYTEXTFONT, 40))
	self.ui_tx:SetVAnchor(1)
	self.ui_tx:SetHAnchor(1)
	self.ui_tx:SetPosition(135, -40, 0)
	self.ui_tx:SetString("没金币")
	UI = self

end
AddClassPostConstruct("widgets/controls", addHelloWidget)

--这是一个小土堆出货概率表

STRINGS.NAMES.FIRENETTLES_SEEDS="火荨麻种子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIRENETTLES_SEEDS = "老木糖给你喝岩浆的温度"

STRINGS.NAMES.FORGETMELOTS_SEEDS="必忘我种子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FORGETMELOTS_SEEDS = "忘了老木糖吧"

STRINGS.NAMES.TILLWEED_SEEDS="犁地草种子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TILLWEED_SEEDS = "犁出很多老木糖"

STRINGS.NAMES.IVY_SEEDS="针刺旋花种子"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.IVY_SEEDS = "困住木糖"

STRINGS.NAMES.MONSTSPAWNER1="传送门1"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTSPAWNER1="全是狗"

STRINGS.NAMES.MONSTSPAWNER2="传送门2"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTSPAWNER1="全是狗"

STRINGS.NAMES.MONSTSPAWNER3="传送门3"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTSPAWNER1="全是狗"

STRINGS.NAMES.MONSTSPAWNER4="传送门4"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTSPAWNER1="全是狗"

STRINGS.NAMES.MYMOONBASE="以前那个月台？"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYMOONBASE = "守住它"

STRINGS.NAMES.SNORTOISE="王八"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SNORTOISE = "王八"



local function JudgeIsWall(x,y,z)
	local target_ents = TheSim:FindEntities(x,y,z, 1,nil,nil,{"wall"})
	if #target_ents>=1 then return true
	else return false end
end

local function Fly(inst)
	local point1 = inst:GetPosition()
	local vec = inst.Forward/inst.timeaa
	if not TheWorld.Map:IsOceanTileAtPoint(point1.x+vec.x,0,point1.z+vec.z) and not JudgeIsWall(point1.x+vec.x,0,point1.z+vec.z) then
		inst.Transform:SetPosition(point1.x+vec.x,0,point1.z+vec.z)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:revivablecorpse
end)
AddComponentPostInit("revivablecorpse", function(self)
    self.revivable = _G.net_bool(self.inst.GUID, "revivablecorpse.revivable")
    self.SetRevivable = function(self, val)
        self.revivable:set(val)
    end
    self:SetRevivable(true)

    local _oldCanBeRevivedBy = self.CanBeRevivedBy
    self.CanBeRevivedBy = function(self, reviver)
        return self.revivable:value() and _oldCanBeRevivedBy(self, reviver)
    end

    self.base_revive_health_percent = 1
    self.SetBaseReviveHealthPercent = function(self, percent)
        if self.ismastersim then
            self.base_revive_health_percent = percent or self.base_revive_health_percent
        end
    end

    self.revivers_mult = 1
    self.GetReviveHealthPercent = function(self)
        if self.ismastersim then
            return self.health_override or self.revive_health_percet * self.base_revive_health_percent * (self.revivers_mult or 1)
        end
    end

    local _oldSetCorpse = self.SetCorpse
    self.SetCorpse = function(self, corpse)
        if self.ismastersim and not corpse then
            self.reviving = false
            self.health_override = nil
            self.revivers_mult = 1
            self.inst:PushEvent("revived")
        end
        _oldSetCorpse(self, corpse)
    end

    local _oldRevive = self.Revive
    self.Revive = function(self, reviver, health_override)
        if not self:IsReviving() then
            _oldRevive(self, reviver)
            if self.ismastersim then
                self.reviving = true
                self.health_override = health_override
                self.revivers_mult = reviver and reviver.components.corpsereviver and reviver.components.corpsereviver:GetReviveHealthPercentMult() or 1
            end
        end
    end

    self.reviving = false
    self.IsReviving = function(self)
        return self.reviving
    end

    self.IsCorpse = function(self)
        return self.inst:HasTag("corpse")
    end

    self.revive_charges = {}
    self.revive_priority = {}
    self.AddCharge = function(self, source, health, on_revive_fn, priority)
        if not self.revive_charges[source] then
            self.revive_charges[source] = true
            table.insert(self.revive_priority, {source = source, health = health, on_revive_fn = on_revive_fn, priority = priority})
            table.sort(self.revive_priority, function(a, b)
                return a.priority < b.priority
            end)
            -- Check to see if charge should be immediately used.
            self:ConsumeCharge()
        end
    end

    self.RemoveCharge = function(self, source)
        if self.revive_charges[source] then
            self.revive_charges[source] = nil
            for i,data in pairs(self.revive_priority) do
                if data.source == source then
                    table.remove(self.revive_priority, i)
                    break
                end
            end
        end
    end

    self.HasReviveCharges = function(self)
        return #self.revive_priority > 0
    end

    local REVIVE_DELAY = 3 -- Ensure the owner is completely dead before attempting to revive.
    self.ConsumeCharge = function(self)
        if self.inst.components.health:IsDead() and not self:IsReviving() and #self.revive_priority > 0 then
            self.inst:DoTaskInTime(self.inst.sg.currentstate.name ~= "corpse" and REVIVE_DELAY or 0, function()
                local revive_data = table.remove(self.revive_priority, 1)
                self:Revive(revive_data.source, revive_data.health)
                if revive_data.on_revive_fn then
                    revive_data.on_revive_fn(self.inst)
                end
                self.revive_charges[revive_data.source] = nil
            end)
        end
    end

    self.inst:ListenForEvent("death", function()
        self:ConsumeCharge()
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:snortoise
end
AddStategraphPostInit("snortoise", HitFly) --让牌子可以击飞任何怪物



LastWave={--记录上一个并重置它
	day = nil,
	waves={}
}


local function qianghua(inst,Size)--怪物增加体积

	local Scale = inst.Transform:GetScale()
	inst.Transform:SetScale(Scale*Size, Scale*Size, Scale*Size)

	if inst.components.aura and Size > 1 then
		inst.components.aura.radius = inst.components.aura.radius *Size
	end

	if inst.components.health ~= nil then
		if inst.myscale == nil and inst.components.health then
			if Size<=0.2 then Size=0.2 end
			inst.components.health.maxhealth=inst.components.health.maxhealth*(Size-0.15)
			inst.components.health.currenthealth=inst.components.health.maxhealth
		end

	end


	if inst.components.combat then
		inst.components.combat.hitrange = inst.components.combat.hitrange * Size
		inst.components.combat.attackrange = inst.components.combat.attackrange * Size
		if inst.components.domesticatable ~= nil and  inst.components.domesticatable:IsDomesticated() then
			Size = math.min(Size,2)
		end
		inst.components.combat.defaultdamage =  math.ceil(inst.components.combat.defaultdamage * Size)
	end

	if inst.Physics ~= nil then
		local radius = inst.Physics:GetRadius() or 0
		local height = inst.Physics:GetHeight() or 2
		inst.Physics:SetCapsule(radius * Size, height)
	end
	if inst.components.locomotor ~= nil then
		inst.components.locomotor.runspeed = inst.components.locomotor.runspeed/inst.Transform:GetScale()
	end

	inst.myscale = Size
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:weed_firenettle

AddPrefabPostInit("weed_firenettle",AddMove)-------------------定位-这里却是正常的还有这里
AddPrefabPostInit("fossil_stalker",function(inst) --骨头碎片没有碰撞
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GROUND)
end)

```



### 变体演进：FF6 Death Sound (Mod 2723078309)
- **变体场景与切面**：收录来自工坊 Mod 2723078309 (`FF6 Death Sound`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2723078309)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```

