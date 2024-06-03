require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}

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




   
local events=
{
	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
	end),

    EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() then
			local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip then
				inst.sg:GoToState("attack_arm")
				if inst.components.talker then
					inst.components.talker:Say("女神女神!")
				end
			else
				
				if not (inst.canzhanfu or inst.components.timer:TimerExists("zhanfu")) then
					inst.components.timer:StartTimer("zhanfu", 12.5)
				end
				if not (inst.canpound or inst.components.timer:TimerExists("pound")) then
					inst.components.timer:StartTimer("pound", 7.5)
				end
				
				if inst.canzhanfu then
					inst.sg:GoToState("pound")
					if inst.components.talker then
						inst.components.talker:Say("【爆裂天魔】")
					end
				elseif inst.canpound then
					inst.sg:GoToState("pound")
					if inst.components.talker then
						inst.components.talker:Say("【天魔散花】")
					end
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

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()			
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))  
			
			
			--下一个标志
			local pos = Zg_GetTPPos()
			if pos then
				SpawnPrefab("diviningrod").Transform:SetPosition( pos:Get() )
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
	----橡胶
	State{
        name = "attack_arm",
        tags = {"attack", "notalking", "abouttoattack", "busy", "skill"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("punch")  
			
			inst.AnimState:Hide("ARM_normal")
        end,
        
        timeline=
        {	
			TimeEvent(4*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack")
            end),
            TimeEvent(10*FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
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
		
		onexit = function(inst)
			if inst.components.inventory then
                inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
				inst.AnimState:Show("ARM_normal")
            end
		end
    },    
	
	----机关枪
	State{
        name = "pound",
        tags = {"busy", "skill"},
		
		onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.Physics:Stop()
			
			inst.AnimState:PlayAnimation("powerup")
			inst.AnimState:PushAnimation("punch")
			inst.AnimState:PushAnimation("powerdown", false)
        end,
		
		timeline = 
		{
			--跳起结束
			TimeEvent(36*FRAMES, function(inst)
				
			end),
			
			--发动机关枪
			TimeEvent(45*FRAMES, function(inst)
				
				----位置
				local x, y, z = inst:GetPosition():Get()
				
				----面向目标
				if inst.components.combat and inst.components.combat.target then
					inst.Transform:SetRotation( inst:GetAngleToPoint( inst.components.combat.target:GetPosition():Get() ) )
				end
				
				----定义机关枪
				for k = 1, 40 do
				
					inst:DoTaskInTime(math.random() * .75, function(inst)
						local fx = SpawnPrefab("fire_projectile")
						if fx then
							fx.Transform:SetPosition(x, y, z)
							fx.Transform:SetRotation( inst.Transform:GetRotation() - 45 + math.random() * 90 )
							fx.Physics:SetMotorVelOverride( 12.5, 0, 0)							
							fx:DoTaskInTime(5, fx.Remove)
							local period = .1
	fx.collide_task_table = {}
	fx:DoPeriodicTask(period, function()
	
		local pt = fx:GetPosition()	
		local r = 2
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
		
		for k,v in pairs(ents) do
			if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
				
				if not table.contains(fx.collide_task_table, v.GUID) then
					v.components.combat:Zg_GetAttacked(fx, 10, nil, "zg_ele_dark")
					table.insert(fx.collide_task_table, v.GUID)
				end
				
			end
		end
		
	end)	
							
							
							
							
							
						end
					end)
					
				end
				for k = 1, 40 do
				
					inst:DoTaskInTime(.75+math.random() * .75, function(inst)
						local fx = SpawnPrefab("ice_projectile")
						if fx then
							fx.Transform:SetPosition(x, y, z)
							fx.Transform:SetRotation( inst.Transform:GetRotation() - 45 + math.random() * 90 )
							fx.Physics:SetMotorVelOverride( 12.5, 0, 0)
							fx:DoTaskInTime(5, fx.Remove)
														local period = .1
	fx.collide_task_table = {}
	fx:DoPeriodicTask(period, function()
	
		local pt = fx:GetPosition()	
		local r = 2
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss"})
		
		for k,v in pairs(ents) do
			if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
				
				if not table.contains(fx.collide_task_table, v.GUID) then
					v.components.combat:Zg_GetAttacked(fx, 10, nil, "zg_ele_dark")
					table.insert(fx.collide_task_table, v.GUID)
				end
				
			end
		end
		
	end)
							
						end
					end)
					
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

    ----战斧
	State{
        name = "attack_zf",
        tags = {"busy", "skill"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
			
			--inst.AnimState:PlayAnimation("powerup")
            inst.AnimState:PlayAnimation("zg_zhanfu_pre") 
			inst.AnimState:PushAnimation("zg_zhanfu", false) 
			inst.sg:SetTimeout(60*FRAMES)
			
        end,
        
        timeline=
        {	
            TimeEvent( (55) *FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
				
				----AOE伤害
				local x, y, z = inst.Transform:GetWorldPosition()
				
				SpawnPrefab("collapse_small").Transform:SetPosition(x,y,z)
				
				local fx1 = SpawnPrefab("groundpound_fx")
				fx1.Transform:SetPosition(x, 0, z)
				fx1.Transform:SetScale(2,2,2)
				
				local ents = TheSim:FindEntities(x, y, z, 5, nil, { "INLIMBO", "shadowboss" })
				for i, v in ipairs(ents) do
					if v:IsValid() then
						if v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
							v.components.combat:Zg_GetAttacked(inst, 200)
						end
					end
				end
                
            end),   
			
			TimeEvent( (56)*FRAMES, function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				
				local fx1 = SpawnPrefab("groundpound_fx")
				fx1.Transform:SetPosition(x+3, 0, z+3)
				fx1.Transform:SetScale(2,2,2)
				
				local fx2 = SpawnPrefab("groundpound_fx")
				fx2.Transform:SetPosition(x-3, 0, z+3)
				fx2.Transform:SetScale(2,2,2)
				
				local fx3 = SpawnPrefab("groundpound_fx")
				fx3.Transform:SetPosition(x+3, 0, z-3)
				fx3.Transform:SetScale(2,2,2)
				
				local fx4 = SpawnPrefab("groundpound_fx")
				fx4.Transform:SetPosition(x-3, 0, z-3)
				fx4.Transform:SetScale(2,2,2)
				
				local ents = TheSim:FindEntities(x, y, z, 5, nil, { "INLIMBO", "shadowboss" })
				for i, v in ipairs(ents) do
					if v:IsValid() then
						if v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
							v.components.combat:Zg_GetAttacked(inst, 400)
						end
					end
				end
			end),
			
			TimeEvent( (57)*FRAMES, function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				
				local fx1 = SpawnPrefab("groundpound_fx")
				fx1.Transform:SetPosition(x+6, 0, z+6)
				fx1.Transform:SetScale(2,2,2)
				
				local fx2 = SpawnPrefab("groundpound_fx")
				fx2.Transform:SetPosition(x-6, 0, z+6)
				fx2.Transform:SetScale(2,2,2)
				
				local fx3 = SpawnPrefab("groundpound_fx")
				fx3.Transform:SetPosition(x+6, 0, z-6)
				fx3.Transform:SetScale(2,2,2)
				
				local fx4 = SpawnPrefab("groundpound_fx")
				fx4.Transform:SetPosition(x-6, 0, z-6)
				fx4.Transform:SetScale(2,2,2)
				
				local ents = TheSim:FindEntities(x, y, z, 7, nil, { "INLIMBO", "shadowboss" })
				for i, v in ipairs(ents) do
					if v:IsValid() then
						if v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
							v.components.combat:Zg_GetAttacked(inst, 400)
						end
					end
				end
				
				inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("attack")
				
				
				inst.canzhanfu = false
				if not inst.components.timer:TimerExists("zhanfu") then
					inst.components.timer:StartTimer("zhanfu", 12.5)
				end
				
			end),
        },
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
        
    },  
	
	----攻击
	State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("punch") 

			inst.sg:SetTimeout(22*FRAMES)
        end,
        
        timeline=
        {	
			TimeEvent(4*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack")
            end),
            TimeEvent(10*FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("attack")
            end),   
        },
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
        
		--[[
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end ),
        },]]
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

    
return StateGraph("zg_ch2_luffy", states, events, "idle", actionhandlers)

