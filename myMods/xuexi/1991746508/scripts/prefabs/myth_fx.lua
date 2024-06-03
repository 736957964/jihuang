--------------------------------------------------------------------------
--[[ 桃叶下落 ]]
--------------------------------------------------------------------------

local assets_peachNeedle =
{
    Asset("ANIM", "anim/pine_needles.zip"), --官方的针叶下落动画模板
    Asset("ANIM", "anim/myth_fx_peachneedle.zip"),
}

local function PlayAnim_peachNeedle(inst)
    inst.AnimState:SetBank("pine_needles")
    inst.AnimState:SetBuild("myth_fx_peachneedle")
    inst.AnimState:PlayAnimation(math.random() < 0.5 and "fall" or "chop")

    -- inst.AnimState:SetSortOrder(1)
    inst.Transform:SetScale(0.8, 0.8, 0.8)
    inst.AnimState:OverrideSymbol("needle", "myth_fx_peachneedle", "needle")
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
end

--------------------------------------------------------------------------
--[[ 桃花下落 ]]
--------------------------------------------------------------------------

local assets_peachFlowerNeedle =
{
    Asset("ANIM", "anim/pine_needles.zip"), --官方的针叶下落动画模板
    Asset("ANIM", "anim/myth_fx_peachflowerneedle.zip"),
}

local function PlayAnim_peachFlowerNeedle(inst)
    inst.AnimState:SetBank("pine_needles")
    inst.AnimState:SetBuild("myth_fx_peachflowerneedle")
    inst.AnimState:PlayAnimation(math.random() < 0.5 and "fall" or "chop")

    -- inst.AnimState:SetSortOrder(1)
    inst.Transform:SetScale(0.8, 0.8, 0.8)
    inst.AnimState:OverrideSymbol("needle", "myth_fx_peachflowerneedle", "needle")
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
end

--------------------------------------------------------------------------
--[[ 无需网络组建功能的特效创建通用函数 ]]
--------------------------------------------------------------------------

local function MakeNonNetworkedFx(name, animfn, assets, prefabs)
	local function AnimFn(proxy)
	    local inst = CreateEntity()

	    inst:AddTag("FX")
	    inst:AddTag("NOCLICK")
	    --[[Non-networked entity]]
	    inst.entity:SetCanSleep(false)
	    inst.persists = false

	    inst.entity:AddTransform()
        inst.entity:AddAnimState()

        local parent = proxy.entity:GetParent()
        if parent ~= nil then
            inst.entity:SetParent(parent.entity)
        end

	    inst.Transform:SetFromProxy(proxy.GUID)

	    if animfn ~= nil then
	    	animfn(inst)
	    end

	    inst:ListenForEvent("animover", inst.Remove)
	end

    local function Fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        --Dedicated server does not need to spawn the local fx
        if not TheNet:IsDedicated() then
            --Delay one frame so that we are positioned properly before starting the effect
            --or in case we are about to be removed
            inst:DoTaskInTime(0, AnimFn)
        end

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(1, inst.Remove)

        return inst
    end

    return Prefab(name, Fn, assets, prefabs)
end

---------------

return MakeNonNetworkedFx("myth_fx_peachleaf", PlayAnim_peachNeedle, assets_peachNeedle, nil),
    MakeNonNetworkedFx("myth_fx_peachflower", PlayAnim_peachFlowerNeedle, assets_peachFlowerNeedle, nil)
