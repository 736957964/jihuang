>   随笔

## TheInput相关
```lua 
Input:DisableAllControllers()
Input:EnableAllControllers()
Input:IsControllerLoggedIn(controller)
Input:LogUserAsync(controller,cb)
Input:LogSecondaryUserAsync(controller,cb)
Input:EnableMouse(enable)
Input:ClearCachedController()
Input:CacheController()
Input:TryRecacheController()
Input:GetControllerID()
Input:ControllerAttached()
Input:ControllerConnected()
Input:AddTextInputHandler(fn)
Input:AddKeyUpHandler(key, fn)
Input:AddKeyDownHandler(key, fn)
Input:AddKeyHandler(fn)
Input:AddMouseButtonHandler(fn)
Input:AddMoveHandler(fn)
Input:AddControlHandler(control, fn)
Input:AddGeneralControlHandler(fn)
Input:AddControlMappingHandler(fn)
Input:AddGestureHandler(gesture, fn)
Input:UpdatePosition(x, y)
Input:OnControl(control, digitalvalue, analogvalue)
Input:OnMouseMove(x, y)
Input:OnMouseButton(button, down, x, y)
Input:OnRawKey(key, down)
Input:OnText(text)
Input:OnGesture(gesture)
Input:OnControlMapped(deviceId, controlId, inputId, hasChanged)
Input:OnFrameStart()
TheInput:GetInputDevices()
TheInput:GetScreenPosition()
TheInput:GetWorldPosition()
TheInput:GetAllEntitiesUnderMouse()
TheInput:GetWorldEntityUnderMouse() --当前鼠标的实体
TheInput:GetHUDEntityUnderMouse()
Input:EnableDebugToggle(enable)
Input:IsDebugToggleEnabled()
Input:IsMouseDown(button)
Input:IsKeyDown(key)
Input:IsControlPressed(control)
Input:GetAnalogControlValue(control)
Input:IsPasteKey(key)
Input:UpdateEntitiesUnderMouse()
Input:OnUpdate()
Input:GetLocalizedControl(deviceId, controlId, use_default_mapping, use_control_mapper)
Input:GetControlIsMouseWheel(controlId)
Input:GetStringIsButtonImage(str)
Input:PlatformUsesVirtualKeyboard()
```
## TheNet
```lua 
local IsServer = TheNet:GetIsServer()
if IsServer and TheShard:GetShardId() ~= "0" then --不是世界0的时候生效
end

```
## Network
```lua 
inst.Network:IsServerAdmin() --判断是否为服务器管理员
```

## TheWorld
```lua 
TheWorld.state.isfullmoon --如果是满月 
TheWorld.ismastersim --区分主客机   让部分代码在客户端不会加载  不加可能会造成 部分会报错 部分会造成主客机数据不同步  使用场景:一般官方写了就写

--玩家说话处理
_G.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote)   end --userid 玩家id message 说的话  whisper 公聊为false 私聊为true
-- print(unpack(TheWorld.worldstatewatching))  print(TheWorld.guard_authorization)
for k,_ in pairs(TheWorld.guard_authorization) do print(k) end

for k,v in pairs(TheWorld.worldstatewatching.elapseddaysinseason) do print(v) end
--------------------
TheWorld打印
  GUID	
  inlimbo	
  Pathfinder	
  worldstatewatching	  table
       : isday	
       : startday	
       : season	
       : elapseddaysinseason	--季节内经过的天数
       : iswinter	--是冬天吗
       : isnight	
       : cycles	
       : isspring	
       : isautumn	
       : remainingdaysinseason	
       : israining

  worldprefab	--forest
  spawnwaveyjones	fn
  watchingcycles --true	
  shard	 --shard_network
  net	--forest_network
  pendingtasks	table --挂起任务
  hideminimap	--false
  state	
       : summerlength	--夏季长度
       : seasonprogress	 --季节进展
       : isnightmaredawn	--是噩梦的开始
       : elapseddaysinseason	--季节内经过的天数
       : isfullmoon	--是满月吗
       : moisture	 --潮湿
       : cavephase	 --洞穴？
       : isnightmarewild	--是噩梦吗
       : moonphase	--月相
       : precipitationrate	--降水率
       : iswet	    --是湿的
       : isnewmoon	 --是新月吗
       : iswinter	 --是冬天吗
       : isnightmarewarn	--是噩梦警告吗
       : wetness	 --下雨
       : springlength	--春天长度
       : issnowcovered	--有积雪吗
       : moistureceil	
       : isday	--是白天吗
       : issnowing	--是下雪吗
       : season	--季节
       : israining	--是下雨吗
       : precipitation	--降水
       : isnightmarecalm--是噩梦吗	
       : timeinphase --时间阶段	
       : cycles	--周期
       : iscavedusk	--是洞穴黄昏吗
       : isautumn	--是秋天吗
       : iscaveday  --是洞穴白天	
       : pop	
       : temperature	--当前世界温度
       : snowlevel	--雪位
       : iswaxingmoon	--是月圆吗
       : autumnlength	--秋季长度
       : phase	--阶段   day  night
       : nightmaretime	--噩梦时间
       : winterlength	--冬天长度
       : isspring	--是春天吗
       : nightmarephase	--噩梦阶段
       : remainingdaysinseason	--季节剩余天数
       : nightmaretimeinphase	--噩梦期
       : iscavenight	--是洞穴的夜晚嘛
       : time	
       : isdusk	--是黄昏吗
       : issummer	--是夏天吗
       : isnight	--是夜晚吗
  name	
  guard_authorization	--会打印一串玩家Id 还有一些不在游戏的..  加上id 可以看到名称
  removewaveyjonestarget	fn --好像是熊锁注册上去的清理
  ismastershard	--是主人卡片？
  multiplayer_portal_pos	
  generated	--TheWorld.generated.densities  打印很多密度..不知道干嘛的
  event_listening	--监听事件
       : clocktick	
       : ms_registerpetrifiable	
       : temperaturetick	
       : entity_death	
       : ms_registerklaussack	
       : wargshrinedeactivated	
       : ms_registerspawnpoint	
       : screenflash	
       : nightmareclocktick	
       : ms_playerdespawnanddelete	
       : hasslerkilled	
       : builditem	
       : townportaldeactivated	
       : sanitymodechanged	
       : snowcoveredchanged	
       : ms_playerdespawnandmigrate	
       : buildstructure	
       : ms_skeletonspawn	
       : cycleschanged	
       : ms_gd_playerleft	
       : unpausehounded	
       : seasontick	
       : beargerremoved	
       : playeractivated	
       : ms_playerspawn	
       : killed	
       : wargshrineactivated	
       : ms_restoreklaussackkey	
       : nightmarephasechanged	
       : ms_unregisterpetrifiable	
       : ms_cyclecomplete	
       : ms_registeroasis	
       : unequipskinneditem	
       : precipitationchanged	
       : ms_gd_playerjoined	
       : inducedinsanity	
       : ms_registerdeerspawningground	
       : ms_playerleft	
       : wetchanged	
       : hasslerremoved	
       : pausehounded	
       : ms_unlockchesspiece	
       : ms_registermigrationportal	
       : overrideambientlighting	
       : death	
       : playerdeactivated	
       : beargerkilled	
       : moonphasechanged2	
       : storehassler	
       : equipskinneditem	
       : ms_setspawnmode	
       : ms_setwildfirechance	
       : changeclothes	
       : moistureceilchanged	
       : continuefrompause	
       : seasonlengthschanged	
       : phasechanged	
       : ms_playerjoined	
       : ms_enableresourcerenewal	
       : onremove	
       : ms_playerdespawn	
       : weathertick	
       : ms_enableskeletonsweeper	
       : ms_setpenguinnumboulders	
       : townportalactivated	
       : ms_registertownportal	
       : beginregrowth	
       : ms_lightwildfireforplayer	
  checkwaveyjonestarget	

  -- print(unpack(TheWorld.worldstatewatching))  print(TheWorld.event_listening)
for k,_ in pairs(TheWorld.event_listening) do print(k) end

for k,v in pairs(TheWorld.guard_authorization.OU_76561197960975131) do print(v) end
  minimap	
  OnRemoveEntity	
  lower_components_shadow	
  spawntime	
  Transform	
  entity	
  reservewaveyjonestarget	
  prefab	
  updatecomponents	
  Map	
  OnSave	
  PostInit	
  persists	
  meta	
  event_listeners	
  SoundEmitter	
  has_ocean	
  OnLoad	
  ismastersim	
  GroundCreep	
  WaveComponent	
  replica	
  topology	
  components	
  actioncomponents	
--------------------
```


## TUNING
```lua 
-----------砍树需要的次数
--砍树
TUNING.EVERGREEN_CHOPS_SMALL = 1            --小常青树
TUNING.EVERGREEN_CHOPS_NORMAL = 1           --正常常青树
TUNING.EVERGREEN_CHOPS_TALL = 1             --高常青树

TUNING.DECIDUOUS_CHOPS_SMALL = 1            --小橡果树
TUNING.DECIDUOUS_CHOPS_NORMAL = 1           --正常橡果树
TUNING.DECIDUOUS_CHOPS_TALL = 1             --高橡果树
TUNING.DECIDUOUS_CHOPS_MONSTER = 1          --橡果树精

TUNING.MUSHTREE_CHOPS_SMALL = 1             --小蘑菇树
TUNING.MUSHTREE_CHOPS_MEDIUM = 1            --中蘑菇树
TUNING.MUSHTREE_CHOPS_TALL = 1              --高蘑菇树

TUNING.TOADSTOOL_MUSHROOMSPROUT_CHOPS = 1   --毒蕈蘑菇芽树
TUNING.TOADSTOOL_DARK_MUSHROOMSPROUT_CHOPS = 1  --毒蕈黑蘑菇芽树

TUNING.DRIFTWOOD_TREE_CHOPS = 1             --浮木桩树
TUNING.DRIFTWOOD_SMALL_CHOPS = 1            --小浮木桩树

TUNING.MOON_TREE_CHOPS_SMALL = 1            --小月亮树
TUNING.MOON_TREE_CHOPS_NORMAL = 1           --正常月亮树
TUNING.MOON_TREE_CHOPS_TALL = 1             --高月亮树
-----------砍树需要的次数

-----------挖矿需要的次数
TUNING.MARBLESHRUB_MINE_SMALL = 1           --小大理石灌木
TUNING.MARBLESHRUB_MINE_NORMAL = 1          --正常大理石灌木
TUNING.MARBLESHRUB_MINE_TALL = 1            --高大理石灌木

TUNING.ICE_MINE = 1                         --冰矿
TUNING.ROCKS_MINE = 1                       --正常石矿
TUNING.ROCKS_MINE_MED = 1                   --中等石矿
TUNING.ROCKS_MINE_LOW = 1                   --低矮石矿
  
TUNING.MARBLEPILLAR_MINE = 1                --大理石柱子
TUNING.MARBLETREE_MINE = 1                  --大理石树
TUNING.CAVEIN_BOULDER_MINE = 1              --洞穴落石
TUNING.SEASTACK_MINE = 1                    --海上礁石
TUNING.SEACOCOON_MINE = 1                   --海茧
TUNING.SHELL_CLUSTER_MINE = 1               --贝壳

TUNING.GARGOYLE_MINE = 1                    --可疑的大理石雕像
TUNING.GARGOYLE_MINE_LOW = 1                --低矮可疑的大理石雕像

TUNING.ROCK_FRUIT_MINES = 1                 --石果

TUNING.MOONALTAR_ROCKS_MINE = 1             --月亮岛玻璃石矿

TUNING.SPILAGMITE_SPAWNER = 1               --蜘蛛石矿
TUNING.SPILAGMITE_ROCK = 1                  --蜘蛛石矿

TUNING.SALTSTACK.WORK_REQUIRED = 1          --盐石矿

TUNING.SCULPTURE_COVERED_WORK = 1           --补完整的雕塑

TUNING.MOONSPIDERDEN.WORK = 1               --月亮岛蜘蛛巢

TUNING.WOBSTER_DEN.WORK = 1                 --龙虾巢穴(普通和月光通用)
-----------挖矿需要的次数


TUNING.AXE_USES = 100            --斧头
TUNING.HAMMER_USES = 75          --锤     
TUNING.SHOVEL_USES = 25          --铲子
TUNING.PITCHFORK_USES = 25       --草叉
TUNING.PICKAXE_USES = 33         --镐
TUNING.BUGNET_USES = 10          --捕虫网
TUNING.SPEAR_USES = 150          --矛
TUNING.WATHGRITHR_SPEAR_USES = 200 --瓦丝格雷斯矛
TUNING.SPIKE_USES = 100          --狼牙棒
TUNING.FISHINGROD_USES = 9       --鱼杆
TUNING.TRAP_USES = 8             --陷阱
TUNING.BOOMERANG_USES = 10       --回旋镖
TUNING.NIGHTSWORD_USES = 100     --暗影剑
TUNING.ICESTAFF_USES = 20        --冰魔杖
TUNING.FIRESTAFF_USES = 20       --火魔杖
TUNING.TELESTAFF_USES = 5        --传送魔杖
TUNING.YELLOWSTAFF_USES = 20     --黄色魔杖
TUNING.ORANGESTAFF_USES = 20     --橙色魔杖
TUNING.GREENSTAFF_USES = 5       --绿色魔杖
TUNING.TORNADOSTAFF_USES = 1     --龙卷风魔杖
TUNING.HAMBAT_USES = 100         --火腿短棍
TUNING.BATBAT_USES = 75          --蝙蝠棒
TUNING.MULTITOOL_AXE_PICKAXE_USES = 400 --多功能工具斧头和锄头
TUNING.RUINS_BAT_USES = 150      --远古短棒
TUNING.REDAMULET_USES = 20       --红色护身符
TUNING.BLUEAMULET_FUEL = total_day_time * 0.75  --蓝色护身符
TUNING.PURPLEAMULET_FUEL = total_day_time * 0.4 --紫色护身符
TUNING.YELLOWAMULET_FUEL = total_day_time       --黄色护身符
TUNING.ORANGEAMULET_USES = 225                  --橙色护身符
TUNING.GREENAMULET_USES = 5                     --绿色护身符
TUNING.PANFLUTE_USES = 10                       --排箫
TUNING.HORN_USES = 10                           --牛角
TUNING.TRAP_TEETH_USES = 10                     --牙齿陷阱
TUNING.TENT_USES = 6                            --帐篷
TUNING.SIESTA_CANOPY_USES = 6                   --午睡小屋
TUNING.UMBRELLA_USES = 20                       --伞（攻击次数）
TUNING.SEWINGKIT_USES = 5                       --针线包
TUNING.FERTILIZER_USES = 10                     --肥料
TUNING.GLOMMERBELL_USES = 3                     --铃
TUNING.TORCH_FUEL = night_time*1.25             --火炬
TUNING.NIGHTSTICK_FUEL = night_time*6           --夜棍
TUNING.MINERHAT_LIGHTTIME = (night_time+dusk_time)*2.6 --矿工帽
TUNING.LANTERN_LIGHTTIME = (night_time+dusk_time)*2.6  --提灯
TUNING.SPIDERHAT_PERISHTIME = 4*seg_time               --蜘蛛帽
TUNING.ONEMANBAND_PERISHTIME = 6*seg_time              --独奏乐器
TUNING.GRASS_UMBRELLA_PERISHTIME = 2*total_day_time*perish_warp --草伞
--以下修改如上实例，我就不搞了，太累

伞     TUNING.UMBRELLA_PERISHTIME = total_day_time*6,
眼睛帽     TUNING.EYEBRELLA_PERISHTIME = total_day_time*9,
草帽  TUNING.STRAWHAT_PERISHTIME = total_day_time*5,
兔耳罩  TUNING.EARMUFF_PERISHTIME = total_day_time*5,
冬帽  TUNING.WINTERHAT_PERISHTIME = total_day_time*10,
牛毛帽  TUNING.BEEFALOHAT_PERISHTIME = total_day_time*10,
寒冬背心 TUNING.TRUNKVEST_PERISHTIME = total_day_time*15,
反射背心  TUNING.REFLECTIVEVEST_PERISHTIME = total_day_time*8,
夏威夷衬衫  TUNING.HAWAIIANSHIRT_PERISHTIME = total_day_time*15,
小巧背心 TUNING.SWEATERVEST_PERISHTIME = total_day_time*10,
饥饿腰带  TUNING.HUNGERBELT_PERISHTIME = total_day_time*8,
熊背心  TUNING.BEARGERVEST_PERISHTIME = total_day_time*7,
雨衣  TUNING.RAINCOAT_PERISHTIME = total_day_time*10,
海象帽子 TUNING.WALRUSHAT_PERISHTIME = total_day_time*25,
羽毛帽 TUNING.FEATHERHAT_PERISHTIME = total_day_time*8,
高礼帽  TUNING.TOPHAT_PERISHTIME = total_day_time*8,
冰帽  TUNING.ICEHAT_PERISHTIME = total_day_time*4,
鼹鼠帽  TUNING.MOLEHAT_PERISHTIME = total_day_time*1.5,
防雨帽  TUNING.RAINHAT_PERISHTIME = total_day_time*10,
浣熊帽  TUNING.CATCOONHAT_PERISHTIME = total_day_time*10,
羽毛扇     TUNING.FEATHER_FAN_USES = 15,


-----------武器伤害值加大------------------
空手     TUNING.UNARMED_DAMAGE = 10,
暗影剑     TUNING.NIGHTSWORD_DAMAGE = wilson_attack*2,
蝙蝠棒     TUNING.BATBAT_DAMAGE = wilson_attack * 1.25,
枯竭蝙蝠棒     TUNING.BATBAT_DRAIN = wilson_attack * 0.2,
狼牙棒     TUNING.SPIKE_DAMAGE = wilson_attack*1.5,
火腿短棍     TUNING.HAMBAT_DAMAGE = wilson_attack*1.75,
矛     TUNING.SPEAR_DAMAGE = wilson_attack,
瓦丝格雷斯矛     TUNING.WATHGRITHR_SPEAR_DAMAGE = wilson_attack * 1.25,
斧头     TUNING.AXE_DAMAGE = wilson_attack*.8,
镐     TUNING.PICK_DAMAGE = wilson_attack*.8,
回旋镖     TUNING.BOOMERANG_DAMAGE = wilson_attack*.8,
火炬     TUNING.TORCH_DAMAGE = wilson_attack*.5,
锤     TUNING.HAMMER_DAMAGE = wilson_attack*.5,
铲子     TUNING.SHOVEL_DAMAGE = wilson_attack*.5,
草叉     TUNING.PITCHFORK_DAMAGE = wilson_attack*.5,
捕虫网     TUNING.BUGNET_DAMAGE = wilson_attack*.125,
鱼杆     TUNING.FISHINGROD_DAMAGE = wilson_attack*.125,
雨伞     TUNING.UMBRELLA_DAMAGE = wilson_attack*.5,
手杖     TUNING.CANE_DAMAGE = wilson_attack*.5,
多功能工具     TUNING.MULTITOOL_DAMAGE = wilson_attack*.9,
远古短棒     TUNING.RUINS_BAT_DAMAGE = wilson_attack * 1.75,
夜棍     TUNING.NIGHTSTICK_DAMAGE = wilson_attack*.85, 
吹箭     TUNING.PIPE_DART_DAMAGE = 100,
牙齿陷阱     TUNING.TRAP_TEETH_DAMAGE = 60,
火药  TUNING.GUNPOWDER_DAMAGE = 200,
打火机     TUNING.LIGHTER_DAMAGE = wilson_attack*.5,
眼睛炮塔     TUNING.EYETURRET_DAMAGE = 65,
龙卷风     TUNING.TORNADO_DAMAGE = 7,

--盔甲在就不掉血（盔甲100%吸收伤害值）

    1.草盔甲：TUNING.ARMORGRASS_ABSORPTION = 1,

    2.木盔甲：TUNING.ARMORWOOD_ABSORPTION = 1,

    3.大理石盔甲：TUNING.ARMORMARBLE_ABSORPTION = 1,

    4.蜗牛龟盔甲：TUNING.ARMORSNURTLESHELL_ABSORPTION = 1,

    5.远古盔甲：TUNING.ARMORRUINS_ABSORPTION = 1,

    6.饥饿腰带：TUNING.ARMORSLURPER_ABSORPTION = 1,

    7.猪皮帽：TUNING.ARMOR_FOOTBALLHAT_ABSORPTION = 1,

    8.蜻蜓盔甲：TUNING.ARMORDRAGONFLY_ABSORPTION = 1,

    9.瓦丝格雷斯帽：TUNING.ARMOR_WATHGRITHRHAT_ABSORPTION = 1,

    10.远古王冠：TUNING.ARMOR_RUINSHAT_ABSORPTION = 1,

    11.蜗牛帽：TUNING.ARMOR_SLURTLEHAT_ABSORPTION = 1,

    12.蜂帽：TUNING.ARMOR_BEEHAT_ABSORPTION = 1,

    13.夜魔盔甲：TUNING.ARMOR_SANITY_ABSORPTION = 1,

--即可让盔甲100%吸收伤害值

----------提高盔甲耐久力----------

草盔甲     TUNING.ARMORGRASS = wilson_health*1.5,
木盔甲     TUNING.ARMORWOOD = wilson_health*3,
大理石盔甲  TUNING.ARMORMARBLE = wilson_health*7,
蜗牛龟盔甲  TUNING.ARMORSNURTLESHELL = wilson_health*7,
远古盔甲  TUNING.ARMORRUINS = wilson_health * 12,
饥饿腰带  TUNING.ARMORSLURPER = wilson_health * 4,
猪皮帽     TUNING.ARMOR_FOOTBALLHAT = wilson_health*3,
蜻蜓盔甲  TUNING.ARMORDRAGONFLY = wilson_health * 9,
瓦丝格雷斯帽  TUNING.ARMOR_WATHGRITHRHAT = wilson_health * 5,
远古王冠  TUNING.ARMOR_RUINSHAT = wilson_health*8,
蜗牛帽  TUNING.ARMOR_SLURTLEHAT = wilson_health*5,
蜂帽     TUNING.ARMOR_BEEHAT = wilson_health*5,
夜魔盔甲  TUNING.ARMOR_SANITY = wilson_health * 5,
```