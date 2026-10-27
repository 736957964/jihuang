-- Used to delete a specific WatchWorldState.
return function(inst, event)
    if inst.worldstatewatching ~= nil then
        for var in pairs(inst.worldstatewatching) do
        	if var == event then
            	TheWorld.components.worldstate:RemoveWatcher(var, inst)
            end
        end
    end
end