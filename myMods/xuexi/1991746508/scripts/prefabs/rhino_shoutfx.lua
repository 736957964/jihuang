local assets = {
    
}

--垃圾灵衣写的

local function shoutfxfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(0.4, 0.4, 0.4)

    inst:AddTag("FX")

    inst.AnimState:SetBank("bearger_ring_fx")
    inst.AnimState:SetBuild("bearger_ring_fx")
    inst.AnimState:PlayAnimation("idle",true)

    inst.AnimState:SetFinalOffset(1)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	
	return inst
end

return Prefab("rhino_shoutfx", shoutfxfn, assets)