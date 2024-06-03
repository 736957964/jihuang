local pvpgroup = Class(function(self, inst)
    self.inst = inst
    self.touxian = 0
	self.touxianname=""
	self.touxiancol=1
end)

function pvpgroup:OnSave()
    local data = {
        touxian = self.touxian,
		touxianname=self.touxianname,
		touxiancol=self.touxiancol
    }
    return data
end

function pvpgroup:OnLoad(data)
    self.touxian = data.touxian or 0
	self.touxianname = data.touxianname or ""
	self.touxiancol = data.touxiancol or 1
end
function pvpgroup:settouxian(col,name)
	self.touxianname=name
	self.touxiancol=col
	self.touxian=1
end

return pvpgroup