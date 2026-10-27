require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.HAMMER, "attack"),
	ActionHandler(ACTIONS.GOHOME, "taunt"),
}

local SHAKE_DIST = 40

local function DeerclopsFootstep(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 2, inst, SHAKE_DIST)
end

----普通冰冻攻击
local function SpawnIceFx(inst, target)
    if not inst or not target then return end
    local numFX = math.random(20,30)
    local pos = inst:GetPosition()
    local targetPos = target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())		--GetAngleToPoint获取的是角度制
	
	----120度扇形
    for i = 1, numFX do
        inst:DoTaskInTime(math.random() * 0.25, function(inst)
            --local prefab = "icespike_fx_"..math.random(1,4)
			local prefab = "icespike_fx_1"
            local fx = SpawnPrefab(prefab)
            if fx then
                --local x = GetRandomWithVariance(-1, 3)
                --local z = GetRandomWithVariance(-1, 3)
                --local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x,0,z)
				--if i ~= 1 then
				--	fx.sound = " "
				--	fx.sound2 = " "
				--end
				--fx.sound = nil
				
				local fx_angle = math.random(angle-60, angle+60)*DEGREES		--用于三角函数要换成弧度制
				local fx_r = math.random(0, 8)
				local offset = Vector3( fx_r * math.cos(fx_angle), 0, -fx_r * math.sin(fx_angle) )
				local pt = pos+offset
                fx.Transform:SetPosition(pt:Get())
				fx.Transform:SetScale(1,3,1)
				
					
				----冰柱伤害
				local r = 1.33
				local center_dmg = 60 
				local ceter_destory = 2
				--local center_cold = 10
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss", "zg_marine"})
				for k,v in pairs(ents) do
					if v and v.components.health and not v.components.health:IsDead() and v ~= inst and v.prefab ~= inst.prefab then
						
						local dst = pt:Dist(v:GetPosition())
						local dmg_mult = 1 - dst/r
						
						if v.components.combat and not v:HasTag("zg_marine") then
							v.components.combat:Zg_GetAttacked(inst, center_dmg, nil, "zg_ele_ice")
							
							--if fx.SoundEmitter then
							--	fx.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/ice_small")
							--end
							
						end
						
						--if v.components.freezable and not v:HasTag("zg_marine") then
						--	v.components.freezable:AddColdness(.5 * dmg_mult)
						--	v.components.freezable:SpawnShatterFX()
						--end
						
						--if v.components.temperature then
						--	v.components.temperature:DoDelta(-center_dmg * dmg_mult)
						--end
						
						
					end
					
					if v and v:IsValid() and v.components.workable and v.components.workable:CanBeWorked() then
						--v.components.workable:Destroy(inst)
						local dst = pt:Dist(v:GetPosition())
						local dmg_mult = 1 - dst/r
						v.components.workable:WorkedBy(inst, ceter_destory * dmg_mult)
						
						--if fx.SoundEmitter then
						--	fx.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/ice_small")
						--end
					end
				end
					
			end
        end)
    end
end

----冰冻时代大招第一级
local function SpawnIceTime(inst, target)
	if not inst or not target then return end
	local numFX = math.random(160,170)
    local pos = inst:GetPosition()
    local targetPos = target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())

	----分多段, 36度扇形
	for j = 0, 4 do
		inst:DoTaskInTime(1+1*j, function()
			--inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe") 
			ShakeAllCameras(CAMERASHAKE.FULL, .5, .05, 2, inst, SHAKE_DIST)
		end)
			
		for i = 1, math.floor(numFX/5 * ((4-j)*0.2+1) ) do
			inst:DoTaskInTime( 0.25 + math.random() * 0.75 + 1*j, function(inst)
				
				local prefab = "icespike_fx_3"
				local fx = SpawnPrefab(prefab)
				if fx then
					--if i ~= 1 or j == 1 or j == 3 then
					--	fx.sound = " "
					--	fx.sound2 = " "
					--end
					--fx.sound = nil
					
					local fx_angle = math.random(angle-18, angle+18)*DEGREES
					local fx_r = math.random(0, 6)+6*j
					local offset = Vector3( fx_r * math.cos(fx_angle), 0, -fx_r * math.sin(fx_angle) ) 
					local pt = pos+offset
					fx.Transform:SetPosition(pt:Get())
					fx.Transform:SetScale(1.6,3 + 0.5*j,1.6)
					
					----冰柱伤害
					local r = 1.33
					local center_dmg = (120 - 60/18 * fx_r) * 2
					local ceter_destory = 2
					--local center_cold = 10
					local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO","shadow", "shadowboss", "zg_marine"})
					for k,v in pairs(ents) do
						if v and v.components.health and not v.components.health:IsDead() and v ~= inst and v.prefab ~= inst.prefab then
							
							local dst = pt:Dist(v:GetPosition())
							local dmg_mult = 1 - dst/r
							
							if v.components.combat and not v:HasTag("zg_marine") then
								v.components.combat:Zg_GetAttacked(inst, center_dmg, nil, "zg_ele_ice")
													
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

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    
	EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() then
		
			
			if not (inst.canicetime or inst.components.timer:TimerExists("icetime")) then
				inst.components.timer:StartTimer("icetime", 15)
			end
			if not (inst.canlaser or inst.components.timer:TimerExists("laser")) then
				inst.components.timer:StartTimer("laser", 10)
			end
			
			if inst.canlaser then
				inst.sg:GoToState("laser")
			elseif inst.canicetime then
				inst.sg:GoToState("icetime")
			else
				inst.sg:GoToState("atk")
			end
			
			
        end
    end),
	EventHandler("attacked", function(inst, data)
	end),
	
    CommonHandlers.OnDeath(),
}

local states=
{
	
	State{
        name = "icetime",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") 
				--inst.SoundEmitter:PlaySound("zg_laser/zg_laser/magic_pre")
			end),
            TimeEvent(16*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") 
				SpawnIceTime(inst, inst.components.combat.target) 
				
				inst.canicetime = false
				if not inst.components.timer:TimerExists("icetime") then
					inst.components.timer:StartTimer("icetime", 15)
				end
				
			end),	
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "laser",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
           --- inst.AnimState:PlayAnimation("laser")
			inst.AnimState:PlayAnimation("idle_loop", true)
			---inst.AnimState:PlayAnimation("atk")
			
			inst.components.health.absorb = .9
			inst.Light:Enable(true)
			
			inst.sg:SetTimeout(150*FRAMES)
        end,
        
        timeline=
        {
            --TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
			TimeEvent(50*FRAMES, function(inst)
			
				----选定位置,3秒内不再瞄准
				if inst.components.combat.target then
					inst.sg.statemem.laser_pos = inst.components.combat.target:GetPosition()
					inst.Transform:SetRotation( inst:GetAngleToPoint( inst.sg.statemem.laser_pos:Get() ) )
					
					--特效
					local fx = SpawnPrefab("sporebomb")
					if fx then
						fx.Transform:SetScale(8,8,8)
						fx.Transform:SetPosition(inst.sg.statemem.laser_pos:Get())
						
						fx:DoTaskInTime(3, fx.Remove)
						
						
					end
					
				end
				
			end),
			
            TimeEvent(140*FRAMES, function(inst) 
			
				----激光炮攻击
				if inst.sg.statemem.laser_pos then
					local pt = inst.sg.statemem.laser_pos
					
					--特效
					local fx = SpawnPrefab("explode_small")
					if fx then
						fx.Transform:SetScale(8,8,8)
						fx.Transform:SetPosition(pt:Get())
					end
					
					--计算
					local center_dmg = 900
					local ceter_destory = 4
					local r = 12
					local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, r, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "shadow", "shadowboss", "zg_marine"})
					for k,v in pairs(ents) do
						if v and v.components.health and not v.components.health:IsDead() and v ~= inst and v.prefab ~= inst.prefab then
							
							local dst = pt:Dist(v:GetPosition())
							local dmg_mult = 1 - dst/r
							
							
							if v.components.combat then
								v.components.combat:Zg_GetAttacked(inst, center_dmg * dmg_mult, nil, "zg_ele_ray")
							end
							
						end
						
						if v and v:IsValid() and v.components.workable and v.components.workable:CanBeWorked() then
							local dst = pt:Dist(v:GetPosition())
							local dmg_mult = 1 - dst/r
							v.components.workable:WorkedBy(inst, ceter_destory * dmg_mult)
						end
					end
					
				end
				
				inst.canlaser = false
				if not inst.components.timer:TimerExists("laser") then
					inst.components.timer:StartTimer("laser", 10)
				end
				inst.components.combat:SetRange(5.5, 5.5)
				
				inst.Light:Enable(false)
			end),	
			
        },
        		
		ontimeout = function(inst)
			inst.sg:GoToState("idle") 
		end,
		
		onexit = function(inst)
			inst.components.health.absorb = 0
			inst.Light:Enable(false)
		end
		
    },
	
	
	State
    {
        name = "atk",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("atk")
            inst.components.combat:StartAttack()
            inst.sg.statemem.target = target
			inst.sg:SetTimeout(38*FRAMES)
        end,

        timeline = 
		{
			TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
			TimeEvent(29*FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
			TimeEvent(35*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				ShakeAllCameras(CAMERASHAKE.FULL, .5, .05, 2, inst, SHAKE_DIST)
			end),
			TimeEvent(36*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
		},
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end

    },
	
	State
    {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("death")
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,

        timeline = 
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
		}
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



CommonStates.AddIdle(states)
CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {

    },
})

return StateGraph("zg_deerclops", states, events, "idle", actionhandlers)

