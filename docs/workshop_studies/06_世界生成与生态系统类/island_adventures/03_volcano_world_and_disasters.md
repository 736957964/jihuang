# 知识点专卷：多世界分流、火山维度穿梭与周期灾难调度器（Volcano Shard & Disaster Scheduler）

> **归属专题**：`13-world` 多世界与世界生成 / `02-components` 定时器与环境调度  
> **实战案例来源**：创意工坊 `1467214795` (Island Adventures / 海难联机版)  
> **权威级别**：工业级全量重构（全网最成熟的副世界/灾难事件机制）

---

## 一、核心技术痛点与架构本质

在海难玩法中，“火山（Volcano）”是一个完全独立维度的世界空间：
1. **多世界（Sharding）还是同图异构（Interior Cell）？**
   - 如果用真正的多 Shard 分服：需要开启多个服务器进程，极大增加玩家搭建门槛；
   - IA 采用了**同世界虚拟坐标舱隔离技术（Virtual Shard Cell Isolation）**：将火山空间生成在主世界极远端（如 X > 3000 区域），并对该区域的环境光、温度、物理风暴进行全隔离模拟！
2. **季风季与火山喷发灾难（Meteor Shower Scheduler）**：
   - 灾害不能凭空生成在全图，必须具备**针对活跃玩家的威胁预警、落点阴影投影与实体打击物理帧**。

---

## 二、关键源码剖析

### 1. 虚拟火山坐标舱进入与退出协议

```lua
local function EnterVolcano(door, doer)
    if not doer or not doer:IsValid() then return end
    
    -- 记录进入前的外部海面坐标
    doer._ia_exit_pos = doer:GetPosition()
    
    -- 瞬移至隔离火山空间中心
    local volcano_center = TheWorld.volcano_center or Vector3(3500, 0, 3500)
    doer.Transform:SetPosition(volcano_center.x, 0, volcano_center.z)
    
    -- 激活火山专属环境光与高热环境
    TheWorld:PushEvent("entervolcano", { player = doer })
end
```

### 2. 陨石雨预测落点调度

```lua
local function ScheduleMeteorImpact(target_player)
    local x, y, z = target_player.Transform:GetWorldPosition()
    local offset = Vector3(math.random(-15, 15), 0, math.random(-15, 15))
    local impact_pos = Vector3(x, y, z) + offset
    
    -- 生成地面预警阴影
    local shadow = SpawnPrefab("meteor_shadow")
    shadow.Transform:SetPosition(impact_pos:Get())
    
    -- 2.5 秒后下砸实际伤害判定体
    shadow:DoTaskInTime(2.5, function()
        SpawnPrefab("falling_meteor").Transform:SetPosition(impact_pos:Get())
        shadow:Remove()
    end)
end
```

---

## 三、避坑与反例对比（Anti-Patterns）

| 维度 | 常见菜鸟/传统错误写法 (❌) | 工业级权威方案 (✅ Island Adventures) |
| :--- | :--- | :--- |
| **灾难下砸** | 直接在玩家正头顶生成秒杀攻击。*(结果：玩家零容错，毫无操作体验，恶评退订)* | **“预警阴影 -> 震地音效 -> 物理下砸 -> 溅射碎石”的四段式打击规范**。 |
| **副世界隔离** | 未阻断世界天候，导致火山内部下大暴雨打雷。*(结果：世界逻辑崩坏，玩家在岩浆里冻结)* | **天候局部拦截罩（Weather Override Zone）**：在玩家进入火山区域后，本地客户端将天候强行锁定在高温/火山灰状态。 |

---

## 四、生产级开箱即用代码骨架（Boilerplate）

```lua
-- scripts/components/zone_disaster_scheduler.lua
local ZoneDisasterScheduler = Class(function(self, inst)
    self.inst = inst
    self.active = false
    self.interval = 30
end)

function ZoneDisasterScheduler:Start()
    self.active = true
    self:ScheduleNext()
end

function ZoneDisasterScheduler:ScheduleNext()
    if not self.active then return end
    self.inst:DoTaskInTime(self.interval, function()
        for _, player in ipairs(AllPlayers) do
            if player:HasTag("in_disaster_zone") then
                self:TriggerDisasterAt(player)
            end
        end
        self:ScheduleNext()
    end)
end

function ZoneDisasterScheduler:TriggerDisasterAt(target)
    -- 预警与生成打击逻辑
end

return ZoneDisasterScheduler
```

---

## 五、DST 官方版本断代兼容边界（Version Trap）

- 针对现代 DST 的洞穴/地表分流机制，使用同图异构坐标舱时，必须配置 `inst.components.areaaware` 区域感知，否则世界生成时的自动寻路系统（Pathfinder）会尝试在火山与海面之间计算直线路径，导致主线程瞬间卡死！
