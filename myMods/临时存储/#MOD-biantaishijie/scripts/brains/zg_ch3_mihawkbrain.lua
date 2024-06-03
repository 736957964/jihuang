

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 5


local zg_ch3_mihawkbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

---------------------------------------------------------------------------

----	吃食物时
local function EatFoodAction(inst)
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

function zg_ch3_mihawkbrain:OnStart()
    local root = PriorityNode(
    {	
				
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end,
			"AttackMomentarily",
			ChaseAndAttack(self.inst, 20) ),
		WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, 
			"Dodge",
			RunAway(self.inst, function() return self.inst.components.combat.target end, 6, 8) ),
		
		----	吃食物
        DoAction(self.inst, EatFoodAction, "Eat Food"),
		
		----	徘徊
        Wander(self.inst),
		
    }, .1)
    
    self.bt = BT(self.inst, root)

end

return zg_ch3_mihawkbrain