local assets =
{
    Asset("ANIM", "anim/frog.zip"),
    Asset("ANIM", "anim/myth_small_goldfrog.zip"),	
    Asset("SOUND", "sound/frog.fsb"),
}

local prefabs =
{
    "myth_coin",
}

local brain = require "brains/frogbrain"

local RESTARGET_MUST_TAGS = {"_combat","_health","player"}
local function retargetfn(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        return FindEntity(inst, 24, function(guy) 
            if not guy.components.health:IsDead() then
                return guy.components.inventory ~= nil
            end
        end,
        RESTARGET_MUST_TAGS -- see entityreplica.lua
        )
    end
end

local function ShouldSleep(inst)
    return false -- frogs either go to their home, or just sit on the ground.
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    --inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5)
end

local function OnGoingHome(inst)
    SpawnPrefab("frogsplash").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function tryconsume(self, v, amount)
    if v.components.stackable == nil then
        self:RemoveItem(v):Remove()
        return 1
    elseif v.components.stackable.stacksize > amount then
        v.components.stackable:SetStackSize(v.components.stackable.stacksize - amount)
        return amount
    else
        amount = v.components.stackable.stacksize
        self:RemoveItem(v, true):Remove()
        return amount
    end
    return 0
end

local function Container_ConsumeByTag(self,tag, amount)
    if amount <= 0 then
        return false
    end
    for k, v in pairs(self.slots) do
        if v:HasTag(tag) then
            amount = amount - tryconsume(self, v, amount)
            if amount <= 0 then
                return true
            end
        end
    end
	return false
end

local function ConsumeByTag(self,tag, amount)
    if amount <= 0 then
        return false
    end
    for k = 1, self.maxslots do
        local v = self.itemslots[k]
        if v ~= nil and v:HasTag(tag) then
            amount = amount - tryconsume(self, v, amount)
            if amount <= 0 then
                return true
            end
        end
    end

    if self.activeitem ~= nil and self.activeitem:HasTag(tag) then
        amount = amount - tryconsume(self, self.activeitem, amount)
        if amount <= 0 then
            return true
        end
    end

    local overflow = self:GetOverflowContainer()
    if overflow ~= nil then
		return Container_ConsumeByTag(overflow,tag, amount)
    end
	
	return false 
end

local function OnHitOther(inst, other, damage)
	if other and other.components.inventory ~= nil and other.components.inventory.isopen then
		local eat = ConsumeByTag(other.components.inventory,"myth_coin", 1)
		if eat and not inst.components.health:IsDead()  then
			inst.components.health:DoDelta(50)
			if  inst._link ~= nil and inst._link.components.health and  not inst._link.components.health:IsDead()  then
				inst._link.components.health:DoDelta(200)
			end
		end
	end
end

local function DoLink(inst, link)
    inst._link = link
	if inst._link.smallfrog ~= nil then
		inst._link.smallfrog = inst._link.smallfrog + 1
		if inst._link.UpdateLevel then
			inst._link:UpdateLevel()
		end
	end
    local function onlinkdead(link)
        if inst._link ~= nil then
            inst._link = nil
            if not inst.components.health:IsDead()  then
				inst.nodrop = true
				inst.components.health:Kill()
            end
        end
    end
    inst:ListenForEvent("onremove", onlinkdead, link)
    inst:ListenForEvent("death", onlinkdead, link)

	inst:ListenForEvent("death",function(...)
		if inst._link ~= nil and inst._link.smallfrog ~= nil then
			inst._link.smallfrog = inst._link.smallfrog -1
			if inst._link.UpdateLevel then
				inst._link:UpdateLevel()
			end
			inst._link = nil
		end
	end)
	inst:ListenForEvent("onremove",function(...)
		if inst._link ~= nil and inst._link.smallfrog ~= nil then
			inst._link.smallfrog = inst._link.smallfrog -1
			if inst._link.UpdateLevel then
				inst._link:UpdateLevel()
			end
			inst._link = nil
		end
	end)
end

local function StartTracking(inst,link)
	DoLink(inst, link)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, .3)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("frog")
    inst.AnimState:SetBuild("myth_small_goldfrog")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("hostile")
    inst:AddTag("smallcreature")
    inst:AddTag("myth_small_goldfrog")
    inst:AddTag("canbetrapped")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 8

    -- boat hopping enable.
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")
    inst:AddComponent("drownable")

    inst:SetStateGraph("SGfrog")

    inst:SetBrain(brain)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(150)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(25)
    inst.components.combat:SetAttackPeriod(TUNING.FROG_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)

    inst.components.combat.onhitotherfn = OnHitOther

    MakeTinyFreezableCharacter(inst, "frogsack")

    MakeHauntablePanic(inst)

    inst:AddComponent("lootdropper")
	local old_DropLoot = inst.components.lootdropper.DropLoot
	inst.components.lootdropper.DropLoot= function(self,...)
		if self.inst.nodrop then
			return
		end
		return old_DropLoot(self,...)
	end
    inst.components.lootdropper:AddRandomLoot("lucky_goldnugget", 1)
    inst.components.lootdropper:AddRandomLoot("myth_coin", 1)
    inst.components.lootdropper.numrandomloot = 1

    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

	inst.StartTracking = StartTracking
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("goinghome", OnGoingHome)

    return inst
end

return Prefab("myth_small_goldfrog", fn, assets, prefabs)
