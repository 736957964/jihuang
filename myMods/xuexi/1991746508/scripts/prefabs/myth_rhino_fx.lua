local assets = {
    Asset("ANIM", "anim/myth_rhino_fx.zip"),
}

local tornadoassets = {
    Asset("ANIM", "anim/myth_tornadofx.zip"),
}

local ICE_COLOUR = { 60/255, 120/255, 255/255 }
local FIRE_COLOUR = { 220/255, 100/255, 0/255 }
local SAND_COLOUR = { 124/255, 107/255, 41/255 }

local function OnUpdateFade(inst)
    local k
    if inst._fade:value() <= inst._fadeframes then
        inst._fade:set_local(math.min(inst._fade:value() + inst._fadeinspeed, inst._fadeframes))
        k = inst._fade:value() / inst._fadeframes
    else
        inst._fade:set_local(math.min(inst._fade:value() + inst._fadeoutspeed, inst._fadeframes * 2 + 1))
        k = (inst._fadeframes * 2 + 1 - inst._fade:value()) / inst._fadeframes
    end

    inst.Light:SetIntensity(inst._fadeintensity * k)
    inst.Light:SetRadius(inst._faderadius * k)
    inst.Light:SetFalloff(1 - (1 - inst._fadefalloff) * k)

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._fade:value() > 0 and inst._fade:value() <= inst._fadeframes * 2)
    end

    if inst._fade:value() == inst._fadeframes or inst._fade:value() > inst._fadeframes * 2 then
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
    inst._fade:set(inst._fadeframes + 1)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
end

----冰冰冰
local ICE_CIRCLE_RADIUS = 3
local NOTAGS = { "playerghost", "INLIMBO","mythTag_rhino","fx","NOCLICK", "DECOR",}
for k, v in pairs(FUELTYPE) do
    table.insert(NOTAGS, v.."_fueled")
end

local RANDOM_SEGS = 8
local SEG_ANGLE = 360 / RANDOM_SEGS
local ANGLE_VARIANCE = SEG_ANGLE * 2 / 3
local function GetRandomAngle(inst)
    if inst.angles == nil then
        inst.angles = {}
        local offset = math.random() * 360
        for i = 0, RANDOM_SEGS - 1 do
            table.insert(inst.angles, offset + i * SEG_ANGLE)
        end
    end
    local rnd = math.random()
    rnd = rnd * rnd
    local angle = table.remove(inst.angles, math.max(1, math.ceil(rnd * rnd * RANDOM_SEGS)))
    table.insert(inst.angles, angle)
    return (angle + math.random() * ANGLE_VARIANCE) * DEGREES
end

local function DoBurst(inst, x, z, minr, maxr,hasfx)
    local fx = SpawnPrefab(hasfx or inst.burstprefab )
    local theta = GetRandomAngle(inst)
    local rad = GetRandomMinMax(minr, maxr)
    if hasfx then
        local s = 1 + math.random()    
        fx.Transform:SetScale(s,s,s)
    end
    fx.Transform:SetPosition(x + rad * math.cos(theta), 0, z + rad * math.sin(theta))
end

local function DoBubble(inst, x, z, minr, maxr)
    local fx = SpawnPrefab("crab_king_bubble"..math.random(3))
    local theta = GetRandomAngle(inst)
    local rad = GetRandomMinMax(minr, maxr)
    fx.Transform:SetPosition(x + rad * math.cos(theta), 0, z + rad * math.sin(theta))
end

local FREEZETARGET_ONEOF_TAGS = { "locomotor", "freezable", "fire", "smolder" }
local function OnUpdateIceCircle(inst, x, z)
    inst._rad:set(inst._rad:value() * .98 + ICE_CIRCLE_RADIUS * .02)
    --if inst.fx ~= nil then
        inst.burstdelay = (inst.burstdelay or 6) - 1
        if inst.burstdelay < 0 then
            inst.burstdelay = math.random(5, 6)
            DoBurst(inst, x, z, 2, 3)
            DoBubble(inst, x, z, 2, 3)
        end
    --end

    inst._track1 = inst._track2 or {}
    inst._track2 = {}

    for i, v in ipairs(TheSim:FindEntities(x, 0, z, 2.8, nil, NOTAGS, FREEZETARGET_ONEOF_TAGS)) do
        if v:IsValid() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            local gemresist = false
            if v.components.locomotor ~= nil then
                if v:HasTag("mythTag_rhino") then
                    gemresist = true
                else
                    if inst._rad:value() > 0.5 then
                        v.components.locomotor:PushTempGroundSpeedMultiplier(TUNING.DEER_ICE_SPEED_PENALTY)
                    end
                end
            end
            if v.components.burnable ~= nil and v.components.fueled == nil then
                v.components.burnable:Extinguish()
            end
            if v.components.freezable ~= nil then
                if gemresist then
                    if v:HasTag("mythTag_rhino") then
                        v.shouldavoidmagic = true
                    end
                elseif inst._rad:value() > 2.5 then --inst.fx ~= nil then
                    if v.components.freezable:IsFrozen() then
                        inst._track2[v] = TUNING.DEER_ICE_FREEZE_LOCK_FRAMES
                        v.components.freezable:AddColdness(.2, 1)
                    else
                        inst._track2[v] = (inst._track1[v] or 0) > 0 and inst._track1[v] - 1 or nil
                        if inst._track2[v] == nil then
                            v.components.freezable:AddColdness(math.max(1, v.components.freezable:ResolveResistance() - v.components.freezable.coldness + 1), 1)
                        elseif v.components.freezable.coldness < v.components.freezable:ResolveResistance() * .7 then
                            v.components.freezable:AddColdness(.2, 1, true)
                        end
                    end
                elseif not v.components.freezable:IsFrozen()
                    and v.components.freezable.coldness < v.components.freezable:ResolveResistance() * .7 then
                    v.components.freezable:AddColdness(.2, 1, true)
                end
            end

            if v.components.moisture ~= nil then
                v.components.moisture:DoDelta(0.5)
            end           
            if v.components.temperature ~= nil then
                local newtemp = math.max(v.components.temperature.mintemp, TUNING.DEER_ICE_TEMPERATURE)
                if newtemp < v.components.temperature:GetCurrent() then
                    v.components.temperature:SetTemperature(newtemp)
                end
            end
            if v.components.grogginess ~= nil and not v.components.grogginess:IsKnockedOut() then
                local curgrog = v.components.grogginess.grog_amount
                if curgrog < TUNING.DEER_ICE_FATIGUE then
                    v.components.grogginess:AddGrogginess(TUNING.DEER_ICE_FATIGUE)
                end
            end
        end
    end
end

local function TriggerFX(inst)
    if inst.fx ~= nil then
        return
    end
    inst.fx = {}
    for i, v in ipairs(inst.fxprefabs) do
        local fx = SpawnPrefab(v)
        fx.entity:SetParent(inst.entity)
        table.insert(inst.fx, fx)
    end
end

local function OnUpdateIceCircleClient(inst, x, z)
    local rad = inst._rad:value()
    if rad > 0 then
        local player = ThePlayer
        if player ~= nil and
            player.components.locomotor ~= nil and
            not player:HasTag("playerghost") and
            player:GetDistanceSqToPoint(x, 0, z) < 2.8 * 2.8 then
            player.components.locomotor:PushTempGroundSpeedMultiplier(TUNING.DEER_ICE_SPEED_PENALTY)
        end
    end
end

local function OnInitIceCircleClient(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst:DoPeriodicTask(0, OnUpdateIceCircleClient, nil, x, z)
    OnUpdateIceCircleClient(inst, x, z)
end


local function OnInitIceCircle(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst._rad:set(.25)
    inst.task = inst:DoPeriodicTask(0, OnUpdateIceCircle, nil, x, z)
    OnUpdateIceCircle(inst, x, z)
end

local function icekill(inst)
    local x, y, z = inst.Transform:GetWorldPosition()

    for k = 1, math.random(6,8) do
        DoBurst(inst, x, z, 0.5, 2,"icespike_fx_"..tostring(math.random(1, 4)))
    end

    inst:DoTaskInTime(0.1,function()
        for k = 1, math.random(13,15) do
             DoBurst(inst, x, z, 2.5, 4,"icespike_fx_"..tostring(math.random(1, 4)))
        end
    end)

    for i, v in ipairs(TheSim:FindEntities(x, 0, z, 5, {"_combat","_health"}, NOTAGS)) do
        if v:IsValid() and v.components.health ~= nil and not  v.components.health:IsDead() then
            if v.components.combat and inst.components.combat:CanAttack(v) then
                v.components.combat:GetAttacked(inst, 100)
            end
            if v.components.freezable and not v.components.freezable:IsFrozen() then
                v.components.freezable:AddColdness(10)
            end
        end
    end

    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    inst:DoTaskInTime(1.5,function()
        if inst._fade ~= nil then
            FadeOut(inst)
        end
        if inst.fx ~= nil then
            for i, v in ipairs(inst.fx) do
                v:KillFX()
            end
        end
        inst.components.colourtweener:StartTween({1,1,1,0},0.5,inst.Remove)
    end)
end

local function bluefn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst.AnimState:SetBank("myth_rhino_fx")
    inst.AnimState:SetBuild("myth_rhino_fx")
    inst.AnimState:PlayAnimation("water")
    inst.AnimState:PushAnimation("water_idle")

    inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
	
    inst:AddTag("myth_rhino_fx")

    inst._rad = net_float(inst.GUID, "myth_rhino_fx_blue._rad")

    inst.light = ICE_COLOUR
    inst._fadeframes = 30
    inst._fadeintensity = .8
    inst._faderadius = 3
    inst._fadefalloff = .9
    inst._fadeinspeed = 1
    inst._fadeoutspeed = 2

    inst.entity:AddLight()
    inst.Light:SetColour(unpack(inst.light))
    inst.Light:SetRadius(inst._faderadius)
    inst.Light:SetFalloff(inst._fadefalloff)
    inst.Light:SetIntensity(inst._fadeintensity)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

    inst._fade = net_smallbyte(inst.GUID, "myth_rhino_fx_blue._fade", "fadedirty")
    inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)

    if not TheWorld.ismastersim then
        inst:DoTaskInTime(0, OnInitIceCircleClient)
    end

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", OnFadeDirty)
        return inst
    end
	
    inst.entity:SetCanSleep(false)

	inst.persists = false
    inst.burstprefab = "crab_king_icefx"
    inst.fxprefabs = { "deer_ice_fx", "deer_ice_flakes" }
    inst.TriggerFX = TriggerFX
	
    inst:AddComponent("combat")

    inst.task = inst:DoTaskInTime(0, OnInitIceCircle)

    inst:DoTaskInTime(2.5,inst.TriggerFX)
    inst:DoTaskInTime(3,icekill)

    inst:AddComponent('colourtweener')
	return inst
end

local function DoFire(inst, x, z, minr, maxr)
    local fx = SpawnPrefab("firehit")
    local theta = GetRandomAngle(inst)
    local rad = GetRandomMinMax(minr, maxr)
    fx.Transform:SetPosition(x + rad * math.cos(theta), 0, z + rad * math.sin(theta))
    fx:DoTaskInTime(1.5,fx.Remove)
end

local FIRE_CIRCLE_RADIUS = 3.6
local FIRE_TARGET_ONEOF_TAGS = { "_health", "canlight", "freezable" }
local function OnUpdateFireCircle(inst, x, z)
    inst._rad = inst._rad * .9 + FIRE_CIRCLE_RADIUS * .1
    inst.components.propagator.propagaterange = inst._rad
    inst.components.propagator.damagerange = inst._rad
    if inst._rad > 1 then
        inst.burstdelay = (inst.burstdelay or 2) - 1
        if inst.burstdelay < 0 then
            inst.burstdelay = math.random(1, 2)
            DoBurst(inst, x, z, math.max(1, inst._rad - 1.5), inst._rad - .25)
            DoFire(inst, x, z, 0, 3)
        end
    end

    inst._track1 = inst._track2 or {}
    inst._track2 = {}

    local y --dummy
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, inst._rad, nil, NOTAGS, FIRE_TARGET_ONEOF_TAGS)) do
        if v:IsValid() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            x, y, z = v.Transform:GetWorldPosition()
            if v.components.freezable ~= nil then
                if v.components.freezable:IsFrozen() then
                    v.components.freezable:Unfreeze()
                elseif v.components.freezable.coldness > 0 then
                    v.components.freezable:AddColdness(-.1)
                end
            end
            if v.components.burnable ~= nil and
                v.components.fueled == nil and
                v.components.health ~= nil then
                if not v.components.burnable:IsBurning() then
                    inst._track2[v] = (inst._track1[v] or 0) + 1
                    if inst._track2[v] > TUNING.DEER_FIRE_IGNITE_FRAMES then
                        v.components.burnable:Ignite(true, inst)
                    end
                else
                    inst._track2[v] = TUNING.DEER_FIRE_IGNITE_FRAMES
                    v.components.burnable:ExtendBurning()
                end
                if v.components.temperature ~= nil then
                    local newtemp = math.min(v.components.temperature:GetMax(), TUNING.DEER_FIRE_TEMPERATURE)
                    if newtemp > v.components.temperature:GetCurrent() then
                        v.components.temperature:SetTemperature(newtemp)
                    end
                end
            end
        end
    end
end

local function FireTriggerFX(inst)
    if inst.fx ~= nil then
        return
    end
    inst.fx = {}
    for i, v in ipairs(inst.fxprefabs) do
        local fx = SpawnPrefab(v)
        fx.entity:SetParent(inst.entity)
        table.insert(inst.fx, fx)
    end
end

local function OnInitFireCircle(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst._rad = .25
    inst.task = inst:DoPeriodicTask(0, OnUpdateFireCircle, nil, x, z)
    OnUpdateFireCircle(inst, x, z)
end

local function DoRound(inst, x, z,prefab)
    local jiaodu = 0
    for k = 1 ,4 do
        local fx = SpawnPrefab(prefab)
        local theta =  jiaodu* DEGREES
        local rad = GetRandomMinMax(1,2.5)
        fx.Transform:SetPosition(x + rad * math.cos(theta), 0, z + rad * math.sin(theta))
        jiaodu = jiaodu + 90
    end
end

local function newDoBurst(inst, x, z, minr, maxr,hasfx)
    local fx = SpawnPrefab(hasfx)
    local theta = GetRandomAngle(inst)
    local rad = GetRandomMinMax(minr, maxr)
    if hasfx then
        local s = GetRandomMinMax(0.5, 1.5) --0.5 + math.random()   
        fx.Transform:SetScale(s,s,s)
    end
    fx.Transform:SetPosition(x + rad * math.cos(theta), 0, z + rad * math.sin(theta))
end

local function launchitem(item)
    local speed = 3 + GetRandomMinMax(2.5, 4)
    local angle = GetRandomAngle(item)
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end	

local function firekill(inst,boom)
    if inst.killed then
        return
    end
    inst.killed = true
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    inst.SoundEmitter:KillSound("loop")
    inst.components.propagator:StopSpreading()
    if inst._fade ~= nil then
        FadeOut(inst)
    end
    if inst.fx ~= nil then
        for i, v in ipairs(inst.fx) do
            v:KillFX()
        end
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    if not boom then
        for k = 1, math.random(3,6) do
            newDoBurst(inst, x, z, 0.5, 1.5,"myth_rhino_fireexplode")
        end
    
        inst:DoTaskInTime(0.1,function()
            for k = 1, math.random(12,14) do
                newDoBurst(inst, x, z, 1.8, 2.8,"myth_rhino_fireexplode")
            end
        end)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/explode")
        ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 1, inst, 20)
        local ents = TheSim:FindEntities(x, y, z, 4, nil,  { "playerghost", "INLIMBO","mythTag_rhino" })
        for i, v2 in ipairs(ents) do
            if v2 ~= inst and v2:IsValid() then
                if v2.components.health ~= nil and
                    not v2.components.health:IsDead() and
                    inst.components.combat:CanTarget(v2) then
                    v2.components.combat:GetAttacked(inst, 200)
                elseif v2.components.workable ~= nil and
                    v2.components.workable:CanBeWorked() and
                    v2.components.workable.action ~= ACTIONS.NET then
                    v2.components.workable:Destroy(inst)
                elseif v2.components.fueled == nil and
                    v2.components.burnable ~= nil and
                    not v2.components.burnable:IsBurning() and
                    not v2:HasTag("burnt") then
                    v2.components.burnable:Ignite()
                end
            end
        end
        inst:StartThread(function()
            for k = 1, 5 do
                for k1 = 1, 3 do
                    local nug = SpawnPrefab("myth_rhino_firefx")
                    if nug then
                        nug.Transform:SetPosition( x + GetRandomMinMax(-2, 2) , y +1.5 ,z)
                        launchitem(nug)
                        nug:DoUpdate()
                    end
                end
                Sleep(.15)
            end
        end)
    end
    inst.components.colourtweener:StartTween({1,1,1,0},0.5,inst.Remove)
end

local function destroybyfan(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    firekill(inst,true)
    local fx = SpawnPrefab("ash")
    fx.Transform:SetPosition(x, y, z)
end

local function firefn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    
    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst.AnimState:SetBank("myth_rhino_fx")
    inst.AnimState:SetBuild("myth_rhino_fx")
    inst.AnimState:PlayAnimation("fire")
    inst.AnimState:PushAnimation("fire_idle")
    inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
	
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/fx/fire_circle_LP", "loop")

    inst:AddTag("myth_rhino_fx")

    inst.light = FIRE_COLOUR
    inst._fadeframes = 30
    inst._fadeintensity = .8
    inst._faderadius = 3
    inst._fadefalloff = .9
    inst._fadeinspeed = 1
    inst._fadeoutspeed = 2

    inst.entity:AddLight()
    inst.Light:SetColour(unpack(inst.light))
    inst.Light:SetRadius(inst._faderadius)
    inst.Light:SetFalloff(inst._fadefalloff)
    inst.Light:SetIntensity(inst._fadeintensity)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

    inst._fade = net_smallbyte(inst.GUID, "myth_rhino_fx_blue._fade", "fadedirty")
    inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.entity:SetCanSleep(false)

	inst.persists = false
    inst.burstprefab = "deer_fire_burst" 
    inst.fxprefabs = { "deer_fire_flakes"}
    inst.TriggerFX = FireTriggerFX
	
    inst.task = inst:DoTaskInTime(0, OnInitFireCircle)

    inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = .25
    inst.components.propagator.damagerange = .25
    inst.components.propagator:StartSpreading()

    inst:AddComponent('colourtweener')

    inst:AddComponent("combat")

    inst.DestroyByFan = destroybyfan

    inst:DoTaskInTime(0,inst.TriggerFX)

    inst:DoTaskInTime(3,firekill)

	return inst
end


local function fx()
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("explode")
    inst.AnimState:SetBuild("explode")
    inst.AnimState:PlayAnimation("small")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:ListenForEvent("animover", inst.Remove)

    inst:DoTaskInTime(1.5,inst.Remove)

    return inst
end

local function onremove(inst)
    for v, k in pairs(inst.addbuff) do
		if  v then 
			inst.addbuff[v] = nil
            if v.player_classified then
                v.player_classified.stormtype:set(0)
                v.player_classified.stormlevel:set(0)
            end
		end
    end
end

local function IsNearOther(inst,wind,rad)
    local x, y, z = inst.Transform:GetWorldPosition()    
    local ents = TheSim:FindEntities(x, 0, z, rad, {"myth_rhino_fx_yellow"})
    for k, v in ipairs(ents) do
        if v ~= wind then
            return true
        end
    end
    return false
end

local function OnUpdateYellowCircle(inst, x, z)
    inst._rad:set(inst._rad:value() * .98 + ICE_CIRCLE_RADIUS * .02)
    --if inst.fx ~= nil then
        inst.burstdelay = (inst.burstdelay or 6) - 1
        if inst.burstdelay < 0 then
            inst.burstdelay = math.random(5, 6)
            DoBurst(inst, x, z, 2, 3)
        end
    --end
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, 20, {"player"})) do
        if v:IsValid() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            local gemresist = false
            if v:HasTag("player") then
                if inst.addbuff[v] == nil then
                    inst.addbuff[v] = true
                end
            end
        end
    end
    for v, k in pairs(inst.addbuff) do
		if  v  and v:IsValid() then
            local sq = v:GetDistanceSqToInst(inst)
			if sq >  20 *20  then
                inst.addbuff[v] = nil
                if v.player_classified then
                    v.player_classified.stormtype:set(0)
                    v.player_classified.stormlevel:set(0)
                end		
			elseif sq > 3*3 then
                if v.player_classified and not IsNearOther(v,inst,3)then
                    v.player_classified.stormtype:set(1)
                    v.player_classified.stormlevel:set(3)
                end	
            else
                if v.components.locomotor then
                    v.components.locomotor:PushTempGroundSpeedMultiplier(0.3)
                end
                if v.player_classified then
                    v.player_classified.stormtype:set(1)
                    v.player_classified.stormlevel:set(7)
                end
			end
		end
    end
end

local function OnUpdateYellowCircleClient(inst, x, z)
    local rad = inst._rad:value()
    if rad > 0 then
        local player = ThePlayer
        if player ~= nil and
            player.components.locomotor ~= nil and
            not player:HasTag("playerghost") and
            player:GetDistanceSqToPoint(x, 0, z) < 3 * 3 then
            player.components.locomotor:PushTempGroundSpeedMultiplier(0.3)
        end
    end
end

local function OnInitYellowCircleClient(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst:DoPeriodicTask(0.1, OnUpdateYellowCircleClient, nil, x, z)
    OnUpdateYellowCircleClient(inst, x, z)
end

local function OnInitYellowCircle(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst._rad:set(.25)
    inst.task = inst:DoPeriodicTask(0.1, OnUpdateYellowCircle, nil, x, z)
    OnUpdateYellowCircle(inst, x, z)
end

local function yellowill(inst,nowind)
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    if inst._fade ~= nil then
        FadeOut(inst)
    end
    if not nowind then
        local fx = SpawnPrefab("myth_rhino_fx_tornado_big")
        fx.Transform:SetPosition(x, 0, z)
    end
    inst.components.colourtweener:StartTween({1,1,1,0},0.5,inst.Remove)
end

local function destroybyfanyellow(inst)
    yellowill(inst,true)
end

local function yellowfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst.AnimState:SetBank("myth_rhino_fx")
    inst.AnimState:SetBuild("myth_rhino_fx")
    inst.AnimState:PlayAnimation("wind")
    inst.AnimState:PushAnimation("wind_idle")

    inst.AnimState:SetFinalOffset(3)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )
	
    inst:AddTag("myth_rhino_fx")
    inst:AddTag("myth_rhino_fx_yellow")

    inst._rad = net_float(inst.GUID, "myth_rhino_fx_yellow._rad")

    inst.light = SAND_COLOUR
    inst._fadeframes = 30
    inst._fadeintensity = .8
    inst._faderadius = 3
    inst._fadefalloff = .9
    inst._fadeinspeed = 1
    inst._fadeoutspeed = 2

    inst.entity:AddLight()
    inst.Light:SetColour(unpack(inst.light))
    inst.Light:SetRadius(inst._faderadius)
    inst.Light:SetFalloff(inst._fadefalloff)
    inst.Light:SetIntensity(inst._fadeintensity)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

    inst._fade = net_smallbyte(inst.GUID, "myth_rhino_fx_yellow._fade", "fadedirty")
    inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)

    if not TheWorld.ismastersim then
        inst:DoTaskInTime(0, OnInitYellowCircleClient)
    end

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", OnFadeDirty)
        return inst
    end
	
    inst.addbuff = {}

    inst.entity:SetCanSleep(false)

	inst.persists = false
    inst.burstprefab = "myth_rhino_fx_tornado"
    inst.fxprefabs = { "deer_ice_fx", "deer_ice_flakes" }
    inst.TriggerFX = TriggerFX
	
    inst:AddComponent("combat")

    inst.task = inst:DoTaskInTime(0, OnInitYellowCircle)

    inst:DoTaskInTime(8,yellowill)

    inst:AddComponent('colourtweener')

    inst.DestroyByFan = destroybyfanyellow

    inst:ListenForEvent("onremove",onremove)

	return inst
end

local function ontornadolifetime(inst)
    if inst.damagetask then
        inst.damagetask:Cancel()
    end
    inst.task = nil
    inst.AnimState:PlayAnimation("tornado_pst")
    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(),inst.Remove)
end

local function SetDuration(inst, duration)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
    inst.task = inst:DoTaskInTime(duration, ontornadolifetime)
end

local function ondamage(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, inst.rad, {"_health","_combat"},{"playerghost", "INLIMBO","mythTag_rhino","fx"})
    for i, v in ipairs(ents) do
        if v:IsValid() and not (v.components.health ~= nil and v.components.health:IsDead()) and 
            inst.components.combat:CanAttack(v) then
            inst.components.combat:DoAttack(v)
        end
    end
end

local function tornado_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("myth_tornadofx")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")

    inst.Transform:SetScale(0.5, 0.5, 0.5)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.rad = 1.5
    inst.persists = false

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(10)

    inst.damagetask = inst:DoPeriodicTask(0.5,ondamage,0.1)
    inst.SetDuration = SetDuration
    inst:SetDuration(1.6)
    return inst
end

local function tornado_big_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetBank("tornado")
    inst.AnimState:SetBuild("myth_tornadofx")
    inst.AnimState:PlayAnimation("tornado_pre")
    inst.AnimState:PushAnimation("tornado_loop")

    inst.Transform:SetScale(2, 2, 2)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.rad = 4
    inst.persists = false

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(50)

    inst.damagetask = inst:DoPeriodicTask(0.4,ondamage,0.1)

    inst.SetDuration = SetDuration

    inst:SetDuration(2.5)

    return inst
end


return Prefab("myth_rhino_fx_blue", bluefn, assets),
    Prefab("myth_rhino_fx_red", firefn),
    Prefab("myth_rhino_fx_yellow", yellowfn),
    Prefab("myth_rhino_fx_tornado", tornado_fn,tornadoassets),
    Prefab("myth_rhino_fx_tornado_big", tornado_big_fn),
    Prefab("myth_rhino_fireexplode", fx)
