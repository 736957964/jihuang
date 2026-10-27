local assets =
{
	Asset("ANIM", "anim/myth_plant_lotus.zip"),
}

local prefabs =
{

}

local function Set1(inst)
	if inst.components.pickable then
		inst.components.pickable.canbepicked = false
		inst.components.pickable.lootdrops = {}
	end
	inst.AnimState:PlayAnimation("grow_sprout",true)
	inst.AnimState:PushAnimation("lotus_sprout")
	inst.AnimState:SetTime(math.random()*2)
	inst.components.shaveable:SetPrize("myth_lotusleaf", 0)
end

local function Grow1(inst)
end

local function Set2(inst)
	if inst.components.pickable then
		inst.components.pickable.canbepicked = false
		inst.components.pickable.lootdrops = {}
	end
	inst.AnimState:PlayAnimation("grow_small",true)
	inst.AnimState:PushAnimation("lotus_small")
	inst.AnimState:SetTime(math.random()*2)
end

local function Grow2(inst)
end

local function Set3(inst)
	if inst.components.pickable then
		inst.components.pickable.canbepicked = false
		inst.components.pickable.lootdrops = {}
	end
	inst.AnimState:PlayAnimation("grow_med",true)
	inst.AnimState:PushAnimation("lotus_med")
	inst.AnimState:SetTime(math.random()*2)
	inst.components.shaveable:SetPrize("myth_lotusleaf", 0)
end

local function Grow3(inst)
end

local function Set4(inst)
	inst.components.pickable.canbepicked = true
	inst.components.pickable.lootdrops = {}
	inst.components.pickable:SetUp("myth_lotus_flower")
	for k =1,math.random(2) do 
		table.insert(inst.components.pickable.lootdrops,"myth_lotus_flower")
	end
	inst.components.shaveable:SetPrize("myth_lotusleaf", math.random(2))

	inst.AnimState:PlayAnimation("grow_full",true)
	inst.AnimState:PushAnimation("lotus_full")
	inst.AnimState:SetTime(math.random()*2)

end

local function Grow4(inst)
end

local function Set5(inst)
	inst.components.pickable.canbepicked = true
	inst.components.pickable.lootdrops = {}
	inst.components.pickable:SetUp("lotus_root")
	for k =1,math.random(2) do 
		table.insert(inst.components.pickable.lootdrops,"lotus_root")
	end
	for k =1,math.random(2,3) do
		table.insert(inst.components.pickable.lootdrops,"lotus_seeds")
	end
	inst.AnimState:PlayAnimation("grow_rot",true)
	inst.AnimState:PushAnimation("lotus_rot")
	inst.AnimState:SetTime(math.random()*2)
	inst.components.shaveable:SetPrize("myth_lotusleaf", 0)
end

local function Grow5(inst)
end

local growth_stages =
{
	{name="1", time = function() return 2*480 + math.random(100) end, fn = function(inst) Set1(inst) end,  growfn = function(inst) Grow1(inst) end },
	{name="2", time = function() return 2*480 + math.random(100) end , fn = function(inst) Set2(inst) end,  growfn = function(inst) Grow2(inst) end },
	{name="3", time = function() return 2*480 + math.random(100) end , fn = function(inst) Set3(inst) end,  growfn = function(inst) Grow3(inst) end },
	{name="4", time = function() return 3.5*480 + math.random(100) end , fn = function(inst) Set4(inst) end,  growfn = function(inst) Grow4(inst) end },
	{name="5", time = function() return 3.5*480 + math.random(100) end , fn = function(inst) Set5(inst) end,  growfn = function(inst) Grow5(inst) end },
}

local function onpicked(inst,picker)
	if inst.components.pickable.lootdrops ~= nil then
		for i, v in ipairs(inst.components.pickable.lootdrops) do
			local loot = SpawnPrefab(v)
			if loot ~= nil then
				if loot.components.inventoryitem ~= nil then
					loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
				end
				picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
				picker:PushEvent("picksomething", { object = inst, loot = loot })
			end
		end
	end
	if inst.components.growable then
		inst.components.growable:DoPickGrowth()
	end
end

local function on_shaved(inst, shaver, shave_item)
    if inst.components.pickable ~= nil then
        inst.components.pickable:Pick(shaver)
    end
end


local function AttachEffect(inst,effect)
    effect.entity:SetParent(inst.entity)
    effect.Transform:SetPosition(0, 0.3, 0)
end

local function onnear(inst)
	if TUNING.MYTH_SIVING_BOSS ~= nil then 
		return
	end
	if inst.components.growable and inst.components.growable.stage ~= 4 then
		return
	end
	if  TheWorld.state.isnight then
		return
	end
    if TheWorld.components.siving_boss_timer  and TheWorld.components.siving_boss_timer:CanSpawn() and math.random() < 0.5  then
		local boss = SpawnPrefab("myth_siving_boss")
        boss:DoSpawn(inst:GetPosition())
    end
end

local function ongrow(inst, self)
    self:DoGrowth()
end

local function StartGrowing(self,time)
    self.usetimemultiplier = false
    if #self.stages == 0 then
        return
    end

    if self.stage <= #self.stages then
        self:StopGrowing()

        local timeToGrow = 10
        if time ~= nil then
            timeToGrow = time
        elseif self.stages[self.stage].time ~= nil then
            timeToGrow = self.stages[self.stage].time(self.inst, self.stage, self.stages[self.stage])
            if self.stages[self.stage].multiplier then
                self.usetimemultiplier = true
            end
        end

        if timeToGrow ~= nil then
            if TheWorld.state.issummer then
                timeToGrow = timeToGrow * TUNING.SPRING_GROWTH_MODIFIER
            end
            self.targettime = GetTime() + timeToGrow

            if self.growoffscreen or not self.inst:IsAsleep() then
                if self.task ~= nil then
                    self.task:Cancel()
                end
                self.task = self.inst:DoTaskInTime(timeToGrow, ongrow, self)
            end
        end
    end
end
local function makefn(stage, data)

	local function fn(Sim)

		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()

        inst.entity:AddNetwork()
		inst.entity:AddMiniMapEntity()
	
		inst:AddTag("plant")
		anim:SetBuild("myth_plant_lotus")
		anim:SetBank("myth_plant_lotus")
        inst:SetPrefabName("myth_plant_lotus")
        inst:AddTag("myth_plant_lotus")

		inst.AttachEffect = AttachEffect

        inst.front_fx = SpawnPrefab("float_fx_front")
        inst:AttachEffect(inst.front_fx)
        inst.front_fx.AnimState:PlayAnimation("idle_front_small", true)
        inst.back_fx = SpawnPrefab("float_fx_back")
        inst:AttachEffect(inst.back_fx)
        inst.back_fx.AnimState:PlayAnimation("idle_back_small", true)

		inst.MiniMapEntity:SetIcon("myth_lotus_flower.tex")  

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		inst:AddComponent("inspectable")
		--inst.components.inspectable.getstatus = inspect_treee

		inst:AddComponent("timer")

		inst:AddComponent("playerprox")
		inst.components.playerprox:SetDist(7, 9)
		inst.components.playerprox:SetOnPlayerNear(onnear)

		inst:AddComponent("lootdropper")
		---------------------
		inst:AddComponent("shaveable")
		inst.components.shaveable:SetPrize("myth_lotus_flower", 0)
		inst.components.shaveable.on_shaved = on_shaved

		inst:AddComponent("myth_lotus_pickable")
		inst.components.pickable = inst.components.myth_lotus_pickable
		inst.components.pickable.picksound  = "dontstarve/wilson/harvest_berries"
		inst.components.pickable:SetUp("peach")
		inst.components.pickable.canbepicked = false
		inst.components.pickable.lootdrops = {}
		inst.components.pickable.OnSave = function(self,data)
			return {}
		end
		inst.components.pickable.OnLoad = function(self,data)
			return
		end
		inst.components.pickable.Pick = function( self, picker)
			if self.canbepicked  then
				if self.onpickedfn ~= nil then
					self.onpickedfn(self.inst, picker)
				end
				self.canbepicked = false
			end
		end
		inst.components.pickable.onpickedfn = onpicked
		inst:RegisterComponentActions("pickable")
		
		--TheInput:GetWorldEntityUnderMouse().components.growable:DoGrowth()
		inst:AddComponent("growable")
		inst.components.growable.stages = growth_stages
		inst.components.growable:SetStage(stage)
		inst.components.growable.magicgrowable = true
		inst.components.growable.springgrowth = true
		inst.components.growable.StartGrowing = StartGrowing
		local old_StartGrowing = inst.components.growable.StartGrowing
		inst.components.growable.StartGrowing = function(self,time)
			if #self.stages == 0 or  self.stage >= #self.stages then
				return
			end
			old_StartGrowing(self,time)
		end
		inst.components.growable:StartGrowing()
		inst.components.growable.DoPickGrowth = function(self)
			local stage = 1
			self:SetStage(stage)
			if self.stages[stage] ~= nil and self.stages[stage].growfn ~= nil then
				self.stages[stage].growfn(self.inst)
			end
			if self.stage < #self.stages  then
				self:StartGrowing()
			end		
		end
		inst.components.growable.OnSave = function(self)
			local data =
			{
				stage = self.stage or nil,
				time = (self.pausedremaining ~= nil and math.floor(self.pausedremaining))
					or (self.targettime ~= nil and math.floor(self.targettime - GetTime()))
					or nil,
			}
			return next(data) ~= nil and data or nil
		end

        inst.AnimState:SetTime(math.random() * 2)

		return inst
	end
	return fn
end

local function tree(name, stage, data)
	return Prefab(name, makefn(stage, data), assets, prefabs)
end

return 
		tree("myth_plant_lotus", 1),
		tree("myth_plant_lotus_sprout", 2),
		tree("myth_plant_lotus_normal", 3),
		tree("myth_plant_lotus_tall",  4),
		tree("myth_plant_lotus_rot",  5)
