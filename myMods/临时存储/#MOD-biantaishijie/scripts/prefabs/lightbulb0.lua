local assets =
{
    Asset("ANIM", "anim/bulb.zip"),
}

local function OnDropped(inst)
    inst.Light:Enable(true)
end

local function OnPickup(inst)
    inst.Light:Enable(false)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bulb")
    inst.AnimState:SetBuild("bulb")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(237/255, 237/255, 209/255)
    inst.Light:Enable(true)

    inst:AddTag("lightbattery")
    inst:AddTag("vasedecoration")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")
    inst:AddComponent("vasedecoration")
    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_LARGE_FUEL
    inst.components.fuel.fueltype = FUELTYPE.CAVE

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)    
    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("inventoryitem")
	
	
	local function OnDeploy (inst, pt)
    local golf = SpawnPrefab("lightbulb")
    golf.Transform:SetPosition(pt.x, pt.y, pt.z)
    golf.AnimState:SetBank("bulb")
    golf.AnimState:SetBuild("bulb")
    golf.AnimState:PlayAnimation("idle")
    golf.Transform:SetScale(0.8, 0.8, 0.8)
    golf.components.inventoryitem.canbepickedup = false
    MakeSmallBurnable(golf)
    golf:AddComponent("perishable")
    golf.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    golf.components.perishable:StartPerishing()
    golf.components.perishable.onperishreplacement = "ash"
	golf:AddComponent("named")
	golf.components.named:SetName("高尔夫球")
    golf:AddComponent("workable")
    golf.components.workable:SetWorkAction(ACTIONS.HAMMER)
    golf.components.workable:SetWorkLeft(10)
    golf.components.workable:SetOnFinishCallback(function(golf)
        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(golf.Transform:GetWorldPosition())
        golf:Remove()
    end )
    golf.components.workable:SetOnWorkCallback(function(golf)
        local pt2 = Vector3(golf.Transform:GetWorldPosition())
        local pos = Vector3(GetPlayer().Transform:GetWorldPosition())
        golf.Physics:SetMotorVelOverride((pt2.x-pos.x)*13,0,(pt2.z-pos.z)*13)
        golf:DoTaskInTime(0.2, function() golf.Physics:ClearMotorVelOverride() end )
    end )
    golf:DoPeriodicTask(.05, function(golf)
        local pos2 = Vector3(golf.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos2.x,pos2.y,pos2.z, 0.5)
        for k,v in pairs(ents) do
            if v.prefab == "rabbithole" then
               golf:Remove()
            end
        end
    end )
    golf:AddTag("golfs")
    inst.components.stackable:Get():Remove()
end
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
local function onsave(inst, data)
    if inst:HasTag("golfs") then
        data.golfs = true
    end
end
local function onload(inst, data)
  if data and data.golfs then
    inst.AnimState:SetBank("bulb")
    inst.AnimState:SetBuild("bulb")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(0.8, 0.8, 0.8)
    inst.components.inventoryitem.canbepickedup = false
    MakeSmallBurnable(inst)
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "ash"
	inst:AddComponent("named")
	inst.components.named:SetName("高尔夫球")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnFinishCallback(function(inst)
        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst:Remove()
    end )
    inst.components.workable:SetOnWorkCallback(function(inst)
        local pt2 = Vector3(inst.Transform:GetWorldPosition())
        local pos = Vector3(GetPlayer().Transform:GetWorldPosition())
        inst.Physics:SetMotorVelOverride((pt2.x-pos.x)*13,0,(pt2.z-pos.z)*13)
        inst:DoTaskInTime(0.2, function() inst.Physics:ClearMotorVelOverride() end )
    end )
    inst:DoPeriodicTask(.05, function(inst)
        local pos2 = Vector3(inst.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos2.x,pos2.y,pos2.z, 0.5)
        for k,v in pairs(ents) do
            if v.prefab == "rabbithole" then
               inst:Remove()
            end
        end
    end )
    inst:AddTag("golfs")
  end
end
    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPickupFn(OnPickup)

    return inst
end

return Prefab("lightbulb", fn, assets)