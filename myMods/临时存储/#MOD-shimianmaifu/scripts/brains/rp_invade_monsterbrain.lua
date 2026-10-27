require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/useshield"
require "behaviours/attackwall"

local START_FACE_DIST = 4
local KEEP_FACE_DIST = 6
local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 60
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 8
local WANDER_DIST = 16

local DAMAGE_UNTIL_SHIELD = 400
local AVOID_PROJECTILE_ATTACKS = false
local SHIELD_TIME = 4

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
		WhileNode(function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
        WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		
		WhileNode(function() return self.inst:HasTag("rocky") end, "Can Shield",UseShield(self.inst, DAMAGE_UNTIL_SHIELD, SHIELD_TIME, AVOID_PROJECTILE_ATTACKS)),
		AttackWall(self.inst),
		WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
		--如果攻击的是墙则不要走位
		WhileNode(function() 
		
		local radius = 1.5 + (self.inst.Physics and self.inst.Physics:GetRadius() or 0)
		local wall_target = FindEntity(self.inst, radius, 
			function(guy) 
				if self.inst.components.combat:CanTarget(guy) then
					local angle = anglediff(self.inst.Transform:GetRotation(), self.inst:GetAngleToPoint(Vector3(guy.Transform:GetWorldPosition() )))
					return math.abs(angle) < 30
				end
			end,
			{"wall"}
		)
		return self.inst.components.combat.target ~= nil 
		and not wall_target
		and self.inst.components.combat:InCooldown() end, "Dodge",
        RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),
		
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        --Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, WANDER_DIST)
    }, .25)

    self.bt = BT(self.inst, root)
end

return RockyBrain
