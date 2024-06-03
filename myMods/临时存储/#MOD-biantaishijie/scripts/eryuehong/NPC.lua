GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	


AddPrefabPostInit("world",function(inst)
	if TheNet:GetIsServer() then
		inst:AddComponent("NPC1")
		inst:AddComponent("NPC2")
	end
end)



