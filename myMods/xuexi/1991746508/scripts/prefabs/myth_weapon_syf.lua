local assets = {
    Asset("ANIM", "anim/myth_weapon_syf.zip"),
    Asset("IMAGE", "images/inventoryimages/myth_weapon_syf.tex"),
    Asset("ATLAS", "images/inventoryimages/myth_weapon_syf.xml"),
}

local prefabs = {
    "reticulearc",
    "reticulearcping"
}

local function addcold(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner ~= nil and owner.components.temperature and owner.components.temperature.current< 0 then   
        if owner.components.freezable ~= nil and not owner.components.freezable:IsFrozen() then
            owner.components.freezable:AddColdness(2)
            owner.components.freezable:SpawnShatterFX()
        end
    end
end
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "myth_weapon_syf", "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.coldnesscheck then
        inst.coldnesscheck:Cancel()
    end
    inst.coldnesscheck = inst:DoPeriodicTask(2,addcold,2)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst.coldnesscheck then
        inst.coldnesscheck:Cancel()
        inst.coldnesscheck = nil
    end
end

local function onattack(inst, attacker, target, skipsanity)
    if inst.components.finiteuses and inst.components.finiteuses.current < 1 then
        return
    end
    if not target:IsValid() then
        return
    end
    if not attacker:IsValid() then
        return
    end
    local x,y,z =  target.Transform:GetWorldPosition()
    local x0,y0,z0 =  attacker.Transform:GetWorldPosition()
	local sparkle = attacker:SpawnChild("myth_gale_sparkle_vfx")
	sparkle.Transform:SetPosition(1.2,0,0)
	sparkle._target_pos_x:set(x-x0)
	sparkle._target_pos_y:set(0)
	sparkle._target_pos_z:set(z-z0)
	sparkle._can_emit:set(true)

    if target.components.burnable ~= nil then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end

    if target.components.freezable ~= nil then
        target.components.freezable:AddColdness(0.5)
        target.components.freezable:SpawnShatterFX()
    end
end

local function isinrange(inst,target)
    local ang = inst.Transform:GetRotation()
    local x,y,z = target.Transform:GetWorldPosition()
    local angle = inst:GetAngleToPoint( x,0,z )
    local drot = math.abs( ang - angle )
    while drot > 180 do
        drot = math.abs(drot - 360)
    end
    return drot < 70
end

local function Lunge(inst, doer, pos)
    if inst.components.finiteuses.current < 1 then
        return
    end
    doer.components.hunger:DoDelta(-5)
    inst.components.finiteuses:Use(1)
    local x,y,z = doer.Transform:GetWorldPosition()

    for k = 1,12 do
        local facing_angle = (doer.Transform:GetRotation() + GetRandomMinMax(-60,60)) * DEGREES
        local fx = SpawnPrefab("icespike_fx_"..tostring(math.random(1, 4)))
        fx.Transform:SetPosition(x + GetRandomMinMax(1.5,3.5) * math.cos(facing_angle), 0, z - GetRandomMinMax(1.5,3.5) * math.sin(facing_angle))
        local s = 0.5 + math.random()    
        fx.Transform:SetScale(s,s,s)
    end

    local ent = TheSim:FindEntities(x, 0, z, 4, {"_combat"}, { "playerghost", "INLIMBO", "player","companion","wall" }) 
    for i, v in ipairs(ent) do
        if v and v:IsValid() and isinrange(doer,v)  and not v:IsInLimbo() and 
            v.components.combat and not (v.components.health ~= nil and v.components.health:IsDead()) then
            doer:PushEvent("onareaattackother", { target = v, weapon = inst or nil, stimuli = inst.prefab })
            v.components.combat:GetAttacked(doer, inst.components.weapon:GetDamage(doer, v), inst) 
            if v.components.freezable then
                v.components.freezable:AddColdness(4)
                v.components.freezable:SpawnShatterFX()
            end
        end
    end
    inst.components.rechargeable:StartRecharging()
end

local function GetEquippedHeat(inst, observer)
    return -25
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

local function onpercent(inst,data)
	local percent =  data and data.percent or inst.components.finiteuses.current
	if percent <= 0 then 
		inst.components.weapon:SetDamage(0)
	else
		inst.components.weapon:SetDamage(51) 
	end
end

local function aoespellsg(inst,doer,action)
    return "weapon_syf"
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_weapon_syf")
    inst.AnimState:SetBuild("myth_weapon_syf")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("weapon")
    inst:AddTag("weapon_syf")
    inst:AddTag("rechargeable")
    inst:AddTag("mk_nodrop")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticulearc"
    inst.components.aoetargeting.reticule.pingprefab = "reticulearcping"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.aoetargeting.reticule.validcolour = { 0/255, 229/255, 230/255, 1 } 
    inst.components.aoetargeting.reticule.invalidcolour = { 0/255, 229/255, 232/255, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true
    inst.components.aoetargeting.alwaysvalid = true 

    inst.myth_aoespellsg = aoespellsg
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(400)
    inst.components.finiteuses:SetUses(400)

    inst:AddComponent("inspectable")

	inst:AddComponent("heater")
    inst.components.heater:SetThermics(false, true)
	inst.components.heater.equippedheatfn = GetEquippedHeat
    inst.components.heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_weapon_syf.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("myth_aoespell")
    inst.components.aoespell = inst.components.myth_aoespell
    inst.components.aoespell:SetSpellFn(Lunge)
    inst.components.aoespell.ispassableatallpoints = true
    inst:RegisterComponentActions("aoespell")

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)

    inst:AddComponent("myth_rechargeable")
    inst.components.rechargeable = inst.components.myth_rechargeable
    inst.components.rechargeable:SetRechargeTime(10)
    inst:RegisterComponentActions("rechargeable")

    inst:ListenForEvent("percentusedchange", onpercent)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("myth_weapon_syf", fn, assets,prefabs)