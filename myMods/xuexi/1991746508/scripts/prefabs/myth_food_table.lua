require "prefabutil"

local cooking = require("cooking")

local assets =
{
    Asset("ANIM", "anim/myth_food_table.zip"),

}

local prefabs =
{
    "collapse_small",
}

local function onopen(inst)
    --inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    --inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.components.container:DropEverything()
    inst.components.container:Close()
end

local function onbuilt(inst)

end

local function RemoveDecor(inst, data)
    inst.AnimState:ClearOverrideSymbol("food_"..data.slot)
end

local function IsModCook(prefab)
    for cooker,recipes in pairs(cooking.recipes) do
        if IsModCookingProduct(cooker,prefab) then return true end
    end
    return false 
end

local function GetRecipe(prefab)
    for cooker,recipes in pairs(cooking.recipes) do
        if recipes[prefab] then return recipes[prefab] end
    end
    return nil
end

local function getbuild(item)
    if item:HasTag("myth_mooncake") then 
        return item.prefab,item.prefab,nil
    elseif item:HasTag("myth_zongzi") then 
        return "myth_zongzi",item.prefab,nil
    elseif item:HasTag("spicedfood") then 
        local recipe = GetRecipe(item.prefab) 
        print(recipe.spice)
        local truename = item.prefab
        local start = string.find (truename, "_spice")
        if start ~= nil then
            truename = string.sub(truename, 1,start-1)
        end
        if IsModCook(item.prefab) then
            return truename,truename,recipe.spice
        else
            local symbol_override_build = (recipe ~= nil and recipe.overridebuild) or "cook_pot_food"
            return symbol_override_build,truename,recipe.spice
        end
    else
        local overridebuild = IsModCook(item.prefab) and item.prefab or nil
        local recipe = GetRecipe(item.prefab) 
        local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or "cook_pot_food"
        local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or item.prefab
        return build,overridesymbol,nil
    end
end
local function AddDecor(inst, data)
    if inst:HasTag("burnt") or data == nil or data.slot == nil or data.item == nil then
        return
    end

    local build, symbol,spice = getbuild(data.item)
    inst.AnimState:OverrideSymbol("food_"..data.slot, build, symbol)
    --[[if spice then
        print("有我啊"..spice)
        inst.AnimState:OverrideSymbol("swap_plate_"..data.slot, "plate_food", "plate")
        inst.AnimState:OverrideSymbol("swap_garnish_"..data.slot, "spices", string.lower(spice))
    else
        inst.AnimState:ClearOverrideSymbol("swap_plate_"..data.slot)
        inst.AnimState:ClearOverrideSymbol("swap_garnish_"..data.slot)
    end]]
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("myth_food_table.tex")

    inst:AddTag("structure")

    inst:AddTag("myth_nianweidu")

    inst.AnimState:SetBank("myth_food_table")
    inst.AnimState:SetBuild("myth_food_table")
    inst.AnimState:PlayAnimation("idle")

    MakeObstaclePhysics(inst, 1.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("myth_food_table")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true


    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    inst:ListenForEvent("itemget", AddDecor)
    inst:ListenForEvent("itemlose", RemoveDecor)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    AddHauntableDropItemOrWork(inst)

    return inst
end

return Prefab("myth_food_table", fn, assets, prefabs),
    MakePlacer("myth_food_table_placer", "myth_food_table", "myth_food_table", "idle")
