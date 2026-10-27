require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
--require "behaviours/choptree"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/leash"


local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9
local MAX_WANDER_DIST = 10
local MIN_WAITING_TIME = 8

local LEASH_RETURN_DIST = 8
local LEASH_MAX_DIST = 16

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local START_RUN_DIST = 3
local STOP_RUN_DIST = 30
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 30
local SEE_LIGHT_DIST = 20
local TRADE_DIST = 20
local SEE_TREE_DIST = 15
local SEE_TARGET_DIST = 20
local SEE_FOOD_DIST = 10

local KEEP_CHOPPING_DIST = 10

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
local SEE_PLAYER_DIST = 6

local function HasValidHome(inst)
    return inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid()
end

local function GoHomeAction(inst)
    if not inst.components.follower.leader and
        HasValidHome(inst) and
        not inst.components.combat.target then
            return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetNoLeaderHomePos(inst)
    local desk = inst.desk
    if desk and desk:IsValid() then
        local pos = Point()
        local num = 0
        for k in pairs(desk.rhinos)do
            if k:IsValid() then
                pos = pos + k:GetPosition()
                num = num + 1
            end
        end
        return pos/num
    end
end

local function ShouldReturnHome(inst)
    return GetNoLeaderHomePos(inst) and inst:GetPosition():DistSq(GetNoLeaderHomePos(inst)) > 20*20
end

local RhinoBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function RhinoBrain:OnStart()
    local root = 
        PriorityNode(
        {
            AttackWall(self.inst),
            Leash(self.inst, function(inst) return inst:GetDeskPos() end, 32, 10),
            IfNode(function() return self.inst.stage ~= 3 or self.inst:CanDoDash()  end, "DoAttack",
                ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
            Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
            Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST, {
                minwaittime = MIN_WAITING_TIME,
                minwalktime = 1,
                randwalktime = 1,
            })
        }, .5)
    
    self.bt = BT(self.inst, root)
end

return RhinoBrain
