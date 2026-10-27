return Class(function(self,inst)

self.inst=inst

local function Zg_GetTPPos()
	local ground = TheWorld
	local centers = {}
	for i, node in ipairs(ground.topology.nodes) do
		if ground.Map:IsPassableAtPoint(node.x, 0, node.y) then
			table.insert(centers, {x = node.x, z = node.y})
		end
	end
	if #centers > 0 then
		local pos = centers[math.random(#centers)]
		return Point(pos.x, 0, pos.z)
	else
		return nil
	end
end

function self:TrySpawn()
	if not self.mihawk then
		local pos = Zg_GetTPPos()
		if pos then
			SpawnPrefab("diviningrod").Transform:SetPosition( pos:Get() )
			self.mihawk=true
		end
	end
end

function self:OnSave()
	return 
	{
		mihawk=self.mihawk,
	}
end

function self:OnLoad(data)
	if data then
		self.mihawk=data.mihawk or false
	end
end

end)