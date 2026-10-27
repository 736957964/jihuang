require("stategraphs/commonstates")

local function Zg_GetTPPos()
	local ground = TheWorld
	local centers = {}
	for i, node in ipairs(ground.topology.nodes) do
		if ground.Map:IsPassableAtPoint(node.x, 0, node.y) then
			table.insert(centers, {x = node.x, z = node.y})
		end
	end
	if #centers > 0 then
		local pos = centers[math.random(#centers)]
		return Point(pos.x, 0, pos.z)
	else
		return nil
	end
end

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}  
local events=
{
	CommonHandlers.OnLocomote(true, false),
	EventHandler("zg_ch3_mihawk_moonstep", function(inst, data)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("skill") then
			local target=data.target or inst.components.combat.target
			if target then
				inst.sg:GoToState("moonstep",target)
			end
		end
	end),
    EventHandler("attacked", function(inst, data)
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
				----横扫千军
				inst.sg:GoToState("pound2")
			elseif inst.canpound then
				----世界第一斩击
				inst.sg:GoToState("pound")
			else
				if math.random()<.5 and inst.components.health:GetPercent() < .5 then
					--inst.sg:GoToState("z_s_ass")
					inst.sg:GoToState("yingbo")
				else
					inst.sg:GoToState("attack")
				end
			end
			
        end
    end),
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end),
}

local states= 
{

	----鹰波
	State{
        name = "yingbo",
        tags = {"attack", "notalking", "abouttoattack", "busy", "skill"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk")  
			if inst.components.talker then
				inst.components.talker:Say("【鹰王翎霄】")
			end
			----inst.SoundEmitter:PlaySound("zg_ch3_mihawk/zg_ch3_mihawk/jq")
        end,
        
        timeline=
        {	
            TimeEvent(6*FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
				--向前发射鹰波
				----wy_spawn(inst,"poop",nil,nil,nil,{tw_getforwardpos_offset(inst,1),0,{10,0,0}})   ----这里没东西
				local x, y, z = inst:GetPosition():Get()
				local fx = SpawnPrefab("poop")     ----东西呢
				if fx then
					--fx.Transform:SetPosition(x, y, z)
					----烦恼风推进
					--fx.Transform:SetRotation( inst.Transform:GetRotation())
					--fx.Physics:SetMotorVelOverride(10, 0, 0)
				end
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

	--鹰王铳
	State{
		name="z_s_ass",
		tags = {"attack","jumping","canrotate"},	--jumping不能少,如果没有该标签会被behavior结点里被stop
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.sg.statemem.target = inst.components.combat.target
			inst.components.combat:StartAttack()
			inst.AnimState:PlayAnimation("spearjab")
			inst.sg:SetTimeout(15*FRAMES)
			
			if inst.sg.statemem.target then
				inst:ForceFacePoint( inst.sg.statemem.target.Transform:GetWorldPosition() )
			end
			
			inst.collide_task_table = {}
			if inst.sg.statemem.asstask==nil then
				inst.sg.statemem.asstask=inst:DoPeriodicTask(1*FRAMES,function()
					
					local pt = inst:GetPosition()	
					local r = 5
					local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss","playerghost"})
					
					for k,v in pairs(ents) do
						if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
							
							if not table.contains(inst.collide_task_table, v.GUID) then
								v.components.combat:Zg_GetAttacked(inst, 120, nil, "zg_ele_bone")
								table.insert(inst.collide_task_table, v.GUID)
							end
							
						end
					end
					
				end)
			end
			
		end,
		
		onexit=function(inst)
			if inst.sg.statemem.asstask~=nil then
				inst.sg.statemem.asstask:Cancel()
				inst.sg.statemem.asstask=nil
				inst.collide_task_table = nil
			end
		end,
		
		timeline =
		{		
			TimeEvent(2*FRAMES, function(inst) --突击
				--突击音效
				---inst.SoundEmitter:PlaySound("zg_melee/skill/assult")
				inst.Physics:SetMotorVel(40,0,0)
				wy_spawn(inst,"maxwell_smoke")
			end),
			
			TimeEvent(5*FRAMES, function(inst) 
				wy_spawn(inst,"maxwell_smoke")
			end),
			
			TimeEvent(8*FRAMES, function(inst) 
				wy_spawn(inst,"maxwell_smoke")
			end),
			
			TimeEvent(11*FRAMES, function(inst) 	--实施打击
				inst.components.combat:DoAttack(inst.sg.statemem.target) 
			end),  
			TimeEvent(12*FRAMES, function(inst) 
				inst.Physics:Stop()	--停止
				inst.components.locomotor:Stop()
			end),			
		},
		
		ontimeout=function(inst)
			inst.sg:GoToState("idle")
		end,
	},

	--月步
	State{
        name = "moonstep",
        tags = {"busy", "skill", "jumping"},
		
		onenter = function(inst,target)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("jumpout")
			inst.sg:SetTimeout(FRAMES*20)
			if inst.components.talker then
				inst.components.talker:Say("【月步】")
			end
			inst.sg.statemem.target=target
			--面朝目标
			inst:ForceFacePoint( target.Transform:GetWorldPosition() )
			
			inst.moonstep_dist = inst:GetPosition():Dist(target:GetPosition())
        end,
		
		ontimeout=function(inst)
			local fx=wy_spawn(inst,"q5moonstep")
			fx.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
			local x,y,z=inst:GetPosition():Get()
			inst.Transform:SetPosition(x,0,z)
			inst.sg:GoToState("attack")
		end,
		
		timeline = 
		{
			TimeEvent(1 * FRAMES, function(inst)
				--inst.components.locomotor:Clear()
				local vel=(inst.moonstep_dist or 10)*30/17.5*7
				inst.Physics:SetMotorVel(vel, 20*10, 0)
				local fx=wy_spawn(inst,"q5moonstep")
				fx.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
			end),
			TimeEvent(10 * FRAMES, function(inst)
				local vel=(inst.moonstep_dist or 10)*30/17.5*7
				inst.Physics:SetMotorVel(vel, -20*10, 0) 
				wy_spawn(inst,"q5moonstep",{0,-1,0})
			end),
		},
		onexit = function(inst)
			
		end
	},

	----横扫六合
	State{
        name = "pound2",
        tags = {"busy", "skill"},
		
		onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("powerup")
			inst.AnimState:PushAnimation("chop_loop", false)
			----inst.SoundEmitter:PlaySound("zg_ch3_mihawk/zg_ch3_mihawk/call")
			if inst.components.talker then
				inst.components.talker:Say("横扫六合")
			end
        end,
		
		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},
		
		timeline = 
		{
			
			--剑气
			TimeEvent(43*FRAMES, function(inst)
				----inst.SoundEmitter:PlaySound("zg_ch3_mihawk/zg_ch3_mihawk/jq")
				--local pos = tw_getforwardpos(inst, 1)
				--local s=2
				--local speed=5
				--local yspeed=1
				--for k=0,2 do
					--wy_spawn(inst,"zg_fx_mihawkhsqj",nil,nil,s,{pos,0,{speed,yspeed*k,0}})
					--wy_spawn(inst,"zg_fx_mihawkhsqj",nil,nil,s,{pos,-10,{speed,yspeed*k,0}})
				--	wy_spawn(inst,"zg_fx_mihawkhsqj",nil,nil,s,{pos,10,{speed,yspeed*k,0}})
				--	wy_spawn(inst,"zg_fx_mihawkhsqj",nil,nil,s,{pos,-20,{speed,yspeed*k,0}})
				--	wy_spawn(inst,"zg_fx_mihawkhsqj",nil,nil,s,{pos,20,{speed,yspeed*k,0}})
				--	wy_spawn(inst,"zg_fx_mihawkhsqj",nil,nil,s,{pos,-30,{speed,yspeed*k,0}})
				--	wy_spawn(inst,"zg_fx_mihawkhsqj",nil,nil,s,{pos,30,{speed,yspeed*k,0}})
				--end
			end),
		},
		onexit = function(inst)
			--技能结束
			inst.canpound2 = false
			if not inst.components.timer:TimerExists("pound2") then
				inst.components.timer:StartTimer("pound2", 12.5)
			end
		end
		
	},

	----世界第一斩击
	State{
        name = "pound",
        tags = {"busy", "skill"},
		
		onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("powerup")		--36f
			inst.AnimState:PushAnimation("pickaxe_loop", false)		--36+7=43f
			--inst.SoundEmitter:PlaySound("zg_ch3_mihawk/zg_ch3_mihawk/call")
			if inst.components.talker then
				inst.components.talker:Say("让你脑袋开花~~~")
			end
        end,
		
		timeline = 
		{
			TimeEvent(42*FRAMES, function(inst)
				if inst.components.combat and inst.components.combat.target then
					inst:ForceFacePoint( inst.components.combat.target.Transform:GetWorldPosition() )
				end
			end),
			--剑气
			TimeEvent(43*FRAMES, function(inst)
				---inst.SoundEmitter:PlaySound("zg_ch3_mihawk/zg_ch3_mihawk/jq")
				---local pos = tw_getforwardpos(inst, 1)
				---wy_spawn(inst,"zg_fx_mihawkzj",nil,nil,1,{pos,0,{20,0,0}})
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
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
			---local altar=wy_spawn(inst,"ancient_altar")
			---wy_spawn(altar,"collapse_small")
			
			--下一个标志
			local pos = Zg_GetTPPos()
			if pos then
				---SpawnPrefab("zg_fx_mihawksymbol").Transform:SetPosition( pos:Get() )
			end
			
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
            end),
            TimeEvent(15*FRAMES, function(inst)
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
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

    
return StateGraph("zg_ch3_mihawk", states, events, "idle", actionhandlers)

