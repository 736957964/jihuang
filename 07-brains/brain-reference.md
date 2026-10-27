# 07-brains — 常用 AI 大脑 (Brain) 详细参考

> 源码: `scripts/brains/` (200+ 个 brain 文件)
> 每个拥有 AI 的实体都有对应的 Brain 文件，定义其行为树结构。

---

## 1. Brain 通用结构 (braincommon.lua)

`braincommon.lua` 包含所有 brain 共享的工具函数。

### 1.1 常用工具函数

```lua
-- 目标选择辅助
local function FindTarget(inst, dist, tags, notags, oneoftags)
    -- 在 dist 范围内查找符合条件的目标
end

-- 回家逻辑
local function GoHomeAction(inst)
    -- 导航回家的 BufferedAction
end

-- 逃跑逻辑
local function RunAwayFrom(inst, threat, dist)
    -- 从威胁逃跑
end
```

### 1.2 Brain 类生命周期

```lua
-- Brain 初始化
function MyBrain:OnStart()
    -- 构建行为树
    local root = PriorityNode({...})
    self.bt = BT(self.inst, root)
end

-- 每帧更新由 BT 引擎自动处理

-- Brain 初始化后回调
function MyBrain:OnInitializationComplete()
    -- 所有组件加载完毕后
end
```

---

## 2. 玩家 Brain (wilsonbrain.lua / hostedbrain.lua)

### 2.1 wilsonbrain.lua — 单机玩家

单机版玩家 AI（在 DST 中用于服务器）。

### 2.2 hostedbrain.lua — 托管玩家

DST 联机版中的玩家 Brain，处理玩家移动、动作等。

---

## 3. 常用生物 Brain 详细参考

### 3.1 spiderbrain.lua — 蜘蛛

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 有战斗目标
    ChaseAndAttack(self.inst, MAX_CHASE_TIME),
    -- 被攻击时寻找攻击者
    -- 白天躲藏
    -- 晚上闲逛/猎食
    Wander(self.inst, homePos, MAX_WANDER_DIST),
}, .25)
```

**关键特性**:
- 白天回巢躲藏
- 黄昏/夜晚外出活动
- 被攻击时反击
- 蜘蛛女王召唤时跟随

### 3.2 pigbrain.lua — 猪人

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 战斗（猪人会互相帮助）
    ChaseAndAttack(self.inst),
    -- 害怕黑暗：找光源
    -- 吃地上的食物
    -- 黄昏回家
    -- 白天闲逛
    Wander(self.inst, homePos),
}, .25)
```

**关键特性**:
- 黄昏回猪人房
- 害怕黑暗
- 会吃地上的食物
- 给肉可以招募为随从
- 猪人之间互相帮助战斗

### 3.3 beefalobrain.lua — 牛

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 被攻击时反击
    ChaseAndAttack(self.inst),
    -- 发情期：攻击靠近者
    -- 跟随牛群
    -- 闲逛/吃草
    Wander(self.inst),
}, .5)
```

**关键特性**:
- 群居行为
- 发情期攻击性增强
- 可驯服（驯服后行为变化）
- 被剃毛后长毛

### 3.4 houndbrain.lua — 猎犬

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 追击攻击
    ChaseAndAttack(self.inst),
    -- 朝玩家移动
    -- 周期性吼叫
    Wander(self.inst),
}, .25)
```

**关键特性**:
- 周期性猎犬袭击
- 火猎犬死后燃烧
- 冰猎犬死后冰冻
- 跟随猎犬群

### 3.5 frogbrain.lua — 青蛙

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 被攻击时反击
    ChaseAndAttack(self.inst),
    -- 攻击靠近的小生物
    -- 青蛙雨时从天而降
    Wander(self.inst, pondPos),
}, .25)
```

### 3.6 beecommon.lua / beebrain.lua — 蜜蜂

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 攻击威胁蜂巢的敌人
    ChaseAndAttack(self.inst),
    -- 采蜜（找花朵）
    -- 回蜂巢
    Wander(self.inst, hivePos),
}, .25)
```

**关键特性**:
- 春天攻击性增强（杀人蜂）
- 采蜜行为
- 蜂巢被攻击时群起攻之

### 3.7 tallbirdbrain.lua — 高鸟

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 攻击靠近巢的生物
    ChaseAndAttack(self.inst),
    -- 保护蛋
    -- 在巢附近闲逛
    Wander(self.inst, nestPos, MAX_DIST),
}, .25)
```

### 3.8 penguinbrain.lua — 企鹅

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 被攻击时反击
    ChaseAndAttack(self.inst),
    -- 跳跃上岸
    -- 在巢附近活动
    Wander(self.inst, nestPos),
}, .5)
```

### 3.9 bunnymanbrain.lua — 兔人

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 攻击携带肉类的玩家
    ChaseAndAttack(self.inst),
    -- 被攻击时反击
    -- 黄昏回家
    -- 白天闲逛
    Wander(self.inst, homePos),
}, .25)
```

**关键特性**:
- 敌对携带肉类的玩家
- 可用胡萝卜招募
- 与猪人敌对

### 3.10 chesterbrain.lua — 切斯特

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 跟随持有眼骨的玩家
    Follow(self.inst, owner),
    -- 被攻击时逃跑
    RunAway(self.inst, ...),
    Wander(self.inst),
}, .25)
```

### 3.11 catcoonbrain.lua — 浣熊猫

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 狩猎小动物
    -- 吐出礼物
    -- 闲逛
    Wander(self.inst),
}, .25)
```

### 3.12 molebrain.lua — 鼹鼠

```lua
-- 行为树结构（简化）
PriorityNode({
    -- 感知震动逃跑
    -- 偷地上的矿物
    -- 钻地/出地
    Wander(self.inst),
}, .25)
```

---

## 4. Boss Brain 详细参考

### 4.1 deerclopsbrain.lua — 独眼巨鹿

```lua
-- 核心行为
PriorityNode({
    -- 攻击最近的建筑/玩家
    ChaseAndAttack(self.inst),
    -- 摧毁建筑（攻击模式）
    -- 咆哮（范围伤害 + 理智降低）
    -- 移动
    Wander(self.inst),
}, .5)
```

### 4.2 beargerbrain.lua — 熊獾

```lua
-- 核心行为
PriorityNode({
    -- 攻击
    ChaseAndAttack(self.inst),
    -- 偷食物
    -- 打哈欠（催眠）
    -- 摧毁建筑
    Wander(self.inst),
}, .5)
```

### 4.3 dragonflybrain.lua — 蜻蜓龙

```lua
-- 核心行为
PriorityNode({
    -- 攻击
    ChaseAndAttack(self.inst),
    -- 狂暴模式（低血量触发）
    -- 召唤熔岩虫
    -- 三连拍地
    -- 飞行/巡逻
    Wander(self.inst, lavaPondPos),
}, .25)
```

### 4.4 beequeenbrain.lua — 蜂后

```lua
-- 核心行为
PriorityNode({
    -- 攻击
    ChaseAndAttack(self.inst),
    -- 尖叫（强化蜜蜂）
    -- 召唤幼虫
    -- 地面尖刺
    Wander(self.inst, hivePos),
}, .25)
```

### 4.5 klausbrain.lua — 克劳斯

```lua
-- 核心行为
PriorityNode({
    -- 攻击
    ChaseAndAttack(self.inst),
    -- 施法（召唤坎普斯/冰冻/火焰）
    -- 跳跃攻击
    -- 阶段切换（50%血量）
    Wander(self.inst),
}, .25)
```

---

## 5. Brain 编写教程

### 5.1 完整 Brain 模板

```lua
-- brains/mycreaturebrain.lua
require("behaviours/chaseandattack")
require("behaviours/wander")
require("behaviours/leash")
require("behaviours/standstill")
require("behaviours/faceentity")
require("behaviours/follow")
require("behaviours/runaway")

local MAX_WANDER_DIST = 20
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30

local MyCreatureBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function MyCreatureBrain:OnStart()
    local root = PriorityNode(
    {
        -- 优先级 1: 战斗
        ChaseAndAttack(self.inst, MAX_CHASE_TIME),
        -- 优先级 2: 被攻击逃跑（低血量）
        WhileNode(function()
            return self.inst.components.health:GetPercent() < 0.3
                and self.inst.components.combat.target ~= nil
        end, "LowHealth",
            RunAway(self.inst, "player", 10, 20)),
        -- 优先级 3: 离家太远
        Leash(self.inst, self.inst:GetPosition(), MAX_WANDER_DIST, MAX_WANDER_DIST - 2),
        -- 优先级 4: 面对威胁
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        -- 优先级 5: 白天待机
        StandStill(self.inst, function() return not TheWorld.state.isnight end),
        -- 优先级 6: 闲逛
        Wander(self.inst, self.inst:GetPosition(), MAX_WANDER_DIST),
    }, .25)

    self.bt = BT(self.inst, root)
end

return MyCreatureBrain
```

### 5.2 在 Prefab 中绑定 Brain

```lua
local brain = require("brains/mycreaturebrain")

local function fn()
    local inst = CreateEntity()
    -- ... 实体设置 ...
    inst:SetBrain(brain)
    return inst
end
```

### 5.3 在 Mod 中修改 Brain

```lua
-- 在 modmain.lua 中
AddBrainPostInit("spiderbrain", function(self)
    -- 在 brain 的 OnStart 后执行
    -- 注意：这需要覆盖 brain 的行为树
    -- 更常见的做法是用 ComponentPostInit 修改组件行为
end)

-- 更简单的方式：替换整个 brain
-- 在你的 prefab 中
inst:SetBrain(require("brains/my_custom_brain"))
```

### 5.4 行为节点选择指南

| 需求 | 推荐节点 |
|------|----------|
| 攻击目标 | `ChaseAndAttack` |
| 跟随目标 | `Follow` |
| 闲逛 | `Wander` |
| 逃跑 | `RunAway` |
| 回家 | `Leash` |
| 站立不动 | `StandStill` |
| 面向目标 | `FaceEntity` |
| 执行动作 | `DoAction` |
| 寻找实体 | `FindClosest` |
| 靠近实体 | `Approach` |
| 恐慌乱跑 | `Panic` |
| 响应事件 | `EventNode` |
| 条件判断 | `ConditionNode` |
| 等待时间 | `WaitNode` |
| 限制频率 | `MinPeriod` |
| 添加对话 | `ChattyNode` |
