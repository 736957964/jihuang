

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 8

local MIN_FOLLOW = 4
local MAX_FOLLOW = 11
local MED_FOLLOW = 7 


local Zg_ch0_sweeper = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

--------------------------------------------------------------------------
----	αװ
local function PretentAction(inst)
    if (inst.components.combat.target) then return end

	if inst.sg and not inst.sg:HasStateTag("hiding") then
		inst.sg:GoToState("hide")
		return true
	end
	
	return
end
---------------------------------------------------------------------------

function Zg_ch0_sweeper:OnStart()
    local root = PriorityNode(
    {	

		AttackWall(self.inst),
		
		ChaseAndAttack(self.inst, 20, 20), 

		
		--Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),
		
		
		--DoAction(self.inst, PretentAction, "Pretent"),
		
		
        ----Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, 5)
		
    }, .5)
    
    self.bt = BT(self.inst, root)

end

return Zg_ch0_sweeper