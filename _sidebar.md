* 🌟 创意工坊全文模组研读库 (权威母本架构)
  * UI与HUD界面交互类
    * [HUD 矩阵反缩放自适应与视口输入隔离机制](anli/skills/01_UI与HUD界面交互类/skill_workshop_345692228_HUD_Responsive_Matrix.md)
    * [空间几何网格吸附与对象池增量渲染引擎](anli/skills/01_UI与HUD界面交互类/skill_workshop_351325790_Geometric_Placement_Core.md)
    * [事件驱动型 HUD 状态数值注入与跨端状态嗅探](anli/skills/01_UI与HUD界面交互类/skill_workshop_376333686_Combined_Status_Architecture.md)
    * [按需 RPC 属性查询与 ItemTile 悬停响应机制](anli/skills/01_UI与HUD界面交互类/skill_workshop_458940297_ItemTile_Tooltip_OnDemand.md)
    * [纯客机物品元数据镜像缓存与动作隔离沙盒机制](anli/skills/01_UI与HUD界面交互类/skill_workshop_836583293_Item_Metadata_Snapshot.md)
    * [客机响应式 HUD 悬浮面板与 RPC 事务双向流](anli/skills/01_UI与HUD界面交互类/skill_workshop_responsive_hud_and_rpc_pipeline.md)
  * 动作控制与状态机StateGraph类
    * [客户端协程动作队列与框选批量调度架构](anli/skills/02_动作控制与状态机StateGraph类/skill_workshop_1608191708_Client_Action_Queue_Scheduler.md)
  * 网络通信RPC与数据同步类
    * [伴生网络信标（Classified Entity）与跨视距同步架构](anli/skills/03_网络通信RPC与数据同步类/skill_workshop_378160973_Global_Positions_Beacon.md)
    * [紧凑单字节网络编码与 Hoverer 浮动提示切面](anli/skills/03_网络通信RPC与数据同步类/skill_workshop_666155465_Show_Me_Protocol.md)
  * 物品容器与背包扩展类
    * [全局 TUNING 梯队注入与 AddPrefabPostInitAny 智能逼近](anli/skills/04_物品容器与背包扩展类/skill_workshop_374550642_Stack_Tuning_Approximation.md)
    * [超大容量容器切面与多阵列网格对齐规范](anli/skills/04_物品容器与背包扩展类/skill_workshop_382177939_Large_Container_Grid_Matrix.md)
    * [额外装备槽容器拓扑与网络预测同步](anli/skills/04_物品容器与背包扩展类/skill_workshop_extra_equip_slots_topology.md)
  * 战斗AI行为树与Boss机制类
    * [多阶段高阶 BOSS 状态机打断与仇恨软锁定机制](anli/skills/05_战斗AI行为树与Boss机制类/skill_workshop_boss_stategraph_and_aggro_system.md)
    * [高性能动态波次刷怪与防卡顿内存自回收机制](anli/skills/05_战斗AI行为树与Boss机制类/skill_workshop_high_perf_wave_spawner_and_gc.md)
  * 世界生成与生态系统类
    * [闭包穿透黑客（Upvalue Hacker）与跨边界到达距离补偿机制](anli/skills/06_世界生成与生态系统类/skill_workshop_1467214795_Upvalue_Hacker_And_Arrive_Dist.md)
  * 实体机制与游戏平衡类
    * [主客双端复制组件（Replicable Component）与全服拓扑网络架构](anli/skills/07_实体机制与游戏平衡类/skill_workshop_1530801499_Replicable_Component_Topology.md)
    * [实体拓扑对偶配对与 MiniMap 迷雾穿透标记范式](anli/skills/07_实体机制与游戏平衡类/skill_workshop_362175979_Dual_Topology_Wormhole_Mark.md)
    * [服务端聊天指令拦截与玩家生命周期注销重启](anli/skills/07_实体机制与游戏平衡类/skill_workshop_player_lifecycle_and_command_restart.md)
  * 语言本地化与字体渲染类
    * [点分路径闭包穿透与引擎级字体热载技术](anli/skills/08_语言本地化与字体渲染类/skill_workshop_1418746242_Closure_Path_And_Font_Pipeline.md)
* [🌟 核心架构决策与源码哲学](01-core/architecture_philosophy.md)
* 前言
  * [Mod相关信息](README.md)
* 01 核心系统
  * [01-core 总览](01-core/index.md)
  * [EntityScript 实体脚本](01-core/entity.md)
  * [Prefab 预制体系统](01-core/prefab.md)
  * [Class 类系统](01-core/class.md)
  * [全局函数](01-core/mainfunctions.md)
  * [全局变量](01-core/globals.md)
  * [simutil 工具函数](01-core/simutil.md)
* 02 Components 组件
  * [02-components 总览](02-components/index.md)
  * 战斗 Combat
    * [combat 总览](02-components/combat/index.md)
    * [combat 战斗](02-components/combat/combat.md)
    * [health 生命值](02-components/combat/health.md)
    * [weapon 武器](02-components/combat/weapon.md)
    * [armor 盔甲](02-components/combat/armor.md)
  * 生存 Survival
    * [survival 总览](02-components/survival/index.md)
    * [hunger 饥饿](02-components/survival/hunger.md)
    * [sanity 理智](02-components/survival/sanity.md)
    * [temperature 温度](02-components/survival/temperature.md)
