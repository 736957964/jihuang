local assets =
{
	Asset("ANIM", "anim/myth_lotus_items.zip"),
	Asset("ATLAS", "images/inventoryimages/lotus_leaves.xml"),
	Asset("ATLAS", "images/inventoryimages/lotus_root.xml"),
	Asset("ATLAS", "images/inventoryimages/lotus_root_cooked.xml"),
	Asset("ATLAS", "images/inventoryimages/lotus_seeds.xml"),
	Asset("ATLAS", "images/inventoryimages/lotus_seeds_cooked.xml"),
	Asset("ATLAS", "images/inventoryimages/myth_lotus_flower.xml"),
}

local hehua = {
    "lotus_seeds",
    "petals",
}

local function onunwrapped(inst, pos, doer)
    for _,v in ipairs(hehua) do
        local item = SpawnPrefab(v)
        if item ~= nil and item:IsValid() then
            if item.Physics ~= nil then
                item.Physics:Teleport(pos:Get())
            else
                item.Transform:SetPosition(pos:Get())
            end
            if item.components.inventoryitem ~= nil then
                item.components.inventoryitem:OnDropped(true, .5)
            end
        end
    end
    if doer ~= nil and doer.SoundEmitter ~= nil then
        doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
    end
    inst.components.stackable:Get():Remove()
end

local function common_fn(name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_lotus_items")
    inst.AnimState:SetBuild("myth_lotus_items")
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

local function leaves()
    local inst = common_fn("lotus_leaves")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst.components.inventoryitem.atlasname = "images/inventoryimages/lotus_leaves.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)
    inst:AddTag("show_spoilage")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function flower()
    local inst = common_fn("myth_lotus_flower")

    inst.Transform:SetScale(0.8, 0.8, 0.8)
    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_lotus_flower.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst:AddTag("show_spoilage")

    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.LOTUS_FLOWER
    inst.components.fuel.fuelvalue = 10

    inst:AddComponent("unwrappable")
    inst.components.unwrappable.onunwrappedfn = onunwrapped

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function root()
    local inst = common_fn("lotus_root")

    inst.Transform:SetScale(0.8, 0.8, 0.8)

	inst:AddTag("cookable")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/lotus_root.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddTag("show_spoilage")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 8
    inst.components.edible.hungervalue = 25
    inst.components.edible.sanityvalue = 0   
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
	local old_GetSanity = inst.components.edible.GetSanity
	
	inst.components.edible.GetSanity = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetSanity(self,eater)
	end
	local old_GetHunger = inst.components.edible.GetHunger
	
	inst.components.edible.GetHunger = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHunger(self,eater)
	end

	local old_GetHealth = inst.components.edible.GetHealth
	
	inst.components.edible.GetHealth = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHealth(self,eater)
	end


    inst:AddComponent("cookable")
    inst.components.cookable.product = "lotus_root_cooked"

	MakeHauntableLaunch(inst)
    return inst
end

local function root_cooked()
    local inst = common_fn("lotus_root_cooked")

    inst.Transform:SetScale(0.8, 0.8, 0.8)
    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/lotus_root_cooked.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddTag("show_spoilage")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 20
    inst.components.edible.hungervalue = 25
    inst.components.edible.sanityvalue = 15   
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
	local old_GetSanity = inst.components.edible.GetSanity
	
	inst.components.edible.GetSanity = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetSanity(self,eater)
	end
	local old_GetHunger = inst.components.edible.GetHunger
	
	inst.components.edible.GetHunger = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHunger(self,eater)
	end

	local old_GetHealth = inst.components.edible.GetHealth
	
	inst.components.edible.GetHealth = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHealth(self,eater)
	end

	MakeHauntableLaunch(inst)
    return inst
end


local function seeds()
    local inst = common_fn("lotus_seeds")

    inst.Transform:SetScale(0.9, 0.9, 0.9)
	inst:AddTag("cookable")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/lotus_seeds.xml"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddTag("show_spoilage")

    inst:AddComponent("lotusplant")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2
    inst.components.edible.foodtype = FOODTYPE.SEEDS
	local old_GetSanity = inst.components.edible.GetSanity
	
	inst.components.edible.GetSanity = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetSanity(self,eater)
	end
	local old_GetHunger = inst.components.edible.GetHunger
	
	inst.components.edible.GetHunger = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHunger(self,eater)
	end

	local old_GetHealth = inst.components.edible.GetHealth
	
	inst.components.edible.GetHealth = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHealth(self,eater)
	end
	inst:AddComponent("cookable")
	inst.components.cookable.product = "lotus_seeds_cooked"

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    return inst
end


local function seeds_cooked()
    local inst = common_fn("lotus_seeds_cooked")

    inst.Transform:SetScale(0.9, 0.9, 0.9)
    if not TheWorld.ismastersim then
        return inst
    end

	inst.components.inventoryitem.atlasname = "images/inventoryimages/lotus_seeds_cooked.xml"

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddTag("show_spoilage")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY / 2
    inst.components.edible.foodtype = FOODTYPE.SEEDS
	local old_GetSanity = inst.components.edible.GetSanity
	
	inst.components.edible.GetSanity = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetSanity(self,eater)
	end
	local old_GetHunger = inst.components.edible.GetHunger
	
	inst.components.edible.GetHunger = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHunger(self,eater)
	end

	local old_GetHealth = inst.components.edible.GetHealth
	
	inst.components.edible.GetHealth = function(self,eater)
		if  eater and eater:HasTag("neza") then
			return 0
		end
		return old_GetHealth(self,eater)
	end

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return 
       Prefab( "myth_lotus_flower", flower,assets) ,
	   Prefab( "lotus_root", root) ,
	   Prefab( "lotus_root_cooked", root_cooked) ,
	   Prefab( "lotus_seeds", seeds) ,
	   Prefab( "lotus_seeds_cooked", seeds_cooked) 
