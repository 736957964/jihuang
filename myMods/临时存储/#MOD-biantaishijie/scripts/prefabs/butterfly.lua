local assets =
{
    Asset("ANIM", "anim/butterfly_basic.zip"),
}

local prefabs =
{
    "butterflywings",
    "butter",
    "flower",
}

local brain = require "brains/butterflybrain"

local function OnDropped(inst)
    inst.sg:GoToState("idle")
    if inst.butterflyspawner ~= nil then
        inst.butterflyspawner:StartTracking(inst)
    end
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.components.stackable ~= nil then
        while inst.components.stackable:StackSize() > 1 do
            local item = inst.components.stackable:Get()
            if item ~= nil then
                if item.components.inventoryitem ~= nil then
                    item.components.inventoryitem:OnDropped()
                end
                item.Physics:Teleport(inst.Transform:GetWorldPosition())
            end
        end
    end
end

local function OnPickedUp(inst)
    if inst.butterflyspawner ~= nil then
        inst.butterflyspawner:StopTracking(inst)
    end
end

local function OnWorked(inst, worker)
    if worker.components.inventory ~= nil then
        if inst.butterflyspawner ~= nil then
            inst.butterflyspawner:StopTracking(inst)
        end
        worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
        worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
    end
end

local function CanDeploy(inst)
    return true
end

local function OnDeploy(inst, pt) 
    local flower = SpawnPrefab("flower")
    if flower then
        flower:PushEvent("growfrombutterfly")
        flower.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
    end
end


----	被攻击时
local function OnAttacked(inst, data)
    
    ----	群体反攻玩家
    local attacker = data and data.attacker
	if attacker then
		if inst.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			inst.components.combat:SetTarget(attacker)
			----	小伙伴何在
			inst.components.combat:ShareTarget(attacker, 100, function(dude)
				return dude:HasTag("butterfly")	
			end, 20)
		end
	end
end

----	被攻击时
local function OnAttacked(inst, data)
    ----	群体反攻玩家
    local attacker = data and data.attacker
	if attacker then
		if inst.components.combat:CanTarget(attacker) and not attacker:HasTag("shadowboss") then
			inst.components.combat:SetTarget(attacker)
			----	小伙伴何在
			inst.components.combat:ShareTarget(attacker, 100, function(dude)
				return dude:HasTag("butterfly")	
			end, 20)
		end
	end
end

----	重定位目标
local function RetargetFn(inst)
    local invader = nil
    invader = FindEntity(inst, 8, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
    return invader
end
local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)     
end

local function fn()
    local inst = CreateEntity()

    --Core components
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    --Initialize physics
    MakeCharacterPhysics(inst, 1, .5)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)

    inst:AddTag("butterfly")
    inst:AddTag("flying")
    inst:AddTag("insect")
    inst:AddTag("smallcreature")
    inst:AddTag("cattoyairborne")
    inst:AddTag("wildfireprotected")

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBuild("butterfly_basic")
    inst.AnimState:SetBank("butterfly")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    inst.DynamicShadow:SetSize(.8, .5)

    MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ---------------------
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 4
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbutterfly")

    ---------------------
    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem.nobounce = true

    ------------------
    inst:AddComponent("pollinator")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
	
	----	战斗
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(2)
    inst.components.combat.hiteffectsymbol = "butterfly_body"
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:ListenForEvent("attacked", OnAttacked)

    ------------------

    ------------------
    inst:AddComponent("knownlocations")

    MakeSmallBurnableCharacter(inst, "butterfly_body")
    MakeTinyFreezableCharacter(inst, "butterfly_body")

    ------------------
    inst:AddComponent("inspectable")

    ------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("butter", 0.1)
    inst.components.lootdropper:AddRandomLoot("butterflywings", 5)
    inst.components.lootdropper.numrandomloot = 1

    ------------------
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    ------------------
    inst:AddComponent("tradable")

    ------------------
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)


    inst:SetBrain(brain)

    inst.butterflyspawner = TheWorld.components.butterflyspawner
    if inst.butterflyspawner ~= nil then
        inst.components.inventoryitem:SetOnPickupFn(inst.butterflyspawner.StopTrackingFn)
        inst:ListenForEvent("onremove", inst.butterflyspawner.StopTrackingFn)
        inst.butterflyspawner:StartTracking(inst)
    end

    MakeFeedableSmallLivestock(inst, TUNING.BUTTERFLY_PERISH_TIME, OnPickedUp, OnDropped)

    return inst
end

return Prefab("forest/common/butterfly", fn, assets, prefabs),
    MakePlacer("common/butterfly_placer", "flowers", "flowers", "f1")
