
local function shine(inst)
    if not inst.AnimState:IsCurrentAnimation("sparkle") then
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:PushAnimation("idle", false)
    end
    inst:DoTaskInTime(4 + math.random() * 5, shine)
end

local function onuse(inst,doer)
	if doer and doer.components.inventory and doer.components.inventory:Has(inst.prefab,40) and doer.components.inventory:Has("rope",1) then
		doer.components.inventory:ConsumeByName(inst.prefab, 40)
		doer.components.inventory:ConsumeByName("rope", 1)
		local new = SpawnPrefab("myth_coin_box")
		doer.components.inventory:GiveItem(new,nil,doer:GetPosition())
		doer.SoundEmitter:PlaySound("myth_icon_sound/myth_icon_sound/sound")
		return true
	elseif doer and doer.components.talker then
		doer:DoTaskInTime(0,function()
			doer.components.talker:Say(STRINGS.MYTH_NOENOUGHCOIN)
		end)
	end
end

local function MakeGem(name)

	local assets =
	{
		Asset("ANIM", "anim/myth_coin.zip"),
		Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
		Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
	}
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		
        inst.AnimState:SetBank("myth_coin")
        inst.AnimState:SetBuild("myth_coin")

        inst.AnimState:PlayAnimation("idle")
		
		inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		
		inst.MYTH_USE_TYPE = "COIN"
		inst.onusesgname = "dolongaction"

		inst:AddTag("molebait")
		inst:AddTag("quakedebris")
		inst:AddTag("myth_coin")
		
        MakeInventoryFloatable(inst)
		
		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem:SetSinks(true)
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("tradable")
		
		inst:AddComponent("bait")
		
		
		inst:AddComponent("myth_use_inventory")
		inst.components.myth_use_inventory.canuse = true
		inst.components.myth_use_inventory:SetOnUseFn(onuse)

		shine(inst)
		
		return inst
	end

	return Prefab(name, fn, assets)
	
end

return MakeGem("myth_coin")