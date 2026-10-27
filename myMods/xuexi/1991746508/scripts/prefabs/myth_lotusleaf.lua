local assets =
{
    Asset("ANIM", "anim/myth_lotusleaf_umbrella.zip"),
    Asset("IMAGE", "images/inventoryimages/myth_lotusleaf.tex"),
    Asset("ATLAS", "images/inventoryimages/myth_lotusleaf.xml"),
    Asset("ANIM", "anim/floating_items.zip"),
}

local function onequip_grass(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "myth_lotusleaf_umbrella", "swap_leaves")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.DynamicShadow then
        owner.DynamicShadow:SetSize(1.7, 1)
    end
end

local function onunequip_grass(inst, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if owner.DynamicShadow then
        owner.DynamicShadow:SetSize(1.3, 0.6)
    end
end

local function onperish(inst)
    local equippable = inst.components.equippable
    if equippable ~= nil and equippable:IsEquipped() then
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if owner ~= nil then
            local data =
            {
                prefab = inst.prefab,
                equipslot = equippable.equipslot,
            }
            inst:Remove()
            owner:PushEvent("umbrellaranout", data)
            return
        end
    end
    inst:Remove()
end

local function common_fn(name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")  

    inst:AddTag("nopunch")
    inst:AddTag("umbrella")

    inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst, "large")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("waterproofer")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_lotusleaf.xml"

    inst:AddComponent("equippable")

    inst:AddComponent("insulator")
    inst.components.insulator:SetSummer()

    MakeHauntableLaunch(inst)

    return inst
end

local function grass()
    local inst = common_fn("myth_lotusleaf_umbrella")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(4800)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)
    inst:AddTag("show_spoilage")

    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

    inst.components.equippable:SetOnEquip( onequip_grass )
    inst.components.equippable:SetOnUnequip( onunequip_grass )
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

    local swap_data = {sym_build = "myth_lotusleaf_umbrella",sym_name = "swap_leaves"}
    inst.components.floater:SetBankSwapOnFloat(true, -20, swap_data)
    inst.components.floater:SetVerticalOffset(0.05)
    inst.components.floater:SetScale({0.8, 0.4, 0.8})

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end

return  Prefab("myth_lotusleaf", grass, assets)
