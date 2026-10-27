local assets =
{
    Asset("ANIM", "anim/myth_door_exit.zip"),
    Asset("ANIM", "anim/myth_door_exit1.zip"),
    Asset("ANIM", "anim/myth_door_exit2.zip"),
}
local function nowet(inst)
	inst.GetIsWet = function(...) return false end
end

local function OnDoneTeleporting(inst, obj)
    if obj ~= nil and obj:HasTag("player") then
		if inst.ChangE ~= nil  then
			inst.ChangE:DoTaskInTime(1.5,function()
				inst.ChangE:NewPlayer(obj)
			end)
		end
    end
end

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
        if doer.components.talker ~= nil then
            doer.components.talker:ShutUp()
        end
    elseif inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    end
end

local function onhaunted(inst,doer)
	if doer and doer:HasTag("player") then
		inst.components.myth_teleporter:Activate(doer)
	end
end

local function testfn(inst,doer)
	if doer and doer.prefab == "myth_yutu" then
		return true
	end
	return TheWorld.state.phase ~= "night"
end

local function teleportplayer(inst,phase)
	if phase == "night" then
		inst:DoTaskInTime(1,function()
			local x,y,z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 20, {"player"},{"myth_yutu"})
			for i,v in ipairs(ents) do
				inst.components.myth_teleporter:Activate(v)
				if v.components.myth_favorability then
					v.components.myth_favorability:Ban()
					if v.sg then
						v:Hide()
						v:DoTaskInTime(1,function()
							v:Show()
							if not v.components.health:IsDead() then
								if v.components.talker then
									v.components.talker:Say(STRINGS.MYTHGHG_ISNIGHT[string.upper(v.prefab)]  or  STRINGS.MYTHGHG_ISNIGHT.GENERIC)
								end
								v.sg:GoToState("knockback_pst")
							end
						end)
					end
				end
			end	
		end)
	end
end
	
local function CheckChangE(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 20, {"myth_chenge"})
	for i,v in ipairs(ents) do
		inst.ChangE = v
		break
	end
end

local function doors(name,build,size,small)
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:AddPhysics()
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetSphere(1)
	inst.Transform:SetScale(size, size, size)

    inst.AnimState:SetBank(build)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")
	
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	if small then
		inst.small = true
	end
	nowet(inst)
	
    inst:AddTag("trader")
    --inst:AddTag("alltrader")
	inst:AddTag("myth_door")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("nonpackable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
	
    inst:AddComponent("myth_teleporter")
    inst.components.myth_teleporter.onActivate = OnActivate
    inst.components.myth_teleporter.offset = 0
	inst.components.myth_teleporter.travelcameratime = 1
	inst.components.myth_teleporter.travelarrivetime = 0.5	
	
	if name == "myth_door_exit_2" then
		--inst.components.myth_teleporter:SetTestFn(testfn)
		inst:WatchWorldState("phase", teleportplayer)
		teleportplayer(inst, TheWorld.state.phase)
		inst:DoTaskInTime(0, CheckChangE)
	end
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(onhaunted)

    return inst
end
	return Prefab(name, fn, assets)
end

local function OnBuild(inst)
	local x,y,z = inst.Transform:GetWorldPosition() 
	TheWorld.Map:CreatMythHouse(x,z,inst)
end

local function OnRemove(inst)
	TheWorld.Map:RemoveMythHouse(inst)
end

local function house()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
	inst:AddTag("lightningrod")
    inst:AddTag("NOBLOCK")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("myth_house")

	inst:DoTaskInTime(0, OnBuild)
	inst:ListenForEvent("onremove", OnRemove)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst

end

local function OnBuild1(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	TheWorld.Map:CreatMythHouse(x,z,inst,0.5)
end

local function house1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
	inst:AddTag("lightningrod")
    inst:AddTag("NOBLOCK")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("myth_house")

	inst:DoTaskInTime(0, OnBuild1)
	inst:ListenForEvent("onremove", OnRemove)
	
    if not TheWorld.ismastersim then
        return inst
    end
    return inst
end
return 
	doors("myth_door_exit","myth_door_exit",1.3),
	doors("myth_door_exit_1","myth_door_exit1",1,true),
	doors("myth_door_exit_2","myth_door_exit2",1.74,true),
	Prefab("myth_house", house),
	Prefab("myth_house1", house1)
