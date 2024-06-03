--[[怪物防御性 Monster Defensive]]--

local RP_Goods = Class(function(self, inst)
	self.inst = inst
	self.inst.isNewGoods = false
end)

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_batbat", "swap_batbat")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")  
	--SpawnPrefab("maxwell_smoke").Transform:SetPosition(owner.Transform:GetWorldPosition())
	owner:DoTaskInTime(0.03, function ()
		local r, g, b = HexToPercentColor("#FF0705")
		owner.AnimState:SetMultColour(r, g, b, 1)
		local currentscale = owner.Transform:GetScale()
		owner.Transform:SetScale(currentscale*2,currentscale*2,currentscale*2)
		local fx = SpawnPrefab("die_fx")
		fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
		local currentscale = fx.Transform:GetScale()
		fx.Transform:SetScale(currentscale*2.5,currentscale*2.5,currentscale*2.5)
	end)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
	owner.AnimState:SetMultColour(255/255,255/255,255/255,1)
	local currentscale = owner.Transform:GetScale()
	owner.Transform:SetScale(currentscale/2,currentscale/2,currentscale/2)
	owner:DoTaskInTime(0.03, function ()
		SpawnPrefab("small_puff").Transform:SetPosition(owner.Transform:GetWorldPosition())
	end)
end

function RP_Goods:addGoodsTrait()
	self.inst.isNewGoods = true
	local item = self.inst
	if item.components.finiteuses then
		item:RemoveComponent("finiteuses")
	end
	local r, g, b = HexToPercentColor("#FF0705")
	--设置怪物颜色
	item.AnimState:SetMultColour(r, g, b, 1)
	local currentscale = item.Transform:GetScale()
	item.Transform:SetScale(currentscale*2,currentscale*2,currentscale*2)
	item.components.equippable:SetOnEquip(onequip)
	item.components.equippable:SetOnUnequip(onunequip)	
end

function RP_Goods:OnSave()
	return
	{
		isNewGoods = self.inst.isNewGoods,
	}
end

function RP_Goods:OnLoad(data)
	if data ~= nil then
		self.inst.isNewGoods = data.isNewGoods
		if self.inst.isNewGoods then 
			self:addGoodsTrait()
		end
	end
end

return RP_Goods