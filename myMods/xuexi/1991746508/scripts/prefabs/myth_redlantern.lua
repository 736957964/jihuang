local assets =
{
    Asset("ANIM", "anim/redlantern.zip"),
    Asset("ANIM", "anim/redlantern_water.zip"),
	
	Asset("ATLAS", "images/inventoryimages/redlantern_myth_a.xml"),
	Asset("ATLAS", "images/inventoryimages/redlantern_myth_b.xml"),
	Asset("ATLAS", "images/inventoryimages/redlantern_myth_c.xml"),
	Asset("ATLAS", "images/inventoryimages/redlantern_myth_d.xml"),
	Asset("ATLAS", "images/inventoryimages/redlantern_myth_e.xml"),
}

local prefabs =
{
    "myth_redlanternlight",
    "myth_redlanternbody",
}

local function onremovelight(light)
    light._mythlantern._light = nil
end

local function stoptrackingowner(inst)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
        inst._owner = nil
    end
end

local function starttrackingowner(inst, owner)
    if owner ~= inst._owner then
        stoptrackingowner(inst)
        if owner ~= nil and owner.components.inventory ~= nil then
            inst._owner = owner
            inst:ListenForEvent("equip", inst._onownerequip, owner)
        end
    end
end

local function turnon(inst)
	local build = inst.AnimState:GetBuild()
    if inst._light == nil then
        inst._light = SpawnPrefab("myth_redlanternlight")
		if  build == "redlantern_myth_c" or build == "redlantern_myth_d" or "redlantern_myth_e" then
			inst._light.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
		end
        inst._light._mythlantern = inst
        inst:ListenForEvent("onremove", onremovelight, inst._light)
    end
    inst._light.entity:SetParent((inst.components.inventoryitem.owner or inst._body or inst).entity)

    inst.AnimState:Show("LIGHT")

    if inst._body ~= nil then
        inst._body.AnimState:Show("LIGHT")
    end

    if not (inst._body ~= nil and inst._body.entity:IsVisible()) and
        inst.components.equippable:IsEquipped() and
        inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner.AnimState:Show("LANTERN_OVERLAY")
    end
end

local function turnoff(inst)
    stoptrackingowner(inst)

    if inst._light ~= nil then
        inst._light:Remove()
    end

    inst.AnimState:Hide("LIGHT")

    if inst._body ~= nil then
        inst._body.AnimState:Hide("LIGHT")
    end

    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
    end
end

local function OnRemove(inst)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    if inst._body ~= nil then
        inst._body:Remove()
    end
end

local function ondropped(inst)
    turnoff(inst)
    turnon(inst)
end

local function ToggleOverrideSymbols(inst, owner)
	local build = inst.AnimState:GetBuild()
	local swap_build = "swap_"..build
    if owner.sg:HasStateTag("nodangle") or (owner.components.rider ~= nil and owner.components.rider:IsRiding() and not owner.sg:HasStateTag("forcedangle")) then
        owner.AnimState:OverrideSymbol("swap_object", swap_build, "swap_redlantern")
        owner.AnimState:Show("LANTERN_OVERLAY")
        inst._body:Hide()
    else
        owner.AnimState:OverrideSymbol("swap_object", swap_build, "swap_redlantern_stick")
        owner.AnimState:Hide("LANTERN_OVERLAY")
        inst._body:Show()
    end
end

local function onremovebody(body)
    body._mythlantern._body = nil
end

local function onequip(inst, owner)
	local build = inst.AnimState:GetBuild()
	local swap_build = "swap_"..build
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("lantern_overlay", swap_build, "redlantern_overlay")

    if inst._body ~= nil then
        inst._body:Remove()
    end
    inst._body = SpawnPrefab("myth_redlanternbody")
    inst._body._mythlantern = inst
	inst._body.AnimState:SetBuild(build)
    inst:ListenForEvent("onremove", onremovebody, inst._body)

    inst._body.entity:SetParent(owner.entity)
    inst._body.entity:AddFollower()
    inst._body.Follower:FollowSymbol(owner.GUID, "swap_object", 90, -136, 0)--68, -126,
    inst._body:ListenForEvent("newstate", function(owner, data)
        ToggleOverrideSymbols(inst, owner)
    end, owner)

    ToggleOverrideSymbols(inst, owner)

    if owner.components.bloomer ~= nil then
        owner.components.bloomer:AttachChild(inst._body)
    end
    if owner.components.colouradder ~= nil then
        owner.components.colouradder:AttachChild(inst._body)
    end

    if inst._body.entity:IsVisible() then
        owner.AnimState:Hide("LANTERN_OVERLAY")
    else
        owner.AnimState:Show("LANTERN_OVERLAY")
    end
    turnon(inst)
end

local function onunequip(inst, owner)
	local build = inst.AnimState:GetBuild()
	local swap_build = "swap_"..build
    if inst._body ~= nil then
        if inst._body.entity:IsVisible() then
            --need to see the lantern when animating putting away the object
            owner.AnimState:OverrideSymbol("swap_object", swap_build, "swap_redlantern")
        end
        if inst._light ~= nil then
            inst._light.entity:SetParent((inst.components.inventoryitem.owner or inst).entity)
        end
        inst._body:Remove()
    end

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")
    starttrackingowner(inst, owner)
end

local function updatelight(inst, phase)
    if phase == "day" then
        inst.Light:SetRadius(1.5)
    elseif phase == "night" then
        inst.Light:SetRadius(3) 
    elseif phase == "dusk" then
        inst.Light:SetRadius(1.5) 
    end
end

local function ondeath(inst)
	--inst.components.lootdropper:DropLoot()
end

local function onpreload(inst, data)  --兼容旧的存档
    if data ~= nil and data.myth_itemskin_theme ~= nil and data.myth_itemskin_theme.skin ~= nil then
		TheSim:ReskinEntity( inst.GUID, nil, data.myth_itemskin_theme.skin)
    end
end

local function lanternlightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetIntensity(.8)
    inst.Light:SetFalloff(.5)
	inst.Light:SetRadius(1.5)
	inst.Light:SetColour(200 / 255, 100 / 255, 100 / 255)
	inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:WatchWorldState("phase", updatelight)

    updatelight(inst, TheWorld.state.phase)
    inst.persists = false
    return inst
end

--local skins = {"redlantern_myth_a","redlantern_myth_b","redlantern_myth_c","redlantern_myth_d",}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("redlantern")
    inst.AnimState:SetBuild("redlantern_myth_a")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("light")

    MakeInventoryFloatable(inst, "med", nil, {0.775, 0.5, 0.775})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    --inst:AddComponent("health")
    --inst.components.health.canmurder = false
    --inst.components.health:SetMaxHealth(1)
    --inst:ListenForEvent("death", ondeath)

    inst:AddComponent("lootdropper")

	
	inst:AddComponent("myth_redlantern")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)
	inst.components.inventoryitem.imagename = "redlantern_myth_a"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/redlantern_myth_a.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("float") end)
    inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle_loop", true) end)

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    inst.components.burnable.ignorefuel = true

    inst.OnRemoveEntity = OnRemove

    inst._light = nil
    turnon(inst)

    inst._onownerequip = function(owner, data)
        if data.item ~= inst and
            (   data.eslot == EQUIPSLOTS.HANDS or
                (data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))
            ) then
            turnoff(inst)
        end
    end
	inst.OnPreLoad = onpreload
    return inst
end

local function lanternbodyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("redlantern")
	inst.AnimState:SetBuild("redlantern_myth_a")
    inst.AnimState:PlayAnimation("idle_body_loop", true)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst.persists = false

    return inst
end

local function groundbodyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddLight()

    inst.AnimState:SetBank("redlantern") --redlantern
	inst.AnimState:SetBuild("redlantern_myth_a")
    inst.AnimState:PlayAnimation("idle_body_loop", true)
	inst.AnimState:SetLightOverride(.5)

    --inst.Light:SetIntensity(.7)
    --inst.Light:SetFalloff(.5)
	--inst.Light:SetRadius(1.5)
	--inst.Light:SetColour(200 / 255, 100 / 255, 100 / 255)
	--inst.Light:Enable(true)
	
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    --inst:WatchWorldState("phase", updatelight)

    --updatelight(inst, TheWorld.state.phase)
	
    inst.persists = false

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetIntensity(.8)
    inst.Light:SetFalloff(.6)
	inst.Light:SetRadius(1.5)
	inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
	inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:WatchWorldState("phase", updatelight)

    updatelight(inst, TheWorld.state.phase)

    return inst
end

return Prefab("myth_redlantern", fn, assets, prefabs),
    Prefab("myth_redlanternlight", lanternlightfn),
    Prefab("myth_redlanternbody", lanternbodyfn),
	Prefab("myth_redlanternlight_ground", groundbodyfn),
    Prefab("myth_redlanternlight_ground_light", lightfn)
