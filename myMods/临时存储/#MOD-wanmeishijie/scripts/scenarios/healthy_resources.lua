--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing healthy resources scenario.")

-- Table containing the loot for our fire.
local trap_loot =
{
	"houndfire",
	"houndfire",
}

-- Table which contains the entities which could be trapped.
local trap_entities =
{
	"",
	"berrybush",
	"sapling",
	"grass",
	"flower",
}

local function SetTrapHounds(inst)
    local pt = Vector3(inst.Transform:GetWorldPosition())   
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20)
    for k,v in pairs(ents) do
        if v and v.sg and v:HasTag("hound") then
            v.components.sleeper.hibernate = true
            v.sg:GoToState("forcesleep")   
        end
    end
end

-- This function is called when someone triggers our trap on the chest.
local function OnTriggerTrap(inst, scenariorunner)
	-- Create the specific trap elements here.
	inst.components.lootdropper:DropLoot()

	-- Clear the scenario so it doesn't run again.
	scenariorunner.ClearScenario(scenariorunner)
end

-- This function is used to set up the trap for the scenario.
local function SetTrapOnEntities(inst, scenariorunner)
	local trap_entity = trap_entities[math.random(#trap_entities)]

    local parent = inst
    local pt = Vector3(inst.Transform:GetWorldPosition())   
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 5)
   
    for k,v in pairs(ents) do
        if v and v.prefab == trap_entity then
        	if not v.components.lootdropper then
				v:AddComponent("lootdropper")
			end

			v.components.lootdropper:SetLoot(trap_loot)

            v.scene_onpickedfn = function(inst, picker, loot) 
								OnTriggerTrap(inst, scenariorunner) 
							end

			v:ListenForEvent("picked", v.scene_onpickedfn)     
        end
    end
end

-- This function is called when the scenario is created.
local function OnLoad(inst, scenariorunner)
	SetTrapHounds(inst)
	SetTrapOnEntities(inst, scenariorunner)
end

return
{
	OnLoad = OnLoad,
}