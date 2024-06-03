

local function cassockonequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_body", "cassock", "swap_body")  
    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, 0.8)
    end
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function cassockonunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function kamcassockonequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_body", "kam_Lan_cassock", "swap_body")  
    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, 0.5)
    end
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function kamcassockonunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function goldenonequip(inst, owner)

		owner.AnimState:OverrideSymbol("swap_body", "golden_armor_mk", "swap_body")  
		owner.AnimState:OverrideSymbol("swap_body_tall", "mk_golden_armor", "swap_body_tall")  

		if owner.components.combat ~= nil then
			owner.components.combat.externaldamagemultipliers:SetModifier("golden_armor_mk", 1.15) 
		end
end

local function goldenonunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	owner.AnimState:ClearOverrideSymbol("swap_body_tall")
	if owner.components.combat ~= nil then
		owner.components.combat.externaldamagemultipliers:RemoveModifier("golden_armor_mk")
	end	
end

local function onpercent(inst,data)
	local percent =  data and data.percent or inst.components.armor.condition
	if percent <= 0 then 
		inst.components.armor.absorb_percent = 0 
		inst:RemoveTag('myth_nostunned')
	else
		inst.components.armor.absorb_percent = 0.85 
		inst:AddTag('myth_nostunned')
	end
end

local function cassockfn(inst)
		inst.components.equippable:SetOnEquip(cassockonequip)
		inst.components.equippable:SetOnUnequip(cassockonunequip)
		inst.components.equippable.dapperness = 6/60
end
local function kamcassockfn(inst)
		inst.components.equippable:SetOnEquip(kamcassockonequip)
		inst.components.equippable:SetOnUnequip(kamcassockonunequip)
		inst.components.equippable.dapperness = 9/60
end
local function goldenfn(inst)
		inst.components.equippable:SetOnEquip(goldenonequip)
		inst.components.equippable:SetOnUnequip(goldenonunequip)
		inst.components.equippable.restrictedtag = "monkey_king"
		inst:AddComponent("armor")
		inst.components.armor:InitCondition(4000, 0.85)
		inst.components.armor.SetCondition =  function(self,amount)	
			if self.indestructible then
				return
			end
			self.condition = math.max(math.min(amount, self.maxcondition),0)
			self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
		end		
		inst:ListenForEvent("percentusedchange", onpercent)
		onpercent(inst)	
end

local function armor(name,masterfn,biu)
	local assets =
	{
		Asset("ANIM", "anim/"..name..".zip"),
	}

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("anim")
		if biu then
			inst:AddTag("shadowdominance")
		end

		MakeInventoryFloatable(inst, "small", 0.2, 0.80)
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("tradable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/monkey_king_item.xml"

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.AUTOSAVE_INTERVAL* 8)
        inst.components.fueled:SetDepletedFn(inst.Remove)
		
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.BODY
		
		masterfn(inst)

		MakeHauntableLaunch(inst)

		return inst
	end

	return Prefab(name, fn, assets)

end

return armor("cassock",cassockfn),
		armor("kam_lan_cassock",kamcassockfn,true)