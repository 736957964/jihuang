local assets =
{
    Asset("ANIM", "anim/myth_interiors_ghg.zip"),
    Asset("ANIM", "anim/myth_interiors_ghg_groundlight.zip"),

	Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_flower.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_he_left.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_he_right.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_std.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_ryx.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_qzh.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_llt.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_bgz.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_blz.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_gxy.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_groundlight_yhy.xml" ),
    Asset( "ATLAS", "images/inventoryimages/myth_interiors_ghg_lu.xml" ),

}

local pf =
{
    Asset("ANIM", "anim/myth_interiors_ghg_pf.zip"),
}

local smoke =
{
    Asset("ANIM", "anim/smoke_plants.zip"),
}


local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function makeworkable(inst)
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end
    if not inst.components.workable then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(2)
        inst.components.workable:SetOnFinishCallback(onhammered)
    end
end

local function onbuilt(inst)
    inst.onbuilt = true
    makeworkable(inst)
end

local function onload(inst, data)
    if data ~= nil and data.onbuilt then
        inst.onbuilt = true
        makeworkable(inst)
    end
end

local function onsave(inst, data)
    data.onbuilt = inst.onbuilt == true or nil
end

local function canbuilt(inst)
    inst:ListenForEvent("onbuilt", onbuilt)
    inst.OnSave = onsave
    inst.OnLoad = onload
end

local function makeinteriors(name,anim)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		inst.AnimState:SetBank("myth_interiors_ghg")
		inst.AnimState:SetBuild("myth_interiors_ghg")
		inst.AnimState:PlayAnimation(anim)

		inst.Transform:SetScale(0.7, 0.7, 0.7)
		MakeObstaclePhysics(inst, 0.2, .5)
		inst:AddTag("nonpackable")
		inst.GetIsWet = function(...) return false end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("inspectable")
		canbuilt(inst)
		return inst
	end
	return Prefab(name, fn , assets)
end


local function lufn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst:AddTag("structure")

    inst.AnimState:SetBank("myth_interiors_ghg")
    inst.AnimState:SetBuild("myth_interiors_ghg")
    inst.AnimState:PlayAnimation("lu")

	inst.Transform:SetScale(0.9, 0.9, 0.9)
	
	inst:AddTag("nonpackable")
	inst.GetIsWet = function(...) return false end
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("heater")
    inst.components.heater.heat = 20
	
	if not inst.smoke then
		inst.smoke = inst:SpawnChild("myth_interiors_ghg_smoke")
		inst.smoke.Transform:SetPosition(0, 1, 0)
		inst.smoke.AnimState:SetDeltaTimeMultiplier(0.6)
    end
    canbuilt(inst)
    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddLight()

    MakeObstaclePhysics(inst, 0.2, .5)

    inst.Light:Enable(true)
    inst.Light:SetRadius(6)
    inst.Light:SetFalloff(0.6)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(242/255,239/255,103/255)
	
    inst:AddTag("structure")

	inst:AddTag("nonpackable")
	inst.GetIsWet = function(...) return false end
	
    inst.AnimState:SetBank("myth_interiors_ghg")
    inst.AnimState:SetBuild("myth_interiors_ghg")
    inst.AnimState:PlayAnimation("light")

	inst.Transform:SetScale(0.8, 0.8, 0.8)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")

    canbuilt(inst)
    return inst
end

local function flowerfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst:AddTag("structure")

    inst.AnimState:SetBank("myth_interiors_ghg")
    inst.AnimState:SetBuild("myth_interiors_ghg")
    inst.AnimState:PlayAnimation("flower")

	inst:AddTag("nonpackable")
	inst.GetIsWet = function(...) return false end
	
	MakeObstaclePhysics(inst, 0.2, .5)
	
	inst.Transform:SetScale(0.9, 0.9, 0.9)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")

    canbuilt(inst)
    return inst
end

local function pffn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("myth_interiors_ghg_pf")
    inst.AnimState:SetBuild("myth_interiors_ghg_pf")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("nonpackable")
	inst.GetIsWet = function(...) return false end
	
	inst.Transform:SetScale(1.1, 1.1, 1)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    --inst:AddComponent("inspectable")

    return inst
end

local function smokefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("smoke_out")
    inst.AnimState:SetBuild("smoke_plants")
    inst.AnimState:PlayAnimation("smoke_loop", true)
    inst.AnimState:SetFinalOffset(2)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function groundlight()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddLight()

    MakeObstaclePhysics(inst, 0.2, .5)

    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(0.6)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(242/255,239/255,103/255)
	
    inst:AddTag("structure")
	
    inst.AnimState:SetBank("myth_interiors_ghg_groundlight")
    inst.AnimState:SetBuild("myth_interiors_ghg_groundlight")
    inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(0.9, 0.9, 0.9)
	
    inst:SetPrefabNameOverride("myth_interiors_ghg_light")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper.GetRecipeLoot = function(...)
       return {}
    end
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function placefn(inst)
	inst.Transform:SetScale(0.9, 0.9, 0.9)
end

local function placefn1(inst)
	inst.Transform:SetScale(0.7, 0.7, 0.7)
end

--[[
245 235 132
255 239 169
255 205 115
255 240 144
255 219 111
255 102 169
152 255 233


经典，石塔蹬，如意霄，青竹辉，玲珑塔，白骨枝，宝莲盏
std ryx qzh llt bgz blz


]]

return Prefab("myth_interiors_ghg_lu", lufn, assets),
	Prefab("myth_interiors_ghg_light", lightfn, assets),
	Prefab("myth_interiors_ghg_flower", flowerfn, assets),
	Prefab("myth_interiors_ghg_pf", pffn, pf),

    Prefab("myth_interiors_ghg_groundlight", groundlight),

	Prefab("myth_interiors_ghg_smoke", smokefn, smoke),
	makeinteriors("myth_interiors_ghg_he_right","right_he"),
    makeinteriors("myth_interiors_ghg_he_left","left_he"),
    MakePlacer("myth_interiors_ghg_he_right_placer", "myth_interiors_ghg", "myth_interiors_ghg", "right_he",nil,nil,nil,nil,nil,nil,placefn1),
    MakePlacer("myth_interiors_ghg_lu_placer", "myth_interiors_ghg", "myth_interiors_ghg", "lu"),
    MakePlacer("myth_interiors_ghg_groundlight_placer", "myth_interiors_ghg_groundlight", "myth_interiors_ghg_groundlight", "idle",nil,nil,nil,nil,nil,nil,placefn),
    MakePlacer("myth_interiors_ghg_he_left_placer", "myth_interiors_ghg", "myth_interiors_ghg", "left_he",nil,nil,nil,nil,nil,nil,placefn1),
    MakePlacer("myth_interiors_ghg_flower_placer", "myth_interiors_ghg", "myth_interiors_ghg", "flower",nil,nil,nil,nil,nil,nil,placefn)