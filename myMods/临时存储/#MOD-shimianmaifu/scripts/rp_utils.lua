--常用的工具函数

--获取要放置的位置
function rp_GetSpawnPoint(target, min_dist, max_dist)
	--设置默认参数
	if min_dist == nil or max_dist == nil then
		min_dist = 15
		max_dist = 35
	end
	
	local pt = Vector3(target.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
    local radius = math.random(min_dist, max_dist)
	
	local result_offset = FindValidPositionByFan(theta, radius, 36, function(offset) --这里其实就找是一个没有被其他物体占用的位置
		local pos = pt + offset
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
		return next(ents) == nil
    end)
	
	if result_offset ~= nil then
        local pos = pt + result_offset
		return pos
	end
end

--尝试在目标附近放置怪物
function rp_TrySpawn(target, prefab_name, min_dist, max_dist, max_trying_times)
	--print("----use utils return-----")
	if min_dist == nil or max_dist == nil then
		min_dist = 15
		max_dist = 35
	end
	
	if max_trying_times == nil then
		max_trying_times = 40
	end
	
	if max_trying_times < 0 then --递归 尝试 max_trying_times 次，如果找不到有效地点则返回空
		return nil
	end
	
	local b = nil
	if target then
		local player_pt = Vector3(target.Transform:GetWorldPosition())
		local pt = rp_GetSpawnPoint(target, min_dist, max_dist)
		if pt ~= nil then
			local tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			local canspawn = tile ~= GROUND.IMPASSABLE and tile ~= GROUND.INVALID and tile ~= 255 --找到一个有效的位置才放置物体
			if canspawn then
				--print("spawned!")
				b = SpawnPrefab(prefab_name)
				if b then 
					b.Transform:SetPosition(pt:Get())
					if player_pt then 
						b:FacePoint(player_pt)
					end 
				end
				return b
			else
				b = rp_TrySpawn(target, prefab_name, min_dist, max_dist, max_trying_times - 1)
			end
		end
	end
	
	return b
end

--尝试在目标附近放置玩家
function rp_TrySpawnPlayer(target, player, min_dist, max_dist, max_trying_times)
	
	if min_dist == nil or max_dist == nil then
		min_dist = 15
		max_dist = 35
	end
	
	if max_trying_times == nil then
		max_trying_times = 40
	end
	
	if max_trying_times < 0 then --递归 尝试 max_trying_times 次，如果找不到有效地点则返回空
		return nil
	end
	
	if target then
		local target_pt = Vector3(target.Transform:GetWorldPosition())
		local pt = rp_GetSpawnPoint(target, min_dist, max_dist)
		if pt ~= nil then
			local tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			local canspawn = tile ~= GROUND.IMPASSABLE and tile ~= GROUND.INVALID and tile ~= 255 --找到一个有效的位置才放置物体
			if canspawn then
				--print("spawned!")
				--b = SpawnPrefab(prefab_name)
				if player then 
					player.Transform:SetPosition(pt:Get())
					if target_pt then 
						player:FacePoint(target_pt)
					end 
				end
				--return b
			else
				 rp_TrySpawnPlayer(target, player, min_dist, max_dist, max_trying_times - 1)
			end
		end
	end
	
end

--找到猪王
function rp_findPigKing()
	return TheSim:FindFirstEntityWithTag("king")
end

--在猪王附近安置prefab
function rp_SpawnPrefabNearPigKing(prefab_name, min_dist, max_dist, max_try_times)

	if min_dist == nil then
		min_dist = 4
	end
	if max_dist == nil then
		max_dist = 12
	end
	if max_try_times == nil then
		max_try_times = 40
	end
	
	local monster = nil 
	local pig_king = TheSim:FindFirstEntityWithTag("king")
	if pig_king then
		print("find pigking!!!")
		monster = rp_TrySpawn(pig_king, prefab_name, min_dist, max_dist, max_try_times)	
	else
		print("no find pigking!!")
	end
	return monster
end

--在猪王附近安置玩家
function rp_SpawnPlayerNearPigKing(player)
	local pig_king = TheSim:FindFirstEntityWithTag("king")
	if pig_king then
		print("find pigking!!!")
		rp_TrySpawnPlayer(pig_king, player, 5, 15, 30)
	else
		print("no find pigking!!")
	end
end

--函数注入
function rp_Inject(comp,fn_name,fn)
	local old = comp[fn_name]
	comp[fn_name] = function(self,...)
		old(self,...)
		fn(self.inst)
	end
end

function rp_HexToRGB(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

-- Returns the 0.0 - 1.0 color from r, g, b parameters
function rp_RGBToPercentColor(r, g, b)
    return r/255, g/255, b/255
end

-- Returns the 0.0 - 1.0 color from a hex parameter
function rp_HexToPercentColor(hex)
    return RGBToPercentColor(HexToRGB(hex))
end