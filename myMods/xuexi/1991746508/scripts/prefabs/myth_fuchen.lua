local assets =
{
    Asset("ANIM", "anim/myth_fuchen.zip"),
    Asset("ANIM", "anim/swap_myth_fuchen.zip"),
    Asset("IMAGE", "images/inventoryimages/myth_fuchen.tex"),
    Asset("ATLAS", "images/inventoryimages/myth_fuchen.xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_myth_fuchen", "swap_whip")
    owner.AnimState:OverrideSymbol("whipline", "swap_myth_fuchen", "whipline")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() then
        if target.components.combat and target.components.combat:HasTarget() then
            target.components.combat:DropTarget()
        end
    end
end

local REPEL_RADIUS = 1.5
local REPEL_RADIUS_SQ = REPEL_RADIUS * REPEL_RADIUS


local jiaoxie = {
    pigman = true,
    bunnyman = true,
    monkey = true,
}
local function dropeqiups(inst)
    if inst.components.inventory and jiaoxie[inst.prefab] then
        inst.components.inventory:DropEquipped()
    end
    if inst.components.combat and inst.components.combat:HasTarget() then
        inst.components.combat:DropTarget()
    end
end

local function UpdateRepel(inst, x, z, creatures)
    for i = #creatures, 1, -1 do
        local v = creatures[i]
        if not (inst:IsValid() and  v.inst:IsValid() and v.inst.entity:IsVisible()) then
            table.remove(creatures, i)
        elseif v.speed == nil then
            local distsq = v.inst:GetDistanceSqToPoint(x, 0, z)
            if distsq > REPEL_RADIUS_SQ then
                if distsq > 0 then
                    v.inst:ForceFacePoint(x, 0, z)
                end
                v.speed = 15*(0.5*distsq/16)--25 * k
                v.inst.Physics:SetMotorVelOverride(v.speed, 0, 0)
            end
        else 
            local distsq = v.inst:GetDistanceSqToPoint(x, 0, z)
            if distsq < REPEL_RADIUS_SQ then
                v.inst.Physics:ClearMotorVelOverride()
                v.inst.Physics:Stop()
                table.remove(creatures, i)
            else
                local x1, y1, z1 = v.inst.Transform:GetWorldPosition()
                if x1 ~= x or z1 ~= z then
                    v.inst:ForceFacePoint(x, 0, z)
                end
                dropeqiups(v.inst)
                v.inst.Physics:SetMotorVelOverride(v.speed, 0, 0)
            end
        end
    end
end

local function TimeoutRepel(inst, creatures, task)
    task:Cancel()
    for i, v in ipairs(creatures) do
        if v.speed ~= nil then
            v.inst.Physics:ClearMotorVelOverride()
            v.inst.Physics:Stop()
            dropeqiups(v.inst)
        end
    end
end

local function spellfn(inst,doer,target)
	if inst.components.rechargeable.recharging  then
        return 
	end	
    inst.components.rechargeable:StartRecharging()
    if target.components.myth_jzfz ~= nil then
        target.components.myth_jzfz:FanZzhuan()
    elseif doer.components.inventory and target.components.inventoryitem and target.components.inventoryitem.canbepickedup then
        doer:PushEvent("onpickupitem", { item = target })
        doer.components.inventory:GiveItem(target, nil, target:GetPosition())
    elseif target.components.health and not target.components.health:IsDead() and target.components.locomotor then
        local creatures = {}
        if target.Physics ~= nil then
            table.insert(creatures, { inst = target })
        end
        local x, y, z = doer.Transform:GetWorldPosition()
        if #creatures > 0 then
            doer:DoTaskInTime(10 * FRAMES, TimeoutRepel, creatures,
            doer:DoPeriodicTask(0, UpdateRepel, nil, x, z, creatures)
            )
        end	
    end
end

local function onrechargingfn(inst)
    inst.components.fuchen_spell.canspell = false
end

local function onstoprechargfn(inst)
    inst.components.fuchen_spell.canspell = true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_fuchen")
    inst.AnimState:SetBuild("myth_fuchen")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("whip")

    inst:AddTag("rechargeable")

    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", nil, 0.9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(TUNING.WHIP_RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_fuchen.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.25

    inst:AddComponent("fuchen_spell")
    inst.components.fuchen_spell:SetSpellFn(spellfn)

	inst:AddComponent("myth_rechargeable")
    inst.components.rechargeable = inst.components.myth_rechargeable
	inst.components.rechargeable:SetRechargeTime(10)
    inst.components.rechargeable.rechargingfn = onrechargingfn
    inst.components.rechargeable.stoprechargfn = onstoprechargfn
    inst:RegisterComponentActions("rechargeable")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("myth_fuchen", fn, assets)
