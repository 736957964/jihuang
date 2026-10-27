
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    --inst.Transform:SetEightFaced()
	
    inst:AddTag("blocker")
    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetCollisionGroup(COLLISION.WORLD)
    phys:ClearCollisionMask()
	for k,v in pairs(COLLISION) do
		if k ~= "SANITY"  then
			phys:CollidesWith(v)
		end
	end
    phys:SetCapsule(0.5, 2)
		
    inst.Physics:SetDontRemoveOnSleep(true)

    inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("birdblocker")
	inst:AddTag("wall")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
		
    return inst
end

return Prefab("myth_wall", fn)