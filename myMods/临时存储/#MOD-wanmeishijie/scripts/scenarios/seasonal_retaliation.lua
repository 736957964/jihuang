--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing seasonal retaliation scenario.")

-- Initializes the chest functions for usage.
-- The file is provided in "scripts/scenarios" of the original game.
local ChestFunctions = require("scenarios/chestfunctions")

local RemoveListener = function(inst, event, prefab)
    if inst.event_listening then
        for e, sources  in pairs(inst.event_listening) do
            if e == event then
                for s, _ in pairs(sources) do
                    if prefab == nil and s.event_listeners and s.event_listeners[e] then
                        s.event_listeners[e][inst] = nil
                    elseif s.prefab == prefab and s.event_listeners and s.event_listeners[e] then
                        s.event_listeners[e][inst] = nil
                    end
                end
            end
        end
    end    

    if inst.event_listeners then
        for e, listeners in pairs(inst.event_listeners) do
            if e == event then
                for listener, _ in pairs(listeners) do
                    if listener.event_listening and listener.event_listening[e] then
                        listener.event_listening[e][inst] = nil
                    end
                end
            end
        end
    end
end

-- This function is used to set up the trap for the scenario.
local function SetTrapOnEntities(inst)
    local parent = inst
    local pt = Vector3(inst.Transform:GetWorldPosition())   
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10)
    local containers = {}
    
    for k,v in pairs(ents) do
        if v and v.prefab == "treasurechest" or v.prefab == "icebox" then
            table.insert(containers, v)        
        end
    end

    return containers
end

local function GetChest(inst)
    local parent = inst
    local pt = Vector3(inst.Transform:GetWorldPosition())   
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 5)
    
    for k,v in pairs(ents) do
        if v and v.prefab == "treasurechest" then
            return v      
        end
    end

    return nil
end

-- This function is called when someone triggers the summer trap.
local function OnTriggerSummerTrap(inst, scenariorunner)
	-- Create the specific trap elements here.
	local pt = Vector3(inst.Transform:GetWorldPosition())

    if IsDontStarveTogether() then
        TheWorld:PushEvent("ms_setseason", "summer")
        TheWorld:PushEvent("ms_advanceseason")
        TheWorld:PushEvent("ms_advanceseason")
    else
        GetWorld().components.seasonmanager:StartSummer()
        GetWorld().components.seasonmanager:Advance()
        GetWorld().components.seasonmanager:Advance()
    end

    local numhounds = math.random(1, 5)

    for i = 1, numhounds do
        local spawn = SpawnPrefab("firehound")

        if spawn then
            spawn.Transform:SetPosition(pt.x - math.random(1, 15), pt.y, pt.z - math.random(1, 15))
        end

    end

	-- Clear the scenario so it doesn't run again.
	--scenariorunner:ClearScenario()
end

-- This function is called when someone triggers the winter trap.
local function OnTriggerWinterTrap(inst, scenariorunner)
	local pt = Vector3(inst.Transform:GetWorldPosition())

    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/distant")
    
    if IsDontStarveTogether() then
        TheWorld:PushEvent("ms_setseason", "winter")
        TheWorld:PushEvent("ms_advanceseason")
        TheWorld:PushEvent("ms_advanceseason")
        TheWorld:PushEvent("ms_forceprecipitation", true)
    else
        GetWorld().components.seasonmanager:StartWinter()
        GetWorld().components.seasonmanager:Advance()
        GetWorld().components.seasonmanager:Advance()
        GetWorld().components.seasonmanager:ForcePrecip()
    end

    local numhounds = math.random(1, 5)

    for i = 1, numhounds do
        local spawn = SpawnPrefab("icehound")

        if spawn then
            spawn.Transform:SetPosition(pt.x - math.random(1, 15), pt.y, pt.z - math.random(1, 15))
        end
    end

    -- Clear the scenario so it doesn't run again.
	--scenariorunner:ClearScenario()
end

-- This function is called when someone triggers the spring trap.
local function OnTriggerSpringTrap(inst, scenariorunner)
	local pt = Vector3(inst.Transform:GetWorldPosition())
    
    if IsDontStarveTogether() then
        TheWorld:PushEvent("ms_setseason", "spring")
        TheWorld:PushEvent("ms_advanceseason")
        TheWorld:PushEvent("ms_advanceseason")
        TheWorld:PushEvent("ms_forceprecipitation", true)
    else
        GetWorld().components.seasonmanager:StartSpring()
        GetWorld().components.seasonmanager:Advance()
        GetWorld().components.seasonmanager:Advance()
        GetWorld().components.seasonmanager:ForcePrecip()
    end

    local numhounds = math.random(1, 5)

    for i = 1, numhounds do
        local spawn = SpawnPrefab("hound")

        if spawn then
            spawn.Transform:SetPosition(pt.x - math.random(1, 15), pt.y, pt.z - math.random(1, 15))
        end
    end

    -- Clear the scenario so it doesn't run again.
	--scenariorunner:ClearScenario()
end

-- This function is called when someone triggers the autumn trap.
local function OnTriggerAutumnTrap(inst, scenariorunner)
	local pt = Vector3(inst.Transform:GetWorldPosition())
    
    if IsDontStarveTogether() then
        TheWorld:PushEvent("ms_setseason", "autumn")
        TheWorld:PushEvent("ms_advanceseason")
        TheWorld:PushEvent("ms_advanceseason")
        TheWorld:PushEvent("ms_forceprecipitation", true)
    else
        GetWorld().components.seasonmanager:StartAutumn()
        GetWorld().components.seasonmanager:Advance()
        GetWorld().components.seasonmanager:Advance()
        GetWorld().components.seasonmanager:ForcePrecip()
    end

    local numhounds = math.random(1, 5)

    for i = 1, numhounds do
        local spawn = SpawnPrefab("hound")

        if spawn then
            spawn.Transform:SetPosition(pt.x - math.random(1, 15), pt.y, pt.z - math.random(1, 15))
        end
    end

    -- Clear the scenario so it doesn't run again.
	--scenariorunner:ClearScenario()
end

-- This function is called when someone triggers any seasonal trap.
local function OnTriggerTrap(inst, scenariorunner)
    -- Table used to randomly select the trap which will be triggered.
    local TrapFn = {}

    if IsDLCEnabled(REIGN_OF_GIANTS) or IsDontStarveTogether() then
        table.insert(TrapFn, OnTriggerSpringTrap)
        table.insert(TrapFn, OnTriggerSummerTrap)
        table.insert(TrapFn, OnTriggerAutumnTrap)
        table.insert(TrapFn, OnTriggerWinterTrap)
    else
        table.insert(TrapFn, OnTriggerSummerTrap)
        table.insert(TrapFn, OnTriggerWinterTrap)
    end

    TrapFn[math.random(#TrapFn)](inst, scenariorunner)
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
			count = math.random(1, 9),
		},
	}

	ChestFunctions.AddChestItems(GetChest(inst), items)
end

-- This function is called when the scenario is created.
local function OnLoad(inst, scenariorunner)
    local containers = SetTrapOnEntities(inst)

    local trap_inst = containers[math.random(#containers)]

    trap_inst.trap_triggered = false
    trap_inst:ListenForEvent("onopen", function(inst) RemoveListener(trap_inst, "onopen", trap_inst.prefab) RemoveListener(trap_inst, "worked", trap_inst.prefab) end)
    trap_inst:ListenForEvent("worked", function(inst) RemoveListener(trap_inst, "onopen", trap_inst.prefab) RemoveListener(trap_inst, "worked", trap_inst.prefab) end)
    
    if trap_inst.trap_triggered == false then
	   ChestFunctions.InitializeChestTrap(trap_inst, scenariorunner, OnTriggerTrap)
    end
end

-- This function is called when the scenario is destroyed.
local function OnDestroy(inst)
	ChestFunctions.OnDestroy(inst)
end

return
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
	OnDestroy = OnDestroy
}