local _G = GLOBAL
local TheNet = _G.TheNet
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

if IsServer then
	-- 叠加上限
	local stack_size = GetModConfigData("stack_size")
	if stack_size ~= -1 then
		TUNING.STACK_SIZE_LARGEITEM = stack_size
		TUNING.STACK_SIZE_MEDITEM = stack_size
		TUNING.STACK_SIZE_SMALLITEM = stack_size

		local stackTable = {
			"rabbit",             -- 兔子
			"mole",               -- 鼹鼠
			"canary",             -- 金丝雀
			"canary_poisoned",    -- 虚弱的金丝雀
			"robin",              -- 红雀
			"robin_winter",       -- 雪雀
			"crow",               -- 乌鸦
			"eyeturret_item",     -- 眼球塔
			"lavae_egg",          -- 熔岩虫蛋
			"lavae_egg_cracked",  -- 破裂的熔岩虫蛋
			"lavae_tooth",        -- 岩浆牙
			"lavae_cocoon",       -- 冷冻幼虫
			"tallbirdegg",        -- 高脚鸟蛋
			"tallbirdegg_cracked",-- 破裂的高脚鸟蛋
			"bluemooneye",        -- 蓝色月棱镜
			"greenmooneye",       -- 绿色月棱镜
			"moonrockcrater",     -- 火山口月石
			"purplemooneye",      -- 紫色月石
			"redmooneye",         -- 红色月石
			"orangemooneye",      -- 橙色月石
			"yellowmooneye",      -- 黄色月棱镜
			"nightmare_timepiece",-- 图勒奖章
			"shadowheart",        -- 暗影之心
		}

		local function StackFn(inst)
			if(inst.components.stackable == nil) then
				inst:AddComponent("stackable")
			end
			
			if inst.components.health ~= nil then
				inst.components.inventoryitem:SetOnDroppedFn(function(inst)
					inst.components.perishable:StopPerishing()
					inst.sg:GoToState("stunned")
					if inst.components.stackable then
						while inst.components.stackable:StackSize() > 1 do
							local item = inst.components.stackable:Get()
							if item then
								if item.components.inventoryitem then
									item.components.inventoryitem:OnDropped()
								end
								item.Physics:Teleport(inst.Transform:GetWorldPosition())
							end
						end
					end
				end)
			end
		end

		for k,name in pairs(stackTable) do
			AddPrefabPostInit(name, StackFn)
		end
	end

	local drop_min = GetModConfigData("drop_min")
	local drop_max = GetModConfigData("drop_max")
	if drop_max < drop_min then
		drop_min = drop_max
	end

	-- 死亡掉落
	AddComponentPostInit("inventory", function(Inventory, inst)
		if inst:HasTag("player") then
			local old_DropEverything = Inventory.DropEverything

			function DropRandom(self)
				local dropNum = math.random(drop_min, drop_max)

				local slots = {}
				local dropCount = 0
				for k = 1, self.maxslots do
					local v = self.itemslots[k]
					if v ~= nil then
						table.insert(slots, v)
						--self:DropItem(v, true, true)
					end
				end

				while #slots > 0 and dropCount < dropNum do
					local item = table.remove(slots, math.random(#slots))
					self:DropItem(item, true, true)
					dropCount = dropCount + 1
				end

				if dropCount < dropNum then
					for k, v in pairs(self.equipslots) do
						if not v:HasTag("backpack") and dropCount < dropNum then
							self:DropItem(v, true, true)
							dropCount = dropCount + 1
						end
					end
				end
			end

			function Inventory:DropEverything(ondeath, keepequip)
				return DropRandom(self)
			end
		end
	end)
end