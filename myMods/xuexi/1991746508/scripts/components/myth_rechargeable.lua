
local Rechargeable = Class(function(self, inst)
    self.inst = inst
    self.recharge = -2
    self.rechargetime = 255
	self.recharging = false
	self.target_time = nil
end)

function Rechargeable:SetRechargeTime(time)
	self.rechargetime = time  --totaltime
	self.recharge = 0
end

function Rechargeable:SetRechargeRate(fn)
	self.rechargingrate = fn
end

function Rechargeable:StartRecharging()
	self.recharging = true
	
	if self.target_time == nil then
		local rate = self.rechargingrate ~= nil and self.rechargingrate(self.inst)  or 1
		
		self.target_time = self.rechargetime * rate
	end
	if self.rechargingfn ~= nil then
		self.rechargingfn(self.inst)
	end
	self.inst:PushEvent("rechargechange", {percent = self:GetPercent()} )
	
	if self.inst.replica.inventoryitem ~= nil then
		self.inst.replica.inventoryitem:SetChargeTime(self:GetRechargeTime())
	end
	if self.inst.components.aoetargeting ~= nil  then  --turn off
		self.inst.components.aoetargeting:SetEnabled(false)
	end	
	
	self.inst:StartUpdatingComponent(self)
end

function Rechargeable:StopRecharging()
	self.inst:StopUpdatingComponent(self) -- to stop
	
	self.recharging = false
	self.recharge  = 0
	self.target_time = nil
	
	if self.stoprechargfn ~= nil then
		self.stoprechargfn(self.inst)
	end

	self.inst:PushEvent("rechargechange", {percent = self:GetPercent()} )

	if self.inst.components.aoetargeting ~= nil  then  --turn on
		self.inst.components.aoetargeting:SetEnabled(true)
	end
end

function Rechargeable:OnUpdate(dt)

	self.recharge = self.recharge + dt
	
	if self.recharge >= self.target_time then
		self:StopRecharging()
	end
end

function Rechargeable:GetPercent()
	if self.recharging == true  then
		return math.min(1, self.recharge / (self.target_time ~= nil and self.target_time or self.rechargetime ))
	else
		return 1
	end
end

function Rechargeable:GetDebugString()

	if self.recharging == true then
		return	string.format("percent: %2.2f ", self:GetPercent())
	else
		return "recharged"
	end
end

function Rechargeable:GetRechargeTime()
	return self.recharging == true  and (self.target_time ~= nil and self.target_time or self.rechargetime) or  0
end

function Rechargeable:OnSave()
    return
    {
        time = self.recharge,
		target_time = self.target_time
    }
end

function Rechargeable:OnLoad(data)
    if data ~= nil and data.time ~= nil and data.time ~= 0 then
		if data.target_time ~= nil then
			self.target_time = data.target_time
		end
        self.recharge = data.time
            self:StartRecharging()
    end
end

return Rechargeable