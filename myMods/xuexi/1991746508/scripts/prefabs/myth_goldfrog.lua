
local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/myth_toadstool_basic.zip"),
    Asset("ANIM", "anim/myth_toadstool_actions.zip"),
    Asset("ANIM", "anim/myth_goldfrog.zip"),
    --Asset("ANIM", "anim/toadstool_upg_build.zip"),
}

local prefabs =
{
    "froglegs",
    "meat",
    "myth_coin",
    "lucky_goldnugget",
    "opalpreciousgem",
	"redpouch",
}

local gems = {"purplegem","bluegem","redgem","orangegem","yellowgem","greengem"}

for i,v in ipairs(gems) do
	table.insert(prefabs, v)
end

SetSharedLootTable('myth_goldfrog',
{
    {"froglegs",      1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
	
    {"myth_coin",          1.00},
    {"myth_coin",          1.00},
    {"myth_coin",          1.00},
    {"myth_coin",          1.00},
    {"myth_coin",          1.00},
    {"myth_coin",          1.00},

    {"lucky_goldnugget",       1.00},
    {"lucky_goldnugget",       1.00},
    {"lucky_goldnugget",       1.00},
	
    {"redpouch",       0.5},	

    {"purplegem",     	 0.2},
    {"purplegem",     	 0.3},
    {"bluegem",      	0.3},
    {"redgem",      	 0.3},
    {"orangegem",    	  0.3},
    {"yellowgem",    	  0.3},
    {"greengem",     	 0.3},
	
    {"opalpreciousgem",     0.01},
})


local brain = require("brains/toadstoolbrain")

--------------------------------------------------------------------------

local FADE_FRAMES = 20
local FADE_INTENSITY = .75
local FADE_RADIUS = 2
local FADE_FALLOFF = .5

local function OnUpdateFade(inst)
    local k
    if inst._fade:value() <= FADE_FRAMES then
        inst._fade:set_local(math.min(inst._fade:value() + 1, FADE_FRAMES))
        k = inst._fade:value() / FADE_FRAMES
    else
        inst._fade:set_local(math.min(inst._fade:value() + 1, FADE_FRAMES * 2 + 1))
        k = (FADE_FRAMES * 2 + 1 - inst._fade:value()) / FADE_FRAMES
    end

    inst.Light:SetIntensity(FADE_INTENSITY * k)
    inst.Light:SetRadius(FADE_RADIUS * k)
    inst.Light:SetFalloff(1 - (1 - FADE_FALLOFF) * k)

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._fade:value() > 0 and inst._fade:value() <= FADE_FRAMES * 2)
    end

    if inst._fade:value() == FADE_FRAMES or inst._fade:value() > FADE_FRAMES * 2 then
        inst._fadetask:Cancel()
        inst._fadetask = nil
    end
end

local function OnFadeDirty(inst)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
    OnUpdateFade(inst)
end

local function FadeOut(inst)
    inst._fade:set(FADE_FRAMES + 1)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
end

local function CancelFade(inst)
    inst._fade:set(FADE_FRAMES)
    OnFadeDirty(inst)
end

--------------------------------------------------------------------------
--红包
local SPOREBOMBTARGET_MUST_TAGS = { "debuffable", "player" }
local SPOREBOMBTARGET_CANT_TAGS = { "ghost", "playerghost", "shadow", "shadowminion", "noauradamage", "INLIMBO" }

local function FindSporeBombTargets(inst, preferredtargets)
    local targets = {}

    if preferredtargets ~= nil then
        for i, v in ipairs(preferredtargets) do
            if v:IsValid() and v.entity:IsVisible() and
                v.components.debuffable ~= nil and
                v.components.debuffable:IsEnabled() and
                not v.components.debuffable:HasDebuff("myth_redpouch") and
                not (v.components.health ~= nil and
                    v.components.health:IsDead()) and
                not v:HasTag("playerghost") and
                v:IsNear(inst, TUNING.TOADSTOOL_SPOREBOMB_HIT_RANGE) then
                table.insert(targets, v)
                if #targets >= inst.sporebomb_targets then
                    return targets
                end
            end
        end
    end

    local newtargets = {}
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.TOADSTOOL_SPOREBOMB_ATTACK_RANGE, SPOREBOMBTARGET_MUST_TAGS, SPOREBOMBTARGET_CANT_TAGS)
    for i, v in ipairs(ents) do
        if v.entity:IsVisible() and
            v.components.debuffable ~= nil and
            not v.components.debuffable:HasDebuff("myth_redpouch") and--"sporebomb"
            not (v.components.health ~= nil and
                v.components.health:IsDead()) then
            table.insert(newtargets, v)
        end
    end

    for i = #targets + 1, inst.sporebomb_targets do
        if #newtargets <= 0 then
            return targets
        end
        table.insert(targets, table.remove(newtargets, math.random(#newtargets)))
    end

    return targets
end

local function DoSporeBomb(inst, targets)
    for i, v in ipairs(FindSporeBombTargets(inst, targets)) do
        v.components.debuffable:AddDebuff("myth_redpouch", "myth_redpouch")
    end
end


--------------------------------------------------------------------------
--撒币
local function DoMushroomBomb(inst)
	inst.components.myth_goldfrog_quaker:StartQuake()
end

--------------------------------------------------------------------------

local function FindMushroomSproutAngles(inst)
    local maxspawns = 12
    local delta = 2 * PI / maxspawns
    local offset = 2 * PI * math.random()
    local angles = {}
    for i = 1, maxspawns do
        table.insert(angles, i * delta + offset)
    end
    return angles
end

local function GetSpawnPoint(pt,theta)
    local function TestSpawnPoint(offset)
        local spawnpoint = pt + offset
        return TheWorld.Map:IsAboveGroundAtPoint(spawnpoint:Get())
    end

    local theta = theta
    local radius = GetRandomMinMax(TUNING.TOADSTOOL_MUSHROOMSPROUT_MIN_RANGE, TUNING.TOADSTOOL_MUSHROOMSPROUT_MAX_RANGE) --math.random() * TUNING.FROG_RAIN_SPAWN_RADIUS
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function SpawnFrog(spawn_point)
    local frog = SpawnPrefab("myth_small_goldfrog")
    frog.persists = false
    if math.random() < .5 then
        frog.Transform:SetRotation(180)
    end
    frog.sg:GoToState("fall")
    frog.Physics:Teleport(spawn_point.x, 35, spawn_point.z)
    return frog
end

local function DoMushroomSprout(inst, angles)
    if angles == nil or #angles <= 0 then
        return
    end
	local pt = inst:GetPosition()
	local theta = table.remove(angles, math.random(#angles))
	for k = 1,6 do
		local spawn_point = GetSpawnPoint(pt,theta)
		if spawn_point ~= nil then
			local frog = SpawnFrog(spawn_point)
			frog:StartTracking(inst)
			break
		end
	end
end

local function CalculateLevel(links)
    return (links < 1 and 0)
        or (links < 5 and 1)
        or (links < 8 and 2)
        or 3
end
 
local MYTH_GOLDFROG_ABSORPTION_LVL =
{
    [0] = 0,
    [1] = .1,
    [2] = .2,
    [3] = .3,
}
local function UpdateLevel(inst)
    local level = CalculateLevel(inst.smallfrog)

    if not (inst.sg:HasStateTag("frozen") or inst.sg:HasStateTag("thawing")) then
        inst.level = level
		inst.components.health:SetAbsorptionAmount(MYTH_GOLDFROG_ABSORPTION_LVL[level])
        inst.components.locomotor.walkspeed = TUNING.TOADSTOOL_SPEED_LVL[level]
        inst.components.combat:SetDefaultDamage(TUNING.TOADSTOOL_DAMAGE_LVL[level])
        inst.components.combat:SetAttackPeriod(TUNING.TOADSTOOL_ATTACK_PERIOD_LVL[level])
        inst.hit_recovery = TUNING.TOADSTOOL_HIT_RECOVERY_LVL[level]
        inst.mushroombomb_variance = TUNING.TOADSTOOL_MUSHROOMBOMB_VAR_LVL[level]
        inst.mushroombomb_maxchain = TUNING.TOADSTOOL_MUSHROOMBOMB_CHAIN_LVL[level]
    end

    inst:PushEvent("toadstoollevel", level)
end

--------------------------------------------------------------------------

local function UpdatePlayerTargets(inst)
    local toadd = {}
    local toremove = {}
    local pos = inst.components.knownlocations:GetLocation("spawnpoint")

    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        toremove[k] = true
    end
    for i, v in ipairs(FindPlayersInRange(pos.x, pos.y, pos.z, TUNING.TOADSTOOL_DEAGGRO_DIST, true)) do
        if toremove[v] then
            toremove[v] = nil
        else
            table.insert(toadd, v)
        end
    end

    for k, v in pairs(toremove) do
        inst.components.grouptargeter:RemoveTarget(k)
    end
    for i, v in ipairs(toadd) do
        inst.components.grouptargeter:AddTarget(v)
    end
end

local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "INLIMBO", "prey", "companion"--[[, "smallcreature" <- the beeees... - _-" ]] }
local function RetargetFn(inst)
    UpdatePlayerTargets(inst)

    local player = inst.components.combat.target
    if player ~= nil and player:HasTag("player") then
        local newplayer = inst.components.grouptargeter:TryGetNewTarget()
        if newplayer ~= nil and newplayer:IsNear(inst, TUNING.TOADSTOOL_ATTACK_RANGE) then
            return newplayer, true
        elseif player:IsNear(inst, TUNING.TOADSTOOL_ATTACK_RANGE) then
            return
        elseif newplayer ~= nil then
            player = newplayer
        end
    else
        player = nil
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local nearplayers = FindPlayersInRange(x, y, z, TUNING.TOADSTOOL_ATTACK_RANGE, true)
    if #nearplayers > 0 then
        return nearplayers[math.random(#nearplayers)], true
    end

    --Also needs to deal with other creatures in the world
    local spawnpoint = inst.components.knownlocations:GetLocation("spawnpoint")
    local deaggro_dist_sq = TUNING.TOADSTOOL_DEAGGRO_DIST * TUNING.TOADSTOOL_DEAGGRO_DIST
    local creature = FindEntity(
        inst,
        TUNING.TOADSTOOL_AGGRO_DIST,
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and guy:GetDistanceSqToPoint(spawnpoint) < deaggro_dist_sq
        end,
        RETARGET_MUST_TAGS, --see entityreplica.lua
        RETARGET_CANT_TAGS
    )

    if player ~= nil and
        (   creature == nil or
            player:GetDistanceSqToPoint(x, y, z) <= creature:GetDistanceSqToPoint(x, y, z)
        ) then
        return player, true
    end

    if creature ~= nil then
        return creature, true
    end
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
        and target:GetDistanceSqToPoint(inst.components.knownlocations:GetLocation("spawnpoint")) < TUNING.TOADSTOOL_DEAGGRO_DIST * TUNING.TOADSTOOL_DEAGGRO_DIST
end

local function OnNewTarget(inst, data)
    if data.target ~= nil then
        inst:RemoveEventCallback("newcombattarget", OnNewTarget)
        inst.engaged = true

        --Ability first use timers 
        inst.components.timer:StartTimer("sporebomb_cd", TUNING.TOADSTOOL_ABILITY_INTRO_CD)
        --inst.components.timer:StartTimer("mushroombomb_cd", inst.mushroombomb_cd)
        inst.components.timer:StartTimer("mushroomsprout_cd", inst.mushroomsprout_cd)
        inst.components.timer:StartTimer("pound_cd", TUNING.TOADSTOOL_ABILITY_INTRO_CD, true)
    end
end

local function OnNewState(inst)
    if inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("frozen") or inst.sg:HasStateTag("thawing") then
        inst.components.timer:PauseTimer("mushroomsprout_cd")
    else
        inst.components.timer:ResumeTimer("mushroomsprout_cd")
    end
end

local function ClearRecentAttacker(inst, attacker)
    if inst._recentattackers[attacker] ~= nil then
        inst._recentattackers[attacker]:Cancel()
        inst._recentattackers[attacker] = nil
    end
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil and data.attacker:HasTag("player") then
        if inst._recentattackers[data.attacker] ~= nil then
            inst._recentattackers[data.attacker]:Cancel()
        end
        inst._recentattackers[data.attacker] = inst:DoTaskInTime(120, ClearRecentAttacker, data.attacker)
    end
end

local function AnnounceWarning(inst, player)
    if player:IsValid() and player.entity:IsVisible() and
        not (player.components.health ~= nil and player.components.health:IsDead()) and
        not player:HasTag("playerghost") and
        not (inst.sg:HasStateTag("noattack") or
            inst.components.combat:HasTarget() or
            inst.components.health:IsDead()) and
        player.components.talker ~= nil then
        player.components.talker:Say(GetString(player, "ANNOUNCE_TOADESCAPING"))
    end
end

local function OnFleeWarning(inst)
    if not (inst.sg:HasStateTag("noattack") or inst.components.health:IsDead()) then
        local x, y, z = inst.Transform:GetWorldPosition()
        local players = FindPlayersInRange(x, y, z, 40)
        for i, v in ipairs(players) do
            if inst._recentattackers[v] ~= nil then
                inst:DoTaskInTime(math.random() * 2, AnnounceWarning, v)
            end
        end
    end
end

local function AnnounceEscaped(player)
    if player:IsValid() and player.entity:IsVisible() and
        not (player.components.health ~= nil and player.components.health:IsDead()) and
        not player:HasTag("playerghost") and
        player.components.talker ~= nil then
        player.components.talker:Say(GetString(player, "ANNOUNCE_TOADESCAPED"))
    end
end

local function OnEscaped(inst)
	inst:OnSpit()
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, 40)
	
	if inst.gohome then --战败掉落
		SpawnPrefab("myth_treasure_bowl").Transform:SetPosition(x, y, z)
		if not TheWorld.components.yqs_record:IsFull() then
			inst.components.lootdropper:SpawnLootPrefab("myth_cash_tree")
			TheWorld.components.yqs_record:SetFull()
		end
		for k = 1,20 do
			inst.components.lootdropper:SpawnLootPrefab("myth_coin")
			inst.components.lootdropper:SpawnLootPrefab("lucky_goldnugget")
		end
		for k = 1,10 do
			inst.components.lootdropper:SpawnLootPrefab("goldnugget")
		end
		for k = 1,4 do
			inst.components.lootdropper:SpawnLootPrefab(gems[math.random(#gems)])
		end
		inst.components.lootdropper:SpawnLootPrefab("opalpreciousgem")
	else
		local players = FindPlayersInRange(x, y, z, 40)
		for i, v in ipairs(players) do
			if inst._recentattackers[v] ~= nil or v:IsNear(inst, 15) then
				v:DoTaskInTime(math.random(), AnnounceEscaped)
			end
		end
	end
    inst:Remove()
end

--------------------------------------------------------------------------

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

--------------------------------------------------------------------------

local function OnEntitySleep(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
    end
    inst._sleeptask = not inst.components.health:IsDead() and inst:DoTaskInTime(10, inst.Remove) or nil
end

local function OnEntityWake(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
        inst._sleeptask = nil
    end
end

--------------------------------------------------------------------------

local PHASE2_HEALTH = .7
local PHASE3_HEALTH = .4

local function SetPhaseLevel(inst, phase)
    inst.phase = phase
    inst.pound_rnd = phase > 3 and inst.dark
    phase = math.min(3, phase)
    inst.sporebomb_targets = TUNING.TOADSTOOL_SPOREBOMB_TARGETS_PHASE[phase]
    inst.sporebomb_cd = TUNING.TOADSTOOL_SPOREBOMB_CD_PHASE[phase]
    inst.mushroombomb_count = TUNING.TOADSTOOL_MUSHROOMBOMB_COUNT_PHASE[phase]
    if phase > 2 then
        inst.components.timer:ResumeTimer("pound_cd")
    else
        inst.components.timer:StopTimer("pound_cd")
        inst.components.timer:StartTimer("pound_cd", TUNING.TOADSTOOL_ABILITY_INTRO_CD, true)
    end
end


local prizevalues = 
{
	myth_coin = 75,
	gems = 5,
	lucky_goldnugget = 75,
	goldnugget = 40,

}

local function DropGem(inst)
	local item = weighted_random_choice(prizevalues)
	if item == "gems" then
		item = gems[math.random(#gems)]
	end
    local player = inst:GetNearestPlayer()
    LaunchAt(SpawnPrefab(item), inst, player, 1, 4, 2)
end

local function EnterPhase2Trigger(inst)
    if inst.phase < 2 then
        SetPhaseLevel(inst, 2)
        if inst.components.health:GetPercent() > PHASE3_HEALTH then
            DropGem(inst)
        end
        inst:PushEvent("roar")
    end
end

local function EnterPhase3Trigger(inst)
    if inst.phase < 3 then
        SetPhaseLevel(inst, 3)
        if not inst.components.health:IsDead() then
            DropGem(inst)
        end
        inst:PushEvent("roar")
    end
end


local function OnSave(inst, data)
    data.phase = inst.phase
    data.engaged = inst.engaged or nil
    data.poundspeed = inst.pound_speed > 0 and math.floor(inst.pound_speed) or nil
end

local function OnLoad(inst, data)
    if data ~= nil and data.phase ~= nil then
        SetPhaseLevel(inst, data.phase)
    else
        local healthpct = inst.components.health:GetPercent()
        SetPhaseLevel(
            inst,
            (healthpct > PHASE2_HEALTH and 1) or
            (healthpct > PHASE3_HEALTH and 2) or
            ((not inst.dark or healthpct > PHASE4_HEALTH) and 3) or
            4
        )
    end

    if data ~= nil then
        if data.poundspeed ~= nil then
            inst.pound_speed = math.max(0, data.poundspeed)
        end
        if data.engaged then
            inst:RemoveEventCallback("newcombattarget", OnNewTarget)
            inst.engaged = true
        end
    end
end

--------------------------------------------------------------------------

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
        not inst.recentlycharged[other] then
        inst:DoTaskInTime(2 * FRAMES, OnDestroyOther, other)
    end
end

--------------------------------------------------------------------------

local function getstatus(inst)
    return inst.level >= 3  and "RAGE" or nil
end

local function PushMusic(inst)
    if ThePlayer == nil then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 30 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("triggeredevent", { name = "toadstool" })
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 40) then
        inst._playingmusic = false
    end
end
----------------------------------------------------------------------------
local function OnMiniHealth(inst)
	if not inst.gohome then
		inst.gohome = true
		inst:PushEvent("gohome")
	end
end
--------------------------------------------------------------------------

local function CountDamage(inst,data)
	if data and data.damage then
		inst.toatldamage = inst.toatldamage + data.damage
	end
	if inst.startcount and inst.toatldamage > 500  then --伤害满了
		inst.startcount = false
		inst.components.timer:StopTimer("on_eat_player")
		if not inst.components.health:IsDead() then
			if inst.eat_player ~= nil then
				inst:PushEvent("gotospit")
			end
		end
	end
end

local function OnTimeDone(inst,data)
	if data and data.name and data.name == "on_eat_player" then
		inst.startcount = false
		if not inst.components.health:IsDead() then
			if inst.eat_player ~= nil then
				inst:PushEvent("gotospit")
			end
		end
	end
end

local function OnEat(inst,player)
	if player and not player.components.health:IsDead() and player:IsValid() and player.sg then
		inst.eat_player = player
		player.sg:GoToState("eatbyfrog",inst)
		inst.startcount = true
		inst.toatldamage = 0
		inst:ListenForEvent("attacked", CountDamage)
	end
end

local function OnSpit(inst)
	local player = inst.eat_player
	if player ~= nil then
		player:PushEvent("spitbyfrog")
		inst.eat_player = nil
		player.eat_boss = nil
	end
	inst:RemoveEventCallback("attacked", CountDamage)
end

---------------------------------------------------------------------------
local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()

    inst.DynamicShadow:SetSize(6, 3.5)

    inst.Light:SetRadius(FADE_RADIUS)
    inst.Light:SetFalloff(FADE_FALLOFF)
    inst.Light:SetIntensity(FADE_INTENSITY)
    inst.Light:SetColour(255 / 255, 235 / 255, 153 / 255)
    inst.Light:EnableClientModulation(true)

    MakeGiantCharacterPhysics(inst, 1000, 2.5)

    inst.AnimState:SetBank("myth_toadstool")
    inst.AnimState:SetBuild("myth_goldfrog")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetLightOverride(.3)
	inst.AnimState:HideSymbol("puff_small")
	
    inst:AddTag("epic")
    inst:AddTag("noepicmusic")
    inst:AddTag("monster")
    inst:AddTag("myth_goldfrog") --自己的标签
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
	inst:AddTag("noteleport")

    inst._fade = net_smallbyte(inst.GUID, "myth_goldfrog._fade", "fadedirty")

    inst.entity:SetPristine()

    --Dedicated server does not need to trigger music
    if not TheNet:IsDedicated() then
        inst._playingmusic = false
        inst:DoPeriodicTask(1, PushMusic, 0)
    end

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", OnFadeDirty)

        return inst
    end

    inst.recentlycharged = {}
    inst.Physics:SetCollisionCallback(OnCollide)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("lootdropper")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper.diminishingreturns = true

    inst:AddComponent("locomotor")
    inst.components.locomotor.pathcaps = { ignorewalls = true }
    inst.components.locomotor.walkspeed = TUNING.TOADSTOOL_SPEED_LVL[0]

    inst:AddComponent("health")
    inst.components.health.nofadeout = true
	inst.components.health.fire_damage_scale = 0
	inst.components.health.minhealth = 1

    inst:AddComponent("healthtrigger")
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger) --0.7
    inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, EnterPhase3Trigger) --0.4
    inst.components.healthtrigger:AddTrigger(0.9, DropGem)	
    inst.components.healthtrigger:AddTrigger(0.8, DropGem)
    inst.components.healthtrigger:AddTrigger(0.6, DropGem)	
    inst.components.healthtrigger:AddTrigger(0.5, DropGem)	
    inst.components.healthtrigger:AddTrigger(0.3, DropGem)
    inst.components.healthtrigger:AddTrigger(0.2, DropGem)
    inst.components.healthtrigger:AddTrigger(0.1, DropGem)

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.TOADSTOOL_ATTACK_PERIOD_LVL[0])
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(TUNING.TOADSTOOL_ATTACK_RANGE)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat.hiteffectsymbol = "toad_torso"

    inst:AddComponent("explosiveresist")

    inst:AddComponent("sanityaura")

    inst:AddComponent("epicscare")
    inst.components.epicscare:SetRange(TUNING.TOADSTOOL_EPICSCARE_RANGE)

    inst:AddComponent("timer")

    inst:AddComponent("grouptargeter")

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.platformPushingRings = 0
	table.insert(inst.components.groundpounder.noTags,"myth_small_goldfrog")

    inst:AddComponent("knownlocations")
	inst:AddComponent("myth_goldfrog_quaker")

    --MakeLargeBurnableCharacter(inst, "swap_fire")
    --MakeHugeFreezableCharacter(inst, "toad_torso")
    --inst.components.freezable.diminishingreturns = true

    inst:SetStateGraph("SGmyth_goldfrog")
    inst:SetBrain(brain)

    inst.FindSporeBombTargets = FindSporeBombTargets
    inst.DoSporeBomb = DoSporeBomb 
    inst.DoMushroomBomb = DoMushroomBomb 
    inst.FindMushroomSproutAngles = FindMushroomSproutAngles
    inst.DoMushroomSprout = DoMushroomSprout
    inst.OnEscaped = OnEscaped

    inst.sporebomb_targets = TUNING.TOADSTOOL_SPOREBOMB_TARGETS_PHASE[1]
    inst.sporebomb_cd = TUNING.TOADSTOOL_SPOREBOMB_CD_PHASE[1]

    inst.mushroombomb_count = TUNING.TOADSTOOL_MUSHROOMBOMB_COUNT_PHASE[1]
    inst.mushroombomb_variance = TUNING.TOADSTOOL_MUSHROOMBOMB_VAR_LVL[0]
    inst.mushroombomb_maxchain = TUNING.TOADSTOOL_MUSHROOMBOMB_CHAIN_LVL[0]
    inst.mushroombomb_cd = TUNING.TOADSTOOL_MUSHROOMBOMB_CD

    inst.mushroomsprout_cd = TUNING.TOADSTOOL_MUSHROOMSPROUT_CD

    inst.pound_cd = TUNING.TOADSTOOL_POUND_CD
    inst.pound_speed = 0
    inst.pound_rnd = false

    inst.hit_recovery = TUNING.TOADSTOOL_HIT_RECOVERY_LVL[0]

    inst.phase = 1
    inst.level = 0
	inst.smallfrog = 0
	inst.toatldamage = 0
	inst.gohome = false

    inst._recentattackers = {}
    inst.engaged = false

    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("newstate", OnNewState)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("fleewarning", OnFleeWarning)
	inst:ListenForEvent("minhealth", OnMiniHealth)
	inst:ListenForEvent("timerdone", OnTimeDone)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst.FadeOut = FadeOut
    inst.CancelFade = CancelFade
	inst.OnEat = OnEat
	inst.OnSpit = OnSpit
    inst.UpdateLevel = UpdateLevel

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
end

local function normal_fn()
    local inst = common_fn()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.health:SetMaxHealth(99999)
    inst.components.health:SetAbsorptionAmount(TUNING.TOADSTOOL_ABSORPTION_LVL[0])

    inst.components.combat:SetDefaultDamage(TUNING.TOADSTOOL_DAMAGE_LVL[0])

    inst.components.lootdropper:SetChanceLootTable("myth_goldfrog")

    return inst
end

return Prefab("myth_goldfrog", normal_fn, assets, prefabs)
