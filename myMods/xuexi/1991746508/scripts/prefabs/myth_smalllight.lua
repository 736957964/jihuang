local assets =
{
    Asset("ANIM", "anim/myth_smalllight.zip"),
}
--light
local MAX_LIGHT_ON_FRAME = 15
local MAX_LIGHT_OFF_FRAME = 30

local function OnUpdateLight(inst, dframes)
    local frame = inst._lightframe:value() + dframes
    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end
    local k = frame / inst._lightmaxframe
    if inst._islighton:value() then
        inst.Light:SetRadius(3 * k)
    else
        inst.Light:SetRadius(3 * (1 - k))
    end
    if TheWorld.ismastersim then
        inst.Light:Enable(inst._islighton:value() or frame < inst._lightmaxframe)
        if not inst._islighton:value() then
        end
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    inst._lightmaxframe = inst._islighton:value() and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME
    OnUpdateLight(inst, 0)
end 
local function Turnoon(inst)
    if not inst._islighton:value() then
        inst._islighton:set(true)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_OFF_FRAME) * MAX_LIGHT_ON_FRAME + .5))
		inst.AnimState:PlayAnimation("turnon")
        OnLightDirty(inst)
    end
end	

local function Turnoff(inst)
    if inst._islighton:value() then
        inst._islighton:set(false)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_ON_FRAME) * MAX_LIGHT_OFF_FRAME + .5))
		inst.AnimState:PlayAnimation("turnoff")
        OnLightDirty(inst)
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst:AddTag("NOBLOCK")
	inst:AddTag("myth_smalllight")
	
    inst.AnimState:SetBank("myth_smalllight")
    inst.AnimState:SetBuild("myth_smalllight")
    inst.AnimState:PlayAnimation("turnoff")
	
	local light = inst.entity:AddLight()
	light:SetRadius(0)
	light:Enable(false)
	light:SetIntensity(.8)
	light:SetFalloff(.5)
	light:SetColour(228/255, 224/255, 136/255)
	
	inst.Light:EnableClientModulation(true)
	inst._lightframe = net_smallbyte(inst.GUID, "myth_smalllight._lightframe", "myth_smalllightdirty")
	inst._islighton = net_bool(inst.GUID, "myth_smalllight._islighton", "myth_smalllightdirty")
	inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
	inst._lightframe:set(inst._lightmaxframe)
	inst._lighttask = nil
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("myth_smalllightdirty", OnLightDirty)
        return inst
    end
	
	inst:AddComponent('inspectable')
	
	inst.TurnOn = Turnoon
	inst.TurnOff = Turnoff
		
    return inst
end


return Prefab("myth_smalllight", fn , assets)
	