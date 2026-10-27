require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/chaseandram"

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local GO_HOME_DIST = 1
local MAX_WANDER_DIST = 8
local MAX_CHASE_TIME = 8
local MAX_CHASE_DIST = 15
local RUN_AWAY_DIST = 3
local STOP_RUN_AWAY_DIST = 5

local MAX_CHARGE_DIST = 20
local CHASE_GIVEUP_DIST = 10

local function ShouldGoHome(inst)
    if inst.components.follower ~= nil and inst.components.follower.leader ~= nil then
        return false
    end
    local homePos = inst.components.knownlocations:GetLocation("home")
    return homePos ~= nil and inst:GetDistanceSqToPoint(homePos:Get()) > GO_HOME_DIST * GO_HOME_DIST
end

local function GoHomeAction(inst)
    if inst.components.combat.target ~= nil then
        return
    end
    local homePos = inst.components.knownlocations:GetLocation("home")
	--print("GoHomeAction!")
    return homePos ~= nil
        and BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, .2)
        or nil
end

local function GetHomePos(inst)
	local homePos = inst.components.knownlocations:GetLocation("home") 
	return homePos
end

local function GetFaceTargetFn(inst)
    local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
    return target ~= nil and not target:HasTag("notarget") and target or nil
end

local function KeepFaceTargetFn(inst, target)
    return not target:HasTag("notarget") and inst:IsNear(target, KEEP_FACE_DIST)
end

local PigGuardBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function PigGuardBrain:OnStart()
    local root = PriorityNode(
    {
		 WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST))),
        
        ChattyNode(self.inst, STRINGS.PIG_GUARD_TALK_FIGHT,
            WhileNode(function() return self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end, "Dodge",
               RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST))),
        WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
        ChattyNode(self.inst, STRINGS.PIG_GUARD_TALK_GOHOME,
            DoAction(self.inst, GoHomeAction, "Go Home", true))),
        ChattyNode(self.inst, STRINGS.PIG_GUARD_TALK_LOOKATWILSON,
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
		--FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        --StandStill(self.inst)
    }, .25)

    self.bt = BT(self.inst, root)
end

return PigGuardBrain
