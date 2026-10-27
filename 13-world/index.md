# 13 - World 世界系统

> **源码位置**: `scripts/map/` — 地图生成系统  
> **核心文件**: `scripts/gamelogic.lua`、`scripts/worldgen_main.lua`  
> **世界 Prefab**: `scripts/prefabs/world.lua`、`scripts/prefabs/cave.lua`、`scripts/prefabs/forest.lua`

## 1. 世界系统概述

DST 的世界系统负责管理游戏世界的生成、状态、时间流逝以及各类全局事件。世界分为**森林世界**和**洞穴世界**两个独立维度。

### 世界层级结构

```
World (TheWorld)
├── Map (TheWorld.Map)        -- 地图数据
├── State (TheWorld.state)    -- 世界状态
├── PushEvent / ListenForEvent -- 全局事件系统
├── components/               -- 世界级组件
│   ├── worldsettingstimer    -- 世界设置计时器
│   ├── clock                 -- 时钟
│   ├── seasonmanager         -- 季节管理
│   ├── weather               -- 天气
│   └── ...                   -- 其他
└── prefabs/world.lua         -- 世界 Prefab
```

---

## 2. 世界状态 (World State)

### 2.1 状态变量

世界状态通过 `TheWorld.state` 访问，核心状态包括：

```lua
TheWorld.state.phase           -- "day"/"dusk"/"night" 昼夜阶段
TheWorld.state.time            -- 当前时间（一天为 1 单位）
TheWorld.state.timeinphase     -- 当前阶段已持续时间
TheWorld.state.cycles          -- 总天数
TheWorld.state.season          -- 当前季节
TheWorld.state.elapseddaysinseason -- 当前季节已过天数
TheWorld.state.remainingdaysinseason -- 季节剩余天数
TheWorld.state.isday           -- 是否白天
TheWorld.state.isdusk          -- 是否黄昏
TheWorld.state.isnight         -- 是否夜晚
TheWorld.state.issummer        -- 是否夏天
TheWorld.state.iswinter        -- 是否冬天
TheWorld.state.isspring        -- 是否春天
TheWorld.state.isautumn        -- 是否秋天
TheWorld.state.israining       -- 是否下雨
TheWorld.state.issnowing       -- 是否下雪
TheWorld.state.issnowcovered   -- 是否积雪覆盖
TheWorld.state.moisturelevel   -- 湿度等级
TheWorld.state.temperature     -- 环境温度
TheWorld.state.moonphase       -- 月相
TheWorld.state.wetness         -- 湿度
```

### 2.2 时间系统

```lua
-- 一天 = 480 秒 = 8 分钟（默认）
TUNING.TOTAL_DAY_TIME           -- 一天总时长
TUNING.SEG_TIME                 -- 每段时间段

-- 阶段
-- 白天: 0 → day_segs
-- 黄昏: day_segs → day_segs + dusk_segs
-- 夜晚: day_segs + dusk_segs → 16

TheWorld:PushEvent("daytime")    -- 进入白天事件
TheWorld:PushEvent("dusktime")   -- 进入黄昏事件
TheWorld:PushEvent("nighttime")  -- 进入夜晚事件
```

### 2.3 季节系统

```lua
-- 季节常量
SEASONS.AUTUMN    -- 秋
SEASONS.WINTER    -- 冬
SEASONS.SPRING    -- 春
SEASONS.SUMMER    -- 夏

-- 季节事件
TheWorld:PushEvent("seasonChange")   -- 季节变更
TheWorld:PushEvent("beginautumn")    -- 入秋
TheWorld:PushEvent("beginwinter")    -- 入冬
TheWorld:PushEvent("begindspring")   -- 入春
TheWorld:PushEvent("beginsummer")    -- 入夏
```

---

## 3. 地图系统 (Map)

### 3.1 Map 对象方法

```lua
TheWorld.Map:GetTileAtPoint(x, y, z)       -- 获取坐标处地皮类型
TheWorld.Map:IsPassableAtPoint(x, y, z)     -- 坐标是否可通过
TheWorld.Map:IsOceanAtPoint(x, y, z)        -- 坐标是否海洋
TheWorld.Map:IsGroundTargeted(x, y, z)      -- 坐标是否为地面
TheWorld.Map:GetTileSize()                   -- 地皮尺寸
TheWorld.Map:IsVisualGroundAtPoint(x, y, z)  -- 视觉地面检查
```

### 3.2 地图生成 (WorldGen)

地图在创建世界时通过 `worldgen_main.lua` 生成：

```lua
-- 地图层级
LEVEL_FOREST   -- 森林层
LEVEL_CAVE     -- 洞穴层

-- 地图生成流程
-- 1. 选择关卡配置 (levels.lua)
-- 2. 生成地形 (terrain)
-- 3. 放置房间 (rooms)
-- 4. 生成物体布局 (object_layout)
-- 5. 生成静态布局 (static_layouts)
-- 6. 生成生物群落 (biomes)
```

### 3.3 世界配置 (World Settings)

```lua
-- 世界生成预设
worldgen_presets = {
    SURVIVAL_DEFAULT,
    SURVIVAL_TOGETHER,
    MOD_MISSING,
    CUSTOM,
}
```

---

## 4. 世界事件

### 4.1 周期性事件

| 事件 | 触发时机 | 描述 |
|------|---------|------|
| `daytime` | 进入白天 | 开始新的一天 |
| `dusktime` | 进入黄昏 | 黄昏开始 |
| `nighttime` | 进入夜晚 | 夜晚开始 |
| `seasonChange` | 季节变更 | 季节切换 |
| `phasechanged` | 阶段变化 | 昼夜阶段变化 |
| `cycleschanged` | 天数变化 | 经过一天 |

### 4.2 天气事件

| 事件 | 触发时机 | 描述 |
|------|---------|------|
| `rainstart` | 开始下雨 | 降雨开始 |
| `rainstop` | 雨停 | 降雨停止 |
| `startraining` | 降雨阶段 | 持续下雨 |
| `startSnowing` | 开始下雪 | 降雪开始 |
| `stopsnowing` | 雪停 | 降雪停止 |

### 4.3 世界状态变化

| 事件 | 触发时机 | 描述 |
|------|---------|------|
| `israining` | 状态变化 | 是否下雨状态改变 |
| `issnowing` | 状态变化 | 是否下雪状态改变 |
| `issnowcovered` | 状态变化 | 积雪覆盖状态改变 |
| `moisturelevel` | 状态变化 | 湿度等级变化 |
| `moisturelevelchanged` | 状态变化 | 湿度等级改变 |
| `temperature` | 状态变化 | 温度变化 |

---

## 5. 世界级组件

### 5.1 时钟 (Clock)

```lua
TheWorld.components.clock

-- 获取当前时间
clock:GetTime()          -- 当前游戏时间
clock:GetPhase()         -- "day"/"dusk"/"night"
clock:GetTimeInPhase()   -- 当前阶段已过时间
clock:GetNumCycles()     -- 已过天数
clock:GetMoonPhase()     -- 月相
```

### 5.2 季节管理器 (SeasonManager)

```lua
TheWorld.components.seasonmanager

seasonmanager:GetSeason()           -- 当前季节
seasonmanager:GetSeasonLength()     -- 季节长度
seasonmanager:GetElapsed()          -- 季节已过时间
seasonmanager:GetRemaining()        -- 季节剩余时间
seasonmanager:SetSeason(season)     -- 设置季节
seasonmanager:SetSeasonLength(length) -- 设置季节长度
```

### 5.3 天气 (Weather)

```lua
TheWorld.components.weather

weather:IsRaining()       -- 是否下雨
weather:IsSnowing()       -- 是否下雪
weather:GetMoistureLevel() -- 湿度等级
weather:GetMoisture()     -- 当前湿度
weather:GetPrecipitationRate() -- 降雨率
```

---

## 6. 世界 Prefab

### 6.1 森林世界 (forest)

```lua
-- scripts/prefabs/forest.lua
local function fn()
    local inst = CreateEntity()
    -- 基础实体设置
    inst.entity:AddTransform()
    -- 添加世界级组件
    inst:AddComponent("clock")
    inst:AddComponent("seasonmanager")
    inst:AddComponent("weather")
    inst:AddComponent("worldsettingstimer")
    inst:AddComponent("timer")
    -- 设置网络
    inst:AddComponent("playerstatuswatcher")
    inst:AddComponent("areawarning")
    inst:AddComponent("resettimer")
    -- ...
    return inst
end
```

### 6.2 洞穴世界 (cave)

```lua
-- scripts/prefabs/cave.lua
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    -- 洞穴特有的组件
    inst:AddComponent("earthquake")
    inst:AddComponent("batspawner")
    -- ...
    return inst
end
```

---

## 7. 世界常用全局变量

```lua
TheWorld                 -- 当前世界实体
TheWorld.ismastersim     -- 是否服务端
TheWorld.state           -- 世界状态
TheWorld.Map             -- 地图对象
TheWorld.net             -- 网络对象
TheWorld.components      -- 世界级组件
```

---

## 8. 世界生成自定义

### 8.1 世界生成覆写

```lua
-- worldgenoverride.lua
return {
    override_enabled = true,
    preset = "SURVIVAL_TOGETHER",
    unprepared = {
        season_start = "default",
        day = "default",
        weather = "default",
        -- ...
    },
    worldgen_preset = "SURVIVAL_DEFAULT_PLUS",
}
```

### 8.2 Mod 中修改世界生成

```lua
-- modworldgenmain.lua
AddLevelPreInit(LEVEL_FOREST, function(level)
    -- 在地图生成前修改关卡设置
    level:SetOverrideLevelData({...})
end)

AddTaskPreInit(LEVEL_FOREST, "任务名", function(task)
    -- 修改特定生成任务
end)
```
