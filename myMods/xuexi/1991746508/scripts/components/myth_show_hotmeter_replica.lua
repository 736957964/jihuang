

local myth_show_hotmeter = Class(function(self, inst)
    self.inst = inst
    self.current = net_byte(inst.GUID, "myth_show_hotmeter", "hotmeterdirty")
    if not TheWorld.ismastersim then
        self.inst:ListenForEvent("hotmeterdirty", function()
            self.inst:PushEvent("hotmeterchange", self:GetCurrent())
        end)
    end
end)

function myth_show_hotmeter:SetCurrent(charge)
    self.current:set(charge)
end

function myth_show_hotmeter:GetCurrent()
    return self.current:value()
end

return myth_show_hotmeter