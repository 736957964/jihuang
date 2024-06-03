require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"

local SEE_PLAYER_DIST = 8
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 8
local MAX_CHASE_DIST = 20
local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 7
local GO_HOME_DIST = 1

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

local LeifBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LeifBrain:OnStart()
    local root =
        PriorityNode(
        {
			AttackWall(self.inst),
			WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST))),
			WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true)),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),            
        },.25)
    
    self.bt = BT(self.inst, root)
end

return LeifBrain