local assets=
{
    Asset("ANIM", "anim/rosebow.zip"),
    Asset("ANIM", "anim/swap_rosebow.zip"),
 
    Asset("ATLAS", "images/inventoryimages/rosebow.xml"),
    Asset("IMAGE", "images/inventoryimages/rosebow.tex"),
}

local function onattack_rosebow(inst, attacker, target)
    if attacker and attacker.components.health and attacker.components.hunger then
        attacker.components.health:DoDelta(-0)
		attacker.components.hunger:DoDelta(-0)
    end
end

local function OnGetItemFromPlayer(inst, owner, item)
    if item.prefab == "greengem" then
	    inst.level = inst.level + 1
	    inst.components.weapon:SetDamage(55+inst.level)
		owner.components.talker:Say("小容儿的玫瑰弓\n伤害 : "..(55+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",8+inst.level2 * 0.4)).."-"..(string.format("%.1f",10+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
	end
    if item.prefab == "purplegem" and inst.level2 < 30 then
		if math.random() <= -0.45*inst.level2/29+0.5 then
	        inst.level2 = inst.level2 + 1
	        inst.components.weapon:SetRange(8 + inst.level2 * 0.4, 10 + inst.level2 * 0.4)
		    owner.components.talker:Say("小容儿的玫瑰弓\n伤害 : "..(55+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",8+inst.level2 * 0.4)).."-"..(string.format("%.1f",10+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
	    else
			owner.components.talker:Say("强化失败,强化到下一级成功率为"..(string.format("%.1f",-45*inst.level2/29+50)))
	    end
	end
	if item.prefab == "orangegem" and inst.level3 < 30 then
		if math.random() <= -0.45*inst.level3/29+0.5 then
	        inst.level3 = inst.level3 + 1
            inst.components.equippable.walkspeedmult = 1 + inst.level3 * 0.01
		    owner.components.talker:Say("小容儿的玫瑰弓\n伤害 : "..(55+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",8+inst.level2 * 0.4)).."-"..(string.format("%.1f",10+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
		else
			owner.components.talker:Say("强化失败,强化到下一级成功率为"..(string.format("%.1f",-45*inst.level3/29+50)))
		end
	end
end

local function AcceptTest(inst, item)
    if item.prefab == "purplegem" and inst.level2 == 30 then
	    return false
	elseif item.prefab == "orangegem" and inst.level3 == 30 then
        return false
	else
        return item.prefab == "greengem" or item.prefab == "purplegem" or item.prefab == "orangegem" or item.prefab == "flint"
	end
end

local function OnRefuseItem(inst, giver, item)
    if item.prefab == "purplegem" then
	    giver.components.talker:Say("射程已强化到顶级")
	elseif item.prefab == "orangegem" then
	    giver.components.talker:Say("移速已强化到顶级")
    else
	    giver.components.talker:Say("小容儿的玫瑰弓\n伤害 : "..(55+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",8+inst.level2 * 0.4)).."-"..(string.format("%.1f",10+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
	end
end

local function onpreload(inst, data)
	if data and data.level and data.level2 and data.level3 and data.level4 then
		inst.level = data.level
		inst.level2 = data.level2
		inst.level3 = data.level3
		inst.level4 = data.level4
        inst.components.weapon:SetDamage(55+inst.level)
	    inst.components.equippable.walkspeedmult = 1 + inst.level2 * 0.01
		inst.components.weapon:SetRange(8 + inst.level3 * 0.4, 10 + inst.level3 * 0.4)
	end
end

local function onsave(inst, data)
	data.level = inst.level
	data.level2 = inst.level2
	data.level3 = inst.level3
	data.level4 = inst.level4
end

local function fn()
	local inst = CreateEntity()
	inst.level  = 0
	inst.level2 = 0
	inst.level3 = 0
	inst.level4 = 0
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("rosebow")
    inst.AnimState:SetBuild("rosebow")
    inst.AnimState:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
        return inst
    end
 
    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_rosebow", "swap_rosebow")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end
 
    local function OnUnequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
 
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "rosebow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/rosebow.xml"
     
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.inventoryitem.keepondeath = true
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	if not inst.components.named then inst:AddComponent("named") end
	inst.components.named:SetName("小容儿的玫瑰弓\n紫宝石射程\n橙宝石移速\n绿宝石伤害\n小桥溪流漾涟漪\n爱如春风柔情意")
		
	inst:AddTag("shadow")
 	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack_rosebow)
    inst.components.weapon:SetDamage(55)
    inst.components.weapon:SetRange(8, 10)
	inst.components.weapon:SetProjectile("madoka_projectile")

    return inst
	
end
	
return  Prefab("common/inventory/rosebow", fn, assets)