
local MakeTorchFire = require("prefabs/torchfire_common")
local ANIM_HAND_TEXTURE = "fx/animhand.tex"
local ANIM_SMOKE_TEXTURE = "fx/animsmoke.tex"

local SHADER = "shaders/vfx_particle.ksh"
local REVEAL_SHADER = "shaders/vfx_particle_reveal.ksh"

local COLOUR_ENVELOPE_NAME = "myth_rhino_firefx_colourenvelope"
local SCALE_ENVELOPE_NAME = "myth_rhino_firefx_scaleenvelope"

local assets =
{
    Asset("IMAGE", ANIM_HAND_TEXTURE),
    Asset("IMAGE", ANIM_SMOKE_TEXTURE),
    Asset("SHADER", SHADER),
    Asset("SHADER", REVEAL_SHADER),
}
--------------------------------------------------------------------------

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end

local function InitEnvelope()
     EnvelopeManager:AddColourEnvelope(
        COLOUR_ENVELOPE_NAME,
        {   { 0,    IntColour(200, 85, 60, 25) },
            { .19,  IntColour(200, 125, 80, 256) },
            { .35,  IntColour(255, 20, 10, 256) },
            { .51,  IntColour(255, 20, 10, 256) },
            { .75,  IntColour(255, 20, 10, 256) },
            { 1,    IntColour(255, 7, 5, 0) },
        }
    )

    local fire_max_scale = .1
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME,
        {
            { 0,    { fire_max_scale * .5, fire_max_scale * .5 } },
            { .55,  { fire_max_scale * 1.3, fire_max_scale * 1.3 } },
            { 1,    { fire_max_scale * 1.5, fire_max_scale * 1.5 } },
        }
    )

    InitEnvelope = nil
    IntColour = nil
end
local FIRE_MAX_LIFETIME = .9
local function emit_fire_fn(effect, sphere_emitter)
    local vx, vy, vz = .005 * UnitRand(), 0, .0005 * UnitRand()
    local lifetime = FIRE_MAX_LIFETIME * (.9 + UnitRand() * .1)
    local px, py, pz = sphere_emitter()

    effect:AddRotatingParticleUV(
        0,
        lifetime,
        px, py, pz,
        vx, vy, vz,
        math.random() * 360,
        UnitRand() * 2, 
        0, 0 
    )
end

local function common_postinit(inst)
    if TheNet:IsDedicated() then
        return
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end
    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(1)

    effect:SetRenderResources(0, ANIM_SMOKE_TEXTURE, REVEAL_SHADER)
    effect:SetMaxNumParticles(0, 32)
    effect:SetRotationStatus(0, true)
    effect:SetMaxLifetime(0, FIRE_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME)
    effect:SetBlendMode(0, BLENDMODE.AlphaAdditive)
    effect:EnableBloomPass(0, true)
    effect:SetUVFrameSize(0, 1, 1)
    effect:SetSortOrder(0, 0)
    effect:SetSortOffset(0, 1)
    effect:SetKillOnEntityDeath(0, true)
    effect:SetFollowEmitter(0, true)

    local tick_time = TheSim:GetTickTime()

    local fire_desired_pps = 6
    local fire_particles_per_tick = fire_desired_pps * tick_time
    local fire_num_particles_to_emit = 0

    local sphere_emitter = CreateSphereEmitter(.05)

    EmitterManager:AddEmitter(inst, nil, function()
        while fire_num_particles_to_emit > 1 do
            emit_fire_fn(effect, sphere_emitter)
            fire_num_particles_to_emit = fire_num_particles_to_emit - 1
        end
        fire_num_particles_to_emit = fire_num_particles_to_emit + fire_particles_per_tick * math.random() * 3
    end)
end

local NOTAGS = { "playerghost", "INLIMBO","mythTag_rhino" }
local function updateheight(inst)
    local pt = Point(inst.Transform:GetWorldPosition())
    if pt.y <= 0.2 or inst:IsAsleep() then
        SpawnPrefab("explode_small").Transform:SetPosition(pt.x, pt.y, pt.z)
        for i, v in ipairs(TheSim:FindEntities(pt.x, 0, pt.z, 3, nil, NOTAGS,{ "_health", "canlight", "freezable" })) do
            if v:IsValid() then
                if v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat then
                    v.components.combat:GetAttacked(inst, 50)
                elseif v.components.burnable and not v.components.burnable:IsBurning() then
                    v.components.burnable:Ignite(true, inst)
                end
            end  
        end
        if inst.task then
            inst.task:Cancel()
        end
        inst:Remove()
    end
end

local function update(inst)
    inst.task = inst:DoPeriodicTask(0,updateheight)
end

local function CreateLight()
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("playerlight")
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddLight()

    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(197 / 255, 197 / 255, 50 / 255)
    inst.Light:SetFalloff(.5)
    inst.Light:SetRadius(0.2)

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst._light = CreateLight()
    inst._light.entity:SetParent(inst.entity)

    inst.OnRemoveEntity = OnRemoveEntity

    common_postinit(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.DoUpdate = update
    inst:DoTaskInTime(3,inst.Remove)

    return inst
end

return Prefab("myth_rhino_firefx", fn)
