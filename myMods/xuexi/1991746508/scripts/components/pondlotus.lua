
local  Pondlotus = Class(function(self, inst)
	self.inst = inst
	self.lotus = false
end)

local function bialotus(inst)

    inst.lotus = SpawnPrefab("lotus_nz")
	inst.lotus.Transform:SetScale(0.9, 0.9, 0.9)
    inst.lotus.entity:SetParent(inst.entity)
	
	inst:ListenForEvent("onremove", function()
		if inst.lotus ~= nil then
			inst.lotus:Remove()
		end
	end)
end

function Pondlotus:SpawnLotus()
	self.lotus = true
	if self.inst.lotus  == nil then 
		bialotus(self.inst)
	end
end

function Pondlotus:Rebuild()
	self.inst:DoTaskInTime(0.1,function()
		if self.inst.components.pickable ~= nil and self.inst.components.pickable.canbepicked == false then
			if self.inst.lotus then
				self.inst.lotus.AnimState:PlayAnimation("picked")
			end
		end
	end)
end

function Pondlotus:OnSave()
    return
    {
        lotus = self.lotus,
    }
end

function Pondlotus:OnLoad(data)
    if data ~= nil and data.lotus ~= false  then
		self.lotus = data.lotus
		self:SpawnLotus()
		self:Rebuild()
    end
end

return Pondlotus


