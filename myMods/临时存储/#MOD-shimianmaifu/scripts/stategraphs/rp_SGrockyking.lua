require("stategraphs/commonstates")

local function GetScalePercent(inst)
    return (inst.components.scaler.scale - TUNING.ROCKY_MIN_SCALE) / (TUNING.ROCKY_MAX_SCALE - TUNING.ROCKY_MIN_SCALE)
end

local function PlayLobSound(inst, sound)
    inst.SoundEmitter:PlaySoundWithParams(sound, {size=GetScalePercent(inst)})
end

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
	
local function TrySpawn(target, monster, min_dist, max_dist, max_trying_times)
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
				b = SpawnPrefab(monster)
				if b then 
					b.Transform:SetPosition(pt:Get())
					if player_pt then 
						b:FacePoint(player_pt)
					end 
				end
				return b
			else
				b = TrySpawn(target, monster, min_dist, max_dist, max_trying_times - 1)
			end
		end
	end
	return b
end

--虾虾拍地板
local function GroundPound(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local fx1 = SpawnPrefab("groundpoundring_fx")
	fx1.Transform:SetScale(.9,.9,.9)
	fx1.Transform:SetPosition(x,y,z)
	local fx2 = SpawnPrefab("ground_chunks_breaking") 
	local currentscale = fx2.Transform:GetScale()
	fx2.Transform:SetScale(currentscale*2,currentscale*2,currentscale*2)
	fx2.Transform:SetPosition(x,y,z)
	--local x1, y1, z1 = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 8, { "player" })
	for _,obj in pairs(ents) do
		if obj and obj:HasTag("player") and obj.components.health and not obj.components.health:IsDead() then 
		
			if obj.components.combat ~= nil then
				obj.components.combat:GetAttacked(inst, 50, nil)
			end
			
			local item = obj.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if not item then return end
			obj.components.inventory:DropItem(item)
			local x2, y2, z2 = item:GetPosition():Get()
			y = .1
			item.Physics:Teleport(x2,y2,z2)
			local hp = obj:GetPosition()
			local pt = inst:GetPosition()
			local vel = (hp - pt):GetNormalized()
			local speed = 5 + (math.random() * 2)
			local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
			item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
		end
	end
end

--虾虾流星雨
local function CallMeteor(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 15, { "player" })
	local should_max_attack_num = 2
	local attack_num = 1
	for _,obj in pairs(ents) do
		if obj and obj:HasTag("player") and obj.components.health then
			if attack_num <= should_max_attack_num then
			local x1,y1,z1 = obj.Transform:GetWorldPosition()		
			local meteor = SpawnPrefab("shadowmeteor")
			meteor.Transform:SetPosition(x1,y1,z1)
			attack_num = attack_num + 1
			end
		end
	end
	for i = 1, 3 do
		TrySpawn(inst, "shadowmeteor" , 5, 15, 20)
	end
end

local function onattackfn(inst)
	if inst.components.health ~= nil 
		and not inst.components.health:IsDead() 
		and(not inst.sg:HasStateTag("busy")) then
		
		--if not (inst.cangroundpound or inst.components.timer:TimerExists("Groundpound")) then
		--	inst.components.timer:StartTimer("Groundpound", ROCKY_GROUNDPOUND_COOLDOWN)
		--end
		
		if not (inst.cancallmeteor or inst.components.timer:TimerExists("Callmeteor")) then
			inst.components.timer:StartTimer("Callmeteor", ROCKY_CALLMETEOR_COOLDOWN)
		end
		
		--if inst.cangroundpound then
		--	inst.sg:GoToState("ground_pound")
		if inst.cancallmeteor then
			inst.sg:GoToState("call_meteor")
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
    ActionHandler(ACTIONS.TAKEITEM, "rocklick"),
    ActionHandler(ACTIONS.PICKUP, "rocklick"),
    ActionHandler(ACTIONS.EAT, "eat"),
}


local events =
{
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttack(),
    --CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnSleep(),
	EventHandler("attacked", onattackedfn),
	EventHandler("doattack", onattackfn),
    EventHandler("gotosleep", function(inst) inst.sg:GoToState("sleep") end),
    EventHandler("entershield", function(inst) inst.sg:GoToState("shield_start") end),
    EventHandler("exitshield", function(inst) inst.sg:GoToState("shield_end") end),
}

local function pickrandomstate(inst, choiceA, choiceB, chance)
	if math.random() >= chance then
		inst.sg:GoToState(choiceA) 
	else
		inst.sg:GoToState(choiceB)
	end
end


local states =
{

	State{
		name = "idle_tendril",
		tags = {"idle", "canrotate"},

        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle_tendrils")
            else
                inst.AnimState:PlayAnimation("idle_tendrils")
            end
            
        end,

        timeline = 
        {
            TimeEvent(5*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/idle") end),        
            TimeEvent(20*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/idle") end),        
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
	},

    State{
        name = "eat",
        tags = {"idle"},

        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_tendrils")
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley")            
        end,

        timeline = 
        {
            TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
            TimeEvent(8*FRAMES, function(inst) 
                    inst:PerformBufferedAction() 
                    PlayLobSound(inst, "dontstarve/creatures/rocklobster/idle")
                end),
            TimeEvent(20*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },


	--[[
    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley")
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/taunt")
        end,
        
        timeline = 
        {
            TimeEvent(10*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
            TimeEvent(25*FRAMES, function(inst) CallMeteor(inst) end),   
			TimeEvent(30*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),			
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	]]--
	
	State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("rocklick_pre")
            inst.AnimState:PushAnimation("rocklick_loop")
            inst.AnimState:PushAnimation("rocklick_pst", false)
        end,

        timeline = 
        {
            TimeEvent(5*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
            TimeEvent(10*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/attack") end),
            TimeEvent(20*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
            TimeEvent(25*FRAMES, function(inst) inst:PerformBufferedAction() end ),
            TimeEvent(35*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("ground_pound") end),
        },
    }, 
	
    State{
        name = "rocklick",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("rocklick_pre")
            inst.AnimState:PushAnimation("rocklick_loop")
            inst.AnimState:PushAnimation("rocklick_pst", false)
        end,

        timeline = 
        {
            TimeEvent(5*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
            TimeEvent(10*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/attack") end),
            TimeEvent(20*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
            TimeEvent(25*FRAMES, function(inst) inst:PerformBufferedAction() end ),
            TimeEvent(35*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    }, 



    State{
        name = "shield_start",
        tags = {"busy", "hiding"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hide")
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley")
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/hide")
            inst.Physics:Stop()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("shield") end ),
        },
    },

    State{
        name = "shield",
        tags = {"busy", "hiding"},

        onenter = function(inst)
            --If taking fire damage, spawn fire effect. 
            inst.components.health:SetAbsorptionAmount(0.999)
            inst.AnimState:PlayAnimation("hide_loop")
            inst.components.health:StartRegen(50, 1)
            inst.sg:SetTimeout(3)
        end,

        onexit = function(inst)
            inst.components.health:SetAbsorptionAmount(0)
            inst.components.health:StopRegen()
        end,
        
        ontimeout = function(inst)
            inst.sg:GoToState("shield")            

        end,

        timeline = 
        {
            TimeEvent(20*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/sleep") end),
        },


    },

    State{
        name = "shield_end",
        tags = {"busy", "hiding"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("unhide")
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley")
        end,

        timeline = 
        {
            TimeEvent(10*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        },

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
	
	State{
        name = "ground_pound",
        tags = {"busy", "attack"},

        onenter = function(inst)
			if inst.components.locomotor then 
				inst.components.locomotor:StopMoving()
			end
			
            inst.AnimState:PlayAnimation("atk")
			--inst.AnimState:PlayAnimation("idle_tendrils")
			--inst.cangroundpound = false
        end,

		timeline=
        {
			TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
			TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/attack") end),
			TimeEvent(5*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
			TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap_small") end),
			TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap_small") end),
			TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/attack_whoosh") end),
			TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap") end),
			TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack() end),
			TimeEvent(25*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),
			TimeEvent(25*FRAMES, function(inst) GroundPound(inst) end),			
			TimeEvent(30*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),
			
        },
		
        events=
        {
            EventHandler("animover", function(inst) 
			--if not inst.components.timer:TimerExists("Groundpound") then
			--inst.components.timer:StartTimer("Groundpound", ROCKY_GROUNDPOUND_COOLDOWN)
			--end
			inst.sg:GoToState("idle") end ),
        },
    },
	
	State{
        name = "call_meteor",
        tags = {"busy", "attack"},

        onenter = function(inst)
			if inst.components.locomotor then 
				inst.components.locomotor:StopMoving()
			end
			
            --inst.AnimState:PlayAnimation("atk")
			inst.AnimState:PlayAnimation("taunt")
			PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley")
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/taunt")
			inst.cancallmeteor = false
        end,

		timeline = 
        {
			TimeEvent(5*FRAMES, function(inst) CallMeteor(inst) end),
            TimeEvent(10*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),          
			TimeEvent(30*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),			
        },
		
        events=
        {
            EventHandler("animover", function(inst) 
			if not inst.components.timer:TimerExists("Callmeteor") then
			inst.components.timer:StartTimer("Callmeteor", ROCKY_CALLMETEOR_COOLDOWN)
			end
			inst.sg:GoToState("idle") end ),
        },
    },
}

CommonStates.AddWalkStates(states,
{
    starttimeline =  {
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),
    },
	walktimeline = {
        TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/footstep") end),
        TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/footstep") end),
        TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/footstep") end),
        TimeEvent(15*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/footstep") end),
        TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/footstep") end),
    },
    endtimeline = {
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),    
    },
})

CommonStates.AddSleepStates(states,
{
    starttimeline = {
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
    },
    sleeptimeline = {
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/sleep") end),
        TimeEvent(20*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        

    },
    endtimeline ={
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        },
})


local function hitanim(inst)
    if inst:HasTag("hiding") then
        return "hide_hit"
    else
        return "hit"
    end
end

local combatanims =
{
    hit = hitanim,
}

CommonStates.AddCombatStates(states,
{
    attacktimeline = 
    {            
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/attack") end),
        TimeEvent(5*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
        TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap_small") end),
        TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap_small") end),
        TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/attack_whoosh") end),
        TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap") end),
        TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        TimeEvent(25*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),                
        TimeEvent(30*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),
		--TimeEvent(30*FRAMES, function(inst) GroundPound(inst) end),
    },
    hittimeline = {
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/hurt") end),
        TimeEvent(0*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
    },
    deathtimeline = {
        TimeEvent(0*FRAMES, function(inst) 
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/death") 
            PlayLobSound(inst, "dontstarve/creatures/rocklobster/explode") 
        end),

        
    },
}, 
combatanims)

CommonStates.AddFrozenStates(states)
CommonStates.AddIdle(states, "idle_tendril", nil ,
{
    TimeEvent(5*FRAMES, function(inst) PlayLobSound(inst, "dontstarve/creatures/rocklobster/foley") end),        
    TimeEvent(30*FRAMES, function(inst) PlayLobSound(inst,"dontstarve/creatures/rocklobster/foley") end),                    
})

return StateGraph("rocky", states, events, "idle", actionhandlers)
