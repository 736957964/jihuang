# 饥荒创意工坊深度研读报告：ActionQueue Reborn（行为队列与批量框选执行引擎）

- **模组标识**：`1608191708` (`ActionQueue Reborn / 行为队列`)
- **作者**：eXiGe / simplex
- **版本**：v1.050
- **领域分类**：纯客户端预测队列调度器（Client-Only Action Scheduler）、屏幕到世界仿射框选（SelectionBox）、协程级动作管道（Action Thread）、断点保护与手控打断补偿
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 1200+ 行 `actionqueuer.lua`、空间几何工具与完整交互切面）

---

## 一、架构全貌与顶层设计思想

在饥荒原版中，玩家砍树、采草、种地、铺草皮、杀影怪都需要单次频繁点击，极易造成操作疲劳。许多劣质连点器 Mod 容易在客机上因网络延迟导致“角色反复原地空挥、挥空后卡死、被怪物打断后疯狂抽搐”。

`ActionQueue Reborn` 是饥荒史上最成熟、被数百万玩家誉为“改变游戏体验”的客户端调度引擎。它的核心架构设计精髓在于：
1. **客户端动作预测（BufferedAction Client Dispatch）**：全过程由客机驱动，通过 `SendAction` 模拟玩家真实输入；
2. **多线程协程流水线（Thread-based Coroutine Pipeline）**：使用 `TheWorld:StartThread` 拆分选择线程（`selection_thread`）与执行线程（`action_thread`）；
3. **空间网格与几何框选（Geo-Spatial Selection）**：将屏幕鼠标拖拽框映射到世界空间凸多边形，批量萃取可交互实体；
4. **中断感知与状态机守卫（StateGraph Interruption Guard）**：实时感知玩家移动键打断、被击飞状态，并在动作执行间隙自动注入微小节流帧。

---

## 二、四大硬核核心技术解构

### 1. 屏幕视口到世界空间的凸多边形框选投影（SelectionBox Geometry）
- **痛点**：玩家在 2.5D 透视投影下倾斜框选，如何精确判定哪些三维世界实体落入当前鼠标拖拽的矩形框？
- **解法**：在 `geoutil.lua` 与 `actionqueuer.lua` 中：
  - 取鼠标按下点（`start_pos`）与当前拖拽点（`end_pos`）；
  - 结合当前摄像机朝向（`TheCamera:GetHeading()`），推导出世界坐标系的 4 个角点向量；
  - 构造世界多边形，利用点在多边形内部检测算法（Point-in-Polygon），高效从 `TheSim:FindEntities` 中过滤出合规实体并打上高亮标记！

### 2. 双协程管道隔离（Selection vs Action Thread）
- **选择线程（`selection_thread_id`）**：在鼠标按住拖拽期间运行，每隔 0.1 秒刷新框选范围并动态追加/移除非法目标；
- **执行线程（`action_thread_id`）**：在鼠标释放（`OnUp`）后启动，遍历 `selected_ents` 队列：
  ```lua
  self.action_thread = self.inst:StartThread(function()
      while next(self.action_queue) and not self:IsWalkButtonDown() do
          local act = table.remove(self.action_queue, 1)
          if self:CanPerformAction(act) then
              self:SendAction(act)
              -- 等待动作开始与完成状态
              self:WaitActionComplete(act)
          end
      end
      self:ClearActionThread()
  end)
  ```
  通过状态机事件（如 `actionfailed`、`performaction`）作为挂起与恢复的信号，杜绝死循环与主线程卡死。

### 3. 手动干预即时打断补偿（Walk Interruption Guard）
- 当角色在排队砍树期间突然遭到 Boss 袭击或危险时，玩家的第一反应是按 WASD 逃跑。
- MOD 在每个动作循环开头显式检测 `self:IsWalkButtonDown()`：
  一旦捕获到移动输入，立即触发 `ClearActionThread()` 并清空整个队列，瞬间归还玩家全部操控权，零延迟逃生！

### 4. 连续种植/放置的网格步长防穿插（Deploy Spacing Engine）
- 对于墙壁（`wall` 间距 1）、陷阱（`trap` 间距 2）、草皮（`turf` 间距 4）等部署物，MOD 维护了严格的 `deploy_spacing` 规则表。
- 在框选大片区域时，根据几何间距自动在世界空间内均匀点阵化生成放置坐标点，并联动 `builder:CanBuildAtPoint` 预检，确保部署物排列整齐划一。

---

## 三、避坑实战经验

1. **客户端发送 Action 的网络丢包补偿**：
   - 在高延迟客机（Ping > 150ms）上，客户端发送 `SendAction` 后，服务端需要数个网络物理帧才能响应。如果客户端直接在下一帧发送下一个动作，会导致前一个动作被服务端直接丢弃。必须在 `action_thread` 中监听 `ThePlayer.sg` 状态切换到 `busy` 之后，方可放行下一个操作。
2. **`unselectable_tags` 性能黑名单**：
   - 在框选查询时，必须带上 `{"DECOR", "FX", "INLIMBO", "NOCLICK", "player"}` 等标签黑名单，过滤掉特效、阴影、光晕与自身，防止每秒框选处理上千个无意义实体造成 GPU 渲染管线卡顿。
