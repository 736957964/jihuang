local assets = {
    Asset("ANIM", "anim/myth_passcard_jie.zip"),
    Asset("ATLAS", "images/inventoryimages/myth_passcard_jie.xml"),
    Asset("ATLAS", "images/inventoryimages/myth_passcard_jie.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_passcard_jie")
    inst.AnimState:SetBuild("myth_passcard_jie")
    inst.AnimState:PlayAnimation("idle",true)

    MakeInventoryFloatable(inst)

    inst:AddTag("myth_passcard_jie")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_passcard_jie.xml"

    inst:AddComponent("tradable")

    return inst
end

return Prefab("myth_passcard_jie", fn, assets)
