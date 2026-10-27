require("stategraphs/commonstates")

local function DoFoleySounds(inst)

	--for k,v in pairs(inst.components.inventory.equipslots) do
	--if v.components.inventoryitem and v.components.inventoryitem.foleysound then
			--inst.SoundEmitter:PlaySound(v.components.inventoryitem.foleysound)
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
			
			inst.AnimState:PlayAnimation("emote_pants")
			inst.AnimState:PushAnimation("powerup")
			inst.AnimState:PushAnimation("powerdown", false)
			
		end,
		
		timeline = 
		{
			--提裤子结束
			TimeEvent(49*FRAMES, function(inst)
				
			end),
			
			--跳起结束
			TimeEvent(85*FRAMES, function(inst)
				
				--发射死亡头颅
				
				----位置
				local x, y, z = inst:GetPosition():Get()
				
				----偏差
				local offset =
				{
					{x = 1, z = 0},
					{x = 0, z = 1},
					{x = -1, z = 0},
					{x = 0, z = -1},					
					{x = .5, z = .87},
					{x = .87, z = .5},					
					{x = .5, z = -.87},
					{x = .87, z = -.5},					
					{x = -.5, z = -.87},
					{x = -.87, z = -.5},					
					{x = -.5, z = .87},
					{x = -.87, z = .5},
				}
				
				----定义死亡骷髅
				local angle_offset = math.random (180 / #offset) 
				for k = 1, #offset do
				
					local fx = SpawnPrefab("elpheltcrosshair")
					if fx then
						fx.Transform:SetPosition(x + offset[k].x, 0, z + offset[k].z)
						
						----推进
						fx.Transform:SetRotation( fx:GetAngleToPoint( x, y, z ) + angle_offset )
						fx.Physics:SetMotorVelOverride(-10,0,0)
						
						fx:DoTaskInTime(5, fx.Remove)
						
                        ----伤害
	local period = .1
	fx.collide_task_table = {}
	fx:DoPeriodicTask(period, function()
	
		local pt = fx:GetPosition()	
		local r = 2
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
		
		for k,v in pairs(ents) do
			if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
				
				if not table.contains(fx.collide_task_table, v.GUID) then
					v.components.combat:Zg_GetAttacked(fx, 60, nil, "zg_ele_dark")
					table.insert(fx.collide_task_table, v.GUID)
				end
				
			end
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
			inst.components.combat:SetRange(2)
			inst.canpound = false
			if not inst.components.timer:TimerExists("pound") then
				inst.components.timer:StartTimer("pound", 5)
			end
		end
	},

	State{
		name = "summon_perd",		--用的威尔逊的AI, 匹配名字而已,这里召唤的是 姐姐
        tags = {"busy", "zg_summon"},
		onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.talker:Say("Where is my sister!")
			
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
						local perd = SpawnPrefab("zg_mo_abigail")
						perd.Transform:SetPosition(pos:Get())
						perd.components.follower:SetLeader(inst)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
					end
					Sleep(.33)
				end
			end)
			
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
			
			inst.SoundEmitter:PlaySound("dontstarve/zg/wendy/die")
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
    State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
			inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            
			inst.components.locomotor:Stop()
			
			local therandom2 = math.random()
			if therandom2 < .33 then
				inst.AnimState:PlayAnimation("atk")
			elseif therandom2 < .66 then
				inst.AnimState:PlayAnimation("pickaxe_loop")
			else
				inst.AnimState:PlayAnimation("chop_loop")
			end
			
        end,
		
        timeline=
        {	
            TimeEvent(8*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
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

    
return StateGraph("zg_ch_wendy", states, events, "idle", actionhandlers)

