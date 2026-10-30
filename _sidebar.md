- 🌟 创意工坊权威模组研读库
  * [研读库总览与账本](/docs/workshop_studies/README)
  * UI 与 HUD 类别
    * [小地图 HUD (345692228)](/docs/workshop_studies/UI与HUD类/study_345692228_minimap_hud)
    * [几何种植 (351325790)](/docs/workshop_studies/UI与HUD类/study_351325790_geometric_placement)
    * [五维状态显示 (376333686)](/docs/workshop_studies/UI与HUD类/study_376333686_combined_status)
  * 网络与 RPC 同步类
    * [全球定位 Global Positions (378160973)](/docs/workshop_studies/study_378160973_global_positions)
  * 实体与 Prefabs 机制类
    * [地窖模组 Storm Cellar (382177939)](/docs/workshop_studies/study_382177939_storm_cellar)
    * [虫洞标记 Wormhole Marks (362175979)](/docs/workshop_studies/study_362175979_wormhole_marks)
  * 组件与数据持久化类
    * [物品堆叠上限 Increased Stack (374550642)](/docs/workshop_studies/study_374550642_increased_stack_size)
    * [显伤/属性透视 Show Me (666155465)](/docs/workshop_studies/study_666155465_show_me)
  * 大型内容拓展与世界类
    * [海难联机版 Island Adventures (1467214795)](/docs/workshop_studies/study_1467214795_island_adventures)
* [🌟 核心架构决策与源码哲学](01-core/architecture_philosophy.md)
- 前言
  * [Mod相关信息](/README)
- 01 核心系统
  * [01-core 总览](/01-core/index)
  * [EntityScript 实体脚本](/01-core/entity)
  * [Prefab 预制体系统](/01-core/prefab)
  * [Class 类系统](/01-core/class)
  * [全局函数](/01-core/mainfunctions)
  * [全局变量](/01-core/globals)
  * [simutil 工具函数](/01-core/simutil)
- 02 Components 组件
  * [02-components 总览](/02-components/index)
  * 战斗 Combat
    * [combat 总览](/02-components/combat/index)
    * [combat 战斗](/02-components/combat/combat)
    * [health 生命值](/02-components/combat/health)
    * [weapon 武器](/02-components/combat/weapon)
    * [armor 盔甲](/02-components/combat/armor)
  * 生存 Survival
    * [survival 总览](/02-components/survival/index)
    * [hunger 饥饿](/02-components/survival/hunger)
    * [sanity 理智](/02-components/survival/sanity)
  * 背包 Inventory
    * [inventory 总览](/02-components/inventory/index)
    * [inventory 背包](/02-components/inventory/inventory)
    * [container 容器](/02-components/inventory/container)
  * 工作 Work
    * [work 总览](/02-components/work/index)
    * [workable 可工作](/02-components/work/workable)
  * 食物 Edible
    * [edible 总览](/02-components/edible/index)
    * [edible 可食用](/02-components/edible/edible)
    * [perishable 易腐](/02-components/edible/perishable)
  * 建造 Builder
    * [builder 总览](/02-components/builder/index)
    * [builder 建造](/02-components/builder/builder)
  * 燃烧 Burnable
    * [burnable 总览](/02-components/burnable/index)
    * [burnable 可燃](/02-components/burnable/burnable)
  * 生物 Creature
    * [creature 总览](/02-components/creature/index)
    * [childspawner 子生物生成](/02-components/creature/childspawner)
  * 其他 Other
    * [other 总览](/02-components/other/index)
    * 物品系统
      * [inventoryitem 库存物品](/02-components/other/inventoryitem)
      * [stackable 堆叠](/02-components/other/stackable)
      * [equippable 可装备](/02-components/other/equippable)
      * [deployable 可部署](/02-components/other/deployable)
      * [finiteuses 耐久度](/02-components/other/finiteuses)
      * [repairable 可修复](/02-components/other/repairable)
      * [tradable 可交易](/02-components/other/tradable)
    * 交互系统
      * [named 命名](/02-components/other/named)
      * [inspectable 可检查](/02-components/other/inspectable)
      * [writeable 可书写](/02-components/other/writeable)
      * [talker 说话](/02-components/other/talker)
      * [gesturetracker 手势](/02-components/other/gesturetracker)
    * 环境系统
      * [areaaware 区域感知](/02-components/other/areaaware)
      * [ambientlight 环境光](/02-components/other/ambientlight)
      * [propagator 传播](/02-components/other/propagator)
      * [explosive 爆炸](/02-components/other/explosive)
      * [groundpound 震荡](/02-components/other/groundpound)
      * [submersible 可浸没](/02-components/other/submersible)
    * 传送/变形/状态
      * [teleporter 传送](/02-components/other/teleporter)
      * [transformable 变形](/02-components/other/transformable)
      * [petrifiable 石化](/02-components/other/petrifiable)
      * [resurrector 复活](/02-components/other/resurrector)
      * [hauntable 作祟](/02-components/other/hauntable)
      * [ghostlybond 灵魂绑定](/02-components/other/ghostlybond)
      * [appeasement 安抚](/02-components/other/appeasement)
    * 外观/控制/地图
      * [wardrobe 衣柜](/02-components/other/wardrobe)
      * [skinny 外观](/02-components/other/skinny)
      * [decoration 装饰](/02-components/other/decoration)
      * [playercontroller 控制](/02-components/other/playercontroller)
      * [actionpicker 动作选择](/02-components/other/playeractionpicker)
      * [map 地图](/02-components/other/map)
      * [knownlocations 位置](/02-components/other/knownlocations)
      * [pinnable 标记](/02-components/other/pinnable)
    * 其他
      * [timer 定时器](/02-components/other/timer)
      * [occupier 占用](/02-components/other/occupier)
      * [kramped 坎普斯](/02-components/other/kramped)
      * [widgetfavorite 收藏](/02-components/other/widgetfavorite)
  * 航海 Sailing
    * [sailing 总览](/02-components/sailing/index)
- 03 Actions 动作
  * [03-actions 总览](/03-actions/index)
  * [动作列表](/03-actions/detail/action-list)
- 04 Tags 标签
  * [04-tags 总览](/04-tags/index)
- 05 Events 事件
  * [05-events 总览](/05-events/index)
- 06 Stategraphs 状态图
  * [06-stategraphs 总览](/06-stategraphs/index)
  * [常用 SG 参考](/06-stategraphs/sg-reference)
- 07 Brains 行为大脑
  * [07-brains 总览](/07-brains/index)
  * [常用 Brain 参考](/07-brains/brain-reference)
- 08 Prefabs 预设
  * [08-prefabs 总览](/08-prefabs/index)
  * [Prefab 分类参考](/08-prefabs/prefabs-reference)
- 09 Tuning 调参
  * [09-tuning 总览](/09-tuning/index)
- 10 Networking 网络
  * [10-networking 总览](/10-networking/index)
- 11 Modding Mod开发
  * [11-modding 总览](/11-modding/index)
  * [Mod开发工程核心规范](/11-modding/engineering_rules)
- 12 Cooking 烹饪
  * [12-cooking 总览](/12-cooking/index)
- 13 World 世界
  * [13-world 总览](/13-world/index)
  * [地图生成系统](/13-world/worldgen)
- 14 Skilltree 技能树
  * [14-skilltree 总览](/14-skilltree/index)
- 15 UI 界面
  * [15-ui 总览](/15-ui/index)
- 16 Constants 常量
  * [16-constants 总览](/16-constants/index)
- 17 Standard Components 标准组件
  * [17-standardcomponents 总览](/17-standardcomponents/index)
- 18 Behaviours 行为树
  * [18-behaviours 总览](/18-behaviours/index)
- 19 FX 特效
  * [19-fx 总览](/19-fx/index)
- 案例
  * [小案例](/anli/smallAn)
- 数据提取
  * [数据提取1](/xiazai/tq1)
  * [数据提取2](/xiazai/tq2)
  * [数据提取3](/xiazai/tq3)
  * [数据提取4](/xiazai/tq4)
  * [数据提取5](/xiazai/tq5)
  * [字典](/xiazai/tq6)
