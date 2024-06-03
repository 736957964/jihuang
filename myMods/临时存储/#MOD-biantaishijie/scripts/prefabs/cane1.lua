local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_cane", inst.GUID, "swap_cane")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_cane", "swap_cane")
    end
	if  owner and owner.components.builder then 
    owner.components.builder:GiveAllRecipes()
	end
	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
	if  owner and owner.components.builder then 
    owner.components.builder:GiveAllRecipes()
	end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(1000)
	inst.components.weapon:SetRange(10,12)
	inst.components.weapon:SetProjectile("elpheltmissile")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
	inst:AddComponent("builder")
	if  inst.components.named == nil  then   
		inst:AddComponent("named")
		inst.components.named:SetName("全物品制造手杖")
	end
    inst:AddComponent("blinkstaff")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.5

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("cane", fn, assets)
