>   随笔
## 快采功能
```lua 
function pick(inst)
	if inst.components.pickable then --如果是可以挑选的(意思就是可采集的)
	inst.components.pickable.quickpick = true --快速挑选改为true
	end
end
AddPrefabPostInit("sapling", pick)
--sapling树苗  marsh_bush（尖刺灌木）reeds（芦苇） grass（长在地上的草）berrybush（果树丛）berrybush2（果树丛2）flower_cave（单朵洞穴花）
--flower_cave_double（双朵洞穴花）flower_cave_triple（三朵洞穴花） red_mushroom（红蘑菇）green_mushroom（绿蘑菇）blue_mushroom（蓝蘑菇）
--lichen（洞穴苔藓）
```

## 背包保鲜
```lua 
AddPrefabPostInit("backpack", function(inst)
	local nofreezethermal='N'
	if not inst:AddTag("fridge") then --没有冰箱这个标签的情况
		inst:AddTag("fridge") --添加冰箱标签
	end
	if nofreezethermal == "N" then  --nofreezethermal为N的时候 不对背包中的暧石降温 为Y的时候背包中的暧石会冻结
		inst:AddTag("nocool")--？不知道什么标签
	end

	TUNING.PERISH_FRIDGE_MULT = -1  --0.5为正常保鲜 0为冻结 -1为反鲜
end)
```

## 全人物读书
```lua 
AddPlayerPostInit(function(inst) if inst.prefab ~= "wickerbottom" then inst:AddComponent("reader")end end)
```
## 设置人物移动移速 可读书
```lua 
AddPlayerPostInit(function(inst)
	if inst.prefab ~= nil then  end
	inst.components.locomotor.walkspeed =  18 --步行速度
	inst.components.locomotor.runspeed = 28 --跑步速度
	inst:AddComponent("reader") --添加公共组件 读书
end)
```

## 行为限制
```lua 
AddStategraphPostInit("wilson", function(sg)		--玩家.sg
	local old_build = sg.actionhandlers[ACTIONS.BUILD].deststate --ACTIONS.BUILD 制作物品  ACTIONS.PICK 采集 ACTIONS.CHOP 砍伐  ACTIONS.MINE 挖  ACTIONS.DIG 铲
	local day = GLOBAL.TheWorld.state.cycles --世界天数
	sg.actionhandlers[ACTIONS.BUILD].deststate=function(inst, action)
	--inst代表人物  action ( action#table doer#wilson onfail#table doerownsobject#false recipe#制作物品的代码 onsuccess#table distance#1 options#table pos#俩个数字坐标和一个nil)
		if  day > 30 then
			return old_build(inst, action)
		else
			inst.components.talker:Say("世界天数小于30天无法制作")
		end
	end
end)
```

## 随机获取圆内的随机坐标
```lua 
local theta = math.random() * 2 * PI
local radius = math.random(0, 3.5)
local result_offset = _G.FindValidPositionByFan(theta, radius, 12, function(offset) -- radius半径 360度分成12个坐标 最终返回一个坐标
	local pos = pt + offset		--pos需要自己定义 是拿人物当前的位置还是 鼠标之类的 	 inst:GetPosition()
	return pos
end)
local m,n,v = result_offset:Get() --result_offset为最终获得的坐标
```

## 碰撞伤害
```lua 
function(inst)
	inst.owner = nil --owner，特效算作谁打出来的，就指向谁
	inst:DoPeriodicTask(0.1, function()
	local x,y,z = inst.Transform:GetWorldPosition() --获取实体坐标
	--不会伤害到的东西    fx 特效  noclike不能被鼠标点击到的 DECOR装饰 INLIMBO 容器（物品栏这些） player玩家 wall墙  companion 就是格鲁姆，训好的牛啥玩意的
	-- {"_combat","_health"} 表示的是搜索的物品范围有战斗和血量组件   12表示搜索的范围  {"_inventoryitem","HAMMER_workable"}表示找拥有其中一个标签的
	local ens = TheSim:FindEntities(x, 0, z, 12, {"_combat","_health"}, {"FX","NOCLICK","DECOR","INLIMBO","player","wall","companion"},{"_inventoryitem","HAMMER_workable"})
	local attacker = inst.owner or inst
	for i,v in ipairs(ens) do --搜索到俩码之内的物品
		if ( inst.owner == nil or v ~= inst.owner ) and not v.components.health:IsDead() then--不是这些东西 且不是死的
			v.components.combat:GetAttacked( attacker,7 ) --受到攻击
			end
		end
	end)
end
```

## 跟随实体
```lua 
owner._fx = _G.SpawnPrefab("slurperlight") --生成的效果
if owner._fx ~= nil then
	owner._fx.entity:SetParent(owner.entity) --设置父级 owner
	owner._fx.Transform:SetPosition(0, 0, 0)--偏差的位置
end
```
## 保存加载
```lua 
-----------虽然外部写保存能兼容 但如果遇到别人没写且比自己写的晚加载的时候会把函数覆盖--推荐还是写组件里面------
local old_save = inst.OnSave --旧的保存
inst.OnSave = function(inst,data)--保存
	if old_save ~= nil then old_save(inst,data) end
	if inst.money ~=nil then data.money = inst.money end
end

local old_preload = inst.OnPreLoad --旧的预加载
inst.OnPreLoad = function(inst,data)--预加载函数
	if old_preload ~= nil then old_preload(inst,data) end
	if data and data.money ~=nil then inst.money = data.money end
end
```

## 写JSON文件
```lua 
TUNING.MODROOT = MODROOT..'json/gift_info.json' --文件路径
local gift_info = {
	aa=20,cc = 20
}
local f = io.open(TUNING.MODROOT,"w")
if f ~= nil then
	f:write(json.encode(gift_info))
	f:close()
else
	print("无法写入信息文件")
end
----------读JSON文件
local gift_info = {}
local f = io.open(TUNING.MODROOT,"r")
if f ~= nil then
	local content = f:read("*all")
	f:close()
	local info = json.decode(content)
	if info then
		gift_info = info
	else
		print("解码信息文件时出错")
	end
end
```

## 计算函数执行的时长
```lua 
local startTime = os.clock()
local endTime = os.clock()
print("执行时长："..tostring(endTime - startTime))
```

## 获取预设按钮的大界面(鼠标移入然后触发 接收物品的效果)
```lua 
operationInterface.getPresetsButton = operationInterface:AddChild(ImageButton(TUNING.CHHDATA.UI.ASSET..'chh_allBlack.xml','chh_allBlack.tex'))
operationInterface.getPresetsButton:SetPosition(-5, -10) --偏移
operationInterface.getPresetsButton:SetScale(5.35,5,5)--设置大小
operationInterface.getPresetsButton.scale_on_focus = false --鼠标移入的时候不会放大图片了
operationInterface.getPresetsButton.move_on_click = false --鼠标点击后不会有下降的效果了
operationInterface.getPresetsButton:SetFadeAlpha(0.5, nil) ----设置透明度【参数2，为nil时，子体同步设置】
operationInterface.getPresetsButton.OnControl = function(self, control, down) -- down为true是按下 down为false是弹起  一共触发俩次
	if not down then
		local inventory = ThePlayer.components.inventory --  ThePlayer.replica.inventory 客机是这样的
		local activeitem = inventory.activeitem --  inventory:GetActiveItem() 客机是这样的
		local inventoryitem_replica = activeitem and activeitem.replica.inventoryitem
		if activeitem and activeitem.prefab then
		--inst.replica.inventoryitem:GetAtlas() 获取预设的xml  :GetImage() 获取tex
			operationInterface.PrefabImg:SetTexture(inventoryitem_replica:GetAtlas(),inventoryitem_replica:GetImage(),'axe.tex')
			inventory:GiveItem(activeitem)--把东西放回空格里
			inventory:SetActiveItem(nil)--鼠标置空 配合上面
		end
	end
end
```


## 添加克劳斯背包建造
```lua 
AddRecipe("klaus_sack", {Ingredient("redmooneye",1),Ingredient("bluemooneye",1),Ingredient("silk",8)}, RECIPETABS.MAGIC, TECH.NONE,
"klaussack_placer", --placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
"achiveking", -- builder_tag
"images/inventoryimages/klaussack.xml", -- atlas
"klaussack.tex") -- image
-- 可以定义 terra_prisma = AddRecipe 然后排序配方位置 如果俩个mod都设置了0 那么 谁后读取谁在先
terra_prisma.sortkey = 0
```

## 实体创建
```lua 
local function createEntity(name)
	local function fn()
		local inst = CreateEntity() --生成实体 定义inst这个变量，初始化，创造这个物体
		inst.entity:AddTransform() --变换组件 Transform负责的是 实体的大小，位置，形状等等。
		inst.entity:AddAnimState() --动画组件 AnimState负责 实体 的 动画效果，颜色滤镜等等。
		inst.entity:AddNetwork() --网络组件 --其他人才能看到

		MakeInventoryPhysics(inst) --制造物理

		inst.AnimState:SetBank(name)  --地上动画
		inst.AnimState:SetBuild(name) --smcl文件的名字
		inst.AnimState:PlayAnimation(name.."01") --丢地上的动画 anim

		inst:AddTag("manghe") --标签

		MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9) --使库存可浮动

		inst.entity:SetPristine() -- 执行之前的内容都是运行在主机和客机上的
		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("named") --名字组件
		inst:AddComponent("tradable") --可交易
		inst:AddComponent("inspectable") --可检查
		inst:AddComponent("inventoryitem")--可库存
		inst.components.inventoryitem:SetSinks(false)
		--背包默认贴图，防贴图丢失，背包无贴图材质
		inst.components.inventoryitem.imagename = name --图像,像素大小64*64
		inst.components.inventoryitem.atlasname = "images/shop/"..name..".xml" --图集

		MakeHauntableLaunch(inst)
		-- MakeHauntableLaunchAndIgnite(inst)--能够被闹鬼
		return inst
	end
	return Prefab(name, fn, assets)
end
```
## 添加行为
```lua 
---------------添加行为----------部分来自青木字典------------------------
--详细介绍 https://www.zybuluo.com/longfei/note/600841

SCENE = --args: inst, doer, actions, right					--场景
USEITEM = --args: inst, doer, target, actions, right		--使用项目
POINT = --args: inst, doer, pos, actions, right				--地面
EQUIPPED = --args: inst, doer, target, actions, right		--装备  EQUIPPED动作是在你让某个特别的物品被装备时激活。例子：装备火把可以激活点火动作，装备铥矿斧可以砍树，装备武器可以攻击。
INVENTORY = --args: inst, doer, actions, right				--库存  INVENTORY动作可以通过右键点击物品栏执行。例子有吃东西，装备物品，治疗等等。
ISVALID = --args: inst, action, right						--是有效的
--[[ SCENE
使用变量inst(拥有这个组件的东西），doer（做这个动作的玩家）,actions（你添加的动作会被添加到哪张动作表中去，这个参数一般会在函数参数表的尾端。译者注：如果有right的话，在right前面)，right（是否是一个右键点击动作)
SCENE动作是通过点击一个在物品栏或者世界上物品来完成的。拥有这个组件动作的这个东西，让自己能够被点击从而执行动作，这一点与USEITEM和EQUIPPED相反，它们是让你能够点击在你的鼠标所指向的物品，或者物品栏的物品来执行动作。一个例子是收集作物这个动作。
译者注：这里补充几句。edible这个组件，是物品可食用的组件。这个组件没有SCENE 这个组件动作搜集器，只有USEITEM 和 INVENTORY。所以，你不能把食物放在地上，然后右键点击吃掉它（除了woodie的海狸形态，那个比较特殊，这里略过不谈）。要吃掉食物，你只能左键拿起食物，然后对着人点击鼠标，或者把食物放到物品栏里，右键点击。SCEN则就是，你能直接点击它然后完成对应动作。
]]
--[[ USEITEM
使用变量 inst,doer,target(被点击的东西），actions和right。USEITEM动作是这样的，你拿起这个物品（译者注：拥有这个组件动作的物品），去对着世界上的某些其它的物品，就可以激活该动作，按下去就会执行这个动作，典型的例子就是拿起燃料往火坑里添火。
]]

--[[ POINT
使用变量inst,doer,pos（被点击的位置)，actions和right。POINT动作可以被很多东西激活（装备一个手持物品（其它部位不行），或者将一个物品拿起来（附在鼠标上）），但这是唯一一种对着地面而不是一个具体的物体作为变量的动作。典型的例子有deployable组件--种植东西以及放置陷阱。另一个例子则是橙宝石法杖（闪现）
]]
----------------------
local tp_action = AddAction("SOULMATETP", "传送戒指", function(act)
	if act.invobject and act.invobject.components.soulteleporter then
        return act.invobject.components.soulteleporter:TeleportAction(act.doer)
    end
end)

AddComponentAction("INVENTORY", "soulteleporter", function SetupTeleportActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.SOULMATETP)
end)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.SOULMATETP, "give"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.SOULMATETP, "give"))
------------其他动作例子
local CHH_XIUFU = Action()
CHH_XIUFU.id = "CHH_XIUFU"
CHH_XIUFU.str = "修复"
CHH_XIUFU.priority = -100 -- 设置动作优先级 这里数字越高越优先
CHH_XIUFU.fn = function(act)
	--doer 就是动作的执行方，target 就是动作的目标 invobject 就是动作执行时对应的物品  pos 就是动作执行的地点，对地面执行的动作会用到这个数据
	if act.doer ~=nil and act.invobject ~=nil then
		print('成功')
		return true
	end
	print('失败')
	return false
end
 --定义完动作后，要通过这个函数来将定义好的动作添加到游戏当中去
AddAction(CHH_XIUFU)

--因为联机版玩家有两个SG——wilson和wilson_client，所以要设定两个  dolongaction  是一个动作 通过State定义  具体有哪些可用的可以看文件SGwilson
--give给  手动执行动画（客机）  ThePlayer.sg:GoToState("dolongaction")
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(CHH_XIUFU, "dolongaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(CHH_XIUFU, "dolongaction"))
-- 在 USEITEM 中的 inventoryitem 组件生效
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)  --这个函数只有需要显示的时候会判定 不会初始化加载
	-- 只在玩家 和 目标有装备耐久 物品耐久的情况出现动作
	if doer:HasTag("player") and target ~=nil and (target.components.armor ~= nil or target.components.equippable ~= nil ) then
		table.insert(actions, GLOBAL.ACTIONS.CHH_XIUFU)
	end
end)

--修改动作名称的例子 XXXX为动作
ACTIONS.XXXX.stroverridefn = function(buff)
	local act = buff and buff.action or nil
	if act and buff.invobject and buff.target then
		return string.format('尝试使用【%s】修复【%s】', buff.invobject:GetDisplayName(), buff.target:GetDisplayName())
	end
	return "修复？"
end
------------文件路径------------
--   script\entityscript  --实体方法定义
--   screens\redux\lobbyscreen --选人界面列表
--   scripts\componentactions   动作类型
--  buffredaction --客机的动作文件
------------
```



