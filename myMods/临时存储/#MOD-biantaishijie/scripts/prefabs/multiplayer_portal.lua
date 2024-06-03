local assets =
{
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local function GetVerb()
    return STRINGS.ACTIONS.ACTIVATE.GENERIC
end

local function OnRezPlayer(inst)
    inst.sg:GoToState("spawn_pre")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    local gamemode = TheNet:GetServerGameMode()
    if not GetIsSpawnModeFixed(gamemode) then
        inst.entity:Hide()
        inst:DoTaskInTime(0, inst.Remove)
        return inst
    end

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    -- MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("portal_dst.png")

    inst.AnimState:SetBank("portal_dst")
    inst.AnimState:SetBuild("portal_stone")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("antlion_sinkhole_blocker")

    inst:SetDeployExtraSpacing(2)

    inst.GetActivateVerb = GetVerb

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetStateGraph("SGmultiplayerportal")

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    if GetPortalRez(gamemode) then
        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
        inst:AddTag("resurrector")
    end

    inst:ListenForEvent("ms_newplayercharacterspawned", function(world, data) 
        if data and data.player then
            data.player.AnimState:SetMultColour(0,0,0,1)
            data.player:Hide()
            data.player.components.playercontroller:Enable(false)
            data.player:DoTaskInTime(12*FRAMES, function(inst) 
                data.player:Show()
                data.player:DoTaskInTime(60*FRAMES, function(inst)
                    inst.components.colourtweener:StartTween({1,1,1,1}, 14*FRAMES, function(inst)
                        data.player.components.playercontroller:Enable(true)
                    end)
                end)
            end)
        end
        inst.sg:GoToState("spawn_pre") 
    end, TheWorld)
-----------------------------------修改

    inst:AddTag("emozhimen")
	inst:AddTag("shelter")-- 雨伞保护
	inst.toutaizhuanshi = {}
	inst.toutaizhuanshi2 = {}
	inst.toutaizhuanshi3 = {}
	inst.loottongji = {}

    local function OnSave(inst,data)
		if  inst.mingrenbang then 
		    data.mingrenbang = inst.mingrenbang
		end		
	end
	local function OnLoad(inst,data)
		if  data and data.mingrenbang then 
		    inst.mingrenbang = data.mingrenbang 
		end		
	end
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
    TUNING.EMOZHIMEN = inst
	inst:DoTaskInTime(1, function()
		TUNING.EMOZHIMENx,TUNING.EMOZHIMENy,TUNING.EMOZHIMENz = inst.Transform:GetWorldPosition() --移动密码
	end)

	
	------------------------------------------修改 新手村保护
	inst:DoTaskInTime(1, function()
		
		
		local pt = Vector3(inst.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 25)
		for k,v in pairs(ents) do
			if v.prefab == "wall_moonrock" then v:Remove() end
			if v.prefab == "wall_ruins" then v:Remove() end
			if v.prefab == "eyeturret" then v:Remove() end
			if v.prefab == "firepit" then v:Remove() end
			if v.prefab == "homesign" then v:Remove() end
			if v:HasTag("tree") then v:Remove() end
			if v:HasTag("flower") then v:Remove() end
			if v.prefab == "grass" then v:Remove() end
			if v.prefab == "sapling" then v:Remove() end
			if v.prefab == "berrybush" then v:Remove() end
			if v.prefab == "berrybush2" then v:Remove() end
			if v.prefab == "berrybush_juicy" then v:Remove() end
		end
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 35)
		for k,v in pairs(ents) do
			if v.prefab == "wall_ruins" then v:Remove() end
		end
		if TheWorld:HasTag("cave") then return end
		inst.xinshoubaohu = 1
		inst:AddTag("keyihaunt")
		local spawn = nil
            
				---------------------------------修改 转转乐
	local spawn = SpawnPrefab("homesign") 
	spawn.Transform:SetPosition(pt.x+6, pt.y, pt.z+6) 
	spawn.components.writeable:SetText("转转乐")
	spawn.wufaranshao = true
	spawn:AddComponent("named")
	spawn:AddTag("wufafenjie")
	spawn.components.named:SetName("奖池")
	if spawn.components.workable then
		spawn:RemoveComponent("workable")
	end
	spawn.shangdianshangpin = {}
	spawn.shangdianshangpinx = {}
	spawn.shangdianshangpinz = {}
		
		spawn:DoTaskInTime(0, function()
			local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(p1x, p1y, p1z, 25)
			for k,v in pairs(ents) do
				if (v.components.inventoryitem and v.components.inventoryitem:GetContainer() == nil) then v:Remove() end
			end
		end)
	
	------------------------记录
	spawn:DoPeriodicTask(30.3, function()
		if TUNING.ZHUWANG then
			---local zifuc = " 奖池剩余金元宝"..(TUNING.ZHUWANG.shangdianjilu22 or 0).."个"
			---spawn.components.writeable:SetText("转转乐"..zifuc)
		end
	end)
	------------------------记录
	spawn:DoTaskInTime(5, function()
--------------------------------------------老虎机
		spawn.shangdianshangpin2 = {}
		spawn.shangdianshangpinx2 = {}
		spawn.shangdianshangpinz2 = {}
		spawn.laohujizhuangtai = 0
		local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
		p1x = p1x + 15
		p1z = p1z - 3
		
		local item = SpawnPrefab("nightmare_timepiece") 
		if item then
			item.Transform:SetPosition(p1x, 0, p1z) 
			item.shangdianzhanshi = 7
			item.wufaranshao = true
			item:AddTag("wufafenjie")
			item.zhuanzhuanle = spawn
			item.zhuanzhuanle2 = 1
			item.shangdianjiage = 0
			item:AddComponent("named")
			item.components.named:SetName("大乐透")
		end

		table.insert(spawn.shangdianshangpin2,"carrot")--大20
		table.insert(spawn.shangdianshangpin2,"watermelon")--大30
		table.insert(spawn.shangdianshangpin2,"watermelon")--2
		table.insert(spawn.shangdianshangpin2,"taffy")--赠送2次
		table.insert(spawn.shangdianshangpin2,"pomegranate")--大5
		table.insert(spawn.shangdianshangpin2,"corn")--2
		table.insert(spawn.shangdianshangpin2,"corn")--大2
		table.insert(spawn.shangdianshangpin2,"pumpkin")--大30
		table.insert(spawn.shangdianshangpin2,"dragonfruit")--2
		table.insert(spawn.shangdianshangpin2,"dragonfruit")--大50
		table.insert(spawn.shangdianshangpin2,"pomegranate")--大5
		table.insert(spawn.shangdianshangpin2,"carrot")--2
		table.insert(spawn.shangdianshangpin2,"carrot")--大20
		table.insert(spawn.shangdianshangpin2,"durian")--大40
		table.insert(spawn.shangdianshangpin2,"durian")--2
		table.insert(spawn.shangdianshangpin2,"taffy")--赠送2次
		table.insert(spawn.shangdianshangpin2,"pomegranate")--大5
		table.insert(spawn.shangdianshangpin2,"pumpkin")--2
		table.insert(spawn.shangdianshangpin2,"corn")--大10
		table.insert(spawn.shangdianshangpin2,"pumpkin")--30
		table.insert(spawn.shangdianshangpin2,"eggplant")--75
		table.insert(spawn.shangdianshangpin2,"mandrake")--100
		table.insert(spawn.shangdianshangpin2,"pomegranate")--2
		table.insert(spawn.shangdianshangpin2,"pomegranate")--大5

		local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
		p1x = p1x + 15
		p1z = p1z - 3
		for k,v in pairs(spawn.shangdianshangpin2) do
			local x = 0
			local z = 0
			if k == 1 then x = p1x - 6 z = p1z + 0
			elseif k == 2 then x = p1x - 5 z = p1z + 1
			elseif k == 3 then x = p1x - 4 z = p1z + 2
			elseif k == 4 then x = p1x - 3 z = p1z + 3
			elseif k == 5 then x = p1x - 2 z = p1z + 4
			elseif k == 6 then x = p1x - 1 z = p1z + 5
			elseif k == 7 then x = p1x - 0 z = p1z + 6
			elseif k == 8 then x = p1x + 1 z = p1z + 5
			elseif k == 9 then x = p1x + 2 z = p1z + 4
			elseif k == 10 then x = p1x + 3 z = p1z + 3
			elseif k == 11 then x = p1x + 4 z = p1z + 2
			elseif k == 12 then x = p1x + 5 z = p1z + 1
			elseif k == 13 then x = p1x + 6 z = p1z + 0
			elseif k == 14 then x = p1x + 5 z = p1z - 1
			elseif k == 15 then x = p1x + 4 z = p1z - 2
			elseif k == 16 then x = p1x + 3 z = p1z - 3
			elseif k == 17 then x = p1x + 2 z = p1z - 4
			elseif k == 18 then x = p1x + 1 z = p1z - 5
			elseif k == 19 then x = p1x + 0 z = p1z - 6
			elseif k == 20 then x = p1x - 1 z = p1z - 5
			elseif k == 21 then x = p1x - 2 z = p1z - 4
			elseif k == 22 then x = p1x - 3 z = p1z - 3
			elseif k == 23 then x = p1x - 4 z = p1z - 2
			elseif k == 24 then x = p1x - 5 z = p1z - 1
			end
			table.insert(spawn.shangdianshangpinx2,x)
			table.insert(spawn.shangdianshangpinz2,z) 
		end
		spawn.laohuji3 = {}
		for k,v in pairs(spawn.shangdianshangpin2) do
			local item = SpawnPrefab(v) 
			if item then
				table.insert(spawn.laohuji3,item)
				item.zhuanzhuanle = spawn
				item.Transform:SetPosition(spawn.shangdianshangpinx2[k], 0, spawn.shangdianshangpinz2[k]) 
				item.shangdianzhanshi = 7
				item.wufaranshao = true
				if item.components.perishable then item.components.perishable:StopPerishing() end
				if item.components.fueled then item.components.fueled:StopConsuming() end
				if item.components.edible then item:RemoveComponent("edible") end
				item:AddTag("wufafenjie")
				item.shangdianjiage = 1
				item.laohuji2 = {}
				item:AddComponent("named")
				
				if v == "carrot" then item.laohuji = 20 
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "pomegranate" then item.laohuji = 5
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "eggplant" then item.laohuji = 75
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "pumpkin" then item.laohuji = 30
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "corn" then item.laohuji = 10
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "taffy" then item.laohuji = 0
				item.components.named:SetName("幸运转转转")
				item.shangdianjiage = 0
				elseif v == "durian" then item.laohuji = 40
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "dragonfruit" then item.laohuji = 50
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "watermelon" then item.laohuji = 30
				item.components.named:SetName("赔率"..item.laohuji)
				elseif v == "mandrake" then item.laohuji = 100
				item.components.named:SetName("赔率"..item.laohuji)
				end
				if k == 3 or k == 6 or k == 9 or k == 12 or k == 15 or k == 18 or k == 23 then
					item.Transform:SetScale(0.5, 0.5, 0.5)
					item.components.named:SetName("赔率".."2")
				end
			end
		end
--------------------------------------------老虎机
	
		local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
		p1x = p1x + 6
		p1z = p1z + 6
		
		local item = SpawnPrefab("nightmare_timepiece") 
		if item then
			item.Transform:SetPosition(p1x+1, 0, p1z-1) 
			item.AnimState:SetMultColour(0,1,1, 1)
			item.shangdianzhanshi = 1
			item.wufaranshao = true
			item:AddTag("wufafenjie")
			item.zhuanzhuanle = spawn
			item.zhuanzhuanle2 = 1
			item.shangdianjiage = 2
			item:AddComponent("named")
			item.components.named:SetName("转转乐2元宝")
		end
		local item = SpawnPrefab("nightmare_timepiece") 
		if item then
			item.Transform:SetPosition(p1x+2, 0, p1z-2) 
			item.AnimState:SetMultColour(0,1,1, 1)
			item.shangdianzhanshi = 1
			item.wufaranshao = 1
			item:AddTag("wufafenjie")
			item.zhuanzhuanle = spawn
			item.zhuanzhuanle2 = 1
			item.shangdianjiage = 2
			item:AddComponent("named")
			item.components.named:SetName("转转乐2元宝")
		end
		local item = SpawnPrefab("nightmare_timepiece") 
		if item then
			item.Transform:SetPosition(p1x+3, 0, p1z-3) 
			item.AnimState:SetMultColour(0,1,1, 1)
			item.shangdianzhanshi = 1
			item.wufaranshao = true
			item:AddTag("wufafenjie")
			item.zhuanzhuanle = spawn
			item.zhuanzhuanle2 = 1
			item.shangdianjiage = 2
			item:AddComponent("named")
			item.components.named:SetName("转转乐2元宝")
		end
		local item = SpawnPrefab("nightmare_timepiece") 
		if item then
			item.Transform:SetPosition(p1x-1, 0, p1z+1) 
			item.AnimState:SetMultColour(0,1,1, 1)
			item.shangdianzhanshi = 1
			item.wufaranshao = true
			item:AddTag("wufafenjie")
			item.zhuanzhuanle = spawn
			item.zhuanzhuanle2 = 1
			item.shangdianjiage = 2
			item:AddComponent("named")
			item.components.named:SetName("转转乐2元宝")
		end
		local item = SpawnPrefab("nightmare_timepiece") 
		if item then
			item.Transform:SetPosition(p1x-2, 0, p1z+2) 
			item.AnimState:SetMultColour(0,1,1, 1)
			item.shangdianzhanshi = 1
			item.wufaranshao = true
			item:AddTag("wufafenjie")
			item.zhuanzhuanle = spawn
			item.zhuanzhuanle2 = 1
			item.shangdianjiage = 2
			item:AddComponent("named")
			item.components.named:SetName("转转乐2元宝")
		end
		local item = SpawnPrefab("nightmare_timepiece") 
		if item then
			item.Transform:SetPosition(p1x-3, 0, p1z+3) 
			item.AnimState:SetMultColour(0,1,1, 1)
			item.shangdianzhanshi = 1
			item.wufaranshao = true
			item:AddTag("wufafenjie")
			item.zhuanzhuanle = spawn
			item.zhuanzhuanle2 = 1
			item.shangdianjiage = 2
			item:AddComponent("named")
			item.components.named:SetName("转转乐2元宝")
		end
		
		local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
		p1x = p1x + 6
		p1z = p1z + 6
		p1x = p1x + 8
		p1z = p1z + 7
		local k = 2
		
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")--100    1
		table.insert(spawn.shangdianshangpin,"cane")--5     步行手杖         2
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")        --   3
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")--100       4
		table.insert(spawn.shangdianshangpin,"staff_tornado")--300            5
		table.insert(spawn.shangdianshangpin,"spear")--10     6
		table.insert(spawn.shangdianshangpin,"ruins_bat")--10  远古棒子     7
		table.insert(spawn.shangdianshangpin,"krampus_sack")--100            8
		
		table.insert(spawn.shangdianshangpin,"armorruins")--150-------------- 远古盔甲9
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")   --	10
		table.insert(spawn.shangdianshangpin,"goldnugget")--500              --11
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")--50          12
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")
		table.insert(spawn.shangdianshangpin,"multitool_axe_pickaxe")--500
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")--100
		table.insert(spawn.shangdianshangpin,"thulecite")--5  铥矿    
		
		table.insert(spawn.shangdianshangpin,"thulecite")--20 铥矿
		table.insert(spawn.shangdianshangpin,"goldnugget")--50
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")--------------------------
		
		table.insert(spawn.shangdianshangpin,"nightmare_timepiece")
		table.insert(spawn.shangdianshangpin,"goldnugget")--100
		table.insert(spawn.shangdianshangpin,"goldnugget")--10
		table.insert(spawn.shangdianshangpin,"ruinshat")--5  远古王冠        24
		
		spawn.shangdianshangpindubo = {}
		local dubo = 0
		local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
		p1x = p1x + 6
		p1z = p1z + 6
		local banjing = 6
		for k,v in pairs(spawn.shangdianshangpin) do
			local x = math.cos(2*PI/#spawn.shangdianshangpin*k)*banjing + p1x
			local z = math.sin(2*PI/#spawn.shangdianshangpin*k)*banjing + p1z
			table.insert(spawn.shangdianshangpinx,x)
			table.insert(spawn.shangdianshangpinz,z)
			
			----------------------------------赌博
			if v == "goldnugget" then
				dubo = dubo + 1
				if dubo == 1 then
					spawn.shangdianshangpindubo[k] = 1
				elseif dubo == 2 then
					spawn.shangdianshangpindubo[k] = 1
				elseif dubo == 3 then
					spawn.shangdianshangpindubo[k] = 1
				elseif dubo == 4 then
					spawn.shangdianshangpindubo[k] = 1
				elseif dubo == 5 then
					spawn.shangdianshangpindubo[k] = 1
				elseif dubo == 6 then
					spawn.shangdianshangpindubo[k] = 1
				elseif dubo == 7 then
					spawn.shangdianshangpindubo[k] = 1	
				elseif dubo == 8 then
					spawn.shangdianshangpindubo[k] = 1
				elseif dubo == 9 then
					spawn.shangdianshangpindubo[k] = 1
				end
			end
			----------------------------------赌博
		end
		
		
		
		
		
		
		local dubo = 0
		for k,v in pairs(spawn.shangdianshangpin) do
			local item = SpawnPrefab(v) 
			if item then
				if k > 8 and k < 21 then 
					--item.AnimState:SetMultColour(0,1,0, 1) 
				else
					--item.AnimState:SetMultColour(1,0,0, 1)
				end
				if item.prefab == "nightmare_timepiece" then
					if k == 1 then
					    item:AddComponent("named")
						item.components.named:SetName("谢谢惠顾") 
					elseif k == 15 then
					    item:AddComponent("named")
						item.components.named:SetName("谢谢惠顾") 
					elseif k == 4 then
					    item:AddComponent("named")
						item.components.named:SetName("谢谢惠顾") 
					elseif k == 12 then
					    item:AddComponent("named")
						item.components.named:SetName("谢谢惠顾") 
					elseif k == 6 then
					    item:AddComponent("named")
						item.components.named:SetName("谢谢惠顾") 
					else
					    item:AddComponent("named")
						item.components.named:SetName("谢谢惠顾") 
					end
				end
				----------------------------------赌博
				if item.prefab == "goldnugget" and item.components.named then 
					dubo = dubo + 1
					if dubo == 1 then
					    item:AddComponent("named")
						item.components.named:SetName("5金元宝") 
					elseif dubo == 2 then
					    item:AddComponent("named")
						item.components.named:SetName("10金元宝") 
					elseif dubo == 3 then
					    item:AddComponent("named")
						item.components.named:SetName("500金元宝") 
					elseif dubo == 4 then
					    item:AddComponent("named")
						item.components.named:SetName("5金元宝") 
					elseif dubo == 5 then
					    item:AddComponent("named")
						item.components.named:SetName("20金元宝") 
					elseif dubo == 6 then
					    item:AddComponent("named")
						item.components.named:SetName("50金元宝") 
					elseif dubo == 7 then
					    item:AddComponent("named")
						item.components.named:SetName("100金元宝") 
					elseif dubo == 8 then
					    item:AddComponent("named")
						item.components.named:SetName("10金元宝") 
					elseif dubo == 9 then
					    item:AddComponent("named")
						item.components.named:SetName("5金元宝") 
					end
				end
				----------------------------------赌博
				----------------------------------新年大礼包
				if item.prefab == "krampus_sack" then           ----小偷包      
				    item:AddComponent("named")
					item.components.named:SetName("狗年大礼包")
					item:RemoveComponent("container")
					if item.components.locomotor then item:RemoveComponent("locomotor") end
				end
				----------------------------------
				item.Transform:SetPosition(spawn.shangdianshangpinx[k], 0, spawn.shangdianshangpinz[k]) 
				item.shangdianzhanshi = 0
				item.wufaranshao = true
				if item.components.perishable then item.components.perishable:StopPerishing() end
				if item.components.fueled then item.components.fueled:StopConsuming() end
				if item.components.edible then item:RemoveComponent("edible") end
				item:AddTag("wufafenjie")
				item:RemoveComponent("inventoryitem")   
			end
		end
		
	end)
	
	
	
	
	---------------------------------修改 转转乐

		
		
		
		for i=0,13 do
			for k=0,13 do
				local ppt = Vector3(pt.x+k, pt.y, pt.z+i)
				local world = TheWorld
				local map = world.Map
				if map:CanTerraformAtPoint(ppt:Get()) then
					local original_tile_type = map:GetTileAtPoint(ppt:Get())
					local x, y = map:GetTileCoordsAtPoint(ppt:Get())
					map:SetTile(x, y, GROUND.DIRT)
					map:RebuildLayer(original_tile_type, x, y)
					map:RebuildLayer(GROUND.DIRT, x, y)
					local minimap = world.minimap.MiniMap
					minimap:RebuildLayer(original_tile_type, x, y)
					minimap:RebuildLayer(GROUND.DIRT, x, y)
				end
				local ppt = Vector3(pt.x+k, pt.y, pt.z-i)
				local world = TheWorld
				local map = world.Map
				if map:CanTerraformAtPoint(ppt:Get()) then
					local original_tile_type = map:GetTileAtPoint(ppt:Get())
					local x, y = map:GetTileCoordsAtPoint(ppt:Get())
					map:SetTile(x, y, GROUND.DIRT)
					map:RebuildLayer(original_tile_type, x, y)
					map:RebuildLayer(GROUND.DIRT, x, y)
					local minimap = world.minimap.MiniMap
					minimap:RebuildLayer(original_tile_type, x, y)
					minimap:RebuildLayer(GROUND.DIRT, x, y)
				end
				local ppt = Vector3(pt.x-k, pt.y, pt.z+i)
				local world = TheWorld
				local map = world.Map
				if map:CanTerraformAtPoint(ppt:Get()) then
					local original_tile_type = map:GetTileAtPoint(ppt:Get())
					local x, y = map:GetTileCoordsAtPoint(ppt:Get())
					map:SetTile(x, y, GROUND.DIRT)
					map:RebuildLayer(original_tile_type, x, y)
					map:RebuildLayer(GROUND.DIRT, x, y)
					local minimap = world.minimap.MiniMap
					minimap:RebuildLayer(original_tile_type, x, y)
					minimap:RebuildLayer(GROUND.DIRT, x, y)
				end
				local ppt = Vector3(pt.x-k, pt.y, pt.z-i)
				local world = TheWorld
				local map = world.Map
				if map:CanTerraformAtPoint(ppt:Get()) then
					local original_tile_type = map:GetTileAtPoint(ppt:Get())
					local x, y = map:GetTileCoordsAtPoint(ppt:Get())
					map:SetTile(x, y, GROUND.DIRT)
					map:RebuildLayer(original_tile_type, x, y)
					map:RebuildLayer(GROUND.DIRT, x, y)
					local minimap = world.minimap.MiniMap
					minimap:RebuildLayer(original_tile_type, x, y)
					minimap:RebuildLayer(GROUND.DIRT, x, y)
				end
			end
		end
		
		for i=0,3 do
			for k=0,3 do
				local bbd = 5
				local map = TheWorld.Map
				local original_tile_type = map:GetTileAtPoint(pt:Get())
				local x, y = map:GetTileCoordsAtPoint(pt:Get())
				x = x + k
				y = y + i
				if x and y then
					map:SetTile(x,y, bbd)
					map:RebuildLayer( original_tile_type, x, y )
					map:RebuildLayer( bbd, x, y )
				end

				local minimap = TheWorld.minimap.MiniMap
				minimap:RebuildLayer(original_tile_type, x, y)
				minimap:RebuildLayer(bbd, x, y)
				local map = TheWorld.Map
				local original_tile_type = map:GetTileAtPoint(pt:Get())
				local x, y = map:GetTileCoordsAtPoint(pt:Get())
				x = x + k
				y = y - i
				if x and y then
					map:SetTile(x,y, bbd)
					map:RebuildLayer( original_tile_type, x, y )
					map:RebuildLayer( bbd, x, y )
				end

				local minimap = TheWorld.minimap.MiniMap
				minimap:RebuildLayer(original_tile_type, x, y)
				minimap:RebuildLayer(bbd, x, y)
				local map = TheWorld.Map
				local original_tile_type = map:GetTileAtPoint(pt:Get())
				local x, y = map:GetTileCoordsAtPoint(pt:Get())
				x = x - k
				y = y + i
				if x and y then
					map:SetTile(x,y, bbd)
					map:RebuildLayer( original_tile_type, x, y )
					map:RebuildLayer( bbd, x, y )
				end

				local minimap = TheWorld.minimap.MiniMap
				minimap:RebuildLayer(original_tile_type, x, y)
				minimap:RebuildLayer(bbd, x, y)
				local map = TheWorld.Map
				local original_tile_type = map:GetTileAtPoint(pt:Get())
				local x, y = map:GetTileCoordsAtPoint(pt:Get())
				x = x - k
				y = y - i
				if x and y then
					map:SetTile(x,y, bbd)
					map:RebuildLayer( original_tile_type, x, y )
					map:RebuildLayer( bbd, x, y )
				end

				local minimap = TheWorld.minimap.MiniMap
				minimap:RebuildLayer(original_tile_type, x, y)
				minimap:RebuildLayer(bbd, x, y)
			end
		end

	end)
	

-----------------------------------修改 清理个人商店
    inst:DoPeriodicTask(480*3.01, function(inst)
            local pt = Vector3(inst.Transform:GetWorldPosition())
            local range = 9999
            local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, range, { "gerenshangdian" })
            for k, v in pairs(ents) do
                if (v.huangjin or 0) <= 0 and v.shangdianwupin == nil then v:Remove() end
            end
    end)

------------------------------------修改 死亡之塔
inst:DoTaskInTime(7, function()
	if TheWorld:HasTag("cave") then return end

	local p1x, p1y, p1z = inst.Transform:GetWorldPosition()
	p1x = p1x - 19.5
	p1z = p1z - 19.5
	TUNING.SIWANGZHITAx = p1x
	TUNING.SIWANGZHITAz = p1z

	local ents = TheSim:FindEntities(p1x, 0, p1z, 21)
	for k,v in pairs(ents) do
		if v.prefab == "wall_ruins" then v:Remove() end
		if v.prefab == "firepit" then v:Remove() end
		if v.prefab == "dragonfly_chest" then v:Remove() end
		if v.prefab == "treasurechest" then v:Remove() end
		if v.prefab == "pond" then v:Remove() end
		if v.prefab == "eyeturret" then v:Remove() end
	end
	
	local banjing = 17
	local zhouchang = 85
	for k=1,zhouchang do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,0,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
		end
	end
	local banjing = 16
	local zhouchang = 80
	for k=1,zhouchang do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,0,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
		end
	end
	
	-------------------------------------------------------
	local banjing = 15
	local zhouchang = 75
	for k=3,6 do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,4,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
			if k < 5 then
				spawn.keyipanpa = 1
			end
		end
	end
	local banjing = 16
	local zhouchang = 80
	for k=3,6 do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,4,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
			if k < 5 then
				spawn.keyipanpa = 1
			end
		end
	end
	local banjing = 17
	local zhouchang = 85
	for k=3,6 do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,4,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
			if k < 5 then
				spawn.keyipanpa = 1
			end
		end
	end
	local banjing = 18
	local zhouchang = 90
	for k=3,4 do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,2,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
			spawn.keyipanpa = 1
		end
	end
	local banjing = 18
	local zhouchang = 90
	for k=1,6 do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,0,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
		end
	end
	local banjing = 19
	local zhouchang = 95
	for k=1,6 do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,0,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
			spawn.keyipanpa = 1
		end
	end
	local banjing = 20
	local zhouchang = 100
	for k=1,6 do
		if k > zhouchang*0.0 then
			local x = math.cos(2*PI/zhouchang*k)*banjing + p1x
			local z = math.sin(2*PI/zhouchang*k)*banjing + p1z
			local spawn = SpawnPrefab("wall_ruins")
			spawn:RemoveTag("wall")
			spawn.Transform:SetPosition(x,0,z)
			spawn.components.health:SetMaxHealth(99999)
			if spawn.components.workable then
				spawn:RemoveComponent("workable")
			end
			spawn.keyipanpa = 1
		end
	end
	---------------------------名人榜
	--[[local mingrenbang = SpawnPrefab("homesign")
	mingrenbang.Transform:SetPosition(p1x+23, 0, p1z+10) 
	if mingrenbang.mingrenbang == nil then 
		mingrenbang.mingrenbang = {} 
		mingrenbang.mingrenbang2 = {} 
		mingrenbang.mingrenbang[1] = 0
		mingrenbang.mingrenbang[2] = 0
		mingrenbang.mingrenbang[3] = 0
		mingrenbang.mingrenbang[4] = 0
		mingrenbang.mingrenbang[5] = 0
		mingrenbang.mingrenbang[6] = 0
		mingrenbang.mingrenbang[7] = 0
		mingrenbang.mingrenbang[8] = 0
		mingrenbang.mingrenbang[9] = 0
		mingrenbang.mingrenbang2[1] = "\n最高等级"
		mingrenbang.mingrenbang2[2] = "\n最久存活"
		mingrenbang.mingrenbang2[3] = "\n最高斗兽"
		mingrenbang.mingrenbang2[4] = "\n最有钱人"
		
	end
	if mingrenbang.components.named == nil then mingrenbang:AddComponent("named") end
	mingrenbang.components.named:SetName("名人榜")
	mingrenbang.components.writeable:SetText("名人榜")
	mingrenbang:DoPeriodicTask(30.4, function()
		for k,v in pairs(AllPlayers) do
			if v.dengji and v.dengji > mingrenbang.mingrenbang[1] then 
				mingrenbang.mingrenbang[1] = v.dengji 
				mingrenbang.mingrenbang2[1] = "\n最高等级"..mingrenbang.mingrenbang[1].."级--<"..(v.name or "")..">"
			end
			if v.components.age.saved_age > mingrenbang.mingrenbang[2] then 
				mingrenbang.mingrenbang[2] = v.components.age.saved_age
				mingrenbang.mingrenbang2[2] = "\n最久存活"..math.floor(mingrenbang.mingrenbang[2]/480).."天--<"..(v.name or "")..">"
			end
			if v.siwangzhitaceng and v.siwangzhitaceng > mingrenbang.mingrenbang[3] then 
				mingrenbang.mingrenbang[3] = v.siwangzhitaceng
				mingrenbang.mingrenbang2[3] = "\n最高斗兽"..mingrenbang.mingrenbang[3].."层--<"..(v.name or "")..">"
			end
			if v.zuiduohuangjin and v.zuiduohuangjin > mingrenbang.mingrenbang[4] then 
				mingrenbang.mingrenbang[4] = v.zuiduohuangjin
				mingrenbang.mingrenbang2[4] = "\n最有钱人"..mingrenbang.mingrenbang[8].."宝--<"..(v.name or "")..">"
			end
			
		end
		local mingrenbang2 = mingrenbang.mingrenbang2[1]..mingrenbang.mingrenbang2[2]..mingrenbang.mingrenbang2[3]..mingrenbang.mingrenbang2[4]
		mingrenbang.components.named:SetName(mingrenbang2)
	end)]]
	---------------------------
	local spawn = SpawnPrefab("homesign") 
	spawn.Transform:SetPosition(p1x+23, 0, p1z+7) 
	if spawn.components.named == nil then spawn:AddComponent("named") end
	spawn.components.named:SetName("万妖塔")
	spawn.components.writeable:SetText("万妖塔")
	spawn:AddTag("wufafenjie")
	spawn.wufaranshao = true
	if spawn.components.workable then
		spawn:RemoveComponent("workable")
	end
	local item = SpawnPrefab("nightmare_timepiece") 
	if item then
		item.Transform:SetPosition(p1x+24, 0, p1z+8) 
		item.shangdianzhanshi = 6
		item.wufaranshao = true
		item:AddTag("wufafenjie")
		item.shangdianjiage = 30
		item:AddComponent("named")
		item.components.named:SetName("挑战万妖塔需30金元宝")
	end
	
	
	local spawn = SpawnPrefab("firepit")                        -----------四个火焰
	spawn.Transform:SetPosition(p1x-10, 0, p1z+10) 
	spawn:AddTag("wufafenjie")
	spawn:DoPeriodicTask(15.8, function()
		spawn.components.fueled:DoDelta(480) 
	end)
	local spawn = SpawnPrefab("firepit") 
	spawn.Transform:SetPosition(p1x+10, 0, p1z+10) 
	spawn:AddTag("wufafenjie")
	spawn:DoPeriodicTask(15.9, function()
		spawn.components.fueled:DoDelta(480) 
	end)
	local spawn = SpawnPrefab("firepit") 
	spawn.Transform:SetPosition(p1x-10, 0, p1z-10) 
	spawn:AddTag("wufafenjie")
	spawn:DoPeriodicTask(16, function()
		spawn.components.fueled:DoDelta(480) 
	end)
	local spawn = SpawnPrefab("firepit")               ---火堆
	spawn.Transform:SetPosition(p1x+10, 0, p1z-10) 
	spawn:AddTag("wufafenjie")
	spawn:DoPeriodicTask(16.1, function()
		spawn.components.fueled:DoDelta(480) 
	end)
	
	
    ------------总层数
	
	local zongcengshu = 100
	
	inst:DoPeriodicTask(2.09, function()
		local ents = TheSim:FindEntities(p1x, 0, p1z, 15.9)
		local player = nil
		local guai = nil
		for k,v in pairs(ents) do
			if v.prefab ~= "wall_ruins" and v.components.combat then
				if v.siwangzhita == nil or v:HasTag("playerghost") then
					local p3x, p3y, p3z = inst.Transform:GetWorldPosition()
					v.Transform:SetPosition(p3x,p3y,p3z)
					if v:HasTag("player") and v.siwangzhita then
						TheNet:Announce("神秘玩家挑战万妖塔失败")
					end
					v.siwangzhita = nil
				else
					if v:HasTag("player") then
						if player and v.siwangzhita > player.siwangzhita then 
							player = v 
						elseif player == nil then
							player = v
						end
						player.components.temperature:SetTemperature(35)  
						player.components.moisture:DoDelta(-5)          
						player.components.sanity:DoDelta(1)
					elseif v:HasTag("boss") then
						guai = v
					end
				end
			end
			if v.prefab == "evergreen" then v:Remove() end
			if v:HasTag("flower") then v:Remove() end
			if v.prefab == "grass" then v:Remove() end
			if v.prefab == "sapling" then v:Remove() end
			if v.prefab == "berrybush" then v:Remove() end
			if v.prefab == "berrybush2" then v:Remove() end
			if v.prefab == "berrybush_juicy" then v:Remove() end
		end
		if player then
			if guai == nil then
				player.siwangzhita = player.siwangzhita + 1
				if (player.siwangzhitaceng or 0) < player.siwangzhita then
					player.siwangzhitaceng = player.siwangzhita
					---------------------------修改 层数奖励
					if player.siwangzhitaceng == 13 then
					elseif player.siwangzhitaceng == 24 then
					elseif player.siwangzhitaceng == 36 then
					elseif player.siwangzhitaceng == 48 then
					elseif player.siwangzhitaceng == 58 then
					elseif player.siwangzhitaceng == 68 then
					elseif player.siwangzhitaceng == 77 then
					elseif player.siwangzhitaceng == 87 then
					elseif player.siwangzhitaceng == 93 then
					elseif player.siwangzhitaceng == 99 then
					end
					---------------------------修改
				end
				---------------------------修改 层数奖励
				if player.siwangzhita == 13 then
				elseif player.siwangzhita == 24 then
				elseif player.siwangzhita == 36 then
				elseif player.siwangzhita == 48 then
				elseif player.siwangzhita == 58 then
				elseif player.siwangzhita == 68 then
				elseif player.siwangzhita == 77 then
				elseif player.siwangzhita == 87 then
				elseif player.siwangzhita == 93 then
				elseif player.siwangzhita == 99 then
				end
				---------------------------修改
				if player.siwangzhita <= zongcengshu then
					if not player.components.health:IsDead() then
						player.components.health:DoDelta(30)
					end	
					local spawn = nil
					local spawn2 = nil
					local spawn3 = nil
					local spawn4 = nil
					local spawn5 = nil
					local spawnshu = 0
					local spawnlv = 0
					if player.siwangzhita == 5 then
						local suiji = math.random()
						if suiji > 0.25 then
							spawn = SpawnPrefab("spider")
						elseif suiji > 0.5 then
							spawn = SpawnPrefab("spider_hider")
						elseif suiji > 0.75 then
							spawn = SpawnPrefab("spider_spitter")
						else
							spawn = SpawnPrefab("spider_warrior")
						end
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 6 then
						for k=1,2 do
							local suiji = math.random()
							if suiji > 0.25 then
								spawn = SpawnPrefab("spider")
							elseif suiji > 0.5 then
								spawn = SpawnPrefab("spider_hider")
							elseif suiji > 0.75 then
								spawn = SpawnPrefab("spider_spitter")
							else
								spawn = SpawnPrefab("spider_warrior")
							end
							spawnshu = 2
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 7 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.25 then
								spawn = SpawnPrefab("spider")
							elseif suiji > 0.5 then
								spawn = SpawnPrefab("spider_hider")
							elseif suiji > 0.75 then
								spawn = SpawnPrefab("spider_spitter")
							else
								spawn = SpawnPrefab("spider_warrior")
							end
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 8 then
						spawn = SpawnPrefab("spider")
						spawn2 = SpawnPrefab("spider_hider")
						spawn3 = SpawnPrefab("spider_spitter")
						spawn4 = SpawnPrefab("spider_warrior")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
						spawn2.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn2.siwangzhita = player.siwangzhita
						spawn2:DoPeriodicTask(2.21, function()
							if spawn2.components.combat and spawn2.components.combat.target ~= player then
								spawn2.components.combat:SetTarget(player)
							end
						end)
						spawn3.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn3.siwangzhita = player.siwangzhita
						spawn3:DoPeriodicTask(2.21, function()
							if spawn3.components.combat and spawn3.components.combat.target ~= player then
								spawn3.components.combat:SetTarget(player)
							end
						end)
						spawn4.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn4.siwangzhita = player.siwangzhita
						spawn4:DoPeriodicTask(2.21, function()
							if spawn4.components.combat and spawn4.components.combat.target ~= player then
								spawn4.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 9 then
						local suiji = math.random()
						if suiji > 0.33 then
							spawn = SpawnPrefab("hound")
						elseif suiji > 0.66 then
							spawn = SpawnPrefab("firehound")
						else
							spawn = SpawnPrefab("icehound")
						end
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 10 then
						for k=1,2 do
							local suiji = math.random()
							if suiji > 0.33 then
								spawn = SpawnPrefab("hound")
							elseif suiji > 0.66 then
								spawn = SpawnPrefab("firehound")
							else
								spawn = SpawnPrefab("icehound")
							end
							spawnshu = 2
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if player and player:IsValid() and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 11 then
						spawn = SpawnPrefab("icehound")
						spawn2 = SpawnPrefab("firehound")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
						spawn2.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn2.siwangzhita = player.siwangzhita
						spawn2:DoPeriodicTask(2.21, function()
							if spawn2.components.combat and spawn2.components.combat.target ~= player then
								spawn2.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 12 then
						spawn = SpawnPrefab("hound")
						spawn:DoTaskInTime(0, function()
							spawn.qingxiangshi = 100
						end)
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 13 then
					elseif player.siwangzhita == 17 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("frog")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("bat")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("mosquito")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("bee")
							else
								spawn = SpawnPrefab("catcoon")
							end
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 18 then
						for k=1,4 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("frog")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("bat")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("mosquito")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("bee")
							else
								spawn = SpawnPrefab("catcoon")
							end
							spawnshu = 4
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 19 then
						for k=1,5 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("frog")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("bat")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("mosquito")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("bee")
							else
								spawn = SpawnPrefab("catcoon")
							end
							spawnshu = 5
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 20 then
						spawn = SpawnPrefab("frog")
						spawn2 = SpawnPrefab("bat")
						spawn3 = SpawnPrefab("mosquito")
						spawn4 = SpawnPrefab("bee")
						spawn5 = SpawnPrefab("catcoon")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
						spawn2.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn2.siwangzhita = player.siwangzhita
						spawn2:DoPeriodicTask(2.21, function()
							if spawn2.components.combat and spawn2.components.combat.target ~= player then
								spawn2.components.combat:SetTarget(player)
							end
						end)
						spawn3.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn3.siwangzhita = player.siwangzhita
						spawn3:DoPeriodicTask(2.21, function()
							if spawn3.components.combat and spawn3.components.combat.target ~= player then
								spawn3.components.combat:SetTarget(player)
							end
						end)
						spawn4.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn4.siwangzhita = player.siwangzhita
						spawn4:DoPeriodicTask(2.21, function()
							if spawn4.components.combat and spawn4.components.combat.target ~= player then
								spawn4.components.combat:SetTarget(player)
							end
						end)
						spawn5.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn5.siwangzhita = player.siwangzhita
						spawn5:DoPeriodicTask(2.21, function()
							if spawn5.components.combat and spawn5.components.combat.target ~= player then
								spawn5.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 21 then
						for k=1,4 do
							spawn = SpawnPrefab("monkey")
							spawnshu = 4
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 22 then
						for k=1,2 do
							spawn = SpawnPrefab("mossling")
							spawn.mother_dead = true
							spawn.components.health:SetMaxHealth(525)
							spawn:AddTag("mosslingd")
							spawnshu = 2
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 23 then
						spawn = SpawnPrefab("leif")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 24 then
					elseif player.siwangzhita == 29 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.5 then
								spawn = SpawnPrefab("pigman")
							else
								spawn = SpawnPrefab("bunnyman")
							end
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 30 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("pigman")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("bunnyman")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("hound")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("tallbird")
							else
								spawn = SpawnPrefab("merm")
							end
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 31 then
						for k=1,4 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("pigman")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("bunnyman")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("hound")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("tallbird")
							else
								spawn = SpawnPrefab("merm")
							end
							spawnshu = 4
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 32 then
						for k=1,4 do
							spawn = SpawnPrefab("pigguard")
							spawnshu = 4
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 33 then
						spawn = SpawnPrefab("beefalo")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 34 then
						spawn = SpawnPrefab("koalefant_summer")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 35 then
						spawn = SpawnPrefab("spiderqueen")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 36 then
					        ----怪物以后加
					elseif player.siwangzhita == 41 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.5 then
								spawn = SpawnPrefab("slurtle")
							else
								spawn = SpawnPrefab("slurper")
							end
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 42 then
						for k=1,3 do
							spawn = SpawnPrefab("knight")
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 43 then
						for k=1,3 do
							spawn = SpawnPrefab("bishop")
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 44 then
						for k=1,3 do
							spawn = SpawnPrefab("tentacle")
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x, 0, p1z)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 45 then
						for k=1,3 do
							spawn = SpawnPrefab("rocky")
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 46 then
						for k=1,3 do
							spawn = SpawnPrefab("worm")
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 47 then
						spawn = SpawnPrefab("rook")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 48 then
					elseif player.siwangzhita == 53 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.5 then
								spawn = SpawnPrefab("nightmarebeak")
							else
								spawn = SpawnPrefab("crawlingnightmare")
							end
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 54 then
						for k=1,3 do
							spawn = SpawnPrefab("moonpig")
							spawnshu = 3
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 55 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("nightmarebeak")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("crawlingnightmare")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("knight_nightmare")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("bishop_nightmare")
							else
								spawn = SpawnPrefab("moonpig")
							end
							spawnshu = 3
							spawnlv = 3
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 56 then
						for k=1,3 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("nightmarebeak")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("crawlingnightmare")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("knight_nightmare")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("bishop_nightmare")
							else
								spawn = SpawnPrefab("moonpig")
							end
							spawnshu = 3
							spawnlv = 3
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 57 then
						spawn = SpawnPrefab("rook_nightmare")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 58 then
					elseif player.siwangzhita == 63 then
						for k=1,8 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("frog")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("bat")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("penguin")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("monkey")
							else
								spawn = SpawnPrefab("mosquito")
							end
							spawnshu = 8
							spawnlv = 3
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 64 then
						for k=1,12 do
							local suiji = math.random()
							if suiji > 0.2 then
								spawn = SpawnPrefab("frog")
							elseif suiji > 0.4 then
								spawn = SpawnPrefab("bat")
							elseif suiji > 0.6 then
								spawn = SpawnPrefab("penguin")
							elseif suiji > 0.8 then
								spawn = SpawnPrefab("monkey")
							else
								spawn = SpawnPrefab("mosquito")
							end
							spawnshu = 12
							spawnlv = 3
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 65 then
						for k=1,8 do
							spawn = SpawnPrefab("ghost")
							spawnshu = 8
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 66 then
						for k=1,8 do
							spawn = SpawnPrefab("lightninggoat")
							spawnshu = 8
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 67 then
						----TheNet:Announce("死神") 
						for k=1,8 do
							spawn = SpawnPrefab("mossling")
							spawn.mother_dead = true
							spawn.components.health:SetMaxHealth(525)
							spawn:AddTag("mosslingd")
							spawnshu = 8
							spawnlv = 1
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
						end
					elseif player.siwangzhita == 68 then
					elseif player.siwangzhita == 73 then
						spawn = SpawnPrefab("pigman")
						spawn:DoTaskInTime(0, function()
							spawn.qingxiangshi = 100
						end)
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 74 then
						spawn = SpawnPrefab("walrus")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 75 then
						spawn = SpawnPrefab("warg")
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 76 then
						spawn = SpawnPrefab("spiderqueen")
						spawn:DoTaskInTime(0, function()
							spawn.qingxiangshi = 100
						end)
						spawnshu = 1
						spawnlv = 1
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 77 then
					elseif player.siwangzhita == 82 then
						for k=1,4 do
							local suiji = math.random()
							if suiji > 0.125 then
								spawn = SpawnPrefab("spider_warrior")
								spawnshu = 6
							elseif suiji > 0.25 then
								spawn = SpawnPrefab("hound")
								spawnshu = 4
							elseif suiji > 0.375 then
								spawn = SpawnPrefab("catcoon")
								spawnshu = 5
							elseif suiji > 0.5 then
								spawn = SpawnPrefab("bunnyman")
								spawnshu = 3
							elseif suiji > 0.625 then
								spawn = SpawnPrefab("knight")
								spawnshu = 3
							elseif suiji > 0.75 then
								spawn = SpawnPrefab("worm")
								spawnshu = 4
							elseif suiji > 0.875 then
								spawn = SpawnPrefab("pigguard")
								spawnshu = 3
							else
								spawn = SpawnPrefab("merm")
								spawnshu = 4
							end
							spawnlv = 10
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
							spawn.qingxianghuan = (spawn.qingxianghuan or 0) * spawnlv
							spawn.qingxiangteqiang = (spawn.qingxiangteqiang or 0) * spawnlv
							spawn.qingxiangtekuai = (spawn.qingxiangtekuai or 0) * spawnlv
							spawn.qingxianghuo = (spawn.qingxianghuo or 0) * spawnlv
							spawn.qingxiangbing = (spawn.qingxiangbing or 0) * spawnlv
							spawn.qingxiangshan = (spawn.qingxiangshan or 0) * spawnlv
							spawn.qingxiangyou = (spawn.qingxiangyou or 0) * spawnlv
							spawn.qingxiangpi = (spawn.qingxiangpi or 0) * spawnlv
							spawn.qingxiangyuan = (spawn.qingxiangyuan or 0) * spawnlv
							spawn.qingxianghuowu = (spawn.qingxianghuowu or 0) * spawnlv
							spawn.qingxiangbingwu = (spawn.qingxiangbingwu or 0) * spawnlv
							spawn.qingxiangshanwu = (spawn.qingxiangshanwu or 0) * spawnlv
							spawn.qingxiangshiwu = (spawn.qingxiangshiwu or 0) * spawnlv
							spawn.qingxiangchuan = (spawn.qingxiangchuan or 0) * spawnlv
							spawn.qingxiangshi = (spawn.qingxiangshi or 0) * spawnlv
						end
					elseif player.siwangzhita == 83 then
						for k=1,4 do
							local suiji = math.random()
							if suiji > 0.125 then
								spawn = SpawnPrefab("spider_warrior")
								spawnshu = 6
							elseif suiji > 0.25 then
								spawn = SpawnPrefab("hound")
								spawnshu = 4
							elseif suiji > 0.375 then
								spawn = SpawnPrefab("catcoon")
								spawnshu = 5
							elseif suiji > 0.5 then
								spawn = SpawnPrefab("bunnyman")
								spawnshu = 3
							elseif suiji > 0.625 then
								spawn = SpawnPrefab("knight")
								spawnshu = 3
							elseif suiji > 0.75 then
								spawn = SpawnPrefab("worm")
								spawnshu = 4
							elseif suiji > 0.875 then
								spawn = SpawnPrefab("pigguard")
								spawnshu = 3
							else
								spawn = SpawnPrefab("merm")
								spawnshu = 4
							end
							spawnlv = 10
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
							spawn.qingxianghuan = (spawn.qingxianghuan or 0) * spawnlv
							spawn.qingxiangteqiang = (spawn.qingxiangteqiang or 0) * spawnlv
							spawn.qingxiangtekuai = (spawn.qingxiangtekuai or 0) * spawnlv
							spawn.qingxianghuo = (spawn.qingxianghuo or 0) * spawnlv
							spawn.qingxiangbing = (spawn.qingxiangbing or 0) * spawnlv
							spawn.qingxiangshan = (spawn.qingxiangshan or 0) * spawnlv
							spawn.qingxiangyou = (spawn.qingxiangyou or 0) * spawnlv
							spawn.qingxiangpi = (spawn.qingxiangpi or 0) * spawnlv
							spawn.qingxiangyuan = (spawn.qingxiangyuan or 0) * spawnlv
							spawn.qingxianghuowu = (spawn.qingxianghuowu or 0) * spawnlv
							spawn.qingxiangbingwu = (spawn.qingxiangbingwu or 0) * spawnlv
							spawn.qingxiangshanwu = (spawn.qingxiangshanwu or 0) * spawnlv
							spawn.qingxiangshiwu = (spawn.qingxiangshiwu or 0) * spawnlv
							spawn.qingxiangchuan = (spawn.qingxiangchuan or 0) * spawnlv
							spawn.qingxiangshi = (spawn.qingxiangshi or 0) * spawnlv
						end
					elseif player.siwangzhita == 84 then
						for k=1,4 do
							local suiji = math.random()
							if suiji > 0.125 then
								spawn = SpawnPrefab("spider_warrior")
								spawnshu = 6
							elseif suiji > 0.25 then
								spawn = SpawnPrefab("hound")
								spawnshu = 4
							elseif suiji > 0.375 then
								spawn = SpawnPrefab("catcoon")
								spawnshu = 5
							elseif suiji > 0.5 then
								spawn = SpawnPrefab("bunnyman")
								spawnshu = 3
							elseif suiji > 0.625 then
								spawn = SpawnPrefab("knight")
								spawnshu = 3
							elseif suiji > 0.75 then
								spawn = SpawnPrefab("worm")
								spawnshu = 4
							elseif suiji > 0.875 then
								spawn = SpawnPrefab("pigguard")
								spawnshu = 3
							else
								spawn = SpawnPrefab("merm")
								spawnshu = 4
							end
							spawnlv = 10
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
							spawn.qingxianghuan = (spawn.qingxianghuan or 0) * spawnlv
							spawn.qingxiangteqiang = (spawn.qingxiangteqiang or 0) * spawnlv
							spawn.qingxiangtekuai = (spawn.qingxiangtekuai or 0) * spawnlv
							spawn.qingxianghuo = (spawn.qingxianghuo or 0) * spawnlv
							spawn.qingxiangbing = (spawn.qingxiangbing or 0) * spawnlv
							spawn.qingxiangshan = (spawn.qingxiangshan or 0) * spawnlv
							spawn.qingxiangyou = (spawn.qingxiangyou or 0) * spawnlv
							spawn.qingxiangpi = (spawn.qingxiangpi or 0) * spawnlv
							spawn.qingxiangyuan = (spawn.qingxiangyuan or 0) * spawnlv
							spawn.qingxianghuowu = (spawn.qingxianghuowu or 0) * spawnlv
							spawn.qingxiangbingwu = (spawn.qingxiangbingwu or 0) * spawnlv
							spawn.qingxiangshanwu = (spawn.qingxiangshanwu or 0) * spawnlv
							spawn.qingxiangshiwu = (spawn.qingxiangshiwu or 0) * spawnlv
							spawn.qingxiangchuan = (spawn.qingxiangchuan or 0) * spawnlv
							spawn.qingxiangshi = (spawn.qingxiangshi or 0) * spawnlv
						end
					elseif player.siwangzhita == 85 then
					
						for k=1,4 do
							local suiji = math.random()
							if suiji > 0.125 then
								spawn = SpawnPrefab("spider_warrior")
								spawnshu = 6
							elseif suiji > 0.25 then
								spawn = SpawnPrefab("hound")
								spawnshu = 4
							elseif suiji > 0.375 then
								spawn = SpawnPrefab("catcoon")
								spawnshu = 5
							elseif suiji > 0.5 then
								spawn = SpawnPrefab("bunnyman")
								spawnshu = 3
							elseif suiji > 0.625 then
								spawn = SpawnPrefab("knight")
								spawnshu = 3
							elseif suiji > 0.75 then
								spawn = SpawnPrefab("worm")
								spawnshu = 4
							elseif suiji > 0.875 then
								spawn = SpawnPrefab("pigguard")
								spawnshu = 3
							else
								spawn = SpawnPrefab("merm")
								spawnshu = 4
							end
							spawnlv = 10
						
							spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
							spawn.siwangzhita = player.siwangzhita
							spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
								if spawn.components.combat and spawn.components.combat.target ~= player then
									spawn.components.combat:SetTarget(player)
								end
							end)
							spawn.qingxianghuan = (spawn.qingxianghuan or 0) * spawnlv
							spawn.qingxiangteqiang = (spawn.qingxiangteqiang or 0) * spawnlv
							spawn.qingxiangtekuai = (spawn.qingxiangtekuai or 0) * spawnlv
							spawn.qingxianghuo = (spawn.qingxianghuo or 0) * spawnlv
							spawn.qingxiangbing = (spawn.qingxiangbing or 0) * spawnlv
							spawn.qingxiangshan = (spawn.qingxiangshan or 0) * spawnlv
							spawn.qingxiangyou = (spawn.qingxiangyou or 0) * spawnlv
							spawn.qingxiangpi = (spawn.qingxiangpi or 0) * spawnlv
							spawn.qingxiangyuan = (spawn.qingxiangyuan or 0) * spawnlv
							spawn.qingxianghuowu = (spawn.qingxianghuowu or 0) * spawnlv
							spawn.qingxiangbingwu = (spawn.qingxiangbingwu or 0) * spawnlv
							spawn.qingxiangshanwu = (spawn.qingxiangshanwu or 0) * spawnlv
							spawn.qingxiangshiwu = (spawn.qingxiangshiwu or 0) * spawnlv
							spawn.qingxiangchuan = (spawn.qingxiangchuan or 0) * spawnlv
							spawn.qingxiangshi = (spawn.qingxiangshi or 0) * spawnlv
						end
					elseif player.siwangzhita == 86 then
						spawn = SpawnPrefab("spat")
						spawnshu = 1
						spawnlv = 1		
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 87 then
					elseif player.siwangzhita == 92 then
						spawn = SpawnPrefab("deerclops")
						spawn:DoTaskInTime(0, function()
							spawn.qingxianglingqibing = 100
							spawn.qingxiangyuan = 100
						end)
						spawnshu = 1
						spawnlv = 1	
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 93 then
					elseif player.siwangzhita == 98 then
						spawn = SpawnPrefab("minotaur")
						spawnshu = 1
						spawnlv = 1	
						spawn.Transform:SetPosition(p1x-6+math.random()*12, 0, p1z-6+math.random()*12)
						spawn.siwangzhita = player.siwangzhita
						spawn.components.combat:SetTarget(player) spawn:DoPeriodicTask(9999, function()
							if spawn.components.combat and spawn.components.combat.target ~= player then
								spawn.components.combat:SetTarget(player)
							end
						end)
					elseif player.siwangzhita == 99 then
					end
				end
			end
		else
			if guai then
				guai:Remove()
			end
		end
	end)
end)
------------------------------------以上 修改 万妖塔

-----------------------------------------修改彩票
	
	inst:DoPeriodicTask(481, function(inst)     
		if not TheWorld:HasTag("cave") then 
			inst.danseqiu2 = ""
			for k=1,2 do
				local aa = math.floor(math.random()*9.9)
				inst.danseqiu2 = inst.danseqiu2..aa
			end
						
			local dd = "本期《彩票》 开奖号码是<"..inst.danseqiu2..">"
			if TUNING.ZHUWANG then
				dd = dd.."奖金为金元宝"..(500+math.floor(math.max((TUNING.ZHUWANG.shangdianjilu22) * 0.1,0))).."个".." 购买请按U输入#cp 彩票号码"
			end

			TheNet:Announce(dd)
			for k,v in pairs(AllPlayers) do
				if v:IsValid() then
				
					for i,j in pairs(v.danseqiuhaoma) do
						if j == inst.danseqiu2 and i <= 10 then
							danseqiucaipiaozhongjiang(v)
						end
					end
					v.danseqiuhaoma = {}
				end
			end
		end
	end)
-----------------------------------------修改彩票
    inst:ListenForEvent("rez_player", OnRezPlayer)
	
		local id = TheShard:GetShardId()
		inst:AddComponent("named")	 
		inst.components.named:SetName("世界  " ..id.. "\n恶魔之门")
		inst.components.inspectable:SetDescription("世界  " ..id.. "\n恶魔之门\n输入#666 #复活 可复活\n 输入#重生 #restart 可重生")
	
	

    return inst
end

return Prefab("multiplayer_portal", fn, assets)
