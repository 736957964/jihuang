
local function ondiscarded(inst)
    --inst.components.finiteuses:Use()
end

local function onusedup(inst)
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function MakeSaddle(name, data)
    local assets = {
        Asset("ANIM", "anim/"..name..".zip"),
		Asset( "IMAGE", "images/inventoryimages/"..name..".tex" ),
		Asset( "ATLAS", "images/inventoryimages/"..name..".xml" ),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("saddle_qingniu")
        inst.AnimState:SetBuild("saddle_qingniu")
        inst.AnimState:PlayAnimation("idle")

        inst.mounted_foleysound = "dontstarve/beefalo/saddle/"..data.foley

        MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])

        if data.extra_tags ~= nil then
            for _, tag in ipairs(data.extra_tags) do
                inst:AddTag(tag)
            end
        end

        inst:AddTag("qingniu_saddle")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("saddler")
        inst.components.saddler:SetBonusDamage(data.bonusdamage)
        inst.components.saddler:SetBonusSpeedMult(data.speedmult)
        inst.components.saddler:SetSwaps(name, "swap_saddle")
        inst.components.saddler:SetDiscardedCallback(ondiscarded)

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(data.uses)
        inst.components.finiteuses:SetUses(data.uses)
        inst.components.finiteuses:SetOnFinished(onusedup)

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

local data = {
    qingniu = {
        bonusdamage = 0,
        foley = "war_foley",
        uses = TUNING.SADDLE_WAR_USES,
        speedmult = TUNING.SADDLE_RACE_SPEEDMULT,
        floater = {"large", 0.05, 0.68},
    },
}

return  MakeSaddle("saddle_qingniu", data.qingniu)
