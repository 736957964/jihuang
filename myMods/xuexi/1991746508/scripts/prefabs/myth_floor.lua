local floorassets =
{
    Asset("ANIM", "anim/myth_floor.zip"),
    Asset("ANIM", "anim/myth_floor1.zip"),
    Asset("ANIM", "anim/myth_floorskin_ghg.zip"),
}

local wallassets =
{
    Asset("ANIM", "anim/myth_wallpaper.zip"),
    Asset("ANIM", "anim/myth_wallpaper1.zip"),
    Asset("ANIM", "anim/myth_wallskin_ghg.zip"),
}

local mythwallassets = 
{
	Asset("ANIM", "anim/myth_wall_decals.zip"),
	Asset("ANIM", "anim/myth_wall_decals1.zip"),
	Asset("ANIM", "anim/myth_wall_decals_ghg.zip"),
}

local stoneassets = 
{
	Asset("ANIM", "anim/myth_stonedoor.zip"),
}

local mythhousewallskin = {
	myth_wallskin_sunflower = "mythshouse_wallskin1",
	
	myth_floorskin_checkered = "mythshouse_floorskin2",
	
	myth_wallskin_ghg = "myth_wallskin_ghg",
	myth_floorskin_ghg = "myth_floorskin_ghg",	
	
}
local function nowet(inst)
	inst.GetIsWet = function(...) return false end
end

local function SetHouseWallSkin(inst,skin)
	local symbol = inst.prefab == "myth_floor_1"  and "image" or "up"
	if skin == "original" then
		inst.AnimState:ClearOverrideSymbol(symbol)
		inst._mythskin = nil
	elseif mythhousewallskin[skin] ~= nil then
		inst.AnimState:OverrideSymbol(symbol, mythhousewallskin[skin], symbol)
		inst._mythskin = skin
	end
end

local function onwallsave(inst,data)
	data._mythskin = inst._mythskin or nil
end

local function onwallload(inst,data)
	if data and data._mythskin ~= nil then
		SetHouseWallSkin(inst,data._mythskin)
	end
end

local function floorfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("myth_floor")

    inst.AnimState:SetBank("myth_floor")
    inst.AnimState:SetBuild("myth_floor")
    inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(2.26, 2, 1.8)
	
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BELOW_GROUND )
    inst.AnimState:SetSortOrder( 0 )
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.OnSave = onwallsave
	inst.OnLoad = onwallload
	inst.SetHouseWallSkin = SetHouseWallSkin
		
    return inst
end

local function floor1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("myth_floor")

    inst.AnimState:SetBank("myth_floor1")
    inst.AnimState:SetBuild("myth_floor1")
    inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(2.05, 2.05, 1.3)
	
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BELOW_GROUND )
    inst.AnimState:SetSortOrder( 0 )
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.OnSave = onwallsave
	inst.OnLoad = onwallload
	inst.SetHouseWallSkin = SetHouseWallSkin
		
    return inst
end

local function wallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("myth_wallpaper")	
	
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("myth_wallpaper")
    inst.AnimState:SetBuild("myth_wallpaper")
    inst.AnimState:PlayAnimation("idle")

    inst.AnimState:SetLayer(LAYER_BELOW_GROUND )
    inst.AnimState:SetSortOrder( 1 )
	
	inst.Transform:SetScale(2, 2, 2)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	--232
	
	inst.OnSave = onwallsave
	inst.OnLoad = onwallload
	inst.SetHouseWallSkin = SetHouseWallSkin
    return inst
end

local function wall1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("myth_wallpaper")	
	
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("myth_wallpaper1")
    inst.AnimState:SetBuild("myth_wallpaper1")
    inst.AnimState:PlayAnimation("idle")

    inst.AnimState:SetLayer(LAYER_BELOW_GROUND )
    inst.AnimState:SetSortOrder( 1 )
	
	inst.Transform:SetScale(1.6, 1.6, 1.6)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	--232
	
	inst.OnSave = onwallsave
	inst.OnLoad = onwallload
	inst.SetHouseWallSkin = SetHouseWallSkin
    return inst
end

local function onsave(inst,data)
	data.eastside = inst.eastside or nil
end

local function onload(inst,data)
	if data and data.eastside ~= nil then
		inst.eastside = data.eastside
		inst.AnimState:SetScale(-1,1,1)
	end
end
local function IsLowPriorityAction(act, force_inspect)
    return act == nil
        or act.action == ACTIONS.WALKTO
        or (act.action == ACTIONS.LOOKAT and not force_inspect)
end

local function CanMouseThrough(inst)
    if not inst:HasTag("fire") and ThePlayer ~= nil and ThePlayer.components.playeractionpicker ~= nil then
        local force_inspect = ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller:IsControlPressed(CONTROL_FORCE_INSPECT)
        local lmb, rmb = ThePlayer.components.playeractionpicker:DoGetMouseActions(inst:GetPosition(), inst)
        return IsLowPriorityAction(rmb, force_inspect)
            and IsLowPriorityAction(lmb, force_inspect)
    end
end

local function makewall_decals(name,anim,scale,build)
	local function wall_decalsfn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddNetwork()
		inst.entity:AddAnimState()
	
		MakeObstaclePhysics(inst, .5)
	
		inst.AnimState:SetBank(build)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation(anim)
		inst.Transform:SetScale(scale, scale, scale)
	
		inst.CanMouseThrough = CanMouseThrough
		
		nowet(inst)
		inst:AddTag("NOBLOCK")
		inst:AddTag("nonpackable")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end	
		inst.OnSave = onsave
		inst.OnLoad = onload
	
		return inst
	end
	return Prefab(name, wall_decalsfn,mythwallassets)
end

local function builder_onbuilt(inst, builder)

    local x, y, z = builder.Transform:GetWorldPosition()
	for i, v in ipairs(TheSim:FindEntities(x, 0, z, 20, { inst.tag })) do
		if v then
			SetHouseWallSkin(v,inst.skintype)
			break
		end
	end
    inst:Remove()
end

local function MakeSkins(prefab,tag,nolmal)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        inst:AddTag("CLASSIFIED")
        inst.persists = false

        if not TheWorld.ismastersim then
            return inst
        end

		inst.tag = tag
        inst.skintype = nolmal or prefab
        inst.OnBuiltFn = builder_onbuilt
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    return Prefab(prefab.."_builder", fn)
end

local function stonedoorfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()

    inst:AddTag("NOCLICK")
	inst:AddTag("myth_stonedoor")
    inst:AddTag("antlion_sinkhole_blocker")

    inst.AnimState:SetBank("myth_stonedoor")
    inst.AnimState:SetBuild("myth_stonedoor")
    inst.AnimState:PlayAnimation("stone")
	
	MakeObstaclePhysics(inst, 1)
	
	inst.Transform:SetScale(1.73, 1.73, 1.73)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

return Prefab("myth_floor", floorfn , floorassets),
		Prefab("myth_floor_1", floor1fn , floorassets),
	Prefab("myth_wallpaper", wallfn , wallassets),
	Prefab("myth_wallpaper_1", wall1fn , wallassets),
	Prefab("myth_stonedoor", stonedoorfn, stoneassets),
	
	makewall_decals("myth_wall_decals","idle",0.82,"myth_wall_decals"),
	makewall_decals("myth_wall_decals_in","idle_in",1.18,"myth_wall_decals"),
	makewall_decals("myth_wall_decals1","idle",0.6,"myth_wall_decals1"),
	makewall_decals("myth_wall_decals1_in","idle_in",0.9,"myth_wall_decals1"),
	makewall_decals("myth_wall_decals_ghg","idle",0.6,"myth_wall_decals_ghg"),
	makewall_decals("myth_wall_decals_ghg_in","idle_in",0.9,"myth_wall_decals_ghg")

	--skin
	--MakeSkins("myth_wallskin_mushroom","myth_wallpaper","original"),
	--MakeSkins("myth_wallskin_sunflower","myth_wallpaper"),

	--MakeSkins("myth_floorskin_mushroom","myth_floor","original"),
	--MakeSkins("myth_floorskin_checker","myth_floor"),
	
	
	
	
	
	