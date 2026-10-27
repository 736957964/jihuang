
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
IsServer = TheNet:GetIsServer()
modimport("scripts/eryuehong/jisuan.lua")	
GLOBAL.require "wiliya_lib"

LoadPOFile("simplifiedchinese.po", "chs") -- 加载中文

modimport("scripts/eryuehong/xianxue.lua")	   ---------显血
modimport("scripts/eryuehong/shangdian.lua")   ----商店
modimport("scripts/eryuehong/bianfu.lua")	    ----蝙蝠
modimport("scripts/eryuehong/bianyi.lua")		 ---怪物变异
modimport("scripts/eryuehong/yuren.lua")		 ---鱼人
modimport("scripts/eryuehong/hudie.lua")		 -- 蝴蝶      ----c_give("flower")
modimport("scripts/eryuehong/tuzi.lua")			---暗黑兔兔
modimport("scripts/eryuehong/huimie.lua")		---毁灭取消
modimport("scripts/eryuehong/zhu.lua")  	 	 ---猪的猪猪
modimport("scripts/eryuehong/siwangling.lua")    ---死亡令
modimport("scripts/eryuehong/zhuanzhuanle.lua")    ---转转乐
modimport("scripts/eryuehong/shubianyi.lua")   	 --- 树变异
modimport("scripts/eryuehong/NPC.lua")   		 --- 任务NPC
modimport("scripts/eryuehong/eyh_17.lua")  		 --- 不能打墙
modimport("scripts/eryuehong/eyh_29.lua")   	 --- 建造限制
modimport("scripts/eryuehong/laomai")        	  --老麦
modimport("scripts/eryuehong/eyh_2")         	  --作物升级
modimport("scripts/eryuehong/eyh_19")        	  --暖石
modimport("scripts/eryuehong/eyh_20")        	  --#世界 彩票
modimport("scripts/eryuehong/libao")         	  --在线礼包
modimport("scripts/eryuehong/jiankong")         	  --脏话监控
modimport("scripts/eryuehong/jidi")         	  --基地
modimport("scripts/eryuehong/eyh_23.lua")   	 --- 成就系统
modimport("scripts/eryuehong/eyh_1.lua")   	 --- 猪王灯
modimport("scripts/eryuehong/zg_sgwilson.lua")
----增加新动作和buff状态
modimport("scripts/eryuehong/zg_sgwilson_buff.lua")
modimport("scripts/eryuehong/douniu.lua")
modimport("scripts/eryuehong/lanmei.lua")
----modimport("scripts/eryuehong/baobaoshangren.lua")


--取消作祟
ACTIONS.HAUNT.fn = function(act)
    return false
end

-----隐藏管理员图标
GLOBAL.getmetatable(GLOBAL.TheNet).__index.GetClientTable =
      (function ()
	 local oldGetClientTable = GLOBAL.getmetatable(GLOBAL.TheNet).__index.GetClientTable
	 return function(self, ... )
	    local res=oldGetClientTable(self, ...)
	    for k, v in pairs(res) do
	       v.admin = false
	    end
	    return res
	 end
   end)()

AddPrefabPostInit("world", function(inst)
	GLOBAL.TheWorld:DoPeriodicTask(240, function() 
		GLOBAL.c_save()
	end)
	TheNet:SetDefaultServerName("【鬼服】超难~~~~")
	TheNet:SetDefaultMaxPlayers(13)
	TheNet:SetDefaultServerDescription("Q群 328734503") 
end)

   
   
   



local function WelcomeMessageInit(inst)
	inst:AddComponent("message")
	inst.components.message:SetTitle(GetModConfigData("title"))
	inst.components.message:SetMessage(GetModConfigData("message"))
end

AddPrefabPostInit("world", WelcomeMessageInit)

	----------------------------------------------



----计算人物平均天数
local function ZG_average_dag()
	local sum = 0
	for i,v in ipairs(GLOBAL.AllPlayers) do
		if v and v.components.age then
			sum = sum + v.components.age:GetAgeInDays()
		end
	end
	local average = 0
	if #GLOBAL.AllPlayers >= 1 then
		average = sum / #GLOBAL.AllPlayers
	end
	return average
end

----计算人数
local function ZG_num_player()
	local num = 1
	if #GLOBAL.AllPlayers >= 1 then
		num = #GLOBAL.AllPlayers
	end
	return num
end



--------------------------------------------------------------------------------玩家机制----------------------------------------------------------
local function Zg_oneat_fn(inst, data)
	if math.random() < 0.05 then
		local x, y, z = inst.Transform:GetWorldPosition()
		local wormhole_random = math.random()
		if wormhole_random < .25 then
			local x, y, z = inst.Transform:GetWorldPosition()
			local r = SpawnPrefab("pigguard")
			r.Transform:SetPosition(x, 0, z)
			r.AnimState:SetBank("wilson")
			local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
			local buildname = names[math.random(#names)]
			r.AnimState:SetBuild("willow") 
			r.AnimState:PlayAnimation("idle")
			local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
			local wuqi = wuqis[math.random(#wuqis)]
			r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
			r.AnimState:Hide("ARM_normal") 
			r.AnimState:Show("ARM_carry")
			local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
			local hat = hats[math.random(#hats)]
			r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
			r.AnimState:Show("HAT")
			r.AnimState:Show("HAT_HAIR")
			r.AnimState:Hide("HAIR_NOHAT")
			r.AnimState:Hide("HAIR")
			r.Transform:SetFourFaced()
			r.Transform:SetRotation( 0 )
			r.Transform:SetScale(1.5, 1.5, 1.5)
			r:AddComponent("named")	
			r.components.named:SetName("魔尊属下 火女薇洛")
			local shadow = r.entity:AddDynamicShadow()
			shadow:SetSize( 2, 1.5 )
			r.components.inspectable:SetDescription("魔尊属下 火女薇洛？")
			r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
			local light = r.entity:AddLight()
			light:SetFalloff(1)
			light:SetIntensity(.8)
			light:SetRadius(10)
			light:SetColour(180/255, 195/255, 50/255)
			light:Enable(true)
			
			local function RetargetFn(r)
            local invader = nil
			invader = FindEntity(r, 10 + 15 * 2, function(guy)
				return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
			end)
			if invader then
				local sayrandom = math.random()
				if sayrandom < .3 then			
					r.components.talker:Say("奉二月红之命, 让我烧熟你!")
				elseif sayrandom < .3 then			
					r.components.talker:Say("你真该死！")
				end
			end
	
			return invader, true
			end
			local function KeepTargetFn(r, target)
			return r.components.combat:CanTarget(target)     
			end
			SetSharedLootTable( 'zg_ch_willow',
			{
			{'armordragonfly',          1.00},
	
			})
	  
			r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
			r.components.eater.strongstomach = true
			local selfeater = r.components.eater
			local old = selfeater.Eat
			function r.components.eater:Eat(food)
				if selfeater:CanEat(food) then
					if food.components.edible.healthvalue < 1 then
						food.components.edible.healthvalue = 1
					end
				end
				return old(selfeater, food)
			end
	
			r.components.locomotor.walkspeed= 2
			r.components.locomotor.runspeed = 4
			r.components.locomotor.fasteronroad = true
			r.components.locomotor:SetTriggersCreep(false)
	
			r:SetStateGraph("SGzg_ch_willow")
			local brain = require "brains/zg_ch_wilsonbrain"	
			r:SetBrain(brain)
			r.components.health:SetMaxHealth(10000)
			r.components.health:StartRegen(2 , 5 )
			r.components.health.fire_damage_scale = 0
			r.components.health:SetAbsorptionAmount(.5)
			r:AddComponent("leader")
			r:AddComponent("timer")
			r.components.combat:SetDefaultDamage(60)					
			r.components.combat:SetAttackPeriod(2)
			r.components.combat:SetRange(2)
			r.components.combat.hiteffectsymbol = "torso"
			r.components.combat:SetRetargetFunction(3, RetargetFn)
			r.components.combat:SetKeepTargetFunction(KeepTargetFn)
			r:AddComponent("lootdropper")
			r.components.lootdropper:SetChanceLootTable('zg_ch_willow')	
	

			r:DoPeriodicTask(960,function()	
			r:Remove()		
			end)
			return r          -------------------写完一个了 

						
		elseif wormhole_random < .25 then
			local x, y, z = inst.Transform:GetWorldPosition()
			local r = SpawnPrefab("pigguard")
			r.Transform:SetPosition(x, 0, z)
			r.AnimState:SetBank("wilson")
			local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
			local buildname = names[math.random(#names)]
			r.AnimState:SetBuild("wolfgang") 
			r.AnimState:PlayAnimation("idle")
			local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
			local wuqi = wuqis[math.random(#wuqis)]
			r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
			r.AnimState:Hide("ARM_normal") 
			r.AnimState:Show("ARM_carry")
			local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
			local hat = hats[math.random(#hats)]
			r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
			r.AnimState:Show("HAT")
			r.AnimState:Show("HAT_HAIR")
			r.AnimState:Hide("HAIR_NOHAT")
			r.AnimState:Hide("HAIR")
			r.Transform:SetFourFaced()
			r.Transform:SetRotation( 0 )
			r.Transform:SetScale(1, 1, 1)
			local shadow = r.entity:AddDynamicShadow()
			shadow:SetSize( 2, 1.5 )
			r:AddComponent("named")	
			r.components.named:SetName("魔尊属下 大力士")
			r.components.inspectable:SetDescription("魔尊属下大力士？")
			r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
			local light = r.entity:AddLight()
			light:SetFalloff(1)
			light:SetIntensity(.8)
			light:SetRadius(10)
			light:SetColour(180/255, 195/255, 50/255)
			light:Enable(true)
			
			local function RetargetFn(r)
			local invader = nil
			invader = FindEntity(r, 10 + 15, function(guy)
				return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
			end)
	----	敌视语句
			if invader then
				local sayrandom = math.random()
				if sayrandom < .3 then
					r.components.talker:Say("尝尝我大锤的厉害")
				elseif sayrandom < .3 then
					r.components.talker:Say("我的肌肉结实吗?!")
				elseif sayrandom < .3 then
					r.components.talker:Say("我TM敲死你!")	
				end
		
			end
			return invader, true
			end
			local function KeepTargetFn(r, target)
			return r.components.combat:CanTarget(target)     
			end
			SetSharedLootTable( 'zg_wolfgang',
			{
			{'bonestew',          1.00},
			{'bonestew',          0.50},
			})
			local function onattack(r, data)
			local victim = data.target
			if victim and victim:HasTag("player") then
				local x,y,z = victim.Transform:GetWorldPosition()
				SpawnPrefab("collapse_small").Transform:SetPosition(x,y,z)
				if victim.components.hunger then
					victim.components.hunger:DoDelta( -victim.components.hunger.current * .25 )
				end
				end
			end
	
			r.components.locomotor.walkspeed= 2
			r.components.locomotor.runspeed = 4
			r.components.locomotor.fasteronroad = true
			r.components.locomotor:SetTriggersCreep(false)
	
			r:SetStateGraph("SGzg_ch_wolfgang")

			local brain = require "brains/zg_ch_wolfgangbrain"
			r:SetBrain(brain)
	
			r.components.health:SetMaxHealth(10000)
			r.components.health:StartRegen(2,5 )
			r.components.health.fire_damage_scale = 0
			r.components.health:SetAbsorptionAmount(.5)
			r:AddComponent("leader")
			r.components.combat:SetDefaultDamage(60)						----常常不是空手, 因此无用
			r.components.combat:SetAttackPeriod(1)
			r.components.combat:SetRange(2.5)
			r.components.combat:SetAreaDamage(2, 1)					----范围攻击
			r.components.combat.hiteffectsymbol = "torso"
			r.components.combat:SetRetargetFunction(2, RetargetFn)
			r.components.combat:SetKeepTargetFunction(KeepTargetFn)
			r:ListenForEvent("onhitother", onattack)
	
			r:AddComponent("groundpounder")
			r.components.groundpounder.numRings = 2	
			r.components.groundpounder.damageRings = 2	
			r.components.groundpounder.burner = false
			r.components.groundpounder.groundpounddamagemult = 1
			r.components.groundpounder.destroyer = false
			r.components.groundpounder.destructionRings = 2
			r.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "shadowboss"}
			r:AddComponent("lootdropper")
			r.components.lootdropper:SetChanceLootTable('zg_wolfgang')
	
			r:AddComponent("timer")
			r:ListenForEvent("timerdone", function(r, data)
				if data.name == "pound" then	--打扁
						r.canpound = true
						end
			end)
	
			r:AddComponent("eater")  
			r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
			r.components.eater.strongstomach = true
			local selfeater = r.components.eater
			local old = selfeater.Eat
			function r.components.eater:Eat(food)
				if selfeater:CanEat(food) then
					if food.components.edible.healthvalue < 1 then
						food.components.edible.healthvalue = 1
					end
				end
				return old(selfeater, food)
			end
    
			r:DoPeriodicTask(960,function()	
				r:Remove()		
			end)
			return r 		 --------------写完两个了

			
		elseif wormhole_random < .25 then		
		    local x, y, z = inst.Transform:GetWorldPosition()
			local r = SpawnPrefab("pigguard")
			r.Transform:SetPosition(x, 0, z)
			r.AnimState:SetBank("wilson")
			local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
			local buildname = names[math.random(#names)]
			r.AnimState:SetBuild("woodie") 
			r.AnimState:PlayAnimation("idle")
			local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
			local wuqi = wuqis[math.random(#wuqis)]
			r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
			r.AnimState:Hide("ARM_normal") 
			r.AnimState:Show("ARM_carry")
			local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
			local hat = hats[math.random(#hats)]
			r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
			r.AnimState:Show("HAT")
			r.AnimState:Show("HAT_HAIR")
			r.AnimState:Hide("HAIR_NOHAT")
			r.AnimState:Hide("HAIR")
			r.Transform:SetFourFaced()
			r.Transform:SetRotation( 0 )
			r.Transform:SetScale(1, 1, 1)
			local shadow = r.entity:AddDynamicShadow()
			shadow:SetSize( 2, 1.5 )
			r:AddComponent("named")	
			r.components.named:SetName("魔尊属下 伐木工")
			r.components.inspectable:SetDescription("魔尊属下 伐木工？")
			r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
			local light = r.entity:AddLight()
			light:SetFalloff(1)
			light:SetIntensity(.8)
			light:SetRadius(10)
			light:SetColour(180/255, 195/255, 50/255)
			light:Enable(true)
			local function RetargetFn(r)
			local invader = nil
			invader = FindEntity(r, 10 + 15, function(guy)
				return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
			end)
			if invader then
				local sayrandom = math.random()
				if sayrandom < .3 then
					r.components.talker:Say("把头伸过来, 我要给你砍掉")
				elseif sayrandom < .3 then
					r.components.talker:Say("雪舞雪舞~别跑呀")
				end
			end
			return invader, true
			end
			local function KeepTargetFn(r, target)
			return r.components.combat:CanTarget(target)     
			end
-------------------------------------------------------------------------------------------------------------
			SetSharedLootTable( 'zg_ch_woodie',
			{
			{'dragonpie',          1.00},
			{'dragonpie',          0.50},
			})
	
			r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
			r.components.eater.strongstomach = true
			local selfeater = r.components.eater
			local old = selfeater.Eat
			function r.components.eater:Eat(food)
				if selfeater:CanEat(food) then
					if food.components.edible.healthvalue < 1 then
						food.components.edible.healthvalue = 1
					end
				end
				return old(selfeater, food)
			end
	
			r.components.locomotor.walkspeed= 2
			r.components.locomotor.runspeed = 4
			r.components.locomotor.fasteronroad = true
			r.components.locomotor:SetTriggersCreep(false)
	
			r:SetStateGraph("SGzg_ch_woodie")

			local brain = require "brains/zg_ch_wolfgangbrain"		
			r:SetBrain(brain)
	
			r.components.health:SetMaxHealth(10000)
			r.components.health:StartRegen(2 , 5 )
			r.components.health.fire_damage_scale = 0
			r.components.health:SetAbsorptionAmount(.5)
			r:AddComponent("leader")
			r.components.combat:SetDefaultDamage(80)						
			r.components.combat:SetAttackPeriod(3)
			r.components.combat:SetRange(2)
			r.components.combat.hiteffectsymbol = "torso"
			r.components.combat:SetRetargetFunction(3, RetargetFn)
			r.components.combat:SetKeepTargetFunction(KeepTargetFn)
			r:AddComponent("lootdropper")
			r.components.lootdropper:SetChanceLootTable('zg_ch_woodie')
	
			r:AddComponent("timer")
			r:ListenForEvent("timerdone", function(r, data)
				if data.name == "pound" then	--身体旋风
					r.canpound = true
				end
			end)
	
			r:DoPeriodicTask(960,function()	
			   r:Remove()		
			end)
		    return r 

		end
	end
end

local function caiji(inst,data)
    if math.random() < 0.02 then 
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild(buildname) 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike", "swap_elpheltbazooka", "swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(1, 1, 1)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔界小鬼")
	r.components.inspectable:SetDescription("魔界小鬼")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)	

    ----	重定位目标
    local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 15, function(guy)
        return guy and guy:HasTag("player") and not guy:HasTag("playerghost") and not guy.components.container
				or (guy.components.combat and guy.components.combat.target and guy.components.combat.target:HasTag("zg_soldier") )
    end)
	if invader then
		r.components.combat:SetTarget(invader)
		r.components.combat:ShareTarget(invader, 100, function(dude)
			return dude:HasTag("zg_soldier")	
		end, 20)
	end
    return invader
    end
	local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)    
	end
	
	
	----	击中玩家	特点	--模板
    local function onattack(r,data)
    local victim = data.target
	if victim and victim:HasTag("character") then
		
	end
    end

    local function OnAttacked(r, data)
    local attacker = data and data.attacker
	if attacker then
		if r.components.combat:CanTarget(attacker) and not attacker:HasTag("zg_soldier") then
			r.components.combat:SetTarget(attacker)
			r.components.combat:ShareTarget(attacker, 100, function(dude)
				return dude:HasTag("zg_soldier")	
			end, 20)
			
		end
	end
    end
	
	----	武器栏
local function GetInventory(r)
	if r.components.inventory ~= nil and not r.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
		local meleeweapon = CreateEntity()
		meleeweapon.entity:AddTransform()
		meleeweapon:AddComponent("weapon")
		meleeweapon.name = "ak"
		meleeweapon.components.weapon:SetDamage(25)			----三连发
		meleeweapon.components.weapon:SetRange(10, 12)
		meleeweapon.components.weapon.stimuli = "zg_ele_bullet"
		
		meleeweapon:AddComponent("inventoryitem")
		meleeweapon.persists = false
		meleeweapon.components.inventoryitem:SetOnDroppedFn(r.Remove)
		meleeweapon:AddComponent("equippable")
		meleeweapon.components.equippable:SetOnEquip(function()
			r.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
			r.AnimState:Show("ARM_carry") 
			r.AnimState:Hide("ARM_normal")
		end)
		meleeweapon:AddTag("ak")
		r.components.inventory:Equip(meleeweapon)
		r.zg_bullet = 90
	end
    end
    SetSharedLootTable( 'zg_ch0_soldier00',
    {
	{'charcoal',     1.0},
    {'charcoal',     1.0},
	{'krampus_sack',          0.01},
	
    })
	
	r:HasTag("zg_soldier")
    r.components.locomotor.walkspeed= 5
    r.components.locomotor.runspeed = 6
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(true)
	r.components.health:SetMaxHealth(2500)
	r.components.combat:SetDefaultDamage(50)		
    r.components.combat:SetAttackPeriod(0)				
    r.components.combat:SetRange(3)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(1, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	r:ListenForEvent("onattackother", onattack)

    r:AddComponent("lootdropper")
	r.components.lootdropper:SetChanceLootTable('zg_ch0_soldier00')
    r:ListenForEvent("attacked", OnAttacked)
	
	
	
	
	r:AddComponent("leader")
    r:SetStateGraph("SGzg_ch0_soldier")
    local brain = require "brains/zg_ch0_soldier00"
    r:SetBrain(brain)
    
	
	----	伪装
	r:DoPeriodicTask(.5, function(r)
		local invader = nil
		invader = FindEntity(r, 15, function(guy)
			return guy and guy:HasTag("character") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
					or (guy.components.combat and guy.components.combat.target and guy.components.combat.target:HasTag("zg_soldier") )
		end)
		if invader then
			----有目标则起身射击
			if r.sg and r.sg:HasStateTag("hiding") then
				r.sg:GoToState("idle")
				r.components.combat:SetTarget(invader)		
			end
		else
			----没入侵者 且 无 攻击目标 则伪装
			if r.sg and not r.sg:HasStateTag("hiding") then
				if r.components.combat and r.components.combat.target == nil then
					r.sg:GoToState("hide")
				end
			end
		end
	end)
	
	return r
	end
end
	
	
function jisha(inst,data)
    if math.random() < 0.02 then 
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild("xenomorph") 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike", "swap_elpheltbazooka", "swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(1, 1, 1)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔尊属下 异形")
	r.components.inspectable:SetDescription("魔尊属下 异形")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)	
	
	----	重定位目标
    local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .05 then
			r.components.talker:Say("魔尊大人 法力无边!")
		elseif sayrandom < .1 then
			r.components.talker:Say("小子 哈哈哈哈哈！")
		end
		if not r.components.combat:CanHitTarget(invader) 
			and wy_isalive(invader) and math.random()<.2 
			and not r.sg:HasStateTag("skill")
			then
			r:PushEvent("zg_ch1_sanji_moonstep",{target=invader})
		end
	end
    return invader
    end
    local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end
	
	
	SetSharedLootTable( 'zg_ch1_sanji',
    {
	{'butterflymuffin',          0.2},
	{'frogglebunwich',          0.2},
	{'taffy',          0.2},
	{'pumpkincookie',          0.2},
	{'stuffedeggplant',          0.2},
	{'fishsticks',          0.2},
	{'honeynuggets',          0.2},
	{'honeyham',          0.2},

    })
	
	----	击中玩家	特点	--模板
    local function onattack(r, data)
    local victim = data.target
	if victim and victim.SoundEmitter then
	end
	if victim and victim.components.burnable and r.firetick then
		victim.components.burnable:Ignite()
	end
    end
	
	local phys = r.entity:AddPhysics()
	phys:SetMass(100)
    phys:SetCapsule(.5, 1.5)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.GROUND)
	r:AddTag("shadowboss")
	
	
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
	r.components.locomotor.walkspeed= 3.5
    r.components.locomotor.runspeed = 4.5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)
	
	r:SetStateGraph("SGzg_ch1_sanji")

    local brain = require "brains/zg_ch_wolfgangbrain"
    r:SetBrain(brain)
	
	r.components.health:SetMaxHealth(10000)
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.5)
	r:AddComponent("leader")
	r.components.combat:SetDefaultDamage(60)						
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)			
	r.components.combat:SetAreaDamage(2, 0.6)					----范围攻击
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(1, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	function r.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
		local hitcount = 0
		local x, y, z = target.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, {"shadowboss"})			----AOE伤害忽略队友
		for i, ent in ipairs(ents) do
			if ent ~= target and
				ent ~= self.inst and
				self:IsValidTarget(ent) and
				(validfn == nil or validfn(ent)) then
				self.inst:PushEvent("onareaattackother", { target = target, weapon = weapon, stimuli = stimuli })
				ent.components.combat:Zg_GetAttacked(self.inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli)
				hitcount = hitcount + 1
			end
		end
		return hitcount
	end
	
	----	攻击特效
	r:ListenForEvent("onhitother", onattack)	

    r:AddComponent("lootdropper")
	----	掉落
	r.components.lootdropper:SetChanceLootTable('zg_ch1_sanji')
	
	r:AddComponent("timer")
	r.canpound = true
	r:ListenForEvent("timerdone", function (r, data)

		if data.name == "pound" then		--旋风踢
			r.canpound = true
		end
		
	end)
	
    return r
	end
end	

local function diuqi(inst,data)
    if math.random() < 0.01 then   ----因为乱丢东西 惩罚
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild("faroz") 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike", "swap_elpheltbazooka", "swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(1, 1, 1)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔尊属下 兔娘")
	r.components.inspectable:SetDescription("魔尊属下 兔娘")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	----	重定位目标
    local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 35, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		
		if r._is_riding then
			if sayrandom < .05 then
				r.components.talker:Say("祝你好运!")
			elseif sayrandom < .1 then
				r.components.talker:Say("翻滚吧! 宝宝!")
			end
		else
			if sayrandom < .1 then
				r.components.talker:Say("来亲吻我吧!")
			end
		end
		
	end
    return invader, true
    end
		
	local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end

    SetSharedLootTable( 'zg_ch_wigfrid',
    {
	{'honeyham',          1.00},
	{'honeyham',          0.50},
    })
	
	----	武器样式
    local function onequip(r, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear_wathgrithr", "swap_spear_wathgrithr")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    end
    local function onunequip(r, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end

    ----	武器栏
    local function GetInventory(r)
    if r.components.inventory ~= nil and not r.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local meleeweapon = CreateEntity()
        meleeweapon.entity:AddTransform()
        meleeweapon:AddComponent("weapon")
        meleeweapon.components.weapon:SetDamage(80)
		meleeweapon.components.weapon:SetOnAttack( function(meleeweapon, r, target)
			if r._is_riding then
				if target and target.components.health and not target.components.health:IsDead() and target.components.combat then
					target.components.combat:Zg_GetAttacked(r, 80)
				end
			end
		end)	
		
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(r.Remove)
        meleeweapon:AddComponent("equippable")
			----	武器外观
			meleeweapon.components.equippable:SetOnEquip(onequip)
			meleeweapon.components.equippable:SetOnUnequip(onunequip)
        meleeweapon:AddTag("meleeweapon")
		r.components.inventory:Equip(meleeweapon)
    end
    end
    
	
	
	local phys = r.entity:AddPhysics()
	phys:SetMass(10000)
    phys:SetCapsule(.5, 1.5)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.GROUND)
	phys:CollidesWith(COLLISION.CHARACTERS)
	r:AddTag("shadowboss")
	
	
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
    r.components.locomotor.walkspeed= 4
    r.components.locomotor.runspeed = 5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)

    r:SetStateGraph("SGzg_ch_wigfrid")

    local brain = require "brains/zg_ch_wolfgangbrain"		----使用沃尔夫冈的AI
    r:SetBrain(brain)
	
	
	r.components.health:SetMaxHealth(10000)
	r.components.health:StartRegen(10, 5)
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.5)
	r:AddComponent("leader")
	r.components.combat:SetDefaultDamage(100)						----常常不是空手, 因此无用
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)
	r.components.combat:SetAreaDamage(2, 0.8)					----范围攻击
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(2, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	function r.components.combat:DoAreaAttack(target, range, weapon, validfn, stimuli)
		local hitcount = 0
		local x, y, z = target.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, range, { "_combat" }, {"shadowboss"})			----AOE伤害忽略队友
		for i, ent in ipairs(ents) do
			if ent ~= target and
				ent ~= self.inst and
				self:IsValidTarget(ent) and
				(validfn == nil or validfn(ent)) then
				self.inst:PushEvent("onareaattackother", { target = target, weapon = weapon, stimuli = stimuli })
				ent.components.combat:Zg_GetAttacked(self.inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli)
				hitcount = hitcount + 1
			end
		end
		return hitcount
	end
	
	r:AddComponent("lootdropper")
	----	掉落
	r.components.lootdropper:SetChanceLootTable('zg_ch_wigfrid')
	GetInventory(r)
	
	
	r.pound_cd = 12.5
	r.pound2_cd = 2.5
	
	r:AddComponent("timer")
	r:ListenForEvent("timerdone", function(r, data)
		if data.name == "pound" then	--身体旋风
			r.canpound = true
		elseif data.name == "pound2" then	--骑牛冲锋
			r.canpound2 = true
		end
	end)
	
	----	开头就准备技能
	if not (r.canpound2 or r.components.timer:TimerExists("pound2")) then
		r.components.timer:StartTimer("pound2", r.pound2_cd)
	end
    return r
	end
end	
	




AddPlayerPostInit(function(inst)
	if inst then
		if GLOBAL.TheWorld.ismastersim then						
			inst:ListenForEvent("oneat", Zg_oneat_fn)	 --吃食物机制	
            inst:ListenForEvent("picksomething", caiji)  --采摘		
            inst:ListenForEvent("killed", jisha)         --击杀	
            inst:ListenForEvent("dropitem", diuqi)       --丢垃圾			
		end	
	end
end)

----------------------------------------------------------------------------------------玩家机制

----工作机制中的变异
----石头中的人形怪物  ---------------------------------很好
local function rock_worked(inst, data)
	if math.random() < 0.03 then    ----- 0.03
	local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild(buildname) 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(1, 1, 1)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔尊属下 人形兵器")
	r.components.inspectable:SetDescription("魔尊 二月红的 军队？")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 60, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	if invader then
		local sayrandom = math.random()
		if sayrandom < .3 then
			if r.components.talker then
				r.components.talker:Say("奉魔尊二月红之命!")
			end
		end
		if sayrandom < .2 then
			if r.components.talker then
				r.components.talker:Say("誓死守卫魔尊!")
			end
		end
		if sayrandom < .2 then
			if r.components.talker then
				r.components.talker:Say("小子，不要走，决战到天亮!")
			end
		end
	end
    return invader,true
    end
    local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end
	
	SetSharedLootTable( 'ex',
    {
	{'redgem',          .05},
	{'bluegem',          .05},
	{'greengem',          .05},
	{'yellowgem',          .05},

    })
	local function LaunchItem(r, target, item)
    if item.Physics ~= nil then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        local vel = (target:GetPosition() - r:GetPosition()):GetNormalized()
        local speed = 5 + math.random() * 2
        local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
        item.Physics:SetVel(math.cos(angle) * speed, 10, -math.sin(angle) * speed)
    end
    end
	local function onattack(r,data)
    local victim = data.target
	if victim then
		if victim:HasTag("player") then
			if math.random() < .5 then
				local item = victim.components.inventory and victim.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if item then
					victim.components.inventory:DropItem(item)
					LaunchItem(r, victim, item)
				end
			end
		end
	end
    end
	MakeCharacterPhysics(r, 75, .5)
	r.Physics:ClearCollisionMask()
    r.Physics:CollidesWith(COLLISION.CHARACTERS)
	r.Physics:CollidesWith(COLLISION.GROUND)
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
    r.components.locomotor.walkspeed= 2.5
    r.components.locomotor.runspeed = 5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)	
	r:SetStateGraph("SGzg_ch3_mihawk")
	local brain = require "brains/zg_ch3_mihawkbrain"
    r:SetBrain(brain)
	r.zg_chase_time=30	
	r.zg_see_dist=8	
	r.zg_startrunaway_dist=2		
	r.zg_stoprunaway_dist=3	
	r.target_exdist=1	
    r.components.health:SetMaxHealth(10000)
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.5)
    r.components.combat:SetDefaultDamage(60)			
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(1, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	r.components.combat:SetAreaDamage(3, 1)		
	function r.components.combat:CanTarget(target)
		return true
	end
	function r.components.combat:IsValidTarget(target)
		return true
	end
	function r.components.combat:CanHitTarget(target, weapon)
		if self.inst ~= nil and
			self.inst:IsValid() and
			target ~= nil and
			(   self:CanExtinguishTarget(target, weapon) or
				self:CanLightTarget(target, weapon) or
				(   target.components.combat ~= nil 
				)
			) then

			local targetpos = target:GetPosition()
			if distsq(targetpos, self.inst:GetPosition()) <= self:CalcHitRangeSq(target) then
				return true
			elseif weapon ~= nil and weapon.components.projectile ~= nil then
				local range = target.Physics ~= nil and target.Physics:GetRadius() + weapon.components.projectile.hitdist or weapon.components.projectile.hitdist
				return distsq(targetpos, weapon:GetPosition()) <= range * range
			end
		end
		return false
	end
	
	r:ListenForEvent("onhitother", onattack)
    r:AddComponent("lootdropper")
	r.components.lootdropper:SetChanceLootTable('ex')    
	r:HasTag("rxg")
	r:AddComponent("timer")
	r.canpound = true
	r.canpound2 = true
	r:ListenForEvent("timerdone", function (r, data)
		if data.name == "pound" then	
			r.canpound = true
		elseif data.name == "pound2" then	
			r.canpound2 = true
		end
	end)
	
	r:ListenForEvent("healthdelta", function (r, data)
		local newpercent=data.newpercent
		if newpercent and newpercent<.5 then
			if not r.wzs then
				r.wzs=true
				r.components.combat.damagemultiplier=2
				r.components.health:SetAbsorptionAmount(.7)
			end
		end
	end)	
	
	r:DoPeriodicTask(480*1.5,function()	   
	r:Remove()		
	end)

	return r
	end
end

local function Spawngw(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:ListenForEvent("worked", rock_worked)
	end
end

AddPrefabPostInit("rock1", Spawngw)
AddPrefabPostInit("rock2", Spawngw)


----烹饪的奇遇-----------------------------------------很好
local function zg_startcookfn(inst)
	if not inst:HasTag("burnt") then
		----开始来怪
		if math.random() < .1 then   ----这里是几率
			local x, y, z = inst.Transform:GetWorldPosition()
			local wormhole_random = math.random()
			if  wormhole_random < .2 then
				local x, y, z = inst.Transform:GetWorldPosition()
                local r = SpawnPrefab("pigguard")
                r.Transform:SetPosition(x, 0, z)
				r.AnimState:SetBank("wilson")
				local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
				local buildname = names[math.random(#names)]
				r.AnimState:SetBuild(buildname) 
				r.AnimState:PlayAnimation("idle")
				local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
				local wuqi = wuqis[math.random(#wuqis)]
				r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
				r.AnimState:Hide("ARM_normal") 
				r.AnimState:Show("ARM_carry")
				local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
				local hat = hats[math.random(#hats)]
				r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
				r.AnimState:Show("HAT")
				r.AnimState:Show("HAT_HAIR")
				r.AnimState:Hide("HAIR_NOHAT")
				r.AnimState:Hide("HAIR")
				r.Transform:SetFourFaced()
				r.Transform:SetRotation( 0 )
				r.Transform:SetScale(1, 1, 1)
				local shadow = r.entity:AddDynamicShadow()
				shadow:SetSize( 2, 1.5 )
				r:AddComponent("named")	
				r.components.named:SetName("魔尊属下 人形兵器")
				r.components.inspectable:SetDescription("魔尊 二月红的 军队？")
				r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
				local light = r.entity:AddLight()
				light:SetFalloff(1)
				light:SetIntensity(.8)
				light:SetRadius(10)
				light:SetColour(180/255, 195/255, 50/255)
				light:Enable(true) 
				local function RetargetFn(r)
				local invader = nil
				invader = FindEntity(r, 40, function(guy)
					return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
				end)
				if invader then
					local sayrandom = math.random()
					if sayrandom < .1 then
						r.components.talker:Say("你可有苦头吃着呢!")
					end
					if sayrandom < .2 then
						r.components.talker:Say("我才是最强的人形兵器!")
					end
				end
				return invader, true
				end
	
				local function KeepTargetFn(r, target)
				return r.components.combat:CanTarget(target)     
				end
				SetSharedLootTable( 'zg_ch_wes',
				{
				{'walrushat',          0.05},
	
				{'krampus_sack',      0.05},
	
				{'cane',          0.02},
	
				})
	            r:HasTag("rxg")
				r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
				r.components.eater.strongstomach = true
				local selfeater = r.components.eater
				local old = selfeater.Eat
				function r.components.eater:Eat(food)
					if selfeater:CanEat(food) then
						if food.components.edible.healthvalue < 1 then
							food.components.edible.healthvalue = 1
						end
					end
					return old(selfeater, food)
				end
	

				r.components.locomotor.walkspeed= 3.5
				r.components.locomotor.runspeed = 5.5
				r.components.locomotor.fasteronroad = true
				r.components.locomotor:SetTriggersCreep(false)
				r:SetStateGraph("SGzg_ch_wes")
				local brain = require "brains/zg_ch_wolfgangbrain"			--使用大力士的AI
				r:SetBrain(brain)
				r.components.health:SetMaxHealth(10000)
				r.components.health:StartRegen(2 , 5 )
				r.components.health.fire_damage_scale = 0
				r.components.health:SetAbsorptionAmount(.5)
				r:AddComponent("leader")

				r.components.combat:SetDefaultDamage( 60 )						----常常不是空手, 因此无用
				r.components.combat:SetAttackPeriod( 3 )
				r.components.combat:SetRange(2)
				r.components.combat.hiteffectsymbol = "torso"
				r.components.combat:SetRetargetFunction(3, RetargetFn)
				r.components.combat:SetKeepTargetFunction(KeepTargetFn)
				r:AddComponent("lootdropper")
				r.components.lootdropper:SetChanceLootTable('zg_ch_wes')
		
				r:AddComponent("timer")
				r:ListenForEvent("timerdone", function(r, data)
					if data.name == "pound" then	
						r.canpound = true
					end
				end)
				if not (r.canpound or r.components.timer:TimerExists("pound")) then
					r.components.timer:StartTimer("pound", 5)
				end
				r:DoPeriodicTask(960,function()	
					r:Remove()		
				end)	
				return r
				
			elseif  wormhole_random < .3 then
			    local x, y, z = inst.Transform:GetWorldPosition()
                local r = SpawnPrefab("pigguard")
                r.Transform:SetPosition(x, 0, z)
				r.AnimState:SetBank("wilson")
				local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
				local buildname = names[math.random(#names)]
				r.AnimState:SetBuild(buildname) 
				r.AnimState:PlayAnimation("idle")
				local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
				local wuqi = wuqis[math.random(#wuqis)]
				r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
				r.AnimState:Hide("ARM_normal") 
				r.AnimState:Show("ARM_carry")
				local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
				local hat = hats[math.random(#hats)]
				r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
				r.AnimState:Show("HAT")
				r.AnimState:Show("HAT_HAIR")
				r.AnimState:Hide("HAIR_NOHAT")
				r.AnimState:Hide("HAIR")
				r.Transform:SetFourFaced()
				r.Transform:SetRotation( 0 )
				r.Transform:SetScale(1, 1, 1)
				local shadow = r.entity:AddDynamicShadow()
				shadow:SetSize( 2, 1.5 )
				r:AddComponent("named")	
				r.components.named:SetName("魔尊属下 人形兵器")
				r.components.inspectable:SetDescription("魔尊 二月红的 军队？")
				r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
				local light = r.entity:AddLight()
				light:SetFalloff(1)
				light:SetIntensity(.8)
				light:SetRadius(10)
				light:SetColour(180/255, 195/255, 50/255)
				light:Enable(true) 
				local function RetargetFn(r)
				local invader = nil
				invader = FindEntity(r, 10 + 15, function(guy)
					return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
				end)
				if invader then
					local sayrandom = math.random()
					if sayrandom < .1 then
						r.components.talker:Say("让你永远闭嘴!")
					elseif sayrandom < .2 then
						r.components.talker:Say("站住！尝尝我的法术！")
					end
				end
				return invader, true
				end
	            r:HasTag("rxg")
				local function KeepTargetFn(r, target)
						return r.components.combat:CanTarget(target)     
				end
	
				SetSharedLootTable( 'zg_wicker',
				{
				{'icestaff',          1.00},
				})
	
				local function GetInventory(r)
				if r.components.inventory ~= nil and not r.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
					local meleeweapon = CreateEntity()
					meleeweapon.entity:AddTransform()
					meleeweapon:AddComponent("weapon")
					meleeweapon.components.weapon:SetDamage(60 )			----冰尖柱法术
					meleeweapon.components.weapon:SetRange(4, 7)
					meleeweapon:AddComponent("inventoryitem")
					meleeweapon.persists = false
					meleeweapon.components.inventoryitem:SetOnDroppedFn(r.Remove)
					meleeweapon:AddComponent("equippable")
					meleeweapon:AddTag("meleeweapon")
					r.components.inventory:Equip(meleeweapon)
					end
				end
	
				local function NumPerdsToSpawn(r)
				local numFollowers = r.components.leader:CountFollowers()
				local num = 1 - numFollowers
				if num <= 0 then
					return 0
				else
				return num
				end
				end
	
				r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
				r.components.eater.strongstomach = true
				local selfeater = r.components.eater
				local old = selfeater.Eat
				function r.components.eater:Eat(food)
					if selfeater:CanEat(food) then
						if food.components.edible.healthvalue < 1 then
							food.components.edible.healthvalue = 1
						end
					end
					return old(selfeater, food)
				end

				r.components.locomotor.walkspeed= 3.5
				r.components.locomotor.runspeed = 5.5
				r.components.locomotor.fasteronroad = true
				r.components.locomotor:SetTriggersCreep(false)
	
				r.NumPerdsToSpawn = NumPerdsToSpawn
	
				r:SetStateGraph("SGzg_ch_wicker")
	
				local brain = require "brains/zg_ch_wilsonbrain"		
				r:SetBrain(brain)
	
				r.components.health:SetMaxHealth(10000)
				r.components.health:StartRegen(2 , 5 )
				r.components.health.fire_damage_scale = 0
				r.components.health:SetAbsorptionAmount(.5)
	
				r.components.combat:SetDefaultDamage(60 )					----常常不是空手, 因此无用				
				r.components.combat:SetAttackPeriod(2)
				r.components.combat:SetRange(2)
				r.components.combat.hiteffectsymbol = "torso"
				r.components.combat:SetRetargetFunction(3, RetargetFn)
				r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
				r:AddComponent("lootdropper")
				r.components.lootdropper:SetChanceLootTable('zg_wicker')
	
				r:AddComponent("timer")
				r:ListenForEvent("timerdone", function(r, data)
					if data.name == "pound" then	--冰风暴
						r.canpound = true
					end
				end)
	
	
	
				r:DoPeriodicTask(960,function()	
					r:Remove()		
				end)
	
				return r
				
			else	
			    
				GLOBAL.SpawnPrefab("leif").Transform:SetPosition(x-5,0,z-5)
			end
		end
		
    end
end


local function cookpot_change(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst.components.stewer.onstartcooking = zg_startcookfn
	end
end
AddPrefabPostInit("cookpot", cookpot_change)

-----------------------------------砍树出的 ------------------------------------------

local function kanshu(inst, data)
	if math.random() < 0.03 then    ----- 0.03  几率百分之三 就好。不要太多
	            local x, y, z = inst.Transform:GetWorldPosition()
                local r = SpawnPrefab("pigguard")
                r.Transform:SetPosition(x, 0, z)
				r.AnimState:SetBank("wilson")
				local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
				local buildname = names[math.random(#names)]
				r.AnimState:SetBuild(buildname) 
				r.AnimState:PlayAnimation("idle")
				local wuqis = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
				local wuqi = wuqis[math.random(#wuqis)]
				r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
				r.AnimState:Hide("ARM_normal") 
				r.AnimState:Show("ARM_carry")
				local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
				local hat = hats[math.random(#hats)]
				r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
				r.AnimState:Show("HAT")
				r.AnimState:Show("HAT_HAIR")
				r.AnimState:Hide("HAIR_NOHAT")
				r.AnimState:Hide("HAIR")
				r.Transform:SetFourFaced()
				r.Transform:SetRotation( 0 )
				r.Transform:SetScale(1, 1, 1)
				local shadow = r.entity:AddDynamicShadow()
				shadow:SetSize( 2, 1.5 )
				r:AddComponent("named")	
				r.components.named:SetName("魔尊属下 人形兵器")
				r.components.inspectable:SetDescription("魔尊 二月红的 军队？")
				r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
				local light = r.entity:AddLight()
				light:SetFalloff(1)
				light:SetIntensity(.8)
				light:SetRadius(10)
				light:SetColour(180/255, 195/255, 50/255)
				light:Enable(true) 
				
			----	重定位目标
    local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .0375 then
			r.components.talker:Say("奉魔尊之命, 让你去一览美景!")
		elseif sayrandom < .075 then
			r.components.talker:Say("站住！我只想要你的命而已！")
		end
	end
    return invader, true
    end
    local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end
-------------------------------------------------------------------------------------------------------------
    SetSharedLootTable( 'zg_wilson',
    {

	{'turkeydinner',          1.00},
	{'turkeydinner',          0.50},

    })
	
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end

    r.components.locomotor.walkspeed= 3
    r.components.locomotor.runspeed = 5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)
	
	r.NumPerdsToSpawn = NumPerdsToSpawn
	
	----	状态图和AI
    r:SetStateGraph("SGzg_ch_wilson")

    local brain = require "brains/zg_ch_wilsonbrain"
    r:SetBrain(brain)
    
    r.components.health:SetMaxHealth(10000)
	r.components.health:StartRegen(20 , 5 )
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.5)
	r:AddComponent("leader")
    r.components.combat:SetDefaultDamage(60)					
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(3, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	r:AddComponent("lootdropper")
	r.components.lootdropper:SetChanceLootTable('zg_wilson')
	r:AddComponent("timer")
	r:ListenForEvent("timerdone", function(r, data)
		if data.name == "pound" then	--突击
			r.canpound = true
		end
	end)
	
	r:DoPeriodicTask(960,function()	
	r:Remove()		
	end)	
				
	return r			
	   		
	end
end

local function Spawngw1(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:ListenForEvent("worked", kanshu)
	end
end

AddPrefabPostInit("evergreen", Spawngw1)
AddPrefabPostInit("evergreen_sparse", Spawngw1)
AddPrefabPostInit("marsh_tree", Spawngw1)
AddPrefabPostInit("deciduoustree_tall", Spawngw1)
AddPrefabPostInit("deciduoustree_short", Spawngw1)
AddPrefabPostInit("deciduoustree", Spawngw1)



-------------------------定时出的怪物 


function chuxian(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild("wendy") 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike", "swap_elpheltbazooka", "swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(2, 2, 2)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔界至尊 懒瞄")
	r.components.inspectable:SetDescription("魔界至尊")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
    local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 10 + 15 , function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	if invader then
		local sayrandom = math.random()
		if sayrandom < .3 then
			r.components.talker:Say("以我之名, 拿你项上人头!")
		elseif sayrandom < .15 then
			r.components.talker:Say("死亡终究会找到你!")
		elseif sayrandom < .15 then
			r.components.talker:Say("怎么样。我漂亮吗!")	
		end
	end
    return invader, true
    end
    local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end
	SetSharedLootTable( 'zg_ch_wendy',
	
    {
	{'icecream',          1.00},         
	{'icecream',          1.00},
	{'icecream',          1.00},
	{'icecream',          1.00},
	
    })
	
	if not TheWorld.ismastersim then
        return r
    end 
	
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
    r.components.locomotor.walkspeed= 1.5
    r.components.locomotor.runspeed = 2.5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)	
	r:SetStateGraph("SGzg_ch_wendy")
    local brain = require "brains/zg_ch_wilsonbrain"
    r:SetBrain(brain)
    r.components.health:SetMaxHealth(30000)
	r.components.health:StartRegen(20, 5 )
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.5)
    r.components.combat:SetDefaultDamage(150)						
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(3, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)	
	r:AddComponent("lootdropper")
	r.components.lootdropper:SetChanceLootTable('zg_ch_wendy')
	r:AddComponent("timer")
	r:ListenForEvent("timerdone", function(r, data)
		if data.name == "pound" then	
			r.canpound = true
			r.components.combat:SetRange(6)
		end
	end)
	r:DoPeriodicTask(480*5,function()	  
	r:Remove()		
	end)
	
end

AddPrefabPostInit("pigking", function(inst)                    -------------猪王不出了
  -- inst.xinrenqushanchu = inst:DoPeriodicTask(480*5, chuxian)
  -- inst.yuyan   = inst:DoPeriodicTask(480*5, function(inst)	
  -- TheNet:Announce("魔尊大人已出现在猪王附近")
  -- end)
end)

AddPrefabPostInit("critterlab", function(inst)            
   inst.xinrenqushanchu = inst:DoPeriodicTask(480*5, chuxian)     --------洞穴5天出一个
   inst.yuyan   = inst:DoPeriodicTask(480*5, function(inst)	
   TheNet:Announce("魔尊大人已出现在宠物地穴附近")
   end)
end)



function chuxian1(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild(buildname) 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike", "swap_elpheltbazooka", "swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(1, 1, 1)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔界第六天魔王")
	
	r.components.inspectable:SetDescription("魔界第六天魔王")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	local phys = r.entity:AddPhysics()
	phys:SetMass(100)
    phys:SetCapsule(.5, 1.5)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.GROUND)
	phys:CollidesWith(COLLISION.SANITY)
	phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
	r.Physics:SetCollisionCallback(oncollide)
	
    r.components.locomotor.walkspeed= 2.5
    r.components.locomotor.runspeed = 3.5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)
    r.components.health:SetMaxHealth(30000)
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.5)
	r:AddComponent("eater")  
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	
	r:SetStateGraph("SGmytuxingsun")
	local brain = require "brains/darktuxingsunbrain"
    r:SetBrain(brain)
	
	local function is_meat(item)
    return item.components.edible ~= nil  and item.components.edible.foodtype == FOODTYPE.MEAT
    end
	
	
	local function onequiptttspear(r, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    end
    local function onunequiptttspear(r, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    end

    local function GetInventoryTuxingsun(r)
	if r.components.inventory ~= nil and not r.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local meleeweapon = CreateEntity()
        meleeweapon.name = "tttspear"
        meleeweapon.entity:AddTransform()
        meleeweapon:AddComponent("weapon")
		meleeweapon:AddTag("zhuangbi")
        meleeweapon.components.weapon:SetDamage(30)
		meleeweapon.components.weapon:SetRange(.1)
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(r.Remove)
        meleeweapon:AddComponent("equippable")
			meleeweapon.components.equippable:SetOnEquip(onequiptttspear)
			meleeweapon.components.equippable:SetOnUnequip(onunequiptttspear)
			
        meleeweapon:AddTag("meleeweapon")
		r.components.inventory:GiveItem(meleeweapon)
		r.components.inventory:Equip(meleeweapon)
    end
    end
	
	local function TuxingsunRetargetFn(r)
    local defenseTarget = r
    local invader = nil
    invader = FindEntity(r, 25, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
				and (guy.components.inventory ~= nil and guy.components.inventory:FindItem(is_meat) ~= nil)
		or guy:HasTag("player")
    end)
	
	if invader then		
		----	有一定几率突击到攻击者
		if math.random() < .8 then
			r.components.talker:Say("我在这里呢")
			local a,b,c = invader.Transform:GetWorldPosition()	
			if math.random() < .15 then
				r.Transform:SetPosition(a+1.5,b,c+1.5)
			elseif math.random() < .15 then
				r.Transform:SetPosition(a+1.5,b,c-1.5)
			elseif math.random() < .15 then
				r.Transform:SetPosition(a-1.5,b,c+1.5)
			else 
				r.Transform:SetPosition(a-1.5,b,c-1.5)
			end			
			SpawnPrefab("collapse_small").Transform:SetPosition(r.Transform:GetWorldPosition())
			
			----突击单一伤害
			if invader.components.combat then
				invader.components.combat:GetAttacked(r, 20)
			end
			
		end
	end
	
    return invader
    end
    local function TuxingsunKeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end
	-----------------武器被击落
	local function LaunchItem77(r, target, item)
    if item.Physics ~= nil then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        local vel = (target:GetPosition() - r:GetPosition()):GetNormalized()
        local speed = 5 + math.random() * 2
        local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
        item.Physics:SetVel(math.cos(angle) * speed, 10, -math.sin(angle) * speed)
    end
    end

	
	
	local function tuxingsunattack(r,data)
    local victim = data.target
	
	if victim and victim:HasTag("player") then
		
		
		----	一定几率击落武器
		if math.random () < .2 then
			local item7 = victim.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if item7 then 
				victim.components.inventory:DropItem(item7)
				LaunchItem77(inst, victim, item7)
			end
		end
		
		----	10%几率的crush blow， 打掉玩家当前血量的1/8
		if math.random() < .15 then
			if victim.components.health and not victim.components.health:IsDead() then
				victim.components.health.currenthealth = victim.components.health.currenthealth * .875
			end
		end
	end
	
	----	对于非玩家非boss, 很高几率直接杀死
	if victim and not victim:HasTag("player") and not victim:HasTag("epic") then
		if math.random() < .85 then
			if victim.components.health and not victim.components.health:IsDead() then
				victim.components.health:Kill()
			end
		end
	end
	
	----	击中后瞬移
	SpawnPrefab("collapse_small").Transform:SetPosition(r.Transform:GetWorldPosition())
	local max_tries = 4
	for k = 1, max_tries do
		local x, y, z = r.Transform:GetWorldPosition()
		local offset = 10
		x = x + math.random(2 * offset) - offset          
		z = z + math.random(2 * offset) - offset
		if TheWorld.Map:IsPassableAtPoint(x, y, z) then
			r.Transform:SetPosition(x, y, z)
		break
		end
	end
	SpawnPrefab("collapse_small").Transform:SetPosition(r.Transform:GetWorldPosition())	
    end
	
	local function TuxingsunOnAttacked(r, data)
	local x,y,z = r.Transform:GetWorldPosition()
	local blood = SpawnPrefab("ice_splash")
	blood.Transform:SetPosition(x, 1.5, z)
    blood.AnimState:SetMultColour(175/255,0/255,0/255,1)
    blood.Transform:SetScale(1, 1, 1)
	
	SpawnPrefab("collapse_small").Transform:SetPosition(r.Transform:GetWorldPosition())
	local max_tries = 4
	for k = 1, max_tries do
		local x, y, z = r.Transform:GetWorldPosition()
		local offset = 10
		x = x + math.random(2 * offset) - offset          
		z = z + math.random(2 * offset) - offset
		if TheWorld.Map:IsPassableAtPoint(x, y, z) then
			r.Transform:SetPosition(x, y, z)
		break
		end
	end
	SpawnPrefab("collapse_small").Transform:SetPosition(r.Transform:GetWorldPosition())
	
    local attacker = data and data.attacker
	if attacker then
		if r.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			r.components.combat:SetTarget(attacker)
		end
	end
    end

    local function tuxingsunondeath(r)
	local x, y, z = r.Transform:GetWorldPosition()
    local skel = SpawnPrefab("cane")
    if skel ~= nil then
        skel.Transform:SetPosition(x, y, z)         
    end
    end
	
	r:AddComponent("lootdropper")  
	GetInventoryTuxingsun(r)   
    r.components.combat:SetDefaultDamage(60)				
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)
    r.components.combat.hiteffectsymbol = "torso"
	r.components.combat:SetRetargetFunction(2, TuxingsunRetargetFn)
    r.components.combat:SetKeepTargetFunction(TuxingsunKeepTargetFn)
    r:ListenForEvent("onattackother",tuxingsunattack)
    r:ListenForEvent("attacked", TuxingsunOnAttacked)
	r:ListenForEvent("death", tuxingsunondeath)
	
	
	r:DoPeriodicTask(960,function()	      ---第六天魔王2天后消失      4天一刷新 
	r:Remove()		
	end)

    return r
			
end

AddPrefabPostInit("statuemaxwell", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(480*4, chuxian1)
   inst.yuyan   = inst:DoPeriodicTask(480*4, function(inst)	
   TheNet:Announce("魔界第六天魔王已出现在老麦雕像附近")
   end)
end)




function chuxian2(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild(buildname) 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike", "swap_elpheltbazooka", "swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(1, 1, 1)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔界第九天魔王")
	r.components.inspectable:SetDescription("魔界第九天魔王")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	
		----	重定位目标
    local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 20, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .2 then
		    r.components.talker:Say("我是第九天魔王!")
		elseif sayrandom < .2 then
		    r.components.talker:Say("渺小的人类啊!死于这里吧")
		end
		
		----	有一定几率闪现到攻击者
		if math.random() < .5 then
			r.components.talker:Say("我闪!")
			local a,b,c = invader.Transform:GetWorldPosition()			
			if math.random() < .25 then
				r.Transform:SetPosition(a+5,b,c+5)
			elseif math.random() < .5 then
				r.Transform:SetPosition(a+5,b,c-5)
			elseif math.random() < .75 then
				r.Transform:SetPosition(a-5,b,c+5)
			else 
				r.Transform:SetPosition(a-5,b,c-5)
			end
			
			----突击伤害
			if invader.components.combat then
				invader.components.combat:GetAttacked(r, 50)
				r.components.combat:DoAttack(invader)
			end
		end		
	end
    return invader
    end
	
	local function KeepTargetFn(r, target)
         return r.components.combat:CanTarget(target)     
    end
	
	SetSharedLootTable( 'zg_ch2_wukong',
    {
	{'armorruins',          1.00},
	{'ruinshat',          1.00},
    })
	
	local function oncollide(r, other)
	if not other then
		return
	else
		if not other:IsValid() then
			return
		end
		----遇到障碍物就跳跃
		if r.components.health and not r.components.health:IsDead() and not (other:HasTag("shadowboss") or other:HasTag("projectile") or other:HasTag("character")) then
			r.sg:GoToState("jump")
		end
	end
    end
	
	----	击中玩家	特点
    local function onattack(r,data)
    local victim = data.target
	if victim then
		----	击中点燃玩家
		if victim.components.burnable and not victim.components.burnable:IsBurning()  then
			victim.components.burnable:Ignite()
		end
		if victim:HasTag("player") then
		end
	end
    end
	
	
	----	被攻击时
    local function OnAttacked(r, data)
	
	----	群体反攻玩家
    local attacker = data and data.attacker
	if attacker then
		if r.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			r.components.combat:SetTarget(attacker)
			----	小伙伴何在
			r.components.combat:ShareTarget(attacker, 100, function(dude)
				return dude and ( dude:HasTag("shadowboss") or dude:HasTag("monkey") )
			end, 20)
		end
	end
    end
	--------------物理
	local phys = r.entity:AddPhysics()
	phys:SetMass(100)
    phys:SetCapsule(.5, 1.5)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.GROUND)
	phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
	phys:CollidesWith(COLLISION.CHARACTERS)
	
	--------------执行碰撞
	r.Physics:SetCollisionCallback(oncollide)
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
    r.components.locomotor.walkspeed= 3.5
    r.components.locomotor.runspeed = 5.5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)
	
	r:SetStateGraph("SGzg_ch2_wukong")
	local brain = require "brains/zg_ch_wilsonbrain"
    r:SetBrain(brain)
	
    r.components.health:SetMaxHealth(30000)   ----先设定为三百
	r.components.health:StartRegen(10, 5)
	r.components.health.fire_damage_scale = 0
	r:AddComponent("leader")
    r.components.combat:SetDefaultDamage(36)						----常常不是空手, 因此无用
    r.components.combat:SetAttackPeriod(.5)
    r.components.combat:SetRange(4)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(2, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	r:ListenForEvent("onhitother", onattack)
	
	
	--	几率闪避
	local old_GetAttacked = r.components.combat.GetAttacked
	function r.components.combat.GetAttacked(attacker, damage, weapon, stimuli)
		local x,y,z = r.Transform:GetWorldPosition()
		if math.random() < .2 then
		   r.components.talker:Say("格挡!")
		  
			return						
		elseif math.random() < .2 then
		
		    r.components.talker:Say("闪避!")
			return
		else
			return old_GetAttacked(attacker, damage, weapon, stimuli)
		end
	end
	
	
	r:AddComponent("lootdropper")
	----	掉落
	r.components.lootdropper:SetChanceLootTable('zg_ch2_wukong')
	
	
	----	监听事件
    r:ListenForEvent("attacked", OnAttacked)
	
	r:AddComponent("inspectable")
	r.components.inspectable:SetDescription("第九天魔王!")
	
	r:DoPeriodicTask(960,function()	   ----两天消除
	r:Remove()		
	end)	
	return r	
end


AddPrefabPostInit("pigking", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(480*5, chuxian2)
   inst.yuyan   = inst:DoPeriodicTask(480*5, function(inst)	
   TheNet:Announce("魔界第九天魔王已出现在猪王附近")
   end)
end)




function chuxian3(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild(buildname) 
    r.AnimState:PlayAnimation("idle")
    local wuqis = {"swap_goldenaxe","swap_spear","swap_spike", "swap_elpheltbazooka", "swap_batbat","swap_ruins_bat"}
	local wuqi = wuqis[math.random(#wuqis)]
    r.AnimState:OverrideSymbol("swap_object", wuqi, wuqi)
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
	local hat = hats[math.random(#hats)]
    r.AnimState:OverrideSymbol("swap_hat",  hat, "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(1, 1, 1)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 2, 1.5 )
	r:AddComponent("named")	
	r.components.named:SetName("魔界至尊 百变女皇")
	r.components.inspectable:SetDescription("魔界至尊 百变女皇")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	
	
	----	重定位目标
    local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 30, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .1 then
			r.components.talker:Say("你以为美女就没有脾气么!")
		elseif sayrandom < .2 then
			r.components.talker:Say("站住！我只想要你的命而已！")
		end
	end
    return invader
    end
    local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end
	SetSharedLootTable( 'zg_ch1_luffy',
    {
	{'footballhat',          0.50},	
	{'armorwood',          0.50},
    })
	
	
	local function oncollide(r, other)
	if not other then
		return
	else
		if not other:IsValid() then
			return
		end
		if r.components.health and not r.components.health:IsDead() and not (other:HasTag("shadowboss") or other:HasTag("projectile") or other:HasTag("character")) then
			r.sg:GoToState("jump")
		end
	end
    end

    local function onattack(r,data)
    local victim = data.target
	if victim and victim:HasTag("player") then
		
	end
    end

    local function OnAttacked(r, data)
    local attacker = data and data.attacker
	if attacker then
		if r.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			r.components.combat:SetTarget(attacker)
			r.components.combat:ShareTarget(attacker, 100, function(dude)
				return dude:HasTag("shadowboss")	
			end, 20)
		end
	end
    end
	
	
	----	换挡变身
    local function bianshen(r)
	if r.components.health and not r.components.health:IsDead() then
		local state = r.zg_state
		if state == 0 then                   
			r.AnimState:SetBuild("wendy")
			r.components.locomotor.walkspeed= 8
			r.components.locomotor.runspeed = 10
			r.components.combat:SetDefaultDamage(80)
			r.components.health:SetAbsorptionAmount(.5)
			r.zg_state = 1
			
		elseif state == 1 then
		    r.components.talker:Say("变身威尔逊！")
			r.AnimState:SetBuild("wilson")              
			r.components.locomotor.walkspeed= 6
			r.components.locomotor.runspeed = 8
			r.components.combat:SetDefaultDamage(120)
			r.components.health:SetAbsorptionAmount(.6)
			r.zg_state = 2
			
		elseif state == 2 then
		    r.components.talker:Say("变身小丑！")
			r.AnimState:SetBuild("wes")              
			r.components.locomotor.walkspeed= 4
			r.components.locomotor.runspeed = 5
			r.components.combat:SetDefaultDamage(160)
			r.components.health:SetAbsorptionAmount(.7)	
			r.zg_state = 3
			
		elseif state == 3 then
		    r.components.talker:Say("变身老奶奶！")
			r.AnimState:SetBuild("wickerbottom")              
			r.components.locomotor.walkspeed= 4
			r.components.locomotor.runspeed = 5
			r.components.combat:SetDefaultDamage(200)
			r.components.health:SetAbsorptionAmount(.8)	
			r.zg_state = 4	
			
		elseif state == 4 then
		    r.components.talker:Say("变身火女！")
			r.AnimState:SetBuild("willow")              
			r.components.locomotor.walkspeed= 5
			r.components.locomotor.runspeed = 7
			r.components.combat:SetDefaultDamage(150)
			r.components.health:SetAbsorptionAmount(.7)	
			r.zg_state = 5	
        elseif state == 5 then
		    r.components.talker:Say("变身机器人！")	
			r.AnimState:SetBuild("wx78")              
			r.components.locomotor.walkspeed= 6
			r.components.locomotor.runspeed = 8
			r.components.combat:SetDefaultDamage(100)
			r.components.health:SetAbsorptionAmount(.8)	
			r.zg_state = 0			
		end
	end
    end
	
	
	local phys = r.entity:AddPhysics()
	phys:SetMass(100)
    phys:SetCapsule(.5, 1.5)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.GROUND)
	phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
	phys:CollidesWith(COLLISION.CHARACTERS)
	
	if not TheWorld.ismastersim then
        return r
    end 
	r.Physics:SetCollisionCallback(oncollide)
	
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
    r.components.locomotor.walkspeed= 3.5
    r.components.locomotor.runspeed = 5.5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)
	
    r:SetStateGraph("SGzg_ch1_luffy")

    local brain = require "brains/zg_ch_wolfgangbrain"
    r:SetBrain(brain)
	
    r.components.health:SetMaxHealth(30000)
	r.components.health:StartRegen(20, 5)
	r.components.health.fire_damage_scale = 1
	----	防御力
	r.components.health:SetAbsorptionAmount(.5)
	
	MakeMediumBurnableCharacter(r, "torso")
    r.components.burnable:SetBurnTime(TUNING.PLAYER_BURN_TIME)

	
	r:AddComponent("leader")
	
    r.components.combat:SetDefaultDamage(150)						
    r.components.combat:SetAttackPeriod(.75)
    r.components.combat:SetRange(3)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(2, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	r:ListenForEvent("onattackother", onattack)
	
	local old_GetAttacked = r.components.combat.GetAttacked
	function r.components.combat.GetAttacked(attacker, damage, weapon, stimuli)
		local x,y,z = r.Transform:GetWorldPosition()
		if math.random() < .2 then
			return						
		elseif math.random() < .2 then
			return
		else
			return old_GetAttacked(attacker, damage, weapon, stimuli)
		end
	end
	
	r:AddComponent("lootdropper")
	r.components.lootdropper:SetChanceLootTable('zg_ch1_luffy')
    r:ListenForEvent("attacked", OnAttacked)
	r.zg_state = 0
	r:DoPeriodicTask(15, bianshen)
	r:DoPeriodicTask(480*3,function()	     -------1000秒刷一次。。3天清理一次
	r:Remove()		
	end)
	
	    
	
	return r
	

end


AddPrefabPostInit("pigking", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(480*10, chuxian3)
   inst.yuyan   = inst:DoPeriodicTask(480*10, function(inst)	
   TheNet:Announce("魔界百变女皇已出现在猪王附近")
   end)
end)



----------------------------------------------------女武神
---------------------------------------------------

AddPrefabPostInit("beefalo",function(inst)

	if inst then
	   inst:AddComponent("named")
	   inst:AddComponent("lootdropper")
	   inst.components.health:SetMaxHealth(math.random(3000,7000))
	   inst.components.combat:SetDefaultDamage(math.random(30,70))
       inst.components.combat:SetAttackPeriod(math.random(0.5,2))
	   local  t = math.random(1,2.25)
	   inst.Transform:SetScale(t, t, t)	   
	   if  math.random() < 0.3 then 
       inst.components.named:SetName("火元素牛")
	   inst.components.lootdropper:SetLoot({"meat","meat","redgem","meat","beefalowool","beefalowool"})	  
       inst.AnimState:SetMultColour(1,0,0,1)	      
	   elseif math.random() < 0.4 then 
	   inst.components.named:SetName("雷元素牛")
	   inst.components.lootdropper:SetLoot({"meat","meat","bluegem","meat","beefalowool","beefalowool"})
	   inst.AnimState:SetMultColour(0,1,1,1)	   
	   elseif math.random() < 0.5 then 
	   inst.components.named:SetName("木元素牛")
	   inst.components.lootdropper:SetLoot({"meat","meat","greengem","meat","beefalowool","beefalowool"})
	   inst.AnimState:SetMultColour(1,1,0,1)   
	   elseif math.random() < 0.6 then 
	   inst.components.named:SetName("土元素牛")
	   inst.components.lootdropper:SetLoot({"meat","meat","yellowgem","meat","beefalowool","beefalowool"})
	   inst.AnimState:SetMultColour(205/255,155/255,29/255,1)
	   elseif math.random() < 0.7 then 
	   inst.components.named:SetName("风元素牛")
	   inst.components.lootdropper:SetLoot({"meat","meat","orangegem","meat","beefalowool","beefalowool"})
	   inst.AnimState:SetMultColour(1,105/255,180/255,1)
	   elseif math.random() < 0.8 then 
	   inst.components.named:SetName("金元素牛")
	   inst.components.lootdropper:SetLoot({"meat","meat","purplegem","meat","beefalowool","beefalowool"})
	   inst.AnimState:SetMultColour(1,185/255,15/255,1)
	   end
	   
	   
    end
end)	


------------------------------------------------报时模版

AddPrefabPostInit("pigking", function(inst)         
   inst.yuyan   = inst:DoPeriodicTask(500, function(inst)	

   
   TheNet:Announce(os.date("【报时】%Y年%m月%d日    %X",os.time()))	
   end)
end)





	

	

	
	
	