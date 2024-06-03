--[[怪物防御性 Monster Defensive]]--

local RP_Defensive = Class(function(self, inst)
	self.inst = inst
	self.inst.isDefensive = false
	self.inst.makeType = 0
	self.inst.isLittleBrother = false
end)

--生成国王
local function makeKing(inst)
	
	local monster = inst
	
	monster:AddTag("shadowboss")
	monster:AddTag("rp_monster")
	monster:AddTag("rp_monster_king")
	monster:AddTag("wave_monster")
	monster:AddTag("houndedKiller")
	monster:AddTag("hostile")
	--monster:AddTag("INLIMBO")
	--monster:AddTag("insect")
	
	monster:AddTag("pointed_monster_king")
	--monster:AddTag("pointed_monster")
	
	if monster.prefab == "bunnyman" then
		if not monster.components.rp_bunnymanking then
			--monster:DoTaskInTime(0, function()
				monster:AddComponent("rp_bunnymanking")
				monster:DoTaskInTime(0, function()
					monster.components.rp_bunnymanking:start()
				end)
			--end)
		end
	elseif monster.prefab == "pigman" then
		if not monster.components.rp_pigmanking then
			--monster:DoTaskInTime(0, function()
				monster:AddComponent("rp_pigmanking")
				monster:DoTaskInTime(0, function()
					monster.components.rp_pigmanking:start()
				end)
			--end)
		end
	elseif monster.prefab == "merm" then
		if not monster.components.rp_mermking then
			monster:DoTaskInTime(0, function()
				monster:AddComponent("rp_mermking")
			end)
		end
	elseif monster.prefab == "rocky" then
		if not monster.components.rp_rockyking then
			monster:DoTaskInTime(0, function()
				monster:AddComponent("rp_rockyking")
			end)
		end
	elseif monster.prefab == "pigguard" then
		if not monster.components.rp_pigbigbrotherking then
			monster:DoTaskInTime(0, function()
				if monster:HasTag("little_pig") then --区分是大的还是小的
					monster:AddComponent("rp_piglittlebrotherking")
					monster.isLittleBrother = true
				else
					monster:AddComponent("rp_pigbigbrotherking")
				end
				
			end)
		end
	elseif monster.prefab == "leif_sparse" then
		if not monster.components.rp_pigbigbrotherking then
			monster:DoTaskInTime(0, function()
				monster:AddComponent("rp_leifking")
			end)
		end		
	end
	
	--死亡后执行复活计时
	if monster.prefab == "pigman" then
	
		--TheWorld:PushEvent("rp_kingbekilled", data)
		monster:ListenForEvent("death", function()
			SpawnPrefab("lightning")
		end)
		
	elseif monster.prefab == "pigguard" then
	
		monster:ListenForEvent("death", function()
			SpawnPrefab("lightning")
			--杀完最后一个才开启计时
			monster:RemoveTag("PigBrother")
			local myborther = TheSim:FindFirstEntityWithTag("PigBrother")
			if myborther then
				myborther:AddTag("rp_only_one")
				myborther:PushEvent("rp_brotherbekilled")
			end
			
			if monster:HasTag("rp_only_one") then
	
				local data = {}
				data.name = monster.prefab
				TheWorld:PushEvent("rp_kingbekilled", data)
				
			end
			
		end)
		
	else
	
		monster:ListenForEvent("death", function()
			SpawnPrefab("lightning")
			local data = {}
			--if monster.prefab == "merm" then
			--	data.name = "bunnyman"
			--elseif monster.prefab == "bunnyman" then
			--	data.name = "merm"
			--end
			data.name = monster.prefab
			TheWorld:PushEvent("rp_kingbekilled", data)
			TheWorld:PushEvent("rp_over_allnight", data)
		end)
		
	end
	
	--local r, g, b = HexToPercentColor("#FF0705")
	--设置怪物颜色
	--monster.AnimState:SetMultColour(r, g, b, 1)	
end

--生成指挥官
local function makeCommander(inst)
	
	--monster.AnimState:OverrideSymbol("swap_hat", "hat_slurtle", "swap_hat")
	--monster.AnimState:Show("HAT")
	--monster.AnimState:Show("HAT_HAIR")
	--monster.AnimState:Hide("HAIR_NOHAT")
	--monster.AnimState:Hide("HAIR")
	
end

--生成小兵
local function makeMob(inst)

end

--根据传入的值生成相应类型的怪
function RP_Defensive:Make(make_type)
	local monster = self.inst
	if make_type == DEFENSIVE_MOB then
		makeMob(monster)
		self.inst.makeType = DEFENSIVE_MOB
		self.inst.isDefensive = true
	elseif make_type == DEFENSIVE_COMMANDER then
		makeCommander(monster)
		self.inst.makeType = DEFENSIVE_COMMANDER
		self.inst.isDefensive = true
	elseif make_type == DEFENSIVE_KING then
		makeKing(monster)
		self.inst.makeType = DEFENSIVE_KING
		self.inst.isDefensive = true
	end
end

function RP_Defensive:OnSave()
	
	return
	{
		
		isDefensive = self.inst.isDefensive,
		makeType = self.inst.makeType,
		isLittleBrother = self.inst.isLittleBrother
		
	}
end

function RP_Defensive:OnLoad(data)
	if data ~= nil then
		self.inst.isDefensive = data.isDefensive
		self.inst.makeType = data.makeType
		if data.isLittleBrother then --加载时判断是不是小的
			self.inst:AddTag("little_pig")
		end
		if self.inst.isDefensive then 
			self:Make(self.inst.makeType)
		end
		
	end
end

return RP_Defensive