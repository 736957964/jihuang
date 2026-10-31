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

