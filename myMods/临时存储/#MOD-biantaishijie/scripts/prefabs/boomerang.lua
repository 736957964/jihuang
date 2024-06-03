local assets =
{
    Asset("ANIM", "anim/boomerang.zip"),
    Asset("ANIM", "anim/swap_boomerang.zip"),
}

local function dmcc(inst ,owner)
if owner == nil or owner.components.inventory == nil then
        return
    end
    local x, y, z = owner.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 40, { "_inventoryitem" }, { "INLIMBO", "NOCLICK", "catchable", "fire", "minesprung", "mineactive" })
    for i, v in ipairs(ents) do
        if v:HasTag("thrown")and v:HasTag("projectile")and v:HasTag("dsb")then

            --Amulet will only ever pick up items one at a time. Even from stacks.

            local v_pos = v:GetPosition()
            if v.components.stackable ~= nil then
                v = v.components.stackable:Get()
            end

            if v.components.trap ~= nil and v.components.trap:IsSprung() then
                v.components.trap:Harvest(owner)
            else
                owner.components.inventory:Equip(v, nil, v_pos)
            end
            return
        end
    end

end



local function OnFinished(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", inst.Remove)
end

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_boomerang", "swap_boomerang")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
	inst.task = inst:DoPeriodicTask(.1, function()dmcc(inst ,owner)end)
end

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	inst.task = inst:DoPeriodicTask(.1, function()dmcc(inst ,owner)end)
end

local function OnThrown(inst, owner, target)
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
end

local function OnCaught(inst, catcher)
    if catcher ~= nil and catcher.components.inventory ~= nil and catcher.components.inventory.isopen then
        if inst.components.equippable ~= nil and not catcher.components.inventory:GetEquippedItem(inst.components.equippable.equipslot) then
            catcher.components.inventory:Equip(inst)
        else
            catcher.components.inventory:GiveItem(inst)
        end
        catcher:PushEvent("catch")
    end
end

local function ReturnToOwner(inst, owner)
    if owner ~= nil and not (inst.components.finiteuses ~= nil and inst.components.finiteuses:GetUses() < 1) then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        inst.components.projectile:Throw(owner, owner)
    end
end

local function OnHit(inst, owner, target)
    if owner == target or owner:HasTag("playerghost") then
       ReturnToOwner(inst, owner)
    else
         OnDropped(inst)
    end
    if target ~= nil and target:IsValid() then
        local impactfx = SpawnPrefab("impact")
        if impactfx ~= nil then
            local follower = impactfx.entity:AddFollower()
            follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
            impactfx:FacePoint(inst.Transform:GetWorldPosition())
        end
    end
end

local function OnMiss(inst, owner, target)
    if owner == target then
        OnDropped(inst)
    else
        ReturnToOwner(inst, owner)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("boomerang")
    inst.AnimState:SetBuild("boomerang")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("thrown")
	inst:AddTag("dsb")

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(200)
    inst.components.weapon:SetRange(12, 16)
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(50)
    inst.components.finiteuses:SetUses(50)

    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("inspectable")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(15)
    inst.components.projectile:SetCanCatch(true)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile:SetOnCaughtFn(OnCaught)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("boomerang", fn, assets)
