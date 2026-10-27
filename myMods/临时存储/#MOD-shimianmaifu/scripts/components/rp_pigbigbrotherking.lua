
--------------------------------------------------------------------------
--[[大野猪]]
--------------------------------------------------------------------------
local brain = require "brains/rp_point_pigbigbrotherkingbrain"

return Class(function(self, inst)

--------------------------------------------------------------------------
--[[ Private constants ]]
--------------------------------------------------------------------------
local SLEEP_DIST_FROMTHREAT = 20
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

local function onsmashother(inst, other)
    if not other:IsValid() then
        return
    elseif other.components.health ~= nil and not other.components.health:IsDead() then
        if other:HasTag("smashable") then
            --other.Physics:SetCollides(false)
            other.components.health:Kill()
        --else
        --    SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        --    inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        --    inst.components.combat:DoAttack(other)
        end
    elseif other.components.workable ~= nil and other.components.workable:CanBeWorked() and other.prefab ~= "pighouse" and not other:HasTag("tree") then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        other.components.workable:Destroy(inst)
		ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 20)
    end
end

local function oncollide(inst, other)
    if other == nil or
        not other:IsValid() or
        other:HasTag("player") then
        return
    end
    inst:DoTaskInTime(2 * FRAMES, onsmashother, other)
end

local function CreateWeapon(inst)
    local weapon = CreateEntity()
    --[[Non-networked entity]]
    weapon.entity:AddTransform()
    weapon:AddComponent("weapon")
    weapon.components.weapon:SetDamage(200)
    weapon.components.weapon:SetRange(0)
    weapon:AddComponent("inventoryitem")
    weapon.persists = false
    weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
    weapon:AddComponent("equippable")
    inst.components.inventory:GiveItem(weapon)
    inst.weapon = weapon
end
--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------
local function onTimerDone(inst, data)
	--if data.name == "Groundpound" then
	--	inst.cangroundpound = true
	if data.name == "angry" then
		inst.angry = true
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

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
	--local big_brother = GetClosestInstWithTag("BigPigBrother", inst, 30)--可能导致效率变低
	--if big_brother and not big_brother.components.health:IsDead() and big_brother.components.combat then
	--	print("dont attack my brother!!!")
	--	if big_brother.components.combat.target ~= data.attacker then
	--		big_brother.components.combat:SetTarget(data.attacker)
	--		print("I will kill you!!!")
	--	end
	--end
	
    inst.components.combat:ShareTarget(data.attacker, 40, function(dude)
        return dude:HasTag("PigBrother")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
            and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
	
end

local werepigbrain = require "brains/werepigbrain"

local function OnBrotherBeKilled(inst)
	inst:AddTag("werepig")
	inst:RemoveTag("guard")
	inst:SetBrain(werepigbrain)
	inst:SetStateGraph("SGwerepig")
	inst.AnimState:SetBuild("werepig_build")
	inst.sg:GoToState("transformWere")
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
self.inst:AddTag("PigBrother")
self.inst:AddTag("big_pig")

--self.inst:RemoveComponent("werebeast")
--self.inst:AddTag("BigPigBrother")
self.inst.AnimState:OverrideSymbol("swap_hat", "hat_slurper", "swap_hat")
self.inst.AnimState:Show("HAT")
self.inst.AnimState:Show("HAT_HAIR")
self.inst.AnimState:Hide("HAIR_NOHAT")
self.inst.AnimState:Hide("HAIR")

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
	local dist = 20	
	local invader = nil
	invader = FindEntity(inst, dist, function(guy)
		return guy:HasTag("player") and not guy:HasTag("rp_monster") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost") and not guy:HasTag("hostile")
	end)
	
	return invader
end

self.inst.components.combat:SetRetargetFunction(1, retargetfn)


--血多厚
self.inst.components.health:SetMaxHealth(BIG_PIGBROTHER_HEALTH)
self.inst.components.health:StartRegen(400, 200)
if _healthPercent ~= nil then
	self.inst.components.health:SetPercent(_healthPercent)
end
--self.inst:ListenForEvent("healthdelta", OnHealthDelta1)

--战斗力强不强
self.inst.components.combat:SetDefaultDamage(70)
self.inst.components.combat:SetAttackPeriod(2.5)
self.inst.components.combat:SetAreaDamage(2, 0.8)
self.inst.components.combat:SetRange(2, 3)
self.inst.components.locomotor.walkspeed= 2
self.inst.components.locomotor.runspeed = 3 
--AOE伤害忽略队友
function self.inst.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
	local hitcount = 0
	local x, y, z = target.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, {"rp_monster", "shadowboss", "hostile", "insect"})			
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

self.inst:ListenForEvent("attacked", OnAttacked)
self.inst:ListenForEvent("rp_brotherbekilled", OnBrotherBeKilled)
--技能学了么
--self.inst:AddComponent("timer")
--self.inst.angry = false
--self.inst.cancallmeteor = false
--self.inst:ListenForEvent("timerdone", onTimerDone)


--家在哪儿
if not self.inst.components.inspectable then
	self.inst:AddComponent("inspectable")
end
if not self.inst.components.knownlocations then
	self.inst:AddComponent("knownlocations")
end
self.inst:DoTaskInTime(0, RememberKnownLocation)

--CreateWeapon(self.inst)

--撞东西
--MakeCharacterPhysics(inst, 100, 2)
--self.inst.Physics:SetCylinder(2.2, 4)
self.inst.Physics:SetCollisionCallback(oncollide)

--智商咋样
self.inst:SetBrain(brain)
self.inst:SetStateGraph("rp_SGpigbigbrotherking")

end)
