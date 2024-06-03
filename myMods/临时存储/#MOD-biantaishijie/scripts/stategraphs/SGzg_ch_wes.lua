require("stategraphs/commonstates")
---local zg_puppet_brain = require("brains/zg_puppet_brain")


local function DoFoleySounds(inst)

	---for k,v in pairs(inst.components.inventory.equipslots) do
		---if v.components.inventoryitem and v.components.inventoryitem.foleysound then
			---inst.SoundEmitter:PlaySound(v.components.inventoryitem.foleysound)
		---end
	---end

end

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		inst.SoundEmitter:PlaySound("dontstarve/zg/wes/hit")
		--不被中断
		
		--[[
		----	倾倒玩家的物品
		if math.random() < .125 then
			inst.components.talker:Say("(DISARMOR)")
			local x, y, z = inst.Transform:GetWorldPosition()
			inst.SoundEmitter:PlaySound("dontstarve/zg/wolfgang/flash")
			
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
			
			----	卸掉玩家的护甲
			local ents2 = TheSim:FindEntities(x, y, z, 20, {"player"})
			for k,v in pairs(ents2) do
				if v.components.inventory and not v:HasTag("playerghost") then
					local item = v.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
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
			
			----	卸掉玩家的帽子
			local ents3 = TheSim:FindEntities(x, y, z, 20, {"player"})
			for k,v in pairs(ents3) do
				if v.components.inventory and not v:HasTag("playerghost") then
					local item = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
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
			end]]
			
			--[[
			----	倾倒玩家的物品特效
			SpawnPrefab("book_fx").Transform:SetPosition(x,y,z)
			
			----			倾倒玩家的物品
			local ents4 = TheSim:FindEntities(x, y, z, 20, {"player"})
			for k,v in pairs(ents4) do
				if v.components.inventory and not v:HasTag("playerghost") then
					----	让玩家的 所有物品 震落
					if v.components.inventory then
						v.components.inventory:DropEverything(true)
					end
					
				end
			end
		
		end]]
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
			
			--inst.AnimState:PlayAnimation("powerup")
			
			inst.AnimState:PlayAnimation("mime8")
			inst.AnimState:PushAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("flute", false)
			
			
			if inst._fx ~= nil then
				inst._fx:kill_fx()
			end
			inst._fx = SpawnPrefab("forcefieldfx")
			if inst._fx then
				inst._fx.entity:SetParent(inst.entity)
				inst._fx.Transform:SetPosition(0, 0.2, 0)
			end
			
			--inst["zg_inh_anti_physics"] = 1
			
		end,
		
		--ontimeout = function(inst)
		--	inst.sg:GoToState("idle")
		--end,

		events=
		{
			--EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end)
		},

		timeline=
		{
			
			----自行车样式动作结束
			TimeEvent(55*FRAMES, function(inst)
				inst.AnimState:OverrideSymbol("pan_flute01", "pan_flute", "pan_flute01")
				inst.AnimState:Hide("ARM_carry") 
				inst.AnimState:Show("ARM_normal")
			end),
			
			TimeEvent(83*FRAMES, function(inst)
				----催眠声音
				inst.SoundEmitter:PlaySound("dontstarve/wilson/flute_LP", "flute")
				
				local pt = inst:GetPosition()
				
				local fx = SpawnPrefab("groundpoundring_fx")
				if fx then
					fx.Transform:SetPosition( pt:Get() )
					fx.Transform:SetScale( 1, 1, 1 )
				end
			end),
			
			
			TimeEvent(84*FRAMES, function(inst)
				local pt = inst:GetPosition()
				
				local fx = SpawnPrefab("groundpoundring_fx")
				if fx then
					fx.Transform:SetPosition( pt:Get() )
					fx.Transform:SetScale( .75, .75, .75 )
				end
			end),
			
			TimeEvent(85*FRAMES, function(inst)
			
				local pt = inst:GetPosition()
				
				----范围迷乱
				local r = 12
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss", "epic"})
				for k,v in pairs(ents) do
					if v and v.components.health and not v.components.health:IsDead() and v.components.combat then	
						if v:HasTag("player") then
							
							----	震玩家的武器和帽子
							local inv = v.components.inventory
							if inv then
								--for kk, vv in pairs( inv.equipslots ) do
									local item = inv:GetEquippedItem(EQUIPSLOTS.HANDS)
									--local item = vv
									if item and item.Physics then
										inv:DropItem(item)
										local a, b, c = item:GetPosition():Get()
										item.Physics:Teleport(a,.1,c)
										local hp = v:GetPosition()
										local pt = inst:GetPosition()
										local vel = (pt - hp):GetNormalized()
										local speed = 5 + (math.random() * 2)
										local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
										item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
									end	
								--end
							end
							if inv then
								--for kk, vv in pairs( inv.equipslots ) do
									local item = inv:GetEquippedItem(EQUIPSLOTS.HEAD)
									--local item = vv
									if item and item.Physics then
										inv:DropItem(item)
										local a, b, c = item:GetPosition():Get()
										item.Physics:Teleport(a,.1,c)
										local hp = v:GetPosition()
										local pt = inst:GetPosition()
										local vel = (pt - hp):GetNormalized()
										local speed = 5 + (math.random() * 2)
										local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
										item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
									end	
								--end
							end
							
							----6米内才催眠
							local dist = v:GetPosition():Dist(pt)
							if dist < 6 then
							
								----卸掉所有装备
								local inv = v.components.inventory
								if inv then
									for kk, vv in pairs( inv.equipslots ) do
										--local item = inv:GetEquippedItem(vv)
										local item = vv
										if item and item.Physics then
											inv:DropItem(item)
											local a, b, c = item:GetPosition():Get()
											item.Physics:Teleport(a,.1,c)
											local hp = v:GetPosition()
											local pt = inst:GetPosition()
											local vel = (pt - hp):GetNormalized()
											local speed = 5 + (math.random() * 2)
											local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
											item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
										end	
									end
								end
							
								----玩家被催眠
								if v.components.talker then
									v.components.talker:Say("好舒服啊!")
								end
								
								v:DoTaskInTime( .1, function()
									if v and v.components.grogginess then
										v.components.grogginess:AddGrogginess(10, 5)
									end
								end)
								
							end
						
							----玩家失控
							--[[
							if v.components.playercontroller then
								v.components.playercontroller:Enable(false)
							end
							v:SetBrain(zg_puppet_brain)
							local tar = FindEntity( v, 12, function(guy)
								return guy and guy ~= v and
									guy.components.health and not guy.components.health:IsDead() and guy.components.combat and
									not guy:HasTag("shadowboss") and not guy:HasTag("shadow") and
									(
										guy:HasTag("player") or guy:HasTag("character")
									)
							end)
							if tar then
								v.components.combat:SetTarget(tar)
							end
							
							----复原
							v:DoTaskInTime(5, function()
								if v and v.components.health and not v.components.health:IsDead() and v.components.combat and v.components.playercontroller then
									v.components.playercontroller:Enable(true)
								end
								v:SetBrain(nil)
							end)]]
					
						else
							local tar = FindEntity( v, 12, function(guy)
								return guy and guy ~= v and
									guy.components.health and not guy.components.health:IsDead() and guy.components.combat and
									not guy:HasTag("shadowboss") and not guy:HasTag("shadow") and
									(
										guy:HasTag("player")
									)
							end)
							if tar then
								if v.components.talker then
									v.components.talker:Say("乖乖听小丑的话!")
								end
								v.components.combat:SetTarget(tar)
							end
						end
					end
				end
				
			end),
			
			----消声
			TimeEvent(140*FRAMES, function(inst)
				inst.SoundEmitter:KillSound("flute")
			end),
			
		},
		
		onexit = function(inst)
		
			inst.SoundEmitter:KillSound("flute")
            --if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry") 
                inst.AnimState:Hide("ARM_normal")
            --end
			
			if inst._fx then
				inst._fx:kill_fx()
				inst._fx:Remove()
				inst._fx = nil
			end

			--
			--inst["zg_inh_anti_physics"] = inst.mem_anti_physics or .5
			
			inst.canpound = false
			if not inst.components.timer:TimerExists("pound") then
				inst.components.timer:StartTimer("pound", 5)
			end
		end,
		
	},
	
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
			---inst.SoundEmitter:PlaySound("dontstarve/zg/wes/die")
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  
			SpawnPrefab("gravestone").Transform:SetPosition(inst.Transform:GetWorldPosition())
			
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
			
			inst.AnimState:PlayAnimation("atk")
        end,
        
        timeline=
        {	
			TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
            TimeEvent(8*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target) 
				inst.sg:RemoveStateTag("abouttoattack") 
				
				----产生气球
				if inst.sg.statemem.target then
					local x, y, z = inst.sg.statemem.target.Transform:GetWorldPosition()
					
					--for k = 1, 2 do
						local offset = 2 + math.random()
						local drerandom = math.random()
						if drerandom < .25 then
							SpawnPrefab("balloon").Transform:SetPosition(x+offset, y, z+offset)
						elseif drerandom < .5 then
							SpawnPrefab("balloon").Transform:SetPosition(x-offset, y, z+offset)
						elseif drerandom < .75 then
							SpawnPrefab("balloon").Transform:SetPosition(x+offset, y, z-offset)
						else 
							SpawnPrefab("balloon").Transform:SetPosition(x-offset, y, z-offset)
						end	
					--end
					
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
            --if math.random() < .25 then
				--SpawnPrefab("zg_it_balloon").Transform:SetPosition(inst.Transform:GetWorldPosition())
			--end
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

    
return StateGraph("zg_ch_wes", states, events, "idle", actionhandlers)

