# 全局变量

DST 中有大量全局变量，以下是按分类整理的列表。

## 核心引擎全局

| 变量 | 说明 | 可用时机 |
|------|------|----------|
| `TheSim` | 引擎层接口，最底层的全局对象 | 始终可用 |
| `TheNet` | 网络接口，控制连接、网络状态 | 始终可用 |
| `TheInput` | 输入管理 | 始终可用 |
| `TheInputProxy` | 输入代理（多设备支持） | 始终可用 |
| `TheFrontEnd` | 前端UI管理器 | 启动后 |
| `TheHaptics` | 触觉反馈（手柄震动） | 始终可用 |
| `TheMixer` | 音频混音器 | 始终可用 |
| `TheGameService` | 平台游戏服务（成就等） | 始终可用 |
| `TheSystemService` | 系统服务（服务器管理等） | 始终可用 |
| `TheInventory` | 皮肤库存系统 | 始终可用 |
| `TheSkillTree` | 技能树系统 | 始终可用 |
| `TheCraftingMenuProfile` | 制作菜单配置 | 游戏中 |

## 游戏世界

| 变量 | 说明 | 可用时机 |
|------|------|----------|
| `TheWorld` | 世界实例（Ground实体） | 进入游戏后 |
| `ThePlayer` | 当前玩家实例 | 进入游戏后（客户端） |
| `AllPlayers` | 所有玩家列表 `{player1, player2, ...}` | 服务端 |
| `Ents` | 所有实体表 `{ [guid] = inst }` | 进入游戏后 |
| `NumEnts` | 实体数量 | 进入游戏后 |
| `Prefabs` | 已注册预制体表 `{ [name] = prefab }` | 加载后 |
| `PREFABDEFINITIONS` | 预制体定义表 | 加载后 |

## Mod 管理

| 变量 | 说明 | 可用时机 |
|------|------|----------|
| `ModManager` | Mod管理器 | 启动后 |
| `KnownModIndex` | Mod索引 | 启动后 |
| `MODS_ROOT` | Mod目录路径 | 始终可用 |
| `MODS_ENABLED` | Mod是否启用 | 始终可用 |

## 游戏状态

| 变量 | 说明 |
|------|------|
| `inGamePlay` | 是否在游戏玩法中 |
| `POPULATING` | 是否在填充世界 |
| `Paused` | 是否暂停 |
| `Autopaused` | 是否自动暂停 |
| `SimTearingDown` | 模拟是否正在拆除 |
| `SimShuttingDown` | 模拟是否正在关闭 |
| `PerformingRestart` | 是否正在重启 |
| `exiting_game` | 是否正在退出 |
| `IsIntegrityChecking` | 是否在完整性检查 |
| `HashesMessageState` | 文件哈希状态 |

## 玩家配置

| 变量 | 说明 |
|------|------|
| `Profile` | 玩家配置文件 |
| `Settings` | 游戏实例设置 |
| `Purchases` | 购买信息 |

## 管理器

| 变量 | 说明 |
|------|------|
| `SGManager` | StateGraph 管理器 |
| `BrainManager` | Brain 管理器 |
| `EmitterManager` | 粒子发射器管理器 |
| `TileGroupManager` | 地块组管理器 |
| `ChatHistory` | 聊天历史 |

## 调度器

| 变量 | 说明 |
|------|------|
| `scheduler` | 主调度器（受时间缩放影响） |
| `staticScheduler` | 静态调度器（不受时间缩放影响） |

## 碰撞相关

| 变量 | 说明 |
|------|------|
| `COLLISION` | 碰撞组枚举 |
| `PhysicsCollisionCallbacks` | 物理碰撞回调 |

## 常量表

| 变量 | 说明 | 定义位置 |
|------|------|----------|
| `TUNING` | 游戏数值配置 | `tuning.lua` |
| `ACTIONS` | 动作枚举 | `actions.lua` |
| `EQUIPSLOTS` | 装备槽位枚举 | `constants.lua` |
| `FOODTYPE` | 食物类型枚举 | `constants.lua` |
| `FUELTYPE` | 燃料类型枚举 | `constants.lua` |
| `TECH` | 科技等级枚举 | `constants.lua` |
| `MATERIALS` | 材料类型枚举 | `constants.lua` |
| `COLLISION` | 碰撞组枚举 | `constants.lua` |
| `FONTS` | 字体配置 | `constants.lua` |
| `BGCOLOURS` | 背景颜色 | `constants.lua` |
| `DEGREES` | 弧度转度常量 | `constants.lua` |
| `RADIANS` | 度转弧度常量 | `constants.lua` |
| `STRINGS` | 所有游戏文本 | `strings.lua` |
| `LOC` | 本地化工具 | `loc.lua` |
| `LANGUAGE` | 当前语言 | 始终可用 |

## 平台与分支

| 变量 | 说明 |
|------|------|
| `BRANCH` | 分支名（"dev"/"staging"/"release"） |
| `PLATFORM` | 平台标识（如 "WIN32_STEAM"） |
| `APP_REGION` | 区域（如 "SCEJ"） |
| `CONFIGURATION` | 构建配置 |
| `CURRENT_BETA` | 当前Beta版本号 |
| `PUBLIC_BETA` | 公开Beta版本号 |
| `RUN_GLOBAL_INIT` | 是否运行全局初始化 |
| `CAN_USE_DBUI` | 是否可用调试UI |
| `VERBOSITY_LEVEL` | 日志详细级别 |
| `SOUNDDEBUG_ENABLED` | 声音调试是否启用 |
| `WORLDSTATEDEBUG_ENABLED` | 世界状态调试是否启用 |

## 路径

| 变量 | 说明 |
|------|------|
| `CWD` | 当前工作目录 |

## 特殊事件

| 变量 | 说明 |
|------|------|
| `SPECIAL_EVENT_GLOBAL_PREFABS` | 特殊事件全局预制体列表 |
| `FESTIVAL_EVENT_GLOBAL_PREFABS` | 节日事件全局预制体列表 |

## 网络状态

| 变量 | 说明 |
|------|------|
| `LoadingStates` | 加载状态枚举 |
| `FirstStartupForNetworking` | 是否首次启动网络 |

## Shard 相关

| 变量 | 说明 |
|------|------|
| `ShardGameIndex` | Shard 游戏索引 |
| `TheShard` | 当前 Shard 信息 |

## 更新实体表

| 变量 | 说明 |
|------|------|
| `UpdatingEnts` | 正在更新的实体表 |
| `NewUpdatingEnts` | 新加入更新的实体表 |
| `num_updating_ents` | 正在更新的实体数量 |
| `StaticUpdatingEnts` | 静态更新的实体表 |
| `NewStaticUpdatingEnts` | 新加入静态更新的实体表 |
| `WallUpdatingEnts` | 墙上更新的实体表 |
| `NewWallUpdatingEnts` | 新加入墙上更新的实体表 |

## 文件操作

| 函数/变量 | 说明 |
|------|------|
| `resolvefilepath(file [, modroot])` | 解析文件路径 |
| `resolvefilepath_soft(file [, modroot])` | 软解析文件路径 |

## 数学工具

| 函数 | 说明 |
|------|------|
| `Lerp(a, b, t)` | 线性插值 |
| `math.clamp(val, min, max)` | 值限制 |
| `distsq(x1, z1, x2, z2)` | 距离平方 |
| `GetTableSize(t)` | 获取表大小 |
| `IsTableEmpty(t)` | 表是否为空 |
| `RemoveByValue(t, val)` | 按值移除元素 |
| `shallowcopy(t)` | 浅拷贝 |
| `deepcopy(t)` | 深拷贝 |

## 游戏逻辑

| 函数 | 说明 |
|------|------|
| `IsEntityDeadOrGhost(inst)` | 实体是否死亡或鬼魂 |
| `IsEntityDead(inst)` | 实体是否死亡 |
| `IsAnyPlayerInRange(x, y, z, range, isalive)` | 范围内是否有玩家 |
| `FindClosestPlayer(x, y, z, isalive)` | 找最近玩家 |
| `FindPlayersInRange(x, y, z, range, isalive)` | 找范围内所有玩家 |
| `FindEntity(inst, radius, fn, must_tags, cant_tags)` | 找实体 |
| `Launch(inst, haunter, speed)` | 弹飞实体 |
| `ErodeAway(inst)` | 侵蚀消失 |
| `GetTileInfo(tile)` | 获取地块信息 |
| `ConstructAdjectivedName(inst, name, adjective)` | 构造带形容词的名称 |
| `IsConsole()` | 是否主机平台 |
| `IsNotConsole()` | 是否非主机平台 |
| `IsRail()` | 是否Rail平台 |
| `IsSteamDeck()` | 是否SteamDeck |
| `IsDLCEnabled(dlc)` | DLC是否启用 |
| `EnableAllDLC()` / `DisableAllDLC()` | 启用/禁用所有DLC |

## 资源相关

| 函数 | 说明 |
|------|------|
| `GetBuildForItem(skinname)` | 获取皮肤对应的Build |
| `GetMemoizedFilePaths()` | 获取缓存的文件路径 |

## UI 工具

| 函数 | 说明 |
|------|------|
| `ShowLoading()` | 显示加载画面 |
| `SetGlobalErrorWidget(title, message, buttons, ...)` | 设置全局错误UI |
| `global_error_widget` | 全局错误Widget引用 |

## 其他

| 函数/变量 | 说明 |
|------|------|
| `global(string)` | 声明全局变量（在mod环境中可能需要） |
| `known_assert(condition, error_key)` | 已知断言（带错误key） |
| `TrackedAssert(name, fn, ...)` | 带追踪的断言包装 |
| `RunInSandboxSafe(str)` | 安全沙箱执行字符串 |
| `BuildListOfSelectedItems(profile, key)` | 构建选中项列表 |
| `SerializeUserSession(player)` | 序列化用户会话 |
| `DeactivateWorld()` | 停用世界 |
| `ApplyLocalWordFilter(text, ctx, netid)` | 应用本地词过滤 |
| `GetUniquePotentialCharacterStartingInventoryItems(char, include_backpack)` | 获取角色起始物品 |
| `WasSuUsed()` | SU是否被使用 |
| `IsDynamicCloudShutdown` | 是否动态云端关闭 |
| `IsItemId(skin)` | 是否是物品ID |
| `GetWorldTileMap()` | 获取世界瓷砖映射 |
