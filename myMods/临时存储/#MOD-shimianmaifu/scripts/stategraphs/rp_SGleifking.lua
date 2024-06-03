require("stategraphs/commonstates")

local actionhandlers = 
{
}

local SHAKE_DIST = 40

--根刺
local function RootThorn(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 15, { "player" })
	for _, v in ipairs(ents) do
		if v.components.health and not v.components.health:IsDead() then
			local x1,y1,z1 = v.Transform:GetWorldPosition()
			local deciduous_root = SpawnPrefab("deciduous_root")
			deciduous_root.Transform:SetPosition(x1,y1,z1)
		end
	end
end

--大地颤抖
local function EarthQuake(inst)
	--print("--EarthQuake--")
	local x,y,z = inst.Transform:GetWorldPosition()
	local fx = SpawnPrefab("groundpoundring_fx")
	fx.Transform:SetScale(1,1,1)
	fx.Transform:SetPosition(x,y,z)
	
	local ents = TheSim:FindEntities(x, y, z, 8, { "_combat" }, {"rp_monster", "shadowboss", "hostile"})
	for _, v in ipairs(ents) do
		if v and v.components.health and not v.components.health:IsDead() then
			if v.components.combat ~= nil then
				v.components.combat:GetAttacked(inst, 40, nil)
			end
			if v:HasTag("player") then
				local item = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if not item then return end
				v.components.inventory:DropItem(item)
				local x2, y2, z2 = item:GetPosition():Get()
				y = .1
				item.Physics:Teleport(x2,y2,z2)
				local hp = v:GetPosition()
				local pt = inst:GetPosition()
				local vel = (hp - pt):GetNormalized()
				local speed = 5 + (math.random() * 2)
				local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
				item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
			end
		end
	end
	
end

local function LeifFootstep(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 1, inst, SHAKE_DIST)
end

local function onattackfn(inst, data)
	if inst.components.health and not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
		
		if not (inst.canearthquake or inst.components.timer:TimerExists("Earthquake")) then
			inst.components.timer:StartTimer("Earthquake", LEIF_EARTHQUACK_COOLDOWN)
		end
		
		if not (inst.canearthquake or inst.components.timer:TimerExists("RootThorn")) then
			inst.components.timer:StartTimer("RootThorn", LEIF_EARTHQUACK_COOLDOWN)
		end
		
		if inst.canearthquake then
			inst.sg:GoToState("earthquake")
		else
			inst.sg:GoToState("attack", data.target)
		end

	end
end

local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not
     inst.sg:HasStateTag("attack") and not
      inst.sg:HasStateTag("waking") and not
       inst.sg:HasStateTag("sleeping") and 
        (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
            inst.sg:GoToState("hit") 
      end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	EventHandler("doattack", onattackfn),
    --EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then inst.sg:GoToState("attack", data.target) end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("gotosleep", function(inst) inst.sg:GoToState("sleeping") end),
    EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
    
    
}

local states=
{

	State{
        name = "earthquake",
        tags = {"attack", "busy"},
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("transform_tree", false)
            --inst.AnimState:PlayAnimation("transform_ent")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
			inst.canearthquake = false
        end,
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
			if not inst.components.timer:TimerExists("Earthquake") then
				inst.components.timer:StartTimer("Earthquake", LEIF_EARTHQUACK_COOLDOWN)
			end
			inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
			TimeEvent(20*FRAMES, function(inst) 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
			ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 4, inst, 40)
			EarthQuake(inst)
			end),
			TimeEvent(25*FRAMES, function(inst) 
				inst.AnimState:PlayAnimation("transform_ent") 
				inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
			--	RootThorn(inst)
			end),
            TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },
	
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            --inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.SoundEmitter:PlaySound("dontstarve/forest/treeFall")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
    
    State{
        name = "tree",
        onenter = function(inst)
            inst.AnimState:PlayAnimation("tree_idle", true)
        end,
    },   

    State{
        name = "panic",
        tags = {"busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("panic_pre")
            inst.AnimState:PushAnimation("panic_loop", true)
        end,
        onexit = function(inst)
        end,
        
        onupdate = function(inst)
			if inst.components.burnable and not inst.components.burnable:IsBurning() and inst.sg.timeinstate > .3 then
				inst.sg:GoToState("idle", "panic_post")
			end
        end,
    },   
    
	State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            TimeEvent(26*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
			
			TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
			TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/swipe") RootThorn(inst) end),
			TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },  
    
	State{
        name = "hit",
        tags = {"hit", "busy"},
        
        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/hurt_VO")
            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },      
    
    State{
        name = "sleeping",
        tags = {"sleeping", "busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_tree", false)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
        end,
        events=
        {
		    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() then inst.sg:GoToState("wake") end end),
        },
        
        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },
    
    State{
        name = "spawn",
        tags = {"waking", "busy"},
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_ent")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },
    
	State{
        name = "wake",
        tags = {"waking", "busy"},
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_ent_mad")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
        
    },          
}

CommonStates.AddWalkStates(
    states,
    {
		starttimeline =
		{
            TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end),
            TimeEvent(11*FRAMES, function(inst) inst.components.locomotor:WalkForward() end),
            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(17*FRAMES, function(inst) inst.Physics:Stop() end),
		},
        walktimeline = 
        { 
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/walk_vo") end),
            TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/footstep") ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 2, inst, SHAKE_DIST) end),
            TimeEvent(52*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(53*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/footstep") ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 2, inst, SHAKE_DIST) end),
        },
        endtimeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
    })

CommonStates.AddIdle(states)
CommonStates.AddFrozenStates(states)

return StateGraph("leif", states, events, "idle", actionhandlers)

