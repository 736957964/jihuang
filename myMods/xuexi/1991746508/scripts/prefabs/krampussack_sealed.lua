local assets =
{
    Asset("ANIM", "anim/krampussack_sealed.zip"),
    Asset("IMAGE", "images/inventoryimages/krampussack_sealed.tex"),
    Asset("ATLAS", "images/inventoryimages/krampussack_sealed.xml"),
}

local function OnUnwrapped(inst, pos, doer)
    if doer ~= nil and doer.SoundEmitter ~= nil then
        doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
    end
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("krampussack_sealed")
    inst.AnimState:SetBuild("krampussack_sealed")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst.Transform:SetScale(1.18, 1.18, 1.18)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/krampussack_sealed.xml"

    --inst:AddComponent("stackable")

    inst:AddComponent("unwrappable")
    inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)

    return inst
end

return Prefab("krampussack_sealed", fn, assets)
