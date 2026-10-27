require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/faceentity"

local SEE_PLAYER_DIST = 8
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 20
local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 6
local GO_HOME_DIST = 1
local LEASH_MAX_DIST = 30
local LEASH_RETURN_DIST = 10

local MermBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function ShouldGoHome(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    return homePos ~= nil and inst:GetDistanceSqToPoint(homePos:Get()) > GO_HOME_DIST * GO_HOME_DIST
end

local function GoHomeAction(inst)
    if inst.components.combat.target ~= nil then
        return
    end
    local homePos = inst.components.knownlocations:GetLocation("home")
    return homePos ~= nil
        and BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, .2)
        or nil
end

local function GetHomePos(inst)
	local homePos = inst.components.knownlocations:GetLocation("home") 
	return homePos
end

local function GetFaceTargetFn(inst)
    return FindClosestPlayerToInst(inst, SEE_PLAYER_DIST, true)
end

local function KeepFaceTargetFn(inst, target)
    return target:IsValid() and inst:IsNear(target, SEE_PLAYER_DIST)
end


function MermBrain:OnStart()
	
	local homePos = self.inst.components.knownlocations:GetLocation("home")
    local root = PriorityNode(
    {
		Leash(self.inst, GetHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
        WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST))),
        WhileNode(function() return self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),
        WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true)),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, .25)

    self.bt = BT(self.inst, root)
end

return MermBrain
