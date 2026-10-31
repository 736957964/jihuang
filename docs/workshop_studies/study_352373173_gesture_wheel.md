# 饥荒创意工坊深度研读报告：Gesture Wheel（极坐标扇区映射与手柄模拟量轮盘交互架构）

- **模组标识**：`352373173` (`Gesture Wheel / 动作表情轮盘`)
- **作者**：rezecib
- **版本**：v1.8.2
- **领域分类**：纯客户端模组（`client_only_mod = true`）、极坐标几何学分布（$\theta = \frac{2\pi}{N}$）、手柄模拟量差分采样（Analog Stick Tilt）、鼠标光标跨坐标系还原（Restore Cursor Pipeline）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `gesturewheel.lua`、`gesturebadge.lua` 与输入事件总线切面）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，玩家执行动作表情（Emote）原版需要手动在聊天框敲击字符（如 `/dance`、`/wave`），交互繁琐且极易在战斗或社交中延误时机。

`Gesture Wheel` 是由饥荒 Mod 宗师 **rezecib**（同为几何种植、全局定位作者）打造的**极坐标轮盘交互教科书级神作**：
1. **多环嵌套极坐标排布算法（Multi-Ring Polar Coordinate Distribution）**：支持多套 Emote（基础轮、成就轮、活动轮）按半径自适应分层缩放（`scale = scale * 0.85`），利用三角函数实时计算离散点位；
2. **手柄摇杆差分与盲区判定（Deadzone & Analog Differential Sampling）**：将手柄左右摇杆的模拟量输入进行轴向差分，将二维模拟量投影到单位圆并映射到最近扇区；
3. **鼠标光标上下文智能还原器（Cursor Position Preservation Matrix）**：轮盘开启瞬间将鼠标拉至屏幕圆心，关闭时根据相对位移模式（Relative）或绝对位置模式（Absolute）精准复原鼠标位置，手感极其丝滑！

---

## 二、四大硬核核心技术解构

### 1. 极坐标等分点阵生成器（Polar Distribution Matrix）
- **数学建模**：
  给定总项数 $N$ 与半径 $R$，第 $i$ 个选项的局部坐标分布为：
  $$\Delta\theta = \frac{2\pi}{N}, \quad x_i = R \cdot \cos(i \cdot \Delta\theta), \quad y_i = R \cdot \sin(i \cdot \Delta\theta)$$
- **源码实现**：
  ```lua
  local count = #emotes
  radius = radius * scale
  local delta = 2 * math.pi / count
  local theta = 0
  for i, v in ipairs(emotes) do
      local gesture = wheel:AddChild(GestureBadge(ThePlayer.prefab, v.name, v.anim, image, text, color))
      gesture:SetPosition(radius * math.cos(theta), radius * math.sin(theta), 0)
      gesture:SetScale(scale)
      theta = theta + delta
  end
  ```
  结合递归缩放系数，支持同心圆双环甚至三环无缝平铺，几何美感拉满。

### 2. 双模态距离最近邻匹配（Nearest-Neighbor Hit Detection）
- 轮盘不需要为每个扇区建立复杂的几何网格遮罩，而是巧妙地采用**欧氏距离平方最近邻算法**：
  - **鼠标模式**：计算鼠标当前屏幕坐标到各个 Badge 绝对屏幕投影坐标的距离平方：
    $$D^2 = (P_{\text{badge}}.x - P_{\text{mouse}}.x)^2 + (P_{\text{badge}}.y - P_{\text{mouse}}.y)^2$$
  - **手柄模式**：获取摇杆模拟量向量 $\vec{V} = (V_x, V_y)$，若其模长小于死区阈值（Deadzone $< 0.5$）则判定为未选，否则将其与各扇区单位方向向量做内积与位移比对，毫秒级得出最接近的高亮选中项。

### 3. 摇杆模拟量轴向差分采样（Analog Stick Tilt Sampling）
- 原版手柄驱动将摇杆拆解为四个离散方向量：
  ```lua
  local function GetControllerTilt(right)
      local xdir, ydir = 0, 0
      if right then
          xdir = TheInput:GetAnalogControlValue(CONTROL_INVENTORY_RIGHT) - TheInput:GetAnalogControlValue(CONTROL_INVENTORY_LEFT)
          ydir = TheInput:GetAnalogControlValue(CONTROL_INVENTORY_UP) - TheInput:GetAnalogControlValue(CONTROL_INVENTORY_DOWN)
      else
          xdir = TheInput:GetAnalogControlValue(CONTROL_MOVE_RIGHT) - TheInput:GetAnalogControlValue(CONTROL_MOVE_LEFT)
          ydir = TheInput:GetAnalogControlValue(CONTROL_MOVE_UP) - TheInput:GetAnalogControlValue(CONTROL_MOVE_DOWN)
      end
      return Vector3(xdir, ydir, 0)
  end
  ```
  通过相反控制轴的差值提取出连续的浮点极向矢量，让手柄玩家能够像操作《守望先锋》轮盘一样行云流水。

### 4. 鼠标指针空间坐标还原流水线（Restore Cursor Pipeline）
- **痛点**：呼出轮盘后若光标停在边缘，会导致玩家还没开始选就误判选中某一项；若强行移到中心，松开按键后玩家原来的鼠标瞄准点又丢失了。
- **神级工程解法**：
  - 开启瞬间，记录鼠标绝对屏幕坐标 $P_{\text{saved}}$；
  - 调用 `TheSim:SetMousePos(screen_center_x, screen_center_y)` 将光标硬件级移至轮盘中心；
  - 玩家松开热键瞬间，计算出玩家为了选表情产生的相对位移 $\Delta \vec{M}$；
  - 根据用户配置执行：
    - `Absolute`：直接还原回 $P_{\text{saved}}$；
    - `Relative`：还原至 $P_{\text{saved}} + \Delta \vec{M}$；
  实现了操作与视口瞄准的绝对平滑过渡。

---

## 三、避坑实战经验

1. **`SetClickable(false)` 贯穿点击穿透保障**：
   - 轮盘根节点必须显式声明 `self:SetClickable(false)`。若轮盘遮罩层拦截了鼠标事件，会导致玩家在呼出轮盘的一瞬间，地图底层的移动与战斗寻路彻底挂起，若此时正好遭遇怪物会发生无法躲避攻击的惨剧。
2. **纯客户端模组的动作下发协议**：
   - 客户端选定 Emote 后，执行动作下发不能伪造状态机，必须调用原生网络命令：
     ```lua
     TheNet:SendRPCToServer(RPC.SlashCmd, emote_name)
     ```
     严格走官方斜杠命令 RPC 管道，确保服务端安全校验与联机动画同步。
