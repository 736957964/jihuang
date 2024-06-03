local assets =
{
    Asset("ANIM", "anim/myth_huanhundan.zip"),
    Asset("ATLAS", "images/inventoryimages/myth_huanhundan.xml"),

}

local prefabs =
{

}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_huanhundan")
    inst.AnimState:SetBuild("myth_huanhundan")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("preparedfood")
    inst:AddTag("mk_pills")

    MakeInventoryFloatable(inst, "med", nil, 0.68)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_huanhundan.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = 4096

    inst:AddComponent("inspectable")

    MakeHauntable(inst)
    
    return inst
end

return Prefab("myth_huanhundan", fn, assets, prefabs)
