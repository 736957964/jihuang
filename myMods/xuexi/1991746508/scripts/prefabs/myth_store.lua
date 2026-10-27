
local assets=
{
	Asset("ANIM", "anim/myth_store.zip"),
}


local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2)

    inst.AnimState:SetBank("myth_store")
    inst.AnimState:SetBuild("myth_store")
    inst.AnimState:PlayAnimation("idle",true)
    	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    return inst
end 
    
return Prefab( "myth_store", fn, assets, prefabs) 