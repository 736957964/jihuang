local assets =
{
    Asset("ANIM", "anim/myth_qxj.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/inventoryimages/myth_qxj.xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "myth_qxj", "swap_qxj")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    inst.components.weapon:SetDamage(34)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end



local function ReticuleTargetFn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end

local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end

local function Lunge(inst, doer, pos)
    local projectile = doer.components.inventory:DropItem(inst, false)
    if projectile ~= nil then
        projectile.components.myth_qxj_biu:Throw(doer, pos)
    end
	inst.components.rechargeable:StartRecharging()
    return true
end

local function ReturnToOwner(inst, owner)
    if owner and owner:IsValid() and not owner.components.health:IsDead() and owner.components.inventory then
        owner.components.inventory:Equip(inst)
    end
end

local function OnThrown(inst, owner, target)
    if not inst.shadow_task then
        inst.shadow_task = inst:DoPeriodicTask(0, function()
            local fx = SpawnPrefab('myth_qxj_shadow')
            local angle = inst.Transform:GetRotation()
            fx.Transform:SetPosition(inst:GetPosition():Get())
            fx.Transform:SetRotation(angle)
        end)
    end
end

local function onattack(inst, owner, target)
    if target and (target:HasTag("nightmare") or target:HasTag("shadow") or target:HasTag("shadowchesspiece"))
        and target.components.lootdropper ~= nil then
            target.components.lootdropper.nodroploot = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_qxj")
    inst.AnimState:SetBuild("myth_qxj")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticulelong"
    inst.components.aoetargeting.reticule.pingprefab = "reticulelongping"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true

    inst:AddTag("sharp")
    inst:AddTag("throw_line")
    inst:AddTag("rechargeable")
    --inst:AddTag("irreplaceable")
    inst:AddTag("mk_nodrop")
    inst:AddTag("weapon")

	local swap_data = {sym_build = "myth_qxj",sym_name = "swap_qxj"}
	MakeInventoryFloatable(inst, "med", 0.05, {0.9, 0.5, 0.9}, true, -22, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon.GetDamage = function(self,attacker, target)
        if target and (target:HasTag("nightmare") or target:HasTag("shadow") or target:HasTag("shadowchesspiece")) then
            if target.components.lootdropper then
                target.components.lootdropper.GenerateLoot = function(...) return {} end
            end
            return 999999999999999
        end
        return self.damage
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_qxj.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("myth_aoespell")
    inst.components.aoespell = inst.components.myth_aoespell
	inst.components.aoespell:SetSpellFn(Lunge)
    inst.components.aoespell.ispassableatallpoints = true
	inst:RegisterComponentActions("aoespell")
	
	inst:AddComponent("myth_rechargeable")
    inst.components.rechargeable = inst.components.myth_rechargeable
	inst.components.rechargeable:SetRechargeTime(10)
	inst:RegisterComponentActions("rechargeable")

	inst:AddComponent("myth_qxj_biu")
	inst.components.myth_qxj_biu:SetSpeed(20)
	inst.components.myth_qxj_biu:SetRange(16)
    inst.components.myth_qxj_biu:SetHitDist(1)
    inst.components.myth_qxj_biu:SetLaunchOffset(Vector3(1, 0.6, 0))
    inst.components.myth_qxj_biu:SetOnThrownFn(OnThrown)
    inst.components.myth_qxj_biu:SetOnMissFn(ReturnToOwner)
    --DebugSpawn"spider"
    MakeHauntableLaunch(inst)

    return inst
end

local function fxfn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

	inst.entity:AddNetwork()
	
    anim:SetBank('myth_qxj')
    anim:SetBuild('myth_qxj')
    inst.AnimState:PlayAnimation("thrown")

    anim:SetMultColour(0.4,0.4,0.4,0.4)
    inst:AddTag('FX')
    inst:AddTag('NOCLICK')
    anim:SetOrientation(ANIM_ORIENTATION.OnGround)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.persists = false
	
    inst:AddComponent('colourtweener')
    inst.components.colourtweener:StartTween({0,0,0,0}, 0.3, inst.Remove)

    return inst
end

return Prefab("myth_qxj", fn, assets),
    Prefab("myth_qxj_shadow", fxfn)