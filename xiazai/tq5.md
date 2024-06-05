> 摘录う丶青木
- 数据提取5

```lua	
保鲜背包			预设: icepack		路径： [string "scripts/prefabs/icepack.lua"]	
	Tags▼	
	{":", "_inventoryitem", "backpack", "inspectable", "nocool", "_container", "fridge", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("icepack")	
			inst.AnimState:SetBuild("swap_icepack")	
			Anim路径 :  "anim/swap_icepack.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("itemget")	
------------------------------------------------	
农作物			预设: quagmire_wheat_planted		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "plantedsoil", "fertilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fossilspike2_base		路径： [string "scripts/prefabs/fossil_spike2.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fossil_spike2")	
			inst.AnimState:SetBuild("fossil_spike2")	
			Anim路径 :  "anim/fossil_spike2.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: bundle_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ruinsrelic_bowl_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_bowl")	
			inst.AnimState:SetBuild("ruins_bowl")	
			Anim路径 :  "anim/ruins_bowl.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
胡萝卜			预设: carrot		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "halloweenmoonmutable", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carrot")	
			inst.AnimState:SetBuild("carrot")	
			Anim路径 :  "anim/carrot.zip"	
 	
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
避雷导线			预设: mastupgrade_lightningrod_item		路径： [string "scripts/prefabs/mastupgrade_lightningrod.lu..."]	
	Tags▼	
	{":", "_inventoryitem", "mast_upgrader", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mastupgrade_lightningrod_item")	
			inst.AnimState:SetBuild("mastupgrade_lightningrod")	
			Anim路径 :  "anim/mastupgrade_lightningrod.zip"	
 	
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
MISSING NAME			预设: reticuleaoesummontarget		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: signleft		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
鸟鸟吃虫虫套装			预设: carnivalgame_feedchicks_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_feedchicks_station")	
			inst.AnimState:SetBuild("carnivalgame_feedchicks_station")	
			Anim路径 :  "anim/carnivalgame_feedchicks_station.zip"	
 	
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
MISSING NAME			预设: gooball_projectile		路径： [string "scripts/prefabs/fireball_projectile.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
奇异的骨架			预设: fossil_stalker		路径： [string "scripts/prefabs/fossil_mound.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "workrepairable", "repairable_fossil", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fossil_stalker")	
			inst.AnimState:SetBuild("fossil_stalker")	
			Anim路径 :  "anim/fossil_stalker.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("repairable")	
------------------------------------------------	
MISSING NAME			预设: beefalo_groomer_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo_wardrobe")	
			inst.AnimState:SetBuild("beefalo_wardrobe")	
			Anim路径 :  "anim/beefalo_wardrobe.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_plain11		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
椭圆形种子			预设: quagmire_seeds_6		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
铥矿甲			预设: armorruins		路径： [string "scripts/prefabs/armor_ruins.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "metal", "ruins", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_ruins")	
			inst.AnimState:SetBuild("armor_ruins")	
			Anim路径 :  "anim/armor_ruins.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("armor")	
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
牛角帽			预设: beefalohat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalohat")	
			inst.AnimState:SetBuild("hat_beefalo")	
			Anim路径 :  "anim/hat_beefalo.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("fueled")	
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
MISSING NAME			预设: critterbuff_lunarmoth		路径： [string "scripts/prefabs/critterbuff_lunarmoth.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fossil_piece_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fossil_stalker")	
			inst.AnimState:SetBuild("fossil_stalker")	
			Anim路径 :  "anim/fossil_stalker.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: spore_moon_coughout		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
月盲乌鸦			预设: bird_mutant		路径： [string "scripts/prefabs/birds_mutant.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "monster", "_health", "SEEDS_eater", "freezable", "idle", "small_livestock", "hostile", "NOBLOCK", "_combat", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "show_spoilage", "soulless", "sleeper", "bird_mutant", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mutated_crow")	
			inst.AnimState:SetBuild("bird_mutant_build")	
			Anim路径 :  "anim/mutated_crow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("occupier")	
		inst:AddComponent("propagator")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("timer")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("losttarget")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("droppedtarget")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: miniboatlanternlight		路径： [string "scripts/prefabs/miniboatlantern.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型芦笋			预设: asparagus_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_asparagus")	
			inst.AnimState:SetBuild("farm_plant_asparagus")	
			Anim路径 :  "anim/farm_plant_asparagus.zip"	
 	
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
反应健身房套装			预设: yotc_carrat_gym_reaction_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_gym_reaction_item")	
			inst.AnimState:SetBuild("yotc_carrat_gym_reaction_item")	
			Anim路径 :  "anim/yotc_carrat_gym_reaction_item.zip"	
 	
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
MISSING NAME			预设: halloweenpotion_sparks_buff		路径： [string "scripts/prefabs/halloweenpotion_embers.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_embers")	
			inst.AnimState:SetBuild("halloween_embers")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: wood_splinter_drill		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蕨类盆栽			预设: pottedfern		路径： [string "scripts/prefabs/pottedfern.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "HAMMER_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cave_ferns_potted")	
			Anim路径 :  "anim/cave_ferns_potted.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: werebeaver_transform_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lighterfire		路径： [string "scripts/prefabs/lighterfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
桦树地皮			预设: turf_deciduous		路径： [string "scripts/prefabs/turfs.lua"]	
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
蓝色孢子			预设: spore_tall		路径： [string "scripts/prefabs/mushtree_spores.lua"]	
	Tags▼	
	{":", "_inventoryitem", "busy", "spore", "inspectable", "_stackable", "locomotor", "NET_workable", "canlight", "show_spoilage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_spore")	
			inst.AnimState:SetBuild("mushroom_spore_blue")	
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
MISSING NAME			预设: dragonflychest_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonfly_chest")	
			inst.AnimState:SetBuild("dragonfly_chest")	
			Anim路径 :  "anim/dragonfly_chest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蝴蝶翅膀			预设: butterflywings		路径： [string "scripts/prefabs/butterflywings.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("butterfly_wings")	
			inst.AnimState:SetBuild("butterfly_wings")	
			Anim路径 :  "anim/butterfly_wings.zip"	
 	
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
鞍具			预设: saddle_basic		路径： [string "scripts/prefabs/saddle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("saddle_basic")	
			Anim路径 :  "anim/saddle_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("saddler")	
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
MISSING NAME			预设: year_of_the_varg_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
未使用			预设: oceanfishinglure_spinner_orange		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
巨型芦笋			预设: asparagus_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_asparagus")	
			inst.AnimState:SetBuild("farm_plant_asparagus")	
			Anim路径 :  "anim/farm_plant_asparagus.zip"	
 	
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
MISSING NAME			预设: spat_splash_fx_med		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
超级钓具箱			预设: supertacklecontainer		路径： [string "scripts/prefabs/tacklecontainer.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_container", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("supertacklecontainer")	
			inst.AnimState:SetBuild("supertacklecontainer")	
			Anim路径 :  "anim/supertacklecontainer.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: damp_trail		路径： [string "scripts/prefabs/damp_trail.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("damp_trail")	
			inst.AnimState:SetBuild("damp_trail")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的怪物鞑靼			预设: monstertartare_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: lantern_crystal_fx_held		路径： [string "scripts/prefabs/lantern_crystal_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lantern")	
			Anim路径 :  "anim/dynamic/lantern_crystal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
碎石			预设: rubble		路径： [string "scripts/prefabs/rubble.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rubble")	
			inst.AnimState:SetBuild("ruins_rubble")	
			Anim路径 :  "anim/ruins_rubble.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: weregoose_splash_med2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
韦伯口哨			预设: spider_whistle		路径： [string "scripts/prefabs/spider_whistle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "spider_whistle", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_whistle")	
			inst.AnimState:SetBuild("spider_whistle")	
			Anim路径 :  "anim/spider_whistle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("followerherder")	
		inst:AddComponent("propagator")	
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
锄头			预设: quagmire_hoe		路径： [string "scripts/prefabs/quagmire_hoe.lua"]	
	Tags▼	
	{":", "sharp", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_hoe")	
			inst.AnimState:SetBuild("quagmire_hoe")	
			Anim路径 :  "anim/quagmire_hoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜鲜果可丽饼			预设: freshfruitcrepes_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
Salad Furnace			预设: dragonflyfurnace		路径： [string "scripts/prefabs/dragonfurnace.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "wildfireprotected", "_named", "HAMMER_workable", "cooker", "HASHEATER", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonfly_furnace")	
			inst.AnimState:SetBuild("dragonfly_furnace")	
			Anim路径 :  "anim/dragonfly_furnace.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("cooker")	
		inst:AddComponent("workable")	
		inst:AddComponent("named")	
		inst:AddComponent("heater")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: creepyeyes		路径： [string "scripts/prefabs/creepyeyes.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyes_darkness")	
			inst.AnimState:SetBuild("eyes_darkness")	
			Anim路径 :  "anim/eyes_darkness.zip"	
 	
	使用的组件▼	
		inst:AddComponent("playerprox")	
		
	使用的监听▼	
		inst:ListenForEvent("nightvision")	
		inst:ListenForEvent("enterlight")	
------------------------------------------------	
MISSING NAME			预设: sand_puff_large_back		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
红羽浮标			预设: oceanfishingbobber_robin_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_robin_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
MISSING NAME			预设: mining_moonglass_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鳞片			预设: dragon_scales		路径： [string "scripts/prefabs/dragon_scales.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragon_scales")	
			inst.AnimState:SetBuild("dragon_scales")	
			Anim路径 :  "anim/dragon_scales.zip"	
 	
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
长矛			预设: spear		路径： [string "scripts/prefabs/spear.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "pointy", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spear")	
			inst.AnimState:SetBuild("swap_spear")	
			Anim路径 :  "anim/spear.zip"	
 	
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
主教雕塑			预设: chesspiece_bishop_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sand_puff		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
麋鹿鹅			预设: moose		路径： [string "scripts/prefabs/moose.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "_named", "idle", "moose", "_inventory", "_combat", "locomotor", "epic", "scarytoprey", "nolight", "MOOSE_eater", "largecreature", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("goosemoose_build")	
			Anim路径 :  "anim/goosemoose_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("named")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("timer")	
		inst:AddComponent("eater")	
		inst:AddComponent("health")	
		inst:AddComponent("playerprox")	
		
	使用的监听▼	
		inst:ListenForEvent("EggHatch")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
时间碎片			预设: pocketwatch_parts		路径： [string "scripts/prefabs/pocketwatch_parts.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_parts")	
			inst.AnimState:SetBuild("pocketwatch_parts")	
			Anim路径 :  "anim/pocketwatch_parts.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("bait")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("onpickup")	
------------------------------------------------	
针鼻喷墨鱼			预设: oceanfish_small_2		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_small_2", "OMNI_eater", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_2")	
			Anim路径 :  "anim/oceanfish_small.zip"	
 	
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
MISSING NAME			预设: endtable_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stagehand")	
			inst.AnimState:SetBuild("stagehand")	
			Anim路径 :  "anim/stagehand.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: carnivalcannon_sparkle_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon_sparkle")	
			Anim路径 :  "anim/carnival_cannon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
鸟鸟吃虫虫			预设: carnivalgame_feedchicks_station		路径： [string "scripts/prefabs/carnivalgame_feedchicks.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "HAMMER_workable", "carnivalgame_part", "birdblocker", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_feedchicks_station")	
			inst.AnimState:SetBuild("carnivalgame_feedchicks_station")	
			Anim路径 :  "anim/carnivalgame_feedchicks_station.zip"	
 	
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
考拉象			预设: koalefant_winter		路径： [string "scripts/prefabs/koalefant.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "_health", "inspectable", "freezable", "idle", "_combat", "locomotor", "nolight", "largecreature", "animal", "saltlicker", "sleeper", "koalefant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("koalefant")	
			inst.AnimState:SetBuild("koalefant_winter_build")	
			Anim路径 :  "anim/koalefant_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("combat")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("burnable")	
		inst:AddComponent("timer")	
		inst:AddComponent("eater")	
		inst:AddComponent("saltlicker")	
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
方向健身房			预设: yotc_carrat_gym_direction		路径： [string "scripts/prefabs/rat_gym.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "_inventory", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_direction_build")	
			Anim路径 :  "anim/yotc_carrat_gym_direction.zip"	
 	
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
辣香蕉冻			预设: bananapop_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: heatrocklight		路径： [string "scripts/prefabs/heatrock.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: hutch_move_fx		路径： [string "scripts/prefabs/lavae_move_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
格罗姆翅膀			预设: glommerwings		路径： [string "scripts/prefabs/glommerwings.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("glommer_wings")	
			inst.AnimState:SetBuild("glommer_wings")	
			Anim路径 :  "anim/glommer_wings.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("fuel")	
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
MISSING NAME			预设: boat_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_test")	
			Anim路径 :  "anim/boat_test.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: lantern_crystal_fx_ground		路径： [string "scripts/prefabs/lantern_crystal_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lantern")	
			Anim路径 :  "anim/dynamic/lantern_crystal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: explode_firecrackers		路径： [string "scripts/prefabs/explode_small.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
龙蝇			预设: dragonfly		路径： [string "scripts/prefabs/dragonfly.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "idle", "_inventory", "hostile", "noepicmusic", "_combat", "locomotor", "_moisture", "epic", "scarytoprey", "flying", "dragonfly", "largecreature", "ignorewalkableplatformdrowning", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonfly")	
			inst.AnimState:SetBuild("dragonfly_build")	
			Anim路径 :  "anim/dragonfly_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("rampingspawner")	
		inst:AddComponent("grouptargeter")	
		inst:AddComponent("freezable")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("stunnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("moisture")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("health")	
		inst:AddComponent("groundpounder")	
		inst:AddComponent("timer")	
		inst:AddComponent("healthtrigger")	
		inst:AddComponent("damagetracker")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("rampingspawner_spawn")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("rampingspawner_death")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("moisturedelta")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: weregoose_ripple2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
曼德拉草			预设: mandrake		路径： [string "scripts/prefabs/mandrake_inactive.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mandrake")	
			inst.AnimState:SetBuild("mandrake")	
			Anim路径 :  "anim/mandrake.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("cookable")	
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
MISSING NAME			预设: atrium_fence		路径： [string "scripts/prefabs/atrium_fence.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_fence")	
			inst.AnimState:SetBuild("atrium_fence")	
			Anim路径 :  "anim/atrium_fence.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("atriumpowered")	
------------------------------------------------	
辣辣椒炖肉			预设: hotchili_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
薇诺娜的投石机			预设: winona_catapult_projectile		路径： [string "scripts/prefabs/winona_catapult_projectile...."]	
	Tags▼	
	{":", "projectile", "_combat", "notarget", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_catapult_projectile")	
			inst.AnimState:SetBuild("winona_catapult_projectile")	
			Anim路径 :  "anim/winona_catapult_projectile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
MISSING NAME			预设: wormwood_plant_fx		路径： [string "scripts/prefabs/wormwood_plant_fx.lua"]	
	Tags▼	
	{":", "fx", "wormwood_plant_fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wormwood_plant_fx")	
			inst.AnimState:SetBuild("wormwood_plant_fx")	
			Anim路径 :  "anim/wormwood_plant_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
红色孢子			预设: spore_medium		路径： [string "scripts/prefabs/mushtree_spores.lua"]	
	Tags▼	
	{":", "_inventoryitem", "busy", "spore", "inspectable", "_stackable", "locomotor", "NET_workable", "canlight", "show_spoilage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_spore")	
			inst.AnimState:SetBuild("mushroom_spore_red")	
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
恐惧实验			预设: halloween_experiment_bravery		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: deerclops_lasertrail		路径： [string "scripts/prefabs/deerclops_laser.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_staff_smoke_fx")	
			inst.AnimState:SetBuild("lavaarena_staff_smoke_fx")	
			Anim路径 :  "anim/lavaarena_staff_smoke_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
寒霜皮弗娄牛玩偶			预设: yotb_beefalo_doll_ice		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
远古守护者雕塑			预设: chesspiece_minotaur_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
                  Event data unavailable: lavaarena_event_server/prefabs/spear_gungnir
------------------------------------------------	
尖齿矛			预设: spear_gungnir		路径： [string "scripts/prefabs/spear_gungnir.lua"]	
	Tags▼	
	{":", "aoeweapon_lunge", "rechargeable", "pointy", "sharp", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spear_gungnir")	
			inst.AnimState:SetBuild("spear_gungnir")	
			Anim路径 :  "anim/spear_gungnir.zip"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
糖果袋			预设: candybag		路径： [string "scripts/prefabs/candybag.lua"]	
	Tags▼	
	{":", "_inventoryitem", "backpack", "inspectable", "_container", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("candybag")	
			inst.AnimState:SetBuild("candybag")	
			Anim路径 :  "anim/candybag.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("itemget")	
------------------------------------------------	
MISSING NAME			预设: retrofit_archiveteleporter		路径： [string "scripts/prefabs/retrofit_archiveteleporter...."]	
	Tags▼	
	{":", "CLASSIFIED", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
------------------------------------------------	
烤箱			预设: quagmire_oven		路径： [string "scripts/prefabs/quagmire_oven.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_oven")	
			inst.AnimState:SetBuild("quagmire_oven")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
			预设: quagmire_soil		路径： [string "scripts/prefabs/quagmire_soil.lua"]	
	Tags▼	
	{":", "soil"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("quagmire_soil")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香无花果烤串			预设: figkabab_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: honey_trail		路径： [string "scripts/prefabs/honey_trail.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("honey_trail")	
			inst.AnimState:SetBuild("honey_trail")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: buff_electricattack		路径： [string "scripts/prefabs/foodbuffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
无花果意面			预设: figatoni		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food8")	
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
MISSING NAME			预设: researchlab3_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab3")	
			inst.AnimState:SetBuild("researchlab3")	
			Anim路径 :  "anim/researchlab3.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
果酱			预设: jammypreserves		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蓝色月眼			预设: bluemooneye		路径： [string "scripts/prefabs/mooneye.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mooneyes")	
			inst.AnimState:SetBuild("mooneyes")	
			Anim路径 :  "anim/mooneyes.zip"	
 	
	使用的组件▼	
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
迷你旋转秋千			预设: carnivaldecor_eggride2		路径： [string "scripts/prefabs/carnivaldecor_eggride.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "carnivaldecor", "HAMMER_workable", "quickactivation", "canlight", "structure", "inactive", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride2")	
			inst.AnimState:SetBuild("carnivaldecor_eggride2")	
			Anim路径 :  "anim/carnivaldecor_eggride2.zip"	
 	
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
日出匙型假饵			预设: oceanfishinglure_spoon_red		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
麋鹿鹅羽毛			预设: goose_feather		路径： [string "scripts/prefabs/goose_feather.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goose_feather")	
			inst.AnimState:SetBuild("goose_feather")	
			Anim路径 :  "anim/goose_feather.zip"	
 	
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
麻醉鱼饵			预设: oceanfishinglure_hermit_drowsy		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_lure_hermit")	
			inst.AnimState:SetBuild("oceanfishing_lure_hermit")	
			Anim路径 :  "anim/oceanfishing_lure_hermit.zip"	
 	
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
渔网			预设: fishingnet		路径： [string "scripts/prefabs/fishingnet.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "allow_action_on_impassable", "nolight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_net")	
			inst.AnimState:SetBuild("boat_net")	
			Anim路径 :  "anim/boat_net.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("fishingnet")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
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
MISSING NAME			预设: sugarwood_leaf_withered_fx_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
小惊吓			预设: smallghost		路径： [string "scripts/prefabs/smallghost.lua"]	
	Tags▼	
	{":", "ghostkid", "busy", "trader", "inspectable", "ghost", "NOBLOCK", "locomotor", "sanityaura", "_follower", "flying", "girl", "noauradamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ghost_kid")	
			inst.AnimState:SetBuild("ghost_kid")	
			Anim路径 :  "anim/ghost_kid.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("questowner")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("talker")	
		inst:AddComponent("follower")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
未使用			预设: oceanfishinglure_spoon_silver		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_lure_spoon")	
			inst.AnimState:SetBuild("oceanfishing_lure_spoon")	
			Anim路径 :  "Anim"	
 	
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
MISSING NAME			预设: yotc_carratshrine_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carratshrine")	
			inst.AnimState:SetBuild("yotc_carratshrine")	
			Anim路径 :  "anim/yotc_carratshrine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蜘蛛丝			预设: silk		路径： [string "scripts/prefabs/silk.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "spider_upgrader", "_stackable", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("silk")	
			inst.AnimState:SetBuild("silk")	
			Anim路径 :  "anim/silk.zip"	
 	
	使用的组件▼	
		inst:AddComponent("upgrader")	
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
风刮来的种子			预设: pomegranate_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
咸的辣龙椒沙拉			预设: dragonchilisalad_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
熟藤壶			预设: barnacle_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "barnacle", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle")	
			inst.AnimState:SetBuild("barnacle")	
			Anim路径 :  "anim/barnacle.zip"	
 	
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
巨钳			预设: crabking_claw		路径： [string "scripts/prefabs/crabking_claw.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "crabking_claw", "idle", "hostile", "_combat", "locomotor", "scarytoprey", "nolight", "ignorewalkableplatforms", "soulless", "animal"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("crab_king_claw_build")	
			Anim路径 :  "anim/crab_king_claw.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("teleportedoverride")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("boatdrag")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("teleported")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
犬牙			预设: houndstooth		路径： [string "scripts/prefabs/houndstooth.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "selfstacker", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("houndstooth")	
			inst.AnimState:SetBuild("hounds_tooth")	
			Anim路径 :  "anim/hounds_tooth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("selfstacker")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
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
烤大蒜			预设: garlic_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "fresh"}	
 	
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
MISSING NAME			预设: glass_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
生命魔杖			预设: healingstaff		路径： [string "scripts/prefabs/healingstaff.lua"]	
	Tags▼	
	{":", "rechargeable", "rangedweapon", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("healingstaff")	
			inst.AnimState:SetBuild("healingstaff")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
泽芹			预设: bunnyman		路径： [string "scripts/prefabs/bunnyman.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "cavedweller", "trader", "_health", "inspectable", "freezable", "pig", "RAW_eater", "_named", "idle", "manrabbit", "_inventory", "_combat", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("manrabbit")	
			inst.AnimState:SetBuild("manrabbit_build")	
			Anim路径 :  "anim/manrabbit_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("named")	
		inst:AddComponent("talker")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("inventory")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("eater")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: shadowskittish		路径： [string "scripts/prefabs/shadowskittish.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_skittish")	
			Anim路径 :  "anim/shadow_skittish.zip"	
 	
	使用的组件▼	
		inst:AddComponent("playerprox")	
		inst:AddComponent("transparentonsanity")	
		
------------------------------------------------	
火焰吹箭			预设: blowdart_fire		路径： [string "scripts/prefabs/blowdart.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "blowdart", "_stackable", "sharp", "_equippable", "firedart", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blow_dart")	
			inst.AnimState:SetBuild("blow_dart")	
			Anim路径 :  "anim/blow_dart.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("projectile")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onthrown")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
瓦伦提尼安			预设: moonpig		路径： [string "scripts/prefabs/pigman.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "werepig", "freezable", "pig", "RAW_eater", "_named", "idle", "_inventory", "hostile", "strongstomach", "HORRIBLE_eater", "_combat", "locomotor", "moonbeast", "OMNI_eater", "sanityaura", "scarytoprey", "nolight", "_follower", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("werepig_build")	
			Anim路径 :  "anim/werepig_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("follower")	
		inst:AddComponent("named")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("inventory")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("moontransformed")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("moonpetrify")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: fissure_grottowarfx		路径： [string "scripts/prefabs/nightmarelightfx.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fissure_grottowarfx")	
			inst.AnimState:SetBuild("fissure_grottowarfx")	
			Anim路径 :  "anim/fissure_grottowarfx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
口水鱼			预设: oceanfish_small_9		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_small_9", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming", "VEGETARIAN_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_9")	
			Anim路径 :  "anim/oceanfish_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("firedetector")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("eater")	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("timer")	
		inst:AddComponent("weighable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: researchlab2_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab2")	
			inst.AnimState:SetBuild("researchlab2")	
			Anim路径 :  "anim/researchlab2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
远古大门			预设: atrium_gate		路径： [string "scripts/prefabs/atrium_gate.lua"]	
	Tags▼	
	{":", "gemsocket", "trader", "inspectable", "stargate", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_gate")	
			inst.AnimState:SetBuild("atrium_gate")	
			Anim路径 :  "anim/atrium_gate.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("entitytracker")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: flotsam_puddle		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
隐士之家			预设: hermithouse		路径： [string "scripts/prefabs/hermithouse.lua"]	
	Tags▼	
	{":", "inspectable", "antlion_sinkhole_blocker", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hermitcrab_home")	
			inst.AnimState:SetBuild("hermitcrab_home")	
			Anim路径 :  "anim/hermitcrab_home.zip"	
 	
	使用的组件▼	
		inst:AddComponent("spawner")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("clocksegschanged")	
------------------------------------------------	
MISSING NAME			预设: splash_sink		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: penguinherd		路径： [string "scripts/prefabs/penguinherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("mood")	
		inst:AddComponent("herd")	
		
------------------------------------------------	
海鲜杂烩			预设: moqueca		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "masterfood", "canlight", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: wanda_attack_shadowweapon_normal_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
不太甜的玉米			预设: halloweencandy_3		路径： [string "scripts/prefabs/halloweencandy.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "halloweencandy", "_stackable", "edible_VEGGIE", "cattoy"}	
 	
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
甜蓬松土豆蛋奶酥			预设: potatosouffle_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
追蛋			预设: carnivalgame_herding_station		路径： [string "scripts/prefabs/carnivalgame_herding.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "HAMMER_workable", "carnivalgame_part", "birdblocker", "carnivalgame_herding_station", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_herding_station")	
			inst.AnimState:SetBuild("carnivalgame_herding_station")	
			Anim路径 :  "anim/carnivalgame_herding_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("minigame")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_medium_6		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_fest_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的波兰水饺			预设: perogies_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蝎子			预设: peghook_projectile		路径： [string "scripts/prefabs/lavaarena_peghook.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
幽灵			预设: ghost		路径： [string "scripts/prefabs/ghost.lua"]	
	Tags▼	
	{":", "monster", "trader", "_health", "inspectable", "FROMNUM", "hostile", "ghost", "_combat", "locomotor", "sanityaura", "flying", "noauradamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ghost")	
			inst.AnimState:SetBuild("ghost_build")	
			Anim路径 :  "anim/player_ghost_withhat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("aura")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: archive_resonator_base		路径： [string "scripts/prefabs/archive_resonator.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_resonator")	
			inst.AnimState:SetBuild("archive_resonator")	
			Anim路径 :  "anim/archive_resonator.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
坏掉的小鱼			预设: spoiled_fish_small		路径： [string "scripts/prefabs/spoiledfood.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "tile_deploy", "inspectable", "spoiled_fish", "selfstacker", "icebox_valid", "HAMMER_workable", "_stackable", "BURNABLE_fuel", "badfood", "fertilizer", "canlight", "fertilizerresearchable", "show_spoiled", "saltbox_valid", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spoiled_fish_small")	
			inst.AnimState:SetBuild("spoiled_fish_small")	
			Anim路径 :  "anim/spoiled_fish_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("selfstacker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("smotherer")	
		inst:AddComponent("tradable")	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("fertilizer")	
		inst:AddComponent("stackable")	
		inst:AddComponent("workable")	
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
月亮虹吸器			预设: moon_device_construction1		路径： [string "scripts/prefabs/moon_device.lua"]	
	Tags▼	
	{":", "inspectable", "_constructionsite", "nomagic", "antlion_sinkhole_blocker", "moon_device", "structure", "constructionsite", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moon_device")	
			Anim路径 :  "anim/moon_device.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("constructionsite")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: yotc_seedpacket_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: deer_fire_circle		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx", "deer_fire_circle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_fire_circle")	
			inst.AnimState:SetBuild("deer_fire_circle")	
			Anim路径 :  "anim/deer_fire_circle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("propagator")	
------------------------------------------------	
MISSING NAME			预设: spawn_fx_medium		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_gobbler_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: telebase_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("staff_purple_base_ground")	
			inst.AnimState:SetBuild("staff_purple_base_ground")	
			Anim路径 :  "anim/staff_purple_base_ground.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
彩带大炮套装			预设: carnivalcannon_streamer_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon_streamer")	
			Anim路径 :  "anim/carnival_cannon.zip"	
 	
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
白色骑士			预设: trinket_30		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: reticuleaoesmallping		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
植株			预设: weed_tillweed		路径： [string "scripts/prefabs/weed_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant_killjoy", "farm_plant", "plantresearchable", "plant", "DIG_workable", "canlight", "weed", "weed_tillweed", "tendable_farmplant", "weedplantstress"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("weed_tillweed")	
			inst.AnimState:SetBuild("weed_tillweed")	
			Anim路径 :  "anim/weed_tillweed.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("farmplanttendable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("plantresearchable")	
		inst:AddComponent("workable")	
		inst:AddComponent("timer")	
		inst:AddComponent("farmsoildrinker")	
		
	使用的监听▼	
		inst:ListenForEvent("on_planted")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
火鸡大餐			预设: turkeydinner		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: icing_splash_fx_med		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
盛夏夜灯			预设: carnivaldecor_lamp		路径： [string "scripts/prefabs/carnivaldecor_lamp.lua"]	
	Tags▼	
	{":", "carnivallamp", "trader", "inspectable", "carnivaldecor", "HAMMER_workable", "quickactivation", "canlight", "structure", "inactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_lamp")	
			inst.AnimState:SetBuild("carnivaldecor_lamp")	
			Anim路径 :  "anim/carnivaldecor_lamp.zip"	
 	
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
草丛			预设: dug_grass		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grass")	
			inst.AnimState:SetBuild("grass1")	
			Anim路径 :  "anim/grass.zip"	
 	
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
捆绑包装			预设: bundlewrap		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bundle")	
			inst.AnimState:SetBuild("bundle")	
			Anim路径 :  "anim/bundle.zip"	
 	
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
辣蓬松土豆蛋奶酥			预设: potatosouffle_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蒜香芦笋冷汤			预设: gazpacho_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
捆绑物资			预设: bundle		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bundle")	
			inst.AnimState:SetBuild("bundle")	
			Anim路径 :  "anim/bundle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("unwrappable")	
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
辣西瓜冰棍			预设: watermelonicle_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
苹果酒			预设: winter_food7		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
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
感伤装饰			预设: winter_ornament_boss_pearl		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments2020")	
			inst.AnimState:SetBuild("winter_ornaments2020")	
			Anim路径 :  "anim/winter_ornaments2020.zip"	
 	
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
灵魂万灵药			预设: ghostlyelixir_fastregen		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
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
冰鲷鱼			预设: oceanfish_medium_8		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "OMNI_eater", "herd_oceanfish_medium_8", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_8")	
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
MISSING NAME			预设: sugarwood_leaf_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型茄子			预设: eggplant_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_eggplant_build")	
			Anim路径 :  "anim/farm_plant_potato.zip"	
 	
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
MISSING NAME			预设: icing_splat_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
未使用			预设: oceanfishinglure_spoon_yellow		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
巨型腐烂石榴			预设: pomegranate_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_pomegranate_build")	
			Anim路径 :  "anim/farm_plant_potato.zip"	
 	
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
MISSING NAME			预设: cavelight_small		路径： [string "scripts/prefabs/cavelight.lua"]	
	Tags▼	
	{":", "fx", "sinkhole", "FROMNUM", "daylight", "batdestination", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "anim/cave_exit_lightsource.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hideout")	
		
------------------------------------------------	
世界鸟类大全			预设: book_birds		路径： [string "scripts/prefabs/books.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("books")	
			inst.AnimState:SetBuild("books")	
			Anim路径 :  "anim/books.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("book")	
		
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
咸的舒缓茶			预设: sweettea_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: abigailsummonfx_mount		路径： [string "scripts/prefabs/abigail_flower.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wendy_mount_channel_flower")	
			inst.AnimState:SetBuild("wendy_mount_channel_flower")	
			Anim路径 :  "anim/wendy_mount_channel_flower.zip"	
 	
	使用的组件▼	
		inst:AddComponent("updatelooper")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
木球浮标			预设: oceanfishingbobber_ball_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_ball_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
MISSING NAME			预设: cane_ancient_fx2		路径： [string "scripts/prefabs/cane_ancient_fx.lua"]	
	Tags▼	
	{":", "fx", "shadowtrail"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: hallowed_nights_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
兔耳罩			预设: earmuffshat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "open_top_hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("earmuffshat")	
			inst.AnimState:SetBuild("hat_earmuffs")	
			Anim路径 :  "anim/hat_earmuffs.zip"	
 	
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
MISSING NAME			预设: buff_workeffectiveness		路径： [string "scripts/prefabs/foodbuffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: pocketwatch_portal_entrance_underlay		路径： [string "scripts/prefabs/pocketwatch_portal.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_portal_fx")	
			inst.AnimState:SetBuild("pocketwatch_portal_fx")	
			Anim路径 :  "anim/pocketwatch_portal_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
沙刺			预设: sandspike_short		路径： [string "scripts/prefabs/sand_spike.lua"]	
	Tags▼	
	{":", "groundspike", "object", "_health", "cannotheal", "hostile", "_combat", "notarget", "stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sand_spike")	
			inst.AnimState:SetBuild("sand_spike")	
			Anim路径 :  "anim/sand_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("health")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("death")	
------------------------------------------------	
保险箱			预设: quagmire_safe		路径： [string "scripts/prefabs/quagmire_safe.lua"]	
	Tags▼	
	{":", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_safe")	
			inst.AnimState:SetBuild("quagmire_safe")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: halloween_firepuff_cold_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: container_opener		路径： [string "scripts/prefabs/container_opener.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的蛙腿三明治			预设: frogglebunwich_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
红袋子			预设: redpouch		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("redpouch")	
			inst.AnimState:SetBuild("redpouch")	
			Anim路径 :  "anim/redpouch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("unwrappable")	
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
粗壮常青树			预设: quagmire_evergreen_normal		路径： [string "scripts/prefabs/quagmire_evergreen.lua"]	
	Tags▼	
	{":", "tree", "plant", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_short")	
			inst.AnimState:SetBuild("evergreen_new_2")	
			Anim路径 :  "anim/evergreen_short_normal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
起皱的包裹			预设: wetpouch		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wetpouch")	
			inst.AnimState:SetBuild("wetpouch")	
			Anim路径 :  "anim/wetpouch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("unwrappable")	
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
邪天翁雕塑			预设: chesspiece_malbatross_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鸟笼			预设: birdcage		路径： [string "scripts/prefabs/birdcage.lua"]	
	Tags▼	
	{":", "bird_occupiable", "inspectable", "cage", "HAMMER_workable", "_inventory", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("birdcage")	
			inst.AnimState:SetBuild("bird_cage")	
			Anim路径 :  "anim/bird_cage.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("shelf")	
		inst:AddComponent("inventory")	
		inst:AddComponent("occupiable")	
		
	使用的监听▼	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onwakeup")	
------------------------------------------------	
MISSING NAME			预设: sinkhole_warn_fx_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
暗影战车			预设: shadow_rook		路径： [string "scripts/prefabs/shadowchesspieces.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "hostile", "_combat", "locomotor", "sanityaura", "shadowchesspiece"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadow_rook")	
			inst.AnimState:SetBuild("shadow_rook")	
			Anim路径 :  "anim/shadow_rook.zip"	
 	
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
蚊子			预设: mosquito		路径： [string "scripts/prefabs/mosquito.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "freezable", "idle", "insect", "small_livestock", "smallcreature", "_stackable", "_combat", "locomotor", "NET_workable", "OMNI_eater", "nolight", "flying", "mosquito", "show_spoilage", "cattoyairborne", "ignorewalkableplatformdrowning", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mosquito")	
			inst.AnimState:SetBuild("mosquito")	
			Anim路径 :  "anim/mosquito.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("workable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("eater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("tradable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
恐怖利爪			预设: oceanhorror		路径： [string "scripts/prefabs/oceanshadowcreature.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "shadow", "hostile", "_combat", "locomotor", "sanityaura", "ignorewalkableplatforms", "shadowcreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanhorror")	
			inst.AnimState:SetBuild("shadow_oceanhorror")	
			Anim路径 :  "anim/shadow_oceanhorror.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("transparentonsanity")	
		inst:AddComponent("shadowsubmissive")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
圣诞灯			预设: winter_ornament_light8		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "lightbattery", "inspectable", "molebait", "winter_ornament", "cattoy", "CAVE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("timer")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
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
------------------------------------------------	
遗失的玻璃球			预设: lost_toy_1		路径： [string "scripts/prefabs/lost_toys.lua"]	
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
蒸馏的知识			预设: archive_lockbox		路径： [string "scripts/prefabs/archive_lockbox.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "archive_lockbox"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_lockbox")	
			inst.AnimState:SetBuild("archive_lockbox")	
			Anim路径 :  "anim/archive_lockbox.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onteach")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
辣怪物千层饼			预设: monsterlasagna_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "monstermeat", "badfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: carnivaldecor_figure_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_statue")	
			inst.AnimState:SetBuild("carnivaldecor_statue")	
			Anim路径 :  "anim/carnivaldecor_statue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: crater_steam_fx3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
饕餮敬拜者			预设: quagmire_park_angel		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
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
木门			预设: fence_gate_item		路径： [string "scripts/prefabs/fence.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "gatebuilder", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fence_gate")	
			inst.AnimState:SetBuild("fence_gate")	
			Anim路径 :  "anim/fence_gate.zip"	
 	
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
蒜香叶肉糕			预设: leafloaf_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: deer_ice_circle		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx", "deer_ice_circle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_ice_circle")	
			inst.AnimState:SetBuild("deer_ice_circle")	
			Anim路径 :  "anim/deer_ice_circle.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
烤芦笋			预设: asparagus_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("asparagus")	
			inst.AnimState:SetBuild("asparagus")	
			Anim路径 :  "anim/asparagus.zip"	
 	
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
MISSING NAME			预设: moon_device_break_stage3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnivaldecor_lamp_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_lamp")	
			inst.AnimState:SetBuild("carnivaldecor_lamp")	
			Anim路径 :  "anim/carnivaldecor_lamp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
采摘的红蘑菇			预设: red_cap		路径： [string "scripts/prefabs/mushrooms.lua"]	
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
烹饪指南			预设: cookbook		路径： [string "scripts/prefabs/cookbook.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "simplebook", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cookbook")	
			inst.AnimState:SetBuild("cookbook")	
			Anim路径 :  "anim/cookbook.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("simplebook")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
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
铥矿墙			预设: brokenwall_moonrock		路径： [string "scripts/prefabs/brokenwalls.lua"]	
	Tags▼	
	{":", "moonrock", "inspectable", "_named", "HAMMER_workable", "stone", "wall", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_moonrock")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
防火假声			预设: battlesong_fireresistance		路径： [string "scripts/prefabs/battlesongs.lua"]	
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
蒜香炸鱼排			预设: fishsticks_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "catfood", "spicedfood", "preparedfood", "fresh"}	
 	
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
蟹肉意大利饺			预设: quagmire_food_065		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_teambanner		路径： [string "scripts/prefabs/lavaarena_crowdstand.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
落叶比目鱼			预设: oceanfish_small_6		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_veggie", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_small_6", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming", "VEGETARIAN_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_6")	
			Anim路径 :  "anim/oceanfish_small.zip"	
 	
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
泡泡烟斗雕塑			预设: chesspiece_pipe_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: hutch_music_light_fx		路径： [string "scripts/prefabs/hutch.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("fxdirty")	
------------------------------------------------	
MISSING NAME			预设: burntfencepost		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_gobbler_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鱼钩			预设: oceanfishingbobber_none_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_hook")	
			inst.AnimState:SetBuild("oceanfishing_hook")	
			Anim路径 :  "anim/oceanfishing_hook.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
MISSING NAME			预设: staff_castinglight		路径： [string "scripts/prefabs/staff_castinglight.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_speed_dripfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
正式礼服款式			预设: formal_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
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
雪雀			预设: robin_winter		路径： [string "scripts/prefabs/birds.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "_health", "inspectable", "SEEDS_eater", "freezable", "stunnedbybomb", "idle", "small_livestock", "smallcreature", "_combat", "locomotor", "nolight", "show_spoilage", "robin_winter", "cookable", "flight", "likewateroffducksback", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crow")	
			inst.AnimState:SetBuild("robin_winter_build")	
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
水煮鱼			预设: quagmire_food_040		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fossilspike_base		路径： [string "scripts/prefabs/fossil_spike.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fossil_spike")	
			inst.AnimState:SetBuild("fossil_spike")	
			Anim路径 :  "anim/fossil_spike.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜奶油土豆泥			预设: mashedpotatoes_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: red_leaves_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
女王雕塑			预设: chesspiece_muse_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: explode_reskin		路径： [string "scripts/prefabs/explode_small.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
必忘我			预设: forgetmelots		路径： [string "scripts/prefabs/forgetmelots.lua"]	
	Tags▼	
	{":", "_inventoryitem", "vasedecoration", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "BURNABLE_fuel", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("forgetmelots")	
			inst.AnimState:SetBuild("forgetmelots")	
			Anim路径 :  "anim/forgetmelots.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("vasedecoration")	
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
南瓜饼干			预设: pumpkincookie		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
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
蒜香肉丸			预设: meatballs_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
鳗鱼			预设: eel		路径： [string "scripts/prefabs/eel.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "fishmeat", "dryable", "_stackable", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eel")	
			inst.AnimState:SetBuild("eel")	
			Anim路径 :  "anim/eel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("dryable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("floater")	
		inst:AddComponent("cookable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("onpickup")	
------------------------------------------------	
蜂蜡			预设: beeswax		路径： [string "scripts/prefabs/beeswax.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "meltable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beeswax")	
			inst.AnimState:SetBuild("beeswax")	
			Anim路径 :  "anim/beeswax.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("wax")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stopfiremelt")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("firemelt")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
橘色月眼			预设: orangemooneye		路径： [string "scripts/prefabs/mooneye.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mooneyes")	
			inst.AnimState:SetBuild("mooneyes")	
			Anim路径 :  "anim/mooneyes.zip"	
 	
	使用的组件▼	
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
月光玻璃			预设: grotto_moonglass_3		路径： [string "scripts/prefabs/grotto_pool_moonglass.lua"]	
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
甜培根煎蛋			预设: baconeggs_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: shadowstrike_slash2_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: anchor_item_placer		路径： [string "scripts/prefabutil.lua"]	
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
月蛾雕塑			预设: chesspiece_butterfly_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
杯装刚毅勇气			预设: halloweenpotion_sanity_large		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
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
眼睛炮塔			预设: eyeturret_item		路径： [string "scripts/prefabs/eyeturret.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "deployable", "largecreature", "eyeturret"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeball_turret_object")	
			inst.AnimState:SetBuild("eyeball_turret_object")	
			Anim路径 :  "anim/eyeball_turret_object.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
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
蒜香失败料理			预设: wetgoop_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "_stackable", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
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
天体英雄			预设: alterguardian_phase3deadorb		路径： [string "scripts/prefabs/alterguardian_phase3dead.lu..."]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_spawn_death")	
			inst.AnimState:SetBuild("alterguardian_spawn_death")	
			Anim路径 :  "anim/alterguardian_spawn_death.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("orbtaken")	
------------------------------------------------	
MISSING NAME			预设: waxwell_book_fx		路径： [string "scripts/prefabs/book_fx.lua"]	
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
MISSING NAME			预设: archive_chandelier		路径： [string "scripts/prefabs/archive_chandelier.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK", "archive_chandelier"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("chandelier_archives")	
			inst.AnimState:SetBuild("chandelier_archives")	
			Anim路径 :  "anim/chandelier_archives.zip"	
 	
	使用的组件▼	
		inst:AddComponent("playerprox")	
		
	使用的监听▼	
		inst:ListenForEvent("arhivepoweron")	
		inst:ListenForEvent("arhivepoweroff")	
------------------------------------------------	
悲惨的孢子帽			预设: mushroomsprout_dark		路径： [string "scripts/prefabs/mushroomsprout.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "tree", "CHOP_workable", "canlight", "mushroomsprout", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroomsprout")	
			inst.AnimState:SetBuild("mushroomsprout_dark_upg_build")	
			Anim路径 :  "anim/mushroomsprout.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("linktoadstool")	
------------------------------------------------	
MISSING NAME			预设: hud		路径： [string "scripts/prefabs/hud.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	

------------------------------------------------	
培根裹肉			预设: quagmire_food_062		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型腐烂胡萝卜			预设: carrot_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_carrot")	
			inst.AnimState:SetBuild("farm_plant_carrot")	
			Anim路径 :  "anim/farm_plant_carrot.zip"	
 	
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
骨头盔甲			预设: armorskeleton		路径： [string "scripts/prefabs/armor_skeleton.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "NIGHTMARE_fueled", "fossil", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_skeleton")	
			inst.AnimState:SetBuild("armor_skeleton")	
			Anim路径 :  "anim/armor_skeleton.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cooldown")	
		inst:AddComponent("fueled")	
		inst:AddComponent("resistance")	
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
MISSING NAME			预设: townportal_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("townportal")	
			inst.AnimState:SetBuild("townportal")	
			Anim路径 :  "anim/townportal.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
地图卷轴			预设: mapscroll		路径： [string "scripts/prefabs/mapscroll.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mapscroll")	
			inst.AnimState:SetBuild("mapscroll")	
			Anim路径 :  "anim/mapscroll.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("maprecorder")	
		
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
咸的蔬菜杂烩			预设: ratatouille_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣恐怖国王饼			预设: nightmarepie_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "unsafefood", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
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
护士变身涂鸦			预设: mutator_healer		路径： [string "scripts/prefabs/spider_mutators.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "monstermeat", "BURNABLE_fuel", "badfood", "canlight", "spidermutator"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("spider_mutators")	
			Anim路径 :  "anim/spider_mutators.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("spidermutator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
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
传送魔杖			预设: telestaff		路径： [string "scripts/prefabs/staff.lua"]	
	Tags▼	
	{":", "_inventoryitem", "castonlocomotorspvp", "inspectable", "castfrominventory", "_equippable", "nopunch"}	
 	
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
MISSING NAME			预设: halloween_firepuff_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sentryward_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sentryward")	
			inst.AnimState:SetBuild("sentryward")	
			Anim路径 :  "anim/sentryward.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蛴螬			预设: carnivalgame_feedchicks_food		路径： [string "scripts/prefabs/carnivalgame_feedchicks.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "nonpotatable", "_equippable", "nopunch", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_feedchicks_food")	
			inst.AnimState:SetBuild("carnivalgame_feedchicks_food")	
			Anim路径 :  "anim/carnivalgame_feedchicks_food.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("equippable")	
		inst:AddComponent("carnivalgameitem")	
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
暗影主教			预设: shadow_bishop		路径： [string "scripts/prefabs/shadowchesspieces.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "hostile", "_combat", "locomotor", "sanityaura", "shadowchesspiece"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadow_bishop")	
			inst.AnimState:SetBuild("shadow_bishop")	
			Anim路径 :  "anim/shadow_bishop.zip"	
 	
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
巴甫洛娃蛋糕			预设: pavlova		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
种子袋			预设: seedpouch		路径： [string "scripts/prefabs/seedpouch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "backpack", "inspectable", "_container", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seedpouch")	
			inst.AnimState:SetBuild("seedpouch")	
			Anim路径 :  "anim/seedpouch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("itemget")	
------------------------------------------------	
蛙腿三明治			预设: frogglebunwich		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
邪天翁羽浮标			预设: oceanfishingbobber_malbatross		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_malbatross_build")	
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
终止恐惧的药液			预设: halloweenpotion_bravery_large		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
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
旋转的风扇			预设: minifan		路径： [string "scripts/prefabs/minifan.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "HASHEATER", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("minifan")	
			inst.AnimState:SetBuild("minifan")	
			Anim路径 :  "anim/minifan.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("fueled")	
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
灵子分解器			预设: researchlab4		路径： [string "scripts/prefabs/magicprototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "level4", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab4")	
			inst.AnimState:SetBuild("researchlab4")	
			Anim路径 :  "anim/researchlab4.zip"	
 	
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
MISSING NAME			预设: schoolherd_oceanfish_small_2		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
果酱三明治			预设: quagmire_food_004		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
腐烂鸟蛋			预设: rottenegg		路径： [string "scripts/prefabs/egg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "tile_deploy", "inspectable", "icebox_valid", "_stackable", "cattoy", "BURNABLE_fuel", "badfood", "fertilizer", "canlight", "fertilizerresearchable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bird_eggs")	
			Anim路径 :  "anim/bird_eggs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
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
猪鼻铸币			预设: pig_coin		路径： [string "scripts/prefabs/pig_coin.lua"]	
	Tags▼	
	{":", "_inventoryitem", "castonlocomotorspvp", "inspectable", "castfrominventory", "cointosscast", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pig_coin")	
			inst.AnimState:SetBuild("pig_coin")	
			Anim路径 :  "anim/pig_coin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("tradable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("spellcaster")	
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
普通鸦年华小雕像			预设: carnivaldecor_figure		路径： [string "scripts/prefabs/carnivaldecor_figure.lua"]	
	Tags▼	
	{":", "inspectable", "blindbox_common", "carnivaldecor", "HAMMER_workable", "canlight", "structure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_statue")	
			inst.AnimState:SetBuild("carnivaldecor_statue")	
			Anim路径 :  "anim/carnivaldecor_statue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("carnivaldecor")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("loot_prefab_spawned")	
------------------------------------------------	
农作物			预设: quagmire_onion_planted		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "plantedsoil", "fertilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_small_3		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: scarecrow_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scarecrow")	
			inst.AnimState:SetBuild("scarecrow")	
			Anim路径 :  "anim/scarecrow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
沙刺			预设: sandspike_tall		路径： [string "scripts/prefabs/sand_spike.lua"]	
	Tags▼	
	{":", "groundspike", "object", "_health", "cannotheal", "hostile", "_combat", "notarget", "stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sand_spike")	
			inst.AnimState:SetBuild("sand_spike")	
			Anim路径 :  "anim/sand_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("health")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("death")	
------------------------------------------------	
花朵金枪鱼			预设: oceanfish_small_7_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "badfood", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_7")	
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
小鸟			预设: smallbird		路径： [string "scripts/prefabs/smallbird.lua"]	
	Tags▼	
	{":", "trader", "_health", "inspectable", "freezable", "companion", "idle", "smallcreature", "smallbird", "_combat", "locomotor", "nolight", "_follower", "_hunger", "BERRIES_AND_SEEDS_eater", "character", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("smallbird")	
			inst.AnimState:SetBuild("smallbird_basic")	
			Anim路径 :  "anim/smallbird_basic.zip"	
 	
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
		inst:ListenForEvent("SetUpSpringSmallBird")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
	SG = 有▼	
------------------------------------------------	
甜华夫饼			预设: waffles_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
盐晶			预设: saltrock		路径： [string "scripts/prefabs/saltrock.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("salt")	
			inst.AnimState:SetBuild("salt")	
			Anim路径 :  "anim/salt.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("preservative")	
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
舔盐块			预设: saltlick		路径： [string "scripts/prefabs/saltlick.lua"]	
	Tags▼	
	{":", "inspectable", "saltlick", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("salt_lick")	
			inst.AnimState:SetBuild("salt_lick")	
			Anim路径 :  "anim/salt_lick.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("burntup")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("percentusedchange")	
------------------------------------------------	
盐盒			预设: saltbox		路径： [string "scripts/prefabs/saltbox.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "HAMMER_workable", "saltbox", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("saltbox")	
			inst.AnimState:SetBuild("saltbox")	
			Anim路径 :  "anim/saltbox.zip"	
 	
	使用的组件▼	
		inst:AddComponent("preserver")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
鞍角			预设: saddlehorn		路径： [string "scripts/prefabs/saddlehorn.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("saddlehorn")	
			inst.AnimState:SetBuild("saddlehorn")	
			Anim路径 :  "anim/saddlehorn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("unsaddler")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("finiteuses")	
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
战争鞍具			预设: saddle_war		路径： [string "scripts/prefabs/saddle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "combatmount"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("saddle_war")	
			Anim路径 :  "anim/saddle_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("saddler")	
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
MISSING NAME			预设: ruinsrelic_table_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_table")	
			inst.AnimState:SetBuild("ruins_table")	
			Anim路径 :  "anim/ruins_table.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
辣蜜汁卤肉			预设: honeynuggets_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
遗物复制品 花瓶			预设: ruinsrelic_vase		路径： [string "scripts/prefabs/ruinsrelic.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_vase")	
			inst.AnimState:SetBuild("ruins_vase")	
			Anim路径 :  "anim/ruins_vase.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
遗物复制品 椅子			预设: ruinsrelic_chair		路径： [string "scripts/prefabs/ruinsrelic.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_chair")	
			inst.AnimState:SetBuild("ruins_chair")	
			Anim路径 :  "anim/ruins_chair.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: die_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
蝎子			预设: peghook		路径： [string "scripts/prefabs/lavaarena_peghook.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("peghook")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: alterguardian_laserhit		路径： [string "scripts/prefabs/alterguardian_laser.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
缝纫机			预设: yotb_sewingmachine		路径： [string "scripts/prefabs/yotb_sewingmachine.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "HAMMER_workable", "canlight", "sewingmachine", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_beefalo_sewingmachine")	
			Anim路径 :  "anim/yotb_beefalo_sewingmachine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("yotb_sewer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("onopen")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onclose")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
MISSING NAME			预设: moon_device_break_stage1		路径： [string "scripts/prefabs/moon_device.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_device_break")	
			inst.AnimState:SetBuild("moon_device_break")	
			Anim路径 :  "anim/moon_device_break.zip"	
 	
	使用的组件▼	
------------------------------------------------	
熔岩坑			预设: rock_light		路径： [string "scripts/prefabs/rock_light.lua"]	
	Tags▼	
	{":", "inspectable", "fueldepleted", "sanityaura", "MINE_workable", "canlight", "rocklight", "structure", "stone", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock_light")	
			inst.AnimState:SetBuild("rock_light")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("onextinguish")	
------------------------------------------------	
舒缓茶			预设: sweettea		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "honeyed", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food7")	
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
MISSING NAME			预设: small_puff		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: deer_unshackle_fx		路径： [string "scripts/prefabs/deer.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("deer_build")	
			Anim路径 :  "anim/deer_unshackle.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: rock_avocado_fruit_sprout_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_fruit_build")	
			Anim路径 :  "anim/rock_avocado_fruit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: reviver_cupid_beat_fx		路径： [string "scripts/prefabs/reviver_cupid_beat_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: reticulelong		路径： [string "scripts/prefabs/reticulelong.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticulelong")	
			inst.AnimState:SetBuild("reticulelong")	
			Anim路径 :  "anim/reticulelong.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香花式回旋块茎			预设: potatotornado_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
独眼巨鹿雕塑			预设: chesspiece_deerclops_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
------------------------------------------------	
小麦			预设: quagmire_wheat		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "show_spoilage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
大理石豌豆			预设: marblebean		路径： [string "scripts/prefabs/marblebean.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "deployable", "treeseed"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marblebean")	
			inst.AnimState:SetBuild("marblebean")	
			Anim路径 :  "anim/marblebean.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("stackable")	
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
MISSING NAME			预设: reticuleaoesummon		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
失败料理			预设: wetgoop		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: lavaarena_creature_teleport_medium_fx		路径： [string "scripts/prefabs/lavaarena_creature_spawn_fx..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_beefalo_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
风干肉			预设: meat_dried		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "dryable", "_stackable", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_rack_food")	
			inst.AnimState:SetBuild("meat_rack_food")	
			Anim路径 :  "anim/meat_rack_food.zip"	
 	
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
咸的芝士蛋糕			预设: powcake_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: deerclopswarning_lvl3		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
多汁浆果			预设: berries_juicy		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "oceanfishing_lure", "edible_BERRY", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berries_juicy")	
			inst.AnimState:SetBuild("berries_juicy")	
			Anim路径 :  "anim/berries_juicy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("oceanfishingtackle")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cookable")	
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
格罗姆的黏液			预设: glommerfuel		路径： [string "scripts/prefabs/glommerfuel.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "tile_deploy", "inspectable", "_stackable", "BURNABLE_fuel", "badfood", "fertilizer", "canlight", "fertilizerresearchable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("glommer_fuel")	
			inst.AnimState:SetBuild("glommer_fuel")	
			Anim路径 :  "anim/glommer_fuel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fertilizer")	
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
剃刀			预设: razor		路径： [string "scripts/prefabs/razor.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("razor")	
			inst.AnimState:SetBuild("swap_razor")	
			Anim路径 :  "anim/razor.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("shaver")	
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
MISSING NAME			预设: crabking_claw_shadow		路径： [string "scripts/prefabs/crabking_claw.lua"]	
	Tags▼	
	{":", "NOBLOCK", "ignorewalkableplatforms", "notarget", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("crab_king_claw_shadow_build")	
			Anim路径 :  "anim/crab_king_claw.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_cooking_buff		路径： [string "scripts/prefabs/quagmire_cooking_buff.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: rabbithouse_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rabbithouse")	
			inst.AnimState:SetBuild("rabbit_house")	
			Anim路径 :  "anim/rabbit_house.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: carnivalgame_feedchicks_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_feedchicks_station")	
			inst.AnimState:SetBuild("carnivalgame_feedchicks_station")	
			Anim路径 :  "anim/carnivalgame_feedchicks_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
伏特羊角			预设: lightninggoathorn		路径： [string "scripts/prefabs/lightninggoathorn.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lightning_goat_horn")	
			inst.AnimState:SetBuild("lightning_goat_horn")	
			Anim路径 :  "anim/lightning_goat_horn.zip"	
 	
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
蒜香火龙果派			预设: dragonpie_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
房子碎石			预设: quagmire_swampig_house_rubble		路径： [string "scripts/prefabs/quagmire_swampig_house.lua"]	
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
MISSING NAME			预设: quagmire_swampig		路径： [string "scripts/prefabs/quagmire_swampig.lua"]	
	Tags▼	
	{":", "pig", "_named", "scarytoprey", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "anim/ds_pig_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
		
------------------------------------------------	
MISSING NAME			预设: staffcoldlightfx		路径： [string "scripts/prefabs/stafflight.lua"]	
	Tags▼	
	{":", "HASHEATER", "sanityaura"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("star_cold")	
			inst.AnimState:SetBuild("star_cold")	
			Anim路径 :  "anim/star_cold.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("heater")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: inksplat		路径： [string "scripts/prefabs/waterprojectiles.lua"]	
	Tags▼	
	{":", "projectile", "locomotor", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("squid_watershoot")	
			inst.AnimState:SetBuild("squid_watershoot")	
			Anim路径 :  "anim/squid_watershoot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("complexprojectile")	
------------------------------------------------	
斑点香料			预设: quagmire_spotspice_ground		路径： [string "scripts/prefabs/quagmire_spiceshrub.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_spotspice_ground")	
			inst.AnimState:SetBuild("quagmire_spotspice_ground")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_portal_player_splash_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
战车雕塑			预设: chesspiece_rook_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: grotto_war_sfx		路径： [string "scripts/prefabs/atrium_gate_pulsesfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: shadow_puff_large_front		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
灰烬			预设: ash		路径： [string "scripts/prefabs/ash.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_named", "molebait", "_stackable", "edible_BURNT", "ashes"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ashes")	
			inst.AnimState:SetBuild("ash")	
			Anim路径 :  "anim/ash.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("named")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("disappears")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
盐			预设: quagmire_salt		路径： [string "scripts/prefabs/quagmire_salts.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_salt")	
			inst.AnimState:SetBuild("quagmire_salt")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
远古钥匙			预设: quagmire_portal_key		路径： [string "scripts/prefabs/quagmire_portal_key.lua"]	
	Tags▼	
	{":", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_portal_key")	
			inst.AnimState:SetBuild("quagmire_portal_key")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: blowdart_walrus		路径： [string "scripts/prefabs/blowdart.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "blowdart", "_stackable", "sharp", "NOCLICK", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blow_dart")	
			inst.AnimState:SetBuild("blow_dart")	
			Anim路径 :  "anim/blow_dart.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("projectile")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onthrown")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
维多利亚皮弗娄牛玩偶			预设: yotb_beefalo_doll_victorian		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
牛奶帽			预设: batnosehat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("batnosehat")	
			inst.AnimState:SetBuild("hat_batnose")	
			Anim路径 :  "anim/hat_batnose.zip"	
 	
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
一角鲸的角			预设: gnarwail_horn		路径： [string "scripts/prefabs/gnarwail_horn.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "gnarwail_horn", "allow_action_on_impassable", "castonpointwater", "_equippable", "nopunch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gnarwail")	
			inst.AnimState:SetBuild("gnarwail_horn")	
			Anim路径 :  "anim/gnarwail_horn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("spellcaster")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("reticule")	
		
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
迷你火箭			预设: trinket_5		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: fx_boat_pop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
桦栗树树苗			预设: acorn_sapling		路径： [string "scripts/prefabs/planted_tree.lua"]	
	Tags▼	
	{":", "inspectable", "deciduoustree", "plant", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("acorn")	
			inst.AnimState:SetBuild("acorn")	
			Anim路径 :  "anim/acorn.zip"	
 	
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
MISSING NAME			预设: carnivaldecor_eggride3_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride3")	
			inst.AnimState:SetBuild("carnivaldecor_eggride3")	
			Anim路径 :  "anim/carnivaldecor_eggride3.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
砸烂的时钟			预设: quagmire_rubble_clock		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
铥矿墙			预设: brokenwall_hay		路径： [string "scripts/prefabs/brokenwalls.lua"]	
	Tags▼	
	{":", "inspectable", "grass", "_named", "HAMMER_workable", "wall", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_hay")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
尘蛾			预设: dustmoth		路径： [string "scripts/prefabs/dustmoth.lua"]	
	Tags▼	
	{":", "cavedweller", "trader", "_health", "inspectable", "freezable", "idle", "_inventory", "_combat", "locomotor", "nolight", "ELEMENTAL_eater", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dustmoth")	
			inst.AnimState:SetBuild("dustmoth")	
			Anim路径 :  "anim/dustmoth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("combat")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("inventory")	
		inst:AddComponent("timer")	
		inst:AddComponent("trader")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("dustmothden_repaired")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: wathgrithr_bloodlustbuff_self		路径： [string "scripts/prefabs/wathgrithr_bloodlustbuff.lu..."]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_attack_buff_effect")	
			inst.AnimState:SetBuild("lavaarena_attack_buff_effect")	
			Anim路径 :  "anim/lavaarena_attack_buff_effect.zip"	
 	
	使用的组件▼	
------------------------------------------------	
尖形种子			预设: quagmire_seeds_4		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: chandelier_sfx		路径： [string "scripts/prefabs/archive_chandelier.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: quagmire_onion_leaf		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的鲜果可丽饼			预设: freshfruitcrepes_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
果蝇			预设: fruitfly		路径： [string "scripts/prefabs/fruitfly.lua"]	
	Tags▼	
	{":", "busy", "_health", "inspectable", "freezable", "insect", "hostile", "_combat", "small", "locomotor", "sanityaura", "nolight", "_follower", "fruitfly", "flying", "ignorewalkableplatformdrowning", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fruitfly")	
			inst.AnimState:SetBuild("fruitfly_evil_minion")	
			Anim路径 :  "anim/fruitfly.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("follower")	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
华丽基座			预设: archive_switch		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":", "gemsocket", "trader", "inspectable", "outofreach", "archive_switch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_switch")	
			inst.AnimState:SetBuild("archive_switch")	
			Anim路径 :  "anim/archive_switch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("pickable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("trader")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: quagmire_turnip_leaf		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
小虚影			预设: smallguard_alterguardian_projectile		路径： [string "scripts/prefabs/gestalt_alterguardian_proje..."]	
	Tags▼	
	{":", "crazy", "NOBLOCK", "_combat", "extinguisher", "sanityaura", "brightmare", "NOCLICK", "brightmare_guard"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt_evolved")	
			inst.AnimState:SetBuild("brightmare_gestalt_evolved")	
			Anim路径 :  "anim/brightmare_gestalt_evolved.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("combat")	
		inst:AddComponent("transparentonsanity")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
巨型火龙果			预设: dragonfruit_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_dragonfruit_build")	
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
农作物			预设: quagmire_carrot_planted		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "plantedsoil", "fertilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: burntstickleft		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
------------------------------------------------	
暴怒的露西			预设: lavaarena_lucy		路径： [string "scripts/prefabs/lavaarena_lucy.lua"]	
	Tags▼	
	{":", "tool", "rechargeable", "chop_attack", "sharp", "throw_line", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_lucy")	
			inst.AnimState:SetBuild("lavaarena_lucy")	
			Anim路径 :  "anim/lavaarena_lucy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
MISSING NAME			预设: wathgrithr_spirit		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: quagmire_oven_back		路径： [string "scripts/prefabs/quagmire_oven.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_oven")	
			inst.AnimState:SetBuild("quagmire_oven")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
猎犬			预设: moonhound		路径： [string "scripts/prefabs/hound.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "freezable", "scarytooceanprey", "hostile", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "moonbeast", "canbestartled", "sanityaura", "scarytoprey", "nolight", "_follower", "sleeper", "hound"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hound")	
			inst.AnimState:SetBuild("hound")	
			Anim路径 :  "anim/hound_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("eater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("follower")	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("moonpetrify")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("moontransformed")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
烤曼德拉草			预设: cookedmandrake		路径： [string "scripts/prefabs/mandrake_inactive.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mandrake")	
			inst.AnimState:SetBuild("mandrake")	
			Anim路径 :  "anim/mandrake.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
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
MISSING NAME			预设: fencepostright		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
沙漠地皮			预设: turf_desertdirt		路径： [string "scripts/prefabs/turfs.lua"]	
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
组装一半的祭坛			预设: moon_altar		路径： [string "scripts/prefabs/moon_altar.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "HAMMER_workable", "workrepairable", "repairable_moon_altar", "structure", "moonaltarlinktarget", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_altar")	
			inst.AnimState:SetBuild("moon_altar")	
			Anim路径 :  "anim/moon_altar.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("repairable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("moonaltarlinktarget")	
		
	使用的监听▼	
		inst:ListenForEvent("calling_moon_relics")	
		inst:ListenForEvent("on_fissure_socket")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
残破的烟囱			预设: quagmire_rubble_chimney		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: splash_green_large		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
残破的门			预设: quagmire_rubble_pubdoor		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: moonstorm_spark_shock_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: goo_spit_fx		路径： [string "scripts/prefabs/lavaarena_snapper.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_rubble_empty		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "NOCLICK"}	
 	
	使用的组件▼	
------------------------------------------------	
蘑菇			预设: quagmire_mushroomstump		路径： [string "scripts/prefabs/quagmire_mushroomstump.lua"]	
	Tags▼	
	{":", "quagmire_wildplant", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_mushroomstump")	
			inst.AnimState:SetBuild("quagmire_mushroomstump")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: positronpulse		路径： [string "scripts/prefabs/positronbeam.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moonbase_fx")	
			Anim路径 :  "anim/moonbase_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: chumpiece		路径： [string "scripts/prefabs/chum_aoe.lua"]	
	Tags▼	
	{":", "fx", "edible_GENERIC", "edible_MEAT", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		
------------------------------------------------	
养蜂帽			预设: beehat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beehat")	
			inst.AnimState:SetBuild("hat_bee")	
			Anim路径 :  "anim/hat_bee.zip"	
 	
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
MISSING NAME			预设: sugarwood_leaf_fx_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
冰箱			预设: icebox		路径： [string "scripts/prefabs/icebox.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "fridge", "HAMMER_workable", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("icebox")	
			inst.AnimState:SetBuild("ice_box")	
			Anim路径 :  "anim/ice_box.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
启迪陷阱			预设: alterguardian_phase3trap		路径： [string "scripts/prefabs/alterguardian_phase3trap.lu..."]	
	Tags▼	
	{":", "inspectable", "moonglass", "FROMNUM", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_meteor")	
			inst.AnimState:SetBuild("alterguardian_meteor")	
			Anim路径 :  "anim/alterguardian_meteor.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onalterguardianlasered")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
大烤架			预设: quagmire_grill_item		路径： [string "scripts/prefabs/quagmire_grill.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_grill")	
			inst.AnimState:SetBuild("quagmire_grill")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
蟹肉卷			预设: quagmire_food_063		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
 			预设: krampus		路径： [string "scripts/prefabs/krampus.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "freezable", "_inventory", "hostile", "_combat", "locomotor", "scarytoprey", "nolight", "deergemresistance", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("krampus")	
			inst.AnimState:SetBuild("krampus_build")	
			Anim路径 :  "anim/krampus_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inventory")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
甜辣龙椒沙拉			预设: dragonchilisalad_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
暗影操控器			预设: researchlab3		路径： [string "scripts/prefabs/magicprototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "level3", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab3")	
			inst.AnimState:SetBuild("researchlab3")	
			Anim路径 :  "anim/researchlab3.zip"	
 	
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
MISSING NAME			预设: lavaarena_meteor_splashbase		路径： [string "scripts/prefabs/lavaarena_meteor.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mudpuddle_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
冰淇淋			预设: icecream		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咖哩			预设: quagmire_food_037		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: lavaarena_fossilizing		路径： [string "scripts/prefabs/lavaarena_fossilizing.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wortox_eat_soul_fx		路径： [string "scripts/prefabs/wortox_eat_soul_fx.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wortox_eat_soul_fx")	
			inst.AnimState:SetBuild("wortox_eat_soul_fx")	
			Anim路径 :  "anim/wortox_eat_soul_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: lantern_flower_fx_held		路径： [string "scripts/prefabs/lantern_flower_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: alterguardian_lasertrail		路径： [string "scripts/prefabs/alterguardian_laser.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_staff_smoke_fx")	
			inst.AnimState:SetBuild("lavaarena_staff_smoke_fx")	
			Anim路径 :  "anim/lavaarena_staff_smoke_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
耕地机			预设: farm_plow		路径： [string "scripts/prefabs/farm_plow.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "scarytoprey", "canlight", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plow")	
			inst.AnimState:SetBuild("farm_plow")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("terraformer")	
		inst:AddComponent("workable")	
		inst:AddComponent("timer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
肉饼			预设: quagmire_food_015		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
肉串			预设: quagmire_food_011		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
肉丸			预设: quagmire_food_010		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: book_fx		路径： [string "scripts/prefabs/book_fx.lua"]	
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
MISSING NAME			预设: ghostflower_spirit1_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
炖鱼			预设: quagmire_food_005		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: blowdart_lava2_projectile_explosive		路径： [string "scripts/prefabs/blowdart_lava2.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_blowdart_attacks")	
			inst.AnimState:SetBuild("lavaarena_blowdart_attacks")	
			Anim路径 :  "anim/lavaarena_blowdart_attacks.zip"	
 	
	使用的组件▼	
------------------------------------------------	
常春藤			预设: quagmire_altar_ivy		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: stickleft		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蛞蝓龟黏液			预设: slurtleslime		路径： [string "scripts/prefabs/slurtleslime.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "explosive", "_stackable", "canlight", "CAVE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slurtle_slime")	
			inst.AnimState:SetBuild("slurtle_slime")	
			Anim路径 :  "anim/slurtle_slime.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("explosive")	
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
烧焦的食物			预设: quagmire_food_plate_burnt		路径： [string "scripts/prefabs/quagmire_food_burnt.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "overcooked", "show_spoiled"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mushtree_tall_webbed_burntfx		路径： [string "scripts/prefabs/mushtree_webbed.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_webbed")	
			inst.AnimState:SetBuild("mushroom_tree_webbed")	
			Anim路径 :  "anim/mushroom_tree_webbed.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_fastregen_buff		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
沙之石			预设: townportaltalisman		路径： [string "scripts/prefabs/townportaltalisman.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "townportaltalisman", "_stackable", "townportal"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("townportaltalisman")	
			inst.AnimState:SetBuild("townportaltalisman")	
			Anim路径 :  "anim/townportaltalisman.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("teleporter")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("linktownportals")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
粗壮常青树			预设: quagmire_evergreen_small		路径： [string "scripts/prefabs/quagmire_evergreen.lua"]	
	Tags▼	
	{":", "tree", "plant", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_short")	
			inst.AnimState:SetBuild("evergreen_new_2")	
			Anim路径 :  "anim/evergreen_short_normal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: thunder_close		路径： [string "scripts/prefabs/thunder_close.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
                  Failed to spawn	quagmirestage_cravings	
------------------------------------------------	
MISSING NAME			预设: lavaarena_lucy_spin		路径： [string "scripts/prefabs/lavaarena_lucy.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
姜饼猪屋			预设: gingerbreadhouse		路径： [string "scripts/prefabs/gingerbreadhouse.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gingerbread_house2")	
			inst.AnimState:SetBuild("gingerbread_house3")	
			Anim路径 :  "anim/gingerbread_house2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
第二次机会表			预设: pocketwatch_revive		路径： [string "scripts/prefabs/pocketwatch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "pocketwatch_inactive", "inspectable", "rechargeable", "pocketwatch_mountedcast", "pocketwatch", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch")	
			inst.AnimState:SetBuild("pocketwatch_wood")	
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
		inst:ListenForEvent("activateresurrection")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
石柱			预设: quagmire_park_obelisk		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
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
MISSING NAME			预设: lavaarena_portal_player_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: dug_berrybush_juicy_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush_juicy")	
			inst.AnimState:SetBuild("berrybush_juicy")	
			Anim路径 :  "anim/berrybush_juicy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
巨型南瓜			预设: pumpkin_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_pumpkin")	
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
船			预设: burnable_locator_medium		路径： [string "scripts/prefabs/burnable_locator_medium.lua"]	
	Tags▼	
	{":", "NOBLOCK", "ignorewalkableplatforms", "canlight", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
------------------------------------------------	
女王野兽			预设: quagmire_altar_queen		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_altar_queen")	
			inst.AnimState:SetBuild("quagmire_altar_queen")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
甜海鲜浓汤			预设: seafoodgumbo_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣鲜果可丽饼			预设: freshfruitcrepes_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蒜香花沙拉			预设: flowersalad_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: gargoyle_houndatk_fx		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
羽毛帽			预设: featherhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("featherhat")	
			inst.AnimState:SetBuild("hat_feather")	
			Anim路径 :  "anim/hat_feather.zip"	
 	
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
末日将至！			预设: book_brimstone		路径： [string "scripts/prefabs/books.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("books")	
			inst.AnimState:SetBuild("books")	
			Anim路径 :  "anim/books.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("book")	
		
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
变异菌类地皮			预设: turf_fungus_moon		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf_fungus_moon")	
			inst.AnimState:SetBuild("turf_fungus_moon")	
			Anim路径 :  "anim/turf_fungus_moon.zip"	
 	
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
小格罗姆			预设: critter_glomling_builder		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
二手假牙			预设: trinket_10		路径： [string "scripts/prefabs/trinkets.lua"]	
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
丰饶角雕塑			预设: chesspiece_hornucopia_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: abigailforcefieldbuffed		路径： [string "scripts/prefabs/abigailforcefield.lua"]	
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
甜炖肉汤			预设: bonestew_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
晾肉架			预设: meatrack		路径： [string "scripts/prefabs/meatrack.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "candry", "canlight", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_rack")	
			inst.AnimState:SetBuild("meat_rack")	
			Anim路径 :  "anim/meat_rack.zip"	
 	
	使用的组件▼	
		inst:AddComponent("dryer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
辣伏特羊肉冻			预设: voltgoatjelly_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
玉米鳕鱼			预设: oceanfish_medium_5		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_veggie", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_medium_5", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming", "VEGETARIAN_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_5")	
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
MISSING NAME			预设: attune_out_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
种下的风刮来的种子			预设: farm_plant_pomegranate		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "farm_plant_pomegranate", "DIG_workable", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_pomegranate_build")	
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
天体贡品			预设: moon_altar_cosmic		路径： [string "scripts/prefabs/moon_altar.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "HAMMER_workable", "structure", "moonaltarlinktarget", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_altar_crown")	
			inst.AnimState:SetBuild("moon_altar_crown")	
			Anim路径 :  "anim/moon_altar_crown.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("moonaltarlinktarget")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("calling_moon_relics")	
		inst:ListenForEvent("on_fissure_socket")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: none_fest_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ground_chunks_breaking		路径： [string "scripts/prefabs/ground_chunks_breaking.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的叶肉糕			预设: leafloaf_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
杀人蜂			预设: killerbee		路径： [string "scripts/prefabs/bee.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "freezable", "bee", "idle", "insect", "small_livestock", "smallcreature", "_stackable", "_combat", "locomotor", "NET_workable", "OMNI_eater", "scarytoprey", "nolight", "flying", "show_spoilage", "cattoyairborne", "ignorewalkableplatformdrowning", "sleeper", "killer", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee")	
			inst.AnimState:SetBuild("bee_angry_build")	
			Anim路径 :  "anim/bee.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("workable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("eater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("tradable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("stackable")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("worked")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("spawnedfromhaunt")	
	SG = 有▼	
------------------------------------------------	
咸的炸鱼排			预设: fishsticks_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "catfood", "spicedfood", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: battlesong_durability_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
薛蒙妮			预设: carnival_crowkid		路径： [string "scripts/prefabs/carnival_crowkid.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "inspectable", "RAW_eater", "_named", "idle", "NOBLOCK", "locomotor", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crow_kids")	
			inst.AnimState:SetBuild("crow_kids")	
			Anim路径 :  "anim/crow_kids.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("eater")	
		inst:AddComponent("talker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: moonbutterfly_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("baby_moon_tree")	
			inst.AnimState:SetBuild("baby_moon_tree")	
			Anim路径 :  "anim/baby_moon_tree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
辣曼德拉草汤			预设: mandrakesoup_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的什锦干果			预设: trailmix_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
司夜女神头盔			预设: lavaarena_strongdamagerhat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
多肉盆栽			预设: succulent_potted		路径： [string "scripts/prefabs/succulent_potted.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "HAMMER_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("succulent_potted")	
			inst.AnimState:SetBuild("succulent_potted")	
			Anim路径 :  "anim/succulent_potted.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: alterguardian_phase2spiketrail		路径： [string "scripts/prefabs/alterguardian_phase2spike.l..."]	
	Tags▼	
	{":", "groundspike", "_combat", "notarget", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_spike")	
			inst.AnimState:SetBuild("alterguardian_spike")	
			Anim路径 :  "anim/alterguardian_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("alterguardian_phase2spike._stop_trail")	
------------------------------------------------	
辣彩虹糖豆			预设: jellybean_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
小座狼			预设: critter_puppy_builder		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣加州卷			预设: californiaroll_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
沼泽地皮			预设: turf_marsh		路径： [string "scripts/prefabs/turfs.lua"]	
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
咸的芦笋冷汤			预设: gazpacho_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: weremoose_transform_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: gift_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香冰淇淋			预设: icecream_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
野猪猩			预设: trails2		路径： [string "scripts/prefabs/lavaarena_trails.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trails")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的无花果蛙腿三明治			预设: frognewton_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
天体探测仪			预设: archive_resonator		路径： [string "scripts/prefabs/archive_resonator.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "HAMMER_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_resonator")	
			inst.AnimState:SetBuild("archive_resonator")	
			Anim路径 :  "anim/archive_resonator.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("portablestructure")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
咸的花沙拉			预设: flowersalad_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: cane_victorian_fx		路径： [string "scripts/prefabs/cane_victorian_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
咸的水果圣代			预设: fruitmedley_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
羽毛帆布			预设: malbatross_feathered_weave		路径： [string "scripts/prefabs/malbatross_feathered_weave...."]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("malbatross_feathered_weave")	
			inst.AnimState:SetBuild("malbatross_feathered_weave")	
			Anim路径 :  "anim/malbatross_feathered_weave.zip"	
 	
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
咸的藤壶中细面			预设: barnaclinguine_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: atrium_gate_activatedfx		路径： [string "scripts/prefabs/atrium_gate_activatedfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_gate_overload_fx")	
			inst.AnimState:SetBuild("atrium_gate_overload_fx")	
			Anim路径 :  "anim/atrium_gate_overload_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香火鸡大餐			预设: turkeydinner_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的鳗鱼料理			预设: unagi_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: flotsam_break		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
炸鱼排			预设: fishsticks		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "catfood", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: sleepbomb_burst		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ocean_splash_small2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: portabletent_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tent_walter")	
			inst.AnimState:SetBuild("tent_walter")	
			Anim路径 :  "anim/tent_walter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: waterplant_burr_burst		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ember_short_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
便携研磨器			预设: portableblender_item		路径： [string "scripts/prefabs/portableblender.lua"]	
	Tags▼	
	{":", "_inventoryitem", "portableitem", "inspectable", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_blender")	
			inst.AnimState:SetBuild("portable_blender")	
			Anim路径 :  "anim/portable_blender.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("deployable")	
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
MISSING NAME			预设: chester_transform_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
池塘			预设: pond_cave		路径： [string "scripts/prefabs/pond.lua"]	
	Tags▼	
	{":", "inspectable", "watersource", "fishable", "antlion_sinkhole_blocker", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_tile")	
			inst.AnimState:SetBuild("marsh_tile")	
			Anim路径 :  "anim/marsh_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("fishable")	
		inst:AddComponent("watersource")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
蒸馏复仇			预设: ghostlyelixir_retaliation		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
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
MISSING NAME			预设: chesterlight		路径： [string "scripts/prefabs/chesterlight.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
警告表			预设: pocketwatch_weapon		路径： [string "scripts/prefabs/pocketwatch_weapon.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "NIGHTMARE_fueled", "pocketwatch", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_weapon")	
			inst.AnimState:SetBuild("pocketwatch_weapon")	
			Anim路径 :  "anim/pocketwatch_weapon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitem")	
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
MISSING NAME			预设: deer_ice_burst		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_ice_burst")	
			inst.AnimState:SetBuild("deer_ice_burst")	
			Anim路径 :  "anim/deer_ice_burst.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
漏洞			预设: boat_leak		路径： [string "scripts/prefabs/boat_leak.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_leak")	
			inst.AnimState:SetBuild("boat_leak_build")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("boatleak")	
		inst:AddComponent("lootdropper")	
		
------------------------------------------------	
野生作物			预设: plant_normal_ground		路径： [string "scripts/prefabs/plant_normal.lua"]	
	Tags▼	
	{":", "inspectable", "NPC_workable", "notreadyforharvest", "DIG_workable", "canlight", "witherable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plant_normal_ground")	
			inst.AnimState:SetBuild("plant_normal_ground")	
			Anim路径 :  "anim/plant_normal_ground.zip"	
 	
	使用的组件▼	
		inst:AddComponent("crop")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("timer")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("witherable")	
		
	使用的监听▼	
		inst:ListenForEvent("onhalloweenmoonmutate")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
德米特里			预设: pigelite3		路径： [string "scripts/prefabs/pigelite.lua"]	
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
第二次机会表			预设: pocketwatch_revive_reviver		路径： [string "scripts/prefabs/pocketwatch.lua"]	
	Tags▼	
	{":", "_inventoryitem"}	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("activateresurrection")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
蒜香香蕉冻			预设: bananapop_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
圆形种子			预设: quagmire_seeds_5		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: petrified_tree_fx_normal		路径： [string "scripts/prefabs/petrify_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wurt_tentacle_warning		路径： [string "scripts/prefabs/wurt_tentacle_warning.lua"]	
	Tags▼	
	{":", "DECOR", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wurt_xray")	
			inst.AnimState:SetBuild("wurt_xray")	
			Anim路径 :  "anim/wurt_xray.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_fancy3		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: acorn_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("acorn")	
			inst.AnimState:SetBuild("acorn")	
			Anim路径 :  "anim/acorn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
疙瘩树果			预设: oceantreenut		路径： [string "scripts/prefabs/oceantreenut.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantreenut")	
			inst.AnimState:SetBuild("oceantreenut")	
			Anim路径 :  "anim/oceantreenut.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("timer")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("on_salvaged")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("on_submerge")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: weremoose_shock_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
彩纸大炮			预设: carnivalcannon_confetti		路径： [string "scripts/prefabs/carnival_cannons.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "carnivaldecor", "carnivalcannon", "HAMMER_workable", "quickactivation", "canlight", "structure", "inactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon")	
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
MISSING NAME			预设: sinkhole_spawn_fx_3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
黄金斧头			预设: goldenaxe		路径： [string "scripts/prefabs/axe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "possessable_axe", "inspectable", "tool", "sharp", "_equippable", "CHOP_tool", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goldenaxe")	
			inst.AnimState:SetBuild("goldenaxe")	
			Anim路径 :  "anim/goldenaxe.zip"	
 	
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
MISSING NAME			预设: redpouch_yotb_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
未使用			预设: oceanfishinglure_spinner_yellow		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
MISSING NAME			预设: shadow_teleport_in		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蜘蛛腺			预设: spidergland		路径： [string "scripts/prefabs/spidergland.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_gland")	
			inst.AnimState:SetBuild("spider_gland")	
			Anim路径 :  "anim/spider_gland.zip"	
 	
	使用的组件▼	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
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
MISSING NAME			预设: oceanfishingbobber_twig_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_twig_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
犬牙陷阱			预设: trap_teeth		路径： [string "scripts/prefabs/trap_teeth.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "trap", "mineactive", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trap_teeth")	
			inst.AnimState:SetBuild("trap_teeth")	
			Anim路径 :  "anim/trap_teeth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("mine")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
邪天翁羽浮标			预设: oceanfishingbobber_malbatross_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_malbatross_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
MISSING NAME			预设: dr_warmer_loop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
黑鲶鱼			预设: oceanfish_medium_4_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_4")	
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
梦魇尖喙			预设: nightmarebeak		路径： [string "scripts/prefabs/nightmarecreature.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "shadow", "hostile", "_combat", "locomotor", "gestaltnoloot", "sanityaura", "nightmarecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_insanity2_basic")	
			Anim路径 :  "anim/shadow_insanity2_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("shadowsubmissive")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
闪电			预设: lightning		路径： [string "scripts/prefabs/lightning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lightning")	
			inst.AnimState:SetBuild("lightning")	
			Anim路径 :  "anim/lightning.zip"	
 	
	使用的组件▼	
------------------------------------------------	
鱼和薯条			预设: quagmire_food_018		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
鱼排			预设: fishmeat_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "fishmeat", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fishmeat")	
			inst.AnimState:SetBuild("fishmeat")	
			Anim路径 :  "anim/fishmeat.zip"	
 	
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
猎犬			预设: houndcorpse		路径： [string "scripts/prefabs/hound_corpse.lua"]	
	Tags▼	
	{":", "inspectable", "canlight", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hound")	
			inst.AnimState:SetBuild("hound")	
			Anim路径 :  "anim/hound_basic_transformation.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("timer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
充气背心			预设: balloonvest		路径： [string "scripts/prefabs/balloonvest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "noepicmusic", "_combat", "cattoy", "_equippable", "balloon", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("balloonvest")	
			inst.AnimState:SetBuild("balloonvest")	
			Anim路径 :  "anim/balloonvest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("poppable")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("fueled")	
		inst:AddComponent("health")	
		inst:AddComponent("flotationdevice")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蜂箱			预设: beebox		路径： [string "scripts/prefabs/beebox.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "playerowned", "canlight", "structure", "beebox", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_box")	
			inst.AnimState:SetBuild("bee_box")	
			Anim路径 :  "anim/bee_box.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("workable")	
		inst:AddComponent("harvestable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("childgoinghome")	
		inst:ListenForEvent("enterlight")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("enterdark")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
小蛾子			预设: critter_lunarmothling_builder		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnivaldecor_eggride2_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride2")	
			inst.AnimState:SetBuild("carnivaldecor_eggride2")	
			Anim路径 :  "anim/carnivaldecor_eggride2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
麦斯威尔之门			预设: adventure_portal		路径： [string "scripts/prefabs/adventure_portal.lua"]	
	Tags▼	
	{":", "inspectable", "quickactivation", "inactive", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portal_adventure")	
			inst.AnimState:SetBuild("portal_adventure")	
			Anim路径 :  "anim/portal_adventure.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("activatable")	
		
------------------------------------------------	
魂甲			预设: armor_sanity		路径： [string "scripts/prefabs/armor_sanity.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "shadow_item", "_equippable", "sanity"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_sanity")	
			inst.AnimState:SetBuild("armor_sanity")	
			Anim路径 :  "anim/armor_sanity.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("armor")	
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
薯片			预设: quagmire_food_002		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: walkingplank_item		路径： [string "scripts/prefabs/walkingplank.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_accessory", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seafarer_anchor")	
			inst.AnimState:SetBuild("seafarer_anchor")	
			Anim路径 :  "anim/seafarer_anchor.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fuel")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("deployable")	
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
鹿角			预设: deer_antler3		路径： [string "scripts/prefabs/deer_antler.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "deerantler", "klaussackkey"}	
 	
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
			预设: farm_soil		路径： [string "scripts/prefabs/farm_soil.lua"]	
	Tags▼	
	{":", "soil"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_soil")	
			inst.AnimState:SetBuild("farm_soil")	
			Anim路径 :  "anim/farm_soil.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("breaksoil")	
		inst:ListenForEvent("collapsesoil")	
------------------------------------------------	
穴居猴桶			预设: monkeybarrel		路径： [string "scripts/prefabs/monkeybarrel.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "HAMMER_workable", "canlight", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("monkey_barrel")	
			Anim路径 :  "anim/monkey_barrel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("workable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("warnquake")	
		inst:ListenForEvent("monkeydanger")	
		inst:ListenForEvent("safetospawn")	
------------------------------------------------	
秃鹫			预设: buzzard		路径： [string "scripts/prefabs/buzzard.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "_combat", "locomotor", "OMNI_eater", "scarytoprey", "nolight", "buzzard", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("buzzard")	
			inst.AnimState:SetBuild("buzzard_build")	
			Anim路径 :  "anim/buzzard_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
蘑菇			预设: quagmire_mushrooms		路径： [string "scripts/prefabs/quagmire_mushrooms.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_mushrooms")	
			inst.AnimState:SetBuild("quagmire_mushrooms")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: oldager_become_younger_back_fx_mount		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: archive_security_pulse		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":", "FROMNUM", "locomotor", "power_point"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_security_pulse")	
			inst.AnimState:SetBuild("archive_security_pulse")	
			Anim路径 :  "anim/archive_security_pulse.zip"	
 	
	使用的组件▼	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("locomote")	
------------------------------------------------	
良羽鸦			预设: carnival_host		路径： [string "scripts/prefabs/carnival_host.lua"]	
	Tags▼	
	{":", "inspectable", "idle", "locomotor", "character", "prototyper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_host")	
			inst.AnimState:SetBuild("carnival_host")	
			Anim路径 :  "anim/carnival_host.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("talker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_carnivalplazabuilt")	
	SG = 有▼	
------------------------------------------------	
被击败的天体英雄			预设: alterguardian_phase3dead		路径： [string "scripts/prefabs/alterguardian_phase3dead.lu..."]	
	Tags▼	
	{":", "inspectable", "moonglass", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_spawn_death")	
			inst.AnimState:SetBuild("alterguardian_spawn_death")	
			Anim路径 :  "anim/alterguardian_spawn_death.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
蜘蛛战士			预设: spider_warrior		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "halloweenmoonmutable", "show_spoilage", "drop_inventory_onmurder", "sleeper", "eatsrawmeat", "spider", "fresh", "spider_warrior"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider")	
			inst.AnimState:SetBuild("spider_warrior_build")	
			Anim路径 :  "anim/ds_spider_cannon.zip"	
 	
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
远古壁画			预设: atrium_rubble		路径： [string "scripts/prefabs/atrium_rubble.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_rubble")	
			inst.AnimState:SetBuild("atrium_rubble")	
			Anim路径 :  "anim/atrium_rubble.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
天体英雄			预设: alterguardian_phase1		路径： [string "scripts/prefabs/alterguardian_phase1.lua"]	
	Tags▼	
	{":", "mech", "monster", "_health", "inspectable", "freezable", "idle", "hostile", "noepicmusic", "_combat", "locomotor", "brightmareboss", "sanityaura", "epic", "scarytoprey", "soulless", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_phase1")	
			inst.AnimState:SetBuild("alterguardian_phase1")	
			Anim路径 :  "anim/alterguardian_phase1.zip"	
 	
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
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("phasetransition")	
		inst:ListenForEvent("blocked")	
	SG = 有▼	
------------------------------------------------	
邪天翁羽毛			预设: malbatross_feather		路径： [string "scripts/prefabs/malbatross_feather.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("malbatross_feather")	
			inst.AnimState:SetBuild("malbatross_feather")	
			Anim路径 :  "anim/malbatross_feather.zip"	
 	
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
MISSING NAME			预设: signright		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
骨头头盔			预设: skeletonhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "shadowdominance", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("skeletonhat")	
			inst.AnimState:SetBuild("hat_skeleton")	
			Anim路径 :  "anim/hat_skeleton.zip"	
 	
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
科学机器			预设: researchlab		路径： [string "scripts/prefabs/scienceprototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "level1", "structure", "prototyper", "SnowCovered", "giftmachine", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab")	
			inst.AnimState:SetBuild("researchlab")	
			Anim路径 :  "anim/researchlab.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("wardrobe")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ms_addgiftreceiver")	
		inst:ListenForEvent("ms_removegiftreceiver")	
		inst:ListenForEvent("ms_giftopened")	
------------------------------------------------	
远古伪科学站			预设: ancient_altar_broken		路径： [string "scripts/prefabs/altar_prototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "workrepairable", "altar", "structure", "repairable_thulecite", "stone", "prototyper", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crafting_table")	
			inst.AnimState:SetBuild("crafting_table")	
			Anim路径 :  "anim/crafting_table.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("repairable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
------------------------------------------------	
MISSING NAME			预设: wintersfeastbuff		路径： [string "scripts/prefabs/wintersfeastbuff.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
海鲜浓汤			预设: seafoodgumbo		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food2")	
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
辣爆炒填馅辣椒			预设: pepperpopper_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "badfood", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
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
铥矿墙			预设: brokenwall_ruins_2		路径： [string "scripts/prefabs/brokenwalls.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "HAMMER_workable", "ruins", "stone", "wall", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins_2")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: hammer_mjolnir_crackle		路径： [string "scripts/prefabs/hammer_mjolnir.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_hammer_attack_fx")	
			inst.AnimState:SetBuild("lavaarena_hammer_attack_fx")	
			Anim路径 :  "anim/lavaarena_hammer_attack_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
步行手杖			预设: cane		路径： [string "scripts/prefabs/cane.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cane")	
			inst.AnimState:SetBuild("swap_cane")	
			Anim路径 :  "anim/cane.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("weapon")	
		inst:AddComponent("equippable")	
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
MISSING NAME			预设: none_fest_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
采下的芦苇			预设: cutreeds		路径： [string "scripts/prefabs/cutreeds.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_ROUGHAGE", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cutreeds")	
			inst.AnimState:SetBuild("cutreeds")	
			Anim路径 :  "anim/cutreeds.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
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
MISSING NAME			预设: atrium_gate_explodesfx		路径： [string "scripts/prefabs/atrium_gate_pulsesfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: reticulearc		路径： [string "scripts/prefabs/reticulearc.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticulearc")	
			inst.AnimState:SetBuild("reticulearc")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------
MISSING NAME			预设: upper_nightmarefissurefx		路径： [string "scripts/prefabs/nightmarelightfx.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmare_crack_upper_fx")	
			inst.AnimState:SetBuild("nightmare_crack_upper_fx")	
			Anim路径 :  "anim/nightmare_crack_upper_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pocketwatch_weapon_fx		路径： [string "scripts/prefabs/pocketwatch_weapon_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: red_leaves		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnival_streamer_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: townportalsandcoffin_fx		路径： [string "scripts/prefabs/townportal.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("teleport_sand_fx")	
			inst.AnimState:SetBuild("teleport_sand_fx")	
			Anim路径 :  "anim/teleport_sand_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
海鲜牛排			预设: surfnturf		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food2")	
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
圣诞灯			预设: winter_ornament_light3		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "lightbattery", "inspectable", "molebait", "winter_ornament", "cattoy", "CAVE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("timer")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
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
------------------------------------------------	
MISSING NAME			预设: spat_splash_fx_low		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: reticulelongmulti		路径： [string "scripts/prefabs/reticulelong.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticulelong")	
			inst.AnimState:SetBuild("reticulelong")	
			Anim路径 :  "anim/reticulelong.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
鱼人工艺屋			预设: mermhouse_crafted		路径： [string "scripts/prefabs/mermhouse.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mermhouse_crafted")	
			inst.AnimState:SetBuild("mermhouse_crafted")	
			Anim路径 :  "anim/mermhouse_crafted.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
熊皮背心			预设: beargervest		路径： [string "scripts/prefabs/beargervest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("torso_bearger")	
			inst.AnimState:SetBuild("torso_bearger")	
			Anim路径 :  "anim/torso_bearger.zip"	
 	
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
辣芝士蛋糕			预设: powcake_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: crater_steam_fx1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: attackfire_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
锚套装			预设: anchor_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_accessory", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seafarer_anchor")	
			inst.AnimState:SetBuild("seafarer_anchor")	
			Anim路径 :  "anim/seafarer_anchor.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fuel")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("deployable")	
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
裁判席			预设: yotb_stage_item		路径： [string "scripts/prefabs/yotb_stage.lua"]	
	Tags▼	
	{":", "_inventoryitem", "portableitem", "inspectable", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotb_stagebooth_item")	
			inst.AnimState:SetBuild("yotb_stagebooth_item")	
			Anim路径 :  "anim/yotb_stagebooth_item.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitemmoisture")	
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
环状零件			预设: teleportato_ring		路径： [string "scripts/prefabs/teleportato_parts.lua"]	
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
铥矿墙			预设: brokenwall_stone		路径： [string "scripts/prefabs/brokenwalls.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "HAMMER_workable", "stone", "wall", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_stone")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_fancy5		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: archive_security_pulse_sfx		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		inst:AddComponent("updatelooper")	
		
------------------------------------------------	
甜果酱			预设: jammypreserves_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: beargerwarning_lvl1		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_creature_teleport_small_fx		路径： [string "scripts/prefabs/lavaarena_creature_spawn_fx..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: slingshotammo_rock_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
MISSING NAME			预设: moon_device_meteor_spawner		路径： [string "scripts/prefabs/moon_device.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蓬松土豆蛋奶酥			预设: potatosouffle		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
洞察皇冠			预设: lavaarena_eyecirclethat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
                  Failed to spawn	lavaarena_battlestandard_healbuff	
------------------------------------------------	
吹箭			预设: blowdart_lava		路径： [string "scripts/prefabs/blowdart_lava.lua"]	
	Tags▼	
	{":", "blowdart", "aoeblowdart_long", "rechargeable", "sharp", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blowdart_lava")	
			inst.AnimState:SetBuild("blowdart_lava")	
			Anim路径 :  "anim/blowdart_lava.zip"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
鱼人头			预设: mermhead		路径： [string "scripts/prefabs/stickheads.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "beaverchewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_head")	
			inst.AnimState:SetBuild("merm_head")	
			Anim路径 :  "anim/merm_head.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
机器人玩偶			预设: trinket_11		路径： [string "scripts/prefabs/trinkets.lua"]	
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
起点套装			预设: yotc_carrat_race_start_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_racekit_start")	
			inst.AnimState:SetBuild("yotc_carrat_racekit_start")	
			Anim路径 :  "anim/yotc_carrat_racekit_start.zip:IDLE"	
 	
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
咸的火鸡大餐			预设: turkeydinner_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
圣诞灯			预设: winter_ornament_light5		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "lightbattery", "inspectable", "molebait", "winter_ornament", "cattoy", "CAVE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments")	
			inst.AnimState:SetBuild("winter_ornaments")	
			Anim路径 :  "anim/winter_ornaments.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("timer")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
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
------------------------------------------------	
MISSING NAME			预设: quagmire_planted_soil_back		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("quagmire_soil")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: halloweenpotion_health_small_buff		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
花朵皮弗娄牛玩偶			预设: yotb_beefalo_doll_nature		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
龙虾汤			预设: lobsterbisque		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food3")	
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
MISSING NAME			预设: lavaarena_firebomb_proc_fx		路径： [string "scripts/prefabs/lavaarena_firebomb.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_firebomb")	
			inst.AnimState:SetBuild("lavaarena_firebomb")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_dragonfly		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
蒜粉			预设: spice_garlic		路径： [string "scripts/prefabs/spices.lua"]	
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
MISSING NAME			预设: impact		路径： [string "scripts/prefabs/impact.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: seeds_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_soil")	
			inst.AnimState:SetBuild("farm_soil")	
			Anim路径 :  "anim/farm_soil.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
组装一半的圣殿			预设: moon_altar_astral		路径： [string "scripts/prefabs/moon_altar.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "HAMMER_workable", "workrepairable", "repairable_moon_altar", "structure", "moonaltarlinktarget", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_altar_claw")	
			inst.AnimState:SetBuild("moon_altar_claw")	
			Anim路径 :  "anim/moon_altar_claw.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("repairable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("moonaltarlinktarget")	
		
	使用的监听▼	
		inst:ListenForEvent("calling_moon_relics")	
		inst:ListenForEvent("on_fissure_socket")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蒜香蔬菜鸡尾酒			预设: vegstinger_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
 背包			预设: krampus_sack		路径： [string "scripts/prefabs/krampus_sack.lua"]	
	Tags▼	
	{":", "_inventoryitem", "backpack", "inspectable", "_container", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_krampus_sack")	
			Anim路径 :  "anim/backpack.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("container")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
麋鹿鹅雕塑			预设: chesspiece_moosegoose_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
战士变身涂鸦			预设: mutator_warrior		路径： [string "scripts/prefabs/spider_mutators.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "monstermeat", "BURNABLE_fuel", "badfood", "canlight", "spidermutator"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("spider_mutators")	
			Anim路径 :  "anim/spider_mutators.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("spidermutator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
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
MISSING NAME			预设: treasurechest_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("chest")	
			inst.AnimState:SetBuild("treasure_chest")	
			Anim路径 :  "anim/treasure_chest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: fire_projectile		路径： [string "scripts/prefabs/staff_projectile.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("projectile")	
			inst.AnimState:SetBuild("staff_projectile")	
			Anim路径 :  "anim/staff_projectile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		
------------------------------------------------	
眼睛炮塔			预设: eyeturret		路径： [string "scripts/prefabs/eyeturret.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "companion", "idle", "_inventory", "_combat", "sanityaura", "eyeturret", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeball_turret")	
			inst.AnimState:SetBuild("eyeball_turret")	
			Anim路径 :  "anim/eyeball_turret.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: sugarwood_leaf_withered_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fence_gate_anim		路径： [string "scripts/prefabs/fence.lua"]	
	Tags▼	
	{":", "fx", "can_offset_sort_pos", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fence_gate")	
			inst.AnimState:SetBuild("fence_gate")	
			Anim路径 :  "anim/fence_gate.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: dr_warm_loop_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
礼物			预设: gift		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gift")	
			inst.AnimState:SetBuild("gift")	
			Anim路径 :  "anim/gift.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("unwrappable")	
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
华丽的装饰			预设: winter_ornament_boss_noeyered		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
企鸥			预设: penguin		路径： [string "scripts/prefabs/penguin.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "_inventory", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "locomotor", "OMNI_eater", "nolight", "penguin", "team_penguin", "halloweenmoonmutable", "_hunger", "herdmember", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("penguin")	
			inst.AnimState:SetBuild("penguin_build")	
			Anim路径 :  "anim/penguin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("halloweenmoonmutable")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hunger")	
		inst:AddComponent("teamattacker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("leavemood")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("entermood")	
	SG = 有▼	
------------------------------------------------	
象鼻排			预设: trunk_cooked		路径： [string "scripts/prefabs/trunk.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("koalephant_trunk")	
			Anim路径 :  "anim/koalephant_trunk.zip"	
 	
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
MISSING NAME			预设: confetti_fx		路径： [string "scripts/prefabs/confetti_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
绿蘑菇树			预设: mushtree_small		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "FROMNUM", "mushtree", "tree", "plant", "CHOP_workable", "canlight", "shelter", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_small")	
			inst.AnimState:SetBuild("mushroom_tree_small")	
			Anim路径 :  "anim/mushroom_tree_small.zip"	
 	
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
		
------------------------------------------------	
睡前故事			预设: book_sleep		路径： [string "scripts/prefabs/books.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("books")	
			inst.AnimState:SetBuild("books")	
			Anim路径 :  "anim/books.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("book")	
		
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
充能玻璃石			预设: moonstorm_glass		路径： [string "scripts/prefabs/moonstorm_glass.lua"]	
	Tags▼	
	{":", "inspectable", "moonglass", "FROMNUM", "_named", "MINE_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_charged")	
			inst.AnimState:SetBuild("moonglass_charged_tile")	
			Anim路径 :  "anim/moonglass_charged_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("timer")	
		inst:AddComponent("updatelooper")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
月岩墙			预设: wall_moonrock		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "moonrock", "_health", "inspectable", "cannotheal", "HAMMER_workable", "repairable_moonrock", "_combat", "healthrepairable", "stone", "wall", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_moonrock")	
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
甜龙虾正餐			预设: lobsterdinner_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
犁地草			预设: tillweed		路径： [string "scripts/prefabs/tillweed.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "BURNABLE_fuel", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tillweed")	
			inst.AnimState:SetBuild("tillweed")	
			Anim路径 :  "anim/tillweed.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
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
沼泽猪长老			预设: quagmire_swampigelder		路径： [string "scripts/prefabs/quagmire_swampigelder.lua"]	
	Tags▼	
	{":", "character", "prototyper", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
		
------------------------------------------------	
远古灯柱			预设: atrium_light		路径： [string "scripts/prefabs/atrium_light.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_light")	
			inst.AnimState:SetBuild("atrium_light")	
			Anim路径 :  "anim/atrium_light.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("atriumpowered")	
------------------------------------------------	
南瓜派			预设: pumpkinpie		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
韦伯			预设: webber		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "monster", "trader", "_health", "inspectable", "spider_upgradeuser", "freezable", "player", "idle", "spiderwhisperer", "_builder", "_sanity", "bearded", "_inventory", "strongstomach", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "playermonster", "_rider", "dualsoul", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser", "eatsrawmeat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("webber")	
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
		inst:AddComponent("beard")	
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
		inst:ListenForEvent("repelled")	
		inst:ListenForEvent("done_embark_movement")	
		inst:ListenForEvent("onareaattackother")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("sheltered")	
		inst:ListenForEvent("localplayer._hermit_music")	
		inst:ListenForEvent("heargrue")	
		inst:ListenForEvent("onstartedfire")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("stopfiredamage")	
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
辣鱼肉玉米卷			预设: fishtacos_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
小钢羊			预设: critter_lamb		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "idle", "small_livestock", "NOBLOCK", "locomotor", "OMNI_eater", "_follower", "critter", "sleeper", "noauradamage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("sheepington_build")	
			Anim路径 :  "anim/sheepington_basic.zip"	
 	
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
幸运兽躯体			预设: dragonbodyhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonbodyhat")	
			inst.AnimState:SetBuild("hat_dragonbody")	
			Anim路径 :  "anim/hat_dragonbody.zip"	
 	
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
小风干肉			预设: smallmeat_dried		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "dryable", "_stackable", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_rack_food")	
			inst.AnimState:SetBuild("meat_rack_food")	
			Anim路径 :  "anim/meat_rack_food.zip"	
 	
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
小座狼			预设: critter_puppy		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "idle", "small_livestock", "NOBLOCK", "locomotor", "OMNI_eater", "_follower", "critter", "sleeper", "noauradamage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("pupington_build")	
			Anim路径 :  "anim/pupington_basic.zip"	
 	
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
蒜香果冻沙拉			预设: leafymeatsouffle_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蓝带鱼排			预设: frogfishbowl		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "masterfood", "badfood", "canlight", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: twiggy_nut_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("twiggy_nut")	
			inst.AnimState:SetBuild("twiggy_nut")	
			Anim路径 :  "anim/twiggy_nut.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
藤壶握寿司			预设: barnaclesushi		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
------------------------------------------------	
面包圈和鱼			预设: quagmire_food_047		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
生鱼肉			预设: fishmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "fishmeat", "dryable", "_stackable", "cookable", "catfood", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fishmeat")	
			inst.AnimState:SetBuild("fishmeat")	
			Anim路径 :  "anim/fishmeat.zip"	
 	
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
眼球草			预设: eyeplant		路径： [string "scripts/prefabs/eyeplant.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "idle", "_inventory", "hostile", "smallcreature", "_combat", "MEAT_eater", "locomotor", "canlight", "eyeplant", "veggie", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeplant")	
			inst.AnimState:SetBuild("eyeplant")	
			Anim路径 :  "anim/eyeplant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("gotnewitem")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
叽叽喳喳斗篷			预设: carnival_vest_b		路径： [string "scripts/prefabs/carnival_vest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_vest_b")	
			inst.AnimState:SetBuild("carnival_vest_b")	
			Anim路径 :  "anim/carnival_vest_b.zip"	
 	
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
MISSING NAME			预设: miniboatlantern_loseballoon		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
海带叶			预设: kelp		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "dryable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("kelp")	
			inst.AnimState:SetBuild("kelp")	
			Anim路径 :  "anim/kelp.zip"	
 	
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
		inst:AddComponent("dryable")	
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
辣海鲜浓汤			预设: seafoodgumbo_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: deer_fire_burst		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_fire_burst")	
			inst.AnimState:SetBuild("deer_fire_burst")	
			Anim路径 :  "anim/deer_fire_burst.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_plain6		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: mushroombomb_dark_projectile		路径： [string "scripts/prefabs/mushroombomb.lua"]	
	Tags▼	
	{":", "projectile", "locomotor", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroombomb")	
			inst.AnimState:SetBuild("mushroombomb_dark_build")	
			Anim路径 :  "anim/mushroombomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
传送门用具			预设: multiplayer_portal_moonrock_constr_plans		路径： [string "scripts/prefabs/constructionplans.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "multiplayer_portal_plans", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("construction_plans")	
			inst.AnimState:SetBuild("construction_plans")	
			Anim路径 :  "anim/construction_plans.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("constructionplans")	
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
紫宝石			预设: purplegem		路径： [string "scripts/prefabs/gem.lua"]	
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
MISSING NAME			预设: fossilizing_fx_2		路径： [string "scripts/prefabs/fossilized_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
皮普顿的马车			预设: quagmire_merm_cart2		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
种下的种子			预设: farm_plant_randomseed		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "farm_plant_randomseed", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_soil")	
			inst.AnimState:SetBuild("farm_soil")	
			Anim路径 :  "anim/farm_soil.zip"	
 	
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
MISSING NAME			预设: lavaarena_fossilizedebris2		路径： [string "scripts/prefabs/lavaarena_fossilizing.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_fossilizedebris"}	
 	
	使用的组件▼	
		
------------------------------------------------	
烤蛙腿			预设: froglegs_cooked		路径： [string "scripts/prefabs/froglegs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "smallmeat", "_stackable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("frog_legs")	
			inst.AnimState:SetBuild("frog_legs")	
			Anim路径 :  "anim/frog_legs.zip"	
 	
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
MISSING NAME			预设: weaponsparks_thrusting		路径： [string "scripts/prefabs/weaponsparks.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
MISSING NAME			预设: ancient_altar_broken_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
终点线			预设: yotc_carrat_race_finish		路径： [string "scripts/prefabs/yotc_carrat_race_finish.lua"]	
	Tags▼	
	{":", "inspectable", "yotc_racefinishline", "HAMMER_workable", "yotc_racecheckpoint", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_race_finish")	
			inst.AnimState:SetBuild("yotc_carrat_race_finish")	
			Anim路径 :  "anim/yotc_carrat_race_finish.zip"	
 	
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
MISSING NAME			预设: beetletaur_fossilized_break_fx_left		路径： [string "scripts/prefabs/lavaarena_beetletaur.lua"]	
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
辣藤壶中细面			预设: barnaclinguine_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
甜鳄梨酱			预设: guacamole_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
甜味鱼			预设: oceanfish_medium_9		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_medium_9", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming", "BERRY_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_9")	
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
暗影心房			预设: shadowheart		路径： [string "scripts/prefabs/shadowheart.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadowheart")	
			inst.AnimState:SetBuild("shadowheart")	
			Anim路径 :  "anim/shadowheart.zip"	
 	
	使用的组件▼	
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
红薯焗饭			预设: wintercooking_sweetpotato		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
莎草纸			预设: papyrus		路径： [string "scripts/prefabs/papyrus.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("papyrus")	
			inst.AnimState:SetBuild("papyrus")	
			Anim路径 :  "anim/papyrus.zip"	
 	
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
菌类地皮			预设: turf_fungus		路径： [string "scripts/prefabs/turfs.lua"]	
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
华夫饼			预设: waffles		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
甜骨头汤			预设: bonesoup_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣龙虾正餐			预设: lobsterdinner_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣蔬菜鸡尾酒			预设: vegstinger_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
封印的传送门			预设: archive_portal		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":", "groundhole", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_portal")	
			inst.AnimState:SetBuild("archive_portal")	
			Anim路径 :  "anim/archive_portal.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
大理石甲			预设: armormarble		路径： [string "scripts/prefabs/armor_marble.lua"]	
	Tags▼	
	{":", "_inventoryitem", "marble", "inspectable", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_marble")	
			inst.AnimState:SetBuild("armor_marble")	
			Anim路径 :  "anim/armor_marble.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("armor")	
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
MISSING NAME			预设: bishop_nightmare_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
MISSING NAME			预设: weregoose_feathers2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
长猪肉干			预设: humanmeat_dried		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "badfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_rack_food")	
			inst.AnimState:SetBuild("meat_rack_food")	
			Anim路径 :  "anim/meat_rack_food.zip"	
 	
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
MISSING NAME			预设: cointosscastfx		路径： [string "scripts/prefabs/staffcastfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cointosscast_fx")	
			inst.AnimState:SetBuild("cointosscast_fx")	
			Anim路径 :  "anim/cointosscast_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	

------------------------------------------------	
农作物			预设: quagmire_garlic_planted		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "plantedsoil", "fertilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
发光浆果慕斯			预设: glowberrymousse		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
鳄鱼指挥官			预设: snapper		路径： [string "scripts/prefabs/lavaarena_snapper.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("snapper")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
损毁的自行车			预设: quagmire_rubble_bike		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: oceanvine_patch		路径： [string "scripts/prefabs/oceanvine.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("build:")	
			inst.AnimState:SetBuild("Anim")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
酸橘汁腌鱼			预设: ceviche		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
鹿角			预设: deer_antler1		路径： [string "scripts/prefabs/deer_antler.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "deerantler", "klaussackkey"}	
 	
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
船套装			预设: boat_item		路径： [string "scripts/prefabs/boat.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight", "deployable", "boatbuilder", "usedeployspacingasoffset"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seafarer_boat")	
			inst.AnimState:SetBuild("seafarer_boat")	
			Anim路径 :  "anim/seafarer_boat.zip:IDLE"	
 	
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
虚影			预设: gestalt		路径： [string "scripts/prefabs/gestalt.lua"]	
	Tags▼	
	{":", "idle", "NOBLOCK", "_combat", "locomotor", "sanityaura", "brightmare", "brightmare_gestalt"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt")	
			inst.AnimState:SetBuild("brightmare_gestalt")	
			Anim路径 :  "anim/brightmare_gestalt.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("transparentonsanity")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("losttarget")	
		inst:ListenForEvent("droppedtarget")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: peghook_spitfx		路径： [string "scripts/prefabs/lavaarena_peghook.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
怪物肉干			预设: monstermeat_dried		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "dryable", "_stackable", "monstermeat", "badfood", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_rack_food")	
			inst.AnimState:SetBuild("meat_rack_food")	
			Anim路径 :  "anim/meat_rack_food.zip"	
 	
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
海钓竿			预设: oceanfishingrod		路径： [string "scripts/prefabs/oceanfishingrod.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_container", "_oceanfishingrod", "allow_action_on_impassable", "accepts_oceanfishingtackle", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fishingrod_ocean")	
			inst.AnimState:SetBuild("fishingrod_ocean")	
			Anim路径 :  "anim/fishingrod_ocean.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("reticule")	
		inst:AddComponent("oceanfishingrod")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("container")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: reticuleline2		路径： [string "scripts/prefabs/reticuleline.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleline2")	
			inst.AnimState:SetBuild("reticuleline2")	
			Anim路径 :  "anim/reticuleline2.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
木球浮标			预设: oceanfishingbobber_ball_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_ball_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
甜肉丸			预设: meatballs_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: mushtree_tall_burntfx		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("mushroom_tree_tall")	
			Anim路径 :  "anim/mushroom_tree_tall.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
应用园艺学			预设: book_gardening		路径： [string "scripts/prefabs/books.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("books")	
			inst.AnimState:SetBuild("books")	
			Anim路径 :  "anim/books.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("book")	
		
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
花环			预设: flowerhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "open_top_hat", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flowerhat")	
			inst.AnimState:SetBuild("hat_flower")	
			Anim路径 :  "anim/hat_flower.zip"	
 	
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
MISSING NAME			预设: ruinsrelic_plate_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_plate")	
			inst.AnimState:SetBuild("ruins_plate")	
			Anim路径 :  "anim/ruins_plate.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
花沙拉			预设: flowersalad		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
平檐帽犀牛兄弟			预设: rhinodrill2		路径： [string "scripts/prefabs/lavaarena_rhinodrill.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rhinodrill")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香恐怖国王饼			预设: nightmarepie_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "unsafefood", "edible_VEGGIE", "canlight", "spicedfood", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: tears		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cavein_debris		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: farm_plant_happy		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wave_shimmer_deep		路径： [string "scripts/prefabs/wave_shimmer.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED", "NOBLOCK", "ignorewalkableplatforms", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wave_shimmer_deep")	
			Anim路径 :  "anim/wave_shimmer_deep.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
月岩雕像			预设: moonrockidol		路径： [string "scripts/prefabs/moonrockidol.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "moonportalkey"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonrock_idol")	
			inst.AnimState:SetBuild("moonrock_idol")	
			Anim路径 :  "anim/moonrock_idol.zip"	
 	
	使用的组件▼	
		inst:AddComponent("moonrelic")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("ms_moonportalproximity")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	

------------------------------------------------	
探测杖			预设: diviningrod		路径： [string "scripts/prefabs/diviningrod.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "diviningrod", "nonpotatable", "maxwell_key", "_equippable", "nopunch", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("diviningrod")	
			inst.AnimState:SetBuild("diviningrod")	
			Anim路径 :  "anim/diviningrod.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("key")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("equippable")	
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
齿轮			预设: gears		路径： [string "scripts/prefabs/gears.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_GEARS", "work_gears", "molebait", "_stackable", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gears")	
			inst.AnimState:SetBuild("gears")	
			Anim路径 :  "anim/gears.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("repairer")	
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
微型树套装			预设: carnivaldecor_plant_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_plant")	
			inst.AnimState:SetBuild("carnivaldecor_plant")	
			Anim路径 :  "anim/carnivaldecor_plant.zip"	
 	
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
MISSING NAME			预设: balloon_pop_body		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的火龙果派			预设: dragonpie_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: wetpouch_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
茶几			预设: endtable		路径： [string "scripts/prefabs/endtable.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "vase", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stagehand")	
			inst.AnimState:SetBuild("stagehand")	
			Anim路径 :  "anim/stagehand.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("vase")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ondeconstructstructure")	
------------------------------------------------	
派对气球			预设: balloonparty		路径： [string "scripts/prefabs/balloonparty.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "noepicmusic", "_combat", "cattoyairborne", "_equippable", "nopunch", "balloon", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("balloon2")	
			inst.AnimState:SetBuild("balloon2")	
			Anim路径 :  "anim/balloon2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("poppable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("equippable")	
		inst:AddComponent("combat")	
		inst:AddComponent("inventoryitem")	
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
		inst:ListenForEvent("death")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	

------------------------------------------------	
影子分身			预设: quagmire_shadowwaxwell		路径： [string "scripts/prefabs/quagmire_shadowwaxwell.lua"]	
	Tags▼	
	{":", "NOBLOCK", "scarytoprey", "shadowminion"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("waxwell_shadow_mod")	
			Anim路径 :  "anim/player_groggy.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
螃蟹蛋糕			预设: quagmire_food_059		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
水果圣代			预设: fruitmedley		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: homesign_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_home")	
			inst.AnimState:SetBuild("sign_home")	
			Anim路径 :  "anim/sign_home.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
牛角			预设: horn		路径： [string "scripts/prefabs/horn.lua"]	
	Tags▼	
	{":", "_inventoryitem", "horn", "inspectable", "PLAY_tool", "tool"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("horn")	
			inst.AnimState:SetBuild("horn")	
			Anim路径 :  "anim/horn.zip"	
 	
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
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
丰饶角雕塑			预设: chesspiece_hornucopia		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_hornucopia_stone")	
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
```
