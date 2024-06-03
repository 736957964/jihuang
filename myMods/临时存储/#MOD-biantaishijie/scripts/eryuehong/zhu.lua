
------------------------------GLOBAL

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	


-------------------------------------------




local function zhu(inst)

    if math.random() < 0.02 then
	    local x, y, z = inst.Transform:GetWorldPosition()
		local r = SpawnPrefab("pigman")
		r.Transform:SetPosition(x, 0, z)
		r.Transform:SetScale(1.5, 1.5, 1.5)
		r.AnimState:SetBank("pigman")
		r.AnimState:SetBuild("werepig_build")
		r.AnimState:SetMultColour(1,1,1,.5)
		local light = r.entity:AddLight()
		light:SetFalloff(1)
		light:SetIntensity(.8)
		light:SetRadius(10)
		light:SetColour(180/255, 195/255, 50/255)
		light:Enable(true)
		r:AddTag("pigman")
		r.Physics:SetCapsule(.25, 1)
		r.Physics:SetMass(1)
		r.Physics:SetDamping(5)
		r.Physics:SetCollisionGroup(COLLISION.FLYERS)
		r.Physics:ClearCollisionMask()
		r.Physics:CollidesWith(COLLISION.GROUND)
		r.Transform:SetTwoFaced()
		r.DynamicShadow:SetSize(.8, .5)
		
		
		----	重定位目标
		local function RetargetFn(r)
			local invader = nil
			invader = FindEntity(r, 10, function(guy)
			return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
		end)
		return invader, true
		end
		local function KeepTargetFn(r, target)
				return r.components.combat:CanTarget(target)     
		end
		
		----	被攻击时
		local function OnAttacked(r, data)
    
		----	群体反攻玩家
		local attacker = data and data.attacker
		if attacker then
		if r.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			r.components.combat:SetTarget(attacker)
			----	小伙伴何在
			r.components.combat:ShareTarget(attacker, 20, function(dude)
				return dude:HasTag("pigman")	
			end, 5)
		end
		end
		end
		
		----击中别人
		local function OnHitOther(r, data)
		local other = data.target
		if other and other.components.freezable then
			other.components.freezable:AddColdness(2)
			other.components.freezable:SpawnShatterFX()
		----刺骨的寒冷
			if other.components.temperature then
				other.components.temperature:DoDelta(-60)
			end
		
		----一定几率击倒玩家
			if other:HasTag("player") and not ( other.components.health and other.components.health:IsDead() ) then
			if math.random() < .33 * (r.zg_freezemult or 1) then
				other:PushEvent("zg_buff_knockout")
			end
			end
			end
		end

		local function onattack(r,data)
		---inst.SoundEmitter:PlaySound("zg_cr_icepig/zg_cr_icepig/atk")
		end	
		
		SetSharedLootTable( 'zg_cr_icepig',
		{
		{'ice',          1},
		{'ice',          1},
		{'meat',          1},
		})	
		
		
		r.components.locomotor.runspeed = 5 
		r.components.locomotor.walkspeed = 3 
		r.components.locomotor.fasteronroad = true
		r.components.locomotor:SetTriggersCreep(true)	
		
		r.components.combat.hiteffectsymbol = "pig_torso"
		r.components.combat:SetDefaultDamage( 66 * 1 )
		r.components.combat:SetAttackPeriod( 3 - 1 )
		r.components.combat:SetRange(2)
		r.components.combat:SetKeepTargetFunction(KeepTargetFn)
		r.components.combat:SetRetargetFunction(3, RetargetFn)	
		
		r:AddComponent("lootdropper")
		----	掉落
		r.components.lootdropper:SetChanceLootTable('zg_cr_icepig')
	
		r.components.health:SetMaxHealth(666)
	
		r.components.inspectable:SetDescription("变异的冰猪")
	
	
		local brain = require "brains/zg_cr_icepigbrain"
		r:SetBrain(brain)
		r:SetStateGraph("SGzg_cr_icepig")
	
		r:ListenForEvent("attacked", OnAttacked)
		
		r.zg_freezemult = 1
		r:ListenForEvent("onhitother", OnHitOther)	
		return r
		end


end


local function bianshenzhu(inst)

    if math.random() < 0.02 then
	    local x, y, z = inst.Transform:GetWorldPosition()
		local r = SpawnPrefab("pigman")
		r.Transform:SetPosition(x, 0, z)
		r.Transform:SetScale(1.5, 1.5, 1.5)
		r.AnimState:SetBank("pigman")
		r.AnimState:SetBuild("werepig_build")
		r.AnimState:SetMultColour(1,1,1,.5)
		local light = r.entity:AddLight()
		light:SetFalloff(1)
		light:SetIntensity(.8)
		light:SetRadius(10)
		light:SetColour(180/255, 195/255, 50/255)
		light:Enable(true)
		r:AddTag("pigman")
		r.Physics:SetCapsule(.25, 1)
		r.Physics:SetMass(1)
		r.Physics:SetDamping(5)
		r.Physics:SetCollisionGroup(COLLISION.FLYERS)
		r.Physics:ClearCollisionMask()
		r.Physics:CollidesWith(COLLISION.GROUND)
		r.Transform:SetTwoFaced()
		r.DynamicShadow:SetSize(.8, .5)
		
		
		----	重定位目标
		local function RetargetFn(r)
			local invader = nil
			invader = FindEntity(r, 10, function(guy)
			return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
		end)
		
		if invader then
		local sayrandom = math.random()
		if sayrandom < .2 then
			if r.components.talker then
				r.components.talker:Say("猪人的世界你们不懂!")
			end
		end
		if sayrandom < .3 then
			if r.components.talker then
				r.components.talker:Say("你看的都是幻觉!")
			end
		end
		end
		
		
		
		
		return invader, true
		end
		
		
		
		
		local function KeepTargetFn(r, target)
				return r.components.combat:CanTarget(target)     
		end
		
		----	被攻击时
		local function OnAttacked(r, data)
    
		----	群体反攻玩家
		local attacker = data and data.attacker
		if attacker then
		if r.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			r.components.combat:SetTarget(attacker)
			----	小伙伴何在
			r.components.combat:ShareTarget(attacker, 20, function(dude)
				return dude:HasTag("pigman")	
			end, 5)
		end
		end
		end
		
		----击中别人
		local function OnHitOther(r, data)
		local other = data.target
		if other and other.components.freezable then
			other.components.freezable:AddColdness(2)
			other.components.freezable:SpawnShatterFX()
		----刺骨的寒冷
			if other.components.temperature then
				other.components.temperature:DoDelta(-60)
			end
		
		----一定几率击倒玩家
			if other:HasTag("player") and not ( other.components.health and other.components.health:IsDead() ) then
			if math.random() < .33 * (r.zg_freezemult or 1) then
				other:PushEvent("zg_buff_knockout")
			end
			end
			end
		end

		local function onattack(r,data)
		---inst.SoundEmitter:PlaySound("zg_cr_icepig/zg_cr_icepig/atk")
		end	
		
		
		SetSharedLootTable( 'zg_cr_icepig0',
		{
		{'ice',          1},
		{'ice',          1},
		{'ice',          1},
		{'ice',          1},
	
		{'meat',          1},
		{'meat',          1},
		})
		
		r.components.locomotor.runspeed = 5 
		r.components.locomotor.walkspeed = 3 
		r.components.locomotor.fasteronroad = true
		r.components.locomotor:SetTriggersCreep(true)	
		
		r.components.combat.hiteffectsymbol = "pig_torso"
		r.components.combat:SetAttackPeriod( 3 - 1 )
		r.components.combat:SetRange(2)
		r.components.combat:SetKeepTargetFunction(KeepTargetFn)
		r.components.combat:SetRetargetFunction(3, RetargetFn)	
		
		
		r.components.health:SetMaxHealth(1600)
		r.components.combat:SetDefaultDamage(99 * 1)
		r.components.combat:SetRange(2.5)
		
		
		r.zg_freezemult = 2
	    r.zg_canchange = true
	
	    local brain0 = require "brains/zg_cr_iceborebrain"
		
		r:ListenForEvent("healthdelta", function()
		if r.zg_canchange == true then
			----血低了就变身
			if r.components.health.currenthealth < 1590 then   ---血量
				r.AnimState:SetBuild("pig_build")
				r.Transform:SetScale(3, 3, 3)
				r.components.talker:Say("猪皇幻象!")
				r.components.locomotor.runspeed = 2.5
				r:SetStateGraph("SGzg_cr_icebore")
				
				r.components.combat:SetDefaultDamage(99 * 1)
				r.components.combat:SetAttackPeriod(3 - 1)
				
				r:SetBrain(brain0)
				r.zg_canchange = false
			end
		end
		end)
	
		r.components.lootdropper:SetChanceLootTable('zg_cr_icepig0')
	
		return r
		
		end
end
		
		







	
	
		
AddPrefabPostInit("pighouse", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(60, zhu)
   inst.xinrenqushanchu = inst:DoPeriodicTask(60, bianshenzhu)
end)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	