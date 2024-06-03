local function oncharge(self,charge)
	self.inst.replica.myth_show_hotmeter:SetCurrent(charge)
end
local myth_show_hotmeter = Class(function(self, inst)
    self.inst = inst
    self.charge = 0
    self.maxcharge = 100
    self.cooldowntime = TUNING.TOTAL_DAY_TIME / 100
    self.cooltimer = 0

	self.updating = false

    self.red_threshold = 0.90
    self.orange_threshold = 0.66
    self.yellow_threshold = 0.33
    self.normal_threshold = 0.01
end,
nil,
{
	charge = oncharge
})

function myth_show_hotmeter:Start()
	if not self.updating then
		self.updating = true
		self.inst:StartUpdatingComponent(self)
	end
end

function myth_show_hotmeter:Stop()
	if self.updating then
		self.updating = false
		self.inst:StopUpdatingComponent(self)
	end
end

function myth_show_hotmeter:OnSave()
	return
	{
		charge = self.charge
	}
end

function myth_show_hotmeter:GetPercent()
	return self.charge/self.maxcharge
end

function myth_show_hotmeter:OnLoad(data)
	self:SetCharge(data.charge or 0)
end

function myth_show_hotmeter:GetCharge()
	return self.charge, self.maxcharge
end

function myth_show_hotmeter:SetCharge(num)
	local old = self.charge
	self.charge = num

	if self.charge > 0 then
		self:Start()
	else
		self:Stop()
	end
	if old ~= self.charge and self.onchargedelta ~= nil then
		self.onchargedelta(self.inst,old,num)
	end
end

function myth_show_hotmeter:Ignite(doer, target)
	if target.SoundEmitter then
		target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
	end
	if target.components.burnable then
		target.components.burnable:Ignite()
	end
	if target.components.propagator then
		target.components.propagator:Flash()
	end
	if target.components.health then
		target.components.health:DoFireDamage(0)
	end
end

function myth_show_hotmeter:Use(doer, target)
	self:SetCharge(math.min(self.charge + 1.5, self.maxcharge))
	if self.charge >= self.maxcharge then
		self:Ignite(doer, target)
	end
	self.cooltimer = 0.0
end

function myth_show_hotmeter:OnUpdate(dt)
	self.cooltimer = self.cooltimer + dt
	if self.cooltimer >= self.cooldowntime then
		self:SetCharge(math.max(self.charge - 1, 0))
		self.cooltimer = 0.0
	end
end

return myth_show_hotmeter