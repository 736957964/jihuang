local assets =
{
    Asset("ANIM", "anim/myth_store_construction.zip"),
}

local prefabs =
{

}

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
     
	MakeObstaclePhysics(inst, 2)
	
    inst.AnimState:SetBank("myth_store_construction")
    inst.AnimState:SetBuild("myth_store_construction")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(0.75, 0.75, 0.75)   --动画体积系数
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
    return inst
end

return Prefab("myth_store_construction", fn, assets, prefabs)
