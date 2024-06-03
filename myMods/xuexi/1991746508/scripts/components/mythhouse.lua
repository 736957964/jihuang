
local MythHouse = Class(function(self, inst)
	self.inst = inst
	self.num = 1
	self.maxnum = 100
end)

function MythHouse:BuildHouse()
	self.num = self.num + 1
end

function MythHouse:IsMax()
	return self.num >= self.maxnum
end

function MythHouse:GetPosition()
	if self:IsMax() then
		return
	end
	local x,z = -2000, -2000
	
	local aa = math.ceil(self.num/5) -1
	
	x = x + 100*aa
	z = 100*((self.num-5*aa)-1) + z
	return x,z
end

function MythHouse:OnSave()
    return
    {
        num = self.num,
    }
end

function MythHouse:OnLoad(data)
    if data.num ~= nil then
		self.num = data.num
	end
end

return MythHouse