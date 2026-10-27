local assets =
{
    Asset("ANIM", "anim/gravestones.zip"),
    Asset("MINIMAP_IMAGE", "gravestones"),
}

local prefabs =
{
    "ghost",
    "mound",
}

local function onsave(inst, data)
    if inst.mound then
        data.mounddata = inst.mound:GetSaveRecord()
    end
    data.setepitaph = inst.setepitaph
end

local function onload(inst, data, newents)
    if data then
        if inst.mound and data.mounddata then
            if newents and data.mounddata.id then
                newents[data.mounddata.id] = {entity=inst.mound, data=data.mounddata} 
            end
            inst.mound:SetPersistData(data.mounddata.data, newents)
        end

        if data.setepitaph then
            --this handles custom epitaphs set in the tile editor
            inst.components.inspectable:SetDescription("'"..data.setepitaph.."'")
            inst.setepitaph = data.setepitaph
        end
    end
end

local function OnHaunt(inst)
    if inst.setepitaph == nil and #STRINGS.EPITAPHS > 1 then
        --change epitaph (if not a set custom epitaph)
        --guarantee it's not the same as b4!
        local oldepitaph = inst.components.inspectable.description
        local newepitaph = STRINGS.EPITAPHS[math.random(#STRINGS.EPITAPHS - 1)]
        if newepitaph == oldepitaph then
            newepitaph = STRINGS.EPITAPHS[#STRINGS.EPITAPHS]
        end
        inst.components.inspectable:SetDescription(newepitaph)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
    else
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
    end
    return true
end

local function CHUXIAN()
	local ground = TheWorld
	local centers = {}
	for i, node in ipairs(ground.topology.nodes) do
		if ground.Map:IsPassableAtPoint(node.x, 0, node.y) then
			table.insert(centers, {x = node.x, z = node.y})
		end
	end
	if #centers > 0 then
		local pos = centers[math.random(#centers)]
		return Point(pos.x, 0, pos.z)
	else
		return nil
	end
end





local function onhammered(inst, worker)
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()	
	local x, y, z = inst.Transform:GetWorldPosition()
			local r = SpawnPrefab("pigguard")
			r.Transform:SetPosition(x+5, 0, z-10)
			TheNet:Announce("[新闻]" ..worker.name.."在盗墓时惊醒传说中的【东方污神小小】")
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
			r:AddComponent("named")	
			r.components.named:SetName("东方污神 小小")
			local shadow = r.entity:AddDynamicShadow()
			shadow:SetSize( 2, 1.5 )
			r.components.inspectable:SetDescription("沉睡的灵魂？")
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
					r.components.talker:Say("我的沉睡是上天安排的结果!")
				elseif sayrandom < .3 then			
					r.components.talker:Say("你真该死！打扰了亡灵的休息")
				elseif sayrandom < .3 then			
					r.components.talker:Say("既然我已经复苏，那么拿命来吧")	
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
	
			r.components.locomotor.walkspeed= 3.5
			r.components.locomotor.runspeed = 5.5
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
	
	
	local pos = CHUXIAN()
	if pos then
			SpawnPrefab("gravestone").Transform:SetPosition( pos:Get() )
	end
	
end


local function onhammered1(inst, worker)
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()	
	
	
	local x, y, z = inst.Transform:GetWorldPosition()
			local r = SpawnPrefab("pigguard")
			r.Transform:SetPosition(x, 0, z)
			TheNet:Announce("[新闻]" ..worker.name.."在盗墓时惊醒传说中的【西方赌神老陈】")
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
			r.components.named:SetName("西方赌神 菜鸟老陈")
			r.components.inspectable:SetDescription("沉睡的亡灵老陈")
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
					r.components.talker:Say("弃我去者，昨日今日不可留")
				elseif sayrandom < .3 then
					r.components.talker:Say("乱我心者，今日明日多烦忧")
				elseif sayrandom < .3 then
					r.components.talker:Say("死者不能安息~!")	
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
	
			r.components.locomotor.walkspeed= 3.5
			r.components.locomotor.runspeed = 5.5
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
	local pos = CHUXIAN()
	if pos then
			SpawnPrefab("gravestone").Transform:SetPosition( pos:Get() )
	end
		

    
end


local function onhammered2(inst, worker)
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()	
	
	 local x, y, z = inst.Transform:GetWorldPosition()
			local r = SpawnPrefab("pigguard")
			r.Transform:SetPosition(x, 0, z)
			TheNet:Announce("[新闻]" ..worker.name.."在盗墓时惊醒传说中的【东方游侠队长】")
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
			r.components.named:SetName("东方游侠 二货队长")
			r.components.inspectable:SetDescription("队长的亡灵")
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
					r.components.talker:Say("兄弟，别开枪，是我呀")
				elseif sayrandom < .3 then
					r.components.talker:Say("哈哈，小子，你上当了")
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
	
			r.components.locomotor.walkspeed= 3.5
			r.components.locomotor.runspeed = 5.5
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
			
		local pos = CHUXIAN()
	if pos then
			SpawnPrefab("gravestone").Transform:SetPosition( pos:Get() )
	end
	


end

local function onhammered3(inst, worker)
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()	

    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
	TheNet:Announce("[新闻]" ..worker.name.."在盗墓时惊醒传说中的【牙仙宝宝小瞄】")
    r.AnimState:SetBank("wilson")
	local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
	local buildname = names[math.random(#names)]
    r.AnimState:SetBuild("elphelt") 
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
	r.components.named:SetName("牙仙宝宝 小喵")
	r.components.inspectable:SetDescription("魔界牙仙宝宝的亡灵")
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
				r.components.talker:Say("~早上好，朋友们~!")
			elseif sayrandom < .1 then
				r.components.talker:Say("牙仙宝宝 海星~~!")
			end
		else
			if sayrandom < .1 then
				r.components.talker:Say("天哪，人家的衣服又瘦了~!")
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
    r.components.locomotor.walkspeed= 4.25
    r.components.locomotor.runspeed = 5.25
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

    local pos = CHUXIAN()
	if pos then
			SpawnPrefab("gravestone").Transform:SetPosition( pos:Get() )
	end
	
	
	
end

local function onhammered4(inst, worker)
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()	
	
				
				local x, y, z = inst.Transform:GetWorldPosition()
		     	local r = SpawnPrefab("pigguard")
				r.Transform:SetPosition(x, 0, z)
				TheNet:Announce("[新闻]" ..worker.name.."在盗墓时惊醒传说中的【大魔天王亡灵】")
				r.AnimState:SetBank("wilson")
				local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
				local buildname = names[math.random(#names)]
				r.AnimState:SetBuild("wilson") 
				r.AnimState:PlayAnimation("idle")
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
				r.components.named:SetName("魔尊  大魔天王")
				r.components.inspectable:SetDescription("大魔天王亡灵")
				r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
				local light = r.entity:AddLight()
				light:SetFalloff(1)
				light:SetIntensity(.8)
				light:SetRadius(10)
				light:SetColour(180/255, 195/255, 50/255)
				light:Enable(true)
				r:AddTag("shadowboss")
				
				local function GetWeapon(r)
				if r.components.inventory ~= nil and not r.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
				local meleeweapon = CreateEntity()
				meleeweapon.entity:AddTransform()
				meleeweapon:AddComponent("weapon")
				meleeweapon.components.weapon:SetDamage(0)
				meleeweapon.components.weapon:SetRange(15, 19)
				meleeweapon.components.weapon:SetProjectile("zg_fx_luffyhand2")
				meleeweapon:AddComponent("inventoryitem")
				meleeweapon.persists = false
				meleeweapon.components.inventoryitem:SetOnDroppedFn(r.Remove)
				meleeweapon:AddComponent("equippable")
				meleeweapon:AddTag("meleeweapon")
				r.components.inventory:Equip(meleeweapon)
				end
				end
				
				local function RetargetFn(r)
				local invader = nil
				invader = FindEntity(r, 10 + 25, function(guy)
					return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
				end)
				----	敌视语句
				if invader then
					local sayrandom = math.random()
					if sayrandom < .3 then
						if r.components.talker then
							r.components.talker:Say("英雄不问出处，流氓不问岁数!")
						end
					end
					if sayrandom < .2 then
						if r.components.talker then
							r.components.talker:Say("天之道，损有余而补不足~!")
						end
					end
		
		
					if math.random() < .25 then
						----当和目标距离过大时使用橡胶手臂
						if not r:IsNear(invader, 10) then
							r.components.combat:SetTarget(invader)
							if not r.sg:HasStateTag("skill") then
								GetWeapon(r)
							end
						end
					end
		
				end
	
				return invader, true
				end
				local function KeepTargetFn(r, target)
					return r.components.combat:CanTarget(target)     
				end
				
				SetSharedLootTable( 'mozun',
                  {
				{'dragonpie',          1},
				{'dragonpie',          1},
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
	
				r:AddComponent("timer")
				
				r.components.locomotor.walkspeed= 2.5
				r.components.locomotor.runspeed = 3.5
				r.components.locomotor.fasteronroad = true
				r.components.locomotor:SetTriggersCreep(false)
				r:SetStateGraph("SGzg_ch2_luffy")

				local brain = require "brains/zg_ch_wolfgangbrain"
				r:SetBrain(brain)
				r.components.health:SetMaxHealth(20000)
				r.components.health:SetAbsorptionAmount(.7)
				r.components.combat:SetDefaultDamage( 150 )						
				r.components.combat:SetAttackPeriod( 2 )
				r.components.combat:SetRange(3)
				r.components.combat.hiteffectsymbol = "torso"
				r.components.combat:SetRetargetFunction(1, RetargetFn)
				r.components.combat:SetKeepTargetFunction(KeepTargetFn)
				
				r.components.combat:SetAreaDamage(2, 0.6)					----范围攻击
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
				r.components.lootdropper:SetChanceLootTable('mozun')
							
				r.canzhanfu = true
				r.canpound = true
				r:ListenForEvent("timerdone", function (r, data)

					if data.name == "zhanfu" then
						r.canzhanfu = true
					elseif data.name == "pound" then
						r.canpound = true
					end
					
				end)
	
	
	
	
	

	local pos = CHUXIAN()
	if pos then
		SpawnPrefab("gravestone").Transform:SetPosition( pos:Get() )
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .25)

    inst.MiniMapEntity:SetIcon("gravestones.png")

    inst:AddTag("grave")

    inst.AnimState:SetBank("gravestone")
    inst.AnimState:SetBuild("gravestones")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:PlayAnimation("grave"..tostring(math.random(4)))

    inst:AddComponent("inspectable")
    inst.components.inspectable:SetDescription(STRINGS.EPITAPHS[math.random(#STRINGS.EPITAPHS)])

    inst.mound = inst:SpawnChild("mound")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
	
	
    
	
	
	local name = ""
	local shuzi = math.random(1,5)
	if     shuzi == 1 then 
		name = "西方赌神老陈沉睡之所"
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetMultColour(1,0.84,0, 1)
	inst.components.workable:SetOnFinishCallback(onhammered1)
	elseif shuzi == 2 then 
		name = "东方游侠队长沉睡之所"
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetMultColour(1,0.84,0, 1)
	inst.components.workable:SetOnFinishCallback(onhammered2)
	elseif shuzi == 3 then  
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetMultColour(1,0.84,0, 1)
	inst.components.workable:SetOnFinishCallback(onhammered)
		name = "东方武神小小沉睡之所"	
		
	elseif shuzi == 4 then 
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetMultColour(1,0.84,0, 1)
	inst.components.workable:SetOnFinishCallback(onhammered3)
		name = "牙仙宝宝小喵沉睡之所"
		
	elseif shuzi == 5 then 
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetMultColour(1,0.84,0, 1)             ---c_give("gravestone")
	inst.components.workable:SetOnFinishCallback(onhammered4)
		name = "天界大魔天王沉睡之所"
	end
	
	

    inst:AddComponent("named")
	inst.components.named:SetName(name)
	
	
    inst.OnLoad = onload
    inst.OnSave = onsave

    inst.mound.Transform:SetPosition((TheCamera:GetDownVec()*.5):Get())

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	

    return inst
end

return Prefab("gravestone", fn, assets, prefabs)
