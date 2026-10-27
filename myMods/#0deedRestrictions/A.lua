
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
				
IsServer = TheNet:GetIsServer()

-- modimport("A.lua")--当前只有一个 因为属于测试

--开局封闭区域
TUNING.H1Z1_ZONE_LENGTH = 24		--半径即正方形的边长一半
local npc_dist = 18
function IsInStartZone(inst)
	if not TUNING.H1Z1_START_POS_X or not TUNING.H1Z1_START_POS_Z then
		local start = c_find("multiplayer_portal")
		if start and start:IsValid() then
			local x,y,z = start.Transform:GetWorldPosition()
			TUNING.H1Z1_START_POS_X = x
			TUNING.H1Z1_START_POS_Z = z
		end
	end
	if TUNING.H1Z1_START_POS_X and TUNING.H1Z1_START_POS_Z then
		local x1,y1,z1 = inst.Transform:GetWorldPosition()
		return math.abs(TUNING.H1Z1_START_POS_X - x1) < TUNING.H1Z1_ZONE_LENGTH and math.abs(TUNING.H1Z1_START_POS_Z - z1) < TUNING.H1Z1_ZONE_LENGTH
	end
	return false
end

local function SpawnBasalt(x,z)
	local t = SpawnPrefab("basalt_pillar")
	t.Transform:SetPosition(x,0,z)
	if not t:IsOnValidGround() then
		t:Remove()
	end
end
local function SpawnBasaltB(x,z)--斗兽场2层围墙
 local pt1 = Vector3(x-11, 2,z-11)--圆心
    for k = 1, 60 do
        local result_offset = FindValidPositionByFan(1 * 2 * PI, 10, 60, function(offset)--围成圆形（角度，半径，个数）
            local x,y,z = (pt1 + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset then
	local t = SpawnPrefab("wall_ruins")
	t.AnimState:PlayAnimation("fullC")
           MakeObstaclePhysics(t, 1)
	t.Transform:SetPosition((pt1 + result_offset):Get())
end
end
end
local function SpawnBasaltC(x,z)--斗兽场3层围墙
 local pt2 = Vector3(x-11,4,z-11)--圆心
    for k = 1, 60 do
        local result_offset = FindValidPositionByFan(1 * 2 * PI, 8, 60, function(offset)--围成圆形
            local x,y,z = (pt2 + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset then
	local t = SpawnPrefab("wall_ruins")--用远古墙围
	t.AnimState:PlayAnimation("fullC")--状态为3级墙
           MakeObstaclePhysics(t, 1)
	t.Transform:SetPosition((pt2 + result_offset):Get())
end
end
end
local function SpawnNPCA(x,z)--远古科技
	local t = SpawnPrefab("ancient_altar")
	t.Transform:SetPosition(x,0,z)
end
local function SpawnNPCy(x,z)--斗兽场
    local gamehost = SpawnPrefab("thulecite")--游戏主持人
    gamehost.Transform:SetPosition(x, 0, z)
    gamehost.AnimState:SetBank("wilson")
    gamehost.AnimState:SetBuild("wolfgang")
    gamehost.AnimState:OverrideSymbol("swap_hat", "hat_top", "swap_hat")
    gamehost.AnimState:Show("HAT")
    gamehost.AnimState:Show("HAT_HAIR")
    gamehost.AnimState:Hide("HAIR_NOHAT")
    gamehost.AnimState:Hide("HAIR")
    gamehost.AnimState:Hide("ARM_carry")
    gamehost.AnimState:Show("ARM_normal")
    gamehost.Transform:SetFourFaced()
    gamehost.AnimState:PlayAnimation("idle")
    gamehost:RemoveComponent("repairer")
    gamehost:RemoveComponent("edible")
    gamehost:RemoveComponent("tradable")
    gamehost:RemoveComponent("inventoryitem")
    gamehost:RemoveComponent("stackable")
    gamehost:RemoveComponent("deployable")
    gamehost:RemoveComponent("bait")
    gamehost:RemoveTag("molebait")
    gamehost:AddTag("gamehost")
    gamehost:AddComponent("workable")
    gamehost.components.workable:SetWorkAction(ACTIONS.HAMMER)
    gamehost.components.workable:SetWorkLeft(3)
    gamehost.components.workable:SetOnFinishCallback(function(gamehost)
        local pos = Vector3(gamehost.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 50)
        for k,v in pairs(ents) do
            if v:HasTag("candel") then
               SpawnPrefab("collapse_big").Transform:SetPosition(v.Transform:GetWorldPosition())
               --GetPlayer().SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
               v:Remove()
            end
        end
        gamehost:Remove()
    end )
	local fountain = SpawnPrefab("thulecite")--角斗场火炬
    fountain.Transform:SetPosition(x-11, 0,z-11)
    fountain.AnimState:SetBank("staff_purple_base")
    fountain.AnimState:SetBuild("staff_purple_base")
    fountain.AnimState:PlayAnimation("idle_full_loop")
    fountain.Transform:SetScale(1.5, 1.5, 1.5)
    fountain.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    fountain.AnimState:SetLayer( LAYER_BACKGROUND )
    fountain.AnimState:SetSortOrder( 1 )
    fountain.Transform:SetRotation( 45 )
    fountain:AddTag("NOCLICK")
    fountain:RemoveComponent("repairer")
    fountain:RemoveComponent("edible")
    fountain:RemoveComponent("tradable")
    fountain:RemoveComponent("inventoryitem")
    fountain:RemoveComponent("stackable")
    fountain:RemoveComponent("deployable")
    fountain:RemoveComponent("bait")
    fountain:RemoveTag("molebait")
    local light = fountain.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(18)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
    fountain:AddTag("candel")
    local pt0 = Vector3(fountain.Transform:GetWorldPosition())
    for k = 1, 60 do
        local result_offset = FindValidPositionByFan(1 * 2 * PI, 12, 60, function(offset)--围成圆形
            local x,y,z = (pt0 + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset then
           local fence = SpawnPrefab("wall_ruins")--用远古墙围
		   --[[fence.AnimState:SetBank("wall")
		   fence.AnimState:SetBuild("wall_ruins")--]]
           fence.AnimState:PlayAnimation("fullC")
           MakeObstaclePhysics(fence, 1)
           fence:RemoveComponent("repairer")
           fence:RemoveComponent("edible")
           fence:RemoveComponent("tradable")
           fence:RemoveComponent("inventoryitem")
           fence:RemoveComponent("stackable")
           fence:RemoveComponent("deployable")
           fence:RemoveComponent("bait")
           fence:RemoveTag("molebait")
           fence:AddTag("candel")
           fence.Transform:SetPosition((pt0 + result_offset):Get())
        end
    end
	gamehost:AddComponent("trader")
    gamehost.components.trader:SetAcceptTest(function(gamehost, item) 
      if not gamehost:HasTag("startgame") then
	  if item.prefab == "goldnugget" then
              return true
           end
		   end
      return false
    end )
	local function OnGetItemFromPlayer(gamehost, giver, item)
    	if item.prefab == "goldnugget" then--门票一个金子
		giver.components.locomotor:Stop()
        giver.Transform:SetPosition(x-11+5, 0, z-11-5)
	    gamehost:AddTag("startgame")
		giver.components.talker:Say("欢迎参赛")
		local warrior0 = SpawnPrefab("thulecite")
        warrior0.Transform:SetPosition(x-11-5, 0,z-11+5)
        warrior0.AnimState:SetBank("wilson")
        local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
        local buildname = names[math.random(#names)]
        warrior0.AnimState:SetBuild(buildname)
        local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
        local hat = hats[math.random(#hats)]
        warrior0.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
        local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
        local armor = armors[math.random(#armors)]
        warrior0.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
		local names = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}--npc武器随机
        local weapon = names[math.random(#names)]
		warrior0.AnimState:OverrideSymbol("swap_object", weapon, weapon)
        warrior0.AnimState:Show("HAT")
        warrior0.AnimState:Show("HAT_HAIR")
        warrior0.AnimState:Hide("HAIR_NOHAT")
        warrior0.AnimState:Hide("HAIR")
        warrior0.AnimState:Show("ARM_carry")
        warrior0.AnimState:Show("ARM_normal")
        warrior0.AnimState:PlayAnimation("idle")
        warrior0.Transform:SetFourFaced()
        local sound = warrior0.entity:AddSoundEmitter()
        local shadow = warrior0.entity:AddDynamicShadow()
        shadow:SetSize( 1.3, .6 )
        local brain = require "brains/frogbrain"
        warrior0:SetBrain(brain)
        warrior0:AddComponent("locomotor")
        warrior0.components.locomotor.walkspeed = 5
        warrior0.components.locomotor.runspeed = 10
        warrior0:SetStateGraph("SGshadowwaxwell")
        MakeCharacterPhysics(warrior0, 75, .5)
        warrior0:RemoveComponent("repairer")
        warrior0:RemoveComponent("edible")
        warrior0:RemoveComponent("tradable")
        warrior0:RemoveComponent("inventoryitem")
        warrior0:RemoveComponent("stackable")
        warrior0:RemoveComponent("deployable")
        warrior0:RemoveComponent("bait")
        warrior0:RemoveTag("molebait")
        warrior0:AddComponent("inventory")
        warrior0:AddComponent("knownlocations")
        warrior0:AddComponent("health")
        warrior0.components.health:SetMaxHealth(math.random(2500,5000))
        warrior0:AddComponent("combat")
        warrior0.components.combat:SetDefaultDamage(math.random(25,50))
        warrior0.components.combat:SetAttackPeriod(2)
        warrior0.components.combat:SetRetargetFunction(1, function(warrior0)
            if not warrior0.components.health:IsDead() then
                return FindEntity(warrior0, 30, function(guy)
                    return guy:HasTag("player")
                end )
            end
        end )
        warrior0:DoPeriodicTask(1, function(warrior0)
            if not warrior0:HasTag("noplay") then
               if warrior0.components.health.currenthealth <= 100 then
                  warrior0:AddTag("noplay")
                  warrior0.components.combat:SetTarget(nil)
                  warrior0.components.combat:SetRetargetFunction(100, nil )
               end
               if giver.components.health.currenthealth <= 51 then
                  warrior0.components.locomotor:Stop()
                  warrior0:SetBrain(nil)
                  warrior0:AddTag("noplay")
                  warrior0.components.combat:SetTarget(nil)
                  warrior0.components.combat:SetRetargetFunction(100, nil )
                  warrior0.components.health:SetInvincible(true)
                  warrior0.AnimState:PlayAnimation("idle_onemanband1_loop",true)
                  gamehost:DoTaskInTime(3, function()
                      warrior0:Remove()
                      giver.components.locomotor:Stop()
                      giver.Transform:SetPosition(x-1, 0,z+1)
                      if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
                      gamehost:RemoveTag("startgame")--结束游戏
                  end )
               end
            end
        end )
		warrior0:ListenForEvent("death", function()
           
            gamehost:DoTaskInTime(3, function()
                giver.components.locomotor:Stop()
                giver.Transform:SetPosition(x-1, 0, z+1)
                for k = 1, 10 do--奖品数量，下面随机奖品，每种奖品概率1/11
				local gems = {"purplegem","bluegem","redgem","orangegem","yellowgem","greengem","thulecite","goldnugget"}
                local gem = gems[math.random(#gems)]
                    giver.components.inventory:GiveItem(SpawnPrefab(gem))
                end
			
                if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
                gamehost:RemoveTag("startgame")
            end )
        end )
        warrior0:AddTag("candel")
        gamehost.task = gamehost:DoPeriodicTask(1, function(gamehost)
            local target = FindEntity(fountain, 13, function(guy) 
                return guy:HasTag("player")
            end )
            if not target then
               warrior0:Remove()
               if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
               gamehost:RemoveTag("startgame")
            end
        end )
    
	gamehost.components.inspectable.getstatus = function(gamehost)
        if not gamehost:HasTag("startgame") then
           if giver.components.inventory:Has("goldnugget", 1) then
             giver.components.inventory:ConsumeByName("goldnugget", 1)
              gamehost:AddTag("startgame")
              local warrior1 = SpawnPrefab("thulecite")
              warrior1.Transform:SetPosition(x-11+5, 0,z-11-5)
              warrior1.AnimState:SetBank("wilson")
              local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
              local buildname = names[math.random(#names)]
              warrior1.AnimState:SetBuild(buildname)
              local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
              local hat = hats[math.random(#hats)]
              warrior1.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
              local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
              local armor = armors[math.random(#armors)]
              warrior1.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
			  local names = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
              local weapon = names[math.random(#names)]
              warrior1.AnimState:OverrideSymbol("swap_object", weapon, weapon)
              warrior1.AnimState:Show("HAT")
              warrior1.AnimState:Show("HAT_HAIR")
              warrior1.AnimState:Hide("HAIR_NOHAT")
              warrior1.AnimState:Hide("HAIR")
              warrior1.AnimState:Hide("ARM_carry")
              warrior1.AnimState:Show("ARM_normal")
              warrior1.AnimState:PlayAnimation("idle")
              warrior1.Transform:SetFourFaced()
              local sound = warrior1.entity:AddSoundEmitter()
              local shadow = warrior1.entity:AddDynamicShadow()
              shadow:SetSize( 1.3, .6 )
              local brain = require "brains/frogbrain"
              warrior1:SetBrain(brain)
              warrior1:AddComponent("locomotor")
              warrior1.components.locomotor.walkspeed = 5
              warrior1.components.locomotor.runspeed = 10
              warrior1:SetStateGraph("SGshadowwaxwell")
              MakeCharacterPhysics(warrior1, 75, .5)
              warrior1:RemoveComponent("repairer")
              warrior1:RemoveComponent("edible")
              warrior1:RemoveComponent("tradable")
              warrior1:RemoveComponent("inventoryitem")
              warrior1:RemoveComponent("stackable")
              warrior1:RemoveComponent("deployable")
              warrior1:RemoveComponent("bait")
              warrior1:RemoveTag("molebait")
              warrior1:AddComponent("inventory")
              warrior1:AddComponent("knownlocations")
              warrior1:AddComponent("health")
              warrior1.components.health:SetMaxHealth(math.random(200,500))
              warrior1:AddComponent("combat")
              warrior1.components.combat:SetDefaultDamage(math.random(25,100))
              warrior1.components.combat:SetAttackPeriod(3)
              warrior1.components.combat:SetRetargetFunction(1, function(warrior1)
                  if not warrior1.components.health:IsDead() then
                      return FindEntity(warrior1, 30, function(guy)
                          return guy:HasTag("warrior2")
                      end )
                  end
              end )
			  warrior1:AddTag("warrior1")
              warrior1:AddTag("candel")
              local warrior2 = SpawnPrefab("thulecite")
              warrior2.Transform:SetPosition(x-11-5, 0,z-11+5)
              warrior2.AnimState:SetBank("wilson")
              local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
              local buildname = names[math.random(#names)]
              warrior2.AnimState:SetBuild(buildname)
              local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
              local hat = hats[math.random(#hats)]
              warrior2.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
              local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
              local armor = armors[math.random(#armors)]
              warrior2.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
              warrior2.AnimState:Show("HAT")
              warrior2.AnimState:Show("HAT_HAIR")
              warrior2.AnimState:Hide("HAIR_NOHAT")
              warrior2.AnimState:Hide("HAIR")
              warrior2.AnimState:Hide("ARM_carry")
              warrior2.AnimState:Show("ARM_normal")
              warrior2.AnimState:PlayAnimation("idle")
              warrior2.Transform:SetFourFaced()
              local sound = warrior2.entity:AddSoundEmitter()
              local shadow = warrior2.entity:AddDynamicShadow()
              shadow:SetSize( 1.3, .6 )
              local brain = require "brains/frogbrain"
              warrior2:SetBrain(brain)
              warrior2:AddComponent("locomotor")
              warrior2.components.locomotor.walkspeed = 5
              warrior2.components.locomotor.runspeed = 10
              warrior2:SetStateGraph("SGshadowwaxwell")
              MakeCharacterPhysics(warrior2, 75, .5)
              warrior2:RemoveComponent("repairer")
              warrior2:RemoveComponent("edible")
              warrior2:RemoveComponent("tradable")
              warrior2:RemoveComponent("inventoryitem")
              warrior2:RemoveComponent("stackable")
              warrior2:RemoveComponent("deployable")
              warrior2:RemoveComponent("bait")
              warrior2:RemoveTag("molebait")
              warrior2:AddComponent("inventory")
              warrior2:AddComponent("knownlocations")
              warrior2:AddComponent("health")
              warrior2.components.health:SetMaxHealth(math.random(200,500))
              warrior2:AddComponent("combat")
              warrior2.components.combat:SetDefaultDamage(math.random(25,100))
              warrior2.components.combat:SetAttackPeriod(3)
              warrior2.components.combat:SetRetargetFunction(1, function(warrior2)
                  if not warrior2.components.health:IsDead() then
                      return FindEntity(warrior2, 30, function(guy)
                          return guy:HasTag("warrior1")
                      end )
                  end
              end )
              warrior2:AddTag("warrior2")
              warrior2:AddTag("candel")
              warrior1:DoPeriodicTask(1, function(warrior1)
                  if not warrior1:HasTag("noplay") and not warrior2:HasTag("noplay") then
                     if warrior1.components.health.currenthealth <= 100 then
                        warrior1:AddTag("noplay")
                        warrior1.components.combat:SetTarget(nil)
                        warrior1.components.combat:SetRetargetFunction(100, nil )
                     end
                  end
              end )
			   warrior2:DoPeriodicTask(1, function(warrior2)
                  if not warrior2:HasTag("noplay") and not warrior1:HasTag("noplay") then
                     if warrior2.components.health.currenthealth <= 100 then
                        warrior2:AddTag("noplay")
                        warrior2.components.combat:SetTarget(nil)
                        warrior2.components.combat:SetRetargetFunction(100, nil )
                     end
                  end
              end )
              warrior1:ListenForEvent("death", function()
                  warrior2.components.locomotor:Stop()
                  warrior2:SetBrain(nil)
                  warrior2.AnimState:PlayAnimation("idle_onemanband1_loop",true)
                  gamehost:DoTaskInTime(3, function() warrior2:Remove() gamehost:RemoveTag("startgame") end )
              end )
              warrior2:ListenForEvent("death", function()
                  warrior1.components.locomotor:Stop()
                  warrior1:SetBrain(nil)
                  warrior1.AnimState:PlayAnimation("idle_onemanband1_loop",true)
                  gamehost:DoTaskInTime(3, function() warrior1:Remove() gamehost:RemoveTag("startgame") end )
              end )
		end
		end
		end
		end
		end
	local function OnRefuseItem(gamehost, giver, item)
	giver.components.talker:Say("参赛需要缴费一个金子，身上至少要带100个金子")
	end
	gamehost.components.trader.onaccept = OnGetItemFromPlayer
	gamehost.components.trader.onrefuse = OnRefuseItem
	
	
           end
		   
	local function SpawnNPCy(x,z)--斗兽场1（普通难度）
    local gamehost = SpawnPrefab("thulecite")--游戏主持人
    gamehost.Transform:SetPosition(x, 0, z)
    gamehost.AnimState:SetBank("wilson")
    gamehost.AnimState:SetBuild("wolfgang")
    gamehost.AnimState:OverrideSymbol("swap_hat", "hat_top", "swap_hat")
    gamehost.AnimState:Show("HAT")
    gamehost.AnimState:Show("HAT_HAIR")
    gamehost.AnimState:Hide("HAIR_NOHAT")
    gamehost.AnimState:Hide("HAIR")
    gamehost.AnimState:Hide("ARM_carry")
    gamehost.AnimState:Show("ARM_normal")
    gamehost.Transform:SetFourFaced()
    gamehost.AnimState:PlayAnimation("idle")
    gamehost:RemoveComponent("repairer")
    gamehost:RemoveComponent("edible")
    gamehost:RemoveComponent("tradable")
    gamehost:RemoveComponent("inventoryitem")
    gamehost:RemoveComponent("stackable")
    gamehost:RemoveComponent("deployable")
    gamehost:RemoveComponent("bait")
    gamehost:RemoveTag("molebait")
    gamehost:AddTag("gamehost")
    gamehost:AddComponent("workable")
    gamehost.components.workable:SetWorkAction(ACTIONS.HAMMER)
    gamehost.components.workable:SetWorkLeft(3)
    gamehost.components.workable:SetOnFinishCallback(function(gamehost)
        local pos = Vector3(gamehost.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 50)
        for k,v in pairs(ents) do
            if v:HasTag("candel") then
               SpawnPrefab("collapse_big").Transform:SetPosition(v.Transform:GetWorldPosition())
               --GetPlayer().SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
               v:Remove()
            end
        end
        gamehost:Remove()
    end )
	local fountain = SpawnPrefab("thulecite")--角斗场火炬
    fountain.Transform:SetPosition(x-11, 0,z-11)
    fountain.AnimState:SetBank("staff_purple_base")
    fountain.AnimState:SetBuild("staff_purple_base")
    fountain.AnimState:PlayAnimation("idle_full_loop")
    fountain.Transform:SetScale(1.5, 1.5, 1.5)
    fountain.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    fountain.AnimState:SetLayer( LAYER_BACKGROUND )
    fountain.AnimState:SetSortOrder( 1 )
    fountain.Transform:SetRotation( 45 )
    fountain:AddTag("NOCLICK")
    fountain:RemoveComponent("repairer")
    fountain:RemoveComponent("edible")
    fountain:RemoveComponent("tradable")
    fountain:RemoveComponent("inventoryitem")
    fountain:RemoveComponent("stackable")
    fountain:RemoveComponent("deployable")
    fountain:RemoveComponent("bait")
    fountain:RemoveTag("molebait")
    local light = fountain.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(18)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
    fountain:AddTag("candel")
    local pt0 = Vector3(fountain.Transform:GetWorldPosition())
    for k = 1, 60 do
        local result_offset = FindValidPositionByFan(1 * 2 * PI, 12, 60, function(offset)--围成圆形
            local x,y,z = (pt0 + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset then
           local fence = SpawnPrefab("wall_ruins")--用远古墙围
		   --[[fence.AnimState:SetBank("wall")
		   fence.AnimState:SetBuild("wall_ruins")--]]
           fence.AnimState:PlayAnimation("fullC")
           MakeObstaclePhysics(fence, 1)
           fence:RemoveComponent("repairer")
           fence:RemoveComponent("edible")
           fence:RemoveComponent("tradable")
           fence:RemoveComponent("inventoryitem")
           fence:RemoveComponent("stackable")
           fence:RemoveComponent("deployable")
           fence:RemoveComponent("bait")
           fence:RemoveTag("molebait")
           fence:AddTag("candel")
           fence.Transform:SetPosition((pt0 + result_offset):Get())
        end
    end
	gamehost:AddComponent("trader")
    gamehost.components.trader:SetAcceptTest(function(gamehost, item) 
      if not gamehost:HasTag("startgame") then
	  if item.prefab == "goldnugget" then
              return true
           end
		   end
      return false
    end )
	local function OnGetItemFromPlayer(gamehost, giver, item)
    	if item.prefab == "goldnugget" then--门票一个金子
		giver.components.locomotor:Stop()
        giver.Transform:SetPosition(x-11+5, 0, z-11-5)
	    gamehost:AddTag("startgame")
		giver.components.talker:Say("欢迎参赛")
		local warrior0 = SpawnPrefab("thulecite")
        warrior0.Transform:SetPosition(x-11-5, 0,z-11+5)
        warrior0.AnimState:SetBank("wilson")
        local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
        local buildname = names[math.random(#names)]
        warrior0.AnimState:SetBuild(buildname)
        local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
        local hat = hats[math.random(#hats)]
        warrior0.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
        local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
        local armor = armors[math.random(#armors)]
        warrior0.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
		local names = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}--npc武器随机
        local weapon = names[math.random(#names)]
		warrior0.AnimState:OverrideSymbol("swap_object", weapon, weapon)
        warrior0.AnimState:Show("HAT")
        warrior0.AnimState:Show("HAT_HAIR")
        warrior0.AnimState:Hide("HAIR_NOHAT")
        warrior0.AnimState:Hide("HAIR")
        warrior0.AnimState:Show("ARM_carry")
        warrior0.AnimState:Show("ARM_normal")
        warrior0.AnimState:PlayAnimation("idle")
        warrior0.Transform:SetFourFaced()
        local sound = warrior0.entity:AddSoundEmitter()
        local shadow = warrior0.entity:AddDynamicShadow()
        shadow:SetSize( 1.3, .6 )
        local brain = require "brains/frogbrain"
        warrior0:SetBrain(brain)
        warrior0:AddComponent("locomotor")
        warrior0.components.locomotor.walkspeed = 5
        warrior0.components.locomotor.runspeed = 10
        warrior0:SetStateGraph("SGshadowwaxwell")
        MakeCharacterPhysics(warrior0, 75, .5)
        warrior0:RemoveComponent("repairer")
        warrior0:RemoveComponent("edible")
        warrior0:RemoveComponent("tradable")
        warrior0:RemoveComponent("inventoryitem")
        warrior0:RemoveComponent("stackable")
        warrior0:RemoveComponent("deployable")
        warrior0:RemoveComponent("bait")
        warrior0:RemoveTag("molebait")
        warrior0:AddComponent("inventory")
        warrior0:AddComponent("knownlocations")
        warrior0:AddComponent("health")
        warrior0.components.health:SetMaxHealth(math.random(2500,5000))
        warrior0:AddComponent("combat")
        warrior0.components.combat:SetDefaultDamage(math.random(25,100))--伤害25到100
        warrior0.components.combat:SetAttackPeriod(6)--攻速6
        warrior0.components.combat:SetRetargetFunction(1, function(warrior0)
            if not warrior0.components.health:IsDead() then
                return FindEntity(warrior0, 30, function(guy)
                    return guy:HasTag("player")
                end )
            end
        end )
        warrior0:DoPeriodicTask(1, function(warrior0)
            if not warrior0:HasTag("noplay") then
               if warrior0.components.health.currenthealth <= 100 then
                  warrior0:AddTag("noplay")
                  warrior0.components.combat:SetTarget(nil)
                  warrior0.components.combat:SetRetargetFunction(100, nil )
               end
               if giver.components.health.currenthealth <= 51 then
                  warrior0.components.locomotor:Stop()
                  warrior0:SetBrain(nil)
                  warrior0:AddTag("noplay")
                  warrior0.components.combat:SetTarget(nil)
                  warrior0.components.combat:SetRetargetFunction(100, nil )
                  warrior0.components.health:SetInvincible(true)
                  warrior0.AnimState:PlayAnimation("idle_onemanband1_loop",true)
                  gamehost:DoTaskInTime(3, function()
                      warrior0:Remove()
                      giver.components.locomotor:Stop()
                      giver.Transform:SetPosition(x-1, 0,z+1)
                      if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
                      gamehost:RemoveTag("startgame")--结束游戏
                  end )
               end
            end
        end )
		warrior0:ListenForEvent("death", function()
           
            gamehost:DoTaskInTime(3, function()
                giver.components.locomotor:Stop()
                giver.Transform:SetPosition(x-1, 0, z+1)
                for k = 1, 10 do--奖品数量，下面随机奖品，每种奖品概率1/11
				local gems = {"purplegem","bluegem","redgem","orangegem","yellowgem","greengem","thulecite","goldnugget"}
                local gem = gems[math.random(#gems)]
                    giver.components.inventory:GiveItem(SpawnPrefab(gem))
                end
			
                if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
                gamehost:RemoveTag("startgame")
            end )
        end )
        warrior0:AddTag("candel")
        gamehost.task = gamehost:DoPeriodicTask(1, function(gamehost)
            local target = FindEntity(fountain, 13, function(guy) 
                return guy:HasTag("player")
            end )
            if not target then
               warrior0:Remove()
               if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
               gamehost:RemoveTag("startgame")
            end
        end )
    
	gamehost.components.inspectable.getstatus = function(gamehost)
        if not gamehost:HasTag("startgame") then
           if giver.components.inventory:Has("goldnugget", 1) then
             giver.components.inventory:ConsumeByName("goldnugget", 1)
              gamehost:AddTag("startgame")
              local warrior1 = SpawnPrefab("thulecite")
              warrior1.Transform:SetPosition(x-11+5, 0,z-11-5)
              warrior1.AnimState:SetBank("wilson")
              local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
              local buildname = names[math.random(#names)]
              warrior1.AnimState:SetBuild(buildname)
              local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
              local hat = hats[math.random(#hats)]
              warrior1.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
              local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
              local armor = armors[math.random(#armors)]
              warrior1.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
			  local names = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
              local weapon = names[math.random(#names)]
              warrior1.AnimState:OverrideSymbol("swap_object", weapon, weapon)
              warrior1.AnimState:Show("HAT")
              warrior1.AnimState:Show("HAT_HAIR")
              warrior1.AnimState:Hide("HAIR_NOHAT")
              warrior1.AnimState:Hide("HAIR")
              warrior1.AnimState:Hide("ARM_carry")
              warrior1.AnimState:Show("ARM_normal")
              warrior1.AnimState:PlayAnimation("idle")
              warrior1.Transform:SetFourFaced()
              local sound = warrior1.entity:AddSoundEmitter()
              local shadow = warrior1.entity:AddDynamicShadow()
              shadow:SetSize( 1.3, .6 )
              local brain = require "brains/frogbrain"
              warrior1:SetBrain(brain)
              warrior1:AddComponent("locomotor")
              warrior1.components.locomotor.walkspeed = 5
              warrior1.components.locomotor.runspeed = 10
              warrior1:SetStateGraph("SGshadowwaxwell")
              MakeCharacterPhysics(warrior1, 75, .5)
              warrior1:RemoveComponent("repairer")
              warrior1:RemoveComponent("edible")
              warrior1:RemoveComponent("tradable")
              warrior1:RemoveComponent("inventoryitem")
              warrior1:RemoveComponent("stackable")
              warrior1:RemoveComponent("deployable")
              warrior1:RemoveComponent("bait")
              warrior1:RemoveTag("molebait")
              warrior1:AddComponent("inventory")
              warrior1:AddComponent("knownlocations")
              warrior1:AddComponent("health")
              warrior1.components.health:SetMaxHealth(math.random(200,500))
              warrior1:AddComponent("combat")
              warrior1.components.combat:SetDefaultDamage(math.random(25,100))
              warrior1.components.combat:SetAttackPeriod(3)
              warrior1.components.combat:SetRetargetFunction(1, function(warrior1)
                  if not warrior1.components.health:IsDead() then
                      return FindEntity(warrior1, 30, function(guy)
                          return guy:HasTag("warrior2")
                      end )
                  end
              end )
			  warrior1:AddTag("warrior1")
              warrior1:AddTag("candel")
              local warrior2 = SpawnPrefab("thulecite")
              warrior2.Transform:SetPosition(x-11-5, 0,z-11+5)
              warrior2.AnimState:SetBank("wilson")
              local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
              local buildname = names[math.random(#names)]
              warrior2.AnimState:SetBuild(buildname)
              local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
              local hat = hats[math.random(#hats)]
              warrior2.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
              local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
              local armor = armors[math.random(#armors)]
              warrior2.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
              warrior2.AnimState:Show("HAT")
              warrior2.AnimState:Show("HAT_HAIR")
              warrior2.AnimState:Hide("HAIR_NOHAT")
              warrior2.AnimState:Hide("HAIR")
              warrior2.AnimState:Hide("ARM_carry")
              warrior2.AnimState:Show("ARM_normal")
              warrior2.AnimState:PlayAnimation("idle")
              warrior2.Transform:SetFourFaced()
              local sound = warrior2.entity:AddSoundEmitter()
              local shadow = warrior2.entity:AddDynamicShadow()
              shadow:SetSize( 1.3, .6 )
              local brain = require "brains/frogbrain"
              warrior2:SetBrain(brain)
              warrior2:AddComponent("locomotor")
              warrior2.components.locomotor.walkspeed = 5
              warrior2.components.locomotor.runspeed = 10
              warrior2:SetStateGraph("SGshadowwaxwell")
              MakeCharacterPhysics(warrior2, 75, .5)
              warrior2:RemoveComponent("repairer")
              warrior2:RemoveComponent("edible")
              warrior2:RemoveComponent("tradable")
              warrior2:RemoveComponent("inventoryitem")
              warrior2:RemoveComponent("stackable")
              warrior2:RemoveComponent("deployable")
              warrior2:RemoveComponent("bait")
              warrior2:RemoveTag("molebait")
              warrior2:AddComponent("inventory")
              warrior2:AddComponent("knownlocations")
              warrior2:AddComponent("health")
              warrior2.components.health:SetMaxHealth(math.random(200,500))--血量200到500
              warrior2:AddComponent("combat")
              warrior2.components.combat:SetDefaultDamage(math.random(25,100))--伤害范围25到100
              warrior2.components.combat:SetAttackPeriod(8)--攻速
              warrior2.components.combat:SetRetargetFunction(1, function(warrior2)
                  if not warrior2.components.health:IsDead() then
                      return FindEntity(warrior2, 30, function(guy)
                          return guy:HasTag("warrior1")
                      end )
                  end
              end )
              warrior2:AddTag("warrior2")
              warrior2:AddTag("candel")
              warrior1:DoPeriodicTask(1, function(warrior1)
                  if not warrior1:HasTag("noplay") and not warrior2:HasTag("noplay") then
                     if warrior1.components.health.currenthealth <= 100 then
                        warrior1:AddTag("noplay")
                        warrior1.components.combat:SetTarget(nil)
                        warrior1.components.combat:SetRetargetFunction(100, nil )
                     end
                  end
              end )
			   warrior2:DoPeriodicTask(1, function(warrior2)
                  if not warrior2:HasTag("noplay") and not warrior1:HasTag("noplay") then
                     if warrior2.components.health.currenthealth <= 100 then
                        warrior2:AddTag("noplay")
                        warrior2.components.combat:SetTarget(nil)
                        warrior2.components.combat:SetRetargetFunction(100, nil )
                     end
                  end
              end )
              warrior1:ListenForEvent("death", function()
                  warrior2.components.locomotor:Stop()
                  warrior2:SetBrain(nil)
                  warrior2.AnimState:PlayAnimation("idle_onemanband1_loop",true)
                  gamehost:DoTaskInTime(3, function() warrior2:Remove() gamehost:RemoveTag("startgame") end )
              end )
              warrior2:ListenForEvent("death", function()
                  warrior1.components.locomotor:Stop()
                  warrior1:SetBrain(nil)
                  warrior1.AnimState:PlayAnimation("idle_onemanband1_loop",true)
                  gamehost:DoTaskInTime(3, function() warrior1:Remove() gamehost:RemoveTag("startgame") end )
              end )
		end
		end
		end
		end
		end
	local function OnRefuseItem(gamehost, giver, item)
	giver.components.talker:Say("参赛需要缴费一个金子，身上至少要带1个金子")
	end
	gamehost.components.trader.onaccept = OnGetItemFromPlayer
	gamehost.components.trader.onrefuse = OnRefuseItem
	
	
           end	  
		   
	local function SpawnNPCy2(x,z)--斗兽场2
    local gamehost = SpawnPrefab("thulecite")--游戏主持人
    gamehost.Transform:SetPosition(x, 0, z)
    gamehost.AnimState:SetBank("wilson")
    gamehost.AnimState:SetBuild("wolfgang")
    gamehost.AnimState:OverrideSymbol("swap_hat", "hat_top", "swap_hat")
    gamehost.AnimState:Show("HAT")
    gamehost.AnimState:Show("HAT_HAIR")
    gamehost.AnimState:Hide("HAIR_NOHAT")
    gamehost.AnimState:Hide("HAIR")
    gamehost.AnimState:Hide("ARM_carry")
    gamehost.AnimState:Show("ARM_normal")
    gamehost.Transform:SetFourFaced()
    gamehost.AnimState:PlayAnimation("idle")
    gamehost:RemoveComponent("repairer")
    gamehost:RemoveComponent("edible")
    gamehost:RemoveComponent("tradable")
    gamehost:RemoveComponent("inventoryitem")
    gamehost:RemoveComponent("stackable")
    gamehost:RemoveComponent("deployable")
    gamehost:RemoveComponent("bait")
    gamehost:RemoveTag("molebait")
    gamehost:AddTag("gamehost")
    gamehost:AddComponent("workable")
    gamehost.components.workable:SetWorkAction(ACTIONS.HAMMER)
    gamehost.components.workable:SetWorkLeft(3)
    gamehost.components.workable:SetOnFinishCallback(function(gamehost)
        local pos = Vector3(gamehost.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 50)
        for k,v in pairs(ents) do
            if v:HasTag("candel") then
               SpawnPrefab("collapse_big").Transform:SetPosition(v.Transform:GetWorldPosition())
               --GetPlayer().SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
               v:Remove()
            end
        end
        gamehost:Remove()
    end )
	local fountain = SpawnPrefab("thulecite")--角斗场火炬
    fountain.Transform:SetPosition(x-11, 0,z-11)
    fountain.AnimState:SetBank("staff_purple_base")
    fountain.AnimState:SetBuild("staff_purple_base")
    fountain.AnimState:PlayAnimation("idle_full_loop")
    fountain.Transform:SetScale(1.5, 1.5, 1.5)
    fountain.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    fountain.AnimState:SetLayer( LAYER_BACKGROUND )
    fountain.AnimState:SetSortOrder( 1 )
    fountain.Transform:SetRotation( 45 )
    fountain:AddTag("NOCLICK")
    fountain:RemoveComponent("repairer")
    fountain:RemoveComponent("edible")
    fountain:RemoveComponent("tradable")
    fountain:RemoveComponent("inventoryitem")
    fountain:RemoveComponent("stackable")
    fountain:RemoveComponent("deployable")
    fountain:RemoveComponent("bait")
    fountain:RemoveTag("molebait")
    local light = fountain.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(18)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
    fountain:AddTag("candel")
    local pt0 = Vector3(fountain.Transform:GetWorldPosition())
    for k = 1, 60 do
        local result_offset = FindValidPositionByFan(1 * 2 * PI, 12, 60, function(offset)--围成圆形
            local x,y,z = (pt0 + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset then
           local fence = SpawnPrefab("wall_ruins")--用远古墙围
		   --[[fence.AnimState:SetBank("wall")
		   fence.AnimState:SetBuild("wall_ruins")--]]
           fence.AnimState:PlayAnimation("fullC")
           MakeObstaclePhysics(fence, 1)
           fence:RemoveComponent("repairer")
           fence:RemoveComponent("edible")
           fence:RemoveComponent("tradable")
           fence:RemoveComponent("inventoryitem")
           fence:RemoveComponent("stackable")
           fence:RemoveComponent("deployable")
           fence:RemoveComponent("bait")
           fence:RemoveTag("molebait")
           fence:AddTag("candel")
           fence.Transform:SetPosition((pt0 + result_offset):Get())
        end
    end
	gamehost:AddComponent("trader")
    gamehost.components.trader:SetAcceptTest(function(gamehost,giver, item) 
      if not gamehost:HasTag("startgame") then
	  for k,v in pairs(AllPlayers) do
	  if v.components.inventory:Has("goldnugget", 100) then
	  if item.prefab == "goldnugget" then
              return true
           end
		   end
		   end
		   end
      return false
    end )
	local function OnGetItemFromPlayer(gamehost, giver, item)
	    if item.prefab == "goldnugget" then
        giver.components.inventory:ConsumeByName("goldnugget", 99)--扣除99金子
		giver.components.locomotor:Stop()
        giver.Transform:SetPosition(x-11+5, 0, z-11-5)
	    gamehost:AddTag("startgame")
		giver.components.talker:Say("欢迎参赛")
		local warrior0 = SpawnPrefab("thulecite")
        warrior0.Transform:SetPosition(x-11-5, 0,z-11+5)
        warrior0.AnimState:SetBank("wilson")
        local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
        local buildname = names[math.random(#names)]
        warrior0.AnimState:SetBuild(buildname)
        local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
        local hat = hats[math.random(#hats)]
        warrior0.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
        local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
        local armor = armors[math.random(#armors)]
        warrior0.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
		local names = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}--npc武器随机
        local weapon = names[math.random(#names)]
		warrior0.AnimState:OverrideSymbol("swap_object", weapon, weapon)
        warrior0.AnimState:Show("HAT")
        warrior0.AnimState:Show("HAT_HAIR")
        warrior0.AnimState:Hide("HAIR_NOHAT")
        warrior0.AnimState:Hide("HAIR")
        warrior0.AnimState:Show("ARM_carry")
        warrior0.AnimState:Show("ARM_normal")
        warrior0.AnimState:PlayAnimation("idle")
        warrior0.Transform:SetFourFaced()
        local sound = warrior0.entity:AddSoundEmitter()
        local shadow = warrior0.entity:AddDynamicShadow()
        shadow:SetSize( 1.3, .6 )
        local brain = require "brains/frogbrain"
        warrior0:SetBrain(brain)
        warrior0:AddComponent("locomotor")
        warrior0.components.locomotor.walkspeed = 10
        warrior0.components.locomotor.runspeed = 12
        warrior0:SetStateGraph("SGshadowwaxwell")
        MakeCharacterPhysics(warrior0, 75, .5)
        warrior0:RemoveComponent("repairer")
        warrior0:RemoveComponent("edible")
        warrior0:RemoveComponent("tradable")
        warrior0:RemoveComponent("inventoryitem")
        warrior0:RemoveComponent("stackable")
        warrior0:RemoveComponent("deployable")
        warrior0:RemoveComponent("bait")
        warrior0:RemoveTag("molebait")
        warrior0:AddComponent("inventory")
        warrior0:AddComponent("knownlocations")
        warrior0:AddComponent("health")
        warrior0.components.health:SetMaxHealth(math.random(8000,20000))--血量8千到2万
        warrior0:AddComponent("combat")
        warrior0.components.combat:SetDefaultDamage(math.random(50,200))--伤害
        warrior0.components.combat:SetAttackPeriod(6)--攻速
        warrior0.components.combat:SetRetargetFunction(1, function(warrior0)
            if not warrior0.components.health:IsDead() then
                return FindEntity(warrior0, 30, function(guy)
                    return guy:HasTag("player")
                end )
            end
        end )
        warrior0:DoPeriodicTask(1, function(warrior0)
            if not warrior0:HasTag("noplay") then
               if warrior0.components.health.currenthealth <= 100 then
                  warrior0:AddTag("noplay")
                  warrior0.components.combat:SetTarget(nil)
                  warrior0.components.combat:SetRetargetFunction(100, nil )
               end
               if giver.components.health.currenthealth <= 51 then
                  warrior0.components.locomotor:Stop()
                  warrior0:SetBrain(nil)
                  warrior0:AddTag("noplay")
                  warrior0.components.combat:SetTarget(nil)
                  warrior0.components.combat:SetRetargetFunction(100, nil )
                  warrior0.components.health:SetInvincible(true)
                  warrior0.AnimState:PlayAnimation("idle_onemanband1_loop",true)
                  gamehost:DoTaskInTime(3, function()
                      warrior0:Remove()
                      giver.components.locomotor:Stop()
                      giver.Transform:SetPosition(x-1, 0,z+1)
                      if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
                      gamehost:RemoveTag("startgame")--结束游戏
                  end )
               end
            end
        end )
		warrior0:ListenForEvent("death", function()
           
            gamehost:DoTaskInTime(3, function()
                giver.components.locomotor:Stop()
                giver.Transform:SetPosition(x-1, 0, z+1)
                for k = 1, 10 do--奖品数量，下面随机奖品，每种奖品概率1/11
				local gems = {"purplegem","bluegem","redgem","orangegem","yellowgem","greengem","thulecite","goldnugget"}
                local gem = gems[math.random(#gems)]
                    giver.components.inventory:GiveItem(SpawnPrefab(gem))
                end
			
                if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
                gamehost:RemoveTag("startgame")
            end )
        end )
        warrior0:AddTag("candel")
        gamehost.task = gamehost:DoPeriodicTask(1, function(gamehost)
            local target = FindEntity(fountain, 13, function(guy) 
                return guy:HasTag("player")
            end )
            if not target then
               warrior0:Remove()
               if gamehost.task then gamehost.task:Cancel() gamehost.task = nil end
               gamehost:RemoveTag("startgame")
            end
        end )
    
	gamehost.components.inspectable.getstatus = function(gamehost)
        if not gamehost:HasTag("startgame") then
           if giver.components.inventory:Has("goldnugget", 100) then
             giver.components.inventory:ConsumeByName("goldnugget", 20)--扣除20金子
              gamehost:AddTag("startgame")
              local warrior1 = SpawnPrefab("thulecite")
              warrior1.Transform:SetPosition(x-11+5, 0,z-11-5)
              warrior1.AnimState:SetBank("wilson")
              local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
              local buildname = names[math.random(#names)]
              warrior1.AnimState:SetBuild(buildname)
              local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
              local hat = hats[math.random(#hats)]
              warrior1.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
              local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
              local armor = armors[math.random(#armors)]
              warrior1.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
			  local names = {"swap_goldenaxe","swap_spear","swap_spike","swap_batbat","swap_ruins_bat"}
              local weapon = names[math.random(#names)]
              warrior1.AnimState:OverrideSymbol("swap_object", weapon, weapon)
              warrior1.AnimState:Show("HAT")
              warrior1.AnimState:Show("HAT_HAIR")
              warrior1.AnimState:Hide("HAIR_NOHAT")
              warrior1.AnimState:Hide("HAIR")
              warrior1.AnimState:Hide("ARM_carry")
              warrior1.AnimState:Show("ARM_normal")
              warrior1.AnimState:PlayAnimation("idle")
              warrior1.Transform:SetFourFaced()
              local sound = warrior1.entity:AddSoundEmitter()
              local shadow = warrior1.entity:AddDynamicShadow()
              shadow:SetSize( 1.3, .6 )
              local brain = require "brains/frogbrain"
              warrior1:SetBrain(brain)
              warrior1:AddComponent("locomotor")
              warrior1.components.locomotor.walkspeed = 5
              warrior1.components.locomotor.runspeed = 10
              warrior1:SetStateGraph("SGshadowwaxwell")
              MakeCharacterPhysics(warrior1, 75, .5)
              warrior1:RemoveComponent("repairer")
              warrior1:RemoveComponent("edible")
              warrior1:RemoveComponent("tradable")
              warrior1:RemoveComponent("inventoryitem")
              warrior1:RemoveComponent("stackable")
              warrior1:RemoveComponent("deployable")
              warrior1:RemoveComponent("bait")
              warrior1:RemoveTag("molebait")
              warrior1:AddComponent("inventory")
              warrior1:AddComponent("knownlocations")
              warrior1:AddComponent("health")
              warrior1.components.health:SetMaxHealth(math.random(200,500))
              warrior1:AddComponent("combat")
              warrior1.components.combat:SetDefaultDamage(math.random(25,100))
              warrior1.components.combat:SetAttackPeriod(3)
              warrior1.components.combat:SetRetargetFunction(1, function(warrior1)
                  if not warrior1.components.health:IsDead() then
                      return FindEntity(warrior1, 30, function(guy)
                          return guy:HasTag("warrior2")
                      end )
                  end
              end )
			  warrior1:AddTag("warrior1")
              warrior1:AddTag("candel")
              local warrior2 = SpawnPrefab("thulecite")
              warrior2.Transform:SetPosition(x-11-5, 0,z-11+5)
              warrior2.AnimState:SetBank("wilson")
              local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
              local buildname = names[math.random(#names)]
              warrior2.AnimState:SetBuild(buildname)
              local hats = {"hat_beefalo","hat_feather","hat_football","hat_ruins","hat_slurper","hat_slurtle","hat_spider"}
              local hat = hats[math.random(#hats)]
              warrior2.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
              local armors = {"armor_grass","armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
              local armor = armors[math.random(#armors)]
              warrior2.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
              warrior2.AnimState:Show("HAT")
              warrior2.AnimState:Show("HAT_HAIR")
              warrior2.AnimState:Hide("HAIR_NOHAT")
              warrior2.AnimState:Hide("HAIR")
              warrior2.AnimState:Hide("ARM_carry")
              warrior2.AnimState:Show("ARM_normal")
              warrior2.AnimState:PlayAnimation("idle")
              warrior2.Transform:SetFourFaced()
              local sound = warrior2.entity:AddSoundEmitter()
              local shadow = warrior2.entity:AddDynamicShadow()
              shadow:SetSize( 1.3, .6 )
              local brain = require "brains/frogbrain"
              warrior2:SetBrain(brain)
              warrior2:AddComponent("locomotor")
              warrior2.components.locomotor.walkspeed = 5
              warrior2.components.locomotor.runspeed = 10
              warrior2:SetStateGraph("SGshadowwaxwell")
              MakeCharacterPhysics(warrior2, 75, .5)
              warrior2:RemoveComponent("repairer")
              warrior2:RemoveComponent("edible")
              warrior2:RemoveComponent("tradable")
              warrior2:RemoveComponent("inventoryitem")
              warrior2:RemoveComponent("stackable")
              warrior2:RemoveComponent("deployable")
              warrior2:RemoveComponent("bait")
              warrior2:RemoveTag("molebait")
              warrior2:AddComponent("inventory")
              warrior2:AddComponent("knownlocations")
              warrior2:AddComponent("health")
              warrior2.components.health:SetMaxHealth(math.random(200,500))
              warrior2:AddComponent("combat")
              warrior2.components.combat:SetDefaultDamage(math.random(25,100))
              warrior2.components.combat:SetAttackPeriod(3)
              warrior2.components.combat:SetRetargetFunction(1, function(warrior2)
                  if not warrior2.components.health:IsDead() then
                      return FindEntity(warrior2, 30, function(guy)
                          return guy:HasTag("warrior1")
                      end )
                  end
              end )
              warrior2:AddTag("warrior2")
              warrior2:AddTag("candel")
              warrior1:DoPeriodicTask(1, function(warrior1)
                  if not warrior1:HasTag("noplay") and not warrior2:HasTag("noplay") then
                     if warrior1.components.health.currenthealth <= 100 then
                        warrior1:AddTag("noplay")
                        warrior1.components.combat:SetTarget(nil)
                        warrior1.components.combat:SetRetargetFunction(100, nil )
                     end
                  end
              end )
			   warrior2:DoPeriodicTask(1, function(warrior2)
                  if not warrior2:HasTag("noplay") and not warrior1:HasTag("noplay") then
                     if warrior2.components.health.currenthealth <= 100 then
                        warrior2:AddTag("noplay")
                        warrior2.components.combat:SetTarget(nil)
                        warrior2.components.combat:SetRetargetFunction(100, nil )
                     end
                  end
              end )
              warrior1:ListenForEvent("death", function()
                  warrior2.components.locomotor:Stop()
                  warrior2:SetBrain(nil)
                  warrior2.AnimState:PlayAnimation("idle_onemanband1_loop",true)--跳舞
                  gamehost:DoTaskInTime(3, function() warrior2:Remove() gamehost:RemoveTag("startgame") end )
              end )
              warrior2:ListenForEvent("death", function()
                  warrior1.components.locomotor:Stop()
                  warrior1:SetBrain(nil)
                  warrior1.AnimState:PlayAnimation("idle_onemanband1_loop",true)--跳舞
                  gamehost:DoTaskInTime(3, function() warrior1:Remove() gamehost:RemoveTag("startgame") end )
              end )
		
		end
		end
		end
		end
		end
	local function OnRefuseItem(gamehost, giver, item)
	giver.components.talker:Say("参赛需要缴费金子，身上至少要带100个金子")
	end
	gamehost.components.trader.onaccept = OnGetItemFromPlayer
	gamehost.components.trader.onrefuse = OnRefuseItem
	
	
           end	   


local function SpawnNPCB(x,z)--玫瑰花
	local t = SpawnPrefab("flower_rose")
	t.Transform:SetPosition(x,0,z)
	t.AnimState:SetMultColour(255/255,0/255,0/255,1)

	 --t.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
     --t.AnimState:SetLayer( LAYER_BACKGROUND )
     t.AnimState:SetSortOrder( 1 )
	t:RemoveComponent("pickable")
	local light = t.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           
          t:DoPeriodicTask(2, function(shopsign)
               t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               t:DoTaskInTime(1, function() t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
end
local function SpawnNPCC(x,z)--风滚草
	local t = SpawnPrefab("tumbleweed")
	t.Transform:SetPosition(x,0,z)
	local light = t.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           
          t:DoPeriodicTask(2, function(shopsign)
               t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               t:DoTaskInTime(1, function() t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
end
local function SpawnNPCD(x,z)--猪王
	local t = SpawnPrefab("pigking")
	t.Transform:SetPosition(x,0,z)
	local light = t.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           
          t:DoPeriodicTask(2, function(shopsign)
               t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               t:DoTaskInTime(1, function() t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
end
local function SpawnBasalta(x,z)    
           local border = SpawnPrefab("ash")
		   border.Transform:SetPosition(x,0,z)
           border.AnimState:SetBank("bulb")
           border.AnimState:SetBuild("bulb")
           border.AnimState:PlayAnimation("idle")
           border.Transform:SetScale(1.2, 1.2, 1.2)
           border.AnimState:SetMultColour(255/255,0/255,0/255,1)
           border.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
           border.AnimState:SetLayer( LAYER_BACKGROUND )
           border.AnimState:SetSortOrder( 1 )
           border:RemoveComponent("inventoryitem")
           border:RemoveComponent("stackable")
           border:RemoveComponent("deployable")
		   border:RemoveComponent("disappears")
		   local light = border.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           border:RemoveTag("cattoy")
           border:DoPeriodicTask(2, function(shopsign)
               border.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               border:DoTaskInTime(1, function() border.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
           border:AddTag("NOCLICK")
           border:AddTag("border")
		
end

local function SpawnBasaltb(x,z)    
           local border = SpawnPrefab("ash")
		   border.Transform:SetPosition(x,0,z)
           border.AnimState:SetBank("bulb")
           border.AnimState:SetBuild("bulb")
           border.AnimState:PlayAnimation("idle")
           border.Transform:SetScale(1.2, 1.2, 1.2)
           border.AnimState:SetMultColour(255/255,0/255,0/255,1)
           border.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
           border.AnimState:SetLayer( LAYER_BACKGROUND )
           border.AnimState:SetSortOrder( 1 )
           border:RemoveComponent("inventoryitem")
           border:RemoveComponent("stackable")
           border:RemoveComponent("deployable")
		   local light = border.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           border:RemoveTag("cattoy")
           border:DoPeriodicTask(2, function(shopsign)
               border.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               border:DoTaskInTime(1, function() border.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
           border:AddTag("NOCLICK")
           border:AddTag("border")
		
end

local function SpawnNPCQ(x,z)
	---local t = SpawnPrefab("ancient_altar")
	---t.Transform:SetPosition(x,0,z)
	local seller = SpawnPrefab("charcoal")
    seller.Transform:SetPosition(x, 0, z)  --------------------- NPC 坐标
    seller.AnimState:SetBank("wilson")          -------------------NPC
    ---local buildnames = {"wilson","wendy","willow","wx78"}   --------NPC样子
    ---local buildname = buildnames[math.random(#buildnames)] -----------选择NPC样子
    seller.AnimState:SetBuild("wx78")          -------------------选择
    ---local hats = {"hat_ruins","hat_rain"} ---帽子
    --local hat = hats[math.random(#hats)]   ---------随机帽子
    seller.AnimState:OverrideSymbol("swap_hat","hat_ruins", "swap_hat")    ------------帽子
    ---local armors = {"armor_grass","armor_ruins","armor_wood","torso_rain"}
    ---local armor = armors[math.random(#armors)]          ----------------护甲
    seller.AnimState:OverrideSymbol("swap_body","armor_ruins", "swap_body")
    seller.AnimState:Show("HAT")             -----------状态
    seller.AnimState:Show("HAT_HAIR")
    seller.AnimState:Hide("HAIR_NOHAT")
    seller.AnimState:Hide("HAIR")
    seller.AnimState:Hide("ARM_carry")
    seller.AnimState:Show("ARM_normal")
    seller.AnimState:PlayAnimation("idle")
    seller.Transform:SetFourFaced()
    seller:RemoveComponent("stackable")           ------------取消这些组件
    seller:RemoveComponent("fuel")
    seller:RemoveComponent("inventoryitem")
    seller:RemoveComponent("burnable")
    seller:RemoveComponent("propagator")
    seller:RemoveComponent("deployable")
    seller:RemoveComponent("bait")
    seller:RemoveTag("molebait")         ----------取消标签
    seller:AddComponent("talker")           
	seller:AddComponent("named")                       -----------名字组件
	seller.components.named:SetName("杂货商\n点击查看描述")
	seller:AddComponent("inspectable")               ---------------查看组件
	seller.components.inspectable:SetDescription("\n给予黄金购买商品,价格是125个黄金")	
    seller:AddTag("sellers")
  --[[  local flea = SpawnPrefab("charcoal")
    flea.Transform:SetPosition(x+2.8+1.2, 0, z-2.8+1.2)  ---------------地板坐标
    flea.AnimState:SetBank("winter_meter")
    flea.AnimState:SetBuild("winter_meter")
    flea.AnimState:SetPercent("meter", 0)
    flea.Transform:SetScale(1.5, 1.5, 1.5)
    flea.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    flea.AnimState:SetLayer( LAYER_BACKGROUND )
    flea.AnimState:SetSortOrder( 1 )
    flea.Transform:SetRotation( 135 )
    flea.AnimState:SetMultColour(255/255,255/255,255/255,0)
    flea:RemoveComponent("stackable")
    flea:RemoveComponent("fuel")
    flea:RemoveComponent("inventoryitem")
    flea:RemoveComponent("burnable")
    flea:RemoveComponent("propagator")
    flea:RemoveComponent("deployable")
    flea:RemoveComponent("bait")
    flea:RemoveTag("molebait")
    flea:AddTag("NOCLICK")
    flea:AddTag("fleas")--]]
    local pt0 = Vector3(seller.Transform:GetWorldPosition())
    for k = 0, 8 do
        local result_offset = FindValidPositionByFan(1 * 2 * PI, 4, 8, function(offset)--围成圆形
            local x,y,z = (pt0 + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset then
        local names = {"blueamulet","purpleamulet","orangeamulet","greenamulet","yellowamulet","armorgrass","armormarble","armorruins","armor_sanity","armorwood","axe","goldenaxe","multitool_axe_pickaxe","batbat","butter","cane","compass","deerclops_eyeball","diviningrod","eyeturret_item","fishingrod","hambat","hammer","footballhat","flowerhat","beefalohat","featherhat","beehat","walrushat","earmuffshat","spiderhat","bushhat","slurtlehat","ruinshat","healingsalve","heatrock","nightsword","pickaxe","goldenpickaxe","pitchfork","ruins_bat","shovel","goldenshovel","spear","icestaff","firestaff","telestaff","orangestaff","greenstaff","yellowstaff","sweatervest","tentaclespike","torch","trunkvest_winter","umbrella","fertilizer","spear_wathgrithr","grass_umbrella","rainhat","icehat","watermelonhat","catcoonhat","wathgrithrhat","raincoat","molehat","armordragonfly","beargervest","featherfan","staff_tornado","nightstick","eyebrellahat","reflectivevest","hawaiianshirt"}
        local name = names[math.random(#names)]
        local commodity = SpawnPrefab(name)
		commodity .AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
        commodity .AnimState:SetLayer( LAYER_BACKGROUND )
		commodity.AnimState:SetSortOrder( 1 )
        commodity.Transform:SetRotation( 0 )
        commodity.Transform:SetPosition((pt0 + result_offset):Get())    -------------售品的坐标
        commodity.components.inventoryitem.canbepickedup = false
        commodity.persists = false
        commodity:AddComponent("trader")
        commodity.components.trader:SetAcceptTest(function(commodity, item) 
            for k,v in pairs(AllPlayers) do
	          if v.components.inventory:Has("goldnugget", 125) then --价格125个黄金 
               if item.prefab == "goldnugget" then
                  return true
               end
			   end
            end
            return false
        end )
        commodity.components.trader.onaccept = function(commodity, giver, item)
            --GetPlayer().components.inventory:ConsumeByName("goldnugget", 1)
			giver.components.inventory:ConsumeByName("goldnugget", 125)
            commodity.components.inventoryitem.canbepickedup = true
            commodity:RemoveTag("commodity")
            --GetPlayer().components.inventory:GiveItem(commodity)
			giver.components.inventory:GiveItem(commodity)
            commodity:RemoveComponent("trader")
            commodity.persists = true
        end
        commodity:AddTag("commodity")
    end
	end
    seller:DoPeriodicTask(30, function(seller)
        seller.components.talker:Say("新店开业大酬宾~~", 5, false)
        seller.AnimState:PlayAnimation("give")
        local pos = Vector3(seller.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 6)
        for k,v in pairs(ents) do--移除上一次商品
            if v:HasTag("commodity") then
               v:Remove()
            end
        end
		 local pt1 = Vector3(x,0,z)--更新商品
        for k = 0,8 do
		local result_offset1 = FindValidPositionByFan(1 * 2 * PI, 4, 8, function(offset)--围成圆形
            local x,y,z = (pt1 + offset):Get()
            local ents = TheSim:FindEntities(x,y,z , 1)
            return not next(ents) 
        end)
        if result_offset1 then
            local names = {"amulet","blueamulet","purpleamulet","orangeamulet","greenamulet","yellowamulet","armorgrass","armormarble","armorruins","armor_sanity","armorslurper","armorwood","axe","goldenaxe","multitool_axe_pickaxe","batbat","trunkvest_summer","blowdart_sleep","blowdart_fire","blowdart_pipe","boomerang","bugnet","butter","cane","compass","deerclops_eyeball","diviningrod","eyeturret_item","fishingrod","hambat","hammer","footballhat","strawhat","tophat","flowerhat","beefalohat","featherhat","beehat","walrushat","earmuffshat","winterhat","spiderhat","bushhat","slurtlehat","ruinshat","healingsalve","heatrock","nightsword","lantern","panflute","pickaxe","goldenpickaxe","pitchfork","razor","ruins_bat","shovel","goldenshovel","spear","icestaff","firestaff","telestaff","orangestaff","greenstaff","yellowstaff","tentaclespike","torch","trunkvest_winter","umbrella","spear_wathgrithr","grass_umbrella","rainhat","icehat","watermelonhat","catcoonhat","wathgrithrhat","raincoat","molehat","armordragonfly","beargervest","featherfan","staff_tornado","nightstick","eyebrellahat","reflectivevest","hawaiianshirt"}
            local name = names[math.random(#names)]
            local commodity = SpawnPrefab(name)
            commodity.Transform:SetPosition((pt1 + result_offset1):Get())
            commodity.components.inventoryitem.canbepickedup = false
            commodity.persists = false
            commodity:AddTag("commodity")
            commodity:AddComponent("trader")
            commodity.components.trader:SetAcceptTest(function(commodity, item) 
                for k,v in pairs(AllPlayers) do
	            if v.components.inventory:Has("goldnugget", 125) then
                   if item.prefab == "goldnugget" then
                      return true
                   end
                end
				end
                return false
            end )
            commodity.components.trader.onaccept = function(commodity, giver, item)
                --GetPlayer().components.inventory:ConsumeByName("goldnugget", 1)
				giver.components.inventory:ConsumeByName("goldnugget", 125)
                commodity.components.inventoryitem.canbepickedup = true
                commodity:RemoveTag("commodity")
                --GetPlayer().components.inventory:GiveItem(commodity)
				giver.components.inventory:GiveItem(commodity)
                commodity:RemoveComponent("trader")
                commodity.persists = true
                end
            end
        end
				

end)
end
		

local function SpawnNPCR(x,z)
	local t = SpawnPrefab("statuemaxwell")
	t.Transform:SetPosition(x,5,z)
	local light = t.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           
          t:DoPeriodicTask(2, function(shopsign)
               t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               t:DoTaskInTime(1, function() t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
end
local function SpawnNPCW(x,z)
	local t = SpawnPrefab("statueglommer")
	t.Transform:SetPosition(x,0,z)
	local light = t.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           
          t:DoPeriodicTask(2, function(shopsign)
               t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               t:DoTaskInTime(1, function() t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
end
local function SpawnNPCE(x,z)
	local t = SpawnPrefab("critterlab")
	t.Transform:SetPosition(x,0,z)
	local light = t.entity:AddLight()
           light:SetFalloff(0.5)
           light:SetIntensity(.8)
           light:SetRadius(5)
           light:SetColour(180/255, 195/255, 50/255)
           light:Enable(true)
           
          t:DoPeriodicTask(2, function(shopsign)
               t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1)
               t:DoTaskInTime(1, function() t.AnimState:SetMultColour(math.random(),math.random(),math.random(),1) end )
           end )
end
----------------------BOSS 1号。-----------
local function SpawnNPC1(x,z)
	local guru = SpawnPrefab("ruins_bat")
    guru.Transform:SetPosition(x, 0, z)
    guru.AnimState:SetBank("wilson")
    guru.AnimState:SetBuild("wendy") 
    guru.AnimState:PlayAnimation("idle")
    guru.AnimState:OverrideSymbol("swap_object", "swap_cane", "swap_cane")
	local armors = {"armor_marble","armor_ruins","armor_sanity","armor_slurper","armor_wood"}
    local armor = armors[math.random(#armors)]
    guru.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
    guru.AnimState:Show("ARM_normal") 
    guru.AnimState:Show("ARM_carry")
    guru.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    guru.AnimState:Show("HAT")
    guru.AnimState:Show("HAT_HAIR")
    guru.AnimState:Hide("HAIR_NOHAT")
    guru.AnimState:Hide("HAIR")
    guru.Transform:SetFourFaced()
    guru.Transform:SetRotation( 0 )
    guru.Transform:SetScale(2.5, 2.5, 2.5)
    local shadow = guru.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
    guru:AddComponent("named")
	guru.components.named:SetName("自由女神")
	guru:AddComponent("inspectable")
	guru.components.inspectable:SetDescription("女神，我爱你！")
    guru.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    guru:AddTag("guru")
    guru:RemoveTag("sharp")
    guru:RemoveComponent("weapon")
    guru:RemoveComponent("finiteuses")
    guru:RemoveComponent("inventoryitem")
    guru:RemoveComponent("equippable")
    guru:RemoveComponent("deployable")
    local light = guru.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
end

 ---------------BOSS 2 号
local function SpawnNPC2(x,z)
	local a = SpawnPrefab("ruins_bat")
    a.Transform:SetPosition(x, 0, z)
    a.AnimState:SetBank("wilson")
    a.AnimState:SetBuild("wes") 
    a.AnimState:PlayAnimation("idle")
    a.AnimState:OverrideSymbol("swap_object", "swap_cane", "swap_cane")
    a.AnimState:Hide("ARM_normal") 
    a.AnimState:Show("ARM_carry")
    a.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    a.AnimState:Show("HAT")
    a.AnimState:Show("HAT_HAIR")
    a.AnimState:Hide("HAIR_NOHAT")
    a.AnimState:Hide("HAIR")
    a.Transform:SetFourFaced()
    a.Transform:SetRotation( 0 )
    a.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = a.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
    a:AddComponent("named")
	a.components.named:SetName("恶魔韦斯")
	a:AddComponent("inspectable")
	a.components.inspectable:SetDescription("他一直装聋作哑,隐藏着自己的实力")
    a.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    a:RemoveComponent("inventoryitem")
	a:RemoveComponent("finiteuses")
    local light = a.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	----重定位目标
    local function RetargetFn(a)
    local invader = nil
    invader = FindEntity(a, 10 + 15 * 2, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----说话语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .1 then
			a.components.talker:Say("你可有苦头吃着呢!")
		end
	end
    return invader, true
    end
	
    local function KeepTargetFn(a, target)
    return a.components.combat:CanTarget(target)     
    end
	SetSharedLootTable( 'zg_ch_wes',
{
	{'walrushat',          0.75},
	
	{'krampus_sack',      0.75},
	
	{'cane',          0.10},
	
    })
	
	----	不会中毒，共性
    a:AddComponent("eater")  
	a.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    a.components.eater.strongstomach = true
	local selfeater = a.components.eater
	local old = selfeater.Eat
	function a.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
	----	移动，共性
    a:AddComponent("locomotor")
    a.components.locomotor.walkspeed= 1.5
    a.components.locomotor.runspeed = 2
	a.components.locomotor.fasteronroad = true
	a.components.locomotor:SetTriggersCreep(false)
	----	状态图和AI
    a:SetStateGraph("SGzg_ch_wes")

    local brain = require "brains/zg_ch_wolfgangbrain"			--使用大力士的AI
    a:SetBrain(brain)
	a:AddComponent("health")
    a.components.health:SetMaxHealth(10000)
	a.components.health:StartRegen(2 , 5 )
	a.components.health.fire_damage_scale = 0
	a.components.health:SetAbsorptionAmount(.5)
	a:AddComponent("leader")
	a:AddComponent("talker")
	----	战斗
    a:AddComponent("combat")
    a.components.combat:SetDefaultDamage( 30 )						----常常不是空手, 因此无用
    a.components.combat:SetAttackPeriod( 3 )
    a.components.combat:SetRange(2)
    a.components.combat.hiteffectsymbol = "torso"
    a.components.combat:SetRetargetFunction(3, RetargetFn)
    a.components.combat:SetKeepTargetFunction(KeepTargetFn)
	a:AddComponent("lootdropper")
	a.components.lootdropper:SetChanceLootTable('zg_ch_wes')
	
		----	武器
	---GetInventory(a)
	
	a:AddComponent("timer")
	a:ListenForEvent("timerdone", function(a, data)
		if data.name == "pound" then	--催眠迷乱
			a.canpound = true
		end
	end)
		----	开头就准备技能
	if not (a.canpound or a.components.timer:TimerExists("pound")) then
		a.components.timer:StartTimer("pound", 5)
	end
	
	return a
	
end


local function SpawnNPC3(x,z)
    local b = SpawnPrefab("ruins_bat")
    b.Transform:SetPosition(x, 0, z)
    b.AnimState:SetBank("wilson")
    b.AnimState:SetBuild("willow") 
	b.AnimState:PlayAnimation("idle")
    b.AnimState:OverrideSymbol("swap_object", "swap_spear_wathgrithr", "swap_spear_wathgrithr")
    b.AnimState:Hide("ARM_normal") 
    b.AnimState:Show("ARM_carry")
    b.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    b.AnimState:Show("HAT")
    b.AnimState:Show("HAT_HAIR")
    b.AnimState:Hide("HAIR_NOHAT")
    b.AnimState:Hide("HAIR")
    b.Transform:SetFourFaced()
    b.Transform:SetRotation( 0 )
    b.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = b.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	b:AddComponent("timer")
    b:AddComponent("named")
	b.components.named:SetName("恶魔不知火舞")
	b:AddComponent("inspectable")
	b.components.inspectable:SetDescription("她的气息都可以用来烧玻璃了")
    b.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    b:RemoveComponent("inventoryitem")
	b:RemoveComponent("finiteuses")
    local light = b.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
			
	local function RetargetFn(b)
    local invader = nil
    invader = FindEntity(b, 10 + 15 * 2, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	if invader then
		local sayrandom = math.random()
		if sayrandom < .2 then
			
			b.components.talker:Say("奉老陈之命, 让我烧熟你!")
		elseif sayrandom < .2 then
			
			b.components.talker:Say("你真该死！")
		end
	end
	
    return invader, true
    end
    local function KeepTargetFn(b, target)
    return b.components.combat:CanTarget(target)     
    end
    SetSharedLootTable( 'zg_ch_willow',
    {
	{'armordragonfly',          1.00},
	
    })
	  
	 	----	不会中毒，共性
    b:AddComponent("eater")  
	b.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    b.components.eater.strongstomach = true
	local selfeater = b.components.eater
	local old = selfeater.Eat
	function b.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
	b:AddComponent("locomotor")
    b.components.locomotor.walkspeed= 1.5
    b.components.locomotor.runspeed = 2.5
	b.components.locomotor.fasteronroad = true
	b.components.locomotor:SetTriggersCreep(false)
	
	b:SetStateGraph("SGzg_ch_willow")
    local brain = require "brains/zg_ch_wilsonbrain"	    ------------zg_ch_wolfgangbrain   zg_ch_wilsonbrain
	b:SetBrain(brain)
	b:AddComponent("health")
    b.components.health:SetMaxHealth(10000)
	b.components.health:StartRegen(2 , 5 )
	b.components.health.fire_damage_scale = 0
	b.components.health:SetAbsorptionAmount(.5)
	b:AddComponent("talker")	
	b:AddComponent("leader")
	
	
	
	b:AddComponent("combat")
    b.components.combat:SetDefaultDamage(30)					
    b.components.combat:SetAttackPeriod(2)
    b.components.combat:SetRange(2)
	b.components.combat.hiteffectsymbol = "torso"
    b.components.combat:SetRetargetFunction(3, RetargetFn)
    b.components.combat:SetKeepTargetFunction(KeepTargetFn)
	b:AddComponent("lootdropper")
	b.components.lootdropper:SetChanceLootTable('zg_ch_willow')	
	

	
	
	
	return b

end
             ---------------BOSS 4号

local function SpawnNPC4(x,z)
    local c = SpawnPrefab("ruins_bat")
    c.Transform:SetPosition(x, 0, z)
    c.AnimState:SetBank("wilson")
    c.AnimState:SetBuild("wickerbottom") 
	c.AnimState:PlayAnimation("idle")
    c.AnimState:OverrideSymbol("swap_object", "swap_staffs", "bluestaff")
    c.AnimState:Hide("ARM_normal") 
    c.AnimState:Show("ARM_carry")
    c.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    c.AnimState:Show("HAT")
    c.AnimState:Show("HAT_HAIR")
    c.AnimState:Hide("HAIR_NOHAT")
    c.AnimState:Hide("HAIR")
    c.Transform:SetFourFaced()
    c.Transform:SetRotation( 0 )
    c.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = c.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	c:AddComponent("timer")
	c:AddComponent("talker")
    c:AddComponent("named")
	c.components.named:SetName("恶魔奶奶")
	c:AddComponent("inspectable")
	c.components.inspectable:SetDescription("这老奶奶真是恶魔啊")
    c.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    c:RemoveComponent("inventoryitem")
	c:RemoveComponent("finiteuses")
    local light = c.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	
	local function RetargetFn(c)
    local invader = nil
    invader = FindEntity(c, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .1 then
			c.components.talker:Say("让你永远闭嘴!")
		elseif sayrandom < .2 then
			c.components.talker:Say("站住！尝尝我的法术！")
		end
	end
    return invader, true
    end
	
	local function KeepTargetFn(c, target)
    return c.components.combat:CanTarget(target)     
    end
	
	SetSharedLootTable( 'zg_ch_wicker',
    {
	{'icestaff',          1.00},
    })
	
	local function GetInventory(c)
    if c.components.inventory ~= nil and not c.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local meleeweapon = CreateEntity()
        meleeweapon.entity:AddTransform()
        meleeweapon:AddComponent("weapon")
        meleeweapon.components.weapon:SetDamage(60 )			----冰尖柱法术
		meleeweapon.components.weapon:SetRange(4, 7)
        meleeweapon:AddComponent("inventoryitem")
        meleeweapon.persists = false
        meleeweapon.components.inventoryitem:SetOnDroppedFn(c.Remove)
		meleeweapon:AddComponent("equippable")
        meleeweapon:AddTag("meleeweapon")
		c.components.inventory:Equip(meleeweapon)
        end
    end
	
	local function NumPerdsToSpawn(c)
    local numFollowers = c.components.leader:CountFollowers()
	local num = 1 - numFollowers
	if num <= 0 then
		return 0
	else
		return num
	end
    end
	
	
	----	不会中毒，共性
    c:AddComponent("eater")  
	c.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    c.components.eater.strongstomach = true
	local selfeater = c.components.eater
	local old = selfeater.Eat
	function c.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
	c:AddComponent("locomotor")
    c.components.locomotor.walkspeed= 1.5
    c.components.locomotor.runspeed = 2.5
	c.components.locomotor.fasteronroad = true
	c.components.locomotor:SetTriggersCreep(false)
	
	c.NumPerdsToSpawn = NumPerdsToSpawn
	
	c:SetStateGraph("SGzg_ch_wicker")

    local brain = require "brains/zg_ch_wilsonbrain"		
    c:SetBrain(brain)
	
	c:AddComponent("health")
    c.components.health:SetMaxHealth(10000)
	c.components.health:StartRegen(2 , 5 )
	c.components.health.fire_damage_scale = 0
	c.components.health:SetAbsorptionAmount(.5)
	
	c:AddComponent("combat")
    c.components.combat:SetDefaultDamage(60 )					----常常不是空手, 因此无用				
    c.components.combat:SetAttackPeriod(2)
    c.components.combat:SetRange(2)
	c.components.combat.hiteffectsymbol = "torso"
    c.components.combat:SetRetargetFunction(3, RetargetFn)
    c.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	c:AddComponent("lootdropper")
	c.components.lootdropper:SetChanceLootTable('zg_ch_wicker')
	
	c:AddComponent("timer")
	c:ListenForEvent("timerdone", function(c, data)
		if data.name == "pound" then	--冰风暴
			c.canpound = true
		end
	end)
	return c
end


local function SpawnNPC5(x,z)
    local d = SpawnPrefab("ruins_bat")
    d.Transform:SetPosition(x, 0, z)
    d.AnimState:SetBank("wilson")
	d.AnimState:SetBuild("webber")
	---d.AnimState:AddOverrideBuild("beefalo_domesticated")
	d.AnimState:PlayAnimation("idle")
    d.AnimState:OverrideSymbol("swap_object", "swap_boomerang", "swap_boomerang")
    d.AnimState:Hide("ARM_normal") 
    d.AnimState:Show("ARM_carry")
    d.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    d.AnimState:Show("HAT")
    d.AnimState:Show("HAT_HAIR")
    d.AnimState:Hide("HAIR_NOHAT")
    d.AnimState:Hide("HAIR")
    d.Transform:SetFourFaced()
    d.Transform:SetRotation( 0 )
    d.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = d.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	d:AddComponent("timer")
	d:AddComponent("talker")
    d:AddComponent("named")
	d.components.named:SetName("恶魔蜘蛛人")
	d:AddComponent("inspectable")
	d.components.inspectable:SetDescription("蜘蛛堡的信差")
    d.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    d:RemoveComponent("inventoryitem")
	d:RemoveComponent("finiteuses")
    local light = d.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	local function RetargetFn(d)
    local invader = nil
    invader = FindEntity(d, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .05 then
			d.components.talker:Say("我要吃肉!")
		elseif sayrandom < .1 then
			d.components.talker:Say("小子不许走!")
		end
	end
    return invader, true
    end
    local function KeepTargetFn(d, target)
    return d.components.combat:CanTarget(target)     
    end
	SetSharedLootTable( 'zg_ch_webber',
    {
	
	{'meat',          1.00},
	{'meat',          0.50},
	
	{'silk',          1.00},
	{'silk',          1.00},

    })
	
	local function NumPerdsToSpawn(d)
    local numFollowers = d.components.leader:CountFollowers()
	local num = 1 - numFollowers
	if num <= 0 then
		return 0
	else
		return num
	end
    end
	
	d:AddComponent("eater")  
	d.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    d.components.eater.strongstomach = true
	local selfeater = d.components.eater
	local old = selfeater.Eat
	function d.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
	d:AddComponent("locomotor")
    d.components.locomotor.walkspeed= 4
    d.components.locomotor.runspeed = 5
	d.components.locomotor.fasteronroad = true
	d.components.locomotor:SetTriggersCreep(false)
	d.NumPerdsToSpawn = NumPerdsToSpawn
	
	----	状态图和AI
    -- d:SetStateGraph("SGzg_ch_webber") --找不到sg 换一个
	d:SetStateGraph("SGzg_ch_willow")

    -- local brain = require "brains/zg_ch_wickerbrain"
	local brain = require "brains/zg_ch_wilsonbrain"
	
    d:SetBrain(brain)
	d:AddComponent("health")
    d.components.health:SetMaxHealth(10000)
	d.components.health:StartRegen(2, 5 )
	d.components.health.fire_damage_scale = 0
	d.components.health:SetAbsorptionAmount(.45)
	d:AddComponent("talker")
	d:AddComponent("leader")
	d:AddComponent("combat")
    d.components.combat:SetDefaultDamage(60 )						----常常不是空手, 因此无用
    d.components.combat:SetAttackPeriod(4)
    d.components.combat:SetRange(2)
    d.components.combat.hiteffectsymbol = "torso"
    d.components.combat:SetRetargetFunction(3, RetargetFn)
    d.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	d:AddComponent("lootdropper")
	d.components.lootdropper:SetChanceLootTable('zg_ch_webber')
	
	
	
end



local function SpawnNPC6(x,z)
    local e = SpawnPrefab("ruins_bat")
    e.Transform:SetPosition(x, 0, z)
    e.AnimState:SetBank("wilson")
	e.AnimState:SetBuild("wolfgang_mighty")
	---d.AnimState:AddOverrideBuild("beefalo_domesticated")
	e.AnimState:PlayAnimation("idle")
    e.AnimState:OverrideSymbol("swap_object", "swap_hammer", "swap_hammer")
    e.AnimState:Hide("ARM_normal") 
    e.AnimState:Show("ARM_carry")
    e.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    e.AnimState:Show("HAT")
    e.AnimState:Show("HAT_HAIR")
    e.AnimState:Hide("HAIR_NOHAT")
    e.AnimState:Hide("HAIR")
    e.Transform:SetFourFaced()
    e.Transform:SetRotation( 0 )
    e.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = e.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	e:AddComponent("timer")
	e:AddComponent("talker")
    e:AddComponent("named")
	e.components.named:SetName("恶魔大力士")
	e:AddComponent("inspectable")
	e.components.inspectable:SetDescription("这B玩意儿打人贼疼")
    e.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    e:RemoveComponent("inventoryitem")
	e:RemoveComponent("finiteuses")
    local light = e.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	
	local function RetargetFn(e)
    local invader = nil
    invader = FindEntity(e, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .05 then
			e.components.talker:Say("尝尝我大锤的厉害")
		elseif sayrandom < .1 then
			e.components.talker:Say("我的肌肉结实吗?!")
		end
		
	end
    return invader, true
    end
    local function KeepTargetFn(e, target)
    return e.components.combat:CanTarget(target)     
    end
    SetSharedLootTable( 'zg_ch_wolfgang',
    {
	{'bonestew',          1.00},
	{'bonestew',          0.50},
    })
	local function onattack(e, data)
    local victim = data.target
	if victim and victim:HasTag("player") then
		local x,y,z = victim.Transform:GetWorldPosition()
		SpawnPrefab("collapse_small").Transform:SetPosition(x,y,z)
		if victim.components.hunger then
			victim.components.hunger:DoDelta( -victim.components.hunger.current * .25 )
		end
	    end
	end
	
	e:AddComponent("locomotor")
    e.components.locomotor.walkspeed= 1.5
    e.components.locomotor.runspeed = 2.5
	e.components.locomotor.fasteronroad = true
	e.components.locomotor:SetTriggersCreep(false)
	
	e:SetStateGraph("SGzg_ch_wolfgang")

    local brain = require "brains/zg_ch_wolfgangbrain"
    e:SetBrain(brain)
	
	e:AddComponent("health")
    e.components.health:SetMaxHealth(10000)
	e.components.health:StartRegen(2,5 )
	e.components.health.fire_damage_scale = 0
	e.components.health:SetAbsorptionAmount(.5)
	e:AddComponent("talker")	
	e:AddComponent("leader")
	e:AddComponent("combat")
    e.components.combat:SetDefaultDamage(60)						----常常不是空手, 因此无用
    e.components.combat:SetAttackPeriod(3)
    e.components.combat:SetRange(2.5)
	e.components.combat:SetAreaDamage(2, 1)					----范围攻击
    e.components.combat.hiteffectsymbol = "torso"
    e.components.combat:SetRetargetFunction(2, RetargetFn)
    e.components.combat:SetKeepTargetFunction(KeepTargetFn)
	e:ListenForEvent("onhitother", onattack)
	
	e:AddComponent("groundpounder")
	e.components.groundpounder.numRings = 2	
	e.components.groundpounder.damageRings = 2	
    e.components.groundpounder.burner = false
    e.components.groundpounder.groundpounddamagemult = 1
	e.components.groundpounder.destroyer = false
	e.components.groundpounder.destructionRings = 2
	e.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "shadowboss"}
	e:AddComponent("lootdropper")
	e.components.lootdropper:SetChanceLootTable('zg_ch_wolfgang')
	
	e:AddComponent("timer")
	e:ListenForEvent("timerdone", function(e, data)
		if data.name == "pound" then	--打扁
			e.canpound = true
		end
	end)
	
	e:AddComponent("eater")  
	e.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    e.components.eater.strongstomach = true
	local selfeater = e.components.eater
	local old = selfeater.Eat
	function e.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
	
	
end



local function SpawnNPC7(x,z)
    local f = SpawnPrefab("ruins_bat")
    f.Transform:SetPosition(x, 0, z)
    f.AnimState:SetBank("wilson")
	f.AnimState:SetBuild("woodie")
	f.AnimState:PlayAnimation("idle")
    f.AnimState:OverrideSymbol("swap_object", "swap_lucy_axe", "swap_lucy_axe")
    f.AnimState:Hide("ARM_normal") 
    f.AnimState:Show("ARM_carry")
    f.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    f.AnimState:Show("HAT")
    f.AnimState:Show("HAT_HAIR")
    f.AnimState:Hide("HAIR_NOHAT")
    f.AnimState:Hide("HAIR")
    f.Transform:SetFourFaced()
    f.Transform:SetRotation( 0 )
    f.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = f.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	f:AddComponent("timer")
	f:AddComponent("talker")
    f:AddComponent("named")
	f.components.named:SetName("恶魔伍迪")
	f:AddComponent("inspectable")
	f.components.inspectable:SetDescription("老陈，来PK啊~~~")
    f.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    f:RemoveComponent("inventoryitem")
	f:RemoveComponent("finiteuses")
    local light = f.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	
	local function RetargetFn(f)
    local invader = nil
    invader = FindEntity(f, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	if invader then
		local sayrandom = math.random()
		if sayrandom < .1 then
			f.components.talker:Say("把头伸过来, 我拿露西砍掉")
		elseif sayrandom < .1 then
			f.components.talker:Say("站住！那小子")
		end
	end
    return invader, true
    end
    local function KeepTargetFn(f, target)
    return f.components.combat:CanTarget(target)     
    end
-------------------------------------------------------------------------------------------------------------
    SetSharedLootTable( 'zg_ch_woodie',
    {
	{'dragonpie',          1.00},
	{'dragonpie',          0.50},
    })
	
	f:AddComponent("eater")  
	f.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    f.components.eater.strongstomach = true
	local selfeater = f.components.eater
	local old = selfeater.Eat
	function f.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end
	
	f:AddComponent("locomotor")
    f.components.locomotor.walkspeed= 1.5
    f.components.locomotor.runspeed = 2.5
	f.components.locomotor.fasteronroad = true
	f.components.locomotor:SetTriggersCreep(false)
	
	f:SetStateGraph("SGzg_ch_woodie")

    local brain = require "brains/zg_ch_wolfgangbrain"		
    f:SetBrain(brain)
	
	f:AddComponent("health")
    f.components.health:SetMaxHealth(15000)
	f.components.health:StartRegen(2 , 5 )
	f.components.health.fire_damage_scale = 0
	f.components.health:SetAbsorptionAmount(.35)
	f:AddComponent("talker")
	f:AddComponent("leader")
	f:AddComponent("combat")
    f.components.combat:SetDefaultDamage(80)						
    f.components.combat:SetAttackPeriod(3)
    f.components.combat:SetRange(2)
    f.components.combat.hiteffectsymbol = "torso"
    f.components.combat:SetRetargetFunction(3, RetargetFn)
    f.components.combat:SetKeepTargetFunction(KeepTargetFn)
    f:AddComponent("lootdropper")
	f.components.lootdropper:SetChanceLootTable('zg_ch_woodie')
	
	f:AddComponent("timer")
	f:ListenForEvent("timerdone", function(f, data)
		if data.name == "pound" then	--身体旋风
			f.canpound = true
		end
	end)
  
	
	
end



local function SpawnNPC8(x,z)
	local aa = SpawnPrefab("ruins_bat")
    aa.Transform:SetPosition(x, 0, z)
    aa.AnimState:SetBank("wilson")
    aa.AnimState:SetBuild("wilson") 
    aa.AnimState:PlayAnimation("idle")
    aa.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    aa.AnimState:Hide("ARM_normal") 
    aa.AnimState:Show("ARM_carry")
    aa.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    aa.AnimState:Show("HAT")
    aa.AnimState:Show("HAT_HAIR")
    aa.AnimState:Hide("HAIR_NOHAT")
    aa.AnimState:Hide("HAIR")
    aa.Transform:SetFourFaced()
    aa.Transform:SetRotation( 0 )
    aa.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = aa.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	aa:RemoveComponent("inventoryitem")
	aa:RemoveComponent("finiteuses")
    aa:AddComponent("named")
	aa.components.named:SetName("恶魔威尔逊")
	aa:AddComponent("inspectable")
	----aa.components.inspectable:SetDescription("女神，我爱你！")
	aa.components.inspectable:SetDescription("还记得六苯基苯吗,空间位阻效应还是什么效应来着?")
    aa.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = aa.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	
	----	重定位目标
    local function RetargetFn(aa)
    local invader = nil
    invader = FindEntity(aa, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .0375 then
			aa.components.talker:Say("奉艺皇之命, 让你去一览美景!")
		elseif sayrandom < .075 then
			aa.components.talker:Say("站住！我只想要你的命而已！")
		end
	end
    return invader, true
    end
    local function KeepTargetFn(aa, target)
    return aa.components.combat:CanTarget(target)     
    end
-------------------------------------------------------------------------------------------------------------
    SetSharedLootTable( 'zg_ch_wilson',
    {

	{'turkeydinner',          1.00},
	{'turkeydinner',          0.50},

    })
	
	----	不会中毒，共性
    aa:AddComponent("eater")  
	aa.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    aa.components.eater.strongstomach = true
	local selfeater = aa.components.eater
	local old = selfeater.Eat
	function aa.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end

	----	移动，共性
    aa:AddComponent("locomotor")
    aa.components.locomotor.walkspeed= 1.5
    aa.components.locomotor.runspeed = 2.5
	aa.components.locomotor.fasteronroad = true
	aa.components.locomotor:SetTriggersCreep(false)
	
	aa.NumPerdsToSpawn = NumPerdsToSpawn
	
	----	状态图和AI
    aa:SetStateGraph("SGzg_ch_wilson")

    local brain = require "brains/zg_ch_wilsonbrain"
    aa:SetBrain(brain)
    
	-------------------------------------------------------------------------------------------------------
    aa:AddComponent("health")
    aa.components.health:SetMaxHealth(15000)
	aa.components.health:StartRegen(2 , 5 )
	aa.components.health.fire_damage_scale = 0
	aa.components.health:SetAbsorptionAmount(.55)
	aa:AddComponent("talker")
	aa:AddComponent("leader")
	aa:AddComponent("combat")
    aa.components.combat:SetDefaultDamage(60)					
    aa.components.combat:SetAttackPeriod(2)
    aa.components.combat:SetRange(2)
    aa.components.combat.hiteffectsymbol = "torso"
    aa.components.combat:SetRetargetFunction(3, RetargetFn)
    aa.components.combat:SetKeepTargetFunction(KeepTargetFn)
	aa:AddComponent("lootdropper")
	aa.components.lootdropper:SetChanceLootTable('zg_ch_wilson')
	aa:AddComponent("timer")
	aa:ListenForEvent("timerdone", function(aa, data)
		if data.name == "pound" then	--突击
			aa.canpound = true
		end
	end)
	
	
	
	
end



local function SpawnNPC9(x,z)
	local q = SpawnPrefab("ruins_bat")
    q.Transform:SetPosition(x, 0, z)
    q.AnimState:SetBank("wilson")
    q.AnimState:SetBuild("waxwell") 
    q.AnimState:PlayAnimation("idle")
    q.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword", "swap_nightmaresword")
    q.AnimState:Hide("ARM_normal") 
    q.AnimState:Show("ARM_carry")
    q.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    q.AnimState:Show("HAT")
    q.AnimState:Show("HAT_HAIR")
    q.AnimState:Hide("HAIR_NOHAT")
    q.AnimState:Hide("HAIR")
    q.Transform:SetFourFaced()
    q.Transform:SetRotation( 0 )
    q.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = q.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	q:RemoveComponent("inventoryitem")
	q:RemoveComponent("finiteuses")
    q:AddComponent("named")
	q.components.named:SetName("恶魔麦斯威尔")
	q:AddComponent("inspectable")
	q.components.inspectable:SetDescription("隐身的魔术师,但是我还是看得见它的刀")
    q.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = q.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	local function RetargetFn(q)
    local invader = nil
    invader = FindEntity(q, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	
    return invader, true
    end
    local function KeepTargetFn(q, target)
    return q.components.combat:CanTarget(target)     
    end
	
	SetSharedLootTable( 'zg_ch_waxwell',
    {
	{'nightsword',          1.00},	
    })
	
	local function LaunchItem1(q, target, item)
    if item.Physics ~= nil then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        local vel = (target:GetPosition() - q:GetPosition()):GetNormalized()
        local speed = 5 + math.random() * 2
        local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
        item.Physics:SetVel(math.cos(angle) * speed, 10, -math.sin(angle) * speed)
    end
    end
	
	local function onattack(q,data)
    local victim = data.target
	if victim and victim:HasTag("player") then
		
		----	一定几率砍掉帽子
		if math.random () < .2 then
			local item3 = victim.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			if item3 then 
				victim.components.inventory:DropItem(item3)
				LaunchItem1(q, victim, item3)
			end
		end			
	end
    end
	local phys = q.entity:AddPhysics()
	 phys:SetMass(100)
     phys:SetCapsule(.5, 1.5)
     phys:SetFriction(0)
     phys:SetDamping(5)
     phys:SetCollisionGroup(COLLISION.CHARACTERS)
     phys:ClearCollisionMask()
	 phys:CollidesWith(COLLISION.GROUND)
	
	
	
    q:AddComponent("eater")  
	q.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    q.components.eater.strongstomach = true
	local selfeater = q.components.eater
	local old = selfeater.Eat
	function q.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end

    q:AddComponent("locomotor")
    q.components.locomotor.walkspeed= 1.5
    q.components.locomotor.runspeed = 2.5
	q.components.locomotor.fasteronroad = false
	q.components.locomotor:SetTriggersCreep(false)
    q:SetStateGraph("SGzg_ch_waxwell")
    local brain = require "brains/zg_ch_wilsonbrain"		
    q:SetBrain(brain)
    q:AddComponent("health")
    q.components.health:SetMaxHealth(15000)
	q.components.health:StartRegen(2 , 5 )
	q.components.health.fire_damage_scale = 0
	q.components.health:SetAbsorptionAmount(.55)
	q:AddComponent("talker")
	q:AddComponent("leader")
	q:AddComponent("combat")
    q.components.combat:SetDefaultDamage( 60 )						
    q.components.combat:SetAttackPeriod(3)
    q.components.combat:SetRange(2)
    q.components.combat.hiteffectsymbol = "torso"
    q.components.combat:SetRetargetFunction(3, RetargetFn)
    q.components.combat:SetKeepTargetFunction(KeepTargetFn)
	q:ListenForEvent("onattackother", onattack)
	q:AddComponent("lootdropper")
	q.components.lootdropper:SetChanceLootTable('zg_ch_waxwell')
	q:AddComponent("timer")
	q:ListenForEvent("timerdone", function(q, data)
		if data.name == "pound" then	--暗影闪电
			q.canpound = true
		end
	end)	
	return q
end



local function SpawnNPC10(x,z)
	local w = SpawnPrefab("ruins_bat")
    w.Transform:SetPosition(x, 0, z)
    w.AnimState:SetBank("wilson")
    w.AnimState:SetBuild("wilson") 
    w.AnimState:PlayAnimation("idle")
    w.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword", "swap_nightmaresword")
    w.AnimState:Hide("ARM_normal") 
    w.AnimState:Show("ARM_carry")
    w.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    w.AnimState:Show("HAT")
    w.AnimState:Show("HAT_HAIR")
    w.AnimState:Hide("HAIR_NOHAT")
    w.AnimState:Hide("HAIR")
    w.Transform:SetFourFaced()
    w.Transform:SetRotation( 0 )
    w.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = w.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	w:RemoveComponent("inventoryitem")
	w:RemoveComponent("finiteuses")
    w:AddComponent("named")
	w.components.named:SetName("真恶魔威尔逊")
	w:AddComponent("inspectable")
	w.components.inspectable:SetDescription("他会使用风")
    w.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = w.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	local function RetargetFn(w)
    local invader = nil
    invader = FindEntity(w, 10 + 15, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .05 then
			w.components.talker:Say("伙计, 给我把武器!")
		elseif sayrandom < .1 then
			w.components.talker:Say("我要成为世界第一刀客！")
		end
	end
    return invader
    end
    local function KeepTargetFn(w, target)
    return w.components.combat:CanTarget(target)     
    end
    SetSharedLootTable( 'zg_ch1_sanji',
    {
	{'pumpkincookie',          0.2},	
    })
    local function onattack(w, data)
    local victim = data.target
	if victim and victim.SoundEmitter then
	end
	if victim and victim.components.burnable and w.firetick then
		victim.components.burnable:Ignite()
	end
    end
	
	
	w:AddComponent("eater")  
	w.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    w.components.eater.strongstomach = true
	local selfeater = w.components.eater
	local old = selfeater.Eat
	function w.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end

	----	移动，共性
    w:AddComponent("locomotor")
    w.components.locomotor.walkspeed= 1.5
    w.components.locomotor.runspeed = 2.5
	w.components.locomotor.fasteronroad = true
	w.components.locomotor:SetTriggersCreep(false)
	
	----	状态图和AI
    w:SetStateGraph("SGzg_ch1_zoro")

    local brain = require "brains/zg_ch_wolfgangbrain"
    w:SetBrain(brain)
	
	w:AddComponent("health")
    w.components.health:SetMaxHealth(2000)
	w.components.health.fire_damage_scale = 0
	w.components.health:SetAbsorptionAmount(.85)
	w:AddComponent("talker")	
	w:AddComponent("leader")
	
	w:AddComponent("combat")
    w.components.combat:SetDefaultDamage(60)						
    w.components.combat:SetAttackPeriod(2)
    w.components.combat:SetRange(2)			
	w.components.combat:SetAreaDamage(2, 0.6)					----范围攻击
    w.components.combat.hiteffectsymbol = "torso"
    w.components.combat:SetRetargetFunction(1, RetargetFn)
    w.components.combat:SetKeepTargetFunction(KeepTargetFn)
	w:ListenForEvent("onhitother", onattack)	
    w:AddComponent("lootdropper")
	w.components.lootdropper:SetChanceLootTable('zg_ch1_sanji')
	
	w:AddComponent("timer")
	w.canpound = true
	w.canpound2 = true
	w:ListenForEvent("timerdone", function (w, data)

		if data.name == "pound" then	----风暴
			w.canpound = true
		elseif data.name == "pound2" then	----死亡新月
			w.canpound2 = true
		end
		
	end)
	
	return w
	
	

end



local function SpawnNPC11(x,z)
	local r = SpawnPrefab("ruins_bat")
    r.Transform:SetPosition(x, 0, z)
    r.AnimState:SetBank("wilson")
    r.AnimState:SetBuild("wx78") 
    r.AnimState:PlayAnimation("idle")
    r.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword", "swap_nightmaresword")
    r.AnimState:Hide("ARM_normal") 
    r.AnimState:Show("ARM_carry")
    r.AnimState:OverrideSymbol("swap_hat", "hat_ruins", "swap_hat")
    r.AnimState:Show("HAT")
    r.AnimState:Show("HAT_HAIR")
    r.AnimState:Hide("HAIR_NOHAT")
    r.AnimState:Hide("HAIR")
    r.Transform:SetFourFaced()
    r.Transform:SetRotation( 0 )
    r.Transform:SetScale(3.5, 3.5, 3.5)
    local shadow = r.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
	r:RemoveComponent("inventoryitem")
	r:RemoveComponent("finiteuses")
    r:AddComponent("named")
	r.components.named:SetName("!老陈!")
	r:AddComponent("inspectable")
	r.components.inspectable:SetDescription("他会使用风")
    r.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    local light = r.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(10)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	local function RetargetFn(r)
    local invader = nil
    invader = FindEntity(r, 60, function(guy)
        return guy:HasTag("player") and not guy:HasTag("shadowboss") and not guy:HasTag("playerghost")
    end)
	----	敌视语句
	if invader then
		local sayrandom = math.random()
		if sayrandom < .3 then
			if r.components.talker then
				r.components.talker:Say("闲来无事罢了!")
			end
		end
	end
    return invader,true
    end
    local function KeepTargetFn(r, target)
    return r.components.combat:CanTarget(target)     
    end
	
	SetSharedLootTable( 'zg_ch3_mihawk',
{
	{'armorruins',          .5},
	{'ruinshat',          .5},
	{'thulecite',          .5},
	{'wall_ruins_item',          .5},
	{'nightmare_timepiece',          .5},
	{'orangeamulet',          .5},
	{'yellowamulet',          .5},
	{'greenamulet',          .5},
	{'orangestaff',          .5},
	{'yellowstaff',          .5},
	{'greenstaff',          .5},
	{'multitool_axe_pickaxe',          .5},
	{'ruins_bat',          .5},
	{'panflute',          .5},
	{'armor_sanity',          .5},
	{'nightsword',          .5},
	{'batbat',          .5},
	{'armorslurper',          .5},
	{'amulet',          .5},
	{'blueamulet',          .5},
	{'purpleamulet',          .5},
	{'firestaff',          .5},
	{'icestaff',          .5},
	{'telestaff',          .5},
    })
	
	local function LaunchItem(r, target, item)
    if item.Physics ~= nil then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        local vel = (target:GetPosition() - r:GetPosition()):GetNormalized()
        local speed = 5 + math.random() * 2
        local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
        item.Physics:SetVel(math.cos(angle) * speed, 10, -math.sin(angle) * speed)
    end
    end
	
	local function onattack(r,data)
    local victim = data.target
	if victim then
		if victim:HasTag("player") then
			if math.random() < .5 then
				local item = victim.components.inventory and victim.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if item then
					victim.components.inventory:DropItem(item)
					LaunchItem(r, victim, item)
				end
			end
		end
	end
    end
	
	MakeCharacterPhysics(r, 75, .5)
	r.Physics:ClearCollisionMask()
    r.Physics:CollidesWith(COLLISION.CHARACTERS)
	r.Physics:CollidesWith(COLLISION.GROUND)
	
	
	
	----	不会中毒，共性
    r:AddComponent("eater")  
	r.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI})
    r.components.eater.strongstomach = true
	local selfeater = r.components.eater
	local old = selfeater.Eat
	function r.components.eater:Eat(food)
		if selfeater:CanEat(food) then
			if food.components.edible.healthvalue < 1 then
				food.components.edible.healthvalue = 1
			end
		end
		return old(selfeater, food)
	end

	----	移动，共性
    r:AddComponent("locomotor")
    r.components.locomotor.walkspeed= 1.5
    r.components.locomotor.runspeed = 2.5
	r.components.locomotor.fasteronroad = true
	r.components.locomotor:SetTriggersCreep(false)
	
	r:SetStateGraph("SGzg_ch3_mihawk")
	local brain = require "brains/zg_ch3_mihawkbrain"
    r:SetBrain(brain)
	
	r.zg_chase_time=30	--追杀时间
	r.zg_see_dist=8	--逃跑检测hunter的距离
	
	r.zg_startrunaway_dist=2		--开始躲避敌人预留的距离
	r.zg_stoprunaway_dist=3	--躲避敌人攻击距离 预留的安全距离
	
	r.target_exdist=1	--玩家要是武器距离超过1,不再走位
	
	
	r:AddComponent("health")
    r.components.health:SetMaxHealth(10000)
	r.components.health.fire_damage_scale = 0
	r.components.health:SetAbsorptionAmount(.8)
	
	r:AddComponent("talker")
	
	r:AddComponent("leader")
	
	r:AddComponent("combat")
    r.components.combat:SetDefaultDamage(60)						----常常不是空手, 因此无用
    r.components.combat:SetAttackPeriod(2)
    r.components.combat:SetRange(2)
    r.components.combat.hiteffectsymbol = "torso"
    r.components.combat:SetRetargetFunction(1, RetargetFn)
    r.components.combat:SetKeepTargetFunction(KeepTargetFn)
	r.components.combat:SetAreaDamage(3, 1)					----范围攻击

	function r.components.combat:CanTarget(target)
		return true
	end
	function r.components.combat:IsValidTarget(target)
		return true
	end
	function r.components.combat:CanHitTarget(target, weapon)
		if self.r ~= nil and
			self.r:IsValid() and
			target ~= nil and
			(   self:CanExtinguishTarget(target, weapon) or
				self:CanLightTarget(target, weapon) or
				(   target.components.combat ~= nil 
				)
			) then

			local targetpos = target:GetPosition()
			if distsq(targetpos, self.r:GetPosition()) <= self:CalcHitRangeSq(target) then
				return true
			elseif weapon ~= nil and weapon.components.projectile ~= nil then
				local range = target.Physics ~= nil and target.Physics:GetRadius() + weapon.components.projectile.hitdist or weapon.components.projectile.hitdist
				return distsq(targetpos, weapon:GetPosition()) <= range * range
			end
		end
		return false
	end
	
	r:ListenForEvent("onhitother", onattack)
    r:AddComponent("lootdropper")
	r.components.lootdropper:SetChanceLootTable('zg_ch3_mihawk')
	
	r:AddComponent("timer")
	r.canpound = true
	r.canpound2 = true
	r:ListenForEvent("timerdone", function (r, data)
		if data.name == "pound" then	----世界第一斩击
			r.canpound = true
		elseif data.name == "pound2" then	----横扫千军
			r.canpound2 = true
		end
	end)
	
	r:ListenForEvent("healthdelta", function (r, data)
		local newpercent=data.newpercent
		if newpercent and newpercent<.5 then
			if not r.wzs then
				r.wzs=true
				r.components.combat.damagemultiplier=2
				r.components.health:SetAbsorptionAmount(.99)
				----Spawn(r,"forcefieldfx",nil,1,1)
				TheNet:Announce("老陈开启了流氓色霸气，双倍攻击，99%防御")
			end
		end
	end)	
	return r
end


AddPrefabPostInit("multiplayer_portal",function(inst)

local r = GLOBAL.TheShard:GetShardId()


	if IsServer then
		inst.CreateResourses = CreateResourses
		inst:DoTaskInTime(0,function()
 --获取世界天数，如果大于1，就不要修改了,避免重复放置,用这段只会放置一次--
--[[	if TheWorld.state.cycles > 0 then
		return 
	end--]]
			if not inst.haszone then--若门口没有对应的东西，就再行放置，有的话不会再放置
				inst.haszone = true
				local x,y,z = inst.Transform:GetWorldPosition()
				--创建一个封闭区域
				for k = -TUNING.H1Z1_ZONE_LENGTH, TUNING.H1Z1_ZONE_LENGTH do
					-- SpawnBasalt(x + k, z + TUNING.H1Z1_ZONE_LENGTH)
					-- SpawnBasalt(x + k, z - TUNING.H1Z1_ZONE_LENGTH)
					-- SpawnBasalt(x + TUNING.H1Z1_ZONE_LENGTH, z + k)
					-- SpawnBasalt(x - TUNING.H1Z1_ZONE_LENGTH, z + k)
				end
				
				local x,y,z = inst.Transform:GetWorldPosition()
				--创建灯口~~~~~~~~~~~
				for k = -22, 22 do
					SpawnBasalta(x + k, z + 22)
					SpawnBasalta(x + k, z - 22)
					SpawnBasalta(x + 22, z + k)
					SpawnBasalta(x - 22, z + k)
				end
				
				local x,y,z = inst.Transform:GetWorldPosition()
				--创建内部灯口~~~~~~~~~~~
				for k = -5, 5 do
					SpawnBasalta(x + k, z + 5)
					SpawnBasalta(x + k, z - 5)
					SpawnBasalta(x + 5, z + k)
					SpawnBasalta(x - 5, z + k)
				end
				local x,y,z = inst.Transform:GetWorldPosition()
				--创建玫瑰花圈
				for k = -21, 21,1 do
				SpawnNPCB(x+k,z+21)
				SpawnNPCB(x+k,z-21)
				SpawnNPCB(x+21,z+k)
				SpawnNPCB(x-21,z+k)

				end
				local x,y,z = inst.Transform:GetWorldPosition()
				--创建风滚圈
				for k = -42, 42,1 do
				-- SpawnNPCC(x+k,z+42)
			    -- SpawnNPCC(x+k,z-42)
				-- SpawnNPCC(x+42,z+k)
				-- SpawnNPCC(x-42,z+k)
				end
				--创建NCP
				--SpawnNPCR(x+npc_dist,z+npc_dist)
				SpawnNPCQ(x+9,z+9)
				SpawnNPCQ(x+9,z-9)
				--SpawnNPCW(x+npc_dist,z-npc_dist)
				--SpawnNPCE(x-npc_dist,z+npc_dist)
				SpawnNPCE(x-15,z+15)
				SpawnNPCA(x-10,z+10)
				SpawnNPCW(x-10,z-10)
				SpawnNPCD(x-15,z-15)
				SpawnNPCR(x+npc_dist,z+npc_dist)
				SpawnNPCR(x+npc_dist,z-npc_dist)
				SpawnNPCR(x-npc_dist,z+npc_dist)
				SpawnNPCR(x-npc_dist,z-npc_dist)
				-- SpawnNPCy(x-22,z-22)--斗兽场1
				-- SpawnBasaltB(x-22,z-22)--斗兽场1的2层
				SpawnNPCy2(x+44,z+44)--斗兽场2
				SpawnBasaltB(x+44,z+44)--斗兽场2的2层
				SpawnBasaltC(x-20,z-20)--斗兽场3层
				-- SpawnNPCI(x-20,z-20)
				----创建BOSS
               SpawnNPC1(x-math.random(0,500),z+math.random(0,500))
			   SpawnNPC1(x-36,z+36)
			   SpawnNPC1(x-36,z+18)
			   SpawnNPC1(x-36,z+36)
			   SpawnNPC1(x+36,z+36)
			   SpawnNPC1(x-36,z-18)
			   SpawnNPC1(x-36,z-36)
			   SpawnNPC1(x-18,z+36)
			   SpawnNPC1(x+18,z+36)
			   SpawnNPC2(x-72,z+72)
			   SpawnNPC3(x-73,z+72)
			   SpawnNPC5(x-96,z+96)
			   SpawnNPC7(x-math.random(0,200),z+math.random(0,200))
				SpawnNPC8(x-math.random(0,200),z+math.random(0,200))
				SpawnNPC9(x-math.random(0,200),z+math.random(0,200))
				SpawnNPC10(x-math.random(0,200),z+math.random(0,200))
				SpawnNPC7(x-math.random(0,250),z+math.random(0,250))
				SpawnNPC8(x-math.random(0,250),z+math.random(0,250))
				SpawnNPC9(x-math.random(0,250),z+math.random(0,250))
				SpawnNPC10(x-math.random(0,250),z+math.random(0,250))
				SpawnNPC7(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC8(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC9(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC10(x-math.random(0,500),z+math.random(0,500))
				--[[SpawnNPC2(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC3(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC4(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC5(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC7(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC8(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC9(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC10(x-math.random(0,500),z+math.random(0,500))
				SpawnNPC11(x-math.random(0,500),z+math.random(0,500))--]]
				
			end
			
		end)
		inst.haszone =false
	--[[	inst.OnSave = onsave --保存
    inst.OnPreLoad = onpreload --]]
		
		inst:ListenForEvent("ms_playerjoined", function(src, player) 
			if not inst.h1z1_delete then--删除函数（删除项目以外的其他物品
				inst.h1z1_delete = true
				local x,y,z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,0,z,TUNING.H1Z1_ZONE_LENGTH*2)
				for k, v in pairs(ents) do
					if not (v.prefab == "multiplayer_portal" 
						or v.prefab == "basalt_pillar"
						or v.prefab == "statuemaxwell"
						or v.prefab == "ancient_altar"
						or v.prefab == "charcoal"
						or v.prefab == "statueglommer" 
                        or v.prefab == "critterlab"   
						or v.prefab == "ash"
						or v.prefab == "ruins_bat"
						or v.prefab == "thulecite"
						or v.prefab == "ancient_altar"
                        or v.prefab == "wall_ruins"				
						or v:HasTag("player"))
						and IsInStartZone(v)
						then
						v:Remove()
					end
				end
			end
		end, TheWorld)
	end

end)
------------------------------------------------全图定位。-----------

AddPlayerPostInit(function(inst) 
    if inst.prefab ~= nil then 
    end 
    inst:AddTag("compassbearer")
	inst:AddTag("maprevealer")
    inst:AddComponent("maprevealer")	 
	if inst.components.maprevealable ~= nil then
       inst.components.maprevealable:AddRevealSource(inst, "compassbearer")
    end
end)   
-----获取玩家id和加玩法介绍---
if GLOBAL.TheNet 
and GLOBAL.TheNet:GetIsServer() 
then 

function GetPlayerById(id) 
for k,v in ipairs(GLOBAL.AllPlayers) 
do if v ~= nil and v.userid and v.userid == id 
then return v 
end 
end 
return nil 
end 

local OldNetworking_Say = GLOBAL.Networking_Say  
GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper) 
OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper) 
local talker = GetPlayerById(userid) 
local shardId = GLOBAL.TheShard:GetShardId()
 
if whisper 
then 
if string.sub(message,1,8) == "#宝石升级玩法" then 
talker.components.talker:Say("吃红宝石增加抗暑\r吃蓝宝石增加抗寒\r吃紫宝石增加范围攻击\r吃橙宝石增加移速\r吃黄宝石增加发光\r吃绿宝石增加攻击倍数\r吃彩色宝石（分解权杖分解呼月之杖）加自动回血和免伤\r吃铥矿增加三维") 
end 
end 
end 
end


