local assets = {
    Asset("ANIM", "anim/myth_weapon_gtt.zip"),
    Asset("IMAGE", "images/inventoryimages/myth_weapon_gtt.tex"),
    Asset("ATLAS", "images/inventoryimages/myth_weapon_gtt.xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "myth_weapon_gtt", "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.components.combat then
        owner.components.combat:SetAttackPeriod(0.8)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if owner.components.combat then
        owner.components.combat:SetAttackPeriod(0.4)
    end
end

local function onattack(inst, attacker, target, skipsanity)
    if not (inst.components.finiteuses.current > 0) then
        return
    end
    if target:IsValid() then
        local x, y, z = target.Transform:GetWorldPosition()
        local ent = TheSim:FindEntities(x, 0, z, 3, {"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })
        for i, v in ipairs(ent) do
            if v and v ~= target and v:IsValid() and not v:IsInLimbo() and not (v.components.health ~= nil and v.components.health:IsDead()) then
                if attacker ~= nil and attacker:IsValid() and attacker.components.combat and attacker.components.combat:CanTarget(v) then
                    attacker:PushEvent("onareaattackother", { target = v, weapon = inst or nil, stimuli = inst.prefab })
                    v.components.combat:GetAttacked(attacker, 51)
                end
            end
        end
    end
end
local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    for r = 7, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function UpdateOverrideSymbols(inst, state)
    inst.AnimState:OverrideSymbol("cracks1", "antlion_sinkhole", "cracks_pre"..tostring(state))
end

local function SpawnFx(doer, scale,pos)
    local theta = math.random() * PI * 2
    local num = 10
    local radius = 1.6
    local dtheta = 2 * PI / num
    local x, y, z = pos:Get()
    SpawnPrefab("sinkhole_spawn_fx_"..math.random(3)).Transform:SetPosition(x, y, z)
    for i = 1, num do
        local dust = SpawnPrefab("sinkhole_spawn_fx_"..math.random(3))
        dust.Transform:SetPosition(x + math.cos(theta) * radius * (1 + math.random() * .1), 0, z - math.sin(theta) * radius * (1 + math.random() * .1))
        local s = scale + math.random() * .2
        dust.Transform:SetScale(i % 2 == 0 and -s or s, s, s)
        theta = theta + dtheta
    end
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, doer, 40)
    doer.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
end

local function Lunge(inst, doer, pos)
    if inst.components.finiteuses.current < 1 then
        return
    end
    doer:PushEvent("weapon_gtt_do", {targetpos = pos, weapon = inst})
    doer.components.hunger:DoDelta(-5)
    inst.components.finiteuses:Use(1)
    
    inst.components.rechargeable:StartRecharging()
end

local function doleap(inst,doer,startpos,endpos)
    local fx = SpawnPrefab("myth_weapon_gtt_fx")
    SpawnFx(doer, .8,endpos)
    UpdateOverrideSymbols(fx, 1)
    fx.Transform:SetPosition(endpos.x, endpos.y, endpos.z)
    local ent = TheSim:FindEntities(endpos.x, 0, endpos.z, 3, {"_combat"}, { "playerghost", "INLIMBO", "player","companion","wall" })
    for i, v in ipairs(ent) do
        if v and v:IsValid() and not v:IsInLimbo() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            doer:PushEvent("onareaattackother", { target = v, weapon = inst or nil, stimuli = inst.prefab })
            local x1,y1,z1 = v.Transform:GetWorldPosition()
            local dmg = 200 * (9-distsq(x1, z1, endpos.x, endpos.z))/9
            dmg = Remap(dmg, 0, 200, 50, 200)
            v.components.combat:GetAttacked(doer, dmg)
        end
    end
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
    return "weapon_gtt_start"
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_weapon_gtt")
    inst.AnimState:SetBuild("myth_weapon_gtt")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("weapon")
    inst:AddTag("weapon_gtt")
    inst:AddTag("rechargeable")
    inst:AddTag("mk_nodrop")
    --inst:AddTag("propweapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetRange(3.5)
    inst.components.aoetargeting.reticule.reticuleprefab = "purple_gourd_re3"
    inst.components.aoetargeting.reticule.pingprefab = "purple_gourd_re4"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true
    --inst.components.aoetargeting.targetprefab = "purple_gourd_re3"

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

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_weapon_gtt.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("myth_aoespell")
    inst.components.aoespell = inst.components.myth_aoespell
    inst.components.aoespell:SetSpellFn(Lunge)
    inst:RegisterComponentActions("aoespell")

    inst:AddComponent("myth_rechargeable")
    inst.components.rechargeable = inst.components.myth_rechargeable
    inst.components.rechargeable:SetRechargeTime(20)

    inst:RegisterComponentActions("rechargeable")

    inst:ListenForEvent("percentusedchange", onpercent)

    inst.DoLeap = doleap
    MakeHauntableLaunch(inst)

    return inst
end


local function fxfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sinkhole")
    inst.AnimState:SetBuild("antlion_sinkhole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst.Transform:SetEightFaced()

    inst:AddTag("fx")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(1,ErodeAway)

    return inst
end

return Prefab("myth_weapon_gtt", fn, assets),Prefab("myth_weapon_gtt_fx", fxfn)