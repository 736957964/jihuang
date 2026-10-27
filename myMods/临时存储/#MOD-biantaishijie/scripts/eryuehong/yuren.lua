
------------------------------GLOBAL

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	


-------------------------------------------




local function yuren(inst)

    if math.random() < 0.02 then
	    local x, y, z = inst.Transform:GetWorldPosition()
		local r = SpawnPrefab("merm")
		r.Transform:SetPosition(x, 0, z)
		r.Transform:SetScale(2, 2, 2)
		r.AnimState:SetBank("pigman")
		r.AnimState:SetBuild("merm_build")
		r.AnimState:SetMultColour(1,1,1,.5)
		r.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
		r.AnimState:Show("HAT")
		r.AnimState:Show("HAT_HAIR")
		r.AnimState:Hide("HAIR_NOHAT")
		r.AnimState:Hide("HAIR")
		
		
		
		
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
		
	local SLEEP_DIST_FROMTHREAT = 20
	local SLEEP_DIST_FROMHOME_SQ = 1 * 1
	local _healthPercent = nil
	local _isSetHome = false
	----self.inst = inst	
		
local function _BasicWakeCheck(r)
    return (r.components.combat ~= nil and r.components.combat.target ~= nil)
        or (r.components.burnable ~= nil and r.components.burnable:IsBurning())
        or (r.components.freezable ~= nil and r.components.freezable:IsFrozen())
        or GetClosestInstWithTag("player", r, SLEEP_DIST_FROMTHREAT) ~= nil
end

local function ShouldSleep(r)
    local homePos = r.components.knownlocations:GetLocation("home")
    return homePos ~= nil
        and r:GetDistanceSqToPoint(homePos:Get()) < SLEEP_DIST_FROMHOME_SQ
        and not _BasicWakeCheck(r)
end

local function ShouldWake(r)
    local homePos = r.components.knownlocations:GetLocation("home")
    return (homePos ~= nil and
            r:GetDistanceSqToPoint(homePos:Get()) >= SLEEP_DIST_FROMHOME_SQ)
        or _BasicWakeCheck(r)
end

local function RememberKnownLocation(r)

	if not _isSetHome then
		r.components.knownlocations:RememberLocation("home", r:GetPosition())
		_isSetHome = true
	end

end

local function Retarget(r)
    return FindTarget(r, TUNING.SPIDER_WARRIOR_TARGET_DIST)
end

--鱼鱼远程冰冻
local function MakeWeapon(r)
    if r.components.inventory ~= nil then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        MakeInventoryPhysics(weapon)
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(45)
        weapon.components.weapon:SetRange(r.components.combat.attackrange, r.components.combat.attackrange + 2)
		--weapon.components.weapon:SetRange(10,14)
        weapon.components.weapon:SetProjectile("ice")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
        weapon:AddComponent("equippable")
        r.weapon = weapon
        r.components.inventory:Equip(r.weapon)
        r.components.inventory:Unequip(EQUIPSLOTS.HANDS)
		
    end
end

local function onTimerDone(r, data)
	if data.name == "Freezing" then
		r.canfreezing = true
	elseif data.name == "Togglestate" then
		if not r.cantogglestate then 
			r.cantogglestate = true
			r.components.combat:SetDefaultDamage(70)
			r.components.combat:SetAttackPeriod(0.7)
			r.components.combat:SetRange(12, 14)
		else
			r.cantogglestate = false
			r.components.combat:SetDefaultDamage(70)
			r.components.combat:SetAttackPeriod(2.5)
			r.components.combat:SetRange(3, 4)
		end
		--print("toggle!!!! ")
		if not (r.components.timer:TimerExists("Togglestate")) then
		--print("start timer!!!")
			r.components.timer:StartTimer("Togglestate", MERM_TOGGLE_COOLDOWN)
		end
 	end
end
    
	if r.components.sleeper ~= nil then
	
	r.components.sleeper:SetSleepTest(ShouldSleep)
	r.components.sleeper:SetWakeTest(ShouldWake)
			
	end

	
	local origCanTarget = r.components.combat.keeptargetfn
	local function keepTargetOverride(r, target)
	-- TODO: Testing this 
	if true then
		return r.components.combat:CanTarget(target)
	end
	-- This wont get hit. Was original code. TODO : if above is better, remove this.
	if target:HasTag("player") and r.components.combat:CanTarget(target) then
		return true
	else
		return origCanTarget and origCanTarget(r,target)
	end
	end
	r.components.combat:SetKeepTargetFunction(keepTargetOverride)

		
		
	local function retargetfn(r)
	-- Give all mobs same search dist as hounds
	local dist = 15		
	local invader = nil
	invader = FindEntity(r, dist, function(guy)
		return guy:HasTag("player") and not guy:HasTag("wave_monster") and not guy:HasTag("playerghost")
	end)
	
	return invader
	end
	if not r.components.teamattacker then
        r.components.combat:SetRetargetFunction(2, retargetfn)
	end	
	
	r.components.health:SetMaxHealth(4000)
	r.components.health:StartRegen(400, 100)
	if _healthPercent ~= nil then
			r.components.health:SetPercent(_healthPercent)
	end
	
	
	--战斗力强不强
r.components.combat:SetDefaultDamage(70)
r.components.combat:SetAttackPeriod(2)
r.components.combat:SetRange(12, 14)--第一个参数为攻击距离，第二个为能够击中的距离
r.components.locomotor.walkspeed= 1
r.components.locomotor.runspeed = 2

--技能学了么
r:AddComponent("timer")
r.canfreezing = false
r.cantogglestate = false
r:ListenForEvent("timerdone", onTimerDone)
if not r.components.inventory then
	r:AddComponent("inventory")
end
MakeWeapon(r)


--家在哪儿
if not r.components.inspectable then
	r:AddComponent("inspectable")
end
if not r.components.knownlocations then
	r:AddComponent("knownlocations")
end
r:DoTaskInTime(0, RememberKnownLocation)

--智商咋样
local MermKingBrain = require "brains/mermkingbrain"
r:SetBrain(MermKingBrain)
r:SetStateGraph("SGmermking")

end
end
	
			
AddPrefabPostInit("mermhouse", function(inst)         
   inst.xinrenqushanchu = inst:DoPeriodicTask(60, yuren)
   ---inst.xinrenqushanchu = inst:DoPeriodicTask(60, bianshenzhu)
end)
	
	
	
		
		
		
		