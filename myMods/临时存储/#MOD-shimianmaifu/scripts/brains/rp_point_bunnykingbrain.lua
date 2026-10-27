require "behaviours/standstill"
require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
--require "behaviours/choptree"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local START_RUN_DIST = 3
local STOP_RUN_DIST = 30
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 20

local RUN_AWAY_DIST = 3
local STOP_RUN_AWAY_DIST = 4
local SEE_PLAYER_DIST = 6
local GO_HOME_DIST = 1
local MAX_WANDER_DIST = 8

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
	print("GoHomeAction!")
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

local BunnymanBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function BunnymanBrain:OnStart()
    --print(self.inst, "PigBrain:OnStart")
    local root = 
        PriorityNode(
        {
            --WhileNode(function() return self.inst.components.health:GetPercent() < TUNING.BUNNYMAN_PANIC_THRESH end, "LowHealth",
			--	ChattyNode(self.inst, STRINGS.RABBIT_RETREAT,
			--		RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST))),
            WhileNode(function()
                        return self.inst.components.combat.target == nil
                            or not self.inst.components.combat:InCooldown()
                    end,
                    "AttackMomentarily",
                    ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
			WhileNode(function() return self.inst.candodge and self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),
            WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true)),
           
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
			Wander(self.inst, function() return GetHomePos(self.inst) end, MAX_WANDER_DIST),
        }, .25)
    
    self.bt = BT(self.inst, root)
    
end

return BunnymanBrain
