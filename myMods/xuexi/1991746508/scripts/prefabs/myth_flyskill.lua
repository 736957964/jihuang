
local function builder_onbuilt(inst, builder)
	if builder and builder.components.mk_flyer then 
        if builder._is_player_astral ~= nil and builder._is_player_astral:value() then
            return
        end        
        if builder.OnBuiltFn_Flyskill then
            builder:OnBuiltFn_Flyskill()
        end
		builder.components.mk_flyer:SetFlying(true)
	end
    inst:Remove()
end

local function makefly(name)
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")

    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnBuiltFn = builder_onbuilt
    inst:DoTaskInTime(0, inst.Remove)

    return inst
end
return Prefab(name, fn)
end

local function flyerfx_wheelfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:AddLight()

    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(197/255,128/255,50/255)
    inst.Light:SetFalloff(.5)
    inst.Light:SetRadius(2)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("heater")
    inst.components.heater.heat = 90
	inst.persists = false
	
    return inst
end

local function flyerfx_yutufn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddLight()

    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(0, 183 / 255, 1)
    inst.Light:SetFalloff(.5)
    inst.Light:SetRadius(1)
	inst.Light:Enable(true)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("heater")
    inst.components.heater.heat = -10
    inst.components.heater:SetThermics(false, true)
	inst.persists = false
	
    return inst
end

local function flyerfx_yamafn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:AddLight()

    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(40 / 255, 264 / 255, 218 / 255)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    
    return inst
end
return Prefab("flyerfx_wheel_fx", flyerfx_wheelfn),
    Prefab("flyerfx_yama_fx", flyerfx_yamafn),
	Prefab("flyerfx_yutu_fx", flyerfx_yutufn),
	makefly("myth_flyskill"),
	makefly("myth_flyskill_mk"),
	makefly("myth_flyskill_nz"),
	makefly("myth_flyskill_wb"),
	makefly("myth_flyskill_pg"),
	makefly("myth_flyskill_yj"),
	makefly("myth_flyskill_yt"),
    makefly("myth_flyskill_ya")