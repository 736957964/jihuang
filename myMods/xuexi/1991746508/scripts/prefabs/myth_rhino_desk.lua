local assets = {
	Asset("ANIM", 'anim/myth_rhino_desk.zip'),
}

local function _isvalid(desk, inst)
	if not (inst and inst:IsValid()) then
		return 
	end
	if not desk.peach and inst.prefab == 'peach' then
		return true
	end
	if not desk.light_on and inst.components.fuel and inst.components.fuel.fueltype == 'BURNABLE' then
		return true
	end
end
Myth_AddCachedStr(function()
STRINGS.CHARACTERS.MONKEY_KING.DESCRIBE.MYTH_RHINO_DESK = '这石头供桌什么来头？'
STRINGS.CHARACTERS.NEZA.DESCRIBE.MYTH_RHINO_DESK = '这桌子是供奉哪位仙长的？'
STRINGS.CHARACTERS.WHITE_BONE.MYTH_RHINO_DESK = '好呀，这倒也是一计~'
end)

local function OnLightDirty(inst)
	local on = inst._lighton:value()
	--print("Call > OnLightDirty")
	for i = 1, 4 do
		inst.AnimState:OverrideSymbol('fire'..i, "myth_rhino_desk", on and "fire4" or "empty")
		if on then
			local light = SpawnPrefab('myth_rhino_desk_light')
			local f = light.entity:AddFollower()
			f:FollowSymbol(inst.GUID, 'fire'..i, 0, 0, 0)
			inst.lightfx[i] = light
		else
			if inst.lightfx[i] and inst.lightfx[i]:IsValid() then
				inst.lightfx[i]:Remove()
				inst.lightfx[i] = nil
			end
		end
	end
end

local function LightOn(inst)
	if inst.light_on then return end

	inst.light_on = true
	inst._lighton:set_local(false)
	inst._lighton:set(true)
	if not inst.components.timer:TimerExists('light') then
		inst.components.timer:StartTimer('light', 180)
	end
end

local function LightOff(inst)
	if not inst.light_on then return end

	inst.light_on = false
	inst._lighton:set_local(true)
	inst._lighton:set(false)
end

local function AddPeach(inst)
	if not inst.peach then
		inst.peach = true
		inst.AnimState:OverrideSymbol('swap1', 'myth_rhino_desk', 'swap1')
		if not inst.components.timer:TimerExists('peach') then
			inst.components.timer:StartTimer('peach', 600)
		end
	end
end

local function RemovePeach(inst)
	inst.peach = false
	inst.AnimState:OverrideSymbol('swap1', 'a', 'b')
end

local function RhinoFn(inst)
	if not inst.peach or not inst.light_on then return end 
	if not (TheWorld.state.isspring and TheWorld.state.isnight) then return end
	local has = false
	for k in pairs(inst.rhinos)do
		if not k:IsValid() or k.components.health:IsDead() then
			inst.rhinos[k] = nil
		else
			has = true
		end
	end
	if has then return end

	if inst.components.timer:TimerExists('cd') then
		return
	else
		inst.components.timer:StartTimer('cd', 50*480)
		local rhino = SpawnPrefab('myth_rhino_come')
		rhino.Transform:SetPosition(inst.Transform:GetWorldPosition())
		rhino:SetTarget(inst)
	end
end

--local a = DebugSpawn"myth_rhino_desk" local b = DebugSpawn"myth_rhino_come"  b:SetTarget(a)

local function GetItem(inst, item)
	if _isvalid(inst, item) then
		if item.components.stackable then
			item = item.components.stackable:Get()
		end
		if item.prefab == 'peach' then
			AddPeach(inst)
		elseif item.components.fuel then
			LightOn(inst)
		end
		item:Remove()

		if inst.light_on and inst.peach then
			RhinoFn(inst)
		end
		return true
	end
	return false
end

local function OnRhinoDie(inst)
	for k in pairs(inst.rhinos)do
		if not k:IsValid() then
			inst.rhinos[k] = nil
		else
			if k:HasTag('mythTag_rhino') and not k.components.health:IsDead() then
				k:SetStage(k.stage + 1)
			end
		end
	end
end

local function OnSave(inst, data)
	data.light_on = inst.light_on
	data.peach = inst.peach
end

local function OnLoad(inst, data)
	if not data then return end
	if data.peach then AddPeach(inst) end
	if data.light_on then LightOn(inst) end
end

local function OnDay(inst)
	LightOff(inst)
	RemovePeach(inst)
end

local function OnTimerDone(inst, data)
	if data and data.name == 'peach' then
		RemovePeach(inst)
	end
	if data and data.name == 'light' then
		LightOff(inst)
	end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "myth_rhino_desk.tex" )
	inst.entity:AddNetwork()
	--
	MakeObstaclePhysics(inst, 1.2)
	trans:SetScale(1.2,1.2,1.2)

	anim:SetBank('myth_rhino_desk')
	anim:SetBuild('myth_rhino_desk')
	anim:PlayAnimation('idle')
	for i = 1, 4 do
		anim:OverrideSymbol('fire'..i, "myth_rhino_desk", "empty")
	end

	inst.lightfx = {}
	inst.rhinos = {}
	inst.peach = false
	inst.light_on = false
	
	inst._lighton = net_bool(inst.GUID, 'inst._lighton', 'lighton_dirty')
	inst._lighton:set_local(true)
	inst:ListenForEvent("lighton_dirty", OnLightDirty)
	
	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent('inspectable')

	inst:AddComponent('timer')

	inst:AddComponent('myth_rhino_team')

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnRhinoDie = OnRhinoDie

	LightOff(inst)
	RemovePeach(inst)

	inst:ListenForEvent('onremove', LightOff)
	inst:ListenForEvent('timerdone', OnTimerDone)

	inst:WatchWorldState('isday', OnDay)
	inst:WatchWorldState('isnight', RhinoFn)

	inst.GetItem = GetItem

	return inst
end

local function light()
	local inst = CreateEntity()
	--本地
	inst.persists = false
	inst:AddTag('FX')
	inst:AddTag('NOCLICK')

	local trans = inst.entity:AddTransform()
	trans:SetScale(0.3,0.3,0.3)

	local anim = inst.entity:AddAnimState()
	anim:SetBank('campfire_fire')
	anim:SetBuild('campfire_fire')
	anim:PlayAnimation('level1', true)
	anim:SetMultColour(1, 0.6, 1, 1)
	anim:SetLightOverride(1)
	anim:SetBloomEffectHandle( "shaders/anim.ksh" )
	anim:SetRayTestOnBB(true)
	anim:SetFinalOffset(-1)

	local light = inst.entity:AddLight()
	light:SetRadius(1)
	light:Enable(true)
	light:SetIntensity(.8)
	light:SetFalloff(.5)
	light:SetColour(200/255, 126/255, 30/255)

	return inst
end

return Prefab('myth_rhino_desk', fn, assets), Prefab('myth_rhino_desk_light', light, {Asset("ANIM", 'anim/campfire_fire.zip')})
