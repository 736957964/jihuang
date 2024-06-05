> 摘录う丶青木
- 数据提取(数据量有点多 拆多份了)
```lua 
兔洞			预设: rabbithole		路径： [string "scripts/prefabs/rabbithole.lua"]	
	Tags▼	
	{":", "inspectable", "cattoy", "DIG_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rabbithole")	
			inst.AnimState:SetBuild("rabbit_hole")	
			Anim路径 :  "anim/rabbit_hole.zip"	
 	
	使用的组件▼	
		inst:AddComponent("spawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("death")	
------------------------------------------------	
石头			预设: rocks		路径： [string "scripts/prefabs/inv_rocks.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "quakedebris", "edible_ELEMENTAL", "repairer", "health_stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rocks")	
			inst.AnimState:SetBuild("rocks")	
			Anim路径 :  "anim/rocks.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("repairer")	
		
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
岩石			预设: lava_pond_rock3		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_rock")	
			inst.AnimState:SetBuild("scorched_rock")	
			Anim路径 :  "anim/scorched_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
浮堆			预设: seastack		路径： [string "scripts/prefabs/seastack.lua"]	
	Tags▼	
	{":", "inspectable", "waterplant_upgradeable", "MINE_workable", "ignorewalkableplatforms", "seastack", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("water_rock_01")	
			Anim路径 :  "anim/water_rock_01.zip"	
 	
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
月树			预设: moon_tree		路径： [string "scripts/prefabs/moontree.lua"]	
	Tags▼	
	{":", "tree", "moon_tree", "plant", "CHOP_workable", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_tree")	
			inst.AnimState:SetBuild("moon_tree")	
			Anim路径 :  "anim/moon_tree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("plantregrowth")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
常青树			预设: evergreen		路径： [string "scripts/prefabs/evergreens.lua"]	
	Tags▼	
	{":", "evergreen", "tree", "petrifiable", "plant", "CHOP_workable", "evergreens", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_short")	
			inst.AnimState:SetBuild("evergreen_new")	
			Anim路径 :  "anim/evergreen_short_normal.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("plantregrowth")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("petrifiable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: float_fx_back		路径： [string "scripts/prefabs/float_fx.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("float_fx")	
			Anim路径 :  "anim/float_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: inventoryitem_classified		路径： [string "scripts/prefabs/inventoryitem_classified.lu..."]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
岩浆池			预设: lava_pond		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "cooker", "HASHEATER", "antlion_sinkhole_blocker", "birdblocker", "lava", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lava_tile")	
			inst.AnimState:SetBuild("lava_tile")	
			Anim路径 :  "anim/lava_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("cooker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("dragonflyengaged")	
------------------------------------------------	
MISSING NAME			预设: float_fx_front		路径： [string "scripts/prefabs/float_fx.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("float_fx")	
			Anim路径 :  "anim/float_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
岩石			预设: lava_pond_rock6		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_rock")	
			inst.AnimState:SetBuild("scorched_rock")	
			Anim路径 :  "anim/scorched_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
岩石			预设: lava_pond_rock4		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_rock")	
			inst.AnimState:SetBuild("scorched_rock")	
			Anim路径 :  "anim/scorched_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
岩石			预设: lava_pond_rock		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_rock")	
			inst.AnimState:SetBuild("scorched_rock")	
			Anim路径 :  "anim/scorched_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
海草			预设: waterplant		路径： [string "scripts/prefabs/waterplant.lua"]	
	Tags▼	
	{":", "harvestable", "_health", "inspectable", "freezable", "waterplant", "idle", "bearded", "_inventory", "_combat", "ignorewalkableplatforms", "canlight", "sleeper", "seastack", "veggie", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle_plant")	
			inst.AnimState:SetBuild("barnacle_plant_colour_swaps")	
			Anim路径 :  "anim/barnacle_plant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("combat")	
		inst:AddComponent("colouradder")	
		inst:AddComponent("propagator")	
		inst:AddComponent("harvestable")	
		inst:AddComponent("shaveable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventory")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("pollenlanded")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("freeze")	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("droppedtarget")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: waterplant_base		路径： [string "scripts/prefabs/waterplant.lua"]	
	Tags▼	
	{":", "DECOR", "freezable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle_plant")	
			inst.AnimState:SetBuild("barnacle_plant_colour_swaps")	
			Anim路径 :  "anim/barnacle_plant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
------------------------------------------------	
MISSING NAME			预设: moon_altar_astral_marker_1		路径： [string "scripts/prefabs/moon_altar.lua"]	
	Tags▼	
	{":", "fx", "moon_altar_astral_marker", "antlion_sinkhole_blocker", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cookiecutter_spawner		路径： [string "scripts/prefabs/cookiecutter_spawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
悬垂蜘蛛装饰			预设: halloween_ornament_5		路径： [string "scripts/prefabs/halloween_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "BURNABLE_fuel", "halloween_ornament"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_ornaments")	
			inst.AnimState:SetBuild("halloween_ornaments")	
			Anim路径 :  "anim/halloween_ornaments.zip"	
 	
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
可疑的大理石			预设: sculpture_rooknose		路径： [string "scripts/prefabs/sculpture_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "nonpotatable", "work_sculpture", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_sculpture_rooknose")	
			Anim路径 :  "anim/sculpture_pieces.zip"	
 	
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
花			预设: flower		路径： [string "scripts/prefabs/flower.lua"]	
	Tags▼	
	{":", "quickpick", "inspectable", "cattoy", "halloweenmoonmutable", "canlight", "flower", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flowers")	
			inst.AnimState:SetBuild("flowers")	
			Anim路径 :  "anim/flowers.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("halloweenmoonmutable")	
		
------------------------------------------------	
高音贝壳钟			预设: singingshell_octave5		路径： [string "scripts/prefabs/singingshell.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "cancycle", "HAMMER_workable", "singingshell"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("singingshell")	
			inst.AnimState:SetBuild("singingshell")	
			Anim路径 :  "anim/singingshell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("workable")	
		inst:AddComponent("cyclable")	
		inst:AddComponent("lootdropper")	
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
MISSING NAME			预设: seastack_spawner_rough		路径： [string "scripts/prefabs/seastack.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
植物			预设: marsh_plant		路径： [string "scripts/prefabs/marsh_plant.lua"]	
	Tags▼	
	{":", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_plant")	
			inst.AnimState:SetBuild("marsh_plant")	
			Anim路径 :  "anim/marsh_plant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
船碎片			预设: boatfragment03		路径： [string "scripts/prefabs/boatfragments.lua"]	
	Tags▼	
	{":", "inspectable", "wet", "HAMMER_workable", "canlight", "edible_WOOD", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_brokenparts_build")	
			Anim路径 :  "anim/boat_brokenparts.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
仙人掌			预设: cactus		路径： [string "scripts/prefabs/cactus.lua"]	
	Tags▼	
	{":", "thorny", "inspectable", "plant", "canlight", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cactus")	
			inst.AnimState:SetBuild("cactus")	
			Anim路径 :  "anim/cactus.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
方尖碑			预设: insanityrock		路径： [string "scripts/prefabs/nightmarerock.lua"]	
	Tags▼	
	{":", "insanityrock", "inspectable", "idle", "antlion_sinkhole_blocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blocker_sanity")	
			inst.AnimState:SetBuild("blocker_sanity")	
			Anim路径 :  "anim/blocker_sanity.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onispathfindingdirty")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: lightrays_canopy		路径： [string "scripts/prefabs/light_rays.lua"]	
	Tags▼	
	{":", "exposure", "FROMNUM", "NOBLOCK", "ignorewalkableplatforms", "NOCLICK", "lightrays"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lightrays")	
			inst.AnimState:SetBuild("lightrays")	
			Anim路径 :  "anim/lightrays.zip"	
 	
	使用的组件▼	
		inst:AddComponent("distancefade")	
		
	使用的监听▼	
		inst:ListenForEvent("raysdirty")	
------------------------------------------------	
可疑的月岩			预设: gargoyle_werepighowl		路径： [string "scripts/prefabs/gargoyles.lua"]	
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
绚丽之门			预设: multiplayer_portal		路径： [string "scripts/prefabs/multiplayer_portal.lua"]	
	Tags▼	
	{":", "inspectable", "idle", "multiplayer_portal", "antlion_sinkhole_blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("portal_stone")	
			Anim路径 :  "anim/portal_stone.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_newplayercharacterspawned")	
		inst:ListenForEvent("rez_player")	
	SG = 有▼	
------------------------------------------------	
隐士之家			预设: hermithouse_construction1		路径： [string "scripts/prefabs/hermithouse.lua"]	
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
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("clocksegschanged")	
------------------------------------------------	
MISSING NAME			预设: constructionsite_classified		路径： [string "scripts/prefabs/constructionsite_classified..."]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
粗壮常青树			预设: evergreen_sparse		路径： [string "scripts/prefabs/evergreens.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "petrifiable", "plant", "CHOP_workable", "evergreen_sparse", "canlight", "evergreens", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_short")	
			inst.AnimState:SetBuild("evergreen_new_2")	
			Anim路径 :  "anim/evergreen_tall_old.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("plantregrowth")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("timer")	
		inst:AddComponent("petrifiable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
玩具眼镜蛇			预设: trinket_42		路径： [string "scripts/prefabs/trinkets.lua"]	
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
胡萝卜			预设: carrot_planted		路径： [string "scripts/prefabs/carrot.lua"]	
	Tags▼	
	{":", "quickpick", "inspectable", "halloweenmoonmutable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carrot")	
			inst.AnimState:SetBuild("carrot")	
			Anim路径 :  "anim/carrot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("halloweenmoonmutable")	
		
------------------------------------------------	
草帽			预设: strawhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("strawhat")	
			inst.AnimState:SetBuild("hat_straw")	
			Anim路径 :  "anim/hat_straw.zip"	
 	
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
MISSING NAME			预设: underwater_salvageable		路径： [string "scripts/prefabs/underwater_salvageable.lua"]	
	Tags▼	
	{":", "_inventory", "underwater_salvageable", "NOBLOCK", "ignorewalkableplatforms", "notarget", "NOCLICK", "winchtarget"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flotsam_heavy")	
			inst.AnimState:SetBuild("flotsam_heavy")	
			Anim路径 :  "anim/flotsam_heavy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("winchtarget")	
		inst:AddComponent("treasuremarked")	
		
	使用的监听▼	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
------------------------------------------------	
贝壳堆			预设: shell_cluster		路径： [string "scripts/prefabs/shell_cluster.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "INLIMBO", "MINE_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("singingshell_cluster")	
			inst.AnimState:SetBuild("singingshell_cluster")	
			Anim路径 :  "anim/singingshell_cluster.zip"	
 	
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
鼹鼠洞			预设: molehill		路径： [string "scripts/prefabs/molehill.lua"]	
	Tags▼	
	{":", "inspectable", "_inventory", "DIG_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mole")	
			inst.AnimState:SetBuild("mole_build")	
			Anim路径 :  "anim/mole_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("spawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("inventory")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("worldsettingstimer")	
		
	使用的监听▼	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
------------------------------------------------	
鼹鼠			预设: mole		路径： [string "scripts/prefabs/mole.lua"]	
	Tags▼	
	{":", "_inventoryitem", "mole", "_health", "inspectable", "freezable", "stunnedbybomb", "idle", "whackable", "INLIMBO", "small_livestock", "noattack", "_inventory", "smallcreature", "notdrawable", "_combat", "canbetrapped", "locomotor", "prey", "cattoy", "show_spoilage", "cookable", "catfood", "ELEMENTAL_eater", "baitstealer", "animal", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mole")	
			inst.AnimState:SetBuild("mole_build")	
			Anim路径 :  "anim/mole_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("freezable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("health")	
		inst:AddComponent("inventory")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("onwenthome")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("molehill_dug_up")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
地精奶奶			预设: trinket_13		路径： [string "scripts/prefabs/trinkets.lua"]	
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
融化的迷你冰川			预设: rock_ice		路径： [string "scripts/prefabs/rock_ice.lua"]	
	Tags▼	
	{":", "inspectable", "frozen", "antlion_sinkhole_blocker", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ice_boulder")	
			inst.AnimState:SetBuild("ice_boulder")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("timer")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firemelt")	
		inst:ListenForEvent("stopfiremelt")	
------------------------------------------------	
MISSING NAME			预设: ice_puddle		路径： [string "scripts/prefabs/ice_puddle.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ice_puddle")	
			inst.AnimState:SetBuild("ice_puddle")	
			Anim路径 :  "anim/ice_puddle.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
公牛海带			预设: bullkelp_beachedroot		路径： [string "scripts/prefabs/bullkelp_beached.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bullkelp")	
			inst.AnimState:SetBuild("bullkelp")	
			Anim路径 :  "anim/bullkelp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
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
伏特羊			预设: lightninggoat		路径： [string "scripts/prefabs/lightninggoat.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "lightninggoat", "_combat", "locomotor", "nolight", "herdmember", "lightningrod", "animal", "saltlicker", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lightning_goat_build")	
			Anim路径 :  "anim/lightning_goat_basic.zip"	
 	
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
		inst:AddComponent("saltlicker")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("saltlick_placed")	
		inst:ListenForEvent("lightningstrike")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("spawnedforhunt")	
		inst:ListenForEvent("freeze")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
在呼唤我			预设: moon_altar_rock_glass		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("altar_glasspiece")	
			inst.AnimState:SetBuild("altar_glasspiece")	
			Anim路径 :  "anim/altar_glasspiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("calling_moon_relics")	
------------------------------------------------	
天体裂隙			预设: moon_fissure		路径： [string "scripts/prefabs/moon_fissure.lua"]	
	Tags▼	
	{":", "inspectable", "antlion_sinkhole_blocker", "workrepairable", "sanityaura", "repairable_moon_altar"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_fissure")	
			inst.AnimState:SetBuild("moon_fissure")	
			Anim路径 :  "anim/moon_fissure.zip"	
 	
	使用的组件▼	
		inst:AddComponent("repairable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: moon_fissure_fx		路径： [string "scripts/prefabs/moon_fissure.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_fissure_fx")	
			inst.AnimState:SetBuild("moon_fissure_fx")	
			Anim路径 :  "anim/moon_fissure_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
皮弗娄牛			预设: beefalo		路径： [string "scripts/prefabs/beefalo.lua"]	
	Tags▼	
	{":", "_writeable", "VEGGIE_eater", "trader", "_health", "inspectable", "freezable", "_named", "beefalo", "idle", "bearded", "domesticatable", "_combat", "locomotor", "has_beard", "nolight", "_follower", "brushable", "_hunger", "largecreature", "herdmember", "animal", "saltlicker", "sleeper", "ROUGHAGE_eater", "saddleable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo")	
			inst.AnimState:SetBuild("beefalo_build")	
			Anim路径 :  "anim/beefalo_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("saltlicker")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("follower")	
		inst:AddComponent("named")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("brushable")	
		inst:AddComponent("timer")	
		inst:AddComponent("beard")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("colourtweener")	
		inst:AddComponent("combat")	
		inst:AddComponent("rideable")	
		inst:AddComponent("leader")	
		inst:AddComponent("writeable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("markable_proxy")	
		inst:AddComponent("trader")	
		inst:AddComponent("hitchable")	
		inst:AddComponent("hunger")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("skinner_beefalo")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("domesticatable")	
		inst:AddComponent("drownable")	
		inst:AddComponent("beefalometrics")	
		inst:AddComponent("eater")	
		inst:AddComponent("uniqueid")	
		
	使用的监听▼	
		inst:ListenForEvent("refusedrider")	
		inst:ListenForEvent("beingridden")	
		inst:ListenForEvent("goneferal")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("healthdelta")	
		inst:ListenForEvent("obediencedelta")	
		inst:ListenForEvent("domesticated")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("riderchanged")	
		inst:ListenForEvent("onwenthome")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onclothingchanged")	
		inst:ListenForEvent("entermood")	
		inst:ListenForEvent("ridersleep")	
		inst:ListenForEvent("saltchange")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("freeze")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("leavemood")	
		inst:ListenForEvent("saltlick_placed")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("despawn")	
		inst:ListenForEvent("brushed")	
		inst:ListenForEvent("unhitch")	
		inst:ListenForEvent("hitchto")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("ms_respawnedfromghost")	
		inst:ListenForEvent("domesticationdelta")	
		inst:ListenForEvent("riderdoattackother")	
		inst:ListenForEvent("saddlechanged")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: writeable_classified		路径： [string "scripts/prefabs/writeable_classified.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
公牛海带			预设: bullkelp_plant		路径： [string "scripts/prefabs/bullkelp_plant.lua"]	
	Tags▼	
	{":", "inspectable", "kelp", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bullkelp")	
			inst.AnimState:SetBuild("bullkelp")	
			Anim路径 :  "anim/bullkelp.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: bullkelp_plant_leaves		路径： [string "scripts/prefabs/bullkelp_plant.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bullkelp_underwater")	
			inst.AnimState:SetBuild("bullkelp_underwater")	
			Anim路径 :  "anim/bullkelp_underwater.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
红蘑菇			预设: red_mushroom		路径： [string "scripts/prefabs/mushrooms.lua"]	
	Tags▼	
	{":", "inspectable", "DIG_workable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushrooms")	
			inst.AnimState:SetBuild("mushrooms")	
			Anim路径 :  "anim/mushrooms.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
可疑的月岩			预设: gargoyle_houndatk		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "inspectable", "gargoyle", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("sculpture_hound_moonrock_build")	
			Anim路径 :  "anim/sculpture_hound.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("hauntable")	
		
------------------------------------------------	
蜘蛛指环			预设: trinket_33		路径： [string "scripts/prefabs/trinkets.lua"]	
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
温泉			预设: hotspring		路径： [string "scripts/prefabs/hotspring.lua"]	
	Tags▼	
	{":", "inspectable", "FROMNUM", "watersource", "HASHEATER", "antlion_sinkhole_blocker", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crater_pool")	
			inst.AnimState:SetBuild("crater_pool")	
			Anim路径 :  "anim/crater_pool.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bathbombable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("watersource")	
		inst:AddComponent("heater")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
月亮石			预设: moonbase		路径： [string "scripts/prefabs/moonbase.lua"]	
	Tags▼	
	{":", "moonbase", "inspectable", "NPC_workable", "event_trigger", "repairable_moonrock", "antlion_sinkhole_blocker", "workrepairable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonbase")	
			inst.AnimState:SetBuild("moonbase")	
			Anim路径 :  "anim/moonbase.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("workable")	
		inst:AddComponent("moonbeastspawner")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("repairable")	
		inst:AddComponent("timer")	
		inst:AddComponent("pickable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: seastack_spawner_swell		路径： [string "scripts/prefabs/seastack.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
大理石柱			预设: marblepillar		路径： [string "scripts/prefabs/marblepillar.lua"]	
	Tags▼	
	{":", "inspectable", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marble_pillar")	
			inst.AnimState:SetBuild("marble_pillar")	
			Anim路径 :  "anim/marble_pillar.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
龙虾窝			预设: wobster_den		路径： [string "scripts/prefabs/wobster_den.lua"]	
	Tags▼	
	{":", "inspectable", "event_trigger", "MINE_workable", "ignorewalkableplatforms", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_den_build")	
			Anim路径 :  "anim/lobster_den.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
曼德拉草			预设: mandrake_planted		路径： [string "scripts/prefabs/mandrake_planted.lua"]	
	Tags▼	
	{":", "inspectable", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mandrake")	
			inst.AnimState:SetBuild("mandrake")	
			Anim路径 :  "anim/mandrake.zip"	
 	
	使用的组件▼	
		inst:AddComponent("pickable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
大理石树			预设: marbletree		路径： [string "scripts/prefabs/marbletree.lua"]	
	Tags▼	
	{":", "inspectable", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marble_trees")	
			inst.AnimState:SetBuild("marble_trees")	
			Anim路径 :  "anim/marble_trees.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
蝙蝠装饰			预设: halloween_ornament_2		路径： [string "scripts/prefabs/halloween_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "BURNABLE_fuel", "halloween_ornament"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_ornaments")	
			inst.AnimState:SetBuild("halloween_ornaments")	
			Anim路径 :  "anim/halloween_ornaments.zip"	
 	
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
犬骨			预设: houndbone		路径： [string "scripts/prefabs/houndbone.lua"]	
	Tags▼	
	{":", "bone", "inspectable", "HAMMER_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("hound_base")	
			Anim路径 :  "anim/hound_base.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
发条骑士			预设: knight		路径： [string "scripts/prefabs/knight.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "idle", "chess", "hostile", "_combat", "locomotor", "nolight", "_follower", "knight", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("knight")	
			inst.AnimState:SetBuild("knight_build")	
			Anim路径 :  "anim/knight.zip"	
 	
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
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
蜂蜜地块			预设: beequeenhive		路径： [string "scripts/prefabs/beequeenhive.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_queen_hive")	
			inst.AnimState:SetBuild("bee_queen_hive")	
			Anim路径 :  "anim/bee_queen_hive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("entitytracker")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
萤火虫			预设: fireflies		路径： [string "scripts/prefabs/fireflies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "firefly", "_stackable", "NOBLOCK", "NET_workable", "flying", "NOCLICK", "cattoyairborne", "CAVE_fuel"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fireflies")	
			inst.AnimState:SetBuild("fireflies")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("workable")	
		
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
邪恶花			预设: flower_evil		路径： [string "scripts/prefabs/flower_evil.lua"]	
	Tags▼	
	{":", "quickpick", "inspectable", "sanityaura", "canlight", "flower", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flowers_evil")	
			inst.AnimState:SetBuild("flowers_evil")	
			Anim路径 :  "anim/flowers_evil.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		
------------------------------------------------	
试金石			预设: resurrectionstone		路径： [string "scripts/prefabs/resurrectionstone.lua"]	
	Tags▼	
	{":", "inspectable", "resurrector", "antlion_sinkhole_blocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("resurrection_stone")	
			inst.AnimState:SetBuild("resurrection_stone")	
			Anim路径 :  "anim/resurrection_stone.zip"	
 	
	使用的组件▼	
		inst:AddComponent("cooldown")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("playeractivated")	
		inst:ListenForEvent("enablelightsdirty")	
		inst:ListenForEvent("playerdeactivated")	
		inst:ListenForEvent("activateresurrection")	
------------------------------------------------	
MISSING NAME			预设: spawnpoint_master		路径： [string "scripts/prefabs/spawnpoint_multiplayer.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
寄居蟹隐士			预设: hermitcrab		路径： [string "scripts/prefabs/hermitcrab.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "freezable", "RAW_eater", "_named", "idle", "_inventory", "strongstomach", "HORRIBLE_eater", "locomotor", "OMNI_eater", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("hermitcrab_build")	
			Anim路径 :  "anim/player_idles.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("friendlevels")	
		inst:AddComponent("teleportedoverride")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("talker")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("craftingstation")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("inventory")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("named")	
		inst:AddComponent("npc_talker")	
		inst:AddComponent("timer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("home_upgraded")	
		inst:ListenForEvent("CHEVO_starteddrying")	
		inst:ListenForEvent("moonfissurevent")	
		inst:ListenForEvent("CHEVO_lureplantdied")	
		inst:ListenForEvent("dancingplayer")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("CHEVO_growfrombutterfly")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("friend_task_complete")	
		inst:ListenForEvent("CHEVO_heavyobject_winched")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("CHEVO_fertilized")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("clocksegschanged")	
	SG = 有▼	
------------------------------------------------	
触手			预设: tentacle		路径： [string "scripts/prefabs/tentacle.lua"]	
	Tags▼	
	{":", "WORM_DANGER", "monster", "_health", "inspectable", "freezable", "wet", "invisible", "idle", "hostile", "_combat", "tentacle", "sanityaura"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tentacle")	
			inst.AnimState:SetBuild("tentacle")	
			Anim路径 :  "anim/tentacle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
青蛙			预设: frog		路径： [string "scripts/prefabs/frog.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "hostile", "smallcreature", "_combat", "canbetrapped", "locomotor", "prey", "frog", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("frog")	
			inst.AnimState:SetBuild("frog")	
			Anim路径 :  "anim/frog.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("thief")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("embarker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("onmissother")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("goinghome")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
	AI = 有▼	
------------------------------------------------	
蜂窝			预设: beehive		路径： [string "scripts/prefabs/beehive.lua"]	
	Tags▼	
	{":", "hive", "_health", "inspectable", "freezable", "_combat", "beehive", "canlight", "structure", "SnowCovered", "beaverchewable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beehive")	
			inst.AnimState:SetBuild("beehive")	
			Anim路径 :  "anim/beehive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("freezable")	
		inst:AddComponent("health")	
		inst:AddComponent("combat")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("onthaw")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("freeze")	
------------------------------------------------	
阿比盖尔之花			预设: abigail_flower		路径： [string "scripts/prefabs/abigail_flower.lua"]	
	Tags▼	
	{":", "_inventoryitem", "ghostlyelixirable", "inspectable", "abigail_flower", "INLIMBO", "give_dolongaction", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_flower_rework")	
			inst.AnimState:SetBuild("abigail_flower_rework")	
			Anim路径 :  "anim/abigail_flower_rework.zip"	
 	
	使用的组件▼	
		inst:AddComponent("ghostlyelixirable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("summoningitem")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("abiflowerskiniddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
浮木			预设: driftwood_small2		路径： [string "scripts/prefabs/driftwood_trees.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "plant", "CHOP_workable", "canlight", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("driftwood_small2")	
			inst.AnimState:SetBuild("driftwood_small2")	
			Anim路径 :  "anim/driftwood_small2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
阿比盖尔			预设: abigail		路径： [string "scripts/prefabs/abigail.lua"]	
	Tags▼	
	{":", "ghostlyelixirable", "busy", "notraptrigger", "trader", "_health", "inspectable", "INLIMBO", "noattack", "abigail", "ghost", "NOBLOCK", "_combat", "locomotor", "scarytoprey", "debuffable", "_follower", "flying", "character", "girl", "noauradamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ghost")	
			inst.AnimState:SetBuild("ghost_abigail_build")	
			Anim路径 :  "anim/player_ghost_withhat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("ghostlyelixirable")	
		inst:AddComponent("combat")	
		inst:AddComponent("debuffable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("aura")	
		inst:AddComponent("timer")	
		inst:AddComponent("follower")	
		
	使用的监听▼	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("ghostlybond_level_change")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onareaattackother")	
		inst:ListenForEvent("blocked")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
兔子			预设: rabbit		路径： [string "scripts/prefabs/rabbit.lua"]	
	Tags▼	
	{":", "_inventoryitem", "VEGGIE_eater", "_health", "inspectable", "freezable", "stunnedbybomb", "idle", "small_livestock", "smallcreature", "_combat", "canbetrapped", "locomotor", "sanityaura", "prey", "nolight", "rabbit", "cattoy", "show_spoilage", "cookable", "catfood", "animal", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rabbit")	
			inst.AnimState:SetBuild("rabbit_build")	
			Anim路径 :  "anim/ds_rabbit_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("tradable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("cookable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("onremove")	
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
月光玻璃			预设: moonglass_rock		路径： [string "scripts/prefabs/rocks.lua"]	
	Tags▼	
	{":", "inspectable", "moonglass", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_rock3")	
			inst.AnimState:SetBuild("moonglass_rock3")	
			Anim路径 :  "anim/moonglass_rock3.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
船碎片			预设: boatfragment04		路径： [string "scripts/prefabs/boatfragments.lua"]	
	Tags▼	
	{":", "inspectable", "wet", "HAMMER_workable", "canlight", "edible_WOOD", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_brokenparts_build")	
			Anim路径 :  "anim/boat_brokenparts.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
桦栗树			预设: deciduoustree		路径： [string "scripts/prefabs/deciduoustrees.lua"]	
	Tags▼	
	{":", "__combat", "deciduoustree", "tree", "birchnut", "plant", "CHOP_workable", "cattoyairborne", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("tree_leaf_trunk_build")	
			Anim路径 :  "anim/tree_leaf_short.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("plantregrowth")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("sway")	
		inst:ListenForEvent("timerdone")	
	SG = 有▼	
------------------------------------------------	
漏雨的小屋			预设: mermhouse		路径： [string "scripts/prefabs/mermhouse.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_house")	
			inst.AnimState:SetBuild("merm_house")	
			Anim路径 :  "anim/merm_house.zip"	
 	
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
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
尖刺灌木			预设: marsh_bush		路径： [string "scripts/prefabs/marsh_bush.lua"]	
	Tags▼	
	{":", "thorny", "inspectable", "plant", "DIG_workable", "canlight", "silviculture", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_bush")	
			inst.AnimState:SetBuild("marsh_bush")	
			Anim路径 :  "anim/marsh_bush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
地精爷爷			预设: trinket_4		路径： [string "scripts/prefabs/trinkets.lua"]	
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
船碎片			预设: boatfragment05		路径： [string "scripts/prefabs/boatfragments.lua"]	
	Tags▼	
	{":", "inspectable", "wet", "HAMMER_workable", "canlight", "edible_WOOD", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_brokenparts_build")	
			Anim路径 :  "anim/boat_brokenparts.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
海象营地			预设: walrus_camp		路径： [string "scripts/prefabs/walrus_camp.lua"]	
	Tags▼	
	{":", "inspectable", "antlion_sinkhole_blocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("igloo_track")	
			inst.AnimState:SetBuild("igloo_track")	
			Anim路径 :  "anim/igloo_track.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onwenthome")	
------------------------------------------------	
发条主教			预设: bishop		路径： [string "scripts/prefabs/bishop.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "idle", "chess", "_inventory", "hostile", "bishop", "_combat", "locomotor", "nolight", "_follower", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bishop")	
			inst.AnimState:SetBuild("bishop_build")	
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
------------------------------------------------	
大树根			预设: watertree_root		路径： [string "scripts/prefabs/watertree_root.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "CHOP_workable", "ignorewalkableplatforms", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("watertree_root")	
			inst.AnimState:SetBuild("watertree_root")	
			Anim路径 :  "anim/watertree_root.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("on_collide")	
------------------------------------------------	
浆果丛			预设: berrybush2		路径： [string "scripts/prefabs/berrybush.lua"]	
	Tags▼	
	{":", "bush", "inspectable", "renewable", "plant", "DIG_workable", "canlight", "witherable", "SnowCovered", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush2")	
			inst.AnimState:SetBuild("berrybush2")	
			Anim路径 :  "anim/berrybush2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("witherable")	
		
	使用的监听▼	
		inst:ListenForEvent("onwenthome")	
------------------------------------------------	
盐堆			预设: saltstack		路径： [string "scripts/prefabs/saltstack.lua"]	
	Tags▼	
	{":", "inspectable", "MINE_workable", "ignorewalkableplatforms", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("salt_pillar")	
			inst.AnimState:SetBuild("salt_pillar")	
			Anim路径 :  "anim/salt_pillar.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: dragonfly_spawner		路径： [string "scripts/prefabs/dragonfly_spawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("dragonflyengaged")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("ms_registerlavapond")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: antlion_spawner		路径： [string "scripts/prefabs/antlion_spawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("entitytracker")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_stormchanged")	
------------------------------------------------	
被堵住的洞穴			预设: cave_entrance		路径： [string "scripts/prefabs/cave_entrance.lua"]	
	Tags▼	
	{":", "inspectable", "CLASSIFIED", "antlion_sinkhole_blocker", "MINE_workable", "NOCLICK", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cave_entrance")	
			inst.AnimState:SetBuild("cave_entrance")	
			Anim路径 :  "anim/cave_entrance.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("worldmigrator")	
		
	使用的监听▼	
		inst:ListenForEvent("migration_activate_other")	
------------------------------------------------	
MISSING NAME			预设: wobster_den_spawner_shore		路径： [string "scripts/prefabs/wobster_den.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
不搭的纽扣			预设: trinket_9		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: crabking_spawner		路径： [string "scripts/prefabs/crabking_spawner.lua"]	
	Tags▼	
	{":", "crabking_spawner", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: hermitcrab_lure_marker		路径： [string "scripts/prefabs/hermitcrab.lua"]	
	Tags▼	
	{":", "NOBLOCK", "NOCLICK", "hermitcrab_lure_marker"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: hermitcrab_marker		路径： [string "scripts/prefabs/hermitcrab.lua"]	
	Tags▼	
	{":", "hermitcrab_marker", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
单只手套			预设: trinket_39		路径： [string "scripts/prefabs/trinkets.lua"]	
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
堵住的裂隙			预设: moon_fissure_plugged		路径： [string "scripts/prefabs/moon_fissure.lua"]	
	Tags▼	
	{":", "inspectable", "antlion_sinkhole_blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("plugged_fissure")	
			inst.AnimState:SetBuild("plugged_fissure")	
			Anim路径 :  "anim/plugged_fissure.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
岩石巢穴			预设: critterlab		路径： [string "scripts/prefabs/critterlab.lua"]	
	Tags▼	
	{":", "inspectable", "critterlab", "antlion_sinkhole_blocker", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("critterlab")	
			inst.AnimState:SetBuild("critterlab")	
			Anim路径 :  "anim/critterlab.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
------------------------------------------------	
疙瘩树			预设: oceantree		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "event_trigger", "tree", "plant", "CHOP_workable", "ignorewalkableplatforms", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_short")	
			inst.AnimState:SetBuild("oceantree_short")	
			Anim路径 :  "anim/oceantree_short.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("timer")	
		inst:AddComponent("waterphysics")	
		
	使用的监听▼	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: oceantree_ripples_short		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_short")	
			inst.AnimState:SetBuild("oceantree_short")	
			Anim路径 :  "anim/oceantree_short.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: oceantree_roots_short		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_short")	
			inst.AnimState:SetBuild("oceantree_short")	
			Anim路径 :  "anim/oceantree_short.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
岩石			预设: rock1		路径： [string "scripts/prefabs/rocks.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock")	
			inst.AnimState:SetBuild("rock")	
			Anim路径 :  "anim/rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
在呼唤我			预设: moon_altar_rock_seed		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("altar_seedpiece")	
			inst.AnimState:SetBuild("altar_seedpiece")	
			Anim路径 :  "anim/altar_seedpiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("calling_moon_relics")	
------------------------------------------------	
MISSING NAME			预设: burntground		路径： [string "scripts/prefabs/burntground.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("burntground")	
			inst.AnimState:SetBuild("burntground")	
			Anim路径 :  "anim/burntground.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
断桩			预设: trinket_37		路径： [string "scripts/prefabs/trinkets.lua"]	
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
眼骨			预设: chester_eyebone		路径： [string "scripts/prefabs/chester_eyebone.lua"]	
	Tags▼	
	{":", "_inventoryitem", "chester_eyebone", "inspectable", "nonpotatable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("chester_eyebone_build")	
			Anim路径 :  "anim/chester_eyebone.zip"	
 	
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
MISSING NAME			预设: oceanvine_deco		路径： [string "scripts/prefabs/oceanvine_deco.lua"]	
	Tags▼	
	{":", "NOBLOCK", "flying", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("waterforest_vines")	
			Anim路径 :  "anim/waterforest_vines.zip"	
 	
	使用的组件▼	
		inst:AddComponent("distancefade")	
		
------------------------------------------------	
针刺树			预设: marsh_tree		路径： [string "scripts/prefabs/marsh_tree.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "burnt", "plant", "CHOP_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_tree")	
			inst.AnimState:SetBuild("tree_marsh")	
			Anim路径 :  "anim/tree_marsh.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
坟墓			预设: mound		路径： [string "scripts/prefabs/mound.lua"]	
	Tags▼	
	{":", "inspectable", "grave", "DIG_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gravestone")	
			inst.AnimState:SetBuild("gravestones")	
			Anim路径 :  "anim/gravestones.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
排箫			预设: panflute		路径： [string "scripts/prefabs/panflute.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "PLAY_tool", "tool", "flute"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pan_flute")	
			inst.AnimState:SetBuild("pan_flute")	
			Anim路径 :  "anim/pan_flute.zip"	
 	
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
绿蘑菇			预设: green_mushroom		路径： [string "scripts/prefabs/mushrooms.lua"]	
	Tags▼	
	{":", "inspectable", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushrooms")	
			inst.AnimState:SetBuild("mushrooms")	
			Anim路径 :  "anim/mushrooms.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
树苗			预设: sapling_moon		路径： [string "scripts/prefabs/sapling.lua"]	
	Tags▼	
	{":", "inspectable", "renewable", "plant", "DIG_workable", "canlight", "witherable", "silviculture", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sapling_moon")	
			inst.AnimState:SetBuild("sapling_moon")	
			Anim路径 :  "anim/sapling_moon.zip"	
 	
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
MISSING NAME			预设: eyeflame		路径： [string "scripts/prefabs/eyeflame.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
う丶青木			预设: wendy		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "elixirbrewer", "_rider", "singingshelltrigger", "ghostlyfriend", "ghostfriend_notsummoned", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wendy")	
			Anim路径 :  "anim/player_idles_wendy.zip"	
 	
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
		inst:AddComponent("actionqueuer")	
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
		inst:AddComponent("pethealthbar")	
		inst:AddComponent("playermetrics")	
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
		inst:AddComponent("playerhearing")	
		inst:AddComponent("spooked")	
		inst:AddComponent("playervoter")	
		inst:AddComponent("playercontroller")	
		inst:AddComponent("playeractionpicker")	
		inst:AddComponent("ghostlybond")	
		inst:AddComponent("embarker")	
		inst:AddComponent("giftreceiver")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("touchstonetracker")	
		inst:AddComponent("petleash")	
		inst:AddComponent("areaaware")	
		inst:AddComponent("moonstormwatcher")	
		inst:AddComponent("playeravatardata")	
		inst:AddComponent("debuffable")	
		inst:AddComponent("grogginess")	
		inst:AddComponent("workmultiplier")	
		inst:AddComponent("rider")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("wisecracker")	
		inst:AddComponent("hudindicatorwatcher")	
		inst:AddComponent("birdattractor")	
		inst:AddComponent("attuner")	
		inst:AddComponent("bloomer")	
		
	使用的监听▼	
		inst:ListenForEvent("playerdied")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("startfreezing")	
		inst:ListenForEvent("continuefrompause")	
		inst:ListenForEvent("voteselectiondirty")	
		inst:ListenForEvent("mountwounded")	
		inst:ListenForEvent("actionfailed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("healthdelta")	
		inst:ListenForEvent("changearea")	
		inst:ListenForEvent("unequip")	
		inst:ListenForEvent("townportalteleport")	
		inst:ListenForEvent("stormlevel")	
		inst:ListenForEvent("buildstructure")	
		inst:ListenForEvent("digdiseasing")	
		inst:ListenForEvent("thorns")	
		inst:ListenForEvent("ghostdissipated")	
		inst:ListenForEvent("enableboatcamera")	
		inst:ListenForEvent("underleafcanopydirty")	
		inst:ListenForEvent("learncookbookrecipe")	
		inst:ListenForEvent("on_halloweenmoonpotion_failed")	
		inst:ListenForEvent("refreshflowertooltip")	
		inst:ListenForEvent("accomplishment_done")	
		inst:ListenForEvent("playeractivated")	
		inst:ListenForEvent("burnt")	
		inst:ListenForEvent("zoomcamera")	
		inst:ListenForEvent("sharksounddirty")	
		inst:ListenForEvent("respawnfromghost")	
		inst:ListenForEvent("unpinned")	
		inst:ListenForEvent("ms_becameghost")	
		inst:ListenForEvent("unregister_hudindicatable")	
		inst:ListenForEvent("ms_updategiftitems")	
		inst:ListenForEvent("repelled")	
		inst:ListenForEvent("foodbuffdetached")	
		inst:ListenForEvent("done_embark_movement")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("onareaattackother")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("enterlight")	
		inst:ListenForEvent("sheltered")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("localplayer._hermit_music")	
		inst:ListenForEvent("playerdeactivated")	
		inst:ListenForEvent("gotnewattunement")	
		inst:ListenForEvent("startsmallhealthregen")	
		inst:ListenForEvent("starthealthregen")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("gotnewitem")	
		inst:ListenForEvent("heargrue")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("enterdark")	
		inst:ListenForEvent("bufferedcastaoe")	
		inst:ListenForEvent("onstartedfire")	
		inst:ListenForEvent("takeoversizedpicture")	
		inst:ListenForEvent("nightvision")	
		inst:ListenForEvent("killed")	
		inst:ListenForEvent("onsisturnstatechanged")	
		inst:ListenForEvent("ms_respawnedfromghost")	
		inst:ListenForEvent("onchangecanopyzone")	
		inst:ListenForEvent("ghostdelta")	
		inst:ListenForEvent("learnfertilizer")	
		inst:ListenForEvent("unlockrecipe")	
		inst:ListenForEvent("setowner")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("learncookbookstats")	
		inst:ListenForEvent("lightningdamageavoided")	
		inst:ListenForEvent("unevengrounddetected")	
		inst:ListenForEvent("coveredinbees")	
		inst:ListenForEvent("startoverheating")	
		inst:ListenForEvent("itemranout")	
		inst:ListenForEvent("startfiredamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("working")	
		inst:ListenForEvent("wonteatfood")	
		inst:ListenForEvent("enablemovementprediction")	
		inst:ListenForEvent("dropitem")	
		inst:ListenForEvent("picksomething")	
		inst:ListenForEvent("snared")	
		inst:ListenForEvent("startcorrosivedebuff")	
		inst:ListenForEvent("invincibletoggle")	
		inst:ListenForEvent("accomplishment")	
		inst:ListenForEvent("resistedgrue")	
		inst:ListenForEvent("ms_closepopup")	
		inst:ListenForEvent("playerexited")	
		inst:ListenForEvent("wormholespit")	
		inst:ListenForEvent("makeplayerghost")	
		inst:ListenForEvent("inventoryfull")	
		inst:ListenForEvent("usedtouchstone")	
		inst:ListenForEvent("equip")	
		inst:ListenForEvent("localplayer._winters_feast_music")	
		inst:ListenForEvent("foodbuffattached")	
		inst:ListenForEvent("insufficientfertilizer")	
		inst:ListenForEvent("attackedbygrue")	
		inst:ListenForEvent("hungrybuild")	
		inst:ListenForEvent("encumberedwalking")	
		inst:ListenForEvent("on_standing_on_new_leak")	
		inst:ListenForEvent("huntlosttrail")	
		inst:ListenForEvent("onpresink")	
		inst:ListenForEvent("pickdiseasing")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("huntbeastnearby")	
		inst:ListenForEvent("attunementlost")	
		inst:ListenForEvent("clientpetskindirty")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("spooked")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("newactiveitem")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: player_classified		路径： [string "scripts/prefabs/player_classified.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("repair")	
		inst:ListenForEvent("morguedirty")	
		inst:ListenForEvent("hasinspirationbuffdirty")	
		inst:ListenForEvent("MapSpotRevealer.revealmapspot")	
		inst:ListenForEvent("MapExplorer.learnmap")	
		inst:ListenForEvent("carefulwalking")	
		inst:ListenForEvent("performaction")	
		inst:ListenForEvent("eater.feedincontainer")	
		inst:ListenForEvent("builder.damaged")	
		inst:ListenForEvent("actionfailed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("playerfadedirty")	
		inst:ListenForEvent("healthdelta")	
		inst:ListenForEvent("builditem")	
		inst:ListenForEvent("sanitydelta")	
		inst:ListenForEvent("consumehealthcost")	
		inst:ListenForEvent("makefriend")	
		inst:ListenForEvent("buildstructure")	
		inst:ListenForEvent("builder.build")	
		inst:ListenForEvent("houndwarning")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("yotbskindirty")	
		inst:ListenForEvent("ismounthurtdirty")	
		inst:ListenForEvent("play_theme_music")	
		inst:ListenForEvent("leader.makefriend")	
		inst:ListenForEvent("learnrecipe")	
		inst:ListenForEvent("repair.repair")	
		inst:ListenForEvent("werenessdelta")	
		inst:ListenForEvent("learnmap")	
		inst:ListenForEvent("startfarmingmusicevent")	
		inst:ListenForEvent("playercameradirty")	
		inst:ListenForEvent("wormholetraveldirty")	
		inst:ListenForEvent("playercamerasnap")	
		inst:ListenForEvent("houndwarningdirty")	
		inst:ListenForEvent("wormholetravel")	
		inst:ListenForEvent("giftsdirty")	
		inst:ListenForEvent("builder.learnrecipe")	
		inst:ListenForEvent("inked")	
		inst:ListenForEvent("feedincontainer")	
		inst:ListenForEvent("stormleveldirty")	
------------------------------------------------	
MISSING NAME			预设: inventory_classified		路径： [string "scripts/prefabs/inventory_classified.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
巨大蜂窝			预设: beequeenhivegrown		路径： [string "scripts/prefabs/beequeenhive.lua"]	
	Tags▼	
	{":", "inspectable", "event_trigger", "HAMMER_workable", "antlion_sinkhole_blocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_queen_hive")	
			inst.AnimState:SetBuild("bee_queen_hive")	
			Anim路径 :  "anim/bee_queen_hive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: deerspawningground		路径： [string "scripts/prefabs/deerspawningground.lua"]	
	Tags▼	
	{":", "deerspawningground", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
触手装饰			预设: halloween_ornament_4		路径： [string "scripts/prefabs/halloween_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "BURNABLE_fuel", "halloween_ornament"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_ornaments")	
			inst.AnimState:SetBuild("halloween_ornaments")	
			Anim路径 :  "anim/halloween_ornaments.zip"	
 	
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
大理石雕像			预设: sculpture_rookbody		路径： [string "scripts/prefabs/sculptures.lua"]	
	Tags▼	
	{":", "inspectable", "sculpture", "antlion_sinkhole_blocker", "statue", "MINE_workable", "chess_moonevent", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rook")	
			inst.AnimState:SetBuild("sculpture_rook")	
			Anim路径 :  "anim/sculpture_rook.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("shadowchessroar")	
------------------------------------------------	
黏液罐			预设: trinket_41		路径： [string "scripts/prefabs/trinkets.lua"]	
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
月岩			预设: moonrocknugget		路径： [string "scripts/prefabs/moonrocknugget.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_ELEMENTAL", "repairer", "health_moonrock", "work_moonrock"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonrocknugget")	
			inst.AnimState:SetBuild("moonrock_nugget")	
			Anim路径 :  "anim/moonrock_nugget.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("repairer")	
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
岩石			预设: rock_flintless		路径： [string "scripts/prefabs/rocks.lua"]	
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
草			预设: grass		路径： [string "scripts/prefabs/grass.lua"]	
	Tags▼	
	{":", "inspectable", "renewable", "plant", "DIG_workable", "canlight", "witherable", "silviculture", "pickable"}	
 	
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
蜂箱			预设: beebox_hermit		路径： [string "scripts/prefabs/beebox.lua"]	
	Tags▼	
	{":", "inspectable", "playerowned", "antlion_sinkhole_blocker", "structure", "beebox", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_box_hermitcrab")	
			inst.AnimState:SetBuild("bee_box_hermitcrab")	
			Anim路径 :  "anim/bee_box_hermitcrab.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("harvestable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("childgoinghome")	
		inst:ListenForEvent("enterlight")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("enterdark")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
岩石			预设: rock2		路径： [string "scripts/prefabs/rocks.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rock2")	
			inst.AnimState:SetBuild("rock2")	
			Anim路径 :  "anim/rock2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
高脚鸟			预设: tallbird		路径： [string "scripts/prefabs/tallbird.lua"]	
	Tags▼	
	{":", "busy", "tallbird", "_health", "inspectable", "freezable", "_combat", "locomotor", "OMNI_eater", "nolight", "largecreature", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tallbird")	
			inst.AnimState:SetBuild("DS_tallbird_basic")	
			Anim路径 :  "anim/ds_tallbird_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("eater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("leader")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
月亮石碎块			预设: moonrock_pieces		路径： [string "scripts/prefabs/moonrock_pieces.lua"]	
	Tags▼	
	{":", "inspectable", "MINE_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonrock_pieces")	
			inst.AnimState:SetBuild("moonrock_pieces")	
			Anim路径 :  "anim/moonrock_pieces.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
大树干			预设: watertree_pillar		路径： [string "scripts/prefabs/watertree_pillar.lua"]	
	Tags▼	
	{":", "lightningblocker", "inspectable", "cocoon_home", "shadecanopy", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_pillar")	
			inst.AnimState:SetBuild("oceantree_pillar_build1")	
			Anim路径 :  "anim/oceantree_pillar.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lightningblocker")	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("timer")	
		inst:AddComponent("distancefade")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("phasechanged")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("hascanopydirty")	
		inst:ListenForEvent("cocoon_destroyed")	
------------------------------------------------	
MISSING NAME			预设: watertree_pillar_ripples		路径： [string "scripts/prefabs/watertree_pillar.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_pillar")	
			inst.AnimState:SetBuild("oceantree_pillar_build1")	
			Anim路径 :  "anim/oceantree_pillar.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: watertree_pillar_roots		路径： [string "scripts/prefabs/watertree_pillar.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_pillar")	
			inst.AnimState:SetBuild("oceantree_pillar_build1")	
			Anim路径 :  "anim/oceantree_pillar.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蓝蘑菇			预设: blue_mushroom		路径： [string "scripts/prefabs/mushrooms.lua"]	
	Tags▼	
	{":", "inspectable", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushrooms")	
			inst.AnimState:SetBuild("mushrooms")	
			Anim路径 :  "anim/mushrooms.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
芦苇			预设: reeds		路径： [string "scripts/prefabs/reeds.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "BURNABLE_fuel", "canlight", "silviculture", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grass")	
			inst.AnimState:SetBuild("reeds")	
			Anim路径 :  "anim/grass.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
双筒望远镜			预设: trinket_38		路径： [string "scripts/prefabs/trinkets.lua"]	
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
南瓜			预设: pumpkin		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
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
鱼人			预设: merm		路径： [string "scripts/prefabs/merm.lua"]	
	Tags▼	
	{":", "merm", "trader", "_health", "inspectable", "freezable", "wet", "idle", "_inventory", "_combat", "locomotor", "nolight", "_follower", "character", "sleeper", "VEGETARIAN_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("merm_build")	
			Anim路径 :  "anim/ds_pig_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
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
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onmermkingdestroyed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onmermkingcreated")	
		inst:ListenForEvent("newcombattarget")	
	SG = 有▼	
------------------------------------------------	
蜗牛秤			预设: trinket_40		路径： [string "scripts/prefabs/trinkets.lua"]	
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
高脚鸟巢			预设: tallbirdnest		路径： [string "scripts/prefabs/tallbirdnest.lua"]	
	Tags▼	
	{":", "inspectable", "antlion_sinkhole_blocker", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("egg")	
			inst.AnimState:SetBuild("tallbird_egg")	
			Anim路径 :  "anim/tallbird_egg.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
树苗			预设: sapling		路径： [string "scripts/prefabs/sapling.lua"]	
	Tags▼	
	{":", "inspectable", "renewable", "plant", "halloweenmoonmutable", "DIG_workable", "canlight", "witherable", "silviculture", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sapling")	
			inst.AnimState:SetBuild("sapling")	
			Anim路径 :  "anim/sapling.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("halloweenmoonmutable")	
		inst:AddComponent("witherable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("pickable")	
		
------------------------------------------------	
MISSING NAME			预设: buzzardspawner		路径： [string "scripts/prefabs/buzzardspawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED", "buzzardspawner"}	
 	
	使用的组件▼	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
MISSING NAME			预设: circlingbuzzard		路径： [string "scripts/prefabs/buzzardspawner.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("buzzard")	
			inst.AnimState:SetBuild("buzzard_build")	
			Anim路径 :  "anim/buzzard_shadow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("circler")	
		
------------------------------------------------	
红雀			预设: robin		路径： [string "scripts/prefabs/birds.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "_health", "inspectable", "SEEDS_eater", "freezable", "stunnedbybomb", "idle", "small_livestock", "smallcreature", "_combat", "locomotor", "nolight", "robin", "show_spoilage", "cookable", "likewateroffducksback", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crow")	
			inst.AnimState:SetBuild("robin_build")	
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
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("threatnear")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("gohome")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
	AI = 有▼	
------------------------------------------------	
蝴蝶			预设: butterfly		路径： [string "scripts/prefabs/butterfly.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "_health", "inspectable", "wildfireprotected", "butterfly", "freezable", "idle", "insect", "small_livestock", "pollinator", "smallcreature", "_stackable", "_combat", "locomotor", "NET_workable", "OMNI_eater", "nolight", "halloweenmoonmutable", "flying", "show_spoilage", "cattoyairborne", "deployable", "ignorewalkableplatformdrowning", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("butterfly")	
			inst.AnimState:SetBuild("butterfly_basic")	
			Anim路径 :  "anim/butterfly_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("halloweenmoonmutable")	
		inst:AddComponent("workable")	
		inst:AddComponent("eater")	
		inst:AddComponent("deployable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("tradable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pollinator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
	AI = 有▼	
------------------------------------------------	
空心树桩			预设: catcoonden		路径： [string "scripts/prefabs/catcoonden.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "catcoonden", "canlight", "structure", "SnowCovered", "beaverchewable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("catcoon_den")	
			inst.AnimState:SetBuild("catcoon_den")	
			Anim路径 :  "anim/catcoon_den.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
石果灌木丛			预设: rock_avocado_bush		路径： [string "scripts/prefabs/rock_avocado_bush.lua"]	
	Tags▼	
	{":", "inspectable", "renewable", "plant", "DIG_workable", "canlight", "witherable", "SnowCovered", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_build")	
			Anim路径 :  "anim/rock_avocado.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("witherable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		
------------------------------------------------	
大理石			预设: marble		路径： [string "scripts/prefabs/inv_marble.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "quakedebris"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marble")	
			inst.AnimState:SetBuild("marble")	
			Anim路径 :  "anim/marble.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
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
燧石			预设: flint		路径： [string "scripts/prefabs/flint.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "quakedebris", "renewable", "edible_ELEMENTAL"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flint")	
			inst.AnimState:SetBuild("flint")	
			Anim路径 :  "anim/flint.zip"	
 	
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
海黾巢穴			预设: oceanvine_cocoon		路径： [string "scripts/prefabs/oceanvine_cocoon.lua"]	
	Tags▼	
	{":", "webbed", "_health", "inspectable", "freezable", "NOBLOCK", "_combat", "plant", "canlight", "flying", "ignorewalkableplatform", "spidercocoon", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanvine_cocoon")	
			Anim路径 :  "anim/oceanvine_cocoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("distancefade")	
		inst:AddComponent("propagator")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("onthaw")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("activated")	
		inst:ListenForEvent("freeze")	
------------------------------------------------	
海骨			预设: dead_sea_bones		路径： [string "scripts/prefabs/dead_sea_bones.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fishbones")	
			inst.AnimState:SetBuild("fishbones")	
			Anim路径 :  "anim/fishbones.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
月树花			预设: moon_tree_blossom		路径： [string "scripts/prefabs/moontree_blossom.lua"]	
	Tags▼	
	{":", "_inventoryitem", "vasedecoration", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moon_tree_petal")	
			inst.AnimState:SetBuild("moon_tree_petal")	
			Anim路径 :  "anim/moon_tree_petal.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
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
猪屋			预设: pighouse		路径： [string "scripts/prefabs/pighouse.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pig_house")	
			inst.AnimState:SetBuild("pig_house")	
			Anim路径 :  "anim/pig_house.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("spawner")	
		inst:AddComponent("burnable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
尖刺灌木			预设: burnt_marsh_bush		路径： [string "scripts/prefabs/marsh_bush.lua"]	
	Tags▼	
	{":", "thorny", "inspectable", "burnt", "plant", "quickactivation", "inactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_bush")	
			inst.AnimState:SetBuild("marsh_bush")	
			Anim路径 :  "anim/marsh_bush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("activatable")	
		
------------------------------------------------	
浮木桩			预设: driftwood_log		路径： [string "scripts/prefabs/driftwood.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "health_wood", "waterproofer", "BURNABLE_fuel", "canlight", "repairer", "edible_WOOD"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("driftwood_log")	
			inst.AnimState:SetBuild("driftwood_log")	
			Anim路径 :  "anim/driftwood_log.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("burnable")	
		
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
晾肉架			预设: meatrack_hermit		路径： [string "scripts/prefabs/meatrack.lua"]	
	Tags▼	
	{":", "inspectable", "candry", "antlion_sinkhole_blocker", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meatrack_hermit")	
			inst.AnimState:SetBuild("meatrack_hermit")	
			Anim路径 :  "anim/meatrack_hermit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("dryer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
空的长生不老药			预设: trinket_35		路径： [string "scripts/prefabs/trinkets.lua"]	
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
方尖碑			预设: sanityrock		路径： [string "scripts/prefabs/nightmarerock.lua"]	
	Tags▼	
	{":", "inspectable", "idle", "antlion_sinkhole_blocker", "sanityrock", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blocker_sanity")	
			inst.AnimState:SetBuild("blocker_sanity")	
			Anim路径 :  "anim/blocker_sanity.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onispathfindingdirty")	
	SG = 有▼	
------------------------------------------------	
瓦伦斯			预设: pigguard		路径： [string "scripts/prefabs/pigman.lua"]	
	Tags▼	
	{":", "trader", "_health", "inspectable", "freezable", "pig", "RAW_eater", "_named", "idle", "_inventory", "strongstomach", "HORRIBLE_eater", "_combat", "locomotor", "OMNI_eater", "sanityaura", "scarytoprey", "nolight", "_follower", "guard", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("pig_guard_build")	
			Anim路径 :  "anim/ds_pig_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("werebeast")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("named")	
		inst:AddComponent("talker")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("inventory")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onvacatehome")	
		inst:ListenForEvent("itemlose")	
	SG = 有▼	
------------------------------------------------	
奇怪的收音机			预设: trinket_45		路径： [string "scripts/prefabs/trinkets.lua"]	
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
蜘蛛装饰			预设: halloween_ornament_3		路径： [string "scripts/prefabs/halloween_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "BURNABLE_fuel", "halloween_ornament"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_ornaments")	
			inst.AnimState:SetBuild("halloween_ornaments")	
			Anim路径 :  "anim/halloween_ornaments.zip"	
 	
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
草席卷			预设: bedroll_straw		路径： [string "scripts/prefabs/bedroll.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("swap_bedroll_straw")	
			inst.AnimState:SetBuild("swap_bedroll_straw")	
			Anim路径 :  "anim/swap_bedroll_straw.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("sleepingbag")	
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
沙拉蝾螈			预设: fruitdragon		路径： [string "scripts/prefabs/fruitdragon.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "smallcreature", "_combat", "locomotor", "scarytoprey", "animal", "sleeper", "fruitdragon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("fruit_dragon_build")	
			Anim路径 :  "anim/fruit_dragon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("timer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("lostfruitdragonchallenge")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("doattack")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("blocked")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
猪头			预设: pighead		路径： [string "scripts/prefabs/stickheads.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "beaverchewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pig_head")	
			inst.AnimState:SetBuild("pig_head")	
			Anim路径 :  "anim/pig_head.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
MISSING NAME			预设: flies		路径： [string "scripts/prefabs/flies.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flies")	
			inst.AnimState:SetBuild("flies")	
			Anim路径 :  "anim/flies.zip"	
 	
	使用的组件▼	
		inst:AddComponent("playerprox")	
		
------------------------------------------------	
猪火炬			预设: pigtorch		路径： [string "scripts/prefabs/pigtorch.lua"]	
	Tags▼	
	{":", "inspectable", "wildfireprotected", "HAMMER_workable", "nolight", "fire", "PIGTORCH_fueled", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigtorch")	
			inst.AnimState:SetBuild("pig_torch")	
			Anim路径 :  "anim/pig_torch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("spawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		
	使用的监听▼	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: pigtorch_flame		路径： [string "scripts/prefabs/pigtorch_flame.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("campfire_fire")	
			inst.AnimState:SetBuild("campfire_fire")	
			Anim路径 :  "anim/campfire_fire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("firefx")	
		
------------------------------------------------	
MISSING NAME			预设: firefx_light		路径： [string "scripts/prefabs/firefx_light.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
金块			预设: goldnugget		路径： [string "scripts/prefabs/goldnugget.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "quakedebris", "edible_ELEMENTAL", "minigameitem"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goldnugget")	
			inst.AnimState:SetBuild("gold_nugget")	
			Anim路径 :  "anim/gold_nugget.zip"	
 	
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
月亮碎片			预设: moonglass		路径： [string "scripts/prefabs/moonglass.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "moonglass_piece", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass")	
			inst.AnimState:SetBuild("moonglass")	
			Anim路径 :  "anim/moonglass.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
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
世界			预设: world		路径： [string "scripts/prefabs/world.lua"]	
	Tags▼	
	{":", "CLASSIFIED", "forest", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("squidspawner")	
		inst:AddComponent("yotc_raceprizemanager")	
		inst:AddComponent("shadowhandspawner")	
		inst:AddComponent("colourcube")	
		inst:AddComponent("dsp")	
		inst:AddComponent("birdspawner")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("shadowcreaturespawner")	
		inst:AddComponent("specialeventsetup")	
		inst:AddComponent("retrofitforestmap_anr")	
		inst:AddComponent("deerherdspawner")	
		inst:AddComponent("hounded")	
		inst:AddComponent("wildfires")	
		inst:AddComponent("skeletonsweeper")	
		inst:AddComponent("brightmarespawner")	
		inst:AddComponent("sandstorms")	
		inst:AddComponent("dynamicmusic")	
		inst:AddComponent("carnivalevent")	
		inst:AddComponent("groundcreep")	
		inst:AddComponent("butterflyspawner")	
		inst:AddComponent("worldmeteorshower")	
		inst:AddComponent("feasts")	
		inst:AddComponent("worlddeciduoustreeupdater")	
		inst:AddComponent("mermkingmanager")	
		inst:AddComponent("regrowthmanager")	
		inst:AddComponent("klaussackloot")	
		inst:AddComponent("nutrients_visual_manager")	
		inst:AddComponent("lureplantspawner")	
		inst:AddComponent("worldstate")	
		inst:AddComponent("yotb_stagemanager")	
		inst:AddComponent("hudindicatablemanager")	
		inst:AddComponent("desolationspawner")	
		inst:AddComponent("ambientlighting")	
		inst:AddComponent("hunter")	
		inst:AddComponent("forestresourcespawner")	
		inst:AddComponent("moosespawner")	
		inst:AddComponent("worldwind")	
		inst:AddComponent("beargerspawner")	
		inst:AddComponent("walkableplatformmanager")	
		inst:AddComponent("deerherding")	
		inst:AddComponent("flotsamgenerator")	
		inst:AddComponent("uniqueprefabids")	
		inst:AddComponent("moonstormmanager")	
		inst:AddComponent("moonstormlightningmanager")	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("penguinspawner")	
		inst:AddComponent("worldoverseer")	
		inst:AddComponent("sharklistener")	
		inst:AddComponent("wavemanager")	
		inst:AddComponent("klaussackspawner")	
		inst:AddComponent("chessunlocks")	
		inst:AddComponent("playerspawner")	
		inst:AddComponent("messagebottlemanager")	
		inst:AddComponent("townportalregistry")	
		inst:AddComponent("oceancolor")	
		inst:AddComponent("crabkingspawner")	
		inst:AddComponent("malbatrossspawner")	
		inst:AddComponent("ambientsound")	
		inst:AddComponent("hallucinations")	
		inst:AddComponent("timer")	
		inst:AddComponent("deerclopsspawner")	
		inst:AddComponent("forestpetrification")	
		inst:AddComponent("farming_manager")	
		inst:AddComponent("frograin")	
		inst:AddComponent("kramped")	
		inst:AddComponent("schoolspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("goinsane")	
		inst:ListenForEvent("clocktick")	
		inst:ListenForEvent("ms_registerpetrifiable")	
		inst:ListenForEvent("ms_unregistersoildrinker")	
		inst:ListenForEvent("temperaturetick")	
		inst:ListenForEvent("phasechanged")	
		inst:ListenForEvent("ms_registerklaussack")	
		inst:ListenForEvent("wargshrinedeactivated")	
		inst:ListenForEvent("unequipskinneditem")	
		inst:ListenForEvent("ms_registerspawnpoint")	
		inst:ListenForEvent("screenflash")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("nightmareclocktick")	
		inst:ListenForEvent("ms_stopthemoonstorms")	
		inst:ListenForEvent("ms_playerdespawnanddelete")	
		inst:ListenForEvent("hasslerkilled")	
		inst:ListenForEvent("builditem")	
		inst:ListenForEvent("ms_playerdespawn")	
		inst:ListenForEvent("sanitymodechanged")	
		inst:ListenForEvent("equipskinneditem")	
		inst:ListenForEvent("snowcoveredchanged")	
		inst:ListenForEvent("changeclothes")	
		inst:ListenForEvent("ms_playerdespawnandmigrate")	
		inst:ListenForEvent("buildstructure")	
		inst:ListenForEvent("ms_skeletonspawn")	
		inst:ListenForEvent("cycleschanged")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("inducedinsanity")	
		inst:ListenForEvent("townportaldeactivated")	
		inst:ListenForEvent("ms_registerfishshoal")	
		inst:ListenForEvent("stormlevel")	
		inst:ListenForEvent("sharkspawned")	
		inst:ListenForEvent("unpausehounded")	
		inst:ListenForEvent("nutrientsvision")	
		inst:ListenForEvent("seasontick")	
		inst:ListenForEvent("yotb_oncontestfinshed")	
		inst:ListenForEvent("beargerremoved")	
		inst:ListenForEvent("ms_startthemoonstorms")	
		inst:ListenForEvent("playeractivated")	
		inst:ListenForEvent("ms_playerspawn")	
		inst:ListenForEvent("ms_exchangeshadowcreature")	
		inst:ListenForEvent("sanitydelta")	
		inst:ListenForEvent("beargerkilled")	
		inst:ListenForEvent("killed")	
		inst:ListenForEvent("ms_forcenaughtiness")	
		inst:ListenForEvent("ms_fruitflyspawneractive")	
		inst:ListenForEvent("wargshrineactivated")	
		inst:ListenForEvent("playcarnivalmusic")	
		inst:ListenForEvent("ms_restoreklaussackkey")	
		inst:ListenForEvent("ms_registertownportal")	
		inst:ListenForEvent("playfarmingmusic")	
		inst:ListenForEvent("playtrainingmusic")	
		inst:ListenForEvent("nightmarephasechanged")	
		inst:ListenForEvent("ms_unregisterpetrifiable")	
		inst:ListenForEvent("playhermitmusic")	
		inst:ListenForEvent("feasterstarted")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onterraform")	
		inst:ListenForEvent("playboatmusic")	
		inst:ListenForEvent("triggeredevent")	
		inst:ListenForEvent("ms_cyclecomplete")	
		inst:ListenForEvent("ms_setspawnmode")	
		inst:ListenForEvent("yotb_onabortcontest")	
		inst:ListenForEvent("precipitationchanged")	
		inst:ListenForEvent("ms_shoalfishhooked")	
		inst:ListenForEvent("malbatrosskilled")	
		inst:ListenForEvent("ms_oncroprotted")	
		inst:ListenForEvent("ms_registerdeerspawningground")	
		inst:ListenForEvent("goenlightened")	
		inst:ListenForEvent("performaction")	
		inst:ListenForEvent("nightvision")	
		inst:ListenForEvent("ms_playerleft")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("wetchanged")	
		inst:ListenForEvent("buildsuccess")	
		inst:ListenForEvent("hasslerremoved")	
		inst:ListenForEvent("pausehounded")	
		inst:ListenForEvent("gotnewitem")	
		inst:ListenForEvent("moonphasestylechanged")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("ms_unlockchesspiece")	
		inst:ListenForEvent("ms_registermigrationportal")	
		inst:ListenForEvent("overrideambientlighting")	
		inst:ListenForEvent("onthronedestroyed")	
		inst:ListenForEvent("oncandidatekingarrived")	
		inst:ListenForEvent("serverpauseddirty")	
		inst:ListenForEvent("ms_registersoildrinker")	
		inst:ListenForEvent("ccphasefn")	
		inst:ListenForEvent("enabledynamicmusic")	
		inst:ListenForEvent("isfeasting")	
		inst:ListenForEvent("playerdeactivated")	
		inst:ListenForEvent("weathertick")	
		inst:ListenForEvent("ccoverrides")	
		inst:ListenForEvent("yotb_onstagebuilt")	
		inst:ListenForEvent("moonphasechanged2")	
		inst:ListenForEvent("feasterfinished")	
		inst:ListenForEvent("playracemusic")	
		inst:ListenForEvent("storehassler")	
		inst:ListenForEvent("hounded_setdifficulty")	
		inst:ListenForEvent("townportalactivated")	
		inst:ListenForEvent("malbatrossremoved")	
		inst:ListenForEvent("onthronebuilt")	
		inst:ListenForEvent("ms_registeroasis")	
		inst:ListenForEvent("pushdsp")	
		inst:ListenForEvent("messagebottletreasure_marker_added")	
		inst:ListenForEvent("hasinspirationbuff")	
		inst:ListenForEvent("beginregrowth")	
		inst:ListenForEvent("ms_enableresourcerenewal")	
		inst:ListenForEvent("continuefrompause")	
		inst:ListenForEvent("overridecolourmodifier")	
		inst:ListenForEvent("ms_playerjoined")	
		inst:ListenForEvent("seasonlengthschanged")	
		inst:ListenForEvent("ms_lightwildfireforplayer")	
		inst:ListenForEvent("setambientsounddaytime")	
		inst:ListenForEvent("ms_lordfruitflykilled")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("popdsp")	
		inst:ListenForEvent("messagebottletreasure_marker_removed")	
		inst:ListenForEvent("ms_enableskeletonsweeper")	
		inst:ListenForEvent("ms_setpenguinnumboulders")	
		inst:ListenForEvent("overridecolourcube")	
		inst:ListenForEvent("moonstorm_nodes_dirty_relay")	
		inst:ListenForEvent("moistureceilchanged")	
		inst:ListenForEvent("overrideambientsound")	
------------------------------------------------	
MISSING NAME			预设: minimap		路径： [string "scripts/prefabs/minimap.lua"]	
	Tags▼	
	{":", "minimap"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: focalpoint		路径： [string "scripts/prefabs/focalpoint.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("focalpoint")	
		
	使用的监听▼	
		inst:ListenForEvent("playeractivated")	
		inst:ListenForEvent("playerdeactivated")	
------------------------------------------------	
MISSING NAME			预设: mist		路径： [string "scripts/prefabs/mistparticle.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		inst:AddComponent("emitter")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: forest_network		路径： [string "scripts/prefabs/world_network.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("shardstate")	
		inst:AddComponent("seasons")	
		inst:AddComponent("worldreset")	
		inst:AddComponent("worldvoter")	
		inst:AddComponent("moonstorms")	
		inst:AddComponent("clock")	
		inst:AddComponent("weather")	
		inst:AddComponent("autosaver")	
		inst:AddComponent("worldtemperature")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_advanceseason")	
		inst:ListenForEvent("clocktick")	
		inst:ListenForEvent("ms_setmoonphasestyle")	
		inst:ListenForEvent("ms_setsnowlevel")	
		inst:ListenForEvent("ms_deltamoistureceil")	
		inst:ListenForEvent("ms_newmastersessionid")	
		inst:ListenForEvent("temperaturetick")	
		inst:ListenForEvent("phasechanged")	
		inst:ListenForEvent("ms_setseasonlength")	
		inst:ListenForEvent("ms_playerleft")	
		inst:ListenForEvent("moonphasedirty")	
		inst:ListenForEvent("ms_forceprecipitation")	
		inst:ListenForEvent("ms_playercounts")	
		inst:ListenForEvent("ms_setseasonclocksegs")	
		inst:ListenForEvent("ms_receivevote")	
		inst:ListenForEvent("ms_simunpaused")	
		inst:ListenForEvent("ms_setmoonphase")	
		inst:ListenForEvent("entercharacterselect")	
		inst:ListenForEvent("moonstorm_nodes_dirty")	
		inst:ListenForEvent("ms_sendlightningstrike")	
		inst:ListenForEvent("ms_setlightningdelay")	
		inst:ListenForEvent("moistureceildirty")	
		inst:ListenForEvent("playerdeactivated")	
		inst:ListenForEvent("ms_setlightningmode")	
		inst:ListenForEvent("ms_deltamoisture")	
		inst:ListenForEvent("ms_setphase")	
		inst:ListenForEvent("ms_deltawetness")	
		inst:ListenForEvent("ms_setmoisturescale")	
		inst:ListenForEvent("ms_setprecipitationmode")	
		inst:ListenForEvent("ms_retreatseason")	
		inst:ListenForEvent("seasontick")	
		inst:ListenForEvent("ms_lockmoonphase")	
		inst:ListenForEvent("ms_save")	
		inst:ListenForEvent("ms_setseasonsegmodifier")	
		inst:ListenForEvent("ms_nextcycle")	
		inst:ListenForEvent("preciptypedirty")	
		inst:ListenForEvent("wetdirty")	
		inst:ListenForEvent("snowcovereddirty")	
		inst:ListenForEvent("ms_nextphase")	
		inst:ListenForEvent("ms_stopvote")	
		inst:ListenForEvent("lengthsdirty")	
		inst:ListenForEvent("playeractivated")	
		inst:ListenForEvent("ms_playerjoined")	
		inst:ListenForEvent("cyclesdirty")	
		inst:ListenForEvent("ms_setworldresettime")	
		inst:ListenForEvent("ms_cyclecomplete")	
		inst:ListenForEvent("countdowndirty")	
		inst:ListenForEvent("ms_setseason")	
		inst:ListenForEvent("phasedirty")	
		inst:ListenForEvent("moonphasestyledirty")	
		inst:ListenForEvent("seasondirty")	
		inst:ListenForEvent("ms_startvote")	
		inst:ListenForEvent("ms_setclocksegs")	
		inst:ListenForEvent("ms_setautosaveenabled")	
		inst:ListenForEvent("segsdirty")	
		inst:ListenForEvent("issavingdirty")	
------------------------------------------------	
短路			预设: rain		路径： [string "scripts/prefabs/rain.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: snow		路径： [string "scripts/prefabs/snow.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: pollen		路径： [string "scripts/prefabs/pollen.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: shard_network		路径： [string "scripts/prefabs/shard_network.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("shard_clock")	
		inst:AddComponent("shard_seasons")	
		inst:AddComponent("shard_worldreset")	
		inst:AddComponent("shard_sinkholes")	
		inst:AddComponent("shard_autosaver")	
		inst:AddComponent("shard_players")	
		inst:AddComponent("shard_worldvoter")	
		
	使用的监听▼	
		inst:ListenForEvent("master_clockupdate")	
		inst:ListenForEvent("master_worldresetupdate")	
		inst:ListenForEvent("master_worldvotersquelchedupdate")	
		inst:ListenForEvent("ms_respawnedfromghost")	
		inst:ListenForEvent("ms_becameghost")	
		inst:ListenForEvent("master_secondaryplayerschanged")	
		inst:ListenForEvent("master_autosaverupdate")	
		inst:ListenForEvent("master_worldvoterupdate")	
		inst:ListenForEvent("master_seasonsupdate")	
		inst:ListenForEvent("ms_playerspawn")	
		inst:ListenForEvent("playercountsdirty")	
		inst:ListenForEvent("master_sinkholesupdate")	
		inst:ListenForEvent("ms_playerleft")	
		inst:ListenForEvent("master_worldvoterenabled")	
------------------------------------------------	
幽灵装饰			预设: halloween_ornament_1		路径： [string "scripts/prefabs/halloween_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "BURNABLE_fuel", "halloween_ornament"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_ornaments")	
			inst.AnimState:SetBuild("halloween_ornaments")	
			Anim路径 :  "anim/halloween_ornaments.zip"	
 	
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
中音贝壳钟			预设: singingshell_octave4		路径： [string "scripts/prefabs/singingshell.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "cancycle", "HAMMER_workable", "singingshell"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("singingshell")	
			inst.AnimState:SetBuild("singingshell")	
			Anim路径 :  "anim/singingshell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("workable")	
		inst:AddComponent("cyclable")	
		inst:AddComponent("lootdropper")	
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
完全正常的树			预设: livingtree_halloween		路径： [string "scripts/prefabs/livingtree_halloween.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "tree", "fridge", "plant", "sanityaura", "CHOP_workable", "canlight", "decoratable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_living_wood_growable")	
			inst.AnimState:SetBuild("evergreen_living_wood_growable")	
			Anim路径 :  "anim/evergreen_living_wood_growable.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("eyeflamesdirty")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
MISSING NAME			预设: container_classified		路径： [string "scripts/prefabs/container_classified.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蜘蛛巢			预设: spiderden		路径： [string "scripts/prefabs/spiderden.lua"]	
	Tags▼	
	{":", "hive", "cavedweller", "_health", "inspectable", "freezable", "bearded", "spiderden", "hostile", "spider_upgradeable", "_combat", "bedazzleable", "canlight", "structure", "SnowCovered", "beaverchewable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_cocoon")	
			inst.AnimState:SetBuild("spider_cocoon")	
			Anim路径 :  "anim/spider_cocoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("bedazzlement")	
		inst:AddComponent("upgradeable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("shaveable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("propagator")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("combat")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("creepactivate")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("onthaw")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("freeze")	
------------------------------------------------	
发条战车			预设: rook		路径： [string "scripts/prefabs/rook.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "idle", "chess", "_inventory", "hostile", "_combat", "locomotor", "nolight", "_follower", "largecreature", "sleeper", "rook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rook")	
			inst.AnimState:SetBuild("rook_build")	
			Anim路径 :  "anim/rook.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("hauntable")	
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
------------------------------------------------	
胡萝卜			预设: carrat_planted		路径： [string "scripts/prefabs/carrat.lua"]	
	Tags▼	
	{":", "inspectable", "DIG_workable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carrat")	
			inst.AnimState:SetBuild("carrat_build")	
			Anim路径 :  "anim/carrat_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
池塘			预设: pond_mos		路径： [string "scripts/prefabs/pond.lua"]	
	Tags▼	
	{":", "inspectable", "watersource", "fishable", "antlion_sinkhole_blocker", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_tile")	
			inst.AnimState:SetBuild("marsh_tile")	
			Anim路径 :  "anim/marsh_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("fishable")	
		inst:AddComponent("watersource")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
大理石雕像			预设: statue_marble		路径： [string "scripts/prefabs/statue_marble.lua"]	
	Tags▼	
	{":", "inspectable", "statue", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("statue_small")	
			inst.AnimState:SetBuild("statue_small")	
			Anim路径 :  "anim/statue_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
立方氧化锆球			预设: trinket_32		路径： [string "scripts/prefabs/trinkets.lua"]	
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
大理石雕像			预设: sculpture_bishopbody		路径： [string "scripts/prefabs/sculptures.lua"]	
	Tags▼	
	{":", "inspectable", "sculpture", "antlion_sinkhole_blocker", "statue", "MINE_workable", "chess_moonevent", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bishop")	
			inst.AnimState:SetBuild("sculpture_bishop")	
			Anim路径 :  "anim/sculpture_bishop.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("shadowchessroar")	
------------------------------------------------	
猪王			预设: pigking		路径： [string "scripts/prefabs/pigking.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "idle", "antlion_sinkhole_blocker", "king", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("Pig_King")	
			inst.AnimState:SetBuild("Pig_King")	
			Anim路径 :  "anim/pig_king.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("minigame")	
		
	SG = 有▼	
------------------------------------------------	
墓碑			预设: gravestone		路径： [string "scripts/prefabs/gravestone.lua"]	
	Tags▼	
	{":", "inspectable", "grave", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gravestone")	
			inst.AnimState:SetBuild("gravestones")	
			Anim路径 :  "anim/gravestones.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("worked")	
------------------------------------------------	
易碎骨骼			预设: scorched_skeleton		路径： [string "scripts/prefabs/scorched_skeleton.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("skeleton")	
			inst.AnimState:SetBuild("scorched_skeletons")	
			Anim路径 :  "anim/skeletons.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
虫洞			预设: wormhole		路径： [string "scripts/prefabs/wormhole.lua"]	
	Tags▼	
	{":", "teleporter", "trader", "inspectable", "alltrader", "idle", "_inventory", "antlion_sinkhole_blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("teleporter_worm_build")	
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
沐浴球			预设: bathbomb		路径： [string "scripts/prefabs/bathbomb.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "bathbomb", "_stackable", "BURNABLE_fuel", "canlight", "show_spoilage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bath_bomb")	
			inst.AnimState:SetBuild("bath_bomb")	
			Anim路径 :  "anim/bath_bomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("bathbomb")	
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
南瓜灯			预设: pumpkin_lantern		路径： [string "scripts/prefabs/pumpkin_lantern.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "_combat", "veggie", "fresh", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pumpkin")	
			inst.AnimState:SetBuild("pumpkin_lantern")	
			Anim路径 :  "anim/pumpkin_lantern.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
钓竿			预设: fishingrod		路径： [string "scripts/prefabs/fishingrod.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "allow_action_on_impassable", "fishingrod", "_fishingrod", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fishingrod")	
			inst.AnimState:SetBuild("fishingrod")	
			Anim路径 :  "anim/fishingrod.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("fishingrod")	
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
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("fishingcollect")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lightninggoatherd		路径： [string "scripts/prefabs/lightninggoatherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("herd")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
月光玻璃窝			预设: moonglass_wobster_den		路径： [string "scripts/prefabs/wobster_den.lua"]	
	Tags▼	
	{":", "inspectable", "event_trigger", "MINE_workable", "ignorewalkableplatforms", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_den_moonglass_build")	
			Anim路径 :  "anim/lobster_den.zip"	
 	
	使用的组件▼	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("on_collide")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
矿工帽			预设: minerhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "CAVE_fueled", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("minerhat")	
			inst.AnimState:SetBuild("hat_miner")	
			Anim路径 :  "anim/hat_miner.zip"	
 	
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
破碎的玻璃罐			预设: trinket_44		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: tumbleweedspawner		路径： [string "scripts/prefabs/tumbleweedspawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("detachchild")	
		inst:ListenForEvent("ontrapped")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("death")	
------------------------------------------------	
苔藓藤条			预设: oceanvine		路径： [string "scripts/prefabs/oceanvine.lua"]	
	Tags▼	
	{":", "inspectable", "oceanvine", "NOBLOCK", "hangingvine", "canlight", "flying", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanvine")	
			inst.AnimState:SetBuild("oceanvine")	
			Anim路径 :  "anim/oceanvine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: moose_nesting_ground		路径： [string "scripts/prefabs/mooseegg.lua"]	
	Tags▼	
	{":", "antlion_sinkhole_blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nesting_ground")	
			inst.AnimState:SetBuild("nesting_ground")	
			Anim路径 :  "anim/nesting_ground.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("playerprox")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
格罗姆雕像			预设: statueglommer		路径： [string "scripts/prefabs/statueglommer.lua"]	
	Tags▼	
	{":", "inspectable", "statue", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("glommer_statue")	
			inst.AnimState:SetBuild("glommer_statue")	
			Anim路径 :  "anim/glommer_statue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("leader")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("death")	
------------------------------------------------	
帝王蟹			预设: crabking		路径： [string "scripts/prefabs/crabking.lua"]	
	Tags▼	
	{":", "gemsocket", "trader", "_health", "inspectable", "noattack", "_inventory", "crabking", "_combat", "ignorewalkableplatforms", "birdblocker", "largecreature", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("crab_king_build")	
			Anim路径 :  "anim/crab_king_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("trader")	
		inst:AddComponent("timer")	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("freeze")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("healthdelta")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
破碎蜘蛛洞			预设: moonspiderden		路径： [string "scripts/prefabs/moonspiderden.lua"]	
	Tags▼	
	{":", "inspectable", "spiderden", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_mound_mutated")	
			inst.AnimState:SetBuild("spider_mound_mutated")	
			Anim路径 :  "anim/spider_mound_mutated.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("workable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("creepactivate")	
		inst:ListenForEvent("startquake")	
------------------------------------------------	
MISSING NAME			预设: meteorspawner		路径： [string "scripts/prefabs/meteorspawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("meteorshower")	
		
------------------------------------------------	
舞台之手			预设: stagehand		路径： [string "scripts/prefabs/stagehand.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "hiding", "idle", "HAMMER_workable", "antlion_sinkhole_blocker", "locomotor", "canlight", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stagehand")	
			inst.AnimState:SetBuild("stagehand")	
			Anim路径 :  "anim/stagehand.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		
	SG = 有▼	
	AI = 有▼	
------------------------------------------------	
猴爪			预设: trinket_34		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: oceanfish_shoalspawner		路径： [string "scripts/prefabs/oceanfish_shoalspawner.lua"]	
	Tags▼	
	{":", "NOBLOCK", "ignorewalkableplatforms"}	
 	
	使用的组件▼	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
可疑的大理石			预设: sculpture_knighthead		路径： [string "scripts/prefabs/sculpture_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "nonpotatable", "work_sculpture", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_sculpture_knighthead")	
			Anim路径 :  "anim/sculpture_pieces.zip"	
 	
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
树枝			预设: twigs		路径： [string "scripts/prefabs/twigs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_ROUGHAGE", "_stackable", "renewable", "health_wood", "oceanfishing_bobber", "cattoy", "BURNABLE_fuel", "canlight", "repairer", "edible_WOOD"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("twigs")	
			inst.AnimState:SetBuild("twigs")	
			Anim路径 :  "anim/twigs.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("oceanfishingtackle")	
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
猎犬丘			预设: houndmound		路径： [string "scripts/prefabs/houndmound.lua"]	
	Tags▼	
	{":", "houndmound", "_health", "inspectable", "_combat", "structure", "SnowCovered", "beaverchewable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("hound_base")	
			Anim路径 :  "anim/hound_base.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
在呼唤我			预设: moon_altar_rock_idol		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("altar_idolpiece")	
			inst.AnimState:SetBuild("altar_idolpiece")	
			Anim路径 :  "anim/altar_idolpiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("calling_moon_relics")	
------------------------------------------------	
麦斯威尔雕像			预设: statuemaxwell		路径： [string "scripts/prefabs/statuemaxwell.lua"]	
	Tags▼	
	{":", "inspectable", "maxwell", "statue", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("statue_maxwell")	
			inst.AnimState:SetBuild("statue_maxwell")	
			Anim路径 :  "anim/statue_maxwell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
瓶中信			预设: messagebottle		路径： [string "scripts/prefabs/messagebottle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "waterproofer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bottle")	
			inst.AnimState:SetBuild("bottle")	
			Anim路径 :  "anim/bottle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("mapspotrevealer")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_reveal_map_spot_pst")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
可疑的大理石			预设: sculpture_bishophead		路径： [string "scripts/prefabs/sculpture_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "nonpotatable", "work_sculpture", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_sculpture_bishophead")	
			Anim路径 :  "anim/sculpture_pieces.zip"	
 	
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
风滚草			预设: tumbleweed		路径： [string "scripts/prefabs/tumbleweed.lua"]	
	Tags▼	
	{":", "inspectable", "locomotor", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tumbleweed")	
			inst.AnimState:SetBuild("tumbleweed")	
			Anim路径 :  "anim/tumbleweed.zip"	
 	
	使用的组件▼	
		inst:AddComponent("locomotor")	
		inst:AddComponent("blowinwind")	
		inst:AddComponent("burnable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("pickable")	
		
	使用的监听▼	
		inst:ListenForEvent("windchange")	
		inst:ListenForEvent("startlongaction")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: moon_altar_astral_marker_2		路径： [string "scripts/prefabs/moon_altar.lua"]	
	Tags▼	
	{":", "fx", "moon_altar_astral_marker", "antlion_sinkhole_blocker", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
仙人掌			预设: oasis_cactus		路径： [string "scripts/prefabs/cactus.lua"]	
	Tags▼	
	{":", "thorny", "inspectable", "plant", "canlight", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oasis_cactus")	
			inst.AnimState:SetBuild("oasis_cactus")	
			Anim路径 :  "anim/oasis_cactus.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
石砖			预设: cutstone		路径： [string "scripts/prefabs/cutstone.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "repairer", "health_stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cutstone")	
			inst.AnimState:SetBuild("cutstone")	
			Anim路径 :  "anim/cutstone.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("repairer")	
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
浮木			预设: driftwood_tall		路径： [string "scripts/prefabs/driftwood_trees.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "plant", "CHOP_workable", "canlight", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("driftwood_tall")	
			inst.AnimState:SetBuild("driftwood_tall")	
			Anim路径 :  "anim/driftwood_tall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
损坏的吹风机			预设: trinket_46		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: scorchedground		路径： [string "scripts/prefabs/scorchedground.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_ground")	
			inst.AnimState:SetBuild("scorched_ground")	
			Anim路径 :  "anim/scorched_ground.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
努梅里安			预设: pigman		路径： [string "scripts/prefabs/pigman.lua"]	
	Tags▼	
	{":", "trader", "_health", "inspectable", "freezable", "pig", "RAW_eater", "_named", "idle", "_inventory", "strongstomach", "HORRIBLE_eater", "_combat", "locomotor", "OMNI_eater", "sanityaura", "scarytoprey", "nolight", "_follower", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigman")	
			inst.AnimState:SetBuild("pigspotted_build")	
			Anim路径 :  "anim/ds_pig_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("werebeast")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("named")	
		inst:AddComponent("talker")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("inventory")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("drownable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("suggest_tree_target")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onvacatehome")	
		inst:ListenForEvent("itemlose")	
	SG = 有▼	
------------------------------------------------	
低音贝壳钟			预设: singingshell_octave3		路径： [string "scripts/prefabs/singingshell.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "cancycle", "HAMMER_workable", "singingshell"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("singingshell")	
			inst.AnimState:SetBuild("singingshell")	
			Anim路径 :  "anim/singingshell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("workable")	
		inst:AddComponent("cyclable")	
		inst:AddComponent("lootdropper")	
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
MISSING NAME			预设: beefaloherd		路径： [string "scripts/prefabs/beefaloherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("herd")	
		inst:AddComponent("mood")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: hermitcrab_marker_fishing		路径： [string "scripts/prefabs/hermitcrab.lua"]	
	Tags▼	
	{":", "NOBLOCK", "hermitcrab_marker_fishing", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
乌鸦装饰			预设: halloween_ornament_6		路径： [string "scripts/prefabs/halloween_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "cattoy", "BURNABLE_fuel", "halloween_ornament"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("halloween_ornaments")	
			inst.AnimState:SetBuild("halloween_ornaments")	
			Anim路径 :  "anim/halloween_ornaments.zip"	
 	
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
多汁浆果丛			预设: berrybush_juicy		路径： [string "scripts/prefabs/berrybush.lua"]	
	Tags▼	
	{":", "bush", "inspectable", "renewable", "plant", "DIG_workable", "canlight", "witherable", "SnowCovered", "pickable", "jostlepick", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush_juicy")	
			inst.AnimState:SetBuild("berrybush_juicy")	
			Anim路径 :  "anim/berrybush_juicy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("witherable")	
		
	使用的监听▼	
		inst:ListenForEvent("onwenthome")	
------------------------------------------------	
大理石雕像			预设: sculpture_knightbody		路径： [string "scripts/prefabs/sculptures.lua"]	
	Tags▼	
	{":", "inspectable", "sculpture", "antlion_sinkhole_blocker", "statue", "MINE_workable", "chess_moonevent", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("knight")	
			inst.AnimState:SetBuild("sculpture_knight")	
			Anim路径 :  "anim/sculpture_knight.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("shadowchessroar")	
------------------------------------------------	
池塘			预设: pond		路径： [string "scripts/prefabs/pond.lua"]	
	Tags▼	
	{":", "inspectable", "watersource", "fishable", "antlion_sinkhole_blocker", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marsh_tile")	
			inst.AnimState:SetBuild("marsh_tile")	
			Anim路径 :  "anim/marsh_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("fishable")	
		inst:AddComponent("watersource")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
杀人蜂蜂窝			预设: wasphive		路径： [string "scripts/prefabs/wasphive.lua"]	
	Tags▼	
	{":", "WORM_DANGER", "hive", "_health", "inspectable", "_combat", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wasphive")	
			inst.AnimState:SetBuild("wasphive")	
			Anim路径 :  "anim/wasphive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("propagator")	
		inst:AddComponent("health")	
		inst:AddComponent("combat")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
葡萄干			预设: halloweencandy_7		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
回旋镖			预设: boomerang		路径： [string "scripts/prefabs/boomerang.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "thrown", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boomerang")	
			inst.AnimState:SetBuild("boomerang")	
			Anim路径 :  "anim/boomerang.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("projectile")	
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
MISSING NAME			预设: spawnpoint_multiplayer		路径： [string "scripts/prefabs/spawnpoint_multiplayer.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
浮木			预设: driftwood_small1		路径： [string "scripts/prefabs/driftwood_trees.lua"]	
	Tags▼	
	{":", "inspectable", "tree", "plant", "CHOP_workable", "canlight", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("driftwood_small1")	
			inst.AnimState:SetBuild("driftwood_small1")	
			Anim路径 :  "anim/driftwood_small1.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
可疑的月岩			预设: gargoyle_hounddeath		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "inspectable", "gargoyle", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("sculpture_hound_moonrock_build")	
			Anim路径 :  "anim/sculpture_hound.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("hauntable")	
		
------------------------------------------------	
湖泊			预设: oasislake		路径： [string "scripts/prefabs/oasislake.lua"]	
	Tags▼	
	{":", "inspectable", "antlion_sinkhole_blocker", "birdblocker", "NOCLICK", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oasis_tile")	
			inst.AnimState:SetBuild("oasis_tile")	
			Anim路径 :  "anim/oasis_tile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("fishable")	
		inst:AddComponent("oasis")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("watersource")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_stormchanged")	
------------------------------------------------	
人造尖牙			预设: trinket_36		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: waterplant_spawner_rough		路径： [string "scripts/prefabs/waterplant.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
海星			预设: trap_starfish		路径： [string "scripts/prefabs/trap_starfish.lua"]	
	Tags▼	
	{":", "inspectable", "wet", "trapdamage", "trap", "mineactive", "DIG_workable", "birdblocker", "mine_not_reusable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("star_trap")	
			inst.AnimState:SetBuild("star_trap")	
			Anim路径 :  "anim/star_trap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("mine")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onputininventory")	
------------------------------------------------	
鹤嘴锄			预设: pickaxe		路径： [string "scripts/prefabs/pickaxe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "MINE_tool", "inspectable", "tool", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pickaxe")	
			inst.AnimState:SetBuild("pickaxe")	
			Anim路径 :  "anim/pickaxe.zip"	
 	
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
岩石			预设: rock_moon		路径： [string "scripts/prefabs/rocks.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock7")	
			Anim路径 :  "anim/rock7.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
竖琴雕像			预设: statueharp		路径： [string "scripts/prefabs/statueharp.lua"]	
	Tags▼	
	{":", "inspectable", "statue", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("statue_small")	
			inst.AnimState:SetBuild("statue_small")	
			Anim路径 :  "anim/statue_small.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
鳄鱼玩具			预设: trinket_43		路径： [string "scripts/prefabs/trinkets.lua"]	
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
月光玻璃斧			预设: moonglassaxe		路径： [string "scripts/prefabs/axe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "possessable_axe", "inspectable", "tool", "sharp", "_equippable", "CHOP_tool", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("glassaxe")	
			inst.AnimState:SetBuild("glassaxe")	
			Anim路径 :  "anim/glassaxe.zip"	
 	
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
岩石			预设: lava_pond_rock2		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_rock")	
			inst.AnimState:SetBuild("scorched_rock")	
			Anim路径 :  "anim/scorched_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
岩石			预设: lava_pond_rock7		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_rock")	
			inst.AnimState:SetBuild("scorched_rock")	
			Anim路径 :  "anim/scorched_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
岩石			预设: lava_pond_rock5		路径： [string "scripts/prefabs/lava_pond.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scorched_rock")	
			inst.AnimState:SetBuild("scorched_rock")	
			Anim路径 :  "anim/scorched_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: mastupgrade_lightningrod_top		路径： [string "scripts/prefabs/mastupgrade_lightningrod.lu..."]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mastupgrade_lightningrod_item")	
			inst.AnimState:SetBuild("mastupgrade_lightningrod")	
			Anim路径 :  "anim/mastupgrade_lightningrod.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
孢子云			预设: sporecloud		路径： [string "scripts/prefabs/sporecloud.lua"]	
	Tags▼	
	{":", "fx", "_combat", "notarget", "NOCLICK", "sporecloud"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sporecloud")	
			inst.AnimState:SetBuild("sporecloud")	
			Anim路径 :  "anim/sporecloud.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("combat")	
		inst:AddComponent("aura")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
种下的尖种子			预设: farm_plant_pumpkin		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "farm_plant_pumpkin", "plant", "DIG_workable", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_pumpkin")	
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
MISSING NAME			预设: alterguardian_hat_equipped		路径： [string "scripts/prefabs/alterguardian_hat_equipped...."]	
	Tags▼	
	{":", "fx", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hat_alterguardian_equipped")	
			inst.AnimState:SetBuild("hat_alterguardian_equipped")	
			Anim路径 :  "anim/hat_alterguardian_equipped.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: portablespicer_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_spicer")	
			inst.AnimState:SetBuild("portable_spicer")	
			Anim路径 :  "anim/portable_spicer.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
洞穴香蕉树			预设: cave_banana_tree		路径： [string "scripts/prefabs/cave_banana_tree.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "CHOP_workable", "canlight", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cave_banana_tree")	
			inst.AnimState:SetBuild("cave_banana_tree")	
			Anim路径 :  "anim/cave_banana_tree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
衣柜 蓝图			预设: blueprint		路径： [string "scripts/prefabs/blueprint.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_named", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blueprint")	
			inst.AnimState:SetBuild("blueprint")	
			Anim路径 :  "anim/blueprint.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("fuel")	
		inst:AddComponent("teacher")	
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
MISSING NAME			预设: schoolherd_oceanfish_small_6		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
黑羽浮标			预设: oceanfishingbobber_crow		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_crow_build")	
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
圣诞灯			预设: winter_ornament_light2		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: blossom_hit_fx		路径： [string "scripts/prefabs/fireball_projectile.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜爆炒填馅辣椒			预设: pepperpopper_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
熊獾雕塑			预设: chesspiece_bearger_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣蜜汁火腿			预设: honeyham_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的发光浆果慕斯			预设: glowberrymousse_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
节日欢愉			预设: wintersfeastfuel		路径： [string "scripts/prefabs/wintersfeastfuel.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wintersfeastfuel")	
			inst.AnimState:SetBuild("wintersfeastfuel")	
			Anim路径 :  "anim/wintersfeastfuel.zip"	
 	
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
煮熟的叶子			预设: quagmire_foliage_cooked		路径： [string "scripts/prefabs/foliage.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("foliage")	
			inst.AnimState:SetBuild("foliage")	
			Anim路径 :  "anim/foliage.zip"	
 	
	使用的组件▼	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
船补丁			预设: boatpatch		路径： [string "scripts/prefabs/boatpatch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_patch", "inspectable", "allow_action_on_impassable", "_stackable", "health_wood", "BURNABLE_fuel", "canlight", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_repair_build")	
			Anim路径 :  "anim/boat_repair.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
		inst:AddComponent("boatpatch")	
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
火腿棒			预设: hambat		路径： [string "scripts/prefabs/hambat.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "icebox_valid", "show_spoilage", "_equippable", "weapon", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ham_bat")	
			inst.AnimState:SetBuild("ham_bat")	
			Anim路径 :  "anim/ham_bat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("forcecompostable")	
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
玉米鳕鱼			预设: oceanfish_medium_5_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "edible_VEGGIE", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_5")	
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
石笋			预设: stalagmite		路径： [string "scripts/prefabs/stalagmite.lua"]	
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
MISSING NAME			预设: messagebottle_throwable		路径： [string "scripts/prefabs/messagebottle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bottle")	
			inst.AnimState:SetBuild("bottle")	
			Anim路径 :  "anim/bottle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("complexprojectile")	
		inst:AddComponent("mapspotrevealer")	
		inst:AddComponent("equippable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_reveal_map_spot_pst")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蒜香培根煎蛋			预设: baconeggs_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
玛姆茜			预设: quagmire_goatmum		路径： [string "scripts/prefabs/quagmire_goatmum.lua"]	
	Tags▼	
	{":", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
------------------------------------------------	
螺旋矛			预设: spear_lance		路径： [string "scripts/prefabs/spear_lance.lua"]	
	Tags▼	
	{":", "rechargeable", "pointy", "superjump", "sharp", "aoeweapon_leap", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spear_lance")	
			inst.AnimState:SetBuild("spear_lance")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
------------------------------------------------	
什锦种子包			预设: quagmire_seedpacket		路径： [string "scripts/prefabs/quagmire_seedpackets.lua"]	
	Tags▼	
	{":", "unwrappable", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_seedpacket")	
			inst.AnimState:SetBuild("quagmire_seedpacket")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
种下的芦笋种子			预设: farm_plant_asparagus		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "farm_plant_asparagus", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_asparagus")	
			inst.AnimState:SetBuild("farm_plant_asparagus")	
			Anim路径 :  "anim/farm_plant_asparagus.zip"	
 	
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
MISSING NAME			预设: schoolherd_oceanfish_medium_7		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
重量级鱼饵			预设: oceanfishinglure_hermit_heavy		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
MISSING NAME			预设: reviver_cupid_glow_fx		路径： [string "scripts/prefabs/reviver_cupid_beat_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bloodpump")	
			inst.AnimState:SetBuild("bloodpump")	
			Anim路径 :  "anim/bloodpump.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
炸鸟腿			预设: drumstick_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "drumstick", "_stackable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("drumstick")	
			inst.AnimState:SetBuild("drumstick")	
			Anim路径 :  "anim/drumstick.zip"	
 	
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
火药			预设: gunpowder		路径： [string "scripts/prefabs/gunpowder.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "explosive", "molebait", "_stackable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gunpowder")	
			inst.AnimState:SetBuild("gunpowder")	
			Anim路径 :  "anim/gunpowder.zip"	
 	
	使用的组件▼	
		inst:AddComponent("bait")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("explosive")	
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
蔚蓝羽浮标广告			预设: tacklesketch		路径： [string "scripts/prefabs/tacklesketch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_named", "BURNABLE_fuel", "tacklesketch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blueprint_tackle")	
			inst.AnimState:SetBuild("blueprint_tackle")	
			Anim路径 :  "anim/blueprint_tackle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("tacklesketch")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("named")	
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
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
幸运兽尾巴			预设: dragontailhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragontailhat")	
			inst.AnimState:SetBuild("hat_dragontail")	
			Anim路径 :  "anim/hat_dragontail.zip"	
 	
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
辣失败料理			预设: wetgoop_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: weregoose_feathers3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香牛肉绿叶菜			预设: meatysalad_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
残破的钟楼			预设: quagmire_rubble_clocktower		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
沙刺			预设: sandspike_med		路径： [string "scripts/prefabs/sand_spike.lua"]	
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
MISSING NAME			预设: pillar_cave_flintless		路径： [string "scripts/prefabs/pillar.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_cave_flintless")	
			inst.AnimState:SetBuild("pillar_cave_flintless")	
			Anim路径 :  "anim/pillar_cave_flintless.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蘑菇皮			预设: shroom_skin		路径： [string "scripts/prefabs/shroom_skin.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shroom_skin")	
			inst.AnimState:SetBuild("shroom_skin")	
			Anim路径 :  "anim/shroom_skin.zip"	
 	
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
刷子			预设: brush		路径： [string "scripts/prefabs/brush.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalobrush")	
			inst.AnimState:SetBuild("beefalobrush")	
			Anim路径 :  "anim/beefalobrush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("brush")	
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
MISSING NAME			预设: wave_shimmer		路径： [string "scripts/prefabs/wave_shimmer.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED", "NOBLOCK", "ignorewalkableplatforms", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wave_shimmer")	
			Anim路径 :  "anim/wave_shimmer_med.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
金色腰带			预设: pig_token		路径： [string "scripts/prefabs/pig_token.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pig_token")	
			inst.AnimState:SetBuild("pig_token")	
			Anim路径 :  "anim/pig_token.zip"	
 	
	使用的组件▼	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: icing_splash_fx_low		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: crabking_feeze		路径： [string "scripts/prefabs/crabking.lua"]	
	Tags▼	
	{":", "fx", "crabking_spellgenerator", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("age")	
		
	使用的监听▼	
		inst:ListenForEvent("endspell")	
		inst:ListenForEvent("setowner")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: winters_feast_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
幸运野兽弗娄牛玩偶			预设: yotb_beefalo_doll_beast		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
奶油鱼片			预设: quagmire_food_056		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜藤壶皮塔饼			预设: barnaclepita_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
减轻恐惧的药液			预设: halloweenpotion_bravery_small		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
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
蜂刺			预设: stinger		路径： [string "scripts/prefabs/stinger.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stinger")	
			inst.AnimState:SetBuild("stinger")	
			Anim路径 :  "anim/stinger.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
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
无花果酿树干			预设: koalefig_trunk		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
锚雕塑草图			预设: sketch		路径： [string "scripts/prefabs/sketch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_named", "BURNABLE_fuel", "sketch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blueprint_sketch")	
			inst.AnimState:SetBuild("blueprint_sketch")	
			Anim路径 :  "anim/blueprint_sketch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("named")	
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
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
石果			预设: rock_avocado_fruit		路径： [string "scripts/prefabs/rock_avocado_fruit.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL", "MINE_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_fruit_build")	
			Anim路径 :  "anim/rock_avocado_fruit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("tradable")	
		
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
蒜香蜜汁火腿			预设: honeyham_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
塞满馅料的蘑菇			预设: quagmire_food_029		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
天体英雄雕塑			预设: chesspiece_guardianphase3		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_guardianphase3_moonglass")	
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
便携烹饪锅			预设: portablecookpot		路径： [string "scripts/prefabs/portablecookpot.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "stewer", "mastercookware", "HAMMER_workable", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_cook_pot")	
			inst.AnimState:SetBuild("portable_cook_pot")	
			Anim路径 :  "anim/portable_cook_pot.zip"	
 	
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
战旗			预设: lavaarena_battlestandard_heal		路径： [string "scripts/prefabs/lavaarena_battlestandard.lu..."]	
	Tags▼	
	{":", "battlestandard", "LA_mob"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
地狱魔杖			预设: fireballstaff		路径： [string "scripts/prefabs/fireballstaff.lua"]	
	Tags▼	
	{":", "rechargeable", "rangedweapon", "pyroweapon", "firestaff", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fireballstaff")	
			inst.AnimState:SetBuild("fireballstaff")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
MISSING NAME			预设: redpouch_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
远古钥匙			预设: atrium_key		路径： [string "scripts/prefabs/atrium_key.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "nonpotatable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_key")	
			inst.AnimState:SetBuild("atrium_key")	
			Anim路径 :  "anim/atrium_key.zip"	
 	
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
MISSING NAME			预设: none_fest_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鼹鼠帽			预设: molehat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "nightvision", "WORMLIGHT_fueled", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("molehat")	
			inst.AnimState:SetBuild("hat_mole")	
			Anim路径 :  "anim/hat_mole.zip"	
 	
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
洞穴香蕉			预设: cave_banana		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cave_banana")	
			inst.AnimState:SetBuild("cave_banana")	
			Anim路径 :  "anim/cave_banana.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
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
MISSING NAME			预设: sleepcloud		路径： [string "scripts/prefabs/sleepcloud.lua"]	
	Tags▼	
	{":", "fx", "notarget", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sleepcloud")	
			inst.AnimState:SetBuild("sleepcloud")	
			Anim路径 :  "anim/sleepcloud.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
龙虾正餐			预设: lobsterdinner		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
楼梯			预设: cave_exit		路径： [string "scripts/prefabs/cave_exit.lua"]	
	Tags▼	
	{":", "inspectable", "CLASSIFIED", "NOCLICK", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cave_exit")	
			Anim路径 :  "anim/cave_exit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldmigrator")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("migration_unavailable")	
		inst:ListenForEvent("migration_full")	
		inst:ListenForEvent("migration_available")	
		inst:ListenForEvent("migration_activate")	
------------------------------------------------	
肉串			预设: kabobs		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
座狼			预设: warg		路径： [string "scripts/prefabs/warg.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "houndfriend", "freezable", "idle", "_combat", "locomotor", "scarytoprey", "nolight", "largecreature", "warg", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("warg")	
			inst.AnimState:SetBuild("warg_build")	
			Anim路径 :  "anim/warg_actions.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("leader")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("locomotor")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
洞穴香蕉树			预设: cave_banana_stump		路径： [string "scripts/prefabs/cave_banana_tree.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cave_banana_tree")	
			inst.AnimState:SetBuild("cave_banana_tree")	
			Anim路径 :  "anim/cave_banana_tree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
------------------------------------------------	
意粉和肉丸			预设: quagmire_food_038		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
红色猎犬			预设: firehound		路径： [string "scripts/prefabs/hound.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "freezable", "scarytooceanprey", "hostile", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "canbestartled", "sanityaura", "scarytoprey", "_follower", "sleeper", "hound"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hound")	
			inst.AnimState:SetBuild("hound_red_ocean")	
			Anim路径 :  "anim/hound_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("amphibiouscreature")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("spawnfader")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("spawnedfromhaunt")	
	SG = 有▼	
------------------------------------------------	
洞穴蝙蝠			预设: bat		路径： [string "scripts/prefabs/bat.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "freezable", "team_bat", "bat", "idle", "_inventory", "hostile", "strongstomach", "_combat", "MEAT_eater", "locomotor", "scarytoprey", "nolight", "flying", "ignorewalkableplatformdrowning", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bat")	
			inst.AnimState:SetBuild("bat_basic")	
			Anim路径 :  "anim/bat_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("propagator")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("eater")	
		inst:AddComponent("teamattacker")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
邪天翁雕塑			预设: chesspiece_malbatross		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_malbatross_marble")	
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
树精守卫			预设: leif_sparse		路径： [string "scripts/prefabs/leif.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "idle", "tree", "hostile", "_combat", "locomotor", "sanityaura", "epic", "nolight", "evergreens", "largecreature", "leif", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("leif")	
			inst.AnimState:SetBuild("leif_lumpy_build")	
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
MISSING NAME			预设: pine_needles_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
种下的块状种子			预设: farm_plant_pepper		路径： [string "scripts/prefabs/farm_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant", "farm_plant_pepper", "planted_seed", "plantresearchable", "plant", "DIG_workable", "canlight", "farmplantstress", "tendable_farmplant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_pepper")	
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
背壳头盔			预设: slurtlehat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slurtlehat")	
			inst.AnimState:SetBuild("hat_slurtle")	
			Anim路径 :  "anim/hat_slurtle.zip"	
 	
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
MISSING NAME			预设: yotb_post_rug		路径： [string "scripts/prefabs/yotb_post.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("yotb_post_rug")	
			Anim路径 :  "anim/yotb_post_rug.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
黑羽浮标			预设: oceanfishingbobber_crow_floater		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "inspectable", "fishinghook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_crow_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishinghook")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("oceanfishable")	
		
------------------------------------------------	
浆果丛			预设: berrybush		路径： [string "scripts/prefabs/berrybush.lua"]	
	Tags▼	
	{":", "bush", "inspectable", "renewable", "plant", "DIG_workable", "canlight", "witherable", "SnowCovered", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush")	
			inst.AnimState:SetBuild("berrybush")	
			Anim路径 :  "anim/berrybush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("witherable")	
		
	使用的监听▼	
		inst:ListenForEvent("onwenthome")	
------------------------------------------------	
花饰头带			预设: lavaarena_healingflowerhat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: madscience_lab_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("madscience_lab")	
			inst.AnimState:SetBuild("madscience_lab")	
			Anim路径 :  "anim/madscience_lab.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
荧光果			预设: lightbulb		路径： [string "scripts/prefabs/lightbulb.lua"]	
	Tags▼	
	{":", "_inventoryitem", "vasedecoration", "lightbattery", "inspectable", "FROMNUM", "_stackable", "edible_VEGGIE", "halloweenmoonmutable", "canlight", "CAVE_fuel", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bulb")	
			inst.AnimState:SetBuild("bulb")	
			Anim路径 :  "anim/bulb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("vasedecoration")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("halloweenmoonmutable")	
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
MISSING NAME			预设: schoolherd_oceanfish_medium_5		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
蜂王雕塑			预设: chesspiece_beequeen		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_beequeen_stone")	
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
冰鲷鱼			预设: oceanfish_medium_8_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "HASHEATER", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_8")	
			Anim路径 :  "anim/oceanfish_medium.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("heater")	
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
MISSING NAME			预设: battlesong_sanitygain_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
烤鳗鱼			预设: eel_cooked		路径： [string "scripts/prefabs/eel.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "fishmeat", "_stackable", "catfood", "fresh"}	
 	
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
		inst:AddComponent("stackable")	
		inst:AddComponent("floater")	
		
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
MISSING NAME			预设: slow_steam_fx5		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
胡萝卜鼠雕塑			预设: chesspiece_carrat		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_carrat_marble")	
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
硬物浮标			预设: oceanfishingbobber_oval_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishing_bobber_sporty_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
岩浆虫卵			预设: lavae_egg_cracked		路径： [string "scripts/prefabs/lavae_egg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavae_egg")	
			inst.AnimState:SetBuild("lavae_egg")	
			Anim路径 :  "anim/lavae_egg.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("hatchable")	
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
芝士蛋糕			预设: powcake		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "edible_VEGGIE", "badfood", "canlight", "preparedfood", "fresh"}	
 	
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
沃拓克斯			预设: wortox		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "monster", "trader", "_health", "inspectable", "soulstealer", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "souleater", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "playermonster", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
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
		inst:AddComponent("wisecracker")	
		inst:AddComponent("propagator")	
		inst:AddComponent("distancetracker")	
		inst:AddComponent("grogginess")	
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
		inst:AddComponent("reticule")	
		inst:AddComponent("foodaffinity")	
		inst:AddComponent("playervision")	
		inst:AddComponent("eater")	
		inst:AddComponent("timer")	
		inst:AddComponent("inkable")	
		inst:AddComponent("combat")	
		inst:AddComponent("plantregistryupdater")	
		inst:AddComponent("leader")	
		inst:AddComponent("souleater")	
		inst:AddComponent("singingshelltrigger")	
		inst:AddComponent("embarker")	
		inst:AddComponent("giftreceiver")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hunger")	
		inst:AddComponent("touchstonetracker")	
		inst:AddComponent("areaaware")	
		inst:AddComponent("petleash")	
		inst:AddComponent("moonstormwatcher")	
		inst:AddComponent("debuffable")	
		inst:AddComponent("playeravatardata")	
		inst:AddComponent("workmultiplier")	
		inst:AddComponent("moisture")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("rider")	
		inst:AddComponent("bloomer")	
		inst:AddComponent("birdattractor")	
		inst:AddComponent("spooked")	
		inst:AddComponent("attuner")	
		
	使用的监听▼	
		inst:ListenForEvent("playerdied")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("startfreezing")	
		inst:ListenForEvent("entity_death")	
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
		inst:ListenForEvent("starvedtrapsouls")	
		inst:ListenForEvent("localplayer._hermit_music")	
		inst:ListenForEvent("learnfertilizer")	
		inst:ListenForEvent("entity_droploot")	
		inst:ListenForEvent("heargrue")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("working")	
		inst:ListenForEvent("ms_respawnedfromghost")	
		inst:ListenForEvent("onstartedfire")	
		inst:ListenForEvent("harvesttrapsouls")	
		inst:ListenForEvent("murdered")	
		inst:ListenForEvent("soulhop")	
		inst:ListenForEvent("gotnewitem")	
		inst:ListenForEvent("takeoversizedpicture")	
		inst:ListenForEvent("onchangecanopyzone")	
		inst:ListenForEvent("ghostdelta")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("learncookbookstats")	
		inst:ListenForEvent("setowner")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("killed")	
		inst:ListenForEvent("lightningdamageavoided")	
		inst:ListenForEvent("unevengrounddetected")	
		inst:ListenForEvent("coveredinbees")	
		inst:ListenForEvent("startoverheating")	
		inst:ListenForEvent("itemranout")	
		inst:ListenForEvent("startfiredamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("wonteatfood")	
		inst:ListenForEvent("dropitem")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("picksomething")	
		inst:ListenForEvent("attackedbygrue")	
		inst:ListenForEvent("snared")	
		inst:ListenForEvent("soultoofew")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("accomplishment")	
		inst:ListenForEvent("resistedgrue")	
		inst:ListenForEvent("ms_closepopup")	
		inst:ListenForEvent("soultoomany")	
		inst:ListenForEvent("wormholespit")	
		inst:ListenForEvent("makeplayerghost")	
		inst:ListenForEvent("inventoryfull")	
		inst:ListenForEvent("usedtouchstone")	
		inst:ListenForEvent("equip")	
		inst:ListenForEvent("oneat")	
		inst:ListenForEvent("foodbuffdetached")	
		inst:ListenForEvent("foodbuffattached")	
		inst:ListenForEvent("insufficientfertilizer")	
		inst:ListenForEvent("soulempty")	
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
传送焦点			预设: telebase		路径： [string "scripts/prefabs/telebase.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "telebase"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("staff_purple_base_ground")	
			inst.AnimState:SetBuild("staff_purple_base_ground")	
			Anim路径 :  "anim/staff_purple_base_ground.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("objectspawner")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: slingshotammo_hitfx_thulecite		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
岩石大白鲨			预设: shark		路径： [string "scripts/prefabs/shark.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "scarytooceanprey", "idle", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "scarytoprey", "nolight", "shark", "largecreature", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shark")	
			inst.AnimState:SetBuild("shark_build")	
			Anim路径 :  "anim/shark_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("amphibiouscreature")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("updatelooper")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onattackother")	
	SG = 有▼	
------------------------------------------------	
可靠的弹弓			预设: slingshot		路径： [string "scripts/prefabs/slingshot.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_container", "slingshot", "canlight", "rangedweapon", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshot")	
			inst.AnimState:SetBuild("slingshot")	
			Anim路径 :  "anim/slingshot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("container")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("weapon")	
		
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
培根煎蛋			预设: baconeggs		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
生鲜萨尔萨酱			预设: salsa		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣炸鱼排			预设: fishsticks_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
神秘盒子			预设: carnivaldecor_figure_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_statue")	
			inst.AnimState:SetBuild("carnivaldecor_statue")	
			Anim路径 :  "anim/carnivaldecor_statue.zip"	
 	
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
蒜香龙虾汤			预设: lobsterbisque_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
锯齿木甲			预设: lavaarena_armormediumdamager		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "hide_percentage", "wood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜加州卷			预设: californiaroll_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
残破的大教堂			预设: quagmire_rubble_cathedral		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	

------------------------------------------------	
鱼丸串			预设: quagmire_food_009		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
土豆汤			预设: quagmire_food_008		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
小龙蝇			预设: critter_dragonling		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "idle", "small_livestock", "NOBLOCK", "locomotor", "OMNI_eater", "_follower", "flying", "ignorewalkableplatformdrowning", "critter", "sleeper", "noauradamage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("dragonling_build")	
			Anim路径 :  "anim/dragonling_basic.zip"	
 	
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
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
石化树			预设: rock_petrified_tree		路径： [string "scripts/prefabs/rocks.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("petrified_tree")	
			inst.AnimState:SetBuild("petrified_tree")	
			Anim路径 :  "anim/petrified_tree.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
触手皮			预设: tentaclespots		路径： [string "scripts/prefabs/tentaclespots.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tentaclespots")	
			inst.AnimState:SetBuild("tentaclespots")	
			Anim路径 :  "anim/tentaclespots.zip"	
 	
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
射手三明治			预设: quagmire_food_061		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
糖木树			预设: quagmire_sugarwoodtree		路径： [string "scripts/prefabs/quagmire_sugarwoodtree.lua"]	
	Tags▼	
	{":", "tappable", "tree", "sugarwoodtree", "plant", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
辣鳗鱼料理			预设: unagi_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
 			预设: construction_container		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_container", "bundle"}	
 	
	使用的组件▼	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
MISSING NAME			预设: cavein_dust_low		路径： [string "scripts/prefabs/cavein_boulder.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cavein_dust_fx")	
			inst.AnimState:SetBuild("cavein_dust_fx")	
			Anim路径 :  "anim/cavein_dust_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_speed_buff		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
巨型辣椒			预设: pepper_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_pepper")	
			Anim路径 :  "anim/farm_plant_pepper.zip"	
 	
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
MISSING NAME			预设: groundpound_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
石笋			预设: stalagmite_tall_med		路径： [string "scripts/prefabs/stalagmite_tall.lua"]	
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
MISSING NAME			预设: quagmire_garlic_leaf		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
胡萝卜			预设: quagmire_carrot		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
绽放花环			预设: lavaarena_healinggarlandhat		路径： [string "scripts/prefabs/hats_lavaarena.lua"]	
	Tags▼	
	{":", "hat"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
不屈药剂			预设: ghostlyelixir_shield		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
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
雪球发射器			预设: firesuppressor		路径： [string "scripts/prefabs/firesuppressor.lua"]	
	Tags▼	
	{":", "BURNABLE_fueled", "inspectable", "FROMNUM", "idle", "hasemergencymode", "turnedon", "CHEMICAL_fueled", "HAMMER_workable", "cooldown", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firefighter")	
			inst.AnimState:SetBuild("firefighter")	
			Anim路径 :  "anim/firefighter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("firedetector")	
		inst:AddComponent("workable")	
		inst:AddComponent("machine")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("deployhelper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
	SG = 有▼	
------------------------------------------------	
切斯特			预设: chester		路径： [string "scripts/prefabs/chester.lua"]	
	Tags▼	
	{":", "notraptrigger", "_health", "inspectable", "companion", "_container", "idle", "_combat", "locomotor", "scarytoprey", "nolight", "_follower", "chester", "character", "sleeper", "noauradamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("chester")	
			inst.AnimState:SetBuild("chester_build")	
			Anim路径 :  "anim/chester.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("maprevealable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("container")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("drownable")	
		
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
钢羊			预设: spat		路径： [string "scripts/prefabs/spat.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "spat", "_health", "inspectable", "freezable", "idle", "_inventory", "_combat", "locomotor", "nolight", "largecreature", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spat")	
			inst.AnimState:SetBuild("spat_build")	
			Anim路径 :  "anim/spat_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inventory")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("eater")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	

------------------------------------------------	
华丽丝带盔甲			预设: lavaarena_armor_hprecharger		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "hide_percentage", "metal", "ruins"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
岩石地皮			预设: turf_rocky		路径： [string "scripts/prefabs/turfs.lua"]	
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
MISSING NAME			预设: spellmasteryorb		路径： [string "scripts/prefabs/spellmasterybuff.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_arcane_orb")	
			inst.AnimState:SetBuild("lavaarena_arcane_orb")	
			Anim路径 :  "anim/lavaarena_arcane_orb.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
暗影挖掘者			预设: shadowdigger_builder		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_spawnerdecor_fx_3		路径： [string "scripts/prefabs/lavaarena_creature_spawn_fx..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
嗡嗡蜜蜂			预设: beeguard		路径： [string "scripts/prefabs/beeguard.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "FROMNUM", "freezable", "bee", "idle", "insect", "hostile", "_combat", "locomotor", "scarytoprey", "nolight", "flying", "ignorewalkableplatformdrowning", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("bee_guard_build")	
			Anim路径 :  "anim/bee_guard.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("lostcommander")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("gotcommander")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("on_no_longer_landed")	
	SG = 有▼	
------------------------------------------------	
帝王蟹雕塑			预设: chesspiece_crabking		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_crabking_marble")	
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
毛皮铺盖			预设: bedroll_furry		路径： [string "scripts/prefabs/bedroll.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("swap_bedroll_furry")	
			inst.AnimState:SetBuild("swap_bedroll_furry")	
			Anim路径 :  "anim/swap_bedroll_furry.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("sleepingbag")	
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
毒菌蟾蜍雕塑			预设: chesspiece_toadstool		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_toadstool_marble")	
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
MISSING NAME			预设: propsignshatterfx		路径： [string "scripts/prefabs/propsign.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_elite")	
			inst.AnimState:SetBuild("sign_elite")	
			Anim路径 :  "anim/sign_elite.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: petrified_tree_fx_old		路径： [string "scripts/prefabs/petrify_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: monkeybarrel_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
彩虹糖豆			预设: jellybean		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "canlight", "preparedfood", "edible_GOODIES"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
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
蓝蘑菇树			预设: mushtree_tall		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "mushtree", "tree", "plant", "webbable", "DIG_workable", "canlight", "stump", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("mushroom_tree_tall")	
			Anim路径 :  "anim/mushroom_tree_tall.zip"	
 	
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
苏打鱼			预设: lutefisk		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
骑士雕塑			预设: chesspiece_knight		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_knight_moonglass")	
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
蓝色猎犬			预设: icehound		路径： [string "scripts/prefabs/hound.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "scarytooceanprey", "hostile", "strongstomach", "HORRIBLE_eater", "_combat", "MEAT_eater", "locomotor", "canbestartled", "sanityaura", "scarytoprey", "nolight", "_follower", "sleeper", "hound"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hound")	
			inst.AnimState:SetBuild("hound_ice_ocean")	
			Anim路径 :  "anim/hound_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("combat")	
		inst:AddComponent("amphibiouscreature")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("eater")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
		inst:AddComponent("spawnfader")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("stopfollowing")	
		inst:ListenForEvent("onattackother")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("startfollowing")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("spawnedfromhaunt")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: wave_shimmer_med		路径： [string "scripts/prefabs/wave_shimmer.lua"]	
	Tags▼	
	{":", "fx", "CLASSIFIED", "NOBLOCK", "ignorewalkableplatforms", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wave_shimmer_med")	
			Anim路径 :  "anim/wave_shimmer_med.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
便携烹饪锅			预设: portablecookpot_item		路径： [string "scripts/prefabs/portablecookpot.lua"]	
	Tags▼	
	{":", "_inventoryitem", "portableitem", "inspectable", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("portable_cook_pot")	
			inst.AnimState:SetBuild("portable_cook_pot")	
			Anim路径 :  "anim/portable_cook_pot.zip"	
 	
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
甜花式回旋块茎			预设: potatotornado_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: shadow_shield1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
蝙蝠洞			预设: batcave		路径： [string "scripts/prefabs/batcave.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("batcave")	
			inst.AnimState:SetBuild("batcave")	
			Anim路径 :  "anim/batcave.zip"	
 	
	使用的组件▼	
		inst:AddComponent("playerprox")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	

------------------------------------------------	
阿比盖尔			预设: lavaarena_abigail		路径： [string "scripts/prefabs/lavaarena_abigail.lua"]	
	Tags▼	
	{":", "notraptrigger", "FROMNUM", "companion", "abigail", "ghost", "NOBLOCK", "scarytoprey", "NOCLICK", "character", "girl", "noauradamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ghost")	
			inst.AnimState:SetBuild("ghost_abigail_build")	
			Anim路径 :  "anim/player_ghost_withhat.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
辣无花果蛙腿三明治			预设: frognewton_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
花伞			预设: grass_umbrella		路径： [string "scripts/prefabs/umbrella.lua"]	
	Tags▼	
	{":", "_inventoryitem", "umbrella", "inspectable", "waterproofer", "BURNABLE_fuel", "canlight", "show_spoilage", "_equippable", "nopunch", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("parasol")	
			inst.AnimState:SetBuild("parasol")	
			Anim路径 :  "anim/parasol.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
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
MISSING NAME			预设: wall_stone_2_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wall_stone_2")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	

------------------------------------------------	
MISSING NAME			预设: rhinodrill_fossilized_break_fx		路径： [string "scripts/prefabs/lavaarena_rhinodrill.lua"]	
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
蒜香藤壶握寿司			预设: barnaclesushi_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
幸运黄金			预设: lucky_goldnugget		路径： [string "scripts/prefabs/goldnugget.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_ELEMENTAL"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goldnugget")	
			inst.AnimState:SetBuild("gold_nugget")	
			Anim路径 :  "anim/gold_nugget.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
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
		inst:ListenForEvent("knockbackdropped")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
巨型腐烂洋葱			预设: onion_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_onion_build")	
			Anim路径 :  "anim/farm_plant_pumpkin.zip"	
 	
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
MISSING NAME			预设: lavaarena_firebomb_explosion		路径： [string "scripts/prefabs/lavaarena_firebomb.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_firebomb")	
			inst.AnimState:SetBuild("lavaarena_firebomb")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: weed_forgetmelots_respawner		路径： [string "scripts/prefabs/forgetmelots.lua"]	
	Tags▼	
	{":", "CLASSIFIED", "NOBLOCK", "weed_forgetmelots_respawner"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: miniflare_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flare")	
			inst.AnimState:SetBuild("flare")	
			Anim路径 :  "anim/flare.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
化石笼子			预设: fossilspike		路径： [string "scripts/prefabs/fossil_spike.lua"]	
	Tags▼	
	{":", "groundspike", "fossilspike", "_combat", "notarget"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fossil_spike")	
			inst.AnimState:SetBuild("fossil_spike")	
			Anim路径 :  "anim/fossil_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
------------------------------------------------	
克劳斯雕塑			预设: chesspiece_klaus		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_klaus_moonglass")	
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
缠绕根须			预设: ivy_snare		路径： [string "scripts/prefabs/ivy_snare.lua"]	
	Tags▼	
	{":", "groundspike", "_health", "inspectable", "hostile", "_combat", "canlight", "soulless", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("weed_ivy")	
			inst.AnimState:SetBuild("weed_ivy")	
			Anim路径 :  "anim/weed_ivy.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
黄金弹药			预设: slingshotammo_gold		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
比利			预设: quagmire_goatkid		路径： [string "scripts/prefabs/quagmire_goatkid.lua"]	
	Tags▼	
	{":", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("talker")	
		
------------------------------------------------	
MISSING NAME			预设: winters_feast_food_depleted		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
迅捷气球			预设: balloonspeed		路径： [string "scripts/prefabs/balloonspeed.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "noepicmusic", "_combat", "cattoyairborne", "_equippable", "nopunch", "balloon", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("balloon2")	
			inst.AnimState:SetBuild("balloon2")	
			Anim路径 :  "anim/balloon2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("poppable")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fueled")	
		inst:AddComponent("health")	
		inst:AddComponent("equippable")	
		
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
MISSING NAME			预设: year_of_the_beefalo_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜素食堡			预设: leafymeatburger_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: weregoose_transform_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣椒炖肉			预设: hotchili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣华夫饼			预设: waffles_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: globalmapicon		路径： [string "scripts/prefabs/globalmapicon.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
圣诞小玩意			预设: winter_ornament_plain2		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
夹夹绞盘			预设: winch		路径： [string "scripts/prefabs/winch.lua"]	
	Tags▼	
	{":", "inspectable", "standingactivation", "winch_ready", "HAMMER_workable", "_inventory", "can_use_heavy", "canlight", "structure", "inactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_winch")	
			inst.AnimState:SetBuild("boat_winch")	
			Anim路径 :  "anim/boat_winch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("workable")	
		inst:AddComponent("heavyobstacleusetarget")	
		inst:AddComponent("activatable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("winch")	
		inst:AddComponent("boatdrag")	
		inst:AddComponent("shelf")	
		
	使用的监听▼	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("ondeconstructstructure")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
彩虹宝石			预设: opalpreciousgem		路径： [string "scripts/prefabs/gem.lua"]	
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
铁栅栏			预设: quagmire_parkspike		路径： [string "scripts/prefabs/quagmire_parkspike.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: winona_catapult_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_catapult_placement")	
			inst.AnimState:SetBuild("winona_catapult_placement")	
			Anim路径 :  "anim/winona_catapult_placement.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
骷髅			预设: skeleton_player		路径： [string "scripts/prefabs/skeleton.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "playerskeleton", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("skeleton")	
			inst.AnimState:SetBuild("skeletons")	
			Anim路径 :  "anim/skeletons.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playeravatardata")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: forcefieldfx		路径： [string "scripts/prefabs/forcefieldfx.lua"]	
	Tags▼	
	{":", "FROMNUM"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("forcefield")	
			inst.AnimState:SetBuild("forcefield")	
			Anim路径 :  "anim/forcefield.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pigtorch_fuel		路径： [string "scripts/prefabs/pigtorch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "pigtorch_fuel"}	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
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
大理石弹			预设: slingshotammo_marble		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
MISSING NAME			预设: reticuleaoeping		路径： [string "scripts/prefabs/reticuleaoe.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticuleaoe")	
			inst.AnimState:SetBuild("reticuleaoe")	
			Anim路径 :  "anim/reticuleaoe.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fx_boat_crackle		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
芦笋种子			预设: asparagus_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
爆米花鱼			预设: oceanfish_small_5		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_veggie", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_small_5", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming", "VEGETARIAN_eater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_5")	
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
蒜香酿鱼头			预设: barnaclestuffedfishhead_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
查理的胡萝卜鼠			预设: carrat_ghostracer		路径： [string "scripts/prefabs/carrat_ghostracer.lua"]	
	Tags▼	
	{":", "busy", "inspectable", "shadow", "noattack", "locomotor"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carrat")	
			inst.AnimState:SetBuild("carrat_shadow_build")	
			Anim路径 :  "anim/carrat_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("yotc_racecompetitor")	
		inst:AddComponent("yotc_racestats")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("musicstatedirty")	
	SG = 有▼	
------------------------------------------------	
咸的牛肉绿叶菜			预设: meatysalad_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: bile_puddle_water		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
刺针旋花			预设: weed_ivy		路径： [string "scripts/prefabs/weed_plants.lua"]	
	Tags▼	
	{":", "weed_ivy", "inspectable", "plantedsoil", "farm_plant_killjoy", "farm_plant", "plantresearchable", "plant", "DIG_workable", "canlight", "weed", "tendable_farmplant", "weedplantstress"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("weed_ivy")	
			inst.AnimState:SetBuild("weed_ivy")	
			Anim路径 :  "anim/weed_ivy.zip"	
 	
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
		inst:ListenForEvent("defend_farm_plant")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
花瓣			预设: petals		路径： [string "scripts/prefabs/petals.lua"]	
	Tags▼	
	{":", "_inventoryitem", "vasedecoration", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "BURNABLE_fuel", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("petals")	
			inst.AnimState:SetBuild("flower_petals")	
			Anim路径 :  "anim/flower_petals.zip"	
 	
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
MISSING NAME			预设: ocean_splash_med1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: goosplash5		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蓝宝石			预设: bluegem		路径： [string "scripts/prefabs/gem.lua"]	
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
MISSING NAME			预设: dirt_puff		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香蘑菇蛋糕			预设: shroomcake_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: moonpulse_spawner		路径： [string "scripts/prefabs/moonpulse.lua"]	
	Tags▼	
	{":", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
熔岩椒			预设: halloweencandy_14		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
MISSING NAME			预设: lucy_classified		路径： [string "scripts/prefabs/lucy_classified.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香太妃糖			预设: taffy_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
盛夏夜灯套装			预设: carnivaldecor_lamp_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_lamp")	
			inst.AnimState:SetBuild("carnivaldecor_lamp")	
			Anim路径 :  "anim/carnivaldecor_lamp.zip"	
 	
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
咸的奶油土豆泥			预设: mashedpotatoes_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
鱼食			预设: chum		路径： [string "scripts/prefabs/chum.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "allow_action_on_impassable", "_stackable", "locomotor", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("chum_pouch")	
			inst.AnimState:SetBuild("chum_pouch")	
			Anim路径 :  "anim/chum_pouch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("reticule")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("floater")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("forcecompostable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("stackable")	
		inst:AddComponent("oceanthrowable")	
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
MISSING NAME			预设: bile_puddle_land		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
鱼饼			预设: quagmire_food_017		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
树果酱			预设: treegrowthsolution		路径： [string "scripts/prefabs/treegrowthsolution.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_patch", "tile_deploy", "inspectable", "allow_action_on_impassable", "_stackable", "health_wood", "fertilizer", "fertilizerresearchable", "deployable", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("treegrowthsolution")	
			inst.AnimState:SetBuild("treegrowthsolution")	
			Anim路径 :  "anim/treegrowthsolution.zip"	
 	
	使用的组件▼	
		inst:AddComponent("repairer")	
		inst:AddComponent("boatpatch")	
		inst:AddComponent("fertilizerresearchable")	
		inst:AddComponent("treegrowthsolution")	
		inst:AddComponent("deployable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fertilizer")	
		inst:AddComponent("stackable")	
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
MISSING NAME			预设: redlanternbody		路径： [string "scripts/prefabs/redlantern.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("redlantern")	
			inst.AnimState:SetBuild("redlantern")	
			Anim路径 :  "anim/redlantern.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
辣什锦干果			预设: trailmix_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: battlesong_instant_panic_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
熟石果			预设: rock_avocado_fruit_ripe_cooked		路径： [string "scripts/prefabs/rock_avocado_fruit.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_fruit_build")	
			Anim路径 :  "anim/rock_avocado_fruit.zip"	
 	
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
MISSING NAME			预设: year_of_the_pig_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	

------------------------------------------------	
浆果挞			预设: quagmire_food_045		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蜗牛龟			预设: snurtle		路径： [string "scripts/prefabs/slurtle.lua"]	
	Tags▼	
	{":", "cavedweller", "_health", "inspectable", "freezable", "idle", "explosive", "_inventory", "_combat", "locomotor", "nolight", "snurtle", "ELEMENTAL_eater", "animal"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("snurtle")	
			inst.AnimState:SetBuild("slurtle_snaily")	
			Anim路径 :  "anim/slurtle_snaily.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("thief")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("explosive")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("ifnotchanceloot")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
	SG = 有▼	

------------------------------------------------	
骨灰瓮			预设: quagmire_park_urn		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
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
甜酿茄子			预设: stuffedeggplant_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的加州卷			预设: californiaroll_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
损坏的发条骑士			预设: knight_nightmare		路径： [string "scripts/prefabs/knight.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "freezable", "idle", "chess", "hostile", "_combat", "locomotor", "nolight", "_follower", "knight", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("knight")	
			inst.AnimState:SetBuild("knight_nightmare")	
			Anim路径 :  "anim/knight.zip"	
 	
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
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("firedamage")	
	SG = 有▼	
------------------------------------------------	
辣藤壶握寿司			预设: barnaclesushi_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
影子分身			预设: shadowminer		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
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
洞			预设: toadstool_cap		路径： [string "scripts/prefabs/toadstool_cap.lua"]	
	Tags▼	
	{":", "inspectable", "event_trigger", "absorbpoison", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("toadstool")	
			inst.AnimState:SetBuild("toadstool_build")	
			Anim路径 :  "anim/toadstool_actions.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_spawntoadstool")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
爬行梦魇			预设: crawlingnightmare		路径： [string "scripts/prefabs/nightmarecreature.lua"]	
	Tags▼	
	{":", "busy", "notraptrigger", "monster", "_health", "shadow", "hostile", "_combat", "locomotor", "gestaltnoloot", "sanityaura", "nightmarecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_insanity1_basic")	
			Anim路径 :  "anim/shadow_insanity1_basic.zip"	
 	
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
烤绿蘑菇			预设: green_cap_cooked		路径： [string "scripts/prefabs/mushrooms.lua"]	
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
破碎蜘蛛			预设: spider_moon		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "spider_moon", "sanityaura", "scarytoprey", "nolight", "_follower", "show_spoilage", "drop_inventory_onmurder", "sleeper", "eatsrawmeat", "spider", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_moon")	
			inst.AnimState:SetBuild("DS_spider_moon")	
			Anim路径 :  "anim/ds_spider_moon.zip"	
 	
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
MISSING NAME			预设: knight_nightmare_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
辣花沙拉			预设: flowersalad_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
彩带大炮			预设: carnivalcannon_streamer		路径： [string "scripts/prefabs/carnival_cannons.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "carnivaldecor", "carnivalcannon", "HAMMER_workable", "quickactivation", "canlight", "structure", "inactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon_streamer")	
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
咸的蜜汁火腿			预设: honeyham_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
薇洛			预设: willow		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "bernieowner", "pyromaniac", "player", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "expertchef", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser", "heatresistant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("willow")	
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
		inst:AddComponent("fuelmaster")	
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
蛞蝓龟			预设: slurtle		路径： [string "scripts/prefabs/slurtle.lua"]	
	Tags▼	
	{":", "cavedweller", "_health", "inspectable", "freezable", "idle", "explosive", "_inventory", "_combat", "locomotor", "slurtle", "nolight", "ELEMENTAL_eater", "animal"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slurtle")	
			inst.AnimState:SetBuild("slurtle")	
			Anim路径 :  "anim/slurtle.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("thief")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("explosive")	
		inst:AddComponent("periodicspawner")	
		inst:AddComponent("eater")	
		
	使用的监听▼	
		inst:ListenForEvent("ifnotchanceloot")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
天体传送门			预设: multiplayer_portal_moonrock		路径： [string "scripts/prefabs/multiplayer_portal.lua"]	
	Tags▼	
	{":", "inspectable", "idle", "multiplayer_portal", "antlion_sinkhole_blocker", "moonportal", "moontrader"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("portal_moonrock")	
			Anim路径 :  "anim/portal_moonrock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("moontrader")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("ms_playerjoined")	
		inst:ListenForEvent("ms_newplayerspawned")	
		inst:ListenForEvent("ms_newplayercharacterspawned")	
		inst:ListenForEvent("rez_player")	
	SG = 有▼	

------------------------------------------------	
胡萝卜汤			预设: quagmire_food_016		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型腐烂西瓜			预设: watermelon_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_watermelon_build")	
			Anim路径 :  "anim/farm_plant_tomato.zip"	
 	
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
蒜香骨头汤			预设: bonesoup_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: deer_fire_flakes		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_fire_flakes")	
			inst.AnimState:SetBuild("deer_fire_flakes")	
			Anim路径 :  "anim/deer_fire_flakes.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香果酱			预设: jammypreserves_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
月岩企鸥			预设: mutated_penguin		路径： [string "scripts/prefabs/penguin.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "_inventory", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "locomotor", "OMNI_eater", "sanityaura", "scarytoprey", "nolight", "penguin", "team_penguin", "_hunger", "herdmember", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("penguin")	
			inst.AnimState:SetBuild("penguin_mutated_build")	
			Anim路径 :  "anim/penguin.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("herdmember")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("homeseeker")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hunger")	
		inst:AddComponent("teamattacker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("inventory")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("health")	
		
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
精神病实验			预设: halloween_experiment_sanity		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: singingshell_creature_woodfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
懒人魔杖			预设: orangestaff		路径： [string "scripts/prefabs/staff.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "nopunch"}	
 	
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
		inst:AddComponent("blinkstaff")	
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
烤土豆			预设: potato_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("potato")	
			inst.AnimState:SetBuild("potato")	
			Anim路径 :  "anim/potato.zip"	
 	
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
骑士雕塑			预设: chesspiece_knight_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
露西斧			预设: lucy		路径： [string "scripts/prefabs/lucy.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "tool", "sharp", "_equippable", "CHOP_tool", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("Lucy_axe")	
			inst.AnimState:SetBuild("Lucy_axe")	
			Anim路径 :  "anim/lucy_axe.zip"	
 	
	使用的组件▼	
		inst:AddComponent("possessedaxe")	
		inst:AddComponent("equippable")	
		inst:AddComponent("talker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("sentientaxe")	
		inst:AddComponent("tool")	
		inst:AddComponent("weapon")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("axepossessedbyplayer")	
		inst:ListenForEvent("axerejectedotheraxe")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("donetalking")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("axerejectedowner")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ontalk")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
方向舵套装			预设: steeringwheel_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_accessory", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seafarer_wheel")	
			inst.AnimState:SetBuild("seafarer_wheel")	
			Anim路径 :  "anim/seafarer_wheel.zip:IDLE"	
 	
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
磨损的纱线			预设: trinket_22		路径： [string "scripts/prefabs/trinkets.lua"]	
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
茄子种子			预设: eggplant_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
MISSING NAME			预设: wormwarning_lvl2		路径： [string "scripts/prefabs/wormwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
蒜蓉面包			预设: quagmire_food_025		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
曼德拉草汤			预设: mandrakesoup		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: crater_steam_fx4		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蘑菇农场			预设: mushroom_farm		路径： [string "scripts/prefabs/mushroom_farm.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "mushroom_farm", "alltrader", "HAMMER_workable", "playerowned", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_farm")	
			inst.AnimState:SetBuild("mushroom_farm")	
			Anim路径 :  "anim/mushroom_farm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("harvestable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: archive_dispencer_sfx		路径： [string "scripts/prefabs/archive_lockbox.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	

------------------------------------------------	
MISSING NAME			预设: lavaarena_floorgrate		路径： [string "scripts/prefabs/lavaarena_floorgrate.lua"]	
	Tags▼	
	{":", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_floorgrate")	
			inst.AnimState:SetBuild("lavaarena_floorgrate")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蜘蛛帽			预设: spiderhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spiderhat")	
			inst.AnimState:SetBuild("hat_spider")	
			Anim路径 :  "anim/hat_spider.zip"	
 	
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
MISSING NAME			预设: burntstick		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_fest_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sinkhole_spawn_fx_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: splash_green		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
岩石			预设: rock_flintless_low		路径： [string "scripts/prefabs/rocks.lua"]	
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
MISSING NAME			预设: minisign_drawn_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_mini")	
			inst.AnimState:SetBuild("sign_mini")	
			Anim路径 :  "anim/sign_mini.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
三文鱼苗			预设: oceanfish_small_4_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_4")	
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
MISSING NAME			预设: quagmire_tomato_leaf		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
雷电吹箭			预设: blowdart_yellow		路径： [string "scripts/prefabs/blowdart.lua"]	
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
MISSING NAME			预设: boatlip		路径： [string "scripts/prefabs/boatlip.lua"]	
	Tags▼	
	{":", "DECOR", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_test")	
			Anim路径 :  "anim/boat_test.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
寒霜礼服款式			预设: ice_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
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
种子荚			预设: quagmire_seeds_7		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
辣无花果酿树干			预设: koalefig_trunk_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
                      Event data unavailable: lavaarena_event_server/prefabs/blowdart_lava2
------------------------------------------------	
MISSING NAME			预设: blowdart_lava2_projectile		路径： [string "scripts/prefabs/blowdart_lava2.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_blowdart_attacks")	
			inst.AnimState:SetBuild("lavaarena_blowdart_attacks")	
			Anim路径 :  "anim/lavaarena_blowdart_attacks.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: farmrockflat		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
微型树			预设: carnivaldecor_plant		路径： [string "scripts/prefabs/carnival_decor.lua"]	
	Tags▼	
	{":", "inspectable", "carnivaldecor", "HAMMER_workable", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivaldecor_plant")	
			inst.AnimState:SetBuild("carnivaldecor_plant")	
			Anim路径 :  "anim/carnivaldecor_plant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("carnivaldecor")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
甜南瓜饼干			预设: pumpkincookie_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: goosplash7		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sphua		路径： [string "../mods/KongZhiTai/scripts/prefabs/hua.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
奇形鸟			预设: bird_mutant_spitter		路径： [string "scripts/prefabs/birds_mutant.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "monster", "_health", "SEEDS_eater", "freezable", "idle", "small_livestock", "hostile", "NOBLOCK", "_combat", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "bird_mutant_spitter", "show_spoilage", "soulless", "sleeper", "bird_mutant", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mutated_robin")	
			inst.AnimState:SetBuild("bird_mutant_spitter_build")	
			Anim路径 :  "anim/mutated_robin.zip"	
 	
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
果冻沙拉			预设: leafymeatsouffle		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
看不见的手			预设: shadowchanneler		路径： [string "scripts/prefabs/shadowchanneler.lua"]	
	Tags▼	
	{":", "notraptrigger", "monster", "_health", "shadow", "hostile", "_combat", "sanityaura", "notarget", "shadowcreature", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadow_channeler")	
			inst.AnimState:SetBuild("shadow_channeler")	
			Anim路径 :  "anim/shadow_channeler.zip"	
 	
	使用的组件▼	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("health")	
		inst:AddComponent("transparentonsanity")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("combat")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("gotcommander")	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("lostcommander")	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: hallowed_nights_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鹿角			预设: deer_antler2		路径： [string "scripts/prefabs/deer_antler.lua"]	
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
MISSING NAME			预设: ghostlyelixir_fastregen_dripfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
小钢羊			预设: critter_lamb_builder		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: slingshotammo_slow_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
发芽的石果			预设: rock_avocado_fruit_sprout_sapling		路径： [string "scripts/prefabs/rock_avocado_fruit.lua"]	
	Tags▼	
	{":", "inspectable", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_fruit_build")	
			Anim路径 :  "anim/rock_avocado_fruit.zip"	
 	
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
------------------------------------------------	
辣蝴蝶松饼			预设: butterflymuffin_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
喷泉			预设: quagmire_park_fountain		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
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
起点			预设: yotc_carrat_race_start		路径： [string "scripts/prefabs/yotc_carrat_race_start.lua"]	
	Tags▼	
	{":", "inspectable", "yotc_racestart", "HAMMER_workable", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_race_start")	
			inst.AnimState:SetBuild("yotc_carrat_race_start")	
			Anim路径 :  "anim/yotc_carrat_race_start.zip"	
 	
	使用的组件▼	
		inst:AddComponent("yotc_racestart")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("deployhelper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("yotc_race_over")	
------------------------------------------------	
辣海鲜牛排			预设: surfnturf_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: icebox_victorian_frost_fx		路径： [string "scripts/prefabs/icebox_victorian_frost_fx.l..."]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("icebox_victorian")	
			inst.AnimState:SetBuild("ice_box")	
			Anim路径 :  "anim/dynamic/icebox_victorian.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
荧光花			预设: flower_cave_triple		路径： [string "scripts/prefabs/flower_cave.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "halloweenmoonmutable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bulb_plant_triple")	
			inst.AnimState:SetBuild("bulb_plant_triple")	
			Anim路径 :  "anim/bulb_plant_triple.zip"	
 	
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
猎犬雕塑			预设: chesspiece_clayhound		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_clayhound_marble")	
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
MISSING NAME			预设: pillar_cave		路径： [string "scripts/prefabs/pillar.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_cave")	
			inst.AnimState:SetBuild("pillar_cave")	
			Anim路径 :  "anim/pillar_cave.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pottedfern_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cave_ferns_potted")	
			Anim路径 :  "anim/cave_ferns_potted.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
木板			预设: walkingplank		路径： [string "scripts/prefabs/walkingplank.lua"]	
	Tags▼	
	{":", "interactable", "inspectable", "walkingplank", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_plank_build")	
			Anim路径 :  "anim/boat_plank.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("walkingplank")	
		
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: hermit_bundle_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: waterballoon_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
斑鱼			预设: oceanfish_medium_2		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "MEAT_eater", "locomotor", "herd_oceanfish_medium_2", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_2")	
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
锚雕塑			预设: chesspiece_anchor		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_anchor_marble")	
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
远古守护者雕塑			预设: chesspiece_minotaur		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_minotaur_marble")	
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
远古伪科学站			预设: ancient_altar		路径： [string "scripts/prefabs/altar_prototyper.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "altar", "structure", "stone", "prototyper", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crafting_table")	
			inst.AnimState:SetBuild("crafting_table")	
			Anim路径 :  "anim/crafting_table.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	

------------------------------------------------	
螃蟹陷阱			预设: quagmire_crabtrap		路径： [string "scripts/prefabs/quagmire_crabtrap.lua"]	
	Tags▼	
	{":", "trap"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sinkhole_warn_fx_3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
披萨			预设: quagmire_food_057		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
多用斧镐			预设: multitool_axe_pickaxe		路径： [string "scripts/prefabs/axe_pickaxe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "MINE_tool", "inspectable", "tool", "sharp", "_equippable", "CHOP_tool", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("multitool_axe_pickaxe")	
			inst.AnimState:SetBuild("multitool_axe_pickaxe")	
			Anim路径 :  "anim/multitool_axe_pickaxe.zip"	
 	
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
沙滩玩具			预设: antliontrinket		路径： [string "scripts/prefabs/antliontrinket.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("antliontrinket")	
			inst.AnimState:SetBuild("antliontrinket")	
			Anim路径 :  "anim/antliontrinket.zip"	
 	
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
酿鱼头			预设: barnaclestuffedfishhead		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: abigailsummonfx		路径： [string "scripts/prefabs/abigail_flower.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wendy_channel_flower")	
			inst.AnimState:SetBuild("wendy_channel_flower")	
			Anim路径 :  "anim/wendy_channel_flower.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: shadow_shield4		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
铥矿徽章			预设: nightmare_timepiece		路径： [string "scripts/prefabs/nightmare_timepiece.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("nightmare_timepiece")	
			Anim路径 :  "anim/nightmare_timepiece.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
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
夜间旋转亮片			预设: oceanfishinglure_spinner_blue		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
MISSING NAME			预设: malbatross_ripple		路径： [string "scripts/prefabs/malbatross.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("malbatross_ripple")	
			inst.AnimState:SetBuild("malbatross_ripple")	
			Anim路径 :  "anim/malbatross_ripple.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	

------------------------------------------------	
旧硬币			预设: quagmire_coin1		路径： [string "scripts/prefabs/quagmire_coins.lua"]	
	Tags▼	
	{":", "quagmire_coin"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜牛肉绿叶菜			预设: meatysalad_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
遗物复制品 盘子			预设: ruinsrelic_chipbowl		路径： [string "scripts/prefabs/ruinsrelic.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_chipbowl")	
			inst.AnimState:SetBuild("ruins_chipbowl")	
			Anim路径 :  "anim/ruins_chipbowl.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
甜果冻沙拉			预设: leafymeatsouffle_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
召唤之书			预设: book_elemental		路径： [string "scripts/prefabs/books_lavaarena.lua"]	
	Tags▼	
	{":", "book", "rechargeable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("book_elemental")	
			inst.AnimState:SetBuild("book_elemental")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
MISSING NAME			预设: rubble1		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	

------------------------------------------------	
奶油宽意面			预设: quagmire_food_053		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的辣椒炖肉			预设: hotchili_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
巨型火龙果			预设: dragonfruit_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_dragonfruit_build")	
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
月蛾雕塑			预设: chesspiece_butterfly		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_butterfly_marble")	
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
华丽巨齿铠甲			预设: lavaarena_armor_hpdamager		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "hide_percentage", "metal", "ruins"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
藤壶			预设: barnacle		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "selfstacker", "rawmeat", "barnacle", "_stackable", "badfood", "cookable", "fresh"}	
 	
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
		inst:AddComponent("cookable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("selfstacker")	
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
蚁头凤尾鱼			预设: antchovies		路径： [string "scripts/prefabs/antchovies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("antchovy")	
			inst.AnimState:SetBuild("antchovy")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("stackable")	
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
烤番茄			预设: quagmire_tomato_cooked		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜火龙果派			预设: dragonpie_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蚁狮雕塑			预设: chesspiece_antlion		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_antlion_marble")	
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
烹饪锅			预设: cookpot		路径： [string "scripts/prefabs/cookpot.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "stewer", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot")	
			inst.AnimState:SetBuild("cook_pot")	
			Anim路径 :  "anim/cookpot_archive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("stewer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
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
无眼鹿			预设: deer_blue		路径： [string "scripts/prefabs/deer.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "idle", "deer", "_combat", "locomotor", "nolight", "deergemresistance", "animal", "sleeper"}	
 	
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
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
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
姜饼猪			预设: gingerdeadpig		路径： [string "scripts/prefabs/gingerbreadpig.lua"]	
	Tags▼	
	{":", "DECOR", "idle", "locomotor", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gingerbread_pigman")	
			inst.AnimState:SetBuild("gingerbread_pigman")	
			Anim路径 :  "anim/gingerbread_pigman.zip"	
 	
	使用的组件▼	
		inst:AddComponent("locomotor")	
		
	SG = 有▼	
------------------------------------------------	
暗影秘典			预设: waxwelljournal		路径： [string "scripts/prefabs/waxwelljournal.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight", "shadowmagic", "prototyper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("book_maxwell")	
			inst.AnimState:SetBuild("book_maxwell")	
			Anim路径 :  "anim/book_maxwell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("prototyper")	
		
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
MISSING NAME			预设: yellow_leaves		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: spat_splat_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: arrowsign_panel_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_arrow_panel")	
			inst.AnimState:SetBuild("sign_arrow_panel")	
			Anim路径 :  "anim/sign_arrow_panel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
月亮虹吸器			预设: moon_device_construction2		路径： [string "scripts/prefabs/moon_device.lua"]	
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
海象牙			预设: walrus_tusk		路径： [string "scripts/prefabs/walrus_tusk.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("walrus_tusk")	
			inst.AnimState:SetBuild("walrus_tusk")	
			Anim路径 :  "anim/walrus_tusk.zip"	
 	
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
考拉象			预设: koalefant_summer		路径： [string "scripts/prefabs/koalefant.lua"]	
	Tags▼	
	{":", "VEGGIE_eater", "_health", "inspectable", "freezable", "idle", "_combat", "locomotor", "nolight", "largecreature", "animal", "saltlicker", "sleeper", "koalefant"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("koalefant")	
			inst.AnimState:SetBuild("koalefant_summer_build")	
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
无眼鹿			预设: deer		路径： [string "scripts/prefabs/deer.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "deer", "_combat", "locomotor", "nolight", "animal", "saltlicker", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer")	
			inst.AnimState:SetBuild("deer_build")	
			Anim路径 :  "anim/deer_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("saltlicker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("timer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("saltlick_placed")	
		inst:ListenForEvent("queuegrowantler")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("deerherdmigration")	
		inst:ListenForEvent("freeze")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("unfreeze")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("gotosleep")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
烤怪物肉			预设: cookedmonstermeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "monstermeat", "badfood", "fresh"}	
 	
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
带斑点的小灌木			预设: quagmire_spotspice_shrub		路径： [string "scripts/prefabs/quagmire_spiceshrub.lua"]	
	Tags▼	
	{":", "quagmire_wildplant", "plant", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sounddebugicon		路径： [string "scripts/prefabs/sounddebugicon.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("sounddebug")	
			Anim路径 :  "anim/sounddebug.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: electricchargedfx		路径： [string "scripts/prefabs/electric_charged_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
草甲			预设: armorgrass		路径： [string "scripts/prefabs/armor_grass.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "grass", "BURNABLE_fuel", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_grass")	
			inst.AnimState:SetBuild("armor_grass")	
			Anim路径 :  "anim/armor_grass.zip"	
 	
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
MISSING NAME			预设: yotc_carrat_scale_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_scale")	
			inst.AnimState:SetBuild("yotc_carrat_scale")	
			Anim路径 :  "anim/yotc_carrat_scale.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
俗气鹿像			预设: wereitem_moose		路径： [string "scripts/prefabs/wereitems.lua"]	
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
空浇水壶			预设: wateringcan		路径： [string "scripts/prefabs/wateringcan.lua"]	
	Tags▼	
	{":", "usesdepleted", "_inventoryitem", "inspectable", "wateringcan", "fillable", "BURNABLE_fuel", "canlight", "_equippable", "fillable_showoceanaction", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wateringcan")	
			inst.AnimState:SetBuild("wateringcan")	
			Anim路径 :  "anim/wateringcan.zip"	
 	
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
MISSING NAME			预设: moonglass_stalactite3		路径： [string "scripts/prefabs/moonglass_stalactites.lua"]	
	Tags▼	
	{":", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_bigwaterfall")	
			inst.AnimState:SetBuild("moonglass_bigwaterfall")	
			Anim路径 :  "anim/moonglass_bigwaterfall.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
紫色月眼			预设: purplemooneye		路径： [string "scripts/prefabs/mooneye.lua"]	
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
圣诞小玩意			预设: winter_ornament_plain5		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: pocketwatch_warp_marker		路径： [string "scripts/prefabs/pocketwatch.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_warp_marker")	
			inst.AnimState:SetBuild("pocketwatch_warp_marker")	
			Anim路径 :  "anim/pocketwatch_warp_marker.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
暗影矿工			预设: shadowminer_builder		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
彩纸大炮套装			预设: carnivalcannon_confetti_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon")	
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
损坏的发条战车			预设: rook_nightmare		路径： [string "scripts/prefabs/rook.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "freezable", "idle", "chess", "_inventory", "hostile", "_combat", "locomotor", "nolight", "_follower", "sleeper", "rook"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rook")	
			inst.AnimState:SetBuild("rook_nightmare")	
			Anim路径 :  "anim/rook.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("hauntable")	
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
------------------------------------------------	
小孔雀鱼			预设: oceanfish_small_1		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_small_1", "OMNI_eater", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_1")	
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
MISSING NAME			预设: sculptingtable_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sculpting_station")	
			inst.AnimState:SetBuild("sculpting_station")	
			Anim路径 :  "anim/sculpting_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
铥矿皇冠			预设: ruinshat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "metal", "open_top_hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruinshat")	
			inst.AnimState:SetBuild("hat_ruins")	
			Anim路径 :  "anim/hat_ruins.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
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
龙鳞宝箱			预设: dragonflychest		路径： [string "scripts/prefabs/dragonfly_chest.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "chest", "HAMMER_workable", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonfly_chest")	
			inst.AnimState:SetBuild("dragonfly_chest")	
			Anim路径 :  "anim/dragonfly_chest.zip"	
 	
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
火炬			预设: torch		路径： [string "scripts/prefabs/torch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "wildfireprotected", "nolight", "waterproofer", "_equippable", "lighter", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("torch")	
			inst.AnimState:SetBuild("swap_torch")	
			Anim路径 :  "anim/torch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fueled")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lighter")	
		inst:AddComponent("weapon")	
		
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
发光浆果			预设: wormlight		路径： [string "scripts/prefabs/wormlight.lua"]	
	Tags▼	
	{":", "_inventoryitem", "vasedecoration", "lightbattery", "inspectable", "FROMNUM", "WORMLIGHT_fuel", "_stackable", "edible_VEGGIE", "badfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("worm_light")	
			inst.AnimState:SetBuild("worm_light")	
			Anim路径 :  "anim/worm_light.zip"	
 	
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
MISSING NAME			预设: krampuswarning_lvl3		路径： [string "scripts/prefabs/monsterwarningsounds.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: crab_king_bubble2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
菌伞灯			预设: mushroom_light2		路径： [string "scripts/prefabs/mushroom_light.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "HAMMER_workable", "canlight", "structure", "lamp", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_light2")	
			inst.AnimState:SetBuild("mushroom_light2")	
			Anim路径 :  "anim/mushroom_light2.zip"	
 	
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
远古窑			预设: archive_cookpot		路径： [string "scripts/prefabs/cookpot.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "stewer", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot")	
			inst.AnimState:SetBuild("cookpot_archive")	
			Anim路径 :  "anim/cookpot_archive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("stewer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
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
咸的生鲜萨尔萨酱			预设: salsa_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
粗壮常青树			预设: quagmire_evergreen_tall		路径： [string "scripts/prefabs/quagmire_evergreen.lua"]	
	Tags▼	
	{":", "tree", "plant", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_short")	
			inst.AnimState:SetBuild("evergreen_new_2")	
			Anim路径 :  "anim/evergreen_tall_old.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mining_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鬼魂棒棒糖			预设: halloweencandy_8		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
园艺锄			预设: farm_hoe		路径： [string "scripts/prefabs/farm_hoe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_hoe")	
			inst.AnimState:SetBuild("quagmire_hoe")	
			Anim路径 :  "anim/quagmire_hoe.zip"	
 	
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
华丽低语盔甲			预设: lavaarena_armor_hppetmastery		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "hide_percentage", "metal", "ruins"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: schoolherd_oceanfish_medium_1		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: oceantree_roots_normal		路径： [string "scripts/prefabs/oceantree.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceantree_normal")	
			inst.AnimState:SetBuild("oceantree_normal")	
			Anim路径 :  "anim/oceantree_normal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的蝴蝶松饼			预设: butterflymuffin_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: diseaseflies		路径： [string "scripts/prefabs/diseaseflies.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	使用的组件▼	

------------------------------------------------	
盐池			预设: quagmire_pond_salt		路径： [string "scripts/prefabs/quagmire_pond.lua"]	
	Tags▼	
	{":", "saltpond", "watersource", "antlion_sinkhole_blocker", "birdblocker", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	

------------------------------------------------	
坚固的石质护甲			预设: lavaarena_armorextraheavy		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "marble", "hide_percentage", "heavyarmor"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: marblebean_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marblebean")	
			inst.AnimState:SetBuild("marblebean")	
			Anim路径 :  "anim/marblebean.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
远古雕像			预设: atrium_statue_facing		路径： [string "scripts/prefabs/atrium_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_statue")	
			inst.AnimState:SetBuild("atrium_statue")	
			Anim路径 :  "anim/atrium_statue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
辣肉丸			预设: meatballs_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
大萝卜			预设: quagmire_turnip		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜蝴蝶松饼			预设: butterflymuffin_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
熊皮			预设: bearger_fur		路径： [string "scripts/prefabs/bearger_fur.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bearger_fur")	
			inst.AnimState:SetBuild("bearger_fur")	
			Anim路径 :  "anim/bearger_fur.zip"	
 	
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
MISSING NAME			预设: moose_nest_fx_idle		路径： [string "scripts/prefabs/moose_nest_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
大熔炉猪战士			预设: lavaarena_groundlift		路径： [string "scripts/prefabs/lavaarena_groundlifts.lua"]	
	Tags▼	
	{":", "groundspike", "object", "hostile", "notarget", "stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
蕨叶			预设: foliage		路径： [string "scripts/prefabs/foliage.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "BURNABLE_fuel", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("foliage")	
			inst.AnimState:SetBuild("foliage")	
			Anim路径 :  "anim/foliage.zip"	
 	
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
牛排薯条			预设: quagmire_food_060		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: blowdart_lava_projectile_alt		路径： [string "scripts/prefabs/blowdart_lava.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_blowdart_attacks")	
			inst.AnimState:SetBuild("lavaarena_blowdart_attacks")	
			Anim路径 :  "anim/lavaarena_blowdart_attacks.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
天气风向标			预设: staff_tornado		路径： [string "scripts/prefabs/staff_tornado.lua"]	
	Tags▼	
	{":", "_inventoryitem", "castoncombat", "inspectable", "castonworkable", "quickcast", "_equippable", "nopunch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tornado_stick")	
			inst.AnimState:SetBuild("tornado_stick")	
			Anim路径 :  "anim/tornado_stick.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("spellcaster")	
		inst:AddComponent("equippable")	
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
MISSING NAME			预设: retrofitted_grotterwar_spawnpoint		路径： [string "scripts/prefabs/nightmaregrowth.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
堆肥			预设: compost		路径： [string "scripts/prefabs/compost.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "_stackable", "BURNABLE_fuel", "fertilizer", "canlight", "fertilizerresearchable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("compost")	
			inst.AnimState:SetBuild("compost")	
			Anim路径 :  "anim/compost.zip"	
 	
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
铥矿碎片			预设: thulecite_pieces		路径： [string "scripts/prefabs/thulecite_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL", "work_thulecite", "health_thulecite", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("thulecite_pieces")	
			inst.AnimState:SetBuild("thulecite_pieces")	
			Anim路径 :  "anim/thulecite_pieces.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("repairer")	
		
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
路牌			预设: homesign		路径： [string "scripts/prefabs/homesign.lua"]	
	Tags▼	
	{":", "_writeable", "sign", "inspectable", "writeable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_home")	
			inst.AnimState:SetBuild("sign_home")	
			Anim路径 :  "anim/sign_home.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("writeable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: bishop_charge_hit		路径： [string "scripts/prefabs/bishop_charge.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
铁甲礼服款式			预设: robot_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
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
MISSING NAME			预设: statue_transition_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
高级耕作先驱帽			预设: nutrientsgoggleshat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "plantinspector", "detailedplanthappiness", "nutrientsvision", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nutrientsgoggleshat")	
			inst.AnimState:SetBuild("hat_nutrientsgoggles")	
			Anim路径 :  "anim/hat_nutrientsgoggles.zip"	
 	
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
正式皮弗娄牛玩偶			预设: yotb_beefalo_doll_formal		路径： [string "scripts/prefabs/yotb_beefalo_dolls.lua"]	
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
MISSING NAME			预设: icing_splash_fx_melted		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
腌鲱鱼			预设: wintercooking_pickledherring		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
锅烤美食			预设: quagmire_food_058		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
硝石			预设: nitre		路径： [string "scripts/prefabs/nitre.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "quakedebris", "CHEMICAL_fuel", "edible_ELEMENTAL"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nitre")	
			inst.AnimState:SetBuild("nitre")	
			Anim路径 :  "anim/nitre.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		
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
铥矿棒			预设: ruins_bat		路径： [string "scripts/prefabs/ruins_bat.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_bat")	
			inst.AnimState:SetBuild("swap_ruins_bat")	
			Anim路径 :  "anim/ruins_bat.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("equippable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("weapon")	
		
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
胡萝卜鼠秤套装			预设: yotc_carrat_scale_item		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotc_carrat_scale_item")	
			inst.AnimState:SetBuild("yotc_carrat_scale_item")	
			Anim路径 :  "anim/yotc_carrat_scale_item.zip"	
 	
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
尖刺			预设: bramblefx_trap		路径： [string "scripts/prefabs/bramblefx.lua"]	
	Tags▼	
	{":", "fx", "thorny", "trapdamage"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bramblefx")	
			inst.AnimState:SetBuild("bramblefx")	
			Anim路径 :  "anim/bramblefx.zip"	
 	
	使用的组件▼	
		inst:AddComponent("updatelooper")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
斧头			预设: axe		路径： [string "scripts/prefabs/axe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "possessable_axe", "inspectable", "tool", "sharp", "_equippable", "CHOP_tool", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("axe")	
			inst.AnimState:SetBuild("axe")	
			Anim路径 :  "anim/axe.zip"	
 	
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
洞穴蝙蝠翅膀			预设: batwing		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "dryable", "_stackable", "badfood", "cookable", "catfood", "lureplant_bait", "fresh", "batwing"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("batwing")	
			inst.AnimState:SetBuild("batwing")	
			Anim路径 :  "anim/batwing.zip"	
 	
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
蔬菜汤			预设: quagmire_food_003		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
大理石灌木			预设: marbleshrub		路径： [string "scripts/prefabs/marbleshrub.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("marbleshrub")	
			inst.AnimState:SetBuild("marbleshrub")	
			Anim路径 :  "anim/marbleshrub.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		
------------------------------------------------	
MISSING NAME			预设: slingshotammo_hitfx_freeze		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
玄武岩柱			预设: basalt_pillar		路径： [string "scripts/prefabs/basalt.lua"]	
	Tags▼	
	{":", "inspectable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blocker")	
			inst.AnimState:SetBuild("blocker")	
			Anim路径 :  "anim/blocker.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
裸露鼻孔			预设: batnose		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "dryable", "_stackable", "badfood", "cookable", "catfood", "lureplant_bait", "fresh"}	
 	
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
MISSING NAME			预设: spider_heal_ground_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
战旗			预设: lavaarena_battlestandard_shield		路径： [string "scripts/prefabs/lavaarena_battlestandard.lu..."]	
	Tags▼	
	{":", "battlestandard", "LA_mob"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mermthrone_construction_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_king_carpet_construction")	
			inst.AnimState:SetBuild("merm_king_carpet_construction")	
			Anim路径 :  "anim/merm_king_carpet_construction.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
巨型榴莲			预设: durian_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_durian_build")	
			Anim路径 :  "anim/farm_plant_pepper.zip"	
 	
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
可靠的胶布			预设: sewing_tape		路径： [string "scripts/prefabs/sewing_tape.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_patch", "inspectable", "tape", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tape")	
			inst.AnimState:SetBuild("sewing_tape")	
			Anim路径 :  "anim/sewing_tape.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sewing")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("boatpatch")	
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
亡者补药			预设: ghostlyelixir_slowregen		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
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
MISSING NAME			预设: pocketwatch_heal_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: frontend		路径： [string "scripts/prefabs/frontend.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
花锦鲤			预设: oceanfish_medium_6		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "OMNI_eater", "herd_oceanfish_medium_6", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_6")	
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
杯子和球			预设: trinket_7		路径： [string "scripts/prefabs/trinkets.lua"]	
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
铁钥匙			预设: quagmire_key_park		路径： [string "scripts/prefabs/quagmire_key.lua"]	
	Tags▼	
	{":", "klaussackkey", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_key")	
			inst.AnimState:SetBuild("quagmire_key")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_fest_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: winters_feast_depletefood		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
乌鸦			预设: crow		路径： [string "scripts/prefabs/birds.lua"]	
	Tags▼	
	{":", "bird", "_inventoryitem", "_health", "inspectable", "SEEDS_eater", "freezable", "crow", "stunnedbybomb", "idle", "small_livestock", "smallcreature", "_combat", "locomotor", "nolight", "show_spoilage", "cookable", "flight", "likewateroffducksback", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("crow")	
			inst.AnimState:SetBuild("crow_build")	
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
MISSING NAME			预设: beetletaur_fossilized_break_fx_right		路径： [string "scripts/prefabs/lavaarena_beetletaur.lua"]	
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
MISSING NAME			预设: ice_projectile		路径： [string "scripts/prefabs/staff_projectile.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("projectile")	
			inst.AnimState:SetBuild("staff_projectile")	
			Anim路径 :  "anim/staff_projectile.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		
------------------------------------------------	
月亮孢子			预设: spore_moon		路径： [string "scripts/prefabs/mushtree_moonspore.lua"]	
	Tags▼	
	{":", "busy", "spore", "inspectable", "_stackable", "_combat", "NET_workable", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spore_moon")	
			inst.AnimState:SetBuild("mushroom_spore_moon")	
			Anim路径 :  "anim/spore_moon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("workable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("popped")	
	SG = 有▼	
------------------------------------------------	
悬蛛变身涂鸦			预设: mutator_dropper		路径： [string "scripts/prefabs/spider_mutators.lua"]	
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
MISSING NAME			预设: raindrop		路径： [string "scripts/prefabs/raindrop.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("raindrop")	
			inst.AnimState:SetBuild("raindrop")	
			Anim路径 :  "anim/raindrop.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
远古织影者雕塑			预设: chesspiece_stalker		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_stalker_moonglass")	
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
华丽的装饰			预设: winter_ornament_boss_moose		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
烤火鸡			预设: wintercooking_roastturkey		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
汁液			预设: quagmire_sap		路径： [string "scripts/prefabs/quagmire_sap.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_sap")	
			inst.AnimState:SetBuild("quagmire_sap")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pocketwatch_heal_fx_mount		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_firebomb_sparks		路径： [string "scripts/prefabs/lavaarena_firebomb.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: seafaring_prototyper_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("seafaring_prototyper")	
			Anim路径 :  "anim/seafaring_prototyper.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: mermwatchtower_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_guard_tower")	
			inst.AnimState:SetBuild("merm_guard_tower")	
			Anim路径 :  "anim/merm_guard_tower.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
烤火鸡面包馅			预设: wintercooking_stuffing		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
南瓜饼			预设: wintercooking_pumpkinpie		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: halloween_firepuff_cold_1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cookpot_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot")	
			inst.AnimState:SetBuild("cook_pot")	
			Anim路径 :  "anim/cookpot_archive.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: dug_berrybush2_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush2")	
			inst.AnimState:SetBuild("berrybush2")	
			Anim路径 :  "anim/berrybush2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蒜香肉串			预设: kabobs_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: retrofitted_grotterwar_homepoint		路径： [string "scripts/prefabs/nightmaregrowth.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
煎高脚鸟蛋			预设: tallbirdegg_cooked		路径： [string "scripts/prefabs/tallbirdegg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "tallbirdegg", "_stackable", "cattoy", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("egg")	
			inst.AnimState:SetBuild("tallbird_egg")	
			Anim路径 :  "anim/tallbird_egg.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("perishable")	
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
巨型土豆			预设: potato_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_potato")	
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
农作物			预设: quagmire_potato_planted		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "plantedsoil", "fertilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: lavaarena_spawnerdecor_fx_2		路径： [string "scripts/prefabs/lavaarena_creature_spawn_fx..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
肉块雕像			预设: resurrectionstatue		路径： [string "scripts/prefabs/resurrectionstatue.lua"]	
	Tags▼	
	{":", "ATTUNABLE_ID_125002", "inspectable", "resurrector", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilsonstatue")	
			inst.AnimState:SetBuild("wilsonstatue")	
			Anim路径 :  "anim/wilsonstatue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("attunable")	
		inst:AddComponent("burnable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("ms_playerjoined")	
		inst:ListenForEvent("activateresurrection")	

------------------------------------------------	
地狱独眼巨猪			预设: beetletaur		路径： [string "scripts/prefabs/lavaarena_beetletaur.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "epic", "fossilizable", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beetletaur")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("beetletaur._spawnflower")	
------------------------------------------------	
约束静电			预设: moonstorm_static_item		路径： [string "scripts/prefabs/moonstorm_static.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "moonstorm_static"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("static_ball_contained")	
			Anim路径 :  "anim/static_ball_contained.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
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
蒜香无花果意面			预设: figatoni_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蒜香伏特羊肉冻			预设: voltgoatjelly_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
焦糖块			预设: quagmire_food_066		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_beefalo_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: splash_ocean		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	

------------------------------------------------	
华丽坚固盔甲			预设: lavaarena_armor_hpextraheavy		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "hide_percentage", "metal", "ruins"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
洞穴苔藓			预设: lichen		路径： [string "scripts/prefabs/lichen.lua"]	
	Tags▼	
	{":", "inspectable", "lichen", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("algae_bush")	
			inst.AnimState:SetBuild("algae_bush")	
			Anim路径 :  "anim/algae_bush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: slingshotammo_hitfx_rocks		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
煮熟的长猪			预设: humanmeat_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "badfood", "fresh"}	
 	
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
MISSING NAME			预设: alterguardian_phase3trapprojectile		路径： [string "scripts/prefabs/alterguardian_phase3trap.lu..."]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_meteor")	
			inst.AnimState:SetBuild("alterguardian_meteor")	
			Anim路径 :  "anim/alterguardian_meteor.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
损坏的发条装置			预设: chessjunk2		路径： [string "scripts/prefabs/chessjunk.lua"]	
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
MISSING NAME			预设: ink_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: brokentool		路径： [string "scripts/prefabs/brokentool.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
火			预设: fire		路径： [string "scripts/prefabs/fire.lua"]	
	Tags▼	
	{":", "fx", "HASHEATER"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fire")	
			inst.AnimState:SetBuild("fire")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("firefx")	
		
------------------------------------------------	
强化农场			预设: fast_farmplot		路径： [string "scripts/prefabs/farmplot.lua"]	
	Tags▼	
	{":", "inspectable", "fullfertile", "HAMMER_workable", "grower", "canlight", "structure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farmplot")	
			inst.AnimState:SetBuild("farmplot")	
			Anim路径 :  "anim/farmplot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("grower")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
MISSING NAME			预设: quagmire_portal_playerdrip_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
毒菌蟾蜍雕塑			预设: chesspiece_toadstool_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: icespike_fx_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
喷吐变身涂鸦			预设: mutator_spitter		路径： [string "scripts/prefabs/spider_mutators.lua"]	
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
岩浆傀儡			预设: lavaarena_elemental		路径： [string "scripts/prefabs/lavaarena_elemental.lua"]	
	Tags▼	
	{":", "elemental", "notraptrigger", "companion", "scarytoprey", "flying", "NOCLICK", "ignorewalkableplatformdrowning", "character"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_old_rubble		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
背包			预设: backpack		路径： [string "scripts/prefabs/backpack.lua"]	
	Tags▼	
	{":", "_inventoryitem", "backpack", "inspectable", "_container", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_backpack")	
			Anim路径 :  "anim/backpack.zip"	
 	
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
银盘			预设: quagmire_plate_silver		路径： [string "scripts/prefabs/quagmire_plates.lua"]	
	Tags▼	
	{":", "quagmire_replater"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: battreefx		路径： [string "scripts/prefabs/battreefx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bat_tree_fx")	
			inst.AnimState:SetBuild("bat_tree_fx")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
蒜香蛙腿三明治			预设: frogglebunwich_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
```
