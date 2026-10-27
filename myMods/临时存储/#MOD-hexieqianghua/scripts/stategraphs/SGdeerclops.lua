require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.HAMMER, "attack"),
	ActionHandler(ACTIONS.GOHOME, "taunt"),
}

local SHAKE_DIST = 40
local ICE_NUM_RINGS = 5
local ICE_DAMAGE_RINGS = 4
local ICE_DESTRUCTION_RINGS = 5
local ICE_RING_DELAY = 0.2
local ICE_NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
--------------------------------------------------------------------------

local function ChooseAttack(inst)
    if inst.icepower_cd ~= nil then
        if not inst.components.timer:TimerExists("icepower_cd") then
            if inst.anger then
                inst.sg:GoToState("icepower_anger")
            else
                inst.sg:GoToState("icepower")
            end
            return true
        end
    end
    
    inst.sg:GoToState("atk")
    return false
end

local function readyAnima(inst)
    inst.AnimState:PlayAnimation("taunt")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr")
    local pt = inst:GetPosition()
    SpawnPrefab("groundpoundring_fx").Transform:SetPosition(pt:Get())
end

local function DeerclopsFootstep(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 2, inst, SHAKE_DIST)
end

local function SpawnIceFx(inst, target)
    if not inst or not target then return end
    local numFX = math.random(15,20)
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
            if fx then
                local x = GetRandomWithVariance(0, 3)
                local z = GetRandomWithVariance(0, 3)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x,0,z)
                fx.Transform:SetPosition((offset+pos):Get())
            end
        end)
    end
end

local function FindScopeIceTargets(inst, target)
    local maxices = math.random(2,5)
    local delta = (1 + math.random()) * PI / maxices
    local offset = 2 * PI * math.random()
    local angles = {}
    local posTargets = {}

    local targetPos = target:GetPosition()
    local angle = inst:GetAngleToPoint(targetPos:Get())
    table.insert(angles, angle)

    for i = 1, maxices - 1 do
        table.insert(angles, i * delta + angle + offset)
    end

    local pt = inst:GetPosition()
    local minrange = 4
    local maxrange = 8.75
    for i = 1, 2 do
        local closerange = (minrange + maxrange) * .5
        local targets = TheSim:FindEntities(pt.x, 0, pt.z, closerange, { "_combat", "_health" }, { "player", "INLIMBO" })
        if #targets < 1 then
            break
        end
        maxrange = closerange
    end

    local range = GetRandomMinMax(minrange, maxrange)
    while #angles > 0 do
        local theta = table.remove(angles, math.random(#angles))
        local offset = FindWalkableOffset(pt, theta, range, 12, true)
        if offset ~= nil then
            offset.x = offset.x + pt.x
            offset.y = 0
            offset.z = offset.z + pt.z
            table.insert(posTargets, offset)
        end
    end

    return posTargets
end

-- 沿直线扇形分段施放冰柱群
local function SpawnLineIce(inst, pos, targetPos)
    local numFX = math.random(5,10)
    -- local vec = targetPos - pos
    -- vec = vec:Normalize()
    -- local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())
    ----多段36度扇形
	for j = 0, 4 do
		inst:DoTaskInTime(1+1*j, function()
			--inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe") 
			ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .05, 2, inst, SHAKE_DIST)
		end)
			
		for i = 1, math.floor(numFX * ((4-j)*0.2+1) ) do
			inst:DoTaskInTime( 0.25 + math.random() * 0.75 + 1*j, function(inst)
				
				local prefab = "icespike_fx_"..math.random(1,4)
				local fx = SpawnPrefab(prefab)
				if fx then
					local fx_angle = math.random(angle-18, angle+18)*DEGREES
					local fx_r = math.random(0, 6)+6*j
					local offset = Vector3( fx_r * math.cos(fx_angle), 0, -fx_r * math.sin(fx_angle) ) 
					local pt = pos+offset
					fx.Transform:SetPosition(pt:Get())
					fx.Transform:SetScale(1.6,3 + 0.5*j,1.6)
					
					----冰柱伤害
					local r = 1.33
					local center_dmg = (120 - 60/18 * fx_r) / 3
					local ceter_destory = 2
					local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, ICE_NO_TAGS)
					for k,v in pairs(ents) do
                        -- 同物种之间可以互相伤害 and v.prefab ~= inst.prefab
						if v and v.components.health and not v.components.health:IsDead() and v ~= inst then
							
							-- local dst = pt:Dist(v:GetPosition())
							-- local dmg_mult = 1 - dst/r
							
							if v.components.combat then
								v.components.combat:GetAttacked(inst, center_dmg)
							end
						end
						
						if v and v:IsValid() and v.components.workable and v.components.workable:CanBeWorked() then
							local dst = pt:Dist(v:GetPosition())
							local dmg_mult = 1 - dst/r
							v.components.workable:WorkedBy(inst, ceter_destory * dmg_mult)
						end
					end
					
				end
			end)
		end
	end
end

--大招:冰阵
local function SpawnIcePower(inst, target)
	if not inst or not target then return end
    local targets = FindScopeIceTargets(inst, target)
    if #targets > 0 then
        local pos = inst:GetPosition()
        for _,targetPos in pairs(targets) do
            SpawnLineIce(inst, pos, targetPos)
        end
    end
    
    -- local pos = inst:GetPosition()
    -- local targetPos = target:GetPosition()
    -- local angle = inst:GetAngleToPoint(targetPos:Get()) + 45
    -- for i = 0, 3 do
    --     local dist_angle = (angle + i * 90) * DEGREES
    --     local dist_range = 1
    --     local offset = Vector3( dist_range * math.cos(dist_angle), 0, -dist_range * math.sin(dist_angle) ) 
    --     local distPos = pos + offset
    --     --SpawnPrefab("spawn_fx_medium").Transform:SetPosition(distPos:Get())
    --     SpawnLineIce(inst, pos, distPos)
    -- end
end

local function GetPoints(pt)
    local points = {}
    local radius = 1

    for i = 1, ICE_NUM_RINGS do
        local theta = 0
        local circ = 2*PI*radius
        local numPoints = circ * .25
        for p = 1, numPoints do

            if not points[i] then
                points[i] = {}
            end

            local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
            local point = pt + offset

            table.insert(points[i], point)

            theta = theta - (2*PI/numPoints)
        end
        
        radius = radius + 4

    end
    return points
end

local function DestroyPoints(inst, pos, points, maxRange, breakobjects, dodamage)
    local getEnts = breakobjects or dodamage
    local map = TheWorld.Map
    local range = 3
    local ceter_destory = 2
    for k, v in pairs(points) do
        if getEnts then
            local ents = TheSim:FindEntities(v.x, v.y, v.z, range, nil, ICE_NO_TAGS)
            if #ents > 0 then
                if breakobjects then
                    for i, v2 in ipairs(ents) do
                        if v2 ~= inst and v2:IsValid() then
                            -- Don't net any insects when we do work
                            if v2.components.workable ~= nil and
                                v2.components.workable:CanBeWorked() and
                                v2.components.workable.action ~= ACTIONS.NET then
                                local dst = v:Dist(v2:GetPosition())
							    local dmg_mult = 1 - dst/1.34
                                v2.components.workable:WorkedBy(inst, ceter_destory * dmg_mult)
                                --v2.components.workable:Destroy(inst)
                            end
                        end
                    end
                end
                if dodamage then
                    for i, v2 in ipairs(ents) do
                        if v2 ~= inst and
                            v2:IsValid() and
                            v2.components.health ~= nil and
                            not v2.components.health:IsDead() and 
                            inst.components.combat:CanTarget(v2) then
                            -- 鹿角怪攻击力
                            --inst.components.combat.defaultdamage
                            local defaultdamage = inst.components.combat.defaultdamage
                            local dst = pos:Dist(v2:GetPosition())
                            local dmg = defaultdamage - ((dst > 5 and dst - 5 or 1) / maxRange) * defaultdamage
                            v2.components.combat:GetAttacked(inst, dmg)
                            --inst.components.combat:DoAttack(v2, nil, nil, nil, 1)
                        end
                    end
                end
            end
        end

        if map:IsPassableAtPoint(v:Get()) then
            SpawnPrefab("icespike_fx_"..math.random(1,4)).Transform:SetPosition(v.x, 0, v.z)
        end
    end
end

--大招:愤怒冰阵
local function SpawnAngerIcePower(inst, target)
	if not inst or not target then return end
    local pos = inst:GetPosition()
    local points = GetPoints(pos)
    local delay = 0
    for i = 1, ICE_NUM_RINGS do
        inst:DoTaskInTime(delay, function() DestroyPoints(inst, pos, points[i], ICE_NUM_RINGS * 4, i <= ICE_DAMAGE_RINGS, i <= ICE_DESTRUCTION_RINGS) end)
        delay = delay + ICE_RING_DELAY
    end
end

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            ChooseAttack(inst)
        end
    end),
    EventHandler("attacked", function(inst, data)
        if inst.components.health ~= nil and not inst.components.health:IsDead() and inst.sg:HasStateTag("frozen") then
            inst.sg:GoToState("hit")
        end
    end),
    CommonHandlers.OnDeath(),
}

local states=
{
    State{
        name = "icepower",
        tags = { "attack", "busy" },
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr")
			end),
            TimeEvent(16*FRAMES, function(inst)
				SpawnIcePower(inst, inst.components.combat.target) 

				if not inst.components.timer:TimerExists("icepower_cd") then
					inst.components.timer:StartTimer("icepower_cd", inst.icepower_cd or 1)
				end
			end),
        },
        
        events=
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

    State{
        name = "icepower_anger",
        tags = { "attack", "busy" },
        
        onenter = function(inst)
            inst.Physics:Stop()
            readyAnima(inst)
            inst.components.health.absorb = .9
            --inst.Light:Enable(true)
            inst.sg:SetTimeout(150*FRAMES)
        end,
        
        timeline=
        {
            TimeEvent(60*FRAMES, function(inst)
                readyAnima(inst)
			end),
            TimeEvent(120*FRAMES, function(inst)
                readyAnima(inst)
			end),
            TimeEvent(140*FRAMES, function(inst)
				SpawnAngerIcePower(inst, inst.components.combat.target)

				if not inst.components.timer:TimerExists("icepower_cd") then
					inst.components.timer:StartTimer("icepower_cd", inst.icepower_cd or 1)
				end
			end),
        },
        
        -- events=
        -- {
        --     CommonHandlers.OnNoSleepAnimOver("idle"),
        -- },

        ontimeout = function(inst)
			inst.sg:GoToState("idle") 
		end,
		
		onexit = function(inst)
			inst.components.health.absorb = 0
			--inst.Light:Enable(false)
		end,
    },

    State{
        name = "atk",
        tags = { "attack", "busy" },
        
        onenter = function(inst, target)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("atk")
            inst.components.combat:StartAttack()

            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
            TimeEvent(29*FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
            TimeEvent(35*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.HAMMER then
                    inst.bufferedaction.target.components.workable:SetWorkLeft(1)
                    inst:PerformBufferedAction()
                end
                ShakeAllCameras(CAMERASHAKE.FULL, .5, .05, 2, inst, SHAKE_DIST)
            end),
            TimeEvent(36*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        },
        
        events=
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },      

    State{
        name = "gohome",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst:ClearBufferedAction()
            inst.components.knownlocations:RememberLocation("home", nil)
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },      
    
	State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.GOHOME then
            	inst:PerformBufferedAction()
            end
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddWalkStates( states,
{
	starttimeline =
	{
        TimeEvent(7*FRAMES, DeerclopsFootstep),
	},
    walktimeline = 
    { 
        TimeEvent(23*FRAMES, DeerclopsFootstep),
        TimeEvent(42*FRAMES, DeerclopsFootstep),
    },
    endtimeline=
    {
        TimeEvent(5*FRAMES, DeerclopsFootstep),
    },
})

CommonStates.AddCombatStates(states,
{
	hittimeline =
	{
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/hurt") end),
	},
    attacktimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
        TimeEvent(29*FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
        TimeEvent(35*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
            inst.components.combat:DoAttack(inst.sg.statemem.target)
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.HAMMER then
                inst.bufferedaction.target.components.workable:SetWorkLeft(1)
                inst:PerformBufferedAction()
            end
            ShakeAllCameras(CAMERASHAKE.FULL, .5, .05, 2, inst, SHAKE_DIST)
        end),
        TimeEvent(36*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },
    deathtimeline=
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/death") end),
        TimeEvent(50*FRAMES, function(inst)
            if TheWorld.state.snowlevel > 0.02 then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_snow")
            else
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_dirt")
            end
            ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, 3, inst, SHAKE_DIST)
        end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        --TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("deerclops", states, events, "idle", actionhandlers)

