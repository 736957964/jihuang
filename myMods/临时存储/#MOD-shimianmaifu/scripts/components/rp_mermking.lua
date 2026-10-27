--rp_components template
--------------------------------------------------------------------------
--[[兔子国王/bunnymanking]]
local MermKingBrain = require "brains/rp_point_mermkingbrain"

--------------------------------------------------------------------------
return Class(function(self, inst)

local SLEEP_DIST_FROMTHREAT = 20
local SLEEP_DIST_FROMHOME_SQ = 1 * 1
local _healthPercent = nil
local _isSetHome = false
self.inst = inst
local function _BasicWakeCheck(inst)
    return (inst.components.combat ~= nil and inst.components.combat.target ~= nil)
        or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
        or (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen())
        or GetClosestInstWithTag("player", inst, SLEEP_DIST_FROMTHREAT) ~= nil
end

local function ShouldSleep(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    return homePos ~= nil
        and inst:GetDistanceSqToPoint(homePos:Get()) < SLEEP_DIST_FROMHOME_SQ
        and not _BasicWakeCheck(inst)
end

local function ShouldWake(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    return (homePos ~= nil and
            inst:GetDistanceSqToPoint(homePos:Get()) >= SLEEP_DIST_FROMHOME_SQ)
        or _BasicWakeCheck(inst)
end

local function RememberKnownLocation(inst)

	if not _isSetHome then
		inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
		_isSetHome = true
	end

end

local function Retarget(inst)
    return FindTarget(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST)
end

--鱼鱼远程冰冻
local function MakeWeapon(inst)
    if inst.components.inventory ~= nil then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        MakeInventoryPhysics(weapon)
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(45)
        weapon.components.weapon:SetRange(inst.components.combat.attackrange, inst.components.combat.attackrange + 2)
		--weapon.components.weapon:SetRange(10,14)
        weapon.components.weapon:SetProjectile("ice")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
        weapon:AddComponent("equippable")
        inst.weapon = weapon
        inst.components.inventory:Equip(inst.weapon)
        inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
		
    end
end
--------------------------------------------------------------------------
--[[ 公有成员函数/Public member functions ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ 私有事件处理函数/Private event handlers ]]
--------------------------------------------------------------------------
local function onTimerDone(inst, data)
	if data.name == "Freezing" then
		inst.canfreezing = true
	elseif data.name == "Togglestate" then
		if not inst.cantogglestate then 
			inst.cantogglestate = true
			inst.components.combat:SetDefaultDamage(70)
			inst.components.combat:SetAttackPeriod(0.7)
			inst.components.combat:SetRange(12, 14)
		else
			inst.cantogglestate = false
			inst.components.combat:SetDefaultDamage(70)
			inst.components.combat:SetAttackPeriod(2.5)
			inst.components.combat:SetRange(3, 4)
		end
		--print("toggle!!!! ")
		if not (inst.components.timer:TimerExists("Togglestate")) then
		--print("start timer!!!")
			inst.components.timer:StartTimer("Togglestate", MERM_TOGGLE_COOLDOWN)
		end
 	end
end
--------------------------------------------------------------------------
--[[ 保存与加载/Save/Load ]]
--------------------------------------------------------------------------
function self:OnSave()
	if self.inst.components.health then
		_healthPercent = self.inst.components.health:GetPercent()
	end
	
	return
	{
		isSetHome = _isSetHome,
		healthPercent = _healthPercent,
	}
end

function self:OnLoad(data)
	if data ~= nil then
		_isSetHome = data.isSetHome
		_healthPercent = data.healthPercent
	end
end
--------------------------------------------------------------------------
--[[ 调试/Debug ]]
--------------------------------------------------------------------------
function self:GetDebugString()
	local s = ""
	return s
end
--------------------------------------------------------------------------
--[[ 初始化操作/Initialization ]]
--------------------------------------------------------------------------
self.inst.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
self.inst.AnimState:Show("HAT")
self.inst.AnimState:Show("HAT_HAIR")
self.inst.AnimState:Hide("HAIR_NOHAT")
self.inst.AnimState:Hide("HAIR")
--local r, g, b = HexToPercentColor("#050505")
--设置怪物颜色
--self.inst.AnimState:SetMultColour(r, g, b, 0.65)	
--体格
local currentscale = self.inst.Transform:GetScale()
self.inst.Transform:SetScale(currentscale*3,currentscale*3,currentscale*3)

--睡不睡觉啊
if self.inst.components.sleeper ~= nil then
	
	self.inst.components.sleeper:SetSleepTest(ShouldSleep)
	self.inst.components.sleeper:SetWakeTest(ShouldWake)
			
end

--打谁啊
local origCanTarget = self.inst.components.combat.keeptargetfn
local function keepTargetOverride(inst, target)
	-- TODO: Testing this 
	if true then
		return inst.components.combat:CanTarget(target)
	end
	-- This wont get hit. Was original code. TODO : if above is better, remove this.
	if target:HasTag("player") and inst.components.combat:CanTarget(target) then
		return true
	else
		return origCanTarget and origCanTarget(inst,target)
	end
end
self.inst.components.combat:SetKeepTargetFunction(keepTargetOverride)
local function retargetfn(inst)
	-- Give all mobs same search dist as hounds
	local dist = 15		
	local invader = nil
	invader = FindEntity(inst, dist, function(guy)
		return guy:HasTag("player") and not guy:HasTag("wave_monster") and not guy:HasTag("playerghost")
	end)
	
	return invader
end
if not self.inst.components.teamattacker then
  self.inst.components.combat:SetRetargetFunction(2, retargetfn)
end

--血多厚
self.inst.components.health:SetMaxHealth(MERM_HEALTH)
self.inst.components.health:StartRegen(400, 100)
if _healthPercent ~= nil then
	self.inst.components.health:SetPercent(_healthPercent)
end
--self.inst:ListenForEvent("healthdelta", OnHealthDelta1)

--战斗力强不强
self.inst.components.combat:SetDefaultDamage(70)
self.inst.components.combat:SetAttackPeriod(2)
self.inst.components.combat:SetRange(12, 14)--第一个参数为攻击距离，第二个为能够击中的距离
self.inst.components.locomotor.walkspeed= 1
self.inst.components.locomotor.runspeed = 2

--技能学了么
self.inst:AddComponent("timer")
self.inst.canfreezing = false
self.inst.cantogglestate = false
self.inst:ListenForEvent("timerdone", onTimerDone)
if not self.inst.components.inventory then
	self.inst:AddComponent("inventory")
end
MakeWeapon(self.inst)

--家在哪儿
if not self.inst.components.inspectable then
	self.inst:AddComponent("inspectable")
end
if not self.inst.components.knownlocations then
	self.inst:AddComponent("knownlocations")
end
self.inst:DoTaskInTime(0, RememberKnownLocation)

--智商咋样
self.inst:SetBrain(MermKingBrain)
self.inst:SetStateGraph("rp_SGmermking")

--local r, g, b = HexToPercentColor("#0C70F0")
--设置怪物颜色
--self.inst.AnimState:SetMultColour(r, g, b, 1)

end)
