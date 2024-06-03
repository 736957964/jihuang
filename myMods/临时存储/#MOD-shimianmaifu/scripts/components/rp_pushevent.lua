--[[推送事件组件]]--
local function OnDeath(inst)
	inst:ListenForEvent("death", function()
		
		if inst.prefab == "pigking" then
			SpawnPrefab("lightning")
			TheNet:Announce("猪王已死亡，世界即将陷入一片黑暗中！！！")
			TheWorld:PushEvent("rp_pigkingbekilled")
		end

	end)
end

local RP_PushEvent = Class(function(self, inst)
	self.inst = inst
	OnDeath(self.inst)
end)

function RP_PushEvent:OnSave()
	return
	{

	}
end

function RP_PushEvent:OnLoad(data)
	if data ~= nil then

	end
end

return RP_PushEvent