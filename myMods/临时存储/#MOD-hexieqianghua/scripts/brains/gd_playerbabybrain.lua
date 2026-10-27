require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/gd_kiteandattack"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/attackwall"
require "behaviours/standstill"
require "behaviours/leash"
require "behaviours/runaway"

local PlayerBabyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

--Images will help chop, mine and fight.

local MIN_FOLLOW_DIST = 0
local TARGET_FOLLOW_DIST = 6
local MAX_FOLLOW_DIST = 8

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8

local KEEP_WORKING_DIST = 14
local SEE_WORK_DIST = 10

local KEEP_DANCING_DIST = 10

local KITING_DIST = 3
local STOP_KITING_DIST = 5
local STOP_KITING_EX_DIST = 6

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8

local AVOID_EXPLOSIVE_DIST = 5

local WORK_TAGS = {}
WORK_TAGS[ACTIONS.DIG] = {
    tags = {"stump", "grave"},
}
WORK_TAGS[ACTIONS.HAMMER] = {
    prefabs = {
        -- 前辈骨头
        skeleton = true,
        -- scorched_skeleton = true,
        skeleton_player = true,
    },
}
WORK_TAGS[ACTIONS.PICK] = {
    noprefabs = {
        -- 花
        flower = true,
        -- 传送阵插座
        gemsocket = true,
    },
    finishCall = true,
}
WORK_TAGS[ACTIONS.HARVEST] = {
    finishCall = true,
}
WORK_TAGS[ACTIONS.PICKUP] = {
    noprefabs = {
        -- 萤火虫
        fireflies = true,
    },
    finishCall = true,
}

--通过id获取当前世界玩家
local function GetTheWorldPlayerById(id)
    for _,p in pairs(AllPlayers) do
        if p.userid == id then 
            return p
        end
    end
	return nil
end

local function GetLeader(inst)
    -- print("检查宝宝状态", inst.leadercmd.follow)
    if not inst.leadercmd.follow then return nil end
    return inst.components.follower.leader or GetTheWorldPlayerById(inst.babydata.userid)
end

local function GetLeaderPos(inst)
    return inst.components.follower.leader:GetPosition()
end

local function GetFaceTargetFn(inst)
    local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
    return target ~= nil and not target:HasTag("notarget") and target or nil
end

local function IsNearLeader(inst, dist)
    local leader = GetLeader(inst)
    return leader ~= nil and inst:IsNear(leader, dist)
end

local function NiceBufferedAction(inst, target, action)
    if inst.onequipwork(inst, action) then
        local buffaction = BufferedAction(inst, target, action)
        if WORK_TAGS[action] ~= nil and WORK_TAGS[action].finishCall then
            buffaction:AddSuccessAction(function()
                inst:PushEvent("finishedwork", { target = target, action = action })
            end)
        end
        return buffaction
    end
end

-- 获得工作内容
local function GetTargetWork(inst, leader, target)
    if target ~= nil and target:IsValid() then
        -- 不可见或不能点击正在燃烧等对象或离主人过远直接不工作
        if target:IsInLimbo() or target:HasTag("NOCLICK") or target:HasTag("event_trigger")
           or (target.components.burnable ~= nil and (target.components.burnable:IsBurning() or target.components.burnable:IsSmoldering()))
           or not target.entity:IsVisible()
           or not target:IsNear(leader, KEEP_WORKING_DIST)
        then return nil end

        local workAction = nil
        if target.components.workable ~= nil and target.components.workable:CanBeWorked() then
            workAction = target.components.workable:GetWorkAction()
            if inst.canWork[workAction] then
                if WORK_TAGS[workAction] ~= nil then
                    if WORK_TAGS[workAction].prefabs ~= nil and WORK_TAGS[workAction].prefabs[target.prefab] then return workAction end
                    if WORK_TAGS[workAction].tags ~= nil then
                        for i, v in ipairs(WORK_TAGS[workAction].tags) do
                            if target:HasTag(v) then return workAction end
                        end
                    end
                else
                    return workAction
                end
            end
        end

        workAction = ACTIONS.PICK
        if inst.canWork[workAction] then
            if ((target.components.pickable ~= nil and target.components.pickable.caninteractwith and target.components.pickable:CanBePicked()) or target.prefab == "worm")
               and not WORK_TAGS[workAction].noprefabs[target.prefab]
            then
                return workAction
            end
        end

        workAction = ACTIONS.HARVEST
        if inst.canWork[workAction] then
            if target.components.crop and target.components.crop:IsReadyForHarvest()
               or target.components.dryer and target.components.dryer:IsDone()
               or target.components.stewer and target.components.stewer:IsDone()
            then
                return workAction
            end
        end

        workAction = ACTIONS.PICKUP
        if inst.canWork[workAction] then
            if target.ownerlist == nil and target.components.health == nil
               and target.components.inventoryitem ~= nil and (target.components.inventoryitem.canbepickedup or (target.components.inventoryitem.canbepickedupalive and not inst:HasTag("player")))
               and target.components.inventoryitem.cangoincontainer
               and not (target.components.projectile ~= nil and target.components.projectile:IsThrown())
               and not WORK_TAGS[workAction].noprefabs[target.prefab]
            then
                return workAction
            end
        end
    end

    return nil
end

local function FindEntityToWorkAction(inst)
    -- print("输出工作信息", inst, action, addtltags)
    local leader = GetLeader(inst)
    if leader ~= nil then
        --Keep existing target?
        local target = inst.sg.statemem.target
        local workAction = GetTargetWork(inst, leader, target)
        if workAction == nil then
            --Find new target
            -- target = FindEntity(leader, SEE_WORK_DIST, nil, { "CHOP_workable", "MINE_workable", "DIG_workable" }, { "fire", "smolder", "event_trigger", "INLIMBO", "NOCLICK" }, addtltags)
            -- target = FindEntity(leader, SEE_WORK_DIST, function(guy)
            --     local workAction = GetTargetWork(inst, leader, guy)
            --     return workAction ~= nil and true or false
            -- end, nil, { "fire", "smolder", "event_trigger", "INLIMBO", "NOCLICK" }) -- , { "CHOP_workable", "MINE_workable", "DIG_workable" }

            -- 寻找新的工作目标
            local x, y, z = leader.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, SEE_WORK_DIST, nil, { "fire", "smolder", "event_trigger", "INLIMBO", "NOCLICK" })
            for i, v in ipairs(ents) do
                workAction = GetTargetWork(inst, leader, v)
                if workAction ~= nil then
                    target = v
                    break
                end
            end
        end

        if workAction ~= nil then
            return NiceBufferedAction(inst, target, workAction)
        end
    end
end

local function KeepFaceTargetFn(inst, target)
    return not target:HasTag("notarget") and inst:IsNear(target, KEEP_FACE_DIST)
end

local function DanceParty(inst)
    inst:PushEvent("dance")
end

local function ShouldDanceParty(inst)
    local leader = GetLeader(inst)
    return leader ~= nil and leader.sg:HasStateTag("dancing")
end

local function ShouldAvoidExplosive(target)
    return target.components.explosive == nil
        or target.components.burnable == nil
        or target.components.burnable:IsBurning()
end

local function ShouldRunAway(target, inst)
    return not inst.babydata.canAtk
        and not (target.components.health ~= nil and target.components.health:IsDead())
        and (target.components.combat ~= nil and target.components.combat:HasTarget())
        -- and (not target:HasTag("shadowcreature") or (target.components.combat ~= nil and target.components.combat:HasTarget()))
end

local function ShouldKite(target, inst)
    return target ~= nil
        and target == inst.components.combat.target
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end

function PlayerBabyBrain:OnStart()
    local root = PriorityNode(
    {
        --#1 priority is dancing beside your leader. Obviously.
        WhileNode(function() return ShouldDanceParty(self.inst) end, "Dance Party",
            PriorityNode({
                -- 跑到离主人多少码范围内(注释掉即为原地跳舞,不跑向主人)
                Leash(self.inst, GetLeaderPos, KEEP_DANCING_DIST, KEEP_DANCING_DIST),
                ActionNode(function() DanceParty(self.inst) end),
        }, .25)),

        WhileNode(function() return IsNearLeader(self.inst, KEEP_WORKING_DIST) end, "Leader In Range",
            PriorityNode({
                --All shadows will avoid explosives
                RunAway(self.inst, { fn = ShouldAvoidExplosive, tags = { "explosive" }, notags = { "INLIMBO" } }, AVOID_EXPLOSIVE_DIST, AVOID_EXPLOSIVE_DIST),
                --Duelists will try to fight before fleeing
                IfNode(function() return self.inst.babydata.canAtk end, "Attacking",
                    PriorityNode({
                        IfNode(function() return self.inst.babydata.level >= 30 end, "High Attacking",
                            GD_KiteAndAttack(self.inst, STOP_KITING_EX_DIST)),
                        IfNode(function() return self.inst.babydata.level < 30 end, "Low Attacking",
                            PriorityNode({
                                WhileNode(function() return self.inst.components.combat:GetCooldown() > .5 and ShouldKite(self.inst.components.combat.target, self.inst) end, "Dodge",
                                    RunAway(self.inst, { fn = ShouldKite, tags = { "_combat", "_health" }, notags = { "INLIMBO" } }, KITING_DIST, STOP_KITING_DIST)),
                                ChaseAndAttack(self.inst),
                        }, .25)),
                }, .25)),
                --All shadows will flee from danger at this point
                RunAway(self.inst, { fn = ShouldRunAway, oneoftags = { "monster", "hostile" }, notags = { "player", "INLIMBO" } }, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
                --Workiers will try to work if not fleeing
                IfNode(function() return self.inst.components.hunger.current > 0 and self.inst.components.combat.target == nil and self.inst.canWork ~= nil end, "Keep Working",
                    DoAction(self.inst, function() return FindEntityToWorkAction(self.inst) end)),
        }, .25)),

        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),

        WhileNode(function() return GetLeader(self.inst) ~= nil end, "Has Leader",
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
    }, .25)

    self.bt = BT(self.inst, root)
end

return PlayerBabyBrain
