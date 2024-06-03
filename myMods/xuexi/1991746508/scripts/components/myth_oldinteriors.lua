
local function onold(self,old)
	if not old then
		self.inst:RemoveTag("myth_oldinteriors")
		self.inst.AnimState:PlayAnimation("new")
	else
		self.inst:AddTag("myth_oldinteriors")
	end
end

local function onnew(self,new)
	if new and self.onnew then
		self.onnew(self.inst,self.first)
	end
end

local myth_oldinteriors = Class(function(self, inst)
	self.inst = inst
	self.onusefn = nil
	self.old = true
	self.new = false
	self.first = false
end,
nil,
{
	old = onold,
	new = onnew,
}
)

function myth_oldinteriors:SetNew(first)
	self.first = first
	self.new = true
end

function myth_oldinteriors:SetOnClearFn(fn)
	self.onclearfn = fn
end

function myth_oldinteriors:OnClear(doer)
	self.old = false
	if self.onclearfn then
		self.onclearfn(self.inst,doer)
	end
	return true
end

function myth_oldinteriors:OnSave()
	return { old = self.old, new = self.new }
end

function myth_oldinteriors:OnLoad(data)
	if data then
		if  data.old ~= nil then
			self.old = data.old
		end
		if  data.new ~= nil then
			self.new = data.new
		end
	end
end

return myth_oldinteriors