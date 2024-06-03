
local assets=
{
    Asset("ANIM", "anim/elpheltbazooka.zip"),
    Asset("ANIM", "anim/swap_elpheltbazooka.zip"),
 
    Asset("ATLAS", "images/inventoryimages/elpheltbazooka.xml"),
    Asset("IMAGE", "images/inventoryimages/elpheltbazooka.tex"),
}

local function onattack_elpheltbazooka(inst, attacker, target)
    if attacker and attacker.components.health and attacker.components.hunger then
        attacker.components.health:DoDelta(-0)
		attacker.components.hunger:DoDelta(-0)
    end
    local atkfx = SpawnPrefab("firesplash_fx")
	--local atkfxx = SpawnPrefab("collapse_big")
    if atkfx  then
	    local follower = atkfx.entity:AddFollower()
		--local follower = atkfxx.entity:AddFollower()
	    follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
		--follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
			for i, v in ipairs(AllPlayers) do
			v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, .3, inst, 40)
		end
    end
    if target and target.brain and target.elpheltbazookastun ~= true then
        target.elpheltbazookastun = true
		if inst.level4 < 200*52 then
		        if math.random() <= 0.48+inst.level4*0.01/200 then
                    target.brain:Stop()
			        inst.level4 = inst.level4 + 1
					if (inst.level4%200) ~= 0 then 
		                attacker.components.talker:Say("大炮\n熟练等级 ："..(math.ceil(inst.level4/200)).."\n震晕几率 ："..(48+inst.level4*1/200).."%".."\n眩晕时间 ："..(5+inst.level4*1/200).."秒".."\n熟练度 ："..(inst.level4).."\n升级还需熟练度 ："..(200*math.ceil(inst.level4/200)-inst.level4).."\n只有震晕非眩晕状态的目标才可获得熟练度")
					else
					    attacker.components.talker:Say("大炮\n熟练等级 ："..(math.ceil(inst.level4/200)).."\n震晕几率 ："..(48+inst.level4*1/200).."%".."\n眩晕时间 ："..(5+inst.level4*1/200).."秒".."\n熟练度 ："..(inst.level4).."\n升级还需熟练度 ：200\n只有震晕非眩晕状态的目标才可获得熟练度")
					end
		        end
                if target.components.locomotor then
		            if math.random() <= 0.48 + inst.level4*0.01/200 then
                        target.components.locomotor:Stop()
		            end
                end
                target:DoTaskInTime(5+inst.level4*1/200, function()
		            if target.brain then
                        target.brain:Start()
			            attacker.components.talker:Say("目标已摆脱眩晕状态,请小心！")
                        target.elpheltbazookastun = nil
			        end
                end)
		else
		    target.brain:Stop()
            if target.components.locomotor then
                target.components.locomotor:Stop()
            end
		    attacker.components.talker:Say("三十六大炮\n熟练等级 ："..(math.ceil(inst.level4/200)).."\n震晕几率 ："..(48+inst.level4*1/200).."%".."\n眩晕时间 ："..(5+inst.level4*1/200).."秒".."\n熟练度 ："..(inst.level4).."\n终极神器,打遍天下无敌手！")
			target:DoTaskInTime(57, function()
		        if target.brain then
                    target.brain:Start()
			        attacker.components.talker:Say("目标已摆脱眩晕状态,请小心！")
                    target.elpheltbazookastun = nil
			    end
            end)
		end
    end
end

local function OnGetItemFromPlayer(inst, owner, item)
    if item.prefab == "greengem" then
	    inst.level = inst.level + 1
	    inst.components.weapon:SetDamage(200+inst.level)
		owner.components.talker:Say("大炮\n伤害 : "..(200+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",10+inst.level2 * 0.4)).."-"..(string.format("%.1f",12+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
	end
    if item.prefab == "purplegem" and inst.level2 < 30 then
		if math.random() <= -0.45*inst.level2/29+0.5 then
	        inst.level2 = inst.level2 + 1
	        inst.components.weapon:SetRange(10 + inst.level2 * 0.4, 12 + inst.level2 * 0.4)
		    owner.components.talker:Say("大炮\n伤害 : "..(200+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",10+inst.level2 * 0.4)).."-"..(string.format("%.1f",12+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
	    else
			owner.components.talker:Say("强化失败,强化到下一级成功率为"..(string.format("%.1f",-45*inst.level2/29+50)))
	    end
	end
	if item.prefab == "orangegem" and inst.level3 < 30 then
		if math.random() <= -0.45*inst.level3/29+0.5 then
	        inst.level3 = inst.level3 + 1
            inst.components.equippable.walkspeedmult = 1 + inst.level3 * 0.01
		    owner.components.talker:Say("大炮\n伤害 : "..(200+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",10+inst.level2 * 0.4)).."-"..(string.format("%.1f",12+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
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
	    giver.components.talker:Say("三十六大炮\n伤害 : "..(200+inst.level).."\n移速 : "..(string.format("%.2f",1 + inst.level3 * 0.01)).."\n射程 : "..(string.format("%.1f",8+inst.level2 * 0.4)).."-"..(string.format("%.1f",10+inst.level2 * 0.4)).."\n眩晕 ："..(string.format("%.1f",5+inst.level4*1/200)).."秒"..(string.format("%.1f",48+inst.level4*1/200)).."%")
	end
	---inst.SoundEmitter:PlaySound("dontstarve/zg/shotgun/cantfill")
end

local function onpreload(inst, data)
	if data and data.level and data.level2 and data.level3 and data.level4 then
		inst.level = data.level
		inst.level2 = data.level2
		inst.level3 = data.level3
		inst.level4 = data.level4
        inst.components.weapon:SetDamage(200+inst.level)
	    inst.components.equippable.walkspeedmult = 1 + inst.level2 * 0.01
		inst.components.weapon:SetRange(10 + inst.level3 * 0.4, 12 + inst.level3 * 0.4)
	end
end

local function onsave(inst, data)
	data.level = inst.level
	data.level2 = inst.level2
	data.level3 = inst.level3
	data.level4 = inst.level4
end

local function fn()
	local inst  = CreateEntity()
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
	
	inst.AnimState:SetBank("elpheltbazooka")
    inst.AnimState:SetBuild("elpheltbazooka")
    inst.AnimState:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then return inst end
        
    local function OnEquip(inst, owner)
		owner.components.combat:SetAreaDamage(1, 1)
        owner.AnimState:OverrideSymbol("swap_object", "swap_elpheltbazooka", "swap_elpheltbazooka")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end
 
    local function OnUnequip(inst, owner)
		owner.components.combat:SetAreaDamage(nil, nil)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
 
    inst:AddComponent("inventoryitem")
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.inventoryitem.imagename = "elpheltbazooka"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/elpheltbazooka.xml"
     
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
    inst.components.equippable.walkspeedmult = 1 + inst.level2 * 0.01
			
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	if not inst.components.named then inst:AddComponent("named") end
	inst.components.named:SetName("大炮\n紫宝石升级射程\n橙宝石升级移速\n绿宝石升级伤害\n攻击怪物提升熟练度\n熟练度可使怪物晕眩")
	
			
	inst:AddTag("shadow")
 	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack_elpheltbazooka)
    inst.components.weapon:SetDamage(200+inst.level)
    inst.components.weapon:SetRange(10+inst.level3*0.4,12+inst.level3*0.4)
	inst.components.weapon:SetProjectile("elpheltmissile")
    
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
    return inst
	
end

STRINGS.NAMES.ELPHELTBAZOOKA = "大炮!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELPHELTBAZOOKA = "我可以放在这粉红色的大炮一样武器!"
	
return  Prefab("common/inventory/elpheltbazooka", fn, assets)