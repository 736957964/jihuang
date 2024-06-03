-- 采集加三维2024.05.29
local threeDimensional = Class(function(self, inst)
    self.inst = inst
    self.CollectionArray = {'cutgrass'}  -- 采集升级的配置项 {'twigs','twigs'}
    self.CollectionFrequency = 0 -- 记录采集次数
    self.upgradeDemand = 5  --采集升级要求次数
    self.level = 0
    self.maxLevel = 20 --最大升级.`
end)

function threeDimensional:OnSetStrengthen()
    self.inst:ListenForEvent("picksomething", function(inst,data)   
        
        if(self.CollectionArray ~= nil) then
            for i,key in pairs(self.CollectionArray) do
                if(data and data.loot and data.loot.prefab == self.CollectionArray[i]) then
                    if math.random() < 0.2 then
                        inst.components.inventory:GiveItem(SpawnPrefab(data.loot.prefab) ) 
                        if inst.components.talker then inst.components.talker:Say("金色传说") end
                    end
                    self.CollectionFrequency = self.CollectionFrequency + 1 -- 采集次数加1
                    if self.level < self.maxLevel then -- 不超出等级限制
                        while self.CollectionFrequency >= self.upgradeDemand do
                            self.CollectionFrequency = self.CollectionFrequency - self.upgradeDemand
                            self.level = self.level + 1
                            if inst.components.talker then inst.components.talker:Say("哇偶，升级了") end
                            self:OnLoadThree()
                        end
                    end
                end
            end
        end
    end)
end

function threeDimensional:setCollectionArray(data)
    self.CollectionArray = data
end

function threeDimensional:OnLoadThree()
    local _health =  self.inst.components.health
    if _health then 
        if _health.initMaxHealth == nil then _health.initMaxHealth  = _health.maxhealth end
        _health.maxhealth = _health.initMaxHealth +  self.level * 7
    end
    local _sanity = self.inst.components.sanity
    if _sanity then 
        if _sanity.initMax == nil then _sanity.initMax  = _sanity.max end
        _sanity.max = _sanity.initMax +  self.level * 2
    end
    local _hunger = self.inst.components.hunger
    if _hunger then 
        if _hunger.initMax == nil then _hunger.initMax  = _hunger.max end
        _hunger.max = _hunger.initMax +  self.level * 3
    end
end

 
local savaKey = {'CollectionFrequency','level'}
function threeDimensional:OnSave()
    local OnSaveData = {}
    for index,key in pairs(savaKey) do OnSaveData[key] = self[key] end
    return OnSaveData
end

function threeDimensional:OnLoad(data)
    for k,v in pairs(data) do if v ~= nil then self[k] = v end end
    self:OnLoadThree()
end

return threeDimensional