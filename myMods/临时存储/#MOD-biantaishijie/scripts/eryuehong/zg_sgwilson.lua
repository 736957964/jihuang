----全局变量声明
local g = GLOBAL
local TimeEvent = GLOBAL.TimeEvent
local FRAMES = GLOBAL.FRAMES
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local EventHandler = GLOBAL.EventHandler
local SpawnPrefab = GLOBAL.SpawnPrefab
local State = GLOBAL.State
local DEGREES = GLOBAL.DEGREES
local Vector3 = GLOBAL.Vector3
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local FOODTYPE = GLOBAL.FOODTYPE

local TUNING = GLOBAL.TUNING
local PLAYERSTUNLOCK = GLOBAL.PLAYERSTUNLOCK
local GetTime = GLOBAL.GetTime
local HUMAN_MEAT_ENABLED = GLOBAL.HUMAN_MEAT_ENABLED


--------------------------------------------------------------------

AddPlayerPostInit(function(inst)

	if inst and GLOBAL.TheNet:GetIsServer() then
		
		----装备双手武器则卸掉另一只手的武器
		inst:ListenForEvent("equip", function()
			inst:DoTaskInTime(0, function()
				
				local inv = inst.components.inventory
				if inv then
				
					local item1 = inv:GetEquippedItem(EQUIPSLOTS.HANDS)
					if item1 and item1:HasTag("zg_doublehand") then
					
						local item2 = inv:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
						if item2 then
							
							----卸下盾牌
							if item2.components.inventoryitem.cangoincontainer then
								inv:GiveItem(item2)
							else
								inv:DropItem(item2, true, true)
							end
								
							----说话
							if inst.components.talker then
								inst.components.talker:Say( "双手武器不能和盾同时装备" )
							end
							
						end
						
					end
					
				end	
					
			end)
		end)
		
		--骑牛不能装盾牌
		inst:ListenForEvent("mounted", function(inst,data)
			inst:DoTaskInTime(0, function()
				local inv = inst.components.inventory
				if inv then
				
					local item2 = inv:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
					if item2 then
						
						----卸下盾牌
						if item2.components.inventoryitem.cangoincontainer then
							inv:GiveItem(item2)
						else
							inv:DropItem(item2, true, true)
						end
							
						----说话
						if inst.components.talker then
							inst.components.talker:Say( "驾驭坐骑时无法拿住盾牌" )
						end
						
					end
					
				end	
			end)
		end)
		
	end
	
end)

--------------------------------------------------------------------



--lightning-------------------------------------------------------------------------------------------
AddStategraphState("wilson", State{
	name = "zg_weapon_lightninggun",
	tags = { "attack", "notalking", "abouttoattack", --"autopredict"
	},
	onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("dart")
		--inst.sg.statemem.weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		
	end,
	
	timeline=
	{	
		TimeEvent(2*FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/zg/wx78/atk")
		end),
	
		TimeEvent(6*FRAMES, function(inst)
			--if inst.sg.statemem.target then
			--	inst.components.combat:DoAttack(inst.sg.statemem.target)
			--end
			inst:PerformBufferedAction()
			inst.sg:RemoveStateTag("abouttoattack")
			
		end),
	
		TimeEvent(7*FRAMES, function(inst)
			
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
})

--zhzh------------------------------------------------------------------------------------------------
AddStategraphState("wilson", State{
	name = "zg_shotgun",
	tags = { "attack", "notalking", "abouttoattack", --"autopredict" 
	},
	onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("dart")
		
		inst.sg.statemem.weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		
	end,
	
	timeline=
	{	
		TimeEvent(6*FRAMES, function(inst)
		
			----判断有无子弹
			if inst.sg.statemem.weapon then 
			
				local bulletnum = inst.sg.statemem.weapon.components.finiteuses.current or 0
				
				----有子弹
				if bulletnum > 0 then
					
					----发出枪声
					inst.SoundEmitter:PlaySound("dontstarve/zg/ch_sanji/atk")
					
					----在前方2处产生火花
					local pt = inst:GetPosition()
					local heading_angle = -(inst.Transform:GetRotation())
					local r = 2
					local dir = Vector3(math.cos(heading_angle*DEGREES) * r, 1.675, math.sin(heading_angle*DEGREES) * r)
					local fx = SpawnPrefab("zg_fx_gunfire")
					fx.Transform:SetPosition( (pt + dir):Get() )
					fx.Transform:SetScale(.25,.25,.25)
					
					----射出子弹, 在这里才是真正的攻击
					
					--子弹的初始位置
					local bullet = SpawnPrefab("zg_fx_bullet")
					bullet.zg_shooter = inst				----定义发射者
					local dir2 = Vector3(math.cos(heading_angle*DEGREES) * r, 0, math.sin(heading_angle*DEGREES) * r)
					bullet.Transform:SetPosition( (pt + dir2):Get() )
					
					--子弹的投射方向
					if inst.components.combat.target then
						local vel = (inst.components.combat.target:GetPosition() - bullet:GetPosition() ):GetNormalized()
						local speed = 100
						local angle = math.atan2(vel.z, vel.x) + (math.random() * 3 - 1.5) * DEGREES		--偏离正负1.5角度
						bullet.Physics:SetVel(math.cos(angle) * speed, 0, math.sin(angle) * speed)
						inst.components.combat:DoAttack(inst.components.combat.target)		--触发一次枪的弹药的顿号(即"耐久"的损耗),实际上攻击在子弹上
						
					end
					
					inst.sg:RemoveStateTag("abouttoattack")
					
				----无子弹
				else
					inst.sg.statemem.weapon.SoundEmitter:PlaySound("dontstarve/zg/shotgun/nobullet")
					inst.components.talker:Say("没有足够的子弹!")
				end
			end
			
		end),
	
		TimeEvent(7*FRAMES, function(inst)
			--inst.sg:RemoveStateTag("abouttoattack")
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
})

--m3--------------------------------------------------------------------------------------------------
AddStategraphState("wilson", State{
	name = "zg_minigun",
	tags = { "attack", "notalking", "abouttoattack", --"autopredict" 
	},
	onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("dart")
		
		inst.sg.statemem.weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		inst.sg:SetTimeout(2*FRAMES)
	end,
	
	timeline=
	{	
		TimeEvent(0*FRAMES, function(inst)
		
			----判断有无子弹
			if inst.sg.statemem.weapon then 
			
				local bulletnum = inst.sg.statemem.weapon.components.finiteuses.current or 0
				
				----有子弹
				if bulletnum > 0 then
					
					----发出枪声
					--inst.SoundEmitter:PlaySound("dontstarve/zg/minigun/atk")
					inst.SoundEmitter:PlaySound("zg_we_mini/zg_we_mini/atk1")
					
					----在前方2处产生火花
					local pt = inst:GetPosition()
					local heading_angle = -(inst.Transform:GetRotation())
					local r = 2
					local dir = Vector3(math.cos(heading_angle*DEGREES) * r, 1.675, math.sin(heading_angle*DEGREES) * r)
					local fx = SpawnPrefab("zg_fx_gunfire")
					fx.Transform:SetPosition( (pt + dir):Get() )
					fx.Transform:SetScale(.25,.25,.25)
					
					----射出子弹, 在这里才是真正的攻击
					
					--子弹的初始位置
					local bullet = SpawnPrefab("zg_fx_bullet0")
					bullet.zg_shooter = inst				----定义发射者
					local dir2 = Vector3(math.cos(heading_angle*DEGREES) * r, 0, math.sin(heading_angle*DEGREES) * r)
					bullet.Transform:SetPosition( (pt + dir2):Get() )
					
					--子弹的投射方向
					if inst.components.combat.target then
						local vel = (inst.components.combat.target:GetPosition() - bullet:GetPosition() ):GetNormalized()
						local speed = 100
						local angle = math.atan2(vel.z, vel.x) + (math.random() * 10 - 5) * DEGREES		--偏离正负5角度
						bullet.Physics:SetVel(math.cos(angle) * speed, 0, math.sin(angle) * speed)
						--子弹扣1
						inst.components.combat:DoAttack(inst.components.combat.target)		--触发一次枪的弹药的顿号(即"耐久"的损耗),实际上攻击在子弹上
					end
					
					
					inst.sg:RemoveStateTag("abouttoattack")
					
				----无子弹
				else
					inst.sg.statemem.weapon.SoundEmitter:PlaySound("dontstarve/zg/shotgun/nobullet")
					inst.components.talker:Say("没有足够的子弹!")
				end
			end
			
		end),
	
		
		TimeEvent(1*FRAMES, function(inst)
			--inst.sg:RemoveStateTag("abouttoattack")
			inst.sg:RemoveStateTag("busy")
			inst.sg:RemoveStateTag("attack")
		end),
	},
	
	ontimeout = function(inst)
		inst.sg:GoToState("idle")
	end,
})

--ak47--------------------------------------------------------------------------------------------------
AddStategraphState("wilson", State{
	name = "zg_ak47",
	tags = { "attack", "notalking", "abouttoattack", --"autopredict"
	},
	onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("dart")
		
		inst.sg.statemem.weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		inst.sg:SetTimeout(4*FRAMES)
	end,
	
	timeline=
	{	
	
		TimeEvent(1*FRAMES, function(inst)
		
			----判断有无子弹
			if inst.sg.statemem.weapon then 
			
				local bulletnum = inst.sg.statemem.weapon.components.finiteuses.current or 0
				
				----有子弹
				if bulletnum > 0 then
				
					----发出枪声
					inst.SoundEmitter:PlaySound("dontstarve/zg/ak47/atk")
					
					----在前方2处产生火花
					local pt = inst:GetPosition()
					local heading_angle = -(inst.Transform:GetRotation())
					local r = 2
					local dir = Vector3(math.cos(heading_angle*DEGREES) * r, 1.675, math.sin(heading_angle*DEGREES) * r)
					local fx = SpawnPrefab("zg_fx_gunfire")
					fx.Transform:SetPosition( (pt + dir):Get() )
					fx.Transform:SetScale(.3,.3,.3)
					
					----射出子弹, 在这里才是真正的攻击
					
					--子弹的初始位置
					local bullet = SpawnPrefab("zg_fx_bullet_ak47")
					bullet.zg_shooter = inst				----定义发射者
					local dir2 = Vector3(math.cos(heading_angle*DEGREES) * r, 0, math.sin(heading_angle*DEGREES) * r)
					bullet.Transform:SetPosition( (pt + dir2):Get() )
					
					--子弹的投射方向
					if inst.components.combat.target then
						local vel = (inst.components.combat.target:GetPosition() - bullet:GetPosition() ):GetNormalized()
						local speed = 100
						local angle = math.atan2(vel.z, vel.x) + (math.random() * 6 - 3) * DEGREES		--偏离正负3角度
						bullet.Physics:SetVel(math.cos(angle) * speed, 0, math.sin(angle) * speed)
						--子弹扣1
						inst.components.combat:DoAttack(inst.components.combat.target)		--触发一次枪的弹药的顿号(即"耐久"的损耗),实际上攻击在子弹上
					end
					
					inst.sg:RemoveStateTag("abouttoattack")
					
				----无子弹
				else
					inst.sg.statemem.weapon.SoundEmitter:PlaySound("dontstarve/zg/shotgun/nobullet")
					inst.components.talker:Say("没有足够的子弹!")
				end
			end
			
		end),
	
		
		TimeEvent(3*FRAMES, function(inst)
			
			--inst.sg:RemoveStateTag("abouttoattack")
			inst.sg:RemoveStateTag("busy")
			inst.sg:RemoveStateTag("attack")
		end),
	},
	
	ontimeout = function(inst)
		inst.sg:GoToState("idle")
	end,
})

--m4----------------------------------------------------------------------------------------------------
AddStategraphState("wilson", State{
	name = "zg_m4",
	tags = { "attack", "notalking", "abouttoattack", --"autopredict"
	},
	onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("dart")
		inst.sg.statemem.weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		inst.sg:SetTimeout(3*FRAMES)
	end,
	
	timeline=
	{	
		TimeEvent(1*FRAMES, function(inst)
		
			----判断有无子弹
			if inst.sg.statemem.weapon then 
			
				local bulletnum = inst.sg.statemem.weapon.components.finiteuses.current or 0
				
				----有子弹
				if bulletnum > 0 then
				
					----发出枪声
					inst.SoundEmitter:PlaySound("dontstarve/zg/m4/atk")
					
					----在前方2处产生火花
					local pt = inst:GetPosition()
					local heading_angle = -(inst.Transform:GetRotation())
					local r = 2
					local dir = Vector3(math.cos(heading_angle*DEGREES) * r, 1.675, math.sin(heading_angle*DEGREES) * r)
					local fx = SpawnPrefab("zg_fx_gunfire")
					fx.Transform:SetPosition( (pt + dir):Get() )
					fx.Transform:SetScale(.3,.3,.3)
					
					----射出子弹, 在这里才是真正的攻击
					
					--子弹的初始位置
					local bullet = SpawnPrefab("zg_fx_bullet_ak47")
					bullet.zg_shooter = inst				----定义发射者
					local dir2 = Vector3(math.cos(heading_angle*DEGREES) * r, 0, math.sin(heading_angle*DEGREES) * r)
					bullet.Transform:SetPosition( (pt + dir2):Get() )
					
					--子弹的投射方向
					if inst.components.combat.target then
						local vel = (inst.components.combat.target:GetPosition() - bullet:GetPosition() ):GetNormalized()
						local speed = 100
						local angle = math.atan2(vel.z, vel.x) + (math.random() * 4 - 2) * DEGREES		--偏离正负2角度
						bullet.Physics:SetVel(math.cos(angle) * speed, 0, math.sin(angle) * speed)
						--子弹扣1
						inst.components.combat:DoAttack(inst.components.combat.target)		--触发一次枪的弹药的顿号(即"耐久"的损耗),实际上攻击在子弹上
					end
					
					inst.sg:RemoveStateTag("abouttoattack")
					
				----无子弹
				else
					inst.sg.statemem.weapon.SoundEmitter:PlaySound("dontstarve/zg/shotgun/nobullet")
					inst.components.talker:Say("没有足够的子弹!")
				end
			end
		end),
		
		TimeEvent(2*FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
			inst.sg:RemoveStateTag("attack")
		end),
	},
	
	ontimeout = function(inst)
		inst.sg:GoToState("idle")
	end,
})
------------------------------------------------------------------------------------------
----受伤
local function DoHurtSound(inst)
	----根据角色判断音效
	
	if inst.prefab == "wathgrithr" then
		inst.SoundEmitter:PlaySound("zg_player_wigfid/zg_player_wigfid/hit")
	elseif inst.prefab == "willow" then
		inst.SoundEmitter:PlaySound("zg_player_willow/zg_player_willow/hit")
	elseif inst.prefab == "wendy" then
		inst.SoundEmitter:PlaySound("zg_player_wendy/zg_player_wendy/hit")
	elseif inst.prefab == "wolfgang" then
		inst.SoundEmitter:PlaySound("zg_player_wolfgang/zg_player_wolfgang/hit")
	elseif inst.prefab == "wickerbottom" then
		inst.SoundEmitter:PlaySound("zg_player_wickerbottom/zg_player_wickerbottom/hit")
	elseif inst.prefab == "wilson" then
		inst.SoundEmitter:PlaySound("zg_player_wilson/zg_player_wilson/hit")
	elseif inst.prefab == "woodie" then
		if not (inst.isbeavermode and inst.isbeavermode:value()) then
			inst.SoundEmitter:PlaySound("zg_player_woodie/zg_player_woodie/hit")	
		else
			inst.SoundEmitter:PlaySound("zg_player_woodie/zg_player_woodie/hit_beaver")
		end
	
    elseif inst.hurtsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.hurtsoundoverride)
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/hurt")
    end
end

----死亡
local function ZG_DoDeathSound(inst)	
	----根据角色判断音效
	
	if inst.prefab == "wathgrithr" then
		inst.SoundEmitter:PlaySound("zg_player_wigfid/zg_player_wigfid/die")
	elseif inst.prefab == "willow" then
		inst.SoundEmitter:PlaySound("zg_player_willow/zg_player_willow/die")
	elseif inst.prefab == "wendy" then
		inst.SoundEmitter:PlaySound("zg_player_wendy/zg_player_wendy/die")
	elseif inst.prefab == "wolfgang" then
		inst.SoundEmitter:PlaySound("zg_player_wolfgang/zg_player_wolfgang/die")
	elseif inst.prefab == "wickerbottom" then
		inst.SoundEmitter:PlaySound("zg_player_wickerbottom/zg_player_wickerbottom/die")
	elseif inst.prefab == "wilson" then
		inst.SoundEmitter:PlaySound("zg_player_wilson/zg_player_wilson/die")
	elseif inst.prefab == "woodie" then
		if not (inst.isbeavermode and inst.isbeavermode:value()) then
			inst.SoundEmitter:PlaySound("zg_player_woodie/zg_player_woodie/die")	
		else
			inst.SoundEmitter:PlaySound("zg_player_woodie/zg_player_woodie/die_beaver")
		end
	elseif inst.prefab == "wx78" then
		inst.SoundEmitter:PlaySound("zg_ch_wx78/zg_ch_wx78/die")
		
	
	elseif not inst:HasTag("mime") then
		inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/death_voice")
	end
end

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end

local function DoMountSound(inst, mount, sound, ispredicted)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, ispredicted)
    end
end
------------------------------------------------------------------------------------------------------------
--弓箭攻击
AddStategraphState("wilson", State{
	name="zg_bow",
	tags = { "attack", "notalking", "abouttoattack", },
	onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("bow_attack")
	end,
	timeline =
	{		
		TimeEvent(4*FRAMES, function(inst) 
			--弓箭拉弦声音
			local weapon = inst.components.combat and inst.components.combat:GetWeapon()
			if weapon and weapon.SoundEmitter then
				weapon.SoundEmitter:PlaySound("zg_bow/zg_bow/atk")
			end
		end),
		TimeEvent(11*FRAMES, function(inst) 
			inst:PerformBufferedAction()
			inst.sg:RemoveStateTag("abouttoattack") 
		end),  
		TimeEvent(12*FRAMES, function(inst) 
			--消耗耐久在拉弦后 而不是 饥荒传统的击中算法
			local weapon = inst.components.combat and inst.components.combat:GetWeapon()
			if weapon and weapon.components.finiteuses then
				weapon.components.finiteuses:Use(1)
			end
			inst.sg:RemoveStateTag("attack")
		end),			
	},
	events =
	{
		EventHandler("animover", function(inst)
			inst.sg:GoToState("idle")
		end ),
	},
})

AddStategraphState("wilson", State{
	name="zg_gun_fire",
	tags = { "attack", "notalking", "abouttoattack",  },
	onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		--动作
		inst.AnimState:PlayAnimation("fishing_idle")
	end,
	timeline =
	{		
		TimeEvent(2*FRAMES, function(inst) 
			--枪的声音
			local weapon = inst.components.combat and inst.components.combat:GetWeapon()
			if weapon and weapon.SoundEmitter then
				--火枪
				if weapon:HasTag("zg_gun_fire") then
					weapon.SoundEmitter:PlaySound("zg_melee/gun/atk_fire")
				end
			end
		end),
		TimeEvent(3*FRAMES, function(inst) 
			inst:PerformBufferedAction()
			inst.sg:RemoveStateTag("abouttoattack") 
		end),  
		TimeEvent(4*FRAMES, function(inst) 
			--消耗耐久在开枪后 而不是 饥荒传统的击中算法
			local weapon = inst.components.combat and inst.components.combat:GetWeapon()
			if weapon and weapon.components.finiteuses then
				weapon.components.finiteuses:Use(1)
			end
			inst.sg:RemoveStateTag("attack")
		end),			
	},
	events =
	{
		EventHandler("animover", function(inst)
			inst.sg:GoToState("idle")
		end ),
	},
})

----状态图优化
AddStategraphPostInit("wilson", function(sg)

	--死亡
	local state_death = sg.states["death"]
	state_death.onenter = function(inst)
		ClearStatusAilments(inst)
		inst.components.locomotor:Stop()
		inst.components.locomotor:Clear()
		inst:ClearBufferedAction()
		if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
			--DoMountSound(inst, inst.components.rider:GetMount(), "yell")
			inst.AnimState:PlayAnimation("fall_off")
			inst.sg:AddStateTag("dismounting")
		else
			inst.SoundEmitter:PlaySound("dontstarve/wilson/death")
			--if not inst:HasTag("mime") then
			--	inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/death_voice")
			--end
			ZG_DoDeathSound(inst)
			if HUMAN_MEAT_ENABLED then
				inst.components.inventory:GiveItem(SpawnPrefab("humanmeat")) -- Drop some player meat!
			end
			inst.components.inventory:DropEverything(true)
			inst.AnimState:Hide("swap_arm_carry")
			inst.AnimState:PlayAnimation("death")
		end
		inst.components.burnable:Extinguish()
		if inst.components.playercontroller ~= nil then
			inst.components.playercontroller:RemotePausePrediction()
			inst.components.playercontroller:Enable(false)
		end
		inst.sg:ClearBufferedEvents()
	end
	state_death.onexit = function(inst)
	
	end

	--攻击---------------------------------------------------------------------------------------
	local action_attack_fn = sg.actionhandlers[ACTIONS.ATTACK].deststate
	sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
		inst.sg.mem.localchainattack = not action.forced or nil
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
			local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
			
			if weapon and weapon:HasTag("zg_bow") then
				return "zg_bow"
			elseif weapon and weapon:HasTag("zg_gun_fire") then
				return "zg_gun_fire"	
				
			elseif weapon and weapon:HasTag("zg_m4") then
				return "zg_m4"	
			elseif weapon and weapon:HasTag("zg_ak47") then
				return "zg_ak47"
			elseif weapon and weapon:HasTag("zg_minigun") then
				return "zg_minigun"	
			elseif weapon and weapon:HasTag("zg_shotgun") then
				return "zg_shotgun"	
			elseif weapon and weapon:HasTag("zg_weapon_lightninggun") then
				return "zg_weapon_lightninggun"		
			else
				return action_attack_fn(inst, action)
			end
		
		end
	end
	
	--攻击状态--------------------------------------------------------------------------------
	local state_attack = sg.states["attack"]
	state_attack.onenter = function(inst)
	
		--驾驭坐骑时无法拿住盾牌
		local isriding=inst.components.rider ~= nil and inst.components.rider:IsRiding()
		if isriding then
			local inv = inst.components.inventory
			if inv then
				local item2 = inv:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
				if item2 then
					----卸下盾牌
					if item2.components.inventoryitem.cangoincontainer then
						inv:GiveItem(item2)
					else
						inv:DropItem(item2, true, true)
					end	
					----说话
					if inst.components.talker then
						inst.components.talker:Say( "驾驭坐骑时无法拿住盾牌" )
					end
				end
			end	
		end
	
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		inst.components.combat:SetTarget(target)
		inst.components.combat:StartAttack()
		inst.components.locomotor:Stop()
		local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
		
		----检测盾牌
		local shield = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
		local hasshield = shield and shield:HasTag("zg_shield") or nil 
		
		----坐骑攻击
		if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
			inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk", false)
			--DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
			cooldown = math.max(cooldown, 16 * FRAMES)
			
		----鞭子
		--[[
		elseif equip ~= nil and equip:HasTag("whip") then
			inst.AnimState:PlayAnimation("whip_pre")
			inst.AnimState:PushAnimation("whip", false)
			inst.sg.statemem.iswhip = true
			inst.SoundEmitter:PlaySound("dontstarve/common/whip_pre", nil, nil, true)
			cooldown = math.max(cooldown, 17 * FRAMES)]]
		
		----双手武器
		elseif equip ~= nil and equip:HasTag("zg_doublehand") then
			
			----劈的动作
			inst.AnimState:PlayAnimation("pickaxe_loop")
			--inst.AnimState:PushAnimation("zg_atk", false)
			
			inst.SoundEmitter:PlaySound(
				(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
				(equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
				(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
				"dontstarve/wilson/attack_weapon",
				nil, nil, true
			)
			cooldown = math.max(cooldown, 13 * FRAMES)
			
		----单手武器
		elseif equip ~= nil and equip.components.weapon ~= nil and not equip:HasTag("punch") then
		
			if hasshield then
				inst.AnimState:PlayAnimation("zg_atk_pre")
				inst.AnimState:PushAnimation("zg_atk", false)
			else
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
			end
				
			inst.SoundEmitter:PlaySound(
				(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
				(equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
				(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
				"dontstarve/wilson/attack_weapon",
				nil, nil, true
			)
			cooldown = math.max(cooldown, 13 * FRAMES)
		elseif equip ~= nil and (equip:HasTag("light") or equip:HasTag("nopunch")) then
		
			if hasshield then
				inst.AnimState:PlayAnimation("zg_atk_pre")
				inst.AnimState:PushAnimation("zg_atk", false)
			else
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
			end
				
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
			cooldown = math.max(cooldown, 13 * FRAMES)
			
		----海狸攻击	
		elseif inst:HasTag("beaver") then
			inst.sg.statemem.isbeaver = true
			inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk", false)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
			cooldown = math.max(cooldown, 13 * FRAMES)
			
		----空手攻击
		else
		
			if hasshield then
				inst.AnimState:ClearOverrideSymbol("swap_object")
				inst.AnimState:PlayAnimation("zg_atk_pre")
				inst.AnimState:PushAnimation("zg_atk", false)
			else
				inst.AnimState:PlayAnimation("punch")
			end
				
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
			cooldown = math.max(cooldown, 24 * FRAMES)
		end

		inst.sg:SetTimeout(cooldown)

		if target ~= nil then
			inst.components.combat:BattleCry()
			if target:IsValid() then
				inst:FacePoint(target:GetPosition())
				inst.sg.statemem.attacktarget = target
			end
		end
	end
	
------------------------------------------------------------------------------------------------------------------------
	----跑步
	local state_run_start = sg.states["run_start"]
	state_run_start.onenter = function(inst)
	
		--驾驭坐骑时无法拿住盾牌
		local isriding=inst.components.rider ~= nil and inst.components.rider:IsRiding()
		if isriding then
			local inv = inst.components.inventory
			if inv then
				local item2 = inv:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
				if item2 then
					----卸下盾牌
					if item2.components.inventoryitem.cangoincontainer then
						inv:GiveItem(item2)
					else
						inv:DropItem(item2, true, true)
					end	
					----说话
					if inst.components.talker then
						inst.components.talker:Say( "驾驭坐骑时无法拿住盾牌" )
					end
				end
			end	
		end
	
		inst.components.locomotor:RunForward()
		
		----检测盾牌
		local shield = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
		local hasshield = shield and shield:HasTag("zg_shield") or nil 
		
		if hasshield then
		
			----检查手1
			local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if handitem then
				inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pre" or "zg_run_pre")
			else
				inst.AnimState:ClearOverrideSymbol("swap_object")
				inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pre" or "zgfy_run_pre")
			end
			
			
			
			--inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pre" or "zg_run_pre")
		else
			inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pre" or "run_pre")
		end
		
		inst.sg.mem.footsteps = 0
		inst.sg.statemem.riding = inst.components.rider ~= nil and inst.components.rider:IsRiding()
	end
	
	local state_run = sg.states["run"]
	state_run.onenter = function(inst) 
	
		--驾驭坐骑时无法拿住盾牌
		local isriding=inst.components.rider ~= nil and inst.components.rider:IsRiding()
		if isriding then
			local inv = inst.components.inventory
			if inv then
				local item2 = inv:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
				if item2 then
					----卸下盾牌
					if item2.components.inventoryitem.cangoincontainer then
						inv:GiveItem(item2)
					else
						inv:DropItem(item2, true, true)
					end	
					----说话
					if inst.components.talker then
						inst.components.talker:Say( "驾驭坐骑时无法拿住盾牌" )
					end
				end
			end	
		end
	
		inst.components.locomotor:RunForward()
		
		----如果被挤出海面, 则回到陆地
		if not inst:IsOnValidGround() then
			local x, y, z = inst.Transform:GetWorldPosition()
			local ground = g.TheWorld
			local centers = {}
			for i, node in ipairs(ground.topology.nodes) do
				if ground.Map:IsPassableAtPoint(node.x, 0, node.y) then
					table.insert(centers, {x = node.x, z = node.y, zg_dstsq = (x-node.x)*(x-node.x)+(y-node.y)*(y-node.y) })
				end
			end
			----寻找最近的拓补节点中心上岸
			if #centers > 0 then
				----按照距离从小到大排序
				table.sort(centers, function(a,b) return a.zg_dstsq < b.zg_dstsq end)
				inst.Transform:SetPosition(centers[1].x, 0, centers[1].z)
				----上岸后身体早已湿透
				if inst.components.moisture then
					inst.components.moisture:DoDelta(100)
					----感慨自己湿身了
					if inst.components.talker then
						inst.components.talker:Say("尼玛, 刚才掉海里了, 湿身了!!!")
					end
				end
				----浸水效果
				g.SpawnPrefab("splash_ocean").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:PushEvent("zg_buff_knockout")
			end
		end
		
		----检测盾牌
		local shield = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
		local hasshield = shield and shield:HasTag("zg_shield") or nil 
		local anim = inst:HasTag("groggy") and "idle_walk" or "run_loop"
		
		if hasshield then
		
			----检查手1
			local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if handitem then
				anim = inst:HasTag("groggy") and "idle_walk" or "zg_run_loop"
			else
				inst.AnimState:ClearOverrideSymbol("swap_object")
				anim = inst:HasTag("groggy") and "idle_walk" or "zgfy_run_loop"
			end
			
			
		
			--anim = inst:HasTag("groggy") and "idle_walk" or "zg_run_loop"
		else
			anim = inst:HasTag("groggy") and "idle_walk" or "run_loop"
		end
		
		if not inst.AnimState:IsCurrentAnimation(anim) then
			inst.AnimState:PlayAnimation(anim, true)
		end
		inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
		inst.sg.statemem.riding = inst.components.rider ~= nil and inst.components.rider:IsRiding()
	end
	
	local state_run_stop = sg.states["run_stop"]
	state_run_stop.onenter = function(inst) 
	
		--驾驭坐骑时无法拿住盾牌
		local isriding=inst.components.rider ~= nil and inst.components.rider:IsRiding()
		if isriding then
			local inv = inst.components.inventory
			if inv then
				local item2 = inv:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
				if item2 then
					----卸下盾牌
					if item2.components.inventoryitem.cangoincontainer then
						inv:GiveItem(item2)
					else
						inv:DropItem(item2, true, true)
					end	
					----说话
					if inst.components.talker then
						inst.components.talker:Say( "驾驭坐骑时无法拿住盾牌" )
					end
				end
			end	
		end
	
		inst.components.locomotor:Stop()
		
		local shield = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
		local hasshield = shield and shield:HasTag("zg_shield") or nil 
		
		if hasshield then
		
			----检查手1
			local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if handitem then
				inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pst" or "zg_run_pst")
			else
				inst.AnimState:ClearOverrideSymbol("swap_object")
				inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pst" or "zgfy_run_pst")
			end
		
			--inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pst" or "zg_run_pst")
		else
			inst.AnimState:PlayAnimation(inst:HasTag("groggy") and "idle_walk_pst" or "run_pst")
		end
		
	end
	
--------------------------------------------------------------------------------------------------------------------------------
	--静止
	local state_idle = sg.states["idle"]
	state_idle.onenter = function(inst, pushanim)
	
		--驾驭坐骑时无法拿住盾牌
		local isriding=inst.components.rider ~= nil and inst.components.rider:IsRiding()
		if isriding then
			local inv = inst.components.inventory
			if inv then
				local item2 = inv:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
				if item2 then
					----卸下盾牌
					if item2.components.inventoryitem.cangoincontainer then
						inv:GiveItem(item2)
					else
						inv:DropItem(item2, true, true)
					end	
					----说话
					if inst.components.talker then
						inst.components.talker:Say( "驾驭坐骑时无法拿住盾牌" )
					end
				end
			end	
		end
	
		inst.components.locomotor:Stop()
		inst.components.locomotor:Clear()

		if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
			inst.sg:GoToState("mounted_idle")
			return
		end

		local equippedArmor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		if equippedArmor ~= nil and equippedArmor:HasTag("band") then
			inst.sg:GoToState("enter_onemanband")
			return
		end

		local anims = {}

		if inst:HasTag("beaver") then
			if inst:HasTag("groggy") then
				table.insert(anims, "idle_groggy_pre")
				table.insert(anims, "idle_groggy")
			else
				table.insert(anims, "idle_loop")
			end
		else
		
			local shield = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
			local hasshield = shield and shield:HasTag("zg_shield") or nil 
			
			if hasshield then
			
				----检查手1
				local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if handitem then
					table.insert(anims, "zg_idle_loop")
				else
					table.insert(anims, "zgfy_idle_loop")
				end
				
			else
				table.insert(anims, "idle_loop")
			end
			
		end

		if pushanim then
			for k, v in pairs(anims) do
				inst.AnimState:PushAnimation(v, k == #anims)
			end
		else
			inst.AnimState:PlayAnimation(anims[1], #anims == 1)
			for k, v in pairs(anims) do
				if k > 1 then
					inst.AnimState:PushAnimation(v, k == #anims)
				end
			end
		end
		inst.sg:SetTimeout(2.2)
	end
	state_idle.ontimeout = function(inst)
		inst.sg:GoToState("idle")
	end
	
--------------------------------------------------------------------------------------------------------------------------------	
	
	--破甲
	local state_armorbroke = sg.states["armorbroke"]
	state_armorbroke.onenter = function(inst, armor)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_armour_break")
		inst.sg.statemem.armor = armor
		inst.sg:SetTimeout(5*FRAMES)
	end
	state_armorbroke.events =
	{
	
	}
	state_armorbroke.onexit = function(inst)
		local sameArmor = inst.components.inventory:FindItem(function(item)
			return item.prefab == inst.sg.statemem.armor.prefab
		end)
		if sameArmor then
			inst.components.inventory:Equip(sameArmor)
		end
	end
	state_armorbroke.ontimeout = function(inst)
		inst.sg:GoToState("idle")
	end
	
	--被攻击
	local event_attacked = sg.events["attacked"]
	event_attacked.fn = function(inst, data)
        if not inst.components.health:IsDead() then
            if data.weapon ~= nil and data.weapon:HasTag("tranquilizer") and (inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("knockout")) then
                return
            elseif inst.sg:HasStateTag("transform") or inst.sg:HasStateTag("dismounting") then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                DoHurtSound(inst)
            elseif inst.sg:HasStateTag("sleeping") then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                DoHurtSound(inst)
                if inst.sleepingbag ~= nil then
                    inst.sleepingbag.components.sleepingbag:DoWakeUp()
                    inst.sleepingbag = nil
                else
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                end
            elseif inst.sg:HasStateTag("shell") then
                inst.sg:GoToState("shell_hit")
            elseif inst:HasTag("pinned") then
                inst.sg:GoToState("pinned_hit")
            elseif data.stimuli == "darkness" then
                inst.sg:GoToState("hit_darkness")
            elseif data.stimuli == "electric" and not inst.components.inventory:IsInsulated() then
                inst.sg:GoToState("electrocute")
				
			----子弹伤害
			elseif data.stimuli == "zg_ele_bullet" or data.stimuli2 == "zg_ele_bullet" then
			
				----抗僵直
				local chance = .25
				if math.random() < chance then
					if not data.nostill then
						DoHurtSound(inst)
						--inst.sg:GoToState("hit")
					end
				end
				
			----电系伤害的电麻状态
			elseif data.stimuli == "zg_ele_electric" or data.stimuli2 == "zg_ele_electric" then
			
				----抗电麻
				local chance = .25 * ( data.weapon and data.weapon.zg_electrocute_mult or 1)
				if math.random() < chance then
					inst.sg:GoToState("electrocute")
				else
					if not data.nostill then
						DoHurtSound(inst)
						inst.sg:GoToState("hit")
					end
				end
				
			----暗系伤害
			elseif data.stimuli == "zg_ele_dark" or data.stimuli2 == "zg_ele_dark" then
			
				local dmg = data.damage
				
				----抗脑残
				if inst.components.sanity then
					inst.components.sanity:DoDelta(-dmg/5)
				end
				
			----火系伤害
			elseif data.stimuli == "zg_ele_fire" or data.stimuli2 == "zg_ele_fire" then
				
				local dmg = data.damage
				
				----抗燃
				local chance = .25
				if math.random() < chance then
					if inst.components.burnable and not inst.components.burnable:IsBurning()  then
						inst.components.burnable:Ignite()
					end
				end
				
				----抗热
				if inst.components.temperature then
					inst.components.temperature:DoDelta(dmg)
				end
				
				if not data.nostill then
					DoHurtSound(inst)
					inst.sg:GoToState("hit")
				end
				
			----冰系伤害
			elseif data.stimuli == "zg_ele_ice" or data.stimuli2 == "zg_ele_ice" then
				
				local dmg = data.damage
				
				----抗冻
				if inst.components.freezable then
					inst.components.freezable:AddColdness(dmg/25)
					inst.components.freezable:SpawnShatterFX()
				end
				
				----抗冷
				if inst.components.temperature then
					inst.components.temperature:DoDelta(-dmg)
				end
				
				if not data.nostill then
					DoHurtSound(inst)
					inst.sg:GoToState("hit")
				end
				
			
				
			----物理攻击
            else
                local stunlock = data.attacker ~= nil and data.attacker.components.combat and data.attacker.components.combat.playerstunlock
                local stunoffset = inst.laststuntime and GetTime() - inst.laststuntime or 999
                if stunlock ~= nil
                    and (stunlock == PLAYERSTUNLOCK.NEVER
                         or (stunlock == PLAYERSTUNLOCK.RARELY and stunoffset < TUNING.STUNLOCK_TIMES.RARELY)
                         or (stunlock == PLAYERSTUNLOCK.SOMETIMES and stunoffset < TUNING.STUNLOCK_TIMES.SOMETIMES)
                         or (stunlock == PLAYERSTUNLOCK.OFTEN and stunoffset < TUNING.STUNLOCK_TIMES.OFTEN))
                    and (not inst.sg:HasStateTag("idle") or inst.sg.timeinstate == 0) then 

                    inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                    DoHurtSound(inst)
                else
                    inst.laststuntime = GetTime()
                    DoHurtSound(inst)
					if not data.nostill then
						inst.sg:GoToState("hit")
					end
                end
            end
        end
    end
	
----被攻击状态------------------------------------------------------------------
	local state_hit = sg.states["hit"]
	state_hit.onenter = function(inst)
		inst.components.locomotor:Stop()
		inst:ClearBufferedAction()

		----检测盾牌
		local shield = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.ZGHAND2)
		local hasshield = shield and shield:HasTag("zg_shield") or nil 
		
		if hasshield then
			
			----检测手持
			local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if handitem == nil then
				inst.AnimState:ClearOverrideSymbol("swap_object")
			end
			inst.AnimState:PlayAnimation("zg_atk_pre")
			
			----格挡声音
			inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
			
			----僵直时间
			local destill = shield and shield["zg_shield_destill"] or 0
			if destill > 1 then
				destill = 1
			end
			
			local stun_frames = 6 * ( 1 - destill )
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:RemotePausePrediction(stun_frames)
			end
			inst.sg:SetTimeout(stun_frames * FRAMES)
		
		else
			inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
			local stun_frames = 6
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:RemotePausePrediction(stun_frames)
			end
			inst.sg:SetTimeout(stun_frames * FRAMES)
		end
		
	end
	
	----取消换装备的延迟
	local event_equip = sg.events["equip"]
	event_equip.fn = function(inst, data) end
	
	local event_unequip = sg.events["unequip"]
	event_unequip.fn = function(inst, data) end
	
end)





