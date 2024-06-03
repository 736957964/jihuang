local myth_playernwd =
    Class(
    function(self, inst)
        self.inst = inst
        self.nwd = 0
        self.inst:WatchWorldState(
            "startday",
            function()
                if TheWorld.state.season == "spring" and (TheWorld.state.remainingdaysinseason == TheWorld.state.springlength) then
                    self:CheckNwd()
                end
            end
        )

        self.inst:ListenForEvent(
            "oneat",
            function(inst, data)
                if data and data.food and data.food:HasTag("myth_nianweidu_food") then
                    self:OnEat()
                end
            end
        )
    end
)

local function done(inst, self)
    self.nwd = 0
    self.targettime = nil
    self.task = nil
end

function myth_playernwd:OnSave()
    local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
    return {
        nwd = self.nwd,
        remainingtime = remainingtime > 0 and remainingtime or nil
    }
end

function myth_playernwd:OnLoad(data)
    if data then
        self.nwd = data.nwd
        if data.remainingtime ~= nil then
            self.targettime = GetTime() + math.max(0, data.remainingtime)
            self.task = self.inst:DoTaskInTime(data.remainingtime, done, self)
        end
    end
end

function myth_playernwd:OnEat()
    self.nwd = 1
    if self.task ~= nil then
        self.task:Cancel()
    end
    self.targettime = GetTime() + 480
    self.task = self.inst:DoTaskInTime(480, done, self)
end

function myth_playernwd:CheckNwd()
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 12, {"myth_nianweidu"}, {"INLIMBO"})
    local nwd = 0
    for i, v in ipairs(ents) do
        if v.prefab == "firecrackers" then
            nwd = nwd + (v.persists and 0 or 3)
        elseif v.prefab == "myth_food_table" then
            nwd = nwd + 1
            if v.components.container ~= nil then
                for i = 1, v.components.container:GetNumSlots() do
                    local item = v.components.container:GetItemInSlot(i)
                    if item and item:HasTag("myth_nianweidu_food") then
                        nwd = nwd + 1
                    end
                end
            end
        elseif v:HasTag("myth_toys") then
            nwd = nwd + v.components.stackable:StackSize()
        end
    end
    if self.inst.replica.inventory and self.inst.replica.inventory:EquipHasTag("myth_food_tr") then
        nwd = nwd + 1
    end
    nwd = nwd + self.nwd
    --self.inst.components.talker:Say("我的年维度是" .. nwd)

    if nwd > 1 then
        local x, y, z = self.inst.Transform:GetWorldPosition()

        local pouch = SpawnPrefab("redpouch_yotb")
        local prize_items = {}
        local allnum = math.min(math.floor(nwd / 2), 10)
        for k = 1, allnum do
            table.insert(prize_items, SpawnPrefab("lucky_goldnugget"))
        end
        pouch.components.unwrappable:WrapItems(prize_items)
        for i, v in ipairs(prize_items) do
            v:Remove()
        end
        pouch.Transform:SetPosition(x, 15, z)
    end
end

return myth_playernwd
