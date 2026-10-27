local assets = {
    Asset("ANIM", "anim/myth_siving.zip"),
	Asset("ATLAS", "images/inventoryimages/siving_stone.xml"),
	Asset("ATLAS", "images/inventoryimages/siving_rocks.xml"),
}

local function sivingitem(name,bigger)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("myth_siving")
        inst.AnimState:SetBuild("myth_siving")
        inst.AnimState:PlayAnimation(name)

        if bigger then
            inst.Transform:SetScale(1.3, 1.3, 1.3)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("tradable")

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = bigger and TUNING.STACK_SIZE_LARGEITEM or TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetSinks(true)
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        return inst
    end
    return Prefab(name, fn, assets)
end

return sivingitem("siving_rocks"),sivingitem("siving_stone",true)
