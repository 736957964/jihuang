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
			inst.AnimState:PlayAnimation("emote_hands")
			inst.AnimState:PushAnimation("chop_loop", false)
			
			inst.sg:SetTimeout(6)
			
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,

		timeline=
		{
		
			----手部动作结束
			--TimeEvent(61*FRAMES, function(inst)
			
			--end),
			
			TimeEvent(65*FRAMES, function(inst)
			
				if inst.components.combat.target then
					inst._target_pos = inst.components.combat.target:GetPosition()
				end
				local vec
				if inst._target_pos then
					vec = inst._target_pos - inst:GetPosition()
					vec = vec:Normalize()
				else
					local theta = - inst.Transform:GetRotation()
					vec = Vector3( math.cos(theta), 0, math.sin(theta) )
				end
				
				if vec and inst._spintask == nil then
				
					----开始旋转
					local period = 1/30
					local velocity = inst.components.locomotor.runspeed or 4
					local w = 360 * 8
					inst._spintick = 0
					inst._spintask = inst:DoPeriodicTask( period, function()
					
						----动画
						inst.AnimState:SetPercent("chop_loop", 0.078 + math.random() * 0.078)	--手伸最长时
						
						----持续前进
						local pos = inst:GetPosition()
						inst.Transform:SetPosition( (pos + vec * period * velocity):Get() )
						
						----持续旋转
						local rot = inst.Transform:GetRotation()
						rot = rot + period * w
						while rot > 360 do
							rot = rot - 360
						end
						inst.Transform:SetRotation( rot )
						
						----判定伤害, 转一圈就是一次伤害
						local ticknum = math.ceil( 360/ w / period )
						if ticknum > 0 and inst._spintick % ticknum == 0 then
							
							----范围攻击
							local pt = inst:GetPosition()
							local r = 3
							local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
							for k,v in pairs(ents) do
								if v and v.components.health and not v.components.health:IsDead() and v.components.combat then	
									v.components.combat:Zg_GetAttacked(inst, 60)
								end
							end
							
						end
						inst._spintick = inst._spintick + 1
						
					end)
					
				end
				
			end),
			
			
			
		},
		
		onexit = function(inst)
		
			if inst._spin_fx then
				inst._spin_fx:Remove()
				inst._spin_fx = nil
			end
		
			if inst._spintask then
				inst._spintask:Cancel()
				inst._spintask = nil
			end
		
			
			inst.canpound = false
			if not inst.components.timer:TimerExists("pound") then
				inst.components.timer:StartTimer("pound", 5)
			end
		end,
		
	},

	State{
		name = "summon_perd",
        tags = {"busy"},
		onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.talker:Say("老陈喜欢吃泡面~!")
			
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
						---local perd = SpawnPrefab("zg_mo_beaver")
						---perd.Transform:SetPosition(pos:Get())
						---perd.components.follower:SetLeader(inst)
						---SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
					end
					Sleep(.33)
				end
			end)
			
			---inst.SoundEmitter:PlaySound("dontstarve/zg/spell/summon01")
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
			---inst.SoundEmitter:PlaySound("dontstarve/zg/wilson/die")
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  
			
			----生成会动的树木
			--local x, y, z = inst.Transform:GetWorldPosition()
			--SpawnPrefab("zg_mo_evergreen").Transform:SetPosition(x + 5, y, z + 5)
			--SpawnPrefab("zg_mo_evergreen").Transform:SetPosition(x - 5, y, z + 5)
			--SpawnPrefab("zg_mo_evergreen").Transform:SetPosition(x + 5, y, z - 5)
			--SpawnPrefab("zg_mo_evergreen").Transform:SetPosition(x - 5, y, z - 5)
			
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
			
			if math.random() < .125 then
				inst.SoundEmitter:PlaySound("dontstarve/zg/wilson/call")
			end
				
			inst.AnimState:PlayAnimation("chop_loop")
        end,
        
        timeline=
        {	
			TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
            TimeEvent(8*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target) 
				inst.sg:RemoveStateTag("abouttoattack") 
			end),  
			TimeEvent(10*FRAMES, function(inst) 
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

