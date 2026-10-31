* 🌟 创意工坊全文模组研读库
  * 01 UI 与 HUD 界面交互类
    * [网格吸附与对象池引擎 (351325790)](anli/skills/01_UI与HUD界面交互类/skill_workshop_351325790_Geometric_Placement_Core.md)
    * [视口小地图与矩阵缩放 (345692228)](anli/skills/01_UI与HUD界面交互类/skill_workshop_345692228_HUD_Responsive_Matrix.md)
    * [五维状态动态扩展与脏标记 (376333686)](anli/skills/01_UI与HUD界面交互类/skill_workshop_376333686_Combined_Status_Architecture.md)
    * [物品悬浮 Tooltip 动态挂载 (458940297)](anli/skills/01_UI与HUD界面交互类/skill_workshop_458940297_ItemTile_Tooltip_OnDemand.md)
    * [物品元数据快照面板 (836583293)](anli/skills/01_UI与HUD界面交互类/skill_workshop_836583293_Item_Metadata_Snapshot.md)
    * [响应式 HUD 与 RPC 传输管道](anli/skills/01_UI与HUD界面交互类/skill_workshop_responsive_hud_and_rpc_pipeline.md)
  * 02 动作控制与状态机 StateGraph 类
    * [纯客机协程动作队列调度器 (1608191708)](anli/skills/02_动作控制与状态机StateGraph类/skill_workshop_1608191708_Client_Action_Queue_Scheduler.md)
    * [饥荒RPG](anli/skills/02_动作控制与状态机StateGraph类/skill_workshop_3820674954_rpg.md)
  * 03 网络通信 RPC 与数据同步类
    * [全球定位网络表与信标广播 (378160973)](anli/skills/03_网络通信RPC与数据同步类/skill_workshop_378160973_Global_Positions_Beacon.md)
    * [Show Me 序列化与属性探针 (666155465)](anli/skills/03_网络通信RPC与数据同步类/skill_workshop_666155465_Show_Me_Protocol.md)
    * [高亮选物 RPC 寻径与高频广播 (2281925291)](anli/skills/03_网络通信RPC与数据同步类/skill_workshop_2281925291_mod_2281925291.md)
  * 04 物品容器与背包扩展类
    * [额外装备槽拓扑与网络预测 (母本)](anli/skills/04_物品容器与背包扩展类/skill_workshop_extra_equip_slots_topology.md)
    * [多倍堆叠与动态容量逼近算法 (374550642)](anli/skills/04_物品容器与背包扩展类/skill_workshop_374550642_Stack_Tuning_Approximation.md)
    * [大容量地窖矩阵网格与持久化 (382177939)](anli/skills/04_物品容器与背包扩展类/skill_workshop_382177939_Large_Container_Grid_Matrix.md)
  * 05 战斗 AI 行为树与 Boss 机制类
    * [Boss 状态机与仇恨追击算法](anli/skills/05_战斗AI行为树与Boss机制类/skill_workshop_boss_stategraph_and_aggro_system.md)
    * [高性能波次生成器与 GC 防御](anli/skills/05_战斗AI行为树与Boss机制类/skill_workshop_high_perf_wave_spawner_and_gc.md)
  * 06 世界生成与生态系统类
    * [上值劫持与海洋距离判定 (1467214795)](anli/skills/06_世界生成与生态系统类/skill_workshop_1467214795_Upvalue_Hacker_And_Arrive_Dist.md)
  * 07 实体机制与游戏平衡类
    * [聊天指令拦截与生命周期重置 (母本)](anli/skills/07_实体机制与游戏平衡类/skill_workshop_player_lifecycle_and_command_restart.md)
    * [网络副本组件拓扑注入 (1530801499)](anli/skills/07_实体机制与游戏平衡类/skill_workshop_1530801499_Replicable_Component_Topology.md)
    * [虫洞双向拓扑标记与着色 (362175979)](anli/skills/07_实体机制与游戏平衡类/skill_workshop_362175979_Dual_Topology_Wormhole_Mark.md)
  * 08 语言本地化与字体渲染类
    * [闭包路径劫持与动态字体栈 (1418746242)](anli/skills/08_语言本地化与字体渲染类/skill_workshop_1418746242_Closure_Path_And_Font_Pipeline.md)
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
