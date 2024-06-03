
local laozo_qingniu_buff = Class(function(self, inst)
	self.inst = inst
	self.time = 3*480
	self.canspawnya = true
end)

local function donetime(inst,self)
    self.task = nil
    self.targettime = nil
    self.canspawnya = true
end

function laozo_qingniu_buff:OnSpawn()
	self.canspawnya = false
    self.targettime = GetTime() + self.time
    if self.task ~= nil then
        self.task:Cancel()
    end
    self.task = self.inst:DoTaskInTime(self.time, donetime, self)	
end

function laozo_qingniu_buff:OnSave()
    --local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return
    {
        --canspawnya = self.canspawnya,
		rideable = self.inst.components.rideable ~= nil and self.inst.components.rideable:OnSaveDomesticatable() or nil,
    }
end

function laozo_qingniu_buff:OnLoad(data)
    if data ~= nil then
        if self.inst.components.rideable ~= nil then
            self.inst.components.rideable:OnLoadDomesticatable(data.rideable)
        end
	end
end
return laozo_qingniu_buff
