

local Use_Gourd = Class(function(self, inst)
	self.inst = inst
	self.onusefn = nil
end)

function Use_Gourd:SetOnUseFn(fn)
	self.onusefn = fn
end

function Use_Gourd:OnUse(doer)
	if not self.inst.components.fueled or  self.inst.components.fueled:GetPercent() <=0 then
		return false
	end
	if self.onusefn then
		self.onusefn(self.inst,doer)
	end
	return true
end

return Use_Gourd