require("stategraphs/commonstates")

local function beardit(inst, anim)
    return "beard_"..anim
end

local events =
{
    CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		
	end),

    EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("attack")
        end
    end),
    
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end),
}

local states=
{


	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/death")
			inst.SoundEmitter:PlaySound("dontstarve/zg/spell/summon02")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)                     
        end,
        
    },
    
	State{
        name= "funnyidle",
        tags = {"busy"},
        
        onenter = function(inst)
			inst.Physics:Stop()
            inst.AnimState:PlayAnimation("beard_taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_taunt")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_attack")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation(beardit(inst,"atk"))
        end,
        
        timeline=
        {
            TimeEvent(13*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/bite")        
				inst.components.combat:DoAttack()
				inst.sg:RemoveStateTag("attack") 
				inst.sg:RemoveStateTag("busy") 
			end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
	State{
		name = "run_start",
		tags = {"moving", "running", "canrotate"},
	    
		onenter = function(inst) 
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("beard_run_pre")
		end,

		events=
		{   
			EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
		},
	},

	State{
		name = "run",
		tags = {"moving", "running", "canrotate"},

		onenter = function(inst) 
            inst.components.locomotor:RunForward()

            if not inst.AnimState:IsCurrentAnimation("beard_run_loop") then
                inst.AnimState:PlayAnimation("beard_run_loop", true)
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

		timeline =
		{
		    TimeEvent(0*FRAMES, PlayFootstep),
		    TimeEvent(10*FRAMES, PlayFootstep),
		},

		ontimeout = function(inst)
		     inst.sg:GoToState("run")
		end,
	},

	State{
		name = "run_stop",
		tags = {"canrotate"},
	    
		onenter = function(inst) 
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("beard_run_pst")
		end,
	    
		events=
		{   
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
		},
	},
    
	State{
		name = "walk_stop",
		tags = {"canrotate"},
	    
		onenter = function(inst) 
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("beard_walk_pst")
		end,
		
		events=
		{   
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
		},
	},
}

CommonStates.AddIdle(states,"funnyidle", function(inst) return beardit(inst,"idle_loop") end, 
{
    TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_breathin") end ),
    TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_idle") end ),
})
    
return StateGraph("zg_mo_bunny", states, events, "idle")

