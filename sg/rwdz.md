>  随笔-sg

人物动作
-------------------
```lua
-- ThePlayer.sg:GoToState("changeoutsidewardrobe")
	ThePlayer.sg:GoToState("hop_master")	--跳起来
	ThePlayer.sg:GoToState("parry_hit")		--拿武器格挡
	ThePlayer.sg:GoToState("shell_hit")		--躲进蜗牛壳
	ThePlayer.sg:GoToState("pinned_hit")	--被打一下并下蹲一下
	ThePlayer.sg:GoToState("hit_darkness")	--黑夜攻击
	ThePlayer.sg:GoToState("electrocute")	--被电攻击
	ThePlayer.sg:GoToState("startle")	--往左下蹲	
	ThePlayer.sg:GoToState("repelled")	--往左下蹲
	ThePlayer.sg:GoToState("parry_knockback")	--拿武器格挡
	ThePlayer.sg:GoToState("knockbacklanded")	--反U型弯腰挑起
	ThePlayer.sg:GoToState("knockback")		--高空落地
	ThePlayer.sg:GoToState("hit_souloverload")	--看着也像是被攻击一下，声音不一样
	ThePlayer.sg:GoToState("mindcontrolled")	--迷糊晕搓脸
	ThePlayer.sg:GoToState("heavylifting_start")	---双手有点像划船
	ThePlayer.sg:GoToState("heavylifting_item_hat")	---单手有点像划船
	ThePlayer.sg:GoToState("item_out")	--应该是拿起武器吧
	ThePlayer.sg:GoToState("item_hat")	--脱下装备
	ThePlayer.sg:GoToState("heavylifting_stop")	--下蹲抓起
	--ThePlayer.sg:GoToState("corpse")	--趴在地上-有BUG
	ThePlayer.sg:GoToState("death")		--死亡
	ThePlayer.sg:GoToState("talk")		--说话
	ThePlayer.sg:GoToState("mime")		--小丑无声动作
	ThePlayer.sg:GoToState("powerup")	--大力士吃饱跳起来
	ThePlayer.sg:GoToState("powerdown")	--大力士变饿了
	ThePlayer.sg:GoToState("sink")		--动了一会，真掉进水里，还会死
	ThePlayer.sg:GoToState("sink_fast")	--直接掉水死，真掉进水里，还会死
	ThePlayer.sg:GoToState("armorbroke")	--破甲被攻击动作
	ThePlayer.sg:GoToState("fishing_pst")	--收鱼竿动作
	ThePlayer.sg:GoToState("knockout")		--倒地睡觉
	ThePlayer.sg:GoToState("yawn")			--打哈欠
	--ThePlayer.sg:GoToState("frozen")		--被打
	ThePlayer.sg:GoToState("pinned_pre")	--偏一旁侧着身子动了一下
	ThePlayer.sg:GoToState("refuseeat")		--女武神不吃蔬菜动作
	ThePlayer.sg:GoToState("opengift")		--领取礼包，拿出礼包又收回
	ThePlayer.sg:GoToState("dismount")		--不见了隐身，应该是草丛帽
	ThePlayer.sg:GoToState("spooked")		--不见了隐身，应该是草丛帽
	ThePlayer.sg:GoToState("funnyidle")		--疑惑摸脑袋
	ThePlayer.sg:GoToState("shake")			--不见了隐身，应该是草丛帽
	ThePlayer.sg:GoToState("chop")			--砍树动作
	ThePlayer.sg:GoToState("item_out")		--拿换东西
	ThePlayer.sg:GoToState("thaw")		--冰冻住
	ThePlayer.sg:GoToState("construct")		--打开礼物
	ThePlayer.sg:GoToState("constructing")		--打开礼物持续
	ThePlayer.sg:GoToState("startchanneling")		--抚摸沙之球
	ThePlayer.sg:GoToState("till_start")		--锄头挖地
	ThePlayer.sg:GoToState("till")		--锄头挖地
	ThePlayer.sg:GoToState("portal_jumpin")		--红色从地下钻进去再从天上落下
	ThePlayer.sg:GoToState("portal_jumpout")		--红色从天上落下
	ThePlayer.sg:GoToState("form_log")		--像是再扯绷带
	ThePlayer.sg:GoToState("furl_boost")		--拉风帆会崩溃
	ThePlayer.sg:GoToState("multithrust")		--多重连击
	ThePlayer.sg:GoToState("multithrust_pre")		--多重连击
	ThePlayer.sg:GoToState("combat_lunge_start")		--抬手武器转圈
	ThePlayer.sg:GoToState("forcetele")		--额黑屏
	ThePlayer.sg:GoToState("quicktele")		--打击动作
	ThePlayer.sg:GoToState("quickcastspell")		--打击动作2
	ThePlayer.sg:GoToState("castspell")		--释放法杖动作
	ThePlayer.sg:GoToState("exittownportal")		--身体变小在慢慢变大
	ThePlayer.sg:GoToState("exittownportal_pre")		--沙之石传送动作
	ThePlayer.sg:GoToState("jumpout")		--跳跃
	ThePlayer.sg:GoToState("jumpin")		--延迟跳跃
	ThePlayer.sg:GoToState("corpse_rebirth")		--倒地身体发光再起来
	ThePlayer.sg:GoToState("corpse")		--尸体倒地
	ThePlayer.sg:GoToState("reviver_rebirth")		--从灵魂状态复活
	ThePlayer.sg:GoToState("portal_rez")		--消失身体变黑，再变出来
	ThePlayer.sg:GoToState("amulet_rebirth")		--被复活项链救活
	ThePlayer.sg:GoToState("spooked")		--隐身一会就出现
	ThePlayer.sg:GoToState("tool_slip")		--手滑掉落装备
	ThePlayer.sg:GoToState("mindcontrolled_loop")		--身上黑魂爆炸
	ThePlayer.sg:GoToState("mindcontrolled")		--身上黑魂爆炸加摸头
	ThePlayer.sg:GoToState("knockbacklanded")		--跳起蹦下
	ThePlayer.sg:GoToState("knockback_pst")		--倒地爬起来
	ThePlayer.sg:GoToState("knockback")		--从空中掉地上爬起来
	ThePlayer.sg:GoToState("mount_plank")		--左右偷瞄	
	ThePlayer.AnimState:PlayAnimation("form_log")	--撸袖子
	doer.AnimState:PushAnimation("form_log", false)
	inst.AnimState:PlayAnimation("wortox_portal_jumpout")

--开的联机无地下测试的效果--人物威尔逊
--GetPlayer().sg:GoToState("attack_prop")--有洞穴应该是这个测试吧--不确定
	ThePlayer.sg:GoToState("abandon_ship")--像前跳，--船到另一个船的动作
	ThePlayer.sg:GoToState("attack_prop")--攻击道具？？？？？---从左边拉扯
	ThePlayer.sg:GoToState("bellow")--隐身--可以移动解除
	ThePlayer.sg:GoToState("bow")--鞠躬--蜂王帽子
	ThePlayer.sg:GoToState("bow", royalty)--无效，需要参数--自己去找源码看
	ThePlayer.sg:GoToState("bow_loop", { target = ThePlayer.sg.statemem.target, talktask = ThePlayer.sg.statemem.talktask })
	--鞠躬--一直持续
	ThePlayer.sg:GoToState("bow_pst")--鞠躬起身的动作
	ThePlayer.sg:GoToState("bow_pst2")--没显示
	ThePlayer.sg:GoToState("breakfree")--打破？？--像被打了一下
	ThePlayer.sg:GoToState("bucked")--不知道是什么--人直接消失了---有bug--被打动作解除frozen
	ThePlayer.sg:GoToState("bucked_post")--从天上落下
	ThePlayer.sg:GoToState("bugnet")--捕虫网的捕捉动作
	ThePlayer.sg:GoToState("cantsing")--武神的不能唱歌动作--会显示只能武神使用
	ThePlayer.sg:GoToState("cast_net_release")--抖落出一个绿色的渔网--应该是废稿
	ThePlayer.sg:GoToState("cast_net_release_pst")--抖落出一个绿色的渔网--应该是废稿
	ThePlayer.sg:GoToState("cast_net_retrieving")--拉渔网的动作--卡bug
	ThePlayer.sg:GoToState("catch")--抓的动作
	ThePlayer.sg:GoToState("catch_equip")--给予动作--出现一团红雾
	ThePlayer.sg:GoToState("catchfish")--掉起来鱼，收杆的动作
	ThePlayer.sg:GoToState("catchfish", data.build)--无效--参数自己找源码--最后应该是和上面一样的
	ThePlayer.sg:GoToState("changeoutsidewardrobe")---开礼物后选择装备刚刚得到的物品--关闭礼物盒子--然后黑手换装
	ThePlayer.sg:GoToState("channel_longaction")--一直给别人东西的动作
	ThePlayer.sg:GoToState("combat_lunge", data)--无效
	ThePlayer.sg:GoToState("combat_lunge_start")--神话的猴子棍子的特效？？？？
	ThePlayer.sg:GoToState("combat_superjump_pst", ThePlayer.sg.statemem.data)
	ThePlayer.sg:GoToState("construct")--像神话摘桃子的动作--有抬头
	ThePlayer.sg:GoToState("construct",ThePlayer:HasTag("fastbuilder"))---蹲下做东西的动作--持续
	ThePlayer.sg:GoToState("constructing")--像神话摘桃子的动作--有抬头--持续动作
	ThePlayer.sg:GoToState("cookbook_close")--烹饪书的关书动作
	ThePlayer.sg:GoToState("corpse")--熔炉里面人物死了的动作--趴地上--有bug--可以通过--被打等动作解除frozen
	ThePlayer.sg:GoToState("corpse", true)--趴地上--和上面一样的
	ThePlayer.sg:GoToState("corpse_rebirth")--熔炉复活，倒地的身体发光再起来
	ThePlayer.sg:GoToState("dig")--铲子挖动作
	ThePlayer.sg:GoToState("dolongaction")--制作物品的动作
	ThePlayer.sg:GoToState("dolongaction", .5)--后面为时间
	ThePlayer.sg:GoToState("dolongaction", slow and 2 or .5)
	ThePlayer.sg:GoToState("doshortaction", true)--放下的动作吗？
	ThePlayer.sg:GoToState("dostorytelling_loop")--讲故事的动作--卡bug
	ThePlayer.sg:GoToState("emote", data)--无效
	ThePlayer.sg:GoToState("enter_onemanband")--拉风琴动作--就是那个独奏乐器
	ThePlayer.sg:GoToState("enter_onemanband", pushanim)--无效--直接从源文件弄的--参数为nil
	ThePlayer.sg:GoToState("falloff")--不知道是什么--人直接消失了---有bug--被打动作解除frozen
	ThePlayer.sg:GoToState("fertilize")--植物人喂自己吃便便，像洗脸那样
	ThePlayer.sg:GoToState("fertilize_short")--植物人使用肥料包还是便便忘了--往肚子抹
	ThePlayer.sg:GoToState("fishing")--钓鱼动作
	ThePlayer.sg:GoToState("fishing", "bite_light_pst")--钓鱼的动作
	ThePlayer.sg:GoToState("fishing_nibble")--有鱼上钩--身体抖动的动作
	ThePlayer.sg:GoToState("fishing_pst")--收鱼竿动作
	ThePlayer.sg:GoToState("fishing_strain")--拉杆的动作--鱼往反方向跑
	ThePlayer.sg:GoToState("forcetele")--黑屏--跳虫洞的动作吧--请不要尝试--我没有想到解除办法
	ThePlayer.sg:GoToState("form_log")--植物人做活木
	ThePlayer.sg:GoToState("frozen")--被打
	ThePlayer.sg:GoToState("furl", ThePlayer.sg.mem.furl_target)--拉帆的动作--卡bug--无参数--崩溃
	ThePlayer.sg:GoToState("hammer")--锤子的动作
	ThePlayer.sg:GoToState("heavylifting_item_hat")--重物在身上的动作吧
	ThePlayer.sg:GoToState("heavylifting_start")--搬雕像等重物品的起手动作
	ThePlayer.sg:GoToState("heavylifting_stop")--搬雕像等重物品的结束动作--放下物品
	ThePlayer.sg:GoToState("helmsplitter", ThePlayer.sg.statemem.target)--熔炉的动作--火光
	ThePlayer.sg:GoToState("hit")--挨打
	ThePlayer.sg:GoToState("hit", data.noimpactsound and "noimpactsound" or nil)--挨打
	ThePlayer.sg:GoToState("hit", true)--挨打
	ThePlayer.sg:GoToState("hit_darkness")--被黑暗攻击
	ThePlayer.sg:GoToState("hit_push")--被打
	ThePlayer.sg:GoToState("hit_souloverload")--看着像被打了一下
	ThePlayer.sg:GoToState("hit_spike")--被地刺打中弯腰起来
	ThePlayer.sg:GoToState("hit_spike", data.attacker)
	ThePlayer.sg:GoToState("hop_master")--跳起来
	ThePlayer.sg:GoToState("idle")--没有事情做的时候的动作
	ThePlayer.sg:GoToState("idle", false)--没有事情做的时候的动作
	ThePlayer.sg:GoToState("idle", true)--没有事情做的时候的动作
	ThePlayer.sg:GoToState("item_hat")--帽子装备和卸下的动作
	ThePlayer.sg:GoToState("item_out")--卸下和装备工具武器的动作
	ThePlayer.sg:GoToState("jumpin")--跳进虫洞的动作吧---崩溃--请不要尝试
	ThePlayer.sg:GoToState("jumpout")--跳跃--像前跳--虫洞跳出来的动作吧
	ThePlayer.sg:GoToState("knockback")--被打抛起来，高空落地
	ThePlayer.sg:GoToState("knockback_pst")--被攻击倒地之后的站起来动作--熔炉的吧
	ThePlayer.sg:GoToState("knockbacklanded")--反U型弯腰挑起
	ThePlayer.sg:GoToState("loserod")--鱼竿被鱼拉跑了
	ThePlayer.sg:GoToState("mime")--小丑的无声动作
	ThePlayer.sg:GoToState("mindcontrolled")--中庭boss的那个控制技能，迷糊晕，搓脸
	ThePlayer.sg:GoToState("mindcontrolled_loop")--中庭boss的那个控制技能，脑残低被控制的动作
	ThePlayer.sg:GoToState("mindcontrolled_pst")--中庭boss的控制技能之后的动作
	ThePlayer.sg:GoToState("mine")--挖矿
	ThePlayer.sg:GoToState("mount_plank")---船上要跳水的动作--左右喵
	ThePlayer.sg:GoToState("mounted_idle")--闲置
	ThePlayer.sg:GoToState("mounted_idle", pushanim)--闲置
	ThePlayer.sg:GoToState("mounted_idle", true)--闲置
	ThePlayer.sg:GoToState("multithrust")--多重连击--有特效--挺帅的--
	ThePlayer.sg:GoToState("multithrust", ThePlayer.sg.statemem.target)--参数为目标吧
	ThePlayer.sg:GoToState("multithrust_pre")--多重连击--有特效--挺帅的--
	ThePlayer.sg:GoToState("oceanfishing_idle")---没有显示
	ThePlayer.sg:GoToState("oceanfishing_linesnapped", {escaped_str = "ANNOUNCE_OCEANFISHING_LINESNAP"})
	--海掉的鱼竿被拉走--说所有辛苦全被折断
	ThePlayer.sg:GoToState("oceanfishing_stop")--停止海钓
	ThePlayer.sg:GoToState("opengift")--领取礼包--拿出礼包又收回
	ThePlayer.sg:GoToState("parry_hit")--拿武器格挡
	ThePlayer.sg:GoToState("parry_idle", ThePlayer.sg.statemem.timeleft ~= nil and { duration = math.max(0, ThePlayer.sg.statemem.timeleft + ThePlayer.sg.statemem.timeleft0 - GetTime()) end end
	--上一个因为参数原因不行
	ThePlayer.sg:GoToState("parry_idle")--格挡的动作--有延迟
	ThePlayer.sg:GoToState("parry_idle", { duration = ThePlayer.sg.statemem.parrytime, pauseframes = 30, talktask = talktask })
	--无效
	ThePlayer.sg:GoToState("parry_knockback")--拿武器格挡
	ThePlayer.sg:GoToState("pinned")--被打
	ThePlayer.sg:GoToState("pinned_hit")--被打一下并蹲一下
	ThePlayer.sg:GoToState("pinned_pre")--偏一旁侧着身子动了一下
	ThePlayer.sg:GoToState("pinned_pre", data)--偏一旁侧着身子动了一下
	ThePlayer.sg:GoToState("plantregistry_close")--什么关闭--人物恢复到正经状态
	ThePlayer.sg:GoToState("play_onemanband")--独奏乐器的动作
	ThePlayer.sg:GoToState("portal_jumpin")--恶魔的灵魂跳
	ThePlayer.sg:GoToState("portal_jumpout")--恶魔的灵魂跳
	ThePlayer.sg:GoToState("portal_jumpout", ThePlayer.sg.statemem.dest)
	ThePlayer.sg:GoToState("portal_rez")--恶魔跳到目标地点后出来的动作吧--身体变黑--然后恢复正常
	ThePlayer.sg:GoToState("powerdown")--大力士饿了--也像是累了蹲起
	ThePlayer.sg:GoToState("powerdown_wurt")--大力士饿了
	ThePlayer.sg:GoToState("powerup")--大力士吃饱跳起来
	ThePlayer.sg:GoToState("powerup_wurt")--大力士吃饱跳起来
	ThePlayer.sg:GoToState("quickcastspell")--打击动作
	ThePlayer.sg:GoToState("quicktele")--打敌人的动作
	ThePlayer.sg:GoToState("refuseeat")--女武神拒绝吃蔬菜的动作
	ThePlayer.sg:GoToState("repelled")--往左下蹲
	ThePlayer.sg:GoToState("repelled", data)--无效
	ThePlayer.sg:GoToState("research")--高兴跳起的动作
	ThePlayer.sg:GoToState("research", data)--无效
	ThePlayer.sg:GoToState("reviver_rebirth")--从灵魂状态复活
	ThePlayer.sg:GoToState("run")--跑步动作
	ThePlayer.sg:GoToState("run_start")--跑步开始
	ThePlayer.sg:GoToState("run_stop")--跑步停止
	ThePlayer.sg:GoToState("shake")--隐身--这个可以移动解除
	ThePlayer.sg:GoToState("shell_hit")--躲进蜗牛壳
	ThePlayer.sg:GoToState("shell_idle", talktask)
	ThePlayer.sg:GoToState("sing")--无反应
	ThePlayer.sg:GoToState("singsong")--这个就是一直说话--没有参数
	ThePlayer.sg:GoToState("singsong", data)--无效
	ThePlayer.sg:GoToState("steer_boat_idle_loop")--掌握船舵
	ThePlayer.sg:GoToState("steer_boat_idle_loop", true)
	ThePlayer.sg:GoToState("steer_boat_turning", true)--转船舵
	ThePlayer.sg:GoToState("steer_boat_turning_pst")--转船舵
	ThePlayer.sg:GoToState("stopchanneling")--停止什么--
	ThePlayer.sg:GoToState("tackle_collide")--人物消失
	ThePlayer.sg:GoToState("tackle_start")--钻地在地下运动
	ThePlayer.sg:GoToState("tackle_stop")--停止在地下运动
	ThePlayer.sg:GoToState("talk")--说话
	ThePlayer.sg:GoToState("talk", data.noanim)
	ThePlayer.sg:GoToState("teleportato_teleport")--被黑暗之手拉到地下--单机的那个找到老麦的结局--换一个动作就可以解除ttt
	ThePlayer.sg:GoToState("toolbroke")--什么东西坏了，还有碎屑从身上掉落
	ThePlayer.sg:GoToState("toolbroke", data.tool)
	ThePlayer.sg:GoToState("transform_"..data.mode.."_person", data.cb)
	ThePlayer.sg:GoToState("transform_person")--从地上爬起来武器不掉落，镜头也会拉近
	ThePlayer.sg:GoToState("transform_were"..data.mode, data.cb)--无效
	ThePlayer.sg:GoToState("transform_were"..ThePlayer.sg.statemem.data.mode, ThePlayer.sg.statemem.data.cb)
	ThePlayer.sg:GoToState("transform_werebeaver")	--从地上爬起来武器会掉落，镜头也会拉近
	ThePlayer.sg:GoToState("transform_wereplayer", data)
	ThePlayer.sg:GoToState("wakeup")--掉水里躺地上起来--会扣血量上限--满潮湿
	ThePlayer.sg:GoToState("washed_ashore")--掉水里之后--在陆地上起来的动作
	ThePlayer.sg:GoToState("winters_feast_eat", target)--无效崩溃--不要尝试
```
