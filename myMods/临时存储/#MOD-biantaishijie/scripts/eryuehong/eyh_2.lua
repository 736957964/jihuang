
local RenWuShuXing = true	
local XiTongGongGao =  false    ----关闭了系统公告
local QL_em = 50

local ZW_max = 60 --每位玩家的种植上限
local ZW_exp = 5  --玩家采集作物后，给予作物的经验值
------------执行


GLOBAL.UUU = function(s)
    for k, v in pairs(GLOBAL.AllPlayers) do
        if v and v:GetDisplayName() == s then
            return v
        end
    end
    return
end

---------------------公告 ~~~~~~~~~~
local gonggao = '十步杀一人\n千里不留行\n事了拂衣去\n深藏身与名'	
local gonggao1 = '人生得意须尽欢\n莫使金樽空对月\n抽刀断水水更流\n举杯消愁愁更愁'	

if XiTongGongGao then
	AddPrefabPostInit("world",function(inst)
		inst._xtgg = inst:DoPeriodicTask(180,function()
			if GLOBAL.TheShard:GetShardId() == "0"  or  GLOBAL.TheShard:GetShardId() == "1"  or  GLOBAL.TheShard:GetShardId() == "2"  then
				if type(gonggao) == "string" then
					GLOBAL.c_announce(gonggao,nil,"system")
				end
			end
		end)
		
		inst._xtgg1 = inst:DoPeriodicTask(210,function()
			if GLOBAL.TheShard:GetShardId() == "0"  or  GLOBAL.TheShard:GetShardId() == "1"  or  GLOBAL.TheShard:GetShardId() == "2"  then
				if type(gonggao) == "string" then
					GLOBAL.c_announce(gonggao1,nil,"system")
				end
			end
		end)
		
		
	end)
end

-----------------骨头消失  

AddPrefabPostInit("skeleton", function(inst)
    inst:DoTaskInTime(300, function()inst:Remove() end)
end)
AddPrefabPostInit("skeleton_player", function(inst)
    inst:DoTaskInTime(10, function()inst:Remove() end)
end)
     
	 
	 

     -----------------门口 产生建筑 
local function jspanding(RX, RZ, zu)
    local ZU = zu or false
    if RX and RZ and RX ~= nil and RZ ~= nil and ZU then
        local ents = TheSim:FindEntities(RX, 0, RZ, 1)
        if ents ~= nil then
            for i, ent in ipairs(ents) do
                if ZU and ent.prefab == ZU then
                    return
                end
            end
        end
        local pll = GLOBAL.SpawnPrefab(ZU)
        pll.Transform:SetPosition(RX, 0, RZ)
        pll.ownerlist = {}
        pll.ownerlist[1] = GM_1
        pll.ownerlist[2] = "uid_private"
        if not pll:HasTag("uid_private") then
            pll:AddTag("uid_private")
        end
    end
end



local function shanchu(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local Fan_wei = QL_em
    local ents = TheSim:FindEntities(x, y, z, Fan_wei)
    if ents ~= nil then
        for i, ent in ipairs(ents) do
            if ent.ownerlist and ent.ownerlist[1] ~= GM_1 and ent.ownerlist[1] ~= GM_2 then
                GLOBAL.SpawnPrefab("collapse_small").Transform:SetPosition(ent.Transform:GetWorldPosition())
                ent:Remove()
            end
        end
    end
    
    local ents = TheSim:FindEntities(x + 6, 0, z + 6, 1)
    if ents ~= nil then
        for i, ent in ipairs(ents) do
            if ent.prefab == "homesign" then
                ent:Remove()
            end
        end
    end
    
    local inn = GLOBAL.SpawnPrefab("homesign")
    inn.Transform:SetPosition(x + 6, 0, z + 6)
    inn.AnimState:SetMultColour(1, .035, 1, 1)
    inn.AnimState:SetAddColour(1, 0, 1, 0)
    inn.ownerlist = {}
    inn.ownerlist[1] = GM_1
    inn.ownerlist[2] = "uid_private"
    if not inn:HasTag("uid_private") then
        inn:AddTag("uid_private")
    end
    ---inn:AddComponent("named")
	---inn.components.named:SetName("✿✿      ✿✿\r✿      ✿ ✿     ✿\r✿                 ✿\r✿        ✿\r✿\r\r\r ")
	inn.components.writeable.text = "☀"
    inn.components.inspectable.getspecialdescription = function(inst, viewer)
        return string.format("✿✿      ✿✿\r✿      ✿ ✿     ✿\r✿                 ✿\r✿        ✿\r✿\r\r\r ") end

 
   -- jspanding(x + 6 + 2, z + 6 - 2, "firepit")
   -- jspanding(x + 6 - 2, z + 6 + 2, "perdshrine")
end

AddPrefabPostInit("multiplayer_portal", function(inst)
    inst:AddTag("multiplayer_portal")
    ---inst.xinrenqushanchu = inst:DoPeriodicTask(30, shanchu,GLOBAL.TheNet:Announce("☂二月锁☂  已经在恶魔门生成设施"))
	---GLOBAL.TheNet:Announce("☂二月锁☂  已经在恶魔门生成设施")
	
	
end)


------------------------------------------------------以上没问题








































---------------------------------------------------------------------------------以下是作物等级系统
local _DIG =
    {
        {
            name = "berrybush",
        },
        {
            name = "berrybush2",
        },
        {
            name = "berrybush_juicy",
        },
        {
            name = "sapling",
        },
        {
            name = "grass",
        },
        {
            name = "marsh_bush",
        },
    }

local function ondeploy_5(inst, pt, deployer)
    local ents = {}
    local ents = TheSim:FindEntities(pt.x, 0, pt.z, 5000, {"DIG_YIZHI", 'DIG_' .. deployer.userid})
    if ents ~= nil and #ents >= ZW_max and deployer ~= nil then
        if deployer ~= nil and deployer.components.talker then
            inst.components.stackable:Get().Transform:SetPosition(pt:Get())
            deployer:DoTaskInTime(.1, function()deployer.components.talker:Say("☂二月锁☂：您的个人移植上限已用完") end)
            return
        end
    end
       
    for i, v in ipairs(_DIG) do
        if v and inst and inst.prefab == "dug_" .. v.name then
            local tree = GLOBAL.SpawnPrefab(v.name)
            if tree ~= nil then
                tree.Transform:SetPosition(pt:Get())
                inst.components.stackable:Get():Remove()
                tree.components.pickable:OnTransplant()
                
                
                if deployer ~= nil and deployer.userid then
                    tree.DIG_1 = {'DIG_' .. deployer.userid, "DIG_YIZHI"}
                    tree:AddTag('DIG_' .. deployer.userid)
                    tree:AddTag("DIG_YIZHI")
                    if tree.components.workable ~= nil then
                        tree.components.workable_new = tree.components.workable
                        tree.components.workable = nil
                    end
                    tree:RemoveComponent('propagator')
                    tree:RemoveTag("canlight")
                end
                
                if deployer ~= nil and deployer.SoundEmitter ~= nil then
                    deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
                end
            end
        end
    end
end

local function OnSave_8(inst, data)
    if inst.OldOnSave_8 ~= nil then
        inst.OldOnSave_8(inst, data)
    end
    if inst.DIG_1 and inst.DIG_1 ~= nil then
        data.DIG_1 = inst.DIG_1
    end
    if inst._LEVEL ~= nil and inst._EXP ~= nil then
        data._LEVEL = inst._LEVEL
        data._EXP = inst._EXP
    end
end

local function OnLoad_8(inst, data)
    if inst.OldOnLoad_8 ~= nil then
        inst.OldOnLoad_8(inst, data)
    end
    if data ~= nil and data.DIG_1 and data.DIG_1 ~= nil then
        inst.DIG_1 = data.DIG_1
        for i, v in ipairs(inst.DIG_1) do
            inst:AddTag(v)
        end
        if inst and inst.components.workable ~= nil then
            inst.components.workable_new = inst.components.workable
            inst.components.workable = nil
        end
        inst:RemoveComponent('propagator')
        inst:RemoveTag("canlight")
    end
    if data ~= nil and data._LEVEL then
        inst._LEVEL = data._LEVEL
    end
    if data ~= nil and data._EXP then
        inst._EXP = data._EXP
    end
end

AddPrefabPostInit("dug_grass", function(inst)
    inst.components.deployable.min_spacing = 2
    inst.components.deployable.ondeploy = ondeploy_5
end)

AddPrefabPostInit("grass", function(inst)
    inst:AddTag("zuowu")
    inst._LEVEL = 1
    inst._EXP = 0
    local old_pick_1 = inst.components.pickable.onpickedfn
    inst.components.pickable.onpickedfn = function(inst, picker, loot)
        old_pick_1(inst, picker, loot)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        if inst:HasTag("DIG_YIZHI") and picker ~= nil and picker:HasTag("player") then
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP < inst._LEVEL * 20 then
                inst._EXP = inst._EXP + ZW_exp
            end
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP >= inst._LEVEL * 20 then
                inst._EXP = 0
                inst._LEVEL = inst._LEVEL + 1
            end
            if picker and picker ~= nil and picker:HasTag("player") and picker.components.talker then
                picker:DoTaskInTime(.1, function()
                    picker.components.talker:Say("\n当前作物属性\n等级Ｌｖ " .. string.format("%d", inst._LEVEL) .. string.format("\n成长经验Ｅｘｐ %d", inst._EXP), 5)
                end)
            end
            if inst._LEVEL and inst._LEVEL > 1 then
                for h = 1, inst._LEVEL - 1, 1 do
                    local CW = GLOBAL.SpawnPrefab("cutgrass")
                    picker.components.inventory:GiveItem(CW)
                end
            end
        end
    end
    inst.OldOnSave_8 = inst.OnSave
    inst.OnSave = OnSave_8
    inst.OldOnLoad_8 = inst.OnLoad
    inst.OnLoad = OnLoad_8
    
    inst.OnPreLoad = function(inst, data) end
end)


AddPrefabPostInit("dug_sapling", function(inst)
    inst.components.deployable.min_spacing = 2
    inst.components.deployable.ondeploy = ondeploy_5
end)

AddPrefabPostInit("sapling", function(inst)
    inst:AddTag("zuowu")
    
    inst._LEVEL = 1
    inst._EXP = 0
    local old_pick_1 = inst.components.pickable.onpickedfn
    inst.components.pickable.onpickedfn = function(inst, picker, loot)
        old_pick_1(inst, picker, loot)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        if inst:HasTag("DIG_YIZHI") and picker ~= nil and picker:HasTag("player") then
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP < inst._LEVEL * 20 then
                inst._EXP = inst._EXP + ZW_exp
            end
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP >= inst._LEVEL * 20 then
                inst._EXP = 0
                inst._LEVEL = inst._LEVEL + 1
            end
            if picker and picker ~= nil and picker:HasTag("player") and picker.components.talker then
                picker:DoTaskInTime(.1, function()
                    picker.components.talker:Say("\n当前作物属性\n等级Ｌｖ " .. string.format("%d", inst._LEVEL) .. string.format("\n成长经验Ｅｘｐ %d", inst._EXP), 5)
                end)
            end
            if inst._LEVEL and inst._LEVEL > 1 then
                for h = 1, inst._LEVEL - 1, 1 do
                    local CW = GLOBAL.SpawnPrefab("twigs")
                    picker.components.inventory:GiveItem(CW)
                end
            end
        end
    end
    inst.OldOnSave_8 = inst.OnSave
    inst.OnSave = OnSave_8
    inst.OldOnLoad_8 = inst.OnLoad
    inst.OnLoad = OnLoad_8
end)
-------
AddPrefabPostInit("dug_berrybush", function(inst)
    inst.components.deployable.min_spacing = 2
    inst.components.deployable.ondeploy = ondeploy_5
end)

AddPrefabPostInit("berrybush", function(inst)
    inst:AddTag("zuowu")
    
    inst._LEVEL = 1
    inst._EXP = 0
    local old_pick_1 = inst.components.pickable.onpickedfn
    inst.components.pickable.onpickedfn = function(inst, picker, loot)
        old_pick_1(inst, picker, loot)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        if inst:HasTag("DIG_YIZHI") and picker ~= nil and picker:HasTag("player") then
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP < inst._LEVEL * 20 then
                inst._EXP = inst._EXP + ZW_exp
            end
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP >= inst._LEVEL * 20 then
                inst._EXP = 0
                inst._LEVEL = inst._LEVEL + 1
            end
            if picker and picker ~= nil and picker:HasTag("player") and picker.components.talker then
                picker:DoTaskInTime(.1, function()
                    picker.components.talker:Say("\n当前作物属性\n等级Ｌｖ " .. string.format("%d", inst._LEVEL) .. string.format("\n成长经验Ｅｘｐ %d", inst._EXP), 5)
                end)
            end
            if inst._LEVEL and inst._LEVEL > 1 then
                for h = 1, inst._LEVEL - 1, 1 do
                    local CW = GLOBAL.SpawnPrefab("berries")
                    picker.components.inventory:GiveItem(CW)
                end
            end
        end
    end
    inst.OldOnSave_8 = inst.OnSave
    inst.OnSave = OnSave_8
    inst.OldOnLoad_8 = inst.OnLoad
    inst.OnLoad = OnLoad_8
end)


AddPrefabPostInit("dug_berrybush2", function(inst)
    inst.components.deployable.min_spacing = 2
    inst.components.deployable.ondeploy = ondeploy_5
end)

AddPrefabPostInit("berrybush2", function(inst)
    inst:AddTag("zuowu")
    inst._LEVEL = 1
    inst._EXP = 0
    local old_pick_1 = inst.components.pickable.onpickedfn
    inst.components.pickable.onpickedfn = function(inst, picker, loot)
        old_pick_1(inst, picker, loot)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        if inst:HasTag("DIG_YIZHI") and picker ~= nil and picker:HasTag("player") then
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP < inst._LEVEL * 20 then
                inst._EXP = inst._EXP + ZW_exp
            end
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP >= inst._LEVEL * 20 then
                inst._EXP = 0
                inst._LEVEL = inst._LEVEL + 1
            end
            if picker and picker ~= nil and picker:HasTag("player") and picker.components.talker then
                picker:DoTaskInTime(.1, function()
                    picker.components.talker:Say("\n当前作物属性\n等级Ｌｖ " .. string.format("%d", inst._LEVEL) .. string.format("\n成长经验Ｅｘｐ %d", inst._EXP), 5)
                end)
            end
            if inst._LEVEL and inst._LEVEL > 1 then
                for h = 1, inst._LEVEL - 1, 1 do
                    local CW = GLOBAL.SpawnPrefab("berries")
                    picker.components.inventory:GiveItem(CW)
                end
            end
        end
    end
    inst.OldOnSave_8 = inst.OnSave
    inst.OnSave = OnSave_8
    inst.OldOnLoad_8 = inst.OnLoad
    inst.OnLoad = OnLoad_8
end)


AddPrefabPostInit("dug_berrybush_juicy", function(inst)
    inst.components.deployable.min_spacing = 2
    inst.components.deployable.ondeploy = ondeploy_5
end)

AddPrefabPostInit("berrybush_juicy", function(inst)
    inst:AddTag("zuowu")
    
    inst._LEVEL = 1
    inst._EXP = 0
    local old_pick_1 = inst.components.pickable.onpickedfn
    inst.components.pickable.onpickedfn = function(inst, picker, loot)
        old_pick_1(inst, picker, loot)
        inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
        if inst:HasTag("DIG_YIZHI") and picker ~= nil and picker:HasTag("player") then
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP < inst._LEVEL * 20 then
                inst._EXP = inst._EXP + ZW_exp
            end
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP >= inst._LEVEL * 20 then
                inst._EXP = 0
                inst._LEVEL = inst._LEVEL + 1
            end
            if picker and picker ~= nil and picker:HasTag("player") and picker.components.talker then
                picker:DoTaskInTime(.1, function()
                    picker.components.talker:Say("\n当前作物属性\n等级Ｌｖ " .. string.format("%d", inst._LEVEL) .. string.format("\n成长经验Ｅｘｐ %d", inst._EXP), 5)
                end)
            end
            if inst._LEVEL and inst._LEVEL > 1 then
                for h = 1, inst._LEVEL * 3 - 3, 1 do
                    local CW = GLOBAL.SpawnPrefab("berries_juicy")
                    picker.components.inventory:GiveItem(CW)
                end
            end
        end
    end
    inst.OldOnSave_8 = inst.OnSave
    inst.OnSave = OnSave_8
    inst.OldOnLoad_8 = inst.OnLoad
    inst.OnLoad = OnLoad_8
end)


AddPrefabPostInit("dug_marsh_bush", function(inst)
    inst.components.deployable.min_spacing = 2
    inst.components.deployable.ondeploy = ondeploy_5
end)

AddPrefabPostInit("marsh_bush", function(inst)
    inst:AddTag("zuowu")
    
    inst._LEVEL = 1
    inst._EXP = 0
    local old_pick_1 = inst.components.pickable.onpickedfn
    inst.components.pickable.onpickedfn = function(inst, picker, loot)
        old_pick_1(inst, picker, loot)
        if inst:HasTag("DIG_YIZHI") and picker ~= nil and picker:HasTag("player") then
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP < inst._LEVEL * 20 then
                inst._EXP = inst._EXP + ZW_exp
            end
            if picker and picker ~= nil and picker:HasTag("player") and inst._LEVEL and inst._LEVEL < 5 and inst._EXP and inst._EXP >= inst._LEVEL * 20 then
                inst._EXP = 0
                inst._LEVEL = inst._LEVEL + 1
            end
            if picker and picker ~= nil and picker:HasTag("player") and picker.components.talker then
                picker:DoTaskInTime(.1, function()
                    picker.components.talker:Say("\n当前作物属性\n等级Ｌｖ " .. string.format("%d", inst._LEVEL) .. string.format("\n成长经验Ｅｘｐ %d", inst._EXP), 5)
                end)
            end
            if inst._LEVEL and inst._LEVEL > 1 then
                for h = 1, inst._LEVEL - 1, 1 do
                    local CW = GLOBAL.SpawnPrefab("twigs")
                    picker.components.inventory:GiveItem(CW)
                end
            end
        end
    end
    inst.OldOnSave_8 = inst.OnSave
    inst.OnSave = OnSave_8
    inst.OldOnLoad_8 = inst.OnLoad
    inst.OnLoad = OnLoad_8
end)


AddStategraphPostInit("wilson", function(sg)
    local _DeathExit = sg.states["death"].onexit
    
    sg.states["death"].onexit = function(inst)
        inst:DoTaskInTime(0, function()GLOBAL.TheNet:Kick(inst.userid) end)
    end
end)





  ---没问题
-----------------------------------------暗夜照明灯
local function OnSave_15(inst, data)
    if inst.OldOnSave_15 ~= nil then
        inst.OldOnSave_15(inst, data)
    end
    if inst._Rl and inst._Rl > 0 then
        data._Rl = inst._Rl
    end
end

local function OnLoad_15(inst, data)
    if inst.OldOnLoad_15 ~= nil then
        inst.OldOnLoad_15(inst, data)
    end
    if data ~= nil and data._Rl and data._Rl > 0 then
        inst._Rl = data._Rl
    end
end

local function _sjzhou(str)
    if str then
        local xa = math.floor(str / 3600)
        local xb = math.floor((str - (xa * 3600)) / 60)
        local xc = math.floor(str - xa * 60 * 60 - xb * 60)
        local xxa = "00"
        local xxb = "00"
        local xxc = "00"
        if xa > 0 and xa < 10 then
            xxa = "0" .. string.format("%d", xa)
        elseif xa >= 10 then
            xxa = string.format("%d", xa)
        end
        if xb > 0 and xb < 10 then
            xxb = "0" .. string.format("%d", xb)
        elseif xb >= 10 then
            xxb = string.format("%d", xb)
        end
        if xc > 0 and xc < 10 then
            xxc = "0" .. string.format("%d", xc)
        elseif xc >= 10 then
            xxc = string.format("%d", xc)
        end
        
        return xxa .. " : " .. xxb .. " : " .. xxc or "0"
    else
        return "0"
    end
end

local function _name_n(inst)
    local aa = "\n暗夜照明灯"
    local bb = "\n剩余照明时间"
    local cc = "\n" .. _sjzhou(inst._Rl)
    local dd = aa .. bb .. cc
    inst.components.named.possiblenames = {dd}
    inst.components.named:PickNewName()
end

local function _SJ(inst)
    if inst._Rl > 5 then
        inst._Rl = inst._Rl - 5
    else
        inst._Rl = 0
        inst._offfn(inst)
    end
    _name_n(inst)
end

local function offon(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local player = GLOBAL.FindClosestPlayerInRange(x, y, z, 15, nil)
    if player ~= nil and GLOBAL.TheWorld.state.phase == "night" and inst._Rl > 0 then
        inst._onfn(inst)
    elseif inst._Fx_1 ~= nil then
        inst._offfn(inst)
    end
end

local function yingdeng_1(inst, giver, item)
    if item and item.prefab == "nightmarefuel" then
        if inst._Rl <= 6900 then
            inst._Rl = inst._Rl + 300
        else
            inst._Rl = 7200
        end
    end
    _name_n(inst)
end

local function yingdeng(inst, item, giver)
    return item.prefab == "nightmarefuel"
end


AddPrefabPostInit("nightmarefuel",function(inst)
    inst:AddComponent("tradable")
end)

AddPrefabPostInit("nightlight_flame",function(inst)
    inst.AnimState:SetMultColour(255/255, 155/255, 255/255, .8)
end)


AddPrefabPostInit("nightlight", function(inst)
    inst:RemoveComponent("fueled")
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("hauntable")
    inst:RemoveComponent("sanityaura")
    inst:StopAllWatchingWorldStates()
    inst:RemoveAllEventCallbacks()
    inst:CancelAllPendingTasks()
    inst:AddTag("_named")
    inst:AddComponent("named")
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(yingdeng)
    inst.components.trader.onaccept = yingdeng_1
    inst._Rl = 0
    inst._Fx_1 = nil
    inst._onfn = function(inst) if inst._Rl >= 0 and inst._Fx_1 == nil then
        inst._Fx_1 = GLOBAL.SpawnPrefab("nightlight_flame")
        inst._Fx_1.components.firefx:SetLevel(4)
        local follower = inst._Fx_1.entity:AddFollower()
        follower:FollowSymbol(inst.GUID, "fire_marker", 0, 0, 0)
        if not inst._CD4 then
            inst._CD4 = inst:DoPeriodicTask(5, _SJ)
        end
    end
    end
    inst._offfn = function(inst)
        if inst._Fx_1 ~= nil then
            inst._Fx_1:Remove()
            inst._Fx_1 = nil
        end
        if inst._CD4 then
            inst._CD4:Cancel()
            inst._CD4 = nil
        end
    end
    inst._update = inst:DoPeriodicTask(1, offon)
    
    inst.OldOnSave_15 = inst.OnSave
    inst.OnSave = OnSave_15
    inst.OldOnLoad_15 = inst.OnLoad
    inst.OnLoad = OnLoad_15
end)




