>   随笔
## 垃圾堆
```lua 
target:IsValid() --有效目标
target.components.health:IsDead() --死亡
TUNING.MODROOT = MODROOT..'script/gift_info.json' --修改路径 直接调用 TUNING.MODROOT  这是放在了 script/目录下
inst:RegisterComponentActions("aoespell") --重新注册组件  如果组件做了防冲突且涉及到动作 需要重新注册 inst:AddComponent('myth_aoespell') inst.components.aoespell = inst.components.myth_aoespell
----------------------------------------------
MakeInventoryPhysics(inst)									--增加物理性【物品】
RemovePhysicsColliders(inst)								--取消物理性碰撞
inst.Physics:SetActive(false)								--关闭物理碰撞效果
inst._ispathfinding:set(false)								--自动寻路
inst.Physics:SetMass(0)										--自由落体速率   0为不掉落，默认1	质量
inst.Physics:SetSphere(.5)									--物理范围
inst.Physics:SetFriction(.1)								--设置摩擦
inst.Physics:SetDamping(0)									--设置阻尼
inst.Physics:SetRestitution(.5)								--设置恢复
inst.Physics:SetCollisionGroup(COLLISION.ITEMS)				--设置碰撞组
inst.Physics:ClearCollisionMask()							--清除冲突面
inst.Physics:CollidesWith(COLLISION.WORLD)					--增加冲突面
inst.Physics:CollidesWith(COLLISION.OBSTACLES)				--增加冲突面
inst.Physics:SetCapsule(rad, 1)								--物理碰撞体积，碰撞高度
inst.Physics:SetCylinder(.6, 2)								--中空类型的物理性
inst.Physics:GetMass()										--获取质量
inst.Physics:GetRadius()									--获取物理碰撞范围
inst.Physics:Teleport(x,y,z)								--物理传送
--------------------------------------------------------------抓取角度
local function onhit(inst, attacker, target)  --attacker 使用者 target是目标。两官方函数
	inst:Remove() --物品删除   inst代表的是当前物品
	SpawnPrefab("collapse_small").Transform:SetPosition(target.Transform:GetWorldPosition()) --生成的特效  爆炸特效
	target.Transform:SetScale(0.7, 0.7, 0.7)--设置大小
	if target.components.health then  -- 如果目标拥有血量组件 则
       target.components.health.currenthealth = 1 --修改目标的当前血量
       target.components.health.maxhealth = 1 --修改目标的最大血量
    end
	if target.components.combat then --如果目标拥有攻击组件 则
       target.components.combat:SetDefaultDamage(0) --修改目标的攻击
       target.components.combat.target = nil --目标的目标为nil  --目标是怪物，怪物的目标是你，为nil，怪物不打人了，丧失攻击行为
    end
	 if target.components.locomotor then --如果目标拥有运动组件
       target.components.locomotor.runspeed = 1 --走的速度(也可以设置全人物速度 具体看文件)
       target.components.locomotor.walkspeed = 1 --跑的速度
    end
end
---------
local minimap = inst.entity:AddMiniMapEntity()---即可在小地图上看到牛的位置，显示为beemine图标
minimap:SetIcon( "beemine.png" )
inst.SoundEmitter:PlaySound("dontstarve/zg/shotgun/fill")--声音播放 音效代码查询 音效代码的记录
inst:RemoveComponent('workable') --移除可被铲的标签
-----客机部分
ThePlayer.replica.inventory:GetActiveItem() -- 获取当前鼠标的物品
-------------------官方杂七杂八的东西-------------------
---按钮图片框---
local button = self:AddChild(ImageButton("images/global_redux.xml", "button_carny_xlong_normal.tex", "button_carny_xlong_hover.tex", "button_carny_xlong_disabled.tex", "button_carny_xlong_down.tex"))
----文件夹 images/global_redux.xml 里头有很多官方自带的按钮图
char_selection --类似徽章的图 较大
--
-------------------------客机代码---------------------------------------------------
local activeitem = ThePlayer.replica.inventory:GetActiveItem() --当前人物鼠标上的预设
ThePlayer.replica.inventory:GetActiveItem().replica.stackable._stacksize:value() + 1 --当前人物的鼠标物品堆叠数量
local inventoryitem_replica = activeitem and activeitem.replica.inventoryitem
inventoryitem_replica:GetAtlas(),inventoryitem_replica:GetImage() --获取xml和tex图像

SendModRPCToServer(GetModRPC("chh_smlh", "smlh_shop")) -- 客户端发送 接收
SendModRPCToServer(MOD_RPC["chh_smlh"]["smlh_shop"],{TransferorUserid,number})

AddModRPCHandler("MOD名称即可", "当前命名空间", function (owner)  end -- 服务端的时候创建
--namespace: 命名空间，一般写mod名字即可，与其它mod的rpc区分开防止冲突 --name: rpc名字，在当前空间下的，发送rpc时会用到
--fn: 当rpc发送时，要做的事，方法第一个参数是player，表示发出rpc的玩家是谁 与之对应的发送方法是 SendModRPCToServer()
AddModRPCHandler(namespace, name, fn) end
```
## sourcemodifierlist  重要的文件
```lua
local SourceModifierList = require("util/sourcemodifierlist")
--第一个参数 可以是字符串也可以是对象，用来合并计算最终的系数 比如health中的防御 就是通过这个计算的
--第二个参数0表示默认设置为1开始算  第三个参数为计算方式 也可以自己定义 不写的话默认为乘法 .multiply 乘法 .additive加法 .boolean 则是  a or b  这里三个算法都是传参都是(a, b)
--比如说战旗 我只想要生效一个 一般情况传入inst是独立的 这时候 如果都传入的字符串 就会被覆盖 从而达到只有一种buff的效果
SourceModifierList(inst, 0, SourceModifierList.additive)
--source当前操作对象(一般情况下传的是要操作的X)  m为当前key要设置的值  key可以不传 默认就是key
--数据格式大致是这样的 self._modifiers.【source】.modifiers.【key】
XXXXXXXX:SetModifier(source, m, key)
XXXXXXXX:RemoveModifier(source, key)--移除 当前source下的key
XXXXXXXX:CalculateModifierFromSource(source, key)--返回的是当前 source下的key值
XXXXXXXX:RecalculateModifier(inst) -- 重新计算程序RecalculateModifier(inst)  最后返回给 _modifier 计算后的总数据
XXXXXXXX:CalculateModifierFromKey(key) --循环 source列表找到key值
---------------------实体相关开始------------------------------------
EntityScript:GetDisplayName() --获取实体的名称
---------血量类的
target.components.health.currenthealth = target.components.health.currenthealth - wugjhj --目标血量 = 当前血量 - 武器攻击 这里有个问题 就是就算扣负 怪物还是会活着 不会执行isDead 所以正常情况下不要操作生命值
target.components.health:DoDelta(wugjhj*-1) -- 设置血量扣除  俩者都能做到扣除目标的血量 DoDelta本身有一些回调 currenthealth 操作不会触发这个回调
---------血量类的
EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
	inst.AnimState:Hide("ARM_carry")
	inst.AnimState:Show("ARM_normal")
end)
--[[ name：Prefab名 ingredients：成分表 tab：物品栏分类  level：科技等级   placer：建筑物放置物，也就是制造建筑时显示的那个图像（实质上也是个Prefab）是否有placer(设置不能被绿杖拆解)
min_spacing：最小间隔
nounlock：是否可以离开制作台制作--远古物品只能在制作台上制作。nil则可以离开制作台
numtogive：制作数量，若填nil则为制作1个。
builder_tag：制作者需要拥有的Tag（标签），填nil则所有人都可以做--需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
atlas：制作栏图片文档路径
image：制作栏图片文件名，当名字与Prefab名相同时，可省略。
testfn：自定义检测函数，需要满足该函数才能制作物品，不常用。]]

--
```
## 添加光圈
```lua
---------------------添加光圈开始---------------------
local light = r.entity:AddLight()
light:SetFalloff(1)  -- 最大范围再向外辐射的光效，1几乎不辐射（衰减）
light:SetIntensity(.8)  --光照强度.99为强光
light:SetRadius(10) --光圈范围   inst.level7/3
light:SetColour(math.random(1,255)/255,math.random(1,255)/255,math.random(1,255)/255)--随机光圈颜色
light:Enable(true)--开启照明
-----添加光圈2------上面的写法是个坑 服务器需要注册生成一个光源 客户端才能显示,单机无视------------------
local _fx = _G.SpawnPrefab("minerhatlight")--添加灯光  注册一个光源
_fx.entity:SetParent(w.entity)	--设置父级是谁
_fx.Light:SetFalloff(0.5) --最大范围再向外辐射的光效，1几乎不辐射
_fx.Light:SetIntensity(.99)-- 光照强度.99为强光
_fx.Light:SetRadius(8)-- 照明范围
_fx.Light:SetColour(180/255, 195/255, 50/255)
_fx.Light:Enable(true)-- 开启照明
_fx.Light:EnableClientModulation(false)-- false 不读取客户端的设置，  true 读取客户端本地数据
---------------------添加光圈结束---------------------
```

## 实体
```lua
---------------------创建实体后的各种（重要）---------------------
local inst = CreateEntity()
inst.entity:AddTransform() --形态
inst.entity:AddAnimState() --状态
inst.entity:AddSoundEmitter() --添加声音发射器
inst.entity:AddNetwork() --添加网络
inst.entity:AddImage() --添加图像
inst.entity:AddLabel() --添加标记
inst.entity:AddMiniMapEntity() --添加小图标

inst.entity:LocalToWorldSpace(1,0,0)
inst.entity:AddDebugRender()
inst.entity:GetParent() --获取父级
inst.entity:GetPrefabName()--获取预设的名称
inst.entity:SetParent(item) --设置父级
inst.entity:IsVisible() --是否可见的
---------------------   ---------------------
local swap_data = {bank = "backpack1", anim = "anim"}
MakeInventoryFloatable(inst, "small", 0.2, nil, nil, nil, swap_data) -- 设置漂浮（在水上的时候） ps：这里是添加了 floater 组件
MakeSmallBurnable(inst, time, offset, structure, sym) --使可燃 ps:这里是添加了 burnable 组件
MakeSmallPropagator(inst) --小型传播器 ps:这里添加了 propagator 组件
MakeHauntableLaunchAndDropFirstItem(inst, launchchance, dropchance, speed, cooldown, launch_haunt_value, drop_haunt_value) -- 添加 hauntable 组件(闹鬼)
---------------------   ---------------------
owner._fx = _G.SpawnMyPrefab("tornado")
--方法一（这个方法 父级隐藏了 子级也会跟着隐藏）
if owner._fx ~= nil then
	owner._fx.entity:SetParent(owner.entity) --跟随父级
	owner._fx.Transform:SetPosition(0, 0, 0)
end
--方法二
owner._fx.entity:AddFollower() --添加跟随
owner._fx.Follower:FollowSymbol(owner.GUID,"swap_body",0,0,0) --第一个参数的人物的GUID,第二个参数的显示的位置 这里是 身体 后面三个是坐标
owner._fx.Follower:FollowSymbol(0,"",0,0,0)--取消跟踪

----------------------创建实体后需要的各种结尾---------------------------------------

```

## 快捷代码
```lua
c_spawn("cane_rose_fx")
DebugSpawn("resurrectionstone") 复活代码
TheInput:GetWorldEntityUnderMouse():Remove()
　　删除你鼠标所在位置的物体
AllPlayers[2].components.inventory:GiveItem(SpawnPrefab("lucy"))
GetPlayer().components.builder:GiveAllRecipes()
-------- 全物品直接制造
GetPlayer().components.hungerause(true)
-------------- 不饿
GetPlayer().components.sanity:SetMax(500)
---------- maximum sanity 慎用，不可取消
GetPlayer().components.health:SetMaxHealth(300)
---------- 最大血格
下面是开全地图，要输入2个指令才行，每次都要回车执行：
minimap = TheSim:FindFirstEntityWithTag("minimap")
minimap.MiniMap:ShowArea(0,0,0, 10000)
--------
GetPlayer().components.health:SetInvincible(true)
--------- 上帝模式
```

## 方法或者官方定义的东西
```lua
QueryServer --接口传输 get
FRAMES -- 1/30 帧的时间
local Isserver = GLOBAL.TheNet:GetIsServer() --如果在这个世界
if TheNet:IsDedicated() then  --判定是否为[不是](专用服务器)  -- TheWorld.ismastersim
Prefabs --所有预设物的表
ThePlayer --本体 控制台
AllRecipe -- 配方表  AllRecipes.XXXXX.ingredients
Enst --世界上所有生成的实体 -----？？
GLOBAL.AllPlayers --获取世界上所有的玩家（早进入的貌似只能拿到之前服务器的人数 后进入的拿不到）
AllPlayers[1] --当前世界的第一个玩家
TheNet:GetClientTable() -- 所有玩家（客户端要用的时候调取 不要用AllPlayers）
AddPlayerPostInit(fn) --添加玩家预设
AddPrefabPostInit("预设物",fn) --设置预设物
AddPrefabPostInitAny(fn) --所有预设物
TheInput:GetScreenPosition() --获取当前鼠标的位置
inst.Network:IsServerAdmin() --判断管理员
not TheNet:GetIsClient() --不是客户端
GetModConfigData(XXXX) --获取modinfo的配置
---------------------
ThePlayer.Transform:SetPosition(0,0,0)
-- r为半径，O为角度,
-- x坐标为x1+rcosO，
-- y坐标为y1+rsinO
-- 其中x1，y1为圆心坐标
--  x + 3 约等于  math.sin(30)* -3
local t = {nil , 3}
retunrn unpack(t)   -- nil , 3
inst:PushEvent(event，data)  --设置监听
inst:ListenForEvent(event，fn, source) --"buildstructure", getid --监听
inst:RemoveEventCallback(event，fn) --移除监听
AddClassPostConstruct("widgets/controls", addIntroduceWidget) -- 这个函数是官方的MOD API，用于修改游戏中的类的构造函数。第一个参数是类的文件路径，根目录为scripts。第二个自定义的修改函数，第一个参数固定为self，指代要修改的类。
PrefabFiles = {'预设文件'} --注册prefabs
{no_deconstruction = true} --配方里加 不能毁灭分解
inst.Transform:GetWorldPosition() --获取当前世界位置  可以通过x,y,z接收 也可以通过单个参数接收全部
local pos = inst:GetPosition() --获取当前位置 通过 pos:Get()获取位置
XXX.Transform:SetPosition(x,y,z)--变换定位  XXX= SpawnPrefab("disease_puff")  也可以是inst
AddAction(GIVE_RIGHTCLICK) --向游戏注册一个动作
TheSim:FindEntities(x, y, z, 8) --检测周围物体
local angle = inst.Transform:GetRotation()--获取实体的面向角度   0-180   正负
STRINGS.NAMES.SOULRING = "物品名称" -- SOULRING
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SOULRING = "物品介绍"
STRINGS.RECIPE_DESC.ACHIVBOOK_GARDENING = "制作介绍"
package.loaded[luafile] = nil --  require 二次加载
local x,y,z = Point(1,2,3):Get() print(x,y,z) --打包参数 依次接收
```

## 全局功能代码
```lua
TUNING.GRASSGEKKO_MORPH_CHANCE = 0     ------阻止草变异
TUNING.BASE_COOK_TIME = 0.01   -----快速烹饪  基本烹饪时间
```

## 音效目录
```lua
moonspider_spike冰块的特效 能直接刷出来有声音
inst.SoundEmitter:PlaySound("turnoftides/creatures/together/spider_moon/break")--冰块炸裂
inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")   --影刀的攻击声音   
inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/buff") --飞溅声
caster.SoundEmitter:PlaySound("dontstarve/common/staff_blink") --传送的声音
dontstarve/wilson/equip_item_gold--叮的一下
turnoftides/sanity/lunacy_LP
dontstarve/sanity/sanity
turnoftides/common/together/boat/repair
"turnoftides/common/together/boat/untain_small_LP", "small_leak"
"turnoftides/common/together/boat/fountain_medium_LP", "med_leak"
dontstarve/impacts/impact_
dontstarve/wilson/cook
dontstarve/common/fireBurstLarge
dontstarve/common/fireBurstSmall
dontstarve/common/fireOut
hookline/creatures/squid/ink
turnoftides/common/together/boat/mast/sail_open
turnoftides/common/together/boat/mast/top
dontstarve/maxwell/disappear_adventure
dontstarve/maxwell/disappear
dontstarve/maxwell/appear_adventure
dontstarve/maxwell/disappear
dontstarve/beefalo/saddle/dismount
dontstarve/creatures/together/bee_queen/beeguard/puff
dontstarve/characters/wendy/abigail/shield/on
dontstarve/ghost/ghost_girl_howl_LP
dontstarve/characters/wendy/abigail/shield/retaliation_fx
dontstarve/characters/wendy/abigail/haunted_flower_LP
dontstarve/common/maxwellportal_activate
dontstarve/common/maxwellportal_idle
"dontstarve/common/teleportato/ragtime", "ragtime"
dontstarve/common/maxwellportal_shutdown
turnoftides/common/together/boat/anchor/place
turnoftides/common/together/boat/anchor/ocean_hit
dontstarve/common/sign_craft
dontstarve/common/together/atrium/gate_spike
dontstarve/common/together/atrium/retract
dontstarve/common/together/atrium_gate/shadow_pulse
dontstarve/common/together/atrium_gate/key_in
dontstarve/common/together/atrium_gate/destabilize_LP
dontstarve/common/together/atrium_gate/active_LP
dontstarve/cave/nightmare_spawner_open_LP
dontstarve/common/balloon_bounce
dontstarve/common/ghost_spawn
dontstarve/common/balloon_pop
dontstarve/creatures/bat/flap
dontstarve/cave/bat_cave_explosion
dontstarve/creatures/bat/taunt
dontstarve/cave/bat_cave_warning
dontstarve/creatures/bat/taunt
dontstarve/cave/bat_cave_bat_spawn
dontstarve/common/bee_box_craft
dontstarve/bee/bee_box_LP
dontstarve/bee/bee_hive_LP
dontstarve/common/freezecreature
dontstarve/bee/beehive_destroy
dontstarve/common/freezethaw
dontstarve/bee/beehive_hit
dontstarve/bee/beemine_rattle
dontstarve/bee/beemine_explo
dontstarve/bee/beemine_launch
dontstarve/bee/beemine_rattle
dontstarve/creatures/together/bee_queen/wings_LP
dontstarve/creatures/together/bee_queen/hive_hit
dontstarve/creatures/together/bee_queen/hive_grow
dontstarve/common/bush_fertilize
dontstarve/birds/wingflap_cage
dontstarve/common/birdcage_craft
dontstarve/creatures/bishop/shotexplo
turnoftides/common/together/boat/repair_with_wood
dontstarve/common/destroy_
```

## 配方
```lua

--LIGHT（照明）
campfire（营火）：cutgrass（草）3、log（木）2
firepit（石头营火）：log（木）2、rocks（石）12
torch（火炬）：cutgrass（草）2、twigs（树枝）2
coldfire（冷火）：cutgrass（草）3、nitre（硝石）2
coldfirepit（石头冷火）：nitre（硝石）2、cutstone（石砖）5、transistor（晶体管）2
minerhat（矿工帽）：strawhat（草帽）1、goldnugget（黄金）1、fireflies（萤火虫）1
molehat（鼹鼠帽）：mole（鼹鼠）2、transistor（晶体管）2、wormlight（虫子果）1
pumpkin_lantern（南瓜灯）：pumpkin（南瓜）1、fireflies（萤火虫）1
lantern（提灯）：twigs（树枝）3、rope（绳子）2、lightbulb（荧光果）2


--STRUCTURES（建造）
treasurechest（木箱）：boards（木板）3
homesign（标牌）：boards（木板）1
wall_hay_item（干草墙）：cutgrass（草）4、twigs（树枝）2
wall_wood_item（木墙）：boards（木板）2、rope（绳子）1
wall_stone_item（石墙）：cutstone（石砖）2
pighouse（猪人房）：boards（木板）4、cutstone（石砖）3、pigskin（猪皮）4
rabbithouse（兔子房）：boards（木板）4、carrot（胡萝卜）10、manrabbit_tail（兔人尾巴）4
birdcage（鸟笼）：papyrus（纸）2、goldnugget（黄金）6、seeds（种子）2
turf_road（卵石路）：turf_rocky（岩石草皮）1、boards（木板）1
turf_woodfloor（木地板）：boards（木板）1
turf_checkerfloor（棋盘地板）：marble（大理石）1
turf_carpetfloor（地毯地板）：boards（木板）1、beefalowool（牛毛）1
pottedfern（盆栽植物）：foliage（叶子）5、slurtle_shellpieces（蜗牛壳碎片）1
dragonflychest（蜻蜓箱子）：dragon_scales（蜻蜓鳞片）1、boards（木板）4、goldnugget（黄金）10


--FARM（种植）
slow_farmplot（一般农田）：cutgrass（草）8、poop（便便）4、log（木）4
fast_farmplot（高级农田）：cutgrass（草）10、poop（便便）6、rocks（石）4
fertilizer（化肥）：poop（便便）3、boneshard（硬骨头）2、log（木）4
beebox（蜂箱）：boards（木板）2、honeycomb（蜂巢）1、bee（蜜蜂）4
meatrack（晾肉架）：twigs（树枝）3、charcoal（木炭）2、rope（绳子）3
cookpot（煮锅）：cutstone（石砖）3、charcoal（木炭）6、twigs（树枝）6
icebox（冰箱）：goldnugget（黄金）2、gears（齿轮）1、cutstone（石砖）1


--SURVIVAL（生存）
trap（陷阱）：twigs（树枝）2、cutgrass（草）6
birdtrap（捕鸟陷阱）：twigs（树枝）3、silk（蛛丝）4
bugnet（捕虫网）：twigs（树枝）4、silk（蛛丝）2、rope（绳子）1
fishingrod（鱼竿）：twigs（树枝）2、silk（蛛丝）2
grass_umbrella（草伞）：twigs（树枝）4、cutgrass（草）3、petals（花瓣）6
umbrella（伞）：twigs（树枝）6),pigskin（猪皮）1、silk（蛛丝）2
bandage（蜂蜜绷带）：papyrus（纸）1、honey（蜂蜜）2
healingsalve（治疗药膏）：ash（灰）2、rocks（石）1、spidergland（蜘蛛腺体）1
compass（指南针）：goldnugget（黄金）1、papyrus（纸）1
heatrock（保温石）：rocks（石）10、pickaxe（镐）1、flint（燧石）3
backpack（背包）：cutgrass（草）4、twigs（树枝）4
piggyback（猪皮包）：pigskin（猪皮）4、silk（蛛丝）6、rope（绳子）2
bedroll_straw（草席卷）：cutgrass（草）6、rope（绳子）1
bedroll_furry（毛皮铺盖）：bedroll_straw（草席卷）1、manrabbit_tail（兔人尾巴）2
tent（帐篷）：silk（蛛丝）6、twigs（树枝）4、rope（绳子）3
siestahut（午睡小屋）：silk（蛛丝）2、boards（木板）4、rope（绳子）3
featherfan（羽毛扇）：goose_feather（鹿鸭羽毛）5、cutreeds（芦苇）5、rope（绳子）2
icepack（冰包）：bearger_fur（熊皮）1、gears（齿轮）3、transistor（晶体管）3


--TOOLS（工具）
axe（斧头）：twigs（树枝）1、flint（燧石）1
goldenaxe（黄金斧头）：twigs（树枝）4、goldnugget（黄金）2
pickaxe（镐）：twigs（树枝）2、flint（燧石）2
goldenpickaxe（黄金镐）：twigs（树枝）4、goldnugget（黄金）2
shovel（铲子）：twigs（树枝）2、flint（燧石）2
goldenshovel（黄金铲子）：twigs（树枝）4、goldnugget（黄金）2
hammer（锤子）：twigs（树枝）3、rocks（石）3、cutgrass（草）6
pitchfork（草叉）：twigs（树枝）2、flint（燧石）2
razor（剃刀）：twigs（树枝）2、flint（燧石）2


--SCIENCE（科学）
researchlab（科学机器）：goldnugget（黄金）1、log（木）4、rocks（石）4
researchlab2（炼金术引擎）：boards（木板）4、cutstone（石砖）2、transistor（晶体管）2
transistor（晶体管）：goldnugget（黄金）2、cutstone（石砖）2
diviningrod（探矿杖）：twigs（树枝）1、nightmarefuel（噩梦燃料）4、gears（齿轮）1
winterometer（寒冬温度计）：boards（木板）2、goldnugget（黄金）2
rainometer（雨量计）：boards（木板）2、goldnugget（黄金）2、rope（绳子）2
gunpowder（火药）：rottenegg（烂鸡蛋）1、charcoal（木炭）1、nitre（硝石）1
lightning_rod（避雷针）：goldnugget（黄金）4、cutstone（石砖）1
firesuppressor（灭火器）：gears（齿轮）2、ice（冰）15、transistor（晶体管）2


--MAGIC（魔法）
researchlab4（灵子分解器）：rabbit（兔子）4、boards（木板）4、tophat（高礼帽）1
researchlab3（阴影操纵者）：livinglog（活木头）3、purplegem（紫宝石）1、nightmarefuel（噩梦燃料）7
resurrectionstatue（肉块雕像）：boards（木板）4、cookedmeat（熟肉）4、beardhair（胡须）4
panflute（排箫）：cutreeds（芦苇）5、mandrake（曼德拉草）1、rope（绳子）1
bell（铃）：glommerwings（格罗门翅膀）1、glommerflower（格罗门花）1
onemanband（独奏乐器）：goldnugget（黄金）2、nightmarefuel（噩梦燃料）4、pigskin（猪皮）2
nightlight（暗影照明灯）：goldnugget（黄金）8、nightmarefuel（噩梦燃料）2、redgem（红宝石）1
armor_sanity（夜魔盔甲）：nightmarefuel（噩梦燃料）5、papyrus（纸）3
nightsword（暗夜剑）：nightmarefuel（噩梦燃料）5、livinglog（活木头）1
batbat（蝙蝠棒）：batwing（蝙蝠翅膀）5、livinglog（活木头）2、purplegem（紫宝石）1
armorslurper（饥饿腰带）：slurper_pelt（啜食者皮）6、rope（绳子）2、nightmarefuel（噩梦燃料）2
amulet（红色护身符）：goldnugget（黄金）3、nightmarefuel（噩梦燃料）2、redgem（红宝石）1
blueamulet（蓝色护身符）：goldnugget（黄金）3、bluegem（蓝宝石）1
purpleamulet（紫色护身符）：goldnugget（黄金）6、nightmarefuel（噩梦燃料）4、purplegem（紫宝石）2
firestaff（火魔杖）：nightmarefuel（噩梦燃料）2、spear（长矛）1、redgem（红宝石）1
icestaff（冰魔杖）：spear（长矛）1、bluegem（蓝宝石）1
telestaff（传送魔杖）：nightmarefuel（噩梦燃料）4、livinglog（活木头）2、purplegem（紫宝石）2
telebase（传送核心）：nightmarefuel（噩梦燃料）4、livinglog（活木头）4、goldnugget（黄金）8


--REFINE（精炼）
rope（绳子）：cutgrass（草）3
boards（木板）：log（木）4
cutstone（石砖）：rocks（石）3
papyrus（纸）：cutreeds（芦苇）4
transistor（晶体管）：goldnugget（黄金）2、cutstone（石砖）1
nightmarefuel（噩梦燃料）：petals_evil（噩梦花瓣）4
purplegem（紫宝石）：redgem（红宝石）1、bluegem（蓝宝石）1


--WAR（战斗）
spear（矛）：twigs（树枝）2、rope（绳子）1、flint（燧石）1
hambat（火腿短棍）：pigskin（猪皮）1、twigs（树枝）2、meat（大肉）2
nightstick（夜棍）：lightninggoathorn（闪电羊角）1、transistor（晶体管）2
armorgrass（草盔甲）：cutgrass（草）10、twigs（树枝）2
armorwood（木盔甲）：log（木）8、rope（绳子）2
armormarble（大理石盔甲）：marble（大理石）12、rope（绳子）4
footballhat（猪皮帽）：pigskin（猪皮）1、rope（绳子）1
blowdart_sleep（麻醉吹箭）：cutreeds（芦苇）2、stinger（蜂刺）1、feather_crow（乌鸦羽毛）1
blowdart_fire（燃烧吹箭）：cutreeds（芦苇）2、charcoal（木炭）1、feather_robin（红雀羽毛）1
blowdart_pipe（吹箭）：cutreeds（芦苇）2、houndstooth（犬牙）1、feather_robin_winter（雪雀羽毛）1
boomerang（回旋镖）：boards（木板）1、silk（蛛丝）1、charcoal（木炭）1
beemine（蜜蜂地雷）：boards（木板）1、bee（蜜蜂）4、flint（燧石）1
trap_teeth（牙齿陷阱）：log（木）1、rope（绳子）1、houndstooth（犬牙）1
armordragonfly（蜻蜓盔甲）：dragon_scales（蜻蜓鳞片）1、armorwood（木盔甲）1、pigskin（猪皮）3
staff_tornado（龙卷风魔杖）：goose_feather（鹿鸭羽毛）10、lightninggoathorn（闪电羊角）1、gears（齿轮）1


--DRESSUP（穿戴）
sewing_kit（针线包）：log（木）1、silk（蛛丝）8、houndstooth（犬牙）2
flowerhat（花环）：petals（花瓣）12
strawhat（草帽）：cutgrass（草）12
tophat（高礼帽）：silk（蛛丝）6
rainhat（防雨帽）：mole（鼹鼠）2、strawhat（草帽）1、boneshard（硬骨头）1
earmuffshat（兔耳罩）：rabbit（兔子）2、twigs（树枝）1
beefalohat（牛毛帽）：beefalowool（牛毛）8、horn（野牛角）1
winterhat（寒冬帽）：beefalowool（牛毛）4、silk（蛛丝）4
catcoonhat（浣熊帽）：coontail（浣熊尾巴）4、silk（蛛丝）4
watermelonhat（西瓜帽）：watermelon（西瓜）1、twigs（树枝）3
icehat（冰帽）：transistor（晶体管）2、rope（绳子）4、ice（冰）10
beehat（养蜂帽）：silk（蛛丝）8、rope（绳子）1
featherhat（羽毛帽）：feather_crow（乌鸦羽毛）3、feather_robin（红雀羽毛）2、tentaclespots（触手皮）2
bushhat（丛林帽）：strawhat（草帽）1、rope（绳子）1、dug_berrybush（浆果灌木丛）1
raincoat（雨衣）：tentaclespots（触手皮）2、rope（绳子）2、boneshard（硬骨头）2
sweatervest（小巧背心）：houndstooth（犬牙）8、silk（蛛丝）6
trunkvest_summer（夏日背心）：trunk_summer（红色象鼻）1、silk（蛛丝）8
trunkvest_winter（寒冬背心）：trunk_winter（蓝色象鼻）1、silk（蛛丝）8、beefalowool（牛毛）2
reflectivevest（反射背心）：rope（绳子）1、feather_robin（红雀羽毛）4、pigskin（猪皮）2
hawaiianshirt（夏威夷衬衫）：papyrus（纸）3、silk（蛛丝）3、cactus_flower（仙人掌花）5
cane（步行手杖）：goldnugget（黄金）2、walrus_tusk（海象牙）1、twigs（树枝）4
beargervest（熊背心）：bearger_fur（熊皮）1、sweatervest（小巧背心）1、rope（绳子）2
eyebrellahat（眼睛帽）：deerclops_eyeball（巨鹿眼球）1、twigs（树枝）15、boneshard（硬骨头）4


----ANCIENT----（远古）
thulecite（铥矿石）：thulecite_pieces（铥矿碎片）6
wall_ruins_item（铥矿墙）：thulecite（铥矿石）1
nightmare_timepiece（铥矿奖章）：thulecite（铥矿石）2、nightmarefuel（噩梦燃料）2
orangeamulet（橙色护身符）：thulecite（铥矿石）2、nightmarefuel（噩梦燃料）3、orangegem（橙色宝石）1
yellowamulet（黄色护身符）：thulecite（铥矿石）2、nightmarefuel（噩梦燃料）3、yellowgem（黄色宝石）1
greenamulet（绿色护身符）：thulecite（铥矿石）2、nightmarefuel（噩梦燃料）3、greengem（绿色宝石）1
orangestaff（橙色魔杖）：nightmarefuel（噩梦燃料）2、cane（步行手杖）1、orangegem（橙色宝石）2
yellowstaff（黄色魔杖）：nightmarefuel（噩梦燃料）4、livinglog（活木头）2、yellowgem（黄宝石）2
greenstaff（绿色魔杖）：nightmarefuel（噩梦燃料）4、livinglog（活木头）2、greengem（绿色宝石）2
multitool_axe_pickaxe（多功能工具）：goldenaxe（黄金斧头）1、goldenpickaxe（黄金镐）1、thulecite（铥矿石）2

ruinshat（远古王冠）：thulecite（铥矿石）4、nightmarefuel（噩梦燃料）4
armorruins（远古盔甲）：thulecite（铥矿石）6、nightmarefuel（噩梦燃料）4
ruins_bat（远古短棒）：livinglog（活木头）3、thulecite（铥矿石）4、nightmarefuel（噩梦燃料）4
eyeturret_item（眼睛炮塔）：deerclops_eyeball（巨鹿眼球）1、minotaurhorn（远古守护者角）1、thulecite（铥矿石）5


三七六.常用物品中英文名称

1.材料：

cutgrass（草）  twigs（树枝） log（木头） charcoal（木炭） ash（灰） cutreeds（采下的芦苇） lightbulb（荧光果）  petals（花瓣）  petals_evil（噩梦花瓣）
pinecone（松果） foliage （叶子） cutlichen（摘下的苔藓）   wormlight（虫子果） lureplantbulb（食人花种子） flint（燧石）  nitre（硝石）
redgem  （红宝石）bluegem （蓝宝石）purplegem （紫宝石）greengem（绿宝石） orangegem（橙宝石） yellowgem（黄宝石） rocks（岩石）goldnugget（黄金）
thulecite（铥矿石） thulecite_pieces（铥矿碎片）
rope （绳子）
boards （木板）
cutstone （石砖）
papyrus （纸）
houndstooth （犬牙）
pigskin （猪皮）
manrabbit_tail （兔人尾巴）
silk （蜘蛛丝）
spidergland （蜘蛛腺体）
spidereggsack （蜘蛛卵）
beardhair （胡子）
beefalowool （牛毛）
honeycomb （蜂巢）
stinger （蜂刺）
walrus_tusk （海象牙）
feather_crow （乌鸦羽毛）
feather_robin （红雀羽毛）
feather_robin_winter （雪雀羽毛）
horn （牛角）
tentaclespots （触手皮）
trunk_summer （夏象鼻）
trunk_winter （冬象鼻）
slurtleslime （蜗牛龟粘液）
slurtle_shellpieces （蜗牛龟壳片）
butterflywings （蝴蝶翅膀）
mosquitosack （蚊子血囊）
slurper_pelt （啜食者皮）
minotaurhorn （远古守护者角）
deerclops_eyeball （巨鹿眼球）
lightninggoathorn （闪电羊角）
glommerwings （格罗门翅膀）
glommerflower （格罗门花）
glommerfuel （格罗门燃料）
livinglog （活木头）
nightmarefuel （噩梦燃料）
gears （齿轮）
transistor（晶体管）
marble （大理石）
boneshard （硬骨头）
ice （冰）
poop （便便）
guano （鸟粪）
dragon_scales （蜻蜓鳞片）
goose_feather （鹿鸭羽毛）
coontail （浣熊尾巴）
bearger_fur （熊皮）



2.工具武器：

axe （斧子）
goldenaxe （黄金斧头）
lucy （露西斧子）
hammer （锤子）
pickaxe （镐）
goldenpickaxe （黄金镐）
shovel （铲子）
goldenshovel （黄金铲子）
pitchfork （草叉）
razor （剃刀）
bugnet （捕虫网）
fishingrod （鱼竿）
multitool_axe_pickaxe （多功能工具）
cane （行走手杖）
trap （陷阱）
birdtrap （鸟陷阱）
trap_teeth （牙齿陷阱）
trap_teeth_maxwell （麦斯威尔的牙齿陷阱）
backpack （背包）
piggyback （猪皮包）
krampus_sack （坎普斯背包）
umbrella （雨伞）
grass_umbrella（草伞）
heatrock （保温石）
bedroll_straw （草席卷）
bedroll_furry （毛皮铺盖）
torch （火炬）
lantern （提灯）
pumpkin_lantern （南瓜灯）
compass （指南针）
fertilizer（化肥）
firesuppressor（灭火器）
sewing_kit （缝纫工具包）
spear （矛）
boomerang （回旋镖）
tentaclespike （狼牙棒）
blowdart_pipe （吹箭）
blowdart_sleep （麻醉吹箭）
blowdart_fire （燃烧吹箭）
hambat （火腿短棍）
nightsword （暗影剑）
batbat （蝙蝠棒）
ruins_bat （远古短棒）
spear_wathgrithr （瓦丝格雷斯矛）
panflute （排箫）
onemanband （独奏乐器）
gunpowder （火药）
beemine （蜜蜂地雷）
bell （铃）
amulet （红色护身符）
blueamulet （蓝色护身符）
purpleamulet （紫色护身符）
yellowamulet （黄色护身符）
orangeamulet （橙色护身符） 
greenamulet （绿色护身符）
nightmare_timepiece （铥矿奖章）
icestaff （冰魔杖）
firestaff （火魔杖）
telestaff （传送魔杖）
orangestaff （橙色魔杖）
greenstaff （绿色魔杖）
yellowstaff （黄色魔杖）
diviningrod （探矿杖）
book_birds （召唤鸟的书）
book_tentacles （召唤触手的书）
book_gardening （催生植物的书）
book_sleep （催眠的书）
book_brimstone （召唤闪电的书）
waxwelljournal （麦斯威尔的日志）
abigail_flower （阿比盖尔之花）
balloons_empty （空气球）
balloon （气球） 
lighter （薇洛的打火机）
chester_eyebone （切斯特骨眼）
featherfan （羽毛扇）
staff_tornado （龙卷风魔杖）
nightstick （夜棍）



3.穿戴：

strawhat （草帽）
flowerhat （花环）
beefalohat （牛毛帽）
featherhat （羽毛帽）
footballhat （猪皮帽）
tophat （高礼帽）
earmuffshat （兔耳罩）
winterhat （冬帽）
minerhat （矿工帽）
spiderhat （蜘蛛帽）
beehat （蜂帽）
walrushat （海象帽）
slurtlehat （蜗牛帽子）
bushhat （丛林帽）
ruinshat （远古王冠）
rainhat（防雨帽）
icehat（冰帽）
watermelonhat （西瓜帽）
catcoonhat （浣熊帽）
wathgrithrhat （瓦丝格雷斯帽）
armorwood （木盔甲）
armorgrass （草盔甲）
armormarble （大理石盔甲）
armor_sanity （夜魔盔甲）
armorsnurtleshell （蜗牛龟盔甲）
armorruins （远古盔甲）
sweatervest （小巧背心）
trunkvest_summer （夏日背心）
trunkvest_winter （寒冬背心）
armorslurper （饥饿腰带）
raincoat（雨衣）
webberskull （韦伯头骨）
molehat （鼹鼠帽）
armordragonfly （蜻蜓盔甲）
beargervest （熊背心）
eyebrellahat （眼睛帽）
reflectivevest （反射背心）
hawaiianshirt （夏威夷衬衫）



4.建筑：

campfire （营火）
firepit （石头营火）
coldfire（冷火）
coldfirepit（石头冷火）
cookpot （锅）
icebox （冰箱）
winterometer （寒冰温度计）
rainometer （雨量计）
slow_farmplot （一般农田）
fast_farmplot （高级农田）
siestahut（午睡小屋）
tent （帐篷）
homesign （路牌）
birdcage （鸟笼）
meatrack （晾肉架）
lightning_rod （避雷针）
pottedfern （盆栽）
nightlight （暗夜照明灯）
nightmarelight （影灯）
researchlab （科学机器）
researchlab2 （炼金术引擎）
researchlab3 （阴影操纵者）
researchlab4 （灵子分解器）
treasurechest （木箱）
skullchest （骷髅箱）
pandoraschest （华丽的箱子）
minotaurchest （大华丽的箱子）
wall_hay_item （草墙）
wall_wood_item （木墙）
wall_stone_item （石墙）
wall_ruins_item （铥墙）
wall_hay （地上的草墙）
wall_wood （地上的木墙）
wall_stone （地上的石墙）
wall_ruins （地上的铥墙）
pighouse （猪房）
rabbithole （兔房）
mermhouse （鱼人房）
resurrectionstatue （肉块雕像）
resurrectionstone （重生石）
ancient_altar  （远古祭坛）
ancient_altar_broken  （损坏的远古祭坛）
telebase （传送核心）
gemsocket （宝石看台）
eyeturret （固定在地上的眼睛炮塔）
eyeturret_item （可带走的眼睛炮塔）
cave_exit （洞穴出口）
turf_woodfloor （木地板）
turf_carpetfloor （地毯地板）
turf_checkerfloor （棋盘地板）
adventure_portal （冒险之门）
rock_light （火山坑）
gravestone （墓碑）
mound （坟墓土堆）
skeleton （人骨）
houndbone （狗骨头）
animal_track （动物足迹）
dirtpile （可疑的土堆）
pond （池塘）
pond_cave （洞穴池塘）
pighead （猪头棍）
mermhead （鱼头棍）
pigtorch （猪火炬）
rabbithole （兔子洞）
beebox （蜂箱）
beehive （野生蜂窝）
wasphive （杀人蜂窝）
spiderhole （洞穴蜘蛛洞）
walrus_camp （海象窝）
tallbirdnest （高鸟窝）
houndmound （猎犬丘）
slurtlehole （蜗牛窝）
batcave （蝙蝠洞）
monkeybarrel （猴子桶）
spiderden （蜘蛛巢穴）
molehill （鼹鼠丘）
catcoonden （浣熊洞）
rock1 （带硝石的岩石）
rock2 （带黄金的岩石）
rock_flintless （只有石头的岩石）
stalagmite_full （大圆洞穴石头）
stalagmite_med （中圆洞穴石头）
stalagmite_low （小圆洞穴石头）
stalagmite_tall_full （大高洞穴石头）
stalagmite_tall_med （中高洞穴石头）
stalagmite_tall_low （小高洞穴石头）
rock_ice （冰石）
ruins_statue_head （远古头像）
ruins_statue_mage （远古法师雕像）
marblepillar （大理石柱子）
marbletree （大理石树）
statueharp （竖琴雕像）
basalt （玄武岩）
basalt_pillar （高玄武岩）
insanityrock （猪王矮柱石）
sanityrock （猪王高柱石）
ruins_chair （远古椅子）
ruins_vase （远古花瓶）
ruins_table （远古桌子）
statuemaxwell （麦斯威尔雕像）
statueglommer （格罗门雕像）
relic （废墟）
ruins_rubble （损毁的废墟）
bishop_nightmare （损坏的雕像）
rook_nightmare （损坏的战车）
knight_nightmare （损坏的骑士）
chessjunk1 （损坏的机械1）
chessjunk2 （损坏的机械2）
chessjunk3 （损坏的机械3）
teleportato_ring （环状传送机零件）
teleportato_box （盒状传送机零件）
teleportato_crank （曲柄状传送机零件）
teleportato_potato （球状传送机零件）
teleportato_base （传送机零件底座）
teleportato_checkmate （传送机零件底座）
wormhole （虫洞）
wormhole_limited_1 （被限制的虫洞）
stafflight （小星星）
treasurechest_trap （箱子陷阱）
icepack （冰包）
dragonflychest （蜻蜓箱子）



5.食物：

carrot （胡萝卜）
carrot_cooked （熟胡萝卜）
berries （浆果）
berries_cooked （熟浆果）
pumpkin （南瓜）
pumpkin_cooked （熟南瓜）
dragonfruit （火龙果）
dragonfruit_cooked （熟火龙果）
pomegranate （石榴）
pomegranate_cooked （熟石榴）
corn （玉米）
corn_cooked （熟玉米）
durian （榴莲）
durian_cooked （熟榴莲）
eggplant （茄子）
eggplant_cooked （熟茄子）
cave_banana （洞穴香蕉）
cave_banana_cooked （熟洞穴香蕉）
acorn （橡果）
acorn_cooked（熟橡果）
cactus_meat （仙人掌肉）
watermelon（西瓜）
red_cap （采摘的红蘑菇）
red_cap_cooked （煮熟的红蘑菇）
green_cap （采摘的绿蘑菇）
green_cap_cooked （煮熟的绿蘑菇）
blue_cap_cooked （煮熟的蓝蘑菇）
blue_cap （采摘的蓝蘑菇）
seeds （种子）
seeds_cooked （熟种子）
carrot_seeds （胡萝卜种子）
pumpkin_seeds （南瓜种子）
dragonfruit_seeds （火龙果种子）
pomegranate_seeds （石榴种子）
corn_seeds （玉米种子）
durian_seeds （榴莲种子）
eggplant_seeds （茄子种子）
smallmeat （小肉）
cookedsmallmeat （小熟肉）
smallmeat_dried （小干肉）
meat （大肉）
cookedmeat （大熟肉）
meat_dried （大干肉）
drumstick （鸡腿）
drumstick_cooked （熟鸡腿）
monstermeat （疯肉）
cookedmonstermeat （熟疯肉）
monstermeat_dried （干疯肉）
plantmeat （食人花肉）
plantmeat_cooked （熟食人花肉）
bird_egg （鸡蛋）
bird_egg_cooked （煮熟的鸡蛋）
rottenegg （烂鸡蛋）
tallbirdegg （高鸟蛋）
tallbirdegg_cooked （熟高鸟蛋）
tallbirdegg_cracked （孵化的高鸟蛋）
fish （鱼）
fish_cooked （熟鱼）
eel （鳗鱼）
eel_cooked （熟鳗鱼）
froglegs （蛙腿）
froglegs_cooked （熟蛙腿）
batwing （蝙蝠翅膀）
batwing_cooked （熟蝙蝠翅膀）
trunk_cooked （熟象鼻）
mandrake （曼德拉草）
cookedmandrake （熟曼特拉草）
honey （蜂蜜）
butter （黄油）
butterflymuffin （奶油松饼）
frogglebunwich （青蛙圆面包三明治）
honeyham （蜜汁火腿）
dragonpie （龙馅饼）
taffy （太妃糖）
pumpkincookie （南瓜饼）
kabobs （肉串）
powcake （芝士蛋糕）
mandrakesoup （曼德拉草汤）
baconeggs （鸡蛋火腿）
bonestew （肉汤）
perogies （半圆小酥饼）
wetgoop （湿腻焦糊）
ratatouille （蹩脚的炖菜）
fruitmedley （水果拼盘）
fishtacos  （玉米饼包炸鱼）
waffles  （华夫饼）
turkeydinner （火鸡正餐）
fishsticks （鱼肉条）
stuffedeggplant （香酥茄盒）
honeynuggets （甜蜜金砖）
meatballs （肉丸）
jammypreserves （果酱蜜饯）
monsterlasagna （怪物千层饼）
unagi （鳗鱼料理）
bandage （蜂蜜绷带）
healingsalve （治疗药膏）
spoiled_food （腐烂食物）
flowersalad （花沙拉）
icecream （冰激淋）
watermelonicle （西瓜冰）
trailmix （干果）
hotchili （咖喱）
guacamole （鳄梨酱）
goatmilk （羊奶）



6.植物：

flower （花）
flower_evil （噩梦花）
carrot_planted （长在地上的胡萝卜）
grass （长在地上的草）
depleted_grass （草根）
dug_grass （长草簇）
sapling （树苗）
dug_sapling （可种的树苗）
berrybush （果树丛）
dug_berrybush （可种的果树丛）
berrybush2 （果树丛2）
dug_berrybush2 （可种的果树丛2）
marsh_bush （尖刺灌木）
dug_marsh_bush （可种的尖刺灌木）
reeds （芦苇）
lichen （洞穴苔藓）
cave_fern （蕨类植物）
evergreen （树）
evergreen_sparse （无松果的树）
marsh_tree （针叶树）
cave_banana_tree （洞穴香蕉树）
livingtree （活树）
deciduoustree （橡树）
deciduoustree_tall （高橡树）
deciduoustree_short （矮橡树）
red_mushroom （红蘑菇）
green_mushroom （绿蘑菇）
blue_mushroom （蓝蘑菇）
mushtree_tall （高蘑菇树）
mushtree_medium （中蘑菇树）
mushtree_small （小蘑菇树）
flower_cave （单朵洞穴花）
flower_cave_double （双朵洞穴花）
flower_cave_triple （三朵洞穴花）
tumbleweed （滚草）
cactus （仙人掌）
cactus_flower （仙人掌花）
marsh_plant （水塘边小草）
pond_algae （水藻）



7.动物：

rabbit （兔子）
perd （火鸡）
crow （乌鸦）
robin （红雀）
robin_winter （雪雀）
butterfly （蝴蝶）
fireflies （萤火虫）
bee （蜜蜂）
killerbee （杀人蜂）
flies （苍蝇）
mosquito （蚊子）
frog （青蛙）
beefalo （牛）
babybeefalo （小牛）
lightninggoat （闪电羊）
pigman （猪人）
pigguard （猪守卫）
bunnyman （兔人）
merm （鱼人）
spider_hider （洞穴蜘蛛）
spider_spitter （喷射蜘蛛）
spider （地面小蜘蛛）
spider_warrior （地面绿蜘蛛）
spiderqueen （蜘蛛女王）
spider_dropper （白蜘蛛）
hound （猎狗）
firehound （红色猎狗）
icehound （冰狗）tentacle （触手）tentacle_garden （巨型触手）leif （树精）leif_sparse （稀有树精）walrus （海象）little_walrus （小海象）smallbird （小高鸟）teenbird （青年高鸟）tallbird （高鸟）koalefant_summer （夏象）koalefant_winter （冬象）penguin （企鹅）slurtle （蜗牛龟）snurtle （黏糊虫）bat （蝙蝠）rocky （龙虾）monkey （猴子）
slurper （缀食者）buzzard （秃鹫）mole （鼹鼠）catcoon （浣熊）knight （发条骑士）bishop （主教）rook （战车）crawlinghorror （爬行暗影怪）terrorbeak （尖嘴暗影怪）deerclops （巨鹿）minotaur （远古守护者）worm （远古虫子）abigail （阿比盖尔）ghost （幽灵）shadowwaxwell （麦斯威尔黑影小人）krampus （坎普斯）
glommer （格罗门）chester （切斯特）lureplant （食人花）eyeplant （食人花眼睛）bigfoot （大脚）pigking （猪王）moose （鹿鸭）mossling （小鸭）dragonfly （蜻蜓）warg（座狼） bearger （熊）birchnutdrake （坚果鸭）  mooseegg（鹿鸭蛋）

8.角色：
wilson （威尔逊） waxwell （麦斯威尔） wendy（温蒂） woodie （伍迪） wes（韦斯）
wickerbottom（图书管理员）willow（薇洛）wolfgang（沃尔夫冈）wx78（机器人）wathgrithr（瓦丝格雷斯）webber（韦伯）

moon_fissure 天体裂缝 moon_fissure_plugged  堵住的裂缝 moon_fissure_fx 裂缝的发光特效 klaus 克劳斯 klaus_sack 克劳斯袋  klaussackkey 克劳斯袋钥匙 deer_antler 鹿角 deer_antler 
冰鹿deer_ice_circle 　deer_blue 火鹿deer_fire_circle deer_red  圣诞食物  winter_food1  winter_food2 winter_food3  winter_food4 圣诞灯　winter_ornament_light1　winter_ornament_light2　winter_ornament_light3　winter_ornament_light4


eyebrellahat 眼球伞
royal_jelly 蜂王浆
dragon_scales 蜻蜓鳞片
shroom_skin 蛤蟆皮
dragonfly  龙蝇
beequeen  蜂后
deerclops  巨鹿
leif  树精
bearger 熊
moose 鸭子
warg  座狼
toadstool  蛤蟆
nightsword（暗影剑）
lucky_goldnugget 元宝
waterballoon 水球
sculpture_bishophead 主教头部
sculpture_knighthead  马
sculpture_rooknose 战车鼻部
shadowheart 暗影之心
fossil_stalker 骨架
opalpreciousgem 彩虹宝石
waterballoon 水球
homesign木牌
```