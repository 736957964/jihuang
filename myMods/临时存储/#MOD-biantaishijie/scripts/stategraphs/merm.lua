local assets =
{
    Asset("ANIM", "anim/merm_build.zip"),
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("SOUND", "sound/merm.fsb"),
}

local prefabs =
{
    "fish",
    "froglegs",
}

local loot =
{
    "fish",
	"fish",
	"fish",
    "froglegs",
}

local brain = require "brains/mermbrain"

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function FindInvaderFn(guy)
    return guy and not guy:HasTag("merm") and not guy:HasTag("zg_marine") and 
		(
			guy:HasTag("character") or guy:HasTag("zg_kaizaku")
		)
end

local function RetargetFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST * TUNING.MERM_DEFEND_DIST then
        defenseTarget = home
    end
    return FindEntity(defenseTarget or inst, SpringCombatMod(TUNING.MERM_TARGET_DIST), FindInvaderFn)
end

local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
               and home:GetDistanceSqToInst(inst) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
    end
    return inst.components.combat:CanTarget(target)
end

local function OnAttacked(inst, data)
	
	local attacker = data and data.attacker
	
	--if not (attacker and attacker:HasTag("shadowboss")) then
		if attacker and inst.components.combat:CanTarget(attacker) then
			inst.components.combat:SetTarget(attacker)
			local targetshares = MAX_TARGET_SHARES
			if inst.components.homeseeker and inst.components.homeseeker.home then
				local home = inst.components.homeseeker.home
				if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= SHARE_TARGET_DIST*SHARE_TARGET_DIST then
					targetshares = targetshares - home.components.childspawner.childreninside
					home.components.childspawner:ReleaseAllChildren(attacker)
				end
				inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude)
					return dude.components.homeseeker
						   and dude.components.homeseeker.home
						   and dude.components.homeseeker.home == home
				end, targetshares)
			end
		end
	--end
	
end

----------------------
----	武器样式
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_spear", "swap_spear", "swap_spear") 
end
local function onunequip(inst, owner) 
	owner.AnimState:ClearOverrideSymbol("swap_spear")
end

----	武器栏
local function GetInventory(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local meleeweapon = CreateEntity()
        meleeweapon.entity:AddTransform()
		meleeweapon.entity:AddSoundEmitter()
        meleeweapon:AddComponent("weapon")
		meleeweapon.zg_name = "sword"
        meleeweapon.components.weapon:SetDamage( 34*inst.Transform:GetScale() )
		meleeweapon.components.weapon:SetOnAttack(function (weapon, attacker, target)
			meleeweapon.SoundEmitter:PlaySound("dontstarve/zg/ch_law/atk")
		end)
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
        meleeweapon:AddComponent("equippable")
			----	武器外观
			meleeweapon.components.equippable:SetOnEquip(onequip)
			meleeweapon.components.equippable:SetOnUnequip(onunequip)
        meleeweapon:AddTag("meleeweapon")
		inst.components.inventory:Equip(meleeweapon)
    end
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

    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("merm_build")
    --inst.AnimState:Hide("hat")
	inst.AnimState:OverrideSymbol("swap_hat", "hat_marine", "swap_hat")
	inst.AnimState:OverrideSymbol("swap_hat", "hat_marine", "swap_hat")

    inst:AddTag("character")
    inst:AddTag("merm")
    inst:AddTag("wet")
	
	inst:AddTag("zg_marine")
	inst:AddTag("zg_cr1")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.MERM_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED

    inst:SetBrain(brain)

    inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    inst.components.eater.strongstomach = true

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetNocturnal(true)

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst.components.health:SetMaxHealth(555)
    inst.components.combat:SetDefaultDamage(30)
    inst.components.combat:SetAttackPeriod(3)


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("inventory")

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
	
	inst:DoTaskInTime(.25,function()
		GetInventory(inst)
	end)

    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")

    inst:ListenForEvent("attacked", OnAttacked)
	
	inst:SetStateGraph("SGmerm")

    return inst
end

return Prefab("merm", fn, assets, prefabs)
