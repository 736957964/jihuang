
local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 6

local MIN_FOLLOW = 4
local MAX_FOLLOW = 11
local MED_FOLLOW = 6 


local Zg_cr_icepigbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

---------------------------------------------------------------------------
---------------------------------------------------------------------------

function Zg_cr_icepigbrain:OnStart()
    local root = PriorityNode(
    {	
		--ChaseAndAttack(self.inst, 33, 33),
		AttackWall(self.inst),
		----	×ßÎ»É±		
        WhileNode( function() 
			return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, 			
			"AttackMomentarily",
			ChaseAndAttack(self.inst, 10, 60) ),      
		--WhileNode( function() 
		--	return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
		--	"Dodge", RunAway(self.inst, function() 
		--	return self.inst.components.combat.target end,  RUN_AWAY_DIST,  STOP_RUN_AWAY_DIST) ),
		WhileNode( function() 
				return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
				"Dodge",
				Panic(self.inst)),
			
		----	¸úËæ
		----Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),
		
		----	ÅÇ»²
        Wander(self.inst),
		
    }, .5)
    
    self.bt = BT(self.inst, root)

end

return Zg_cr_icepigbrain