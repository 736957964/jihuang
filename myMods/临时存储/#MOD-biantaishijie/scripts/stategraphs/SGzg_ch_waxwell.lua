require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		--inst.SoundEmitter:PlaySound("dontstarve/zg/wilson/hit")
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
			inst.AnimState:PushAnimation("mime5", false)
			
			
		end,
		
		timeline = 
		{
			--跳起结束
			TimeEvent(36*FRAMES, function(inst)
				
			end),
			
			--pose结束
			TimeEvent(77*FRAMES, function(inst)
				
				----位置
				local x, y, z = inst:GetPosition():Get()
				
				----面向目标
				if inst.components.combat and inst.components.combat.target then
					inst.Transform:SetRotation( inst:GetAngleToPoint( inst.components.combat.target:GetPosition():Get() ) )
				end
				
				----定义黑电
				local angle_offset = 
				{
					75, 60, 45, 30, 15, 
					0,
					-15, -30, -45, -60, -75, -90
				}	
				local angle_offset2 = math.random(30) / 2
				for k, v in pairs(angle_offset) do
				
					local fx = SpawnPrefab("lightning")
					if fx then
						fx.Transform:SetPosition(x, y, z)
						fx:AddTag("fx")
						
						fx:AddComponent("combat")
							MakeInventoryPhysics(fx)
						RemovePhysicsColliders(fx)
						----黑电推进
						fx.Transform:SetRotation( inst.Transform:GetRotation() + angle_offset[k] + angle_offset2 )
						fx.Physics:SetMotorVelOverride( 10, 0, 0)
						
						local meleeweapon = CreateEntity()
	meleeweapon.entity:AddTransform()
	meleeweapon:AddComponent("weapon")
	meleeweapon.components.weapon:SetDamage(0)
	meleeweapon:AddComponent("inventoryitem")
	meleeweapon.persists = false
	meleeweapon.zg_electrocute_mult = 4
	meleeweapon.components.inventoryitem:SetOnDroppedFn(fx.Remove)
	meleeweapon:AddComponent("equippable")
						
					local period = 1/30
	fx.collide_task_table = {}
	fx:DoPeriodicTask(period, function()
	
		local pt = fx:GetPosition()	
		local r = 1.5
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
		
		for k,v in pairs(ents) do
			if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
				
				if not table.contains(fx.collide_task_table, v.GUID) then
					v.components.combat:Zg_GetAttacked(fx, 60, nil, "zg_ele_dark")
					v.components.combat:Zg_GetAttacked(fx, 60, meleeweapon, "zg_ele_electric")
					table.insert(fx.collide_task_table, v.GUID)
				end
				
			end
		end
		
	end)	

	----生命周期
	fx.zg_lifetime = 4
	fx:DoTaskInTime(fx.zg_lifetime, function()
		if fx then
			fx:Remove()
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
				inst.components.timer:StartTimer("pound", 5)
			end
		end
	},

	State{
		name = "summon_perd",			--为了匹配AI而起的名字, 这里召唤的是影子
        tags = {"busy", "zg_summon"},
		onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.talker:Say("Shadows!")
			
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
						--local perd = SpawnPrefab("zg_mo_shadow")
						--perd.Transform:SetPosition(pos:Get())
						--perd.components.follower:SetLeader(inst)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
					end
					Sleep(.33)
				end
			end)
			
			--inst.SoundEmitter:PlaySound("dontstarve/zg/spell/summon01")
			inst.AnimState:PlayAnimation("emote_hands")
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
			--inst.SoundEmitter:PlaySound("dontstarve/zg/wilson/die")
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
			
			inst.AnimState:PlayAnimation("atk")
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
        end,
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },       
    },    
}

    
return StateGraph("zg_ch_waxwell", states, events, "idle", actionhandlers)

