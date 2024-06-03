--- 2021.3.31
-- 削弱犀牛的减伤系数\攻击频率\冲刺距离\冲刺速度
-- 犀牛不会攻击海面的目标，也不会离开供桌太远
-- 犀牛的攻击附带摧毁效果

-- todo 
-- 玉兔和杨健的检查语句


local assets =
{
    Asset("ANIM", "anim/lavaarena_rhinodrill_basic.zip"),
    Asset("ANIM", "anim/myth_rhino_blue.zip"),
    Asset("ANIM", "anim/myth_rhino_red.zip"),
    Asset("ANIM", "anim/myth_rhino_yellow.zip"),
}
local L = MK_MOD_LANGUAGE_SETTING

STRINGS.NAMES.RHINO3_RED ='辟暑大王' 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RHINO3_RED = '辟暑大王' 

STRINGS.NAMES.RHINO3_BLUE = '辟寒大王' 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RHINO3_BLUE = '辟寒大王' 

STRINGS.NAMES.RHINO3_YELLOW = '辟尘大王' 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RHINO3_YELLOW = '辟尘大王'

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MYTH_RHINO = "啊！有妖气！"
-- STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.MYTH_RHINO = "你们这群妖怪又来骗油吃"
-- STRINGS.CHARACTERS.NEZA.DESCRIBE.MYTH_RHINO = "装神弄鬼的家伙，待小爷收拾你们"
-- STRINGS.CHARACTERS.WHITE_BONE.DESCRIBE.MYTH_RHINO = "送走三位，便是奴家受这香火了"
-- STRINGS.CHARACTERS.PIGSY.DESCRIBE.MYTH_RHINO = "大师兄，有妖怪！"
-- STRINGS.CHARACTERS.YANGJIAN.DESCRIBE.MYTH_RHINO = "你们这群妖怪又来骗油吃"
-- STRINGS.CHARACTERS.MYTH_YUTU.DESCRIBE.MYTH_RHINO = ""

local function descriptionfn(inst, viewer)
    local prefab = viewer.prefab
    if prefab == 'monkey_king' then
        return '你们这群妖怪又来骗油吃'
    elseif prefab == 'neza' then
        return '装神弄鬼的家伙，待小爷收拾你们'
    elseif prefab == 'white_bone' then
        return '送走三位，便是奴家受这香火了'
    elseif prefab == 'pigsy' then
        return '大师兄，有妖怪！'
    else
        return "啊！有妖气！"
    end
end

require 'stategraphs/SGrhino3'

local ATTACKED_BY_SPELL = {
    '你这蠢货，怕不是被敌人戳瞎了眼。',
    '平时练习配合那么好，关键时候掉链子啊你。',
    '你这头蠢牛！',
    '靠边站，别挡着大爷我发挥实力。',
    '兄弟齐心，才能断金！',
    '让我来打头阵！',
    '不好好在府里待着，非要跟来。',
    '你怕不是想杀了我俩独吞香油。',
}

local function OnAttackedBySpell(inst)
    if inst.components.health:IsDead() then return end
    if GetTime() - inst.last_spelled > 15 then
        inst.last_spelled = GetTime()
        inst.components.talker:Say(ATTACKED_BY_SPELL[math.random(#ATTACKED_BY_SPELL)])
    end
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function RetargetFn(inst, target)
    local r = inst.stage == 2 and 28 or 20 --2 法术
    if (inst.stage == 3 and inst.resurrected ) or inst.friendly then return end
    return FindEntity(inst, r, function(guy)
        return inst.components.combat:CanTarget(guy) and not guy:HasTag('mythTag_rhino') and guy:HasTag("player") and 
        (not guy:IsOnOcean(true) or inst.stage == 2 and guy:IsOnOcean(true))
    end)
end

local function OnAttacked(inst, data)
    if inst.desk and inst.desk.rhinos then
        for k, v in pairs(inst.desk.rhinos) do
            k.friendly = false
        end
    end

    if data and data.attacker then
        inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
            return dude:HasTag("mythTag_rhino") and not dude.components.health:IsDead()
        end, 10)
        inst.components.combat:SetTarget(data.attacker)
    end
end

local SPELL_INTERVAL = 12
--local function GetSpellInterval(inst) return 10 end
local MAX_SPELL_RUN_TIME = 12 

local function isSpellAvailable(inst)
    if inst.components.health:IsDead()then return false end
    if inst.sg:HasStateTag('dashing') then return false end
    if inst.components.combat.target and inst.stage == 2 
    and inst.components.combat.target:IsValid()
    and GetTime() - inst.last_spell_time > SPELL_INTERVAL
        then
        return true
    end
end

local function ShouldSpellRun(inst)
    if isSpellAvailable(inst) then
        if inst:GetDistanceSqToInst(inst.components.combat.target) > 20 * 20 then
            return false
        else
            inst.last_spell_runtime = GetTime()
            return true
        end
    end
end

local spellprefabs = {'deer_fire_circle', 'deer_ice_circle', 'antlion_sinkhole'}
local function shouldDoSpell(inst)
    if inst.components.health:IsDead()then return false end
    if inst.stage ~= 2 then return false end
    local target = inst.components.combat.target
    if not (target and target:IsValid()) then return false end
    return isSpellAvailable(inst)
    and (inst:GetDistanceSqToInst(target) > 5 * 5
    or GetTime() - inst.last_spell_runtime > MAX_SPELL_RUN_TIME)
end

local function ShouldLeave(inst)
    if inst.stage == 1 and inst.components.health:GetPercent() == 1 and TheWorld.state.isday then
        return true
    end
end

--冲刺
local DASH_INTERVAL = 25
local function CanDash(inst)
    return GetTime() - inst.last_dash_time > DASH_INTERVAL
end

local STAGE_DATA = {
    absorb = { 0, 0.1, 0.2 },
    damage = { 1, 1.5, 2 },
    period = { 3, 2, 1 },
    scale  = { 1, 1.2, 1.4},
}

--三个阶段！？？
local function SetStage(inst, num)
    num = num or inst.stage or 1
    inst.stage = num

    if num == 1 then 
        inst.components.combat:SetAttackPeriod(3)
        inst.components.health:StopRegen()
        inst.components.combat:SetRange(4, 4.2)
        inst.components.combat:SetDefaultDamage(200)
    elseif num == 2 then
        inst.components.combat:SetAttackPeriod(3)
        inst.components.health:StartRegen(10, 1)
        inst.components.combat:SetRange(30, 30)
        inst.components.combat:SetDefaultDamage(400)
    else
        inst.components.combat:SetAttackPeriod(10)
        inst.components.combat:SetRange(8, 8)
        inst.components.health:StartRegen(10, 1)
        inst.components.combat:SetDefaultDamage(300)
    end
end

--防灭月代码
local function GetNoLeaderHomePos(inst)
    local desk = inst.desk
    if desk and desk:IsValid() then
        local pos = Point()
        local num = 0
        for k in pairs(desk.rhinos)do
            if k:IsValid() then
                pos = pos + k:GetPosition()
                num = num + 1
            end
        end
        return pos/num
    end
end

local function ShouldReturnHome(inst, dist)
    dist = dist or 20
    return GetNoLeaderHomePos(inst) and inst:GetPosition():DistSq(GetNoLeaderHomePos(inst)) > dist*dist
end

local function CheckTarget(inst, target)
    local target = target or inst.components.combat.target
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        -- OnWater?
        if target:IsOnOcean(true) then --???
            return "WATER"
        else
            return "GROUND"
        end
    end
    return nil
end

local function PeriodicCheckTarget(inst, data)
    local laststate = data.state
    local lastentity = data.entity

    local state = inst:CheckTarget()

    if state == "WATER" --and laststate == "GROUND" 
        and lastentity == inst.components.combat.target then
        inst.components.combat:DropTarget()
        if laststate == "GROUND" then
            inst:PushEvent("rhino_targetgotowater", {target = lastentity})
        end
    end

    data.state = state 
    data.entity = inst.components.combat.target
end


local function OnTargetOnWater(inst)
    inst.components.talker:Say("就这就这就这?")
end

local function ShouldProtectDesk(inst)
    return inst:GetDistanceSqToPoint(inst:GetDeskPos()) > 40*40
end

local function CanDoDash(inst)
    if inst.stage == 3 and not inst.resurrected and not inst.components.health:IsDead() 
        and GetTime() - (inst.lastattack_dash or 0) > 10 then
        return true
    end
    return false
end

local function GetDeskPos(inst)
    if inst.desk and inst.desk:IsValid() then
        return inst.desk:GetPosition()
    else
        return inst:GetPosition()
    end
end

local function teleport_override_fn(inst)
    local ipos = inst:GetPosition()
    local offset = FindWalkableOffset(ipos, 2*PI*math.random(), 10, 8, true, false)
        or FindWalkableOffset(ipos, 2*PI*math.random(), 14, 8, true, false)

    return (offset ~= nil and ipos + offset) or ipos
end

local function resurrect(inst)
    if inst.desk and inst.desk.rhinos then
        for k, v in pairs(inst.desk.rhinos) do
            if k ~= inst and k:IsValid() and k.components.health  then
                if  k.components.health:GetPercent() < 0.25 then
                    k.components.health:SetPercent(0.25)
                end
            end
		    k.components.health.nofadeout = false
			k.resurrected = false
        end
        inst.desk.components.myth_rhino_team:Rework()
    end
end

local function reviveme(inst)
    if inst.desk and inst.desk.rhinos then
        for k, v in pairs(inst.desk.rhinos) do
            if k ~= inst and  not k.components.health:IsDead() then
                k.sg:GoToState("taunt",inst)
            end
        end
        inst.desk.components.myth_rhino_team:Pause()
    end
end

local function getdashtarget(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local player = FindClosestPlayerInRange(x, y, z, 12, true)
    return player
end

local function ArmorTask(inst)
    if not inst.components.health:IsDead() then
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, 0, z, 32, {"player"}, {"playerghost", "FX", "NOCLICK"})
        if #ents > 3 then 
            inst.components.health:SetAbsorptionAmount(0.5)
        elseif #ents > 1 then
            inst.components.health:SetAbsorptionAmount(0.25)
        else
            inst.components.health:SetAbsorptionAmount(0)
        end
    end
end



local function PushMusic(inst)
    if ThePlayer ~= nil and ThePlayer:IsNear(inst, 30) then
        ThePlayer:PushEvent("triggeredevent", { name = "myth_rhino3_boss" })
    end
end

local function OnMusicDirty(inst)
    if not TheNet:IsDedicated() then
        if inst._music:value() then
            if inst._musictask == nil then
                inst._musictask = inst:DoPeriodicTask(1, PushMusic, 0)
            end
        elseif inst._musictask ~= nil then
            inst._musictask:Cancel()
            inst._musictask = nil
        end
    end
end

local function StartMusic(inst)
    if not (inst._music:value() or inst.components.health:IsDead()) then
        inst._music:set(true)
        OnMusicDirty(inst)
    end
end

local function StopMusic(inst)
    if inst._music:value() then
        inst._music:set(false)
        OnMusicDirty(inst)
    end
end

local function CommonRhino()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(2.5, 1.2)
    inst.Transform:SetSixFaced()
    inst.Transform:SetScale(0.85, 0.85, 1)

    MakeCharacterPhysics(inst, 400, 1)
    inst.physicsradiusoverride = 1

    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)

    inst.AnimState:SetBank("rhinodrill")

    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("epic")
    inst:AddTag("noepicmusic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("mythTag_rhino")
    inst:AddTag("ignorewalkableplatformdrowning")

    inst:AddComponent('talker')
    inst.components.talker.fontsize = 50
    inst.components.talker.offset = Vector3(0, -800, 0)


    inst._music = net_bool(inst.GUID, "rhino._music", "musicdirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("musicdirty", OnMusicDirty)

        return inst
    end

    inst.resurrected = false
    inst.brothers = {}
    inst.knockbacktarget  = {}
    inst.friendly = true
    inst.last_spell_time = 0--GetTime() + math.random(10)
    inst.last_spell_runtime = 0
    inst.last_dash_time = GetTime() + math.random(10)
    inst.CanSpell = isSpellAvailable
    inst.ShouldSpellRun = ShouldSpellRun
    inst.CanDoSpell = shouldDoSpell
    inst.CanDash = CanDash
    inst.CheckTarget = CheckTarget
    inst.CanDoDash = CanDoDash
    --inst.spelltask = inst:DoPeriodicTask(0.1, SpellTask)
    --inst.checktargettask = inst:DoPeriodicTask(1, PeriodicCheckTarget, nil, {})

    inst.armortask = inst:DoPeriodicTask(1, ArmorTask,1)

    inst.GetDeskPos = GetDeskPos
    inst.ShouldProtectDesk = ShouldProtectDesk

    inst.ShouldReturnHome = ShouldReturnHome
    inst.OnAttackedBySpell = OnAttackedBySpell

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(10000)
    inst.components.health.destroytime = 5
    inst.components.health.fire_damage_scale = 0.2
    inst.components.health.nofadeout = true

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(200) --伤害50 
    --inst.components.combat:SetRange(3.4, 4.2)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    --inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/bearger/hurt")
    ----
    inst:AddComponent("explosiveresist")

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "myth_rhino"
    inst.components.inspectable.descriptionfn = descriptionfn

    inst:AddComponent("knownlocations")

    inst:AddComponent("timer")

    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("teleportedoverride")
    inst.components.teleportedoverride:SetDestPositionFn(teleport_override_fn)

    MakeLargeBurnableCharacter(inst, "body")
    inst.components.burnable:SetBurnTime(2)
    --MakeHugeFreezableCharacter(inst, "body")

    inst:AddComponent("sleeper") --防止风铃乱打断！
    inst.components.sleeper:SetResistance(8)
    inst.components.sleeper.wearofftime = 3
    inst.components.sleeper.sleeptestfn = function() return false end

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 6.6

    inst.Resurrect = resurrect
    inst.ReviveMe = reviveme
    inst.SetStage = SetStage
    inst.GetDashTarget = getdashtarget
    inst:SetStage(1)

    inst.OnSave = function(inst, data)
        --data.stage = inst.stage
        data.desk = inst.desk and inst.desk.GUID 
        return {data.desk}
    end
    inst.OnLoad = function(inst, data)
        --inst:SetStage(data and data.stage or 1)
    end
    inst.OnLoadPostPass = function(inst, ents, data)
        if data and data.desk and ents[data.desk] then
            inst.desk = ents[data.desk].entity
            if inst.desk then
                inst.desk.rhinos[inst] = true
            end
        end
    end

    inst:SetStateGraph("SGrhino3")
    local brain = require("brains/rhino3brain")
    inst:SetBrain(brain)

    inst:ListenForEvent("rhino_targetgotowater", OnTargetOnWater)

    inst:ListenForEvent('mythEvent_attackedbyspell', OnAttackedBySpell)
    inst.last_spelled = 0

    inst.ShouldLeave = ShouldLeave

    StartMusic(inst)

    return inst
end

local function onspell(inst,fx)
    local x, y, z = inst.Transform:GetWorldPosition()  
    local fx = SpawnPrefab(fx)
    fx.Transform:SetPosition(x, 0, z)
    if inst:IsValid() and inst.components.health
        and not inst.components.health:IsDead() and  inst.components.mk_flyer and inst.components.mk_flyer:IsFlying() then
        inst.components.mk_flyer:SetFlying(false)
        inst.components.mk_flyer._percent:set(0)	
    end
	local ents = TheSim:FindEntities(x, 0, z, 6, nil, {"playerghost", "FX", "NOCLICK"},{"boat"})
    for i, v in ipairs(ents) do
        if v:IsValid() and v.components.health
			and not v.components.health:IsDead() and v:HasTag("boat") then
			v.components.health:DoDelta(-200)
		end
	end
end

local function RhinoBlue()
    local inst = CommonRhino()
    inst:AddTag('rhino3_blue')
    inst.AnimState:SetBuild('myth_rhino_blue')

    inst.spellfn = function(inst,target)
        onspell(target,'myth_rhino_fx_blue')
        for _, v in ipairs(AllPlayers) do
            if v:IsValid() and v ~= target and v:GetDistanceSqToInst(inst) < 20 * 20 and not v:HasTag("playerghost") and not v.components.health:IsDead() then
                onspell(v,'myth_rhino_fx_blue')
            end
        end
    end

    inst.components.talker.colour = Point(0.6,0.6,1)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetLoot({
        "minotaurhorn",
        "bluegem", "bluegem", "bluegem", 
        "myth_coin", "myth_coin", "myth_coin", "myth_coin", "myth_coin",
        "myth_rhino_blueheart",
        'myth_redlantern',
        "meat","meat","meat","meat",
        'lucky_goldnugget','lucky_goldnugget','lucky_goldnugget','lucky_goldnugget','lucky_goldnugget'
    })

    return inst
end

local function RhinoRed()
    local inst = CommonRhino()
    inst:AddTag('rhino3_red')
    inst.AnimState:SetBuild('myth_rhino_red')

    inst.spellfn = function(inst,target)
        onspell(target,'myth_rhino_fx_red')
        for _, v in ipairs(AllPlayers) do
            if v:IsValid() and v ~= target and v:GetDistanceSqToInst(inst) < 20 * 20 and not v:HasTag("playerghost") and not v.components.health:IsDead() then
                onspell(v,'myth_rhino_fx_red')
            end
        end
    end

    inst.components.talker.colour = Point(0.75,0.25,0.25)

    local light = inst.entity:AddLight()
    light:Enable(true)
    light:SetRadius(2)
    light:SetFalloff(0.5)
    light:SetIntensity(.75)
    light:SetColour(235/255,121/255,12/255)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetLoot({
        "minotaurhorn",
        "redgem", "redgem", "redgem", 
        "myth_coin", "myth_coin", "myth_coin", "myth_coin", "myth_coin",
        "myth_rhino_redheart",
        'myth_redlantern',
        "meat","meat","meat","meat",
        'lucky_goldnugget','lucky_goldnugget','lucky_goldnugget','lucky_goldnugget','lucky_goldnugget'
    })
    inst:RemoveComponent('burnable')
    inst.components.health.vulnerabletoheatdamage = false

    return inst
end

local function RhinoYellow()
    local inst = CommonRhino()
    inst:AddTag('rhino3_yellow')
    inst.AnimState:SetBuild('myth_rhino_yellow')

    inst.spellfn = function(inst,target)
        onspell(target,'myth_rhino_fx_yellow')
        for _, v in ipairs(AllPlayers) do
            if v:IsValid() and v ~= target and v:GetDistanceSqToInst(inst) < 20 * 20 and not v:HasTag("playerghost") and not v.components.health:IsDead() then
                onspell(v,'myth_rhino_fx_yellow')
            end
        end
    end

    inst.components.talker.colour = Point(0.75,0.6,0.0)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetLoot({
        "minotaurhorn",
        "yellowgem", "yellowgem", "yellowgem", 
        "myth_coin", "myth_coin", "myth_coin", "myth_coin", "myth_coin",
        "myth_rhino_yellowheart",
        'myth_redlantern',
        "meat","meat","meat","meat",
        'lucky_goldnugget','lucky_goldnugget','lucky_goldnugget','lucky_goldnugget','lucky_goldnugget'
    })

    return inst
end

local function come()
    --纯主机实体
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetTarget = function(inst, desk)
        if not (desk and desk:IsValid()) then
            return
        end
        local ori = desk:GetPosition()
        local dist = 8
        for i = 1, 1000 do
            local angle = 2*PI*math.random()
            local offset = Vector3(math.sin(angle)*dist, 0, math.cos(angle)*dist)
            local pos = offset + ori
            if TheWorld.Map:IsVisualGroundAtPoint(pos:Get()) then
                desk.components.myth_rhino_team:ReStart()
                for _,v in ipairs({'yellow', 'blue', 'red'})do
                    local rhino = SpawnPrefab('rhino3_'..v)
                    rhino.Transform:SetPosition(pos:Get())
                    rhino.desk = desk
                    desk.rhinos[rhino] = true
                    rhino.persists = false
                    rhino.resurrected = true
                    rhino.last_spell_time = GetTime() - 8
                    desk.components.myth_rhino_team:AddTeammate(rhino)
                end
                desk.components.myth_rhino_team:Start()
                return
            end
        end
    end
    inst.persists = false
    inst.entity:SetCanSleep(false)
    return inst
end

return 
Prefab('rhino3_red', RhinoRed, assets),
Prefab('rhino3_yellow', RhinoYellow, assets),
Prefab('rhino3_blue', RhinoBlue, assets),
Prefab('myth_rhino_come', come)
