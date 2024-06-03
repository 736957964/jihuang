local assets = {
    Asset("ANIM", "anim/laozi_bell.zip"),
    Asset("ATLAS", "images/inventoryimages/laozi_bell.xml"),
    Asset("ATLAS", "images/inventoryimages/laozi_bell_broken.xml")
}

local prefabs = {
    "spawn_fx_medium"
}

local TWEEN_TARGET = {0, 0, 0, 1}
local TWEEN_TIME = 13 * FRAMES
local function on_player_despawned(inst)
    for beef, _ in pairs(inst.components.leader.followers) do
        local fx = SpawnPrefab("spawn_fx_medium")
        fx.Transform:SetPosition(beef.Transform:GetWorldPosition())

        beef.components.colourtweener:StartTween(TWEEN_TARGET, TWEEN_TIME, beef.Remove)
        beef:PushEvent("despawn")
    end
end

local function get_other_player_linked_bell(inst, other)
    if other.components.inventory ~= nil then
        return other.components.inventory:FindItem(
            function(item)
                return (item ~= inst) and (item.prefab == "beef_bell") and item:_HasBeefalo()
            end
        )
    elseif other.components.container ~= nil then
        return other.components.container:FindItem(
            function(item)
                return (item ~= inst) and (item.prefab == "beef_bell") and item:_HasBeefalo()
            end
        )
    else
        return nil
    end
end

local function on_put_in_inventory(inst, owner)
    local grand_owner = inst.components.inventoryitem:GetGrandOwner()
    if grand_owner ~= nil then
        -- If the bell being picked up has a beefalo...
        if inst:_HasBeefalo() then
            -- ...look for another bell in the picking up player's inventory and drop it.
            local other_bell = get_other_player_linked_bell(inst, grand_owner)
            if other_bell ~= nil then
                if grand_owner.components.inventory ~= nil then
                    grand_owner.components.inventory:DropItem(other_bell, true, true)
                elseif grand_owner.components.container ~= nil then
                    grand_owner.components.container:DropItem(other_bell)
                end
            end
        end
    end
end

local function cleanup_bell(inst)
    inst:RemoveTag("nobundling")
    --inst.components.inventoryitem:ChangeImageName("beef_bell")
    --inst.AnimState:PlayAnimation("idle1", true)
end

local function on_beef_disappeared(inst, beef)
    cleanup_bell(inst)

    inst.components.useabletargeteditem:StopUsingItem()
end

local function has_beefalo(inst)
    return inst.components.leader:CountFollowers() > 0
end

local function get_beefalo(inst)
    for beef, v in pairs(inst.components.leader.followers) do
        if v then
            return beef
        end
    end

    return nil
end

local function on_used_on_beefalo(inst, target, user)
    if target.SetBeefBellOwner ~= nil then
        --if user ~= nil and get_other_player_linked_bell(inst, user) ~= nil then
        --    return false, "BEEF_BELL_HAS_BEEF_ALREADY"
        --end

        local beef_set_successful, failreason = target:SetBeefBellOwner(inst, user)

        if beef_set_successful then
            inst:AddTag("nobundling")
        end

        if failreason == nil then
            return beef_set_successful
        else
            local full_failreason = string.upper(inst.prefab) .. "_" .. failreason
            return beef_set_successful, full_failreason
        end
    else
        return false, "BEEF_BELL_INVALID_TARGET"
    end
end

local function on_stop_use(inst)
    inst:DoTaskInTime(
        1.5,
        function()
            local beef = get_beefalo(inst)
            if beef and beef:IsValid() and not beef.components.health:IsDead() then
                if beef.components.hitchable and not beef.components.hitchable.canbehitched then
                    beef.components.hitchable:Unhitch()
                end
                if beef.components.combat.target ~= nil then

                    beef.components.combat:SetTarget(nil)
                    beef.components.combat:BlankOutAttacks(1)
                end

                local owner = inst.components.inventoryitem.owner
                if owner then
                    local pos = owner:GetPosition()
                    local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 3, 10)
                    if offset ~= nil then
                        pos.x = pos.x + offset.x
                        pos.z = pos.z + offset.z	
                    end
                    beef.Transform:SetPosition(pos:Get())
                    local fx = SpawnPrefab('mk_cloudpuff')
                    fx.Transform:SetScale(0.8,0.8,0.8)
                    fx.Transform:SetPosition(pos:Get())
                end
            end
        end
    )
end

local function on_bell_save(inst, data)
    for beef, _ in pairs(inst.components.leader.followers) do
        data.beef_record = beef:GetSaveRecord()
        break
    end
end

local function on_bell_load(inst, data)
    if data and data.beef_record then
        local beef = SpawnSaveRecord(data.beef_record)
        if beef ~= nil then
            inst.components.useabletargeteditem:StartUsingItem(beef)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("laozi_bell")
    inst.AnimState:SetBuild("laozi_bell")
    inst.AnimState:PlayAnimation("laozi_bell", true)

    inst.MiniMapEntity:SetIcon("laozi_bell.tex")

    MakeInventoryFloatable(inst)

    inst:AddTag("bell")
    inst:AddTag("laozi_bell")
    inst:AddTag("irreplaceable")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(on_put_in_inventory)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/laozi_bell.xml"

    inst:AddComponent("useabletargeteditem")
    inst.components.useabletargeteditem:SetTargetPrefab("laozi_qingniu")
    inst.components.useabletargeteditem:SetOnUseFn(on_used_on_beefalo)
    inst.components.useabletargeteditem:SetOnStopUseFn(on_stop_use)
    inst.components.useabletargeteditem.StopUsingItem = function(self)
        if self.onstopusefn then
            self.onstopusefn(self.inst)
        end
    end
    inst.components.useabletargeteditem:SetInventoryDisable(true)

    inst:AddComponent("tradable")

    inst:AddComponent("leader")
    inst.components.leader.onremovefollower = on_beef_disappeared

    inst._HasBeefalo = has_beefalo
    inst.GetBeefalo = get_beefalo
    inst.OnSave = on_bell_save
    inst.OnLoad = on_bell_load

    inst:ListenForEvent("player_despawn", on_player_despawned)

    return inst
end

local function broken_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("laozi_bell")
    inst.AnimState:SetBuild("laozi_bell")
    inst.AnimState:PlayAnimation("laozi_bell_broken", true)

    inst.MiniMapEntity:SetIcon("laozi_bell.tex")

    --inst:AddTag("irreplaceable")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/laozi_bell_broken.xml"

    inst:AddComponent("tradable")

    return inst
end

return Prefab("laozi_bell", fn, assets), Prefab("laozi_bell_broken", broken_fn)
