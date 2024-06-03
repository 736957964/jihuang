
--定义GLOBAL变量

local TheNet = GLOBAL.TheNet
local SpawnPrefab = GLOBAL.SpawnPrefab
local TheWorld = GLOBAL.TheWorld
local Point = GLOBAL.Point
local TUNING = GLOBAL.TUNING
local require = GLOBAL.require
local AllPlayers = GLOBAL.AllPlayers
local SpawnPrefab = GLOBAL.SpawnPrefab
local COLLISION = GLOBAL.COLLISION
local CreateEntity = GLOBAL.CreateEntity
local MakeInventoryPhysics = GLOBAL.MakeObstaclePhysics
local MakeCharacterPhysics = GLOBAL.MakeCharacterPhysics
local MakeObstaclePhysics = GLOBAL.MakeObstaclePhysics
local MakeLargeBurnableCharacter = GLOBAL.MakeLargeBurnableCharacter
local MakeHugeFreezableCharacter = GLOBAL.MakeHugeFreezableCharacter
local IsServer = TheNet:GetIsServer()

--巨鹿眼球可交换
AddPrefabPostInit("deerclops_eyeball", function(inst)
	if IsServer then
		inst:AddComponent("tradable")
	end
end)
-------------远古守卫者
AddPrefabPostInit("minotaurhorn", function(inst)
	if IsServer then
		inst:AddComponent("tradable")
	end
end)
------鳞片
AddPrefabPostInit("dragon_scales", function(inst)
	if IsServer then
		inst:AddComponent("tradable")
	end
end)
------------熊皮
AddPrefabPostInit("bearger_fur", function(inst)
	if IsServer then
		inst:AddComponent("tradable")
	end
end)






--挑战书以传送机零件为载体
function FY_book_init(inst)
	inst.AnimState:SetBank("papyrus")
	inst.AnimState:SetBuild("papyrus")
	inst.AnimState:PlayAnimation("idle")
	inst.components.inventoryitem:ChangeImageName("papyrus")
	
	inst:AddTag("FY_book")
	
	--雷夫挑战书
	if inst.challenge_type == "leif" then
		inst.components.named:SetName("雷夫挑战书")
		inst.components.inspectable:SetDescription("给猪王可以获得挑战雷夫boss的资格")
	elseif inst.challenge_type == "bearger" then	
		inst.components.named:SetName("巨熊挑战书")
		inst.components.inspectable:SetDescription("给猪王可以获得挑战巨熊boss的资格")
	elseif inst.challenge_type == "dragonfly" then	
		inst.components.named:SetName("龙蝇挑战书")
		inst.components.inspectable:SetDescription("给猪王可以获得挑战龙蝇boss的资格")
    elseif inst.challenge_type == "minotaur" then	
		inst.components.named:SetName("守卫者挑战书")
		inst.components.inspectable:SetDescription("给猪王可以获得挑战守卫者boss的资格")
	end
	
end
AddPrefabPostInit("teleportato_ring", function(inst)
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				FY_book_init(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
			end
		end
	end
end)

--桃木剑以暗影剑为载体
function FY_sword_init(inst)
	inst:AddTag("FY_weapon")	
	if inst.challenge_type == 1 then
		inst.components.named:SetName("暗影桃木剑")		
		inst.components.weapon:SetDamage(60)
		if inst.components.finiteuses then
			inst:RemoveComponent("finiteuses")
		end
		inst.components.equippable:SetOnEquip(function (inst, owner)
			owner.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword", "swap_nightmaresword")
			owner.AnimState:Show("ARM_carry") 
			owner.AnimState:Hide("ARM_normal") 
			if inst.fires == nil then
				inst.fires = SpawnPrefab("torchfire")
				inst.fires.entity:SetParent(owner.entity)
				inst.fires.entity:AddFollower()
				inst.fires.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -110, 0)
			end
		end)
		inst.components.equippable:SetOnUnequip(function(inst, owner) 
			owner.AnimState:Hide("ARM_carry") 
			owner.AnimState:Show("ARM_normal") 
			if inst.fires ~= nil then
				inst.fires:Remove()
				inst.fires = nil
			end
		end)
		inst.components.equippable.dapperness = 0
	end
end
AddPrefabPostInit("nightsword", function(inst)
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				--FY_sword_init(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
			end
		end
	end
end)

--专属箱子以犀牛箱子为载体
function FY_chest_init(inst)
	inst:AddTag("FY_chest")	
	if inst.challenge_type == 0 then
		inst.components.named:SetName("雷夫宝箱")
		--不是召唤者就无法打开箱子
		inst:ListenForEvent("onopen", function(inst, data)		
			for k,v in pairs(AllPlayers) do
				if v and v.GUID == inst.fy_summon_id then
					inst.fy_summon = v
					break
				end
			end
		
			local doer = data.doer
			if doer ~= inst.fy_summon then
				inst:DoTaskInTime(0, function()
					inst.components.container:Close()
					if doer.components.talker then
						local summonstr = inst.fy_summon and inst.fy_summon:GetDisplayName()
						doer.components.talker:Say("接任务的不是我, 是 "..summonstr)
					end
				end)
			end
		end)
	end
	
	
	if inst.challenge_type == 1 then
		inst.components.named:SetName("巨熊宝箱")
		--不是召唤者就无法打开箱子
		inst:ListenForEvent("onopen", function(inst, data)		
			for k,v in pairs(AllPlayers) do
				if v and v.GUID == inst.fy_summon_id then
					inst.fy_summon = v
					break
				end
			end
		
			local doer = data.doer
			if doer ~= inst.fy_summon then
				inst:DoTaskInTime(0, function()
					inst.components.container:Close()
					if doer.components.talker then
						local summonstr = inst.fy_summon and inst.fy_summon:GetDisplayName()
						doer.components.talker:Say("接任务的不是我, 是 "..summonstr)
					end
				end)
			end
		end)
	end
	
	
	
	
	
	
	
end
AddPrefabPostInit("minotaurchest", function(inst)
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				FY_chest_init(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
				data.burnt = true
			end
			data.challenge_type = inst.challenge_type
			data.fy_summon = inst.fy_summon
		end
		inst.OnPreLoad = function(inst, data)
			if data ~= nil and data.burnt then
				inst.components.burnable.onburnt(inst)
			end
			if data then
				inst.challenge_type = data.challenge_type
				inst.fy_summon = data.fy_summon
			end
		end
	end
end)

--雷夫boss以雷夫为载体
function FY_leif_init(inst)
	inst:AddTag("FY_boss")
	inst:ListenForEvent("attacked", function (inst, data)
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("leif") and not dude.components.health:IsDead() end, 5)
	end)
	if inst.challenge_type == 0 then       --------------这里必须等于0
		inst.components.named:SetName("超级雷夫")
		inst.components.inspectable:SetDescription("它不是普通的树精")
		inst.Transform:SetScale(2.5,2.5,2.5)
		inst.components.health:SetMaxHealth(100000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5/2
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				--SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
		inst.fy_time_live = 0
		
		----没有目标则消失
		inst:DoPeriodicTask(1, function()
			if inst.components.combat.target == nil then
				inst.fy_time_live = inst.fy_time_live + 1
			else
				inst.fy_time_live = 0	--有目标则重新计时
			end
			if inst.fy_time_live >= 5 * 60 then
				inst:Remove()
			end
		end)
		
		
		inst.yunshi_task1 = inst:DoPeriodicTask(10, function()
			local offset = {x = math.random()*6-3, z = math.random()*6-3}
			local target = inst.components.combat.target
			local x1,y1,z1 = inst.Transform:GetWorldPosition()
			local fx = SpawnPrefab("shadowmeteor")
			fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
			fx.challenge_type = 1
		end)
		
		inst:ListenForEvent("healthdelta", function(inst, data)
			local oldpercent = data.oldpercent
			local newpercent = data.newpercent
			if oldpercent > .75 and newpercent <= .75 and newpercent > .5 then
				local x,y,z = inst.Transform:GetWorldPosition()
				local leif1 = SpawnPrefab("leif")
				leif1.Transform:SetPosition(x,y,z)
				leif1.challenge_type = 1
				FY_leif_init(leif1)
			elseif oldpercent > .5 and newpercent <= .5 and newpercent > .25 then
				if inst.yunshi_task1 ~= nil then
					inst.yunshi_task1:Cancel()
					inst.yunshi_task1 = nil
				end
				inst.yunshi_task2 = inst:DoPeriodicTask(5, function()
					for k = 1, 2 do
						local offset = {x = math.random()*6-3, z = math.random()*6-3}
						local target = inst.components.combat.target
						local x1,y1,z1 = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("shadowmeteor")
						fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
						fx.challenge_type = 1
					end
				end)
			elseif oldpercent > .25 and newpercent <= .25 then
				local x,y,z = inst.Transform:GetWorldPosition()
				
				local leif2 = SpawnPrefab("leif")
				leif2.Transform:SetPosition(x,y,z)
				leif2.challenge_type = 2
				FY_leif_init(leif2)
				
				local leif3 = SpawnPrefab("leif")
				leif3.Transform:SetPosition(x,y,z)
				leif3.challenge_type = 3
				FY_leif_init(leif3)
				
				local leif4 = SpawnPrefab("leif")
				leif4.Transform:SetPosition(x,y,z)
				leif4.challenge_type = 4
				FY_leif_init(leif4)
				
			end
		end)
		
	elseif inst.challenge_type == 1 then
		inst.components.named:SetName("雷夫侍卫")
		inst.components.inspectable:SetDescription("超级雷夫的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
	elseif inst.challenge_type == 2 then
		inst.components.named:SetName("雷夫侍卫")
		inst.components.inspectable:SetDescription("超级雷夫的贴身侍卫")
		inst.components.health:SetMaxHealth(2000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
	
	elseif inst.challenge_type == 3 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("雷夫侍卫")
		inst.components.inspectable:SetDescription("超级雷夫的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5 / .75
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target.components.burnable then
				if target.xiana_task == nil then
					target.components.burnable:SpawnFX()
					target.xiana_task = target:DoPeriodicTask(1, function()
						target.components.health:DoDelta(-2 * target.components.health.fire_damage_scale )
					end)
					target:DoTaskInTime(10, function()
						if target.xiana_task ~= nil then
							target.xiana_task:Cancel()
							target.xiana_task = nil
							target.components.burnable:KillFX()
						end
					end)
				end
			end
		end)
	
	elseif inst.challenge_type == 4 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("雷夫侍卫")
		inst.components.inspectable:SetDescription("超级雷夫的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5 / .75
		
		inst.fy_attack_tick = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target then
				if inst.fy_attack_tick == 1 then
					if target.components.locomotor then
						target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", .5)
						target:DoTaskInTime(5, function()
							target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", 1)
						end)
					end
					inst.fy_attack_tick = 2
				elseif inst.fy_attack_tick == 2 then
					if target.components.freezable then
						target.components.freezable:AddColdness(2)
						target.components.freezable:SpawnShatterFX()
					end
					inst.fy_attack_tick = 1
				end
			end
		end)
	
	end
end


--巨熊boss以巨熊为载体
function FY_bearger_init(inst)
	inst:AddTag("FY_boss")
	inst:ListenForEvent("attacked", function (inst, data)
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("bearger") and not dude.components.health:IsDead() end, 5)
	end)
	if inst.challenge_type == 0 then   -------------------等于0
		inst.components.named:SetName("超级巨熊")
		inst.components.inspectable:SetDescription("它不是普通的熊")
		inst.Transform:SetScale(2.5,2.5,2.5)
		inst.components.health:SetMaxHealth(100000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5/2
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				---SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
		inst.fy_time_live = 0
		
		----没有目标则消失
		inst:DoPeriodicTask(1, function()
			if inst.components.combat.target == nil then
				inst.fy_time_live = inst.fy_time_live + 1
			else
				inst.fy_time_live = 0	--有目标则重新计时
			end
			if inst.fy_time_live >= 5 * 60 then
				inst:Remove()
			end
		end)
		
		
		inst.yunshi_task1 = inst:DoPeriodicTask(10, function()
			local offset = {x = math.random()*6-3, z = math.random()*6-3}
			local target = inst.components.combat.target
			local x1,y1,z1 = inst.Transform:GetWorldPosition()
			local fx = SpawnPrefab("shadowmeteor")
			fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
			fx.challenge_type = 1
		end)
		
		inst:ListenForEvent("healthdelta", function(inst, data)
			local oldpercent = data.oldpercent
			local newpercent = data.newpercent
			if oldpercent > .75 and newpercent <= .75 and newpercent > .5 then
				local x,y,z = inst.Transform:GetWorldPosition()
				local leif1 = SpawnPrefab("bearger")
				leif1.Transform:SetPosition(x,y,z)
				leif1.challenge_type = 1
				FY_leif_init(leif1)
			elseif oldpercent > .5 and newpercent <= .5 and newpercent > .25 then
				if inst.yunshi_task1 ~= nil then
					inst.yunshi_task1:Cancel()
					inst.yunshi_task1 = nil
				end
				inst.yunshi_task2 = inst:DoPeriodicTask(5, function()
					for k = 1, 2 do
						local offset = {x = math.random()*6-3, z = math.random()*6-3}
						local target = inst.components.combat.target
						local x1,y1,z1 = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("shadowmeteor")
						fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
						fx.challenge_type = 1
					end
				end)
			elseif oldpercent > .25 and newpercent <= .25 then
				local x,y,z = inst.Transform:GetWorldPosition()
				
				local leif2 = SpawnPrefab("bearger")
				leif2.Transform:SetPosition(x,y,z)
				leif2.challenge_type = 2
				FY_leif_init(leif2)
				
				local leif3 = SpawnPrefab("bearger")
				leif3.Transform:SetPosition(x,y,z)
				leif3.challenge_type = 3
				FY_leif_init(leif3)
				
				local leif4 = SpawnPrefab("bearger")
				leif4.Transform:SetPosition(x,y,z)
				leif4.challenge_type = 4
				FY_leif_init(leif4)
				
			end
		end)
		
	elseif inst.challenge_type == 1 then
		inst.components.named:SetName("巨熊侍卫")
		inst.components.inspectable:SetDescription("超级巨熊的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
	elseif inst.challenge_type == 2 then
		inst.components.named:SetName("巨熊侍卫")
		inst.components.inspectable:SetDescription("超级巨熊的贴身侍卫")
		inst.components.health:SetMaxHealth(2000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
	
	elseif inst.challenge_type == 3 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("巨熊侍卫")
		inst.components.inspectable:SetDescription("超级巨熊的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5 / .75
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target.components.burnable then
				if target.xiana_task == nil then
					target.components.burnable:SpawnFX()
					target.xiana_task = target:DoPeriodicTask(1, function()
						target.components.health:DoDelta(-2 * target.components.health.fire_damage_scale )
					end)
					target:DoTaskInTime(10, function()
						if target.xiana_task ~= nil then
							target.xiana_task:Cancel()
							target.xiana_task = nil
							target.components.burnable:KillFX()
						end
					end)
				end
			end
		end)
	
	elseif inst.challenge_type == 4 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("巨熊侍卫")
		inst.components.inspectable:SetDescription("超级巨熊的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5 / .75
		
		inst.fy_attack_tick = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target then
				if inst.fy_attack_tick == 1 then
					if target.components.locomotor then
						target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", .5)
						target:DoTaskInTime(5, function()
							target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", 1)
						end)
					end
					inst.fy_attack_tick = 2
				elseif inst.fy_attack_tick == 2 then
					if target.components.freezable then
						target.components.freezable:AddColdness(2)
						target.components.freezable:SpawnShatterFX()
					end
					inst.fy_attack_tick = 1
				end
			end
		end)
	
	end
end




--龙蝇boss以龙蝇为载体
function FY_dragonfly_init(inst)
	inst:AddTag("FY_boss")
	inst:ListenForEvent("attacked", function (inst, data)
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("dragonfly") and not dude.components.health:IsDead() end, 5)
	end)
	if inst.challenge_type == 0 then   -------------------等于0
		inst.components.named:SetName("超级龙蝇")
		inst.components.inspectable:SetDescription("它不是普通的龙蝇")
		inst.Transform:SetScale(2.5,2.5,2.5)
		inst.components.health:SetMaxHealth(100000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5/2
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				---SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
		inst.fy_time_live = 0
		
		----没有目标则消失
		inst:DoPeriodicTask(1, function()
			if inst.components.combat.target == nil then
				inst.fy_time_live = inst.fy_time_live + 1
			else
				inst.fy_time_live = 0	--有目标则重新计时
			end
			if inst.fy_time_live >= 5 * 60 then
				inst:Remove()
			end
		end)
		
		
		inst.yunshi_task1 = inst:DoPeriodicTask(10, function()
			local offset = {x = math.random()*6-3, z = math.random()*6-3}
			local target = inst.components.combat.target
			local x1,y1,z1 = inst.Transform:GetWorldPosition()
			local fx = SpawnPrefab("shadowmeteor")
			fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
			fx.challenge_type = 1
		end)
		
		inst:ListenForEvent("healthdelta", function(inst, data)
			local oldpercent = data.oldpercent
			local newpercent = data.newpercent
			if oldpercent > .75 and newpercent <= .75 and newpercent > .5 then
				local x,y,z = inst.Transform:GetWorldPosition()
				local leif1 = SpawnPrefab("dragonfly")
				leif1.Transform:SetPosition(x,y,z)
				leif1.challenge_type = 1
				FY_leif_init(leif1)
			elseif oldpercent > .5 and newpercent <= .5 and newpercent > .25 then
				if inst.yunshi_task1 ~= nil then
					inst.yunshi_task1:Cancel()
					inst.yunshi_task1 = nil
				end
				inst.yunshi_task2 = inst:DoPeriodicTask(5, function()
					for k = 1, 2 do
						local offset = {x = math.random()*6-3, z = math.random()*6-3}
						local target = inst.components.combat.target
						local x1,y1,z1 = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("shadowmeteor")
						fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
						fx.challenge_type = 1
					end
				end)
			elseif oldpercent > .25 and newpercent <= .25 then
				local x,y,z = inst.Transform:GetWorldPosition()
				
				local leif2 = SpawnPrefab("dragonfly")
				leif2.Transform:SetPosition(x,y,z)
				leif2.challenge_type = 2
				FY_leif_init(leif2)
				
				local leif3 = SpawnPrefab("dragonfly")
				leif3.Transform:SetPosition(x,y,z)
				leif3.challenge_type = 3
				FY_leif_init(leif3)
				
				local leif4 = SpawnPrefab("dragonfly")
				leif4.Transform:SetPosition(x,y,z)
				leif4.challenge_type = 4
				FY_leif_init(leif4)
				
			end
		end)
		
	elseif inst.challenge_type == 1 then
		inst.components.named:SetName("龙蝇侍卫")
		inst.components.inspectable:SetDescription("超级龙蝇的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				--SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
	elseif inst.challenge_type == 2 then
		inst.components.named:SetName("龙蝇侍卫")
		inst.components.inspectable:SetDescription("超级龙蝇的贴身侍卫")
		inst.components.health:SetMaxHealth(2000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				--SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
	
	elseif inst.challenge_type == 3 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("龙蝇侍卫")
		inst.components.inspectable:SetDescription("超级龙蝇的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5 / .75
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target.components.burnable then
				if target.xiana_task == nil then
					target.components.burnable:SpawnFX()
					target.xiana_task = target:DoPeriodicTask(1, function()
						target.components.health:DoDelta(-2 * target.components.health.fire_damage_scale )
					end)
					target:DoTaskInTime(10, function()
						if target.xiana_task ~= nil then
							target.xiana_task:Cancel()
							target.xiana_task = nil
							target.components.burnable:KillFX()
						end
					end)
				end
			end
		end)
	
	elseif inst.challenge_type == 4 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("龙蝇侍卫")
		inst.components.inspectable:SetDescription("超级龙蝇的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5 / .75
		
		inst.fy_attack_tick = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target then
				if inst.fy_attack_tick == 1 then
					if target.components.locomotor then
						target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", .5)
						target:DoTaskInTime(5, function()
							target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", 1)
						end)
					end
					inst.fy_attack_tick = 2
				elseif inst.fy_attack_tick == 2 then
					if target.components.freezable then
						target.components.freezable:AddColdness(2)
						target.components.freezable:SpawnShatterFX()
					end
					inst.fy_attack_tick = 1
				end
			end
		end)
	
	end
end



--守卫者boss以本身为载体
function FY_minotaur_init(inst)
	inst:AddTag("FY_boss")
	inst:ListenForEvent("attacked", function (inst, data)
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("minotaur") and not dude.components.health:IsDead() end, 5)
	end)
	if inst.challenge_type == 0 then   -------------------等于0
		inst.components.named:SetName("超级守卫者")
		inst.components.inspectable:SetDescription("它不是普通的守卫者")
		inst.Transform:SetScale(2,2,2)
		inst.components.health:SetMaxHealth(100000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 1.5/2
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				---SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
		inst.fy_time_live = 0
		
		----没有目标则消失
		inst:DoPeriodicTask(1, function()
			if inst.components.combat.target == nil then
				inst.fy_time_live = inst.fy_time_live + 1
			else
				inst.fy_time_live = 0	--有目标则重新计时
			end
			if inst.fy_time_live >= 5 * 60 then
				inst:Remove()
			end
		end)
		
		
		inst.yunshi_task1 = inst:DoPeriodicTask(10, function()
			local offset = {x = math.random()*6-3, z = math.random()*6-3}
			local target = inst.components.combat.target
			local x1,y1,z1 = inst.Transform:GetWorldPosition()
			local fx = SpawnPrefab("shadowmeteor")
			fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
			fx.challenge_type = 1
		end)
		
		inst:ListenForEvent("healthdelta", function(inst, data)
			local oldpercent = data.oldpercent
			local newpercent = data.newpercent
			if oldpercent > .75 and newpercent <= .75 and newpercent > .5 then
				local x,y,z = inst.Transform:GetWorldPosition()
				local leif1 = SpawnPrefab("minotaur")
				leif1.Transform:SetPosition(x,y,z)
				leif1.challenge_type = 1
				FY_leif_init(leif1)
			elseif oldpercent > .5 and newpercent <= .5 and newpercent > .25 then
				if inst.yunshi_task1 ~= nil then
					inst.yunshi_task1:Cancel()
					inst.yunshi_task1 = nil
				end
				inst.yunshi_task2 = inst:DoPeriodicTask(5, function()
					for k = 1, 2 do
						local offset = {x = math.random()*6-3, z = math.random()*6-3}
						local target = inst.components.combat.target
						local x1,y1,z1 = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("shadowmeteor")
						fx.Transform:SetPosition(x1+offset.x,y1,z1+offset.z)
						fx.challenge_type = 1
					end
				end)
			elseif oldpercent > .25 and newpercent <= .25 then
				local x,y,z = inst.Transform:GetWorldPosition()
				
				local leif2 = SpawnPrefab("minotaur")
				leif2.Transform:SetPosition(x,y,z)
				leif2.challenge_type = 2
				FY_leif_init(leif2)
				
				local leif3 = SpawnPrefab("minotaur")
				leif3.Transform:SetPosition(x,y,z)
				leif3.challenge_type = 3
				FY_leif_init(leif3)
				
				local leif4 = SpawnPrefab("minotaur")
				leif4.Transform:SetPosition(x,y,z)
				leif4.challenge_type = 4
				FY_leif_init(leif4)
				
			end
		end)
		
	elseif inst.challenge_type == 1 then
		inst.components.named:SetName("守卫者侍卫")
		inst.components.inspectable:SetDescription("超级守卫者的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 6
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
		
	elseif inst.challenge_type == 2 then
		inst.components.named:SetName("守卫者侍卫")
		inst.components.inspectable:SetDescription("超级守卫者的贴身侍卫")
		inst.components.health:SetMaxHealth(2000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(1)
		inst.components.locomotor.walkspeed = 6
		inst:ListenForEvent("onhitother", function(inst, data)
			local other = data.target
			if other then
				SpawnPrefab("lightning").Transform:SetPosition( other.Transform:GetWorldPosition() )
			end
		end)
	
	elseif inst.challenge_type == 3 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("守卫者侍卫")
		inst.components.inspectable:SetDescription("超级守卫者的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 6   ------------移动速度
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target.components.burnable then
				if target.xiana_task == nil then
					target.components.burnable:SpawnFX()
					target.xiana_task = target:DoPeriodicTask(1, function()
						target.components.health:DoDelta(-2 * target.components.health.fire_damage_scale )
					end)
					target:DoTaskInTime(10, function()
						if target.xiana_task ~= nil then
							target.xiana_task:Cancel()
							target.xiana_task = nil
							target.components.burnable:KillFX()
						end
					end)
				end
			end
		end)
	
	elseif inst.challenge_type == 4 then	
		inst.Transform:SetScale(.75, .75, .75)
		inst.components.named:SetName("守卫者侍卫")
		inst.components.inspectable:SetDescription("超级守卫者的贴身侍卫")
		inst.components.health:SetMaxHealth(1000)
		inst.components.combat:SetDefaultDamage(200)
		inst.components.combat.playerdamagepercent = 1
		inst.components.combat:SetAttackPeriod(2)
		inst.components.locomotor.walkspeed = 6
		
		inst.fy_attack_tick = 1
		inst:ListenForEvent("onhitother", function(inst, data)
			local target = data.target
			if target then
				if inst.fy_attack_tick == 1 then
					if target.components.locomotor then
						target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", .5)
						target:DoTaskInTime(5, function()
							target.components.locomotor:SetExternalSpeedMultiplier(target, "fy_speedlow_task", 1)
						end)
					end
					inst.fy_attack_tick = 2
				elseif inst.fy_attack_tick == 2 then
					if target.components.freezable then
						target.components.freezable:AddColdness(2)
						target.components.freezable:SpawnShatterFX()
					end
					inst.fy_attack_tick = 1
				end
			end
		end)
	
	end
end













AddPrefabPostInit("leif", function(inst)
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				FY_leif_init(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
			data.fy_summon_id = inst.fy_summon_id
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
				inst.fy_summon_id = data.fy_summon_id
			end
		end
	end
end)

AddPrefabPostInit("bearger", function(inst)
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				FY_bearger_init(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
			data.fy_summon_id = inst.fy_summon_id
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
				inst.fy_summon_id = data.fy_summon_id
			end
		end
	end
end)

AddPrefabPostInit("dragonfly", function(inst)
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				FY_dragonfly_init(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
			data.fy_summon_id = inst.fy_summon_id
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
				inst.fy_summon_id = data.fy_summon_id
			end
		end
	end
end)
------------------守卫者
AddPrefabPostInit("minotaur", function(inst)
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				FY_minotaur_init(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
			data.fy_summon_id = inst.fy_summon_id
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
				inst.fy_summon_id = data.fy_summon_id
			end
		end
	end
end)







--挑战猪房以传送机零件盒子为载体
function FY_pighouse_init(inst)     ------------------
	
	--inst.AnimState:SetBank("pig_house")
	--inst.AnimState:SetBuild("pig_house")
	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("wilson")
	inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(2, 2, 2)
	
	inst:AddComponent("trader")
	if inst.components.tradable then
		inst:RemoveComponent("tradable")
	end
	if inst.components.inventoryitem then
		inst:RemoveComponent("inventoryitem")
	end
	
    inst:AddTag("blocker")
    inst.Physics:SetMass(0) 
    inst.Physics:SetCapsule(1, 2)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
	
	if inst.challenge_type == 1 then
		inst.components.named:SetName("神族统领威尔逊")
		inst.components.inspectable:SetDescription("可用眼球交换雷夫挑战书\r可用熊皮交换巨熊挑战书\r可用鳞片交换龙蝇挑战书\r可用号角交换守卫挑战书")
		inst.components.trader:SetAcceptTest(function(inst, item)
			return item and item.prefab == "deerclops_eyeball" or "bearger_fur" or "dragon_scales" or "minotaurhorn" 
		end)
		inst.components.trader.onaccept = function (inst, giver, item)
			if item then
				if item.prefab == "deerclops_eyeball" then
					local x,y,z = inst.Transform:GetWorldPosition()
					local leifbook = SpawnPrefab("teleportato_ring")      ---c_give("statue_transition")
					leifbook.challenge_type = "leif"
					FY_book_init(leifbook)
					giver.components.inventory:GiveItem(leifbook) 					
					local fx = SpawnPrefab("statue_transition")       ----生成特效
					fx.Transform:SetPosition(x,y,z)
					fx.Transform:SetScale(3, 3, 3)
					TheNet:Announce(giver:GetDisplayName().." 获得雷夫挑战书")					
				end
				
				if item.prefab == "bearger_fur" then   ---熊皮
					local x,y,z = inst.Transform:GetWorldPosition()
					local leifbook = SpawnPrefab("teleportato_ring")      ---c_give("statue_transition")
					leifbook.challenge_type = "bearger"
					FY_book_init(leifbook)
					giver.components.inventory:GiveItem(leifbook) 					
					local fx = SpawnPrefab("statue_transition")       ----生成特效
					fx.Transform:SetPosition(x,y,z)
					fx.Transform:SetScale(3, 3, 3)
					TheNet:Announce(giver:GetDisplayName().." 获得巨熊挑战书")					
				end
				
				if item.prefab == "dragon_scales" then   ---鳞片
					local x,y,z = inst.Transform:GetWorldPosition()
					local leifbook = SpawnPrefab("teleportato_ring")      ---c_give("statue_transition")
					leifbook.challenge_type = "dragonfly"
					FY_book_init(leifbook)
					giver.components.inventory:GiveItem(leifbook) 					
					local fx = SpawnPrefab("statue_transition")       ----生成特效
					fx.Transform:SetPosition(x,y,z)
					fx.Transform:SetScale(3, 3, 3)
					TheNet:Announce(giver:GetDisplayName().." 获得龙蝇挑战书")					
				end
				
				if item.prefab == "minotaurhorn" then   ---角
					local x,y,z = inst.Transform:GetWorldPosition()
					local leifbook = SpawnPrefab("teleportato_ring")      ---c_give("statue_transition")
					leifbook.challenge_type = "minotaur"
					FY_book_init(leifbook)
					giver.components.inventory:GiveItem(leifbook) 					
					local fx = SpawnPrefab("statue_transition")       ----生成特效
					fx.Transform:SetPosition(x,y,z)
					fx.Transform:SetScale(3, 3, 3)
					TheNet:Announce(giver:GetDisplayName().." 获得守卫者挑战书")					
				end
				
				
				
			end
		end
		inst.components.trader.onrefuse = function (inst, giver, item)
			if giver.components.talker then
				giver.components.talker:Say("不是所需的资源")
			end
		end
	end

end


function FY_wx78_init(inst) 

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("wx78")
	inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(2, 2, 2)
	
	inst:AddComponent("trader")
	if inst.components.tradable then
		inst:RemoveComponent("tradable")
	end
	if inst.components.inventoryitem then
		inst:RemoveComponent("inventoryitem")
	end
	
	inst.components.inspectable:SetDescription("无奈啊")
	
    inst:AddTag("blocker")
    inst.Physics:SetMass(0) 
    inst.Physics:SetCapsule(1, 2)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
	
	if inst.challenge_type == 2 then
		inst.components.named:SetName("神族统领WX78")       --------------------------
	end
	
end

function FY_SD_init(inst)           --------------------------------暂时没用。。。

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("wendy")
	inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(2, 2, 2)
	
	inst:AddComponent("trader")
	if inst.components.tradable then
		--inst:RemoveComponent("tradable")
	end
	if inst.components.inventoryitem then
		--inst:RemoveComponent("inventoryitem")
	end
	
    inst:AddTag("blocker")
    inst.Physics:SetMass(0) 
    inst.Physics:SetCapsule(1, 2)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
	
	if inst.challenge_type == 3 then
	    inst:AddComponent("named")
		inst.components.named:SetName("温迪的神秘商店")
		
	end
	
end
-----------------------------------------------------------没用到

--teleportato_crank	（曲柄状传送机零件） ---已使用
--teleportato_potato	（球状传送机零件）
--teleportato_base	（传送机零件底座）



AddPrefabPostInit("teleportato_box", function(inst)              ----c_give("teleportato_checkmate")
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				FY_pighouse_init(inst)
				----FY_wx78_init(inst)   ---------------------------这里也改过
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
			end
		end
	end
end)

AddPrefabPostInit("teleportato_crank", function(inst)              ----c_give("teleportato_checkmate")
	if IsServer then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				---FY_pighouse_init(inst)
				FY_wx78_init(inst)   ---------------------------这里也改过
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
			end
		end
	end
end)

--大门生成
AddPrefabPostInit("multiplayer_portal", function(inst)

	if IsServer then
		inst:DoTaskInTime(0, function()
			local pt = inst:GetPosition()
			local x,y,z = pt:Get()
			
			local pighouse1 = SpawnPrefab("teleportato_box")
			pighouse1.Transform:SetPosition(x+15,y,z+15)
			pighouse1.persists = false
			pighouse1.challenge_type = 1
			FY_pighouse_init(pighouse1)
			
			
			local pighouse2 = SpawnPrefab("teleportato_crank")
			pighouse2.Transform:SetPosition(x+15,y,z-15)
			pighouse2.persists = false
			pighouse2.challenge_type = 2
			FY_wx78_init(pighouse2)
			
			local pighouse3 = SpawnPrefab("perdshrine")
			pighouse3.Transform:SetPosition(x-15,y,z+15)
			pighouse3.persists = false
			pighouse3.AnimState:SetBank("wilson")
			pighouse3.AnimState:SetBuild("wendy")
			pighouse3.AnimState:PlayAnimation("idle", true)
			pighouse3.Transform:SetFourFaced()
			pighouse3.Transform:SetScale(2, 2, 2)
			pighouse3:AddTag("wufafenjie")
			--if  pighouse3.components.named == nil  then    storeroom
				--pighouse3:AddComponent("named")
				pighouse3.components.named:SetName("温迪的神秘商店")
			--end
			
			--pighouse3.challenge_type = 3
			--FY_SD_init(pighouse3)
			
			local  xiangzi = SpawnPrefab("storeroom")			
			xiangzi.Transform:SetPosition(x+15,y,z+18)
			xiangzi.components.named:SetName("公用地窖")
			--xiangzi.AnimState:SetBank("wilson")
			--xiangzi.AnimState:SetBuild("wendy")
			xiangzi.persists = false
		end)
	end

end)














