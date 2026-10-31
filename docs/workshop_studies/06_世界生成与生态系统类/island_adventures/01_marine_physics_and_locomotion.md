# 知识点专卷：航海物理、船舶操纵与主客机客户端预测同步（Marine Physics & Client Locomotion）

> **归属专题**：`10-networking` 网络与预测同步 / `17-standardcomponents` 实体物理控制  
> **实战案例来源**：创意工坊 `1467214795` (Island Adventures / 海难联机版)  
> **权威级别**：工业级全量重构（全网最成熟的联机船舶物理方案）

---

## 一、核心技术痛点与架构本质

在饥荒原版（单机版海难）中，玩家上船本质是将玩家实体直接绑定在船上，移动由单一主进程驱动。  
但在《饥荒联机版（DST）》的**主客机分离架构（Client-Server Dedicated Architecture）**下，直接移动或暴力绑体会导致：
1. **客机剧烈抖动与回弹（Rubber-banding）**：客机未收到服务器物理帧确认前出现画面瞬移。
2. **海陆碰撞脱节**：船只物理碰撞体与玩家本身的 `Locomotor` 互相干涉，导致卡死在海边（Coast Stuck）。
3. **风帆/划桨物理推力叠加失真**：多名客机玩家操控或受季风、浪潮推力时，速度矢量计算不同步。

### IA 的工业级解法
IA 采用了**双实体解耦代理模型（Dual-Entity Proxy Decoupling）**：
- **船体（Boat/Raft Entity）**：拥有独立的刚体、浮力与水流阻尼组件；
- **操控者（Doer）**：通过挂载 `driver` 组件劫持原版 `Locomotor`，将键盘输入转译为**船体推进矢量（Thrust Vector）**；
- **客户端先行预测（Client-side Path Prediction）**：利用 `PlayerController:Locomote` 管道先行推进视觉坐标，服务器以 30Hz 频率下发 NetVars 进行平滑插值修正（Hermite Spline Interpolation）。

---

## 二、关键源码剖析

### 1. 客户端操控劫持与矢量映射
在客户端 `playercontroller.lua` 的 Hook 切面中，IA 拦截了原生移动指令：

```lua
-- IA 船舶操控输入转换核心
function SteeringController:OnControl(control, down)
    if not self.inst:HasTag("driving") then return end
    
    local boat = self.inst.replica.driver:GetBoat()
    if boat and boat:IsValid() then
        if control == CONTROL_PRIMARY then
            -- 映射划桨/开帆状态
            SendRPCToServer(RPC.IA_RowBoat, boat, down)
            return true
        end
    end
end
```

### 2. 水体碰撞与岸边自动阻尼
为防止高速撞击陆地直接穿模进入虚空，IA 为船只设计了复合碰撞层：

```lua
local function OnCollide(inst, other)
    if other and other:HasTag("coast_line") then
        local vel_x, vel_y, vel_z = inst.Physics:GetVelocity()
        -- 沿法线方向反弹并损失 70% 动能，防止穿入陆地地块
        inst.Physics:SetVel(-vel_x * 0.3, 0, -vel_z * 0.3)
        inst.SoundEmitter:PlaySound("ia/boat/hit_coast")
    end
end
```

---

## 三、避坑与反例对比（Anti-Patterns）

| 维度 | 常见菜鸟/传统错误写法 (❌) | 工业级权威方案 (✅ Island Adventures) |
| :--- | :--- | :--- |
| **主客机同步** | 仅在服务器计算船体移动，客机等待坐标同步。*(结果：客机延迟 100ms 以上时，开船像看幻灯片，转向严重滞后)* | **客户端先行预测物理步进**，服务器仅验证合法性并周期下发插值校正。 |
| **上下船状态** | 直接 `inst.Transform:SetPosition` 瞬移，未清理物理层级。*(结果：玩家被丢入海中无法行动或坐标卡入虚空)* | **挂载/卸载驱动协议栈**：在上下船动画（SGState）完成帧原子化切换物理遮罩（Collision Mask）。 |
| **多推力计算** | 多个风帆/划桨直接 `SetMotorVel` 粗暴相加。*(结果：顺风+划桨时速度突破引擎上限，穿墙出海)* | **力矩聚合器（Thrust Aggregator）**：将风力、洋流、动力统一计算标量合力并进行 `math.min(max_speed)` 钳位。 |

---

## 四、生产级开箱即用代码骨架（Boilerplate）

以下为提取自 IA 核心思想、可直接复制到自己 Mod 中快速实现“联机操控载具”的干净最小模板：

```lua
-- scripts/components/vehicle_driver.lua
local VehicleDriver = Class(function(self, inst)
    self.inst = inst
    self.vehicle = nil
    self.is_driving = false
end)

function VehicleDriver:Mount(vehicle)
    if not vehicle or not vehicle:IsValid() then return false end
    self.vehicle = vehicle
    self.is_driving = true
    self.inst:AddTag("driving_vehicle")
    -- 禁用玩家自主物理碰撞，跟随载具
    self.inst.Physics:SetActive(false)
    self.inst.Transform:SetPosition(vehicle.Transform:GetWorldPosition())
    return true
end

function VehicleDriver:Dismount(target_pos)
    if not self.is_driving then return end
    self.is_driving = false
    self.inst:RemoveTag("driving_vehicle")
    self.inst.Physics:SetActive(true)
    if target_pos then
        self.inst.Transform:SetPosition(target_pos:Get())
    end
    self.vehicle = nil
end

return VehicleDriver
```

---

## 五、DST 官方版本断代兼容边界（Version Trap）

1. **碰撞掩码（CollisionGroup）断代**：
   - *旧版（2018年之前）*：使用硬编码的物理层常量；
   - *现代版本（The Return of Them 之后）*：必须严格使用 `COLLISION.BOAT_LIMITS` 与 `COLLISION.LAND_OCEAN_LIMITS`，否则会导致原版三桅大船与自制独木舟发生物理击飞崩溃。
2. **网络组件 Replica 规则**：
   - 载具状态查询必须严格挂载在 `vehicle_driver_replica`，客户端通过 Replica 判断 `HasTag("driving_vehicle")`，严禁在客户端直接访问服务端的 component 实体。
