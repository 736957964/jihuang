local brain = require "brains/mytentaclebrain"

local assets =
{
    Asset("ANIM", "anim/tentacle.zip"),
    Asset("SOUND", "sound/tentacle.fsb"),
}

SetSharedLootTable( 'tentacle',                    ----c_give("tentacle")
{
    {'monstermeat',   1.0},
    {'monstermeat',   1.0},
    {'tentaclespike', 0.5},
    {'tentaclespots', 0.2},
})

local function retargetfn(inst)
	local invader = nil
    invader = FindEntity(inst, 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	return invader
end

local function shouldKeepTarget(inst, target)
	return inst.components.combat:CanTarget(target)
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
	if attacker then
		if inst.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowcreature") then
			inst.components.combat:SetTarget(attacker)
			----	Ð¡»ï°éºÎÔÚ
			inst.components.combat:ShareTarget(attacker, 15, function(dude)
				return dude.prefab == "tentacle"	
			end, 20)
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --inst.entity:AddPhysics()
	
	local phys = inst.entity:AddPhysics()
	phys:SetMass(100)
    phys:SetCapsule(.5, 1.5)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.GROUND)
	phys:CollidesWith(COLLISION.SANITY)
	phys:CollidesWith(COLLISION.WORLD)
	
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    --inst.Physics:SetCylinder(0.25, 2)

    inst.AnimState:SetBank("tentacle")
    inst.AnimState:SetBuild("tentacle")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("monster")    
    inst:AddTag("hostile")
	--inst:AddTag("shadowcreature")
    --inst:AddTag("wet")
    --inst:AddTag("WORM_DANGER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(250)
	inst.components.health:StartRegen(1,2)

    inst:AddComponent("combat")
    inst.components.combat:SetRange(4)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(1, retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)

    --MakeLargeFreezableCharacter(inst)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('tentacle')

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 2
    inst:SetStateGraph("SGmytentacle")
	
	inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("marsh/monsters/tentacle", fn, assets)