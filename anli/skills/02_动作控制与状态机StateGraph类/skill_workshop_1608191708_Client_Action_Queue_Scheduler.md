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

