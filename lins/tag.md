>   随笔
## TAG标签
```lua 
inst:AddTag("aoeweapon_leap") --卡刀的动作
inst:AddTag("quickcast") --前倾传送动作
inst:AddTag("NOCLICK")			--不可被点击，查看
inst:AddTag("NOBLOCK")			--不可被查看	建造不会被遮挡
inst:AddTag("notarget")			--不能被作为目标
inst:AddTag("CLASSIFIED")		--增加保密标签
inst:AddTag("haunted") ---防作祟标签
inst:AddTag("hide_percentage") -- 隐藏护甲的耐久度显示
inst:HasTag("ignoretalking") --有这个标签就会忽略谈话
inst:RemoveComponent("talker")
inst:HasTag("heavy") --重物标签 （mightiness组件会判断 取消减速）
inst:AddTag("fridge") --添加冰箱标签
inst:HasTag("player") --玩家标签   幽灵标签 playerghost
inst:RemoveTag("insomniac") --移除失眠症（wickerbottom）老太太可以睡帐篷
inst:RemoveTag("monster")--韦伯不被当成怪物（webber） --即可让韦伯不被当成怪物，猪人、兔人等中立动物不会主动攻击你,当然后果是怪物比如蜘蛛就会主动攻击你了
inst:RemoveComponent('tradable') --移除可交易标签

```