require("stategraphs/commonstates")

local function DoEquipmentFoleySounds(inst)
    for k, v in pairs(inst.components.inventory.equipslots) do
        if v.foleysound ~= nil then
            inst.SoundEmitter:PlaySound(v.foleysound, nil, nil, true)
        end
    end
end

local function DoFoleySounds(inst)
    DoEquipmentFoleySounds(inst)
    if inst.foleysound ~= nil then
        inst.SoundEmitter:PlaySound(inst.foleysound, nil, nil, true)
    end
end

local function DoHurtSound(inst)
    if inst.hurtsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.hurtsoundoverride)
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.babydata.prefab).."/hurt")
    end
end

local function DoTalkSound(inst)
    if inst.talksoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
        return true
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.babydata.prefab).."/talk_LP", "talk")
        return true
    end
end

local function DoMountSound(inst, mount, sound, ispredicted)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, ispredicted)
    end
end

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
    -- print("检查宝宝状态", inst.babydata, inst.babydata.canChop)
    return inst.components.follower.leader or GetTheWorldPlayerById(inst.babydata.userid)
end

local actionhandlers =
{    
    ActionHandler(ACTIONS.CHOP,
        function(inst)
            if not inst.sg:HasStateTag("prechop") then
                return inst.sg:HasStateTag("chopping")
                    and "chop"
                    or "chop_start"
            end
        end),
    ActionHandler(ACTIONS.MINE, 
        function(inst) 
            if not inst.sg:HasStateTag("premine") then
                return inst.sg:HasStateTag("mining")
                    and "mine"
                    or "mine_start"
            end
        end),
    ActionHandler(ACTIONS.DIG,
        function(inst)
            if not inst.sg:HasStateTag("predig") then
                return inst.sg:HasStateTag("digging")
                    and "dig"
                    or "dig_start"
            end
        end),
    ActionHandler(ACTIONS.HAMMER,
        function(inst)
            if not inst.sg:HasStateTag("prehammer") then
                return inst.sg:HasStateTag("hammering")
                    and "hammer"
                    or "hammer_start"
            end
        end),
    ActionHandler(ACTIONS.NET,
        function(inst)
            return not inst.sg:HasStateTag("prenet")
                and (inst.sg:HasStateTag("netting") and
                    "bugnet" or
                    "bugnet_start")
                or nil
        end),
    ActionHandler(ACTIONS.PICK,
        function(inst, action)
            return action.target ~= nil
                and action.target.components.pickable ~= nil
                and (   (action.target.components.pickable.jostlepick and "dojostleaction") or
                        (action.target.components.pickable.quickpick and "doshortaction") or
                        "dolongaction"  )
                or nil
        end),
    ActionHandler(ACTIONS.HARVEST, "dolongaction"),
    ActionHandler(ACTIONS.PICKUP, "doshortaction"),
    ActionHandler(ACTIONS.SLEEPIN, 
		function(inst, action)
			if action.invobject then
                if action.invobject.onuse then
                    action.invobject.onuse()
                end
				return "bedroll"
			else
				return "doshortaction"
			end
		end),
    ActionHandler(ACTIONS.EAT,
        function(inst, action)
            if inst.sg:HasStateTag("busy") then
                return
            end
            local obj = action.target or action.invobject
            if obj == nil or obj.components.edible == nil then
                return
            elseif not inst.components.eater:PrefersToEat(obj) then
                inst:PushEvent("wonteatfood", { food = obj })
                return
            end
            return (inst:HasTag("beaver") and "beavereat")
                or (obj.components.edible.foodtype == FOODTYPE.MEAT and "eat")
                or "quickeat"
        end),
}

local events =
{
    CommonHandlers.OnLocomote(true, false),
    -- CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst, data)
        if not inst.components.health:IsDead() then
            if data.weapon ~= nil and data.weapon:HasTag("tranquilizer") and inst.sg:HasStateTag("knockout") then
                return --Do nothing
            elseif inst.sg:HasStateTag("transform") or inst.sg:HasStateTag("dismounting") then
                -- don't interrupt transform or when bucked in the air
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                DoHurtSound(inst)
            elseif inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("sleeping") then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                DoHurtSound(inst)
                if inst.sleepingbag ~= nil then
                    inst.sleepingbag.components.sleepingbag:DoWakeUp()
                    inst.sleepingbag = nil
                else
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                end
            elseif not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen") then
                inst.sg:GoToState("hit")
            end
        end
    end),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnAttack(),
    EventHandler("eat", function(inst, data) 
        if inst.components.health ~= nil and not inst.components.health:IsDead() then
            inst.sg:GoToState(data.food.components.edible.foodtype == FOODTYPE.MEAT and "eat" or "quickeat", data)
        end
    end),
    EventHandler("ontalk", function(inst, data)
        if inst.sg:HasStateTag("idle") then
            if inst.prefab == "wes" then
				inst.sg:GoToState("mime")
            else
				inst.sg:GoToState("talk", data.noanim)
			end
        end
    end),
    EventHandler("gotosleep", function(inst)
        if inst.components.health ~= nil and not inst.components.health:IsDead() then
            inst.sg:GoToState("bedroll")
        end
    end),
	EventHandler("wakeup", function(inst)
        inst.sg:GoToState("wakeup")
    end),  
	EventHandler("knockedout", function(inst)
        if inst.sg:HasStateTag("knockout") then
            inst.sg.statemem.cometo = nil
        elseif not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking")) then
            inst.sg:GoToState("knockout")
        end
    end),
    EventHandler("dance", function(inst)
        if not (inst.sg:HasStateTag("dancing") or inst.sg:HasStateTag("busy")) then
            inst.sg:GoToState("dance")
        end
    end),
}

local states =
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)

            if inst.components.combat.target == nil then
                local leader = GetLeader(inst)
                if leader and leader.hxsleep then inst.sg:GoToState("bedroll") end
            end
        end,
    },

    State{
        name = "talk",
        tags = { "idle", "talking" },

        onenter = function(inst, noanim)
            if not noanim then
                inst.AnimState:PlayAnimation(
                    inst.components.inventory:IsHeavyLifting() and
                    not (inst.components.rider ~= nil and inst.components.rider:IsRiding()) and
                    "heavy_dial_loop" or
                    "dial_loop",
                    true)
            end
            DoTalkSound(inst)
            inst.sg:SetTimeout(1.5 + math.random() * .5)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,

        events =
        {
            EventHandler("donetalking", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("talk")
        end,
    },

    State{
        name = "run_start",
        tags = { "moving", "running", "canrotate", "autopredict" },

        onenter = function(inst)
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.sg.statemem.riding = true
                inst.sg:AddStateTag("nodangle")
            elseif inst.components.inventory:IsHeavyLifting() then
                inst.sg.statemem.heavy = true
            end

            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation(
                (inst.sg.statemem.heavy and "heavy_walk_pre") or
                (inst:HasTag("groggy") and "idle_walk_pre") or
                "run_pre"
            )

            inst.sg.mem.footsteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline =
        {
            --mounted
            TimeEvent(0, function(inst)
                if inst.sg.statemem.riding then
                    DoMountedFoleySounds(inst)
                end
            end),

            --heavy lifting
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    PlayFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),

            --unmounted
            TimeEvent(4 * FRAMES, function(inst)
                if not (inst.sg.statemem.riding or inst.sg.statemem.heavy) then
                    PlayFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),

            --mounted
            TimeEvent(5 * FRAMES, function(inst)
                if inst.sg.statemem.riding then
                    PlayFootstep(inst, nil, true)
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("run")
                end
            end),
        },
    },

    State{
        name = "run",
        tags = { "moving", "running", "canrotate", "autopredict" },

        onenter = function(inst) 
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.sg.statemem.riding = true
                inst.sg:AddStateTag("nodangle")
            elseif inst.components.inventory:IsHeavyLifting() then
                inst.sg.statemem.heavy = true
            end

            inst.components.locomotor:RunForward()

            local anim =
                (inst.sg.statemem.heavy and "heavy_walk") or
                (inst:HasTag("groggy") and "idle_walk") or
                "run_loop"
            if not inst.AnimState:IsCurrentAnimation(anim) then
                inst.AnimState:PlayAnimation(anim, true)
            end

            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline =
        {
            --unmounted
            TimeEvent(7 * FRAMES, function(inst)
                if not (inst.sg.statemem.riding or inst.sg.statemem.heavy) then
                    if inst.sg.mem.footsteps > 3 then
                        PlayFootstep(inst, .6, true)
                    else
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                        PlayFootstep(inst, 1, true)
                    end
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(15 * FRAMES, function(inst)
                if not (inst.sg.statemem.riding or inst.sg.statemem.heavy) then
                    if inst.sg.mem.footsteps > 3 then
                        PlayFootstep(inst, .6, true)
                    else
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                        PlayFootstep(inst, 1, true)
                    end
                    DoFoleySounds(inst)
                end
            end),

            --heavy lifting
            TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    PlayFootstep(inst, inst.sg.mem.footsteps > 3 and .6 or 1, true)
                    DoFoleySounds(inst)
                    inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                end
            end),
            TimeEvent(36 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    PlayFootstep(inst, inst.sg.mem.footsteps > 3 and .6 or 1, true)
                    DoFoleySounds(inst)
                    if inst.sg.mem.footsteps > 12 then
                        inst.sg.mem.footsteps = math.random(4, 6)
                        inst:PushEvent("encumberedwalking")
                    else
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                    end
                end
            end),

            --mounted
            TimeEvent(0 * FRAMES, function(inst)
                if inst.sg.statemem.riding then
                    DoMountedFoleySounds(inst)
                end
            end),
            TimeEvent(5 * FRAMES, function(inst)
                if inst.sg.statemem.riding then
                    if inst.sg.mem.footsteps > 3 then
                        PlayFootstep(inst, .6, true)
                    else
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                        PlayFootstep(inst, 1, true)
                    end
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("run")
        end,
    },

    State{
        name = "run_stop",
        tags = { "canrotate", "idle", "autopredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.sg:AddStateTag("nodangle")
                inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pst" or "run_pst")
            elseif inst.components.inventory:IsHeavyLifting() then
                inst.AnimState:PlayAnimation("heavy_walk_pst")
            else
                inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pst" or "run_pst")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    -- State{
    --     name = "attack",
    --     tags = {"attack", "notalking", "abouttoattack", "busy"},

    --     onenter = function(inst)
    --         inst.onoldequiphands(inst)
    --         inst.sg.statemem.target = inst.components.combat.target
    --         inst.components.combat:StartAttack()
    --         inst.Physics:Stop()
    --         inst.AnimState:PlayAnimation("atk")
    --         inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")

    --         if inst.components.combat.target ~= nil and inst.components.combat.target:IsValid() then
    --             inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
    --         end
    --     end,

    --     timeline =
    --     {
    --         TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) inst.sg:RemoveStateTag("abouttoattack") end),
    --         TimeEvent(12*FRAMES, function(inst)
    --             inst.sg:RemoveStateTag("busy")
    --         end),
    --         TimeEvent(13*FRAMES, function(inst)
    --             inst.sg:RemoveStateTag("attack")
    --         end),
    --     },

    --     events =
    --     {
    --         EventHandler("animover", function(inst)
    --             if inst.AnimState:AnimDone() then
    --                 inst.sg:GoToState("idle")
    --             end
    --         end),
    --     },
    -- },

    State{
        name = "attack",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            inst.onoldequiphands(inst)
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            -- inst.components.locomotor:Stop()
            inst.Physics:Stop()
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                cooldown = math.max(cooldown, 16 * FRAMES)
            elseif equip ~= nil and equip:HasTag("whip") then
                inst.AnimState:PlayAnimation("whip_pre")
                inst.AnimState:PushAnimation("whip", false)
                inst.sg.statemem.iswhip = true
                inst.SoundEmitter:PlaySound("dontstarve/common/whip_pre", nil, nil, true)
                cooldown = math.max(cooldown, 17 * FRAMES)
            elseif equip ~= nil and equip.components.weapon ~= nil and not equip:HasTag("punch") then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                inst.SoundEmitter:PlaySound(
                    (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
                    (equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
                    (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
                    "dontstarve/wilson/attack_weapon",
                    nil, nil, true
                )
                cooldown = math.max(cooldown, 13 * FRAMES)
            elseif equip ~= nil and (equip:HasTag("light") or equip:HasTag("nopunch")) then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
                cooldown = math.max(cooldown, 13 * FRAMES)
            elseif inst:HasTag("beaver") then
                inst.sg.statemem.isbeaver = true
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
                cooldown = math.max(cooldown, 13 * FRAMES)
            else
                inst.AnimState:PlayAnimation("punch")
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
                cooldown = math.max(cooldown, 24 * FRAMES)
            end

            if inst.components.combat.target ~= nil and inst.components.combat.target:IsValid() then
                inst:FacePoint(inst.components.combat.target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) inst.sg:RemoveStateTag("abouttoattack") end),
            TimeEvent(12*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(13*FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "eat",
        tags = { "busy", "nodangle" },

        onenter = function(inst, foodinfo)
            inst.components.locomotor:Stop()

            local feed = foodinfo and foodinfo.feed
            if feed ~= nil then
                inst.components.locomotor:Clear()
                inst:ClearBufferedAction()
                inst.sg.statemem.feed = foodinfo.feed
                inst.sg.statemem.feeder = foodinfo.feeder
                inst.sg:AddStateTag("pausepredict")
            elseif inst:GetBufferedAction() then
                feed = inst:GetBufferedAction().invobject
            end

            if feed == nil or
                feed.components.edible == nil or
                feed.components.edible.foodtype ~= FOODTYPE.GEARS then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")
            end

            if inst.components.inventory:IsHeavyLifting() and
                not (inst.components.rider ~= nil and inst.components.rider:IsRiding()) then
                inst.AnimState:PlayAnimation("heavy_eat")
            else
                inst.AnimState:PlayAnimation("eat_pre")
                inst.AnimState:PushAnimation("eat", false)
            end

            inst.components.hunger:Pause()
        end,

        timeline =
        {
            TimeEvent(28 * FRAMES, function(inst)
                if inst.sg.statemem.feed ~= nil then
                    inst.components.eater:Eat(inst.sg.statemem.feed, inst.sg.statemem.feeder)
                else
                    inst:PerformBufferedAction()
                end
            end),

            TimeEvent(30 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("pausepredict")
            end),

            TimeEvent(70 * FRAMES, function(inst)
                inst.SoundEmitter:KillSound("eating")
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("eating")
            inst.components.hunger:Resume()
            if inst.sg.statemem.feed ~= nil and inst.sg.statemem.feed:IsValid() then
                inst.sg.statemem.feed:Remove()
            end
        end,
    },

    State{
        name = "quickeat",
        tags = { "busy" },

        onenter = function(inst, foodinfo)
            inst.components.locomotor:Stop()

            local feed = foodinfo and foodinfo.feed
            if feed ~= nil then
                inst.components.locomotor:Clear()
                inst:ClearBufferedAction()
                inst.sg.statemem.feed = foodinfo.feed
                inst.sg.statemem.feeder = foodinfo.feeder
                inst.sg:AddStateTag("pausepredict")
            elseif inst:GetBufferedAction() then
                feed = inst:GetBufferedAction().invobject
            end

            if feed == nil or
                feed.components.edible == nil or
                feed.components.edible.foodtype ~= FOODTYPE.GEARS then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")
            end

            if inst.components.inventory:IsHeavyLifting() and
                not (inst.components.rider ~= nil and inst.components.rider:IsRiding()) then
                inst.AnimState:PlayAnimation("heavy_quick_eat")
            else
                inst.AnimState:PlayAnimation("quick_eat_pre")
                inst.AnimState:PushAnimation("quick_eat", false)
            end

            inst.components.hunger:Pause()
        end,

        timeline =
        {
            TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.feed ~= nil then
                    inst.components.eater:Eat(inst.sg.statemem.feed, inst.sg.statemem.feeder)
                else
                    inst:PerformBufferedAction()
                end
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("pausepredict")
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("eating")
            inst.components.hunger:Resume()
            if inst.sg.statemem.feed ~= nil and inst.sg.statemem.feed:IsValid() then
                inst.sg.statemem.feed:Remove()
            end
        end,
    },

    State{
        name = "bedroll",
        tags = { "bedroll", "busy", "nomorph" },

        onenter = function(inst)
            inst.components.locomotor:Stop()

            inst.AnimState:OverrideSymbol("swap_bedroll", "swap_bedroll_straw", "bedroll_straw")
            inst.AnimState:PlayAnimation("bedroll",true) 
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("bedroll", false)
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
            end),
        },

        events =
        {
            EventHandler("firedamage", function(inst)
                if inst.sg:HasStateTag("sleeping") then
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                end
            end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    if (inst.components.health ~= nil and inst.components.health.takingfiredamage) or
                        (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
                        inst:PushEvent("performaction", { action = inst.bufferedaction })
                        inst:ClearBufferedAction()
                        inst.sg.statemem.iswaking = true
                        inst.sg:GoToState("wakeup")
                    elseif inst:GetBufferedAction() then
                        inst:PerformBufferedAction()
                        inst.sg:AddStateTag("sleeping")
                        inst.sg:AddStateTag("silentmorph")
                        inst.sg:RemoveStateTag("nomorph")
                        inst.sg:RemoveStateTag("busy")
                        inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                    else
                        inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                    end
                end
            end),
        },

        onexit = function(inst)
            if inst.sleepingbag ~= nil then
                inst.sleepingbag.components.sleepingbag:DoWakeUp(true)
                inst.sleepingbag = nil
            end
        end,
    },

    State{
        --Alternative to doshortaction but animated with your held tool
        --Animation mirrors attack action, but are not "auto" predicted
        --by clients (also no sound prediction)
        name = "dojostleaction",
        tags = { "doing", "busy" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()
            local cooldown
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry")
                cooldown = 16 * FRAMES
            elseif equip ~= nil and equip:HasTag("whip") then
                inst.AnimState:PlayAnimation("whip_pre")
                inst.AnimState:PushAnimation("whip", false)
                inst.sg.statemem.iswhip = true
                inst.SoundEmitter:PlaySound("dontstarve/common/whip_pre")
                cooldown = 17 * FRAMES
            elseif equip ~= nil and equip.components.weapon ~= nil and not equip:HasTag("punch") then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
                cooldown = 13 * FRAMES
            elseif equip ~= nil and (equip:HasTag("light") or equip:HasTag("nopunch")) then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
                cooldown = 13 * FRAMES
            elseif inst:HasTag("beaver") then
                inst.sg.statemem.isbeaver = true
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
                cooldown = 13 * FRAMES
            else
                inst.AnimState:PlayAnimation("punch")
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
                cooldown = 24 * FRAMES
            end

            if target ~= nil and target:IsValid() then
                inst:FacePoint(target:GetPosition())
            end

            inst.sg.statemem.action = buffaction
            inst.sg:SetTimeout(cooldown)
        end,

        timeline =
        {
            --beaver: frame 4 remove busy, frame 6 action
            --whip: frame 8 remove busy, frame 10 action
            --other: frame 6 remove busy, frame 8 action
            TimeEvent(4 * FRAMES, function(inst)
                if inst.sg.statemem.isbeaver then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(6 * FRAMES, function(inst)
                if inst.sg.statemem.isbeaver then
                    inst:PerformBufferedAction()
                elseif not inst.sg.statemem.iswhip then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(8 * FRAMES, function(inst)
                if inst.sg.statemem.iswhip then
                    inst.sg:RemoveStateTag("busy")
                elseif not inst.sg.statemem.isbeaver then
                    inst:PerformBufferedAction()
                end
            end),
            TimeEvent(10 * FRAMES, function(inst)
                if inst.sg.statemem.iswhip then
                    inst:PerformBufferedAction()
                end
            end),
        },

        ontimeout = function(inst)
            --anim pst should still be playing
            inst.sg:GoToState("idle", true)
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        },

        onexit = function(inst)
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
        end,
    },

    State
    {
        name = "dolongaction",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
            local buffaction = inst:GetBufferedAction()
            local targ = buffaction.target or nil
            if targ then targ:PushEvent("startlongaction") end

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(timeout or 1)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("make")
            inst.AnimState:PlayAnimation("build_pst")
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
    },

    State
    {
        name = "doshortaction",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("pickup")
            inst.AnimState:PushAnimation("pickup_pst", false)

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(10 * FRAMES)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(6 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        ontimeout = function(inst)
            --pickup_pst should still be playing
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
        end,
    },

    State{
        name = "knockout",
        tags = { "busy", "knockout", "nopredict", "nomorph" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.sg.statemem.isinsomniac = inst:HasTag("insomniac")

            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.sg:AddStateTag("dismounting")
                inst.AnimState:PlayAnimation("fall_off")
                inst.SoundEmitter:PlaySound("dontstarve/beefalo/saddle/dismount")
            else
                inst.AnimState:PlayAnimation(inst.sg.statemem.isinsomniac and "insomniac_dozy" or "dozy")
            end

            inst.sg:SetTimeout(TUNING.KNOCKOUT_SLEEP_TIME)
        end,

        ontimeout = function(inst)
            if inst.components.grogginess == nil then
                inst.sg.statemem.iswaking = true
                inst.sg:GoToState("wakeup")
            end
        end,

        events =
        {
            EventHandler("firedamage", function(inst)
                if inst.sg:HasStateTag("sleeping") then
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                else
                    inst.sg.statemem.cometo = true
                end
            end),
            EventHandler("cometo", function(inst)
                if inst.sg:HasStateTag("sleeping") then
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                else
                    inst.sg.statemem.cometo = true
                end
            end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg:HasStateTag("dismounting") then
                        inst.sg:RemoveStateTag("dismounting")
                        if inst.components.rider ~= nil then
                            inst.components.rider:ActualDismount()
                        end
                        inst.AnimState:PlayAnimation(inst.sg.statemem.isinsomniac and "insomniac_dozy" or "dozy")
                    elseif inst.sg.statemem.cometo then
                        inst.sg.statemem.iswaking = true
                        inst.sg:GoToState("wakeup")
                    else
                        inst.AnimState:PlayAnimation(inst.sg.statemem.isinsomniac and "insomniac_sleep_loop" or "sleep_loop", true)
                        inst.sg:AddStateTag("sleeping")
                    end
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("dismounting") and inst.components.rider ~= nil then
                --Interrupted
                inst.components.rider:ActualDismount()
            end
        end,
    },

    ------------------SLEEPING-----------------

	-- State{
    --     name = "sleep",
    --     tags = {"busy", "sleeping"},

    --     onenter = function(inst)
    --         inst.components.locomotor:Stop()

    --         inst.AnimState:OverrideSymbol("swap_bedroll", "swap_bedroll_straw", "bedroll_straw")
    --         inst.AnimState:PlayAnimation("bedroll",true) 
    --         inst.AnimState:PlayAnimation("action_uniqueitem_pre")
    --         inst.AnimState:PushAnimation("bedroll", false)
    --     end,

    --     events=
    --     {
    --         EventHandler("animqueueover", function(inst) inst.sg:GoToState("sleeping") end ),
    --         EventHandler("onwakeup", function(inst) inst.sg:GoToState("wakeup") end),
    --     },

    --     timeline=
    --     {
    --         TimeEvent(20 * FRAMES, function(inst) 
    --             inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
    --         end),
    --     },
    -- },

    -- State{
    --     name = "sleeping",
    --     tags = {"busy", "sleeping"},

    --     onenter = function(inst)
    --         inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
    --     end,

    --     events=
    --     {
    --         EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end ),
    --         EventHandler("onwakeup", function(inst) inst.sg:GoToState("wakeup") end),
    --     },
    -- },

    State{
        name = "wakeup",

        onenter = function(inst)
            if inst.AnimState:IsCurrentAnimation("bedroll") or
                inst.AnimState:IsCurrentAnimation("bedroll_sleep_loop") then
                inst.AnimState:PlayAnimation("bedroll_wakeup")
            elseif not (inst.AnimState:IsCurrentAnimation("bedroll_wakeup") or
                        inst.AnimState:IsCurrentAnimation("wakeup")) then
                inst.AnimState:PlayAnimation("wakeup")
				
            end
            inst.components.health:SetInvincible(true)
        end,
        
        onexit = function(inst)
            inst.components.health:SetInvincible(false)
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "frozen",
        tags = { "busy", "frozen", "nopredict", "nodangle" },
        
        onenter = function(inst)
            if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
                inst.components.pinnable:Unstick()
            end

            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
            inst.AnimState:PlayAnimation("frozen")
            inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")

            -- inst.components.inventory:Hide()
            -- inst:PushEvent("ms_closepopups")

            --V2C: cuz... freezable component and SG need to match state,
            --     but messages to SG are queued, so it is not great when
            --     when freezable component tries to change state several
            --     times within one frame...
            if inst.components.freezable == nil then
                inst.sg:GoToState("hit", true)
            elseif inst.components.freezable:IsThawing() then
                inst.sg.statemem.isstillfrozen = true
                inst.sg:GoToState("thaw")
            elseif not inst.components.freezable:IsFrozen() then
                inst.sg:GoToState("hit", true)
            end
        end,

        events =
        {
            EventHandler("onthaw", function(inst)
                inst.sg.statemem.isstillfrozen = true
                inst.sg:GoToState("thaw")
            end),
            EventHandler("unfreeze", function(inst)
                inst.sg:GoToState("hit", true)
            end),
        },

        onexit = function(inst)
            -- if not inst.sg.statemem.isstillfrozen then
            --     inst.components.inventory:Show()
            -- end
            inst.AnimState:ClearOverrideSymbol("swap_frozen")
        end,
    },

    State{
        name = "thaw",
        tags = { "busy", "thawing", "nopredict", "nodangle" },

        onenter = function(inst) 
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
            inst.AnimState:PlayAnimation("frozen_loop_pst", true)
            inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")

            -- inst.components.inventory:Hide()
            -- inst:PushEvent("ms_closepopups")
        end,

        events =
        {
            EventHandler("unfreeze", function(inst)
                inst.sg:GoToState("hit", true)
            end),
        },

        onexit = function(inst)
            -- inst.components.inventory:Show()
            inst.SoundEmitter:KillSound("thawing")
            inst.AnimState:ClearOverrideSymbol("swap_frozen")
        end,
    },

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:ClearBufferedAction()

            inst.SoundEmitter:PlaySound("dontstarve/wilson/death")

            if not inst:HasTag("mime") then
                inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.babydata.prefab).."/death_voice")
            end

            -- inst.components.inventory:DropEverything(true)

            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")

            inst.components.burnable:Extinguish()

            --Don't process other queued events if we died this frame
            inst.sg:ClearBufferedEvents()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst:Remove()
                end
            end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },
    },

    State{
        name = "stunned",
        tags = {"busy", "canrotate"},

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_sanity_pre")
            inst.AnimState:PushAnimation("idle_sanity_loop", true)
            inst.sg:SetTimeout(5)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State{
        name = "chop_start",
        tags = {"prechop", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("chop_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("chop")
                end
            end),
        },
    },

    State{
        name = "chop",
        tags = {"prechop", "chopping", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end

            inst.AnimState:PlayAnimation("chop_loop")
        end,

        timeline =
        {
            TimeEvent(2 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),

            --NOTE: This is one frame off from SGwilson's since it was
            --      too slow when coupled with our brain update period
            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("prechop")
            end),

            TimeEvent(16*FRAMES, function(inst)
                inst.sg:RemoveStateTag("chopping")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "mine_start",
        tags = {"premine", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pickaxe_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("mine")
                end
            end),
        },
    },

    State{
        name = "mine",
        tags = {"premine", "mining", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end

            inst.AnimState:PlayAnimation("pickaxe_loop")
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                local target = inst.sg.statemem.target
                if target ~= nil and target:IsValid() then
                    if target.Transform ~= nil then
                        SpawnPrefab("mining_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
                    end
                    inst.SoundEmitter:PlaySound(target:HasTag("frozen") and "dontstarve_DLC001/common/iceboulder_hit" or "dontstarve/wilson/use_pick_rock")
                end
                inst:PerformBufferedAction()
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("premine")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) 
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("pickaxe_pst") 
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    },

    State{
        name = "dig_start",
        tags = {"predig", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end

            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("shovel_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("dig")
                end
            end),
        },
    },

    State{
        name = "dig",
        tags = {"predig", "digging", "working"},

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end

            inst.AnimState:PlayAnimation("shovel_loop")
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
            end),

            TimeEvent(35 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("predig")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("shovel_pst")
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    },

    State{
        name = "hammer_start",
        tags = { "prehammer", "working" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end

            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("pickaxe_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("hammer")
                end
            end),
        },
    },

    State{
        name = "hammer",
        tags = { "prehammer", "hammering", "working" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                -- inst.onequipwork(inst, buffaction.action)
                inst.sg.statemem.target = buffaction.target
            end
            
            inst.AnimState:PlayAnimation("pickaxe_loop")
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("prehammer")
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("prehammer")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("pickaxe_pst")
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    },

    State{
        name = "bugnet_start",
        tags = { "prenet", "working", "autopredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("bugnet_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("bugnet")
                end
            end),
        },
    },

    State{
        name = "bugnet",
        tags = { "prenet", "netting", "working", "autopredict" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("bugnet")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bugnet", nil, nil, true)
        end,

        timeline =
        {
            TimeEvent(10*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("prenet") 
                inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "dance",
        tags = {"idle", "dancing"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
            if inst.AnimState:IsCurrentAnimation("run_pst") then
                inst.AnimState:PushAnimation("emoteXL_pre_dance0")
            else
                inst.AnimState:PlayAnimation("emoteXL_pre_dance0")
            end
            inst.AnimState:PushAnimation("emoteXL_loop_dance0", true)
        end,
    },
}

return StateGraph("gd_playbaby", states, events, "idle", actionhandlers)
