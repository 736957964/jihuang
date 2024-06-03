local assets =
{
    Asset("ANIM", "anim/myth_ruyi.zip"),
	Asset("ATLAS", "images/inventoryimages/myth_ruyi.xml"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_spear", inst.GUID, "swap_spear")
    else
        owner.AnimState:OverrideSymbol("swap_object", "myth_ruyi", "swap_ruyi")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function onattack(inst, attacker, target, skipsanity)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
	inst:Remove()
	if attacker and attacker.components.talker then
		attacker.components.talker:Say("珍贵的宝物应当被珍藏而不是战斗")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_ruyi")
    inst.AnimState:SetBuild("myth_ruyi")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("myth_ruyi")
	
	inst.Transform:SetScale(0.7, 0.7, 0.7)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(5)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_ruyi.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.dapperness = 3.3/60

    return inst
end

return Prefab("myth_ruyi", fn, assets)