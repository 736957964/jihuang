
AddComponentPostInit("hunger", function(self) --月饼不掉饥饿
	local oldDoDelta = self.DoDelta
	function self:DoDelta(...)
		if self.myth_mooncake_nuts then 
			return
		end
		return oldDoDelta(self,...)
	end
end)

AddComponentPostInit("sanity", function(self)--月饼不掉脑残
	local oldDoDelta = self.DoDelta
	function self:DoDelta(...)
		if self.myth_mooncake_ice and not self.yj_change then 
			return
		end
		return oldDoDelta(self,...)
	end

	local old_RecalculatePenalty = self.RecalculatePenalty
	function self:RecalculatePenalty(...)
		local icemooncake = false
		if self.myth_mooncake_ice then 
			icemooncake = true
			self.myth_mooncake_ice = false
		end
		old_RecalculatePenalty(self,...)
		if icemooncake then
			self.myth_mooncake_ice = true
		end
	end
end)




AddComponentPostInit("moisture", function(self)--避水
	local oldGetWaterproofInventory= self.GetWaterproofInventory
	function self:GetWaterproofInventory(...)
		if self.myth_waterproofInventory  then 
			return true
		end
		return oldGetWaterproofInventory(self,...)
	end
end)

AddComponentPostInit("groomer", function(self)
	local oldBeginChanging= self.BeginChanging
	function self:BeginChanging(doer,...)
		if self.inst.components.hitcher ~= nil and self.inst.components.hitcher.hitched ~= nil 
			and  self.inst.components.hitcher.hitched:HasTag("laozi_qingniu") then 
			if doer and doer.components.talker then
				doer.components.talker:Say(STRINGS.CHARACTERS.WILLOW.ACTIONFAIL_GENERIC)
			end
			return false
		end
		return oldBeginChanging(self,doer,...)
	end
end)

AddComponentPostInit("edible", function(self)
	local old_GetSanity = self.GetSanity
	function self:GetSanity(eater,...)
		local old = old_GetSanity(self,eater,...)
		if eater and eater.myth_mooncake_lotus then
			return (old > 0 and old or 0)
		else
			return old
		end
	end
	local old_GetHunger = self.GetHunger
	function self:GetHunger(eater,...)
		local old = old_GetHunger(self,eater,...)
		if eater and eater.myth_mooncake_lotus then
			return (old > 0 and old or 0)
		else
			return old
		end
	end
	local old_GetHealth = self.GetHealth
	function self:GetHealth(eater,...)
		local old = old_GetHealth(self,eater,...)
		if eater and eater.myth_mooncake_lotus then
			return (old > 0 and old or 0)
		else
			return old
		end
	end
	
end)

--不可以传送大蛤蟆
AddPrefabPostInit("telestaff", function(inst)
	if inst.components.spellcaster then
		local old = inst.components.spellcaster.spell
		inst.components.spellcaster.spell = function(inst, target,...)
			if  target and target.prefab == "myth_goldfrog" then
				return false
			end
			if old ~= nil then
				return old(inst, target,...)
			end
		end
	end
end)

AddComponentPostInit("equippable", function(self) 
	local oldGetWalkSpeedMult = self.GetWalkSpeedMult
	function self:GetWalkSpeedMult(...)
		local old = oldGetWalkSpeedMult(self,...)
		local owner =  self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner or nil
		if owner and owner:HasTag("movemountain_pill_buff") then
			return math.max(1,old)
		end
		return old
	end
end)


AddComponentPostInit("temperature", function(self) 
	local oldGetInsulation = self.GetInsulation
	function self:GetInsulation(...)
		local winterInsulation , summerInsulation = oldGetInsulation(self,...)
		if self.myth_food_tsj_buff then
			return winterInsulation + 120 ,summerInsulation
		end
		return winterInsulation , summerInsulation
	end
end)


AddComponentPostInit("inventory", function(self) 
	local old_IsHeavyLifting = self.IsHeavyLifting
	function self:IsHeavyLifting(...)
		if self.inst:HasTag("movemountain_pill_buff") then
			return false
		end
		return old_IsHeavyLifting(self,...)
	end
end)

AddClassPostConstruct( "components/inventory_replica", function(self, inst)
	local old_IsHeavyLifting = self.IsHeavyLifting
	function self:IsHeavyLifting(...)
		if self.inst:HasTag("movemountain_pill_buff") then
			return false
		end
		return old_IsHeavyLifting(self,...)
	end
end)

AddClassPostConstruct( "components/inventoryitem_replica", function(self, inst)
	local old_GetWalkSpeedMult = self.GetWalkSpeedMult
	function self:GetWalkSpeedMult(...)
		local old = old_GetWalkSpeedMult(self,...)
		if ThePlayer and self:IsGrandOwner(ThePlayer) and ThePlayer:HasTag("movemountain_pill_buff")  then
			return math.max(1,old)
		end
		return old
	end
end)

AddComponentPostInit("armor", function(self)
	local oldTakeDamage = self.TakeDamage
	function self:TakeDamage(damage_amount,...)
		local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner or nil
		if owner and owner.components.inventory and owner.components.inventory:ArmorHasTag("siving_hat") then
			damage_amount = damage_amount *0.75
		end
		oldTakeDamage(self,damage_amount,...)
	end
end)

AddComponentPostInit("weapon", function(self1)
	local attackwearmultipliers = self1.attackwearmultipliers
	local old_Get = attackwearmultipliers.Get
	function attackwearmultipliers:Get()
		local old = old_Get(self)
		local owner = self1.inst.components.inventoryitem and self1.inst.components.inventoryitem.owner or nil
		if owner and owner.components.inventory and owner.components.inventory:ArmorHasTag("siving_hat") then
			old = old *0.75
		end
		return old
	end
end)

local shadow_sanity = {
	"crawlinghorror","terrorbeak","shadow_knight","shadow_rook","shadow_bishop","crawlingnightmare","nightmarebeak",
	"stalker","stalker_forest","stalker_atrium","oceanhorror",
}

for _, v in ipairs(shadow_sanity) do
	AddPrefabPostInit(v,function(inst)
		inst:AddTag("myth_sving_sanity")
	end)
end

