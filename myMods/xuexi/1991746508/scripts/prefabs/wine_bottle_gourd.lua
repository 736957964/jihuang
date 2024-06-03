local assets =
{
	Asset("ANIM", "anim/wine_bottle_gourd.zip"),
}

local prefabs =
{
	"peach_wine",
}

local function nofuel(inst)

end

local function check(inst)
	if  inst.components.fueled:GetPercent() >= 1 then
		inst.components.fueled.accepting = false
		inst:AddTag("canusegourd")
	else
		inst.components.fueled.accepting = true
		if inst.components.fueled:GetPercent() <= 0 then
			inst:RemoveTag("canusegourd")
		else
			inst:AddTag("canusegourd")
		end
	end
end

local function onuse(inst,user)
	inst.components.fueled:DoDelta(-20)
	if user.components.hunger then
		user.components.hunger:DoDelta(12.5)
	end
	if user.components.health then
		user.components.health:DoDelta(3)
	end
	if user.components.sanity then
		user.components.sanity:DoDelta(50)
	end
end
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    anim:SetBank("wine_bottle_gourd")
    anim:SetBuild("wine_bottle_gourd")
    anim:PlayAnimation("idle")
	
	MakeInventoryFloatable(inst)
	
	inst.MYTH_USE_TYPE = "DRINK"
	inst.onusesgname = "mk_drink"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end 

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/monkey_king_item.xml"
	
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.GOURDWINE
    inst.components.fueled:InitializeFuelLevel(100)
    inst.components.fueled:SetDepletedFn(nofuel)
	inst:ListenForEvent("percentusedchange", check)
	inst:DoTaskInTime(0, check)
	
    inst:AddComponent("myth_use_inventory")
	inst.components.myth_use_inventory.canuse = true

	inst:AddComponent("use_gourd")
	inst.components.use_gourd:SetOnUseFn(onuse)
	
    inst:AddComponent("tradable")

    return inst
end

return Prefab( "wine_bottle_gourd", fn, assets,prefabs)
