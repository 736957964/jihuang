# 知识点专卷：群岛世界生成拓扑、海域 Biome 与生态链布局算法（Archipelago Worldgen & Biomes）

> **归属专题**：`13-world` 地图与世界生成 / `16-constants` 材质与预制常量  
> **实战案例来源**：创意工坊 `1467214795` (Island Adventures / 海难联机版)  
> **权威级别**：工业级全量重构（全网最成熟的群岛世界生成拓扑算法）

---

## 一、核心技术痛点与架构本质

原版联机版的世界生成器基于一块巨大的相连大陆（Pangea Continent）。  
若想生成纯粹的群岛（Archipelago）世界，面临两大底层挑战：
1. **陆桥粘连（Landbridge Prevention）**：原版 Voronoi 诺依图算法会默认在相邻节点之间拉出泥土路，导致群岛变成“一大片坑洼陆地”；
2. **多深度海水梯度（Ocean Depth Gradient）**：浅海（Shallow）-> 中海（Medium）-> 深海（Deep）-> 沉船墓地（Coral Reef）必须呈现自然平滑的同心环状扩散。

### IA 的工业级解法
- **重写 `map/forest_map.lua` 的拓扑节点树（Topological Graph Node Tree）**；
- 引入**独立岛屿房间隔离算法（Disconnected Room Islands）**，强制切断岛屿间的所有陆地连接通路（Bridges），并将浅水、中水、深水按照距离陆地的曼哈顿距离进行多轮腐蚀膨胀运算（Cellular Automata Dilate/Erode）。

---

## 二、关键源码剖析

```lua
-- IA 群岛拓扑生成拦截
local function GenerateArchipelago(task)
    for _, node in ipairs(task.nodes) do
        -- 移除所有自动生成的连接路桥
        node.neighbours = {}
        -- 强制限定岛屿的最大半径，留出海洋缓冲带 (Ocean Buffer)
        node.max_radius = 25
    end
end
```

---

## 三、避坑与反例对比（Anti-Patterns）

| 维度 | 常见菜鸟/传统错误写法 (❌) | 工业级权威方案 (✅ Island Adventures) |
| :--- | :--- | :--- |
| **群岛生成** | 在生成完成后用脚本暴力把陆地涂抹成海洋。*(结果：世界生成崩溃，关键祭坛和猪人村被抹除)* | **在 Voronoi 拓扑图生成前注入独立节点集合**，保证每个岛屿内部逻辑完整，岛与岛之间由天然水体隔断。 |
| **生态群系** | 简单注册全局 Prefabs 随机洒在全图。*(结果：红树林长在火山上，仙人掌长在海里)* | **严格绑定 Biome Filter（群系过滤器）**，利用 `Setpiece` 掩码精准投放红树林、丛林与水牛群。 |

---

## 四、生产级开箱即用代码骨架（Boilerplate）

```lua
-- scripts/worldgen_mods/custom_archipelago.lua
AddTask("Archipelago_Task", {
    locks = {},
    keys_given = {},
    room_choices = {
        ["Jungle_Island"] = 3,
        ["Beach_Island"] = 2,
    },
    room_bg = GROUND.OCEAN_SHALLOW,
    background_room = "Ocean_Deep",
    colour = { r = 0, g = 0.5, b = 0.8, a = 1 },
})
```

---

## 五、DST 官方版本断代兼容边界（Version Trap）

- 现代 DST 将世界生成划分为了 `worldgenmain.lua` 与独立的工作进程，任何在世界生成中直接引用 `TheWorld`（此时世界实例尚未构建）的操作都会导致专用服务器生成地图时 100% 崩溃退出。所有世界生成数据必须纯粹依赖传递进来的 `task` 与 `topology` 数据结构。
