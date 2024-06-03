require("stategraphs/commonstates")


local function Do_sanji_xft(inst)
	local x, y, z = inst.Transform:GetWorldPosition()	
	local ents = TheSim:FindEntities(x, y, z, 4, nil, { "INLIMBO", "shadowboss" })
	for i, v in ipairs(ents) do
		if v:IsValid() then
			if v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
				v.components.combat:Zg_GetAttacked(inst, 120)
			end
		end
	end
end

-------------------------------------------------------------------------------------
local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

--------------------------------------------------------------------------------------
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
	end),
	
	EventHandler("zg_ch1_sanji_moonstep", function(inst, data)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("skill") then
			local target=data.target or inst.components.combat.target
			if target then
				inst.sg:GoToState("moonstep",target)
			end
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
			local fx=wy_spawn(inst,"wathgrithr_spirit")
			---fx.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
			local x,y,z=inst:GetPosition():Get()
			inst.Transform:SetPosition(x,0,z)
			inst.sg:GoToState("attack")
		end,
		
		timeline = 
		{
			TimeEvent(1 * FRAMES, function(inst)
				local vel=(inst.moonstep_dist or 10)*30/17.5*7
				inst.Physics:SetMotorVel(vel, 20*10, 0)
				local fx=wy_spawn(inst,"wathgrithr_spirit")
				---fx.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
			end),
			TimeEvent(10 * FRAMES, function(inst)
				local vel=(inst.moonstep_dist or 10)*30/17.5*7
				inst.Physics:SetMotorVel(vel, -20*10, 0) 
				wy_spawn(inst,"wathgrithr_spirit",{0,-1,0})
			end),
		},
		onexit = function(inst)
			
		end
	},

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
			---inst.SoundEmitter:PlaySound("dontstarve/zg/ch_sanji/die")
			--inst.SoundEmitter:PlaySound("zg_ch1_zoro/zg_ch1_zoro/die")
			
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
    
	
	----旋风踢
	State{
        name = "pound",
        tags = {"attack", "notalking", "abouttoattack", "busy","skill"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
			inst.components.locomotor:RunForward()
            --inst.components.locomotor:Stop()
            --inst.AnimState:PlayAnimation("zg_xuanfengtui_pre")
			--inst.AnimState:PushAnimation("zg_xuanfengtui")
			
			inst.AnimState:PlayAnimation("powerdown")
			inst.AnimState:PushAnimation("quick_eat")
			--inst.sg:SetTimeout(80*FRAMES)
        end,
        
        timeline=
        {	
			TimeEvent(36*FRAMES, function(inst)
				local fx = SpawnPrefab("wathgrithr_spirit")   -----旋风
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetPosition(0,0,0)
				fx.Transform:SetScale(2.5,1,2.5)
			end),
		
			TimeEvent(38*FRAMES, function(inst)
				inst.sg:RemoveStateTag("abouttoattack")
				Do_sanji_xft(inst)
			end),
		
			TimeEvent(44*FRAMES, function(inst)
				Do_sanji_xft(inst)
			end),
			
			TimeEvent(52*FRAMES, function(inst)
				Do_sanji_xft(inst)
			end),
			
			TimeEvent(60*FRAMES, function(inst)
				Do_sanji_xft(inst)
			end),
			
			TimeEvent(68*FRAMES, function(inst)
				Do_sanji_xft(inst)
			end),
		
            TimeEvent(74*FRAMES, function(inst)
                Do_sanji_xft(inst)
                inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("attack")
				
				--技能结束
				inst.canpound = false
				if not inst.components.timer:TimerExists("pound") then
					inst.components.timer:StartTimer("pound", 5)
				end
				
            end),   
        },
        
		--ontimeout = function(inst)
		--	inst.sg:GoToState("idle")
		--end,
		
        events=
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end ),
        },
    },    
	
	----腿攻
	State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
			if math.random() < .75 then
				inst.components.locomotor:Stop()
				inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack")
			else
				--恶魔风脚
				if inst.components.talker then
					inst.components.talker:Say("【恶魔风脚】")
				end
				inst.SoundEmitter:PlaySound("wiliya_monster/butterfly/atk_rh")
				inst.firetick=true
			end
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
			--inst.components.locomotor:RunForward()
            --inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("jumpout")  
        end,
		
		onexit = function(inst)
			inst.firetick=false
			--退出状态时还原速度
			--inst.components.locomotor.runspeed = 6
		end,
        
        timeline=
        {	
			--TimeEvent(0*FRAMES, function(inst)
                --inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack")
				--inst.zg_sound = 0
				
				--临时改变速度
				--inst.components.locomotor.runspeed = 8
				
			--end),
		
            TimeEvent(10*FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.components.combat:DoAttack(inst.sg.statemem.target,nil,nil,nil,inst.firetick and 3 or 1)
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
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
                --DoFoleySounds(inst)
            end),
            TimeEvent(15*FRAMES, function(inst)
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
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

    
return StateGraph("zg_ch1_sanji", states, events, "idle", actionhandlers)

