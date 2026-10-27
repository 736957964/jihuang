

-----来自 【【【【灵衣女王的鬼铠】】】】

local aaaaaa = "fx/wintersnow.tex"
local bbbbbb = "fx/spark.tex"

local cccccc = "shaders/vfx_particle_add.ksh"

local dddddd = "gale_sparkle_vfx_colourenvelope"
local eeeeee = "gale_sparkle_vfx_scaleenvelope"

local ffffff = "gale_sparkle_vfx_arrow_colourenvelope"
local gggggg = "gale_sparkle_vfx_arrow_scaleenvelope"

local hhhhhh =
{
    Asset("IMAGE", aaaaaa),
    Asset("IMAGE", bbbbbb),
    Asset("SHADER", cccccc),
}



local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end

local function InitEnvelope()
    local iiiiii = {}
    local jjjjjj = 0
    local kkkkkk = .15
    while jjjjjj + kkkkkk + .01 < 0.8 do
        table.insert(iiiiii, { jjjjjj, IntColour(0, 229, 232, 255) })
        jjjjjj = jjjjjj + kkkkkk
        table.insert(iiiiii, { jjjjjj, IntColour(255, 229, 232, 200) })
        jjjjjj = jjjjjj + .01
    end
    table.insert(iiiiii, { 1, IntColour(0, 229, 232, 0) })

    EnvelopeManager:AddColourEnvelope(dddddd, iiiiii)

    local llllll = 0.88
    EnvelopeManager:AddVector2Envelope(
        eeeeee,
        {
            { 0,    { llllll, llllll } },
            { 1,    { llllll * .5, llllll * .5 } },
        }
    )

    EnvelopeManager:AddColourEnvelope(
        ffffff,
        {
            { 0,    IntColour(0, 229, 230, 180) },
            { .2,   IntColour(0, 229, 232, 255) },
            { .8,   IntColour(0, 229, 230, 175) },
            { 1,    IntColour(0, 0, 0, 0) },
        }
    )

    local mmmmmm = 2.8
    EnvelopeManager:AddVector2Envelope(
        gggggg,
        {
            { 0,    { mmmmmm, mmmmmm } },
            { 1,    { mmmmmm * 0.125, mmmmmm * 0.8} },
        }
    )

    InitEnvelope = nil
    IntColour = nil
end


local nnnnnn = 1.75
local oooooo = 1

local function emit_sparkle_fn(yyyyyy, BBBBBB,target_pos)
    local pppppp = target_pos:GetNormalized() * 0.25
    local vx, vy, vz = pppppp:Get()
    local svx,svy,svz = CreateSphereEmitter(pppppp:Length())()
    svy = svy < 0 and -svy or svy
    svy = Remap(svy,0,pppppp:Length(),0,pppppp:Length() + 0.2)

    local qqqqqq = nnnnnn * (.7 + UnitRand() * .3)
    local px, py, pz = BBBBBB()

    local rrrrrr = math.random() * 360
    local ssssss = math.random(0, 3) * .25
    local tttttt = (UnitRand() - 1) * 5

    yyyyyy:AddRotatingParticleUV(
        0,
        qqqqqq,           
        px, py + 1, pz,         
        vx+svx, vy+svy, vz+svz,         
        rrrrrr, tttttt,     
        ssssss, 0        
    )
end


local function emit_arrow_fn(yyyyyy, BBBBBB,target_pos)
    local pppppp = target_pos:GetNormalized() * 0.4
    local vx, vy, vz = pppppp:Get()
    local svx,svy,svz = CreateSphereEmitter(pppppp:Length())()
    svy = svy < 0 and -svy or svy
    svx = Remap(svx,0,pppppp:Length(),0.1,pppppp:Length())
    svz = Remap(svz,0,pppppp:Length(),0.1,pppppp:Length())

    local qqqqqq = oooooo * (.7 + UnitRand() * .3)
    local px, py, pz = BBBBBB()

    local ssssss = math.random(0, 3) * .25

    yyyyyy:AddParticleUV(
        1,
        qqqqqq,           
        px, py + 1, pz,    
        vx+svx, vy+svy, vz+svz,          
        ssssss, 0        
    )
end

local function fn()
    local xxxxxx = CreateEntity()

    xxxxxx.entity:AddTransform()
    xxxxxx.entity:AddNetwork()

    xxxxxx:AddTag("FX")

    xxxxxx.entity:SetPristine()

    xxxxxx.persists = false

    xxxxxx._target_pos_x = net_float(xxxxxx.GUID,"xxxxxx._target_pos_x")
    xxxxxx._target_pos_y = net_float(xxxxxx.GUID,"xxxxxx._target_pos_y")
    xxxxxx._target_pos_z = net_float(xxxxxx.GUID,"xxxxxx._target_pos_z")
    xxxxxx._can_emit = net_bool(xxxxxx.GUID,"xxxxxx._can_emit")
    xxxxxx._can_emit:set(false)

    
    if TheNet:IsDedicated() then
        return xxxxxx
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end

    local yyyyyy = xxxxxx.entity:AddVFXEffect()
    yyyyyy:InitEmitters(2)

    
    yyyyyy:SetRenderResources(0, aaaaaa, cccccc)
    yyyyyy:SetRotationStatus(0, true)
    yyyyyy:SetUVFrameSize(0, .25, 1)
    yyyyyy:SetMaxNumParticles(0, 256)
    yyyyyy:SetMaxLifetime(0, nnnnnn)
    yyyyyy:SetColourEnvelope(0, dddddd)
    yyyyyy:SetScaleEnvelope(0, eeeeee)
    yyyyyy:SetBlendMode(0, BLENDMODE.Additive)
    yyyyyy:EnableBloomPass(0, true)
    yyyyyy:SetSortOrder(0, 0)
    yyyyyy:SetSortOffset(0, 2)
    yyyyyy:SetDragCoefficient(0, .1)

    yyyyyy:SetRenderResources(1, bbbbbb, cccccc)
    yyyyyy:SetMaxNumParticles(1, 25)
    yyyyyy:SetMaxLifetime(1, oooooo)
    yyyyyy:SetColourEnvelope(1, ffffff)
    yyyyyy:SetScaleEnvelope(1, gggggg)
    yyyyyy:SetBlendMode(1, BLENDMODE.Additive)
    yyyyyy:EnableBloomPass(1, true)
    yyyyyy:SetUVFrameSize(1, 0.25, 1)
    yyyyyy:SetSortOrder(1, 0)
    yyyyyy:SetSortOffset(1, 0)
    yyyyyy:SetDragCoefficient(1, .14)
    yyyyyy:SetRotateOnVelocity(1, true)
    

    local zzzzzz = GetRandomMinMax(15,20)
    local AAAAAA = Remap(zzzzzz,15,20,5,9)
    local BBBBBB = CreateSphereEmitter(.25)

    


    EmitterManager:AddEmitter(xxxxxx, nil, function()
        while not xxxxxx._can_emit:value() do

        end
        while zzzzzz > 0 do
            emit_sparkle_fn(yyyyyy, BBBBBB,Vector3(xxxxxx._target_pos_x:value(),xxxxxx._target_pos_y:value(),xxxxxx._target_pos_z:value()))
            zzzzzz = zzzzzz - 1
        end
        while AAAAAA > 0 do
            emit_arrow_fn(yyyyyy, BBBBBB,Vector3(xxxxxx._target_pos_x:value(),xxxxxx._target_pos_y:value(),xxxxxx._target_pos_z:value()))
            AAAAAA = AAAAAA - 1
        end
        xxxxxx:Remove()
    end)

    return xxxxxx
end

return Prefab("myth_gale_sparkle_vfx", fn, hhhhhh)
