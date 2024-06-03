
AddPrefabFiles("blackbear", "blackbear_rock")

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = 30

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end
AddPrefabPostInit('critterlab', function(inst)
    if not TheWorld.ismastersim then
        return inst
	end
	inst:DoTaskInTime(0,function(...)
		if not TheWorld.myth_honeypot then
			local pt = Vector3(inst.Transform:GetWorldPosition())
			local spawn_pt = GetSpawnPoint(pt)
			if spawn_pt then
				local pot = SpawnPrefab("myth_honeypot")
				pot.Transform:SetPosition(spawn_pt:Get())
			end
		end
	end)
end)


--与熊大不发生仇恨
AddPrefabPostInit('blackbear', function(inst)
	if inst.components.combat then
		local old_set = inst.components.combat.SetTarget
		inst.components.combat.SetTarget = function(self, target, ...)
			if target and (target.prefab == 'blackbear' or target.prefab == 'bearger') then
				return 
			else
				return old_set(self, target, ...)
			end
		end
	end
end)

AddPrefabPostInit('bearger', function(inst)
	if inst.components.combat then
		local old_set = inst.components.combat.SetTarget
		inst.components.combat.SetTarget = function(self, target)
			if target and target.prefab == 'blackbear' then
				return 
			else
				return old_set(self, target)
			end
		end
	end
end)

--蓝图不可点燃
AddPrefabPostInit("kam_lan_cassock_blueprint", function(inst)
    inst.AnimState:SetBank("blueprint_rare")
    inst.AnimState:SetBuild("blueprint_rare")
	if inst.components.inventoryitem then
		inst.components.inventoryitem:ChangeImageName("blueprint_rare")
	end
	if inst.components.burnable then
		inst:RemoveComponent("burnable")
	end
	if inst.components.propagator then
		inst:RemoveComponent("propagator")
	end
end)


AddPrefabPostInit('lucky_goldnugget', function(inst)
	inst:AddTag('myth_coin')
end)

AddPrefabPostInit('goldnugget', function(inst)
	inst:AddTag('myth_coin')
end)
