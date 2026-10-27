local assets =
{
    Asset("ANIM", "anim/frog.zip"),
    Asset("SOUND", "sound/frog.fsb"),
}

local prefabs =
{
    "froglegs",
    "splash",
}

local brain = require "brains/frogbrain"

local function retargetfn(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy) 
            if not guy.components.health:IsDead() then
                --return guy.components.inventory ~= nil
				return guy:HasTag("player") and not guy:HasTag("playerghost")
            end
        end,
        {"_combat","_health"} -- see entityreplica.lua
        )
    end
end

local function ShouldSleep(inst)
    return false -- frogs either go to their home, or just sit on the ground.
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5)
end

local function OnGoingHome(inst)
    local fx = SpawnPrefab("splash")
    local pos = inst:GetPosition()
    fx.Transform:SetPosition(pos.x, pos.y, pos.z)

    --local splash = PlayFX(Vector3(inst.Transform:GetWorldPosition() ), "splash", "splash", "splash")
    inst.SoundEmitter:PlaySound("dontstarve/frog/splash")
end

local function OnHitOther(inst, other, damage)
    inst.components.thief:StealItem(other)
end

local function wilsononcollide(inst, other)
	if not other:IsValid() then
        return
    end
	
	----遇到障碍物就跳跃
	if other and not other:HasTag("player") then
		if inst.components.health and not inst.components.health:IsDead() then
			inst.sg:GoToState("mydarkjump")
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	
	local phys = inst.entity:AddPhysics()
	phys:SetMass(100)
    phys:SetCapsule(.3, 1)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.GROUND)
	phys:CollidesWith(COLLISION.SANITY)
	phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
	
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    --MakeCharacterPhysics(inst, 1, .3)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("frog")
    inst.AnimState:SetBuild("frog")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("smallcreature")
    inst:AddTag("frog")
    inst:AddTag("canbetrapped")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 5

    inst:SetStateGraph("SGmyfrog")
	----	软实体的碰撞
	inst.Physics:SetCollisionCallback(wilsononcollide)

    inst:SetBrain(brain)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.FROG_HEALTH)
	inst.components.health:StartRegen(1,2)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(5)
    inst.components.combat:SetAttackPeriod(TUNING.FROG_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)

    inst.components.combat.onhitotherfn = OnHitOther

    inst:AddComponent("thief")

    --MakeTinyFreezableCharacter(inst, "frogsack")

    --MakeHauntablePanic(inst)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"froglegs"})

    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("goinghome", OnGoingHome)

    return inst
end

return Prefab("forest/animals/frog", fn, assets, prefabs)