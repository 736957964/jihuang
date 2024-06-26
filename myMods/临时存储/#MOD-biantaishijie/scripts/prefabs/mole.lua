local assets =
{
    Asset("ANIM", "anim/mole_build.zip"),
    Asset("ANIM", "anim/mole_basic.zip"),
    Asset("SOUND", "sound/mole.fsb"),
}

-- make him pop up periodically

local prefabs =
{
    "smallmeat",
    "cookedsmallmeat",
    "mole_move_fx",
    "molehat",
}

local brain = require("brains/molebrain")


----	被攻击时

local function OnAttacked(inst, data)
    -- Don't spread the word when whacked
    --if data and data.weapon and data.weapon == "hammer" then return end

    ----	群体反攻玩家
    local attacker = data and data.attacker
	if attacker then
		if inst.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			inst.components.combat:SetTarget(attacker)
			----	小伙伴何在
			inst.components.combat:ShareTarget(attacker, 100, function(dude)
				return dude:HasTag("mole")	
			end, 20)
		end
	end
end

local function OnWentHome(inst)
    local molehill = inst.components.homeseeker and inst.components.homeseeker.home or nil
    if not molehill then return end
    if molehill.components.inventory then
        inst.components.inventory:TransferInventory(molehill)
    end
    inst.sg:GoToState("idle")
end

local function OnCookedFn(inst)
    if inst.components.health then
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mole/death")
    end
end

local function onpickup(inst)
    inst:PushEvent("ontrapped")
    inst.SoundEmitter:KillSound("move")
    inst.SoundEmitter:KillSound("sniff")
    inst.SoundEmitter:KillSound("stunned")
    if inst.sg.statemem.playtask ~= nil then
        inst.sg.statemem.playtask:Cancel()
        inst.sg.statemem.playtask = nil
    end
    if inst.sg.statemem.killtask ~= nil then
        inst.sg.statemem.killtask:Cancel()
        inst.sg.statemem.killtask = nil
    end
end

local function OnLoad(inst, data)
    if data then
        inst.needs_home_time = data.needs_home_time and -data.needs_home_time or nil
    end
end

local function OnSave(inst, data)
    data.needs_home_time = inst.needs_home_time and (GetTime() - inst.needs_home_time) or nil
end

local function SetUnderPhysics(inst)
    if inst.isunder ~= true then
        inst.isunder = true
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    end
end

local function SetAbovePhysics(inst)
    if inst.isunder ~= false then
        inst.isunder = false
        ChangeToCharacterPhysics(inst)
    end
end

local function displaynamefn(inst)
    return inst:HasTag("noattack")
        and not inst:HasTag("INLIMBO")
        and not (inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:CanBePickedUp())
        and STRINGS.NAMES.MOLE_UNDERGROUND
        or STRINGS.NAMES.MOLE_ABOVEGROUND
end

local function getstatus(inst)
    return (inst.components.inventoryitem ~= nil and inst.components.inventoryitem:IsHeld() and "HELD")
        or (inst.isunder and "UNDERGROUND")
        or "ABOVEGROUND"
end

local function TestForMakeHome(inst)
    if not (inst.components.homeseeker ~= nil and inst.components.homeseeker.home ~= nil and inst.components.homeseeker.home:IsValid()) then
        inst.needs_home_time = GetTime()
    end
end

local function ondrop(inst)
    inst.SoundEmitter:KillSound("move")
    inst.SoundEmitter:KillSound("sniff")
    inst.SoundEmitter:KillSound("stunned")
    inst.sg:GoToState("stunned", true)
    TestForMakeHome(inst)
end

local function OnSleep(inst)
    inst.SoundEmitter:KillAllSounds()
end

local function OnRemove(inst)
    inst.SoundEmitter:KillAllSounds()
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
    inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()
    --inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 99999, 0.5)
    SetUnderPhysics(inst)

    inst.AnimState:SetBank("mole")
    inst.AnimState:SetBuild("mole_build")
    inst.AnimState:PlayAnimation("idle_under")

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("mole")
    inst:AddTag("smallcreature")
    --inst:AddTag("canbetrapped")
    inst:AddTag("baitstealer")
    inst:AddTag("cattoy")
    inst:AddTag("catfood")
    --inst:AddTag("wildfireprotected") --Only if burnable

    --cookable (from cookable component) added to pristine state for optimization
    inst:AddTag("cookable")

    MakeFeedableSmallLivestockPristine(inst)

    inst.displaynamefn = displaynamefn
    inst.name = STRINGS.NAMES.MOLE_ABOVEGROUND

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.isunder = nil --this flag is not valid on clients

        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
	inst.components.locomotor.runspeed = 3

    inst:SetStateGraph("SGmole")
    inst:SetBrain(brain)
	
	----	战斗
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(25)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(2.5)
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("cookable")
    inst.components.cookable.product = "cookedsmallmeat"
    inst.components.cookable:SetOnCookedFn(OnCookedFn)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(250)
    inst.components.health.murdersound = "dontstarve_DLC001/creatures/mole/death"
    inst.components.health.fire_damage_scale = 0

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({FOODTYPE.ELEMENTAL})

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"meat"})
    inst.components.lootdropper.trappable = false

    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 3
    inst.force_onwenthome_message = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem.trappable = false
    -- inst.components.inventoryitem:SetOnPickupFn(onpickup)
    -- inst.components.inventoryitem:SetOnDroppedFn(ondrop) Done in MakeFeedableSmallLivestock

    inst:AddComponent("knownlocations")
    inst.last_above_time = 0
    inst.make_home_delay = math.random(5,10)
    inst.peek_interval = math.random(15,25)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetNocturnal(true)

    inst.SetUnderPhysics = SetUnderPhysics
    inst.SetAbovePhysics = SetAbovePhysics

    -- MakeSmallBurnableCharacter(inst, "mole")
    MakeTinyFreezableCharacter(inst, "chest")

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    -- inst.OnEntityWake = OnWake
    inst.OnEntitySleep = OnSleep
    inst.OnRemoveEntity = OnRemove
    inst:ListenForEvent("enterlimbo", OnRemove)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onwenthome", OnWentHome)

    MakeFeedableSmallLivestock(inst, TUNING.TOTAL_DAY_TIME*2, onpickup, ondrop)

    inst:DoTaskInTime(inst.make_home_delay, TestForMakeHome)

    return inst
end

return Prefab("forest/animals/mole", fn, assets, prefabs)
