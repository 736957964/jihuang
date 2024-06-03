--[[玩家宝宝 GD_Player_Baby]]--
local brain = require "brains/gd_playerbabybrain"

-- 宝宝重生时间
TUNING.PLAYERBABY_RESPAWN_TIME = 1 * TUNING.TOTAL_DAY_TIME
-- 初始最大生命
TUNING.PLAYERBABY_DEFAULT_MAXHEALTH = 100
-- 满级最大生命
TUNING.PLAYERBABY_LEVEL_MAXHEALTH = TUNING.PLAYERBABY_DEFAULT_MAXHEALTH * 8
-- 初始最大饥饿
TUNING.PLAYERBABY_HUNGER = TUNING.WILSON_HUNGER
-- 满级最大饥饿
TUNING.PLAYERBABY_LEVEL_HUNGER = TUNING.PLAYERBABY_HUNGER * 10
-- 饥饿值损耗速度
TUNING.PLAYERBABY_HUNGER_RATE = TUNING.WILSON_HUNGER_RATE
-- 攻击力
TUNING.PLAYERBABY_UNARMED_DAMAGE = TUNING.UNARMED_DAMAGE
-- 攻击频率
TUNING.PLAYERBABY_ATTACK_PERIOD = 2
-- 满级后攻击频率
TUNING.PLAYERBABY_LEVEL_ATTACK_PERIOD = .5
-- 最大攻击加成
TUNING.PLAYERBABY_DAMAGE_MULT_MAX = 1.25
-- 最大伤害减免
TUNING.PLAYERBABY_ABSORPTION_MAX = 0.3
-- 最大每秒回血
TUNING.PLAYERBABY_HEALTH_REGEN_MAX = 10
-- 学会斧子的等级
TUNING.PLAYERBABY_WORK_CHOP = 3
-- 学会锄头的等级
TUNING.PLAYERBABY_WORK_MINE = 4
-- 学会铲子的等级
TUNING.PLAYERBABY_WORK_DIG = 5
-- 学会锤子的等级
TUNING.PLAYERBABY_WORK_HAMMER = 2
-- 学会采集的等级
TUNING.PLAYERBABY_WORK_PICK = 10
-- 学会捡东西的等级
TUNING.PLAYERBABY_WORK_PICKUP = 15

-- 宝宝说话颜色
local BABY_SAY_COLOUR = {0.6, 0.9, 0.8, 1}
BABY_SAY_COLOUR[1], BABY_SAY_COLOUR[2], BABY_SAY_COLOUR[3] = HexToPercentColor("#E80607")

---------------------------------  宝宝台词  ---------------------------------
-- 登场时说的话
local makeSayTable = {
	"这是哪...我是谁?你是主人?",
	"让我来助你一臂之力吧!",
	"我擦?我还在吃泡面,怎么突然到这了?",
	"天空一声巨响,宝宝闪亮登场!",
	"本宝宝又重见天日了~~~",
}

-- 被主人攻击时说的话
local leaderAtkSayTable = {
	"主人,你为什么要打宝宝?是不是宝宝做错了什么...555",
	"主人,宝宝好疼!",
	"主人打宝宝了,你不是宝宝的好主人了",
	"友谊的小船说翻就翻!",
	"蓝瘦...香菇...",
}

-- 死亡时说的话
local deathSayTable = {
	"主人...来生再见...",
	"主人...你会想宝宝吗...",
	"世界这么大,宝宝还没有看过...",
}

-- 包包满时说的话
local fullSayTable = {
	"主人,宝宝拿不下更多的东西了!",
	"宝宝只能带这么多东西！",
	"宝宝的口袋都装满了。",
	"宝宝体力有限，携带不了更多东西了。",
	"宝宝只能拿这么多了！",
	"宝宝强壮的手臂实在无法搬动更多东西了。",
	"物品超出携带容量",
}

---------------------------------  宝宝经验  ---------------------------------
-- 经验系数
local EXP_MODULUS = 1
-- 最高等级
local MAX_LEVEL = 99
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
	inst.babydata.exp = math.max(0, inst.babydata.exp)
	inst.babydata.exp = math.min(max_exp, inst.babydata.exp)

	local nowLevel = ExpLevel(inst.babydata.exp)
	if inst.babydata.level ~= nowLevel or isRun then
		local oldLv = inst.babydata.level or 0
		local isUp = nowLevel > oldLv
		inst.babydata.level = nowLevel

		local hunger_percent, health_percent
		if not isNotFull then
			hunger_percent = inst.components.hunger:GetPercent()
			health_percent = inst.components.health:GetPercent()
		end

		local hungerBuff = inst.babydata.level * (inst.babydata.init_maxhunger - inst.babydata.init_minhunger) / #exps
		local healthBuff = inst.babydata.level * (inst.babydata.init_maxhealth - inst.babydata.init_minhealth) / #exps
		local atkperBuff = inst.babydata.level * (inst.babydata.init_maxatkper - inst.babydata.init_minatkper) / #exps
		local damageMultBuff = inst.babydata.level * (inst.babydata.init_damageMultMax - 1) / #exps
		local absorbBuff = inst.babydata.level * inst.babydata.init_AbsorptionMax / #exps
		local healthRegenBuff = inst.babydata.level * inst.babydata.init_HealthRegenMax / #exps

		inst.babydata.maxhunger = math.ceil(inst.babydata.init_minhunger + hungerBuff)
		inst.babydata.maxhealth = math.ceil(inst.babydata.init_minhealth + healthBuff)
		inst.babydata.maxatkper = inst.babydata.init_minatkper + atkperBuff
		inst.babydata.damageMult = 1 + damageMultBuff
		inst.babydata.absorb = absorbBuff
		inst.babydata.healthRegen = healthRegenBuff

		inst.components.hunger.max = inst.babydata.maxhunger
		inst.components.health.maxhealth = inst.babydata.maxhealth
		inst.components.health.absorb = inst.babydata.absorb
		inst.components.health:StartRegen(inst.babydata.healthRegen, 1)
		inst.components.combat.damagemultiplier = inst.babydata.damageMult
		inst.components.combat:SetAttackPeriod(inst.babydata.maxatkper)

		if hunger_percent then
			inst.components.hunger:SetPercent(hunger_percent)
			inst.components.health:SetPercent(health_percent)
		end

		-- 宝宝学会砍
		if nowLevel >= TUNING.PLAYERBABY_WORK_CHOP then
			if not inst.babydata.canWork.CHOP then
				inst.babydata.canWork.CHOP = true
				inst.canWork[ACTIONS.CHOP] = true
				PlayerSay(inst, "宝宝会用斧子了,以后宝宝吃饱了可以帮主人砍树哦", 5, 3)
			end
		else
			if inst.babydata.canWork.CHOP then
				inst.babydata.canWork.CHOP = false
				inst.canWork[ACTIONS.CHOP] = false
				PlayerSay(inst, "宝宝好像忘记怎么用斧子了", 5, 3)
			end
		end

		-- 宝宝学会锄头
		if nowLevel >= TUNING.PLAYERBABY_WORK_MINE then
			if not inst.babydata.canWork.MINE then
				inst.babydata.canWork.MINE = true
				inst.canWork[ACTIONS.MINE] = true
				PlayerSay(inst, "宝宝会用锄头了,以后宝宝吃饱了可以帮主人挖矿哦", 5, 3)
			end
		else
			if inst.babydata.canWork.MINE then
				inst.babydata.canWork.MINE = false
				inst.canWork[ACTIONS.MINE] = false
				PlayerSay(inst, "宝宝好像忘记怎么用锄头了", 5, 3)
			end
		end

		-- 宝宝学会挖
		if nowLevel >= TUNING.PLAYERBABY_WORK_DIG then
			if not inst.babydata.canWork.DIG then
				inst.babydata.canWork.DIG = true
				inst.canWork[ACTIONS.DIG] = true
				PlayerSay(inst, "宝宝会用铲子了,以后宝宝吃饱了可以帮主人铲东西哦", 5, 3)
			end
		else
			if inst.babydata.canWork.DIG then
				inst.babydata.canWork.DIG = false
				inst.canWork[ACTIONS.DIG] = false
				PlayerSay(inst, "宝宝好像忘记怎么用铲子了", 5, 3)
			end
		end

		-- 宝宝学会锤子
		if nowLevel >= TUNING.PLAYERBABY_WORK_HAMMER then
			if not inst.babydata.canWork.HAMMER then
				inst.babydata.canWork.HAMMER = true
				inst.canWork[ACTIONS.HAMMER] = true
				PlayerSay(inst, "宝宝会用锤子了,以后宝宝吃饱了可以帮主人砸东西哦", 5, 3)
			end
		else
			if inst.babydata.canWork.HAMMER then
				inst.babydata.canWork.HAMMER = false
				inst.canWork[ACTIONS.HAMMER] = false
				PlayerSay(inst, "宝宝好像忘记怎么用锤子了", 5, 3)
			end
		end

		-- 宝宝学会采集
		if nowLevel >= TUNING.PLAYERBABY_WORK_PICK then
			if not inst.babydata.canWork.PICK then
				inst.babydata.canWork.PICK = true
				inst.canWork[ACTIONS.PICK] = true
				inst.babydata.canWork.HARVEST = true
				inst.canWork[ACTIONS.HARVEST] = true
				PlayerSay(inst, "宝宝会采集了,以后宝宝吃饱了可以帮主人采集哦", 5, 3)
			end
		else
			if inst.babydata.canWork.PICK then
				inst.babydata.canWork.PICK = false
				inst.canWork[ACTIONS.PICK] = false
				inst.babydata.canWork.HARVEST = false
				inst.canWork[ACTIONS.HARVEST] = false
				PlayerSay(inst, "宝宝好像忘记怎么采集了", 5, 3)
			end
		end

		-- 宝宝学会捡东西
		if nowLevel >= TUNING.PLAYERBABY_WORK_PICKUP then
			if not inst.babydata.canWork.PICKUP then
				inst.babydata.canWork.PICKUP = true
				inst.canWork[ACTIONS.PICKUP] = true
				PlayerSay(inst, "宝宝会捡东西了,以后宝宝吃饱了可以帮主人捡垃圾哦", 5, 3)
			end
		else
			if inst.babydata.canWork.PICKUP then
				inst.babydata.canWork.PICKUP = false
				inst.canWork[ACTIONS.PICKUP] = false
				PlayerSay(inst, "宝宝好像忘记怎么捡垃圾了", 5, 3)
			end
		end

		-- -- 宝宝25级学会捕虫网
		-- if nowLevel >= 25 then
		-- 	if not inst.babydata.canWork.NET then
		-- 		inst.babydata.canWork.NET = true
		-- 		inst.canWork[ACTIONS.NET] = true
		-- 		PlayerSay(inst, "宝宝会用捕虫网了,以后宝宝吃饱了可以帮主人抓东西哦", 5, 3)
		-- 	end
		-- else
		-- 	if inst.babydata.canWork.NET then
		-- 		inst.babydata.canWork.NET = false
		-- 		inst.canWork[ACTIONS.NET] = false
		-- 		PlayerSay(inst, "宝宝好像忘记怎么用捕虫网了", 5, 3)
		-- 	end
		-- end

		if oldLv > 0 and nowLevel ~= oldLv then
			PlayerSay(inst, string.format("%s %d -> %d\n当前经验: %d", isUp and "升级" or "降级", oldLv, nowLevel, inst.babydata.exp), 2.5, 3)
		end
	end
end

---------------------------------  宝宝行为主体  ---------------------------------
-- 装备工作工具
local function OnEquipWork(inst, work)
	local tool = nil
	-- 黄金工具_golden
	if work == ACTIONS.CHOP then tool = "swap_lucy_axe" --"swap_axe"
	elseif work == ACTIONS.MINE then tool = "swap_pickaxe"
	elseif work == ACTIONS.DIG then tool = "swap_shovel"
	elseif work == ACTIONS.HAMMER then tool = "swap_hammer"
	elseif work == ACTIONS.NET then tool = "swap_bugnet"
	end

	if tool ~= nil then
		if inst.oldHands == nil then
			inst.oldHands = inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
			-- if inst.oldHands ~= nil then
			-- 	inst.components.inventory:GiveItem(inst.oldHands)
			-- end
		end

		if inst.oldtool ~= tool then
			inst.oldtool = tool
			inst.AnimState:OverrideSymbol("swap_object", tool, tool)
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
	end

	return true
end

-- 还原武器
local function OnEquipOldHands(inst)
	if inst.oldHands ~= nil then
		-- local equipHand = inst.components.inventory:RemoveItem(inst.oldHands)
		-- if equipHand ~= nil then
		-- 	inst.components.inventory:Equip(equipHand)
		-- end
		inst.components.inventory:Equip(inst.oldHands)
		inst.oldHands = nil
		inst.oldtool = nil
	end
end

local GD_Player_Baby = Class(function(self, inst)
	self.inst = inst
	self.baby = nil
	self.old_attacked = nil
	self.old_newcombattarget = nil
	self.old_moonpetrify = nil
	self.old_moontransformed = nil
	self._respawntask = nil
	self._onkilled = function(owner, data) self:OnBabyKilled(owner, data) end
	self._ondeath = function(owner, data) self:OnBabyDeath(owner, data) end
	self._onremove = function(owner) self:OnBabyRemove(owner) end
	self._onfinishedwork = function(owner, data) self:OnFinishedWork(data.target, data.action) end
	self.sysRemove = false
	self.lastkilled = nil
	self.babydata = {
		userid = nil,
		prefab = nil,
		exp = 0,
		level = 1,
		-- 血量
		maxhealth = TUNING.PLAYERBABY_DEFAULT_MAXHEALTH,
		init_minhealth = TUNING.PLAYERBABY_DEFAULT_MAXHEALTH,
		init_maxhealth = TUNING.PLAYERBABY_LEVEL_MAXHEALTH,
		-- 饥饿
		maxhunger = TUNING.PLAYERBABY_HUNGER,
		init_minhunger = TUNING.PLAYERBABY_HUNGER,
		init_maxhunger = TUNING.PLAYERBABY_LEVEL_HUNGER,
		-- 伤害加成
		damageMult = 1,
		init_damageMultMax = TUNING.PLAYERBABY_DAMAGE_MULT_MAX,
		-- 攻击频率(影响使用的ai)
		maxatkper = TUNING.PLAYERBABY_ATTACK_PERIOD,
		init_minatkper = TUNING.PLAYERBABY_ATTACK_PERIOD,
		init_maxatkper = TUNING.PLAYERBABY_LEVEL_ATTACK_PERIOD,
		-- 防御减免
		absorb = 0,
		init_AbsorptionMax = TUNING.PLAYERBABY_ABSORPTION_MAX,
		-- 每秒回血
		healthRegen = 0,
		init_HealthRegenMax = TUNING.PLAYERBABY_HEALTH_REGEN_MAX,
		-- health = nil,
		canWork = {
			-- ATTACK = true,
			CHOP = false,
			MINE = false,
			DIG = false,
			HAMMER = false,
			NET = false,
			PICKUP = false,
			PICK = false,
			HARVEST = false,
		},
		canAtk = true,
		-- canChop = false,
		-- canMine = false,
		-- canDig = false,
		-- equipslots = {},
		timetorespawn = nil,
		savedata = {},
	}
	self.canWork = {}
	self.leadercmd = {
		follow = true,
	}
end)

-- 说话
function PlayerSay(player, msg, delay, duration, noanim, force, nobroadcast, colour)
	if player ~= nil and player.components.talker then
		player:DoTaskInTime(delay or 0.01, function ()
			player.components.talker:Say(msg, duration or 2.5, noanim, force, nobroadcast, colour)
		end)
	end
end

-- 带颜色渲染的话
function PlayerColorSay(player, msg, colour, delay, duration)
	PlayerSay(player, msg, delay, duration, nil, nil, nil, colour)
end

--通过id获取当前世界玩家
local function GetTheWorldPlayerById(id)
    for _,p in pairs(AllPlayers) do
        if p.userid == id then 
            return p
        end
    end
	return nil
end

-- 获取物体周围一个随机范围内有效的地形
local function GetFanValidPoint(position, minRadiu, maxRadiu, attempts)
	local theta = math.random() * 2 * PI
	local radius = math.random(minRadiu or 8, maxRadiu or 15)
	local attempts = attempts or 30
	local result_offset = FindValidPositionByFan(theta, radius, attempts, function(offset)
		local run_point = position+offset
		local tile = _G.TheWorld.Map:GetTileAtPoint(run_point.x, run_point.y, run_point.z)
		if tile == GROUND.IMPASSABLE or tile == GROUND.INVALID or tile >= GROUND.UNDERGROUND then
			return false
		end
		return true
	end)
	if result_offset ~= nil then
		local pos = position + result_offset
		return pos
	end
end

-- 移除指定文件监听方法并返回原始Fn
local function RemoveEventCallbackEx(inst, event, filepath)
	local old_event_key, old_event = nil, nil

	-- 移除指定监听方法
	if inst.event_listeners ~= nil and inst.event_listeners[event] ~= nil and inst.event_listeners[event][inst] ~= nil then
		--print("find event begin")
		for i, fn in ipairs(inst.event_listeners[event][inst]) do
			local info = debug.getinfo(fn,"LnS")
			if string.find(info.source, filepath) then
				old_event_key = i
				old_event = fn
				break
				--print(string.format("      %s = function - %s", i, info.source..":"..tostring(info.linedefined)))
			end
			
		end
		--print("find event end")
	end

	-- 移除指定监听方法
	if inst.event_listeners ~= nil and inst.event_listeners[event] ~= nil and inst.event_listeners[event][inst] ~= nil then
		-- inst.event_listening[event][inst] = nil
		-- inst.event_listeners[event][inst] = nil
		-- inst.event_listening[event][inst][old_event_key] = OnEvent
		-- inst.event_listeners[event][inst][old_event_key] = OnEvent
		inst:RemoveEventCallback(event, old_event)
	end

	return old_event
end

-- 载入存储数据
function SpawnBabySaveRecord(inst, saved, newents)
    --print(string.format("~~~~~~~~~~~~~~~~~~~~~SpawnSaveRecord [%s, %s, %s]", tostring(saved.id), tostring(saved.prefab), tostring(saved.data)))
    -- local inst = SpawnPrefab(saved.prefab, saved.skinname, saved.skin_id)

    if inst then
		if saved.alt_skin_ids then
			inst.alt_skin_ids = saved.alt_skin_ids
		end
		
        inst.Transform:SetPosition(saved.x or 0, saved.y or 0, saved.z or 0)
        if not inst.entity:IsValid() then
            --print(string.format("SpawnSaveRecord [%s, %s] FAILED - entity invalid", tostring(saved.id), saved.prefab))
            return nil
        end

        if newents then

            --this is kind of weird, but we can't use non-saved ids because they might collide
            if saved.id  then
                newents[saved.id] = {entity=inst, data=saved.data} 
            else
                newents[inst] = {entity=inst, data=saved.data} 
            end

        end

        -- Attach scenario. This is a special component that's added based on save data, not prefab setup.
        if saved.scenario or (saved.data and saved.data.scenariorunner) then
            if inst.components.scenariorunner == nil then
                inst:AddComponent("scenariorunner")
            end
            if saved.scenario then
                inst.components.scenariorunner:SetScript(saved.scenario)
            end
        end
        inst:SetPersistData(saved.data, newents)

    else
        print(string.format("SpawnSaveRecord [%s, %s] FAILED", tostring(saved.id), saved.prefab))
    end

    return inst
end

local function GetLeader(inst)
    return inst.components.follower.leader or GetTheWorldPlayerById(inst.babydata.userid)
end

local function RetargetFn(inst)
    --Find things attacking leader
    local leader = GetLeader(inst)
	-- print("输出主人和宝宝目标", leader, inst.components.combat.target)
    return leader ~= nil
        and FindEntity(
            leader,
            TUNING.SHADOWWAXWELL_TARGET_DIST,
            function(guy)
                return guy ~= inst and guy ~= leader
                    and ((guy.components.combat:TargetIs(leader) or guy.components.combat:TargetIs(inst))
					     or leader.components.combat.target == guy)
                    and inst.components.combat:CanTarget(guy)
            end,
            { "_combat" }, -- see entityreplica.lua
            { "playerghost", "INLIMBO" }
        )
        or nil
end

local function KeepTargetFn(inst, target)
    --Is your leader nearby and your target not dead? Stay on it.
    --Match KEEP_WORKING_DIST in brain
	local leader = GetLeader(inst)
    return leader ~= nil and inst:IsNear(leader, 14)
        and inst.components.combat:CanTarget(target)
end

-- 被攻击的逻辑
local function OnAttacked(inst, data)
    if data.attacker ~= nil then
		if data.attacker.userid == inst.babydata.userid then
			PlayerColorSay(inst, leaderAtkSayTable[math.random(#leaderAtkSayTable)], BABY_SAY_COLOUR)
        elseif data.attacker.components.combat ~= nil then
            inst.components.combat:SuggestTarget(data.attacker)
        end
    end
end

local function OnEat(inst, food)
    if food.components.edible ~= nil then
		local full = inst.components.hunger:GetPercent() >= 1
		inst:PushEvent("eat", { full = full, food = food })

		-- 宝宝吃东西经验处理
		local max_exp = exps[#exps].maxExp
		if inst.babydata.exp < max_exp then
			if food and food.components.edible then
				local upExp = 0
				if food_exp[food.prefab] ~= nil then
					upExp = food_exp[food.prefab]
				else
					upExp = (food.components.edible.hungervalue / 50 + food.components.edible.sanityvalue / 20 + food.components.edible.healthvalue / 30) * EXP_MODULUS
					upExp = upExp > .5 and math.ceil(upExp) or 0
				end

				if upExp > 0 then
					if inst.babydata.exp + upExp > max_exp then
						upExp = max_exp - inst.babydata.exp
					end
					inst.babydata.exp = inst.babydata.exp + upExp
					PlayerSay(inst, string.format("吃[%s]\n[经验值] +%d ", food.name, upExp))
					applyLevelExp(inst)
				end
			end
		end
    end
end

local function ShouldAcceptItem(inst, item, giver)
	if giver.components.gd_playerbaby ~= nil and giver.components.gd_playerbaby.baby == inst then
		if item.components.equippable ~= nil and (item.components.equippable.equipslot == EQUIPSLOTS.HEAD or item.components.equippable.equipslot == EQUIPSLOTS.BODY or item.components.equippable.equipslot == EQUIPSLOTS.HANDS) then
			return true
		elseif item.components.edible ~= nil and inst.components.eater:CanEat(item) then
			return true
		end
	else
		PlayerColorSay(inst, "宝宝只收主人给的东西", BABY_SAY_COLOUR)
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if giver.components.gd_playerbaby ~= nil and giver.components.gd_playerbaby.baby == inst then
		--I eat food
		if item.components.edible ~= nil and inst.components.eater:CanEat(item) then
			if inst.components.combat:TargetIs(giver) then
				inst.components.combat:SetTarget(nil)
			end
			
			-- if inst.components.sleeper:IsAsleep() then
			--     inst.components.sleeper:WakeUp()
			-- end

			inst.components.eater:Eat(item, inst)
		end

		--I wear hats
		if item.components.equippable ~= nil and (item.components.equippable.equipslot == EQUIPSLOTS.HEAD or item.components.equippable.equipslot == EQUIPSLOTS.BODY or item.components.equippable.equipslot == EQUIPSLOTS.HANDS) then
			OnEquipOldHands(inst)
			local current = inst.components.inventory:GetEquippedItem(item.components.equippable.equipslot)
			if current ~= nil then
				inst.components.inventory:DropItem(current)
			end
			inst.components.inventory:Equip(item)
			-- inst.AnimState:Show("hat")
		end
	end
end

-- 饥饿为0时的处理
local function OnStarving(inst, dt)
    -- apply no health damage; the stomach is just used by domesticatable
    -- inst.components.domesticatable:DeltaObedience(TUNING.BEEFALO_DOMESTICATION_STARVE_OBEDIENCE * dt)
    --inst.components.domesticatable:DeltaDomestication(TUNING.BEEFALO_DOMESTICATION_STARVE_DOMESTICATION * dt)
end

-- 脑残光环
local function CalcSanityAura(inst, observer)
	local leader = GetLeader(inst)
    return (leader == observer and inst.sg:HasStateTag("dancing") and TUNING.SANITYAURA_SMALL)
        or 0
end

----	武器样式
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

----	武器栏
local function GetInventory(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local meleeweapon = CreateEntity()
        meleeweapon.entity:AddTransform()
        meleeweapon:AddComponent("weapon")
        meleeweapon.components.weapon:SetDamage(17)
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
        meleeweapon:AddComponent("equippable")
		----	武器外观
		meleeweapon.components.equippable:SetOnEquip(onequip)
		meleeweapon.components.equippable:SetOnUnequip(onunequip)
        meleeweapon:AddTag("meleeweapon")
		inst.components.inventory:Equip(meleeweapon)
    end
end

-- 重写目标验证方法
local function OverrideIsValidTarget(inst)
	local old_IsValidTargetFn = inst.replica.combat.IsValidTarget
	function inst.replica.combat:IsValidTarget(target)
		-- print("验证目标", target, target.name)
		if target == nil or
			target == self.inst or
			not (target.entity:IsValid() and target.entity:IsVisible()) then
			return false
		end

		local weapon = self:GetWeapon()
		return self:CanExtinguishTarget(target, weapon)
			or self:CanLightTarget(target, weapon)
			or (target.replica.combat ~= nil and
				target.replica.health ~= nil and
				not target.replica.health:IsDead() and
				-- not (target:HasTag("shadow") and self.inst.replica.sanity == nil) and
				not (target:HasTag("playerghost") and (self.inst.replica.sanity == nil or self.inst.replica.sanity:IsSane())) and
				-- gjans: Some specific logic so the birchnutter doesn't attack it's spawn with it's AOE
				-- This could possibly be made more generic so that "things" don't attack other things in their "group" or something
				(not self.inst:HasTag("birchnutroot") or not (target:HasTag("birchnutroot") or target:HasTag("birchnut") or target:HasTag("birchnutdrake"))) and 
				(TheNet:GetPVPEnabled() or not (self.inst:HasTag("player") and target:HasTag("player"))) and
				target:GetPosition().y <= self._attackrange:value())
	end
end

-- 初始化tag和组件
function GD_Player_Baby:InitTagAndComponents()
	if self.baby ~= nil and self.baby:IsValid() then
		self.baby:RemoveTag("pig")
		self.baby:RemoveTag("guard")
		self.baby:RemoveTag("scarytoprey")

		if self.baby.components.werebeast then
			self.baby.components.werebeast:SetOnWereFn(nil)
			self.baby.components.werebeast:SetOnNormalFn(nil)
			self.baby.components.werebeast:SetTriggerLimit(nil)
			self.baby:RemoveComponent("werebeast")
		end
		if self.baby.components.hauntable then
			self.baby:RemoveComponent("hauntable")
		end
		if self.baby.components.sleeper then
			self.baby.components.sleeper:SetDefaultTests()
			self.baby:RemoveComponent("sleeper")
		end

		-- 使宝宝可被查看
		if self.baby.components.inspectable == nil then
			self.baby:AddComponent("inspectable")
		end
		self.baby.components.inspectable.getstatus = nil

		-- 命名组件
		if self.baby.components.named == nil then
			self.baby:AddComponent("named")
		end

		-- 跟随组件
		if self.baby.components.follower == nil then
			self.baby:AddComponent("follower")
		end

		-- 行动组件
		if self.baby.components.locomotor == nil then
			self.baby:AddComponent("locomotor")
		end

		-- 物品栏组件
		if self.baby.components.inventory == nil then
			self.baby:AddComponent("inventory")
		end

		-- 特效
		-- if self.baby.components.colourtweener == nil then
		-- 	self.baby:AddComponent("colourtweener")
		-- end

		-- 喂养组件
		if self.baby.components.eater == nil then
			self.baby:AddComponent("eater")
		end

		-- 给予物品组件
		if self.baby.components.trader == nil then
			self.baby:AddComponent("trader")
		end

		-- 饥饿状态组件
		if self.baby.components.hunger == nil then
			self.baby:AddComponent("hunger")
		end

		-- -- 骑行组件
		-- if self.baby.components.rider == nil then
		-- 	self.baby:AddComponent("rider")
		-- end

		-- -- 脑残依赖组件
		-- if self.baby.components.moisture == nil then
		-- 	self.baby:AddComponent("moisture")
		-- end

		-- -- 脑残状态组件
		-- if self.baby.components.sanity == nil then
		-- 	self.baby:AddComponent("sanity")
		-- end
		if self.baby.components.sanity == nil then
			self.baby.components.sanity = {}
			function self.baby.components.sanity:DoDelta( ... ) end
			function self.baby.components.sanity:GetPercent( ... ) return 1 end
		end

		-- 脑残光环组件
		if self.baby.components.sanityaura == nil then
			self.baby:AddComponent("sanityaura")
		end

		-- 生命值组件
		if self.baby.components.health == nil then
			self.baby:AddComponent("health")
		end

		-- 攻击组件
		if self.baby.components.combat == nil then
			self.baby:AddComponent("combat")
		end
		OverrideIsValidTarget(self.baby)

		-- 冰冻组件
		if self.baby.components.freezable == nil then
			self.baby:AddComponent("freezable")
		end
	end
end

-- 初始化事件移除和监听
function GD_Player_Baby:InitAddAndRemoveEvents()
	if self.baby ~= nil and self.baby:IsValid() then
		-- 重写被攻击后方法
		if self.old_attacked == nil then
			self.old_attacked = RemoveEventCallbackEx(self.baby, "attacked", "scripts/prefabs/pigman.lua")
		else
			self.baby:RemoveEventCallback("attacked", self.old_attacked)
		end
		if self.old_newcombattarget == nil then
			self.old_newcombattarget = RemoveEventCallbackEx(self.baby, "newcombattarget", "scripts/prefabs/pigman.lua")
		else
			self.baby:RemoveEventCallback("newcombattarget", self.old_newcombattarget)
		end
		if self.old_moonpetrify == nil then
			self.old_moonpetrify = RemoveEventCallbackEx(self.baby, "moonpetrify", "scripts/prefabs/pigman.lua")
		else
			self.baby:RemoveEventCallback("moonpetrify", self.old_moonpetrify)
		end
		if self.old_moontransformed == nil then
			self.old_moontransformed = RemoveEventCallbackEx(self.baby, "moontransformed", "scripts/prefabs/pigman.lua")
		else
			self.baby:RemoveEventCallback("moontransformed", self.old_moontransformed)
		end
		self.baby:ListenForEvent("attacked", OnAttacked)
		self.baby:ListenForEvent("finishedwork", self._onfinishedwork)
		self.baby:ListenForEvent("killed", self._onkilled)
		self.baby:ListenForEvent("death", self._ondeath)
		self.baby:ListenForEvent("onremove", self._onremove)
		self.baby:ListenForEvent("inventoryfull", function(it, data)
			if self.baby.components.inventory:IsFull() then
				-- 包包满了
				PlayerColorSay(self.baby, fullSayTable[math.random(#fullSayTable)], BABY_SAY_COLOUR)
			end
		end)
	end
end

function GD_Player_Baby:MakePlayer(skinPrefab)
	if self.baby ~= nil and self.baby:IsValid() then
		return false
	end

	self.baby = SpawnPrefab("pigguard")
	if skinPrefab == "wathgrithr" or skinPrefab == "webber" then
		self.baby.talker_path_override = "dontstarve_DLC001/characters/"
	end
	if skinPrefab == "waxwell" then
		self.baby.soundsname = "maxwell"
	end
	self.babydata.userid = self.inst.userid
	self.babydata.prefab = skinPrefab
	self.babydata.timetorespawn = nil
	for k, v in pairs(self.babydata.canWork) do
		self.canWork[ACTIONS[k]] = v
	end
	self.baby.babydata = self.babydata
	self.baby.canWork = self.canWork
	self.baby.leadercmd = self.leadercmd
	self.baby.onequipwork = OnEquipWork
	self.baby.onoldequiphands = OnEquipOldHands

	self.baby.AnimState:SetBank("wilson")
	self.baby.AnimState:SetBuild(skinPrefab)
	self.baby.AnimState:PlayAnimation("idle")
	-- 添加羽毛帽头饰显示效果
	--self.baby.AnimState:OverrideSymbol("swap_hat", "hat_feather", "swap_hat")
	-- self.baby.AnimState:Show("HAT")
	-- self.baby.AnimState:Show("HAT_HAIR")
	-- self.baby.AnimState:Hide("HAIR_NOHAT")
	-- self.baby.AnimState:Hide("HAIR")
	-- 隐藏持有武器的动作
	self.baby.AnimState:Hide("ARM_carry")
	self.baby.AnimState:Hide("HAT")
    self.baby.AnimState:Hide("HAIR_HAT")
    self.baby.AnimState:Show("HAIR_NOHAT")
    self.baby.AnimState:Show("HAIR")
    self.baby.AnimState:Show("HEAD")
    self.baby.AnimState:Hide("HEAD_HAT")
	-- 添加木甲显示效果
	-- self.baby.AnimState:OverrideSymbol("swap_body", "armor_wood", "swap_body")
	-- 武器效果
	-- self.baby.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
	-- 添加胡须
	-- self.baby.AnimState:OverrideSymbol("beard", "beard", "beard_long")

	-- 初始化组件
	self:InitTagAndComponents()
	self:InitAddAndRemoveEvents()

	self.baby:SetStateGraph("gd_SGplayerbaby")
    self.baby:SetBrain(brain)

	self.baby.components.named:SetName(self.inst.name .. "的宝宝")
	self.baby.health_oldname = self.inst.name .. "的宝宝"

	self.baby.components.follower:KeepLeaderOnAttacked()
    self.baby.components.follower.keepdeadleader = true
	self.baby.components.follower.maxfollowtime = nil

	self.baby.components.locomotor.runspeed = self.inst.components.locomotor.runspeed * 1.5
    self.baby.components.locomotor.walkspeed = self.inst.components.locomotor.walkspeed * 1.5
	self.inst.components.leader:AddFollower(self.baby)
	
	local currentscale = self.baby.Transform:GetScale()
	self.baby.Transform:SetScale(currentscale*0.7,currentscale*0.7,currentscale*0.7)

	self.baby.components.eater:SetOnEatFn(OnEat)

	self.baby.components.trader:SetAcceptTest(ShouldAcceptItem)
	self.baby.components.trader.onaccept = OnGetItemFromPlayer
	self.baby.components.trader.onrefuse = nil

	self.baby.components.hunger:SetMax(self.babydata.maxhunger)
    self.baby.components.hunger:SetRate(TUNING.PLAYERBABY_HUNGER_RATE)
	self.baby.components.hunger:SetOverrideStarveFn(OnStarving)

	self.baby.components.sanityaura.aurafn = CalcSanityAura

	self.baby.components.health:SetMaxHealth(self.babydata.maxhealth)
	self.baby.components.health:StartRegen(self.babydata.healthRegen, 1)
	self.baby.components.health.absorb = self.babydata.absorb

	-- GetInventory(self.baby)
	self.baby.components.combat.hiteffectsymbol = "marker"
	self.baby.components.combat:SetRetargetFunction(1, RetargetFn)
	self.baby.components.combat:SetKeepTargetFunction(KeepTargetFn)
	self.baby.components.combat:SetDefaultDamage(TUNING.PLAYERBABY_UNARMED_DAMAGE)
	self.baby.components.combat:SetAttackPeriod(self.babydata.maxatkper)
	self.baby.components.combat.damagemultiplier = self.babydata.damageMult
	-- self.baby.components.combat:SetRange(2)
	-- self.baby.Transform:SetPosition(self.inst.Transform:GetWorldPosition())

	if self.baby.components.talker ~= nil then
		self.baby.components.talker.ontalk = nil
		self.baby.components.talker:StopIgnoringAll(nil)
	end

	-- 冰冻抗性
	self.baby.components.freezable:SetResistance(8)

	-- 宝宝死亡不掉落
	self.baby.components.lootdropper:SetLoot(nil)
	self.baby.old_DropEverything = self.baby.components.inventory.DropEverything
	function self.baby.components.inventory:DropEverything(ondeath, keepequip) end

	self.baby.OnSave = function(inst, data) data.isbaby = true end
    self.baby.OnLoad = function(inst, data) end

	-- 获取宝宝状态
	self.baby.GetBabyInfoString = function()
		local max_exp = exps[#exps].maxExp
		local nowLv = ExpLevel(self.baby.babydata.exp)
		local exp = self.baby.babydata.exp or 0
		local nextExp = exps[math.min(MAX_LEVEL, nowLv + 1)].maxExp - exp
		nextExp = nextExp < 0 and 0 or nextExp
		local nextLvMsg = exp >= max_exp and string.format("\n已达到最高等级") or string.format("\n距离下一级还需要 %d 点经验值", nextExp)
		local strDes = string.format("这个宝宝的当前等级: %d\n经验: %d", nowLv, exp) .. nextLvMsg

		-- 生命
		local curhp = math.ceil(self.baby.components.health.currenthealth-self.baby.components.health.minhealth)
		local maxhp = math.ceil(self.baby.components.health.maxhealth-self.baby.components.health.minhealth)
		if curhp>maxhp then curhp=maxhp end
		strDes = strDes .. "\n生命: " .. curhp .. " / " .. maxhp

		-- 饥饿
		local curhg = math.ceil(self.baby.components.hunger.current)
		local maxhg = math.ceil(self.baby.components.hunger.max)
		if curhg>maxhg then curhg=maxhg end
		strDes = strDes .. "\n饥饿: " .. curhg .. " / " .. maxhg

		return strDes
	end

	-- 加载数据
	self:LoadData()

	-- 登场宣言
	PlayerColorSay(self.baby, makeSayTable[math.random(#makeSayTable)], BABY_SAY_COLOUR)
	return true
end

-- 完成工作
function GD_Player_Baby:OnFinishedWork(target, action)
	-- OnEquipOldHands(self.baby)
	local max_exp = exps[#exps].maxExp
	if self.baby.babydata.exp < max_exp then
		local upExp = 0
		local workMsg = GetActionString(action.id, nil)

		if action == ACTIONS.CHOP then
			upExp = 1
		elseif action == ACTIONS.MINE then
			upExp = 2
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

		-- "fishing_pre"
		-- equippedTool.components.fishingrod:WaitForFish()

		if workMsg == nil or workMsg == "ACTION" then
			workMsg = "工作"
		end

		if upExp ~= 0 then
			if self.baby.babydata.exp + upExp > max_exp then
				upExp = max_exp - self.baby.babydata.exp
			end
			self.baby.babydata.exp = self.baby.babydata.exp + upExp
			PlayerSay(self.baby, string.format("完成%s[%s]\n[经验值] %s%d ", workMsg, target.oldName or target.name, upExp > 0 and "+" or "", upExp))
			applyLevelExp(self.baby)
		end
	end
end

-- 击杀
function GD_Player_Baby:OnBabyKilled(inst, data)
	local victim = data.victim
	if self.lastkilled == victim then return end
	self.lastkilled = victim

	local max_exp = exps[#exps].maxExp
	if inst.babydata.exp < max_exp then
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
				if inst.babydata.exp + upExp > max_exp then
					upExp = max_exp - inst.babydata.exp
				end
				inst.babydata.exp = inst.babydata.exp + upExp
				PlayerSay(inst, string.format("击杀[%s]\n[经验值] %s%d ", victim.name, upExp > 0 and "+" or "", upExp))
				applyLevelExp(inst)
			end
		end
	end

	if not data.babymaster then
		self.inst:PushEvent("killed", data)
	end
end

-------------------------------  控制命令开始  ------------------------------------
-- 跟随
function GD_Player_Baby:Follow(allow)
	if self.leadercmd.follow ~= allow then
		self.leadercmd.follow = allow
		if self.baby ~= nil and self.baby:IsValid() then
			if allow then
				-- 距离主人超过30码则将宝宝送到主人身边
				if not self.baby:IsNear(self.inst, 30) then
					local inst_pos = self.inst:GetPosition()
					local babyPos = GetFanValidPoint(inst_pos, 1, 5, 25) or Vector3(0, 0, 0)
					self.baby.Transform:SetPosition(babyPos:Get())

					local fx = SpawnPrefab("spawn_fx_medium")
					if fx ~= nil then
						fx.Transform:SetPosition(babyPos:Get())
					end
				end

				-- self.baby.components.health.absorb = self.absorb
				self.baby.components.health:SetInvincible(false)
				self.baby:RestartBrain()
				self.baby.components.locomotor.disable = false
				self.baby.components.combat:DropTarget()
				self.baby.components.follower:StartLeashing()
			else
				-- self.absorb = self.baby.components.health.absorb
				-- self.baby.components.health.absorb = .9
            	self.baby.components.health:SetInvincible(true)
				self.baby:StopBrain()
				self.baby.components.locomotor:Stop()
				self.baby.components.locomotor.disable = true
				self.baby.components.follower:StopLeashing()
			end
		end
	end
end

-- 丢弃
function GD_Player_Baby:DropAll()
	if self.baby ~= nil and self.baby:IsValid() then
		OnEquipOldHands(self.baby)
		local inventory = self.baby.components.inventory
		if inventory.activeitem ~= nil then
			inventory:DropItem(inventory.activeitem)
			inventory:SetActiveItem(nil)
		end

		for k = 1, inventory.maxslots do
			local v = inventory.itemslots[k]
			if v ~= nil then
				inventory:DropItem(v, true, true)
			end
		end
	end
end
-------------------------------  控制命令结束  ------------------------------------

function GD_Player_Baby:StopRespawnTimer()
    if self._respawntask ~= nil then
        self._respawntask:Cancel()
        self._respawntask = nil
    end
end

function GD_Player_Baby:StartRespawnTimer(t)
    self:StopRespawnTimer()
    self._respawntask = self.inst:DoTaskInTime(t or TUNING.PLAYERBABY_RESPAWN_TIME, function(inst)
		self:MakePlayer(self.babydata.prefab)
		self._respawntask = nil
	end)
end

function GD_Player_Baby:OnBabyDeath(inst, data)
	-- inst.components.health.currenthealth = self.babydata.maxhealth
	-- self:SaveData(true)
	-- inst.components.health.currenthealth = 0
	if not TheNet:GetPVPEnabled() and data ~= nil and data.afflicter ~= nil and data.afflicter:HasTag("player") and data.afflicter.components.health ~= nil and not data.afflicter.components.health:IsDead() then
		-- 非PVP下宝宝死亡扣除攻击玩家100点脑残值
		data.afflicter.components.sanity:DoDelta(-100)
	end
	PlayerColorSay(inst, deathSayTable[math.random(#deathSayTable)], BABY_SAY_COLOUR)
	-- self:StartRespawnTimer()

	-- 宝宝经验值处理
	local nowLevel = ExpLevel(inst.babydata.exp)
	-- print("当前状态:", nowLevel, inst.babydata.exp, exps[nowLevel].cutExp)
	local cutExp = inst.babydata.exp - exps[nowLevel].cutExp
	if cutExp > 0 then
		inst.babydata.exp = cutExp
		PlayerSay(self.inst, "[宝宝死亡]\n[宝宝经验值] -" .. exps[nowLevel].cutExp, 2)
	else
		if inst.babydata.exp > 0 then
			PlayerSay(self.inst, "[宝宝死亡]\n[宝宝经验值] -" .. inst.babydata.exp, 2)
		end
		inst.babydata.exp = 0
	end
	applyLevelExp(inst, true)
end

function GD_Player_Baby:OnBabyRemove(inst)
	-- and inst.components.health and inst.components.health.currenthealth > 0
	if not self.sysRemove then
		-- print("宝宝状态", self.baby, self.baby:IsValid())
		inst.components.health.currenthealth = self.babydata.maxhealth
		self:SaveData(true)
		inst.components.health.currenthealth = 0

		if self._respawntask == nil then
        	self:StartRespawnTimer()
		end
    end
end

function GD_Player_Baby:SaveData(isNotRemove)
	-- 保存宝宝重生时间
	if self._respawntask ~= nil then
		self.babydata.timetorespawn = math.ceil(GetTaskRemaining(self._respawntask))
	end

	-- self.babydata.equipslots = {}

	if self.baby ~= nil and self.baby:IsValid() then
		OnEquipOldHands(self.baby)
		-- for k, v in pairs(self.baby.components.inventory.equipslots) do
		-- 	if v.persists then
		-- 		self.babydata.equipslots[k] = v:GetSaveRecord()
		-- 	end
		-- end

		-- self.babydata.savedata.data, self.babydata.savedata.refs = self.baby:GetSaveRecord()
		self.babydata.savedata.data = self.baby:GetSaveRecord()

		if not isNotRemove then
			-- self.baby_save = self.baby:GetSaveRecord()
			-- self.baby.persists = false
			local fx = SpawnPrefab("spawn_fx_medium")
			if fx ~= nil then
				fx.Transform:SetPosition(self.baby.Transform:GetWorldPosition())
			end
			
			self.sysRemove = true

			-- 特效
			if self.baby.components.colourtweener == nil then
				self.baby:AddComponent("colourtweener")
			end
			self.baby.components.colourtweener:StartTween({ 0, 0, 0, 1 }, 13 * FRAMES, self.baby.Remove)
		end
	end
end

function GD_Player_Baby:LoadData()
	if self.baby ~= nil and self.baby:IsValid() then
		local inst_pos = self.inst:GetPosition()
		local babyPos = nil

		if self.babydata.savedata.data ~= nil then
			SpawnBabySaveRecord(self.baby, self.babydata.savedata.data)
			babyPos = self.baby:GetPosition()
		else
			babyPos = GetFanValidPoint(inst_pos, 1, 5, 25) or Vector3(0, 0, 0)
			self.baby.Transform:SetPosition(babyPos:Get())
		end

		local fx = SpawnPrefab("spawn_fx_medium")
		if fx ~= nil then
			fx.Transform:SetPosition(babyPos:Get())
		end
		SpawnPrefab("lightning").Transform:SetPosition(babyPos:Get())
		-- for k, v in pairs(self.babydata.equipslots) do
		-- 	local equip = SpawnSaveRecord(v)
		-- 	if equip and equip:IsValid() then
		-- 		self.babydata.equipslots[k] = nil
		-- 		self.baby.components.inventory:Equip(equip)
		-- 	end
		-- end
	end
end

function GD_Player_Baby:OnSave()
	self:SaveData(true)
	return
	{
		babydata = self.babydata
	}
end

function GD_Player_Baby:OnLoad(data)
	if data.babydata then
		self.babydata = data.babydata
		-- 兼容处理(兼容老版本)
		self.babydata.exp = self.babydata.exp or 0
		self.babydata.level = self.babydata.level or 1
		self.babydata.damageMult = self.babydata.damageMult or 1
		self.babydata.absorb = self.babydata.absorb or 0
		self.babydata.healthRegen = self.babydata.healthRegen or 0
		self.babydata.maxhealth = self.babydata.maxhealth or TUNING.PLAYERBABY_DEFAULT_MAXHEALTH
		self.babydata.init_minhealth = self.babydata.init_minhealth or TUNING.PLAYERBABY_DEFAULT_MAXHEALTH
		self.babydata.init_maxhealth = self.babydata.init_maxhealth or TUNING.PLAYERBABY_LEVEL_MAXHEALTH
		self.babydata.maxhunger = self.babydata.maxhunger or TUNING.PLAYERBABY_HUNGER
		self.babydata.init_minhunger = self.babydata.init_minhunger or TUNING.PLAYERBABY_HUNGER
		self.babydata.init_maxhunger = self.babydata.init_maxhunger or TUNING.PLAYERBABY_LEVEL_HUNGER
		self.babydata.init_damageMultMax = self.babydata.init_damageMultMax or TUNING.PLAYERBABY_DAMAGE_MULT_MAX
		self.babydata.maxatkper = self.babydata.maxatkper or TUNING.PLAYERBABY_ATTACK_PERIOD
		self.babydata.init_minatkper = self.babydata.init_minatkper or TUNING.PLAYERBABY_ATTACK_PERIOD
		self.babydata.init_maxatkper = self.babydata.init_maxatkper or TUNING.PLAYERBABY_LEVEL_ATTACK_PERIOD
		self.babydata.init_AbsorptionMax = self.babydata.init_AbsorptionMax or TUNING.PLAYERBABY_ABSORPTION_MAX
		self.babydata.init_HealthRegenMax = self.babydata.init_HealthRegenMax or TUNING.PLAYERBABY_HEALTH_REGEN_MAX
		if self.babydata.prefab ~= nil then
			self.inst:DoTaskInTime(0, function(inst)
				if self.babydata.timetorespawn == nil then
					self:MakePlayer(self.babydata.prefab)
				else
					self:StartRespawnTimer(self.babydata.timetorespawn)
				end
			end)
		end
		-- self.baby = SpawnSaveRecord(data.playerbaby)
		-- if self.inst.migrationpets ~= nil then
		-- 	table.insert(self.inst.migrationpets, self.baby)
		-- end

		-- self.inst:DoTaskInTime(0, function()
		-- 	local fx = SpawnPrefab("spawn_fx_medium")
		-- 	if fx ~= nil then
		-- 		fx.Transform:SetPosition(self.baby.Transform:GetWorldPosition())
		-- 	end
		-- end)
	end
end

return GD_Player_Baby