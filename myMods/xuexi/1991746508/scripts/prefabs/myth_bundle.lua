require "prefabs/winter_ornaments"

local function OnStartBundling(inst)--, doer)
    inst.components.stackable:Get():Remove()
end

local function MakeWrap(name, containerprefab, tag, cheapfuel)
    local assets =
    {
        Asset("ANIM", "anim/"..name..".zip"),
    }

    local prefabs =
    {
        name,
        containerprefab,
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("bundle")
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")

        if tag ~= nil then
            inst:AddTag(tag)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetSinks(true)
		inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_bundlewrap.xml"	

        inst:AddComponent("bundlemaker")
        inst.components.bundlemaker:SetBundlingPrefabs(containerprefab, name)
        inst.components.bundlemaker:SetOnStartBundlingFn(OnStartBundling)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = cheapfuel and TUNING.TINY_FUEL or TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
        inst.components.propagator.flashpoint = 10 + math.random() * 5
        MakeHauntableLaunchAndIgnite(inst)

        return inst
    end

    return Prefab(name.."wrap", fn, assets, prefabs)
end

local function onburnt(inst)
    inst.burnt = true
    inst.components.unwrappable:Unwrap()
end

local function onignite(inst)
    inst.components.unwrappable.canbeunwrapped = false
end

local function onextinguish(inst)
    inst.components.unwrappable.canbeunwrapped = true
end

local function MakeBundle(name, onesize, variations, loot, tossloot, setupdata, bank, build, inventoryimage)
    local assets =
    {
        Asset("ANIM", "anim/"..(inventoryimage or name)..".zip"),
		Asset( "ATLAS", "images/inventoryimages/myth_bundlewrap.xml" ),
		Asset( "ATLAS", "images/inventoryimages/myth_bundle_small.xml" ),
		Asset( "ATLAS", "images/inventoryimages/myth_bundle_medium.xml" ),
		Asset( "ATLAS", "images/inventoryimages/myth_bundle_large.xml" ),
    }
    local prefabs =
    {
        "ash",
        name.."_unwrap",
    }

    if loot ~= nil then
        for i, v in ipairs(loot) do
            table.insert(prefabs, v)
        end
    end

    local function OnWrapped(inst, num, doer)
        local suffix =
            (onesize and "_onesize") or
            (num > 3 and "_large") or
            (num > 1 and "_medium") or
            "_small"
        if not onesize then
			inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..suffix..".xml"			
            inst.components.inventoryitem:ChangeImageName(name..suffix)
        end

        inst.AnimState:PlayAnimation("idle"..suffix) --emmm

        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
        end
    end

    local function OnUnwrapped(inst, pos, doer)
        if inst.burnt then
            SpawnPrefab("ash").Transform:SetPosition(pos:Get())
        else
            local loottable = (setupdata ~= nil and setupdata.lootfn ~= nil) and setupdata.lootfn(inst, doer) or loot
            if loottable ~= nil then
                local moisture = inst.components.inventoryitem:GetMoisture()
                local iswet = inst.components.inventoryitem:IsWet()
                for i, v in ipairs(loottable) do
                    local item = SpawnPrefab(v)
                    if item ~= nil then
                        if item.Physics ~= nil then
                            item.Physics:Teleport(pos:Get())
                        else
                            item.Transform:SetPosition(pos:Get())
                        end
                        if item.components.inventoryitem ~= nil then
                            item.components.inventoryitem:InheritMoisture(moisture, iswet)
                            if tossloot then
                                item.components.inventoryitem:OnDropped(true, .5)
                            end
                        end
                    end
                end
            end
            SpawnPrefab(name.."_unwrap").Transform:SetPosition(pos:Get())--拆的特效
        end
        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
        end
        inst:Remove()
    end

    local OnSave = variations ~= nil and function(inst, data)
        data.variation = inst.variation
    end or nil

    local OnPreLoad = variations ~= nil and function(inst, data)
        if data ~= nil then
            inst.variation = data.variation
        end
    end or nil

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("bundle")
        inst.AnimState:SetBuild(build or name)
        inst.AnimState:PlayAnimation(
            variations ~= nil and
            (onesize and "idle_onesize1" or "idle_large1") or
            (onesize and "idle_onesize" or "idle_large")
        )

        inst:AddTag("bundle")

        --unwrappable (from unwrappable component) added to pristine state for optimization
        inst:AddTag("unwrappable")

        if setupdata ~= nil and setupdata.common_postinit ~= nil then
            setupdata.common_postinit(inst, setupdata)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetSinks(true)
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
        
        if inventoryimage then
            inst.components.inventoryitem:ChangeImageName(inventoryimage)
        end

        if variations ~= nil or not onesize then
			inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..(variations == nil and "_large" or (onesize and "1" or "_large1"))..".xml"
            inst.components.inventoryitem:ChangeImageName(
                name..
                (variations == nil and "_large" or (onesize and "1" or "_large1"))
            )
        end

        inst:AddComponent("unwrappable")
        inst.components.unwrappable:SetOnWrappedFn(OnWrapped)
        inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)

        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
        inst.components.propagator.flashpoint = 10 + math.random() * 5
        inst.components.burnable:SetOnBurntFn(onburnt)
        inst.components.burnable:SetOnIgniteFn(onignite)
        inst.components.burnable:SetOnExtinguishFn(onextinguish)

        MakeHauntableLaunchAndIgnite(inst)

        if setupdata ~= nil and setupdata.master_postinit ~= nil then
            setupdata.master_postinit(inst, setupdata)
        end

        inst.OnSave = OnSave
        inst.OnPreLoad = OnPreLoad

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function fx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("bundle")
    inst.AnimState:SetBuild("myth_bundle")
    inst.AnimState:PlayAnimation("unwrap")

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    return inst
end

return	Prefab("myth_bundle_unwrap",fx),
    MakeBundle("myth_bundle", false, nil, { "myth_banana_leaf" }),
	MakeWrap("myth_bundle", "bundle_container", nil, false)
