local prefs = {}
local RangeFamily = 6 --竹群再生范围
local Chances = {
	groupGrow = 0.4, --竹群的再生竹组的几率(春季雨天，每15秒进行一次判定)
	groupWildGrow = 0.03, --野生竹组的重生几率(春季雨天，每15秒进行一次判定)
	memberGrow = 0.15, --竹组的再生竹子成员的几率(雨天，每15秒进行一次判定)
	groupOld = 0.1, --竹群的竹组长出苍竹的几率(每个竹子都判定一次)
	groupWildOld = 0.007, --野生竹组的长出苍竹的几率(每个竹子都判定一次)
}
local ChopMap = { --砍伐类的破坏次数
	myth_plant_bamboo_3 = 4,
	myth_plant_bamboo_4 = 5,
	myth_plant_bamboo_5 = 7,
	myth_plant_bamboo_burnt = 1
}
local DigMap = { --挖掘类的破坏次数
	myth_plant_bamboo_0 = 1,
	myth_plant_bamboo_1 = 1,
	myth_plant_bamboo_2 = 2,
	myth_plant_bamboo_stump = 1
}

SetSharedLootTable('myth_plant_bamboo_0',
{
    {'myth_bamboo_shoots', 0.5},
})
SetSharedLootTable('myth_plant_bamboo_2',
{
    {'myth_bamboo_shoots', 0.3},
})
SetSharedLootTable('myth_plant_bamboo_stump',
{
    {'myth_bamboo', 1},
})
SetSharedLootTable('myth_plant_bamboo_3',
{
    {'myth_bamboo', 0.67},
})
SetSharedLootTable('myth_plant_bamboo_4',
{
    {'myth_bamboo', 1.00},
	{'myth_bamboo', 0.67},
})
SetSharedLootTable('myth_plant_bamboo_5',
{
    {'myth_bamboo', 		1.00},
	{'myth_bamboo', 		0.67},
	{'myth_greenbamboo', 	1.00},
	{'myth_greenbamboo', 	0.50},
})
SetSharedLootTable('myth_plant_bamboo_burnt',
{
    {'charcoal', 1.00},
})

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function GetCalculatedPos(x, y, z, radius, angle)
    local rad = radius or math.random() * 3
    local ang = angle or math.random() * 2 * PI
    return x + rad * math.cos(ang), y, z - rad * math.sin(ang)
end

local function CanPlantHere(x, y, z, treename)
    local map = TheWorld.Map
	if map ~= nil and map:CanPlantAtPoint(x, y, z)
		and map:CanPlacePrefabFilteredAtPoint(x, y, z, treename)
		and not (RoadManager ~= nil and RoadManager:IsOnRoad(x, 0, z))
	then
		return true
	else
		return false
	end
end

local function SpawnRandomLoot(inst, loot, chance)
	if math.random() < chance then
		inst.components.lootdropper:SpawnLootPrefab(loot)
	end
end

local function SetMapIcon(inst, imgname)
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon(imgname or "myth_plant_bamboo.tex")
end

local function AddGrowTimer_dig(inst, grownname, time)
	inst.canGrow = true
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("growup", time)
	inst:ListenForEvent("timerdone", function(inst, data)
		if data.name == "growup" then
			inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")

			local newtree = SpawnPrefab(grownname)
			if newtree ~= nil then
				newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.replacedTree = newtree
			end
			inst:Remove()
		end
	end)

	inst.components.burnable:SetOnIgniteFn(function(inst)
		inst.components.timer:PauseTimer("growup")
	end)
	inst.components.burnable:SetOnExtinguishFn(function(inst)
		inst.components.timer:ResumeTimer("growup")
	end)
end

local function AddMagicGrow(inst) --这样写的话，一次只能生长一个阶段，但懒得再优化了
	inst:AddComponent("growable")
	inst.components.growable.stages = {}
	inst.components.growable:StopGrowing()
	inst.components.growable.domagicgrowthfn = function(inst, doer)
		if inst.canGrow then
			inst.components.timer:StopTimer("growup")
			inst:PushEvent("timerdone", { name = "growup" })
		end
	end
end

local function SetRandomColor(inst)
	local color = 0.7 + math.random() * 0.3
	inst.AnimState:SetMultColour(color, color, color, 1)
end

local function SetAnimData(inst)
	if inst.taskAnim ~= nil then
		inst.taskAnim:Cancel()
		inst.taskAnim = nil
	end
	if inst.animData ~= nil then
		if inst.animData.bank then
			inst.AnimState:SetBank(inst.animData.bank)
		end
		if inst.animData.build then
			inst.AnimState:SetBuild(inst.animData.build)
		end
		if inst.animData.anim then
			inst.AnimState:PlayAnimation(inst.animData.anim, true)
		end
	end
	SetRandomColor(inst)
end

-----

local function MakeBambooDig(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddSoundEmitter()
			inst.entity:AddAnimState()
			inst.entity:AddNetwork()

			inst:AddTag("plant")
			inst:AddTag("myth_plant_bamboo")

			if data.fn_common ~= nil then
				data.fn_common(inst)
			end

			inst.entity:SetPristine()

			if not TheWorld.ismastersim then
				return inst
			end

			-- inst.persists = false
			inst.groupLeader = nil
			inst.canGrow = false
			inst.replacedTree = nil

			inst:AddComponent("inspectable")

			inst:AddComponent("lootdropper")

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
        	inst.components.workable:SetWorkLeft(DigMap[data.name])
			inst.components.workable:SetOnWorkCallback(function(inst, doer, workleft, numworks)
				if inst.groupLeader ~= nil and inst.groupLeader.OnWorkGroup ~= nil then
					inst.groupLeader.OnWorkGroup(inst.groupLeader, doer, inst, numworks)
				elseif inst.OnWorkGroup ~= nil then
					inst.OnWorkGroup(inst, doer)
				end
			end)
			inst.components.workable:SetOnFinishCallback(function(inst, doer)
				if inst.groupLeader ~= nil then
					return
				end
				if inst.OnWorkGroupFinish ~= nil then
					inst.OnWorkGroupFinish(inst, doer)
				else
					inst:Remove()
				end
			end)

			MakeHauntableWork(inst)

			MakeSmallBurnable(inst)
			MakeSmallPropagator(inst)
			inst.components.burnable:SetOnBurntFn(function(inst)
				SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:Remove()
			end)

			if data.fn_server ~= nil then
				data.fn_server(inst)
			end

			return inst
		end,
		{
			Asset("ANIM", "anim/myth_plant_bamboo.zip"),
		},
		data.prefabs
	))
end

local function MakeBambooChop(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddSoundEmitter()
			inst.entity:AddAnimState()
			inst.entity:AddNetwork()

			inst:AddTag("myth_plant_bamboo")

			if data.fn_common ~= nil then
				data.fn_common(inst)
			end

			inst.entity:SetPristine()

			if not TheWorld.ismastersim then
				return inst
			end

			-- inst.persists = false
			inst.groupLeader = nil
			inst.canGrow = false
			inst.replacedTree = nil
			inst.animData = nil
			inst.taskAnim = nil

			inst:AddComponent("inspectable")

			inst:AddComponent("lootdropper")

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.CHOP)
        	inst.components.workable:SetWorkLeft(DigMap[data.name])
			inst.components.workable:SetOnWorkCallback(function(inst, doer, workleft, numworks)
				if inst.groupLeader ~= nil and inst.groupLeader.OnWorkGroup ~= nil then
					inst.groupLeader.OnWorkGroup(inst.groupLeader, doer, inst, numworks)
				elseif inst.OnWorkGroup ~= nil then
					inst.OnWorkGroup(inst, doer)
				end
			end)
			inst.components.workable:SetOnFinishCallback(function(inst, doer)
				if inst.groupLeader ~= nil then
					return
				end
				if inst.OnWorkGroupFinish ~= nil then
					inst.OnWorkGroupFinish(inst, doer)
				else
					inst:Remove()
				end
			end)

			MakeHauntableWork(inst)

			if data.fn_server ~= nil then
				data.fn_server(inst)
			end

			return inst
		end,
		{
			Asset("ANIM", "anim/myth_plant_bamboo.zip"),
		},
		data.prefabs
	))
end

--------------------------------------------------------------------------
--[[ 种下的竹笋 ]]
--------------------------------------------------------------------------

MakeBambooDig({
	name = "myth_plant_bamboo_0",
	prefabs = { "myth_bamboo_shoots", "myth_plant_bamboo_2", "bambooplant_family_myth", "bambooplant_group_myth" },
	fn_common = function(inst)
		inst.AnimState:SetBank("plant_bamboo_short")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("short_0", true)

		inst:AddTag("tree")
	end,
	fn_server = function(inst)
		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_0")

		-- inst.OnWorkGroup = function(inst, doer)
		-- end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst:Remove()
		end

		inst.InitMyFamily = function(inst)
			local noFamily = false
			local familyInst = FindEntity(inst, RangeFamily+1,
				function(target)
					if target and target:IsValid() and target.prefab == "bambooplant_family_myth" then
						return true
					end
					return false
				end,
				nil, {"FX", "shadow", "playerghost", "INLIMBO"}, nil
			)
			if familyInst == nil then
				noFamily = true
				familyInst = SpawnPrefab("bambooplant_family_myth")
				if familyInst ~= nil then
					familyInst.Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
			end

			if familyInst ~= nil then
				local groupInst = SpawnPrefab("bambooplant_group_myth")
				if groupInst ~= nil then
					if groupInst.OnMemberAdded ~= nil then
						groupInst.OnMemberAdded(groupInst, inst)
					end
					if not noFamily and familyInst.OnGroupAdded ~= nil then
						familyInst.OnGroupAdded(familyInst, groupInst)
					end
				end
			end
		end

		AddGrowTimer_dig(inst, "myth_plant_bamboo_2", TUNING.TOTAL_DAY_TIME * 2)
		AddMagicGrow(inst)
	end
})

--------------------------------------------------------------------------
--[[ 竹芽 ]]
--------------------------------------------------------------------------

MakeBambooDig({
	name = "myth_plant_bamboo_1",
	prefabs = { "myth_bamboo_shoots", "myth_plant_bamboo_2" },
	fn_common = function(inst)
		inst.AnimState:SetBank("plant_bamboo_short")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("short_1", true)

		inst:AddTag("tree")
	end,
	fn_server = function(inst)
		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_0")

		-- inst.OnWorkGroup = function(inst, doer)
		-- end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst:Remove()
		end

		AddGrowTimer_dig(inst, "myth_plant_bamboo_2", TUNING.TOTAL_DAY_TIME * 3)
		AddMagicGrow(inst)
	end
})

--------------------------------------------------------------------------
--[[ 竹苗 ]]
--------------------------------------------------------------------------

MakeBambooDig({
	name = "myth_plant_bamboo_2",
	prefabs = { "myth_bamboo_shoots", "myth_plant_bamboo_3" },
	fn_common = function(inst)
		inst.AnimState:SetBank("plant_bamboo_short")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("short_2", true)

		inst:AddTag("tree")
	end,
	fn_server = function(inst)
		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_2")

		-- inst.OnWorkGroup = function(inst, doer)
		-- end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst:Remove()
		end

		SetRandomColor(inst)
		AddGrowTimer_dig(inst, "myth_plant_bamboo_3", TUNING.TOTAL_DAY_TIME * 1)
		AddMagicGrow(inst)
	end
})

--------------------------------------------------------------------------
--[[ 竹桩 ]]
--------------------------------------------------------------------------

MakeBambooDig({
	name = "myth_plant_bamboo_stump",
	prefabs = { "myth_bamboo" },
	fn_common = function(inst)
		inst.AnimState:SetBank("plant_bamboo_mild_1")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("stump")

		inst:AddTag("stump")
	end,
	fn_server = function(inst)
		inst.canGrow = false
		inst.animData = { bank = "plant_bamboo_mild_"..math.random(3), build = "myth_plant_bamboo", anim = "stump" }
		inst.taskAnim = nil

		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_stump")

		-- inst.OnWorkGroup = function(inst, doer)
		-- end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst:Remove()
		end

		inst.taskAnim = inst:DoTaskInTime(0, SetAnimData)

		inst.OnSave = function(inst, data)
			if inst.animData ~= nil then
				data.animData = inst.animData
			end
		end
		inst.OnLoad = function(inst, data, newents)
			if data ~= nil then
				if data.animData ~= nil then
					inst.animData = data.animData
					SetAnimData(inst)
				end
			end
		end
	end
})

--------------------------------------------------------------------------
--[[ 竹株 ]]
--------------------------------------------------------------------------

local function InitPlant3(inst)
	SetAnimData(inst)

	if inst.canGrow then
		if not inst.components.timer:TimerExists("growup") then
			inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 2)
		end
	else
		inst.components.timer:StopTimer("growup")
	end
end

MakeBambooChop({
	name = "myth_plant_bamboo_3",
	prefabs = { "myth_bamboo", "myth_plant_bamboo_4", "myth_plant_bamboo_stump", "myth_plant_bamboo_burnt" },
	fn_common = function(inst)
		MakeObstaclePhysics(inst, 0.13)
		inst:AddTag("plant")
		inst:AddTag("tree")

		inst.AnimState:SetBank("plant_bamboo_mild_1")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("idle", true)
	end,
	fn_server = function(inst)
		inst.canGrow = math.random() < 0.5
		inst.animData = { bank = "plant_bamboo_mild_"..math.random(3), build = "myth_plant_bamboo", anim = "idle" }

		MakeMediumBurnable(inst)
		MakeMediumPropagator(inst)
		inst.components.burnable:SetOnIgniteFn(function(inst)
			if inst.canGrow then
				inst.components.timer:PauseTimer("growup")
			end
		end)
		inst.components.burnable:SetOnExtinguishFn(function(inst)
			if inst.canGrow then
				inst.components.timer:ResumeTimer("growup")
			end
		end)
		inst.components.burnable:SetOnBurntFn(function(inst)
			local newtree = SpawnPrefab("myth_plant_bamboo_burnt")
			if newtree ~= nil then
				newtree.animData = { bank = inst.animData.bank, build = inst.animData.build, anim = "burnt" }
				newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.replacedTree = newtree
			end
			SpawnRandomLoot(inst, "ash", 0.4)

			inst:Remove()
		end)

		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", function(inst, data)
			if data.name == "growup" then
				inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")

				local newtree = SpawnPrefab("myth_plant_bamboo_4")
				if newtree ~= nil then
					newtree.animData = { bank = "plant_bamboo_tall_"..math.random(3), build = "myth_plant_bamboo", anim = "idle" }
					newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.replacedTree = newtree
				end
				inst:Remove()
			end
		end)
		AddMagicGrow(inst)

		inst.taskAnim = inst:DoTaskInTime(0, InitPlant3)

		inst.OnSave = function(inst, data)
			if inst.animData ~= nil then
				data.animData = inst.animData
			end
			data.canGrow = inst.canGrow
		end
		inst.OnLoad = function(inst, data, newents)
			if data ~= nil then
				if data.animData ~= nil then
					inst.animData = data.animData
				end
				if data.canGrow ~= nil then
					inst.canGrow = data.canGrow == true
				end
			end
			InitPlant3(inst)
		end

		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_3")

		inst.OnWorkGroup = function(inst, doer)
			inst.AnimState:PlayAnimation("chop")
			inst.AnimState:PushAnimation("idle", true)
		end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst.AnimState:PlayAnimation("down")
			inst:ListenForEvent("animover", function(inst)
				local newtree = SpawnPrefab("myth_plant_bamboo_stump")
				if newtree ~= nil then
					newtree.animData = { bank = inst.animData.bank, build = inst.animData.build, anim = "stump" }
					newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.replacedTree = newtree
				end
				inst:Remove()
			end)
		end

	end
})

--------------------------------------------------------------------------
--[[ 竹树 ]]
--------------------------------------------------------------------------

local function StartTimer4(inst)
	inst.canGrow = true
	if not inst.components.timer:TimerExists("growup") then
		inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 2)
	end
end

local function InitPlant4(inst)
	SetAnimData(inst)

	if inst.canGrow then
		StartTimer4(inst)
	else
		inst.components.timer:StopTimer("growup")
	end
end

MakeBambooChop({
	name = "myth_plant_bamboo_4",
	prefabs = { "myth_bamboo", "myth_plant_bamboo_5", "myth_plant_bamboo_stump", "myth_plant_bamboo_burnt" },
	fn_common = function(inst)
		MakeObstaclePhysics(inst, 0.17)
		inst:AddTag("plant")
		inst:AddTag("tree")

		inst.AnimState:SetBank("plant_bamboo_tall_1")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("idle", true)
	end,
	fn_server = function(inst)
		inst.animData = { bank = "plant_bamboo_tall_"..math.random(3), build = "myth_plant_bamboo", anim = "idle" }

		MakeMediumBurnable(inst)
		MakeMediumPropagator(inst)
		inst.components.burnable:SetOnIgniteFn(function(inst)
			if inst.canGrow then
				inst.components.timer:PauseTimer("growup")
			end
		end)
		inst.components.burnable:SetOnExtinguishFn(function(inst)
			if inst.canGrow then
				inst.components.timer:ResumeTimer("growup")
			end
		end)
		inst.components.burnable:SetOnBurntFn(function(inst)
			local newtree = SpawnPrefab("myth_plant_bamboo_burnt")
			if newtree ~= nil then
				newtree.animData = { bank = inst.animData.bank, build = inst.animData.build, anim = "burnt" }
				newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.replacedTree = newtree
			end
			SpawnRandomLoot(inst, "ash", 0.7)

			inst:Remove()
		end)

		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", function(inst, data)
			if data.name == "growup" then
				inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")

				local newtree = SpawnPrefab("myth_plant_bamboo_5")
				if newtree ~= nil then
					newtree.animData = { bank = "plant_bamboo_supertall_"..math.random(3), build = "myth_plant_bamboo", anim = "idle" }
					newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.replacedTree = newtree
				end
				inst:Remove()
			end
		end)
		AddMagicGrow(inst)

		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_4")

		inst.taskAnim = inst:DoTaskInTime(0, InitPlant4)

		inst.OnSave = function(inst, data)
			if inst.animData ~= nil then
				data.animData = inst.animData
			end
			data.canGrow = inst.canGrow
		end
		inst.OnLoad = function(inst, data, newents)
			if data ~= nil then
				if data.animData ~= nil then
					inst.animData = data.animData
				end
				if data.canGrow ~= nil then
					inst.canGrow = data.canGrow == true
				end
			end
			InitPlant4(inst)
		end

		inst.OnWorkGroup = function(inst, doer)
			inst.AnimState:PlayAnimation("chop")
			inst.AnimState:PushAnimation("idle", true)
		end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst.AnimState:PlayAnimation("down")
			inst:ListenForEvent("animover", function(inst)
				local newtree = SpawnPrefab("myth_plant_bamboo_stump")
				if newtree ~= nil then
					newtree.animData = { bank = inst.animData.bank, build = inst.animData.build, anim = "stump" }
					newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.replacedTree = newtree
				end
				inst:Remove()
			end)
		end

	end
})

--------------------------------------------------------------------------
--[[ 苍竹 ]]
--------------------------------------------------------------------------

local function InitPlant5(inst)
	SetAnimData(inst)
end

MakeBambooChop({
	name = "myth_plant_bamboo_5",
	prefabs = { "myth_bamboo", "myth_greenbamboo", "myth_plant_bamboo_stump", "myth_plant_bamboo_burnt" },
	fn_common = function(inst)
		MakeObstaclePhysics(inst, 0.2)
		inst:AddTag("plant")
		inst:AddTag("tree")

		inst.AnimState:SetBank("plant_bamboo_supertall_1")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("idle", true)
	end,
	fn_server = function(inst)
		inst.canGrow = false
		inst.animData = { bank = "plant_bamboo_supertall_"..math.random(3), build = "myth_plant_bamboo", anim = "idle" }

		MakeMediumBurnable(inst)
		MakeMediumPropagator(inst)
		inst.components.burnable:SetOnBurntFn(function(inst)
			local newtree = SpawnPrefab("myth_plant_bamboo_burnt")
			if newtree ~= nil then
				newtree.animData = { bank = inst.animData.bank, build = inst.animData.build, anim = "burnt" }
				newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.replacedTree = newtree
			end
			SpawnRandomLoot(inst, "ash", 1)

			inst:Remove()
		end)

		-- inst:AddComponent("timer")

		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_5")

		inst.taskAnim = inst:DoTaskInTime(0, InitPlant5)

		inst.OnSave = function(inst, data)
			if inst.animData ~= nil then
				data.animData = inst.animData
			end
		end
		inst.OnLoad = function(inst, data, newents)
			if data ~= nil then
				if data.animData ~= nil then
					inst.animData = data.animData
					InitPlant5(inst)
				end
			end
		end

		inst.OnWorkGroup = function(inst, doer)
			inst.AnimState:PlayAnimation("chop")
			inst.AnimState:PushAnimation("idle", true)
		end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst.AnimState:PlayAnimation("down")
			inst:ListenForEvent("animover", function(inst)
				local newtree = SpawnPrefab("myth_plant_bamboo_stump")
				if newtree ~= nil then
					newtree.animData = { bank = inst.animData.bank, build = inst.animData.build, anim = "stump" }
					newtree.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.replacedTree = newtree
				end
				inst:Remove()
			end)
		end

	end
})

--------------------------------------------------------------------------
--[[ 烧焦的竹子 ]]
--------------------------------------------------------------------------

MakeBambooChop({
	name = "myth_plant_bamboo_burnt",
	prefabs = { "charcoal" },
	fn_common = function(inst)
		MakeObstaclePhysics(inst, 0.15)
		inst:AddTag("burnt")
		inst:AddTag("tree")

		inst.AnimState:SetBank("plant_bamboo_mild_1")
		inst.AnimState:SetBuild("myth_plant_bamboo")
		inst.AnimState:PlayAnimation("burnt", true)
	end,
	fn_server = function(inst)
		inst.canGrow = false
		inst.animData = { bank = "plant_bamboo_mild_"..math.random(3), build = "myth_plant_bamboo", anim = "burnt" }

		-- inst:AddComponent("timer")

		inst.components.lootdropper:SetChanceLootTable("myth_plant_bamboo_burnt")

		inst.taskAnim = inst:DoTaskInTime(0, SetAnimData)

		inst.OnSave = function(inst, data)
			if inst.animData ~= nil then
				data.animData = inst.animData
			end
		end
		inst.OnLoad = function(inst, data, newents)
			if data ~= nil then
				if data.animData ~= nil then
					inst.animData = data.animData
					SetAnimData(inst)
				end
			end
		end

		-- inst.OnWorkGroup = function(inst, doer)
		-- end
		inst.OnWorkGroupFinish = function(inst, doer)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            inst.AnimState:PlayAnimation("chop_burnt")
			inst:ListenForEvent("animover", function(inst)
				inst:Remove()
			end)
		end

	end
})

--------------------------------------------------------------------------
--[[ 竹组管理器 ]]
--------------------------------------------------------------------------

local function UpdateWorkCounts(inst)
	local workCounts = { chop = 0, dig = 0 }

	if inst.groupData ~= nil then
		for k,v in pairs(inst.groupData) do
			if v ~= nil then
				if ChopMap[v.prefab] ~= nil then
					workCounts.chop = workCounts.chop + ChopMap[v.prefab]
				elseif DigMap[v.prefab] ~= nil then
					workCounts.dig = workCounts.dig + DigMap[v.prefab]
				end
			end
		end
	end

	inst.workCounts = workCounts
end

local function InitMember_group(inst, tree)
	-- tree.persists = false
	tree.groupLeader = inst
	inst:ListenForEvent("onremove", inst.OnMemberRemoved, tree)
end

local function OnIsRaining_group(inst)
	if inst.taskGrow ~= nil then
		inst.taskGrow:Cancel()
		inst.taskGrow = nil
	end

	if TheWorld.state.israining then
		inst.taskGrow = inst:DoPeriodicTask(15, function()
			if math.random() < Chances.memberGrow and inst.groupData ~= nil then
				for k,v in pairs(inst.groupData) do
					if v ~= nil then
						local listradius = { 0.6, 0.7, 0.8 }
						local x, y, z = v.Transform:GetWorldPosition()
						local newmembernum = math.random() < 0.35 and 1 or 2
						local anglebase = math.random() * 2 * PI

						for i = 1, newmembernum, 1 do
							local x2, y2, z2 = GetCalculatedPos(x, y, z, listradius[math.random(3)], anglebase+i*(2*PI/3))
							if CanPlantHere(x2, y2, z2, "myth_plant_bamboo_1")
								and #TheSim:FindEntities(x2, y2, z2, 0.51, nil, { "NOCLICK", "FX", "INLIMBO", "myth_plant_bamboo", "player" }, nil) <= 0
								and #TheSim:FindEntities(x2, y2, z2, 0.29, nil, { "NOCLICK", "FX", "INLIMBO", "player" }, nil) <= 0
							then
								local tree = SpawnPrefab("myth_plant_bamboo_1")
								if tree ~= nil then
									tree.Transform:SetPosition(x2, y2, z2)
									InitMember_group(inst, tree)
									table.insert(inst.groupData, tree)
								end
							end
						end
						inst.canGrow = true
						UpdateWorkCounts(inst)

						inst:StopWatchingWorldState("israining", inst.OnIsRaining)
						if inst.taskGrow ~= nil then
							inst.taskGrow:Cancel()
							inst.taskGrow = nil
						end

						return
					end
				end
			end
		end, 1+4*math.random())
	end
end

local function SetNewGroup(inst, newgroup)
	inst.groupData = newgroup

	if newgroup == nil then --没有成员了，则该竹组消亡
		inst:Remove()
	else 					--成员发生改变，重新设置管理器
		local possetmember = nil
		local countgroup = 0
		local countcantgrow = 0
		local oldtag = false

		for k,v in pairs(newgroup) do
			if v ~= nil then
				if
					(v.prefab == "myth_plant_bamboo_4" and v.canGrow) or
					v.prefab == "myth_plant_bamboo_5"
				then
					oldtag = true
					break
				end
			end
		end
		if inst.isOld ~= oldtag then
			if inst.familyLeader ~= nil then --因为苍竹竹组只有一组，所以一旦有变化，绝对是这一个
				inst.familyLeader.isOld = oldtag
			end
			inst.isOld = oldtag
		end

		for k,v in pairs(newgroup) do
			if v ~= nil then
				possetmember = v

				--竹组里有苍竹的话，能给其他竹株变为苍竹的机会
				if inst.isOld then
					if v.prefab == "myth_plant_bamboo_4" then
						if not v.canGrow and math.random() < 0.5 then
							StartTimer4(v)
						end
					end
				end

				if not v.canGrow then
					countcantgrow = countcantgrow + 1
				end
				countgroup = countgroup + 1
			end
		end

		if countgroup == 0 then
			inst:Remove()
			return
		end
		UpdateWorkCounts(inst)

		if possetmember ~= nil then
			inst.Transform:SetPosition(possetmember.Transform:GetWorldPosition())
		end

		if countgroup == countcantgrow then
			if countgroup == 1 then --只有停止生长的单个竹子时，再生1-2个新竹子
				inst.canGrow = true
				inst:WatchWorldState("israining", inst.OnIsRaining)
				inst:DoTaskInTime(0.2*math.random(), inst.OnIsRaining)
				return
			else
				inst.canGrow = false
			end
		else
			inst.canGrow = true
		end
		inst:StopWatchingWorldState("israining", inst.OnIsRaining)
		if inst.taskGrow ~= nil then
			inst.taskGrow:Cancel()
			inst.taskGrow = nil
		end

	end
end

table.insert(prefs, Prefab(
	"bambooplant_group_myth",
	function()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddNetwork()
		-- [[Non-networked entity]]

		SetMapIcon(inst, nil)

		-- inst:AddTag("CLASSIFIED")
		inst:AddTag("NOCLICK")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.groupData = nil
		inst.isWild = false --只有青竹岛上的竹子为true，也就是野生竹子
		inst.taskGrow = nil
		inst.workCounts = { chop = 0, dig = 0 }
		inst.familyLeader = nil
		inst.canGrow = true
		inst.isOld = false --是否为苍竹竹组

		inst.OnMemberAdded = function(inst, member)
			InitMember_group(inst, member)
			if inst.groupData == nil then
				inst.groupData = {}
			end
			table.insert(inst.groupData, member)
			SetNewGroup(inst, inst.groupData)
		end
		inst.OnMemberRemoved = function(child)
			if child ~= nil then
				inst:RemoveEventCallback("onremove", inst.OnMemberRemoved, child)

				local hasmember = false
				local newgroup = {}
				if inst.groupData ~= nil then
					for k,v in pairs(inst.groupData) do
						if v ~= nil and child ~= v then
							table.insert(newgroup, v)
							hasmember = true
						end
					end
				end
				if child.replacedTree ~= nil then
					InitMember_group(inst, child.replacedTree)
					table.insert(newgroup, child.replacedTree)
					hasmember = true

					if inst.isWild then
						if child.replacedTree.prefab == "myth_plant_bamboo_4" then --判断它能否长成苍竹
							if math.random() < Chances.groupWildOld then
								StartTimer4(child.replacedTree)
							end
						end
					elseif inst.familyLeader ~= nil and not inst.familyLeader.isOld then
						if child.replacedTree.prefab == "myth_plant_bamboo_4" then --判断它能否长成苍竹
							if math.random() < Chances.groupOld then
								StartTimer4(child.replacedTree)
								inst.familyLeader.isOld = true
							end
						elseif child.replacedTree.prefab == "myth_plant_bamboo_5" then --已有苍竹
							inst.familyLeader.isOld = true
						end
					end
				end
				SetNewGroup(inst, hasmember and newgroup or nil)
			end
		end
		inst.OnIsRaining = OnIsRaining_group
		inst.OnWorkGroup = function(inst, doer, member, numworks)
			if inst.groupData == nil then
				inst:Remove()
				return
			end
			if member.components.workable ~= nil and numworks ~= nil then
				local actiontype = nil
				if member.components.workable.action == ACTIONS.CHOP then
					actiontype = "chop"
					if member.SoundEmitter ~= nil and not (doer ~= nil and doer:HasTag("playerghost")) then
						member.SoundEmitter:PlaySound(
							doer ~= nil and doer:HasTag("beaver") and
							"dontstarve/characters/woodie/beaver_chop_tree" or
							"dontstarve/wilson/use_axe_tree"
						)
					end

					local heightbase = nil
					if member.prefab == "myth_plant_bamboo_3" then
						heightbase = 0.8
					elseif member.prefab == "myth_plant_bamboo_4" then
						heightbase = 1.2
					elseif member.prefab == "myth_plant_bamboo_5" then
						heightbase = 1.6
					end
					if heightbase ~= nil then
						local x, y, z = member.Transform:GetWorldPosition()
						local x2, y2, z2 = GetCalculatedPos(x, y+heightbase+math.random()*2, z, math.random()*2)
						local fx = SpawnPrefab("myth_fx_peachleaf")
						if fx ~= nil then
							fx.Transform:SetPosition(x2, y2, z2)
						end
					end
				elseif member.components.workable.action == ACTIONS.DIG then
					actiontype = "dig"
				else
					return
				end

				inst.workCounts[actiontype] = inst.workCounts[actiontype] - numworks
				if inst.workCounts[actiontype] <= 0 then
					inst.workCounts[actiontype] = 0

					if member.SoundEmitter ~= nil and actiontype == "chop" then
						member.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
					end

					local memberWorked = {}
					for k,v in pairs(inst.groupData) do
						if
							v ~= nil and v.components.workable ~= nil
							and member.components.workable.action == v.components.workable.action
						then
							table.insert(memberWorked, v) --不直接删除成员，因为此时处在成员表的循环里，随意删除会导致循环错乱
						end
					end
					for k3,v3 in pairs(memberWorked) do
						v3.components.workable.workleft = 0
						if v3.OnWorkGroup ~= nil then
							v3.OnWorkGroup(v3, doer)
						end
						if v3.OnWorkGroupFinish ~= nil then
							v3.OnWorkGroupFinish(v3, doer)
						else
							v3:Remove()
						end
					end
				else
					member.components.workable:SetWorkLeft(DigMap[member.prefab])
					for k,v in pairs(inst.groupData) do
						if
							v ~= nil and v.components.workable ~= nil
							and v.OnWorkGroup ~= nil and member.components.workable.action == v.components.workable.action
						then
							v.OnWorkGroup(v, doer)
						end
					end
				end
			end

		end

		inst.OnSave = function(inst, data)
			if inst.isWild then
				data.isWild = true
			end

			if inst.groupData ~= nil then
				local hasmember = false
				local refs = {}

				for k,v in pairs(inst.groupData) do
					if v ~= nil and v:IsValid() then
						hasmember = true
						table.insert(refs, v.GUID)
					end
				end

				if hasmember then
					data.memberids = refs
					return refs
				end
			end
		end
		inst.OnLoad = function(inst, data, newents)
			if data ~= nil then
				if data.isWild then
					inst.isWild = true
				end
			end
		end
		inst.OnLoadPostPass = function(inst, newents, data)
			if data ~= nil and data.memberids ~= nil then
				local groupData = {}
				for k,v in pairs(data.memberids) do
					if v ~= nil then
						local member = newents[v]
						if member ~= nil then
							member = member.entity
							InitMember_group(inst, member)
							table.insert(groupData, member)
						end
					end
				end
				SetNewGroup(inst, groupData)
			else
				SetNewGroup(inst, nil)
			end
		end
		inst.OnRemoveEntity = function(inst)
			--清空竹子
			if inst.groupData ~= nil then
				for k,v in pairs(inst.groupData) do
					if v ~= nil then
						inst:RemoveEventCallback("onremove", inst.OnMemberRemoved, v)
						v:Remove()
					end
				end
				inst.groupData = nil
			end

			--野生竹子留下再生器
			if inst.isWild then
				local tree = SpawnPrefab("bambooplant_regenerate_myth")
				if tree ~= nil then
					tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
			end

			if inst.taskGrow ~= nil then
				inst.taskGrow:Cancel()
				inst.taskGrow = nil
			end
		end

		return inst
	end,
	nil,
	{
		"myth_plant_bamboo_0", "myth_plant_bamboo_1",
		"myth_plant_bamboo_2", "myth_plant_bamboo_3", "myth_plant_bamboo_4", "myth_plant_bamboo_5",
		"myth_plant_bamboo_stump", "myth_plant_bamboo_burnt",
		"bambooplant_regenerate_myth"
	}
))

--------------------------------------------------------------------------
--[[ 竹群管理器 ]]
--------------------------------------------------------------------------

local function SetNewFamily(inst, newfamily)
	inst.familyData = newfamily

	if newfamily == nil then --没有竹组了，则该竹群消亡
		inst:Remove()
	else 					--竹组发生改变，重新设置管理器的位置
		local possetgroup = nil
		local possetgroup2 = nil
		local oldTag = false

		for k,v in pairs(newfamily) do
			if v ~= nil then
				possetgroup = v
				if not v.canGrow then
					possetgroup2 = v
					break
				end

				if v.isOld then
					oldTag = true
				end
			end
		end

		if possetgroup2 ~= nil then --更偏向于以成熟竹子为中心
			inst.Transform:SetPosition(possetgroup2.Transform:GetWorldPosition())
		elseif possetgroup ~= nil then
			inst.Transform:SetPosition(possetgroup.Transform:GetWorldPosition())
		end
		inst.isOld = oldTag
	end
end

local function OnIsRaining_family(inst)
	if inst.taskRegenerate ~= nil then
		inst.taskRegenerate:Cancel()
		inst.taskRegenerate = nil
	end

	if TheWorld.state.israining then
		inst.taskRegenerate = inst:DoPeriodicTask(15, function()
			if math.random() < Chances.groupGrow then
				if inst.familyData == nil then
					return
				end

				--有停止生长的竹组，并且数量小于10时，才会长新竹组
				local countgroup = 0
				local countcantgrow = 0
				for k,v in pairs(inst.familyData) do
					if v ~= nil then
						countgroup = countgroup + 1
						if not v.canGrow then
							countcantgrow = countcantgrow + 1
						end
					end
				end
				if countgroup >= 10 or countcantgrow == 0 then
					return
				end

				local xb, yb, zb = inst.Transform:GetWorldPosition()
				local x, y, z = GetCalculatedPos(xb, yb, zb, 0.1+RangeFamily*math.random(), nil)
				if CanPlantHere(x, y, z, "myth_plant_bamboo_1")
					and #TheSim:FindEntities(x, y, z, 1.2, nil, { "NOCLICK", "FX", "INLIMBO", "player" }, nil) <= 0
				then
					local tree = SpawnPrefab("myth_plant_bamboo_1")
					local group = SpawnPrefab("bambooplant_group_myth")

					if tree == nil and group ~= nil then
						group:Remove()
						return
					elseif tree ~= nil and group == nil then
						tree:Remove()
						return
					end

					if tree ~= nil and group ~= nil then
						tree.Transform:SetPosition(x, y, z)
						if not POPULATING and tree.SoundEmitter ~= nil then
							tree.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
						end

						group.Transform:SetPosition(x, y, z)
						if group.OnMemberAdded ~= nil then
							group.OnMemberAdded(group, tree)
						end

						if inst.OnGroupAdded ~= nil then
							inst.OnGroupAdded(inst, group)
						end
					end
				end
			end
		end, 1+6*math.random())
	end
end

local function OnIsSpring_family(inst)
	if TheWorld.state.isspring then
        inst:WatchWorldState("israining", OnIsRaining_family)
		OnIsRaining_family(inst)
    else
        inst:StopWatchingWorldState("israining", OnIsRaining_family)
		if inst.taskRegenerate ~= nil then
			inst.taskRegenerate:Cancel()
			inst.taskRegenerate = nil
		end
    end
end

table.insert(prefs, Prefab(
	"bambooplant_family_myth",
	function()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		-- inst.entity:AddNetwork()
		-- [[Non-networked entity]]

		-- inst:AddTag("CLASSIFIED")
		inst:AddTag("NOCLICK")

		inst.taskRegenerate = nil
		inst.familyData = nil
		inst.isOld = false

		inst.OnGroupAdded = function(inst, group)
			group.isWild = false
			group.familyLeader = inst
			inst:ListenForEvent("onremove", inst.OnGroupRemoved, group)
			if inst.familyData == nil then
				inst.familyData = {}
			end
			table.insert(inst.familyData, group)
			SetNewFamily(inst, inst.familyData)
		end
		inst.OnGroupRemoved = function(child)
			if child ~= nil then
				inst:RemoveEventCallback("onremove", inst.OnGroupRemoved, child)

				local hasgroup = false
				local newfamily = {}
				if inst.familyData ~= nil then
					for k,v in pairs(inst.familyData) do
						if v ~= nil and child ~= v then
							table.insert(newfamily, v)
							hasgroup = true
						end
					end
				end
				SetNewFamily(inst, hasgroup and newfamily or nil)
			end
		end
		inst.OnRemoveEntity = function(inst)
			--清空竹组的数据
			if inst.familyData ~= nil then
				for k,v in pairs(inst.familyData) do
					if v ~= nil then
						inst:RemoveEventCallback("onremove", inst.OnGroupRemoved, v)
						v.familyLeader = nil
					end
				end
				inst.familyData = nil
			end

			if inst.taskRegenerate ~= nil then
				inst.taskRegenerate:Cancel()
				inst.taskRegenerate = nil
			end
		end

		inst:DoTaskInTime(0.2 + 0.4*math.random(), function()
			local x, y, z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, RangeFamily+1, nil, { "FX", "INLIMBO", "player" }, nil)
			local newfamily = {}
			local hasgroup = false

			for i, v in pairs(ents) do
				if
					v ~= nil and v.prefab == "bambooplant_group_myth" and not v.isWild and
					(v.familyLeader == nil or v.familyLeader == inst)
				then
					v.familyLeader = inst
					inst:ListenForEvent("onremove", inst.OnGroupRemoved, v)
					table.insert(newfamily, v)
					hasgroup = true
				end
			end

			if hasgroup then
				inst:WatchWorldState("isspring", OnIsSpring_family)
				OnIsSpring_family(inst)
			end
			SetNewFamily(inst, hasgroup and newfamily or nil)
		end)

		return inst
	end,
	nil,
	{ "myth_plant_bamboo_1", "bambooplant_group_myth" }
))

--------------------------------------------------------------------------
--[[ 野生的竹组管理器的再生器 ]]
--------------------------------------------------------------------------

local function OnIsRaining_regenerate(inst)
	if inst.taskRegenerate ~= nil then
		inst.taskRegenerate:Cancel()
		inst.taskRegenerate = nil
	end

	if TheWorld.state.israining then
		inst.taskRegenerate = inst:DoPeriodicTask(15, function()
			if math.random() < Chances.groupWildGrow then
				local newtreename = math.random() < 0.75 and "myth_plant_bamboo_1" or "myth_plant_bamboo_2"
				local x, y, z = inst.Transform:GetWorldPosition()

				if CanPlantHere(x, y, z, newtreename)
					and #TheSim:FindEntities(x, y, z, 1, nil, { "NOCLICK", "FX", "INLIMBO", "myth_plant_bamboo", "player" }, nil) <= 0
					and #TheSim:FindEntities(x, y, z, 0.5, nil, { "NOCLICK", "FX", "INLIMBO", "player" }, nil) <= 0
				then
					local tree = SpawnPrefab(newtreename)
					local group = SpawnPrefab("bambooplant_group_myth")

					if tree == nil and group ~= nil then
						group:Remove()
						return
					elseif tree ~= nil and group == nil then
						tree:Remove()
						return
					end

					if tree ~= nil and group ~= nil then
						tree.Transform:SetPosition(x, y, z)
						if not POPULATING and tree.SoundEmitter ~= nil then
							tree.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
						end

						group.Transform:SetPosition(x, y, z)
						group.isWild = true
						if group.OnMemberAdded ~= nil then
							group.OnMemberAdded(group, tree)
						end
					end

					if inst.taskRegenerate ~= nil then
						inst.taskRegenerate:Cancel()
						inst.taskRegenerate = nil
					end
					inst:Remove()
				end
			end
		end, 1+4*math.random())
    end
end

local function OnIsSpring_regenerate(inst)
	if TheWorld.state.isspring then
        inst:WatchWorldState("israining", OnIsRaining_regenerate)
		OnIsRaining_regenerate(inst)
    else
        inst:StopWatchingWorldState("israining", OnIsRaining_regenerate)
		if inst.taskRegenerate ~= nil then
			inst.taskRegenerate:Cancel()
			inst.taskRegenerate = nil
		end
    end
end

table.insert(prefs, Prefab(
	"bambooplant_regenerate_myth",
	function()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		-- inst.entity:AddNetwork()
		-- [[Non-networked entity]]

		inst:AddTag("CLASSIFIED")
		inst:AddTag("NOCLICK")

		inst.taskRegenerate = nil

		inst:WatchWorldState("isspring", OnIsSpring_regenerate)
		inst:DoTaskInTime(0.2*math.random(), OnIsSpring_regenerate)

		return inst
	end,
	nil,
	{ "myth_plant_bamboo_1", "myth_plant_bamboo_2", "bambooplant_group_myth" }
))

--------------------------------------------------------------------------
--[[ 新世界所需的地图上野生竹组的产生器 ]]
--------------------------------------------------------------------------

local function SpawnBambooGroup(inst)
	inst:DoTaskInTime(0.1+0.4*math.random(), function()
		local listradius = { 0.3, 0.4, 0.5 }
		local anglebase = math.random() * 2 * PI
		local x, y, z = inst.Transform:GetWorldPosition()
		local numTree = 3
		local chanceNum = math.random()

		if chanceNum < 0.2 then
			numTree = 1
		elseif chanceNum < 0.4 then
			numTree = 2
		else
			numTree = 3
		end

		local numSuccess = 0
		local groupInst = SpawnPrefab("bambooplant_group_myth")
		if groupInst == nil then
			inst:Remove()
			return
		else
			groupInst.isWild = true
			groupInst.groupData = {}
			groupInst.Transform:SetPosition(x, y, z) --一定要提前设置一下，否则会导致留在地图中心位置
		end
		for i = 1, numTree, 1 do
			local newtreename = "myth_plant_bamboo_1"
			local chanceName = math.random()
			if chanceName < 0.1 then
				newtreename = "myth_plant_bamboo_1"
			elseif chanceName < 0.25 then
				newtreename = "myth_plant_bamboo_2"
			else
				newtreename = "myth_plant_bamboo_3"
			end

			local x2, y2, z2 = GetCalculatedPos(x, y, z, listradius[math.random(3)], anglebase+i*(2*PI/3))
			if CanPlantHere(x2, y2, z2, newtreename)
				and #TheSim:FindEntities(x2, y2, z2, 0.51, nil, { "NOCLICK", "FX", "INLIMBO", "myth_plant_bamboo", "player" }, nil) <= 0
				and #TheSim:FindEntities(x2, y2, z2, 0.29, nil, { "NOCLICK", "FX", "INLIMBO", "player" }, nil) <= 0
			then
				local tree = SpawnPrefab(newtreename)
				if tree ~= nil then
					tree.animData = { bank = "plant_bamboo_mild_"..math.random(3), build = "myth_plant_bamboo", anim = "idle" }
					tree.Transform:SetPosition(x2, y2, z2)
					numSuccess = numSuccess + 1
					InitMember_group(groupInst, tree)
					table.insert(groupInst.groupData, tree)
				end
			end
		end

		if numSuccess == 0 then
			groupInst:Remove()
		else
			SetNewGroup(groupInst, groupInst.groupData)
		end
		inst:Remove()
	end)
end

table.insert(prefs, Prefab(
	"bambooplant_mapspawn_myth",
	function()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		-- inst.entity:AddNetwork()
		-- [[Non-networked entity]]

		inst:AddTag("CLASSIFIED")
		inst:AddTag("NOCLICK")

		SpawnBambooGroup(inst)

		return inst
	end,
	nil,
	{
		"myth_plant_bamboo_1",
		"myth_plant_bamboo_2", "myth_plant_bamboo_3",
		"bambooplant_group_myth"
	}
))

--------------------------------------------------------------------------
--[[ 兼容旧版本的竹子 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
	"myth_plant_bamboo",
	function()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		-- inst.entity:AddNetwork()
		-- [[Non-networked entity]]

		inst:AddTag("CLASSIFIED")
		inst:AddTag("NOCLICK")

		if math.random() < 0.2 then --让旧版本的竹子数量减少80%
			SpawnBambooGroup(inst)
		else
			inst:Remove()
		end

		return inst
	end,
	nil,
	{
		"myth_plant_bamboo_1",
		"myth_plant_bamboo_2", "myth_plant_bamboo_3",
		"bambooplant_group_myth"
	}
))

--------------------
--------------------

return unpack(prefs)