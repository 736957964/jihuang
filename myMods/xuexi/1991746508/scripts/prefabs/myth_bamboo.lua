local assets =
{
	Asset("ANIM", "anim/myth_bamboo.zip"),
	Asset("ATLAS", "images/inventoryimages/myth_bamboo.xml"),
	Asset("ATLAS", "images/inventoryimages/myth_bamboo_shoots.xml"),
	Asset("ATLAS", "images/inventoryimages/myth_bamboo_shoots_cooked.xml"),
	Asset("ATLAS", "images/inventoryimages/myth_greenbamboo.xml"),
}

local function common_fn(name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_bamboo")
    inst.AnimState:SetBuild("myth_bamboo")
    inst.AnimState:PlayAnimation(name)  

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

	inst:AddComponent("stackable")
    return inst
end


local function bamboo()
    local inst = common_fn("myth_bamboo")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_bamboo.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function green()
    local inst = common_fn("myth_greenbamboo")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_greenbamboo.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function shoot()
    local inst = common_fn("myth_bamboo_shoots")

	inst:AddTag("cookable")
    inst:AddTag("deployedplant")
    inst:AddTag("show_spoilage")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_bamboo_shoots.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 8
    inst.components.edible.hungervalue = 12.5
    inst.components.edible.sanityvalue = 0   
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = function(inst, pt, deployer)
        local tree = SpawnPrefab("myth_plant_bamboo_0")
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()

            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end

            if tree.InitMyFamily ~= nil then
                tree:InitMyFamily()
            end
        end
    end
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)

    inst:AddComponent("cookable")
    inst.components.cookable.product = "myth_bamboo_shoots_cooked"

	MakeHauntableLaunch(inst)
    return inst
end

local function shoot_cooked()
    local inst = common_fn("myth_bamboo_shoots_cooked")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_bamboo_shoots_cooked.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddTag("show_spoilage")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 20
    inst.components.edible.hungervalue = 12.5
    inst.components.edible.sanityvalue = 5   
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
	local old_GetSanity = inst.components.edible.GetSanity

	MakeHauntableLaunch(inst)
    return inst
end

return
    Prefab("myth_bamboo", bamboo, assets),
    Prefab("myth_greenbamboo", green),
    Prefab("myth_bamboo_shoots", shoot),
    Prefab("myth_bamboo_shoots_cooked", shoot_cooked),
    MakePlacer("myth_bamboo_shoots_placer", "plant_bamboo_short", "myth_plant_bamboo", "short_0")
