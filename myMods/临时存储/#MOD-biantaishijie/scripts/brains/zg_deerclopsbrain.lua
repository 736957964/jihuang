require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/panic"
require "behaviours/minperiod"
require "giantutils"

local SEE_DIST = 40

local CHASE_DIST = 32
local CHASE_TIME = 20

local function BaseDestroy(inst)
    if inst.components.knownlocations:GetLocation("targetbase") then
    	local target = FindEntity(inst, SEE_DIST, function(item) 
    			if item.components.workable and item:HasTag("structure")
    				and item.components.workable.action == ACTIONS.HAMMER
    			then
    				return true
    			end
    		end, nil, {"wall"})
    	if target then
    		return BufferedAction(inst, target, ACTIONS.HAMMER)
    	end
    end
end


local function GetWanderPos(inst)
    if inst.components.knownlocations:GetLocation("targetbase") then
        return inst.components.knownlocations:GetLocation("targetbase")
	elseif inst.components.knownlocations:GetLocation("home") then
		return inst.components.knownlocations:GetLocation("home")
	elseif inst.components.knownlocations:GetLocation("spawnpoint") then
		return inst.components.knownlocations:GetLocation("spawnpoint")
	end
end

local function GetNewHome(inst)
    if inst.forgethometask then
        inst.forgethometask:Cancel()
        inst.forgethometask = nil
    end
    local targetPos = Vector3(inst.Transform:GetWorldPosition())
    local wanderAwayPoint = GetWanderAwayPoint(targetPos)
    if wanderAwayPoint then
        inst.components.knownlocations:RememberLocation("home", wanderAwayPoint)
    end

    inst.forgethometask = inst:DoTaskInTime(30, function() inst.components.knownlocations:ForgetLocation("home") end)
end

local function GetHomePos(inst)
    if not inst.components.knownlocations:GetLocation("home") then
        GetNewHome(inst)
    end
    return inst.components.knownlocations:GetLocation("home")
end

--
local function SomeoneWantAttackMe(inst)
	local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 7, {"player"}, {"playerghost"})
    for k,v in pairs(ents) do
		if v and v.components.combat and v.components.combat.target and v.components.combat.target == inst then
			return true
		end
    end
end

--
local function TargetIsOutOfHisHitrange(inst)
	local target = inst.components.combat.target
	if target and target.components.combat then
		local dst = (target.components.combat.hitrange or 0) + inst.Physics:GetRadius() + .5
		local dst2 = inst:GetPosition():Dist(target:GetPosition())
		return dst2 > dst
	end
	return false
end

--
local function MyDogeMinDST(inst)
	local target = inst.components.combat.target
	if target and target.components.combat then
		return (target.components.combat.hitrange or 0) + inst.Physics:GetRadius() + .5
	end
end

local function MyDogeMaxDST(inst)
	local hitrange = inst.components.combat.hitrange
	local target = inst.components.combat.target
	if target and target.components.combat then
		local hitrange2 = target.components.combat.hitrange or 0
		if hitrange2 > hitrange then
			return hitrange2 + inst.Physics:GetRadius() + .5
		else
			return hitrange
		end
	end
end
--

local DeerclopsBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function DeerclopsBrain:OnStart()
    local root =
        PriorityNode(
        {
            --AttackWall(self.inst),
			
			WhileNode( function() 
				return not self.inst.components.combat:InCooldown() and TargetIsOutOfHisHitrange(self.inst) end, 			
				"AttackMomentarily",
				ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST) ),  
			WhileNode( function() 
				return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
				"Dodge", RunAway(self.inst, function() 
				return self.inst.components.combat.target end,  4,  6 )),

			DoAction(self.inst, function() return not SomeoneWantAttackMe(self.inst) and BaseDestroy(self.inst) end, "DestroyBase", true),

            Wander(self.inst, GetWanderPos, 30, {minwwwalktime = 10}),
        },1)
    
    self.bt = BT(self.inst, root)
end

function DeerclopsBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", Point(self.inst.Transform:GetWorldPosition()))
end

return DeerclopsBrain
