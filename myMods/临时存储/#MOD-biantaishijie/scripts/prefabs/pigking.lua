local assets =
{
    Asset("ANIM", "anim/pig_king.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "goldnugget",
}

for i = 1, NUM_HALLOWEENCANDY do
    table.insert(prefabs, "halloweencandy_"..i)
end

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function ontradeforgold(inst, item, giver)
    inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
end

local function onplayhappysound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingHappy")
end

local function onendhappytask(inst)
    inst.happy = false
    inst.endhappytask = nil
end

local function OnGetItemFromPlayer(inst, giver, item)
        inst.AnimState:PlayAnimation("cointoss")
        inst.AnimState:PushAnimation("happy")
        inst.AnimState:PushAnimation("idle", true)
	inst.shangdiangiver = giver--修改
        inst:DoTaskInTime(20/30, ontradeforgold, item, giver)
        inst:DoTaskInTime(1.5, onplayhappysound)
        inst.happy = true
        if inst.endhappytask ~= nil then
            inst.endhappytask:Cancel()
        end
    inst.endhappytask = inst:DoTaskInTime(5, onendhappytask)
	
	
	
	
	--猪王的位置
	local x,y,z = inst.Transform:GetWorldPosition()
	
	inst.AnimState:PlayAnimation("cointoss")
	inst.AnimState:PushAnimation("happy")
	inst.AnimState:PushAnimation("idle", true)
	inst:DoTaskInTime(1.5, onplayhappysound)
	inst.happy = true
	if inst.endhappytask ~= nil then
		inst.endhappytask:Cancel()
	end
	inst.endhappytask = inst:DoTaskInTime(5, onendhappytask)

    if item.components.tradable.goldvalue > 0 then
        
        inst:DoTaskInTime(20/30, ontradeforgold, item)
		
	--挑战书
    elseif item:HasTag("FY_book") then
	
		if item.challenge_type == "leif" then		
			local leif = SpawnPrefab("leif")
			leif.challenge_type = 0
			leif.fy_summon_id = giver.GUID
			leif.Transform:SetPosition(x+2,y,z+2)
				
		elseif item.challenge_type == "bearger" then
		
			local bearger = SpawnPrefab("bearger")
			bearger.challenge_type = 0
			bearger.fy_summon_id = giver.GUID
			bearger.Transform:SetPosition(x+2,y,z+2)
			
		elseif item.challenge_type == "dragonfly" then
		
			local dragonfly = SpawnPrefab("dragonfly")
			dragonfly.challenge_type = 0
			dragonfly.fy_summon_id = giver.GUID
			dragonfly.Transform:SetPosition(x+2,y,z+2)	
			
		elseif item.challenge_type == "minotaur" then		
		
			local minotaur = SpawnPrefab("minotaur")
			minotaur.challenge_type = 0
			minotaur.fy_summon_id = giver.GUID
			minotaur.Transform:SetPosition(x+2,y,z+2)		
		
		end
	end
			
	
end

local function OnRefuseItem(inst, giver, item)
    inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingReject")
    inst.AnimState:PlayAnimation("unimpressed")
    inst.AnimState:PushAnimation("idle", true)
    inst.happy = false
end

local function AcceptTest(inst, item)
    return item.components.tradable    
end

local function OnIsNight(inst, isnight)
    if isnight then
        inst.components.trader:Disable()
        inst.AnimState:PlayAnimation("sleep_pre")
        inst.AnimState:PushAnimation("sleep_loop", true)
    else
        inst.components.trader:Enable()
        inst.AnimState:PlayAnimation("sleep_pst")
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2, .5)

    inst.MiniMapEntity:SetIcon("pigking.png")
    inst.MiniMapEntity:SetPriority(1)

    inst.DynamicShadow:SetSize(10, 5)

    --inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("king")
    inst.AnimState:SetBank("Pig_King")
    inst.AnimState:SetBuild("Pig_King")
    inst.AnimState:PlayAnimation("idle", true)

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("trader")

    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

    inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
        if inst.components.trader and inst.components.trader.enabled then
            OnRefuseItem(inst)
            return true
        end
        return false
    end)
	
	---------------------------------修改 猪王商店系统
	TUNING.ZHUWANG = inst
	inst.shangdianshangpin = {}
	inst.shangdianshoujia = {}
	inst.shangdianjiazhi = {}
	inst.shangdianjilu = {}
	inst.shangdianjilu11 = 0
	inst.shangdianjilu2 = {}
	inst.shangdianjilu22 = 0
	inst.shangdianjilu3 = {}
	inst:AddComponent("talker")
	
	local function OnSave(inst,data)
		if inst.shangdianjilu then data.shangdianjilu = inst.shangdianjilu end--字符串 猪王商店 个人商店
		if inst.shangdianjilu11 then data.shangdianjilu11 = inst.shangdianjilu11 end  --整数 余额
		if inst.shangdianjilu2 then data.shangdianjilu2 = inst.shangdianjilu2 end--字符串 转转乐 彩票
		if inst.shangdianjilu22 then data.shangdianjilu22 = inst.shangdianjilu22 end--整数 余额
		if inst.shangdianjilu3 then data.shangdianjilu3 = inst.shangdianjilu3 end--大奖获得者
	end
	local function OnLoad(inst,data)

		if data and data.shangdianjilu then inst.shangdianjilu = data.shangdianjilu end
		if data and data.shangdianjilu11 then inst.shangdianjilu11 = data.shangdianjilu11 end
		if data and data.shangdianjilu2 then inst.shangdianjilu2 = data.shangdianjilu2 end
		if data and data.shangdianjilu22 then inst.shangdianjilu22 = data.shangdianjilu22 end
		if data and data.shangdianjilu3 then inst.shangdianjilu3 = data.shangdianjilu3 end
		
	end
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	------------------------------------------------修改猪王附近清理乱七八糟
	inst:DoTaskInTime(0, function()
		local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(p1x, p1y, p1z, 25)
		for k,v in pairs(ents) do
			if v.prefab == "homesign" then v:Remove() end
			if v:HasTag("tree") then v:Remove() end
			if v:HasTag("flower") then v:Remove() end
			if v.prefab == "grass" then v:Remove() end
			if v.prefab == "sapling" then v:Remove() end
			if v.prefab == "berrybush" then v:Remove() end
			if v.prefab == "berrybush2" then v:Remove() end
			if v.prefab == "berrybush_juicy" then v:Remove() end
			if v.components.inventoryitem and v.components.inventoryitem:GetContainer() == nil then v:Remove() end
		end
		
	end)
	
	---------------------------------修改
	
    return inst
end

return Prefab("pigking", fn, assets, prefabs)
