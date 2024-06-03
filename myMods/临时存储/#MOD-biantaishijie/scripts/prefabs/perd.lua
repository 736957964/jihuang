local assets =
{
    Asset("ANIM", "anim/perd_basic.zip"),
    Asset("ANIM", "anim/perd.zip"),
    Asset("SOUND", "sound/perd.fsb"),
}

local prefabs =
{
    "drumstick",
}

local brain = require "brains/perdbrain"

local loot =
{
    "drumstick",
    "drumstick",
}

local function ShouldWake()
    --always wake up if we're asleep
    return true
end

----	被攻击时
local function OnAttacked(inst, data)
    ----	群体反攻玩家
    local attacker = data and data.attacker
	if attacker then
		if inst.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			inst.components.combat:SetTarget(attacker)
			----	小伙伴何在
			inst.components.combat:ShareTarget(attacker, 100, function(dude)
				return dude:HasTag("perd")	
			end, 20)
		end
	end
end

----	重定位目标
local function RetargetFn(inst)
    local invader = nil
    invader = FindEntity(inst, 8, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
    return invader
end
local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)     
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("perd")
    inst.AnimState:SetBuild("perd")
    inst.AnimState:Hide("hat")

    inst:AddTag("character")
    inst:AddTag("berrythief")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 6
    inst.components.locomotor.walkspeed = 6

    inst:SetStateGraph("SGperd")

    inst:AddComponent("homeseeker")
    inst:SetBrain(brain)

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })
    inst.components.eater:SetCanEatRaw()

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest(ShouldWake)

    inst:AddComponent("health")
	inst.components.health:SetMaxHealth(240)
	
    inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(40)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRange(2)
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:ListenForEvent("attacked", OnAttacked)
	
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("inventory")

    inst:AddComponent("inspectable")

    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")

    return inst
end

return Prefab("forest/animals/perd", fn, assets, prefabs)