
local function onskin1(self, skin1)
	if skin1 ~= nil then
		self.inst:AddTag("canquxialai")
		self.inst.AnimState:ShowSymbol("tou")
	else
		self.inst:RemoveTag("canquxialai")
		self.inst.AnimState:HideSymbol("tou")
	end
end

local function onskin2(self, skin2)
	if skin2 ~= nil then
		self.inst:RemoveTag("canguashangqu")
	else
		self.inst:AddTag("canguashangqu")
	end
end

local Myth_Redlantern_Ground = Class(function(self, inst)
    self.inst = inst
    self.skin1 = nil
    self.skin2 = nil

    self.item1 = nil
	self.item2 = nil
end,
nil,
{
    skin1 = onskin1,
    skin2 = onskin2,
})

function Myth_Redlantern_Ground:RemoveLights()
	if self.item1 ~= nil then 
		self.item1:Remove()
		if self.item1light then
			self.item1light:Remove()
			self.item1light = nil
		end
	end
	if self.item2 ~= nil then 
		self.item2:Remove()
		if self.item2light then
			self.item2light:Remove()
			self.item2light = nil
		end
	end
end

local yellow = {
	redlantern_myth_c = true,
	redlantern_myth_d = true,
}
local function deng(inst,skin,symbol,gao,offset)
	local body = SpawnPrefab("myth_redlanternlight_ground")
	body.entity:SetParent(inst.entity)
	body.entity:AddFollower()
	body.Follower:FollowSymbol(inst.GUID, symbol, 0, gao or yellow[skin] and 0 or -20, 0)
	body.AnimState:SetLightOverride(.4)
	body.AnimState:SetBuild(skin)
	body.AnimState:SetFinalOffset(offset)
	--if yellow[skin] then
	--	body.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
	--end
	return body
end

function Myth_Redlantern_Ground:SpawnLight()
	self:RemoveLights()
	if self.skin2 ~= nil then
		self.item2 = deng(self.inst, self.skin2,"b",nil,-1)
		self.item2light = SpawnPrefab("myth_redlanternlight_ground_light")
		self.item2light.entity:SetParent(self.inst.entity)
	end
	if self.skin1 ~= nil then
		self.item1 = deng(self.inst, self.skin1,"a",-20,0)
		self.item1light = SpawnPrefab("myth_redlanternlight_ground_light")
		self.item1light.entity:SetParent(self.inst.entity)
		if self.skin2 ~= nil then
			self.item1.AnimState:HideSymbol("Tassle")
		end
	end

end

function Myth_Redlantern_Ground:GuaLight(item)
    if self.skin1 == nil then
        self.skin1 = item.AnimState:GetBuild()
	elseif self.skin2 == nil then
        self.skin2 = item.AnimState:GetBuild()
    end
	self:SpawnLight()
	item:Remove()
	return true
end

local function givelight(player,skin)
	if skin == "redlantern_myth_a" then
		skin = nil
	end
	local light = SpawnPrefab("myth_redlantern",skin)
	player.components.inventory:GiveItem(light,nil,player:GetPosition())
end

function Myth_Redlantern_Ground:QuLight(giver)
    if self.skin2 ~= nil then
		givelight(giver,self.skin2)
		self.skin2 = nil
	elseif self.skin1 ~= nil then
		givelight(giver,self.skin1)
		self.skin1 = nil
    end
	self:SpawnLight()
	return true
end

function Myth_Redlantern_Ground:OnSave()
    return { skin1 = self.skin1 , skin2 = self.skin2 }
end

function Myth_Redlantern_Ground:OnLoad(data)
    if data then
        self.skin1 = data.skin1
        self.skin2 = data.skin2
        self:SpawnLight()
    end
end

Myth_Redlantern_Ground.OnRemoveEntity = Myth_Redlantern_Ground.RemoveLights

return Myth_Redlantern_Ground
