# 饥荒创意工坊深度研读报告：Wormhole Marks（虫洞双向配对标记与地图图标切面）

- **模组标识**：`362175979` (`Wormhole Marks / 虫洞标记`)
- **作者**：_Q_
- **版本**：v1.4.5
- **领域分类**：实体拓扑对偶配对（Dual Topology Mapping）、MiniMapEntity 地图动态切面、雾层穿透渲染（DrawOverFogOfWar）、世界级单例计数持久化
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含提取解压后的完整组件与图集资源）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，虫洞（Wormhole）两两成对分散在广袤的世界各处。原版所有虫洞在小地图上都长得一模一样，玩家若不借助外部笔记，极难分清跳入后会被传送到何方。

`Wormhole Marks` 采用了一套极其优雅紧凑的**对偶拓扑感知引擎（Dual Topology Engine）**：
1. **世界单例序列号生成器（`wormhole_counter`）**：挂载在 `TheWorld`（仅森林世界主域），负责分配递增的虫洞通道 ID（1~22）；
2. **虫洞伴生标记组件（`wormhole_marks`）**：挂载在每一个 `wormhole` 预制体上；
3. **跳跃触发与对偶穿透**：玩家跳入虫洞触发 `starttravelsound` 事件时，同时为当前入口与远端出口（`targetTeleporter`）打上相同的数字标记！

---

## 二、四大硬核核心技术解构

### 1. 对偶实体事件穿透与配对原子操作（Dual Entity Atomicity）
- **痛点**：若只在玩家跳出时标记出口，如果玩家在半途掉线或在洞穴/地表穿梭，可能导致入口被标记而出口未被标记，数字序列永久错位。
- **解法**：在入口处捕获 `starttravelsound` 音效事件（即玩家跃入虫洞的瞬间）：
  ```lua
  local function Mark(inst)
      -- 1. 标记当前入口
      if not inst.components.wormhole_marks:CheckMark() then
          inst.components.wormhole_marks:MarkEntrance()
      end
      -- 2. 穿透 teleporter 抓取对偶出口实体
      local other = inst.components.teleporter.targetTeleporter	
      if other and not other.components.wormhole_marks:CheckMark() then
          other.components.wormhole_marks:MarkExit()
      end
  end
  ```
  在 `MarkExit` 内部才调用 `TheWorld.components.wormhole_counter:Set()` 自增计数器，保证了一对虫洞严格共享同一个序列号，原子性坚不可摧！

### 2. 动态 MiniMap 图标实时切换与迷雾穿透（DrawOverFogOfWar）
- 饥荒的 `MiniMapEntity` 允许在运行时动态改写贴图：
  ```lua
  self.inst.MiniMapEntity:SetIcon("mark_" .. self.wormhole_number .. ".tex")
  ```
- **配置项穿透迷雾**：
  原版小地图未探索区域会被黑色迷雾覆盖。MOD 通过调用引擎底层：
  ```lua
  self.inst.MiniMapEntity:SetDrawOverFogOfWar(true)
  ```
  允许远端出口即使位于尚未探索的黑雾区域，依然能够在地图上清晰展示其对应标号，彻底提升探图导航体验。

### 3. 主从世界严格校验与森林过滤（Tag & MasterSim Guard）
- 虫洞计数器只能存在于森林地表世界，洞穴没有虫洞（有触手洞）。
  - 在 `WorldPrefabPostInit` 中：
    ```lua
    if inst:HasTag("forest") then
        inst:AddComponent("wormhole_counter")
    end
    ```
  - 在组件构造器中强制断言：
    ```lua
    assert(TheWorld.ismastersim, "Wormhole_Counter should not exist on client")
    ```
    杜绝在客机或未完全初始化的洞穴世界中误挂载引发崩溃。

### 4. 读档恢复与 MiniMapEntity 懒加载初始化
- 在 `OnLoad` 阶段，实体刚从磁盘反序列化出来时，其 `MiniMapEntity` 可能尚未完全装配：
  ```lua
  if self.marked and self.wormhole_number then
      self.inst.entity:AddMiniMapEntity() -- 确保存在
      self.inst.MiniMapEntity:SetIcon("mark_" .. self.wormhole_number .. ".tex")
  end
  ```
  通过显式声明 `AddMiniMapEntity` 避免了存档热重载时找不到组件的空指针隐患。

---

## 三、避坑实战经验

1. **`targetTeleporter` 跨维度为 nil 的情况**：
   - 如果使用了某些魔改多世界/洞穴直通虫洞 MOD，`inst.components.teleporter.targetTeleporter` 可能会返回 nil（其目标是在另一个 shard 甚至未加载的片区）。在调用 `other.components.wormhole_marks` 前必须加 `if other ~= nil then` 判空，防止解包野指针报错。
2. **图集注册的配额上限**：
   - MOD 注册了 22 组独立 Atlas 图集（`AddMinimapAtlas("images/mark_X.xml")`）。对于常规中小型地图，22 对虫洞绰绰有余；如果超大世界虫洞数量超过 22，必须使用模运算循环复用数字（`number % 22 + 1`），避免找不到贴图变紫块。
