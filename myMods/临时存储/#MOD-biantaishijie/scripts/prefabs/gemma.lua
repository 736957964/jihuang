local assets = {
	Asset("ANIM", "anim/gemma.zip"),
	Asset("ANIM", "anim/swap_gemma.zip"),

	Asset("ATLAS", "images/inventoryimages/gemma.xml"),
	Asset("IMAGE", "images/inventoryimages/gemma.tex")
}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_gemma", "swap_gemma")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

--定义闪电
local function lightningstrike(lightningstriketarget)
    local x, y, z = lightningstriketarget.Transform:GetWorldPosition()
	local lightning = SpawnPrefab("lightning")
	lightning.Transform:SetPosition(x, y, z)
	lightning:DoTaskInTime(2, lightning.Remove)
end

local function onattack(inst, attacker, target, skipsanity)
    --原函数
    if math.random() < 0.2 then local pt
        if target ~= nil and target:IsValid() then pt = target:GetPosition()  
        else pt = attacker:GetPosition() target = nil end
        local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3)
        if offset ~= nil then
            local tentacle = SpawnPrefab("shadowtentacle")
            if tentacle ~= nil then
                tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                tentacle.components.combat:SetTarget(target)
            end
        end
    end
	--魔杖火焰
	if inst.level > 0 and inst.level2 == 0 and math.random() <= inst.level/200 then
		if not target:IsValid() then return end
		if target.components.freezable ~= nil then target.components.freezable:AddColdness(-1) end
		if target.components.combat ~= nil then target.components.combat:SuggestTarget(attacker) end
		if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then target.components.sleeper:WakeUp() end
	    if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil then attacker.components.sanity:DoDelta(-1) end
		if target.components.freezable ~= nil and target.components.freezable:IsFrozen() then target.components.freezable:Unfreeze() end
        if target.components.burnable ~= nil and not target.components.burnable:IsBurning() then
            if target.components.fueled == nil then target.components.burnable:Ignite(true)
            elseif target.components.fueled.fueltype == FUELTYPE.BURNABLE or target.components.fueled.secondaryfueltype == FUELTYPE.BURNABLE then
                local fuel = SpawnPrefab("cutgrass")
                if fuel ~= nil then
                    if fuel.components.fuel ~= nil and
                        fuel.components.fuel.fueltype == FUELTYPE.BURNABLE then
                        target.components.fueled:TakeFuelItem(fuel)
                    else
                        fuel:Remove()
                    end
                end
            end
		end
		attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
        target:PushEvent("attacked", { attacker = attacker, damage = 60+inst.level6 })
		attacker.components.talker:Say("成功触发火焰,当前触发几率"..(inst.level/2).."%")
	end
    --魔杖冰冻
	if inst.level2 > 0 and inst.level == 0 and math.random() <= inst.level2/200 then
	    if target and not target:IsValid() then return end
		if target.components.combat ~= nil then target.components.combat:SuggestTarget(attacker) end
	    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then target.components.sleeper:WakeUp() end
	    if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil then attacker.components.sanity:DoDelta(-1) end
		if target.components.burnable ~= nil and target.components.burnable:IsBurning() then target.components.burnable:Extinguish() end
		if target.sg ~= nil and not target.sg:HasStateTag("frozen") then target:PushEvent("attacked", { attacker = attacker, damage = 60+inst.level6 }) end
        if target.components.burnable ~= nil and target.components.burnable:IsSmoldering() then target.components.burnable:SmotherSmolder() end
        if target.components.freezable ~= nil then
            target.components.freezable:AddColdness(inst.level2*10/200)
            target.components.freezable:SpawnShatterFX()
			attacker.components.talker:Say("成功触发冰冻,触发几率"..(inst.level2/2).."%,冰冻值"..(inst.level2*10/200))
        end
	end
	--升级路线三:兼修
	if inst.level > 0 and inst.level2 > 0 and inst.level == 200 and inst.level2 == 200 then
	    if math.random() <= 0.5 then
	        if not target:IsValid() then return end
		    if target.components.freezable ~= nil then target.components.freezable:AddColdness(-1) end
		    if target.components.combat ~= nil then target.components.combat:SuggestTarget(attacker) end
		    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then target.components.sleeper:WakeUp() end
	        if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil then attacker.components.sanity:DoDelta(-1) end
		    if target.components.freezable ~= nil and target.components.freezable:IsFrozen() then target.components.freezable:Unfreeze() end
            if target.components.burnable ~= nil and not target.components.burnable:IsBurning() then
                if target.components.fueled == nil then target.components.burnable:Ignite(true)
                elseif target.components.fueled.fueltype == FUELTYPE.BURNABLE or target.components.fueled.secondaryfueltype == FUELTYPE.BURNABLE then
                    local fuel = SpawnPrefab("cutgrass")
                    if fuel ~= nil then
                        if fuel.components.fuel ~= nil and
                            fuel.components.fuel.fueltype == FUELTYPE.BURNABLE then
                            target.components.fueled:TakeFuelItem(fuel)
                        else
                            fuel:Remove()
                        end
                    end
                end
		    end
			attacker.components.talker:Say("成功触发火焰,当前触发几率50%")
            attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
			target:PushEvent("attacked", { attacker = attacker, damage = 60+inst.level6 })
	    end
	    if math.random() > 0.5 then
	        if target and not target:IsValid() then return end
		    if target.components.combat ~= nil then target.components.combat:SuggestTarget(attacker) end
	        if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then target.components.sleeper:WakeUp() end
	        if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil then attacker.components.sanity:DoDelta(-1) end
		    if target.components.burnable ~= nil and target.components.burnable:IsBurning() then target.components.burnable:Extinguish() end
		    if target.sg ~= nil and not target.sg:HasStateTag("frozen") then target:PushEvent("attacked", { attacker = attacker, damage = 60+inst.level6 }) end
            if target.components.burnable ~= nil and target.components.burnable:IsSmoldering() then target.components.burnable:SmotherSmolder() end
            if target.components.freezable ~= nil then
                target.components.freezable:AddColdness(10)
                target.components.freezable:SpawnShatterFX()
			    attacker.components.talker:Say("成功触发冰冻,触发几率50%,冰冻值10")
            end
	    end
	end
	--暴击
	if inst.level3 > 0 and math.random() < inst.level3/200 and attacker.components.inventory then
	    local weapon = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if weapon ~= nil and attacker ~= nil and target ~= nil then
		    attacker.components.talker:Say("成功触发暴击,当前触发几率"..(inst.level3/2).."%")
	        target.components.health:DoDelta(-weapon.components.weapon.damage)
	    end
	end
	--闪电
	if inst.level4 > 0 and math.random() < inst.level4/400 and attacker ~= nil then lightningstrike(target)
		attacker.components.talker:Say("成功触发闪电,当前触发几率"..(inst.level4/4).."%")
	end
	--嗜血
	if inst.level7 > 0 and attacker ~= nil then attacker.components.health:DoDelta(inst.level7) end
	--五彩缤纷
	if target and attacker.components.health:GetPercent() > 0 then target.AnimState:SetMultColour(math.random(1,255)/255,math.random(1,255)/255,math.random(1,255)/255,1) end
end

--橙魔杖
local function onblink(staff, pos, caster)
    if caster.components.sanity ~= nil then caster.components.sanity:DoDelta(-100) end
end

local function blinkstaff_reticuletargetfn()
    local player = ThePlayer
    local rotation = player.Transform:GetRotation() * DEGREES
    local pos = player:GetPosition()
    for r = 13, 1, -1 do
        local numtries = 2 * PI * r
        local pt = FindWalkableOffset(pos, rotation, r, numtries)
        if pt ~= nil then
            return pt + pos
        end
    end
end

local function onhauntorange(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_OCCASIONAL then
        local target = FindEntity(inst, 20, nil, { "locomotor" }, { "playerghost", "INLIMBO" })
        if target ~= nil then
            local pos = target:GetPosition()
            local start_angle = math.random() * 2 * PI
            local offset = FindWalkableOffset(pos, start_angle, math.random(8, 12), 60, false, true)
            local pt = pos + offset
            inst.components.blinkstaff:Blink(pt, target)
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_LARGE
            return true
        end
    end
    return false
end

local function extra(inst)
    if inst.level == 200 and inst.level2 == 200 and inst.level3 == 200 and inst.level4 == 400 and inst.level5 == 30 then
	    inst.components.tool:SetAction(ACTIONS.CHOP,15)
	    inst.components.tool:SetAction(ACTIONS.DIG)
	    inst.components.tool:SetAction(ACTIONS.HAMMER)
	    inst:AddComponent("blinkstaff")
        inst.components.blinkstaff.onblinkfn = onblink
	    inst:AddComponent("reticule")
        inst.components.reticule.targetfn = blinkstaff_reticuletargetfn
        inst.components.reticule.ease = true
	    MakeHauntableLaunch(inst)
        AddHauntableCustomReaction(inst, onhauntorange, true, false, true)
	end
end

local function OnGetItemFromPlayer(inst, owner, item)
	if     item.prefab == "redgem"    and inst.level  < 200 then inst.level  = inst.level  + 1
	elseif item.prefab == "bluegem"   and inst.level2 < 200 then inst.level2 = inst.level2 + 1
	elseif item.prefab == "purplegem" and inst.level3 < 200 then inst.level3 = inst.level3 + 1
	elseif item.prefab == "yellowgem" and inst.level4 < 400 then inst.level4 = inst.level4 + 1
	elseif item.prefab == "greengem"                        then inst.level6 = inst.level6 + 1 inst.components.weapon:SetDamage(40+inst.level6)
	elseif item.prefab == "shroom_skin"                     then inst.level7 = inst.level7 + 1
	elseif item.prefab == "royal_jelly"                     then inst.level  = 0 inst.level2 = 0
	end
	owner.components.talker:Say("保姆伽玛\n火焰 : "..(inst.level/2).."%\n冰冻 : "..(inst.level2/2).."%\n暴击 : "..(inst.level3/2).."%\n闪电 : "..(inst.level4/4).."%\n移速 ："..(1+inst.level5*0.01).."\n伤害 ："..(60+inst.level6).."\n嗜血 ："..(inst.level7))
    if item.prefab == "orangegem" and inst.level5 < 30 then
	    if math.random() < -0.45*inst.level5/29+0.5 then
	        inst.level5 = inst.level5 + 1
	        inst.components.equippable.walkspeedmult = 1+inst.level5*0.01
			owner.components.talker:Say("保姆伽玛\n火焰 : "..(inst.level/2).."%\n冰冻 : "..(inst.level2/2).."%\n暴击 : "..(inst.level3/2).."%\n闪电 : "..(inst.level4/4).."%\n移速 ："..(1+inst.level5*0.01).."\n伤害 ："..(60+inst.level6).."\n嗜血 ："..(inst.level7))
		else
			owner.components.talker:Say("强化移速失败,强化到下一级成功率为"..(string.format("%.1f",-45*inst.level5/29+50)).."%")
	   end
	end
	extra(inst)
end

local function AcceptTest(inst, item)
    if     item.prefab == "redgem"           and inst.level  == 200                              then
	    return false
	elseif item.prefab == "bluegem"          and inst.level2 == 200                              then
	    return false
	elseif item.prefab == "purplegem"        and inst.level3 == 200                              then
	    return false
	elseif item.prefab == "yellowgem"        and inst.level4 == 400                              then
	    return false
	elseif item.prefab == "orangegem"        and inst.level5 == 30                               then
	    return false
	else
        return item.prefab == "redgem" or item.prefab == "bluegem" or item.prefab == "purplegem" or item.prefab == "yellowgem" or item.prefab == "orangegem" or item.prefab == "greengem" or item.prefab == "shroom_skin" or item.prefab == "royal_jelly" 
	end
end

local function OnRefuseItem(inst, giver, item)
    if item.prefab == "redgem" then
	    giver.components.talker:Say("火焰已强化到顶级")
	elseif item.prefab == "bluegem" then
	    giver.components.talker:Say("冰冻已强化到顶级")
	elseif item.prefab == "purplegem" then
	    giver.components.talker:Say("暴击已强化到顶级")
	elseif item.prefab == "yellowgem" then
	    giver.components.talker:Say("闪电已强化到顶级")
	elseif item.prefab == "orangegem" then
	    giver.components.talker:Say("移速已强化到顶级")
	else
	    giver.components.talker:Say("保姆伽玛\n火焰 : "..(inst.level/2).."%\n冰冻 : "..(inst.level2/2).."%\n暴击 : "..(inst.level3/2).."%\n闪电 : "..(inst.level4/4).."%\n移速 ："..(1+inst.level5*0.01).."\n伤害 ："..(40+inst.level6).."\n嗜血 ："..(inst.level7))
	end
end

local function onpreload(inst, data)
	if data and data.level and data.level2 and data.level3 and data.level4 and data.level5 and data.level6 and data.level7 then
		inst.level  = data.level
		inst.level2 = data.level2
		inst.level3 = data.level3
		inst.level4 = data.level4
		inst.level5 = data.level5
		inst.level6 = data.level6
		inst.level7 = data.level7
		extra(inst)
		inst.components.weapon:SetDamage(40+inst.level6)
        inst.components.equippable.walkspeedmult = 1+inst.level5*0.01
	end
end

local function onsave(inst, data)
	data.level  = inst.level
	data.level2 = inst.level2
	data.level3 = inst.level3
	data.level4 = inst.level4
	data.level5 = inst.level5
	data.level6 = inst.level6
	data.level7 = inst.level7
	data.level8 = inst.level8
	data.level9 = inst.level9
	extra(inst)
end

local function fn()
	local inst = CreateEntity()
	--定义冰冻
	local Freezable = Class(function(self, inst)
    self.inst = inst
    self.state = states.NORMAL
    self.resistance = 1
    self.coldness = 0
    self.wearofftime = 10000
    self.damagetotal = 0
    self.damagetobreak = 0
    self.fxlevel = 1
    self.fxdata = {}
    self.inst:ListenForEvent("attacked",onattack)
    self.inst:AddTag("freezable")
    end)
    inst.level  = 0
	inst.level2 = 0
	inst.level3 = 0
	inst.level4 = 0
	inst.level5 = 0
	inst.level6 = 0
	inst.level7 = 0
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("gemma")
	inst.AnimState:SetBuild("gemma")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("icebox_valid")
	inst:AddTag("sharp")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then return inst end
	
	extra(inst)
		
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
	inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.MINE,15)
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	if not inst.components.named then inst:AddComponent("named") end
	inst.components.named:SetName("保姆伽玛\n红宝石升级火焰\n蓝宝石升级冰冻\n紫宝石升级暴击\n黄宝石升级闪电\n橙宝石升级移速\n绿宝石升级伤害\n人生若只如初见\n何事秋风悲画扇")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "gemma"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/gemma.xml"

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(40+inst.level6)
	inst.components.weapon:SetOnAttack(onattack)
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.walkspeedmult = 1+inst.level5*0.01

	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	return inst
end

return Prefab("common/inventory/gemma", fn, assets)
