local function IsPosWithin(x, z, positions, dist)
    dist = dist * dist
    for i, v in ipairs(positions) do
        local distance = VecUtil_DistSq(x, z, v.x, v.z)
        if distance < dist then
            return true
        end
    end
    return false
end
local function SpawnFarm(inst)
	if GROUND.FARMING_SOIL ~= nil then
	    local world = TheWorld
		local map = world.Map
		local _x, _y, _z = inst.Transform:GetWorldPosition()
		local original_tile_type = map:GetTileAtPoint(_x, _y, _z)
		local x, y = map:GetTileCoordsAtPoint(_x, _y, _z)

		local below_soil_turf
		if original_tile_type == GROUND.FARMING_SOIL and TheWorld.components.farming_manager then
			below_soil_turf = TheWorld.components.farming_manager:GetTileBelowSoil(x, y)
		end

		local turf = GROUND.FARMING_SOIL or below_soil_turf or GROUND.DIRT

		map:SetTile(x, y, turf)
		map:RebuildLayer(original_tile_type, x, y)
		map:RebuildLayer(turf, x, y)

		world.minimap.MiniMap:RebuildLayer(original_tile_type, x, y)
		world.minimap.MiniMap:RebuildLayer(turf, x, y)
		
		local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(_x, _y, _z)
		local TILE_EXTENTS = TILE_SCALE * 0.9
		local spawned_positions = {}
		for i = 1, math.random(TUNING.FARM_PLOW_DRILLING_DEBRIS_MIN, TUNING.FARM_PLOW_DRILLING_DEBRIS_MAX) do
			local x = cx + (math.random() * TILE_EXTENTS) - TILE_EXTENTS/2
			local z = cz + (math.random() * TILE_EXTENTS) - TILE_EXTENTS/2
			if not IsPosWithin(x, z, spawned_positions, 1) then
				table.insert(spawned_positions, {x = x, z = z})
				TheWorld.Map:CollapseSoilAtPoint(x, cy, z)
				SpawnPrefab(math.random() < 0.5 and "farm_soil_debris" or "farm_soil").Transform:SetPosition(x, cy, z)
			end
		end

		SpawnPrefab("dirt_puff").Transform:SetPosition(cx + math.random() + 1, cy, cz + math.random() + 1)
		SpawnPrefab("dirt_puff").Transform:SetPosition(cx - math.random() - 1, cy, cz + math.random() + 1)
		SpawnPrefab("dirt_puff").Transform:SetPosition(cx + math.random() + 1, cy, cz - math.random() - 1)
		SpawnPrefab("dirt_puff").Transform:SetPosition(cx - math.random() - 1, cy, cz - math.random() - 1)
	else
		SpawnPrefab("slow_farmplot").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")

    if not TheWorld.ismastersim then
        return inst
    end
	inst.persists = false
    inst:DoTaskInTime(0, SpawnFarm)

    return inst
end
return Prefab("myth_farm_spawn", fn)