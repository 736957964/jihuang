require "behaviours/wander"
require "behaviours/panic"
require "behaviours/chaseandattack"

local TuDiBrain =
    Class(
    Brain,
    function(self, inst)
        Brain._ctor(self, inst)
    end
)

local function GetTraderFn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, 15, true)
    for i, v in ipairs(players) do
        if inst.components.trader:IsTryingToTradeWithMe(v) then
            return v
        end
    end
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end

local function findcombat(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 8, {"_combat", "_health"})
    for i, v in ipairs(ents) do
        if v and v.sg and v.sg:HasStateTag("attack") and v.prefab ~= "fruitfly" then
            return true
        end
    end
    return false
end

local function GetFollowPos(inst)
    local leader = inst.components.entitytracker:GetEntity("tudimiao")
    if leader and leader:IsValid() then
        return leader:GetPosition()
    end
    return inst:GetPosition()
end

local function GetFollowPos1(inst)
    --local leader = inst.components.entitytracker:GetEntity("tudimiao")
    --if leader and leader:IsValid() then
    --    return leader:GetPosition()
    --end
    return inst:GetPosition()
end

local function ShouldGoHome(inst) --啥时候回家
    if findcombat(inst) then --周围有战斗
        inst.avoidattack = true
        return true
    elseif TheWorld.state.isnight then --不是白天
        return true
    end
    return false
end

local function GoHomeAction(inst) --怎么回家
    inst.sg:RemoveStateTag("busy")
    inst.sg:AddStateTag("idle")
    local leader = inst.components.entitytracker:GetEntity("tudimiao")
    if inst.avoidattack then --遇到战斗直接原地
        inst.sg:GoToState("gohome", true)
    --elseif TheWorld.state.isnight then --晚上直接原地
    --    inst.sg:GoToState("gohome")
    elseif leader ~= nil and leader:IsValid() then --黄昏有庙 走过去再消失
        return BufferedAction(inst, leader, ACTIONS.GOHOME)
    else
        inst.sg:GoToState("gohome") --其余的时候原地
    end
end

local function ShouldTargetPlant(inst, plant)
    return not inst:IsTargetedByOther(inst, plant)
end

local function IsNearLeader(inst, dist)
    local leader = inst.components.entitytracker:GetEntity("tudimiao")
    return leader ~= nil and leader:IsValid() and inst:IsNear(leader, dist)
end

local function getspeech(inst, target)
    if target:HasTag("farm_plant_pumpkin") then
        return STRINGS.MYTH_TUDI_ROTTEN_SPEAK[math.random(#STRINGS.MYTH_TUDI_ROTTEN_SPEAK)]
    elseif target:HasTag("player") then
        local playerstr = STRINGS.MYTH_TUDI_PLAYER_SPEAK[target.prefab] or STRINGS.MYTH_TUDI_PLAYER_SPEAK["common"]
        return playerstr[math.random(#playerstr)]
    end
end

local function GetFaceTargetFn(inst)
    if not inst.sg:HasStateTag("idle") then
        return nil
    end

    if inst.sg:HasStateTag("haoleia") then
        return nil
    end

    local target = FindClosestPlayerToInst(inst, 4, true)

    if math.random() < 0.5 then
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 6, {"pickable_harvest_str"})
        if ents[1] ~= nil and ents[1]:IsValid() then
            target = ents[1]
        end
    end

    local shouldface = target ~= nil and not target:HasTag("notarget") and target or nil

    if shouldface and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("alert") then
        local str = getspeech(inst, target)
        if str then
            --inst.components.npc_talker:Say(str, nil, true)
            inst.components.talker:Say(str, nil, true)
            inst.components.timer:StartTimer("speak_time", math.random(15,20))
        end
    end

    return shouldface
end

local function KeepFaceTargetFn(inst, target)
    return inst ~= nil and target ~= nil and inst:IsValid() and target:IsValid() and
        not (target:HasTag("notarget") or target:HasTag("playerghost") or (target.sg and target.sg:HasStateTag("talking"))) and
        inst:IsNear(target, 6)
end

local function FindGoldAction(inst)
    if inst.sg:HasStateTag("busy") then
        return
    end
    if inst.components.inventory ~= nil and inst.components.inventory:IsFull() then
        return
    end
    local target =
        FindEntity(
        inst,
        16,
        function(item)
            return item:GetTimeAlive() >= 3 and (item:HasTag("myth_coin") or item:HasTag("gem"))
        end,
        nil,
        nil,
        {"myth_coin", "gem"}
    )
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.PICKUP)
    end
end

function TuDiBrain:OnStart()
    local brain = {
        --回家
        WhileNode(function()return ShouldGoHome(self.inst)end,"ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true)
        ),
        --攻击
        ChaseAndAttack(self.inst),
        --捡东西
        ChattyNode(self.inst, "PickUp", DoAction(self.inst, FindGoldAction)),
        --照料植物
        WhileNode(function()return IsNearLeader(self.inst, 16)end, "花花草草什么的最讨厌了",
            FindFarmPlant(self.inst, ACTIONS.INTERACT_WITH, true, GetFollowPos1)
        ),
        --交易朝向
        ChattyNode(self.inst, "TALK_ATTEMPT_TRADE", FaceEntity(self.inst, GetTraderFn, KeepTraderFn)),
        
        --朝向
        IfNode(function()return not self.inst.components.timer:TimerExists("speak_time") end,"friendly",
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)
        ),
        --漫步
        Wander(self.inst, GetFollowPos, 12)
    }
    local root = PriorityNode(brain, .25)
    self.bt = BT(self.inst, root)
end

return TuDiBrain
