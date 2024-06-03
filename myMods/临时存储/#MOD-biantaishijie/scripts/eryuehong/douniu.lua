
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})	
				

local function DOUNIUSHI(x,z)
    local NPC = SpawnPrefab("horn")
    NPC.Transform:SetPosition(x, 0, z)
    NPC.AnimState:SetBank("wilson")
    NPC.AnimState:SetBuild("wilson")
	NPC.AnimState:PlayAnimation("idle")
    NPC.Transform:SetFourFaced()
    NPC.Transform:SetScale(1.5, 1.5, 1.5)
	NPC.AnimState:SetMultColour(1, 0, 1, 1)	
    NPC:RemoveComponent("instrument")
    NPC:RemoveComponent("tool")
    NPC:RemoveComponent("finiteuses")
    NPC:RemoveComponent("inventoryitem")
    NPC:RemoveTag("horn")
    NPC:AddComponent("named")
    NPC.components.named:SetName("西班牙斗牛士")
	NPC.components.inspectable:SetDescription("给予金元宝可以斗牛")
	NPC.persists = false	
    local light = NPC.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.8)
    light:SetRadius(15)
    light:SetColour(180/255, 195/255, 50/255)
    light:Enable(true)
	
	local function ShouldAcceptItem(NPC, giver, item)
    if item.prefab == "lucky_goldnugget" then
       return false
    end
    return true
	end
    
    local function OnGetItemFromPlayer(NPC, giver, item)
        if item.prefab == "lucky_goldnugget" then
		giver.components.talker:Say("本斗牛士来了~")
        local DN = SpawnPrefab("beefalo")
        DN.Transform:SetPosition(x+2, 0, z+2)
        DN.Transform:SetScale(2, 2, 2)
		DN.AnimState:SetMultColour(0, 1, 0, 1)	
        DN:AddComponent("named")
        DN.components.named:SetName("西班牙斗牛\n斗牛士："..giver.name)
		DN.components.inspectable:SetDescription("纯种的西班牙斗牛")
		
        DN.components.locomotor.walkspeed = math.random(4,6)
        DN.components.locomotor.runspeed = math.random(8,10)
        DN:SetStateGraph("SGBeefalo")
        local brain = require "brains/leifbrain"
        DN:SetBrain(brain)
        DN:AddComponent("knownlocations")
        DN:AddComponent("lootdropper")
        DN.components.lootdropper:SetLoot({"meat","meat","meat","meat","beefalowool","beefalowool"})
        DN.components.lootdropper:AddChanceLoot("horn", 0.05)
		DN.components.lootdropper:AddChanceLoot("goldnugget", 0.5)
        DN.components.health:SetMaxHealth(math.random(3000,7000))
        DN.components.combat:SetTarget(giver)
        DN.components.combat.hiteffectsymbol = "beefalo_body"
        DN.components.combat:SetDefaultDamage(math.random(30,70))
        DN.components.combat:SetAttackPeriod(math.random(0.5,2))
        DN.components.combat:SetRetargetFunction(1, function(DN)
            if not DN.components.health:IsDead() then
               return FindEntity(DN, 50, function(guy)
                    if guy.components.health and not guy.components.health:IsDead() and not guy:HasTag("DN") then
                       return guy:HasTag("player")
                    end
               end )
            end
        end )
        DN.components.combat:SetKeepTargetFunction(function(DN, target) return target and target:IsValid() end )
       
        DN:DoTaskInTime(60, function()
            if not DN.components.health:IsDead() then
               SpawnPrefab("die_fx").Transform:SetPosition(DN.Transform:GetWorldPosition())
               DN:Remove()
            end
        end )
        DN:AddTag("DN")
		end
	end
	
    for k = 0,6 do
        local GZ = SpawnPrefab("horn")
        GZ.Transform:SetPosition(x-2+6-k*2, 0, z-2-6+k*2)
		GZ.persists = false	
        GZ.AnimState:SetBank("wilson")
        local names = {"wilson","wendy","wes","wickerbottom","willow","wolfgang","wx78"}
        local buildname = names[math.random(#names)]
        GZ.AnimState:SetBuild(buildname)
        local hats = {"hat_bee","hat_beefalo","hat_bush","hat_earmuffs","hat_feather","hat_flower","hat_football","hat_miner","hat_ruins","hat_slurper","hat_slurtle","hat_spider","hat_straw","hat_top","hat_walrus","hat_winter","hat_rain","hat_watermelon","hat_ice","hat_catcoon","hat_wathgrithr"}
        local hat = hats[math.random(#hats)]
        GZ.AnimState:OverrideSymbol("swap_hat", hat, "swap_hat")
        local armors = {"armor_grass","armor_marble","armor_onemanband","armor_ruins","armor_sanity","armor_slurper","armor_slurtleshell","armor_sweatervest","armor_trunkvest_summer","armor_trunkvest_winter","armor_wood","torso_rain"}
        local armor = armors[math.random(#armors)]
        GZ.AnimState:OverrideSymbol("swap_body", armor, "swap_body")
        GZ.AnimState:Show("HAT")
        GZ.AnimState:Show("HAT_HAIR")
        GZ.AnimState:Hide("HAIR_NOHAT")
        GZ.AnimState:Hide("HAIR")
        GZ.AnimState:Hide("ARM_carry")
        GZ.AnimState:Show("ARM_normal")
		GZ:AddComponent("named")
        GZ.components.named:SetName("斗牛场观众")
		GZ.components.inspectable:SetDescription("这些观众只会喝彩，都不帮人的")
        local stories = {"idle","hungry","eat","dart","throw","atk","idle_onemanband1_loop","run_pst","item_hat","give"}
        local story = stories[math.random(#stories)]
        GZ.AnimState:PlayAnimation(story,true)
        GZ.Transform:SetFourFaced()
        GZ:RemoveComponent("instrument")
        GZ:RemoveComponent("inventoryitem")
        GZ:RemoveTag("horn")
        GZ:AddTag("nobullring")
    end


    NPC:AddComponent("trader")
    NPC.components.trader.onaccept = OnGetItemFromPlayer
    NPC.components.trader:SetAcceptTest(ShouldAcceptItem)




end
		

AddPrefabPostInit("beequeenhive",function(inst)
	if inst then
		inst:DoTaskInTime(0,function()
			local x,y,z = inst.Transform:GetWorldPosition()					
			DOUNIUSHI(x-10,z-10)
		end)
	end
end)





local function ShouldAcceptItem1(inst, giver,item)
    if item.prefab == "goldnugget" then
        return false
    end
    return true
end
local function OnGetItemFromPlayer1(inst, giver, item)
    if item.prefab == "goldnugget" then
    local bullet = SpawnPrefab("trinket_5")
    bullet.Transform:SetPosition(inst.Transform:GetWorldPosition())
    bullet.components.inventoryitem.canbepickedup = false
    bullet.Physics:SetMotorVelOverride(0,20,0)
    giver.components.sanity:DoDelta(10)
    inst:DoTaskInTime(1, function() bullet:Remove() end )
    inst:DoTaskInTime(1.5, function()
		inst:StartThread(function()
			for k = 1, 200 do
               local pt = Vector3(giver.Transform:GetWorldPosition())
               local rain = SpawnPrefab("lightbulb")
               rain:RemoveComponent("edible")
			   rain:AddTag("NOCLICK")
			   ---giver.SoundEmitter:PlaySound("dontstarve/music/music_hoedown", "beavermusic")   ----音效
			   
			  -- giver:DoTaskInTime(30, function()
                  --  giver.SoundEmitter:KillSound("beavermusic")
			  -- end)
			   
               rain.components.inventoryitem.canbepickedup = false
               if item.prefab == "goldnugget" then
                  rain.AnimState:SetMultColour(math.random(255)/255,math.random(255)/255,math.random(255)/255,1)
               end
               rain.Transform:SetPosition(pt.x+(math.random(30)-math.random(30)), 20, pt.z+(math.random(30)-math.random(30)))
               inst:DoTaskInTime(1.5, function()
                    rain:Remove()
               end)
               Sleep(0.2)
			end
		end)
    end)
	
	end
end

AddPrefabPostInit("flowerhat",function(inst)
	if inst then
    inst:AddComponent("trader")
    inst.components.trader.onaccept = OnGetItemFromPlayer1
    inst.components.trader:SetAcceptTest(ShouldAcceptItem1)
	end
end)

















