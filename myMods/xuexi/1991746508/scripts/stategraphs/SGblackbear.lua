require("stategraphs/commonstates")

local SHAKE_DIST = 40

local function onattackedfn(inst, data)
    if inst.components.health and not inst.components.health:IsDead()
    and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
        -- Clear out the inventory if he got interrupted
        local target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
        while target do
            target:Remove()
            target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
        end
       inst.sg:GoToState("hit")
    end
end

local function onattackfn(inst)
    if inst.components.health and not inst.components.health:IsDead()
    and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
        -- Clear out the inventory if he got interrupted
        local target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
        while target do
            target:Remove()
            target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
        end

        if inst.components.combat and inst.components.combat.target and inst.components.combat.target:HasTag("beehive") then
            inst.sg:GoToState("attack")
            return
        end

        if inst.sg:HasStateTag("running") then
            inst.sg:GoToState("pound")
        else
            if inst:shouldPound() then
                inst.sg:GoToState("pound")
            else
                inst.sg:GoToState("attack")
            end
        end
    end
end

local function destroystuff(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 5,nil,{"NOCLICK", "DECOR", "INLIMBO"})
    local heading_angle = -(inst.Transform:GetRotation())
    for k,v in pairs(ents) do
        if v and v.components.workable and v.components.workable.workleft > 0 and v.components.workable.action ~= ACTIONS.NET then
            SpawnPrefab("collapse_small").Transform:SetPosition(v:GetPosition():Get())        
            v.components.workable:Destroy(inst)
        end
    end
end

local function onignite(inst)
    if inst.components.health:IsDead() then return end
    --if not inst.sg.currentstate.name == 'spin_loop' then
        inst.sg:GoToState('spin_loop')
    --end
end

local function becomeblackwind(inst)
    if inst.isblackwind then return end
    if inst.components.health:IsDead() then return end
    local anim = inst.AnimState
    anim:SetBank("mossling")
    anim:SetBuild("mossling_build")
    --anim:OverrideSymbol('','','')
    anim:SetMultColour(0.3,0.3,0.3,1)
    inst.Transform:SetScale(3,3,1)

    inst.isblackwind = true
    inst:onBW()

    --刷新函数
    inst.windDamageTask = inst.windDamageTask or inst:DoPeriodicTask(1, function()
        local x,y,z = inst:GetPosition():Get()
        local ents = TheSim:FindEntities(x,y,z,4.5, {'_combat'},{"NOCLICK", "DECOR", "INLIMBO"})
        for k, v in pairs(ents)do
            if v ~= inst and v.components.health and not v.components.health:IsDead() then
                v.components.combat:GetAttacked(inst, 50)
            end
        end
    end)
end

local function becomebear(inst)
    if not inst.isblackwind then return end
    local anim = inst.AnimState
    anim:SetBank("bearger")
    anim:SetBuild("blackbear")
    anim:SetMultColour(1,1,1,1)

    inst.Transform:SetScale(1,1,1)

    inst.isblackwind = false

    if inst.windDamageTask then
        inst.windDamageTask:Cancel()
        inst.windDamageTask = nil
    end
end

local function ShouldStopSpin(inst, loop)
    local player = GetClosestInstWithTag('player', inst, 10)
    return not player or (math.random() > 1 - loop * 0.1)
end

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, 1, inst, 40)
end

local function ShakeIfClose_Pound(inst)
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, inst, 40)
end

local function ShakeIfClose_Footstep(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40)
end

local actionhandlers = 
{
    --ActionHandler(ACTIONS.HAMMER, "attack"),
    ActionHandler(ACTIONS.GOHOME, "taunt"),

    ActionHandler(ACTIONS.STEAL, "steal"),
    ActionHandler(ACTIONS.HAMMER, "steal"),
    ActionHandler(ACTIONS.RUMMAGE, "open"),
    ActionHandler(ACTIONS.EAT, "eat_loop"),
    
    ActionHandler(ACTIONS.PICKUP, "action"),
    ActionHandler(ACTIONS.HARVEST, "action"),
    ActionHandler(ACTIONS.PICK, "action"),
}
local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    --CommonHandlers.OnFreeze(),
    EventHandler("freeze", function(inst)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag('spinning') then
            inst.sg:GoToState("frozen")
        end
    end),
    --CommonHandlers.OnDeath(),
    EventHandler("doattack", onattackfn),
    EventHandler("attacked", onattackedfn),
    --EventHandler("becomeblackwind", becomeblackwind),
    EventHandler('onignite', onignite),
}

local function DoFootstep(inst)
    if inst:IsStandState("quad") then
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/step_soft")
    else
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/step_stomp")
        ShakeIfClose_Footstep(inst)
    end
end

local function OnTransOver(inst, fn)
    fn(inst)
    inst:RemoveEventCallback("animover", inst.transoverfn)
end

local function GoToStandState(inst, state, customtrans)
    if inst.IsStandState(inst, state) then
        return true
    end
    inst.sg:GoToState(string.lower(state), {endstate = inst.sg.currentstate.name, customtrans = customtrans})    
end


local states=
{

    State{
        name = "bi",
        tags = {"busy"},
        onenter = function(inst, data)
            inst.Physics:Stop()
            inst.sg.statemem.endstate = data.endstate
            inst.AnimState:PlayAnimation(data.customtrans or "taunt_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) 
                inst:SetStandState("bi") 
                --inst.components.locomotor:SetShouldRun(true)            
                inst.sg:GoToState(inst.sg.statemem.endstate) 
            end)
        },

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst) PlayFootstep(inst) end),
        },
    },

    State{
        name = "quad",
        tags = {"busy"},
        onenter = function(inst, data)
            inst.Physics:Stop()
            inst.sg.statemem.endstate = data.endstate
            inst.AnimState:PlayAnimation(data.customtrans or "taunt_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) 
                inst:SetStandState("quad")
                --inst.components.locomotor:SetShouldRun(false)               
                inst.sg:GoToState(inst.sg.statemem.endstate) 
            end)
        },

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst) 
                inst:SetStandState("quad")
                DoFootstep(inst)
            end),
        },
    },

    State{
        name = "idle",
        tags = {"idle"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            if GoToStandState(inst, "bi") then
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
        end,

        timeline=
        {
            -- TimeEvent(14*FRAMES, function(inst) 
            --     if inst:IsStandState("bi") and math.random() < .3 then
            --         -- Make sure he's not too noisy
            --         if ((GetTime() - inst.last_growl_time) > TUNING.BEARGER_GROWL_INTERVAL) then
            --             inst.last_growl_time = GetTime()
            --             inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/idle")
            --         end
            --     end
            -- end),
            -- TimeEvent(22*FRAMES, function(inst)
            --     if inst:IsStandState("quad") and math.random() < .3 then
            --         -- Make sure he's not too noisy
            --         if ((GetTime() - inst.last_growl_time) > TUNING.BEARGER_GROWL_INTERVAL) then
            --             inst.last_growl_time = GetTime()
            --             inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/idle")
            --         end
            --     end
            -- end),
        },
    },

----------------------COMBAT------------------------

    State{
        name = "targetstolen",
        tags = {"busy", "canrotate"},
        
        onenter = function(inst)
            if GoToStandState(inst, "bi") then
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("taunt")
            end
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt") end),
            TimeEvent(9*FRAMES, function(inst) DoFootstep(inst) end),
            TimeEvent(33*FRAMES, function(inst) DoFootstep(inst) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst:ClearBufferedAction() inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        tags = {"hit", "busy"},
        
        onenter = function(inst, cb)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            if inst:IsStandState("quad") then
                inst.AnimState:PlayAnimation("hit")
            else
                inst.AnimState:PlayAnimation("standing_hit")
            end
        end,
        
        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "spin_loop",
        tags = {"busy", "spinning"},

        onenter = function(inst, loop)
            becomeblackwind(inst)
            inst.AnimState:PlayAnimation('spin_loop')
            inst.sg.statemem.move = true
            inst.sg.statemem.loop = loop or 0
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin", "spinLoop")

            local fx = SpawnPrefab("mossling_spin_fx")
            fx.entity:SetParent(inst.entity)
            fx.Transform:SetPosition(0,0.1,0)
            inst.components.burnable:Extinguish()       
        end,

        onupdate = function(inst)
            if inst.sg.statemem.move then
                inst.components.locomotor:WalkForward()
            else
                inst.components.locomotor:StopMoving()
            end
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("spinLoop")
            inst.components.locomotor:StopMoving()
            if not inst.sg.statemem.restart then
                becomebear(inst)
            end
        end,

        timeline=
        {
            --TimeEvent(0*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            --TimeEvent(35*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            --TimeEvent(70*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            --TimeEvent(105*FRAMES, function(inst) inst.sg:SetTimeout(0) end),
        },

        events=
        {
            EventHandler("animover",function(inst)
                if ShouldStopSpin(inst, inst.sg.statemem.loop) then
                    inst.sg.statemem.inexit = true
                    inst.sg:GoToState('idle')
                else
                    inst.sg.statemem.restart= true
                    inst.sg:GoToState("spin_loop", inst.sg.statemem.loop + 1)
                end
            end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "busy", "canrotate"},
        
        onenter = function(inst)
            --inst.sg:GoToState('spin_loop')
            --do return end
            if GoToStandState(inst, "bi") then
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end
                inst.components.combat:StartAttack()
                inst.AnimState:PlayAnimation("atk")
            end
        end,

        timeline=
        {
            --TimeEvent(3*FRAMES, function(inst) becomeblackwind(inst) end),
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/attack") end),
            --TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/attack") end),
            TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/swhoosh") end),
            --
            TimeEvent(29*FRAMES, function(inst) if inst:shouldBW() then inst.sg:GoToState('spin_loop') end end),
            --
            TimeEvent(35*FRAMES, function(inst) inst.components.combat:DoAttack() inst.WorkEntities(inst) end),
            TimeEvent(40*FRAMES, function(inst) becomebear(inst) end),
        },
        
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "pound",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            if GoToStandState(inst, "bi") then
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end
                inst.AnimState:PlayAnimation("ground_pound")
            end
        end,

        timeline=
        {
            TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/swhoosh") end),
        
            TimeEvent(20*FRAMES, function(inst)                
                inst.components.groundpounder.damageRings = 4
                inst.components.groundpounder.destructionRings = 4
                inst.components.groundpounder.numRings = 4                
                ShakeIfClose_Pound(inst)         
                inst.components.groundpounder:GroundPound()
                inst:onPound()

                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
                
                local pt = Vector3(inst.Transform:GetWorldPosition())
                TheWorld:DoTaskInTime(0.6,function() inst:spawnbarrier(pt) end)
            end),
            -- TimeEvent(38*FRAMES, function(inst)
            --     inst:spawnbarrier(inst:GetPosition():Get())
            -- end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst:SetStandState("QUAD")
                inst.sg:GoToState("idle") 
            end),
        },
    },

    State{
        name = "death",  
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            if GoToStandState(inst, "bi") then
                inst.AnimState:PlayAnimation("death")
                inst.Physics:ClearCollisionMask()
            end
        end,

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/death") end),
            TimeEvent(50*FRAMES, function(inst)
                ShakeIfClose(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
                inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
            end),
        },

    },

-------------------EATING-------------------------

    State{
        name = "action",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            if GoToStandState(inst, "bi") then
                inst.AnimState:PlayAnimation("action")
                inst.AnimState:PushAnimation("eat_loop", false)
            end
        end,

        onexit = function(inst)
            
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) end),
            TimeEvent(15*FRAMES, function(inst)
                inst:PerformBufferedAction()             
                inst.sg:RemoveStateTag("busy")
                inst.sg:AddStateTag("wantstoeat")
                inst.last_eat_time = GetTime()
                inst.brain:ForceUpdate()
            end),
            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/gulp") end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("eat_pst") end)
        }
    },

    State{
        name = "eat_loop",
        tags = {"busy"},
        
        onenter = function(inst)
            if GoToStandState(inst, "bi") then
                inst.Physics:Stop()
                inst.AnimState:PushAnimation("eat_loop", true)
                local timeout = math.random()+.5
                local ba = inst:GetBufferedAction()
                if ba and ba.target and ba.target:HasTag("honeyed") then
                    timeout = timeout*2
                end
                inst.sg:SetTimeout(timeout)
            end
        end,
        
        timeline=
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/chew") end),
            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/chew") end),
            TimeEvent(23*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/chew") end),
        },
        
        ontimeout = function(inst)
            local ba = inst:GetBufferedAction()
            if (ba and ba.target and ba.target:HasTag("honeyed")) then
                inst.last_food_good = ba.target.components.stackable and ba.target.components.stackable:StackSize() or 1
            else
                inst.last_food_good = 0
            end
            inst:PerformBufferedAction() 
            inst.last_eat_time = GetTime()
            inst.sg:GoToState("eat_pst") 
        end,
        
    },

    State{
        name = "eat_pst",
        tags = {"busy"},
        
        onenter = function(inst)
            if GoToStandState(inst, "bi") then
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("eat_pst")
            end
        end,
        
        timeline=
        {
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.num_good_food_eaten = inst.last_food_good and inst.num_good_food_eaten + inst.last_food_good or inst.num_good_food_eaten
                inst.last_food_good = nil
                inst.sg:GoToState("idle") 
            end),
        },
    },

    State{
        name = "steal",
        tags = {"busy"},
        
        onenter = function(inst)
            if GoToStandState(inst, "bi") then
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("atk", false)
            end
        end,
        
        timeline=
        {
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/attack") end),
            --TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/attack") end),
            TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/swhoosh") end),
            TimeEvent(35*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "open",
        tags = {"busy"},
        
        onenter = function(inst,pot)
            inst.Physics:Stop()
            inst.sg.statemem.pot = pot
            inst.AnimState:PlayAnimation("atk", false)
            --inst.AnimState:PushAnimation("action")
            inst.AnimState:PushAnimation("eat_loop", false)

        end,
        
        timeline=
        {
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/attack") end),
            --TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/attack") end),
            TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/swhoosh") end),
            TimeEvent(35*FRAMES, function(inst) 
                if inst.sg.statemem.pot and inst.sg.statemem.pot:IsValid() then
                    inst.sg.statemem.pot.components.container:Open(inst)
                end
            end),
            TimeEvent(2.5, function(inst) 
                if inst.sg.statemem.pot and inst.sg.statemem.pot:IsValid() then
                    inst.sg.statemem.pot.components.container:DestroyContents()
                    inst.sg.statemem.pot.components.container:Close()
                end
            end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
        onexit = function(inst)
            if inst.sg.statemem.pot and inst.sg.statemem.pot:IsValid() then
                inst.sg.statemem.pot.components.container:Close()
            end
        end,
    },

---------------------------WALKING---------------

    State{
            name = "walk_start",
            tags = {"moving", "canrotate"},

            onenter = function(inst) 
                local anim = (inst.components.combat.target and not inst.components.combat.target:HasTag("beehive")) and "charge_pre" or "walk_pre"
                if GoToStandState(inst, "bi") then
                    inst.AnimState:PlayAnimation(anim)
                end
            end,

            events =
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("walk") end ),        
            },
        },
        
    State{            
            name = "walk",
            tags = {"moving", "canrotate"},
            
            onenter = function(inst)
                local anim = (inst.components.combat.target and not inst.components.combat.target:HasTag("beehive")) and "charge_loop" or "walk_loop"
                if GoToStandState(inst, "bi") then
                    inst.AnimState:PlayAnimation(anim)
                end
                inst.components.locomotor:WalkForward()
                if inst.components.combat and inst.components.combat.target and math.random() < .5 then
                    inst:DoTaskInTime(math.random(13)*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/grrrr") end)
                end
            end,

            events=
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("walk") end ),        
            },

            timeline=
            {
                TimeEvent(2*FRAMES, function(inst)
                    if inst.components.combat.target then
                        DoFootstep(inst) 
                    end
                end),
                TimeEvent(18*FRAMES, function(inst)
                    if inst.components.combat.target then
                        DoFootstep(inst) 
                    end
                end),
                TimeEvent(4*FRAMES, function(inst) 
                    if not inst.components.combat.target then
                        DoFootstep(inst) 
                    end
                end),
                TimeEvent(30*FRAMES, function(inst) 
                    if not inst.components.combat.target then
                        DoFootstep(inst) 
                    end
                end),
            },
        },        
    
    State{            
            name = "walk_stop",
            tags = {"canrotate"},
            
            onenter = function(inst) 
                inst.components.locomotor:StopMoving()
                local anim = (inst.components.combat.target and not inst.components.combat.target:HasTag("beehive")) and "charge_pst" or "walk_pst"
                DoFootstep(inst)
                if GoToStandState(inst, "bi") then
                    inst.AnimState:PlayAnimation(anim)
                end
            end,

            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
            },
        },

    State{
            name = "run_start",
            tags = {"moving", "running", "atk_pre", "canrotate"},

            onenter = function(inst) 
                if GoToStandState(inst, "bi") then
                    inst.components.locomotor:RunForward()
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt", "taunt")
                    inst.AnimState:PlayAnimation("charge_pre")
                end
            end,

            events =
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("run") end ),        
            },
        },
        
    State{
            
            name = "run",
            tags = {"moving", "running", "canrotate"},
            
            onenter = function(inst) 
                inst.components.locomotor:RunForward()
                if not inst.SoundEmitter:PlayingSound("taunt") then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt", "taunt") end
                inst.AnimState:PlayAnimation("charge_roar_loop")
            end,

            timeline=
            {
                TimeEvent(3*FRAMES, function(inst)
                    DoFootstep(inst)
                    destroystuff(inst)
                end),
                TimeEvent(11*FRAMES, function(inst)
                    DoFootstep(inst)
                    destroystuff(inst)
                end),
            },   

            events=
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("run") end ),        
            },
        },        
    
    State{
            
            name = "run_stop",
            tags = {"canrotate"},
            
            onenter = function(inst) 
                inst.components.locomotor:StopMoving()
                local should_softstop = false
                inst.AnimState:PlayAnimation("charge_pst")          
            end,

            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
            },
        },

------------------SLEEPING-----------------

        State{
            name = "sleep",
            tags = {"busy", "sleeping"},
            
            onenter = function(inst) 
                inst.components.locomotor:StopMoving()
                inst.last_eat_time = nil -- Unset eat timer
                if inst:IsStandState("quad") then
                    inst.AnimState:PushAnimation("sleep_pre", false)
                else
                    inst.AnimState:PlayAnimation("standing_sleep_pre")
                    inst.AnimState:PushAnimation("sleep_pre", false)
                end
            end,

            events=
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("sleeping") end ),        
                EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
            },

            timeline=
            {
                TimeEvent(25*FRAMES, function(inst)
                    if inst:IsStandState("bi") then
                        inst:SetStandState("quad")
                        DoFootstep(inst)
                    end
                end),
            },
        },
        
        State{
            
            name = "sleeping",
            tags = {"busy", "sleeping"},
            
            onenter = function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/sleep")
                inst.AnimState:PlayAnimation("sleep_loop")
            end,
            
            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end ),        
                EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
            },
        },        
    
        State{
            
            name = "wake",
            tags = {"busy", "waking"},
            
            onenter = function(inst) 
                inst.last_eat_time = GetTime() -- Fake this as eating so he doesn't aggro immediately
                inst.components.locomotor:StopMoving()
                inst.AnimState:PlayAnimation("sleep_pst")
                if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
                    inst.components.sleeper:WakeUp()
                end
                if not inst:IsStandState("quad") then inst:SetStandState("quad") end
            end,

            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
            },

            timeline=
            {
                TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt_short") end),
            },
        },      
}

CommonStates.AddFrozenStates(states)

return StateGraph("black_bear", states, events, "idle", actionhandlers)

