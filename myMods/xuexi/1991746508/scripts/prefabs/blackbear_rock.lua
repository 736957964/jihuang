--from DLC0003
local assets = {
	Asset("ANIM", 'anim/blackbear_rock.zip'),
}

local function basalt_fn()

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.nameoverride = "ROCK1"
	
	MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "rock.png" )

	local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)  
	anim:SetBank("rock_basalt")
	anim:SetBuild("blackbear_rock")
	anim:PlayAnimation("full")

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	if math.random() < 0.2 then
		inst.components.lootdropper:SetLoot(math.random()<0.3 and {"rocks"} or {"flint"})
	end
		
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(1)
	
	inst.components.workable:SetOnWorkCallback(
		function(inst, worker, workleft)

			local pt = Point(inst.Transform:GetWorldPosition())
			if workleft <= 0 then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
				inst.components.lootdropper:DropLoot(pt)
				inst:Remove()
			else
				if workleft < TUNING.ROCKS_MINE*(1/3) then
					inst.AnimState:PlayAnimation("low")
				elseif workleft < TUNING.ROCKS_MINE*(2/3) then
					inst.AnimState:PlayAnimation("med")
				else
					inst.AnimState:PlayAnimation("full")
				end
			end
		end)


	inst:AddComponent("inspectable")

	MakeSnowCovered(inst)

	return inst
end

return Prefab('blackbear_rock', basalt_fn, assets)