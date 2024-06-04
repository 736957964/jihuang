>   随笔,如有错误及时指出  联系2435609307
## projectile弹道
```lua 
inst:AddComponent("projectile")  --弹道组件
inst.components.projectile:SetSpeed(60) --弹道速度
inst.components.projectile:SetOnHitFn(onhit)--武器击中的时候触发自定义函数onhit
inst:ListenForEvent("onthrown", onthrown) --？？？？？ 投掷出去的时候
```
## edible 可食用组件
```lua 
inst:AddComponent("edible")--可食用组件
inst.components.edible.healthvalue = 0 --食用后健康
inst.components.edible.hungervalue = 0 --食用后饥饿
inst.components.edible.sanityvalue = 0 --食用后脑力值
inst.components.edible.foodtype = FOODTYPE.WOOD --食物类型 不知道干嘛的可以不加
inst.components.edible.woodiness = 15 --木头值 韦迪专属
inst.components.eater:SetOnEatFn(oneat)--吃的时候触发函数oneat
inst.components.eater:SetCarnivore(false) --可以吃菜（ wathgrithr）
```
## tradable 可交易组件
```lua 
inst:AddComponent("tradable")--可交易组件(可以给予别的物品的意思)
```
## stackable 可堆叠组件
```lua 
inst:AddComponent("stackable")--可堆叠组件
inst.components.stackable.stacksize  -- 当前的堆叠物品数量
inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM --堆叠数量 这里调取的是全局具体多少需要自己找
:Get():Remove() -- 消耗次数  不写默认为 1  :Remove()可以不写  不写的话 剩余最后一个的时候不会消失
```
## lootdropper 掉落组件
```lua 
inst:AddComponent("lootdropper")--设置掉落组件
inst.components.lootdropper:SetLoot(loot) --loot掉落
inst.components.lootdropper:SetChanceLootTable('deerclops')--概率掉落（设置概率表）
SetSharedLootTable('deerclops',
{
    {'bearger_fur',0.05},
})
```
## health 血量组件
```lua 
--  amount 伤害（负为扣除） overtime ？ cause（字符串）一般情况为 afflicter.prefab  ignore_invincible 忽视无敌(true) afflicter 击杀者 ignore_absorb(忽略吸收免伤 默认nil为不忽略经过减伤计算 afflicter必须有player标签)
inst.components.health:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
inst.components.health:SetInvincible(true) --设置无敌！ inst.components.health.invincible = true
inst.components.health:StartRegen(2, 30)--设置自动回血每30秒回2滴
inst.components.health:StopRegen() -- 停止再生
inst.components.health:DoFireDamage(amount, doer, instant) -- 设置火灾
inst.components.health.absorb = 0.2 --设置伤害减免20%
inst.components.health.externalabsorbmodifiers = 0.2 -- 设置防御 absorb后续可能会弃用改用 externalabsorbmodifiers
inst.components.health:SetAbsorptionAmount(0.5) --设置防御百分比（吸收量）
inst.components.hunger.hungerrate=1*TUNING.WILSON_HUNGER_RATE --设置饥饿的倍率
inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")--播放声音  WX78升级的声音
inst.components.health.maxhealth --maxhealth 血量上限 sanity 脑力值 hunger 饥饿
health:IsDead()--是死的
```
## temperature 温度组件
```lua 
inst.components.temperature.inherentsummerinsulation--耐热
inst.components.temperature.inherentinsulation--抗寒
inst.components.temperature.mintemp = 10 --最低温  maxtemp=40 最高温 math.random() <= -0.45*inst.level2/29+0.5
```
## combat 战斗组件
```lua 
inst:AddComponent("combat")
inst.components.combat.areahitrange = inst.level4*3/30 --战斗范围（AOE） math.random() <= -0.6*inst.level4/29+0.7
inst.components.combat.attackrange = ？ --攻击范围
inst.components.combat.damagemultiplier = 1+inst.level6*0.5/30--伤害倍率 math.random() <= -0.45*inst.level6/29+0.5
inst.components.combat.playerdamagepercent = TUNING.ABIGAIL_DMG_PLAYER_PERCENT--玩家损失百分比
inst.components.combat.battlecryenabled = false --战斗启用
inst.components.combat:EnableAreaDamage(true) --启用区域伤害
inst.components.combat.bonusdamagefn = bonus_damage_via_allergy --？
inst.components.combat.battlecryinterval = 16 --战斗间隔
inst.components.combat.panic_thresh = TUNING.BUNNYMAN_PANIC_THRESH --惊慌失措
inst.components.combat.defaultdamage = TUNING.COOKIECUTTER.DAMAGE --默认伤害
inst.components.combat.hiteffectsymbol = "body" --被攻击的位置
inst.components.combat:SetDefaultDamage(5) --设置默认伤害 (可以做到命中修改目标的伤害)
inst.components.combat:SetRange(TUNING.ANTLION_CAST_RANGE)--3, 4 --设置范围
inst.components.combat:SetAttackPeriod(TUNING.ANTLION_MAX_ATTACK_PERIOD)--设置攻击周期 攻速
inst.components.combat:SetRetargetFunction(3, RetargetFn)--设置重定目标函数
inst.components.combat:SetKeepTargetFunction(KeepTargetFn)--保留目标函数
inst.components.combat:SetOnHit(OnHit)--设置击中的时候？
inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/deciduous/drake_hit")--设置伤害声音
-- inst:ListenForEvent("attacked", OnAttacked)
inst.components.combat:SetTarget(data.attacker) --设定目标   --只针对玩家且 sg状态不是 hiding 的 target.sg:HasStateTag("hiding")
-- target 攻击目标, range 范围 , fn 触发的函数, maxnum 最大的共享目标数量, musttags
inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5) --共享攻击目标
target.components.combat.target = nil --目标的目标为nil  --目标是怪物，怪物的目标是你，为nil，怪物不打人了，丧失攻击行为

Combat:StopTrackingTarget(target) --停止攻击目标 清掉了 enterlimbo onremove 监听
```
## locomotor 移动组件
```lua 
inst.components.locomotor.walkspeed =  math.abs (8+inst.level5*0.1) --math.abs绝对值 步行速度  math.random() <= -0.6*inst.level5/29+0.7
inst.components.locomotor.runspeed  =  math.abs (10+inst.level5*0.1)--奔跑速度
inst.components.locomotor:SetExternalSpeedMultiplier(inst,"mounted_mightiness",2) --设置外部方法 currentspeedspeed 速度倍率（可叠加！） mounted_mightiness 伤害倍率？ sandstorm 沙暴中的行走速度  spawning产卵速度  ghostlyelixir鬼魂速度？c_speedmult？ haunted_speedpot闹鬼的速度？ softstop?
local speed_mod = Remap(pct, 1, 0, TUNING.MIN_GROGGY_SPEED_MOD, TUNING.MAX_GROGGY_SPEED_MOD)
inst.components.locomotor:SetExternalSpeedMultiplier(inst, "grogginess", speed_mod) --grogginess眩晕 ？
local mult= math.clamp(mult, 0, 1) --返回限制在 min 和 max 范围内（含首尾）的 mult。
inst.components.locomotor:SetExternalSpeedMultiplier(inst, "carefulwalking", mult) --carefulwalking 小心行走倍率？
inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "carefulwalking", mult) --移除添加的倍率
local debuffkey = inst.prefab
target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, TUNING.SLINGSHOT_AMMO_MOVESPEED_MULT)--弹弓子弹移动速度倍增？看不懂先放着
```
## saddler 鞍具的组件
```lua 
inst:AddComponent("saddler")
```
## saddler 鞍具的组件
```lua 
inst:AddComponent("saddler")
```
## pickable 采集组件
```lua 
inst.components.pickable.quickpick = true --开启快采 记得注意写保护
inst.components.pickable:MakeBarren()--使得贫瘠 注意写保护
```

## workable 可铲除组件
```lua 
inst:AddComponent("workable")--可铲除的（草 树都算）
inst.components.workable:SetWorkAction(ACTIONS.DIG)--设置工作动作
inst.components.workable:SetOnFinishCallback(dig_up)--完成后回调
inst.components.workable:SetWorkLeft(1)--设置剩余工作次数  math.clamp(work or 10, 1, self.maxwork) 这里设置不会超出maxwork 
inst.components.instrument.range = TUNING.HORN_RANGE --工具范围
inst.components.instrument:SetOnHeardFn(HearHorn)--工具回调
TheInput:GetWorldEntityUnderMouse().components.workable:Destroy(ThePlayer)--判断workleft > 0然后 WorkedBy(destroyer, self.workleft)
--触发 ShouldRecoil(worker, tool, numworks)  WorkedBy_Internal(worker, numworks)  numworks 就是self.workleft
target.components.workable:WorkedBy(worker, numworks)

:SetShouldRecoilFn(fn) -- local recoil, remainingworks =  self.shouldrecoilfn(self.inst, worker, tool, numworks) 工作物体 操作人 工具 剩余工作次数
:ShouldRecoil(worker, tool, numworks) -- 自己翻 返回格式 return false or true, numworks or 0
-- numworks默认1 worker:PushEvent("working"   self.inst:PushEvent("worked"
-- workleft <=0   self.inst:PushEvent("workfinished"   worker:PushEvent("finishedwork"  有 plant 和没有 burnt 并且不是  diseaseable:IsDiseased()  会世界推送 plantkilled
:WorkedBy_Internal(worker, numworks)
```
## talker 说话组件
```lua 
inst:AddComponent("talker")
:Chatter(strtbl, strid, time, forcetext) -- 不停的唠叨
-- script说话语句 time 持续时间默认3 noanim, force, nobroadcast, colour 颜色 text_filter_context, original_author_netid
:Say(script, time, noanim, force, nobroadcast, colour, text_filter_context, original_author_netid)
```
## finiteuses 耐久组件
```lua 
inst:AddComponent("finiteuses") --添加耐久组件
inst.components.finiteuses:SetMaxUses()--设置武器耐久最大值
inst.components.finiteuses:SetOnFinished(inst.Remove) --设置完成后移除(必须是耐久用完才触发)  也可以是调用别的函数
inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)--设置消耗？
inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 3)
inst.components.finiteuses:SetMaxUses(1)--设置最大使用次数
inst.components.finiteuses:SetUses(TUNING.HORN_USES) -- 设置当前的可使用次数
inst.components.finiteuses:Use(1) -- 设置使用次数   要写在阅读后触发 别写在初始化里面
inst.components.finiteuses:SetPercent(inst.components.finiteuses:GetPercent())--设置百分比--获取百分比
inst.components.finiteuses.current = (a + inst.components.finiteuses.current) --现有耐久
inst.components.finiteuses.total --全部耐久  通常用来设置全部的百分比 （总使用次数）
```
## equippable 装备组件
```lua 
inst:AddComponent("equippable")
inst.components.equippable.dapperness = 10 / 60 --60秒里面回复10点san值  帧刷
inst.components.equippable:SetOnEquip(onequip) --装备被装备的时候触发  如果自己写会覆盖原有的函数 所以最好使用监听事件 inst:ListenForEvent("equipped", czqlin)  --装备的时候触发
inst.components.equippable:SetOnUnequip(onunequip) --装备卸下时候触发 如果自己写会覆盖原有的函数 所以最好使用监听事件 inst:ListenForEvent("unequipped", czqlout)--武器卸下 因为监听只传了武器本身如果需要获取人物 可以用 inst.components.inventoryitem.owner --获取库存项目的主人
inst.components.equippable:SetOnPocket(onequip) -- 放进包里的时候 拿起物品也算触发这个函数   （装备卸下到包里的时候,俩个同时触发）
inst.components.equippable.equipslot = EQUIPSLOTS.BODY -- 插槽位置 可以身体 头 这些部位 具体要查 这里设置的是身体  不设置默认为手？
inst.components.equippable.walkspeedmult = TUNING.PIGGYBACK_SPEED_MULT * 2 --装备后的步行速度
inst.components.equippable.equipstack = true  --装备可叠加 类似吹箭
inst.components.equippable.is_magic_dapperness = true
inst.components.equippable.insulated = true
inst.components.equippable.restrictedtag = "bernieowner" --约束标签  只有有这个标签的人才能装备   添加标签的方法：inst:AddTag('bernieowner')
```
## armor 盔甲组件
```lua 
inst:AddComponent("armor")
inst.components.armor.condition --盔甲的耐久
inst.components.armor.maxcondition--耐久的最大值
inst.components.armor:SetCondition(inst.components.armor.condition +1)--设置耐久值
inst.components.armor:InitCondition(TUNING.ARMORBRAMBLE, TUNING.ARMORBRAMBLE_ABSORPTION)--设置初始参数 第一个参数是耐久 第二个参数是减伤比例
inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)
inst.components.armor.ontakedamage = OnTakeDamage --遭受损害的时候触发函数（函数里写的获取库存主人然后扣san）
inst.components.armor:SetTags({ "bee" }) --设置一个标签
inst.components.armor.indestructible -- 无法损坏  inst:AddTag("hide_percentage") 隐藏耐久显示
:GetPercent -- 获取百分比 self.condition / self.maxcondition
:SetPercent -- 设置百分比
inst.components.armor:SetPercent(inst.components.armor:GetPercent())--设置百分比--获取百分比
```
## tool 工具
```lua 
inst:AddComponent("tool")
inst.components.tool:SetAction(ACTIONS.CHOP, 1.33)
```

## weapon 武器组件
```lua 
inst:AddComponent("weapon") --武器组件
inst.components.weapon:SetDamage(100)--设置伤害  .damage获取伤害
inst.components.weapon:SetRange(28, 30)--设置范围 攻击
inst.components.weapon:SetProjectile("ice_projectile")--弹道 冰球 fire_projectile
inst.components.weapon.onattack = onattack --武器轨道？
inst.components.weapon.attackwear = 3 --攻击磨损
inst.components.weapon:SetOnAttack(onattack) --发动攻击的时候触发函数
inst.components.weapon:SetOnProjectileLaunched(OnProjectileLaunched) --设置投掷的时候？ 需要设置弹道为Nil？
inst.components.weapon:SetProjectileOffset(1)-- 射弹偏移量
```

## trader 接收物品(交易组件)
```lua 
inst:AddComponent("trader") --可接收组件
inst.components.trader:SetAcceptTest(AcceptTest) --接收物品的时候触发 inst,give,item  本体 给的物品 和给的人
inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)--设置能够接收的物品 一共三个参数 接受道具的物品 给过来的物品 和给的人物
inst.components.trader.onaccept = OnGivenItem --接受后触发 onaccept 情况下第一个参数的本体 第二个是人物 第三个是给过来的物品
inst.components.trader.onrefuse = OnRefuseItem --拒绝后触发
inst.components.trader.acceptnontradable = true --不可接收为true  啥都改成能给了 不要傻乎乎的一个个自己去设置了
inst.components.trader.deleteitemonaccept = true --删除项目 给过去的时候其实目标是会存储物品的（有存储组件） ——给猪怪物肉会自己再拿出来吃 给猪王就会删除
inst.components.trader:Disable() --禁用接收
inst.components.trader:Enable() --启用接收
```

## inventoryitem 存储栏组件
```lua 
inst.replica.inventoryitem:GetAtlas()-- 获取预设的xml  :GetImage() 获取tex
inst:AddComponent("inventoryitem")--可存储组件（不加这个是不能拿进背包的）
inst.components.inventoryitem.cangoincontainer = true --是否可以放在背包（设置可以捡 能在背包存储的意思）
inst.components.inventoryitem.canonlygoinpocket = true --是否只能放在口袋里(不能放背包)
inst.components.inventoryitem.canbepickedup = false --可选取改为false
inst.components.inventoryitem.canbepickedupalive = false --可选取活的改为false
inst.components.inventoryitem.onpickupfn = onpickupfn --被捡取的时候触发 onpickupfn(inst,pickupguy) inst 捡取的东西  pickupguy为捡取的人 （注意 如果是装备上去那么不会触发这个函数）
inst.components.inventoryitem.owner --获取库存项目的主人
inst.components.inventoryitem.trappable = true --可捕捉
self:EnableMoisture(true) --使能湿 --原理是清除添加 inventoryitemmoisture 库存物品湿度组件
self.pushlandedevents = true --是否可以推送落地监听 on_no_longer_landed 需配合SetLanded
:GetMoisture() --获取湿度  --inst.components.inventoryitemmoisture.moisture 没有组件拿的是0
:IsWet() --是否为湿的 inst.components.inventoryitemmoisture.iswet
:InheritMoisture(moisture, iswet) :DiluteMoisture(item, count)  :AddMoisture(delta) --继承水分 --稀释水分 --添加水分
:SetOwner(owner)  :ClearOwner(owner) -- 设置主人 清除主人
:GetSlotNum() --获取插槽数  容器或者库存的  container inventory
:TryToSink() --尝试下沉 掉入虚空or海里 掉落海大部分会消失 部分保存（哈奇的鱼缸，小妾的眼骨，基佬的头）
:GetContainer() --获取容器或者库存
:SetOnDroppedFn --设置下降后的fn
:OnPickup(pickupguy, src_pos) --捡取
:OnDropped(randomdir, speedmult) --使下降 如果有设置掉落的fn会触发fn（:SetOnDroppedFn）推送 ondropped  容器会有额外的监听推送onownerdropped(针对里面的物品)
inst.components.inventoryitem:ChangeImageName('backpack') --更新图片
```

## age 日期
```lua 
inst:AddComponent("age")
inst.components.age:GetDisplayAgeInDays() -- 获取存活的日期
```
## amphibiouscreature 两栖动物组件
```lua 
inst:AddComponent("amphibiouscreature") -- 比较有趣的组件可以参考一下
```

## inventory 存储组件（重要）
```lua 
attacker.components.inventory:DropItem(inst, true, true) --pickupguy:DoTaskInTime(0, function() end)  物品掉落   注意一点要设置延迟 否则崩溃 延迟0都Ok 如果不延迟那就加 attacker.components.inventory:Unequip(_G.EQUIPSLOTS.HANDS)
inst.components.inventory:Hide() --隐藏物品栏
inst.components.inventory:Has("goldnugget",count) --查找背包有没有 goldnugget 这个物品  count表示数量
inst.components.inventory:ConsumeByName("goldnugget",count)--删除背包 goldnugget 这个物品  count表示数量  可以接收参数 第一个是 是否满足条件 第二个是返回背包该物品的数量
inst.components.inventory:GiveItem(_G.SpawnPrefab('goldnugget') ) --给到背包物品
local targ = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) --获取inst中穿戴的身体部位物品 (EQUIPSLOTS.BODY)
self.itemslots = {}	--物品栏
self.equipslots = {} --装备栏
self.maxslots = GetMaxItemSlots(TheNet:GetServerGameMode())	--最大的物品栏格子的数目 :GetNumSlots() 获取格子数量，返回self.maxslots(物品栏)
self.heavylifting = false--运送重物
self.activeitem = nil--activeitem是指鼠标上的物品   ThePlayer.components.inventory.itemslots
self.opencontainers = {} --打开容器
self.dropondeath = true	--死亡掉落
:DropEverything(true)	--掉落所有东西
:EnableDropOnDeath()--使能死亡掉落 --监听事件“death”
:DisableDropOnDeath()	--使不能死亡掉落 --移除死亡掉落事件回调
:NumItems() --物品数量，返回值是物品栏放了物品的格子的数量
:TransferInventory(receiver)--转移物品，把身上所有物品（不包括背包和鼠标）转移给receiver，这个只有在PICKUP动作和MURDER动作以及鼹鼠里面才有用到
:RemoveItemBySlot(k)--RemoveItemBySlot(k)移除物品栏k位置的物品，并返回该物品
:Unequip(equipslot, slip)--卸下装备，效果大概是把装备栏中的索引为equipslot的装备删除，返回值为该装备
:GetOverflowContainer()--获取溢出容器，返回值是身上的背包之类的container组件 .inst拿到预设
--判断item物品，能不能放到slot里，slot是格子的索引，是物品栏里某一个格子  -- slot必须小于maxslots
--物品的inventoryitem组件的cangoincontainer或者ignorescangoincontainer某一个为true
--游戏模式的non_item_equips属性 和 物品的equippable组件为不为空 这两个条件不同时成立 --GetGameModeProperty函数（获取游戏模式属性）来自于gamemodes.lua，non_item_equips只有quagmire游戏模式才有
:CanTakeItemInSlot(item, slot)
:AcceptsStacks()--判断是否接受堆叠，直接返回self.acceptsstacks
:IgnoresCanGoInContainer()--直接返回self.ignorescangoincontainer
:DropActiveItem()	--掉落鼠标上的东西，返回值为掉出来的物品
:DropItem(self.activeitem) :SetActiveItem(nil)  --掉落鼠标物品（掉在脚下的）  --把鼠标置空
:IsWearingArmor()	--是不是正穿着护甲，遍历装备栏，如果装备的armor组件不为空，返回true
:ArmorHasTag(tag)	--判断身上的护甲是不是有tag标签，有返回true  条件为armor
:EquipHasTag(tag)	--判断身上的装备是不是有tag标签，有返回true
:IsHeavyLifting()	--是不是在负重，直接返回self.heavylifting
:ApplyDamage(damage, attacker, weapon)--应用伤害，是计算身上护甲减免的伤害，返回值是剩余的伤害（东西很多 具体看文件）
:GetActiveItem()--获取鼠标物品，直接返回self.activeitem
:IsItemEquipped(item)	--判断物品有没有在装备栏里，有返回其索引
:SelectActiveItemFromEquipSlot(slot)	--大概是把装备栏里第slot格的物品放鼠标上，鼠标上原来有东西的话就塞你身上，返回值是鼠标物品
:GiveActiveItem(inst)				--参数是一个物品，功能应该是把东西放到鼠标上，如果鼠标上有东西就放物品栏里，在ACTIONS.CONSTRUCT和ACTIONS.STORE动作中有用到
:SelectActiveItemFromSlot(slot)	--鼠标上的物品和物品栏里的物品交换（待测试）
:ReturnActiveItem(slot, stack_mod) --把鼠标放空 （掉落鼠标上物品）
:GetItemSlot(item) --获取物品格子，返回的是item放的物品栏的格子的索引
:IsHolding(item, checkcontainer) -- 是不是持有这个物品（待测试）
:FindItem(fn)--返回值是物品，根据fn来寻找某一个物品，包括物品栏，鼠标，背包类但 不包括装备栏
:FindItems(fn)--返回值是一个表，表里放的是要找的物品，根据fn来寻找物品，范围包括物品栏，鼠标，装备栏以及背包类
:ForEachItem(fn, ...)--对每一个物品，对身上的所有物品（范围包括物品栏，装备栏，鼠标，背包类）作为参数传给fn，并调用fn
:RemoveItemBySlot(slot)--移除物品栏第slot个格子的物品，并且返回该物品
--掉落物品，返回值是掉落的物品 推送事件 dropitem 第一个参数 拥有者 第二个参数 物品
--第三个参数 randomdir为true就随机一个角度甩出来(同时推送事件ondropped) 第四个参数坐标（没写的情况会自动获取在世界上的坐标）
:DropItem(item, wholestack, randomdir, pos)
:IsInsulated() --循环装备栏  有绝缘装备返回true（ components.equippable:IsInsulated()）
:GetEquippedItem(eslot) --取装备栏里eslot格的物品，直接返回 equipslots[eslot]
:GetItemInSlot(slot) --取物品栏里第slot格的物品，直接返回 itemslots[slot]
:IsFull() --遍历物品栏，如果每一个格子都放了东西，就返回true
:GetNextAvailableSlot(item) --找可以放得下item的格子，返回这个格子的索引以及格子种类（物品栏，装备栏，背包类） 如果找不到空格第一个参数返回nil
:CanAcceptCount(item, maxcount) --检查我们可以从一叠物品中接受多少物品（待测试）
:GiveActiveItem(inst) --把东西放到鼠标上，如果鼠标上有东西就放物品栏里 在ACTIONS.CONSTRUCT和ACTIONS.STORE动作中有用到 推送事件 itemget
--把东西塞到你身上，物品栏、装备栏、背包、鼠标，只要塞的下，就返回true，否则就返回false	（待测试,东西很多）
--如果是鼠标上的东西 一定要置空鼠标不然会有bug :SetActiveItem(nil)
:GiveItem(inst, slot, src_pos)
:Unequip(equipslot, slip)--卸下装备,把装备栏中的索引为equipslot的装备删除，返回值为该装备（待测试）
:SetActiveItem(item)--设置鼠标物品，把物品item放到鼠标上，参数为nil时就是鼠标上什么也没有 推送 newactiveitem（待测试）
:Equip(item, old_to_active)--装备，把item装备到装备栏对应的位置上，被顶下来的装备放你物品栏里，背包类的装备事件应该也在这里面（待测试,东西很多）
:RemoveItem(item, wholestack)--移除物品，就是把item从你身上去掉，返回值为这个item wholestack参数就是整组物品的意思，当wholestack为true时，移除整组物品，为false或为nil时，只移除一个
:GetOverflowContainer()--获取溢出容器，返回值是身上的背包之类的container组件
:Has(item, amount)--找身上的不包括装备栏的所有格子，然后数有多少个item 返回值有两个，第一个是item的数量有没有大于amount，第二个是找到的数量
:HasItemWithTag(tag, amount) --同上  找含有tag标签的物品数量
:GetItemByName(item, amount)--在身上的不包括装备栏的所有格子里找item，amount要找的数量  如果找到了就统计到items表里去，items表的索引是物品，值是个数，最后返回items表
:ConsumeByName(item, amount) -- 消耗amount个item 这个函数在沃托克斯的瞬移，穴居猴扔便便，还有一个叫digester的组件里用到了
:DropEverythingWithTag(tag) --扔掉身上所有带有tag的物品，包括身上带的容器里面的
:DropEverything(ondeath, keepequip)	--掉落所有物品，ondeath为false时，物品栏全掉，当keepequip为false或者nil时，装备栏也全掉
:DropEquipped(keepBackpack)	--掉装备，如果keepBackpack为false时或者没有“backpack”标签，背包也掉，伍迪变身有用，位于SGwilson.lua
:BurnNonpotatableInContainer(container)	--应该功能是把容器里含有nonpotatable标签的物品烧成灰，但是似乎没有地方有用到这个函数
:ReferenceAllItems()--查阅所有物品，但是不包括鼠标上的，返回值是包含所有物品组成的表
:IsOpenedBy(guy)--被谁打开，ACTIONS.GIVETOPLAYER、ACTIONS.GIVEALLTOPLAYER、以及ACTIONS.USEITEM有用到这个函数
:Show() :Open() :Hide() --显示 打开 隐藏物品栏
:PutOneOfActiveItemInSlot(slot)	--把鼠标上的物品中的一个，放到空的物品栏第slot格里
:PutAllOfActiveItemInSlot(slot)	--把鼠标上的所有物品放到空的物品栏第slot格子里
:TakeActiveItemFromHalfOfSlot(slot)	--拿第slot格子里一半的东西在鼠标上，应该就是按住ctrl+鼠标左键
:TakeActiveItemFromAllOfSlot(slot)    --拿第slot格子里全部东西在鼠标上
:AddOneOfActiveItemToSlot(slot)	--添加鼠标上的物品中的一个到slot格子中，同类的可以叠加的物品上去
:AddAllOfActiveItemToSlot(slot)		--添加鼠标物品上的所有到第slot格中，同类的可以叠加的物品上去，多了还是放在鼠标上
:SwapActiveItemWithSlot(slot)--把鼠标上的物品与第slot格交换
:CanAccessItem(item) --可以访问到物品，返回值是true或false，true表示可访问物品item，false表示不可访问物品item
:UseItemFromInvTile(item, actioncode, mod_name)
:ControllerUseItemOnItemFromInvTile(item, active_item, actioncode, mod_name) --？
:ControllerUseItemOnSelfFromInvTile(item, actioncode, mod_name) --？
:ControllerUseItemOnSceneFromInvTile(item, target, actioncode, mod_name)--？
:InspectItemFromInvTile(item)	--检查InvTile里的物品
:DropItemFromInvTile(item, single)	--从InvTile里掉落物品
:EquipActiveItem()	--装备鼠标物品，把鼠标上的物品放到空的装备格子里
:EquipActionItem(item)-- item为空 item取鼠标物品  武器栏没有装备 （估计是堆叠武器相关,自己翻下吧）
:SwapEquipWithActiveItem()	--用鼠标把装备放到一个已经有装备的装备格子上
:TakeActiveItemFromEquipSlot(eslot)	--从装备栏格子里拿物品到鼠标上
:TakeActiveItemFromEquipSlotID(eslotid)--根据eslotid取物品到鼠标
:MoveItemFromAllOfSlot(slot, container)--把你身上第slot格的物品放进container里，应该是整组物品吧，跟下面那个半组物品相对
:MoveItemFromHalfOfSlot(slot, container)--把你身上第slot格的物品放进container里，应该是一半物品吧
:GetEquippedMoistureRate(slot)		 --获取身上装备的潮湿度，slot为空就找装备栏，slot不为空就找物品栏slot位置，返回值有两个，第一个是当前潮湿度，第二个是最大潮湿度
:GetWaterproofness(slot)--没有传参就是直接遍历装备栏，返回装备的总防水值
:IsWaterproof() --当前防水吗，防水值大于1返回true
```
## disappears 消失组件
```lua 
inst:AddComponent("disappears")
inst.components.disappears.anim = "disappear" --消失动画设置？
inst.components.disappears.delay = delayTime --设置消失延迟时间
inst.components.disappears.sound = "dontstarve/common/dust_blowaway" --消失的声音
```

## burnable 燃烧组件
```lua 
inst:AddComponent("burnable")
inst.components.burnable:SetFXLevel(2) --特效程度？
inst.components.burnable.canlight = false --发亮？
--campfirefire fire pigtorch_flame  添加燃烧效果    生成的特效，偏移的坐标，跟随的通道（部件）， 跟班孩子？  部件 spore firefx fire_marker swap_fire
inst.components.burnable:AddBurnFX("coldfirefire", Vector3(0, 45, 0), "firefx", true) --
inst.components.burnable:SetOnIgniteFn(DefaultBurnFn) --设置点火时触发的函数
inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)--设置熄灭的时候触发的函数
inst.components.burnable:SetOnBurntFn(onburnt)--设置烧毁时候的函数
inst.components.burnable:SetBurnTime(10)--nil 设置燃烧时间
inst.components.burnable.fxprefab = nil

target.components.burnable:IsBurning()--判断是否在燃烧
target.components.burnable:IsSmoldering()--判断是否缓燃
target.components.burnable:Ignite(true) --使其点燃

SetOnStopSmolderingFn--停止缓燃的fn
SetOnSmolderingFn--开始缓燃的fn
SetBurningFX--燃烧的特效？
AddBurnFX--添加燃烧的特效
OverrideBurnFXBuild--覆盖燃烧特效构建
```

## container 容器组件
```lua 
inst:AddComponent("container")
inst.components.container:WidgetSetup("beefalo") --小装置图标设置
inst.components.container.onopenfn = onopen--打开的时候调用
inst.components.container.onclosefn = onclose--关闭的时候调用
inst.components.container.canbeopened = false --可以打开改为false
```
## book 书组件
```lua 
inst:AddComponent("book")
```
## sanity 组件
```lua 
inst:AddComponent("sanity")
inst.components.sanity.max = 200  --设置san的最大值
inst.components.sanity.current  --获取当前的san值
```
## moisture 潮湿组件
```lua 
--ps:潮湿组件官方目前只有 player_common 和dragonfly有  大部分功能需要没有 forceddrymodifiers:Get() 的情况下才会生效
--推送的监听：moisturedelta(old,new)
inst:AddComponent("moisture")
inst.components.moisture:ForceDry(true,source) --强制干燥? true为执行false不执行 source为目标 如果不写默认inst
inst.components.moisture:SetMoistureLevel() --设置湿度级别
inst.components.moisture:SetWaterproofInventory()--设置防水库存
inst.components.moisture:SetPercent--设置百分比
inst.components.moisture:SetInherentWaterproofness()--设置固有防水性
inst.components.moisture:GetMaxMoisture() --获取最大湿度
inst.components.moisture:GetMoisture() --获取湿度
inst.components.moisture:GetMoisturePercent() --获取水分百分比
inst.components.moisture:GetWaterproofInventory()--获取防水库存
inst.components.moisture:IsWet() --判断是否潮湿的 是个布尔值
-----太多了 自己去翻吧
```

## moisture 潮湿组件
```lua 
--ps:潮湿组件官方目前只有 player_common 和dragonfly有  大部分功能需要没有 forceddrymodifiers:Get() 的情况下才会生效
--推送的监听：moisturedelta(old,new)
inst:AddComponent("moisture")
inst.components.moisture:ForceDry(true,source) --强制干燥? true为执行false不执行 source为目标 如果不写默认inst
inst.components.moisture:SetMoistureLevel() --设置湿度级别
inst.components.moisture:SetWaterproofInventory()--设置防水库存
inst.components.moisture:SetPercent--设置百分比
inst.components.moisture:SetInherentWaterproofness()--设置固有防水性
inst.components.moisture:GetMaxMoisture() --获取最大湿度
inst.components.moisture:GetMoisture() --获取湿度
inst.components.moisture:GetMoisturePercent() --获取水分百分比
inst.components.moisture:GetWaterproofInventory()--获取防水库存
inst.components.moisture:IsWet() --判断是否潮湿的 是个布尔值
-----太多了 自己去翻吧
```

## blinkstaff 传送组件
```lua 
inst:AddComponent("blinkstaff")
```

## spellcaster 施法组件
```lua 
inst:AddComponent("spellcaster")
inst.components.spellcaster:SetSpellFn(SpellFn)--设置施法的fn 自带三个参数   (inst,target, pos)  本体  目标   pos 鼠标位置 可以通过 pos:Get() 获取位置
```

## AnimState 组件
```lua 
owner.AnimState:ClearOverrideSymbol("swap_body") --清除动画部件
---替换的动画部件 swap_object 胳膊 swap_hat 脑袋 swap_body 身子  第二个参数 使用的动画 第三个参数 替换的文件夹（注意这里也是文件夹的名字）
owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
owner.AnimState:Show("ARM_carry") --显示  卸载的话需要隐藏这个  ARM_carry 手    HEAD 头    swap_body 身体  HAIR 头发     HAT  帽子    HAIR_HAT 头发和帽子
owner.AnimState:Hide("ARM_normal") --隐藏 卸载的话需要显示这个  ARM_normal      HEAD_HAT   blocked        HAIR_NOHAT 头发和帽子
inst.AnimState:SetBank("spear") --地上动画
inst.AnimState:SetBuild("swap_spear") --smcl文件的名字
inst.AnimState:PlayAnimation("idle") --丢地上的动画 anim
inst.AnimState:SetSortOrder( 2 ) -- ？
inst.AnimState:SetPercent("meter", 0) -- 温度计的计数 0是红的 其他是蓝的
inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )  --设置和地面贴合（立着的会变成扁的）
inst.AnimState:SetLayer(LAYER_BACKGROUND) ---- 应该是只作用自身 （人物站上去透明度变化了）
inst.AnimState:SetMultColour(255/255,255/255,255/255,0.5) --设置物体颜色和透明度
inst.MiniMapEntity:SetIcon("backpack.png") --设置小地图上的图标
```

## Transform 
```lua 
inst.Transform:SetRotation( 135 ) --旋转角度
inst.Transform:SetScale(1.5, 1.5, 1.5) --设置大小
inst.Transform:SetTwoFaced() --二面 citters
inst.Transform:SetFourFaced() --四面
inst.Transform:SetSixFaced() --六面
inst.Transform:SetEightFaced()--八面
```
## diseaseable 患病组件
```lua 
inst:AddComponent("diseaseable")
```
