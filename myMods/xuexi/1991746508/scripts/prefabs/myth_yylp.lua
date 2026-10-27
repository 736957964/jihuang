local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/myth_yylp.zip"),
	Asset("ATLAS", "images/inventoryimages/myth_yylp.xml"),	
}


local prefabs =
{
    "myth_yylp_icon",
}

local prefabs_icon =
{
    "globalmapicon",
}

local function onturnon(inst)
    inst.AnimState:PlayAnimation("disk_float", true)
    if not inst.SoundEmitter:PlayingSound("idlesound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_LP", "idlesound")
    end
end

local function onturnoff(inst)
    inst.SoundEmitter:KillSound("idlesound")
	inst.AnimState:PlayAnimation("disk_idle", true)
end

local function onactivate(inst)   
	inst.AnimState:PlayAnimation("disk_unlock", true)
	inst.AnimState:PushAnimation("disk_float")
	
	local fx = SpawnPrefab("staff_castinglight")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetUp({ 162/255, 230/255, 218/255 }, 2)
	--inst._fx:push()
end

local function storeincontainer(inst, container)
    if container ~= nil and container.components.container ~= nil then
        inst:ListenForEvent("onputininventory", inst._oncontainerownerchanged, container)
        inst:ListenForEvent("ondropped", inst._oncontainerownerchanged, container)
        inst:ListenForEvent("onremove", inst._oncontainerremoved, container)
        inst._container = container
    end
end

local function unstore(inst)
    if inst._container ~= nil then
        inst:RemoveEventCallback("onputininventory", inst._oncontainerownerchanged, inst._container)
        inst:RemoveEventCallback("ondropped", inst._oncontainerownerchanged, inst._container)
        inst:RemoveEventCallback("onremove", inst._oncontainerremoved, inst._container)
        inst._container = nil
    end
end

local function tostore(inst, owner)
    if inst._container ~= owner then
        unstore(inst)
        storeincontainer(inst, owner)
    end
    owner = owner.components.inventoryitem ~= nil and owner.components.inventoryitem:GetGrandOwner() or owner
    if inst._owner ~= owner then
        inst._owner = owner
        inst.icon.entity:SetParent(owner.entity)
    end
end

local function topocket(inst, owner)
    onturnoff(inst)
    tostore(inst, owner)
end

local function toground(inst)
    if inst.components.prototyper.on then
        onturnon(inst)
    end
    unstore(inst)
    inst._owner = nil
    inst.icon.entity:SetParent(inst.entity)
end

local lightstates =
{
    new                 = {override=0.00,   enabled=false,  radius=0.00},
    quarter             = {override=0.00,   enabled=false,  radius=0.00},
    half                = {override=0.10,   enabled=true,   radius=0.70},
    threequarter        = {override=0.10,   enabled=true,   radius=1.50},
    full                = {override=0.50,   enabled=true,   radius=5.00},
}

local function onmoonphasechagned(inst, phase)	
	if TheWorld.state.moonphase == "full" then
		inst.AnimState:OverrideSymbol("flower_02", "myth_yylp", "flower_04")
		if inst.flies == nil then
			inst.flies = inst:SpawnChild("myth_yylp_fx")
		end
	elseif (TheWorld.state.moonphase == "half" or TheWorld.state.moonphase == "threequarter") then
		inst.AnimState:OverrideSymbol("flower_02", "myth_yylp", "flower_03")
		if inst.flies ~= nil then
			inst.flies:Remove()
			inst.flies = nil
		end
	else
		inst.AnimState:ClearOverrideSymbol("flower_02")
		if inst.flies ~= nil then
			inst.flies:Remove()
			inst.flies = nil
		end
	end
    local lightstate = lightstates[TheWorld.state.moonphase]
    inst.AnimState:SetLightOverride(lightstate.override)
    inst.Light:Enable(lightstate.enabled)
    inst.Light:SetRadius(lightstate.radius)
end

local function OnRemoveEntity(inst)
    if inst.icon ~= nil then
        inst.icon:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddDynamicShadow()
    inst.entity:AddLight()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("myth_yylp")
    inst.AnimState:SetBuild("myth_yylp")
    inst.AnimState:PlayAnimation("disk_idle")

	inst.DynamicShadow:SetSize(1.3, .6)
	
    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")
	inst:AddTag("prototyper")

    inst.Light:Enable(false)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetColour(15 / 255, 160 / 255, 180 / 255)
	
	MakeInventoryFloatable(inst)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._tasks = {}
    inst._light = 0
    inst._targetlight = 0
    inst._owner = nil
    inst._container = nil

    inst._oncontainerownerchanged = function(container)
        tostore(inst, container)
    end

    inst._oncontainerremoved = function()
        unstore(inst)
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/myth_yylp.xml"
    inst.components.inventoryitem.nobounce = true

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.MOON_ALTAR_FULL

    inst.icon = SpawnPrefab("myth_yylp_icon")
    inst.icon.entity:SetParent(inst.entity)
    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)

    inst.OnRemoveEntity = OnRemoveEntity

    inst:WatchWorldState("moonphase", onmoonphasechagned)

    onmoonphasechagned(inst)
	
    return inst
end

local function icon_init(inst)
    inst.icon = SpawnPrefab("globalmapicon")
    inst.icon.MiniMapEntity:SetPriority(11)
    inst.icon:TrackEntity(inst,nil,"myth_yylp.tex")
end

local function iconfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("myth_yylp.tex")
    inst.MiniMapEntity:SetPriority(11)
    inst.MiniMapEntity:SetCanUseCache(false)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)

    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.icon = nil
    inst:DoTaskInTime(0, icon_init)
    inst.OnRemoveEntity = inst.OnRemoveEntity
    inst.persists = false

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("fx")

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.AnimState:SetBank("fireflies")
    inst.AnimState:SetBuild("fireflies")
	inst.AnimState:PlayAnimation("swarm_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end
return Prefab("myth_yylp", fn, assets, prefabs),
	Prefab("myth_yylp_fx", fxfn),
    Prefab("myth_yylp_icon", iconfn)
