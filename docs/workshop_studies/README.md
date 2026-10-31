# 饥荒联机版（DST）创意工坊权威模组研读库

本专栏由 **DeepSeek 自动化工坊研读流水线** 持续驱动生成，遵循严格的**权威性筛选标准**（订阅数超 50 万、历史沉淀代码、全网公认权威方案），旨在提供兼具**技术深度、架构解构、避坑指南、生产级 Skill 沉淀**的全面实战参考。

---

## 📚 已完成权威模组分类索引

### 1. UI 与 HUD 交互类
- **[几何种植 Geometric Placement (351325790)](/docs/workshop_studies/UI与HUD类/study_351325790_geometric_placement.md)**
  - *技术要点*：Client-Side 纯客户端注入、仿射网格坐标投影变换、Placer Hook 无感知拦截、零网络入侵设计。
- **[小地图 HUD Minimap HUD (345692228)](/docs/workshop_studies/UI与HUD类/study_345692228_minimap_hud.md)**
  - *技术要点*：独立 HUD 视口挂载、MiniMapComponent 封装、缩放矩阵与视口遮罩处理。
- **[五维状态显示 Combined Status (376333686)](/docs/workshop_studies/UI与HUD类/study_376333686_combined_status.md)**
  - *技术要点*：Badge 徽章动态扩展、脏标记按需刷新、高频数据网络传输开销优化。

### 2. 网络与 RPC 同步类
- **[全球定位 Global Positions (378160973)](/docs/workshop_studies/study_378160973_global_positions.md)**
  - *技术要点*：跨服务器实体网络脏标记广播、NetVars 协议压缩、大地图动态坐标共享。

### 3. 实体与 Prefabs 机制类
- **[地窖 Storm Cellar (382177939)](/docs/workshop_studies/study_382177939_storm_cellar.md)**
  - *技术要点*：超大容量容器 Container 数据持久化保存与加载、防火防雷耐久属性注入。
- **[虫洞标记 Wormhole Marks (362175979)](/docs/workshop_studies/study_362175979_wormhole_marks.md)**
  - *技术要点*：双向 Teleporter 对端动态寻址、实体着色着色器应用、微型状态图标绑定。

### 4. 组件与数据持久化类
- **[物品堆叠上限 Increased Stack Size (374550642)](/docs/workshop_studies/study_374550642_increased_stack_size.md)**
  - *技术要点*：Stackable 组件深度切面修改、数值边界安全保护、旧存档兼容方案。
- **[显伤与属性透视 Show Me (666155465)](/docs/workshop_studies/study_666155465_show_me.md)**
  - *技术要点*：Inspectable 拦截、Client-Server 属性反射协议、无侵入动态信息提示。

### 5. 大型内容拓展与世界机制类
- **[海难联机版 Island Adventures (1467214795)](/docs/workshop_studies/study_1467214795_island_adventures.md)**
  - *技术要点*：多世界物理规则重构、独立水体与波浪逻辑、完整生态群系（Biome）生成算法。

---

*持续更新中，流水线每 10 分钟自动调度巡检推进。*
