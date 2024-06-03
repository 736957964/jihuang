require("stategraphs/commonstates")

local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(true,true),
    --CommonHandlers.OnSleep(),
    --CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttack(),
	EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("attack", data.target)
        end
    end),
    --CommonHandlers.OnAttacked(true),
	EventHandler("attacked", function(inst, data)
		--inst.SoundEmitter:PlaySound("dontstarve/zg/wx78/hit")
		inst.SoundEmitter:PlaySound("zg_cr_icepig/zg_cr_icepig/hit")
	end),
	
    --CommonHandlers.OnDeath(),
	EventHandler("death", function(inst)
	
        inst.sg:GoToState("death")
    end),
	
    --EventHandler("transformnormal", function(inst) if not inst.components.health:IsDead() then inst.sg:GoToState("transformNormal") end end),
    
}

local states=
{
    State{
        name= "funnyidle",
        tags = {"idle"},
        
        onenter = function(inst)
			inst.Physics:Stop()
            local daytime = not TheWorld.state.isnight
            --inst.SoundEmitter:PlaySound("dontstarve/pig/oink")
            
            if inst.components.follower.leader and inst.components.follower:GetLoyaltyPercent() < 0.05 then
                inst.AnimState:PlayAnimation("hungry")
                --inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry")
            elseif inst:HasTag("guard") then
                inst.AnimState:PlayAnimation("idle_angry")
            elseif daytime then
                if inst.components.combat.target then
                    inst.AnimState:PlayAnimation("idle_angry")
                elseif inst.components.follower.leader and inst.components.follower:GetLoyaltyPercent() > 0.3 then
                    inst.AnimState:PlayAnimation("idle_happy")
                else
                    inst.AnimState:PlayAnimation("idle_creepy")
                end
            else
                inst.AnimState:PlayAnimation("idle_scared")
            end
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
			inst.SoundEmitter:PlaySound("zg_cr_icepig/zg_cr_icepig/die")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
    
    State{
		name = "abandon",
		tags = {"busy"},
		
		onenter = function(inst, leader)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("abandon")
            inst:FacePoint(Vector3(leader.Transform:GetWorldPosition()))
		end,
		
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
    
    
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            --inst.SoundEmitter:PlaySound("dontstarve/pig/attack")
            --inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
			inst.sg.statemem.target = target
			inst.SoundEmitter:PlaySound("zg_cr_icepig/zg_cr_icepig/atk")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
        end,
        
        timeline=
        {
            TimeEvent(13*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target) 
				inst.sg:RemoveStateTag("attack") 
				inst.sg:RemoveStateTag("busy") 
			end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
})



CommonStates.AddIdle(states,"funnyidle")
CommonStates.AddSimpleState(states,"refuse", "pig_reject", {"busy"})
    
return StateGraph("zg_cr_icepig", states, events, "idle")

