--主要负责猪王周围进攻怪物的安置

--更新世界
local function updateWorld(world)
	
	--if TheWorld.state.cycles == 1 then
	--	for n,player in pairs(AllPlayers) do 
	--		rp_SpawnPlayerNearPigKing(player)
	--	end
	--end
	
	--if TheWorld.state.cycles > 1 and TheWorld.state.cycles % 2 == 0 then  
	--	for i = 1, 3 do 
	--		SpawnPrefab("lightning")
	--		local monster = rp_SpawnPrefabNearPigKing("merm")
	--	end
	--end
	
end

--[入侵猪王机制]--
local RP_PigKing_Invade = Class(function(self, inst)
	self.inst = inst
	self.inst:ListenForEvent("ms_cyclecomplete", function() updateWorld(self.inst) end)
	
end)

function RP_PigKing_Invade:OnSave()
	return
	{
		
	}
end
	
function RP_PigKing_Invade:OnLoad(data)
	if data ~= nil then
		
	end
end

return RP_PigKing_Invade