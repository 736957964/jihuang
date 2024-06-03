local _G = GLOBAL
local SpawnPrefab = _G.SpawnPrefab

function AddAnger(inst, rate, angerAtkPre, angerAnim, callback)
	rate = rate or 0.2
	local atkPre = inst.components.combat.min_attack_period

	local colour_r, colour_g, colour_b, alpha
	inst:DoTaskInTime(0, function ()
		colour_r, colour_g, colour_b, alpha = inst.AnimState:GetMultColour()
	end)

	inst.components.health.old_ondelta = inst.components.health.ondelta
	inst.components.health.ondelta = function(inst, old_percent, new_percent)
		if inst.components.health.old_ondelta ~= nil then
			inst.components.health.old_ondelta(inst, old_percent, new_percent)
		end
		
		if not inst.anger and inst.components.health.currenthealth <= inst.components.health.maxhealth * rate then
			inst.anger = true
			if angerAnim then
				local tauntfx = SpawnPrefab("tauntfire_fx")
				tauntfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				tauntfx.Transform:SetRotation(inst.Transform:GetRotation())
			end
			inst.AnimState:SetMultColour(0.7, 0, 0, 1)
			inst.components.combat:SetAttackPeriod(angerAtkPre)
			if callback ~= nil then
				callback(inst, atkPre)
			end
		elseif inst.anger and inst.components.health.currenthealth > inst.components.health.maxhealth * rate then
			inst.anger = false
			---inst.AnimState:SetMultColour(colour_r, colour_g, colour_b, alpha)
			inst.components.combat:SetAttackPeriod(atkPre)
			if callback ~= nil then
				callback(inst, atkPre)
			end
		end
	end
end