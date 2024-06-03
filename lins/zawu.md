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