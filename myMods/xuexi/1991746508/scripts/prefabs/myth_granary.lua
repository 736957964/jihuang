
local assets =
{
    Asset("ANIM", "anim/ui_myth_granary_4x4.zip"),	
}

local prefabs =
{
    "collapse_small",
}

local shows = {"corn","garlic","pepper",}
local function showornot(inst)
	for _, v in ipairs(shows) do 
		if inst.components.container:Has(v, 1) then 
			inst.AnimState:ShowSymbol(v)
		else
			inst.AnimState:HideSymbol(v)
		end
	end
end

local function onopen(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
	showornot(inst)
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.components.container:DropEverything()
    inst.components.container:Close()
end

local function onbuilt(inst)
	inst:Hide()
	inst:DoTaskInTime(0,function()
		local x,y,z = inst.Transform:GetWorldPosition()
		x, y, z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
		inst.Transform:SetPosition(x,0, z)
		inst:Show()
	end)
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
	local x,y,z = inst.Transform:GetWorldPosition()
	for k = 1 ,6 do
		SpawnPrefab("ash").Transform:SetPosition(x+math.random()*2*( math.random() < 0.5 and 1 or -1),0,z+math.random()*2*( math.random() < 0.5 and 1 or -1))
	end
    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState() 
    inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("myth_granary.tex")
	
    inst:AddTag("structure")
	inst:AddTag("wildfirepriority")

	MakeObstaclePhysics(inst, 1.5)
	
    inst.AnimState:SetBank("myth_granary") 
    inst.AnimState:SetBuild("myth_granary")
    inst.AnimState:PlayAnimation("idle")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("myth_granary")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable") 
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0.1)
	
    AddHauntableDropItemOrWork(inst)
	
    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeSnowCovered(inst)
	
	inst:DoTaskInTime(0,showornot)
    return inst
end

local function placerfn(inst)
    inst.components.placer.snap_to_tile = true
    inst.AnimState:HideSymbol("snow")
	inst.outline = SpawnPrefab("tile_outline")
	inst.outline.entity:SetParent(inst.entity)

	inst.components.placer:LinkEntity(inst.outline)
end
return Prefab("myth_granary", fn, assets, prefabs),
	MakePlacer("myth_granary_placer", "myth_granary", "myth_granary", "idle",nil,nil,nil,nil,nil,nil,placerfn)