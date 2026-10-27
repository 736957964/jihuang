require("stategraphs/commonstates")

local FREEZING_COOLDOWN = 3
local TOGGLE_STATE_COOLDOWN = 8

--鱼鱼范围冰冻
local function Freezing(inst, target)
	if not inst or not target then return end
    local numFX = math.random(6,10)
    local pos = inst:GetPosition()
    local targetPos = target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())

    for i = 1, numFX do
        inst:DoTaskInTime(math.random() * 0.25, function(inst)
            local prefab = "icespike_fx_"..math.random(1,4)
            local fx = SpawnPrefab(prefab)
			local currentscale = fx.Transform:GetScale()
			fx.Transform:SetScale(currentscale*1,currentscale*1.2,currentscale*1)
            if fx then
                local x = GetRandomWithVariance(0,1)
                local z = GetRandomWithVariance(0,1)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x,0,z)
                fx.Transform:SetPosition((offset+pos):Get())
            end
        end)
    end
	
	local x1, y1, z1 = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x1, y1, z1, 3, { "player" })
	for _,obj in pairs(ents) do
		if obj and (obj:HasTag("player") or obj:HasTag("character")) 
		and not (obj:HasTag("rp_monster") or obj:HasTag("shadowboss")) 
		and obj.components.freezable then 
			obj.components.freezable:AddColdness(2)
			obj.components.freezable:SpawnShatterFX()
		end
	end
end

--重写攻击状态
local function onattackfn(inst, data)
	if inst.components.health ~= nil 
	and not inst.components.health:IsDead() 
	and not inst.sg:HasStateTag("busy") then
	
		if not (inst.canhypnosis or inst.components.timer:TimerExists("Freezing")) then
			inst.components.timer:StartTimer("Freezing", FREEZING_COOLDOWN)
		end
		--转换状态计时器
		if not ( inst.components.timer:TimerExists("Togglestate")) then
			inst.components.timer:StartTimer("Togglestate", MERM_TOGGLE_COOLDOWN)
		end 
		
		if inst.cantogglestate then
			inst.sg:GoToState("distance_attack")
		
		else
		--[[
			inst.sg:GoToState(
                    data.target:IsValid()
                    and not inst:IsNear(data.target, 10)
                    and "distance_attack" --Do spit attack
                    or "attack",
                    data.target
                )
				]]--
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
}


local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttack(),
   -- CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
	EventHandler("attacked", onattackedfn),
	EventHandler("doattack", onattackfn),
}

local states=
{
	State{
		name = "freeze",
		tags = {"attack","busy"},
		
		onenter = function(inst, leader)
			
			if inst.components.locomotor then 
				inst.components.locomotor:StopMoving()
			end
			
			inst.AnimState:PlayAnimation("atk")
			
			inst.canfreezing = false
		end,
		
		timeline=
        {
			TimeEvent(12*FRAMES, function(inst) Freezing(inst, inst.components.combat.target) end),
			TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
		
        events =
        {
            EventHandler("animover", function(inst) 
			if not inst.components.timer:TimerExists("Freezing") then
				inst.components.timer:StartTimer("Freezing", FREEZING_COOLDOWN)
			end
			inst.sg:GoToState("idle") end ),
        },        
    },
	
	State{
        name = "distance_attack",
        tags = {"attack", "busy",},

        onenter = function(inst, target)
            if inst.weapon and inst.components.inventory then
                inst.components.inventory:Equip(inst.weapon)
            end
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
			
			inst.sg.statemem.target = inst.components.combat.target
			inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            --inst.sg.statemem.target = target
        end,

        onexit = function(inst)
            if inst.components.inventory then
                inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
            end
        end,

        timeline =
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack") end),
			TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh") end),
			TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
})

CommonStates.AddSleepStates(states,
{
	sleeptimeline = 
	{
		TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/sleep") end ),
	},
})

CommonStates.AddCombatStates(states,
{
    attacktimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack") end),
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh") end),
		TimeEvent(19*FRAMES, function(inst) Freezing(inst, inst.components.combat.target) end),	
        TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack() end),
		
    },
    hittimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/hurt") end),
    },
    deathtimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/death") end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4*FRAMES, {"busy"})
CommonStates.AddSimpleActionState(states, "eat", "eat", 10*FRAMES, {"busy"})
CommonStates.AddFrozenStates(states)

    
return StateGraph("merm", states, events, "idle", actionhandlers)

