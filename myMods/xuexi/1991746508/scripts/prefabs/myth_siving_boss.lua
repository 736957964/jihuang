local assets =
{
    Asset("ANIM", "anim/myth_siving_boss.zip"),
    Asset("ANIM", "anim/buzzard_basic.zip"),

    Asset("SOUND", "sound/buzzard.fsb"), 
}

local brain = require("brains/buzzardbrain")


local function ShouldAcceptItem(inst, item)
    return item.prefab == "myth_lotus_flower"
end

local function OnGetItemFromPlayer(inst, giver, item)

    inst.numtogive = inst.numtogive + 1
    for k =1,inst.numtogive do
        inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
    end
    inst.sg:GoToState("flyaway")
end

local function onspawn(inst,pos)
    local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 3, 10)
    if offset ~= nil then
        pos.x = pos.x + offset.x
        pos.z = pos.z + offset.z	
    end
    inst.Transform:SetPosition(pos.x, 30, pos.z)
    inst.sg:GoToState("glide")
    --inst.components.timer:StartTimer("flyaway", 30)
end

local function OnTimerDone(inst)
    inst.sg:GoToState("flyaway")
    for k =1,inst.numtogive do
        inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
    end  
end

local function OnAttacked(inst, data)
    if not inst.components.health:IsDead() then
        local x,y,z = inst.Transform:GetWorldPosition()
        inst.SoundEmitter:PlaySound("crane/sfx/talk_LP")
        inst.sg:GoToState("flyaway")
        local ents = TheSim:FindEntities(x,y,z, 6,nil,nil,{"player","companion"})
        for k,v in pairs(ents) do
            if v and v.components.inventory  then
                v.components.inventory:DropEquipped(true)
            end
        end
        --叫一声
    end
    if TheWorld.components.siving_boss_timer then
        TheWorld.components.siving_boss_timer:DoCd()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(1.25, 1)
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 15, .5)

    inst.AnimState:SetBank("myth_siving_boss")
    inst.AnimState:SetBuild("myth_siving_boss")
    inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("animal")
    inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.numtogive = 0

    inst.entity:SetCanSleep(false)

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(100)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(9000)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.BUZZARD_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.BUZZARD_RUN_SPEED
    
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer

    inst:AddComponent("inventory")

    inst:AddComponent("lootdropper")

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("goaway", 30)
    
    inst:SetStateGraph("SGmyth_siving_boss")

    inst:ListenForEvent("timerdone",OnTimerDone)
    inst:ListenForEvent("attacked", OnAttacked)

    inst:ListenForEvent("onremove",function()
        TUNING.MYTH_SIVING_BOSS  = nil
    end)

    inst.DoSpawn = onspawn

    TUNING.MYTH_SIVING_BOSS  = inst

    return inst
end

return Prefab("myth_siving_boss", fn, assets, prefabs)
