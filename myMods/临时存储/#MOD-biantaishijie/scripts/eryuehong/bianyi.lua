
----智能敌对变异机制----
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
----蝴蝶
local function butterfly_change(inst)
	if inst then
		if GLOBAL.TheWorld.ismastersim then
			inst:DoPeriodicTask(10, function()   ----30秒变异
				if inst then
					if math.random() < 0.8 then  ----测试先80%几率生成
						inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/lucy_warn_"..math.random(3) )
						inst:DoTaskInTime(1, function()
						    if math.random() < 0.8 then
							local x, y, z = inst.Transform:GetWorldPosition()
							local r = SpawnPrefab("butterfly") 
							      r.Transform:SetPosition(x+5, 0, z-5) 
							      r.Transform:SetScale(2.5, 2.5, 2.5)
								  r.AnimState:SetBuild("butterfly_basic")
                                  r.AnimState:SetBank("butterfly")
								  
							      local light = r.entity:AddLight()
			                      light:SetFalloff(1)
			                      light:SetIntensity(.8)
			                      light:SetRadius(10)
		                          light:SetColour(180/255, 195/255, 50/255)
			                      light:Enable(true)
								  r:AddTag("butterfly")
								  r.Physics:SetCapsule(.25, 1)
							      r.Physics:SetMass(1)
								  r.Physics:SetDamping(5)
								  r.Physics:SetCollisionGroup(COLLISION.FLYERS)
								  r.Physics:ClearCollisionMask()
								  r.Physics:CollidesWith(COLLISION.GROUND)
								  r.Transform:SetTwoFaced()
								  r.DynamicShadow:SetSize(.8, .5)
								 ---- r:AddComponent("lootdropper")
                                  r.components.lootdropper:AddRandomLoot("butter", 0.3)
                                  r.components.lootdropper:AddRandomLoot("butterflywings", 5)
								  r.components.health:SetMaxHealth(500)
								 --- r:AddComponent("combat")
								  r.components.combat:SetDefaultDamage(50)
                                  r.components.combat:SetAttackPeriod(1)
								  r.components.combat:SetRange(6,8)
							      r.components.locomotor.runspeed = 3
	                              r.components.locomotor.walkspeed = 3
								  local function EquipWeapon(r,slot)
	                              local slot=slot or 1
	                              if slot==1 then
	                            	 wy_virtual_weapon(r,50,nil,8,12,"fire_projectile",nil,nil,nil,"wy_dark")
	                              elseif slot==2 then
		                             wy_virtual_weapon(r,80,1,8,12,"ice_projectile",nil,nil,nil,"wy_dark")
	                              end
                                  end	
								  r.EquipWeapon=EquipWeapon
                                  EquipWeapon(r)
								  r:AddComponent("pollinator")
                                  r.pollinator=0
	
	                              r:ListenForEvent("toolbroke",function(r,data)
		                          EquipWeapon(r)
	                              end)
	                              r:ListenForEvent("onhitother",function(r,data)
		                             if r.pollinator>0 then
			                            r.pollinator=r.pollinator-1
		                             end
	                              end)
                                  r:SetStateGraph("q1butterfly_s")
								  local brain = require "brains/q1butterfly_b"	
                                  r:SetBrain(brain)
															  
								  return r 
							end
							-----GLOBAL.SpawnPrefab("statue_transition").Transform:SetPosition(x,y,z)
							inst:Remove()
						end)
						---inst:Remove()
					end
					--inst:Remove()
				end
			end)
		end
	end
end

local function SBWANYI(item,n)
	for i,v in ipairs(GLOBAL.AllPlayers) do
		if v.is_admin == nil and not v:HasTag("playerghost") 
		and v.components.health 
		and v.components.health.currenthealth > 0     then
			for j=1,n or 1 do
				local dubloon = GLOBAL.SpawnPrefab(item)
				if dubloon ~= nil then
					v.components.inventory:GiveItem(dubloon)        -----   SBWANYI("bluegem",1)
				end
			end									
		end
	end
end


AddPrefabPostInit("dragonfly", function (inst)
    local function siwangongao(inst, data)
        TheNet:Announce("太牛逼了！！世界BOSS〖 "..inst:GetDisplayName().." 〗终于被【 "..data.attacker:GetDisplayName().." 】击杀")
		TheNet:Announce("〖 这个世界所有玩家即将获得击杀"..inst:GetDisplayName().."奖励boss大礼包！！〗")
    end

    local function siwang(inst)
        inst:ListenForEvent("attacked", siwangongao)
    end

    local function dospawnchest(inst)
	  SBWANYI("bluegem",20) 
	  SBWANYI("greengem",10) 
    end
    local function spawnchest(inst)
        inst:DoTaskInTime(6, dospawnchest)
    end


    inst:ListenForEvent("death", siwang)
    inst:ListenForEvent("death", spawnchest)
end)


-----------c_give("dragonfly")




AddPrefabPostInit("world", function(inst)			
	if TheWorld.ismastersim then
	   inst:AddComponent("zg_superboss")	       --超级boss
			inst:DoTaskInTime(0, function()
				inst.components.zg_superboss:TrySpawn()
			end)
	end
end)
	 
	 
	 
function chuxian0(inst)
    if math.random() < 0.05 then
    local x, y, z = inst.Transform:GetWorldPosition()
    local r = SpawnPrefab("pigguard")
    r.Transform:SetPosition(x, 0, z)
	TheNet:Announce("魔界若水三千已出现在猪王附近")
    r.AnimState:SetBank("wilson")
    r.AnimState:SetBuild("willow") 
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
	r.components.inspectable:SetDescription("魔界若水三千")
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
    invader = FindEntity(r, 10 + 25, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .05 then
			if r.components.talker then
				r.components.talker:Say("我要成为世界第一美女!")
			end
		end
			
		if wy_isalive(invader) and math.random()<.2 
			and not r.sg:HasStateTag("skill")
			then
			r:PushEvent("zg_ch1_zoro_sanqian",{target=invader})
		end
	end
    return invader
end
local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
end
	
SetSharedLootTable( 'zg_ch1_zoro',
{
	{'turkeydinner',          1},
	{'turkeydinner',          1},
	
	{'zg_zorohead', 		.33},
})
-----------------------------------------------------------------------------------------------------

----	击中玩家	特点	--模板
local function onattack(r,data)
    local victim = data.target
	if victim and victim:HasTag("player") then
	end
end
----	武器样式
local function onequip(r, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
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
		--meleeweapon.components.weapon:SetRange(12, 16)
		--meleeweapon.components.weapon:SetProjectile("zg_fx_zorotornado")
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
	
	
    ----	状态图和AI
    r:SetStateGraph("SGzg_ch1_zoro")

    local brain = require "brains/zg_ch1_zorobrain"
    r:SetBrain(brain)
	
	r.components.health:SetMaxHealth(20000)
	r.components.health.fire_damage_scale = 0
	----	防御力
	r.components.health:SetAbsorptionAmount(.65)
    
	r.components.combat:SetDefaultDamage(60)						----常常不是空手, 因此无用
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(1, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)


	r.components.combat:SetAreaDamage(2, 1)					----范围攻击
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
	r.components.lootdropper:SetChanceLootTable('zg_ch1_zoro')
	
	
	r:AddComponent("timer")
	r.canpound = true
	r.canpound2 = true
	r:ListenForEvent("timerdone", function (r, data)

		if data.name == "pound" then	----烦恼风
			r.canpound = true
		elseif data.name == "pound2" then	----死亡新月
			r.canpound2 = true
		end
		
	end)
	
    return r
    end
end
	
	
AddPrefabPostInit("pigking", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(480, chuxian0)
  -- inst.yuyan   = inst:DoPeriodicTask(20, function(inst)	
  -- TheNet:Announce("魔界若水三千已出现在猪王附近")
  -- end)
end)

	
	
	
	
	
	
	
	
	
	
	




