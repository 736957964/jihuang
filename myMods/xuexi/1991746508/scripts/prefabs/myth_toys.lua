
local function buildgem(name)

	local assets =
	{
		Asset("ANIM", "anim/myth_toys.zip"),
		Asset( "IMAGE", "images/inventoryimages/"..name..".tex" ),
		Asset( "ATLAS", "images/inventoryimages/"..name..".xml" ),
	}

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("myth_toys")
        inst.AnimState:SetBuild("myth_toys")
        inst.AnimState:PlayAnimation(name)
        inst.Transform:SetScale(1.5, 1.5, 1.5)

        MakeInventoryFloatable(inst)
        inst:AddTag("myth_toys")
        inst:AddTag("myth_nianweidu")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 0.1
        inst.components.tradable.tradefor = {"myth_coin","myth_coin"}

		inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
        return inst
    end
    return Prefab(name, fn, assets)
end

local t = {}
local toys = {"myth_toy_featherbundle","myth_toy_tigerdoll","myth_toy_tumbler","myth_toy_twirldrum","myth_toy_chineseknot"}
for _,v in ipairs(toys) do
	table.insert(t, buildgem(v))
end
return unpack(t)
