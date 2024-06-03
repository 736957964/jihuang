local assets =
{
    Asset("ANIM", "anim/myth_redlantern_ground.zip"),
    Asset("ANIM", "anim/myth_redlantern_ground_right.zip"),	
	Asset("ATLAS", "images/inventoryimages/myth_redlantern_ground.xml"),
	Asset("ATLAS", "images/inventoryimages/myth_redlantern_ground_right.xml"),
}

local function droop(inst)
	if  inst.components.myth_redlantern_ground then
		local myth_redlantern_ground = inst.components.myth_redlantern_ground
		if myth_redlantern_ground.skin1 ~= nil then
			local item = inst.components.lootdropper:SpawnLootPrefab("myth_redlantern")
			TheSim:ReskinEntity( item.GUID, nil, myth_redlantern_ground.skin1)
		end
		if myth_redlantern_ground.skin2 ~= nil then
			local item = inst.components.lootdropper:SpawnLootPrefab("myth_redlantern")
			TheSim:ReskinEntity( item.GUID, nil, myth_redlantern_ground.skin2)
		end
	end
end
local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("myth_redlantern_ground")
    inst.AnimState:SetBuild("myth_redlantern_ground")
    inst.AnimState:PlayAnimation("idle")
	
    inst.Transform:SetTwoFaced()
    
    inst:AddTag("structure")
    inst.MYTH_USE_TYPE = "QUDENG"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("myth_redlantern_ground")

    inst:AddComponent("inspectable")

    inst:AddComponent("myth_use_inventory")
    
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 
	inst:ListenForEvent("onremove", droop)
    return inst
end

local function right()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("myth_redlantern_ground_right")
    inst.AnimState:SetBuild("myth_redlantern_ground_right")
    inst.AnimState:PlayAnimation("idle")
	
	--inst.Transform:SetEightFaced()
	
    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("myth_redlantern_ground")

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 
    return inst
end

return Prefab("myth_redlantern_ground", fn, assets),
	Prefab("myth_redlantern_ground_right", right, assets),
	MakePlacer("myth_redlantern_ground_right_placer", "myth_redlantern_ground_right", "myth_redlantern_ground_right", "idle"),
	MakePlacer("myth_redlantern_ground_placer", "myth_redlantern_ground", "myth_redlantern_ground", "idle")
