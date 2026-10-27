--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing koalefant farm scenario.")

-- List of creatures we will randomly select from with this trap.
local creatures = {
	"koalefant_summer",
	"koalefant_winter",
}

if KnownModIndex:IsModEnabled("Koalefanta Proboscidea [DST]") then
	table.insert(creatures, "koalefant_feathered")
	table.insert(creatures, "koalefant_rocky")
	table.insert(creatures, "koalefant_forest")
	table.insert(creatures, "koalefant_nightmare")
	table.insert(creatures, "koalefant_frost_base")
	table.insert(creatures, "koalefant_albino_base")
end

-- This function is called when the scenario is created.
local function OnLoad(inst, scenariorunner)
	-- Create the specific elements here.
	local pt = Vector3(inst.Transform:GetWorldPosition())
	
	local spawn = SpawnPrefab(creatures[math.random(#creatures)])

    if spawn then
        spawn.Transform:SetPosition(pt.x - math.random(1, 15), pt.y, pt.z - math.random(1, 15))
    end

	-- Clear the scenario so it doesn't run again.
	scenariorunner.ClearScenario(scenariorunner)
end
return
{
	OnLoad = OnLoad,
}