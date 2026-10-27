
local myth_rhino_team = Class(function(self, inst)
    self.inst = inst
    self.cd = 40
	self.needleave = 0 
	self.state = 1
    self.rhinos = {}
	self.OnDeath = function(rhino)
		if self.state == 2 then
			self:ReAttack(rhino)
		end
	end

	self.CheckPlayer = function() 
		local pos = self.inst:GetPosition()
		local ents = TheSim:FindEntities(pos.x, 0, pos.z, 28,{"player"} , {"playerghost"})
		if #ents > 0 then
			self.needleave = 0
		else
			self.needleave = self.needleave + 1
		end
		if self.needleave > 15 then
			self:Leave()
		end
	end
end)

function myth_rhino_team:ReStart()
	if self.changetask then
		self.changetask:Cancel()
		self.changetask = nil
	end
	self.rhinos = {}
	self.state = 1
	self.needleave = 0 
end

function myth_rhino_team:Start()
	if self.attacktask then
		self.attacktask:Cancel()
	end
	local state = math.random(3)
	for k, v in pairs(self.rhinos) do
		if k:IsValid() and not k.components.health:IsDead() then
			k:SetStage(state)
			state = state + 1 
			if state > 3 then
				state = 1
			end
		end
	end
	self.changetask = self.inst:DoPeriodicTask(self.cd, function()
		self:ChangeState()
	end,self.cd)

    self.inst:DoPeriodicTask(1, self.CheckPlayer, 1)
end

function myth_rhino_team:Pause()
	if self.changetask then
		self.changetask:Cancel()
		self.changetask = nil
	end
end

function myth_rhino_team:Rework()
	if self.changetask then
		self.changetask:Cancel()
	end
	self.state = 2
	self:ChangeState(true)
	self.changetask = self.inst:DoPeriodicTask(self.cd, function()
		self:ChangeState()
	end,self.cd)
end

function myth_rhino_team:ChangeState(noanim)
	if self.state == 1 then
		for k, v in pairs(self.rhinos) do
			if k:IsValid() and not k.components.health:IsDead() then
				local new = k.stage + 1
				if new > 3 then
					new = 1
				end
				k.sg:GoToState("newstate",new)
			end
		end
	else
		local isyou  = nil
		for k1 = 3,1,-1 do 
			for k, v in pairs(self.rhinos) do
				if k:IsValid() and not k.components.health:IsDead() and k.stage == k1  then
					isyou = k
					break
				end
			end
			if isyou ~= nil then
				break
			end
		end
		if isyou ~= nil then 
			for k, v in pairs(self.rhinos) do
				if k:IsValid() then
					local new = k == isyou and 1  or  k.stage + 1
					if new > 3 then
						new = 1
					end
					if noanim then
						k.components.combat:DropTarget()
						k:SetStage(new)
					else
						k.sg:GoToState("newstate",new)
					end
				end
			end
		end
	end
end

function myth_rhino_team:AddTeammate(rhino)
	self.rhinos[rhino] = true
	self.inst:ListenForEvent('death', self.OnDeath, rhino)
end

function myth_rhino_team:Leave()
	for k, v in pairs(self.rhinos) do
		if k:IsValid() and not k.components.health:IsDead() then
			SpawnPrefab("mk_cloudpuff").Transform:SetPosition(k.Transform:GetWorldPosition())
			k:Remove()
		end
	end
	self:ReStart()
end

function myth_rhino_team:ReAttack(rhino)
	if not rhino.resurrected then
		self.inst:RemoveEventCallback('death', self.OnDeath, rhino)
		self.rhinos[rhino] = nil
	end

	if next(self.rhinos) == nil then
		if self.changetask then
			self.changetask:Cancel()
			self.changetask = nil
		end
		return 
	end
	local needtochange = true
	for k, v in pairs(self.rhinos) do
		if k:IsValid() and not k.components.health:IsDead() and k.stage == 1  then
			needtochange = false
			break
		end
	end	 
	if needtochange then
		self:ChangeState(true)
		if self.changetask then
			self.changetask:Cancel()
		end
		self.changetask = self.inst:DoPeriodicTask(self.cd, function()
			self:ChangeState()
		end,self.cd)
	end
end

return myth_rhino_team
