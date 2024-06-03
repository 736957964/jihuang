local assets =
{
    Asset("ANIM", "anim/myth_coin_box.zip"),
    Asset("ATLAS", "images/inventoryimages/myth_coin_box.xml"),

}

local prefabs =
{
	"oceanfishingbobber_twig_projectile",
}

local function OnUnwrapped(inst, pos, doer)
    if  doer and doer.components.inventory then
        local new = SpawnPrefab("myth_coin")
        new.components.stackable:SetStackSize(40)
        inst.components.stackable:Get():Remove()
        doer.components.inventory:GiveItem(new,nil,doer:GetPosition())
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_coin_box")
    inst.AnimState:SetBuild("myth_coin_box")
    inst.AnimState:PlayAnimation("idle")

    --MakeInventoryFloatable(inst, "med", nil, 0.68)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_coin_box.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("unwrappable")
    --inst.components.unwrappable:SetOnWrappedFn(OnWrapped)
    inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)

    inst:AddComponent("tradable")

    MakeHauntable(inst)

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("myth_coin_box", fn, assets, prefabs)
