local assets =
{
    Asset("ANIM", "anim/myth_rhino_heart.zip"),
    Asset( "IMAGE", "images/inventoryimages/myth_rhino_redheart.tex" ),
    Asset( "ATLAS", "images/inventoryimages/myth_rhino_redheart.xml" ),
    Asset( "IMAGE", "images/inventoryimages/myth_rhino_blueheart.tex" ),
    Asset( "ATLAS", "images/inventoryimages/myth_rhino_blueheart.xml" ),
    Asset( "IMAGE", "images/inventoryimages/myth_rhino_yellowheart.tex" ),
    Asset( "ATLAS", "images/inventoryimages/myth_rhino_yellowheart.xml" ),
}

local prefabs = 
{

}

local function fn(name,colour)

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_rhino_heart")
    inst.AnimState:SetBuild("myth_rhino_heart")
    inst.AnimState:PlayAnimation(name,true)

    inst:AddTag("cattoy")
    inst:AddTag("renewable")
	inst:AddTag("oceanfishing_bobber")

    MakeInventoryFloatable(inst, "med", nil, 0.68)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    if FOODTYPE.WB_HEART ~= nil then
        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.WB_HEART
        inst.components.edible.healthvalue = 50
        inst.components.edible.hungervalue = 50
        inst.components.edible.sanityvalue = 50
        inst.components.edible.oneaten = function(inst, eater)
            if
                eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost")
             then
                eater.components.debuffable:AddDebuff("myth_rhino_"..colour.."buff", "myth_rhino_"..colour.."buff")
            end
        end
    end

    return inst
end

local function red()
    return fn("myth_rhino_redheart","red")
end
local function blue()
    return fn("myth_rhino_blueheart","blue")
end
local function yellow()
    return fn("myth_rhino_yellowheart","yellow")
end
return Prefab("myth_rhino_redheart", red, assets, prefabs),
    Prefab("myth_rhino_blueheart", blue, assets, prefabs),
    Prefab("myth_rhino_yellowheart", yellow, assets, prefabs)
