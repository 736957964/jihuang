# 饥荒一线工坊深度研读 Skill：多阶段高阶 BOSS 状态机打断与仇恨软锁定机制

- **来源工程**：`神话书说 (1991746508 / Myth Words)` 与 `smallAn.md 工业案例`
- **核心逻辑对应**：`scripts/prefabs/blackbear.lua`、`scripts/brains/blackbearbrain.lua`、`SGblackbear.lua`
- **领域分类**：高阶怪物/BOSS AI 设计、StateGraph 强制打断与无敌帧治理、群体仇恨锁定与防卡顿脱战

---

## 一、核心实现原理与架构全貌

饥荒中设计一个具备商业级体验的高阶 BOSS，最大的挑战不是堆砌数值，而是处理**多人联机围殴下的动作被打断（硬直死锁）**、**转阶段动画期间被冰冻/催眠异常打断**、以及**无限制追击玩家导致的虚空寻路崩服**。神话书说的黑风怪与辟寒大王体系提供了标准规范：

### 1. 阈值触发转阶段与状态机霸体无敌帧
- **痛点**：BOSS 在血量降至 50% 准备施展咆哮或狂暴时，若被多名玩家同时冰冻杖、排箫或武器硬直打断，会导致转阶段标志位已置为 true，但对应动画和技能逻辑完全丢失。
- **工业级解法**：
  - 在 `healthdelta` 回调中触发转阶段后，立即通过 `inst.sg:GoToState("roar")` 强制切入。
  - 在 StateGraph 的 `roar` 状态中，打上两组关键 Tag：
    - `inst.sg:AddStateTag("busy")`: 屏蔽常规攻击与移动指令。
    - `inst.sg:AddStateTag("nosleep")` 与 `inst.sg:AddStateTag("nofreeze")`: 临时免疫催眠与冰冻，确保转阶段关键动画帧完整执行。

### 2. 行为树（Brain）权重分流与条件节点闭环
- **架构**：采用 `PriorityNode` 进行高优先级拦截。
  - 第一优先级：狂暴且未处于 `busy` 时，距离目标一定范围内强制施放范围技能（如 `groundpound` 地震波）；
  - 第二优先级：标准 `ChaseAndAttack` 追击与普攻；
  - 第三优先级：失去目标时的巡逻锚点漫步（`Wander`）。

### 3. 地震震慑与装备剥离的安全判定
- 范围伤害函数中必须使用 `TheSim:FindEntities` 严格设置过滤标签 `{ "INLIMBO", "flight", "FX" }`。
- 对被击中玩家触发震落装备（`DropEverything`）时，只震落手持武器（`eslot == EQUIPSLOTS.HANDS`），避免将玩家整个背包和护符震落导致客户端不同步。

---

## 二、标准化生产级代码范式 (可直接复用)

```lua
-- ==============================================================================
-- 范式 1：高阶 BOSS 状态机状态定义与免疫标签配置 (SGboss.lua)
-- ==============================================================================

local states = {
    State{
        name = "roar",
        tags = { "busy", "nosleep", "nofreeze", "epic", "jumping" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("roar")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bearger/taunt")
            
            -- 全屏摄像机震动反馈
            ShakeAllCameras(CAMERASHAKE.FULL, 0.7, 0.02, 0.5, inst, 40)
        end,

        timeline = {
            TimeEvent(10 * FRAMES, function(inst)
                -- 核心技能点：地面冲击与范围震慑
                if inst.DoGroundPound then
                    inst:DoGroundPound()
                end
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
}

-- ==============================================================================
-- 范式 2：BOSS 实体预制体定义与血量监听 (custom_boss.lua)
-- ==============================================================================

local function OnHealthDelta(inst, data)
    if not inst.components.health:IsDead() then
        local percent = data.newpercent
        -- 50% 血量转阶段判定 (使用布尔锁防止反复触发)
        if percent < 0.5 and not inst.is_enraged then
            inst.is_enraged = true
            -- 强制切入霸体咆哮
            inst.sg:GoToState("roar")
            -- 狂暴属性加成
            inst.components.combat:SetDefaultDamage(150)
            inst.components.combat:SetAttackPeriod(2.0)
            inst.components.locomotor.runspeed = 10
        end
    end
end

local function RetargetFn(inst)
    -- 智能检索 15 码内非幽灵、非隐匿的玩家
    return FindEntity(
        inst,
        15,
        function(guy)
            return inst.components.combat:CanTarget(guy) and not guy:HasTag("playerghost")
        end,
        { "_combat", "character" },
        { "INLIMBO", "FX" }
    )
end

local function KeepTargetFn(inst, target)
    -- 离开 30 码或目标死亡时安全释放仇恨
    return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) < 900
end
```

---

## 三、踩坑与避错实战指南

1. **`KeepTargetFn` 缺失导致的全图追杀崩服**：
   - 饥荒怪物如果只写 `SetRetargetFunction` 而不配置 `SetKeepTargetFunction`，一旦玩家通过传送杖或虫洞飞到地图另一端，BOSS 会保持目标并在服务器后台进行每帧数千次的超远距离寻路计算，直接拉爆 CPU。务必设置安全脱战平方距离（如 `900` 即 30 码）。
2. **`INLIMBO` 实体击打导致坏档**：
   - 在范围伤害（AOE）遍历实体时，绝对不能碰处于 `INLIMBO`（背包中/被装入箱子）状态的物体，否则会导致存放在玩家包裹内的物品受到伤害，触发无效物理销毁，引发世界保存时数据结构断裂！
