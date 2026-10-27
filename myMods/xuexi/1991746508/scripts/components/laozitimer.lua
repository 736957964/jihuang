
local LaoziTimer = Class(function(self, inst)
	self.inst = inst
	self.time = 3*480
	self.canspawnya = true
end)

local function donetime(inst,self)
    self.task = nil
    self.targettime = nil
    self.canspawnya = true
end

function LaoziTimer:OnSpawn()
	self.canspawnya = false
    self.targettime = GetTime() + self.time
    if self.task ~= nil then
        self.task:Cancel()
    end
    self.task = self.inst:DoTaskInTime(self.time, donetime, self)	
end

function LaoziTimer:OnSave()
    local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return
    {
        canspawnya = self.canspawnya,
        remainingtime = remainingtime > 0 and remainingtime or nil,
    }
end

function LaoziTimer:OnLoad(data)
    if data.canspawnya ~= nil then
		self.canspawnya = data.canspawnya
        if data.remainingtime ~= nil and self.canspawnya == false then
            self.targettime = GetTime() + math.max(0, data.remainingtime)
            self.task = self.inst:DoTaskInTime(data.remainingtime, donetime, self)
		end
	end
end
function LaoziTimer:LongUpdate(dt)
	if self.canspawnya == false and self.targettime ~= nil then
		if self.task ~= nil then
			self.task:Cancel()
		end
		if self.targettime - dt > GetTime() then
			self.targettime = self.targettime - dt
			self.task = self.inst:DoTaskInTime(self.targettime - GetTime(), donetime, self)
			dt = 0 
		else
			dt = dt - self.targettime + GetTime()
			donetime(self.inst, self)
		end
	end
end

return LaoziTimer
