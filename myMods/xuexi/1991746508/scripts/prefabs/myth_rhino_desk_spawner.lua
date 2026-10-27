local prefabs =
{
    "myth_rhino_desk",
}

local function dospawn(inst, child)
	if inst.canspawn then
		inst.canspawn = false
		local child = SpawnPrefab("myth_rhino_desk")
    	local x, y, z = inst.Transform:GetWorldPosition()
   	 	child.Transform:SetPosition(x, 0, z)
		child.nodormove = true
	end
end

local function onload(inst, data)
    if data ~= nil and data.canspawn ~= nil then
        inst.canspawn = data.canspawn
    end
end

local function onsave(inst, data)
    data.canspawn = inst.canspawn
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")

	inst.canspawn = true

	inst:DoTaskInTime(0,dospawn)
    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end


local function dopondspawn(inst, child)
	local child = SpawnPrefab("pond")
    if child then
   	    child.Transform:SetPosition(inst.Transform:GetWorldPosition())
        if child.components.myth_lotus_grower then
            child.components.myth_lotus_grower:PlantItem()
        end
    end
	inst:Remove()
end

local function pondfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")
	inst:DoTaskInTime(0,dopondspawn)

    return inst
end

return Prefab("myth_rhino_desk_spawner", fn, nil, prefabs),
    Prefab("myth_pond_spawner", pondfn)
