local assets = {
    Asset("ANIM", "anim/siving_hat.zip"),
    Asset("IMAGE", "images/inventoryimages/siving_hat.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_hat.xml"),
}

local prefabs = {}
local function onequiphat(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "siving_hat", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
    if owner.components.sanity then
        owner.components.sanity:AddSanityAuraImmunity("myth_sving_sanity")
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

    if owner.components.sanity then
        owner.components.sanity:RemoveSanityAuraImmunity("myth_sving_sanity")
    end
end

local function onpercent(inst,data)
	local percent =  data and data.percent or inst.components.armor.condition
	if percent <= 0 then 
		inst.components.armor.absorb_percent = 0 
	else
		inst.components.armor.absorb_percent = 0.9 
	end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("siving_hat")
    inst.AnimState:SetBuild("siving_hat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")
    inst:AddTag("siving_hat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_hat.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequiphat)
    inst.components.equippable:SetOnUnequip(onunequiphat)
    inst.components.equippable.dapperness = 3.3/60

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(3000, 0.9)
    inst:AddComponent("tradable")

    --inst:ListenForEvent("percentusedchange", onpercent)
    --onpercent(inst)	
    
    return inst
end

return Prefab("siving_hat", fn, assets, prefabs)
