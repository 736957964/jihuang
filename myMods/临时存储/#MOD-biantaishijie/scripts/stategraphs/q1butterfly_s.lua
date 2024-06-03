require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.POLLINATE, function(inst)
		if inst.sg:HasStateTag("landed") then
			return "pollinate"
		else 
			return "land"
		end
    end),
}

local events=
{
	EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() then
			if inst.prefab=="butterfly" then
				inst.sg:GoToState("attack", data.target)
			elseif inst.prefab=="butterfly" then
				--if wy_needweapon(inst) then inst:EquipWeapon() end
				inst.sg:GoToState("attackr", data.target)
			end
        end
    end),
	CommonHandlers.OnLocomote(true, false),
	
	EventHandler("attacked", function(inst, data)
		if wy_isalive(inst) then
			if inst.sg:HasStateTag("pollinate") then
				inst.sg:GoToState("idle")
			end
		end
	end),
	
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnFreeze(),
}


local states=
{
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
			TimeEvent(12*FRAMES, function(inst)		
				inst.SoundEmitter:PlaySound("wiliya_monster/butterfly/atk"..(inst.pollinator>0 and "2" or "") )
				wy_spawn(inst,"groundpoundring_fx",nil,nil,.6)
			end),
            
			TimeEvent(15*FRAMES, function(inst) 
			
				local plus=inst.pollinator>0
				inst.components.combat:DoAttack(inst.sg.statemem.target,nil,nil,math.random()<(plus and 1 or .5) and "electric",plus and 2 or 1)
				
				local pt = inst:GetPosition()
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 3.5, {"_combat", "_health"}, {"playerghost"})
				for k, v in pairs(ents) do
					if v ~= inst
						and v~= inst.sg.statemem.target
						and (
								v:HasTag("player") 
								or (v.components.combat.target and v.components.combat.target:HasTag("butterfly"))
							)
						then
						inst.components.combat:DoAttack(v,nil,nil,math.random()<(plus and 1 or .5) and "electric",plus and 2 or 1)
					end
				end
				inst.pollinator=inst.pollinator-1
			end),
        },
		
		events=
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
            end),
        },
	},
	
	State{
        name = "attackr",
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
				inst.SoundEmitter:PlaySound("wiliya_monster/butterfly/atk_r" )
				inst.components.combat:DoAttack(inst.sg.statemem.target)
			end),
        },
		
		events=
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
            end),
        },
	},
	
	State{
        name = "pollinate",
        tags = {"busy", "landed", "pollinate"},
        
        onenter = function(inst)
            inst.AnimState:PushAnimation("idle", true)
            inst:PerformBufferedAction()
            inst.sg:SetTimeout(GetRandomWithVariance(3, 1) )
        end,
        
        ontimeout = function(inst)
			inst.pollinator=inst.pollinator+1
			wy_ghealth(inst,50)
            inst.sg:GoToState("takeoff")
        end,
    },
	
	State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
			if inst.pollinator>0 then
				inst.AnimState:SetMultColour(.75,1,1, math.max(.25,1-inst.pollinator*.1) )
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "pollinator", math.min( inst.prefab=="butterfly" and 1.75 or 1,1+inst.pollinator*.1) )
				if inst.prefab=="butterfly" then	--有花粉则用厉害的攻击
					inst:EquipWeapon(2)
				end
			else
				inst.AnimState:SetMultColour(1,1,1,1)
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "pollinator", 1)
			end
			
            inst.Physics:Stop()
            if not inst.AnimState:IsCurrentAnimation("idle_flight_loop") then
                inst.AnimState:PlayAnimation("idle_flight_loop", true)
            end
            inst.sg:SetTimeout( inst.AnimState:GetCurrentAnimationLength() )
        end,

        ontimeout = function(inst)
                inst.sg:GoToState("idle")
        end,
    },
--------------------------------------------------------------
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

}
CommonStates.AddFrozenStates(states)
    
return StateGraph("q1butterfly", states, events, "takeoff", actionhandlers)

