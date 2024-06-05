> 摘录う丶青木
- 数据提取3
```lua
德米特里			预设: pigelitefighter3		路径： [string "scripts/prefabs/pigelitefighter.lua"]	
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
荧光花			预设: flower_cave_double		路径： [string "scripts/prefabs/flower_cave.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "halloweenmoonmutable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bulb_plant_double")	
			inst.AnimState:SetBuild("bulb_plant_double")	
			Anim路径 :  "anim/bulb_plant_double.zip"	
 	
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
小火鸡			预设: critter_perdling		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "idle", "small_livestock", "NOBLOCK", "locomotor", "OMNI_eater", "_follower", "critter", "sleeper", "noauradamage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("perdling_build")	
			Anim路径 :  "anim/perdling_basic.zip"	
 	
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
MISSING NAME			预设: petrified_tree_fx_short		路径： [string "scripts/prefabs/petrify_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
MISSING NAME			预设: quagmire_potato_leaf		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
煮熟的碎肉			预设: quagmire_cookedsmallmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
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
咸的海鲜浓汤			预设: seafoodgumbo_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的果酱			预设: jammypreserves_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
英勇美声颂			预设: battlesong_sanityaura		路径： [string "scripts/prefabs/battlesongs.lua"]	
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
辣南瓜饼干			预设: pumpkincookie_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: crab_king_shine		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜波兰水饺			预设: perogies_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的蔬菜鸡尾酒			预设: vegstinger_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: firering_fx		路径： [string "scripts/prefabs/fireringfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
伯尼			预设: bernie_inactive		路径： [string "scripts/prefabs/bernie_inactive.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "nopunch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bernie_build")	
			Anim路径 :  "anim/bernie.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("timer")	
		inst:AddComponent("insulator")	
		inst:AddComponent("fueled")	
		inst:AddComponent("hauntable")	
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
------------------------------------------------	
芦笋			预设: asparagus		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
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
岩石			预设: cavein_boulder		路径： [string "scripts/prefabs/cavein_boulder.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "caveindebris", "boulder", "MINE_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavein_boulder")	
			inst.AnimState:SetBuild("swap_cavein_boulder")	
			Anim路径 :  "anim/cavein_boulder.zip"	
 	
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
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stopfalling")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("startfalling")	
------------------------------------------------	
小鱼块			预设: fishmeat_small		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "fishmeat", "dryable", "_stackable", "cookable", "catfood", "lureplant_bait", "fresh"}	
 	
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
MISSING NAME			预设: bullkelp_root_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bullkelp")	
			inst.AnimState:SetBuild("bullkelp")	
			Anim路径 :  "anim/bullkelp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
                  Failed to spawn	lavaarena_battlestandard_shieldbuff	
------------------------------------------------	
信号弹			预设: miniflare_minimap		路径： [string "scripts/prefabs/miniflare.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
爆炒填馅辣椒			预设: pepperpopper		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "badfood", "canlight", "preparedfood", "fresh"}	
 	
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
蔚蓝羽浮标			预设: oceanfishingbobber_robin_winter		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_robin_winter_build")	
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
尖形种子			预设: onion_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
超级可爱岩浆虫			预设: lavae_pet		路径： [string "scripts/prefabs/lavae_pet.lua"]	
	Tags▼	
	{":", "notraptrigger", "trader", "_health", "inspectable", "FROMNUM", "freezable", "companion", "idle", "BURNT_eater", "cooker", "_inventory", "HASHEATER", "smallcreature", "_combat", "locomotor", "scarytoprey", "_follower", "_hunger", "character", "sleeper", "noauradamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavae")	
			inst.AnimState:SetBuild("lavae")	
			Anim路径 :  "anim/lavae.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("follower")	
		inst:AddComponent("heater")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("cooker")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hunger")	
		inst:AddComponent("inventory")	
		inst:AddComponent("health")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
火鸡			预设: perd		路径： [string "scripts/prefabs/perd.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "_health", "inspectable", "freezable", "RAW_eater", "idle", "_inventory", "_combat", "locomotor", "berrythief", "nolight", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("perd")	
			inst.AnimState:SetBuild("perd")	
			Anim路径 :  "anim/perd_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: stalker_shield3		路径： [string "scripts/prefabs/stalker_shield.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker_shield")	
			inst.AnimState:SetBuild("stalker_shield")	
			Anim路径 :  "anim/stalker_shield.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
破烂的马车			预设: quagmire_rubble_carriage		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: rook_nightmare_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
小木牌			预设: minisign_item		路径： [string "scripts/prefabs/minisign.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
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
龙蝇雕塑			预设: chesspiece_dragonfly_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: moonpulse		路径： [string "scripts/prefabs/moonpulse.lua"]	
	Tags▼	
	{":", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
粪肥			预设: poop		路径： [string "scripts/prefabs/poop.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "_stackable", "BURNABLE_fuel", "fertilizer", "canlight", "fertilizerresearchable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("poop")	
			inst.AnimState:SetBuild("poop")	
			Anim路径 :  "anim/poop.zip"	
 	
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
MISSING NAME			预设: battlesong_sanitygain_buff		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
咸的怪物千层饼			预设: monsterlasagna_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
种壳			预设: waterplant_bomb		路径： [string "scripts/prefabs/waterplant_seed.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "noattack", "_stackable", "_combat", "canlight", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle_burr")	
			inst.AnimState:SetBuild("barnacle_burr")	
			Anim路径 :  "anim/barnacle_burr.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("reticule")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
		inst:AddComponent("propagator")	
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
影子分身			预设: shadowdigger		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
	Tags▼	
	{":", "_health", "idle", "NOBLOCK", "_combat", "locomotor", "scarytoprey", "_follower", "shadowminion"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("waxwell_shadow_mod")	
			Anim路径 :  "anim/player_idles.zip"	
 	
	使用的组件▼	
		inst:AddComponent("follower")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
战斗大师普格纳			预设: lavaarena_boarlord		路径： [string "scripts/prefabs/lavaarena_boarlord.lua"]	
	Tags▼	
	{":", "king"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
		
------------------------------------------------	
浮夸狮子鱼			预设: oceanfish_medium_3		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "MEAT_eater", "locomotor", "herd_oceanfish_medium_3", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_3")	
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
MISSING NAME			预设: schoolherd_oceanfish_small_7		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
赃物袋			预设: klaus_sack		路径： [string "scripts/prefabs/klaus_sack.lua"]	
	Tags▼	
	{":", "inspectable", "antlion_sinkhole_blocker", "klaussacklock", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("klaus_bag")	
			inst.AnimState:SetBuild("klaus_bag")	
			Anim路径 :  "anim/klaus_bag.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("klaussacklock")	
		inst:AddComponent("entitytracker")	
		
------------------------------------------------	
MISSING NAME			预设: bee_poof_small		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
月亮精华液			预设: halloweenpotion_moon		路径： [string "scripts/prefabs/halloweenpotion_moon.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_potion_moon")	
			inst.AnimState:SetBuild("halloween_potion_moon")	
			Anim路径 :  "anim/halloween_potion_moon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("halloweenpotionmoon")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("animqueueover")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
星空			预设: hutch_fishbowl		路径： [string "scripts/prefabs/hutch_fishbowl.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hutch_fishbowl", "nonpotatable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("hutch_fishbowl")	
			Anim路径 :  "anim/hutch_fishbowl.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("leader")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
梦魇城墙			预设: nightmaregrowth		路径： [string "scripts/prefabs/nightmaregrowth.lua"]	
	Tags▼	
	{":", "inspectable", "sanityaura", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmaregrowth")	
			inst.AnimState:SetBuild("nightmaregrowth")	
			Anim路径 :  "anim/nightmaregrowth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
大虚影			预设: gestalt_guard		路径： [string "scripts/prefabs/gestalt_guard.lua"]	
	Tags▼	
	{":", "_health", "crazy", "idle", "NOBLOCK", "_combat", "locomotor", "extinguisher", "sanityaura", "soulless", "brightmare", "brightmare_guard"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt_evolved")	
			inst.AnimState:SetBuild("brightmare_gestalt_evolved")	
			Anim路径 :  "anim/brightmare_gestalt_evolved.zip"	
 	
	使用的组件▼	
		inst:AddComponent("health")	
		inst:AddComponent("transparentonsanity")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("losttarget")	
		inst:ListenForEvent("droppedtarget")	
		inst:ListenForEvent("killed")	
	SG = 有▼	
------------------------------------------------	
甜恐怖国王饼			预设: nightmarepie_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣酿茄子			预设: stuffedeggplant_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: shadowhand		路径： [string "scripts/prefabs/shadowhand.lua"]	
	Tags▼	
	{":", "shadowhand", "locomotor", "sanityaura", "ignorewalkableplatforms", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_creatures_ground")	
			Anim路径 :  "anim/shadow_creatures_ground.zip"	
 	
	使用的组件▼	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
------------------------------------------------	
耕地机			预设: farm_plow_item		路径： [string "scripts/prefabs/farm_plow.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "canlight", "deployable", "usedeploystring"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plow")	
			inst.AnimState:SetBuild("farm_plow")	
			Anim路径 :  "anim/farm_plow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
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
MISSING NAME			预设: lavalight		路径： [string "scripts/prefabs/lavalight.lua"]	
	Tags▼	
	{":", "HASHEATER", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fire_large_character")	
			inst.AnimState:SetBuild("fire_large_character")	
			Anim路径 :  "anim/fire_large_character.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("firefx")	
		
------------------------------------------------	
喜庆皮弗娄牛玩偶			预设: yotb_beefalo_doll_festive		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
复活的骨架			预设: stalker		路径： [string "scripts/prefabs/stalker.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "idle", "fossil", "hostile", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "largecreature", "stalker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker")	
			inst.AnimState:SetBuild("stalker_shadow_build")	
			Anim路径 :  "anim/stalker_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("talker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("healthtrigger")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("grouptargeter")	
		inst:AddComponent("timer")	
		inst:AddComponent("epicscare")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("ontalk")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("healthdelta")	
		inst:ListenForEvent("donetalking")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: erode_ash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
洞穴			预设: cave_entrance_open		路径： [string "scripts/prefabs/cave_entrance.lua"]	
	Tags▼	
	{":", "inspectable", "CLASSIFIED", "antlion_sinkhole_blocker", "NOCLICK", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cave_entrance")	
			inst.AnimState:SetBuild("cave_entrance")	
			Anim路径 :  "anim/cave_entrance.zip"	
 	
	使用的组件▼	
		inst:AddComponent("childspawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("worldmigrator")	
		
	使用的监听▼	
		inst:ListenForEvent("migration_unavailable")	
		inst:ListenForEvent("migration_available")	
		inst:ListenForEvent("migration_full")	
------------------------------------------------	
糖果虱			预设: halloweencandy_12		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
缺少的牙齿			预设: lost_toy_10		路径： [string "scripts/prefabs/lost_toys.lua"]	
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
甜发光浆果慕斯			预设: glowberrymousse_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
牧羊人派			预设: quagmire_food_041		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
鱼排			预设: quagmire_food_036		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: positronbeam_back		路径： [string "scripts/prefabs/positronbeam.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moonbase_fx")	
			Anim路径 :  "anim/moonbase_fx.zip"	
 	
	使用的组件▼	

------------------------------------------------	
农作物			预设: quagmire_tomato_planted		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "plantedsoil", "fertilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ice_splash		路径： [string "scripts/prefabs/ice_splash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ice_splash")	
			inst.AnimState:SetBuild("ice_splash")	
			Anim路径 :  "anim/ice_splash.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
玉米泥			预设: carnivalfood_corntea		路径： [string "scripts/prefabs/carnival_food.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_food")	
			inst.AnimState:SetBuild("carnival_food")	
			Anim路径 :  "anim/carnival_food.zip"	
 	
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
噩梦燃料			预设: nightmarefuel		路径： [string "scripts/prefabs/nightmarefuel.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "NIGHTMARE_fuel", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmarefuel")	
			inst.AnimState:SetBuild("nightmarefuel")	
			Anim路径 :  "anim/nightmarefuel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("fuel")	
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
古怪工具			预设: wagstaff_tool_2		路径： [string "scripts/prefabs/wagstaff_tools.lua"]	
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
树木园实验			预设: halloween_experiment_root		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜失败料理			预设: wetgoop_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
可疑的月岩			预设: gargoyle_werepigdeath		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "gargoyle", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")	
			Anim路径 :  "anim/sculpture_werepig.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
------------------------------------------------	
大熔炉猪战士			预设: lavaarena_groundliftembers		路径： [string "scripts/prefabs/lavaarena_groundlifts.lua"]	
	Tags▼	
	{":", "groundspike", "object", "hostile", "notarget", "stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
皮弗娄牛雕塑			预设: chesspiece_beefalo		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_beefalo_marble")	
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
松果			预设: pinecone		路径： [string "scripts/prefabs/pinecone.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight", "deployable", "treeseed"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pinecone")	
			inst.AnimState:SetBuild("pinecone")	
			Anim路径 :  "anim/pinecone.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("winter_treeseed")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("deployable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("forcecompostable")	
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
MISSING NAME			预设: waveyjones_arm		路径： [string "scripts/prefabs/waveyjones.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onscared")	
------------------------------------------------	
MISSING NAME			预设: carnival_sparkle_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_bearger		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
火荨麻叶			预设: firenettles		路径： [string "scripts/prefabs/firenettles.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "BURNABLE_fuel", "badfood", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firenettles")	
			inst.AnimState:SetBuild("firenettles")	
			Anim路径 :  "anim/firenettles.zip"	
 	
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
鹅羽浮标			预设: oceanfishingbobber_goose		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_goose_build")	
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
MISSING NAME			预设: year_of_the_pig_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的爆炒填馅辣椒			预设: pepperpopper_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
甜舒缓茶			预设: sweettea_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: crabking_chip_low		路径： [string "scripts/prefabs/crabking.lua"]	
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
MISSING NAME			预设: lavaarena_bloom2		路径： [string "scripts/prefabs/lavaarena_blooms.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_bloom"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")	
			Anim路径 :  "anim/lavaarena_heal_flowers_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: archive_lockbox_dispencer_temp		路径： [string "scripts/prefabs/archive_lockbox.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
损坏的发条主教			预设: bishop_nightmare		路径： [string "scripts/prefabs/bishop.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "freezable", "idle", "chess", "_inventory", "hostile", "bishop", "_combat", "locomotor", "nolight", "_follower", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bishop")	
			inst.AnimState:SetBuild("bishop_nightmare")	
			Anim路径 :  "anim/bishop.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("freezable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("follower")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
                  Event data unavailable: quagmire_event_server/prefabs/campfire
------------------------------------------------	
营火			预设: quagmire_campfire		路径： [string "scripts/prefabs/campfire.lua"]	
	Tags▼	
	{":", "BURNABLE_fueled", "campfire", "inspectable", "NPC_workable", "cooker", "nolight", "storytellingprop", "fire", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("campfire")	
			inst.AnimState:SetBuild("campfire")	
			Anim路径 :  "anim/campfire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("storytellingprop")	
		inst:AddComponent("burnable")	
		inst:AddComponent("cooker")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: chum_aoe		路径： [string "scripts/prefabs/chum_aoe.lua"]	
	Tags▼	
	{":", "fx", "chum", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fish_chum")	
			inst.AnimState:SetBuild("fish_chum")	
			Anim路径 :  "anim/fish_chum.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: blossom_cast_fx		路径： [string "scripts/prefabs/healingstaff.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
少许刚毅勇气			预设: halloweenpotion_sanity_small		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
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
格罗姆花			预设: glommerflower		路径： [string "scripts/prefabs/glommerflower.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "glommerflower", "nonpotatable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("glommer_flower")	
			inst.AnimState:SetBuild("glommer_flower")	
			Anim路径 :  "anim/glommer_flower.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("leader")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香发光浆果慕斯			预设: glowberrymousse_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
影子分身			预设: shadowduelist		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
	Tags▼	
	{":", "_health", "idle", "NOBLOCK", "_combat", "locomotor", "scarytoprey", "_follower", "shadowminion"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("waxwell_shadow_mod")	
			Anim路径 :  "anim/player_idles.zip"	
 	
	使用的组件▼	
		inst:AddComponent("follower")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
月亮虹吸器			预设: moon_device_top		路径： [string "scripts/prefabs/moon_device.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moon_device")	
			Anim路径 :  "anim/moon_device.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
飞翼风帆			预设: mast_malbatross		路径： [string "scripts/prefabs/mast.lua"]	
	Tags▼	
	{":", "inspectable", "mast_upgradeable", "HAMMER_workable", "NOBLOCK", "burnableignorefuel", "canlight", "structure", "sailraised", "blocker", "mast"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mast_malbatross")	
			inst.AnimState:SetBuild("boat_mast_malbatross_build")	
			Anim路径 :  "anim/boat_mast_malbatross_wip.zip"	
 	
	使用的组件▼	
		inst:AddComponent("mast")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("upgradeable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("ondeconstructstructure")	
------------------------------------------------	
时间裂缝			预设: pocketwatch_portal_entrance		路径： [string "scripts/prefabs/pocketwatch_portal.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "scarytoprey", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_portal_fx")	
			inst.AnimState:SetBuild("pocketwatch_portal_fx")	
			Anim路径 :  "anim/pocketwatch_portal_fx.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("teleporter")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
种下的种子荚			预设: farm_plant_garlic		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "farm_plant_garlic", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_garlic")	
			inst.AnimState:SetBuild("farm_plant_garlic")	
			Anim路径 :  "anim/farm_plant_garlic.zip"	
 	
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
MISSING NAME			预设: beargerwarning_lvl3		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: slingshotammo_hitfx_gold		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
独眼巨鹿			预设: alterguardian_laserempty		路径： [string "scripts/prefabs/alterguardian_laser.lua"]	
	Tags▼	
	{":", "hostile", "_combat", "notarget"}	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
------------------------------------------------	
MISSING NAME			预设: ruins_statue_head_nogem_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
MISSING NAME			预设: gridplacer_farmablesoil		路径： [string "scripts/prefabs/gridplacer.lua"]	
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
残破的屋顶			预设: quagmire_rubble_roof		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: mushgnome_spawner		路径： [string "scripts/prefabs/mushgnome_spawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
喜庆款式碎片			预设: yotb_pattern_fragment_3		路径： [string "scripts/prefabs/yotb_pattern_fragments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "yotb_pattern_fragment", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_pattern_fragment_3")	
			Anim路径 :  "anim/yotb_pattern_fragment_3.zip"	
 	
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
座狼雕塑			预设: chesspiece_claywarg_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型西瓜			预设: watermelon_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_watermelon_build")	
			Anim路径 :  "anim/farm_plant_tomato.zip"	
 	
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
黑鲶鱼			预设: oceanfish_medium_4		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "OMNI_eater", "herd_oceanfish_medium_4", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_4")	
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
MISSING NAME			预设: chessjunk_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
漂浮灯笼			预设: miniboatlantern		路径： [string "scripts/prefabs/miniboatlantern.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "FROMNUM", "idle", "locomotor", "BURNABLE_fuel", "burnableignorefuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_lantern_boat")	
			Anim路径 :  "anim/yotc_lantern_boat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: none_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的龙虾正餐			预设: lobsterdinner_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
忠诚鱼人守卫			预设: mermguard		路径： [string "scripts/prefabs/merm.lua"]	
	Tags▼	
	{":", "merm", "trader", "_health", "inspectable", "freezable", "wet", "idle", "_inventory", "_combat", "locomotor", "nolight", "_follower", "guard", "mermguard", "character", "sleeper", "VEGETARIAN_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("merm_guard_build")	
			Anim路径 :  "anim/ds_pig_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("mermcandidate")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("talker")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("inventory")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("trader")	
		inst:AddComponent("timer")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("suggest_tree_target")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onmermkingdestroyed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onmermkingcreated")	
		inst:ListenForEvent("newcombattarget")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: compostingbin_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("compostingbin")	
			inst.AnimState:SetBuild("compostingbin")	
			Anim路径 :  "anim/compostingbin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
遗物			预设: ruins_chair		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "_combat", "smashable", "stone", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_chair")	
			inst.AnimState:SetBuild("ruins_chair")	
			Anim路径 :  "anim/ruins_chair.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
远古哨所			预设: archive_security_desk		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":", "inspectable", "dustable", "statue", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_security_desk")	
			inst.AnimState:SetBuild("archive_security_desk")	
			Anim路径 :  "anim/archive_security_desk.zip"	
 	
	使用的组件▼	
		inst:AddComponent("playerprox")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("updatelooper")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
植株			预设: weed_forgetmelots		路径： [string "scripts/prefabs/weed_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant_killjoy", "farm_plant", "weed_forgetmelots", "plantresearchable", "plant", "DIG_workable", "canlight", "weed", "tendable_farmplant", "weedplantstress"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("weed_forgetmelots")	
			inst.AnimState:SetBuild("weed_forgetmelots")	
			Anim路径 :  "anim/weed_forgetmelots.zip"	
 	
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
羽毛笔			预设: featherpencil		路径： [string "scripts/prefabs/featherpencil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("feather_pencil")	
			inst.AnimState:SetBuild("feather_pencil")	
			Anim路径 :  "anim/feather_pencil.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("drawingtool")	
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
MISSING NAME			预设: oceanhorror_ripples		路径： [string "scripts/prefabs/oceanshadowcreature.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanhorror")	
			inst.AnimState:SetBuild("shadow_oceanhorror")	
			Anim路径 :  "anim/shadow_oceanhorror.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sparks		路径： [string "scripts/prefabs/sparks.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: mole_move_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香生鲜萨尔萨酱			预设: salsa_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
致敬烤肉			预设: yotp_food1		路径： [string "scripts/prefabs/yotp_food.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotp_food")	
			inst.AnimState:SetBuild("yotp_food")	
			Anim路径 :  "anim/yotp_food.zip"	
 	
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
MISSING NAME			预设: oceantree_leaf_fx_fall		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
迷你摆锤套装			预设: carnivaldecor_eggride3_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride3")	
			inst.AnimState:SetBuild("carnivaldecor_eggride3")	
			Anim路径 :  "anim/carnivaldecor_eggride3.zip"	
 	
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
陶轮			预设: sculptingtable		路径： [string "scripts/prefabs/sculptingtable.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "alltrader", "HAMMER_workable", "canlight", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sculpting_station")	
			inst.AnimState:SetBuild("sculpting_station")	
			Anim路径 :  "anim/sculpting_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("craftingstation")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("shadowchessroar")	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
蕃茄汤			预设: quagmire_food_026		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
菌类地皮			预设: turf_fungus_green		路径： [string "scripts/prefabs/turfs.lua"]	
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
鸟粪			预设: guano		路径： [string "scripts/prefabs/guano.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "_stackable", "BURNABLE_fuel", "fertilizer", "canlight", "fertilizerresearchable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("guano")	
			inst.AnimState:SetBuild("guano")	
			Anim路径 :  "anim/guano.zip"	
 	
	使用的组件▼	
		inst:AddComponent("smotherer")	
		inst:AddComponent("fuel")	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("savedscale")	
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
蒜香海鲜浓汤			预设: seafoodgumbo_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
残破的房子			预设: quagmire_rubble_house		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: houndwarning_lvl3		路径： [string "scripts/prefabs/houndwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的培根煎蛋			预设: baconeggs_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蔚蓝羽毛			预设: feather_robin_winter		路径： [string "scripts/prefabs/feathers.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("feather_robin_winter")	
			inst.AnimState:SetBuild("feather_robin_winter")	
			Anim路径 :  "anim/feather_robin_winter.zip"	
 	
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
主教雕塑			预设: chesspiece_bishop		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_bishop_moonglass")	
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
方形种子			预设: watermelon_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
触须棒棒糖			预设: halloweencandy_10		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
咸的肉丸			预设: meatballs_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: ink_puddle_water		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
烤芝士			预设: quagmire_food_048		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: icespike_fx_4		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pillar_atrium		路径： [string "scripts/prefabs/atrium_pillar.lua"]	
	Tags▼	
	{":", "groundhole", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_atrium")	
			inst.AnimState:SetBuild("pillar_atrium")	
			Anim路径 :  "anim/pillar_atrium.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("atriumpowered")	
------------------------------------------------	
MISSING NAME			预设: wormlight_light		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("spell")	
		
------------------------------------------------	
辣无花果烤串			预设: figkabab_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: wave_shimmer_flood		路径： [string "scripts/prefabs/wave_shimmer.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED", "NOBLOCK", "ignorewalkableplatforms", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wave_shimmer_flood")	
			inst.AnimState:SetBuild("wave_shimmer_flood")	
			Anim路径 :  "anim/wave_shimmer_flood.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: reticuleline		路径： [string "scripts/prefabs/reticuleline.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleline")	
			inst.AnimState:SetBuild("reticuleline")	
			Anim路径 :  "anim/reticuleline.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lighterfire_haunteddoll		路径： [string "scripts/prefabs/lighterfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_small_9		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: moondial_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moondial")	
			inst.AnimState:SetBuild("moondial_build")	
			Anim路径 :  "anim/moondial.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
火			预设: houndfire		路径： [string "scripts/prefabs/hound.lua"]	
	Tags▼	
	{":", "nolight", "fire"}	
 	
	使用的组件▼	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
甜怪物鞑靼			预设: monstertartare_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
远古哨兵蜈蚣			预设: archive_centipede		路径： [string "scripts/prefabs/archive_centipede.lua"]	
	Tags▼	
	{":", "mech", "monster", "_health", "inspectable", "freezable", "idle", "hostile", "_combat", "locomotor", "archive_centipede", "nolight", "_follower", "soulless", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_centipede")	
			inst.AnimState:SetBuild("archive_centipede_build")	
			Anim路径 :  "anim/archive_centipede.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("follower")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: moonstorm_glass_ground_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
岩浆虫			预设: lavae		路径： [string "scripts/prefabs/lavae.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "FROMNUM", "freezable", "idle", "hostile", "_combat", "lavae", "locomotor"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavae")	
			inst.AnimState:SetBuild("lavae")	
			Anim路径 :  "anim/lavae.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("freezable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: carnivalcannon_streamer_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon_streamer")	
			Anim路径 :  "anim/carnival_cannon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
树苗			预设: dug_sapling		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "halloweenmoonmutable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sapling")	
			inst.AnimState:SetBuild("sapling")	
			Anim路径 :  "anim/sapling.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("halloweenmoonmutable")	
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
MISSING NAME			预设: tree_petal_fx_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: slingshotammo_hitfx_trinket_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: archive_switch_pad		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_switch_ground_small")	
			inst.AnimState:SetBuild("archive_switch_ground_small")	
			Anim路径 :  "anim/archive_switch_ground_small.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: hammer_mjolnir_cracklehit		路径： [string "scripts/prefabs/hammer_mjolnir.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_hammer_attack_fx")	
			inst.AnimState:SetBuild("lavaarena_hammer_attack_fx")	
			Anim路径 :  "anim/lavaarena_hammer_attack_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: nightsword_curve_fx		路径： [string "scripts/prefabs/nightsword_curve_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: alterguardian_spike_breakfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
香蕉冻			预设: bananapop		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣无花果意面			预设: figatoni_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
眼球伞			预设: eyebrellahat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "umbrella", "inspectable", "hat", "open_top_hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyebrellahat")	
			inst.AnimState:SetBuild("hat_eyebrella")	
			Anim路径 :  "anim/hat_eyebrella.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("fueled")	
		
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
MISSING NAME			预设: redpouch_yotc_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
海鹦鹉			预设: puffin		路径： [string "scripts/prefabs/birds.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "_health", "inspectable", "SEEDS_eater", "freezable", "stunnedbybomb", "idle", "small_livestock", "smallcreature", "puffin", "_combat", "locomotor", "nolight", "show_spoilage", "cookable", "flight", "likewateroffducksback", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("puffin")	
			inst.AnimState:SetBuild("puffin_build")	
			Anim路径 :  "anim/puffin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("occupier")	
		inst:AddComponent("propagator")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("cookable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("health")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("floater_startfloating")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("floater_stopfloating")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: mast_malbatross_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mast_malbatross")	
			inst.AnimState:SetBuild("boat_mast_malbatross_build")	
			Anim路径 :  "anim/boat_mast_malbatross_wip.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: oceanfishingbobber_plug_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_plug_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
弯曲的叉子			预设: trinket_17		路径： [string "scripts/prefabs/trinkets.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "oceanfishing_lure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("oceanfishingtackle")	
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
月岩墙			预设: wall_moonrock_item		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "wallbuilder", "deployable", "repairer", "health_moonrock"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_moonrock")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("repairer")	
		inst:AddComponent("stackable")	
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
Matic 朋友之门			预设: migration_portal		路径： [string "scripts/prefabs/migration_portal.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portal_friends")	
			inst.AnimState:SetBuild("portal_friends")	
			Anim路径 :  "anim/portal_friends.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldmigrator")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("migration_unavailable")	
		inst:ListenForEvent("migration_full")	
		inst:ListenForEvent("migration_available")	
		inst:ListenForEvent("migration_activate")	
------------------------------------------------	
迷你摆锤			预设: carnivaldecor_eggride3		路径： [string "scripts/prefabs/carnivaldecor_eggride.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "carnivaldecor", "HAMMER_workable", "quickactivation", "canlight", "structure", "inactive", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride3")	
			inst.AnimState:SetBuild("carnivaldecor_eggride3")	
			Anim路径 :  "anim/carnivaldecor_eggride3.zip"	
 	
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
灌木丛帽			预设: bushhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "hide", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bushhat")	
			inst.AnimState:SetBuild("hat_bush")	
			Anim路径 :  "anim/hat_bush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("useableitem")	
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
玄武岩			预设: basalt		路径： [string "scripts/prefabs/basalt.lua"]	
	Tags▼	
	{":", "inspectable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blocker")	
			inst.AnimState:SetBuild("blocker")	
			Anim路径 :  "anim/blocker.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
干瘪的触手			预设: trinket_12		路径： [string "scripts/prefabs/trinkets.lua"]	
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
红薯焗饭			预设: sweetpotato		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
花朵金枪鱼			预设: oceanfish_small_7		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_veggie", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_small_7", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming", "VEGETARIAN_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_7")	
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
哈奇			预设: hutch		路径： [string "scripts/prefabs/hutch.lua"]	
	Tags▼	
	{":", "notraptrigger", "hutch", "_health", "inspectable", "companion", "_container", "idle", "_combat", "locomotor", "scarytoprey", "nolight", "_follower", "character", "sleeper", "noauradamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hutch")	
			inst.AnimState:SetBuild("hutch_build")	
			Anim路径 :  "anim/hutch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("maprevealable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("amorphous")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("follower")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onclose")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("itemlose")	
	SG = 有▼	
------------------------------------------------	
蒜香波兰水饺			预设: perogies_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: damagenumber		路径： [string "scripts/prefabs/damagenumber.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜蘑菇蛋糕			预设: shroomcake_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
红色月眼			预设: redmooneye		路径： [string "scripts/prefabs/mooneye.lua"]	
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
MISSING NAME			预设: houndwarning_lvl2		路径： [string "scripts/prefabs/houndwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
炉火晶石			预设: lavaarena_firebomb		路径： [string "scripts/prefabs/lavaarena_firebomb.lua"]	
	Tags▼	
	{":", "rechargeable", "throw_line", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_firebomb")	
			inst.AnimState:SetBuild("lavaarena_firebomb")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
------------------------------------------------	
后扣帽犀牛兄弟			预设: rhinodrill		路径： [string "scripts/prefabs/lavaarena_rhinodrill.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rhinodrill")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
大蒜			预设: quagmire_garlic		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蝙蝠棒			预设: batbat		路径： [string "scripts/prefabs/batbat.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "dull", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("batbat")	
			inst.AnimState:SetBuild("batbat")	
			Anim路径 :  "anim/batbat.zip"	
 	
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
MISSING NAME			预设: moonpulse_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣发光浆果慕斯			预设: glowberrymousse_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
注能月亮碎片			预设: moonglass_charged		路径： [string "scripts/prefabs/moonglass.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "moonglass_piece", "FROMNUM", "_stackable", "show_spoilage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_charged")	
			inst.AnimState:SetBuild("moonglass_charged")	
			Anim路径 :  "anim/moonglass_charged.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
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
------------------------------------------------	
MISSING NAME			预设: oceanfishingbobber_twig_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_twig_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
MISSING NAME			预设: reticuleaoe		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: abigailforcefield		路径： [string "scripts/prefabs/abigailforcefield.lua"]	
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
远古石刻			预设: turf_archive		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf_archives")	
			inst.AnimState:SetBuild("turf_archives")	
			Anim路径 :  "anim/turf_archives.zip"	
 	
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
甜无花果蛙腿三明治			预设: frognewton_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: beargerwarning_lvl2		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: moonpulse2_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: crab_king_icefx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: icebox_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("icebox")	
			inst.AnimState:SetBuild("ice_box")	
			Anim路径 :  "anim/ice_box.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
挂锅装置			预设: quagmire_pot_hanger		路径： [string "scripts/prefabs/quagmire_pot_hanger.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_pot_hanger")	
			inst.AnimState:SetBuild("quagmire_pot_hanger")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
普切塔			预设: quagmire_food_031		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
铥矿墙			预设: brokenwall_ruins		路径： [string "scripts/prefabs/brokenwalls.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "HAMMER_workable", "ruins", "stone", "wall", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: waterpump_placer		路径： [string "scripts/prefabutil.lua"]	
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
硬物浮标			预设: oceanfishingbobber_oval_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_sporty_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
红色蘑菇帽			预设: red_mushroomhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("red_mushroomhat")	
			inst.AnimState:SetBuild("hat_red_mushroom")	
			Anim路径 :  "anim/hat_red_mushroom.zip"	
 	
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
MISSING NAME			预设: lavaarena_bloom6		路径： [string "scripts/prefabs/lavaarena_blooms.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_bloom"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")	
			Anim路径 :  "anim/lavaarena_heal_flowers_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_krampus		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
皮弗娄牛舞台			预设: yotb_post_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotb_post_item")	
			inst.AnimState:SetBuild("yotb_post_item")	
			Anim路径 :  "anim/yotb_post_item.zip"	
 	
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
针线包			预设: sewing_kit		路径： [string "scripts/prefabs/sewingkit.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sewing_kit")	
			inst.AnimState:SetBuild("sewing_kit")	
			Anim路径 :  "anim/sewing_kit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("sewing")	
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
无花果蛙腿三明治			预设: frognewton		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
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
MISSING NAME			预设: lantern_winter_fx_ground		路径： [string "scripts/prefabs/lantern_winter_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lantern")	
			Anim路径 :  "anim/dynamic/lantern_winter.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
怪物肉			预设: monstermeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "selfstacker", "edible_MONSTER", "dryable", "_stackable", "monstermeat", "badfood", "cookable", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("monstermeat")	
			inst.AnimState:SetBuild("meat_monster")	
			Anim路径 :  "anim/meat_monster.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("selfstacker")	
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
咸的失败料理			预设: wetgoop_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
应用造林学			预设: book_silviculture		路径： [string "scripts/prefabs/books.lua"]	
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
MISSING NAME			预设: schoolherd_oceanfish_small_8		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: gestalt_head		路径： [string "scripts/prefabs/gestalt_head.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt_head")	
			inst.AnimState:SetBuild("brightmare_gestalt_head")	
			Anim路径 :  "anim/brightmare_gestalt_head.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
吹箭			预设: blowdart_pipe		路径： [string "scripts/prefabs/blowdart.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "blowdart", "_stackable", "sharp", "_equippable", "weapon"}	
 	
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
充能玻璃石			预设: moonstorm_glass_nub		路径： [string "scripts/prefabs/moonstorm_glass.lua"]	
	Tags▼	
	{":", "inspectable", "moonglass", "MINE_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_charged")	
			inst.AnimState:SetBuild("moonglass_charged_tile")	
			Anim路径 :  "anim/moonglass_charged_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
------------------------------------------------	
萨米的货车			预设: quagmire_merm_cart1		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: wall_stone_2_item		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "wallbuilder", "deployable", "repairer", "health_stone_2"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_stone_2")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("repairer")	
		inst:AddComponent("stackable")	
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
辣果冻沙拉			预设: leafymeatsouffle_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
皮弗娄牛美妆台			预设: beefalo_groomer		路径： [string "scripts/prefabs/beefalo_groomer.lua"]	
	Tags▼	
	{":", "hitcher", "inspectable", "HAMMER_workable", "beefalo_groomer", "canlight", "structure", "dressable", "groomer", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo_wardrobe")	
			inst.AnimState:SetBuild("beefalo_wardrobe")	
			Anim路径 :  "anim/beefalo_wardrobe.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("groomer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hitcher")	
		inst:AddComponent("propagator")	
		inst:AddComponent("skinner")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
薇诺娜的宝石发电机			预设: winona_battery_high		路径： [string "scripts/prefabs/winona_battery_high.lua"]	
	Tags▼	
	{":", "gemsocket", "trader", "inspectable", "fueldepleted", "engineeringbattery", "HAMMER_workable", "burnableignorefuel", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_battery_high")	
			inst.AnimState:SetBuild("winona_battery_high")	
			Anim路径 :  "anim/winona_battery_high.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("workable")	
		inst:AddComponent("updatelooper")	
		inst:AddComponent("fueled")	
		inst:AddComponent("deployhelper")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("circuitnode")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("engineeringcircuitchanged")	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: icebox_coffin_bat_fx		路径： [string "scripts/prefabs/icebox_coffin_bat_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
堆肥桶			预设: compostingbin		路径： [string "scripts/prefabs/compostingbin.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "compostingbin_accepts_items", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("compostingbin")	
			inst.AnimState:SetBuild("compostingbin")	
			Anim路径 :  "anim/compostingbin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("compostingbin")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("pickable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("animqueueover")	
		inst:ListenForEvent("onburnt")	
------------------------------------------------	
多愁善感的卡祖笛			预设: lost_toy_2		路径： [string "scripts/prefabs/lost_toys.lua"]	
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
遮阳篷			预设: siestahut		路径： [string "scripts/prefabs/tent.lua"]	
	Tags▼	
	{":", "inspectable", "tent", "HAMMER_workable", "canlight", "siestahut", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("siesta_canopy")	
			inst.AnimState:SetBuild("siesta_canopy")	
			Anim路径 :  "anim/siesta_canopy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sleepingbag")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
甜鳗鱼料理			预设: unagi_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: wall_wood_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_wood")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
咸的海鲜杂烩			预设: moqueca_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
甜冰淇淋			预设: icecream_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
火魔杖			预设: firestaff		路径： [string "scripts/prefabs/staff.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "rangedlighter", "rangedweapon", "_equippable", "firestaff", "weapon"}	
 	
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
干草叉			预设: pitchfork		路径： [string "scripts/prefabs/pitchfork.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pitchfork")	
			inst.AnimState:SetBuild("pitchfork")	
			Anim路径 :  "anim/pitchfork.zip"	
 	
	使用的组件▼	
		inst:AddComponent("terraformer")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
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
咸的芦笋汤			预设: asparagussoup_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: yotc_seedpacket_rare_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_plain7		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
多层小蛋糕			预设: quagmire_food_068		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
小饵鱼			预设: oceanfish_small_3		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "MEAT_eater", "locomotor", "herd_oceanfish_small_3", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_3")	
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
黄金园艺锄			预设: golden_farm_hoe		路径： [string "scripts/prefabs/farm_hoe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goldenhoe")	
			inst.AnimState:SetBuild("goldenhoe")	
			Anim路径 :  "anim/goldenhoe.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("farmtiller")	
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
木板			预设: boards		路径： [string "scripts/prefabs/boards.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "health_wood", "BURNABLE_fuel", "canlight", "repairer", "edible_WOOD"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boards")	
			inst.AnimState:SetBuild("boards")	
			Anim路径 :  "anim/boards.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
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
种下的方形种子			预设: farm_plant_watermelon		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "farm_plant_watermelon", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_watermelon_build")	
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
MISSING NAME			预设: beargerwarning_lvl4		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
野猪猩			预设: trails		路径： [string "scripts/prefabs/lavaarena_trails.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trails")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
西瓜冰棍			预设: watermelonicle		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: fissure_lower		路径： [string "scripts/prefabs/nightmarefissure.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmare_crack_ruins")	
			inst.AnimState:SetBuild("nightmare_crack_ruins")	
			Anim路径 :  "anim/nightmare_crack_ruins.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
松树先锋队帽子			预设: walterhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("walterhat")	
			inst.AnimState:SetBuild("hat_walter")	
			Anim路径 :  "anim/hat_walter.zip"	
 	
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
MISSING NAME			预设: messagebottletreasure_marker		路径： [string "scripts/prefabs/messagebottletreasure_marke..."]	
	Tags▼	
	{":", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")		
------------------------------------------------	
MISSING NAME			预设: weremoose_transform2_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
草			预设: depleted_grass		路径： [string "scripts/prefabs/grass.lua"]	
	Tags▼	
	{":", "inspectable", "barren", "renewable", "plant", "DIG_workable", "canlight", "witherable", "silviculture"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grass")	
			inst.AnimState:SetBuild("grass1")	
			Anim路径 :  "anim/grass.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("witherable")	
		
------------------------------------------------	
国王雕塑			预设: chesspiece_formal		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_formal_moonglass")	
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
韦德			预设: pigelitefighter1		路径： [string "scripts/prefabs/pigelitefighter.lua"]	
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
独奏乐器			预设: onemanband		路径： [string "scripts/prefabs/onemanband.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "band"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("onemanband")	
			inst.AnimState:SetBuild("armor_onemanband")	
			Anim路径 :  "anim/armor_onemanband.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("equippable")	
		inst:AddComponent("leader")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: reticulelongping		路径： [string "scripts/prefabs/reticulelong.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticulelong")	
			inst.AnimState:SetBuild("reticulelong")	
			Anim路径 :  "anim/reticulelong.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜芦笋冷汤			预设: gazpacho_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
                  Event data unavailable: quagmire_event_server/prefabs/quagmire_book_shadow
------------------------------------------------	
暗影秘典			预设: quagmire_book_shadow		路径： [string "scripts/prefabs/quagmire_book_shadow.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("book_maxwell")	
			inst.AnimState:SetBuild("book_maxwell")	
			Anim路径 :  "anim/book_maxwell.zip"	
 	
	使用的组件▼	
------------------------------------------------	
伏特羊肉冻			预设: voltgoatjelly		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "canlight", "preparedfood", "edible_GOODIES", "fresh"}	
 	
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
蒜香蔬菜杂烩			预设: ratatouille_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
催眠吹箭			预设: blowdart_sleep		路径： [string "scripts/prefabs/blowdart.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "blowdart", "tranquilizer", "_stackable", "sharp", "_equippable", "weapon"}	
 	
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
蜜汁卤肉			预设: honeynuggets		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
团队首领			预设: teamleader		路径： [string "scripts/prefabs/teamleader.lua"]	
	Tags▼	
	{":", "teamleader_monster", "teamleader"}	
 	
	使用的组件▼	
		inst:AddComponent("teamleader")	
		
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_shield_dripfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
鱼肉汉堡			预设: quagmire_food_034		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cavein_dust_high		路径： [string "scripts/prefabs/cavein_boulder.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavein_dust_fx")	
			inst.AnimState:SetBuild("cavein_dust_fx")	
			Anim路径 :  "anim/cavein_dust_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: splash_snow_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnival_unwrap_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
无敌硬糖			预设: halloweencandy_13		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
闪亮鞍具			预设: saddle_race		路径： [string "scripts/prefabs/saddle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("saddle_race")	
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
黄羽浮标			预设: oceanfishingbobber_canary		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_canary_build")	
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
鳞甲			预设: armordragonfly		路径： [string "scripts/prefabs/armor_dragonfly.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("torso_dragonfly")	
			inst.AnimState:SetBuild("torso_dragonfly")	
			Anim路径 :  "anim/torso_dragonfly.zip"	
 	
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
龙虾			预设: wobster_sheller_land		路径： [string "scripts/prefabs/wobster.lua"]	
	Tags▼	
	{":", "_inventoryitem", "murderable", "weighable_fish", "_health", "inspectable", "freezable", "stunnedbybomb", "idle", "whackable", "smallcreature", "_combat", "canbetrapped", "locomotor", "prey", "nolight", "show_spoilage", "smalloceancreature", "cookable", "animal", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_sheller")	
			Anim路径 :  "anim/lobster.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("tradable")	
		inst:AddComponent("murderable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("weighable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
友好果蝇果			预设: fruitflyfruit		路径： [string "scripts/prefabs/fruitfly.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "nonpotatable", "fruitflyfruit", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fruitflyfruit")	
			inst.AnimState:SetBuild("fruitflyfruit")	
			Anim路径 :  "anim/fruitflyfruit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("leader")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
麋鹿鹅幼崽			预设: mossling		路径： [string "scripts/prefabs/mossling.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "_inventory", "_combat", "locomotor", "nolight", "mossling", "MOOSE_eater", "herdmember", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mossling")	
			inst.AnimState:SetBuild("mossling_build")	
			Anim路径 :  "anim/mossling_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("sizetweener")	
		inst:AddComponent("propagator")	
		inst:AddComponent("eater")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
咸的无花果烤串			预设: figkabab_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
玻璃尖刺			预设: glassspike_med		路径： [string "scripts/prefabs/glass_spike.lua"]	
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
MISSING NAME			预设: monkeyprojectile		路径： [string "scripts/prefabs/monkeyprojectile.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("monkey_projectile")	
			inst.AnimState:SetBuild("monkey_projectile")	
			Anim路径 :  "anim/monkey_projectile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		
------------------------------------------------	
MISSING NAME			预设: yellowamuletlight		路径： [string "scripts/prefabs/amulet.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
营火			预设: campfire		路径： [string "scripts/prefabs/campfire.lua"]	
	Tags▼	
	{":", "BURNABLE_fueled", "campfire", "inspectable", "NPC_workable", "cooker", "nolight", "storytellingprop", "fire", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("campfire")	
			inst.AnimState:SetBuild("campfire")	
			Anim路径 :  "anim/campfire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("storytellingprop")	
		inst:AddComponent("burnable")	
		inst:AddComponent("cooker")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("death")	
------------------------------------------------	
冰帽			预设: icehat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "icebox_valid", "HASHEATER", "repairable_ice", "frozen", "waterproofer", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("icehat")	
			inst.AnimState:SetBuild("hat_ice")	
			Anim路径 :  "anim/hat_ice.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("repairable")	
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
MISSING NAME			预设: slingshotammo_hitfx_slow		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
暗影香炉			预设: thurible		路径： [string "scripts/prefabs/thurible.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "NIGHTMARE_fueled", "_equippable", "nopunch", "shadowlure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("thurible")	
			inst.AnimState:SetBuild("thurible")	
			Anim路径 :  "anim/thurible.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
兔屋			预设: rabbithouse		路径： [string "scripts/prefabs/rabbithouse.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rabbithouse")	
			inst.AnimState:SetBuild("rabbit_house")	
			Anim路径 :  "anim/rabbit_house.zip"	
 	
	使用的组件▼	
		inst:AddComponent("spawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("worldsettingstimer")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
MISSING NAME			预设: nightmaregrowth_spawner		路径： [string "scripts/prefabs/nightmaregrowth.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: crabking_chip_high		路径： [string "scripts/prefabs/crabking.lua"]	
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
MISSING NAME			预设: houndwarning_lvl1		路径： [string "scripts/prefabs/houndwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: dug_sapling_moon_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sapling_moon")	
			inst.AnimState:SetBuild("sapling_moon")	
			Anim路径 :  "anim/sapling_moon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: eyeturret_base		路径： [string "scripts/prefabs/eyeturret.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeball_turret_base")	
			inst.AnimState:SetBuild("eyeball_turret_base")	
			Anim路径 :  "anim/eyeball_turret_base.zip"	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: rhinobuff		路径： [string "scripts/prefabs/lavaarena_rhinobuff.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: deerclops_laserscorch		路径： [string "scripts/prefabs/deerclops_laser.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("burntground")	
			inst.AnimState:SetBuild("burntground")	
			Anim路径 :  "anim/burntground.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
恐怖尖喙			预设: terrorbeak		路径： [string "scripts/prefabs/shadowcreature.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "shadow", "hostile", "_combat", "locomotor", "gestaltnoloot", "sanityaura", "shadowcreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_insanity2_basic")	
			Anim路径 :  "anim/shadow_insanity2_basic.zip"	
 	
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
挂锅装置			预设: quagmire_pot_hanger_item		路径： [string "scripts/prefabs/quagmire_pot_hanger.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_pot_hanger")	
			inst.AnimState:SetBuild("quagmire_pot_hanger")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: alterguardian_phase3circle		路径： [string "scripts/prefabs/alterguardian_phase3circle...."]	
	Tags▼	
	{":", "NOCLICK"}	
 	
	使用的组件▼	
------------------------------------------------	
毛茸茸的种子			预设: quagmire_seeds_2		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_crate_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
流星			预设: shadowmeteor		路径： [string "scripts/prefabs/shadowmeteor.lua"]	
	Tags▼	
	{":", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meteor")	
			inst.AnimState:SetBuild("meteor")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
热可可			预设: winter_food8		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "wintersfeastfood", "_stackable", "cattoy", "edible_GOODIES"}	
 	
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
小火鸡			预设: critter_perdling_builder		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣椒面			预设: spice_chili		路径： [string "scripts/prefabs/spices.lua"]	
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
MISSING NAME			预设: wortox_soul_spawn		路径： [string "scripts/prefabs/wortox_soul_spawn.lua"]	
	Tags▼	
	{":", "projectile", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wortox_soul_ball")	
			inst.AnimState:SetBuild("wortox_soul_ball")	
			Anim路径 :  "anim/wortox_soul_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		inst:AddComponent("weapon")	
		
------------------------------------------------	
MISSING NAME			预设: shadow_puff		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
反应健身房			预设: yotc_carrat_gym_reaction		路径： [string "scripts/prefabs/rat_gym.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "_inventory", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_reaction_build")	
			Anim路径 :  "anim/yotc_carrat_gym_reaction.zip"	
 	
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
MISSING NAME			预设: crater_steam_fx2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cavelight_tiny		路径： [string "scripts/prefabs/cavelight.lua"]	
	Tags▼	
	{":", "fx", "sinkhole", "FROMNUM", "daylight", "batdestination", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "anim/cave_exit_lightsource.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hideout")	
		
------------------------------------------------	
辣火鸡大餐			预设: turkeydinner_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
黑色羽毛			预设: feather_crow		路径： [string "scripts/prefabs/feathers.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("feather_crow")	
			inst.AnimState:SetBuild("feather_crow")	
			Anim路径 :  "anim/feather_crow.zip"	
 	
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
烤大萝卜			预设: quagmire_turnip_cooked		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
篮中蛋套装			预设: carnivalgame_memory_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_memory_station")	
			inst.AnimState:SetBuild("carnivalgame_memory_station")	
			Anim路径 :  "anim/carnivalgame_memory_station.zip"	
 	
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
铥矿墙			预设: brokenwall_wood		路径： [string "scripts/prefabs/brokenwalls.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "HAMMER_workable", "wall", "wood", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_wood")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
启迪之冠碎片			预设: alterguardianhatshard		路径： [string "scripts/prefabs/alterguardianhatshard.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_container", "fulllighter", "lightcontainer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardianhatshard")	
			inst.AnimState:SetBuild("alterguardianhatshard")	
			Anim路径 :  "anim/alterguardianhatshard.zip"	
 	
	使用的组件▼	
		inst:AddComponent("preserver")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("container")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
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
蚁狮雕塑			预设: chesspiece_antlion_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: nutrients_overlay_visual		路径： [string "scripts/prefabs/nutrients_overlay.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nutrients_overlay")	
			inst.AnimState:SetBuild("nutrients_overlay")	
			Anim路径 :  "anim/nutrients_overlay.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蒜香华夫饼			预设: waffles_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
发芽的石果			预设: rock_avocado_fruit_sprout		路径： [string "scripts/prefabs/rock_avocado_fruit.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_fruit_build")	
			Anim路径 :  "anim/rock_avocado_fruit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("tradable")	
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
MISSING NAME			预设: reticulelineping		路径： [string "scripts/prefabs/reticuleline.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleline")	
			inst.AnimState:SetBuild("reticuleline")	
			Anim路径 :  "anim/reticuleline.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
肉			预设: meat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "dryable", "_stackable", "badfood", "cookable", "catfood", "lureplant_bait", "fresh"}	
 	
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
白色战车			预设: trinket_28		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: quagmire_portal_activefx		路径： [string "scripts/prefabs/quagmire_portal.lua"]	
	Tags▼	
	{":", "scarytoprey", "birdblocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: warg_gooicing		路径： [string "scripts/prefabs/warg_gooicing.lua"]	
	Tags▼	
	{":", "locomotor"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("warg_gingerbread_bomb")	
			inst.AnimState:SetBuild("warg_gingerbread_bomb")	
			Anim路径 :  "anim/warg_gingerbread_bomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("locomotor")	
------------------------------------------------	
盐晶			预设: quagmire_saltrock		路径： [string "scripts/prefabs/quagmire_salts.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_saltrock")	
			inst.AnimState:SetBuild("quagmire_saltrock")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: oldager_become_younger_back_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
白菜卷			预设: cabbagerolls		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
恐怖猎犬			预设: mutatedhound		路径： [string "scripts/prefabs/hound.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "freezable", "scarytooceanprey", "hostile", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "canbestartled", "sanityaura", "scarytoprey", "nolight", "_follower", "hound_mutated", "sleeper", "hound"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hound")	
			inst.AnimState:SetBuild("hound_mutated")	
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
		inst:AddComponent("propagator")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onattackother")	
	SG = 有▼	
------------------------------------------------	
遗物			预设: ruins_chipbowl		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "clay", "_combat", "smashable", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_chipbowl")	
			inst.AnimState:SetBuild("ruins_chipbowl")	
			Anim路径 :  "anim/ruins_chipbowl.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
美妆台套装			预设: beefalo_groomer_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo_groomer_item")	
			inst.AnimState:SetBuild("beefalo_groomer_item")	
			Anim路径 :  "anim/beefalo_groomer_item.zip"	
 	
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
黄色月眼			预设: yellowmooneye		路径： [string "scripts/prefabs/mooneye.lua"]	
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
MISSING NAME			预设: oceantree_leaf_fx_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
裁判席			预设: yotb_stage		路径： [string "scripts/prefabs/yotb_stage.lua"]	
	Tags▼	
	{":", "inspectable", "yotb_stage", "HAMMER_workable", "structure", "SnowCovered", "appraiser", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_stagebooth")	
			Anim路径 :  "anim/yotb_stagebooth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("deployhelper")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("talker")	
		inst:AddComponent("timer")	
		inst:AddComponent("yotb_stager")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("yotb_advance_queue")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("yotb_contest_abort")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_medium_4		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
糖果玉米			预设: halloweencandy_2		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
指路标志			预设: arrowsign_post		路径： [string "scripts/prefabs/arrowsign.lua"]	
	Tags▼	
	{":", "_writeable", "sign", "inspectable", "writeable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_arrow_post")	
			inst.AnimState:SetBuild("sign_arrow_post")	
			Anim路径 :  "anim/sign_arrow_post.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("writeable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: singingshell_critterfx		路径： [string "scripts/prefabs/singingshell.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("singingshell_creature_basic")	
			Anim路径 :  "anim/singingshell_creature_basic.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: carnivalgame_placementblocker		路径： [string "scripts/prefabs/carnivalgame_placementblock..."]	
	Tags▼	
	{":", "DECOR", "carnivalgame_part", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: moon_geyser_explode		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: round_puff_fx_lg		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鱼肉玉米卷			预设: fishtacos		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
曼德拉草			预设: mandrake_active		路径： [string "scripts/prefabs/mandrake_active.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "idle", "smallcreature", "_combat", "small", "locomotor", "_follower", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mandrake")	
			inst.AnimState:SetBuild("mandrake")	
			Anim路径 :  "anim/mandrake.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("follower")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("startfollowing")	
	SG = 有▼	
------------------------------------------------	
司康餅			预设: quagmire_food_067		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
天体祭坛宝球			预设: moon_altar_seed		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "work_moon_altar", "nonpotatable", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_altar_seedpiece")	
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
MISSING NAME			预设: beebox_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_box")	
			inst.AnimState:SetBuild("bee_box")	
			Anim路径 :  "anim/bee_box.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: weaponsparks_piercing		路径： [string "scripts/prefabs/weaponsparks.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: maxwell_smoke		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
华丽的司夜女神头盔			预设: lavaarena_crowndamagerhat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香素食堡			预设: leafymeatburger_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蕨类植物			预设: quagmire_fern		路径： [string "scripts/prefabs/quagmire_fern.lua"]	
	Tags▼	
	{":", "quagmire_wildplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cave_ferns")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: dr_hot_loop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: saltbox_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("saltbox")	
			inst.AnimState:SetBuild("saltbox")	
			Anim路径 :  "anim/saltbox.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: frostbreath		路径： [string "scripts/prefabs/frostbreath.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_small_5		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_creature_teleport_smoke_fx_3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: moon_altar_link_contained		路径： [string "scripts/prefabs/moon_altar_link.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moon_geyser")	
			Anim路径 :  "anim/moon_geyser.zip"	
 	
	使用的组件▼	
------------------------------------------------	
银碗			预设: quagmire_bowl_silver		路径： [string "scripts/prefabs/quagmire_plates.lua"]	
	Tags▼	
	{":", "quagmire_replater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: moonstormmarker_big		路径： [string "scripts/prefabs/moonstormmarker.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
减速弹药			预设: slingshotammo_slow		路径： [string "scripts/prefabs/slingshotammo.lua"]	
	Tags▼	
	{":", "_inventoryitem", "slingshotammo", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL", "reloaditem_ammo"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshotammo")	
			inst.AnimState:SetBuild("slingshotammo")	
			Anim路径 :  "anim/slingshotammo.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("reloaditem")	
		
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
烤土豆			预设: quagmire_potato_cooked		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
炼金引擎			预设: researchlab2		路径： [string "scripts/prefabs/scienceprototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "level2", "structure", "prototyper", "SnowCovered", "giftmachine", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab2")	
			inst.AnimState:SetBuild("researchlab2")	
			Anim路径 :  "anim/researchlab2.zip"	
 	
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
MISSING NAME			预设: grottopool_sfx		路径： [string "scripts/prefabs/grottopool_sfx.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("fader")	
		
------------------------------------------------	
MISSING NAME			预设: nightsword_sharp_fx		路径： [string "scripts/prefabs/nightsword_sharp_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_medium_3		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_gym_reaction_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_reaction_build")	
			Anim路径 :  "anim/yotc_carrat_gym_reaction.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: explode_small_slurtlehole		路径： [string "scripts/prefabs/explode_small.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: moon_device_construction1_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("moon_device")	
			Anim路径 :  "anim/moon_device.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: round_puff_fx_hi		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cane_ancient_fx1		路径： [string "scripts/prefabs/cane_ancient_fx.lua"]	
	Tags▼	
	{":", "fx", "shadowtrail"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
幸运猫扎尔			预设: trinket_24		路径： [string "scripts/prefabs/trinkets.lua"]	
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
蝎子酸液			预设: peghook_dot		路径： [string "scripts/prefabs/lavaarena_peghook.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
铲子			预设: shovel		路径： [string "scripts/prefabs/shovel.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "tool", "_equippable", "weapon", "DIG_tool"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shovel")	
			inst.AnimState:SetBuild("shovel")	
			Anim路径 :  "anim/shovel.zip"	
 	
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
智囊团			预设: seafaring_prototyper		路径： [string "scripts/prefabs/seafaring_prototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("seafaring_prototyper")	
			Anim路径 :  "anim/seafaring_prototyper.zip"	
 	
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
熔炉装饰			预设: winter_ornament_festivalevents1		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: battlesong_attach		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
桦栗果			预设: acorn		路径： [string "scripts/prefabs/acorn.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "icebox_valid", "_stackable", "cattoy", "canlight", "show_spoilage", "cookable", "deployable", "treeseed", "edible_RAW", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("acorn")	
			inst.AnimState:SetBuild("acorn")	
			Anim路径 :  "anim/acorn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("winter_treeseed")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("forcecompostable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("propagator")	
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
MISSING NAME			预设: fossilspike2		路径： [string "scripts/prefabs/fossil_spike2.lua"]	
	Tags▼	
	{":", "fossilspike", "_combat", "notarget"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fossil_spike2")	
			inst.AnimState:SetBuild("fossil_spike2")	
			Anim路径 :  "anim/fossil_spike2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
------------------------------------------------	
护士蜘蛛			预设: spider_healer		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "halloweenmoonmutable", "show_spoilage", "drop_inventory_onmurder", "sleeper", "eatsrawmeat", "spider", "fresh", "spider_healer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider")	
			inst.AnimState:SetBuild("spider_wolf_build")	
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
MISSING NAME			预设: halloween_moonpuff		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
红袋子			预设: redpouch_yotb		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("redpouch_yotb")	
			inst.AnimState:SetBuild("redpouch_yotb")	
			Anim路径 :  "anim/redpouch_yotb.zip"	
 	
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
天体圣殿卫戍			预设: moon_altar_ward		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "work_moon_altar", "nonpotatable", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_altar_wardpiece")	
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
MISSING NAME			预设: icespike_fx_3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
草壁虎			预设: grassgekko		路径： [string "scripts/prefabs/grassgekko.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "grassgekko", "idle", "smallcreature", "_combat", "locomotor", "nolight", "herdmember", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grassgecko")	
			inst.AnimState:SetBuild("grassgecko")	
			Anim路径 :  "anim/grassgecko.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("herdmember")	
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
		inst:AddComponent("playerprox")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("newcombattarget")	
	SG = 有▼	
------------------------------------------------	
蒜香蓝带鱼排			预设: frogfishbowl_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: fishschoolspawnblocker		路径： [string "scripts/prefabs/fishschoolspawnblocker.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK", "fishschoolspawnblocker"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: wake_small		路径： [string "scripts/prefabs/wake_small.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("water_squid_wake")	
			inst.AnimState:SetBuild("water_squid_wake")	
			Anim路径 :  "anim/water_squid_wake.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")		
------------------------------------------------	
土豆杯			预设: trinket_26		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: burnt_marsh_bush_erode		路径： [string "scripts/prefabs/marsh_bush.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: slow_steam_fx3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: stalker_shield2		路径： [string "scripts/prefabs/stalker_shield.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker_shield")	
			inst.AnimState:SetBuild("stalker_shield")	
			Anim路径 :  "anim/stalker_shield.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: fireball_cast_fx		路径： [string "scripts/prefabs/fireballstaff.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("deer_fire_charge")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香怪物千层饼			预设: monsterlasagna_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: table_winters_feast_placer		路径： [string "scripts/prefabutil.lua"]	
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
蒜香爆炒填馅辣椒			预设: pepperpopper_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的果冻沙拉			预设: leafymeatsouffle_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: madscience_lab_fire		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("madscience_lab")	
			inst.AnimState:SetBuild("madscience_lab")	
			Anim路径 :  "anim/madscience_lab.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: boat_mast_sink_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: nightmarelightfx		路径： [string "scripts/prefabs/nightmarelightfx.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock_light_fx")	
			inst.AnimState:SetBuild("rock_light_fx")	
			Anim路径 :  "anim/rock_light_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蜂王浆			预设: royal_jelly		路径： [string "scripts/prefabs/royal_jelly.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "honeyed", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("royal_jelly")	
			inst.AnimState:SetBuild("royal_jelly")	
			Anim路径 :  "anim/royal_jelly.zip"	
 	
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
MISSING NAME			预设: saltlick_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("salt_lick")	
			inst.AnimState:SetBuild("salt_lick")	
			Anim路径 :  "anim/salt_lick.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
甘露煮鱼			预设: quagmire_food_028		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
黄羽浮标			预设: oceanfishingbobber_canary_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_canary_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
遗物复制品 桌子			预设: ruinsrelic_table		路径： [string "scripts/prefabs/ruinsrelic.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_table")	
			inst.AnimState:SetBuild("ruins_table")	
			Anim路径 :  "anim/ruins_table.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: moon_altar_link_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: waterplant_destroy		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
常青树苗			预设: pinecone_sapling		路径： [string "scripts/prefabs/planted_tree.lua"]	
	Tags▼	
	{":", "evergreen", "inspectable", "plant", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pinecone")	
			inst.AnimState:SetBuild("pinecone")	
			Anim路径 :  "anim/pinecone.zip"	
 	
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
华丽的装饰			预设: winter_ornament_boss_crabking		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
甜炸鱼排			预设: fishsticks_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: slow_steam_fx1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
编织花环			预设: lavaarena_tiaraflowerpetalshat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香鳄梨酱			预设: guacamole_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
应用园艺学，简编			预设: book_horticulture		路径： [string "scripts/prefabs/books.lua"]	
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
薇洛的打火机			预设: lighter		路径： [string "scripts/prefabs/lighter.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "wildfireprotected", "dangerouscooker", "cooker", "nolight", "_equippable", "lighter", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lighter")	
			inst.AnimState:SetBuild("lighter")	
			Anim路径 :  "anim/lighter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("cooker")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("lighter")	
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
粘液蜘蛛			预设: halloweencandy_4		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
MISSING NAME			预设: messagebottle_break_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
耐力健身房套装			预设: yotc_carrat_gym_stamina_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_gym_stamina_item")	
			inst.AnimState:SetBuild("yotc_carrat_gym_stamina_item")	
			Anim路径 :  "anim/yotc_carrat_gym_stamina_item.zip"	
 	
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
一包谢意			预设: hermit_bundle_shells		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hermit_bundle")	
			inst.AnimState:SetBuild("hermit_bundle")	
			Anim路径 :  "anim/hermit_bundle.zip"	
 	
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
烤鱼			预设: fish_cooked		路径： [string "scripts/prefabs/fish.lua"]	
	Tags▼	
	{":", "meat", "pondfish", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "catfood", "fresh"}	
 	
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
辣蔬菜杂烩			预设: ratatouille_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
迷你汉堡			预设: quagmire_food_020		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pillar_cave_rock		路径： [string "scripts/prefabs/pillar.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_cave_rock")	
			inst.AnimState:SetBuild("pillar_cave_rock")	
			Anim路径 :  "anim/pillar_cave_rock.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型腐烂辣椒			预设: pepper_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_pepper")	
			Anim路径 :  "anim/farm_plant_pepper.zip"	
 	
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
公牛海带茎			预设: bullkelp_root		路径： [string "scripts/prefabs/bullkelp_root.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "show_spoilage", "deployable", "_equippable", "whip", "weapon", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bullkelp")	
			inst.AnimState:SetBuild("bullkelp")	
			Anim路径 :  "anim/bullkelp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
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
咸的素食堡			预设: leafymeatburger_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
月眼守卫			预设: sentryward		路径： [string "scripts/prefabs/sentryward.lua"]	
	Tags▼	
	{":", "inspectable", "maprevealer", "HAMMER_workable", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sentryward")	
			inst.AnimState:SetBuild("sentryward")	
			Anim路径 :  "anim/sentryward.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("maprevealer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
时间裂缝			预设: pocketwatch_portal_exit_fx		路径： [string "scripts/prefabs/pocketwatch_portal.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_portal_fx")	
			inst.AnimState:SetBuild("pocketwatch_portal_fx")	
			Anim路径 :  "anim/pocketwatch_portal_fx.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("animqueueover")	
------------------------------------------------	
吸热营火			预设: coldfire		路径： [string "scripts/prefabs/coldfire.lua"]	
	Tags▼	
	{":", "BURNABLE_fueled", "campfire", "blueflame", "inspectable", "NPC_workable", "CHEMICAL_fueled", "nolight", "storytellingprop", "fire", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("coldfire")	
			inst.AnimState:SetBuild("coldfire")	
			Anim路径 :  "anim/coldfire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("storytellingprop")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("death")	
------------------------------------------------	
芝士汉堡			预设: quagmire_food_052		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
颗粒状传输			预设: wagstaff_npc_pstboss		路径： [string "scripts/prefabs/wagstaff_npc.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "idle", "nomagic", "locomotor", "wagstaff_npc"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wagstaff")	
			Anim路径 :  "anim/player_emote_extra.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hudindicatable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("talker")	
		
	使用的监听▼	
		inst:ListenForEvent("doerode")	
		inst:ListenForEvent("ontalk")	
		inst:ListenForEvent("spawndevice")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
好肉汁			预设: wintercooking_gravy		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜海鲜杂烩			预设: moqueca_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: moonrockseed_icon		路径： [string "scripts/prefabs/moonrockseed.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的彩虹糖豆			预设: jellybean_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
圣诞灯			预设: winter_ornament_light4		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: pillar_stalactite		路径： [string "scripts/prefabs/pillar.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_stalactite")	
			inst.AnimState:SetBuild("pillar_stalactite")	
			Anim路径 :  "anim/pillar_stalactite.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mushroom_farm_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_farm")	
			inst.AnimState:SetBuild("mushroom_farm")	
			Anim路径 :  "anim/mushroom_farm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: waveyjones_hand		路径： [string "scripts/prefabs/waveyjones.lua"]	
	Tags▼	
	{":", "idle", "locomotor", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("onscared")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
草墙			预设: wall_hay_item		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "wallbuilder", "health_hay", "BURNABLE_fuel", "canlight", "deployable", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_hay")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("hauntable")	
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
MISSING NAME			预设: mushtree_small_burntfx		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_small")	
			inst.AnimState:SetBuild("mushroom_tree_small")	
			Anim路径 :  "anim/mushroom_tree_small.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
炭烤鼻孔			预设: batnose_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("batnose")	
			inst.AnimState:SetBuild("batnose")	
			Anim路径 :  "anim/batnose.zip"	
 	
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
桅杆			预设: mast		路径： [string "scripts/prefabs/mast.lua"]	
	Tags▼	
	{":", "inspectable", "mast_upgradeable", "HAMMER_workable", "NOBLOCK", "burnableignorefuel", "canlight", "saillowered", "structure", "blocker", "mast"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_mast2_wip")	
			Anim路径 :  "anim/boat_mast2_wip.zip"	
 	
	使用的组件▼	
		inst:AddComponent("mast")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("upgradeable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("ondeconstructstructure")	
------------------------------------------------	
甜龙虾汤			预设: lobsterbisque_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
兔绒			预设: manrabbit_tail		路径： [string "scripts/prefabs/manrabbit_tail.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_HORRIBLE", "cattoy", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("manrabbit_tail")	
			inst.AnimState:SetBuild("manrabbit_tail")	
			Anim路径 :  "anim/manrabbit_tail.zip"	
 	
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
MISSING NAME			预设: mushroombomb_projectile		路径： [string "scripts/prefabs/mushroombomb.lua"]	
	Tags▼	
	{":", "projectile", "locomotor", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroombomb")	
			inst.AnimState:SetBuild("mushroombomb")	
			Anim路径 :  "anim/mushroombomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
鹅卵石			预设: slingshotammo_rock		路径： [string "scripts/prefabs/slingshotammo.lua"]	
	Tags▼	
	{":", "_inventoryitem", "slingshotammo", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL", "reloaditem_ammo"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshotammo")	
			inst.AnimState:SetBuild("slingshotammo")	
			Anim路径 :  "anim/slingshotammo.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("reloaditem")	
		
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
月亮蘑菇			预设: moon_cap		路径： [string "scripts/prefabs/moon_mushroom.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "moonmushroom", "edible_VEGGIE", "canlight", "cookable", "mushroom", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_cap")	
			inst.AnimState:SetBuild("moon_cap")	
			Anim路径 :  "anim/moon_cap.zip"	
 	
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
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
梦魇护符			预设: purpleamulet		路径： [string "scripts/prefabs/amulet.lua"]	
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
		inst:AddComponent("fueled")	
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
MISSING NAME			预设: beemine_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_mine")	
			inst.AnimState:SetBuild("bee_mine")	
			Anim路径 :  "anim/bee_mine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
气球			预设: balloon		路径： [string "scripts/prefabs/balloon.lua"]	
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
高级种子包			预设: yotc_seedpacket_rare		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_seedpacket_rare")	
			inst.AnimState:SetBuild("yotc_seedpacket_rare")	
			Anim路径 :  "anim/yotc_seedpacket_rare.zip"	
 	
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
MISSING NAME			预设: staffcastfx		路径： [string "scripts/prefabs/staffcastfx.lua"]	
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
MISSING NAME			预设: dug_rock_avocado_bush_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_build")	
			Anim路径 :  "anim/rock_avocado.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
无花果烤串			预设: figkabab		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "canlight", "preparedfood", "fresh"}	
 	
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
珍贵的玩具机器人			预设: lost_toy_11		路径： [string "scripts/prefabs/lost_toys.lua"]	
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
MISSING NAME			预设: abigail_vex_debuff		路径： [string "scripts/prefabs/abigail.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_debuff_fx")	
			inst.AnimState:SetBuild("abigail_debuff_fx")	
			Anim路径 :  "anim/abigail_debuff_fx.zip"	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("abigail_vex_debuff.hitevent")	
------------------------------------------------	
MISSING NAME			预设: none_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mushtree_medium_bloom_burntfx		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_med")	
			inst.AnimState:SetBuild("mushroom_tree_med_bloom")	
			Anim路径 :  "anim/mushroom_tree_med.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: farmrocktall		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
天体英雄雕塑			预设: chesspiece_guardianphase3_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_bloom5		路径： [string "scripts/prefabs/lavaarena_blooms.lua"]	
	Tags▼	
	{":", "fx", "lavaarena_bloom"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")	
			Anim路径 :  "anim/lavaarena_heal_flowers_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
月亮实验			预设: halloween_experiment_moon		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
奶油土豆泥			预设: mashedpotatoes		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蒜香藤壶皮塔饼			预设: barnaclepita_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: explode_small_slurtle		路径： [string "scripts/prefabs/explode_small.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: slurperlight		路径： [string "scripts/prefabs/slurper.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜蓝带鱼排			预设: frogfishbowl_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: spellmasteryorbs		路径： [string "scripts/prefabs/spellmasterybuff.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
带斑点的小枝			预设: quagmire_spotspice_sprig		路径： [string "scripts/prefabs/quagmire_spiceshrub.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_spotspice_sprig")	
			inst.AnimState:SetBuild("quagmire_spotspice_sprig")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: globalmapiconunderfog		路径： [string "scripts/prefabs/globalmapicon.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: batbat_bats		路径： [string "scripts/prefabs/batbat.lua"]	
	Tags▼	
	{":", "fx", "nointerpolate"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣鳄梨酱			预设: guacamole_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
汉堡			预设: quagmire_food_033		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的龙虾汤			预设: lobsterbisque_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
帐篷卷			预设: portabletent_item		路径： [string "scripts/prefabs/portabletent.lua"]	
	Tags▼	
	{":", "_inventoryitem", "portableitem", "inspectable", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tent_walter")	
			inst.AnimState:SetBuild("tent_walter")	
			Anim路径 :  "anim/tent_walter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
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
MISSING NAME			预设: nightstickfire		路径： [string "scripts/prefabs/nightstickfire.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型腐烂火龙果			预设: dragonfruit_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_dragonfruit_build")	
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
芦苇束腰外衣			预设: lavaarena_armorlight		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "grass", "hide_percentage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_light")	
			inst.AnimState:SetBuild("armor_light")	
			Anim路径 :  "anim/armor_light.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: buff_playerabsorption		路径： [string "scripts/prefabs/foodbuffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
猎犬雕塑			预设: chesspiece_clayhound_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
卒子雕塑			预设: chesspiece_pawn_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
迷你旋转秋千套装			预设: carnivaldecor_eggride2_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_eggride2")	
			inst.AnimState:SetBuild("carnivaldecor_eggride2")	
			Anim路径 :  "anim/carnivaldecor_eggride2.zip"	
 	
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
蘑菇地精			预设: mushgnome		路径： [string "scripts/prefabs/mushgnome.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "FROMNUM", "freezable", "idle", "tree", "_combat", "locomotor", "sanityaura", "nolight", "leif", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grotto_mushgnome")	
			inst.AnimState:SetBuild("grotto_mushgnome")	
			Anim路径 :  "anim/grotto_mushgnome.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("periodicspawner")	
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
远古雕像			预设: ruins_statue_head		路径： [string "scripts/prefabs/statueruins.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "statue", "MINE_workable", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("statue_ruins_small")	
			inst.AnimState:SetBuild("statue_ruins_small")	
			Anim路径 :  "anim/statue_ruins_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
洞穴香蕉树			预设: cave_banana_burnt		路径： [string "scripts/prefabs/cave_banana_tree.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "CHOP_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cave_banana_tree")	
			inst.AnimState:SetBuild("cave_banana_tree")	
			Anim路径 :  "anim/cave_banana_tree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
熔化的弹珠			预设: trinket_1		路径： [string "scripts/prefabs/trinkets.lua"]	
	Tags▼	
	{":", "_inventoryitem", "slingshotammo", "inspectable", "molebait", "_stackable", "cattoy", "reloaditem_ammo"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trinkets")	
			inst.AnimState:SetBuild("trinkets")	
			Anim路径 :  "anim/trinkets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("reloaditem")	
		
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
小木牌			预设: minisign		路径： [string "scripts/prefabs/minisign.lua"]	
	Tags▼	
	{":", "sign", "inspectable", "DIG_workable", "canlight", "drawable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_mini")	
			inst.AnimState:SetBuild("sign_mini")	
			Anim路径 :  "anim/sign_mini.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("drawable")	
		
------------------------------------------------	
MISSING NAME			预设: rudder		路径： [string "scripts/prefabs/rudder.lua"]	
	Tags▼	
	{":", "DECOR", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_pointer_small")	
			Anim路径 :  "anim/boat_pointer_small.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: rubble_med		路径： [string "scripts/prefabs/rubble.lua"]	
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
失衡陀螺			预设: trinket_19		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: battlesong_healthgain_buff		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
啜食者			预设: slurper		路径： [string "scripts/prefabs/slurper.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "_health", "inspectable", "freezable", "idle", "hostile", "_combat", "locomotor", "slurper", "sanityaura", "nolight", "mufflehat", "_equippable", "sleeper", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slurper")	
			inst.AnimState:SetBuild("slurper_basic")	
			Anim路径 :  "anim/slurper_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("propagator")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: birdcage_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("birdcage")	
			inst.AnimState:SetBuild("bird_cage")	
			Anim路径 :  "anim/bird_cage.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
美味的蛋酒			预设: winter_food9		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "edible_MEAT", "inspectable", "wintersfeastfood", "_stackable", "cattoy"}	
 	
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
羽饰芦苇外衣			预设: lavaarena_armorlightspeed		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "grass", "hide_percentage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_lightspeed")	
			inst.AnimState:SetBuild("armor_lightspeed")	
			Anim路径 :  "anim/armor_lightspeed.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: halloween_firepuff_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
速度健身房			预设: yotc_carrat_gym_speed		路径： [string "scripts/prefabs/rat_gym.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "_inventory", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_gym_speed_build")	
			Anim路径 :  "anim/yotc_carrat_gym_speed.zip"	
 	
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
MISSING NAME			预设: quagmire_fest_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
活鳗鱼			预设: pondeel		路径： [string "scripts/prefabs/pondfish.lua"]	
	Tags▼	
	{":", "meat", "pondfish", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "smallcreature", "fish", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eel")	
			inst.AnimState:SetBuild("eel")	
			Anim路径 :  "anim/eel.zip"	
 	
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
陷阱			预设: trap		路径： [string "scripts/prefabs/trap.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "trap"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trap")	
			inst.AnimState:SetBuild("trap")	
			Anim路径 :  "anim/trap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trap")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("timer")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("floater_stopfloating")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("floater_startfloating")	
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
小饵鱼			预设: oceanfish_small_3_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_3")	
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
MISSING NAME			预设: yotc_carrat_race_checkpoint_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_race_checkpoint")	
			inst.AnimState:SetBuild("yotc_carrat_race_checkpoint")	
			Anim路径 :  "anim/yotc_carrat_race_checkpoint.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蓝色种子			预设: quagmire_seeds_1		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: crow_carnival_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wormlight_light_greater		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("spell")	
		
------------------------------------------------	
MISSING NAME			预设: stalker_shield1		路径： [string "scripts/prefabs/stalker_shield.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker_shield")	
			inst.AnimState:SetBuild("stalker_shield")	
			Anim路径 :  "anim/stalker_shield.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: crab_king_bubble1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
花式回旋块茎			预设: potatotornado		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
影子分身			预设: shadowlumber		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
	Tags▼	
	{":", "_health", "idle", "NOBLOCK", "_combat", "locomotor", "scarytoprey", "_follower", "shadowminion"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("waxwell_shadow_mod")	
			Anim路径 :  "anim/player_idles.zip"	
 	
	使用的组件▼	
		inst:AddComponent("follower")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: shock_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
奖品摊位套装			预设: carnival_prizebooth_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_prizebooth")	
			inst.AnimState:SetBuild("carnival_prizebooth")	
			Anim路径 :  "anim/carnival_prizebooth.zip"	
 	
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
皮普顿
清醒的泥沼鱼人			预设: quagmire_trader_merm2		路径： [string "scripts/prefabs/quagmire_traders.lua"]	
	Tags▼	
	{":", "character", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
		
------------------------------------------------	
天体祭坛雕像			预设: moon_altar_idol		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "work_moon_altar", "nonpotatable", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_altar_idolpiece")	
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
MISSING NAME			预设: caverain		路径： [string "scripts/prefabs/caverain.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
钢丝衣架			预设: trinket_27		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: buildgridplacer		路径： [string "../mods/workshop-100010060/scripts/prefabs/..."]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("buildgridplacer")	
			inst.AnimState:SetBuild("buildgridplacer")	
			Anim路径 :  "../mods/workshop-100010060/anim/buildgridplacer.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lizi01		路径： [string "../mods/KongZhiTai/scripts/prefabs/lizicesh..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: hua		路径： [string "../mods/KongZhiTai/scripts/prefabs/hua.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lavaarena_heal_flowers_fx")	
			Anim路径 :  "anim/lavaarena_heal_flowers_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
档案馆石墙			预设: wall_stone_2		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "HAMMER_workable", "_combat", "healthrepairable", "stone", "wall", "repairable_stone", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_stone_2")	
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
八宝泥馅饼			预设: yotp_food2		路径： [string "scripts/prefabs/yotp_food.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "_stackable", "edible_HORRIBLE"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotp_food")	
			inst.AnimState:SetBuild("yotp_food")	
			Anim路径 :  "anim/yotp_food.zip"	
 	
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
洞穴变身涂鸦			预设: mutator_hider		路径： [string "scripts/prefabs/spider_mutators.lua"]	
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
辣蛙腿三明治			预设: frogglebunwich_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
簇状种子			预设: corn_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
MISSING NAME			预设: compostheal_buff		路径： [string "scripts/prefabs/compostwrap.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
胡萝卜鼠秤			预设: yotc_carrat_scale		路径： [string "scripts/prefabs/yotc_carrat_scale.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "HAMMER_workable", "_inventory", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_scale")	
			inst.AnimState:SetBuild("yotc_carrat_scale")	
			Anim路径 :  "anim/yotc_carrat_scale.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("workable")	
		inst:AddComponent("shelf")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("trader")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_rug		路径： [string "scripts/prefabs/yotc_carrat_rug.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotc_carrat_rug")	
			Anim路径 :  "anim/yotc_carrat_rug.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onburntup")	
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_race_start_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_race_start")	
			inst.AnimState:SetBuild("yotc_carrat_race_start")	
			Anim路径 :  "anim/yotc_carrat_race_start.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: yotc_carrat_race_finish_light		路径： [string "scripts/prefabs/yotc_carrat_race_finish.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
终点线套装			预设: yotc_carrat_race_finish_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_racekit_finish")	
			inst.AnimState:SetBuild("yotc_carrat_racekit_finish")	
			Anim路径 :  "anim/yotc_carrat_racekit_finish.zip:IDLE"	
 	
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
MISSING NAME			预设: mushroomsprout_glow		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cavelight		路径： [string "scripts/prefabs/cavelight.lua"]	
	Tags▼	
	{":", "fx", "sinkhole", "FROMNUM", "daylight", "batdestination", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavelight")	
			inst.AnimState:SetBuild("cave_exit_lightsource")	
			Anim路径 :  "anim/cave_exit_lightsource.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hideout")	
		
------------------------------------------------	
海象			预设: walrus		路径： [string "scripts/prefabs/walrus.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "houndfriend", "freezable", "idle", "_inventory", "_combat", "MEAT_eater", "locomotor", "nolight", "character", "walrus", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("walrus")	
			inst.AnimState:SetBuild("walrus_build")	
			Anim路径 :  "anim/walrus_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("leader")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: yotb_stage_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_stagebooth")	
			Anim路径 :  "anim/yotb_stagebooth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
果冻虫			预设: halloweencandy_9		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
MISSING NAME			预设: yotb_stage_voice		路径： [string "scripts/prefabs/yotb_stage.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("build:")	
			inst.AnimState:SetBuild("Anim")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
		
	使用的监听▼	
		inst:ListenForEvent("ontalk")	
		inst:ListenForEvent("donetalking")	
------------------------------------------------	
炸肉排			预设: quagmire_food_055		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
缝纫机套装			预设: yotb_sewingmachine_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotb_sewingmachine_item")	
			inst.AnimState:SetBuild("yotb_sewingmachine_item")	
			Anim路径 :  "anim/yotb_sewingmachine_item.zip"	
 	
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
浆果丛			预设: dug_berrybush		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush")	
			inst.AnimState:SetBuild("berrybush")	
			Anim路径 :  "anim/berrybush.zip"	
 	
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
MISSING NAME			预设: yotb_post_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_post_rug")	
			Anim路径 :  "anim/yotb_post_rug.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: yotb_post_spotlight		路径： [string "scripts/prefabs/yotb_post.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotb_spotlight")	
			inst.AnimState:SetBuild("yotb_spotlight")	
			Anim路径 :  "anim/yotb_spotlight.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
可疑的月岩			预设: gargoyle_werepigatk		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "gargoyle", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")	
			Anim路径 :  "anim/sculpture_werepig.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
------------------------------------------------	
一块面包			预设: quagmire_food_001		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
小烤架			预设: quagmire_grill_small		路径： [string "scripts/prefabs/quagmire_grill.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_grill_small")	
			inst.AnimState:SetBuild("quagmire_grill_small")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: spidereggsack_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_cocoon")	
			inst.AnimState:SetBuild("spider_cocoon")	
			Anim路径 :  "anim/spider_cocoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: sisturn_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sisturn")	
			inst.AnimState:SetBuild("sisturn")	
			Anim路径 :  "anim/sisturn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
恐怖款式碎片			预设: yotb_pattern_fragment_1		路径： [string "scripts/prefabs/yotb_pattern_fragments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "yotb_pattern_fragment", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_pattern_fragment_1")	
			Anim路径 :  "anim/yotb_pattern_fragment_1.zip"	
 	
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
节日盛装款式			预设: festive_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
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
MISSING NAME			预设: deerclopswarning_lvl1		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
娃娃礼服款式			预设: doll_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
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
幸运野兽礼服款式			预设: beast_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
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
多汁浆果丛			预设: dug_berrybush_juicy		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush_juicy")	
			inst.AnimState:SetBuild("berrybush_juicy")	
			Anim路径 :  "anim/berrybush_juicy.zip"	
 	
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
MISSING NAME			预设: yotb_beefaloshrine_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefaloshrine")	
			inst.AnimState:SetBuild("yotb_beefaloshrine")	
			Anim路径 :  "anim/yotb_beefaloshrine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
盐架			预设: quagmire_salt_rack		路径： [string "scripts/prefabs/quagmire_salt_rack.lua"]	
	Tags▼	
	{":", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_salt_rack")	
			inst.AnimState:SetBuild("quagmire_salt_rack")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
通心粉和奶酪			预设: quagmire_food_046		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
铁甲皮弗娄牛玩偶			预设: yotb_beefalo_doll_robot		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
毁掉的汁液			预设: quagmire_sap_spoiled		路径： [string "scripts/prefabs/quagmire_sap.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_sap")	
			inst.AnimState:SetBuild("quagmire_sap")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
战士皮弗娄牛玩偶			预设: yotb_beefalo_doll_war		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
甜无花果意面			预设: figatoni_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
座狼雕塑			预设: chesspiece_claywarg		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_claywarg_marble")	
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
WX-78			预设: wx78		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "ignoresspoilage", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "electricdamageimmune", "_hunger", "soulless", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser", "GEARS_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wx78")	
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
MISSING NAME			预设: petrified_trunk_break_fx		路径： [string "scripts/prefabs/petrify_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
沃特			预设: wurt		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "merm", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "merm_builder", "wet", "idle", "aspiring_bookworm", "_builder", "_sanity", "_inventory", "reader", "_combat", "locomotor", "_moisture", "mermfluent", "scarytoprey", "nolight", "debuffable", "stronggrip", "usesvegetarianequipment", "playermerm", "turfrunner_8", "_hunger", "_rider", "singingshelltrigger", "mermguard", "character", "lightningtarget", "waterplant_upgradeuser", "VEGETARIAN_eater"}	
 	
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
		inst:AddComponent("itemaffinity")	
		inst:AddComponent("preserver")	
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
		inst:ListenForEvent("onmermkingcreated")	
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
		inst:ListenForEvent("ms_respawnedfromghost")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("onchangecanopyzone")	
		inst:ListenForEvent("ghostdelta")	
		inst:ListenForEvent("onmermkingdestroyed")	
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
MISSING NAME			预设: blossom_projectile		路径： [string "scripts/prefabs/fireball_projectile.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wortox_soul_in_fx		路径： [string "scripts/prefabs/wortox_soul_in_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wortox_soul_ball")	
			inst.AnimState:SetBuild("wortox_soul_ball")	
			Anim路径 :  "anim/wortox_soul_ball.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: plant_dug_large_fx		路径： [string "scripts/prefabs/plant_normal.lua"]	
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
MISSING NAME			预设: wortox_soul_heal_fx		路径： [string "scripts/prefabs/wortox_soul_heal_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wortox_soul_heal_fx")	
			inst.AnimState:SetBuild("wortox_soul_heal_fx")	
			Anim路径 :  "anim/wortox_soul_heal_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
灵魂			预设: wortox_soul		路径： [string "scripts/prefabs/wortox_soul.lua"]	
	Tags▼	
	{":", "_inventoryitem", "soul", "inspectable", "nosteal", "_stackable", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wortox_soul_ball")	
			inst.AnimState:SetBuild("wortox_soul_ball")	
			Anim路径 :  "anim/wortox_soul_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("soul")	
		inst:AddComponent("stackable")	
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
------------------------------------------------	
MISSING NAME			预设: wortox_portal_jumpin_fx		路径： [string "scripts/prefabs/wortox_portal_fx.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wortox_portal")	
			Anim路径 :  "anim/wortox_portal.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: carnival_prizebooth_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_prizebooth")	
			inst.AnimState:SetBuild("carnival_prizebooth")	
			Anim路径 :  "anim/carnival_prizebooth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
便携香料站			预设: portablespicer_item		路径： [string "scripts/prefabs/portablespicer.lua"]	
	Tags▼	
	{":", "_inventoryitem", "portableitem", "inspectable", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_spicer")	
			inst.AnimState:SetBuild("portable_spicer")	
			Anim路径 :  "anim/portable_spicer.zip"	
 	
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
损坏的发条装置			预设: chessjunk3		路径： [string "scripts/prefabs/chessjunk.lua"]	
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
辣波兰水饺			预设: perogies_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: wormwarning_lvl4		路径： [string "scripts/prefabs/wormwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wormwarning_lvl1		路径： [string "scripts/prefabs/wormwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
神秘植物			预设: wormlight_plant		路径： [string "scripts/prefabs/wormlight_plant.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "plant", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("worm")	
			inst.AnimState:SetBuild("worm")	
			Anim路径 :  "anim/worm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: wormlight_light_fx_greater		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
长猪			预设: humanmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "selfstacker", "dryable", "_stackable", "badfood", "cookable", "lureplant_bait", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_human")	
			inst.AnimState:SetBuild("meat_human")	
			Anim路径 :  "anim/meat_human.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("selfstacker")	
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
木制传送台			预设: teleportato_base		路径： [string "scripts/prefabs/teleportato.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "_container", "quickactivation", "teleportato", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("teleporter")	
			inst.AnimState:SetBuild("teleportato_build")	
			Anim路径 :  "anim/teleportato.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("activatable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
MISSING NAME			预设: wormlight_light_fx_lesser		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
锚			预设: anchor		路径： [string "scripts/prefabs/anchor.lua"]	
	Tags▼	
	{":", "inspectable", "anchor_raised", "HAMMER_workable", "canlight", "structure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_anchor")	
			inst.AnimState:SetBuild("boat_anchor")	
			Anim路径 :  "anim/boat_anchor.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("anchor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("boatdrag")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("anchor_lowered")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: wormlight_light_fx		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wormlight_light_lesser		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("spell")	
		
------------------------------------------------	
小发光浆果			预设: wormlight_lesser		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "_inventoryitem", "vasedecoration", "lightbattery", "inspectable", "FROMNUM", "WORMLIGHT_fuel", "_stackable", "edible_VEGGIE", "badfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("worm_light_lesser")	
			inst.AnimState:SetBuild("worm_light_lesser")	
			Anim路径 :  "anim/worm_light_lesser.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("floater")	
		inst:AddComponent("vasedecoration")	
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
蔬菜大杂烩			预设: quagmire_food_030		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜花沙拉			预设: flowersalad_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
生病的虫洞			预设: wormhole_limited_1		路径： [string "scripts/prefabs/wormhole_limited.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "alltrader", "idle", "_inventory", "antlion_sinkhole_blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("teleporter_sickworm_build")	
			Anim路径 :  "anim/teleporter_worm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("teleporter")	
		inst:AddComponent("trader")	
		
	使用的监听▼	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("starttravelsound")	
		inst:ListenForEvent("doneteleporting")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
口水鱼			预设: oceanfish_small_9_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_9")	
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
MISSING NAME			预设: worm_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
气球帽			预设: balloonhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "hat", "noepicmusic", "_combat", "cattoy", "waterproofer", "_equippable", "balloon", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("balloonhat")	
			inst.AnimState:SetBuild("hat_balloon")	
			Anim路径 :  "anim/hat_balloon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("poppable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("fueled")	
		inst:AddComponent("health")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: slingshotammo_hitfx_poop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
土堆			预设: worm		路径： [string "scripts/prefabs/worm.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "wet", "invisible", "idle", "dirt", "_inventory", "hostile", "_combat", "locomotor", "OMNI_eater", "sanityaura", "worm"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("worm")	
			inst.AnimState:SetBuild("worm")	
			Anim路径 :  "anim/worm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
伍迪			预设: woodie		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "wereness", "freezable", "player", "woodcutter", "idle", "_builder", "_sanity", "bearded", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "werehuman", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser", "polite"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("woodie")	
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
		inst:AddComponent("wereness")	
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
		inst:AddComponent("rider")	
		inst:AddComponent("wereeater")	
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
		inst:AddComponent("tackler")	
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
		inst:ListenForEvent("newstate")	
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
		inst:ListenForEvent("insufficientfertilizer")	
		inst:ListenForEvent("onstartedfire")	
		inst:ListenForEvent("ms_respawnedfromghost")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("learncookbookstats")	
		inst:ListenForEvent("werenessdelta")	
		inst:ListenForEvent("onchangecanopyzone")	
		inst:ListenForEvent("ghostdelta")	
		inst:ListenForEvent("takeoversizedpicture")	
		inst:ListenForEvent("learnfertilizer")	
		inst:ListenForEvent("setowner")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("lightningdamageavoided")	
		inst:ListenForEvent("unevengrounddetected")	
		inst:ListenForEvent("coveredinbees")	
		inst:ListenForEvent("startoverheating")	
		inst:ListenForEvent("itemranout")	
		inst:ListenForEvent("startfiredamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("killed")	
		inst:ListenForEvent("working")	
		inst:ListenForEvent("playerdeactivated")	
		inst:ListenForEvent("wonteatfood")	
		inst:ListenForEvent("dropitem")	
		inst:ListenForEvent("snared")	
		inst:ListenForEvent("picksomething")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("accomplishment")	
		inst:ListenForEvent("resistedgrue")	
		inst:ListenForEvent("ms_closepopup")	
		inst:ListenForEvent("heargrue")	
		inst:ListenForEvent("wormholespit")	
		inst:ListenForEvent("makeplayerghost")	
		inst:ListenForEvent("inventoryfull")	
		inst:ListenForEvent("usedtouchstone")	
		inst:ListenForEvent("equip")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("foodbuffdetached")	
		inst:ListenForEvent("foodbuffattached")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("hungrybuild")	
		inst:ListenForEvent("encumberedwalking")	
		inst:ListenForEvent("attackedbygrue")	
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
沃利			预设: warly		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "professionalchef", "scarytoprey", "nolight", "debuffable", "expertchef", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser", "masterchef"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("warly")	
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
		inst:AddComponent("foodmemory")	
		
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
沃尔夫冈			预设: wolfgang		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wolfgang")	
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
		inst:ListenForEvent("mounted")	
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
		inst:ListenForEvent("dismounted")	
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
沃比			预设: wobysmall		路径： [string "scripts/prefabs/wobysmall.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "_container", "idle", "fedbyall", "small_livestock", "NOBLOCK", "locomotor", "_follower", "_hunger", "MONSTER_eater", "critter", "sleeper", "noauradamage", "noabandon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("pupington_woby_build")	
			Anim路径 :  "anim/pupington_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("colourtweener")	
		inst:AddComponent("crittertraits")	
		inst:AddComponent("container")	
		inst:AddComponent("spawnfader")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("eater")	
		inst:AddComponent("hunger")	
		inst:AddComponent("timer")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("itemlose")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: spawn_fx_tiny		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
死龙虾			预设: wobster_sheller_dead		路径： [string "scripts/prefabs/wobster.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "fishmeat", "_stackable", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_sheller")	
			Anim路径 :  "anim/lobster.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("cookable")	
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
知识饮水机			预设: archive_lockbox_dispencer		路径： [string "scripts/prefabs/archive_lockbox.lua"]	
	Tags▼	
	{":", "inspectable", "dustable", "quickactivation", "structure", "inactive", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("archive_knowledge_dispensary")	
			Anim路径 :  "anim/archive_knowledge_dispensary.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("activatable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: slow_farmplot_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farmplot")	
			inst.AnimState:SetBuild("farmplot")	
			Anim路径 :  "anim/farmplot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
月光龙虾			预设: wobster_moonglass_land		路径： [string "scripts/prefabs/wobster.lua"]	
	Tags▼	
	{":", "_inventoryitem", "murderable", "weighable_fish", "_health", "inspectable", "freezable", "stunnedbybomb", "idle", "whackable", "smallcreature", "_combat", "canbetrapped", "locomotor", "prey", "nolight", "show_spoilage", "smalloceancreature", "animal", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_moonglass")	
			Anim路径 :  "anim/lobster.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("combat")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("weighable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("murderable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("on_loot_dropped")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
苏打鱼			预设: wintercooking_lutefisk		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蛞蝓龟窝			预设: slurtlehole		路径： [string "scripts/prefabs/slurtlehole.lua"]	
	Tags▼	
	{":", "cavedweller", "_health", "inspectable", "explosive", "hostile", "_combat", "canlight", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slurtle_mound")	
			inst.AnimState:SetBuild("slurtle_mound")	
			Anim路径 :  "anim/slurtle_mound.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("explosive")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("health")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("endquake")	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: ruinsrelic_chipbowl_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_chipbowl")	
			inst.AnimState:SetBuild("ruins_chipbowl")	
			Anim路径 :  "anim/ruins_chipbowl.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
波兰饼干			预设: wintercooking_polishcookie		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: battlesong_healthgain_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
塔马利			预设: wintercooking_tamales		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: deerclopswarning_lvl4		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
饕餮馅饼			预设: wintercooking_tourtiere		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
香料潘趣酒			预设: wintercooking_mulleddrink		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
快乐浆果酱			预设: wintercooking_berrysauce		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
土豆饼			预设: wintercooking_latkes		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: nightlight_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmare_torch")	
			inst.AnimState:SetBuild("nightmare_torch")	
			Anim路径 :  "anim/nightmare_torch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
巴甫洛娃蛋糕			预设: wintercooking_pavlova		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wintersfeastoven_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wintersfeast_oven")	
			inst.AnimState:SetBuild("wintersfeast_oven")	
			Anim路径 :  "anim/wintersfeast_oven.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
暗影			预设: waxwell_shadowstriker		路径： [string "scripts/prefabs/waxwell_shadowstriker.lua"]	
	Tags▼	
	{":", "NOBLOCK", "scarytoprey"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_shadow_lunge")	
			inst.AnimState:SetBuild("waxwell_shadow_mod")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: wintersfeastoven_fire		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "fx", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wintersfeast_oven")	
			inst.AnimState:SetBuild("wintersfeast_oven")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: hungerregenbuff		路径： [string "scripts/prefabs/hungerregenbuff.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: weaponsparks_bounce		路径： [string "scripts/prefabs/weaponsparks.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: crabking_ring_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
永远的水果蛋糕			预设: winter_food4		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
	Tags▼	
	{":", "pre-preparedfood", "_inventoryitem", "inspectable", "wintersfeastfood", "_stackable", "winter_ornament", "edible_VEGGIE", "cattoy", "badfood"}	
 	
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
糖曲奇饼			预设: winter_food2		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
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
小姜饼			预设: winter_food1		路径： [string "scripts/prefabs/wintersfeastfood.lua"]	
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
石笋			预设: stalagmite_tall_full		路径： [string "scripts/prefabs/stalagmite_tall.lua"]	
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
烤火鸡面包馅			预设: stuffing		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
比宾卡米糕			预设: bibingka		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
烤种子			预设: seeds_cooked		路径： [string "scripts/prefabs/seeds.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_SEEDS", "_stackable", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seeds")	
			inst.AnimState:SetBuild("seeds")	
			Anim路径 :  "anim/seeds.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
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
快乐浆果酱			预设: berrysauce		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
腌鲱鱼			预设: pickledherring		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
MISSING NAME			预设: rhinobumpfx		路径： [string "scripts/prefabs/lavaarena_rhinobumpfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cave_hole		路径： [string "scripts/prefabs/cave_hole.lua"]	
	Tags▼	
	{":", "groundhole", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cave_hole")	
			inst.AnimState:SetBuild("cave_hole")	
			Anim路径 :  "anim/cave_hole.zip"	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
节庆鱼料理			预设: festivefish		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
小份炖菜			预设: quagmire_casseroledish_small		路径： [string "scripts/prefabs/quagmire_casseroledish.lua"]	
	Tags▼	
	{":", "quagmire_stewer", "quagmire_casseroledish"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_casseroledish_small")	
			inst.AnimState:SetBuild("quagmire_casseroledish_small")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wintersfeastbuff_fx		路径： [string "scripts/prefabs/wintersfeastbuff.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winters_feast_fx")	
			inst.AnimState:SetBuild("winters_feast_fx")	
			Anim路径 :  "anim/winters_feast_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: lavaarena_spawnerdecor_fx_small		路径： [string "scripts/prefabs/lavaarena_creature_spawn_fx..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: winterometer_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_meter")	
			inst.AnimState:SetBuild("winter_meter")	
			Anim路径 :  "anim/winter_meter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
温度测量仪			预设: winterometer		路径： [string "scripts/prefabs/winterometer.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_meter")	
			inst.AnimState:SetBuild("winter_meter")	
			Anim路径 :  "anim/winter_meter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
MISSING NAME			预设: winter_treestand_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wintertree_build")	
			Anim路径 :  "anim/wintertree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
一角鲸			预设: gnarwail		路径： [string "scripts/prefabs/gnarwail.lua"]	
	Tags▼	
	{":", "scarytocookiecutters", "gnarwail", "trader", "_health", "inspectable", "freezable", "idle", "hostile", "strongstomach", "_combat", "MEAT_eater", "locomotor", "scarytoprey", "_follower", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gnarwail")	
			inst.AnimState:SetBuild("gnarwail_build")	
			Anim路径 :  "anim/gnarwail.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("freezable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("timer")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("follower")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
船			预设: boat		路径： [string "scripts/prefabs/boat.lua"]	
	Tags▼	
	{":", "boat", "_health", "repairable_wood", "walkableplatform", "antlion_sinkhole_blocker", "ignorewalkableplatforms", "wood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_test")	
			Anim路径 :  "anim/boat_test.zip"	
 	
	使用的组件▼	
		inst:AddComponent("reticule")	
		inst:AddComponent("hull")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("boatdrifter")	
		inst:AddComponent("healthsyncer")	
		inst:AddComponent("boattrail")	
		inst:AddComponent("health")	
		inst:AddComponent("repairable")	
		inst:AddComponent("boatphysics")	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("walkableplatform")	
		inst:AddComponent("hullhealth")	
		
	使用的监听▼	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("spawnnewboatleak")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("starthealthregen")	
		inst:ListenForEvent("endsteeringreticule")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("startcorrosivedebuff")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("starsteeringreticule")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
冬季圣诞树			预设: winter_tree		路径： [string "scripts/prefabs/winter_tree.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "event_trigger", "canlight", "decoratable", "structure", "winter_tree", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("evergreen_new")	
			Anim路径 :  "anim/wintertree.zip"	
 	
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
麋鹿鹅雕塑			预设: chesspiece_moosegoose		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_moosegoose_moonglass")	
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
大熔炉猪战士			预设: lavaarena_groundliftempty		路径： [string "scripts/prefabs/lavaarena_groundlifts.lua"]	
	Tags▼	
	{":", "groundspike", "object", "CLASSIFIED", "hostile", "notarget", "stone"}	
 	
	使用的组件▼	
		
------------------------------------------------	
感伤装饰			预设: winter_ornament_boss_hermithouse		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
多枝树种			预设: twiggy_nut		路径： [string "scripts/prefabs/pinecone.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight", "deployable", "treeseed"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("twiggy_nut")	
			inst.AnimState:SetBuild("twiggy_nut")	
			Anim路径 :  "anim/twiggy_nut.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("winter_treeseed")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("deployable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("forcecompostable")	
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
华丽的装饰			预设: winter_ornament_boss_toadstool_misery		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: lavaarena_firebomb_projectile		路径： [string "scripts/prefabs/lavaarena_firebomb.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_minotaur		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
华丽的装饰			预设: winter_ornament_boss_crabkingpearl		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
超级催长剂			预设: soil_amender_fermented		路径： [string "scripts/prefabs/soil_amender.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "fertilizer", "fertilizerresearchable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("soil_amender")	
			inst.AnimState:SetBuild("soil_amender")	
			Anim路径 :  "anim/soil_amender.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fertilizer")	
		inst:AddComponent("hauntable")	
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
华丽的装饰			预设: winter_ornament_boss_toadstool		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
颗粒状传输			预设: wagstaff_npc		路径： [string "scripts/prefabs/wagstaff_npc.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "FROMNUM", "idle", "_inventory", "locomotor", "wagstaff_npc", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wagstaff")	
			Anim路径 :  "anim/player_emote_extra.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("talker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("teleportedoverride")	
		inst:AddComponent("hudindicatable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventory")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("ontalk")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("moonboss_defeated")	
		inst:ListenForEvent("teleported")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: thunder_far		路径： [string "scripts/prefabs/thunder_far.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_fuelweaver		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
华丽的装饰			预设: winter_ornament_boss_beequeen		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: spat_splash_fx_full		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蜂蜜			预设: honey		路径： [string "scripts/prefabs/honey.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "honeyed", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("honey")	
			inst.AnimState:SetBuild("honey")	
			Anim路径 :  "anim/honey.zip"	
 	
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
小烤架			预设: quagmire_grill_small_item		路径： [string "scripts/prefabs/quagmire_grill.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_grill_small")	
			inst.AnimState:SetBuild("quagmire_grill_small")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
暴食装饰			预设: winter_ornament_festivalevents5		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
暴食装饰			预设: winter_ornament_festivalevents4		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: formationleader		路径： [string "scripts/prefabs/formationleader.lua"]	
	Tags▼	
	{":", "formationleader", "NOBLOCK", "NOCLICK", "formationleader_monster"}	
 	
	使用的组件▼	
		inst:AddComponent("formationleader")	
		
------------------------------------------------	
圣诞灯			预设: winter_ornament_light7		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
圣诞小玩意			预设: winter_ornament_fancy6		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
圣诞小玩意			预设: winter_ornament_fancy4		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
皮弗娄牛雕塑			预设: chesspiece_beefalo_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: perdshrine_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("perdshrine")	
			inst.AnimState:SetBuild("perdshrine")	
			Anim路径 :  "anim/perdshrine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
多枝树苗			预设: twiggy_nut_sapling		路径： [string "scripts/prefabs/planted_tree.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "DIG_workable", "canlight", "twiggytree"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("twiggy_nut")	
			inst.AnimState:SetBuild("twiggy_nut")	
			Anim路径 :  "anim/twiggy_nut.zip"	
 	
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
圣诞小玩意			预设: winter_ornament_fancy2		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
速度健身房套装			预设: yotc_carrat_gym_speed_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_gym_speed_item")	
			inst.AnimState:SetBuild("yotc_carrat_gym_speed_item")	
			Anim路径 :  "anim/yotc_carrat_gym_speed_item.zip"	
 	
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
圣诞小玩意			预设: winter_ornament_fancy1		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
圣诞小玩意			预设: winter_ornament_plain12		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
圣诞小玩意			预设: winter_ornament_plain10		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
圣诞小玩意			预设: winter_ornament_plain4		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
诅咒弹药			预设: slingshotammo_thulecite		路径： [string "scripts/prefabs/slingshotammo.lua"]	
	Tags▼	
	{":", "_inventoryitem", "slingshotammo", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL", "reloaditem_ammo"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshotammo")	
			inst.AnimState:SetBuild("slingshotammo")	
			Anim路径 :  "anim/slingshotammo.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("reloaditem")	
		
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
圣诞小玩意			预设: winter_ornament_plain3		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
圣诞小玩意			预设: winter_ornament_plain1		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
薇诺娜的聚光灯			预设: winona_spotlight		路径： [string "scripts/prefabs/winona_spotlight.lua"]	
	Tags▼	
	{":", "spotlight", "inspectable", "HAMMER_workable", "canlight", "structure", "engineering", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_spotlight")	
			inst.AnimState:SetBuild("winona_spotlight")	
			Anim路径 :  "anim/winona_spotlight.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("updatelooper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("deployhelper")	
		inst:AddComponent("circuitnode")	
		inst:AddComponent("colouradder")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("engineeringcircuitchanged")	
------------------------------------------------	
辣肉串			预设: kabobs_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: weregoose_splash_less1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cane_sharp_fx		路径： [string "scripts/prefabs/cane_sharp_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: ink_puddle_land		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: carnivalcannon_confetti_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon")	
			Anim路径 :  "anim/carnival_cannon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
鹅羽浮标			预设: oceanfishingbobber_goose_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_goose_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
MISSING NAME			预设: winona_battery_sparks		路径： [string "scripts/prefabs/winona_battery_sparks.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sparks")	
			inst.AnimState:SetBuild("sparks")	
			Anim路径 :  "anim/sparks.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
辣椒			预设: pepper		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
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
巨型南瓜			预设: pumpkin_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_pumpkin")	
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
薇诺娜			预设: winona		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "hungrybuilder", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "fastbuilder", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser", "handyperson"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("winona")	
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
薇克巴顿			预设: wickerbottom		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "reader", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "insomniac", "usesvegetarianequipment", "bookbuilder", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wickerbottom")	
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
韦德			预设: pigelite1		路径： [string "scripts/prefabs/pigelite.lua"]	
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
```
