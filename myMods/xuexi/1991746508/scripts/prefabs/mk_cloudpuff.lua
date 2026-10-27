
local assets =
{
    Asset("ANIM", "anim/cloud_puff_soft.zip"),
	Asset("ANIM", "anim/mkcloud.zip"),
	Asset("ANIM", "anim/mk_cloudfx.zip"),
}

local function onSleep(inst)
	inst:Remove()
end 

local function PlayRingAnim(proxy,anim)
    local inst = CreateEntity()

    inst:AddTag("FX")
	inst:AddTag( "NOCLICK" )

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.Transform:SetFromProxy(proxy.GUID)
    
    inst.AnimState:SetBank("splash_clouds_drop")
    inst.AnimState:SetBuild("cloud_puff_soft")
    inst.AnimState:PlayAnimation("idle_sink")
	inst.AnimState:OverrideSymbol("poof", "mkcloud", "poof")
    inst.AnimState:SetFinalOffset(1)
	inst.Transform:SetScale(1.2, 1.2, 1.2)
	
    inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

	inst:AddTag("FX")
	inst:AddTag( "NOCLICK" )
	
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
	
	if not TheNet:IsDedicated() then
		inst:DoTaskInTime(0, PlayRingAnim)
	end
	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end
	inst.persists = false
	inst.OnEntitySleep = onSleep
	return inst
end

local function fx()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()

	inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetDamping(10)
    inst.Physics:CollidesWith(COLLISION.GROUND)

	inst.AnimState:SetBank("mk_cloudfx")
    inst.AnimState:SetBuild("mk_cloudfx")
    inst.AnimState:SetRayTestOnBB(true)
    
    inst.AnimState:SetFinalOffset(-5)

	inst.Transform:SetScale(1.1, 1.1, 1.1)
	
	inst:AddTag("FX")
	inst:AddTag( "NOCLICK" )
	
	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end	
	
	inst.ScaleFn = function(inst)
		local max = 1.2
		local min = .7
		
		local step = 0.06+0.03*math.random()
		local s = inst.Transform:GetScale()
		local tick = math.random(628)
		inst:DoPeriodicTask(0,function()
			tick = tick+1
			local scale = s*((max+min)/2+((max-min)/2)*math.sin(tick*step))
			inst.Transform:SetScale(scale,scale,scale)
			if tick >= 63832 then
				tick = 0
			end
		end)
	end
	inst.ScaleFnLz = function(inst)
		inst.Physics:SetMass(0)
		local max = 1.2
		local min = 1
		
		local step = 0.06+0.03*math.random()
		local s = inst.Transform:GetScale()
		local tick = math.random(628)
		inst:DoPeriodicTask(0,function()
			tick = tick+1
			local scale = s*((max+min)/2+((max-min)/2)*math.sin(tick*step))
			inst.Transform:SetScale(scale,scale,scale)
			if tick >= 63832 then
				tick = 0
			end
		end)
	end
	inst.ScaleFnQN = function(inst)
		inst.Physics:SetMass(0)
		local max = 1
		local min = 0.7
		
		local step = 0.06+0.03*math.random()
		local s = inst.Transform:GetScale()
		local tick = math.random(628)
		inst:DoPeriodicTask(0,function()
			tick = tick+1
			local scale = s*((max+min)/2+((max-min)/2)*math.sin(tick*step))
			inst.Transform:SetScale(scale,scale,scale)
			if tick >= 63832 then
				tick = 0
			end
		end)
	end
	inst.persists = false
	return inst
end

return Prefab("mk_cloudpuff", fn, assets),
		Prefab("mk_cloudfx", fx, assets)
