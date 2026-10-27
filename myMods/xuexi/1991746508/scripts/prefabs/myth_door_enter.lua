local assets =
{
    Asset("ANIM", "anim/myth_stonedoor.zip"),
}

local function OnFocusCamera(inst)
	--nothing
end
local function OnDoneTeleporting(inst, obj)
    if obj ~= nil and obj.Transform  then
		if obj:HasTag("player") then
			OnFocusCamera(obj)
		end
		local pos = obj:GetPosition()
		local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 2, 10)
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

local function onbuilt(inst)

	if not  TheWorld.components.mythhouse  or TheWorld.components.mythhouse:IsMax()then
		return
	end
	
	local x,z = TheWorld.components.mythhouse:GetPosition()
	
	local removeents = TheSim:FindEntities(x, 0, z, 15)
	for i,v in ipairs(removeents) do
		v:Remove()
	end

	local myth_house =  SpawnPrefab("myth_house1")
	myth_house.Transform:SetPosition(x, 0, z)

	local exit = SpawnPrefab("myth_door_exit_1")
	exit.Transform:SetPosition(x+4.3, 0, z)
	
	local floor = SpawnPrefab("myth_floor_1")
	floor.Transform:SetPosition(x-5.8, 0, z)
	
	local wallpaper = SpawnPrefab("myth_wallpaper_1")
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
	
	local myth_wall_decals1 = SpawnPrefab("myth_wall_decals1")
	myth_wall_decals1.Transform:SetPosition(x+5, 0, z-6.6)
	local myth_wall_decals2 = SpawnPrefab("myth_wall_decals1")
	myth_wall_decals2.Transform:SetPosition(x+5, 0, z+6.6)
	myth_wall_decals2.AnimState:SetScale(-1,1,1)
	myth_wall_decals2.eastside = true
	
	local myth_wall_decals3 = SpawnPrefab("myth_wall_decals1_in")
	myth_wall_decals3.Transform:SetPosition(x-5.5, 0, z-6.2)
	
	local myth_wall_decals4 = SpawnPrefab("myth_wall_decals1_in")
	myth_wall_decals4.Transform:SetPosition(x-5.5, 0, z+6.2)
	myth_wall_decals4.AnimState:SetScale(-1,1,1)
	myth_wall_decals4.eastside = true
	
	local bed = SpawnPrefab("myth_interiors_bed")
	bed.Transform:SetPosition(x-3.59, 0, z-4.98)

	local xl = SpawnPrefab("myth_interiors_xl")
	xl.Transform:SetPosition(x+3.14, 0, z-5.25)

	local zz = SpawnPrefab("myth_interiors_zz")
	zz.Transform:SetPosition(x-3.66, 0, z+0.14)	

	local gz = SpawnPrefab("myth_interiors_gz")
	gz.Transform:SetPosition(x-4.2, 0, z+4.23)	
	
	local pf = SpawnPrefab("myth_interiors_pf")
	pf.Transform:SetPosition(x+2.94, 0, z+3.86)	

	local gh = SpawnPrefab("myth_interiors_gh")
	gh.Transform:SetPosition(x-5.5, 0, z+0.32)

	local gh_small = SpawnPrefab("myth_interiors_gh_small")
	gh_small.Transform:SetPosition(x-3.76, 0, z+7.12)
	
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

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("myth_stonedoor")
    inst.AnimState:SetBuild("myth_stonedoor")
    inst.AnimState:PlayAnimation("door")

	inst.Transform:SetScale(1.73, 1.73, 1.73)
	
	inst:AddTag("myth_door")
	inst:AddTag("shelter")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("nonpackable")
	
	inst.GetIsWet = function(...) return false end
	
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
	inst.OnBuildRoom = onbuilt
    return inst
end
--DebugSpawn"myth_door_enter":OnBuildRoom()
return Prefab("myth_door_enter", Fn, assets, nil)
