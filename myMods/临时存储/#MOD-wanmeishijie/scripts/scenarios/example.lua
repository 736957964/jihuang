--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing conquering pigs scenario.")

-- Initializes the chest functions for usage.
-- The file is provided in "scripts/scenarios" of the original game.
local ChestFunctions = require("scenarios/chestfunctions")

-- This function is called when someone triggers our trap on the chest.
local function OnTriggerTrap(inst, scenariorunner)
	-- Create the specific trap elements here.

	-- Clear the scenario so it doesn't run again.
	scenariorunner.ClearScenario(scenariorunner)
end

-- This function is called when the scenario is created.
local function OnCreate(inst, scenariorunner)
	-- Table which will contain the list of items we want to add to our chest.
	local items = 
	{
		{
			-- Prefab name of the item to add to chest.
			item = "blueprint",
			-- The amount of items to add to chest.
			count = 1,
		},

		{
			-- Prefab name of the item to add to chest.
			item = "axe",
			-- The amount of items to add to chest.
			count = 1,
		},
	}

	ChestFunctions.AddChestItems(inst, items)
end

-- This function is called when the scenario is created.
local function OnLoad(inst, scenariorunner)
	ChestFunctions.InitializeChestTrap(inst, scenariorunner, OnTriggerTrap)
end

-- This function is called when the scenario is destroyed.
local function OnDestroy(inst)
	ChestFunctions.OnDestroy(inst)
end

return
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
	OnDestroy = OnDestroy,
}