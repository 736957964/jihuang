--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing colourful mushroom farm scenario.")

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
	"poop",
	"blue_mushroom",
	"red_mushroom",
	"green_mushroom",
}

-- This function is called when someone triggers our trap on the chest.
local function OnTriggerTrap(inst, scenariorunner, x, y, z)
	-- Create the specific trap elements here.
	if inst.prefab == "poop" then		
		local houndfire = SpawnPrefab("houndfire")		
        
        houndfire.Transform:SetPosition(x - 3, y, z - 3)
    else

		inst.components.lootdropper:DropLoot()
	end

	-- Clear the scenario so it doesn't run again.
	scenariorunner.ClearScenario(scenariorunner)
end

-- This function is used to set up the trap for the scenario.
local function GetPoop(inst)
    local parent = inst
    local pt = Vector3(inst.Transform:GetWorldPosition())   
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 15)
    local poop = {}
    for k,v in pairs(ents) do
        if v.prefab == "poop" then
        	table.insert(poop, v)
        end
    end

    return poop
end

-- This function is used to set up the trap for the scenario.
local function SetTrapOnEntities(inst, scenariorunner)
    local parent = inst
    local pt = Vector3(inst.Transform:GetWorldPosition())   
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 15)
   
    for k,v in pairs(ents) do
        if v.prefab == "blue_mushroom" or v.prefab == "red_mushroom" or v.prefab == "green_mushroom" then
        	if not v.components.lootdropper then
				v:AddComponent("lootdropper")
			end

			v.components.lootdropper:SetLoot(trap_loot)

           	v.scene_onworkedfn = function(inst, worker, workleft) 
							OnTriggerTrap(inst, scenariorunner) 
						end

			v:ListenForEvent("worked", v.scene_onpickedfn)
        end
    end
end

-- This function is called when the scenario is created.
local function OnLoad(inst, scenariorunner)
	SetTrapOnEntities(inst, scenariorunner)

	for i = 1, 5 do
		local poop = GetPoop(inst)
        
        if poop then
		    --local v = poop[math.random(#poop)]
	 	 --   local x, y, z = v.Transform:GetWorldPosition()
		 	  --  v.scene_putininventoryfn = function(inst) 
		 		    			--OnTriggerTrap(inst, scenariorunner, x, y, z) 
		 			    	--end
		 	    --v:ListenForEvent("onpickup", v.scene_putininventoryfn)
        end
	end

end

return
{
	OnLoad = OnLoad,
}