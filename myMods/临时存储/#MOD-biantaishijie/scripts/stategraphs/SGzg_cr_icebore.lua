require("stategraphs/commonstates")

local events=
{

	CommonHandlers.OnLocomote(true,false),
    EventHandler("doattack", function(inst, data)
        if inst.components.health and not inst.components.health:IsDead() then
            inst.sg:GoToState("charge_attack", data.target)
        end
    end),
	EventHandler("attacked", function(inst, data)
	end),
	EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end),
}

local states=
{
    State{
        name= "idle",
        tags = {"idle"},
        
        onenter = function(inst)
			inst.Physics:Stop()
            --inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/wild_boar/oink")
			---inst.AnimState:PlayAnimation("idle") 
			inst.AnimState:PlayAnimation("idle_loop", true)
			inst.sg:SetTimeout( ( 20+math.random(10) ) * FRAMES)
		end,
        
        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,        
    },
    
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
        name = "run_start",
        tags = {"canrotate", "busy", "moving", "running"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
          --  inst.AnimState:PlayAnimation("charge_pre")
			inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },
    },
	
	State{
        name = "run",
        tags = {"canrotate", "moving", "running"},

        onenter = function(inst)
            inst.components.locomotor:RunForward()
           -- inst.AnimState:PlayAnimation("charge_loop")
			inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        onexit = function(inst)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },
    },
	
	State{
        name = "run_stop",
        tags = {"canrotate", "idle"},

        onenter = function(inst) 
			inst.sg:SetTimeout(1*FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

	-------------------------------------------------------------------------------------------------------------------------------
    State{
        name = "charge_attack",
        tags = {"attack", "busy", "notalking", "abouttoattack"},

        onenter = function(inst, target)
		
			----一记猛打
			inst.sg.statemem.target = target
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("charge_atk")
			inst.sg:SetTimeout(12*FRAMES)
        end,

        timeline =
        {
            TimeEvent(8*FRAMES, function(inst)
				inst.sg:RemoveStateTag("abouttoattack")			
                inst.components.combat:DoAttack(inst.sg.statemem.target)
				inst.sg:RemoveStateTag("attack") 
				inst.sg:RemoveStateTag("busy")
            end),
        },

        ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,		
    },
}
  
return StateGraph("zg_cr_icebore", states, events, "idle")
