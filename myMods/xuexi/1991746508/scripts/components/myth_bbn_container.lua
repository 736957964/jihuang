
local function onchester(self,chester)
	if self.inst._hasbbn ~= nil then
		self.inst._hasbbn:set(chester ~= nil)
	end
end


local function Container_WithTag(self,tag)
    local containers = {}
    for i = 1, self.numslots do
        local item = self.slots[i]
        if item ~= nil then
            if item:HasTag(tag) then
                item:Remove()
            elseif item.components.container ~= nil then
                table.insert(containers, item)
            end
        end
    end
    for i, v in ipairs(containers) do
        Container_WithTag(v.components.container,tag)
    end
end

local function RemoveWithTag(self,tag)
    local containers = {}

    if self.activeitem ~= nil then
        if self.activeitem:HasTag(tag) then
            self.activeitem:Remove()
        elseif self.activeitem.components.container ~= nil then
            table.insert(containers, self.activeitem)
        end
    end

    for k = 1, self.maxslots do
        local v = self.itemslots[k]
        if v ~= nil then
            if v:HasTag(tag) then
                v:Remove()
            elseif v.components.container ~= nil then
                table.insert(containers, v)
            end
        end
    end

    for k, v in pairs(self.equipslots) do
        if v:HasTag(tag) then
            v:Remove()
        elseif v.components.container ~= nil then
            table.insert(containers, v)
        end
    end
    for i, v in ipairs(containers) do
        Container_WithTag(v.components.container,tag)
    end
end

local myth_bbn_container = Class(function(self, inst)
    self.inst = inst
    self.chester = nil
    self.targettime = nil
    self.task = nil

    inst:ListenForEvent("ms_playerreroll", function(inst)
		if self.chester ~= nil then
			self.chester.components.container:DropEverything()
			SpawnPrefab("myth_bbn").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		if self.inst.components.inventory then
			RemoveWithTag(self.inst.components.inventory,"myth_removebydespwn")
		end
    end)
end,
nil,
{
	chester = onchester,
})

local function SetChester(self, chester)
	self.chester = chester
	chester.persists = false
	chester.Transform:SetPosition(0,0,0) 
	chester.entity:SetParent(self.inst.entity)
end

local function stopchester(inst, self)
    self.task = nil
    self.targettime = nil
	if self.chester ~= nil then
		self.chester.components.container:DropEverything()
		self.chester:Remove()
		self.chester = nil
	end
	local bbn = SpawnPrefab("myth_bbn")
	inst.components.inventory:GiveItem(bbn)
end

function myth_bbn_container:UseBnn(bbn)
	if self.chester == nil then
		bbn:Remove()
		self:SpawnChester()
		return true
	end
	return false
end

local maxtime = 9.5*480
function myth_bbn_container:SpawnChester()
	if self.chester == nil then
		local chester = SpawnPrefab("myth_bbn_container")
        SetChester(self, chester)
		self.targettime = GetTime() + maxtime
		if self.task ~= nil then
			self.task:Cancel()
		end
		self.task = self.inst:DoTaskInTime(maxtime, stopchester, self)
	end
end

function myth_bbn_container:HasChester()
	return self.chester ~= nil 
end

function myth_bbn_container:GetChester()
	return self.chester
end

function myth_bbn_container:OpenChester()
	if self.chester ~= nil and self.chester.components.container then
		if self.chester.components.container:IsOpenedBy(self.inst) then
			self.chester.components.container:Close(self.inst)
		else
			self.chester.components.container:Open(self.inst)
		end
	end
end

function myth_bbn_container:OnSave()
	local remainingtime = self.targettime ~= nil and self.targettime - GetTime() or 0
	if self.chester ~= nil then
		return { pack = self.chester:GetSaveRecord(), remainingtime = remainingtime > 0 and remainingtime or nil,}
	end
end

function myth_bbn_container:OnLoad(data)
    if data ~= nil and data.pack ~= nil then
		local chester = SpawnSaveRecord(data.pack)
		SetChester(self, chester)
		--self.inst:DoTaskInTime(1, function()
		--	SetChester(self, chester)
		--end)
		if data.remainingtime ~= nil then
			self.targettime = GetTime() + math.max(0, data.remainingtime)
			self.task = self.inst:DoTaskInTime(data.remainingtime, stopchester, self)
		end
	end
end

return myth_bbn_container
