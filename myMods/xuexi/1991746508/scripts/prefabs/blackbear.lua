require "brains/blackbearbrain"
require "stategraphs/SGblackbear"

local L = MK_MOD_LANGUAGE_SETTING

STRINGS.NAMES.BLACKBEAR = L == "ENGLISH" and 'Black bear'or '黑风大王'
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLACKBEAR = '好黑一妖精！'
Myth_AddCachedStr(function()
STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.BLACKBEAR = '你这黑煤精来此作甚，怕不是被菩萨赶出来了？'
STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.BLACKBEAR = '不如我们做个交易吧~袈裟归你唐僧归我~'
end)

assets =
{
    Asset("ANIM", "anim/mossling_build.zip"),
    Asset("ANIM", "anim/mossling_basic.zip"),
    Asset("ANIM", "anim/mossling_actions.zip"),
    Asset("ANIM", "anim/mossling_angry_build.zip"),
    Asset("ANIM", "anim/mossling_yule_build.zip"),
    Asset("ANIM", "anim/mossling_yule_angry_build.zip"),
    Asset("ANIM", "anim/blackbear.zip"),
    Asset("ANIM", "anim/bearger_build.zip"),
    Asset("ANIM", "anim/bearger_basic.zip"),
    Asset("ANIM", "anim/bearger_actions.zip"),
    Asset("ANIM", "anim/bearger_yule.zip"),
}

local BLACKWIND_CD = function(inst) 
   return inst.components.health:GetPercent() < .2 and 15 or 20
end

local POUND_CD = function(inst)
    return 10
end

local function shouldPound(inst)
    return GetTime() - inst.last_pound_time > POUND_CD(inst) and not inst:shouldBW()
end

local function shouldBW(inst)
    return inst.components.health:GetPercent() < .5 and
        GetTime() - inst.last_bw_time > BLACKWIND_CD(inst)
end

local function onPound(inst)
    inst.last_pound_time = GetTime()
end

local function onBW(inst)
    inst.last_bw_time = GetTime()
end

SetSharedLootTable( 'blackbear',
{
    {'lucky_goldnugget',             1.00},
    {'lucky_goldnugget',             1.00},
    {'lucky_goldnugget',             1.00},
    {'lucky_goldnugget',             1.00},
    {'lucky_goldnugget',             1.00},
    {'myth_coin',             1.00},
    {'myth_coin',             1.00},
    {'myth_coin',             1.00},
    {'myth_coin',             1.00},
    {'myth_coin',             1.00},

    {'honeycomb',             1.00},
    {'honeycomb',             1.00},
    {'honeycomb',             1.00},
    {'honeycomb',             0.5},

    {'pill_bottle_gourd_bb', 1},

    {'cassock',          1.00},
    {'kam_lan_cassock_blueprint',1.00},
    {'kam_lan_cassock',  0.05},

})

local BASE_TAGS = {"structure"}
local SEE_STRUCTURE_DIST = 20

local TARGET_DIST = 7.5

local function LeaveWorld(inst)
    inst:Remove()
end

local function NearPlayerBase(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, BASE_TAGS)
    if #ents >= 2 then
        inst.SeenBase = true
        return true
    end
end

local function CalcSanityAura(inst, observer) --噩梦光环
    if inst.components.combat.target then
        return -400/60
    end

    return -100/60
end

local function RetargetFn(inst)
    --if inst.components.sleeper and inst.components.sleeper:IsAsleep() then return end
    if inst.last_eat_time and (GetTime() - inst.last_eat_time) > TUNING.BEARGER_DISGRUNTLE_TIME then
        return FindEntity(inst, TARGET_DIST*5, function(guy) 
            return inst.components.combat:CanTarget(guy)
               and not guy:HasTag("prey")
               and not guy:HasTag("smallcreature")
        end)
    else
        return FindEntity(inst, TARGET_DIST, function(guy)
            return inst.components.combat:CanTarget(guy)
                and not guy:HasTag("prey")
                and not guy:HasTag("smallcreature")
        end)
    end
end

local function is_honey(item)
    return item.prefab == "honey" or item.prefab == "royal_jelly"
end
local RETARGET_MUST_TAGS = { "_combat", "_health" }
local function RetargetFn(inst)
    return not inst:IsInLimbo()
        and FindEntity(
                inst,
                8,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                        and (guy.components.inventory ~= nil and guy.components.inventory:FindItem(is_honey) ~= nil)
                end,
                RETARGET_MUST_TAGS,
                nil,nil
            )
        or nil
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnSave(inst, data)
    data.SeenBase = inst.SeenBase
    data.CanGroundPound = inst.CanGroundPound
    data.num_food_cherrypicked = inst.num_food_cherrypicked
    data.num_good_food_eaten = inst.num_good_food_eaten
    data.shouldGoAway = inst.shouldGoAway
end

local function OnLoad(inst, data)
    if data then
        inst.SeenBase = data.SeenBase
        inst.CanGroundPound = data.CanGroundPound
        inst.num_food_cherrypicked = data.num_food_cherrypicked or 0
        inst.num_good_food_eaten = data.num_good_food_eaten or 0
        inst.shouldGoAway = data.shouldGoAway or false
    end
end

local function OnAttacked(inst, data)
    inst.homevalue = 0
    inst.components.combat:SetTarget(data.attacker)
end

local function ClearRecentlyCharged(inst, other)
    inst.recentlycharged[other] = nil
end

local function OnDestroyOther(inst, other)
    if other:IsValid() and
        other.components.workable ~= nil and
        other.components.workable:CanBeWorked() and
        other.components.workable.action ~= ACTIONS.NET and
        not inst.recentlycharged[other] then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        if other.components.lootdropper ~= nil and (other:HasTag("tree") or other:HasTag("boulder")) then
            other.components.lootdropper:SetLoot({})
        end
        other.components.workable:Destroy(inst)
        if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
            inst.recentlycharged[other] = true
            inst:DoTaskInTime(3, ClearRecentlyCharged, other)
        end
    end
end

local function OnCollide(inst, other)
    if other ~= nil and
        other:IsValid() and
        other.components.workable ~= nil and
        other.components.workable:CanBeWorked() and
        other.components.workable.action ~= ACTIONS.NET and
        Vector3(inst.Physics:GetVelocity()):LengthSq() >= 1 and
        not inst.recentlycharged[other] then
        inst:DoTaskInTime(2 * FRAMES, OnDestroyOther, other)
    end
end

local function WorkEntities(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 5,nil,{"NOCLICK", "DECOR", "INLIMBO"})
    local heading_angle = -(inst.Transform:GetRotation())
    local dir = Vector3(math.cos(heading_angle*DEGREES),0, math.sin(heading_angle*DEGREES))

    for k,v in pairs(ents) do
        if v and v.components.workable and not v:HasTag("insect") then
            local hp = v:GetPosition()
            local offset = (hp - pt):GetNormalized()     
            local dot = offset:Dot(dir)
            if dot > .3 then
                v.components.workable:Destroy(inst)
            end
        end
    end
end

local function LaunchItem(inst, target, item)
    if item.Physics then

        local x, y, z = item:GetPosition():Get()
        y = .1
        item.Physics:Teleport(x,y,z)

        local hp = target:GetPosition()
        local pt = inst:GetPosition()
        local vel = (hp - pt):GetNormalized()     
        local speed = 5 + (math.random() * 2)
        local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
        item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)

    end
end

local function OnHitOther(inst, data)  --普通攻击时使物体掉落
    local other = data.target
    if other and other.components.inventory then
        local item = other.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        
        if not item or item:HasTag("cantdrop") or item:HasTag("mk_jgb") then return end  

        other.components.inventory:DropItem(item)
        LaunchItem(inst, data.target, item)
    end
end

local function spawnbarrier(inst,pt) --升起石墙

    for _,v in pairs(inst.rocks) do
        if v and v:IsValid() then
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(v.Transform:GetWorldPosition())
            v:Remove()
        end
    end
    inst.rocks = {}
    local angle = 0
    local radius = 13
    local number = 32
    for i=1,number do        
        local offset = Vector3(radius * math.cos( angle ), 0, -radius * math.sin( angle ))
        local newpt = pt + offset
        local x, y, z = newpt:Get()
        if TheWorld.Map:IsPassableAtPoint(x, y, z) then
            inst:DoTaskInTime(math.random()*0.3, function()            
                local rock = SpawnPrefab("blackbear_rock")
                rock.AnimState:PlayAnimation("emerge")
                rock.AnimState:PushAnimation("full")
                rock.Transform:SetPosition(newpt.x,newpt.y,newpt.z)
                table.insert(inst.rocks, rock)
            end)
        end
        angle = angle + (PI*2/number)
    end
end

local function SetStandState(inst, state)
    --"quad" or "bi" state
    inst.StandState = string.lower(state)
end

local function IsStandState(inst, state)
    return inst.StandState == string.lower(state)
end

-- local function OnPlayerAction(inst, player, data)
--     local playerAction = data.action
--     local selfAction = inst:GetBufferedAction()
--     if not playerAction or not selfAction then return end --You're not doing anything so whatever.

--     if playerAction.target == selfAction.target then -- We got a problem bud.
        
--         inst.num_food_cherrypicked = inst.num_food_cherrypicked + 1
--         if inst.num_food_cherrypicked < TUNING.BEARGER_STOLEN_TARGETS_FOR_AGRO then
--             inst.sg:GoToState("targetstolen")
--         else
--             inst.num_food_cherrypicked = TUNING.BEARGER_STOLEN_TARGETS_FOR_AGRO - 1
--             inst.components.combat:SuggestTarget(player)
--         end
--     end
-- end


local function leave(inst)
    inst.white_bone_killed = false
    inst.ray_killed = false
    if inst.wantodrop then
        inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
    end
    local wind = SpawnPrefab("blackbear_wind")
    wind.Transform:SetPosition(inst.Transform:GetWorldPosition())
    wind.Physics:SetMotorVel(3,0,-2 + math.random()*4)
    inst:Remove()
end

local function OnDeath(inst)
    inst.wantodrop = true
    leave(inst)
end

local function gohomeornot(inst)
    inst.homevalue = inst.homevalue + 1
    if inst.homevalue> 59 then
        leave(inst)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	shadow:SetSize(6, 3.5)
    
    inst.Transform:SetFourFaced()
    
    local s = 1
    trans:SetScale(s,s,s)

	MakeCharacterPhysics(inst, 1000, 1.5)
    inst.recentlycharged = {}
    inst.Physics:SetCollisionCallback(OnCollide)

    anim:SetBank("bearger")
    anim:SetBuild("blackbear")
    anim:PlayAnimation("idle_loop", true)
    
    ------------------------------------------

	inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("bearger")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.rocks = {}
    inst.homevalue = 0

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(12500)--
    --inst.components.health.minhealth = 1

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(200) --
    inst.components.combat:SetRange(TUNING.BEARGER_ATTACK_RANGE, TUNING.BEARGER_MELEE_RANGE)
    inst.components.combat:SetAreaDamage(6.2, 0.8) --
    inst.components.combat.hiteffectsymbol = "bearger_body"
    inst.components.combat:SetAttackPeriod(TUNING.BEARGER_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/bearger/hurt")
    inst:ListenForEvent("killed", function(inst, data)
        if inst.components.combat and data and data.victim == inst.components.combat.target then
            inst.components.combat.target = nil
        end 
    end)


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("blackbear")

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    ------------------------------------------

    inst:AddComponent("knownlocations")
    inst:AddComponent("thief")
    inst:AddComponent("inventory")

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.groundpoundfx = "groundpound_fx"

    inst:AddComponent("timer")
    inst:AddComponent("eater")
    inst.components.eater.foodprefs = {"MEAT", "VEGGIE", "GENERIC"}
    inst.components.eater.eatwholestack = true

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onhitother", OnHitOther)
    inst:ListenForEvent("death", OnDeath)

    MakeLargeBurnableCharacter(inst, "swap_fire")
    MakeHugeFreezableCharacter(inst, "bearger_body")

    inst:DoPeriodicTask(1,gohomeornot,1)
    SetStandState(inst, "QUAD")
    inst.SetStandState = SetStandState
    inst.IsStandState = IsStandState
    inst.SeenBase = false
    inst.NearPlayerBase = NearPlayerBase
    inst.WorkEntities = WorkEntities
    --inst.CanGroundPound = false
    inst.spawnbarrier = spawnbarrier

    inst.num_good_food_eaten = 0

    inst.num_food_cherrypicked = 0

    inst.last_pound_time = 0
    inst.last_bw_time = 0
    inst.shouldPound = shouldPound
    inst.shouldBW = shouldBW
    inst.onPound = onPound
    inst.onBW = onBW

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    ------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 10
    inst.components.locomotor:SetShouldRun(true)

    ------------------------------------------

    inst:SetStateGraph("SGblackbear")
    local brain = require("brains/blackbearbrain")
    inst:SetBrain(brain)

    return inst
end

local function setpot(inst,pot)
    inst.pot = pot
    inst.components.locomotor:RunForward()
    inst.components.locomotor:GoToPoint(Vector3(pot.Transform:GetWorldPosition()))

    inst._range_check = inst:DoPeriodicTask(0,function()
        if inst and inst.pot and inst.pot:IsValid() and inst:IsNear(inst.pot, 1.5) then
            inst.SoundEmitter:KillSound("spinLoop")
            inst.components.locomotor:StopMoving()
            inst._range_check:Cancel()
            local boss = SpawnPrefab("blackbear")
            if boss then
                if inst.pot.components.timer then
                    inst.pot.components.timer:StartTimer("blackbear", 20*480)
                end
                boss.Transform:SetPosition(inst.Transform:GetWorldPosition())
                boss:FacePoint(inst.pot.Transform:GetWorldPosition())
                inst.pot.components.container.canbeopened = true
                boss.sg:GoToState("open",inst.pot)
             end
             inst:Remove()
        end
    end)
end

local function fnfx(Sim)
    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local shadow = inst.entity:AddDynamicShadow()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    MakeGhostPhysics(inst, 1, 1.5)

    local anim = inst.AnimState
    anim:SetBank("mossling")
    anim:SetBuild("mossling_build")
    anim:PlayAnimation('spin_loop',true)
    shadow:SetSize(6, 3.5)

    inst.Transform:SetFourFaced()

    anim:SetMultColour(0.3,0.3,0.3,1)
    inst.Transform:SetScale(3,3,1)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin", "spinLoop")

    --inst:AddTag("fx")
    inst:AddTag("flying")
    inst:SetPrefabNameOverride("blackbear")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end 

    inst.persists = false
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 12
    inst.components.locomotor.runspeed = 12
    --inst.components.locomotor:SetShouldRun(true)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(200) --
    
    inst:AddComponent("inspectable")

    inst.SetPot = setpot

    local fx = SpawnPrefab("mossling_spin_fx")
    fx.entity:SetParent(inst.entity)
    fx.Transform:SetPosition(0,0.1,0)

    inst:DoTaskInTime(5,inst.Remove)

    return inst
end
return Prefab( "prefabs/blackbear", fn, assets) ,
Prefab( "blackbear_wind", fnfx) 