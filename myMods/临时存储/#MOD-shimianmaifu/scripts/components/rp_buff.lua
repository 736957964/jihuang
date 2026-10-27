--[[玩家buff组件]]--


local RP_Buff = Class(function(self, inst)
	self.inst = inst
	self.inst.buff = {}
	self.inst.oringnal_max_health = self.inst.components.health.maxhealth
	self.inst.current_level = 1
end)

function RP_Buff:make() 
	self.inst.canUpGrade = true
	
end

function RP_Buff:LevelUp(current_level)
	self.inst.current_level = current_level
	local health_delta = 10 * (current_level - 1)
	
	if self.inst.components.health then 
		self.inst.buff.health_percent = self.inst.components.health:GetPercent()
		self.inst.components.health:SetMaxHealth(self.inst.oringnal_max_health + health_delta)
		self.inst.components.health:SetPercent(self.inst.buff.health_percent)
	end
end

function RP_Buff:OnSave()
	return
	{
		current_level = self.inst.current_level,
	}
end

function RP_Buff:OnLoad(data)
	if data ~= nil then
		if data.current_level ~= nil then
			self.inst.current_level = data.current_level
			self:LevelUp(self.inst.current_level)
		end
	end
end

return RP_Buff