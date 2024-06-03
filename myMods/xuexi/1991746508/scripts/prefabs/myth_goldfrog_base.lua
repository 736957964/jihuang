local assets =
{
    Asset("ANIM", "anim/myth_goldfrog_base.zip"),
}

local prefabs =
{
	"myth_goldfrog"
}

local function onworked(inst, worker)
	
end

local function onworkfinished(inst)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_up")
	for i, v in ipairs(TUNING.MYTH_TREASURE_BOWL) do
		if v and v:IsValid() then
			v:DoTaskInTime(0, ErodeAway)
		end
	end
    local toadstool = SpawnPrefab("myth_goldfrog")

    toadstool.Transform:SetPosition(inst.Transform:GetWorldPosition())
    toadstool.sg:GoToState("surface")
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("myth_goldfrog_base.tex")

    inst.AnimState:SetBank("myth_goldfrog_base")
    inst.AnimState:SetBuild("myth_goldfrog_base")
    inst.AnimState:PlayAnimation("idle")

	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
    inst:AddTag("event_trigger")
	
    ----------------------------------------------------
    inst:AddTag("blocker")
    inst.entity:AddPhysics()
    inst.Physics:SetMass(0) 
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(1, 2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetOnWorkCallback(onworked)
    inst.components.workable:SetOnFinishCallback(onworkfinished)
	
    return inst
end

return Prefab("myth_goldfrog_base", fn, assets, prefabs)
