# 饥荒创意工坊深度研读报告：Global Positions（全球定位与地图共享）

- **模组标识**：`378160973` (`Global Positions / 全球定位`)
- **作者**：rezecib
- **版本**：v2.2.0
- **领域分类**：全域网络信标（Classified Entity）、非主客视距穿透同步、迷雾地图互通序列化（MapExplorer）、实时 Ping 标点交互系统
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 951 行 `modmain.lua` 与完整网络组件、Ping 控件预制体）

---

## 一、架构全貌与顶层设计思想

在原版饥荒联机版中，当两名玩家相距超过 15~20 码时，客机会因为**视距裁剪（Entity Sleep / Limbo）**彻底失去对远方队友实体的感知：不仅屏幕边缘的头像指示器（TargetIndicator）会消失，大地图上也无法实时看到队友动态，更无法感知队友已探索的地图迷雾。

`Global Positions` 的核心架构成就，是创造性地引入了 **Classified 伴生轻量网络信标实体机制** 与 **Dedicated 独立世界地图探索器（WorldMapExplorer）**，在极低网络带宽占用下打破了视距阻隔，实现了全图视距穿透与全队迷雾互通！

---

## 二、四大硬核核心技术解构

### 1. 轻量化伴生信标架构（`globalposition_classified`）
- **痛点**：如果强行把玩家实体设为全图不休眠（`SetCanSleep(false)`），远端上千个实体动作帧与物理碰撞会把客户端直接卡死。
- **解法**：为每个玩家与篝火派生一个隐形的微型网络信标实体：
  ```lua
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddNetwork()
  inst.entity:Hide()
  inst:AddTag("CLASSIFIED")
  inst.entity:SetCanSleep(false) -- 信标常驻不休眠
  ```
  该信标不挂载任何模型、物理和大型组件，仅包含 5 个 NetVar 属性：
  - `parentprefab`: 宿主 Prefab 名（用于图标索引）
  - `parententity`: 宿主句柄（`net_entity`）
  - `userid`: 玩家 Steam ID（`net_string`）
  - `portraitdirty`: 头像脏标记事件（`net_event`）
  每帧仅传输几字节的坐标向量，客户端通过监听该微型信标即可在大地图和屏幕边缘完美驱动雷达追踪！

### 2. 团队迷雾互通与序列化传承（Shared Map Exploration）
- **痛点**：专用服务器（Dedicated Server）本身是没有真实屏幕和玩家视口的，其底层默认不维护全图迷雾缓存。
- **神级突破**：MOD 在 Dedicated 专服上强行实例化了一个虚拟地图探索者 `worldmapexplorer`：
  ```lua
  TheWorld.worldmapexplorer.MapExplorer:LearnRecordedMap(data.worldmap)
  ```
  1. **渐进式聚合**：专服作为团队地图的集中存储中心，收集所有玩家上传的已探索迷雾二进制块（`MapExplorer:RecordMap()`）；
  2. **新玩家下发**：当新玩家或掉线重连的队友加入世界时，专服自动将当前合并后的全队地图打包下发，调用客户端 `LearnRecordedMap` 一键点亮全队已探索迷雾！
  3. **异步重试容错（TryLoadingWorldMap）**：巧妙处理了世界加载初期的网络时序问题，若专服网络未就绪则在 `inst:DoTaskInTime(0, TryLoadingWorldMap)` 逐帧重试直至成功。

### 3. 多人战术轮盘 Ping 标点协议
- **轮盘交互与 RPC**：
  在小地图上按住 Alt/Shift 拖拽弹出 `PingWheel`（支持普通 Generic、前往 GoHere、危险 Danger、探索 Explore、赶来 OMW）。
  客户端选定后，通过自定义 ModRPC 将绝对世界坐标与标点类型发送至服务端。
- **标点生命周期管理**：
  服务端接收后生成 `ping_danger` 等实体，同样注入 `globalposition` 伴随组件，并在到达 TTL（默认 10 秒）后触发渐变销毁，实现团队跨屏战术协同。

### 4. 屏幕边缘目标指示器（TargetIndicator）劫持
- 原版 `TargetIndicator` 仅在近距离由原生 C++ 触发。MOD 在客机通过 `ThePlayer.HUD:AddTargetIndicator(classified)`，将远距离信标直接注入 HUD 指示器列表。
- 动态替换其头像贴图与死亡幽灵遮罩（`v:IsGhost() and "avatar_ghost_bg.tex" or "avatar_bg.tex"`），并根据距离平方计算指示器的半透明衰减度。

---

## 三、避坑实战经验

1. **`net_entity` 跨网络时序的 nil 陷阱**：
   - 当信标 `globalposition_classified` 先于玩家实体到达客机时，`inst.parententity:value()` 可能短暂为 nil。因此客机端一切逻辑必须以 `userid` 或字符串形式的 `parentprefab` 作为第一索引，严禁强依赖实体指针。
2. **专服专用判定（`TheNet:IsDedicated()`）**：
   - 地图数据聚合逻辑切忌在客户端或本地单人房运行，必须显式限制在 `TheWorld.ismastersim and TheNet:IsDedicated()` 下，防止单人房主机世界地图与玩家个人地图互相覆盖造成死循环。
