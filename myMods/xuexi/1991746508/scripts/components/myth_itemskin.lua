local skin = Class(function(self, inst)
	self.inst = inst
	self.character = ''
	self.prefab = ''
	self.skin = net_string(inst.GUID, 'myth_itemskin.skin', 'mythEvents_itemskin')
	self.skin:set_local('none')

	if TheWorld.ismastersim then
		inst:DoTaskInTime(0.3, function() self:ChangeSkin(self.skin:value()) end)
	end
end)

function skin:SetData(data)
	self.data = data
end

function skin:SetDefaultData(skins)
	skins = skins or {}

	local data = {
		default = {
			anim = {bank = self.prefab, build = self.prefab, anim = "idle_none"},
			icon = {atlas = self.prefab..".xml", image = self.prefab.."_none"},
			swap = {build = self.prefab, folder = "swap_none"},
		},
	}
	for _,v in ipairs(skins)do
		data[v] = {
			anim = {bank = self.prefab, build = self.prefab, anim = "idle_"..v},
			icon = {atlas = self.prefab.. ".xml", image = self.prefab .."_".. v},
			swap = {build = self.prefab, folder = "swap_"..v},
		}
	end

	self.data = data
end

function skin:RoundSkin(allskin)
	if allskin == nil then
		return
	end
	if #allskin == 0 then
		return
	end
	for i,v in ipairs(allskin)do
		if v == self.skin:value() then
			self:ChangeSkin(allskin[i+1] or allskin[1])
			return
		end
	end
	self:ChangeSkin(allskin[math.random(#allskin)])
end

function skin:Default(a)
	return a .. "_" .. self.skin:value()
end

function skin:ChangeSkin(skin)
	if skin == '' then
		skin = 'none'
	end
	self.skin:set(skin)

	if self.changskinfn then
		self.changskinfn(skin)
	end
	if self.data == nil then
		return
	end

	local data = self.data[skin] or self.data['default']
	local anim = data.anim
	local icon = data.icon
	local swap = data.swap

	self.swap = swap
	
	if anim.build then
		self.inst.AnimState:SetBuild(anim.build)
	end
	if anim.bank then
		self.inst.AnimState:SetBank(anim.bank)
	end
	if anim.anim then
		self.inst.AnimState:PlayAnimation(anim.anim)
	end

	if self.inst.components.inventoryitem then
		if icon and icon.image then
			self.inst.components.inventoryitem:ChangeImageName(icon.image)
		end
	end
end

function skin:OverrideSymbol(inst, folder)
	local swap = self.swap or self.data.default.swap
	inst.AnimState:OverrideSymbol(folder, swap.build, swap.folder)
end

function skin:OnSave()
	return {skin = self.skin:value()}
end

function skin:OnLoad(data)
	if data then
		self.skin:set(data.skin or "none")
	end
end

return skin

