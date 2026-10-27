local assets =
{
    Asset("ANIM", "anim/myth_zodiac.zip"),
}

local function lightup(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, 0, z, 25,{"myth_smalllight"},{"INLIMBO"})
	for i,v in ipairs(ents) do
		if v then
			v:TurnOn()
		end
	end
end

local function lightdown(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, 0, z, 25,{"myth_smalllight"},{"INLIMBO"})
	for i,v in ipairs(ents) do
		if v then
			v:TurnOff()
		end
	end
end

local function shakeplayer(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, 0, z, 25,{"player"},{"INLIMBO"})
	for i,v in ipairs(ents) do
		v:ShakeCamera(CAMERASHAKE.FULL, 0.7, 0.02, 1,inst,25)
	end
end

local function kaimen(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, 0, z, 25,{"myth_stonedoor"},{"INLIMBO"})
	for i,v in ipairs(ents) do
		if v then
			local x1,y1,z1 = v.Transform:GetWorldPosition()
			v:Remove()
			local fx = SpawnPrefab("collapse_big")
			fx.Transform:SetPosition(x1+0.7,0,z1)
			local myth_door_enter = SpawnPrefab("myth_door_enter")
			myth_door_enter.Transform:SetPosition(x1+0.3, 0, z1)
			myth_door_enter:DoTaskInTime(0.5, function()
				myth_door_enter:OnBuildRoom()
			end)
			break
		end
	end
end

local function unlock(inst)
	inst.newnumatask = inst:DoPeriodicTask(0.3, shakeplayer,FRAMES)
	inst.components.myth_quaker:StartQuake()
	inst:DoTaskInTime(6, function()
		kaimen(inst)
		inst.unlock = true
		if inst.newnumatask ~= nil then
			inst.newnumatask:Cancel()
		end	
		inst.components.myth_quaker:StopQuake()
		if  inst.busy then
			inst.busy = false
		end
	end)
end

local function checklock(inst)
	if not inst.huan then
		return
	end
	local a = inst.Transform:GetRotation()
	local b = inst.huan.Transform:GetRotation()
	--print(a)
	--print(b)
	if math.abs(a - b) < 4 then 
		if not inst.unlock then
			unlock(inst)
		else
			if inst.busy then
				inst.busy = false	
			end
		end
		lightup(inst)
	else
		lightdown(inst)
		if inst.busy then
			inst.busy = false
		end
	end
end

local function RotationYue(inst,angle,rate)
	inst.busy = true
	inst.SoundEmitter:PlaySound("buttons/sfx/zhuan", "totem_sound")
	local a = 0
	local speed = 1
    inst.zhuan = inst:DoPeriodicTask(
        0,
        function()
            a = a + speed
			inst.Transform:SetRotation( inst.Transform:GetRotation() + speed*rate )
			if inst.huan ~= nil then
				inst.huan.Transform:SetRotation( inst.huan.Transform:GetRotation() - 2*speed*rate )			
			end
            if a >= angle  then	
				inst.SoundEmitter:KillSound("totem_sound")
				inst.zhuan:Cancel()
				if inst.huan ~= nil then
					checklock(inst)
				else
					inst.busy = false
				end
            end
        end
	)
end

local function RotationXing(inst,angle,rate)
	inst.busy = true
	inst.SoundEmitter:PlaySound("buttons/sfx/zhuan", "totem_sound")
	local a = 0
	local speed = 2
    inst.zhuan = inst:DoPeriodicTask(
        0,
        function()
            a = a + speed
			inst.Transform:SetRotation( inst.Transform:GetRotation() + speed*rate )
			if inst.huan ~= nil then
				inst.huan.Transform:SetRotation( inst.huan.Transform:GetRotation() - speed*rate )			
			end
            if a >= angle  then	
				inst.SoundEmitter:KillSound("totem_sound")
				inst.zhuan:Cancel()			
				if inst.huan ~= nil then
					checklock(inst)
				else
					inst.busy = false
				end
            end
        end
	)
end

local function onsave(inst, data)
    if inst.unlock then
        data.unlock = inst.unlock
    end
	
    local ents = {}
    if inst.huan ~= nil then
        data.huan_id = inst.huan.GUID
        table.insert(ents, data.huan_id)
    end

    return ents
end

local function onload(inst, data, newents)
    if data and data.unlock then
       inst.unlock =  data.unlock
	end
end

local function onloadpostpass(inst, newents, savedata)
    inst.huan = nil
    if savedata ~= nil then
        if savedata.huan_id ~= nil and newents[savedata.huan_id] ~= nil then
            inst.huan = newents[savedata.huan_id].entity
        end
    end
end

local function doors(name,idle,sort)
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetScale(1.25, 1.25, 1.6)

    inst.AnimState:SetBank("myth_zodiac")
    inst.AnimState:SetBuild("myth_zodiac")
    inst.AnimState:PlayAnimation(idle)
	
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(3)
    inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetFinalOffset( sort )
	
    inst:AddTag("fx")
	inst:AddTag(name)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	
	inst:AddComponent("savedrotation")
	inst.RotationYue = RotationYue
	inst.RotationXing = RotationXing
	if name == "myth_zodiac_1" then
		inst.unlock = false
		inst:DoTaskInTime(0.1, function()
			local x,y,z = inst.Transform:GetWorldPosition()
			local yue1 =  SpawnPrefab("myth_yue")
			yue1.Transform:SetPosition(x, 0, z+7.5)
			local yue2 = SpawnPrefab("myth_xing")
			yue2.Transform:SetPosition(x, 0, z-7.5)		
			yue1.huan = inst
			yue2.huan = inst
			checklock(inst)
		end)
		inst:AddComponent("myth_quaker")
		inst.CheckLock = checklock
		inst.OnSave = onsave
		inst.OnLoad = onload
		inst.OnLoadPostPass = onloadpostpass
	end
    return inst
end
	return Prefab(name, fn, assets)
end

return 
	doors("myth_zodiac_1","idle1",1),
	doors("myth_zodiac_2","idle2",2),
	doors("myth_zodiac_3","idle3",3)
