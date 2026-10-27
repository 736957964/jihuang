local function SetRandomColor(inst)
	local color = .7 + math.random() * .3
	inst.AnimState:SetMultColour(color, color, color, 1)
end

local function SetRandomAnimTime(inst)
	--设置动画的随机播放比例，这样就不会看起来所有作物都在做一样的动作  这是时间线 不是比例(百分比)
	inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
end

----------------------
--桃树芽
----------------------

local assets_sprout =
{
	Asset("ANIM", "anim/myth_peachtree.zip"),
}

local prefabs_sprout =
{
	"twigs",
	"peachsapling_myth",
}

local function StopGrowing_sprout(inst)
    inst.components.timer:StopTimer("grow")
end

local function OnTimerDone_sprout(inst, data)
    if data.name == "grow" then
        local tree = SpawnPrefab(inst.growprefab)
		if tree then
			tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
			if tree.StartGrowing ~= nil then
				tree:StartGrowing()
			end
			if tree.SoundEmitter ~= nil then
				tree.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
			end
			inst:Remove()
		end
    end
end

local function StartGrowing_sprout(inst)
	if inst.components.timer ~= nil and not inst.components.timer:TimerExists("grow") then
		local growtime = GetRandomWithVariance(TUNING.TOTAL_DAY_TIME * 8, TUNING.TOTAL_DAY_TIME * 2)
		inst.components.timer:StartTimer("grow", growtime)
	end
end

local function DigUp_sprout(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function Fn_sprout()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("myth_peachtree")
	inst.AnimState:SetBuild("myth_peachtree")
	inst.AnimState:PlayAnimation("lv1_idle")

	inst:AddTag("plant")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	SetRandomColor(inst)

	inst.growprefab = "peachsapling_myth"
	inst.StartGrowing = StartGrowing_sprout

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone_sprout)
	inst.StartGrowing(inst)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"twigs"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUp_sprout)
	inst.components.workable:SetWorkLeft(1)

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	inst:ListenForEvent("onignite", StopGrowing_sprout)
	inst:ListenForEvent("onextinguish", StartGrowing_sprout)
	MakeSmallPropagator(inst)

	MakeHauntableIgnite(inst)

	return inst
end

----------------------
--桃树苗
----------------------

local prefabs_sapling =
{
    "log",
	"charcoal",
	"twigs",
	"peachtree_myth",
}

local function Fn_sapling()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .2)

	inst.MiniMapEntity:SetIcon("peachtree.tex")
	inst.MiniMapEntity:SetPriority(-1)

	inst.AnimState:SetBank("myth_peachtree")
	inst.AnimState:SetBuild("myth_peachtree")
	inst.AnimState:PlayAnimation("lv2_idle", true)

	inst:AddTag("plant")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	SetRandomColor(inst)
	SetRandomAnimTime(inst)

	inst.growprefab = "peachtree_myth"
	inst.StartGrowing = StartGrowing_sprout

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone_sprout)
	inst.StartGrowing(inst)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({ "twigs", "twigs", "log" })

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUp_sprout)
	inst.components.workable:SetWorkLeft(3)

	MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
	MakeMediumPropagator(inst)
	inst.components.burnable:SetFXLevel(5)
	inst:ListenForEvent("onignite", StopGrowing_sprout)
	inst:ListenForEvent("onextinguish", StartGrowing_sprout)
	inst.components.burnable:SetOnBurntFn(function(inst)
		inst.components.lootdropper:SpawnLootPrefab("charcoal")
		if math.random() < 0.33 then
			inst.components.lootdropper:SpawnLootPrefab("charcoal")
		end
		-- SpawnPrefab("charcoal").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:Remove()
	end)

	MakeHauntableIgnite(inst)

	return inst
end

----------------------
--桃树桩
----------------------

local prefabs_stump =
{
    "log",
}

local function Fn_stump()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("myth_peachtree")
	inst.AnimState:SetBuild("myth_peachtree")
	inst.AnimState:PlayAnimation("lv3_stump")

	inst:AddTag("plant")
	inst:AddTag("stump")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	SetRandomColor(inst)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUp_sprout)
	inst.components.workable:SetWorkLeft(1)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	MakeHauntableIgnite(inst)

	return inst
end

----------------------
--烧焦桃树
----------------------

local prefabs_burnt =
{
    "charcoal",
}

local function FallAndDropLoot(inst, doer, animPre)
    local pt = inst:GetPosition()
    local he_right = true

    if doer then
        local hispos = doer:GetPosition()
        he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    else
        if math.random() > 0.5 then
            he_right = false
        end
    end

    if he_right then
		inst.AnimState:PlayAnimation(animPre.."left")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation(animPre.."right")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end

	if inst:HasTag("burnt") then
		inst.components.lootdropper:SpawnLootPrefab("charcoal")
		inst.components.lootdropper:SpawnLootPrefab("charcoal")
	end
end

local function Fn_burnt()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .25)

	inst.AnimState:SetBank("myth_peachtree")
	inst.AnimState:SetBuild("myth_peachtree")
	inst.AnimState:PlayAnimation("lv3_burnt")

	inst:AddTag("plant")
	inst:AddTag("burnt")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	SetRandomColor(inst)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(function(inst, chopper)
		inst:RemoveComponent("workable")
		RemovePhysicsColliders(inst)
		inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
		if not (chopper ~= nil and chopper:HasTag("playerghost")) then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
		end
		FallAndDropLoot(inst, chopper, "lv3_burnt_chop")
		inst:ListenForEvent("animover", inst.Remove)
	end)

	MakeHauntableIgnite(inst)

	return inst
end

----------------------
--桃树
----------------------

local assets_tree =
{
	Asset("ANIM", "anim/myth_peachtree.zip"),
}

local prefabs_tree =
{
	"log",
	"twigs",
	"petals",
	"peachstump_myth",
	"peachtreeburnt_myth",
	"peach",
	"bigpeach",
	"myth_fx_peachleaf",
	"myth_fx_peachflower",
	"peachtreeregenerated_myth",
}

local workLeft_tree = 18

local function GetSpawnPoint(inst, radius)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = radius or math.random() * 2
    local angle = math.random() * 2 * PI
    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function YouAreNaughty(kid, num)
	if kid ~= nil and kid:HasTag("player") then
		TheWorld:PushEvent("ms_forcenaughtiness", { player = kid, numspawns = num or math.random(1, 3) })
	end
end

-----

local easing = require("easing")

local function OnFalling(inst, startpos, starttime, duration)
	local t = math.max(0, GetTime() - starttime)
	local pos = startpos + (inst.fallingpos - startpos) * easing.inOutQuad(t, 0, 1, duration)
    if t < duration and pos.y > 0 then
        inst.Transform:SetPosition(pos:Get())
    else
        inst.Physics:Teleport(inst.fallingpos:Get())
        inst.fallingtask:Cancel()
        inst.fallingtask = nil
        inst.fallingpos = nil
        if inst.components.inventoryitem ~= nil then
			inst.components.inventoryitem.canbepickedup = true
		end

		local someone = FindEntity(inst, 1,
			function(target)
				if target and target:IsValid() and
					target.components.combat ~= nil and
					target.components.health ~= nil and not target.components.health:IsDead()
				then
					return true
				end
				return false
			end,
			{"_combat", "_health"}, {"NOCLICK", "FX", "shadow", "playerghost", "INLIMBO"}, nil
		)
		if someone ~= nil then
			if not (someone.components.inventory and someone.components.inventory:EquipHasTag("myth_ruyi")) then
				someone.components.combat:GetAttacked(inst, inst.isRare and 24 or 6, nil)
			end
		end
		inst.isRare = nil
    end
end

local function SpawnFx(inst, x, y, z)
	local fxName = inst.components.growable.stage == 2 and "myth_fx_peachflower" or "myth_fx_peachleaf"
	SpawnPrefab(fxName).Transform:SetPosition(x, y, z)
end

local function DropFruit(inst, isRare, x, y, z)
	SpawnFx(inst, x, y + 1 + math.random() * 2, z)

	local fruit = SpawnPrefab(isRare and "bigpeach" or "peach")
	if fruit ~= nil then
		fruit.isRare = isRare
		fruit.Transform:SetPosition(x, y + 2, z)
		fruit.fallingpos = fruit:GetPosition()
		fruit.fallingpos.y = 0
		if fruit.components.inventoryitem ~= nil then
			fruit.components.inventoryitem.canbepickedup = false
		end
		fruit.fallingtask = fruit:DoPeriodicTask(FRAMES, OnFalling, 0, fruit:GetPosition(), GetTime(), 5 * FRAMES)
    end
end

-----

local function GetFruitNumber(inst, doer)
	local res = { hand = 0, ground = 0, rare = 0, all = 3 }
	for i = 1, 2 do
		if math.random() <= 0.45 then
			res.all = res.all + 1
		end
	end
	if
		doer ~= nil
		and (
			doer.prefab == "monkey_king" or doer.prefab == "white_bone"
			or doer.prefab == "winona" or doer.prefab == "wormwood" or doer.prefab == "wes"
			or doer:HasTag("cleverhands")
		)
	then
		res.hand = res.all
	else
		for i = 1, res.all do
			if math.random() <= 0.35 then
				res.ground = res.ground + 1
			else
				res.hand = res.hand + 1
			end
		end
	end
	local rare = doer ~= nil and doer.components.inventory and doer.components.inventory:EquipHasTag("myth_ruyi")  and 0.04 or 0.02
	if math.random() <= rare then
		res.rare = 1
	end

	return res
end

local function OnPicked(inst, picker)
	local fruitData = GetFruitNumber(inst, picker)
	if fruitData.ground > 0 then
		for i = 1, fruitData.ground do
			if picker ~= nil and math.random() < 0.35 then
				DropFruit(inst, false, GetSpawnPoint(picker))
			else
				DropFruit(inst, false, GetSpawnPoint(inst))
			end
		end
	end
	if fruitData.rare > 0 then
		if picker ~= nil then
			DropFruit(inst, true, GetSpawnPoint(picker))
			YouAreNaughty(picker)
		else
			DropFruit(inst, true, GetSpawnPoint(inst))
		end
	end

	if fruitData.hand > 0 then
		if picker ~= nil and picker.components.inventory ~= nil then
			local loot = SpawnPrefab("peach")
			if loot ~= nil then
				if loot.components.inventoryitem ~= nil then
					loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
				end
				if loot.components.stackable ~= nil then
					loot.components.stackable:SetStackSize(fruitData.hand)
				end
				picker:PushEvent("picksomething", { object = inst, loot = loot })
				picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
			end
		else
			for i = 1, fruitData.hand do
				DropFruit(inst, false, GetSpawnPoint(inst))
			end
		end
	end

	local growable = inst.components.growable
	if growable ~= nil then
		if growable.targettime == nil and growable.pausedremaining == nil then
			--neither started nor paused, which means we're fully stopped
			return
		end

		local stage = 1
		if not growable.growonly then
			growable:SetStage(stage)
		end
		if growable.stages[stage] ~= nil and growable.stages[stage].growfn ~= nil then
			growable.stages[stage].growfn(growable.inst)
		end
		if growable.stage < #growable.stages or growable.loopstages then
			growable:StartGrowing()
		end
	end
end

local function SetRandomIdleAnim(inst, isPush)
	if isPush then
		inst.AnimState:PushAnimation(math.random() > 0.5 and "lv3_idle" or "lv3_idle2", true)
	else
		inst.AnimState:PlayAnimation(math.random() > 0.5 and "lv3_idle" or "lv3_idle2", true)
	end
end

local function OnSnowCoveredChagned(inst, covered)
    if TheWorld.state.issnowcovered then
		inst.AnimState:OverrideSymbol("snow", "myth_peachtree", "snow")
	else
		inst.AnimState:OverrideSymbol("snow", "myth_peachtree", "emptysnow")
	end
end

local function SetStateFn(inst, level)
    if inst.components.workable ~= nil and inst.components.lootdropper ~= nil and inst.components.uppickable ~= nil then
		inst.components.workable:SetWorkLeft(workLeft_tree)
		if level == 1 then
			-- inst:RemoveTag("flower")
			inst.components.uppickable:SetPickable(false)
			inst.components.lootdropper:SetLoot({ "twigs", "log", "log", "log" })
		elseif level == 2 then
			--如果加了flower标签，就会导致蜜蜂能产生桃树，需要改传粉者组件来阻止蜜蜂生成非花朵的“花”
			-- inst:AddTag("flower")
			inst.components.uppickable:SetPickable(false)
			inst.components.lootdropper:SetLoot({ "twigs", "log", "log", "log", "petals", "petals", "petals", "petals", "petals" })
		elseif level == 3 then
			-- inst:RemoveTag("flower")
			inst.components.uppickable:SetPickable(true)

			--砍到桃树能得到更多蟠桃，但是无异于杀鸡取卵
			inst.components.lootdropper:SetLoot({ "twigs", "log", "log", "log", "peach", "peach", "peach" })
		end
    end
    SetRandomIdleAnim(inst, true)
end

local function SetStateGrowFn(inst, level)
	if level == 1 then
		inst.AnimState:OverrideSymbol("fruit", "myth_peachtree", "emptytop")
		inst.AnimState:OverrideSymbol("tall_leaves", "myth_peachtree", "tall_leaves")
		inst.AnimState:OverrideSymbol("flower", "myth_peachtree", "emptytop")
		inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	elseif level == 2 then
		inst.AnimState:OverrideSymbol("fruit", "myth_peachtree", "emptytop")
		inst.AnimState:OverrideSymbol("tall_leaves", "myth_peachtree", "emptytop")
		inst.AnimState:OverrideSymbol("flower", "myth_peachtree", "flower")
		inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
	elseif level == 3 then
		inst.AnimState:OverrideSymbol("fruit", "myth_peachtree", "fruit")
		inst.AnimState:OverrideSymbol("tall_leaves", "myth_peachtree", "emptytop")
		inst.AnimState:OverrideSymbol("flower", "myth_peachtree", "emptytop")
		inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
	end
	SetRandomIdleAnim(inst, true)
	inst:DoTaskInTime(0.5, function(inst)
		OnSnowCoveredChagned(inst)
	end)
end

local growthStages =
{
	{
		name = "normal",
		time = function(inst) return GetRandomWithVariance(TUNING.TOTAL_DAY_TIME * 9, TUNING.TOTAL_DAY_TIME) end,
		fn = function(inst) SetStateFn(inst, 1) end, --主要管性质的改变
		growfn = function(inst) SetStateGrowFn(inst, 1) end --主要管动画的变化
	},
	{
		name = "blooming",
		time = function(inst) return GetRandomWithVariance(TUNING.TOTAL_DAY_TIME * 9, TUNING.TOTAL_DAY_TIME) end,
		fn = function(inst) SetStateFn(inst, 2) end,
		growfn = function(inst) SetStateGrowFn(inst, 2) end
	},
	{
		name = "fruitful",
		time = function(inst) return GetRandomWithVariance(TUNING.TOTAL_DAY_TIME * 9, TUNING.TOTAL_DAY_TIME) end,
		fn = function(inst) SetStateFn(inst, 3) end,
		growfn = function(inst) SetStateGrowFn(inst, 3) end
	}
}

local function OnBurnt_tree(inst)
	SpawnPrefab("peachtreeburnt_myth").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function OnHaunt_tree(inst, haunter)
    if inst.components.workable ~= nil and math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        inst.components.workable:WorkedBy(haunter, 1)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        return true
    end
    return false
end

local function OnRemove_tree(inst)
	local tree = SpawnPrefab("peachtreeregenerated_myth")
	if tree then
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local function StartGrowing_tree(inst)
	inst.components.growable:SetStage(1)
	SetStateGrowFn(inst, 1)
	inst.isWild = false
	inst:RemoveEventCallback("onremove", OnRemove_tree)
end

-----

local function OnEntitySleep_tree(inst)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		OnBurnt_tree(inst)
	end
end

local function OnSave_tree(inst, data)
	if inst.isWild == false then
		data.isWild = false
	end
end

local function OnLoad_tree(inst, data)
	if data ~= nil then
		if data.isWild ~= nil and data.isWild == false then
			inst.isWild = false
			inst:RemoveEventCallback("onremove", OnRemove_tree)
		end
	end

	if inst.components.growable ~= nil and inst.components.growable.stage ~= nil then
		SetStateGrowFn(inst, inst.components.growable.stage)
	end
end

-----

local function OnChop_tree(inst, chopper, chopsleft, numchops)
	if not (chopper ~= nil and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound(
			chopper ~= nil and chopper:HasTag("beaver") and
			"dontstarve/characters/woodie/beaver_chop_tree" or
			"dontstarve/wilson/use_axe_tree"
		)
	end

	inst.AnimState:PlayAnimation("lv3_chop")
	SetRandomIdleAnim(inst, true)

	local x, y, z = GetSpawnPoint(inst)
	SpawnFx(inst, x, y + 1 + math.random() * 2, z)

	if inst.components.growable.stage == 3 and math.random() < 0.07 then
		if chopper ~= nil then
			DropFruit(inst, false, GetSpawnPoint(chopper))
		else
			DropFruit(inst, false, GetSpawnPoint(inst))
		end
	end

	--tell any nearby leifs to wake up
	local ents = TheSim:FindEntities(x, y, z, TUNING.LEIF_REAWAKEN_RADIUS, { "leif" })
	for i, v in ipairs(ents) do
		if v.components.sleeper ~= nil and v.components.sleeper:IsAsleep() then
			v:DoTaskInTime(math.random(), function(ent)
				ent.components.sleeper:WakeUp()
			end)
		end
		v.components.combat:SuggestTarget(chopper)
	end
end

local function find_leif_spawn_target(item)
    return not item.noleif
        and item.components.growable ~= nil
        and item.components.growable.stage <= 3
end

local function OnChopDown_tree(inst, chopper)
	if inst.components.uppickable ~= nil then
		inst.components.uppickable:SetPickable(false)
	end
	if inst.components.growable ~= nil and inst.components.growable.stage == 3 then
		local fruitData = GetFruitNumber(inst)
		if fruitData.all > 0 then
			for i = 1, fruitData.all do
				inst.components.lootdropper:AddChanceLoot("peach", 1.0)
			end
		end
		if fruitData.rare > 0 then
			inst.components.lootdropper:AddChanceLoot("bigpeach", 1.0)
			YouAreNaughty(chopper, math.random(3, 6))
		else
			YouAreNaughty(chopper)
		end
	else
		YouAreNaughty(chopper)
	end

	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	FallAndDropLoot(inst, chopper, "lv3_fall")
	inst:ListenForEvent("animover", function(inst)
		SpawnPrefab("peachstump_myth").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:Remove()
	end)
	inst:DoTaskInTime(0.4, function(inst)
		ShakeAllCameras(CAMERASHAKE.FULL, .25, .03, .5, inst, 6)
	end)

	if chopper then
		local days_survived = chopper.components.age ~= nil and chopper.components.age:GetAgeInDays() or TheWorld.state.cycles
		if days_survived >= TUNING.LEIF_MIN_DAY then
			local chance = TUNING.LEIF_PERCENT_CHANCE * 5 --树精生成率增加5倍
			if math.random() < chance then
				for k = 1, (days_survived <= 30 and 1) or math.random(days_survived <= 80 and 2 or 3) do
					local target = FindEntity(inst, TUNING.LEIF_MAXSPAWNDIST, find_leif_spawn_target, { "evergreens", "tree" }, { "leif", "stump", "burnt" })
					if target ~= nil then
						target.noleif = true
						target.leifscale = target.components.growable.stages[target.components.growable.stage].leifscale or 1
						target.chopper = chopper
						target:DoTaskInTime(1 + math.random() * 3, function(target)
							local leif = SpawnPrefab(target.build == "sparse" and "leif_sparse" or "leif")
							leif.AnimState:SetMultColour(target.AnimState:GetMultColour())
							leif:SetLeifScale(target.leifscale)
							if target.chopper ~= nil then
								leif.components.combat:SuggestTarget(target.chopper)
							end

							local x, y, z = target.Transform:GetWorldPosition()
							target:Remove()
							leif.Transform:SetPosition(x, y, z)
							leif.sg:GoToState("spawn")
						end)
					end
				end
			end
		end
	end
end

-----

local function Fn_tree()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .25)

	inst.MiniMapEntity:SetIcon("peachtree.tex")
	inst.MiniMapEntity:SetPriority(-1)

	inst.AnimState:SetBank("myth_peachtree")
	inst.AnimState:SetBuild("myth_peachtree")
	inst.AnimState:PlayAnimation("lv3_idle", true)
	inst.AnimState:OverrideSymbol("snow", "myth_peachtree", "emptysnow")
	inst.AnimState:OverrideSymbol("fruit", "myth_peachtree", "emptytop")
    inst.AnimState:OverrideSymbol("tall_leaves", "myth_peachtree", "tall_leaves")
    inst.AnimState:OverrideSymbol("flower", "myth_peachtree", "emptytop")

	inst:AddTag("shelter")
	inst:AddTag("peachtree")
	inst:AddTag("plant")
	inst:AddTag("event_trigger") --防止被暗影随从砍伐
	inst:AddTag("uppick")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	SetRandomColor(inst)
	SetRandomAnimTime(inst)

	inst.isWild = true
	inst.StartGrowing = StartGrowing_tree

	inst:WatchWorldState("issnowcovered", OnSnowCoveredChagned)

	MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
	inst.components.burnable:SetFXLevel(5)
	inst.components.burnable:SetOnBurntFn(OnBurnt_tree)
	MakeMediumPropagator(inst)

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = function(inst)
		if inst.components.growable ~= nil then
			return (inst.components.burnable ~= nil and inst.components.burnable:IsBurning() and "BURNING")
				or (inst.components.growable.stage == 2 and "BLOOM")
				or (inst.components.growable.stage == 3 and "FRUIT")
				or nil
		end
		return nil
	end

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(workLeft_tree)
	inst.components.workable:SetOnWorkCallback(OnChop_tree)
	inst.components.workable:SetOnFinishCallback(OnChopDown_tree)

	inst:AddComponent("lootdropper")

	-----

	inst:AddComponent("pickable") --这个组件只是个傀儡，真正发挥作用的是growable和uppickable
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	inst.components.pickable:SetUp("peach", 1000000)
	inst.components.pickable:Pause()
	inst.components.pickable.caninteractwith = false
	inst.components.pickable.canbepicked = false
	inst.components.pickable.onpickedfn = function(inst, picker)
		if inst.components.uppickable ~= nil then
			inst.components.uppickable:Pick(picker)
		end
	end

	inst:AddComponent("uppickable")
	inst.components.uppickable:SetOnPickedFn(OnPicked)

	-----

	local state = math.random(1, 3)
	inst:AddComponent("growable")
	inst.components.growable.stages = growthStages
	-- inst.components.growable.loopstages = true
	inst.components.growable.springgrowth = true
	inst.components.growable:SetStage(state)
	inst.components.growable:StartGrowing()
	SetStateGrowFn(inst, state)
	inst.components.growable.OnSave = function () --官方码师出来挨打。stage不存下来的话，会导致stage为1的onload时，变为随机状态
		local self = inst.components.growable
		local data =
		{
			stage = self.stage or 1, --所以这里默认也要存储1
			time = (self.pausedremaining ~= nil and math.floor(self.pausedremaining))
				or (self.targettime ~= nil and math.floor(self.targettime - GetTime()))
				or nil,
		}
		return data
	end

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(OnHaunt_tree)

	inst.OnSave = OnSave_tree
	inst.OnLoad = OnLoad_tree

	inst.OnEntitySleep = OnEntitySleep_tree
	-- inst.OnEntityWake = OnEntityWake_tree

	inst:ListenForEvent("onremove", OnRemove_tree)

	return inst
end

----------------------
--兼容旧版桃树
----------------------

local function MakeOldVersionTree(name, newTree, level)
	local function Fn_oldVersionTree()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddNetwork()

		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end

		inst:DoTaskInTime(1, function(inst)
			local tree = SpawnPrefab(newTree)
			if tree ~= nil then
				tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
				if level == 1 and tree.StartGrowing ~= nil then
					tree:StartGrowing()
				end
				inst:Remove()
			end
		end)

		return inst
	end
	return Prefab(name, Fn_oldVersionTree, nil, { newTree })
end

----------------------
--桃树再生器
----------------------

local function SetRegenerateTimer(inst)
	if inst.components.timer ~= nil and not inst.components.timer:TimerExists("regenerate") then
		local regeneratetime = GetRandomWithVariance(TUNING.TOTAL_DAY_TIME * 20, TUNING.TOTAL_DAY_TIME * 5)
		inst.components.timer:StartTimer("regenerate", regeneratetime)
	end
end

local function FindRuinedPeachTree(item)
    return item.prefab == "peachtreeburnt_myth" or item.prefab == "peachstump_myth"
end

local function OnTimerDone_regenerate(inst, data)
	if data.name == "regenerate" then
		--判断目前这个位置是否还能再生
		local x, y, z = inst.Transform:GetWorldPosition()
		local map = TheWorld.Map
		if map == nil then
			SetRegenerateTimer(inst)
			return
		end
		if map:CanPlantAtPoint(x, y, z)
            and map:CanPlacePrefabFilteredAtPoint(x, y, z, "peachtree_myth")
			and not (RoadManager ~= nil and RoadManager:IsOnRoad(x, 0, z))
			and #TheSim:FindEntities(x, y, z, 1.2, nil, { "NOCLICK", "FX", "INLIMBO", "burnt", "stump" }, nil) <= 0
		then
            --再生前，先把目前位置的桃树残留物清除掉
			local ruinedTree = FindEntity(inst, 0.5, FindRuinedPeachTree)
			if ruinedTree ~= nil then
				ruinedTree:Remove()
			end

			local tree = SpawnPrefab("peachtree_myth")
			if tree then
				tree.Transform:SetPosition(x, y, z)
				inst:Remove()
			end
		else
			SetRegenerateTimer(inst)
        end
    end
end

local function Fn_peachRegenerate()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	-- inst.entity:AddNetwork()
    --[[Non-networked entity]]

    inst:AddTag("CLASSIFIED")
	inst:AddTag("NOCLICK")

	-- inst.entity:SetPristine()
	-- if not TheWorld.ismastersim then
	-- 	return inst
	-- end

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone_regenerate)
	SetRegenerateTimer(inst)

	return inst
end

----------------------

return Prefab("peachsprout_myth", Fn_sprout, assets_sprout, prefabs_sprout),
	Prefab("peachsapling_myth", Fn_sapling, assets_sprout, prefabs_sapling),
	Prefab("peachstump_myth", Fn_stump, assets_sprout, prefabs_stump),
	Prefab("peachtreeburnt_myth", Fn_burnt, assets_sprout, prefabs_burnt),
	Prefab("peachtree_myth", Fn_tree, assets_tree, prefabs_tree),
	MakeOldVersionTree("peachtree", "peachtree_myth", 2),
	MakeOldVersionTree("peach_sapling", "peachsprout_myth", 1),
	MakeOldVersionTree("peachtree_short", "peachsapling_myth", 1),
	MakeOldVersionTree("peachtree_normal", "peachtree_myth", 2),
	MakeOldVersionTree("peachtree_tall", "peachtree_myth", 2),
	Prefab("peachtreeregenerated_myth", Fn_peachRegenerate, nil, { "peachtree_myth" })
