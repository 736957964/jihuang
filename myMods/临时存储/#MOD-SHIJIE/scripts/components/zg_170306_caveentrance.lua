return Class(function(self,inst)

self.inst = inst
self.changed = nil
self.id = nil

self.inst:DoTaskInTime(0, function()
	if self.inst and self.changed then
		if self.inst.components.childspawner then
			self.inst.components.childspawner.childname = ""
		end
		if self.inst.components.talker then
			self.inst:DoPeriodicTask(1, function()
				self.inst.AnimState:PlayAnimation("open", true)
				self.inst.AnimState:SetScale(1,1,1)
				self.inst.MiniMapEntity:SetEnabled(true)
				self.inst:RemoveTag("NOCLICK")
				self.inst:RemoveTag("CLASSIFIED")
				self.inst.components.talker.offset = Vector3(0, -200, 0)
				self.inst.components.talker.colour = {x=0, y=1, z=0}
				
				local id = self.id or 0
				local players_num = TUNING.WORLD_PLAYERSNUM_170306["world_"..id] and TUNING.WORLD_PLAYERSNUM_170306["world_"..id].players_num or 0
				local players_num_max = TUNING.WORLD_PLAYERSNUM_170306["world_"..id] and TUNING.WORLD_PLAYERSNUM_170306["world_"..id].players_num_max or 0
				
				self.inst.components.talker:Say( id.."世界\n人数"..players_num.."/"..players_num_max.."\n↓", 2)
				
				self.inst.components.worldmigrator:SetDestinationWorld(self.id)
			end)
		end
		self.inst.components.worldmigrator:SetDestinationWorld(self.id)
	end
end)

function self:OnSave()
	return {changed = self.changed, id = self.id}
end

function self:OnLoad(data)
	self.changed = data and data.changed
	self.id = data and data.id
end
	
end)