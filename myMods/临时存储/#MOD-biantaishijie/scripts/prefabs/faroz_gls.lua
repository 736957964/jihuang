local assets=
{
	Asset("ANIM", "anim/faroz_gls.zip"),
	Asset("ATLAS", "images/inventoryimages/faroz_gls.xml")
}

local function saniup(inst)
	if inst.isWeared and not inst.isDropped then
		--inst:AddComponent("dapperness")
		inst.components.equippable.dapperness = inst.level*0.5+0.5
	end
end

local function onequip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_hat", "faroz_gls", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
		inst.isWeared = true
		inst.isDropped = false
		saniup(inst)
end

local function onunequip(inst, owner) 
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
		inst.isWeared = false
		inst.isDropped = false
		saniup(inst)
end

local function ondrop(inst)
	inst.isDropped = true
	inst.isWeared = false
	saniup(inst)
end

local function OnGetItemFromPlayer(inst, owner, item)
	if item.prefab == "greengem" and inst.level < 99 then
	    inst.level = inst.level + 1
		saniup(inst)
		owner.components.talker:Say("眼镜\n脑残回复 ："..(inst.level*0.1+0.5).."/秒")
	end

end

local function AcceptTest(inst, item)
	return item.prefab == "greengem" and inst.level < 99
end

local function OnRefuseItem(inst, giver, item)
	if item.prefab == "greengem" then
	    giver.components.talker:Say("已强化到顶级")
	else
	    giver.components.talker:Say("眼镜\n脑残回复 ："..(inst.level*0.1+0.5).."/秒")
	end

end

local function onpreload(inst, data)
	if data and data.level then
		inst.level  = data.level
	end
end

local function onsave(inst, data)
	data.level  = inst.level
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.level = 0
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    
    inst:AddTag("hat")
    
	inst.isWeared = false
	inst.isDropped = false
	
    anim:SetBank("beehat")
    anim:SetBuild("faroz_gls")
    anim:PlayAnimation("anim")    
        
    inst:AddComponent("inspectable")
	if not inst.components.named then inst:AddComponent("named") end
	inst.components.named:SetName("隐形眼镜\n你的泪光柔弱中带伤\n惨白的月弯弯勾住过往\n夜太漫长凝结成了霜\n谁在阁楼上冰冷的绝望")
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    
    if glassesdrop == 1 then 
	---inst:AddTag("irreplaceable")
	end 
	
	if not TheWorld.ismastersim then return inst end
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/faroz_gls.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	inst.components.inventoryitem:SetOnDroppedFn( ondrop )
	
	inst:ListenForEvent("phasechanged", function() saniup(inst) end, TheWorld)
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
    return inst
end

return Prefab( "common/inventory/faroz_gls", fn, assets) 
