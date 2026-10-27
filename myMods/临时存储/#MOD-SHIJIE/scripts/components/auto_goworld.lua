return Class(function(self,inst)

self.new = true

self.inst = inst

local function choosemin(table)
	if type(table) ~= table then
		return
	end
	local min = 1000000
	local key
	for k, v in pairs(table) do
		if v
			and v <= min 
			then
			min = v
			key = k
		end
	end
	return key, min
end

self.inst:DoTaskInTime(1,function()
	if self.new then
		--当前人数
		local curnum = {}
		for k,v in pairs(TUNING.WORLD_PLAYERSNUM_170306) do
			if v and v.players_num < v.players_num_max then
				curnum[v.name] = v.players_num
			end
		end
		--选当前人数最少的未满世界
		local world = choosemin(curnum)
		if world then
			local worldid = TUNING.WORLD_PLAYERSNUM_170306[world].id
			--进入世界
			local ents = TheSim:FindEntities(0,0,0, 90011)
			for k,v in pairs(ents) do
				if v 
					and v.prefab == "cave_entrance_open"
					and v.components.zg_170306_caveentrance
					and v.components.zg_170306_caveentrance.id == worldid
					then
					v.components.worldmigrator:Activate(inst)
					break
				end
			end
			
		end
		self.new = false
	end
end)

function self:OnSave()
	return {new = self.new}
end

function self:OnLoad(data)
	self.new = data and data.new
end
	
end)