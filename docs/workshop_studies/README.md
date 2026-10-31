# 饥荒联机版（DST）创意工坊权威模组研读库（总览与分类索引）

本研读库严格执行管理员（老爹）制定的 **【Doc-as-Skill 工业级规范】**，彻底摒弃任何无钩子、纯数值改动的流水账，专注于饥荒 Mod 开发中最具技术难度与架构深度的权威范式。

所有研读均按照严格的 **3 级层级体系** 组织归档，任何一个条目都归属于清晰的功能专卷分类，具备唯一的母本索引路径。

---

## 📚 权威研读与黄金 Skill 分类索引

### 01 UI 与 HUD 界面交互类
> 涵盖客户端视口挂载、晶格吸附、仿射矩阵投影、Badge徽章状态脏标记及按需悬浮提示等。
- [专卷全景架构综述](/docs/workshop_studies/01_UI与HUD界面交互类/README.md)
- [几何种植：网格吸附与对象池增量渲染引擎 (351325790)](/docs/workshop_studies/01_UI与HUD界面交互类/study_351325790_geometric_placement.md)
- [小地图 HUD：独立视口挂载与缩放矩阵 (345692228)](/docs/workshop_studies/01_UI与HUD界面交互类/study_345692228_minimap_hud.md)
- [五维状态显示：动态扩展与脏标记流转机制 (376333686)](/docs/workshop_studies/01_UI与HUD界面交互类/study_376333686_combined_status.md)
- [食物与三维属性常驻状态条 (1185229307)](/docs/workshop_studies/01_UI与HUD界面交互类/study_1185229307_food_values_display.md)
- [简易血条客机切面 (1207269292)](/docs/workshop_studies/01_UI与HUD界面交互类/study_1207269292_simple_health_bar_server.md)
- [史诗级 Boss 动态血条渲染 (1595631294)](/docs/workshop_studies/01_UI与HUD界面交互类/study_1595631294_epic_healthbar.md)
- [食物属性按需悬浮 Tooltip 渲染 (458940297)](/docs/workshop_studies/01_UI与HUD界面交互类/study_458940297_food_values_item_tooltips.md)
- [物品详细元数据快照面板 (836583293)](/docs/workshop_studies/01_UI与HUD界面交互类/study_836583293_item_info.md)

---

### 02 动作控制与状态机 StateGraph 类
> 涵盖纯客户端动作预测、协程调度管线、手控移动打断及 StateGraph 状态切面。
- [专卷全景架构综述](/docs/workshop_studies/02_动作控制与状态机StateGraph类/README.md)
- [动作队列：纯客户端协程流水线与移动打断调度器 (1608191708)](/docs/workshop_studies/02_动作控制与状态机StateGraph类/study_1608191708_action_queue_reborn.md)

---

### 03 网络通信 RPC 与数据同步类
> 涵盖服务端权威广播、Netvars 网络变量序列化、RPC 管道压缩及跨实体数据探针。
- [专卷全景架构综述](/docs/workshop_studies/03_网络通信RPC与数据同步类/README.md)
- [全球定位：网络表脏标记广播与地图信标 (378160973)](/docs/workshop_studies/03_网络通信RPC与数据同步类/study_378160973_global_positions.md)
- [Show Me：协议序列化、数据探针与属性广播 (666155465)](/docs/workshop_studies/03_网络通信RPC与数据同步类/study_666155465_show_me.md)
- [Insight：高性能 RPC 专有同步协议切面 (758532836)](/docs/workshop_studies/03_网络通信RPC与数据同步类/study_758532836_insight_protocol.md)

---

### 04 物品容器与背包扩展类
> 涵盖容器拓扑动态注入、大容量网格矩阵、物品堆叠溢出算法与存档数据持久化。
- [专卷全景架构综述](/docs/workshop_studies/04_物品容器与背包扩展类/README.md)
- [多倍堆叠与动态容量逼近算法 (374550642)](/docs/workshop_studies/04_物品容器与背包扩展类/study_374550642_increased_stack_size.md)
- [额外装备槽：独立装备位与网络拓扑扩展 (375850593)](/docs/workshop_studies/04_物品容器与背包扩展类/study_375850593_extra_equip_slots.md)
- [防爆地窖：大容量矩阵容器与存档持久化 (382177939)](/docs/workshop_studies/04_物品容器与背包扩展类/study_382177939_storm_cellar.md)

---

### 05 战斗 AI 行为树与 Boss 机制类
> 涵盖复杂 Boss 仇恨策略、行为树修剪、波次高频生成器与实体垃圾回收。
- [专卷全景架构综述](/docs/workshop_studies/05_战斗AI行为树与Boss机制类/README.md)

---

### 06 世界生成与生态系统类
> 涵盖全新群岛拓扑、海洋物理流体仿真、地质灾难循环及大型 DLC 级模组架构。
- [专卷全景架构综述](/docs/workshop_studies/06_世界生成与生态系统类/README.md)
- [海难大型 DLC：海洋动力学与群岛生态架构 (1467214795)](/docs/workshop_studies/06_世界生成与生态系统类/study_1467214795_island_adventures.md)
  - [01 海洋物理与船舶动力学](/docs/workshop_studies/06_世界生成与生态系统类/island_adventures/01_marine_physics_and_locomotion.md)
  - [02 潮汐浪涌波浪物理动力学](/docs/workshop_studies/06_世界生成与生态系统类/island_adventures/02_ocean_tides_waves_dynamics.md)
  - [03 火山季世界与喷发地质灾难](/docs/workshop_studies/06_世界生成与生态系统类/island_adventures/03_volcano_world_and_disasters.md)
  - [04 海洋 Boss 战斗与状态机](/docs/workshop_studies/06_世界生成与生态系统类/island_adventures/04_marine_bosses_and_stategraph.md)
  - [05 群岛世界生成与生物群系](/docs/workshop_studies/06_世界生成与生态系统类/island_adventures/05_archipelago_worldgen_biomes.md)

---

### 07 实体机制与游戏平衡类
> 涵盖实体双向标记、空间着色、角色注销/重生切面与客户端全局指令管理。
- [专卷全景架构综述](/docs/workshop_studies/07_实体机制与游戏平衡类/README.md)
- [快速旅行：UI 视口挂载与无损空间坐标穿梭 (1530801499)](/docs/workshop_studies/07_实体机制与游戏平衡类/study_1530801499_fast_travel_gui.md)
- [虫洞标记：双向拓扑记录与着色渲染 (362175979)](/docs/workshop_studies/07_实体机制与游戏平衡类/study_362175979_wormhole_marks.md)
- [自杀重选：实体注销生命周期与角色重生切面 (462434129)](/docs/workshop_studies/07_实体机制与游戏平衡类/study_462434129_restart.md)

---

### 08 语言本地化与字体渲染类
> 涵盖动态字体栈、闭包路径劫持、多语言字典流转与宽字符渲染管线。
- [专卷全景架构综述](/docs/workshop_studies/08_语言本地化与字体渲染类/README.md)
- [中文增强：Lua 闭包劫持与动态字体栈切面 (1418746242)](/docs/workshop_studies/08_语言本地化与字体渲染类/study_1418746242_chinese_plus_plus.md)
- [神话书说：国际化多语言文本架构与字典注入 (1991746508)](/docs/workshop_studies/08_语言本地化与字体渲染类/study_1991746508_myth_words_architecture.md)
