

local tudi_shrines_trader = Class(function(self, inst)
    self.inst = inst
    self.foods = {}
    self.time = 5*480 
    self.food_type = {
        [FOODTYPE.MEAT] = true,
        [FOODTYPE.VEGGIE] = true,
        [FOODTYPE.GOODIES] = true,
    }
    self:ChangeBUild()
end)

function tudi_shrines_trader:ChangeBUild()
    for  k = 1, 3 do 
        if self.foods[k] ~= nil then
            self.inst.AnimState:ShowSymbol("food_"..k)
            self.inst.AnimState:OverrideSymbol("food_"..k, self.foods[k][1], self.foods[k][2])
        else
            self.inst.AnimState:HideSymbol("food_"..k)
        end
    end

    if self:IsFull() then
        self.inst.AnimState:ShowSymbol("thurible")
        self.inst.AnimState:ShowSymbol("middle")
        self.inst.AnimState:ShowSymbol("tall")
    else 
        self.inst.AnimState:HideSymbol("thurible")
        self.inst.AnimState:HideSymbol("middle")
        self.inst.AnimState:HideSymbol("tall")
    end
end

local function done(inst, self)
    self.task = nil
    self.targettime = nil
    self.foods = {}
    self.food_type = {
        [FOODTYPE.MEAT] = true,
        [FOODTYPE.VEGGIE] = true,
        [FOODTYPE.GOODIES] = true,
    }
    self:ChangeBUild()
end

local cooking = require("cooking")

local function IsModCook(prefab)
    for cooker,recipes in pairs(cooking.recipes) do
        if IsModCookingProduct(cooker,prefab) then return true end
    end
    return false 
end

local function GetRecipe(prefab)
    for cooker,recipes in pairs(cooking.recipes) do
        if recipes[prefab] then return recipes[prefab] end
    end
    return nil
end

function tudi_shrines_trader:GetItem(item,player)
    if item:HasTag("myth_mooncake") then 
        table.insert(self.foods,{item.prefab ,item.prefab })
    elseif item:HasTag("myth_zongzi") then 
        table.insert(self.foods,{"myth_zongzi" ,item.prefab })
    elseif item:HasTag("spicedfood") then 
        local recipe = GetRecipe(item.prefab)
        local truename = item.prefab
        local start = string.find (truename, "_spice")
        if start ~= nil then
            truename = string.sub(truename, 1,start-1)
        end
        if IsModCook(item.prefab) then
            table.insert(self.foods,{truename ,truename })
        else
            local symbol_override_build = (recipe ~= nil and recipe.overridebuild) or "cook_pot_food"
            table.insert(self.foods,{symbol_override_build, truename })
        end
    else
        local overridebuild = IsModCook(item.prefab) and item.prefab or nil
        local recipe = GetRecipe(item.prefab)
        local build = (recipe ~= nil and recipe.overridebuild) or overridebuild  or "cook_pot_food"
        local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or item.prefab
        table.insert(self.foods,{build,overridesymbol})
    end
    self.food_type[item.components.edible.foodtype] = false
    self:ChangeBUild()
    item:Remove()
    self.targettime = GetTime() + self.time
    if self.task ~= nil then
        self.task:Cancel()
    end
    self.inst:WantToSpawn()
    self.task = self.inst:DoTaskInTime(self.time, done, self)
end

function tudi_shrines_trader:IsFull()
    return #self.foods >= 3
end

local function playersay(inst,str)
    if inst.components.talker then
        inst.components.talker:Say(str)
    end
end
function tudi_shrines_trader:Test(item,player)
    if self:IsFull() then 
        return false
    elseif not (item:HasTag("preparedfood") and item.components.edible ) then
        playersay(player,STRINGS.TUDI_SHRINES_NEEDGOODFOOD)
        return false
    elseif not self.food_type[item.components.edible.foodtype] then
        playersay(player,STRINGS.TUDI_SHRINES_NEEDOTHERFOOD)
        return false
    end
    return true
end

function tudi_shrines_trader:OnSave()
    local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return {
        foods = self.foods,
        food_type = self.food_type,
        remainingtime = remainingtime > 0 and remainingtime or nil,
    }
end

function tudi_shrines_trader:OnLoad(data)
    if data then
        self.foods = data.foods
        self.food_type  = data.food_type 
        if data.remainingtime ~= nil then
            self.targettime = GetTime() + math.max(0, data.remainingtime)
            self.task = self.inst:DoTaskInTime(data.remainingtime, done, self)
        end
        self:ChangeBUild()
    end
end

return tudi_shrines_trader
