--[[玩家升级组件]]--

local function showLevelUp(player, level) --显示升级效果
	
	local x,y,z = player.Transform:GetWorldPosition()
	local fx = SpawnPrefab("die_fx")
	fx.Transform:SetPosition(x, y, z)
	local playerscale = player.Transform:GetScale()
	local currentscale = fx.Transform:GetScale()
	fx.Transform:SetScale(currentscale*playerscale*2,currentscale*playerscale*2,currentscale*playerscale*2)
	
	if player.components.talker then
		local colour = {0,0,0,1}
		colour[1],colour[2],colour[3] = HexToPercentColor("#E80607")
		local speech = ""
		if level == player.maxLevel then
			speech = "Level Max"
		else
			speech = "Level Up "..level
		end
		player.components.talker:Say(speech, 
		5,
		nil,
		nil,
		nil,
		colour
		)
	end
	
end

local function showGrowExp(player, exp_value) --显示增加经验效果
	if player.components.talker then
	--Say(script, time, noanim, force, nobroadcast, colour)
		local colour = {0,0,0,1}
		colour[1],colour[2],colour[3] = HexToPercentColor("#E9E806")
		player.components.talker:Say("EXP +"..exp_value.."  "..player.currentExp.."/"..player.maxExp, 
		2,
		nil,
		nil,
		nil,
		colour
		)
	end
end

local function showMaxLevelInfo(player)
	if player.components.talker then
	--Say(script, time, noanim, force, nobroadcast, colour)
		local colour = {0,0,0,1}
		colour[1],colour[2],colour[3] = HexToPercentColor("#E80607")
		player.components.talker:Say("Level Max", 
		1,
		nil,
		nil,
		nil,
		colour
		)
	end
end

local RP_UpGrade = Class(function(self, inst)
	self.inst = inst
	self.inst.canUpGrade = false
	self.inst.maxExp = 5 --当前等级对应的最大经验值
	self.inst.maxLevel = 30
	self.inst.currentExp = 0
	self.inst.currentLevel = 1
	
end)

function RP_UpGrade:make() --设置能升级
	self.inst.canUpGrade = true
	
end

function RP_UpGrade:growExp(exp_value) --增加玩家经验
	
	if self.inst.currentLevel < self.inst.maxLevel then
		self.inst.currentExp = self.inst.currentExp + exp_value
		
		local exp_offset = self.inst.currentExp - self.inst.maxExp 
		
		if exp_offset >= 0 then
			
			self:setLevel(self:getLevel() + 1)
			self:setMaxExpByLevel(self:getLevel())
			self.inst.components.rp_buff:LevelUp(self:getLevel())
			
			while(exp_offset > self:getMaxExpByLevel(self:getLevel())) --判断经验值有没有溢出
			do
				exp_offset = exp_offset - self:getMaxExpByLevel(self:getLevel())
				self:setLevel(self:getLevel() + 1)
				self:setMaxExpByLevel(self:getLevel())
				self.inst.components.rp_buff:LevelUp(self:getLevel())
			end
			self.inst.currentExp = 0 + exp_offset --如果升级则重置当前经验
			
			showLevelUp(self.inst, self.inst.currentLevel)
		else
			showGrowExp(self.inst, exp_value)
		end
	else
		showMaxLevelInfo(self.inst)
	end
end

function RP_UpGrade:setLevel(level_value) 
	if level_value <= self.inst.maxLevel then --确保等级不超过最高等级
		self.inst.currentLevel = level_value
	else
		self.inst.currentLevel = self.inst.maxLevel
	end
end

function RP_UpGrade:getLevel() --获取当前等级
	return self.inst.currentLevel
end

function RP_UpGrade:setMaxExpByLevel(current_level) --根据等级来决定当前等级的最大经验值

	self.inst.maxExp = self:getMaxExpByLevel(current_level)
	
end

function RP_UpGrade:getMaxExpByLevel(current_level)
	local max_exp = 0
	
	if current_level <= 5 then
		max_exp = current_level * 5
	elseif current_level < self.inst.maxLevel then
		max_exp = current_level * 10 - 25
	else
		max_exp = 10000
	end
	
	return max_exp
end

function RP_UpGrade:killed(player, monster) --根据击杀的怪物类型和玩家类型来确定增加的经验值
	if player.prefab ~= "wathgrithr" then
		if monster:HasTag("hostile") or monster:HasTag("rp_monster") then
			if monster:HasTag("exp_level_1") then
				self:growExp(1)	
			elseif monster:HasTag("exp_level_2") then
				self:growExp(2)
			elseif monster:HasTag("exp_level_3") then
				self:growExp(3)
			elseif monster:HasTag("exp_level_4") then
				self:growExp(4)
			elseif monster:HasTag("exp_boss_1") then
				self:growExp(20)
			elseif monster:HasTag("exp_boss_2") then
				self:growExp(100)
			elseif monster:HasTag("exp_boss_3") then
				self:growExp(100)
			elseif monster:HasTag("exp_boss_4") then
				self:growExp(200)
			elseif monster:HasTag("rp_monster_king") then
				self:growExp(100)
			end
		end
	else
		if monster:HasTag("hostile") or monster:HasTag("rp_monster") then
			if monster:HasTag("exp_level_1") then
				self:growExp(1)	
			elseif monster:HasTag("exp_level_2") then
				self:growExp(1)
			elseif monster:HasTag("exp_level_3") then
				self:growExp(2)
			elseif monster:HasTag("exp_level_4") then
				self:growExp(2)
			elseif monster:HasTag("exp_boss_1") then
				self:growExp(20)
			elseif monster:HasTag("exp_boss_2") then
				self:growExp(100)
			elseif monster:HasTag("exp_boss_3") then
				self:growExp(100)
			elseif monster:HasTag("exp_boss_4") then
				self:growExp(200)
			elseif monster:HasTag("rp_monster_king") then
				self:growExp(100)
			end
		end
	end
end

function RP_UpGrade:OnSave()
	return
	{
		canUpGrade = self.inst.canUpGrade,
		maxExp = self.inst.maxExp,
		currentExp = self.inst.currentExp,
		currentLevel = self.inst.currentLevel,
	}
end

function RP_UpGrade:OnLoad(data)
	if data ~= nil then
		self.inst.canUpGrade = data.canUpGrade
		self.inst.maxExp = data.maxExp
		self.inst.currentExp = data.currentExp
		self.inst.currentLevel = data.currentLevel
	end
end

return RP_UpGrade