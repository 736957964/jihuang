local assets = {
    Asset("ANIM", "anim/myth_lotusleaf_hat.zip"),
    Asset("IMAGE", "images/inventoryimages/myth_lotusleaf_hat.tex"),
    Asset("ATLAS", "images/inventoryimages/myth_lotusleaf_hat.xml"),
}

local prefabs = {}
local function onequiphat(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "myth_lotusleaf_hat", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequiphat(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function finished(inst)
    inst:Remove()
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_lotusleaf_hat")
    inst.AnimState:SetBuild("myth_lotusleaf_hat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")
    inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.05)
    inst.components.floater:SetScale({1, 0.6, 1})

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_lotusleaf_hat.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(4800)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)
    inst:AddTag("show_spoilage")

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_LARGE)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequiphat)
    inst.components.equippable:SetOnUnequip(onunequiphat)
    inst.components.equippable.insulated = true

    inst:AddComponent("tradable")

    MakeHauntableLaunchAndPerish(inst)
    return inst
end

return Prefab("myth_lotusleaf_hat", fn, assets, prefabs)
