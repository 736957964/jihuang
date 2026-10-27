
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
				
local function LM(inst) 
    inst.components.pickable:SetUp("halloweencandy_13", TUNING.BERRY_REGROW_TIME)
    inst.components.pickable.getregentimefn = getregentimefn_normal
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
end
local function HM(inst)
    inst.components.pickable:SetUp("halloweencandy_14", TUNING.BERRY_REGROW_TIME)
    inst.components.pickable.getregentimefn = getregentimefn_normal
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
end


AddPrefabPostInit("berrybush",function(inst)
	if  inst then
	    inst:AddComponent("named")	 
		if math.random() < 0.28 then	
		inst.components.named:SetName("蓝莓浆果丛")
		inst.components.inspectable:SetDescription("蓝莓好吃哦~")
		inst.AnimState:SetMultColour(0, 1, 0, 1)		 
		LM(inst)
        end
		
		if math.random() < 0.3 then		
		inst.components.named:SetName("红辣椒果丛")
		inst.components.inspectable:SetDescription("辣妹子啦 辣妹子辣")
		inst.AnimState:SetMultColour(1, 0, 0, 1)
		HM(inst)
		end
		
		
	end
end)

AddPrefabPostInit("halloweencandy_13",function(inst)   -----c_give("halloweencandy_13")

    if  inst then
        inst:AddComponent("named")	
        inst.components.named:SetName("蓝莓果实")	
        inst.components.edible.hungervalue = 35
        inst.components.edible.healthvalue = 20
        inst.components.edible.sanityvalue = 20	
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
    end
	
end)
AddPrefabPostInit("halloweencandy_14",function(inst)   -----c_give("halloweencandy_14")

    if  inst then
        inst:AddComponent("named")	
        inst.components.named:SetName("红色辣椒")
        inst.components.edible.hungervalue = 35
        inst.components.edible.healthvalue = 20
        inst.components.edible.sanityvalue = 20	
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
    end
	
end)

AddPrefabPostInit("halloweencandy_1",function(inst)   -----苹果

    if  inst then
        inst:AddComponent("named")	
        inst.components.named:SetName("红苹果")
        inst.components.edible.hungervalue = 35
        inst.components.edible.healthvalue = 20
        inst.components.edible.sanityvalue = 20	
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
    end
	
end)

-----------------------------------------------玩家名字。

--[[inst:AddComponent("named")--修改

		inst:DoTaskInTime(0, function()
			inst.wanjianame = inst.Network:GetClientName()
		end)
			
		inst:DoPeriodicTask(2, function(inst)
			local A = ""
			local B = ""
           A = "<可爱>"..A
			B = "<美丽的>\r"..B
			if inst.wanjianame == "饥友在这里改名" then 
			   local  J = math.random () 
			   if J  < 0.2  then 
			   inst.wanjianame = "喜羊羊" 
			   elseif J < 0.3 then 
			   inst.wanjianame = "懒羊羊" 
			   elseif J < 0.4 then 
			   inst.wanjianame = "美羊羊" 
			   end
			end
			inst.components.named:SetName(A..B..(inst.wanjianame or "").."\r等级："..(100))
		end)

]]


AddPrefabPostInit("multiplayer_portal",function(inst)
	if IsServer then
		inst:DoTaskInTime(0,function()
			if not inst.haszone then
				inst.haszone = true
				local x,y,z = inst.Transform:GetWorldPosition()

			end
		end)		
		inst.OnSave = function(inst,data)
			data.haszone = inst.haszone
		end
		inst.OnLoad = function(inst,data)
			inst.haszone = inst.haszone
		end
	end
end)

----------------------暖石头无耐久

local old_TemperatureChange
local old_heatrock_fn

local function new_TemperatureChange(inst, data)
	inst.components.fueled = {
		GetPercent = function() return 1 end,
		SetPercent = function() end,
	}
	old_TemperatureChange(inst, data)
	inst.components.fueled = nil
end

local function new_heatrock_fn(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:RemoveComponent("fueled")

		local function switchListenerFns(t)
			local listeners = t["temperaturedelta"]
			local listener_fns = listeners[inst]
			old_TemperatureChange = listener_fns[1]
			listener_fns[1] = new_TemperatureChange
		end

		switchListenerFns(inst.event_listeners)
		switchListenerFns(inst.event_listening)
	end
end

AddPrefabPostInit("heatrock", new_heatrock_fn)












