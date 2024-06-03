
local function oniceeat(inst,eater)
    if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
        not (eater.components.health ~= nil and eater.components.health:IsDead()) and
        not eater:HasTag("playerghost") then
		eater.components.debuffable:AddDebuff("myth_mooncake_icebuff", "myth_mooncake_icebuff")
    end
end

local function onnutseat(inst,eater)
    if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
        not (eater.components.health ~= nil and eater.components.health:IsDead()) and
        not eater:HasTag("playerghost") then
		eater.components.debuffable:AddDebuff("myth_mooncake_nutsbuff", "myth_mooncake_nutsbuff")
    end
end
local function onlotusseat(inst,eater)
    if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
        not (eater.components.health ~= nil and eater.components.health:IsDead()) and
        not eater:HasTag("playerghost") then
		eater.components.debuffable:AddDebuff("myth_mooncake_lotusbuff", "myth_mooncake_lotusbuff")
    end
end


local function makecake(name,oneatenfn)
	
	local assets =
	{
		Asset("ANIM", "anim/"..name..".zip"),
		Asset("ATLAS", "images/inventoryimages/"..name..".xml")
	}

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle")

		inst:AddTag("preparedfood")
		inst:AddTag("myth_mooncake")
		
		inst.Transform:SetScale(0.8, 0.8, 0.8)
		
		MakeInventoryFloatable(inst)
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("edible")
		inst.components.edible.foodtype = FOODTYPE.GOODIES
		inst.components.edible.hungervalue = 15
		inst.components.edible.healthvalue = 15
		inst.components.edible.sanityvalue = 15
		inst.components.edible:SetOnEatenFn(oneatenfn)
		
		inst:AddComponent("tradable")

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

		MakeHauntableLaunch(inst)

		return inst
	end
	return Prefab(name, fn, assets)
end
return  makecake("myth_mooncake_nuts",onnutseat),
		makecake("myth_mooncake_lotus",onlotusseat),
		makecake("myth_mooncake_ice",oniceeat)
