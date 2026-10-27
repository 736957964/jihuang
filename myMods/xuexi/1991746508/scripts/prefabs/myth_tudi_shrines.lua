require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/myth_tudi_shrines.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.inventory:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    TheWorld:PushEvent("myth_tudi_shrines_remove",inst)
    inst:Remove()
end

local function onremove(inst)
    if inst.tudi ~= nil and  inst.tudi:IsValid() then
        inst.tudi.sg:GoToState("gohome")
    end
    if TheWorld.tudimiao ~= nil and  TheWorld.tudimiao == inst then
        TheWorld.net.myth_tudimiao:set(false)
    end
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("build")
    inst.AnimState:PushAnimation("idle", false)
    --inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end

local function ShouldAcceptItem(inst, item,giver)
    return inst.components.tudi_shrines_trader:Test(item,giver)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.components.tudi_shrines_trader then
        inst.components.tudi_shrines_trader:GetItem(item,giver)
    end
end

local function onspawn(inst)
    if inst.tudi ~= nil and  inst.tudi:IsValid() then return end
    if inst.components.tudi_shrines_trader:IsFull() then
        local tudi = SpawnPrefab("myth_tudi")
        if tudi then
            local x,y,z =  inst.Transform:GetWorldPosition()
            local pos = Vector3(x,y,z)
            local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 4, 10)
            if offset ~= nil then
                x = x + offset.x
                z = z + offset.z
            end           
            tudi.Transform:SetPosition(inst.Transform:GetWorldPosition())
            tudi:SpawnChild("maxwell_smoke")
            tudi:SetMiao(inst)
        end
    end
end

local function trytospwan(inst)
    if not TheWorld.state.isnight  and  not inst.tudi then
        onspawn(inst)
    end
end

local function ontudiremove(inst)
    if not TheWorld.state.isnight  and  inst.components.tudi_shrines_trader:IsFull() then
        if inst._tuditask ~= nil then
            inst._tuditask:Cancel()
        end
        inst._tuditask = inst:DoTaskInTime(15,trytospwan)
    end
end

local function Update(inst)
    if not TheWorld.state.isnight and inst._tuditask ~= nil then
        inst._tuditask:Cancel()
        inst._tuditask = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    MakeObstaclePhysics(inst, 1.5)

    inst.MiniMapEntity:SetIcon("myth_tudi_shrines.tex")

    inst:AddTag("structure")

    inst.AnimState:SetBank("myth_tudi_shrines")
    inst.AnimState:SetBuild("myth_tudi_shrines")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")


    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:AddComponent("tudi_shrines_trader") 

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.deleteitemonaccept = false 

    inst:AddComponent("inventory")

    inst:ListenForEvent("onbuilt", onbuilt)
    inst:ListenForEvent("onremove", onremove)

    --inst:WatchWorldState("startday", onspawn)
    inst:WatchWorldState("cycles", onspawn)

    inst:WatchWorldState("phase", Update)

    MakeSnowCovered(inst)

    AddHauntableDropItemOrWork(inst)

    inst:DoTaskInTime(0.1,function(...)
        if TheWorld.net and not TheWorld.net.myth_tudimiao:value() then
            TheWorld.net.myth_tudimiao:set(true)
            TheWorld.tudimiao  = inst
            trytospwan(inst)
        elseif inst.components.workable and inst.persists then
            inst.components.workable:Destroy(inst)
        end
    end)
    inst.WantToSpawn = trytospwan

    inst.OnTudIRemove = ontudiremove
    return inst
end

local function placefn(inst)
    inst.AnimState:HideSymbol("food_1")
    inst.AnimState:HideSymbol("food_2")
    inst.AnimState:HideSymbol("food_3")
    inst.AnimState:HideSymbol("thurible")
    inst.AnimState:HideSymbol("middle")
    inst.AnimState:HideSymbol("tall")
    inst.AnimState:HideSymbol("snow")
end

return Prefab("myth_tudi_shrines", fn, assets, prefabs),
    MakePlacer("myth_tudi_shrines_placer", "myth_tudi_shrines", "myth_tudi_shrines", "idle",nil,nil,nil,nil,nil,nil,placefn)
