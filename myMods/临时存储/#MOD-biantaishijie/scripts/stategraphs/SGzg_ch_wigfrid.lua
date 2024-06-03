require("stategraphs/commonstates")

local function DoFoleySounds(inst)

	--for k,v in pairs(inst.components.inventory.equipslots) do
		--if v.components.inventoryitem and v.components.inventoryitem.foleysound then
		--	inst.SoundEmitter:PlaySound(v.components.inventoryitem.foleysound)
		--end
	--end

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
				inst.components.timer:StartTimer("pound", inst.pound_cd)
			end
			if not (inst.canpound2 or inst.components.timer:TimerExists("pound2")) then
				inst.components.timer:StartTimer("pound2", inst.pound2_cd)
			end
			
			if inst.canpound then
				if inst._is_riding then	
					----下来
					inst.sg:GoToState("dismount")
				else
					inst.sg:GoToState("pound")
				end
			elseif inst.canpound2 then
				if inst._is_riding then
					inst.sg:GoToState("attack")
				else
					----骑上
					inst.sg:GoToState("pound2")
				end
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
		name = "pound2",
		tags = {"busy", "pound"},
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
            inst.AnimState:OverrideSymbol("horn01", "horn", "horn01")
            inst.AnimState:Show("ARM_normal")
			
		end,
		
		timeline =
        {
            TimeEvent(21*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
            end),
        },
		
		events =
        {
            EventHandler("animqueueover", function(inst)
			
				--骑上牛
				inst.AnimState:SetBank("wilsonbeefalo")
				
				--牛在下面
				inst.AnimState:AddOverrideBuild("beefalo_baby_build")
				
				inst.AnimState:OverrideSymbol("swap_saddle", "saddle_war", "swap_saddle")
				inst.Transform:SetSixFaced()
				inst.DynamicShadow:SetSize(6, 2)
				inst.sg:GoToState("mount")
				
            end),
        },

        onexit = function(inst)
            
            inst.AnimState:Show("ARM_carry") 
			inst.AnimState:Hide("ARM_normal")
			
			--
			inst.canpound2 = false
			if not inst.components.timer:TimerExists("pound2") then
				inst.components.timer:StartTimer("pound2", inst.pound2_cd)
			end
           
        end,
		
	},
	
	State{
        name = "mount",
        tags = { "doing", "busy", "pound"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("mount")
			
			----
			inst._is_riding = true
			inst.components.health:SetAbsorptionAmount(.9)
			inst.components.combat:SetRange(3)
			inst.components.locomotor:SetExternalSpeedMultiplier(inst, "zg_ch_wigfrid_beefalo", 1.2)
			
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/beefalo/saddle/dismount")
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("mounted_idle")
            end),
        },

        onexit = function(inst)
            
        end,
    },
	
	State{
        name = "mounted_idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst, pushanim)

            inst.AnimState:PlayAnimation("idle_loop", true)

            inst.sg:SetTimeout(2 + math.random() * 8)
        end,

        ontimeout = function(inst)
            
            inst.sg:GoToState("graze")
               
        end,
    },
	
	State{
        name = "graze",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("graze_loop", true)
            inst.sg:SetTimeout(1 + math.random() * 5)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("mounted_idle")
        end,
    },

------------------------------------------------------------------------------------------------------------------------------------------
	State{
        name = "dismount",
        tags = { "doing", "busy", "pound"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("dismount")
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/saddle/dismount")
        end,

        events =
        {
            EventHandler("animover", function(inst)
				
				----从牛身上下来就要发技能了
                inst.sg:GoToState("pound")
				
            end),
        },

        onexit = function(inst)
		
			inst._is_riding = false
			inst.components.health:SetAbsorptionAmount(.8)
			inst.components.combat:SetRange(2)
			inst.components.locomotor:SetExternalSpeedMultiplier(inst, "zg_ch_wigfrid_beefalo", 1)
			
			----还原bank
			inst.AnimState:SetBank("wilson")
			inst.AnimState:ClearOverrideSymbol("swap_saddle")
			inst.Transform:SetFourFaced()
			inst.DynamicShadow:SetSize(1.3, .6)
        end,
    },

	State{
		name = "pound",
		tags = {"busy", "pound"},

		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("powerup")
			--inst.AnimState:PlayAnimation("emote_hands")
			inst.AnimState:PushAnimation("spearjab", false)
			
			--特效
			--local fx = SpawnPrefab("mossling_spin_fx")
			--fx.entity:SetParent(inst.entity)
			--fx.Transform:SetPosition(0,0.1,0)
			
			inst.sg:SetTimeout(6)
			
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,

		--[[
		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},]]

		timeline=
		{
		
			----手部动作结束
			--TimeEvent(36*FRAMES, function(inst)
			
			--end),
			
			TimeEvent(46*FRAMES, function(inst)
			
				--旋风状态实体攻击无效
				--inst["zg_inh_anti_physics"] = .95
			
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
				
				if vec and inst._spintask == nil then
				
					----开始旋转
					local period = 1/30
					local velocity = inst.components.locomotor.runspeed or 4
					local w = 360 * 8
					inst._spintick = 0
					inst._spintask = inst:DoPeriodicTask( period, function()
					
						----动画
						--inst.AnimState:SetPercent("spearjab", 0.323 + math.random() * 0.031)	--手伸最长时
						inst.AnimState:SetPercent("spearjab", 0.354)
						
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
									v.components.combat:Zg_GetAttacked(inst, 80)
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
		
			--
			--inst["zg_inh_anti_physics"] = inst.mem_anti_physics or .5
			
			inst.canpound = false
			if not inst.components.timer:TimerExists("pound") then
				inst.components.timer:StartTimer("pound", inst.pound_cd)
			end
		end,
		
	},

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.SoundEmitter:PlaySound("dontstarve/zg/willow/die")
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
			
			--idle分支, 妙
			if inst._is_riding then
                inst.sg:GoToState("mounted_idle")
                return
            end
			
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
			
			if inst._is_riding then
				--inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PlayAnimation("atk")
			else
				inst.AnimState:PlayAnimation("spearjab")
			end
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
	
	
---------------------------------------------------------------------------------------------------------------------	
   
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

    
return StateGraph("zg_ch_wigfrid", states, events, "idle", actionhandlers)

