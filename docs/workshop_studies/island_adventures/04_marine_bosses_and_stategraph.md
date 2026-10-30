# 知识点专卷：跨陆海 Boss 仇恨决策与复合 StateGraph 状态机（Marine Bosses & Multi-Phase SG）

> **归属专题**：`06-stategraphs` 状态图系统 / `07-brains` AI 行为大脑  
> **实战案例来源**：创意工坊 `1467214795` (Island Adventures / 海难联机版)  
> **权威级别**：工业级全量重构（全网最成熟的海上 Boss 战状态机架构）

---

## 一、核心技术痛点与架构本质

在饥荒普通 Mod 中，陆地 Boss 的 SG 状态机非常单一（Walk -> Attack -> Hit -> Death）。  
但在海难中，像**龙卷风鲨（Sealnado）**与**深海海妖（Quacken）**面临极端复杂的技术挑战：
1. **多介质游移（Amphibious Locomotion）**：Boss 在水里是潜泳形态，上岸变身陆地巨兽；
2. **多阶段（Multi-Phase）形态转换**：血量跌破阈值后改变攻击模式（如吸力飓风、巨浪拍击）；
3. **触手/从属实体阵列同步（Minion Tentacle Array）**：深海 Boss 本体隐匿在水下，露出 10~20 条水面触手同步施法。

---

## 二、关键源码剖析

### 1. 水陆状态切换切面（Amphibious State Switcher）

```lua
-- SG 状态机中的水陆转移分支
State{
    name = "transition_to_water",
    tags = { "busy", "transition" },
    onenter = function(inst)
        inst.AnimState:PlayAnimation("dive_down")
        inst.Physics:SetCollisionMask(COLLISION.OCEAN_ONLY)
    end,
    events = {
        EventHandler("animover", function(inst)
            inst:AddTag("swimming")
            inst.AnimState:PlayAnimation("swim_loop", true)
            inst.sg:GoToState("idle")
        end),
    },
}
```

### 2. 环形触手生成与心跳保活

```lua
local function SpawnTentacleRing(boss, center_pos, radius, count)
    boss._tentacles = boss._tentacles or {}
    for i = 1, count do
        local angle = (i / count) * 2 * PI
        local offset = Vector3(radius * math.cos(angle), 0, radius * math.sin(angle))
        local tentacle = SpawnPrefab("quacken_tentacle")
        tentacle.Transform:SetPosition((center_pos + offset):Get())
        tentacle._boss = boss
        table.insert(boss._tentacles, tentacle)
    end
end
```

---

## 三、避坑与反例对比（Anti-Patterns）

| 维度 | 常见菜鸟/传统错误写法 (❌) | 工业级权威方案 (✅ Island Adventures) |
| :--- | :--- | :--- |
| **仇恨追逐** | 目标一旦跳上船，Boss 依然保持陆地寻路。*(结果：Boss 在岸边疯狂卡步，变成沙包木桩)* | **仇恨介质感知（Media-Aware Target Evaluation）**：实时检测目标处于“船上/陆地”，自动切换水上追击技或吐射远程水炮。 |
| **多从属实体** | 子触手被击杀时，Boss 未监听事件。*(结果：子实体泄露无法回收，Boss 永远处于无敌锁定状态)* | **双向事件链路（Bi-directional Event Hook）**：父子实体互相绑定 `onremove` 与 `death` 监听器，确保原子级协同销毁。 |

---

## 四、生产级开箱即用代码骨架（Boilerplate）

```lua
-- scripts/stategraphs/SGamphibious_boss.lua
local events = {
    EventHandler("locomote", function(inst)
        local is_on_water = TheWorld.Map:IsOceanTileAtPoint(inst.Transform:GetWorldPosition())
        if is_on_water and not inst:HasTag("swimming") then
            inst.sg:GoToState("transition_to_water")
        elseif not is_on_water and inst:HasTag("swimming") then
            inst.sg:GoToState("transition_to_land")
        end
    end)
}
```

---

## 五、DST 官方版本断代兼容边界（Version Trap）

- 现代 DST 官方引入了新的 `Combat:SetKeepTargetFunction`，旧版直接在 SG 内粗暴判定目标的做法会导致在多人混战时频繁丢仇恨。必须统一采用现代函数回调机制判定水陆距离。
