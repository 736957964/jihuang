local assets=
{
    Asset("ANIM", "anim/laozi.zip"),
	Asset("ATLAS", "images/inventoryimages/laozi_sp.xml")
}

local function Spawn(inst,taker)
	if TheWorld.components.laozitimer.canspawnya == false then
        inst:DoTaskInTime(0, inst.Remove)
        return
    else
        TheWorld.components.laozitimer.canspawnya = false
    end
    local pos = taker ~= nil and taker:GetPosition() or inst:GetPosition()
    local fx = SpawnPrefab('mk_cloudpuff')
    fx.Transform:SetScale(2.2,2.2,2.2)
    fx.Transform:SetPosition(pos:Get())
	fx:DoTaskInTime(1, function()
		local lz  = SpawnPrefab('laozi')
		lz.components.timer:StartTimer('despawn', 480)
		lz.Transform:SetPosition(pos:Get())
		TheWorld.components.laozitimer:OnSpawn()
	end)
	
    inst:DoTaskInTime(0, inst.Remove)
end
local function onuse(inst,target,doer)
    if target.components.container then
        target.components.container:DropEverything()
    end
    local items = {}
    table.insert(items,target)

    local new = SpawnPrefab("krampussack_sealed")
    new.components.unwrappable:WrapItems(items, doer)
    local x,y,z = target.Transform:GetWorldPosition()
    target:Remove()
    local fx = SpawnPrefab("collapse_small")
    new.Transform:SetPosition(x,y,z)
    fx.Transform:SetPosition(x,y,z)
    inst.components.stackable:Get():Remove()

end

local function needfn(inst,target,doer)
    return target.prefab == 'krampus_sack'
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddDynamicShadow()
	
    MakeInventoryPhysics(inst)
	inst.DynamicShadow:SetSize( 2, 0.5 )	
	
    inst.AnimState:SetBank("laozi_sp")
    inst.AnimState:SetBuild("laozi")
    inst.AnimState:PlayAnimation("idle", true)
	
	MakeInventoryFloatable(inst)

    inst.myth_useitem_needfn = needfn
    inst.MYTH_USEITEM_TYPE  = "LAOZIPACK"
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
    inst.components.fuel:SetOnTakenFn(Spawn)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("tradable")
    --inst:AddComponent("laozisp_pack")
    inst:AddComponent("myth_useitem")
    inst.components.myth_useitem.onuse = onuse

    inst.components.burnable.onburnt = Spawn
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/laozi_sp.xml"

    return inst
end

return Prefab( "laozi_sp", fn, assets) 
