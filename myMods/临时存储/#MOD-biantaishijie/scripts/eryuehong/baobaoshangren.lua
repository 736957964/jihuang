GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	

--根据权值获取物品,需传入一个table
function FFDX(choices)   -----------发放东西
    local function weighted_total(choices)
        local total = 0
        for choice, weight in pairs(choices) do
            total = total + weight
        end
        return total
    end
    local threshold = math.random() * weighted_total(choices)
    local last_choice
    for choice, weight in pairs(choices) do
        threshold = threshold - weight
        if threshold <= 0 then return choice end
        last_choice = choice
    end
    return last_choice
end





--礼物列表
local giftsTable = {
	redgem = 30,
	bluegem = 30,
	pigskin = 30,
	livinglog = 10,
	silk = 100,
	poop = 200,
	spidergland = 50,
	boards = 100,
	gears = 10,
	walrus_tusk = 5,
	papyrus = 50,
	tentaclespots = 20,
	beefalowool = 30,
	cutreeds = 50,
	feather_robin = 50,
	feather_crow = 50,
	feather_robin_winter = 50,
	feather_canary = 50,
	stinger = 100,
	durian = 50,
	dragonfruit = 50,
	wormlight = 30,
	turf_carpetfloor = 200,
	turf_checkerfloor = 200,
	horn = 20,
	krampus_sack = 1,
	nightmarefuel = 100,
	healingsalve = 150,
	bandage = 100,
}

--扔礼物
local function throwGifts(inst)
	inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
    local gift_num = math.random(1, 3)
	local gift_name = nil
    for k = 1, gift_num do
		gift_name = FFDX(giftsTable)
        local nug = SpawnPrefab(gift_name)
        local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0, 4.5, 0)
        
        nug.Transform:SetPosition(pt:Get())
        local down = TheCamera:GetDownVec()
        local angle = math.atan2(down.z, down.x) + (math.random() * 60 - 30) * DEGREES
        local sp = math.random() * 4 + 2
        nug.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 8, sp * math.sin(angle))
    end
end

--猪王的恩惠
local function morningFunny(inst)
	inst.AnimState:PushAnimation("hungry")
	inst.AnimState:PushAnimation("idle", true)
	inst:DoTaskInTime(20/30, throwGifts)
	inst.happy = true
	if inst.endhappytask ~= nil then
		inst.endhappytask:Cancel()
	end
end




local function OnGetItemFromPlayer(inst, giver, item)
    local is_event_item = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and item.components.tradable.halloweencandyvalue and item.components.tradable.halloweencandyvalue > 0
    if item.components.tradable.goldvalue > 0 or is_event_item then
		inst.AnimState:PlayAnimation("bow_pre")        -----完美的动作
        inst.AnimState:PushAnimation("idle", true)
        inst.happy = true
        if inst.endhappytask ~= nil then
            inst.endhappytask:Cancel()
        end
    end
end

local function OnRefuseItem(inst, giver, item)
	inst.AnimState:PlayAnimation("hungry")
    inst.AnimState:PushAnimation("idle", true)
    inst.happy = false
end

local function OnIsNight(inst, isnight)
    if isnight then
        inst.components.trader:Disable()
		inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("bedroll", false)  
    else
        inst.components.trader:Enable()
		inst.AnimState:PlayAnimation("powerup")
    end
	
	--猪王的恩惠
	inst:DoTaskInTime(3, function()
		if inst then
			morningFunny(inst)
		end
	end)
end


--猪王已猪王为载体
function BBSR(inst)
	inst.AnimState:SetBank("wilson")    
    inst.AnimState:SetBuild("wilson")
    inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetFourFaced() 
    inst.AnimState:OverrideSymbol("swap_object", "swap_cane", "swap_cane")
    inst.AnimState:Hide("ARM_normal") 
    inst.AnimState:Show("ARM_carry")
    inst.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    inst.AnimState:Show("HAT")
    inst.AnimState:Show("HAT_HAIR")
    inst.AnimState:Hide("HAIR_NOHAT")
    inst.AnimState:Hide("HAIR")	
	inst.Transform:SetScale(2, 2, 2) 
	inst.DynamicShadow:SetSize(1, 0.5) 
	if inst.challenge_type == 1 then
		inst.components.named:SetName("每日礼物领取")
		inst.components.inspectable:SetDescription("每天早晨会出现礼物")
		inst.components.trader.onaccept = OnGetItemFromPlayer
		inst.components.trader.onrefuse = OnRefuseItem

		inst:WatchWorldState("isnight", OnIsNight)
	end
	
	
end

AddPrefabPostInit("pigking", function(inst)
	if inst then
		inst:AddComponent("named")
		inst:DoTaskInTime(0, function()
			if inst.challenge_type ~= nil then
				BBSR(inst)
			end
		end)
		----保存
		inst.OnSave = function(inst, data)
			data.challenge_type = inst.challenge_type
		end
		inst.OnPreLoad = function(inst, data)
			if data then
				inst.challenge_type = data.challenge_type
			end
		end
	end
end)


AddPrefabPostInit("multiplayer_portal", function(inst)

	if inst then
		inst:DoTaskInTime(0, function()
			local pt = inst:GetPosition()
			local x,y,z = pt:Get()
			
			local r = SpawnPrefab("pigking")
			r.Transform:SetPosition(x+15,y,z+21)
			r.persists = false
			---r.AddTag("liwu")
			r.challenge_type = 1
			BBSR(r)
			
		end)
	end

end)














