TUNING = GLOBAL.TUNING
FindWalkableOffset = GLOBAL.FindWalkableOffset
require = GLOBAL.require
SpawnPrefab = GLOBAL.SpawnPrefab
RemovePhysicsColliders = GLOBAL.RemovePhysicsColliders
debug = GLOBAL.debug
AllPlayers = GLOBAL.AllPlayers
COLLISION = GLOBAL.COLLISION
PI = GLOBAL.PI

--龙蝇
TUNING.DRAGONFLY_FREEZE_THRESHOLD = 50--耐冻
TUNING.DRAGONFLY_ENRAGED_FREEZE_THRESHOLD = 100
TUNING.DRAGONFLY_ATTACK_PERIOD = 2.5--攻击频率
TUNING.DRAGONFLY_SPEED = 8--速度
TUNING.DRAGONFLY_FIRE_ATTACK_PERIOD = 1
TUNING.DRAGONFLY_FIRE_SPEED = 12
TUNING.DRAGONFLY_HEALTH = 27500 * 1.5
TUNING.DRAGONFLY_STUN = 2500
TUNING.DRAGONFLY_STUN_RESIST = 500
TUNING.DRAGONFLY_STUN_COOLDOWN = 480
TUNING.DRAGONFLY_STUN_DURATION = 3


-- 移除指定文件监听方法并返回原始Fn
local function RemoveEventCallbackEx(inst, event, filepath)
	local old_event_key, old_event = nil, nil

	-- 移除指定监听方法
	if inst.event_listeners ~= nil and inst.event_listeners[event] ~= nil and inst.event_listeners[event][inst] ~= nil then
		for i, fn in ipairs(inst.event_listeners[event][inst]) do
			local info = debug.getinfo(fn,"LnS")
			if string.find(info.source, filepath) then
				old_event_key = i
				old_event = fn
				break
			end
			
		end
	end

	if inst.event_listeners ~= nil and inst.event_listeners[event] ~= nil and inst.event_listeners[event][inst] ~= nil then
		inst:RemoveEventCallback(event, old_event)
	end

	return old_event
end

local function GetSpawnPoint(pt,radius)
    local theta = math.random() * 2 * PI

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end

local function teleport(inst,data)
	if inst.sg.stopped then--解除石化
		inst.sg:Start()
		inst.AnimState:SetMultColour(1,1,1,1)
	end
	if inst.brain and inst.brain.stopped then--解除石化
		inst.brain:Start()
	end
	local pt = inst:GetPosition()
	local newpoint = GetSpawnPoint(pt,15)
	SpawnPrefab("spawn_fx_medium").Transform:SetPosition(pt:Get())
	if newpoint then--不在海上战斗
		inst.Transform:SetPosition(newpoint:Get())
		SpawnPrefab("spawn_fx_medium").Transform:SetPosition(newpoint:Get())
		if math.random() <= .5 then
            local rushfx = SpawnPrefab("sand_puff")
            rushfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.sg:GoToState("onrush")
		else
			inst.sg:GoToState("walk")
		end
	else
		inst.sg:GoToState("flyaway")
	end
end

local function getdistance(inst1,inst2)
	local x1,y1,z1 = inst1.Transform:GetWorldPosition()
	local x2,y2,z2 = inst2.Transform:GetWorldPosition()
	return math.sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2) + (z1-z2) * (z1-z2))
end

local function OnHealthTrigger1(inst)
	inst.angerlv = 1
	inst:PushEvent("transform", { transformstate = "fire" })
end

local function OnHealthTrigger2(inst)
	inst.angerlv = 2
	inst:PushEvent("transform", { transformstate = "fire" })
end

local function OnHealthTrigger3(inst)
	inst.angerlv = 3
	inst:PushEvent("transform", { transformstate = "fire" })
end

AddPrefabPostInit("dragonfly",function(inst)
--基础数据增加
    inst.components.combat:SetAreaDamage(6, 1)--aoe伤害
	inst.components.sleeper:SetResistance(95)--耐睡觉

    inst.components.damagetracker.enabled = true--降低刷皮难度
	
    inst:AddComponent("flash")--闪现技能
    inst.components.flash.flash_threshold = 300
    inst.components.flash.flash_period = 1
    inst.components.flash.flash_cooldown = 10
	inst:ListenForEvent("flash", teleport)
	
	
	inst:AddTag("immunetoexplode")--需要同时配合爆炸组件才能使蜻蜓防炸
	
	inst.lr_resettime = 120
	
	RemovePhysicsColliders(inst)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	inst.angerlv = 0

	inst._ontargetdeath = nil

	--不再吐虫子，血量低于一定程度暴怒
	RemoveEventCallbackEx(inst, "rampingspawner_spawn", "scripts/prefabs/dragonfly.lua")
	RemoveEventCallbackEx(inst, "rampingspawner_death", "scripts/prefabs/dragonfly.lua")
	inst:RemoveComponent("rampingspawner")
	inst.components.rampingspawner = {}
	inst.components.rampingspawner.spawns = {}
	
	inst.components.healthtrigger.triggers = {}
	inst.components.healthtrigger:AddTrigger(math.random(75,85)/100, OnHealthTrigger1)
    inst.components.healthtrigger:AddTrigger(math.random(45,55)/100, OnHealthTrigger2)
    inst.components.healthtrigger:AddTrigger(math.random(20,30)/100, OnHealthTrigger3)
	
	inst:ListenForEvent("attacked",function(inst,data)
		inst.lr_resettime = 120
		if inst.lr_resettask == nil then
			inst.lr_resettask = inst:DoPeriodicTask(1,function()--120s没有进行任何攻击则重置
			inst.lr_resettime = inst.lr_resettime - 1 
			if inst.lr_resettime <= 0 then
				inst.lr_resettime = 120
				inst.lr_resettask:Cancel()
				inst.lr_resettask = nil
				inst.sg:GoToState("flyaway")
			end
			end)
		end
		if inst.angerlv and inst.angerlv > 0 and not inst.enraged then
			inst:PushEvent("transform", { transformstate = "fire" })
		end
	end)
	
	
	inst:ListenForEvent("transform",function(inst,data)--不同暴怒等级属性不同
		if data.transformstate == "normal" then
			inst.AnimState:SetMultColour(1,1,1,1)
			inst.components.locomotor.walkspeed = TUNING.DRAGONFLY_SPEED
			inst.components.combat:SetDefaultDamage(TUNING.DRAGONFLY_DAMAGE)
			inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_ATTACK_PERIOD)
		end
		if data.transformstate == "fire" then
			inst.AnimState:SetBuild("dragonfly_fire_build")
			inst.enraged = true
			inst.can_ground_pound = true

			inst.Light:Enable(true)
			inst.components.propagator:StartSpreading()

			inst.components.moisture:DoDelta(-inst.components.moisture:GetMoisture())

			inst.components.freezable:SetResistance(TUNING.DRAGONFLY_ENRAGED_FREEZE_THRESHOLD)
			if inst.angerlv == 1 then
				inst.AnimState:SetMultColour(1,1,1,1)
				inst.components.combat:SetAreaDamage(8, 1.3)
				inst.components.groundpounder.numRings = 2
				inst.components.groundpounder.pointDensity = .25
				inst.components.groundpounder.damageRings = 2
				inst.components.groundpounder.destructionRings = 3
				inst.components.groundpounder.groundpounddamagemult = 0.5
				inst.components.locomotor.walkspeed = TUNING.DRAGONFLY_FIRE_SPEED
				inst.components.combat:SetDefaultDamage(TUNING.DRAGONFLY_DAMAGE * 2)
				inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_FIRE_ATTACK_PERIOD)			
			elseif inst.angerlv == 2 then
				inst.components.combat:SetAreaDamage(10, 1.5)
				inst.components.groundpounder.numRings = 3
				inst.components.groundpounder.pointDensity = .40
				inst.components.groundpounder.damageRings = 2
				inst.components.groundpounder.destructionRings = 3
				inst.components.groundpounder.groundpounddamagemult = 0.75
				if inst.components.sanityaura == nil then
					inst:AddComponent("sanityaura")
				end
				inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
				inst.AnimState:SetMultColour(0/255,0/255,230/255,1)--蓝色
				inst.components.locomotor.walkspeed = TUNING.DRAGONFLY_FIRE_SPEED * 1.25
				inst.components.combat:SetDefaultDamage(TUNING.DRAGONFLY_DAMAGE * 3)
				inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_FIRE_ATTACK_PERIOD)		
			elseif inst.angerlv == 3 then
				inst.components.combat:SetAreaDamage(12, 2)
				inst.components.groundpounder.numRings = 4
				inst.components.groundpounder.pointDensity = .70
				inst.components.groundpounder.damageRings = 3
				inst.components.groundpounder.destructionRings = 4
				inst.components.groundpounder.groundpounddamagemult = 1
				if inst.components.sanityaura == nil then
					inst:AddComponent("sanityaura")
				end
				inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE*2
				inst.AnimState:SetMultColour(125/255,0,255/255,1)--紫色
				inst.melttask = inst:DoPeriodicTask(1,function()
					local spell = SpawnPrefab("deer_fire_circle")
					local x,y,z = inst.Transform:GetWorldPosition()
					spell.Transform:SetScale(1.5,1.5,1.5)
					spell.Transform:SetPosition(x, 0, z)
					spell:DoTaskInTime(4, spell.KillFX)
				end)
				inst.components.locomotor.walkspeed = TUNING.DRAGONFLY_FIRE_SPEED * 1.5
				inst.components.combat:SetDefaultDamage(TUNING.DRAGONFLY_DAMAGE * 4)
				inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_FIRE_ATTACK_PERIOD * .5)		
			end
		end
	end)

	inst.components.lootdropper.loot = {}
	for i = 1, math.random(16,24) do table.insert(inst.components.lootdropper.loot,"greengem") end
	inst.continuepoundernum = 0
	inst.health_oldname = "愤怒的蜻蜓α测试版"
	
	inst:DoPeriodicTask(.5,function()--无目标时主动攻击周围50码内玩家
		if inst.components.combat.target == nil and type(AllPlayers) == "table" then
			for i,v in pairs(AllPlayers) do
				local x1,y1,z1 = inst.Transform:GetWorldPosition()
				local x2,y2,z2 = v.Transform:GetWorldPosition()
				if math.sqrt((x1-x2) * (x1-x2) + (z1-z2) * (z1-z2)) <=50 and not inst.sg:HasStateTag("flight") then
					inst.components.combat.target = v
				end
			end
		end
	end)
	
    inst:SetStateGraph("SGdragonfly")
    inst:SetBrain(require("brains/dragonflybrain"))

end)

AddComponentPostInit("combat",function(self,inst)--官方函数补正
function self:StopTrackingTarget(target)
	if self.losetargetcallback then
		self.inst:RemoveEventCallback("enterlimbo", self.losetargetcallback, target)
		self.inst:RemoveEventCallback("onremove", self.losetargetcallback, target)
	end
end
end)











