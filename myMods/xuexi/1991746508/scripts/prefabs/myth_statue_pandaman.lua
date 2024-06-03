local assets =
{
    Asset("ANIM", "anim/myth_statue_pandaman.zip"),
}

local prefabs =
{

}

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
     
	MakeObstaclePhysics(inst, 1.25)
	
    inst.AnimState:SetBank("myth_statue_pandaman")
    inst.AnimState:SetBuild("myth_statue_pandaman")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

	
    return inst
end

return Prefab("myth_statue_pandaman", fn, assets, prefabs)
