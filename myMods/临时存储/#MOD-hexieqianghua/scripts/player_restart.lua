local _G = GLOBAL
local os = _G.os
local TheNet = _G.TheNet
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local GetTime = _G.GetTime

local TUNING = _G.TUNING
local STRINGS = _G.STRINGS

local restart_cd = GetModConfigData("restart_cd")
local resurrect_cd = GetModConfigData("resurrect_cd")
local kill_cd = GetModConfigData("kill_cd")

if IsServer and (restart_cd ~= -1 or resurrect_cd ~= -1 or kill_cd ~= -1) then
	local MY_STRINGS = {
		welcome_msg = {
			"按Y(公聊)或者U(私聊)输入指令:",
			"按Y(公聊)输入指令:",
			"按U(私聊)输入指令:",
		},
		allow_msg = {
			" #重生/#restart/#cs/#chongsheng (冷却:%d 秒,重生换角色)",
			" ##重生/#restart_d/#cs_d/#chongsheng_d (冷却:%d 秒,重生并掉落物品)",
			" #复活/#resurrect/#fh/#fuhuo (冷却:%d 秒,角色复活)",
			" #自杀/#kill/#zs/#zisha  (冷却:%d 秒,角色自杀)",
		},
		force_drop_msg = {
			"当前重生强制掉落道具!",
			"当前重生强制不掉落道具!",
		},
		map_save_msg = {
			"重生将保存地图数据.",
			"重生将不保存地图数据.",
		},
		cd_max_msg = {
			"无限制",
			"%分钟",
		},
		cd_bonus_msg = "每次使用增加冷却%。最大值：%.",
		warning = "%s CD:%d 秒.",
		announce = "重新开始!",
		restart = "重生",
		resurrect = "复活",
		kill = "自杀",
		resurrect_from = "复活",
		kill_from = "自杀",
	}

	local MSG_CHOOSE = {
		["#restart"] = 1,
		["#restart_d"] = 2,
		["#resurrect"] = 3,
		["#kill"] = 4,
		["#重生"] = 1,
		["##重生"] = 2,
		["#复活"] = 3,
		["#666"] = 3,
		["#888"] = 3,
		["#自杀"] = 4,
		["#cs"] = 1,
		["#cs_d"] = 2,
		["#fh"] = 3,
		["#zs"] = 4,
		["#chongsheng"] = 1,
		["#chongsheng_d"] = 2,
		["#fuhuo"] = 3,
		["#zisha"] = 4,
	}

	local welcome_tips = MY_STRINGS.welcome_msg[1]
	local ignoring_admin = true
	local allow_restart = restart_cd ~= -1
	local allow_resurrect = resurrect_cd ~= -1
	local allow_kill = kill_cd ~= -1
	local cd_restart = (allow_restart and restart_cd or 180) * 60
	local cd_resurrect = (allow_resurrect and resurrect_cd or 180) * 60
	local cd_kill = (allow_kill and kill_cd or 180) * 60
	-- 保存游戏天数数据
	local age_save = true
	-- 保存地图数据
	local map_save = true and 1 or 2
	-- 冷却时间递增百分比
	local cd_bonus = 0
	-- 最大冷却时间（分钟）
	local cd_max = 180 * 60
	-- 是否强制掉落道具_默认
	local force_drop_mode = 1
	-- 复活恢复生命值_获得默认健康（只有50）
	local resurrect_health = 0
	-- 命令模式_公聊和私聊
	local trigger_mode = 1
	-- 欢迎提示
	local restart_welcome_tips =   false          ----true
	-- 提示时间
	local restart_welcome_tips_time = 6

	-- List Manage Function
	local function ListInsert(userid)
		-- and player.components and player.components.age
		if userid ~= nil then
			_G.TheWorld.guard_restart[userid] = {
				restart = 0,
				resurrect = 0,
				kill = 0,
				restart_count = 0,
				resurrect_count = 0,
				kill_count = 0,
			}
			local age = os.time() -- player.components.age:GetAge()
			local cd_record = _G.TheWorld.guard_restart[userid]
			if allow_restart and cd_restart ~= 0 and age >= cd_restart then
				cd_record.restart = age
			end
			-- and age >= cd_resurrect
			if allow_resurrect and cd_resurrect ~= 0 then
				cd_record.resurrect = age - cd_resurrect
			end
			-- and age >= cd_kill
			if allow_kill and cd_kill ~= 0 then
				cd_record.kill = age - cd_kill
			end
		end
	end

	-- Get Player var userid
	local function GetPlayerById(playerid)
		for k, v in ipairs(_G.AllPlayers) do
			if v ~= nil and v.userid and v.userid == playerid then
				return v
			end
		end
		return nil
	end

	-- DropEverything for player
	local function ItemDropAll(player)
		if player and player.components and player.components.inventory then
			player.components.inventory:DropEverything(false, false)
		end
	end

	-- Is Player Died
	local function IsDied(player)
		if player and player:HasTag("player") and player:HasTag("playerghost") then
			return true
		end
	end

	-- Get player's command cooldown time
	local function GetCD(userid, tagnumber)
		local cd = 0
		if userid and _G.TheWorld.guard_restart[userid] then
			local age = os.time() -- player.components.age:GetAge()
			local cd_record = _G.TheWorld.guard_restart[userid]
			if tagnumber <= 2 and cd_restart ~= 0 then
				cd = cd_record.restart + cd_restart + cd_restart * cd_bonus * cd_record.restart_count - age
			elseif tagnumber == 3 and cd_resurrect ~= 0 then
				cd = cd_record.resurrect + cd_resurrect + cd_resurrect * cd_bonus * cd_record.resurrect_count - age
			elseif tagnumber == 4 and cd_kill ~= 0 then
				cd = cd_record.kill + cd_kill + cd_kill * cd_bonus * cd_record.kill_count - age
			end
			if cd ~= 0 and cd_max > 0 then
				cd = math.min(cd, cd_max)
			end
		end
		return cd
	end

	-- RecordMap Record map
	local function RecordMap(player)
		if player ~= nil and player.userid ~= nil and player.player_classified ~= nil and player.player_classified.MapExplorer ~= nil and player.player_classified.MapExplorer.RecordMap ~= nil then
			if _G.TheWorld.guard_restart[player.userid] == nil then
				ListInsert(player.userid)
			end
			
			_G.TheWorld.guard_restart[player.userid].map = player.player_classified.MapExplorer:RecordMap()
		end
	end

	-- TeachMap Teach map
	local function TeachMap(player)
		if player and player.userid and _G.TheWorld.guard_restart[player.userid].map and player.player_classified and player.player_classified.MapExplorer then
			if not player.player_classified.MapExplorer:LearnRecordedMap(_G.TheWorld.guard_restart[player.userid].map) then
				print("[河蟹强化] 地图数据恢复出错")
			end
			_G.TheWorld.guard_restart[player.userid].map = nil
		end
	end

	-- DodeSpawn Function
	local function DodeSpawn(userid)
		if allow_restart and userid ~= nil then
			local cd_record = _G.TheWorld.guard_restart[userid]
			local age = os.time() -- player.components.age:GetAge()
			if cd_restart ~= 0 then
				cd_record.restart = age_save and age or 0
			end
			-- if allow_resurrect and cd_resurrect ~= 0 then
			-- 	cd_record.resurrect = age_save and cd_record.resurrect - age or age - cd_record.resurrect
			-- end
			-- if allow_kill and cd_kill ~= 0 then
			-- 	cd_record.kill = age_save or cd_record.kill - age or age - cd_record.kill
			-- end
			cd_record.restart_count = cd_record.restart_count + 1

			local client_obj = TheNet:GetClientTableForUser(userid)
			cd_record.playerage = client_obj and client_obj.playerage - 1 or nil

			local player = GetPlayerById(userid)
			if player and player:IsValid() then
				player:DoTaskInTime(1, function(inst)
					_G.TheWorld:PushEvent("ms_playerdespawnanddelete", player)
				end)
			end
		end
	end

	local function ResurrectSpawn(userid)
		if allow_resurrect and userid ~= nil then
			local cd_record = _G.TheWorld.guard_restart[userid]
			if cd_resurrect ~= 0 then
				cd_record.resurrect = os.time() -- player.components.age:GetAge()
			end
			cd_record.resurrect_count = cd_record.resurrect_count + 1

			local player = GetPlayerById(userid)
			if player and player:IsValid() and IsDied(player) then
				player:DoTaskInTime(1, function(inst)
					player:PushEvent("respawnfromghost")
					player.rezsource = MY_STRINGS.resurrect_from
					if resurrect_health > 0 then
						local health = resurrect_health
						if health == 1 then
							health = 100 - cd_record.resurrect_count * 5
							health = math.max(40, health)
						elseif health == 2 then
							health = math.random(10, 100)
						else
							health = math.max(10, health)
						end
						player.components.health:SetCurrentHealth(player.components.health.maxhealth * health * 0.01)
					end
				end)
			end
		end
	end

	local function KillSpawn(userid)
		if allow_kill and userid ~= nil then
			local cd_record = _G.TheWorld.guard_restart[userid]
			if cd_kill ~= 0 then
				cd_record.kill = os.time() -- player.components.age:GetAge()
			end
			cd_record.kill_count = cd_record.kill_count + 1

			local player = GetPlayerById(userid)
			if player and player:IsValid() and not IsDied(player) then
				player:DoTaskInTime(1, function(inst)
					player:PushEvent("death")
					player.deathpkname = MY_STRINGS.kill_from
				end)
			end
		end
	end

	-- When a player dies automatic counting
	local function DeathRemove(player)
		if player.userid and _G.TheWorld.guard_restart[player.userid] and player.components and player.components.age then
			if player:IsValid() and IsDied(player) then

				local cd_record = _G.TheWorld.guard_restart[player.userid]
				if GetCD(player, 1) > 0 then
					cd_record.restart = cd_record.restart - 1
				end
				if GetCD(player, 3) > 0 then
					cd_record.resurrect = cd_record.resurrect - 1
				end
				if GetCD(player, 4) > 0 then
					cd_record.kill = cd_record.kill - 1
				end

				if GetCD(player, 1) > 0 or GetCD(player, 3) > 0 or GetCD(player, 4) > 0 then
					player:DoTaskInTime(1, DeathRemove)
				end
			end
		end
	end

	-- Remove restart
	AddComponentPostInit("playerspawner", function(OnPlayerSpawn, inst)
		inst:ListenForEvent("ms_playerjoined", function(inst, player)
			if not (player and player.components) then return end

			if restart_welcome_tips and _G.TheWorld.guard_restart[player.userid] == nil and (allow_restart or allow_resurrect or allow_kill) then
				player:DoTaskInTime(3, function(player)
					if player.components and player.components.talker then
						player.components.talker:Say(player:GetDisplayName() .. ", " .. welcome_tips, restart_welcome_tips_time)
					end
				end)
			end

			-- Save the command cooldown time when a player leaves the server side
			if _G.TheWorld.guard_restart[player.userid] == nil then
				ListInsert(player.userid)
			end

			-- if allow_restart and cd_restart ~= 0 or allow_resurrect and cd_resurrect ~= 0 or allow_kill and cd_kill ~= 0 then
			-- 	if IsDied(player) then
			-- 		if GetCD(player, 1) > 0 or GetCD(player, 3) > 0 or GetCD(player, 4) > 0 then
			-- 			player:DoTaskInTime(1, DeathRemove)
			-- 		end
			-- 	end

			-- 	player:ListenForEvent("death", function(player)
			-- 		-- Waiting for the player's status was changed to death.
			-- 		player:DoTaskInTime(2.5, DeathRemove)
			-- 	end)
			-- end

			if map_save == 1 and _G.TheWorld.guard_restart[player.userid].map then
				player:DoTaskInTime(1, TeachMap)
			end

			if age_save and _G.TheWorld.guard_restart[player.userid].playerage ~= nil then
				player:DoTaskInTime(1, function(inst)
					local save_age_day = _G.TheWorld.guard_restart[player.userid].playerage
					local day = player.components.age:GetDisplayAgeInDays()
					if save_age_day > day then
						player.components.age.saved_age = save_age_day * TUNING.TOTAL_DAY_TIME
					end
					_G.TheWorld.guard_restart[player.userid].playerage = nil
				end)
			end
		end)
	end)

	AddPlayerPostInit(function(inst)
		local old_OnDespawn = inst._OnDespawn
		function inst._OnDespawn(inst, ...)
			if old_OnDespawn then
				old_OnDespawn(inst, ...)
			end

			if map_save == 1 then
				RecordMap(inst)
			end
		end
	end)

	local function IsTrigger(whisper)
		if trigger_mode == 1 then
			return true
		elseif trigger_mode == 2 and not whisper then
			return true
		elseif trigger_mode == 3 and whisper then
			return true
		end
		return false
	end

	local function IsContinue(tag)
		if tag <= 2 and allow_restart then
			return true
		elseif tag == 3 and allow_resurrect then
			return true
		elseif tag == 4 and allow_kill then
			return true
		end
		return false
	end

	AddPrefabPostInit("world", function(inst)
		inst.guard_restart = {}
			
		local OldOnSave=inst.OnSave
		inst.OnSave = function(inst,data)
			if OldOnSave~=nil then
				OldOnSave(inst,data)
			end
			if inst.guard_restart~=nil then
				data.guard_restart=inst.guard_restart
			end
		end
		
		local OldOnLoad=inst.OnLoad
		inst.OnLoad = function(inst,data)
			if OldOnLoad~=nil then
				OldOnLoad(inst,data)
			end
			if data.guard_restart~=nil then
				inst.guard_restart=data.guard_restart
			end
		end

		welcome_tips = MY_STRINGS.welcome_msg[trigger_mode]
		local cd_list = { cd_restart, cd_restart, cd_resurrect, cd_kill }
		local allow_list = { allow_restart, allow_restart, allow_resurrect, allow_kill }
		for i = 1, #cd_list do
			MY_STRINGS.allow_msg[i] = string.format(MY_STRINGS.allow_msg[i], cd_list[i])
			if allow_list[i] then welcome_tips = welcome_tips .. "\n" .. MY_STRINGS.allow_msg[i] end
		end
		if cd_bonus > 0 then
			if cd_max > 0 then
				MY_STRINGS.cd_max_msg[2] = string.format(MY_STRINGS.cd_max_msg[2], cd_max / 60)
			end
			local cd_max_msg = cd_max == 0 and MY_STRINGS.cd_max_msg[1] or MY_STRINGS.cd_max_msg[2]
			welcome_tips = welcome_tips .. "\n" .. string.format(MY_STRINGS.cd_bonus_msg, cd_bonus * 100, cd_max_msg)
		end
		welcome_tips = welcome_tips .. "\n" .. MY_STRINGS.map_save_msg[map_save]
		if force_drop_mode > 0 then welcome_tips = welcome_tips .. "\n" .. MY_STRINGS.force_drop_msg[force_drop_mode] end

		-- Main Function
		local Old_Networking_Say = _G.Networking_Say
		_G.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
			Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
			if IsTrigger(whisper) then
				local choose = MSG_CHOOSE[string.lower(message)]

				if choose and IsContinue(choose) then
					-- TheNet:GetClientTableForUser(userid)
					-- local player = GetPlayerById(userid)
					-- print("输出时间信息:", GetTime(), _G.GetTimeReal(), os.time(), os.date("%Y-%m-%d %H:%M:%S", os.time()))
					-- print("输出玩家信息:", player.playerage)
					-- print("输出玩家信息2:", xxx.components.age:GetAge())
					local cd = GetCD(userid, choose)
					if cd > 0 then
						local player = GetPlayerById(userid)
						if player == nil then return end
						if not (ignoring_admin and TheNet:GetIsServerAdmin() and player.Network and player.Network:IsServerAdmin()) then
							local warning = choose == 3 and MY_STRINGS.resurrect or
									(choose == 4 and MY_STRINGS.kill or MY_STRINGS.restart)
							local msg = string.format(MY_STRINGS.warning, warning, cd)
							player:DoTaskInTime(0.5, function()
								if player.components.talker then player.components.talker:Say(player:GetDisplayName() .. ", " .. msg) end
							end)
							return
						end
					end

					if inst.guard_restart[userid] == nil then
						ListInsert(userid)
					end

					if choose == 3 then
						ResurrectSpawn(userid)
					elseif choose == 4 then
						KillSpawn(userid)
					elseif choose <= 2 then
						local player = GetPlayerById(userid)
						if player then
							-- Drop Everything
							if force_drop_mode == 1 or force_drop_mode == 0 and choose == 2 then
								ItemDropAll(player)
							end

							if map_save == 1 then
								RecordMap(player)
							end

							-- Announce all Players who restart the Game
							player:DoTaskInTime(0.5, function()
								local charactername = STRINGS.CHARACTER_NAMES[prefab] or prefab
								TheNet:Announce(player:GetDisplayName() .. " (" .. charactername .. ") " .. MY_STRINGS.announce)
							end)
						end
						-- Restart the Game
						DodeSpawn(userid)
					end
					
		
					
				end
			end
		end
	end)
end