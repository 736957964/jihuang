
--------------------------------------------------------------------------
--[[兔子国王]]
--------------------------------------------------------------------------
local brain = require "brains/rp_point_bunnykingbrain"

return Class(function(self, inst)

--------------------------------------------------------------------------
--[[ Private constants/私有常量]]
--------------------------------------------------------------------------
local SLEEP_DIST_FROMTHREAT = 10
local SLEEP_DIST_FROMHOME_SQ = 1 * 1
--------------------------------------------------------------------------
--[[ Public Member Variables/公有成员变量]]
--------------------------------------------------------------------------
self.inst = inst
--------------------------------------------------------------------------
--[[ Private Member Variables/私有成员变量]]
--------------------------------------------------------------------------
local _healthPercent = nil
local _isSetHome = false
local _homePos = nil
local _isSecondState = false

self.inst.healthPercent = nil
self.inst.isSetHome = false
self.inst.homePos = nil 
self.inst.isSecondState = false
self.inst.tag = 1

--------------------------------------------------------------------------
--[[ Private member functions/私有成员函数]]
--------------------------------------------------------------------------

local function _BasicWakeCheck(inst)
    return (inst.components.combat ~= nil and inst.components.combat.target ~= nil)
        or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
        or (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen())
        or GetClosestInstWithTag("player", inst, SLEEP_DIST_FROMTHREAT) ~= nil
end

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function RememberKnownLocation(inst)
	
	inst.homePos = inst:GetPosition()
	inst.components.knownlocations:RememberLocation("home", inst.homePos)
	--[[
	if not _isSetHome then
		_homePos = inst:GetPosition()
		inst.components.knownlocations:RememberLocation("home", _homePos)
		_isSetHome = true
		print("first home!!!")
	else
		inst.components.knownlocations:RememberLocation("home", _homePos)
		print("not first home!!!")
	end
	]]--
end
--------------------------------------------------------------------------
--[[ Private event handlers/私有事件处理函数]]
--------------------------------------------------------------------------
local function onTimerDone(inst, data)
	if data.name == "Hypnosis" then
		inst.canhypnosis = true
	elseif data.name == "Lighting" then
		inst.canlighting = true
	end
end

local function OnHealthDelta1(inst, data)
    if inst.components.health:GetPercent() < .5 then
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
			
			inst.components.combat:SetDefaultDamage(90)
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
--[[ Public member functions/公有成员函数]]
--------------------------------------------------------------------------
--function self:SetAttacksPerWinter(attacks)
--    _attacksperwinter = attacks
--end
--------------------------------------------------------------------------
--[[ Save/Load/存储与载入]]
--------------------------------------------------------------------------
function self:OnSave()
	if self.inst.components.health then
		self.inst.healthPercent = self.inst.components.health:GetPercent()
	end
	--_homePos = self.inst.components.knownlocations:GetLocation("home")
	
	return
	{
		isSetHome = self.inst.isSetHome,
		homePos = self.inst.homePos,
		healthPercent = self.inst.healthPercent,
		isSecondState = self.inst.isSecondState,
		tag = 2,
	}
end

function self:OnLoad(data)
	if data ~= nil then
		print("load---")
		--if data.homePos then
		--	print("load homepos not null")
		--end
		if data.healthPercent then
			print("load healthPercent "..data.healthPercent)
		end
		self.inst.isSetHome = data.isSetHome
		self.inst.homePos = data.homePos
		self.inst.healthPercent = data.healthPercent
		self.inst.isSecondState = data.isSecondState
		self.inst.tag = data.tag		
	end
end

--------------------------------------------------------------------------
--[[ Debug]]
--------------------------------------------------------------------------
function self:GetDebugString()
	local s = ""
	return s
end


--------------------------------------------------------------------------
--[[ Initialization/初始化]]
--------------------------------------------------------------------------
function self:start()
	print("tag--"..self.inst.tag)
	self.inst.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
	self.inst.AnimState:Show("HAT")
	self.inst.AnimState:Show("HAT_HAIR")
	self.inst.AnimState:Hide("HAIR_NOHAT")
	self.inst.AnimState:Hide("HAIR")

	--体格
	local currentscale = self.inst.Transform:GetScale()
	self.inst.Transform:SetScale(currentscale*2.5,currentscale*2.5,currentscale*2.5)

	--睡不睡觉
	if self.inst.components.sleeper ~= nil then
		
		self.inst.components.sleeper:SetSleepTest(ShouldSleep)
		self.inst.components.sleeper:SetWakeTest(ShouldWake)
				
	end

	--打谁
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
			return guy:HasTag("player") and not guy:HasTag("rp_monster") and not guy:HasTag("wave_monster") and not guy:HasTag("playerghost")
		end)
		
		return invader
	end
	if not self.inst.components.teamattacker then
	  self.inst.components.combat:SetRetargetFunction(1, retargetfn)
	end

	--血多厚
	self.inst.components.health:SetMaxHealth(PIGMAN_HEALTH)
	self.inst.components.health:StartRegen(400, 100)
	if self.inst.healthPercent ~= nil then
		print("healthPercent not null")
		self.inst.components.health:SetPercent(self.inst.healthPercent)
	end
	--self.inst:ListenForEvent("healthdelta", OnHealthDelta1)

	--战斗力强不强
	self.inst.components.combat:SetDefaultDamage(70)
	self.inst.components.combat:SetAttackPeriod(2)
	self.inst.components.combat:SetAreaDamage(2.5, 1)
	self.inst.components.locomotor.walkspeed= 1
	self.inst.components.locomotor.runspeed = 2

	--AOE伤害忽略队友
	function self.inst.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
		local hitcount = 0
		local x, y, z = target.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, {"rp_monster","wave_monster","pig"})			
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
	self.inst.canhypnosis = false
	self.inst.canlighting = false
	self.inst.candodge = false
	self.inst:ListenForEvent("timerdone", onTimerDone)

	--家在哪儿
	if not self.inst.components.inspectable then
		self.inst:AddComponent("inspectable")
	end
	if not self.inst.components.knownlocations then
		self.inst:AddComponent("knownlocations")
	end

	if self.inst.homePos == nil then
		print("homepos null")
		
		RememberKnownLocation(self.inst)
	else
		print("homepos not null")
	end

	--智商咋样
	self.inst:SetBrain(brain)
	self.inst:SetStateGraph("rp_SGbunnyking")
end
--长得咋样
--if _isSecondState then
	--self.inst.AnimState:SetBuild("manrabbit_beard_build")
--else
--	self.inst.AnimState:SetBuild("manrabbit_build")
--end



end)
