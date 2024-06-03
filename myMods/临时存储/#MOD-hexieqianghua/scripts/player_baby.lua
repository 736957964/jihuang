local _G = GLOBAL
local TheNet = _G.TheNet
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local TUNING = _G.TUNING

local player_baby = GetModConfigData("player_baby")

if player_baby and IsServer then
	local pigking_accept_table = {
		bluegem = "wx78",               -- 蓝宝石->机器人
		redgem = "wathgrithr",          -- 红宝石->女武神
		purplegem = "wolfgang",         -- 紫宝石->沃尔夫冈
		greengem = "wickerbottom",      -- 绿宝石->老奶奶
		yellowgem = "wilson",           -- 黄宝石->威尔逊
		orangegem = "webber",           -- 橙宝石->韦伯
		opalpreciousgem = "wendy",      -- 闪闪发亮的宝石->温迪
		redmooneye = "willow",          -- 红色月石->薇洛
		moonrocknugget = "wes",         -- 月石->韦斯
		nightmarefuel = "waxwell",      -- 噩梦燃料->麦斯威尔
		fossil_piece = "woodie",        -- 化石碎片->伍迪
	}

	-- 处理宝宝残留物
    AddPrefabPostInit("pigguard", function(inst)
		local OldOnSave=inst.OnSave
		inst.OnSave = function(inst,data)
			if OldOnSave~=nil then
				OldOnSave(inst,data)
			end
			if inst.babydata ~= nil then
				data.isbaby = true
			end
		end
		
		local OldOnLoad=inst.OnLoad
		inst.OnLoad = function(inst,data)
			if OldOnLoad~=nil then
				OldOnLoad(inst,data)
			end
			if data ~= nil and data.isbaby then
				inst:DoTaskInTime(0, function(inst)
					inst:Remove()
				end)
			end
		end
	end)

	-- 处理青蛙攻击宝宝不掉落
    AddPrefabPostInit("frog", function(inst)
		local old_OnHitOtherFn = inst.components.combat.onhitotherfn
		inst.components.combat.onhitotherfn = function(inst, other, damage)
			if other.babydata ~= nil then return end
			if old_OnHitOtherFn ~= nil then
				old_OnHitOtherFn(inst, other, damage)
			end
		end
	end)

	-- 处理宝宝击杀影怪给主人回脑残
	local shadow_table = {
		"crawlinghorror",     -- 暗影爬行怪
		"terrorbeak",         -- 巨喙梦魇
	}

	local function GetBabyLeader(inst)
		return inst.components.follower.leader or GetTheWorldPlayerById(inst.babydata.userid)
	end

	local function ShadowKilledByOtherFn(inst)
		local old_OnKilledByOtherFn = inst.components.combat.onkilledbyother
		inst.components.combat.onkilledbyother = function(inst, attacker)
			if attacker and attacker.babydata ~= nil then
				local leader = GetBabyLeader(attacker)
				if leader and leader.components.sanity then
					leader.components.sanity:DoDelta(inst.sanityreward or TUNING.SANITY_SMALL)
				end
			elseif old_OnKilledByOtherFn ~= nil then
				old_OnKilledByOtherFn(inst, attacker)
			end
		end
	end

	for k,name in pairs(shadow_table) do
		AddPrefabPostInit(name, ShadowKilledByOtherFn)
	end

	-- 给予猪王宝石换宝宝
    AddPrefabPostInit("pigking", function(inst)
		local function onplayhappysound(inst)
			inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingHappy")
		end

		local function onendhappytask(inst)
			inst.happy = false
			inst.endhappytask = nil
		end

		-- 生成宝宝
		local function ontradeforbaby(inst, item, giver)
			giver.components.gd_playerbaby:MakePlayer(pigking_accept_table[item.prefab])
		end

		local old_OnAcceptTestFn = inst.components.trader.test
		local function AcceptTest(inst, item, giver)
			if pigking_accept_table[item.prefab] ~= nil and giver.components.gd_playerbaby ~= nil then
				if giver.components.gd_playerbaby.baby == nil and giver.components.gd_playerbaby._respawntask == nil then return true end
				PlayerSay(giver, "我做不到,只能换一个宝宝")
			end
			return old_OnAcceptTestFn(inst, item, giver)
		end
		inst.components.trader:SetAcceptTest(AcceptTest)

        local old_onaccept = inst.components.trader.onaccept
        inst.components.trader.onaccept = function(inst, giver, item)
			if pigking_accept_table[item.prefab] ~= nil and giver.components.gd_playerbaby ~= nil and giver.components.gd_playerbaby.baby == nil and giver.components.gd_playerbaby._respawntask == nil then
				inst.AnimState:PlayAnimation("cointoss")
				inst.AnimState:PushAnimation("happy")
				inst.AnimState:PushAnimation("idle", true)
				inst:DoTaskInTime(20/30, ontradeforbaby, item, giver)
				inst:DoTaskInTime(1.5, onplayhappysound)
				inst.happy = true
				if inst.endhappytask ~= nil then
					inst.endhappytask:Cancel()
				end
				inst.endhappytask = inst:DoTaskInTime(5, onendhappytask)
            elseif old_onaccept ~= nil then old_onaccept(inst, giver, item) end
        end
	end)

	AddPlayerPostInit(function(inst)
		inst:AddComponent("gd_playerbaby")

		local old_OnDespawn = inst._OnDespawn
		function inst._OnDespawn(inst, ...)
			if old_OnDespawn then
				old_OnDespawn(inst, ...)
			end
			inst.components.gd_playerbaby:SaveData()
		end

		local old_OnSleepIn = inst.OnSleepIn
		local old_OnWakeUp = inst.OnWakeUp
		function inst.OnSleepIn(inst)
			old_OnSleepIn(inst)
			inst.hxsleep = true
			
			if inst.components.gd_playerbaby.baby and inst.components.gd_playerbaby.baby:IsValid()
			and (not inst.components.gd_playerbaby.baby.sg:HasStateTag("busy") or
				inst.components.gd_playerbaby.baby.sg:HasStateTag("frozen"))
			then
				inst.components.gd_playerbaby.baby:PushEvent("gotosleep")
			end
		end

		function inst.OnWakeUp(inst)
			old_OnWakeUp(inst)
			inst.hxsleep = false
			
			if inst.components.gd_playerbaby.baby and inst.components.gd_playerbaby.baby:IsValid()
			and (inst.components.gd_playerbaby.baby.sg:HasStateTag("sleeping") or
				inst.components.gd_playerbaby.baby.sg:HasStateTag("bedroll") or
				inst.components.gd_playerbaby.baby.sg:HasStateTag("tent") or
				inst.components.gd_playerbaby.baby.sg:HasStateTag("waking"))
			then
				inst.components.gd_playerbaby.baby:PushEvent("wakeup")
			end
		end

		-- 当被宝宝击杀时需要显示击杀者是xxx的宝宝而不是猪人守卫
		local old_deathFn = RemoveEventCallbackEx(inst, "death", "scripts/prefabs/player_common.lua")
		if old_deathFn ~= nil then
			local function OnPlayerDeath(inst, data)
				if data ~= nil and data.afflicter ~= nil and data.afflicter.babydata ~= nil then
					data.afflicter.overridepkname = data.afflicter.name
				end

				old_deathFn(inst, data)
			end

			inst:ListenForEvent("death", OnPlayerDeath)
		end

		local function OnKilled(inst, data)
			if inst.components.gd_playerbaby.baby and inst.components.gd_playerbaby.baby:IsValid() then
				data.babymaster = true
				inst.components.gd_playerbaby.baby:PushEvent("killed", data)
			end
		end
		inst:ListenForEvent("killed", OnKilled)
	end)

	AddPrefabPostInitAny(function(inst)
		if inst.components.equippable ~= nil and inst.components.tradable == nil then
			inst:AddComponent("tradable")
		end
	end)

	-- 查看物品
	local old_LOOKAT = _G.ACTIONS.LOOKAT.fn 
	_G.ACTIONS.LOOKAT.fn = function(act)
		if act.target and act.target.babydata ~= nil then
			PlayerSay(act.doer, act.target.GetBabyInfoString())
			return true
		end
		
		return old_LOOKAT(act)
	end

	local MSG_CHOOSE = {
		["#宝宝跟"] = 1,
		["#宝宝停"] = 2,
		["#宝宝丢"] = 3,
		["#宝宝停丢"] = 4,
		["#bbg"] = 1,
		["#bbt"] = 2,
		["#bbd"] = 3,
		["#bbtd"] = 4,
	}

	AddPrefabPostInit("world", function(inst)
		--根据玩家说的话来对命令进行处理
		local OldNetworking_Say = _G.Networking_Say
		_G.Networking_Say = function(guid, userid, name, prefab, message, ...)
			local r = OldNetworking_Say(guid, userid, name, prefab, message, ...)

			--获取到玩家说的话
			local choose = MSG_CHOOSE[string.lower(message)]
			if choose then
				local talker = GetTheWorldPlayerById(userid)
				if talker == nil then
					return r
				end

				if choose == 1 then
					talker.components.gd_playerbaby:Follow(true)
				elseif choose == 2 then
					talker.components.gd_playerbaby:Follow(false)
				elseif choose == 3 then
					talker.components.gd_playerbaby:DropAll()
				elseif choose == 4 then
					talker.components.gd_playerbaby:Follow(false)
					talker.components.gd_playerbaby:DropAll()
				end
			end

			return r
		end
	end)
end