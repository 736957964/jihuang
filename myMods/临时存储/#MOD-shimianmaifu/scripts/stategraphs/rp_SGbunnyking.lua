require("stategraphs/commonstates")

--local HYPONSIS_COOLDOWN = 10
--local LIGHTING_COOLDOWN = 8

local function GetSpawnPoint(target, min_dist, max_dist)
	local pt = Vector3(target.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
	--设置默认参数
	if min_dist == nil or max_dist == nil then
		min_dist = 15
		max_dist = 35
	end
    local radius = math.random(min_dist, max_dist)
	local result_offset = FindValidPositionByFan(theta, radius, 20, function(offset)
    local pos = pt + offset
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1)
		return next(ents) == nil
    end)
	if result_offset ~= nil then
        local pos = pt + result_offset
		return pos
	end
end
	
local function TrySpawn(target, prefab_name, min_dist, max_dist, max_trying_times)
	--设置默认参数
	if max_trying_times == nil then
		max_trying_times = 50
	end
	
	if max_trying_times < 0 then
		return nil
	end
	
	local b = nil
	if target then
		local player_pt = Vector3(target.Transform:GetWorldPosition())
		local pt = GetSpawnPoint(target, min_dist, max_dist)
		if pt ~= nil then
			local tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			local canspawn = tile ~= GROUND.IMPASSABLE and tile ~= GROUND.INVALID and tile ~= 255
			if canspawn then
				--print("spawned!")
				b = SpawnPrefab(prefab_name)
				if b then 
					b.Transform:SetPosition(pt:Get())
					if player_pt then 
						b:FacePoint(player_pt)
					end 
				end
				return b
			else
				b = TrySpawn(target, prefab_name, min_dist, max_dist, max_trying_times - 1)
			end
		end
	end
	return b
end

--兔兔催眠
local function Hypnosised(inst)
	
	local fx = SpawnPrefab("dr_warm_loop_1")
	local x,y,z = inst.Transform:GetWorldPosition()
	
	fx.Transform:SetPosition(x, y+5, z)
	local currentscale = fx.Transform:GetScale()
	fx.Transform:SetScale(currentscale*4,currentscale*4,currentscale*4)
	
	local ents = TheSim:FindEntities(x, y, z, BUNNYMAN_HYPONSIS_RANGE, nil, { "playerghost", "rp_monster", "shadowboss", "wave_monster"}, { "player", "character"})
    for i, v in ipairs(ents) do
        if v ~= inst and v:IsValid() and
            not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
            not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) then
            if v:HasTag("player") then
                v:PushEvent("yawn", { grogginess = 3, knockoutduration = 0 })
            end
        end
    end
end

--兔兔电击
local function LightingStroke(inst)

	local fx = SpawnPrefab("shock_fx")
	local x,y,z = inst.Transform:GetWorldPosition()
	
	fx.Transform:SetPosition(x, y+1, z)
	local currentscale = fx.Transform:GetScale()
	fx.Transform:SetScale(currentscale*5,currentscale*5,currentscale*5)
	
	--周围的玩家受到电击
	local ents = TheSim:FindEntities(x, y, z, BUNNYMAN_LIGHTING_RANGE, nil, { "playerghost", "electricdamageimmune", "rp_monster", "shadowboss"}, { "player", "character"})
	for i, v in ipairs(ents) do
		if v:HasTag("player") or v:HasTag("character") then
			if v.components.health ~= nil and not (v.components.health:IsDead() 
			--or v.components.health:IsInvincible()
			) 
			then
				if not v.components.inventory:IsInsulated() then
					local damage = nil
					if v.components.moisture then 
						local mult = TUNING.ELECTRIC_WET_DAMAGE_MULT * v.components.moisture:GetMoisturePercent()
						damage = TUNING.LIGHTNING_DAMAGE + mult * TUNING.LIGHTNING_DAMAGE + 40
					else
						damage = TUNING.LIGHTNING_DAMAGE + 40
					end
					
					v.components.health:DoDelta(-damage, false, "lightning")
					v.sg:GoToState("electrocute")
				else
					v:PushEvent("lightningdamageavoided")
				end
			end
		end
	end
	
	for i = 1, 4 do
		TrySpawn(inst, "lightning", 2, 8, 10)
	end
	
end

--重写攻击状态(添加技能)
local function onattackfn(inst)
	if inst.components.health ~= nil 
	and not inst.components.health:IsDead() 
	and (not inst.sg:HasStateTag("busy")) then
		if not inst.candodge then
			inst.candodge = true
		else
			inst.candodge = false
		end
		
		if not (inst.canhypnosis or inst.components.timer:TimerExists("Hypnosis")) then
			inst.components.timer:StartTimer("Hypnosis", BUNNYMAN_HYPONSIS_COOLDOWN)
		end
		
		if not (inst.canhypnosis or inst.components.timer:TimerExists("Lighting")) then
			inst.components.timer:StartTimer("Lighting", BUNNYMAN_LIGHTING_COOLDOWN)
		end
		
		if inst.canhypnosis and not inst.beardlord then
			inst.sg:GoToState("hypnosis")
		elseif inst.canlighting and inst.beardlord then 
			inst.sg:GoToState("lighting")
		else
			inst.sg:GoToState("attack")
		end
	end
end

--重写被攻击状态（无硬直）
local function onattackedfn(inst)
	if inst.components.health ~= nil and
        not inst.components.health:IsDead() and
       (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
	   return ;
	end
end

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.PICKUP, "pickup"),
    ActionHandler(ACTIONS.EQUIP, "pickup"),
    ActionHandler(ACTIONS.ADDFUEL, "pickup"),
}


local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttack(),
    --CommonHandlers.OnAttacked(true),
    CommonHandlers.OnDeath(),
	EventHandler("attacked", onattackedfn),
	EventHandler("doattack", onattackfn),
    
}

local function beardit(inst, anim)
    return inst.beardlord and "beard_"..anim or anim
end

local states=
{
    State{
        name= "funnyidle",
        tags = {"busy"},
        
        onenter = function(inst)
			inst.Physics:Stop()
            
            if inst.beardlord then
                inst.AnimState:PlayAnimation("beard_taunt")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_taunt")
			elseif inst.components.health:GetPercent() < TUNING.BUNNYMAN_PANIC_THRESH then
				inst.AnimState:PlayAnimation("idle_angry")
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/angry_idle")
            elseif inst.components.follower.leader and inst.components.follower:GetLoyaltyPercent() < 0.05 then
                inst.AnimState:PlayAnimation("hungry")
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry")
            elseif inst.components.combat.target then
                inst.AnimState:PlayAnimation("idle_angry")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/angry_idle")
            elseif inst.components.follower.leader and inst.components.follower:GetLoyaltyPercent() > 0.3 then
                inst.AnimState:PlayAnimation("idle_happy")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/happy")
            else
                inst.AnimState:PlayAnimation("idle_creepy")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/idle_med")
            end
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
            --inst.components.highlight:SetAddColour(Vector3(82/255, 115/255, 124/255))
        end,
    },

    
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst, data)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/death")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
			inst.causeofdeath = data and data.afflicter or nil
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
    
    State{
		name = "abandon",
		tags = {"busy"},
		
		onenter = function(inst, leader)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("abandon")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/angry_idle")
            inst:FacePoint(Vector3(leader.Transform:GetWorldPosition()))
		end,
		
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
			if inst.beardlord then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_attack")
            else
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/attack")       
            end

            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation(beardit(inst,"atk"))
        end,
        
        timeline=
        {
			TimeEvent(13*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/bite")        
				inst.components.combat:DoAttack() 
				inst.sg:RemoveStateTag("attack") 
				inst.sg:RemoveStateTag("busy") 
			end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("eat")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/eat")            
        end,
        
        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
    State{
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/hurt")
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    }, 
	
	State{
		name = "hypnosis",
		tags = {"attack", "busy"},

		onenter = function(inst)
			if inst.components.locomotor then 
				inst.components.locomotor:StopMoving()
			end
			
			--inst.AnimState:PlayAnimation("hungry")
			inst.AnimState:PlayAnimation("idle_angry")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/angry_idle")
			inst.canhypnosis = false
		end,
		
		timeline=
        {
			TimeEvent(25*FRAMES, function(inst) inst.AnimState:PlayAnimation("hungry") end),
            TimeEvent(40*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/happy") end),
			TimeEvent(50*FRAMES, function(inst) Hypnosised(inst) end),
        },

		events=
        {
            EventHandler("animover", function(inst) 
			if not inst.components.timer:TimerExists("Hypnosis") then
				inst.components.timer:StartTimer("Hypnosis", BUNNYMAN_HYPONSIS_COOLDOWN)
			end
			inst.sg:GoToState("idle") 
			end ),
        },
	},
	
	State{
		name = "lighting",
		tags = {"attack","busy"},
		
		onenter = function(inst, leader)
			
			if inst.components.locomotor then 
				inst.components.locomotor:StopMoving()
			end
			
			inst.AnimState:PlayAnimation("idle_angry")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/angry_idle")
			inst.canlighting = false
            --inst:FacePoint(Vector3(leader.Transform:GetWorldPosition()))
		end,
		
		timeline=
        {
			TimeEvent(25*FRAMES, function(inst) inst.AnimState:PlayAnimation("beard_taunt") end),
			TimeEvent(50*FRAMES, function(inst) LightingStroke(inst) end),
        },
		
        events =
        {
            EventHandler("animqueueover", function(inst) 
			if not inst.components.timer:TimerExists("Lighting") then
				inst.components.timer:StartTimer("Lighting", BUNNYMAN_LIGHTING_COOLDOWN)
			end
			inst.sg:GoToState("idle") end ),
        },        
    },
	
	State{
		name = "taunt",
		tags = {"busy"},
		
		onenter = function(inst, leader)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("abandon")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/angry_idle")
            --inst:FacePoint(Vector3(leader.Transform:GetWorldPosition()))
		end,
		
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/hop")
        end),
		TimeEvent(4*FRAMES, function(inst)
            inst.components.locomotor:WalkForward()
        end),
		TimeEvent(12*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, function(inst)
            inst.Physics:Stop()
        end),
	},
},
{
    startwalk = function(inst) return beardit(inst,"walk_pre") end,
    walk = function(inst) return beardit(inst,"walk_loop") end,
    stopwalk = function(inst) return beardit(inst,"walk_pst") end,
},
function(inst) return not inst.beardlord end
)

CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/hop")
        end),
		TimeEvent(4*FRAMES, function(inst)
            inst.components.locomotor:RunForward()
        end),
		TimeEvent(8*FRAMES, PlayFootstep ),
		TimeEvent(8*FRAMES, function(inst)
            inst.Physics:Stop()
        end),
	},
},
{
    startrun = function(inst) return beardit(inst,"run_pre") end,
    run = function(inst) return beardit(inst,"run_loop") end,
    stoprun = function(inst) return beardit(inst,"run_pst") end,
},
function(inst) return not inst.beardlord end
)

CommonStates.AddSleepStates(states,
{
	sleeptimeline = 
	{
		TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/sleep") end ),
	},
})

CommonStates.AddIdle(states,"funnyidle", function(inst) return beardit(inst,"idle_loop") end, 
{
    TimeEvent(0*FRAMES, function(inst) if inst.beardlord then inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_breathin") end end ),
    TimeEvent(15*FRAMES, function(inst) if inst.beardlord then inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/wererabbit_idle") end end ),
})

CommonStates.AddSimpleState(states,"refuse", "pig_reject", {"busy"})
CommonStates.AddFrozenStates(states)

CommonStates.AddSimpleActionState(states,"pickup", "pig_pickup", 10*FRAMES, {"busy"})

CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4*FRAMES, {"busy"})

    
return StateGraph("pig", states, events, "idle", actionhandlers)

