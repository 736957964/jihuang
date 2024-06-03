local assets =
{
    Asset("ANIM", "anim/armor_siving.zip"),
	Asset("ATLAS", "images/inventoryimages/armorsiving.xml"),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_body", "armor_siving", "swap_body")
    
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function OnTaskTick(inst)
    if not TheWorld.state.isday then
        return
    end
    if TheWorld.state.israining then 
        return
    end
    local owner = inst.components.inventoryitem.owner
    local per = inst.components.armor:GetPercent()
    if owner then
        return
    end
    if per > 0 and per < 0.5 then
        inst.components.armor:SetCondition(inst.components.armor.condition+2)
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_siving")
    inst.AnimState:SetBuild("armor_siving")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("metal")

    inst.foleysound = "dontstarve/movement/foley/metalarmour"

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armorsiving.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(3000, 0.9)

    local old_GetAbsorption = inst.components.armor.GetAbsorption
    inst.components.armor.GetAbsorption = function(self,attacker, weapon)
        if self.condition > 0 and attacker and (attacker:HasTag("nightmare") or attacker:HasTag("shadow") 
        or attacker:HasTag("shadowchesspiece") or attacker:HasTag("stalker") or attacker:HasTag("stalkerminion")) then
            return 0.95
        end
        return old_GetAbsorption(self,attacker, weapon)
    end

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = 3.3/60

    MakeHauntableLaunch(inst)

    inst:DoPeriodicTask(5, OnTaskTick,1)
    --inst:ListenForEvent("percentusedchange", onpercent)
    --onpercent(inst)	

    return inst
end

return Prefab("armorsiving", fn, assets)
