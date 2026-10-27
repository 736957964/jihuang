require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		--inst.SoundEmitter:PlaySound("dontstarve/zg/wx78/hit")
		inst.SoundEmitter:PlaySound("dontstarve/zg/ch_luffy/hit")
		
		--	反弹伤害35%伤害
		local attacker = data.attacker
		local damage = data.damage
		if attacker and damage then
			if attacker.components.combat then
				attacker.components.combat:GetAttacked(inst, damage * .35)
			end
		end
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
            inst.components.locomotor:Stop()
			--inst.SoundEmitter:PlaySound("dontstarve/zg/ch_ace/die")
			
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  
			
			
        end,
    },

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)     
            inst.components.locomotor:Stop()
            local anims = {"idle_loop"}          
            local anim = "idle_loop"                      
            if pushanim then
                for k,v in pairs (anims) do
					inst.AnimState:PushAnimation(v, k == #anims)
				end
            else
                inst.AnimState:PlayAnimation(anims[1], #anims == 1)
                for k,v in pairs (anims) do
					if k > 1 then
						inst.AnimState:PushAnimation(v, k == #anims)
					end
				end
            end  
            inst.sg:SetTimeout(math.random()*4+2)
        end,
    },

    State{
        name = "quickeat",
        tags ={"busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("quick_eat")
        end,

        timeline=
        {
            TimeEvent(12*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("busy")
            end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
        
        onexit= function(inst)
            inst.SoundEmitter:KillSound("eating")    
        end,
    },    
	
-----------------------------------------------------------------------遇到障碍物跳过去-------------------------------------------------------------- 
	State{
        name = "jump",
        tags = {"doing", "busy"},
        
        onenter = function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
	
			inst.AnimState:PlayAnimation("jumpout")
			inst.Physics:SetMotorVel(9.3, 0, 0)
		
			inst.sg.statemem.action = inst.bufferedaction

        end,
        
		onupdate = function(inst)         
            inst.components.locomotor:RunForward()			----	直接冲过去
        end,
		
		onexit = function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
			inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
			inst.Physics:CollidesWith(COLLISION.CHARACTERS)
			local x,y,z = inst.Transform:GetWorldPosition()
			inst.Transform:SetPosition(x,0,z)
			if inst.bufferedaction == inst.sg.statemem.action then
				inst:ClearBufferedAction()
			end
			inst.sg.statemem.action = nil
		end,
		
        timeline=
        {	
			TimeEvent(4.5 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(8.4, 0, 0)
			end),
			TimeEvent(9 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(7.7, 0, 0)
			end),
			TimeEvent(13.5 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(7.1, 0, 0)
			end),
			TimeEvent(15.2 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
			end),
			TimeEvent(16 * FRAMES, function(inst)
				inst.Physics:SetMotorVel(2, 0, 0)
			end),
			TimeEvent(18 * FRAMES, function(inst)
				inst.Physics:Stop()
			end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst)
				local x,y,z = inst.Transform:GetWorldPosition()
				if inst.AnimState:AnimDone() then
					inst.Physics:ClearCollisionMask()
					inst.Physics:CollidesWith(COLLISION.GROUND)
					inst.Physics:CollidesWith(COLLISION.OBSTACLES)
					inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
					inst.Physics:CollidesWith(COLLISION.CHARACTERS)
					inst.Transform:SetPosition(x,0,z)
					inst.sg:GoToState("idle")
				end
			end),
        },
    },    
	
------------------------------------------------------------------------------------------------------------------------------------------------------
    ----攻击
	State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("punch")  
        end,
        
        timeline=
        {	
			TimeEvent(4*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack")
            end),
            TimeEvent(10*FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("attack")
            end),   
        },
        
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end ),
        },
    },    
   
    State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst)
			inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")
            inst.sg.mem.foosteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
        
        timeline=
        {
        
            TimeEvent(4*FRAMES, function(inst)
                PlayFootstep(inst)
                --DoFoleySounds(inst)
            end),
        },        
        
    },

    State{
        
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_loop")
        end,
        
        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst)
				---inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                --PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
                --DoFoleySounds(inst)
            end),
            TimeEvent(15*FRAMES, function(inst)
				--inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                --PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
                --DoFoleySounds(inst)
				
            end),
        },
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
        
        
    },
    
    State{
        name = "run_stop",
        tags = {"canrotate", "idle"},
        
        onenter = function(inst) 
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("run_pst")
        end,
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },       
    },    
}

    
return StateGraph("zg_ch1_luffy", states, events, "idle", actionhandlers)

