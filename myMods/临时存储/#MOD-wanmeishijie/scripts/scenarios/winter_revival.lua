--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing winter revival scenario.")

-- Initializes the chest functions for usage.
-- The file is provided in "scripts/scenarios" of the original game.
local ChestFunctions = require("scenarios/chestfunctions")

-- This function is called when the scenario is created.
local function OnCreate(inst, scenariorunner)
	-- Table which will contain the list of items we want to add to our chest.
	local items = 
	{
		{
			-- Prefab name of the item to add to chest.
			item = "axe",
			-- The amount of items to add to chest.
			count = 1,
		},

		{
			-- Prefab name of the item to add to chest.
			item = "flint",
			-- The amount of items to add to chest.
			count = math.random(1, 10)
		},

		{
			-- Prefab name of the item to add to chest.
			item = "cutgrass",
			-- The amount of items to add to chest.
			count = math.random(1, 10)
		},

		{
			-- Prefab name of the item to add to chest.
			item = "twigs",
			-- The amount of items to add to chest.
			count = math.random(1, 10)
		},

		{
			-- Prefab name of the item to add to chest.
			item = "log",
			-- The amount of items to add to chest.
			count = math.random(1, 10)
		},		
	}

	ChestFunctions.AddChestItems(inst, items)
end

return
{
	OnCreate = OnCreate,
}