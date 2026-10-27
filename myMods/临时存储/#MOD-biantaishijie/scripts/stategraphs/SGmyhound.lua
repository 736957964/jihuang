require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events =
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("idle") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then inst.sg:GoToState("attack", data.target) end end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnFreeze(),
}

local states =
{

    State{
        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, playanim)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/pant")
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
            inst.sg:SetTimeout(2*math.random()+.5)
        end,
    },

	-----------------------------------------------------------------------遇到障碍物跳过去-------------------------------------------------------------- 
	State{
        name = "mydarkjump",
        tags = {"doing", "busy"},
        
        onenter = function(inst)
			--inst.components.locomotor:Stop()
			--inst.components.combat:DoAttack(inst.sg.statemem.target)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
			--inst.Physics:CollidesWith(COLLISION.CHARACTERS)
			--inst.Physics:CollidesWith(COLLISION.GIANTS)
	
			--inst.AnimState:PlayAnimation("jumpout")
			
			--inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PlayAnimation("hit")
			
			inst.Physics:SetMotorVel(9.3, 0, 0)
		
			inst.sg.statemem.action = inst.bufferedaction

        end,
        
		onupdate = function(inst)         
            inst.components.locomotor:RunForward()			----	直接冲过去
        end,
		
		onexit = function(inst)
			--ChangeToCharacterPhysics(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
			inst.Physics:CollidesWith(COLLISION.SANITY)
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
			inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
			
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
					--GLOBAL.ChangeToCharacterPhysics(inst)
					inst.Physics:ClearCollisionMask()
					inst.Physics:CollidesWith(COLLISION.GROUND)
					inst.Physics:CollidesWith(COLLISION.CHARACTERS)
					inst.Physics:CollidesWith(COLLISION.OBSTACLES)
					inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
					
					inst.Transform:SetPosition(x,0,z)
					inst.sg:GoToState("idle")
				end
			end),
        },
    },    
	
----------------更猛的狗狗------------------------------------------------------------------------
    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            --inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
			inst.sg:SetTimeout(3)
        end,

		onupdate = function(inst)         
            inst.components.locomotor:RunForward()			----	直接冲过去
        end,
		
		ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
		
		onexit = function(inst)
            inst.components.locomotor:StopMoving()
        end,
		
        timeline =
        {
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/attack") end),
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            --EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/bite") end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) if inst:PerformBufferedAction() then inst.components.combat:SetTarget(nil) inst.sg:GoToState("idle") else inst.sg:GoToState("idle", "atk_pst") end end),
        },
    },

    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst, cb)
            --inst.Physics:Stop()
            --inst.AnimState:PlayAnimation("hit")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

	--[[
    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {
            TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/bark") end),
            TimeEvent(24*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/bark") end),
        },

        events =
        {
            EventHandler("animover", function(inst) if math.random() < .333 then inst.sg:GoToState("taunt") else inst.sg:GoToState("idle") end end),
        },
    },]]

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/death")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
    },

    State{
        name = "forcesleep",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("sleep_loop", true)
        end,
    },
}

CommonStates.AddSleepStates(states,
{
    sleeptimeline = {
        TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/sleep") end),
    },
})

CommonStates.AddRunStates(states,
{
    runtimeline = {
        TimeEvent(0, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/growl")
            PlayFootstep(inst)
        end),
        TimeEvent(4*FRAMES, PlayFootstep),
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("hound", states, events, "idle", actionhandlers)
