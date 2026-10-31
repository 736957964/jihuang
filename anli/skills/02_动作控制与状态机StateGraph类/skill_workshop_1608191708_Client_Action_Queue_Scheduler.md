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



### 变体演进：fixed_aura_drain (Mod 3828146119)
- **变体场景与切面**：收录来自工坊 Mod 3828146119 (`fixed_aura_drain`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3828146119)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:combat
-- builds use GetAttacked directly; wrap the entry point actually provided by combat.
AddComponentPostInit("combat", function(self)
    local entrypoint = self.GetAttacked_Internal ~= nil and "GetAttacked_Internal" or "GetAttacked"
    local OldGetAttacked = self[entrypoint]
    self[entrypoint] = function(combat, attacker, damage, weapon, stimuli, spdamage, from_doattack)
        local target = combat.inst
        -- Area attacks and some mod projectiles enter here without calling CanTarget.
        local madness = attacker ~= nil and attacker._dd_monk_madness or nil
        if madness ~= nil and madness.aura:IsValid() and madness.aura:Contains(attacker)
            and not madness.aura:IsMadnessTarget(attacker, target) then
            return false
        end
        local mark = target._dd_monk_exposure
        local chainaura
        local hit = combat.redirected_from ~= nil and exposurehits[combat.redirected_from] or nil
        local health = target.components.health
        local oldhealth = health ~= nil and health.currenthealth or 0
        if hit == nil and mark ~= nil and attacker ~= nil and damage ~= nil and damage > 0 and oldhealth > 0
            and not health:IsInvincible() and stimuli ~= "dd_monk_chain" then
            local aura = mark.aura:GetDominantAura(target)
            if aura == nil then
                Exposure.Clear(target)
            else
                mark.aura = aura
                if mark.charged then
                    mark.charged = false -- Reserve during damage resolution; keep the icon if dodged.
                    damage = damage * (1 + .1 * aura.power)
                    chainaura = aura
                    hit = {}
                end
            end
        end
        -- Keep prefab/brain/SG callbacks, retaliation and herd sharing intact.
        -- Only this tick's hit-reaction state transition is suppressed.
        if stimuli == "dd_monk_electric" then
            PatchElectricHitReaction(target)
        end
        local ok, result
        if hit ~= nil and health ~= nil then
            ok, result = pcall(ExposureAttack, combat, OldGetAttacked, attacker, damage, weapon, stimuli, spdamage, from_doattack, hit)
        else
            ok, result = pcall(OldGetAttacked, combat, attacker, damage, weapon, stimuli, spdamage, from_doattack)
        end
        if not ok then
            error(result, 0)
        end
        if chainaura ~= nil then
            if hit.landed then
                Exposure.Consume(target, mark)
                if chainaura:IsValid() and target:IsValid() then
                    chainaura:ChainExplosion(target)
                end
            elseif target._dd_monk_exposure == mark then
                Exposure.SetCharged(target, mark, true)
            end
        elseif mark ~= nil and target._dd_monk_exposure == mark and not mark.charged
            and stimuli ~= "dd_monk_chain" and health ~= nil and health.currenthealth < oldhealth
            and not health:IsDead() and mark.aura:IsValid() and mark.aura:Contains(target) then
            -- A successful roll arms the NEXT hit; the triggering hit stays ordinary.
            Exposure.SetCharged(target, mark, math.random() < math.min(1, .2 * mark.aura.power))
        end
        return result
    end

    local OldSetTarget = self.SetTarget
    self.SetTarget = function(combat, target, ...)
        local madness = combat.inst._dd_monk_madness
        if madness ~= nil and madness.aura:IsValid() and madness.aura:Contains(combat.inst) then
            if not madness.aura:IsMadnessTarget(combat.inst, target) then
                target = madness.aura:PickMadnessTarget(combat.inst)
            end
        end
        return OldSetTarget(combat, target, ...)
    end

    local OldCanTarget = self.CanTarget
    self.CanTarget = function(combat, target, ...)
        local madness = combat.inst._dd_monk_madness
        if madness ~= nil and madness.aura:IsValid() and madness.aura:Contains(combat.inst)
            and not madness.aura:IsMadnessTarget(combat.inst, target) then
            return false
        end
        return OldCanTarget(combat, target, ...)
    end

    local OldDoAttack = self.DoAttack
    self.DoAttack = function(combat, target, ...)
        local madness = combat.inst._dd_monk_madness
        if madness ~= nil and madness.aura:IsValid() and madness.aura:Contains(combat.inst)
            and not madness.aura:IsMadnessTarget(combat.inst, target or combat.target) then
            return
        end
        return OldDoAttack(combat, target, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:stewer

AddComponentPostInit("stewer", function(self)
    local oldstart = self.StartCooking
    self.StartCooking = function(stewer, doer)
        local starting = stewer.targettime == nil and stewer.inst.components.container ~= nil
        InstallDoneCallback(stewer)
        local result = oldstart(stewer, doer)
        if starting then
            stewer._dd_monk_extended = nil
            stewer._dd_monk_prepared = IsMashedPotatoes(stewer.product) and doer ~= nil
                and doer:HasTag("dd_monk") and util.HasSkill(doer, "dd_monk_food") or nil
        end
        return result
    end

    local oldharvest = self.Harvest
    self.Harvest = function(stewer, harvester)
        local previous = preparingfood
        preparingfood = stewer._dd_monk_prepared and IsMashedPotatoes(stewer.product) or false
        local result = oldharvest(stewer, harvester)
        preparingfood = previous
        if result then
            stewer._dd_monk_prepared = nil
            stewer._dd_monk_extended = nil
        end
        return result
    end
    local oldstop = self.StopCooking
    self.StopCooking = function(stewer, reason)
        local previous = preparingfood
        preparingfood = stewer._dd_monk_prepared and IsMashedPotatoes(stewer.product) or false
        local result = oldstop(stewer, reason)
        preparingfood = previous
        stewer._dd_monk_prepared = nil
        stewer._dd_monk_extended = nil
        return result
    end

    local oldsave = self.OnSave
    self.OnSave = function(stewer)
        local data, references = oldsave(stewer)
        data = data or {}
        data.dd_monk_prepared = stewer._dd_monk_prepared or nil
        data.dd_monk_extended = stewer._dd_monk_extended or nil
        return data, references
    end
    local oldload = self.OnLoad
    self.OnLoad = function(stewer, data, newents)
        stewer._dd_monk_prepared = data ~= nil and data.dd_monk_prepared or nil
        stewer._dd_monk_extended = data ~= nil and data.dd_monk_extended or nil
        InstallDoneCallback(stewer)
        local result = oldload(stewer, data, newents)
        ExtendPotSpoilage(stewer)
        return result
    end

    local oldlongupdate = self.LongUpdate
    self.LongUpdate = function(stewer, dt)
        local cooktime = stewer:GetTimeToCook()
        if stewer._dd_monk_prepared and stewer:IsCooking() and cooktime <= dt then
            oldlongupdate(stewer, math.max(0, cooktime))
            ExtendPotSpoilage(stewer)
            if dt > cooktime then
                oldlongupdate(stewer, dt - cooktime)
            end
        else
            return oldlongupdate(stewer, dt)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:playercontroller
-- 只拦截已经选好武僧技能的落点点击，其余动作完整走原 playercontroller。
AddComponentPostInit("playercontroller", function(self)
    local function OnMounted()
        local owner = self.inst
        if owner == ThePlayer and owner.prefab == "dd_monk" and util.IsMounted(owner)
            and (owner._dd_monk_castmode ~= nil or owner._dd_monk_pendingcast ~= nil) then
            CancelMonkCast(owner)
            owner:PushEvent("dd_monk_castmessage", STRINGS.DD_MONK.ERROR_MOUNTED)
        end
    end
    self.inst:ListenForEvent("mounted", OnMounted)
    self.inst:ListenForEvent("isridingdirty", OnMounted)
    local oldcommand = self.DoCharacterCommandWheelButton
    self.DoCharacterCommandWheelButton = function(controller, ...)
        local owner = controller.inst
        if owner ~= ThePlayer or owner.prefab ~= "dd_monk" then return oldcommand(controller, ...) end
        if not IsHUDScreen(owner) or owner:HasTag("playerghost") then return end
        local configured = controller._dd_monk_configkey
            or IsNativeMenuBinding(TUNING.DD_MONK_MENU_KEY)
        -- 改键/禁用只影响武僧自身菜单；原版背包技能书仍由原版键操作。
        if not configured and not HasInventorySpellBook(owner) then return end
        if owner._dd_monk_castmode ~= nil or owner._dd_monk_pendingcast ~= nil then
            CancelMonkCast(owner)
            return
        end
        return oldcommand(controller, ...)
    end
    local oldleft = self.OnLeftClick
    self.OnLeftClick = function(controller, down, ...)
        local inst = controller.inst
        if inst._dd_monk_castmode ~= nil and inst == ThePlayer then
            if not down then return end
            if util.IsMounted(inst) then
                CancelMonkCast(inst)
                inst:PushEvent("dd_monk_castmessage", STRINGS.DD_MONK.ERROR_MOUNTED)
                return
            end
            if not IsHUDScreen(inst) or TheNet:IsServerPaused() or not controller:IsEnabled()
                or TheInput:GetHUDEntityUnderMouse() ~= nil then return end
            local point = TheInput:GetWorldPosition()
            if point ~= nil then
                local kind = inst._dd_monk_castmode
                if (kind == "repair" or kind == "recall") and inst:GetDistanceSqToPoint(point.x, 0, point.z) > 30 * 30 then
                    inst:PushEvent("dd_monk_castmessage", STRINGS.DD_MONK.TOO_FAR)
                    return
                end
                inst._dd_monk_castmode = nil
                controller._dd_monk_swallow_leftup = true
                controller:ClearActionHold()
                if kind == "repair" or kind == "recall" then
                    SendModRPCToServer(MOD_RPC.dd_monk.manage_aura, kind, point.x, point.z)
                else
                    local action = BufferedAction(inst, nil, ACTIONS.DD_MONK_CAST, nil, point)
                    action.dd_monk_kind = kind
                    inst._dd_monk_castsequence = (inst._dd_monk_castsequence or 0) + 1
                    local pending = {id = inst._dd_monk_castsequence, action = action, sent = false}
                    inst._dd_monk_pendingcast = pending
                    local function FinishLocal()
                        if inst._dd_monk_pendingcast == pending then inst._dd_monk_pendingcast = nil end
                    end
                    action:AddSuccessAction(FinishLocal)
                    action:AddFailAction(function()
                        -- A predicted action may be cleared when the server takes over.
                        -- Once sent, wait for the authoritative success/failure reply.
                        if controller.ismastersim or not pending.sent then FinishLocal() end
                    end)
                    controller:CancelAOETargeting()
                    controller:CancelPlacement()
                    controller:CancelDeployPlacement()
                    inst.replica.inventory:ReturnActiveItem()
                    if not controller.ismastersim then
                        local function SendCast()
                            if inst._dd_monk_pendingcast ~= pending or pending.sent then return end
                            pending.sent = true
                            SendModRPCToServer(MOD_RPC.dd_monk.cast, kind, point.x, point.z, pending.id)
                        end
                        action.preview_cb = SendCast
                        action.non_preview_cb = SendCast
                    end
                    controller:DoAction(action)
                    if not pending.sent and inst:GetBufferedAction() ~= action then FinishLocal() end
                end
            end
            return
        end
        if not down and controller._dd_monk_swallow_leftup then
            controller._dd_monk_swallow_leftup = nil
            return
        end
        return oldleft(controller, down, ...)
    end
    local oldright = self.OnRightClick
    self.OnRightClick = function(controller, down, ...)
        if controller.inst == ThePlayer and (controller.inst._dd_monk_castmode ~= nil or controller.inst._dd_monk_pendingcast ~= nil) then
            if down then CancelMonkCast(controller.inst) end
            return
        end
        local hud = controller.inst == ThePlayer and controller.inst.HUD or nil
        local book = controller.inst._dd_monk_spell ~= nil and controller.inst._dd_monk_spell:value() or nil
        if book ~= nil and hud ~= nil and hud:IsSpellWheelOpen() and hud.controls.spellwheel.invobject == book then
            if down then hud:CloseSpellWheel() end
            return
        end
        return oldright(controller, down, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified

AddPrefabPostInit("player_classified", function(inst)
    inst.dd_monk_aura_count = net_byte(inst.GUID, "dd_monk_aura.count")
    inst.dd_monk_aura_capacity = net_byte(inst.GUID, "dd_monk_aura.capacity")
    inst.dd_monk_mana_max = net_ushortint(inst.GUID, "dd_monk_mana.max", "dd_monk_manadirty")
    inst.dd_monk_mana_current = net_ushortint(inst.GUID, "dd_monk_mana.current", "dd_monk_manadirty")
    inst.dd_monk_mana_pulseup = net_bool(inst.GUID, "dd_monk_mana.pulseup", "dd_monk_manadirty")
    inst.dd_monk_mana_pulsedown = net_bool(inst.GUID, "dd_monk_mana.pulsedown", "dd_monk_manadirty")
    if TheWorld.ismastersim then
        inst:DoStaticTaskInTime(0, function()
            inst._parent = inst.entity:GetParent()
            if inst._parent ~= nil then
                inst:ListenForEvent("dd_monk_manadelta", OnManaDelta, inst._parent)
                if inst._parent.components.dd_monk_mana ~= nil then
                    inst._parent.components.dd_monk_mana:DoDelta(0, true)
                end
                local owner = inst._parent.components.dd_monk_auraowner
                if owner ~= nil then owner:SyncCount() end
            end
        end)
    else
        -- 与官方 classified 一样等首包反序列化、父实体 AttachClassified 后再发初值。
        inst:DoStaticTaskInTime(0, function()
            local maximum = inst.dd_monk_mana_max:value()
            inst.old_dd_monk_manavalue = inst.dd_monk_mana_current:value()
            inst.old_dd_monk_manapercent = maximum > 0 and inst.old_dd_monk_manavalue / maximum or 0
            inst:ListenForEvent("dd_monk_manadirty", OnManaDirty)
            OnManaDirty(inst)
        end)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:skinner
-- 人物皮肤的init_fn 和 clear_fn
AddComponentPostInit("skinner", function(self)
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
end)

```



### 变体演进：飞碟哈基米 (Mod 3822973750)
- **变体场景与切面**：收录来自工坊 Mod 3822973750 (`飞碟哈基米`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3822973750)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Better Polar Bearger Bin / 更好的极地熊獾桶 (Mod 3820687628)
- **变体场景与切面**：收录来自工坊 Mod 3820687628 (`Better Polar Bearger Bin / 更好的极地熊獾桶`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820687628)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beargerfur_sack

AddPrefabPostInit("beargerfur_sack", function(inst)
    if not G.TheWorld.ismastersim then
        return
    end

    local original_rate = inst.components.preserver.perish_rate_multiplier
    inst:AddComponent("bpbb_energy")
    inst.components.preserver:SetPerishRateMultiplier(function(sack, item)
        local fallback = G.FunctionOrValue(original_rate, sack, item) or 1
        return sack.components.bpbb_energy:GetPerishRate(item, fallback)
    end)
    local description = inst.components.inspectable.getspecialdescription
    inst.components.inspectable.getspecialdescription = function(sack, viewer)
        local original = description ~= nil and description(sack, viewer) or nil
        return (original ~= nil and original .. "\n" or "") .. sack.components.bpbb_energy:GetDescription()
    end

    if GetModConfigData("companion_enabled") then
        inst:AddComponent("bpbb_companion")
    end
end)

```



### 变体演进：Mod 3808356713 (Mod 3808356713)
- **变体场景与切面**：收录来自工坊 Mod 3808356713 (`Mod 3808356713`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3808356713)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:vault_pillar_guard_dormant

AddPrefabPostInit("vault_pillar_guard_dormant", function(inst)
    if not G.TheWorld.ismastersim then
        return
    end
    local old_save, old_load = inst.OnSave, inst.OnLoad
    inst.OnSave = function(body, data, ...)
        if old_save ~= nil then old_save(body, data, ...) end
        data.xingui_guard_rebuilt = body:HasTag(REBUILT_TAG) or nil
    end
    inst.OnLoad = function(body, data, ...)
        if old_load ~= nil then old_load(body, data, ...) end
        if data ~= nil and data.xingui_guard_rebuilt then
            body:AddTag(REBUILT_TAG)
                                                                            
                                                                           
                                                                          
            body:DoTaskInTime(0, function(old)
                if not old:IsValid() then return end
                local guard = G.ReplacePrefab(old, "vault_pillar_guard")
                if guard ~= nil then
                    guard:MakeCrafted()
                    guard.sg:GoToState("activate")
                end
            end)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:vault_pillar_guard

AddStategraphPostInit("vault_pillar_guard", function(sg)
    Safety.PatchStategraph(sg)
    Wreck.PatchStategraph(sg)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    if not G.TheNet:IsDedicated() then
        PatrolIndicator.Install(inst)                                           
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:vault_pillar_guard

AddPrefabPostInit("vault_pillar_guard", function(inst)
    if not G.TheWorld.ismastersim then
                                                                           
                                                                             
                                                    
        if not Mobility.Apply(inst) then
            local attempts = 0
            local task
            task = inst:DoPeriodicTask(.5, function()
                attempts = attempts + 1
                if Mobility.Apply(inst) or attempts >= 60 then
                    task:Cancel()
                end
            end)
        end
        return
    end

                                                                            
    if inst.components.entitytracker == nil then
        inst:AddComponent("entitytracker")
    end
    inst:AddComponent("xingui_guardcontrol")

    local original_makecrafted = inst.MakeCrafted
    if type(original_makecrafted) ~= "function" then
        print("[Guard Control] missing MakeCrafted; refusing to alter guard")
        return
    end
    inst.MakeCrafted = function(guard, ...)
        local result = original_makecrafted(guard, ...)
        local control = guard.components.xingui_guardcontrol
        if control ~= nil and Threat.IsCraftedGuard(guard) then
                                                                       
                                                                             
                                                                        
            guard:AddTag("companion")
            Mobility.Apply(guard)
            control:ActivateCrafted(Brain, Threat)
        end
        return result
    end

                                                                             
    inst:DoTaskInTime(0, function(guard)
        local control = guard.components.xingui_guardcontrol
        if control ~= nil and Threat.IsCraftedGuard(guard) then
            guard:AddTag("companion")
            Mobility.Apply(guard)
            control:ActivateCrafted(Brain, Threat)
        end
    end)
end)

```



### 变体演进：除草剂 (Mod 3792826233)
- **变体场景与切面**：收录来自工坊 Mod 3792826233 (`除草剂`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3792826233)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：DST Haptics Compatibility / 手柄震动兼容 (Mod 3805091756)
- **变体场景与切面**：收录来自工坊 Mod 3805091756 (`DST Haptics Compatibility / 手柄震动兼容`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3805091756)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddStategraphPostInit:wilson_client

    AddStategraphPostInit("wilson_client", function(sg)
        WrapState(sg, "chop_start", "chop", captures)
        WrapState(sg, "mine_start", "mine", captures)
        WrapState(sg, "hammer_start", "hammer", captures)
        WrapState(sg, "dig_start", "dig", captures)
        WrapState(sg, "attack", "attack", captures)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world

    AddPrefabPostInit("world", function(world)
        world:ListenForEvent("playeractivated", function(_, player)
            AttachPlayer(player)
        end)
        world:DoTaskInTime(0, function()
            AttachPlayer(G.ThePlayer)
        end)
    end)

```



### 变体演进：Title (Mod 3783095419)
- **变体场景与切面**：收录来自工坊 Mod 3783095419 (`Title`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3783095419)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:pighouse
    -- 标记玩家建造的猪人房 + 摧毁还原 + 玩家靠近不熄灯
    AddPrefabPostInit("pighouse", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end
        inst:ListenForEvent("onbuilt", function()
            inst.mvb_playerbuilt = true
        end)
        inst:ListenForEvent("burntup", MVB_RevertWorkerPigs)
        if inst.components.workable ~= nil then
            local oldfinish = inst.components.workable.onfinish
            inst.components.workable.onfinish = function(house, worker)
                MVB_RevertWorkerPigs(house)
                if oldfinish ~= nil then
                    oldfinish(house, worker)
                end
            end
        end
        if inst.components.playerprox ~= nil then
            local oldonnear = inst.components.playerprox.onnear
            inst.components.playerprox.onnear = function(...)
                if not inst.mvb_playerbuilt and oldonnear ~= nil then
                    oldonnear(...)
                end
            end
        end
        local old_save = inst.OnSave
        inst.OnSave = function(house, data)
            if old_save ~= nil then
                old_save(house, data)
            end
            data.mvb_playerbuilt = house.mvb_playerbuilt
            data.mvb_cluster_x = house.mvb_cluster_x
            data.mvb_cluster_z = house.mvb_cluster_z
            data.mvb_cluster_center_id = house.mvb_cluster_center_id
        end
        local old_load = inst.OnLoad
        inst.OnLoad = function(house, data)
            if old_load ~= nil then
                old_load(house, data)
            end
            if data ~= nil then
                house.mvb_playerbuilt = data.mvb_playerbuilt
                house.mvb_cluster_x = data.mvb_cluster_x
                house.mvb_cluster_z = data.mvb_cluster_z
                house.mvb_cluster_center_id = data.mvb_cluster_center_id
            end
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:pigman
    -- 公共猪人初始化：忠诚刷新 + 帽子转职 + 不再跟随 + 存档
    AddPrefabPostInit("pigman", function(inst)
        if not GLOBAL.TheWorld.ismastersim or inst.components.trader == nil then
            return
        end
        -- 转职猪人不仇恨"带 monster 标签的玩家角色"（韦伯/沃托克斯/沃特及任意mod同类角色），普通怪物照常打
        if inst.components.combat ~= nil and inst.components.combat.mvb_no_special_hate == nil then
            inst.components.combat.mvb_no_special_hate = true
            local combat = inst.components.combat
            local orig_settarget = combat.SetTarget
            combat.SetTarget = function(self, target)
                if IsConvertedPig(self.inst) and target ~= nil
                    and target:HasTag("monster") and target:HasTag("player") then
                    return
                end
                return orig_settarget(self, target)
            end
        end
        inst:ListenForEvent("equip", function()
            if inst.mvb_farmer then
                MVB_StopHatDepletion(inst, "strawhat")
            end
            if inst.mvb_miner then
                MVB_StopHatDepletion(inst, "minerhat")
            end
            if inst.mvb_beekeeper then
                MVB_StopHatDepletion(inst, "beehat")
            end
            if inst.mvb_battle then
                MVB_StopHatDepletion(inst, "footballhat")
            end
            if inst.mvb_guard then
                MVB_StopHatDepletion(inst, GUARD_CROWNS[1])
                MVB_StopHatDepletion(inst, GUARD_CROWNS[2])
            end
            if inst.mvb_tower then
                MVB_StopHatDepletion(inst, "cookiecutterhat")
            end
            if inst.mvb_sweeper then
                MVB_StopHatDepletion(inst, "winterhat")
            end
            if inst.mvb_lumberjack then
                MVB_StopHatDepletion(inst, "bushhat")
            end
        end)
        local old_onaccept = inst.components.trader.onaccept
        inst.components.trader.onaccept = function(pig, giver, item)
            local item_prefab = item ~= nil and item.prefab or nil
            if old_onaccept ~= nil then
                old_onaccept(pig, giver, item)
            end
                if item_prefab == "baconeggs" and IsPlayerBuiltHome(pig) then
                pig.mvb_farmer_candidate = true
                MVB_StartLoyaltyRefresh(pig)
                print("[MyVanillaBoost] 猪人吃了培根煎蛋（自家猪屋），忠诚度永久化（每500秒刷新）")
            elseif item_prefab == "baconeggs" then
                print("[MyVanillaBoost] 猪人吃了培根煎蛋，但不是自家建造的猪屋，不转职")
            end
            -- 已满足条件且头上戴着对应帽子 → 转职（两种给予顺序都支持）
            if pig.mvb_farmer_candidate and pig.components.inventory ~= nil then
                local hat = MVB_GetPigHat(pig)
                if hat == nil then
                    -- 额外装备栏会把软帽改成 HAT 槽，猪没有该槽，帽子会留在背包：背包里找职业帽
                    hat = pig.components.inventory:FindItem(function(v)
                        return v ~= nil and MVB_PIG_HATS[v.prefab] == true
                    end)
                end
                if hat == nil and item ~= nil and MVB_PIG_HATS[item.prefab] == true then
                    hat = item
                end
                if hat ~= nil and hat.components.equippable ~= nil
                    and hat.components.equippable.equipslot ~= GLOBAL.EQUIPSLOTS.HEAD then
                    -- 戴回头盔槽（猪没有额外装备栏的 HAT 槽）
                    hat.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.HEAD
                    pig.components.inventory:Equip(hat)
                end
                if hat ~= nil and hat.prefab == "strawhat" and GetModConfigData("pig_farmer_harvest") then
                    MVB_ConvertFarmerPig(pig)
                elseif hat ~= nil and hat.prefab == "minerhat" and GetModConfigData("pig_miner") then
                    MVB_ConvertMinerPig(pig)
                elseif hat ~= nil and hat.prefab == "beehat" and GetModConfigData("pig_beekeeper") then
                    MVB_ConvertBeekeeperPig(pig)
                elseif hat ~= nil and hat.prefab == "footballhat" and GetModConfigData("pig_battle") then
                    MVB_ConvertBattlePig(pig)
                elseif IsGuardCrown(hat) and GetModConfigData("pig_guard") then
                    MVB_ConvertGuardPig(pig)
                elseif hat ~= nil and hat.prefab == "cookiecutterhat" and GetModConfigData("pig_tower") then
                    MVB_ConvertTowerPig(pig)
                elseif hat ~= nil and hat.prefab == "winterhat" and GetModConfigData("pig_sweeper") then
                    MVB_ConvertSweeperPig(pig)
                elseif hat ~= nil and hat.prefab == "bushhat" and GetModConfigData("pig_lumberjack") then
                    MVB_ConvertLumberjackPig(pig)
                end
            end
            -- 农家猪/矿工猪再被喂肉也不会重新跟随
            if HasPigWorker(pig) and pig.components.follower ~= nil
                and pig.components.follower:GetLeader() ~= nil then
                pig.components.follower:SetLeader(nil)
            end
        end
        local old_save = inst.OnSave
        inst.OnSave = function(pig, data)
            if old_save ~= nil then
                old_save(pig, data)
            end
            for _, marker in ipairs(MVB_PIG_CLASS_MARKERS) do
                data[marker] = pig[marker]
            end
            data.mvb_battle_origmax = pig.mvb_battle_origmax
            data.mvb_battle_origdamage = pig.mvb_battle_origdamage
            data.mvb_battle_origperiod = pig.mvb_battle_origperiod

            data.mvb_farmer_candidate = pig.mvb_farmer_candidate
            data.mvb_logistics = pig.mvb_logistics or false
            data.mvb_farm_x = pig.mvb_farm_x
            data.mvb_farm_z = pig.mvb_farm_z
            data.mvb_cluster_x = pig.mvb_cluster_x
            data.mvb_cluster_z = pig.mvb_cluster_z
        end
        local old_load = inst.OnLoad
        inst.OnLoad = function(pig, data)
            if old_load ~= nil then
                old_load(pig, data)
            end
            if data ~= nil then
                for _, marker in ipairs(MVB_PIG_CLASS_MARKERS) do
                    pig[marker] = data[marker]
                end
                pig.mvb_battle_origmax = data.mvb_battle_origmax
                pig.mvb_battle_origdamage = data.mvb_battle_origdamage
                pig.mvb_battle_origperiod = data.mvb_battle_origperiod

                pig.mvb_farmer_candidate = data.mvb_farmer_candidate
                pig.mvb_logistics = data.mvb_logistics or false
                pig.mvb_farm_x = data.mvb_farm_x
                pig.mvb_farm_z = data.mvb_farm_z
                pig.mvb_cluster_x = data.mvb_cluster_x
                pig.mvb_cluster_z = data.mvb_cluster_z
                if pig.mvb_farmer_candidate or pig.mvb_battle or pig.mvb_guard then
                    MVB_StartLoyaltyRefresh(pig)
                end
                if pig.mvb_battle or pig.mvb_guard then
                    MVB_MakeLoyaltyPermanent(pig)
                end
                if pig.mvb_farmer then
                    MVB_StopHatDepletion(pig, "strawhat")
                end
                if pig.mvb_miner then
                    MVB_StopHatDepletion(pig, "minerhat")
                    if pig.mvb_miner_task ~= nil then
                        pig.mvb_miner_task:Cancel()
                    end
                    pig.mvb_miner_task = pig:DoPeriodicTask(120, function()
                        MVB_SpawnMinerLoot(pig)
                    end)
                end
                if pig.mvb_beekeeper then
                    MVB_StopHatDepletion(pig, "beehat")
                    MVB_SetupBeekeeperPig(pig)
                end
                if pig.mvb_battle then
                    MVB_StopHatDepletion(pig, "footballhat")
                    MVB_ApplyBattleStats(pig)
                end
                if pig.mvb_guard then
                    MVB_StopHatDepletion(pig, GUARD_CROWNS[1])
                    MVB_StopHatDepletion(pig, GUARD_CROWNS[2])
                    MVB_ApplyGuardStats(pig)
                end
                if pig.mvb_tower then
                    MVB_StopHatDepletion(pig, "cookiecutterhat")
                    MVB_SetupTowerPig(pig)
                end
                if pig.mvb_sweeper then
                    MVB_StopHatDepletion(pig, "winterhat")
                    MVB_SetupSweeperPig(pig)
                end
                if pig.mvb_logistics and pig.components.named ~= nil then
                    MVB_SetClassPrefix(pig, "[后勤]")
                end
                if pig.mvb_lumberjack then
                    MVB_StopHatDepletion(pig, "bushhat")
                    MVB_SetupLumberjackPig(pig)
                end
                if HasPigClass(pig) then
                    MVB_DisableWerepig(pig)
                end
                if HasPigClass(pig) and pig.components.named ~= nil then
                    local cur = pig.components.named.name or ""
                    local has_prefix = false
                    for _, prefix in ipairs(MVB_ALL_CLASS_PREFIXES) do
                        if prefix ~= nil and string.sub(cur, 1, #prefix) == prefix then
                            has_prefix = true
                            break
                        end
                    end
                    if not has_prefix then
                        local want = "[后勤]"
                        if not pig.mvb_logistics then
                            want = nil
                            for _, marker in ipairs(MVB_PIG_CLASS_MARKERS) do
                                if pig[marker] then
                                    want = MVB_PIG_CLASS_PREFIX[marker]
                                    break
                                end
                            end
                        end
                        if want ~= nil then
                            pig.components.named:SetName(want .. cur)
                        end
                    end
                end
            end
        end
    end)


    --------------------------------------------------
    -- [砍伐]猪人自动伐木（开关：pig_lumberjack）
    -- 优先级：砍树 → 铲树根 → 捡掉落物；以猪屋为中心 7 格范围
    --------------------------------------------------
    if GetModConfigData("pig_lumberjack") then
        SafeCall("[砍伐]猪人自动伐木", function()
            -- 玩家种植标记：种下的树苗长大时会调用 growfromseed，借此标记"玩家种植"（野生树不调用）
            -- 砍伐判定配置：以后加/减树只改这里
            local MVB_TREE_WHITELIST = {   -- 精确 prefab 白名单（补 tag 判定漏掉的树）
                "evergreen_sparse",
                "evergreen_sparse_short",
                "evergreen_sparse_normal",
                "evergreen_sparse_tall",
            }
            local MVB_TREE_BLACKLIST_PREFIX = {  -- prefab 前缀黑名单（整族排除）
                "oceantree",
            }

            local PLANTABLE_TREES = {
                "evergreen", "evergreen_short", "evergreen_normal", "evergreen_tall",
                "evergreen_sparse", "evergreen_sparse_short", "evergreen_sparse_normal", "evergreen_sparse_tall",
                "twiggytree", "twiggytree_short", "twiggytree_normal", "twiggytree_tall",
                "deciduoustree", "deciduoustree_short", "deciduoustree_normal", "deciduoustree_tall",
                "palmconetree", "palmconetree_short", "palmconetree_normal", "palmconetree_tall",
            }
            for _, treename in ipairs(PLANTABLE_TREES) do
                AddPrefabPostInit(treename, function(inst)
                    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
                        return
                    end
                    local oldgrow = inst.growfromseed
                    if oldgrow ~= nil then
                        inst.growfromseed = function(...)
                            local r = oldgrow(...)
                            inst.mvb_planted = true
                            return r
                        end
                    end
                    -- 种植标记随存档保存（否则重进游戏后树被当野生，砍伐猪会砍玩家种的树）
                    local oldsave = inst.OnSave
                    inst.OnSave = function(i, data)
                        if oldsave ~= nil then
                            oldsave(i, data)
                        end
                        if i.mvb_planted then
                            data.mvb_planted = true
                        end
                    end
                    local oldload = inst.OnLoad
                    inst.OnLoad = function(i, data)
                        if oldload ~= nil then
                            oldload(i, data)
                        end
                        i.mvb_planted = (data ~= nil and data.mvb_planted) or false
                    end
                end)
            end

            -- 树的最大阶段判定：常青树有 short/normal/tall/old 四阶段，tall（第3）即可砍；无 growable 视为成熟
            local function IsMaxStageTree(guy)
                local g = guy.components.growable
                if g == nil then
                    return true
                end
                local cur = g.stage ~= nil and g.stages ~= nil and g.stages[g.stage] or nil
                return cur ~= nil and (cur.name == "tall" or cur.name == "old")
            end

            local function IsChoppableTree(guy)
                if guy == nil or guy.components.workable == nil
                    or guy:HasTag("stump") then
                    return false
                end
                -- 黑名单：疙瘩树（oceantree 整族）不砍
                for _, prefix in ipairs(MVB_TREE_BLACKLIST_PREFIX) do
                    if string.sub(guy.prefab, 1, #prefix) == prefix then
                        return false
                    end
                end
                if guy.prefab == "marbleshrub" then
                    -- 只挖第三阶段（刚种下的幼苗/中苗不挖）
                    return guy.components.growable ~= nil and guy.components.growable.stage >= 3
                end
                -- 白名单：臃肿常青树（lumpy）明确可砍（各阶段 prefab 都认）
                local in_whitelist = false
                for _, treename in ipairs(MVB_TREE_WHITELIST) do
                    if guy.prefab == treename then
                        in_whitelist = true
                        break
                    end
                end
                if not guy:HasTag("tree") and not in_whitelist then
                    return false
                end
                -- 棕榈松果树：不管野生/种植，只砍最大阶段
                if string.sub(guy.prefab, 1, 12) == "palmconetree" then
                    return IsMaxStageTree(guy)
                end
                -- 玩家种的树只砍最大阶段；野生树任意阶段都能砍
                if not guy.mvb_planted then
                    return true
                end
                return IsMaxStageTree(guy)
            end

            local function FindTree(inst)
                return FindAround(inst, GetWorkerRadius(inst), IsChoppableTree)
            end

            local function ChopAction(inst)
                if inst.sg ~= nil and inst.sg:HasStateTag("busy") then
                    return
                end
                local tree = FindTree(inst)
                if tree ~= nil then
                    local action = tree.components.workable ~= nil and tree.components.workable.action or GLOBAL.ACTIONS.CHOP
                    return GLOBAL.BufferedAction(inst, tree, action)
                end
            end

            local function ShouldChop(inst)
                return FindTree(inst) ~= nil
            end

            local function FindStump(inst)
                return FindAround(inst, GetWorkerRadius(inst), function(guy)
                    return guy:HasTag("stump") and not guy:HasTag("burnt")
                        and guy.components.workable ~= nil
                end)
            end

            local function DigAction(inst)
                if inst.sg ~= nil and inst.sg:HasStateTag("busy") then
                    return
                end
                local stump = FindStump(inst)
                if stump ~= nil then
                    return GLOBAL.BufferedAction(inst, stump, GLOBAL.ACTIONS.DIG)
                end
            end

            local function ShouldDig(inst)
                return FindStump(inst) ~= nil
            end

            AddBrainPostInit("pigbrain", function(brain)
                local root = brain.bt ~= nil and brain.bt.root or nil
                if root == nil or root.children == nil then
                    return
                end
                local pig = brain.inst
                local lumberjack = GLOBAL.WhileNode(function()
                    return pig.mvb_lumberjack and not GLOBAL.TheWorld.state.isnight
                end, "MVB Lumberjack",
                    GLOBAL.PriorityNode{
                        GLOBAL.WhileNode(function() return ShouldChop(pig) end, "MVB Chop",
                            GLOBAL.DoAction(pig, ChopAction, "MVB Chop", true)),
                        GLOBAL.WhileNode(function() return ShouldDig(pig) end, "MVB Dig",
                            GLOBAL.DoAction(pig, DigAction, "MVB Dig", true)),
                        GLOBAL.WhileNode(function() return ShouldSweep(pig) end, "MVB LumberSweep",
                            GLOBAL.DoAction(pig, SweepAction, "MVB LumberSweep", true)),
                        GLOBAL.WhileNode(function() return ShouldStore(pig) end, "MVB LumberStore",
                            GLOBAL.DoAction(pig, StoreAction, "MVB LumberStore", true)),
                        GLOBAL.Wander(pig, function() return GetAnchorPos(pig) end, function() return GetWorkerRadius(pig) end),
                    }, 1)
                for i, child in ipairs(root.children) do
                    local cond = child.children ~= nil and child.children[1] or nil
                    if cond ~= nil and cond.name == "IsDay" then
                        table.insert(root.children, i, lumberjack)
                        break
                    end
                end
            end)
        end)
    end
    --------------------------------------------------
    -- 功能二十六：忠诚猪人自动采摘（开关：pig_farmer_harvest）
    --------------------------------------------------
    if GetModConfigData("pig_farmer_harvest") then
        SafeCall("忠诚猪人自动采摘", function()
            local function IsMatureCrop(guy)
                if guy == nil or guy:HasTag("withered") or guy:HasTag("burnt") then
                    return false
                end
                if guy.prefab == "mvb_pseudo_base" or guy.prefab == "yellowstaff" or guy.prefab == "opalstaff" then
                    return false
                end
                -- 不采集玩家用蝴蝶种出的花（蜂箱启动工具，摘了影响产蜜）
                if guy.prefab == "flower" and guy.planted then
                    return false
                end
                if guy.prefab == "bullkelp_plant" then
                    local kx, ky, kz = guy.Transform:GetWorldPosition()
                    if GLOBAL.GetOceanDepthAtPosition(kx, ky, kz) ~= "SHALLOW" then
                        return false
                    end
                    local pick = guy.components.pickable
                    if pick == nil or not pick:CanBePicked() or pick.caninteractwith == false then
                        return false
                    end
                    for kdx = -8, 8, 4 do
                        for kdz = -8, 8, 4 do
                            if GLOBAL.TheWorld.Map:IsVisualGroundAtPoint(kx + kdx, 0, kz + kdz) then
                                return true
                            end
                        end
                    end
                    return false
                end
                local pickable = guy.components.pickable
                if pickable ~= nil and pickable:CanBePicked() and pickable.caninteractwith ~= false then
                    return true
                end
                local crop = guy.components.crop
                return crop ~= nil and crop:IsReadyForHarvest()
            end

            local function FindMatureCrop(inst)
                return FindAround(inst, GetWorkerRadius(inst), IsMatureCrop)
            end

            local function HarvestAction(inst)
                if inst.sg ~= nil and inst.sg:HasStateTag("busy") then
                    return
                end
                local crop = FindMatureCrop(inst)
                if crop ~= nil then
                    if crop.prefab == "bullkelp_plant" then
                        local kx, ky, kz = crop.Transform:GetWorldPosition()
                        local px, py, pz = inst.Transform:GetWorldPosition()
                        local dx, dz = px - kx, pz - kz
                        if dx * dx + dz * dz <= 13 * 13 then
                            if crop.components.pickable ~= nil and crop.components.pickable:CanBePicked() then
                                crop.components.pickable:Pick(inst)
                            end
                            return nil
                        end
                        local bestx, bestz, bestd = nil, nil, math.huge
                        for kdx = -8, 8, 4 do
                            for kdz = -8, 8, 4 do
                                if GLOBAL.TheWorld.Map:IsVisualGroundAtPoint(kx + kdx, 0, kz + kdz) then
                                    local dd = kdx * kdx + kdz * kdz
                                    if dd < bestd then
                                        bestd = dd
                                        bestx, bestz = kx + kdx, kz + kdz
                                    end
                                end
                            end
                        end
                        if bestx ~= nil then
                            return GLOBAL.BufferedAction(inst, nil, GLOBAL.ACTIONS.WALKTO, nil, GLOBAL.Vector3(bestx, 0, bestz), nil, 1)
                        end
                    end
                    if crop.components.crop ~= nil then
                        return GLOBAL.BufferedAction(inst, crop, GLOBAL.ACTIONS.HARVEST)
                    end
                    return GLOBAL.BufferedAction(inst, crop, GLOBAL.ACTIONS.PICK)
                end
            end

            local function ShouldHarvest(inst)
                local inv = inst.components.inventory
                return inv ~= nil and not inv:IsFull() and FindMatureCrop(inst) ~= nil
            end

            -- 农作掉落特化（多汁浆果/棱镜三花）：采摘产物掉地上；不管堆叠与否，范围内就尝试捡拾
            local function IsFarmDrop(guy)
                return guy ~= nil and (guy.prefab == "berries_juicy"
                    or guy.prefab == "cutted_rosebush"
                    or guy.prefab == "cutted_lilybush"
                    or guy.prefab == "cutted_orchidbush")
                    and guy.components.inventoryitem ~= nil
                    and guy.components.inventoryitem.owner == nil
                    and not guy:HasTag("INLIMBO") and not guy:HasTag("burnt")
            end
            local function ShouldPickupFarmDrop(inst)
                local inv = inst.components.inventory
                return inv ~= nil and not inv:IsFull()
                    and FindAround(inst, GetWorkerRadius(inst), IsFarmDrop) ~= nil
            end
            local function PickupFarmDropAction(inst)
                if inst.sg ~= nil and inst.sg:HasStateTag("busy") then return end
                local loot = FindAround(inst, GetWorkerRadius(inst), IsFarmDrop)
                if loot ~= nil then
                    if loot.components.inventoryitem ~= nil then
                        loot.components.inventoryitem.canbepickedup = true
                    end
                    return GLOBAL.BufferedAction(inst, loot, GLOBAL.ACTIONS.PICKUP)
                end
            end

            -- 农家猪行为：白天/黄昏 采摘→存放→房周围游走；夜晚走原版回房睡觉
            AddBrainPostInit("pigbrain", function(brain)
                local root = brain.bt ~= nil and brain.bt.root or nil
                if root == nil or root.children == nil then
                    return
                end
                local pig = brain.inst
                local farmer = GLOBAL.WhileNode(function()
                    return pig.mvb_farmer and not GLOBAL.TheWorld.state.isnight
                end, "MVB Farmer",
                    GLOBAL.PriorityNode{
                        GLOBAL.WhileNode(function() return ShouldHarvest(pig) end, "MVB Harvest",
                            GLOBAL.DoAction(pig, HarvestAction, "MVB Harvest", true)),
                        GLOBAL.WhileNode(function() return ShouldPickupFarmDrop(pig) end, "MVB FarmDropPickup",
                            GLOBAL.DoAction(pig, PickupFarmDropAction, "MVB FarmDropPickup", true)),
                        GLOBAL.WhileNode(function() return ShouldStore(pig) end, "MVB Store",
                            GLOBAL.DoAction(pig, StoreAction, "MVB Store", true)),
                        GLOBAL.Wander(pig, function() return GetAnchorPos(pig) end, function() return GetWorkerRadius(pig) end),
                    }, 1)
                for i, child in ipairs(root.children) do
                    local cond = child.children ~= nil and child.children[1] or nil
                    if cond ~= nil and cond.name == "IsDay" then
                        table.insert(root.children, i, farmer)
                        break
                    end
                end
            end)

            -- 功能二十六（续）：农家猪工作范围显示（开关：pig_farmer_range）
            if GetModConfigData("pig_farmer_range") then
                SafeCall("农家猪工作范围显示", function()
                    AddPrefabPostInit("pighouse", function(inst)
                        inst.mvb_farmer_flag = GLOBAL.net_int(inst.GUID, "mvb_farmer_flag")
                        inst.mvb_farmer_radius = GLOBAL.net_int(inst.GUID, "mvb_farmer_radius")
                        inst.mvb_cluster_center_net = GLOBAL.net_int(inst.GUID, "mvb_cluster_center_net")
                        inst.mvb_cluster_x_net = GLOBAL.net_int(inst.GUID, "mvb_cluster_x_net")
                        inst.mvb_cluster_z_net = GLOBAL.net_int(inst.GUID, "mvb_cluster_z_net")
                        if not GLOBAL.TheWorld.ismastersim then
                            return
                        end
                        inst:DoPeriodicTask(1, function()
                            local has = false
                            local r = 0
                            local cid = 0
                            local x, y, z = inst.Transform:GetWorldPosition()
                            if inst.mvb_cluster_x ~= nil then
                                -- 集群成员屋：统一显示集群中心 5 格范围
                                has = true
                                r = GLOBAL.math.floor(MVB_CLUSTER_RADIUS / 4)
                                cid = inst.mvb_cluster_center_id or 0
                            else
                                local pigs = GLOBAL.TheSim:FindEntities(x, y, z, 48, nil, nil, nil)
                                for _, p in ipairs(pigs) do
                                    if p.prefab == "pigman" and inst.mvb_playerbuilt == true and GetFarmHome(p) == inst
                                        and HasPigWorker(p) then
                                        has = true
                                        r = GLOBAL.math.floor(GetWorkerRadius(p) / 4)
                                        break
                                    end
                                end
                            end
                            inst.mvb_farmer_flag:set(has and 1 or 0)
                            inst.mvb_farmer_radius:set(r)
                            inst.mvb_cluster_center_net:set(cid)
                            inst.mvb_cluster_x_net:set(inst.mvb_cluster_x or 0)
                            inst.mvb_cluster_z_net:set(inst.mvb_cluster_z or 0)
                        end)
                    end)
                    AddSimPostInit(function()
                        if GLOBAL.TheNet:IsDedicated() then
                            return
                        end
                        if not InsightAvailable() then
                            return
                        end
                        local ring = nil
                        local attached = nil
                        GLOBAL.TheWorld:DoPeriodicTask(0.05, function()
                            local target = GLOBAL.TheInput:GetWorldEntityUnderMouse()
                            local show = target ~= nil and target:IsValid()
                                and target.prefab == "pighouse"
                                and target.mvb_farmer_flag ~= nil
                                and target.mvb_farmer_flag:value() == 1
                            if show then
                                if ring == nil or not ring:IsValid() then
                                    ring = GLOBAL.SpawnPrefab("insight_range_indicator")
                                    if ring ~= nil then
                                        ring:SetColour(GLOBAL.unpack(MVB_DISPLAY_COLOUR))
                                    end
                                end
                                if ring ~= nil then
                                    local attach_target = target
                                    local cid_net = 0

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:pigbrain

            AddBrainPostInit("pigbrain", function(brain)
                local root = brain.bt ~= nil and brain.bt.root or nil
                if root == nil or root.children == nil then
                    return
                end
                local pig = brain.inst
                local lumberjack = GLOBAL.WhileNode(function()
                    return pig.mvb_lumberjack and not GLOBAL.TheWorld.state.isnight
                end, "MVB Lumberjack",
                    GLOBAL.PriorityNode{
                        GLOBAL.WhileNode(function() return ShouldChop(pig) end, "MVB Chop",
                            GLOBAL.DoAction(pig, ChopAction, "MVB Chop", true)),
                        GLOBAL.WhileNode(function() return ShouldDig(pig) end, "MVB Dig",
                            GLOBAL.DoAction(pig, DigAction, "MVB Dig", true)),
                        GLOBAL.WhileNode(function() return ShouldSweep(pig) end, "MVB LumberSweep",
                            GLOBAL.DoAction(pig, SweepAction, "MVB LumberSweep", true)),
                        GLOBAL.WhileNode(function() return ShouldStore(pig) end, "MVB LumberStore",
                            GLOBAL.DoAction(pig, StoreAction, "MVB LumberStore", true)),
                        GLOBAL.Wander(pig, function() return GetAnchorPos(pig) end, function() return GetWorkerRadius(pig) end),
                    }, 1)
                for i, child in ipairs(root.children) do
                    local cond = child.children ~= nil and child.children[1] or nil
                    if cond ~= nil and cond.name == "IsDay" then
                        table.insert(root.children, i, lumberjack)
                        break
                    end
                end
            end)
        end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cookpot
            -- 锅的集群绑定随存档保存
            AddPrefabPostInit("cookpot", function(inst)
                if not GLOBAL.TheWorld.ismastersim then
                    return
                end
                local old_save = inst.OnSave
                inst.OnSave = function(i, data)
                    if old_save ~= nil then
                        old_save(i, data)
                    end
                    data.mvb_cook_cluster_x = i.mvb_cook_cluster_x
                    data.mvb_cook_cluster_z = i.mvb_cook_cluster_z
                end
                local old_load = inst.OnLoad
                inst.OnLoad = function(i, data)
                    if old_load ~= nil then
                        old_load(i, data)
                    end
                    if data ~= nil then
                        i.mvb_cook_cluster_x = data.mvb_cook_cluster_x
                        i.mvb_cook_cluster_z = data.mvb_cook_cluster_z
                    end
                end
            end)

```



### 变体演进：【附魔-海钓】 (Mod 3647461165)
- **变体场景与切面**：收录来自工坊 Mod 3647461165 (`【附魔-海钓】`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3647461165)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：熔炉武器汉化版 (Mod 2954835265)
- **变体场景与切面**：收录来自工坊 Mod 2954835265 (`熔炉武器汉化版`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2954835265)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:inventoryitem_classified
local a=_G.json;local b=_G.FRAMES;local c=_G.EQUIPSLOTS;local d=_G.STRINGS;local e=_G.EventHandler;local f=_G.State;local g=_G.ACTIONS;local h=_G.net_bool;local i=_G.net_float;local j=_G.net_string;local k=_G.TheNet;AddPrefabPostInit("inventoryitem_classified",function(l)l.isaltattacking=h(l.GUID,"weapon.isaltattacking")l.altattackrange=i(l.GUID,"weapon.altattackrange")end)AddPrefabPostInit("player_classified",function(l)l.net_buffs=j(l.GUID,"forge.net_buffs","net_buffs_dirty")if not k:IsDedicated()then l:ListenForEvent("net_buffs_dirty",function(l)if not l._parent or not l._parent.HUD or#l.net_buffs:value()<1 then return end;l.net_buffs:set_local("")l.net_buffs:set("")end)end end)AddPlayerPostInit(function(l)if l.components.health~=nil then l.components.health.hasmaxhpbuff=false end;if not l.components.buffable then l:AddComponent("buffable")end;if not l.components.colourfader then l:AddComponent("colourfader")end end)function _G.EntityScript:GetDisplayName()local m=self:GetAdjectivedName()if self.prefab~=nil then local n=d.NAME_DETAIL_EXTENTION[string.upper(self.nameoverride~=nil and self.nameoverride or self.prefab)]if n~=nil then return m.."\n"..n end end;return m end;_G.DAMAGETYPES={PHYSICAL=1,MAGIC=2}_G.DAMAGETYPE_IDS={}for o,p in pairs(_G.DAMAGETYPES)do _G.DAMAGETYPE_IDS[p]=o end;AddComponentPostInit("combat",function(self)self.damage_override=nil;self.damagetype=nil;self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}function self:SetDamageType(q)self.damagetype=q end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end end end;function self:CopyBuffsTo(y)if y and y.components.combat then y.components.combat.damagebuffs=self.damagebuffs end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then return u[s]~=nil else return u[t]~=nil and u[t][s]~=nil end end;_oldGetAttackRange=self.GetAttackRange;function self:GetAttackRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return z.components.weapon.altattackrange else return _oldGetAttackRange(self)end end;_oldGetHitRange=self.GetHitRange;function self:GetHitRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return self.attackrange+z.components.weapon.althitrange else return _oldGetHitRange(self)end end;_oldCalcDamage=self.CalcDamage;function self:CalcDamage(A,z,B)if A:HasTag("alwaysblock")then return 0 end;local C=_oldCalcDamage(self,A,z,B)local D=z~=nil and z.components.weapon.damage or self.defaultdamage;if z and z.components.weapon:CanAltAttack()or not z and self.damage_override then local E=0;if z then E=z.components.weapon.altdamagecalc~=nil and z.components.weapon.altdamagecalc(z,self.inst,A)or(z.components.weapon.altdamage or D)else E=type(self.damage_override)=="function"and self.damage_override(self.inst,A)or self.damage_override end;C=(C-(self.damagebonus or 0))/D;C=C*E+(self.damagebonus or 0)end;return C end;local function F(r,G,H,z,x)local I=1;local J=1;local K={common={additive={},multiplicative={}},overrides={additive={},multiplicative={}}}for t,p in pairs(self.damagebuffs[r and"recieved"or"dealt"])do for o,v in pairs(p)do local z=z or self:GetWeapon()local L=z~=nil and z.components.weapon or self;if t=="generic"or t=="stimuli"and x==o or t=="dmgtype"and L.damagetype and L.damagetype==_G.DAMAGETYPES[_G.DAMAGETYPE_IDS[o]]then if t=="generic"then if type(v)=="function"then local M,N,O=v(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][o]=M else K.common.additive[o]=v end else for P,Q in pairs(v)do if type(Q)=="function"then local M,N,O=Q(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][P]=M else K.common.additive[P]=Q end end end end end end;local R=false;if _G.GetTableSize(K.overrides.additive)>0 or _G.GetTableSize(K.overrides.multiplicative)>0 then R=true end;for S,v in pairs(K[R and"overrides"or"common"].multiplicative)do if v then J=J*v end end;for S,v in pairs(K[R and"overrides"or"common"].additive)do if v then I=I*(v+1)end end;if I==0 then I=1 end;if J==0 then J=1 end;return I,J end;function self:GetBuffMults(r,G,H,z,x)return F(r,G,H,z,x)end;_oldDoAttack=self.DoAttack;function self:DoAttack(T,z,U,x,V)local I,J=F(false,self.inst,T or self.target,z,x)local W=(V or 1)*J*I;_oldDoAttack(self,T,z,U,x,W)end;_oldGetAttacked=self.GetAttacked;function self:GetAttacked(G,X,z,x)local I,J=F(true,G,self.inst,z,x)X=X*J*I;return _oldGetAttacked(self,G,X,z,x)end;function self:DoAreaAttack(A,Y,z,Z,x,_)local a0=0;local a1,a2,a3=A.Transform:GetWorldPosition()local a4=_G.TheSim:FindEntities(a1,a2,a3,Y,{"_combat"},_)for P,y in ipairs(a4)do if y~=A and y~=self.inst and self:IsValidTarget(y)and(Z==nil or Z(y,self.inst))then self.inst:PushEvent("onareaattackother",{target=y,weapon=z,stimuli=x})local J=(self.areahitdamagepercent or 1)+F(false,self.inst,y,z,x)y.components.combat:GetAttacked(self.inst,self:CalcDamage(y,z,J),z,x)a0=a0+1 end end;return a0 end;function self:DoSpecialAttack(C,T,x,V,a5)self.damage_override=C;if a5 then self:DoAreaAttack(a5.target,a5.range,nil,a5.validfn,x,a5.excludetags)else self:DoAttack(T,nil,nil,x,V)end;self.damage_override=nil end end)AddComponentPostInit("weapon",function(self)self.hasaltattack=false;self.isaltattacking=false;self.altattackrange=nil;self.althitrange=nil;self.altdamage=nil;self.altdamagecalc=nil;self.altcondition=nil;self.altprojectile=nil;self._projectile=nil;self.damagetype=nil;self.altdamagetype=nil;self._damagetype=nil;function self:SetDamageType(q)self.damagetype=q;self._damagetype=q end;function self:SetStimuli(x)self.stimuli=x end;function self:SetProjectile(U)self.projectile=U;self._projectile=U end;function self:SetAltAttack(X,Y,a6,q,a7,a8)self.hasaltattack=true;self.altdamage=X~=nil and X or self.damage;if Y~=nil then self.altattackrange=type(Y)=="table"and Y[1]or Y or self.attackrange;self.althitrange=type(Y)=="table"and Y[2]or self.altattackrange else self.altattackrange=20;self.althitrange=20 end;self.altprojectile=a6;self.altdamagetype=q~=nil and q or self.damagetype;self.altdamagecalc=a7;self.altcondition=a8;if self.altdamagecalc then local a9=self.altdamagecalc;self.altdamagecalc=function(z,G,A)local C=a9(z,G,A)return C~=nil and C or self.altdamage end end;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)end end;function self:SetIsAltAttacking(aa)self.isaltattacking=aa;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetIsAltAttacking(aa)end;if aa then self.projectile=self.altprojectile;self.damagetype=self.altdamagetype else self.projectile=self._projectile;self.damagetype=self._damagetype end end;function self:HasAltAttack()return self.hasaltattack end;function self:CanAltAttack()if self:HasAltAttack()and self.isaltattacking then return self.altcondition~=nil and self.altcondition(self.inst)or true end end;_oldCanRangedAttack=self.CanRangedAttack;function self:CanRangedAttack()return self:CanAltAttack()and self.altprojectile or _oldCanRangedAttack(self)end;function self:DoAltAttack(G,T,U,x,V)self:SetIsAltAttacking(true)if G and G.components.combat and self:CanAltAttack()then if T and type(T)=="table"and not T.prefab then for S,y in ipairs(T)do if y~=G and y.entity:IsValid()and y.components.workable~=nil and self.inst.IsWorkableAllowed~=nil and type(self.inst.IsWorkableAllowed)=="function"and self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(),y)then local ab=self.inst.prefab:upper()if _G.TUNING.THE_FORGE_ITEM_PACK[ab]~=nil and _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG~=nil then y.components.workable:WorkedBy(G,_G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG)end end;if y~=G and G.components.combat:IsValidTarget(y)and y.components.health and not y.components.health:IsDead()then G.components.combat:DoAttack(y,self.inst,U,x,V)end end else if G.components.combat:IsValidTarget(T)then G.components.combat:DoAttack(T,self.inst,U,x,V)end end end;G:PushEvent("alt_attack_complete",{weapon=self.inst})self:SetIsAltAttacking(false)end end)AddComponentPostInit("health",function(self)self.buffs={}function self:GetHealthBuff()local ac=0;for s,v in pairs(self.buffs)do ac=ac+v end;return ac end;function self:HasHealthBuff(s)return self.buffs[s]end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then self.buffs[s]=v;self.maxhealth=self.maxhealth+self:GetHealthBuff()self.currenthealth=self.currenthealth+self:GetHealthBuff()end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.currenthealth=math.max(self.minhealth,self.currenthealth-self.buffs[s])self.maxhealth=math.max(self.minhealth,self.maxhealth-self.buffs[s])self.buffs[s]=nil end end end)AddComponentPostInit("equippable",function(self)self.uniquebuffs={}self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}self.healthbuffs={}function self:HasHealthBuff(s)return self.healthbuffs[s]~=nil end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:AddHealthBuff(s,v)end end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.healthbuffs[s]=nil;local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:RemoveHealthBuff(s)end end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageBuff(r,s,v)end end end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageTypeBuff(r,w,s,v)end end end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageStimuliBuff(r,x,s,v)end end end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:RemoveDamageBuff(r,s,t)end end end end;function self:AddBuffsTo(ad)if ad and ad.components.buffable then ad.components.buffable:AddBuff(self.inst.prefab,self.uniquebuffs)end end;function self:RemoveBuffsFrom(ad)if ad and ad.components.buffable then ad.components.buffable:RemoveBuff(self.inst.prefab)end end;function self:AddUniqueBuff(ae)for t,v in pairs(ae)do self.uniquebuffs[t]=v end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;function self:RemoveUniqueBuff(t)self.uniquebuffs[t]=nil;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;local af=self.Equip;function self:Equip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:AddDamageBuff(P=="recieved",t,v)else for ag,ah in pairs(v)do if o=="dmgtype"then ad.components.combat:AddDamageTypeBuff(P=="recieved",t,ag,ah)else ad.components.combat:AddDamageStimuliBuff(P=="recieved",t,ag,ah)end end end end end end end;self:AddBuffsTo(ad)af(self,ad)end;local ai=self.Unequip;function self:Unequip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:RemoveDamageBuff(P=="recieved",t)else for s,S in pairs(v)do ad.components.combat:RemoveDamageBuff(P=="recieved",s,t)end end end end end end;self:RemoveBuffsFrom(ad)ai(self,ad)end end)AddComponentPostInit("rechargeable",function(self)self.owner=nil;self.onequip=function(l,ae)if self.owner~=nil then self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))end end;self.onunequip=function(l,ae)self:RemoveChargeTimeMod(self.inst,l.prefab)end;self.inst:ListenForEvent("equipped",function(l,ae)self.owner=ae.owner;self.pickup=false;self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))if not self.updating then self.updating=true;self.inst:StartUpdatingComponent(self)end;self.inst:ListenForEvent("equip",self.onequip,l)self.inst:ListenForEvent("unequip",self.onunequip,l)end)self.inst:ListenForEvent("unequipped",function(l,ae)self.inst:RemoveEventCallback("equip",self.onequip,l)self.inst:RemoveEventCallback("unequip",self.onunequip,l)if self.pickup and self.updating then self.updating=false;self.inst:StopUpdatingComponent(self)end;self:RemoveChargeTimeMod(self.inst,l.prefab)self.owner=nil end)end)AddComponentPostInit("aoespell",function(self)self.spell_type=nil;function self:SetSpellType(aj)self.spell_type=aj end;local ak=self.CastSpell;function self:CastSpell(al,am)if self.inst.components.reticule_spawner~=nil then self.inst.components.reticule_spawner:Spawn(am)end;local an,ao=ak(self,al,am)self.inst:PushEvent("aoe_casted",{caster=al,pos=am})return an,ao end;function self:OnSpellCast(ap,aq,ar)ap:PushEvent("spell_complete",{weapon=self.inst,spell_type=self.spell_type,targets=aq,projectiles=ar})end end)AddClassPostConstruct("components/inventoryitem_replica",function(self)self.can_altattack_fn=function()return true end;function self:SetIsAltAttacking(aa)if self.classified~=nil then self.classified.isaltattacking:set(aa)end end;function self:SetAltAttackRange(Y)if self.classified~=nil then self.classified.altattackrange:set(Y or self:AttackRange())end end;function self:AltAttackRange()if self.inst.components.weapon then return self.inst.components.weapon.altattackrange elseif self.classified~=nil then return math.max(0,self.classified.altattackrange:value())else return self:AttackRange()end end;function self:SetAltAttackCheck(as)if as and type(as)=="function"then self.can_altattack_fn=as end end;function self:CanAltAttack()if self.classified~=nil and self.classified.isaltattacking:value()then return self.inst.components.weapon and self.components.weapon:CanAltAttack()or self.can_altattack_fn(self.inst)end end;_oldAttackRange=self.AttackRange;function self:AttackRange()return self:CanAltAttack()and self:AltAttackRange()or _oldAttackRange(self)end end)AddClassPostConstruct("components/combat_replica",function(self)local at=self.CanBeAttacked;function self:CanBeAttacked(G)if TUNING.PREVENT_COMPAGNION_ATTACK and(self.inst:HasTag("companion")and G and G:HasTag("player"))then return false end;return at(self,G)end end)local function au(l,av)local aw={livingstaff="heal_staff",infernalstaff="fireball"}if aw[av.prefab]then l.sg.statemem.projectilesound="dontstarve/common/lava_arena/"..aw[av.prefab]end end;AddStategraphPostInit("wilson",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.components.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddStategraphPostInit("wilson_client",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.replica.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddComponentPostInit("debuffable",function(self)local aA=self.AddDebuff;local aB=self.RemoveDebuff;function self:AddDebuff(m,...)if self.debuffs[m]==nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=false}))end;aA(self,m,...)end;function self:RemoveDebuff(m,...)if self.debuffs[m]~=nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=true}))end;aB(self,m,...)end end)local aC={book=25*b,castspell=53*b}local ab=function(...)end;for aD,aE in pairs(aC)do AddStategraphPostInit("wilson",function(self)local aF,aG,aH=self.states[aD].onenter or ab,self.states[aD].onexit or ab,self.states[aD].onupdate or ab;self.states[aD].onenter=function(l)l.sg.statemem.tm=0;l.sg.statemem.trgt=aE;l.sg.statemem.equip=l.components.inventory:GetEquippedItem(c.HANDS)aF(l)end;self.states[aD].onexit=function(l)if not l.sg.statemem.equip then return end;if l.sg.statemem.tm<l.sg.statemem.trgt and l.sg.statemem.equip.components.reticule_spawner then l.sg.statemem.equip.components.reticule_spawner:Interrupt()end;aG(l)end;self.states[aD].onupdate=function(l,aI)l.sg.statemem.tm=l.sg.statemem.tm+aI;aH(l)end end)end;local aJ={"spider","spider_warrior","tentacle","hound","firehound","icehound","krampus","knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare","spider_hider","spider_spitter","spider_dropper","bat","worm","spat","eyeplant","walrus","little_walrus","monkey","slurper","tallbird","frog","mosquito","bee","killerbee","pigguard","moonpig","merm","leif","leif_sparse","spiderqueen","deerclops","minotaur","warg","birchnutdrake","deciduoustree","bearger","moose","dragonfly","lavae","beeguard","cookiecutter","mutatedhound","houndcorpse","mutated_penguin","spider_moon","beequeen","klaus","stalker","stalker_forest","stalker_atrium","malbatross","pigman","koalefant_summer","koalefant_winter","slurtle","snurtle","beefalo","penguin","bunnyman","rocky","lightninggoat","catcoon","buzzard","mossling","antlion","gestalt","gnarwail","gnarwail_attack_horn","fruitdragon","squid","player"}for S,aK in ipairs(aJ)do AddPrefabPostInit(aK,function(l)if l.components and l.components.combat then l.components.combat:SetDamageType(1)end end)end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified
local a=_G.json;local b=_G.FRAMES;local c=_G.EQUIPSLOTS;local d=_G.STRINGS;local e=_G.EventHandler;local f=_G.State;local g=_G.ACTIONS;local h=_G.net_bool;local i=_G.net_float;local j=_G.net_string;local k=_G.TheNet;AddPrefabPostInit("inventoryitem_classified",function(l)l.isaltattacking=h(l.GUID,"weapon.isaltattacking")l.altattackrange=i(l.GUID,"weapon.altattackrange")end)AddPrefabPostInit("player_classified",function(l)l.net_buffs=j(l.GUID,"forge.net_buffs","net_buffs_dirty")if not k:IsDedicated()then l:ListenForEvent("net_buffs_dirty",function(l)if not l._parent or not l._parent.HUD or#l.net_buffs:value()<1 then return end;l.net_buffs:set_local("")l.net_buffs:set("")end)end end)AddPlayerPostInit(function(l)if l.components.health~=nil then l.components.health.hasmaxhpbuff=false end;if not l.components.buffable then l:AddComponent("buffable")end;if not l.components.colourfader then l:AddComponent("colourfader")end end)function _G.EntityScript:GetDisplayName()local m=self:GetAdjectivedName()if self.prefab~=nil then local n=d.NAME_DETAIL_EXTENTION[string.upper(self.nameoverride~=nil and self.nameoverride or self.prefab)]if n~=nil then return m.."\n"..n end end;return m end;_G.DAMAGETYPES={PHYSICAL=1,MAGIC=2}_G.DAMAGETYPE_IDS={}for o,p in pairs(_G.DAMAGETYPES)do _G.DAMAGETYPE_IDS[p]=o end;AddComponentPostInit("combat",function(self)self.damage_override=nil;self.damagetype=nil;self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}function self:SetDamageType(q)self.damagetype=q end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end end end;function self:CopyBuffsTo(y)if y and y.components.combat then y.components.combat.damagebuffs=self.damagebuffs end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then return u[s]~=nil else return u[t]~=nil and u[t][s]~=nil end end;_oldGetAttackRange=self.GetAttackRange;function self:GetAttackRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return z.components.weapon.altattackrange else return _oldGetAttackRange(self)end end;_oldGetHitRange=self.GetHitRange;function self:GetHitRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return self.attackrange+z.components.weapon.althitrange else return _oldGetHitRange(self)end end;_oldCalcDamage=self.CalcDamage;function self:CalcDamage(A,z,B)if A:HasTag("alwaysblock")then return 0 end;local C=_oldCalcDamage(self,A,z,B)local D=z~=nil and z.components.weapon.damage or self.defaultdamage;if z and z.components.weapon:CanAltAttack()or not z and self.damage_override then local E=0;if z then E=z.components.weapon.altdamagecalc~=nil and z.components.weapon.altdamagecalc(z,self.inst,A)or(z.components.weapon.altdamage or D)else E=type(self.damage_override)=="function"and self.damage_override(self.inst,A)or self.damage_override end;C=(C-(self.damagebonus or 0))/D;C=C*E+(self.damagebonus or 0)end;return C end;local function F(r,G,H,z,x)local I=1;local J=1;local K={common={additive={},multiplicative={}},overrides={additive={},multiplicative={}}}for t,p in pairs(self.damagebuffs[r and"recieved"or"dealt"])do for o,v in pairs(p)do local z=z or self:GetWeapon()local L=z~=nil and z.components.weapon or self;if t=="generic"or t=="stimuli"and x==o or t=="dmgtype"and L.damagetype and L.damagetype==_G.DAMAGETYPES[_G.DAMAGETYPE_IDS[o]]then if t=="generic"then if type(v)=="function"then local M,N,O=v(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][o]=M else K.common.additive[o]=v end else for P,Q in pairs(v)do if type(Q)=="function"then local M,N,O=Q(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][P]=M else K.common.additive[P]=Q end end end end end end;local R=false;if _G.GetTableSize(K.overrides.additive)>0 or _G.GetTableSize(K.overrides.multiplicative)>0 then R=true end;for S,v in pairs(K[R and"overrides"or"common"].multiplicative)do if v then J=J*v end end;for S,v in pairs(K[R and"overrides"or"common"].additive)do if v then I=I*(v+1)end end;if I==0 then I=1 end;if J==0 then J=1 end;return I,J end;function self:GetBuffMults(r,G,H,z,x)return F(r,G,H,z,x)end;_oldDoAttack=self.DoAttack;function self:DoAttack(T,z,U,x,V)local I,J=F(false,self.inst,T or self.target,z,x)local W=(V or 1)*J*I;_oldDoAttack(self,T,z,U,x,W)end;_oldGetAttacked=self.GetAttacked;function self:GetAttacked(G,X,z,x)local I,J=F(true,G,self.inst,z,x)X=X*J*I;return _oldGetAttacked(self,G,X,z,x)end;function self:DoAreaAttack(A,Y,z,Z,x,_)local a0=0;local a1,a2,a3=A.Transform:GetWorldPosition()local a4=_G.TheSim:FindEntities(a1,a2,a3,Y,{"_combat"},_)for P,y in ipairs(a4)do if y~=A and y~=self.inst and self:IsValidTarget(y)and(Z==nil or Z(y,self.inst))then self.inst:PushEvent("onareaattackother",{target=y,weapon=z,stimuli=x})local J=(self.areahitdamagepercent or 1)+F(false,self.inst,y,z,x)y.components.combat:GetAttacked(self.inst,self:CalcDamage(y,z,J),z,x)a0=a0+1 end end;return a0 end;function self:DoSpecialAttack(C,T,x,V,a5)self.damage_override=C;if a5 then self:DoAreaAttack(a5.target,a5.range,nil,a5.validfn,x,a5.excludetags)else self:DoAttack(T,nil,nil,x,V)end;self.damage_override=nil end end)AddComponentPostInit("weapon",function(self)self.hasaltattack=false;self.isaltattacking=false;self.altattackrange=nil;self.althitrange=nil;self.altdamage=nil;self.altdamagecalc=nil;self.altcondition=nil;self.altprojectile=nil;self._projectile=nil;self.damagetype=nil;self.altdamagetype=nil;self._damagetype=nil;function self:SetDamageType(q)self.damagetype=q;self._damagetype=q end;function self:SetStimuli(x)self.stimuli=x end;function self:SetProjectile(U)self.projectile=U;self._projectile=U end;function self:SetAltAttack(X,Y,a6,q,a7,a8)self.hasaltattack=true;self.altdamage=X~=nil and X or self.damage;if Y~=nil then self.altattackrange=type(Y)=="table"and Y[1]or Y or self.attackrange;self.althitrange=type(Y)=="table"and Y[2]or self.altattackrange else self.altattackrange=20;self.althitrange=20 end;self.altprojectile=a6;self.altdamagetype=q~=nil and q or self.damagetype;self.altdamagecalc=a7;self.altcondition=a8;if self.altdamagecalc then local a9=self.altdamagecalc;self.altdamagecalc=function(z,G,A)local C=a9(z,G,A)return C~=nil and C or self.altdamage end end;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)end end;function self:SetIsAltAttacking(aa)self.isaltattacking=aa;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetIsAltAttacking(aa)end;if aa then self.projectile=self.altprojectile;self.damagetype=self.altdamagetype else self.projectile=self._projectile;self.damagetype=self._damagetype end end;function self:HasAltAttack()return self.hasaltattack end;function self:CanAltAttack()if self:HasAltAttack()and self.isaltattacking then return self.altcondition~=nil and self.altcondition(self.inst)or true end end;_oldCanRangedAttack=self.CanRangedAttack;function self:CanRangedAttack()return self:CanAltAttack()and self.altprojectile or _oldCanRangedAttack(self)end;function self:DoAltAttack(G,T,U,x,V)self:SetIsAltAttacking(true)if G and G.components.combat and self:CanAltAttack()then if T and type(T)=="table"and not T.prefab then for S,y in ipairs(T)do if y~=G and y.entity:IsValid()and y.components.workable~=nil and self.inst.IsWorkableAllowed~=nil and type(self.inst.IsWorkableAllowed)=="function"and self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(),y)then local ab=self.inst.prefab:upper()if _G.TUNING.THE_FORGE_ITEM_PACK[ab]~=nil and _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG~=nil then y.components.workable:WorkedBy(G,_G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG)end end;if y~=G and G.components.combat:IsValidTarget(y)and y.components.health and not y.components.health:IsDead()then G.components.combat:DoAttack(y,self.inst,U,x,V)end end else if G.components.combat:IsValidTarget(T)then G.components.combat:DoAttack(T,self.inst,U,x,V)end end end;G:PushEvent("alt_attack_complete",{weapon=self.inst})self:SetIsAltAttacking(false)end end)AddComponentPostInit("health",function(self)self.buffs={}function self:GetHealthBuff()local ac=0;for s,v in pairs(self.buffs)do ac=ac+v end;return ac end;function self:HasHealthBuff(s)return self.buffs[s]end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then self.buffs[s]=v;self.maxhealth=self.maxhealth+self:GetHealthBuff()self.currenthealth=self.currenthealth+self:GetHealthBuff()end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.currenthealth=math.max(self.minhealth,self.currenthealth-self.buffs[s])self.maxhealth=math.max(self.minhealth,self.maxhealth-self.buffs[s])self.buffs[s]=nil end end end)AddComponentPostInit("equippable",function(self)self.uniquebuffs={}self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}self.healthbuffs={}function self:HasHealthBuff(s)return self.healthbuffs[s]~=nil end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:AddHealthBuff(s,v)end end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.healthbuffs[s]=nil;local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:RemoveHealthBuff(s)end end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageBuff(r,s,v)end end end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageTypeBuff(r,w,s,v)end end end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageStimuliBuff(r,x,s,v)end end end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:RemoveDamageBuff(r,s,t)end end end end;function self:AddBuffsTo(ad)if ad and ad.components.buffable then ad.components.buffable:AddBuff(self.inst.prefab,self.uniquebuffs)end end;function self:RemoveBuffsFrom(ad)if ad and ad.components.buffable then ad.components.buffable:RemoveBuff(self.inst.prefab)end end;function self:AddUniqueBuff(ae)for t,v in pairs(ae)do self.uniquebuffs[t]=v end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;function self:RemoveUniqueBuff(t)self.uniquebuffs[t]=nil;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;local af=self.Equip;function self:Equip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:AddDamageBuff(P=="recieved",t,v)else for ag,ah in pairs(v)do if o=="dmgtype"then ad.components.combat:AddDamageTypeBuff(P=="recieved",t,ag,ah)else ad.components.combat:AddDamageStimuliBuff(P=="recieved",t,ag,ah)end end end end end end end;self:AddBuffsTo(ad)af(self,ad)end;local ai=self.Unequip;function self:Unequip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:RemoveDamageBuff(P=="recieved",t)else for s,S in pairs(v)do ad.components.combat:RemoveDamageBuff(P=="recieved",s,t)end end end end end end;self:RemoveBuffsFrom(ad)ai(self,ad)end end)AddComponentPostInit("rechargeable",function(self)self.owner=nil;self.onequip=function(l,ae)if self.owner~=nil then self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))end end;self.onunequip=function(l,ae)self:RemoveChargeTimeMod(self.inst,l.prefab)end;self.inst:ListenForEvent("equipped",function(l,ae)self.owner=ae.owner;self.pickup=false;self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))if not self.updating then self.updating=true;self.inst:StartUpdatingComponent(self)end;self.inst:ListenForEvent("equip",self.onequip,l)self.inst:ListenForEvent("unequip",self.onunequip,l)end)self.inst:ListenForEvent("unequipped",function(l,ae)self.inst:RemoveEventCallback("equip",self.onequip,l)self.inst:RemoveEventCallback("unequip",self.onunequip,l)if self.pickup and self.updating then self.updating=false;self.inst:StopUpdatingComponent(self)end;self:RemoveChargeTimeMod(self.inst,l.prefab)self.owner=nil end)end)AddComponentPostInit("aoespell",function(self)self.spell_type=nil;function self:SetSpellType(aj)self.spell_type=aj end;local ak=self.CastSpell;function self:CastSpell(al,am)if self.inst.components.reticule_spawner~=nil then self.inst.components.reticule_spawner:Spawn(am)end;local an,ao=ak(self,al,am)self.inst:PushEvent("aoe_casted",{caster=al,pos=am})return an,ao end;function self:OnSpellCast(ap,aq,ar)ap:PushEvent("spell_complete",{weapon=self.inst,spell_type=self.spell_type,targets=aq,projectiles=ar})end end)AddClassPostConstruct("components/inventoryitem_replica",function(self)self.can_altattack_fn=function()return true end;function self:SetIsAltAttacking(aa)if self.classified~=nil then self.classified.isaltattacking:set(aa)end end;function self:SetAltAttackRange(Y)if self.classified~=nil then self.classified.altattackrange:set(Y or self:AttackRange())end end;function self:AltAttackRange()if self.inst.components.weapon then return self.inst.components.weapon.altattackrange elseif self.classified~=nil then return math.max(0,self.classified.altattackrange:value())else return self:AttackRange()end end;function self:SetAltAttackCheck(as)if as and type(as)=="function"then self.can_altattack_fn=as end end;function self:CanAltAttack()if self.classified~=nil and self.classified.isaltattacking:value()then return self.inst.components.weapon and self.components.weapon:CanAltAttack()or self.can_altattack_fn(self.inst)end end;_oldAttackRange=self.AttackRange;function self:AttackRange()return self:CanAltAttack()and self:AltAttackRange()or _oldAttackRange(self)end end)AddClassPostConstruct("components/combat_replica",function(self)local at=self.CanBeAttacked;function self:CanBeAttacked(G)if TUNING.PREVENT_COMPAGNION_ATTACK and(self.inst:HasTag("companion")and G and G:HasTag("player"))then return false end;return at(self,G)end end)local function au(l,av)local aw={livingstaff="heal_staff",infernalstaff="fireball"}if aw[av.prefab]then l.sg.statemem.projectilesound="dontstarve/common/lava_arena/"..aw[av.prefab]end end;AddStategraphPostInit("wilson",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.components.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddStategraphPostInit("wilson_client",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.replica.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddComponentPostInit("debuffable",function(self)local aA=self.AddDebuff;local aB=self.RemoveDebuff;function self:AddDebuff(m,...)if self.debuffs[m]==nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=false}))end;aA(self,m,...)end;function self:RemoveDebuff(m,...)if self.debuffs[m]~=nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=true}))end;aB(self,m,...)end end)local aC={book=25*b,castspell=53*b}local ab=function(...)end;for aD,aE in pairs(aC)do AddStategraphPostInit("wilson",function(self)local aF,aG,aH=self.states[aD].onenter or ab,self.states[aD].onexit or ab,self.states[aD].onupdate or ab;self.states[aD].onenter=function(l)l.sg.statemem.tm=0;l.sg.statemem.trgt=aE;l.sg.statemem.equip=l.components.inventory:GetEquippedItem(c.HANDS)aF(l)end;self.states[aD].onexit=function(l)if not l.sg.statemem.equip then return end;if l.sg.statemem.tm<l.sg.statemem.trgt and l.sg.statemem.equip.components.reticule_spawner then l.sg.statemem.equip.components.reticule_spawner:Interrupt()end;aG(l)end;self.states[aD].onupdate=function(l,aI)l.sg.statemem.tm=l.sg.statemem.tm+aI;aH(l)end end)end;local aJ={"spider","spider_warrior","tentacle","hound","firehound","icehound","krampus","knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare","spider_hider","spider_spitter","spider_dropper","bat","worm","spat","eyeplant","walrus","little_walrus","monkey","slurper","tallbird","frog","mosquito","bee","killerbee","pigguard","moonpig","merm","leif","leif_sparse","spiderqueen","deerclops","minotaur","warg","birchnutdrake","deciduoustree","bearger","moose","dragonfly","lavae","beeguard","cookiecutter","mutatedhound","houndcorpse","mutated_penguin","spider_moon","beequeen","klaus","stalker","stalker_forest","stalker_atrium","malbatross","pigman","koalefant_summer","koalefant_winter","slurtle","snurtle","beefalo","penguin","bunnyman","rocky","lightninggoat","catcoon","buzzard","mossling","antlion","gestalt","gnarwail","gnarwail_attack_horn","fruitdragon","squid","player"}for S,aK in ipairs(aJ)do AddPrefabPostInit(aK,function(l)if l.components and l.components.combat then l.components.combat:SetDamageType(1)end end)end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
local a=_G.json;local b=_G.FRAMES;local c=_G.EQUIPSLOTS;local d=_G.STRINGS;local e=_G.EventHandler;local f=_G.State;local g=_G.ACTIONS;local h=_G.net_bool;local i=_G.net_float;local j=_G.net_string;local k=_G.TheNet;AddPrefabPostInit("inventoryitem_classified",function(l)l.isaltattacking=h(l.GUID,"weapon.isaltattacking")l.altattackrange=i(l.GUID,"weapon.altattackrange")end)AddPrefabPostInit("player_classified",function(l)l.net_buffs=j(l.GUID,"forge.net_buffs","net_buffs_dirty")if not k:IsDedicated()then l:ListenForEvent("net_buffs_dirty",function(l)if not l._parent or not l._parent.HUD or#l.net_buffs:value()<1 then return end;l.net_buffs:set_local("")l.net_buffs:set("")end)end end)AddPlayerPostInit(function(l)if l.components.health~=nil then l.components.health.hasmaxhpbuff=false end;if not l.components.buffable then l:AddComponent("buffable")end;if not l.components.colourfader then l:AddComponent("colourfader")end end)function _G.EntityScript:GetDisplayName()local m=self:GetAdjectivedName()if self.prefab~=nil then local n=d.NAME_DETAIL_EXTENTION[string.upper(self.nameoverride~=nil and self.nameoverride or self.prefab)]if n~=nil then return m.."\n"..n end end;return m end;_G.DAMAGETYPES={PHYSICAL=1,MAGIC=2}_G.DAMAGETYPE_IDS={}for o,p in pairs(_G.DAMAGETYPES)do _G.DAMAGETYPE_IDS[p]=o end;AddComponentPostInit("combat",function(self)self.damage_override=nil;self.damagetype=nil;self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}function self:SetDamageType(q)self.damagetype=q end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end end end;function self:CopyBuffsTo(y)if y and y.components.combat then y.components.combat.damagebuffs=self.damagebuffs end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then return u[s]~=nil else return u[t]~=nil and u[t][s]~=nil end end;_oldGetAttackRange=self.GetAttackRange;function self:GetAttackRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return z.components.weapon.altattackrange else return _oldGetAttackRange(self)end end;_oldGetHitRange=self.GetHitRange;function self:GetHitRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return self.attackrange+z.components.weapon.althitrange else return _oldGetHitRange(self)end end;_oldCalcDamage=self.CalcDamage;function self:CalcDamage(A,z,B)if A:HasTag("alwaysblock")then return 0 end;local C=_oldCalcDamage(self,A,z,B)local D=z~=nil and z.components.weapon.damage or self.defaultdamage;if z and z.components.weapon:CanAltAttack()or not z and self.damage_override then local E=0;if z then E=z.components.weapon.altdamagecalc~=nil and z.components.weapon.altdamagecalc(z,self.inst,A)or(z.components.weapon.altdamage or D)else E=type(self.damage_override)=="function"and self.damage_override(self.inst,A)or self.damage_override end;C=(C-(self.damagebonus or 0))/D;C=C*E+(self.damagebonus or 0)end;return C end;local function F(r,G,H,z,x)local I=1;local J=1;local K={common={additive={},multiplicative={}},overrides={additive={},multiplicative={}}}for t,p in pairs(self.damagebuffs[r and"recieved"or"dealt"])do for o,v in pairs(p)do local z=z or self:GetWeapon()local L=z~=nil and z.components.weapon or self;if t=="generic"or t=="stimuli"and x==o or t=="dmgtype"and L.damagetype and L.damagetype==_G.DAMAGETYPES[_G.DAMAGETYPE_IDS[o]]then if t=="generic"then if type(v)=="function"then local M,N,O=v(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][o]=M else K.common.additive[o]=v end else for P,Q in pairs(v)do if type(Q)=="function"then local M,N,O=Q(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][P]=M else K.common.additive[P]=Q end end end end end end;local R=false;if _G.GetTableSize(K.overrides.additive)>0 or _G.GetTableSize(K.overrides.multiplicative)>0 then R=true end;for S,v in pairs(K[R and"overrides"or"common"].multiplicative)do if v then J=J*v end end;for S,v in pairs(K[R and"overrides"or"common"].additive)do if v then I=I*(v+1)end end;if I==0 then I=1 end;if J==0 then J=1 end;return I,J end;function self:GetBuffMults(r,G,H,z,x)return F(r,G,H,z,x)end;_oldDoAttack=self.DoAttack;function self:DoAttack(T,z,U,x,V)local I,J=F(false,self.inst,T or self.target,z,x)local W=(V or 1)*J*I;_oldDoAttack(self,T,z,U,x,W)end;_oldGetAttacked=self.GetAttacked;function self:GetAttacked(G,X,z,x)local I,J=F(true,G,self.inst,z,x)X=X*J*I;return _oldGetAttacked(self,G,X,z,x)end;function self:DoAreaAttack(A,Y,z,Z,x,_)local a0=0;local a1,a2,a3=A.Transform:GetWorldPosition()local a4=_G.TheSim:FindEntities(a1,a2,a3,Y,{"_combat"},_)for P,y in ipairs(a4)do if y~=A and y~=self.inst and self:IsValidTarget(y)and(Z==nil or Z(y,self.inst))then self.inst:PushEvent("onareaattackother",{target=y,weapon=z,stimuli=x})local J=(self.areahitdamagepercent or 1)+F(false,self.inst,y,z,x)y.components.combat:GetAttacked(self.inst,self:CalcDamage(y,z,J),z,x)a0=a0+1 end end;return a0 end;function self:DoSpecialAttack(C,T,x,V,a5)self.damage_override=C;if a5 then self:DoAreaAttack(a5.target,a5.range,nil,a5.validfn,x,a5.excludetags)else self:DoAttack(T,nil,nil,x,V)end;self.damage_override=nil end end)AddComponentPostInit("weapon",function(self)self.hasaltattack=false;self.isaltattacking=false;self.altattackrange=nil;self.althitrange=nil;self.altdamage=nil;self.altdamagecalc=nil;self.altcondition=nil;self.altprojectile=nil;self._projectile=nil;self.damagetype=nil;self.altdamagetype=nil;self._damagetype=nil;function self:SetDamageType(q)self.damagetype=q;self._damagetype=q end;function self:SetStimuli(x)self.stimuli=x end;function self:SetProjectile(U)self.projectile=U;self._projectile=U end;function self:SetAltAttack(X,Y,a6,q,a7,a8)self.hasaltattack=true;self.altdamage=X~=nil and X or self.damage;if Y~=nil then self.altattackrange=type(Y)=="table"and Y[1]or Y or self.attackrange;self.althitrange=type(Y)=="table"and Y[2]or self.altattackrange else self.altattackrange=20;self.althitrange=20 end;self.altprojectile=a6;self.altdamagetype=q~=nil and q or self.damagetype;self.altdamagecalc=a7;self.altcondition=a8;if self.altdamagecalc then local a9=self.altdamagecalc;self.altdamagecalc=function(z,G,A)local C=a9(z,G,A)return C~=nil and C or self.altdamage end end;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)end end;function self:SetIsAltAttacking(aa)self.isaltattacking=aa;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetIsAltAttacking(aa)end;if aa then self.projectile=self.altprojectile;self.damagetype=self.altdamagetype else self.projectile=self._projectile;self.damagetype=self._damagetype end end;function self:HasAltAttack()return self.hasaltattack end;function self:CanAltAttack()if self:HasAltAttack()and self.isaltattacking then return self.altcondition~=nil and self.altcondition(self.inst)or true end end;_oldCanRangedAttack=self.CanRangedAttack;function self:CanRangedAttack()return self:CanAltAttack()and self.altprojectile or _oldCanRangedAttack(self)end;function self:DoAltAttack(G,T,U,x,V)self:SetIsAltAttacking(true)if G and G.components.combat and self:CanAltAttack()then if T and type(T)=="table"and not T.prefab then for S,y in ipairs(T)do if y~=G and y.entity:IsValid()and y.components.workable~=nil and self.inst.IsWorkableAllowed~=nil and type(self.inst.IsWorkableAllowed)=="function"and self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(),y)then local ab=self.inst.prefab:upper()if _G.TUNING.THE_FORGE_ITEM_PACK[ab]~=nil and _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG~=nil then y.components.workable:WorkedBy(G,_G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG)end end;if y~=G and G.components.combat:IsValidTarget(y)and y.components.health and not y.components.health:IsDead()then G.components.combat:DoAttack(y,self.inst,U,x,V)end end else if G.components.combat:IsValidTarget(T)then G.components.combat:DoAttack(T,self.inst,U,x,V)end end end;G:PushEvent("alt_attack_complete",{weapon=self.inst})self:SetIsAltAttacking(false)end end)AddComponentPostInit("health",function(self)self.buffs={}function self:GetHealthBuff()local ac=0;for s,v in pairs(self.buffs)do ac=ac+v end;return ac end;function self:HasHealthBuff(s)return self.buffs[s]end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then self.buffs[s]=v;self.maxhealth=self.maxhealth+self:GetHealthBuff()self.currenthealth=self.currenthealth+self:GetHealthBuff()end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.currenthealth=math.max(self.minhealth,self.currenthealth-self.buffs[s])self.maxhealth=math.max(self.minhealth,self.maxhealth-self.buffs[s])self.buffs[s]=nil end end end)AddComponentPostInit("equippable",function(self)self.uniquebuffs={}self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}self.healthbuffs={}function self:HasHealthBuff(s)return self.healthbuffs[s]~=nil end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:AddHealthBuff(s,v)end end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.healthbuffs[s]=nil;local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:RemoveHealthBuff(s)end end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageBuff(r,s,v)end end end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageTypeBuff(r,w,s,v)end end end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageStimuliBuff(r,x,s,v)end end end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:RemoveDamageBuff(r,s,t)end end end end;function self:AddBuffsTo(ad)if ad and ad.components.buffable then ad.components.buffable:AddBuff(self.inst.prefab,self.uniquebuffs)end end;function self:RemoveBuffsFrom(ad)if ad and ad.components.buffable then ad.components.buffable:RemoveBuff(self.inst.prefab)end end;function self:AddUniqueBuff(ae)for t,v in pairs(ae)do self.uniquebuffs[t]=v end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;function self:RemoveUniqueBuff(t)self.uniquebuffs[t]=nil;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;local af=self.Equip;function self:Equip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:AddDamageBuff(P=="recieved",t,v)else for ag,ah in pairs(v)do if o=="dmgtype"then ad.components.combat:AddDamageTypeBuff(P=="recieved",t,ag,ah)else ad.components.combat:AddDamageStimuliBuff(P=="recieved",t,ag,ah)end end end end end end end;self:AddBuffsTo(ad)af(self,ad)end;local ai=self.Unequip;function self:Unequip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:RemoveDamageBuff(P=="recieved",t)else for s,S in pairs(v)do ad.components.combat:RemoveDamageBuff(P=="recieved",s,t)end end end end end end;self:RemoveBuffsFrom(ad)ai(self,ad)end end)AddComponentPostInit("rechargeable",function(self)self.owner=nil;self.onequip=function(l,ae)if self.owner~=nil then self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))end end;self.onunequip=function(l,ae)self:RemoveChargeTimeMod(self.inst,l.prefab)end;self.inst:ListenForEvent("equipped",function(l,ae)self.owner=ae.owner;self.pickup=false;self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))if not self.updating then self.updating=true;self.inst:StartUpdatingComponent(self)end;self.inst:ListenForEvent("equip",self.onequip,l)self.inst:ListenForEvent("unequip",self.onunequip,l)end)self.inst:ListenForEvent("unequipped",function(l,ae)self.inst:RemoveEventCallback("equip",self.onequip,l)self.inst:RemoveEventCallback("unequip",self.onunequip,l)if self.pickup and self.updating then self.updating=false;self.inst:StopUpdatingComponent(self)end;self:RemoveChargeTimeMod(self.inst,l.prefab)self.owner=nil end)end)AddComponentPostInit("aoespell",function(self)self.spell_type=nil;function self:SetSpellType(aj)self.spell_type=aj end;local ak=self.CastSpell;function self:CastSpell(al,am)if self.inst.components.reticule_spawner~=nil then self.inst.components.reticule_spawner:Spawn(am)end;local an,ao=ak(self,al,am)self.inst:PushEvent("aoe_casted",{caster=al,pos=am})return an,ao end;function self:OnSpellCast(ap,aq,ar)ap:PushEvent("spell_complete",{weapon=self.inst,spell_type=self.spell_type,targets=aq,projectiles=ar})end end)AddClassPostConstruct("components/inventoryitem_replica",function(self)self.can_altattack_fn=function()return true end;function self:SetIsAltAttacking(aa)if self.classified~=nil then self.classified.isaltattacking:set(aa)end end;function self:SetAltAttackRange(Y)if self.classified~=nil then self.classified.altattackrange:set(Y or self:AttackRange())end end;function self:AltAttackRange()if self.inst.components.weapon then return self.inst.components.weapon.altattackrange elseif self.classified~=nil then return math.max(0,self.classified.altattackrange:value())else return self:AttackRange()end end;function self:SetAltAttackCheck(as)if as and type(as)=="function"then self.can_altattack_fn=as end end;function self:CanAltAttack()if self.classified~=nil and self.classified.isaltattacking:value()then return self.inst.components.weapon and self.components.weapon:CanAltAttack()or self.can_altattack_fn(self.inst)end end;_oldAttackRange=self.AttackRange;function self:AttackRange()return self:CanAltAttack()and self:AltAttackRange()or _oldAttackRange(self)end end)AddClassPostConstruct("components/combat_replica",function(self)local at=self.CanBeAttacked;function self:CanBeAttacked(G)if TUNING.PREVENT_COMPAGNION_ATTACK and(self.inst:HasTag("companion")and G and G:HasTag("player"))then return false end;return at(self,G)end end)local function au(l,av)local aw={livingstaff="heal_staff",infernalstaff="fireball"}if aw[av.prefab]then l.sg.statemem.projectilesound="dontstarve/common/lava_arena/"..aw[av.prefab]end end;AddStategraphPostInit("wilson",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.components.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddStategraphPostInit("wilson_client",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.replica.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddComponentPostInit("debuffable",function(self)local aA=self.AddDebuff;local aB=self.RemoveDebuff;function self:AddDebuff(m,...)if self.debuffs[m]==nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=false}))end;aA(self,m,...)end;function self:RemoveDebuff(m,...)if self.debuffs[m]~=nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=true}))end;aB(self,m,...)end end)local aC={book=25*b,castspell=53*b}local ab=function(...)end;for aD,aE in pairs(aC)do AddStategraphPostInit("wilson",function(self)local aF,aG,aH=self.states[aD].onenter or ab,self.states[aD].onexit or ab,self.states[aD].onupdate or ab;self.states[aD].onenter=function(l)l.sg.statemem.tm=0;l.sg.statemem.trgt=aE;l.sg.statemem.equip=l.components.inventory:GetEquippedItem(c.HANDS)aF(l)end;self.states[aD].onexit=function(l)if not l.sg.statemem.equip then return end;if l.sg.statemem.tm<l.sg.statemem.trgt and l.sg.statemem.equip.components.reticule_spawner then l.sg.statemem.equip.components.reticule_spawner:Interrupt()end;aG(l)end;self.states[aD].onupdate=function(l,aI)l.sg.statemem.tm=l.sg.statemem.tm+aI;aH(l)end end)end;local aJ={"spider","spider_warrior","tentacle","hound","firehound","icehound","krampus","knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare","spider_hider","spider_spitter","spider_dropper","bat","worm","spat","eyeplant","walrus","little_walrus","monkey","slurper","tallbird","frog","mosquito","bee","killerbee","pigguard","moonpig","merm","leif","leif_sparse","spiderqueen","deerclops","minotaur","warg","birchnutdrake","deciduoustree","bearger","moose","dragonfly","lavae","beeguard","cookiecutter","mutatedhound","houndcorpse","mutated_penguin","spider_moon","beequeen","klaus","stalker","stalker_forest","stalker_atrium","malbatross","pigman","koalefant_summer","koalefant_winter","slurtle","snurtle","beefalo","penguin","bunnyman","rocky","lightninggoat","catcoon","buzzard","mossling","antlion","gestalt","gnarwail","gnarwail_attack_horn","fruitdragon","squid","player"}for S,aK in ipairs(aJ)do AddPrefabPostInit(aK,function(l)if l.components and l.components.combat then l.components.combat:SetDamageType(1)end end)end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:weapon
local a=_G.json;local b=_G.FRAMES;local c=_G.EQUIPSLOTS;local d=_G.STRINGS;local e=_G.EventHandler;local f=_G.State;local g=_G.ACTIONS;local h=_G.net_bool;local i=_G.net_float;local j=_G.net_string;local k=_G.TheNet;AddPrefabPostInit("inventoryitem_classified",function(l)l.isaltattacking=h(l.GUID,"weapon.isaltattacking")l.altattackrange=i(l.GUID,"weapon.altattackrange")end)AddPrefabPostInit("player_classified",function(l)l.net_buffs=j(l.GUID,"forge.net_buffs","net_buffs_dirty")if not k:IsDedicated()then l:ListenForEvent("net_buffs_dirty",function(l)if not l._parent or not l._parent.HUD or#l.net_buffs:value()<1 then return end;l.net_buffs:set_local("")l.net_buffs:set("")end)end end)AddPlayerPostInit(function(l)if l.components.health~=nil then l.components.health.hasmaxhpbuff=false end;if not l.components.buffable then l:AddComponent("buffable")end;if not l.components.colourfader then l:AddComponent("colourfader")end end)function _G.EntityScript:GetDisplayName()local m=self:GetAdjectivedName()if self.prefab~=nil then local n=d.NAME_DETAIL_EXTENTION[string.upper(self.nameoverride~=nil and self.nameoverride or self.prefab)]if n~=nil then return m.."\n"..n end end;return m end;_G.DAMAGETYPES={PHYSICAL=1,MAGIC=2}_G.DAMAGETYPE_IDS={}for o,p in pairs(_G.DAMAGETYPES)do _G.DAMAGETYPE_IDS[p]=o end;AddComponentPostInit("combat",function(self)self.damage_override=nil;self.damagetype=nil;self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}function self:SetDamageType(q)self.damagetype=q end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end end end;function self:CopyBuffsTo(y)if y and y.components.combat then y.components.combat.damagebuffs=self.damagebuffs end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then return u[s]~=nil else return u[t]~=nil and u[t][s]~=nil end end;_oldGetAttackRange=self.GetAttackRange;function self:GetAttackRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return z.components.weapon.altattackrange else return _oldGetAttackRange(self)end end;_oldGetHitRange=self.GetHitRange;function self:GetHitRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return self.attackrange+z.components.weapon.althitrange else return _oldGetHitRange(self)end end;_oldCalcDamage=self.CalcDamage;function self:CalcDamage(A,z,B)if A:HasTag("alwaysblock")then return 0 end;local C=_oldCalcDamage(self,A,z,B)local D=z~=nil and z.components.weapon.damage or self.defaultdamage;if z and z.components.weapon:CanAltAttack()or not z and self.damage_override then local E=0;if z then E=z.components.weapon.altdamagecalc~=nil and z.components.weapon.altdamagecalc(z,self.inst,A)or(z.components.weapon.altdamage or D)else E=type(self.damage_override)=="function"and self.damage_override(self.inst,A)or self.damage_override end;C=(C-(self.damagebonus or 0))/D;C=C*E+(self.damagebonus or 0)end;return C end;local function F(r,G,H,z,x)local I=1;local J=1;local K={common={additive={},multiplicative={}},overrides={additive={},multiplicative={}}}for t,p in pairs(self.damagebuffs[r and"recieved"or"dealt"])do for o,v in pairs(p)do local z=z or self:GetWeapon()local L=z~=nil and z.components.weapon or self;if t=="generic"or t=="stimuli"and x==o or t=="dmgtype"and L.damagetype and L.damagetype==_G.DAMAGETYPES[_G.DAMAGETYPE_IDS[o]]then if t=="generic"then if type(v)=="function"then local M,N,O=v(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][o]=M else K.common.additive[o]=v end else for P,Q in pairs(v)do if type(Q)=="function"then local M,N,O=Q(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][P]=M else K.common.additive[P]=Q end end end end end end;local R=false;if _G.GetTableSize(K.overrides.additive)>0 or _G.GetTableSize(K.overrides.multiplicative)>0 then R=true end;for S,v in pairs(K[R and"overrides"or"common"].multiplicative)do if v then J=J*v end end;for S,v in pairs(K[R and"overrides"or"common"].additive)do if v then I=I*(v+1)end end;if I==0 then I=1 end;if J==0 then J=1 end;return I,J end;function self:GetBuffMults(r,G,H,z,x)return F(r,G,H,z,x)end;_oldDoAttack=self.DoAttack;function self:DoAttack(T,z,U,x,V)local I,J=F(false,self.inst,T or self.target,z,x)local W=(V or 1)*J*I;_oldDoAttack(self,T,z,U,x,W)end;_oldGetAttacked=self.GetAttacked;function self:GetAttacked(G,X,z,x)local I,J=F(true,G,self.inst,z,x)X=X*J*I;return _oldGetAttacked(self,G,X,z,x)end;function self:DoAreaAttack(A,Y,z,Z,x,_)local a0=0;local a1,a2,a3=A.Transform:GetWorldPosition()local a4=_G.TheSim:FindEntities(a1,a2,a3,Y,{"_combat"},_)for P,y in ipairs(a4)do if y~=A and y~=self.inst and self:IsValidTarget(y)and(Z==nil or Z(y,self.inst))then self.inst:PushEvent("onareaattackother",{target=y,weapon=z,stimuli=x})local J=(self.areahitdamagepercent or 1)+F(false,self.inst,y,z,x)y.components.combat:GetAttacked(self.inst,self:CalcDamage(y,z,J),z,x)a0=a0+1 end end;return a0 end;function self:DoSpecialAttack(C,T,x,V,a5)self.damage_override=C;if a5 then self:DoAreaAttack(a5.target,a5.range,nil,a5.validfn,x,a5.excludetags)else self:DoAttack(T,nil,nil,x,V)end;self.damage_override=nil end end)AddComponentPostInit("weapon",function(self)self.hasaltattack=false;self.isaltattacking=false;self.altattackrange=nil;self.althitrange=nil;self.altdamage=nil;self.altdamagecalc=nil;self.altcondition=nil;self.altprojectile=nil;self._projectile=nil;self.damagetype=nil;self.altdamagetype=nil;self._damagetype=nil;function self:SetDamageType(q)self.damagetype=q;self._damagetype=q end;function self:SetStimuli(x)self.stimuli=x end;function self:SetProjectile(U)self.projectile=U;self._projectile=U end;function self:SetAltAttack(X,Y,a6,q,a7,a8)self.hasaltattack=true;self.altdamage=X~=nil and X or self.damage;if Y~=nil then self.altattackrange=type(Y)=="table"and Y[1]or Y or self.attackrange;self.althitrange=type(Y)=="table"and Y[2]or self.altattackrange else self.altattackrange=20;self.althitrange=20 end;self.altprojectile=a6;self.altdamagetype=q~=nil and q or self.damagetype;self.altdamagecalc=a7;self.altcondition=a8;if self.altdamagecalc then local a9=self.altdamagecalc;self.altdamagecalc=function(z,G,A)local C=a9(z,G,A)return C~=nil and C or self.altdamage end end;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)end end;function self:SetIsAltAttacking(aa)self.isaltattacking=aa;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetIsAltAttacking(aa)end;if aa then self.projectile=self.altprojectile;self.damagetype=self.altdamagetype else self.projectile=self._projectile;self.damagetype=self._damagetype end end;function self:HasAltAttack()return self.hasaltattack end;function self:CanAltAttack()if self:HasAltAttack()and self.isaltattacking then return self.altcondition~=nil and self.altcondition(self.inst)or true end end;_oldCanRangedAttack=self.CanRangedAttack;function self:CanRangedAttack()return self:CanAltAttack()and self.altprojectile or _oldCanRangedAttack(self)end;function self:DoAltAttack(G,T,U,x,V)self:SetIsAltAttacking(true)if G and G.components.combat and self:CanAltAttack()then if T and type(T)=="table"and not T.prefab then for S,y in ipairs(T)do if y~=G and y.entity:IsValid()and y.components.workable~=nil and self.inst.IsWorkableAllowed~=nil and type(self.inst.IsWorkableAllowed)=="function"and self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(),y)then local ab=self.inst.prefab:upper()if _G.TUNING.THE_FORGE_ITEM_PACK[ab]~=nil and _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG~=nil then y.components.workable:WorkedBy(G,_G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG)end end;if y~=G and G.components.combat:IsValidTarget(y)and y.components.health and not y.components.health:IsDead()then G.components.combat:DoAttack(y,self.inst,U,x,V)end end else if G.components.combat:IsValidTarget(T)then G.components.combat:DoAttack(T,self.inst,U,x,V)end end end;G:PushEvent("alt_attack_complete",{weapon=self.inst})self:SetIsAltAttacking(false)end end)AddComponentPostInit("health",function(self)self.buffs={}function self:GetHealthBuff()local ac=0;for s,v in pairs(self.buffs)do ac=ac+v end;return ac end;function self:HasHealthBuff(s)return self.buffs[s]end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then self.buffs[s]=v;self.maxhealth=self.maxhealth+self:GetHealthBuff()self.currenthealth=self.currenthealth+self:GetHealthBuff()end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.currenthealth=math.max(self.minhealth,self.currenthealth-self.buffs[s])self.maxhealth=math.max(self.minhealth,self.maxhealth-self.buffs[s])self.buffs[s]=nil end end end)AddComponentPostInit("equippable",function(self)self.uniquebuffs={}self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}self.healthbuffs={}function self:HasHealthBuff(s)return self.healthbuffs[s]~=nil end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:AddHealthBuff(s,v)end end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.healthbuffs[s]=nil;local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:RemoveHealthBuff(s)end end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageBuff(r,s,v)end end end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageTypeBuff(r,w,s,v)end end end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageStimuliBuff(r,x,s,v)end end end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:RemoveDamageBuff(r,s,t)end end end end;function self:AddBuffsTo(ad)if ad and ad.components.buffable then ad.components.buffable:AddBuff(self.inst.prefab,self.uniquebuffs)end end;function self:RemoveBuffsFrom(ad)if ad and ad.components.buffable then ad.components.buffable:RemoveBuff(self.inst.prefab)end end;function self:AddUniqueBuff(ae)for t,v in pairs(ae)do self.uniquebuffs[t]=v end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;function self:RemoveUniqueBuff(t)self.uniquebuffs[t]=nil;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;local af=self.Equip;function self:Equip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:AddDamageBuff(P=="recieved",t,v)else for ag,ah in pairs(v)do if o=="dmgtype"then ad.components.combat:AddDamageTypeBuff(P=="recieved",t,ag,ah)else ad.components.combat:AddDamageStimuliBuff(P=="recieved",t,ag,ah)end end end end end end end;self:AddBuffsTo(ad)af(self,ad)end;local ai=self.Unequip;function self:Unequip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:RemoveDamageBuff(P=="recieved",t)else for s,S in pairs(v)do ad.components.combat:RemoveDamageBuff(P=="recieved",s,t)end end end end end end;self:RemoveBuffsFrom(ad)ai(self,ad)end end)AddComponentPostInit("rechargeable",function(self)self.owner=nil;self.onequip=function(l,ae)if self.owner~=nil then self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))end end;self.onunequip=function(l,ae)self:RemoveChargeTimeMod(self.inst,l.prefab)end;self.inst:ListenForEvent("equipped",function(l,ae)self.owner=ae.owner;self.pickup=false;self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))if not self.updating then self.updating=true;self.inst:StartUpdatingComponent(self)end;self.inst:ListenForEvent("equip",self.onequip,l)self.inst:ListenForEvent("unequip",self.onunequip,l)end)self.inst:ListenForEvent("unequipped",function(l,ae)self.inst:RemoveEventCallback("equip",self.onequip,l)self.inst:RemoveEventCallback("unequip",self.onunequip,l)if self.pickup and self.updating then self.updating=false;self.inst:StopUpdatingComponent(self)end;self:RemoveChargeTimeMod(self.inst,l.prefab)self.owner=nil end)end)AddComponentPostInit("aoespell",function(self)self.spell_type=nil;function self:SetSpellType(aj)self.spell_type=aj end;local ak=self.CastSpell;function self:CastSpell(al,am)if self.inst.components.reticule_spawner~=nil then self.inst.components.reticule_spawner:Spawn(am)end;local an,ao=ak(self,al,am)self.inst:PushEvent("aoe_casted",{caster=al,pos=am})return an,ao end;function self:OnSpellCast(ap,aq,ar)ap:PushEvent("spell_complete",{weapon=self.inst,spell_type=self.spell_type,targets=aq,projectiles=ar})end end)AddClassPostConstruct("components/inventoryitem_replica",function(self)self.can_altattack_fn=function()return true end;function self:SetIsAltAttacking(aa)if self.classified~=nil then self.classified.isaltattacking:set(aa)end end;function self:SetAltAttackRange(Y)if self.classified~=nil then self.classified.altattackrange:set(Y or self:AttackRange())end end;function self:AltAttackRange()if self.inst.components.weapon then return self.inst.components.weapon.altattackrange elseif self.classified~=nil then return math.max(0,self.classified.altattackrange:value())else return self:AttackRange()end end;function self:SetAltAttackCheck(as)if as and type(as)=="function"then self.can_altattack_fn=as end end;function self:CanAltAttack()if self.classified~=nil and self.classified.isaltattacking:value()then return self.inst.components.weapon and self.components.weapon:CanAltAttack()or self.can_altattack_fn(self.inst)end end;_oldAttackRange=self.AttackRange;function self:AttackRange()return self:CanAltAttack()and self:AltAttackRange()or _oldAttackRange(self)end end)AddClassPostConstruct("components/combat_replica",function(self)local at=self.CanBeAttacked;function self:CanBeAttacked(G)if TUNING.PREVENT_COMPAGNION_ATTACK and(self.inst:HasTag("companion")and G and G:HasTag("player"))then return false end;return at(self,G)end end)local function au(l,av)local aw={livingstaff="heal_staff",infernalstaff="fireball"}if aw[av.prefab]then l.sg.statemem.projectilesound="dontstarve/common/lava_arena/"..aw[av.prefab]end end;AddStategraphPostInit("wilson",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.components.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddStategraphPostInit("wilson_client",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.replica.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddComponentPostInit("debuffable",function(self)local aA=self.AddDebuff;local aB=self.RemoveDebuff;function self:AddDebuff(m,...)if self.debuffs[m]==nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=false}))end;aA(self,m,...)end;function self:RemoveDebuff(m,...)if self.debuffs[m]~=nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=true}))end;aB(self,m,...)end end)local aC={book=25*b,castspell=53*b}local ab=function(...)end;for aD,aE in pairs(aC)do AddStategraphPostInit("wilson",function(self)local aF,aG,aH=self.states[aD].onenter or ab,self.states[aD].onexit or ab,self.states[aD].onupdate or ab;self.states[aD].onenter=function(l)l.sg.statemem.tm=0;l.sg.statemem.trgt=aE;l.sg.statemem.equip=l.components.inventory:GetEquippedItem(c.HANDS)aF(l)end;self.states[aD].onexit=function(l)if not l.sg.statemem.equip then return end;if l.sg.statemem.tm<l.sg.statemem.trgt and l.sg.statemem.equip.components.reticule_spawner then l.sg.statemem.equip.components.reticule_spawner:Interrupt()end;aG(l)end;self.states[aD].onupdate=function(l,aI)l.sg.statemem.tm=l.sg.statemem.tm+aI;aH(l)end end)end;local aJ={"spider","spider_warrior","tentacle","hound","firehound","icehound","krampus","knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare","spider_hider","spider_spitter","spider_dropper","bat","worm","spat","eyeplant","walrus","little_walrus","monkey","slurper","tallbird","frog","mosquito","bee","killerbee","pigguard","moonpig","merm","leif","leif_sparse","spiderqueen","deerclops","minotaur","warg","birchnutdrake","deciduoustree","bearger","moose","dragonfly","lavae","beeguard","cookiecutter","mutatedhound","houndcorpse","mutated_penguin","spider_moon","beequeen","klaus","stalker","stalker_forest","stalker_atrium","malbatross","pigman","koalefant_summer","koalefant_winter","slurtle","snurtle","beefalo","penguin","bunnyman","rocky","lightninggoat","catcoon","buzzard","mossling","antlion","gestalt","gnarwail","gnarwail_attack_horn","fruitdragon","squid","player"}for S,aK in ipairs(aJ)do AddPrefabPostInit(aK,function(l)if l.components and l.components.combat then l.components.combat:SetDamageType(1)end end)end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:health
local a=_G.json;local b=_G.FRAMES;local c=_G.EQUIPSLOTS;local d=_G.STRINGS;local e=_G.EventHandler;local f=_G.State;local g=_G.ACTIONS;local h=_G.net_bool;local i=_G.net_float;local j=_G.net_string;local k=_G.TheNet;AddPrefabPostInit("inventoryitem_classified",function(l)l.isaltattacking=h(l.GUID,"weapon.isaltattacking")l.altattackrange=i(l.GUID,"weapon.altattackrange")end)AddPrefabPostInit("player_classified",function(l)l.net_buffs=j(l.GUID,"forge.net_buffs","net_buffs_dirty")if not k:IsDedicated()then l:ListenForEvent("net_buffs_dirty",function(l)if not l._parent or not l._parent.HUD or#l.net_buffs:value()<1 then return end;l.net_buffs:set_local("")l.net_buffs:set("")end)end end)AddPlayerPostInit(function(l)if l.components.health~=nil then l.components.health.hasmaxhpbuff=false end;if not l.components.buffable then l:AddComponent("buffable")end;if not l.components.colourfader then l:AddComponent("colourfader")end end)function _G.EntityScript:GetDisplayName()local m=self:GetAdjectivedName()if self.prefab~=nil then local n=d.NAME_DETAIL_EXTENTION[string.upper(self.nameoverride~=nil and self.nameoverride or self.prefab)]if n~=nil then return m.."\n"..n end end;return m end;_G.DAMAGETYPES={PHYSICAL=1,MAGIC=2}_G.DAMAGETYPE_IDS={}for o,p in pairs(_G.DAMAGETYPES)do _G.DAMAGETYPE_IDS[p]=o end;AddComponentPostInit("combat",function(self)self.damage_override=nil;self.damagetype=nil;self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}function self:SetDamageType(q)self.damagetype=q end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end end end;function self:CopyBuffsTo(y)if y and y.components.combat then y.components.combat.damagebuffs=self.damagebuffs end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then return u[s]~=nil else return u[t]~=nil and u[t][s]~=nil end end;_oldGetAttackRange=self.GetAttackRange;function self:GetAttackRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return z.components.weapon.altattackrange else return _oldGetAttackRange(self)end end;_oldGetHitRange=self.GetHitRange;function self:GetHitRange()local z=self:GetWeapon()if z and z.components.weapon:CanAltAttack()then return self.attackrange+z.components.weapon.althitrange else return _oldGetHitRange(self)end end;_oldCalcDamage=self.CalcDamage;function self:CalcDamage(A,z,B)if A:HasTag("alwaysblock")then return 0 end;local C=_oldCalcDamage(self,A,z,B)local D=z~=nil and z.components.weapon.damage or self.defaultdamage;if z and z.components.weapon:CanAltAttack()or not z and self.damage_override then local E=0;if z then E=z.components.weapon.altdamagecalc~=nil and z.components.weapon.altdamagecalc(z,self.inst,A)or(z.components.weapon.altdamage or D)else E=type(self.damage_override)=="function"and self.damage_override(self.inst,A)or self.damage_override end;C=(C-(self.damagebonus or 0))/D;C=C*E+(self.damagebonus or 0)end;return C end;local function F(r,G,H,z,x)local I=1;local J=1;local K={common={additive={},multiplicative={}},overrides={additive={},multiplicative={}}}for t,p in pairs(self.damagebuffs[r and"recieved"or"dealt"])do for o,v in pairs(p)do local z=z or self:GetWeapon()local L=z~=nil and z.components.weapon or self;if t=="generic"or t=="stimuli"and x==o or t=="dmgtype"and L.damagetype and L.damagetype==_G.DAMAGETYPES[_G.DAMAGETYPE_IDS[o]]then if t=="generic"then if type(v)=="function"then local M,N,O=v(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][o]=M else K.common.additive[o]=v end else for P,Q in pairs(v)do if type(Q)=="function"then local M,N,O=Q(G,H,z,x)K[O and"overrides"or"common"][N and"multiplicative"or"additive"][P]=M else K.common.additive[P]=Q end end end end end end;local R=false;if _G.GetTableSize(K.overrides.additive)>0 or _G.GetTableSize(K.overrides.multiplicative)>0 then R=true end;for S,v in pairs(K[R and"overrides"or"common"].multiplicative)do if v then J=J*v end end;for S,v in pairs(K[R and"overrides"or"common"].additive)do if v then I=I*(v+1)end end;if I==0 then I=1 end;if J==0 then J=1 end;return I,J end;function self:GetBuffMults(r,G,H,z,x)return F(r,G,H,z,x)end;_oldDoAttack=self.DoAttack;function self:DoAttack(T,z,U,x,V)local I,J=F(false,self.inst,T or self.target,z,x)local W=(V or 1)*J*I;_oldDoAttack(self,T,z,U,x,W)end;_oldGetAttacked=self.GetAttacked;function self:GetAttacked(G,X,z,x)local I,J=F(true,G,self.inst,z,x)X=X*J*I;return _oldGetAttacked(self,G,X,z,x)end;function self:DoAreaAttack(A,Y,z,Z,x,_)local a0=0;local a1,a2,a3=A.Transform:GetWorldPosition()local a4=_G.TheSim:FindEntities(a1,a2,a3,Y,{"_combat"},_)for P,y in ipairs(a4)do if y~=A and y~=self.inst and self:IsValidTarget(y)and(Z==nil or Z(y,self.inst))then self.inst:PushEvent("onareaattackother",{target=y,weapon=z,stimuli=x})local J=(self.areahitdamagepercent or 1)+F(false,self.inst,y,z,x)y.components.combat:GetAttacked(self.inst,self:CalcDamage(y,z,J),z,x)a0=a0+1 end end;return a0 end;function self:DoSpecialAttack(C,T,x,V,a5)self.damage_override=C;if a5 then self:DoAreaAttack(a5.target,a5.range,nil,a5.validfn,x,a5.excludetags)else self:DoAttack(T,nil,nil,x,V)end;self.damage_override=nil end end)AddComponentPostInit("weapon",function(self)self.hasaltattack=false;self.isaltattacking=false;self.altattackrange=nil;self.althitrange=nil;self.altdamage=nil;self.altdamagecalc=nil;self.altcondition=nil;self.altprojectile=nil;self._projectile=nil;self.damagetype=nil;self.altdamagetype=nil;self._damagetype=nil;function self:SetDamageType(q)self.damagetype=q;self._damagetype=q end;function self:SetStimuli(x)self.stimuli=x end;function self:SetProjectile(U)self.projectile=U;self._projectile=U end;function self:SetAltAttack(X,Y,a6,q,a7,a8)self.hasaltattack=true;self.altdamage=X~=nil and X or self.damage;if Y~=nil then self.altattackrange=type(Y)=="table"and Y[1]or Y or self.attackrange;self.althitrange=type(Y)=="table"and Y[2]or self.altattackrange else self.altattackrange=20;self.althitrange=20 end;self.altprojectile=a6;self.altdamagetype=q~=nil and q or self.damagetype;self.altdamagecalc=a7;self.altcondition=a8;if self.altdamagecalc then local a9=self.altdamagecalc;self.altdamagecalc=function(z,G,A)local C=a9(z,G,A)return C~=nil and C or self.altdamage end end;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)end end;function self:SetIsAltAttacking(aa)self.isaltattacking=aa;if self.inst.replica.inventoryitem then self.inst.replica.inventoryitem:SetIsAltAttacking(aa)end;if aa then self.projectile=self.altprojectile;self.damagetype=self.altdamagetype else self.projectile=self._projectile;self.damagetype=self._damagetype end end;function self:HasAltAttack()return self.hasaltattack end;function self:CanAltAttack()if self:HasAltAttack()and self.isaltattacking then return self.altcondition~=nil and self.altcondition(self.inst)or true end end;_oldCanRangedAttack=self.CanRangedAttack;function self:CanRangedAttack()return self:CanAltAttack()and self.altprojectile or _oldCanRangedAttack(self)end;function self:DoAltAttack(G,T,U,x,V)self:SetIsAltAttacking(true)if G and G.components.combat and self:CanAltAttack()then if T and type(T)=="table"and not T.prefab then for S,y in ipairs(T)do if y~=G and y.entity:IsValid()and y.components.workable~=nil and self.inst.IsWorkableAllowed~=nil and type(self.inst.IsWorkableAllowed)=="function"and self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(),y)then local ab=self.inst.prefab:upper()if _G.TUNING.THE_FORGE_ITEM_PACK[ab]~=nil and _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG~=nil then y.components.workable:WorkedBy(G,_G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG)end end;if y~=G and G.components.combat:IsValidTarget(y)and y.components.health and not y.components.health:IsDead()then G.components.combat:DoAttack(y,self.inst,U,x,V)end end else if G.components.combat:IsValidTarget(T)then G.components.combat:DoAttack(T,self.inst,U,x,V)end end end;G:PushEvent("alt_attack_complete",{weapon=self.inst})self:SetIsAltAttacking(false)end end)AddComponentPostInit("health",function(self)self.buffs={}function self:GetHealthBuff()local ac=0;for s,v in pairs(self.buffs)do ac=ac+v end;return ac end;function self:HasHealthBuff(s)return self.buffs[s]end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then self.buffs[s]=v;self.maxhealth=self.maxhealth+self:GetHealthBuff()self.currenthealth=self.currenthealth+self:GetHealthBuff()end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.currenthealth=math.max(self.minhealth,self.currenthealth-self.buffs[s])self.maxhealth=math.max(self.minhealth,self.maxhealth-self.buffs[s])self.buffs[s]=nil end end end)AddComponentPostInit("equippable",function(self)self.uniquebuffs={}self.damagebuffs={dealt={dmgtype={},stimuli={},generic={}},recieved={dmgtype={},stimuli={},generic={}}}self.healthbuffs={}function self:HasHealthBuff(s)return self.healthbuffs[s]~=nil end;function self:AddHealthBuff(s,v)if not self:HasHealthBuff(s)then local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:AddHealthBuff(s,v)end end end;function self:RemoveHealthBuff(s)if self:HasHealthBuff(s)then self.healthbuffs[s]=nil;local ad=self.inst.components.inventoryitem.owner;if ad.components.health then ad.components.health:RemoveHealthBuff(s)end end end;function self:HasDamageBuff(r,s,t)local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then if u[s]then return true end else if u[t]and u[t][s]then return true end end end;function self:AddDamageBuff(r,s,v)if not self:HasDamageBuff(r,s)then self.damagebuffs[r and"recieved"or"dealt"].generic[s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageBuff(r,s,v)end end end end;function self:AddDamageTypeBuff(r,w,s,v)if not self:HasDamageBuff(r,s,w)then local u=self.damagebuffs[r and"recieved"or"dealt"].dmgtype;if not u[w]then u[w]={}end;u[w][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageTypeBuff(r,w,s,v)end end end end;function self:AddDamageStimuliBuff(r,x,s,v)if not self:HasDamageBuff(r,s,x)then local u=self.damagebuffs[r and"recieved"or"dealt"].stimuli;if not u[x]then u[x]={}end;u[x][s]=v;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:AddDamageStimuliBuff(r,x,s,v)end end end end;function self:RemoveDamageBuff(r,s,t)if self:HasDamageBuff(r,s,t)then local u=self.damagebuffs[r and"recieved"or"dealt"][type(t)=="number"and"dmgtype"or(type(t)=="string"and"stimuli"or"generic")]if not t then u[s]=nil else u[t][s]=nil;if _G.GetTableSize(u[t])<1 then u[t]=nil end end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;if ad.components.combat then ad.components.combat:RemoveDamageBuff(r,s,t)end end end end;function self:AddBuffsTo(ad)if ad and ad.components.buffable then ad.components.buffable:AddBuff(self.inst.prefab,self.uniquebuffs)end end;function self:RemoveBuffsFrom(ad)if ad and ad.components.buffable then ad.components.buffable:RemoveBuff(self.inst.prefab)end end;function self:AddUniqueBuff(ae)for t,v in pairs(ae)do self.uniquebuffs[t]=v end;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;function self:RemoveUniqueBuff(t)self.uniquebuffs[t]=nil;if self:IsEquipped()then local ad=self.inst.components.inventoryitem.owner;self:AddBuffsTo(ad)end end;local af=self.Equip;function self:Equip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:AddDamageBuff(P=="recieved",t,v)else for ag,ah in pairs(v)do if o=="dmgtype"then ad.components.combat:AddDamageTypeBuff(P=="recieved",t,ag,ah)else ad.components.combat:AddDamageStimuliBuff(P=="recieved",t,ag,ah)end end end end end end end;self:AddBuffsTo(ad)af(self,ad)end;local ai=self.Unequip;function self:Unequip(ad)if ad.components.combat then for P,ae in pairs(self.damagebuffs)do for o,K in pairs(ae)do for t,v in pairs(K)do if o=="generic"then ad.components.combat:RemoveDamageBuff(P=="recieved",t)else for s,S in pairs(v)do ad.components.combat:RemoveDamageBuff(P=="recieved",s,t)end end end end end end;self:RemoveBuffsFrom(ad)ai(self,ad)end end)AddComponentPostInit("rechargeable",function(self)self.owner=nil;self.onequip=function(l,ae)if self.owner~=nil then self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))end end;self.onunequip=function(l,ae)self:RemoveChargeTimeMod(self.inst,l.prefab)end;self.inst:ListenForEvent("equipped",function(l,ae)self.owner=ae.owner;self.pickup=false;self:SetChargeTimeMod(self.inst,l.prefab,self.owner.components.buffable:GetBuffData("cooldown_mult"))if not self.updating then self.updating=true;self.inst:StartUpdatingComponent(self)end;self.inst:ListenForEvent("equip",self.onequip,l)self.inst:ListenForEvent("unequip",self.onunequip,l)end)self.inst:ListenForEvent("unequipped",function(l,ae)self.inst:RemoveEventCallback("equip",self.onequip,l)self.inst:RemoveEventCallback("unequip",self.onunequip,l)if self.pickup and self.updating then self.updating=false;self.inst:StopUpdatingComponent(self)end;self:RemoveChargeTimeMod(self.inst,l.prefab)self.owner=nil end)end)AddComponentPostInit("aoespell",function(self)self.spell_type=nil;function self:SetSpellType(aj)self.spell_type=aj end;local ak=self.CastSpell;function self:CastSpell(al,am)if self.inst.components.reticule_spawner~=nil then self.inst.components.reticule_spawner:Spawn(am)end;local an,ao=ak(self,al,am)self.inst:PushEvent("aoe_casted",{caster=al,pos=am})return an,ao end;function self:OnSpellCast(ap,aq,ar)ap:PushEvent("spell_complete",{weapon=self.inst,spell_type=self.spell_type,targets=aq,projectiles=ar})end end)AddClassPostConstruct("components/inventoryitem_replica",function(self)self.can_altattack_fn=function()return true end;function self:SetIsAltAttacking(aa)if self.classified~=nil then self.classified.isaltattacking:set(aa)end end;function self:SetAltAttackRange(Y)if self.classified~=nil then self.classified.altattackrange:set(Y or self:AttackRange())end end;function self:AltAttackRange()if self.inst.components.weapon then return self.inst.components.weapon.altattackrange elseif self.classified~=nil then return math.max(0,self.classified.altattackrange:value())else return self:AttackRange()end end;function self:SetAltAttackCheck(as)if as and type(as)=="function"then self.can_altattack_fn=as end end;function self:CanAltAttack()if self.classified~=nil and self.classified.isaltattacking:value()then return self.inst.components.weapon and self.components.weapon:CanAltAttack()or self.can_altattack_fn(self.inst)end end;_oldAttackRange=self.AttackRange;function self:AttackRange()return self:CanAltAttack()and self:AltAttackRange()or _oldAttackRange(self)end end)AddClassPostConstruct("components/combat_replica",function(self)local at=self.CanBeAttacked;function self:CanBeAttacked(G)if TUNING.PREVENT_COMPAGNION_ATTACK and(self.inst:HasTag("companion")and G and G:HasTag("player"))then return false end;return at(self,G)end end)local function au(l,av)local aw={livingstaff="heal_staff",infernalstaff="fireball"}if aw[av.prefab]then l.sg.statemem.projectilesound="dontstarve/common/lava_arena/"..aw[av.prefab]end end;AddStategraphPostInit("wilson",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.components.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddStategraphPostInit("wilson_client",function(self)local ax=self.states.attack.onenter;self.states.attack.onenter=function(l)local av=l.replica.inventory:GetEquippedItem(c.HANDS)if av then au(l,av)end;ax(l)end;local ay=self.actionhandlers[g.CASTAOE].deststate;self.actionhandlers[g.CASTAOE].deststate=function(l,az)if az.invobject:HasTag("parry")then return"parry_pre"end;return ay(l,az)end end)AddComponentPostInit("debuffable",function(self)local aA=self.AddDebuff;local aB=self.RemoveDebuff;function self:AddDebuff(m,...)if self.debuffs[m]==nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=false}))end;aA(self,m,...)end;function self:RemoveDebuff(m,...)if self.debuffs[m]~=nil and self.inst.player_classified then self.inst.player_classified.net_buffs:set(a.encode({name=m,removed=true}))end;aB(self,m,...)end end)local aC={book=25*b,castspell=53*b}local ab=function(...)end;for aD,aE in pairs(aC)do AddStategraphPostInit("wilson",function(self)local aF,aG,aH=self.states[aD].onenter or ab,self.states[aD].onexit or ab,self.states[aD].onupdate or ab;self.states[aD].onenter=function(l)l.sg.statemem.tm=0;l.sg.statemem.trgt=aE;l.sg.statemem.equip=l.components.inventory:GetEquippedItem(c.HANDS)aF(l)end;self.states[aD].onexit=function(l)if not l.sg.statemem.equip then return end;if l.sg.statemem.tm<l.sg.statemem.trgt and l.sg.statemem.equip.components.reticule_spawner then l.sg.statemem.equip.components.reticule_spawner:Interrupt()end;aG(l)end;self.states[aD].onupdate=function(l,aI)l.sg.statemem.tm=l.sg.statemem.tm+aI;aH(l)end end)end;local aJ={"spider","spider_warrior","tentacle","hound","firehound","icehound","krampus","knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare","spider_hider","spider_spitter","spider_dropper","bat","worm","spat","eyeplant","walrus","little_walrus","monkey","slurper","tallbird","frog","mosquito","bee","killerbee","pigguard","moonpig","merm","leif","leif_sparse","spiderqueen","deerclops","minotaur","warg","birchnutdrake","deciduoustree","bearger","moose","dragonfly","lavae","beeguard","cookiecutter","mutatedhound","houndcorpse","mutated_penguin","spider_moon","beequeen","klaus","stalker","stalker_forest","stalker_atrium","malbatross","pigman","koalefant_summer","koalefant_winter","slurtle","snurtle","beefalo","penguin","bunnyman","rocky","lightninggoat","catcoon","buzzard","mossling","antlion","gestalt","gnarwail","gnarwail_attack_horn","fruitdragon","squid","player"}for S,aK in ipairs(aJ)do AddPrefabPostInit(aK,function(l)if l.components and l.components.combat then l.components.combat:SetDamageType(1)end end)end

```



### 变体演进：海钓随机物品RR (Mod 2993464051)
- **变体场景与切面**：收录来自工坊 Mod 2993464051 (`海钓随机物品RR`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2993464051)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
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

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:researchlab3
--四本
AddRecipePostInit("researchlab3", function(self)
-- 将科技等级强制修改为 TECH.NONE
self.level = TECH.NONE
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:purplegem
--紫宝石
AddRecipePostInit("purplegem", function(self)
-- 将科技等级强制修改为 TECH.NONE
self.level = TECH.NONE
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:multiplayer_portal_moonrock

-- AddPrefabPostInit("multiplayer_portal_moonrock", function(inst)
--     inst:ListenForEvent("entitysleep", function() 
--         local x,y,z = inst.Transform:GetWorldPosition()
--         local ents = TheSim:FindEntities(x, 0, z, 10)
--         print("睡眠")
--         for k,v in pairs(ents or {}) do
--             print(k,v)
--         end
--     end)
-- end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:lootdropper

AddComponentPostInit("lootdropper", function(self, inst)
    self.DropLoot = function(self, pt) -- 只好覆盖原方法
        local prefabs = self:GenerateLoot()
        if self.inst:HasTag("burnt")
            or (self.inst.components.burnable ~= nil and
                self.inst.components.burnable:IsBurning() and
                (self.inst.components.fueled == nil or self.inst.components.burnable.ignorefuel)) then

            local isstructure = self.inst:HasTag("structure")
            for k, v in pairs(prefabs) do
                if TUNING.BURNED_LOOT_OVERRIDES[v] ~= nil then
                    prefabs[k] = TUNING.BURNED_LOOT_OVERRIDES[v]
                elseif PrefabExists(v.."_cooked") then
                    prefabs[k] = v.."_cooked"
                elseif PrefabExists("cooked"..v) then
                    prefabs[k] = "cooked"..v
                elseif (not isstructure and not self.inst:HasTag("tree")) or self.inst:HasTag("hive") then 
                    prefabs[k] = "ash"
                end
            end
        end
        for k, v in pairs(prefabs) do
            if math.random() > LOOT_GL then -- 就这里添加一下概率 每次掉落时判断一下
                self:SpawnLootPrefab(v, pt)
            end
        end
        if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
            local prefabname = string.upper(self.inst.prefab)
            local num_decor_loot = self.GetWintersFeastOrnaments ~= nil and self.GetWintersFeastOrnaments(self.inst) or TUNING.WINTERS_FEAST_TREE_DECOR_LOOT[prefabname] or nil
            if num_decor_loot ~= nil then
                for i = 1, num_decor_loot.basic do
                    self:SpawnLootPrefab(GetRandomBasicWinterOrnament(), pt)
                end
                if num_decor_loot.special ~= nil then
                    self:SpawnLootPrefab(num_decor_loot.special, pt)
                end
            elseif not TUNING.WINTERS_FEAST_LOOT_EXCLUSION[prefabname] and (self.inst:HasTag("monster") or self.inst:HasTag("animal")) then
                local loot = math.random()
                if loot < 0.005 then
                    self:SpawnLootPrefab(GetRandomBasicWinterOrnament(), pt)
                elseif loot < 0.20 then
                    self:SpawnLootPrefab("winter_food"..math.random(NUM_WINTERFOOD), pt)
                end
            end
        end

        TheWorld:PushEvent("entity_droploot", { inst = self.inst })
    end
end)


AddPrefabPostInit("wortox_soul_spawn", function(inst)
    -- 击杀生物时有33%概率掉落灵魂
    inst:DoTaskInTime(0,function(inst)
        if math.random() > SOUL_GL then
            inst:Remove()
        end
    end)
end)


AddPrefabPostInit("world", function(inst)
    if TheWorld.ismastersim then --判断是不是主机
        -- 给大门免费升级
        inst:DoTaskInTime(0,function(inst) 
            local items = {
                multiplayer_portal = true,
                multiplayer_portal_moonrock_constr = true,
            }
            local removed = {}
            for k,v in pairs(Ents) do
                if v.prefab ~= nil and items[v.prefab] then
                    table.insert(removed, v)
                end
            end
            for k,v in pairs(removed) do
                local dm = SpawnPrefab("multiplayer_portal_moonrock")
                local sp = SpawnPrefab("springlamp") -- 添加泉灯
                local x,y,z = v.Transform:GetWorldPosition()
                dm.Transform:SetPosition(x,y,z)
                sp.Transform:SetPosition(x + 4,y,z)
                v:Remove()
            end                
        end)
    end
end)

```



### 变体演进：Smart Expandable Gem Chests (Mod 3829905877)
- **变体场景与切面**：收录来自工坊 Mod 3829905877 (`Smart Expandable Gem Chests`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3829905877)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddRecipePostInit:treasurechest
if GetModConfigData("disable_treasurechest") then
    AddRecipePostInit("treasurechest", function(recipe)
        recipe.builder_tag = "gemchest_no_treasurechest"
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:stackable

AddComponentPostInit("stackable", function(self)
    local _SetIgnoreMaxSize = self.SetIgnoreMaxSize
    function self:SetIgnoreMaxSize(ignore)
        if not (ignore and stack_cap ~= nil) then
            return _SetIgnoreMaxSize(self, ignore)
        end
        local _ = _G.rawget(self, "_")
        local original = _.originalmaxsize[1]
        if original == nil then
            if _.maxsize[1] >= stack_cap then
                return   -- already stacks at least this high
            end
            _.originalmaxsize[1] = _.maxsize[1]
            self.inst.replica.stackable:SetIgnoreMaxSize(true)
        end
        _.maxsize[1] = math.max(stack_cap, self.stacksize)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:gemchest

AddPrefabPostInit("gemchest", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end
    local container = inst.components.container
    if T.STACK_SIZE > 0 then
        local _GiveItem = container.GiveItem
        function container:GiveItem(...)
            return WithStackCap(inst, _GiveItem, self, ...)
        end
        WithStackCap(inst, container.EnableInfiniteStackSize, container, true)
    else
        -- Big stacks saved while the option was on: split them back into
        -- normal stacks (into free slots, or dropped next to the chest).
        local _OnLoad = container.OnLoad
        function container:OnLoad(...)
            _OnLoad(self, ...)
            for slot = 1, self.numslots do
                local stackable = self.slots[slot] ~= nil and self.slots[slot].components.stackable or nil
                while stackable ~= nil and stackable:StackSize() > stackable.maxsize do
                    local extra = stackable:Get(math.min(stackable:StackSize() - stackable.maxsize, stackable.maxsize))
                    self:GiveItem(extra, nil, nil, true)
                end
            end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:playercontroller
-- the same way the crafting menu blocks zoom while it has focus.
AddComponentPostInit("playercontroller", function(self)
    local _DoCameraControl = self.DoCameraControl
    function self:DoCameraControl(...)
        if GemChestUI.HasFocus() then
            self.lastzoomtime = _G.GetStaticTime()
        end
        return _DoCameraControl(self, ...)
    end
end)

```



### 变体演进：Habis+ (Mod 3829792009)
- **变体场景与切面**：收录来自工坊 Mod 3829792009 (`Habis+`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3829792009)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(world)
    if GLOBAL.TheNet:IsDedicated() then return end
    local function UpdateWheelRecipeHint()
        local player = GLOBAL.ThePlayer
        local builder = player ~= nil and player.replica ~= nil and player.replica.builder or nil
        local known = builder ~= nil and builder.KnowsRecipe ~= nil
            and builder:KnowsRecipe("xxx6_mahoraga_wheel", true)
        STRINGS.RECIPE_DESC.XXX6_MAHORAGA_WHEEL = known
            and XXX6_WHEEL_UNLOCKED_DESCRIPTION or HABIS_TRANSLATE("I have not tamed Mahoraga yet", "Я ещё не подчинил махорагу")
    end
    world:DoPeriodicTask(.5, UpdateWheelRecipeHint, .2)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:friendly_soul

AddPrefabPostInit("friendly_soul", function(inst)
    if inst.displayname == nil or inst.displayname == "Missing Name"
        or inst.displayname == "" then
        inst.displayname = HABIS_TRANSLATE("Prison Realm", "Тюремное царство")
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat

AddComponentPostInit("combat", function(combat)
    local old_can = combat.CanTarget
    combat.CanTarget = function(self, target, ...)
        if target ~= nil and target.prefab == "ghost" then return false end
        return old_can(self, target, ...)
    end
    local old_attack = combat.DoAttack
    combat.DoAttack = function(self, target, ...)
        local victim = target or self.target
        if self.inst.prefab == "ghost" or (victim ~= nil and victim.prefab == "ghost") then
            return false
        end
        return old_attack(self, target, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ghost

AddPrefabPostInit("ghost", function(inst)
    if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim then
        inst:DoTaskInTime(0,function(g)
            local d = GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld._xxx6_sukuna_recent_death or nil
            if d ~= nil and GLOBAL.GetTime() <= d[3] and g:IsValid() then
                local x,_,z=g.Transform:GetWorldPosition()
                if (x-d[1])^2+(z-d[2])^2 <= 9 then g:Remove() end
            end
        end)
    end
    inst:AddTag("notarget")
    inst:AddTag("noattack")
    if not GLOBAL.TheWorld.ismastersim then return end
    inst:DoTaskInTime(0, function(g)
        if not g:IsValid() then return end
        if g.components.combat ~= nil then
            local combat = g.components.combat
            combat:SetTarget(nil)
            combat.CanTarget = function() return false end
            combat.SetTarget = function() end
            combat.DoAttack = function() return false end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:lootdropper

AddComponentPostInit("lootdropper", function(self, inst)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then return end
    local _DropLoot = self.DropLoot
    if _DropLoot == nil then return end
    self.DropLoot = function(s, ...)
        if inst ~= nil and inst._xxx6_captured_on_death == true then return end
        if inst ~= nil and GetoKitTryAbsorbOnDeath(inst) then return end
        return _DropLoot(s, ...)
    end
end)

```



### 变体演进：Mod 3826330138 (Mod 3826330138)
- **变体场景与切面**：收录来自工坊 Mod 3826330138 (`Mod 3826330138`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3826330138)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wathgrithr

AddPrefabPostInit("wathgrithr", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("inspirationdelta", function(player, data)
        local insp = player.components.singinginspiration
        if insp == nil or not player:HasTag("wvmscoreuser") then
            return
        end
        local newslots = (data ~= nil and data.slots_available) or insp.available_slots
        local last = player.wvm_last_slots
        player.wvm_last_slots = newslots
        if last ~= nil and newslots > last then
            -- 上升穿越刻度：每穿一格唱一首（从左到右第一首未激活）
            for _ = 1, newslots - last do
                if not SingFirstInactive(player) then
                    break
                end
            end
        end
    end)

    inst:ListenForEvent("playeractivated", function(player)
        GLOBAL.WVM_ScoreSheetSync(player)
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:locomotor

AddComponentPostInit("locomotor", function(self)
    local function MarkNoLocomote(ba)
        if ba ~= nil and ba.action ~= nil and ba.action.id == "WVM_SPEAR_ALIGNED"
            and ba.target ~= nil and ba.target.components.inventoryitem ~= nil
            and ba.target.components.inventoryitem:IsHeld() then
            -- 原版对"目标已持有"的处理：distance=huge → 跳过寻路，原地起动作（有动画）
            ba.distance = math.huge
        end
    end
    local OldPush = self.PushAction
    self.PushAction = function(self, ba, run, try_instant)
        MarkNoLocomote(ba)
        return OldPush(self, ba, run, try_instant)
    end
    local OldPreview = self.PreviewAction
    self.PreviewAction = function(self, ba, run, try_instant)
        MarkNoLocomote(ba)
        return OldPreview(self, ba, run, try_instant)
    end
end)

```



### 变体演进：Papapav (Mod 3829211964)
- **变体场景与切面**：收录来自工坊 Mod 3829211964 (`Papapav`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3829211964)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:grassgekko
    end
    env.AddPrefabPostInit("grassgekko", Server(AttachGecko))
    env.AddPrefabPostInit("smallbird", Server(AttachSmallbird))
    for _, name in ipairs({ "forest", "savanna", "deciduous", "marsh", "grass", "rocky", "desert", "moon", "yot" }) do
        env.AddPrefabPostInit("kitcoon_" .. name, Server(AttachKitcoon))
    end
end

return M

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:smallbird
    env.AddPrefabPostInit("grassgekko", Server(AttachGecko))
    env.AddPrefabPostInit("smallbird", Server(AttachSmallbird))
    for _, name in ipairs({ "forest", "savanna", "deciduous", "marsh", "grass", "rocky", "desert", "moon", "yot" }) do
        env.AddPrefabPostInit("kitcoon_" .. name, Server(AttachKitcoon))
    end
end

return M

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:kitcoon_
    for _, name in ipairs({ "forest", "savanna", "deciduous", "marsh", "grass", "rocky", "desert", "moon", "yot" }) do
        env.AddPrefabPostInit("kitcoon_" .. name, Server(AttachKitcoon))
    end
end

return M

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
    local function Server(fn) return function(c) if G.TheWorld and G.TheWorld.ismastersim then fn(c) end end end
    env.AddComponentPostInit("combat", Server(AttachCombat))
    env.AddComponentPostInit("sanityaura", Server(function(self)
        local old = self.GetAura
        if old then self.GetAura = function(self, observer, ...)
            local result = Pack(old(self, observer, ...))
            if Defs.Finite(result[1]) and result[1] < 0 and Comp(self.inst, "combat") ~= nil then
                result[1] = result[1] * (1 - Clamp(Effect(observer, "enemy_sanity_resist"), 0, 1))
            end
            return unpack(result, 1, result.n)
        end end
    end))
    env.AddComponentPostInit("lootdropper", Server(function(self)
        local old = self.GenerateLoot
        if old then self.GenerateLoot = function(self, ...)
            local result = Pack(old(self, ...))
            local hp, combat = Comp(self.inst, "health"), Comp(self.inst, "combat")
            local killer = hp and hp.causeofdeath or nil
            if Comp(killer, "papapav_skilltree") == nil then killer = combat and combat.lastattacker end
            if hp and hp:IsDead() and not self.inst:HasTag("player") and not self.inst._papapav_inventory_hunter
                and not self._papapav_extra_rolled and type(result[1]) == "table" and #result[1] > 0 then
                self._papapav_extra_rolled = true
                if math.random() < Effect(killer, "extra_kill_loot") then
                    result[1][#result[1] + 1] = result[1][math.random(#result[1])]
                end
            end
            return unpack(result, 1, result.n)
        end end
    end))
end

return M

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:sanityaura
    env.AddComponentPostInit("combat", Server(AttachCombat))
    env.AddComponentPostInit("sanityaura", Server(function(self)
        local old = self.GetAura
        if old then self.GetAura = function(self, observer, ...)
            local result = Pack(old(self, observer, ...))
            if Defs.Finite(result[1]) and result[1] < 0 and Comp(self.inst, "combat") ~= nil then
                result[1] = result[1] * (1 - Clamp(Effect(observer, "enemy_sanity_resist"), 0, 1))
            end
            return unpack(result, 1, result.n)
        end end
    end))
    env.AddComponentPostInit("lootdropper", Server(function(self)
        local old = self.GenerateLoot
        if old then self.GenerateLoot = function(self, ...)
            local result = Pack(old(self, ...))
            local hp, combat = Comp(self.inst, "health"), Comp(self.inst, "combat")
            local killer = hp and hp.causeofdeath or nil
            if Comp(killer, "papapav_skilltree") == nil then killer = combat and combat.lastattacker end
            if hp and hp:IsDead() and not self.inst:HasTag("player") and not self.inst._papapav_inventory_hunter
                and not self._papapav_extra_rolled and type(result[1]) == "table" and #result[1] > 0 then
                self._papapav_extra_rolled = true
                if math.random() < Effect(killer, "extra_kill_loot") then
                    result[1][#result[1] + 1] = result[1][math.random(#result[1])]
                end
            end
            return unpack(result, 1, result.n)
        end end
    end))
end

return M

```



### 变体演进：momo蓝图 (Mod 3824396997)
- **变体场景与切面**：收录来自工坊 Mod 3824396997 (`momo蓝图`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3824396997)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:fishable
AddComponentPostInit("fishable", function(self) --钓鱼
	local oldHookFish=self.HookFish
	self.HookFish = function(self,fisherman)
		if math.random() < .1  then
			local px,py,pz= fisherman.Transform:GetWorldPosition()
			local lantu = SpawnPrefab("blueprint")
			lantu.Transform:SetPosition(px, 0, pz)
			SpawnPrefab("small_puff").Transform:SetPosition(px, 0, pz)
			TheNet:Announce(""..fisherman:GetDisplayName().."在钓鱼时获得"..lantu:GetDisplayName().."")
		end
		if oldHookFish then
			return oldHookFish(self,fisherman)
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:oceanfishingrod

AddComponentPostInit("oceanfishingrod", function(self)--海钓
	local oldCatchFish=self.CatchFish
	self.CatchFish = function(self)
		if self.target ~= nil and self.target.components.oceanfishable ~= nil then
			if math.random() < .1  then
				local px,py,pz= self.fisher.Transform:GetWorldPosition()
				local lantu = SpawnPrefab("blueprint")
				lantu.Transform:SetPosition(px, 0, pz)
				SpawnPrefab("small_puff").Transform:SetPosition(px, 0, pz)
				TheNet:Announce(""..self.fisher:GetDisplayName().."在钓"..self.target:GetDisplayName().."时获得"..lantu:GetDisplayName().."")
			end
		end
		if oldCatchFish then
			oldCatchFish(self)
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:stewer

AddComponentPostInit("stewer", function(self)--高级烹饪
	local oldHarvest=self.Harvest
	self.Harvest = function(self,harvester)
		if (self.inst.prefab == "cookpot" or self.inst.prefab == "archive_cookpot" or self.inst.prefab == "portablecookpot") and harvester ~= nil and self.chef_id == harvester.userid and self.product 
		and self.product ~= "wetgoop" and self.product ~= "monsterlasagna" and self.product ~= "monstertartare" then
			if math.random() < .03  then
				local px,py,pz= harvester.Transform:GetWorldPosition()
				local lantu = SpawnPrefab("blueprint")
				lantu.Transform:SetPosition(px, 0, pz)
				local liaoli = SpawnPrefab(self.product)
				SpawnPrefab("small_puff").Transform:SetPosition(px, 0, pz)
				TheNet:Announce(""..harvester:GetDisplayName().."在烹饪"..liaoli:GetDisplayName().."时获得"..lantu:GetDisplayName().."")
			end
		end
		return oldHarvest and oldHarvest(self,harvester) or nil
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:cooker

AddComponentPostInit("cooker", function(self)--普通烹饪
	local oldCookItem=self.CookItem
	self.CookItem = function(self,item, chef)
		if item ~= nil and chef and chef:HasTag("player") then
			if math.random() < .005  then
				local px,py,pz= chef.Transform:GetWorldPosition()
				local lantu = SpawnPrefab("blueprint")
				lantu.Transform:SetPosition(px, 0, pz)
				SpawnPrefab("small_puff").Transform:SetPosition(px, 0, pz)
				TheNet:Announce(""..chef:GetDisplayName().."在烹饪"..item:GetDisplayName().."时获得"..lantu:GetDisplayName().."")
			end
		end
		return oldCookItem and oldCookItem(self,item, chef) or nil
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:shaveable

AddComponentPostInit("shaveable", function(self)--刮毛10%掉落蓝图
	local oldShave=self.Shave
	self.Shave = function(self,shaver, shaving_implement)
		if shaver ~= nil and self.inst and shaving_implement and self.prize_prefab ~= nil and self.prize_count ~= nil then
			if self.canshavetest ~= nil then
				local pass, reason = self.canshavetest(self.inst, shaver)
				if not pass then
					return
				end
			end
			if math.random() < .1  then
				local px,py,pz= shaver.Transform:GetWorldPosition()
				local lantu = SpawnPrefab("blueprint")
				lantu.Transform:SetPosition(px, 0, pz)
				SpawnPrefab("small_puff").Transform:SetPosition(px, 0, pz)
				TheNet:Announce(""..shaver:GetDisplayName().."在刮"..self.inst:GetDisplayName().."时获得"..lantu:GetDisplayName().."")
			end
		end
		return oldShave and oldShave(self,shaver, shaving_implement) or nil
	end
end)

```



### 变体演进：Doro和咕嘎 (Mod 3820600244)
- **变体场景与切面**：收录来自工坊 Mod 3820600244 (`Doro和咕嘎`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820600244)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:burnable
-- The existing orange-tree area blocks naturally ignited fires.
AddComponentPostInit("burnable", function(self)
    local original = self.StartWildfire
    self.StartWildfire = function(burnable, ...)
        if rules.IsProtected(burnable.inst) then return end
        return original(burnable, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:pigman

AddPrefabPostInit("pigman", function(inst)
    if not _G.TheWorld.ismastersim or inst.components.talker == nil
        or inst._friendly_pigman_chatter_hooked then return end
    inst._friendly_pigman_chatter_hooked = true

    -- Every stock PigBrain/ChattyNode speech reaches Talker:Chatter. Replacing
    -- here preserves the original timing and behaviour without a second timer.
    local old_chatter = inst.components.talker.Chatter
    inst.components.talker.Chatter = function(talker, stringtable, strid, time,
            forcetext, echotochatpriority)
        if IsNormalPig(inst) and math.random() < chatter.CUSTOM_CHANCE then
            local line = ChooseLine(inst, GetCategory(inst, stringtable))
            if line ~= nil then
                return talker:Say(line, time, forcetext, forcetext)
            end
        end
        return old_chatter(talker, stringtable, strid, time, forcetext,
            echotochatpriority)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified

AddPrefabPostInit("player_classified", function(inst)
    inst.doro_orange_buff_duration = _G.net_float(inst.GUID, "doro_orange_buff_duration")
    inst.doro_orange_buff_serial = _G.net_byte(inst.GUID,
        "doro_orange_buff_serial", "doro_orange_buff_dirty")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:doro_teleport_sign

AddPrefabPostInit("doro_teleport_sign", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end

    signs[inst] = true
    inst:ListenForEvent("onremove", function()
        signs[inst] = nil
    end)
end)

```



### 变体演进：Ma Pháp Khai Nguyên (Mod 3814992771)
- **变体场景与切面**：收录来自工坊 Mod 3814992771 (`Ma Pháp Khai Nguyên`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814992771)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", WrapMap)   -- components/map.lua da nap xong (server lan may nguoi choi)
AddSimPostInit(WrapMap)               -- du phong

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:forest

AddPrefabPostInit("forest", function(world)
    local lit = false
    local ramp = nil
    local current = nil   -- mau dang day (nil = game tu lo)
    local function Push(c)
        current = c
        world:PushEvent("overrideambientlighting", c ~= nil and G.Point(c[1], c[2], c[3]) or nil)
    end
    -- chuyen dan tu `from` sang `to` trong MPKN_BLOODMOON_FADE giay; xong goi done()
    local function Ramp(from, to, done)
        if ramp ~= nil then
            ramp:Cancel()
            ramp = nil
        end
        local steps = math.max(1, math.floor(TUNING.MPKN_BLOODMOON_FADE / 0.1))
        local i = 0
        ramp = world:DoPeriodicTask(0.1, function()
            i = i + 1
            if i >= steps then
                ramp:Cancel()
                ramp = nil
                Push(to)
                if done ~= nil then
                    done()
                end
                return
            end
            local k = i / steps
            Push({ from[1] + (to[1] - from[1]) * k, from[2] + (to[2] - from[2]) * k, from[3] + (to[3] - from[3]) * k })
        end)
    end
    local function Update(force)
        local night = CurrentPhase() == "night"
        if night == lit and not force then
            return
        end
        lit = night
        if night then
            -- vao dem: tu mau chieu cua game (luc nay anh sang dang la mau chieu) do dan sang anh sang dem do
            Ramp(current or SeasonColour("MPKN_BLOODMOON_DUSK_AMBIENT"), TUNING.MPKN_BLOODMOON_NIGHT_AMBIENT)
        elseif current ~= nil then
            -- het dem: chuyen dan sang mau ban ngay roi tra lai cho game
            Ramp(current, SeasonColour("MPKN_BLOODMOON_DAY_AMBIENT"), function() Push(nil) end)
        end
    end
    relight = function() Update(true) end
    world:DoPeriodicTask(0.5, function() Update(false) end, 0)
end)

-- Tao trong PlayerHud:CreateOverlays (luc nhan vat vao game): ham nay xoa sach overlayroot roi tao lai
-- cac lop phu cua game => tao lop phu huyet nguyet SAU do (tao trong constructor se bi xoa mat).
local function SetupClient(self, owner)
    if owner == nil or self.overlayroot == nil then
        return
    end
    if self.mpkn_bloodmoon_task ~= nil then
        self.mpkn_bloodmoon_task:Cancel()
        self.mpkn_bloodmoon_task = nil
    end
    local Image = G.require("widgets/image")
    local img = self.overlayroot:AddChild(Image("images/global.xml", "square.tex"))
    img:SetVRegPoint(G.ANCHOR_MIDDLE)
    img:SetHRegPoint(G.ANCHOR_MIDDLE)
    img:SetVAnchor(G.ANCHOR_MIDDLE)
    img:SetHAnchor(G.ANCHOR_MIDDLE)
    img:SetScaleMode(G.SCALEMODE_FILLSCREEN)
    img:SetClickable(false)
    img:SetTint(1, 0, 0, 0)
    img:Hide()
    self.mpkn_bloodmoon_overlay = img

    local shown = nil
    self.mpkn_bloodmoon_refresh = function() shown = false end   -- console c_mpkn_bloodmoon_colour: ve lai
    if owner.components.playervision ~= nil then
        -- ban cu bat "nhin trong toi" o day; gio anh sang dem lam o phan "Anh sang dem huyet nguyet" phia tren
        owner.components.playervision:PopForcedNightVision(KEY)
    end
    local function Update()
        local phase = CurrentPhase()
        if phase == shown then
            return
        end
        shown = phase
        local fade = TUNING.MPKN_BLOODMOON_FADE
        if phase == "dusk" then
            Tint(img, TUNING.MPKN_BLOODMOON_DUSK_TINT, fade)
        elseif phase == "night" then
            Tint(img, TUNING.MPKN_BLOODMOON_NIGHT_TINT, fade)
        else
            local c = TUNING.MPKN_BLOODMOON_NIGHT_TINT
            Tint(img, { c[1], c[2], c[3], 0 }, fade)
        end
    end
    self.mpkn_bloodmoon_task = self.inst:DoPeriodicTask(0.5, Update, 0)
end

AddClassPostConstruct("screens/playerhud", function(self)
    local old = self.CreateOverlays
    self.CreateOverlays = function(hud, owner, ...)
        local r = old(hud, owner, ...)
        SetupClient(hud, owner)
        return r
    end
end)

local mpkn = G.rawget(G, "MPKN")
if mpkn ~= nil then
    mpkn.BloodMoon = {
        IsDay = MPKN_IsBloodMoonDay, Phase = CurrentPhase, OnPhase = OnPhase, Scan = Scan,
        ApplyBuff = ApplyBuff, RemoveBuff = RemoveBuff, IsOwned = IsOwned,
        GetActive = function() return active end,
    }
end

--------------------------------------------------------------------------
-- Dong ho: cham mat trang nho (UIClock._moonanim - Combined Status thu nho / dat canh dong ho) hien moi buoi chieu
-- + dem. Ngay huyet nguyet (chieu + dem cua ngay do) => doi hinh mat trang sang ban MAU DO, vien go nau giu nguyen.
--   * Hinh mat trang cua game (build "moon_phases", 8 pha) ve lien vien go nau trong cung 1 hinh => khong to mau rieng
--     ruot duoc bang code. Mod co build rieng "mpkn_moon_phases_blood" (anim/mpkn_moon_phases_blood.zip): chep y het
--     moon_phases, chi to do phan mat trang ben trong vien (cung ten symbol tung pha) => chi doi build khi gan symbol.
--   * Chi khi dong ho dang dung hinh mat trang thuong (moon_phases); kieu mat trang Thuy tinh (Celestial) giu nguyen.
--   * Chi phia may nguoi choi, tu tinh tu TheWorld.state. Hang dong khong co mat trang (_moonanim = nil) => bo qua.

local BLOOD_MOON_BUILD = "mpkn_moon_phases_blood"
table.insert(Assets, G.Asset("ANIM", "anim/" .. BLOOD_MOON_BUILD .. ".zip"))

-- = moon_syms trong UIClock:ShowMoon cua game
local function MoonSymbol(clock)
    local p, waxing = clock._moonphase, clock._mooniswaxing
    if p == "quarter" then
        return waxing and "moon_quarter_wax" or "moon_quarter"
    elseif p == "threequarter" then
        return waxing and "moon_three_quarter_wax" or "moon_three_quarter"
    elseif p == "half" then
        return waxing and "moon_half_wax" or "moon_half"
    elseif p == "new" then
        return "moon_new"
    end
    return "moon_full"
end

AddClassPostConstruct("widgets/uiclock", function(self)
    if self._moonanim == nil then
        return
    end
    local function IsBloodMoonNow()
        local ws = G.TheWorld ~= nil and G.TheWorld.state or nil
        -- doc ws.phase (KHONG dung ws.isdusk / ws.isnight): game bao "phase" TRUOC khi cap nhat isdusk / isnight
        local phase = ws ~= nil and ws.phase or nil
        return (phase == "dusk" or phase == "night") and MPKN_IsBloodMoonDay(ws.cycles)
    end
    local function Apply()
        local anim = self._moonanim ~= nil and self._moonanim:GetAnimState() or nil
        if anim == nil or self._moonphasebuild ~= "moon_phases" then
            return
        end
        local build = IsBloodMoonNow() and BLOOD_MOON_BUILD or self._moonphasebuild
        anim:OverrideSymbol("swap_moon", build, MoonSymbol(self))
    end
    -- game gan lai hinh mat trang moi khi doi pha trang / hien trang => gan lai ban do sau no
    local _ShowMoon = self.ShowMoon
    self.ShowMoon = function(clock, ...)
        local r = _ShowMoon(clock, ...)
        Apply()
        return r
    end
    self.inst:WatchWorldState("phase", Apply)
    self.inst:WatchWorldState("cycles", Apply)
    self.inst:DoTaskInTime(0, Apply)
    Apply()
end)

--------------------------------------------------------------------------
-- Console (thu mau khong can sua file): c_mpkn_bloodmoon_colour(r, g, b, dem, chieu)
--   r, g, b  = anh sang dem (0..1), vd 0.66, 0.32, 0.32
--   dem      = do dam lop phu man hinh ban dem (0..1), vd 0.08
--   chieu    = do dam lop phu man hinh buoi chieu (0..1), vd 0.08
--   Bo trong tham so nao thi giu gia tri cu. Chi doi tren may go lenh (host khong dedicated: ca server + man hinh),
--   mat khi thoat game => thay mau ung y thi ghi vao common/constants.lua.
G.global("c_mpkn_bloodmoon_colour")
G.c_mpkn_bloodmoon_colour = function(r, g, b, night_alpha, dusk_alpha)
    local a = TUNING.MPKN_BLOODMOON_NIGHT_AMBIENT
    TUNING.MPKN_BLOODMOON_NIGHT_AMBIENT = { r or a[1], g or a[2], b or a[3] }
    if night_alpha ~= nil then
        local c = TUNING.MPKN_BLOODMOON_NIGHT_TINT
        TUNING.MPKN_BLOODMOON_NIGHT_TINT = { c[1], c[2], c[3], night_alpha }
    end
    if dusk_alpha ~= nil then
        local c = TUNING.MPKN_BLOODMOON_DUSK_TINT
        TUNING.MPKN_BLOODMOON_DUSK_TINT = { c[1], c[2], c[3], dusk_alpha }
    end
    if relight ~= nil then
        relight()
    end
    local hud = G.ThePlayer ~= nil and G.ThePlayer.HUD or nil
    if hud ~= nil and hud.mpkn_bloodmoon_refresh ~= nil then
        hud.mpkn_bloodmoon_refresh()
    end
    local n, d = TUNING.MPKN_BLOODMOON_NIGHT_AMBIENT, TUNING.MPKN_BLOODMOON_NIGHT_TINT
    print(string.format("[MPKN] Huyet nguyet: anh sang dem {%.2f, %.2f, %.2f}, lop phu dem %.3f, chieu %.3f",
        n[1], n[2], n[3], d[4], TUNING.MPKN_BLOODMOON_DUSK_TINT[4]))
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:builder

AddComponentPostInit("builder", function(self)
    BlockWhileFlying(self, { "MakeRecipeFromMenu", "MakeRecipeAtPoint", "BufferBuild", "MakeRecipe" })
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory
-- Hinh cuoi choi cua game chi bat khi tay cam vat co tag "flyingbroom" (SGwilson ConfigureRunState) => dang bay coi nhu co
AddComponentPostInit("inventory", function(self, inst)
    local _EquipHasTag = self.EquipHasTag
    self.EquipHasTag = function(s, tag, ...)
        if tag == "flyingbroom" and Util.IsFlying(s.inst) then
            return true
        end
        return _EquipHasTag(s, tag, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:locomotor
-- Toc do co dinh (server + may nguoi choi du doan)
AddComponentPostInit("locomotor", function(self, inst)
    if not inst:HasTag("player") then
        return
    end
    local _RunSpeed = self.RunSpeed
    self.RunSpeed = function(s, ...)
        if Util.IsFlying(s.inst) then
            return G.TheWorld.state.israining and TUNING.MPKN_BROOM_RAIN_SPEED or TUNING.MPKN_BROOM_SPEED
        end
        return _RunSpeed(s, ...)
    end
    local _GetSpeedMultiplier = self.GetSpeedMultiplier
    self.GetSpeedMultiplier = function(s, ...)
        if Util.IsFlying(s.inst) then
            -- chi giu phan LAM CHAM tu ngoai (ru ngu, ngay ngat, ho sut, bao...): buff tang toc / mat dat (bun, mang nhen,
            -- duong...) / do mac khong tinh
            local ext = s.ExternalSpeedMultiplier ~= nil and s:ExternalSpeedMultiplier() or 1
            return math.min(1, ext)
        end
        return _GetSpeedMultiplier(s, ...)
    end
    if Util.IsFlying(inst) then
        Util.ApplyLocal(inst, true)   -- may nguoi choi: locomotor co sau (vao game dang bay)
    end
end)

-- Dang bay: khong chet duoi / roi vuc
AddComponentPostInit("drownable", function(self, inst)
    local _ShouldDrown = self.ShouldDrown
    self.ShouldDrown = function(s, ...)
        if Util.IsFlying(s.inst) then
            return false
        end
        return _ShouldDrown(s, ...)
    end
    local _ShouldFallInVoid = self.ShouldFallInVoid
    self.ShouldFallInVoid = function(s, ...)
        if Util.IsFlying(s.inst) then
            return false
        end
        return _ShouldFallInVoid(s, ...)
    end
end)

-- Dang bay: mat nhiet nhanh hon 25% (chi luc dang lanh di)
AddComponentPostInit("temperature", function(self, inst)
    if not inst:HasTag("player") then
        return
    end
    local _OnUpdate = self.OnUpdate
    self.OnUpdate = function(s, dt, ...)
        local before = s.current
        _OnUpdate(s, dt, ...)
        if Util.IsFlying(s.inst) and s.current < before then
            local x, _, z = s.inst.Transform:GetWorldPosition()
            local getat = G.rawget(G, "GetTemperatureAtXZ")
            local ambient = getat ~= nil and getat(x, z) or G.TheWorld.state.temperature
            local floor = math.max(s.mintemp or TUNING.MIN_ENTITY_TEMP, math.min(s.current, ambient))
            local target = before + (s.current - before) * TUNING.MPKN_BROOM_COLD_MULT
            if target < s.current then
                s:SetTemperature(math.max(target, floor))
            end
        end
    end
end)

-- Chuot trai vao mat nuoc (vung bay duoc) => di toi do (game: chi di toi o dat)
local function MakeMapProxy(inst, map)
    local proxy = {}
    proxy.IsPassableAtPoint = function(_, x, y, z, ...)
        if x ~= nil and z ~= nil and Util.IsFlying(inst) and Util.Allowed(x, z) then
            return true
        end
        return map:IsPassableAtPoint(x, y, z, ...)
    end
    return G.setmetatable(proxy, {
        __index = function(t, k)
            local v = map[k]
            if type(v) == "function" then
                local f = function(_, ...)
                    return v(map, ...)
                end
                G.rawset(t, k, f)
                return f
            end
            return v
        end,
    })
end

for _, name in ipairs({ "playeractionpicker", "playercontroller" }) do
    AddComponentPostInit(name, function(self, inst)
        if self.map ~= nil then
            self.map = MakeMapProxy(inst, self.map)
        end
        if name == "playercontroller" then
            BlockWhileFlying(self, { "StartBuildPlacementMode" })   -- khong hien bong cong trinh de dat
            -- F / Ctrl+F / nut danh tay cam: dang bay => khong danh, nhac xuong choi
            for _, fname in ipairs({ "DoAttackButton", "DoControllerAttackButton" }) do
                local fn = self[fname]
                if fn ~= nil then
                    self[fname] = function(s, ...)
                        if Util.IsFlying(s.inst) then
                            if s.inst == G.ThePlayer then
                                SayDismountFirst(s.inst)
                            end
                            return
                        end
                        return fn(s, ...)
                    end
                end
            end
        end
        if Util.IsFlying(inst) then
            Util.ApplyLocal(inst, true)   -- loc hanh dong (component co sau netvar)
        end
    end)
end

--------------------------------------------------------------------------
-- Hanh dong

-- Leo len (chuot phai vao choi, phai dang cam ngoc cua choi do)
AddAction("MPKN_BROOM_MOUNT", MPKN_TXT.ACTION.BROOM_MOUNT, function(act)
    local doer, broom = act.doer, act.target
    local rider = doer ~= nil and doer.components.mpkn_broomrider or nil
    local bc = broom ~= nil and broom:IsValid() and broom.components.mpkn_broom or nil
    if rider == nil or bc == nil then
        return false
    end
    return rider:Mount(bc.gem, broom)
end)
ACTIONS.MPKN_BROOM_MOUNT.distance = 2
ACTIONS.MPKN_BROOM_MOUNT.priority = 2

-- doer leo len choi nay duoc khong (ca 2 phia): dang cam ngoc cua choi, ngoc chua can, khong dang bay / cuoi beefalo
local function CanMountBroom(broom, doer)
    if doer:HasTag("mpkn_broomflying") or doer:HasTag("playerghost") then
        return false
    end
    if doer.replica.rider ~= nil and doer.replica.rider:IsRiding() then
        return false
    end
    local gem = broom._gem ~= nil and broom._gem:value() or nil
    -- ngoc can van hien "Leo lên": bam vao => nhan vat noi can nap nang luong (mpkn_broomrider:CanMount)
    return gem ~= nil and gem.replica.inventoryitem ~= nil and gem.replica.inventoryitem:IsGrandOwner(doer)
end

AddComponentAction("SCENE", "mpkn_broom", function(inst, doer, actions, right)
    if right and CanMountBroom(inst, doer) then
        table.insert(actions, ACTIONS.MPKN_BROOM_MOUNT)
    end
end)

-- Choi mong, kho tro trung => chuot phai XUONG DAT gan choi cua minh (TUNING.MPKN_BROOM_CLICK_RADIUS) cung la "Leo lên"
-- (ca server: server tinh lai hanh dong chuot phai tu vi tri may nguoi choi gui len)
local BROOM_MUST_TAGS = { "mpkn_broom" }
local BROOM_CANT_TAGS = { "INLIMBO" }
local function FindMountableBroom(doer, x, z)
    local best, bestd
    for _, broom in ipairs(G.TheSim:FindEntities(x, 0, z, TUNING.MPKN_BROOM_CLICK_RADIUS, BROOM_MUST_TAGS, BROOM_CANT_TAGS)) do
        if CanMountBroom(broom, doer) then
            local d = broom:GetDistanceSqToPoint(x, 0, z)
            if bestd == nil or d < bestd then
                best, bestd = broom, d
            end
        end
    end
    return best
end

AddComponentPostInit("playeractionpicker", function(self, inst)
    local _GetRightClickActions = self.GetRightClickActions
    self.GetRightClickActions = function(s, position, target, ...)
        local actions = _GetRightClickActions(s, position, target, ...)
        if position ~= nil and (actions == nil or #actions == 0) and (target == nil or target:HasTag("mpkn_broom")) then
            local broom = FindMountableBroom(s.inst, position.x, position.z)
            if broom ~= nil then
                return { G.BufferedAction(s.inst, broom, ACTIONS.MPKN_BROOM_MOUNT) }
            end
        end
        return actions
    end
end)

-- Xuong choi (dang bay, chuot phai vao chinh minh - nhu xuong beefalo)
AddAction("MPKN_BROOM_DISMOUNT", MPKN_TXT.ACTION.BROOM_DISMOUNT, function(act)
    local rider = act.doer ~= nil and act.doer.components.mpkn_broomrider or nil
    return rider ~= nil and rider:Dismount({ keepvisual = true, reason = "manual" }) or false
end)
ACTIONS.MPKN_BROOM_DISMOUNT.mount_valid = true
ACTIONS.MPKN_BROOM_DISMOUNT.priority = 2

AddComponentAction("SCENE", "mpkn_broomrider", function(inst, doer, actions, right)
    if right and inst == doer and inst:HasTag("mpkn_broomflying") then
        table.insert(actions, ACTIONS.MPKN_BROOM_DISMOUNT)
    end
end)

-- Nap ngoc bang Ma thach
local function ConsumeOne(item)
    local one = item.components.inventoryitem ~= nil and item.components.inventoryitem:RemoveFromOwner(false) or item
    one:Remove()
end

AddAction("MPKN_GEM_RECHARGE", MPKN_TXT.ACTION.GEM_RECHARGE, function(act)
    local stone, gem = act.invobject, act.target
    if stone == nil or gem == nil or not stone:IsValid() or not gem:IsValid() or not gem:HasTag("mpkn_broom_gem") then
        return false
    end
    local fueled = gem.components.fueled
    if fueled == nil or fueled:GetPercent() >= .999 then
        return false
    end
    ConsumeOne(stone)
    fueled:SetPercent(1)
    if act.doer ~= nil and act.doer.SoundEmitter ~= nil then
        act.doer.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
    end
    return true
end)
ACTIONS.MPKN_GEM_RECHARGE.mount_valid = true
ACTIONS.MPKN_GEM_RECHARGE.priority = 2

AddComponentAction("USEITEM", "mpkn_gemcharger", function(inst, doer, target, actions, right)
    if target:HasTag("mpkn_broom_gem") and not target:HasTag("mpkn_gem_full") then
        table.insert(actions, ACTIONS.MPKN_GEM_RECHARGE)
    end
end)

AddPrefabPostInit("mpkn_mana_stone", function(inst)
    if not G.TheWorld.ismastersim then
        return
    end
    inst:AddComponent("mpkn_gemcharger")
end)

AddStategraphActionHandler("wilson", G.ActionHandler(ACTIONS.MPKN_BROOM_MOUNT, MOUNT_STATE))
AddStategraphActionHandler("wilson", G.ActionHandler(ACTIONS.MPKN_BROOM_DISMOUNT, DISMOUNT_STATE))
AddStategraphActionHandler("wilson", G.ActionHandler(ACTIONS.MPKN_GEM_RECHARGE, "doshortaction"))
AddStategraphActionHandler("wilson_client", G.ActionHandler(ACTIONS.MPKN_BROOM_MOUNT, "doshortaction"))
AddStategraphActionHandler("wilson_client", G.ActionHandler(ACTIONS.MPKN_BROOM_DISMOUNT, "doshortaction"))
AddStategraphActionHandler("wilson_client", G.ActionHandler(ACTIONS.MPKN_GEM_RECHARGE, "doshortaction"))

--------------------------------------------------------------------------
-- Stategraph: lo lung / leo len / xuong

local function HoverState(server)
    return G.State{
        name = HOVER,
        tags = { "idle", "canrotate", "mpkn_broomhover" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            if not inst.AnimState:IsCurrentAnimation("run_witchbroom_loop") then
                inst.AnimState:PlayAnimation("run_witchbroom_loop", true)
            end
            if server and Util.IsFlying(inst) then
                inst:AddTag("notraptrigger")   -- state bay cua game go tag nay khi dung lai
            end
        end,

        onupdate = function(inst)
            if not Util.IsFlying(inst) then
                inst.sg:GoToState("idle")
            end
        end,
    }
end

-- Bay di chuyen: luon giu dang ngoi choi (khong doi sang chay ron ren / bao cat / ngay ngat... cua game)
local function FlyState()
    return G.State{
        name = FLY_STATE,
        tags = { "moving", "running", "canrotate", "flyingonbroom", "autopredict" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:RunForward()
            end
            if not inst.AnimState:IsCurrentAnimation("run_witchbroom_loop") then
                inst.AnimState:PlayAnimation("run_witchbroom_loop", true)
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        onupdate = function(inst)
            if not Util.IsFlying(inst) then
                inst.sg:GoToState("run")
                return
            end
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:RunForward()
            end
        end,

        ontimeout = function(inst)
            inst.sg:GoToState(FLY_STATE)
        end,
    }
end

AddStategraphState("wilson", FlyState())
AddStategraphState("wilson_client", FlyState())
AddStategraphState("wilson", HoverState(true))
AddStategraphState("wilson_client", HoverState(false))

AddStategraphState("wilson", G.State{
    name = MOUNT_STATE,
    tags = { "doing", "busy", "nomorph" },

    onenter = function(inst)
        inst.components.locomotor:StopMoving()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction()
        end
        local act = inst:GetBufferedAction()
        local broom = act ~= nil and act.target or nil
        if broom ~= nil and broom:IsValid() then
            inst:ForceFacePoint(broom.Transform:GetWorldPosition())
        end
        if not inst:PerformBufferedAction() then
            inst.sg:GoToState("idle")
            return
        end
        inst.AnimState:PlayAnimation("run_witchbroom_pre")
        PlayMountSound(inst)
    end,

    events =
    {
        G.EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")   -- dang bay => lo lung
            end
        end),
    },
})

AddStategraphState("wilson", G.State{
    name = DISMOUNT_STATE,
    tags = { "doing", "busy", "nomorph", "dismounting" },

    onenter = function(inst)
        inst.components.locomotor:StopMoving()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction()
        end
        if not inst:PerformBufferedAction() then
            inst.sg:GoToState("idle")
            return
        end
        inst.AnimState:PlayAnimation("run_witchbroom_pst")   -- choi van duoi nguoi toi het anim (FinishDismount o onexit)
    end,

    events =
    {
        G.EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        local rider = inst.components.mpkn_broomrider
        if rider ~= nil then
            rider:FinishDismount()
        end
    end,
})

-- Dang bay: dung yen => lo lung (khong buoc xuong choi), di chuyen => FLY_STATE
local function PatchSG(sg)
    local idle = sg.states.idle
    if idle ~= nil then
        local _onenter = idle.onenter
        idle.onenter = function(inst, ...)
            if Util.IsFlying(inst) then
                inst.sg:GoToState(HOVER)
                return
            end
            if _onenter ~= nil then
                return _onenter(inst, ...)
            end
        end
    end
    local stop = sg.states.run_stop
    if stop ~= nil then
        local _onenter = stop.onenter
        stop.onenter = function(inst, ...)
            if Util.IsFlying(inst) then
                inst.sg:GoToState(HOVER)
                return
            end
            if _onenter ~= nil then
                return _onenter(inst, ...)
            end
        end
    end
    -- moi state chay cua game => bay (bo qua chay ron ren / bao cat / ngay ngat / anim leo len cua choi cam tay)
    for _, name in ipairs({ "run_start", "run", "run_flyingbroom_start", "run_flyingbroom" }) do
        local st = sg.states[name]
        if st ~= nil then
            local _onenter = st.onenter
            st.onenter = function(inst, ...)
                if Util.IsFlying(inst) then
                    inst.sg:GoToState(FLY_STATE)
                    return
                end
                if _onenter ~= nil then
                    return _onenter(inst, ...)
                end
            end
        end
    end
end

AddStategraphPostInit("wilson", PatchSG)
AddStategraphPostInit("wilson_client", PatchSG)

--------------------------------------------------------------------------
-- Set: danh vao nguoi dang bay gan nhat (nhu cot thu loi)

AddPrefabPostInit("forest", function(inst)
    if not inst.ismastersim then
        return
    end
    local _PushEvent = inst.PushEvent
    inst.PushEvent = function(self, event, data, ...)
        if event == "ms_sendlightningstrike" and type(data) == "table" and data.x ~= nil and data.z ~= nil then
            local r = TUNING.MPKN_BROOM_LIGHTNING_RANGE
            local best, bestd
            for _, p in ipairs(G.AllPlayers) do
                if p:IsValid() and p:HasTag("mpkn_broomflying") then
                    local d = p:GetDistanceSqToPoint(data.x, 0, data.z)
                    if d <= r * r and (bestd == nil or d < bestd) then
                        best, bestd = p, d
                    end
                end
            end
            if best ~= nil then
                local x, _, z = best.Transform:GetWorldPosition()
                data = G.Vector3(x, 0, z)
            end
        end
        return _PushEvent(self, event, data, ...)
    end
end)

```



### 变体演进：影月重铸 | Shadow & Moon: Reforged (Mod 3817517238)
- **变体场景与切面**：收录来自工坊 Mod 3817517238 (`影月重铸 | Shadow & Moon: Reforged`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3817517238)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:voidcloth_boomerang_proj
end
AddPrefabPostInit("voidcloth_boomerang_proj", hooks.BoomerangProjectile)
AddPrefabPostInit("houndstooth_proj", hooks.ToothProjectile)
AddPrefabPostInit("houndstooth_proj",ammo.Projectile)
AddPrefabPostInit("stafflight",newgear.Star)
AddPrefabPostInit("queen_torchlight",newgear.QueenLightPrefab)
AddPrefabPostInit("beefalo", saddle_storage.Beefalo)
AddComponentAction("POINT", "farmtiller", function(inst, doer, pt, actions, right)
    if right and tilling.CanAreaTill(inst, pt) then
        for _, action in ipairs(actions) do if action == G.ACTIONS.TILL then return end end
        actions[#actions+1] = G.ACTIONS.TILL
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:houndstooth_proj
AddPrefabPostInit("voidcloth_boomerang_proj", hooks.BoomerangProjectile)
AddPrefabPostInit("houndstooth_proj", hooks.ToothProjectile)
AddPrefabPostInit("houndstooth_proj",ammo.Projectile)
AddPrefabPostInit("stafflight",newgear.Star)
AddPrefabPostInit("queen_torchlight",newgear.QueenLightPrefab)
AddPrefabPostInit("beefalo", saddle_storage.Beefalo)
AddComponentAction("POINT", "farmtiller", function(inst, doer, pt, actions, right)
    if right and tilling.CanAreaTill(inst, pt) then
        for _, action in ipairs(actions) do if action == G.ACTIONS.TILL then return end end
        actions[#actions+1] = G.ACTIONS.TILL
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:stafflight
AddPrefabPostInit("houndstooth_proj",ammo.Projectile)
AddPrefabPostInit("stafflight",newgear.Star)
AddPrefabPostInit("queen_torchlight",newgear.QueenLightPrefab)
AddPrefabPostInit("beefalo", saddle_storage.Beefalo)
AddComponentAction("POINT", "farmtiller", function(inst, doer, pt, actions, right)
    if right and tilling.CanAreaTill(inst, pt) then
        for _, action in ipairs(actions) do if action == G.ACTIONS.TILL then return end end
        actions[#actions+1] = G.ACTIONS.TILL
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:queen_torchlight
AddPrefabPostInit("stafflight",newgear.Star)
AddPrefabPostInit("queen_torchlight",newgear.QueenLightPrefab)
AddPrefabPostInit("beefalo", saddle_storage.Beefalo)
AddComponentAction("POINT", "farmtiller", function(inst, doer, pt, actions, right)
    if right and tilling.CanAreaTill(inst, pt) then
        for _, action in ipairs(actions) do if action == G.ACTIONS.TILL then return end end
        actions[#actions+1] = G.ACTIONS.TILL
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beefalo
AddPrefabPostInit("queen_torchlight",newgear.QueenLightPrefab)
AddPrefabPostInit("beefalo", saddle_storage.Beefalo)
AddComponentAction("POINT", "farmtiller", function(inst, doer, pt, actions, right)
    if right and tilling.CanAreaTill(inst, pt) then
        for _, action in ipairs(actions) do if action == G.ACTIONS.TILL then return end end
        actions[#actions+1] = G.ACTIONS.TILL
    end
end)

```



### 变体演进：熔炉武器汉化版 (Mod 3353028449)
- **变体场景与切面**：收录来自工坊 Mod 3353028449 (`熔炉武器汉化版`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3353028449)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:blacksmith_edge

AddPrefabPostInit("blacksmith_edge",function(inst)
    local function get_edge_max_level()
        local day = TheWorld.components.worldstate.data.cycles
        local max_level = 10
        if day > 500 then
            max_level = max_level + math.floor((day - 500) / 100)
        end
        return math.min(max_level, 20)
    end

    local function Set_Name(inst)
        if inst.mater and inst.components.named then
            local name = ' Lv.'..inst.mater..' '..STRINGS.NAMES[string.upper(inst.prefab)]
            inst.components.named:SetName(name)
        end
    end

    local function onlevelup(inst, giver)
        if inst.components.weapon then
            inst.components.weapon:SetDamage(TUNING.THE_FORGE_ITEM_PACK.BLACKSMITH_EDGE.DAMAGE + inst.mater * 10)
        end
        if giver and giver.components.talker then
            giver.components.talker:Say("等级:"..inst.mater.."/"..get_edge_max_level().."!")
        end
        inst.entity:AddSoundEmitter()
        inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
    end

    local function OnGetItemFromPlayer(inst, giver, item, player)
        if not inst.components.weapon then return end

        if item then
            if item.prefab == "moonstorm_static_item" then
                -- 检查是否超过最大等级
                local max_level = get_edge_max_level()
                if inst.mater < max_level then
                    inst.mater = inst.mater + 1
                    onlevelup(inst, giver)
                    Set_Name(inst)
                else
                    if giver and giver.components.talker then
                        if inst.mater < 20 then
                            local day = TheWorld.components.worldstate.data.cycles
                            local next_day = (inst.mater - 9) * 100 + 500
                            local to_day = next_day - day
                            giver.components.talker:Say("已达当前天数最大等级"..max_level.."!\n距离下一级解锁还有"..to_day.."天")
                        else
                            giver.components.talker:Say("已达到最大等级"..max_level.."!")
                        end
                    end
                    -- 返还物品
                    local giveback = SpawnPrefab("moonstorm_static_item")
                    if giver and giver.components.inventory then
                        giver.components.inventory:GiveItem(giveback, nil, giver:GetPosition())
                    end
                end
            elseif item.prefab == "greengem" then
                if inst.mater > 0 then
                    inst.mater = inst.mater - 1
                    local giveback = SpawnPrefab("moonstorm_static_item")
                    if giver and giver.components.inventory then
                        giver.components.inventory:GiveItem(giveback, nil, giver:GetPosition())
                        giver.components.talker:Say("降级后的等级为"..inst.mater..", 返还一个静电")
                    end
                    inst.components.weapon:SetDamage(TUNING.THE_FORGE_ITEM_PACK.BLACKSMITH_EDGE.DAMAGE + inst.mater * 10)
                    Set_Name(inst)
                elseif inst.mater == 0 then
                    local giveback = SpawnPrefab("moonstorm_static_item")
                    if giver and giver.components.inventory then
                        giver.components.inventory:GiveItem(giveback, nil, giver:GetPosition())
                        giver.components.talker:Say("当前大刀等级为0, 回收刀并返还一个静电")
                    end
                    inst:Remove()
                end
            end
        end
    end

    local function onpreload(inst, data)
        if data then
            if data.mater then
                inst.mater = data.mater
                -- 直接设置伤害，不调用OnGetItemFromPlayer
                if inst.components.weapon then
                    inst.components.weapon:SetDamage(TUNING.THE_FORGE_ITEM_PACK.BLACKSMITH_EDGE.DAMAGE + inst.mater * 10)
                end
            end
        end
    end

    local function onsave(inst, data)
        data.mater = inst.mater
    end

    local function OnRefuseItem(inst, giver, item)
        if item and giver and giver.components.talker then
            giver.components.talker:Say("等级:"..inst.mater.."/"..get_edge_max_level().."!\n给予静电升级\n给予绿宝石降级并返还静电\n500天后每100天增加1上限,最高20级")
        end
    end

    local function AcceptTest(inst, item)
        if inst.mater then
            if item.prefab == "moonstorm_static_item" or item.prefab == "greengem" then
                return true
            end
        end
        return false
    end

    -- 初始化等级
    inst.mater = inst.mater or 0

    if not TheWorld.ismastersim then
        return inst
    end

    -- 添加必要的组件
    if not inst.components.named then
        inst:AddComponent("named")
    end

    -- 设置初始名称和伤害
    Set_Name(inst)
    if inst.components.weapon then
        inst.components.weapon:SetDamage(TUNING.THE_FORGE_ITEM_PACK.BLACKSMITH_EDGE.DAMAGE)
    end

    -- 添加交易者组件
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    -- 保存和加载
    inst.OnSave = onsave
    inst.OnPreLoad = onpreload
end)

if GetModConfigData("NORMAL_GAME_BOOSTED", false) then
    local u = {"fishingrod", "bugnet", "lucy", "shovel", "goldenshovel", "pitchfork", "hammer", "torch", "umbrella",
               "cane", "lighter", "axe", "pickaxe", "goldenaxe", "goldenpickaxe", "boomerang", "hambat",
               "multitool_axe_pickaxe", "spear", "batbat", "spear_wathgrithr", "nightstick", "slurtleslime",
               "ruins_bat", "trap_teeth", "nightsword", "blowdart_pipe", "blowdart_fire", "gunpowder", "bell",
               "tentaclespike", "brush", "blowdart_yellow", "glasscutter", "moonglassaxe", "oceanfishingrod", "trident"}
    local v = {"firestaff", "icestaff", "staff_tornado", "pocketwatch_weapon", "pocketwatch_weapon_new"}
    for i, j in ipairs(u) do
        AddPrefabPostInit(j, function(b)
            if b.components.weapon then
                b.components.weapon:SetDamageType(1)
            end
        end)
    end
    for i, j in ipairs(v) do
        AddPrefabPostInit(j, function(b)
            if b.components.weapon then
                b.components.weapon:SetDamageType(2)
            end
        end)
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:inventoryitem_classified
local k = _G.TheNet;
AddPrefabPostInit("inventoryitem_classified", function(l)
    l.isaltattacking = h(l.GUID, "weapon.isaltattacking")
    l.altattackrange = i(l.GUID, "weapon.altattackrange")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified
end)
AddPrefabPostInit("player_classified", function(l)
    l.net_buffs = j(l.GUID, "forge.net_buffs", "net_buffs_dirty")
    if not k:IsDedicated() then
        l:ListenForEvent("net_buffs_dirty", function(l)
            if not l._parent or not l._parent.HUD or #l.net_buffs:value() < 1 then
                return
            end
            l.net_buffs:set_local("")
            l.net_buffs:set("")
        end)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
end
AddComponentPostInit("combat", function(self)
    self.damage_override = nil;
    self.damagetype = nil;
    self.damagebuffs = {
        dealt = {
            dmgtype = {},
            stimuli = {},
            generic = {}
        },
        recieved = {
            dmgtype = {},
            stimuli = {},
            generic = {}
        }
    }
    function self:SetDamageType(q)
        self.damagetype = q
    end
    function self:HasDamageBuff(r, s, t)
        local u = self.damagebuffs[r and "recieved" or "dealt"][type(t) == "number" and "dmgtype" or
                      (type(t) == "string" and "stimuli" or "generic")]
        if not t then
            if u[s] then
                return true
            end
        else
            if u[t] and u[t][s] then
                return true
            end
        end
    end
    function self:AddDamageBuff(r, s, v)
        if not self:HasDamageBuff(r, s) then
            self.damagebuffs[r and "recieved" or "dealt"].generic[s] = v
        end
    end
    function self:AddDamageTypeBuff(r, w, s, v)
        if not self:HasDamageBuff(r, s, w) then
            local u = self.damagebuffs[r and "recieved" or "dealt"].dmgtype;
            if not u[w] then
                u[w] = {}
            end
            u[w][s] = v
        end
    end
    function self:AddDamageStimuliBuff(r, x, s, v)
        if not self:HasDamageBuff(r, s, x) then
            local u = self.damagebuffs[r and "recieved" or "dealt"].stimuli;
            if not u[x] then
                u[x] = {}
            end
            u[x][s] = v
        end
    end
    function self:RemoveDamageBuff(r, s, t)
        if self:HasDamageBuff(r, s, t) then
            local u = self.damagebuffs[r and "recieved" or "dealt"][type(t) == "number" and "dmgtype" or
                          (type(t) == "string" and "stimuli" or "generic")]
            if not t then
                u[s] = nil
            else
                u[t][s] = nil;
                if _G.GetTableSize(u[t]) < 1 then
                    u[t] = nil
                end
            end
        end
    end
    function self:CopyBuffsTo(y)
        if y and y.components.combat then
            y.components.combat.damagebuffs = self.damagebuffs
        end
    end
    function self:HasDamageBuff(r, s, t)
        local u = self.damagebuffs[r and "recieved" or "dealt"][type(t) == "number" and "dmgtype" or
                      (type(t) == "string" and "stimuli" or "generic")]
        if not t then
            return u[s] ~= nil
        else
            return u[t] ~= nil and u[t][s] ~= nil
        end
    end
    _oldGetAttackRange = self.GetAttackRange;
    function self:GetAttackRange()
        local z = self:GetWeapon()
        if z and z.components.weapon:CanAltAttack() then
            return z.components.weapon.altattackrange
        else
            return _oldGetAttackRange(self)
        end
    end
    _oldGetHitRange = self.GetHitRange;
    function self:GetHitRange()
        local z = self:GetWeapon()
        if z and z.components.weapon:CanAltAttack() then
            return self.attackrange + z.components.weapon.althitrange
        else
            return _oldGetHitRange(self)
        end
    end
    _oldCalcDamage = self.CalcDamage;
    function self:CalcDamage(A, z, B)
        if A:HasTag("alwaysblock") then
            return 0
        end
        local C = _oldCalcDamage(self, A, z, B)
        local D = z ~= nil and z.components.weapon.damage or self.defaultdamage;
        if z ~= nil and z.components.planardamage == nil or (z == nil and self.inst.components.planardamage == nil) then -- 修改的地方对有位面伤害的做出区别
            if z and z.components.weapon:CanAltAttack() or not z and self.damage_override then
                local E = 0;
                if z then
                    E =
                        z.components.weapon.altdamagecalc ~= nil and z.components.weapon.altdamagecalc(z, self.inst, A) or
                            (z.components.weapon.altdamage or D)
                else
                    E = type(self.damage_override) == "function" and self.damage_override(self.inst, A) or
                            self.damage_override
                end
                C = (C - (self.damagebonus or 0)) / D;
                C = C * E + (self.damagebonus or 0)
            end
            return C
        else
            return _oldCalcDamage(self, A, z, B) -- 修改
        end
    end
    local function F(r, G, H, z, x)
        local I = 1;
        local J = 1;
        local K = {
            common = {
                additive = {},
                multiplicative = {}
            },
            overrides = {
                additive = {},
                multiplicative = {}
            }
        }
        for t, p in pairs(self.damagebuffs[r and "recieved" or "dealt"]) do
            for o, v in pairs(p) do
                local z = z or self:GetWeapon()
                local L = z ~= nil and z.components.weapon or self;
                if t == "generic" or t == "stimuli" and x == o or t == "dmgtype" and L.damagetype and L.damagetype ==
                    _G.DAMAGETYPES[_G.DAMAGETYPE_IDS[o]] then
                    if t == "generic" then
                        if type(v) == "function" then
                            local M, N, O = v(G, H, z, x)
                            K[O and "overrides" or "common"][N and "multiplicative" or "additive"][o] = M
                        else
                            K.common.additive[o] = v
                        end
                    else
                        for P, Q in pairs(v) do
                            if type(Q) == "function" then
                                local M, N, O = Q(G, H, z, x)
                                K[O and "overrides" or "common"][N and "multiplicative" or "additive"][P] = M
                            else
                                K.common.additive[P] = Q
                            end
                        end
                    end
                end
            end
        end
        local R = false;
        if _G.GetTableSize(K.overrides.additive) > 0 or _G.GetTableSize(K.overrides.multiplicative) > 0 then
            R = true
        end
        for S, v in pairs(K[R and "overrides" or "common"].multiplicative) do
            if v then
                J = J * v
            end
        end
        for S, v in pairs(K[R and "overrides" or "common"].additive) do
            if v then
                I = I * (v + 1)
            end
        end
        if I == 0 then
            I = 1
        end
        if J == 0 then
            J = 1
        end
        return I, J
    end
    function self:GetBuffMults(r, G, H, z, x)
        return F(r, G, H, z, x)
    end
    _oldDoAttack = self.DoAttack;
    function self:DoAttack(T, z, U, x, V, ...) -- 修改 官方有两个多的参数但是好像那两个参数没作用Combat:DoAttack(targ, weapon, projectile, stimuli, instancemult, instrangeoverride, instpos)
        local I, J = F(false, self.inst, T or self.target, z, x)
        local W = (V or 1) * J * I;
        _oldDoAttack(self, T, z, U, x, W, ...) -- 修改 Combat:DoAttack(targ, weapon, projectile, stimuli, instancemult, instrangeoverride, instpos)DoAttack(T, self.inst, U, x, V)
    end
    _oldGetAttacked = self.GetAttacked;
    function self:GetAttacked(G, X, z, x, ...) -- 修改Combat:GetAttacked(attacker, damage, weapon, stimuli, spdamage)spdamage为位面伤害没这个参数对象不会收到位面伤害
        local I, J = F(true, G, self.inst, z, x)
        X = X * J * I;
        return _oldGetAttacked(self, G, X, z, x, ...) -- 修改
    end
    function self:DoAreaAttack(A, Y, z, Z, x, _)
        local a0 = 0;
        local a1, a2, a3 = A.Transform:GetWorldPosition()
        local a4 = _G.TheSim:FindEntities(a1, a2, a3, Y, {"_combat"}, _)
        for P, y in ipairs(a4) do
            if y ~= A and y ~= self.inst and self:IsValidTarget(y) and (Z == nil or Z(y, self.inst)) then
                self.inst:PushEvent("onareaattackother", {
                    target = y,
                    weapon = z,
                    stimuli = x
                })
                local J = (self.areahitdamagepercent or 1) + F(false, self.inst, y, z, x)
                y.components.combat:GetAttacked(self.inst, self:CalcDamage(y, z, J), z, x)
                a0 = a0 + 1
            end
        end
        return a0
    end
    function self:DoSpecialAttack(C, T, x, V, a5)
        self.damage_override = C;
        if a5 then
            self:DoAreaAttack(a5.target, a5.range, nil, a5.validfn, x, a5.excludetags)
        else
            self:DoAttack(T, nil, nil, x, V)
        end
        self.damage_override = nil
    end
end)
AddComponentPostInit("weapon", function(self)
    self.hasaltattack = false;
    self.isaltattacking = false;
    self.altattackrange = nil;
    self.althitrange = nil;
    self.altdamage = nil;
    self.altdamagecalc = nil;
    self.altcondition = nil;
    self.altprojectile = nil;
    self._projectile = nil;
    self.damagetype = nil;
    self.altdamagetype = nil;
    self._damagetype = nil;
    function self:SetDamageType(q)
        self.damagetype = q;
        self._damagetype = q
    end
    function self:SetStimuli(x)
        self.stimuli = x
    end
    function self:SetProjectile(U)
        self.projectile = U;
        self._projectile = U
    end
    function self:SetAltAttack(X, Y, a6, q, a7, a8)
        self.hasaltattack = true;
        self.altdamage = X ~= nil and X or self.damage;
        if Y ~= nil then
            self.altattackrange = type(Y) == "table" and Y[1] or Y or self.attackrange;
            self.althitrange = type(Y) == "table" and Y[2] or self.altattackrange
        else
            self.altattackrange = 20;
            self.althitrange = 20
        end
        self.altprojectile = a6;
        self.altdamagetype = q ~= nil and q or self.damagetype;
        self.altdamagecalc = a7;
        self.altcondition = a8;
        if self.altdamagecalc then
            local a9 = self.altdamagecalc;
            self.altdamagecalc = function(z, G, A)
                local C = a9(z, G, A)
                return C ~= nil and C or self.altdamage
            end
        end
        if self.inst.replica.inventoryitem then
            self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)
        end
    end
    function self:SetIsAltAttacking(aa)
        self.isaltattacking = aa;
        if self.inst.replica.inventoryitem then
            self.inst.replica.inventoryitem:SetIsAltAttacking(aa)
        end
        if aa then
            self.projectile = self.altprojectile;
            self.damagetype = self.altdamagetype
        else
            self.projectile = self._projectile;
            self.damagetype = self._damagetype
        end
    end
    function self:HasAltAttack()
        return self.hasaltattack
    end
    function self:CanAltAttack()
        if self:HasAltAttack() and self.isaltattacking then
            return self.altcondition ~= nil and self.altcondition(self.inst) or true
        end
    end
    _oldCanRangedAttack = self.CanRangedAttack;
    function self:CanRangedAttack()
        return self:CanAltAttack() and self.altprojectile or _oldCanRangedAttack(self)
    end
    function self:DoAltAttack(G, T, U, x, V)
        self:SetIsAltAttacking(true)
        if G and G.components.combat and self:CanAltAttack() then
            if T and type(T) == "table" and not T.prefab then
                for S, y in ipairs(T) do
                    if y ~= G and y.entity:IsValid() and y.components.workable ~= nil and self.inst.IsWorkableAllowed ~=
                        nil and type(self.inst.IsWorkableAllowed) == "function" and
                        self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(), y) then
                        local ab = self.inst.prefab:upper()
                        if _G.TUNING.THE_FORGE_ITEM_PACK[ab] ~= nil and _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG ~=
                            nil then
                            y.components.workable:WorkedBy(G, _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG)
                        end
                    end
                    if y ~= G and G.components.combat:IsValidTarget(y) and y.components.health and
                        not y.components.health:IsDead() then
                        G.components.combat:DoAttack(y, self.inst, U, x, V)
                    end
                end
            else
                if G.components.combat:IsValidTarget(T) then
                    G.components.combat:DoAttack(T, self.inst, U, x, V)
                end
            end
        end
        G:PushEvent("alt_attack_complete", {
            weapon = self.inst
        })
        self:SetIsAltAttacking(false)
    end
end)
AddComponentPostInit("aoeweapon_lunge", function(self)    --修改为附加而不是覆盖  矛相关
    self.width = 3;
    self.damage = nil;
    self.stimuli = nil;
    self.onlunge = nil
    function self:SetWidth(c)
        self.width = c
    end
    function self:SetStimuli(d)
        self.stimuli = d
    end
    function self:SetOnLungeFn(e)
        self.onlunge = e
    end
    _oldDoLunge = self.DoLunge
    function self:DoLunge(f, g, h)
        if self.inst.prefab == "pithpike" then          --对尖刺矛走mod别的走原版
            local i = {}
            local j = {}
        for k = 0, 10 do
            f:DoTaskInTime(FRAMES * math.ceil(1 + k / 3.5), function()
                local l = (h - g):GetNormalized() * k * 0.6;
                SpawnPrefab("spear_gungnir_lungefx").Transform:SetPosition((g + l):Get())
                local m, n, o = (g + l):Get()
                local p = TheSim:FindEntities(m, n, o, self.width / 2, nil, {"player", "companion"})
                for q, r in ipairs(p) do
                    if not i[r] and r ~= f and f.components.combat:IsValidTarget(r) and
                        (r.components.health or r.entity:IsValid() and r.components.workable and
                            r.components.workable:CanBeWorked() and r.components.workable:GetWorkAction()) then
                        i[r] = true;
                        table.insert(j, r)
                    end
                end
                if k == 10 then
                    if self.inst.components.weapon and self.inst.components.weapon:HasAltAttack() then
                        self.inst.components.weapon:DoAltAttack(f, j, nil, self.stimuli)
                    end
                end
            end)
        end
        if self.onlunge ~= nil then
            self.onlunge(self.inst, f, g, h)
        end
        return true 
        else
            return _oldDoLunge(self,f, g, h)
        end
    end
end)
AddComponentPostInit("health", function(self)
    self.buffs = {}
    function self:GetHealthBuff()
        local ac = 0;
        for s, v in pairs(self.buffs) do
            ac = ac + v
        end
        return ac
    end
    function self:HasHealthBuff(s)
        return self.buffs[s]
    end
    function self:AddHealthBuff(s, v)
        if not self:HasHealthBuff(s) then
            self.buffs[s] = v;
            self.maxhealth = self.maxhealth + self:GetHealthBuff()
            self.currenthealth = self.currenthealth + self:GetHealthBuff()
        end
    end
    function self:RemoveHealthBuff(s)
        if self:HasHealthBuff(s) then
            self.currenthealth = math.max(self.minhealth, self.currenthealth - self.buffs[s])
            self.maxhealth = math.max(self.minhealth, self.maxhealth - self.buffs[s])
            self.buffs[s] = nil
        end
    end
end)
AddComponentPostInit("equippable", function(self)
    self.uniquebuffs = {}
    self.damagebuffs = {
        dealt = {
            dmgtype = {},
            stimuli = {},
            generic = {}
        },
        recieved = {
            dmgtype = {},
            stimuli = {},
            generic = {}
        }
    }
    self.healthbuffs = {}
    function self:HasHealthBuff(s)
        return self.healthbuffs[s] ~= nil
    end
    function self:AddHealthBuff(s, v)
        if not self:HasHealthBuff(s) then
            local ad = self.inst.components.inventoryitem.owner;
            if ad.components.health then
                ad.components.health:AddHealthBuff(s, v)
            end
        end
    end
    function self:RemoveHealthBuff(s)
        if self:HasHealthBuff(s) then
            self.healthbuffs[s] = nil;
            local ad = self.inst.components.inventoryitem.owner;
            if ad.components.health then
                ad.components.health:RemoveHealthBuff(s)
            end
        end
    end
    function self:HasDamageBuff(r, s, t)
        local u = self.damagebuffs[r and "recieved" or "dealt"][type(t) == "number" and "dmgtype" or
                      (type(t) == "string" and "stimuli" or "generic")]
        if not t then
            if u[s] then
                return true
            end
        else
            if u[t] and u[t][s] then
                return true
            end
        end
    end
    function self:AddDamageBuff(r, s, v)
        if not self:HasDamageBuff(r, s) then
            self.damagebuffs[r and "recieved" or "dealt"].generic[s] = v;
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:AddDamageBuff(r, s, v)
                end
            end
        end
    end
    function self:AddDamageTypeBuff(r, w, s, v)
        if not self:HasDamageBuff(r, s, w) then
            local u = self.damagebuffs[r and "recieved" or "dealt"].dmgtype;
            if not u[w] then
                u[w] = {}
            end
            u[w][s] = v;
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:AddDamageTypeBuff(r, w, s, v)
                end
            end
        end
    end
    function self:AddDamageStimuliBuff(r, x, s, v)
        if not self:HasDamageBuff(r, s, x) then
            local u = self.damagebuffs[r and "recieved" or "dealt"].stimuli;
            if not u[x] then
                u[x] = {}
            end
            u[x][s] = v;
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:AddDamageStimuliBuff(r, x, s, v)
                end
            end
        end
    end
    function self:RemoveDamageBuff(r, s, t)
        if self:HasDamageBuff(r, s, t) then
            local u = self.damagebuffs[r and "recieved" or "dealt"][type(t) == "number" and "dmgtype" or
                          (type(t) == "string" and "stimuli" or "generic")]
            if not t then
                u[s] = nil
            else
                u[t][s] = nil;
                if _G.GetTableSize(u[t]) < 1 then
                    u[t] = nil
                end
            end
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:RemoveDamageBuff(r, s, t)
                end
            end
        end
    end
    function self:AddBuffsTo(ad)
        if ad and ad.components.buffable then
            ad.components.buffable:AddBuff(self.inst.prefab, self.uniquebuffs)
        end
    end
    function self:RemoveBuffsFrom(ad)
        if ad and ad.components.buffable then
            ad.components.buffable:RemoveBuff(self.inst.prefab)
        end
    end
    function self:AddUniqueBuff(ae)
        for t, v in pairs(ae) do
            self.uniquebuffs[t] = v
        end
        if self:IsEquipped() then
            local ad = self.inst.components.inventoryitem.owner;
            self:AddBuffsTo(ad)
        end
    end
    function self:RemoveUniqueBuff(t)
        self.uniquebuffs[t] = nil;
        if self:IsEquipped() then
            local ad = self.inst.components.inventoryitem.owner;
            self:AddBuffsTo(ad)
        end
    end
    local af = self.Equip;
    function self:Equip(ad)
        if ad.components.combat then
            for P, ae in pairs(self.damagebuffs) do
                for o, K in pairs(ae) do
                    for t, v in pairs(K) do
                        if o == "generic" then
                            ad.components.combat:AddDamageBuff(P == "recieved", t, v)
                        else
                            for ag, ah in pairs(v) do
                                if o == "dmgtype" then
                                    ad.components.combat:AddDamageTypeBuff(P == "recieved", t, ag, ah)
                                else
                                    ad.components.combat:AddDamageStimuliBuff(P == "recieved", t, ag, ah)
                                end
                            end
                        end
                    end
                end
            end
        end
        self:AddBuffsTo(ad)
        af(self, ad)
    end
    local ai = self.Unequip;
    function self:Unequip(ad)
        if ad.components.combat then
            for P, ae in pairs(self.damagebuffs) do
                for o, K in pairs(ae) do
                    for t, v in pairs(K) do
                        if o == "generic" then
                            ad.components.combat:RemoveDamageBuff(P == "recieved", t)
                        else
                            for s, S in pairs(v) do
                                ad.components.combat:RemoveDamageBuff(P == "recieved", s, t)
                            end
                        end
                    end
                end
            end
        end
        self:RemoveBuffsFrom(ad)
        ai(self, ad)
    end
end)
AddComponentPostInit("rechargeable", function(self)
    self.owner = nil;
    self.onequip = function(l, ae)
        if self.owner ~= nil and self.owner.components.buffable ~= nil then -- 修改对buffable组件判定 假人相关
            self:SetChargeTimeMod(self.inst, l.prefab, self.owner.components.buffable:GetBuffData("cooldown_mult"))
        end
    end;
    self.onunequip = function(l, ae)
        self:RemoveChargeTimeMod(self.inst, l.prefab)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:weapon
end)
AddComponentPostInit("weapon", function(self)
    self.hasaltattack = false;
    self.isaltattacking = false;
    self.altattackrange = nil;
    self.althitrange = nil;
    self.altdamage = nil;
    self.altdamagecalc = nil;
    self.altcondition = nil;
    self.altprojectile = nil;
    self._projectile = nil;
    self.damagetype = nil;
    self.altdamagetype = nil;
    self._damagetype = nil;
    function self:SetDamageType(q)
        self.damagetype = q;
        self._damagetype = q
    end
    function self:SetStimuli(x)
        self.stimuli = x
    end
    function self:SetProjectile(U)
        self.projectile = U;
        self._projectile = U
    end
    function self:SetAltAttack(X, Y, a6, q, a7, a8)
        self.hasaltattack = true;
        self.altdamage = X ~= nil and X or self.damage;
        if Y ~= nil then
            self.altattackrange = type(Y) == "table" and Y[1] or Y or self.attackrange;
            self.althitrange = type(Y) == "table" and Y[2] or self.altattackrange
        else
            self.altattackrange = 20;
            self.althitrange = 20
        end
        self.altprojectile = a6;
        self.altdamagetype = q ~= nil and q or self.damagetype;
        self.altdamagecalc = a7;
        self.altcondition = a8;
        if self.altdamagecalc then
            local a9 = self.altdamagecalc;
            self.altdamagecalc = function(z, G, A)
                local C = a9(z, G, A)
                return C ~= nil and C or self.altdamage
            end
        end
        if self.inst.replica.inventoryitem then
            self.inst.replica.inventoryitem:SetAltAttackRange(self.altattackrange)
        end
    end
    function self:SetIsAltAttacking(aa)
        self.isaltattacking = aa;
        if self.inst.replica.inventoryitem then
            self.inst.replica.inventoryitem:SetIsAltAttacking(aa)
        end
        if aa then
            self.projectile = self.altprojectile;
            self.damagetype = self.altdamagetype
        else
            self.projectile = self._projectile;
            self.damagetype = self._damagetype
        end
    end
    function self:HasAltAttack()
        return self.hasaltattack
    end
    function self:CanAltAttack()
        if self:HasAltAttack() and self.isaltattacking then
            return self.altcondition ~= nil and self.altcondition(self.inst) or true
        end
    end
    _oldCanRangedAttack = self.CanRangedAttack;
    function self:CanRangedAttack()
        return self:CanAltAttack() and self.altprojectile or _oldCanRangedAttack(self)
    end
    function self:DoAltAttack(G, T, U, x, V)
        self:SetIsAltAttacking(true)
        if G and G.components.combat and self:CanAltAttack() then
            if T and type(T) == "table" and not T.prefab then
                for S, y in ipairs(T) do
                    if y ~= G and y.entity:IsValid() and y.components.workable ~= nil and self.inst.IsWorkableAllowed ~=
                        nil and type(self.inst.IsWorkableAllowed) == "function" and
                        self.inst:IsWorkableAllowed(y.components.workable:GetWorkAction(), y) then
                        local ab = self.inst.prefab:upper()
                        if _G.TUNING.THE_FORGE_ITEM_PACK[ab] ~= nil and _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG ~=
                            nil then
                            y.components.workable:WorkedBy(G, _G.TUNING.THE_FORGE_ITEM_PACK[ab].WORKABLE_DMG)
                        end
                    end
                    if y ~= G and G.components.combat:IsValidTarget(y) and y.components.health and
                        not y.components.health:IsDead() then
                        G.components.combat:DoAttack(y, self.inst, U, x, V)
                    end
                end
            else
                if G.components.combat:IsValidTarget(T) then
                    G.components.combat:DoAttack(T, self.inst, U, x, V)
                end
            end
        end
        G:PushEvent("alt_attack_complete", {
            weapon = self.inst
        })
        self:SetIsAltAttacking(false)
    end
end)
AddComponentPostInit("aoeweapon_lunge", function(self)    --修改为附加而不是覆盖  矛相关
    self.width = 3;
    self.damage = nil;
    self.stimuli = nil;
    self.onlunge = nil
    function self:SetWidth(c)
        self.width = c
    end
    function self:SetStimuli(d)
        self.stimuli = d
    end
    function self:SetOnLungeFn(e)
        self.onlunge = e
    end
    _oldDoLunge = self.DoLunge
    function self:DoLunge(f, g, h)
        if self.inst.prefab == "pithpike" then          --对尖刺矛走mod别的走原版
            local i = {}
            local j = {}
        for k = 0, 10 do
            f:DoTaskInTime(FRAMES * math.ceil(1 + k / 3.5), function()
                local l = (h - g):GetNormalized() * k * 0.6;
                SpawnPrefab("spear_gungnir_lungefx").Transform:SetPosition((g + l):Get())
                local m, n, o = (g + l):Get()
                local p = TheSim:FindEntities(m, n, o, self.width / 2, nil, {"player", "companion"})
                for q, r in ipairs(p) do
                    if not i[r] and r ~= f and f.components.combat:IsValidTarget(r) and
                        (r.components.health or r.entity:IsValid() and r.components.workable and
                            r.components.workable:CanBeWorked() and r.components.workable:GetWorkAction()) then
                        i[r] = true;
                        table.insert(j, r)
                    end
                end
                if k == 10 then
                    if self.inst.components.weapon and self.inst.components.weapon:HasAltAttack() then
                        self.inst.components.weapon:DoAltAttack(f, j, nil, self.stimuli)
                    end
                end
            end)
        end
        if self.onlunge ~= nil then
            self.onlunge(self.inst, f, g, h)
        end
        return true 
        else
            return _oldDoLunge(self,f, g, h)
        end
    end
end)
AddComponentPostInit("health", function(self)
    self.buffs = {}
    function self:GetHealthBuff()
        local ac = 0;
        for s, v in pairs(self.buffs) do
            ac = ac + v
        end
        return ac
    end
    function self:HasHealthBuff(s)
        return self.buffs[s]
    end
    function self:AddHealthBuff(s, v)
        if not self:HasHealthBuff(s) then
            self.buffs[s] = v;
            self.maxhealth = self.maxhealth + self:GetHealthBuff()
            self.currenthealth = self.currenthealth + self:GetHealthBuff()
        end
    end
    function self:RemoveHealthBuff(s)
        if self:HasHealthBuff(s) then
            self.currenthealth = math.max(self.minhealth, self.currenthealth - self.buffs[s])
            self.maxhealth = math.max(self.minhealth, self.maxhealth - self.buffs[s])
            self.buffs[s] = nil
        end
    end
end)
AddComponentPostInit("equippable", function(self)
    self.uniquebuffs = {}
    self.damagebuffs = {
        dealt = {
            dmgtype = {},
            stimuli = {},
            generic = {}
        },
        recieved = {
            dmgtype = {},
            stimuli = {},
            generic = {}
        }
    }
    self.healthbuffs = {}
    function self:HasHealthBuff(s)
        return self.healthbuffs[s] ~= nil
    end
    function self:AddHealthBuff(s, v)
        if not self:HasHealthBuff(s) then
            local ad = self.inst.components.inventoryitem.owner;
            if ad.components.health then
                ad.components.health:AddHealthBuff(s, v)
            end
        end
    end
    function self:RemoveHealthBuff(s)
        if self:HasHealthBuff(s) then
            self.healthbuffs[s] = nil;
            local ad = self.inst.components.inventoryitem.owner;
            if ad.components.health then
                ad.components.health:RemoveHealthBuff(s)
            end
        end
    end
    function self:HasDamageBuff(r, s, t)
        local u = self.damagebuffs[r and "recieved" or "dealt"][type(t) == "number" and "dmgtype" or
                      (type(t) == "string" and "stimuli" or "generic")]
        if not t then
            if u[s] then
                return true
            end
        else
            if u[t] and u[t][s] then
                return true
            end
        end
    end
    function self:AddDamageBuff(r, s, v)
        if not self:HasDamageBuff(r, s) then
            self.damagebuffs[r and "recieved" or "dealt"].generic[s] = v;
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:AddDamageBuff(r, s, v)
                end
            end
        end
    end
    function self:AddDamageTypeBuff(r, w, s, v)
        if not self:HasDamageBuff(r, s, w) then
            local u = self.damagebuffs[r and "recieved" or "dealt"].dmgtype;
            if not u[w] then
                u[w] = {}
            end
            u[w][s] = v;
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:AddDamageTypeBuff(r, w, s, v)
                end
            end
        end
    end
    function self:AddDamageStimuliBuff(r, x, s, v)
        if not self:HasDamageBuff(r, s, x) then
            local u = self.damagebuffs[r and "recieved" or "dealt"].stimuli;
            if not u[x] then
                u[x] = {}
            end
            u[x][s] = v;
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:AddDamageStimuliBuff(r, x, s, v)
                end
            end
        end
    end
    function self:RemoveDamageBuff(r, s, t)
        if self:HasDamageBuff(r, s, t) then
            local u = self.damagebuffs[r and "recieved" or "dealt"][type(t) == "number" and "dmgtype" or
                          (type(t) == "string" and "stimuli" or "generic")]
            if not t then
                u[s] = nil
            else
                u[t][s] = nil;
                if _G.GetTableSize(u[t]) < 1 then
                    u[t] = nil
                end
            end
            if self:IsEquipped() then
                local ad = self.inst.components.inventoryitem.owner;
                if ad.components.combat then
                    ad.components.combat:RemoveDamageBuff(r, s, t)
                end
            end
        end
    end
    function self:AddBuffsTo(ad)
        if ad and ad.components.buffable then
            ad.components.buffable:AddBuff(self.inst.prefab, self.uniquebuffs)
        end
    end
    function self:RemoveBuffsFrom(ad)
        if ad and ad.components.buffable then
            ad.components.buffable:RemoveBuff(self.inst.prefab)
        end
    end
    function self:AddUniqueBuff(ae)
        for t, v in pairs(ae) do
            self.uniquebuffs[t] = v
        end
        if self:IsEquipped() then
            local ad = self.inst.components.inventoryitem.owner;
            self:AddBuffsTo(ad)
        end
    end
    function self:RemoveUniqueBuff(t)
        self.uniquebuffs[t] = nil;
        if self:IsEquipped() then
            local ad = self.inst.components.inventoryitem.owner;
            self:AddBuffsTo(ad)
        end
    end
    local af = self.Equip;
    function self:Equip(ad)
        if ad.components.combat then
            for P, ae in pairs(self.damagebuffs) do
                for o, K in pairs(ae) do
                    for t, v in pairs(K) do
                        if o == "generic" then
                            ad.components.combat:AddDamageBuff(P == "recieved", t, v)
                        else
                            for ag, ah in pairs(v) do
                                if o == "dmgtype" then
                                    ad.components.combat:AddDamageTypeBuff(P == "recieved", t, ag, ah)
                                else
                                    ad.components.combat:AddDamageStimuliBuff(P == "recieved", t, ag, ah)
                                end
                            end
                        end
                    end
                end
            end
        end
        self:AddBuffsTo(ad)
        af(self, ad)
    end
    local ai = self.Unequip;
    function self:Unequip(ad)
        if ad.components.combat then
            for P, ae in pairs(self.damagebuffs) do
                for o, K in pairs(ae) do
                    for t, v in pairs(K) do
                        if o == "generic" then
                            ad.components.combat:RemoveDamageBuff(P == "recieved", t)
                        else
                            for s, S in pairs(v) do
                                ad.components.combat:RemoveDamageBuff(P == "recieved", s, t)
                            end
                        end
                    end
                end
            end
        end
        self:RemoveBuffsFrom(ad)
        ai(self, ad)
    end
end)
AddComponentPostInit("rechargeable", function(self)
    self.owner = nil;
    self.onequip = function(l, ae)
        if self.owner ~= nil and self.owner.components.buffable ~= nil then -- 修改对buffable组件判定 假人相关
            self:SetChargeTimeMod(self.inst, l.prefab, self.owner.components.buffable:GetBuffData("cooldown_mult"))
        end
    end;
    self.onunequip = function(l, ae)
        self:RemoveChargeTimeMod(self.inst, l.prefab)
    end;
    self.inst:ListenForEvent("equipped", function(l, ae)
        self.owner = ae.owner;
        self.pickup = false;
        if self.owner ~= nil and self.owner.components.buffable ~= nil then -- 修改对buffable组件判定 假人相关
            self:SetChargeTimeMod(self.inst, l.prefab, self.owner.components.buffable:GetBuffData("cooldown_mult"))
        end
        if not self.updating then
            self.updating = true;
            self.inst:StartUpdatingComponent(self)
        end
        self.inst:ListenForEvent("equip", self.onequip, l)
        self.inst:ListenForEvent("unequip", self.onunequip, l)
    end)
    self.inst:ListenForEvent("unequipped", function(l, ae)
        self.inst:RemoveEventCallback("equip", self.onequip, l)
        self.inst:RemoveEventCallback("unequip", self.onunequip, l)
        if self.pickup and self.updating then
            self.updating = false;
            self.inst:StopUpdatingComponent(self)
        end
        self:RemoveChargeTimeMod(self.inst, l.prefab)
        self.owner = nil
    end)
end)
AddComponentPostInit("aoespell", function(self)
    self.spell_type = nil;
    function self:SetSpellType(aj)
        self.spell_type = aj
    end
    local ak = self.CastSpell;
    function self:CastSpell(al, am)
        if self.inst.components.reticule_spawner ~= nil then
            self.inst.components.reticule_spawner:Spawn(am)
        end
        local an, ao = ak(self, al, am)
        self.inst:PushEvent("aoe_casted", {
            caster = al,
            pos = am
        })
        return an, ao
    end
    function self:OnSpellCast(ap, aq, ar)
        ap:PushEvent("spell_complete", {
            weapon = self.inst,
            spell_type = self.spell_type,
            targets = aq,
            projectiles = ar
        })
    end
end)
AddClassPostConstruct("components/inventoryitem_replica", function(self)
    self.can_altattack_fn = function()
        return true
    end;
    function self:SetIsAltAttacking(aa)
        if self.classified ~= nil then
            self.classified.isaltattacking:set(aa)
        end
    end
    function self:SetAltAttackRange(Y)
        if self.classified ~= nil then
            self.classified.altattackrange:set(Y or self:AttackRange())
        end
    end
    function self:AltAttackRange()
        if self.inst.components.weapon then
            return self.inst.components.weapon.altattackrange
        elseif self.classified ~= nil then
            return math.max(0, self.classified.altattackrange:value())
        else
            return self:AttackRange()
        end
    end
    function self:SetAltAttackCheck(as)
        if as and type(as) == "function" then
            self.can_altattack_fn = as
        end
    end
    function self:CanAltAttack()
        if self.classified ~= nil and self.classified.isaltattacking:value() then
            return self.inst.components.weapon and self.components.weapon:CanAltAttack() or
                       self.can_altattack_fn(self.inst)
        end
    end
    _oldAttackRange = self.AttackRange;
    function self:AttackRange()
        return self:CanAltAttack() and self:AltAttackRange() or _oldAttackRange(self)
    end
end)
AddClassPostConstruct("components/combat_replica", function(self)
    local at = self.CanBeAttacked;
    function self:CanBeAttacked(G)
        if TUNING.PREVENT_COMPAGNION_ATTACK and (self.inst:HasTag("companion") and G and G:HasTag("player")) then
            return false
        end
        return at(self, G)
    end
end)
local function au(l, av)
    local aw = {
        livingstaff = "heal_staff",
        infernalstaff = "fireball"
    }
    if aw[av.prefab] then
        l.sg.statemem.projectilesound = "dontstarve/common/lava_arena/" .. aw[av.prefab]
    end
end
AddStategraphPostInit("wilson", function(self)
    local ax = self.states.attack.onenter;
    self.states.attack.onenter = function(l)
        local av = l.components.inventory:GetEquippedItem(c.HANDS)
        if av then
            au(l, av)
        end
        ax(l)
    end;
    local ay = self.actionhandlers[g.CASTAOE].deststate;
    self.actionhandlers[g.CASTAOE].deststate = function(l, az)
        if az.invobject:HasTag("parry1") then --和盾的反进行区别
            return "parry_pre"
        end
        return ay(l, az)
    end
end)
AddStategraphPostInit("wilson_client", function(self)
    local ax = self.states.attack.onenter;
    self.states.attack.onenter = function(l)
        local av = l.replica.inventory:GetEquippedItem(c.HANDS)
        if av then
            au(l, av)
        end
        ax(l)
    end;
    local ay = self.actionhandlers[g.CASTAOE].deststate;
    self.actionhandlers[g.CASTAOE].deststate = function(l, az)
        if az.invobject:HasTag("parry1") then --和盾的反进行区别
            return "parry_pre"
        end
        return ay(l, az)
    end
end)
AddComponentPostInit("debuffable", function(self)
    local aA = self.AddDebuff;
    local aB = self.RemoveDebuff;
    function self:AddDebuff(m, ...)
        if self.debuffs[m] == nil and self.inst.player_classified then
            self.inst.player_classified.net_buffs:set(a.encode({
                name = m,
                removed = false
            }))
        end
        aA(self, m, ...)
    end
    function self:RemoveDebuff(m, ...)
        if self.debuffs[m] ~= nil and self.inst.player_classified then
            self.inst.player_classified.net_buffs:set(a.encode({
                name = m,
                removed = true
            }))
        end
        aB(self, m, ...)
    end
end)
local aC = {
    book = 25 * b,
    castspell = 53 * b
}
local ab = function(...)
end;
for aD, aE in pairs(aC) do
    AddStategraphPostInit("wilson", function(self)
        local aF, aG, aH = self.states[aD].onenter or ab, self.states[aD].onexit or ab, self.states[aD].onupdate or ab;
        self.states[aD].onenter = function(l)
            l.sg.statemem.tm = 0;
            l.sg.statemem.trgt = aE;
            l.sg.statemem.equip = l.components.inventory:GetEquippedItem(c.HANDS)
            aF(l)
        end;
        self.states[aD].onexit = function(l)
            if not l.sg.statemem.equip then
                return
            end
            if l.sg.statemem.tm < l.sg.statemem.trgt and l.sg.statemem.equip.components.reticule_spawner then
                l.sg.statemem.equip.components.reticule_spawner:Interrupt()
            end
            aG(l)
        end;
        self.states[aD].onupdate = function(l, aI)
            l.sg.statemem.tm = l.sg.statemem.tm + aI;
            aH(l)
        end
    end)
end
local aJ = {"spider", "spider_warrior", "tentacle", "hound", "firehound", "icehound", "krampus", "knight", "bishop",
            "rook", "knight_nightmare", "bishop_nightmare", "rook_nightmare", "spider_hider", "spider_spitter",
            "spider_dropper", "bat", "worm", "spat", "eyeplant", "walrus", "little_walrus", "monkey", "slurper",
            "tallbird", "frog", "mosquito", "bee", "killerbee", "pigguard", "moonpig", "merm", "leif", "leif_sparse",
            "spiderqueen", "deerclops", "minotaur", "warg", "birchnutdrake", "deciduoustree", "bearger", "moose",
            "dragonfly", "lavae", "beeguard", "cookiecutter", "mutatedhound", "houndcorpse", "mutated_penguin",
            "spider_moon", "beequeen", "klaus", "stalker", "stalker_forest", "stalker_atrium", "malbatross", "pigman",
            "koalefant_summer", "koalefant_winter", "slurtle", "snurtle", "beefalo", "penguin", "bunnyman", "rocky",
            "lightninggoat", "catcoon", "buzzard", "mossling", "antlion", "gestalt", "gnarwail", "gnarwail_attack_horn",
            "fruitdragon", "squid", "player"}
for S, aK in ipairs(aJ) do
    AddPrefabPostInit(aK, function(l)
        if l.components and l.components.combat then
            l.components.combat:SetDamageType(1)
        end
    end)
end

```



### 变体演进：九格装备栏Plus (Mod 3823818148)
- **变体场景与切面**：收录来自工坊 Mod 3823818148 (`九格装备栏Plus`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823818148)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：孤岛抽奖机 (Mod 3025140277)
- **变体场景与切面**：收录来自工坊 Mod 3025140277 (`孤岛抽奖机`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3025140277)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    if TheWorld.ismastersim then --判断主机
        inst:AddComponent("daywalkerspawner") -- 添加噩梦猪人boss刷新组件

        inst:ListenForEvent("ms_playerspawn", function(inst, player)    --玩家出生时 "ms_newplayerspawned"不包括变猴
            local CurrentOnNewSpawn = player.OnNewSpawn or function() return true end -- 记录角色本身开局物品
            player.OnNewSpawn = function(...)
                player.components.inventory.ignoresound = true

                for i,v in pairs({"footballhat","spear","lucky_goldnugget","lucky_goldnugget","lucky_goldnugget",
                                "lucky_goldnugget","lucky_goldnugget","trinket_1","trinket_1","trinket_1","boat_item","oar"}) do  --猪皮帽 长矛 元宝*5 弹珠*3 船 浆
                    local item = SpawnPrefab(v)
                    SetSpellCB(item, player)
                    player.components.inventory:GiveItem(item)
                end
                return CurrentOnNewSpawn(...)
            end

            -----------------玩家弹珠偿还
            inst:DoTaskInTime(3*FRAMES,function ()
				if player.components.ability and player.components.ability.danzhubagnum>0 then  --数据储存在组件里面
                    local check = false
                    if player.components.inventory then
                        local bag = player.components.inventory:GetEquippedItem(EQUIPSLOTS.NLDANZHUBAG)
                        if bag and bag.components.container then
                            local item = SpawnPrefab("trinket_1")
                            if item.components.stackable then
                                item.components.stackable.stacksize = player.components.ability.danzhubagnum    --计数
                            end
                            bag.components.container:GiveItem(item)--,nil,nil,false
                            check = true--给了就标记
                        else    --一般情况下实现不了，只是保险
                            local item = SpawnPrefab("trinket_1")
                            if item.components.stackable then
                                item.components.stackable.stacksize = player.components.ability.danzhubagnum --没钱包就直接给全部
                            end
                            player.components.inventory:GiveItem(item)
                            check = true
                        end
                    end

                    if check then
                        player.components.ability.danzhubagnum = 0
                    end
                end
            end)
        end)

        inst:DoTaskInTime(5,function()
            if not TheWorld.ismastersim then
                return inst
            end
            local a,b = nil,nil --对于部分岛，让其连接虫洞
            a = c_findnext("wormhole",nil,inst) --（官方的c_findnext很方便，会自动排除已经查找到的实体）
            b = c_findnext("wormhole",nil,inst)
            if a ~= nil and b ~= nil and a ~= b then
                a.components.teleporter:Target(b)
                b.components.teleporter:Target(a)
                TheNet:Announce("成功连接虫洞")
            else
                TheNet:Announce("未能连接虫洞")
            end

            RIFTPORTAL_FNS.CreateRiftPortalDefinition("lunarrift_portal", { --选择裂隙生成点，需要返回两个点x，z。因为改了地图生成方法，需要手动重设
                GetNextRiftSpawnLocation = function(_map, rift_def)
                    local t = {}
                    local ep = nil
                    for i = 1, 5 do
                        ep = c_findnext("nl_lunarportal_point",nil,inst) --我的想法是直接额外设置一个岛，在岛上安排标记点，然后随机选择这些标记点为裂隙点(因为感觉不喜欢随机选岛生成的方法，就这样吧)
                        if ep ~= nil then
                            local x,y,z = ep.Transform:GetWorldPosition()
                            table.insert(t,{xp = x,zp = z})
                        end
                    end
                    if #t>0 then
                        local point = t[math.random(#t)]
                        return point.xp,point.zp
                    end
                end,
                CustomAllowTest = function(_map, x, y, z)
                    return true
                end,
                Affinity = RIFTPORTAL_CONST.AFFINITY.LUNAR,
            })

            RIFTPORTAL_FNS.CreateRiftPortalDefinition("shadowrift_portal", {
                GetNextRiftSpawnLocation = function(_map, rift_def)
                    local t = {}
                    local ep = nil
                    for i = 1, 5 do
                        ep = c_findnext("nl_shadowportal_point",nil,inst)
                        if ep ~= nil then
                            local x,y,z = ep.Transform:GetWorldPosition()
                            table.insert(t,{xp = x,zp = z})
                        end
                    end
                    if #t>0 then
                        local point = t[math.random(#t)]
                        return point.xp,point.zp
                    end
                end,
                CustomAllowTest = function(_map, x, y, z)
                    return true
                end,
                Affinity = RIFTPORTAL_CONST.AFFINITY.SHADOW,
            })
        end)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:nightlight
------------------------------------------------------
AddPrefabPostInit("nightlight", function(inst) --对于影灯只是简单的修改了一点，具体实现细节请看官方组件components.trader，可以实现很多多样化的操作
    if TheWorld.ismastersim then --判断是不是主机
        if inst.components.trader == nil then
            inst:AddComponent("trader")
        end
        
        if inst.components.trader then
            inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest_bl)
            inst.components.trader:SetAcceptTest(can_accept_item_bl)
            inst.components.trader.onaccept = bl_OnGetItemFromPlayer
        end

        if GetModConfigData("if_break_nl") then --让影灯无法被破坏
            if inst.components.workable then inst:RemoveComponent("workable") end --不能被敲
            AddRecipe2("nightlight", { Ingredient("goldnugget", 8), Ingredient("nightmarefuel", 2), Ingredient("redgem", 1) },TECH.LOST, { placer = "nightlight_placer" }) --移除影灯配方
        end

        inst:AddTag("not_move_nl") --不会被清理
        inst:AddTag("shop_no_destroy") --不让影灯可以被拆解法杖分解

        -- inst:AddComponent("timer")
        -- inst:ListenForEvent("timerdone", clear_nightlight_keep)
        -- clear_nightlight_begin(inst)

        -- 监听世界时间：进入黄昏时触发清理记录
        inst:WatchWorldState("phase", function(inst, phase)
            if phase == "dusk" then
                inst:DoTaskInTime(2, nl_doclean)
            end
        end)

        -- inst:DoPeriodicTask(5,nl_doclean)  --测试用时间

        local oldsave = inst.OnSave
        inst.OnSave = function(inst, data)--当保存的时候
            if oldsave ~= nil then oldsave(inst,data) end
            data.nl_check_count = inst.nl_check_count
        end
        
        local oldOnPreLoad = inst.OnPreLoad
        inst.OnPreLoad = function(inst,data)
            if oldOnPreLoad ~= nil then oldOnPreLoad(inst,data) end
            if data and data.nl_check_count~=nil then inst.nl_check_count = data.nl_check_count end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:nl_lotterymachine

AddPrefabPostInit("nl_lotterymachine", function(inst)   --弹珠抽奖机
    if TheWorld.ismastersim then --判断是不是主机
        if inst.components.trader == nil then
            inst:AddComponent("trader")
        end
        
        if inst.components.trader then
            inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest_bl)
            inst.components.trader:SetAcceptTest(can_accept_item_bl)
            inst.components.trader.onaccept = bl_OnGetItemFromPlayer_b
        end
  
        inst:AddTag("not_move_nl") --不会被清理
        inst:AddTag("shop_no_destroy") --不可以被拆解法杖分解
    
        -- inst:AddComponent("timer")
        -- inst:ListenForEvent("timerdone", clear_nightlight_keep)
        -- clear_nightlight_begin(inst)

        -- 监听世界时间：进入黄昏时触发清理记录
        inst:WatchWorldState("phase", function(inst, phase)
            if phase == "dusk" then
                inst:DoTaskInTime(5, nl_doclean)
            end
        end)

        local oldsave = inst.OnSave
        inst.OnSave = function(inst, data)--当保存的时候
            if oldsave ~= nil then oldsave(inst,data) end
            data.nl_check_count = inst.nl_check_count
        end
        
        local oldOnPreLoad = inst.OnPreLoad
        inst.OnPreLoad = function(inst,data)
            if oldOnPreLoad ~= nil then oldOnPreLoad(inst,data) end
            if data and data.nl_check_count~=nil then inst.nl_check_count = data.nl_check_count end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:drownable
if GetModConfigData("if_drownable") then
    AddComponentPostInit("drownable",function(component)    --溺水不掉落物品
        component.DropInventory = function(self, inst) end
        component.ShouldDropItems = function(self, inst) end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:pinkstaff

    AddPrefabPostInit("pinkstaff", function(inst)   --幻象法杖，不能幻化商品
        if TheWorld.ismastersim then
            if inst.components.spellcaster then
                inst.components.spellcaster.can_cast_fn = nil
                inst.components.spellcaster.can_cast_fn = function (doer, target, pos)
                    if target:HasTag("shopitem") then
                        return false
                    end

                    if target == nil then --解除幻化，也是可以生效的
                        return true
                    elseif target == doer then --对自己施法：解除幻化
                        return true
                    elseif DRESSUP_DATA_LEGION[target.prefab] ~= nil then
                        return true
                    end
                
                    return false
                end
            end
        end
    end)
end

for i, v in pairs(backpack_list) do
    AddPrefabPostInit(v, function(inst)   --背包死亡不掉落
        if TheWorld.ismastersim then
            if inst.components.inventoryitem then
                inst.components.inventoryitem.keepondeath = true
            end
        end
    end)
end

AddPrefabPostInit("lucky_goldnugget", function(inst)   --幸运黄金的堆叠数量调大
    if TheWorld.ismastersim then
        if inst.components.stackable then
            inst.components.stackable:SetIgnoreMaxSize(true)
        end
    end
end)
-----------------------------------------------------------------------------------新人保护试写
local function player_protect (inst)   
    local playerday = inst.components.age:GetAgeInDays() + 1
    if playerday <= 21 then
        local ab_pre =0.01*(42 - (playerday*2))
        local absorb_rate = nil
        if ab_pre>= 0 then absorb_rate = ab_pre else absorb_rate = 0 end
        local init_ab_rate = 0
        if inst.components.health then
            if inst.prefab == "wathgrithr" then init_ab_rate = 0.25 end
            inst.components.health.absorb = init_ab_rate + absorb_rate <= 0.95 and init_ab_rate + absorb_rate or 0.95
        end

        if absorb_rate > 0 and playerday % 3 == 0  then --每三天播报一次 
            _G.TheNet:Announce("玩家 "..inst:GetDisplayName().." 的生存时间不满20天，当前自带额外 "..tostring(absorb_rate*100).." %伤害减免 ")
        end
    end
end

AddComponentPostInit("age", function(self, inst)--生存保护，boss更新debuff
    if TheWorld.state.cycles >= 50 and (inst ~=nil and inst:HasTag("player") and not inst:HasTag("playerghost") and inst.components.age) then
        inst:DoPeriodicTask(480, function(inst)
            -- if inst.userid == "KU_iJIpbeHa" then --整蛊一下某位玩家(无情修狗)
            --     TheNet:Announce("检测到玩家 【"..inst:GetDisplayName().."】 在线，触发事件 —— 陶笛的诅咒：该玩家抽奖抽到好东西的概率减少1%")
            -- end
            player_protect(inst)
        end)
    end
    if TheWorld.state.cycles%10 == 0 then   --debuff更新
        if inst and inst:IsValid() and inst.components and inst.components.nl_entitydebuff then
            inst:DoTaskInTime(5*FRAMES,function()
                if inst.components.nl_entitydebuff.self.buffnum and inst.components.nl_entitydebuff.self.buffnum<1 then
                    inst.components.nl_entitydebuff:Init()
                end
            end)
        end
    end
end)
-----------------------------------------------------------------------------------加一点生物加强，可以自己选择关闭
local str_list = {--只选了能对玩家造成伤害的大部分生物，像亮茄这种真的恶心的还是不加强了
    "spider", "spider_warrior", "spider_hider", "spider_spitter", "spider_dropper", "spider_moon", "spider_healer","spider_water",--各种小蜘蛛                                                                                                          
    "bee", "killerbee",--蜜蜂
    "bat",--蝙蝠
    "mosquito",--蚊子
    "frog",--青蛙
    "penguin",--企鹅
    "pigman",--猪人
    "pigguard",--猪人守卫
    "rocky",--石虾
    "bunnyman",--兔人
    "merm",--鱼人
    "mushgnome",--蘑菇精
    "beefalo",--牛
    "koalefant_summer", "koalefant_winter",--冬夏象
    "catcoon",--浣猫
    "lightninggoat",--电羊
    "walrus",--海象
    "little_walrus",--小海象
    "grassgator",--草鳄鱼
    "shark",--大白鲨
    "gnarwail",--一角鲸
    "squid",--章鱼
    "tallbird",--高鸟
    "hound", "firehound", "icehound", "hedgehound_bush", "hedgehound",--各种狗
    "slurtle", "snurtle",--蜗牛
    "slurper",--缀食者
    "monkey",--猴子
    "knight", "knight_nightmare",--发条骑士
    "bishop", "bishop_nightmare",--发条主教
    "rook", "rook_nightmare",--发条战车
    "worm",--洞穴蠕虫
    "yots_worm",--金蠕虫
    "krampus",--坎普斯
    "mossling",--小鸭子
    "tentacle",--触手
    "molebat",--裸鼹鼠蝙蝠
    "fused_shadeling",--熔合暗影
    "shadowthrall_hands","shadowthrall_wings","shadowthrall_horns",--墨荒
    "crabking_mob",--蟹卫
    "crabking_mob_knight",--蟹骑士
    "crabking_cannontower",--加农炮塔
    "otter",--水獭掠夺者
    "shadowthrall_mouth",--狞笑
    "chest_mimic_revealed",--暴躁箱子
    "rabbitkingminion_bunnyman",--皇家兔子警卫
    "mutatedbuzzard_gestalt",--水晶冠秃鹫
    "cave_vent_mite",--地热螨
    "ruinsnightmare",--潜伏梦魇
    ---------------------------之后的为大部分boss
    "shadow_rook", "shadow_knight", "shadow_bishop",--暗影三基佬
    "spiderqueen",--蜘蛛女王
    "leif", "leif_sparse",--树精
    "deerclops",--巨鹿
    "moose",--鹿鸭
    "antlion",--蚁狮
    "warg",--座狼
    "spat",--钢羊
    "warglet",--年轻座狼
    "bearger",--熊大
    "klaus",--克劳斯
    "lordfruitfly",--果蝇王
    "dragonfly",--龙蝇
    "beequeen",--蜂后
    "minotaur",--犀牛
    "toadstool",--蛤蟆
    "toadstool_dark",--金蛤蟆
    "stalker_atrium",--远古影织者
    "alterguardian_phase1", "alterguardian_phase2", "alterguardian_phase3",--天体英雄3种形态
    "malbatross",--邪天翁
    "crabking",--帝王蟹
    "eyeofterror", "twinofterror1", "twinofterror2",--恐怖之眼，激光眼，魔焰眼
    "shadowthrall_hands", "shadowthrall_horns", "shadowthrall_wings",--三种墨荒
    "sharkboi",--大霜鲨
    "daywalker",--疯猪
    "daywalker2",--疯猪
    "mutateddeerclops",--晶体巨鹿
    "mutatedbearger",--装甲熊大
    "worm_boss",--巨大洞穴蠕虫
    "rabbitking_aggressive",--暴戾兔王
    "alterguardian_phase4_lunarrift",--天体后裔
    "wagboss_robot",--战争瓦器人
    "shadowthrall_centipede_controller",--涟漪
    "vault_pillar_guard",--远古戍卫塔
}

if GetModConfigData("creature_health_str") ~= false then --血量成长，就是随天数变多，新生成的生物血量会慢慢变高
    for i, v in pairs(str_list) do
        AddPrefabPostInit(v, function(inst)
        if TheWorld.ismastersim then

            local hp_rate = GetModConfigData("creature_health_str")
            local max_day = GetModConfigData("creature_str_day")

            local now_day = TheWorld.state.cycles
            local current_rate = nil

            if now_day < max_day then
                current_rate = (((hp_rate - 1) / max_day) * now_day) + 1 --每天变为当前天数占目标天数的百分比
            else
                current_rate = hp_rate
            end

            if inst.components.health then
                local creature_hp = inst.components.health.maxhealth --记录其原版血量
                inst.components.health:SetMaxHealth(creature_hp * current_rate)
            end
        end
        end)
    end
end

if GetModConfigData("creature_attack_str") ~= false then --基础攻击力成长，就是随天数变多，新生成的生物基础攻击力会慢慢变高
    for i, v in pairs(str_list) do
        AddPrefabPostInit(v, function(inst)
        if TheWorld.ismastersim then
            local at_rate = GetModConfigData("creature_attack_str")
            local max_day = GetModConfigData("creature_str_day")

            local now_day = TheWorld.state.cycles
            local current_rate = nil

            if now_day < max_day then
                current_rate = (((at_rate - 1) / max_day) * now_day) + 1 --每天变为当前天数占目标天数的百分比
            else
                current_rate = at_rate
            end

            if inst.components.combat then
                local creature_at = inst.components.combat.defaultdamage --记录其原版攻击力
                inst.components.combat:SetDefaultDamage(creature_at * current_rate)
            end
        end
        end)
    end
end

----------------------------------------导入商店系统动作，从老木糖的杂草战争mod继承与修改
modimport("scripts/mutang_shop.lua")
----------------------------------------导入陷阱箱相关函数，麦斯威尔陷阱修改，以及一些杂项修改
modimport("scripts/trap_chest.lua")
----------------------------------------导入商品保护，不让商品可以被拆解法杖分解
modimport("scripts/shop_protect.lua")
----------------------------------------BOSS击杀奖励福袋
if GetModConfigData("boss_kill_gift") then
    modimport("scripts/boss_gift.lua")
end
----------------------------------------BOSS不相互攻击
if GetModConfigData("boss_attack_each") then
    AddComponentPostInit("combat", function(self)
        local OldSuggestTarget=self.SuggestTarget
        self.SuggestTarget = function(self,target)  --仇恨
            if target == nil then return false end --保险，有时候会打到空气而报错？
            if self.inst:HasTag("epic") and target:HasTag("epic") then --boss一般有的标签，懒得再列表给boss加标签了(已知会忽略暗影三基佬，帝王蟹)
                return false
            else
                return OldSuggestTarget and OldSuggestTarget(self,target) or false
            end
        end

        local OldCanHitTarget=self.CanHitTarget
        self.CanHitTarget = function(self,target, weapon)   --攻击命中
            if target == nil then return false end   --保险，有时候会打到空气而报错？
            if self.inst:HasTag("epic") and target:HasTag("epic") then --boss一般有的标签，懒得再列表给boss加标签了(已知会忽略暗影三基佬，帝王蟹)
                return false
            else
                return OldCanHitTarget and OldCanHitTarget(self,target,weapon) or false
            end
        end
    end)
end
----------------------------------------强度模式调整
if GetModConfigData("hard_modify") then
    modimport("scripts/hard_modify.lua")
end
----------------------------------------boss再加强，受伤反击，参考成就
local BOSSLISTAI = {"dragonfly", "deerclops", "bearger", "moose", "beequeen", "klaus","antlion","toadstool","toadstool_dark","malbatross",
"minotaur", "stalker_atrium","crabking",
"alterguardian_phase1", "alterguardian_phase2", "alterguardian_phase3", "eyeofterror",--"koalefant_summer","koalefant_winter",
"twinofterror1", "twinofterror2","daywalker","sharkboi","daywalker2","mutateddeerclops","mutatedbearger","vault_pillar_guard","alterguardian_phase4_lunarrift",
"wagboss_robot",
}
if GetModConfigData("boss_str_more") then
for _, v in pairs(BOSSLISTAI) do -- boss受伤有概率加快反击，对玩家伤害提高
    if v then
        AddPrefabPostInit(v, function(inst)
            if TheWorld.ismastersim then
                local day = TheWorld.state.cycles
                local max_day = GetModConfigData("creature_str_day")
                local absorbpresent = math.min(day/max_day,1)
                local tem_cooldowntime = 2
                local tem_random = 0.7
                if inst.components.combat then
                    if v and (v ~= "twinofterror1" or v ~= "twinofterror2") then
                        inst.components.combat.playerdamagepercent = 1 - 0.25*absorbpresent
                    else
                        inst.components.combat.playerdamagepercent = 1
                    end
                end
                if inst.components.health then
                    if v and v ~= "klaus" and v ~= "worm" and v ~= "stalker_atrium" then
                        if v == "alterguardian_phase1" or v == "alterguardian_phase2" or v == "alterguardian_phase3" then
                            inst.components.health:SetAbsorptionAmount(0.25*absorbpresent)
                        else
                            inst.components.health:SetAbsorptionAmount(0.35*absorbpresent)
                        end
                    end
                    if v and (v == "koalefant_summer" or v == "koalefant_winter" or v =="malbatross") then
                        tem_cooldowntime = 2
                        tem_random = 0.5
                    end
                    if v and (v == "crabking") then
                        tem_cooldowntime = 2.5
                        tem_random = 0.1
                    end
                end
            
                inst:ListenForEvent("attacked", function(inst, data)
                    if v ~= "eyeofterror" and v ~= "twinofterror1" and v ~= "twinofterror2" then
                        if inst.components.combat and math.random() < tem_random and inst._task_cooldown_atk == nil then
                            if data and data.attacker and data.attacker:HasTag("player") and not data.attacker:HasTag("playerghost") then ---and inst.components.combat:TryAttack(data.attacker) then
                                if not inst.components.health:IsDead() then
                                    inst.components.combat:ResetCooldown()
                                    inst._task_cooldown_atk =
                                        inst:DoTaskInTime(tem_cooldowntime, function(inst)
                                            inst._task_cooldown_atk = nil
                                    end)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end
end
-----------------------------------------Boss词条
if GetModConfigData("debuff_appearanceday") then
    for _, v in pairs(BOSSLISTAI) do --各种boss词条
        if v then
            AddPrefabPostInit(v, function(inst)
                if TheWorld.ismastersim then
                    if inst.components.nl_entitydebuff==nil then
                        inst:AddComponent("nl_entitydebuff")
                    end
                    inst:DoTaskInTime(4*FRAMES,function()
                        inst.components.nl_entitydebuff:Init()
                    end)
                    inst:AddTag("nl_debuff_creature")
                end
            end)
        end
    end
end
----------------------------------------药水作用
modimport("scripts/use_medal_f.lua")
----------------------------------------动作修改
--modimport("scripts/actionchange_attack.lua")
modimport("scripts/actionchange_aoespell.lua")
----------------------------------------一些ui
modimport("scripts/nl_ui.lua")
----------------------------------------
modimport("scripts/nl_recipe.lua")
----------------------------------------
--modimport("scripts/nl_itemflymethod.lua")

local old_DoPeriodicTask = EntityScript.DoPeriodicTask
function EntityScript:DoPeriodicTask(period, fn, initialdelay, ...)
    local wrapped_fn = function(inst, ...)
        if inst == nil or not inst:IsValid() then return end
        local ok, err = pcall(fn, inst, ...)
        if not ok then
            TheNet:Announce("错误：entityscript attempt to index local 'self' (a nil value) -->"..tostring(err))
            print("PERIODIC TASK ERROR:", err)
        end
    end
    return old_DoPeriodicTask(self, period, wrapped_fn, initialdelay, ...)
end

```



### 变体演进：龙右 (Mod 3820211135)
- **变体场景与切面**：收录来自工坊 Mod 3820211135 (`龙右`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820211135)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:experiencecollector
--     "回调体里判 prefab"规则拦（2026-09-21 新增）。
AddComponentPostInit("experiencecollector", function(self)
    local _UpdateXp = self.UpdateXp

    self.UpdateXp = function(comp, ...)
        if comp.inst ~= nil and comp.inst.prefab == "esctemplate" then
            return
        end
        return _UpdateXp(comp, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:esctemplate
-- 玩家入场：服务端起任务监听并在握手后把名单交给客户端；客户端按名单重设可点状态。
AddPrefabPostInit("esctemplate", function(inst)
    ---------------------------------------------------------------------------
    -- 【2026-10-15 三合一】本 prefab 原先有**三个** PostInit（本处 / 文件中部
    -- 的"位面伤害" / 文件尾的"涅槃结算"），现合并成这一个。次序说明：
    --   官方按**注册顺序**依次跑同一 prefab 的多个 PostInit，原先实际次序是
    --   任务监听 → 位面伤害 → 涅槃结算。现在把后两段放在本函数**最前面**，
    --   于是变成 位面伤害 → 涅槃结算 → 任务监听。
    --   三段互不读写对方的状态（一个加组件、一个挂监听、一个挂任务监听），
    --   调序无影响 —— 但**必须**放在下面那条早退之前：任务监听那段有
    --   `skilltreeupdater == nil 就 return`，后两段若放在它之后，
    --   会在"没有 skilltreeupdater 的实体"上被那个 return 一起吞掉。
    ---------------------------------------------------------------------------

    -- 位面伤害组件（万龙战法需要；原来的"死亡不掉落"hook 已删除，
    -- 改为在 shengwunang 里置空 container.DropEverything）
    if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim then
        if inst.components.planardamage == nil then
            inst:AddComponent("planardamage")
        end
    end

    ---------------------------------------------------------------------------
    -- 生物基因 · 12「不死鸟涅槃」②：复活后的三维结算（**官方不重设三维**）
    --
    -- CommonActualRez 只做 Resume() / 解除 ignore，**不 SetPercent**；三维数值是
    -- 死亡瞬间写进去的：
    --   · CommonPlayerDeath  → sanity:SetPercent(.5)、hunger:SetPercent(2/3)
    --   · OnMakePlayerGhost  → health:SetCurrentHealth(TUNING.RESURRECT_HEALTH)（**50，绝对值**）
    -- ⇒ 官方复活后大约是 50 血 / 50% 理智 / 66.7% 饱食。要变成"血满 / 理智满 / 饱食一半"
    --   必须我们自己设。
    --
    -- 接在 `ms_respawnedfromghost` 上 —— 那是 DoActualRez 的**最后一行**
    --（CommonActualRez 已跑完、playerghost tag 已摘掉），此时写不会被随后的
    --  Resume() / `sanity.ignore` 复位覆盖。reviver_rebirth 状态的 onenter / timeline /
    --  onexit **都不碰三维**（只做皮肤 / 光晕 / 光照 / 影子恢复 + SetInvincible），
    --  所以写在事件里是安全的（写早了反而会被重生的演出覆盖掉观感）。
    --
    -- "无任何惩罚"这半龙右**本来就免疫**：prefabs/esctemplate.lua 里已经设了
    --   health.disable_penalty = true（Health:SetPenalty 直接跳过）
    --   + sanity.penalty = 0 / AddSanityPenalty 空实现
    -- ⇒ 官方那两条 DeltaPenalty 路径对龙右是空转，上限不会被削。
    ---------------------------------------------------------------------------
    if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim then
        inst:ListenForEvent("ms_respawnedfromghost", function(inst)
            if not inst._esctemplate_nirvana_pending then
                return
            end
            inst._esctemplate_nirvana_pending = nil
            local health = inst.components.health
            if health ~= nil then
                health:SetPercent(1)
            end
            local sanity = inst.components.sanity
            if sanity ~= nil then
                sanity:SetPercent(1, true)
            end
            local hunger = inst.components.hunger
            if hunger ~= nil then
                hunger:SetPercent(T.NIRVANA_HUNGER_PERCENT, true)
            end
        end)
    end

    ---------------------------------------------------------------------------
    -- 玩家入场（原 733 那段，本体未动）
    ---------------------------------------------------------------------------
    if inst.components == nil or inst.components.skilltreeupdater == nil then
        return
    end

    -- 环境日志：**两端都会打**（故意放在 ismastersim 判断之外）。这一端到底
    -- "有没有 UI / 有没有服务端组件"，直接决定 Unlock.Grant 把"开放"交给谁 ——
    -- 排查"任务做完了却点不亮"先对比这一对日志（client_log.txt 与 master_server_log.txt 各一行）：
    --   有UI=true                → 这一端就是玩家的客户端，Grant 会就地开放 ✔
    --   有UI=false 且 ismastersim=true → **服务端 VM**：它改 root / 抬 XP 都是白干（界面收不到）
    --   ismastersim=false        → 客户端 VM
    print(string.format("[龙右] 入场 %s：ismastersim=%s 本机玩家=%s 有UI=%s 服务端组件=%s",
        tostring(inst.prefab),
        tostring(GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim),
        tostring(inst == GLOBAL.ThePlayer),
        tostring(inst.HUD ~= nil),
        tostring(inst.components ~= nil and inst.components.esctemplate_skills ~= nil)))
    if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim then
        Unlock.StartTracking(inst)
        -- 点亮反馈：玩家在技能树里点下节点的那一刻飘「解锁技能：<技能名>」（第二次播报）。
        -- 只能靠监听官方事件 —— 点亮走的是官方 RPC 链，我们的解锁模块全程不参与：
        --   客户端 ActivateSkill → RPC.SetSkillActivatedState → 服务端 ActivateSkill
        --   → ActivateSkill_Server（skilltreeupdater.lua:77）推 onactivateskill_server。
        -- 🔴 只挂在**服务端**这一段：那条分支里，服务端玩家实体在"远端玩家"（:91-92）
        --    与"房主托管自己"（:96-99）两种情形下都会推这个事件，而服务端 talker 说的话
        --    会网络同步给所有客户端 ⇒ 说一遍、所有人（含远端）都看得见。
        --    客户端那段（:100-105）只推 onactivateskill_client，两边都挂就会飘两遍。
        Unlock.WatchActivation(inst)
        -- 握手完成之后（POSTACTIVATEHANDSHAKE.READY → ms_skilltreeinitialized，
        -- player_common_extensions.lua:1074-1076）再把名单交过去：
        -- 本端就是玩家的客户端就地应用，否则（服务端 VM，连房主也算）发 RPC。
        -- 判据同 Unlock.Grant：IsClientOwner，别用 player == ThePlayer 猜。
        -- ⚠ 服务端**不做** XP 对齐：XP 是客户端权威的量，服务端去"抹平残留 XP"
        --    会把玩家手里还没花的技能点一起抹掉。
        inst:ListenForEvent("ms_skilltreeinitialized", function()
            Unlock.PushOpen(inst)
        end)
    end

    -- 客户端侧：可点性（root）与 XP 都在这一端。
    -- root 只是内存态、而且挂在**全局** SKILLTREE_DEFS 上 → 每次进场都要整体重设一次
    -- （先全清、再按名单置）。这既是"补回上次的可点状态"，也是**换世界时清掉上一个
    -- 世界残留**的唯一时机 —— 少了它，新建世界里旧世界开放过的节点照样可点，
    -- 点一下就亮回来（2026-09-21 那次 bug 的另一半）。
    -- ⚠ 但**重设用的名单必须是服务端下发的那一份**（RPC → Unlock.ApplyPacked）：
    --    本端刚进场时那份是空的，抢先把空名单套上去 = 把服务端刚发的整份名单抹掉。
    --    两个事件谁先谁后不确定，所以这里只交给 Unlock.OnClientInitialized 去**等**：
    --    等到了就不动，等不到（grace 秒）才按本端名单兜底重设。
    -- 时机取官方握手完成事件：那会儿 activatedskills 才是权威数据（见 skillunlock 文件头 (c)）。
    inst:ListenForEvent("skilltreeinitialized_client", function()
        if GLOBAL.ThePlayer ~= nil and inst == GLOBAL.ThePlayer then
            Unlock.OnClientInitialized(inst)
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
-- 配方
-- 之前写在了 AddPrefabPostInit("world") 里，开洞穴/重开档会重复注册，
-- 这里直接在顶层调用一次即可。
--
-- 【force_hint = true】下面三条装备配方都带这个标记，意思是「在制作栏里永远显示」。
--
-- 为什么必须加：制作栏只会显示 knows_recipe 或 should_hint_recipe 的配方
-- （craftingmenu_hud.lua:309）。should_hint_recipe 的判定是
-- 「配方科技等级 ≤ 玩家当前科技等级 + 1」（widgetutil.lua:2），
-- 也就是说科技等级 2 以上的配方，对空手玩家压根不出现——原版 constants.lua:1244
-- 那句注释正是在讲这件事："Magic starts at level 2 so it's not teased from the start"。
-- 于是 TECH.ANCIENT_FOUR 的魔戟/魔铠要摸到完整的远古祭坛才冒出来，
-- TECH.SCIENCE_TWO 的生物囊也要靠近炼金引擎才看得见，制作栏里就是「什么都没有」。
--
-- 加上 force_hint 之后的实际表现（全部是官方原本就支持的路径）：
--   · 未达成科技：在「冒险家物品」「模组物品」栏里恒常显示，暗色 + 挂锁图标
--     （craftingmenu_widget.lua:1073），鼠标移上去按 TUNING.PROTOTYPER_TREES 反推
--     提示该带什么机器（craftingmenu_details.lua:87），比如"需要一座完整的远古遗迹"；
--   · 达成科技但原料不够：恢复正常配方的样子，只是变暗（无锁）；
--   · 原料齐了：正常可点。
-- 也就是说它只影响「看不看得见」，科技门槛和材料门槛都原样保留。
-- 顺带注意：CHARACTER（冒险家物品）栏 ~= CRAFTING_STATION 栏，后者会把 force_hint
-- 配方藏起来（craftingmenu_widget.lua:219），所以本栏不受影响。
-------------------------------------------------------------------------------
AddRecipe2("anmesijichangmaji",
    { Ingredient("gnarwail_horn", 3), Ingredient("shadowheart", 1), Ingredient("livinglog", 20), Ingredient("dreadstone", 10) },
    TECH.ANCIENT_FOUR,
    {
        atlas = "images/inventoryimages/anmesijichangmaji.xml",
        image = "anmesijichangmaji.tex",
        builder_tag = "esctemplate",
        force_hint = true,
    },
    { "CHARACTER", "MODS" })

AddRecipe2("shengmingmokai",
    {
        Ingredient("dreadstone", 5),
        Ingredient("shadowheart", 1),
    },
    TECH.ANCIENT_FOUR,
    {
        atlas = "images/inventoryimages/shengmingmokai.xml",
        image = "shengmingmokai.tex",
        builder_tag = "esctemplate",
        force_hint = true,
    },
    { "CHARACTER", "MODS" })

AddRecipe2("shengwunang",
    {
        Ingredient("rabbit", 4),
        Ingredient("spider", 4),
        Ingredient("froglegs", 4),
        Ingredient("pigskin", 20),
    },
    TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages.xml",
        image = "krampus_sack.tex",
        builder_tag = "esctemplate",
        force_hint = true,
    },
    { "CHARACTER", "MODS" })

-------------------------------------------------------------------------------
-- 活木：消耗生命制作（参考原版植物人 recipes.lua:338）
--
-- 三点必须这么写：
-- 1. 配方名不能叫 "livinglog"。官方已经给植物人注册过同名配方（recipes.lua:338，
--    builder_tag="plantkin"），而配方是按名字存进 AllRecipes 的，重名会直接覆盖掉官方那条，
--    植物人就再也做不了活木了。所以另起一个名字，用 product 指回真正的产物。
-- 2. 生命原料用官方一等公民 CHARACTER_INGREDIENT.HEALTH（constants.lua:2126），
--    扣血在 builder.lua:570、制作栏的原料预览在 builder_replica.lua，全都是自带的，不用自己写。
--    硬约束：数量必须是 5 的倍数（constants.lua:2134），否则 Ingredient 构造时直接断言失败。
-- 3. 名字和图标都不用额外补 STRINGS / Assets：craftingmenu_details.lua:253 先查
--    STRINGS.NAMES[upper(recipe.name)]，查不到就退到 STRINGS.NAMES[upper(recipe.product)]，
--    于是自动显示原版活木的名字；图标同理走 GetInventoryItemAtlas 找原版图集。
-- 4. （2026-09-21 新增）这条配方**锁在技能树节点 esctemplate_body5（「活木」）后面**，
--    用的是**官方原生字段** builder_skill（recipes.lua 里 Wurt 的蚊子包、Wendy 的药水、
--    Wilson 的炼金转化、Wormwood 的"以生命造树苗/浆果丛/芦苇"等几十条都在用）：
--      · 客户端：builder_replica.lua:409 的 CanLearn → false
--        → craftingmenu_hud.lua:312 算出 is_build_tag_restricted
--        → :320 把 build_state 置 "hide" ⇒ **未点亮时制作栏里压根不显示这条配方**
--        （不是灰显，是不出现）；
--      · 服务端：builder.lua:869 起那段 KnowsRecipe 同样看这个字段，绕不过去。
--    ⚠ 值必须与任务表里的节点 key 逐字一致（esctemplate_body5）。改一处要改两处 ——
--      自检 _check_skilltree.py 会把"节点 ↔ builder_skill"这一对当硬规则核对。
--    ⚠ 不用自己写刷新：官方 craftingmenu_hud.lua:121 本来就监听了 onactivateskill_client
--      （点亮时由 skilltreeupdater.lua:67 在客户端推）→ 自动 UpdateRecipes，
--      点亮那一刻配方就出现在制作栏里。
--
-- builder_tag 用角色自己的标签（prefabs/esctemplate.lua:43 加的 "esctemplate"），
-- 所以只有龙右能做；也不会像 plantkin 那样连带把植物人的荆棘甲/荆棘陷阱/堆肥包一起解锁。
-------------------------------------------------------------------------------
local CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT

AddRecipe2("esctemplate_livinglog",
    { Ingredient(CHARACTER_INGREDIENT.HEALTH, T.LIVINGLOG_HEALTH_COST) },
    TECH.NONE,
    {
        product = "livinglog",
        image = "livinglog.tex",
        builder_tag = "esctemplate",
        -- 🔴 技能树节点「活木」没点亮 → 这条配方在制作栏里**不出现**、服务端也拒绝制作。
        --    值 = 任务表里那个节点的 key（esctemplate_quests.lua 的 esctemplate_body5）。
        builder_skill = "esctemplate_body5",
        allowautopick = true,
        no_deconstruction = true,
    },
    { "CHARACTER", "MODS" })

-------------------------------------------------------------------------------
-- 魔蛟毒：技能树节点 esctemplate_body10（「冰海魔蛟毒」）的解锁产物
--
-- 与活木那条同路（三点注意事项照抄那边），差别只有三处：
--   1. 产物是**新物品** mojiaodu，所以 name 就是 prefab 名、不用 product，
--      但 STRINGS.NAMES.MOJIAODU **必须自己补**（见上面那段）。
--   2. 成本 500 生命（T.MOJIAODU_HEALTH_COST）—— 官方扣血判据是
--      `math.ceil(当前血) > 消耗量`（builder.lua:599）⇒ 做的时候当前血必须 ≥ 501。
--      龙右基础上限只有 80，唯一堆血手段是吞噬（每次 +50）⇒ 至少吞 9 次（530）且
--      接近满血才做得出来。这是**刻意的中后期门槛**，不是 bug。
--   3. 图标用官方 gelblob_bottle.tex（inventoryimages2.xml），走 GetInventoryItemAtlas。
--
-- 锁定方式同活木：builder_skill = 节点 key（esctemplate_body10）。
--   未点亮 → 制作栏**不显示**这条配方；服务端 KnowsRecipe 同样看这个字段，绕不过去。
-------------------------------------------------------------------------------
AddRecipe2("mojiaodu",
    { Ingredient(CHARACTER_INGREDIENT.HEALTH, T.MOJIAODU_HEALTH_COST) },
    TECH.NONE,
    {
        image = "gelblob_bottle.tex",
        builder_tag = "esctemplate",
        builder_skill = "esctemplate_body10",
        allowautopick = true,
        no_deconstruction = true,
        -- ⚠ 一次给 1 支（T.MOJIAODU_YIELD）。曾试过给 3 支来避免"驯服完手上就空"，
        --   但"指挥"已经有独立的空手通道（AddAction 那条「令其自尽」），
        --   存量只决定"还能奴役几只"⇒ 回到 1 支（用户 2026-09-22 定）。
        numtogive = T.MOJIAODU_YIELD,
    },
    { "CHARACTER", "MODS" })

-------------------------------------------------------------------------------
-- 血肉机械：技能树节点 esctemplate_body11（「血肉机械」）的 9 条解锁配方
--
-- 与活木 / 魔蛟毒同路（注意事项见那两段的注释），差别只有一个：这里是**一批**，
-- 而且产物全是**官方已有物品**，于是：
--   · 用 product 指回官方 prefab（名字 / 描述自动退回官方，不必补 STRINGS / Assets）；
--   · 配方名**必须加 esctemplate_ 前缀**。官方已经有一批同产物的配方
--     （Wilson 炼金线的 transmute_redgem / bluegem / purplegem / orangegem /
--       yellowgem / greengem / opalpreciousgem 等），而配方是按名字存进 AllRecipes 的
--     —— **重名会直接覆盖掉官方那条**（同"活木 vs plantkin"那个坑，见上面活木那段）。
--   · 图标交给 GetInventoryItemAtlas 自动解析 ⇒ **不用也不该手写 atlas**：
--     宝石横跨 inventoryimages 的 1/2/3/4 号分片、wagpunk_bits 在 3 号、gears 在 2 号，
--     写死分片迟早错一个。
--
-- 成本（T.MECH_*_COST，全是生命值）与硬约束见 tuning 里那一段注释：
--   齿轮 200 / 废料 500 / 六色宝石各 1000 / 彩虹宝石 2000。
--   ⚠ 官方彩虹宝石的配方是"六色宝石各 1"（recipes.lua 的 transmute_opalpreciousgem）
--     —— 我们这条 2000 血是**等价替代**（用命换一整套宝石），不是凭空多出一个物品。
--
-- 锁定方式同活木：每条都挂 builder_skill = "esctemplate_body11"。
--   未点亮 → 制作栏**不显示**这 9 条；服务端 KnowsRecipe 同样看这个字段，绕不过去。
--   ⚠ 值必须与任务表里那个节点的 key 逐字一致（改一处要改两处，
--     _check_skilltree.py 把"节点 ↔ builder_skill"这一对当硬规则核对）。
-------------------------------------------------------------------------------
-- 一张表描述这 9 条：{ 产物 prefab, 血耗常量 }。
-- ⚠ 顺序无所谓（配方按名字索引）。产物与门槛**故意重叠**（齿轮 / 宝石既能捡
--   也能造）：先靠捡够 7 件把节点解锁，之后就能用血把缺的那些再造出来。
--   ✅ 2026-10-16 用户拍板补上橙宝石配方 ⇒ 重叠的正好是「齿轮 + 6 色宝石」共 7 件，
--     与门槛**完全一致**（在这之前配方只产 5 色宝石，橙宝石做不出来、只能靠捡）。
local MECH_RECIPES = {
    { "gears", T.MECH_GEARS_COST },              -- 齿轮
    { "redgem", T.MECH_GEM_COST },               -- 红宝石
    { "bluegem", T.MECH_GEM_COST },              -- 蓝宝石
    { "yellowgem", T.MECH_GEM_COST },            -- 黄宝石
    { "greengem", T.MECH_GEM_COST },             -- 绿宝石
    { "purplegem", T.MECH_GEM_COST },            -- 紫宝石
    { "orangegem", T.MECH_GEM_COST },            -- 橙宝石
    { "opalpreciousgem", T.MECH_OPAL_COST },     -- 彩虹宝石
    { "wagpunk_bits", T.MECH_WAGPUNK_COST },     -- 废料
}

for _, mech in ipairs(MECH_RECIPES) do
    local mech_prefab = mech[1]
    AddRecipe2("esctemplate_" .. mech_prefab,
        { Ingredient(CHARACTER_INGREDIENT.HEALTH, mech[2]) },
        TECH.NONE,
        {
            product = mech_prefab,
            -- 图标 = 产物自己的 tex 名（都在官方 inventoryimages*.xml 里，
            -- 由 GetInventoryItemAtlas 找分片）。
            image = mech_prefab .. ".tex",
            builder_tag = "esctemplate",
            builder_skill = "esctemplate_body11",
            allowautopick = true,
            no_deconstruction = true,
        },
        { "CHARACTER", "MODS" })
end

-------------------------------------------------------------------------------
-- 气血肉龙：技能树节点 esctemplate_tgq8（**天罡气第 8 重「无」**）的两条解锁配方
--
-- 玩法（用户 2026-09-24 第二次拍板）：**两条配方**各消耗 20 块肉，做出**同一件**物品 ——
--   · 大肉版  ：20 块生大肉（meat）
--   · 怪物肉版：20 块生怪物肉（monstermeat）
-- 与活木 / 魔蛟毒 / 血肉机械同路（注意事项见那几段的注释），差别有三处：
--   1. 产物是**新物品** qixueroulong ⇒ 名字与描述必须自己补（见上面那 4 条 STRINGS）；
--   2. **两条配方共用一个产物** —— 这条是新的：配方按**名字**存进 AllRecipes
--      （recipe.lua 用 recipe.name 做索引），所以两条互不覆盖、制作栏里各占一个格子。
--      两条的 `description` 都指向**与配方名同名**的 key ⇒ 名字与描述各说各的。
--   3. 材料是**具体 prefab**（meat / monstermeat），不是血 —— 所以数量**不受
--      "必须 5 的倍数"约束**（那条只针对血/理智原料，recipe.lua 的 assert），
--      写 20 完全合法。
--      ⚠ 官方 `Ingredient` 只认"具体 prefab + 数量"、**没有 tag 原料** ⇒ "任意肉 x 20"
--        表达不了，用户 2026-09-24 因此把配方收敛成这两种。
--      ⚠ 材料按 prefab 名**精确匹配** ⇒ 烤大肉（cookedmeat）/ 肉干 / 小肉 / 鸡腿 /
--        蛙腿 / 象鼻一律**不认**（用户拍板"3 不算"）。两条描述里都写死了"生"字。
--
-- 🔴 门槛 = 技能树节点 esctemplate_tgq8（天罡气第 8 重「无」）。值必须与
--   esctemplate_quests.lua 里那个节点 key 逐字一致（_check_skilltree.py 硬核对）。
--   未点亮 → 制作栏里**不显示**这两条（builder_replica 的 CanLearn → false ⇒
--   craftingmenu_hud 把 build_state 置 hide），服务端 KnowsRecipe 同样拦（builder.lua）。
--
-- 产量 1 个、TECH.NONE（不用科技）、放**冒险家物品栏**（filters 的 CHARACTER）
--   —— 用户 2026-09-24 拍板"5：一个，不用科技，冒险家物品栏"。
--   filters 里额外带的 "MODS" 是本项目**所有**角色专属配方的统一写法（见上面三条），
--   让它在 MOD 栏里也找得到；不想要就删掉 "MODS"，不影响归属判定。
--
-- 扣料 / 出产物 / 进背包 / 背包满掉脚下**全是官方自带**（builder.lua 的 DoBuild：
--   扣料 → SpawnPrefab(recipe.product) → inventory:GiveItem），一个字都不用自己写。
-------------------------------------------------------------------------------
-- 一张表描述这两条：{ 配方名, 原料 prefab }。
-- ⚠ 配方名带 esctemplate_ 前缀（理由同血肉机械那条：避免与官方/别的 mod 重名互相覆盖）。
-- ⚠ 顺序无所谓（配方按名字索引）。
local QIXUEROULONG_RECIPES = {
    { "qixueroulong_meat",        "meat" },         -- 二十块生大肉
    { "qixueroulong_monstermeat", "monstermeat" },  -- 二十块生怪物肉
}

for _, qix in ipairs(QIXUEROULONG_RECIPES) do
    local qix_name = qix[1]
    AddRecipe2(qix_name,
        { Ingredient(qix[2], T.QIXUEROULONG_MEAT_COST) },
        TECH.NONE,
        {
            product = "qixueroulong",
            -- 🔴 atlas 必须写：配方的 image 只是个**图元名**，UI 会用 GetInventoryItemAtlas
            --    去**官方**的 inventoryimages*.xml 里找它 —— 自绘的这张不在官方图集里，
            --    不写 atlas 就是"制作栏那一格空白、且零报错"（对照上面魔戟 / 魔铠的写法）。
            atlas = "images/inventoryimages/qixueroulong.xml",
            -- 图标 = 自绘的 qixueroulong.tex（2026-10-07 起），与物品栏里那件东西同一张图。
            -- ⚠ 两条配方图标**相同**，只能靠名字/描述区分（所以上面补了 4 条 STRINGS）。
            image = "qixueroulong.tex",
            builder_tag = "esctemplate",
            -- 🔴 天罡气第 8 重「无」没点亮 ⇒ 制作栏**不显示**、服务端也拒绝制作。
            builder_skill = T.QIXUEROULONG_SKILL,
            -- 描述 key 与配方名同名：格子查 NAMES[upper(配方名)]、
            -- 详情面板查 RECIPE_DESC[upper(description or 产物名)] ⇒ 两处都落到"本条"。
            description = qix_name,
            allowautopick = true,
            -- 🔴 必须禁拆解：两条配方产出同一个物品，系统分不清来源 —— 不禁就会出现
            -- 「20 个怪物肉 → 肉龙 → 拆出 20 个大肉」的白赚转换。
            no_deconstruction = true,
        },
        { "CHARACTER", "MODS" })
end

-------------------------------------------------------------------------------
-- 魔蛟毒：补一条「装备在手」的右键通道（EQUIPPED）
--
-- 🔴🔴 为什么必须有这一段（血泪）：官方 componentactions.lua 只给 spellcaster
--   注册了 **POINT / USEITEM / INVENTORY** 三个表，**没有 EQUIPPED**。于是：
--     · 用鼠标"拿着"魔蛟毒（active item）右键生物 → 走 USEITEM → 有反应；
--     · 魔蛟毒**装备在手上**右键生物 → 走 EQUIPPED → 官方表是空的 →
--       `#actions == 0`，直接掉到 GetSceneActions（只剩"检视"之类）⇒
--       **右键毫无反应、零报错**，表现就是"做出来了却没法对生物用"。
--   而玩家在物品栏里右键一个可装备物品时，游戏默认是"装备"而不是"拿在鼠标上"
--   ⇒ 实操中几乎总是走装备态，必踩这个坑。
--
-- ⚠ AddComponentAction 内部按 modname 隔离（MOD_COMPONENT_ACTIONS），并要求
--   **服务端与客户端注册顺序完全一致**（不一致会打
--   "Mod component actions are out of sync"）。modmain 两端跑同一份代码 ⇒ 天然一致。
-- ⚠ 判据抄官方 USEITEM 那条（componentactions.lua:255）：right + 目标带 locomotor
--   + 物品带 castonlocomotors / castontargets + 目标不带 nomagic。
--   用 **tag** 而不是"有 spellcaster 组件"是为了跟服务端
--   `SpellCaster:CanCast`（spellcaster.lua:192）判据同源 —— tag 由 spellcaster
--   字段驱动，只要 prefab 里的 flag 改了，两端一起变，不会出现
--   "冒得出动作但按下去没效果"。
-- ⚠ prefab 限定 mojiaodu：这条规则只服务我们自己的物品，别波及别的法器。
-- ⚠ 装备态不会跟 ATTACK 抢：GetRightClickActions 装备态分支只收集
--   EQUIPPED + SCENE，不收集玩家自身动作（ATTACK 是左键/强制攻击）。
-------------------------------------------------------------------------------
AddComponentAction("EQUIPPED", "spellcaster", function(inst, doer, target, actions, right)
    if not right then
        return
    end
    if inst == nil or inst.prefab ~= "mojiaodu" then
        return
    end
    if target == nil or not target:HasTag("locomotor") or target:HasTag("nomagic") then
        return
    end
    if not (inst:HasTag("castonlocomotors") or inst:HasTag("castontargets")) then
        return
    end
    table.insert(actions, GLOBAL.ACTIONS.CASTSPELL)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson
-------------------------------------------------------------------------------
AddStategraphPostInit("wilson", function(sg)
    local hit = (sg.states ~= nil) and sg.states["hit"] or nil
    if hit == nil then
        return
    end
    local old_onenter = hit.onenter
    hit.onenter = function(inst, ...)
        if inst:HasTag(T.ARMOR_TAG) then
            if inst.sg ~= nil then
                inst.sg:GoToState("idle")
            end
            return
        end
        if old_onenter ~= nil then
            return old_onenter(inst, ...)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
AddStategraphPostInit("wilson", LY_GateFaceStates)
AddStategraphPostInit("wilson_client", LY_GateFaceStates)

-------------------------------------------------------------------------------
-- ★ 快速进食：龙右吃任何东西都走 quickeat（用户 2026-10-06 拍板）
--
--   【为什么吃肉要嚼 3 秒】官方 SGwilson 的 ACTIONS.EAT handler
--   （SGwilson.lua:1185-1197）里有一条**特判**：
--       local state =
--           (obj:HasTag("quickeat") and "quickeat") or
--           (obj:HasTag("sloweat") and "eat") or
--           ((obj.components.edible.foodtype == FOODTYPE.MEAT
--             and not obj:HasTag("fooddrink")) and "eat") or   ← 就是这一条
--           "quickeat"
--       浮空时再拼成 "float_" .. state
--   默认本来就是 quickeat —— 只有**肉**被单独拎出来走长 eat。所以
--   "吃花很快、吃肉要嚼"不是动画慢，而是这一行。
--   两套状态的代价（FRAMES = 1/30）：
--       eat      = eat_pre + eat            ⇒ 效果在 28 帧结算，动画 94 帧 ≈ 3.1 秒
--       quickeat = quick_eat_pre + quick_eat ⇒ 效果在 12 帧结算，动画 21 帧 ≈ 0.7 秒
--
--   ✅ 做法：包一层 **deststate**，不动 action 本身、不动状态表。
--      · 状态机取状态的唯一入口是 `handler.deststate(self.inst, bufferedaction)`
--        （stategraph.lua:436 StartAction；:412 PreviewAction 同款）⇒ 包这里
--        一次就覆盖"自己吃"的**服务端**与**客户端预测**两条路。
--      · **先调原函数再改名** ⇒ "不肯吃要说话"(wonteatfood)、忙碌早退、空手早退
--        那些分支原样保留（它们返回 nil，改名函数对 nil 原样透传）。
--      · 只对带 `esctemplate` 标签的角色改名 ⇒ 官方角色零影响。
--      · **不需要新动画**：龙右的 bank 是官方 wilson（只有 build 是 mod 的），
--        quick_eat / quick_eat_pre 这套动画名现成就有
--        （物证：exported/esctemplate/esctemplate.scml 与 animation.xml 里
--         只有 1 个动画 BUILD_PLAYER ⇒ 动作根本不来自 mod 这边）。
--      · 尖牙不用额外处理：FACE_SHOW_STATES 白名单本来就把 quickeat /
--        float_quickeat 收在里面（见上面那张表）。
--
--   🔴 三条边界（用户 2026-10-06 明确）：
--     ① **别人喂你 → 保持原版（吃肉仍嚼）**。被别人喂走的是
--        ACTIONS.FEEDPLAYER.fn（actions.lua:2423 —— 它自己算完 state 直接
--        `act.target.sg:GoToState(...)`，**根本不经过 actionhandlers**）
--        ⇒ 本补丁天然管不到，正好就是用户要的。
--     ② 盛宴大快朵颐（WINTERSFEAST_FEAST）是另一个动作，不在范围。
--     ③ **吞噬保持正常播 eat**。它走 skilldefs 里直接
--        `inst.sg:GoToState("esctemplate_devour")`（不经过 ACTIONS.EAT）
--        ⇒ 不受影响。
-------------------------------------------------------------------------------
local function LY_QuickEatAllowed(inst)
    -- 🔴 这个门控是"不污染官方角色"的唯一保证，别改松（有负向用例盯着）。
    return inst ~= nil and inst:HasTag("esctemplate")
end

```



### 变体演进：【崩铁厄敌/Phaidei】万敌 (Mod 3793699296)
- **变体场景与切面**：收录来自工坊 Mod 3793699296 (`【崩铁厄敌/Phaidei】万敌`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3793699296)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:mydei

        AddPrefabPostInit("mydei", function(inst)
            -- v54：阶段 netvar —— 服务端写、客户端读（图标自动点亮 + 打开中的面板实时刷新）。
            --   netvar 两端都必须建，所以放在 mastersim 分支**之前**声明。
            inst.mydei_insight_stage = GLOBAL.net_byte(inst.GUID, "mydei.insight.stage", "mydeiinsightstagedirty")
            -- v57：计数 netvar —— 客户端显示进度 / 判小锁开合（与阶段 netvar 同源同步）。
            --   类型按**正式量程**预置（netvars.lua:97 GetIdealUnsignedNetVarForCount）：
            --   正式门槛 77 投掷 / 777 矛命中 ⇒ net_ushortint（上限 65535，够）；巨兽 ≤3 ⇒ net_byte。
            --   ⚠️ v58 测试期计数只是个位数，也**不要**降成 net_byte —— 门槛改回正式值时会溢出。
            inst.mydei_insight_throw = GLOBAL.net_ushortint(inst.GUID, "mydei.insight.throw", "mydeiinsightstagedirty")
            inst.mydei_insight_melee = GLOBAL.net_ushortint(inst.GUID, "mydei.insight.melee", "mydeiinsightstagedirty")
            inst.mydei_insight_giant = GLOBAL.net_byte(inst.GUID, "mydei.insight.giant", "mydeiinsightstagedirty")

            if not GLOBAL.TheWorld.ismastersim then
                -- 客户端：阶段变化时借用官方刷新事件让打开着的技能树面板立即重渲染
                -- （skilltreewidget.lua:180 官方自己就监听 onaddskillxp_client → RefreshTree）
                inst:ListenForEvent("mydeiinsightstagedirty", function(i)
                    if GLOBAL.ThePlayer == i then
                        i:PushEvent("onaddskillxp_client")
                    end
                end)
                return
            end

            inst:ListenForEvent("onhitother", function(inst, data)
                local target = data ~= nil and data.target or nil
                if not IsAggroedEnemy(target, inst) then
                    return
                end
                -- 投掷 / 近战分路：投掷由 lance_of_fury 在 GetAttacked 前后盖时间戳
                -- （同步回调，期间一定读得到）。用 0.2s 窗口而非布尔，万一标记没清掉也会自动过期。
                local t = inst._mydei_thrownhit_t
                if t ~= nil and GLOBAL.GetTime() - t < 0.2 then
                    -- ★ v68：投掷命中 = THROW +1，**并且** MELEE +1
                    --   （MELEE 语义已放宽为「天谴之矛命中」，投掷当然也是矛命中）。
                    AddLocalCount(inst, "THROW")
                    AddLocalCount(inst, "MELEE")
                else
                    -- v56/v68：近战命中要**手里拿着天谴之矛**才计数 ——
                    --   v56 的老口径是「使用天谴之矛近战 10/30/100」；v68 去掉「必须近战」的
                    --   强制，但只要不是投掷，就仍然要求武器是这把矛（否则拿别的武器乱砍也涨）。
                    --   判据 = 手持槽里是不是带 lance_of_fury tag。
                    local hand = nil
                    if inst.components.inventory ~= nil then
                        hand = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
                    end
                    if hand ~= nil and hand:HasTag("lance_of_fury") then
                        AddLocalCount(inst, "MELEE")
                    end
                end
            end)

            -- v61：原「killed 才计巨兽」的监听已删除 —— 那时的判据是"万敌补上最后一刀"，
            --   master 定稿改成「只要万敌参与过这场战斗，巨兽最终被击败就 +1」，与谁补刀无关。
            --   现在由 NoteGiantParticipation（伤害前登记，挂在巨兽身上）+
            --   巨兽自己的 death 事件（结算）接管，见上方 v61 段。
            --   ⚠️ 不要加回来：两条并存 ⇒ 同一只巨兽被记两次。

            -- v60：玩家加载时官方会用存档里的 skilltreeblob **重新激活**技能
            --   （player_common_extensions.lua:1093 → SendFromSkillTreeBlob，时机**晚于** OnLoad）
            --   ⇒ 在这条事件上再对账一次，把「计数撑不起的旧激活记录」撤掉。
            --   这是旧激活记录唯一能被捕获的时机：OnLoad 太早（记录还没填），
            --   命中事件太晚（可能一直不打怪）。
            inst:ListenForEvent("onsetskillselection_server", function(i)
                if i._mydei_insight_counts == nil then return end
                SyncStage(i, false)   -- 内含 tag 同步 + 激活记录对账
            end)

            -- v53：实体计数随玩家存档持久化（包装 prefab 自带的 OnSave/OnLoad，先存再调原函数）
            local oldsave, oldload = inst.OnSave, inst.OnLoad
            inst.OnSave = function(i, data)
                data.mydei_insight_counts = i._mydei_insight_counts
                if oldsave ~= nil then oldsave(i, data) end
            end
            inst.OnLoad = function(i, data)
                if data ~= nil and data.mydei_insight_counts ~= nil then
                    i._mydei_insight_counts = data.mydei_insight_counts
                    -- v54：读档后把阶段 netvar 补到当前值 —— 图标点亮状态随存档恢复
                    -- v57：计数 netvar 一起补，否则客户端要等到下一次命中才看得到进度
                    PushCounts(i)
                    SyncStage(i, false)
                    -- v57：把当前进度打进 server_log —— master 核对"面板数字对不对"时一眼可查
                    local c = i._mydei_insight_counts
                    print(string.format("[mydei] insight counts loaded: THROW=%d MELEE=%d GIANT=%d (stage=%d)",
                        c.THROW or 0, c.MELEE or 0, c.GIANT or 0, i.mydei_insight_stage and i.mydei_insight_stage:value() or 0))
                end
                if oldload ~= nil then oldload(i, data) end
            end

            print("[mydei] insight auto-unlock counters installed (v53, server-side)")
        end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:container
-- ---------------------------------------------------------------------------
AddComponentPostInit("container", function(self)
    if self._lance_gate then
        return
    end
    self._lance_gate = true

    local _CanTakeItemInSlot = self.CanTakeItemInSlot
    self.CanTakeItemInSlot = function(c, item, slot, ...)
        if item ~= nil
            and LANCE_MAX_PET > 0
            and c.inst ~= nil
            and c.currentuser ~= nil            -- 只在「有人正在搬运」时判定
            and item:HasTag("lance_of_fury")
            and IsLancePet(c.inst)
            and LanceCountInContainer(c) >= LANCE_MAX_PET then
            -- 矛已经在同一个容器里、只是想换格子 → 放行，否则宠物背包内没法整理
            local already_here = false
            pcall(function()
                already_here = item.components ~= nil
                    and item.components.inventoryitem ~= nil
                    and item.components.inventoryitem:GetContainer() == c
            end)
            if not already_here then
                dlog("[lance] %s 不收天谴之矛：已达宠物持有上限（%d 把）",
                     tostring(c.inst.prefab), LANCE_MAX_PET)
                return false
            end
        end
        return _CanTakeItemInSlot(c, item, slot, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:container_classified

AddPrefabPostInit("container_classified", function(inst)
    if inst.ReceiveItem == nil then
        return
    end
    local _ReceiveItem = inst.ReceiveItem
    inst.ReceiveItem = function(i, item, count, forceslot)
        if item ~= nil and LANCE_MAX_PET > 0 and item:HasTag("lance_of_fury") then
            local parent = i._parent
            local refuse = false
            pcall(function()
                if parent ~= nil
                    and (LANCE_PET_PREFABS[parent.prefab] == true
                        or parent:HasTag("critter")
                        or parent:HasTag("companion")) then
                    refuse = LanceClassifiedAlreadyHasLance(i, item)
                end
            end)
            if refuse then
                print("[lance] 客户端预测拒绝：宠物已达天谴之矛上限（不放入、不发 RPC）")
                if GLOBAL.TheFocalPoint ~= nil and GLOBAL.TheFocalPoint.SoundEmitter ~= nil then
                    GLOBAL.TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative")
                end
                return nil
            end
        end
        return _ReceiveItem(i, item, count, forceslot)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory
-- ---------------------------------------------------------------------------
AddComponentPostInit("inventory", function(self)
    if self._lance_guarded then
        return
    end
    self._lance_guarded = true
    local _GiveItem = self.GiveItem
    self.GiveItem = function(inv, item, ...)
        if item ~= nil and item:HasTag("lance_of_fury") then
            local ok, allow = pcall(function()
                local owner = inv.inst
                if owner == nil then
                    return true
                end
                -- 已在主人名下（搬家 / 归还）→ 放行
                local cur_owner = nil
                if item.components ~= nil and item.components.inventoryitem ~= nil then
                    cur_owner = item.components.inventoryitem:GetGrandOwner()
                end
                if cur_owner == owner then
                    return true
                end
                if IsLancePet(owner) then
                    local e, s = LanceCountOwned(owner)
                    return (e + s) < LANCE_MAX_PET
                end
                -- 角色：这里只卡【总数上限】(手上1 + 背包1 = 2)。
                --   不能再套 CanHoldOneMoreLance 的"分栏位"判定：GiveItem 这个时机
                --   无法知道"手上是否空着"，分栏位会误拦合法情况——例如
                --   「背包里有 1 把、手上空着捡第 2 把」（总数才 1→2，应当允许，
                --   但 st<1 会被判 false）。分栏位判定交给动作层
                --   (CreateLance / PICKUP / GIVE 拦截) 负责，这里只兜总数。
                local e, s = LanceCountOwned(owner)
                return (e + s) < (LANCE_MAX_HELD + LANCE_MAX_STORED)
            end)
            if ok and allow == false then
                dlog("[lance] inventory:GiveItem 被拦截：%s 已达持有上限",
                     tostring(inv.inst ~= nil and inv.inst.prefab))
                return false
            end
        end
        return _GiveItem(inv, item, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson
    local ok, err = pcall(function()
        AddStategraphPostInit("wilson", GuardCastspell)
    end)
    if not ok then
        print("[mydei][sg] SGwilson castspell 守卫挂载失败: " .. tostring(err))
    end
end

-- ---------------------------------------------------------------------------
-- HUD：注入 UI 按钮（仅客户端）
-- ---------------------------------------------------------------------------
AddClassPostConstruct("screens/playerhud", function(self)
    if self._lance_of_fury_btn ~= nil then
        return
    end

```



### 变体演进：艾希,I see ! （修改版） (Mod 3814755564)
- **变体场景与切面**：收录来自工坊 Mod 3814755564 (`艾希,I see ! （修改版）`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814755564)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    if not TheNet:IsDedicated() then
        if not inst:HasTag("cave") then 
            -- GroundTiles.underground[1][2].name = "lavaarena_falloff"
            -- MapLayerManager:SetSampleStyle(MAP_SAMPLE_STYLE.MARCHING_SQUARES)
            if not inst.WaveComponent then 
                inst.entity:AddWaveComponent()
            end 
            local scale = 1.3
            inst.WaveComponent:SetWaveParams(13.5 * scale, 2.8 * (scale - .15),0.1) -- wave texture u repeat, forward distance between waves, world y-axis position
            inst.WaveComponent:SetWaveSize(80 * scale, 3.5 * scale)                 -- wave mesh width and height
            inst.WaveComponent:SetWaveMotion(.3, .5, .35)                           -- speed, horizontal travel, vertical travel                      -- wave mesh width and height
            inst.WaveComponent:SetWaveTexture(resolvefilepath("images/fog_cloud.tex"))
            inst.WaveComponent:SetWaveEffect("shaders/waves.ksh")  

            inst:DoTaskInTime(0, function(inst)
                if inst.has_ocean then
                    return
                end

                -- inst.WaveComponent:SetWaveTexture("images/wave.tex")
                inst.Map:SetTransparentOcean(false)
            end)
        end 
    end 
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:chester

--[[AddPrefabPostInit("chester",function(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	inst.enablemap = IceyUtil.EnableDrawOverFogOfWar
	IceyUtil.EnableDrawOverFogOfWar(inst,true) 
end) --]]

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:mist

AddPrefabPostInit("mist",function(inst)
	local function InitEnvelopes()
	    EnvelopeManager:AddColourEnvelope(
	        "bloodmistcolourenvelope",
	        {
	            { 0,    { 167/255, 0, 0, 0 } },
	            { .1,  {167/255, 0, 0, .12 } },
	            { .75, { 167/255, 0, 0, .12 } },
	            { 1,    { 167/255, 0, 0, 0 } },
	        }
	    )

	    InitEnvelopes = nil
	end

	if InitEnvelopes ~= nil then
        InitEnvelopes()
    end

	inst:AddComponent("areaaware")
	inst:DoTaskInTime(1,function()
		local current_area = inst.components.areaaware:GetCurrentArea()
		if current_area and current_area.id and string.find(current_area.id,"bloodcity") then 
			inst.VFXEffect:SetColourEnvelope(0,"bloodmistcolourenvelope")
			inst.components.emitter.config.colour_envelope_name = "bloodmistcolourenvelope"
		end
	end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:gunpowder

AddPrefabPostInit("gunpowder",function(inst)
	if not TheWorld.ismastersim then
		return inst
	end
	inst:AddComponent("tradable")
end) 

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:weapon

AddComponentPostInit("weapon",function(self)
	local old_OnAttack = self.OnAttack 
	self.OnAttack = function(self,attacker, target, projectile,...)
		old_OnAttack(self,attacker, target, projectile,...)
		if self.inst.components.darksoulweapon then 
			self.inst:PushEvent("darksoulweapon_onattack",{attacker = attacker,target = target,projectile = projectile})
		end 
	end
end)

```



### 变体演进：！？饥友的酒？！ (Mod 3815821175)
- **变体场景与切面**：收录来自工坊 Mod 3815821175 (`！？饥友的酒？！`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3815821175)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skinner
-- 人物皮肤的init_fn 和 clear_fn
AddComponentPostInit("skinner", function(self)
    local oldfn = self.SetSkinName
    if oldfn then
        function self.SetSkinName(s, skinname, ...)
            local old = s.skin_name
            local new = skinname
            if characterskins[old] and characterskins[old].clear_fn then characterskins[old].clear_fn(s.inst, old) end
            if characterskins[new] and characterskins[new].init_fn then characterskins[new].init_fn(s.inst, new) end
            oldfn(s, skinname, ...)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
function dst_lan:_hookCombat()
    AddComponentPostInit("combat", function(self)
        self.dstlan_atkperiodmodifiers = SourceModifierList(self.inst)
        self.dstlan_orig_min_attack_period = self.min_attack_period
        local p = rawget(self, "_")["min_attack_period"]
        local old_on_map = p[2]
        p[2] = function(self, map)
            if old_on_map ~= nil then
                old_on_map(self, map)
            end
            if self.inst.replica.combat and self.inst.replica.combat.dstlan_atkperiodmult then
                self.inst.replica.combat.dstlan_atkperiodmult:set(self.dstlan_atkperiodmodifiers:Get())
            end
        end

        function self:SetAttackPeriod(val)
            self.dstlan_orig_min_attack_period = val
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end

        function self:SetAtkPeriodModifier(source, mult, key)
            self.dstlan_atkperiodmodifiers:SetModifier(source, mult, key)
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end

        function self:RemoveAtkPeriodModifier(source, key)
            self.dstlan_atkperiodmodifiers:RemoveModifier(source, key)
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson
function dst_lan:_hookSG()
    AddStategraphPostInit("wilson", function(sg)
        local old_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function (inst,...)
            local res = old_onenter ~= nil and {old_onenter(inst,...)} or {}
            local combat = inst.components.combat
            local timeout = (math.floor(13/(combat.dstlan_atkperiodmodifiers:Get())))*FRAMES
            inst.sg:SetTimeout(timeout)
            inst.AnimState:SetDeltaTimeMultiplier(combat.dstlan_atkperiodmodifiers:Get())
            return unpack(res)
        end

        local old_ontimeout = sg.states["attack"].ontimeout
        sg.states["attack"].ontimeout = function (inst,...)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag('abouttoattack')
            return old_ontimeout(inst,...)
        end

        local old_onexit = sg.states["attack"].onexit
        sg.states["attack"].onexit = function (inst,...)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            return old_onexit(inst,...)
        end

    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
function dst_lan:_hookSGClient()
    AddStategraphPostInit("wilson_client", function(sg)
        local old_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function (inst,...)
            local res = old_onenter ~= nil and {old_onenter(inst,...)} or {}
            local timeout = (math.floor(13/inst.replica.combat.dstlan_atkperiodmult:value()))*FRAMES
            inst.sg:SetTimeout(timeout)
            inst.AnimState:SetDeltaTimeMultiplier(inst.replica.combat.dstlan_atkperiodmult:value())
            return unpack(res)
        end

        local old_ontimeout = sg.states["attack"].ontimeout
        sg.states["attack"].ontimeout = function (inst,...)
            inst:PerformPreviewBufferedAction()
            inst.sg:RemoveStateTag('abouttoattack')
            return old_ontimeout(inst,...)
        end

        local old_onexit = sg.states["attack"].onexit
        sg.states["attack"].onexit = function (inst,...)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            return old_onexit(inst,...)
        end

    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cook_certificate
    --------------------------------------------
    AddPrefabPostInit('cook_certificate',function (inst)
        if not TheWorld.ismastersim then
            return inst
        end

        local old_HarvestFoodFn = inst.HarvestFoodFn
        ---@diagnostic disable-next-line: inject-field
        inst.HarvestFoodFn = function(inst,foodname,harvester,cookpotname,...)
            local fuelnum = GetThisMODDishConsume(foodname)
            if foodname and fuelnum > 0 and not table.contains(inst.foodlist,foodname) then
                --消耗耐久
                if inst.components.finiteuses then
                    inst.components.finiteuses:Use(fuelnum)
                    inst.foodlist[#inst.foodlist+1]=foodname
                    setFoodList(inst,harvester)--同步料理列表
                    if not RewardToiler(harvester,0.1) then--天道酬勤
                        SpawnMedalTips(harvester,fuelnum,10)--弹幕提示
                    end
                end
            end
            return old_HarvestFoodFn ~= nil and old_HarvestFoodFn(inst,foodname,harvester,cookpotname,...) or nil
        end
    end)

```



### 变体演进：Walter and the GATLING SLINGSHOT (Mod 2599163162)
- **变体场景与切面**：收录来自工坊 Mod 2599163162 (`Walter and the GATLING SLINGSHOT`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2599163162)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddStategraphPostInit:wilson

AddStategraphPostInit("wilson", SGslingshotPostInit)

```



### 变体演进：Iva (Mod 3824012810)
- **变体场景与切面**：收录来自工坊 Mod 3824012810 (`Iva`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3824012810)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:iva
-- 이스터에그 거부모션
AddPrefabPostInit("iva", function(inst)
    if not GLOBAL.TheWorld.ismastersim or inst.components.eater == nil then
        return
    end
    local eater = inst.components.eater
    local _PrefersToEat = eater.PrefersToEat
    eater.PrefersToEat = function(self, food, ...)
        if food ~= nil and food.prefab == "iva_mysteryegg" then
            return false
        end
        return _PrefersToEat(self, food, ...)
    end
    local _Eat = eater.Eat
    eater.Eat = function(self, food, ...)
        if food ~= nil and food.prefab == "iva_mysteryegg" then
            return false
        end
        return _Eat(self, food, ...)
    end
    inst:ListenForEvent("wonteatfood", function(inst, data)
        if data ~= nil and data.food ~= nil and data.food.prefab == "iva_mysteryegg" and inst.components.talker ~= nil then
            inst.components.talker:Say(GLOBAL.GetString(inst, "ANNOUNCE_IVA_MYSTERYEGG"))
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:tallbirdnest

AddPrefabPostInit("tallbirdnest", function(inst)
    if not GLOBAL.TheWorld.ismastersim or inst.components.pickable == nil then
        return
    end
    local pickable = inst.components.pickable
    local _Pick = pickable.Pick
    pickable.Pick = function(self, picker, ...)
        local results = { _Pick(self, picker, ...) }
        if results[1] and picker ~= nil and picker.prefab == "iva" and math.random() < IVA_WETEGG_CHANCE then
            local x, y, z = picker.Transform:GetWorldPosition()
            SpawnWetEgg(x, z)
        end
        return GLOBAL.unpack(results)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:birdcage

AddPrefabPostInit("birdcage", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if inst.components.trader ~= nil and inst.components.trader.onaccept ~= nil then
        local _onaccept = inst.components.trader.onaccept
        inst.components.trader.onaccept = function(cage, giver, item, ...)
            local edible = item ~= nil and item.components.edible or nil
            cage.iva_feeder = giver
            cage.iva_feed_meat = edible ~= nil and edible.foodtype == GLOBAL.FOODTYPE.MEAT
            cage.iva_feed_time = GLOBAL.GetTime()
            return _onaccept(cage, giver, item, ...)
        end
    end    local dropper = inst.components.lootdropper
    if dropper ~= nil then
        local _SpawnLootPrefab = dropper.SpawnLootPrefab
        dropper.SpawnLootPrefab = function(self, lootprefab, ...)
            local loot = _SpawnLootPrefab(self, lootprefab, ...)
            local feeder = inst.iva_feeder
            if loot ~= nil and lootprefab == "bird_egg" and inst.iva_feed_meat and feeder ~= nil and feeder:IsValid() and feeder.prefab == "iva"
                and GLOBAL.GetTime() - (inst.iva_feed_time or -100) < 3 and math.random() < IVA_WETEGG_CHANCE then
                inst.iva_feed_meat = false
                local x, y, z = loot.Transform:GetWorldPosition()
                SpawnWetEgg(x, z)
            end
            return loot
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:builder

AddComponentPostInit("builder", function(self)
    local _HasCharacterIngredient = self.HasCharacterIngredient
    function self:HasCharacterIngredient(ingredient)
        if ingredient.type == CHARACTER_INGREDIENT.IVA_MANA then
            local mana = self.inst.components.iva_mana
            local current = mana ~= nil and math.floor(mana.current) or 0
            return current >= ingredient.amount, current
        end
        return _HasCharacterIngredient(self, ingredient)
    end

    local _RemoveIngredients = self.RemoveIngredients
    function self:RemoveIngredients(ingredients, recname, discounted)
        local recipe = GLOBAL.AllRecipes[recname]
        local mana = self.inst.components.iva_mana
        if not self.freebuildmode and recipe ~= nil and mana ~= nil then
            for _, v in ipairs(recipe.character_ingredients) do
                if v.type == CHARACTER_INGREDIENT.IVA_MANA then
                    mana:DoDelta(-v.amount)
                end
            end
        end
        return _RemoveIngredients(self, ingredients, recname, discounted)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:stewer
end
AddComponentPostInit("stewer", function(self)
    local _StartCooking = self.StartCooking
    self.StartCooking = function(self, doer, ...)
        iva_cooking_doer = doer
        local ok, a, b, c = GLOBAL.pcall(_StartCooking, self, doer, ...)
        iva_cooking_doer = nil
        if not ok then
            GLOBAL.error(a, 0)
        end
        return a, b, c
    end
end)

```



### 变体演进：Нинель — Цветущая душа (Mod 3824556895)
- **变体场景与切面**：收录来自工坊 Mod 3824556895 (`Нинель — Цветущая душа`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3824556895)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Flowery (DELTARUNE) (Mod 3820792693)
- **变体场景与切面**：收录来自工坊 Mod 3820792693 (`Flowery (DELTARUNE)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820792693)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit("playercontroller", function(self)
    local _OnControl = self.OnControl
    self.OnControl = function(pc, control, down, ...)
        local p = pc.inst
        if p.flw_role ~= nil and p.flw_role:value() ~= 0 then
            if control >= CONTROL_INV_1 and control <= CONTROL_INV_10 then return end
        end
        return _OnControl(pc, control, down, ...)
    end
end)

```



### 变体演进：饥荒懒人 (Mod 3822079448)
- **变体场景与切面**：收录来自工坊 Mod 3822079448 (`饥荒懒人`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3822079448)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit("playercontroller", function(self)
    local _OnLeftClick = self.OnLeftClick
    if _OnLeftClick == nil then
        return
    end
    self.OnLeftClick = function(self, down, ...)
        if down
            and self.placer_recipe ~= nil
            and LAZY_SKIP_BUSY_PLACERS[self.placer_recipe.name]
            and self.placer ~= nil
            and self.placer.components.placer ~= nil
            and self.placer.components.placer.can_build
            and self.inst.replica.builder ~= nil
            and self.inst.replica.builder:IsBusy() then
            -- 照抄原版 :4705-4712 那一小段，只去掉 IsBusy 这一条 ✓
            local placer = self.placer.components.placer
            self.inst.replica.builder:MakeRecipeAtPoint(
                self.placer_recipe,
                placer.override_build_point_fn ~= nil
                    and placer.override_build_point_fn(self.placer)
                    or self.placer:GetPosition(),
                self.placer:GetRotation(),
                self.placer_recipe_skin)
            self:CancelPlacement()
            return
        end
        return _OnLeftClick(self, down, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory
    --   ⚠ 用**点调用**包装方法 ⇒ 第一个参数要显式带上 inv（也就是 self）✗ 别写成冒号 ✗
    AddComponentPostInit("inventory", function(self)
        local old_dropitem = self.DropItem
        self.DropItem = function(inv, item, wholestack, randomdir, pos, keepoverstacked)
            if item ~= nil and item:IsValid() and item:HasTag("lazy_nodrop") then
                local stamped = item._lazy_allowdrop
                if stamped == nil or GetTime() - stamped > GLOBAL.LAZY_DROP_GRACE then
                    -- ★ 外力 ⇒ 拦下，武器一点都不动 ✓
                    return
                end
                item._lazy_allowdrop = nil      -- 用掉就清 ✓
            end
            return old_dropitem(inv, item, wholestack, randomdir, pos, keepoverstacked)
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson
--          ⇒ 这一下动画早开播了 ⇒ 用的是上一个工具 ✗
--   真因②：改用 `AddStategraphPostInit("wilson")` hook 状态 onenter —— **挂不上** ✗✗✗
--          用户玩的是**自定义角色**（xd_gyfy），它有自己的 stategraph ✗
--          ⇒ 日志实锤：打印了"命中 0/4"（hook 从没被调用 ✗）
--
--   ✓ 最终方案：用 **`newstate` 事件**（stategraph.lua:594 推的 ✓ **跟角色无关** ✓）
--      顺序：onenter（播动画）→ PushEvent("newstate") ⇒ 只差 1 帧 ✓ 肉眼看不出 ✓
--      data.statename = 状态名（就是 chop / mine / dig / hammer ✓）
-- ==========================================================
do
    local MT_STATE_TOOL = {
        -- ★ 第 9 版：自己的美术 + 多帧结构（4 帧 / length=400 ✓）
        chop = "swap_lazy_mt_axe",
        mine = "swap_lazy_mt_pick",
        dig = "swap_lazy_mt_shovel",
        hammer = "swap_lazy_mt_hammer",
    }
    -- ★★★ 2026/10/05 再往前一步：**动作一被下发就切**（修"准备动作看不到工具" ✗）
    --   用户实测："采集时一开始那个准备动作看不到工具" ✗
    --   真因：`chop` 状态的 onenter **直接播 chop_loop**（SGwilson.lua:4936 ✓）
    --         而 newstate 事件在 onenter **之后** ⇒ 动画第 0 帧已经用旧符号渲染了 ✗
    --   ⇒ 改 hook `PlayerController:DoAction`：这是**玩家动作下发的最早时机** ✓
    --     比 stategraph 早 ⇒ 动画一开播符号就已经对了 ✓
    --   （newstate 那套保留 ✓ 用于"回到非采集状态时收掉工具" ✓）
    do
        local ACTION_TOOL = {
            [ACTIONS.CHOP] = "swap_lazy_mt_axe",
            [ACTIONS.MINE] = "swap_lazy_mt_pick",
            [ACTIONS.DIG] = "swap_lazy_mt_shovel",
            [ACTIONS.HAMMER] = "swap_lazy_mt_hammer",
        }
        local function EquipToolNow(doer, action)
            local build = action ~= nil and ACTION_TOOL[action] or nil
            if build == nil or doer == nil or not doer:IsValid() then
                return
            end
            local inv = doer.components ~= nil and doer.components.inventory or nil
            local item = inv ~= nil and inv:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
            if item == nil or item.prefab ~= "lazy_multitool" then
                return                  -- 手里不是匣子 ⇒ 不管 ✓
            end
            pcall(function()
                doer.AnimState:OverrideSymbol("swap_object", build, build)
                doer.AnimState:Show("ARM_carry")
                doer.AnimState:Hide("ARM_normal")
            end)
        end

        AddComponentPostInit("playercontroller", function(self)
            local old_doaction = self.DoAction
            if type(old_doaction) ~= "function" then
                return
            end
            self.DoAction = function(pc, buffaction, ...)
                pcall(function()
                    EquipToolNow(pc.inst, buffaction ~= nil and buffaction.action or nil)
                end)
                return old_doaction(pc, buffaction, ...)
            end
        end)
        print("[饥荒懒人][MT] 已挂 DoAction 提前切换 ✓（准备动作也能看到工具 ✓）")
    end

    -- ★★★ 2026/10/05 再往前一步：**跟着鼠标指向预判**（修"准备动作看不到工具" ✗）
    --   用户实测：右键砍树时，"准备动作"那一下还是空的 ✗
    --   真因：`DoAction` 虽然早于 stategraph，但动画第一帧仍可能抢在符号刷新之前 ✗
    --   ⇒ 用 `pc.RMBaction`：它是**每帧根据鼠标指向算出来的**（playercontroller.lua:2827 ✓）
    --     ⇒ **鼠标一指到树上，动作就已经知道了** ⇒ 根本不用等右键 ✓✓
    --   ⚠ 只在**客户端**跑（RMBaction 是客户端算的 ✓ 本地切换立即生效 ✓）
    --     服务端那两道（DoAction / newstate）保留 ⇒ 联机时队友那边也对 ✓
    do
        local ACTION_TOOL = {
            [ACTIONS.CHOP] = "swap_lazy_mt_axe",
            [ACTIONS.MINE] = "swap_lazy_mt_pick",
            [ACTIONS.DIG] = "swap_lazy_mt_shovel",
            [ACTIONS.HAMMER] = "swap_lazy_mt_hammer",
        }
        AddPlayerPostInit(function(player)
            if TheWorld ~= nil and TheWorld.ismastersim then
                return                  -- 服务端走 DoAction 那道 ✓
            end
            player:DoPeriodicTask(0.1, function(inst)
                pcall(function()
                    local pc = inst.components ~= nil and inst.components.playercontroller or nil
                    local inv = inst.components ~= nil and inst.components.inventory or nil
                    if pc == nil or inv == nil then
                        return
                    end
                    local item = inv:GetEquippedItem(EQUIPSLOTS.HANDS)
                    if item == nil or item.prefab ~= "lazy_multitool" then
                        return
                    end
                    local act = pc.RMBaction
                    local build = act ~= nil and act.action ~= nil and ACTION_TOOL[act.action] or nil
                    if build ~= nil then
                        inst.AnimState:OverrideSymbol("swap_object", build, build)
                        inst.AnimState:Show("ARM_carry")
                        inst.AnimState:Hide("ARM_normal")
                    end
                end)
            end)
        end)
        print("[饥荒懒人][MT] 客户端鼠标预判已挂 ✓（指向就出工具 ✓ 比右键更早 ✓）")
    end

    -- ★ 第二道：newstate —— 非采集状态时**收掉工具**（回到空手 ✓）
    AddPlayerPostInit(function(player)
        player:ListenForEvent("newstate", function(inst, data)
            local sname = data ~= nil and data.statename or nil
            local build = sname ~= nil and MT_STATE_TOOL[sname] or nil
            pcall(function()
                local inv = inst.components ~= nil and inst.components.inventory or nil
                local item = inv ~= nil and inv:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
                if item == nil or item.prefab ~= "lazy_multitool" then
                    return                  -- 手里不是匣子 ⇒ 一点都不管 ✓
                end
                if build ~= nil then
                    -- ★ 采集状态 ⇒ **立即调出对应工具** ✓（用户要的 ✓）
                    inst.AnimState:OverrideSymbol("swap_object", build, build)
                    inst.AnimState:Show("ARM_carry")
                    inst.AnimState:Hide("ARM_normal")
                else
                    -- ★ 其他状态 ⇒ **手空** ✓（用户要的"像啥也没拿"✓ 走路不摆持物姿势 ✓）
                    inst.AnimState:ClearOverrideSymbol("swap_object")
                    inst.AnimState:Hide("ARM_carry")
                    inst.AnimState:Show("ARM_normal")
                end
            end)
        end)
    end)
    print("[饥荒懒人][MT] 采集切换已改走 newstate 事件 ✓（角色无关 ✓ 采集才拿工具 ✓ 平时手空 ✓）")
end

-- ==========================================================
-- ★ 2026/10/05 虚空背包（30 格背部容器 ✓）
--   预制体在 scripts/prefabs/lazy_voidbag.lua ✓（结构照原版 backpack.lua ✓）
--   30 个格位的坐标 = 底图上画好的 30 个格子（实测反查出来的 ✓ 见下）
-- ==========================================================

-- ---- ① UI 贴图必须挂在 modmain 的 Assets 上（HUD 一直要用 ✓）----
--   ⚠ 这两个 tex/xml 由 autocompiler 从 png 生成 ⇒ 别手改 xml ✗
table.insert(Assets, Asset("IMAGE", "images/voidbag_ui.tex"))
table.insert(Assets, Asset("ATLAS", "images/voidbag_ui.xml"))
table.insert(Assets, Asset("IMAGE", "images/voidbag_slot.tex"))
table.insert(Assets, Asset("ATLAS", "images/voidbag_slot.xml"))

-- ---- ② 30 格布局 ----
--   坐标怎么来的（可复现 ✓）：
--     在用户原图 背包ui.png（1024×1024）里，用 格子ui.png（105×103）当模板做全图匹配，
--     反查出一张 **5 列 × 6 行 = 30 格** 的规则网格：
--        第 1 格左上角 (256, 284)，列距 102，行距 101，格子 105×103
--     底图整体 ×0.5996（1024 ⇒ 614）⇒ 所有量一起乘 0.5996
--     614×614 的图在 widget 里居中于原点 ⇒ 再减 307
--     最终：格心 X = 0.5996 × (256 + 102i + 52.5) − 307 = −122.02 + 61.160 × i
--           格心 Y = 307 − 0.5996 × (284 + 101j + 51.5) =  105.83 − 60.561 × j
local LAZY_VB_UI_OK = false
do
    local ok, err = pcall(function()
        local containers = require("containers")
        if containers == nil or containers.params == nil then
            error("containers.params 拿不到")
        end

        local VB_COLS, VB_ROWS = 5, 6
        local VB_X0, VB_Y0   = -122.02, 105.83
        local VB_DX, VB_DY   = 61.160, -60.561

        local params =
        {
            widget =
            {
                slotpos = {},
                slotbg  = {},          -- 每一格自己的底图（格子ui.png × 0.6 ✓）
                bgimage = "voidbag_ui.tex",
                bgatlas = "images/voidbag_ui.xml",
                -- 放屏幕左侧，避开底部物品栏和人物 ✓
                pos = Vector3(-340, 0, 0),

                -- ★★★ 2026/10/05 整体放大：containerwidget.lua:11 写死 0.6 ✗
                --   0.6 那版用户实测「有点小，物品放进去也有点小」✗
                --   1.0 那版用户实测「可以，就是 ui 真可以稍微小点」⇒ 落到 0.85 ✓
                --   这里让底下的 hook 把**这一块**面板的 widget 缩放改成这个数 ✓
                --   （0.85 ⇒ 底图 614→522、每格 63→53.6、里面的物品图标 64→54.4 ✓）
                --   改这一个数就能整体调大小 ✓ **不用重编译素材** ✓
                lazy_widget_scale = 0.85,
            },
            issidewidget = true,       -- 和原版背包一样挂侧面 ✓
            -- ★★★ 2026/10/06【type 改回 "pack"】✗
            --   试过改成 side_inv（想让九格放行、走原版侧面板 ✓）⇒ **实测没效果** ✗
            --   用户："还是没 ui" ✓ ⇒ 说明不是这一项决定的 ⇒ **改回来** ✗
            --   （保持和"身上/物品栏里能开"那两种情况完全一致 ✓ 那两种是好的 ✓）
            type = "pack",             -- 占"背包"这一个窗口位（同时只开一个 ✓）
            openlimit = 1,
        }

        for row = 0, VB_ROWS - 1 do
            for col = 0, VB_COLS - 1 do
                table.insert(params.widget.slotpos,
                    Vector3(VB_X0 + col * VB_DX, VB_Y0 + row * VB_DY, 0))
                table.insert(params.widget.slotbg,
                    { atlas = "images/voidbag_slot.xml", image = "voidbag_slot.tex" })
            end
        end

        containers.params.lazy_voidbag = params
        -- ★ 原版在 containers.lua 末尾按已有容器算好格子池上限；
        --   模组后注册必须自己抬高，否则 container_classified 池子不够 ⇒ 报错禁用模组 ✗
        containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS,
            #params.widget.slotpos, VB_COLS * VB_ROWS)

        LAZY_VB_UI_OK = true
    end)
    if LAZY_VB_UI_OK then
        print("[饥荒懒人][VB] 虚空背包 30 格布局已注册 ✓（5 列 × 6 行 ✓ 已对齐底图格子 ✓）")
    else
        print("[饥荒懒人][VB] ✗ 布局注册失败：" .. tostring(err))
    end
end

-- ---- ②b 让"虚空背包"这块面板能整体放大 ----
--   原版 containerwidget.lua:11 在构造里写死 `local scale = .6` ✗
--   ⇒ 模组的容器想放大只能**在 Open 之后自己重设** ✓
--   Open 是每次开面板都走的 ✓（而且它开头会先 self:Close()，Close 不动缩放 ✓）
--   ⇒ 这样"每次打开都按我们的数来" ✓，别人的容器照旧 0.6 ✓
--   ★★ 2026/10/06【日志措辞修正】✗
--     原来这里在**服务端**也打了「✗ 缩放接管失败（不影响别的功能）：nil」✗
--     而那其实是**故意的**：服务端进程没有 UI ⇒ 这段本来就该跳过 ✓
--     用户看到那行会以为坏了 ✗（而且排查联机问题时会被它带偏 ✗）
--     ⇒ 现在分开报：「服务端无 UI ⇒ 跳过（正常 ✓）」
--     ★ 铁证：客户端日志里是「面板缩放已接管 ✓」✓ 服务端才是"跳过" ✓
local LAZY_VB_SCALE_OK = false
local LAZY_VB_SCALE_SKIP = false
do
    local ok, err = pcall(function()
        -- 专用服务器 / 服务端进程上没有 UI ⇒ 别碰 widget ✗（这是正常跳过 ✓ 不是失败 ✗）
        if TheNet ~= nil and TheNet.IsDedicated ~= nil and TheNet:IsDedicated() then
            LAZY_VB_SCALE_SKIP = true
            return
        end
        local CW = GLOBAL.require("widgets/containerwidget")
        if CW == nil or CW.Open == nil then
            error("widgets/containerwidget 拿不到")
        end
        local _VB_Open = CW.Open
        CW.Open = function(self, container, doer)
            _VB_Open(self, container, doer)
            -- ★ 这是**全局钩子**（所有容器都会走）⇒ 里面出错会连累别人 ✗
            --   所以查缩放这段单独 pcall 兜住，查不到就退回原版的 0.6 ✓
            local ok2, s = pcall(function()
                local rep = container ~= nil and container.replica ~= nil
                    and container.replica.container or nil
                local w = rep ~= nil and rep.GetWidget ~= nil and rep:GetWidget() or nil
                return (w ~= nil and w.lazy_widget_scale) or 0.6
            end)
            if not ok2 or type(s) ~= "number" then
                s = 0.6
            end
            self:SetScale(s, s, s)
        end
        LAZY_VB_SCALE_OK = true
    end)
    if LAZY_VB_SCALE_OK then
        print("[饥荒懒人][VB] 面板缩放已接管 ✓（虚空背包 ×0.85 ✓ 其他容器照旧 ×0.6 ✓）")
    elseif LAZY_VB_SCALE_SKIP then
        print("[饥荒懒人][VB] 面板缩放：服务端无 UI ⇒ 跳过（正常 ✓ 客户端那边会装 ✓）")
    else
        print("[饥荒懒人][VB] ✗ 缩放接管**真失败**了（不影响别的功能）：" .. tostring(err))
    end
end

-- ==========================================================
-- ★ 2026/10/05 虚空背包：**右键长按面板空白处 = 拖动**（位置记住 ✓）
--
--   整套照搬用户自己「鬼域空间」那套
--   （神秘复苏 smfs_shenmifusu\smfs_yj_domain_ui.lua ✓ 已经实机验证过 ✓）
--
--   四个要点（都是踩过的坑 ✓ 别自作聪明改 ✗）：
--     ① 位置用 TheSim:SetPersistentString 存 ⇒ 关游戏再进也记得 ✓
--     ② 鼠标停在**格子**上时不拖 ⇒ 交给格子自己处理 ✓
--          判断用**格子的 focus**（引擎给的悬停焦点 ✓）
--          **绝不去读格子的坐标** ✗ 别的模组会换掉格子控件 ⇒ 读 transform 会 nil ✗
--     ③ 拖动期间 player.HUD:SetModFocus(...) ⇒ 右键不会顺手放出技能/动作 ✓
--     ④ 右键按下时若在面板空白处 ⇒ 就地开拖 ✓ 并 return true 把这次右键吃掉 ✓
--          （不然它会穿到世界里去 ✗）
--
--   我们面板的空白边够用 ✓（614 本地尺寸里，格子阵只占中间 308×365：
--     左右各留 153、上留 170、下留 79 ⇒ 乘缩放 0.85 后屏上左右各 130 像素 ✓ 好抓 ✓）
-- ==========================================================
-- ★ strict 声明：控制台命令 c_lazyvbpos（下面 pcall 里才真正赋值 ✓）
--   ⚠ 不先声明就会报 `assign to undeclared variable 'c_lazyvbpos'` ✗
--     ⇒ 整个 pcall 中断 ⇒ 后面的 CW.OnControl 右键拖动**装不上** ✗
--     （2026/10/18 根因：日志里"右键拖动接管真失败了"就是这一行 ✓）
GLOBAL.c_lazyvbpos = nil

local LAZY_VB_DRAG_OK = false
local LAZY_VB_DRAG_SKIP = false
do
    local ok, err = pcall(function()
        -- ★ 同样是"服务端无 UI ⇒ 正常跳过" ✓ 不是失败 ✗（理由见上面缩放那段 ✓）
        if TheNet ~= nil and TheNet.IsDedicated ~= nil and TheNet:IsDedicated() then
            LAZY_VB_DRAG_SKIP = true
            return
        end
        local TheInput = GLOBAL.TheInput
        local TheSim = GLOBAL.TheSim
        local CW = GLOBAL.require("widgets/containerwidget")
        if CW == nil or CW.OnControl == nil then
            error("widgets/containerwidget 拿不到")
        end

        local DRAG_PREFAB = "lazy_voidbag"
        local SAVE_KEY = "lazy_voidbag_ui_pos"
        local PANEL_W, PANEL_H = 614, 614      -- 贴图本体的**本地**尺寸（没乘缩放 ✓）

        local saved_pos = nil
        local drag_widget = nil
        local drag_from = nil

        local function VB_Safe(fn, ...)
            local ok2, err2 = pcall(fn, ...)
            if not ok2 then
                print("[饥荒懒人][VB] 拖动出错（已拦下 ✓）: " .. tostring(err2))
            end
            return ok2
        end

        -- ① 读回上次的位置（异步 ⇒ 进游戏时就读完了 ✓）
        if TheSim ~= nil and TheSim.GetPersistentString ~= nil then
            TheSim:GetPersistentString(SAVE_KEY, function(success, data)
                if success and data ~= nil and #data > 0 then
                    local xs, ys = string.match(data, "^(-?%d+%.?%d*),(-?%d+%.?%d*)$")
                    if xs ~= nil and ys ~= nil then
                        saved_pos = { tonumber(xs), tonumber(ys) }
                        print("[饥荒懒人][VB] 已读回上次的面板位置：" .. tostring(data))
                    end
                end
            end)
        end

        local function GetScaleOf(widget)
            if widget == nil then return 1, 1 end
            local ok2, s = pcall(function() return widget:GetWorldScale() end)
            if ok2 and s ~= nil and s.x ~= nil and s.y ~= nil and s.x ~= 0 and s.y ~= 0 then
                return s.x, s.y
            end
            return 1, 1
        end

        -- ★★★ 2026/10/18【位置改成"相对默认位置的偏移"】✗✗✗
        --   原来存的是**绝对坐标**：10/6 存了 527.3,-11.6 ⇒ 换屏幕/HUD 后直接飞到屏幕外 ✗
        --   ⇒ 现在只存"相对 containers.params 里 pos(-340,0) 的偏移" ✓
        --     偏移还夹在 ±200 / ±150 内 ⇒ 永远贴着默认那块地方，不会再丢 ✓
        local function GetDefaultPos(container)
            local ok2, px, py = pcall(function()
                local w = container ~= nil and container.replica ~= nil
                    and container.replica.container ~= nil
                    and container.replica.container:GetWidget() or nil
                local pos = w ~= nil and w.pos or nil
                return (pos ~= nil and pos.x or -340), (pos ~= nil and pos.y or 0)
            end)
            if ok2 and px ~= nil then return px, py end
            return -340, 0
        end

        -- ★★★ 2026/10/18【别猜单位了：用 world 坐标现场标定】✓✓✓
        --   实测：local=-1091 时 world=878 ⇒ local→world 有缩放+偏移，
        --   之前按 local 硬算边界，怎么改都对不上 ✗
        --   ⇒ 打开时标定一次：local 走 100，看 world 走多少 ⇒ 得到 k 和偏移 ✓
        local function Calibrate(widget)
            local ok2 = pcall(function()
                local p0 = widget:GetPosition()
                local w0 = widget:GetWorldPosition()
                widget:SetPosition(p0.x + 100, p0.y, 0)
                local w1 = widget:GetWorldPosition()
                widget:SetPosition(p0.x, p0.y + 100, 0)
                local w2 = widget:GetWorldPosition()
                widget:SetPosition(p0.x, p0.y, 0)
                local kx = (w1.x - w0.x) / 100
                local ky = (w2.y - w0.y) / 100
                if kx == 0 then kx = 1 end
                if ky == 0 then ky = 1 end
                widget.lazy_vb_kx, widget.lazy_vb_ky = kx, ky
                widget.lazy_vb_cx = w0.x - kx * p0.x
                widget.lazy_vb_cy = w0.y - ky * p0.y
            end)
            return ok2
        end

        -- 把面板的 world 位置夹进屏幕（world 是屏幕像素，左上角原点 ✓）
        --   面板屏幕尺寸 = 522 × k（local 522 → world 522*k）
        local function ClampToScreen(widget, x, y)
            local kx = widget.lazy_vb_kx or 1
            local ky = widget.lazy_vb_ky or 1
            local cx = widget.lazy_vb_cx or 0
            local cy = widget.lazy_vb_cy or 0
            local sw, sh = 2560, 1600
            pcall(function()
                local w, h = TheSim:GetScreenSize()
                if w ~= nil and w > 0 and h ~= nil and h > 0 then sw, sh = w, h end
            end)
            local pw = PANEL_W * 0.85 * kx       -- 面板在屏幕上的实际宽（像素）
            local ph = PANEL_W * 0.85 * ky
            local m = 40
            local wx = math.max(m, math.min(sw - pw - m, kx * x + cx))
            local wy = math.max(m, math.min(sh - ph - m, ky * y + cy))
            return (wx - cx) / kx, (wy - cy) / ky
        end

        local function SavePos(widget)
            if TheSim == nil or TheSim.SetPersistentString == nil then return end
            local p = widget:GetPosition()
            local bx = widget.lazy_vb_defx or -340
            local by = widget.lazy_vb_defy or 0
            -- 原样存（拖动时不夹边 ✓）；打开时若跑出屏幕会自动回默认 ✓
            local dx, dy = p.x - bx, p.y - by
            saved_pos = { dx, dy }
            TheSim:SetPersistentString(SAVE_KEY, string.format("%.1f,%.1f", dx, dy), false)
            print(string.format("[饥荒懒人][VB] 面板偏移已记住 ✓（相对默认 %+.1f,%+.1f）", dx, dy))
        end

        -- ② 鼠标是不是停在某个格子上 ⇒ 是就不拖 ✓
        local function IsOverSlotWidget(widget)
            if widget.inv == nil then return false end
            for _, slot in pairs(widget.inv) do
                if slot ~= nil and slot.focus then return true end
            end
            return false
        end

        -- ③ 拖动期间屏蔽角色操作（不然右键会顺手放技能 ✗）
        local function SetDragFocus(on)
            local player = GLOBAL.ThePlayer
            if player ~= nil and player.HUD ~= nil and player.HUD.SetModFocus ~= nil then
                player.HUD:SetModFocus("dst_lazy", "lazy_vb_drag", on)
            end
        end

        local function StopDrag(save)
            local w = drag_widget
            drag_widget = nil
            drag_from = nil
            SetDragFocus(false)
            if save and w ~= nil and w.inst ~= nil and w.inst:IsValid() then
                -- ★ 2026/10/18 诊断：拖完打一行，用真实坐标反推"锚点在哪、单位怎么换" ✓
                --   ⚠ GetSize 在 ContainerWidget 上可能没有 ⇒ 单独 pcall，别把整行吞了 ✗
                pcall(function()
                    local p = w:GetPosition()
                    local wp = w:GetWorldPosition()
                    local sw, sh = TheSim:GetScreenSize()
                    print(string.format(
                        "[VB-POS] local=%.0f,%.0f world=%.0f,%.0f screen=%.0fx%.0f k=%.3f,%.3f c=%.0f,%.0f",
                        p.x, p.y, wp.x, wp.y, sw, sh,
                        w.lazy_vb_kx or -1, w.lazy_vb_ky or -1,
                        w.lazy_vb_cx or 0, w.lazy_vb_cy or 0))
                end)
                SavePos(w)
            end
        end

        local function StartDrag(widget)
            if drag_widget == widget then return end
            local mp = TheInput:GetScreenPosition()
            local p = widget:GetPosition()
            drag_widget = widget
            drag_from = { mx = mp.x, my = mp.y, px = p.x, py = p.y }
            SetDragFocus(true)
        end

        -- 鼠标是否在面板范围内（位移用父控件的缩放换算 ✓ HUD 一般是 1 ✓）
        local function IsInPanel(widget, x, y)
            local ok2, wp = pcall(function() return widget:GetWorldPosition() end)
            if not ok2 or wp == nil then return false end
            local sx, sy = GetScaleOf(widget)
            return math.abs((x - wp.x) / sx) <= PANEL_W * 0.5
               and math.abs((y - wp.y) / sy) <= PANEL_H * 0.5
        end

        local function FindDragTarget(x, y)
            local player = GLOBAL.ThePlayer
            local hud = player ~= nil and player.HUD or nil
            local containers = hud ~= nil and hud.controls ~= nil
                and hud.controls.containers or nil
            if containers == nil then return nil end
            for c, w in pairs(containers) do
                if w ~= nil and w.isopen and w.lazy_vb_drag
                    and c ~= nil and c.prefab == DRAG_PREFAB
                    and IsInPanel(w, x, y) and not IsOverSlotWidget(w) then
                    return w
                end
            end
            return nil
        end

        local function OnMove(x, y)
            local w = drag_widget
            if w == nil then return end
            if w.inst == nil or not w.inst:IsValid() then
                StopDrag(false)
                return
            end
            local sx, sy = GetScaleOf(w.parent)
            -- ★ 2026/10/18【拖动时不再夹边】✗
            --   实测 k=1.542 / c=2560,800 —— local↔屏幕像素的关系太绕，
            --   硬夹只会出现"右边/上面到不了" ✗
            --   ⇒ 拖动范围 = 全屏随便拖 ✓
            --   ⇒ 防丢：打开时检查 world 是否跑出屏幕，跑出去就自动回默认 ✓
            local kx = w.lazy_vb_kx or sx
            local ky = w.lazy_vb_ky or sy
            w:SetPosition(drag_from.px + (x - drag_from.mx) / kx,
                drag_from.py + (y - drag_from.my) / ky, 0)
        end

        TheInput:AddMoveHandler(function(x, y) VB_Safe(OnMove, x, y) end)
        TheInput:AddMouseButtonHandler(function(button, down, x, y)
            if button ~= GLOBAL.MOUSEBUTTON_RIGHT then return end
            if down then
                VB_Safe(function()
                    if drag_widget == nil then
                        local w = FindDragTarget(x, y)
                        if w ~= nil then StartDrag(w) end
                    end
                end)
            else
                VB_Safe(StopDrag, true)
            end
        end)

        -- ==========================================================
        -- ★★★ 2026/10/07【把记住的位置**夹进屏幕里**】✗✗✗
        --   用户问：「看看我背包的 ui 是不是在屏幕外？」
        --   日志实锤：记住的位置是 **527.3,-11.6**（2560×1600 屏 ✓ 数出来是能看见的 ✓）
        --   但**换个分辨率 / 窗口化 / 改过 HUD 大小**之后，这个老位置就可能整块飘到屏幕外 ✗
        --     ⇒ 而它又是**存在磁盘上的**（lazy_voidbag_ui_pos ✓）⇒ 会一直错下去 ✗
        --   ⇒ 保险做法：套用之前先**夹**一下 ✓ 永远留半块在屏幕里 ✓
        --   ★ 坐标换算（和拖动那段用的是同一套 ✓ 不是猜的 ✓）：
        --       这个 widget 的坐标单位 = **像素 ÷ HUDScale** ✓
        --       （证据：拖动时鼠标位移要 ÷ GetWorldScale() ✓ 见 OnMove ✓）
        --       面板在 HUD 单位下的尺寸 = 614 × 0.6 × 0.85 ≈ 313 ✓（HUDScale 在两边抵消 ✓）
        -- ==========================================================
        local PANEL_HUD_W = PANEL_W * 0.6 * 0.85      -- ≈ 313（HUD 单位 ✓）
        local function ClampPos(widget, x, y)
            local ok2, cx, cy = pcall(function()
                local sx, sy = GetScaleOf(widget)
                local sw, sh = 1280 * sx, 720 * sy   -- 兜底：按 1280×720 虚拟屏算 ✓
                pcall(function()
                    local w, h = TheSim:GetScreenSize()
                    if w ~= nil and w > 0 and h ~= nil and h > 0 then
                        sw, sh = w, h
                    end
                end)
                local halfw = (sw / 2) / sx
                local halfh = (sh / 2) / sy
                local mx = math.max(0, halfw - PANEL_HUD_W / 2 - 10)
                local my = math.max(0, halfh - PANEL_HUD_W / 2 - 10)
                local nx = math.max(-mx, math.min(mx, x or 0))
                local ny = math.max(-my, math.min(my, y or 0))
                return nx, ny
            end)
            if ok2 and cx ~= nil then
                if math.abs((x or 0) - cx) > 1 or math.abs((y or 0) - cy) > 1 then
                    print("[饥荒懒人][VB] 记住的面板位置超出屏幕 ⇒ 已夹回来 ✓（"
                        .. string.format("%.0f,%.0f", x or 0, y or 0) .. " → "
                        .. string.format("%.0f,%.0f", cx, cy) .. "）")
                end
                return cx, cy
            end
            return x or 0, y or 0
        end

        -- ★ 万一还是找不着：控制台敲 `c_lazyvbpos()` ⇒ 回屏幕正中 ✓ 并记住 ✓
        GLOBAL.c_lazyvbpos = function()
            saved_pos = { 0, 0 }
            if TheSim ~= nil and TheSim.SetPersistentString ~= nil then
                TheSim:SetPersistentString(SAVE_KEY, "0.0,0.0", false)
            end
            local hud = GLOBAL.ThePlayer ~= nil and GLOBAL.ThePlayer.HUD or nil
            if hud ~= nil and hud.controls ~= nil then
                for _, w in pairs(hud.controls.children or {}) do
                    if w ~= nil and w.lazy_vb_drag then
                        -- ★ 回**默认位置**（不是 (0,0)：美术不是正中，写 0 会一半在屏外 ✗）
                        w:SetPosition(w.lazy_vb_defx or -340, w.lazy_vb_defy or 0, 0)
                    end
                end
            end
            print("[饥荒懒人][VB] 面板位置已重置到默认位置 ✓（重开一次面板就生效 ✓）")
        end

        -- 面板一开 ⇒ 打标记 + 套用记住的位置 ✓
        local _VB2_Open = CW.Open
        CW.Open = function(self, container, doer)
            _VB2_Open(self, container, doer)
            if container ~= nil and container.prefab == DRAG_PREFAB then
                VB_Safe(function()
                    self.lazy_vb_drag = true
                    -- ★★★ 2026/10/18【位置 = 默认 pos + 记住的偏移】✓
                    --   默认 pos 在 containers.params 里是 (-340, 0)（避开物品栏 ✓）
                    --   Open 自己已经套过默认值 ⇒ 这里只加偏移 ✓
                    --   ⚠ 千万别写死 (0,0)：面板美术不是正中对齐的 ⇒ 会有一半在屏幕外 ✗
                    local bx, by = GetDefaultPos(container)
                    self.lazy_vb_defx, self.lazy_vb_defy = bx, by
                    -- ★ 先标定 local→world 的换算（拖动/夹边都靠它 ✓）

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:container
-- ==========================================================
AddComponentPostInit("container", function(self)
    if self.inst == nil or self.inst.prefab ~= "lazy_voidbag" then
        return
    end
    local _VB_Open = self.Open
    if _VB_Open ~= nil then
        self.Open = function(c, doer)
            print("[饥荒懒人][VB][诊断] 服务端收到「开」请求 ✓（谁="
                .. tostring(doer ~= nil and doer.prefab or "nil") .. "）")
            local r = _VB_Open(c, doer)
            print("[饥荒懒人][VB][诊断] 开完 ⇒ opencount=" .. tostring(c.opencount)
                .. " / openlist 人数=" .. tostring((function()
                    local n = 0
                    pcall(function() for _ in pairs(c.openlist) do n = n + 1 end end)
                    return n
                end)()))
            return r
        end
    end
    local _VB_Close = self.Close
    if _VB_Close ~= nil then
        self.Close = function(c, doer)
            print("[饥荒懒人][VB][诊断] 服务端收到「关」请求 ✓")
            return _VB_Close(c, doer)
        end
    end
end)

-- ==========================================================
-- ★★★ 2026/10/07 虚空背包：**记住玩家关没关面板** ✓（用户点名要的 ✓）
--   用户原话：「装备背包关闭 ui 了，然后每次死了复活都会自动打开背包，这个设定不要，
--              记住玩家的选择，我关闭了除非我在开不然不自动打开」
--
--   ★ 为什么钩 **ACTIONS.RUMMAGE.fn** 而不是 Container:Close ✗（这条最关键 ✗）
--     Close 会被一堆**非玩家意愿**的路径调到：卸下 / 死亡 / 换人 / 远距离自动关…
--     钩在那里 ⇒ 只要自动关过一次，就永远不再自动开了 ✗ 比原来还糟 ✗
--     RUMMAGE.fn 才是**玩家右键那一条路**：
--       actions.lua:1084  开着 → Close / 关着 → Open（本身就是开/关切换 ✓）
--     ⇒ 只有玩家自己右键，才算"他的选择" ✓
--   ★ 标记存在背包实体身上（_lazy_vb_user_closed）⇒ 死亡复活后同一只包 ⇒ 记得住 ✓
-- ==========================================================
do
    local ok, err = pcall(function()
        local _VB_RUMMAGE = ACTIONS.RUMMAGE.fn
        if _VB_RUMMAGE == nil then
            error("ACTIONS.RUMMAGE.fn 拿不到")
        end
        ACTIONS.RUMMAGE.fn = function(act)
            local targ = act ~= nil and act.target or nil
            local doer = act ~= nil and act.doer or nil
            local isvb = (targ ~= nil and targ.prefab == "lazy_voidbag")
            local wasopen = false
            if isvb and doer ~= nil and targ.components ~= nil and targ.components.container ~= nil then
                local okq, v = pcall(function()
                    return targ.components.container:IsOpenedBy(doer)
                end)
                wasopen = (okq and v == true)
            end
            local r = _VB_RUMMAGE(act)
            if isvb and targ:IsValid() then
                -- 开着被点 ⇒ 是玩家自己关的 ⇒ 记住"以后别再自动开" ✓
                -- 关着被点 ⇒ 是玩家自己开的 ⇒ 取消那个偏好 ✓
                targ._lazy_vb_user_closed = wasopen
                print("[饥荒懒人][VB] 玩家右键" .. (wasopen and "关闭" or "打开") .. "了面板 ⇒ "
                    .. (wasopen and "以后不再自动打开 ✓（除非他自己再开）" or "恢复自动打开 ✓"))
            end
            return r
        end
    end)
    if ok then
        print("[饥荒懒人][VB] 「记住玩家开关」已接管 ✓")
    else
        print("[饥荒懒人][VB] ✗ 「记住玩家开关」没装上（不影响别的功能 ✓）：" .. tostring(err))
    end
end

-- ==========================================================
-- ★ 2026/10/05 虚空背包：**右键开关面板** —— 走原版那条路，不自造动作 ✓
--
--   用户要求：「装备上后右键是关闭背包而不是卸下，
--              要卸下就是左键自己点了放物品栏里」✓
--   用户还提醒：「原版背包右键就是关闭背包」✓ —— 确实如此 ✓
--
--   ★ 原版这条链（查证过 ✓ 一开始我差点自己造一个动作 ✗ 幸好核了）：
--     右键装备格 ⇒ equipslot.lua:66 inventory:UseItemFromInvTile(item)
--                ⇒ inventory_classified.lua:911 GetInventoryActions(item)
--                ⇒ playeractionpicker.lua:272 useitem:CollectActions("INVENTORY", ...)
--                ⇒ componentactions.lua:2548（**INVENTORY 段**的 container 处理）
--                     if container:CanBeOpened() then ... table.insert(actions, ACTIONS.RUMMAGE)
--                ⇒ actions.lua:1084
--                     elseif targ.components.container:IsOpenedBy(act.doer) then
--                         targ.components.container:Close(act.doer)      ← 开着 ⇒ 关 ✓
--                         act.doer:PushEvent("closecontainer", {container = targ})
--                     else ... Open(act.doer)                            ← 关着 ⇒ 开 ✓
--     ⇒ **ACTIONS.RUMMAGE.fn 本身就是开/关切换** ✓ 而且它会推 closecontainer 事件 ✓
--       （自造动作漏了这个事件 ⇒ HUD 那边可能不认 ⇒ 反而出问题 ✗）
--
--   ★ 那我们唯一要做的事：**别把 CanBeOpened() 掐掉** ✓
--       预制体 lazy_voidbag.lua 里**故意不写** inst.components.container.canbeopened = false ✗
--       （鬼棺材写 false 是因为它不想让人手动开 ✗ 我们的需求正好相反 ✓）
--     ⇒ 顺带白拿一个原版行为：背包放在物品栏里（没穿）也能右键打开 ✓
--     ⇒ 控制器(手柄)下原版会主动不给侧栏这条件动作（componentactions.lua:2555 ✓）保持一致 ✓
--
--   卸下不变，还是原版那条：左键把包装到手上 ⇒ 再点物品栏格子放下 ✓
-- ==========================================================

-- ==========================================================
-- ★ 2026/10/05 物质连接器（远程链接物质转换机 ✓）
--
--   用户要的：拿着它左键点世界上的物质转换机 ⇒ 绑定
--             绑定后放物品栏里右键 ⇒ 直接开那台机器的界面（**无限距离** ✓）
--             能量、格子里的东西都同步 ✓
--
--   ★★★ 无限距离的关键（这条最容易被漏掉 ✗✗✗）
--     container.lua:1059 OnUpdate 里会**按距离**把面板关掉：
--         elseif mount or not (opener:IsValid()
--                 and opener:IsNear(self.inst, CONTAINER_AUTOCLOSE_DISTANCE) ...) then
--             self:Close(opener)          ← 走远了就关 ✗
--     而 container.lua:620 打开时是这么起定时器的：
--         if not self.skipautoclose then self.inst:StartUpdatingComponent(self) end
--     ⇒ **打开前把 skipautoclose 顶成 true** ⇒ 那个定时器压根不会起 ⇒ 距离就管不着了 ✓
--     ★ 记住原值、关干净了再还原 ✓（这台机器以后正常开的时候行为不变 ✓）
--       （用户自己「鬼域空间」也是靠 skipautoclose 做到"跟着角色永不自动关闭"的 ✓ 同一条路 ✓）
--
--   ★ 绑定信息存**坐标**（预制体里解释过为什么不是实体引用 ✓ 引用存不进存档 ✗）
-- ==========================================================
local MCLINK_BUILD = "lazy_mclink"
local MCLINK_MC    = "lazy_matter_converter"
local MCL_DEBUG    = false

-- 手上/身上的连接器：先看动作自带的对象 ✓ 再兜底查手上拿的 ✓
--   （拆除器那套也是这么兜底的 ✓ 见上面 _gm_held_remover ✓）
local function MCL_Linker(act, doer)
    local o = act ~= nil and act.invobject or nil
    if o ~= nil and o:IsValid() and o.prefab == MCLINK_BUILD then
        return o
    end
    if doer ~= nil and doer:IsValid() and doer.components.inventory ~= nil then
        local inv = doer.components.inventory
        local h = inv:GetEquippedItem(EQUIPSLOTS.HANDS)
        if h ~= nil and h:IsValid() and h.prefab == MCLINK_BUILD then
            return h
        end
        -- ★ 兜底②：动作没带对象、手上也没装备 ⇒ 把背包翻一遍 ✓
        --   （正常走不到这 ✓ 但多一层就不会出现"莫名其妙打不开"✗）
        local found = nil
        pcall(function()
            found = inv:FindItem(function(it)
                return it ~= nil and it.prefab == MCLINK_BUILD
            end)
        end)
        if found ~= nil and found:IsValid() then
            return found
        end
    end
    return nil
end

-- 找出这台连接器绑定的转换机
--   ① 活引用还在 ⇒ 直接用 ✓
--   ② 引用没了（读档了 / 跨过了存档）⇒ 按坐标 + 半径重找 ✓
local function MCL_FindConverter(linker)
    if linker == nil or not linker:IsValid() then
        return nil
    end
    local live = linker._linked_mc
    if live ~= nil and live:IsValid() then
        return live
    end
    linker._linked_mc = nil
    local x, y, z = linker._lx, linker._ly, linker._lz
    if x == nil or y == nil or z == nil then
        return nil
    end
    local ok, ents = pcall(function()
        return TheSim:FindEntities(x, y, z, 4, { "structure" })
    end)
    if not ok or ents == nil then
        return nil
    end
    for _, e in ipairs(ents) do
        if e.prefab == MCLINK_MC then
            linker._linked_mc = e
            if MCL_DEBUG then
                print("[饥荒懒人][MCL] 按坐标找回绑定的转换机 ✓（读档后走这条路 ✓）")
            end
            return e
        end
    end
    return nil
end

local function MCL_Say(doer, msg)
    if doer ~= nil and doer:IsValid() and doer.components.talker ~= nil then
        local ok = pcall(function() doer.components.talker:Say(msg) end)
        if not ok then return end
    end
end

-- ---- ①【绑定】左键点物质转换机 ----
AddAction("LAZY_MC_LINK", "绑定", function(act)
    if act == nil then return false end
    local doer = act.doer
    local mc = act.target
    local linker = MCL_Linker(act, doer)
    if linker == nil then
        print("[饥荒懒人][MCL] 绑定：✗ 手上没拿到物质连接器")
        return false
    end
    if mc == nil or not mc:IsValid() or mc.prefab ~= MCLINK_MC then
        print("[饥荒懒人][MCL] 绑定：✗ 目标不是物质转换机（"
            .. tostring(mc ~= nil and mc.prefab or "nil") .. "）")
        return false
    end
    -- 客机只举手 ✓（和放生那套一致 ✓）
    if not TheWorld.ismastersim then
        return true
    end
    local ok, err = pcall(function()
        linker._linked_mc = mc
        local x, y, z = mc.Transform:GetWorldPosition()
        linker._lx, linker._ly, linker._lz = x, y, z
        if linker._mclink_bound ~= nil then
            linker._mclink_bound:set(true)
        end
        -- ★ 把"绑的是哪台机器"同步给客户端 ✓（客机远距离要自己开面板 ✓ 见下面远程打开）
        if linker._mclink_target ~= nil then
            linker._mclink_target:set(mc)
        end
    end)
    if not ok then
        print("[饥荒懒人][MCL] 绑定：✗ 出错（已拦下 ✓）：" .. tostring(err))
        return false
    end
    MCL_Say(doer, "连上了。")
    print("[饥荒懒人][MCL] 绑定成功 ✓（放物品栏里右键就能远程开这台机器 ✓）")
    return true
end)

-- ---- ②【远程打开】物品栏里右键连接器 ----
AddAction("LAZY_MC_REMOTE_OPEN", "远程打开", function(act)
    if act == nil then return false end
    local doer = act.doer
    local linker = MCL_Linker(act, doer)
    if linker == nil then
        print("[饥荒懒人][MCL] 远程打开：✗ 没拿到连接器")
        return false
    end
    -- ★★★ 客机：远距离下**服务端管不到我们** ✗✗✗
    --   实测（master_server_log.txt）：
    --     服务端 opencount 一直是 1、面板一直开着 ✓ 可客户端什么都没显示 ✗
    --   真因：客户端是靠引擎把 container_classified / container_opener 这两个
    --         **classified 实体**送过来，才自动开面板的
    --         （container_replica.lua:49-59 ✓）
    --         **远距离下引擎不送** ⇒ 客户端永远不知道要开 ✗
    --         ★ 这就是为什么「简易储存」那个模组要自造**假容器 + 自绘 UI** 来绕开 ✗
    --   ⇒ 折中：客机自己动手开本地面板 ✓ 目标从 net_entity 拿 ✓
    --     内容能不能显示要看引擎有没有把 container_classified 送过来（下面有日志 ✓ 一看就知道 ✓）
    if not TheWorld.ismastersim then
        local okc, errc = pcall(function()
            local mc = linker._mclink_target ~= nil and linker._mclink_target:value() or nil
            if mc == nil or not mc:IsValid() then
                print("[饥荒懒人][MCL] 客机：✗ net_entity 还没同步到目标转换机")
                return
            end
            -- ★★★ 不再自己开真容器了 ✗✗✗
            --   实测：直接 ThePlayer.HUD:OpenContainer(mc) 在远距离下**一片空白** ✗
            --   因为引擎不把 container_classified 送给远处的人 ✗（网络层，改不了 ✗）
            --   ⇒ 改成举手：让服务端把「机器的样子」打包发过来 ✓（假容器方案 ✓）
            SendModRPCToServer(GetModRPC("LAZY_MCL", "request"), mc.GUID)
            print("[饥荒懒人][MCL] 客机：已请求服务端把机器的样子发过来 ✓")
        end)
        if not okc then
            print("[饥荒懒人][MCL] 客机请求出错：" .. tostring(errc))
        end
        return true
    end
    local ok, err = pcall(function()
        local mc = MCL_FindConverter(linker)
        if mc == nil then
            print("[饥荒懒人][MCL] 远程打开：✗ 找不到绑定的转换机（拆了？或者没绑过？）")
            MCL_Say(doer, "那头没东西了。")
            return
        end
        local c = mc.components.container
        if c == nil then
            print("[饥荒懒人][MCL] 远程打开：✗ 那台机器没有 container 组件")
            return
        end

        -- ★★★ 无限距离：把"走远自动关"顶掉（见本段开头 ★★★ 那段说明 ✓）
        --   ⚠⚠ 还原标记必须**独立**，不能拿原值当"改没改过"的判断依据 ✗✗✗
        --      skipautoclose 默认是 **nil** 不是 false ✗
        --      上一版写 `if c._lazy_prev_autoclose ~= nil then 还原 end`
        --      ⇒ 原值是 nil ⇒ 条件永远不成立 ⇒ **还原从来没跑过** ✗
        --      ⇒ 这台机器从此再也不自动关了 ✗（用户实测就是这个 ✗）
        if c._mcl_saved == nil then
            c._mcl_saved = true
            c._mcl_prev  = c.skipautoclose      -- 可能是 nil ✓ 原样存着 ✓
        end
        c.skipautoclose = true
        -- ★★ 远程打开期间：让 OnUpdate **整个跳过**这台机器 ✓✓✓
        --   为什么光靠 skipautoclose 不够 ✗：
        --     container.lua:620 `if not self.skipautoclose then StartUpdatingComponent()` ✓
        --     ⇒ 它只能**阻止开定时器**，管不了**已经开着**的定时器 ✗
        --     （物理开过一次就把定时器点着了；只要没关干净，它就一直在跑 ✗
        --       用户实测：物理那次开着没关 ⇒ 远程打开后走远照样被关 ✗）
        --   ⇒ 直接在下层把 OnUpdate 挡掉 ⇒ 不管定时器起没起、谁起的，都不可能按距离关 ✓
        c._mcl_remote_open = true

        -- ★★★ 2026/10/05 只有**主机**才开真容器 ✗✗✗
        --   用户实测过一个很怪的现象：
        --     「在范围外右键没反应，然后**走进范围面板自己弹出来**」✗
        --   真因就在这里：服务端对**客机**也调了 c:Open(doer) ✗
        --     ⇒ 那台机器在服务端变成"开着"状态 ✓
        --     ⇒ 客机一走进网络范围、收到 container_classified ⇒ 面板自己冒出来 ✗
        --   ⇒ 客机走的是**假容器**那条路（客户端举手 → 服务端发包 ✓）
        --     服务端**绝不能**再给它开真容器 ✗
        --   ★ doer.HUD 只有"主机自己/本地玩家"才有 ⇒ 拿它当判据最准 ✓
        if doer ~= nil and doer.HUD ~= nil then
            -- 主机：直接开真容器 ✓（同一个进程，没有任何网络问题 ✓）
            if c.openlist == nil or c.openlist[doer] == nil then
                c:Open(doer)
            end
        else
            -- ★★★ 客机：**服务端直接发包给它** ✗✗✗
            --   原来我写的是"客机自己举手发 RPC 来要" ✗ —— 那条路根本不通 ✗
            --   实锤：日志里服务端打了「客机 ⇒ 不开真容器」，可客机那边
            --         `客机：已请求服务端把机器的样子发过来` **一条都没有** ✗
            --   真因：DST 里**客机的动作 fn 压根不跑** ✗（只有服务端跑那份 ✗）
            --         INVENTORY 那条右键动作是 RemoteUseItemFromInvTile 发 RPC 上去的，
            --         执行只在服务端 ✓
            --   ⇒ 根本不用客机举手 ✗ **服务端本来就知道是谁点的** ✓ 直接发给他就行 ✓
            print("[饥荒懒人][MCL] 客机 ⇒ 不开真容器 ✓ 走假容器那条路 ✓")
            -- ★★★ 2026/10/05 右键改成**一开一关** ✗✗✗
            --   用户要的：「在物品栏再右键一下关闭，一开一关」✓
            --   为什么开关必须由**服务端**来判 ✗
            --     已经查死：客机的动作 fn 压根不跑 ✗（只有服务端那份跑 ✓）
            --     ⇒ 客机没法自己判断"现在开着没有" ⇒ 只能服务端记着 ✓
            --   ⇒ 交给 LAZY_MCL_TOGGLE 处理：开着就发关闭包、关着就发开面板包 ✓
            if GLOBAL.LAZY_MCL_TOGGLE ~= nil then
                GLOBAL.LAZY_MCL_TOGGLE(doer, mc)
            else
                print("[饥荒懒人][MCL] ✗ LAZY_MCL_TOGGLE 还没挂上（假容器模块没载入？）")
            end
        end

        -- ★ 双保险：直接把"看距离自动关"那个定时器停掉 ✓
        --   container.lua:1059 OnUpdate 就是它跑出来的；没起过就停一下也无害 ✓
        if c.opencount ~= nil and c.opencount > 0 then
            pcall(function() c.inst:StopUpdatingComponent(c) end)
        end

        -- ★★ 2026/10/05 拆掉"自动重开"兜底 ✗✗✗
        --   用户实测：加上它之后游戏崩了一次 ✗
        --   原因：它在 DoPeriodicTask 里调 c:Open(doer) ✗
        --         一旦 doer 失效（下线/读档/提前退出），
        --         就会在**定时任务里抛错** ⇒ 定时任务里抛错能把服务端直接带崩 ✗
        --   ★ 而且这个兜底本来就是"猜着补"✗
        --     真正的问题已经查清了：**客机远距离收不到容器数据**（引擎不送 ✗）
        --     那是网络层的事，重开多少次客户端都不会有内容 ✗
        --   ⇒ 改用用户指定的方案：**假容器 + 自绘/复用界面**（照 简易储存 那套 ✓）
        if MCL_DEBUG then
            print("[饥荒懒人][MCL] 远程打开 ✓ 面板已开"
                .. "（opencount=" .. tostring(c.opencount)
                .. " / skipautoclose=" .. tostring(c.skipautoclose)
                .. " / 原值=" .. tostring(c._mcl_prev) .. " ✓）")
        end
    end)
    if not ok then
        print("[饥荒懒人][MCL] 远程打开：✗ 出错（已拦下 ✓）：" .. tostring(err))
        return false
    end
    return true
end)

-- ---- ③ container 组件：远程打开期间挡住"按距离自动关" + 关干净后还原 ----
--   ★★ 判断"改过没有"用的是 **_mcl_saved** 这个独立标记 ✗✗✗
--      绝不能用"原值是不是 nil"来判断 ✗（skipautoclose 默认就是 nil ✗ 第一版就死在这 ✓）
--
--   ★★ 光设 skipautoclose **不够** ✗✗✗（用户实测：离一点点远还是被关 ✓）
--      container.lua:620 那句只能**阻止开定时器**，
--      管不了**已经开着**的定时器 —— 物理开过一次就点着了，
--      只要那次没关干净，它就一直跑，一样按距离关 ✗
--      （唯一按距离关的地方：container.lua:1079，用 CONSTANTS.CONTAINER_AUTOCLOSE_DISTANCE = 3 ✓
--        全原版只有这一处 ✓ 所以只要挡住这一处就绝对安全 ✓）
--   ⇒ 直接在 OnUpdate 上挡：远程打开期间**整个跳过**这台机器 ✓
AddComponentPostInit("container", function(self)
    -- ① 远程打开期间 ⇒ 这个定时器做什么都不做 ✓（确定性 ✓ 不依赖谁先谁后 ✓）
    local _MCL_OnUpdate = self.OnUpdate
    self.OnUpdate = function(c, dt)
        if c._mcl_remote_open then
            return
        end
        return _MCL_OnUpdate(c, dt)
    end

    -- ② 关干净了 ⇒ 还原 skipautoclose + 清标记 + 顺手把定时器停掉 ✓
    local _MCL_Close = self.Close
    self.Close = function(c, doer)
        _MCL_Close(c, doer)
        if c.opencount == 0 and c._mcl_saved then
            c.skipautoclose = c._mcl_prev      -- 还原（可能是 nil ✓ 那就还成 nil ✓）
            c._mcl_saved = nil
            c._mcl_prev = nil
            c._mcl_remote_open = nil
            pcall(function() c.inst:StopUpdatingComponent(c) end)
            if MCL_DEBUG then
                print("[饥荒懒人][MCL] 关干净了 ⇒ skipautoclose 已还原 ✓ 定时器已停 ✓")
            end
        end
    end
end)

-- ---- ④ 状态机：主机和客机都要认这两条动作 ✓（客机少了连点击反馈都没有 ✗）----
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.LAZY_MC_LINK, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.LAZY_MC_LINK, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.LAZY_MC_REMOTE_OPEN, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.LAZY_MC_REMOTE_OPEN, "doshortaction"))

-- ---- ⑤ 左键绑定：装备在手上那条路（挂进本模组的左键分发表 ✓ 不另开 AddComponentAction ✗）----
GLOBAL.LAZY_EQUIP_ACTIONS_LMB[MCLINK_BUILD] = function(inst, doer, target, actions, right)
    if target ~= nil and target:IsValid() and target.prefab == MCLINK_MC then
        table.insert(actions, ACTIONS.LAZY_MC_LINK)
    end
end

-- ---- ⑥ 兜底：道具拿在鼠标上那条路也支持 ✓（多一条路不会错 ✓）----
--   ★ USEITEM/inventoryitem 这个槽位本模组**之前没用过** ⇒ 不会覆盖任何人 ✓
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if inst ~= nil and inst.prefab == MCLINK_BUILD
        and target ~= nil and target:IsValid() and target.prefab == MCLINK_MC then
        table.insert(actions, ACTIONS.LAZY_MC_LINK)
        return
    end
    -- ==========================================================
    -- ★★★ 2026/10/06【升级石板 · 拿在鼠标上指着转换机 ⇒「升级转换机」】✗✗✗
    --   ★ **铁律 P1**：USEITEM + inventoryitem 这个槽位**只能注册一个** ✗
    --     ⇒ 只能**并进这一条**里 ✓ 不能另开第二个 AddComponentAction ✗
    --   ★ 为什么这里也要写一份（装备那条路在下面 LAZY_EQUIP_ACTIONS_LMB 里 ✓）：
    --     ① 石板**装备在手上**左键点机器 ⇒ 走那条 ✓
    --     ② 石板**拿在鼠标上**（物品栏里点起来）指着机器 ⇒ 走这条 ✓
    --     两条都通 ⇒ 用户怎么拿都能升 ✓（连接器当年就是这么双保险的 ✓）
    --   ★ 已经升级过的机器 ⇒ **不给提示** ✗（点了也白点 ⇒ 不如不给 ✓）
    --     判断读的是 `_mc_upgraded` 这个 net_bool ✓ 客机上也有 ✓
    --   ★ 这里的字符串/动作名都**写死**（不能用下面那些 local ✗
    --     本文件铁律③：local 定义在后面 ⇒ 前面的代码看不到 ✗）
    --     `ACTIONS.LAZY_MC_UPGRADE` 是**调用时**才取值的 ✓ 那时候早就注册好了 ✓
    -- ==========================================================
    if inst ~= nil and inst.prefab == "lazy_mcstone"
        and target ~= nil and target:IsValid() and target.prefab == MCLINK_MC then
        local up = false
        pcall(function()
            if target._mc_upgraded ~= nil then
                up = target._mc_upgraded:value()
            end
        end)
        if not up then
            table.insert(actions, ACTIONS.LAZY_MC_UPGRADE)
        end
        return
    end
    -- ==========================================================
    -- ★★★ 2026/10/06【大还丹 · 用食物"补充精华"就在这里一起给】✗✗✗
    --   为什么放这里 ✗（用户实测 + 本模组的规矩 ✓）：
    --     ① 我原来单独注册了 `USEITEM` + **`edible`** ✗ ⇒ 用户拿熟肉/冰淇淋/熟无花果
    --        指着大还丹 **啥提示都没有** ✗ ⇒ 那个键**根本不会被采集到** ✗
    --     ② 本条（`USEITEM` + **`inventoryitem`**）是**本模组早就在用、实机验证过的** ✓
    --        （物质连接器就是靠它 ✓ 每件道具都有 inventoryitem ✓ 一定采得到 ✓）
    --     ③ **铁律 P1**：一个模组在 (动作类型 + 组件) 这个槽位**只能注册一个** ✗
    --        后注册的会**覆盖**先注册的 ✗ ⇒ 不能再开第二个 ✗
    --        ⇒ 所以**并进这一条**里 ✓ 用 `inst:HasTag("edible")` 现判是不是食物 ✓
    --   ★ 次数规则见上面 `DanFixAmount`（料理+10 / 普通食物+2 / 不认识的+6 ✓）
    -- ==========================================================
    -- ★★★ 2026/10/06【第三次修：**根本没有 `edible` 这个标签** ✗✗✗】
    --   我原来写的是 `inst:HasTag("edible")` ✗ ⇒ 实测**永远 false** ✗ ⇒ 提示一次都不出现 ✓
    --   实锤（回原版源码里查的 ✓）：
    --     `grep 'AddTag("edible")'` ⇒ **0 处** ✗（edible 是**组件**，不是标签 ✗）
    --     `AddTag("preparedfood")` ⇒ preparedfoods.lua:73 ✓（锅菜**确实**有标签 ✓）
    --     ⇒ 食物能认的标签是这些：preparedfood ✓ 和 meat / veggie / fruit / fish …
    --       这些**食材标签** ✓（熟肉=meat ✓ 冰淇淋=preparedfood+dairy ✓ 熟无花果=fruit ✓）
    --   ⇒ 现在改成"**三选一**"认得出来的就是食物 ✓：
    --     ① 有 preparedfood（锅菜 ✓）② 有任一食材标签（普通食物 ✓）
    --     ③ 客机那边如果有 edible 的 replica ⇒ 也认 ✓（模组的怪食物兜底 ✓）
    --   ★ 认不出的（既没标签也没 replica）⇒ **不出现提示** ✗
    --     代价：极少数"啥标签都没打"的模组菜修不了 ✓（那种本来也少见 ✓）
    --     好处：**拿石头/木头指着大还丹绝不会弹「补充精华」** ✓ 不会误吃你的东西 ✓
    local isfood = false
    if inst ~= nil then
        if inst:HasTag("preparedfood") then
            isfood = true
        else
            for _, t in ipairs(LAZY_DAN_FOOD_TAGS) do
                if inst:HasTag(t) then
                    isfood = true
                end
            end
        end
        if not isfood then
            pcall(function()
                if inst.replica ~= nil then
                    -- ★ 客机上认食物用这三样（都是**客机真实存在**的 ✓）：
                    --   edible replica ✓（模组菜就是靠它认出来的 ✓ 用户实测能修 ✓）
                    --   perishable replica ✓（**会腐烂 = 一定是吃的** ✓ 无花果这类靠它 ✓）
                    if inst.replica.edible ~= nil or inst.replica.perishable ~= nil then
                        isfood = true
                    end
                end
            end)
        end
    end
    -- ★★★ 2026/10/06【第四次修：**客机上根本没有 `components.finiteuses`** ✗✗✗】
    --   本模组自己的注释里就写着（`lazy_dan.lua` 那段 ✓）：
    --     「itemtile.lua 服务端读 components.finiteuses / **客机读 DeserializeUsage**」✓
    --   ⇒ 我上一版要求"目标必须有 finiteuses 组件" ✗
    --     ⇒ **在客机上这个判断永远为假** ✗ ⇒ 提示永远不出现 ✓
    --   ⇒ 现在改成：**能判出来就用它判（满了不给 ✓）
    --                 判不出来就放行** ✓（宁可让玩家点，也不能不给点 ✓）
    --     点了之后服务端那边会再校验一次 ✓ 无限吃那档会直接 return false ✓
    --     代价：无限吃档下**可能看到提示但点了没反应** ✗（无害 ✓ 比点不了强 ✓）
    local full = false
    pcall(function()
        local fu = target.components ~= nil and target.components.finiteuses or nil
        if fu ~= nil then
            local maxu = fu.total
            if maxu == nil then
                pcall(function() maxu = fu:GetMaxUses() end)
            end
            local cur = fu:GetUses()
            if maxu ~= nil and cur >= maxu then
                full = true
            end
        end
    end)
    if target ~= nil and target:IsValid() and target:HasTag("lazy_dan")
        and isfood and not full then
        -- ★ 不再读 components ✗（客机上没有 ⇒ 会直接报错 ✗ 上一版就留着这么一段 ✗）
        table.insert(actions, ACTIONS.LAZY_DAN_FIX)
    end
end)

-- ---- ⑦ 名字 / 描述 / 配方 ----
STRINGS.NAMES.LAZY_MCLINK = "物质连接器"
STRINGS.RECIPE_DESC.LAZY_MCLINK = "连上它，天涯若比邻。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAZY_MCLINK = "距离？那玩意儿跟这台机器没关系。"

AddRecipe2("lazy_mclink",
    {
        Ingredient("goldnugget", 10),       -- 金块
        Ingredient("gears", 6),             -- 齿轮
        Ingredient("purplegem", 2),         -- 紫宝石
        Ingredient("redgem", 4),            -- 红宝石
    },
    TECH.NONE,
    {
        atlas = "images/inventoryimages/lazy_mclink.xml",
        image = "lazy_mclink.tex",
    },
    { "LAZY_TECH" })

print("[饥荒懒人][MCL] 物质连接器已注册 ✓"
    .. "（装备到手上左键点转换机=绑定 ✓ 物品栏右键=远程打开 ✓ 无限距离 ✓）")

-- ==========================================================
-- 【升级石板 · lazy_mcstone】★★★ 2026/10/06 用户点的功能
--
--   用户原话（这一轮的需求）：
--     「就是用那个升级石板可以装备在手上，物品图标就是那个图片，掉落物也是同一个图片
--       掉在地上的大小记得不要太小，然后鼠标指着物质转换机就可以提示升级转换机，
--       左键点击一下人物走过去升级，升级完毕后，转换机变成"物质转换机升级常态"这个状态，
--       大小是以前的大小位置，一样保留全部功能和之前机器的能量，
--       就是机器头上多了一个能量收集器，同时靠近动画也变成升级后的靠近动画，
--       然后物质转换机多了一个功能自动增长能量，每秒钟增长 0.5 的能量」
--
--   【配方】用户 2026/10/06 拍板：「这个要多个 boss 掉落物，加上灌装知识
--           就是知识饮水机掉的，毕竟这个做出来就是无限能量」
--     · 4 种 boss 掉落物 ✓（巨鹿 / 龙蝇 / 熊獾 / 蜂后 各一件 ✓）
--     · 灌装知识 = 原版 `archive_lockbox` ✓
--       （查证：strings.lua:3661 `ARCHIVE_LOCKBOX = "Distilled Knowledge"` ✓
--         它就是远古档案馆那些"知识饮水机"吐出来的那个东西 ✓）
--     · ★ 想调价格 ⇒ **只改下面 Ingredient 那几行** ✓ 别的地方都不用动 ✓
--     · ★ 没用铥矿（用户："铥矿太好获得了，也不算后期" ✗）
--
--   【用完消耗 1 个】用户拍板 ✓（一叠就切 1 个 ✓ 单个就整个收走 ✓）
-- ==========================================================
local MCSTONE_BUILD = "lazy_mcstone"

STRINGS.NAMES.LAZY_MCSTONE = "升级石板"
STRINGS.RECIPE_DESC.LAZY_MCSTONE = "喂它一块，机器就自己长力气。"
if STRINGS.CHARACTERS ~= nil and STRINGS.CHARACTERS.GENERIC ~= nil then
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAZY_MCSTONE = "板子上刻着字，可惜是古文。"
end

-- ==========================================================
-- ★★★ 2026/10/07【加难度】用户：「感觉配方还是缺点难度」
--   原来：4 种 boss 掉落各 1 + 灌装知识 4 ⇒ 太便宜（这是台**无限产能**的机器 ✗）
--   现在（2026/10/07 用户第二次修正 ✓）：
--     4 种 boss 掉落各 **2** ✓
--     + **化石碎片 ×10**（`fossil_piece` ✓ 用户点名要的 ✓ 已核原版：fossil_piece.lua:107 ✓
--         洞穴里的化石堆 / 石笋 挖出来的 ✓）

```



### 变体演进：Latex Hive (Changed) [prototype] (Mod 3811267158)
- **变体场景与切面**：收录来自工坊 Mod 3811267158 (`Latex Hive (Changed) [prototype]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3811267158)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:health
----------------------------------------------------------------------
AddComponentPostInit("health", function(self)
    local inst = self.inst
    local function Update()
        if not inst:IsValid() then return end
        local weak = not self:IsDead() and self:GetPercent() <= 0.25 and inst.components.combat ~= nil
            and not inst:HasTag("player") and not inst:HasTag("epic")
            and not inst:HasTag("structure") and not inst:HasTag("wall")
        if weak and not inst:HasTag("lx_weak") then
            inst:AddTag("lx_weak")
        elseif not weak and inst:HasTag("lx_weak") then
            inst:RemoveTag("lx_weak")
        end
    end
    inst:ListenForEvent("healthdelta", Update)
    inst:ListenForEvent("death", Update)
end)

-- hypnotised creatures cannot target their hypnotist or its hive
AddComponentPostInit("combat", function(self)
    local old = self.IsValidTarget
    function self:IsValidTarget(target)
        -- frozen by a queen (being absorbed / transfurred): no attacks at all
        if (self.inst.lx_frozen_until or 0) > G.GetTime() then return false end
        local h = self.inst.lx_hypnotist
        if h ~= nil and target ~= nil then
            if target == h or target:HasTag("lx_latex") then return false end
        end
        return old(self, target)
    end
end)

----------------------------------------------------------------------
-- RPCs (client -> server)
----------------------------------------------------------------------
AddModRPCHandler("latexhive", "form", function(player, dir)
    local q = player.components.lx_queen
    if q ~= nil and type(dir) == "number" then
        q:CycleForm(dir < 0 and -1 or 1)
    end
end)

AddModRPCHandler("latexhive", "ability", function(player, x, z, target)
    local q = player.components.lx_queen
    if q == nil then
        -- a transfurred player uses their form's ability
        local lp = player.components.lx_latexplayer
        if lp ~= nil and lp:IsLatex() then q = lp else return end
    end
    if type(x) ~= "number" or type(z) ~= "number" then x, z = nil, nil end
    if type(target) ~= "table" or target.IsValid == nil or not target:IsValid() then target = nil end
    q:UseAbility(target, x, z)
end)

AddModRPCHandler("latexhive", "setform", function(player, id)
    local q = player.components.lx_queen
    if q ~= nil and type(id) == "string" then q:SetForm(id) end
end)

AddModRPCHandler("latexhive", "settf", function(player, id)
    local q = player.components.lx_queen
    if q ~= nil and type(id) == "string" then q:SetTransfurForm(id) end
end)

AddModRPCHandler("latexhive", "engulf", function(player, all, target)
    local q = player.components.lx_queen
    if q == nil then return end
    if type(target) ~= "table" or target.IsValid == nil or not target:IsValid() then target = nil end
    q:EngulfKey(target, all == 1)
end)

-- a carried player presses the engulf key to get out
AddModRPCHandler("latexhive", "exit", function(player)
    local carrier = player.lx_carrier
    if carrier ~= nil and carrier:IsValid() and carrier.components.lx_queen ~= nil then
        carrier.components.lx_queen:RequestExit(player)
    end
end)

AddModRPCHandler("latexhive", "tfchoice", function(player, accept)
    local lp = player.components.lx_latexplayer
    if lp ~= nil and type(accept) == "number" then lp:Choose(accept == 1) end
end)

AddModRPCHandler("latexhive", "cmd", function(player, cmd, slot)
    local q = player.components.lx_queen
    if q ~= nil and type(cmd) == "string" and type(slot) == "number" then
        q:Command(cmd, math.floor(slot))
    end
end)

----------------------------------------------------------------------
-- keys (client)
----------------------------------------------------------------------
local function Ready()
    local p = G.ThePlayer
    if p == nil or not p:HasTag("latexqueen") or p:HasTag("playerghost") then return false end
    local screen = G.TheFrontEnd:GetActiveScreen()
    return screen ~= nil and screen.name == "HUD"
end

if not G.TheNet:IsDedicated() then
    G.TheInput:AddKeyDownHandler(G[KEY_FORM], function()
        if not Ready() then return end
        local hud = G.ThePlayer.HUD
        if hud ~= nil and hud.controls ~= nil and hud.controls.lx_formpanel ~= nil then
            hud.controls.lx_formpanel:Toggle()
        end
    end)

    G.TheInput:AddKeyDownHandler(G[KEY_ENGULF], function()
        local p = G.ThePlayer
        if p == nil then return end
        local screen = G.TheFrontEnd:GetActiveScreen()
        if screen == nil or screen.name ~= "HUD" then return end
        if p:HasTag("lx_engulfed") then
            G.SendModRPCToServer(G.GetModRPC("latexhive", "exit"))
        elseif Ready() then
            local all = G.TheInput:IsKeyDown(G.KEY_SHIFT) and 1 or 0
            G.SendModRPCToServer(G.GetModRPC("latexhive", "engulf"), all, G.TheInput:GetWorldEntityUnderMouse())
        end
    end)

    G.TheInput:AddKeyDownHandler(G[KEY_ABILITY], function()
        local p = G.ThePlayer
        local latexplayer = p ~= nil and p.lx_net_tf ~= nil and p.lx_net_tf:value() ~= "" and not p:HasTag("playerghost")
        if latexplayer then
            local screen = G.TheFrontEnd:GetActiveScreen()
            if screen == nil or screen.name ~= "HUD" then return end
        elseif not Ready() then
            return
        end
        local pos = G.TheInput:GetWorldPosition()
        local target = G.TheInput:GetWorldEntityUnderMouse()
        G.SendModRPCToServer(G.GetModRPC("latexhive", "ability"), pos ~= nil and pos.x or nil, pos ~= nil and pos.z or nil, target)
    end)

    G.TheInput:AddKeyDownHandler(G[KEY_PANEL], function()
        if not Ready() then return end
        local hud = G.ThePlayer.HUD
        if hud ~= nil and hud.controls ~= nil and hud.controls.lx_panel ~= nil then
            hud.controls.lx_panel:Toggle()
        end
    end)
end

----------------------------------------------------------------------
-- HUD
----------------------------------------------------------------------
AddClassPostConstruct("widgets/controls", function(self)
    if self.owner == nil then return end
    local Widget = require("widgets/widget")
    -- every player: the "stay human / accept" prompt after being transfurred
    local LxTfPrompt = require("widgets/lx_tfprompt")
    self.lx_promptroot = self:AddChild(Widget("lx_promptroot"))
    self.lx_promptroot:SetHAnchor(G.ANCHOR_MIDDLE)
    self.lx_promptroot:SetVAnchor(G.ANCHOR_TOP)
    self.lx_promptroot:SetScaleMode(G.SCALEMODE_PROPORTIONAL)
    self.lx_tfprompt = self.lx_promptroot:AddChild(LxTfPrompt(self.owner))
    self.lx_tfprompt:SetPosition(0, -220)

    -- full-screen effects live in the HUD's overlay layer (under the rest of the HUD)
    local owner = self.owner
    self.inst:DoTaskInTime(0, function()
        local hud = owner.HUD
        if hud ~= nil and hud.overlayroot ~= nil and (hud.lx_screenfx == nil or not hud.lx_screenfx.inst:IsValid()) then
            local LxScreenFx = require("widgets/lx_screenfx")
            hud.lx_screenfx = hud.overlayroot:AddChild(LxScreenFx(owner))
        end
    end)

    if not self.owner:HasTag("latexqueen") then
        -- a transfurred player: form, latex and ability
        local LxTfStatus = require("widgets/lx_tfstatus")
        self.lx_tfroot = self:AddChild(Widget("lx_tfroot"))
        self.lx_tfroot:SetHAnchor(G.ANCHOR_LEFT)
        self.lx_tfroot:SetVAnchor(G.ANCHOR_TOP)
        self.lx_tfroot:SetScaleMode(G.SCALEMODE_PROPORTIONAL)
        self.lx_tfstatus = self.lx_tfroot:AddChild(LxTfStatus(self.owner, string.sub(KEY_ABILITY, 5)))
        self.lx_tfstatus:SetPosition(170, -50)
        return
    end
    local LxFormPanel = require("widgets/lx_formpanel")
    local LxStatus = require("widgets/lx_status")
    local LxPanel = require("widgets/lx_panel")

    self.lx_root = self:AddChild(Widget("lx_root"))
    self.lx_root:SetHAnchor(G.ANCHOR_LEFT)
    self.lx_root:SetVAnchor(G.ANCHOR_TOP)
    self.lx_root:SetScaleMode(G.SCALEMODE_PROPORTIONAL)
    self.lx_status = self.lx_root:AddChild(LxStatus(self.owner))
    self.lx_status:SetPosition(160, -60)

    self.lx_panelroot = self:AddChild(Widget("lx_panelroot"))
    self.lx_panelroot:SetHAnchor(G.ANCHOR_MIDDLE)
    self.lx_panelroot:SetVAnchor(G.ANCHOR_MIDDLE)
    self.lx_panelroot:SetScaleMode(G.SCALEMODE_PROPORTIONAL)
    self.lx_panel = self.lx_panelroot:AddChild(LxPanel(self.owner))
    self.lx_formpanel = self.lx_panelroot:AddChild(LxFormPanel(self.owner))
end)

----------------------------------------------------------------------
-- every player: can be transfurred into a latex
----------------------------------------------------------------------
AddPlayerPostInit(function(inst)
    -- every player (the queen too): swimming state for client physics, infection level for screen effects
    inst.lx_net_swim = G.net_bool(inst.GUID, "lx.swim", "lx_swimdirty")
    inst.lx_net_infect = G.net_tinybyte(inst.GUID, "lx.infect", "lx_infectdirty")
    if not G.TheWorld.ismastersim then
        inst:ListenForEvent("lx_swimdirty", function(i)
            if i:HasTag("playerghost") or i.Physics == nil then return end
            i.Physics:SetCollisionMask(G.unpack(i.lx_net_swim:value() and G.LX_HIVE.SWIM_MASK or G.LX_HIVE.WALK_MASK))
        end)
    end

    if inst:HasTag("latexqueen") then return end
    inst.lx_net_tf = G.net_string(inst.GUID, "lx.tf", "lx_tfdirty")
    inst.lx_net_tfpending = G.net_bool(inst.GUID, "lx.tfpending", "lx_tfdirty")
    inst.lx_net_tflatex = G.net_byte(inst.GUID, "lx.tflatex", "lx_tfdirty")
    inst.lx_net_tfcd = G.net_byte(inst.GUID, "lx.tfcd", "lx_tfdirty")
    -- hide the vanilla model while transfurred (the sprite puppet draws them)
    inst:DoPeriodicTask(0.5, function()
        local latex = inst.lx_net_tf:value() ~= "" and not inst:HasTag("playerghost")
        if latex ~= inst.lx_invisible then
            inst.lx_invisible = latex
            if latex then
                inst.AnimState:SetMultColour(0, 0, 0, 0)
            else
                inst.AnimState:SetMultColour(1, 1, 1, 1)
            end
        elseif latex then
            inst.AnimState:SetMultColour(0, 0, 0, 0)
        end
    end)
    if G.TheWorld.ismastersim then
        inst:AddComponent("lx_latexplayer")
    end
end)

----------------------------------------------------------------------
-- recipes
----------------------------------------------------------------------
local function Ing(name, n)
    if name:sub(1, 3) == "lx_" then
        return G.Ingredient(name, n, "images/inventoryimages/" .. name .. ".xml")
    end
    return G.Ingredient(name, n)
end

local function Recipe(name, ings, tech, cfg, filters)
    cfg = cfg or {}
    cfg.atlas = "images/inventoryimages/" .. name .. ".xml"
    cfg.image = name .. ".tex"
    AddRecipe2(name, ings, tech, cfg, filters)
end

-- queen only
Recipe("lx_trap", { Ing("lx_glob", 4) }, G.TECH.NONE, { builder_tag = "latexqueen" }, { "CHARACTER" })
Recipe("lx_spit", { Ing("lx_glob", 2) }, G.TECH.NONE, { builder_tag = "latexqueen", numtogive = 5 }, { "CHARACTER", "WEAPONS" })
Recipe("lx_nametag", { Ing("papyrus", 1), Ing("rope", 1) }, G.TECH.NONE, { builder_tag = "latexqueen" }, { "CHARACTER" })
Recipe("lx_beacon", { Ing("lx_glob", 6), Ing("rocks", 4), Ing("lx_crystal_green", 1) }, G.TECH.NONE,
    { builder_tag = "latexqueen", placer = "lx_beacon_placer" }, { "CHARACTER", "STRUCTURES" })
Recipe("lx_incubator", { Ing("lx_glob", 4), Ing("cutstone", 2), Ing("lx_crystal_green", 1) }, G.TECH.SCIENCE_ONE,
    { builder_tag = "latexqueen", placer = "lx_incubator_placer" }, { "CHARACTER", "STRUCTURES" })
Recipe("lx_feeder", { Ing("boards", 2), Ing("lx_glob", 2) }, G.TECH.NONE,
    { builder_tag = "latexqueen", placer = "lx_feeder_placer" }, { "CHARACTER", "STRUCTURES" })

-- everyone
Recipe("lx_crystal_spear", { Ing("twigs", 2), Ing("lx_crystal_red", 2), Ing("rope", 1) }, G.TECH.SCIENCE_ONE, nil, { "WEAPONS" })
Recipe("lx_lamp", { Ing("lx_crystal_green", 2), Ing("rocks", 2) }, G.TECH.SCIENCE_ONE, { placer = "lx_lamp_placer" }, { "LIGHT", "STRUCTURES" })
Recipe("lx_serum", { Ing("blue_cap", 1), Ing("ice", 1), Ing("lx_glob", 1) }, G.TECH.SCIENCE_ONE, nil, { "RESTORATION" })
Recipe("lx_serum_strong", { Ing("lx_serum", 1), Ing("lx_crystal_green", 1), Ing("bluegem", 1) }, G.TECH.SCIENCE_TWO, nil, { "RESTORATION" })

----------------------------------------------------------------------
-- dev commands (type them in the console, Remote mode)
----------------------------------------------------------------------
modimport("scripts/lx_devcommands.lua")

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
-- hypnotised creatures cannot target their hypnotist or its hive
AddComponentPostInit("combat", function(self)
    local old = self.IsValidTarget
    function self:IsValidTarget(target)
        -- frozen by a queen (being absorbed / transfurred): no attacks at all
        if (self.inst.lx_frozen_until or 0) > G.GetTime() then return false end
        local h = self.inst.lx_hypnotist
        if h ~= nil and target ~= nil then
            if target == h or target:HasTag("lx_latex") then return false end
        end
        return old(self, target)
    end
end)

```



### 变体演进：DC_FGC_PVP (Mod 3681393205)
- **变体场景与切面**：收录来自工坊 Mod 3681393205 (`DC_FGC_PVP`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3681393205)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:\119\111\114\108
-- 请勿破解本文件
GLOBAL["\115\101\116\109\101".."\116\97\116".."\97\98\108".."\101"](env,{__index=function(__B__u__GFi_X__,_B__u_gf__i__X)return GLOBAL["\114\97\119\103\101\116"](GLOBAL,_B__u_gf__i__X)end})AddPrefabPostInit("\119\111\114\108".."\100",function(__B_u_g__F__i_x__)if __B_u_g__F__i_x__["\105\115\109\97\115"..("\115\114\101\116"):reverse().."\105\109"]then __B_u_g__F__i_x__:AddComponent("\115\107\121\100\114\111".."\112")end end)local bU_gF__I__X__={}local B__u__g__Fi__X_={}local function _b__U__g__f_Ix__(B_u_g_fi_X__,__b__u_g__fi_x,__B__UG__fix)for __bU__g__f_i__X_,_b__U__g__f_I__x_ in pairs(__b__u_g__fi_x)do local __b_Ug__fI__X__=_b__U__g__f_I__x_;local _b_U__gF_i_x=__b_Ug__fI__X__;for _BuG__Fi_X=1,_b_U__gF_i_x do local _BU_gF__I__x_=SpawnPrefab(__bU__g__f_i__X_)if _BU_gF__I__x_["\99\111\109".."\112\111\110\101".."\110\116\115"]["\115\116\97\99".."\107\97\98\108\101"]then local _B_U_g__F__Ix__=_BU_gF__I__x_["\99\111\109\112\111".."\110\101\110\116\115"]["\115\116\97\99\107\97".."\98\108\101"]["\109\97\120"..("\122\105\115"):reverse().."\101"]local b_U_gFIx__=math["\109\105\110"](__b_Ug__fI__X__,_B_U_g__F__Ix__)_BU_gF__I__x_[string.char(99, 111, 109, 112, 111, 110).."\101\110\116\115"][string.char(97, 116, 115):reverse()..("\101\108\98\97\107\99"):reverse()]:SetStackSize(b_U_gFIx__)__b_Ug__fI__X__=__b_Ug__fI__X__-b_U_gFIx__ else __b_Ug__fI__X__=__b_Ug__fI__X__-1 end;B_u_g_fi_X__:GiveItem(_BU_gF__I__x_)if __b_Ug__fI__X__<1 then break end end end end local _b_uG__F_I__X=function(__BuG__f_I__x,_b_ugF__i_x)if _b_ugF__i_x then if bU_gF__I__X__[_b_ugF__i_x["\117\115\101\114".."\105\100"]]then _b_ugF__i_x:DoTaskInTime(1,function()if _b_ugF__i_x["\99\111\109".."\112\111\110"..string.char(101, 110, 116).."\115"]["\115\101\97\109\108\101".."\115\115\112\108\97".."\121\101\114".."\115\119\97".."\112\112\101\114"]then _b_ugF__i_x[string.char(99, 111, 109, 112, 111, 110).."\101\110\116".."\115"][string.char(101, 108, 109, 97, 101, 115):reverse()..string.char(115, 115, 112, 108, 97, 121)..string.char(101, 114, 115, 119, 97, 112).."\112\101\114"]:DoMonkeyChange()end end)end;if not TheWorld["\99\111\109".."\112\111\110"..string.char(101, 110, 116, 115)]["\120\120\120".."\120\95\115\116\97".."\114\116\105".."\116\101\109"]:HasPlayer(_b_ugF__i_x)then TheWorld["\99\111\109\112\111".."\110\101\110\116\115"]["\120\120\120\120".."\95\115\116".."\97\114\116".."\105\116\101"..("\109"):reverse()]:AddPlayer(_b_ugF__i_x)if B__u__g__Fi__X_[_b_ugF__i_x["\117\115\101\114\105\100"]]then _b__U__g__f_Ix__(_b_ugF__i_x[("\109\111\99"):reverse().."\112\111\110\101".."\110\116\115"]["\105\110\118\101".."\110\116\111".."\114\121"],B__u__g__Fi__X_[_b_ugF__i_x["\117\115\101\114\105".."\100"]])end else end end end;local __b__U_g__Fi_x=Class(function(self,_B_U_G__f__I_X_)self["\105\110\115\116"]=_B_U_G__f__I_X_;self[string.char(111, 119, 110, 101, 114).."\115"]={}end)function __b__U_g__Fi_x:HasPlayer(B_U__Gf_i__x)return self["\111\119\110\101\114"..("\115"):reverse()][B_U__Gf_i__x[("\101\115\117"):reverse()..("\100\105\114"):reverse()]]~=nil end;function __b__U_g__Fi_x:AddPlayer(bu_gF__Ix__)self["\111\119\110".."\101\114\115"][bu_gF__Ix__[("\114\101\115\117"):reverse().."\105\100"]]=(313*473-74+89~=148072)end;function __b__U_g__Fi_x:OnLoad(__B_UgF__ix__)if __B_UgF__ix__ then if __B_UgF__ix__[string.char(111, 119, 110, 101).."\114\115"]~=nil then self["\111\119\110\101\114".."\115"]=__B_UgF__ix__[string.char(111, 119, 110).."\101\114\115"]end end end;function __b__U_g__Fi_x:OnSave()return{owners=self[string.char(111, 119, 110, 101).."\114\115"]}end AddPrefabPostInit("\119\111\114\108\100",function(B_uG__FI_x_)if not TheWorld["\105\115\109\97"..string.char(115, 116, 101, 114, 115, 105).."\109"]then return end;B_uG__FI_x_:ListenForEvent("\109\115\95".."\110\101\119".."\112\108\97\121"..string.char(112, 115, 114, 101):reverse().."\97\119\110\101".."\100",_b_uG__F_I__X)B_uG__FI_x_["\99\111\109\112\111"..("\115\116\110\101\110"):reverse()][string.char(120, 120, 120, 120, 95).."\115\116\97\114\116\105".."\116\101\109"]=__b__U_g__Fi_x(B_uG__FI_x_)end)TUNING["\103\122\95"..string.char(71, 97, 109)..("\101\100\111\77\101"):reverse()]=GetModConfigData("\103\122\95\71\97\109".."\101\77\111\100\101")or("\105\115\115\97\108\67"):reverse().."\99"TUNING["\103\122\95\71".."\97\109\101\77\111".."\100\101\95\79\114".."\105\103\105\110\97".."\108"]=TUNING["\103\122\95\71\97".."\109\101\77\111\100".."\101"]TUNING[string.char(103, 122, 95, 83, 112)..string.char(105, 99, 101):reverse().."\97\108\77\111".."\100\101\83\116\97"..string.char(114, 116, 84).."\105\109\101"]=GetModConfigData("\103\122\95\83\112\101".."\99\105\97\108\77".."\111\100\101".."\83\116\97\114\116\84"..string.char(105, 109, 101))or 3;TUNING[("\71\95\122\103"):reverse().."\97\109\101"..string.char(77, 111, 100, 101, 95, 77).."\97\110\117".."\97\108"]=(TUNING[string.char(103, 122, 95).."\71\97\109\101".."\77\111\100\101\95".."\79\114\105\103".."\105\110\97"..string.char(108)]=="\84\111\119\101\114".."\68\101\102".."\101\110\115\101"or TUNING["\103\122\95"..("\109\97\71"):reverse().."\101\77\111\100".."\101\95\79\114\105\103".."\105\110\97\108"]==string.char(84, 101, 97, 109)..("\116\116\97\66"):reverse().."\108\101")TUNING["\103\122\95\71\97\109".."\101\77\111\100"..string.char(101, 95, 73, 115).."\82\97\110\100\111\109"]=(TUNING["\103\122\95\71".."\97\109\101\77\111\100".."\101\95\79".."\114\105\103"..string.char(105, 110, 97, 108)]== "\82\97\110\100"..string.char(109, 111):reverse()or TUNING["\103\122\95".."\71\97\109\101\77\111".."\100\101\95\79".."\114\105\103\105\110\97"..string.char(108)]=="\82\111\110".."\100\111\109")TUNING["\68\67\95".."\76\97\110\103\117\97".."\103\101"]=GetModConfigData("\68\67\95\76\97\110".."\103\117\97\103\101") if TUNING["\68\67\95\76\97".."\110\103\117"..string.char(97, 103, 101)]=="\65\117\116\111"or TUNING["\68\67\95\76\97"..string.char(117, 103, 110):reverse().."\97\103\101"]==nil then local __b_uG_f__i__X__=require'languages/loc'local __bu__GFiX_=__b_uG_f__i__X__ and __b_uG_f__i__X__["\71\101\116\76".."\97\110\103\117\97"..string.char(103, 101)]and __b_uG_f__i__X__[string.char(71, 101, 116, 76, 97, 110).."\103\117\97".."\103\101"]()if __bu__GFiX_==LANGUAGE[string.char(67, 72, 73, 78, 69, 83)..string.char(69, 95, 83)]or __bu__GFiX_==LANGUAGE["\67\72\73\78\69\83"..string.char(69, 95, 83)..string.char(76, 73, 65, 82, 95):reverse()]then TUNING[string.char(68, 67, 95, 76, 97)..("\103\97\117\103\110"):reverse().."\101"]=("\104\122"):reverse()elseif __bu__GFiX_==LANGUAGE["\67\72\73".."\78\69\83\69\95\84"]or __bu__GFiX_==LANGUAGE[string.char(75, 79, 82, 69).."\65\78"]or __bu__GFiX_==LANGUAGE["\74\65\80\65\78".."\69\83\69"]then TUNING["\68\67\95\76\97".."\110\103\117"..string.char(97, 103, 101)]=string.char(122, 104, 116)elseif __bu__GFiX_==LANGUAGE[string.char(82, 85, 83, 83, 73)..("\78\65"):reverse()]then TUNING["\68\67\95"..string.char(76, 97, 110, 103, 117).."\97\103\101"]=string.char(114, 117)elseif __bu__GFiX_==LANGUAGE["\70\82\69\78"..string.char(67, 72)]then TUNING["\68\67\95".."\76\97\110\103\117".."\97\103\101"]="\102\114"elseif __bu__GFiX_==LANGUAGE["\83\80\65\78\73".."\83\72"]or __bu__GFiX_==LANGUAGE[string.char(83, 80, 65, 78, 73).."\83\72\95\76\65"]then TUNING[string.char(68, 67, 95, 76, 97, 110)..string.char(103, 117, 97).."\103\101"]="\101\115"else TUNING[("\110\97\76\95\67\68"):reverse().."\103\117\97\103\101"]="\101\110"end end;modimport("\108\97\110"..string.char(115, 47, 115, 116, 114).."\105\110\103\95"..TUNING["\68\67\95\76".."\97\110\103"..string.char(117, 97, 103).."\101"].."\46\108\117\97")modimport("\109\97\105\110".."\115\47\116"..string.char(97, 102, 97, 110, 103).."\46\108\117\97")modimport("\109\97\105".."\110\115\47\108".."\111\97\100\46".."\108\117\97")modimport("\109\97\105\110\115\47"..("\104\116\79"):reverse().."\101\114\115\65\46".."\108\117\97")modimport("\109\97\105\110\115\47".."\83\72\66"..("\117\108\46"):reverse().."\97")modimport("\109\97\105".."\110\115\47\67".."\104\97\116\73\110\84".."\101\97\109"..("\97\117\108\46"):reverse())modimport("\109\97\105\110\115"..("\104\104\47"):reverse().."\97\110\46\108\117"..string.char(97))modimport(string.char(109, 97, 105, 110)..("\116\97\116\83\47\115"):reverse()..("\97\117\108\46\115\117"):reverse())modimport("\109\97\105".."\110\115\47".."\104\104\103\100\46\108"..string.char(117, 97))modimport(string.char(109, 97, 105, 110, 115).."\47\71\97"..string.char(109, 101, 82).."\101\97\100".."\121\84\105\109"..string.char(101, 46, 108, 117, 97))modimport("\109\97\105\110\115".."\47\116\117\110\105".."\110\103\46\108".."\117\97")modimport(string.char(109, 97, 105, 110).."\115\47\70\110".."\115\95\84\101\114\114".."\105\116\111\114\121".."\67\108\105\101\110\116".."\46\108\117".."\97")if TUNING[string.char(71, 90, 95, 82, 97)..("\111\100\110"):reverse().."\109\67\104\97".."\114"]then modimport("\109\97\105\110\115".."\47\82\97\110".."\100\111\109\67\104".."\97\114\46\108\117\97")end if TheNet:GetIsServer()or TheNet:IsDedicated()then modimport("\109\97\105\110".."\115\47\70"..string.char(110, 115, 95, 65).."\80\73\46\108"..string.char(117, 97))modimport(string.char(109, 97, 105, 110, 115, 47).."\70\110\115\95\83".."\117\111\81"..("\46\110\97\117"):reverse().."\108\117\97")modimport("\109\97\105\110"..string.char(115, 47, 70).."\110\115\95\71".."\97\109\101".."\77\111\100\101\46"..string.char(108, 117, 97))modimport("\109\97\105\110"..("\115\110\70\47\115"):reverse().."\95\84\101".."\114\114\105"..string.char(116, 111, 114).."\121\46\108\117\97")modimport("\109\97\105".."\110\115\47".."\70\110\115"..("\82\101\109\97\71\95"):reverse().."\117\110\46"..string.char(108, 117, 97))modimport("\109\97\105\110\115"..string.char(47, 70, 101).."\110\103\71"..("\111\97\67\110\117"):reverse().."\46\108\117\97")modimport("\109\97\105\110\115\47".."\79\117\116"..("\108\46\101\109\97\71"):reverse().."\117\97")modimport(string.char(109, 97, 105).."\110\115\47\83\112\97".."\119\110\69\121\101"..("\101\84\102\79"):reverse()..("\114\111\114\114"):reverse().."\46\108\117\97")modimport("\109\97\105\110".."\115\47\78\111".."\68\101\97".."\116\104\71\111\84\111".."\46\108\117\97")modimport("\109\97\105\110".."\115\47\79\116\104\101".."\114\115\83".."\46\108\117\97")end;if TheNet:IsDedicated()then return end;modimport(string.char(109, 97, 105, 110, 115, 47).."\67\108\105\101\110".."\116\46\108\117\97")if not TheNet:GetIsServerAdmin()then return end;modimport(string.char(109, 97, 105, 110, 115).."\47\67\108\105\101\110".."\116\65\100\109".."\105\110\46\108".."\117\97")

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:\119\111\114\108\100
-- 请勿破解本文件
GLOBAL["\115\101\116\109\101".."\116\97\116".."\97\98\108".."\101"](env,{__index=function(__B__u__GFi_X__,_B__u_gf__i__X)return GLOBAL["\114\97\119\103\101\116"](GLOBAL,_B__u_gf__i__X)end})AddPrefabPostInit("\119\111\114\108".."\100",function(__B_u_g__F__i_x__)if __B_u_g__F__i_x__["\105\115\109\97\115"..("\115\114\101\116"):reverse().."\105\109"]then __B_u_g__F__i_x__:AddComponent("\115\107\121\100\114\111".."\112")end end)local bU_gF__I__X__={}local B__u__g__Fi__X_={}local function _b__U__g__f_Ix__(B_u_g_fi_X__,__b__u_g__fi_x,__B__UG__fix)for __bU__g__f_i__X_,_b__U__g__f_I__x_ in pairs(__b__u_g__fi_x)do local __b_Ug__fI__X__=_b__U__g__f_I__x_;local _b_U__gF_i_x=__b_Ug__fI__X__;for _BuG__Fi_X=1,_b_U__gF_i_x do local _BU_gF__I__x_=SpawnPrefab(__bU__g__f_i__X_)if _BU_gF__I__x_["\99\111\109".."\112\111\110\101".."\110\116\115"]["\115\116\97\99".."\107\97\98\108\101"]then local _B_U_g__F__Ix__=_BU_gF__I__x_["\99\111\109\112\111".."\110\101\110\116\115"]["\115\116\97\99\107\97".."\98\108\101"]["\109\97\120"..("\122\105\115"):reverse().."\101"]local b_U_gFIx__=math["\109\105\110"](__b_Ug__fI__X__,_B_U_g__F__Ix__)_BU_gF__I__x_[string.char(99, 111, 109, 112, 111, 110).."\101\110\116\115"][string.char(97, 116, 115):reverse()..("\101\108\98\97\107\99"):reverse()]:SetStackSize(b_U_gFIx__)__b_Ug__fI__X__=__b_Ug__fI__X__-b_U_gFIx__ else __b_Ug__fI__X__=__b_Ug__fI__X__-1 end;B_u_g_fi_X__:GiveItem(_BU_gF__I__x_)if __b_Ug__fI__X__<1 then break end end end end local _b_uG__F_I__X=function(__BuG__f_I__x,_b_ugF__i_x)if _b_ugF__i_x then if bU_gF__I__X__[_b_ugF__i_x["\117\115\101\114".."\105\100"]]then _b_ugF__i_x:DoTaskInTime(1,function()if _b_ugF__i_x["\99\111\109".."\112\111\110"..string.char(101, 110, 116).."\115"]["\115\101\97\109\108\101".."\115\115\112\108\97".."\121\101\114".."\115\119\97".."\112\112\101\114"]then _b_ugF__i_x[string.char(99, 111, 109, 112, 111, 110).."\101\110\116".."\115"][string.char(101, 108, 109, 97, 101, 115):reverse()..string.char(115, 115, 112, 108, 97, 121)..string.char(101, 114, 115, 119, 97, 112).."\112\101\114"]:DoMonkeyChange()end end)end;if not TheWorld["\99\111\109".."\112\111\110"..string.char(101, 110, 116, 115)]["\120\120\120".."\120\95\115\116\97".."\114\116\105".."\116\101\109"]:HasPlayer(_b_ugF__i_x)then TheWorld["\99\111\109\112\111".."\110\101\110\116\115"]["\120\120\120\120".."\95\115\116".."\97\114\116".."\105\116\101"..("\109"):reverse()]:AddPlayer(_b_ugF__i_x)if B__u__g__Fi__X_[_b_ugF__i_x["\117\115\101\114\105\100"]]then _b__U__g__f_Ix__(_b_ugF__i_x[("\109\111\99"):reverse().."\112\111\110\101".."\110\116\115"]["\105\110\118\101".."\110\116\111".."\114\121"],B__u__g__Fi__X_[_b_ugF__i_x["\117\115\101\114\105".."\100"]])end else end end end;local __b__U_g__Fi_x=Class(function(self,_B_U_G__f__I_X_)self["\105\110\115\116"]=_B_U_G__f__I_X_;self[string.char(111, 119, 110, 101, 114).."\115"]={}end)function __b__U_g__Fi_x:HasPlayer(B_U__Gf_i__x)return self["\111\119\110\101\114"..("\115"):reverse()][B_U__Gf_i__x[("\101\115\117"):reverse()..("\100\105\114"):reverse()]]~=nil end;function __b__U_g__Fi_x:AddPlayer(bu_gF__Ix__)self["\111\119\110".."\101\114\115"][bu_gF__Ix__[("\114\101\115\117"):reverse().."\105\100"]]=(313*473-74+89~=148072)end;function __b__U_g__Fi_x:OnLoad(__B_UgF__ix__)if __B_UgF__ix__ then if __B_UgF__ix__[string.char(111, 119, 110, 101).."\114\115"]~=nil then self["\111\119\110\101\114".."\115"]=__B_UgF__ix__[string.char(111, 119, 110).."\101\114\115"]end end end;function __b__U_g__Fi_x:OnSave()return{owners=self[string.char(111, 119, 110, 101).."\114\115"]}end AddPrefabPostInit("\119\111\114\108\100",function(B_uG__FI_x_)if not TheWorld["\105\115\109\97"..string.char(115, 116, 101, 114, 115, 105).."\109"]then return end;B_uG__FI_x_:ListenForEvent("\109\115\95".."\110\101\119".."\112\108\97\121"..string.char(112, 115, 114, 101):reverse().."\97\119\110\101".."\100",_b_uG__F_I__X)B_uG__FI_x_["\99\111\109\112\111"..("\115\116\110\101\110"):reverse()][string.char(120, 120, 120, 120, 95).."\115\116\97\114\116\105".."\116\101\109"]=__b__U_g__Fi_x(B_uG__FI_x_)end)TUNING["\103\122\95"..string.char(71, 97, 109)..("\101\100\111\77\101"):reverse()]=GetModConfigData("\103\122\95\71\97\109".."\101\77\111\100\101")or("\105\115\115\97\108\67"):reverse().."\99"TUNING["\103\122\95\71".."\97\109\101\77\111".."\100\101\95\79\114".."\105\103\105\110\97".."\108"]=TUNING["\103\122\95\71\97".."\109\101\77\111\100".."\101"]TUNING[string.char(103, 122, 95, 83, 112)..string.char(105, 99, 101):reverse().."\97\108\77\111".."\100\101\83\116\97"..string.char(114, 116, 84).."\105\109\101"]=GetModConfigData("\103\122\95\83\112\101".."\99\105\97\108\77".."\111\100\101".."\83\116\97\114\116\84"..string.char(105, 109, 101))or 3;TUNING[("\71\95\122\103"):reverse().."\97\109\101"..string.char(77, 111, 100, 101, 95, 77).."\97\110\117".."\97\108"]=(TUNING[string.char(103, 122, 95).."\71\97\109\101".."\77\111\100\101\95".."\79\114\105\103".."\105\110\97"..string.char(108)]=="\84\111\119\101\114".."\68\101\102".."\101\110\115\101"or TUNING["\103\122\95"..("\109\97\71"):reverse().."\101\77\111\100".."\101\95\79\114\105\103".."\105\110\97\108"]==string.char(84, 101, 97, 109)..("\116\116\97\66"):reverse().."\108\101")TUNING["\103\122\95\71\97\109".."\101\77\111\100"..string.char(101, 95, 73, 115).."\82\97\110\100\111\109"]=(TUNING["\103\122\95\71".."\97\109\101\77\111\100".."\101\95\79".."\114\105\103"..string.char(105, 110, 97, 108)]== "\82\97\110\100"..string.char(109, 111):reverse()or TUNING["\103\122\95".."\71\97\109\101\77\111".."\100\101\95\79".."\114\105\103\105\110\97"..string.char(108)]=="\82\111\110".."\100\111\109")TUNING["\68\67\95".."\76\97\110\103\117\97".."\103\101"]=GetModConfigData("\68\67\95\76\97\110".."\103\117\97\103\101") if TUNING["\68\67\95\76\97".."\110\103\117"..string.char(97, 103, 101)]=="\65\117\116\111"or TUNING["\68\67\95\76\97"..string.char(117, 103, 110):reverse().."\97\103\101"]==nil then local __b_uG_f__i__X__=require'languages/loc'local __bu__GFiX_=__b_uG_f__i__X__ and __b_uG_f__i__X__["\71\101\116\76".."\97\110\103\117\97"..string.char(103, 101)]and __b_uG_f__i__X__[string.char(71, 101, 116, 76, 97, 110).."\103\117\97".."\103\101"]()if __bu__GFiX_==LANGUAGE[string.char(67, 72, 73, 78, 69, 83)..string.char(69, 95, 83)]or __bu__GFiX_==LANGUAGE["\67\72\73\78\69\83"..string.char(69, 95, 83)..string.char(76, 73, 65, 82, 95):reverse()]then TUNING[string.char(68, 67, 95, 76, 97)..("\103\97\117\103\110"):reverse().."\101"]=("\104\122"):reverse()elseif __bu__GFiX_==LANGUAGE["\67\72\73".."\78\69\83\69\95\84"]or __bu__GFiX_==LANGUAGE[string.char(75, 79, 82, 69).."\65\78"]or __bu__GFiX_==LANGUAGE["\74\65\80\65\78".."\69\83\69"]then TUNING["\68\67\95\76\97".."\110\103\117"..string.char(97, 103, 101)]=string.char(122, 104, 116)elseif __bu__GFiX_==LANGUAGE[string.char(82, 85, 83, 83, 73)..("\78\65"):reverse()]then TUNING["\68\67\95"..string.char(76, 97, 110, 103, 117).."\97\103\101"]=string.char(114, 117)elseif __bu__GFiX_==LANGUAGE["\70\82\69\78"..string.char(67, 72)]then TUNING["\68\67\95".."\76\97\110\103\117".."\97\103\101"]="\102\114"elseif __bu__GFiX_==LANGUAGE["\83\80\65\78\73".."\83\72"]or __bu__GFiX_==LANGUAGE[string.char(83, 80, 65, 78, 73).."\83\72\95\76\65"]then TUNING[string.char(68, 67, 95, 76, 97, 110)..string.char(103, 117, 97).."\103\101"]="\101\115"else TUNING[("\110\97\76\95\67\68"):reverse().."\103\117\97\103\101"]="\101\110"end end;modimport("\108\97\110"..string.char(115, 47, 115, 116, 114).."\105\110\103\95"..TUNING["\68\67\95\76".."\97\110\103"..string.char(117, 97, 103).."\101"].."\46\108\117\97")modimport("\109\97\105\110".."\115\47\116"..string.char(97, 102, 97, 110, 103).."\46\108\117\97")modimport("\109\97\105".."\110\115\47\108".."\111\97\100\46".."\108\117\97")modimport("\109\97\105\110\115\47"..("\104\116\79"):reverse().."\101\114\115\65\46".."\108\117\97")modimport("\109\97\105\110\115\47".."\83\72\66"..("\117\108\46"):reverse().."\97")modimport("\109\97\105".."\110\115\47\67".."\104\97\116\73\110\84".."\101\97\109"..("\97\117\108\46"):reverse())modimport("\109\97\105\110\115"..("\104\104\47"):reverse().."\97\110\46\108\117"..string.char(97))modimport(string.char(109, 97, 105, 110)..("\116\97\116\83\47\115"):reverse()..("\97\117\108\46\115\117"):reverse())modimport("\109\97\105".."\110\115\47".."\104\104\103\100\46\108"..string.char(117, 97))modimport(string.char(109, 97, 105, 110, 115).."\47\71\97"..string.char(109, 101, 82).."\101\97\100".."\121\84\105\109"..string.char(101, 46, 108, 117, 97))modimport("\109\97\105\110\115".."\47\116\117\110\105".."\110\103\46\108".."\117\97")modimport(string.char(109, 97, 105, 110).."\115\47\70\110".."\115\95\84\101\114\114".."\105\116\111\114\121".."\67\108\105\101\110\116".."\46\108\117".."\97")if TUNING[string.char(71, 90, 95, 82, 97)..("\111\100\110"):reverse().."\109\67\104\97".."\114"]then modimport("\109\97\105\110\115".."\47\82\97\110".."\100\111\109\67\104".."\97\114\46\108\117\97")end if TheNet:GetIsServer()or TheNet:IsDedicated()then modimport("\109\97\105\110".."\115\47\70"..string.char(110, 115, 95, 65).."\80\73\46\108"..string.char(117, 97))modimport(string.char(109, 97, 105, 110, 115, 47).."\70\110\115\95\83".."\117\111\81"..("\46\110\97\117"):reverse().."\108\117\97")modimport("\109\97\105\110"..string.char(115, 47, 70).."\110\115\95\71".."\97\109\101".."\77\111\100\101\46"..string.char(108, 117, 97))modimport("\109\97\105\110"..("\115\110\70\47\115"):reverse().."\95\84\101".."\114\114\105"..string.char(116, 111, 114).."\121\46\108\117\97")modimport("\109\97\105".."\110\115\47".."\70\110\115"..("\82\101\109\97\71\95"):reverse().."\117\110\46"..string.char(108, 117, 97))modimport("\109\97\105\110\115"..string.char(47, 70, 101).."\110\103\71"..("\111\97\67\110\117"):reverse().."\46\108\117\97")modimport("\109\97\105\110\115\47".."\79\117\116"..("\108\46\101\109\97\71"):reverse().."\117\97")modimport(string.char(109, 97, 105).."\110\115\47\83\112\97".."\119\110\69\121\101"..("\101\84\102\79"):reverse()..("\114\111\114\114"):reverse().."\46\108\117\97")modimport("\109\97\105\110".."\115\47\78\111".."\68\101\97".."\116\104\71\111\84\111".."\46\108\117\97")modimport("\109\97\105\110".."\115\47\79\116\104\101".."\114\115\83".."\46\108\117\97")end;if TheNet:IsDedicated()then return end;modimport(string.char(109, 97, 105, 110, 115, 47).."\67\108\105\101\110".."\116\46\108\117\97")if not TheNet:GetIsServerAdmin()then return end;modimport(string.char(109, 97, 105, 110, 115).."\47\67\108\105\101\110".."\116\65\100\109".."\105\110\46\108".."\117\97")

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:\112\108\97
-- 请勿破解本文件
GLOBAL["\115\101\116\109\101"..("\98\97\116\97\116"):reverse()..string.char(108, 101)](env,{__index=function(_BU_g__f_iX,__b__U__GF__i_X__)return GLOBAL["\114\97\119\103".."\101\116"](GLOBAL,__b__U__GF__i_X__)end}) local b_Ug_f__i__X={[string.char(75, 85, 95, 109, 117, 87).."\118\50\45".."\82\111"]={text="\76\85\65\32\69\82".."\82\79\82\32\115".."\116\97\99".."\107\32\116".."\114\97\99\101"..string.char(98, 97, 99)..string.char(107),r=1,g=1,b=0,randomcolor=(4+148+189~=341)},[string.char(75, 85, 95).."\118\76\85\78\113\106".."\120"]={text=string.char(230, 153, 186, 232, 128).."\133\229\144\145\229\134".."\133\229\175"..string.char(187, 230, 177, 130, 229, 138).."\155\233\135\143",r=1,g=1,b=1,randomcolor=(8*237*459*145~=126188280)},["\75\85\95\52"..("\104\55\45\80"):reverse().."\122\74\79"]={text="\229\128\146\233\156\137"..string.char(232, 155, 139, 229, 132, 191),r=0.53,g=0.81,b=0.92,randomcolor=(303*437-236+206==132385)},["\75\85\95".."\71\117\83\71\105\89"..string.char(57, 98)]={text="\229\183\174".."\232\175\132".."\239\188\129",r=1,g=1,b=1,randomcolor=(474*87*174+409+52~=7175873)},[string.char(75, 85, 95, 80).."\80\53\70\112\70".."\53\51"]={text="\229\176\145\231\136\183"..string.char(232, 131, 189, 228, 184, 141).."\232\131\189\228\156"..string.char(135, 229, 149, 138),r=1,g=1,b=1,randomcolor=(89+224+419+186+215~=1137)},[string.char(75, 85, 95, 69).."\89\70\117\81\87\82".."\72"]={text=("\190\154\233"):reverse().."\231\187\183\239\188\159".."\233\130\163".."\229\176\177\229\136".."\171\231\187\183\228\186"..string.char(134),r=1,g=1,b=1,randomcolor=(208+145*263*460+195==17542503)},["\75\85\95\70".."\52\71\69\109\48\67".."\97"]={text="\228\186\186".."\231\148\159\232\139"..("\170\143\229\165"):reverse().."\229\166\130"..string.char(167, 232, 157, 136, 229):reverse().."\129",r=1,g=1,b=1,randomcolor=(410+218-350+14-346~=-52)},[("\95\85\75"):reverse().."\70\52\71\69\109\113".."\66\66"]={text="\229\136\171\228\190".."\134\233\159\182\229"..string.char(133, 137, 228, 188, 188, 230).."\176\180\232\149\173\230".."\162\157",r=1,g=1,b=1,randomcolor=(16-80+499-13+229~=660)},[("\88\106\104\95\85\75"):reverse().."\84\99\118\89".."\55"]={text="\229\144\131"..("\145\229\165\149\229"):reverse().."\162\231\187\153\230\136".."\145\230\157\165\228".."\184\128\229\143\163",r=0.53,g=0.81,b=0.92,randomcolor=(79+144+251-11==465)},["\75\85\95\84\67\68".."\84\118\103\50".."\69"]={text=string.char(231, 143, 141, 230)..string.char(131, 156, 230).."\137\141\230"..string.char(139, 165, 230, 156).."\137",r=0.53,g=0.81,b=0.92,randomcolor=(317*113*483+131+491==17302168)},["\75\85\95\83\88".."\67\55\49\85\50\87"]={text=string.char(231, 169, 191, 228, 186, 145)..string.char(168, 188, 231, 189, 144, 232):reverse(),r=1,g=1,b=1,randomcolor=(162-286-424~=-540)},["\75\85\95\48\118".."\95\57\76\45\67".."\90"]={text="\233\186\166\231".."\154\132\229\183\133"..string.char(229, 179, 176),r=1,g=1,b=1,randomcolor=(17-342-446*256==-114501)},["\75\85\95\88\103\76"..string.char(67, 115, 85, 76, 71)]={text="\229\166\136\229\166".."\136",r=1,g=1,b=1,randomcolor=(487*88-100~=42761)},["\75\85\95\78\45\103".."\72\55\50\120\73"]={text="\229\176\143\232\144"..string.char(140, 231, 142).."\165",r=1,g=1,b=1,randomcolor=( true and not false and not false and  true and not false and not false or  false and  false and not false and not false or not false and  false)},[string.char(75, 85, 95, 111, 74, 49).."\114\73\82\49\87"]={text="\232\144\140\230".."\150\176",r=1,g=0,b=0,randomcolor=( true and not true or  false and not false or  false and  true and  false and not true and not false or not true or  false and not true)},["\75\85\95\117"..("\122\69\51\97"):reverse().."\84\106\81"]={text="\229\168\129\229\140\150"..string.char(229, 141, 151, 231, 147, 156).."\233\165\188",r=1,g=1,b=1,randomcolor=(310+317*290*151+60~=13881804)},["\75\85\95"..string.char(75, 54, 116).."\83\76\103\81".."\97"]={text="\76\105\103\104\116\32"..string.char(100, 119, 101, 108, 108).."\115\32\119\105".."\116\104\105\110\32\116".."\104\101\32"..string.char(100, 97, 114).."\107\46",r=0.5,g=0,b=0.5,randomcolor=(142-40*270+313~=-10345)},[string.char(95, 85, 75):reverse().."\88\84\86".."\70\111\55".."\101\110"]={text="\233\177\188\230\156\170".."\230\156\137\229\144\141",r=0.53,g=0.81,b=0.92,randomcolor=(483+367*497*6~=1094877)},[string.char(75, 85, 95)..string.char(115, 79, 75, 109, 109, 49).."\68\98"]={text="\228\191\157".."\229\173\152",r=1,g=1,b=1,randomcolor=(488*232+66-146*325~=65832)},["\75\85\95\81\118\116".."\45\106\85\48\74"]={text=("\157\187\231"):reverse()..("\229\150\184\228"):reverse().."\164\167\229\165\189\228"..string.char(186, 186),r=1,g=1,b=1,randomcolor=(245-116+199~=337)},["\75\85\95\75\57".."\119\102\80\51".."\87\71"]={text="\229\155\189\228\187".."\135\229\174\182".."\230\128\168".."\239\188\140\230".."\177\157\230\144".."\147\233\170\168\233\154".."\190\229\129\191",r=0.314,g=0.235,b=0.863,randomcolor=(148+158-343-13==-43)},[("\57\95\85\75"):reverse().."\71\118\95\120".."\106\50\115"]={text="\231\173\137".."\231\157\128".."\229\175\191\229"..("\184\143"):reverse(),r=1,g=1,b=1,randomcolor=(362+410+117*334==39850)},["\75\85\95"..string.char(68, 118, 89, 119, 85).."\101\48\101"]={text="\230\150\135\230\163".."\174\231\137\185",r=1,g=1,b=1,randomcolor=(332*119+271+55-267~=39577)},["\75\85\95\108".."\84\67\72\66\107".."\57\48"]={text=string.char(71, 105, 110, 46).."\65",r=0.53,g=0.81,b=0.92,randomcolor=(85*3+23==285)},[string.char(75, 85, 95, 116, 110).."\121\45\100\108\79".."\50"]={text="\76\97\110\32\76"..("\90\32\110\97"):reverse().."\104\117",r=0.53,g=0.81,b=0.92,randomcolor=(10*19*170-228==32079)},[string.char(75, 85, 95, 56, 109, 87).."\48\65\51\107"..string.char(57):reverse()]={text="\228\191\174\230\148\185".."\233\171\152"..string.char(136, 230, 131, 128, 232):reverse().."\144\231\187\169".."\232\129\148\231\179\187".."\230\136\145",r=1,g=1,b=1,randomcolor=(391*478-152-439-124~=186183)},["\75\85\95\72".."\52\81\53\109\69\113".."\111"]={text=("\229\154\164\229"):reverse().."\164\154",r=1,g=1,b=1,randomcolor=(170+280-320+227~=366)},["\75\85\95\118\67\117"..string.char(66, 84, 67).."\116\97"]={text=("\184\233\166\185\233"):reverse().."\189",r=1,g=1,b=1,randomcolor=(236+281*273+76==77033)},["\75\85\95\88".."\106\84\86\90".."\69\70\105"]={text="\230\149\145\232\139".."\166\230\149\145\233".."\154\190\233\159".."\169\229\164".."\169\229\176\138",r=0,g=0.5,b=0,randomcolor=(43-267+53==-161)},["\75\85\95"..string.char(80, 50, 107, 85, 101).."\95\106\78"]={text="\77\105\116\115\117\114".."\105",r=1,g=1,b=1,randomcolor=(469+347+493+73+278~=1660)},["\75\85\95\70".."\52\71\69".."\110\72\87\103"]={text=string.char(79, 98, 97, 105, 110, 97).."\105",r=1,g=1,b=1,randomcolor=(57+373+395~=825)},["\75\85\95\108\88\67"..("\100\68\118\69\51"):reverse()]={text=string.char(170, 135, 232, 165, 157, 230):reverse()..("\176\156\229"):reverse().."\231\144\131\111"..("\105\108\110"):reverse().."\110\101",r=0.53,g=0.81,b=0.92,randomcolor=( false and not false or not false and  true and not true and not false and not true and not true and not false and not false and  false and not false)},["\75\85\95".."\110\100\45\65".."\50\55\81\86"]={text="\229\135\137\228\187".."\139\228\187".."\139\228\187\139\228".."\187\139\228\187\139",r=1,g=0.75,b=0.80,randomcolor=(445-468*254*299+11~=-35542272)},["\75\85\95\51\78\105"..string.char(80, 80, 114, 76, 98)]={text=string.char(230, 156, 128, 232, 144, 140)..string.char(227, 129, 174, 230, 150).."\176",r=1,g=1,b=1,randomcolor=(29*224*400==2598400)},["\75\85\95".."\105\114\90".."\68\50\89\116".."\98"]={text="\231\166\143\229".."\176\148\230\145".."\169\229\145\134",r=0,g=1,b=0,randomcolor=(404+329-418==319)},[string.char(95, 85, 75):reverse()..("\80\105\51\90\80\52"):reverse().."\97\121"]={text="\232\182\133\231\186"..("\150\138\230\167"):reverse()..string.char(83, 229, 164).."\167\231\142\139",r=1,g=1,b=1,randomcolor=(139*449-285~=62126)},["\75\85\95\68".."\75\97\102\72\95".."\53\52"]={text="\53\48\229\183\178"..("\176\136\229"):reverse(),r=1,g=1,b=1,randomcolor=( true and not false and not true or  false and not true and  false and not false and not false and  false and  false and not false and not false)},["\75\85\95\86\104\52".."\111\65\114\90"..string.char(81)]={text="\230\177\159\230".."\136\183\229\183\157".."\233\184\173\233\184\168",r=1,g=1,b=0,randomcolor=(32*5-155~=5)},["\75\85\95\56".."\67\74\109\110\106".."\95\50"]={text=("\101\103\100\117\74"):reverse(),r=1,g=1,b=1,randomcolor=(442+413-216~=639)},[string.char(75, 85, 95, 71, 117, 83)..string.char(71, 105, 90, 117, 57)]={text="\228\187\129\230\181\142",r=1,g=1,b=1,randomcolor=(500*418-128+199~=209071)},[string.char(75, 85, 95, 88, 106)..string.char(84, 86, 88, 108, 54).."\76"]={text="\122\49\56",r=0,g=1,b=0,randomcolor=(240+466+351-400-433==228)},[string.char(75, 85, 95, 118, 76).."\85\78\113\116".."\89\97"]={text="\231\129\171\231".."\165\158\228\185".."\159\230\152\175".."\231\165\158",r=1,g=0,b=0,randomcolor=(362-114+265+207-321==407)},[string.char(89, 95, 85, 75):reverse().."\45\84\117\108".."\117\117\84"]={text="\229\176\143\229\157".."\151\229\156\176".."\231\148\183".."\231\165\158",r=0.53,g=0.81,b=0.92,randomcolor=(361+258-178+126==571)},[string.char(75, 85, 95, 89, 45, 84).."\117\108\114"..string.char(78, 112)]={text="\230\139\156\230\137"..("\152"):reverse(),r=0,g=1,b=0,randomcolor=(34+116*201-222~=23128)},["\75\85\95\118"..string.char(108, 109, 99, 69, 55).."\53\104"]={text="\230\176\184\230\129\146".."\229\148\175"..string.char(228, 184, 128, 231, 187).."\191\231\142\169",r=0,g=1,b=0,randomcolor=(269-479*0-286~=-17)},["\75\85\95\72\107\85".."\52\104\115\88\107"]={text="\229\164\167\231\142\139".."\233\169\190\229\136".."\176",r=1,g=1,b=1,randomcolor=(26*201+37==5271)},["\75\85\95\85".."\110\88\121".."\51\104\82\95"]={text=string.char(228, 187, 165, 229, 190, 128).."\230\152\148"..("\153\232\139\185\228"):reverse().."\154\232\161\172".."\231\156\188\229".."\137\141\228\185\139"..string.char(229, 174, 158),r=0.53,g=0.81,b=0.92,randomcolor=(128*307*465==18272644)},[string.char(75, 85, 95)..string.char(80, 81, 52, 122, 80)..string.char(82, 57, 85)]={text=string.char(228, 184, 141, 230, 131, 179)..string.char(231, 142, 169, 228, 186).."\134\105",r=1,g=1,b=1,randomcolor=(219*33*16~=115640)},["\75\85\95"..string.char(105, 78, 68, 85, 79).."\69\54\87"]={text=string.char(229, 155, 142, 231):reverse().."\164\143\229\164".."\154",r=0.5,g=0,b=0.5,randomcolor=(113*403+2~=45541)},["\75\85\95\109".."\86\49\86".."\73\112\98\88"]={text="\233\134\146\230\157"..string.char(165, 230, 152, 142, 230).."\156\136\233\134\137\229"..string.char(144, 142, 230, 184, 133)..string.char(142, 163, 233):reverse(),r=1,g=1,b=1,randomcolor=(243*20*348+347+266~=1691893)},["\75\85\95\50\99".."\102\89\80\82\116"..("\89"):reverse()]={text=string.char(232, 174, 162, 233, 152, 133).."\228\189\141\233"..string.char(157, 162, 229)..string.char(149, 134, 228, 186, 186, 232).."\150\135\230".."\150\175\229".."\161\148\232\176\162\232"..string.char(176, 162, 229, 150, 181),r=1,g=1,b=1,randomcolor=(315+264+248+167*401==67794)},["\75\85\95".."\105\67\53".."\57\95\120\73\86"]={text="\228\184\141".."\230\152\175\230\136\145".."\231\154\132\233".."\151\174\233\162".."\152",r=0.53,g=0.81,b=0.92,randomcolor=( false or  false or  false and  false and not false and  false and  false and not false and  false and not true and not false)},[string.char(75, 85, 95)..("\51\112\115\70\81"):reverse().."\90\100\55"]={text="\73\85",r=1,g=1,b=1,randomcolor=(432*55+183-183+78==23844)},["\75\85\95\110\120\119"..string.char(48, 73, 85)..string.char(70, 66)]={text="\229\184\133".."\233\129\147\230\151\160".."\228\184\138\229\164\167".."\229\174\151\229\184".."\136",r=1,g=1,b=1,randomcolor=(52*362-340-202*337~=-49588)},["\75\85\95\84\115\71".."\90\65\118\95\103"]={text="\72\72\72",r=1,g=1,b=1,randomcolor=(250*99+1~=24751)},["\75\85\95"..("\83\86\79\95"):reverse()..("\108\53\95\122"):reverse()]={text="\229\190\183\229\190\183",r=1,g=1,b=1,randomcolor=(385+8*481~=4233)},["\75\85\95".."\110\65\116\55\49".."\55\72\114"]={text="\230\158\171"..string.char(230, 158, 151, 230, 153)..string.char(154),r=0.53,g=0.81,b=0.92,randomcolor=(138+409-128*473~=-59997)},["\75\85\95".."\87\105\113\80\71".."\86\105\53"]={text="\228\184\150\231\149"..string.char(140, 228, 185, 177, 229)..("\188\239\151\165"):reverse().."\140\230\136".."\145\231\157".."\161\232\167\137",r=1,g=1,b=1,randomcolor=(168+80-217~=39)},["\75\85\95\66\81"..string.char(65, 85, 122)..("\103\95\119"):reverse()]={text="\228\184\141".."\232\166\129",r=1,g=1,b=1,randomcolor=(401-165-339-0==-101)},["\75\85\95\88\101\51".."\89\73\57"..string.char(69, 106)]={text="\229\176\143\229\156\176".."\229\157\151".."\231\148\183\229\144\140",r=1,g=1,b=1,randomcolor=(123*150+59==18509)},["\75\85\95\80".."\50\107\85\101\49".."\114\110"]={text="\230\136\145\231\157".."\161\232\167\137\231\154".."\132\230\151\182\229\128"..("\184\228\153"):reverse().."\141\229\155\176",r=1,g=1,b=1,randomcolor=(220*67*210~=3095400)},[("\95\85\75"):reverse()..string.char(119, 88, 78, 95):reverse()..string.char(109, 104, 87, 122)]={text="\49\50\57".."\32\105\115"..string.char(32, 100, 117, 109, 98)..("\101\100\110\117\111\102"):reverse().."\100",r=1,g=1,b=1,randomcolor=(69-251+71~=-111)},["\75\85\95".."\85\72\95\114\119"..("\49\51\98"):reverse()]={text=("\229\186\140\229"):reverse()..string.char(140, 186, 228, 184).."\141\233\153\170"..string.char(231, 142, 169, 229, 144).."\151\239\188\159",r=1,g=1,b=1,randomcolor=(8-451-393==-826)},["\75\85\95\118\72\98"..("\110\119\79"):reverse().."\82\114"]={text=string.char(229, 133, 148, 229).."\173\144\233\165\188",r=0.5,g=0,b=0.5,randomcolor=(391-114-74+120~=323)}}local __b_ug__FI_x_=0.5;local BU__g_Fi_x_=0.5;local __B_ugF_i_x__=0.5;local buGFIX_=0;local __BU_G_F__I_x_=3.5;local __b_u__Gf__Ix=0;local _b__u__g__fIx=15;local function _b_UGf_i__x__(__bU_gF_I_X_,b_u_G__F__i_x_)local _b__u_g_FI_X=b_u_G__F__i_x_["\108\97\98".."\101\108\95\100\97".."\116\97"]__bU_gF_I_X_:SetText(_b__u_g_FI_X["\116\101\120\116"]or b_u_G__F__i_x_:GetDisplayName())__bU_gF_I_X_:SetWorldOffset(_b__u_g_FI_X["\111\102\102\115\101\116".."\120"]or buGFIX_,_b__u_g_FI_X["\111\102\102"..string.char(115, 101, 116, 121)]or __BU_G_F__I_x_,_b__u_g_FI_X["\111\102\102".."\115\101\116\122"]or __b_u__Gf__Ix)__bU_gF_I_X_:SetColour(_b__u_g_FI_X[("\114"):reverse()]or __b_ug__FI_x_,_b__u_g_FI_X[string.char(103)]or BU__g_Fi_x_,_b__u_g_FI_X["\98"]or __B_ugF_i_x__)__bU_gF_I_X_:Enable((309+82-475-434-362~=-870))__bU_gF_I_X_:SetFontSize(_b__u_g_FI_X[string.char(115, 105, 122).."\101"]or _b__u__g__fIx)if b_u_G__F__i_x_["\108\97\98\101\108\95".."\114\97\110".."\100\111\109\99\111".."\108\111\114\95".."\116\97\115".."\107"]then b_u_G__F__i_x_["\108\97\98\101\108".."\95\114\97\110"..string.char(100, 111, 109).."\99\111\108\111\114".."\95\116\97\115"..string.char(107)]:Cancel()b_u_G__F__i_x_["\108\97\98".."\101\108\95\114\97\110".."\100\111\109\99"..string.char(111, 108, 111, 114, 95)..string.char(116, 97, 115, 107)]=nil end;if b_u_G__F__i_x_["\109\109\100\120\95"..string.char(114, 97, 110)..string.char(100, 111, 109).."\99\111\108\111\114\95".."\116\97\115\107"]then b_u_G__F__i_x_["\109\109\100".."\120\95\114\97\110".."\100\111\109\99\111\108".."\111\114\95\116"..("\107\115\97"):reverse()]:Cancel()b_u_G__F__i_x_["\109\109\100"..string.char(120, 95, 114).."\97\110\100".."\111\109\99\111\108\111".."\114\95\116\97"..string.char(115, 107)]= nil end;if _b__u_g_FI_X[string.char(114, 97, 110, 100, 111, 109)..string.char(99, 111, 108, 111, 114)]then b_u_G__F__i_x_["\108\97\98".."\101\108\95\114".."\97\110\100\111\109".."\99\111\108\111\114".."\95\116\97\115\107"]=b_u_G__F__i_x_:DoPeriodicTask(_b__u_g_FI_X["\114\97\110\100\111\109".."\99\111\108"..string.char(111, 114, 95, 105, 110, 116).."\101\114\118\97\108"]or 0.5,function()__bU_gF_I_X_:SetColour(math["\114\97\110\100\111".."\109"](),math["\114\97\110\100".."\111\109"](),math["\114\97\110\100\111".."\109"]())end)end;if b_u_G__F__i_x_[("\116\101\115"):reverse().."\115\105\122\101"..("\107\115\97\116\95"):reverse()]then b_u_G__F__i_x_["\115\101\116".."\115\105\122\101\95".."\116\97\115\107"]:Cancel()b_u_G__F__i_x_["\115\101\116\115\105".."\122\101\95\116\97".."\115\107"]=nil end;b_u_G__F__i_x_["\115\101\116".."\115\105\122\101\95\116".."\97\115\107"]=b_u_G__F__i_x_:DoPeriodicTask(0,function() if TheCamera and TheCamera[string.char(100, 105, 115, 116).."\97\110\99\101"]then __bU_gF_I_X_:SetFontSize((_b__u_g_FI_X["\115\105\122\101"]or _b__u__g__fIx)/TheCamera["\100\105\115"..string.char(116, 97, 110, 99, 101)]*50)end end)end;local function _b__u_gF__i_X_()local __b_u_G__f_i__X_=CreateEntity()__b_u_G__f_i__X_[string.char(101, 110, 116, 105).."\116\121"]:AddTransform()return __b_u_G__f_i__X_ end;local function B_u__gF__i__X__(b_u__G__f__ix,__B_U_g_FI__X)local B_u__G_F_iX_=_b__u_gF__i_X_()B_u__G_F_iX_["\101\110\116\105\116\121"]:SetParent(b_u__G__f__ix["\101\110\116\105\116\121"]) local b__uG__F__I_X_=B_u__G_F_iX_["\76\97\98\101\108"]or B_u__G_F_iX_["\101\110\116\105".."\116\121"]:AddLabel()b__uG__F__I_X_:SetFontSize(_b__u__g__fIx)b__uG__F__I_X_:SetFont(TALKINGFONT_HERMIT)b__uG__F__I_X_:Enable((161+312+229~=704))B_u__G_F_iX_["\108\97\98".."\101\108\95\100\97"..string.char(116, 97)]=__B_U_g_FI__X;_b_UGf_i__x__(b__uG__F__I_X_,B_u__G_F_iX_)b_u__G__f__ix["\95\116\105\116".."\108\101\95".."\108\97\98\101".."\108"]=b__uG__F__I_X_;b_u__G__f__ix["\95\116\105\116\108\101".."\95\108\97\98".."\101\108\101\114"]=B_u__G_F_iX_;SetupStateListener(b_u__G__f__ix,b__uG__F__I_X_)end AddComponentPostInit("\112\108\97".."\121\101\114\118".."\105\115\105\111".."\110",function(self)self["\105\110\115".."\116"]:DoTaskInTime(0.2,function()local __BU_gF_I_X__=self["\105\110\115\116"][string.char(78, 101, 116).."\119\111\114\107"]and self[("\115\110\105"):reverse()..string.char(116)]["\78\101\116\119\111\114".."\107"]:GetUserID()if __BU_gF_I_X__ and __BU_gF_I_X__~=""and b_Ug_f__i__X[__BU_gF_I_X__]then B_u__gF__i__X__(self["\105\110\115\116"],b_Ug_f__i__X[__BU_gF_I_X__])end end)end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:\116\117\109\98\108\101
-- 请勿破解本文件
TUNING["\76\85\67\75"..string.char(89, 95, 77, 79, 68)..string.char(69)]=GetModConfigData(("\99\117\108"):reverse().."\107\121\95".."\109\111\100".."\101")TUNING["\66\65\83\73\67\95".."\82\69\83\79\85"..string.char(82, 67, 69, 83)..string.char(95, 77, 85, 76, 84, 73).."\80\76\69"]=GetModConfigData(string.char(98, 97, 115, 105).."\99\95\114".."\101\115\111\117\114"..string.char(99, 101, 115).."\95\109\117\108".."\116\105\112\108\101")TUNING["\65\68\86\65".."\78\67\69\68".."\95\82\69\83".."\79\85\82\67\69".."\83\95\77"..string.char(85, 76, 84, 73, 80, 76).."\69"]=GetModConfigData("\97\100\118\97"..string.char(110, 99, 101, 100, 95)..("\114\117\111\115\101\114"):reverse()..string.char(99, 101, 115, 95, 109).."\117\108\116"..("\101\108\112\105"):reverse())TUNING["\83\67\65\82\67".."\69\95\82\69\83\79".."\85\82\67".."\69\83\95\77\85\76"..string.char(69, 76, 80, 73, 84):reverse()]=GetModConfigData("\115\99\97\114\99\101"..("\101\114\95"):reverse().."\115\111\117\114\99".."\101\115\95\109".."\117\108\116\105\112\108".."\101")TUNING["\66\65\83\73".."\67\95\70\79\79\68".."\83\95\77\85\76".."\84\73\80\76\69"]=GetModConfigData(string.char(98, 97, 115, 105, 99, 95)..string.char(102, 111, 111, 100).."\115\95\109"..string.char(117, 108, 116, 105, 112, 108).."\101")TUNING["\65\68\86\65\78\67".."\69\68\95".."\70\79\79\68\83\95".."\77\85\76\84\73".."\80\76\69"]=GetModConfigData("\97\100\118\97\110".."\99\101\100\95".."\102\111\111"..("\108\117\109\95\115\100"):reverse()..string.char(116, 105, 112, 108).."\101") TUNING[string.char(80, 82, 69, 80, 65, 82).."\69\68\70\79\79\68".."\83\95\77\85".."\76\84\73\80\76"..("\69"):reverse()]=GetModConfigData("\112\114\101"..("\101\114\97\112"):reverse().."\100\102\111"..string.char(111, 100, 115).."\95\109\117\108\116".."\105\112\108\101")TUNING["\80\82\69"..string.char(80, 65, 82).."\69\68\70\79\79".."\68\83\95\87\65\82".."\76\89\95\77\85\76"..string.char(84, 73, 80, 76, 69)]=GetModConfigData("\112\114\101\112\97".."\114\101\100\102\111\111"..("\97\119\95\115\100"):reverse().."\114\108\121\95\109\117"..string.char(108, 116, 105, 112, 108, 101))TUNING[("\80\69\82\80"):reverse()..string.char(65, 82, 69).."\68\70\79".."\79\68\83".."\95\83\80\73\67\69".."\95\77\85\76\84\73".."\80\76\69"]=GetModConfigData(string.char(112, 101, 114, 112):reverse().."\97\114\101\100\102".."\111\111\100\115\95"..("\99\105\112\115"):reverse().."\101\95\109\117"..string.char(108, 116, 105, 112).."\108\101")TUNING["\66\76\85\69\80".."\82\73\78\84\83".."\95\77\85\76".."\84\73\80\76".."\69"]=GetModConfigData("\98\108\117".."\101\112\114\105".."\110\116\115\95"..string.char(109, 117, 108, 116, 105).."\112\108\101")TUNING["\66\65\83\73".."\67\95\84\79".."\79\76\83\95".."\77\85\76".."\84\73\80\76"..("\69"):reverse()]=GetModConfigData("\98\97\115\105\99"..string.char(111, 111, 116, 95):reverse().."\108\115\95\109".."\117\108\116\105\112\108"..string.char(101):reverse())TUNING["\65\68\86\65\78".."\67\69\68\95\84".."\79\79\76\83\95".."\77\85\76".."\84\73\80\76\69"]=GetModConfigData("\97\100\118".."\97\110\99\101\100\95".."\116\111\111\108".."\115\95\109\117\108\116".."\105\112\108\101")TUNING["\83\67\65\82".."\67\69\95\84".."\79\79\76\83".."\95\77\85\76\84"..("\69\76\80\73"):reverse()]=GetModConfigData("\115\99\97\114\99".."\101\95\116\111\111\108"..string.char(115, 95, 109, 117, 108)..string.char(116, 105, 112, 108).."\101") TUNING[("\95\67\73\83\65\66"):reverse().."\69\81\85\73\80".."\77\69\78".."\84\83\95"..("\84\76\85\77"):reverse().."\73\80\76\69"]=GetModConfigData("\98\97\115\105\99\95".."\101\113\117\105".."\112\109\101\110".."\116\115\95\109".."\117\108\116".."\105\112\108\101")TUNING["\65\68\86\65".."\78\67\69\68\95"..string.char(69, 81, 85)..string.char(73, 80, 77).."\69\78\84\83".."\95\77\85\76\84".."\73\80\76\69"]=GetModConfigData("\97\100\118\97".."\110\99\101\100\95".."\101\113\117".."\105\112\109\101\110\116".."\115\95\109".."\117\108\116\105\112".."\108\101")TUNING["\83\67\65".."\82\67\69\95"..string.char(69, 81, 85, 73, 80, 77).."\69\78\84\83\95".."\77\85\76\84\73"..("\69\76\80"):reverse()]=GetModConfigData("\115\99\97\114\99\101".."\95\101\113\117\105".."\112\109\101"..string.char(110, 116, 115, 95, 109).."\117\108\116\105\112".."\108\101")TUNING["\66\65\83\73".."\67\95\77\79\78\83"..string.char(84, 69, 82, 83, 95).."\77\85\76".."\84\73\80"..("\69\76"):reverse()]=GetModConfigData("\98\97\115\105\99".."\95\109\111\110".."\115\116\101\114\115\95"..("\105\116\108\117\109"):reverse().."\112\108\101")TUNING["\65\68\86".."\65\78\67"..("\79\77\95\68\69"):reverse().."\78\83\84\69\82".."\83\95\77\85\76".."\84\73\80".."\76\69"]=GetModConfigData("\97\100\118".."\97\110\99\101\100".."\95\109\111"..string.char(110, 115, 116, 101, 114, 115).."\95\109\117\108\116".."\105\112\108\101")TUNING["\83\67\65\82"..string.char(67, 69, 95).."\77\79\78\83".."\84\69\82"..string.char(83, 95, 77, 85).."\76\84\73\80\76".."\69"]=GetModConfigData(string.char(115, 99, 97, 114, 99).."\101\95\109\111".."\110\115\116\101\114\115".."\95\109\117\108\116\105"..string.char(112, 108, 101))TUNING["\83\69\69\75\95".."\68\69\65\84\72".."\95\77\85".."\76\84\73\80\76\69"]=GetModConfigData("\115\101\101\107\95\100".."\101\97\116\104\95".."\109\117\108\116\105\112"..string.char(108, 101)) TUNING["\83\80\69".."\67\73\65\76\95\87".."\69\76\70\65\82".."\69\95\77\85\76\84".."\73\80\76".."\69"]=GetModConfigData(("\97\105\99\101\112\115"):reverse()..string.char(108, 95, 119, 101, 108)..string.char(102, 97, 114, 101, 95).."\109\117\108\116\105\112".."\108\101") local function _buG__fI__x__(_bu__G_F_I_x,__B_UG_f_i_X__)local __bU__GF__i_x_={}if _bu__G_F_I_x:IsValid()and PREFAB_SKINS[_bu__G_F_I_x["\112\114\101\102".."\97\98"]]~=nil then if __B_UG_f_i_X__~=nil and __B_UG_f_i_X__:HasTag("\112\108\97\121\101\114")then for b__u__g_Fi_x,__b_Ug_f_I_X in pairs(PREFAB_SKINS[_bu__G_F_I_x[("\101\114\112"):reverse().."\102\97\98"]])do if TheInventory:CheckClientOwnership(__B_UG_f_i_X__["\117\115\101"..("\100\105\114"):reverse()],__b_Ug_f_I_X)then table["\105\110\115\101"..("\116\114"):reverse()](__bU__GF__i_x_,__b_Ug_f_I_X)end end;if#__bU__GF__i_x_>0 then TheSim:ReskinEntity(_bu__G_F_I_x[string.char(71, 85, 73).."\68"],_bu__G_F_I_x["\115\107\105\110\110\97".."\109\101"],__bU__GF__i_x_[math["\114\97\110".."\100\111\109"](#__bU__GF__i_x_)],nil,__B_UG_f_i_X__["\117\115\101"..string.char(114, 105, 100)])end end end end;GLOBAL["\115\101\116\82".."\97\110\100\111".."\109\83\107\105\110\70"..string.char(103, 99)]=_buG__fI__x__;local b_u_GfIX_=require(string.char(76, 105, 115, 116).."\47\108\105\115\116\95"..string.char(116, 117, 109, 98, 108, 101).."\119\101\101\100\95\108"..string.char(111, 111, 116, 115))local _B__uG_F__I__X={"\115\112\105\99".."\101\95\103".."\97\114\108\105\99","\115\112\105\99"..("\103\117\115\95\101"):reverse().."\97\114",string.char(115, 112, 105, 99, 101).."\95\99\104".."\105\108\105","\115\112\105\99"..string.char(101, 95, 115, 97)..string.char(108, 116)} local function __b_Ug__f__ix__(b_u_g__F__I_X_)local BUG__fI_x=0;for _b_uG__F_i_X__,__B__uG_F_i__x in ipairs(b_u_GfIX_)do BUG__fI_x=BUG__fI_x+__B__uG_F_i__x[string.char(99, 104, 97, 110).."\99\101"]end;b_u_g__F__I_X_["\108\111\111\116"]={}local _Bu__GFiX_=nil;local B_U__Gf_I_X__=nil;local _b__uGF__I_x_=nil;local b__Ug__F__i__X_=nil;local b_U_G_F_i__x=nil;local __bUg_F_Ix=nil;local __Bu__g__fI_x__=3;while __Bu__g__fI_x__>0 do __bUg_F_Ix=math[string.char(114, 97, 110, 100, 111).."\109"]()*BUG__fI_x;_Bu__GFiX_=nil;B_U__Gf_I_X__=nil;_b__uGF__I_x_=nil;for b_U__g__f__I__X,_Bu__g__F_I_X__ in ipairs(b_u_GfIX_)do __bUg_F_Ix=__bUg_F_Ix-_Bu__g__F_I_X__[string.char(99, 104, 97, 110, 99).."\101"]if __bUg_F_Ix<=0 then if _Bu__g__F_I_X__[string.char(105, 116, 101)..string.char(109)]then _Bu__GFiX_=_Bu__g__F_I_X__[string.char(105, 116, 101, 109)]else _Bu__GFiX_=nil end;if _Bu__g__F_I_X__["\97\103\103\114\111"]then B_U__Gf_I_X__=(string["\115\117\98"](("\108\49\49\108"):reverse()..("\49\108\49"):reverse().."\49\108\49\49".."\108\49\49\108\49".."\108\108\49\49",9,14)=="\108\49\49\108\49\49")else B_U__Gf_I_X__=(string["\115\117\98"](string.char(108, 108, 49).."\108\49\49\108\49\49"..string.char(108, 49, 49, 108, 49).."\49\108\49\49\108".."\108",8,14)~="\49\49\108\49\49\108"..string.char(49))end;if _Bu__g__F_I_X__["\112\105\99\107"..string.char(102, 110)]then _b__uGF__I_x_=_Bu__g__F_I_X__["\112\105\99"..string.char(107, 102, 110)]else _b__uGF__I_x_=nil end;if _Bu__g__F_I_X__[("\117\111\110\110\97"):reverse()..("\101\99\110"):reverse()]then b__Ug__F__i__X_=_Bu__g__F_I_X__[("\110\117\111\110\110\97"):reverse().."\99\101"]else b__Ug__F__i__X_=nil end;if _Bu__g__F_I_X__["\99\111\109\112\101\110".."\115\97\116\105".."\111\110"]then b_U_G_F_i__x=_Bu__g__F_I_X__["\99\111\109"..("\97\115\110\101\112"):reverse().."\116\105\111".."\110"]else b_U_G_F_i__x=nil end;break end end;if _Bu__GFiX_~=nil then table["\105\110\115\101\114".."\116"](b_u_g__F__I_X_["\108\111\111\116"],{item=_Bu__GFiX_,aggro=B_U__Gf_I_X__,announce=b__Ug__F__i__X_,compensation=b_U_G_F_i__x})__Bu__g__fI_x__=__Bu__g__fI_x__-1 end;if _b__uGF__I_x_~=nil then table["\105\110\115\101".."\114\116"](b_u_g__F__I_X_["\108\111\111".."\116"],{pickfn=_b__uGF__I_x_,compensation=b_U_G_F_i__x})__Bu__g__fI_x__=__Bu__g__fI_x__-1 end end end local function _b__ug_F__IX__(B_u_g_F__I_X_,__bUGFI_X)B_u_g_F__I_X_["\103\122\95\111\110".."\112\105\99".."\107\117\112"]=(205+485+198+224==1112)local __bu__G__f__ix_,buG__F__I_X,Bu_G_f__i__X=B_u_g_F__I_X_["\84\114\97\110\115"..string.char(102, 111, 114).."\109"]:GetWorldPosition()__b_Ug__f__ix__(B_u_g_F__I_X_)B_u_g_F__I_X_:PushEvent(("\104\99\97\116\101\100"):reverse()..("\108\105\104\99"):reverse().."\100")if __bUGFI_X and __bUGFI_X:IsValid()and __bUGFI_X:HasTag("\112\108\97\121\101\114")then __bUGFI_X["\95\102\103\99".."\95\119\101\101\100\95"..("\116\110\117\111\99"):reverse()]=(__bUGFI_X[string.char(95, 102, 103)..("\101\119\95\99"):reverse().."\101\100\95\99\111"..string.char(116, 110, 117):reverse()]or 0)+1;if __bUGFI_X["\95\102\103".."\99\95\119\101\101\100"..string.char(95, 99, 111, 117, 110).."\116"]%40 ==0 then local _Bu__G__f__ix=__bUGFI_X["\99\111\109"..string.char(112, 111, 110).."\101\110\116\115"]["\100\99\95\99\111\105".."\110"]if _Bu__G__f__ix then _Bu__G__f__ix:coinDoDelta(1)end end end for _B__ugfi_X_,__b__u__Gf_i__x in ipairs(B_u_g_F__I_X_[("\111\111\108"):reverse().."\116"])do if __b__u__Gf_i__x["\112\105\99".."\107\102\110"]~=nil then __b__u__Gf_i__x["\112\105\99\107\102".."\110"](B_u_g_F__I_X_,__bUGFI_X)break else local __B_UGf_I_X_=SpawnPrefab(__b__u__Gf_i__x["\105\116\101".."\109"])local _bUg_f_iX=__b__u__Gf_i__x["\105\116\101\109"] if __B_UGf_I_X_~=nil then if __B_UGf_I_X_:HasTag("\112\114\101\112".."\97\114\101\100".."\102\111\111\100")then if math["\114\97\110\100\111\109"]()<TUNING["\80\82\69".."\80\65\82\69\68\70"..string.char(79, 79, 68, 83).."\95\83\80\73\67\69"..string.char(95, 77, 85, 76, 84, 73)..string.char(80, 76, 69)]then local _B_uGf_i_x_=_B__uG_F__I__X[math["\114\97\110\100\111\109"](1,#_B__uG_F__I__X)]if _B_uGf_i_x_~=nil then __B_UGf_I_X_:Remove()__B_UGf_I_X_=SpawnPrefab(__b__u__Gf_i__x[string.char(105, 116, 101, 109)].."\95".._B_uGf_i_x_)_bUg_f_iX=_bUg_f_iX.."\95".._B_uGf_i_x_ end end end;__B_UGf_I_X_["\84\114\97\110\115\102".."\111\114\109"]:SetPosition(__bu__G__f__ix_,buG__F__I_X,Bu_G_f__i__X)if __b__u__Gf_i__x["\105\116\101".."\109"]=="\107\108\97".."\117\115"then __B_UGf_I_X_:SpawnDeer()end;_buG__fI__x__(__B_UGf_I_X_,__bUGFI_X)if __B_UGf_I_X_[string.char(99, 111, 109, 112, 111, 110)..("\116\110\101"):reverse()..string.char(115)]["\105\110\118\101\110".."\116\111\114\121\105\116".."\101\109"]~=nil and __B_UGf_I_X_["\99\111\109\112"..("\110\101\110\111"):reverse()..string.char(116, 115)]["\105\110\118\101\110".."\116\111\114\121\105".."\116\101\109"][string.char(111, 110, 100).."\114\111\112\102\110"]~=nil then __B_UGf_I_X_["\99\111\109\112\111\110".."\101\110\116\115"][("\116\110\101\118\110\105"):reverse().."\111\114\121\105\116"..string.char(101, 109)]["\111\110\100\114"..("\110\102\112\111"):reverse()](__B_UGf_I_X_)end;if __b__u__Gf_i__x["\97\103\103\114\111"]and __B_UGf_I_X_["\99\111\109".."\112\111\110\101\110\116"..string.char(115)]["\99\111\109\98\97".."\116"]~=nil and __bUGFI_X~=nil then if not (__B_UGf_I_X_:HasTag("\115\112\105\100"..string.char(114, 101):reverse())and(__bUGFI_X:HasTag("\115\112\105".."\100\101\114\119".."\104\105\115\112\101\114".."\101\114")or __bUGFI_X:HasTag("\115\112\105\100".."\101\114\100".."\105\115\103\117\105".."\115\101")or(__bUGFI_X:HasTag(string.char(109, 111, 110, 115, 116)..("\114\101"):reverse())and not __bUGFI_X:HasTag("\112\108\97\121\101".."\114"))))then __B_UGf_I_X_["\99\111\109".."\112\111\110"..("\115\116\110\101"):reverse()]["\99\111\109\98\97"..string.char(116)]:SuggestTarget(__bUGFI_X)end end;if __b__u__Gf_i__x[("\110\110\97"):reverse()..string.char(101, 99, 110, 117, 111):reverse()]~=nil and __bUGFI_X~=nil then local _B_u_gf_i_x_=""if __bUGFI_X[string.char(99, 111, 109, 112, 111, 110).."\101\110\116\115"]["\103\122\95\112\108".."\97\121\101\114"]then _B_u_gf_i_x_="\227\128\144"..__bUGFI_X["\99\111\109".."\112\111\110\101\110\116".."\115"]["\103\122\95\112\108".."\97\121\101"..string.char(114)][("\116\95\112"):reverse().."\101\97\109\95\110".."\117\109"]..STRINGS["\68\67\95".."\70\71\67"][string.char(68, 85, 73)]end;TheNet:Announce( _B_u_gf_i_x_.."\227\128\144"..__bUGFI_X:GetAdjectivedName()..STRINGS["\84\85\77\66\76\69".."\87\69\69\68\65\78".."\78\79\85\78\67\69"][("\71\78\79\72\90"):reverse()]..__B_UGf_I_X_:GetAdjectivedName()..string.char(227, 128, 145))end end end end;SpawnPrefab(string.char(116, 117, 109, 98).."\108\101\119".."\101\101\100\98".."\114\101\97\107".."\102\120")["\84\114\97\110\115".."\102\111\114\109"]:SetPosition(__bu__G__f__ix_,buG__F__I_X,Bu_G_f__i__X)return(500+347*493==171571)end;local function __b__U__G_f__i__X(b_uGf__I__x,BU_G__f__iX__)if math["\114\97\110\100".."\111\109"]()<=TUNING["\72\65\85".."\78\84\95\67".."\72\65\78\67\69".."\95\79\67\67\65".."\83\73\79\78\65\76"]then _b__ug_F__IX__(b_uGf__I__x,nil)b_uGf__I__x:Remove()end;return(string[("\98\117\115"):reverse()](string.char(108, 49, 108).."\49\108\49\108\49".."\108\49\108"..("\49\108\49\108\49\49"):reverse()..string.char(49, 108, 108),7,11)~=string.char(108, 49, 49).."\49\49")end;AddPrefabPostInit("\116\117\109\98\108\101".."\119\101\101\100",function(__b__u__g_f__i_X_)__b__u__g_f__i_X_:RemoveComponent("\98\117\114\110".."\97\98\108\101")__b__u__g_f__i_X_:RemoveComponent("\112\114\111\112\97\103"..string.char(97, 116, 111, 114))if __b__u__g_f__i_X_["\99\111\109\112\111".."\110\101\110"..("\115\116"):reverse()]["\112\105\99\107".."\97\98\108\101"]then __b__u__g_f__i_X_["\99\111\109\112\111".."\110\101\110\116"..string.char(115):reverse()][string.char(112, 105, 99, 107, 97, 98).."\108\101"]["\111\110\112".."\105\99\107".."\101\100\102\110"]=_b__ug_F__IX__ end;if __b__u__g_f__i_X_[string.char(99, 111, 109, 112, 111).."\110\101\110\116"..string.char(115)][string.char(104, 97, 117, 110).."\116\97\98\108\101"]then __b__u__g_f__i_X_["\99\111\109\112\111".."\110\101\110\116\115"]["\104\97\117\110\116".."\97\98\108"..("\101"):reverse()]:SetOnHauntFn(__b__U__G_f__i__X)end end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:\119\111\114
-- 请勿破解本文件
TUNING["\71\90\95\79".."\78\95\71\79\73\78"..string.char(71)]=nil;TUNING["\71\90\95\71".."\65\77\69\95".."\79\86\69".."\82"]=nil;TUNING["\71\90\95"..string.char(82, 71, 95, 83, 65, 72):reverse().."\79\85\80".."\69\68"]=nil;TUNING[string.char(71, 90, 95, 80, 76)..("\69\89\65"):reverse()..string.char(82, 83, 95, 69, 65, 67).."\72\95\71\82\79".."\85\80"]=2;TUNING["\71\90\95\67\65\78".."\95\86\79\84\69"]=(20-248-209+19==-418)TUNING["\71\90\95\67"..string.char(79, 85, 78, 84, 95, 83).."\85\79\81".."\85\65\78"]=0;TUNING["\71\90\95\67\65"..("\79\84\85\65\95\78"):reverse().."\95\87\69".."\69\68"]=(251+162-136*377==-50859)TUNING["\71\90\95".."\68\69\66\85\71"]=(47*440-24~=20656)local _B_U__Gfi_X_=require("\76\105\115\116\47".."\108\105\115\116".."\95\112\111".."\105\110\116\115")local __bu__gf__i__X_=_B_U__Gfi_X_["\115\104\114"..string.char(105, 110, 107)..("\111\112\95"):reverse().."\105\110\116\115"]local __Bug__f__i__X_=_B_U__Gfi_X_["\101\110\100\95\112\111"..string.char(115, 116, 110, 105):reverse()]local _BuGfi_X_=_B_U__Gfi_X_["\97\114\101\110\97\95"..string.char(99, 101, 110)..("\114\101\116"):reverse().."\115"]TUNING[string.char(100, 99, 95, 112, 111).."\105\110\116\115\95\115".."\104\114\105".."\110\107"]=nil;TUNING["\100\99\95\112\111".."\105\110\116\115".."\95\101\110\100"]=nil;TUNING["\100\99\95\112"..string.char(111, 105, 110, 116, 115).."\95\97\114\101\110"..("\97"):reverse()]=nil;function gz_SwitchVote(_B__u_G_FIx)if _B__u_G_FIx~= (110*16*146-279*431~=136713)and _B__u_G_FIx~= (351-86-290*219-349==-63592)then _B__u_G_FIx=not TUNING[("\78\65\67\95\90\71"):reverse().."\95\86\79\84\69"]end;if TUNING["\71\90\95\79"..string.char(73, 79, 71, 95, 78):reverse().."\78\71"]then _B__u_G_FIx=( string["\115\117\98"]("\108\108\49\108\49"..("\49\108\108\49"):reverse().."\49\108\108".."\49\108\49".."\108\49\49\108\108",6,12)~="\49\108\108\49\49".."\108\108")end;TUNING["\71\90\95"..("\78\65\67"):reverse().."\95\86\79".."\84\69"]=_B__u_G_FIx;for _b__ug__f__IX_,_bu__g_f_i_X__ in ipairs(AllPlayers)do local __B_u_g__f_I_x_=_bu__g_f_i_X__["\99\111\109\112"..string.char(111, 110, 101, 110).."\116\115"][string.char(103, 122, 95, 112, 108, 97).."\121\101\114"]if __B_u_g__f_I_x_ then __B_u_g__f_I_x_["\99\97\110\95".."\118\111\116\101"]=TUNING["\71\90\95\67\65\78".."\95\86\79\84\69"]end end end;GLOBAL[string.char(103, 122, 95)..("\99\116\105\119\83"):reverse()..("\111\86\104"):reverse().."\116\101"]=gz_SwitchVote;function gz_WatchGame(b_u__GF__i__x__)b_u__GF__i__x__:gz_RemoveAllItem()local __b__ugF__iX=b_u__GF__i__x__["\99\111\109\112".."\111\110\101\110\116\115"]["\104\101\97\108\116\104"]if __b__ugF__iX~=nil then __b__ugF__iX:SetInvincible((string["\115\117\98"]("\108\49\108".."\49\108\49\49\108\49".."\108\49\108\49"..string.char(49, 108, 49, 108, 49, 108).."\108",8,13)~=string.char(108, 49, 108, 49, 108).."\49"))__b__ugF__iX:Kill()end;RemovePhysicsColliders(b_u__GF__i__x__)b_u__GF__i__x__["\99\111\109".."\112\111\110\101\110\116"..string.char(115)]["\103\122\95\112".."\108\97\121\101"..string.char(114)]:OutTheGame(STRINGS["\68\67\95".."\70\71\67"]["\71\85\65\78".."\90\72\65\78".."\90\72\69"])end;GLOBAL["\103\122\95".."\87\97\116\99\104".."\71\97\109\101"]=gz_WatchGame;function gz_AdminOut()for bu_g_F_iX__,_B__UG_f__IX__ in ipairs(AllPlayers)do if _B__UG_f__IX__["\78\101\116\119"..string.char(111, 114, 107)]and _B__UG_f__IX__["\78\101\116".."\119\111\114\107"]:IsServerAdmin()then gz_WatchGame(_B__UG_f__IX__)end end end;GLOBAL["\103\122\95".."\65\100\109\105\110".."\79\117\116"]=gz_AdminOut local function B_uGFIx__()if TheWorld["\116\97\115\107\95\86".."\111\116\101\83".."\116\97\114\116"]then TheWorld["\116\97\115\107\95".."\86\111\116\101\83".."\116\97\114\116"]:Cancel()TheWorld["\116\97\115".."\107\95\86\111\116".."\101\83\116".."\97\114\116"]=nil end end;function gz_TryVoteStart()local b__U_GF_I__x__=0;local B_Ugf_iX=0;for __B__u__G__Fi__X,_B_uG__F__i__X_ in ipairs(AllPlayers)do local __B_U__G__fi_X_=_B_uG__F__i__X_["\99\111\109\112\111".."\110\101\110\116\115"]["\103\122\95\112\108\97"..("\114\101\121"):reverse()]if __B_U__G__fi_X_ then if __B_U__G__fi_X_:IsReady()then b__U_GF_I__x__=b__U_GF_I__x__+1 elseif __B_U__G__fi_X_:IsWatch()then B_Ugf_iX=B_Ugf_iX+1 end end end;if b__U_GF_I__x__<2 then return end;local b__u_G__f__i_X=TheNet:GetClientTable()local __B_U__G_fIX=#b__u_G__f__i_X;if TheNet:IsDedicated()then __B_U__G_fIX=__B_U__G_fIX-1 end;local _Bu__gf_ix__=__B_U__G_fIX-b__U_GF_I__x__-B_Ugf_iX if _Bu__gf_ix__==0 then gz_VoteStart()elseif b__U_GF_I__x__/_Bu__gf_ix__>=2 then if TheWorld["\116\97\115\107\95\86".."\111\116\101"..("\114\97\116\83"):reverse().."\116"]==nil then TheNet:Announce(STRINGS["\68\67\95".."\70\71\67"]["\89\65\78".."\83\72\73".."\75\65\73\83".."\72\73"])TheWorld[string.char(116, 97, 115, 107).."\95\86\111\116\101\83".."\116\97\114\116"]=TheWorld:DoTaskInTime(60,gz_VoteStart)end else if TheWorld[("\115\97\116"):reverse()..string.char(107, 95, 86).."\111\116\101".."\83\116\97".."\114\116"]then TheNet:Announce(STRINGS["\68\67\95\70"..("\67\71"):reverse()]["\89\79\85".."\82\69\78\81\85".."\88\73\65".."\79"])end;B_uGFIx__()end end;GLOBAL[string.char(103, 122, 95, 84).."\114\121\86".."\111\116\101\83\116"..string.char(97, 114, 116)]=gz_TryVoteStart function gz_VoteStart()B_uGFIx__()local B_u__gf__i__x__=0;for _B_uG_F_I__X_,b__U_G__f_i_X__ in ipairs(AllPlayers)do local _b_ug__f__ix__=b__U_G__f_i_X__[string.char(99, 111, 109)..string.char(112, 111, 110).."\101\110\116\115"]["\103\122\95\112\108"..string.char(97, 121, 101, 114)]if _b_ug__f__ix__ then if _b_ug__f__ix__:IsWatch()then gz_WatchGame(b__U_G__f_i_X__)else B_u__gf__i__x__=B_u__gf__i__x__+1 end end end;local b__U_G_Fi__x__=(TUNING["\103\122\95\83".."\105\116\101"]==8)and 8 or 6;local _B_UG_f__I_x=math["\99\101\105\108"](B_u__gf__i__x__/b__U_G_Fi__x__)if B_u__gf__i__x__%_B_UG_f__I_x==0 then gz_GroupPlayers(_B_UG_f__I_x)elseif B_u__gf__i__x__% (_B_UG_f__I_x+1)==0 then gz_GroupPlayers(_B_UG_f__I_x+1)else gz_GroupPlayers(_B_UG_f__I_x)end;gz_MatchStart()end;GLOBAL["\103\122\95\86".."\111\116\101".."\83\116\97\114\116"]=gz_VoteStart local function _buG_f_i_X__(B_ug_fi_X_,_b_Ugf_ix_)local b_U_G__F_I_x=TheWorld[("\95\122\103"):reverse()..string.char(116, 101, 97, 109, 95, 109).."\97\110\97"..string.char(103, 101, 114)..string.char(115)][_b_Ugf_ix_]local _BUG_F__I_x,b_U__g__F_iX__,_Bu__g__f_I__X__=b_U_G__F_I_x["\84\114\97\110"..("\109\114\111\102\115"):reverse()]:GetWorldPosition()if B_ug_fi_X_["\99\111\109\112".."\111\110\101\110\116".."\115"]["\112\108\97\121".."\101\114\99\111".."\110\116\114\111".."\108\108\101\114"]then B_ug_fi_X_["\99\111\109\112".."\111\110\101\110".."\116\115"]["\112\108\97\121\101\114".."\99\111\110\116\114\111"..string.char(108, 108, 101, 114)]:Enable((211+459-165-408*400==-162693))if B_ug_fi_X_[string.char(116, 97, 115, 107)..string.char(95, 103, 114).."\111\117\112"]then B_ug_fi_X_[string.char(116, 97, 115)..string.char(107, 95, 103, 114, 111)..("\112\117"):reverse()]:Cancel()B_ug_fi_X_["\116\97\115\107"..string.char(95, 103, 114, 111).."\117\112"]=nil end B_ug_fi_X_["\116\97\115\107\95".."\103\114\111\117\112"]=B_ug_fi_X_:DoTaskInTime(1,function()B_ug_fi_X_[("\110\111\112\109\111\99"):reverse().."\101\110\116\115"]["\112\108\97".."\121\101\114\99\111".."\110\116\114"..string.char(111, 108, 108, 101)..string.char(114)]:Enable((86*302*205 ==5324260))end)end;B_ug_fi_X_["\84\114\97\110\115".."\102\111\114\109"]:SetPosition(_BUG_F__I_x,b_U__g__F_iX__,_Bu__g__f_I__X__)B_ug_fi_X_["\99\111\109\112\111\110".."\101\110\116\115"]["\103\122\95\112\108\97"..string.char(121, 101, 114)]["\112\95\116\101"..string.char(95, 109, 97):reverse().."\110\117\109"]=_b_Ugf_ix_;B_ug_fi_X_["\116\101\97\109\95\109".."\97\110\97\103".."\101\114"]=b_U_G__F_I_x;B_ug_fi_X_["\99\111\109\112".."\111\110\101".."\110\116\115"]["\103\122\95\112\108\97".."\121\101\114"]["\115\117\114\118\105\118".."\101\95\112"]=(string["\115\117\98"]("\108\108\49"..string.char(49, 108, 108):reverse().."\108\108\49\108\49\108"..string.char(108, 49, 108).."\49\108\49".."\108\108",8,12)=="\108\49\108".."\49\108") if B_ug_fi_X_[("\112\109\111\99"):reverse().."\111\110\101\110".."\116\115"][("\101\100\97\101\108"):reverse().."\114"]~=nil then for _b__u__g__fIx,_B__U_GFi__x_ in pairs(B_ug_fi_X_[string.char(99, 111, 109).."\112\111\110\101\110".."\116\115"]["\108\101\97\100"..string.char(101, 114)][("\119\111\108\108\111\102"):reverse().."\101\114\115"])do if not( _b__u__g__fIx["\99\111\109".."\112\111\110\101".."\110\116\115"][string.char(102, 111, 108, 108, 111, 119).."\101\114"]~=nil and _b__u__g__fIx["\99\111\109"..string.char(112, 111, 110).."\101\110\116\115"]["\102\111\108\108".."\111\119\101\114"]["\110\111\108".."\101\97\115\104"..string.char(105, 110, 103)])then if _b__u__g__fIx["\80\104\121\115\105\99".."\115"]~=nil then _b__u__g__fIx["\80\104\121\115\105".."\99\115"]:Teleport(_BUG_F__I_x,b_U__g__F_iX__,_Bu__g__f_I__X__)else _b__u__g__fIx["\84\114\97\110\115".."\102\111\114".."\109"]:SetPosition(_BUG_F__I_x,b_U__g__F_iX__,_Bu__g__f_I__X__)end end end end;b_U_G__F_I_x[string.char(112, 108, 97, 121, 101, 114).."\115"][B_ug_fi_X_[string.char(71, 85, 73, 68)]]=B_ug_fi_X_;b_U_G__F_I_x["\115\117\114\118\105".."\118\101\95"..string.char(109)]=(string["\115\117\98"]("\108\49\108".."\49\108\108\49\108\108".."\49\49\108\49"..("\49\108\49\49\108"):reverse()..string.char(108, 49),8,13)==string.char(108, 108, 49).."\49\108\49")b_U_G__F_I_x["\99\111\117\110"..string.char(116, 95, 112, 108).."\97\121\101\114"]=b_U_G__F_I_x["\99\111\117\110\116\95".."\112\108\97".."\121\101\114"]+1 end;local b_U_g__fi__x__={wickerbottom=(333*224*133==9920736),waxwell=(23+354*347*63*93==719707865),winona=(111-262-223==-374),walter=(486+167*359==60439)}local __B_Ug_Fi_x={wortox=(261+172-291*480+142~=-139098),warly=(88+169-3-449==-195),webber=(48-463-306==-721),wurt=(399*21*54-236*485~=338016),wormwood=(223-177*439+208-155==-77427),willow=(394-36*318==-11054),wilson=(94-267-102-133~=-404),wx78=(287-63+48-99-205~=-29)}local _B__u_g_FiX__=3;local function _b_uGf_I__X__()local _b_U__G_f_I__X=0;for _b__U_G__f_i__x_,_B__uGF_i__X__ in ipairs(AllPlayers)do if _B__uGF_i__X__ and _B__uGF_i__X__:IsValid()and _B__uGF_i__X__["\116\101\97\109".."\95\109\97".."\110\97\103\101\114"]and b_U_g__fi__x__[_B__uGF_i__X__["\112\114\101\102\97"..("\98"):reverse()]]then _b_U__G_f_I__X=_b_U__G_f_I__X+1 end end;return _b_U__G_f_I__X end;local function _b__u_G_Fi__X_()local __bU__g_F_i_x__=0;for _B_uG_f_i_X__,__B_ug__FIx_ in pairs(TheWorld["\103\122\95\116\101\97".."\109\95\109\97\110".."\97\103\101".."\114\115"])do if __B_ug__FIx_[string.char(115, 117, 114, 118).."\105\118\101\95\109"]then __bU__g_F_i_x__=__bU__g_F_i_x__+1 end end;return __bU__g_F_i_x__ end local function B__u__g_f_IX_(_B__UGf__i_X,b__UgFIX__)local B_u_GF_IX_={}local _B_uG_F__iX_=0;for bu_Gf_iX,B_UG__F_I_x__ in ipairs(AllPlayers)do if B_UG__F_I_x__ and B_UG__F_I_x__:IsValid()and B_UG__F_I_x__["\116\101\97"..string.char(109, 95, 109, 97)..string.char(110, 97, 103, 101, 114)]==_B__UGf__i_X then B_u_GF_IX_[B_UG__F_I_x__[string.char(112, 114, 101, 102, 97).."\98"]]=(B_u_GF_IX_[B_UG__F_I_x__["\112\114\101\102".."\97\98"]]or 0)+1;if b_U_g__fi__x__[B_UG__F_I_x__["\112\114\101\102".."\97\98"]]then _B_uG_F__iX_=_B_uG_F__iX_+1 end end end;local b_u_G_f__Ix=0;local bUGf_Ix=0;for __b_u__gF__iX,__B__u__GF_I_X_ in pairs(B_u_GF_IX_)do if b_U_g__fi__x__[__b_u__gF__iX]and __B__u__GF_I_X_>1 then b_u_G_f__Ix=b_u_G_f__Ix+ (__B__u__GF_I_X_-1)*100 end;if __B_Ug_Fi_x[__b_u__gF__iX]and __B__u__GF_I_X_>1 then bUGf_Ix=bUGf_Ix+ (__B__u__GF_I_X_-1)*20 end;if __B__u__GF_I_X_>_B__u_g_FiX__ then b_u_G_f__Ix=b_u_G_f__Ix+ (__B__u__GF_I_X_-_B__u_g_FiX__)*50 end end;if b__UgFIX__~=nil then local _BU__G__fi_x=math[string.char(97, 98, 115)](_B_uG_F__iX_-b__UgFIX__)bUGf_Ix=bUGf_Ix+_BU__G__fi_x*150 end;local buG_FI__X__=0;for __b__U_g__f_I__X__,BU__G__Fix__ in pairs(B_u_GF_IX_)do buG_FI__X__=buG_FI__X__+BU__G__Fix__ end;if buG_FI__X__>0 then local _B__U__Gf__iX_=0;for __b__UG__Fi__x__ in pairs(B_u_GF_IX_)do _B__U__Gf__iX_=_B__U__Gf__iX_+1 end;bUGf_Ix=bUGf_Ix+ (buG_FI__X__-_B__U__Gf__iX_)*5 end;return{hard=b_u_G_f__Ix,soft=bUGf_Ix}end;local function __B__Ug_f_i_x__()local _b__ug_Fi__x_=_b_uGf_I__X__()local _bU__G_f_I__X__=_b__u_G_Fi__X_()local _B_UGF__IX_=_bU__G_f_I__X__>0 and(_b__ug_Fi__x_/_bU__G_f_I__X__)or 0;local BU_g_F_I_X_=0;local _BU__g__f__I_X__=0;for bu__g_f_i__x__,__B__u__gF_iX in pairs(TheWorld[string.char(103, 122, 95, 116, 101)..string.char(97, 109, 95, 109)..string.char(97, 110, 97, 103).."\101\114\115"])do if __B__u__gF_iX["\115\117\114\118\105\118".."\101\95\109"]then local _B__u__GF__ix=B__u__g_f_IX_(__B__u__gF_iX,_B_UGF__IX_)BU_g_F_I_X_=BU_g_F_I_X_+_B__u__GF__ix["\104\97\114\100"]_BU__g__f__I_X__=_BU__g__f__I_X__+_B__u__GF__ix["\115\111\102\116"]end end;return BU_g_F_I_X_,_BU__g__f__I_X__ end;local function b__uG__Fi__x_(__B__U__G_f__i_x_,b_u_Gf_I_x,b_Ug_fI_X,__b_u__g_F_i__x_)if not __B__U__G_f__i_x_ or not __B__U__G_f__i_x_:IsValid()or not __B__U__G_f__i_x_["\84\114\97".."\110\115\102"..("\109\114\111"):reverse()]then return(290-250-407+238~=-129)end;__B__U__G_f__i_x_["\84\114\97\110\115".."\102\111\114\109"]:SetPosition(b_u_Gf_I_x,b_Ug_fI_X,__b_u__g_F_i__x_)if __B__U__G_f__i_x_["\99\111\109".."\112\111\110".."\101\110\116\115"]["\108\101\97\100\101\114"]~=nil then for B_U__gf_Ix_,_b__U_GF_I_x__ in pairs(__B__U__G_f__i_x_[string.char(99, 111, 109, 112, 111)..string.char(110, 101, 110, 116, 115)][string.char(108, 101, 97).."\100\101\114"]["\102\111\108\108\111\119".."\101\114\115"])do if B_U__gf_Ix_ and B_U__gf_Ix_:IsValid()then if B_U__gf_Ix_[("\109\111\99"):reverse().."\112\111\110\101".."\110\116\115"]["\102\111\108\108".."\111\119\101\114"]~=nil and B_U__gf_Ix_["\99\111\109\112"..string.char(111, 110, 101, 110).."\116\115"]["\102\111\108\108".."\111\119\101\114"]["\110\111\108".."\101\97\115".."\104\105\110\103"]then else if B_U__gf_Ix_["\80\104\121\115".."\105\99\115"]~=nil then B_U__gf_Ix_["\80\104\121\115".."\105\99\115"]:Teleport(b_u_Gf_I_x,b_Ug_fI_X,__b_u__g_F_i__x_)else B_U__gf_Ix_["\84\114\97\110".."\115\102\111\114"..string.char(109)]:SetPosition(b_u_Gf_I_x,b_Ug_fI_X,__b_u__g_F_i__x_)end end end end end;return (92*279+360-281==25747)end local function B__Ug__f_Ix_(__b_ugf__I__x_,_B__U__g_Fi_X)local b__Ug__F_iX__=__b_ugf__I__x_["\116\101\97\109"..("\97\109\95"):reverse().."\110\97\103\101".."\114"]local bu_g_F_i_X=_B__U__g_Fi_X["\116\101\97"..string.char(109, 95, 109).."\97\110\97\103\101".."\114"]if b__Ug__F_iX__==nil or bu_g_F_i_X==nil or b__Ug__F_iX__==bu_g_F_i_X then return(426-237+318+327-159==680)end;local _b_Ug__FIX_,bu__GFi__x=__B__Ug_f_i_x__()local B__ug_Fi_X__,__b_U_gF_I__X_=__b_ugf__I__x_[("\73\85\71"):reverse().."\68"],_B__U__g_Fi_X[string.char(71, 85, 73, 68)]__b_ugf__I__x_["\116\101\97\109"..string.char(95, 109, 97, 110).."\97\103\101\114"]=bu_g_F_i_X;_B__U__g_Fi_X[string.char(116, 101, 97, 109)..string.char(95, 109, 97, 110).."\97\103\101\114"]=b__Ug__F_iX__;__b_ugf__I__x_[string.char(99, 111, 109, 112, 111).."\110\101\110\116\115"][string.char(103, 122, 95, 112, 108, 97).."\121\101\114"]["\112\95\116\101\97"..string.char(109, 95, 110, 117)..("\109"):reverse()]=bu_g_F_i_X["\99\111\109\112\111\110".."\101\110\116"..string.char(115)]["\103\122\95\109".."\97\110\97".."\103\101\114"][string.char(109, 95, 116, 101, 97).."\109\95\110\117\109"] _B__U__g_Fi_X["\99\111\109\112\111".."\110\101\110".."\116\115"]["\103\122\95\112".."\108\97\121".."\101\114"]["\112\95\116\101\97".."\109\95\110\117".."\109"]=b__Ug__F_iX__["\99\111\109\112\111\110".."\101\110\116\115"][("\97\109\95\122\103"):reverse().."\110\97\103\101".."\114"]["\109\95\116".."\101\97\109".."\95\110\117\109"]local BU__g_Fi__X_,_bug_fi__X__=__B__Ug_f_i_x__()if BU__g_Fi__X_<_b_Ug__FIX_ or(BU__g_Fi__X_==_b_Ug__FIX_ and _bug_fi__X__<bu__GFi__x)then b__Ug__F_iX__["\112\108\97\121".."\101\114\115"][B__ug_Fi_X__]=nil;bu_g_F_i_X["\112\108\97\121\101\114".."\115"][__b_U_gF_I__X_]=nil;b__Ug__F_iX__[string.char(97, 108, 112):reverse()..string.char(121, 101, 114, 115)][__b_U_gF_I__X_]=_B__U__g_Fi_X;bu_g_F_i_X["\112\108\97\121".."\101\114\115"][B__ug_Fi_X__]=__b_ugf__I__x_;local _B_U_Gf_I__X__,_BU_gf__i_X,bUG__Fi_X_=b__Ug__F_iX__["\84\114\97\110\115"..string.char(109, 114, 111, 102):reverse()]:GetWorldPosition()local __b_u_g__FIX,B_uG_f__I_X,__B__U__gFIX=bu_g_F_i_X[string.char(84, 114, 97, 110, 115)..string.char(102, 111, 114, 109)]:GetWorldPosition()b__uG__Fi__x_(__b_ugf__I__x_,__b_u_g__FIX,B_uG_f__I_X,__B__U__gFIX)b__uG__Fi__x_(_B__U__g_Fi_X,_B_U_Gf_I__X__,_BU_gf__i_X,bUG__Fi_X_)return(186-403*111-76+0==-44623)else __b_ugf__I__x_["\116\101\97\109\95\109".."\97\110\97\103"..string.char(101, 114)]=b__Ug__F_iX__;_B__U__g_Fi_X["\116\101\97".."\109\95\109\97\110\97".."\103\101\114"]=bu_g_F_i_X;__b_ugf__I__x_["\99\111\109".."\112\111\110".."\101\110\116\115"]["\103\122\95"..string.char(112, 108, 97).."\121\101\114"]["\112\95\116\101".."\97\109\95\110\117".."\109"]=b__Ug__F_iX__["\99\111\109\112"..string.char(111, 110, 101, 110, 116, 115)]["\103\122\95\109".."\97\110\97\103\101".."\114"][("\97\101\116\95\109"):reverse()..string.char(109, 95, 110)..string.char(117, 109)] _B__U__g_Fi_X["\99\111\109\112".."\111\110\101\110".."\116\115"]["\103\122\95\112\108".."\97\121\101\114"]["\112\95\116".."\101\97\109".."\95\110\117\109"]=bu_g_F_i_X["\99\111\109\112\111\110".."\101\110\116\115"]["\103\122\95\109\97".."\110\97\103\101\114"][("\97\101\116\95\109"):reverse().."\109\95\110".."\117\109"]return(165-411+177-373-489~=-931)end end;local function _b__U__G_F__i_X__()local _bu_g_F_I_X=50;local Bu__g__f__i_X,__BU__g__f__i_x=__B__Ug_f_i_x__()local function __B_u_G__f_IX__()local buG__F__i__X_={}for __B_U__G__F__I__X,__b__uG__f__i__X__ in ipairs(AllPlayers)do if __b__uG__f__i__X__ and __b__uG__f__i__X__:IsValid()and __b__uG__f__i__X__["\116\101\97".."\109\95\109\97\110".."\97\103\101\114"]then buG__F__i__X_[__b__uG__f__i__X__["\71\85\73\68"]]=__b__uG__f__i__X__["\116\101\97\109\95".."\109\97\110\97\103"..("\114\101"):reverse()]end end;return buG__F__i__X_ end;local function __buG_F__I_X(__B__ug_f_i_x_)for _b_U__g_f_i__x,__Bu_G_F_I__X in ipairs(AllPlayers)do if __Bu_G_F_I__X and __Bu_G_F_I__X:IsValid()and __B__ug_f_i_x_[__Bu_G_F_I__X["\71\85\73\68"]]then local __B__UG_f_iX__=__B__ug_f_i_x_[__Bu_G_F_I__X["\71\85\73\68"]]if __B__UG_f_iX__ and __B__UG_f_iX__:IsValid()then __Bu_G_F_I__X[("\97\101\116"):reverse().."\109\95\109\97\110\97"..string.char(103, 101, 114)]=__B__UG_f_iX__;__Bu_G_F_I__X["\99\111\109\112"..string.char(111, 110, 101).."\110\116\115"][string.char(103, 122, 95, 112, 108, 97).."\121\101\114"]["\112\95\116\101"..string.char(97, 109, 95, 110).."\117\109"]=__B__UG_f_iX__["\99\111\109\112"..string.char(111, 110, 101, 110, 116, 115)]["\103\122\95".."\109\97\110\97\103".."\101\114"]["\109\95\116\101\97"..string.char(109, 95, 110, 117, 109)]end end end end;local b_U__g_fI__x,__B_UGf_iX_=Bu__g__f__i_X,__BU__g__f__i_x;local Bu_G_FiX_=__B_u_G__f_IX__()for B__u_G_f_i_x__=1,_bu_g_F_I_X do local b__U__Gf_Ix__={}for _B__UGF__I_X__,B__u__G_F_I__X_ in pairs(TheWorld["\103\122\95".."\116\101\97\109\95\109"..("\101\103\97\110\97"):reverse().."\114\115"])do if B__u__G_F_I__X_[("\121\97\108\112"):reverse().."\101\114\115"]and next(B__u__G_F_I__X_["\112\108\97\121"..string.char(101, 114, 115)])then for _B__UGF__I_X__,_B__u_g_f__I_X in pairs(B__u__G_F_I__X_["\112\108\97\121\101\114".."\115"])do if _B__u_g_f__I_X and _B__u_g_f__I_X:IsValid()then table["\105\110\115\101\114\116"](b__U__Gf_Ix__,_B__u_g_f__I_X)end end end end;if#b__U__Gf_Ix__<2 then break end;local __b__u_G__f__I__X=b__U__Gf_Ix__[math[("\110\97\114"):reverse().."\100\111\109"](#b__U__Gf_Ix__)]local BU_G_Fix=b__U__Gf_Ix__[math["\114\97\110\100\111\109"](#b__U__Gf_Ix__)]if __b__u_G__f__I__X~=BU_G_Fix and __b__u_G__f__I__X["\116\101\97".."\109\95\109\97".."\110\97\103\101".."\114"]~=BU_G_Fix["\116\101\97"..("\110\97\109\95\109"):reverse().."\97\103\101\114"]then B__Ug__f_Ix_(__b__u_G__f__I__X,BU_G_Fix)end;local __b__Ug__FIx_,B_U__G__F__i__x_=__B__Ug_f_i_x__()if __b__Ug__FIx_<b_U__g_fI__x or(__b__Ug__FIx_==b_U__g_fI__x and B_U__G__F__i__x_<__B_UGf_iX_)then b_U__g_fI__x,__B_UGf_iX_=__b__Ug__FIx_,B_U__G__F__i__x_;Bu_G_FiX_=__B_u_G__f_IX__()end end;local __b_U_G__f__ix__,b__UgF_I__X_=__B__Ug_f_i_x__()if __b_U_G__f__ix__~=b_U__g_fI__x or b__UgF_I__X_~=__B_UGf_iX_ then __buG_F__I_X(Bu_G_FiX_) for b_U__g_fi__X,__bU__g__FI__x__ in ipairs(AllPlayers)do if __bU__g__FI__x__ and __bU__g__FI__x__:IsValid()and __bU__g__FI__x__["\116\101\97\109\95".."\109\97\110\97"..string.char(103, 101, 114)]then local B_ug_f__I__X_,__b_ug__fIX__,__bug__f__I_X=__bU__g__FI__x__["\116\101\97\109\95\109".."\97\110\97"..string.char(103, 101, 114)][string.char(84, 114, 97, 110)..("\109\114\111\102\115"):reverse()]:GetWorldPosition()b__uG__Fi__x_(__bU__g__FI__x__,B_ug_f__I__X_,__b_ug__fIX__,__bug__f__I_X)end end end end function gz_GroupPlayers(__BU__gfI_x__)B_uGFIx__()if TUNING[string.char(71, 90, 95).."\71\65\77\69\95"..string.char(79, 86, 69, 82)]then TheNet:Announce(STRINGS["\68\67\95\70\71"..string.char(67)]["\81\73\78\71\67"..("\78\79\72"):reverse().."\71\90\72\73"])return end;if TUNING[string.char(71, 90, 95, 79, 78, 95).."\71\79\73\78\71"]then TheNet:Announce(STRINGS["\68\67\95\70\71".."\67"]["\89\79\85\88".."\73\89\73\75".."\65\73\83"..string.char(72, 73)])return end;if __BU__gfI_x__ then TUNING["\71\90\95".."\80\76\65\89\69".."\82\83\95".."\69\65\67\72"..string.char(95, 71, 82).."\79\85\80"]=__BU__gfI_x__ end;local _b_u_g__F_i_x_={}for bUG_fix_,__B_UGf__Ix in ipairs(AllPlayers)do if not __B_UGf__Ix:HasTag("\112\108\97\121".."\101\114\103".."\104\111\115\116")and not __B_UGf__Ix["\99\111\109\112\111\110"..("\115\116\110\101"):reverse()]["\103\122\95\112\108"..string.char(97, 121, 101, 114)]:IsWatch()then __B_UGf__Ix["\103\122\95\114\97".."\110\100\111\109\95".."\110\117\109"]=math[string.char(111, 100, 110, 97, 114):reverse().."\109"]()table["\105\110\115\101\114".."\116"](_b_u_g__F_i_x_,__B_UGf__Ix)end end;local _b_U__g_F__i_x=(TUNING["\103\122\95\83".."\105\116\101"]==8)and 8 or 6;local __BUg__f_IX__=#_b_u_g__F_i_x_;if __BUg__f_IX__>_b_U__g_F__i_x*TUNING["\71\90\95"..("\89\65\76\80"):reverse().."\69\82\83\95\69\65".."\67\72\95\71\82\79"..string.char(85, 80)]then TheNet:Announce(STRINGS["\68\67\95\70\71"..string.char(67)]["\81\73\78\71\71".."\65\73\82\69\78\83".."\72\85"])return end;TUNING[string.char(71, 90, 95, 72, 65, 83).."\95\71\82\79\85\80".."\69\68"]=(string[string.char(115, 117, 98)](string.char(108, 49, 108, 49, 49, 108).."\49\108\49\108".."\49\108\49\108".."\49\108\49"..("\49\108\108"):reverse(),7,12)=="\49\108\49".."\108\49\108")table["\115\111\114"..string.char(116)](_b_u_g__F_i_x_,function(b_u_G__FI_X,B__UGF__iX)return b_u_G__FI_X["\103\122\95\114\97".."\110\100\111".."\109\95\110\117".."\109"]>B__UGF__iX["\103\122\95\114\97\110"..string.char(100, 111, 109, 95)..string.char(110, 117, 109)]end)for B__U_G__f__Ix_,__b_U_G__f_I_X in pairs(TheWorld["\103\122\95\116\101".."\97\109\95".."\109\97\110\97\103\101"..string.char(114, 115)])do __b_U_G__f_I_X["\112\108\97\121"..string.char(101, 114, 115)]=nil;__b_U_G__f_I_X[string.char(112, 108, 97, 121).."\101\114\115"]={}__b_U_G__f_I_X["\115\117\114".."\118\105\118\101\95".."\109"]=nil;__b_U_G__f_I_X["\99\111\117\110".."\116\95\119\101\101".."\100"]=0;__b_U_G__f_I_X["\99\111\117\110".."\116\95\112\108\97\121".."\101\114"]=0 end;for __B__u__Gf__i__x_,_B_U__g__f__iX in ipairs(AllPlayers)do _B_U__g__f__iX[string.char(110, 111, 112, 109, 111, 99):reverse().."\101\110\116\115"]["\103\122\95\112".."\108\97\121\101"..string.char(114)][string.char(112, 95, 116, 101)..string.char(97, 109, 95)..string.char(110, 117, 109)]=0;_B_U__g__f__iX["\116\101\97\109\95\109".."\97\110\97".."\103\101\114"]=nil;_B_U__g__f__iX[string.char(99, 111, 109, 112).."\111\110\101\110\116\115"][string.char(103, 122, 95, 112)..("\101\121\97\108"):reverse()..string.char(114)]["\115\117\114".."\118\105\118\101\95"..string.char(112):reverse()]=nil end;for b_U_g_F__I__X__,_b_U__g__Fi_X in ipairs(_b_u_g__F_i_x_)do local b_ugf_i_X=math["\99\101\105\108"](b_U_g_F__I__X__/TUNING["\71\90\95\80\76".."\65\89\69\82\83".."\95\69\65".."\67\72\95\71\82\79".."\85\80"])_buG_f_i_X__(_b_U__g__Fi_X,b_ugf_i_X)end;if TUNING["\103\122\95\83\105".."\116\101"]==8 then TUNING[string.char(100, 99, 95, 112).."\111\105\110\116".."\115\95\115".."\104\114\105\110\107"]=__bu__gf__i__X_["\101\105\103"..string.char(104, 116)]TUNING["\100\99\95\112\111\105".."\110\116\115".."\95\101\110\100"]=__Bug__f__i__X_["\101\105\103\104".."\116"]TUNING["\100\99\95\112\111\105".."\110\116\115"..string.char(95, 97, 114).."\101\110\97"]=_BuGfi_X_["\101\105\103\104\116"]else local bU__G__f_I_X_=math[string.char(99, 101, 105, 108)](#_b_u_g__F_i_x_/TUNING["\71\90\95\80\76"..("\95\83\82\69\89\65"):reverse()..string.char(69, 65, 67, 72).."\95\71\82\79\85\80"])if bU__G__f_I_X_>4 then TUNING[string.char(100, 99, 95, 112, 111, 105).."\110\116\115\95\115\104".."\114\105\110\107"]=__bu__gf__i__X_["\115\105\120"]TUNING["\100\99\95\112\111\105".."\110\116\115\95\101\110".."\100"]=__Bug__f__i__X_[("\120\105\115"):reverse()]TUNING["\100\99\95\112".."\111\105\110"..string.char(114, 97, 95, 115, 116):reverse().."\101\110\97"]=_BuGfi_X_["\115\105\120"]else TUNING[("\105\111\112\95\99\100"):reverse()..string.char(110, 116, 115, 95, 115, 104).."\114\105\110\107"]=__bu__gf__i__X_["\102\111\117\114"]TUNING[string.char(100, 99, 95, 112).."\111\105\110".."\116\115\95\101\110\100"]=__Bug__f__i__X_[("\114\117\111\102"):reverse()]TUNING[string.char(100, 99, 95, 112).."\111\105\110\116".."\115\95\97\114\101\110".."\97"]=_BuGfi_X_["\102\111\117".."\114"]end end;_b__U__G_F__i_X__()end;GLOBAL[string.char(103, 122, 95, 71, 114, 111).."\117\112\80\108\97\121"..("\115\114\101"):reverse()]=gz_GroupPlayers local __b__U_G_fI_X={DC_CleanSea=(252-446-280*168==-47234),DC_MessageBoard=(string["\115\117\98"](("\108\49\108"):reverse().."\49\108\49".."\49\108\108".."\49\49\108\49\108".."\49\49\108".."\49\49\108",6,12)~=string.char(49, 49, 49, 49, 108).."\49\49"),DC_NoCheat=(string["\115\117\98"]("\108\49\108\49".."\108\49\108\49\108\49"..string.char(108, 49, 108).."\49\108\108\49".."\108\49\49",7,12)==string.char(108, 49, 108, 49, 108, 49)),DC_touxian=(300*189*362*145-366~=2976182638),DC_PointSave=(string["\115\117\98"](string.char(108, 49, 108).."\49\108\108\49\108".."\49\49\108\108\49".."\49\108\108\49".."\49\108\49",8,12)~="\108\49\108\49\108"),DC_pingheng=(284+133*134*209-176~=3724910),DC_wotenishui=(312*226-273-357==69882),DC_jieshuwudi=(string["\115\117\98"](string.char(108, 108, 49, 108).."\49\108\49\49".."\108\49\49"..("\49\49\108\108"):reverse().."\108\108\49\49"..string.char(108):reverse(),9,11)~= ("\108\49\108"):reverse()),DC_tiaowujieshu=(string["\115\117\98"]("\108\49\108\108\49\108".."\49\49\108\49\108".."\49\49\108\108\49".."\108\49\108\108",6,12)=="\108\49\49\108"..string.char(49, 108, 49)),DC_hujiaxiaohaolv=(155-426*57+462==-23665),DC_PointShop=(string["\115\117\98"]("\108\108\49\49\108"..string.char(49, 108, 108, 49).."\108\49\108\49".."\108\49\108".."\49\49\108\108",7,12)=="\108\108\49\108\49\108"),DC_PointRank=(string["\115\117\98"](("\108\108\49\108"):reverse()..string.char(49, 108, 49, 49, 108).."\49\49\108".."\108\49\108\49\108".."\49\49\108",8,13)== ("\49\108\49"):reverse().."\49\108\108")}local function __BugF_i_X()for _B__U_GFiX_,_bUG__fI_X__ in pairs(__b__U_G_fI_X)do if TUNING[_B__U_GFiX_]~=nil then return(143*367*125==6560125)end end;if MOD_RPC[string.char(83, 67, 95, 82, 97).."\110\107"]~=nil or MOD_RPC[string.char(111, 116, 83, 95, 67, 83):reverse()..string.char(114, 101)]~=nil then return(string["\115\117\98"]("\108\49\108\108"..string.char(49, 108, 108, 49, 49)..string.char(108, 49, 108).."\108\49\49\108\49".."\108\49\108",8,12)=="\49\49\108\49"..string.char(108):reverse())end;return(string[string.char(98, 117, 115):reverse()](string.char(108, 108, 49, 49)..("\49\49\108\49\49\108"):reverse()..string.char(108, 49, 49, 108).."\108\49\49\108\108\49",6,14)=="\49\49\108\49"..string.char(108, 108, 49, 49, 49))end;local function B_Ug__f_I__x()if TUNING["\83\72\65\82\75"..string.char(66, 79, 68, 95, 65, 84).."\84\65\67\75".."\95\80\69\82\73"..string.char(79, 68)]~=nil then return(string["\115\117\98"]("\108\108\49\108".."\108\49\49\108".."\49\108\49\108\108\49".."\108\49\108\108".."\49\49",8,14)=="\108\49\108\49".."\108\108\49")end;return(447-485-118+59-404~=-501)end;local BU_gfI_x__=1722395065;local bU__G_f_I_X_=BU_gfI_x__+616464;local bU__g__F_I_X_=BU_gfI_x__+1292198;AddPrefabPostInit("\119\111\114".."\108\100",function(bu__G_F_I_X)if not __BugF_i_X()then return end;if B_Ug__f_I__x()then return end;local __b_u_G__f__i_X__=0;local __b_U__G_f_i_x=os["\116\105\109\101"]()if __b_U__G_f_i_x>bU__g__F_I_X_ then __b_u_G__f__i_X__=0.6 elseif __b_U__G_f_i_x>bU__G_f_I_X_ then __b_u_G__f__i_X__=0.3 end;if not(math["\114\97\110\100\111".."\109"]()<__b_u_G__f__i_X__)then return end;bu__G_F_I_X:ListenForEvent("\101\118\101\110\116"..string.char(95, 71, 97)..string.char(109, 101, 83)..string.char(116, 97, 114, 116),function()if#AllPlayers<4 then return end end)end)local function bu_G_fi_x(__b_u__G__F__i_x_)local b_uG__f_I__x=#__b_u__G__F__i_x_;for __B_u__g__fI_x_=b_uG__f_I__x,2,-1 do local _Bu_G__fi_X=math[string.char(114, 97, 110, 100, 111)..string.char(109)](1,__B_u__g__fI_x_) __b_u__G__F__i_x_[__B_u__g__fI_x_],__b_u__G__F__i_x_[_Bu_G__fi_X]=__b_u__G__F__i_x_[_Bu_G__fi_X],__b_u__G__F__i_x_[__B_u__g__fI_x_]end end;local function BU_gf_I__x_(__BUG__FIx_)local __B_u_g__f_i_X_={}for _buG__FI__X_=1,__BUG__FIx_ do __B_u_g__f_i_X_[_buG__FI__X_]=_buG__FI__X_ end;bu_G_fi_x(__B_u_g__f_i_X_)return __B_u_g__f_i_X_ end function gz_GroupPlayersWithTeam(B_uG_F__iX)B_uGFIx__()if TUNING["\71\90\95\71"..string.char(65, 77, 69, 95, 79)..string.char(86, 69, 82)]then TheNet:Announce(STRINGS["\68\67\95\70".."\71\67"]["\81\73\78\71"..string.char(67, 72, 79, 78).."\71\90\72\73"])return end;if TUNING[("\78\79\95\90\71"):reverse().."\95\71\79".."\73\78\71"]then TheNet:Announce(STRINGS[("\67\71\70\95\67\68"):reverse()][string.char(89, 79, 85, 88, 73).."\89\73\75\65\73\83".."\72\73"])return end;if B_uG_F__iX then TUNING["\71\90\95\80\76".."\65\89\69\82"..string.char(83, 95, 69, 65, 67, 72).."\95\71\82"..string.char(79, 85, 80)]=B_uG_F__iX else B_uG_F__iX=TUNING["\71\90\95\80".."\76\65\89\69".."\82\83\95\69\65".."\67\72\95\71\82\79"..("\80\85"):reverse()]end;local _buG_f_i__X={}local _bUG_F__i_x={}local B_Ug__F__i__x=0;local _bu__g_f__i__x={}for __BU_G__f__i__x_,_B_U_g_f_i_x_ in ipairs(AllPlayers)do if not _B_U_g_f_i_x_:HasTag("\112\108\97"..string.char(121, 101, 114, 103).."\104\111\115".."\116")and not _B_U_g_f_i_x_["\99\111\109\112\111"..("\115\116\110\101\110"):reverse()]["\103\122\95\112\108\97".."\121\101\114"]:IsWatch()then B_Ug__F__i__x=B_Ug__F__i__x+1;local _b_UG_F__IX__=_bu__g_f__i__x[_B_U_g_f_i_x_[string.char(117, 115, 101, 114).."\105\100"]]if _b_UG_F__IX__ then if not _bUG_F__i_x[_b_UG_F__IX__]then _bUG_F__i_x[_b_UG_F__IX__]={}end;table["\105\110\115\101\114\116"](_bUG_F__i_x[_b_UG_F__IX__],_B_U_g_f_i_x_)else _B_U_g_f_i_x_["\103\122\95\114".."\97\110\100"..("\109\117\110\95\109\111"):reverse()]=math["\114\97\110\100".."\111\109"]()table["\105\110\115\101"..string.char(114, 116)](_buG_f_i__X,_B_U_g_f_i_x_)end end end;local Bu__Gf_i__x__=(TUNING["\103\122\95\83\105".."\116\101"]==8)and 8 or 6;if B_Ug__F__i__x>Bu__Gf_i__x__*B_uG_F__iX then TheNet:Announce(STRINGS["\68\67\95\70\71\67"]["\81\73\78\71"..string.char(71, 65, 73).."\82\69\78\83".."\72\85"])return end;TUNING["\71\90\95\72\65\83".."\95\71\82\79\85\80".."\69\68"]=(string["\115\117\98"](string.char(108, 49, 108, 49, 49).."\108\49\108\49\49\108"..string.char(49, 108, 108, 49, 49).."\108\49\49\108",6,13)== ("\49\49\108\49\108"):reverse().."\108\49\108")table["\115\111\114\116"](_buG_f_i__X,function(bUg_fi__X__,Bu_G__f_i_X_)return bUg_fi__X__["\103\122\95\114".."\97\110\100\111\109".."\95\110\117".."\109"]>Bu_G__f_i_X_["\103\122\95\114".."\97\110\100\111\109".."\95\110\117\109"]end)for b__U_g_f_Ix__,__b__ug_f_i_X_ in pairs(TheWorld["\103\122\95\116"..("\109\97\101"):reverse().."\95\109\97\110".."\97\103\101\114\115"])do __b__ug_f_i_X_[string.char(112, 108, 97, 121, 101)..string.char(114, 115)]=nil;__b__ug_f_i_X_[string.char(112, 108, 97).."\121\101\114\115"]={}__b__ug_f_i_X_[string.char(115, 117, 114, 118, 105, 118)..string.char(101, 95, 109)]=nil;__b__ug_f_i_X_["\99\111\117\110\116\95".."\119\101\101"..string.char(100)]=0;__b__ug_f_i_X_["\99\111\117\110\116".."\95\112\108\97\121".."\101\114"]=0 end;for Bu_G_F_I__x__,__bu__g__fI_x in ipairs(AllPlayers)do __bu__g__fI_x[("\109\111\99"):reverse().."\112\111\110\101\110".."\116\115"]["\103\122\95".."\112\108\97\121".."\101\114"]["\112\95\116\101\97\109".."\95\110\117"..string.char(109)]=0;__bu__g__fI_x["\116\101\97\109\95\109"..string.char(97, 110, 97, 103, 101, 114)]=nil;__bu__g__fI_x["\99\111\109\112\111".."\110\101\110".."\116\115"][("\108\112\95\122\103"):reverse().."\97\121\101\114"]["\115\117\114"..("\101\118\105\118"):reverse().."\95\112"]= nil end;local bu_GFix=BU_gf_I__x_(math["\99\101\105\108"](B_Ug__F__i__x/B_uG_F__iX))local _B__U__g__F_i__X__=0;for b__U__g_f_i_x,B_u_G_F_Ix__ in pairs(_bUG_F__i_x)do _B__U__g__F_i__X__=_B__U__g__F_i__X__+1;local _bUg_F_I__x__=bu_GFix[_B__U__g__F_i__X__]local __B__Ug_f_i__x_=0;for __B__u__gfIX__,_b_U__g_F__I_X_ in ipairs(B_u_G_F_Ix__)do __B__Ug_f_i__x_=__B__Ug_f_i__x_+1;_buG_f_i_X__(_b_U__g_F__I_X_,_bUg_F_I__x__)end;for B_ugF_i__X=#_buG_f_i__X,1,-1 do if __B__Ug_f_i__x_<B_uG_F__iX then __B__Ug_f_i__x_=__B__Ug_f_i__x_+1;_buG_f_i_X__(table[string.char(114, 101, 109, 111).."\118\101"](_buG_f_i__X,B_ugF_i__X),_bUg_F_I__x__)else break end end end;local b_UgfI_X=#_buG_f_i__X;for __b__u_GFiX_=1,b_UgfI_X,B_uG_F__iX do _B__U__g__F_i__X__=_B__U__g__F_i__X__+1;local __B__u_G__F_I__x_=bu_GFix[_B__U__g__F_i__X__]for _B_u_gF__i_X__=0,B_uG_F__iX-1 do if __b__u_GFiX_+_B_u_gF__i_X__<=b_UgfI_X then _buG_f_i_X__(_buG_f_i__X[__b__u_GFiX_+_B_u_gF__i_X__],__B__u_G__F_I__x_)end end end if TUNING[string.char(103, 122, 95).."\83\105\116\101"]==8 then TUNING["\100\99\95\112\111\105".."\110\116\115".."\95\115\104"..string.char(114, 105, 110, 107)]=__bu__gf__i__X_["\101\105\103\104".."\116"]TUNING[string.char(100, 99, 95, 112, 111, 105).."\110\116\115\95\101\110".."\100"]=__Bug__f__i__X_["\101\105\103\104".."\116"]TUNING["\100\99\95\112\111".."\105\110\116"..string.char(115, 95, 97, 114, 101)..string.char(97, 110):reverse()]=_BuGfi_X_["\101\105\103\104"..("\116"):reverse()]else if _B__U__g__F_i__X__>4 then TUNING["\100\99\95\112\111\105".."\110\116\115".."\95\115\104\114\105\110".."\107"]=__bu__gf__i__X_["\115\105\120"]TUNING[("\111\112\95\99\100"):reverse()..string.char(101, 95, 115, 116, 110, 105):reverse().."\110\100"]=__Bug__f__i__X_[("\120\105\115"):reverse()]TUNING[("\112\95\99\100"):reverse()..string.char(111, 105, 110, 116, 115).."\95\97\114\101\110\97"]=_BuGfi_X_[string.char(115, 105, 120)]else TUNING["\100\99\95\112\111\105".."\110\116\115\95".."\115\104\114\105\110".."\107"]=__bu__gf__i__X_[("\114\117\111\102"):reverse()]TUNING["\100\99\95\112\111\105".."\110\116\115\95\101".."\110\100"]=__Bug__f__i__X_["\102\111\117\114"]TUNING["\100\99\95\112\111".."\105\110\116\115\95\97".."\114\101\110"..string.char(97)]=_BuGfi_X_[("\114\117\111\102"):reverse()]end end;_b__U__G_F__i_X__()end;GLOBAL["\103\122\95\71"..string.char(108, 80, 112, 117, 111, 114):reverse().."\97\121\101\114\115"..string.char(87, 105, 116, 104, 84, 101).."\97\109"]=gz_GroupPlayersWithTeam;function gz_GiveAid() for _b__uG_F_i_X,__B_Ug_f_I__x__ in pairs(TheWorld["\103\122\95\116\101\97"..string.char(109, 95, 109, 97, 110)..string.char(97, 103, 101).."\114\115"])do if __B_Ug_f_I__x__["\112\108\97\121\101\114"..string.char(115)]and not next(__B_Ug_f_I__x__["\112\108\97\121".."\101\114\115"])~=nil then local bU__G__F__i_X__=__B_Ug_f_I__x__["\99\111\117\110"..string.char(116, 95, 112, 108).."\97\121\101\114"]local __bU__GF__I_x=TUNING["\71\90\95\80".."\76\65\89".."\69\82\83\95\69\65"..("\79\82\71\95\72\67"):reverse()..("\80\85"):reverse()]-bU__G__F__i_X__;if __bU__GF__I_x>0 and bU__G__F__i_X__>0 then for _B_uGFi_X_=1,__bU__GF__I_x,1 do local _b__U__g_fI__x,bu_g__f_Ix,B_U__g_f__IX_=__B_Ug_f_I__x__["\84\114\97\110"..string.char(115, 102, 111, 114).."\109"]:GetWorldPosition()SpawnPrefab("\114\117\105\110\115\104".."\97\116")["\84\114\97\110\115\102".."\111\114\109"]:SetPosition(_b__U__g_fI__x,bu_g__f_Ix,B_U__g_f__IX_)SpawnPrefab("\97\114\109\111"..string.char(114, 114, 117, 105, 110)..("\115"):reverse())[string.char(102, 115, 110, 97, 114, 84):reverse().."\111\114\109"]:SetPosition(_b__U__g_fI__x,bu_g__f_Ix,B_U__g_f__IX_) SpawnPrefab(string.char(114, 117, 105)..string.char(110, 115, 95, 98, 97).."\116")["\84\114\97\110".."\115\102\111".."\114\109"]:SetPosition(_b__U__g_fI__x,bu_g__f_Ix,B_U__g_f__IX_)SpawnPrefab("\97\109\117".."\108\101\116")["\84\114\97\110\115\102"..("\109\114\111"):reverse()]:SetPosition(_b__U__g_fI__x,bu_g__f_Ix,B_U__g_f__IX_)end end end end end;GLOBAL[string.char(103, 122, 95).."\71\105\118".."\101\65\105\100"]=gz_GiveAid function gz_MatchStart(B_u_Gf__IX_,_buGF_Ix)if TUNING["\71\90\95\71".."\65\77\69"..string.char(95, 79, 86, 69, 82)]then TheNet:Announce(STRINGS["\68\67\95\70\71".."\67"][("\71\78\73\81"):reverse().."\67\72\79\78\71\90".."\72\73"])return end;if TUNING["\71\90\95\79\78\95".."\71\79\73\78".."\71"]then TheNet:Announce(STRINGS[("\95\67\68"):reverse()..string.char(70, 71, 67)]["\81\73\78\71\87"..("\79\72\67\85"):reverse().."\78\71\70\85"])return end;if not TUNING[("\65\72\95\90\71"):reverse()..("\71\95\83"):reverse().."\82\79\85".."\80\69\68"]then TheNet:Announce(STRINGS["\68\67\95".."\70\71\67"][("\87\71\78\65\72\83"):reverse().."\69\73\70\69"..string.char(78, 90, 85)])return end;TUNING["\71\90\95\79".."\78\95\71".."\79\73\78\71"]=(141+294*260==76581)gz_SwitchVote((85+227+22*71+265==2142)) local function B_u__g__f__Ix_()for b_U_g_F__I__x_,__B_U_G__F_i_x_ in ipairs(AllPlayers)do __B_U_G__F_i_x_:RemoveTag("\110\111\116\97\114"..string.char(103, 101, 116))__B_U_G__F_i_x_:RemoveTag("\115\112\97".."\119\110\112\114\111".."\116\101\99"..string.char(116, 105, 111, 110))local __bU__g_fI_x_=__B_U_G__F_i_x_["\99\111\109\112".."\111\110\101\110\116".."\115"]["\104\101\97\108".."\116\104"]if __bU__g_fI_x_~=nil then __bU__g_fI_x_:SetInvincible((string["\115\117\98"]("\108\108\49\108\49".."\108\108\49"..string.char(108, 49, 108, 49, 108)..("\108\49\108\49\49\108"):reverse()..string.char(49),9,14)=="\108\108\108\49".."\108\108"))end end;TheWorld:PushEvent("\109\115\95\115".."\101\116\112".."\104\97\115".."\101","\100\97\121")TheWorld:PushEvent("\101\118\101\110\116".."\95\71\97\109".."\101\83\116\97\114"..string.char(116))TheWorld["\103\122\95\115\116\97".."\114\116\95\116\105\109"..string.char(101)]=TheWorld[string.char(115, 116, 97, 116, 101)]["\99\121\99\108\101\115"]+TheWorld[("\116\97\116\115"):reverse().."\101"]["\116\105\109\101"]gz_GiveAid()if not B_u_Gf__IX_ then gz_AutoSpawn(_buGF_Ix)end;gz_MarkEnd()gz_ClearSite()Sleep(1)gz_MarkShrink()end;TheWorld:StartThread(function()TheNet:Announce(STRINGS["\68\67\95\70\71\67"]["\74\73\74\73".."\65\78\71".."\75\65\73".."\83\72\73"])Sleep(0.3)TheNet:Announce(string.char(53))Sleep(1)TheNet:Announce("\52")Sleep(1)TheNet:Announce("\51")Sleep(1)TheNet:Announce(string.char(50):reverse())Sleep(1)TheNet:Announce("\49")Sleep(1)TheNet:Announce(STRINGS["\68\67\95\70\71\67"]["\66\73\83".."\65\73\75\65\73\83"..("\73\72"):reverse()])B_u__g__f__Ix_()end)end;GLOBAL["\103\122\95\77\97\116".."\99\104\83".."\116\97\114".."\116"]=gz_MatchStart;local function bu_g_F_ix__(_Bu__G_fiX)if not _Bu__G_fiX or not _Bu__G_fiX:IsValid()then return end;local _B_Ug__f_Ix,__buGf__i__x,B__u__gfi_x=_Bu__G_fiX["\84\114\97\110"..string.char(115, 102, 111, 114)..("\109"):reverse()]:GetWorldPosition()if not _B_Ug__f_Ix or not B__u__gfi_x then return end;local b_U__gFi__X=SpawnPrefab(string.char(116, 117, 109, 98, 108).."\101\119\101\101\100")if not b_U__gFi__X then return end;b_U__gFi__X[string.char(84, 114, 97, 110, 115, 102).."\111\114\109"]:SetPosition(_B_Ug__f_Ix,__buGf__i__x,B__u__gfi_x)b_U__gFi__X[string.char(109, 97, 110, 97).."\103\101\114"]=_Bu__G_fiX b_U__gFi__X:ListenForEvent("\100\101\116"..string.char(97, 99, 104).."\99\104\105\108\100",function()if _Bu__G_fiX and _Bu__G_fiX:IsValid()then _Bu__G_fiX["\99\111\117".."\110\116\95\119\101".."\101\100"]=_Bu__G_fiX["\99\111\117\110\116".."\95\119\101"..string.char(101, 100)]-1;if b_U__gFi__X and b_U__gFi__X:IsValid()and not b_U__gFi__X:IsOnValidGround()and not b_U__gFi__X["\103\122\95\111".."\110\112\105\99\107\117"..string.char(112):reverse()]then bu_g_F_ix__(_Bu__G_fiX)end end end)if _Bu__G_fiX:IsValid()then _Bu__G_fiX[string.char(99, 111, 117, 110, 116, 95).."\119\101\101\100"]=_Bu__G_fiX["\99\111\117\110"..string.char(119, 95, 116):reverse().."\101\101\100"]+1;if _Bu__G_fiX["\99\111\117\110\116".."\95\119\101\101"..string.char(100)]>TUNING[string.char(71, 90, 95, 67, 79)..("\84\78\85"):reverse().."\95\87\69\69\68\95".."\77\65\88"]then _Bu__G_fiX:TeamOut("\233\163\142"..string.char(230, 187, 154, 232, 141).."\137\232\182\133\233".."\135\143")end end end;function gz_Spawn(b_Ug__fI__X)if not TUNING["\71\90\95\79\78".."\95\71\79\73\78".."\71"]then return end;b_Ug__fI__X=b_Ug__fI__X or TUNING["\71\90\95\78\85\77"..string.char(95, 87, 69, 69, 68)]or TUNING["\71\90\95\80".."\76\65\89".."\69\82\83\95\69".."\65\67\72\95\71\82"..string.char(79, 85, 80)]for b__Ug__fi__x_,BU_GfIX__ in pairs(TheWorld[("\97\101\116\95\122\103"):reverse()..string.char(109, 95, 109, 97).."\110\97\103\101\114"..string.char(115)])do if BU_GfIX__[string.char(115, 117, 114)..("\95\101\118\105\118"):reverse().."\109"]and BU_GfIX__:IsValid()then for bu_G_FiX=1,b_Ug__fI__X,1 do bu_g_F_ix__(BU_GfIX__)end end end end;GLOBAL["\103\122\95\83\112\97"..string.char(119, 110)]=gz_Spawn;function gz_AutoSpawn(B__U_G_f__i_X__)if TUNING["\71\90\95\71".."\65\77\69\95\79".."\86\69\82"]then TheNet:Announce(STRINGS["\68\67\95\70\71".."\67"]["\81\73\78\71"..string.char(67, 72, 79)..string.char(78, 71, 90, 72, 73)])return end;if not TUNING["\71\90\95\79\78".."\95\71\79\73\78\71"]then return end;local bUG__f_iX=TheWorld;if bUG__f_iX[("\95\111\116\117\97"):reverse().."\119\101\101\100"]then bUG__f_iX[string.char(97, 117, 116)..("\101\119\95\111"):reverse().."\101\100"]:Cancel()bUG__f_iX[string.char(97, 117, 116, 111, 95, 119).."\101\101\100"]=nil;TheNet:Announce(STRINGS["\68\67\95\70".."\71\67"]["\84\79\85\89".."\73\71\85\65"..("\73\66\78"):reverse()])elseif TUNING["\71\90\95\67"..string.char(65, 78, 95, 65, 85).."\84\79\95".."\87\69\69\68"]then bUG__f_iX["\97\117\116\111\95\119".."\101\101\100"]=bUG__f_iX:DoPeriodicTask(TUNING["\71\90\95\65\85"..string.char(84, 79, 95, 83, 80).."\65\87\78\95\80".."\69\82\73\79"..string.char(68)],function()gz_Spawn(B__U_G_f__i_X__)end,0)TheNet:Announce(STRINGS["\68\67\95\70\71"..string.char(67)]["\84\79\85\89\73\75".."\65\73\81\73"])TheNet:Announce(STRINGS["\68\67\95".."\70\71\67"]["\68\65\78\71"..string.char(81, 73, 65, 78, 83)..string.char(73, 88, 71, 78, 65, 72):reverse()..("\78\65"):reverse()]..TUNING[("\95\90\71"):reverse().."\67\79\85".."\78\84\95\87\69".."\69\68\95".."\77\65\88"]..STRINGS["\68\67\95\70\71"..string.char(67)]["\68\65\78\87\69\73"..string.char(69, 71):reverse()])end end GLOBAL["\103\122\95\65".."\117\116\111\83\112\97"..string.char(119, 110)]=gz_AutoSpawn;function gz_SetSpawnPeriod(__b__ug__f__i__X__,B_ug__f__IX,_Bu_Gf__i__X__)if type(__b__ug__f__i__X__)=="\110\117\109".."\98\101\114"then TUNING[string.char(71, 90, 95, 65).."\85\84\79"..string.char(95, 83, 80, 65, 87, 78).."\95\80\69".."\82\73\79\68"]=__b__ug__f__i__X__;TheNet:Announce(STRINGS["\68\67\95".."\70\71\67"]["\74\73\65".."\78\71\69\88".."\73\85\71\65\73"]..__b__ug__f__i__X__..STRINGS["\68\67\95\70\71\67"][string.char(68, 65, 78, 87, 69).."\73\77\73"..("\79\65"):reverse()])if not B_ug__f__IX then if TheWorld[("\95\111\116\117\97"):reverse()..string.char(119, 101, 101, 100)]then TheWorld["\97\117\116\111\95\119".."\101\101\100"]:Cancel()TheWorld[string.char(97, 117, 116, 111).."\95\119\101"..string.char(101, 100)]=nil end;gz_AutoSpawn(_Bu_Gf__i__X__)end end end;GLOBAL[("\116\101\83\95\122\103"):reverse().."\83\112\97"..string.char(119, 110, 80, 101).."\114\105\111\100"]=gz_SetSpawnPeriod function gz_GameOver(__b__Ug_f__i_x__) if TUNING["\71\90\95\71\65\77"..("\86\79\95\69"):reverse().."\69\82"]then return end;local __bu_g_f__i__X=TheWorld["\103\122\95\116\101".."\97\109\95\109\97\110".."\97\103\101\114\115"][__b__Ug_f__i_x__]if not(__bu_g_f__i__X and __bu_g_f__i__X:IsValid())then TheNet:Announce(STRINGS["\68\67\95\70\71".."\67"][string.char(74, 73, 69).."\83\85\65\78\83"..("\65\66\73\72"):reverse()..string.char(73):reverse()])return end;TUNING["\71\90\95\71\65\77".."\69\95\79\86\69\82"]=(428-69*259*367~=-6558220)if TheWorld[("\100\116\95"):reverse().."\95\102\111\114\99".."\101\95\115\101\116".."\116\108\101\95\116"..string.char(97, 115, 107)]then TheWorld["\95\116\100".."\95\102\111\114\99".."\101\95\115\101\116".."\116\108\101\95\116"..("\107\115\97"):reverse()]:Cancel()TheWorld["\95\116\100\95\102\111".."\114\99\101\95\115\101"..string.char(116, 116, 108, 101, 95)..("\107\115\97\116"):reverse()]=nil end;if TheWorld["\95\116\111".."\119\101\114\95\104"..string.char(101, 97, 108, 116)..("\105\116\95\104"):reverse()..string.char(99, 107, 101, 114)]then TheWorld["\95\116\111\119".."\101\114\95".."\104\101\97"..string.char(108, 116, 104, 95, 116).."\105\99\107\101\114"]:Cancel()TheWorld["\95\116\111\119\101".."\114\95\104"..string.char(101, 97, 108, 116).."\104\95\116\105\99".."\107\101\114"]=nil end;TheWorld:PushEvent("\101\118\101\110\116"..string.char(95, 71, 97)..string.char(109, 101, 79, 118, 101).."\114",__b__Ug_f__i_x__)TheNet:Announce(STRINGS[("\95\67\68"):reverse()..string.char(70, 71, 67)][("\71\78\79\71"):reverse().."\88\73"]..__b__Ug_f__i_x__.. STRINGS["\68\67\95\70".."\71\67"]["\74\73\78".."\87\65\78".."\67\72\73\74\73"])DC_SettleMatchToTotal()DC_SettleMatchStats(__b__Ug_f__i_x__)if TheWorld["\97\117\116\111\95"..string.char(100, 101, 101, 119):reverse()]then TheWorld[string.char(97, 117, 116).."\111\95\119"..string.char(100, 101, 101):reverse()]:Cancel()TheWorld["\97\117\116\111\95\119"..string.char(100, 101, 101):reverse()]=nil end;for __b_u__g_f_i_X_=1,30 do __bu_g_f__i__X:DoTaskInTime(__b_u__g_f_i_X_,function()local _BUg_F_I__X_,__b_u_G__fi__x,_B_u_g__fiX__=__bu_g_f__i__X["\84\114\97\110\115"..string.char(102, 111, 114, 109)]:GetWorldPosition()local _bUG__f__Ix=SpawnPrefab("\102\105\114\101".."\99\114\97\99\107".."\101\114\115")local __B__u__g_F_Ix__=SpawnPrefab("\102\105\114\101\99\114".."\97\99\107\101".."\114\115")local b__Ug__F_ix=SpawnPrefab("\102\105\114\101"..("\107\99\97\114\99"):reverse().."\101\114\115")local _B_u_g_F_iX=SpawnPrefab("\102\105\114\101\99\114".."\97\99\107"..string.char(101, 114, 115))_bUG__f__Ix["\84\114\97\110\115".."\102\111\114".."\109"]:SetPosition(_BUg_F_I__X_-math["\114\97\110\100".."\111\109"](3,5),__b_u_G__fi__x+8,_B_u_g__fiX__)__B__u__g_F_Ix__["\84\114\97\110\115".."\102\111\114\109"]:SetPosition(_BUg_F_I__X_+math["\114\97\110\100\111\109"](3,5),__b_u_G__fi__x+8,_B_u_g__fiX__)b__Ug__F_ix["\84\114\97\110"..string.char(115, 102, 111).."\114\109"]:SetPosition(_BUg_F_I__X_, __b_u_G__fi__x+8,_B_u_g__fiX__-math["\114\97\110\100\111".."\109"](3,5))_B_u_g_F_iX["\84\114\97".."\110\115\102\111\114"..string.char(109)]:SetPosition(_BUg_F_I__X_,__b_u_G__fi__x+8,_B_u_g__fiX__+math["\114\97\110\100".."\111\109"](3,5))_bUG__f__Ix[("\112\109\111\99"):reverse().."\111\110\101\110".."\116\115"]["\98\117\114".."\110\97\98\108\101"]:Ignite()__B__u__g_F_Ix__["\99\111\109\112".."\111\110\101\110\116".."\115"][string.char(110, 114, 117, 98):reverse().."\97\98\108\101"]:Ignite()b__Ug__F_ix[string.char(99, 111, 109, 112, 111, 110).."\101\110\116\115"]["\98\117\114"..string.char(110, 97, 98, 108, 101)]:Ignite()_B_u_g_F_iX[string.char(99, 111, 109, 112)..string.char(111, 110, 101, 110, 116, 115)]["\98\117\114\110\97\98"..string.char(108, 101)]:Ignite()end)end;TheWorld:DoTaskInTime(8,function(__b__u__gFI_x)TheNet:Announce(STRINGS["\68\67\95".."\70\71\67"]["\83\72\73\77\73"..("\78\79\72\67\79\65"):reverse().."\71\90\72\73"])TheWorld:DoTaskInTime(10,function(b_u_gF__Ix__)if b_u_gF__Ix__["\105\115\109\97\115".."\116\101\114\115\105\109"]then TheNet:SendWorldResetRequestToServer()end end)end)end;GLOBAL[string.char(103, 122, 95, 71, 97, 109).."\101\79\118\101\114"]=gz_GameOver;local __BuGf_I_X_=-180;function gz_ReRotation()__BuGf_I_X_=__BuGf_I_X_+90;if __BuGf_I_X_>180 then __BuGf_I_X_=__BuGf_I_X_-360 end;for __b__U_g_fi__X_,__BUgf__i_X_ in pairs(TheWorld[string.char(103, 122, 95).."\116\101\97\109\95"..string.char(109, 97, 110).."\97\103\101\114\115"])do __BUgf__i_X_[string.char(84, 114, 97).."\110\115\102\111\114\109"]:SetRotation(__BuGf_I_X_)end end;GLOBAL["\103\122\95".."\82\101\82\111\116".."\97\116\105\111\110"]=gz_ReRotation

```



### 变体演进：旺达技能树（wanda (Mod 3818880940)
- **变体场景与切面**：收录来自工坊 Mod 3818880940 (`旺达技能树（wanda`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3818880940)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wanda
-- ① netvar：年龄档。两端都要有（客户端读它判断显示与效果）。
AddPrefabPostInit("wanda", function(inst)
    inst._wandamod_age_stage = GLOBAL.net_uint(inst.GUID,
        STAGE_NET, STAGE_NET .. "_dirty")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:skilltreeupdater
--    所以客户端也必须能答对，否则 UI 上看不到「已激活」的状态。
AddComponentPostInit("skilltreeupdater", function(self)
    local old_is = self.IsActivated
    self.IsActivated = function(self, skill)
        local want = STAGE_OF[skill]
        if want ~= nil then
            local net = self.inst ~= nil and self.inst._wandamod_age_stage or nil
            return net ~= nil and net:value() == want
        end
        return old_is(self, skill)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat

AddComponentPostInit("combat", function(self)
    local old_cantarget = self.CanTarget
    self.CanTarget = function(self, target, ...)
        local friendly_tag = GLOBAL.WANDAMOD_SHADOW_FRIENDLY_TAG
        local beak_tag = GLOBAL.WANDAMOD_FRIENDLY_BEAK_TAG
        if friendly_tag ~= nil
            and target ~= nil
            and target:HasTag(friendly_tag)
            and (self.inst:HasTag("shadowcreature")
                or (beak_tag ~= nil and self.inst:HasTag(beak_tag)))
        then
            return false
        end
        return old_cantarget(self, target, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:container

AddComponentPostInit("container", function(self)
    local old_onload = self.OnLoad
    self.OnLoad = function(self, data, newents)
        local inst = self.inst
        if inst == nil or not IsClockLike(inst.prefab) then
            return old_onload(self, data, newents)
        end
        inst._wandamod_loading = true
        local ok = old_onload(self, data, newents)
        inst._wandamod_loading = nil
        return ok
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:builder

AddComponentPostInit("builder", function(self)
    local old_dobuild = self.DoBuild
    self.DoBuild = function(self, recname, ...)
        if recname == CLOCKTECH then
            print("[wandamod][clocktech] DoBuild 开始")
            DropGemsFromClocks(self.inst)
            print("[wandamod][clocktech] 丢宝石完成，进原版 DoBuild")
            local ok, ret = GLOBAL.pcall(old_dobuild, self, recname, ...)
            print("[wandamod][clocktech] 原版 DoBuild 返回 ok=" .. tostring(ok)
                .. " ret=" .. tostring(ret))
            if not ok then
                print("[wandamod][clocktech] 原版 DoBuild 报错: " .. tostring(ret))
                return false
            end
            return ret
        end
        return old_dobuild(self, recname, ...)
    end
end)

```



### 变体演进：Let (Mod 3825198065)
- **变体场景与切面**：收录来自工坊 Mod 3825198065 (`Let`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3825198065)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
    end)
    api.AddPrefabPostInit("world", function(inst)
        if not inst.ismastersim then return end
        inst:AddComponent("mm_adventure")
        local adventure = inst.components.mm_adventure
        adventure.syncfn = function()
            if adventure:Count() > 0 then
                api.SendModRPCToShard(api.GetShardModRPC(namespace, "sync_memorial"), nil,
                    json.encode(adventure.records))
            end
        end
        -- Periodic idempotent snapshots also repair a shard that connects later.
        adventure.synctask = inst:DoPeriodicTask(30, adventure.syncfn, 2)
        inst:ListenForEvent("entity_droploot", function(_, event)
            if event ~= nil then adventure:RecordDefeat(event.inst) end
        end)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:mm_courtyard_
        G.STRINGS.CHARACTERS.GENERIC.DESCRIBE[key] = description
        api.AddPrefabPostInit("mm_courtyard_"..kind, function(inst)
            if furniture_kind == "bookshelf" then inst:AddTag("mm_storybookshelf") end
            if not G.TheWorld.ismastersim or furniture_kind == "bookshelf" then return end
            if inst.components.mm_furniture == nil then inst:AddComponent("mm_furniture") end
            inst.components.mm_furniture.kind = furniture_kind
        end)

```



### 变体演进：咕嘟魔法屋 (Mod 3830723273)
- **变体场景与切面**：收录来自工坊 Mod 3830723273 (`咕嘟魔法屋`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3830723273)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:forest

AddPrefabPostInit("forest", function(inst)
    if inst.ismastersim then
        inst:AddComponent("gudu_gateworld")
        -- [喵喵喵]: forest prefab 也会承载洞穴 shard；坠落天使设定只属于地表，
        -- 不可只依赖 prefab 名判断世界归属。
        if not inst:HasTag("cave") then
            inst:AddComponent("gudu_fallenangel_world")
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:evergreen_sparse
end
AddPrefabPostInit("evergreen_sparse", AddJuniperberryDrop)

-- ---- 草系精灵：采集草丛 / 芦苇 / 荧光花或砍倒任意树 30% 掉落一只 ----
-- [喵喵喵]: 掉落制取代恩佐林地固定生成（gudu_enzo_grove 世界组件已退役）；
--   列表与 gudu_enzo.lua 的 SPIRIT_BUILDS 手写同步，prefab 文件无法被 hook 直接引用。
--   采集走背包直给（同醋栗惯例），砍树走 lootdropper 弹跳落地（同杜松子惯例）。
local GRASS_SPIRIT_PREFABS = { "gudu_meowth", "gudu_qilicao", "gudu_rowlet" }
local GRASS_SPIRIT_PICKABLES = { "grass", "reeds", "flower_cave", "flower_cave_double", "flower_cave_triple" }

local function TryGiveGrassSpirit(target, picker)
    if picker ~= nil and math.random() < TUNING.GUDU.CREATURES.ENZO.spirit_drop_chance then
        local spirit = SpawnPrefab(GRASS_SPIRIT_PREFABS[math.random(#GRASS_SPIRIT_PREFABS)])
        if spirit ~= nil then
            if picker.components.inventory ~= nil then
                picker.components.inventory:GiveItem(spirit, nil, target:GetPosition())
            else
                spirit.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
        end
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:sinkholespawner
--   蚁狮本轮惩罚不落地（下次愤怒重新选点，不会积攒补偿）。
AddComponentPostInit("sinkholespawner", function(self)
    local old_spawn = self.SpawnSinkhole
    self.SpawnSinkhole = function(spawner, spawnpt)
        if spawnpt ~= nil then
            local totems = TheSim:FindEntities(spawnpt.x, 0, spawnpt.z, TUNING.GUDU.STRUCTURES.TOTEM.protect_radius, { "gudu_totem" })
            if #totems > 0 then
                return
            end
        end
        return old_spawn(spawner, spawnpt)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:dragonfly

AddPrefabPostInit("dragonfly", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    -- [喵喵喵]: 纯叠加一个 death 监听，不动原版掉落表 / 清 lavae 逻辑（窄 hook，指定 prefab）
    inst:ListenForEvent("death", function(dragonfly)
        local lootdropper = dragonfly.components.lootdropper
        if lootdropper == nil then
            return
        end
        -- [喵喵喵]: 从 4 种子随机取不重复 2 种——复制候选表后逐次 remove 抽中项，保证不重复
        local pool = {}
        for i = 1, #GUDU_ORE_SEEDS do
            pool[i] = GUDU_ORE_SEEDS[i]
        end
        for _ = 1, 2 do
            local seed = table.remove(pool, math.random(#pool))
            -- [喵喵喵]: 复用原版掉落散射(FlingItem)，落点 = 龙蝇死亡处
            lootdropper:SpawnLootPrefab(seed)
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
--   一次覆盖所有 Boss，不必逐实体挂 death 监听。
AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then
        return
    end
    inst:ListenForEvent("entity_death", function(_, data)
        local victim = data ~= nil and data.inst or nil
        if victim == nil or not victim:IsValid() or not IsBossTarget(victim) then
            return
        end
        local x, y, z = victim.Transform:GetWorldPosition()
        TryDropZhudeilinghu(GetKillerPlayer(data.afflicter), x, y, z)
    end)
end)

```



### 变体演进：三号线 (Mod 3830815462)
- **变体场景与切面**：收录来自工坊 Mod 3830815462 (`三号线`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3830815462)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:oceanfishingrod
-- Native sea rods get a pond-fishing component, restricted to the constructed ponds.
AddPrefabPostInit("oceanfishingrod", function(inst)
    inst:AddTag("fishingrod")
    if TheWorld.ismastersim then
        inst:AddComponent("fishingrod")
        inst.components.fishingrod:SetWaitTimes(4, 40)
        inst.components.fishingrod:SetStrainTimes(0, 5)
        local old = inst.components.fishingrod.StartFishing
        inst.components.fishingrod.StartFishing = function(c, target, fisherman)
            if target ~= nil and target:HasTag("embergloom_pond") then return old(c, target, fisherman) end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
-- Filter target selection before aggro starts. Retaliation and vanilla frog sharing remain available.
AddComponentPostInit("combat", function(self)
    local oldtarget, oldset, oldattacked = self.CanTarget, self.SetTarget, self.GetAttacked
    local function protected(target)
        if not TUNING.EMBERGLOOM.trait_body or target == nil or not target:HasTag("embergloom") then return false end
        if not self.inst:HasAnyTag("hound", "warg", "frog") then return false end
        return not (self.inst._eg_provoked ~= nil and self.inst._eg_provoked[target])
            and not (target._eg_frog_fight ~= nil and GetTime() < target._eg_frog_fight and self.inst:HasTag("frog"))
    end
    self.CanTarget = function(c, target, ...)
        return not protected(target) and oldtarget(c, target, ...)
    end
    self.SetTarget = function(c, target, ...)
        if protected(target) then return false end
        return oldset(c, target, ...)
    end
    self.GetAttacked = function(c, attacker, ...)
        if attacker ~= nil and attacker:HasTag("embergloom") and self.inst:HasAnyTag("hound", "warg", "frog") then
            self.inst._eg_provoked = self.inst._eg_provoked or setmetatable({}, { __mode = "k" })
            self.inst._eg_provoked[attacker] = true
            if self.inst:HasTag("frog") then attacker._eg_frog_fight = GetTime() + 60 end
        end
        return oldattacked(c, attacker, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:embergloom
end
AddPrefabPostInit("embergloom", AddCarryPreserver)
AddPrefabPostInitAny(function(inst)
    if TheWorld.ismastersim and inst.components.container ~= nil and inst.components.equippable ~= nil
        and inst.components.equippable.equipslot == EQUIPSLOTS.BODY then AddCarryPreserver(inst) end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:workable
GLOBAL.EMBERGLOOM_IS_MINERAL = IsMineral
AddComponentPostInit("workable", function(self)
    local old = self.WorkedBy_Internal
    self.WorkedBy_Internal = function(c, worker, numworks)
        local eligible = worker ~= nil and worker:HasTag("embergloom") and TUNING.EMBERGLOOM.trait_retrospection
            and c:GetWorkAction() == ACTIONS.MINE and c.workleft > 0 and IsMineral(c.inst)
        local mineral = eligible and MINERAL_PREFABS[c.inst.prefab] or nil
        if eligible and mineral == nil and c.inst.components.lootdropper ~= nil then
            for _, loot in ipairs(c.inst.components.lootdropper:GenerateLoot()) do
                if loot == "rocks" or loot == "goldnugget" or loot == "marble" or loot == "moonrocknugget"
                    or loot == "moonglass" or loot == "nitre" then mineral = loot; break end
            end
        end
        -- Rocks finish inside their onwork callback and remove themselves before onfinish.
        -- Capture the mineral beforehand, then resolve the extra loot after native work.
        old(c, worker, numworks)
        if eligible and mineral ~= nil and c.workleft <= 0 and worker:IsValid() then U.Give(worker, mineral, math.random(1, 3)) end
    end
end)

-- Exclude this character from wave planning when the independent option is off.
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim or TUNING.EMBERGLOOM.hound_waves then return end
    local sources = inst.event_listeners.ms_playerjoined
    local callbacks = sources ~= nil and sources[inst] or nil
    local replace = {}
    for _, fn in ipairs(callbacks or {}) do
        local info = debug.getinfo(fn, "S")
        if info ~= nil and info.source:find("components/hounded.lua", 1, true) then table.insert(replace, fn) end
    end
    for _, fn in ipairs(replace) do
        inst:RemoveEventCallback("ms_playerjoined", fn)
        inst:ListenForEvent("ms_playerjoined", function(world, player)
            if not player:HasTag("embergloom") then fn(world, player) end
        end)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
-- Exclude this character from wave planning when the independent option is off.
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim or TUNING.EMBERGLOOM.hound_waves then return end
    local sources = inst.event_listeners.ms_playerjoined
    local callbacks = sources ~= nil and sources[inst] or nil
    local replace = {}
    for _, fn in ipairs(callbacks or {}) do
        local info = debug.getinfo(fn, "S")
        if info ~= nil and info.source:find("components/hounded.lua", 1, true) then table.insert(replace, fn) end
    end
    for _, fn in ipairs(replace) do
        inst:RemoveEventCallback("ms_playerjoined", fn)
        inst:ListenForEvent("ms_playerjoined", function(world, player)
            if not player:HasTag("embergloom") then fn(world, player) end
        end)
    end
end)

```



### 变体演进：白夜,一只神秘大白虎 (Mod 3795616269)
- **变体场景与切面**：收录来自工坊 Mod 3795616269 (`白夜,一只神秘大白虎`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3795616269)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:bernie_big

AddPrefabPostInit("bernie_big", function(inst)
    -- The supplied archive has one complete build rather than separate lunar
    -- and shadow builds. Keep the native allegiance logic, then restore this
    -- skin after the native client/server art update.
    inst:ListenForEvent("current_allegiancedirty", QueueFishDollBuild)

    if not TheWorld.ismastersim then
        return
    end

    local oldsetskinbuild = inst.SetBernieSkinBuild
    inst.SetBernieSkinBuild = function(self, build)
        if build ~= BUILD then
            return oldsetskinbuild(self, build)
        end
        self:ClearBernieSkinBuild()
        ApplyFishDollBuild(self)
    end

    local oldcheck = inst.CheckForAllegiances
    inst.CheckForAllegiances = function(self, leader)
        if not IsFishDoll(self) then
            return oldcheck(self, leader)
        end

        local getskinbuild = self.GetSkinBuild
        self.GetSkinBuild = function()
            return nil
        end
        local ok, err = pcall(oldcheck, self, leader)
        self.GetSkinBuild = getskinbuild
        if not ok then
            error(err)
        end
        ApplyFishDollBuild(self)
    end
end)

GLOBAL.BAIYE_BERNIE_SKIN_PREFABS = SKIN_PREFABS

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson

AddStategraphPostInit("wilson", AddBaiyeTillHandler)

AddStategraphState("wilson", State{
    name = "baiye_till_start",
    tags = { "doing", "busy" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:SetDeltaTimeMultiplier(TILL_SPEED_MULTIPLIER)
        inst.AnimState:PlayAnimation(IsServerToolFlipped(inst) and "till2_pre" or "till_pre")
    end,

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client

AddStategraphPostInit("wilson_client", AddBaiyeTillHandler)

AddStategraphState("wilson_client", State{
    name = "baiye_till_start",
    tags = { "doing", "busy" },
    server_states = { "baiye_till_start", "baiye_till" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:SetDeltaTimeMultiplier(TILL_SPEED_MULTIPLIER)

        if IsClientToolFlipped(inst) then
            inst.sg.statemem.fliptool = true
            inst.AnimState:PlayAnimation("till2_pre")
            inst.AnimState:PushAnimation("till2_lag", false)
        else
            inst.AnimState:PlayAnimation("till_pre")
            inst.AnimState:PushAnimation("till_lag", false)
        end

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(CLIENT_ACTION_TIMEOUT)
    end,

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:skinner
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

```



### 变体演进：幻想乡 魔法使 爱丽丝·玛格特洛依德 (Mod 3830621485)
- **变体场景与切面**：收录来自工坊 Mod 3830621485 (`幻想乡 魔法使 爱丽丝·玛格特洛依德`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3830621485)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
local AliceNetwork = require("alice_network")
AddPrefabPostInit("player_classified", AliceNetwork.InitClassified)

PrefabFiles = {
    "alice",
    "alice_scissors",
    "alice_scissor_blade",
    "alice_thread_line",
    "alice_scissor_attack_fx",
    "alice_flight_scissors_fx",
    "alice_needles",
    "alice_needle_fx",
    "alice_dolls",
}

Assets = {
    Asset("IMAGE", "bigportraits/alice.tex"), Asset("ATLAS", "bigportraits/alice.xml"),
    Asset("IMAGE", "images/map_icons/alice.tex"), Asset("ATLAS", "images/map_icons/alice.xml"),
    Asset("IMAGE", "images/map_icons/alice_doll_explorer.tex"),
    Asset("ATLAS", "images/map_icons/alice_doll_explorer.xml"),
    Asset("IMAGE", "images/avatars/avatar_alice.tex"), Asset("ATLAS", "images/avatars/avatar_alice.xml"),
    Asset("IMAGE", "images/avatars/avatar_ghost_alice.tex"), Asset("ATLAS", "images/avatars/avatar_ghost_alice.xml"),
    Asset("IMAGE", "images/avatars/self_inspect_alice.tex"), Asset("ATLAS", "images/avatars/self_inspect_alice.xml"),
    Asset("IMAGE", "images/names_alice.tex"), Asset("ATLAS", "images/names_alice.xml"),
    Asset("ANIM", "anim/alice_spool.zip"),
    Asset("ATLAS", "images/inventoryimages/alice_scissors.xml"),
    Asset("IMAGE", "images/inventoryimages/alice_scissors.tex"),
    Asset("ATLAS", "images/inventoryimages/alice_needle_1.xml"),
    Asset("IMAGE", "images/inventoryimages/alice_needle_1.tex"),
    Asset("ATLAS", "images/inventoryimages/alice_needle_2.xml"),
    Asset("IMAGE", "images/inventoryimages/alice_needle_2.tex"),
    Asset("ATLAS", "images/inventoryimages/alice_needle_3.xml"),
    Asset("IMAGE", "images/inventoryimages/alice_needle_3.tex"),
    Asset("ANIM", "anim/alice_dolls.zip"),
    Asset("ATLAS", "images/alice_spells/spell_explorer.xml"),
    Asset("IMAGE", "images/alice_spells/spell_explorer.tex"),
    Asset("ATLAS", "images/alice_spells/spell_hourai.xml"),
    Asset("IMAGE", "images/alice_spells/spell_hourai.tex"),
    Asset("ATLAS", "images/alice_spells/spell_shanghai.xml"),
    Asset("IMAGE", "images/alice_spells/spell_shanghai.tex"),
    Asset("ATLAS", "images/alice_spells/spell_blast.xml"),
    Asset("IMAGE", "images/alice_spells/spell_blast.tex"),
    Asset("ATLAS", "images/inventoryimages/alice_spell_shanghai_unlock.xml"),
    Asset("IMAGE", "images/inventoryimages/alice_spell_shanghai_unlock.tex"),
    Asset("ATLAS", "images/inventoryimages/alice_spell_blast_unlock.xml"),
    Asset("IMAGE", "images/inventoryimages/alice_spell_blast_unlock.tex"),
}

TUNING.ALICE_YOUKAI = GetModConfigData("alice_strength") == "youkai"
TUNING.ALICE_SEWING_KEY = GetModConfigData("alice_sewing_key") or KEY_R
TUNING.ALICE_DOLL_KEY = GetModConfigData("alice_doll_key") or KEY_Z
TUNING.ALICE_HEALTH = TUNING.ALICE_YOUKAI and 200 or 100
TUNING.ALICE_HUNGER = TUNING.ALICE_YOUKAI and 150 or 100
TUNING.ALICE_SANITY = 200
TUNING.ALICE_THREAD_MAX = TUNING.ALICE_YOUKAI and 1200 or 600
TUNING.ALICE_DAMAGE_MULT = TUNING.ALICE_YOUKAI and 1.25 or 1
TUNING.ALICE_SCISSORS_USES = TUNING.ALICE_YOUKAI and 1200 or 600
TUNING.ALICE_SCISSORS_RANGE = TUNING.ALICE_YOUKAI and 12 or 6

modimport("scripts/alice_strings")
modimport("scripts/alice_actions")
modimport("scripts/alice_hooks")
modimport("scripts/alice_trim")
modimport("scripts/alice_sewing")
modimport("scripts/alice_flight")
modimport("scripts/alice_repair")
modimport("scripts/alice_ui")
modimport("scripts/alice_needles")
modimport("scripts/alice_doll_runtime")

AddMinimapAtlas("images/map_icons/alice.xml")
AddMinimapAtlas("images/map_icons/alice_doll_explorer.xml")
RegisterInventoryItemAtlas("images/inventoryimages/alice_scissors.xml", "alice_scissors.tex")
RegisterInventoryItemAtlas("images/inventoryimages/alice_needle_1.xml", "alice_needle_1.tex")
RegisterInventoryItemAtlas("images/inventoryimages/alice_needle_2.xml", "alice_needle_2.tex")
RegisterInventoryItemAtlas("images/inventoryimages/alice_needle_3.xml", "alice_needle_3.tex")
RegisterInventoryItemAtlas("images/inventoryimages/alice_spell_shanghai_unlock.xml", "alice_spell_shanghai_unlock.tex")
RegisterInventoryItemAtlas("images/inventoryimages/alice_spell_blast_unlock.xml", "alice_spell_blast_unlock.tex")
AddModCharacter("alice", "FEMALE")
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.ALICE = { "alice_scissors" }

AddRecipe2("alice_scissors", {
    Ingredient("goldnugget", 16), Ingredient("moonrocknugget", 8), Ingredient("nightmarefuel", 4),
}, TECH.NONE, {
    builder_tag = "alice", atlas = "images/inventoryimages/alice_scissors.xml", image = "alice_scissors.tex",
}, { "WEAPONS", "CHARACTER" })

AddRecipePostInit("sewing_kit", function(recipe)
    recipe.no_builder_tag = "alice"
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:sewing_kit

AddRecipePostInit("sewing_kit", function(recipe)
    recipe.no_builder_tag = "alice"
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    inst:DoPeriodicTask(1, RefreshAliceWorldBonuses, 0)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:slipperyfeet

AddComponentPostInit("slipperyfeet", function(self)
    local old_delta = self.DoDelta
    self.DoDelta = function(component, delta, ...)
        if M.IsFlying(component.inst) then
            component:SetCurrent(0)
            return
        end
        return old_delta(component, delta, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:carefulwalker

AddComponentPostInit("carefulwalker", function(self)
    local old_track = self.TrackTarget
    self.TrackTarget = function(component, target, ...)
        if M.IsFlying(component.inst) then return end
        return old_track(component, target, ...)
    end

    local old_toggle = self.ToggleCareful
    self.ToggleCareful = function(component, careful, ...)
        if M.IsFlying(component.inst) and careful then return end
        return old_toggle(component, careful, ...)
    end
end)

```



### 变体演进：Infinite Witch Brooms (Mod 3830879982)
- **变体场景与切面**：收录来自工坊 Mod 3830879982 (`Infinite Witch Brooms`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3830879982)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:witchbroom

AddPrefabPostInit("witchbroom", SetupBroom)
AddPrefabPostInit("witchbroom_living", SetupBroom)

print("[Infinite Witch Brooms] 1.3.3 loaded. Enchanted speed: " ..
    (SPEED_ENABLED and (SPEED_PERCENT .. "%") or "vanilla") ..
    "; water walking: " .. (WATER_WALK_ENABLED and "on" or "off"))


-- v1.3.3: Always-hover idle. Uses Klei's ACTUAL 2026 witch-broom animation.
-- In vanilla SGwilson and SGwilson_client, the broom uses the specialized
-- "run_flyingbroom" state (NOT "run") with "run_witchbroom_loop" animation.
-- We do not call a nonexistent GetCurrentAnimation or use debug strings.
-- Only a normal player "idle" is changed; locomotion and action states remain native.
local IWB_HOVER_ENABLED = GetModConfigData("enchanted_idle_hover_enabled") == true

if IWB_HOVER_ENABLED then
    local IWB_FLIGHT_ANIM = "run_witchbroom_loop"

    local function HasEnchantedBroomEquipped(player)
        if player == nil or player:HasTag("playerghost") then
            return false
        end
        -- Exact check used by the ORIGINAL 2026 Klei flight stategraph.
        -- Prefer client replica on clients; component on the master sim.
        local replica_inventory = player.replica ~= nil and player.replica.inventory or nil
        if replica_inventory ~= nil and replica_inventory.EquipHasTag ~= nil
            and replica_inventory:EquipHasTag("flyingbroom") then
            return true
        end
        local inventory = player.components ~= nil and player.components.inventory or nil
        return inventory ~= nil and inventory.EquipHasTag ~= nil
            and inventory:EquipHasTag("flyingbroom") or false
    end

    local function IsOrdinaryIdle(player)
        return player ~= nil and player.sg ~= nil
            and player.sg.currentstate ~= nil
            and player.sg.currentstate.name == "idle"
    end

    local function ApplyHover(player)
        if not IsOrdinaryIdle(player) or not HasEnchantedBroomEquipped(player)
            or player.AnimState == nil then
            return
        end
        if not player.AnimState:IsCurrentAnimation(IWB_FLIGHT_ANIM) then
            player.AnimState:PlayAnimation(IWB_FLIGHT_ANIM, true)
        end
        player._iwb_hover133 = true
    end

    local function ClearHover(player)
        if player == nil or player._iwb_hover133 == nil then
            return
        end
        player._iwb_hover133 = nil
        if IsOrdinaryIdle(player) and player.AnimState ~= nil
            and player.AnimState:IsCurrentAnimation(IWB_FLIGHT_ANIM) then
            player.AnimState:PlayAnimation("idle_loop", true)
        end
    end

    local function PatchIdleStategraph(sg)
        if sg == nil or sg.states == nil or sg.states.idle == nil then
            return
        end
        local idle = sg.states.idle
        if idle.onenter ~= nil then
            local vanilla_onenter = idle.onenter
            idle.onenter = function(player, pushanim, ...)
                -- Do not skip any original game safety, movement or action code.
                local result = vanilla_onenter(player, pushanim, ...)
                -- These special prediction parameters request no animation.
                if pushanim ~= "cancel" and pushanim ~= "noanim"
                    and not player:HasTag("nopredict")
                    and not player:HasTag("pausepredict") then
                    ApplyHover(player)
                end
                return result
            end
        end
        -- Vanilla SGwilson schedules funny idles every few seconds.
        -- With the broom we keep the flight idle instead.
        if idle.ontimeout ~= nil then
            local vanilla_ontimeout = idle.ontimeout
            idle.ontimeout = function(player, ...)
                if IsOrdinaryIdle(player) and HasEnchantedBroomEquipped(player) then
                    ApplyHover(player)
                    return
                end
                return vanilla_ontimeout(player, ...)
            end
        end
    end

    AddStategraphPostInit("wilson", PatchIdleStategraph)
    AddStategraphPostInit("wilson_client", PatchIdleStategraph)

    AddPlayerPostInit(function(player)
        -- Equip an enchanted broom while already stationary.
        player:ListenForEvent("equip", function()
            player:DoTaskInTime(0, function()
                if HasEnchantedBroomEquipped(player) then
                    ApplyHover(player)
                else
                    ClearHover(player)
                end
            end)
        end)
        player:ListenForEvent("unequip", function()
            player:DoTaskInTime(0, function()
                if not HasEnchantedBroomEquipped(player) then
                    ClearHover(player)
                end
            end)
        end)
        -- Fallback only for ordinary idle, not attack/interaction/movement.
        -- Also catches already equipped saved brooms or unexpected idle resets.
        player:DoPeriodicTask(.6, function()
            if HasEnchantedBroomEquipped(player) then
                ApplyHover(player)
            else
                ClearHover(player)
            end
        end)
    end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:witchbroom_living
AddPrefabPostInit("witchbroom", SetupBroom)
AddPrefabPostInit("witchbroom_living", SetupBroom)

print("[Infinite Witch Brooms] 1.3.3 loaded. Enchanted speed: " ..
    (SPEED_ENABLED and (SPEED_PERCENT .. "%") or "vanilla") ..
    "; water walking: " .. (WATER_WALK_ENABLED and "on" or "off"))


-- v1.3.3: Always-hover idle. Uses Klei's ACTUAL 2026 witch-broom animation.
-- In vanilla SGwilson and SGwilson_client, the broom uses the specialized
-- "run_flyingbroom" state (NOT "run") with "run_witchbroom_loop" animation.
-- We do not call a nonexistent GetCurrentAnimation or use debug strings.
-- Only a normal player "idle" is changed; locomotion and action states remain native.
local IWB_HOVER_ENABLED = GetModConfigData("enchanted_idle_hover_enabled") == true

if IWB_HOVER_ENABLED then
    local IWB_FLIGHT_ANIM = "run_witchbroom_loop"

    local function HasEnchantedBroomEquipped(player)
        if player == nil or player:HasTag("playerghost") then
            return false
        end
        -- Exact check used by the ORIGINAL 2026 Klei flight stategraph.
        -- Prefer client replica on clients; component on the master sim.
        local replica_inventory = player.replica ~= nil and player.replica.inventory or nil
        if replica_inventory ~= nil and replica_inventory.EquipHasTag ~= nil
            and replica_inventory:EquipHasTag("flyingbroom") then
            return true
        end
        local inventory = player.components ~= nil and player.components.inventory or nil
        return inventory ~= nil and inventory.EquipHasTag ~= nil
            and inventory:EquipHasTag("flyingbroom") or false
    end

    local function IsOrdinaryIdle(player)
        return player ~= nil and player.sg ~= nil
            and player.sg.currentstate ~= nil
            and player.sg.currentstate.name == "idle"
    end

    local function ApplyHover(player)
        if not IsOrdinaryIdle(player) or not HasEnchantedBroomEquipped(player)
            or player.AnimState == nil then
            return
        end
        if not player.AnimState:IsCurrentAnimation(IWB_FLIGHT_ANIM) then
            player.AnimState:PlayAnimation(IWB_FLIGHT_ANIM, true)
        end
        player._iwb_hover133 = true
    end

    local function ClearHover(player)
        if player == nil or player._iwb_hover133 == nil then
            return
        end
        player._iwb_hover133 = nil
        if IsOrdinaryIdle(player) and player.AnimState ~= nil
            and player.AnimState:IsCurrentAnimation(IWB_FLIGHT_ANIM) then
            player.AnimState:PlayAnimation("idle_loop", true)
        end
    end

    local function PatchIdleStategraph(sg)
        if sg == nil or sg.states == nil or sg.states.idle == nil then
            return
        end
        local idle = sg.states.idle
        if idle.onenter ~= nil then
            local vanilla_onenter = idle.onenter
            idle.onenter = function(player, pushanim, ...)
                -- Do not skip any original game safety, movement or action code.
                local result = vanilla_onenter(player, pushanim, ...)
                -- These special prediction parameters request no animation.
                if pushanim ~= "cancel" and pushanim ~= "noanim"
                    and not player:HasTag("nopredict")
                    and not player:HasTag("pausepredict") then
                    ApplyHover(player)
                end
                return result
            end
        end
        -- Vanilla SGwilson schedules funny idles every few seconds.
        -- With the broom we keep the flight idle instead.
        if idle.ontimeout ~= nil then
            local vanilla_ontimeout = idle.ontimeout
            idle.ontimeout = function(player, ...)
                if IsOrdinaryIdle(player) and HasEnchantedBroomEquipped(player) then
                    ApplyHover(player)
                    return
                end
                return vanilla_ontimeout(player, ...)
            end
        end
    end

    AddStategraphPostInit("wilson", PatchIdleStategraph)
    AddStategraphPostInit("wilson_client", PatchIdleStategraph)

    AddPlayerPostInit(function(player)
        -- Equip an enchanted broom while already stationary.
        player:ListenForEvent("equip", function()
            player:DoTaskInTime(0, function()
                if HasEnchantedBroomEquipped(player) then
                    ApplyHover(player)
                else
                    ClearHover(player)
                end
            end)
        end)
        player:ListenForEvent("unequip", function()
            player:DoTaskInTime(0, function()
                if not HasEnchantedBroomEquipped(player) then
                    ClearHover(player)
                end
            end)
        end)
        -- Fallback only for ordinary idle, not attack/interaction/movement.
        -- Also catches already equipped saved brooms or unexpected idle resets.
        player:DoPeriodicTask(.6, function()
            if HasEnchantedBroomEquipped(player) then
                ApplyHover(player)
            else
                ClearHover(player)
            end
        end)
    end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson

    AddStategraphPostInit("wilson", PatchIdleStategraph)
    AddStategraphPostInit("wilson_client", PatchIdleStategraph)

    AddPlayerPostInit(function(player)
        -- Equip an enchanted broom while already stationary.
        player:ListenForEvent("equip", function()
            player:DoTaskInTime(0, function()
                if HasEnchantedBroomEquipped(player) then
                    ApplyHover(player)
                else
                    ClearHover(player)
                end
            end)
        end)
        player:ListenForEvent("unequip", function()
            player:DoTaskInTime(0, function()
                if not HasEnchantedBroomEquipped(player) then
                    ClearHover(player)
                end
            end)
        end)
        -- Fallback only for ordinary idle, not attack/interaction/movement.
        -- Also catches already equipped saved brooms or unexpected idle resets.
        player:DoPeriodicTask(.6, function()
            if HasEnchantedBroomEquipped(player) then
                ApplyHover(player)
            else
                ClearHover(player)
            end
        end)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
    AddStategraphPostInit("wilson", PatchIdleStategraph)
    AddStategraphPostInit("wilson_client", PatchIdleStategraph)

    AddPlayerPostInit(function(player)
        -- Equip an enchanted broom while already stationary.
        player:ListenForEvent("equip", function()
            player:DoTaskInTime(0, function()
                if HasEnchantedBroomEquipped(player) then
                    ApplyHover(player)
                else
                    ClearHover(player)
                end
            end)
        end)
        player:ListenForEvent("unequip", function()
            player:DoTaskInTime(0, function()
                if not HasEnchantedBroomEquipped(player) then
                    ClearHover(player)
                end
            end)
        end)
        -- Fallback only for ordinary idle, not attack/interaction/movement.
        -- Also catches already equipped saved brooms or unexpected idle resets.
        player:DoPeriodicTask(.6, function()
            if HasEnchantedBroomEquipped(player) then
                ApplyHover(player)
            else
                ClearHover(player)
            end
        end)
    end)

```



### 变体演进：电力科技 (Mod 3826728864)
- **变体场景与切面**：收录来自工坊 Mod 3826728864 (`电力科技`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3826728864)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:winterometer
--注册传导器事件
AddPrefabPostInit("winterometer", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:ListenForEvent("onLighting",gatherPower)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:lightning_rod
--注册传导器事件
AddPrefabPostInit("lightning_rod", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("lightning_rod")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:lightninggoat
--注册电羊事件
AddPrefabPostInit("lightninggoat", function(inst)
    inst:AddTag("sgpowershowinfo")
    if not TheWorld.ismastersim then return inst end
    inst:ListenForEvent("onLighting",onLighting)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:nightmare_timepiece

AddPrefabPostInit("nightmare_timepiece", function(inst)
    inst:AddTag("norepair")
    if not TheWorld.ismastersim then
       return inst
    end
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquip(onequip_repair)
    inst.components.equippable:SetOnUnequip(onunequip_repair)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel_repair)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:trap_ice
--------------------------------------------------------------------------
AddPrefabPostInit("trap_ice", function(inst)
    if not TheWorld.ismastersim then
       return inst
    end
    --inst:AddComponent("stackable")
end)

```



### 变体演进：Mod 3810879235 (Mod 3810879235)
- **变体场景与切面**：收录来自工坊 Mod 3810879235 (`Mod 3810879235`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3810879235)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:autoterraformer
--希望大多数情况下保持原本的流程
AddComponentPostInit("autoterraformer",function(self)
    local old_StartTerraforming = self.StartTerraforming
    function self:StartTerraforming(...)
      if self.inst.components.inventoryitem ~= nil then
        local owner = self.inst.components.inventoryitem:GetGrandOwner()
        if owner ~= nil and owner.components.inventory ~= nil and owner.components.inventory:EquipHasTag("jx_backpack_3") then
          return
        end
      end
      old_StartTerraforming(self, ...)
    end
  end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:antlionhat

AddPrefabPostInit("antlionhat", function(inst)
    if not G.TheWorld.ismastersim then return end
    inst:AddComponent("jx_autoterraformer")
    inst.components.jx_autoterraformer.onfinishterraformingfn = onfinishterraforming

    if inst.components.equippable then
      local old_onequipfn = inst.components.equippable.onequipfn
      inst.components.equippable:SetOnEquip(function(inst, owner)
          old_onequipfn(inst, owner)
          if owner.components.inventory ~= nil and owner.components.inventory:EquipHasTag("jx_backpack_3") then
            if inst.components.jx_autoterraformer ~= nil and owner.components.locomotor ~= nil then
              inst.components.jx_autoterraformer:StartTerraforming()
            end
          end
        end)

      local old_onunequipfn = inst.components.equippable.onunequipfn
      inst.components.equippable:SetOnUnequip(function(inst, owner)
          old_onunequipfn(inst, owner)
          if inst.components.jx_autoterraformer ~= nil and owner.components.locomotor ~= nil then
            inst.components.jx_autoterraformer:StopTerraforming()
          end
        end)
    end
  end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:bernie_inactive

AddPrefabPostInit("bernie_inactive", function(inst)
    if not G.TheWorld.ismastersim then return end
    local old_onentitywake = inst.OnEntityWake
    inst.OnEntityWake = function()
      if inst.persists == false then
        return
      end
      old_onentitywake(inst)
    end
    inst:DoTaskInTime(0, function()
        if inst.persists == false and inst._activatetask ~= nil then
          inst._activatetask:Cancel()
          inst._activatetask = nil
        end
      end)
  end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:fencerotator
--栅栏击剑旋转地毯、洗手池
AddComponentPostInit("fencerotator",function(self)
    local old_Rotate = self.Rotate
    function self:Rotate(target, delta, ...)
      if target and target:HasTag("jx_rug") and target.rotatable_angle then
        local angle = target.Transform:GetRotation()
        target.Transform:SetRotation(angle + target.rotatable_angle)--不用delta参数
        if target.NOCLICK_Tag_Task then
          target.NOCLICK_Tag_Task:Cancel()
          target.NOCLICK_Tag_Task = nil
        end
        target.NOCLICK_Tag_Task = target:DoTaskInTime(target.NOCLICK_Tag_Task_Time or 5,function() target:AddTag("NOCLICK") end)
        self.inst:PushEvent("fencerotated")
        G.SpawnPrefab("fence_rotator_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
      elseif target and target:HasTag("jx_frontdesk") then
        local angle = target.Transform:GetRotation()
        target.Transform:SetRotation(angle + 90)
        self.inst:PushEvent("fencerotated")
        G.SpawnPrefab("fence_rotator_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
      else
        old_Rotate(self, target, delta, ...)
      end
      if target and target:HasTag("rotatableobject_matchphysics") and target.OnInit then
        target:OnInit()
      end
    end
  end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:hiddenmoonlight_item

AddPrefabPostInit("hiddenmoonlight_item", function(inst)
    if not G.TheWorld.ismastersim then return end
    if inst.components.upgradekit == nil then return end
    local old_data = inst.components.upgradekit.data or {}
    old_data["jx_icebox"] = { prefabresult = "hiddenmoonlight", onupgradefn = OnUpgrade_hidden }
    old_data["jx_icebox_2"] = { prefabresult = "hiddenmoonlight", onupgradefn = OnUpgrade_hidden }
    old_data["jx_icebox_3"] = { prefabresult = "hiddenmoonlight", onupgradefn = OnUpgrade_hidden }
    inst.components.upgradekit:SetData(old_data)
  end)

```



### 变体演进：月裔王冠 (Mod 3823894945)
- **变体场景与切面**：收录来自工坊 Mod 3823894945 (`月裔王冠`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823894945)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddStategraphPostInit:wilson
-- 仅拦截佩戴有效紫宝石王冠时的击飞，不改伤害结算。
AddStategraphPostInit("wilson", function(sg)
    local event = sg.events ~= nil and sg.events.knockback or nil
    if event == nil or event.fn == nil then return end
    local original = event.fn
    event.fn = function(inst, data, ...)
        local inventory = inst.components.inventory
        local crown = inventory ~= nil and inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD) or nil
        if crown ~= nil and crown.prefab == "descendant_crown"
            and crown.components.armor ~= nil and crown.components.armor:GetPercent() > 0
            and crown.components.container ~= nil then
            for i = 1, 5 do
                local gem = crown.components.container:GetItemInSlot(i)
                if gem ~= nil and gem.prefab == "purplegem" then return end
            end
        end
        return original(inst, data, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:gestalt
local protection = require("dcprotection")
AddPrefabPostInit("gestalt", protection.Install)
AddPrefabPostInit("lunar_grazer", protection.Install)
AddStategraphPostInit("gestalt", protection.InstallStategraph)

STRINGS.RECIPE_DESC.DESCENDANT_CROWN = "将月之启迪锻为月裔的王冠。"
AddRecipe2("descendant_crown", {
    GLOBAL.Ingredient("alterguardianhat", 1),
    GLOBAL.Ingredient("ruinshat", 1),
    GLOBAL.Ingredient("security_pulse_cage_full", 1),
}, GLOBAL.TECH.LOST, {
    atlas = "images/inventoryimages/descendant_crown.xml",
    image = "descendant_crown.tex",
}, {"ARMOUR", "MAGIC"})

-- Native blueprint.lua creates descendant_crown_blueprint from this recipe.
AddPrefabPostInit("alterguardian_phase3", function(inst)
    if not GLOBAL.TheWorld.ismastersim or inst.components.lootdropper == nil then return end
    inst.components.lootdropper:AddChanceLoot("descendant_crown_blueprint", 1)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:lunar_grazer
AddPrefabPostInit("gestalt", protection.Install)
AddPrefabPostInit("lunar_grazer", protection.Install)
AddStategraphPostInit("gestalt", protection.InstallStategraph)

STRINGS.RECIPE_DESC.DESCENDANT_CROWN = "将月之启迪锻为月裔的王冠。"
AddRecipe2("descendant_crown", {
    GLOBAL.Ingredient("alterguardianhat", 1),
    GLOBAL.Ingredient("ruinshat", 1),
    GLOBAL.Ingredient("security_pulse_cage_full", 1),
}, GLOBAL.TECH.LOST, {
    atlas = "images/inventoryimages/descendant_crown.xml",
    image = "descendant_crown.tex",
}, {"ARMOUR", "MAGIC"})

-- Native blueprint.lua creates descendant_crown_blueprint from this recipe.
AddPrefabPostInit("alterguardian_phase3", function(inst)
    if not GLOBAL.TheWorld.ismastersim or inst.components.lootdropper == nil then return end
    inst.components.lootdropper:AddChanceLoot("descendant_crown_blueprint", 1)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:gestalt
AddPrefabPostInit("lunar_grazer", protection.Install)
AddStategraphPostInit("gestalt", protection.InstallStategraph)

STRINGS.RECIPE_DESC.DESCENDANT_CROWN = "将月之启迪锻为月裔的王冠。"
AddRecipe2("descendant_crown", {
    GLOBAL.Ingredient("alterguardianhat", 1),
    GLOBAL.Ingredient("ruinshat", 1),
    GLOBAL.Ingredient("security_pulse_cage_full", 1),
}, GLOBAL.TECH.LOST, {
    atlas = "images/inventoryimages/descendant_crown.xml",
    image = "descendant_crown.tex",
}, {"ARMOUR", "MAGIC"})

-- Native blueprint.lua creates descendant_crown_blueprint from this recipe.
AddPrefabPostInit("alterguardian_phase3", function(inst)
    if not GLOBAL.TheWorld.ismastersim or inst.components.lootdropper == nil then return end
    inst.components.lootdropper:AddChanceLoot("descendant_crown_blueprint", 1)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:alterguardian_phase3
-- Native blueprint.lua creates descendant_crown_blueprint from this recipe.
AddPrefabPostInit("alterguardian_phase3", function(inst)
    if not GLOBAL.TheWorld.ismastersim or inst.components.lootdropper == nil then return end
    inst.components.lootdropper:AddChanceLoot("descendant_crown_blueprint", 1)
end)

```



### 变体演进：Tanjiro — Water Breathing Prototype (Mod 3800012904)
- **变体场景与切面**：收录来自工坊 Mod 3800012904 (`Tanjiro — Water Breathing Prototype`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3800012904)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:tanjiro

AddPrefabPostInit("tanjiro", function(inst)
    inst:AddTag("nichirin_user")
    -- One entity transform scales ordinary poses, held items and baked skill FX.
    local scale = profile.presentation.uniform_scale
    inst.Transform:SetScale(scale, scale, scale)
    inst._nichirin_breath = G.net_float(inst.GUID, "nichirin.breath", "nichirin_breath_dirty")
    inst._nichirin_cast_serial = G.net_uint(inst.GUID,"nichirin.castserial","nichirin_cast_dirty")
    inst._nichirin_cast_mode = G.net_tinybyte(inst.GUID,"nichirin.castmode","nichirin_cast_dirty")
    inst._nichirin_cooldowns = {}
    for _, skill in ipairs({ "water_surface", "water_wheel", "constant_flux" }) do
        inst._nichirin_cooldowns[skill] = G.net_ushortint(inst.GUID, "nichirin.cooldown." .. skill, "nichirin_cooldown_dirty")
    end
    if not G.TheWorld.ismastersim then return end
    inst:AddComponent("nichirincombat")
    inst.components.nichirincombat:Sync()
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson
local attack = G.require("nichirin/attackstate")
AddStategraphPostInit("wilson", attack.install)
AddStategraphPostInit("wilson_client", attack.install)
AddStategraphPostInit("wilson", G.require("nichirin/presentation").install)
AddStategraphPostInit("wilson_client", G.require("nichirin/presentation").install)

AddModRPCHandler("tanjiro_breathing", "cast", function(player, index, x, z)
    if type(index) ~= "number" or index ~= math.floor(index) then return end
    local skill = model.forms[index]
    local combat = player and player.components.nichirincombat
    if not skill or not combat then return end
    local ok,reason=combat:Request(skill,x,z)
    if not ok then G.require("nichirin/dialogue").reject(player,reason) end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
AddStategraphPostInit("wilson", attack.install)
AddStategraphPostInit("wilson_client", attack.install)
AddStategraphPostInit("wilson", G.require("nichirin/presentation").install)
AddStategraphPostInit("wilson_client", G.require("nichirin/presentation").install)

AddModRPCHandler("tanjiro_breathing", "cast", function(player, index, x, z)
    if type(index) ~= "number" or index ~= math.floor(index) then return end
    local skill = model.forms[index]
    local combat = player and player.components.nichirincombat
    if not skill or not combat then return end
    local ok,reason=combat:Request(skill,x,z)
    if not ok then G.require("nichirin/dialogue").reject(player,reason) end
end)

```



### 变体演进：蟠桃会·神话书说 (Mod 3810038043)
- **变体场景与切面**：收录来自工坊 Mod 3810038043 (`蟠桃会·神话书说`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3810038043)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:inventory
    -- patch_webdomain.lua 的周期任务往玩家身上写 _myth_webdef
    AddComponentPostInit("inventory", function(self)
        if not self.inst:HasTag("player") then return end
        local old_ApplyDamage = self.ApplyDamage
        self.ApplyDamage = function(self2, damage, attacker, weapon, spdamage)
            local def = self2.inst._myth_webdef or 0
            if def > 0 and spdamage ~= nil and spdamage.planar ~= nil and spdamage.planar > 0 then
                local sp2 = {}
                for k, v in pairs(spdamage) do sp2[k] = v end
                sp2.planar = sp2.planar - def
                if sp2.planar <= 0 then sp2.planar = nil end
                local any = false
                for k, v in pairs(sp2) do any = true break end
                if not any then sp2 = nil end
                return old_ApplyDamage(self2, damage, attacker, weapon, sp2)
            end
            return old_ApplyDamage(self2, damage, attacker, weapon, spdamage)
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:madameweb_pitfall_cocoon

AddPrefabPostInit("madameweb_pitfall_cocoon", function(inst)
    if not G.TheWorld.ismastersim then return end
    local ok, err = G.pcall(require("patch_cocoon").Wrap, inst)
    if not ok then
        Log("蛛网包茧改造出错: " .. tostring(err))
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:madameweb
    -- 2) 蛛皇本体手术（飞跃落地震击监听）
    AddPrefabPostInit("madameweb", function(inst)
        if not G.TheWorld.ismastersim then return end
        PatchWebDomain.SetupQueen(inst)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:madameweb_armor

AddPrefabPostInit("madameweb_armor", function(inst)
    if not G.TheWorld.ismastersim then return end
    local c = inst.components.container
    if c == nil then return end
    c.Open = function() end -- 实例字段遮蔽类方法：穿上不再弹格子
    -- 旧档遗留：披肩格子里存过东西的，读档恢复后倒出来（防困死）
    local old_OnLoad = c.OnLoad
    c.OnLoad = function(self, data, newents)
        if old_OnLoad ~= nil then old_OnLoad(self, data, newents) end
        self:DropEverything()
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yangjian

    AddPrefabPostInit("yangjian", function(inst)
        if not G.TheWorld.ismastersim then return end
        -- 第二道锁（v1.9.259 玩家实测"区区邪物"台词破案）：人物包还实例级
        -- 覆写了 sanity.SetInducedInsanity（空转+念台词）——梦魇护符的疯狂
        -- 诱导全靠这个接口，摘掉实例字段即回落官方类方法，护符正常生效
        if inst.components.sanity ~= nil then
            inst.components.sanity.SetInducedInsanity = nil
        end
        inst:DoTaskInTime(0, YjSanitySurgery) -- 原版监听挂完再手术
        inst:ListenForEvent("ms_respawnedfromghost", function(inst2)
            inst2:DoTaskInTime(0, YjSanitySurgery) -- 复活重挂后再手术
        end)
    end)

```



### 变体演进：LANGUAGE (Mod 3822900574)
- **变体场景与切面**：收录来自工坊 Mod 3822900574 (`LANGUAGE`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3822900574)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skinner
}
AddComponentPostInit("skinner", function(self)
    if not JV_LOCK[self.inst.prefab] then
        return
    end
    local old = self.SetSkinMode
    function self:SetSkinMode(skintype, default_build)
        local ghost = (skintype or self.skintype) == "ghost_skin"
        local fallback = ghost and JV_GHOST_BUILDS[self.inst.prefab] or self.inst.prefab
        old(self, skintype, ghost and fallback or (default_build or fallback))
        self.inst.AnimState:SetBuild(fallback)
        for _, symbol in ipairs({ "ghost_eyes", "ghost_body", "ghost_tail", "ghost_FX" }) do
            self.inst.AnimState:ClearOverrideSymbol(symbol)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:bloomer

AddComponentPostInit("bloomer", function(self)
    if not CHARACTERS[self.inst.prefab] then
        return
    end

    local PushBloom = self.PushBloom
    function self:PushBloom(source, fx, priority)
        if source == "playerghostbloom" and fx == GHOST_BLOOM then
            -- Remove only this source; preserve other effects and priorities.
            self:PopBloom(source)
            return
        end
        return PushBloom(self, source, fx, priority)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:jayce

AddPrefabPostInit("jayce", PostInit)
AddPrefabPostInit("viktor", PostInit)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:viktor
AddPrefabPostInit("jayce", PostInit)
AddPrefabPostInit("viktor", PostInit)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:playercontroller
-- Hook playercontroller to intercept Left-Click when aiming
AddComponentPostInit("playercontroller", function(self)
    local old_OnControl = self.OnControl
    function self:OnControl(control, down, ...)
        if self.inst == GLOBAL.ThePlayer and self.inst._jayce_laser_aiming then
            if down then
                if control == GLOBAL.CONTROL_PRIMARY then
                    -- Left click: fire laser in aimed direction if not clicking on HUD
                    if GLOBAL.TheInput ~= nil and GLOBAL.TheInput:GetHUDEntityUnderMouse() == nil then
                        local mousepos = GLOBAL.TheInput:GetWorldPosition()
                        if mousepos ~= nil then
                            FireJayceLaser(self.inst, mousepos)
                            return true
                        end
                    end
                elseif control == GLOBAL.CONTROL_SECONDARY or control == GLOBAL.CONTROL_CANCEL then
                    -- Right click or ESC cancels laser aiming
                    StopJayceLaserAiming(self.inst)
                    return true
                end
            elseif control == GLOBAL.CONTROL_PRIMARY or control == GLOBAL.CONTROL_SECONDARY then
                -- Consume button release
                return true
            end
        end
        return old_OnControl(self, control, down, ...)
    end
end)

-- Hotkey registration
local function OnPressLaserHotkey()
    local player = GLOBAL.ThePlayer
    if player == nil or not player:IsValid() then
        return
    end

    if player._jayce_laser_aiming then
        StopJayceLaserAiming(player)
        return
    end

    if not IsValidHUDState() then
        return
    end

    if not LeapSkills.HasShockBlast(player) then
        if GLOBAL.TheFocalPoint ~= nil and GLOBAL.TheFocalPoint.SoundEmitter ~= nil then
            GLOBAL.TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, 0.4)
        end
        return
    end

    local inventory = player.replica.inventory
    if inventory == nil then
        return
    end

    local weapon = inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if weapon == nil or not weapon:HasTag("jayce_laser_weapon") then
        return
    end

    -- Check cooldown
    if weapon._laser_ready ~= nil and not weapon._laser_ready:value() then
        if GLOBAL.TheFocalPoint ~= nil and GLOBAL.TheFocalPoint.SoundEmitter ~= nil then
            GLOBAL.TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, 0.4)
        end
        return
    end

    StartJayceLaserAiming(player, weapon)
end

if GLOBAL.TheInput ~= nil and not GLOBAL.TheNet:IsDedicated() then
    local key_name = (GetModConfigData and GetModConfigData("JAYCE_LASER_KEY")) or "R"
    local hotkey = GLOBAL["KEY_" .. string.upper(key_name)] or GLOBAL.KEY_R
    GLOBAL.TheInput:AddKeyDownHandler(hotkey, OnPressLaserHotkey)
end

GLOBAL.package.loaded["jv_jayce_laser"] = M
return M

```



### 变体演进：grow_time (Mod 3744085911)
- **变体场景与切面**：收录来自工坊 Mod 3744085911 (`grow_time`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3744085911)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:horn
local function Install(AddPrefabPostInit, enabled)
    AddPrefabPostInit("horn", enabled == true and HornPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("tallbirdegg", enabled == true and TallbirdEggPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("ancienttree_gem_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("ancienttree_nightvision_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
end

return { Install = Install }

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:tallbirdegg
    AddPrefabPostInit("horn", enabled == true and HornPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("tallbirdegg", enabled == true and TallbirdEggPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("ancienttree_gem_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("ancienttree_nightvision_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
end

return { Install = Install }

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ancienttree_gem_sapling_item
    AddPrefabPostInit("tallbirdegg", enabled == true and TallbirdEggPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("ancienttree_gem_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("ancienttree_nightvision_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
end

return { Install = Install }

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ancienttree_nightvision_sapling_item
    AddPrefabPostInit("ancienttree_gem_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
    AddPrefabPostInit("ancienttree_nightvision_sapling_item", enabled == true and SaplingPostInit or RestoreUnstackedSave)
end

return { Install = Install }

```



### 变体演进：language (Mod 3808204425)
- **变体场景与切面**：收录来自工坊 Mod 3808204425 (`language`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3808204425)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:berrybush_juicy
})
AddPrefabPostInit("berrybush_juicy", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:ListenForEvent("picked", require("growth/lumine_harvest").OnDroppedPick)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:farmplanttendable
function M.Install(G, H)
    H.AddComponentPostInit("farmplanttendable", function(component)
        if G.TheWorld.ismastersim then
            component.inst:ListenForEvent("on_planted", M.OnPlanted)
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
    G.require("paimon/guide").InstallRPC(G,hooks)
    hooks.AddPrefabPostInit("world", function(inst)
        if inst.ismastersim then inst:AddComponent("paimonworld") end
    end)

```



### 变体演进：The Lamb - English (Mod 3779830956)
- **变体场景与切面**：收录来自工坊 Mod 3779830956 (`The Lamb - English`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3779830956)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:combat

AddComponentPostInit("combat", function(self)
    local old_GetAttacked = self.GetAttacked

    function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
        local armorbreak = self.inst.components.armorbreak_debuff
        local mult = armorbreak ~= nil and armorbreak:GetDamageMultiplier() or 1

        if mult ~= 1 then
            if damage ~= nil and damage > 0 then
                damage = damage * mult
            end

            if spdamage ~= nil and SpDamageUtil ~= nil and SpDamageUtil.ApplyMult ~= nil then
                spdamage = SpDamageUtil.ApplyMult(spdamage, mult)
            end
        end

        return old_GetAttacked(self, attacker, damage, weapon, stimuli, spdamage, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:goldnugget

AddPrefabPostInit("goldnugget", function(inst)
    inst:AddTag("goldnugget")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:flint
end)
AddPrefabPostInit("flint", function(inst)
    inst:AddTag("flint")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:nitre
end)
AddPrefabPostInit("nitre", function(inst)
    inst:AddTag("nitre")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:monstermeat
end)
AddPrefabPostInit("monstermeat", function(inst)
    inst:AddTag("monstermeat")
end)

```



### 变体演进：Shrimpo the Shrimp (Mod 3792774753)
- **变体场景与切面**：收录来自工坊 Mod 3792774753 (`Shrimpo the Shrimp`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3792774753)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:shrimpo_brick

AddPrefabPostInit("shrimpo_brick", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end
	inst:AddComponent('brickthrowable')
	inst.components.brickthrowable:SetRange(8, 10)
	inst.components.brickthrowable:SetOnAttack(brickthrow_onattack)
	inst.components.brickthrowable:SetProjectile("brick_projectile")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shrimpo_brick_gold

AddPrefabPostInit("shrimpo_brick_gold", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end
	inst:AddComponent('brickthrowable')
	inst.components.brickthrowable:SetRange(8, 10)
	inst.components.brickthrowable:SetOnAttack(brickthrow_onattack)
	inst.components.brickthrowable:SetProjectile("gold_brick_projectile")
end)

```



### 变体演进：远古远古战争机器人 (Mod 3799794331)
- **变体场景与切面**：收录来自工坊 Mod 3799794331 (`远古远古战争机器人`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3799794331)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:dynamicmusic

AddComponentPostInit ("dynamicmusic", function (self, inst)
    if not TRIGGERED_DANGER_MUSIC then
        TryAppendMusic (inst)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:mnh_ancient_hulk_ice
-- ========== 主PostInit ==========
AddPrefabPostInit ("mnh_ancient_hulk_ice", function (inst)
    -- 客户端也要执行inspectable，否则右键动作不触发
    if not inst.components.inspectable then
        inst:AddComponent ("inspectable")
    end

    if not TheWorld.ismastersim then return end

    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
        inst.components.container:EnableInfiniteStackSize (true)
        inst.components.container.openside = false
    end

    -- 只监听 death，不监听 onremove
    inst:ListenForEvent("death", TransferItemsOnDeath)
end)

```



### 变体演进：h1. (Mod 3660452522)
- **变体场景与切面**：收录来自工坊 Mod 3660452522 (`h1.`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3660452522)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:ice

AddPrefabPostInit("ice", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("homura_ammo")
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:homura_rifle

AddPrefabPostInit("homura_rifle", function(inst)
    inst:AddTag("allow_action_on_impassable")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:homura_bow

AddPrefabPostInit("homura_bow", function(inst)
    inst:AddTag("allow_action_on_impassable")
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:boat

AddPrefabPostInit("boat", function(inst) 
    inst.lw_timemagic_onstop = OnBoatStop
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:homura_1
-- if USEBOW then
--     AddPrefabPostInit("homura_1", function(inst)
--         -- inst:AddTag("homura_bowmaker")
--         inst.starting_inventory = inst.starting_inventory or {}
--         table.insert(inst.starting_inventory, "homura_bow")
--     end)

```



### 变体演进：Nanachi 试图修复版 (Mod 2847103806)
- **变体场景与切面**：收录来自工坊 Mod 2847103806 (`Nanachi 试图修复版`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2847103806)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beefalo

AddPrefabPostInit("beefalo", function(inst)
    if inst.components and inst.components.eater then
    	local OldOnEat = inst.components.eater.oneatfn
        inst.components.eater:SetOnEatFn(function(inst,food)
        	if food:HasTag("nanachisoup") then
        		inst.components.domesticatable:DeltaDomestication(0.05)
        	end
        	OldOnEat(inst,food)
         end)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:hutch_fishbowl

AddPrefabPostInit("hutch_fishbowl",function(inst)
	inst.OnNewSpawn = SpawnMitty(inst)
end)]]

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:toadstool

AddPrefabPostInit("toadstool", function(inst)
	AddBossToIndicatorTable(inst)

	if Toadstool_Cap then
		RemoveBossFromIndicatorTable(Toadstool_Cap)
	end
	
	inst:ListenForEvent("onremove", function(inst)
		RemoveBossFromIndicatorTable(inst)
		
		if Toadstool_Cap then
			AddBossToIndicatorTable(Toadstool_Cap)
		end
	end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:toadstool_cap

AddPrefabPostInit("toadstool_cap", function(inst)
	inst:DoTaskInTime(0.1, function(inst)
		if inst._state:value() > 0 then
			AddBossToIndicatorTable(inst)
			Toadstool_Cap = inst
		end
	end)
end)

```



### 变体演进：RoseN Gardener (Mod 3823530017)
- **变体场景与切面**：收录来自工坊 Mod 3823530017 (`RoseN Gardener`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823530017)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：左轮手枪(死亡舞步) (Mod 3425984772)
- **变体场景与切面**：收录来自工坊 Mod 3425984772 (`左轮手枪(死亡舞步)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3425984772)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:combat
function dst_lan:_hookCombat()
    AddComponentPostInit("combat", function(self)
        self.dstlan_atkperiodmodifiers = SourceModifierList(self.inst)
        self.dstlan_orig_min_attack_period = self.min_attack_period
        local p = rawget(self, "_")["min_attack_period"]
        local old_on_map = p[2]
        p[2] = function(self, map)
            if old_on_map ~= nil then
                old_on_map(self, map)
            end
            if self.inst.replica.combat and self.inst.replica.combat.dstlan_atkperiodmult then
                self.inst.replica.combat.dstlan_atkperiodmult:set(self.dstlan_atkperiodmodifiers:Get())
            end
        end

        function self:SetAttackPeriod(val)
            self.dstlan_orig_min_attack_period = val
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end

        function self:SetAtkPeriodModifier(source, mult, key)
            self.dstlan_atkperiodmodifiers:SetModifier(source, mult, key)
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end

        function self:RemoveAtkPeriodModifier(source, key)
            self.dstlan_atkperiodmodifiers:RemoveModifier(source, key)
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson
function dst_lan:_hookSG()
    AddStategraphPostInit("wilson", function(sg)
        local old_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function (inst,...)
            local res = old_onenter ~= nil and {old_onenter(inst,...)} or {}
            local combat = inst.components.combat
            local timeout = (math.floor(13/(combat.dstlan_atkperiodmodifiers:Get())))*FRAMES
            inst.sg:SetTimeout(timeout)
            inst.AnimState:SetDeltaTimeMultiplier(combat.dstlan_atkperiodmodifiers:Get())
            return unpack(res)
        end

        local old_ontimeout = sg.states["attack"].ontimeout
        sg.states["attack"].ontimeout = function (inst,...)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag('abouttoattack')
            return old_ontimeout(inst,...)
        end

        local old_onexit = sg.states["attack"].onexit
        sg.states["attack"].onexit = function (inst,...)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            return old_onexit(inst,...)
        end

    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
function dst_lan:_hookSGClient()
    AddStategraphPostInit("wilson_client", function(sg)
        local old_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function (inst,...)
            local res = old_onenter ~= nil and {old_onenter(inst,...)} or {}
            local timeout = (math.floor(13/inst.replica.combat.dstlan_atkperiodmult:value()))*FRAMES
            inst.sg:SetTimeout(timeout)
            inst.AnimState:SetDeltaTimeMultiplier(inst.replica.combat.dstlan_atkperiodmult:value())
            return unpack(res)
        end

        local old_ontimeout = sg.states["attack"].ontimeout
        sg.states["attack"].ontimeout = function (inst,...)
            inst:PerformPreviewBufferedAction()
            inst.sg:RemoveStateTag('abouttoattack')
            return old_ontimeout(inst,...)
        end

        local old_onexit = sg.states["attack"].onexit
        sg.states["attack"].onexit = function (inst,...)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            return old_onexit(inst,...)
        end

    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:health

AddComponentPostInit("health",
---comment
---@param self component_health
function(self)
    local old_SetVal = self.SetVal
    function self:SetVal(val,cause,afflicter,...)
        local res = {old_SetVal(self,val,cause,afflicter,...)}

        local victim = self.inst
        -- 当死亡
        if self:IsDead() then
            local wp = afflicter and afflicter.last_atk_weapon
            -- 是收集者击杀
            if wp and wp.prefab and wp.prefab == 'qhc_revolver_pistol' then
                -- 筛选
                if not victim:HasTag('wall') and not victim:HasTag('structure') then
                    if afflicter and S_QHC_REVOLVER:checkAlive(afflicter) and afflicter.components.sanity then
                        afflicter.components.sanity:DoDelta(db.kill_regen_san)
                    end
                end
            end
        end

        return unpack(res)
    end
end)

```

