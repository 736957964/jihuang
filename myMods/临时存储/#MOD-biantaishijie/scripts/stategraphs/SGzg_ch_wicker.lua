require("stategraphs/commonstates")

local function DoFoleySounds(inst)

	--for k,v in pairs(inst.components.inventory.equipslots) do
		--if v.components.inventoryitem and v.components.inventoryitem.foleysound then
			--inst.SoundEmitter:PlaySound(v.components.inventoryitem.foleysound)
		--end
	--end

end

local function SpawnIceFx(inst, postarget)
    if not inst or not postarget then return end
    local numFX = 6
    local pos = inst:GetPosition()
    local targetPos = postarget
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())

    for i = 1, numFX do
        inst:DoTaskInTime(math.random() * 0.25, function(inst)
            local prefab = "icespike_fx_"..math.random(1,4)
            local fx = SpawnPrefab(prefab)
            if fx then
                local x = GetRandomWithVariance(0, .5)
                local z = GetRandomWithVariance(0, .5)
                local offset = (vec * math.random(dist * 0.75, dist * 1.25)) + Vector3(x,0,z)
                fx.Transform:SetPosition((offset+pos):Get())
				fx.Transform:SetScale(3,4,3)   ----大小
				
				----冰柱伤害
				local pt = fx:GetPosition()
				local r = 1.33
				local center_dmg = 30
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
				for k,v in pairs(ents) do
					if v and v.components.health and not v.components.health:IsDead() and v ~= inst and v.prefab ~= inst.prefab then
						
						--local dst = pt:Dist(v:GetPosition())
						--local dmg_mult = 1 - dst/r
						local dmg_mult = 1
						
						if v.components.combat and not v:HasTag("zg_marine") then
							v.components.combat:Zg_GetAttacked(inst, center_dmg * dmg_mult, nil, "zg_ele_ice")
						end
					end
				end				
				
            end
        end)
    end
end
-----------------------------------------------------------------------
local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		inst.SoundEmitter:PlaySound("dontstarve/zg/wicker/hit")
		--不被中断
		if inst.sg:HasStateTag("zg_summon") then
			inst.sg:GoToState("idle")
		end
	end),

    EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() then
			if not (inst.canpound or inst.components.timer:TimerExists("pound")) then
				inst.components.timer:StartTimer("pound", 7.5)
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
			inst.AnimState:PushAnimation("emote_hands")
			inst.AnimState:PushAnimation("powerdown", false)
			
		end,

		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline=
		{
		
			----跳起落地
			TimeEvent(36*FRAMES, function(inst)
				
			end),
			
			----手部动作结束
			TimeEvent(97*FRAMES, function(inst)
				
				local pt = inst:GetPosition()
				
				--生成冰旋风
				local fx = SpawnPrefab("mossling_spin_fx")     ----黄色旋风
				if fx then
					fx.Transform:SetPosition( pt:Get() )
					--冰旋风推进
					if inst.components.combat and inst.components.combat.target then
						fx.Transform:SetRotation( inst:GetAngleToPoint( inst.components.combat.target:GetPosition():Get() ) )
					else
						fx.Transform:SetRotation( inst.Transform:GetRotation() )
					end
					---fx.Physics:SetMotorVelOverride(7.5, 0, 0)
				end
				
				
			end),
			
		},
		
		onexit = function(inst)
			--
			inst.canpound = false
			if not inst.components.timer:TimerExists("pound") then
				inst.components.timer:StartTimer("pound", 7.5)
			end
		end,
		
	},

	State{
		name = "summon_perd",
        tags = {"busy", "zg_summon"},
		onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.components.talker:Say("Summon!")
			
            local pt = Vector3(inst.Transform:GetWorldPosition())
			inst:StartThread(function()
				for k = 1, inst:NumPerdsToSpawn() do			----在此仅仅召唤一个, 这只是固定格式
					local theta = math.random() * 2 * PI
					local radius = math.random(3, 8)
					local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
						local pos = pt + offset
						local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
						return next(ents) == nil
					end)
					if result_offset ~= nil then
						local pos = pt + result_offset
						--local perd = SpawnPrefab("zg_mo_icearcher")
						--perd.Transform:SetPosition(pos:Get())
						--perd.components.follower:SetLeader(inst)
						--SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
					end
					Sleep(.33)
				end
			end)
			
			inst.SoundEmitter:PlaySound("dontstarve/zg/spell/summon01")
			inst.AnimState:PlayAnimation("emoteXL_kiss")
			--inst.AnimState:PlayAnimation("emote_hands")
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
			--inst.SoundEmitter:PlaySound("dontstarve/zg/wicker/die")
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
			--inst.AnimState:PlayAnimation("spearjab")
			inst.AnimState:PlayAnimation("emote_hands")
			
			--if inst.components.combat.target then
			--	inst._target_pos = inst.components.combat.target:GetPosition()
			--end
			
        end,
        
        timeline=
        {	
			TimeEvent(9*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/zg/wicker/ice") 
				if inst.components.combat.target then
					inst._target_pos = inst.components.combat.target:GetPosition()
				end
			end),
            TimeEvent(29*FRAMES, function(inst) 
			
				SpawnIceFx(inst, inst._target_pos)
				inst.sg:RemoveStateTag("abouttoattack") 
				
				----一定几率缴械
				if math.random() < .25 then
					local x,y,z = inst.Transform:GetWorldPosition()
					
					inst.SoundEmitter:PlaySound("dontstarve/zg/wolfgang/flash")
					inst.components.talker:Say("(DISARM)")
					SpawnPrefab("book_fx").Transform:SetPosition(x,y,z)
					
					----	卸掉玩家的手中的武器
					local ents = TheSim:FindEntities(x, y, z, 20, {"player"})
					for k,v in pairs(ents) do
						if v.components.inventory and not v:HasTag("playerghost") then
							local item = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
							if item and item.Physics then
								v.components.inventory:DropItem(item)
								local a, b, c = item:GetPosition():Get()
								item.Physics:Teleport(a,.1,c)
								local hp = v:GetPosition()
								local pt = inst:GetPosition()
								local vel = (hp - pt):GetNormalized()
								local speed = 5 + (math.random() * 2)
								local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
								item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
							end	
						end
					end
				
					----    紧接着收走范围内亮在外面 的武器
					inst:DoTaskInTime( 1, function()
						if inst.components.health and not inst.components.health:IsDead() then
							local ents2 = TheSim:FindEntities(x, y, z, 30)
							for k,v in pairs(ents2) do
								----	筛选出 不处于 拥有状态 的 武器
								if v.components.weapon and v.components.inventoryitem and not v.components.inventoryitem:IsHeld() then
									local x1,y1,z1 = v.Transform:GetWorldPosition()
									SpawnPrefab("book_fx").Transform:SetPosition(x1,y1,z1)
									---inst.components.inventory:GiveItem(v)
								end
							end
						end
					end)
				end
			end), 
			
			TimeEvent(36*FRAMES, function(inst) 
				
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

    
return StateGraph("zg_ch_wicker", states, events, "idle", actionhandlers)

