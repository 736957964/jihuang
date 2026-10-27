--[[	Copyright © 2015 Ysovuka/Kzisor	 ]]

-- Print a statement to indicate that we are loading this scenario.
print("Initializing wealthy graves scenario.")

-- This function is used to set up the trap for the scenario.
local function SetTrapOnEntities(inst)
	local parent = inst
	local pt = Vector3(inst.Transform:GetWorldPosition())   
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20)
    local graves = {}
    
    for k,v in pairs(ents) do
        if v and v.prefab == "mound" then
        	v.scene_ondug = function(inst, worker)
        							for i=#parent.graves, 1, -1 do

        								if parent.graves[i] == inst then
        									table.remove(parent.graves, i)
        								end
        							end
        					end

        	v:ListenForEvent("workfinished", v.scene_ondug)
            table.insert(graves, v)        
        end
    end

    return graves
end

-- This function is called when someone triggers our trap on the chest.
local function OnTriggerTrap(inst, scenariorunner)
	-- Create the specific trap elements here.
	local parent = inst

	local new_ghost = SpawnPrefab("ghost")

    if new_ghost ~= nil and (#inst.graves > 0) then
        local x, y, z = inst.graves[math.random(#inst.graves)].Transform:GetWorldPosition()

        ---new_ghost.Transform:SetPosition(x, 0, z)
    end

	-- Clear the scenario so it doesn't run again.
	--scenariorunner.ClearScenario(scenariorunner)
end

-- This function is called when the scenario is created.
local function OnLoad(inst, scenariorunner)
	inst.graves = SetTrapOnEntities(inst)

    inst.scene_onworkedfn = function(inst, worker, workleft) 
										OnTriggerTrap(inst, scenariorunner) 
									end

	inst.scene_ondestroyedfn = function(inst, worker)
										scenariorunner:ClearScenario()
									end

	inst:ListenForEvent("worked", inst.scene_onworkedfn)
	inst:ListenForEvent("workfinished", inst.scene_ondestroyedfn)
end

-- This function is called when the scenario is destroyed.
local function OnDestroy(inst)
	if inst.scene_onworkedfn then
        inst:RemoveEventCallback("worked", inst.scene_onworkedfn)
        inst:RemoveEventCallback("workfinished", inst.scene_ondestroyedfn)
        inst.scene_onworkedfn = nil
    end
end

return
{
	OnLoad = OnLoad,
	OnDestroy = OnDestroy,
}