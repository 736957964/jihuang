


local function dig_up(inst, chopper)
    if inst.components.myth_lotus_grower then
        inst.components.myth_lotus_grower:DoDigCrop()
    end
end

local function oncrops(self,crops)
    if crops ~= nil then
        self.inst:RemoveTag("can_plant_lotus")
        if not self.inst.components.workable then
            self.inst:AddComponent("workable")
        end
        self.inst.components.workable:SetWorkAction(ACTIONS.DIG)
        self.inst.components.workable:SetOnFinishCallback(dig_up)
        self.inst.components.workable:SetWorkLeft(1)
    else
        if self.inst.components.workable then
            self.inst:RemoveComponent("workable")
        end
        self.inst:AddTag("can_plant_lotus")
    end
end

local Grower = Class(function(self, inst)
    self.inst = inst
    self.crops = nil
    self.first = true
    self.hasold = false
    inst:DoTaskInTime(0,function()
        if self.first then
            self.first = false
            if math.random() < 0.1 and self.crops == nil then
                self:PlanStart()
            end
        end
    end)

    self.snowlevel = function(inst, snowlevel)
        if snowlevel > .02 and TheWorld.state.iswinter and  self.crops ~= nil then
            inst.components.myth_lotus_grower:DoRemoveCrop()
        end
    end

	inst:ListenForEvent("onremove", function()
		if inst.lotus ~= nil then
			inst.lotus:Remove()
		end
	end)

    self.OnSeasonChange = function(inst,season)
        if season == "spring" and self.hasold then
            self.inst:DoTaskInTime(1,function()
                if  self:IsEmpty() then
                    self:PlantItem()
                end
            end)
        end
    end
    inst:WatchWorldState("snowlevel", self.snowlevel)
    self.snowlevel(inst, TheWorld.state.snowlevel)

    inst:WatchWorldState("season", self.OnSeasonChange)
end,
nil,
{
    crops = oncrops,
})

function Grower:IsEmpty()
    return self.crops == nil
end

function Grower:OnSave()
    local data = {crops = {}}
    if self.crops ~= nil then
        local save_record = self.crops:GetSaveRecord()
        table.insert(data.crops, save_record)
    end
    data.first = self.first
    data.hasold = self.hasold
    return data
end

function Grower:OnLoad(data, newents)
    if data.crops ~= nil then
        for k, v in pairs(data.crops) do
            self.isempty = false
            local child = SpawnSaveRecord(v, newents)
            if child ~= nil then
                self.inst:AddChild(child)
                child.Transform:SetPosition(0, 0, 0)
                self.crops = child
            end
        end
    end
    self.first = data.first
    if data.hasold then
        self.hasold = data.hasold
    end
end

function Grower:PlantItem(item, doer)
    self:Reset()
    local pos = self.inst:GetPosition()

    local plant1 = SpawnPrefab("myth_plant_lotus")
    self.inst:AddChild(plant1)
    plant1.Transform:SetPosition(0, 0, 0)
    
    self.crops = plant1
    if item then
        item.components.stackable:Get():Remove()
    end
    --TheWorld:PushEvent("itemplanted", { doer = doer, pos = pos })
    return true
end

function Grower:PlanStart()
    self:PlantItem()
end

function Grower:DoRemoveCrop()
    if self.crops ~= nil then 
        local loot = SpawnPrefab("spoiled_food")
        if loot then
            loot.Transform:SetPosition(self.crops:GetPosition():Get())
        end
        self.hasold = true
        self.crops:Remove()
        self.crops = nil
    end
end

function Grower:DoDigCrop()
    if self.crops ~= nil then
        if self.crops.components.lootdropper and self.crops.components.pickable and self.crops.components.pickable.lootdrops ~= nil then
            for i, v in ipairs(self.crops.components.pickable.lootdrops) do
                self.crops.components.lootdropper:SpawnLootPrefab(v)
            end
        end
        self.crops:Remove()
        self.crops = nil
    end
end

function Grower:RemoveCrop(crop)
    crop:Remove()
    self.crops = nil
end

function Grower:Reset(reason)
    self.hasold = false
    self.crops = nil
end

return Grower
