require("stategraphs/commonstates")

local function DoFoleySounds(inst)
end

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		----inst.SoundEmitter:PlaySound("dontstarve/zg/wilson/hit")
		if inst.sg:HasStateTag("zg_summon") then
			inst.sg:GoToState("idle")
		end
	end),

    EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() then
            if not (inst.canpound or inst.components.timer:TimerExists("pound")) then
				inst.components.timer:StartTimer("pound", 5)
			end
			if inst.canpound then
				inst.sg:GoToState("pound")
			else
				inst.sg:GoToState("attack")
			end
        end
    end),
    
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end),
}

local states= 
{

	State{
		name = "pound",
		tags = {"busy", "pound"},

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("powerup")
			inst.AnimState:PushAnimation("shovel_loop")
			inst.AnimState:PushAnimation("spearjab")
			inst.AnimState:PushAnimation("idle", false)
			
			----现在瞄准目标位置
			local target = inst.components.combat and inst.components.combat.target
			if target then
				inst._target_pos = target:GetPosition()
				--inst._current_pos = inst:GetPosition()
				--inst._pos = inst._current_pos + (inst._target_pos - inst._current_pos) * 5
				
				--inst.Transform:SetRotation( inst:GetAngleToPoint( inst._pos:Get() ) )
			end
			
			--if inst._fx ~= nil then
			--	inst._fx:kill_fx()
			--end
			--inst._fx = SpawnPrefab("forcefieldfx")
			--if inst._fx then
			--	inst._fx.entity:SetParent(inst.entity)
			--	inst._fx.Transform:SetPosition(0, 0.2, 0)
			--end
			--inst["zg_inh_anti_physics"] = 1
			
		end,

		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline=
		{
			TimeEvent(36*FRAMES, function(inst)
			
				local fx = SpawnPrefab("maxwell_smoke")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			
				--开始突击
				--inst.Transform:SetRotation( inst:GetAngleToPoint( inst._pos:Get() ) )
				--inst.Physics:SetMotorVelOverride(120,0,0)
				--inst.Physics:SetMotorVel(160,0,0)
				
				----向前推进的单位向量
				local vec
				if inst._target_pos then
					vec = inst._target_pos - inst:GetPosition()
					vec = vec:Normalize()
				else
					local theta = - inst.Transform:GetRotation()
					vec = Vector3( math.cos(theta), 0, math.sin(theta) )
				end
				
				if vec and inst.collide_task == nil then
				
					local period = 1/30
					local velocity = (inst.components.locomotor.runspeed or 4) * 2
					inst.collide_task_table = {}
					inst.collide_task = inst:DoPeriodicTask( period, function()
					
						----持续前进
						local pos = inst:GetPosition()
						inst.Transform:SetPosition( (pos + vec * period * velocity):Get() )
					
						local r = 2.5
						local pt = inst:GetPosition()
						local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
						for k, v in pairs(ents) do 
							if v and v.components.combat and v.components.health and not v.components.health:IsDead() then
								
								--	突击+900%物理伤害
								if not table.contains(inst.collide_task_table, v.GUID) then
									v.components.combat:Zg_GetAttacked(inst, 600 , nil, nil, true)
									table.insert(inst.collide_task_table, v.GUID)
								
									
								end
								
							end
						end
					end)
				end
				
			end),
			TimeEvent(54*FRAMES, function(inst)
				--inst.Physics:SetMotorVelOverride(120,0,0)
				local fx = SpawnPrefab("maxwell_smoke")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end),
			TimeEvent(72*FRAMES, function(inst)
				--inst.Physics:SetMotorVelOverride(120,0,0)
				local fx = SpawnPrefab("maxwell_smoke")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end),
			
		},
		
		onexit = function(inst)
			local fx = SpawnPrefab("maxwell_smoke")
			fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			
				
			--技能结束
			inst.canpound = false
			if not inst.components.timer:TimerExists("pound") then
				inst.components.timer:StartTimer("pound", 5)
			end

			
			if inst.collide_task ~= nil then
				inst.collide_task:Cancel()
				inst.collide_task = nil
			end
		end,
	},

	State{
		name = "summon_perd",
        tags = {"busy", "zg_summon"},
		onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.talker:Say("Turkeys!")
			
            local pt = Vector3(inst.Transform:GetWorldPosition())
			inst:StartThread(function()
				for k = 1, inst:NumPerdsToSpawn() do
					local theta = math.random() * 2 * PI
					local radius = math.random(3, 8)
					local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
						local pos = pt + offset
						local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
						return next(ents) == nil
					end)
					if result_offset ~= nil then
						local pos = pt + result_offset
						local perd = SpawnPrefab("zg_mo_perd")
						perd.Transform:SetPosition(pos:Get())
						perd.components.follower:SetLeader(inst)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
					end
					Sleep(.33)
				end
			end)
			
			inst.SoundEmitter:PlaySound("dontstarve/zg/spell/summon01")
			inst.AnimState:PlayAnimation("emote_hands")
        end, 
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
	},

	State{
		name = "summon_bunny",
        tags = {"busy"},
		onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.talker:Say("Help! Bunnyman!")
			
            local x,y,z = inst.Transform:GetWorldPosition()
			local bunny = SpawnPrefab("zg_mo_bunny")
			bunny.Transform:SetPosition(x-3+math.random(5), y, z-3+math.random(5))
			inst.components.leader:AddFollower(bunny)
			
			local fx = SpawnPrefab("statue_transition_2")
			fx.Transform:SetPosition(bunny.Transform:GetWorldPosition())
			
			inst.SoundEmitter:PlaySound("dontstarve/zg/spell/summon01")
			inst.AnimState:PlayAnimation("emoteXL_kiss")
        end, 
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
	},

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.SoundEmitter:PlaySound("dontstarve/zg/wilson/die")
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  
			--SpawnPrefab("zg_ut_adventure").Transform:SetPosition(inst.Transform:GetWorldPosition())
			
			
			
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
	

------------------------------------------------------------------------------------------------------------------------------------------------------
    State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            
			inst.components.locomotor:Stop()
			
			inst.AnimState:PlayAnimation("spearjab")
			
			----现在瞄准目标位置
			local target = inst.components.combat and inst.components.combat.target
			if target then
				inst._target_pos = target:GetPosition()
				inst._current_pos = inst:GetPosition()
				inst._pos = inst._current_pos + (inst._target_pos - inst._current_pos) * 5
				
				--inst.Transform:SetRotation( inst:GetAngleToPoint( inst._pos:Get() ) )
			end
			
        end,
        
        timeline=
        {	
			TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
            TimeEvent(10*FRAMES, function(inst) 
				--inst.components.combat:DoAttack(inst.sg.statemem.target) 
				
				inst.Transform:SetRotation( inst:GetAngleToPoint( inst._pos:Get() ) )
				
				local pt = inst.sg.statemem.target and inst.sg.statemem.target:GetPosition()
				inst.attack_task_table = {}
				local r = 2.5
				local pt = inst:GetPosition()
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
				for k, v in pairs(ents) do 
					if v and v.components.combat and v.components.health and not v.components.health:IsDead() then
						
						if not table.contains(inst.attack_task_table, v.GUID) then
							
							local x,y,z = v.Transform:GetWorldPosition()
							SpawnPrefab("collapse_small").Transform:SetPosition(x,y,z)
							
							v.components.combat:Zg_GetAttacked(inst, 60, nil, nil, true)
							table.insert(inst.attack_task_table, v.GUID)
							
                            -------------这一段新加的
							if v.Physics and v.Transform and v.components.locomotor then
							
								if v.components.playercontroller ~= nil then
									v.components.playercontroller:Enable(false)
								end
							
								v.Physics:ClearMotorVelOverride()
								v.components.locomotor:Stop()
								
								v.Transform:SetRotation( -inst.Transform:GetRotation() )
								v.Physics:SetMotorVelOverride(-40,0,0)
								
								v:DoTaskInTime(.25, function()
		
									if v.components.playercontroller ~= nil then
										v.components.playercontroller:Enable(true)
									end
										
								end)
							end
							----------------------------------------------------------------------
						end
						
					end
				end
				
				
				inst.sg:RemoveStateTag("abouttoattack") 
			end),  
			TimeEvent(11*FRAMES, function(inst) 
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
                DoFoleySounds(inst)
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
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
                DoFoleySounds(inst)
            end),
            TimeEvent(15*FRAMES, function(inst)
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
                DoFoleySounds(inst)
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

    
return StateGraph("zg_ch_wilson", states, events, "idle", actionhandlers)

