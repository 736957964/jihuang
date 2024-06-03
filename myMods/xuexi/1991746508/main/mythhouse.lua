TUNING.MYTH_GHG_TILE = {}
AddClassPostConstruct("cameras/followcamera", function(self)
	local Old_Apply = self.Apply
	function self:Apply()
		if self.inmythhouse == true and  self.mythhousepos ~= nil then
			self.headingtarget = 0
			local pitch = (self.samllhouse and 35 or 42.857142857143)* DEGREES
			local heading = 0 
			local distance = self.samllhouse and 23 or 30 
			local currentpos = Vector3(self.mythhousepos:Get())
			local fov = 35
			local currentscreenxoffset = 0
			local cos_pitch = math.cos(pitch)
			local cos_heading = math.cos(heading)
			local sin_heading = math.sin(heading)
			local dx = -cos_pitch * cos_heading
			local dy = -math.sin(pitch)
			local dz = -cos_pitch * sin_heading
			local xoffs, zoffs = 0, 0
			if self.shake ~= nil then		
				local shakeOffset = self.shake:Update(FRAMES)
				if shakeOffset ~= nil then
					local rightOffset = self:GetRightVec() * shakeOffset.x
					currentpos.x = currentpos.x + rightOffset.x
					currentpos.y = currentpos.y + rightOffset.y + shakeOffset.y
					currentpos.z = currentpos.z + rightOffset.z
				else
					self.shake = nil
				end
			end
			if currentscreenxoffset ~= 0 then
				local hoffs = 2 * currentscreenxoffset / RESOLUTION_Y
				local magic_number = 1.03
				local screen_heights = math.tan(fov * .5 * DEGREES) * distance * magic_number
				xoffs = -hoffs * sin_heading * screen_heights
				zoffs = hoffs * cos_heading * screen_heights
			end

			TheSim:SetCameraPos(
				currentpos.x - dx * distance + xoffs,
				currentpos.y - dy * distance,
				currentpos.z - dz * distance + zoffs
			)
			TheSim:SetCameraDir(dx, dy, dz)

			local right = (heading + 90) * DEGREES
			local rx = math.cos(right)
			local ry = 0
			local rz = math.sin(right)

			local ux = dy * rz - dz * ry
			local uy = dz * rx - dx * rz
			local uz = dx * ry - dy * rx

			TheSim:SetCameraUp(ux, uy, uz)
			TheSim:SetCameraFOV(fov)
			local listendist = -.1 * distance
			TheSim:SetListener(
				dx * listendist + currentpos.x,
				dy * listendist + currentpos.y,
				dz * listendist + currentpos.z,
				dx, dy, dz,
				ux, uy, uz
			)			
		else
			Old_Apply(self)
		end
	end
end)

local small = {myth_house1 = true}
local function OnFocalFocusDirty(inst)
	if ThePlayer ~= nil and inst == ThePlayer then
		if inst._inmythcamea:value() ~= nil then
			local ent = inst._inmythcamea:value()
			TheCamera.inmythhouse = true
			local x1,y1,z1 = ent.Transform:GetWorldPosition()
			if small[ent.prefab] then 
				TheCamera.samllhouse = true
			else
				TheCamera.samllhouse = false
			end
			TheCamera.mythhousepos  = Vector3(x1,1.5,z1)
		else
			TheCamera.inmythhouse = false
			TheCamera.mythhousepos = nil
			TheCamera.samllhouse = false
		end
		if inst.components.playervision then
			inst.components.playervision:UpdateCCTable()
		end
	end
end

--Load
local function OnFocusCamera(inst)
	if inst.spawnanddelete_myth then
		return
	end
	local ent = FindEntity(inst, 15, nil, {"myth_house"})
	if ent then 
		if inst._inmythcamea:value() ~= ent then 
			inst._inmythcamea:set(ent)
		end
	elseif inst._inmythcamea:value() ~= nil then
		inst._inmythcamea:set(nil)
	end
end
--
AddPlayerPostInit(function(inst)

	--这个net已弃用
	inst._inmythhouse = net_bool(inst.GUID, "_inmythhouse","inmythhousedirty")

	--房子的net
	inst._inmythcamea = net_entity(inst.GUID, "_inmythcamea","inmythcameadirty")
	
	--百宝囊
	inst._hasbbn = net_bool(inst.GUID, "_hasbbn","hasbbndirty")

	if not TheWorld:HasTag("cave") then
		inst:AddComponent("myth_ghg_weather")
	end
	
	if TheWorld.ismastersim then
		inst:AddComponent("myth_bbn_container")
		inst:AddComponent("myth_favorability")
		inst:DoPeriodicTask(0.2, OnFocusCamera,0.2)
	end
	
    if not TheNet:IsDedicated() then
		inst:ListenForEvent("inmythcameadirty", OnFocalFocusDirty)
    end
end)
--===============================================

local mythhouses ={ }
local function checkz(z)
	if  z and z >= -2050 and  z<= -1550 then
		return true
	end
	return false
end
--[[
for k,v in pairs(getmetatable(TheSim).__index) do print(k,v) end
]]

--限制制作的配方
local banrecipe = {"hua_player_house_recipe","homesign","townportal","telebase","hua_player_house1_recipe",
	"hua_player_house_pvz_recipe","hua_player_house_tardis_recipe"
}
for i,v in ipairs(banrecipe) do
	local recipe =  AllRecipes[v]
	if recipe  then
		local old = recipe.testfn or nil
		recipe.testfn = function(pt, rot,...)
			if pt.z >= -2050 and pt.z <= -1550 then
				return false
			end
			if old ~= nil then
				return old(pt, rot,...)
			end
			return true
		end
	end
end
	
AddPrefabPostInit("world", function(inst)
	local map = getmetatable(inst.Map).__index
	if map then
		map.CreatMythHouse = function(self,x,z,house,size)
			mythhouses[house] = {x,z,size}
		end
		map.RemoveMythHouse = function(self,house)
			if mythhouses[house] ~= nil then
				mythhouses[house] = nil
			end
		end
		local old_IsAboveGroundAtPoint =	map.IsAboveGroundAtPoint
		map.IsAboveGroundAtPoint = function(self, x, y, z,...)
			if checkz(z) then
				for k,v in pairs(mythhouses) do
					if v[3] ~= nil then
						if z >= v[2]-6.5 and z <= v[2]+6.5 and x >= v[1]-5.5 and  x <= v[1]+5 then
							return true
						end
					else
						if v and z >= v[2]-12 and z <= v[2]+12 and x >= v[1]-8 and  x <= v[1]+8 then	
							if  TheSim:WorldPointInPoly(x, z, { {v[1]-6.2,v[2]+10},{v[1]-6.2,v[2]-10.6},{v[1]+7.8,v[2]-12},{v[1]+7.8,v[2]+12} }) then 		
								return true
							end
						end
					end
				end
			end
			return old_IsAboveGroundAtPoint(self, x, y, z,...)
		end
	
		local old_IsVisualGroundAtPoint =	map.IsVisualGroundAtPoint
		map.IsVisualGroundAtPoint = function(self, x, y, z,...)
			if checkz(z) then
				for k,v in pairs(mythhouses) do
					if v[3] ~= nil then
						if z >= v[2]-6.5 and z <= v[2]+6.5 and x >= v[1]-5.5 and  x <= v[1]+5 then
							return true
						end
					else
						if v and z >= v[2]-12 and z <= v[2]+12 and x >= v[1]-8 and  x <= v[1]+8 then	
							if  TheSim:WorldPointInPoly(x, z, { {v[1]-6.2,v[2]+10},{v[1]-6.2,v[2]-10.6},{v[1]+7.8,v[2]-12},{v[1]+7.8,v[2]+12} }) then 		
								return true
							end
						end
					end
				end
			end
			return old_IsVisualGroundAtPoint(self, x, y, z,...)
		end
		
		local old_GetTileCenterPoint =	map.GetTileCenterPoint
		map.GetTileCenterPoint= function(self, x, y, z)
			if z and  z > -2100 and  z <= -1500 then
				return math.floor(x/4)*4+ 2,0,math.floor(z/4)*4 + 2
			end
			if z then
				return old_GetTileCenterPoint(self, x,y,z)
			else
				return old_GetTileCenterPoint(self, x,y)
			end
		end
	end

	if not TheWorld.ismastersim then
		return
	end
	inst:AddComponent("mythhouse")
	inst:ListenForEvent("ms_playerdespawnanddelete", function(inst,player)
		if player and player._inmythcamea then
			player.spawnanddelete_myth = true
			player._inmythcamea:set(nil)
		end
	end)
end)
local upvaluehelper = require "components/myth_upvaluehelper"

local find_rhino_sound = false
AddComponentPostInit("dynamicmusic", function(self)
	local oldplayeractivated = upvaluehelper.GetEventHandle(self.inst,"playeractivated","components/dynamicmusic")
	if oldplayeractivated ~= nil then
		local TRIGGERED_DANGER_MUSIC = upvaluehelper.Get(oldplayeractivated,"TRIGGERED_DANGER_MUSIC",nil,nil,nil,nil,"table")
		if TRIGGERED_DANGER_MUSIC and not find_rhino_sound then
			TRIGGERED_DANGER_MUSIC.myth_rhino3_boss = {"mythsound_rhino/mythsound_rhino/rhino_battle"}
			find_rhino_sound = true
		end
	end
end)

local actions = upvaluehelper.Get(EntityScript.CollectActions,"COMPONENT_ACTIONS")
if  actions and  actions.SCENE then
	local old = actions.SCENE.trophyscale
	actions.SCENE.trophyscale = function(inst, doer, actions, right)
		old(inst, doer, actions, right)
		if right and (doer.replica.inventory ~= nil and doer:HasTag("movemountain_pill_buff")) and
			not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
			if inst:HasTag("trophyscale_oversizedveggies") and doer.replica.inventory:EquipHasTag("weighable_oversizedveggies") then
				table.insert(actions, ACTIONS.COMPARE_WEIGHABLE)
			end 
		end
	end
	local oldre = actions.SCENE.repairable
	actions.SCENE.repairable = function(inst, doer, actions, right)
		oldre(inst, doer, actions, right)
		if right and doer:HasTag("movemountain_pill_buff") and
			doer.replica.inventory ~= nil and
			not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
			local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			if item ~= nil then
				if (inst:HasTag("repairable_sculpture") and item:HasTag("work_sculpture"))
						or (inst:HasTag("repairable_moon_altar") and item:HasTag("work_moon_altar")) then
					table.insert(actions, ACTIONS.REPAIR)
				end
			end
		end
	end
end

local old_REPAIR = ACTIONS.REPAIR.fn
ACTIONS.REPAIR.fn = function(act)
	if act.doer and act.doer:HasTag("movemountain_pill_buff") then
    	if act.target ~= nil and act.target.components.repairable ~= nil and (act.target:HasTag("repairable_sculpture") or act.target:HasTag("repairable_moon_altar")) and
			act.doer.components.inventory ~= nil  and
			act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil and
			not (act.doer.components.rider ~= nil and
				act.doer.components.rider:IsRiding()) then
			material = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        else
            material = act.invobject
		end
        if material ~= nil and material.components.repairer ~= nil then
            return act.target.components.repairable:Repair(act.doer, material)
        end
    end
	return old_REPAIR(act)
end

local function getcoordsstr(x,y)
	return x.."_"..y
end

AddPrefabPostInit("dirtpile", function(inst)
	if TheWorld.ismastersim then
	inst:DoTaskInTime(0,function(...)
		local x,y,z = inst.Transform:GetWorldPosition()
		local x1, y1 = TheWorld.Map:GetTileCoordsAtPoint(x,0,z)
		if TUNING.MYTH_GHG_TILE ~= nil and TUNING.MYTH_GHG_TILE[getcoordsstr(x1,y1)] then
			inst:Remove()
		end
	end)
	end
end)

local rain = false
AddPrefabPostInit("forest", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if not rain then
	rain = true
	local frograin = upvaluehelper.GetWorldHandle(inst,"israining","components/frograin")
	if  frograin then
		local GetSpawnPoint = upvaluehelper.Get(frograin,"GetSpawnPoint")	
		if GetSpawnPoint ~= nil then
			local old = GetSpawnPoint
			local function newGetSpawnPoint(pt)
				if checkz(pt.z) then
					return nil
				end
				return old(pt)
			end
			upvaluehelper.Set(frograin,"GetSpawnPoint",newGetSpawnPoint)
		end		
	end

	local wildfires = upvaluehelper.GetEventHandle(TheWorld,"ms_lightwildfireforplayer","components/wildfires")
	if  wildfires then
		local LightFireForPlayer = upvaluehelper.Get(wildfires,"LightFireForPlayer")	
		if LightFireForPlayer ~= nil then
			local old = LightFireForPlayer
			local function NewLightFireForPlayer(player, rescheduleFn)
				if player ~= nil then
					local x, y, z = player.Transform:GetWorldPosition()
					if checkz(z) then
						return
					end
					local x1, y1 = TheWorld.Map:GetTileCoordsAtPoint(x,0,z)
					if TUNING.MYTH_GHG_TILE ~= nil and TUNING.MYTH_GHG_TILE[getcoordsstr(x1,y1)] then
						return
					end
				end
				old(player, rescheduleFn)
			end
			upvaluehelper.Set(wildfires,"LightFireForPlayer",NewLightFireForPlayer)
		end	
	end	
	end
end)

AddComponentPostInit("witherable", function(self)
	if self.inst then
		self.inst:DoTaskInTime(0.1,function(crop)
			local x,y,z = crop.Transform:GetWorldPosition()
			if checkz(z) then
				self:Enable(false)
			end
			local x1, y1 = TheWorld.Map:GetTileCoordsAtPoint(x,0,z)
			if TUNING.MYTH_GHG_TILE ~= nil and TUNING.MYTH_GHG_TILE[getcoordsstr(x1,y1)] then
				self:Enable(false)
			end
		end)
	end
end)

AddComponentPostInit("sinkholespawner", function(self)
	local oldSpawnSinkhole = self.SpawnSinkhole
	function self:SpawnSinkhole(spawnpt)
		if checkz(spawnpt.z) then
			return false
		end	
		local x1, y1 = TheWorld.Map:GetTileCoordsAtPoint(spawnpt.x,0,spawnpt.z)
		if TUNING.MYTH_GHG_TILE ~= nil and TUNING.MYTH_GHG_TILE[getcoordsstr(x1,y1)] then
			return false
		end
		return oldSpawnSinkhole(self,spawnpt)
	end
end)

local mythHOUSEVISION =
{
    day = "images/colour_cubes/identity_colourcube.tex",
    dusk = "images/colour_cubes/identity_colourcube.tex",
    night = "images/colour_cubes/identity_colourcube.tex",
    full_moon = "images/colour_cubes/identity_colourcube.tex",
}

AddComponentPostInit("playervision", function(self)
	local old_UpdateCCTable = self.UpdateCCTable
	function self:UpdateCCTable()
		old_UpdateCCTable(self)
		if self.currentcctable == nil then 
			if self.inst._inmythcamea ~= nil  and self.inst._inmythcamea:value() ~=  nil  then
				self.currentcctable = mythHOUSEVISION
				self.inst:PushEvent("ccoverrides", mythHOUSEVISION)
			else
				self.inst:PushEvent("ccoverrides", nil)
			end
		end	
	end
end)

--在房子里面无法打开地图
AddClassPostConstruct("widgets/controls", function(self)
	local old = self.ShowMap
	function self:ShowMap(world_position)
		if self.owner ~= nil and self.owner._inmythcamea ~= nil  and self.owner._inmythcamea:value() ~=  nil  then
			return
		end
		return old(self,world_position)
	end
	local aa = self.ToggleMap
	function self:ToggleMap()
		if self.owner ~= nil and self.owner._inmythcamea ~= nil  and self.owner._inmythcamea:value() ~=  nil and self.owner.HUD ~= nil and not self.owner.HUD:IsMapScreenOpen() then
			return
		end
		return aa(self)
	end
end)

--房子里面100%防雨
AddComponentPostInit("moisture", function(self)
	local old = self.GetMoistureRate
	function self:GetMoistureRate()
		if not TheWorld.state.israining then
			return 0
		end	
		if self.inst._inmythcamea ~= nil and self.inst._inmythcamea:value() ~=  nil then
			return 0
		end
		return old(self)
	end
end)

AddComponentPostInit("areaaware", function(self)
	local old = self.UpdatePosition
	function self:UpdatePosition(x, y, z,...)
		if checkz(z) then
			self.lastpt.x, self.lastpt.z = x, z
			if self.current_area_data ~= nil then
				self.current_area = -1
				self.current_area_data = nil 
				self.inst:PushEvent("changearea", self:GetCurrentArea())
			end
			return	
		end
		return old(self,x, y, z,...)
	end
end)

--这个地方应该渺无鸟烟
AddComponentPostInit("birdspawner", function(self)
	local old_GetSpawnPoint = self.GetSpawnPoint
	function self:GetSpawnPoint(pt)
		if checkz(pt.z) then
			return nil
		else 
			return  old_GetSpawnPoint(self,pt)
		end
	end
end)

local Old_PlayFootstep = GLOBAL.PlayFootstep
GLOBAL.PlayFootstep = function(inst, volume, ispredicted,...)
	if inst and inst._inmythcamea ~= nil and inst._inmythcamea:value() ~=  nil then
		local sound = inst.SoundEmitter
		if sound ~= nil then
            sound:PlaySound(
                inst.sg ~= nil and inst.sg:HasStateTag("running") and "dontstarve/movement/run_woods" or "dontstarve/movement/walk_woods"
                ..
                (   (inst:HasTag("smallcreature") and "_small") or
                    (inst:HasTag("largecreature") and "_large" or "")
                ),
                nil,
                 volume or 1,
                 ispredicted
            )
		end
	else
		Old_PlayFootstep(inst, volume, ispredicted,...)
	end
end

local Old_MakeSnowCovered = GLOBAL.MakeSnowCovered

local function ClearSnowCoveredPristine(inst)
    inst.AnimState:ClearOverrideSymbol("snow", "snow", "snow")
    inst:RemoveTag("SnowCovered")
    inst.AnimState:Hide("snow")
end
GLOBAL.MakeSnowCovered = function(inst,...)
	Old_MakeSnowCovered(inst,...)
	inst:DoTaskInTime(0,function()
		if inst.Transform ~= nil then
			local x,y,z = inst.Transform:GetWorldPosition()
			if checkz(z) then
				 ClearSnowCoveredPristine(inst)
			end
		end
	end)
end

local old_update = {rain = nil ,caverain = nil, snow = nil }
local emitters = GLOBAL.EmitterManager
local oldPostUpdate = emitters.PostUpdate or nil

function emitters:PostUpdate(...)
	for inst, data in pairs( self.awakeEmitters.infiniteLifetimes ) do
		if (inst.prefab == "rain" or inst.prefab == "caverain" or inst.prefab == "snow")  and data.updateFunc ~= nil then
			if old_update[inst] == nil then
				old_update[inst] = data.updateFunc
			end
			local x, y, z = inst.Transform:GetWorldPosition()
			if checkz(z) then
				data.updateFunc = function(...)
				end
			else
				data.updateFunc = old_update[inst]
			end
				
		end
	end
	if oldPostUpdate ~= nil then
		oldPostUpdate(emitters,...)
	end
end
--newaction
--新动作

local MYTH_ENTER_HOUSE = Action({ priority=1, mount_valid = true,ghost_valid=true, encumbered_valid=true})	
MYTH_ENTER_HOUSE.id = "MYTH_ENTER_HOUSE"
MYTH_ENTER_HOUSE.strfn = function(act)
    if act.doer ~= nil and act.doer:HasTag("playerghost") then
		return  "HAUNT"
	end
	return act.target ~= nil and string.upper(act.target.prefab) or nil 
end
local IsFlying = function(inst) return inst and inst.components.mk_flyer and inst.components.mk_flyer:IsFlying()end
MYTH_ENTER_HOUSE.fn = function(act)
    if act.doer ~= nil and
        act.doer.sg ~= nil and
        act.doer.sg.currentstate.name == "mythhousein_pre" then
        if act.target ~= nil and
            act.target.components.myth_teleporter ~= nil and
            act.target.components.myth_teleporter:IsActive(act.doer) then
			if IsFlying(act.doer) then 
				act.doer.sg:GoToState("idle")
				return false,"FLY"
			end
            act.doer.sg:GoToState("mythhousejump", { myth_teleporter = act.target })
            return true
        end
        act.doer.sg:GoToState("idle")
		if act.doer.components.myth_favorability and act.doer.components.myth_favorability:IsBanned() then
			return false,"BANNED"
		else
			return false,"NOTIME"
		end
    end
end
AddAction(MYTH_ENTER_HOUSE)

AddComponentAction("SCENE", "myth_teleporter" , function(inst, doer, actions, right)
    if inst:HasTag("myth_teleporter") then
		table.insert(actions, ACTIONS.MYTH_ENTER_HOUSE)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.MYTH_ENTER_HOUSE, "mythhousein_pre"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.MYTH_ENTER_HOUSE, "mythhousein_pre"))

AddStategraphActionHandler("wilsonghost",ActionHandler(ACTIONS.MYTH_ENTER_HOUSE, "mythhousein_pre"))
AddStategraphActionHandler("wilsonghost_client",ActionHandler(ACTIONS.MYTH_ENTER_HOUSE, "mythhousein_pre"))

local L = MK_MOD_LANGUAGE_SETTING
if L == "CHINESE" then
	STRINGS.ACTIONS.MYTH_ENTER_HOUSE = {
		HAUNT = "作祟",
		FANGCUNHILL = "进入",
		MYTH_GHG = "进入",
		MYTH_DOOR_EXIT = "离开",
		MYTH_DOOR_EXIT_1 = "离开",
		MYTH_DOOR_EXIT_2 = "离开",
		MYTH_DOOR_ENTER = "进入",
	}
else
	STRINGS.ACTIONS.MYTH_ENTER_HOUSE = {
		HAUNT = "haunt",
		FANGCUNHILL = "Enter",
		MYTH_GHG = "Enter",
		MYTH_DOOR_EXIT = "Exit",
		MYTH_DOOR_EXIT_1 = "Exit",
		MYTH_DOOR_EXIT_2 = "Exit",
		MYTH_DOOR_ENTER = "Enter",
	}
end
----weight
local MYTH_WEIGHDOWN = Action({ priority=2})
MYTH_WEIGHDOWN.id = "MYTH_WEIGHDOWN"
MYTH_WEIGHDOWN.str = STRINGS.MYTH_WEIGHDOWN

MYTH_WEIGHDOWN.fn = function(act)
    local pos = act:GetActionPoint()
    if pos == nil then
        pos = act.target:GetPosition()
    end
	if act.doer.components.inventory then	
		return act.doer.components.inventory:DropItem(act.invobject, false, false, pos) 
	end
end
AddAction(MYTH_WEIGHDOWN)

AddComponentAction("USEITEM", "inventoryitem" , function(inst, doer, target, actions, right)
    if target:HasTag("myth_weighdown") then
		table.insert(actions, ACTIONS.MYTH_WEIGHDOWN)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.MYTH_WEIGHDOWN, "give"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.MYTH_WEIGHDOWN, "give"))


----clear
local MYTH_CLEAR = Action({ priority=1,distance = 2.5})
MYTH_CLEAR.id = "MYTH_CLEAR"
MYTH_CLEAR.str = STRINGS.MYTH_CLEAR

MYTH_CLEAR.fn = function(act)
    local pos = act:GetActionPoint()
    if pos == nil then
        pos = act.target:GetPosition()
    end
	if act.target and act.target.components.myth_oldinteriors then
		return act.target.components.myth_oldinteriors:OnClear(act.doer)
	end
end
AddAction(MYTH_CLEAR)

AddComponentAction("SCENE", "myth_oldinteriors" , function(inst, doer, actions)
    if inst:HasTag("myth_oldinteriors") then
		table.insert(actions, ACTIONS.MYTH_CLEAR)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.MYTH_CLEAR, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.MYTH_CLEAR, "dolongaction"))


----clear
local skills ={
	["monkey_king"]	= {"myth_flyskill_mk","mk_dsf"},
	["neza"]		= {"myth_flyskill_nz"},
	["white_bone"]	= {"myth_flyskill_wb"},
	["pigsy"]		= {"myth_flyskill_pg"},
	["yangjian"]	= {"myth_flyskill_yj","yangjian_track",},
	["myth_yutu"]	= {"myth_flyskill_yt"},
	["yama_commissioners"]	= {"myth_bahy","myth_flyskill_ya"},
}

local READ_FLY_BOOK = Action({ priority=1,distance = 1.7})
READ_FLY_BOOK.id = "READ_FLY_BOOK"
READ_FLY_BOOK.str = STRINGS.READ_FLY_BOOK

READ_FLY_BOOK.fn = function(act)
	if act.doer ~= nil and act.doer.components.builder then 
		local skill = skills[act.doer.prefab] or {"myth_flyskill"}
		for _, v in ipairs(skill) do
			if not act.doer.components.builder:KnowsRecipe(v) and
           		 act.doer.components.builder:CanLearn(v) then
				act.doer.components.builder:UnlockRecipe(v)
			end
		end
		if act.doer.Myth_Learn_Skill ~= nil then --如果你想要联动解锁你得技能可以用这个！
			act.doer:Myth_Learn_Skill()
		end
		if act.doer.components.sanity then
			act.doer.components.sanity:DoDelta(2)
		end
		return true
	end
end
AddAction(READ_FLY_BOOK)

AddComponentAction("SCENE", "read_fly_book" , function(inst, doer, actions,right)
    if right then
		table.insert(actions, ACTIONS.READ_FLY_BOOK)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.READ_FLY_BOOK, "myth_peruse"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.READ_FLY_BOOK, "book_peruse"))


local SIT_ON_MYTH = Action({ priority=1})
SIT_ON_MYTH.id = "SIT_ON_MYTH"
SIT_ON_MYTH.str = STRINGS.SIT_ON_MYTH

SIT_ON_MYTH.fn = function(act)
	return true
end
AddAction(SIT_ON_MYTH)

AddComponentAction("SCENE", "sit_on_myth" , function(inst, doer, actions,right)
    if right and not inst:HasTag("sitbusy") then
		table.insert(actions, ACTIONS.SIT_ON_MYTH)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.SIT_ON_MYTH, "sit_on_myth"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.SIT_ON_MYTH, "sit_on_myth"))

local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

AddStategraphState('wilson',

    State{
        name = "mythhousein_pre",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("give")
			inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.bufferedaction ~= nil then
                        inst:PerformBufferedAction()
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            end),
        },
    }
)
AddStategraphState('wilsonghost',

    State{
        name = "mythhousein_pre",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("dissipate", false)
            inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_haunt", nil, nil, true)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.bufferedaction ~= nil then
                        inst:PerformBufferedAction()
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            end),
        },
    }
)

AddStategraphState('wilson',
    State{
        name = "mythhousejump",
        tags = { "doing", "busy", "canrotate", "nopredict", "nomorph" },

        onenter = function(inst, data)
            ToggleOffPhysics(inst)
            inst.components.locomotor:Stop()

            inst.sg.statemem.target = data.myth_teleporter
            inst.sg.statemem.heavy = inst.components.inventory:IsHeavyLifting()

            if data.myth_teleporter ~= nil and data.myth_teleporter.components.myth_teleporter ~= nil then
                data.myth_teleporter.components.myth_teleporter:RegisterTeleportee(inst)
            end
			inst.AnimState:PlayAnimation("give_pst", false)

            local pos = data ~= nil and data.myth_teleporter and data.myth_teleporter:GetPosition() or nil
            local dist
            if pos ~= nil then
                inst:ForceFacePoint(pos:Get())
            else
                inst.sg.statemem.speed = 0
                dist = 0
            end
			inst.sg.statemem.myth_teleportarrivestate = "idle"
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.heavy then
                    inst.Physics:Stop()
                end
                if inst.sg.statemem.target ~= nil then
                    if inst.sg.statemem.target:IsValid() then
                        inst.sg.statemem.target:PushEvent("starttravelsound", inst)
                    else
                        inst.sg.statemem.target = nil
                    end
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg.statemem.target ~= nil and
                        inst.sg.statemem.target:IsValid() and
                        inst.sg.statemem.target.components.myth_teleporter ~= nil then
                        inst.sg.statemem.target.components.myth_teleporter:UnregisterTeleportee(inst)
                        if inst.sg.statemem.target.components.myth_teleporter:Activate(inst) then
                            inst.sg.statemem.isteleporting = true
                            inst.components.health:SetInvincible(true)
                            if inst.components.playercontroller ~= nil then
                                inst.components.playercontroller:Enable(false)
                            end
                            inst:Hide()
                            inst.DynamicShadow:Enable(false)
                            return
                        end
                    end
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.isphysicstoggle then
                ToggleOnPhysics(inst)
            end
            inst.Physics:Stop()

            if inst.sg.statemem.isteleporting then
                inst.components.health:SetInvincible(false)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst:Show()
                inst.DynamicShadow:Enable(true)
            elseif inst.sg.statemem.target ~= nil
                and inst.sg.statemem.target:IsValid()
                and inst.sg.statemem.target.components.myth_teleporter ~= nil then
                inst.sg.statemem.target.components.myth_teleporter:UnregisterTeleportee(inst)
            end
        end,
    }	
)

AddStategraphState('wilsonghost',
    State{
        name = "mythhousejump",
        tags = { "doing", "busy", "canrotate", "nopredict", "nomorph" },
        onenter = function(inst, data)
            inst.components.locomotor:Stop()

            inst.sg.statemem.target = data.myth_teleporter
            inst.sg.statemem.myth_teleportarrivestate = "idle"

            inst.sg.statemem.target:PushEvent("starttravelsound", inst)
            if inst.sg.statemem.target ~= nil and inst.sg.statemem.target.components.myth_teleporter ~= nil
                and inst.sg.statemem.target.components.myth_teleporter:Activate(inst) then
                inst.sg.statemem.isteleporting = true
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(false)
                end
                inst:Hide()
            else
                inst.sg:GoToState("idle")
            end
        end,		
        onexit = function(inst)
            if inst.sg.statemem.isteleporting then
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst:Show()
            end
        end,		
    }	
)

AddStategraphState('wilson_client',

    State{
        name = "mythhousein_pre",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("give")
			inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(1)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    }
)

AddStategraphState('wilsonghost_client',

    State
    {
        name = "mythhousein_pre",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("dissipate")
            inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_haunt", nil, nil, true)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(1)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.AnimState:PlayAnimation("appear")
                inst.sg:GoToState("idle", true)
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("appear")
            inst.sg:GoToState("idle", true)
        end,
    }
)

AddStategraphState('wilson',
    State{
        name = "myth_peruse",
        tags = { "doing","busy" },

        onenter = function(inst)
			local buffaction = inst:GetBufferedAction()
			local target = buffaction ~= nil and buffaction.target or nil
			if target ~= nil then
				inst.sg.statemem.attacktarget = target
				target:Hide()
			end
			inst.AnimState:AddOverrideBuild("myth_peruse")
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("myth_peruse", false)
            inst.AnimState:Show("ARM_normal")
        end,

        timeline =
        {
            TimeEvent(25 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/use_book")
            end),
            TimeEvent(73 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/characters/actions/page_turn")
            end),
            TimeEvent(105 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
        onexit = function(inst)
			inst.AnimState:ClearOverrideBuild("myth_peruse")
			inst.AnimState:AddOverrideBuild("player_peruse")
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and not item:HasTag("book") then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
			if inst.sg.statemem.attacktarget ~= nil then
				inst.sg.statemem.attacktarget:Show()
			end
        end,
    }
)

AddStategraphState("wilson",
	State {
    name = "sit_on_myth",
    tags = { "busy", "pausepredict" },

    onenter = function(inst)
		local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
		if target ~= nil then
			inst.sg.statemem.attacktarget = target
			target:AddTag("sitbusy")
			inst.Transform:SetPosition(target.Transform:GetWorldPosition())
		end
        inst.AnimState:PlayAnimation("emote_pre_sit2")
        inst.AnimState:PushAnimation("emote_loop_sit2", true)
    end,
	
    timeline =
    {
        TimeEvent(.2, function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:RemoveStateTag("pausepredict")
			inst:PerformBufferedAction()
        end),
    },

    events =
    {
        EventHandler("onremove", function(inst) 
			if inst.sg.statemem.attacktarget ~= nil then
				inst.sg.statemem.attacktarget:RemoveTag("sitbusy")
			end	
		end),
    },
    onexit = function(inst)
		if inst.sg.statemem.attacktarget ~= nil then
			inst.sg.statemem.attacktarget:RemoveTag("sitbusy")
		end
    end,
}
)

AddStategraphState("wilson_client",
	State {
    name = "sit_on_myth",
    tags = { "busy", "pausepredict" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()
            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst.Transform:SetPosition(buffaction.target.Transform:GetWorldPosition())
            end
        end
        inst.AnimState:PlayAnimation("emote_pre_sit2")
        inst.AnimState:PushAnimation("emote_loop_sit2", true)
    end,
	
    timeline =
    {
        TimeEvent(.2, function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:RemoveStateTag("pausepredict")
			inst:ClearBufferedAction()
        end),
    }
}
)

--别看了这里是作弊的
local function reset(inst)
	if not inst then return end 
	local x,y,z = inst.Transform:GetWorldPosition()
	
	local ents = TheSim:FindEntities(x, y, z, 15, {"myth_zodiac_1"})
	for i,v in ipairs(ents) do
		v.busy = true
		v.Transform:SetRotation(0)
		if v.huan ~= nil then
			v.huan.Transform:SetRotation(0)
		end
		v:CheckLock()
		break
	end
end

AddModRPCHandler("myth_theme", "yznb", reset)

local function openbbn(inst)
	if inst:HasTag("playerghost") or inst.components.health:IsDead() then return end
	if inst.bbncdin then return end
	if inst.components.myth_bbn_container ~= nil then
		inst.components.myth_bbn_container:OpenChester()
	end
	inst.bbncdin = true
	inst:DoTaskInTime(0.2, function() inst.bbncdin = false end)
end
AddModRPCHandler("myth_theme", "bbn", openbbn)

local ImageButton = require "widgets/imagebutton"

local function AddControl(ui,savename)
	function ui:OnControl(control, down)
		if ui._base.OnControl(ui, control, down) then return true end
		if ui.focus and control == CONTROL_SECONDARY then
			if down then
				local pos = TheInput:GetScreenPosition()
				local pos1 = ui:GetWorldPosition()
				local pos2 = ui:GetPosition()
				ui.offpos = pos - pos1
				if ui.followhandler == nil then
					ui.followhandler = TheInput:AddMoveHandler(function(x, y)
						local scr_w, scr_h = TheSim:GetScreenSize()
						local x,y = math.clamp(x, 32, scr_w - 32), math.clamp(y, 32, scr_h - 32)
						local scale = ui:GetScale()
						local pos4 = ui:GetPosition()
						local pos1 = ui:GetWorldPosition()
						local x1,y1 = (x - pos1.x) * ( 2 - scale.x), (y - pos1.y) * ( 2 - scale.x)
						ui:SetPosition(x1 + pos4.x - ui.offpos.x, y1 + pos4.y - ui.offpos.y)
					end)
				end
			else
				if ui.followhandler ~= nil then
					ui.followhandler:Remove()
					ui.followhandler = nil
					local newpos = ui:GetPosition()
					TheSim:SetPersistentString(savename,string.format("return Vector3(%f,%f,%f)",newpos:Get()),false)
				end
			end
		elseif ui.followhandler ~= nil then
			ui.followhandler:Remove()
			ui.followhandler = nil
			local newpos = ui:GetPosition()
			TheSim:SetPersistentString(savename,string.format("return Vector3(%f,%f,%f)",newpos:Get()),false)
		end
		return true
	end
    TheSim:GetPersistentString(savename,function(load_success, str)
        if load_success then
            local fn = loadstring(str)
            if type(fn) == "function" then
                local pos = fn()
				ui:SetPosition(pos:Get())
            end
        end
    end)
end

local function AddBnnButton(self) 
	--遁地隐藏 			
	self.undergroundfn = function(owner)
		if self.bbnbutton ~= nil then
			if owner._underground ~= nil then
				if owner._underground:value() then
					self.bbnbutton:Hide()
				elseif not self.isghostmode then
					self.bbnbutton:Show()							
				end
			end		
		end
	end
				
	self.inst:ListenForEvent("hasbbndirty", function()
		if self.owner._hasbbn ~= nil and self.owner._hasbbn:value() then
			if not self.bbnbutton then
				self.bbnbutton = self:AddChild(ImageButton("images/inventoryimages/myth_bbnbutton.xml", "myth_bbnbutton.tex"))
				--self.bbnbutton:SetScale(0.9)
				local x1 ,y1,z1 = self.stomach:GetPosition():Get()
				self.bbnbutton:SetPosition(x1-150, y1, 0)
				self.bbnbutton:SetOnClick(function ()
					SendModRPCToServer(MOD_RPC["myth_theme"]["bbn"])
				end)				
				self.bbnbutton.inst:ListenForEvent("undergrounddirty",self.undergroundfn,self.owner)
				AddControl(self.bbnbutton,"myth_theme_bbn")
			end
		elseif self.bbnbutton then
			self.bbnbutton.inst:RemoveEventCallback("undergrounddirty",self.undergroundfn,self.owner)
			self.bbnbutton:Kill()
			self.bbnbutton = nil
		end
	end,self.owner)
	
	local old_SetGhostMode = self.SetGhostMode
	function self:SetGhostMode(ghostmode,...)
		old_SetGhostMode(self,ghostmode,...)
		if ghostmode then		
			if self.bbnbutton ~= nil then 
				self.bbnbutton:Hide()
			end	
		else
			if self.bbnbutton ~= nil then
				self.bbnbutton:Show()
			end
		end
	end
end
AddClassPostConstruct("widgets/statusdisplays", AddBnnButton)



AddClassPostConstruct(
	"widgets/containerwidget",
	function(self)
		local old_Open = self.Open
		function self:Open(container, doer)
			old_Open(self, container, doer)
			if container and container.prefab == "purple_gourd" then
				AddControl(self,"myth_purple_gourd")
			end
		end
	end
)

AddUserCommand("yznb", {
    aliases =nil,
    prettyname = nil,
    desc = nil,
    permission = COMMAND_PERMISSION.USER,
    confirm = false,
    slash = true,
    usermenu = false,
    servermenu = false,
    params = {},
    vote = false,
    localfn = function(params, caller)
        caller:DoTaskInTime(0.1, function(player)
			SendModRPCToServer(MOD_RPC["myth_theme"]["yznb"])
        end)
    end,
})


AddStategraphPostInit("wilson", function(sg)
	local bundle = sg.states["bundle"]
	if bundle then 
		local oldenter = bundle.onenter
		bundle.onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
				local target = buffaction.invobject or buffaction.target or nil
				if target and target.prefab == "myth_bundlewrap" then
					inst.AnimState:OverrideSymbol("wrap_paper", "myth_wrap_bundle", "wrap_paper")
					inst.AnimState:OverrideSymbol("wrap_string", "myth_wrap_bundle", "wrap_string")					
					inst.myth_wrap_bundle = true
				end
            end
			oldenter(inst)
		end
	end	
	local bundling = sg.states["bundling"]
	if bundling then
		local oldonexit = bundling.onexit
		bundling.onexit = function(inst)
			oldonexit(inst)
            if inst.myth_wrap_bundle and not inst.sg.statemem.bundling then
				inst.AnimState:ClearOverrideSymbol("wrap_paper")
				inst.AnimState:ClearOverrideSymbol("wrap_string")
				inst.AnimState:AddOverrideBuild("player_wrap_bundle")
				inst.myth_wrap_bundle = false
            end
		end
	end
	local bundle_pst = sg.states["bundle_pst"]
	if bundle_pst then
		local oldonexit = bundle_pst.onexit
		bundle_pst.onexit = function(inst)
			oldonexit(inst)
            if inst.myth_wrap_bundle then
				inst.AnimState:ClearOverrideSymbol("wrap_paper")
				inst.AnimState:ClearOverrideSymbol("wrap_string")
				inst.AnimState:AddOverrideBuild("player_wrap_bundle")
				inst.myth_wrap_bundle = false
            end
		end
	end
end)


local IsFlying = function(inst) return inst and inst.components.mk_flyer and inst.components.mk_flyer:IsFlying()end
AddComponentPostInit("playercontroller", function(self)
	local old = self.DoActionAutoEquip
	function self:DoActionAutoEquip(buffaction,...)
		if buffaction and buffaction.action == ACTIONS.MYTH_RED_GIVE then
			return
		end
		return old(self,buffaction,...)
	end

	local old_attack = self.DoAttackButton
	function self:DoAttackButton(buffaction,...)
		if self.inst:HasTag("myth_yutu_underground") then
			return
		end
		if self.inst:HasTag("pig_zhuzhu") then
			return
		end
		if self.inst._is_player_astral and self.inst._is_player_astral:value() then
			return
		end

		if (self.inst.prefab == "white_bone" or self.inst.prefab == "yama_commissioners") and IsFlying(self.inst)  then
			return
		end
		return old_attack(self,buffaction,...)
	end	
end)