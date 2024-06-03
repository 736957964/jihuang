require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
	end),
	
	EventHandler("zg_ch1_zoro_sanqian", function(inst, data)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("skill") then
			local target=data.target or inst.components.combat.target
			if target then
				inst.sg:GoToState("sanqian",target)
			end
		end
	end),

    EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() then
		
			if not (inst.canpound2 or inst.components.timer:TimerExists("pound2")) then
					inst.components.timer:StartTimer("pound2", 12.5)
				end
			if not (inst.canpound or inst.components.timer:TimerExists("pound")) then
				inst.components.timer:StartTimer("pound", 7.5)
			end 
			
			if inst.canpound2 then
				----死亡旋风
				inst.sg:GoToState("pound2")
			elseif inst.canpound then
				----烦恼风
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
	--三千世界
	State{
        name = "sanqian",
        tags = {"busy", "skill", "jumping"},
		
		onenter = function(inst,target)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("pickaxe_loop")
			inst.sg:SetTimeout(FRAMES*25)
			if inst.components.talker then
				inst.components.talker:Say("【三千世界】")
			end
			inst.sg.statemem.target=target
			--面朝目标
			inst:ForceFacePoint( target.Transform:GetWorldPosition() )
			
			inst.moonstep_dist = inst:GetPosition():Dist(target:GetPosition())
        end,
		
		ontimeout=function(inst)
			wy_spawn(inst,"maxwell_smoke")
			local x,y,z=inst:GetPosition():Get()
			inst.Transform:SetPosition(x,0,z)
			inst.sg:GoToState("idle")
		end,
		
		timeline = 
		{
			TimeEvent(1 * FRAMES, function(inst)
				local vel=(inst.moonstep_dist or 10)*30/17.5*7
				inst.Physics:SetMotorVel(vel, 0, 0)
				wy_spawn(inst,"maxwell_smoke")
			end),
			TimeEvent(10 * FRAMES, function(inst)
				wy_spawn(inst,"maxwell_smoke")
			end),
			
			TimeEvent(15 * FRAMES, function(inst)
				----范围攻击
				local pt = inst:GetPosition()
				local r = 3
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss","playerghost"})
				for k,v in pairs(ents) do
					if v and v.components.health and not v.components.health:IsDead() and v.components.combat then	
						v.components.combat:Zg_GetAttacked(inst, 240)
					end
				end
			end),
		},
		onexit = function(inst)
			
		end
	},

	----极度魔界
	State{
        name = "pound2",
        tags = {"busy", "skill"},
		
		onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("powerup")			
			inst.AnimState:PushAnimation("chop_loop", false)
			inst.sg:SetTimeout(6)
			
        end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
		
		timeline = 
		{
			--跳起结束
			TimeEvent(36*FRAMES, function(inst)
				if inst.components.talker then
					inst.components.talker:Say("【雪舞极度魔界】")
				end
			end),
			
			--发动
			TimeEvent(45*FRAMES, function(inst)
			
			
				--锁定前进方向
				if inst.components.combat.target then
					inst._target_pos = inst.components.combat.target:GetPosition()
				end
				
				----向前推进的单位向量
				local vec
				if inst._target_pos then
					vec = inst._target_pos - inst:GetPosition()
					vec = vec:Normalize()
				else
					local theta = - inst.Transform:GetRotation()
					vec = Vector3( math.cos(theta), 0, math.sin(theta) )
				end
				
				----比伐木工过之而无不及
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
							local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss","playerghost"})
							for k,v in pairs(ents) do
								if v and v.components.health and not v.components.health:IsDead() and v.components.combat then	
									v.components.combat:Zg_GetAttacked(inst, 60)
								end
							end
							
							----释放半月
							local moon = SpawnPrefab("elpheltcrosshair")
							if moon then
								moon.Transform:SetPosition(pt.x, pt.y, pt.z)
								moon.Transform:SetRotation( math.random() * 360 )
								moon.Physics:SetMotorVelOverride(13, 0, 0)
								moon:DoTaskInTime(3, moon.Remove)
								
								local period = .1
	moon.collide_task_table = {}
	moon:DoPeriodicTask(period, function()
	
		local pt = moon:GetPosition()	
		local r = 2
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
		
		for k,v in pairs(ents) do
			if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
				
				if not table.contains(moon.collide_task_table, v.GUID) then
					v.components.combat:Zg_GetAttacked(moon, 60, nil, "zg_ele_dark")
					table.insert(moon.collide_task_table, v.GUID)
				end
				
			end
		end
		
	end)
								
								
								
								
							end
							
						end
						inst._spintick = inst._spintick + 1
						
						
					end)
					
				end
				
			end),
		},
		
		--events=
		--{
		--	EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		--},
		
		onexit = function(inst)
		
			if inst._spintask then
				inst._spintask:Cancel()
				inst._spintask = nil
			end
		
			--
			--inst["zg_inh_anti_physics"] = inst.mem_anti_physics or .5
			--技能结束
			inst.canpound2 = false
			if not inst.components.timer:TimerExists("pound2") then
				inst.components.timer:StartTimer("pound2", 12.5)
			end
		end
		
	},

	----烦恼风
	State{
        name = "pound",
        tags = {"busy", "skill"},
		
		onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("powerup")
			inst.AnimState:PushAnimation("atk", false)
        end,
		
		timeline = 
		{
			--跳起结束
			TimeEvent(36*FRAMES, function(inst)
				if inst.components.talker then
					inst.components.talker:Say("【剪不断理还乱】")
				end
			end),
			
			--发动烦恼风
			TimeEvent(45*FRAMES, function(inst)
			
				----位置
				local x, y, z = inst:GetPosition():Get()
				
				----面向目标
				if inst.components.combat and inst.components.combat.target then
					inst.Transform:SetRotation( inst:GetAngleToPoint( inst.components.combat.target:GetPosition():Get() ) )
				end
				
				local angle_offset = 
				{
					-7.5,
					0,
					7.5
				}	
				----定义烦恼风
				for k, v in pairs(angle_offset) do
				
					for i = 1, 3 do
						inst:DoTaskInTime( i * .1, function()
							local fx = SpawnPrefab("tornado")
							if fx then
								fx.Transform:SetPosition(x, y, z)
								----烦恼风推进
								fx.Transform:SetRotation( inst.Transform:GetRotation() + v )
								fx.Physics:SetMotorVelOverride( 6, 0, 0)
							end
						end)
						
					end
				end
				
			end),
		},
		
		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},
		
		onexit = function(inst)
		
			--技能结束
			inst.canpound = false
			if not inst.components.timer:TimerExists("pound") then
				inst.components.timer:StartTimer("pound", 7.5)
			end
		end
		
	},

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
			--inst.SoundEmitter:PlaySound("dontstarve/zg/ch_zoro/die")
			--inst.SoundEmitter:PlaySound("dontstarve/zg/wx78/die")
			
			inst.SoundEmitter:PlaySound("zg_ch1_zoro/zg_ch1_zoro/die")
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
	
------------------------------------------------------------------------------------------------------------------------------------------------------
    ----攻击
	State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk")  
        end,
        
        timeline=
        {	
            TimeEvent(6*FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),   
			
			TimeEvent(10*FRAMES, function(inst)
				
				--[[
				if math.random() < .15 then
					inst.SoundEmitter:PlaySound("zg_ch1_zoro/zg_ch1_zoro/fannao")
					if inst.components.talker then
						inst.components.talker:Say("【百八烦恼风】")
					end
					inst.components.combat:DoAttack(inst.sg.statemem.target)
					--inst.components.combat:DoAttack(inst.sg.statemem.target)
					--inst.components.combat:DoAttack(inst.sg.statemem.target)
					--inst.components.combat:DoAttack(inst.sg.statemem.target)
				end]]
				
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
			--inst.AnimState:PlayAnimation("zg_zororun")
            inst.sg.mem.foosteps = 0
			--inst.sg:SetTimeout(1*FRAMES)
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

		--ontimeout = function(inst)
		--	inst.sg:GoToState("run")
		--end,
		
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
        
        timeline=
        {
        
            TimeEvent(4*FRAMES, function(inst)
                --PlayFootstep(inst)
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
			--inst.AnimState:PlayAnimation("zg_zororun")
        end,
        
        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst)
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                --PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
                --DoFoleySounds(inst)
            end),
            TimeEvent(15*FRAMES, function(inst)
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
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
			--inst.AnimState:PlayAnimation("zg_zororun")
			--inst.sg:SetTimeout(1*FRAMES)
        end,
		
		--ontimeout = function(inst)
		--	inst.sg:GoToState("idle")
		--end,
        
        events=
        {   
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },       
    },    
}

    
return StateGraph("zg_ch1_zoro", states, events, "idle", actionhandlers)

