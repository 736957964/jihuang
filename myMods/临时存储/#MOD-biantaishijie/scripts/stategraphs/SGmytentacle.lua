require("stategraphs/commonstates")

local events=
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("hit") and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnFreeze(),
	CommonHandlers.OnLocomote(false,true),
	EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then 
            --inst.sg:GoToState("attack_pre", data.target)
			inst.sg:GoToState("attack", data.target)
        end 
    end),
}

local states=
{
	State{
        name = "walk_start",
        tags = {"moving","canrotate"},

        onenter = function(inst) 
            --inst.AnimState:PlayAnimation("walk_pre")
			inst.AnimState:PlayAnimation("breach_pre")
        end,

        events =
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
        },
    },
        
    State{            
        name = "walk",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:WalkForward()
            --inst.AnimState:PlayAnimation("walk_loop")
			inst.AnimState:PlayAnimation("breach_pre")
        end,
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
        },
        
    },      
    
    State{            
        name = "walk_stop",
		tags = {"canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:StopMoving()
            --inst.AnimState:PlayAnimation("walk_pst")
			inst.AnimState:PlayAnimation("breach_pre")
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },
    },

	State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            --inst.AnimState:PlayAnimation("idle_loop")
			--inst.AnimState:PlayAnimation("idle", true)
			inst.AnimState:PlayAnimation("breach_pre")
        end,

        timeline = 
        {
            --TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/swipe_tail") end),
        },

        events = 
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name ="attack_pre",
        tags = {"attack"},
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_emerge")
            --inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
			--if not inst.SoundEmitter:PlayingSound("tentacle") then
			--	inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_rumble_LP", "tentacle")
			--end      
			--inst.SoundEmitter:SetParameter( "tentacle", "state", 1)      
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
        },
        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_emerge_VO") end),
        }
        
    },
    
    State{ 
        name = "attack",
        tags = {"attack","busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("atk_loop")
            inst.AnimState:PushAnimation("atk_idle", false)
			inst.sg:SetTimeout(2)
        end,
        
        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
			
			TimeEvent(7*FRAMES, function(inst)
				--[[
				local pt = inst:GetPosition()
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4)
				for k,v in pairs(ents) do
					if v and v.components.health and not v.components.health:IsDead() and v ~= inst and v.components.combat and v:HasTag("player") then
						inst.components.combat:DoAttack(v)
					end
				end]]
				inst.components.combat:DoAttack() 
			end),
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
			
            TimeEvent(17*FRAMES, function(inst)
				--[[
				local pt = inst:GetPosition()
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4)
				for k,v in pairs(ents) do
					if v and v.components.health and not v.components.health:IsDead() and v ~= inst and v.components.combat and (v:HasTag("player") or v:HasTag("character")) then
						--v.components.combat:GetAttacked(inst, 34)
						inst.components.combat:DoAttack(v)
					end
				end]]
				inst.components.combat:DoAttack() 
			end),
            TimeEvent(18*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") inst.sg:RemoveStateTag("busy") end),
        },
		
		ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
        
		onupdate = function(inst)         
			inst.components.locomotor:RunForward()		--直接冲过去抽玩家
        end,
		
		onexit = function(inst)
            inst.components.locomotor:StopMoving()
        end,
		
        events=
        {
            EventHandler("animqueueover", function(inst) 
                if inst.components.combat.target then
                    inst.sg:GoToState("attack_post") 
                end
            end),
        },
    },
 
------------------------------------------------------------------------------------------------------- 
    State{
        name ="attack_post",
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_disappear")
            inst.AnimState:PlayAnimation("atk_pst")
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.SoundEmitter:KillAllSounds() inst.sg:GoToState("idle") end),
        },
    },
    
    
	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_death_VO")
            inst.AnimState:PlayAnimation("death")
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
        
        events =
        {
            EventHandler("animover", function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_splat")
			end ),
        },        
    },
    
        
    State{
        name = "hit",
        tags = {"busy", "hit"},
        
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_hurt_VO")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
        },
        
    },    
    
}
CommonStates.AddFrozenStates(states)
    
return StateGraph("tentacle", states, events, "idle")

