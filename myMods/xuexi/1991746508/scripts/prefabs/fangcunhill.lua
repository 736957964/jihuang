local assets =
{
    Asset("ANIM", "anim/fangcunhill.zip"),
}


local function OnSnowCoveredChagned(inst, covered)
    if TheWorld.state.issnowcovered then
		inst.AnimState:OverrideSymbol("snow", "fangcunhill", "snow")
	else
		inst.AnimState:OverrideSymbol("snow", "fangcunhill", "emptysnow")
	end
end

local function OnDoneTeleporting(inst, obj)
    if obj ~= nil and obj.Transform  then
		local pos = obj:GetPosition()
		local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 4, 10)
		if offset ~= nil then
			pos.x = pos.x + offset.x
			pos.z = pos.z + offset.z
		end
        if obj.Physics ~= nil then
            obj.Physics:Teleport(pos.x, pos.y, pos.z)
        elseif obj.Transform ~= nil then
            obj.Transform:SetPosition(pos.x, pos.y, pos.z)
		end
    end
end

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
    elseif inst.SoundEmitter ~= nil then
    end
end

local angles = {}
for k= -150,180,30 do
	table.insert(angles,k)
end

local function Get()
	local a = math.random(12)
	local b = math.random(12)
	while (b == a or b == a+3 or b == a-4) do
		b = math.random(12)
	end
	return a,b
end

local function onbuilt(inst,data)

	if not  TheWorld.components.mythhouse  or TheWorld.components.mythhouse:IsMax()then
		return
	end
	
	local x,z = TheWorld.components.mythhouse:GetPosition()
	
	local removeents = TheSim:FindEntities(x, 0, z, 15)
	for i,v in ipairs(removeents) do
		v:Remove()
	end
	local angle1,angle2 = Get()

	local myth_house =  SpawnPrefab("myth_house") --中心点
	myth_house.Transform:SetPosition(x, 0, z)
	local exit = SpawnPrefab("myth_door_exit")
	exit.Transform:SetPosition(x+7.1, 0, z)
	
	local myth_zodiac1 =  SpawnPrefab("myth_zodiac_1")
	myth_zodiac1.Transform:SetPosition(x+0.5, 0, z)
	myth_zodiac1.Transform:SetRotation(angles[angle1])

	local myth_zodiac2 =  SpawnPrefab("myth_zodiac_2")
	myth_zodiac2.Transform:SetPosition(x+0.5, 0, z)
	myth_zodiac2.Transform:SetRotation(angles[angle2])
	myth_zodiac1.huan = myth_zodiac2
	
	local myth_zodiac3 =  SpawnPrefab("myth_zodiac_3")
	myth_zodiac3.Transform:SetPosition(x+0.5, 0, z)
	myth_zodiac3.Transform:SetRotation(90)
	
	local floor = SpawnPrefab("myth_floor")
	floor.Transform:SetPosition(x-6.8, 0, z)

	local myth_stonedoor = SpawnPrefab("myth_stonedoor")
	myth_stonedoor.Transform:SetPosition(x-6.5, 0, z)
	
	local wallpaper = SpawnPrefab("myth_wallpaper")
	wallpaper.Transform:SetPosition(x, 0, z)
	
	exit.components.myth_teleporter:Target(inst)
	inst.components.myth_teleporter:Target(exit)

	local function addwall(x,z)
		local wall = SpawnPrefab("myth_wall") 
		if wall ~= nil then 
			wall.Physics:SetCollides(false)
			wall.Physics:Teleport(x, 0, z)
			wall.Physics:SetCollides(true)
		end			
	end
	--行1
	for b = -10, 10 do
		addwall(x-6.8,z+b)
	end

	--行2
	for b = -12, 11 do
		addwall(x + 8.3,z+b)
	end
	
	--列1
	local lie1 = 0
	for b = -6.2, 6.8 do
		addwall(x + b,z-11-lie1)
		lie1 = lie1+0.11 
	end
	
	local lie2 = 0
	for b = -6.2, 6.8 do
		addwall(x + b,z+11+lie2)
		lie2 = lie2+0.09 
	end	
	
	local myth_wall_decals1 = SpawnPrefab("myth_wall_decals")
	myth_wall_decals1.Transform:SetPosition(x+7.53, 0, z-12.07)
	local myth_wall_decals2 = SpawnPrefab("myth_wall_decals")
	myth_wall_decals2.Transform:SetPosition(x+7.53, 0, z+11.77)
	myth_wall_decals2.AnimState:SetScale(-1,1,1)
	myth_wall_decals2.eastside = true
	
	local deng1 = SpawnPrefab("myth_smalllight")
	deng1.Transform:SetPosition(x+6, 0, z-9.6)	
	local deng2 = SpawnPrefab("myth_smalllight")
	deng2.Transform:SetPosition(x+6, 0, z+9.6)	

	
	local myth_wall_decals3 = SpawnPrefab("myth_wall_decals_in")
	myth_wall_decals3.Transform:SetPosition(x-5.57, 0, z-10)
	
	local myth_wall_decals4 = SpawnPrefab("myth_wall_decals_in")
	myth_wall_decals4.Transform:SetPosition(x-5.57, 0, z+9.31)
	myth_wall_decals4.AnimState:SetScale(-1,1,1)
	myth_wall_decals4.eastside = true
	
	local deng3 = SpawnPrefab("myth_smalllight")
	deng3.Transform:SetPosition(x-4.5, 0, z-8.5)	
	local deng4 = SpawnPrefab("myth_smalllight")
	deng4.Transform:SetPosition(x-4.5, 0, z+8.1)
	
	
	inst.house = true
	TheWorld.components.mythhouse:BuildHouse()
end

local function cmythnsong(inst,x,y,z,kill)

	if inst.Transform ~= nil then
		inst.Transform:SetPosition(x,y,z)
	elseif inst.Physics ~= nil then
		inst.Physics:Teleport(x,y,z)
	end
	
	if kill then
		inst:DoTaskInTime(0.2,function(inst)
			if inst and inst:IsValid() and inst:HasTag("player") and inst.components.health ~= nil and not inst.components.health:IsDead() then
				inst.components.health:Kill()
			end
		end)
	end
end

local function onsave(inst,data)
	data.house = inst.house or nil
end

local function onload(inst,data)
	if data and data.house ~= nil then
		inst.house = data.house
	end
end

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()

    MakeObstaclePhysics(inst, 2.0)

    inst.MiniMapEntity:SetIcon("fangcunhill.tex")

    inst.AnimState:SetBank("fangcunhill")
    inst.AnimState:SetBuild("fangcunhill")
    inst.AnimState:PlayAnimation("anim")
    inst.AnimState:OverrideSymbol("snow", "fangcunhill", "emptysnow")

	inst.Transform:SetScale(1.35, 1.35, 1.35)
	
	inst:AddTag("myth_door")
	inst:AddTag("shelter")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("nonpackable")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("myth_teleporter")
    inst.components.myth_teleporter.onActivate = OnActivate
    inst.components.myth_teleporter.offset = 0
	inst.components.myth_teleporter.travelcameratime = 1
	inst.components.myth_teleporter.travelarrivetime = 0.5	
	
	inst:ListenForEvent("doneteleporting", OnDoneTeleporting)
	
    inst:WatchWorldState("issnowcovered", OnSnowCoveredChagned)
    OnSnowCoveredChagned(inst)
	inst:ListenForEvent("onremove", function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		if not x then
            for k,v in pairs(Ents) do
                if v:HasTag("multiplayer_portal") then
                x, y, z  = v.Transform:GetWorldPosition()
                end
            end			
		end
		if not x then 
			x, y, z  = 0,0,0
		end
		
		if inst.components.myth_teleporter and inst.components.myth_teleporter.targetTeleporter ~= nil then
			local target = inst.components.myth_teleporter.targetTeleporter
			local target_x, target_y, target_z = target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(target_x, 0, target_z, 20,nil,{"INLIMBO"})
			
			for i,v in ipairs(ents) do
				if v:HasTag("player") or  v:HasTag("irreplaceable") or v.components.health ~= nil then
					cmythnsong(v,x, y, z,true)
				elseif v.components.workable ~= nil then
					v.components.workable:Destroy(v)
				elseif v.components.perishable ~= nil then
					v.components.perishable:LongUpdate(10000)
				elseif v.components.finiteuses ~= nil then
					v.components.finiteuses:Use(10000)
				elseif v.components.fueled ~= nil then
					v.components.fueled:DoUpdate(10000)						
				end
			end
			TheWorld:DoTaskInTime(0.5,function(world)
				local ents2 = TheSim:FindEntities(target_x, 0, target_z, 20)
				for i,v in ipairs(ents2) do
					if v and v.components.inventoryitem ~= nil  then
						cmythnsong(v,x, y, z)
					else
						v:Remove()
					end
				end
			end)
		end
	end)
	inst:DoTaskInTime(0.2,function(inst)
		if not inst.house then
			onbuilt(inst)
		end
	end)
	inst.OnSave = onsave
	inst.OnLoad = onload
	
    return inst
end

return Prefab("fangcunhill", Fn, assets, nil)
