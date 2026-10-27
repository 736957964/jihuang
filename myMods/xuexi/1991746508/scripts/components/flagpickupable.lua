local Flagpickupable = Class(function(self, inst)
	self.inst = inst
	self.onpickupfn = nil 
	self.canbepickedup	= true
end)
function Flagpickupable:SetOnPickupFn(fn)
	self.onpickupfn = fn
end
function Flagpickupable:CanPickUp()
	if self.canpickupfn then
		return self.canpickupfn(self.inst)
	end
	return self.canbepickedup
end
function Flagpickupable:OnPickup(pickupguy)
	self.inst.Transform:SetPosition(0,0,0)
	self.inst:PushEvent("onpickup", {owner = pickupguy})
	if self.onpickupfn and type(self.onpickupfn) == "function" then
		return self.onpickupfn(self.inst, pickupguy)
	end
end
return Flagpickupable
