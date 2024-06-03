local SavedRotation = Class(function(self, inst)
    self.inst = inst
    self.fanzhuan = 1
    inst:AddTag("_jianzhufanzhuan")
end)

function SavedRotation:OnSave()
    return self.fanzhuan ~= 1 and { fanzhuan = self.fanzhuan } or nil
end

function SavedRotation:OnLoad(data)
    if data.fanzhuan ~= 1 then
        self.fanzhuan = data.fanzhuan
        self.inst.AnimState:SetScale(self.fanzhuan,1,1)
    end
end

function SavedRotation:FanZzhuan()
    self.fanzhuan = -1 * self.fanzhuan
    self.inst.AnimState:SetScale(self.fanzhuan,1,1)
end

return SavedRotation
