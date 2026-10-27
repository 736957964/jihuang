local assets =
{
	Asset("ANIM", "anim/mk_items.zip"),
	Asset("ATLAS", "images/inventoryimages/mk_hualing.xml"),
	Asset("ATLAS", "images/inventoryimages/mk_longpi.xml"),
	Asset("ATLAS", "images/inventoryimages/mk_huoyuan.xml"),
}

local function items(name,stackable)

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
	
		MakeInventoryPhysics(inst)

		inst.AnimState:SetRayTestOnBB(true)
		inst.AnimState:SetBank("mk_items")
		inst.AnimState:SetBuild("mk_items")
		inst.AnimState:PlayAnimation(name)
		if name == "mk_huoyuan" then
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end
		
		if not stackable then
			inst:AddTag("waterproofer")
		end
		
		MakeInventoryFloatable(inst)
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("tradable")

		if stackable then
			inst:AddComponent("stackable")
			inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		else
			inst:AddComponent("waterproofer")
			inst.components.waterproofer:SetEffectiveness(0)
		end

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

		MakeHauntableLaunch(inst)

		return inst
	end

	return Prefab(name, fn, assets)
end

return  items("mk_hualing", true),
		items("mk_longpi", true),
		items("mk_huoyuan",false)