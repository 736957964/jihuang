require("stategraphs/commonstates")

local function DoFoleySounds(inst)

	--for k,v in pairs(inst.components.inventory.equipslots) do
	--	if v.components.inventoryitem and v.components.inventoryitem.foleysound then
		--	inst.SoundEmitter:PlaySound(v.components.inventoryitem.foleysound)
	--	end
	--end

end

----子弹用完后装备近战武器
local function GetMeeleWeaopn(inst)
	if inst.components.inventory ~= nil then
		local meleeweapon = CreateEntity()
		meleeweapon.entity:AddTransform()
		meleeweapon.entity:AddSoundEmitter()
		meleeweapon:AddComponent("weapon")
		meleeweapon.components.weapon:SetDamage(30)
		meleeweapon:AddComponent("inventoryitem")
		meleeweapon.persists = false
		meleeweapon.components.inventoryitem:SetOnDroppedFn(inst.Remove)
		meleeweapon:AddComponent("equippable")
		meleeweapon.components.equippable:SetOnEquip(function()
			inst.AnimState:OverrideSymbol("swap_object", "swap_cutlass", "swap_cutlass")
			inst.AnimState:Show("ARM_carry") 
			inst.AnimState:Hide("ARM_normal")
		end)
		meleeweapon:AddTag("meleeweapon")
		meleeweapon.components.weapon:SetAttackCallback(function(inst, attacker, target)
			---meleeweapon.SoundEmitter:PlaySound("dontstarve/zg/ch_law/atk")
		end)
		inst.components.inventory:Equip(meleeweapon)
		inst.components.combat:SetAttackPeriod(1)
	end
end

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "quickeat"),
}
   
local events=
{

	--CommonHandlers.OnSleep(),
	EventHandler("gotosleep", function (inst)
		if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("sleep") then
			inst.sg:GoToState("sleep")
		end
	end),
	
    CommonHandlers.OnFreeze(),
	--CommonHandlers.OnAttacked(true),

	CommonHandlers.OnLocomote(true, false),

    EventHandler("attacked", function(inst, data)
		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
            if inst.sg:HasStateTag("sleeping") then
				inst.sg:GoToState("wakeup")
			else
				inst.sg:GoToState("hit")
			end
        end
	end),

    EventHandler("doattack", function(inst, data)
		if not inst.components.health:IsDead() then
			local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equip and equip.name == "ak" then
				inst.sg:GoToState("attack_ak", data.target)
			else
				inst.sg:GoToState("attack", data.target)
			end
        end
		
        --if not inst.components.health:IsDead() then
		--		inst.sg:GoToState("attack")
        --end
    end),
    
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end),
}

local states= 
{

	State{
        name = "sleep",
        tags = { "busy", "sleep"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            
            inst.AnimState:PlayAnimation("dozy")
            
            inst.sg:SetTimeout(TUNING.KNOCKOUT_SLEEP_TIME)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("wakeup")
        end,

        events =
        {
            EventHandler("firedamage", function(inst)
                if inst.sg:HasStateTag("sleeping") then
                    inst.sg:GoToState("wakeup")
                end
            end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.AnimState:PlayAnimation("sleep_loop", true)
					inst.sg:AddStateTag("sleeping")
                end
            end),
        },
    },

	State{
        name = "wakeup",
        tags = { "busy", },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("wakeup")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

----------------------------------------------------
	State{
        name = "hit",
        tags = { "busy", },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hit")
            local stun_frames = 6
            inst.sg:SetTimeout(stun_frames * FRAMES)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

	----伪装
	State{
        name = "hide",
        tags = { "noattack", "hiding", "notalking", "notarget", "nomorph", "busy", "nopredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hide")
            inst.AnimState:PushAnimation("hide_idle", false)
            inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
			
			--inst:RemoveTag("healthinfo")
			inst:RemoveTag("scarytoprey")
        end,

        timeline =
        {
            TimeEvent(24 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nopredict")
                inst.sg:AddStateTag("idle")
            end),
        },
		
		onexit = function(inst)
			--inst:AddTag("healthinfo")
			inst:AddTag("scarytoprey")
		end,
    },

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
			---inst.SoundEmitter:PlaySound("dontstarve/zg/ch0_soldier/die")
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
			if math.random() < .01 then
				---inst.SoundEmitter:PlaySound("dontstarve/zg/ch0_soldier/call")
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
            inst.sg:SetTimeout(1)
        end,
    },
	
------------------------------------------------------------------------------------------------------------------------------------------------------
	State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.components.combat:StartAttack()
			inst.components.locomotor:Stop()
			local animrandom = math.random()
			if animrandom < .33 then
				inst.AnimState:PlayAnimation("spearjab")
			elseif animrandom < .66 then
				inst.AnimState:PlayAnimation("atk")
			else
				inst.AnimState:PlayAnimation("pickaxe_loop")
			end
        end,
        
        timeline=
        {	
			--TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack") end),
            TimeEvent(10*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target) 
				inst.sg:RemoveStateTag("abouttoattack") 
			end),  
			TimeEvent(12*FRAMES, function(inst) 
				--if math.random() < .25 then
					--inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_attack")
					--inst.components.combat:DoAttack(inst.sg.statemem.target) 
				--end
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
        name = "attack_ak",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.components.combat:StartAttack()
			inst.components.locomotor:Stop()
			
			if math.random() < .01 then
				---inst.SoundEmitter:PlaySound("dontstarve/zg/ch0_soldier/atking")
			end
			
			inst.AnimState:PlayAnimation("dart")
			inst.sg:SetTimeout(5*FRAMES)
			
        end,
        
        timeline=
        {	
			TimeEvent(1*FRAMES, function(inst) 
				--inst.SoundEmitter:PlaySound("dontstarve/zg/ch0_soldier/atk") 
				--inst.SoundEmitter:PlaySound("dontstarve/zg/ak47/atk") 
				
				local pt = inst:GetPosition()
				local heading_angle = -(inst.Transform:GetRotation())
				local r = 2.25
				local dir = Vector3(math.cos(heading_angle*DEGREES) * r, 1.25, math.sin(heading_angle*DEGREES) * r)
				--local fx = SpawnPrefab("zg_fx_gunfire")
				--fx.Transform:SetPosition( (pt + dir):Get() )
				--fx.Transform:SetScale(.3,.3,.3)
			end),
			TimeEvent(2*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target) 
			end),
            TimeEvent(3*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target)		
			end),  
			TimeEvent(4*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				inst.sg:RemoveStateTag("abouttoattack") 
				inst.sg:RemoveStateTag("busy")
				inst.sg:RemoveStateTag("attack")
				
			end),
        },
        
        ontimeout = function(inst)
			if inst.prefab == "pigman" then
				inst.zg_bullet = inst.zg_bullet - 3
				--print(inst.zg_bullet)
				if inst.zg_bullet <= 0 then
					GetMeeleWeaopn(inst)
				end
			end
			if math.random() < .2 then
				inst.components.combat:SetTarget(nil)
			end
			inst.sg:GoToState("idle")
		end,
		
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
			--if math.random() < .005 then
			--	inst.SoundEmitter:PlaySound("dontstarve/zg/ch0_soldier/call")
			--end
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
	
	State {
		name = "frozen",
		tags = {"busy"},
		
        onenter = function(inst)
            inst.AnimState:PlayAnimation("frozen")
            inst.Physics:Stop()
        end,
    },
}
CommonStates.AddFrozenStates(states)
    
return StateGraph("zg_ch0_soldier", states, events, "idle")

