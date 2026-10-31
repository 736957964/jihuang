# 知识点专卷：潮汐涨落、海浪动力学与水体 Wetness 机制（Ocean Tides & Wave Dynamics）

> **归属专题**：`13-world` 世界环境与气象 / `19-fx` 物理特效与粒子系统  
> **实战案例来源**：创意工坊 `1467214795` (Island Adventures / 海难联机版)  
> **权威级别**：工业级全量重构（全网最成熟的水体环境系统）

---

## 一、核心技术痛点与架构本质

在海难生态中，海洋不是静态的贴图，而是一个具备生命力的**动力学模拟场**：
1. **涨潮/退潮（Tide Simulation）**：沙滩在特定时间段会被海水淹没变暗，退潮后遗留贝壳和淤泥；
2. **海浪生成与冲浪物理（Wave Physics）**：浪头沿风向推进，顺浪加速，迎浪湿身甚至损毁船体；
3. **湿润度系统重构（Dynamic Wetness）**：玩家遭遇大浪（Rogue Wave）时必须触发水花爆裂、镜头水幕与水体渗透。

### IA 的工业级解法
- **基于全局时间戳的正弦潮汐池（Sinusoidal Tide Generator）**：不直接修改地皮，而是通过覆盖层（Tile Mask Overlays）动态改变沙滩湿度材质；
- **动态浪头对象池（Wave Object Pool）**：利用 `SpawnPrefab` 高效回收池生成海浪实体，海浪附带不可通行的局部碰撞体与方向推动场（Directional Force Field）。

---

## 二、关键源码剖析

### 1. 浪头与船只迎角动力学计算
在海浪接触到载具时，IA 会计算两者运动方向的夹角：

```lua
local function OnWaveHit(inst, wave)
    local wave_heading = wave.Transform:GetRotation()
    local boat_heading = inst.Transform:GetRotation()
    local angle_diff = math.abs(anglediff(wave_heading, boat_heading))
    
    if angle_diff < 45 then
        -- 顺浪：获得冲浪加速 (Surf Boost)
        inst.components.boatphysics:ApplyForce(wave_heading, 8.0)
        inst.SoundEmitter:PlaySound("ia/wave/surf")
    elseif angle_diff > 135 then
        -- 逆浪：迎头撞浪，船体受损并大幅增加湿润度
        inst.components.health:DoDelta(-15)
        inst.components.boatphysics:ApplyForce(boat_heading, -4.0)
        SpawnPrefab("splash_ocean").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end
```

---

## 三、避坑与反例对比（Anti-Patterns）

| 维度 | 常见菜鸟/传统错误写法 (❌) | 工业级权威方案 (✅ Island Adventures) |
| :--- | :--- | :--- |
| **海浪生成** | 每帧遍历所有水体坐标随机 `SpawnPrefab("wave")`。*(结果：内存雪崩，服务器 Tick 暴跌至个位数)* | **视野动态生成锚点（Viewport-Bounded Spawner）**：仅在玩家摄像机朝向 30 码内的顺风水面按冷却排队生成。 |
| **潮汐水体** | 周期性把岸边沙滩的地皮硬修改为 Ocean Tile。*(结果：世界生成数据被污染，存档永久损坏且陆地生物淹死)* | **非侵入式动态阻尼器**：仅通过 `GroundCreep` 贴图叠加与局部移动减速判定，完全不动原生地皮索引。 |

---

## 四、生产级开箱即用代码骨架（Boilerplate）

```lua
-- scripts/components/wave_interactor.lua
local WaveInteractor = Class(function(self, inst)
    self.inst = inst
    self.inst:ListenForEvent("hit_wave", function(inst, data) self:OnHit(data) end)
end)

function WaveInteractor:OnHit(data)
    local wave = data and data.wave
    if not wave or not wave:IsValid() then return end
    
    local diff = math.abs(anglediff(wave.Transform:GetRotation(), self.inst.Transform:GetRotation()))
    if diff <= 60 then
        -- 顺风/顺浪推力
        self.inst.Physics:SetMotorVel(12, 0, 0)
    else
        -- 破损与减速
        if self.inst.components.health then
            self.inst.components.health:DoDelta(-10)
        end
    end
end

return WaveInteractor
```

---

## 五、DST 官方版本断代兼容边界（Version Trap）

- **官方水体（Ocean System）API 迁移**：
  原版 2019 年水上更新后，官方引入了 `TheWorld.Map:IsOceanTileAtPoint`。旧版代码通常使用 `TheWorld.Map:GetTileAtPoint(x, y, z) == GROUND.OCEAN_COAST`，新开发中必须统一迁移为现代 API，否则在深海（Deep Ocean）地皮会导致判定失效。
