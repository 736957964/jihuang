
-- 不知道怎么归类的...
--@--
---???
------这里写的不好  本意是想要拿着熔炉武器 也可以触发右键的动作 比如 pickup  开关灭火器之类的  感觉写的太糟糕了唉
local PlayerActionPicker = require("components/playeractionpicker")
AddComponentPostInit("playercontroller", function(self)
local old_HasAOETargeting = self.HasAOETargeting
    function self:HasAOETargeting()
        if self.inst.replica.inventory:GetActiveItem() == nil then
            return old_HasAOETargeting(self)
        end
        return false
    end
end)

function PlayerActionPicker:GetRightClickActions(position, target)
    if self.disable_right_click then
        return {}
    end
    if self.rightclickoverride ~= nil then
        local actions, usedefault = self.rightclickoverride(self.inst, target, position)
        if not usedefault or (actions ~= nil and #actions > 0) then
            return actions or {}
        end
    end
    
    local steering_actions = self:GetSteeringActions(self.inst, position, true)
    if steering_actions ~= nil then
        return steering_actions
    end  
    
    local actions = nil
    local useitem = self.inst.replica.inventory:GetActiveItem()
    local equipitem = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    local ispassable = self.map:IsPassableAtPoint(position:Get())
    
    if target ~= nil and self.containers[target] then 
        actions = self:GetSceneActions(target, true)
    elseif useitem ~= nil then 
        if useitem:IsValid() then
            if target == self.inst then
                actions = self:GetInventoryActions(useitem, true)
            elseif target ~= nil and (not target:HasTag("walkableplatform") or (useitem:HasTag("repairer") and not useitem:HasTag("deployable"))) then
                actions = self:GetUseItemActions(target, useitem, true)
            else
                actions = self:GetPointActions(position, useitem, true)
            end
        end
    elseif target ~= nil and not target:HasTag("walkableplatform") then
            if equipitem ~= nil and equipitem:IsValid() then
                if equipitem.components.aoetargeting ~= nil and equipitem.components.aoetargeting:IsEnabled() then
                    actions = self:GetSceneActions(target, true)
                    if #actions <= 0 then
                        actions = self:GetEquippedItemActions(target, equipitem, true)
                        return (#actions <= 0 or actions[1].action == ACTIONS.CASTAOE) and actions or {}
                    end
                else
                    actions = self:GetEquippedItemActions(target, equipitem, true)
                end
            end
        if actions == nil or #actions == 0 then
            actions = self:GetSceneActions(target, true)
        end

    elseif equipitem ~= nil and equipitem:IsValid() and (ispassable or equipitem:HasTag("allow_action_on_impassable") or 
		(equipitem.components.aoetargeting ~= nil and equipitem.components.aoetargeting.alwaysvalid 
		and equipitem.components.aoetargeting:IsEnabled())) then
        actions = self:GetPointActions(position, equipitem, true)
    end 
    
    if (actions == nil or #actions <= 0) and (target == nil or target:HasTag("walkableplatform")) and ispassable then
        actions = self:GetPointSpecialActions(position, useitem, true)
    end 

    return actions or {}
end

function PlayerActionPicker:DoGetMouseActions(position, target)
    local isaoetargeting = false
    local wantsaoetargeting = false
    if position == nil then
        if TheInput:GetHUDEntityUnderMouse() ~= nil then
            return
        end
        isaoetargeting = self.inst.components.playercontroller:IsAOETargeting()
        wantsaoetargeting = not isaoetargeting and self.inst.components.playercontroller:HasAOETargeting()
        if target == nil and not isaoetargeting then
            target = TheInput:GetWorldEntityUnderMouse()
        end
        position = isaoetargeting and self.inst.components.playercontroller:GetAOETargetingPos() or TheInput:GetWorldPosition()
        
        local cansee
        if target == nil then
            local x, y, z = position:Get()
            cansee = CanEntitySeePoint(self.inst, x, y, z)
        else
            cansee = target == self.inst or CanEntitySeeTarget(self.inst, target)
        end
        if not cansee then  
            local lmb = nil
            local rmb = nil          
            if not isaoetargeting then
                local lmbs = self:GetLeftClickActions(position)
                for i, v in ipairs(lmbs) do
                    if (v.action == ACTIONS.DROP and self.inst:GetDistanceSqToPoint(position:Get()) < 16) or 
                        v.action == ACTIONS.SET_HEADING then
                        lmb = v
                    end
                end

                local rmbs = self:GetRightClickActions(position)
                for i, v in ipairs(rmbs) do
                    if (v.action == ACTIONS.STOP_STEERING_BOAT) then
                        rmb = v
                    end
                end                
            end

            return lmb, rmb
        end
    end

    local lmb = not isaoetargeting and self:GetLeftClickActions(position, target)[1] or nil
    local rightaction  = self:GetRightClickActions(position, target)[1]
    local rmb
    if wantsaoetargeting then
        if rightaction ~= nil  and rightaction.action ~= ACTIONS.CASTAOE and rightaction.action ~= ACTIONS.LOOKAT  then
            rmb = rightaction
        else
            rmb = nil
        end
    else
        rmb =  rightaction
    end
    return lmb, rmb ~= nil and (lmb == nil or lmb.action ~= rmb.action) and rmb or nil
end

ACTIONS.TILL.priority = 11

AddPrefabPostInit("cave_network", function(inst)
	inst.myth_tudimiao = net_bool(inst.GUID, "cave_myth_tudimiao")
end)

AddPrefabPostInit("forest_network", function(inst)
	inst.myth_tudimiao = net_bool(inst.GUID, "forest_myth_tudimiao")
end)

local function builder(self)
	local old_canbuild = self.CanBuild
    function self:CanBuild(recname, ...)
        if recname == "myth_tudi_shrines"  and TheWorld.net and TheWorld.net.myth_tudimiao:value() then
            return false
        end
		return old_canbuild(self,recname, ...)
	end
end
AddComponentPostInit('builder', builder)
AddClassPostConstruct('components/builder_replica', builder)
