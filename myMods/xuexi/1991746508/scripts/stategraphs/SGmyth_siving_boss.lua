require("stategraphs/commonstates")

local actionhandlers = 
{
}

local events=
{
    CommonHandlers.OnSleep(),
    CommonHandlers.OnDeath(),

    EventHandler("flyaway", function(inst) 
        inst.sg:GoToState("flyaway") 
    end),

    EventHandler("locomote", 
    function(inst) 
        if (not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving")) then return end
        
        if not inst.components.locomotor:WantsToMoveForward() then
            if not inst.sg:HasStateTag("idle") then
                inst.sg:GoToState("idle")
            end
        else
            if not inst.sg:HasStateTag("hopping") then
                inst.sg:GoToState("hop")
            end
        end
    end),
}

local function doeat(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 6,{"myth_plant_lotus"})
    for k,v in pairs(ents) do
        if v.components.growable and v.components.growable.stage == 4 and v.components.pickable then
            v.components.pickable:Pick(inst)
            inst.numtogive = inst.numtogive +1
        end
    end
end

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            if pushanim then
                if type(pushanim) == "string" then
                    inst.AnimState:PlayAnimation(pushanim)
                end
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
            inst.sg:SetTimeout(3 + math.random()*1)
        end,
        
        ontimeout= function(inst)
            inst.sg:GoToState("idle")
        end,
    },
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.components.trader:Disable()
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            --inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))        
        end,
    },

    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
        end,
        
        timeline=
        {
            --TimeEvent(FRAMES*0, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/taunt") end)
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
    
    State{
        name = "caw",
        tags = {"idle"},
        onenter= function(inst)
            inst.AnimState:PlayAnimation("caw")
        end,

        timeline=
        {
            --TimeEvent(FRAMES*0, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/squack") end)
        },

        events=
        {
            EventHandler("animover", function(inst) if math.random() < .5 then inst.sg:GoToState("caw") else inst.sg:GoToState("idle") end end ),
        },
    },

    State{
        name = "distress_pre",
        tags = {"busy"},
        onenter= function(inst)
            inst.AnimState:PlayAnimation("flap_pre")
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("distress") end ),
        },
    },
    
    State{
        name = "distress",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("flap_loop")
        end,

        timeline=
        {
            --TimeEvent(FRAMES*0, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/squack") end)
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("distress") end ),
        },
    },
    
    State{
        name = "glide",
        tags = {"idle", "flight", "busy"},
        onenter= function(inst,songhuo)
            inst.AnimState:PlayAnimation("glide", true)
            inst.Physics:SetMotorVelOverride(0,-15,0)
            inst.flapSound = inst:DoPeriodicTask(6*FRAMES, 
                function(inst) 
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/flap") 
                end)
        end,
        
        onupdate= function(inst)
            inst.Physics:SetMotorVelOverride(0,-15,0)
            local pt = Point(inst.Transform:GetWorldPosition())            
            if pt.y <= .1 or inst:IsAsleep() then
                inst.Physics:ClearMotorVelOverride()
                pt.y = 0
                inst.Physics:Stop()
                inst.Physics:Teleport(pt.x,pt.y,pt.z)
                inst.AnimState:PlayAnimation("land")
                inst.DynamicShadow:Enable(true)
                inst.sg:GoToState("eat")
                --inst.sg:GoToState("idle", true)
            end
        end,

        timeline =
        {
            TimeEvent(1, function(inst)
                inst.SoundEmitter:PlaySound("crane/sfx/talk_LP")
            end),
        },

        onexit = function(inst)
            if inst.flapSound then
                inst.flapSound:Cancel()
                inst.flapSound = nil
            end

            if inst:GetPosition().y > 0 then
                local pos = inst:GetPosition()
                pos.y = 0
                inst.Transform:SetPosition(pos:Get())
            end
            inst.components.knownlocations:RememberLocation("landpoint", inst:GetPosition())
        end, 
    }, 

    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("peck",true)
            inst.sg:SetTimeout(2)
        end,
        timeline =
        {
            TimeEvent(2.6, function(inst)
                doeat(inst)
                inst.sg:GoToState("idle")
            end),
        },
        onexit = function(inst)
            inst.components.timer:StartTimer("flyaway", 10)
        end,
        events=
        {
        },
    },    

    State{
        name = "flyaway",
        tags = {"flight", "busy", "canrotate"},
        onenter = function(inst)
            inst.Physics:Stop()
            inst.components.health:SetInvincible(true)
            inst.sg:SetTimeout(.1+math.random()*.2)
            inst.sg.statemem.vert = math.random() > .5
            inst.components.trader:Disable()
            
            if inst.sg.statemem.vert then
                inst.AnimState:PlayAnimation("takeoff_vertical_pre")
            else
                inst.AnimState:PlayAnimation("takeoff_diagonal_pre")
            end

            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/flyout")
        end,
        
        ontimeout= function(inst)
            if inst.sg.statemem.vert then
                inst.AnimState:PushAnimation("takeoff_vertical_loop", true)
                inst.Physics:SetMotorVel(-2 + math.random()*4,15+math.random()*5,-2 + math.random()*4)
            else
                inst.AnimState:PushAnimation("takeoff_diagonal_loop", true)
                local x = 8+ math.random()*8
                inst.Physics:SetMotorVel(x,15+math.random()*5,-2 + math.random()*4)
            end
        end,
        timeline =
        {
            TimeEvent(2.5, function(inst)
                inst:Remove()
            end),
        }
    },

    State{
        name = "songhuo",
        tags = {"flight", "busy", "canrotate"},
        onenter = function(inst,data)
            if inst.checekower ~= nil then 
                inst.checekower:Cancel()
            end
            inst.Physics:Stop()
            inst.sg:SetTimeout(.1+math.random()*.2)
            inst.sg.statemem.vert = math.random() > .5
            inst.sg.statemem.mudi = data
            if inst.sg.statemem.vert then
                inst.AnimState:PlayAnimation("takeoff_vertical_pre")
            else
                inst.AnimState:PlayAnimation("takeoff_diagonal_pre")
            end

            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/flyout")
        end,
        
        ontimeout= function(inst)
            if inst.sg.statemem.vert then
                inst.AnimState:PushAnimation("takeoff_vertical_loop", true)
                inst.Physics:SetMotorVel(0,15+math.random()*5,-2 + math.random()*4)
            else
                inst.AnimState:PushAnimation("takeoff_diagonal_loop", true)
                local x = 8+ math.random()*8
                inst.Physics:SetMotorVel(0,15+math.random()*5,-2 + math.random()*4)
            end
        end,

        timeline =
        {
            TimeEvent(2, function(inst)
                if inst.sg.statemem.mudi ~= nil then 
                    local mudi = inst.sg.statemem.mudi
                    local pos = Vector3(mudi[1],0,mudi[2])
                    local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 2, 10)
                    if offset ~= nil then
                        mudi[1] = mudi[1] + offset.x
                        mudi[2] = mudi[2] + offset.z	
                    end
                    inst.Physics:Teleport(mudi[1], 30, mudi[2]) 
                    inst.sg:GoToState("glide",true)            
                else
                    inst:Remove()
                end
            end),
        }
    },
    

    State{
        name = "hop",
        tags = {"moving", "canrotate", "hopping"},
        
        onenter = function(inst) 
            inst.AnimState:PlayAnimation("hop")
            inst.components.locomotor:WalkForward()
            inst.sg:SetTimeout(2*math.random()+.5)
        end,

        onupdate= function(inst)
            if not inst.components.locomotor:WantsToMoveForward() then
                inst.sg:GoToState("idle")
            end
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) 
                --inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")

                inst.Physics:Stop() 
            end),
        },
        
        ontimeout= function(inst)
            inst.sg:GoToState("hop")
        end,
    },
    
    State{
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
            local pt = Vector3(inst.Transform:GetWorldPosition())
            if pt.y > 1 then
                inst.sg:GoToState("fall")
            end
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },    

    State{
        name = "fall",
        tags = {"busy"},
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("fall_loop", true)
        end,
        
        onupdate = function(inst)
            local pt = Vector3(inst.Transform:GetWorldPosition())
            if pt.y <= .2 then
                pt.y = 0
                inst.Physics:Stop()
                inst.Physics:Teleport(pt.x,pt.y,pt.z)
	            inst.DynamicShadow:Enable(true)
                inst.sg:GoToState("stunned")
            end
        end,
    },    
    
    State{
        name = "stunned",
        tags = {"busy"},
        
        onenter = function(inst) 
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("stunned_loop", true)
            inst.sg:SetTimeout(GetRandomWithVariance(6, 2) )
            if inst.components.inventoryitem then
                inst.components.inventoryitem.canbepickedup = true
            end
        end,
        
        onexit = function(inst)
            if inst.components.inventoryitem then
                inst.components.inventoryitem.canbepickedup = false
            end
        end,
        
        ontimeout = function(inst) inst.sg:GoToState("flyaway") end,
    },    
}

CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)
    
return StateGraph("myth_siving_boss", states, events, "idle", actionhandlers)

