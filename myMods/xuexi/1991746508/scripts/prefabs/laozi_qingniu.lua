local fns = {} -- a table to store local functions in so that we don't hit the 60 upvalues limit

local assets =
{
    Asset("ANIM", "anim/beefalo_basic.zip"),
    Asset("ANIM", "anim/beefalo_actions.zip"),
    Asset("ANIM", "anim/beefalo_actions_domestic.zip"),
    Asset("ANIM", "anim/beefalo_actions_quirky.zip"),
    Asset("ANIM", "anim/beefalo_build.zip"),
    Asset("ANIM", "anim/beefalo_shaved_build.zip"),
    Asset("ANIM", "anim/beefalo_baby_build.zip"),

    Asset("ANIM", "anim/beefalo_domesticated.zip"),
    Asset("ANIM", "anim/beefalo_personality_docile.zip"),
    Asset("ANIM", "anim/beefalo_personality_ornery.zip"),
    Asset("ANIM", "anim/beefalo_personality_pudgy.zip"),

    Asset("ANIM", "anim/laozi_qingniu.zip"),

    Asset("ANIM", "anim/beefalo_fx.zip"),
    Asset("ANIM", "anim/beefalo_qingniu_docile.zip"),

    Asset("SOUND", "sound/beefalo.fsb"),

}

local prefabs =
{
    "meat",
    "poop",
    "beefalowool",
    "horn",
    "carrat",
    "explode_reskin",
    'mk_cloudfx',
}

local brain = require("brains/qingniubrain")

SetSharedLootTable( 'beefalo',
{
    {'meat',            1.00},
    {'meat',            1.00},
    {'meat',            1.00},
    {'meat',            1.00},
    {'beefalowool',     1.00},
    {'beefalowool',     1.00},
    {'beefalowool',     1.00},
    {'horn',            0.33},
})

local sounds = 
{
    walk = "dontstarve/beefalo/walk",
    grunt = "dontstarve/beefalo/grunt",
    yell = "dontstarve/beefalo/yell",
    swish = "dontstarve/beefalo/tail_swish",
    curious = "dontstarve/beefalo/curious",
    angry = "dontstarve/beefalo/angry",
    sleep = "dontstarve/beefalo/sleep",
}

fns.ClearBellOwner = function(inst)
    local bell_leader = inst.components.follower:GetLeader()
    inst:RemoveEventCallback("onremove", inst._BellRemoveCallback, bell_leader)

    inst.components.follower:SetLeader(nil)
    inst.components.rideable:SetShouldSave(true)

    inst.persists = true
end

fns.GetBeefBellOwner = function(inst)
    local leader = inst.components.follower:GetLeader()
    return (leader ~= nil
        and leader.components.inventoryitem ~= nil
        and leader.components.inventoryitem:GetGrandOwner())
        or nil
end

fns.SetBeefBellOwner = function(inst, bell, bell_user)
    if inst.components.follower:GetLeader() == nil
            and bell ~= nil and bell.components.leader ~= nil then
        bell.components.leader:AddFollower(inst)
        inst.components.rideable:SetShouldSave(false)

        inst:ListenForEvent("onremove", inst._BellRemoveCallback, bell)

        inst.persists = false

        return true
    else
        return false, "ALREADY_USED"
    end
end

local function ClearBuildOverrides(inst, animstate)
    local basebuild = "laozi_qingniu"
    if animstate ~= inst.AnimState then
        animstate:ClearOverrideBuild(basebuild)
    end
    animstate:ClearOverrideBuild("beefalo_qingniu_docile")
end
-- This takes an anim state so that it can apply to itself, or to its rider
local function ApplyBuildOverrides(inst, animstate)
    local basebuild = "laozi_qingniu"
    if animstate ~= nil and animstate ~= inst.AnimState then
        animstate:AddOverrideBuild(basebuild)
    else
        animstate:SetBuild(basebuild)
    end
    animstate:AddOverrideBuild("beefalo_qingniu_docile")
end

local function KeepTarget(inst, target)
    local herd = inst.components.herdmember ~= nil and inst.components.herdmember:GetHerd() or nil
    return herd == nil
        or herd.components.mood == nil
        or not herd.components.mood:IsInMood()
        or inst:IsNear(herd, TUNING.BEEFALO_CHASE_DIST)
end

local function OnNewTarget(inst, data)
    if data ~= nil and data.target ~= nil and inst.components.follower ~= nil and data.target == inst.components.follower.leader then
        inst.components.follower:SetLeader(nil)
    end
end

local function CanShareTarget(dude)
    return dude:HasTag("beefalo")
        and not dude:IsInLimbo()
        and not (dude.components.health:IsDead() or dude:HasTag("player"))
end

local function OnAttacked(inst, data)
    if inst._ridersleeptask ~= nil then
        inst._ridersleeptask:Cancel()
        inst._ridersleeptask = nil
    end
    inst._ridersleep = nil
    if inst.components.rideable:IsBeingRidden() then
    else
        inst.components.combat:SetTarget(data.attacker)
        inst.components.combat:ShareTarget(data.attacker, 30, CanShareTarget, 5)
    end
    if inst.components.hitchable and not inst.components.hitchable.canbehitched then
        inst.components.hitchable:Unhitch()
    end
end

local pills = {
    condensed_pill = true,
    fly_pill  = true,
    armor_pill = true
}
local function hassddle(inst)
    return inst.components.rideable.saddle ~= nil and inst.components.rideable.saddle:HasTag("qingniu_saddle")
end
local function ShouldAcceptItem(inst, item)
    return (( pills[item.prefab] and hassddle(inst)) or inst.components.eater:CanEat(item))
        and not inst.components.combat:HasTarget()
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.eater:CanEat(item) then
        inst.components.eater:Eat(item, giver)
    elseif item:HasTag("mk_pills") then
        inst.sg:GoToState("eat",{})
        if item.prefab == "condensed_pill" then
            if  giver and giver.components.talker then 
                giver.components.talker:Say(STRINGS.LZOZI_QINGNIU_EATPILL.NS)
            end
            inst.components.debuffable:AddDebuff(item.prefab.."_buff", item.prefab.."_buff")
        elseif item.prefab == "armor_pill" then
            if  giver and giver.components.talker then 
                giver.components.talker:Say(STRINGS.LZOZI_QINGNIU_EATPILL.ZG)
            end
            inst.components.debuffable:AddDebuff(item.prefab.."_buff", item.prefab.."_buff")
        elseif item.prefab == "fly_pill" then
            if  giver and giver.components.talker then 
                giver.components.talker:Say(STRINGS.LZOZI_QINGNIU_EATPILL.TY)
            end
            inst.components.debuffable:AddDebuff("qingniufly_buff", "qingniufly_buff")
        end
    end
end

local function OnRefuseItem(inst, giver,item)
    inst.sg:GoToState("refuse")
    if item.prefab == "bloodthirsty_pill" and giver and giver.components.talker then 
        giver.components.talker:Say(STRINGS.LZOZI_QINGNIU_EATPILL.SX)
    end
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function ShouldBeg(inst)
    return false
end

local function OnDeath(inst, data)
    if not inst.dead_already then
        inst.dead_already = true

        inst.persists = false

        inst:AddTag("NOCLICK")
        if inst.components.rideable:IsBeingRidden() then
            inst.components.rideable:Buck(true)
        end
        inst.components.rideable:SetSaddle(nil, nil)

        local leader = inst.components.follower:GetLeader()
        if  leader and leader.prefab == "laozi_bell"  and leader:GetBeefalo() == inst then
            if leader:IsValid() then
                local goop = SpawnPrefab("laozi_bell_broken")
                if goop ~= nil then
                    local x, y, z = leader.Transform:GetWorldPosition()
                    goop.Transform:SetPosition(x, y, z)
        
                    local owner = leader.components.inventoryitem ~= nil and leader.components.inventoryitem.owner or nil
                    local holder = owner ~= nil and (owner.components.inventory or owner.components.container) or nil
                    if holder ~= nil then
                        local slot = holder:GetItemSlot(leader)
                        leader:Remove()
                        holder:GiveItem(goop, slot)
                    else
                        leader:Remove()
                    end
                end
            end
        end
        local newbeef = SpawnPrefab("laozi_qingniu_fly")
        newbeef.Transform:SetPosition(inst.Transform:GetWorldPosition())
        newbeef:FacePoint(inst.Transform:GetWorldPosition())
        newbeef:GoAway()
        inst:Remove()
    end
end

local function OnEat(inst, food)
    local full = inst.components.hunger:GetPercent() >= 1
    inst:PushEvent("eat", { full = full, food = food })
end

--需要
local function OnHealthDelta(inst, data)
    if data.oldpercent >= 0.2 and
        data.newpercent < 0.2 and
        inst.components.rideable.rider ~= nil then
        inst.components.rideable.rider:PushEvent("mountwounded")
    end
end

local function DoRiderSleep(inst, sleepiness, sleeptime)
    inst._ridersleeptask = nil
    inst.components.sleeper:AddSleepiness(sleepiness, sleeptime)
end

--什么人可以
local function PotentialRiderTest(inst, potential_rider)
    local leader = inst.components.follower:GetLeader()
    if leader == nil or leader.components.inventoryitem == nil then
        return false
    end

    local leader_owner = leader.components.inventoryitem:GetGrandOwner()
    return inst.components.hunger:GetPercent() > 0 and (leader_owner ~= nil and leader_owner == potential_rider)
end

local function OnSaddleChanged(inst, data)

end

local function _OnRefuseRider(inst)
    if inst.components.sleeper:IsAsleep() and not inst.components.health:IsDead() then
        -- this needs to happen after the stategraph
        inst.components.sleeper:WakeUp()
    end
end

local function OnRefuseRider(inst, data)
    inst:DoTaskInTime(0, _OnRefuseRider)
end

local function OnRiderSleep(inst, data)
    inst._ridersleep = inst.components.rideable:IsBeingRidden() and {
        time = GetTime(),
        sleepiness = data.sleepiness,
        sleeptime = data.sleeptime,
    } or nil
end

local function dobeefalounhitch(inst)
    if inst.components.hitchable and not inst.components.hitchable.canbehitched then
        inst.components.hitchable:Unhitch()
    end
end

local function OnHitchTo(inst, data)
    inst.hitchingspot = data.target
    inst:ListenForEvent("minhealth", dobeefalounhitch)
    inst:ListenForEvent("gotosleep", dobeefalounhitch)
    inst:ListenForEvent("onignite", dobeefalounhitch)
    inst:ListenForEvent("onremove", dobeefalounhitch)
end

local function OnUnhitch(inst, data)
    inst:RemoveEventCallback("minhealth", dobeefalounhitch)
    inst:RemoveEventCallback("gotosleep", dobeefalounhitch)
    inst:RemoveEventCallback("onignite", dobeefalounhitch)
    inst:RemoveEventCallback("onremove", dobeefalounhitch)
end

local WAKE_TO_FOLLOW_DISTANCE = 15
local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst)
        or (inst.components.follower.leader ~= nil
            and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local SLEEP_NEAR_LEADER_DISTANCE = 10
local function MountSleepTest(inst)
    return not inst.components.rideable:IsBeingRidden()
        and DefaultSleepTest(inst)
        and not inst:HasTag("hitched")
        and (inst.components.follower.leader == nil
            or inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE))
end

local function onwenthome(inst,data)
    if data.doer and data.doer.prefab == "carrat" then
        addcarrat(inst,data.doer)
        inst:PushEvent("carratboarded")
    end
end

fns.OnSave = function(inst, data)

end

fns.OnLoad = function(inst, data)

end

fns.OnLoadPostPass = function(inst,data)

end

local function GetHopDistance(inst, speed_mult)
	return speed_mult < 0.8 and TUNING.WILSON_HOP_DISTANCE_SHORT
			or speed_mult >= 1.2 and TUNING.WILSON_HOP_DISTANCE_FAR
			or TUNING.WILSON_HOP_DISTANCE
end

local function removeflyfx(inst)
    if inst.Physics then
        ChangeToCharacterPhysics(inst)
    end
    if inst.components.locomotor then
        inst.components.locomotor:SetSlowMultiplier(0.6)
        inst.components.locomotor.pathcaps = { player = true, ignorecreep = true }
        inst.components.locomotor.fasteronroad = true
        inst.components.locomotor:SetTriggersCreep(not inst:HasTag("spiderwhisperer"))
        inst.components.locomotor:SetAllowPlatformHopping(true)
        inst.components.locomotor.hop_distance_fn = GetHopDistance
    end
    if inst.components.drownable then
        inst.components.drownable.enabled = true
    end

    if inst.components.mk_cloudfxspawner then
        inst.components.mk_cloudfxspawner.canspawn = false
        inst.components.mk_cloudfxspawner:RemoveClouds()
    end
end

local function addflyfx(inst)
    if inst.Physics then
        RemovePhysicsColliders(inst)
    end
    if inst.components.locomotor then
        inst.components.locomotor:SetSlowMultiplier(0.6)
        inst.components.locomotor.pathcaps = { player = true, ignorecreep = true ,allowocean = true}
        inst.components.locomotor.fasteronroad = false
        inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor:SetAllowPlatformHopping(false)
    end
    if inst.components.drownable then
        inst.components.drownable.enabled = false
    end
    if inst.components.mk_cloudfxspawner then
        inst.components.mk_cloudfxspawner.canspawn = true
        inst.components.mk_cloudfxspawner:CreateClouds()
    end
end

local function OnQiNiu(inst,data)
    if data then 
        if data.oldrider ~= nil then
            removeflyfx(data.oldrider)
        elseif data.newrider ~= nil and inst.components.debuffable:HasDebuff("qingniufly_buff")  then
            addflyfx(data.newrider)
        end
    end
end

local function beefalo()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 100, .5)

    inst.DynamicShadow:SetSize(6, 2)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetBank("beefalo")
    inst.AnimState:SetBuild("laozi_qingniu")
    --inst.AnimState:AddOverrideBuild("poop_cloud")
    --inst.AnimState:AddOverrideBuild("beefalo_carrat_idles")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("HEAT")

    inst.MiniMapEntity:SetIcon("beefalo_domesticated.png")
    inst.MiniMapEntity:SetEnabled(true)

    inst:AddTag("beefalo")
    inst:AddTag("animal")
    inst:AddTag("largecreature")
    inst:AddTag("companion")

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst:AddTag("laozi_qingniu")

    inst:AddTag("saddleable")

    inst.sounds = sounds

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("bloomer")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.VEGGIE, FOODTYPE.ROUGHAGE }, { FOODTYPE.VEGGIE, FOODTYPE.ROUGHAGE })
    inst.components.eater:SetAbsorptionModifiers(4,1,1)
    inst.components.eater:SetOnEatFn(OnEat)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(51)
    --inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1000)
    inst.components.health.nofadeout = true
    inst.components.health:StartRegen(TUNING.BEEFALO_HEALTH_REGEN, TUNING.BEEFALO_HEALTH_REGEN_PERIOD)

    --死亡需要哦！
    inst:ListenForEvent("minhealth", OnDeath) -- need to handle this due to being mountable
    inst:ListenForEvent("healthdelta", OnHealthDelta) -- to inform rider

    inst:AddComponent("lootdropper")
    --inst.components.lootdropper:SetChanceLootTable('beefalo')

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")

    inst:AddComponent("leader")
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
    inst.components.follower.canaccepttarget = false

    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("rideable")
    inst.components.rideable:SetCustomRiderTest(PotentialRiderTest)
    inst.components.rideable.saddleable = true

    --鞍
    inst:ListenForEvent("saddlechanged", OnSaddleChanged)
    inst:ListenForEvent("refusedrider", OnRefuseRider)

    --可交易
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    inst:AddComponent("hunger")
    inst.components.hunger:SetMax(TUNING.BEEFALO_HUNGER)
    inst.components.hunger:SetRate(TUNING.BEEFALO_HUNGER_RATE)
    inst.components.hunger:SetPercent(1)
    inst.components.hunger.overridestarvefn = function(...)    end

    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.BEEFALO_WALK_SPEED
    inst.components.locomotor.runspeed = 9

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.sleeptestfn = MountSleepTest
    inst.components.sleeper.waketestfn = ShouldWakeUp

    inst:AddComponent("timer")

    inst.ApplyBuildOverrides = ApplyBuildOverrides
    inst.ClearBuildOverrides = ClearBuildOverrides

    inst:ListenForEvent("ridersleep", OnRiderSleep)

    --绑定？
    inst:ListenForEvent("hitchto", OnHitchTo)
    inst:ListenForEvent("unhitch", OnUnhitch)

    inst:ListenForEvent("riderchanged", OnQiNiu)

    --解除绑定
    inst:ListenForEvent("stopfollowing", fns.ClearBellOwner)

    inst:AddComponent("uniqueid")

    inst:AddComponent("drownable")

    inst:AddComponent("debuffable")

    inst:AddComponent("hitchable")--可以绑定的

    inst:AddComponent("colourtweener")

    inst:AddComponent("markable_proxy")

    inst:AddComponent("mk_cloudfxspawner")
    inst.components.mk_cloudfxspawner.qn = true
    inst.components.mk_cloudfxspawner.first = false
    inst.components.mk_cloudfxspawner.canspawn = false

    inst:AddComponent("laozo_qingniu_buff")

    inst.ShouldBeg = ShouldBeg
    inst.SetBeefBellOwner = fns.SetBeefBellOwner
    inst.GetBeefBellOwner = fns.GetBeefBellOwner
    inst.ClearBeefBellOwner = fns.ClearBellOwner

    inst._BellRemoveCallback = function(bell)
        fns.ClearBellOwner(inst)
    end

    inst:SetBrain(brain)
    inst:SetStateGraph("SGBeefalo")

    inst.GetIsInMood = function(...)
        return false
    end

    --inst.OnSave = fns.OnSave
    --inst.OnLoad = fns.OnLoad
    --inst.OnLoadPostPass = fns.OnLoadPostPass

    return inst
end

local function goaway(inst)
    inst.components.locomotor:RunForward()
    inst.Physics:SetMotorVel(12,4,0)
    inst:DoPeriodicTask(0,function()
        inst.Physics:SetMotorVel(12,4,0)
    end)
end

local function fnfx(Sim)
    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    MakeGhostPhysics(inst, 1, 1.5)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("beefalo")
    inst.AnimState:SetBuild("laozi_qingniu")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("HEAT")

    inst.Transform:SetSixFaced()

    inst:AddTag("fx")
    inst:AddTag("flying")
    inst:SetPrefabNameOverride("laozi_qingniu")
    inst.SoundEmitter:PlaySound("dontstarve/beefalo/angry")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end 

    inst.persists = false
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 12
    inst.components.locomotor.runspeed = 12

    inst:AddComponent("inspectable")

    inst:AddComponent("mk_cloudfxspawner")
    inst.components.mk_cloudfxspawner.qn = true

    inst.GoAway = goaway

    inst:DoTaskInTime(5,inst.Remove)

    return inst
end
return Prefab("laozi_qingniu", beefalo, assets, prefabs),
    Prefab("laozi_qingniu_fly", fnfx)
