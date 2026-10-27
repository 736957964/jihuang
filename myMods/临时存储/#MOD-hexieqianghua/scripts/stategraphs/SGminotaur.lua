require("stategraphs/commonstates")

local SHAKE_DIST = 40
local SEE_KNIGHT_DIST = 30
--------------------------------------------------------------------------

-- 传送并转换军团卫士
local function MarKnight(inst, endState)
    if inst.powerup and math.random() < 0.1 then
        local inst_pos = inst:GetPosition()
        local fx = SpawnPrefab("statue_transition_2")
        if fx then
            fx.Transform:SetPosition(inst_pos:Get())
            fx.Transform:SetScale(3,4.5,3)
        end

        local enemytypes = {"knight_nightmare", "bishop_nightmare", "rook_nightmare"}
        local ents = TheSim:FindEntities(inst_pos.x, inst_pos.y, inst_pos.z, SEE_KNIGHT_DIST, {"chess"}, { "mech", "minotaur" })
        if math.random() < 0.33 and #ents < 3 then
            local enemy = SpawnPrefab(enemytypes[math.random(#enemytypes)])
            enemy.Transform:SetPosition(inst_pos:Get())
            enemy.components.follower:SetLeader(inst)
            enemy.components.combat:SetTarget(inst.components.combat.target)
            fx = SpawnPrefab("statue_transition")
            if fx then
                fx.Transform:SetPosition(inst_pos:Get())
                fx.Transform:SetScale(3,4.5,3)
            end
        end

        local theta = math.random() * 2 * PI
		local offset = FindWalkableOffset(inst_pos, theta, 10, 5)

        if offset ~= nil then
            inst_pos.x = inst_pos.x + offset.x
            inst_pos.y = 0
            inst_pos.z = inst_pos.z + offset.z
            inst.Transform:SetPosition(inst_pos:Get())
        end

        inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
        inst.sg:GoToState("teleport") 
    else 
        inst.sg:GoToState(string.lower(endState)) 
    end
end

local function onattackedfn(inst, data)
    if inst.components.health and not inst.components.health:IsDead() then
        if inst.components.freezable and inst.components.freezable:IsFrozen() or not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("hit")
        end
    end

    if inst.powerup and inst._task == nil and math.random() < TUNING.ARMOR_RUINSHAT_PROC_CHANCE then
        inst.components.health:SetInvincible(true)
        if inst._fx ~= nil then
            inst._fx:kill_fx()
        end
        inst._fx = SpawnPrefab("forcefieldfx")
        inst._fx:AddTag("forcefield")
        inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
        inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
        inst._fx.entity:SetParent(inst.entity)
        inst._fx.Transform:SetPosition(0, -1.5, 0)
        inst._fx.Transform:SetScale(3, 3, 3)

        if inst._task ~= nil then
            inst._task:Cancel()
        end
        inst._task = inst:DoTaskInTime(--[[Duration]] 4, function(inst)
            local forcefield = 1
            if inst._fx ~= nil then
                forcefield = inst._fx:GetTimeAlive()
                inst._fx:kill_fx()
                inst._fx = nil
            end
            if inst:IsValid() then
                if not inst:HasTag("invincible") then
                    inst.components.health:SetInvincible(false)
                end
                inst.components.health:DoDelta(5 * forcefield, false, "forcefield")
                if inst._task ~= nil then
                    inst._task:Cancel()
                end
                inst._task = inst:DoTaskInTime(--[[Cooldown]] TUNING.ARMOR_RUINSHAT_COOLDOWN, function(inst) inst._task = nil end)
            end
        end)
    end
end

local actionhandlers = 
{
}


local events=
{
    CommonHandlers.OnLocomote(true, true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    --CommonHandlers.OnAttacked(),
    EventHandler("attacked", onattackedfn),
    CommonHandlers.OnDeath(),

    EventHandler("doattack", function(inst)
        local nstate = "attack"
        if inst.sg:HasStateTag("running") then
            nstate = "runningattack"
        end
        if inst.components.health and not inst.components.health:IsDead()
           and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState(nstate)
        end
    end),

    EventHandler("locomote", function(inst)
        local is_attacking = inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("runningattack")
        local is_busy = inst.sg:HasStateTag("busy")
        local is_idling = inst.sg:HasStateTag("idle")
        local is_moving = inst.sg:HasStateTag("moving")
        local is_running = inst.sg:HasStateTag("running") or inst.sg:HasStateTag("runningattack")

        if is_attacking or is_busy then return end

        local should_move = inst.components.locomotor:WantsToMoveForward()
        local should_run = inst.components.locomotor:WantsToRun()
        
        if is_moving and not should_move then
            inst.SoundEmitter:KillSound("charge")
            if is_running then
                inst.sg:GoToState("run_stop")
            else
                inst.sg:GoToState("walk_stop")
            end
        elseif (not is_moving and should_move) or (is_moving and should_move and is_running ~= should_run) then
            if should_run then
                inst.sg:GoToState("run_start")
            else
                inst.sg:GoToState("walk_start")
            end
        end 
    end),
}

local states=
{
     State{
        
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.SoundEmitter:KillSound("charge")
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end

            inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")

        end,
        
       
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },


    State{  name = "run_start",
            tags = {"moving", "running", "busy", "atk_pre", "canrotate"},
            
            onenter = function(inst)
                inst.Physics:Stop()
                -- inst.components.locomotor:RunForward()
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/pawground")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PlayAnimation("paw_loop", true)
                inst.sg:SetTimeout(1.5)
            end,
            
            ontimeout= function(inst)
                inst.sg:GoToState("run")
                inst:PushEvent("attackstart" )
            end,

            timeline=
            {
		    TimeEvent(12*FRAMES, function(inst)
                                    inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/pawground")
                                end ),

            --TimeEvent(30*FRAMES,  function(inst) inst.sg:RemoveStateTag("canrotate") end ),

		    TimeEvent(30*FRAMES, function(inst)
                                    inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/pawground")
                                end ),
            },        

            onexit = function(inst)
                --inst.SoundEmitter:PlaySound(inst.soundpath .. "charge_LP","charge")
            end,
        },

    State{  name = "run",
            tags = {"moving", "running"},
            
            onenter = function(inst) 
                inst.components.locomotor:RunForward()
                if not inst.AnimState:IsCurrentAnimation("atk") then
                    inst.AnimState:PlayAnimation("atk", true)
                end
                if not inst.powerup then
                    inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
                end
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/step")

            end,
            
            timeline=
            {
                TimeEvent(5*FRAMES, function(inst)
                        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/step")                                        
                                    end ),
            },

            events=
            {   
                EventHandler("animover", function(inst)
                    MarKnight(inst, "run")
                end),
            },
            
            ontimeout = function(inst)
                inst.sg:GoToState("run")
            end,
        },

    State{  name = "teleport",
            tags = {"moving", "running", "busy", "atk_pre", "canrotate"},
            
            onenter = function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
                local fx = SpawnPrefab("statue_transition_2")
                if fx then
                    fx.Transform:SetPosition(inst:GetPosition():Get())
                    fx.Transform:SetScale(3,4,3)
                end
        
                inst.Physics:Stop()
                --inst.components.locomotor:RunForward()
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/pawground")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PlayAnimation("paw_loop", true)
                inst.sg:SetTimeout(.25)
            end,
            
            ontimeout= function(inst)
                inst.sg:GoToState("run")
                inst:PushEvent("attackstart")
            end,

            timeline=
            {
            TimeEvent(12*FRAMES, function(inst)
                                    inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/pawground")
                                end ),

            --TimeEvent(30*FRAMES,  function(inst) inst.sg:RemoveStateTag("canrotate") end ),

            TimeEvent(30*FRAMES, function(inst)
                                    inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/pawground")
                                end ),
            },        

            onexit = function(inst)
                --inst.SoundEmitter:PlaySound(inst.soundpath .. "charge_LP","charge")
            end,
        },
    
    State{  name = "run_stop",
            tags = {"canrotate", "idle"},
            
            onenter = function(inst) 
                inst.SoundEmitter:KillSound("charge")
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("gore")
            end,
            
            timeline =
            {
                TimeEvent(5*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            },
            
            events =
            {
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
            },
        },    

   State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")
        end,
        
        timeline = 
        {
		    TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice") end ),
		    TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice") end ),
        },
        
        events=
        {
            -- EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                MarKnight(inst, "idle")
            end),
        },
    },

    State{  
        name = "runningattack",
        tags = {"runningattack"},
        
        onenter = function(inst)
            inst.SoundEmitter:KillSound("charge")
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("gore")
        end,
        
        timeline =
        {
            TimeEvent(1*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("attack") end),
        },
    },
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("gore")
        end,
        
        timeline =
        {
            TimeEvent(5*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events =
        {
            EventHandler("animqueueover", function(inst) MarKnight(inst, "idle") end),
        },
    },

    State{
        name = "hit",
        tags = {"hit", "busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hit")
        end,
        
        hittimeline = 
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/hurt") end),
        },
        
        events =
        {
            EventHandler("animqueueover", function(inst) MarKnight(inst, "idle") end),
        },
    },

  State{
        name = "death",
        tags = { "death", "busy" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("death")
            inst.persists = false
            inst.components.lootdropper:DropLoot()

            local chest = SpawnPrefab("minotaurchestspawner")
            chest.Transform:SetPosition(inst.Transform:GetWorldPosition())
            chest.minotaur = inst

            inst:AddTag("NOCLICK")
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/death")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/death_voice")
            end),
            TimeEvent(2, ErodeAway),
        },

        onexit = function(inst)
            --Should NOT happen!
            inst:RemoveTag("NOCLICK")
        end,
    },
}

CommonStates.AddWalkStates(states,
{
    starttimeline = 
    {
	    TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
    },
	walktimeline = {
		    TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
            TimeEvent(7*FRAMES, function(inst) 
                inst.components.locomotor:WalkForward()
            end ),
            TimeEvent(20*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/step")
                ShakeAllCameras(CAMERA.VERTICAL, .5, .05, .1, inst, 40)
                inst.Physics:Stop()
            end ),
	},
}, nil,true)

CommonStates.AddSleepStates(states,
{
    starttimeline = 
    {
		TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/liedown") end ),
    },
    
	sleeptimeline = {
        TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/sleep") end),
	},
})

-- CommonStates.AddCombatStates(states,
-- {
--     attacktimeline = 
--     {
--         TimeEvent(17*FRAMES, function(inst)
--                                 inst.components.combat:DoAttack()
--                              end),
--     },
--     hittimeline = 
--     {
--         TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/hurt") end),
--     },
--     deathtimeline = 
--     {
--         TimeEvent(0*FRAMES, function(inst) 
--             inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/death")
--             inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/death_voice")
--         end),
--     },
-- })

CommonStates.AddFrozenStates(states)

    
return StateGraph("rook", states, events, "idle", actionhandlers)

