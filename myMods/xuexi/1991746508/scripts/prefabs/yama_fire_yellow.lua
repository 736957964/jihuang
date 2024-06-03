local MakeTorchFire = require("prefabs/yama_fire_common")

local SMOKE_TEXTURE = "fx/smoke.tex"
local TEXTURE = "fx/torchfire.tex"

local SHADER = "shaders/vfx_particle.ksh"

local COLOUR_ENVELOPE_NAME = "yama_firecolourenvelope_yellow"
local SCALE_ENVELOPE_NAME = "yama_firescaleenvelope_yellow"

local assets =
{
    Asset("IMAGE", TEXTURE),
    Asset("SHADER", SHADER),
}

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end

local function InitEnvelope()
    EnvelopeManager:AddColourEnvelope(
        COLOUR_ENVELOPE_NAME,
        {
            { 0,    IntColour(255, 176, 2, 128) },
            { .49,  IntColour(255, 176, 2, 128) },
            { .5,   IntColour(255, 176, 2, 128) },
            { .51,  IntColour(255, 176, 2, 128) },
            { .75,  IntColour(255, 176, 2, 128) },
            { 1,    IntColour(255, 176, 2, 0) },
        }
    )

    local max_scale = 2.5
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME,
        {
            { 0,    { max_scale * .5, max_scale } },
            { 1,    { max_scale * .5 * .5, max_scale * .5 } },
        }
    )

    InitEnvelope = nil
    IntColour = nil
end

--------------------------------------------------------------------------

local FIRE_MAX_LIFETIME = .3

local function emit_fire_fn(effect, sphere_emitter)
    local vx, vy, vz = .01 * UnitRand(), 0, .01 * UnitRand()
    local lifetime = FIRE_MAX_LIFETIME * (.9 + UnitRand() * .1)
    local px, py, pz = sphere_emitter()
    local uv_offset = math.random(0, 3) * .25

    effect:AddParticleUV(
        0,
        lifetime,           -- lifetime
        px, py, pz,         -- position
        vx, vy, vz,         -- velocity
        uv_offset, 0        -- uv offset
    )
end

--------------------------------------------------------------------------

local function common_postinit(inst)

    if TheNet:IsDedicated() then
        return
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end

    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(1)

    effect:SetRenderResources(0, TEXTURE, SHADER)
    effect:SetMaxNumParticles(0, 64)
    effect:SetMaxLifetime(0, FIRE_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME)
    effect:SetBlendMode(0, BLENDMODE.Additive)
    effect:EnableBloomPass(0, true)
    effect:SetUVFrameSize(0, .25, 1)
    effect:SetSortOrder(0, 0)
    effect:SetSortOffset(0, 2)

    -----------------------------------------------------

    local tick_time = TheSim:GetTickTime()

    local fire_desired_pps = 40
    local fire_particles_per_tick = fire_desired_pps * tick_time
    local fire_num_particles_to_emit = 1

    local sphere_emitter = CreateSphereEmitter(.05)

    EmitterManager:AddEmitter(inst, nil, function()

        while fire_num_particles_to_emit > 1 do
            emit_fire_fn(effect, sphere_emitter)
            fire_num_particles_to_emit = fire_num_particles_to_emit - 1
        end
        fire_num_particles_to_emit = fire_num_particles_to_emit + fire_particles_per_tick
    end)
end

local function master_postinit(inst)
    inst.fx_offset = -110
    if inst._light then
        inst._light.Light:SetColour(255 / 255, 176 / 255, 2 / 255)
    end
end

return MakeTorchFire("yama_fire_yellow", assets, nil, common_postinit, master_postinit)
