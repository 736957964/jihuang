	--[[怪物入侵机制]]--
	
	--入侵怪物列表（请不要私自更改）
	local monster_table = {
		"pigman",
	}
	
	--怪物掉落列表
	local monster_loot_table = {
		{prefab = "thulecite_pieces", chance = 0.01,},
	}
	
	--获取玩家数量(准确的说是地上的玩家数量)
	local function GetPlayerNum()
		local nump = 0
		for k0, v0 in pairs(AllPlayers) do
			if v0 then
				nump = nump + 1
			end
		end
		return nump
	end
	
	--计算会遭到怪物袭击的玩家数量
	local function CalculateSpawnPlayerNum(player_num)
		local nump = player_num
		local numb = 0
		if nump == 0 then
			numb = 0
		elseif nump == 1 then
			numb = 1
		elseif nump <= 12 then
			numb = math.floor(nump / 2)
		else 
			numb = 6
		end
		return numb
	end
	
	--获取会出现怪物的玩家列表
	local function GetSpawnPlayerList()
		local _AllowPlayers = {}
		local allow_num = {}
		local player_num = GetPlayerNum()
		local temp_num = 1
		local spawn_player_num = CalculateSpawnPlayerNum(player_num)
		--用滚轮似的方式随机抽取玩家
		if player_num > 0 then 
			temp_num = math.floor(math.random(1,player_num))
			for k = 1, spawn_player_num do 
				if temp_num ~= 0 then
					table.insert(allow_num, temp_num)
				else 
					table.insert(allow_num, player_num)
				end
				temp_num = (temp_num + 1) % player_num
			end
			
			for k,v in pairs(allow_num) do
				if AllPlayers[v] then
					table.insert(_AllowPlayers, AllPlayers[v])
				end
			end
		end
		return _AllowPlayers
	end
	
	--获取在目标周围要放置的位置
	local function GetSpawnPoint(target, min_dist, max_dist)
		local pt = Vector3(target.Transform:GetWorldPosition())
		local theta = math.random() * 2 * PI
		--设置默认参数
		if min_dist == nil or max_dist == nil then
			min_dist = 15
			max_dist = 35
		end
        local radius = math.random(min_dist, max_dist)
		local result_offset = FindValidPositionByFan(theta, radius, 20, function(offset)
            local pos = pt + offset
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
            return next(ents) == nil
        end)
		if result_offset ~= nil then
            local pos = pt + result_offset
			return pos
		end
	end
	
	--尝试放置怪物
	local function TrySpawn(player, monster, min_dist, max_dist, max_trying_times)
		--设置默认参数
		if max_trying_times == nil then
			max_trying_times = 50
		end
		
		if max_trying_times < 0 then
			return nil
		end
		
		local b = nil
		if player then
			local player_pt = Vector3(player.Transform:GetWorldPosition())
			local pt = GetSpawnPoint(player, min_dist, max_dist)
			if pt ~= nil then
				local tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
				local canspawn = tile ~= GROUND.IMPASSABLE and tile ~= GROUND.INVALID and tile ~= 255
				if canspawn then
					--print("spawned!")
					b = SpawnPrefab(monster)
					if b then 
						b.Transform:SetPosition(pt:Get())
						if player_pt then 
							b:FacePoint(player_pt)
						end 
					end
					return b
				else
					b = TrySpawn(player, monster, min_dist, max_dist, max_trying_times - 1)
				end
			end
		end
		return b
	end
	
	--产生入侵
	local function produceInvaders(player, monster_str)
		SpawnPrefab("lightning")
		local invaders_num = 2
		for k = 1, invaders_num do
			local monster = TrySpawn(player, monster_str)
			if monster then
				if not monster.components.rp_invasive then
					monster:AddComponent("rp_invasive")
				end
				monster.components.rp_invasive:make()
			end			
		end
	end
	
	local RP_Monster_Attack = Class(function(self, inst)
		self.inst = inst
		--self.inst:ListenForEvent("ms_cyclecomplete", function() updateWorld(self.inst) end)
	end)
	
	return RP_Monster_Attack