
local Aoeweapon_Leap = Class(function(self, inst)
    self.inst = inst
	self.leapfn = nil
end)

function Aoeweapon_Leap:SetLeapfn(fn)
	self.leapfn = fn
end		

function Aoeweapon_Leap:DoLeap(doer, pos, targetpos)
	if self.leapfn ~= nil then
		self.leapfn(self.inst ,doer, pos, targetpos)
		return true
	end
end

return Aoeweapon_Leap
