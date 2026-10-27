# 所有 ACTIONS 完整列表

> 共约 150+ 个 Action，按分类整理。`*` 表示没有特殊构造函数参数。

## 基础交互动作

| Action | 参数 | 说明 |
|--------|------|------|
| `WALKTO` | `priority=-4, ghost_valid, mount_valid, encumbered_valid` | 走到目标点（最低优先级） |
| `LOOKAT` | `priority=-3, instant, distance=3, ghost_valid, mount_valid, encumbered_valid` | 查看/检视目标 |
| `TALKTO` | `priority=3, instant, mount_valid, encumbered_valid` | 与目标对话 |
| `INTERACT_WITH` | `distance=1.5, mount_valid` | 与目标交互 |
| `TRAVEL` | `*` | 旅行（通过虫洞等） |
| `JUMPIN` | `ghost_valid, encumbered_valid` | 跳入（虫洞等） |
| `JUMPIN_MAP` | `priority=HIGH, rmb, ghost_valid, encumbered_valid, map_action, closes_map` | 地图上跳入 |
| `TELEPORT` | `rmb, distance=2` | 传送（懒人法杖等） |
| `CLIMB` | `ghost_valid, encumbered_valid` | 攀爬 |
| `SITON` | `invalid_hold_action` | 坐下 |
| `COMMENT` | `distance=4` | 发表评论（表情等） |

## 物品操作动作

| Action | 参数 | 说明 |
|--------|------|------|
| `PICKUP` | `priority=1, mount_valid, extra_arrive_dist` | 拾取地面物品 |
| `DROP` | `priority=-1, mount_valid, encumbered_valid, floating_valid, is_relative_to_platform` | 丢弃物品 |
| `EQUIP` | `priority=0, instant, mount_valid, encumbered_valid, floating_valid, paused_valid` | 装备物品 |
| `UNEQUIP` | `priority=-2, instant, mount_valid, encumbered_valid, floating_valid, paused_valid` | 卸下装备 |
| `GIVE` | `mount_valid, canforce, rangecheckfn` | 给予物品 |
| `GIVETOPLAYER` | `priority=3, canforce, rangecheckfn` | 给予玩家 |
| `GIVEALLTOPLAYER` | `priority=3, canforce, rangecheckfn` | 全部给予玩家 |
| `FEEDPLAYER` | `priority=3, rmb, canforce, rangecheckfn` | 喂食玩家 |
| `STORE` | `mount_valid` | 存放物品（到容器） |
| `RUMMAGE` | `priority=-1, mount_valid` | 翻找 |
| `TAKEITEM` | `*` | 取出物品 |
| `TAKESINGLEITEM` | `*` | 取出单个物品 |
| `COMBINESTACK` | `mount_valid, extra_arrive_dist` | 合并堆叠 |
| `EMPTY_CONTAINER` | `*` | 清空容器 |
| `ACTIVATE_CONTAINER` | `priority=1, mount_valid` | 激活容器（保鲜背包等） |
| `CONTAINER_INSTALL_ITEM` | `priority=3, rmb, instant, mount_valid` | 安装物品到容器 |
| `COMPARE_WEIGHABLE` | `encumbered_valid, priority=HIGH` | 比较重量 |
| `WEIGH_ITEM` | `*` | 称重物品 |

## 采集/工作动作

| Action | 参数 | 说明 |
|--------|------|------|
| `CHOP` | `distance=1.75, invalid_hold_action` | 砍伐 |
| `MINE` | `invalid_hold_action` | 采矿 |
| `DIG` | `rmb, invalid_hold_action` | 挖掘 |
| `HAMMER` | `priority=3, invalid_hold_action` | 锤击/拆除 |
| `PICK` | `canforce, rangecheckfn, extra_arrive_dist, mount_valid` | 采集 |
| `HARVEST` | `*` | 收获 |
| `PLANT` | `*` | 种植 |
| `TILL` | `distance=0.5, theme_music=farming` | 耕地 |
| `PLANTSOIL` | `theme_music=farming` | 播种 |
| `FERTILIZE` | `priority=1, mount_valid` | 施肥 |
| `POLLINATE` | `*` | 授粉 |
| `TAPTREE` | `priority=1, rmb` | 树液采集 |
| `NET` | `priority=3, canforce, rangecheckfn` | 捕虫网捕捉 |
| `CATCH` | `priority=3, distance=math.huge, mount_valid` | 捕捉 |
| `SHAVE` | `mount_valid` | 剃毛 |
| `SCYTHE` | `rmb, distance=1.8, rangecheckfn` | 镰刀收割 |
| `GRAVEDIG` | `rmb, distance=1.8, invalid_hold_action` | 掘墓 |
| `NABBAG` | `rmb, distance=1.8, rangecheckfn` | 抓取（袋） |
| `DIVEGRAB` | `priority=3, distance=5, canforce, rangecheckfn` | 潜抓 |
| `POUNCECAPTURE` | `priority=3, distance=5, canforce, rangecheckfn` | 扑抓 |
| `SLAUGHTER` | `canforce, rangecheckfn` | 屠宰 |

## 战斗动作

| Action | 参数 | 说明 |
|--------|------|------|
| `ATTACK` | `priority=2, canforce, mount_valid, invalid_hold_action` | 攻击 |
| `CASTAOE` | `priority=HIGH, rmb, mount_valid, distance=8, invalid_hold_action` | 释放AOE |
| `CASTSPELL` | `priority=-1, rmb, distance=20, mount_valid` | 施法 |
| `CAST_POCKETWATCH` | `priority=-1, rmb, mount_valid` | 使用怀表 |
| `BLINK` | `priority=HIGH, rmb, distance=36, mount_valid, encumbered_valid` | 闪现 |
| `BLINK_MAP` | `priority=HIGH, customarrivecheck, rmb, mount_valid, encumbered_valid, map_action` | 地图闪现 |
| `HAUNT` | `rmb=false, mindistance=2, ghost_valid, ghost_exclusive, canforce, rangecheckfn` | 鬼魂作祟 |
| `MURDER` | `priority=1, mount_valid` | 谋杀（小动物） |
| `STEAL` | `*` | 偷窃 |
| `TACKLE` | `rmb, distance=math.huge, invalid_hold_action` | 冲撞 |
| `JOUST` | `rmb, distance=math.huge, silent_generic_fail` | 骑士冲锋 |
| `DASH` | `distance=math.huge, mount_valid, invalid_hold_action` | 冲刺 |
| `REMOTERESURRECT` | `rmb=false, ghost_valid, ghost_exclusive` | 远程复活 |
| `REVIVE_CORPSE` | `rmb=false, actionmeter` | 复活尸体 |
| `HEAL` | `mount_valid, extra_arrive_dist` | 治疗 |
| `REPEL` | `mount_valid` | 驱散 |
| `BEDAZZLE` | `*` | 迷惑 |
| `MUTATE` | `priority=2, invalid_hold_action, mount_valid` | 变异 |

## 建造/部署动作

| Action | 参数 | 说明 |
|--------|------|------|
| `BUILD` | `mount_valid` | 建造 |
| `DEPLOY` | `distance=1.1, mount_valid, extra_arrive_dist, invalid_hold_action` | 部署/放置物品 |
| `DEPLOY_TILEARRIVE` | `customarrivecheck, theme_music=farming` | 地块部署（耕种） |
| `DEPLOY_FLOATING` | `do_not_locomote, floating_valid, invalid_hold_action` | 水面部署 |
| `TOGGLE_DEPLOY_MODE` | `priority=HIGH, instant, mount_valid, floating_valid` | 切换部署模式 |
| `TERRAFORM` | `tile_placer=gridplacer` | 地形改造 |
| `ROTATE_FENCE` | `rmb` | 旋转栅栏 |
| `CONSTRUCT` | `priority=1, distance=2.5` | 施工 |
| `STOPCONSTRUCTION` | `priority=1, instant, distance=2` | 停止施工 |
| `APPLYCONSTRUCTION` | `priority=1, instant, distance=2` | 应用施工材料 |
| `DISMANTLE` | `rmb` | 拆卸（便携工程师） |
| `INSTALL` | `*` | 安装 |

## 火/光/燃料动作

| Action | 参数 | 说明 |
|--------|------|------|
| `LIGHT` | `priority=-4` | 点燃 |
| `EXTINGUISH` | `priority=0` | 灭火 |
| `SMOTHER` | `priority=1, mount_valid` | 闷熄火焰 |
| `MANUALEXTINGUISH` | `priority=1` | 手动灭火 |
| `ADDFUEL` | `mount_valid, paused_valid` | 添加燃料 |
| `ADDWETFUEL` | `mount_valid, paused_valid` | 添加湿燃料 |
| `STOKEFIRE` | `rmb, mount_valid, distance=8, invalid_hold_action` | 拨弄火焰 |
| `INCINERATE` | `priority=1, mount_valid` | 焚烧 |

## 海洋/航海动作

| Action | 参数 | 说明 |
|--------|------|------|
| `FISH_OCEAN` | `rmb, customarrivecheck, is_relative_to_platform, disable_platform_hopping` | 海洋钓鱼 |
| `FISH` | `*` | 钓鱼（池塘） |
| `REEL` | `instant` | 收线 |
| `OCEAN_FISHING_POND` | `*` | 海洋鱼点 |
| `OCEAN_FISHING_CAST` | `priority=3, rmb, customarrivecheck, is_relative_to_platform, disable_platform_hopping` | 海钓抛竿 |
| `OCEAN_FISHING_REEL` | `priority=5, rmb, do_not_locomote, silent_fail` | 海钓收线 |
| `OCEAN_FISHING_STOP` | `instant` | 停止海钓 |
| `OCEAN_FISHING_CATCH` | `priority=6, instant` | 海钓捕获 |
| `CHANGE_TACKLE` | `priority=3, rmb, instant, mount_valid` | 更换钓具 |
| `CAST_NET` | `priority=HIGH, rmb, distance=12, mount_valid, disable_platform_hopping` | 撒网 |
| `ROW` | `priority=3, customarrivecheck, is_relative_to_platform, disable_platform_hopping` | 划船 |
| `ROW_CONTROLLER` | `priority=3, is_relative_to_platform, disable_platform_hopping, do_not_locomote` | 手柄划船 |
| `ROW_FAIL` | `customarrivecheck, disable_platform_hopping, skip_locomotor_facing` | 划船失败 |
| `STEER_BOAT` | `arrivedist=0.1, invalid_hold_action` | 掌舵 |
| `SET_HEADING` | `distance=9999, do_not_locomote, invalid_hold_action` | 设定航向 |
| `STOP_STEERING_BOAT` | `instant` | 停止掌舵 |
| `RAISE_SAIL` | `distance=1.25, invalid_hold_action` | 升帆 |
| `LOWER_SAIL` | `distance=1.25, invalid_hold_action` | 降帆 |
| `LOWER_SAIL_BOOST` | `distance=1.25, invalid_hold_action` | 降帆加速 |
| `LOWER_SAIL_FAIL` | `distance=1.25, do_not_locomote` | 降帆失败 |
| `RAISE_ANCHOR` | `distance=2.5, invalid_hold_action` | 起锚 |
| `LOWER_ANCHOR` | `distance=2.5, invalid_hold_action` | 抛锚 |
| `EXTEND_PLANK` | `distance=2.5, invalid_hold_action` | 伸出跳板 |
| `RETRACT_PLANK` | `distance=2.5, invalid_hold_action` | 收回跳板 |
| `MOUNT_PLANK` | `distance=0.5, invalid_hold_action` | 上跳板 |
| `DISMOUNT_PLANK` | `distance=2.5` | 下跳板 |
| `ABANDON_SHIP` | `distance=2.5, priority=4, invalid_hold_action` | 弃船 |
| `REPAIR_LEAK` | `distance=2.5, invalid_hold_action` | 修补船漏 |
| `UNPATCH` | `distance=0.5` | 移除船补丁 |
| `BOARDPLATFORM` | `customarrivecheck` | 登船 |
| `ROTATE_BOAT_CLOCKWISE` | `rmb, priority=1` | 顺时针旋转船 |
| `ROTATE_BOAT_COUNTERCLOCKWISE` | `priority=1` | 逆时针旋转船 |
| `ROTATE_BOAT_STOP` | `*` | 停止旋转船 |
| `BOAT_MAGNET_ACTIVATE` | `*` | 激活船磁铁 |
| `BOAT_MAGNET_DEACTIVATE` | `*` | 停用船磁铁 |
| `BOAT_MAGNET_BEACON_TURN_ON` | `rmb, priority=3` | 打开磁铁信标 |
| `BOAT_MAGNET_BEACON_TURN_OFF` | `rmb, priority=3` | 关闭磁铁信标 |
| `BOAT_CANNON_LOAD_AMMO` | `distance=1.4, mount_valid, paused_valid, rmb, priority=3` | 装载船炮弹药 |
| `BOAT_CANNON_START_AIMING` | `distance=1.4` | 开始瞄准船炮 |
| `BOAT_CANNON_SHOOT` | `distance=9999, do_not_locomote` | 发射船炮 |
| `BOAT_CANNON_STOP_AIMING` | `instant` | 停止瞄准 |
| `OCEAN_TRAWLER_LOWER` | `distance=2.8, rmb` | 下放拖网 |
| `OCEAN_TRAWLER_RAISE` | `distance=2.8, rmb` | 升起拖网 |
| `OCEAN_TRAWLER_FIX` | `distance=2.8` | 修复拖网 |
| `OCEAN_TOSS` | `priority=3, rmb, customarrivecheck, is_relative_to_platform, disable_platform_hopping` | 海上投掷 |
| `WATER_TOSS` | `priority=3, rmb, customarrivecheck, is_relative_to_platform, disable_platform_hopping` | 水上投掷 |
| `TOSS` | `priority=1, rmb, distance=8, mount_valid` | 投掷 |
| `TOSS_MAP` | `priority=HIGH, customarrivecheck, rmb, mount_valid, map_action, closes_map` | 地图投掷 |
| `FILL_OCEAN` | `is_relative_to_platform, extra_arrive_dist` | 海水装填 |

## 食物/烹饪动作

| Action | 参数 | 说明 |
|--------|------|------|
| `EAT` | `mount_valid, floating_valid` | 吃/喝 |
| `COOK` | `priority=1, mount_valid` | 烹饪 |
| `FILL` | `*` | 装填（锅） |
| `DRY` | `*` | 晾干 |
| `FEED` | `priority=1, rmb, mount_valid` | 喂食 |
| `SALT` | `*` | 撒盐 |
| `APPLYPRESERVATIVE` | `*` | 添加防腐剂 |
| `WAX` | `encumbered_valid, mindistance=1.5` | 打蜡封存 |
| `REPLATE` | `*` | 换盘 |
| `WINTERSFEAST_FEAST` | `priority=1` | 冬日盛宴享用 |

## 制作/配方动作

| Action | 参数 | 说明 |
|--------|------|------|
| `OPEN_CRAFTING` | `priority=2, distance=TUNING.RESEARCH_MACHINE_DIST-1` | 打开制作栏 |
| `CREATE` | `*` | 创建（配方） |
| `JOIN` | `*` | 加入（合作配方） |
| `REPAIR` | `mount_valid, encumbered_valid` | 修理 |
| `SEW` | `mount_valid` | 缝补 |
| `UPGRADE` | `rmb, priority=1` | 升级 |
| `RESETMINE` | `priority=3` | 重置矿脉 |
| `UNLOCK` | `*` | 解锁 |
| `USEKLAUSSACKKEY` | `*` | 使用克劳斯袋钥匙 |

## 激活/切换动作

| Action | 参数 | 说明 |
|--------|------|------|
| `ACTIVATE` | `priority=2, invalid_hold_action` | 激活 |
| `TURNON` | `priority=2, invalid_hold_action` | 开启 |
| `TURNOFF` | `priority=2, invalid_hold_action` | 关闭 |
| `USEITEM` | `priority=1, instant` | 使用物品 |
| `USEITEMON` | `distance=2, priority=1, mount_valid` | 对目标使用物品 |
| `STOPUSINGITEM` | `priority=1` | 停止使用物品 |
| `USEEQUIPPEDITEM` | `priority=1, mount_valid` | 使用装备物品 |
| `STOPUSINGEQUIPPEDITEM` | `priority=1, instant, mount_valid` | 停止使用装备物品 |
| `STARTCHANNELING` | `priority=2, distance=2.1` | 开始引导 |
| `STOPCHANNELING` | `instant, distance=2.1` | 停止引导 |
| `START_CHANNELCAST` | `priority=-1, rmb, do_not_locomote` | 开始引导施法 |
| `STOP_CHANNELCAST` | `priority=-1, rmb, do_not_locomote` | 停止引导施法 |
| `CYCLE` | `rmb, priority=2` | 切换/循环 |

## 生物/宠物动作

| Action | 参数 | 说明 |
|--------|------|------|
| `MOUNT` | `priority=1, rmb, encumbered_valid` | 骑乘 |
| `DISMOUNT` | `priority=1, instant, rmb, mount_valid, encumbered_valid` | 下马 |
| `SADDLE` | `priority=1` | 上鞍 |
| `UNSADDLE` | `priority=3, rmb=false` | 卸鞍 |
| `BRUSH` | `priority=3, rmb=false` | 刷毛 |
| `FEED` | `priority=1, rmb, mount_valid` | 喂食 |
| `PET` | `*` | 抚摸 |
| `ABANDON` | `rmb` | 遗弃 |
| `SLAUGHTER` | `canforce, rangecheckfn` | 屠宰 |
| `LAYEGG` | `*` | 下蛋 |
| `STEALMOLEBAIT` | `rmb=false, distance=0.75` | 偷鼹鼠诱饵 |
| `MAKEMOLEHILL` | `priority=4, rmb=false, distance=0` | 造鼹鼠丘 |
| `MOLEPEEK` | `rmb=false, distance=1` | 鼹鼠探头 |
| `HAIRBALL` | `rmb=false, distance=3` | 吐毛球（猫） |
| `CATPLAYGROUND` | `rmb=false, distance=1` | 猫玩地面 |
| `CATPLAYAIR` | `rmb=false, distance=2` | 猫玩空中 |
| `NUZZLE` | `*` | 蹭蹭 |
| `TRANSFER_CRITTER` | `invalid_hold_action` | 转移小动物 |
| `RETURN_FOLLOWER` | `*` | 遣返跟随者 |
| `HIDEANSEEK_FIND` | `rmb, priority=1, mount_valid` | 捉迷藏寻找 |
| `HERD_FOLLOWERS` | `mount_valid` | 召集跟随者 |
| `MIGRATE` | `rmb=false, encumbered_valid, ghost_valid` | 迁移 |
| `SUMMONGUARDIAN` | `rmb=false, distance=5` | 召唤守护者 |
| `CASTSUMMON` | `rmb, mount_valid, priority=3` | 召唤生物 |
| `CASTUNSUMMON` | `mount_valid, distance=math.huge, priority=3` | 遣散召唤物 |
| `COMMUNEWITHSUMMONED` | `rmb, mount_valid, priority=2` | 与召唤物交流 |

## 陷阱/狩猎动作

| Action | 参数 | 说明 |
|--------|------|------|
| `BAIT` | `*` | 放诱饵 |
| `CHECKTRAP` | `priority=2, mount_valid` | 检查陷阱 |

## 睡眠/休息动作

| Action | 参数 | 说明 |
|--------|------|------|
| `SLEEPIN` | `*` | 睡觉 |
| `GOHOME` | `*` | 回家 |
| `CHANGEIN` | `priority=0` | 换衣服 |
| `SOAKIN` | `invalid_hold_action` | 泡澡 |

## 角色专属动作

### 韦伯 (WEBBER)
| Action | 参数 | 说明 |
|--------|------|------|
| `MUTATE_SPIDER` | `priority=2` | 变异蜘蛛 |
| `HERD_FOLLOWERS` | `mount_valid` | 召集随从 |
| `REPEL` | `mount_valid` | 驱散 |
| `BEDAZZLE` | `*` | 迷惑 |

### 旺达 (WANDA)
| Action | 参数 | 说明 |
|--------|------|------|
| `DISMANTLE_POCKETWATCH` | `mount_valid` | 拆解怀表 |

### 沃尔夫冈 (WOLFGANG)
| Action | 参数 | 说明 |
|--------|------|------|
| `LIFT_DUMBBELL` | `priority=2, mount_valid=false` | 举哑铃 |
| `STOP_LIFT_DUMBBELL` | `priority=2, instant, mount_valid=false` | 停止举哑铃 |
| `ENTER_GYM` | `mount_valid=false, invalid_hold_action` | 进入健身房 |
| `UNLOAD_GYM` | `mount_valid=false` | 卸下健身房 |
| `LEAVE_GYM` | `mount_valid=false, instant` | 离开健身房 |
| `LIFT_GYM_SUCCEED_PERFECT` | `do_not_locomote, disable_platform_hopping, skip_locomotor_facing` | 健身完美成功 |
| `LIFT_GYM_SUCCEED` | `do_not_locomote, disable_platform_hopping, skip_locomotor_facing` | 健身成功 |
| `LIFT_GYM_FAIL` | `do_not_locomote, disable_platform_hopping, skip_locomotor_facing` | 健身失败 |

### WX-78
| Action | 参数 | 说明 |
|--------|------|------|
| `APPLYMODULE` | `mount_valid` | 安装模块 |
| `APPLYMODULE_FAIL` | `mount_valid, instant` | 安装模块失败 |
| `REMOVEMODULES` | `mount_valid` | 移除模块 |
| `REMOVEMODULES_FAIL` | `mount_valid, instant` | 移除模块失败 |
| `CHARGE_FROM` | `distance=1.25, mount_valid=false` | 充能 |
| `STARTREMOVINGMODULE` | `mount_valid, invalid_hold_action` | 开始移除模块 |
| `REMOVEMODULE` | `mount_valid, instant, invalid_hold_action` | 移除模块（UI中） |
| `STOPREMOVINGMODULE` | `mount_valid, invalid_hold_action` | 停止移除模块 |
| `TOGGLEWXSCREECH` | `priority=1, invalid_hold_action` | 切换WX尖啸 |
| `TOGGLEWXSHIELDING` | `priority=0, invalid_hold_action` | 切换WX护盾 |

### 麦斯威尔 (MAXWELL)
| Action | 参数 | 说明 |
|--------|------|------|
| `USEMAGICTOOL` | `mount_valid, priority=1` | 使用魔法工具 |
| `STOPUSINGMAGICTOOL` | `mount_valid, priority=2, distance=math.huge, do_not_locomote` | 停止使用魔法工具 |
| `USESPELLBOOK` | `instant, mount_valid, priority=2` | 使用魔法书 |
| `CLOSESPELLBOOK` | `instant, mount_valid, priority=2` | 关闭魔法书 |
| `CAST_SPELLBOOK` | `mount_valid` | 施放魔法书 |

### 伍迪 (WOODIE)
| Action | 参数 | 说明 |
|--------|------|------|
| `USE_WEREFORM_SKILL` | `rmb, distance=math.huge` | 使用兽形态技能 |

### 薇诺娜 (WINONA)
| Action | 参数 | 说明 |
|--------|------|------|
| `REMOTE_TELEPORT` | `rmb, invalid_hold_action, mount_valid` | 远程传送 |

### 沃比 (WOBY)
| Action | 参数 | 说明 |
|--------|------|------|
| `WOBY_PICKUP` | `arrivedist=2` | 沃比拾取 |
| `WOBY_PICK` | `extra_arrive_dist` | 沃比采集 |

## 娱乐/小游戏动作

| Action | 参数 | 说明 |
|--------|------|------|
| `PLAY` | `mount_valid` | 玩 |
| `PERFORM` | `rmb, distance=1.5, invalid_hold_action` | 表演 |
| `SING` | `rmb, mount_valid` | 唱歌 |
| `SING_FAIL` | `rmb, mount_valid` | 唱歌失败 |
| `TELLSTORY` | `rmb, distance=3` | 讲故事 |
| `MAKEBALLOON` | `mount_valid` | 做气球 |
| `FAN` | `rmb, mount_valid` | 扇风 |
| `WRITE` | `*` | 写 |
| `DRAW` | `*` | 画 |
| `ERASE_PAPER` | `rmb, mount_valid` | 擦除纸张 |
| `READ` | `mount_valid` | 阅读 |
| `TEACH` | `mount_valid` | 教导 |
| `INVESTIGATE` | `*` | 调查 |
| `APPRAISE` | `*` | 鉴定 |
| `START_CARRAT_RACE` | `rmb` | 开始胡萝卜鼠比赛 |
| `CARNIVAL_HOST_SUMMON` | `*` | 召唤嘉年华主持 |
| `CARNIVALGAME_FEED` | `mount_valid` | 嘉年华游戏喂食 |

## 地图操作动作

| Action | 参数 | 说明 |
|--------|------|------|
| `MAPSCOUT_MAP` | `instant, mount_valid, map_only, map_works_on_unexplored, map_works_on_impassable` | 地图侦察 |
| `MAPSCOUT_MAP_TOOFAR` | `instant, mount_valid, map_only, map_works_on_unexplored, map_works_on_impassable` | 地图侦察（太远） |
| `MAPSCOUTSELECT_MAP` | `instant, mount_valid, rmb, map_only, map_works_on_unexplored, map_works_on_impassable` | 地图侦察选择 |
| `STARTMAPDELIVER` | `rmb` | 开始地图投递 |
| `MAPDELIVER_MAP` | `map_only, closes_map` | 地图投递 |
| `DIRECTCOURIER_MAP` | `priority=HIGH, customarrivecheck, rmb, instant, map_only, map_works_on_unexplored, closes_map` | 直送信使 |
| `SWAPBODIES_MAP` | `customarrivecheck, rmb, map_only, map_works_on_unexplored, closes_map` | 交换身体（地图） |
| `STARTVAULTORBTELEPORT` | `rmb` | 开始宝珠传送 |
| `VAULTORBTELEPORT_MAP` | `customarrivecheck, rmb, map_only, map_works_on_unexplored, closes_map` | 宝珠传送（地图） |

## 农业/植物动作

| Action | 参数 | 说明 |
|--------|------|------|
| `PLANTREGISTRY_RESEARCH` | `priority=HIGH` | 植物登记研究 |
| `PLANTREGISTRY_RESEARCH_FAIL` | `priority=-1` | 植物登记研究失败 |
| `ASSESSPLANTHAPPINESS` | `priority=1` | 评估植物快乐度 |
| `ATTACKPLANT` | `*` | 攻击植物 |
| `PLANTWEED` | `*` | 种植杂草 |
| `ADVANCE_TREE_GROWTH` | `*` | 加速树木生长 |
| `ADDCOMPOSTABLE` | `*` | 添加堆肥材料 |
| `POUR_WATER` | `rmb, tile_placer=gridplacer, extra_arrive_dist` | 浇水 |
| `POUR_WATER_GROUNDTILE` | `rmb, customarrivecheck, tile_placer=gridplacer, theme_music=farming` | 浇地 |

## 装饰/节日动作

| Action | 参数 | 说明 |
|--------|------|------|
| `DECORATEVASE` | `*` | 装饰花瓶 |
| `CARVEPUMPKIN` | `distance=1.5` | 雕刻南瓜 |
| `DECORATESNOWMAN` | `distance=1.5, encumbered_valid, invalid_hold_action` | 装饰雪人 |
| `START_PUSHING` | `distance=1.5, rmb, priority=1, invalid_hold_action` | 开始推 |
| `HALLOWEENMOONMUTATE` | `priority=-1` | 万圣节月亮变异 |
| `BATHBOMB` | `*` | 浴缸炸弹 |

## 纸牌/包裹动作

| Action | 参数 | 说明 |
|--------|------|------|
| `BUNDLE` | `rmb, priority=2` | 打包 |
| `BUNDLESTORE` | `instant` | 存入包裹 |
| `WRAPBUNDLE` | `instant` | 包裹封口 |
| `UNWRAP` | `rmb, priority=2` | 拆包 |
| `PEEKBUNDLE` | `rmb, priority=2` | 窥视包裹 |
| `BREAK` | `rmb, priority=2` | 打破 |
| `UNPIN` | `*` | 取下（便签） |
| `DRAW_FROM_DECK` | `priority=2, distance=1.8, mount_valid` | 从牌组抽牌 |
| `FLIP_DECK` | `mount_valid` | 翻牌组 |
| `ADD_CARD_TO_DECK` | `mount_valid, canforce, rangecheckfn` | 添加牌到牌组 |

## 任务动作

| Action | 参数 | 说明 |
|--------|------|------|
| `BEGIN_QUEST` | `*` | 开始任务 |
| `ABANDON_QUEST` | `*` | 放弃任务 |

## 牛年/其他活动动作

| Action | 参数 | 说明 |
|--------|------|------|
| `YOTB_SEW` | `priority=1, mount_valid` | 牛年缝纫 |
| `YOTB_STARTCONTEST` | `*` | 牛年开始比赛 |
| `YOTB_UNLOCKSKIN` | `*` | 牛年解锁皮肤 |
| `GIVE_TACKLESKETCH` | `*` | 给予渔具草图 |
| `REMOVE_FROM_TROPHYSCALE` | `*` | 从奖杯秤取下 |

## 其他特殊动作

| Action | 参数 | 说明 |
|--------|------|------|
| `ATTUNE` | `*` | 调谐 |
| `HITCHUP` | `priority=-1` | 拴上 |
| `HITCH` | `priority=-1` | 拴住 |
| `UNHITCH` | `distance=2, priority=-1` | 解开 |
| `MARK` | `distance=2, priority=-1` | 标记 |
| `BOTTLE` | `mount_valid` | 装瓶 |
| `APPLYELIXIR` | `mount_valid` | 使用灵药 |
| `MODSLINGSHOT` | `mount_valid` | 改装弹弓 |
| `STOPMODSLINGSHOT` | `instant, mount_valid` | 停止改装弹弓 |
| `WHISTLE` | `rmb, distance=math.huge, invalid_hold_action` | 吹哨 |
| `STARTELECTRICLINK` | `priority=2, invalid_hold_action` | 开始电链 |
| `ENDELECTRICLINK` | `priority=1, invalid_hold_action` | 结束电链 |
| `REMOVELUNARBUILDUP` | `priority=3, invalid_hold_action` | 清除月能积聚 |
| `EQUIPONBODY` | `priority=3, canforce, rangecheckfn` | 给附身身体装备 |
| `USE_HEAVY_OBSTACLE` | `encumbered_valid, rmb, priority=1` | 使用重型障碍物 |
| `UNLOAD_WINCH` | `rmb, priority=3` | 卸载绞盘 |
