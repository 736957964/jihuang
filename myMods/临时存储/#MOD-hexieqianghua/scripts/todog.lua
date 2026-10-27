if GetModConfigData("todog") then

local structure = {
}
local wall = {
"wall_stone",
"wall_moonrock",
"wall_wood",
"wall_hay",
"wall_ruins",
"fence",
"fence_gate",
}

for i,v in pairs(GLOBAL.AllRecipes) do
	if v.placer then
	table.insert(structure,v.name)
	end
end
for i,v in ipairs(structure) do
	AddPrefabPostInit(v,function(inst)
	inst:ListenForEvent("onbuilt" ,function(inst,data)
	if not data.builder.Network:IsServerAdmin() then
		local x,y,z = inst.Transform:GetWorldPosition()
		GLOBAL.SpawnPrefab("ash").Transform:SetPosition(x,y,z)
		inst:Remove()
	end
	end)
	end)
end

for i,v in ipairs(wall) do
	AddPrefabPostInit(v,function(inst)
		inst:DoTaskInTime(0.1,function()
			local x,y,z = inst.Transform:GetWorldPosition()
			GLOBAL.SpawnPrefab("ash").Transform:SetPosition(x,y,z)
			inst:Remove()
		end)
	end)
end

end