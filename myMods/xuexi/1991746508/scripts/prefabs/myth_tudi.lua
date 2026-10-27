local assets =
{
    Asset("ANIM", "anim/player_basic.zip"),
    Asset("ANIM", "anim/player_actions.zip"),
    Asset("ANIM", "anim/player_actions_eat.zip"),
    Asset("ANIM", "anim/player_actions_item.zip"),
    Asset("ANIM", "anim/player_actions_fishing.zip"),
    Asset("ANIM", "anim/player_actions_fishing_ocean.zip"),
    Asset("ANIM", "anim/player_actions_fishing_ocean_new.zip"),
    Asset("ANIM", "anim/player_actions_pocket_scale.zip"),
    Asset("ANIM", "anim/wilson_fx.zip"),
    Asset("ANIM", "anim/player_frozen.zip"),
    Asset("ANIM", "anim/player_shock.zip"),
    Asset("ANIM", "anim/player_wrap_bundle.zip"),
    Asset("SOUND", "sound/sfx.fsb"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset("ANIM", "anim/player_hermitcrab_idle.zip"),
    Asset("ANIM", "anim/player_hermitcrab_walk.zip"),
    Asset("ANIM", "anim/player_hermitcrab_look.zip"),
    
    Asset("ANIM", "anim/myth_tudi.zip"),
    Asset("ANIM", "anim/myth_tuqi_weapon.zip"),
}

local prefabs =
{

}

local brain = require "brains/myth_tudibrain"

--c_give("fruitfly",10)
local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "playerghost", "INLIMBO" }
local function retargetfn(inst)
    local leader = inst.components.entitytracker:GetEntity("tudimiao")
    return leader ~= nil
        and FindEntity(
            leader,
            16,
            function(guy)
                return guy.prefab == "fruitfly"
                    and inst.components.combat:CanTarget(guy)
            end,
            RETARGET_MUST_TAGS, -- see entityreplica.lua
            RETARGET_CANT_TAGS
        )
        or nil
end

local function keeptargetfn(inst, target)
    local leader = inst.components.entitytracker:GetEntity("tudimiao")
    return leader ~= nil and leader:IsValid() and inst:IsNear(leader, 16) and inst.components.combat:CanTarget(target)
end


local function miaomiao(inst,miao)
    inst.components.entitytracker:TrackEntity("tudimiao", miao)
end

local function IsTargetedByOther(inst, self, target)
    if inst ~= self and (target == inst.planttarget or target == inst.soiltarget) then
        return true
    end
    return false
end

local toys = {"myth_toy_featherbundle","myth_toy_tigerdoll","myth_toy_tumbler","myth_toy_twirldrum","myth_toy_chineseknot"}

local function OnGetItemFromPlayer(inst, giver, item)
    inst.cantakemoney = 1

    local leader = inst.components.entitytracker:GetEntity("tudimiao")
    if leader ~= nil and leader:IsValid() and not leader.components.inventory:IsFull() then
        local new = SpawnPrefab(item.prefab == "goldnugget" and "myth_coin" or item.prefab)
        leader.components.inventory:GiveItem(new)
    end
    print(giver, item)
    if giver  and giver.components.inventory then
        local toy = SpawnPrefab(toys[math.random(#toys)])
        if toy then
            giver.components.inventory:GiveItem(toy,nil,inst:GetPosition())
        end
    end

    inst.components.talker:Say(STRINGS.MYTH_TUDI_TRADE)
end

local function OnRefuseItem(inst, giver, item)
    if item:HasTag("myth_coin") then
        inst.components.talker:Say(STRINGS.MYTH_TUDI_ALREADYTRADE)
    else
        inst.components.talker:Say(STRINGS.TUDI_SHRINES_REFUSEFOOD)
    end
end

local function ShouldAcceptItem(inst, item, giver)
    return inst.cantakemoney == 0  and item:HasTag("myth_coin") and not inst.components.inventory:IsFull()
end

local function onday(inst)
    inst.cantakemoney = 0
end

local function onload(inst, data)
    if data ~= nil then
        inst.cantakemoney = data.antakemoney
    end
end

local function onsave(inst, data)
    data.antakemoney = inst.antakemoney
end

local function onremove(inst)
    local leader = inst.components.entitytracker:GetEntity("tudimiao")
    if leader and leader.tudi == inst then
        leader.tudi = nil
        leader:OnTudIRemove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    RemovePhysicsColliders(inst)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst:AddTag("character")
    inst:AddTag("companion")
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("myth_tudi")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.AnimState:Show("ARM_carry")
    inst.AnimState:Hide("ARM_normal")
    inst.AnimState:Hide("HAT")
    inst.AnimState:Hide("HAIR_HAT")
    inst.AnimState:Show("HAIR_NOHAT")
    inst.AnimState:Show("HAIR")
    inst.AnimState:Show("HEAD")
    inst.AnimState:Hide("HEAD_HAT")

    inst.AnimState:OverrideSymbol("swap_object", "myth_tuqi_weapon", "myth_tuqi_weapon")

    inst.AnimState:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
    inst.AnimState:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
    inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
    inst.AnimState:OverrideSymbol("snap_fx", "player_actions_fishing_ocean_new", "snap_fx")

    
    inst.AnimState:AddOverrideBuild("player_wrap_bundle")
    inst.AnimState:AddOverrideBuild("player_actions_fishing_ocean_new")

    inst:AddTag("trader")
    inst:AddTag("noauradamage")
    inst:AddTag("notraptrigger")
    inst:AddTag("NOBLOCK")

    inst:AddComponent("talker")        
    inst.components.talker.colour = Vector3(194/255, 149/255, 216/255)
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()
    inst.components.talker.lineduration = TUNING.HERMITCRAB.SPEAKTIME -0.5  -- it's minus one here to create a buffer between text.

    if LOC.GetTextScale() == 1 then
        inst.components.talker.fontsize = 40
    end
    inst.components.talker.font = TALKINGFONT_HERMIT

    inst:AddComponent("npc_talker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.cantakemoney  =  0
    inst.takecarenum = math.random(3,5)

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.HERMITCRAB.RUNSPEED
    inst.components.locomotor.walkspeed = TUNING.HERMITCRAB.WALKSPEED

    ------------------------------------------
    --inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.FRUITFLY_HEALTH)
    inst.components.combat:SetAttackPeriod(TUNING.WILSON_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, retargetfn)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetRange(2)

    inst:AddComponent("named")

    inst:AddComponent("entitytracker")
    local old_TrackEntity = inst.components.entitytracker.TrackEntity
    inst.components.entitytracker.TrackEntity = function (self,name, inst)
        old_TrackEntity(self,name, inst)
        if inst then
            inst.tudi = self.inst
        end
    end

    inst:AddComponent("inventory")
    local oldGiveItem = inst.components.inventory.GiveItem
    inst.components.inventory.GiveItem = function(self,inst, slot, src_pos)
        local leader = self.inst.components.entitytracker:GetEntity("tudimiao")
        if inGamePlay and leader ~= nil and leader:IsValid() and not leader.components.inventory:IsFull() then
            local num = inst.components.stackable ~= nil and inst.components.stackable:StackSize() or 1
            local new = SpawnPrefab(inst.prefab == "goldnugget" and "myth_coin" or inst.prefab)
            if new.components.stackable ~= nil then
                new.components.stackable:SetStackSize(num)
            end
            leader.components.inventory:GiveItem(new)
        end
        return oldGiveItem(self,inst, slot, src_pos)
    end
    ------------------------------------------

    inst:AddComponent("lootdropper")

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = true


    inst:AddComponent("timer")

    ------------------------------------------
    --MakeMediumFreezableCharacter(inst, "torso")
    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(...) end

    inst:SetStateGraph("SGmyth_tudi")

    --inst:WatchWorldState("startday", onday)
    inst:WatchWorldState("cycles", onday)
    inst:ListenForEvent("onremove", onremove)
    ------------------------------------------

    inst.entity:SetCanSleep(false)
    
    inst.SetMiao = miaomiao
    inst.IsTargetedByOther = IsTargetedByOther
    inst:SetBrain(brain)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("myth_tudi", fn, assets, prefabs)