local require = GLOBAL.require
local SpawnPrefab = GLOBAL.SpawnPrefab
local COLLISION = GLOBAL.COLLISION
local next = GLOBAL.next
local TheWorld = GLOBAL.TheWorld
local SpringCombatMod = GLOBAL.SpringCombatMod
local FindEntity = GLOBAL.FindEntity
local TheSim = GLOBAL.TheSim

local POOP_BOMB_DELAY = 3 --大便炸弹定时时间
local POOP_BOMB_RANG = 4 --大便炸弹爆炸范围
local POOP_BOMB_DIST = 18 --扔大便炸弹的距离
local PIGKING_HEALTH = 1000
--require "rp_utils"
--local werebeast = require "components/werebeast"

local function addExpTag(inst, exp_level)
	if exp_level == 1 then
		inst:AddTag("exp_level_1")
	elseif exp_level == 2 then
		inst:AddTag("exp_level_2")
	elseif exp_level == 3 then
		inst:AddTag("exp_level_3")
	elseif exp_level == 4 then
		inst:AddTag("exp_level_4")
	elseif exp_level == 5 then
		inst:AddTag("exp_boss_1")
	elseif exp_level == 6 then
		inst:AddTag("exp_boss_2")
	elseif exp_level == 7 then
		inst:AddTag("exp_boss_3")
	elseif exp_level == 8 then
		inst:AddTag("exp_boss_4")	
	end
end

local exp_level_1 = { --小型生物
"bat",
"killerbee",
"rabbit",
"perd",
"crow",
"robin",
"robin_winter",
"butterfly",
"bee",
"frog",
"babybeefalo",
"smallbird",
"penguin",
"mole",
"catcoon",
"birchnutdrake",
"mosquito",
}

local exp_level_2 = { 
"spider",
"lightninggoat",
"hound",
"little_walrus",
"monkey",
"slurper",
"buzzard",
"pigman",
"pigguard",
"bunnyman",
"merm",
"rocky",
}

local exp_level_3 = {
"spider_hider",
"spider_spitter",
"spider_warrior",
"spider_dropper",
"firehound",
"icehound",
"koalefant_summer",
"koalefant_winter",
"slurtle",
"snurtle",
"krampus",
}

local exp_level_4 = {
"beefalo",
"tallbird",
"walrus",
"knight",
"bishop",
"tentacle",
"worm",
"mossling",
}

local exp_boss_1 = { --普通boss
"leif",
"leif_sparse",
"rook",
"warg",
"spat",
"spiderqueen",
}

local exp_boss_2 = { --自定义boss

}

local exp_boss_3 = { --季节boss
"deerclops",
"bearger",
"moose",
}

local exp_boss_4 = { --世界boss
"minotaur",
"dragonfly",
}

local function canBeKilled(inst)

	local item = "trinket_"..tostring(math.random(1, 7))
	local item2 = "trinket_"..tostring(math.random(1, 7))
	local item3 = "trinket_"..tostring(math.random(1, 7))
	
	inst:ListenForEvent("attacked", OnAttackedPig)
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(PIGKING_HEALTH)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({
		"goldnugget", "goldnugget", "goldnugget", "goldnugget", 
		"pigskin", "meat", "meat", "meat"
	})
			
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body"
	
	inst:ListenForEvent("healthdelta", function(inst, data)
		if data.newpercent < data.oldpercent then
			inst.AnimState:PlayAnimation("unimpressed")
			inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingReject")
		end
	end)
	
	inst:ListenForEvent("healthdelta", function(inst, data)
		if data.newpercent == 0 then
			inst.AnimState:PlayAnimation("sleep_pre")
			inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingReject")
		end
	end)	

	inst:ListenForEvent("death", function(inst)
		
		---TheWorld:PushEvent("rp_pigkingbekilled")
		print("猪王死了1！！！")
		
		inst.components.lootdropper:DropLoot()  
		inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
		
		if item then
			inst.components.lootdropper:SpawnLootPrefab(item)
			inst.components.lootdropper:SpawnLootPrefab(item2)
			inst.components.lootdropper:SpawnLootPrefab(item3)
		end		
	end)
	
	inst:AddComponent("rp_pushevent")
	
end

--让猪王可杀
---AddPrefabPostInit("pigking", canBeKilled)

--为怪物添加经验值
for _,v in ipairs(exp_level_1) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst, 1) end)
	end
end

for _,v in ipairs(exp_level_2) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst,2) end)
	end
end

for _,v in ipairs(exp_level_3) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst,3) end)
	end
end

for _,v in ipairs(exp_level_4) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst,4) end)
	end
end

for _,v in ipairs(exp_boss_1) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst,5) end)
	end
end

for _,v in ipairs(exp_boss_2) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst,6) end)
	end
end

for _,v in ipairs(exp_boss_3) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst,7) end)
	end
end

for _,v in ipairs(exp_boss_4) do
	if v then
		AddPrefabPostInit(v, function(inst) addExpTag(inst,8) end)
	end
end

local function KillerRetarget(inst)
    return FindEntity(inst, SpringCombatMod(8),
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "_combat", "_health" },
        { "insect", "INLIMBO", "rp_monster"},
        { "character", "animal", "monster" })
end

--不要攻击怪物
AddPrefabPostInit("killerbee", function(inst)
	if inst.components.combat then
		inst.components.combat:SetRetargetFunction(2, KillerRetarget)
	end
end)

AddPrefabPostInit("deciduous_root", function(inst)
	if inst.components.combat then
		function inst.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
			local hitcount = 0
			local x, y, z = target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, {"rp_monster", "shadowboss", "hostile"})			
			for i, ent in ipairs(ents) do
				if ent ~= target and
					ent ~= inst and
					self:IsValidTarget(ent) and
					(validfn == nil or validfn(ent)) then
					inst:PushEvent("onareaattackother", { target = target, weapon = weapon, stimuli = stimuli })
					ent.components.combat:GetAttacked(inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli)
					hitcount = hitcount + 1
				end
			end
			return hitcount
		end	
	end
end)

--我的猪不会疯
AddComponentPostInit("werebeast", function(self, inst)
	self.OriginalSetWere = self.SetWere
	self.OriginalSetNormal = self.SetNormal
	
	function self:SetWere(time)
		if not self.inst:HasTag("rp_monster") then
			return self:OriginalSetWere(time)
		end
	end
	
	function self:SetNormal()
		if not self.inst:HasTag("rp_monster") then
			return self:OriginalSetNormal()
		end
	end
	
end)

local function onBomb(inst)
	--print(inst.prefab.."--onBomb!!!!!!!!!!")
	GLOBAL.ShakeAllCameras(GLOBAL.CAMERASHAKE.SIDE, .6, .06, .6, inst, 15)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, POOP_BOMB_RANG)
	if next(ents) ~= nil then
		for _,obj in pairs(ents) do
			if obj and obj.components.pinnable then
				obj.components.pinnable:Stick()
			end
		end
	end
end

local function OnHit_piggurad(inst, owner, target)
	if target.components.sanity ~= nil then
		target.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
	end
	--if target.components.health and not target.components.health:IsDead() then
	--	if target.components.combat ~= nil then
	--		target.components.combat:GetAttacked(inst, 5, nil)
	--	end
		--target.components.health:DoDelta(-2, false, "lightning")
	--end
	
	--local r, g, b = GLOBAL.HexToPercentColor("#E71F14")
	--设置颜色
	--item.AnimState:SetMultColour(r, g, b, 1)
	--MakeObstaclePhysics(item, 1)
	local item = SpawnPrefab("poop")
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())
	item:AddTag("poop_bomb")
	GLOBAL.MakeObstaclePhysics(item, 0.3)
	--item:DoTaskInTime(2)
	
	item:DoTaskInTime(3,function()
		item.Physics:SetCollisionCallback(function(inst, other)
			if other.components.pinnable ~= nil then
				other.components.pinnable:Stick()
				inst:Remove()
			end
		end)
	end)
	
	item:AddComponent("rp_autodelete")
	item.components.rp_autodelete:SetPerishTime(POOP_BOMB_DELAY)
	item.components.rp_autodelete:StartPerishing()
	item:ListenForEvent("rp_poop_bomb", onBomb)
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/monkey/poopsplat")
	target:PushEvent("attacked", {attacker = owner, damage = 0})
	inst:Remove()
end

local function OnMiss_piggurad(inst, owner, target)
--SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
	local item = SpawnPrefab("poop")
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())
	item:AddTag("poop_bomb")
	GLOBAL.MakeObstaclePhysics(item, 0.8)
	item.Physics:SetCollisionCallback(function(inst, other)
		if other.components.pinnable ~= nil then
			other.components.pinnable:Stick()
			if other.components.talker then
				other.components.talker:Say("这屎里有毒！！！")
			end
			inst:Remove()
		end
	end)
	item:AddComponent("rp_autodelete")
	item.components.rp_autodelete:SetPerishTime(POOP_BOMB_DELAY)
	item.components.rp_autodelete:StartPerishing()
	item:ListenForEvent("rp_poop_bomb", onBomb)
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/monkey/poopsplat")
	inst:Remove()
end


--远程武器效果修改，避免写新的prefab，因为我懒。。
AddComponentPostInit("weapon", function(self, inst)
	self.OriginalLaunchProjectile = self.LaunchProjectile
	if GLOBAL.TheWorld.ismastersim == false then return; end
	
	function self:LaunchProjectile(attacker, target)
		if attacker:HasTag("pointed_monster_king") then
			if attacker.prefab == "merm" then
				if self.projectile then
					if self.onprojectilelaunch then
						self.onprojectilelaunch(self.inst, attacker, target)
					end
					
					local proj = SpawnPrefab(self.projectile)
					--------------------------
					if proj then
						inst:AddTag("projectile")
						proj.persists = false
						proj:AddComponent("projectile")
						proj.components.projectile:SetSpeed(25)
						proj.components.projectile:SetHoming(false)
						proj.components.projectile:SetHitDist(0.8)
						proj.components.projectile:SetOnHitFn(function()
							local x1, y1, z1 = proj.Transform:GetWorldPosition()
							local ents = TheSim:FindEntities(x1, y1, z1, 5, { "player" })
							for _,obj in pairs(ents) do
								if obj and obj:HasTag("player") and obj.components.freezable then 
									obj.components.freezable:AddColdness(2)
									obj.components.freezable:SpawnShatterFX()
								end
							end
							proj:Remove()
						end)
						proj.components.projectile:SetOnMissFn(proj.Remove)
						proj.components.projectile:SetOnThrownFn(function() proj:ListenForEvent("entitysleep", proj.Remove) end)
						local currentscale = proj.Transform:GetScale()
						proj.Transform:SetScale(currentscale*1,currentscale*8,currentscale*1)
						proj:DoPeriodicTask(.1, function()
							if proj then
								local x, y, z = proj.Transform:GetWorldPosition()
								local fx = SpawnPrefab("icespike_fx_"..math.random(1,4))
								local currentscale = fx.Transform:GetScale()
								fx.Transform:SetScale(currentscale*1.5,currentscale*4,currentscale*1.5)
								fx.Transform:SetPosition(x, y, z)
							end
						end)
	
						proj:DoTaskInTime(1, function()
							proj:Remove()
						end)
						-----------------------
						if proj.components.projectile then
							proj.Transform:SetPosition(attacker.Transform:GetWorldPosition() )
							proj.components.projectile:Throw(self.inst, target, attacker)
						elseif proj.components.complexprojectile then
							proj.Transform:SetPosition( attacker.Transform:GetWorldPosition() )
							proj.components.complexprojectile:Launch(Vector3( target.Transform:GetWorldPosition() ), attacker, self.inst)
						end
					end
				end
				return nil
			elseif attacker.prefab == "pigguard" then
				if self.projectile then
					if self.onprojectilelaunch then
						self.onprojectilelaunch(self.inst, attacker, target)
					end
					
					local proj = SpawnPrefab(self.projectile)
					--------------------------
					if proj then
						proj.AnimState:SetBank("monkey_projectile")
						proj.AnimState:SetBuild("monkey_projectile")
						proj.AnimState:PlayAnimation("idle")
						local currentscale = proj.Transform:GetScale()
						proj.Transform:SetScale(currentscale*1.5,currentscale*1.5,currentscale*1.5)
						inst:AddTag("projectile")
						proj.persists = false
						proj:AddComponent("projectile")
						proj.components.projectile:SetSpeed(18)
						proj.components.projectile:SetHoming(false)
						proj.components.projectile:SetHitDist(0.3)
						proj.components.projectile.range = POOP_BOMB_DIST
						proj.components.projectile:SetOnThrownFn(function() proj:ListenForEvent("entitysleep", proj.Remove) end)
						proj.components.projectile:SetOnHitFn(OnHit_piggurad)
						proj.components.projectile:SetOnMissFn(OnMiss_piggurad)
						
						-----------------------
						if proj.components.projectile then
							proj.Transform:SetPosition(attacker.Transform:GetWorldPosition() )
							proj.components.projectile:Throw(self.inst, target, attacker)
						elseif proj.components.complexprojectile then
							proj.Transform:SetPosition( attacker.Transform:GetWorldPosition() )
							proj.components.complexprojectile:Launch(Vector3( target.Transform:GetWorldPosition() ), attacker, self.inst)
						end
					end
				end
				return nil
			end

		end
		
		return self:OriginalLaunchProjectile(attacker, target)
		
	end
end)
