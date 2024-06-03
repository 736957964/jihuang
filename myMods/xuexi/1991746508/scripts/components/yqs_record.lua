
local Record = Class(function(self, inst)
	self.inst = inst
	self.full = false
end)

function Record:IsFull()
	return self.full
end

function Record:SetFull()
	self.full = true
end

function Record:OnSave()
	return {
		full = self.full,
	}
end

function Record:OnLoad(data)
    if data and data.full then
    	self.full = data.full
    end
end

return Record
