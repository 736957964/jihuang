
local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 8

local MIN_FOLLOW = 4
local MAX_FOLLOW = 11
local MED_FOLLOW = 6 


local Zg_mo_bunnybrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

---------------------------------------------------------------------------
---------------------------------------------------------------------------

function Zg_mo_bunnybrain:OnStart()
    local root = PriorityNode(
    {	
		ChaseAndAttack(self.inst, 15, 60),      
			
		----	跟随
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),
		
		----	徘徊
        Wander(self.inst),
		
    }, 1)
    
    self.bt = BT(self.inst, root)

end

return Zg_mo_bunnybrain