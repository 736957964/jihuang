require("stategraphs/commonstates")

local PLAYER_TAGS = {"player"}

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

local DoRunSounds = function(inst)
    if inst.sg.mem.footsteps > 3 then
        PlayFootstep(inst, .6, true)
    else
        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
        PlayFootstep(inst, 1, true)
    end
end

local function DoHurtSound(inst)
    if inst.hurtsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.hurtsoundoverride, nil, inst.hurtsoundvolume)
    else
        inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/hurt", nil, inst.hurtsoundvolume)
    end
end

local function DoTalkSound(inst)
    if inst.talksoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
        return true
    else
        inst.SoundEmitter:PlaySound("bamboo_clappers/sfx/talk_LP", "talk")
        return true
    end
end

local function StopTalkSound(inst, instant)
    if not instant and inst.endtalksound ~= nil and inst.SoundEmitter:PlayingSound("talk") then
        inst.SoundEmitter:PlaySound(inst.endtalksound)
    end
    inst.SoundEmitter:KillSound("talk")
end

--V2C: This is for cleaning up interrupted states with legacy stuff, like
--     freeze and pinnable, that aren't consistently controlled by either
--     the stategraph or the component.
local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end

local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

local function DoEmoteFX(inst, prefab)
    local fx = SpawnPrefab(prefab)
    if fx ~= nil then
        fx.entity:SetParent(inst.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(inst.GUID, "emotefx", 0, 0, 0)
    end
end

local function DoForcedEmoteSound(inst, soundpath)
    inst.SoundEmitter:PlaySound(soundpath)
end

local function DoEmoteSound(inst, soundoverride, loop)
    --NOTE: loop only applies to soundoverride
    loop = loop and soundoverride ~= nil and "emotesoundloop" or nil
    local soundname = soundoverride or "emote"
    local emotesoundoverride = soundname.."soundoverride"
    if inst[emotesoundoverride] ~= nil then
        inst.SoundEmitter:PlaySound(inst[emotesoundoverride], loop)
    else
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/"..soundname, loop)
    end
end

local function StartTeleporting(inst)
    inst.sg.statemem.isteleporting = true

    inst:Hide()
    inst.DynamicShadow:Enable(false)
end

local function DoneTeleporting(inst)
    inst.sg.statemem.isteleporting = false

    inst:Show()
    inst.DynamicShadow:Enable(true)
end

local function GetUnequipState(inst, data)
    return (data.eslot ~= EQUIPSLOTS.HANDS and "item_hat")
        or (not data.slip and "item_in")
        or (data.item ~= nil and data.item:IsValid() and "tool_slip")
        or "toolbroke"
        , data.item
end

local function ConfigureRunState(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
    elseif inst:HasTag("groggy") then
        inst.sg.statemem.groggy = true
    else
        inst.sg.statemem.normal = true
    end
end

local function GetRunStateAnim(inst)
    return (inst.sg.statemem.heavy and "heavy_walk")
        or (inst.sg.statemem.groggy and "idle_walk")
        or (inst.sg.statemem.careful and "careful_walk")
        or "run"
end

local function GetWalkStateAnim(inst)
    return "walk"
    --[[
    return (inst.sg.statemem.heavy and "heavy_walk")
        or (inst.sg.statemem.groggy and "idle_walk")
        or (inst.sg.statemem.careful and "careful_walk")
        or "walk"
        ]]
end

local function OnRemoveCleanupTargetFX(inst)
    if inst.sg.statemem.targetfx.KillFX ~= nil then
        inst.sg.statemem.targetfx:RemoveEventCallback("onremove", OnRemoveCleanupTargetFX, inst)
        inst.sg.statemem.targetfx:KillFX()
    else
        inst.sg.statemem.targetfx:Remove()
    end
end

local function DoPortalTint(inst, val)
    if val > 0 then
        inst.components.colouradder:PushColour("portaltint", 154 / 255 * val, 23 / 255 * val, 19 / 255 * val, 0)
        val = 1 - val
        inst.AnimState:SetMultColour(val, val, val, 1)
    else
        inst.components.colouradder:PopColour("portaltint")
        inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
end

local actionhandlers =
{

    ActionHandler(ACTIONS.GOHOME, "gohome"),    
    ActionHandler(ACTIONS.INTERACT_WITH, "attackplant"),
    ActionHandler(ACTIONS.PICKUP,"doshortaction"),
}

local events =
{
    EventHandler("freeze", function(inst)
        inst.sg:GoToState("frozen")
    end),    
    EventHandler("locomote", function(inst, data)
        if inst.sg:HasStateTag("busy") then
            return
        end
        local is_moving = inst.sg:HasStateTag("moving")
        local should_move = inst.components.locomotor:WantsToMoveForward()

        if is_moving and not should_move then
            inst.sg:GoToState("walk_stop")
        elseif not is_moving and should_move then        
            inst.sg:GoToState("walk_start")
        elseif data.force_idle_state and not (is_moving or should_move or inst.sg:HasStateTag("idle"))  then
            inst.sg:GoToState("idle")
        end
    end),

    EventHandler("blocked", function(inst, data)
        if inst.sg:HasStateTag("shell") then
            inst.sg:GoToState("shell_hit")
        end
    end),

    EventHandler("snared", function(inst)
        inst.sg:GoToState("startle", true)
    end),

    EventHandler("repelled", function(inst, data)
        inst.sg:GoToState("repelled", data)
    end),

    EventHandler("ontalk", function(inst, data)      
        if not inst.sg:HasStateTag("talking") and not inst.sg:HasStateTag("haoleia") and not inst.sg:HasStateTag("notalking") then
            inst.sg:GoToState("talkto")        
        end
    end),  

    EventHandler("emote",
        function(inst, data)
            if not (inst.sg:HasStateTag("busy") or
                    inst.sg:HasStateTag("nopredict") or
                    inst.sg:HasStateTag("sleeping"))
                and not inst.components.inventory:IsHeavyLifting()
                and (not data.requires_validation or TheInventory:CheckClientOwnership(inst.userid, data.item_type)) then
                inst.sg:GoToState("emote", data)
            end
        end),
	EventHandler("teleported",
		function(inst)
            inst.sg:GoToState("idle")
        end),    
    EventHandler("doattack",
        function(inst)
            inst.sg:GoToState("attack")
        end),   
    CommonHandlers.OnHop(),
    --CommonHandlers.OnAttack(),
}

local statue_symbols =
{
    "ww_head",
    "ww_limb",
    "ww_meathand",
    "ww_shadow",
    "ww_torso",
    "frame",
    "rope_joints",
    "swap_grown"
}

local states =
{

    --------------------------------------------------------------------------
    State{
        name = "gohome",
        tags = { "notalking","busy"},

        onenter = function(inst,nocombat)
            if not inst.persists then
                return
            end
            inst.persists = false
            inst.Physics:Stop()
            local fx = SpawnPrefab("maxwell_smoke")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())	
            if nocombat then
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
                inst.AnimState:PlayAnimation("jump")
                inst.components.talker:Say(STRINGS.MYTH_TUDI_RUNAWAY)
                inst:DoTaskInTime(0.4,ErodeAway)
            else
                ErodeAway(inst)
            end
        end,
    },


    State{
        name = "haoleia",
        tags = { "haoleia","idle"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            DoTalkSound(inst)
            --inst.components.talker:Say(STRINGS.MYTH_TUDI_TIRED[math.random(#STRINGS.MYTH_TUDI_TIRED)])
            inst.AnimState:PlayAnimation("idle_hot_pre")
            inst.AnimState:PushAnimation("idle_hot_loop", false)
            inst.AnimState:PushAnimation("idle_hot_pst", false)
        end,
        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},

        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")

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
        name = "attackplant",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
            local timeout = 3
            inst.sg:SetTimeout(timeout)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
            if inst.bufferedaction ~= nil then
                inst.sg.statemem.action = inst.bufferedaction
                if inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                    inst.bufferedaction.target:PushEvent("startlongaction")
                end
            end
        end,

        timeline =
        {
            --TimeEvent(4 * FRAMES, function(inst)
            --    inst.sg:RemoveStateTag("busy")
            --end),
        },

        ontimeout = function(inst)
            inst.SoundEmitter:KillSound("make")
            inst.AnimState:PlayAnimation("build_pst")
            inst:PerformBufferedAction()

            inst.takecarenum = inst.takecarenum -1
            if inst.takecarenum <= 0  then 
                inst.takecarenum = math.random(3,5)
                inst.sg:GoToState("haoleia")
            else 
                inst.sg:GoToState("idle")
            end
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst, pushanim)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()

            if inst.components.drownable ~= nil and inst.components.drownable:ShouldDrown() then
                inst.sg:GoToState("sink_fast")
                return
            end

            inst.sg.statemem.ignoresandstorm = true

            local equippedArmor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            if equippedArmor ~= nil and equippedArmor:HasTag("band") then
                inst.sg:GoToState("enter_onemanband", pushanim)
                return
            end

            local anims = {}
            local dofunny = true

            if inst.components.inventory:IsHeavyLifting() then
                table.insert(anims, "heavy_idle")
                dofunny = false
            else              
                if inst:HasTag("groggy") then
                    table.insert(anims, "idle_groggy_pre")
                    table.insert(anims, "idle_groggy")
                else
                    table.insert(anims, "idle_loop")
                end
            end

            if pushanim then
                for k, v in pairs(anims) do
                    inst.AnimState:PushAnimation(v, k == #anims)
                end
            else
                inst.AnimState:PlayAnimation(anims[1], #anims == 1)
                for k, v in pairs(anims) do
                    if k > 1 then
                        inst.AnimState:PushAnimation(v, k == #anims)
                    end
                end
            end

            if dofunny then
                inst.sg:SetTimeout(math.random() * 4 + 2)
            end
        end,

        ontimeout = function(inst)
            local royalty = nil
            local mindistsq = 25
            for i, v in ipairs(AllPlayers) do
                if v ~= inst and
                    v.entity:IsVisible() and
                    v.components.inventory:EquipHasTag("regal") then
                    local distsq = v:GetDistanceSqToInst(inst)
                    if distsq < mindistsq then
                        mindistsq = distsq
                        royalty = v
                    end
                end
            end
            if royalty ~= nil then
                inst.sg:GoToState("bow", royalty)
            else            
                inst.sg:GoToState("idle")                                    
            end
        end,
    },


    State{
        name = "alert",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst, pushanim)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()

            if inst.components.drownable ~= nil and inst.components.drownable:ShouldDrown() then
                inst.sg:GoToState("sink_fast")
                return
            end
            
            --if not inst.components.timer:TimerExists("complain_time") and not inst.components.timer:TimerExists("speak_time") then
            --    inst.complain(inst)                
            --end

            inst.sg.statemem.ignoresandstorm = true

            local equippedArmor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            if equippedArmor ~= nil and equippedArmor:HasTag("band") then
                inst.sg:GoToState("enter_onemanband", pushanim)
                return
            end

            local anims = {}
            local dofunny = true

            if inst.components.inventory:IsHeavyLifting() then
                table.insert(anims, "heavy_idle")
                dofunny = false
            else              
                if inst:HasTag("groggy") then
                    table.insert(anims, "idle_groggy_pre")
                    table.insert(anims, "idle_groggy")
                else
                    table.insert(anims, "idle_loop")
                end
            end

            if pushanim then
                for k, v in pairs(anims) do
                    inst.AnimState:PushAnimation(v, k == #anims)
                end
            else
                inst.AnimState:PlayAnimation(anims[1], #anims == 1)
                for k, v in pairs(anims) do
                    if k > 1 then
                        inst.AnimState:PushAnimation(v, k == #anims)
                    end
                end
            end

            if dofunny then
                inst.sg:SetTimeout(math.random() * 4 + 2)
            end
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")     
        end,
    },

    -- TAP idle
    State{
        name = "funnyidle_tap_pre",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst)           
            inst.AnimState:PlayAnimation("idle_tap_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)            
                inst.sg:GoToState("funnyidle_tap")                
            end),
        },
    },
    
    State{
        name = "funnyidle_tap",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst)
        
            inst.AnimState:PushAnimation("idle_tap_loop")   

            inst.sg:SetTimeout(math.random(2,4) * (22 * FRAMES))
        end,
        
        timeline =
        {
    
            TimeEvent(1*FRAMES,         function(inst) PlayFootstep(inst) end),
            TimeEvent(11*FRAMES,        function(inst) PlayFootstep(inst) end),
            TimeEvent((1+22)*FRAMES,    function(inst) PlayFootstep(inst) end), 
            TimeEvent((11+22)*FRAMES,   function(inst) PlayFootstep(inst) end),
            TimeEvent((1+44)*FRAMES,    function(inst) PlayFootstep(inst) end),
            TimeEvent((11+44)*FRAMES,   function(inst) PlayFootstep(inst) end),
            TimeEvent((1+66)*FRAMES,    function(inst) PlayFootstep(inst) end),
            TimeEvent((11+66)*FRAMES,   function(inst) PlayFootstep(inst) end),
            TimeEvent((1+88)*FRAMES,    function(inst) PlayFootstep(inst) end),
            TimeEvent((11+88)*FRAMES,   function(inst) PlayFootstep(inst) end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("funnyidle_tap_pst")
        end,
    },
    
    State{
        name = "funnyidle_tap_pst",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst)           
            inst.AnimState:PlayAnimation("idle_tap_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)            
                inst.sg:GoToState("idle")                
            end),
        },
    },
    -- CLACK idle
    State{
        name = "funnyidle_clack_pre",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst)           
            inst.AnimState:PlayAnimation("idle_clack_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)            
                inst.sg:GoToState("funnyidle_clack")                
            end),
        },
    },
    
    State{
        name = "funnyidle_clack",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst)
        
            inst.AnimState:PushAnimation("idle_clack_loop")   

            inst.sg:SetTimeout(math.random(2,4) * (31 * FRAMES))
        end,

        timeline = ----jason
        {
            TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(29*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((13+31)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((29+31)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((13+62)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((29+62)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((13+93)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((29+93)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
        },

        ontimeout = function(inst)
            local dancing = nil
            if dancing then
                inst.sg:GoToState("funnyidle_clack")
            else
                inst.sg:GoToState("funnyidle_clack_pst")
            end
        end,
    },
    
    State{
        name = "funnyidle_clack_pst",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst)           
            inst.AnimState:PlayAnimation("idle_clack_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)            
                inst.sg:GoToState("idle")                
            end),
        },        
    }, 

    -- TANGO idle
    State{
        name = "funnyidle_tango_pre",
        tags = { "idle", "canrotate", "alert" },

        onenter = function(inst)           
            inst.AnimState:PlayAnimation("idle_tango_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)            
                inst.sg:GoToState("funnyidle_tango")                
            end),
        },
    },
    
    State{
        name = "funnyidle_tango",
        tags = { "idle", "canrotate", "dancing", "alert"},

        onenter = function(inst)
        
            inst.AnimState:PlayAnimation("idle_tango_loop", true)   

            inst.sg:SetTimeout(2 * (81 * FRAMES))
        end,

        timeline = ----jason
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(44*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(52*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(60*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent(68*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),

            TimeEvent((3+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((11+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((19+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((27+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((44+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((52+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((60+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),
            TimeEvent((68+81)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap") end),            
        },

        ontimeout = function(inst)
            local dancing = nil
            if dancing then
                inst.sg:GoToState("funnyidle_tango")
            else
                inst.sg:GoToState("funnyidle_tango_pst")
            end
        end,
    },
    
    State{
        name = "funnyidle_tango_pst",
        tags = { "idle", "canrotate", "dancing", "alert" },

        onenter = function(inst)           
            inst.AnimState:PlayAnimation("idle_tango_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)            
                inst.sg:GoToState("idle")                
            end),
        },        
    },    
    -- end idles

    State{
        name = "talk",
        tags = { "idle", "talking" ,"busy"},

        onenter = function(inst, noanim)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            if not noanim then
                inst.AnimState:PlayAnimation(
                    inst.components.inventory:IsHeavyLifting() and
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

        onexit = StopTalkSound,
    },

    -- this state runs a buffered action, "talk" does not.
    State{
        name = "talkto",
        tags = { "idle", "talking", "canrotate", "mandatory" },

        onenter = function(inst, noanim)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:PerformBufferedAction()
            if not noanim then
                inst.AnimState:PlayAnimation(
                    inst.components.inventory:IsHeavyLifting() and
                    "heavy_dial_loop" or
                    "dial_loop",
                    true)
            end
            DoTalkSound(inst)
            inst.sg:SetTimeout(TUNING.HERMITCRAB.SPEAKTIME - 0.5)
            inst.stoptalktask = inst:DoTaskInTime(2,function()
                StopTalkSound(inst)
                inst.AnimState:PlayAnimation("idle")
            end)
        end,

        ontimeout = function(inst)
             inst.sg:GoToState("idle")
        end,

        onexit = function(inst)
            inst.stoptalktask:Cancel()
            inst.stoptalktask = nil
            StopTalkSound(inst)
        end,
    },

    State{
        name = "unsaddle",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("unsaddle_pre")
            inst.AnimState:PushAnimation("unsaddle", false)

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(21 * FRAMES)
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(15 * FRAMES, function(inst)
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
        name = "heavylifting_start",
        tags = { "busy", "pausepredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:PlayAnimation("heavy_pickup_pst")
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

    State{
        name = "heavylifting_stop",
        tags = { "busy", "pausepredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:PlayAnimation("pickup")
            inst.AnimState:PushAnimation("pickup_pst", false)

            local stun_frames = 6
            inst.sg:SetTimeout(stun_frames * FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,
    },

    State{
        name = "heavylifting_item_hat",
        tags = { "busy", "pausepredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:PlayAnimation("heavy_item_hat")
            inst.AnimState:PushAnimation("heavy_item_hat_pst", false)

            inst.sg:SetTimeout(12 * FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,
    },

    State{
        name = "heavylifting_drop",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("heavy_item_hat")
            inst.AnimState:PushAnimation("heavy_item_hat_pst", false)

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(12 * FRAMES)
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(10 * FRAMES, function(inst)
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
        name = "dostandingaction",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("give")
            inst.AnimState:PushAnimation("give_pst", false)

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(14 * FRAMES)
        end,

        timeline =
        {
            TimeEvent(6 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(12 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        ontimeout = function(inst)
            --give_pst should still be playing
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
        end,
    },

    State{
        name = "doshortaction",
        tags = { "doing", "busy" },

        onenter = function(inst, silent)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("pickup")
            inst.AnimState:PushAnimation("pickup_pst", false)

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg.statemem.silent = silent
            inst.sg:SetTimeout(10 * FRAMES)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(6 * FRAMES, function(inst)
                if inst.sg.statemem.silent then
                    inst.components.talker:IgnoreAll("silentpickup")
                    inst:PerformBufferedAction()
                    inst.components.talker:StopIgnoringAll("silentpickup")
                else
                    inst:PerformBufferedAction()
                end
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
        name = "dosilentshortaction",

        onenter = function(inst)
            inst.sg:GoToState("doshortaction", true)
        end,
    },

    State{
        name = "domediumaction",

        onenter = function(inst)
            inst.sg:GoToState("dolongaction", .5)
        end,
    },

    State{
        name = "dolongaction",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
            if timeout == nil then
                timeout = 1
            elseif timeout > 1 then
                inst.sg:AddStateTag("slowaction")
            end
            inst.sg:SetTimeout(timeout)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
            if inst.bufferedaction ~= nil then
                inst.sg.statemem.action = inst.bufferedaction
                if inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                    inst.bufferedaction.target:PushEvent("startlongaction")
                end
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

    State{
        name = "walk_start",
        tags = { "moving", "walk", "canrotate", "autopredict" },

        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation(GetWalkStateAnim(inst).."_pre")
            
            inst.sg.mem.footsteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:WalkForward()
        end,

        timeline =
        {
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("walk")
                end
            end),
        },
    },

    State{
        name = "walk",
        tags = { "moving", "walking", "canrotate", "autopredict" },

        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:WalkForward()

            local anim = GetWalkStateAnim(inst)
            if anim == "walk" then
                anim = "walk_loop"
            end
            if not inst.AnimState:IsCurrentAnimation(anim) then
                inst.AnimState:PlayAnimation(anim, true)
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
        end,

        onupdate = function(inst)
            inst.components.locomotor:WalkForward()
        end,

        timeline =
        {
            --unmounted
            TimeEvent(6 * FRAMES, function(inst)                
                if inst.sg.statemem.normal then

                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(16 * FRAMES, function(inst)
                if inst.sg.statemem.normal then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            TimeEvent(26 * FRAMES, function(inst)
                if inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --groggy
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.groggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.groggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --heavy lifting
            TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    if inst.sg.mem.footsteps > 3 then
                        --normally stops at > 3, but heavy needs to keep count
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                    end
                elseif inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(36 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    if inst.sg.mem.footsteps > 12 then
                        inst.sg.mem.footsteps = math.random(4, 6)
                        inst:PushEvent("encumberedwalking")
                    elseif inst.sg.mem.footsteps > 3 then
                        --normally stops at > 3, but heavy needs to keep count
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                    end
                end
            end),
        },

        events =
        {         
            EventHandler("carefulwalking", function(inst, data)
                if not data.careful then
                    if inst.sg.statemem.careful then
                        inst.sg:GoToState("walk")
                    end
                elseif not (inst.sg.statemem.heavy or
                            inst.sg.statemem.groggy or
                            inst.sg.statemem.careful) then
                    inst.sg:GoToState("walk")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("walk")
        end,
    },

    State{
        name = "walk_stop",
        tags = { "canrotate", "idle", "autopredict" },

        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation(GetWalkStateAnim(inst).."_pst")
        end,

        timeline =
        {

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


-- RUN
    State{
        name = "run_start",
        tags = { "moving", "running", "canrotate", "autopredict" },

        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation(GetRunStateAnim(inst).."_pre")
            
            inst.sg.mem.footsteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline =
        {
            --heavy lifting
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    PlayFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),

            TimeEvent(4 * FRAMES, function(inst)
                if inst.sg.statemem.normal then
                    PlayFootstep(inst, nil, true)
                    DoFoleySounds(inst)
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
            ConfigureRunState(inst)
            inst.components.locomotor:RunForward()

            local anim = GetRunStateAnim(inst)
            if anim == "run" then
                anim = "run_loop"
            end
            if not inst.AnimState:IsCurrentAnimation(anim) then
                inst.AnimState:PlayAnimation(anim, true)
            end

            --V2C: adding half a frame time so it rounds up
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline =
        {
            --unmounted
            TimeEvent(7 * FRAMES, function(inst)
                if inst.sg.statemem.normal then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(15 * FRAMES, function(inst)
                if inst.sg.statemem.normal then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            TimeEvent(26 * FRAMES, function(inst)
                if inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --groggy
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.groggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.groggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --heavy lifting
            TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    if inst.sg.mem.footsteps > 3 then
                        --normally stops at > 3, but heavy needs to keep count
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                    end
                elseif inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(36 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    if inst.sg.mem.footsteps > 12 then
                        inst.sg.mem.footsteps = math.random(4, 6)
                        inst:PushEvent("encumberedwalking")
                    elseif inst.sg.mem.footsteps > 3 then
                        --normally stops at > 3, but heavy needs to keep count
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                    end
                end
            end),
        },

        events =
        {         
            EventHandler("carefulwalking", function(inst, data)
                if not data.careful then
                    if inst.sg.statemem.careful then
                        inst.sg:GoToState("run")
                    end
                elseif not (inst.sg.statemem.heavy or
                            inst.sg.statemem.groggy or
                            inst.sg.statemem.careful) then
                    inst.sg:GoToState("run")
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
            ConfigureRunState(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation(GetRunStateAnim(inst).."_pst")
        end,

        timeline =
        {

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
        name = "item_hat",
        tags = { "idle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("item_hat")
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

    State{
        name = "item_in",
        tags = { "idle", "nodangle", "busy"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("item_in")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.followfx ~= nil then
                for i, v in ipairs(inst.sg.statemem.followfx) do
                    v:Remove()
                end
            end
        end,
    },

    State{
        name = "item_out",
        tags = { "idle", "nodangle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("item_out")
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

    State{
        name = "give",
        tags = { "giving" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("give")
            inst.AnimState:PushAnimation("give_pst", false)
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
                inst:PerformBufferedAction()
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
    },

    State{
        name = "hit",
        tags = { "busy", "pausepredict" },

        onenter = function(inst, frozen)
            ForceStopHeavyLifting(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:PlayAnimation("hit")

            if frozen == "noimpactsound" then
                frozen = nil
            else
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
            end
            DoHurtSound(inst)

            --V2C: some of the woodie's were-transforms have shorter hit anims
            local stun_frames = math.min(math.floor(inst.AnimState:GetCurrentAnimationLength() / FRAMES + .5), frozen and 10 or 6)
            inst.sg:SetTimeout(stun_frames * FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
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

    State{
        name = "hit_spike",
        tags = { "busy", "nopredict", "nomorph" },

        onenter = function(inst, spike)
            ForceStopHeavyLifting(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            if spike ~= nil then
                inst:ForceFacePoint(spike.Transform:GetWorldPosition())
            end
            inst.AnimState:PlayAnimation("hit_spike_"..(spike ~= nil and spike.spikesize or "short"))

            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
            DoHurtSound(inst)

            inst.sg:SetTimeout(15 * FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,
    },

    State{
        name = "hit_push",
        tags = { "busy", "nopredict", "nomorph" },

        onenter = function(inst)
            ForceStopHeavyLifting(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:PlayAnimation("hit")

            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
            DoHurtSound(inst)

            inst.sg:SetTimeout(6 * FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,
    },

    State{
        name = "startle",
        tags = { "busy" },

        onenter = function(inst, snap)
            local usehit = inst:HasTag("wereplayer")
            local stun_frames = usehit and 6 or 9

            if snap then
                inst.sg:AddStateTag("nopredict")
            else
                inst.sg:AddStateTag("pausepredict")
            end

            ClearStatusAilments(inst)
            ForceStopHeavyLifting(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            if usehit then
                inst.AnimState:PlayAnimation("hit")
            else
                inst.AnimState:PlayAnimation("distress_pre")
                inst.AnimState:PushAnimation("distress_pst", false)
            end

            DoHurtSound(inst)

            inst.sg:SetTimeout(stun_frames * FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,
    },

    --需要
    State{
        name = "frozen",
        tags = { "busy", "frozen", "nopredict", "nodangle" },
        
        onenter = function(inst)
            if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
                inst.components.pinnable:Unstick()
            end

            ForceStopHeavyLifting(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
            inst.AnimState:PlayAnimation("frozen")
            inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")

            inst.components.inventory:Hide()
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
            EventHandler("unfreeze", function(inst)
                inst.sg:GoToState("hit", true)
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.isstillfrozen then
                inst.components.inventory:Show()
            end
            inst.AnimState:ClearOverrideSymbol("swap_frozen")
        end,
    },
}

local function landed_in_water_state(inst)
    return (inst.components.drownable ~= nil and inst.components.drownable:ShouldDrown() and "sink") or nil
end
CommonStates.AddSimpleState(states, "refuse", "idle_loop", { "busy" })

return StateGraph("myth_tudi", states, events, "idle", actionhandlers)
