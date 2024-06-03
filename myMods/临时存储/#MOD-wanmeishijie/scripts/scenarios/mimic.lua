--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing mimic scenario.")

-- Initializes the chest functions for usage.
-- The file is provided in "scripts/scenarios" of the original game.
local ChestFunctions = require("scenarios/chestfunctions")

-- List of walls we will randomly select from with this trap.
local walls = {
    "wall_hay",
    "wall_wood",
    "wall_stone",
    "wall_moonrock",
}

-- List of creatures we will randomly select from with this trap.
local creatures = {
	"hound",
	"spider",
	"spiderwarrior",
	"tentacle",
	"rook",
	"knight",
	"bishop",
}

local function OnWork(inst, worker, workleft)
	local pt = Vector3(inst.Transform:GetWorldPosition())

	local creature = creatures[math.random(#creatures)]

	local spawn = SpawnPrefab(creature)

	if spawn then
		spawn.Transform:SetPosition(pt.x - 1, pt.y, pt.z - 1)
	end
end

-- This function is called when someone triggers our trap on the chest.
local function OnTriggerTrap(inst, scenariorunner)
	-- Create the specific trap elements here.
	   local pt = Vector3(inst.Transform:GetWorldPosition())

    local wall_prefab = walls[math.random(#walls)]

    -- Spawn one side of the enclosure.
    for i = 1, 13 do
    	local wall = SpawnPrefab(wall_prefab)
    	wall.Transform:SetPosition(pt.x - 6, pt.y, pt.z- 13 + (i+6))
    	wall:ListenForEvent("worked", OnWork)
    	wall:ListenForEvent("workfinished", function(inst)
    		scenariorunner.ClearScenario(scenariorunner)
    	end)
    end

    -- Spawn one side of the enclosure.
    for i = 1, 12 do
    	local wall = SpawnPrefab(wall_prefab)
    	wall.Transform:SetPosition(pt.x + 6, pt.y, pt.z- 12 + (i+6))
    	wall:ListenForEvent("worked", OnWork)
    	wall:ListenForEvent("workfinished", function(inst)
    		scenariorunner.ClearScenario(scenariorunner)
    	end)
    end

    -- Spawn one side of the enclosure.
    for i = 1, 12 do
    	local wall = SpawnPrefab(wall_prefab)
       	wall.Transform:SetPosition(pt.x- 12 + (i+6), pt.y, pt.z- 6)
    	wall:ListenForEvent("worked", OnWork)
    	wall:ListenForEvent("workfinished", function(inst)
    		scenariorunner.ClearScenario(scenariorunner)
    	end)
    end

        -- Spawn one side of the enclosure.
    for i = 1, 12 do
    	local wall = SpawnPrefab(wall_prefab)
    	wall.Transform:SetPosition(pt.x- 12 + (i+6), pt.y, pt.z+ 6)
    	wall:ListenForEvent("worked", OnWork)
    	wall:ListenForEvent("workfinished", function(inst)
    		scenariorunner.ClearScenario(scenariorunner)
    	end)
    end

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
			item = "hammer",
			-- The amount of items to add to chest.
			count = 1,
		},

		{
			-- Prefab name of the item to add to chest.
			item = { "armorwood", "armormarble", "armor_sanity" },
			-- The amount of items to add to chest.
			count = 1,
		},

		{
			-- Prefab name of the item to add to chest.
			item = { "spear", "hambat", "nightsword" },
			-- The amount of items to add to chest.
			count = 1,
		},

		{
			-- Prefab name of the item to add to chest.
			item = { "redgem", "bluegem", "purplegem" },
			-- The amount of items to add to chest.
			count = math.random(1, 3),
		},

		{
			-- Prefab name of the item to add to chest.
			item = { "footballhelmet" },
			-- The amount of items to add to chest.
			count = 1,
			-- The chance of this item being placed in the chest.
			chance = math.random(.01, .25),
		},

		{
			-- Prefab name of the item to add to chest.
			item = "nightmarefuel",
			-- The amount of items to add to chest.
			count = math.random(1, 5),
			-- The chance of this item being placed in the chest.
			chance = math.random(.01, .50),
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