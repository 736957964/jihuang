require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/useshield"

local START_FACE_DIST = 4
local KEEP_FACE_DIST = 6
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 16
local WANDER_DIST = 16

local TARGET_FOLLOW_DIST = 6

local DAMAGE_UNTIL_SHIELD = 1000
local AVOID_PROJECTILE_ATTACKS = false
local SHIELD_TIME = 5

local GO_HOME_DIST = 1

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

local RockyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function RockyBrain:OnStart()
    local root = PriorityNode(
    {
        UseShield(self.inst, DAMAGE_UNTIL_SHIELD, SHIELD_TIME, AVOID_PROJECTILE_ATTACKS),
        ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST)),
		WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome", DoAction(self.inst, GoHomeAction, "Go Home", true)),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, WANDER_DIST)
    }, .25)

    self.bt = BT(self.inst, root)
end

return RockyBrain
