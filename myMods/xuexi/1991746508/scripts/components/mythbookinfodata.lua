local USE_SETTINGS_FILE = PLATFORM ~= "PS4" and PLATFORM ~= "NACL"

local MythBookInfoData = Class(function(self)
	self.preparedfoods = {}

	self.filters = {}
	self.filters1 = {}
    self.ZHUYE = 1
    self.RENWU = 1
    self.DIXING = 1
    self.PILL = 1
    self.DAOJU = 1
    self.SHENXIAN = 1
    self.GUAIWU = 1
end)

function MythBookInfoData:ClearFilters()
	self.filters = {}
	self.filters1 = {}
	self.dirty = true
end

function MythBookInfoData:SetFilter(category, value)
	if self.filters[category] ~= value then
		self.filters[category] = value
		self.dirty = true
	end
end

function MythBookInfoData:GetFilter(category)
	return self.filters[category]
end

function MythBookInfoData:SetFilter1(category, value)
	if self.filters1[category] ~= value then
		self.filters1[category] = value
		self.dirty = true
	end
end

function MythBookInfoData:GetFilter1(category)
	return self.filters1[category]
end

return MythBookInfoData
