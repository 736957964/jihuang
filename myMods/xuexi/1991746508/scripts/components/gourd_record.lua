
local Record = Class(function(self, inst)
	self.inst = inst
	self.total = 0
	self.myth_yjp = false
	self.laozi_bell = false

	self:OnInit()
end)

function Record:OnInit()
	local total = 0
	for _, v in pairs(Ents)do
		if v:IsValid() and v:HasTag("purple_gourd") then
			total = total + 1
		end
	end
	self.total = math.max(self.total, total)
end

function Record:Get()
	self.total = self.total + 1
	if self.total == 1 then
		return "FEMALE"
	elseif self.total == 2 then
		return "MALE"
	else
		return "NONE"
	end
end

function Record:OnSave()
	return {
		total = self.total,
		myth_yjp = self.myth_yjp,
		laozi_bell = self.laozi_bell,
	}
end

function Record:OnLoad(data)
    if data then
		if data.total then
			self.total = data.total
		end
		if data.myth_yjp then
			self.myth_yjp = data.myth_yjp
		end

		if data.laozi_bell then
			self.laozi_bell = data.laozi_bell
		end
    end
end

return Record
