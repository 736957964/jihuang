local function OnTimer(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end	
end

---speed
local function OnSpeed(inst, target)
    if target.components.locomotor ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target.components.locomotor:SetExternalSpeedMultiplier(target, "fly_pill_buff", 1.5)
        if target._is_flypill ~= nil then
            target._is_flypill:set(true)
        end
    else
        inst.components.debuff:Stop()
    end
end

local function OnSpeedStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnSpeed(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnSpeedExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnSpeed(inst, target)
end

local function OnSpeedDeath(inst,target)
	if target.components.locomotor ~= nil then
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "fly_pill_buff")
	end
    if target._is_flypill ~= nil then
        target._is_flypill:set(false)
    end
	inst:Remove()
end
--===================
-----========attack
local function OnAttack(inst, target)
    if target.components.combat ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then

        if target.prefab == "laozi_qingniu" then
            target.components.combat:SetDefaultDamage(102)
        else
            target.components.combat.externaldamagemultipliers:SetModifier(inst, 2)
        end
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttackStart(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnAttack(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnAttackExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnAttack(inst, target)
end

local function OnAttackDeath(inst,target)
    if target.components.combat ~= nil then
        if target.prefab == "laozi_qingniu" then
            target.components.combat:SetDefaultDamage(51)
        else
            target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
        end
    end
	inst:Remove()
end

-----========blood
local function OnBlood(inst, target)
    if target.components.combat ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target:AddTag("bloodthirsty_pill_buff")
    else
        inst.components.debuff:Stop()
    end

end

local function OnBloodStart(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnBlood(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnBloodExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnBlood(inst, target)
end

local function OnBloodDeath(inst,target)
	target:RemoveTag("bloodthirsty_pill_buff")
	inst:Remove()
end
-----========armor
local function OnArmor(inst, target)
    if target.components.combat ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		target.components.health.externalabsorbmodifiers:SetModifier(inst, 0.5)
    else
        inst.components.debuff:Stop()
    end

end

local function OnArmorStart(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnArmor(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnArmorExtend(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 240)
    OnArmor(inst, target)
end

local function OnArmorDeath(inst,target)
    if target.components.health ~= nil then
		target.components.health.externalabsorbmodifiers:RemoveModifier(inst)
    end
    inst:Remove()
end
-----mount
local function OnMount(inst, target)
    if target.components.combat ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		target:AddTag("movemountain_pill_buff")
    else
        inst.components.debuff:Stop()
    end

end

local function OnMountStart(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnMount(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnMountExtend(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnMount(inst, target)
end

local function OnMountDeath(inst,target)
    target:RemoveTag("movemountain_pill_buff")
    inst:Remove()
end
---

local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") and target.components.sanity  then
        target.components.sanity:DoDelta(1/3, true, "wb_shadowheart_buff")
    else
        inst.components.debuff:Stop()
    end
end

local function OnShadowStart(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	if target.components.combat ~= nil then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, 2)
	end	
    inst.task = inst:DoPeriodicTask(1, OnTick, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnShadowExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 240)
	if target.components.combat ~= nil then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, 2)
	end
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(1, OnTick, nil, target)
end

local function OnShadowDeath(inst,target)
	if target.components.combat ~= nil then
		target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
	end
    inst:Remove()
end

--猪皮冻
local function OnZhu(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		--if not target
        target.components.health.minhealth = 1
    else
        inst.components.debuff:Stop()
    end
end

local function OnZhuStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnZhu(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnZhuExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 120)
    OnZhu(inst, target)
end

local function OnZhuDeath(inst,target)
	if target.components.health ~= nil then
		target.components.health.minhealth = 0
        if not target.components.health:IsDead() and not target:HasTag("playerghost") then
			target.components.health:SetVal(1)
			target.components.health:DoDelta(0)
		end
	end
	inst:Remove()
end

--冰冻buff
local function onhit(inst,data)
	if data and data.target and data.target:IsValid() then
		if data.target.components.freezable ~= nil then
			data.target.components.freezable:AddColdness(1)
			data.target.components.freezable:SpawnShatterFX()
		end
	end
end

local function OnFreeze(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		target:ListenForEvent('onhitother',onhit)
    else
        inst.components.debuff:Stop()
    end
end

local function OnFreezeStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnFreeze(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnFreezeExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 30)
    OnFreeze(inst, target)
end

local function OnFreezeDeath(inst,target)
	target:RemoveEventCallback('onhitother',onhit)
	inst:Remove()
end

----冰月饼
local function OnIceCake(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		if target.components.sanity then
			target.components.sanity.myth_mooncake_ice = true
		end
    else
        inst.components.debuff:Stop()
    end
end

local function OnIceCakeStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnIceCake(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnIceCakeExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnIceCake(inst, target)
end

local function OnIceCakeDeath(inst,target)
	if target and target.components.sanity then
		target.components.sanity.myth_mooncake_ice = false
	end
	inst:Remove()
end


----五ren月饼
local function OnNutsCake(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		if target.components.hunger then
			target.components.hunger.myth_mooncake_nuts = true
		end
    else
        inst.components.debuff:Stop()
    end
end

local function OnNutsCakeStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnNutsCake(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnNutsCakeExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnNutsCake(inst, target)
end

local function OnNutsCakeDeath(inst,target)
	if target and target.components.hunger then
		target.components.hunger.myth_mooncake_nuts = false
	end
	inst:Remove()
end

---==========================
----五ren月饼lotus

local function OnLotusCake(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		target.myth_mooncake_lotus = true
    else
        inst.components.debuff:Stop()
    end
end
local function OnLotusCakeStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnLotusCake(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnLotusCakeExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnLotusCake(inst, target)
end

local function OnLotusCakeDeath(inst,target)
	target.myth_mooncake_lotus = false
	inst:Remove()
end


---屠苏酒
local function OnTSJ(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            if target.components.temperature ~= nil then
                target.components.temperature.myth_food_tsj_buff = true
            end
            if target.components.sanity ~= nil then
                target.components.sanity.neg_aura_modifiers:SetModifier(inst, 0.5)
            end
    else
        inst.components.debuff:Stop()
    end
end
local function OnTSJStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnTSJ(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTSJExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    OnTSJ(inst, target)
end

local function OnTSJDeath(inst,target)
    if target.components.temperature ~= nil then
        target.components.temperature.myth_food_tsj_buff = nil
    end
    if target.components.sanity ~= nil then
        target.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
    end
	inst:Remove()
end

---肉包子
local function OnBZ(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            if target.components.hunger ~= nil then
                target.components.hunger.burnratemodifiers:SetModifier("myth_food_bz", 0.5)
            end
    else
        inst.components.debuff:Stop()
    end
end
local function OnBZStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnBZ(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnBZExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 60)
    OnBZ(inst, target)
end

local function OnBZDeath(inst,target)
    if target.components.hunger ~= nil then
        target.components.hunger.burnratemodifiers:RemoveModifier("myth_food_bz")
    end
	inst:Remove()
end


---避火
local function OnWheel(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            target.components.health.externalfiredamagemultipliers:SetModifier("myth_flyerfx_wheel_buff", 0)
    else
        inst.components.debuff:Stop()
    end
end
local function OnWheelStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnWheel(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnWheelExtended(inst, target)
    --inst.components.timer:StopTimer("regenover")
    --inst.components.timer:StartTimer("regenover", 60)
    OnWheel(inst, target)
end

local function OnWheelDeath(inst,target)
    if target.components.health ~= nil then
        target.components.health.externalfiredamagemultipliers:RemoveModifier("myth_flyerfx_wheel_buff")
    end
	inst:Remove()
end

---避水
local function OnFHY(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            if target.components.moisture ~= nil then
                target.components.moisture:ForceDry(true, inst)
                target.components.moisture.myth_waterproofInventory = true
            end
    else
        inst.components.debuff:Stop()
    end
end
local function OnFhyStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnFHY(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnFhyExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", TUNING.BUFF_MOISTUREIMMUNITY_DURATION)
    OnFHY(inst, target)
end

local function OnFhyDeath(inst,target)
    if target.components.moisture ~= nil then
        target.components.moisture:ForceDry(false, inst)
        target.components.moisture.myth_waterproofInventory = nil
    end
	inst:Remove()
end



---青牛的buff
local function Onniu(inst, target)
    if target.components.locomotor ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            if target.Physics then
                RemovePhysicsColliders(target)
            end
            if target.components.locomotor then
                target.components.locomotor:SetSlowMultiplier(0.6)
                target.components.locomotor.pathcaps = { player = true, ignorecreep = true ,allowocean = true}
                target.components.locomotor.fasteronroad = false
                target.components.locomotor:SetTriggersCreep(false)
                target.components.locomotor:SetAllowPlatformHopping(false)
            end
            if target.components.drownable then
                target.components.drownable.enabled = false
            end
            if target.components.mk_cloudfxspawner then
                target.components.mk_cloudfxspawner.canspawn = true
                target.components.mk_cloudfxspawner:CreateClouds()
            end
    else
        inst.components.debuff:Stop()
    end
end

local function OnQingStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    Onniu(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnQingExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 480)
    Onniu(inst, target)
end

local function OnQingDeath(inst,target)
    if target.Physics then
        ChangeToCharacterPhysics(target)
    end
    if target.components.locomotor then
        target.components.locomotor:SetSlowMultiplier(0.6)
        target.components.locomotor.pathcaps = { player = true, ignorecreep = true }
        target.components.locomotor.fasteronroad = true
        target.components.locomotor:SetAllowPlatformHopping(true)
        target.components.locomotor:SetTriggersCreep(true)
        --target.components.locomotor.hop_distance_fn = GetHopDistance
    end
    if target.components.drownable then
        target.components.drownable.enabled = true
    end
    if target.components.mk_cloudfxspawner then
        target.components.mk_cloudfxspawner.canspawn = false
        target.components.mk_cloudfxspawner:RemoveClouds()
    end
	inst:Remove()
end

--三犀牛之心的buff
local function OnRed(inst, target)
    if target.components.locomotor ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            target.mythpill_forcefire = true
    else
        inst.components.debuff:Stop()
    end
end

local function OnRedStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnRed(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnRedExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 4800)
    OnRed(inst, target)
end

local function OnRedDeath(inst,target)
    target.mythpill_forcefire = false
	inst:Remove()
end

local function OnBlue(inst, target)
    if target.components.locomotor ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            target.mythpill_forcecold = true
    else
        inst.components.debuff:Stop()
    end
end

local function OnBlueStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnBlue(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnBlueExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 4800)
    OnBlue(inst, target)
end

local function OnBlueDeath(inst,target)
    target.mythpill_forcecold = false
	inst:Remove()
end

local function OnYellow(inst, target)
    if target.components.locomotor ~= nil and target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            target:AddTag("mythpill_forcegoggles")
    else
        inst.components.debuff:Stop()
    end
end

local function OnYellowStart(inst, target) 
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    OnYellow(inst, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnYellowExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", 4800)
    OnYellow(inst, target)
end

local function OnYellowDeath(inst,target)
    target:RemoveTag("mythpill_forcegoggles")
	inst:Remove()
end

--print(ThePlayer:HasTag("mythpill_forcegoggles"))
--=====================================
local function makebuffs(name,data)
	local function fn()
		local inst = CreateEntity()
		--if not TheWorld.ismastersim then
		--	inst:DoTaskInTime(0, inst.Remove)
		--	return inst
		--end
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
		inst.entity:Hide()
		inst.persists = false

        inst:AddTag("CLASSIFIED")
        inst:AddTag("NOCLICK")
        inst:AddTag("NOBLOCK")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        
		inst:AddComponent("debuff")
		inst.components.debuff:SetAttachedFn(data.start)
		inst.components.debuff:SetDetachedFn(data.death)
		inst.components.debuff:SetExtendedFn(data.extended)
		inst.components.debuff.keepondespawn = true

        if  data.time ~= nil then
		    inst:AddComponent("timer")
		    inst.components.timer:StartTimer("regenover", data.time)
            inst:ListenForEvent("timerdone", OnTimer)
        end

		return inst
	end
	return Prefab(name, fn)
end

return 
makebuffs("fly_pill_buff",{start = OnSpeedStart , extended =OnSpeedExtended ,death = OnSpeedDeath ,time = 480 }),
makebuffs("bloodthirsty_pill_buff",{start = OnBloodStart , extended =OnBloodExtended ,death = OnBloodDeath , time = 480 }),
makebuffs("condensed_pill_buff",{start = OnAttackStart , extended =OnAttackExtended ,death = OnAttackDeath , time = 480 }),
makebuffs("armor_pill_buff",{start = OnArmorStart, extended = OnArmorExtend, death = OnArmorDeath, time = 240}),
makebuffs("movemountain_pill_buff",{start = OnMountStart, extended = OnMountExtend, death = OnMountDeath, time = 480}),
makebuffs("wb_shadowheart_buff",{start = OnShadowStart, extended = OnShadowExtended, death = OnShadowDeath, time = 240}),
makebuffs("myth_zpd_buff",{start = OnZhuStart, extended = OnZhuExtended, death = OnZhuDeath, time = 120}),
makebuffs("myth_freezebuff",{start = OnFreezeStart, extended = OnFreezeExtended, death = OnFreezeDeath, time = 30}),
makebuffs("myth_mooncake_nutsbuff",{start = OnNutsCakeStart, extended = OnNutsCakeExtended, death = OnNutsCakeDeath, time = 480}),
makebuffs("myth_mooncake_icebuff",{start = OnIceCakeStart, extended = OnIceCakeExtended, death = OnIceCakeDeath, time = 480}),
makebuffs("myth_mooncake_lotusbuff",{start = OnLotusCakeStart, extended = OnLotusCakeExtended, death = OnLotusCakeDeath, time = 480}),
makebuffs("myth_food_tsj_buff",{start = OnTSJStart, extended = OnTSJExtended, death = OnTSJDeath, time = 480}),
makebuffs("myth_food_bz_buff",{start = OnBZStart, extended = OnBZExtended, death = OnBZDeath, time = 60}),
makebuffs("myth_flyerfx_wheel_buff",{start = OnWheelStart, extended = OnWheelExtended, death = OnWheelDeath}),
makebuffs("myth_food_fhy_buff",{start = OnFhyStart, extended = OnFhyExtended, death = OnFhyDeath,time = TUNING.BUFF_MOISTUREIMMUNITY_DURATION}),
makebuffs("qingniufly_buff",{start = OnQingStart , extended =OnQingExtended ,death = OnQingDeath ,time = 480 }),

--
makebuffs("myth_rhino_redbuff",{start = OnRedStart , extended =OnRedExtended ,death = OnRedDeath ,time = 4800 }),
makebuffs("myth_rhino_bluebuff",{start = OnBlueStart , extended =OnBlueExtended ,death = OnBlueDeath ,time = 4800 }),
makebuffs("myth_rhino_yellowbuff",{start = OnYellowStart , extended =OnYellowExtended ,death = OnYellowDeath ,time = 4800 })