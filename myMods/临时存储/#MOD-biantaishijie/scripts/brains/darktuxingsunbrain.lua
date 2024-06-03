require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/standandattack"
require "behaviours/standstill"

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 5
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 8

local MIN_FOLLOW_DIST = 5
local TARGET_FOLLOW_DIST = 7
local MAX_FOLLOW_DIST = 10

local DarkWendybrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

---------------------------------------------------------------------------
----	定位玩家
local function followplayer(inst)
	local invader = nil
    invader = FindEntity(inst, 100, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	return invader
end

----	吃食物时
local function EatFoodAction(inst)
    if(inst.components.combat.target)then return end
    local target = nil
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    if not target then
        target = FindEntity(inst, 30, function(item) return inst.components.eater:CanEat(item) end)
    end
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem.owner and target.components.inventoryitem.owner ~= inst) end
        return act
    end
end
---------------------------------------------------------------------------

function DarkWendybrain:OnStart()
    local root = PriorityNode(
    {	
		----	走位杀		
        WhileNode( function() 
			return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, 			
			"AttackMomentarily",
			ChaseAndAttack(self.inst, 10000, 10000) ),      
		WhileNode( function() 
			return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
			"Dodge", RunAway(self.inst, function() 
			return self.inst.components.combat.target end,  RUN_AWAY_DIST,  STOP_RUN_AWAY_DIST) ),
		
		----	吃食物
        DoAction(self.inst, EatFoodAction, "Eat Food"),
		
		----	跟随玩家
		--Follow(self.inst, function() return followplayer(self.inst) end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		
		----	徘徊
        Wander(self.inst, function() 
            if(self.inst.components.homeseeker and self.inst.components.homeseeker.home)then
                return self.inst.components.homeseeker:GetHomePos()
            elseif(self.inst.components.knownlocations and self.inst.components.knownlocations:GetLocation("home"))then
                return self.inst.components.knownlocations:GetLocation("home")
            else
                return Vector3(self.inst.Transform:GetWorldPosition())
            end
        end, MAX_WANDER_DIST),
		
    }, 0)
    
    self.bt = BT(self.inst, root)

end

return DarkWendybrain