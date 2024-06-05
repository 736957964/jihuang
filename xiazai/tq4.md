> 摘录う丶青木
- 数据提取4
```lua
皮鞭			预设: whip		路径： [string "scripts/prefabs/whip.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable", "whip", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("whip")	
			inst.AnimState:SetBuild("whip")	
			Anim路径 :  "anim/whip.zip"	
 	
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
咸的鱼肉玉米卷			预设: fishtacos_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: thunder		路径： [string "scripts/prefabs/lightning.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
韦斯			预设: wes		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mime", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "balloonomancer", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wes")	
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
		inst:AddComponent("houndedtarget")	
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
		inst:AddComponent("efficientuser")	
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
俗气鹅像			预设: wereitem_goose		路径： [string "scripts/prefabs/wereitems.lua"]	
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
植株			预设: weed_firenettle		路径： [string "scripts/prefabs/weed_plants.lua"]	
	Tags▼	
	{":", "inspectable", "plantedsoil", "farm_plant_killjoy", "farm_plant", "trapdamage", "plantresearchable", "plant", "weed_firenettle", "DIG_workable", "canlight", "weed", "tendable_farmplant", "weedplantstress"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("weed_firenettle")	
			inst.AnimState:SetBuild("weed_firenettle")	
			Anim路径 :  "anim/weed_firenettle.zip"	
 	
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
砖砌烤炉			预设: wintersfeastoven		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wintersfeast_oven")	
			inst.AnimState:SetBuild("wintersfeast_oven")	
			Anim路径 :  "anim/wintersfeast_oven.zip"	
 	
	使用的组件▼	
		inst:AddComponent("madsciencelab")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("pickable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("prototyper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
远古大门			预设: lavaarena_portal		路径： [string "scripts/prefabs/lavaarena_portal.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_portal")	
			inst.AnimState:SetBuild("lavaarena_portal")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
伊格内修斯			预设: pigelite2		路径： [string "scripts/prefabs/pigelite.lua"]	
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
MISSING NAME			预设: weaponsparks		路径： [string "scripts/prefabs/weaponsparks.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pandorachest_reset		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: waveyjones_marker		路径： [string "scripts/prefabs/waveyjones.lua"]	
	Tags▼	
	{":", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("updatelooper")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: waveyjones_hand_art		路径： [string "scripts/prefabs/waveyjones.lua"]	
	Tags▼	
	{":", "DECOR", "idle", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadow_wavey_jones_hand")	
			inst.AnimState:SetBuild("shadow_wavey_jones_hand")	
			Anim路径 :  "anim/shadow_wavey_jones_hand.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("STATE_TRAPPED")	
		inst:ListenForEvent("STATE_LOOP_ACTION_ANCHOR_PST")	
		inst:ListenForEvent("STATE_PREMOVING")	
		inst:ListenForEvent("onscared")	
		inst:ListenForEvent("STATE_IN")	
		inst:ListenForEvent("STATE_SCARED_RELOCATE")	
		inst:ListenForEvent("STATE_LOOP_ACTION_ANCHOR")	
		inst:ListenForEvent("STATE_TRAPPED_PST")	
		inst:ListenForEvent("STATE_SHORT_ACTION")	
		inst:ListenForEvent("STATE_IDLE")	
		inst:ListenForEvent("STATE_MOVING")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: waveyjones		路径： [string "scripts/prefabs/waveyjones.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadow_wavey_jones")	
			inst.AnimState:SetBuild("shadow_wavey_jones")	
			Anim路径 :  "anim/shadow_wavey_jones.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("updatelooper")	
		
	使用的监听▼	
		inst:ListenForEvent("laugh")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: wave_shore		路径： [string "scripts/prefabs/wave_shore.lua"]	
	Tags▼	
	{":", "fx", "NOBLOCK", "ignorewalkableplatforms", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wave_shore")	
			inst.AnimState:SetBuild("wave_shore")	
			Anim路径 :  "anim/wave_shore.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
做熟的无花果			预设: fig_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "edible_BERRY", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fig")	
			inst.AnimState:SetBuild("fig")	
			Anim路径 :  "anim/fig.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: wathgrithr_bloodlustbuff_other		路径： [string "scripts/prefabs/wathgrithr_bloodlustbuff.lu..."]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_attack_buff_effect2")	
			inst.AnimState:SetBuild("lavaarena_attack_buff_effect2")	
			Anim路径 :  "anim/lavaarena_attack_buff_effect2.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
隐士之家			预设: hermithouse_construction2		路径： [string "scripts/prefabs/hermithouse.lua"]	
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
MISSING NAME			预设: deer_ice_flakes		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_ice_flakes")	
			inst.AnimState:SetBuild("deer_ice_flakes")	
			Anim路径 :  "anim/deer_ice_flakes.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
薇格弗德			预设: wathgrithr		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "battlesinger", "player", "valkyrie", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("wathgrithr")	
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
		inst:AddComponent("battleborn")	
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
		inst:AddComponent("singinginspiration")	
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
		inst:ListenForEvent("onhitother")	
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
甜无花果酿树干			预设: koalefig_trunk_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
钢丝绵			预设: steelwool		路径： [string "scripts/prefabs/steelwool.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("steel_wool")	
			inst.AnimState:SetBuild("steel_wool")	
			Anim路径 :  "anim/steel_wool.zip"	
 	
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
大虚影			预设: largeguard_alterguardian_projectile		路径： [string "scripts/prefabs/gestalt_alterguardian_proje..."]	
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
编织暗影			预设: stalker_minion1		路径： [string "scripts/prefabs/stalker_minions.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "idle", "fossil", "hostile", "_combat", "locomotor", "sanityaura", "stalkerminion"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker_minion")	
			inst.AnimState:SetBuild("stalker_minion")	
			Anim路径 :  "anim/stalker_minion.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("timer")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("timerdone")	
	SG = 有▼	
------------------------------------------------	
基础农场			预设: slow_farmplot		路径： [string "scripts/prefabs/farmplot.lua"]	
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
烤香蕉			预设: cave_banana_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
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
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
锁住的铁门			预设: quagmire_park_gate		路径： [string "scripts/prefabs/fence.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "standingactivation", "door", "HAMMER_workable", "_combat", "alignwall", "canlight", "wall", "inactive", "noauradamage", "klaussacklock", "blocker"}	
 	
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
		inst:AddComponent("klaussacklock")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
消防泵			预设: waterpump		路径： [string "scripts/prefabs/waterpump.lua"]	
	Tags▼	
	{":", "channelable", "inspectable", "HAMMER_workable", "use_channel_longaction", "pump", "canlight", "structure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_waterpump")	
			inst.AnimState:SetBuild("boat_waterpump")	
			Anim路径 :  "anim/boat_waterpump.zip"	
 	
	使用的组件▼	
		inst:AddComponent("deployhelper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("channelable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("channel_finished")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: bilesplat		路径： [string "scripts/prefabs/waterprojectiles.lua"]	
	Tags▼	
	{":", "projectile", "locomotor", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bird_bileshoot")	
			inst.AnimState:SetBuild("bird_bileshoot")	
			Anim路径 :  "anim/bird_bileshoot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
暖石			预设: heatrock		路径： [string "scripts/prefabs/heatrock.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "icebox_valid", "HASHEATER", "molebait", "heatrock", "bait"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("heat_rock")	
			inst.AnimState:SetBuild("heat_rock")	
			Anim路径 :  "anim/heat_rock.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("temperature")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
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
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("sheltered")	
		inst:ListenForEvent("temperaturedelta")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: frogsplash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_attack_dripfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
海芽插穗			预设: waterplant_planter		路径： [string "scripts/prefabs/waterplant_planter.lua"]	
	Tags▼	
	{":", "_inventoryitem", "waterplant_upgrader", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle_root")	
			inst.AnimState:SetBuild("barnacle_root")	
			Anim路径 :  "anim/barnacle_root.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("upgrader")	
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
海芽			预设: waterplant_baby		路径： [string "scripts/prefabs/waterplant_baby.lua"]	
	Tags▼	
	{":", "inspectable", "bearded", "ignorewalkableplatforms", "canlight", "seastack", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("barnacle_plant")	
			inst.AnimState:SetBuild("barnacle_plant_colour_swaps")	
			Anim路径 :  "anim/barnacle_plant.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("waterphysics")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("harvestable")	
		inst:AddComponent("shaveable")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
吸热火坑			预设: coldfirepit		路径： [string "scripts/prefabs/coldfirepit.lua"]	
	Tags▼	
	{":", "BURNABLE_fueled", "campfire", "blueflame", "inspectable", "wildfireprotected", "CHEMICAL_fueled", "HAMMER_workable", "nolight", "storytellingprop", "fire", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("coldfirepit")	
			inst.AnimState:SetBuild("coldfirepit")	
			Anim路径 :  "anim/coldfirepit.zip"	
 	
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
MISSING NAME			预设: warningshadow		路径： [string "scripts/prefabs/warningshadow.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("warning_shadow")	
			inst.AnimState:SetBuild("warning_shadow")	
			Anim路径 :  "anim/meteor_shadow.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wargshrine_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wargshrine")	
			inst.AnimState:SetBuild("wargshrine")	
			Anim路径 :  "anim/wargshrine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
象鼻			预设: trunk_summer		路径： [string "scripts/prefabs/trunk.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "cookable", "fresh"}	
 	
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
姜饼座狼			预设: gingerbreadwarg		路径： [string "scripts/prefabs/warg.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "houndfriend", "freezable", "_combat", "locomotor", "scarytoprey", "nolight", "gingerbread", "largecreature", "warg", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("warg")	
			inst.AnimState:SetBuild("warg_gingerbread_build")	
			Anim路径 :  "anim/warg_gingerbread.zip"	
 	
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
黏土座狼			预设: claywarg		路径： [string "scripts/prefabs/warg.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "houndfriend", "freezable", "clay", "noattack", "_combat", "locomotor", "scarytoprey", "notarget", "largecreature", "warg"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("claywarg")	
			inst.AnimState:SetBuild("claywarg")	
			Anim路径 :  "anim/claywarg.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("freezable")	
		inst:AddComponent("health")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("leader")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("restoredfollower")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("eyeflamesdirty")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("spawnedforhunt")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: wardrobe_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wardrobe")	
			inst.AnimState:SetBuild("wardrobe")	
			Anim路径 :  "anim/wardrobe.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
衣柜			预设: wardrobe		路径： [string "scripts/prefabs/wardrobe.lua"]	
	Tags▼	
	{":", "inspectable", "wardrobe", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wardrobe")	
			inst.AnimState:SetBuild("wardrobe")	
			Anim路径 :  "anim/wardrobe.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("wardrobe")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
旺达			预设: wanda		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "cannotheal", "freezable", "clockmaker", "player", "idle", "_builder", "_sanity", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "pocketwatchcaster", "character", "health_as_oldage", "lightningtarget", "waterplant_upgradeuser"}	
 	
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
		inst:AddComponent("positionalwarp")	
		inst:AddComponent("combat")	
		inst:AddComponent("plantregistryupdater")	
		inst:AddComponent("leader")	
		inst:AddComponent("staffsanity")	
		inst:AddComponent("oldager")	
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
		inst:ListenForEvent("hide_warp_marker")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("learnplantstage")	
		inst:ListenForEvent("onwarpback")	
		inst:ListenForEvent("onchangecanopyzone")	
		inst:ListenForEvent("ghostdelta")	
		inst:ListenForEvent("show_warp_marker")	
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
沃尔特			预设: walter		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "dogrider", "mast_upgradeuser", "efficient_sleeper", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "_inventory", "nowormholesanityloss", "_combat", "storyteller", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "expertchef", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "slingshot_sharpshooter", "allergictobees", "character", "lightningtarget", "pinetreepioneer", "waterplant_upgradeuser", "pebblemaker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("walter")	
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
		inst:AddComponent("storyteller")	
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
		inst:ListenForEvent("healthdelta")	
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
煮熟的蟹肉			预设: quagmire_crabmeat_cooked		路径： [string "scripts/prefabs/quagmire_fish.lua"]	
	Tags▼	
	{":", "meat", "quagmire_stewable", "catfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_crabmeat")	
			inst.AnimState:SetBuild("quagmire_crabmeat")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
小海象			预设: little_walrus		路径： [string "scripts/prefabs/walrus.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "houndfriend", "freezable", "idle", "taunt_attack", "_inventory", "_combat", "MEAT_eater", "locomotor", "nolight", "_follower", "character", "walrus", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("walrus")	
			inst.AnimState:SetBuild("walrus_baby_build")	
			Anim路径 :  "anim/walrus_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("eater")	
		inst:AddComponent("leader")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("hauntable")	
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
甜酸橘汁腌鱼			预设: ceviche_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
饼干切割机帽子			预设: cookiecutterhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cookiecutterhat")	
			inst.AnimState:SetBuild("hat_cookiecutter")	
			Anim路径 :  "anim/hat_cookiecutter.zip"	
 	
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
MISSING NAME			预设: wall_ruins_2_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins_2")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
甜香蕉冻			预设: bananapop_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: ruinsrelic_chair_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_chair")	
			inst.AnimState:SetBuild("ruins_chair")	
			Anim路径 :  "anim/ruins_chair.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
火鸡神龛			预设: perdshrine		路径： [string "scripts/prefabs/perdshrine.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "perdshrine", "canlight", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("perdshrine")	
			inst.AnimState:SetBuild("perdshrine")	
			Anim路径 :  "anim/perdshrine.zip"	
 	
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
		inst:ListenForEvent("ondeconstructstructure")	
------------------------------------------------	
木墙			预设: wall_wood		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "repairable_wood", "HAMMER_workable", "_combat", "healthrepairable", "canlight", "wall", "wood", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_wood")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("repairable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		
------------------------------------------------	
MISSING NAME			预设: wall_ruins_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
铥矿墙			预设: wall_ruins_item		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "wallbuilder", "health_thulecite", "deployable", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins")	
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
MISSING NAME			预设: mushtree_small_bloom_burntfx		路径： [string "scripts/prefabs/mushtree.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_small")	
			inst.AnimState:SetBuild("mushroom_tree_small_bloom")	
			Anim路径 :  "anim/mushroom_tree_small.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
华夫饼			预设: quagmire_food_044		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wall_hay_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_hay")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
草墙			预设: wall_hay		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "grass", "HAMMER_workable", "repairable_hay", "_combat", "healthrepairable", "canlight", "wall", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_hay")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("repairable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		
------------------------------------------------	
木墙			预设: wall_wood_item		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "health_wood", "wallbuilder", "BURNABLE_fuel", "canlight", "deployable", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_wood")	
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
MISSING NAME			预设: wall_ruins_2_item		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "wallbuilder", "health_ruins_2", "deployable", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins_2")	
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
鱼头串			预设: yotp_food3		路径： [string "scripts/prefabs/yotp_food.lua"]	
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
犁地草膏			预设: tillweedsalve		路径： [string "scripts/prefabs/tillweedsalve.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "show_spoilage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tillweedsalve")	
			inst.AnimState:SetBuild("tillweedsalve")	
			Anim路径 :  "anim/tillweedsalve.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("healer")	
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
石墙			预设: wall_stone		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "HAMMER_workable", "_combat", "healthrepairable", "stone", "wall", "repairable_stone", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_stone")	
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
诡异工具			预设: wagstaff_tool_5		路径： [string "scripts/prefabs/wagstaff_tools.lua"]	
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
牛毛			预设: beefalowool		路径： [string "scripts/prefabs/beefalowool.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("beefalo_wool")	
			inst.AnimState:SetBuild("beefalo_wool")	
			Anim路径 :  "anim/beefalo_wool.zip"	
 	
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
花锦鲤			预设: oceanfish_medium_6_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_6")	
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
怪异工具			预设: wagstaff_tool_1		路径： [string "scripts/prefabs/wagstaff_tools.lua"]	
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
月亮精华提取器			预设: alterguardian_contained		路径： [string "scripts/prefabs/wagstaff_npc.lua"]	
	Tags▼	
	{":", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_contained")	
			inst.AnimState:SetBuild("alterguardian_contained")	
			Anim路径 :  "anim/alterguardian_contained.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("docollect")	
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_noeyeblue		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
烤浆果			预设: berries_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "edible_BERRY", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berries")	
			inst.AnimState:SetBuild("berries")	
			Anim路径 :  "anim/berries.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
浆果			预设: berries		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "oceanfishing_lure", "edible_BERRY", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berries")	
			inst.AnimState:SetBuild("berries")	
			Anim路径 :  "anim/berries.zip"	
 	
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
巨型腐烂土豆			预设: potato_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_potato")	
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
土豆种子			预设: potato_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
MISSING NAME			预设: ghostlyelixir_shield_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
仙人掌肉			预设: cactus_meat		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "fresh"}	
 	
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
MISSING NAME			预设: minisign_item_placer		路径： [string "scripts/prefabutil.lua"]	
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
西瓜			预设: watermelon		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
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
巨型西瓜			预设: watermelon_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_watermelon_build")	
			Anim路径 :  "anim/farm_plant_tomato.zip"	
 	
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
熟海带叶			预设: kelp_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "fresh"}	
 	
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
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
干海带叶			预设: kelp_dried		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("meat_rack_food_tot")	
			inst.AnimState:SetBuild("meat_rack_food_tot")	
			Anim路径 :  "anim/meat_rack_food_tot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
白色主教			预设: trinket_15		路径： [string "scripts/prefabs/trinkets.lua"]	
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
烤多汁浆果			预设: berries_juicy_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "edible_BERRY", "fresh"}	
 	
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
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: coldfirepit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("coldfirepit")	
			inst.AnimState:SetBuild("coldfirepit")	
			Anim路径 :  "anim/coldfirepit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
红灯笼			预设: redlantern		路径： [string "scripts/prefabs/redlantern.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "burnableignorefuel", "canlight", "_equippable", "light"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("redlantern")	
			inst.AnimState:SetBuild("redlantern")	
			Anim路径 :  "anim/redlantern.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inventoryitemmoisture")	
		
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
破碎蜘蛛			预设: moonspider_spike		路径： [string "scripts/prefabs/moonspider_spike.lua"]	
	Tags▼	
	{":", "groundspike", "_combat", "notarget", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_spike")	
			inst.AnimState:SetBuild("spider_spike")	
			Anim路径 :  "anim/spider_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
------------------------------------------------	
蜡纸			预设: waxpaper		路径： [string "scripts/prefabs/waxpaper.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wax_paper")	
			inst.AnimState:SetBuild("wax_paper")	
			Anim路径 :  "anim/wax_paper.zip"	
 	
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
MISSING NAME			预设: stickright		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
维多利亚礼服款式			预设: victorian_blueprint		路径： [string "scripts/prefabs/yotb_blueprints.lua"]	
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
饼干切割机壳			预设: cookiecuttershell		路径： [string "scripts/prefabs/cookiecuttershell.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("cookiecuttershell")	
			Anim路径 :  "anim/cookiecuttershell.zip"	
 	
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
巨型胡萝卜			预设: carrot_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_carrot")	
			inst.AnimState:SetBuild("farm_plant_carrot")	
			Anim路径 :  "anim/farm_plant_carrot.zip"	
 	
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
饥饿腰带			预设: armorslurper		路径： [string "scripts/prefabs/armor_slurper.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "fur", "ruins", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_slurper")	
			inst.AnimState:SetBuild("armor_slurper")	
			Anim路径 :  "anim/armor_slurper.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
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
胡萝卜种子			预设: carrot_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
切片熟石榴			预设: pomegranate_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
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
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
巨型石榴			预设: pomegranate_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_pomegranate_build")	
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
熊獾雕塑			预设: chesspiece_bearger		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_bearger_marble")	
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
MISSING NAME			预设: crab_king_waterspout		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
洋葱			预设: onion		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
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
巨型腐烂玉米			预设: corn_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_corn_build")	
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
骨头汤			预设: bonesoup		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蜂王雕塑			预设: chesspiece_beequeen_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
巨型玉米			预设: corn_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_corn_build")	
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
巨型玉米			预设: corn_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_corn_build")	
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
胡萝卜鼠神龛			预设: yotc_carratshrine		路径： [string "scripts/prefabs/yotc_carratshrine.lua"]	
	Tags▼	
	{":", "inspectable", "carratshrine", "HAMMER_workable", "canlight", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carratshrine")	
			inst.AnimState:SetBuild("yotc_carratshrine")	
			Anim路径 :  "anim/yotc_carratshrine.zip"	
 	
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
		inst:ListenForEvent("yotc_ratraceprizechange")	
		inst:ListenForEvent("ondeconstructstructure")	
------------------------------------------------	
超臭榴莲			预设: durian_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_MONSTER", "_stackable", "edible_VEGGIE", "badfood", "canlight", "fresh"}	
 	
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
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
巨型腐烂榴莲			预设: durian_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_durian_build")	
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
巨型茄子			预设: eggplant_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_eggplant_build")	
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
薇诺娜的发电机			预设: winona_battery_low		路径： [string "scripts/prefabs/winona_battery_low.lua"]	
	Tags▼	
	{":", "inspectable", "engineeringbattery", "CHEMICAL_fueled", "HAMMER_workable", "burnableignorefuel", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winona_battery_low")	
			inst.AnimState:SetBuild("winona_battery_low")	
			Anim路径 :  "anim/winona_battery_low.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("circuitnode")	
		inst:AddComponent("deployhelper")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("engineeringcircuitchanged")	
------------------------------------------------	
巨型辣椒			预设: pepper_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pepper")	
			inst.AnimState:SetBuild("farm_plant_pepper")	
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
甜芝士蛋糕			预设: powcake_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
块状种子			预设: pepper_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
魂灯			预设: nightlight		路径： [string "scripts/prefabs/nightlight.lua"]	
	Tags▼	
	{":", "inspectable", "wildfireprotected", "NIGHTMARE_fueled", "HAMMER_workable", "sanityaura", "nolight", "fire", "structure", "shadow_fire", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmare_torch")	
			inst.AnimState:SetBuild("nightmare_torch")	
			Anim路径 :  "anim/nightmare_torch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: ghostflower_spirit2_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: winona_battery_high_placer		路径： [string "scripts/prefabutil.lua"]	
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
损毁的废墟			预设: ruins_rubble_table		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "_combat", "healthrepairable", "smashable", "stone", "repairable_stone", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_table")	
			inst.AnimState:SetBuild("ruins_table")	
			Anim路径 :  "anim/ruins_table.zip"	
 	
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
寒冰护符			预设: blueamulet		路径： [string "scripts/prefabs/amulet.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "HASHEATER", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("amulets")	
			inst.AnimState:SetBuild("amulets")	
			Anim路径 :  "anim/amulets.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("equippable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("heater")	
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
尖种子			预设: pumpkin_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
烤火龙果			预设: dragonfruit_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonfruit")	
			inst.AnimState:SetBuild("dragonfruit")	
			Anim路径 :  "anim/dragonfruit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
蛛网蓝蘑菇树			预设: mushtree_tall_webbed		路径： [string "scripts/prefabs/mushtree_webbed.lua"]	
	Tags▼	
	{":", "webbed", "cavedweller", "inspectable", "FROMNUM", "mushtree", "tree", "plant", "CHOP_workable", "canlight", "shelter", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_tree_webbed")	
			inst.AnimState:SetBuild("mushroom_tree_webbed")	
			Anim路径 :  "anim/mushroom_tree_webbed.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
------------------------------------------------	
MISSING NAME			预设: quagmire_carrot_leaf		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_soil")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
球茎状种子			预设: dragonfruit_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
信号弹			预设: miniflare		路径： [string "scripts/prefabs/miniflare.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flare")	
			inst.AnimState:SetBuild("flare")	
			Anim路径 :  "anim/flare.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("tradable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
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
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
烤番茄			预设: tomato_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tomato")	
			inst.AnimState:SetBuild("tomato")	
			Anim路径 :  "anim/tomato.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("bait")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
番茄			预设: tomato		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tomato")	
			inst.AnimState:SetBuild("tomato")	
			Anim路径 :  "anim/tomato.zip"	
 	
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
巨型腐烂番茄			预设: tomato_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_tomato")	
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
巨型番茄			预设: tomato_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_tomato")	
			Anim路径 :  "anim/farm_plant_tomato.zip"	
 	
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
巨型番茄			预设: tomato_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_tomato")	
			inst.AnimState:SetBuild("farm_plant_tomato")	
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
沙堡			预设: sandblock		路径： [string "scripts/prefabs/sand_spike.lua"]	
	Tags▼	
	{":", "groundspike", "object", "_health", "cannotheal", "hostile", "_combat", "notarget", "stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sand_block")	
			inst.AnimState:SetBuild("sand_block")	
			Anim路径 :  "anim/sand_block.zip"	
 	
	使用的组件▼	
		inst:AddComponent("health")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: rubble_low		路径： [string "scripts/prefabs/rubble.lua"]	
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
甜曼德拉草汤			预设: mandrakesoup_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
小触手			预设: tentacle_pillar_arm		路径： [string "scripts/prefabs/tentacle_arm.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "wet", "idle", "tentacle_pillar_arm", "hostile", "_combat", "sanityaura", "soulless"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("tentacle_arm_build")	
			Anim路径 :  "anim/tentacle_arm.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("freezable")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("full_retreat")	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
巨型大蒜			预设: garlic_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_garlic")	
			inst.AnimState:SetBuild("farm_plant_garlic")	
			Anim路径 :  "anim/farm_plant_garlic.zip"	
 	
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
MISSING NAME			预设: shadow_puff_large_back		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: beefalo_transform_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
花衬衫			预设: hawaiianshirt		路径： [string "scripts/prefabs/hawaiianshirt.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "show_spoilage", "_equippable", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("torso_hawaiian")	
			Anim路径 :  "anim/torso_hawaiian.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("insulator")	
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
巨型大蒜			预设: garlic_oversized		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "waxable", "canlight", "show_spoilage", "weighable_OVERSIZEDVEGGIES", "_equippable", "fresh", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_garlic")	
			inst.AnimState:SetBuild("farm_plant_garlic")	
			Anim路径 :  "anim/farm_plant_garlic.zip"	
 	
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
种子荚			预设: garlic_seeds		路径： [string "scripts/prefabs/veggies.lua"]	
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
MISSING NAME			预设: wave_med		路径： [string "scripts/prefabs/wave.lua"]	
	Tags▼	
	{":", "fx", "scarytoprey", "wave"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("wave")	
			Anim路径 :  "anim/wave.zip"	
 	
	使用的组件▼	
		inst:AddComponent("boattrail")	
		
	使用的监听▼	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
无花果			预设: fig		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "cookable", "oceanfishing_lure", "edible_BERRY", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fig")	
			inst.AnimState:SetBuild("fig")	
			Anim路径 :  "anim/fig.zip"	
 	
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
雨伞			预设: umbrella		路径： [string "scripts/prefabs/umbrella.lua"]	
	Tags▼	
	{":", "_inventoryitem", "umbrella", "inspectable", "waterproofer", "_equippable", "nopunch"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("umbrella")	
			inst.AnimState:SetBuild("umbrella")	
			Anim路径 :  "anim/umbrella.zip"	
 	
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
MISSING NAME			预设: firesuppressor_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firefighter_placement")	
			inst.AnimState:SetBuild("firefighter_placement")	
			Anim路径 :  "anim/firefighter_placement.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: archive_orchestrina_base		路径： [string "scripts/prefabs/archive_orchestrina_main.lu..."]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_orchestrina_main")	
			inst.AnimState:SetBuild("archive_orchestrina_main")	
			Anim路径 :  "anim/archive_orchestrina_main.zip"	
 	
	使用的组件▼	
------------------------------------------------	
MISSING NAME			预设: gooball_hit_fx		路径： [string "scripts/prefabs/fireball_projectile.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: spawn_fx_medium_static		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
贝壳海滩地皮			预设: turf_shellbeach		路径： [string "scripts/prefabs/turfs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "groundtile", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turf_shellbeach")	
			inst.AnimState:SetBuild("turf_shellbeach")	
			Anim路径 :  "anim/turf_shellbeach.zip"	
 	
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
咸的恐怖国王饼			预设: nightmarepie_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
森林地皮			预设: turf_forest		路径： [string "scripts/prefabs/turfs.lua"]	
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
糖果			预设: quagmire_food_042		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
残破的烟囱			预设: quagmire_rubble_chimney2		路径： [string "scripts/prefabs/quagmire_oldstructures.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
鸟粪地皮			预设: turf_cave		路径： [string "scripts/prefabs/turfs.lua"]	
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
地毯地板			预设: turf_carpetfloor		路径： [string "scripts/prefabs/turfs.lua"]	
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
石果灌木丛			预设: dug_rock_avocado_bush		路径： [string "scripts/prefabs/plantables.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deployedplant", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("rock_avocado_build")	
			Anim路径 :  "anim/rock_avocado.zip"	
 	
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
木地板			预设: turf_woodfloor		路径： [string "scripts/prefabs/turfs.lua"]	
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
泥泞地皮			预设: turf_mud		路径： [string "scripts/prefabs/turfs.lua"]	
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
蒜香辣椒炖肉			预设: hotchili_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
姜饼猪			预设: gingerbreadpig		路径： [string "scripts/prefabs/gingerbreadpig.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "freezable", "idle", "_combat", "locomotor", "nolight", "character", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gingerbread_pigman")	
			inst.AnimState:SetBuild("gingerbread_pigman")	
			Anim路径 :  "anim/gingerbread_pigman.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
黏滑地皮			预设: turf_sinkhole		路径： [string "scripts/prefabs/turfs.lua"]	
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
珍珠的珍珠			预设: hermit_pearl		路径： [string "scripts/prefabs/hermit_pearl.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "gem", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hermit_pearl")	
			inst.AnimState:SetBuild("hermit_pearl")	
			Anim路径 :  "anim/hermit_pearl.zip"	
 	
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
MISSING NAME			预设: ocean_splash_ripple1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣龙虾汤			预设: lobsterbisque_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: weregoose_shock_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香酿茄子			预设: stuffedeggplant_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
松软背心			预设: trunkvest_winter		路径： [string "scripts/prefabs/trunkvest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_trunkvest_winter")	
			inst.AnimState:SetBuild("armor_trunkvest_winter")	
			Anim路径 :  "anim/armor_trunkvest_winter.zip"	
 	
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
透气背心			预设: trunkvest_summer		路径： [string "scripts/prefabs/trunkvest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_trunkvest_summer")	
			inst.AnimState:SetBuild("armor_trunkvest_summer")	
			Anim路径 :  "anim/armor_trunkvest_summer.zip"	
 	
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
冬象鼻			预设: trunk_winter		路径： [string "scripts/prefabs/trunk.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "cookable", "fresh"}	
 	
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
座狼神龛			预设: wargshrine		路径： [string "scripts/prefabs/wargshrine.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "wargshrine", "structure", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wargshrine")	
			inst.AnimState:SetBuild("wargshrine")	
			Anim路径 :  "anim/wargshrine.zip"	
 	
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
		inst:ListenForEvent("ondeconstructstructure")	
------------------------------------------------	
铥矿墙			预设: brokenwall_stone_2		路径： [string "scripts/prefabs/brokenwalls.lua"]	
	Tags▼	
	{":", "inspectable", "_named", "HAMMER_workable", "stone", "wall", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_stone_2")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("named")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: trophyscale_oversizedveggies_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trophyscale_oversizedveggies")	
			inst.AnimState:SetBuild("trophyscale_oversizedveggies")	
			Anim路径 :  "anim/trophyscale_oversizedveggies.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: halloweenpotion_sanity_large_buff		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: trophyscale_fish_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scale_o_matic")	
			inst.AnimState:SetBuild("scale_o_matic")	
			Anim路径 :  "anim/scale_o_matic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: quagmire_portal_bubblefx		路径： [string "scripts/prefabs/quagmire_portal.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
卒子雕塑			预设: chesspiece_pawn		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chesspiece_pawn_stone")	
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
                  Failed to spawn	lavaarenastage_blank	
------------------------------------------------	
MISSING NAME			预设: lantern_flower_fx_ground		路径： [string "scripts/prefabs/lantern_flower_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lantern")	
			Anim路径 :  "anim/dynamic/lantern_flower.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
黑色战车			预设: trinket_29		路径： [string "scripts/prefabs/trinkets.lua"]	
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
臭气制造器			预设: trinket_25		路径： [string "scripts/prefabs/trinkets.lua"]	
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
破搅拌器			预设: trinket_21		路径： [string "scripts/prefabs/trinkets.lua"]	
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
玩具木马			预设: trinket_18		路径： [string "scripts/prefabs/trinkets.lua"]	
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
漏水的茶杯			预设: trinket_14		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: archive_orchestrina_small		路径： [string "scripts/prefabs/archive_orchestrina_main.lu..."]	
	Tags▼	
	{":", "DECOR", "resonator_socket", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_orchestrina_main")	
			inst.AnimState:SetBuild("archive_orchestrina_main")	
			Anim路径 :  "anim/archive_orchestrina_main.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: firepit_firebird_puff_fx		路径： [string "scripts/prefabs/firepit_firebird_puff_fx.lu..."]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: balloon_pop_head		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: shatter		路径： [string "scripts/prefabs/shatter.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		inst:AddComponent("shatterfx")	
		
	使用的监听▼	
		inst:ListenForEvent("leveldirty")	
------------------------------------------------	
硬化橡胶塞			预设: trinket_8		路径： [string "scripts/prefabs/trinkets.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "oceanfishing_bobber", "cattoy"}	
 	
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
烂电线			预设: trinket_6		路径： [string "scripts/prefabs/trinkets.lua"]	
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
带刺的种子			预设: quagmire_seeds_3		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: emote_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_pig_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: quagmire_salting_plate_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
可疑的巨石			预设: rock_moon_shell		路径： [string "scripts/prefabs/rocks.lua"]	
	Tags▼	
	{":", "inspectable", "boulder", "MINE_workable", "meteor_protection", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonrock_shell")	
			inst.AnimState:SetBuild("moonrock_shell")	
			Anim路径 :  "anim/moonrock_shell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("workfinished")	
------------------------------------------------	
戈尔迪之结			预设: trinket_3		路径： [string "scripts/prefabs/trinkets.lua"]	
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
假卡祖笛			预设: trinket_2		路径： [string "scripts/prefabs/trinkets.lua"]	
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
泥鱼			预设: oceanfish_medium_1_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_1")	
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
刺耳三叉戟			预设: trident		路径： [string "scripts/prefabs/trident.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "guitar", "allow_action_on_impassable", "pointy", "sharp", "castonpointwater", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trident")	
			inst.AnimState:SetBuild("trident")	
			Anim路径 :  "anim/trident.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("reticule")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("spellcaster")	
		inst:AddComponent("tradable")	
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
沉底宝箱			预设: sunkenchest		路径： [string "scripts/prefabs/treasurechest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "_container", "chest", "HAMMER_workable", "structure", "_equippable", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sunken_treasurechest")	
			inst.AnimState:SetBuild("sunken_treasurechest")	
			Anim路径 :  "anim/sunken_treasurechest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("workable")	
		inst:AddComponent("submersible")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("heavyobstaclephysics")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("on_submerge")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("exitlimbo")	
------------------------------------------------	
大号华丽箱子			预设: minotaurchest		路径： [string "scripts/prefabs/treasurechest.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "chest", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pandoras_chest_large")	
			inst.AnimState:SetBuild("pandoras_chest_large")	
			Anim路径 :  "anim/pandoras_chest_large.zip"	
 	
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
MISSING NAME			预设: shadow_despawn		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
箱子			预设: treasurechest		路径： [string "scripts/prefabs/treasurechest.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "chest", "HAMMER_workable", "canlight", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("chest")	
			inst.AnimState:SetBuild("treasure_chest")	
			Anim路径 :  "anim/treasure_chest.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
MISSING NAME			预设: abigailunsummonfx_mount		路径： [string "scripts/prefabs/abigail_flower.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wendy_mount_recall_flower")	
			inst.AnimState:SetBuild("abigail_flower_rework")	
			Anim路径 :  "anim/wendy_mount_recall_flower.zip"	
 	
	使用的组件▼	
		inst:AddComponent("updatelooper")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: sweettea_buff		路径： [string "scripts/prefabs/forgetmelots.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
麦斯威尔的犬牙陷阱			预设: trap_teeth_maxwell		路径： [string "scripts/prefabs/trap_teeth.lua"]	
	Tags▼	
	{":", "inspectable", "trap", "mineactive", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trap_teeth_maxwell")	
			inst.AnimState:SetBuild("trap_teeth_maxwell")	
			Anim路径 :  "anim/trap_teeth_maxwell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("mine")	
		inst:AddComponent("deployable")	
		
	使用的监听▼	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onputininventory")	
------------------------------------------------	
MISSING NAME			预设: trap_teeth_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trap_teeth")	
			inst.AnimState:SetBuild("trap_teeth")	
			Anim路径 :  "anim/trap_teeth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
烤蝙蝠翅膀			预设: batwing_cooked		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "_stackable", "fresh", "batwing"}	
 	
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
MISSING NAME			预设: dug_trap_starfish_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("star_trap")	
			inst.AnimState:SetBuild("star_trap")	
			Anim路径 :  "anim/star_trap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: battlesong_instant_taunt_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣舒缓茶			预设: sweettea_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
鸦年华代币			预设: carnival_gametoken		路径： [string "scripts/prefabs/carnival_gametoken.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_gametoken")	
			inst.AnimState:SetBuild("carnival_gametoken")	
			Anim路径 :  "anim/carnival_gametoken.zip"	
 	
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
MISSING NAME			预设: dug_sapling_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sapling")	
			inst.AnimState:SetBuild("sapling")	
			Anim路径 :  "anim/sapling.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: goosplash3		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: torchfire_rag		路径： [string "scripts/prefabs/torchfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: torchfire_carrat		路径： [string "scripts/prefabs/torchfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
蒜香无花果蛙腿三明治			预设: frognewton_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: torchfire		路径： [string "scripts/prefabs/torchfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: toadstool_cap_releasefx		路径： [string "scripts/prefabs/toadstool_cap.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("canary")	
			inst.AnimState:SetBuild("canary_build")	
			Anim路径 :  "anim/canary.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: toadstool_cap_absorbfx		路径： [string "scripts/prefabs/toadstool_cap.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("toadstool")	
			inst.AnimState:SetBuild("toadstool_build")	
			Anim路径 :  "anim/toadstool_actions.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
悲惨的毒菌蟾蜍			预设: toadstool_dark		路径： [string "scripts/prefabs/toadstool.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "FROMNUM", "freezable", "idle", "hostile", "noepicmusic", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "nolight", "largecreature", "sleeper", "toadstool"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("toadstool")	
			inst.AnimState:SetBuild("toadstool_dark_build")	
			Anim路径 :  "anim/toadstool_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("groundpounder")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("grouptargeter")	
		inst:AddComponent("propagator")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("freezable")	
		inst:AddComponent("epicscare")	
		inst:AddComponent("healthtrigger")	
		inst:AddComponent("combat")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newstate")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("linkmushroomsprout")	
		inst:ListenForEvent("unlinkmushroomsprout")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("fleewarning")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
毒菌蟾蜍			预设: toadstool		路径： [string "scripts/prefabs/toadstool.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "FROMNUM", "freezable", "idle", "hostile", "noepicmusic", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "nolight", "largecreature", "sleeper", "toadstool"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("toadstool")	
			inst.AnimState:SetBuild("toadstool_build")	
			Anim路径 :  "anim/toadstool_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("groundpounder")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("grouptargeter")	
		inst:AddComponent("propagator")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("freezable")	
		inst:AddComponent("epicscare")	
		inst:AddComponent("healthtrigger")	
		inst:AddComponent("combat")	
		inst:AddComponent("timer")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newstate")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("linkmushroomsprout")	
		inst:ListenForEvent("unlinkmushroomsprout")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("fleewarning")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("healthdelta")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: tillweedsalve_buff		路径： [string "scripts/prefabs/tillweedsalve.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
石墙			预设: wall_stone_item		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "wallbuilder", "deployable", "repairer", "health_stone"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_stone")	
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
MISSING NAME			预设: thuriblebody		路径： [string "scripts/prefabs/thurible.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("thurible")	
			inst.AnimState:SetBuild("thurible")	
			Anim路径 :  "anim/thurible.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_klaus		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
黄宝石			预设: yellowgem		路径： [string "scripts/prefabs/gem.lua"]	
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
铥矿			预设: thulecite		路径： [string "scripts/prefabs/thulecite.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL", "work_thulecite", "health_thulecite", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("thulecite")	
			inst.AnimState:SetBuild("thulecite")	
			Anim路径 :  "anim/thulecite.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("repairer")	
		inst:AddComponent("tradable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("stackable")	
		inst:AddComponent("bait")	
		
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
MISSING NAME			预设: ghostlyelixir_attack_buff		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
触手尖刺			预设: tentaclespike		路径： [string "scripts/prefabs/tentaclespike.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spike")	
			inst.AnimState:SetBuild("tentacle_spike")	
			Anim路径 :  "anim/tentacle_spike.zip"	
 	
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
硕大的泥坑			预设: tentacle_pillar_hole		路径： [string "scripts/prefabs/tentacle_pillar_hole.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "wet", "alltrader", "tentacle_pillar", "_inventory", "rocky", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("tentacle_pillar")	
			Anim路径 :  "anim/tentacle_pillar.zip"	
 	
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
------------------------------------------------	
巨型腐烂大蒜			预设: garlic_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_garlic")	
			inst.AnimState:SetBuild("farm_plant_garlic")	
			Anim路径 :  "anim/farm_plant_garlic.zip"	
 	
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
邪天翁喙			预设: malbatross_beak		路径： [string "scripts/prefabs/oar.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "allow_action_on_impassable", "canlight", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("malbatross_beak")	
			inst.AnimState:SetBuild("malbatross_beak")	
			Anim路径 :  "anim/malbatross_beak.zip"	
 	
	使用的组件▼	
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
远古雕像			预设: ruins_statue_head_nogem		路径： [string "scripts/prefabs/statueruins.lua"]	
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
		
                  Event data unavailable: quagmire_event_server/prefabs/quagmire_book_fertilizer
------------------------------------------------	
应用园艺学			预设: quagmire_book_fertilizer		路径： [string "scripts/prefabs/quagmire_book_fertilizer.lu..."]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("books")	
			inst.AnimState:SetBuild("books")	
			Anim路径 :  "anim/books.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
帐篷			预设: tent		路径： [string "scripts/prefabs/tent.lua"]	
	Tags▼	
	{":", "inspectable", "tent", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tent")	
			inst.AnimState:SetBuild("tent")	
			Anim路径 :  "anim/tent.zip"	
 	
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
小格罗姆			预设: critter_glomling		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "notraptrigger", "inspectable", "companion", "idle", "small_livestock", "NOBLOCK", "locomotor", "OMNI_eater", "_follower", "flying", "ignorewalkableplatformdrowning", "critter", "sleeper", "noauradamage", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("glomling_build")	
			Anim路径 :  "anim/glomling_basic.zip"	
 	
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
曲柄零件			预设: teleportato_crank		路径： [string "scripts/prefabs/teleportato_parts.lua"]	
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
MISSING NAME			预设: schoolherd_oceanfish_small_1		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
绿色月眼			预设: greenmooneye		路径： [string "scripts/prefabs/mooneye.lua"]	
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
宝石底座			预设: gemsocket		路径： [string "scripts/prefabs/telebase_gemsocket.lua"]	
	Tags▼	
	{":", "gemsocket", "trader", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("staff_purple_base")	
			inst.AnimState:SetBuild("staff_purple_base")	
			Anim路径 :  "anim/staff_purple_base.zip"	
 	
	使用的组件▼	
		inst:AddComponent("pickable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("trader")	
		
------------------------------------------------	
MISSING NAME			预设: fencepost		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
高脚鸟蛋			预设: tallbirdegg		路径： [string "scripts/prefabs/tallbirdegg.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "tallbirdegg", "cattoy", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("egg")	
			inst.AnimState:SetBuild("tallbird_egg")	
			Anim路径 :  "anim/tallbird_egg.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("cookable")	
		inst:AddComponent("hatchable")	
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
MISSING NAME			预设: fissure_grottowar		路径： [string "scripts/prefabs/nightmarefissure.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fissure_grottowar")	
			inst.AnimState:SetBuild("fissure_grottowar")	
			Anim路径 :  "anim/fissure_grottowar.zip"	
 	
	使用的组件▼	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
		
------------------------------------------------	
钓具容器			预设: tacklestation		路径： [string "scripts/prefabs/tacklestation.lua"]	
	Tags▼	
	{":", "tacklestation", "inspectable", "HAMMER_workable", "canlight", "structure", "prototyper", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tackle_station")	
			inst.AnimState:SetBuild("tackle_station")	
			Anim路径 :  "anim/tackle_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("prototyper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("craftingstation")	
		
	使用的监听▼	
		inst:ListenForEvent("onlearnednewtacklesketch")	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
哨兵蜈蚣壳			预设: archive_centipede_husk		路径： [string "scripts/prefabs/archive_centipede.lua"]	
	Tags▼	
	{":", "mech", "_health", "inspectable", "_combat", "security_powerpoint"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_centipede")	
			inst.AnimState:SetBuild("archive_centipede_build")	
			Anim路径 :  "anim/archive_centipede.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("combat")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("possess")	
		inst:ListenForEvent("attacked")	
------------------------------------------------	
MISSING NAME			预设: year_of_the_varg_event_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
触手的召唤			预设: book_tentacles		路径： [string "scripts/prefabs/books.lua"]	
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
火坑			预设: firepit		路径： [string "scripts/prefabs/firepit.lua"]	
	Tags▼	
	{":", "BURNABLE_fueled", "campfire", "inspectable", "wildfireprotected", "HAMMER_workable", "cooker", "nolight", "storytellingprop", "fire", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firepit")	
			inst.AnimState:SetBuild("firepit")	
			Anim路径 :  "anim/firepit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("storytellingprop")	
		inst:AddComponent("cooker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("fueled")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("death")	
------------------------------------------------	
辣炖肉汤			预设: bonestew_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
天体探测仪			预设: archive_resonator_item		路径： [string "scripts/prefabs/archive_resonator.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "deployable", "usedeploystring"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("archive_resonator")	
			inst.AnimState:SetBuild("archive_resonator")	
			Anim路径 :  "anim/archive_resonator.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("deployable")	
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
咸的西瓜冰棍			预设: watermelonicle_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
指路标志			预设: arrowsign_panel		路径： [string "scripts/prefabs/arrowsign.lua"]	
	Tags▼	
	{":", "_writeable", "sign", "inspectable", "writeable", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_arrow_panel")	
			inst.AnimState:SetBuild("sign_arrow_panel")	
			Anim路径 :  "anim/sign_arrow_panel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("savedrotation")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("writeable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: purple_leaves		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: abigail_attack_fx		路径： [string "scripts/prefabs/abigail_attack_fx.lua"]	
	Tags▼	
	{":", "FROMNUM"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_attack_fx")	
			inst.AnimState:SetBuild("abigail_attack_fx")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		
------------------------------------------------	
钓具箱			预设: tacklecontainer		路径： [string "scripts/prefabs/tacklecontainer.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_container", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tacklecontainer")	
			inst.AnimState:SetBuild("tacklecontainer")	
			Anim路径 :  "anim/tacklecontainer.zip"	
 	
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
MISSING NAME			预设: fireball_projectile		路径： [string "scripts/prefabs/fireball_projectile.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
冬季盛宴餐桌			预设: table_winters_feast		路径： [string "scripts/prefabs/table_winters_feast.lua"]	
	Tags▼	
	{":", "trader", "inspectable", "HAMMER_workable", "_inventory", "canlight", "wintersfeasttable", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("table_winters_feast")	
			inst.AnimState:SetBuild("table_winters_feast")	
			Anim路径 :  "anim/table_winters_feast.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("workable")	
		inst:AddComponent("shelf")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("deployhelper")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inventory")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("wintersfeasttable")	
		
	使用的监听▼	
		inst:ListenForEvent("ruffle")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
犬牙背心			预设: sweatervest		路径： [string "scripts/prefabs/sweatervest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_sweatervest")	
			inst.AnimState:SetBuild("armor_sweatervest")	
			Anim路径 :  "anim/armor_sweatervest.zip"	
 	
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
MISSING NAME			预设: superjump_fx		路径： [string "scripts/prefabs/superjump_fx.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wilson")	
			inst.AnimState:SetBuild("player_superjump")	
			Anim路径 :  "anim/player_superjump.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
                  Event data unavailable: lavaarena_event_server/prefabs/sunderarmordebuff
------------------------------------------------	
MISSING NAME			预设: sunderarmordebuff		路径： [string "scripts/prefabs/sunderarmordebuff.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_sunder_armor")	
			inst.AnimState:SetBuild("lavaarena_sunder_armor")	
			Anim路径 :  "anim/lavaarena_sunder_armor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
多肉植物			预设: succulent_picked		路径： [string "scripts/prefabs/succulent_plant.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "cattoy", "BURNABLE_fuel", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("succulent_picked")	
			inst.AnimState:SetBuild("succulent_picked")	
			Anim路径 :  "anim/succulent_picked.zip"	
 	
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
MISSING NAME			预设: collapse_small		路径： [string "scripts/prefabs/structure_collapse_fx.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: steeringwheel_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_wheel")	
			inst.AnimState:SetBuild("boat_wheel")	
			Anim路径 :  "anim/boat_wheel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
方向舵			预设: steeringwheel		路径： [string "scripts/prefabs/steeringwheel.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "steeringwheel", "structure"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_wheel")	
			inst.AnimState:SetBuild("boat_wheel")	
			Anim路径 :  "anim/boat_wheel.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("steeringwheel")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: ruins_statue_mage_nogem_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
索耶			预设: pigelitefighter4		路径： [string "scripts/prefabs/pigelitefighter.lua"]	
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
蛙腿			预设: froglegs		路径： [string "scripts/prefabs/froglegs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "smallmeat", "dryable", "_stackable", "badfood", "cookable", "catfood", "fresh"}	
 	
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
		inst:AddComponent("dryable")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("cookable")	
		
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
红袋子			预设: redpouch_yotp		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("redpouch_yotp")	
			inst.AnimState:SetBuild("redpouch_yotp")	
			Anim路径 :  "anim/redpouch_yotp.zip"	
 	
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
红袋子			预设: redpouch_yotc		路径： [string "scripts/prefabs/bundle.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "unwrappable", "canlight", "bundle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("redpouch_yotc")	
			inst.AnimState:SetBuild("redpouch_yotc")	
			Anim路径 :  "anim/redpouch_yotc.zip"	
 	
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
MISSING NAME			预设: ruins_statue_mage_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
海黾巢穴			预设: oceanvine_cocoon_burnt		路径： [string "scripts/prefabs/oceanvine_cocoon.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "_combat", "flying", "ignorewalkableplatform"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanvine_cocoon")	
			Anim路径 :  "anim/oceanvine_cocoon.zip"	
 	
	使用的组件▼	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: ruins_statue_head_ruinsrespawner_inst		路径： [string "scripts/prefabs/ruinsrespawner.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("objectspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("resetruins")	
------------------------------------------------	
远古雕像			预设: ruins_statue_mage		路径： [string "scripts/prefabs/statueruins.lua"]	
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
采下的草			预设: cutgrass		路径： [string "scripts/prefabs/cutgrass.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_ROUGHAGE", "_stackable", "renewable", "health_hay", "cattoy", "BURNABLE_fuel", "canlight", "repairer"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cutgrass")	
			inst.AnimState:SetBuild("cutgrass")	
			Anim路径 :  "anim/cutgrass.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
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
MISSING NAME			预设: tent_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tent")	
			inst.AnimState:SetBuild("tent")	
			Anim路径 :  "anim/tent.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
圣诞灯			预设: winter_ornament_light6		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
MISSING NAME			预设: alterguardian_laserscorch		路径： [string "scripts/prefabs/alterguardian_laser.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("burntground")	
			inst.AnimState:SetBuild("burntground")	
			Anim路径 :  "anim/burntground.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
天体圣殿象征			预设: moon_altar_icon		路径： [string "scripts/prefabs/moon_altar_pieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "work_moon_altar", "nonpotatable", "_equippable", "repairer", "irreplaceable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_altar_iconpiece")	
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
MISSING NAME			预设: stalker_shield4		路径： [string "scripts/prefabs/stalker_shield.lua"]	
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
编织暗影			预设: stalker_minion2		路径： [string "scripts/prefabs/stalker_minions.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "idle", "fossil", "hostile", "_combat", "locomotor", "sanityaura", "stalkerminion"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("stalker_minion_2")	
			inst.AnimState:SetBuild("stalker_minion_2")	
			Anim路径 :  "anim/stalker_minion_2.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("entitytracker")	
		inst:AddComponent("timer")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("timerdone")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: deer_fire_charge		路径： [string "scripts/prefabs/deer_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deer_fire_charge")	
			inst.AnimState:SetBuild("deer_fire_charge")	
			Anim路径 :  "anim/deer_fire_charge.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
小浣猫			预设: critter_kitten_builder		路径： [string "scripts/prefabs/critters.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蕨类植物			预设: stalker_fern		路径： [string "scripts/prefabs/stalker_ferns.lua"]	
	Tags▼	
	{":", "stalkerbloom", "quickpick", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("forest_ferns")	
			Anim路径 :  "anim/forest_ferns.zip"	
 	
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
石笋			预设: stalagmite_tall_low		路径： [string "scripts/prefabs/stalagmite_tall.lua"]	
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
皮弗娄牛铃			预设: beef_bell		路径： [string "scripts/prefabs/beef_bell.lua"]	
	Tags▼	
	{":", "bell", "_inventoryitem", "beefalo_targeter", "inspectable", "useabletargeteditem_inventorydisable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cowbell")	
			inst.AnimState:SetBuild("cowbell")	
			Anim路径 :  "anim/cowbell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("migrationpetowner")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("useabletargeteditem")	
		inst:AddComponent("leader")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: fan_wheel		路径： [string "scripts/prefabs/fan_wheel.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
托尼甜面包			预设: panettone		路径： [string "scripts/prefabs/wintersfeastcookedfoods.lua"]	
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
石笋			预设: stalagmite_low		路径： [string "scripts/prefabs/stalagmite.lua"]	
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
MISSING NAME			预设: quagmire_fest_frontend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
帝王蟹雕塑			预设: chesspiece_crabking_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
------------------------------------------------	
极光			预设: staffcoldlight		路径： [string "scripts/prefabs/stafflight.lua"]	
	Tags▼	
	{":", "inspectable", "HASHEATER", "sanityaura", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("star_cold")	
			inst.AnimState:SetBuild("star_cold")	
			Anim路径 :  "anim/star_cold.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("timer")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: minerhatlight		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		
------------------------------------------------	
矮星			预设: stafflight		路径： [string "scripts/prefabs/stafflight.lua"]	
	Tags▼	
	{":", "inspectable", "daylight", "cooker", "HASHEATER", "sanityaura", "ignorewalkableplatforms"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("star_hot")	
			inst.AnimState:SetBuild("star_hot")	
			Anim路径 :  "anim/star_hot.zip"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("cooker")	
		inst:AddComponent("timer")	
		inst:AddComponent("propagator")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("sanityaura")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: pocketwatch_warpbackout_fx		路径： [string "scripts/prefabs/staffcastfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_warp_casting_fx")	
			inst.AnimState:SetBuild("pocketwatch_warp_casting_fx")	
			Anim路径 :  "anim/pocketwatch_warp_casting_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: fossilized_break_fx		路径： [string "scripts/prefabs/fossilized_fx.lua"]	
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
MISSING NAME			预设: pocketwatch_cast_fx_mount		路径： [string "scripts/prefabs/staffcastfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_casting_fx_mount")	
			inst.AnimState:SetBuild("pocketwatch_casting_fx_mount")	
			Anim路径 :  "anim/pocketwatch_casting_fx_mount.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: pocketwatch_cast_fx		路径： [string "scripts/prefabs/staffcastfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_cast_fx")	
			inst.AnimState:SetBuild("pocketwatch_casting_fx")	
			Anim路径 :  "anim/pocketwatch_casting_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: alterguardian_spintrail_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
唤星者魔杖			预设: yellowstaff		路径： [string "scripts/prefabs/staff.lua"]	
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
拆解魔杖			预设: greenstaff		路径： [string "scripts/prefabs/staff.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "castonrecipes", "_equippable", "nopunch"}	
 	
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
暗影伐木工			预设: shadowlumber_builder		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
------------------------------------------------	
蟹肉			预设: quagmire_crabmeat		路径： [string "scripts/prefabs/quagmire_fish.lua"]	
	Tags▼	
	{":", "meat", "quagmire_stewable", "cookable", "catfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_crabmeat")	
			inst.AnimState:SetBuild("quagmire_crabmeat")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
国王雕塑			预设: chesspiece_formal_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蜜蜂地雷			预设: beemine		路径： [string "scripts/prefabs/beemine.lua"]	
	Tags▼	
	{":", "mine", "_inventoryitem", "inspectable", "HAMMER_workable", "mineactive", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_mine")	
			inst.AnimState:SetBuild("bee_mine")	
			Anim路径 :  "anim/bee_mine.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("deployable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("mine")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("onpickup")	
------------------------------------------------	
野猪猩			预设: trails1		路径： [string "scripts/prefabs/lavaarena_trails.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trails")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
冰魔杖			预设: icestaff		路径： [string "scripts/prefabs/staff.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "icestaff", "extinguisher", "rangedweapon", "_equippable", "weapon"}	
 	
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
MISSING NAME			预设: squidherd		路径： [string "scripts/prefabs/squidherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("herd")	
		
------------------------------------------------	
伯尼！			预设: bernie_big		路径： [string "scripts/prefabs/bernie_big.lua"]	
	Tags▼	
	{":", "busy", "_health", "inspectable", "companion", "crazy", "_combat", "locomotor", "soulless", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bernie_big")	
			inst.AnimState:SetBuild("bernie_build")	
			Anim路径 :  "anim/bernie_big.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("timer")	
		inst:AddComponent("embarker")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: squideyelight		路径： [string "scripts/prefabs/squid.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	使用的组件▼	
		inst:AddComponent("fader")	
		
------------------------------------------------	
MISSING NAME			预设: mushroom_light_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroom_light")	
			inst.AnimState:SetBuild("mushroom_light")	
			Anim路径 :  "anim/mushroom_light.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
熔炉传送门			预设: lavaarena_spawner		路径： [string "scripts/prefabs/lavaarena_spawner.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_spawner")	
			inst.AnimState:SetBuild("lavaarena_spawner")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
木头			预设: log		路径： [string "scripts/prefabs/log.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "health_wood", "BURNABLE_fuel", "canlight", "repairer", "edible_WOOD"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("log")	
			inst.AnimState:SetBuild("log")	
			Anim路径 :  "anim/log.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
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
MISSING NAME			预设: madscience_lab_glow		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("madscience_lab")	
			inst.AnimState:SetBuild("madscience_lab")	
			Anim路径 :  "anim/madscience_lab.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
浣猫			预设: catcoon		路径： [string "scripts/prefabs/catcoon.lua"]	
	Tags▼	
	{":", "trader", "_health", "inspectable", "freezable", "catcoon", "idle", "_inventory", "smallcreature", "_combat", "locomotor", "nolight", "_follower", "animal", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("catcoon")	
			inst.AnimState:SetBuild("catcoon_build")	
			Anim路径 :  "anim/catcoon_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("combat")	
		inst:AddComponent("freezable")	
		inst:AddComponent("inventory")	
		inst:AddComponent("burnable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("playerprox")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("health")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("follower")	
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
MISSING NAME			预设: gargoyle_werepighowl_fx		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
月光玻璃尖刺			预设: alterguardian_phase2spike		路径： [string "scripts/prefabs/alterguardian_phase2spike.l..."]	
	Tags▼	
	{":", "groundspike", "inspectable", "moonglass", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_spike")	
			inst.AnimState:SetBuild("alterguardian_spike")	
			Anim路径 :  "anim/alterguardian_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: rubble2		路径： [string "scripts/prefabs/archive_props.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: crow_carnival_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
针鼻喷墨鱼			预设: oceanfish_small_2_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_2")	
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
加州卷			预设: californiaroll		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: sporecloud_overlay		路径： [string "scripts/prefabs/sporecloud.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sporecloud")	
			inst.AnimState:SetBuild("sporecloud")	
			Anim路径 :  "anim/sporecloud.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: sporebomb		路径： [string "scripts/prefabs/sporebomb.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sporebomb")	
			inst.AnimState:SetBuild("sporebomb")	
			Anim路径 :  "anim/sporebomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
芦笋汤			预设: asparagussoup		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
月光龙虾			预设: wobster_moonglass		路径： [string "scripts/prefabs/wobster.lua"]	
	Tags▼	
	{":", "busy", "weighable_fish", "oceanfishable", "oceanfishinghookable", "NOBLOCK", "locomotor", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lobster_moonglass")	
			Anim路径 :  "anim/lobster_water.zip"	
 	
	使用的组件▼	
		inst:AddComponent("weighable")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("oceanfishable")	
		
	SG = 有▼	
------------------------------------------------	
辣海鲜杂烩			预设: moqueca_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
甜蜜汁火腿			预设: honeyham_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
皮弗娄牛舞台			预设: yotb_post		路径： [string "scripts/prefabs/yotb_post.lua"]	
	Tags▼	
	{":", "hitcher", "inspectable", "HAMMER_workable", "yotb_post", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("yotb_post")	
			inst.AnimState:SetBuild("yotb_post")	
			Anim路径 :  "anim/yotb_post.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("markable")	
		inst:AddComponent("talker")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("hitcher")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onburnt")	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: beetletaur_fossilized_break_fx_alt		路径： [string "scripts/prefabs/lavaarena_beetletaur.lua"]	
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
MISSING NAME			预设: splash_spiderweb		路径： [string "scripts/prefabs/splash_spiderweb.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
强征传送塔			预设: townportal		路径： [string "scripts/prefabs/townportal.lua"]	
	Tags▼	
	{":", "channelable", "inspectable", "HAMMER_workable", "structure", "townportal", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("townportal")	
			inst.AnimState:SetBuild("townportal")	
			Anim路径 :  "anim/townportal.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("channelable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("teleporter")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("doneteleporting")	
		inst:ListenForEvent("linktownportals")	
------------------------------------------------	
肉碎			预设: quagmire_smallmeat		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "rawmeat", "_stackable", "cookable", "catfood", "fresh"}	
 	
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
MISSING NAME			预设: grasspartfx		路径： [string "scripts/prefabs/grass.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("grass")	
			inst.AnimState:SetBuild("grass1")	
			Anim路径 :  "anim/grass.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
蛛网岩			预设: spiderhole_rock		路径： [string "scripts/prefabs/spiderhole.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "MINE_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_mound")	
			inst.AnimState:SetBuild("spider_mound")	
			Anim路径 :  "anim/spider_mound.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
红宝石			预设: redgem		路径： [string "scripts/prefabs/gem.lua"]	
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
圣诞灯			预设: winter_ornament_light1		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
辣辣龙椒沙拉			预设: dragonchilisalad_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
蘑菇汉堡			预设: quagmire_food_035		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: treegrowthsolution_use_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蜘蛛卵			预设: spidereggsack		路径： [string "scripts/prefabs/spidereggsack.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "cattoy", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_egg_sac")	
			inst.AnimState:SetBuild("spider_egg_sac")	
			Anim路径 :  "anim/spider_egg_sac.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("tradable")	
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
蛛巢装饰套装			预设: spiderden_bedazzler		路径： [string "scripts/prefabs/spiderden_bedazzler.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spiderden_bedazzler")	
			inst.AnimState:SetBuild("spiderden_bedazzler")	
			Anim路径 :  "anim/spiderden_bedazzler.zip"	
 	
	使用的组件▼	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("bedazzler")	
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
MISSING NAME			预设: carnivalgame_memory_kit_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_memory_station")	
			inst.AnimState:SetBuild("carnivalgame_memory_station")	
			Anim路径 :  "anim/carnivalgame_memory_station.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
"葡萄干"			预设: halloweencandy_6		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
MISSING NAME			预设: spat_splash_fx_melted		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
变质的鱼			预设: spoiled_fish		路径： [string "scripts/prefabs/spoiledfood.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "tile_deploy", "inspectable", "spoiled_fish", "selfstacker", "icebox_valid", "HAMMER_workable", "_stackable", "BURNABLE_fuel", "badfood", "fertilizer", "canlight", "fertilizerresearchable", "show_spoiled", "saltbox_valid", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spoiled_fish")	
			inst.AnimState:SetBuild("spoiled_fish")	
			Anim路径 :  "anim/spoiled_fish.zip"	
 	
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
MISSING NAME			预设: spider_web_spit_creep		路径： [string "scripts/prefabs/spider_web_spit_creep.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: spider_web_spit		路径： [string "scripts/prefabs/spider_web_spit.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_spit")	
			inst.AnimState:SetBuild("spider_spit")	
			Anim路径 :  "anim/spider_spit.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
------------------------------------------------	
MISSING NAME			预设: explosivehit		路径： [string "scripts/prefabs/explosivehit.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ghost_transform_overlay_fx		路径： [string "scripts/prefabs/ghost_transform_overlay_fx...."]	
	Tags▼	
	{":", "fx", "FROMNUM", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("player_revive_fx")	
			inst.AnimState:SetBuild("player_revive_fx")	
			Anim路径 :  "anim/player_revive_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animqueueover")	
------------------------------------------------	
遗物复制品 碟子			预设: ruinsrelic_plate		路径： [string "scripts/prefabs/ruinsrelic.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_plate")	
			inst.AnimState:SetBuild("ruins_plate")	
			Anim路径 :  "anim/ruins_plate.zip"	
 	
	使用的组件▼	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
MISSING NAME			预设: waterstreak_projectile		路径： [string "scripts/prefabs/waterprojectiles.lua"]	
	Tags▼	
	{":", "projectile", "locomotor", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("waterstreak")	
			inst.AnimState:SetBuild("waterstreak")	
			Anim路径 :  "anim/waterstreak.zip"	
 	
	使用的组件▼	
		inst:AddComponent("wateryprotection")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
海黾变身涂鸦			预设: mutator_water		路径： [string "scripts/prefabs/spider_mutators.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "edible_MONSTER", "_stackable", "monstermeat", "BURNABLE_fuel", "badfood", "canlight", "spidermutator"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_water_mutator")	
			inst.AnimState:SetBuild("spider_water_mutator")	
			Anim路径 :  "anim/spider_water_mutator.zip"	
 	
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
毛丛			预设: furtuft		路径： [string "scripts/prefabs/furtuft.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bearger_tuft")	
			inst.AnimState:SetBuild("bearger_tuft")	
			Anim路径 :  "anim/bearger_tuft.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fuel")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("disappears")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
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
破碎变身涂鸦			预设: mutator_moon		路径： [string "scripts/prefabs/spider_mutators.lua"]	
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
月蛾			预设: moonbutterfly		路径： [string "scripts/prefabs/moonbutterfly.lua"]	
	Tags▼	
	{":", "_inventoryitem", "busy", "VEGGIE_eater", "deployedplant", "_health", "inspectable", "FROMNUM", "wildfireprotected", "butterfly", "freezable", "insect", "small_livestock", "smallcreature", "_stackable", "_combat", "locomotor", "NET_workable", "nolight", "flying", "show_spoilage", "cattoyairborne", "deployable", "ignorewalkableplatformdrowning", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("butterfly")	
			inst.AnimState:SetBuild("butterfly_moon")	
			Anim路径 :  "anim/butterfly_basic.zip"	
 	
	使用的组件▼	
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
		inst:AddComponent("health")	
		inst:AddComponent("deployable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("stackable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("death")	
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
------------------------------------------------	
MISSING NAME			预设: bedazzle_buff		路径： [string "scripts/prefabs/spider_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: spider_whistle_buff		路径： [string "scripts/prefabs/spider_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: chandelier_fire		路径： [string "scripts/prefabs/archive_chandelier.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("chandelier_fire")	
			inst.AnimState:SetBuild("chandelier_fire")	
			Anim路径 :  "anim/chandelier_fire.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
姐妹骨灰罐			预设: sisturn		路径： [string "scripts/prefabs/sisturn.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sisturn")	
			inst.AnimState:SetBuild("sisturn")	
			Anim路径 :  "anim/sisturn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
海黾			预设: spider_water		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "spider_water", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "show_spoilage", "drop_inventory_onmurder", "sleeper", "eatsrawmeat", "spider", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_water")	
			inst.AnimState:SetBuild("spider_water")	
			Anim路径 :  "anim/spider_water.zip"	
 	
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
		inst:AddComponent("amphibiouscreature")	
		inst:AddComponent("eater")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("trader")	
		inst:AddComponent("timer")	
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
粗壮常青树			预设: quagmire_evergreen		路径： [string "scripts/prefabs/quagmire_evergreen.lua"]	
	Tags▼	
	{":", "tree", "plant", "shelter", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("evergreen_short")	
			inst.AnimState:SetBuild("evergreen_new_2")	
			Anim路径 :  "anim/evergreen_short_normal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
小虚影			预设: alterguardianhat_projectile		路径： [string "scripts/prefabs/gestalt_alterguardian_proje..."]	
	Tags▼	
	{":", "crazy", "NOBLOCK", "_combat", "extinguisher", "_follower", "brightmare", "NOCLICK", "brightmare_guard"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt_evolved")	
			inst.AnimState:SetBuild("brightmare_gestalt_evolved")	
			Anim路径 :  "anim/brightmare_gestalt_evolved.zip"	
 	
	使用的组件▼	
		inst:AddComponent("follower")	
		inst:AddComponent("combat")	
		inst:AddComponent("transparentonsanity")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: slingshotammo_thulecite_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
穴居悬蛛			预设: spider_dropper		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "halloweenmoonmutable", "show_spoilage", "drop_inventory_onmurder", "sleeper", "eatsrawmeat", "spider", "fresh", "spider_warrior"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider")	
			inst.AnimState:SetBuild("spider_white")	
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
MISSING NAME			预设: hermit_bundle_shells_unwrap		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
辣太妃糖			预设: taffy_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
裂缝表			预设: pocketwatch_portal		路径： [string "scripts/prefabs/pocketwatch_portal.lua"]	
	Tags▼	
	{":", "_inventoryitem", "pocketwatch_inactive", "inspectable", "pocketwatch_castfrominventory", "recall_unmarked", "rechargeable", "pocketwatch", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch")	
			inst.AnimState:SetBuild("pocketwatch_portal")	
			Anim路径 :  "anim/pocketwatch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("pocketwatch")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("recallmark")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("rechargeable")	
		inst:AddComponent("lootdropper")	
		
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
                  Failed to spawn	quagmirestage_endofmatch	
------------------------------------------------	
MISSING NAME			预设: buff_attack		路径： [string "scripts/prefabs/foodbuffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
烤大蒜			预设: quagmire_garlic_cooked		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蜘蛛			预设: spider		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "halloweenmoonmutable", "show_spoilage", "drop_inventory_onmurder", "sleeper", "eatsrawmeat", "spider", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider")	
			inst.AnimState:SetBuild("spider_build")	
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
调味盐			预设: spice_salt		路径： [string "scripts/prefabs/spices.lua"]	
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
追蛋套裝			预设: carnivalgame_herding_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_herding_station")	
			inst.AnimState:SetBuild("carnivalgame_herding_station")	
			Anim路径 :  "anim/carnivalgame_herding_station.zip"	
 	
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
溯源表			预设: pocketwatch_recall		路径： [string "scripts/prefabs/pocketwatch.lua"]	
	Tags▼	
	{":", "_inventoryitem", "pocketwatch_inactive", "gemsocket", "trader", "inspectable", "pocketwatch_castfrominventory", "recall_unmarked", "pocketwatch_warp_casting", "rechargeable", "pocketwatch", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch")	
			inst.AnimState:SetBuild("pocketwatch_recall")	
			Anim路径 :  "anim/pocketwatch.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("pocketwatch")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("recallmark")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("rechargeable")	
		inst:AddComponent("lootdropper")	
		
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
咸的花式回旋块茎			预设: potatotornado_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
强健精油			预设: ghostlyelixir_speed		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
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
钥匙			预设: quagmire_key		路径： [string "scripts/prefabs/quagmire_key.lua"]	
	Tags▼	
	{":", "klaussackkey", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_key")	
			inst.AnimState:SetBuild("quagmire_key")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
厨师袋			预设: spicepack		路径： [string "scripts/prefabs/spicepack.lua"]	
	Tags▼	
	{":", "_inventoryitem", "backpack", "foodpreserver", "inspectable", "nocool", "_container", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("swap_chefpack")	
			Anim路径 :  "anim/backpack.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("container")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("itemlose")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
晨星锤			预设: nightstick		路径： [string "scripts/prefabs/nightstick.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "wildfireprotected", "nolight", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightstick")	
			inst.AnimState:SetBuild("nightstick")	
			Anim路径 :  "anim/nightstick.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("fueled")	
		inst:AddComponent("inspectable")	
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
MISSING NAME			预设: schoolherd_oceanfish_medium_2		路径： [string "scripts/prefabs/schoolherd.lua"]	
	Tags▼	
	{":", "herd", "NOBLOCK", "NOCLICK"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("herd")	
		inst:AddComponent("knownlocations")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
MISSING NAME			预设: spear_gungnir_lungefx		路径： [string "scripts/prefabs/spear_gungnir.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_staff_smoke_fx")	
			inst.AnimState:SetBuild("lavaarena_staff_smoke_fx")	
			Anim路径 :  "anim/lavaarena_staff_smoke_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
活板门			预设: carnivalgame_memory_card		路径： [string "scripts/prefabs/carnivalgame_memory.lua"]	
	Tags▼	
	{":", "inspectable", "carnivalgame_part", "scarytoprey", "quickactivation", "birdblocker", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_memory_card")	
			inst.AnimState:SetBuild("carnivalgame_memory_card")	
			Anim路径 :  "anim/carnivalgame_memory_card.zip"	
 	
	使用的组件▼	
		inst:AddComponent("activatable")	
		inst:AddComponent("inspectable")	
		
	SG = 有▼	
------------------------------------------------	
冰冻弹药			预设: slingshotammo_freeze		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
		inst:ListenForEvent("ammounloaded")	
		inst:ListenForEvent("ammoloaded")	
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
MISSING NAME			预设: slow_steam_fx4		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: tumbleweedbreakfx		路径： [string "scripts/prefabs/tumbleweed.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tumbleweed")	
			inst.AnimState:SetBuild("tumbleweed")	
			Anim路径 :  "anim/tumbleweed.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
哀悼荣耀			预设: ghostflower		路径： [string "scripts/prefabs/ghostflower.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ghostflower")	
			inst.AnimState:SetBuild("ghostflower")	
			Anim路径 :  "anim/ghostflower.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
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
		inst:ListenForEvent("ondropped")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
便便桶			预设: fertilizer		路径： [string "scripts/prefabs/fertilizer.lua"]	
	Tags▼	
	{":", "_inventoryitem", "tile_deploy", "inspectable", "fertilizer", "fertilizerresearchable", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fertilizer")	
			inst.AnimState:SetBuild("fertilizer")	
			Anim路径 :  "anim/fertilizer.zip"	
 	
	使用的组件▼	
		inst:AddComponent("smotherer")	
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
冰			预设: ice		路径： [string "scripts/prefabs/inv_rocks_ice.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_GENERIC", "inspectable", "watersource", "molebait", "_stackable", "frozen", "freshen_ice", "repairer", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ice")	
			inst.AnimState:SetBuild("ice")	
			Anim路径 :  "anim/ice.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("repairer")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("watersource")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("bait")	
		inst:AddComponent("stackable")	
		inst:AddComponent("smotherer")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stopfiremelt")	
		inst:ListenForEvent("firemelt")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: spawnprotectionbuff		路径： [string "scripts/prefabs/spawnprotectionbuff.lua"]	
	Tags▼	
	{":", "DECOR", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spawnprotectionbuff")	
			inst.AnimState:SetBuild("spawnprotectionbuff")	
			Anim路径 :  "anim/spawnprotectionbuff.zip"	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: merm_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
提灯			预设: lantern		路径： [string "scripts/prefabs/mininglantern.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "CAVE_fueled", "_equippable", "light"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lantern")	
			inst.AnimState:SetBuild("lantern")	
			Anim路径 :  "anim/lantern.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("equippable")	
		inst:AddComponent("fueled")	
		inst:AddComponent("machine")	
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
MISSING NAME			预设: spawnlight_multiplayer		路径： [string "scripts/prefabs/spawnlight_multiplayer.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK", "spawnlight"}	
 	
	使用的组件▼	
		
------------------------------------------------	
斑鱼			预设: oceanfish_medium_2_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_2")	
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
MISSING NAME			预设: spat_bomb		路径： [string "scripts/prefabs/spat.lua"]	
	Tags▼	
	{":", "projectile", "locomotor"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spat_bomb")	
			inst.AnimState:SetBuild("spat_bomb")	
			Anim路径 :  "anim/spat_bomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("locomotor")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
骨头碎片			预设: boneshard		路径： [string "scripts/prefabs/boneshard.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bone_shards")	
			inst.AnimState:SetBuild("bone_shards")	
			Anim路径 :  "anim/bone_shards.zip"	
 	
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
MISSING NAME			预设: electrichitsparks		路径： [string "scripts/prefabs/sparks.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: moose_nest_fx_hit		路径： [string "scripts/prefabs/moose_nest_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: shadowhand_arm		路径： [string "scripts/prefabs/shadowhand.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("shadow_creatures_ground")	
			Anim路径 :  "anim/shadow_creatures_ground.zip"	
 	
	使用的组件▼	
		inst:AddComponent("stretcher")	
		
------------------------------------------------	
MISSING NAME			预设: burntstickright		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜味鱼			预设: oceanfish_medium_9_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_medium_9")	
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
MISSING NAME			预设: fissure		路径： [string "scripts/prefabs/nightmarefissure.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmare_crack_upper")	
			inst.AnimState:SetBuild("nightmare_crack_upper")	
			Anim路径 :  "anim/nightmare_crack_upper.zip"	
 	
	使用的组件▼	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("childspawner")	
------------------------------------------------	
MISSING NAME			预设: slide_puff		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
鳄梨酱			预设: guacamole		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: orange_leaves_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
食人花			预设: lureplant		路径： [string "scripts/prefabs/lureplant.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "lureplant", "hiding", "idle", "_inventory", "hostile", "_combat", "MEAT_eater", "canlight", "wildfirepriority", "veggie", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("eyeplant_trap")	
			inst.AnimState:SetBuild("eyeplant_trap")	
			Anim路径 :  "anim/eyeplant_trap.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("combat")	
		inst:AddComponent("shelf")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("minionspawner")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("eater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("digester")	
		inst:AddComponent("health")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("minionchange")	
		inst:ListenForEvent("freshspawn")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("hidebait")	
		inst:ListenForEvent("stopfiredamage")	
		inst:ListenForEvent("gotnewitem")	
		inst:ListenForEvent("startfiredamage")	
	SG = 有▼	
------------------------------------------------	
烤胡萝卜			预设: quagmire_carrot_cooked		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的冰淇淋			预设: icecream_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: goosplash1		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜伏特羊肉冻			预设: voltgoatjelly_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: smoke_plant		路径： [string "scripts/prefabs/smoke_plant.lua"]	
	Tags▼	
	{":", "fx", "FROMNUM"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("smoke_plants")	
			Anim路径 :  "anim/smoke_plants.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
损毁的废墟			预设: ruins_rubble_vase		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "clay", "_combat", "healthrepairable", "smashable", "repairable_stone", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_vase")	
			inst.AnimState:SetBuild("ruins_vase")	
			Anim路径 :  "anim/ruins_vase.zip"	
 	
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
MISSING NAME			预设: halloweenpotion_sanity_small_buff		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
木炭			预设: charcoal		路径： [string "scripts/prefabs/charcoal.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "BURNABLE_fuel", "canlight", "edible_BURNT"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("charcoal")	
			inst.AnimState:SetBuild("charcoal")	
			Anim路径 :  "anim/charcoal.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("bait")	
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
饼干屑			预设: crumbs		路径： [string "scripts/prefabs/crumbs.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "crumbs", "_stackable", "canlight", "catfood", "edible_GOODIES", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cookie_crumbs")	
			inst.AnimState:SetBuild("cookie_crumbs")	
			Anim路径 :  "anim/cookie_crumbs.zip"	
 	
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
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: round_puff_fx_sm		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香无花果酿树干			预设: koalefig_trunk_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
遗物			预设: ruins_table		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "_combat", "smashable", "stone", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_table")	
			inst.AnimState:SetBuild("ruins_table")	
			Anim路径 :  "anim/ruins_table.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: butterfly_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flowers")	
			inst.AnimState:SetBuild("flowers")	
			Anim路径 :  "anim/flowers.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_slowregen_dripfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: battlesong_loop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的香蕉冻			预设: bananapop_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
遗物			预设: ruins_bowl		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "clay", "_combat", "smashable", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_bowl")	
			inst.AnimState:SetBuild("ruins_bowl")	
			Anim路径 :  "anim/ruins_bowl.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
遗物			预设: ruins_plate		路径： [string "scripts/prefabs/smashables.lua"]	
	Tags▼	
	{":", "object", "cavedweller", "_health", "inspectable", "cannotheal", "clay", "_combat", "smashable", "noauradamage", "blocker", "cannotmurder"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_plate")	
			inst.AnimState:SetBuild("ruins_plate")	
			Anim路径 :  "anim/ruins_plate.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
甜蔬菜鸡尾酒			预设: vegstinger_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: shadow_teleport_out		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蜂蜜药膏			预设: bandage		路径： [string "scripts/prefabs/bandage.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bandage")	
			inst.AnimState:SetBuild("bandage")	
			Anim路径 :  "anim/bandage.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("healer")	
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
MISSING NAME			预设: icing_splash_fx_full		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
大熔炉猪战士			预设: boarrior		路径： [string "scripts/prefabs/lavaarena_boarrior.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "epic", "fossilizable", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boarrior")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: icebox_crystal_fx		路径： [string "scripts/prefabs/icebox_crystal_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("icebox_crystal")	
			inst.AnimState:SetBuild("ice_box")	
			Anim路径 :  "anim/dynamic/icebox_crystal.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
烤桦栗果			预设: acorn_cooked		路径： [string "scripts/prefabs/acorn.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "edible_SEEDS", "_stackable", "canlight", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("acorn")	
			inst.AnimState:SetBuild("acorn")	
			Anim路径 :  "anim/acorn.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("tradable")	
		inst:AddComponent("perishable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
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
托尼甜面包			预设: wintercooking_panettone		路径： [string "scripts/prefabs/wintersfeastoven.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
壳碎片			预设: slurtle_shellpieces		路径： [string "scripts/prefabs/slurtle_shellpieces.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slurtle_shellpieces")	
			inst.AnimState:SetBuild("slurtle_shellpieces")	
			Anim路径 :  "anim/slurtle_shellpieces.zip"	
 	
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
MISSING NAME			预设: slurper_respawn		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
浮木桨			预设: oar_driftwood		路径： [string "scripts/prefabs/oar.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "allow_action_on_impassable", "waterproofer", "BURNABLE_fuel", "canlight", "_equippable", "edible_WOOD", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oar_driftwood")	
			inst.AnimState:SetBuild("oar_driftwood")	
			Anim路径 :  "anim/oar_driftwood.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("equippable")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("floater")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("oar")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
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
MISSING NAME			预设: slow_steam_fx2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
被堵住的陷洞			预设: cave_entrance_ruins		路径： [string "scripts/prefabs/cave_entrance.lua"]	
	Tags▼	
	{":", "inspectable", "CLASSIFIED", "antlion_sinkhole_blocker", "MINE_workable", "NOCLICK", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_entrance")	
			inst.AnimState:SetBuild("ruins_entrance")	
			Anim路径 :  "anim/ruins_entrance.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("worldmigrator")	
		
	使用的监听▼	
		inst:ListenForEvent("migration_activate_other")	
------------------------------------------------	
锚雕塑			预设: chesspiece_anchor_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
天文护目镜			预设: moonstorm_goggleshat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "goggles", "inspectable", "hat", "moonsparkchargeable", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonstorm_goggleshat")	
			inst.AnimState:SetBuild("hat_moonstorm_goggles")	
			Anim路径 :  "anim/hat_moonstorm_goggles.zip"	
 	
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
MISSING NAME			预设: trinket_1_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
MISSING NAME			预设: slingshotammo_poop_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
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
暗影角斗士			预设: shadowduelist_builder		路径： [string "scripts/prefabs/shadowwaxwell.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
------------------------------------------------	
芝士蛋糕			预设: quagmire_food_069		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
便便弹			预设: slingshotammo_poop		路径： [string "scripts/prefabs/slingshotammo.lua"]	
	Tags▼	
	{":", "_inventoryitem", "slingshotammo", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL", "BURNABLE_fuel", "reloaditem_ammo"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshotammo")	
			inst.AnimState:SetBuild("slingshotammo")	
			Anim路径 :  "anim/slingshotammo.zip"	
 	
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
鱼人堡垒			预设: mermwatchtower		路径： [string "scripts/prefabs/mermwatchtower.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_guard_tower")	
			inst.AnimState:SetBuild("merm_guard_tower")	
			Anim路径 :  "anim/merm_guard_tower.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("worldsettingstimer")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("childspawner")	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
		inst:ListenForEvent("onmermkingdestroyed")	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onmermkingcreated")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("burntup")	
------------------------------------------------	
叽叽喳喳小披肩			预设: carnival_vest_c		路径： [string "scripts/prefabs/carnival_vest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "BURNABLE_fuel", "canlight", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_vest_c")	
			inst.AnimState:SetBuild("carnival_vest_c")	
			Anim路径 :  "anim/carnival_vest_c.zip"	
 	
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
烤红蘑菇			预设: red_cap_cooked		路径： [string "scripts/prefabs/mushrooms.lua"]	
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
MISSING NAME			预设: battlesong_sanityaura_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
独眼巨鹿			预设: alterguardian_laser		路径： [string "scripts/prefabs/alterguardian_laser.lua"]	
	Tags▼	
	{":", "hostile", "_combat", "notarget"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("alterguardian_laser_hit_sparks_fx")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
------------------------------------------------	
MISSING NAME			预设: slingshotammo_freeze_proj		路径： [string "scripts/prefabs/slingshotammo.lua"]	
	Tags▼	
	{":", "projectile", "extinguisher", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("slingshotammo")	
			inst.AnimState:SetBuild("slingshotammo")	
			Anim路径 :  "anim/slingshotammo.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		inst:AddComponent("weapon")	
		
------------------------------------------------	
辣龙椒沙拉			预设: dragonchilisalad		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "edible_VEGGIE", "badfood", "canlight", "preparedfood", "fresh"}	
 	
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
辣怪物鞑靼			预设: monstertartare_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: sleepcloud_overlay		路径： [string "scripts/prefabs/sleepcloud.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sleepcloud")	
			inst.AnimState:SetBuild("sleepcloud")	
			Anim路径 :  "anim/sleepcloud.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
睡袋			预设: sleepbomb		路径： [string "scripts/prefabs/sleepbomb.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "projectile", "_stackable", "locomotor", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sleepbomb")	
			inst.AnimState:SetBuild("sleepbomb")	
			Anim路径 :  "anim/sleepbomb.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("reticule")	
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
可疑的土堆			预设: dirtpile		路径： [string "scripts/prefabs/dirtpile.lua"]	
	Tags▼	
	{":", "inspectable", "dirtpile", "inactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("track")	
			inst.AnimState:SetBuild("koalefant_tracks")	
			Anim路径 :  "anim/koalefant_tracks.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("activatable")	
		
------------------------------------------------	
月光玻璃			预设: grotto_waterfall_small1		路径： [string "scripts/prefabs/grotto_waterfall_small.lua"]	
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
咸的无花果酿树干			预设: koalefig_trunk_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
活木头			预设: livinglog		路径： [string "scripts/prefabs/livinglog.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "health_wood", "BURNABLE_fuel", "canlight", "repairer", "edible_WOOD"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("livinglog")	
			inst.AnimState:SetBuild("livinglog")	
			Anim路径 :  "anim/livinglog.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
		inst:AddComponent("fuel")	
		inst:AddComponent("repairer")	
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
铁匠的刀刃			预设: lavaarena_heavyblade		路径： [string "scripts/prefabs/lavaarena_heavyblade.lua"]	
	Tags▼	
	{":", "rechargeable", "sharp", "parryweapon", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
MISSING NAME			预设: crow_carnival_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
有疙瘩的树苗			预设: lumpy_sapling		路径： [string "scripts/prefabs/planted_tree.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "DIG_workable", "evergreen_sparse", "canlight"}	
 	
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
MISSING NAME			预设: wall_moonrock_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_moonrock")	
			Anim路径 :  "anim/wall.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
藤壶皮塔饼			预设: barnaclepita		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: hotcold_fx		路径： [string "scripts/prefabs/smallghost.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("trinket_echoes_fx")	
			Anim路径 :  "anim/trinket_echoes_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
棋盘地板			预设: turf_checkerfloor		路径： [string "scripts/prefabs/turfs.lua"]	
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
桦栗果精			预设: birchnutdrake		路径： [string "scripts/prefabs/birchnutdrake.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "birchnutdrake", "freezable", "noattack", "_combat", "locomotor", "scarytoprey", "nolight", "sleeper", "beaverchewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("treedrake_build")	
			Anim路径 :  "anim/treedrake.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("freezable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
熔炉装饰			预设: winter_ornament_festivalevents3		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
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
清凉夏装			预设: reflectivevest		路径： [string "scripts/prefabs/reflectivevest.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("torso_reflective")	
			Anim路径 :  "anim/torso_reflective.zip"	
 	
	使用的组件▼	
		inst:AddComponent("fueled")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("waterproofer")	
		inst:AddComponent("insulator")	
		inst:AddComponent("equippable")	
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
MISSING NAME			预设: archive_pillar		路径： [string "scripts/prefabs/archive_pillar.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_archive")	
			inst.AnimState:SetBuild("pillar_archive")	
			Anim路径 :  "anim/pillar_archive.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜酿鱼头			预设: barnaclestuffedfishhead_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣酿鱼头			预设: barnaclestuffedfishhead_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
惠灵顿牛排			预设: quagmire_food_064		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: goosplash2		路径： [string "scripts/prefabs/goosplash.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: mast_item_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("boat_mast2_wip")	
			Anim路径 :  "anim/boat_mast2_wip.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
远古方尖碑			预设: atrium_overgrowth		路径： [string "scripts/prefabs/atrium_overgrowth.lua"]	
	Tags▼	
	{":", "inspectable", "sanityaura", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_overgrowth")	
			inst.AnimState:SetBuild("atrium_overgrowth")	
			Anim路径 :  "anim/atrium_overgrowth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("sanityaura")	
		
------------------------------------------------	
蜜蜂			预设: bee		路径： [string "scripts/prefabs/bee.lua"]	
	Tags▼	
	{":", "_inventoryitem", "_health", "inspectable", "freezable", "bee", "idle", "insect", "small_livestock", "pollinator", "smallcreature", "_stackable", "_combat", "locomotor", "NET_workable", "OMNI_eater", "nolight", "worker", "flying", "show_spoilage", "cattoyairborne", "ignorewalkableplatformdrowning", "sleeper", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee")	
			inst.AnimState:SetBuild("bee_build")	
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
		inst:AddComponent("knownlocations")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("eater")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("tradable")	
		inst:AddComponent("pollinator")	
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
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: sinkhole_warn_fx_2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: cane_ancient_fx3		路径： [string "scripts/prefabs/cane_ancient_fx.lua"]	
	Tags▼	
	{":", "fx", "shadowtrail"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("randdirty")	
------------------------------------------------	
MISSING NAME			预设: reticulearcping		路径： [string "scripts/prefabs/reticulearc.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("reticulearc")	
			inst.AnimState:SetBuild("reticulearc")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
日出旋转亮片			预设: oceanfishinglure_spinner_red		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
坦克龟			预设: turtillus		路径： [string "scripts/prefabs/lavaarena_turtillus.lua"]	
	Tags▼	
	{":", "monster", "hostile", "LA_mob", "fossilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("turtillus")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
巨型石榴			预设: pomegranate_oversized_waxed		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "canlight", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_pomegranate_build")	
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
时髦的护目镜			预设: goggleshat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "open_top_hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goggleshat")	
			inst.AnimState:SetBuild("hat_goggles")	
			Anim路径 :  "anim/hat_goggles.zip"	
 	
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
柱子			预设: quagmire_altar_bollard		路径： [string "scripts/prefabs/quagmire_altar_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
治疗药膏			预设: healingsalve		路径： [string "scripts/prefabs/healingsalve.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_gland_salve")	
			inst.AnimState:SetBuild("spider_gland_salve")	
			Anim路径 :  "anim/spider_gland_salve.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("healer")	
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
MISSING NAME			预设: lavaarena_crowdstand		路径： [string "scripts/prefabs/lavaarena_crowdstand.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sanity_raise		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
黑羽浮标			预设: oceanfishingbobber_crow_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_bobber_ball")	
			inst.AnimState:SetBuild("oceanfishingbobber_crow_build")	
			Anim路径 :  "anim/oceanfishing_bobber_ball.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
蒜香加州卷			预设: californiaroll_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
威尔逊			预设: wilson		路径： [string "scripts/prefabs/player_common.lua"]	
	Tags▼	
	{":", "mast_upgradeuser", "_sheltered", "trader", "_health", "inspectable", "freezable", "player", "idle", "_builder", "_sanity", "bearded", "_inventory", "_combat", "locomotor", "_moisture", "OMNI_eater", "scarytoprey", "nolight", "debuffable", "usesvegetarianequipment", "_hunger", "_rider", "singingshelltrigger", "character", "lightningtarget", "waterplant_upgradeuser"}	
 	
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
MISSING NAME			预设: livingtree_root_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("livingtree_root")	
			inst.AnimState:SetBuild("livingtree_root")	
			Anim路径 :  "anim/livingtree_root.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
魔光护符			预设: yellowamulet		路径： [string "scripts/prefabs/amulet.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "NIGHTMARE_fueled", "_equippable"}	
 	
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
MISSING NAME			预设: mindcontroller		路径： [string "scripts/prefabs/mindcontroller.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
冬季圣诞树			预设: winter_deciduoustree		路径： [string "scripts/prefabs/winter_tree.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "event_trigger", "canlight", "decoratable", "structure", "winter_tree", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("tree_leaf_trunk_build")	
			Anim路径 :  "anim/wintertree_deciduous.zip"	
 	
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
		inst:ListenForEvent("burntup")	
		inst:ListenForEvent("onextinguish")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("itemlose")	
------------------------------------------------	
石化之书			预设: book_fossil		路径： [string "scripts/prefabs/books_lavaarena.lua"]	
	Tags▼	
	{":", "book", "rechargeable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("book_fossil")	
			inst.AnimState:SetBuild("book_fossil")	
			Anim路径 :  "anim/book_fossil.zip"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
采摘的绿蘑菇			预设: green_cap		路径： [string "scripts/prefabs/mushrooms.lua"]	
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
MISSING NAME			预设: character_fire		路径： [string "scripts/prefabs/character_fire.lua"]	
	Tags▼	
	{":", "fx", "HASHEATER"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fire_large_character")	
			inst.AnimState:SetBuild("fire_large_character")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("heater")	
		inst:AddComponent("firefx")	
		
------------------------------------------------	
装错的玩具眼镜蛇			预设: lost_toy_42		路径： [string "scripts/prefabs/lost_toys.lua"]	
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
烤箱			预设: quagmire_oven_item		路径： [string "scripts/prefabs/quagmire_oven.lua"]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_oven")	
			inst.AnimState:SetBuild("quagmire_oven")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
独眼巨鹿			预设: deerclops		路径： [string "scripts/prefabs/deerclops.lua"]	
	Tags▼	
	{":", "monster", "_health", "inspectable", "freezable", "idle", "deerclops", "hostile", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "nolight", "largecreature", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("deerclops")	
			inst.AnimState:SetBuild("deerclops_build")	
			Anim路径 :  "anim/deerclops_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("freezable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("propagator")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onhitother")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("working")	
	SG = 有▼	
------------------------------------------------	
桅杆套装			预设: mast_item		路径： [string "scripts/prefabs/mast.lua"]	
	Tags▼	
	{":", "_inventoryitem", "boat_accessory", "deploykititem", "inspectable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("seafarer_mast")	
			inst.AnimState:SetBuild("seafarer_mast")	
			Anim路径 :  "anim/seafarer_mast.zip"	
 	
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
蒜香什锦干果			预设: trailmix_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: houndwarning_lvl4		路径： [string "scripts/prefabs/houndwarning.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
熔化吹箭			预设: blowdart_lava2		路径： [string "scripts/prefabs/blowdart_lava2.lua"]	
	Tags▼	
	{":", "blowdart", "rechargeable", "sharp", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("blowdart_lava2")	
			inst.AnimState:SetBuild("blowdart_lava2")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		inst:AddComponent("aoetargeting")	
		
------------------------------------------------	
猫帽			预设: catcoonhat		路径： [string "scripts/prefabs/hats.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "hat", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("catcoonhat")	
			inst.AnimState:SetBuild("hat_catcoon")	
			Anim路径 :  "anim/hat_catcoon.zip"	
 	
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
远古守护者			预设: minotaur		路径： [string "scripts/prefabs/minotaur.lua"]	
	Tags▼	
	{":", "cavedweller", "monster", "_health", "inspectable", "freezable", "idle", "hostile", "_combat", "locomotor", "minotaur", "epic", "nolight", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rook")	
			inst.AnimState:SetBuild("rook_rhino")	
			Anim路径 :  "anim/rook.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("maprevealable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("freezable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
喷射蜘蛛			预设: spider_spitter		路径： [string "scripts/prefabs/spider.lua"]	
	Tags▼	
	{":", "_inventoryitem", "cavedweller", "monster", "trader", "_health", "inspectable", "freezable", "drop_inventory_onpickup", "idle", "small_livestock", "_inventory", "hostile", "strongstomach", "smallcreature", "HORRIBLE_eater", "_combat", "MEAT_eater", "canbetrapped", "locomotor", "sanityaura", "scarytoprey", "nolight", "_follower", "halloweenmoonmutable", "show_spoilage", "drop_inventory_onmurder", "spider_spitter", "sleeper", "eatsrawmeat", "spider", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("spider_spitter")	
			inst.AnimState:SetBuild("DS_spider2_caves")	
			Anim路径 :  "anim/ds_spider2_caves.zip"	
 	
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
巨型腐烂茄子			预设: eggplant_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_potato")	
			inst.AnimState:SetBuild("farm_plant_eggplant_build")	
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
MISSING NAME			预设: weregoose_feathers1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
黑色主教			预设: trinket_16		路径： [string "scripts/prefabs/trinkets.lua"]	
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
MISSING NAME			预设: year_of_the_carrat_event_global		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_retaliation_dripfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: dragonflyfurnace_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("dragonfly_furnace")	
			inst.AnimState:SetBuild("dragonfly_furnace")	
			Anim路径 :  "anim/dragonfly_furnace.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
铥矿墙			预设: wall_ruins		路径： [string "scripts/prefabs/walls.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "HAMMER_workable", "_combat", "healthrepairable", "ruins", "repairable_thulecite", "stone", "wall", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wall")	
			inst.AnimState:SetBuild("wall_ruins")	
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
MISSING NAME			预设: cane_harlequin_fx		路径： [string "scripts/prefabs/cane_harlequin_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
小孔雀鱼			预设: oceanfish_small_1_inv		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "murderable", "weighable_fish", "inspectable", "oceanfish", "smallcreature", "fish", "smalloceancreature", "cookable", "catfood", "fresh"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_1")	
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
巨型腐烂南瓜			预设: pumpkin_oversized_rotten		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "farm_plant_killjoy", "HAMMER_workable", "canlight", "pickable_harvest_str", "pickable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_plant_pumpkin")	
			inst.AnimState:SetBuild("farm_plant_pumpkin")	
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
土豆			预设: quagmire_potato		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
甜藤壶中细面			预设: barnaclinguine_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: bishop_charge		路径： [string "scripts/prefabs/bishop_charge.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bishop_attack")	
			inst.AnimState:SetBuild("bishop_attack")	
			Anim路径 :  "anim/bishop_attack.zip"	
 	
	使用的组件▼	
		inst:AddComponent("projectile")	
		
------------------------------------------------	
MISSING NAME			预设: wortox_portal_jumpout_fx		路径： [string "scripts/prefabs/wortox_portal_fx.lua"]	
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
蝴蝶松饼			预设: butterflymuffin		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
辣奶油土豆泥			预设: mashedpotatoes_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
乐观实验			预设: halloween_experiment_health		路径： [string "scripts/prefabs/madscience_lab.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的蘑菇蛋糕			预设: shroomcake_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: cracklehitfx		路径： [string "scripts/prefabs/hammer_mjolnir.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_hammer_attack_fx")	
			inst.AnimState:SetBuild("lavaarena_hammer_attack_fx")	
			Anim路径 :  "anim/lavaarena_hammer_attack_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
带孔月岩			预设: moonrockcrater		路径： [string "scripts/prefabs/moonrockcrater.lua"]	
	Tags▼	
	{":", "_inventoryitem", "gemsocket", "trader", "inspectable", "give_dolongaction", "repairer", "health_moonrock", "work_moonrock"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mooneyes")	
			inst.AnimState:SetBuild("mooneyes")	
			Anim路径 :  "anim/mooneyes.zip"	
 	
	使用的组件▼	
		inst:AddComponent("trader")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("repairer")	
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
追蛋			预设: carnivalgame_herding_chick		路径： [string "scripts/prefabs/carnivalgame_herding.lua"]	
	Tags▼	
	{":", "inspectable", "idle"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnivalgame_herding_chick")	
			inst.AnimState:SetBuild("carnivalgame_herding_chick")	
			Anim路径 :  "anim/carnivalgame_herding_chick.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("knownlocations")	
		
	SG = 有▼	
------------------------------------------------	
月光玻璃			预设: grotto_moonglass_4		路径： [string "scripts/prefabs/grotto_pool_moonglass.lua"]	
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
木栅栏			预设: fence		路径： [string "scripts/prefabs/fence.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "cannotheal", "HAMMER_workable", "_combat", "alignwall", "canlight", "wall", "SnowCovered", "noauradamage", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fence")	
			inst.AnimState:SetBuild("fence")	
			Anim路径 :  "anim/fence.zip"	
 	
	使用的组件▼	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: dug_berrybush_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("berrybush")	
			inst.AnimState:SetBuild("berrybush")	
			Anim路径 :  "anim/berrybush.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: green_leaves_chop		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
天体英雄			预设: alterguardian_phase3		路径： [string "scripts/prefabs/alterguardian_phase3.lua"]	
	Tags▼	
	{":", "mech", "monster", "_health", "inspectable", "FROMNUM", "freezable", "idle", "hostile", "noepicmusic", "_combat", "locomotor", "brightmareboss", "sanityaura", "epic", "scarytoprey", "flying", "soulless", "largecreature"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("alterguardian_phase3")	
			inst.AnimState:SetBuild("alterguardian_phase3")	
			Anim路径 :  "anim/alterguardian_phase3.zip"	
 	
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
	SG = 有▼	
------------------------------------------------	
鱼钩			预设: oceanfishingbobber_none_projectile		路径： [string "scripts/prefabs/oceanfishingbobber.lua"]	
	Tags▼	
	{":", "projectile", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("oceanfishing_hook")	
			inst.AnimState:SetBuild("oceanfishing_hook")	
			Anim路径 :  "anim/oceanfishing_hook.zip"	
 	
	使用的组件▼	
		inst:AddComponent("oceanfishable")	
		inst:AddComponent("complexprojectile")	
		
------------------------------------------------	
MISSING NAME			预设: gestalt_trail		路径： [string "scripts/prefabs/gestalt.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("brightmare_gestalt_trail")	
			inst.AnimState:SetBuild("brightmare_gestalt_trail")	
			Anim路径 :  "anim/brightmare_gestalt_trail.zip"	
 	
	使用的组件▼	
		inst:AddComponent("transparentonsanity")	
		
------------------------------------------------	
蒜香蓬松土豆蛋奶酥			预设: potatosouffle_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
炽热太阳鱼			预设: oceanfish_small_8		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "MEAT_eater", "locomotor", "herd_oceanfish_small_8", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_8")	
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
小猪包			预设: piggyback		路径： [string "scripts/prefabs/piggyback.lua"]	
	Tags▼	
	{":", "_inventoryitem", "backpack", "inspectable", "_container", "waterproofer", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("piggyback")	
			inst.AnimState:SetBuild("swap_piggyback")	
			Anim路径 :  "anim/piggyback.zip"	
 	
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
MISSING NAME			预设: moonglass_stalactite1		路径： [string "scripts/prefabs/moonglass_stalactites.lua"]	
	Tags▼	
	{":", "NOBLOCK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("moonglass_bigwaterfall")	
			inst.AnimState:SetBuild("moonglass_bigwaterfall")	
			Anim路径 :  "anim/moonglass_bigwaterfall.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
孢子帽			预设: mushroomsprout		路径： [string "scripts/prefabs/mushroomsprout.lua"]	
	Tags▼	
	{":", "cavedweller", "inspectable", "tree", "CHOP_workable", "canlight", "mushroomsprout", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("mushroomsprout")	
			inst.AnimState:SetBuild("mushroomsprout_upg_build")	
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
珍视的抽线陀螺			预设: lost_toy_7		路径： [string "scripts/prefabs/lost_toys.lua"]	
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
MISSING NAME			预设: weregoose_ripple1		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
岩浆虫尖牙			预设: lavae_tooth		路径： [string "scripts/prefabs/lavae_tooth.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavae_egg_tooth")	
			inst.AnimState:SetBuild("lavae_egg_tooth")	
			Anim路径 :  "anim/lavae_egg_tooth.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("petleash")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("leader")	
		inst:AddComponent("floater")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: rhinodrill_fossilized_break_fx_left		路径： [string "scripts/prefabs/lavaarena_rhinodrill.lua"]	
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
MISSING NAME			预设: ghostlyelixir_attack_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
咸的太妃糖			预设: taffy_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: campfirefire		路径： [string "scripts/prefabs/campfirefire.lua"]	
	Tags▼	
	{":", "fx", "HASHEATER"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("campfire_fire")	
			inst.AnimState:SetBuild("campfire_fire")	
			Anim路径 :  "anim/campfire_fire.zip"	
 	
	使用的组件▼	
		inst:AddComponent("firefx")	
		inst:AddComponent("heater")	
		
------------------------------------------------	
MISSING NAME			预设: year_of_the_varg_event_backend		路径： [string "scripts/prefabs/event_deps.lua"]	
	Tags▼	
	{":"}	
 	
	使用的组件▼	
		
------------------------------------------------	
锤子			预设: hammer		路径： [string "scripts/prefabs/hammer.lua"]	
	Tags▼	
	{":", "_inventoryitem", "HAMMER_tool", "inspectable", "tool", "hammer", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hammer")	
			inst.AnimState:SetBuild("swap_hammer")	
			Anim路径 :  "anim/hammer.zip"	
 	
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
恐怖国王饼			预设: nightmarepie		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "masterfood", "unsafefood", "edible_VEGGIE", "canlight", "preparedfood", "fresh"}	
 	
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
一包谢意			预设: hermit_bundle		路径： [string "scripts/prefabs/bundle.lua"]	
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
MISSING NAME			预设: alterguardian_phase1fallfx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
帐篷卷			预设: portabletent		路径： [string "scripts/prefabs/portabletent.lua"]	
	Tags▼	
	{":", "portabletent", "inspectable", "tent", "HAMMER_workable", "canlight", "structure", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tent_walter")	
			inst.AnimState:SetBuild("tent_walter")	
			Anim路径 :  "anim/tent_walter.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("finiteuses")	
		inst:AddComponent("portablestructure")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("propagator")	
		inst:AddComponent("sleepingbag")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		
------------------------------------------------	
一堆气球			预设: balloons_empty		路径： [string "scripts/prefabs/balloons_empty.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("balloons_empty")	
			inst.AnimState:SetBuild("balloons_empty")	
			Anim路径 :  "anim/balloons_empty.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("balloonmaker")	
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
MISSING NAME			预设: alterguardian_phase3trappst		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
华丽的装饰			预设: winter_ornament_boss_malbatross		路径： [string "scripts/prefabs/winter_ornaments.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "molebait", "_stackable", "winter_ornament", "cattoy"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("winter_ornaments2019")	
			inst.AnimState:SetBuild("winter_ornaments2019")	
			Anim路径 :  "anim/winter_ornaments2019.zip"	
 	
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
MISSING NAME			预设: fishingnetvisualizer		路径： [string "scripts/prefabs/fishingnetvisualizer.lua"]	
	Tags▼	
	{":", "ignorewalkableplatforms", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boat_net")	
			inst.AnimState:SetBuild("boat_net")	
			Anim路径 :  "anim/boat_net.zip"	
 	
	使用的组件▼	
		inst:AddComponent("groundshadowhandler")	
		inst:AddComponent("fishingnetvisualizer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
	SG = 有▼	
------------------------------------------------	
爆米花			预设: corn_cooked		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "canlight", "fresh"}	
 	
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
		inst:AddComponent("burnable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("propagator")	
		inst:AddComponent("stackable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
土豆			预设: potato		路径： [string "scripts/prefabs/veggies.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable", "edible_VEGGIE", "badfood", "canlight", "cookable", "weighable_OVERSIZEDVEGGIES", "fresh"}	
 	
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
MISSING NAME			预设: crab_king_bubble3		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
玻璃城堡			预设: glassblock		路径： [string "scripts/prefabs/glass_spike.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "heavy", "HAMMER_workable", "_equippable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sand_block")	
			inst.AnimState:SetBuild("sand_block")	
			Anim路径 :  "anim/sand_block.zip"	
 	
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
红鞭炮			预设: firecrackers		路径： [string "scripts/prefabs/firecrackers.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "explosive", "_stackable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("firecrackers")	
			inst.AnimState:SetBuild("firecrackers")	
			Anim路径 :  "anim/firecrackers.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("burnable")	
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
完全正常的树苗			预设: livingtree_sapling		路径： [string "scripts/prefabs/livingtree_root_planted.lua"]	
	Tags▼	
	{":", "inspectable", "plant", "DIG_workable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("livingtree_root")	
			inst.AnimState:SetBuild("livingtree_root")	
			Anim路径 :  "anim/livingtree_root.zip"	
 	
	使用的组件▼	
		inst:AddComponent("growable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("burnable")	
		
------------------------------------------------	
猪神龛			预设: pigshrine		路径： [string "scripts/prefabs/pigshrine.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "pigshrine", "prototyper", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pigshrine")	
			inst.AnimState:SetBuild("pigshrine")	
			Anim路径 :  "anim/pigshrine.zip"	
 	
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
		inst:ListenForEvent("ondeconstructstructure")	
------------------------------------------------	
亮片大炮套装			预设: carnivalcannon_sparkle_kit		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "_inventoryitem", "deploykititem", "inspectable", "_stackable", "BURNABLE_fuel", "canlight", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("carnival_cannon")	
			inst.AnimState:SetBuild("carnival_cannon_sparkle")	
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
三文鱼苗			预设: oceanfish_small_4		路径： [string "scripts/prefabs/oceanfish.lua"]	
	Tags▼	
	{":", "ediblefish_meat", "idle", "oceanfishable", "oceanfish", "oceanfishinghookable", "NOBLOCK", "locomotor", "herd_oceanfish_small_4", "OMNI_eater", "ignorewalkableplatforms", "notarget", "NOCLICK", "swimming"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceanfish_small_4")	
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
炖肉			预设: quagmire_food_032		路径： [string "scripts/prefabs/quagmire_foods.lua"]	
	Tags▼	
	{":", "quagmire_replatable", "quagmire_saltable", "quagmire_stewable", "preparedfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: sand_puff_large_front		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
盒状零件			预设: teleportato_box		路径： [string "scripts/prefabs/teleportato_parts.lua"]	
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
胡萝卜鼠雕塑			预设: chesspiece_carrat_builder		路径： [string "scripts/prefabs/chesspieces.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
蒜香海鲜杂烩			预设: moqueca_spice_garlic		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: ghostlyelixir_speed_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
远古雕像			预设: atrium_statue		路径： [string "scripts/prefabs/atrium_statue.lua"]	
	Tags▼	
	{":", "inspectable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("atrium_statue")	
			inst.AnimState:SetBuild("atrium_statue")	
			Anim路径 :  "anim/atrium_statue.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		
------------------------------------------------	
MISSING NAME			预设: ocean_splash_ripple2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
路牌			预设: propsign		路径： [string "scripts/prefabs/propsign.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "nonpotatable", "canlight", "minigameitem", "_equippable", "irreplaceable", "propweapon", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("sign_home")	
			inst.AnimState:SetBuild("sign_elite")	
			Anim路径 :  "anim/sign_home.zip"	
 	
	使用的组件▼	
		inst:AddComponent("equippable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("burnable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("weapon")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("propsmashed")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("knockbackdropped")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: pighouse_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pig_house")	
			inst.AnimState:SetBuild("pig_house")	
			Anim路径 :  "anim/pig_house.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
琥珀美食			预设: dustmeringue		路径： [string "scripts/prefabs/dustmeringue.lua"]	
	Tags▼	
	{":", "_inventoryitem", "dustmothfood", "inspectable", "molebait", "_stackable", "edible_ELEMENTAL"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("cook_pot_food")	
			inst.AnimState:SetBuild("cook_pot_food6")	
			Anim路径 :  "anim/cook_pot_food.zip"	
 	
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
		inst:ListenForEvent("oneaten")	
		inst:ListenForEvent("onputininventory")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("on_no_longer_landed")	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("landeddirty")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("onstolen")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: burntfencepostright		路径： [string "scripts/prefabs/farm_decor.lua"]	
	Tags▼	
	{":", "DECOR"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("farm_decor")	
			inst.AnimState:SetBuild("farm_decor")	
			Anim路径 :  "anim/farm_decor.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
守护者之角			预设: minotaurhorn		路径： [string "scripts/prefabs/minotaurhorn.lua"]	
	Tags▼	
	{":", "_inventoryitem", "edible_MEAT", "inspectable", "badfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("horn_rhino")	
			inst.AnimState:SetBuild("horn_rhino")	
			Anim路径 :  "anim/horn_rhino.zip"	
 	
	使用的组件▼	
		inst:AddComponent("edible")	
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
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("entitysleep")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("on_no_longer_landed")	
------------------------------------------------	
MISSING NAME			预设: lucy_transform_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
皇家手工套装			预设: mermthrone_construction		路径： [string "scripts/prefabs/mermthrone.lua"]	
	Tags▼	
	{":", "inspectable", "_constructionsite", "HAMMER_workable", "canlight", "constructionsite", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("merm_king_carpet_construction")	
			inst.AnimState:SetBuild("merm_king_carpet_construction")	
			Anim路径 :  "anim/merm_king_carpet_construction.zip"	
 	
	使用的组件▼	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("constructionsite")	
		inst:AddComponent("propagator")	
		inst:AddComponent("workable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
------------------------------------------------	
辣藤壶皮塔饼			预设: barnaclepita_spice_chili		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
骷髅			预设: skeleton		路径： [string "scripts/prefabs/skeleton.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("skeleton")	
			inst.AnimState:SetBuild("skeletons")	
			Anim路径 :  "anim/skeletons.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		
------------------------------------------------	
MISSING NAME			预设: poopcloud		路径： [string "scripts/prefabs/poopcloud.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: succulent_potted_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("succulent_potted")	
			inst.AnimState:SetBuild("succulent_potted")	
			Anim路径 :  "anim/succulent_potted.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: halloweenpotion_embers_buff		路径： [string "scripts/prefabs/halloweenpotion_embers.lua"]	
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
黄金鹤嘴锄			预设: goldenpickaxe		路径： [string "scripts/prefabs/pickaxe.lua"]	
	Tags▼	
	{":", "_inventoryitem", "MINE_tool", "inspectable", "tool", "sharp", "_equippable", "weapon"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("goldenpickaxe")	
			inst.AnimState:SetBuild("goldenpickaxe")	
			Anim路径 :  "anim/goldenpickaxe.zip"	
 	
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
MISSING NAME			预设: bile_splash		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
独眼巨鹿			预设: deerclops_laserempty		路径： [string "scripts/prefabs/deerclops_laser.lua"]	
	Tags▼	
	{":", "hostile", "_combat", "notarget"}	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
------------------------------------------------	
太妃糖			预设: taffy		路径： [string "scripts/prefabs/preparedfoods.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "honeyed", "_stackable", "badfood", "canlight", "preparedfood", "edible_GOODIES", "fresh"}	
 	
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
MISSING NAME			预设: yotb_confetti		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
饕餮祭坛			预设: quagmire_altar		路径： [string "scripts/prefabs/quagmire_altar.lua"]	
	Tags▼	
	{":", "quagmire_altar", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_altar")	
			inst.AnimState:SetBuild("quagmire_altar")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("camerafocusdirty")	
------------------------------------------------	
羊奶			预设: quagmire_goatmilk		路径： [string "scripts/prefabs/quagmire_goatmilk.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "catfood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_goatmilk")	
			inst.AnimState:SetBuild("quagmire_goatmilk")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
糖浆			预设: quagmire_syrup		路径： [string "scripts/prefabs/quagmire_syrup.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_syrup")	
			inst.AnimState:SetBuild("quagmire_syrup")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
煮熟的蘑菇			预设: quagmire_mushrooms_cooked		路径： [string "scripts/prefabs/quagmire_mushrooms.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_mushrooms")	
			inst.AnimState:SetBuild("quagmire_mushrooms")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
------------------------------------------------	
烤洋葱			预设: quagmire_onion_cooked		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: wanda_attack_shadowweapon_old_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
甜叶肉糕			预设: leafloaf_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
鸟腿			预设: drumstick		路径： [string "scripts/prefabs/meats.lua"]	
	Tags▼	
	{":", "meat", "_inventoryitem", "edible_MEAT", "inspectable", "drumstick", "rawmeat", "dryable", "_stackable", "badfood", "cookable", "catfood", "lureplant_bait", "fresh"}	
 	
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
甜鱼肉玉米卷			预设: fishtacos_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
巧克力猪			预设: halloweencandy_11		路径： [string "scripts/prefabs/halloweencandy.lua"]	
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
MISSING NAME			预设: lantern_winter_fx_held		路径： [string "scripts/prefabs/lantern_winter_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
友善的稻草人			预设: scarecrow		路径： [string "scripts/prefabs/scarecrow.lua"]	
	Tags▼	
	{":", "inspectable", "wardrobe", "HAMMER_workable", "canlight", "structure", "dressable", "scarecrow", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("scarecrow")	
			inst.AnimState:SetBuild("scarecrow")	
			Anim路径 :  "anim/scarecrow.zip"	
 	
	使用的组件▼	
		inst:AddComponent("workable")	
		inst:AddComponent("playeravatardata")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("wardrobe")	
		inst:AddComponent("propagator")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("skinner")	
		inst:AddComponent("inspectable")	
		
	使用的监听▼	
		inst:ListenForEvent("onbuilt")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("dressedup")	
------------------------------------------------	
MISSING NAME			预设: plant_dug_medium_fx		路径： [string "scripts/prefabs/plant_normal.lua"]	
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
麦斯威尔的蚊子陷阱			预设: beemine_maxwell		路径： [string "scripts/prefabs/beemine.lua"]	
	Tags▼	
	{":", "mine", "inspectable", "HAMMER_workable", "mineactive"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bee_mine_maxwell")	
			inst.AnimState:SetBuild("bee_mine_maxwell")	
			Anim路径 :  "anim/bee_mine_maxwell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("workable")	
		inst:AddComponent("mine")	
		inst:AddComponent("hauntable")	
		
	使用的监听▼	
		inst:ListenForEvent("onpickup")	
		inst:ListenForEvent("onputininventory")	
------------------------------------------------	
鲜果可丽饼			预设: freshfruitcrepes		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
甜藤壶握寿司			预设: barnaclesushi_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: collapse_big		路径： [string "scripts/prefabs/structure_collapse_fx.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: pocketwatch_warpback_fx		路径： [string "scripts/prefabs/staffcastfx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pocketwatch_warp_casting_fx")	
			inst.AnimState:SetBuild("pocketwatch_warp_casting_fx")	
			Anim路径 :  "anim/pocketwatch_warp_casting_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
MISSING NAME			预设: oldager_become_younger_front_fx_mount		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ruinsrelic_vase_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("ruins_vase")	
			inst.AnimState:SetBuild("ruins_vase")	
			Anim路径 :  "anim/ruins_vase.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: lantern_tesla_fx_held		路径： [string "scripts/prefabs/lantern_tesla_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("lantern")	
			Anim路径 :  "anim/dynamic/lantern_tesla.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: tile_outline		路径： [string "scripts/prefabs/gridplacer.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("gridplacer")	
			inst.AnimState:SetBuild("gridplacer")	
			Anim路径 :  "anim/gridplacer.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
雨量计			预设: rainometer		路径： [string "scripts/prefabs/rainometer.lua"]	
	Tags▼	
	{":", "inspectable", "HAMMER_workable", "canlight", "structure", "SnowCovered", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("rain_meter")	
			inst.AnimState:SetBuild("rain_meter")	
			Anim路径 :  "anim/rain_meter.zip"	
 	
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
MISSING NAME			预设: ghostlyelixir_retaliation_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
雨天鱼饵			预设: oceanfishinglure_hermit_rain		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
MISSING NAME			预设: moon_device_break_stage2		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: ghostlyelixir_slowregen_buff		路径： [string "scripts/prefabs/ghostly_elixirs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
甜怪物千层饼			预设: monsterlasagna_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
咸的南瓜饼干			预设: pumpkincookie_spice_salt		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
You cannot spawn multiple worlds!	
                  Failed to spawn	forest	
------------------------------------------------	
MISSING NAME			预设: blowdart_lava_projectile		路径： [string "scripts/prefabs/blowdart_lava.lua"]	
	Tags▼	
	{":", "projectile"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lavaarena_blowdart_attacks")	
			inst.AnimState:SetBuild("lavaarena_blowdart_attacks")	
			Anim路径 :  "anim/lavaarena_blowdart_attacks.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
橙宝石			预设: orangegem		路径： [string "scripts/prefabs/gem.lua"]	
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
MISSING NAME			预设: quagmire_portal_player_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
丝带木甲			预设: lavaarena_armormediumrecharger		路径： [string "scripts/prefabs/armor_lavaarena.lua"]	
	Tags▼	
	{":", "hide_percentage", "wood"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: oceantree_pillar_roots		路径： [string "scripts/prefabs/oceantree_pillar.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("oceantree_pillar_small_build1")	
			Anim路径 :  "anim/oceantree_pillar_small.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
雪天鱼饵			预设: oceanfishinglure_hermit_snow		路径： [string "scripts/prefabs/oceanfishinglure.lua"]	
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
MISSING NAME			预设: minotaurchestspawner		路径： [string "scripts/prefabs/minotaur.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: battlesong_fireresistance_buff		路径： [string "scripts/prefabs/battlesongs.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("debuff")	
		
------------------------------------------------	
MISSING NAME			预设: nightmarefissurefx		路径： [string "scripts/prefabs/nightmarelightfx.lua"]	
	Tags▼	
	{":", "DECOR", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("nightmare_crack_ruins_fx")	
			inst.AnimState:SetBuild("nightmare_crack_ruins_fx")	
			Anim路径 :  "anim/nightmare_crack_ruins_fx.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
懒人护符			预设: orangeamulet		路径： [string "scripts/prefabs/amulet.lua"]	
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
MISSING NAME			预设: eye_charge_hit		路径： [string "scripts/prefabs/eye_charge.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
------------------------------------------------	
番茄			预设: quagmire_tomato		路径： [string "scripts/prefabs/quagmire_plantables.lua"]	
	Tags▼	
	{":", "quagmire_stewable", "cookable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: fast_farmplot_placer		路径： [string "scripts/prefabutil.lua"]	
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
MISSING NAME			预设: icebox_porcelain_fx		路径： [string "scripts/prefabs/icebox_porcelain_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("icebox_porcelain")	
			inst.AnimState:SetBuild("ice_box")	
			Anim路径 :  "anim/dynamic/icebox_porcelain.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
水藻			预设: pond_algae		路径： [string "scripts/prefabs/marsh_plant.lua"]	
	Tags▼	
	{":", "inspectable", "canlight"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("pond_plant_cave")	
			Anim路径 :  "anim/pond_plant_cave.zip"	
 	
	使用的组件▼	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inspectable")	
------------------------------------------------	
战猪			预设: boaron		路径： [string "scripts/prefabs/lavaarena_boaron.lua"]	
	Tags▼	
	{":", "monster", "hostile", "minion", "LA_mob", "fossilizable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("boaron")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
开裂珍珠			预设: hermit_cracked_pearl		路径： [string "scripts/prefabs/hermit_pearl.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "irreplaceable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("hermit_pearl")	
			inst.AnimState:SetBuild("hermit_pearl")	
			Anim路径 :  "anim/hermit_pearl.zip"	
 	
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
MISSING NAME			预设: beetletaur_fossilized_break_fx_left_alt		路径： [string "scripts/prefabs/lavaarena_beetletaur.lua"]	
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
桦栗树			预设: deciduous_root		路径： [string "scripts/prefabs/deciduous_root.lua"]	
	Tags▼	
	{":", "_combat", "notarget", "birchnutroot"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("tree_leaf_spike")	
			inst.AnimState:SetBuild("tree_leaf_spike")	
			Anim路径 :  "anim/tree_leaf_spike.zip"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
	使用的监听▼	
		inst:ListenForEvent("animqueueover")	
		inst:ListenForEvent("givetarget")	
------------------------------------------------	
锡鱼罐			预设: fish_box		路径： [string "scripts/prefabs/fish_box.lua"]	
	Tags▼	
	{":", "inspectable", "_container", "HAMMER_workable", "structure", "SnowCovered"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fish_box")	
			inst.AnimState:SetBuild("fish_box")	
			Anim路径 :  "anim/fish_box.zip"	
 	
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
阿比盖尔之花			预设: lavaarena_abigail_flower		路径： [string "scripts/prefabs/lavaarena_abigail_flower.lu..."]	
	Tags▼	
	{":"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("abigail_flower")	
			inst.AnimState:SetBuild("abigail_flower")	
			Anim路径 :  "anim/abigail_flower.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
枯萎的花			预设: flower_withered		路径： [string "scripts/prefabs/flower_withered.lua"]	
	Tags▼	
	{":", "quickpick", "inspectable", "canlight", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("withered_flowers")	
			inst.AnimState:SetBuild("withered_flowers")	
			Anim路径 :  "anim/withered_flowers.zip"	
 	
	使用的组件▼	
		inst:AddComponent("pickable")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("burnable")	
------------------------------------------------	
MISSING NAME			预设: moonstorm_glass_fx		路径： [string "scripts/prefabs/fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
沃比			预设: wobybig		路径： [string "scripts/prefabs/wobybig.lua"]	
	Tags▼	
	{":", "dogrider_only", "inspectable", "freezable", "companion", "_container", "idle", "fedbyall", "NOBLOCK", "locomotor", "nolight", "_follower", "_hunger", "rideable", "MONSTER_eater", "largecreature", "woby", "animal", "peacefulmount", "sleeper", "handfed", "saddleable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("wobybig")	
			inst.AnimState:SetBuild("woby_big_build")	
			Anim路径 :  "anim/woby_big_basic.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("colourtweener")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("rideable")	
		inst:AddComponent("drownable")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("follower")	
		inst:AddComponent("burnable")	
		inst:AddComponent("eater")	
		inst:AddComponent("freezable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("embarker")	
		inst:AddComponent("hunger")	
		inst:AddComponent("container")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("ridersleep")	
		inst:ListenForEvent("itemget")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("hungerdelta")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("riderchanged")	
		inst:ListenForEvent("itemlose")	
	SG = 有▼	
------------------------------------------------	
MISSING NAME			预设: researchlab_placer		路径： [string "scripts/prefabutil.lua"]	
	Tags▼	
	{":", "placer", "CLASSIFIED", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("researchlab")	
			inst.AnimState:SetBuild("researchlab")	
			Anim路径 :  "anim/researchlab.zip"	
 	
	使用的组件▼	
		inst:AddComponent("placer")	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: gargoyle_werepigdeath_fx		路径： [string "scripts/prefabs/gargoyles.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
------------------------------------------------	
MISSING NAME			预设: healthregenbuff		路径： [string "scripts/prefabs/healthregenbuff.lua"]	
	Tags▼	
	{":", "CLASSIFIED"}	
 	
	使用的组件▼	
		inst:AddComponent("timer")	
		inst:AddComponent("debuff")	
		
	使用的监听▼	
		inst:ListenForEvent("timerdone")	
------------------------------------------------	
海洋残骸			预设: oceanfishableflotsam		路径： [string "scripts/prefabs/oceanfishableflotsam.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "pickable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("flotsam")	
			inst.AnimState:SetBuild("flotsam")	
			Anim路径 :  "anim/flotsam.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("pickable")	
		inst:AddComponent("symbolswapdata")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("inventoryitemmoisture")	
		
	使用的监听▼	
		inst:ListenForEvent("enterlimbo")	
		inst:ListenForEvent("forceperishchange")	
		inst:ListenForEvent("entitywake")	
		inst:ListenForEvent("on_landed")	
		inst:ListenForEvent("stacksizechange")	
		inst:ListenForEvent("exitlimbo")	
		inst:ListenForEvent("percentusedchange")	
		inst:ListenForEvent("onsink")	
		inst:ListenForEvent("rechargechange")	
		inst:ListenForEvent("perishchange")	
		inst:ListenForEvent("entitysleep")	
------------------------------------------------	
MISSING NAME			预设: cane_candy_fx		路径： [string "scripts/prefabs/cane_candy_fx.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
MISSING NAME			预设: peghook_splashfx		路径： [string "scripts/prefabs/lavaarena_peghook.lua"]	
	Tags▼	
	{":", "fx", "NOCLICK"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("FROMNUM")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
果蝇王			预设: lordfruitfly		路径： [string "scripts/prefabs/fruitfly.lua"]	
	Tags▼	
	{":", "busy", "lordfruitfly", "_health", "inspectable", "freezable", "insect", "hostile", "_combat", "small", "locomotor", "sanityaura", "epic", "nolight", "fruitfly", "flying", "ignorewalkableplatformdrowning", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("fruitfly")	
			inst.AnimState:SetBuild("fruitfly_evil")	
			Anim路径 :  "anim/fruitfly.zip"	
 	
	使用的组件▼	
		inst:AddComponent("sleeper")	
		inst:AddComponent("combat")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("burnable")	
		inst:AddComponent("health")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("propagator")	
		inst:AddComponent("leader")	
		inst:AddComponent("hauntable")	
		inst:AddComponent("freezable")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("death")	
	SG = 有▼	
------------------------------------------------	
强心针			预设: lifeinjector		路径： [string "scripts/prefabs/lifeinjector.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "_stackable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("lifepen")	
			inst.AnimState:SetBuild("lifepen")	
			Anim路径 :  "anim/lifepen.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("maxhealer")	
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
MISSING NAME			预设: torchfire_shadow		路径： [string "scripts/prefabs/torchfire_common.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("onremove")	
------------------------------------------------	
瓶装乐观混合剂			预设: halloweenpotion_health_small		路径： [string "scripts/prefabs/halloweenpotion_buffs.lua"]	
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
甜芦笋汤			预设: asparagussoup_spice_sugar		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
MISSING NAME			预设: shadow_bishop_fx		路径： [string "scripts/prefabs/shadowchesspieces.lua"]	
	Tags▼	
	{":", "fx"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("shadow_bishop_fx")	
			inst.AnimState:SetBuild("shadow_bishop_fx")	
			Anim路径 :  "anim/shadow_bishop_fx.zip"	
 	
	使用的组件▼	
		
	使用的监听▼	
		inst:ListenForEvent("animover")	
------------------------------------------------	
能量静电			预设: moonstorm_static		路径： [string "scripts/prefabs/moonstorm_static.lua"]	
	Tags▼	
	{":", "_health", "inspectable", "_combat", "moonstorm_static", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("static_ball_contained")	
			Anim路径 :  "anim/static_ball_contained.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inspectable")	
		inst:AddComponent("combat")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("ms_stormchanged")	
		inst:ListenForEvent("death")	
------------------------------------------------	
MISSING NAME			预设: pillar_ruins		路径： [string "scripts/prefabs/pillar.lua"]	
	Tags▼	
	{":", "blocker"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("pillar_ruins")	
			inst.AnimState:SetBuild("pillar_ruins")	
			Anim路径 :  "anim/pillar_ruins.zip"	
 	
	使用的组件▼	
		
------------------------------------------------	
熊獾			预设: bearger		路径： [string "scripts/prefabs/bearger.lua"]	
	Tags▼	
	{":", "busy", "monster", "_health", "inspectable", "freezable", "bearger", "_inventory", "hostile", "_combat", "locomotor", "sanityaura", "epic", "scarytoprey", "nolight", "largecreature", "BEARGER_eater", "sleeper"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("bearger")	
			inst.AnimState:SetBuild("bearger_build")	
			Anim路径 :  "anim/bearger_actions.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventory")	
		inst:AddComponent("groundpounder")	
		inst:AddComponent("sanityaura")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("shedder")	
		inst:AddComponent("propagator")	
		inst:AddComponent("explosiveresist")	
		inst:AddComponent("thief")	
		inst:AddComponent("locomotor")	
		inst:AddComponent("knownlocations")	
		inst:AddComponent("freezable")	
		inst:AddComponent("burnable")	
		inst:AddComponent("lootdropper")	
		inst:AddComponent("sleeper")	
		inst:AddComponent("timer")	
		inst:AddComponent("combat")	
		inst:AddComponent("eater")	
		inst:AddComponent("health")	
		
	使用的监听▼	
		inst:ListenForEvent("newcombattarget")	
		inst:ListenForEvent("performaction")	
		inst:ListenForEvent("firedamage")	
		inst:ListenForEvent("ms_playerleft")	
		inst:ListenForEvent("onhitother")	
		inst:ListenForEvent("onignite")	
		inst:ListenForEvent("onremove")	
		inst:ListenForEvent("droppedtarget")	
		inst:ListenForEvent("ms_playerjoined")	
		inst:ListenForEvent("player_despawn")	
		inst:ListenForEvent("death")	
		inst:ListenForEvent("killed")	
		inst:ListenForEvent("attacked")	
		inst:ListenForEvent("timerdone")	
		inst:ListenForEvent("onwakeup")	
	SG = 有▼	
------------------------------------------------	
面粉			预设: quagmire_flour		路径： [string "scripts/prefabs/quagmire_flour.lua"]	
	Tags▼	
	{":", "quagmire_stewable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("quagmire_flour")	
			inst.AnimState:SetBuild("quagmire_flour")	
			Anim路径 :  "Anim"	
 	
	使用的组件▼	
		
------------------------------------------------	
蜗壳护甲			预设: armorsnurtleshell		路径： [string "scripts/prefabs/armor_snurtleshell.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "shell", "_equippable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("armor_slurtleshell")	
			inst.AnimState:SetBuild("armor_slurtleshell")	
			Anim路径 :  "anim/armor_slurtleshell.zip"	
 	
	使用的组件▼	
		inst:AddComponent("inventoryitemmoisture")	
		inst:AddComponent("inspectable")	
		inst:AddComponent("inventoryitem")	
		inst:AddComponent("useableitem")	
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
独眼巨鹿			预设: deerclops_laser		路径： [string "scripts/prefabs/deerclops_laser.lua"]	
	Tags▼	
	{":", "hostile", "_combat", "notarget"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("FROMNUM")	
			inst.AnimState:SetBuild("deerclops_laser_hit_sparks_fx")	
			Anim路径 :  "missing!"	
 	
	使用的组件▼	
		inst:AddComponent("combat")	
		
------------------------------------------------	
宝贵的玩具木马			预设: lost_toy_18		路径： [string "scripts/prefabs/lost_toys.lua"]	
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
蔬菜杂烩			预设: ratatouille		路径： [string "scripts/prefabs/preparedfoods.lua"]	
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
荆棘陷阱			预设: trap_bramble		路径： [string "scripts/prefabs/trap_bramble.lua"]	
	Tags▼	
	{":", "_inventoryitem", "inspectable", "trap", "mineactive", "deployable"}	
 	
	AnimState▼	
			inst.AnimState:SetBank("trap_bramble")	
			inst.AnimState:SetBuild("trap_bramble")	
			Anim路径 :  "anim/trap_bramble.zip"	
 	
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
```
