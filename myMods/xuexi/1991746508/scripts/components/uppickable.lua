local function onpickable(self)
    if self.canbepicked then
        self.inst:AddTag("uppickable")
    else
        self.inst:RemoveTag("uppickable")
    end
end

local UpPickable = Class(function(self, inst)
    self.inst = inst
    self.canbepicked = false
    self.onpickedfn = nil
end,
nil,
{
    canbepicked = onpickable,
}
)

function UpPickable:OnRemoveFromEntity()
    self.inst:RemoveTag("uppickable")
end

function UpPickable:SetPickable(picked)
    if self.inst.components.pickable ~= nil then
        if self.canbepicked ~= picked
            or self.inst.components.pickable.caninteractwith ~= picked
            or self.inst.components.pickable.canbepicked ~= picked
        then
            self.canbepicked = picked
            self.inst.components.pickable.caninteractwith = picked
            self.inst.components.pickable.canbepicked = picked
        end
    end
end

function UpPickable:SetOnPickedFn(fn)
    self.onpickedfn = fn
end

function UpPickable:Pick(picker)
    if not self.canbepicked then
        return
    end

    self.canbepicked = false
    if self.inst.components.pickable ~= nil then
        self.inst.components.pickable.caninteractwith = false
        self.inst.components.pickable.canbepicked = false
    end

    if self.onpickedfn ~= nil then
        self.onpickedfn(self.inst, picker)
    end
end

return UpPickable
