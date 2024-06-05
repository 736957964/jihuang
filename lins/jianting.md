>   随笔-监听

```lua 
inst:PushEvent("qm_cc", {q = "1", m = inst, cc = 9}) --推动事件给监听器 { } 里面是一张表 用来给监听接收数据的
inst:RemoveEventCallback("eyeturret_down",getid2) --移除监听的
inst:ListenForEvent("attacked",function(inst,data)  end) --攻击事件
picker.components.combat:GetAttacked(inst, TUNING.CACTUS_DAMAGE)--被攻击 TUNING.CACTUS_DAMAGE为伤害
picker:PushEvent("thorns")--推送荆棘事件
inst:ListenForEvent("enterlimbo", czqlin) --背包拿起的时候会触发一次  装备的时候又触发一次
inst:ListenForEvent("exitlimbo", czqlout)-- 容器里拿起的时候触发一次  丢弃的时候会触发俩次
inst:ListenForEvent("consumeingredients", inst.onitembuild, owner) --绿护符 材料减半的功能
"onhitother",       --攻击后  target 攻击者,damage (damage.target)被攻击目标,damageresolved,stimuli,weapon,redirected
"onattackother",    --攻击前
stacksizechange --物品堆叠数量改变的时候
ms_playerdespawn --玩家下线的时候触发 --请注意 单人也许会失效（可能是主机的原因？）
death --死亡 推送后会挂掉
working
worked --砍树事件（工作）
workfinished
finishedwork
TheWorld:PushEvent('plantkilled')
armordamaged -- 甲掉耐久了
armorbroke --甲破了 在 组件armor中
equip--装备
picksomething --捡东西
oneat--吃东西的监听
builditem--制作东西（制作东西在包里的） data.item（.prefab） 里面有很多表数据  inst代表制作人本身
buildstructure--制作东西（修建建筑放地上的时候） data.item（.prefab） 里面有很多表数据 inst代表制作人本身
ontalk --说话开始    播放声音
donetalking --说话结束  停止声音
onbuilt
deployitem -- 监听在部署后触发（包里的东西放置）  data 中只有一个prefab名称 为建造之前的物品名称  inst代表部署人本身
dropitem --掉落物品
onmissother -- ？
epicscare --震颤？
hostileprojectile--敌方投掷物？
firedamage --火灾伤害？
startfiredamage --开始火灾伤害？
onremove --删除
saltlick_placed --放置？
onremoved--已删除
onpickup --捡取
setowner --设置 所有者
nightvision --夜视
phasechanged--相位改变
moonphasechanged2 --月相变化2
weathertick--风标
screenflash --屏幕显示
seasontick--季节记号
playeractivated --已经激活的播放器
playerdeactivated --播放器停用
overrideambientlighting --高架照明
continuefrompause--继续拖延？

respawnfromghost--从鬼魂中复活
ms_playerjoined--女士加入了
cycleschanged--周期更改（一天过去的时候）

locomote --运动
performaction--执行操作？
unequip--？打击？

itemget--?项目获取 --防止早晨送礼包导致的无敌失效 :GiveActiveItem(inst)	推送的
changeclothes--换衣服
percentusedchange--使用百分比更改
isfightingdirty --？打架？
timerdone --定时器
blocked-- 阻碍？
childgoinghome --回家？ 蜜蜂回家 beebox
enterlight--入口照明
enterdark--进入黑暗
entitysleep--实体随眠
entitywake --实体唤醒

nignite--点燃的时候
animover--？运动
onwenthome--回家？ 浆果从  好像是火鸡的
spawnperd--预设
newcombattarget--新作战目标
onputininventory--清空库存？
ondropped--掉落 物品栏掉下来的时候会触发这个 (猪 拉屎好像也会)
temperaturedelta--温度增量
burntup--燃烧
suggest_tree_target--？
moonpetrify--月亮石化
moontransformed--月亮变化
onextinguish --熄灭？
healthdelta --健康
healthdirty -- 健康？
hungerdelta --饥饿
hungerdirty
sanitydelta--脑力值
sanitydirty
werenessdelta--？
consumehealthcost --消耗治疗成本
learnrecipe --学习食谱
learnmap --学习地图
repair --修理的时候
performaction--表演？
actionfailed --操作失败
carefulwalking --小心行走 （企鹅 应该是）
wormholetravel --虫洞旅行
makefriend--交朋友 应该是猪人的
feedincontainer --容器？ 好像是喂食
houndwarning--猎犬警告
istakingfiredamagedirty--是否有火灾损坏
istakingfiredamagelowdirty--是否火伤严重
werenessdirty--？
temperaturedirty--温度湿度
moisturedirty--湿度
techtreesdirty --树木砍伐？
recipesdirty--食谱
bufferedbuildsdirty--建筑装饰
isperformactionsuccessdirty--表演成功？
pausepredictionframesdirty --停止播放声音
itemplanted 种植的植物
onwakeup --唤醒的时候



-- print("玩家id="..inst.userid)
		-- print("玩家分类="..inst.player_classified)	 a table value
		-- print("玩家颜色="..inst.playercolour) a table value
		-- print("共同任务="..inst.jointask) a table value
		-- print("衣柜弹出窗口="..inst.ShowWardrobePopUp) a function value
		-- print("灯="..inst.Light) a userdata value
		-- print("移动实体="..inst.OnRemoveEntity) a function value
		-- print("pendingtasks="..inst.pendingtasks) a table value
		-- print("ShowHUD="..inst.ShowHUD) a function value
		-- print("ShowGiftItemPopUp="..inst.ShowGiftItemPopUp) a function value
		-- print("sg="..inst.sg)
		-- print("IsHUDVisible="..inst.IsHUDVisible)
		-- print("ApplyScale="..inst.ApplyScale)
		-- print("SetGhostMode="..inst.SetGhostMode)
		-- print("ShowActions="..inst.ShowActions)
		-- print("OnWakeUp="..inst.OnWakeUp)
		-- print("Transform="..inst.Transform)
		-- print("actionreplica="..inst.actionreplica)
		-- print("event_listening="..inst.event_listening)
		-- print("actioncomponents="..inst.actioncomponents)
		-- print("_hermit_music="..inst._hermit_music)
		-- print("GetMaxMoisture="..inst.GetMaxMoisture)
		-- print("CanUseTouchStone="..inst.CanUseTouchStone)
		-- print("updatecomponents="..inst.updatecomponents)
		-- print("ShakeCamera="..inst.ShakeCamera)
		-- print("OnDespawn="..inst.OnDespawn)
		-- print("persists="..inst.persists)
		-- print("MiniMapEntity="..inst.MiniMapEntity)
		-- print("是否冰冻="..inst.IsFreezing)

	animstate的所有方法
OverrideShade
SetFinalOffset
SetSymbolExchange
SetOrientation
GetSortOrder
GetInheritsSortKey
SetSortOrder
SetClientSideBuildOverrideFlag
SetBloomEffectHandle
GetSkinBuild
SetDepthBias
SetDepthTestEnabled
CompareSymbolBuilds
ClearOverrideBuild
Show
OverrideSkinSymbol
AssignItemSkins
SetSortWorldOffset
OverrideItemSkinSymbol
SetMultColour
SetHaunted
GetCurrentAnimationTime
ClearAllOverrideSymbols
SetOceanBlendParams
PushAnimation
GetMultColour
SetPercent
SetAddColour
ClearBloomEffectHandle
SetBank
GetCurrentFacing
SetBankAndPlayAnimation
GetAddColour
HideSymbol
SetLayer
SetRayTestOnBB
IsCurrentAnimation
SetManualBB
SetHighlightColour
Hide
ClearOverrideSymbol
GetSymbolOverride
GetCurrentAnimationLength
Pause
Resume
SetDeltaTimeMultiplier
ShowSymbol
SetDepthWriteEnabled
ClearSymbolExchanges
OverrideSymbol
GetSymbolPosition
OverrideMultColour
SetClientsideBuildOverride
FastForward
SetBuild
SetScale
SetFloatParams
SetMultiSymbolExchange
SetErosionParams
GetBuild
BuildHasSymbol
AnimDone
IsSymbolOverridden
GetCurrentAnimationFrame
AddOverrideBuild
SetInheritsSortKey
PlayAnimation
SetTime
SetLightOverride
SetSkin
```


