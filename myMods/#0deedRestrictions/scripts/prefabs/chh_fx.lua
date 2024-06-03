local ANIM_SMOKE_TEXTURE = resolvefilepath("fx/caihon.tex")

local REVEAL_SHADER = "shaders/vfx_particle.ksh"

local COLOUR_ENVELOPE_NAME = "cane_sharp_colourenvelope"
local SCALE_ENVELOPE_NAME = "cane_sharp_scaleenvelope"

local assets =
{
    Asset("IMAGE", ANIM_SMOKE_TEXTURE),
    Asset("SHADER", REVEAL_SHADER),
}

--------------------------------------------------------------------------

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end
local mth1 = math.random(1,255)
local mth2 = math.random(1,255)
local mth3 = math.random(1,255)
local function InitEnvelope()
    EnvelopeManager:AddColourEnvelope(
        COLOUR_ENVELOPE_NAME,
        {
            { 0,    IntColour(mth1, mth2, mth3, 160) },
            { .19,  IntColour(mth1, mth2, mth3, 160) },
            { .35,  IntColour(mth1, mth2, mth3, 80) },
            { .51,  IntColour(mth1, mth2, mth3, 60) },
            { .75,  IntColour(mth1, mth2, mth3, 40) },
            { 1,    IntColour(mth1, mth2, mth3, 0) },
        }
    )

    local glow_max_scale = 3.5
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME,
        {
            { 0,    { glow_max_scale * 2.5, glow_max_scale * 1.5 } },
            --{ .55,  { glow_max_scale * 3.5, glow_max_scale * 3.5 } },
            { 1,    { glow_max_scale * 2.5, glow_max_scale *  1.5 } },
        }
    )

    InitEnvelope = nil
    IntColour = nil
end

--------------------------------------------------------------------------
local GLOW_MAX_LIFETIME = 10

local function emit_glow_fn(effect, emitter_fn,index)
    local vx, vy, vz = .005 * UnitRand(), 0, .005 * UnitRand()
    local lifetime = GLOW_MAX_LIFETIME * (.9 + math.random() * .1)
    local px, py, pz = emitter_fn()
    if(index==1) then 
        --pz = pz +7
    end
    effect:AddRotatingParticle(
        index,
        2.5,           -- lifetime
        px, py, pz,         -- position
        .005, .005, .005,         -- velocity
        360,-- angle
        0         -- angle velocity  UnitRand()
    )
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.entity:SetPristine()

    inst.persists = false

    --Dedicated server does not need to spawn local particle fx
    if TheNet:IsDedicated() then
        return inst
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end

    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(2) -- 初始化有几个触发器

    effect:SetRenderResources(0, ANIM_SMOKE_TEXTURE, REVEAL_SHADER) --发送tex ANIM_SMOKE_TEXTURE  ksh REVEAL_SHADER
    effect:SetMaxNumParticles(0, 1) --粒子生成的数量
    effect:SetRotationStatus(0, false)  -- true 反复播放
    effect:SetMaxLifetime(0, GLOW_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME)-- 颜色变化
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME)-- 形状变化
    effect:SetBlendMode(0, BLENDMODE.AlphaBlended)
    effect:EnableBloomPass(0, true)
    effect:SetSortOrder(0, 0)
	effect:SetSortOffset(0, 0) -- 0, -1
    effect:SetKillOnEntityDeath(0, true) -- 实体没了后是否删掉
    effect:SetFollowEmitter(0, true) -- 跟随发射器
    -- effect:SetUVFrameSize(1, 1, 1)
    -----------------------------------------------------
    effect:SetRenderResources(1, ANIM_SMOKE_TEXTURE, REVEAL_SHADER) --发送tex ANIM_SMOKE_TEXTURE  ksh REVEAL_SHADER
    effect:SetMaxNumParticles(1, 15) --粒子生成的数量
    effect:SetRotationStatus(1, true)  -- true 反复播放
    effect:SetMaxLifetime(1, GLOW_MAX_LIFETIME)
    effect:SetColourEnvelope(1, COLOUR_ENVELOPE_NAME)-- 颜色变化
    effect:SetScaleEnvelope(1, SCALE_ENVELOPE_NAME)-- 形状变化
    effect:SetBlendMode(1, BLENDMODE.AlphaBlended)
    effect:EnableBloomPass(1, true)
    effect:SetSortOrder(1, 0)
	effect:SetSortOffset(1, 0) -- 0, -1
    effect:SetKillOnEntityDeath(1, true) -- 实体没了后是否删掉
    effect:SetFollowEmitter(1, false) -- 跟随发射器

    local tick_time = TheSim:GetTickTime()

    local glow_desired_pps = 3
    local glow_particles_per_tick = glow_desired_pps * tick_time
    local glow_num_particles_to_emit = 0

    local sphere_emitter = CreateSphereEmitter(.05)
    local sphere_emitter2 = CreateSphereEmitter(.15)
    EmitterManager:AddEmitter(inst, nil, function()
        while glow_num_particles_to_emit > 1 do
            emit_glow_fn(effect, sphere_emitter,0)
            emit_glow_fn(effect, sphere_emitter2,1)
            glow_num_particles_to_emit = glow_num_particles_to_emit - 1
        end
        glow_num_particles_to_emit = glow_num_particles_to_emit + glow_particles_per_tick * math.random() * 3

    end)

    return inst
end

return Prefab("chh_fx", fn, assets)
