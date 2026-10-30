# 饥荒创意工坊深度研读报告：Minimap HUD（智能常驻小地图）

- **模组标识**：`345692228` (`Minimap HUD`)
- **作者**：sqrly
- **领域分类**：纯客户端 UI、C++ 底层 MiniMap 纹理原生桥接、双端分辨率自适应与矩阵缩放对齐、动态摄像机焦点捕获隔离
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 `modmain.lua` 与 `scripts/widgets/minimapwidget.lua`）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，查看地图通常需要按 `Tab` 键切入全屏 `MapScreen`，这会导致玩家无法同时操作走位或观察周围野怪动向。`Minimap HUD` 开创性地将游戏底层的全屏地图渲染管线，裁剪并投射到了主 HUD 界面上的一个轻量悬浮挂件中。

### 1. 深度复用 C++ 引擎的 MiniMap 渲染句柄
- **痛点**：Lua 虚拟机本身没有任何 3D/2D 地图渲染能力，若通过在 UI 上频繁贴实体图标来手绘地图，几十个图标就会彻底卡爆游戏。
- **神级突破**：MOD 直接抓取了 C++ 引擎向 Lua 暴露的底质原生组件：
  ```lua
  self.minimap = TheWorld.minimap.MiniMap
  ```
  通过为 UI 控件挂载 `BLENDMODE.Additive` 混色模式的 ImageWidget，调用底层 C++ 提供的纹理绘制函数，以极低的 GPU 开销直接将引擎已经烘焙好的全图迷雾与地皮贴图投影到 UI 平面上！

---

## 二、四大硬核核心技术解构

### 1. 矩阵逆缩放对齐与九宫格锚点算法（HUD Matrix Unscaling）
当玩家在设置中更改“HUD 大小”（如缩放到 80% 或 120%）时，挂载在 `controls.top_root` 下的普通控件会随之缩放并产生位置偏移。
- **数学对齐公式**：
  ```lua
  local hudscale = controls.top_root:GetScale()
  local screenw_full, screenh_full = unpack(screensize)
  local screenw = screenw_full / hudscale.x
  local screenh = screenh_full / hudscale.y
  ```
  将屏幕全屏分辨率反向除以当前 HUD 缩放系数，求出 `top_root` 相对坐标空间下的绝对可用宽高，再结合九宫格方向因子（`anchor_horiz`, `dir_horiz`, `margin_dir_horiz`），实现了在任意分辨率与任何 HUD 缩放下，小地图贴边距离分毫不差！

### 2. 窗口 Resize 响应式重排（Responsive Resize Hook）
饥荒原生没有公开的“屏幕分辨率变化事件”。MOD 巧妙 Hook 了 `controls.OnUpdate`：
```lua
local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
    PositionMiniMap(controls, curscreensize)
    screensize = curscreensize
end
```
每帧只做两次整数不等于比较，代价微乎其微，却完美实现了玩家拖拽游戏窗口时小地图毫秒级自适应归位。

### 3. 全屏地图切入冲突治理（ToggleMap 状态保护）
当玩家按下 Tab 打开官方全屏大地图时，如果小地图继续渲染，会触发双重纹理争抢甚至 UI 叠层穿模。
- MOD 深度 Hook 了 `controls.ToggleMap`：
  - 打开全屏大地图前，记录 `wasvisible = controls.minimap_small:IsVisible()`；
  - 若小地图原先开着，则调用 `Hide()` 隐蔽小地图并挂起其更新任务；
  - 退出全屏大地图后，自动 `Show()` 唤醒小地图。

### 4. 鼠标滚轮焦点劫持与主摄像机（TheCamera）阻断
小地图支持直接在挂件内滚动滚轮缩放视野。但原版滚轮事件会被主视口摄像机捕获（导致玩家放大缩小主游戏视野）。
- **焦点隔离解法**：
  在 `OnGainFocus` 中临时封锁主摄像机：
  ```lua
  self.camera_controllable_reset = TheCamera:IsControllable()
  TheCamera:SetControllable(false)
  ```
  在 `OnLoseFocus` 移出鼠标时立即精准恢复：
  ```lua
  TheCamera:SetControllable(self.camera_controllable_reset)
  ```
  彻底规避了滚轮缩放地图时主画面抽搐的严重 bug。

---

## 三、避坑指南

1. **`controls.inst:DoTaskInTime(0, ...)` 延迟挂载法**：
   - 在 `AddClassPostConstruct("widgets/controls", ...)` 触发时，`controls` 的部分深层子节点尚未完全装配完毕。若在此刻强行调用 `AddChild`，极易因引擎底层未完成初态计算而闪退。延迟 0 秒调度（下一物理帧开始执行）是所有复杂 HUD 控件装配的金科玉律！
