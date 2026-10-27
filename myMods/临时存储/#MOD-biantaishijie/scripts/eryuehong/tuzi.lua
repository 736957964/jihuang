

------------------------------GLOBAL

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	


------------------------------------------- c_give("rabbithouse")



local function tuzi(inst)

    if math.random() < 0.01 then
	    local x, y, z = inst.Transform:GetWorldPosition()
		
		local r = SpawnPrefab("bunnyman")
		r.Transform:SetPosition(x+5, 0, z-5) 
		r.Transform:SetScale(1.5, 1.5, 1.5)
		r.AnimState:SetBank("manrabbit")
		r.AnimState:SetBuild("manrabbit_beard_build")
		r.AnimState:SetMultColour(1,1,1,.5)
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
		
		----	重定位目标
		local function RetargetFn(r)
		local invader = nil
			invader = FindEntity(r, 10 + 15, function(guy)
				return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
			end)
		----	敌视语句
		if invader then
			local sayrandom = math.random()
			if sayrandom < .2 then
				r.components.talker:Say("小妞 小妞!")
			elseif sayrandom < .3 then
				r.components.talker:Say("给爷乐一个!")
			end
		end
		return invader
		end
		local function KeepTargetFn(r, target)
			return r.components.combat:CanTarget(target)     
		end
		
		r.components.locomotor.runspeed = 6 
		r.components.locomotor.walkspeed = 4 
		r.components.locomotor.fasteronroad = true
		r.components.locomotor:SetTriggersCreep(false)

		r.components.combat.hiteffectsymbol = "manrabbit_torso"
		r.components.combat:SetDefaultDamage(50)
		r.components.combat:SetAttackPeriod(1)
		r.components.combat:SetKeepTargetFunction(KeepTargetFn)
		r.components.combat:SetRetargetFunction(2, RetargetFn)
		
		----r:AddComponent("follower")
		
		r.components.health:SetMaxHealth(1000)
		r.components.inspectable:SetDescription("魔界暗黑大兔子")
		
		local brain = require "brains/zg_mo_bunnybrain"
		r:SetBrain(brain)
		r:SetStateGraph("SGzg_mo_bunny")
		
		
		return r
	end
end
		
		
AddPrefabPostInit("rabbithouse", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(60, tuzi)
   
end)		
		
		
		
		
		
		
		
		
		
		
		
		
		