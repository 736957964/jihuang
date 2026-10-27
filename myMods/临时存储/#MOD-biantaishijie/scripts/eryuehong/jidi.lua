local function basecampspawn(prefab,x,y,z)
	GLOBAL.DebugSpawn(prefab).Transform:SetPosition(x, y, z)
end
local function basecampspawna(prefab,x,y,z,a)
	local prefaba = GLOBAL.DebugSpawn(prefab).Transform
	prefaba:SetPosition(x, y, z)
	prefaba:SetRotation(a)
end
local function basecampcanturf(pt)
    local ground = GLOBAL.GetWorld()
    if ground then
		local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
		return tile ~= GLOBAL.GROUND.IMPASSIBLE and tile < GLOBAL.GROUND.UNDERGROUND --and not ground.Map:IsWater(tile)
	end
	return false
end
local function basecampturf(turf, pt)	
	local ground = GLOBAL.GetWorld()
	if ground and basecampcanturf(pt) then
		local original_tile_type = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
		local x, y = ground.Map:GetTileCoordsAtPoint(pt.x, pt.y, pt.z)
		if x and y then
			ground.Map:SetTile(x,y, turf)
			ground.Map:RebuildLayer( original_tile_type, x, y )
			ground.Map:RebuildLayer( turf, x, y )
		end
		local minimap = TheSim:FindFirstEntityWithTag("minimap")
		if minimap then
			minimap.MiniMap:RebuildLayer( original_tile_type, x, y )
			minimap.MiniMap:RebuildLayer( turf, x, y )
		end
	end
end
local function basecampmonkeyball(container,x,y,z)
	if (container == "piggyback") or (container == "treasurechest") then
		local prefabc = GLOBAL.DebugSpawn(container)
		prefabc.Transform:SetPosition(x, y, z)
		local prefabm = GLOBAL.DebugSpawn("monkeyball")
		prefabm.Transform:SetPosition(x, y, z)
		prefabc.components.container:GiveItem(prefabm, 1, nil, false)
	end
end

--dzx home rog
local function jidi()
	if GLOBAL.GetPlayer() ~= nil then
		local x, y, z = GLOBAL.GetPlayer().Transform:GetWorldPosition()
		x = math.floor(x/4)*4
		y = 0
		z = math.floor(z/4)*4

		--地皮设置
		--CHECKER 棋盘地板
		--CARPET 地毯地板
		--ROAD 卵石路
		--fireflies 萤火虫

		--铺地皮

		basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(x, y, z+4*4))
		for i=x-4*1,x+4*1,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z+4*3)) end
		for i=x-4*2,x+4*2,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z+4*2)) end
		for i=x-4*3,x+4*3,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z+4*1)) end
		for i=x-4*4,x+4*4,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z)) end
		for i=x-4*3,x+4*3,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z-4*1)) end
		for i=x-4*2,x+4*2,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z-4*2)) end
		for i=x-4*1,x+4*1,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z-4*3)) end
		for i=x-4*1,x+4*1,4*1 do basecampturf(GLOBAL.GROUND.CHECKER, GLOBAL.Vector3(i, y, z-4*3)) end


		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x, y, z+4*5))

		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*1, y, z+4*4))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*1, y, z+4*4))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*2, y, z+4*3))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*2, y, z+4*3))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*3, y, z+4*2))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*3, y, z+4*2))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*4, y, z+4*1))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*4, y, z+4*1))

		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*5, y, z))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*5, y, z))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*2, y, z))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*2, y, z))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x, y, z))

		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*4, y, z-4*1))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*4, y, z-4*1))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*3, y, z-4*2))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*3, y, z-4*2))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*2, y, z-4*3))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*2, y, z-4*3))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x-4*1, y, z-4*4))
		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x+4*1, y, z-4*4))

		basecampturf(GLOBAL.GROUND.CARPET, GLOBAL.Vector3(x, y, z-4*5))

		--建筑布局

		--basecampspawn("firesuppressor", x, y, z) --基地中心，灭火器0
		--basecampspawn("firesuppressor", x, y, z+4*10) --灭火器1
		--basecampspawn("firesuppressor", x-4*5, y, z+4*5) --草，灭火器2
		--basecampspawn("firesuppressor", x+4*5, y, z+4*5) --浆果，灭火器3
		--basecampspawn("firesuppressor", x-4*10, y, z) --肉架附近未使用，灭火器4
		--basecampspawn("firesuppressor", x-4*5, y, z-4*5) --肉架，灭火器5
		--basecampspawn("firesuppressor", x+4*5, y, z-4*5) --农场，灭火器6
		--basecampspawn("firesuppressor", x+4*10, y, z) --农场附近未使用，灭火器7
		--basecampspawn("firesuppressor", x, y, z-4*20) --蜜蜂，灭火器8
		--basecampspawn("firesuppressor", x-4*5, y, z-4*15) --猪房，灭火器9
		--basecampspawn("firesuppressor", x+4*5, y, z-4*15) --兔房，灭火器10

		---basecampspawn("homesign", x, y, z-4*5)--木牌

		--basecampspawn("lightning_rod", x, y, z+4*5)--靠近草，避雷针1
		--basecampspawn("lightning_rod", x-4*5, y, z)--靠近肉架，避雷针2
		--basecampspawn("lightning_rod", x+4*5, y, z)--靠近农场，避雷针3
		--basecampspawn("lightning_rod", x, y, z-4*15)--猪房附近避雷针4

		basecampspawn("cookpot", x-2, y, z-4*2-2)--锅子位置
		basecampspawn("cookpot", x-2, y, z-4*2+2)
		basecampspawn("cookpot", x+2, y, z-4*2-2)
		basecampspawn("cookpot", x+2, y, z-4*2+2)

		basecampspawn("icebox", x-3/2, y, z-4*2)--冰箱位置
		basecampspawn("icebox", x+3/2, y, z-4*2)
		basecampspawn("icebox", x, y, z-4*2-3/2)
		basecampspawn("icebox", x, y, z-4*2+3/2)
		basecampspawn("icebox", x, y, z-4*2-4)
		basecampspawn("icebox", x-10, y, z-10)
		basecampspawn("icebox", x+10, y, z-10)

		basecampspawn("birdcage", x-8, y, z-8)--鸟笼
		basecampspawn("birdcage", x+8, y, z-8)

		basecampspawn("researchlab3", x-4, y, z)--科技
		basecampspawn("researchlab2", x+4, y, z)

		--basecampspawn("siestahut", x-8, y, z)--帐篷
		basecampspawn("tent", x+8, y, z)

		--basecampspawn("winterometer", x+12, y, z)--温度计
		--basecampspawn("rainometer", x-12, y, z)--雨量计

		--dragonflychest 龙鳞箱子
		--treasurechest 木箱
		--skullchest 骷髅箱

		basecampspawn("dragonflychest", x, y, z-4*4)--燃料箱

		for i=x-4,x+4,2 do--基地，箱子位置，间2，这是骷髅箱子
			for j=z+4,z+12,2 do
				basecampspawn("skullchest", i, y, j)
			end
		end

		for i=x-14+1/2,x-10-1/2,3/2 do--草，箱子位置，间3/2，这是木箱
			for j=z+10+1/2,z+14-1/2,3/2 do
				basecampspawn("treasurechest", i, y, j)
			end
		end

		basecampspawn("firepit", x-(4*1+2), y, z-(4*3+2))--火堆位置
		basecampspawn("coldfirepit", x+(4*1+2), y, z-(4*3+2))
		basecampspawn("firepit", x-(4*3+2), y, z+(4*1+2))
		basecampspawn("coldfirepit", x-(4*3+2), y, z-(4*1+2))
		basecampspawn("firepit", x+(4*3+2), y, z-(4*1+2))
		basecampspawn("coldfirepit", x+(4*3+2), y, z+(4*1+2))
		basecampspawn("firepit", x+(4*1+2), y, z+(4*3+2))--火堆位置
		basecampspawn("coldfirepit", x-(4*1+2), y, z+(4*3+2))

		--basecampspawn("firesuppressor", x-4*5, y, z+4*5) --草，灭火器2
		for i=x-4*5-4*2,x-4*5+3,1 do--树枝
			for j=z+4*5-12,z+4*5-12+3,1 do
				basecampspawn("sapling", i, y, j)
			end
		end
		for i=x-4*5-12,x-4*5+3,1 do
			for j=z+4*5-8,z+4*5-4,1 do
				basecampspawn("sapling", i, y, j)
			end
		end
		for i=x-4*5-12,x-4*5-4,1 do
			for j=z+4*5-3,z+4*5+3,1 do
				basecampspawn("sapling", i, y, j)
			end
		end

		for i=x-4*5+4,x-4*5+12,1 do--草
			for j=z+4*5-3,z+4*5+3,1 do
				basecampspawn("grass", i, y, j)
			end
		end
		for i=x-4*5-12,x-4*5+12,1 do
			for j=z+4*5+4,z+4*5+8,1 do
				basecampspawn("grass", i, y, j)
			end
		end
		for i=x-4*5-8,x-4*5+8,1 do
			for j=z+4*5+9,z+4*5+12,1 do
				basecampspawn("grass", i, y, j)
			end
		end

		--basecampspawn("firesuppressor", x+4*5, y, z+4*5) --浆果，灭火器3
		--两种浆果 berrybush2 三叶 berrybush 普通
		basecampspawn("berrybush2", x+4*5-8, y, z+4*5-8)--浆果陷阱
		basecampspawn("powcake", x+4*5-8, y, z+4*5-8)--浆果陷阱,内容物为芝士蛋糕
		for i=x+4*5-8-3/2,x+4*5-8+3/2,1 do basecampspawn("wall_stone", i, y, z+4*5-10+1/2) end --浆果陷阱位置
		for i=x+4*5-8-3/2,x+4*5-8+3/2,3 do basecampspawn("wall_stone", i, y, z+4*5-9+1/2) end
		for i=x+4*5-8-3/2,x+4*5-8+3/2,3 do basecampspawn("wall_stone", i, y, z+4*5-8+1/2) end
		for i=x+4*5-8-3/2,x+4*5-8+3/2,1 do basecampspawn("wall_stone", i, y, z+4*5-7+1/2) end

		for i=x+4*5-4,x+4*5+8,2 do basecampspawn("berrybush2", i, y, z+4*5-12) end --浆果位置
		for i=x+4*5-4,x+4*5+10,2 do basecampspawn("berrybush2", i, y, z+4*5-10) end
		for i=x+4*5-4,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5-8) end
		for i=x+4*5-4,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5-6) end
		for i=x+4*5-12,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5-4) end
		for i=x+4*5-12,x+4*5-4,2 do basecampspawn("berrybush2", i, y, z+4*5-2) end
		for i=x+4*5+4,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5-2) end
		for i=x+4*5-12,x+4*5-4,2 do basecampspawn("berrybush2", i, y, z+4*5) end
		for i=x+4*5+4,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5) end
		for i=x+4*5-12,x+4*5-4,2 do basecampspawn("berrybush2", i, y, z+4*5+2) end
		for i=x+4*5+4,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5+2) end
		for i=x+4*5-12,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5+4) end
		for i=x+4*5-12,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5+6) end
		for i=x+4*5-12,x+4*5+12,2 do basecampspawn("berrybush2", i, y, z+4*5+8) end
		for i=x+4*5-10,x+4*5+10,2 do basecampspawn("berrybush2", i, y, z+4*5+10) end
		for i=x+4*5-8,x+4*5+8,2 do basecampspawn("berrybush2", i, y, z+4*5+12) end

		--basecampspawn("firesuppressor", x-4*5, y, z-4*5) --肉架，灭火器5
		for i=x-4*5-8,x-4*5+8,4 do basecampspawn("meatrack", i, y, z-4*5-12) end --肉架位置
		for i=x-4*5-12,x-4*5+12,4 do basecampspawn("meatrack", i, y, z-4*5-8) end
		for i=x-4*5-12,x-4*5+12,4 do basecampspawn("meatrack", i, y, z-4*5-4) end
		for i=x-4*5-12,x-4*5-4,4 do basecampspawn("meatrack", i, y, z-4*5) end
		for i=x-4*5+4,x-4*5+12,4 do basecampspawn("meatrack", i, y, z-4*5) end
		for i=x-4*5-12,x-4*5+8,4 do basecampspawn("meatrack", i, y, z-4*5+4) end
		for i=x-4*5-12,x-4*5+8,4 do basecampspawn("meatrack", i, y, z-4*5+8) end
		for i=x-4*5-8,x-4*5,4 do basecampspawn("meatrack", i, y, z-4*5+12) end

		--basecampspawn("firesuppressor", x+4*5, y, z-4*5) --农场，灭火器6
		for i=x+4*5-4,x+4*5+4,4 do basecampspawn("fast_farmplot", i, y, z-4*5-12) end --农场位置
		for i=x+4*5-8,x+4*5+8,4 do basecampspawn("fast_farmplot", i, y, z-4*5-8) end
		for i=x+4*5-12,x+4*5+12,4 do basecampspawn("fast_farmplot", i, y, z-4*5-4) end
		for i=x+4*5-12,x+4*5-4,4 do basecampspawn("fast_farmplot", i, y, z-4*5) end
		for i=x+4*5+4,x+4*5+12,4 do basecampspawn("fast_farmplot", i, y, z-4*5) end
		for i=x+4*5-8,x+4*5+12,4 do basecampspawn("fast_farmplot", i, y, z-4*5+4) end
		for i=x+4*5-4,x+4*5+8,4 do basecampspawn("fast_farmplot", i, y, z-4*5+8) end
		for i=x+4*5,x+4*5+4,4 do basecampspawn("fast_farmplot", i, y, z-4*5+12) end

		--basecampspawn("firesuppressor", x, y, z-4*20) --蜜蜂，灭火器8
		basecampspawn("beebox", x, y, z-4*20-4)--蜂箱
		basecampspawn("beebox", x-8, y, z-4*20-4)
		basecampspawn("beebox", x+8, y, z-4*20-4)
		basecampspawn("beebox", x-4, y, z-4*20-8)
		basecampspawn("beebox", x+4, y, z-4*20-8)
		basecampspawn("beebox", x, y, z-4*20-12)
		for i=x-6,x+6,2 do--花
			for j=z-4*20+8-6,z-4*20+8+6,2 do
				basecampspawn("flower", i, y, j)
			end
		end

		--basecampspawn("firesuppressor", x-4*5, y, z-4*15) --猪房，灭火器9
		for j=z-4*15-4,z-4*15+4,4 do basecampspawn("pighouse", x-4*5-12, y, j) end--猪房
		for j=z-4*15-8,z-4*15+8,4 do basecampspawn("pighouse", x-4*5-8, y, j) end
		for j=z-4*15-12,z-4*15+4,4 do basecampspawn("pighouse", x-4*5-4, y, j) end
		for j=z-4*15-12,z-4*15-4,4 do basecampspawn("pighouse", x-4*5, y, j) end
		for j=z-4*15-12,z-4*15+4,4 do basecampspawn("pighouse", x-4*5+4, y, j) end
		for j=z-4*15-8,z-4*15+8,4 do basecampspawn("pighouse", x-4*5+8, y, j) end
		for j=z-4*15-4,z-4*15+4,4 do basecampspawn("pighouse", x-4*5+12, y, j) end
		basecampspawn("powcake", x-4*5, y, z-4*15+12)--猪人陷阱,内容物为芝士蛋糕
		for i=x-4*5+1/2-2,x-4*5-1/2+2,1 do basecampspawn("wall_stone", i, y, z-4*15-1/2+14) end
		for i=x-4*5+1/2-2,x-4*5-1/2+2,3 do basecampspawn("wall_stone", i, y, z-4*15-1/2+13) end
		for i=x-4*5+1/2-2,x-4*5-1/2+2,3 do basecampspawn("wall_stone", i, y, z-4*15-1/2+12) end
		for i=x-4*5+1/2-2,x-4*5-1/2+2,1 do basecampspawn("wall_stone", i, y, z-4*15-1/2+11) end

		--basecampspawn("firesuppressor", x+4*5, y, z-4*15) --兔房，灭火器10
		for j=z-4*15-4,z-4*15+4,4 do basecampspawn("rabbithouse", x+4*5-12, y, j) end--兔房
		for j=z-4*15-8,z-4*15+8,4 do basecampspawn("rabbithouse", x+4*5-8, y, j) end
		for j=z-4*15-12,z-4*15+4,4 do basecampspawn("rabbithouse", x+4*5-4, y, j) end
		for j=z-4*15-12,z-4*15-4,4 do basecampspawn("rabbithouse", x+4*5, y, j) end
		for j=z-4*15-12,z-4*15+4,4 do basecampspawn("rabbithouse", x+4*5+4, y, j) end
		for j=z-4*15-8,z-4*15+8,4 do basecampspawn("rabbithouse", x+4*5+8, y, j) end
		for j=z-4*15-4,z-4*15+4,4 do basecampspawn("rabbithouse", x+4*5+12, y, j) end
		basecampspawn("powcake", x+4*5, y, z-4*15+12)--兔人陷阱,内容物为芝士蛋糕
		for i=x+4*5+1/2-2,x+4*5-1/2+2,1 do basecampspawn("wall_stone", i, y, z-4*15-1/2+14) end
		for i=x+4*5+1/2-2,x+4*5-1/2+2,3 do basecampspawn("wall_stone", i, y, z-4*15-1/2+13) end
		for i=x+4*5+1/2-2,x+4*5-1/2+2,3 do basecampspawn("wall_stone", i, y, z-4*15-1/2+12) end
		for i=x+4*5+1/2-2,x+4*5-1/2+2,1 do basecampspawn("wall_stone", i, y, z-4*15-1/2+11) end

		--trap_teeth 狗牙陷阱。狗牙陷阱阵不做，也许单独做
		--basecampspawn("trap_teeth", x, y, z-40)--狗牙陷阱中心

	end
end
GLOBAL.jidi = jidi