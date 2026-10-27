require("stategraphs/commonstates")

local actionhandlers = 
{
}

local function SpreadPine_Small(inst)
    local prefab = "pine_needles_chop"
    local fx = SpawnPrefab(prefab)
    if fx then
        fx.Transform:SetScale(2.5,2.5,2.5)
        local x, y, z = inst.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x,y - math.random()*2,z)
        local pt = fx:GetPosition()
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4.5)
            for k,v in pairs(ents) do
            if v.components.combat and v ~= inst and  v.prefab ~= "leif" and v.prefab ~= "tentacle" and v.prefab ~= "shadowtentacle_root" and v.prefab ~= "crawlinghorror" and v.prefab ~= "terrorbeak"  and not v:HasTag("player") then
            v.components.combat:GetAttacked(inst, 120)
        end
            if v.components.combat and v ~= inst and v.prefab ~= "leif" and v:HasTag("player") then
            v.components.combat:GetAttacked(inst, 40)
            end
        end
    end
end

local function SpreadPine(inst)
    local prefab = "pine_needles_chop"
    local fx = SpawnPrefab(prefab)
    if fx then
        fx.Transform:SetScale(4,4,4)
        local x, y, z = inst.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x,y + math.random()*2,z)
        local pt = fx:GetPosition()
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 5)
            for k,v in pairs(ents) do
             if v.components.combat and v ~= inst and  v.prefab ~= "leif" and v.prefab ~= "tentacle" and v.prefab ~= "shadowtentacle_root" and v.prefab ~= "crawlinghorror" and v.prefab ~= "terrorbeak"  and not v:HasTag("player") then
            v.components.combat:GetAttacked(inst, 180)
        end
            if v.components.combat and v ~= inst and v.prefab ~= "leif" and v:HasTag("player") then
            v.components.combat:GetAttacked(inst, 60)
            end
        end
    end
end

local function TreeDance(inst)
    local numroots = 1
    local pos = inst:GetPosition()
    for i = 1, numroots do
    local prefab = "shadowtentacle_root"
    local root = SpawnPrefab(prefab)
    if root then
        local rad = math.random() < 0.80 and math.random(10, 25) or math.random(3, 9)
        local angle = math.random() * 2 * PI
        local offset = Vector3(rad * math.cos(angle), 0, -rad * math.sin(angle))
        root.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
        root.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
        root.Transform:SetPosition((offset+pos):Get())
        root.components.combat:SetTarget(inst.components.combat.target)
        root.sg:GoToState("attack_pre")
        end
    end
end
local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not
     inst.sg:HasStateTag("attack") and not
      inst.sg:HasStateTag("waking") and not
       inst.sg:HasStateTag("sleeping") and 
        (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
            inst.sg:GoToState("hit") 
      end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),

    EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then inst.sg:GoToState("attack", data.target) end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("gotosleep", function(inst) inst.sg:GoToState("sleeping") end),
    EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
    
    
}

local states=
{
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.SoundEmitter:PlaySound("dontstarve/forest/treeFall")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
    
    State{
        name = "tree",
        onenter = function(inst)
            inst.AnimState:PlayAnimation("tree_idle", true)
        end,
    },   

    State{
        name = "panic",
        tags = {"busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("panic_pre")
            inst.AnimState:PushAnimation("panic_loop", true)
        end,
        onexit = function(inst)
        end,
        
        onupdate = function(inst)
			if inst.components.burnable and not inst.components.burnable:IsBurning() and inst.sg.timeinstate > .3 then
				inst.sg:GoToState("idle", "panic_post")
			end
        end,
    },   
    
	State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target)
			if not inst.components.timer:TimerExists("TreeDance") and not inst.TreeDance then
                inst.components.timer:StartTimer("TreeDance", 15)
                end
            end),
            TimeEvent(26*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),

			TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
			TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/swipe") end),
			TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },  
    State{
        name = "pine_spread",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_tree")
            inst.AnimState:PushAnimation("transform_ent_mad", false)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
            inst.components.health:SetAbsorptionAmount(0.75)
            inst.sg:SetTimeout(3)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
        
        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(40*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO") inst.components.health:SetAbsorptionAmount(0) end),
            TimeEvent(55*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forest/treeFall") 
            SpreadPine_Small(inst) 
			if not inst.components.timer:TimerExists("TreeDance") and not inst.TreeDance then
                inst.components.timer:StartTimer("TreeDance", 15)
                end
            end),
            TimeEvent(60*FRAMES, function(inst) SpreadPine(inst) end),
            TimeEvent(55*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forest/treeFall") SpreadPine_Small(inst) end),
            TimeEvent(65*FRAMES, function(inst) SpreadPine(inst) end),
            TimeEvent(80*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },

    State{
        name = "treedance_pre",
        tags = {"attack", "busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("panic_pre")
            inst.AnimState:PushAnimation("panic_loop", true)
            inst.components.locomotor:StopMoving()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("treedance") end),
        },
    },

    State{
        name = "treedance",
        tags = {"attack", "busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("panic_loop", true)
            inst.sg.statemem.summontime = FRAMES*10
            inst.sg.statemem.summontimer = FRAMES*10
            inst.sg:SetTimeout(9)
        end,

        onupdate = function(inst, dt)
        local target = inst.components.combat:TargetIs(ThePlayer)
        if inst and target then
		TheWorld:PushEvent("enabledynamicmusic", true)
        end
        inst.sg.statemem.summontimer = inst.sg.statemem.summontimer + dt
        if inst.sg.statemem.summontimer >= inst.sg.statemem.summontime then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/walk_vo")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley")
        inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/footstep")
        SpreadPine_Small(inst)
        inst.components.groundpounder:GroundPound()
        TreeDance(inst)
        TreeDance(inst)
        TreeDance(inst)
        TreeDance(inst)
        TreeDance(inst)
        inst.sg.statemem.summontimer = 0
            end
        end,

        ontimeout = function(inst)
        inst.sg:GoToState("treedance_post")
        inst.TreeDance = false
        end,
    },

    State{
        name = "treedance_post",
        tags = {"busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("panic_post")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        }
    },
	State{
        name = "hit",
        tags = {"hit", "busy"},
        
        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/hurt_VO")
            
        end,
        
        events=
        {
                        EventHandler("animover", function(inst) 
        if math.random() < 0.33 and not inst.TreeDance then
        inst.sg:GoToState("pine_spread")
    else
        inst.sg:GoToState("idle") 
            end
        end),
        },
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },      
    
    State{
        name = "sleeping",
        tags = {"sleeping", "busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_tree", false)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
        end,
        events=
        {
		    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() then inst.sg:GoToState("wake") end end),
        },
        
        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },
    
    State{
        name = "spawn",
        tags = {"waking", "busy"},
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_ent")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },
    
	State{
        name = "wake",
        tags = {"waking", "busy"},
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_ent_mad")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },          
}

CommonStates.AddWalkStates(
    states,
    {
		starttimeline =
		{
            TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() if inst.TreeDance then inst.sg:GoToState("treedance_pre") end end),
            TimeEvent(11*FRAMES, function(inst) inst.components.locomotor:WalkForward() end),
            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(17*FRAMES, function(inst) inst.Physics:Stop() end),
		},
        walktimeline = 
        { 
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/walk_vo") if inst.TreeDance then inst.sg:GoToState("treedance_pre") end end),
            TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/footstep") inst.components.groundpounder:GroundPound() end),
            TimeEvent(52*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(53*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/footstep") inst.components.groundpounder:GroundPound() end),
        },
        endtimeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
    })

CommonStates.AddIdle(states)
CommonStates.AddFrozenStates(states)

return StateGraph("leif", states, events, "idle", actionhandlers)
