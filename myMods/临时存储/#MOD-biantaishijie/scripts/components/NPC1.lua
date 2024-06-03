return Class(function(self,inst)

	self.inst=inst
	self.inst:StartUpdatingComponent(self)
	
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
		if not self.has then
			local pos = Zg_GetTPPos()
			if pos then
				SpawnPrefab("lightning")
				--TheNet:Announce("一只可爱的小熊熊出现啦")
				--SpawnPrefab("bearger").Transform:SetPosition( pos:Get() )    c_gonext("teleportato_base")
				
				local r = SpawnPrefab("teleportato_base")
				r.AnimState:SetBank("wilson")
				r.AnimState:SetBuild("wendy")
				r.AnimState:PlayAnimation("idle", true)
				r.Transform:SetPosition( pos:Get() )
				r.Transform:SetFourFaced()
				r.Transform:SetScale(2, 2, 2)
				r:AddTag("wufafenjie")
				---r.persists = false
				r:AddComponent("named")
				r.components.named:SetName("任务 NPC \n迷茫的温蒂\n任务第一环\n金元宝开启")
				r.components.inspectable:SetDescription("温蒂作为饥荒世界的先行者，总是遇到一些困难，希望你能帮助她击杀巨熊")
				
				
				
				local function OnGetItemFromPlayer(r, giver, item)
					if  item.prefab == "lucky_goldnugget"   and  giver.renwu == 0 then			
					TheNet:Announce("饥荒新闻：玩家 "..giver.name.." 开始任务第一环，击杀雄霸~")
					local x, y, z = r.Transform:GetWorldPosition()
					local q = SpawnPrefab("bearger")	
					q.components.health:SetMaxHealth(50000)					   
					q.Transform:SetPosition(x+math.random(10)-math.random(10),y,z+math.random(10)-math.random(10))	
					giver.renwu = 1								
                end				
				end
				
				r:AddComponent("trader")
				r.components.trader.onaccept = OnGetItemFromPlayer
				r.components.trader:SetAcceptTest(function(r, item)
			       return item and item.prefab == "lucky_goldnugget" 
		        end)
				r.components.trader.onrefuse = function (r, giver, item)
					if giver.components.talker then
					giver.components.talker:Say("不是温蒂所需的信物")
				end
				end
				
				
				self.has=true
			end
		end
	end
	
	function self:OnUpdate(dt)
		self:TrySpawn()
		if self.inst.state.cycles % 71 == 0 and self.inst.state.cycles~= (self.lastcycles or self.inst.state.cycles ) then
			self.has = false
		end
		self.lastcycles = self.inst.state.cycles
	end

	function self:OnSave()
		return 
		{
			has=self.has,
		}
	end

	function self:OnLoad(data)
		if data then
			self.has=data.has or false
		end
	end

end)