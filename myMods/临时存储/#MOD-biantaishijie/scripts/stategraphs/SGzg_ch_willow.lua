require("stategraphs/commonstates")

local function DoFoleySounds(inst)

	---for k,v in pairs(inst.components.inventory.equipslots) do
		---if v.components.inventoryitem and v.components.inventoryitem.foleysound then
		---	inst.SoundEmitter:PlaySound(v.components.inventoryitem.foleysound)
		---end
	---end

end

local function SpawnFireFx(inst, target)
    if not inst or not target then return end
    local numFX = math.random(9, 12)
    local pos = inst:GetPosition()
    local targetPos = target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())

    for i = 1, math.ceil(numFX * TUNING.ZG_DIFFICULTY) do
        inst:DoTaskInTime(0, function(inst)
            --local prefab = "icespike_fx_"..math.random(1,4)
			local prefab = "fx_willowfire"
            local fx = SpawnPrefab(prefab)
            if fx then
                local x = GetRandomWithVariance(0, 3)
                local z = GetRandomWithVariance(0, 3)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x,0,z)
                fx.Transform:SetPosition((offset+pos):Get())
				if fx.components.burnable then
					fx.components.burnable:SetBurnTime(9 * TUNING.ZG_DIFFICULTY)
				end
				fx._output = .75  * TUNING.ZG_DIFFICULTY
            end
        end)
    end
end

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		---inst.SoundEmitter:PlaySound("dontstarve/zg/willow/hit")
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
			inst.AnimState:PushAnimation("emoteXL_happycheer")
			inst.AnimState:PushAnimation("powerdown", false)
			
			local tauntfx = SpawnPrefab("tauntfire_fx")
			tauntfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			tauntfx.Transform:SetRotation(inst.Transform:GetRotation())
		end,

		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline=
		{
			TimeEvent(36*FRAMES, function(inst)
				local tauntfx = SpawnPrefab("tauntfire_fx")
				tauntfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				tauntfx.Transform:SetRotation(inst.Transform:GetRotation())
			end),
			TimeEvent(48*FRAMES, function(inst)
				inst.components.groundpounder:GroundPound(nil, "zg_ele_fire")
			end),
			TimeEvent(55*FRAMES, function(inst)
				inst.components.groundpounder:GroundPound(nil, "zg_ele_fire")
			end),
			TimeEvent(66*FRAMES, function(inst)
				inst.components.groundpounder:GroundPound(nil, "zg_ele_fire")
				
				--
				inst.canpound = false
				if not inst.components.timer:TimerExists("pound") then
					inst.components.timer:StartTimer("pound", 5)
				end
				
			end),
			TimeEvent(72*FRAMES, function(inst)
				local tauntfx = SpawnPrefab("tauntfire_fx")
				tauntfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				tauntfx.Transform:SetRotation(inst.Transform:GetRotation())
			end),
		},
	},

	State{
		name = "summon_perd",		--用的威尔逊的AI, 匹配名字而已,这里召唤的是 火元素
        tags = {"busy", "zg_summon"},
		onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.talker:Say("Fire girl!")
			
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
					--	local perd = SpawnPrefab("zg_mo_firegirl")
					--	perd.Transform:SetPosition(pos:Get())
						--perd.components.follower:SetLeader(inst)
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
			
			inst.SoundEmitter:PlaySound("dontstarve/zg/willow/die")
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  
			--SpawnPrefab("zg_ut_adventure").Transform:SetPosition(inst.Transform:GetWorldPosition())
			
			----生成厨房
			local x, y, z = inst.Transform:GetWorldPosition()
			
			--SpawnPrefab("cookpot").Transform:SetPosition(x+2, y, z+2)
		--	SpawnPrefab("cookpot").Transform:SetPosition(x-2, y, z+2)
			--SpawnPrefab("cookpot").Transform:SetPosition(x-2, y, z-2)
			--SpawnPrefab("cookpot").Transform:SetPosition(x+2, y, z-2)
			
			for aaa = x-6, x+6, 1 do
				--SpawnPrefab("wall_stone").Transform:SetPosition(aaa,y,z-6)
				--SpawnPrefab("wall_stone").Transform:SetPosition(aaa,y,z+6)
			end
			for bbb = z-6, z+6, 1 do
				--SpawnPrefab("wall_stone").Transform:SetPosition(x-6,y,bbb)
				--SpawnPrefab("wall_stone").Transform:SetPosition(x+6,y,bbb)
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
	
-----------------------------------------------------------------------遇到障碍物跳过去-------------------------------------------------------------- 
	State{
        name = "jump",
        tags = {"doing", "busy"},
        
        onenter = function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
	
			inst.AnimState:PlayAnimation("jumpout")
			inst.Physics:SetMotorVel(9.3, 0, 0)
		
			inst.sg.statemem.action = inst.bufferedaction

        end,
        
		onupdate = function(inst)         
            inst.components.locomotor:RunForward()			----	直接冲过去
        end,
		
		onexit = function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
			inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
			inst.Physics:CollidesWith(COLLISION.CHARACTERS)
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
					inst.Physics:ClearCollisionMask()
					inst.Physics:CollidesWith(COLLISION.GROUND)
					inst.Physics:CollidesWith(COLLISION.OBSTACLES)
					inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
					inst.Physics:CollidesWith(COLLISION.CHARACTERS)
					inst.Transform:SetPosition(x,0,z)
					inst.sg:GoToState("idle")
				end
			end),
        },
    },    
	
------------------------------------------------------------------------------------------------------------------------------------------------------
    State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
         
			inst.components.locomotor:Stop()
			
			--inst.SoundEmitter:PlaySound("dontstarve/zg/wilson/call")
			if math.random() < .05 then
				inst.SoundEmitter:PlaySound("dontstarve/zg/willow/call")
				inst.components.talker:Say("真该死!", 1)
			end
			
			inst.AnimState:PlayAnimation("atk")
        end,
        
        timeline=
        {	
			TimeEvent(4*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") 
				--if math.random() < .375 then
					--inst.SoundEmitter:PlaySound("dontstarve/zg/zg_mo_evergreen/explode")
					--SpawnFireFx(inst, inst.components.combat.target)
				--end
			end),
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
			local x, y, z = inst.Transform:GetWorldPosition()
			
			--[[
            ----走路就加热
			local ents = TheSim:FindEntities(x, y, z, 2.5)
			for k, v in pairs(ents) do
				if v and v:HasTag("player") and v.components.temperature then
					--v.components.temperature.current = v.components.temperature.current + 2.5
					v.components.temperature:DoDelta(2.5)
				end
			end
			
			local ents2 = TheSim:FindEntities(x, y, z, 5)
			for k, v in pairs(ents2) do
				if v and v:HasTag("player") and v.components.temperature then
					--v.components.temperature.current = v.components.temperature.current + 2.5
					v.components.temperature:DoDelta(2.5)
				end
			end]]
			
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

    
return StateGraph("zg_ch_willow", states, events, "idle", actionhandlers)

