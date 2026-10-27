
local Aoeweapon_Lunge = Class(function(self, inst)
    self.inst = inst
	self.lungefn = nil
end)

function Aoeweapon_Lunge:SetLungefn(fn)
	self.lungefn = fn
end		

function Aoeweapon_Lunge:DoLunge(doer, pos, targetpos)
	if self.lungefn ~= nil then
		self.lungefn(self.inst ,doer, pos, targetpos)
		return true
	end
end

return Aoeweapon_Lunge
