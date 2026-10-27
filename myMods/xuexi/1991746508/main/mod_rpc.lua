
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	inst:AddComponent("myth_saveinfo")
end)

AddShardModRPCHandler( "myth_saveinfo", "myth_saveinfo", function(worldid,value)
    if value and type(value) == "string" then
        local myth_saveinfo = TheWorld and TheWorld.components.myth_saveinfo or nil
        if myth_saveinfo and  myth_saveinfo.AddPlayerInfo ~= nil then
            local success, b = pcall(json.decode,value)
            if success and b ~= nil then
                for k, v in pairs(b) do
                    myth_saveinfo:AddPlayerInfo(k, v)
                end
            end
        end
    end
end)