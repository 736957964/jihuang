local prefabs =
{
    "dragonfly",
}

local function OnKilled(inst)
    inst.components.timer:StartTimer("regen_myth_forg", 480*20)
end

local function GenerateNewDragon(inst)
    inst.components.childspawner:AddChildrenInside(1)
    inst.components.childspawner:StartSpawning()
end

local function ontimerdone(inst, data)
    if data.name == "regen_myth_forg" then
        GenerateNewDragon(inst)
    end
end

local function onspawned(inst, child)
    local x, y, z = child.Transform:GetWorldPosition()
    child.Transform:SetPosition(x, 0, z)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "myth_goldfrog_base"
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(1, 0)
    inst.components.childspawner.onchildkilledfn = OnKilled
    inst.components.childspawner:StartSpawning()
    inst.components.childspawner:StopRegen()
    inst.components.childspawner:SetSpawnedFn(onspawned)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)

    return inst
end

return Prefab("myth_goldfrog_spawner", fn, nil, prefabs)
