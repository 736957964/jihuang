local Flash = Class(function(self, inst)
	self.inst = inst

	self.damage = {}
	self.flash_threshold = 300
	self.flash_period = 1
	self.flash_cooldown = 10
	self.valid_flash_time = 0

	self.inst:ListenForEvent("healthdelta", function(inst, data) self:TakeDamage(data.amount) end)
end)

function Flash:Do()
	self.damage = {}
	self.valid_flash_time = GetTime() + self.flash_cooldown
	self.inst:PushEvent("flash")
end

function Flash:TakeDamage(damage)
	if GetTime() < self.valid_flash_time then return end

	self.damage[GetTime()] = math.abs(damage)
	
	if self:GetDamageInPeriod() > self.flash_threshold then
		self:Do()
	end
end

function Flash:GetDamageInPeriod()
	local totaldamage = 0
	local toremove = {}

	for k,v in pairs(self.damage) do

		if k + self.flash_period > GetTime() then			
			totaldamage = totaldamage + v		
		else		
			table.insert(toremove, k)		
		end
	end

	for k,v in pairs(toremove) do
		self.damage[v] = nil
	end

	return totaldamage
end

return Flash