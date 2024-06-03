local assets =
{
    Asset("ANIM", "anim/myth_ghg.zip"),
}

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

local function onbuilt(inst,data)

	if not  TheWorld.components.mythhouse  or TheWorld.components.mythhouse:IsMax()then
		return
	end
	
	local x,z = TheWorld.components.mythhouse:GetPosition()
	
	local removeents = TheSim:FindEntities(x, 0, z, 15)
	for i,v in ipairs(removeents) do
		v:Remove()
	end

	local myth_house =  SpawnPrefab("myth_house1") --中心点
	myth_house.Transform:SetPosition(x, 0, z)
	local exit = SpawnPrefab("myth_door_exit_2")
	exit.Transform:SetPosition(x+5, 0, z+0.2)

	local change = SpawnPrefab("myth_chang_e")
	change.Transform:SetPosition(x-3.6, 0, z+0.1)

	local myth_chang_e_furniture = SpawnPrefab("myth_chang_e_furniture")
	myth_chang_e_furniture.Transform:SetPosition(x-3.6, 0, z-2.2)
	
	local floor = SpawnPrefab("myth_floor_1")
	floor.Transform:SetPosition(x-5.8, 0, z)
	floor:SetHouseWallSkin("myth_floorskin_ghg")
	
	local wallpaper = SpawnPrefab("myth_wallpaper_1")
	wallpaper.Transform:SetPosition(x, 0, z)
	wallpaper:SetHouseWallSkin("myth_wallskin_ghg")
	
	exit.components.myth_teleporter:Target(inst)
	inst.components.myth_teleporter:Target(exit)

	--DebugSpawn"myth_ghg"
	local function addwall(x,z)
		local wall = SpawnPrefab("myth_wall") 
		if wall ~= nil then 
			wall.Physics:SetCollides(false)
			wall.Physics:Teleport(x, 0, z)
			wall.Physics:SetCollides(true)
		end			
	end
	--行1
	for b = -8, 7 do
		addwall(x-6,z+b+0.5)
	end

	--行2
	for b = -8, 7 do
		addwall(x + 5+0.5,z+b+0.5)
	end
	--列1
	for b = -7, 6 do
		addwall(x + b+0.5,z-7)
	end
	
	for b = -7, 6 do
		addwall(x + b +0.5,z+7)
	end	
	
	local myth_wall_decals1 = SpawnPrefab("myth_wall_decals_ghg")
	myth_wall_decals1.Transform:SetPosition(x+5, 0, z-5.8)
	local myth_wall_decals2 = SpawnPrefab("myth_wall_decals_ghg")
	myth_wall_decals2.Transform:SetPosition(x+5, 0, z+5.8)
	myth_wall_decals2.AnimState:SetScale(-1,1,1)
	myth_wall_decals2.eastside = true	
	
	local lu = SpawnPrefab("myth_interiors_ghg_lu")
	lu.Transform:SetPosition(x+0.1, 0, z)
	
	local left = SpawnPrefab("myth_interiors_ghg_he_left")
	left.Transform:SetPosition(x+4.2, 0, z-3.38)

	local right = SpawnPrefab("myth_interiors_ghg_he_right")
	right.Transform:SetPosition(x+4.2, 0, z+3.3)
	
	local light = SpawnPrefab("myth_interiors_ghg_light")
	light.Transform:SetPosition(x-3.5, 0, z+4.5)

	local flower = SpawnPrefab("myth_interiors_ghg_flower")
	flower.Transform:SetPosition(x-3.5, 0, z-5.4)
	
	local pf = SpawnPrefab("myth_interiors_ghg_pf")
	pf.Transform:SetPosition(x-6, -0.4, z)	
	
	local myth_wall_decals3 = SpawnPrefab("myth_wall_decals_ghg_in")
	myth_wall_decals3.Transform:SetPosition(x-5.5, 0, z-5.8)
	
	local myth_wall_decals4 = SpawnPrefab("myth_wall_decals_ghg_in")
	myth_wall_decals4.Transform:SetPosition(x-5.5, 0, z+5.8)
	myth_wall_decals4.AnimState:SetScale(-1,1,1)
	myth_wall_decals4.eastside = true
	
	inst.house = true
	TheWorld.components.mythhouse:BuildHouse()
end

local function cmythnsong(inst,x,y,z,kill)
	if inst.Transform ~= nil then
		inst.Transform:SetPosition(x,y,z)
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

local function testfn(inst,doer)
	if doer and doer.prefab == "myth_yutu" then
		return true
	end
	return TheWorld.state.phase ~= "night"
end

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()

    MakeObstaclePhysics(inst, 2.0)

    inst.MiniMapEntity:SetIcon("myth_ghg.tex")

    inst.AnimState:SetBank("myth_ghg")
    inst.AnimState:SetBuild("myth_ghg")
    inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(1.35, 1.35, 1.35)
	
	inst:AddTag("myth_door")
	inst:AddTag("shelter")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("nonpackable")
	
	TUNING.MYTH_GHG = inst
	
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
	inst.components.myth_teleporter:SetTestFn(testfn)
	inst.components.myth_teleporter.banned = true
	inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

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

local function getcoordsstr(x,y)
	return x.."_"..y
end

local function addtile(inst)
	local x1,y1,z1 = inst.Transform:GetWorldPosition()
	
	local x, y = TheWorld.Map:GetTileCoordsAtPoint(x1,0,z1)
	local x0,y0
	for k1 = -21,21 do
		for k2 = -21,21 do
			x0 = x+k1
			y0 = y+k2
			TUNING.MYTH_GHG_TILE[getcoordsstr(x0,y0)] = true
		end
	end
end

local function TileFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst:AddTag("fx")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("nonpackable")
	
	inst:DoTaskInTime(0,addtile)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	return inst
end

return Prefab("myth_ghg", Fn, assets, nil),
	Prefab("myth_ghg_tile", TileFn)
