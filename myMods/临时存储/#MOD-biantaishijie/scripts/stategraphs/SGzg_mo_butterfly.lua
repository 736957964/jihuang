require("stategraphs/commonstates")

local events=
{
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnLocomote(true, false),
	EventHandler("attacked", function(inst, data)
	end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnFreeze(),
	EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("attack", data.target)
        end
    end),
}


local states=
{

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,

    },    
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            if not inst.AnimState:IsCurrentAnimation("idle_flight_loop") then
                inst.AnimState:PlayAnimation("idle_flight_loop", true)
            end
            inst.sg:SetTimeout( 1 )
        end,

        ontimeout = function(inst)
            if inst.sg.statemem.wantstomove then
                inst.sg:GoToState("moving")
            else
                inst.sg:GoToState("idle")
            end
        end,
    },
    
    State{
        name = "land",
        tags = {"busy", "landing"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("land")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.POLLINATE then
					inst.sg:GoToState("pollinate")
				elseif inst.bufferedaction and inst.bufferedaction.action == ACTIONS.GOHOME then
					inst:Remove()
				else
					inst.sg:GoToState("land_idle")
				end
            end),
        },
    },
    
    State{
        name = "land_idle",
        tags = {"busy", "landed"},
        
        onenter = function(inst)
            inst.AnimState:PushAnimation("idle", true)
        end,
    },
    
    State{
        name = "pollinate",
        tags = {"busy", "landed"},
        
        onenter = function(inst)
            inst.AnimState:PushAnimation("idle", true)
            inst:PerformBufferedAction()
            inst.sg:SetTimeout( 1 )
        end,
        
        ontimeout = function(inst)
            inst.sg:GoToState("takeoff")
        end,
    },
    
    State{
        name = "takeoff",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("take_off")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
        
    },
	
	State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("land")
        end,

        timeline =
        {
			TimeEvent(4*FRAMES, function(inst) 
			end),
			
			TimeEvent(12*FRAMES, function(inst)
				if inst.prefab == "butterfly" then
					local pt = inst:GetPosition()
					local fx = SpawnPrefab("groundpoundring_fx")
					fx.Transform:SetScale(1.5,1.5,1.5)
					fx.Transform:SetPosition(pt:Get())
				end
			end),
            
			TimeEvent(15*FRAMES, function(inst) 
				if inst.prefab == "butterfly" then
					
					inst.components.combat:DoAttack(inst.sg.statemem.target)
					--
					local pt = inst:GetPosition()
					local center_dmg = 30 
					local r = 3
					local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss", "zg_butterfly", "butterfly"})
					for k, v in pairs(ents) do
						if v and v.components.health and not v.components.health:IsDead() and v ~= inst then
							if v.components.combat then								
								v.components.combat:Zg_GetAttacked(inst, center_dmg, nil, "zg_ele_electric")
							
							end
						end
					end
					
					
				end
			end),
        },
		
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	------------------------------------------------------------------------
	State
    {
        name = "run_start",
        tags = { "moving", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("flight_cycle", false)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("run")
            end),
        }
    },

    State
    {
        name = "run",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("flight_cycle", false)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("run")
            end),
        }
    },

    State
    {
        name = "walk_stop",
        tags = { "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("flight_cycle", false)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
	
	State {
		name = "frozen",
		tags = {"busy"},
		
        onenter = function(inst)
            inst.AnimState:PlayAnimation("frozen")
            inst.Physics:Stop()
        end,
    },

}
CommonStates.AddFrozenStates(states)
    
return StateGraph("butterfly", states, events, "takeoff")

