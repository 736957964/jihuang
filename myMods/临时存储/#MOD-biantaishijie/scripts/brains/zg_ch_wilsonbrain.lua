

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 8


local Zg_ch_wilsonbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

---------------------------------------------------------------------------

----	吃食物时
local function EatFoodAction(inst)
    --if (inst.components.combat.target) then return end
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
function Zg_ch_wilsonbrain:CanSpawnChild(inst)   
    ---local num = inst.NumPerdsToSpawn(inst)
    ---return num > 0 and self.inst.components.combat.target
end

function Zg_ch_wilsonbrain:OnStart()
    local root = PriorityNode(
    {	
		----	主动召唤
		MinPeriod(self.inst, 30, true,
			IfNode(function()
			
				return self:CanSpawnChild(self.inst) and not self.inst.sg:HasStateTag("pound") 
				
				end, 
				
				"needs follower", 
				
				ActionNode(function() 
					self.inst.sg:GoToState("summon_perd") 
					--self.inst:PushEvent("summon_perd") 
					return SUCCESS end, 
					"Summon Perd" ))),
	
		----	进攻
		ChaseAndAttack(self.inst, 15 , 60 ) ,      
		
		----	吃食物
        DoAction(self.inst, EatFoodAction, "Eat Food"),
		
		----	徘徊
        Wander(self.inst),
		
    }, .25)
    
    self.bt = BT(self.inst, root)

end

return Zg_ch_wilsonbrain