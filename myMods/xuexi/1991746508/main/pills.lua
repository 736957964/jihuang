
AddPrefabFiles('alchmy_fur','mk_firefx', 'mk_cloudpuff')
AddPrefabFiles("myth_pills", "myth_buffs")

--免疫火
AddComponentPostInit("health", function(self)
	local old_DoFireDamage = self.DoFireDamage
	function self:DoFireDamage(...)
		if self.inst.components.inventory and self.inst.components.inventory:HasItemWithTag("heat_resistant_pill", 1) or self.inst.mythpill_forcefire then			
			return
		end
		return old_DoFireDamage(self, ...)
	end
end)
--免疫水
AddComponentPostInit("moisture", function(self)
	local old_GetMoistureRate = self.GetMoistureRate
	local old_GetDryingRate = self.GetDryingRate
	function self:GetMoistureRate()
		if self.inst.components.inventory and self.inst.components.inventory:HasItemWithTag("cold_resistant_pill", 1) or self.inst.mythpill_forcecold then
			return 0 
		end
		return old_GetMoistureRate(self)
	end
	function self:GetDryingRate(moisturerate, ...)
		if (moisturerate or self:GetMoistureRate()) > 0 then
			return 0
		end
		if self.inst.components.inventory and self.inst.components.inventory:HasItemWithTag("cold_resistant_pill", 1) or self.inst.mythpill_forcecold then
			return 3 
		end
		return old_GetDryingRate(self,moisturerate, ...)
	end
end)
--温度控制
AddComponentPostInit("temperature", function(self)
	local old_SetTemperature =  self.SetTemperature
	function self:SetTemperature(value,...)
		if value < 10 and  self.inst.components.inventory and self.inst.components.inventory:HasItemWithTag("cold_resistant_pill", 1) or self.inst.mythpill_forcecold then
			value = 10
		end
		if value > (self.overheattemp - 10 ) and self.inst.components.inventory and self.inst.components.inventory:HasItemWithTag("heat_resistant_pill", 1) or self.inst.mythpill_forcefire then
			value = self.overheattemp - 10
		end		
		return old_SetTemperature(self,value,...)
	end
end)

local function PushFn(inst)
	TheWorld:PushEvent("myth_flower_ghostchange")
end

--吸血/反伤/增伤
AddPlayerPostInit(function(inst)
	local function blood(inst,data)
		if not inst:HasTag("bloodthirsty_pill_buff") then
			return
		end
		if data and data.stimuli == "bramblefx_mk"  then
			return
		end
		local delta = (data and data.damage  or 0 ) * 0.1
		if not (inst.components.health ~= nil and inst.components.health:IsDead()) then
			inst.components.health:DoDelta(delta, false, "bloodthirsty_pill_buff")
		end
	end
	local function OnCooldown(inst)
		inst._cdjingji = nil
	end
	local function onattacked(inst,data)	
		if not inst.components.inventory then
			return
		end
		
		if inst._is_player_astral ~= nil and inst._is_player_astral:value() then
			return 
		end

		if inst.components.inventory:Has("thorns_pill", 1) then
			if inst._cdjingji == nil and data ~= nil and not data.redirected then

				inst._cdjingji = inst:DoTaskInTime(.3, OnCooldown)

				SpawnPrefab("bramblefx_mk"):SetFXOwner(inst)

				if inst.SoundEmitter ~= nil then
					inst.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
				end
			end		
		end
	end
    if TheWorld.ismastersim then
    	--新的监听器
        inst:ListenForEvent("onhitother", blood)
		inst:ListenForEvent("attacked", onattacked)
		--修改接口
		inst._myth_listener_blood = blood
		inst._myth_listener_attacked = onattacked

		inst:ListenForEvent("ms_respawnedfromghost", PushFn)
		inst:ListenForEvent("ms_becameghost", PushFn)
		inst:ListenForEvent("onremove", function()
			TheWorld:DoTaskInTime(0.2,function(inst)
				PushFn(inst)
			end)
		end)
    end
end)
--免疫尖刺植物
--可能会导致一些奇怪的后果, 如发生冲突, 请联系我们
AddComponentPostInit('inventory', function(self)
	local old_has = self.EquipHasTag
	function self:EquipHasTag(tag, ...)
		if tag == "bramble_resistant" then
			if self.inst.components.inventory and self.inst.components.inventory:Has("thorns_pill", 1) then
				return true
			end
		end
		return old_has(self,tag, ...)
	end
end)

--免疫沙尘暴
AddClassPostConstruct( "widgets/gogglesover", function(self)
	local oldToggleGoggles =self.ToggleGoggles
	function self:ToggleGoggles(show,...)
		oldToggleGoggles(self,show,...)
		if self.owner 
			and (self.owner.replica.inventory and self.owner.replica.inventory:HasItemWithTag("dust_resistant_pill", 1) 
			or self.owner:HasTag('mythpill_forcegoggles')) then
			self:Hide()
		end
	end
end)

--[[AddClassPostConstruct( "widgets/nutrientsover", function(self)
	local oldToggleNutrients =self.ToggleNutrients
	function self:ToggleNutrients(show,...)
		oldToggleNutrients(self,show,...)
		if self.owner and self.owner.replica.inventory and self.owner.replica.inventory:HasItemWithTag("dust_resistant_pill", 1) then
			self:Hide()
		end
	end
end)]]


---不要学我刷刷刷 这样很不好的 ！！！
AddComponentPostInit("playervision", function(self)
	self.inst:StartUpdatingComponent(self)
	function self:OnUpdate(dt)
		if self.inst.replica.inventory and self.inst.replica.inventory:HasItemWithTag("dust_resistant_pill", 1) or self.inst:HasTag('mythpill_forcegoggles')  then
			self:ForceGoggleVision(true)
		else
			self:ForceGoggleVision(false)
		end
	end
end)

--壮骨 凝味丹会覆盖蒜末辣椒面料理buff
	
local noneedbuff  = {
	buff_playerabsorption = "armor_pill_buff",
	buff_attack = "condensed_pill_buff",
}
AddComponentPostInit("debuffable", function(self)
	local old_AddDebuff = self.AddDebuff
	function self:AddDebuff(name, prefab,...)
		if noneedbuff[name] ~= nil and self:HasDebuff(noneedbuff[name]) then
			self:RemoveDebuff(noneedbuff[name])
		end
		return old_AddDebuff(self,name, prefab,...)
	end
end)