require("stategraphs/commonstates")

--mod from DST lavaarena mod

local function ShakeIfClose(inst)
    ShakeAllCameras(0, .2, .01, .1, inst, 8)
end

local function FootShake(inst)
    ShakeAllCameras(0, .2, .01, .1, inst, 8)
end

local function ShakePound(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_dirt")
    ShakeAllCameras(0, 1.2, .03, .7, inst, 30)
end

local function ShakeRoar(inst)
    ShakeAllCameras(0, 0.8, .03, .5, inst, 30)
end

local actionhandlers = 
{
	ActionHandler(ACTIONS.ATTACK, "attack"),
}

local NOTAGS = {"mythTag_rhino", "notarget", "INLIMBO", 'FX'}

local DOAOEATTACK_TARGET_MUST_HAVE = { "_combat" }
local DOAOEATTACK_TARGET_CANT_HAVE = { "mythTag_rhino", "notarget", 'FX', "shadow", "ghost", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }

local function isinrange(inst,target)
    local ang = inst.Transform:GetRotation()
    local x,y,z = target.Transform:GetWorldPosition()
    local angle = inst:GetAngleToPoint( x,0,z )
    local drot = math.abs( ang - angle )
    while drot > 180 do
        drot = math.abs(drot - 360)
    end
    return drot < 80
end

local function DoFrontAoe(inst,nofront)
    local x0, y0, z0 = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x0, 0, z0, nofront and 6 or 4, DOAOEATTACK_TARGET_MUST_HAVE, DOAOEATTACK_TARGET_CANT_HAVE)) do
        if v:IsValid() and not v:IsInLimbo() and (nofront or isinrange(inst,v))  and
            not (v.components.health ~= nil and v.components.health:IsDead()) then
            if  inst.components.combat:CanTarget(v) then
				if  v.components.combat then --造成一次伤害
					inst.components.combat:DoAttack(v)
				end
				if v:HasTag("player") and (not inst.knockbacktarget[v] or GetTime()- inst.knockbacktarget[v] > 5 ) then
                	v:PushEvent("knockback", { knocker = inst, radius = 4})
					inst.knockbacktarget[v] = GetTime()
				end
            end
        end
    end
end

local function DoDashingAOE(inst)
	if inst.sg:HasStateTag("dashing") then
		local pos = inst:GetPosition()
		local angle = -inst.Transform:GetRotation() * DEGREES
		local offset = 2
		local targetpos = {x = pos.x + (offset * math.cos(angle)), y = 0, z = pos.z + (offset * math.sin(angle))} 
		local chargedents = {}
		local ents = TheSim:FindEntities(targetpos.x, 0, targetpos.z, 3, nil, NOTAGS)
		local donedamage, donedestroy = false, false
		for i, v in ipairs(ents) do
			if v.components.workable ~= nil
				and v.components.workable:CanBeWorked()
				and v.components.workable.action ~= ACTIONS.NET then
				v.components.workable:Destroy(inst)
				donedestroy = true
			end

			if v.components.health and not v.components.health:IsDead() and v.components.combat then
				if inst.dash_hit_targets[v] and ((GetTime() - inst.dash_hit_targets[v]) <= 1.5) then
					--print('no dmg!')
				else
					inst.components.combat:DoAttack(v)
					--v.components.combat:GetAttacked(inst, 400)
					inst.dash_hit_targets[v] = GetTime()
					if inst.components.combat.target == v then
						donedamage = true
					end
				end
			end
		end

		inst.dash_hit_counter = (inst.dash_hit_counter or 0) + 
			(donedamage and 1 or 0) + (donedestroy and 0.5 or 0)
	end
end

local function tuantattack(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 6, { "_combat","_health" },  {"mythTag_rhino", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" })
    for i, ent in ipairs(ents) do
		if ent and ent:IsValid() and inst.replica.combat:IsValidTarget(ent) then
			inst.components.combat:DoAttack(ent)
			if ent:IsValid() and ent:HasTag("player") and not ent.components.health:IsDead() then
				ent:PushEvent("knockback", { knocker = inst, radius = 4 })
			end
        end
    end
end
local function DoShoutting(inst,data)
    data = data or {}
    local offset = data.offset or Vector3(0,0,0)
    local period = data.period or 0.1
    local shoutfx = data.shoutfx or "rhino_shoutfx"
    local shoutsound = data.shoutsound or ""
    local maxtime = data.maxtime or 0.5
    for i=0,maxtime,period do 
        inst:DoTaskInTime(i,function()
            --ShakeAllCameras(CAMERASHAKE.VERTICAL,period, .025, 1.25, inst, 40)
			local fx = SpawnPrefab(shoutfx)
            fx.entity:SetParent(inst.entity)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(inst.GUID, "mouth", 0, 30, 0)
            if i == period then 
                inst.SoundEmitter:PlaySound(shoutsound)
            end
            if data.updatefn then
                data.updatefn(inst)
            end 
        end)
    end
	ShakeAllCameras(CAMERASHAKE.VERTICAL,period, .025, 1.25, inst, 40)

	inst:DoTaskInTime(0.3,function()
    	local x, y, z = inst.Transform:GetWorldPosition()
    	local ents = TheSim:FindEntities(x, y, z, 6, { "_combat","_health" },  {"mythTag_rhino", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" })
    	for i, ent in ipairs(ents) do
			if ent and ent:IsValid() and inst.replica.combat:IsValidTarget(ent) then
				if inst.revivetaunt then
					ent.components.combat:GetAttacked(inst, 100)
				else
					inst.components.combat:DoAttack(ent)
				end
				if ent:IsValid() and ent:HasTag("player") and not ent.components.health:IsDead() then
					ent:PushEvent("knockback", { knocker = inst, radius = 4})
				end
        	end
    	end
	end)
end

local function _WorldCollision()
	return --[[rawget(_G, 'GetWorldCollision') and GetWorldCollision() or]] COLLISION.WORLD
end

local function _WaterCollision()
	return rawget(_G, 'GetWaterCollision') and GetWaterCollision() or COLLISION.WORLD
end

local function SetDashPhysics(inst)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(_WorldCollision())
    --inst.Physics:CollidesWith(_WaterCollision())
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:Teleport(inst.Transform:GetWorldPosition())
end

local function SetNormalPhysics(inst)
	ChangeToCharacterPhysics(inst)
end

local events=
{
	EventHandler("dospell", function(inst) --施法
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("frozen")
			and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("canattack")) then
			inst.sg:GoToState("spell_pre")
		end
	end),

	EventHandler("attacked", function(inst, data) 		
		if not inst.sg:HasStateTag('death') and not (inst.sg:HasStateTag('busy') or inst.sg:HasStateTag('attack') or inst.sg:HasStateTag('dashing')) then
			if  inst.stage == 3 then
				inst.sg:GoToState("taunt")
			elseif inst.stage == 2 then
				inst.sg:GoToState("dash_pre",data.attacker)
			else
				inst.sg:GoToState("hit")
			end
		end 
	end),
    EventHandler("death", function(inst, data) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst, data) 
		if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("canattack")) then 
			if inst:CanDoSpell() and not inst.sg:HasStateTag('spelling') then --攻击方式？
				inst.sg:GoToState("spell_pre", data.target) 
			elseif inst.stage == 3  then
				inst.lastattack_dash = GetTime()
				--inst.components.combat.laststartattacktime = GetTime() 
				inst.sg:GoToState("dash_pre",data.target)
			elseif inst.stage == 1 then
				inst.sg:GoToState("attack", data.target) 
			--elseif not inst.sg:HasStateTag("posing") then
			--	inst.sg:GoToState("pose") 
			end
		end
	end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnFreeze(),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
        	if not inst.components.combat.target or (inst.stage == 2 and not inst:CanDoSpell()) or (inst.stage == 3 and not inst:CanDoDash()) then
        		inst.sg:SetTimeout(1)
        	end
			inst.Transform:SetSixFaced()
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        ontimeout = function(inst)
        	inst.sg:GoToState('pose')
        end,
    },
	
    State{
        name = "attack", 
        tags = {"attack", "busy"},
		
		onenter = function(inst, target)
        local target = inst.components.combat.target 
		if target and target:IsValid() then
            inst:ForceFacePoint(target:GetPosition())
            inst.sg.statemem.attacktarget = target
        end
        --inst.components.combat:SetTarget(target)
		inst.Transform:SetSixFaced()
        
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()
        inst.Physics:Stop()
		inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/attack_2")
        inst.AnimState:PlayAnimation("attack")
	end,
	
    	timeline={
            TimeEvent(13*FRAMES, function(inst) 
				DoFrontAoe(inst)
			end),
   		},

        events={
            EventHandler("animover", function(inst) inst.sg:GoToState("idle")  end),
        },
	
    },

    --冲刺前的吼叫
    State{
		name = "dash_taunt",
        tags = {"busy",},

        onenter = function(inst, force)			
            inst.components.locomotor:Stop()
			inst.Transform:SetSixFaced()
            inst.AnimState:PlayAnimation("taunt")
        end,

		timeline=
        {
			TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/taunt") end),
        },

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("dash_pre") end),
        },
    },

    State{
		name = "taunt",
        tags = {"busy",},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
			inst.Transform:SetSixFaced()
            inst.AnimState:PlayAnimation("taunt")

			if target then
				inst.sg.statemem.revivetarget = target
				inst.components.health:SetInvincible(true)
				inst.revivetaunt = true
			else
				inst.revivetaunt = false
			end
        end,

		timeline=
        {
			TimeEvent(7*FRAMES, function(inst) 
				DoShoutting(inst,
					{	maxtime = 0.4,
						offset = Vector3(0,0,0),
						shoutfx = "rhino_shoutfx",
						shoutsound = "dontstarve/forge2/rhino_drill/taunt",
					}
				)
			end),
        },

        events=
        {
			EventHandler("animover", function(inst) 
				if not inst.components.health:IsDead() and  inst.sg.statemem.revivetarget  ~= nil and   inst.sg.statemem.revivetarget:IsValid()   then
					local pos = inst.sg.statemem.revivetarget:GetPosition()
					local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 1.5, 10)
					if offset ~= nil then
						pos.x = pos.x + offset.x
						pos.z = pos.z + offset.z	
					end
					SpawnPrefab("mk_cloudpuff").Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.Transform:SetPosition(pos:Get())	
					SpawnPrefab("mk_cloudpuff").Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.sg:GoToState("revive",inst.sg.statemem.revivetarget)
				else
					inst.sg:GoToState("pose")
				end
			end),
        },
    },

    State{
		name = "revive",
        tags = {"busy",},

        onenter = function(inst, mytarget)
			inst.components.health:SetInvincible(true)
            inst.components.locomotor:Stop()
			inst.Transform:SetSixFaced()
            inst.AnimState:PlayAnimation("revive_pre")
			inst.AnimState:PushAnimation("revive_loop")
			if mytarget and mytarget:IsValid() then
				inst:ForceFacePoint(mytarget:GetPosition())
				inst.sg.statemem.mytarget = mytarget
			end
        end,

		timeline=
        {
			TimeEvent(0.23, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/revive_LP","revive_LP")
			end),
			TimeEvent(1.63+2, function(inst)
				if inst.sg.statemem.mytarget and inst.sg.statemem.mytarget:IsValid() then
					inst.sg.statemem.reviveover = true
					inst.sg.statemem.mytarget:PushEvent("revivebybrother")
				end
			end),
			TimeEvent(2.5+2, function(inst)
				inst.SoundEmitter:KillSound("revive_LP")
				inst.sg.statemem.successed = true
				inst.AnimState:PlayAnimation("revive_pst")
			end),
        },

        events=
        {
			EventHandler("animover", function(inst) 
				if inst.AnimState:IsCurrentAnimation("revive_pst") then
					local target = inst:GetDashTarget()
					if target then
						inst.sg:GoToState("dash_pre",target)
					else
						inst.sg:GoToState("pose")
					end
				end
			end),
        },
		onexit = function(inst)
			if inst.sg.statemem.mytarget and not inst.sg.statemem.reviveover then
				inst.sg.statemem.mytarget:PushEvent("revivebybrother")
			end
			inst.components.health:SetInvincible(false)
			if not inst.sg.statemem.successed then
				inst.SoundEmitter:KillSound("revive_LP")
			end
	    end,
    },

	--冲刺起步(run_start)
	State{
        name = "dash_pre",
        tags = {"running", "attack", 'dashing'},
		
		onenter = function(inst, target)
			inst.dash_loop_counter = 0
			inst.dash_hit_counter = 0
			inst.dash_hit_targets = {}
			inst.last_dash_time = GetTime()
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation('attack2_pre')
			inst.brain:Stop()

			local mytarget = target or inst.components.combat.target
			if mytarget and mytarget:IsValid() then
				inst:ForceFacePoint(mytarget:GetPosition())
				inst.sg.statemem.mytarget = mytarget
			end
			local lines = {
				"兄弟们，冲啊！",
				"冲！",
				"让你见识见识本大爷的厉害！",
				"顶你个人仰马翻！",
			}
			inst.components.talker:Say(lines[math.random(1, #lines)])
		end,

		onexit = function(inst)
			SetNormalPhysics(inst)
			if inst.brain ~= nil then
				inst.brain:Start()
			end
	    end,

        events=
        {
            EventHandler("animover", function(inst) 
				inst.sg:GoToState("dash_loop", inst.sg.statemem.target)  
			end),
        },
	
    },
	--冲刺阶段
	State{
        name = "dash_loop",
        tags = {"running", "attack", "dashing"},
		
		onenter = function(inst, target)
			inst.dash_loop_counter = ( inst.dash_loop_counter or 0 ) + 1
			
			if inst.brain ~= nil then
				inst.brain:Stop()
			end

			SetDashPhysics(inst)
			inst.Transform:SetEightFaced()

			if target and target:IsValid() then
				inst.sg.statemem.target = target
			elseif inst.components.combat.target and inst.components.combat.target:IsValid() then
				inst.sg.statemem.target = inst.components.combat.target
			else
				inst.sg:GoToState('run_stop') return;
			end
			
			if inst.dash_dmg_task == nil then
				inst.dash_dmg_task = inst:DoPeriodicTask(0.15, DoDashingAOE)
			end

			inst.components.locomotor:RunForward()
			inst.Physics:SetMotorVelOverride(inst.components.locomotor.runspeed, 0, 0)
        	inst.AnimState:PlayAnimation("attack2_loop")
        
		end,
	
		onupdate = function(inst)
			local target = inst.sg.statemem.target
			if inst:CheckTarget(target) ~= "GROUND" then
				inst.sg:GoToState('run_stop')
			elseif inst:ShouldReturnHome(30) then
				inst.sg:GoToState('run_stop')
			else
				local angle = inst.Transform:GetRotation() - inst:GetAngleToPoint(target:GetPosition())

				if angle > 180 then 
					angle = 360 - angle 
				elseif angle < -180 then 
					angle = 360 + angle 
				end
					
				local rot = 0
				local maxrott = 6
					
				if angle >= maxrott then
					rot = maxrott
				elseif angle <= -maxrott then
					rot = -maxrott
				else
					rot = angle
				end
				inst.Transform:SetRotation(inst.Transform:GetRotation() - rot)
				inst.Physics:SetMotorVelOverride(inst.components.locomotor.runspeed, 0, 0)
				--inst.Physics:SetMotorVelOverride(7,0,0)
			end	
		end,
		
		onexit = function(inst)
			SetNormalPhysics(inst)
			if inst.dash_dmg_task then
				inst.dash_dmg_task:Cancel()
				inst.dash_dmg_task = nil
			end
			if inst.brain ~= nil then
				inst.brain:Start()
			end
			inst.Physics:ClearMotorVelOverride()
	    end,
		
	    timeline=
	    {
			TimeEvent(9*FRAMES, PlayFootstep), TimeEvent(9*FRAMES, FootShake),
			TimeEvent(18*FRAMES, PlayFootstep), TimeEvent(18*FRAMES, FootShake),
	    },

        events=
        {
            EventHandler("animover", function(inst) 
				if inst.dash_loop_counter >= 3 then --最长冲刺距离
					inst.sg:GoToState("run_stop")
				elseif inst.dash_hit_counter >= 4 then
					inst.sg:GoToState('run_stop')
				elseif inst.components.burnable and inst.components.burnable:IsBurning() then
					inst.sg:GoToState('run')
				else
					inst.sg:GoToState('dash_loop', inst.sg.statemem.target)
				end	
			end),
        },
    },
	
	State{
		name = "hit",
        tags = {"busy", "hit"},

        onenter = function(inst)
			inst.Transform:SetSixFaced()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
			inst.sg.mem.last_hit_time = GetTime()
			inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/hit")
			inst.rams = 0
			inst.cheer_loop = 0
        end,
		
		onexit = function(inst)
			if inst.brain ~= nil then
				inst.brain:Start()
			end		
		end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
		name = "pose",
        tags = { "posing" , "idle", 'canattack'},

        onenter = function(inst)
        	--inst.components.health:StartRegen(5, 1)
			inst.Physics:Stop()
			inst.Transform:SetSixFaced()
			inst.Transform:SetRotation(math.random(360))
			inst.AnimState:PlayAnimation("pose_pre", false)
			inst.AnimState:PushAnimation("pose_loop", true)
        end,

		timeline=
        {
			--TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/cheer")end),
        },

        onexit = function(inst)
        	--inst.components.health:StopRegen()
        end,
    },
	
	--[[State{
		name = "taunt",
        tags = {"busy", "canattack"},

        onenter = function(inst, force)			
            inst.Physics:Stop()
			inst.Transform:SetSixFaced()
            inst.AnimState:PlayAnimation("taunt")
        end,

		timeline=
        {
			TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/taunt") end),
        },

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },]]
	
	State{
		name = "spell_pre",
        tags = {"busy", "spelling", "nosleep"},

        onenter = function(inst)
			inst.Transform:SetSixFaced()
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("cheer_pre")
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("spell_loop") end),
        },
    },
	
	State{
		name = "spell_loop",
        tags = {"busy", "spelling", "nosleep"},

        onenter = function(inst, cb)
        	local target = inst.components.combat.target
        	if target and target:IsValid() then--and target:IsOnValidGround() then
        		if inst:CanDoSpell() then
					inst:spellfn(target)
					inst.last_spell_time = GetTime()
				else
					inst.last_spell_time = GetTime() - 8
				end
			end
            inst.Physics:Stop()		
			inst.AnimState:PlayAnimation("cheer_loop")
			inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/cheer")
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("spell_pst") end),
        },
    },
	
	State{
		name = "spell_pst",
        tags = {"busy", "nosleep"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("cheer_post")
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "death",
        tags = {"busy", "nointerrupt", 'death'},

        onenter = function(inst, isdead)
			inst.Transform:SetSixFaced()
			inst.AnimState:PlayAnimation("death")
			
			inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/death")
            inst.Physics:Stop()
			if not inst.resurrected and inst.white_bone_killed then
				inst.sg.statemem.white_bone_killed = true
			end
            --inst.components.lootdropper:DropLoot()
        end,
		
		timeline=
        {
			TimeEvent(0, function(inst) 
				--救救救救救救
				if inst.resurrected then
					inst:ReviveMe()
				end
			end),
        	TimeEvent(60*FRAMES, function(inst) 
				if not inst.resurrected then
					inst.AnimState:PlayAnimation('death_finalfinal') 
				end
			end),
        	--和第二个动画同步
			--TimeEvent(37*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/death_final_final") end),
			TimeEvent(80*FRAMES, function(inst) 
				if not inst.resurrected then
					--真死了！
					inst.persists = false
					if not inst.sg.statemem.white_bone_killed then
						inst.components.lootdropper:DropLoot() 
					end
				end
			end),

			--应该不会发生	
			TimeEvent(6, function(inst) 
				ErodeAway(inst)
			end),
        },
        events=
        {
			--复活！
			EventHandler("revivebybrother", function(inst) 
				--inst.components.health.nofadeout = false
				--inst.resurrected = false
				inst.sg:GoToState("resurrect") 
			end),
        },
        onexit = function(inst)
			--inst.components.health:SetInvincible(false)
        end,
    },

    State{
        name = "resurrect",
        tags = { "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
			inst.components.health:SetInvincible(true)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("death_post")
			inst.sg.statemem.resurrecting = true
        end,

        timeline =
        {
            TimeEvent(0.1, function(inst)
                local stafflight = SpawnPrefab("staff_castinglight")
                stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
                stafflight:SetUp({ 150 / 255, 46 / 255, 46 / 255 }, 1, 20 * FRAMES)
            end),
            TimeEvent(0.5, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/cheer")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg.statemem.resurrecting = false
					inst.components.health:SetPercent(0.25)
					inst:Resurrect()
					local target = inst:GetDashTarget()
					if target then
						inst.sg:GoToState("dash_pre",target)
					else
						inst.sg:GoToState("idle")
					end
                end
            end),
        },

        onexit = function(inst)
			inst.components.health:SetInvincible(false)
			if inst.sg.statemem.resurrecting then
				inst.components.health:SetPercent(0.5)
				inst:Resurrect()
			end
        end,
    },
	
	State {
        name = "sleep",
        tags = { "sleeping", "busy" },

        onenter = function(inst)
			inst.Transform:SetSixFaced()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("sleep_pre")
			inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/sleep_pre")

        end,

        timeline = 
		{
			TimeEvent(38*FRAMES, function(inst) 
				ShakeIfClose(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/trails/bodyfall") 
			end),
		},

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end ),
            EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
        },
    },

    State
    {
        name = "sleeping",
        tags = { "sleeping", "busy" },
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/sleep_in")
			inst.AnimState:PlayAnimation("sleep_loop")
		end,
			
		timeline=
        {
			TimeEvent(24*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/sleep_out") end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end ),
			EventHandler("attacked", function(inst) inst.sg:GoToState("wake") end ),
			EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
        },
    },

    State
    {
        name = "wake",
        tags = { "busy", "waking", "nosleep" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("sleep_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) 
				if inst.sg.mem.wants_to_cheer then
					--print("DEBUG: Waking up to cheer!")
					inst.sg:GoToState("cheer_pre")
				else
					inst.sg:GoToState("idle")
				end
			end),
        },
    },
	
	State
    {
        name = "run_start",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
        	inst.Transform:SetSixFaced()
        	--if inst.components.combat.target and inst.components.combat.target:IsValid()
        	--	and inst:CanDash()
        	--	and inst:GetDistanceSqToInst(inst.components.combat.target) > 3*3 then
        	--	inst.sg:GoToState('dash_taunt') --冲刺得条件满足这个的话就冲刺？？有意思 
        	--else
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("run_pre")
			--end
        end,
		
        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("run") end ),
        },
		
		onexit = function(inst)
			inst.Transform:SetSixFaced()
        end,
    },
	
	State
    {
        name = "run",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
			inst.Transform:SetEightFaced()
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("run_loop")
        end,
		
		timeline = {

			TimeEvent(9*FRAMES, PlayFootstep),
			TimeEvent(9*FRAMES, FootShake),
			TimeEvent(18*FRAMES, PlayFootstep),
			TimeEvent(18*FRAMES, FootShake),
		},
		
        events= {
			EventHandler("animqueueover", function(inst) 
				inst.sg:GoToState("run")  
			end),
		},
		onexit = function(inst)
			inst.Transform:SetSixFaced()
        end,
    },
	
	State
    {
        name = "newstate",
        tags = { "busy"},

        onenter = function(inst,state)
			inst.components.combat:DropTarget()
			inst:SetStage(state or 1)
			inst.Transform:SetSixFaced()
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("chest_bump")
			inst.sg.statemem.state = state
			inst.components.health:SetInvincible(true)
        end,	
		timeline = {
			TimeEvent(0.6, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/cheer") end),
		},

        events= {
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle")  
			end),
		},
			
		onexit = function(inst)
			--inst:SetStage(inst.sg.statemem.state or 1)
			inst.Transform:SetSixFaced()
			inst.components.health:SetInvincible(false)
        end,
    },

	State
    {
        name = "run_stop",
        tags = { "idle" },

        onenter = function(inst)
        	inst.Transform:SetSixFaced()
            inst.components.locomotor:StopMoving()
            if inst.AnimState:IsCurrentAnimation('attack2_loop') then
            	inst.AnimState:PlayAnimation('attack2_pst')
            else
				inst.AnimState:PlayAnimation("run_pst")
			end           
        end,
		
		timeline = {

			TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/forge2/rhino_drill/grunt") end),
		},

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

    State{
        name = "frozen",
        tags = {"busy", "frozen"},
        
        onenter = function(inst)
        	--inst.Transform:SetTwoFaced()
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("fossilized")
            inst.AnimState:SetTime(2)
            inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
        end,
        
        onexit = function(inst)
        	inst.AnimState:SetSixFaced()
        	if not inst.sg.statemem.thaw then
        		if inst.icefx then inst.icefx:Remove() inst.icefx = nil end
        	end
        end,
        
        events=
        {   
            EventHandler("onthaw", function(inst)inst.sg.statemem.thaw = true; inst.sg:GoToState("thaw") end ),
        },
    },

    State{
        name = "thaw",
        tags = {"busy", "thawing"},
        
        onenter = function(inst) 
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
            
            if not inst.icefx then
            	inst.icefx = MK_MOD_UTIL.MakeFxAt(Point(0,0,0), 'myth_frozen', 'myth_frozen',
            	'rhino3', nil, function(inst) 
            		inst.Transform:SetRotation(180)
            		inst.Transform:SetTwoFaced()
            		inst.AnimState:SetLayer(LAYER_BACKGROUND) 
            		inst.AnimState:SetScale(3.2, 2.8 ,1)
            		inst.AnimState:SetAddColour(1,1,1,0.5)
            	end)
            	inst.icefx.entity:SetParent(inst.entity)
            end
        end,
        
        onexit = function(inst)
            inst.SoundEmitter:KillSound("thawing")
            if inst.icefx then inst.icefx:Remove() inst.icefx = nil end
        end,

        events =
        {   
            EventHandler("unfreeze", function(inst)
                inst.sg:GoToState("hit")
            end ),
        },
    },
}
    
return StateGraph("rhino3", states, events, "pose", actionhandlers)

