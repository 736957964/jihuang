local assets =
{
    Asset("ANIM", "anim/myth_xing.zip"),
    Asset("ANIM", "anim/myth_yue.zip"),
}

local function on_pressure_plate_near(inst)
    if not inst:HasTag("INTERIOR_LIMBO") and not inst.down then
        inst.SoundEmitter:PlaySound("buttons/sfx/click")
        inst.AnimState:PlayAnimation("uptodown")
        inst.AnimState:PushAnimation("down",false)
        inst.down = true
		inst.onnear(inst)
    end
end

local function on_pressure_plate_far(inst)
    if not inst:HasTag("INTERIOR_LIMBO") and inst.down then
        inst.AnimState:PlayAnimation("downtoup")
        inst.AnimState:PushAnimation("up",false)
        inst.down = nil
    end
end

local function yue(inst)
	inst.onnear = function()
		if inst.huan ~= nil and not inst.huan.busy then --and inst.huan2 ~= nil then
			inst.huan:RotationYue(30,-1)
		end
	end
end

local function xing(inst)
	inst.onnear = function()
		if inst.huan ~= nil and not inst.huan.busy  then --and inst.huan2 ~= nil then
			inst.huan:RotationXing(60,1)
		end
	end
end

local function makexy(name,anim,build,abc)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddNetwork()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		
		inst.AnimState:SetBank("myth_xing")
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation(anim)
		inst.Transform:SetScale(1.2, 1.2, 1.2)
	
		inst.AnimState:SetLayer(LAYER_BACKGROUND)
		inst.AnimState:SetSortOrder(3)

		inst:AddTag("structure")
		inst:AddTag("nonpackable")
		inst:AddTag("myth_weighdown")		

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end	
		if abc ~= nil then
			abc(inst)
		end
		inst:AddComponent("myth_creatureprox")
		inst.components.myth_creatureprox:SetOnPlayerNear(on_pressure_plate_near)
		inst.components.myth_creatureprox:SetOnPlayerFar(on_pressure_plate_far)
		inst.components.myth_creatureprox:SetTestfn(function(testing) return not testing:HasTag("flying") end)
		inst.components.myth_creatureprox:SetDist(0.8, 0.9)
		inst.components.myth_creatureprox.inventorytrigger = true
	
		inst.persists = false
	
		return inst
	end
	return Prefab(name, fn,assets)
end


return makexy("myth_xing","up","myth_xing",xing),
		makexy("myth_yue","up","myth_yue",yue)
	
	
	
	
	
	