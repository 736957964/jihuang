


------------------------------GLOBAL

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	


-------------------------------------------



local function hudie(inst)

    if math.random() < 0.01 then
	    local x, y, z = inst.Transform:GetWorldPosition()
		local r = SpawnPrefab("butterfly")
	    r.Transform:SetPosition(x+5, 0, z-5) 
		r.Transform:SetScale(1.5, 1.5, 1.5)
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
		
		local function EquipWeapon(r,slot)
			local slot=slot or 1
			if slot==1 then
				wy_virtual_weapon(r,60,nil,8,12,"fire_projectile",nil,nil,nil,"wy_dark")
			elseif slot==2 then
				wy_virtual_weapon(r,80,1,8,12,"ice_projectile",nil,nil,nil,"wy_dark")
			end
		end	
		
		local function RetargetFn(r)
			local invader = nil
			invader = FindEntity(r, 3 + 15, function(guy)
				return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
			end)
			return invader
		end
		local function KeepTargetFn(r, target)
				return r.components.combat:CanTarget(target)     
		end
		
		r.EquipWeapon=EquipWeapon
		EquipWeapon(r)
		r:AddComponent("lootdropper")
		r.components.lootdropper:AddRandomLoot("butter", 0.3)
		r.components.lootdropper:AddRandomLoot("butterflywings", 2)
		r.components.lootdropper.numrandomloot = 3
		r.components.health:SetMaxHealth(1000)
		
		r.components.combat:SetDefaultDamage(30)
		r.components.combat:SetAttackPeriod(1)
		r.components.combat:SetRange(5,7)
		----r.components.combat.hiteffectsymbol =  "marker"
		r.components.combat.hiteffectsymbol = "butterfly_body"
		r.components.combat:SetRetargetFunction(3, RetargetFn)
		r.components.combat:SetKeepTargetFunction(KeepTargetFn)
		r.components.inspectable:SetDescription("变异蝴蝶")
		
		r.components.locomotor.runspeed = 2.5
		r.components.locomotor.walkspeed = 3.5
		r.components.locomotor:EnableGroundSpeedMultiplier(false)
		r.components.locomotor:SetTriggersCreep(false)
		
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
		
		q1retarget(r,9)
		q1keeptarget(r)
		q1attacked(r)
		
		
		
		r:SetStateGraph("q1butterfly_s")
		local brain=require ("brains/q1butterfly_b")
		r:SetBrain(brain)
	
		r.OnSave=function(r,data)
			data.pollinator=r.pollinator
		end
		r.OnLoad=function(r,data)
			if data then
				r.pollinator=data.pollinator or 0
			end
		end
		
		
		
		
		
		
		return r
		
		
		
		
	end
end
	

AddPrefabPostInit("flower", function(inst)         
    inst.xinrenqushanchu = inst:DoPeriodicTask(150, hudie)
   
end)







