--[[
晚上没有花时，趋向于火焰，类似飞蛾扑火
白天倾向于花瓣，酿造花粉
]]
require "behaviours/q1butterfly_findflower"

local q1butterfly_b = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

-------------------------------------------------------------------------------
local function NearestFlowerPos(inst)
    local flower = GetClosestInstWithTag("flower", inst, 30)
    if flower and flower:IsValid() then
        return Vector3(flower.Transform:GetWorldPosition() )
	--else
		--return Vector3(flower.Transform:GetWorldPosition() )
    end
end

local function GetNearestLightPos(inst)
    local light = GetClosestInstWithTag("lightsource", inst, 20)
    if light then
        return Vector3(light.Transform:GetWorldPosition())
    end
    return nil
end

local function GetNearestLightRadius(inst)
    local light = GetClosestInstWithTag("lightsource", inst, 20)
    if light then
        return light.Light:GetCalculatedRadius()
    end
    return 1
end

local function SafeLightDist(inst, target)
    return (target:HasTag("player") or target:HasTag("playerlight")
            or (target.inventoryitem and target.inventoryitem:GetGrandOwner() and target.inventoryitem:GetGrandOwner():HasTag("player")))
        and 4
        or target.Light:GetCalculatedRadius() / 3
end
--------------------------------------------------------------------------------


function q1butterfly_b:OnStart()
	
	local day = 
	WhileNode(
		function() return TheWorld.state.isday end, "IsDay",
		PriorityNode{
			q1butterfly_findflower(self.inst),
			--Wander(self.inst, NearestFlowerPos, 20),    
			Wander(self.inst),
		},
		.25)
		
	local night = 
	WhileNode(
		function() return not TheWorld.state.isday end, "IsNight",
		PriorityNode{
			q1butterfly_findflower(self.inst),
			WhileNode(function() return TheWorld.state.isnight  end, "IsInLight",
				Wander(self.inst, GetNearestLightPos, GetNearestLightRadius, {
					minwalktime = 0.6,
					randwalktime = 0.2,
					minwaittime = 5,
					randwaittime = 5
				})
			),
			FindLight(self.inst, 60, SafeLightDist),
			Wander(self.inst),    
		},
		.25)

    local root =
    PriorityNode(
    {
		ChaseAndAttack(self.inst, 12),
        day,
        night,
    },.25)

    self.bt = BT(self.inst, root)
end

return q1butterfly_b
