
--------------------------------------------------------------------------
--[[兔子国王]]
--------------------------------------------------------------------------
local brain = require "brains/rp_point_rockykingbrain"

return Class(function(self, inst)

--------------------------------------------------------------------------
--[[ Private constants ]]
--------------------------------------------------------------------------
local SLEEP_DIST_FROMTHREAT = 15
local SLEEP_DIST_FROMHOME_SQ = 1 * 1
--------------------------------------------------------------------------
--[[ Public Member Variables ]]
--------------------------------------------------------------------------
self.inst = inst
--------------------------------------------------------------------------
--[[ Private Member Variables ]]
--------------------------------------------------------------------------
local _healthPercent = nil
local _isSetHome = false
local _isSecondState = false
--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

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
--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------
local function onTimerDone(inst, data)
	--if data.name == "Groundpound" then
	--	inst.cangroundpound = true
	if data.name == "Callmeteor" then
		inst.cancallmeteor = true
	end
end

local function OnHealthDelta1(inst, data)
    if inst.components.health:GetPercent() < .4 then
		if not _isSecondState then
			inst.sg:GoToState("taunt")
			print("change to second！")
			_isSecondState = true
			inst.beardlord = true
			inst.AnimState:SetBuild("manrabbit_beard_build")
			
			local fx = SpawnPrefab("statue_transition_2")
			local x,y,z = inst.Transform:GetWorldPosition()
			fx.Transform:SetPosition(x, y, z)
			local currentscale = fx.Transform:GetScale()
			fx.Transform:SetScale(currentscale*4,currentscale*4,currentscale*4)
			
			inst.components.combat:SetDefaultDamage(75)
			inst.components.combat:SetAttackPeriod(2)
			inst.components.locomotor.walkspeed= 3
			inst.components.locomotor.runspeed = 5
		end
	else
		if _isSecondState then
			print("change to first！")
			_isSecondState = false
			inst.beardlord = false
			inst.AnimState:SetBuild("manrabbit_build")
			
			local fx = SpawnPrefab("statue_transition")
			local x,y,z = inst.Transform:GetWorldPosition()
			fx.Transform:SetPosition(x, y+1, z)
			local currentscale = fx.Transform:GetScale()
			fx.Transform:SetScale(currentscale*2,currentscale*2,currentscale*2)
			
			inst.components.combat:SetDefaultDamage(70)
			inst.components.combat:SetAttackPeriod(2.2)
			inst.components.locomotor.walkspeed= 1
			inst.components.locomotor.runspeed = 2
		end
	end
end

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------
--function self:SetAttacksPerWinter(attacks)
--    _attacksperwinter = attacks
--end
--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------
function self:OnSave()
	if self.inst.components.health then
		_healthPercent = self.inst.components.health:GetPercent()
	end
	
	return
	{
		isSetHome = _isSetHome,
		healthPercent = _healthPercent,
		isSecondState = _isSecondState,
		
	}
end

function self:OnLoad(data)
	if data ~= nil then
		_isSetHome = data.isSetHome
		_healthPercent = data.healthPercent
		_isSecondState = data.isSecondState	
	end
end

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------
function self:GetDebugString()
	local s = ""
	return s
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--self.inst:DoTaskInTime(0, function() 

self.inst:AddTag("monster")
--体格
local currentscale = self.inst.Transform:GetScale()
self.inst.Transform:SetScale(currentscale*3,currentscale*3,currentscale*3) 
--end)

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
		return guy:HasTag("player") and not guy:HasTag("rp_monster") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
	end)
	
	return invader
end
if not self.inst.components.teamattacker then
  self.inst.components.combat:SetRetargetFunction(3, retargetfn)
end

--血多厚
self.inst.components.health:SetMaxHealth(ROCKY_HEALTH)
self.inst.components.health:StartRegen(400, 100)
if _healthPercent ~= nil then
	self.inst.components.health:SetPercent(_healthPercent)
end
--self.inst:ListenForEvent("healthdelta", OnHealthDelta1)

--战斗力强不强
self.inst.components.combat:SetDefaultDamage(80)
self.inst.components.combat:SetAttackPeriod(3)
self.inst.components.combat:SetAreaDamage(2, 0.8)
self.inst.components.locomotor.walkspeed= 2
self.inst.components.locomotor.runspeed = 4
--AOE伤害忽略队友
function self.inst.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
	local hitcount = 0
	local x, y, z = target.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, {"rp_monster", "shadowboss"})			
	for i, ent in ipairs(ents) do
		if ent ~= target and
			ent ~= self.inst and
			self:IsValidTarget(ent) and
			(validfn == nil or validfn(ent)) then
			self.inst:PushEvent("onareaattackother", { target = target, weapon = weapon, stimuli = stimuli })
			ent.components.combat:GetAttacked(self.inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli)
			hitcount = hitcount + 1
		end
	end
	return hitcount
end				

--技能学了么
self.inst:AddComponent("timer")
--self.inst.cangroundpound = false
self.inst.cancallmeteor = false
self.inst:ListenForEvent("timerdone", onTimerDone)

--家在哪儿
if not self.inst.components.inspectable then
	self.inst:AddComponent("inspectable")
end
if not self.inst.components.knownlocations then
	self.inst:AddComponent("knownlocations")
end
self.inst:DoTaskInTime(0, RememberKnownLocation)

--智商咋样
self.inst:SetBrain(brain)
self.inst:SetStateGraph("rp_SGrockyking")

end)
