# 饥荒创意工坊深度研读报告：Fast Travel GUI（图形化路标传送网与端到端同步架构）

- **模组标识**：`1530801499` (`Fast Travel (GUI) / 图形化快速旅行`)
- **作者**：SoraYuki
- **版本**：v1.10
- **领域分类**：网络复制组件架构（`AddReplicableComponent`）、全服拓扑发现（`ALL_TRAVELABLES`）、全屏非暂停 UI 对话框（`OpenScreenUnderPause`）、动态物理距离-季节能耗折算模型（DistToCost）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整网络副本组件、Classified 预制体与 UI 视窗源码）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，随着基地与农田规模扩大，跑图往往消耗大量时间。然而很多劣质传送 Mod 采用全屏无脑点击即走，容易引发：
1. **脱战与违规逃逸**：被猎犬围攻或身上着火时瞬间瞬移；
2. **客机端 UI 与服务端物理位置脱节**：客机不知道有哪些路标，选定目标后服务端无法权威校验；
3. **开销失真**：传送不消耗资源破坏生存内核。

`Fast Travel (GUI)` 是饥荒联机版工坊在**跨端网络组件化（Replicable Component Pattern）**与**沉浸式 UI 交互**方面的标杆巨作：
1. **官方级主客双端组件架构（Replica Pipeline）**：注册 `travelable` 与 `travelable_replica`，借助伴生 `travelable_classified` 实现路标列表与玩家绑定的网络同步；
2. **全服拓扑自维护池（Global Node Topology）**：在组件实例化时自注册入 `ALL_TRAVELABLES`，销毁时自动退网；
3. **安全与环境感知判定网**：集成严密的燃烧状态、猎犬围攻告警、怪物近身仇恨检测；
4. **动态欧几里得距离与季节能耗算法**：根据几何位移换算饱食度与理智扣减，并在冬季增加理智惩罚（1.25x），完美契合原版生存逻辑！

---

## 二、四大硬核核心技术解构

### 1. 跨端复制组件标准设计（Replicable Component Pattern）
- **痛点**：客机需要知道路标的所有者权限以及当前交互者，但不能直接读取服务端组件。
- **解法**：在 `modmain.lua` 注册官方级复制组件：
  ```lua
  AddReplicableComponent("travelable")
  ```
  配合伴生的 `travelable_replica.lua` 与 `travelable_classified.lua`：
  - 构造时打上 `_travelable` 占位标签；
  - 服务端实例化后解除占位，正式生成权威 `travelable`，并将当前使用者（`traveller`）通过 `net_entity` 广播至客机；
  - 客机 `travelable_replica` 感知到自身被绑定后，安全弹出 `screens/playerhud:ShowTravelScreen`。

### 2. 纯客户端非侵入 UI 视窗挂载（`OpenScreenUnderPause`）
- 很多开发者弹出界面时直接调用 `TheFrontEnd:PushScreen`，导致在联机模式下手柄或聊天键焦点锁死。
- MOD 拦截 `screens/playerhud`：
  ```lua
  self.ShowTravelScreen = function(_, attach)
      self.travelscreen = TravelScreen(self.owner, attach)
      self:OpenScreenUnderPause(self.travelscreen)
      return self.travelscreen
  end
  ```
  使用 HUD 的 `OpenScreenUnderPause` 挂载，既允许在单机房间暂停背景，又能在联机服作为普通非模态覆盖层运行，支持 ESC 键毫秒级关闭。

### 3. 全局路标拓扑与字母排序拓扑网（Topological Destination Discovery）
- 在 `Travelable:ListDestination(traveller)` 中：
  - 遍历全局静态缓存 `ALL_TRAVELABLES`；
  - 校验玩家私有权限（`uid_private` 与 `uid_<userid>`）；
  - 联动 `writeable` 木牌组件获取路标的玩家手写自定义名称（`writeable:GetText()`）；
  - 按照 ASCII/字母顺序进行字典排序并标号，构造整齐的换乘站点索引。

### 4. 战栗危险防逃逸与季节能耗模型（Danger Guard & DistToCost）
- **战斗逃逸防护（`IsNearDanger`）**：
  在触发传送前，强制校验：
  - `TheWorld.components.hounded:GetWarning()`（猎犬来袭警告中禁止传送）；
  - `traveller.components.burnable:IsBurning()`（着火中禁止传送）；
  - 10 码范围内是否存在以玩家为仇恨目标的敌对生物（`combat.target == traveller`）。
- **物理距离衰减算法**：
  $$\text{HungerCost} = \text{Clamp}(5 + \frac{\text{Distance}}{32}, 5, 75)$$
  结合冬季严寒理智损耗放大（$1.25\times$），赋予传送沉重的代价感，平衡性拉满。

---

## 三、避坑实战经验

1. **`travelable` 必须在销毁时主动退网**：
   - 当路标被锤子砸碎或烧毁时，如果漏写 `OnRemoveFromEntity` 从 `ALL_TRAVELABLES` 中注销，其它路标的传送列表里依然会显示该幽灵路标，玩家传送过去会掉入虚空或报错。
2. **ModRPC 权限双重防御**：
   - 客户端点击 UI 后通过 `SendModRPCToServer(MOD_RPC["FastTravel"]["Travel"], inst, index)` 发起传送。服务端收到请求时**绝对不能无条件放行**，必须重新校验 `player` 是否仍在路标交互范围内且满足 `IsNearDanger` 判定，严禁信任客户端下发的免伤伪造包。
