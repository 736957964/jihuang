require "prefabutil"

local assets =
{

}

local prefabs =
{
    "collapse_small",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onbuilt(inst)
	inst:Hide()
	inst:DoTaskInTime(0,function()
		local x,y,z = inst.Transform:GetWorldPosition()
		x, y, z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
		inst.Transform:SetPosition(x,0, z)
		inst:Show()
		inst.AnimState:PlayAnimation("fill")
		inst.AnimState:PushAnimation("idle_full")
	end)
end

local function OnCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 16, nil, { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }, { "smolder" })
    for i, v in pairs(ents) do
        if v.components.burnable ~= nil then
			if v.components.burnable:IsSmoldering() then
				v.components.burnable:SmotherSmolder()
			end
        end	
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("myth_well.tex")

	MakeObstaclePhysics(inst, 1.5)
	
    inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
	inst:AddTag("shelter")

    inst.AnimState:SetBank("myth_well")
    inst.AnimState:SetBuild("myth_well")
    inst.AnimState:PlayAnimation("idle_full",true)
	
	--inst:SetDeployExtraSpacing(2)

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

    inst:ListenForEvent("onbuilt", onbuilt)

	inst:AddComponent("watersource")

	inst.check = inst:DoPeriodicTask(1, OnCheck,1)
    return inst
end
local function placerfn(inst)
    inst.components.placer.snap_to_tile = true

	inst.outline = SpawnPrefab("tile_outline")
	inst.outline.entity:SetParent(inst.entity)

	inst.components.placer:LinkEntity(inst.outline)
end

return Prefab("myth_well", fn, assets, prefabs),
    MakePlacer("myth_well_placer", "myth_well", "myth_well", "idle_full",nil,nil,nil,nil,nil,nil,placerfn)
