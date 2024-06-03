---By GuardAngelY---2017-02-08
modimport("scripts/gd_global.lua")
modimport("scripts/loots.lua")
modimport("scripts/anger.lua")
modimport("scripts/others.lua")
modimport("scripts/spawns.lua")
modimport("scripts/player_level.lua")
modimport("scripts/player_baby.lua")
modimport("scripts/player_restart.lua")
modimport("scripts/equipmentupgrade.lua")
modimport("scripts/otherfunction.lua")

--modimport("scripts/boostboss.lua")
--怪物变大
modimport("scripts/tobig.lua")
--建筑变狗
modimport("scripts/todog.lua")
--我的代码
modimport("scripts/mycode.lua")
--火鸡商店
--modimport("scripts/shop.lua")
--小宠物
--modimport("scripts/pet.lua")

local _G = GLOBAL
local TheNet = _G.TheNet
local TheSim = _G.TheSim
local SpawnPrefab = _G.SpawnPrefab
local FindEntity = _G.FindEntity
local FindWalkableOffset = _G.FindWalkableOffset                    
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local bosstobignum = GetModConfigData("bosstobignum")





local function elemental( inst )
  if inst.components.edible==nil then inst:AddComponent("edible") end
    inst.components.edible.foodtype = "WOOD"
	inst.components.edible.woodiness = 0
	inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
end

AddPrefabPostInit("binggan",elemental)
AddPrefabPostInit("dangao",elemental)
AddPrefabPostInit("moshi",elemental)




----穿墙


COLLISION = GLOBAL.COLLISION

AddPrefabPostInit("warg",function(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
end)

AddPrefabPostInit("spiderqueen",function(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
end)

AddPrefabPostInit("bearger",function(inst)

    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
	inst.components.combat.notags = {"moose", "mossling","deerclops","bearger","dragonfly","beequeen"}
end)

AddPrefabPostInit("deerclops",function(inst)
	
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
		
	inst.components.combat.notags = {"moose", "mossling","deerclops","bearger","dragonfly","beequeen"}

end)



AddPrefabPostInit("moose",function(inst)
    inst.Physics:ClearCollisionMask()
	
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
	inst.components.combat.notags = {"moose", "mossling","deerclops","bearger","dragonfly","beequeen"}
end)

AddPrefabPostInit("dragonfly",function(inst)
    inst.Physics:ClearCollisionMask()

    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
	inst.components.combat.notags = {"moose", "mossling","deerclops","bearger","dragonfly","beequeen"}
end)

AddPrefabPostInit("beequeen",function(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    if inst.Physics:GetMass() > 0 then
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end
	inst.components.combat.notags = {"moose", "mossling","deerclops","bearger","dragonfly","beequeen"}
	
end)





if IsServer then
	local TUNING = _G.TUNING
	local STRINGS = _G.STRINGS
	local ACTIONS = _G.ACTIONS
	local PI = _G.PI

	local deerclops_up = GetModConfigData("deerclops_up")
	local bearger_up = GetModConfigData("bearger_up")
	local dragonfly_up = GetModConfigData("dragonfly_up")
	local moose_up = GetModConfigData("moose_up")
	local minotaur_up = GetModConfigData("minotaur_up")
	local dog_atk_warning_days = GetModConfigData("dog_atk_warning_days")
	-- 防止玩家拆毁 烧毁的蜗牛巢/猴子窝 c_spawn("slurtlehole")
	local old_ATTACK = _G.ACTIONS.ATTACK.fn
	local old_LIGHT =_G.ACTIONS.LIGHT.fn
	local old_HAMMER = _G.ACTIONS.HAMMER.fn
	_G.ACTIONS.HAMMER.fn = function(act)
		if  act.target  and act.target.prefab ~= "monkeybarrel" then
		return old_HAMMER(act)
		end	
		if  act.target  and (act.target.prefab == "monkeybarrel") 
		and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能砸")
		end
		return false
		end

	end
	_G.ACTIONS.ATTACK.fn = function(act)
		if  act.target  and act.target.prefab ~= "slurtlehole"  then
		return old_ATTACK(act)
		end	
		if  act.target  and (act.target.prefab == "slurtlehole" ) 
		and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能打")
		end
		return false
		end

	end
	_G.ACTIONS.LIGHT.fn = function(act)
		if  act.target  and act.target.prefab ~= "slurtlehole" and act.target.prefab ~= "monkeybarrel" then
		return old_LIGHT(act)
		end	
		if  act.target  and (act.target.prefab == "slurtlehole" or act.target.prefab == "monkeybarrel")  
			and not ( act.doer.Network and act.doer.Network:IsServerAdmin())then
		   if act.doer ~= nil and act.doer.components.talker then
		   act.doer.components.talker:Say("不能烧")
		   end
		return false
		end
	end
	-- 冰箱保鲜度
	TUNING.PERISH_FRIDGE_MULT = GetModConfigData("speed")
	-- 帐篷使用次数
	TUNING.TENT_USES = GetModConfigData("TentUses")
	-- 凉棚使用次数
	TUNING.SIESTA_CANOPY_USES = GetModConfigData("SiestaCanopyUses")

	if deerclops_up then
		-- 独眼巨鹿
		TUNING.DEERCLOPS_HEALTH = 8000
		TUNING.DEERCLOPS_ANGER_ATTACK_PERIOD = 2
		TUNING.DEERCLOPS_ICEPOWER_CD = 15
		TUNING.DEERCLOPS_ANGER_ICEPOWER_CD = 10
		AddPrefabPostInit("deerclops", function (inst)
			inst.powerup = true
			-- inst.entity:AddLight()
			-- inst.Light:Enable(false)
			-- inst.Light:SetIntensity(.9)
			-- inst.Light:SetColour(255 / 255, 255 / 255, 180 / 255)
			-- inst.Light:SetFalloff(0.3)
			-- inst.Light:SetRadius(12)

			inst:AddComponent("timer")
			inst.icepower_cd = TUNING.DEERCLOPS_ICEPOWER_CD

			-- 掉落
			--inst.components.lootdropper:SetChanceLootTable('deerclops')
			
			local loot = {"meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat", "deerclops_eyeball","mandrake"}
			AddLootItems(loot, {
				{
					item = "mandrake_planted", --曼德拉草
					chance = 1,
				},
				{
					item = "chesspiece_deerclops_sketch", 
					chance = 0.05,
				},
				{
					item = "mandrake", --曼德拉草
					chance = 0.33,
				},
			})
			
			if bosstobignum==2  then
			AddLootChestItems(loot)
			end
			inst.components.lootdropper:SetLoot(loot)

			AddAnger(inst, 0.2, TUNING.DEERCLOPS_ANGER_ATTACK_PERIOD, true, function(inst, oldAtkPre)
				if inst.anger then
					inst.icepower_cd = TUNING.DEERCLOPS_ANGER_ICEPOWER_CD
				else
					inst.icepower_cd = TUNING.DEERCLOPS_ICEPOWER_CD
				end
			end)
		end)
	end

	if bearger_up then
		--熊獾
		TUNING.BEARGER_HEALTH = 9000
		TUNING.BEARGER_ANGER_ATTACK_PERIOD = 2
		TUNING.BEARGER_ITEMLOST_CD = 15
		TUNING.BEARGER_ANGER_ITEMLOST_CD = 10
		AddPrefabPostInit("bearger", function (inst)
			inst.powerup = true
			inst.itemlost_cd = TUNING.BEARGER_ITEMLOST_CD
			inst.canitemlost = true

			inst.components.lootdropper:SetChanceLootTable(nil)
			local loot = {"meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat",  "bearger_fur"}
			AddLootItems(loot, {
				{
					item = "mandrake_planted", --曼德拉草
					chance = 1,
				},
				
				{
					item = "chesspiece_bearger_sketch", 
					chance = 0.05,
				},
				
				
				
				
				
				{
					item = "mandrake", --曼德拉草
					chance = 0.33,
				},
			})
			if bosstobignum==2  then
			AddLootChestItems(loot)
			end
			inst.components.lootdropper:SetLoot(loot)

			AddAnger(inst, 0.2, TUNING.BEARGER_ANGER_ATTACK_PERIOD, true, function(inst, oldAtkPre)
				if inst.anger then
					inst.itemlost_cd = TUNING.BEARGER_ANGER_ITEMLOST_CD
				else
					inst.itemlost_cd = TUNING.BEARGER_ITEMLOST_CD
				end
			end)

			local function ontimerdone(inst, data)
				if data.name == "itemlost_cd" then
					inst.canitemlost = true
					--inst.components.combat.attackrange = 25
				end
			end
			inst:ListenForEvent("timerdone", ontimerdone)

			-- local function SetGroundPounderSettings(inst, mode)
			-- 	if mode == "normal" then 
			-- 		inst.components.groundpounder.damageRings = 3
			-- 		inst.components.groundpounder.destructionRings = 4
			-- 		inst.components.groundpounder.numRings = 5
			-- 	--[[elseif mode == "hibernation" then 
			-- 		inst.components.groundpounder.damageRings = 3
			-- 		inst.components.groundpounder.destructionRings = 3
			-- 		inst.components.groundpounder.numRings = 4]]
			-- 	end
			-- end
			
			-- local function OnSeasonChange(inst, data)
			-- 	if _G.TheWorld.state.season == "autumn" or _G.TheWorld.state.season == "summer" then 
			-- 		inst:DoTaskInTime(0, function(inst)
			-- 			SetGroundPounderSettings(inst, "normal")
			-- 		end)
			-- 	end
			-- end

			-- SetGroundPounderSettings(inst, "normal")
			-- inst:WatchWorldState("season", OnSeasonChange)
			-- 冰冻抗性
			if inst.components.freezable == nil then
				inst:AddComponent("freezable")
			end
			inst.components.freezable:SetResistance(8)
		end)
	end

	if dragonfly_up then
		--龙蝇
		--TUNING.DRAGONFLY_HEALTH = 27500
		TUNING.DRAGONFLY_ANGER_ATTACK_PERIOD = 2
		AddPrefabPostInit("dragonfly", function (inst)
			inst.powerup = true
			inst.components.lootdropper:SetChanceLootTable(nil)
			local loot = AddLootItems(nil, {
				{
					item = "mandrake_planted", --曼德拉草
					chance = 1,
				},
				{
					item = "chesspiece_dragonfly_sketch", 
					chance = 0.05,
				},
				{
					item = "mandrake", --曼德拉草
					chance = 0.33,
				},
				{
					item = "dragon_scales", --火蜻蜓鳞片
					chance = 1,
				},
				{
					item = "dragonflyfurnace_blueprint", --龙鳞火炉蓝图
					chance = 1,
				},
				
				{
					item = "lavae_egg", --熔岩虫蛋
					chance = 0.33,
				},
				{
					item = "meat", --大肉
					count = 6,
					chance = 1,
				},
				{
					item = "goldnugget",
					count = 4,
					chance = 1,
				},
				{
					item = "goldnugget",
					chance = 0.5,
				},
				{
					item = "goldnugget",
					chance = 0.5,
				},
				{
					item = "goldnugget",
					chance = 0.5,
				},
				{
					item = "goldnugget",
					chance = 0.5,
				},
				{
					item = "redgem", --红色宝石
					count = 2,
					chance = 1,
				},
				{
					item = "bluegem",
					count = 2,
					chance = 1,
				},
				{
					item = "purplegem",
					chance = 1,
				},
				{
					item = "orangegem",
					chance = 1,
				},
				{
					item = "yellowgem",
					chance = 1,
				},
				{
					item = "greengem",
					chance = 1,
				},
				{
					item = "purplegem",
					chance = 0.5,
				},
				{
					item = "orangegem",
					chance = 0.5,
				},
				{
					item = "yellowgem",
					chance = 0.5,
				},
				{
					item = "greengem",
					chance = 0.5,
				},
			})
			if bosstobignum==2  then
			AddLootChestItems(loot)
			end
			inst.components.lootdropper:SetLoot(loot)

			AddAnger(inst, 0.2, TUNING.DRAGONFLY_ANGER_ATTACK_PERIOD, false)

			-- 造成范围伤害
			-- inst.components.combat:SetAreaDamage(6, 0.8)
		end)
	end

	if moose_up then
		--麋鹿鹅
		TUNING.MOOSE_HEALTH = 9000
		TUNING.MOOSE_ANGER_ATTACK_PERIOD = 2
		TUNING.MOOSE_TORNADO_CD = 20
		TUNING.MOOSE_ANGER_TORNADO_CD = 15
		TUNING.MOOSE_TORNADO_TIME = 5
		AddPrefabPostInit("moose", function (inst)
			inst.powerup = true
			inst.tornado_cd = TUNING.MOOSE_TORNADO_CD
			inst.components.lootdropper:SetChanceLootTable(nil)
			local loot = AddLootItems(nil, {
				{
					item = "mandrake_planted", --曼德拉草
					chance = 1,
				},
				{
					item = "chesspiece_moosegoose_sketch", 
					chance = 0.05,
				},
				{
					item = "mandrake", --曼德拉草
					chance = 0.33,
				},
				{
					item = "meat", --大肉
					count = 6,
					chance = 1,
				},
				{
					item = "drumstick",
					count = 2,
					chance = 1,
				},
				{
					item = "goose_feather",
					count = 3,
					chance = 1,
				},
				{
					item = "goose_feather",
					chance = 0.33,
				},
				{
					item = "goose_feather",
					chance = 0.33,
				},
			})
			if bosstobignum==2  then
			AddLootChestItems(loot)
			end
			inst.components.lootdropper:SetLoot(loot)

			AddAnger(inst, 0.2, TUNING.MOOSE_ANGER_ATTACK_PERIOD, true, function(inst, oldAtkPre)
				if inst.anger then
					inst.tornado_cd = TUNING.MOOSE_ANGER_TORNADO_CD
					inst.sg:GoToState("layegg2")
				else
					inst.tornado_cd = TUNING.MOOSE_TORNADO_CD
				end
			end)

			local function OnAttacked(inst, data)
				inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("mossling") end, 10)
				-- if inst.components.freezable and inst.components.freezable:IsFrozen() then
				-- 	inst.components.health:DoDelta(-55, false, "freeze")
				-- end
			end
			inst:ListenForEvent("attacked", OnAttacked)

			-- 造成范围伤害
			-- inst.components.combat:SetAreaDamage(6, 0.8)
			-- 不攻击同类
			inst.components.combat.notags = {"moose", "mossling"}
			function inst.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
				local hitcount = 0
				local x, y, z = target.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, { "INLIMBO", "mossling" }) ----AOE伤害忽略小鸭子
				for i, ent in ipairs(ents) do
					if ent ~= target and
						ent ~= self.inst and
						self:IsValidTarget(ent) and
						(validfn == nil or validfn(ent)) then
						self.inst:PushEvent("onareaattackother", { target = ent, weapon = weapon, stimuli = stimuli })
						ent.components.combat:GetAttacked(self.inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli)
						hitcount = hitcount + 1
					end
				end
				return hitcount
			end

			-- 免疫雷电
			inst.components.burnable.lightningimmune = true
		end)

		-- 鸭蛋
		AddPrefabPostInit("mooseegg", function (inst)
			inst.powerup = true

			local function OnLightning(inst, data)
				if not inst.EggHatched then
					if inst.sg:HasStateTag("egg") then
						inst.sg:GoToState("crack")
					end
				end
			end

			local function OnAttacked(inst, data)
				inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("moose") end, 10)
				-- if inst.components.freezable and inst.components.freezable:IsFrozen() then
				-- 	inst.components.health:DoDelta(-55, false, "freeze")
				-- end
			end
			inst:ListenForEvent("attacked", OnAttacked)

			-- 吸引雷电优先级
			inst.lightningpriority = 2
			inst:ListenForEvent("lightningstrike", OnLightning)
		end)

		-- 小鸭子
		AddPrefabPostInit("mossling", function (inst)
			inst.powerup = true

			local SEE_DIST = 40
			local TARGET_DIST = 6
			local function RetargetFn(inst)
				return FindEntity(inst, TARGET_DIST, function(guy)
					return inst.components.combat:CanTarget(guy)
				end,
				nil,
				{ "prey", "smallcreature", "mossling", "moose" },
				{ "monster", "player"})
			end

			inst.components.combat:SetRetargetFunction(1.5, RetargetFn)
			-- 不攻击同类
			inst.components.combat.notags = {"moose", "mossling"}
			-- 免疫雷电
			--inst.components.burnable.lightningimmune = true

			local old_CreateHerd = inst.components.herdmember.CreateHerd
			function inst.components.herdmember:CreateHerd()
				if self.enabled and not self.herd then
					local findEgg = FindEntity(inst, SEE_DIST, function(guy)
						return guy.prefab == "mooseegg"
					end,
					nil,
					{ "INLIMBO", "NOCLICK" })

					if findEgg ~= nil then
						inst.components.herdmember.herd = findEgg
					else
						old_CreateHerd(self)
					end
				end
			end
		end)
	end

	if minotaur_up then
		--远古守护者
		--TUNING.DRAGONFLY_HEALTH = 27500
		TUNING.MINOTAUR_ANGER_ATTACK_PERIOD = 1
		AddPrefabPostInit("minotaur", function (inst)
			inst.powerup = true
			inst:AddTag("chess")

			AddAnger(inst, 0.2, TUNING.MINOTAUR_ANGER_ATTACK_PERIOD, false)

			local function GetAllies(inst)
				local inst_pos = inst:GetPosition()

				if inst_pos.y > 2 then
					local fx = SpawnPrefab("statue_transition_2")
					if fx then
						fx.Transform:SetPosition(inst_pos:Get())
						fx.Transform:SetScale(3,4.5,3)
					end

					local theta = math.random() * 2 * PI
					local offset = FindWalkableOffset(inst_pos, theta, 10, 5)

					if offset ~= nil then
						inst_pos.x = inst_pos.x + offset.x
						inst_pos.y = 0
						inst_pos.z = inst_pos.z + offset.z
						inst.Transform:SetPosition(inst_pos:Get())
					end
				end

				local allies = TheSim:FindEntities(inst_pos.x, inst_pos.y, inst_pos.z, 30, {"chess"}, {"mech", "minotaur"})
				for k,v in pairs(allies) do
					if v.components.follower and not v.components.follower.leader and not inst.components.leader:IsFollower(v) and                     
                        inst.components.leader.numfollowers < 4 then
						v.components.follower:SetLeader(inst)
					end

					local pos = v:GetPosition()
					if not _G.TheWorld.Map:IsAboveGroundAtPoint(pos:Get()) then
						local fx = SpawnPrefab("spawn_fx_medium")
						if fx then
							fx.Transform:SetPosition(pos:Get())
						end
						v.Transform:SetPosition(inst_pos:Get())
					end
				end
			end

			local function RemoveForcefield(inst, data)
				local pos = inst:GetPosition()
				local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20, {"chess"}, {"mech", "minotaur"})
				if inst:HasTag("invincible") and #ents < 1 then
					inst.components.health:SetInvincible(false)
					inst:RemoveTag("invincible")
					if inst._fx then
						local forcefield = inst._fx:GetTimeAlive()
						inst.components.health:DoDelta(5 * forcefield, false, "forcefieldfx")
						inst._fx:kill_fx()
						inst._fx = nil
					end
				end
			end

			local function TryForcefield(inst, data)
				local pos = inst:GetPosition()
				local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20, {"chess"}, { "mech", "minotaur" })
				if #ents >= 3 then
					if not inst:HasTag("invincible") then
						inst:AddTag("invincible")
						inst.components.health:SetInvincible(true)
						if inst._fx ~= nil then
							inst._fx:kill_fx()
						end
						inst._fx = SpawnPrefab("forcefieldfx")
						inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
						inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
						inst._fx.entity:SetParent(inst.entity)
						inst._fx.Transform:SetPosition(0, -1.5, 0)
						inst._fx.Transform:SetScale(3, 3, 3)
					end
				end
			end

			inst:AddComponent("leader")
			inst:DoPeriodicTask(0.1, GetAllies)
			inst:DoPeriodicTask(0.1, TryForcefield)
			inst:DoPeriodicTask(0.1, RemoveForcefield)

			-- 清理沿途撞到的额外的物品
			inst.onhxcollide = function(inst, other)
				if other:IsValid() and other:HasTag("wall") and other.components.workable ~= nil and other.components.workable:CanBeWorked() and               other.components.workable.action ~= ACTIONS.NET then
					other:Remove()
				end
			end

			-- 造成范围伤害
			-- inst.components.combat:SetAreaDamage(6, 0.8)
			-- 不攻击属下
			inst.components.combat.notags = {"chess"}
		end)
	end

	--nice round function
	local round2 = function(num, idp)
		return _G.tonumber(string.format("%." .. (idp or 0) .. "f", num))
	end

	--毒菇洞
	AddComponentPostInit("toadstoolspawner",function(ToadsToolSpawner, inst)
		--Private
		local _spawners = {}
		local function RespawnTimeAnnounce(data, lastattacker)
			if data ~= nil then
				if data.timetorespawn ~= nil then
					local days = data.timetorespawn / TUNING.TOTAL_DAY_TIME
					TheNet:Announce("〖 "..STRINGS.NAMES.TOADSTOOL.." 〗".. (lastattacker and "被〖 "..lastattacker.name.." 〗击杀" or "") .."将在"..round2(days,1).."天后刷新")
				end
			end
		end

		local function TaskRespawnTimeAnnounce(inst, toadstool)
			local lastattacker = nil
			if toadstool ~= nil and type(toadstool) ~= "number" then
				lastattacker = toadstool.components.combat and toadstool.components.combat.lastattacker
			end
			inst:DoTaskInTime(0, function(inst)
				RespawnTimeAnnounce(ToadsToolSpawner:OnSave(), lastattacker)
			end)
		end

		local OldOnLoad = ToadsToolSpawner.OnLoad
		function ToadsToolSpawner:OnLoad(data)
			if OldOnLoad ~= nil then
				OldOnLoad(self, data)
			end
			RespawnTimeAnnounce(data)
		end

		inst:ListenForEvent("ms_registertoadstoolspawner", function(inst, spawner)
			for i, v in ipairs(_spawners) do
				if v == spawner then
					return
				end
			end

			table.insert(_spawners, spawner)
			inst:ListenForEvent("toadstoolstatechanged", TaskRespawnTimeAnnounce, spawner)
			inst:ListenForEvent("toadstoolkilled", TaskRespawnTimeAnnounce, spawner)
		end)
	end)

	AddPrefabPostInit("toadstool_cap", function (inst)
		inst:ListenForEvent("ms_spawntoadstool", function(inst)
			TheNet:Announce("〖 "..inst:GetDisplayName().." 〗已刷新")
		end)
	end)

	if dog_atk_warning_days > 0 then
		-- 猎犬袭击
		AddPrefabPostInit("world", function(inst)
			if inst:HasTag("cave") then return end
			inst:ListenForEvent("cycleschanged", function(inst, data)
				if not _G.TheWorld.components.hounded then
					return
				end
				
				local _timeToAttack = _G.TheWorld.components.hounded:GetTimeToAttack()
				local days = _timeToAttack / TUNING.TOTAL_DAY_TIME

				if days >= 0 and days <= dog_atk_warning_days and _G.TheWorld.state.cycles ~= 0 then
					local dogMsg = "〖 猎犬袭击 〗将在"..round2(days,1).."天后发动"
					for i, v in ipairs(_G.AllPlayers) do
						PlayerSay(v, dogMsg)
					end
					-- TheNet:Announce("〖 猎犬袭击 〗将在"..round2(days,1).."天后发动")
				end
				
				-- print("猎犬袭击时间: " .. _timeToAttack)
			end)
		end)
	end
end