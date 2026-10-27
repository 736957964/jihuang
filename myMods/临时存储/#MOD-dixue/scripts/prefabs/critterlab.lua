local assets =
{
    Asset("ANIM", "anim/critterlab.zip"),
}


local prefabs = bosscave_animals

--获取位置(引用小红猪怪物入侵)
local function getSpawnPoint1(target)
	local pt = Vector3(target.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
	local radius = math.random(2, 8)

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	else
		return nil
	end
end

local function modifycaveboss(inst)
	local pt = getSpawnPoint1(inst)
	if pt ~= nil then
		local tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
		local canspawn = tile ~= GROUND.IMPASSABLE and tile ~= GROUND.INVALID and tile ~= 255
		if canspawn then
			local num = math.random(#prefabs)
			local boss = prefabs[num]
			if boss then
				local boss_inst = SpawnPrefab(boss)
				boss_inst.Transform:SetPosition(pt:Get())
				local boss_name = boss_inst.name
				inst:DoTaskInTime(inst.num * 2, function()
					TheNet:Announce(inst.name.."产生了"..boss_name)
				end)
			end
		else
			modifycaveboss(player, monster)
		end
	end
	
	
end

local function blink(inst)
    inst.AnimState:PlayAnimation("proximity_loop"..math.random(4))
	inst.idletask = inst:DoTaskInTime(math.random() + 1.0, blink)
end

local function onturnoff(inst)
	if inst.idletask ~= nil then
		inst.idletask:Cancel()
		inst.idletask = nil
	end
    inst.AnimState:PushAnimation("idle", false)
	inst.SoundEmitter:KillSound("loop")
end

local function onturnon(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/critter_lab/idle", "loop")
	blink(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("critterlab.png")

    inst.AnimState:SetBank("critterlab")
    inst.AnimState:SetBuild("critterlab")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("critterlab")
    inst:AddTag("antlion_sinkhole_blocker")

    --prototyper (from prototyper component) added to pristine state for optimization
    inst:AddTag("prototyper")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
		----修改
	TheWorld.components.bosscave_record:Set()
	local num = TheWorld.components.bosscave_record:Get()
	inst:AddComponent("named")
	inst.components.named:SetName(tostring(num).."   号神秘洞穴")
	inst.num = num
    MakeHauntableWork(inst)
	local temp_time = 3*TUNING.TOTAL_DAY_TIME
	inst:DoPeriodicTask(temp_time, modifycaveboss)	
	
	-------------------修改
    
    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.CRITTERLAB

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

return Prefab("critterlab", fn, assets, prefabs)
