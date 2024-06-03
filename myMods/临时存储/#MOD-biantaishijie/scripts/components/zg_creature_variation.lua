local function onvariationfn(inst)
	if inst.SoundEmitter then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/lucy_warn_"..math.random(3) )
	end
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("statue_transition").Transform:SetPosition(x,y,z)
end

local Zg_creature_variation = Class(function(self, inst)
    self.inst = inst 
	self.time = nil
	self.remainingtime = nil
	self.chance = 1
	self.updatetask = nil
	self.onvariationreplacement = nil
	self.variationfn = onvariationfn
end)

local function Update(inst, dt)
	local delta = dt or (10 + math.random()*FRAMES*8)
	if inst.components.zg_creature_variation.remainingtime then 
		inst.components.zg_creature_variation.remainingtime = inst.components.zg_creature_variation.remainingtime - delta
		
		----当一个变异周期度过时, 如果在变异几率内则变异, 否则进入新的变异周期
		if inst.components.zg_creature_variation.remainingtime <= 0 then
			if math.random() < inst.components.zg_creature_variation.chance and
				not ( inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() )
			then
				inst.components.zg_creature_variation:Variation()
			else
				inst.components.zg_creature_variation.remainingtime = inst.components.zg_creature_variation.time
			end
        end
		
	end
end

function Zg_creature_variation:StartVariation()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end

    local dt = 10 + math.random() * FRAMES * 8
    self.updatetask = self.inst:DoPeriodicTask(dt, Update, math.random() * 2, dt)
end

function Zg_creature_variation:Variation()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end

	----变异特效
    if self.variationfn ~= nil then
        self.variationfn(self.inst)
    end

    if self.onvariationreplacement ~= nil then
		
		local goop = nil
		
		if type(self.onvariationreplacement) ~= "table" then
			goop = SpawnPrefab(self.onvariationreplacement)
		else
			----权重
			local quan = 0
			for k, v in pairs(self.onvariationreplacement) do
				quan = quan + v
			end
			
			local pickpoint = math.random()		--概率因子
			local chance = 0
			for k, v in pairs(self.onvariationreplacement) do
				chance = chance + v/quan
				if pickpoint < chance then		--pickpoint小于 比重时说明在对应区域内
					goop = SpawnPrefab(k)
					break
				end
			end
		end
		
        if goop then
			local x, y, z = self.inst.Transform:GetWorldPosition()
			
			----变异之后触发原体死亡事件
			if self.inst.components.health then
				self.inst:AddTag("zg_no_dmgid")
				self.inst.components.health.destroytime = .1
				--self.inst.components.health:Kill()
				self.inst:Remove()
			end
			if self.inst.components.lootdropper then
				--self.inst.components.lootdropper.GenerateLoot = function() return {} end
				self.inst:Remove()
			end
			
			goop.Transform:SetPosition(x, y, z)
        end
    end
end

function Zg_creature_variation:SetVariationTime(time)
	self.time = time
	self.remainingtime = time
    if self.updatetask ~= nil then
        self:StartVariation()
    end
end

function Zg_creature_variation:OnRemoveEntity()
	self:StopVariation()
end

function Zg_creature_variation:OnEntitySleep()
    self:StopVariation()
end

function Zg_creature_variation:OnEntityWake()
    self:StartVariation()
end

function Zg_creature_variation:StopVariation()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
end

return Zg_creature_variation








