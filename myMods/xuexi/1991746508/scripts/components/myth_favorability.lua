
local function onjifen(self,jifen)
	if jifen ~= 0 then
		if jifen >= 150 then
			self.inst.myth_tech_change_bonus = 7
		elseif	jifen >= 100 then
			self.inst.myth_tech_change_bonus = 6
		elseif	jifen >= 50 then
			self.inst.myth_tech_change_bonus = 4	
		elseif	jifen >= 20 then
			self.inst.myth_tech_change_bonus = 2			
		end
	end
end

local Myth_Favorability = Class(function(self, inst)
    self.inst = inst
	inst.myth_tech_change_bonus = 0
    self.jifen = 0
    self.banned = false
    self.task = nil
end,
nil,
{
	jifen = onjifen,
})

local function stopchester(inst, self)
    self.task = nil
    self.targettime = nil
	self.banned = false
end

local maxtime = 2*480
function Myth_Favorability:Ban()
	if not self.banned then
		self.banned = true
		self.targettime = GetTime() + maxtime
		if self.task ~= nil then
			self.task:Cancel()
		end
		self.task = self.inst:DoTaskInTime(maxtime, stopchester, self)
	end
end

function Myth_Favorability:IsMax()
    return self.jifen >= 150
end

function Myth_Favorability:DoDelta(delta)
	if self:IsMax() then return end
    self.jifen = math.min(self.jifen + delta, 150)
end
	
function Myth_Favorability:IsBanned()
	return self.banned
end

function Myth_Favorability:OnSave()
	local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
	return { jifen = self.jifen, remainingtime = remainingtime > 0 and remainingtime or nil,}
end

function Myth_Favorability:OnLoad(data)
    if data ~= nil then
		if data.jifen then
			self.jifen = data.jifen
		end
		if data.remainingtime ~= nil then
			self.banned = true
			self.targettime = GetTime() + math.max(0, data.remainingtime)
			self.task = self.inst:DoTaskInTime(data.remainingtime, stopchester, self)
		end
	end
end

return Myth_Favorability
