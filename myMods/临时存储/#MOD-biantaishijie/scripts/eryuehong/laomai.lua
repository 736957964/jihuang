

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	





function laomai(inst)

    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
	TheNet:Announce("魔界麦斯威尔已出现在猪王附近")
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
	r.components.inspectable:SetDescription("魔界麦斯威尔")
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
	
	
	
	
	----	重定位目标
	local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 10 + 15 , function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	
    return invader, true
	end
	local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
	end
	
	SetSharedLootTable( 'zg_ch_waxwell',
	{
	{'nightsword',          0.02},
	
	{'fruitmedley',          1.00},
	{'fruitmedley',          0.50},
	
	})
	
	
	----	衣服被砍掉
local function LaunchItem1(r, target, item)
    if item.Physics ~= nil then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        local vel = (target:GetPosition() - r:GetPosition()):GetNormalized()
        local speed = 5 + math.random() * 2
        local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
        item.Physics:SetVel(math.cos(angle) * speed, 10, -math.sin(angle) * speed)
    end
end

----	击中玩家	特点	--模板
local function onattack(r,data)
    local victim = data.target
	if victim and victim:HasTag("player") then
		
		----	一定几率砍掉帽子
		if math.random () < .5 then
			local item3 = victim.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			if item3 then 
				victim.components.inventory:DropItem(item3)
				LaunchItem1(r, victim, item3)
			end
		end
		
		----	一定几率把玩家打扁
		if math.random () < .5  then
			if victim.components.zg_sizechange then
				victim.components.zg_sizechange:StartChange(.33, 10)
			end
		end
		
	end
end


----	武器样式
local function onequip(r, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword", "swap_nightmaresword")
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
        meleeweapon.components.weapon:SetDamage(60)
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
	
	
	r.components.locomotor.walkspeed= 4
    r.components.locomotor.runspeed = 5
	r.components.locomotor.fasteronroad = false
	r.components.locomotor:SetTriggersCreep(false)
	
	r.NumPerdsToSpawn = NumPerdsToSpawn
	
	r:SetStateGraph("SGzg_ch_waxwell")

    local brain = require "brains/zg_ch_wilsonbrain"		
    r:SetBrain(brain)
	
	r.components.health:SetMaxHealth(10000)
	r.components.health:StartRegen(2, 5)
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.85)
	
	r:AddComponent("leader")
	
	r.components.combat:SetDefaultDamage( 60 )						----常常不是空手, 因此无用
    r.components.combat:SetAttackPeriod( 2 )
    r.components.combat:SetRange(2)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(3, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	r:ListenForEvent("onattackother", onattack)
	
	

    r:AddComponent("lootdropper")
	----	掉落
	r.components.lootdropper:SetChanceLootTable('zg_ch_waxwell')
	
	
	GetInventory(r)
	
	r:AddComponent("timer")
	r:ListenForEvent("timerdone", function(r, data)
		if data.name == "pound" then	--暗影闪电
			r.canpound = true
		end
	end)
	
	
    return r
end
	
AddPrefabPostInit("pigking", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(480*10, laomai)
end)
	
	
	
	
	
	
	
	
	
	