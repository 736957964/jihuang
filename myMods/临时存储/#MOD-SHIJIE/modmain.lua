GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
				
TUNING.WORLD_PLAYERSNUM_170306 = {}

TUNING.SHARD_ID_TAB_170306 = {
	{x=-15,z=18, id = "1"},                     -----------世界0  编号ID 1      是主世界 必须有 不用改
	{x=-15,z=18, id = "1092213440"},             ----------世界1  编号ID 需要修改 
	--{x=8,z=-8, id = "2616054922"},          ------------世界2  编号ID 需要修改  
	--{x=-4,z=4, id = "4"},
	--{x=-4,z=0, id = "5"},
	--{x=-4,z=-4, id = "0"},
}
for k,v in pairs(TUNING.SHARD_ID_TAB_170306) do
	if v then
		if TheNet:GetIsServer() 
			then
			AddPrefabPostInit("multiplayer_portal", function(inst)
					inst:AddComponent("zg_170306_entrance")
					inst:DoPeriodicTask(.1, function()
						local id = TheShard:GetShardId()
						TUNING.WORLD_PLAYERSNUM_170306["world_"..id] = {}
						TUNING.WORLD_PLAYERSNUM_170306["world_"..id].name = "world_"..id
						TUNING.WORLD_PLAYERSNUM_170306["world_"..id].id = id
						TUNING.WORLD_PLAYERSNUM_170306["world_"..id].players_num =  table.getn(TheNet:GetClientTable())-1
						TUNING.WORLD_PLAYERSNUM_170306["world_"..id].players_num_max = TheNet:GetDefaultMaxPlayers()
						inst.components.zg_170306_entrance.id = id
						inst.components.zg_170306_entrance:Init()
					end)
			end)
		end
	end
end

local function choosemin(table)
	if type(table) ~= table then
		return
	end
	local min = 1000000
	local key
	for k, v in pairs(table) do
		if v
			and v <= min 
			then
			min = v
			key = k
		end
	end
	return key, min
end

AddPlayerPostInit(function(inst)
	if TheNet:GetIsServer() then
		inst:AddComponent("auto_goworld")
	end
end)

AddPrefabPostInit("cave_entrance_open", function(inst)
	if not inst.components.talker then
		inst:AddComponent("talker")
	end
	if TheNet:GetIsServer() then
		inst:AddComponent("zg_170306_caveentrance")
	end
end)



local old_MIGRATE = GLOBAL.ACTIONS.MIGRATE.fn
GLOBAL.ACTIONS.MIGRATE.fn = function(act)
    if act.doer ~= nil and act.target ~= nil and act.target.components.worldmigrator ~= nil then
	local A = act.target.components.worldmigrator.linkedWorld
	local B =  8
	if not TUNING.WORLD_PLAYERSNUM_170306 or TUNING.WORLD_PLAYERSNUM_170306[A] == nil or act.doer.Network:IsServerAdmin() then
	    return old_MIGRATE(act)
	elseif TUNING.WORLD_PLAYERSNUM_170306[A] >= B then
	    if act.doer.components.talker then
		act.doer:DoTaskInTime(0.01, function(player)
		    if player.components.talker then player.components.talker:Say("目标世界人数达到上限，无法进入") end
		end)
	    end
	    return false
	else
	    return old_MIGRATE(act)
	end
    end

    return old_MIGRATE(act)

end

















