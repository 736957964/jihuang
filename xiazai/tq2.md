> 摘录う丶青木
- 数据提取2
```lua	
黑色骑士			预设: trinket_31		路径： [string "scripts/prefabs/trinkets.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: monstormmarker_debug		路径： [string "scripts/prefabs/moonstormmarker.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: spider_heal_target_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: halloweenpotion_bravery_large_buff		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
树液采集工具包			预设: quagmire_sapbucket		路径： [string "scripts/prefabs/quagmire_sapbucket.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_sapbucket")	
			inst.AnimState:SetBuild("quagmire_sapbucket")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
小路灯			预设: quagmire_lamp_short		路径： [string "scripts/prefabs/quagmire_lamp_post.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_lamp_short")	
			inst.AnimState:SetBuild("quagmire_lamp_short")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: spider_heal_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香彩虹糖豆			预设: jellybean_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "canlight", "spicedfood", "preparedfood", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_gym_speed_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_speed_build")	
			Anim路径 :  "anim/yotc_carrat_gym_speed.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: carnivaldecor_plant_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_plant")	
			inst.AnimState:SetBuild("carnivaldecor_plant")	
			Anim路径 :  "anim/carnivaldecor_plant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
玉米			预设: corn		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("corn")	
			inst.AnimState:SetBuild("corn")	
			Anim路径 :  "anim/corn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("weighable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: balloon_held_child		路径： [string "scripts/prefabs/balloon_held_child.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	使用的组件▼	
		
------------------------------------------------	
小皮弗娄牛			预设: babybeefalo		路径： [string "scripts/prefabs/babybeefalo.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "_health", "inspectable", "beefalo", "idle", "_combat", "locomotor", "nolight", "_follower", "herdmember", "animal", "sleeper", "baby"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo")	
			inst.AnimState:SetBuild("beefalo_baby_build")	
			Anim路径 :  "anim/beefalo_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("combat")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("burnable")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("growable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("eater")	
		inst:AddComponent("follower")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
龙蝇雕塑			预设: chesspiece_dragonfly		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_dragonfly_stone")	
			Anim路径 :  "anim/chesspiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("shadowchessroar")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
土地夯实器			预设: turfcraftingstation		路径： [string "scripts/prefabs/turfcraftingstation.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turfcraftingstation")	
			inst.AnimState:SetBuild("turfcraftingstation")	
			Anim路径 :  "anim/turfcraftingstation.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("prototyper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("craftingstation")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
壶装乐观混合剂			预设: halloweenpotion_health_large		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "potion", "_stackable", "BURNABLE_fuel", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_potions")	
			inst.AnimState:SetBuild("halloween_potions")	
			Anim路径 :  "anim/halloween_potions.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: bee_poof_big		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: boat_malbatross_mast_sink_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香芦笋汤			预设: asparagussoup_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
飞翼风帆套装			预设: mast_malbatross_item		路径： [string "scripts/prefabs/mast.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_accessory", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seafarer_mast_malbatross")	
			inst.AnimState:SetBuild("seafarer_mast_malbatross")	
			Anim路径 :  "anim/seafarer_mast_malbatross.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
 			预设: bundle_container		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_container", "bundle"}	
 	
	使用的组件▼	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
酿茄子			预设: stuffedeggplant		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_medium_9		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: mossling_spin_fx		路径： [string "scripts/prefabs/mossling_spin_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_race_finish_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_race_finish")	
			inst.AnimState:SetBuild("yotc_carrat_race_finish")	
			Anim路径 :  "anim/yotc_carrat_race_finish.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
奖票			预设: carnival_prizeticket		路径： [string "scripts/prefabs/carnival_prizeticket.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_prizeticket")	
			inst.AnimState:SetBuild("carnival_prizeticket")	
			Anim路径 :  "anim/carnival_prizeticket.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
浮堆			预设: waterplant_rock		路径： [string "scripts/prefabs/waterplant_rock.lua"]	
	Tags▼	
	{":", "inspectable", "waterplant", "waterplant_upgradeable", "MINE_workable", "ignorewalkableplatforms", "seastack", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle_plant")	
			inst.AnimState:SetBuild("barnacle_plant_colour_swaps")	
			Anim路径 :  "anim/barnacle_plant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("upgradeable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: firesuppressor_glow		路径： [string "scripts/prefabs/firesuppressor.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firefighter_glow")	
			inst.AnimState:SetBuild("firefighter_glow")	
			Anim路径 :  "anim/firefighter_glow.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: deer_ice_fx		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_ice_fx")	
			inst.AnimState:SetBuild("deer_ice_fx")	
			Anim路径 :  "anim/deer_ice_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
损坏的发条装置			预设: chessjunk1		路径： [string "scripts/prefabs/chessjunk.lua"]	
	Tags▼	
	{":", "repairable_gears", "mech", "inspectable", "chess", "HAMMER_workable", "workrepairable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("chessmonster_ruins")	
			inst.AnimState:SetBuild("chessmonster_ruins")	
			Anim路径 :  "anim/chessmonster_ruins.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("repairable")	
		
------------------------------------------------	
MISSING NAME			预设: firesplash_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鞋拔子			预设: trinket_23		路径： [string "scripts/prefabs/trinkets.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
暗夜剑			预设: nightsword		路径： [string "scripts/prefabs/nightsword.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "shadow", "shadow_item", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmaresword")	
			inst.AnimState:SetBuild("nightmaresword")	
			Anim路径 :  "anim/nightmaresword.zip"	
 	
	使用的组件▼	
		inst:AddComponent("weapon")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: coldfire_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("coldfire")	
			inst.AnimState:SetBuild("coldfire")	
			Anim路径 :  "anim/coldfire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_gym_stamina_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_stamina_build")	
			Anim路径 :  "anim/yotc_carrat_gym_stamina.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: cavelight_atrium		路径： [string "scripts/prefabs/cavelight.lua"]	
	Tags▼	
	{":", "fx", "sinkhole", "FROMNUM", "daylight", "batdestination", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "anim/cave_exit_lightsource.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hideout")	
		
------------------------------------------------	
MISSING NAME			预设: moon_altar_crown_break		路径： [string "scripts/prefabs/moon_altar_break.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_altar_crown_break")	
			inst.AnimState:SetBuild("moon_altar_crown_break")	
			Anim路径 :  "anim/moon_altar_crown_break.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: superjump_debris		路径： [string "scripts/prefabs/superjump_fx.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("player_superjump")	
			Anim路径 :  "anim/player_superjump.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: wall_stone_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wall_stone")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: fireball_hit_fx		路径： [string "scripts/prefabs/fireball_projectile.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("deer_fire_charge")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
天体宝球			预设: moonrockseed		路径： [string "scripts/prefabs/moonrockseed.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "nonpotatable", "irreplaceable", "prototyper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonrock_seed")	
			inst.AnimState:SetBuild("moonrock_seed")	
			Anim路径 :  "anim/moonrock_seed.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("prototyper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("moonrockseed._fx")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
小高脚鸟			预设: teenbird		路径： [string "scripts/prefabs/smallbird.lua"]	
	Tags▼	
	{":", "busy", "trader", "_health", "inspectable", "freezable", "companion", "teenbird", "smallbird", "_combat", "locomotor", "OMNI_eater", "nolight", "_follower", "_hunger", "character", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tallbird")	
			inst.AnimState:SetBuild("tallbird_teen_build")	
			Anim路径 :  "anim/ds_tallbird_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("growable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("trader")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("health")	
		inst:AddComponent("hunger")	
		inst:AddComponent("follower")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
战斗长矛			预设: spear_wathgrithr		路径： [string "scripts/prefabs/spear_wathgrithr.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "pointy", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spear_wathgrithr")	
			inst.AnimState:SetBuild("swap_spear_wathgrithr")	
			Anim路径 :  "anim/spear_wathgrithr.zip"	
 	
	使用的组件▼	
		inst:AddComponent("weapon")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
巨型洋葱			预设: onion_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_onion_build")	
			Anim路径 :  "anim/farm_plant_pumpkin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("propagator")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
不老表			预设: pocketwatch_heal		路径： [string "scripts/prefabs/pocketwatch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "pocketwatch_inactive", "inspectable", "pocketwatch_castfrominventory", "rechargeable", "pocketwatch_mountedcast", "pocketwatch", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch")	
			inst.AnimState:SetBuild("pocketwatch_marble")	
			Anim路径 :  "anim/pocketwatch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("rechargeable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("pocketwatch")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
冬季圣诞树			预设: winter_twiggytree		路径： [string "scripts/prefabs/winter_tree.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "event_trigger", "canlight", "decoratable", "structure", "winter_tree", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("twiggy_build")	
			Anim路径 :  "anim/wintertree_twiggy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("updatelight")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
暗影骑士			预设: shadow_knight		路径： [string "scripts/prefabs/shadowchesspieces.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "hostile", "_combat", "locomotor", "sanityaura", "shadowchesspiece"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadow_knight")	
			inst.AnimState:SetBuild("shadow_knight")	
			Anim路径 :  "anim/shadow_knight.zip"	
 	
	使用的组件▼	
		inst:AddComponent("epicscare")	
		inst:AddComponent("health")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("levelup")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: mushtree_medium_burntfx		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_med")	
			inst.AnimState:SetBuild("mushroom_tree_med")	
			Anim路径 :  "anim/mushroom_tree_med.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
甜西瓜冰棍			预设: watermelonicle_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: oldager_become_younger_front_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣果酱			预设: jammypreserves_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香鲜果可丽饼			预设: freshfruitcrepes_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香藤壶中细面			预设: barnaclinguine_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
启迪之冠			预设: alterguardianhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "gestaltprotection", "inspectable", "hat", "_container", "open_top_hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardianhat")	
			inst.AnimState:SetBuild("hat_alterguardian")	
			Anim路径 :  "anim/hat_alterguardian.zip"	
 	
	使用的组件▼	
		inst:AddComponent("preserver")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
黄昏旋转亮片			预设: oceanfishinglure_spinner_green		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_lure_spinner")	
			inst.AnimState:SetBuild("oceanfishing_lure_spinner")	
			Anim路径 :  "anim/oceanfishing_lure_spinner.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
淡水鱼			预设: pondfish		路径： [string "scripts/prefabs/pondfish.lua"]	
	Tags▼	
	{":", "meat", "pondfish", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "smallcreature", "fish", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fish")	
			inst.AnimState:SetBuild("fish")	
			Anim路径 :  "anim/fish.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("murderable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cookable")	
		inst:AddComponent("weighable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("onpickup")	
------------------------------------------------	
MISSING NAME			预设: winona_battery_low_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_battery_placement")	
			inst.AnimState:SetBuild("winona_battery_placement")	
			Anim路径 :  "anim/winona_battery_placement.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
鳗鱼料理			预设: unagi		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的酸橘汁腌鱼			预设: ceviche_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: grotto_waterfall_big		路径： [string "scripts/prefabs/grotto_waterfall_big.lua"]	
	Tags▼	
	{":", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_bigwaterfall")	
			inst.AnimState:SetBuild("moonglass_bigwaterfall")	
			Anim路径 :  "anim/moonglass_bigwaterfall.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: staff_castinglight_small		路径： [string "scripts/prefabs/staff_castinglight.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鱼类计重器			预设: trophyscale_fish		路径： [string "scripts/prefabs/trophyscale_fish.lua"]	
	Tags▼	
	{":", "inspectable", "trophyscale_fish", "HAMMER_workable", "trophyscale", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scale_o_matic")	
			inst.AnimState:SetBuild("scale_o_matic")	
			Anim路径 :  "anim/scale_o_matic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("trophyscale")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("onnewtrophy")	
------------------------------------------------	
MISSING NAME			预设: fossilizing_fx_1		路径： [string "scripts/prefabs/fossilized_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
荧光花			预设: stalker_bulb_double		路径： [string "scripts/prefabs/stalker_bulb.lua"]	
	Tags▼	
	{":", "stalkerbloom", "inspectable", "plant", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bulb_plant_double")	
			inst.AnimState:SetBuild("bulb_plant_double")	
			Anim路径 :  "anim/bulb_plant_double.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
红蘑菇树			预设: mushtree_medium		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "mushtree", "tree", "plant", "DIG_workable", "canlight", "stump", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_med")	
			inst.AnimState:SetBuild("mushroom_tree_med")	
			Anim路径 :  "anim/mushroom_tree_med.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("plantregrowth")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("timer")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
蒜香芝士蛋糕			预设: powcake_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "edible_VEGGIE", "badfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
甜太妃糖			预设: taffy_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "badfood", "canlight", "spicedfood", "preparedfood", "edible_GOODIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
烤小鱼块			预设: fishmeat_small_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "fishmeat", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fishmeat_small")	
			inst.AnimState:SetBuild("fishmeat_small")	
			Anim路径 :  "anim/fishmeat_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("spawnedfromhaunt")	
------------------------------------------------	
远古织影者雕塑			预设: chesspiece_stalker_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
------------------------------------------------	
千层面			预设: quagmire_food_039		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
大熔炉猪战士			预设: lavaarena_groundliftrocks		路径： [string "scripts/prefabs/lavaarena_groundlifts.lua"]	
	Tags▼	
	{":", "groundspike", "object", "hostile", "notarget", "stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: boat_item_collision		路径： [string "scripts/prefabs/boat.lua"]	
	Tags▼	
	{":", "CLASSIFIED", "NOBLOCK", "ignorewalkableplatforms"}	
 	
	使用的组件▼	
------------------------------------------------	
街灯			预设: quagmire_lamp_post		路径： [string "scripts/prefabs/quagmire_lamp_post.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_lamp_post")	
			inst.AnimState:SetBuild("quagmire_lamp_post")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: rockyherd		路径： [string "scripts/prefabs/rockyherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("herd")	
		
------------------------------------------------	
空瓶子			预设: messagebottleempty		路径： [string "scripts/prefabs/messagebottle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "waterproofer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bottle")	
			inst.AnimState:SetBuild("bottle")	
			Anim路径 :  "anim/bottle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("stackable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped_empty")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: pocketwatch_recall_marker		路径： [string "scripts/prefabs/pocketwatch.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_warp_marker")	
			inst.AnimState:SetBuild("pocketwatch_warp_marker")	
			Anim路径 :  "anim/pocketwatch_warp_marker.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
炸弹蘑菇			预设: mushroombomb		路径： [string "scripts/prefabs/mushroombomb.lua"]	
	Tags▼	
	{":", "inspectable", "explosive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroombomb")	
			inst.AnimState:SetBuild("mushroombomb")	
			Anim路径 :  "anim/mushroombomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: oceantree_ripples_normal		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_normal")	
			inst.AnimState:SetBuild("oceantree_normal")	
			Anim路径 :  "anim/oceantree_normal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的肉串			预设: kabobs_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: wanda_attack_pocketwatch_old_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蘑菇灯			预设: mushroom_light		路径： [string "scripts/prefabs/mushroom_light.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "HAMMER_workable", "canlight", "structure", "lamp", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_light")	
			inst.AnimState:SetBuild("mushroom_light")	
			Anim路径 :  "anim/mushroom_light.zip"	
 	
	使用的组件▼	
		inst:AddComponent("preserver")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("burntup")	
		inst:ListenForEvent("itemlose")	

------------------------------------------------	
MISSING NAME			预设: lavaarena_bloom1		路径： [string "scripts/prefabs/lavaarena_blooms.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_bloom"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")	
			Anim路径 :  "anim/lavaarena_heal_flowers_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
醍醐灌顶华彩			预设: battlesong_sanitygain		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "battlesong", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("battlesongs")	
			inst.AnimState:SetBuild("battlesongs")	
			Anim路径 :  "anim/battlesongs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("singable")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: atrium_light_back		路径： [string "scripts/prefabs/atrium_light.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_light")	
			inst.AnimState:SetBuild("atrium_light")	
			Anim路径 :  "anim/atrium_light.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜什锦干果			预设: trailmix_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蛛网岩			预设: spiderhole		路径： [string "scripts/prefabs/spiderhole.lua"]	
	Tags▼	
	{":", "cavedweller", "_health", "inspectable", "spiderden", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_mound")	
			inst.AnimState:SetBuild("spider_mound")	
			Anim路径 :  "anim/spider_mound.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("workable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("creepactivate")	
		inst:ListenForEvent("startquake")	
------------------------------------------------	
啜食者皮			预设: slurper_pelt		路径： [string "scripts/prefabs/slurperpelt.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_HORRIBLE", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slurper_pelt")	
			inst.AnimState:SetBuild("slurper_pelt")	
			Anim路径 :  "anim/slurper_pelt.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	

------------------------------------------------	
大烤架			预设: quagmire_grill		路径： [string "scripts/prefabs/quagmire_grill.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_grill")	
			inst.AnimState:SetBuild("quagmire_grill")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
橄榄球头盔			预设: footballhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("footballhat")	
			inst.AnimState:SetBuild("hat_football")	
			Anim路径 :  "anim/hat_football.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("armor")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: ocean_splash_med2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: oceanfishinghook_ripple		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_hook")	
			inst.AnimState:SetBuild("oceanfishing_hook")	
			Anim路径 :  "anim/oceanfishing_hook.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: portablecookpot_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_cook_pot")	
			inst.AnimState:SetBuild("portable_cook_pot")	
			Anim路径 :  "anim/portable_cook_pot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
暗影触手			预设: shadowtentacle		路径： [string "scripts/prefabs/shadowtentacle.lua"]	
	Tags▼	
	{":", "_health", "freezable", "invisible", "idle", "shadow", "_combat", "sanityaura", "notarget"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("tentacle_arm_black_build")	
			Anim路径 :  "anim/tentacle_arm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: madscience_lab_goop		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("madscience_lab")	
			inst.AnimState:SetBuild("madscience_lab")	
			Anim路径 :  "anim/madscience_lab.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
黄金铲子			预设: goldenshovel		路径： [string "scripts/prefabs/shovel.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "tool", "_equippable", "weapon", "DIG_tool"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goldenshovel")	
			inst.AnimState:SetBuild("goldenshovel")	
			Anim路径 :  "anim/goldenshovel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("tool")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
果酱			预设: quagmire_food_021		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
石头板甲			预设: lavaarena_armorheavy		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "marble", "hide_percentage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
格罗姆			预设: glommer		路径： [string "scripts/prefabs/glommer.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "_combat", "locomotor", "sanityaura", "_follower", "flying", "cattoyairborne", "ignorewalkableplatformdrowning", "sleeper", "glommer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("glommer")	
			inst.AnimState:SetBuild("glommer")	
			Anim路径 :  "anim/glommer.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("freezable")	
		inst:AddComponent("health")	
		inst:AddComponent("follower")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
月亮蘑菇树			预设: mushtree_moon		路径： [string "scripts/prefabs/mushtree_moon.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "FROMNUM", "mushtree", "tree", "plant", "CHOP_workable", "canlight", "shelter", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("mutatedmushroom_tree_build")	
			Anim路径 :  "anim/mushroom_tree_tall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("plantregrowth")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
------------------------------------------------	
MISSING NAME			预设: quagmire_coin_fx		路径： [string "scripts/prefabs/quagmire_coins.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
未使用			预设: oceanfishinglure_spoon_brown		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_lure_spoon")	
			inst.AnimState:SetBuild("oceanfishing_lure_spoon")	
			Anim路径 :  "anim/oceanfishing_lure_spoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
烤火鸡			预设: roastturkey		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "wintersfeastcookedfood", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("food_winters_feast_2019")	
			inst.AnimState:SetBuild("food_winters_feast_2019")	
			Anim路径 :  "anim/food_winters_feast_2019.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: waterstreak_burst		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
美味的龙虾			预设: wobster_sheller_dead_cooked		路径： [string "scripts/prefabs/wobster.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "fishmeat", "_stackable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_sheller")	
			Anim路径 :  "anim/lobster.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
浆果丛			预设: dug_berrybush2		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush2")	
			inst.AnimState:SetBuild("berrybush2")	
			Anim路径 :  "anim/berrybush2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香炖肉汤			预设: bonestew_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
沃姆伍德			预设: wormwood		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "plantkin", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "self_fertilizable", "waterplant_upgradeuser"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wilson")	
			Anim路径 :  "anim/player_idles.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("sandstormwatcher")	
		inst:AddComponent("colouradder")	
		inst:AddComponent("maprevealable")	
		inst:AddComponent("walkingplankuser")	
		inst:AddComponent("stormwatcher")	
		inst:AddComponent("moisture")	
		inst:AddComponent("propagator")	
		inst:AddComponent("distancetracker")	
		inst:AddComponent("hunger")	
		inst:AddComponent("sleepingbaguser")	
		inst:AddComponent("talker")	
		inst:AddComponent("playerlightningtarget")	
		inst:AddComponent("sanity")	
		inst:AddComponent("age")	
		inst:AddComponent("temperature")	
		inst:AddComponent("constructionbuilderuidata")	
		inst:AddComponent("playerinspectable")	
		inst:AddComponent("drownable")	
		inst:AddComponent("colourtweener")	
		inst:AddComponent("grue")	
		inst:AddComponent("freezable")	
		inst:AddComponent("fertilizable")	
		inst:AddComponent("skinner")	
		inst:AddComponent("walkableplatformplayer")	
		inst:AddComponent("builder")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("cookbookupdater")	
		inst:AddComponent("sheltered")	
		inst:AddComponent("steeringwheeluser")	
		inst:AddComponent("pinnable")	
		inst:AddComponent("trader")	
		inst:AddComponent("bundler")	
		inst:AddComponent("carefulwalker")	
		inst:AddComponent("hudindicatable")	
		inst:AddComponent("catcher")	
		inst:AddComponent("frostybreather")	
		inst:AddComponent("constructionbuilder")	
		inst:AddComponent("singingshelltrigger")	
		inst:AddComponent("foodaffinity")	
		inst:AddComponent("playervision")	
		inst:AddComponent("eater")	
		inst:AddComponent("timer")	
		inst:AddComponent("inkable")	
		inst:AddComponent("combat")	
		inst:AddComponent("plantregistryupdater")	
		inst:AddComponent("leader")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("embarker")	
		inst:AddComponent("giftreceiver")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("touchstonetracker")	
		inst:AddComponent("moonstormwatcher")	
		inst:AddComponent("areaaware")	
		inst:AddComponent("playeravatardata")	
		inst:AddComponent("grogginess")	
		inst:AddComponent("debuffable")	
		inst:AddComponent("workmultiplier")	
		inst:AddComponent("petleash")	
		inst:AddComponent("rider")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("wisecracker")	
		inst:AddComponent("spooked")	
		inst:AddComponent("birdattractor")	
		inst:AddComponent("attuner")	
		inst:AddComponent("bloomness")	
		
	使用的监听▼	
		inst:ListenForEvent("playerdied")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("startfreezing")	
		inst:ListenForEvent("mountwounded")	
		inst:ListenForEvent("actionfailed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("changearea")	
		inst:ListenForEvent("unequip")	
		inst:ListenForEvent("townportalteleport")	
		inst:ListenForEvent("stormlevel")	
		inst:ListenForEvent("digdiseasing")	
		inst:ListenForEvent("thorns")	
		inst:ListenForEvent("ghostdissipated")	
		inst:ListenForEvent("enableboatcamera")	
		inst:ListenForEvent("underleafcanopydirty")	
		inst:ListenForEvent("learncookbookrecipe")	
		inst:ListenForEvent("on_halloweenmoonpotion_failed")	
		inst:ListenForEvent("accomplishment_done")	
		inst:ListenForEvent("playeractivated")	
		inst:ListenForEvent("burnt")	
		inst:ListenForEvent("sharksounddirty")	
		inst:ListenForEvent("respawnfromghost")	
		inst:ListenForEvent("unpinned")	
		inst:ListenForEvent("ms_becameghost")	
		inst:ListenForEvent("repelled")	
		inst:ListenForEvent("done_embark_movement")	
		inst:ListenForEvent("onareaattackother")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("sheltered")	
		inst:ListenForEvent("localplayer._hermit_music")	
		inst:ListenForEvent("itemplanted")	
		inst:ListenForEvent("heargrue")	
		inst:ListenForEvent("onstartedfire")	
		inst:ListenForEvent("plantkilled")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("onchangecanopyzone")	
		inst:ListenForEvent("ghostdelta")	
		inst:ListenForEvent("ms_respawnedfromghost")	
		inst:ListenForEvent("takeoversizedpicture")	
		inst:ListenForEvent("setowner")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("learnfertilizer")	
		inst:ListenForEvent("lightningdamageavoided")	
		inst:ListenForEvent("unevengrounddetected")	
		inst:ListenForEvent("coveredinbees")	
		inst:ListenForEvent("startoverheating")	
		inst:ListenForEvent("itemranout")	
		inst:ListenForEvent("startfiredamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("learncookbookstats")	
		inst:ListenForEvent("killed")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("working")	
		inst:ListenForEvent("wonteatfood")	
		inst:ListenForEvent("snared")	
		inst:ListenForEvent("dropitem")	
		inst:ListenForEvent("picksomething")	
		inst:ListenForEvent("accomplishment")	
		inst:ListenForEvent("resistedgrue")	
		inst:ListenForEvent("ms_closepopup")	
		inst:ListenForEvent("attackedbygrue")	
		inst:ListenForEvent("wormholespit")	
		inst:ListenForEvent("makeplayerghost")	
		inst:ListenForEvent("inventoryfull")	
		inst:ListenForEvent("usedtouchstone")	
		inst:ListenForEvent("equip")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("insufficientfertilizer")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("foodbuffdetached")	
		inst:ListenForEvent("foodbuffattached")	
		inst:ListenForEvent("hungrybuild")	
		inst:ListenForEvent("encumberedwalking")	
		inst:ListenForEvent("huntlosttrail")	
		inst:ListenForEvent("on_standing_on_new_leak")	
		inst:ListenForEvent("onpresink")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("pickdiseasing")	
		inst:ListenForEvent("huntbeastnearby")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("enablemovementprediction")	
		inst:ListenForEvent("localplayer._winters_feast_music")	
		inst:ListenForEvent("spooked")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("newactiveitem")	
	SG = 有▼	
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_plain8		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: researchlab2_pod_fx		路径： [string "scripts/prefabs/scienceprototyper.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab2_pod_fx")	
			inst.AnimState:SetBuild("researchlab2")	
			Anim路径 :  "anim/dynamic/researchlab2_pod.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: yotb_sewingmachine_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_beefalo_sewingmachine")	
			Anim路径 :  "anim/yotb_beefalo_sewingmachine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
卵石路			预设: turf_road		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf")	
			inst.AnimState:SetBuild("turf")	
			Anim路径 :  "anim/turf.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: carnivalgame_herding_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_herding_station")	
			inst.AnimState:SetBuild("carnivalgame_herding_station")	
			Anim路径 :  "anim/carnivalgame_herding_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蒜香蜜汁卤肉			预设: honeynuggets_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "honeyed", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: sinkhole_spawn_fx_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: reticuleaoesummonping		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: petrified_tree_fx_tall		路径： [string "scripts/prefabs/petrify_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: shovel_dirt		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: boat_player_collision		路径： [string "scripts/prefabs/boat.lua"]	
	Tags▼	
	{":", "CLASSIFIED", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnival_confetti_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
铁栅栏			预设: quagmire_parkspike_short		路径： [string "scripts/prefabs/quagmire_parkspike.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
月亮虹吸器			预设: moon_device_pillar		路径： [string "scripts/prefabs/moon_device.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moon_device")	
			Anim路径 :  "anim/moon_device.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: archive_switch_base		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_switch_ground")	
			inst.AnimState:SetBuild("archive_switch_ground")	
			Anim路径 :  "anim/archive_switch_ground.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("arhivepoweron")	
		inst:ListenForEvent("arhivepoweroff")	

------------------------------------------------	
MISSING NAME			预设: spellmasterybuff		路径： [string "scripts/prefabs/spellmasterybuff.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_arcane_orb")	
			inst.AnimState:SetBuild("lavaarena_arcane_orb")	
			Anim路径 :  "anim/lavaarena_arcane_orb.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
种子包			预设: yotc_seedpacket		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_seedpacket")	
			inst.AnimState:SetBuild("yotc_seedpacket")	
			Anim路径 :  "anim/yotc_seedpacket.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("unwrappable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的曼德拉草汤			预设: mandrakesoup_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_groundtargetblocker		路径： [string "scripts/prefabs/lavaarena_crowdstand.lua"]	
	Tags▼	
	{":", "fx", "groundtargetblocker"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蔚蓝羽浮标			预设: oceanfishingbobber_robin_winter_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_robin_winter_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
蚁狮			预设: antlion		路径： [string "scripts/prefabs/antlion.lua"]	
	Tags▼	
	{":", "__combat", "trader", "inspectable", "freezable", "idle", "antlion", "noepicmusic", "antlion_sinkhole_blocker", "epic", "__health", "largecreature", "sleeper", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("antlion")	
			inst.AnimState:SetBuild("antlion_build")	
			Anim路径 :  "anim/antlion_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sinkholespawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("freezable")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("trader")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("newcombattarget")	
	SG = 有▼	
------------------------------------------------	
红羽浮标			预设: oceanfishingbobber_robin_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_robin_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	

------------------------------------------------	
MISSING NAME			预设: lavaarena_spectator		路径： [string "scripts/prefabs/lavaarena_crowdstand.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: spider_summoned_buff		路径： [string "scripts/prefabs/spider_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: mermhouse_crafted_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mermhouse_crafted")	
			inst.AnimState:SetBuild("mermhouse_crafted")	
			Anim路径 :  "anim/mermhouse_crafted.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
白菜卷			预设: wintercooking_cabbagerolls		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: reticuleaoecctarget		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: alterguardian_summon_fx		路径： [string "scripts/prefabs/alterguardian_summon_fx.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_summon_fx")	
			inst.AnimState:SetBuild("alterguardian_summon_fx")	
			Anim路径 :  "anim/alterguardian_summon_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("endloop")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_fossilizedebris3		路径： [string "scripts/prefabs/lavaarena_fossilizing.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_fossilizedebris"}	
 	
	使用的组件▼	
		
------------------------------------------------	
农产品秤			预设: trophyscale_oversizedveggies		路径： [string "scripts/prefabs/trophyscale_oversizedveggie..."]	
	Tags▼	
	{":", "inspectable", "trophyscale_oversizedveggies", "HAMMER_workable", "trophyscale", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trophyscale_oversizedveggies")	
			inst.AnimState:SetBuild("trophyscale_oversizedveggies")	
			Anim路径 :  "anim/trophyscale_oversizedveggies.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("trophyscale")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("onnewtrophy")	
------------------------------------------------	
MISSING NAME			预设: torchfire_pronged		路径： [string "scripts/prefabs/torchfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: oldager_become_older_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: turfcraftingstation_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turfcraftingstation")	
			inst.AnimState:SetBuild("turfcraftingstation")	
			Anim路径 :  "anim/turfcraftingstation.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蜜汁火腿			预设: honeyham		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "honeyed", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的酿茄子			预设: stuffedeggplant_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
土豆煎饼			预设: quagmire_food_007		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
重生护符			预设: amulet		路径： [string "scripts/prefabs/amulet.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "resurrector", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("amulets")	
			inst.AnimState:SetBuild("amulets")	
			Anim路径 :  "anim/amulets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
石榴			预设: pomegranate		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pomegranate")	
			inst.AnimState:SetBuild("pomegranate")	
			Anim路径 :  "anim/pomegranate.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("weighable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
辣叶肉糕			预设: leafloaf_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: mastupgrade_lightningrod		路径： [string "scripts/prefabs/mastupgrade_lightningrod.lu..."]	
	Tags▼	
	{":", "DECOR", "NOCLICK", "lightningrod"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mastupgrade_lightningrod_item")	
			inst.AnimState:SetBuild("mastupgrade_lightningrod")	
			Anim路径 :  "anim/mastupgrade_lightningrod.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("mast_burnt")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("lightningstrike")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
钟表匠工具			预设: pocketwatch_dismantler		路径： [string "scripts/prefabs/pocketwatch_dismantler.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_dismantler")	
			inst.AnimState:SetBuild("pocketwatch_dismantler")	
			Anim路径 :  "anim/pocketwatch_dismantler.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("pocketwatch_dismantler")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
塔马利			预设: tamales		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "wintersfeastcookedfood", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("food_winters_feast_2019")	
			inst.AnimState:SetBuild("food_winters_feast_2019")	
			Anim路径 :  "anim/food_winters_feast_2019.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
巨型土豆			预设: potato_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_potato")	
			Anim路径 :  "anim/farm_plant_potato.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("propagator")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: atrium_gate_pulsesfx		路径： [string "scripts/prefabs/atrium_gate_pulsesfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: reticuleaoesmallhostiletarget		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜水果圣代			预设: fruitmedley_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
甲板照明灯			预设: mastupgrade_lamp_item		路径： [string "scripts/prefabs/mastupgrade_lamp.lua"]	
	Tags▼	
	{":", "_inventoryitem", "mast_upgrader", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mastupgrade_lamp_item")	
			inst.AnimState:SetBuild("mastupgrade_lamp")	
			Anim路径 :  "anim/mastupgrade_lamp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("upgrader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: dug_grass_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grass")	
			inst.AnimState:SetBuild("grass1")	
			Anim路径 :  "anim/grass.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
水球			预设: waterballoon		路径： [string "scripts/prefabs/waterprojectiles.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "watersource", "projectile", "_stackable", "locomotor", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("waterballoon")	
			inst.AnimState:SetBuild("waterballoon")	
			Anim路径 :  "anim/waterballoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("equippable")	
		inst:AddComponent("reticule")	
		inst:AddComponent("watersource")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("weapon")	
		inst:AddComponent("complexprojectile")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	

------------------------------------------------	
伯尼			预设: lavaarena_bernie		路径： [string "scripts/prefabs/lavaarena_bernie.lua"]	
	Tags▼	
	{":", "companion", "smallcreature", "notarget", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bernie_build")	
			Anim路径 :  "anim/bernie.zip"	
 	
	使用的组件▼	
		inst:AddComponent("revivablecorpse")	
		
------------------------------------------------	
种下的茄子种子			预设: farm_plant_eggplant		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "farm_plant_eggplant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_eggplant_build")	
			Anim路径 :  "anim/farm_plant_potato.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
MISSING NAME			预设: weregoose_splash_med1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣花式回旋块茎			预设: potatotornado_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: farmrock		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
炖肉汤			预设: bonestew		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	

------------------------------------------------	
果冻卷			预设: quagmire_food_022		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: gargoyle_werepigatk_fx		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: campfire_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("campfire")	
			inst.AnimState:SetBuild("campfire")	
			Anim路径 :  "anim/campfire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
胡萝卜蛋糕			预设: quagmire_food_023		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: deerclopswarning_lvl2		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
检查点			预设: yotc_carrat_race_checkpoint		路径： [string "scripts/prefabs/yotc_carrat_race_checkpoint..."]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "yotc_racecheckpoint", "canlight", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_race_checkpoint")	
			inst.AnimState:SetBuild("yotc_carrat_race_checkpoint")	
			Anim路径 :  "anim/yotc_carrat_race_checkpoint.zip"	
 	
	使用的组件▼	
		inst:AddComponent("deployhelper")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("yotc_racer_at_checkpoint")	
		inst:ListenForEvent("yotc_race_over")	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: cointosscastfx_mount		路径： [string "scripts/prefabs/staffcastfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cointosscast_fx")	
			Anim路径 :  "anim/mount_cointosscast_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: quagmire_salting_bowl_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
球状光虫			预设: lightflier		路径： [string "scripts/prefabs/lightflier.lua"]	
	Tags▼	
	{":", "_inventoryitem", "lightbattery", "VEGGIE_eater", "cavedweller", "formation_lightflier", "_health", "inspectable", "FROMNUM", "freezable", "idle", "insect", "small_livestock", "smallcreature", "_stackable", "_combat", "locomotor", "NET_workable", "nolight", "_follower", "flying", "show_spoilage", "ignorewalkableplatformdrowning", "sleeper", "lightflier", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lightflier")	
			inst.AnimState:SetBuild("lightflier")	
			Anim路径 :  "anim/lightflier.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("formationfollower")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("follower")	
		inst:AddComponent("workable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("freezable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("tradable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("stackable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("teleported")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
鸽子			预设: quagmire_pigeon		路径： [string "scripts/prefabs/birds.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "_health", "inspectable", "SEEDS_eater", "freezable", "stunnedbybomb", "idle", "small_livestock", "smallcreature", "quagmire_pigeon", "_combat", "locomotor", "nolight", "show_spoilage", "cookable", "flight", "likewateroffducksback", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crow")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "anim/crow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("occupier")	
		inst:AddComponent("propagator")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("cookable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("eater")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: arrowsign_post_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_arrow_post")	
			inst.AnimState:SetBuild("sign_arrow_post")	
			Anim路径 :  "anim/sign_arrow_post.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
辣素食堡			预设: leafymeatburger_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
黏土猎犬			预设: clayhound		路径： [string "scripts/prefabs/hound.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "freezable", "scarytooceanprey", "clay", "noattack", "hostile", "_combat", "locomotor", "canbestartled", "sanityaura", "scarytoprey", "_follower", "notarget", "hound"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("clayhound")	
			inst.AnimState:SetBuild("clayhound")	
			Anim路径 :  "anim/clayhound.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("follower")	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("eyeflamesdirty")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("startfollowing")	
	SG = 有▼	
------------------------------------------------	
木门			预设: fence_gate		路径： [string "scripts/prefabs/fence.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "standingactivation", "door", "HAMMER_workable", "_combat", "alignwall", "canlight", "wall", "inactive", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("build:")	
			inst.AnimState:SetBuild("Anim")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("workable")	
		inst:AddComponent("activatable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
蜂王			预设: beequeen		路径： [string "scripts/prefabs/beequeen.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "FROMNUM", "freezable", "bee", "idle", "insect", "hostile", "noepicmusic", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "nolight", "flying", "largecreature", "ignorewalkableplatformdrowning", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bee_queen_build")	
			Anim路径 :  "anim/bee_queen_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("grouptargeter")	
		inst:AddComponent("propagator")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("burnable")	
		inst:AddComponent("epicscare")	
		inst:AddComponent("healthtrigger")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("timer")	
		inst:AddComponent("commander")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onmissother")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("healthdelta")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
烤大肉			预设: cookedmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat")	
			inst.AnimState:SetBuild("meat")	
			Anim路径 :  "anim/meat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("spawnedfromhaunt")	
------------------------------------------------	
月光玻璃			预设: grotto_moonglass_1		路径： [string "scripts/prefabs/grotto_pool_moonglass.lua"]	
	Tags▼	
	{":", "moonglass", "MINE_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_bigwaterfall")	
			inst.AnimState:SetBuild("moonglass_bigwaterfall")	
			Anim路径 :  "anim/moonglass_bigwaterfall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
便携研磨器			预设: portableblender		路径： [string "scripts/prefabs/portableblender.lua"]	
	Tags▼	
	{":", "inspectable", "mastercookware", "HAMMER_workable", "canlight", "structure", "prototyper", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_blender")	
			inst.AnimState:SetBuild("portable_blender")	
			Anim路径 :  "anim/portable_blender.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("portablestructure")	
		inst:AddComponent("prototyper")	
		
------------------------------------------------	
石虾			预设: rocky		路径： [string "scripts/prefabs/rocky.lua"]	
	Tags▼	
	{":", "trader", "_health", "inspectable", "idle", "_inventory", "_combat", "locomotor", "_follower", "rocky", "ELEMENTAL_eater", "herdmember", "character", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rocky")	
			inst.AnimState:SetBuild("rocky")	
			Anim路径 :  "anim/rocky.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("eater")	
		inst:AddComponent("health")	
		inst:AddComponent("inventory")	
		inst:AddComponent("follower")	
		inst:AddComponent("scaler")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: wanda_attack_pocketwatch_normal_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
洞穴岩石地皮			预设: turf_underrock		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf")	
			inst.AnimState:SetBuild("turf")	
			Anim路径 :  "anim/turf.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
圣诞树墩			预设: winter_treestand		路径： [string "scripts/prefabs/winter_treestand.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "winter_treestand", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wintertree_build")	
			Anim路径 :  "anim/wintertree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("plantwintertreeseed")	
------------------------------------------------	
MISSING NAME			预设: attune_in_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_center		路径： [string "scripts/prefabs/lavaarena_center.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
天体英雄			预设: alterguardian_phase2		路径： [string "scripts/prefabs/alterguardian_phase2.lua"]	
	Tags▼	
	{":", "mech", "monster", "_health", "inspectable", "FROMNUM", "freezable", "idle", "hostile", "noepicmusic", "_combat", "locomotor", "brightmareboss", "sanityaura", "epic", "scarytoprey", "soulless", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_phase2")	
			inst.AnimState:SetBuild("alterguardian_phase2")	
			Anim路径 :  "anim/alterguardian_phase2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("teleportedoverride")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("timer")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("phasetransition")	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
节庆鱼料理			预设: wintercooking_festivefish		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cavelightmoon_tiny		路径： [string "scripts/prefabs/cavelightmoon.lua"]	
	Tags▼	
	{":", "fx", "sinkhole", "daylight", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "anim/cave_exit_lightsource.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香西瓜冰棍			预设: watermelonicle_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: cavelightmoon		路径： [string "scripts/prefabs/cavelightmoon.lua"]	
	Tags▼	
	{":", "fx", "sinkhole", "FROMNUM", "daylight", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "anim/cave_exit_lightsource.zip"	
 	
	使用的组件▼	
		inst:AddComponent("spawner")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("playerprox")	
		
------------------------------------------------	
避雷针			预设: lightning_rod		路径： [string "scripts/prefabs/lightningrod.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "structure", "lightningrod", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lightning_rod")	
			inst.AnimState:SetBuild("lightning_rod")	
			Anim路径 :  "anim/lightning_rod.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("lightningstrike")	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
浮夸狮子鱼			预设: oceanfish_medium_3_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_3")	
			Anim路径 :  "anim/oceanfish_medium.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("murderable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("weighable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: eye_charge		路径： [string "scripts/prefabs/eye_charge.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeball_turret_attack")	
			inst.AnimState:SetBuild("eyeball_turret_attack")	
			Anim路径 :  "anim/eyeball_turret_attack.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	

------------------------------------------------	
失败料理			预设: quagmire_food_bowl_goop		路径： [string "scripts/prefabs/quagmire_food_burnt.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "overcooked", "show_spoiled"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: oceantree_ripples_tall		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_tall")	
			inst.AnimState:SetBuild("oceantree_tall")	
			Anim路径 :  "anim/oceantree_tall.zip"	
 	
	使用的组件▼	
------------------------------------------------	
洋葱汤			预设: quagmire_food_054		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
叶肉糕			预设: leafloaf		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food4")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
孵化中的高脚鸟蛋			预设: tallbirdegg_cracked		路径： [string "scripts/prefabs/tallbirdegg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "tallbirdegg", "cattoy", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("egg")	
			inst.AnimState:SetBuild("tallbird_egg")	
			Anim路径 :  "anim/tallbird_egg.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("hatchable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cookable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: oceantree_pillar_leaves		路径： [string "scripts/prefabs/oceantree_pillar.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceantree_pillar_small_build1")	
			Anim路径 :  "anim/oceantree_pillar_small.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_fancy8		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_creature_teleport_smoke_fx_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mining_ice_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
妈妈最爱的茶杯			预设: lost_toy_14		路径： [string "scripts/prefabs/lost_toys.lua"]	
	Tags▼	
	{":", "inspectable", "haunted"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("colourtweener")	
		
------------------------------------------------	
MISSING NAME			预设: archive_resonator_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_resonator")	
			inst.AnimState:SetBuild("archive_resonator")	
			Anim路径 :  "anim/archive_resonator.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: spider_mutate_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
粗壮常青树			预设: quagmire_evergreen_stump		路径： [string "scripts/prefabs/quagmire_evergreen.lua"]	
	Tags▼	
	{":", "tree", "plant", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_short")	
			inst.AnimState:SetBuild("evergreen_new_2")	
			Anim路径 :  "anim/evergreen_short_normal.zip"	
 	
	使用的组件▼	

------------------------------------------------	
盐架			预设: quagmire_salt_rack_item		路径： [string "scripts/prefabs/quagmire_salt_rack.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_pot_hanger")	
			inst.AnimState:SetBuild("quagmire_pot_hanger")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnivaldecor_eggride1_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride1")	
			inst.AnimState:SetBuild("carnivaldecor_eggride1")	
			Anim路径 :  "anim/carnivaldecor_eggride1.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_shield_buff		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: weregoose_splash_less2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
烤小肉			预设: cookedsmallmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_small")	
			inst.AnimState:SetBuild("meat_small")	
			Anim路径 :  "anim/meat_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("spawnedfromhaunt")	

------------------------------------------------	
MISSING NAME			预设: rhinodrill_fossilized_break_fx_right		路径： [string "scripts/prefabs/lavaarena_rhinodrill.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("build:")	
			inst.AnimState:SetBuild("anim:")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: archive_lockbox_player_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: squid_ink_player_fx		路径： [string "scripts/prefabs/squid.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("squid_inked")	
			Anim路径 :  "anim/squid_inked.zip"	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: redlanternlight		路径： [string "scripts/prefabs/redlantern.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
金锦鲤			预设: oceanfish_medium_7_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_7")	
			Anim路径 :  "anim/oceanfish_medium.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("murderable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("weighable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_bloom3		路径： [string "scripts/prefabs/lavaarena_blooms.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_bloom"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")	
			Anim路径 :  "anim/lavaarena_heal_flowers_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: dummytarget		路径： [string "scripts/prefabs/dummytarget.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "_combat", "debuffable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilsonstatue")	
			inst.AnimState:SetBuild("wilsonstatue")	
			Anim路径 :  "anim/wilsonstatue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bloomer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("colouradder")	
		inst:AddComponent("debuffable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("healthdelta")	
------------------------------------------------	
克劳斯			预设: klaus		路径： [string "scripts/prefabs/klaus.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "FROMNUM", "freezable", "idle", "hostile", "noepicmusic", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "nolight", "deergemresistance", "largecreature", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("klaus")	
			inst.AnimState:SetBuild("klaus_build")	
			Anim路径 :  "anim/klaus_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("grouptargeter")	
		inst:AddComponent("propagator")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("freezable")	
		inst:AddComponent("epicscare")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("timer")	
		inst:AddComponent("healthtrigger")	
		inst:AddComponent("commander")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: icespike_fx_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: snowball		路径： [string "scripts/prefabs/waterprojectiles.lua"]	
	Tags▼	
	{":", "projectile", "locomotor", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firefighter_projectile")	
			inst.AnimState:SetBuild("firefighter_projectile")	
			Anim路径 :  "anim/firefighter_projectile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
MISSING NAME			预设: shadow_shield5		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
金锦鲤			预设: oceanfish_medium_7		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "OMNI_eater", "herd_oceanfish_medium_7", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_7")	
			Anim路径 :  "anim/oceanfish_medium.zip"	
 	
	使用的组件▼	
		inst:AddComponent("weighable")	
		inst:AddComponent("eater")	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("timer")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
	SG = 有▼	
------------------------------------------------	
海花冠			预设: kelphat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("kelphat")	
			inst.AnimState:SetBuild("hat_kelp")	
			Anim路径 :  "anim/hat_kelp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("forcecompostable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_spawnerdecor_fx_1		路径： [string "scripts/prefabs/lavaarena_creature_spawn_fx..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: reticuleaoefriendlytarget		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
月蛾翅膀			预设: moonbutterflywings		路径： [string "scripts/prefabs/moonbutterflywings.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonbutterfly_wings")	
			inst.AnimState:SetBuild("moonbutterfly_wings")	
			Anim路径 :  "anim/moonbutterfly_wings.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
比宾卡米糕			预设: wintercooking_bibingka		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
成熟石果			预设: rock_avocado_fruit_ripe		路径： [string "scripts/prefabs/rock_avocado_fruit.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "edible_VEGGIE", "canlight", "cookable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_fruit_build")	
			Anim路径 :  "anim/rock_avocado_fruit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: staffcastfx_mount		路径： [string "scripts/prefabs/staffcastfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("staff")	
			Anim路径 :  "anim/staff.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
耕作先驱帽			预设: plantregistryhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "plantinspector", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plantregistryhat")	
			inst.AnimState:SetBuild("hat_plantregistry")	
			Anim路径 :  "anim/hat_plantregistry.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("useableitem")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
番茄种子			预设: tomato_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "deployedfarmplant", "edible_SEEDS", "_stackable", "canlight", "cookable", "deployable", "oceanfishing_lure", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_seeds")	
			inst.AnimState:SetBuild("farm_plant_seeds")	
			Anim路径 :  "anim/farm_plant_seeds.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("farmplantable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("tradable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("plantable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: halloween_firepuff_cold_3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: splash_green_small		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鱼			预设: fish		路径： [string "scripts/prefabs/fish.lua"]	
	Tags▼	
	{":", "meat", "pondfish", "_inventoryitem", "edible_MEAT", "inspectable", "dryable", "_stackable", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fish")	
			inst.AnimState:SetBuild("fish")	
			Anim路径 :  "anim/fish.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("dryable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("cookable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("onpickup")	
------------------------------------------------	
MISSING NAME			预设: trap_bramble_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trap_bramble")	
			inst.AnimState:SetBuild("trap_bramble")	
			Anim路径 :  "anim/trap_bramble.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: buff_moistureimmunity		路径： [string "scripts/prefabs/foodbuffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
“月亮” 雕塑			预设: chesspiece_moon		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_moon_marble")	
			Anim路径 :  "anim/chesspiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("shadowchessroar")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
小木牌			预设: minisign_drawn		路径： [string "scripts/prefabs/minisign.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_mini")	
			inst.AnimState:SetBuild("sign_mini")	
			Anim路径 :  "anim/sign_mini.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("drawable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
金丝雀			预设: canary_poisoned		路径： [string "scripts/prefabs/canary_poisoned.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "_health", "inspectable", "freezable", "sickness", "idle", "small_livestock", "smallcreature", "canary", "_combat", "nolight", "show_spoilage", "untrappable", "stale"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("canary")	
			inst.AnimState:SetBuild("canary_build")	
			Anim路径 :  "anim/canary.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("freeze")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
水晶头饰			预设: lavaarena_rechargerhat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: crabking_geyserspawner		路径： [string "scripts/prefabs/crabking.lua"]	
	Tags▼	
	{":", "fx", "crabking_spellgenerator", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("age")	
		
	使用的监听▼	
		inst:ListenForEvent("endspell")	
		inst:ListenForEvent("setowner")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
硬物浮标			预设: oceanfishingbobber_oval		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_sporty_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
捕虫网			预设: bugnet		路径： [string "scripts/prefabs/bugnet.lua"]	
	Tags▼	
	{":", "_inventoryitem", "NET_tool", "inspectable", "tool", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bugnet")	
			inst.AnimState:SetBuild("swap_bugnet")	
			Anim路径 :  "anim/bugnet.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("tool")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
制图桌			预设: cartographydesk		路径： [string "scripts/prefabs/cartography_prototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cartography_desk")	
			inst.AnimState:SetBuild("cartography_desk")	
			Anim路径 :  "anim/cartography_desk.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: weremoose_revert_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
索耶			预设: pigelite4		路径： [string "scripts/prefabs/pigelite.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "pig", "minigame_participator", "idle", "_inventory", "noepicmusic", "_combat", "locomotor", "scarytoprey", "nolight", "pigelite", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("pig_guard_build")	
			Anim路径 :  "anim/ds_pig_elite.zip"	
 	
	使用的组件▼	
		inst:AddComponent("minigame_participator")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("talker")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inventory")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("squadmember")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("unequip")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("equip")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("teleported")	
		inst:ListenForEvent("ms_joinsquad_pigkingelite4")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: abigail_retaliation		路径： [string "scripts/prefabs/abigail.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_shield")	
			inst.AnimState:SetBuild("abigail_shield")	
			Anim路径 :  "anim/abigail_shield.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
悬蛛网			预设: dropperweb		路径： [string "scripts/prefabs/dropperweb.lua"]	
	Tags▼	
	{":", "cavedweller", "_health", "spiderden"}	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("health")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("creepactivate")	
------------------------------------------------	
甜蛙腿三明治			预设: frogglebunwich_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
指南针			预设: compass		路径： [string "scripts/prefabs/compass.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "compass", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("compass")	
			inst.AnimState:SetBuild("compass")	
			Anim路径 :  "anim/compass.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("weapon")	
		inst:AddComponent("fueled")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
战车雕塑			预设: chesspiece_rook		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "event_trigger", "HAMMER_workable", "chess_moonevent", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_rook_stone")	
			Anim路径 :  "anim/chesspiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("shadowchessroar")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
辣蘑菇蛋糕			预设: shroomcake_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "edible_GOODIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
带电的羊奶			预设: goatmilk		路径： [string "scripts/prefabs/goatmilk.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "_stackable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goatmilk")	
			inst.AnimState:SetBuild("goatmilk")	
			Anim路径 :  "anim/goatmilk.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
远古月亮雕像			预设: archive_moon_statue		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":", "inspectable", "dustable", "FROMNUM", "statue", "MINE_workable", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_moon_statue")	
			inst.AnimState:SetBuild("archive_moon_statue")	
			Anim路径 :  "anim/archive_moon_statue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
种下的脆籽荚			预设: farm_plant_durian		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "farm_plant_durian", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_durian_build")	
			Anim路径 :  "anim/farm_plant_pepper.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
蚊子血囊			预设: mosquitosack		路径： [string "scripts/prefabs/mosquitosack.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "fillable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bladder")	
			inst.AnimState:SetBuild("bladder")	
			Anim路径 :  "anim/bladder.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("fillable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("healer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
绳子			预设: rope		路径： [string "scripts/prefabs/rope.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rope")	
			inst.AnimState:SetBuild("rope")	
			Anim路径 :  "anim/rope.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蜂王冠			预设: hivehat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "regal", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hivehat")	
			inst.AnimState:SetBuild("hat_hive")	
			Anim路径 :  "anim/hat_hive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("armor")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: battlesong_fireresistance_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: shadow_shield2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
恶魔花瓣			预设: petals_evil		路径： [string "scripts/prefabs/petals_evil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "BURNABLE_fuel", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flower_petals_evil")	
			inst.AnimState:SetBuild("flower_petals_evil")	
			Anim路径 :  "anim/flower_petals_evil.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("spawnedfromhaunt")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: deer_ice_charge		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_ice_charge")	
			inst.AnimState:SetBuild("deer_ice_charge")	
			Anim路径 :  "anim/deer_ice_charge.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: balloonparty_buff		路径： [string "scripts/prefabs/balloonparty.lua"]	
	Tags▼	
	{":", "confetti_buff", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	

------------------------------------------------	
红色马克硬币			预设: quagmire_coin3		路径： [string "scripts/prefabs/quagmire_coins.lua"]	
	Tags▼	
	{":", "quagmire_coin"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
未激活天体贡品			预设: moon_altar_crown		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "work_moon_altar", "nonpotatable", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_altar_crownpiece")	
			Anim路径 :  "anim/moon_altar_pieces.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("repairer")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("calling_moon_relics")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
友好果蝇			预设: friendlyfruitfly		路径： [string "scripts/prefabs/fruitfly.lua"]	
	Tags▼	
	{":", "busy", "_health", "inspectable", "freezable", "insect", "_combat", "small", "locomotor", "sanityaura", "nolight", "_follower", "flying", "cattoyairborne", "ignorewalkableplatformdrowning", "sleeper", "friendlyfruitfly"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fruitfly")	
			inst.AnimState:SetBuild("fruitfly_good")	
			Anim路径 :  "anim/fruitfly.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("follower")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
洞穴蜘蛛			预设: spider_hider		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "halloweenmoonmutable", "show_spoilage", "spider_hider", "drop_inventory_onmurder", "sleeper", "eatsrawmeat", "spider", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_hider")	
			inst.AnimState:SetBuild("DS_spider_caves")	
			Anim路径 :  "anim/ds_spider_caves.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("halloweenmoonmutable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("trader")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("startleashing")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("stopleashing")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	

------------------------------------------------	
奶油蘑菇汤			预设: quagmire_food_049		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: honey_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
腐烂物			预设: spoiled_food		路径： [string "scripts/prefabs/spoiledfood.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "tile_deploy", "inspectable", "selfstacker", "icebox_valid", "_stackable", "BURNABLE_fuel", "badfood", "fertilizer", "canlight", "fertilizerresearchable", "show_spoiled", "saltbox_valid", "deployable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("spoiled_food")	
			Anim路径 :  "anim/spoiled_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("selfstacker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("smotherer")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("tradable")	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("fertilizer")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
种下的土豆种子			预设: farm_plant_potato		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "farm_plant_potato", "DIG_workable", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_potato")	
			Anim路径 :  "anim/farm_plant_potato.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
菌类地皮			预设: turf_fungus_red		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf")	
			inst.AnimState:SetBuild("turf")	
			Anim路径 :  "anim/turf.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的无花果意面			预设: figatoni_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
                          Failed to spawn	global	
------------------------------------------------	
大理石芽			预设: marblebean_sapling		路径： [string "scripts/prefabs/planted_tree.lua"]	
	Tags▼	
	{":", "marbleshrub", "inspectable", "DIG_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marblebean")	
			inst.AnimState:SetBuild("marblebean")	
			Anim路径 :  "anim/marblebean.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("timer")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: carnival_seedpacket_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜蜜汁卤肉			预设: honeynuggets_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "honeyed", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
西瓜帽			预设: watermelonhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "icebox_valid", "HASHEATER", "waterproofer", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("watermelonhat")	
			inst.AnimState:SetBuild("hat_watermelon")	
			Anim路径 :  "anim/hat_watermelon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("waterproofer")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
叶肉			预设: plantmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "_stackable", "badfood", "cookable", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plant_meat")	
			inst.AnimState:SetBuild("plant_meat")	
			Anim路径 :  "anim/plant_meat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("spawnedfromhaunt")	
------------------------------------------------	
MISSING NAME			预设: wood_splinter_jump		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: tacklestation_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tackle_station")	
			inst.AnimState:SetBuild("tackle_station")	
			Anim路径 :  "anim/tackle_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_meteor_splashhit		路径： [string "scripts/prefabs/lavaarena_meteor.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: lavaarena_portal_activefx		路径： [string "scripts/prefabs/lavaarena_portal.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
桨			预设: oar		路径： [string "scripts/prefabs/oar.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "allow_action_on_impassable", "BURNABLE_fuel", "canlight", "_equippable", "edible_WOOD", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oar")	
			inst.AnimState:SetBuild("oar")	
			Anim路径 :  "anim/oar.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("oar")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: waterplant_pollen_fx		路径： [string "scripts/prefabs/waterplant_pollen.lua"]	
	Tags▼	
	{":", "fx", "notarget", "NOCLICK", "pollen"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pollen_cloud")	
			inst.AnimState:SetBuild("pollen_cloud")	
			Anim路径 :  "anim/pollen_cloud.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_medium_8		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
活板门			预设: carnivalgame_feedchicks_nest		路径： [string "scripts/prefabs/carnivalgame_feedchicks.lua"]	
	Tags▼	
	{":", "inspectable", "carnivalgame_part", "birdblocker", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_feedchicks_bird")	
			inst.AnimState:SetBuild("carnivalgame_feedchicks_bird")	
			Anim路径 :  "anim/carnivalgame_feedchicks_bird.zip"	
 	
	使用的组件▼	
		inst:AddComponent("carnivalgamefeedable")	
		inst:AddComponent("inspectable")	
		
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: gridplacer		路径： [string "scripts/prefabs/gridplacer.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gridplacer")	
			inst.AnimState:SetBuild("gridplacer")	
			Anim路径 :  "anim/gridplacer.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
饼干切割机			预设: cookiecutter		路径： [string "scripts/prefabs/cookiecutter.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "WOOD_eater", "noattack", "hostile", "smallcreature", "_combat", "locomotor", "sanityaura", "NOCLICK", "ignorewalkableplatformdrowning", "sleeper", "cookiecutter"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cookiecutter")	
			inst.AnimState:SetBuild("cookiecutter_build")	
			Anim路径 :  "anim/cookiecutter_water.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		inst:AddComponent("eater")	
		inst:AddComponent("cookiecutterdrill")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: balloonparty_confetti_cloud		路径： [string "scripts/prefabs/balloonparty.lua"]	
	Tags▼	
	{":", "fx", "confetti_cloud"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wes_confetti")	
			inst.AnimState:SetBuild("wes_confetti")	
			Anim路径 :  "anim/wes_confetti.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animqueueover")	
------------------------------------------------	
咸的酿鱼头			预设: barnaclestuffedfishhead_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
夜影万金油			预设: ghostlyelixir_attack		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "ghostlyelixir", "_stackable", "BURNABLE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ghostly_elixirs")	
			inst.AnimState:SetBuild("ghostly_elixirs")	
			Anim路径 :  "anim/ghostly_elixirs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("ghostlyelixir")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: winona_spotlight_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_spotlight_placement")	
			inst.AnimState:SetBuild("winona_spotlight_placement")	
			Anim路径 :  "anim/winona_spotlight_placement.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
梦魇灯座			预设: nightmarelight		路径： [string "scripts/prefabs/nightmarelight.lua"]	
	Tags▼	
	{":", "inspectable", "sanityaura", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock_light")	
			inst.AnimState:SetBuild("rock_light")	
			Anim路径 :  "anim/rock_light.zip"	
 	
	使用的组件▼	
		inst:AddComponent("childspawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("sanityaura")	
		
------------------------------------------------	
苔藓			预设: cutlichen		路径： [string "scripts/prefabs/cutlichen.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("algae")	
			inst.AnimState:SetBuild("algae")	
			Anim路径 :  "anim/algae.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: torchfire_pillar		路径： [string "scripts/prefabs/torchfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
辣水果圣代			预设: fruitmedley_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
肥料包			预设: compostwrap		路径： [string "scripts/prefabs/compostwrap.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "_stackable", "BURNABLE_fuel", "fertilizer", "canlight", "fertilizerresearchable", "deployable", "heal_fertilize", "slowfertilize"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("healing_cream")	
			inst.AnimState:SetBuild("healing_cream")	
			Anim路径 :  "anim/healing_cream.zip"	
 	
	使用的组件▼	
		inst:AddComponent("smotherer")	
		inst:AddComponent("fuel")	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("fertilizer")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
烤辣椒			预设: pepper_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pepper")	
			inst.AnimState:SetBuild("pepper")	
			Anim路径 :  "anim/pepper.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
未使用			预设: oceanfishinglure_spinner_white		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_lure_spinner")	
			inst.AnimState:SetBuild("oceanfishing_lure_spinner")	
			Anim路径 :  "anim/oceanfishing_lure_spinner.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_retaliation_buff		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
皮弗娄牛神龛			预设: yotb_beefaloshrine		路径： [string "scripts/prefabs/yotb_beefaloshrine.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "beefaloshrine", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefaloshrine")	
			inst.AnimState:SetBuild("yotb_beefaloshrine")	
			Anim路径 :  "anim/yotb_beefaloshrine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("yotb_contestenabled")	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("yotb_contestfinished")	
------------------------------------------------	
龙鳞地板			预设: turf_dragonfly		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf")	
			inst.AnimState:SetBuild("turf")	
			Anim路径 :  "anim/turf.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: winona_battery_high_shatterfx		路径： [string "scripts/prefabs/winona_battery_high.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gems")	
			inst.AnimState:SetBuild("gems")	
			Anim路径 :  "anim/gems.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: peghook_hitfx		路径： [string "scripts/prefabs/lavaarena_peghook.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
三文鱼			预设: quagmire_salmon		路径： [string "scripts/prefabs/quagmire_fish.lua"]	
	Tags▼	
	{":", "meat", "quagmire_stewable", "cookable", "catfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_salmon")	
			inst.AnimState:SetBuild("quagmire_salmon")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型榴莲			预设: durian_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_durian_build")	
			Anim路径 :  "anim/farm_plant_pepper.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("propagator")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
黄色羽毛			预设: feather_canary		路径： [string "scripts/prefabs/feathers.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("feather_canary")	
			inst.AnimState:SetBuild("feather_canary")	
			Anim路径 :  "anim/feather_canary.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: atrium_key_icon		路径： [string "scripts/prefabs/atrium_key.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("maprevealable")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: antchovies_group		路径： [string "scripts/prefabs/antchovies_group.lua"]	
	Tags▼	
	{":", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("antchovies")	
			inst.AnimState:SetBuild("water_antchovies")	
			Anim路径 :  "anim/water_antchovies.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fishschool")	
		
	使用的监听▼	
		inst:ListenForEvent("on_pre_net")	
------------------------------------------------	
MISSING NAME			预设: nutrients_overlay		路径： [string "scripts/prefabs/nutrients_overlay.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_soil_moisture")	
			inst.AnimState:SetBuild("farm_soil_moisture")	
			Anim路径 :  "anim/farm_soil_moisture.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("nutrientlevelsdirty")	
------------------------------------------------	
烤胡萝卜			预设: carrot_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carrot")	
			inst.AnimState:SetBuild("carrot")	
			Anim路径 :  "anim/carrot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
多肉植物			预设: succulent_plant		路径： [string "scripts/prefabs/succulent_plant.lua"]	
	Tags▼	
	{":", "quickpick", "inspectable", "succulent", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("succulent")	
			inst.AnimState:SetBuild("succulent")	
			Anim路径 :  "anim/succulent.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
雨帽			预设: rainhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rainhat")	
			inst.AnimState:SetBuild("hat_rain")	
			Anim路径 :  "anim/hat_rain.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: archive_ambient_sfx		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("arhivepoweron")	
		inst:ListenForEvent("arhivepoweroff")	
------------------------------------------------	
MISSING NAME			预设: nightmaregrowth_crack		路径： [string "scripts/prefabs/nightmaregrowth.lua"]	
	Tags▼	
	{":", "fx", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmaregrowth")	
			inst.AnimState:SetBuild("nightmaregrowth")	
			Anim路径 :  "anim/nightmaregrowth.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
幸运哨子			预设: houndwhistle		路径： [string "scripts/prefabs/houndwhistle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "PLAY_tool", "tool", "whistle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("houndwhistle")	
			Anim路径 :  "anim/houndwhistle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("instrument")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("tool")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("floater_stopfloating")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("floater_startfloating")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: ancient_altar_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
MISSING NAME			预设: fence_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fence")	
			inst.AnimState:SetBuild("fence")	
			Anim路径 :  "anim/fence.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
羽毛扇			预设: featherfan		路径： [string "scripts/prefabs/fans.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "fan"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fan")	
			inst.AnimState:SetBuild("fan")	
			Anim路径 :  "anim/fan.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("fan")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
完全正常的树根			预设: livingtree_root		路径： [string "scripts/prefabs/livingtree_root.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("livingtree_root")	
			inst.AnimState:SetBuild("livingtree_root")	
			Anim路径 :  "anim/livingtree_root.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
方向健身房套装			预设: yotc_carrat_gym_direction_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_gym_direction_item")	
			inst.AnimState:SetBuild("yotc_carrat_gym_direction_item")	
			Anim路径 :  "anim/yotc_carrat_gym_direction_item.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
龙虾			预设: wobster_sheller		路径： [string "scripts/prefabs/wobster.lua"]	
	Tags▼	
	{":", "busy", "weighable_fish", "oceanfishable", "oceanfishinghookable", "NOBLOCK", "locomotor", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_sheller")	
			Anim路径 :  "anim/lobster_water.zip"	
 	
	使用的组件▼	
		inst:AddComponent("weighable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("oceanfishable")	
		
	SG = 有▼	
------------------------------------------------	
夜间匙型假饵			预设: oceanfishinglure_spoon_blue		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_lure_spoon")	
			inst.AnimState:SetBuild("oceanfishing_lure_spoon")	
			Anim路径 :  "anim/oceanfishing_lure_spoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香南瓜饼干			预设: pumpkincookie_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
脆籽荚			预设: durian_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "deployedfarmplant", "edible_SEEDS", "_stackable", "canlight", "cookable", "deployable", "oceanfishing_lure", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_seeds")	
			inst.AnimState:SetBuild("farm_plant_seeds")	
			Anim路径 :  "anim/farm_plant_seeds.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("farmplantable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("tradable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("plantable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: quagmire_park_gate_anim		路径： [string "scripts/prefabs/fence.lua"]	
	Tags▼	
	{":", "fx", "can_offset_sort_pos", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_park_gate")	
			inst.AnimState:SetBuild("quagmire_park_gate")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
烧焦的食物			预设: quagmire_food_bowl_burnt		路径： [string "scripts/prefabs/quagmire_food_burnt.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "overcooked", "show_spoiled"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香曼德拉草汤			预设: mandrakesoup_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
金属土豆状零件			预设: teleportato_potato		路径： [string "scripts/prefabs/teleportato_parts.lua"]	
	Tags▼	
	{":", "_inventoryitem", "teleportato_part", "inspectable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("teleportato_parts_build")	
			Anim路径 :  "anim/teleportato_parts.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
火龙果			预设: dragonfruit		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "halloweenmoonmutable", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonfruit")	
			inst.AnimState:SetBuild("dragonfruit")	
			Anim路径 :  "anim/dragonfruit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("halloweenmoonmutable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("weighable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: moon_altar_break		路径： [string "scripts/prefabs/moon_altar_break.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_altar_break")	
			inst.AnimState:SetBuild("moon_altar_break")	
			Anim路径 :  "anim/moon_altar_break.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: halloweenpotion_health_large_buff		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: plant_dug_small_fx		路径： [string "scripts/prefabs/plant_normal.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plant_normal_ground")	
			inst.AnimState:SetBuild("plant_normal_ground")	
			Anim路径 :  "anim/plant_normal_ground.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
蘑菇蛋糕			预设: shroomcake		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "canlight", "preparedfood", "edible_GOODIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food6")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_creature_teleport_smoke_fx_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_fancy7		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: slingshotammo_marble_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
	Tags▼	
	{":", "projectile", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshotammo")	
			inst.AnimState:SetBuild("slingshotammo")	
			Anim路径 :  "anim/slingshotammo.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		inst:AddComponent("weapon")	
		
------------------------------------------------	
MISSING NAME			预设: vomitfire_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
炽热太阳鱼			预设: oceanfish_small_8_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "FROMNUM", "HASHEATER", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_8")	
			Anim路径 :  "anim/oceanfish_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("heater")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("murderable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("weighable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
火龙果派			预设: dragonpie		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
雨衣			预设: raincoat		路径： [string "scripts/prefabs/raincoat.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("torso_rain")	
			inst.AnimState:SetBuild("torso_rain")	
			Anim路径 :  "anim/torso_rain.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("fueled")	
		inst:AddComponent("tradable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: gnarwail_water_shadow		路径： [string "scripts/prefabs/gnarwail.lua"]	
	Tags▼	
	{":", "DECOR", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gnarwail_water_shadow")	
			inst.AnimState:SetBuild("gnarwail_build")	
			Anim路径 :  "anim/gnarwail_water_shadow.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的蓝带鱼排			预设: frogfishbowl_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "masterfood", "badfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
巨型胡萝卜			预设: carrot_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_carrot")	
			inst.AnimState:SetBuild("farm_plant_carrot")	
			Anim路径 :  "anim/farm_plant_carrot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("propagator")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: sanity_lower		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
隐士之家			预设: hermithouse_construction3		路径： [string "scripts/prefabs/hermithouse.lua"]	
	Tags▼	
	{":", "inspectable", "_constructionsite", "antlion_sinkhole_blocker", "structure", "constructionsite", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hermitcrab_home")	
			inst.AnimState:SetBuild("hermitcrab_home")	
			Anim路径 :  "anim/hermitcrab_home.zip"	
 	
	使用的组件▼	
		inst:AddComponent("spawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("constructionsite")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("clocksegschanged")	
------------------------------------------------	
幸运扇			预设: perdfan		路径： [string "scripts/prefabs/fans.lua"]	
	Tags▼	
	{":", "_inventoryitem", "channelingfan", "inspectable", "fan"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fan")	
			inst.AnimState:SetBuild("fan")	
			Anim路径 :  "anim/fan.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("fan")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
                  Failed to spawn	lavaarenastage_allplayersspawned	
------------------------------------------------	
MISSING NAME			预设: oceantree_roots_tall		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_tall")	
			inst.AnimState:SetBuild("oceantree_tall")	
			Anim路径 :  "anim/oceantree_tall.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lantern_tesla_fx_ground		路径： [string "scripts/prefabs/lantern_tesla_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lantern")	
			Anim路径 :  "anim/dynamic/lantern_tesla.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: explode_small		路径： [string "scripts/prefabs/explode_small.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: krampuswarning_lvl2		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
蔬菜鸡尾酒			预设: vegstinger		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
远古大门			预设: quagmire_portal		路径： [string "scripts/prefabs/quagmire_portal.lua"]	
	Tags▼	
	{":", "groundhole", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_portal")	
			inst.AnimState:SetBuild("quagmire_portal")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("camerafocusdirty")	
------------------------------------------------	
完全正常的树			预设: livingtree		路径： [string "scripts/prefabs/livingtree.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "plant", "CHOP_workable", "canlight", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_living_wood")	
			inst.AnimState:SetBuild("evergreen_living_wood")	
			Anim路径 :  "anim/evergreen_living_wood.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
蒜香蝴蝶松饼			预设: butterflymuffin_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的藤壶握寿司			预设: barnaclesushi_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
黄羽浮标			预设: oceanfishingbobber_canary_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_canary_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
食人花种子			预设: lureplantbulb		路径： [string "scripts/prefabs/lureplant_bulb.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeplant_bulb")	
			inst.AnimState:SetBuild("eyeplant_bulb")	
			Anim路径 :  "anim/eyeplant_bulb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
失败料理			预设: quagmire_food_plate_goop		路径： [string "scripts/prefabs/quagmire_food_burnt.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "overcooked", "show_spoiled"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
饕餮的惠赠			预设: quagmire_coin4		路径： [string "scripts/prefabs/quagmire_coins.lua"]	
	Tags▼	
	{":", "quagmire_coin"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
检查点套装			预设: yotc_carrat_race_checkpoint_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_racekit_checkpoint")	
			inst.AnimState:SetBuild("yotc_carrat_racekit_checkpoint")	
			Anim路径 :  "anim/yotc_carrat_racekit_checkpoint.zip:IDLE"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
石笋			预设: stalagmite_full		路径： [string "scripts/prefabs/stalagmite.lua"]	
	Tags▼	
	{":", "inspectable", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock_stalagmite")	
			inst.AnimState:SetBuild("rock_stalagmite")	
			Anim路径 :  "anim/rock_stalagmite.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
种下的番茄种子			预设: farm_plant_tomato		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "farm_plant_tomato", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_tomato")	
			Anim路径 :  "anim/farm_plant_tomato.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
告密的心			预设: reviver		路径： [string "scripts/prefabs/reviver.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bloodpump")	
			inst.AnimState:SetBuild("bloodpump")	
			Anim路径 :  "anim/bloodpump.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
迷你摩天轮			预设: carnivaldecor_eggride1		路径： [string "scripts/prefabs/carnivaldecor_eggride.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "carnivaldecor", "HAMMER_workable", "quickactivation", "canlight", "structure", "inactive", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride1")	
			inst.AnimState:SetBuild("carnivaldecor_eggride1")	
			Anim路径 :  "anim/carnivaldecor_eggride1.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("carnivaldecor")	
		inst:AddComponent("burnable")	
		inst:AddComponent("activatable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
远古雕像			预设: ruins_statue_mage_nogem		路径： [string "scripts/prefabs/statueruins.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "statue", "MINE_workable", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("statue_ruins")	
			inst.AnimState:SetBuild("statue_ruins")	
			Anim路径 :  "anim/statue_ruins.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
催长剂起子			预设: soil_amender		路径： [string "scripts/prefabs/soil_amender.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "fertilizer", "fertilizerresearchable", "show_spoilage", "deployable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("soil_amender")	
			inst.AnimState:SetBuild("soil_amender")	
			Anim路径 :  "anim/soil_amender.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fertilizer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("perishable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onfertilizerindexdirty")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
辣芦笋冷汤			预设: gazpacho_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: shadowhand_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
玻璃绿洲			预设: grotto_pool_big		路径： [string "scripts/prefabs/grotto_pool_big.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "watersource", "antlion_sinkhole_blocker", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglasspool_tile")	
			inst.AnimState:SetBuild("moonglasspool_tile")	
			Anim路径 :  "anim/moonglasspool_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("watersource")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
月球环形山地皮			预设: turf_meteor		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf_moon")	
			inst.AnimState:SetBuild("turf_moon")	
			Anim路径 :  "anim/turf_moon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
绿宝石			预设: greengem		路径： [string "scripts/prefabs/gem.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "gem", "work_gem", "molebait", "_stackable", "quakedebris", "edible_ELEMENTAL", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gems")	
			inst.AnimState:SetBuild("gems")	
			Anim路径 :  "anim/gems.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("repairer")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("bait")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
穴居猴			预设: monkey		路径： [string "scripts/prefabs/monkey.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "monkey", "cavedweller", "_health", "inspectable", "freezable", "idle", "_inventory", "_combat", "locomotor", "nolight", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("kiki_basic")	
			Anim路径 :  "anim/kiki_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("areaaware")	
		inst:AddComponent("thief")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inventory")	
		inst:AddComponent("eater")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("health")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("changearea")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onpickupitem")	
		inst:ListenForEvent("done_embark_movement")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: goosplash4		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_seedpacket_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: coldfirefire		路径： [string "scripts/prefabs/coldfirefire.lua"]	
	Tags▼	
	{":", "fx", "HASHEATER"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("coldfire_fire")	
			inst.AnimState:SetBuild("coldfire_fire")	
			Anim路径 :  "anim/coldfire_fire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("firefx")	
		inst:AddComponent("heater")	
		
------------------------------------------------	
采摘的蓝蘑菇			预设: blue_cap		路径： [string "scripts/prefabs/mushrooms.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "mushroom", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushrooms")	
			inst.AnimState:SetBuild("mushrooms")	
			Anim路径 :  "anim/mushrooms.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cookable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("spawnedfromhaunt")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: shadow_shield3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: balloon_held_child_client		路径： [string "scripts/prefabs/balloon_held_child.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("balloon2")	
			inst.AnimState:SetBuild("balloon2")	
			Anim路径 :  "anim/balloon2.zip"	
 	
	使用的组件▼	
		
	SG = 有▼	
------------------------------------------------	
咸的鳄梨酱			预设: guacamole_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜茸土豆泥			预设: quagmire_food_024		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
泥鱼			预设: oceanfish_medium_1		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "OMNI_eater", "herd_oceanfish_medium_1", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_1")	
			Anim路径 :  "anim/oceanfish_medium.zip"	
 	
	使用的组件▼	
		inst:AddComponent("weighable")	
		inst:AddComponent("eater")	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("timer")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
	SG = 有▼	
------------------------------------------------	
损毁的废墟			预设: ruins_rubble_chair		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "_combat", "healthrepairable", "smashable", "stone", "repairable_stone", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_chair")	
			inst.AnimState:SetBuild("ruins_chair")	
			Anim路径 :  "anim/ruins_chair.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("repairable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
沙漠护目镜			预设: deserthat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "goggles", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deserthat")	
			inst.AnimState:SetBuild("hat_desert")	
			Anim路径 :  "anim/hat_desert.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
鱼人之王			预设: mermking		路径： [string "scripts/prefabs/mermking.lua"]	
	Tags▼	
	{":", "merm", "trader", "_health", "inspectable", "wet", "idle", "mermking", "_inventory", "_combat", "nolight", "_hunger", "character", "VEGETARIAN_eater", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_king")	
			inst.AnimState:SetBuild("merm_king")	
			Anim路径 :  "anim/merm_king.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("talker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("trader")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hunger")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("droppedtarget")	
		inst:ListenForEvent("giveuptarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("oncreated")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
金丝雀			预设: canary		路径： [string "scripts/prefabs/birds.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "_health", "inspectable", "SEEDS_eater", "freezable", "stunnedbybomb", "idle", "small_livestock", "smallcreature", "canary", "_combat", "locomotor", "nolight", "show_spoilage", "cookable", "flight", "likewateroffducksback", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crow")	
			inst.AnimState:SetBuild("canary_build")	
			Anim路径 :  "anim/crow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("occupier")	
		inst:AddComponent("propagator")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("cookable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("eater")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
蒜香酸橘汁腌鱼			预设: ceviche_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
硫化实验			预设: halloween_experiment_volatile		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fishingnetvisualizerfx		路径： [string "scripts/prefabs/fishingnetvisualizerfx.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_net_fx")	
			inst.AnimState:SetBuild("boat_net_fx")	
			Anim路径 :  "anim/boat_net_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
化石碎片			预设: fossil_piece		路径： [string "scripts/prefabs/fossil_piece.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "work_fossil", "deployable", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fossil_piece")	
			inst.AnimState:SetBuild("fossil_piece")	
			Anim路径 :  "anim/fossil_piece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("repairer")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
宠爱的鳄鱼玩具			预设: lost_toy_43		路径： [string "scripts/prefabs/lost_toys.lua"]	
	Tags▼	
	{":", "inspectable", "haunted"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("colourtweener")	
		
------------------------------------------------	
MISSING NAME			预设: pinecone_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pinecone")	
			inst.AnimState:SetBuild("pinecone")	
			Anim路径 :  "anim/pinecone.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: lanternlight		路径： [string "scripts/prefabs/mininglantern.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
猎犬			预设: hound		路径： [string "scripts/prefabs/hound.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "freezable", "scarytooceanprey", "hostile", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "canbestartled", "sanityaura", "scarytoprey", "nolight", "_follower", "halloweenmoonmutable", "sleeper", "hound"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hound")	
			inst.AnimState:SetBuild("hound_ocean")	
			Anim路径 :  "anim/hound_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("amphibiouscreature")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("halloweenmoonmutable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("spawnedfromhaunt")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: shadow_puff_solid		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
“月亮” 雕塑			预设: chesspiece_moon_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mushroom_light2_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_light2")	
			inst.AnimState:SetBuild("mushroom_light2")	
			Anim路径 :  "anim/mushroom_light2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: archive_orchestrina_main		路径： [string "scripts/prefabs/archive_orchestrina_main.lu..."]	
	Tags▼	
	{":", "DECOR", "archive_orchestrina_main", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_orchestrina_main")	
			inst.AnimState:SetBuild("archive_orchestrina_main")	
			Anim路径 :  "anim/archive_orchestrina_main.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的藤壶皮塔饼			预设: barnaclepita_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: hammer_mjolnir_cracklebase		路径： [string "scripts/prefabs/hammer_mjolnir.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_hammer_attack_fx")	
			inst.AnimState:SetBuild("lavaarena_hammer_attack_fx")	
			Anim路径 :  "anim/lavaarena_hammer_attack_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
离奇工具			预设: wagstaff_tool_4		路径： [string "scripts/prefabs/wagstaff_tools.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "FROMNUM", "_stackable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wagstaff_tools")	
			Anim路径 :  "anim/wagstaff_tools.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("ms_playerdespawnanddelete")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("ms_playerdespawn")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香鳗鱼料理			预设: unagi_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
什锦干果			预设: trailmix		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
香料潘趣酒			预设: mulleddrink		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "wintersfeastcookedfood", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("food_winters_feast_2019")	
			inst.AnimState:SetBuild("food_winters_feast_2019")	
			Anim路径 :  "anim/food_winters_feast_2019.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香海鲜牛排			预设: surfnturf_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: pocketwatch_portal_entrance_overlay		路径： [string "scripts/prefabs/pocketwatch_portal.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_portal_fx")	
			inst.AnimState:SetBuild("pocketwatch_portal_fx")	
			Anim路径 :  "anim/pocketwatch_portal_fx.zip"	
 	
	使用的组件▼	
		
                  Failed to spawn	quagmire_food	
------------------------------------------------	
整洁洞穴			预设: dustmothden		路径： [string "scripts/prefabs/dustmothden.lua"]	
	Tags▼	
	{":", "inspectable", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dustmothden")	
			inst.AnimState:SetBuild("dustmothden")	
			Anim路径 :  "anim/dustmothden.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("workable")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_plain9		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
硝化硫酸晶体			预设: halloweenpotion_sparks		路径： [string "scripts/prefabs/halloweenpotion_embers.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_potions")	
			inst.AnimState:SetBuild("halloween_potions")	
			Anim路径 :  "anim/halloween_potions.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
裸鼹鼠蝙蝠			预设: molebat		路径： [string "scripts/prefabs/molebat.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "freezable", "bat", "idle", "hostile", "strongstomach", "_combat", "locomotor", "OMNI_eater", "scarytoprey", "nolight", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("molebat")	
			inst.AnimState:SetBuild("molebat")	
			Anim路径 :  "anim/molebat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("freezable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("endquake")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("startquake")	
		inst:ListenForEvent("summon")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: mastupgrade_lightningrod_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
倒走表			预设: pocketwatch_warp		路径： [string "scripts/prefabs/pocketwatch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "pocketwatch_inactive", "inspectable", "pocketwatch_castfrominventory", "pocketwatch_warp_casting", "rechargeable", "pocketwatch", "pocketwatch_warp", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch")	
			inst.AnimState:SetBuild("pocketwatch_warp")	
			Anim路径 :  "anim/pocketwatch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("rechargeable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("pocketwatch")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("onownerputininventory")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("onownerdropped")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: eyeturret_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeball_turret")	
			inst.AnimState:SetBuild("eyeball_turret")	
			Anim路径 :  "anim/eyeball_turret.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: hallowed_nights_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣牛肉绿叶菜			预设: meatysalad_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: winters_feast_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: waterplant_pollen_fx_ocean		路径： [string "scripts/prefabs/waterplant_pollen.lua"]	
	Tags▼	
	{":", "fx", "chum", "NOCLICK", "pollen"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pollen_chum")	
			inst.AnimState:SetBuild("pollen_chum")	
			Anim路径 :  "anim/pollen_chum.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("fadingdirty")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
芦笋冷汤			预设: gazpacho		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: moonglass_stalactite2		路径： [string "scripts/prefabs/moonglass_stalactites.lua"]	
	Tags▼	
	{":", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_bigwaterfall")	
			inst.AnimState:SetBuild("moonglass_bigwaterfall")	
			Anim路径 :  "anim/moonglass_bigwaterfall.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: abigailforcefieldretaliation		路径： [string "scripts/prefabs/abigailforcefield.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_shield")	
			inst.AnimState:SetBuild("abigail_shield")	
			Anim路径 :  "anim/abigail_shield.zip"	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
奇异工具			预设: wagstaff_tool_3		路径： [string "scripts/prefabs/wagstaff_tools.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "FROMNUM", "_stackable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wagstaff_tools")	
			Anim路径 :  "anim/wagstaff_tools.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("ms_playerdespawnanddelete")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("ms_playerdespawn")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: statue_transition		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
多枝树			预设: twiggytree		路径： [string "scripts/prefabs/evergreens.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "renewable", "plant", "CHOP_workable", "canlight", "twiggytree", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("twiggy_build")	
			Anim路径 :  "anim/twiggy_tall_old.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("plantregrowth")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
辣骨头汤			预设: bonesoup_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "masterfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
清洁扫把			预设: reskin_tool		路径： [string "scripts/prefabs/reskin_tool.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "castfrominventory", "veryquickcast", "BURNABLE_fuel", "canlight", "castontargets", "_equippable", "nopunch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reskin_tool")	
			inst.AnimState:SetBuild("reskin_tool")	
			Anim路径 :  "anim/reskin_tool.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("spellcaster")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
伯尼			预设: bernie_active		路径： [string "scripts/prefabs/bernie_active.lua"]	
	Tags▼	
	{":", "_inventoryitem", "busy", "_health", "inspectable", "companion", "smallcreature", "_combat", "locomotor", "soulless"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bernie_build")	
			Anim路径 :  "anim/bernie.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("timer")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
虚影			预设: gestalt_alterguardian_projectile		路径： [string "scripts/prefabs/gestalt_alterguardian_proje..."]	
	Tags▼	
	{":", "NOBLOCK", "sanityaura", "brightmare", "NOCLICK", "brightmare_gestalt"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt")	
			inst.AnimState:SetBuild("brightmare_gestalt")	
			Anim路径 :  "anim/brightmare_gestalt.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("transparentonsanity")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
遗物			预设: ruins_vase		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "clay", "_combat", "smashable", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_vase")	
			inst.AnimState:SetBuild("ruins_vase")	
			Anim路径 :  "anim/ruins_vase.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: slurper_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
面包布丁			预设: quagmire_food_043		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: quagmire_wheat_leaf		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜彩虹糖豆			预设: jellybean_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "canlight", "spicedfood", "preparedfood", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
怪物鞑靼			预设: monstertartare		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "masterfood", "monstermeat", "badfood", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
冷冻虫卵			预设: lavae_cocoon		路径： [string "scripts/prefabs/lavae_cocoon.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavae_cocoon")	
			inst.AnimState:SetBuild("lavae_cocoon")	
			Anim路径 :  "anim/lavae_cocoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: resurrectionstatue_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilsonstatue")	
			inst.AnimState:SetBuild("wilsonstatue")	
			Anim路径 :  "anim/wilsonstatue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
锻锤			预设: hammer_mjolnir		路径： [string "scripts/prefabs/hammer_mjolnir.lua"]	
	Tags▼	
	{":", "tool", "rechargeable", "aoeweapon_leap", "hammer", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hammer_mjolnir")	
			inst.AnimState:SetBuild("hammer_mjolnir")	
			Anim路径 :  "anim/hammer_mjolnir.zip"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
亮片大炮			预设: carnivalcannon_sparkle		路径： [string "scripts/prefabs/carnival_cannons.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "carnivaldecor", "carnivalcannon", "HAMMER_workable", "quickactivation", "canlight", "structure", "inactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon_sparkle")	
			Anim路径 :  "anim/carnival_cannon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("carnivaldecor")	
		inst:AddComponent("burnable")	
		inst:AddComponent("activatable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
鱿鱼			预设: squid		路径： [string "scripts/prefabs/squid.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "scarytooceanprey", "squid", "idle", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "sanityaura", "nolight", "_follower", "likewateroffducksback", "herdmember", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("squiderp")	
			inst.AnimState:SetBuild("squid_build")	
			Anim路径 :  "anim/squid.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("amphibiouscreature")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("timer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onattackother")	
	SG = 有▼	
------------------------------------------------	
石灰硫化晶体			预设: halloweenpotion_embers		路径： [string "scripts/prefabs/halloweenpotion_embers.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_potions")	
			inst.AnimState:SetBuild("halloween_potions")	
			Anim路径 :  "anim/halloween_potions.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	

------------------------------------------------	
蜘蛛宝宝			预设: webber_spider_minion		路径： [string "scripts/prefabs/webber_spider_minions.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider")	
			inst.AnimState:SetBuild("spider_build")	
			Anim路径 :  "anim/ds_spider_cannon.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蜂蜜水晶			预设: spice_sugar		路径： [string "scripts/prefabs/spices.lua"]	
	Tags▼	
	{":", "_inventoryitem", "spice", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spices")	
			inst.AnimState:SetBuild("spices")	
			Anim路径 :  "anim/spices.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: walkingplank_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_anchor")	
			inst.AnimState:SetBuild("boat_anchor")	
			Anim路径 :  "anim/boat_anchor.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
烤仙人掌肉			预设: cactus_meat_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cactus_meat")	
			inst.AnimState:SetBuild("cactus_meat")	
			Anim路径 :  "anim/cactus_meat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: rock_break_fx		路径： [string "scripts/prefabs/rock_break_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蕨类植物			预设: cave_fern		路径： [string "scripts/prefabs/cave_fern.lua"]	
	Tags▼	
	{":", "quickpick", "inspectable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cave_ferns")	
			Anim路径 :  "anim/cave_ferns.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
远古月亮符文石			预设: archive_rune_statue		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":", "inspectable", "dustable", "FROMNUM", "statue", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("archive_runes")	
			Anim路径 :  "anim/archive_runes.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
克劳斯雕塑			预设: chesspiece_klaus_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: alterguardianhatlight		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
------------------------------------------------	
萨米
头脑清晰的泥沼鱼人			预设: quagmire_trader_merm		路径： [string "scripts/prefabs/quagmire_traders.lua"]	
	Tags▼	
	{":", "character", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
		
------------------------------------------------	
怪物千层饼			预设: monsterlasagna		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "monstermeat", "badfood", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
高礼帽			预设: tophat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tophat")	
			inst.AnimState:SetBuild("hat_top")	
			Anim路径 :  "anim/hat_top.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: stick		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
最爱的陀螺			预设: lost_toy_19		路径： [string "scripts/prefabs/lost_toys.lua"]	
	Tags▼	
	{":", "inspectable", "haunted"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("colourtweener")	
		
------------------------------------------------	
MISSING NAME			预设: crabking_chip_med		路径： [string "scripts/prefabs/crabking.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("crabking_rockchip")	
			Anim路径 :  "anim/crabking_rockchip.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
熟月亮蘑菇			预设: moon_cap_cooked		路径： [string "scripts/prefabs/moon_mushroom.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "BURNABLE_fuel", "badfood", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_cap")	
			inst.AnimState:SetBuild("moon_cap")	
			Anim路径 :  "anim/moon_cap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	

------------------------------------------------	
远古锚			预设: lavaarena_keyhole		路径： [string "scripts/prefabs/lavaarena_portal.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_keyhole")	
			inst.AnimState:SetBuild("lavaarena_keyhole")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
木球浮标			预设: oceanfishingbobber_ball		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_ball_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: multiplayer_portal_moonrock_fx		路径： [string "scripts/prefabs/multiplayer_portal.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("portal_moonrock")	
			Anim路径 :  "anim/portal_moonrock.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
遗物复制品 碗			预设: ruinsrelic_bowl		路径： [string "scripts/prefabs/ruinsrelic.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_bowl")	
			inst.AnimState:SetBuild("ruins_bowl")	
			Anim路径 :  "anim/ruins_bowl.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
复活的骨架			预设: stalker_forest		路径： [string "scripts/prefabs/stalker.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "idle", "fossil", "hostile", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "largecreature", "stalker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker_forest")	
			inst.AnimState:SetBuild("stalker_shadow_build")	
			Anim路径 :  "anim/stalker_forest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("donetalking")	
		inst:ListenForEvent("ontalk")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: fence_gate_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("build:")	
			inst.AnimState:SetBuild("Anim")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: moonstorm_lightning		路径： [string "scripts/prefabs/moonstorm_lightning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonstorm_lightningstrike")	
			inst.AnimState:SetBuild("moonstorm_lightningstrike")	
			Anim路径 :  "anim/moonstorm_lightningstrike.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
时间裂缝			预设: pocketwatch_portal_exit		路径： [string "scripts/prefabs/pocketwatch_portal.lua"]	
	Tags▼	
	{":", "inspectable", "CLASSIFIED", "ignorewalkableplatforms"}	
 	
	使用的组件▼	
		inst:AddComponent("teleporter")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
档案馆铥墙			预设: wall_ruins_2		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "HAMMER_workable", "_combat", "healthrepairable", "ruins", "repairable_thulecite", "stone", "wall", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins_2")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("repairable")	
		inst:AddComponent("health")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("combat")	
		
------------------------------------------------	
MISSING NAME			预设: halloweenpotion_bravery_small_buff		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
动物足迹			预设: animal_track		路径： [string "scripts/prefabs/animal_track.lua"]	
	Tags▼	
	{":", "inspectable", "track"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("track")	
			inst.AnimState:SetBuild("koalefant_tracks")	
			Anim路径 :  "anim/koalefant_tracks.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
猪皮			预设: pigskin		路径： [string "scripts/prefabs/pigskin.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_HORRIBLE", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigskin")	
			inst.AnimState:SetBuild("pigskin")	
			Anim路径 :  "anim/pigskin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: yellow_leaves_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
草鳄鱼			预设: grassgator		路径： [string "scripts/prefabs/grassgator.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "_health", "inspectable", "freezable", "idle", "grassgator", "_combat", "locomotor", "nolight", "largecreature", "animal", "saltlicker", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grass_gator")	
			inst.AnimState:SetBuild("grass_gator")	
			Anim路径 :  "anim/grass_gator_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("saltlicker")	
		inst:AddComponent("combat")	
		inst:AddComponent("amphibiouscreature")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("freezable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("burnable")	
		inst:AddComponent("timer")	
		inst:AddComponent("embarker")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("saltlick_placed")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("freeze")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: grassgekkoherd		路径： [string "scripts/prefabs/grassgekkoherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("herd")	
		
------------------------------------------------	
蒜香怪物鞑靼			预设: monstertartare_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "masterfood", "monstermeat", "badfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_bloom4		路径： [string "scripts/prefabs/lavaarena_blooms.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_bloom"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")	
			Anim路径 :  "anim/lavaarena_heal_flowers_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
弹簧秤			预设: pocket_scale		路径： [string "scripts/prefabs/pocket_scale.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "trophyscale_fish", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocket_scale")	
			inst.AnimState:SetBuild("pocket_scale")	
			Anim路径 :  "anim/pocket_scale.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("itemweigher")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蜘蛛女王			预设: spiderqueen		路径： [string "scripts/prefabs/spiderqueen.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "freezable", "idle", "hostile", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "sanityaura", "epic", "nolight", "spiderqueen", "largecreature", "sleeper", "spider"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("spider_queen_build")	
			Anim路径 :  "anim/spider_queen_2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("incrementalproducer")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("leader")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
独眼巨鹿雕塑			预设: chesspiece_deerclops		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_deerclops_marble")	
			Anim路径 :  "anim/chesspiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("shadowchessroar")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	

------------------------------------------------	
饕餮敬拜者			预设: quagmire_park_angel2		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
无眼鹿			预设: deer_red		路径： [string "scripts/prefabs/deer.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "deer", "_combat", "locomotor", "deergemresistance", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer")	
			inst.AnimState:SetBuild("deer_build")	
			Anim路径 :  "anim/deer_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("timer")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("gotcommander")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("lostcommander")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
	SG = 有▼	

------------------------------------------------	
肉饼			预设: quagmire_food_019		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lureplantbulb_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeplant_trap")	
			inst.AnimState:SetBuild("eyeplant_trap")	
			Anim路径 :  "anim/eyeplant_trap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
碾磨石			预设: quagmire_mealingstone		路径： [string "scripts/prefabs/quagmire_mealingstone.lua"]	
	Tags▼	
	{":", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_mealingstone")	
			inst.AnimState:SetBuild("quagmire_mealingstone")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
糖果苹果			预设: halloweencandy_1		路径： [string "scripts/prefabs/halloweencandy.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "halloweencandy", "_stackable", "cattoy", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloweencandy")	
			inst.AnimState:SetBuild("halloweencandy")	
			Anim路径 :  "anim/halloweencandy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
海草			预设: waterplant_projectile		路径： [string "scripts/prefabs/waterplant_seed.lua"]	
	Tags▼	
	{":", "projectile", "noattack", "_combat", "notarget", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle_burr")	
			inst.AnimState:SetBuild("barnacle_burr")	
			Anim路径 :  "anim/barnacle_burr.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
鸦年华树苗			预设: carnival_plaza_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_plaza")	
			inst.AnimState:SetBuild("carnival_plaza")	
			Anim路径 :  "anim/carnival_plaza.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
坑			预设: antlion_sinkhole		路径： [string "scripts/prefabs/antlion_sinkhole.lua"]	
	Tags▼	
	{":", "antlion_sinkhole", "antlion_sinkhole_blocker", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sinkhole")	
			inst.AnimState:SetBuild("antlion_sinkhole")	
			Anim路径 :  "anim/antlion_sinkhole.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("unevenground")	
		
	使用的监听▼	
		inst:ListenForEvent("startcollapse")	
		inst:ListenForEvent("timerdone")	
                  Failed to spawn	lavaarenastage_delay	
------------------------------------------------	
独眼巨鹿眼球			预设: deerclops_eyeball		路径： [string "scripts/prefabs/deerclops_eyeball.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "badfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deerclops_eyeball")	
			inst.AnimState:SetBuild("deerclops_eyeball")	
			Anim路径 :  "anim/deerclops_eyeball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: goosplash8		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
迷你摩天轮套装			预设: carnivaldecor_eggride1_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride1")	
			inst.AnimState:SetBuild("carnivaldecor_eggride1")	
			Anim路径 :  "anim/carnivaldecor_eggride1.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: firenettle_toxin		路径： [string "scripts/prefabs/firenettles.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: spawn_fx_small		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
巧克力树洞蛋糕			预设: winter_food5		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "wintersfeastfood", "_stackable", "winter_ornament", "cattoy", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
拐杖糖			预设: winter_food3		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "wintersfeastfood", "_stackable", "winter_ornament", "cattoy", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_deerclops		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_slowregen_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: battlesong_instant_electric_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: washashore_puddle_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: malbatross_feather_fall		路径： [string "scripts/prefabs/malbatross_feather.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("malbatross_feather")	
			inst.AnimState:SetBuild("malbatross_feather")	
			Anim路径 :  "anim/malbatross_feather.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
大蒜			预设: garlic		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("garlic")	
			inst.AnimState:SetBuild("garlic")	
			Anim路径 :  "anim/garlic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("weighable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
辣芦笋汤			预设: asparagussoup_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
树苗			预设: dug_sapling_moon		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sapling_moon")	
			inst.AnimState:SetBuild("sapling_moon")	
			Anim路径 :  "anim/sapling_moon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
榴莲			预设: durian		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_MONSTER", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("durian")	
			inst.AnimState:SetBuild("durian")	
			Anim路径 :  "anim/durian.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("weighable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: shadow_shield6		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
海星陷阱			预设: dug_trap_starfish		路径： [string "scripts/prefabs/trap_starfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("star_trap")	
			inst.AnimState:SetBuild("star_trap")	
			Anim路径 :  "anim/star_trap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
爆米花鱼			预设: oceanfish_small_5_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "edible_VEGGIE", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_5")	
			Anim路径 :  "anim/oceanfish_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("murderable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("weighable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
粗鲁插曲			预设: battlesong_instant_taunt		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "battlesong", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("battlesongs")	
			inst.AnimState:SetBuild("battlesongs")	
			Anim路径 :  "anim/battlesongs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("singable")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: oceanfishableflotsam_water		路径： [string "scripts/prefabs/oceanfishableflotsam.lua"]	
	Tags▼	
	{":", "oceanfishable", "oceanfishinghookable", "NOBLOCK", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming", "winchtarget"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flotsam")	
			inst.AnimState:SetBuild("flotsam")	
			Anim路径 :  "anim/flotsam.zip"	
 	
	使用的组件▼	
		inst:AddComponent("winchtarget")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
岩浆虫卵			预设: lavae_egg		路径： [string "scripts/prefabs/lavae_egg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavae_egg")	
			inst.AnimState:SetBuild("lavae_egg")	
			Anim路径 :  "anim/lavae_egg.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hatchable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
胡子			预设: beardhair		路径： [string "scripts/prefabs/beardhair.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beardhair")	
			inst.AnimState:SetBuild("beardhair")	
			Anim路径 :  "anim/beardhair.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
流星			预设: lavaarena_meteor		路径： [string "scripts/prefabs/lavaarena_meteor.lua"]	
	Tags▼	
	{":", "fx", "notarget", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: winona_spotlight_head		路径： [string "scripts/prefabs/winona_spotlight.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_spotlight")	
			inst.AnimState:SetBuild("winona_spotlight")	
			Anim路径 :  "anim/winona_spotlight.zip"	
 	
	使用的组件▼	
		inst:AddComponent("colouradder")	
		
------------------------------------------------	
MISSING NAME			预设: meteorwarning		路径： [string "scripts/prefabs/meteorwarning.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("warning_shadow")	
			inst.AnimState:SetBuild("meteor_shadow")	
			Anim路径 :  "anim/meteor_shadow.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
烤西瓜			预设: watermelon_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("watermelon")	
			inst.AnimState:SetBuild("watermelon")	
			Anim路径 :  "anim/watermelon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
仙人掌花			预设: cactus_flower		路径： [string "scripts/prefabs/cactus.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cactus_flower")	
			Anim路径 :  "anim/cactus_flower.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
小蛾子			预设: critter_lunarmothling		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "idle", "small_livestock", "NOBLOCK", "locomotor", "OMNI_eater", "_follower", "flying", "ignorewalkableplatformdrowning", "critter", "sleeper", "noauradamage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lunarmoth_build")	
			Anim路径 :  "anim/lunarmoth_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("crittertraits")	
		inst:AddComponent("perishable")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("eater")	
		inst:AddComponent("timer")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("follower")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: wormwarning_lvl3		路径： [string "scripts/prefabs/wormwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
远古织影者			预设: stalker_atrium		路径： [string "scripts/prefabs/stalker.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "idle", "fossil", "hostile", "noepicmusic", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "largecreature", "stalker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker")	
			inst.AnimState:SetBuild("stalker_shadow_build")	
			Anim路径 :  "anim/stalker_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("talker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("commander")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("grouptargeter")	
		inst:AddComponent("timer")	
		inst:AddComponent("epicscare")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("ontalk")	
		inst:ListenForEvent("miniondeath")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("soldierschanged")	
		inst:ListenForEvent("donetalking")	
	SG = 有▼	
------------------------------------------------	
洋葱			预设: quagmire_onion		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
电子元件			预设: transistor		路径： [string "scripts/prefabs/transistor.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("transistor")	
			inst.AnimState:SetBuild("transistor")	
			Anim路径 :  "anim/transistor.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: merm_king_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
月光玻璃			预设: grotto_waterfall_small2		路径： [string "scripts/prefabs/grotto_waterfall_small.lua"]	
	Tags▼	
	{":", "moonglass", "MINE_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_bigwaterfall")	
			inst.AnimState:SetBuild("moonglass_bigwaterfall")	
			Anim路径 :  "anim/moonglass_bigwaterfall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: boat_water_fx		路径： [string "scripts/prefabs/boat_water_fx.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_water_fx")	
			inst.AnimState:SetBuild("boat_water_fx2")	
			Anim路径 :  "anim/boat_water_fx2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("boattrailmover")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
藤壶中细面			预设: barnaclinguine		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food5")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_fastregen_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavae_move_fx		路径： [string "scripts/prefabs/lavae_move_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: buff_sleepresistance		路径： [string "scripts/prefabs/foodbuffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: dr_warm_loop_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
武器化的颤音			预设: battlesong_durability		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "battlesong", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("battlesongs")	
			inst.AnimState:SetBuild("battlesongs")	
			Anim路径 :  "anim/battlesongs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("singable")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的伏特羊肉冻			预设: voltgoatjelly_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "canlight", "spicedfood", "preparedfood", "edible_GOODIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: cavelightmoon_small		路径： [string "scripts/prefabs/cavelightmoon.lua"]	
	Tags▼	
	{":", "fx", "sinkhole", "daylight", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "anim/cave_exit_lightsource.zip"	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: lavaarena_meteor_splash		路径： [string "scripts/prefabs/lavaarena_meteor.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
荧光花			预设: lightflier_flower		路径： [string "scripts/prefabs/lightflier_flower.lua"]	
	Tags▼	
	{":", "inspectable", "lightflier_home", "plant", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bulb_plant_springy")	
			inst.AnimState:SetBuild("bulb_plant_springy")	
			Anim路径 :  "anim/bulb_plant_springy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("enterlight")	
------------------------------------------------	
MISSING NAME			预设: mushtree_tall_bloom_burntfx		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("mushroom_tree_tall_bloom")	
			Anim路径 :  "anim/mushroom_tree_tall.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
月亮虹吸器			预设: moon_device		路径： [string "scripts/prefabs/moon_device.lua"]	
	Tags▼	
	{":", "inspectable", "nomagic", "antlion_sinkhole_blocker", "moon_device", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moon_device")	
			Anim路径 :  "anim/moon_device.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: lightning_rod_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: attune_ghost_in_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnival_plaza_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_plaza")	
			inst.AnimState:SetBuild("carnival_plaza")	
			Anim路径 :  "anim/carnival_plaza.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
老皮弗娄牛			预设: quagmire_beefalo		路径： [string "scripts/prefabs/quagmire_beefalo.lua"]	
	Tags▼	
	{":", "canbeslaughtered", "beefalo", "largecreature", "animal"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo")	
			inst.AnimState:SetBuild("beefalo_shaved_build")	
			Anim路径 :  "anim/beefalo_basic.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: battlesong_durability_buff		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
木质护甲			预设: lavaarena_armormedium		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "hide_percentage", "wood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_medium")	
			inst.AnimState:SetBuild("armor_medium")	
			Anim路径 :  "anim/armor_medium.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
泡泡烟斗雕塑			预设: chesspiece_pipe		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_pipe_marble")	
			Anim路径 :  "anim/chesspiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("shadowchessroar")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
薇诺娜的投石机			预设: winona_catapult		路径： [string "scripts/prefabs/winona_catapult.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "companion", "idle", "HAMMER_workable", "_combat", "catapult", "canlight", "structure", "noauradamage", "engineering", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_catapult")	
			inst.AnimState:SetBuild("winona_catapult")	
			Anim路径 :  "anim/winona_catapult.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("colouradder")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("updatelooper")	
		inst:AddComponent("deployhelper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("workable")	
		inst:AddComponent("circuitnode")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("engineeringcircuitchanged")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
茄子			预设: eggplant		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eggplant")	
			inst.AnimState:SetBuild("eggplant")	
			Anim路径 :  "anim/eggplant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("weighable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: messagebottle_bob_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蔚蓝羽浮标			预设: oceanfishingbobber_robin_winter_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_robin_winter_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
MISSING NAME			预设: merm_spawn_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wave_splash		路径： [string "scripts/prefabs/wave.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("splash_water_rot")	
			inst.AnimState:SetBuild("splash_water_rot")	
			Anim路径 :  "anim/splash_water_rot.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
辣火龙果派			预设: dragonpie_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
月晷			预设: moondial		路径： [string "scripts/prefabs/moondial.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moondial")	
			inst.AnimState:SetBuild("moondial_build")	
			Anim路径 :  "anim/moondial.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("workable")	
		
	SG = 有▼	
------------------------------------------------	
咸的蜜汁卤肉			预设: honeynuggets_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "honeyed", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
红色羽毛			预设: feather_robin		路径： [string "scripts/prefabs/feathers.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("feather_robin")	
			inst.AnimState:SetBuild("feather_robin")	
			Anim路径 :  "anim/feather_robin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
巨型洋葱			预设: onion_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_onion_build")	
			Anim路径 :  "anim/farm_plant_pumpkin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("waxable")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("weighable")	
		inst:AddComponent("submersible")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
肉丸			预设: meatballs		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
长草地皮			预设: turf_grass		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf")	
			inst.AnimState:SetBuild("turf")	
			Anim路径 :  "anim/turf.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: ocean_splash_small1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
石笋			预设: stalagmite_tall		路径： [string "scripts/prefabs/stalagmite_tall.lua"]	
	Tags▼	
	{":", "inspectable", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock_stalagmite_tall")	
			inst.AnimState:SetBuild("rock_stalagmite_tall")	
			Anim路径 :  "anim/rock_stalagmite_tall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
花朵礼服款式			预设: nature_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("blueprint_sewing_machine_yotb")	
			Anim路径 :  "anim/blueprint_sewing_machine_yotb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("yotb_skinunlocker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
鸟蛋			预设: bird_egg		路径： [string "scripts/prefabs/egg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bird_eggs")	
			Anim路径 :  "anim/bird_eggs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
浣猫糖果			预设: halloweencandy_5		路径： [string "scripts/prefabs/halloweencandy.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "halloweencandy", "_stackable", "cattoy", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloweencandy")	
			inst.AnimState:SetBuild("halloweencandy")	
			Anim路径 :  "anim/halloweencandy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: oceantree_falling		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("build:")	
			inst.AnimState:SetBuild("Anim")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mastupgrade_lamp		路径： [string "scripts/prefabs/mastupgrade_lamp.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mastupgrade_lamp_item")	
			inst.AnimState:SetBuild("mastupgrade_lamp")	
			Anim路径 :  "anim/mastupgrade_lamp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("mast_burnt")	
		inst:ListenForEvent("mast_lamp_off")	
		inst:ListenForEvent("mast_lamp_on")	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
天体祭坛底座			预设: moon_altar_glass		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "work_moon_altar", "nonpotatable", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_altar_glasspiece")	
			Anim路径 :  "anim/moon_altar_pieces.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("repairer")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("calling_moon_relics")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: purple_leaves_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜火鸡大餐			预设: turkeydinner_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
荆棘外壳			预设: armor_bramble		路径： [string "scripts/prefabs/armor_bramble.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "bramble_resistant", "BURNABLE_fuel", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_bramble")	
			inst.AnimState:SetBuild("armor_bramble")	
			Anim路径 :  "anim/armor_bramble.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("armor")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: balloon_mapicon		路径： [string "scripts/prefabs/balloonspeed.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
烤叶肉			预设: plantmeat_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plant_meat")	
			inst.AnimState:SetBuild("plant_meat")	
			Anim路径 :  "anim/plant_meat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("spawnedfromhaunt")	
------------------------------------------------	
咸的炖肉汤			预设: bonestew_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
玻璃刀			预设: glasscutter		路径： [string "scripts/prefabs/glasscutter.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "pointy", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("glasscutter")	
			inst.AnimState:SetBuild("glasscutter")	
			Anim路径 :  "anim/glasscutter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("weapon")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
锅			预设: quagmire_pot_small		路径： [string "scripts/prefabs/quagmire_pot.lua"]	
	Tags▼	
	{":", "quagmire_pot", "quagmire_stewer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_pot_small")	
			inst.AnimState:SetBuild("quagmire_pot_small")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: portableblender_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_blender")	
			inst.AnimState:SetBuild("portable_blender")	
			Anim路径 :  "anim/portable_blender.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
小玻璃绿洲			预设: grotto_pool_small		路径： [string "scripts/prefabs/grotto_pool_small.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "watersource", "antlion_sinkhole_blocker", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglasspool_tile")	
			inst.AnimState:SetBuild("moonglasspool_tile")	
			Anim路径 :  "anim/moonglasspool_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("watersource")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
甜海鲜牛排			预设: surfnturf_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	

------------------------------------------------	
带刺头盔			预设: lavaarena_lightdamagerhat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
治疗黏团			预设: spider_healer_item		路径： [string "scripts/prefabs/spider_healer_item.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_healer_item")	
			inst.AnimState:SetBuild("spider_healer_item")	
			Anim路径 :  "anim/spider_healer_item.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("healer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
鸦年华树			预设: carnival_plaza		路径： [string "scripts/prefabs/carnival_plaza.lua"]	
	Tags▼	
	{":", "inspectable", "carnivalgame_part", "CHOP_workable", "carnival_plaza", "structure", "carnivaldecor_ranker", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_plaza")	
			inst.AnimState:SetBuild("carnival_plaza")	
			Anim路径 :  "anim/carnival_plaza.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("carnivaldecorranker")	
		inst:AddComponent("deployhelper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: pocketwatch_ground_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: battlesong_sanityaura_buff		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: werebeaver_shock_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mushtree_moon_burntfx		路径： [string "scripts/prefabs/mushtree_moon.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("mutatedmushroom_tree_build")	
			Anim路径 :  "anim/mushroom_tree_tall.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
甜肉串			预设: kabobs_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
月熠			预设: moonstorm_spark		路径： [string "scripts/prefabs/moonstorm_spark.lua"]	
	Tags▼	
	{":", "_inventoryitem", "busy", "inspectable", "FROMNUM", "moonstorm_spark", "_stackable", "locomotor", "NET_workable", "show_spoilage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("charged_particle")	
			inst.AnimState:SetBuild("charged_particle")	
			Anim路径 :  "anim/charged_particle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("workable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
篮中蛋			预设: carnivalgame_memory_station		路径： [string "scripts/prefabs/carnivalgame_memory.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "HAMMER_workable", "carnivalgame_part", "birdblocker", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_memory_station")	
			inst.AnimState:SetBuild("carnivalgame_memory_station")	
			Anim路径 :  "anim/carnivalgame_memory_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("objectspawner")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("minigame")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
木栅栏			预设: fence_item		路径： [string "scripts/prefabs/fence.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "fencebuilder", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fence")	
			inst.AnimState:SetBuild("fence")	
			Anim路径 :  "anim/fence.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: winch_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_winch")	
			inst.AnimState:SetBuild("boat_winch")	
			Anim路径 :  "anim/boat_winch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: shadowstrike_slash_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cartographydesk_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cartography_desk")	
			inst.AnimState:SetBuild("cartography_desk")	
			Anim路径 :  "anim/cartography_desk.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
麋鹿鹅蛋			预设: mooseegg		路径： [string "scripts/prefabs/mooseegg.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "idle", "lightningrod"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goosemoose_nest")	
			inst.AnimState:SetBuild("goosemoose_nest")	
			Anim路径 :  "anim/goosemoose_nest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("guardian")	
		inst:AddComponent("named")	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
	SG = 有▼	
------------------------------------------------	
蒜香鱼肉玉米卷			预设: fishtacos_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: yotb_post_ribbon		路径： [string "scripts/prefabs/yotb_post.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotb_post_ribbons")	
			inst.AnimState:SetBuild("yotb_post_ribbons")	
			Anim路径 :  "anim/yotb_post_ribbons.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: groundpoundring_fx		路径： [string "scripts/prefabs/groundpoundringfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
大熔炉猪战士			预设: lavaarena_groundliftwarning		路径： [string "scripts/prefabs/lavaarena_groundlifts.lua"]	
	Tags▼	
	{":", "groundspike", "object", "CLASSIFIED", "hostile", "notarget", "stone"}	
 	
	使用的组件▼	
		
------------------------------------------------	
种子			预设: seeds		路径： [string "scripts/prefabs/seeds.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "deployedfarmplant", "edible_SEEDS", "_stackable", "canlight", "cookable", "deployable", "oceanfishing_lure", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seeds")	
			inst.AnimState:SetBuild("seeds")	
			Anim路径 :  "anim/seeds.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("farmplantable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("tradable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("plantable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
绿色蘑菇帽			预设: green_mushroomhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("green_mushroomhat")	
			inst.AnimState:SetBuild("hat_green_mushroom")	
			Anim路径 :  "anim/hat_green_mushroom.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("waterproofer")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
辣酸橘汁腌鱼			预设: ceviche_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香奶油土豆泥			预设: mashedpotatoes_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: farm_plow_item_placer		路径： [string "scripts/prefabs/farm_plow.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plow")	
			inst.AnimState:SetBuild("farm_plow")	
			Anim路径 :  "anim/farm_plow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
胡萝卜鼠			预设: carrat		路径： [string "scripts/prefabs/carrat.lua"]	
	Tags▼	
	{":", "_inventoryitem", "busy", "_health", "inspectable", "freezable", "stunnedbybomb", "small_livestock", "noattack", "strongstomach", "smallcreature", "_combat", "canbetrapped", "locomotor", "OMNI_eater", "prey", "nolight", "cattoy", "show_spoilage", "cookable", "catfood", "animal", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carrat")	
			inst.AnimState:SetBuild("carrat_build")	
			Anim路径 :  "anim/carrat_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("tradable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("cookable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("musicstatedirty")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
烤南瓜			预设: pumpkin_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pumpkin")	
			inst.AnimState:SetBuild("pumpkin")	
			Anim路径 :  "anim/pumpkin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
种下的尖形种子			预设: farm_plant_onion		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "farm_plant_onion", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_onion_build")	
			Anim路径 :  "anim/farm_plant_pumpkin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
MISSING NAME			预设: abigailunsummonfx		路径： [string "scripts/prefabs/abigail_flower.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wendy_recall_flower")	
			inst.AnimState:SetBuild("abigail_flower_rework")	
			Anim路径 :  "anim/wendy_recall_flower.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
冬帽			预设: winterhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winterhat")	
			inst.AnimState:SetBuild("hat_winter")	
			Anim路径 :  "anim/hat_winter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
落叶比目鱼			预设: oceanfish_small_6_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "badfood", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_6")	
			Anim路径 :  "anim/oceanfish_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("murderable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("weighable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	

------------------------------------------------	
饥饿之兽			预设: quagmire_altar_statue2		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_altar_statue2")	
			inst.AnimState:SetBuild("quagmire_altar_statue2")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("inspectable")	
------------------------------------------------	
炸肉饼			预设: quagmire_food_013		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的骨头汤			预设: bonesoup_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "masterfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: tauntfire_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
奖品摊位			预设: carnival_prizebooth		路径： [string "scripts/prefabs/carnival_prizebooth.lua"]	
	Tags▼	
	{":", "inspectable", "carnivaldecor", "HAMMER_workable", "structure", "carnival_prizebooth", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_prizebooth")	
			inst.AnimState:SetBuild("carnival_prizebooth")	
			Anim路径 :  "anim/carnival_prizebooth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("carnivaldecor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
黄油			预设: butter		路径： [string "scripts/prefabs/butter.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("butter")	
			inst.AnimState:SetBuild("butter")	
			Anim路径 :  "anim/butter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
熔炉装饰			预设: winter_ornament_festivalevents2		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments2018")	
			inst.AnimState:SetBuild("winter_ornaments2018")	
			Anim路径 :  "anim/winter_ornaments2018.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
便携香料站			预设: portablespicer		路径： [string "scripts/prefabs/portablespicer.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "stewer", "mastercookware", "HAMMER_workable", "canlight", "structure", "spicer", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_spicer")	
			inst.AnimState:SetBuild("portable_spicer")	
			Anim路径 :  "anim/portable_spicer.zip"	
 	
	使用的组件▼	
		inst:AddComponent("stewer")	
		inst:AddComponent("workable")	
		inst:AddComponent("portablestructure")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("onopen")	
		inst:ListenForEvent("onclose")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
悲惨的炸弹蘑菇			预设: mushroombomb_dark		路径： [string "scripts/prefabs/mushroombomb.lua"]	
	Tags▼	
	{":", "inspectable", "explosive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroombomb")	
			inst.AnimState:SetBuild("mushroombomb_dark_build")	
			Anim路径 :  "anim/mushroombomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("inspectable")	
------------------------------------------------	
荧光花			预设: flower_cave		路径： [string "scripts/prefabs/flower_cave.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "halloweenmoonmutable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bulb_plant_single")	
			inst.AnimState:SetBuild("bulb_plant_single")	
			Anim路径 :  "anim/bulb_plant_single.zip"	
 	
	使用的组件▼	
		inst:AddComponent("pickable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("halloweenmoonmutable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlight")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
种下的胡萝卜种子			预设: farm_plant_carrot		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "farm_plant_carrot", "plant", "DIG_workable", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_carrot")	
			inst.AnimState:SetBuild("farm_plant_carrot")	
			Anim路径 :  "anim/farm_plant_carrot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
MISSING NAME			预设: petrify_announce		路径： [string "scripts/prefabs/petrify_announce.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
香肠			预设: quagmire_food_027		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: oceanfishingbobber_plug_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_plug_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
种子包			预设: carnival_seedpacket		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_seedpacket")	
			inst.AnimState:SetBuild("carnival_seedpacket")	
			Anim路径 :  "anim/carnival_seedpacket.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("unwrappable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
探测杖底座			预设: diviningrodbase		路径： [string "scripts/prefabs/diviningrodbase.lua"]	
	Tags▼	
	{":", "inspectable", "rodbase"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("diviningrod")	
			inst.AnimState:SetBuild("diviningrod")	
			Anim路径 :  "anim/diviningrod.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lock")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("ready")	
------------------------------------------------	
MISSING NAME			预设: deerclops_laserhit		路径： [string "scripts/prefabs/deerclops_laser.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
邪天翁羽浮标			预设: oceanfishingbobber_malbatross_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_malbatross_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
MISSING NAME			预设: singingshell_creature_rockfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
贝雷帽			预设: walrushat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("walrushat")	
			inst.AnimState:SetBuild("hat_walrus")	
			Anim路径 :  "anim/hat_walrus.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
心碎歌谣			预设: battlesong_healthgain		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "battlesong", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("battlesongs")	
			inst.AnimState:SetBuild("battlesongs")	
			Anim路径 :  "anim/battlesongs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("singable")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: farm_plant_unhappy		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
羽毛头环			预设: lavaarena_feathercrownhat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: spawn_fx_small_high		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
破烂的猪屋			预设: quagmire_swampig_house		路径： [string "scripts/prefabs/quagmire_swampig_house.lua"]	
	Tags▼	
	{":", "inspectable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pig_house")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: moonstorm_ground_lightning_fx		路径： [string "scripts/prefabs/moonstorm_ground_lightning_..."]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonstorm_groundlight")	
			inst.AnimState:SetBuild("moonstorm_groundlight")	
			Anim路径 :  "anim/moonstorm_groundlight.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
煎蛋			预设: bird_egg_cooked		路径： [string "scripts/prefabs/egg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bird_eggs")	
			Anim路径 :  "anim/bird_eggs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
小龙蝇			预设: critter_dragonling_builder		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
小肉			预设: smallmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "dryable", "_stackable", "badfood", "cookable", "catfood", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_small")	
			inst.AnimState:SetBuild("meat_small")	
			Anim路径 :  "anim/meat_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("dryable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("spawnedfromhaunt")	
------------------------------------------------	
绚丽之门			预设: multiplayer_portal_moonrock_constr		路径： [string "scripts/prefabs/multiplayer_portal.lua"]	
	Tags▼	
	{":", "inspectable", "_constructionsite", "idle", "multiplayer_portal", "antlion_sinkhole_blocker", "constructionsite"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("portal_stone")	
			Anim路径 :  "anim/portal_stone_construction.zip"	
 	
	使用的组件▼	
		inst:AddComponent("constructionsite")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onstartconstruction")	
		inst:ListenForEvent("ms_newplayercharacterspawned")	
		inst:ListenForEvent("rez_player")	
	SG = 有▼	
------------------------------------------------	
蒜香舒缓茶			预设: sweettea_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "honeyed", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: redpouch_yotp_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: slingshotammo_hitfx_marble		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
烤蔬菜			预设: quagmire_food_014		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
娃娃皮弗娄牛玩偶			预设: yotb_beefalo_doll_doll		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight", "beefalo_doll"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo_doll")	
			inst.AnimState:SetBuild("beefalo_doll")	
			Anim路径 :  "anim/beefalo_doll.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("appraisable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
饕餮馅饼			预设: tourtiere		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "wintersfeastcookedfood", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("food_winters_feast_2019")	
			inst.AnimState:SetBuild("food_winters_feast_2019")	
			Anim路径 :  "anim/food_winters_feast_2019.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: atrium_light_light		路径： [string "scripts/prefabs/atrium_light.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_light")	
			inst.AnimState:SetBuild("atrium_light")	
			Anim路径 :  "anim/atrium_light.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香龙虾正餐			预设: lobsterdinner_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_player_revive_from_corpse_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
幸运兽脑袋			预设: dragonheadhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonheadhat")	
			inst.AnimState:SetBuild("hat_dragonhead")	
			Anim路径 :  "anim/hat_dragonhead.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fueled")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
糖浆锅			预设: quagmire_pot_syrup		路径： [string "scripts/prefabs/quagmire_pot.lua"]	
	Tags▼	
	{":", "quagmire_syrup_cooker", "quagmire_pot", "quagmire_stewer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_pot_syrup")	
			inst.AnimState:SetBuild("quagmire_pot_syrup")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
建造护符			预设: greenamulet		路径： [string "scripts/prefabs/amulet.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("amulets")	
			inst.AnimState:SetBuild("amulets")	
			Anim路径 :  "anim/amulets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: oceanhorror_attachpivot		路径： [string "scripts/prefabs/oceanshadowcreature.lua"]	
	Tags▼	
	{":", "NOCLICK", "ignorewalkableplatformdrowning"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onsink")	
------------------------------------------------	
俗气海狸像			预设: wereitem_beaver		路径： [string "scripts/prefabs/wereitems.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "wereitem", "_stackable", "monstermeat", "badfood", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wereitems")	
			inst.AnimState:SetBuild("wereitems")	
			Anim路径 :  "anim/wereitems.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: disease_puff		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: orange_leaves		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
饥饿之兽			预设: quagmire_altar_statue1		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_altar_statue1")	
			inst.AnimState:SetBuild("quagmire_altar_statue1")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
疯狂科学家实验室			预设: madscience_lab		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "inspectable", "madsciencelab", "HAMMER_workable", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("madscience_lab")	
			inst.AnimState:SetBuild("madscience_lab")	
			Anim路径 :  "anim/madscience_lab.zip"	
 	
	使用的组件▼	
		inst:AddComponent("madsciencelab")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
大萝卜蛋糕			预设: quagmire_food_006		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
战士礼服款式			预设: war_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("blueprint_sewing_machine_yotb")	
			Anim路径 :  "anim/blueprint_sewing_machine_yotb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("yotb_skinunlocker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
番茄酱烙通心粉			预设: quagmire_food_051		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
玻璃尖刺			预设: glassspike_short		路径： [string "scripts/prefabs/glass_spike.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sand_spike")	
			inst.AnimState:SetBuild("sand_spike")	
			Anim路径 :  "anim/sand_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
一角鲸			预设: gnarwail_attack_horn		路径： [string "scripts/prefabs/gnarwail.lua"]	
	Tags▼	
	{":", "gnarwail", "_health", "inspectable", "hostile", "_combat", "soulless"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gnarwail")	
			inst.AnimState:SetBuild("gnarwail_build")	
			Anim路径 :  "anim/gnarwail.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("death")	
------------------------------------------------	
煮熟的三文鱼			预设: quagmire_salmon_cooked		路径： [string "scripts/prefabs/quagmire_fish.lua"]	
	Tags▼	
	{":", "meat", "quagmire_stewable", "catfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_salmon")	
			inst.AnimState:SetBuild("quagmire_salmon")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
MISSING NAME			预设: walter_campfire_story_proxy		路径： [string "scripts/prefabs/walter.lua"]	
	Tags▼	
	{":", "NOBLOCK", "sanityaura"}	
 	
	使用的组件▼	
		inst:AddComponent("sanityaura")	
		
------------------------------------------------	
MISSING NAME			预设: book_horticulture_spell		路径： [string "scripts/prefabs/books.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜辣椒炖肉			预设: hotchili_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
战斗头盔			预设: wathgrithrhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wathgrithrhat")	
			inst.AnimState:SetBuild("hat_wathgrithr")	
			Anim路径 :  "anim/hat_wathgrithr.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("armor")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: halloween_firepuff_3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽箱子			预设: pandoraschest		路径： [string "scripts/prefabs/treasurechest.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "chest", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pandoras_chest")	
			inst.AnimState:SetBuild("pandoras_chest")	
			Anim路径 :  "anim/pandoras_chest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("resetruins")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
蓝蘑菇帽			预设: blue_mushroomhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blue_mushroomhat")	
			inst.AnimState:SetBuild("hat_blue_mushroom")	
			Anim路径 :  "anim/hat_blue_mushroom.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("waterproofer")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
石蟹			预设: quagmire_pebblecrab		路径： [string "scripts/prefabs/quagmire_pebblecrab.lua"]	
	Tags▼	
	{":", "crab", "small_livestock", "smallcreature", "canbetrapped", "prey", "cattoy", "show_spoilage", "animal"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
唤月者魔杖			预设: opalstaff		路径： [string "scripts/prefabs/staff.lua"]	
	Tags▼	
	{":", "_inventoryitem", "castonpoint", "inspectable", "allow_action_on_impassable", "castonpointwater", "_equippable", "nopunch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("staffs")	
			inst.AnimState:SetBuild("staffs")	
			Anim路径 :  "anim/staffs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("spellcaster")	
		inst:AddComponent("reticule")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
月树苗			预设: moonbutterfly_sapling		路径： [string "scripts/prefabs/planted_tree.lua"]	
	Tags▼	
	{":", "inspectable", "moon_tree", "plant", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("baby_moon_tree")	
			inst.AnimState:SetBuild("baby_moon_tree")	
			Anim路径 :  "anim/baby_moon_tree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("timer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onextinguish")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_bloomhealbuff		路径： [string "scripts/prefabs/lavaarena_blooms.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: minotaur_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
MISSING NAME			预设: krampuswarning_lvl1		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
捕鸟陷阱			预设: birdtrap		路径： [string "scripts/prefabs/birdtrap.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "trap"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("birdtrap")	
			inst.AnimState:SetBuild("birdtrap")	
			Anim路径 :  "anim/birdtrap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trap")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("timer")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: battlesong_detach		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: book_fx_mount		路径： [string "scripts/prefabs/book_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("book_fx")	
			inst.AnimState:SetBuild("book_fx")	
			Anim路径 :  "anim/book_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
脓鼻涕			预设: phlegm		路径： [string "scripts/prefabs/phlegm.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "_stackable", "badfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("phlegm")	
			inst.AnimState:SetBuild("phlegm")	
			Anim路径 :  "anim/phlegm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_fest_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	

------------------------------------------------	
石头汤			预设: quagmire_food_012		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: goosplash6		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
痒痒挠			预设: trinket_20		路径： [string "scripts/prefabs/trinkets.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
女王雕塑			预设: chesspiece_muse		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_muse_marble")	
			Anim路径 :  "anim/chesspiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("shadowchessroar")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
咸的华夫饼			预设: waffles_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
种下的簇状种子			预设: farm_plant_corn		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "farm_plant_corn", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_corn_build")	
			Anim路径 :  "anim/farm_plant_pumpkin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
MISSING NAME			预设: meatrack_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_rack")	
			inst.AnimState:SetBuild("meat_rack")	
			Anim路径 :  "anim/meat_rack.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
红羽浮标			预设: oceanfishingbobber_robin		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_robin_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的海鲜牛排			预设: surfnturf_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
咸的蓬松土豆蛋奶酥			预设: potatosouffle_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_antlion		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: shadowwatcher		路径： [string "scripts/prefabs/shadowwatcher.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_creatures_ground")	
			Anim路径 :  "anim/shadow_creatures_ground.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("nightvision")	
		inst:ListenForEvent("enterlight")	
------------------------------------------------	
尖刺			预设: bramblefx_armor		路径： [string "scripts/prefabs/bramblefx.lua"]	
	Tags▼	
	{":", "fx", "thorny"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bramblefx")	
			inst.AnimState:SetBuild("bramblefx")	
			Anim路径 :  "anim/bramblefx.zip"	
 	
	使用的组件▼	
		inst:AddComponent("updatelooper")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	

------------------------------------------------	
蓝宝石徽章			预设: quagmire_coin2		路径： [string "scripts/prefabs/quagmire_coins.lua"]	
	Tags▼	
	{":", "quagmire_coin"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_gym_direction_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_direction_build")	
			Anim路径 :  "anim/yotc_carrat_gym_direction.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
农田杂物			预设: farm_soil_debris		路径： [string "scripts/prefabs/farm_soil_debris.lua"]	
	Tags▼	
	{":", "inspectable", "farm_plant_killjoy", "farm_debris", "DIG_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_soil_debris")	
			inst.AnimState:SetBuild("farm_soil_debris")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	

------------------------------------------------	
MISSING NAME			预设: quagmire_planted_soil_front		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("quagmire_soil")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
远古宝箱			预设: sacred_chest		路径： [string "scripts/prefabs/sacred_chest.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "chest"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sacred_chest")	
			inst.AnimState:SetBuild("sacred_chest")	
			Anim路径 :  "anim/sacred_chest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
爬行恐惧			预设: crawlinghorror		路径： [string "scripts/prefabs/shadowcreature.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "shadow", "hostile", "_combat", "locomotor", "gestaltnoloot", "sanityaura", "shadowcreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_insanity1_basic")	
			Anim路径 :  "anim/shadow_insanity1_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("transparentonsanity")	
		inst:AddComponent("shadowsubmissive")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("death")	
	SG = 有▼	

------------------------------------------------	
MISSING NAME			预设: lavaarena_lootbeacon		路径： [string "scripts/prefabs/lavaarena_lootbeacon.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: balloonparty_confetti_balloon		路径： [string "scripts/prefabs/balloonparty.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wes_balloon_party")	
			inst.AnimState:SetBuild("wes_balloon_party")	
			Anim路径 :  "anim/wes_balloon_party.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: moon_altar_link_fx_spawner		路径： [string "scripts/prefabs/moon_altar.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_carrat_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: thurible_smoke		路径： [string "scripts/prefabs/thurible_smoke.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
惊心独白			预设: battlesong_instant_panic		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "battlesong", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("battlesongs")	
			inst.AnimState:SetBuild("battlesongs")	
			Anim路径 :  "anim/battlesongs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("singable")	
		inst:AddComponent("fuel")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: rainometer_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rain_meter")	
			inst.AnimState:SetBuild("rain_meter")	
			Anim路径 :  "anim/rain_meter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
甜无花果烤串			预设: figkabab_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: alterguardian_hat_equipped_client		路径： [string "scripts/prefabs/alterguardian_hat_equipped...."]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fish_box_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fish_box")	
			inst.AnimState:SetBuild("fish_box")	
			Anim路径 :  "anim/fish_box.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蒜香水果圣代			预设: fruitmedley_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: reticulelongmultiping		路径： [string "scripts/prefabs/reticulelong.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticulelong")	
			inst.AnimState:SetBuild("reticulelong")	
			Anim路径 :  "anim/reticulelong.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
辣冰淇淋			预设: icecream_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
玻璃尖刺			预设: glassspike_tall		路径： [string "scripts/prefabs/glass_spike.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sand_spike")	
			inst.AnimState:SetBuild("sand_spike")	
			Anim路径 :  "anim/sand_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
正式款式碎片			预设: yotb_pattern_fragment_2		路径： [string "scripts/prefabs/yotb_pattern_fragments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "yotb_pattern_fragment", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_pattern_fragment_2")	
			Anim路径 :  "anim/yotb_pattern_fragment_2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
树精守卫			预设: leif		路径： [string "scripts/prefabs/leif.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "idle", "tree", "hostile", "_combat", "locomotor", "sanityaura", "epic", "nolight", "evergreens", "largecreature", "leif", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("leif")	
			inst.AnimState:SetBuild("leif_build")	
			Anim路径 :  "anim/leif_idles.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
种下的球茎状种子			预设: farm_plant_dragonfruit		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "farmplantstress", "farm_plant_dragonfruit", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_dragonfruit_build")	
			Anim路径 :  "anim/farm_plant_potato.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplantstress")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("workable")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("loot_prefab_spawned")	
		inst:ListenForEvent("on_planted")	
------------------------------------------------	
皇家地毯			预设: mermthrone		路径： [string "scripts/prefabs/mermthrone.lua"]	
	Tags▼	
	{":", "inspectable", "mermthrone", "HAMMER_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_king_carpet")	
			inst.AnimState:SetBuild("merm_king_carpet")	
			Anim路径 :  "anim/merm_king_carpet.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("onmermkingcreated")	
		inst:ListenForEvent("onmermkingdestroyed")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
波兰水饺			预设: perogies		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: gestalt_guard_head		路径： [string "scripts/prefabs/gestalt_head.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt_head_evolved")	
			inst.AnimState:SetBuild("brightmare_gestalt_head_evolved")	
			Anim路径 :  "anim/brightmare_gestalt_head_evolved.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: weregoose_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
礼物包装			预设: giftwrap		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gift")	
			inst.AnimState:SetBuild("gift")	
			Anim路径 :  "anim/gift.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("bundlemaker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
石笋			预设: stalagmite_med		路径： [string "scripts/prefabs/stalagmite.lua"]	
	Tags▼	
	{":", "inspectable", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock_stalagmite")	
			inst.AnimState:SetBuild("rock_stalagmite")	
			Anim路径 :  "anim/rock_stalagmite.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
甜蔬菜杂烩			预设: ratatouille_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: dug_marsh_bush_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_bush")	
			inst.AnimState:SetBuild("marsh_bush")	
			Anim路径 :  "anim/marsh_bush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
好肉汁			预设: gravy		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "wintersfeastcookedfood", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("food_winters_feast_2019")	
			inst.AnimState:SetBuild("food_winters_feast_2019")	
			Anim路径 :  "anim/food_winters_feast_2019.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: abigail_attack_fx_ground		路径： [string "scripts/prefabs/abigail_attack_fx.lua"]	
	Tags▼	
	{":", "FROMNUM"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_attack_fx")	
			inst.AnimState:SetBuild("abigail_attack_fx")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
聪明的伪装			预设: mermhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "open_top_hat", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mermhat")	
			inst.AnimState:SetBuild("hat_merm")	
			Anim路径 :  "anim/hat_merm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
猫尾			预设: coontail		路径： [string "scripts/prefabs/coontail.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("coontail")	
			inst.AnimState:SetBuild("coontail")	
			Anim路径 :  "anim/coontail.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
尘土块			预设: refined_dust		路径： [string "scripts/prefabs/refined_dust.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_ELEMENTAL"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("refined_dust")	
			inst.AnimState:SetBuild("refined_dust")	
			Anim路径 :  "anim/refined_dust.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("bait")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
农作物			预设: quagmire_turnip_planted		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "plantedsoil", "fertilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
黄昏匙型假饵			预设: oceanfishinglure_spoon_green		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_lure_spoon")	
			inst.AnimState:SetBuild("oceanfishing_lure_spoon")	
			Anim路径 :  "anim/oceanfishing_lure_spoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
战旗			预设: lavaarena_battlestandard_damager		路径： [string "scripts/prefabs/lavaarena_battlestandard.lu..."]	
	Tags▼	
	{":", "battlestandard", "LA_mob"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
伊格内修斯			预设: pigelitefighter2		路径： [string "scripts/prefabs/pigelitefighter.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "pig", "idle", "noepicmusic", "_combat", "locomotor", "scarytoprey", "nolight", "_follower", "pigelite", "ignorewalkableplatformdrowning", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("pig_guard_build")	
			Anim路径 :  "anim/ds_pig_elite.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("talker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("burnable")	
		inst:AddComponent("timer")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("blocked")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("newcombattarget")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: torchfire_spooky		路径： [string "scripts/prefabs/torchfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: penguin_ice		路径： [string "scripts/prefabs/penguin_ice.lua"]	
	Tags▼	
	{":", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_fossilizedebris1		路径： [string "scripts/prefabs/lavaarena_fossilizing.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_fossilizedebris"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: alterguardian_phase3trapgroundfx		路径： [string "scripts/prefabs/alterguardian_phase3trap.lu..."]	
	Tags▼	
	{":", "DECOR", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_meteor")	
			inst.AnimState:SetBuild("alterguardian_meteor")	
			Anim路径 :  "anim/alterguardian_meteor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
辣生鲜萨尔萨酱			预设: salsa_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
裸鼹鼠蝙蝠山丘			预设: molebathill		路径： [string "scripts/prefabs/molebathill.lua"]	
	Tags▼	
	{":", "inspectable", "molebathill", "DIG_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("molebathill")	
			Anim路径 :  "anim/molebathill.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("suckedup")	
------------------------------------------------	
岩石海滩地皮			预设: turf_pebblebeach		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf_moon")	
			inst.AnimState:SetBuild("turf_moon")	
			Anim路径 :  "anim/turf_moon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: year_of_the_gobbler_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: green_leaves		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: reticuleaoesmall		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
波兰饼干			预设: polishcookie		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "wintersfeastcookedfood", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("food_winters_feast_2019")	
			inst.AnimState:SetBuild("food_winters_feast_2019")	
			Anim路径 :  "anim/food_winters_feast_2019.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
龙卷风			预设: tornado		路径： [string "scripts/prefabs/staff_tornado.lua"]	
	Tags▼	
	{":", "idle", "locomotor"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tornado")	
			inst.AnimState:SetBuild("tornado")	
			Anim路径 :  "anim/tornado.zip"	
 	
	使用的组件▼	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		
	SG = 有▼	
------------------------------------------------	
烤茄子			预设: eggplant_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eggplant")	
			inst.AnimState:SetBuild("eggplant")	
			Anim路径 :  "anim/eggplant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
神秘能量			预设: moon_altar_link		路径： [string "scripts/prefabs/moon_altar_link.lua"]	
	Tags▼	
	{":", "inspectable", "NOBLOCK", "moon_altar_link"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moon_geyser")	
			Anim路径 :  "anim/moon_geyser.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("moonaltarlink")	
		inst:AddComponent("entitytracker")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_moonstormwindowover")	
------------------------------------------------	
耐力健身房			预设: yotc_carrat_gym_stamina		路径： [string "scripts/prefabs/rat_gym.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "_inventory", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_stamina_build")	
			Anim路径 :  "anim/yotc_carrat_gym_stamina.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("workable")	
		inst:AddComponent("shelf")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("gym")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("musicstatedirty")	
		inst:ListenForEvent("itemlose")	
	SG = 有▼	
------------------------------------------------	
叽叽喳喳围巾			预设: carnival_vest_a		路径： [string "scripts/prefabs/carnival_vest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_vest_a")	
			inst.AnimState:SetBuild("carnival_vest_a")	
			Anim路径 :  "anim/carnival_vest_a.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("insulator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: abigaillevelupfx		路径： [string "scripts/prefabs/abigail_flower.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_flower_change")	
			inst.AnimState:SetBuild("abigail_flower_rework")	
			Anim路径 :  "anim/abigail_flower_change.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
麋鹿茸			预设: klaussackkey		路径： [string "scripts/prefabs/deer_antler.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "deerantler", "klaussackkey", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_antler")	
			inst.AnimState:SetBuild("deer_antler")	
			Anim路径 :  "anim/deer_antler.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("klaussackkey")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蜂巢			预设: honeycomb		路径： [string "scripts/prefabs/honeycomb.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("honeycomb")	
			inst.AnimState:SetBuild("honeycomb")	
			Anim路径 :  "anim/honeycomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
绿色孢子			预设: spore_small		路径： [string "scripts/prefabs/mushtree_spores.lua"]	
	Tags▼	
	{":", "_inventoryitem", "busy", "spore", "inspectable", "_stackable", "locomotor", "NET_workable", "canlight", "show_spoilage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_spore")	
			inst.AnimState:SetBuild("mushroom_spore")	
			Anim路径 :  "anim/mushroom_spore.zip"	
 	
	使用的组件▼	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("workable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
巨型腐烂芦笋			预设: asparagus_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_asparagus")	
			inst.AnimState:SetBuild("farm_plant_asparagus")	
			Anim路径 :  "anim/farm_plant_asparagus.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
素食堡			预设: leafymeatburger		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food4")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: archive_security_waypoint		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":", "NOBLOCK", "archive_waypoint"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: none_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜生鲜萨尔萨酱			预设: salsa_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: nightlight_flame		路径： [string "scripts/prefabs/nightlight_flame.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("campfire_fire")	
			inst.AnimState:SetBuild("campfire_fire")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("firefx")	
		
------------------------------------------------	
烤蓝蘑菇			预设: blue_cap_cooked		路径： [string "scripts/prefabs/mushrooms.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "BURNABLE_fuel", "badfood", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushrooms")	
			inst.AnimState:SetBuild("mushrooms")	
			Anim路径 :  "anim/mushrooms.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("spawnedfromhaunt")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: positronbeam_front		路径： [string "scripts/prefabs/positronbeam.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moonbase_fx")	
			Anim路径 :  "anim/moonbase_fx.zip"	
 	
	使用的组件▼	

------------------------------------------------	
大份炖菜			预设: quagmire_casseroledish		路径： [string "scripts/prefabs/quagmire_casseroledish.lua"]	
	Tags▼	
	{":", "quagmire_stewer", "quagmire_casseroledish"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_casseroledish")	
			inst.AnimState:SetBuild("quagmire_casseroledish")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
麦斯威尔			预设: waxwell		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "dappereffects", "player", "idle", "_builder", "_sanity", "_inventory", "reader", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "shadowmagic", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("waxwell")	
			Anim路径 :  "anim/player_idles.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("sandstormwatcher")	
		inst:AddComponent("colouradder")	
		inst:AddComponent("maprevealable")	
		inst:AddComponent("walkingplankuser")	
		inst:AddComponent("stormwatcher")	
		inst:AddComponent("moisture")	
		inst:AddComponent("propagator")	
		inst:AddComponent("distancetracker")	
		inst:AddComponent("hunger")	
		inst:AddComponent("sleepingbaguser")	
		inst:AddComponent("talker")	
		inst:AddComponent("playerlightningtarget")	
		inst:AddComponent("sanity")	
		inst:AddComponent("age")	
		inst:AddComponent("temperature")	
		inst:AddComponent("constructionbuilderuidata")	
		inst:AddComponent("playerinspectable")	
		inst:AddComponent("drownable")	
		inst:AddComponent("colourtweener")	
		inst:AddComponent("grue")	
		inst:AddComponent("freezable")	
		inst:AddComponent("skinner")	
		inst:AddComponent("walkableplatformplayer")	
		inst:AddComponent("builder")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("cookbookupdater")	
		inst:AddComponent("sheltered")	
		inst:AddComponent("steeringwheeluser")	
		inst:AddComponent("pinnable")	
		inst:AddComponent("trader")	
		inst:AddComponent("bundler")	
		inst:AddComponent("carefulwalker")	
		inst:AddComponent("hudindicatable")	
		inst:AddComponent("catcher")	
		inst:AddComponent("frostybreather")	
		inst:AddComponent("constructionbuilder")	
		inst:AddComponent("singingshelltrigger")	
		inst:AddComponent("foodaffinity")	
		inst:AddComponent("playervision")	
		inst:AddComponent("eater")	
		inst:AddComponent("timer")	
		inst:AddComponent("inkable")	
		inst:AddComponent("reader")	
		inst:AddComponent("combat")	
		inst:AddComponent("plantregistryupdater")	
		inst:AddComponent("leader")	
		inst:AddComponent("embarker")	
		inst:AddComponent("giftreceiver")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("touchstonetracker")	
		inst:AddComponent("moonstormwatcher")	
		inst:AddComponent("areaaware")	
		inst:AddComponent("playeravatardata")	
		inst:AddComponent("grogginess")	
		inst:AddComponent("debuffable")	
		inst:AddComponent("workmultiplier")	
		inst:AddComponent("petleash")	
		inst:AddComponent("rider")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("wisecracker")	
		inst:AddComponent("spooked")	
		inst:AddComponent("birdattractor")	
		inst:AddComponent("attuner")	
		inst:AddComponent("bloomer")	
		
	使用的监听▼	
		inst:ListenForEvent("playerdied")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("startfreezing")	
		inst:ListenForEvent("mountwounded")	
		inst:ListenForEvent("actionfailed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("changearea")	
		inst:ListenForEvent("unequip")	
		inst:ListenForEvent("townportalteleport")	
		inst:ListenForEvent("stormlevel")	
		inst:ListenForEvent("digdiseasing")	
		inst:ListenForEvent("thorns")	
		inst:ListenForEvent("ms_playerreroll")	
		inst:ListenForEvent("ghostdissipated")	
		inst:ListenForEvent("enableboatcamera")	
		inst:ListenForEvent("underleafcanopydirty")	
		inst:ListenForEvent("learncookbookrecipe")	
		inst:ListenForEvent("on_halloweenmoonpotion_failed")	
		inst:ListenForEvent("accomplishment_done")	
		inst:ListenForEvent("playeractivated")	
		inst:ListenForEvent("burnt")	
		inst:ListenForEvent("sharksounddirty")	
		inst:ListenForEvent("respawnfromghost")	
		inst:ListenForEvent("unpinned")	
		inst:ListenForEvent("ms_becameghost")	
		inst:ListenForEvent("repelled")	
		inst:ListenForEvent("done_embark_movement")	
		inst:ListenForEvent("onareaattackother")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("sheltered")	
		inst:ListenForEvent("localplayer._hermit_music")	
		inst:ListenForEvent("heargrue")	
		inst:ListenForEvent("onstartedfire")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("onchangecanopyzone")	
		inst:ListenForEvent("ghostdelta")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("takeoversizedpicture")	
		inst:ListenForEvent("setowner")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("learnfertilizer")	
		inst:ListenForEvent("lightningdamageavoided")	
		inst:ListenForEvent("unevengrounddetected")	
		inst:ListenForEvent("coveredinbees")	
		inst:ListenForEvent("startoverheating")	
		inst:ListenForEvent("itemranout")	
		inst:ListenForEvent("startfiredamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("learncookbookstats")	
		inst:ListenForEvent("killed")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("working")	
		inst:ListenForEvent("wonteatfood")	
		inst:ListenForEvent("snared")	
		inst:ListenForEvent("dropitem")	
		inst:ListenForEvent("picksomething")	
		inst:ListenForEvent("accomplishment")	
		inst:ListenForEvent("resistedgrue")	
		inst:ListenForEvent("ms_closepopup")	
		inst:ListenForEvent("attackedbygrue")	
		inst:ListenForEvent("wormholespit")	
		inst:ListenForEvent("makeplayerghost")	
		inst:ListenForEvent("inventoryfull")	
		inst:ListenForEvent("usedtouchstone")	
		inst:ListenForEvent("equip")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("insufficientfertilizer")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("foodbuffdetached")	
		inst:ListenForEvent("foodbuffattached")	
		inst:ListenForEvent("hungrybuild")	
		inst:ListenForEvent("encumberedwalking")	
		inst:ListenForEvent("huntlosttrail")	
		inst:ListenForEvent("on_standing_on_new_leak")	
		inst:ListenForEvent("onpresink")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("pickdiseasing")	
		inst:ListenForEvent("huntbeastnearby")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("enablemovementprediction")	
		inst:ListenForEvent("localplayer._winters_feast_music")	
		inst:ListenForEvent("spooked")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("newactiveitem")	
	SG = 有▼	
------------------------------------------------	
木甲			预设: armorwood		路径： [string "scripts/prefabs/armor_wood.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight", "_equippable", "wood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_wood")	
			inst.AnimState:SetBuild("armor_wood")	
			Anim路径 :  "anim/armor_wood.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("armor")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
空鸟嘴壶			预设: premiumwateringcan		路径： [string "scripts/prefabs/wateringcan.lua"]	
	Tags▼	
	{":", "usesdepleted", "_inventoryitem", "inspectable", "wateringcan", "fillable", "BURNABLE_fuel", "canlight", "_equippable", "fillable_showoceanaction", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("premiumwateringcan")	
			inst.AnimState:SetBuild("premiumwateringcan")	
			Anim路径 :  "anim/premiumwateringcan.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("fillable")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: moon_altar_claw_break		路径： [string "scripts/prefabs/moon_altar_break.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_altar_claw_break")	
			inst.AnimState:SetBuild("moon_altar_claw_break")	
			Anim路径 :  "anim/moon_altar_claw_break.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: researchlab4_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab4")	
			inst.AnimState:SetBuild("researchlab4")	
			Anim路径 :  "anim/researchlab4.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
大触手			预设: tentacle_pillar		路径： [string "scripts/prefabs/tentacle_pillar.lua"]	
	Tags▼	
	{":", "cavedweller", "_health", "inspectable", "wet", "tentacle_pillar", "_combat", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("tentacle_pillar")	
			Anim路径 :  "anim/tentacle_pillar.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("combat")	
		inst:AddComponent("teleporter")	
		inst:AddComponent("playerprox")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: attunable_classified		路径： [string "scripts/prefabs/attunable_classified.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: siestahut_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("siesta_canopy")	
			inst.AnimState:SetBuild("siesta_canopy")	
			Anim路径 :  "anim/siesta_canopy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: slingshotammo_gold_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
	Tags▼	
	{":", "projectile", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshotammo")	
			inst.AnimState:SetBuild("slingshotammo")	
			Anim路径 :  "anim/slingshotammo.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		inst:AddComponent("weapon")	
		
------------------------------------------------	
鹅羽浮标			预设: oceanfishingbobber_goose_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_goose_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
MISSING NAME			预设: pillar_algae		路径： [string "scripts/prefabs/pillar.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_algae")	
			inst.AnimState:SetBuild("pillar_algae")	
			Anim路径 :  "anim/pillar_algae.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pigshrine_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigshrine")	
			inst.AnimState:SetBuild("pigshrine")	
			Anim路径 :  "anim/pigshrine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
驱赶盒子			预设: spider_repellent		路径： [string "scripts/prefabs/spider_repellent.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_repellent")	
			inst.AnimState:SetBuild("spider_repellent")	
			Anim路径 :  "anim/spider_repellent.zip"	
 	
	使用的组件▼	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("repellent")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
牛肉绿叶菜			预设: meatysalad		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food4")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: firepit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firepit")	
			inst.AnimState:SetBuild("firepit")	
			Anim路径 :  "anim/firepit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
神秘植物			预设: stalker_berry		路径： [string "scripts/prefabs/stalker_berry.lua"]	
	Tags▼	
	{":", "stalkerbloom", "inspectable", "plant", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("forest_glowberry")	
			inst.AnimState:SetBuild("forest_glowberry")	
			Anim路径 :  "anim/forest_glowberry.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
高出平均值的树干			预设: oceantree_pillar		路径： [string "scripts/prefabs/oceantree_pillar.lua"]	
	Tags▼	
	{":", "lightningblocker", "inspectable", "event_trigger", "CHOP_workable", "canlight", "shadecanopysmall", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceantree_pillar_small_build1")	
			Anim路径 :  "anim/oceantree_pillar_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("distancefade")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("lightningblocker")	
		
	使用的监听▼	
		inst:ListenForEvent("hascanopydirty")	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: reticuleaoehostiletarget		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
土豆饼			预设: latkes		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "wintersfeastcookedfood", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("food_winters_feast_2019")	
			inst.AnimState:SetBuild("food_winters_feast_2019")	
			Anim路径 :  "anim/food_winters_feast_2019.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: oceantree_pillar_ripples		路径： [string "scripts/prefabs/oceantree_pillar.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceantree_pillar_small_build1")	
			Anim路径 :  "anim/oceantree_pillar_small.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
农作物			预设: plant_normal		路径： [string "scripts/prefabs/plant_normal.lua"]	
	Tags▼	
	{":", "inspectable", "NPC_workable", "notreadyforharvest", "DIG_workable", "canlight", "witherable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plant_normal")	
			inst.AnimState:SetBuild("plant_normal")	
			Anim路径 :  "anim/plant_normal.zip"	
 	
	使用的组件▼	
		inst:AddComponent("crop")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("witherable")	
		
	使用的监听▼	
		inst:ListenForEvent("onhalloweenmoonmutate")	
------------------------------------------------	
MISSING NAME			预设: gargoyle_hounddeath_fx		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
                  Failed to spawn	quagmirestage_delay	
------------------------------------------------	
热带草原地皮			预设: turf_savanna		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf")	
			inst.AnimState:SetBuild("turf")	
			Anim路径 :  "anim/turf.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: winters_feast_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
------------------------------------------------	
屠杀工具			预设: quagmire_slaughtertool		路径： [string "scripts/prefabs/quagmire_slaughtertool.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_slaughtertool")	
			inst.AnimState:SetBuild("quagmire_slaughtertool")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: abigail_vex_hit		路径： [string "scripts/prefabs/abigail.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_debuff_fx")	
			inst.AnimState:SetBuild("abigail_debuff_fx")	
			Anim路径 :  "anim/abigail_debuff_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_small_4		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
尖刺灌木			预设: dug_marsh_bush		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_bush")	
			inst.AnimState:SetBuild("marsh_bush")	
			Anim路径 :  "anim/marsh_bush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
波兰水饺			预设: quagmire_food_050		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香辣龙椒沙拉			预设: dragonchilisalad_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "edible_VEGGIE", "badfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
荧光花			预设: stalker_bulb		路径： [string "scripts/prefabs/stalker_bulb.lua"]	
	Tags▼	
	{":", "stalkerbloom", "inspectable", "plant", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bulb_plant_single")	
			inst.AnimState:SetBuild("bulb_plant_single")	
			Anim路径 :  "anim/bulb_plant_single.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
烤洋葱			预设: onion_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("onion")	
			inst.AnimState:SetBuild("onion")	
			Anim路径 :  "anim/onion.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	

------------------------------------------------	
大锅			预设: quagmire_pot		路径： [string "scripts/prefabs/quagmire_pot.lua"]	
	Tags▼	
	{":", "quagmire_pot", "quagmire_stewer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_pot")	
			inst.AnimState:SetBuild("quagmire_pot")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
李子布丁			预设: winter_food6		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "wintersfeastfood", "_stackable", "edible_VEGGIE", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
辣蓝带鱼排			预设: frogfishbowl_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "masterfood", "badfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lucy_ground_transform_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: reticule		路径： [string "scripts/prefabs/reticule.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticule")	
			inst.AnimState:SetBuild("reticule")	
			Anim路径 :  "anim/reticule.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lightning_rod_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lightning_rod")	
			inst.AnimState:SetBuild("lightning_rod")	
			Anim路径 :  "anim/lightning_rod.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
岩石			预设: rock_flintless_med		路径： [string "scripts/prefabs/rocks.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock_flintless")	
			inst.AnimState:SetBuild("rock_flintless")	
			Anim路径 :  "anim/rock_flintless.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
小浣猫			预设: critter_kitten		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "idle", "small_livestock", "NOBLOCK", "locomotor", "OMNI_eater", "_follower", "critter", "sleeper", "noauradamage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("kittington_build")	
			Anim路径 :  "anim/kittington_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("crittertraits")	
		inst:AddComponent("perishable")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("eater")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("timer")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	

------------------------------------------------	
MISSING NAME			预设: firehit		路径： [string "scripts/prefabs/firehits.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣培根煎蛋			预设: baconeggs_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plate_food")	
			inst.AnimState:SetBuild("plate_food")	
			Anim路径 :  "anim/plate_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: deer_growantler_fx		路径： [string "scripts/prefabs/deer.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("deer_build")	
			Anim路径 :  "anim/deer_unshackle.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_carrat_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
邪天翁			预设: malbatross		路径： [string "scripts/prefabs/malbatross.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "malbatross", "_inventory", "noepicmusic", "_combat", "locomotor", "epic", "scarytoprey", "nolight", "flying", "largecreature", "ignorewalkableplatformdrowning", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("malbatross")	
			inst.AnimState:SetBuild("malbatross_build")	
			Anim路径 :  "anim/malbatross_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("timer")	
		inst:AddComponent("inventory")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("ms_playerjoined")	
		inst:ListenForEvent("ms_playerleft")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("performaction")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("losttarget")	
		inst:ListenForEvent("droppedtarget")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
```
