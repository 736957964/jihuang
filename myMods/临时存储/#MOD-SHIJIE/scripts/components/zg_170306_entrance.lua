return Class(function(self,inst)

self.inst = inst
self.given = nil
self.id = nil

function self:Init()
	if not self.given then
		local portal = self.inst
		if portal then
			local x,y,z = portal.Transform:GetWorldPosition()
			for k,v in pairs(TUNING.SHARD_ID_TAB_170306) do
				if v and v.id ~= self.id 
					then
					local entrance = SpawnPrefab("cave_entrance_open")
					entrance.Transform:SetPosition(x+v.x, 0, z+v.z)
					entrance.components.zg_170306_caveentrance.changed = true
					entrance.components.zg_170306_caveentrance.id = v.id
				end
			end
			self.given = true
		end
	end
end

function self:OnSave()
	return {given = self.given}
end

function self:OnLoad(data)
	self.given = data and data.given
end
	
end)