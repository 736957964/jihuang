local assets =
{
    Asset("ANIM", "anim/myth_weapon_syd.zip"),
    Asset("ANIM", "anim/obsidian_tool_meter.zip"),
    Asset("IMAGE", "images/inventoryimages/myth_weapon_syd.tex"),
    Asset("ATLAS", "images/inventoryimages/myth_weapon_syd.xml"),
}

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

local function UpdateDamage(inst)
    if inst.components.finiteuses.current < 1 then
        inst.components.weapon:SetDamage(0)
    elseif inst.components.myth_show_hotmeter and inst.components.weapon then
        local dmg = 72 * inst.components.myth_show_hotmeter:GetPercent()
        dmg = Remap(dmg, 0, 72, 0.5*72, 72)
        inst.components.weapon:SetDamage(dmg)
    end
end

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "myth_weapon_syd", "swap")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    UpdateDamage(inst)
end


local function onunequip(inst, owner)
    UpdateDamage(inst)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, owner, target)
    UpdateDamage(inst)
    if inst.components.myth_show_hotmeter ~= nil then
		inst.components.myth_show_hotmeter:Use(owner, target) --增加热度
    end
end

local function onchargedelta(inst,old,new)

    local percentage = new/inst.components.myth_show_hotmeter.maxcharge
    local rad = Lerp(1, 2.5, percentage)

	--刷新光照
    if percentage >= inst.components.myth_show_hotmeter.red_threshold then
        inst.hotfire.Light:Enable(true)
        inst.hotfire.Light:SetColour(254/255,98/255,75/255)
        inst.hotfire.Light:SetRadius(rad)
    elseif percentage >= inst.components.myth_show_hotmeter.orange_threshold then
        inst.hotfire.Light:Enable(true)
        inst.hotfire.Light:SetColour(255/255,159/255,102/255)
        inst.hotfire.Light:SetRadius(rad)
    elseif percentage >= inst.components.myth_show_hotmeter.yellow_threshold then
        inst.hotfire.Light:Enable(true)
        inst.hotfire.Light:SetColour(255/255,223/255,125/255)
        inst.hotfire.Light:SetRadius(rad)
    else
        inst.hotfire.Light:Enable(false)
    end
end

local function Lunge(inst, doer, pos)
    if inst.components.finiteuses.current < 1 then
        return
    end
    doer.components.hunger:DoDelta(-5)
    inst.components.finiteuses:Use(1)
    
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, doer, 40)
    local numsteps = 8 
    local x, y, z = doer.Transform:GetWorldPosition() 
    local angle = (doer.Transform:GetRotation() + 90) * DEGREES   
    local step = 1.1--.75
    local offset = 1.5--1 - step 
    local ground = TheWorld.Map
    local targets = {} 
    local i = -1
    local noground = false
    local fx, dist, delay, x1, z1
    while i < numsteps do
        i = i + 1
        dist = i * step + offset 
        delay = math.max(0, i - 1)
        x1 = x + dist * math.sin(angle) 
        z1 = z + dist * math.cos(angle)
		if not ground:IsPassableAtPoint(x1, 0, z1) then
            if i <= 0 then
                return
            end
            noground = true
        end
        fx = SpawnPrefab("myth_weapon_syd_fx")
        fx.Transform:SetPosition(x1, 0, z1)
        fx:Trigger(delay * FRAMES, targets, doer, inst)
        if noground then
            break
        end
    end
    if i < numsteps then
        dist = (i + .5) * step + offset
        x1 = x + dist * math.sin(angle)
        z1 = z + dist * math.cos(angle)
    end
    inst.components.rechargeable:StartRecharging()
end

local function GetEquippedHeat(inst, observer)
    return 110
end

local function OnLoad(inst, data)
    UpdateDamage(inst)
end

local function OnOwnerChange(inst)
    local newowners = {}
    local owner = inst
    while owner.components.inventoryitem ~= nil do
        newowners[owner] = true

        if inst._owners[owner] then
            inst._owners[owner] = nil
        else
            inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
            inst:ListenForEvent("ondropped", inst._onownerchange, owner)
        end

        local nextowner = owner.components.inventoryitem.owner
        if nextowner == nil then
            break
        end

        owner = nextowner
    end

    inst.hotfire.entity:SetParent(owner.entity)

    for k, v in pairs(inst._owners) do
        if k:IsValid() then
            inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
            inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
        end
    end

    inst._owners = newowners
end

local function aoespellsg(inst,doer,action)
    return "weapon_syd"
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_weapon_syd")
    inst.AnimState:SetBuild("myth_weapon_syd")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_hotmeter") --标签
    inst:AddTag("weapon_syd")
    inst:AddTag("rechargeable")
    inst:AddTag("mk_nodrop")

    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticulelongmulti"
    inst.components.aoetargeting.reticule.pingprefab = "reticulelongmultiping"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true

    inst.myth_aoespellsg = aoespellsg

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon.onattack = onattack

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(600)
    inst.components.finiteuses:SetUses(600)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_weapon_syd.xml"

    inst:AddComponent("myth_aoespell")
    inst.components.aoespell = inst.components.myth_aoespell
    inst.components.aoespell:SetSpellFn(Lunge)
    inst.components.aoespell.ispassableatallpoints = true
    inst:RegisterComponentActions("aoespell")

    inst:AddComponent("myth_rechargeable")
    inst.components.rechargeable = inst.components.myth_rechargeable
    inst.components.rechargeable:SetRechargeTime(10)
    inst:RegisterComponentActions("rechargeable")

	inst:AddComponent("heater")
    inst.components.heater:SetThermics(true, false)
	inst.components.heater.equippedheatfn = GetEquippedHeat
    inst.components.heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR

	--光照
	--inst.hotfire = inst:SpawnChild("myth_hotmeter_fx")

    inst.hotfire = SpawnPrefab("myth_hotmeter_fx")
    inst._owners = {}
    inst._onownerchange = function() OnOwnerChange(inst) end
    OnOwnerChange(inst)   

	--热量
	inst:AddComponent("myth_show_hotmeter")
	inst.components.myth_show_hotmeter.onchargedelta = onchargedelta

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst.OnLoad = OnLoad


    MakeHauntableLaunch(inst)

    return inst
end



local RADIUS = 1.0

local function DoDamage(inst, targets, doer, weapon)
	local x, y, z = inst.Transform:GetWorldPosition()
    if inst.AnimState ~= nil then
		inst.AnimState:PlayAnimation("puff_"..math.random(3))
		inst:Show()
		inst:DoTaskInTime(0.7 + 2 * FRAMES, inst.Remove)
    else
        inst:DoTaskInTime(2 * FRAMES, inst.Remove)
	end
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, RADIUS + 3, {"_combat", }, { "playerghost", "INLIMBO", "player","companion","wall" })) do
        if not targets[v] and v:IsValid() and not v:IsInLimbo() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            local vradius = v:GetPhysicsRadius(.5)
            local range = RADIUS + vradius
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                if doer ~= nil and doer:IsValid() and doer.components.combat and doer.components.combat:CanTarget(v) then
                    targets[v] = true
					doer:PushEvent("onareaattackother", { target = v, weapon = weapon or nil })
					v.components.combat:GetAttacked(doer, 2*weapon.components.weapon:GetDamage(doer, v))
                end
            end
        end
    end
end

local function Trigger(inst, delay, targets,doer,weapon)
    if inst.task ~= nil then
        inst.task:Cancel()
        if (delay or 0) > 0 then
            inst.task = inst:DoTaskInTime(delay, DoDamage, targets or {}, doer, weapon)
        else
            DoDamage(inst, targets or {}, doer, weapon)
        end
    end
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("halloween_embers")
	inst.AnimState:SetBuild("halloween_embers")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst:Hide()
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.persists = false
	
	inst.task = inst:DoTaskInTime(0, inst.Remove)
	inst.Trigger = Trigger  
	return inst
end

return Prefab("myth_weapon_syd", fn, assets), Prefab("myth_weapon_syd_fx", fxfn)