require "prefabutil"
local assets =
{
    Asset("ANIM", "anim/cook_pot.zip"),
    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
	
	Asset("ANIM", "anim/alchmy_fur_work.zip"),
	Asset("ANIM", "anim/alchmy_fur_copper_work.zip"),
	Asset("ANIM", "anim/alchmy_fur_ruins_work.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/alchmy_fur_ruins.xml" ),
    Asset( "ATLAS", "images/inventoryimages/alchmy_fur_copper.xml" ),
}

local prefabs =
{
    "collapse_small",
	"mk_cloudpuff",
	"mk_firefx",
	"mk_firefxdie",
	"mk_firefire"
}

local function fireon(inst)
    inst.fire = SpawnPrefab("mk_firefire")
    inst.fire.entity:SetParent(inst.entity)
end

local function fireoff(inst)
	if inst.fire ~= nil then
		if inst.fire.KillFX then
			inst.fire:KillFX()
		end
		inst.fire = nil
	end
end

local function launchitem(item)
    local speed = math.random() * 3 + 3
    local angle = math.random(360) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end	

local function biubiu(inst)	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 6, nil, { "INLIMBO" })
	for i, target in ipairs(ents) do
		if target then 
			if target.components.burnable ~= nil and not (target:HasTag("fueldepleted") or target:HasTag("INLIMBO")) then
				target.components.burnable:Ignite()
			end
		end
	end
	ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 1, inst, 8)
    SpawnPrefab("mk_firefxdie").Transform:SetPosition(x, y, z)
	inst.AnimState:PlayAnimation("hit_empty")
	inst:StartThread(function()
    for k = 1, 4 do
			for k1 = 1, 3 do
				local nug = SpawnPrefab("mk_firefx")
					if nug then
						nug.Transform:SetPosition( x + math.random()* (math.random() < 0.5 and 1 or -1) , y + 1 ,z)
					launchitem(nug)
				end
			end
	Sleep(.15)
    end
end)
end

local function onhammered(inst, worker)
    if  inst.components.stewer_fur.product ~= nil and inst.components.stewer_fur:IsDone() then
        local pd = inst.components.stewer_fur.product
        if pd == 'purple_gourd' then
            pd = 'pill_bottle_gourd'
        end
        inst.components.lootdropper:AddChanceLoot(pd, 1)
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if inst.components.stewer_fur:IsCooking() then
        inst.AnimState:PlayAnimation("hit_cooking")
        inst.AnimState:PushAnimation("cooking_loop", true)
    elseif inst.components.stewer_fur:IsDone() then
        inst.AnimState:PlayAnimation("hit_full")
        inst.AnimState:PushAnimation("idle_full", false)
    else
        inst.AnimState:PlayAnimation("hit_empty")
        inst.AnimState:PushAnimation("idle_empty", false)
    end
end

local function startcookfn(inst)
	local build = inst.AnimState:GetBuild().."_work"
	
	inst.AnimState:OverrideSymbol("pot", build, "pot_work")
    inst.AnimState:PlayAnimation("cooking_loop", true)
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    inst.Light:Enable(true)
	if inst.components.heater then
		inst.components.heater.heat = 200
	end
	if inst.components.propagator then 
		inst.components.propagator:StartSpreading()
	end
	fireon(inst)
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("cooking_pre_loop", true)
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
    if not inst:HasTag("burnt") then 
        if not inst.components.stewer_fur:IsCooking() then
            inst.AnimState:PlayAnimation("idle_empty")
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end


local specific_item = {
    purple_gourd = {"purple_gourd","swap_fur"},
    myth_yjp = {"myth_yjp","image"},
}

local function ShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer_fur.product
        local build = specific_item[product] ~= nil and specific_item[product][1] or "mk_pills"
        local symbol = specific_item[product] ~= nil and specific_item[product][2] or product
        inst.AnimState:Hide("swap_high")
        inst.AnimState:Show("swap_mid")
        inst.AnimState:Hide("swap_low")
        inst.AnimState:OverrideSymbol("swap_cooked", build, symbol)
    end
end


local function badfn(inst)
	biubiu(inst)
	inst:DoTaskInTime(0.6, function()
        inst.AnimState:PlayAnimation("cooking_pst")
		inst.AnimState:ClearOverrideSymbol("pot")
		inst.AnimState:ClearOverrideSymbol("swap_cooked")
        inst.AnimState:PushAnimation("idle_empty", false)
        inst.SoundEmitter:KillSound("snd")
        inst.Light:Enable(false)
		if inst.components.heater then
			inst.components.heater.heat = 0
		end
		if inst.components.propagator then 
			inst.components.propagator:StopSpreading()
		end
		fireoff(inst)
	end)
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pst")
		inst.AnimState:ClearOverrideSymbol("pot")
        inst.AnimState:PushAnimation("idle_full", false)
        ShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
		if inst.components.heater then
			inst.components.heater.heat = 0
		end
		if inst.components.propagator then 
			inst.components.propagator:StopSpreading()
		end
		fireoff(inst)
    end
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("idle_full")
        ShowProduct(inst)
    end
end

local function continuecookfn(inst)
    if not inst:HasTag("burnt") then 
		local build = inst.AnimState:GetBuild().."_work"
		inst.AnimState:OverrideSymbol("pot", build, "pot_work")
        inst.AnimState:PlayAnimation("cooking_loop", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
		if inst.components.heater then
			inst.components.heater.heat = 200
		end
		if inst.components.propagator then 
			inst.components.propagator:StartSpreading()
		end
		fireon(inst)
    end
end

local function harvestfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty")
    end
end

local function getstatus(inst)
    return
		(inst.components.stewer_fur:IsDone() and "DONE")
        or (not inst.components.stewer_fur:IsCooking() and "EMPTY")
        or "GENERIC"
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle_empty", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function onpreload(inst, data)  --兼容旧的存档
    if data ~= nil and data.myth_itemskin_theme ~= nil and data.myth_itemskin_theme.skin ~= nil then
		TheSim:ReskinEntity( inst.GUID, nil, data.myth_itemskin_theme.skin)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .9)

    inst.MiniMapEntity:SetIcon("alchmy_fur.tex")
	
    inst.Light:SetFalloff(0.8)
    inst.Light:SetIntensity(.9)
    inst.Light:SetRadius(6)
	inst.Light:SetColour(197/255, 126/255, 126/255)
	inst.Light:Enable(false)
	
    inst:AddTag("structure")
	inst:AddTag("alchmy_fur")

    inst.AnimState:SetBank("cook_pot")
    inst.AnimState:SetBuild("alchmy_fur")
    inst.AnimState:PlayAnimation("idle_empty")
	inst.Transform:SetScale(1.2, 1.2, 1.2)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("stewer_fur")
    inst.components.stewer_fur.onstartcooking = startcookfn 
    inst.components.stewer_fur.oncontinuecooking = continuecookfn 
    inst.components.stewer_fur.oncontinuedone = continuedonefn 
    inst.components.stewer_fur.ondonecooking = donecookfn 
    inst.components.stewer_fur.onharvest = harvestfn
    inst.components.stewer_fur.ondobad = badfn 

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("alchmy_fur")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("heater")
    inst.components.heater.heat = 0
	inst.components.heater.carriedheatmultiplier = 3
	
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus  --检查待定吧

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("propagator")
	inst.components.propagator.acceptsheat = false
	inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
	inst.components.propagator.flashpoint = 45+math.random()*10
	inst.components.propagator.decayrate = 0.5
	inst.components.propagator.propagaterange = 6
	inst.components.propagator.heatoutput = 9
    inst.components.propagator.damagerange = 3
    inst.components.propagator.damages = true
	
    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnPreLoad = onpreload
    return inst
end

return Prefab("alchmy_fur", fn, assets, prefabs),
    MakePlacer("alchmy_fur_placer", "cook_pot", "alchmy_fur", "idle_empty",nil,nil,nil,1.2)
