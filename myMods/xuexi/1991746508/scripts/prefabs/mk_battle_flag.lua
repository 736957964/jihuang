require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/mk_battle_flag.zip"),
    Asset("ANIM", "anim/ui_board_5x3.zip"),
}
local fxassets =
{
    Asset("ANIM", "anim/lavaarena_battlestandard.zip"),
}
local prefabs =
{
    "collapse_big",
	"mk_battle_flag_item",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("flag", false)
end

local function ondeploy(inst, pt, deployer)
    local ent = SpawnPrefab("mk_battle_flag")
	if ent then
		ent.Transform:SetPosition(pt:Get())
		ent.SoundEmitter:PlaySound("dontstarve/common/sign_craft")
		if ent.components.writeable  then
			ent.owner = deployer.userid
			if	inst.text ~= nil then
				ent.components.writeable:SetText(inst.text)
			else
				ent.components.writeable:BeginWriting(deployer)
			end
		end
		if ent.components.fueled  then
			local percent = inst.components.fueled and inst.components.fueled:GetPercent() or 1
			ent.components.fueled:SetPercent(percent)
		end
	end
	inst:Remove()
end


local function onsave(inst,data)
	data.text = inst.text  or nil
	data.owner = inst.owner  or nil
end

local function onload(inst,data)
	if data then
		if data.text ~= nil then
			inst.text = data.text
		end
		if data.owner ~= nil then
			inst.owner = data.owner
		end
	end
end

local function pickupfn(inst, guy)
	if guy.components and guy.components.inventory then
		local text = inst.components.writeable and inst.components.writeable.text or nil
		local fueled  = inst.components.fueled and inst.components.fueled:GetPercent() or 1
		local potitem = SpawnPrefab("mk_battle_flag_item")
		if text ~= nil then
			potitem.text = text
		end
		if potitem.components.fueled then
			potitem.components.fueled:SetPercent(fueled)
		end
		guy.components.inventory:GiveItem(potitem)
		inst:Remove()
		return true
	end
end

local function sanitydelate(inst)
	if inst:IsValid() and inst.components.health and not inst.components.health:IsDead() and inst.components.sanity then
		inst.components.sanity:DoDelta(6/60, true)
	end
end
local function addbufffx(inst)
    inst.mk_battle_fx = SpawnPrefab("mk_battle_flag_fx")
    inst.mk_battle_fx.entity:SetParent(inst.entity)
end
local function removebufffx(inst)
	if inst.mk_battle_fx  then
		inst.mk_battle_fx:Remove()
		inst.mk_battle_fx = nil
	end
end
local function onremove(inst)
    for k, v in pairs(inst.addbuff) do
		if  v  and v.components.health  and v.components.combat and v.components.locomotor  then 
			inst.addbuff[v] = nil
			v.components.locomotor:RemoveExternalSpeedMultiplier(v, "mk_battle_flag")
			v.components.combat.externaldamagemultipliers:RemoveModifier("mk_battle_flag")		
			removebufffx(v)
		end
    end
end
local function Oncheckbuff(inst)
	if inst.components.fueled:IsEmpty() then
		onremove(inst)
		return
	end
	local x, y, z = inst.Transform:GetWorldPosition() 
	local ents = TheSim:FindEntities(x, y, z, 15,{ "player" }) 
	for i, v in ipairs(ents) do
		if v  and v.components.health  and v.components.combat and v.components.locomotor  then 
			if inst.addbuff[v] == nil then
				if not v.components.health:IsDead() then 
					inst.addbuff[v] = v
					v.components.combat.externaldamagemultipliers:SetModifier("mk_battle_flag", 1.15) 
					v.components.locomotor:SetExternalSpeedMultiplier(v, "mk_battle_flag", 1.15)
					if not v.mk_battle_fx then
						addbufffx(v)
					end
				end
			end
		end
	end
    for k, v in pairs(inst.addbuff) do
		if  v  and v:IsValid() and v.components.health  and v.components.combat and v.components.locomotor  then 
			if inst.owner ~= nil then
				if inst.owner == v.userid then
					sanitydelate(v)
				end
			end
			if v.components.health and v.components.health:IsDead() or  v:GetDistanceSqToInst(inst) >  225  then
				inst.addbuff[v] = nil
				v.components.locomotor:RemoveExternalSpeedMultiplier(v, "mk_battle_flag")
				v.components.combat.externaldamagemultipliers:RemoveModifier("mk_battle_flag")
				removebufffx(v)			
			else
				if not v.mk_battle_fx then
					addbufffx(v)
				end
				if not v.components.locomotor._externalspeedmultipliers["mk_battle_flag"] then
					v.components.locomotor:SetExternalSpeedMultiplier(v, "mk_battle_flag", 1.15)
				end
				if not v.components.combat.externaldamagemultipliers._modifiers["mk_battle_flag"] then
					v.components.combat.externaldamagemultipliers:SetModifier("mk_battle_flag", 1.15)
				end
			end
		end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --MakeObstaclePhysics(inst, .3)

    inst.MiniMapEntity:SetIcon("mk_battle_flag.tex")

    inst.AnimState:SetBank("mk_battle_flag")
    inst.AnimState:SetBuild("mk_battle_flag")
    inst.AnimState:PlayAnimation("flag")
	
	inst.AnimState:SetScale(1.5, 1.5, 1.5)
    inst:AddTag("structure")
	
    inst:AddTag("_writeable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:RemoveTag("_writeable")

    inst:AddComponent("inspectable")
	
    inst:AddComponent("writeable")
	
    inst:AddComponent("lootdropper")
	
	inst.addbuff = {}
    inst.buffs = inst:DoPeriodicTask(0.5, Oncheckbuff)
	inst.owner = nil
	
	inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(960) --10
    --inst.components.fueled:SetDepletedFn(onhammered)
	inst.components.fueled:StartConsuming()

	inst:AddComponent("flagpickupable")
	inst.components.flagpickupable:SetOnPickupFn(pickupfn)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onremove", onremove)
	
    inst.OnSave = onsave
    inst.OnLoad = onload
	
    return inst
end

local function item_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("mk_battle_flag")
    inst.AnimState:SetBuild("mk_battle_flag")
    inst.AnimState:PlayAnimation("idle")
	
	MakeInventoryFloatable(inst, "large", 0.05, {0.8, 0.35, 0.8})
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.text = nil
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "mk_battle_flag_item"
	inst.components.inventoryitem.atlasname = "images/monkey_king_item.xml"
	
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
	
	inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
	--inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:InitializeFuelLevel(960)
    inst.OnSave = onsave
    inst.OnLoad = onload
	
    return inst
end
local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
    
    inst.AnimState:SetBank("lavaarena_battlestandard")
    inst.AnimState:SetBuild("lavaarena_battlestandard")
    inst.AnimState:PlayAnimation("heal_fx",true) --attack_fx3  heal_fx
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end
return Prefab("mk_battle_flag", fn, assets, prefabs),
	Prefab("mk_battle_flag_item", item_fn, assets),
	Prefab("mk_battle_flag_fx", fxfn, fxassets),
    MakePlacer("mk_battle_flag_item_placer", "mk_battle_flag", "mk_battle_flag", "flag",nil,nil,nil,1.5)
