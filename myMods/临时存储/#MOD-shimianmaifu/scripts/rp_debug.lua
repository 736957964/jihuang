function rp_spawn(prefab, type_code)
	if type_code == nil then type_code = 1 end
    if TheSim ~= nil and TheInput ~= nil then
        TheSim:LoadPrefabs({ prefab })
        local inst = SpawnPrefab(prefab)
        if inst ~= nil then
			if not inst.components.rp_invasive then
				inst:AddComponent("rp_invasive")
			end
			inst.components.rp_invasive:Make(type_code)
            inst.Transform:SetPosition(ConsoleWorldPosition():Get())
            return inst
        end
    end
end
