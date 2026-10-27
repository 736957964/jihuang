# 13-world — 地图生成系统 (World Generation)

> 源码: `scripts/map/` (478+ 文件)
> 地图生成是 DST 最复杂的系统之一，负责创建整个游戏世界的地形、生态区、资源分布和特殊结构。

---

## 1. 地图生成系统架构

### 1.1 核心文件结构

```
map/
├── level.lua            # 关卡/世界定义
├── levels.lua           # 所有关卡配置
├── terrain.lua          # 地形类型定义
├── rooms.lua            # 房间定义（地形块）
├── room_functions.lua   # 房间生成函数
├── tasks.lua            # 任务定义（生成什么）
├── tasksets.lua         # 任务集（一组任务）
├── layouts.lua          # 静态布局定义
├── layout.lua           # 布局生成逻辑
├── static_layout.lua    # 静态布局系统
├── object_layout.lua    # 对象布局
├── graphnode.lua        # 图节点（房间连接）
├── graphedge.lua        # 图边（连接路径）
├── settings.lua         # 生成设置
├── network.lua          # 网络相关
├── customise.lua        # 自定义世界设置
├── customize.lua        # 自定义选项
├── locations.lua        # 特殊位置定义
├── startlocations.lua   # 起始位置
├── pointsofinterest.lua # 兴趣点
├── protected_resources.lua # 受保护资源
├── resource_substitution.lua # 资源替换
├── storygen.lua         # 故事生成
├── boons.lua            # 恩赐（奖励箱等）
├── traps.lua            # 陷阱
├── bunches.lua          # 资源簇
├── bunch_spawner.lua    # 资源簇生成器
├── lockandkey.lua       # 锁钥机制
├── maptags.lua          # 地图标签
├── extents.lua          # 范围限制
├── maze_layouts.lua     # 迷宫布局
├── stack.lua            # 堆栈工具
├── placement.lua        # 放置工具
├── blockersets.lua      # 阻挡器集合
│
├── forest_map.lua       # 森林地图
├── caves_retrofit_land.lua # 洞穴改造
├── ocean_gen.lua        # 海洋生成
├── ocean_gen_config.lua # 海洋生成配置
├── ocean_retrofit_island.lua # 海洋岛屿改造
├── monkeyisland_worldgen.lua # 猴岛世界生成
├── waterlog_worldgen.lua # 水木世界生成
├── archive_worldgen.lua  # 档案区世界生成
├── retrofit_savedata.lua # 存档数据改造
│
├── levels/              # 关卡配置文件
├── rooms/               # 42 个房间定义文件
├── tasks/               # 10 个任务定义文件
├── tasksets/            # 任务集配置
└── static_layouts/      # 340 个静态布局文件
```

### 1.2 世界生成流程

```
1. settings.lua     → 读取世界设置（大小、季节等）
2. level.lua        → 初始化关卡
3. terrain.lua      → 生成地形基础
4. graphnode.lua    → 创建房间图节点
5. rooms.lua        → 定义房间内容
6. tasks.lua        → 执行生成任务
7. static_layout.lua → 放置静态结构
8. pointsofinterest.lua → 标记特殊位置
```

---

## 2. 地形系统 (terrain.lua)

### 2.1 地形类型

| 地形 ID | 名称 | 说明 |
|---------|------|------|
| `GROUND.ROAD` | 道路 | 移动速度加成 |
| `GROUND.ROCKY` | 岩石地 | 矿区 |
| `GROUND.DIRT` | 泥土 | 普通地面 |
| `GROUND.SAVANNA` | 稀树草原 | 草原生态 |
| `GROUND.GRASS` | 草地 | 绿色草地 |
| `GROUND.FOREST` | 森林 | 森林生态 |
| `GROUND.MARSH` | 沼泽 | 湿地生态 |
| `GROUND.WOODFLOOR` | 木地板 | 人造地面 |
| `GROUND.CARPET` | 地毯 | 人造地面 |
| `GROUND.CHECKER` | 棋盘 | 人造地面 |
| `GROUND.SAND` | 沙地 | 沙漠生态 |
| `GROUND.OCEAN` | 海洋 | 水域 |
| `GROUND.DECIDUOUS` | 落叶林 | 秋季森林 |
| `GROUND.DESERT_DIRT` | 沙漠土 | 绿洲沙漠 |
| `GROUND.FUNGUS` | 菌地 | 洞穴菌类区 |
| `GROUND.CAVE` | 洞穴 | 洞穴地面 |
| `GROUND.MUD` | 泥地 | 洞穴泥地 |
| `GROUND.UNDERROCK` | 岩下 | 洞穴岩石 |
| `GROUND.PEAT` | 泥炭 | 沼泽变体 |
| `GROUND.SHELLBEACH` | 贝壳海滩 | 海洋生态 |
| `GROUND.METEOR` | 陨石 | 陨石区 |
| `GROUND.LUNARROCK` | 月岩 | 月岛 |
| `GROUND.MOONLAND` | 月地 | 月岛 |

### 2.2 地形属性

```lua
-- 每种地形可以设置
GROUND_TYPE = {
    name = "forest",
    turf_id = "FOREST",
    -- 移动速度修正
    -- 可建造性
    -- 视觉样式
}
```

---

## 3. 世界设置 (settings.lua)

### 3.1 世界大小预设

| 预设 | 说明 |
|------|------|
| `small` | 小型世界 |
| `medium` | 中型世界（默认） |
| `large` | 大型世界 |
| `huge` | 巨型世界 |

### 3.2 自定义世界选项

在创建世界时可自定义的选项（通过 `customise.lua`）：
- 季节长度
- 昼夜长度
- 资源密度
- 生物密度
- Boss 数量
- 特殊事件开关
- 起始资源

### 3.3 世界预设 (Presets)

```lua
-- levels.lua 中定义
SURVIVAL_TOGETHER = {
    id = "SURVIVAL_TOGETHER",
    name = "生存",
    location = "forest",
    -- 世界生成参数
}
```

---

## 4. 地图生成核心概念

### 4.1 图节点 (GraphNode)

```lua
-- graphnode.lua
GraphNode = {
    id,           -- 节点 ID
    x, y,         -- 位置
    type,         -- 节点类型
    edges,        -- 连接的边
    room,         -- 关联的房间
    tasks,        -- 关联的任务
}
```

### 4.2 房间 (Room)

```lua
-- rooms.lua
Room = {
    name,         -- 房间名称
    value,        -- 权重
    tags,         -- 标签
    contents,     -- 内容定义
    -- 包含:
    --   countprefabs: 预制体分布
    --   distributepercent: 分布百分比
    --   prefabdata: 预制体数据
}
```

### 4.3 任务 (Task)

```lua
-- tasks.lua
Task = {
    name,         -- 任务名称
    locks,        -- 前置条件（锁）
    keys_given,   -- 解锁的键
    room_tags,    -- 需要的房间标签
    room_choices, -- 房间选择
    room_bg,      -- 背景房间
}
```

### 4.4 静态布局 (StaticLayout)

静态布局是预定义的建筑/结构排列，340+ 个布局定义了各种套装、营地、遗迹等。

```lua
-- static_layout.lua
StaticLayout = {
    -- 布局数据
    -- 相对位置
    -- 预制体列表
    -- 装饰物
}
```

---

## 5. 生态区 (Biomes)

### 5.1 地表生态区

| 生态区 | 主要特征 | 典型资源 |
|--------|----------|----------|
| 森林 | 树多 | 木材、猪人房、蜘蛛巢 |
| 草原 | 草地 | 兔子、草、牛群 |
| 岩石地 | 岩石 | 矿石、高鸟 |
| 沼泽 | 湿地 | 芦苇、触手、鱼人 |
| 沙漠 | 沙地 | 仙人掌、秃鹰、猎犬丘 |
| 绿洲沙漠 | 沙漠+湖 | 绿洲、蚁狮 |
| 落叶林 | 秋色树林 | 桦树、猪王、格罗姆 |
| 月岛 | 月球地形 | 月岩、月树、变异生物 |
| 海洋 | 水域 | 鱼群、盐矿、海上垃圾 |

### 5.2 洞穴生态区

| 生态区 | 主要特征 |
|--------|----------|
| 菌类区 | 蓝/红/绿蘑菇林 |
| 蝙蝠区 | 蝙蝠洞、石笋 |
| 蜘蛛区 | 蜘蛛巢、洞穴蜘蛛 |
| 兔人区 | 兔人房、胡萝卜 |
| 遗迹区 | 损坏的发条装置、铥矿 |
| 中庭 | 远古守护者、远古大门 |

---

## 6. 特殊位置 (Point of Interest)

### 6.1 强制生成的特殊位置

| 位置 | 文件 | 说明 |
|------|------|------|
| 猪王 | `pointsofinterest.lua` | 落叶林中心 |
| 格罗姆雕像 | `pointsofinterest.lua` | 落叶林 |
| 麦斯威尔之门 | `pointsofinterest.lua` | 世界中心 |
| 月石 | `pointsofinterest.lua` | 森林 |
| 虫洞 | `pointsofinterest.lua` | 成对生成 |
| 复活石 | `pointsofinterest.lua` | 散落各处 |

### 6.2 起始位置 (Start Locations)

```lua
-- startlocations.lua
-- 定义玩家生成点
-- 确保生成在安全区域（有资源、无危险）
-- 多人模式下分散生成
```

---

## 7. 资源生成

### 7.1 资源簇 (Bunches)

```lua
-- bunches.lua
-- 定义资源如何成群生成
Bunch = {
    prefab,       -- 预制体名称
    count,        -- 数量
    radius,       -- 分布半径
    spacing,      -- 间距
}
```

### 7.2 受保护资源 (Protected Resources)

```lua
-- protected_resources.lua
-- 确保某些关键资源一定存在
-- 例如：燧石、树枝、草
```

### 7.3 资源替换 (Resource Substitution)

```lua
-- resource_substitution.lua
-- 根据世界设置替换资源
-- 例如：无草世界用树枝替代
```

---

## 8. Mod 开发参考

### 8.1 添加自定义生态区

```lua
-- 在 modmain.lua 中
AddRoomPreInit("MyCustomRoom", function(room)
    room.contents.countprefabs = {
        my_custom_tree = 5,
        my_custom_rock = 3,
    }
end)
```

### 8.2 添加自定义任务

```lua
-- 注册新任务类型
AddTask("MyCustomTask", {
    locks = { LOCKS.NONE },
    keys_given = { KEYS.MY_CUSTOM_KEY },
    room_tags = { "my_custom_tag" },
    room_choices = {
        MyCustomRoom = 1,
    },
})
```

### 8.3 添加静态布局

```lua
-- 注册静态布局
StaticLayouts["my_custom_layout"] = {
    -- 布局数据
}
```

### 8.4 修改世界生成设置

```lua
-- 修改世界预设
GLOBAL.levels.CUSTOM_PRESET = {
    id = "CUSTOM_PRESET",
    name = "自定义世界",
    location = "forest",
    -- ...
}
```

---

## 9. 海洋生成 (ocean_gen.lua)

### 9.1 海洋生态区

| 生态区 | 说明 |
|--------|------|
| 近海 | 浅水区，靠近陆地 |
| 中海 | 中等深度 |
| 深海 | 深水区 |
| 暗礁 | 岩石水域 |
| 盐矿 | 盐矿区域 |
| 海草林 | 海草森林 |
| 沉船区 | 沉船残骸 |

### 9.2 海洋特殊结构

- 猴岛 (`monkeyisland_worldgen.lua`)
- 水木 (`waterlog_worldgen.lua`)
- 月岛连接
- 海堆
