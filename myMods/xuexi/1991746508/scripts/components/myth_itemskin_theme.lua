local skin = Class(function(self, inst)
	self.inst = inst
	
	self.skin = inst.prefab --默认
	self.skins = {} --皮肤
	self.skindata = {} --属性
end)

function skin:AddSkin(skin,data)
	table.insert(self.skins,skin)
	self.skindata[skin] = data
end

function skin:GetBuild()
	if self.skin and self.skindata[self.skin] ~= nil then
		return self.skindata[self.skin].build
	end
	return nil
end

function skin:GetSkin()
	return self.skin
end

function skin:RoundSkin()
	if #self.skins < 2 then --默认只有一个 不需要换
		return
	end
	for i,v in ipairs(self.skins)do
		if v == self.skin then
			self:ChangeSkin(self.skins[i+1] or self.skins[1])
			return
		end
	end
	self:ChangeSkin(self.skins[math.random(#self.skins)])
end

function skin:ChangeSkin(newskin)
	if newskin == nil or self.skindata[newskin] == nil then
		return
	end
	self.skin =  newskin
	if self.skindata[newskin].build then
		self.inst.AnimState:SetBuild(self.skindata[newskin].build)
	end
	if self.skindata[newskin].bank then
		self.inst.AnimState:SetBank(self.skindata[newskin].bank)
	end
	if self.skindata[newskin].anim then
		self.inst.AnimState:PlayAnimation(self.skindata[newskin].anim)
	end

	if self.inst.components.inventoryitem then
		if self.skindata[newskin].image then
			self.inst.components.inventoryitem.atlasname = "images/inventoryimages/"..self.skindata[newskin].image..".xml"
			self.inst.components.inventoryitem:ChangeImageName(self.skindata[newskin].image)
		end
	end
	if self.changskinfn then
		self.changskinfn(self.inst,newskin)
	end
end

function skin:OnSave()
	return {skin = self.skin}
end

function skin:OnLoad(data)
	if data then
		if data.skin ~= nil then
			self:ChangeSkin(data.skin)
		end
	end
end

return skin

