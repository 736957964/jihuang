local _G = GLOBAL
local TheNet = _G.TheNet
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local GetActionString = _G.GetActionString
local TUNING = _G.TUNING
local ACTIONS = _G.ACTIONS

local player_up = GetModConfigData("player_up")

if player_up and IsServer then
	local easing = _G.require("easing")
	-- 经验系数
	local EXP_MODULUS = 1
	-- 最高等级
	local MAX_LEVEL = 30
	-- 经验数据
	local exps = {}

	-- 怪物经验
	local monster_exp = {
		moose = 100,        -- 春鸭
		dragonfly = 100,    -- 龙蝇
		bearger = 100,      -- 熊獾
		deerclops = 100,    -- 独眼巨鹿
		beequeen = 100,     -- 女王蜂
		spiderqueen = 50,   -- 蜘蛛女王
		toadstool = 100,    -- 蛤蟆
		minotaur = 100,     -- 犀牛
		klaus = 100,        -- 克劳斯
		chester = -10,      -- 切斯特箱
		hutch = -10,        -- 兔箱
	}

	-- 食物经验
	local food_exp = {
		deerclops_eyeball = 25,  -- 鹿角怪眼球
		minotaurhorn = 25,       -- 守护者之角
		mandrake = 10,           -- 曼德拉草
		cookedmandrake = 10,     -- 烤曼德拉草
		mandrakesoup = 15,       -- 曼德拉草汤
	}

	-- 读书经验
	local read_exp = {
		book_brimstone = 10,    -- 末日降临
		book_tentacles = 10,    -- 触手书
	}

	--nice round function
	local function round2(num, idp)
		return _G.tonumber(string.format("%." .. (idp or 0) .. "f", num))
	end

	-- 获得等级需要的经验
	local function LevelExp(level)
		return level > 1 and (level * level * 8) or level * 16
	end

	-- 获得经验对应的等级
	local function ExpLevel(exp)
		local level = 1
		exp = _G.tonumber(exp)
		if exp == nil then return level end

		local sqLv = math.sqrt(exp / (exp < 32 and 16 or 8))
		level = math.ceil(sqLv)

		if level ~= sqLv then
			level = level - 1
		end

		if level == 0 then level = 1 end

		return math.min(MAX_LEVEL, level)
	end

	for i = 1, MAX_LEVEL do
		local exp = { minExp = LevelExp(i - 1), maxExp = LevelExp(i) }
		exp.rangeExp = exp.maxExp - exp.minExp
		exp.cutExp = round2(exp.rangeExp / 5, 0)
		table.insert(exps, exp)
		-- print("经验值输出", ExpLevel(exp.minExp), ExpLevel(exp.maxExp), exp.minExp, exp.maxExp, exp.rangeExp, exp.cutExp, ExpLevel(exp.cutExp))
	end

	-- 应用等级并改变属性
	local function applyLevelExp(inst, isNotFull, isRun)
		local max_exp = exps[#exps].maxExp
		inst.hxleveldata.exp = math.max(0, inst.hxleveldata.exp)
		inst.hxleveldata.exp = math.min(max_exp, inst.hxleveldata.exp)

		local nowLevel = ExpLevel(inst.hxleveldata.exp)
		if inst.hxleveldata.level ~= nowLevel or isRun then
			local oldLv = inst.hxleveldata.level or 0
			local isUp = nowLevel > oldLv
			inst.hxleveldata.level = nowLevel

			local hunger_percent, sanity_percent, health_percent
			if not isNotFull then
				hunger_percent = inst.components.hunger:GetPercent()
				sanity_percent = inst.components.sanity:GetPercent()
				health_percent = inst.components.health:GetPercent()
			end

			local hungerBuff = inst.hxleveldata.level * (inst.init_maxhunger - inst.init_minhunger) / #exps
			local sanityBuff = inst.hxleveldata.level * (inst.init_maxsanity - inst.init_minsanity) / #exps
			local healthBuff = inst.hxleveldata.level * (inst.init_maxhealth - inst.init_minhealth) / #exps

			if inst.prefab == "wx78" then
				local max_upgrades = 15
    			inst.level = math.min(inst.level, max_upgrades)
				hungerBuff = hungerBuff + inst.level * (TUNING.WX78_MAX_HUNGER - TUNING.WX78_MIN_HUNGER) / max_upgrades
				sanityBuff = sanityBuff + inst.level * (TUNING.WX78_MAX_SANITY - TUNING.WX78_MIN_SANITY) / max_upgrades
				healthBuff = healthBuff + inst.level * (TUNING.WX78_MAX_HEALTH - TUNING.WX78_MIN_HEALTH) / max_upgrades
			end

			if inst.prefab == "wolfgang" then
				local health_max = TUNING.WOLFGANG_HEALTH_NORMAL
				if inst.strength == "mighty" then
					local mighty_start = (TUNING.WOLFGANG_START_MIGHTY_THRESH/TUNING.WOLFGANG_HUNGER)   
					local mighty_percent = math.max(0, (hunger_percent - mighty_start) / (1 - mighty_start))
					health_max = easing.linear(mighty_percent, TUNING.WOLFGANG_HEALTH_NORMAL, TUNING.WOLFGANG_HEALTH_MIGHTY - TUNING.WOLFGANG_HEALTH_NORMAL, 1)
					healthBuff = healthBuff + health_max - TUNING.WOLFGANG_HEALTH_NORMAL
				elseif inst.strength == "wimpy" then
					local wimpy_start = (TUNING.WOLFGANG_START_WIMPY_THRESH/TUNING.WOLFGANG_HUNGER) 
					local wimpy_percent = math.min(1, hunger_percent/wimpy_start)
					health_max = easing.linear(wimpy_percent, TUNING.WOLFGANG_HEALTH_WIMPY, TUNING.WOLFGANG_HEALTH_NORMAL - TUNING.WOLFGANG_HEALTH_WIMPY, 1)
					healthBuff = healthBuff + health_max - TUNING.WOLFGANG_HEALTH_WIMPY - (TUNING.WOLFGANG_HEALTH_NORMAL - TUNING.WOLFGANG_HEALTH_WIMPY)
				end
			end

			inst.components.hunger.max = math.ceil(inst.init_minhunger + hungerBuff)
			inst.components.sanity.max = math.ceil(inst.init_minsanity + sanityBuff)
			inst.components.health.maxhealth = math.ceil(inst.init_minhealth + healthBuff)

			if hunger_percent then
				-- if inst.prefab ~= "wolfgang" then
				-- 	inst.components.hunger:SetPercent(hunger_percent)
				-- end
				inst.components.hunger.current = inst.components.hunger.max * hunger_percent
				inst.components.sanity:SetPercent(sanity_percent)
				-- inst.components.sanity.current = inst.components.sanity.max * sanity_percent
				inst.components.health:SetPercent(health_percent)
				-- inst.components.health.currenthealth = inst.components.health.maxhealth * health_percent
				-- inst.components.health:SetVal(inst.components.health.maxhealth * health_percent)
    			-- inst.components.health:DoDelta(0, nil, nil, true, nil, true)
			end

			if oldLv > 0 and nowLevel ~= oldLv then
				PlayerSay(inst, string.format("%s %d -> %d\n当前经验: %d", isUp and "升级" or "降级", oldLv, nowLevel, inst.hxleveldata.exp), 2.5, 3)
			end
		end
	end

	-- 吃东西
	local function OnEat(inst, food)
		if inst.old_OnEatFn ~= nil then
			inst.old_OnEatFn(inst, food)
		end
		local max_exp = exps[#exps].maxExp
		if inst.hxleveldata.exp < max_exp then
			if food and food.components.edible then
				local upExp = 0
				-- if food.components.edible.hungervalue >= 150 and food.components.edible.healthvalue >= 100 then
				-- 	upExp = 25
				-- elseif food.components.edible.hungervalue >= 75 and food.components.edible.healthvalue >= 60 then
				-- 	upExp = 20
				-- elseif food.components.edible.hungervalue >= 140 and food.components.edible.healthvalue >= 35 then
				-- 	upExp = 15
				-- elseif food.components.edible.hungervalue >= 150 and food.components.edible.healthvalue >= 10 then
				-- 	upExp = 10
				-- elseif food.components.edible.hungervalue >= 75 and food.components.edible.healthvalue >= 40 then
				-- 	upExp = 10
				-- elseif food.components.edible.hungervalue >= 75 and food.components.edible.healthvalue >= 30 then
				-- 	upExp = 8
				-- elseif food.components.edible.hungervalue >= 30 and food.components.edible.healthvalue >= 60 then
				-- 	upExp = 8
				-- elseif food.components.edible.hungervalue > 55 or food.components.edible.healthvalue > 29 or food.components.edible.sanityvalue > 19 then
				-- 	upExp = 5
				-- elseif food.components.edible.hungervalue > 24 or food.components.edible.healthvalue > 19 or food.components.edible.sanityvalue > 14 then
				-- 	upExp = 3
				-- elseif food.components.edible.hungervalue > 9 or food.components.edible.healthvalue > 9 or food.components.edible.sanityvalue > 9 then
				-- 	upExp = 1
				-- end
				if food_exp[food.prefab] ~= nil then
					upExp = food_exp[food.prefab]
				else
					--print("食物属性", food.components.edible.hungervalue, food.components.edible.hungervalue / 50, food.components.edible.sanityvalue, food.components.edible.sanityvalue / 20, food.components.edible.healthvalue, food.components.edible.healthvalue / 30)
					upExp = (food.components.edible.hungervalue / 50 + food.components.edible.sanityvalue / 20 + food.components.edible.healthvalue / 30) * EXP_MODULUS
					upExp = upExp > .5 and math.ceil(upExp) or 0
					if inst.prefab == "wendy" and (food.prefab == "berries" or food.prefab == "berries_cooked" or food.prefab == "berries_juicy" or food.prefab == "berries_juicy_cooked") then
						upExp = 1
					elseif inst.prefab == "wes" and (food.prefab == "berries" or food.prefab == "berries_cooked" or food.prefab == "berries_juicy" or food.prefab == "berries_juicy_cooked") then
						upExp = 5
					end
				end

				if upExp > 0 then
					if inst.hxleveldata.exp + upExp > max_exp then
						upExp = max_exp - inst.hxleveldata.exp
					end
					inst.hxleveldata.exp = inst.hxleveldata.exp + upExp
					PlayerSay(inst, string.format("吃[%s]\n[经验值] +%d ", food.name, upExp))
					applyLevelExp(inst, nil, inst.prefab == "wx78" or nil)
				end
			end
		elseif inst.prefab == "wx78" then
			applyLevelExp(inst, nil, true)
		end
	end

	-- 击杀目标
	local function OnKilled(inst, data)
		local victim = data.victim
		if inst.lastkilled == victim then return end
		inst.lastkilled = victim

		local max_exp = exps[#exps].maxExp
		if inst.hxleveldata.exp < max_exp then
			if not victim:HasTag("smashable") then
				local upExp = 0
				if monster_exp[victim.prefab] ~= nil then
					upExp = monster_exp[victim.prefab]
				elseif not (
					--victim:HasTag("prey") or
					victim:HasTag("bird") or
					victim:HasTag("veggie") or
					victim:HasTag("eyeplant") or
					victim:HasTag("insect") or			
					victim:HasTag("structure") or
					--victim:HasTag("no_exp") or
					victim:HasTag("wall")
				) then
					if victim.components.health then
						--print("怪物属性-血量", victim.components.health.maxhealth)
						upExp = upExp + math.max(victim.components.health.maxhealth > 99 and 0.5 or 0, victim.components.health.maxhealth / 200)
					end
					if victim.components.combat then
						--print("怪物属性-攻击", victim.components.combat.defaultdamage)
						upExp = upExp + victim.components.combat.defaultdamage / 50
					end
					--print("怪物经验", upExp)
					upExp = upExp > .5 and math.ceil(upExp * EXP_MODULUS) or 0
				end

				-- local upExp = monster_exp[victim.prefab] ~= nil and monster_exp[victim.prefab] or 5
				if upExp ~= 0 then
					if inst.hxleveldata.exp + upExp > max_exp then
						upExp = max_exp - inst.hxleveldata.exp
					end
					inst.hxleveldata.exp = inst.hxleveldata.exp + upExp
					PlayerSay(inst, string.format("击杀[%s]\n[经验值] %s%d ", victim.name, upExp > 0 and "+" or "", upExp))
					applyLevelExp(inst)
				end
			end
		end
	end

	-- 读书
	local function OnRead(inst, book)
		local max_exp = exps[#exps].maxExp
		if inst.hxleveldata.exp < max_exp then
			local upExp = 0
			if read_exp[book.prefab] ~= nil then
				upExp = read_exp[book.prefab]
			else
				upExp = 10 * EXP_MODULUS
			end

			if upExp > 0 then
				if inst.hxleveldata.exp + upExp > max_exp then
					upExp = max_exp - inst.hxleveldata.exp
				end
				inst.hxleveldata.exp = inst.hxleveldata.exp + upExp
				PlayerSay(inst, string.format("读书[%s]\n[经验值] +%d ", book.name, upExp))
				applyLevelExp(inst)
			end
		end
	end

	-- 完成工作
	local function OnFinishedWork(inst, data)
		local max_exp = exps[#exps].maxExp
		if inst.hxleveldata.exp < max_exp then
			local target = data.target
			local action = data.action

			local workMsg = GetActionString(action.id, nil)

			if action == ACTIONS.CHOP then
				upExp = 1
			elseif action == ACTIONS.MINE then
				upExp = 1
			elseif action == ACTIONS.DIG then
				upExp = 1
			elseif action == ACTIONS.HAMMER then
				upExp = 2
				workMsg = "砸"
			elseif action == ACTIONS.NET then
				upExp = 2
			elseif action == ACTIONS.PICK then
				upExp = 1
			elseif action == ACTIONS.HARVEST then
				upExp = 1
			-- 拾取不加经验
			-- elseif action == ACTIONS.PICKUP then
			-- 	upExp = 1
			end

			if workMsg == nil or workMsg == "ACTION" then
				workMsg = "工作"
			end

			if upExp > 0 then
				if inst.hxleveldata.exp + upExp > max_exp then
					upExp = max_exp - inst.hxleveldata.exp
				end
				inst.hxleveldata.exp = inst.hxleveldata.exp + upExp
				PlayerSay(inst, string.format("完成%s[%s]\n[经验值] %s%d ", workMsg, target.oldName or target.name, upExp > 0 and "+" or "", upExp))
				applyLevelExp(inst)
			end
		end
	end

	-- 死亡
	local function OnDeath(inst)
		local nowLevel = ExpLevel(inst.hxleveldata.exp)
		-- print("当前状态:", nowLevel, inst.hxleveldata.exp, exps[nowLevel].cutExp)
		local cutExp = inst.hxleveldata.exp - exps[nowLevel].cutExp
		if cutExp > 0 then
			inst.hxleveldata.exp = cutExp
			PlayerSay(inst, "[死亡]\n[经验值] -" .. exps[nowLevel].cutExp, 2)
		else
			if inst.hxleveldata.exp > 0 then
				PlayerSay(inst, "[死亡]\n[经验值] -" .. inst.hxleveldata.exp, 2)
			end
			inst.hxleveldata.exp = 0
		end
		applyLevelExp(inst, nil, inst.prefab == "wx78" or nil)
	end

	AddPlayerPostInit(function(inst)
		inst.hxleveldata = {
			exp = 0,
			level = 1,
		}
		inst.init_minhunger = inst.components.hunger.max
		inst.init_minsanity = inst.components.sanity.max
		inst.init_minhealth = inst.components.health.maxhealth

		if inst.prefab == "wx78" then
			inst.init_minhunger = TUNING.WX78_MIN_HUNGER
			inst.init_minsanity = TUNING.WX78_MIN_SANITY
			inst.init_minhealth = TUNING.WX78_MIN_HEALTH
		end

		if inst.prefab == "wolfgang" then
			inst.init_minhunger = TUNING.WOLFGANG_HUNGER
			inst.init_minhealth = TUNING.WOLFGANG_HEALTH_NORMAL

			local old_Wolfgang_SetMaxHealth = inst.components.health.SetMaxHealth
			function inst.components.health:SetMaxHealth( ... )
				old_Wolfgang_SetMaxHealth(self, ...)
				applyLevelExp(inst, nil, true)
			end
		end

		-- 处理老奶奶读书
		if inst.prefab == "wickerbottom" then
			if inst.components.reader ~= nil then
				local old_ReadFn = inst.components.reader.Read
				function inst.components.reader:Read(book)
					local ret = old_ReadFn(self, book)
					if ret then OnRead(inst, book) end
					return ret
				end
			end
		end

		-- 处理老麦制造影子
		if inst.prefab == "waxwell" then
			local old_AddFollowerFn = inst.components.leader.AddFollower
			function inst.components.leader:AddFollower(follower)
				if old_AddFollowerFn ~= nil then
					old_AddFollowerFn(self, follower)
				end

				if follower.prefab == "shadowlumber" or follower.prefab == "shadowminer" or follower.prefab == "shadowdigger" then
					follower:ListenForEvent("finishedwork", function(owner, data)
						data.worker = owner
						OnFinishedWork(inst, data)
					end)
				end
			end
		end

		-- 处理温蒂召唤小姐姐
		if inst.prefab == "wendy" then
			local old_AddFollowerFn = inst.components.leader.AddFollower
			function inst.components.leader:AddFollower(follower)
				if old_AddFollowerFn ~= nil then
					old_AddFollowerFn(self, follower)
				end

				if follower.prefab == "abigail" then
					follower:ListenForEvent("killed", function(owner, data)
						data.killer = owner
						OnKilled(inst, data)
					end)
				end
			end
		end

		inst.init_maxhunger = inst.init_minhunger * 2
		inst.init_maxsanity = inst.init_minsanity * 2
		inst.init_maxhealth = inst.init_minhealth * 2
		-- print("初始化角色属性值", inst.init_minhunger, inst.init_minsanity, inst.init_minhealth)
		-- inst:DoTaskInTime(0, function()
		-- 	inst.init_minhunger = inst.components.hunger.max
		-- 	inst.init_minhealth = inst.components.health.maxhealth
		-- 	inst.init_minsanity = inst.components.sanity.max
		-- 	print("初始化角色属性值2", inst.init_minhunger, inst.init_minhealth, inst.init_minsanity)
		-- end)

		local old_OnDespawn = inst._OnDespawn
		function inst._OnDespawn(inst, ...)
			if old_OnDespawn then
				old_OnDespawn(inst, ...)
			end
			
			inst.hxleveldata.hxhunger = inst.components.hunger.current
			inst.hxleveldata.hxsanity = inst.components.sanity.current
			inst.hxleveldata.hxhealth = inst.components.health.currenthealth
		end

		local OldOnSave=inst.OnSave
		inst.OnSave = function(inst,data)
			if OldOnSave~=nil then
				OldOnSave(inst,data)
			end
			inst.hxleveldata.hxhunger = inst.components.hunger.current
			inst.hxleveldata.hxsanity = inst.components.sanity.current
			inst.hxleveldata.hxhealth = inst.components.health.currenthealth
			data.hxleveldata = inst.hxleveldata
			-- print("当前属性", data.hxleveldata.hxhunger, data.hxleveldata.hxsanity, data.hxleveldata.hxhealth)
		end
		
		local OldOnLoad=inst.OnPreLoad
		inst.OnPreLoad = function(inst,data)
			if OldOnLoad~=nil then
				OldOnLoad(inst,data)
			end
			if data ~= nil then
				inst.hxleveldata = data.hxleveldata or {
					exp = data.hxexp or 0,
					level = data.hxlevel or 1,
				}
				applyLevelExp(inst, true, true)
				if type(inst.hxleveldata.hxhunger) == "number" then
					-- print("角色属性值", data.hxleveldata.hxhunger, data.hxleveldata.hxsanity, data.hxleveldata.hxhealth)
					inst.components.hunger.current = inst.hxleveldata.hxhunger
					inst.components.sanity.current = inst.hxleveldata.hxsanity
					inst.components.health:SetCurrentHealth(inst.hxleveldata.hxhealth)
					inst.components.health:DoDelta(0)
					inst.components.sanity:DoDelta(0)
					inst.components.hunger:DoDelta(0)
				end
			end
		end
		-- inst.OnPreLoad

		inst.old_OnEatFn = inst.components.eater.oneatfn
		inst.components.eater:SetOnEatFn(OnEat)

		inst:ListenForEvent("killed", OnKilled)
		inst:ListenForEvent("death", OnDeath)
		-- inst:ListenForEvent("hx_applylevelexp", function(inst)
		-- 	applyLevelExp(inst, nil, true)
		-- end)
	end)

	AddPrefabPostInit("world", function(inst)
		--根据玩家说的话来对命令进行处理
		local OldNetworking_Say = _G.Networking_Say
		_G.Networking_Say = function(guid, userid, name, prefab, message, ...)
			local r = OldNetworking_Say(guid, userid, name, prefab, message, ...)

			local talker = GetTheWorldPlayerById(userid)
			if talker == nil then
				return r
			end
			
			--获取到玩家说的话
			local words = {}
			for word in string.gmatch(message, "%S+") do
				table.insert(words, word) --分词
			end

			if string.sub(message,1,1) == "#" then
				local sayAction = words[1]

				if sayAction ~= nil and (string.lower(sayAction) == "#lv" or sayAction == "#等级") then
					local max_exp = exps[#exps].maxExp
					local nowLv = ExpLevel(talker.hxleveldata.exp)
					local exp = talker.hxleveldata.exp or 0
					local nextExp = exps[math.min(MAX_LEVEL, nowLv + 1)].maxExp - exp
					nextExp = nextExp < 0 and 0 or nextExp
					local nextLvMsg = exp >= max_exp and string.format("\n已达到最高等级") or string.format("\n距离下一级还需要 %d 点经验值", nextExp)
					PlayerSay(talker, string.format("当前等级: %d\n经验: %d", nowLv, exp) .. nextLvMsg)
				end
			end

			return r
		end
	end)
end