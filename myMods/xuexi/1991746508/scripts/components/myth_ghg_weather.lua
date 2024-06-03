
--ThePlayer.components.myth_ghg_weather:SetSnow(true)
local needfx = not TheNet:IsDedicated() --专用服务器不需要哦

local function OnChangeArea(inst, area)
	local area_snow_mode = area ~= nil and area.tags and table.contains(area.tags, "ghgarea") and true or false
	inst.components.myth_ghg_weather:SetSnow(area_snow_mode)
end

local function OnTaskTick(inst, self, period)
    self:ChecekTile(period)
end

local function getcoordsstr(x,y)
	return x.."_"..y
end

local myth_ghg_weather = Class(function(self, inst)
    self.inst = inst

	self.turfs = nil
	if needfx then
		self.snowfx = SpawnPrefab("myth_ghg_snow")
		self.snowfx.entity:SetParent(inst.entity)
		self.snowfx:PostInit()
	end
	
	self.insnow = false
	
    local period = 1
    self.inst:DoPeriodicTask(period, OnTaskTick, nil, self, period)
end)

function myth_ghg_weather:ChecekTile()
	local x1,y1,z1 = self.inst.Transform:GetWorldPosition()
	local x, y = TheWorld.Map:GetTileCoordsAtPoint(x1,0,z1)
	if TUNING.MYTH_GHG_TILE[getcoordsstr(x,y)] then
		if not self.insnow then
			self:SetSnow(true)
		end
	elseif self.insnow then
		self:SetSnow(false)
	end
end

function myth_ghg_weather:SetSnow(bool)
	if bool then
		self.insnow = true
		if self.inst.components.temperature then
			local tem  = -30
			if TheWorld.state.iswinter then
				tem  = -10
			elseif TheWorld.state.issummer then
				tem  = -40
			end
			self.inst.components.temperature:SetModifier("myth_ghg", tem)
		end
		if self.snowfx then
			self.snowfx.particles_per_tick = 20
		end

	elseif self.insnow then
		self.insnow = false
		if self.snowfx then
			self.snowfx.particles_per_tick = 0
		end
		if self.inst.components.temperature then
			self.inst.components.temperature:RemoveModifier("myth_ghg")
		end
	end
end

return myth_ghg_weather