
local assets =
{
	Asset("ANIM", "anim/mk_firefx.zip"),
}

local fxassets =
{
	Asset("ANIM", "anim/die.zip"),
}

local fireassets =
{
    Asset("ANIM", "anim/deer_fire_flakes.zip"),
}

local brambleassets =
{
    Asset("ANIM", "anim/bramblefx.zip"),
}

local function onremove(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("houndfire").Transform:SetPosition(x, 0, z)
	inst:Remove()
end

local function KillFX(inst)
    inst.AnimState:PlayAnimation("pst")
    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + .25, inst.Remove)
end

local MAXRANGE = 3
local NO_TAGS_NO_PLAYERS = { "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "player" }
local NO_TAGS = { "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }

local function OnUpdateThorns(inst)
    inst.range = inst.range + .75

    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x, y, z, inst.range + 3, { "_combat" }, inst.canhitplayers and NO_TAGS or NO_TAGS_NO_PLAYERS)) do
        if not inst.ignore[v] and
            v:IsValid() and
            v.entity:IsVisible() and
            v.components.combat ~= nil and
            not (v.components.inventory ~= nil and
                v.components.inventory:EquipHasTag("bramble_resistant")) then
            local range = inst.range + v:GetPhysicsRadius(0)
            if v:GetDistanceSqToPoint(x, y, z) < range * range then
                if inst.owner ~= nil and not inst.owner:IsValid() then
                    inst.owner = nil
                end
                if inst.owner ~= nil then
                    if inst.owner.components.combat ~= nil and inst.owner.components.combat:CanTarget(v) then
                        inst.ignore[v] = true
                        v.components.combat:GetAttacked(v.components.follower ~= nil and v.components.follower:GetLeader() == inst.owner and inst or inst.owner, inst.damage,nil,"bramblefx_mk")
                    end
                elseif v.components.combat:CanBeAttacked() then
                    inst.ignore[v] = true
                    v.components.combat:GetAttacked(inst, inst.damage)
                end
            end
        end
    end

    if inst.range >= MAXRANGE then
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateThorns)
    end
end

local function SetFXOwner(inst, owner)
    inst.Transform:SetPosition(owner.Transform:GetWorldPosition())
    inst.owner = owner
    inst.canhitplayers = not owner:HasTag("player") or TheNet:GetPVPEnabled()
    inst.ignore[owner] = true
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	inst:AddTag("FX")
	
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
	
    inst.AnimState:SetBank("mk_firefx")
    inst.AnimState:SetBuild("mk_firefx")
    inst.AnimState:PlayAnimation("idle_loop",true)
    inst.AnimState:SetFinalOffset(2)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	local scale = math.random(4,8) * 0.1
	
	inst.Transform:SetScale(scale, scale, scale)	
    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(197/255, 126/255, 126/255)
    inst.Light:Enable(true)	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	inst.persists = false
	inst:DoTaskInTime(1, onremove)
	return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("die_fx")
    inst.AnimState:SetBuild("die")
	inst.AnimState:PlayAnimation("large")
	inst.AnimState:SetMultColour(239/255, 184/255, 16/255, 1)
	
	inst:AddTag("fx")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/mound_explode")
	
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
    return inst
end

local function firefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deer_fire_flakes")
    inst.AnimState:SetBuild("deer_fire_flakes")
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(1)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst.AnimState:PushAnimation("loop",true)

    inst.KillFX = KillFX
    return inst
end


local function bramblefxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("thorny")

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("bramblefx")
    inst.AnimState:SetBuild("bramblefx")
    inst.AnimState:PlayAnimation("idle")

    inst:SetPrefabNameOverride("bramblefx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(OnUpdateThorns)

    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
    inst.damage = 34
    inst.range = .75
    inst.ignore = {}
    inst.canhitplayers = true

    inst.SetFXOwner = SetFXOwner

    return inst
end

return Prefab("mk_firefx", fn, assets),
		Prefab("mk_firefxdie", fxfn, fxassets),
		Prefab("mk_firefire", firefn, fireassets),
		Prefab("bramblefx_mk", bramblefxfn, brambleassets)
