


------------------------------GLOBAL

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	


-------------------------------------------
local function bianfu(inst)

    if math.random() < 0.01 then
	    local x, y, z = inst.Transform:GetWorldPosition()
		
		local r = SpawnPrefab("bat")
		r.AnimState:SetBank("bat")
        r.AnimState:SetBuild("bat_basic")
		r.Transform:SetPosition(x+5, 0, z-5) 
		r.Transform:SetScale(1.5, 1.5, 1.5)
		
		local light = r.entity:AddLight()
		light:SetFalloff(1)
		light:SetIntensity(.8)
		light:SetRadius(10)
		light:SetColour(180/255, 195/255, 50/255)
		light:Enable(true)
		r:AddTag("bat")
		r.Physics:SetCapsule(.25, 1)
		r.Physics:SetMass(1)
		r.Physics:SetDamping(5)
		r.Physics:SetCollisionGroup(COLLISION.FLYERS)
		r.Physics:ClearCollisionMask()
		r.Physics:CollidesWith(COLLISION.GROUND)
		r.Transform:SetTwoFaced()
		r.DynamicShadow:SetSize(.8, .5)
		
		local function BasicWakeCheck(r)
			return (r.components.combat ~= nil and r.components.combat.target ~= nil)
				or (r.components.homeseeker ~= nil and r.components.homeseeker:HasHome())
				or (r.components.burnable ~= nil and r.components.burnable:IsBurning())
				or (r.components.follower ~= nil and r.components.follower.leader ~= nil)
		end
		
		local function ShouldSleep(r)
			return TheWorld.state.isday and not BasicWakeCheck(r)
		end

		local function FindTarget(r, radius)
			return FindEntity(
			r,
			radius,
			function(guy)
				return guy
			end,
			{ "_combat", "character" },
			{ "INLIMBO", "monster" }
			)
		end
		
		
		
		
		local function ShouldWake(r)
			return not TheWorld.state.day
				or BasicWakeCheck(r)
				or FindTarget(r, 6)
		end

		local function EquipWeapon(r,slot)
			local slot=slot or 1
			if slot==1 then
				wy_virtual_weapon(r,50,nil,6,10,"fire_projectile")
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
		
		r.def=def
	
		r.wy_leader=nil
		r.wy_follower={}
		r:AddComponent("inventory")
		
		r.EquipWeapon=EquipWeapon
		EquipWeapon(r)
		
		r:AddComponent("lootdropper")
		r.components.lootdropper:AddRandomLoot("rocks", 1)
		r.components.lootdropper:AddRandomLoot("batwing", .1)
		r.components.lootdropper.numrandomloot = 1
		
		r.components.health:SetMaxHealth(1000)
		
		r.components.combat:SetDefaultDamage(50)
		r.components.combat:SetAttackPeriod(2)
		r.components.combat:SetRange(3, 3)
		r.components.combat.hiteffectsymbol =  "marker"
		r.components.combat:SetRetargetFunction(3, RetargetFn)
		r.components.combat:SetKeepTargetFunction(KeepTargetFn)
		r.components.inspectable:SetDescription("变异的蝙蝠")
		
		r.components.locomotor.runspeed = 2.5
		r.components.locomotor.walkspeed = 3.5
		r.components.locomotor:EnableGroundSpeedMultiplier(false)
		r.components.locomotor:SetTriggersCreep(false)

		r:AddComponent("sleeper")
		r.components.sleeper:SetResistance(3)
		r.components.sleeper:SetSleepTest(ShouldSleep)
		r.components.sleeper:SetWakeTest(ShouldWake)
		
		r.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
		r.components.eater:SetCanEatHorrible()
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
		
		
			--怪物的行为方式
	q1retarget(r,12,2,nil,function(guy,invader)
		if wy_getn(r.wy_follower)>0 then
			--队长紧急召唤
			guy.components.combat:wy_ShareTarget(invader,30,function(dude) 
				return dude and dude:HasTag("q1bat") and not dude.components.health:IsDead() end
			,30)
		else
			guy.components.combat:ShareTarget(invader,20,function(dude) 
				return dude and dude:HasTag("q1bat") and not dude.components.health:IsDead() end
			,5)
		end
	end)
	q1keeptarget(r)
	q1attacked(r,function(guy,invader)
		if wy_getn(r.wy_follower)>0 then
			--队长紧急召唤
			guy.components.combat:wy_ShareTarget(invader,30,function(dude) 
				return dude and dude:HasTag("q1bat") and not dude.components.health:IsDead() end
			,30)
		else
			guy.components.combat:ShareTarget(invader,20,function(dude) 
				return dude and dude:HasTag("q1bat") and not dude.components.health:IsDead() end
			,5)
		end
	end)
		
		
	r:SetStateGraph("q1bat_s")
	local brain=require ("brains/q1bat_b")
    r:SetBrain(brain)
		
		
			return r
		
		
		
		
	end
end	
		
		
		
AddPrefabPostInit("cave_entrance_open", function(inst)         
    inst.xinrenqushanchu = inst:DoPeriodicTask(60, bianfu)
   
end)	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		