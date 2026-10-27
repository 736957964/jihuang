local assets =
{
    Asset("ANIM", "anim/book_maxwell.zip"),
    Asset("ANIM", "anim/book_myth.zip"),
}

local lightassets =
{
    Asset("ANIM", "anim/myth_interiors_light.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("book_maxwell")
    inst.AnimState:SetBuild("book_myth")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(-1)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("read_fly_book")

	inst.persists = false
    return inst
end

local function deng()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("myth_interiors_light")
    inst.AnimState:SetBuild("myth_interiors_light")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(-1)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:DoTaskInTime(0,function(deng)
        local fx = SpawnPrefab("myth_dengfire")
        fx.entity:SetParent(deng.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(deng.GUID, "deng", -28, -55, 0)
        fx:AttachLightTo(deng)
	end)		
	inst.persists = false
    return inst
end

return Prefab("book_fly_myth", fn, assets),
	Prefab("myth_interiors_light", deng, lightassets)
