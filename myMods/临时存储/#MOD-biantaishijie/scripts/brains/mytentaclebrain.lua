require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/standandattack"
require "behaviours/standstill"

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 25
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 8


local MyTentaclebrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

---------------------------------------------------------------------------
---------------------------------------------------------------------------

function MyTentaclebrain:OnStart()
    local root = PriorityNode(
    {	
	
		----	追赶目标
		ChaseAndAttack(self.inst, MAX_CHASE_TIME),
		----	徘徊
        Wander(self.inst),
		--[[
		----	走位杀		
        WhileNode( function() 
			return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, 			
			"AttackMomentarily",
			ChaseAndAttack(self.inst, 10000, 10000) ),  
			
			
		WhileNode( function() 
			return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
			"Dodge", RunAway(self.inst, function() 
			return self.inst.components.combat.target end,  RUN_AWAY_DIST,  STOP_RUN_AWAY_DIST) ),]]
		
    }, 0)
    
    self.bt = BT(self.inst, root)

end

return MyTentaclebrain