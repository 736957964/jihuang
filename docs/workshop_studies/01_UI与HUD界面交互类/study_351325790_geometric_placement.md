# 饥荒创意工坊深度研读报告：Geometric Placement（几何种植）

- **模组标识**：`351325790` (`Geometric Placement / 几何种植`)
- **作者**：rezecib
- **版本**：v3.2.0
- **领域分类**：纯客户端（Client-Only）空间几何计算引擎、Placer 切面重写、时间预算与增量网格渲染池、多控制设备（键鼠/手柄）输入预测
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 1713 行 `modmain.lua` 及全部独立网格资源预制体）

---

## 一、架构全貌与顶层设计思想

`Geometric Placement` 是饥荒工坊历史上最成功、用户量最大（数百万订阅）的纯客户端 Mod 之一。其最伟大的技术成就，是在**完全不修改服务端任何逻辑、不增加网络通信负载**的前提下，为客户端提供了毫米级的建筑/种植空间吸附与网格投影。

### 1. 纯客户端安全隔离（Client-Only Architecture）
- **根目录防御**：
  ```lua
  client_only_mod = true
  all_clients_require_mod = false
  if DST and GLOBAL.TheNet:IsDedicated() then return end
  ```
  在专用服务端运行时直接返回，杜绝污染服务端实体与状态机。
- **与服务端权威位置的协调**：
  饥荒联机版的实体建造依赖客户端发送建造 RPC（包含世界坐标点）。`Geometric Placement` 在客户端本地接管了 `Placer:OnUpdate`，将鼠标光标的浮点坐标吸附为计算后的离散几何网格坐标，并将 `self.inst.Transform:SetPosition(pt:Get())`。当玩家点击时，原版 `playercontroller` 从 `Placer` 实体提取的世界坐标本身就已经是吸附后的精确网格点，从而以零网络入侵的方式达成了完美的建造吸附！

---

## 二、四大硬核核心技术解构

### 1. 仿射变换与多维网格几何投影引擎（Affine Projection Matrix）
MOD 支持多种几何网格（正方形 Square、菱形 Diamond、平顶六边形 Flat-Hexagon、尖顶六边形 Pointy-Hexagon、X/Z 轴六边形）。其核心并没有为每种形状写单独的穷举算法，而是提炼出了**抽象晶格空间（Lattice Space）向世界空间（World Space）的二维矩阵投影**：

```lua
-- 晶格坐标 [bgx, bgz] 与世界坐标 [x, z] 的仿射矩阵变换
-- [ col_offset.x   row_offset.x ] [ bgx ] = [ x ]
-- [ col_offset.z   row_offset.z ] [ bgz ]   [ z ]
```
通过乘以旋转矩阵：
```lua
[ cos(th) -sin(th) ] [ a b ]   [ a*cos(th) - c*sin(th), b*cos(th) - d*sin(th) ]
[ sin(th)  cos(th) ] [ c d ] = [ a*sin(th) + c*cos(th), b*sin(th) - d*cos(th) ]
```
从而以极低的 CPU 开销，任意在世界中生成 45°、90°、135° 的六边形和菱形对称点阵。

### 2. 增量网格移动与对象池（Incremental Grid Updates & Entity Pooling）
如果玩家移动鼠标时，每帧将周围上百个网格实体全部 `Remove()` 重新 `SpawnPrefab()`，客户端必定瞬间掉帧暴跌。
- **增量差分更新**：
  当光标从 `lastpt` 移到 `pt` 时，计算晶格位移差 `dx = cx - lx, dz = cz - lz`。
  使用 `HasOverlap` 判定新旧区域重叠，仅剔除离开视野的旧边缘点，将其丢入 `to_move_list` 回收池；
  对于新进入视野的网格点，直接从 `to_move_list` 提取已有实体执行 `SetPosition`，做到了**实体零频繁 GC 创建**！
- **帧时间预算切片（Time Budget Slicing）**：
  引入 `TIMEBUDGET = percent * FRAMES`（如单帧时间的 10%）。在生成大规模复杂网格时，如果耗时达到预算上限，立即挂起并留到下一帧继续渲染，彻底保证游戏 60 帧丝滑运行。

### 3. 手柄控制器特殊坐标捕捉（Controller Fake-Parenting）
在手柄模式下，饥荒原生会将 Placer 作为角色的子实体（`ThePlayer:AddChild(self.inst)`），导致 Placer 随角色朝向旋转。
- **MOD 破解之道**：
  解绑主 Placer 的父子关系，在玩家身上挂载一个无碰撞无持久化的隐形定位桩 `self.controller_child`（`persists = false`, `AddTag("FX")`），通过该隐形桩捕获控制器的旋转朝向与半径，再输入到 `Snap()` 算法中重新结算出世界绝对网格坐标。

### 4. 颜色与材质动态渲染（AnimState MultColour / AddColour）
- 网格点根据 `can_build` 状态分别赋予 GOOD/BAD 着色。
- 利用 `SetMultColour` 与 `SetAddColour` 实现白色描边、纯黑反差高对比度视觉提示，兼顾色盲玩家辅助模式。

---

## 三、设计权衡与避坑实战经验

1. **绝对不要破坏原版 Placer 的关键字段**：
   - 原版 `playercontroller` 在建造时会读取 `placer.inst:GetPosition()` 或 `placer.targetPos`。如果切面改写时只移动了视觉动画而漏写 `self.inst.Transform:SetPosition(...)`，会导致服务端落点依然是原始鼠标点。
2. **地图 Tile 边界与地皮网格的对齐（Tile Alignment）**：
   - 饥荒的地皮是严格按 4x4 尺寸划分的，而墙体和植物通常按 0.5 或 1 间隔划分。MOD 定义了 `ORIGIN_OFFSETS`（`wall = 0.5, tile = -2`），精准补偿不同 prefab 在地块中心处的固有偏移量。
