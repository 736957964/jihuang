

local myth_useitem = Class(function(self, inst)
    self.inst = inst
end)

function myth_useitem:SetUseFn(fn)
    self.onuse = fn
end

function myth_useitem:Use(target,doer)
    if self.onuse ~= nil then
        self.onuse(self.inst,target,doer)
    end
end
return myth_useitem