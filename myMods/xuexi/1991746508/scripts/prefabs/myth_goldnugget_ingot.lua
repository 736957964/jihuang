local assets =
{
    Asset("ANIM", "anim/myth_goldnugget_ingot.zip"),
}

local UpdateShadowSize = function(shadow, height)
    local scaleFactor = Lerp(2, 3, height / 35)
    shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
end
local OnRemoveDebris =  function(debris)
    debris.shadow:Remove()
end

local COLLAPSIBLE_WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}
local COLLAPSIBLE_TAGS = { "_combat", "pickable", "NPC_workable" }
for k, v in pairs(COLLAPSIBLE_WORK_ACTIONS) do
    table.insert(COLLAPSIBLE_TAGS, k.."_workable")
end
local TOSS_MUST_TAGS = { "_inventoryitem" }
local TOSS_CANT_TAGS = { "locomotor", "INLIMBO" }

local NON_COLLAPSIBLE_TAGS = { "flying", "bird", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO","myth_goldfrog","myth_small_goldfrog" }

local function SmallLaunch(inst, launcher, basespeed)
    local hp = inst:GetPosition()
    local pt = launcher:GetPosition()
    local vel = (hp - pt):GetNormalized()
    local speed = basespeed * .5 + math.random()
    local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
    inst.Physics:Teleport(hp.x, .1, hp.z)
    inst.Physics:SetVel(math.cos(angle) * speed, 3 * speed + math.random(), math.sin(angle) * speed)
end

local _BreakDebris =function(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
	local explode = SpawnPrefab("explosivehit")
    explode.Transform:SetPosition(x, 0, z) --爆炸+伤害+减速的坑	
	
	SpawnPrefab("myth_goldnugget_ingot_fx").Transform:SetPosition(x, 0, z)

    local ents = TheSim:FindEntities(x, 0, z, 4, nil, NON_COLLAPSIBLE_TAGS, COLLAPSIBLE_TAGS)
    for i, v in ipairs(ents) do
        if v:IsValid() then
            local isworkable = false
            if v.components.workable ~= nil then
                local work_action = v.components.workable:GetWorkAction()
                isworkable = (
                    (work_action == nil and v:HasTag("NPC_workable")) or
                    (v.components.workable:CanBeWorked() and work_action ~= nil and COLLAPSIBLE_WORK_ACTIONS[work_action.id])
                )
            end
            if isworkable then
                v.components.workable:Destroy(debris)
                if v:IsValid() and v:HasTag("stump") then
                    v:Remove()
                end
            elseif v.components.pickable ~= nil
                and v.components.pickable:CanBePicked()
                and not v:HasTag("intense") then
                local num = v.components.pickable.numtoharvest or 1
                local product = v.components.pickable.product
                local x1, y1, z1 = v.Transform:GetWorldPosition()
                v.components.pickable:Pick(debris) -- only calling this to trigger callbacks on the object
                if product ~= nil and num > 0 then
                    for i = 1, num do
                        SpawnPrefab(product).Transform:SetPosition(x1, 0, z1)
                    end
                end
            elseif v.components.combat ~= nil
                and v.components.health ~= nil
                and not v.components.health:IsDead() then
				v.components.combat:GetAttacked(debris, 100, nil)
				if not v.components.health:IsDead() and  v.components.mk_flyer and v.components.mk_flyer:IsFlying() then
					v.components.mk_flyer:SetFlying(false)
					v.components.mk_flyer._percent:set(0)			
				end
            end
        end
    end
    local totoss = TheSim:FindEntities(x, 0, z, 3, TOSS_MUST_TAGS, TOSS_CANT_TAGS)
    for i, v in ipairs(totoss) do
        if v.components.mine ~= nil then
            v.components.mine:Deactivate()
        end
        if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
            SmallLaunch(v, debris, 1.5)
        end
    end
    if TheWorld.ismastersim then
        debris:Remove()
    end
end

local function geiwoxialai(inst) --给我下来！
	local x, y, z = inst.Transform:GetWorldPosition()
	local explode = SpawnPrefab("splash_green_large")
    explode.Transform:SetPosition(x, 0, z)
	local ents = TheSim:FindEntities(x, 0, z, 4, nil, {"playerghost", "FX", "NOCLICK"},{"player","boat"})
    for i, v in ipairs(ents) do
        if v:IsValid() and v.components.health
			and not v.components.health:IsDead() then
			if  v.components.mk_flyer and v.components.mk_flyer:IsFlying() then
				v.components.mk_flyer:SetFlying(false)
				v.components.mk_flyer._percent:set(0)	
			elseif v:HasTag("boat") then
				v.components.health:DoDelta(-200)
			end
		end
	end
end

local _GroundDetectionUpdate = function(debris, override_density)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .2 then
        if debris:IsOnOcean(true) then
			geiwoxialai(debris)
            debris:PushEvent("detachchild")
            debris:Remove()
        else
			_BreakDebris(debris)
        end
    elseif debris:GetTimeAlive() < 3 then
        if y < 2 then
			--print()
            --debris.Physics:SetMotorVel(0, 0, 0)
        end
        UpdateShadowSize(debris.shadow, y)
    elseif debris:IsInLimbo() then
		debris:Remove()
	else
        _BreakDebris(debris)
    end
end

local function ondrop(inst,pt)

	inst.Physics:Teleport(pt.x, 35, pt.z)
    inst.shadow = SpawnPrefab("warningshadow")
    inst.shadow:ListenForEvent("onremove", OnRemoveDebris, inst)
    inst.shadow.Transform:SetPosition(pt.x, 0, pt.z)
    UpdateShadowSize(inst.shadow, 35)
    inst.updatetask = inst:DoPeriodicTask(FRAMES, _GroundDetectionUpdate, nil)
    inst:PushEvent("startfalling")			
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
	inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.AnimState:SetBank("myth_goldnugget_ingot")
    inst.AnimState:SetBuild("myth_goldnugget_ingot")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
	
	inst.OnDrop = ondrop 

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sinkhole")
    inst.AnimState:SetBuild("antlion_sinkhole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst.Transform:SetEightFaced()

    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("NOCLICK")

    inst:SetDeployExtraSpacing(4)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --inst:AddComponent("timer")
    --inst:ListenForEvent("timerdone", OnTimerDone)

    inst:AddComponent("unevenground")
    inst.components.unevenground.radius = TUNING.ANTLION_SINKHOLE.UNEVENGROUND_RADIUS

	inst:DoTaskInTime(10,inst.Remove)

    return inst
end
return Prefab("myth_goldnugget_ingot", fn, assets),
	Prefab("myth_goldnugget_ingot_fx", fxfn)
