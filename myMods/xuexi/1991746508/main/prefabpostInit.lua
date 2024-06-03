AddPrefabPostInit("firecrackers", function(inst)
    inst:AddTag("myth_nianweidu")
end)

AddPrefabPostInit(
    "frog",
    function(inst)
        if inst.components.combat then
            local old_targetfn = inst.components.combat.targetfn
            inst.components.combat.targetfn = function(inst, ...)
                local old_target = old_targetfn ~= nil and old_targetfn(inst, ...)
                if old_target ~= nil and old_target.prefab == "myth_siving_boss" then
                    return nil
                end
                return old_target
            end
        end
end)

local need = {
	laozi_bell = true,
}

local function Container_WithTag(self,tag)
    local containers = {}
    for i = 1, self.numslots do
        local item = self.slots[i]
        if item ~= nil then
            if need[item.prefab] then
                item:RemoveTag(tag)
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
        if need[self.activeitem.prefab] then
            self.activeitem:RemoveTag(tag)
        elseif self.activeitem.components.container ~= nil then
            table.insert(containers, self.activeitem)
        end
    end

    for k = 1, self.maxslots do
        local v = self.itemslots[k]
        if v ~= nil then
            if need[v.prefab] then
                v:RemoveTag(tag)
            elseif v.components.container ~= nil then
                table.insert(containers, v)
            end
        end
    end

    for k, v in pairs(self.equipslots) do
        if need[v.prefab] then
            v:RemoveTag(tag)
        elseif v.components.container ~= nil then
            table.insert(containers, v)
        end
    end
    for i, v in ipairs(containers) do
        Container_WithTag(v.components.container,tag)
    end
end
local function onchuansong(inst,data)
    if data and data.player and data.player.components.inventory then
        RemoveWithTag(data.player.components.inventory,"irreplaceable")
    end
end
    
 AddPrefabPostInit("world", function(inst)
    if TheWorld.ismastersim then
        inst:ListenForEvent("ms_playerdespawnandmigrate", onchuansong)
    end
end)