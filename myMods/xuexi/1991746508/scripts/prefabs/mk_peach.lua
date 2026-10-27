
local function ondeploy(inst, pt, deployer)
    local sapling = SpawnPrefab("peachsprout_myth")
    sapling:StartGrowing()
    sapling.Transform:SetPosition(pt:Get())
    sapling.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")

    inst:Remove()
end

local function makefood(name,preparedfood,data)
	local assets =
	{
		Asset("ANIM", "anim/"..name..".zip"),
	}
	if name == "bigpeach" then
		table.insert(assets, Asset("ANIM", "anim/myth_peachtree.zip"))
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle")

		if preparedfood then
			inst:AddTag("preparedfood")
		end
		if name == "bigpeach" then
			inst:AddTag("deployedplant")
		end

		MakeInventoryFloatable(inst)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.foodtype = FOODTYPE.VEGGIE
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0

		inst:AddComponent("tradable")

		inst:AddComponent("inspectable")

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/monkey_king_item.xml"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(data.perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		if name == "peach" then
			inst:AddComponent("cookable")
			inst.components.cookable.product = name.."_cooked"

			MakeSmallBurnable(inst)
			MakeSmallPropagator(inst)
		elseif name == "bigpeach" then
			inst:AddComponent("cookable")
			inst.components.cookable.product = "peach_cooked"

			inst:AddComponent("deployable")
			inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
			inst.components.deployable.ondeploy = ondeploy
		end

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end
	return Prefab(name, fn, assets)
end
return  makefood("peach",false,{ health = 6, hunger = 10.5, sanity = 5 ,  perishtime = TUNING.UMBRELLA_PERISHTIME}),
	makefood("bigpeach",false,{health = 1024, hunger = 2048, sanity = 4096, perishtime = TUNING.WINTERHAT_PERISHTIME}),
	MakePlacer("bigpeach_placer", "myth_peachtree", "myth_peachtree", "lv1_idle"),
	makefood("peach_cooked",false,{ health = 3, hunger = 10.5, sanity = 0 ,  perishtime = TUNING.STRAWHAT_PERISHTIME })