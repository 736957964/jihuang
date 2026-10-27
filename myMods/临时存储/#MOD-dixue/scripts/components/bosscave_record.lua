return Class(function(self, inst)

assert(TheWorld.ismastersim, "bosscave_record should not exist on client")

	self.inst = inst
	
	self.count = 0

function self:Set()
	self.count = self.count + 1
end

function self:Get()
	return self.count
end

end)