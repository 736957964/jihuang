require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/findflower"
require "behaviours/panic"

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 10
local POLLINATE_FLOWER_DIST = 10
local SEE_FLOWER_DIST = 30
local MAX_WANDER_DIST = 20


local ButterflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function NearestFlowerPos(inst)
    local flower = GetClosestInstWithTag("flower", inst, SEE_FLOWER_DIST)
    if flower and 
       flower:IsValid() then
        return Vector3(flower.Transform:GetWorldPosition() )
    end
end

function ButterflyBrain:OnStart()

    local root =
        PriorityNode(
        {
			AttackWall(self.inst),
			----	×ßÎ»É±		
			WhileNode( function() 
				return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, 			
				"AttackMomentarily",
				ChaseAndAttack(self.inst, 5, 15) ),      
			--WhileNode( function() 
			--	return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
			--	"Dodge", RunAway(self.inst, function() 
			--	return self.inst.components.combat.target end,  6,  8) ),
			WhileNode( function() 
				return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
				"Dodge",
				Panic(self.inst)),
				
            Wander(self.inst, NearestFlowerPos, MAX_WANDER_DIST)           
        }, .5)
    
    
    self.bt = BT(self.inst, root)
    
         
end

return ButterflyBrain