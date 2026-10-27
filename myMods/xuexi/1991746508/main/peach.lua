local _G = GLOBAL
local FRAMES = _G.FRAMES
local TimeEvent = _G.TimeEvent
local EventHandler = _G.EventHandler
-- local require = _G.require
-- local STRINGS = _G.STRINGS
local EQUIPSLOTS = _G.EQUIPSLOTS
local ACTIONS = _G.ACTIONS
-- local ActionHandler = _G.ActionHandler
local IsServer = _G.TheNet:GetIsServer() or _G.TheNet:IsDedicated()

----------

AddPrefabFiles(
    "mk_peach",
    "myth_peachtree",
    "fangcunhill"
)

--------------------------------------------------------------------------
--[[ 坎普斯和克劳斯袋子增加掉落物 ]]
--------------------------------------------------------------------------
local toys = {"myth_toy_featherbundle","myth_toy_tigerdoll","myth_toy_tumbler","myth_toy_twirldrum","myth_toy_chineseknot"}
if IsServer then
    --[[AddPrefabPostInit("krampus", function(inst)
        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:AddChanceLoot('peach', 0.25)

            local old = inst.components.lootdropper.GenerateLoot
            inst.components.lootdropper.GenerateLoot = function(self,...)
                local loots = old(self,...)
                table.insert(loots,toys[math.random(#toys)])
                return loots
            end
        end
    end)]]
    
    AddPrefabPostInit("klaus_sack", function(inst)
        if inst.components.klaussacklock ~= nil then
            local onusekeyfn_old = inst.components.klaussacklock.onusekeyfn
            inst.components.klaussacklock.onusekeyfn = function(inst, key, doer)
				local x,y,z = onusekeyfn_old(inst, key, doer)
				if x then
                    --额外掉落一个包裹：大蟠桃、2蟠桃素酒、葫芦
                    local items = {
                        _G.SpawnPrefab("bigpeach"),
                        _G.SpawnPrefab("peach_wine"),
                        _G.SpawnPrefab("peach_wine"),
                        _G.SpawnPrefab("gourd")
                    }
                    local bundle = _G.SpawnPrefab(_G.IsSpecialEventActive(_G.SPECIAL_EVENTS.WINTERS_FEAST) and "gift" or "bundle")
                    bundle.components.unwrappable:WrapItems(items)
                    for i, v in ipairs(items) do
                        v:Remove()
                    end

                    --额外掉落四个玩具
                    local items1 = {
                    }
                    for k =1,4 do 
                        table.insert(items1,_G.SpawnPrefab(toys[math.random(#toys)]))
                    end
                    local bundle1 = _G.SpawnPrefab(_G.IsSpecialEventActive(_G.SPECIAL_EVENTS.WINTERS_FEAST) and "gift" or "bundle")
                    bundle1.components.unwrappable:WrapItems(items1)
                    for i, v in ipairs(items1) do
                        v:Remove()
                    end
                    inst.components.lootdropper:FlingItem(bundle1)	
                    inst.components.lootdropper:FlingItem(bundle)			
				end
                return x,y,z
            end
        end
    end)
end

--------------------------------------------------------------------------
--[[ 采摘桃树动作相关 ]]
--------------------------------------------------------------------------

local doupaction = _G.State{
    name = "doupaction",
    tags = { "doing", "busy", "nodangle" },

    onenter = function(inst)
        if
            inst:HasTag("fastpicker")
            or (inst:HasTag("pigsy") --八戒要不饥饿时空手采摘才会加快
                and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil
                and inst.replica.hunger:GetCurrent() >= 50)
        then
            inst.sg:SetTimeout(1.5)
        else
            inst.sg:SetTimeout(3)
        end

        inst.components.locomotor:Stop()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
        inst.AnimState:PlayAnimation("construct_pre")
        inst.AnimState:PushAnimation("construct_loop", true)
        if inst.bufferedaction ~= nil then
            inst.sg.statemem.action = inst.bufferedaction
            -- if inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
            --     inst.bufferedaction.target:PushEvent("startlongaction") --目前只有风滚草会用到，所以这里不需要
            -- end
        end
    end,

    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end),
    },

    ontimeout = function(inst)
        inst.SoundEmitter:KillSound("make")
        inst.AnimState:PlayAnimation("construct_pst")
        inst:PerformBufferedAction()
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.SoundEmitter:KillSound("make")
        if inst.bufferedaction == inst.sg.statemem.action then
            inst:ClearBufferedAction()
        end
    end,
}

local doupaction_rider = _G.State{
    name = "doupaction_rider",
    onenter = function(inst)
        inst.sg:GoToState("dolongaction", 3)
    end,
}

AddStategraphState("wilson", doupaction)
AddStategraphState("wilson", doupaction_rider)

local doupaction_client = _G.State{
    name = "doupaction",
    tags = { "doing", "busy" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make_preview")
        inst.AnimState:PlayAnimation("construct_pre")
        inst.AnimState:PushAnimation("construct_loop", true)

        inst:PerformPreviewBufferedAction()
        if
            inst:HasTag("fastpicker")
            or (inst:HasTag("pigsy") --八戒要不饥饿时空手采摘才会加快
                and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil
                and inst.replica.hunger:GetCurrent() >= 50)
        then
            inst.sg:SetTimeout(1.5)
        else
            inst.sg:SetTimeout(3)
        end
    end,

    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end),
    },

    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.AnimState:PlayAnimation("construct_pst")
            inst.sg:GoToState("idle", true)
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.AnimState:PlayAnimation("construct_pst")
        inst.sg:GoToState("idle", true)
    end,

    onexit = function(inst)
        inst.SoundEmitter:KillSound("make_preview")
    end,
}

AddStategraphState("wilson_client", doupaction_rider)
AddStategraphState("wilson_client", doupaction_client)

local ActionPickFn_old = ACTIONS.PICK.fn
ACTIONS.PICK.fn = function(act)
    if act.target ~= nil and act.target.components.uppickable ~= nil then
        act.target.components.uppickable:Pick(act.doer)
        return true
    else
        return ActionPickFn_old(act)
    end
end

AddStategraphPostInit("wilson", function(sg)
	local old_handler = sg.actionhandlers[ACTIONS.PICK].deststate
    sg.actionhandlers[ACTIONS.PICK].deststate = function(inst, action)
        if action.target ~= nil and action.target.components.uppickable ~= nil then
			if inst.components.inventory:EquipHasTag("myth_ruyi") then
				return "dojostleaction"
            elseif inst.replica.rider and inst.replica.rider:IsRiding() then
                return "doupaction_doupaction_rider"
			else
				return "doupaction"
			end
        end
        if inst:HasTag("pigsy") and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil and inst.replica.hunger:GetCurrent() >= 50 then
            return action.target ~= nil
                and action.target.components.pickable ~= nil
                and (   (action.target.components.pickable.jostlepick and "dojostleaction") or
                    "doshortaction"  )
                or nil
        end
        return old_handler(inst, action)
    end
end)

AddStategraphPostInit("wilson_client", function(sg)
	local old_handler = sg.actionhandlers[ACTIONS.PICK].deststate
    sg.actionhandlers[ACTIONS.PICK].deststate = function(inst, action)
        if action.target ~= nil and action.target:HasTag("uppick") then
            if action.target:HasTag("uppickable") then
				if inst.replica.inventory:EquipHasTag("myth_ruyi") then
					return "dojostleaction"
                elseif inst.replica.rider and inst.replica.rider:IsRiding() then
                    return "doupaction_doupaction_rider"
				else
					return "doupaction"
				end
            end
			return nil --防止无法采集桃树时却跳到原本的采集sg去
        end
        if inst:HasTag("pigsy") and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil and inst.replica.hunger:GetCurrent() >= 50 then
            return (action.target:HasTag("jostlepick") and "dojostleaction")
                or "doshortaction"
        end
		return old_handler(inst, action)
    end
end)

--------------------------------------------------------------------------
--[[ 粉色墓园地皮会产生金丝雀和红雀/雪雀 ]]
--------------------------------------------------------------------------

if IsServer then
    local function IsDangerNearby(x, y, z)
        local ents = _G.TheSim:FindEntities(x, y, z, 8, { "scarytoprey" })
        return next(ents) ~= nil
    end

    AddComponentPostInit("birdspawner", function(self)
        local SpawnBird_old = self.SpawnBird
        self.SpawnBird = function(self, spawnpoint, ignorebait)
            local tile = _G.TheWorld.Map:GetTileAtPoint(spawnpoint:Get())
            if tile ~= nil and (tile == _G.GROUND.QUAGMIRE_PARKFIELD or tile == _G.GROUND.MYTH_ZHULIN )then
                local prefab = _G.GetRandomItem({ "robin", "canary" })
                local bird = _G.SpawnPrefab(  tile == _G.GROUND.MYTH_ZHULIN and  "canary"   or _G.TheWorld.state.iswinter and prefab == "robin" and "robin_winter" or prefab)
                if math.random() < .5 then
                    bird.Transform:SetRotation(180)
                end
                if bird:HasTag("bird") then
                    spawnpoint.y = 15
                end

                --see if there's bait nearby that we might spawn into
                if bird.components.eater and not ignorebait then
                    local bait = _G.TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, 15)
                    for k, v in pairs(bait) do
                        local x, y, z = v.Transform:GetWorldPosition()
                        if bird.components.eater:CanEat(v) and not v:IsInLimbo() and
                            v.components.bait and
                            not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) and
                            not IsDangerNearby(x, y, z) and
                            (bird.components.floater ~= nil or _G.TheWorld.Map:IsPassableAtPoint(x, y, z)) then
                            spawnpoint.x, spawnpoint.z = x, z
                            bird.bufferedaction = _G.BufferedAction(bird, v, ACTIONS.EAT)
                            break
                        elseif v.components.trap and
                            v.components.trap.isset and
                            (not v.components.trap.targettag or bird:HasTag(v.components.trap.targettag)) and
                            not v.components.trap.issprung and
                            math.random() < TUNING.BIRD_TRAP_CHANCE and
                            not IsDangerNearby(x, y, z) then
                            spawnpoint.x, spawnpoint.z = x, z
                            break
                        end
                    end
                end

                bird.Physics:Teleport(spawnpoint:Get())

                return bird
            else
                return SpawnBird_old(self, spawnpoint, ignorebait)
            end
        end
    end)
end
