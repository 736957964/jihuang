--[[
蝙蝠有团队精神
空闲时喜欢靠近锅子，冰箱，灭火器等
]]

local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 40

local BatBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function EatFoodAction(inst)
    local target = nil
    if inst.sg:HasStateTag("busy") then
        return
    end
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
        if target then return BufferedAction(inst,target,ACTIONS.EAT) end
    end

    if not target then
        target = FindEntity(inst, 30, function(item)
            return inst.components.eater:CanEat(item)
        end)
    end
    if target then
        return BufferedAction(inst,target,ACTIONS.PICKUP)
    end
end

local function GetNearestCookpotPos(inst)
    local light = wy_GetClosestInstWithName({"cookpot","icebox","firesuppressor"}, inst, 30)
    if light then
        return Vector3(light.Transform:GetWorldPosition())
    end
    return nil
end

local function GetF(inst)
	return wy_getn(inst.wy_leader.wy_follower)
end

function BatBrain:OnStart()
    local root = PriorityNode(
    {
		--攻击
        ChaseAndAttack(self.inst,self.inst:HasTag("q1bat_leader") and 20 or 10, 40),
		
		--跟随队长
		WhileNode(function() 
			return wy_isalive(self.inst.wy_leader) 
				and GetF(self.inst)<10
			end,"HasLeader", 
			Follow(self.inst, function() return self.inst.wy_leader end, 2, 4, 6, true)),
		--跟随队长
		WhileNode(function() 
			return wy_isalive(self.inst.wy_leader) 
				and GetF(self.inst)>=10 and GetF(self.inst)<20
			end,"HasLeader", 
			Follow(self.inst, function() return self.inst.wy_leader end, 2, 6, 10, true)),
		--跟随队长
		WhileNode(function() 
			return wy_isalive(self.inst.wy_leader) 
				and GetF(self.inst)>=20 and GetF(self.inst)<30
			end,"HasLeader", 
			Follow(self.inst, function() return self.inst.wy_leader end, 2, 10, 18, true)),	
		--跟随队长
		WhileNode(function() 
			return wy_isalive(self.inst.wy_leader) 
				and GetF(self.inst)>=30
			end,"HasLeader", 
			Follow(self.inst, function() return self.inst.wy_leader end, 2, 18, 34, true)),		
		
		DoAction(self.inst, EatFoodAction),
		Wander(self.inst, GetNearestCookpotPos, 5)

    }, .25)
    
    self.bt = BT(self.inst, root)
end

return BatBrain
