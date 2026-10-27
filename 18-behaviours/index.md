# 18-behaviours — 行为系统 (Behaviour System)

> 源码位置: `scripts/behaviourtree.lua` + `scripts/behaviours/`
> 行为树是 DST AI 系统的底层引擎，与 `07-brains` 的 Brain 层配合工作。Brain 定义行为树结构，Behaviour 节点负责具体执行。

---

## 1. 行为树引擎 (behaviourtree.lua)

### 1.1 核心状态常量

```lua
SUCCESS = "SUCCESS"   -- 节点执行成功
FAILED  = "FAILED"    -- 节点执行失败
READY   = "READY"     -- 节点待执行（初始状态）
RUNNING = "RUNNING"   -- 节点正在执行中
```

### 1.2 BT 类 (Behaviour Tree)

行为树实例，每个拥有 brain 的实体都有一个 BT。

| 方法 | 签名 | 说明 |
|------|------|------|
| `BT(inst, root)` | 构造函数 | inst 为实体，root 为根节点 |
| `BT:ForceUpdate()` | | 强制下一帧更新（跳过休眠时间） |
| `BT:Update()` | | 执行一帧：Visit → SaveStatus → Step |
| `BT:Reset()` | | 重置整棵树为 READY 状态 |
| `BT:Stop()` | | 停止树，触发所有 OnStop 回调 |
| `BT:GetSleepTime()` | → number | 获取树的休眠时间（秒），forceupdate 时返回 0 |

### 1.3 BehaviourNode 基类

所有行为节点的基类。

| 属性 | 类型 | 说明 |
|------|------|------|
| `name` | string | 节点名称（调试用） |
| `children` | table | 子节点列表 |
| `status` | string | 当前状态 (READY/FAILED/SUCCESS/RUNNING) |
| `lastresult` | string | 上一帧状态 |
| `parent` | BehaviourNode | 父节点 |
| `nextupdatetime` | number | 下次更新时间（休眠用） |

| 方法 | 说明 |
|------|------|
| `BehaviourNode:Visit()` | 执行节点逻辑，设置 self.status |
| `BehaviourNode:SaveStatus()` | 保存 lastresult = status，递归子节点 |
| `BehaviourNode:Step()` | 若状态非 RUNNING 则 Reset；否则递归子节点 |
| `BehaviourNode:Reset()` | 重置为 READY，递归子节点 |
| `BehaviourNode:Stop()` | 停止节点，调用 OnStop 回调，递归子节点 |
| `BehaviourNode:Sleep(t)` | 设置休眠时间 t 秒 |
| `BehaviourNode:GetSleepTime()` | 获取休眠时间 |
| `BehaviourNode:GetTreeSleepTime()` | 获取子树最小休眠时间 |
| `BehaviourNode:DoToParents(fn)` | 向上遍历父节点执行 fn |
| `BehaviourNode:DBString()` | 调试字符串（子类覆写） |

---

## 2. 行为树节点类型

### 2.1 组合节点 (Composite Nodes)

#### PriorityNode — 优先级节点 ⭐ 最常用

按优先级依次检查子节点，执行第一个 SUCCESS/RUNNING 的子节点。

| 参数 | 类型 | 说明 |
|------|------|------|
| `children` | table | 子节点列表（按优先级排序） |
| `period` | number | 重新评估间隔（默认 1 秒），设为 nil 则每帧评估 |
| `noscatter` | boolean | 是否禁用随机偏移（避免所有实体同时评估） |

**工作机制**:
1. 按 `period` 间隔重新评估所有子节点
2. 找到第一个 SUCCESS 或 RUNNING 的子节点，设为当前活动节点
3. 评估期间，当前 RUNNING 的子节点继续执行
4. EventNode 触发时会清除 lasttime 强制重评估
5. 如果所有子节点都 FAILED，则整体 FAILED

```lua
-- 示例：猪人行为优先级
PriorityNode({
    Leash(self.inst, ...),        -- 优先级1: 回家
    ChaseAndAttack(self.inst),    -- 优先级2: 战斗
    FaceEntity(self.inst, ...),   -- 优先级3: 面对威胁
    Wander(self.inst, ...),       -- 优先级4: 闲逛
}, 0.5)  -- 每 0.5 秒重评估
```

#### SequenceNode — 顺序节点

依次执行子节点，全部成功才算成功，任一失败则失败。

| 属性 | 说明 |
|------|------|
| `idx` | 当前执行的子节点索引 |

```lua
SequenceNode({
    ConditionNode(function() return self.inst:HasTag("hungry") end),
    ActionNode(function() self.inst:PushEvent("eat") end),
})
```

#### SelectorNode — 选择节点

依次尝试子节点，第一个成功则成功，全部失败则失败。

```lua
SelectorNode({
    ConditionNode(function() return self.inst.components.health:IsDead() end),
    ConditionNode(function() return self.inst.components.sleeper:IsAsleep() end),
})
```

#### ParallelNode — 并行节点

同时执行所有子节点，全部成功则成功，任一失败则失败。ConditionNode 子节点每帧重置。

| 属性 | 说明 |
|------|------|
| `stoponanycomplete` | 任一完成则整体成功（ParallelNodeAny 子类） |

#### LoopNode — 循环节点

循环执行子节点序列，可限制最大循环次数。

| 参数 | 类型 | 说明 |
|------|------|------|
| `children` | table | 子节点序列 |
| `maxreps` | number | 最大循环次数（nil 则无限） |

#### RandomNode — 随机节点

随机选择一个非 FAILED 的子节点执行。

### 2.2 条件节点 (Condition Nodes)

#### ConditionNode

执行条件函数，返回 true 则 SUCCESS，false 则 FAILED。

```lua
ConditionNode(function(self) return self.inst.components.health:IsDead() end)
```

#### MultiConditionNode

多阶段条件：start 函数判断是否进入，continue 函数判断是否继续。

```lua
MultiConditionNode(
    function() return self.inst.components.timer:StartTimer("attack") end,  -- start
    function() return not self.inst.components.timer:TimerDone("attack") end -- continue
)
```

#### ConditionWaitNode

等待条件满足（不满足时返回 RUNNING 而非 FAILED）。

### 2.3 动作节点 (Action Nodes)

#### ActionNode

执行一个动作函数，总是返回 SUCCESS。

```lua
ActionNode(function() self.inst:PushEvent("eat") end)
```

#### WaitNode

等待指定时间。

```lua
WaitNode(3.0)  -- 等待 3 秒
```

### 2.4 装饰节点 (Decorator Nodes)

#### NotDecorator

取反子节点结果（SUCCESS↔FAILED）。

#### FailIfRunningDecorator

子节点 RUNNING 时返回 FAILED（用于 PriorityNode 中跳过长时间运行的任务）。

#### FailIfSuccessDecorator

子节点 SUCCESS 时返回 FAILED（用于 PriorityNode 中依次尝试所有选项）。

#### LatchNode

在 latchduration 时间内只允许进入一次（冷却机制）。

| 参数 | 类型 | 说明 |
|------|------|------|
| `inst` | Entity | 所属实体 |
| `latchduration` | number/function | 冷却时间 |
| `child` | BehaviourNode | 被包装的子节点 |

### 2.5 事件节点 (EventNode)

监听游戏事件，触发时唤醒行为树。

| 参数 | 类型 | 说明 |
|------|------|------|
| `inst` | Entity | 所属实体 |
| `event` | string | 事件名称 |
| `child` | BehaviourNode | 事件触发后执行的子节点 |
| `priority` | number | 优先级（PriorityNode 中用，高优先级事件可打断低优先级） |

**工作机制**:
1. 通过 `inst:ListenForEvent(event, fn)` 监听事件
2. 事件触发时设置 `triggered = true`，调用 `brain:ForceUpdate()`
3. 清除父 PriorityNode 的 lasttime 强制重评估
4. OnStop 时自动 RemoveEventCallback

### 2.6 辅助函数

```lua
-- WhileNode: 每帧检查条件，条件变化会中断子节点
WhileNode(cond_fn, name, node)
  -- 等价于 ParallelNode{ ConditionNode(cond), node }

-- IfNode: 条件通过后持续执行直到完成（不重检查）
IfNode(cond_fn, name, node)
  -- 等价于 SequenceNode{ ConditionNode(cond), node }

-- IfThenDoWhileNode: 进入条件和持续条件分离
IfThenDoWhileNode(ifcond_fn, whilecond_fn, name, node)
  -- 等价于 ParallelNode{ MultiConditionNode(ifcond, whilecond), node }
```

---

## 3. 常用行为节点 (behaviours/)

`scripts/behaviours/` 目录下有 29 个预定义行为节点，可直接在 brain 中使用。

### 3.1 移动类

#### Wander — 闲逛 ⭐ 最常用

| 参数 | 类型 | 说明 |
|------|------|------|
| `inst` | Entity | 实体 |
| `homelocation` | Vector3/function | 家的位置（nil 则不限制） |
| `max_dist` | number/function | 离家最大距离 |
| `times` | table | `{minwalktime, randwalktime, minwaittime, randwaittime}` |
| `getdirectionFn` | function | 获取偏好方向 |
| `setdirectionFn` | function | 存储随机方向 |
| `checkpointFn` | function | 额外检查函数 |
| `data` | table | `{wander_dist, ignore_walls, offset_attempts, should_run, leashwhengoinghome}` |

行为：随机走一段 → 停一段 → 再走。离家太远则回家。

#### Follow — 跟随

| 参数 | 类型 | 说明 |
|------|------|------|
| `inst` | Entity | 实体 |
| `target` | Entity/function | 跟随目标 |
| `min_dist` | number/function | 最小距离（太近则后退） |
| `target_dist` | number/function | 目标距离（到达即成功） |
| `max_dist` | number/function | 最大距离（超过则靠近） |
| `canrun` | boolean | 是否可跑（默认 true） |
| `alwayseval` | boolean | 每次进入都重新计算距离函数（默认 true） |
| `inlimbo_invalid` | boolean | 目标在 limbo 中是否视为失败 |

#### Approach — 靠近

简化版 Follow，只靠近不停留。

| 参数 | 类型 | 说明 |
|------|------|------|
| `target` | Entity/function | 目标 |
| `dist` | number/function | 目标距离 |
| `canrun` | boolean | 是否可跑 |

#### Leash — 牵引/回家

检查实体是否在家的范围内，超出则导航回家。

| 参数 | 类型 | 说明 |
|------|------|------|
| `homelocation` | Vector3/function | 家的位置 |
| `max_dist` | number/function | 最大活动范围 |
| `inner_return_dist` | number/function | 开始回家的距离阈值 |
| `running` | boolean/function | 回家时是否跑步 |

#### RunAway — 逃跑

| 参数 | 类型 | 说明 |
|------|------|------|
| `hunterparams` | string/table/function | 追击者参数：tags/notags/fn/getfn/oneoftags/seeequipped |
| `see_dist` | number | 视野距离 |
| `safe_dist` | number | 安全距离 |
| `fn` | function | 额外条件 |
| `runhome` | boolean | 是否跑回家 |
| `fix_overhang` | boolean | 是否修正海洋悬空 |
| `walk_instead` | boolean | 走而不是跑 |
| `safe_point_fn` | function | 安全点函数 |

#### Panic — 恐慌

随机方向乱跑，每 0.25~0.5 秒换方向。

#### StandStill — 站立不动

| 参数 | 类型 | 说明 |
|------|------|------|
| `startfn` | function | 开始条件（nil 则始终开始） |
| `keepfn` | function | 持续条件（返回 false 则失败） |

### 3.2 战斗类

#### ChaseAndAttack — 追击攻击 ⭐ 核心

| 参数 | 类型 | 说明 |
|------|------|------|
| `inst` | Entity | 实体 |
| `max_chase_time` | number | 最大追击时间 |
| `give_up_dist` | number | 放弃距离 |
| `max_attacks` | number | 最大攻击次数 |
| `findnewtargetfn` | function | 寻找新目标函数 |
| `walk` | boolean | 走而不是跑 |
| `distance_from_ocean_target` | number/function | 海洋目标保持距离 |

行为：导航到 combat.target → 靠近攻击 → 目标死亡 SUCCESS / 超时/太远 FAILED。

#### AttackWall — 攻击墙壁

专门用于攻击墙壁类目标。

#### StandAndAttack — 站立攻击

原地不动进行攻击。

#### StalkerChaseAndAttack — 潜行追击

猎犬/影怪等潜行追击模式。

#### ChaseAndAttackAndAvoid — 追击+躲避

追击同时避开某些威胁。

#### ChaseAndRam — 追击+冲撞

用于冲锋型生物。

### 3.3 寻找类

#### FindClosest — 寻找最近实体

| 参数 | 类型 | 说明 |
|------|------|------|
| `see_dist` | number | 视野距离 |
| `safe_dist` | number/function | 安全距离 |
| `tags` | table/string | 必须拥有的标签 |
| `exclude_tags` | table/string | 必须没有的标签 |
| `one_of_tags` | table/string | 至少拥有一个的标签 |

每 5 秒重新搜索，找到后导航到 safe_dist 距离。

#### FindLight — 寻找光源

寻找最近的 `lightsource` 标签实体并靠近。用于怕黑的生物。

#### FindFlower — 寻找花朵

蜜蜂/蝴蝶专用，寻找花朵并执行 POLLINATE 动作。

#### FindFarmPlant — 寻找农作物

用于照料农田的生物。

### 3.4 交互类

#### FaceEntity — 面向实体

| 参数 | 类型 | 说明 |
|------|------|------|
| `getfn` | function | 获取目标函数 |
| `keepfn` | function | 持续条件 |
| `timeout` | number | 超时时间 |
| `customalert` | string | 自定义 alert 状态名 |

行为：停住，面向目标。如果不在 alert 状态则进入 alert SG。

#### DoAction — 执行动作

| 参数 | 类型 | 说明 |
|------|------|------|
| `getactionfn` | function | 返回 BufferedAction 的函数 |
| `name` | string | 节点名称 |
| `run` | boolean | 是否跑步执行 |
| `timeout` | number | 超时时间 |

行为：获取 action → PushAction → 等待 SuccessAction/FailAction 回调。

#### ChattyNode — 聊天装饰器

包装另一个节点，在 RUNNING 期间定时说话。

| 参数 | 类型 | 说明 |
|------|------|------|
| `chatlines` | string/function/table | 对话内容（STRING_TABLE 名称） |
| `child` | BehaviourNode | 被装饰的子节点 |
| `delay` | number | 说话间隔 |
| `rand_delay` | number | 随机间隔 |
| `enter_delay` | number | 进入延迟 |
| `enter_delay_rand` | number | 进入随机延迟 |

### 3.5 辅助类

#### MinPeriod — 最小间隔

限制子节点成功后必须等待 minperiod 秒才能再次成功。

| 参数 | 类型 | 说明 |
|------|------|------|
| `minperiod` | number | 最小间隔 |
| `immediate` | boolean | 是否允许立即执行第一次 |

#### ControlMinions — 控制仆从

用于控制随从生物的行为。

#### UseShield — 使用护盾

生物使用护盾的逻辑。

#### RunToDist — 跑到指定距离

跑到离目标特定距离的位置。

#### LeashAndAvoid — 牵引+躲避

结合 Leash 和躲避功能。

#### PanicAndAvoid — 恐慌+躲避

恐慌时同时躲避威胁。

#### AvoidLight — 避开光源

用于怕光的生物。

#### AvoidElectricFence — 避开电网

用于避开电围栏。

#### BeargerOffscreen — 熊獾离屏

熊獾离屏时的特殊行为。

---

## 4. 行为树编写模式

### 4.1 典型 Brain 结构

```lua
-- 生物 brain 示例 (scripts/brains/spiderbrain.lua)
require("behaviours/leash")
require("behaviours/chaseandattack")
require("behaviours/wander")
require("behaviours/standstill")
require("behaviours/faceentity")

local SpiderBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function SpiderBrain:OnStart()
    local root = PriorityNode(
    {
        -- 优先级 1: 有敌人在附近？面对它
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        -- 优先级 2: 离家太远？回家
        Leash(self.inst, self.inst:GetPosition(), 15, 12),
        -- 优先级 3: 白天？站着不动
        StandStill(self.inst, function() return not TheWorld.state.isnight end),
        -- 优先级 4: 闲逛
        Wander(self.inst, self.inst:GetPosition(), 10),
    }, .25)
    self.bt = BT(self.inst, root)
end
```

### 4.2 战斗 Brain 结构

```lua
local root = PriorityNode(
{
    -- 优先级最高：战斗
    ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
    -- 回家
    Leash(self.inst, homePos, MAX_WANDER_DIST, MAX_WANDER_DIST),
    -- 闲逛
    Wander(self.inst, homePos, MAX_WANDER_DIST),
}, .25)
```

### 4.3 使用 EventNode 响应事件

```lua
EventNode(self.inst, "attacked",
    PriorityNode({
        ChaseAndAttack(self.inst),
    })
)
```

### 4.4 使用 ChattyNode 添加对话

```lua
ChattyNode(self.inst, "SPIDER_TALK_FOLLOW",
    Follow(self.inst, ...)
)
```

---

## 5. Mod 开发参考

### 5.1 自定义 Behaviour 节点

```lua
-- 在你的 mod 中定义新的行为节点
MyCustomBehaviour = Class(BehaviourNode, function(self, inst, param1, param2)
    BehaviourNode._ctor(self, "MyCustomBehaviour")
    self.inst = inst
    self.param1 = param1
    self.param2 = param2
end)

function MyCustomBehaviour:Visit()
    if self.status == READY then
        -- 初始化逻辑
        self.status = RUNNING
    end

    if self.status == RUNNING then
        -- 执行逻辑
        if some_condition then
            self.status = SUCCESS
        elseif some_fail_condition then
            self.status = FAILED
        else
            self:Sleep(0.25)  -- 休眠 0.25 秒
        end
    end
end
```

### 5.2 替换/扩展 Brain

```lua
-- 在 modmain.lua 中
AddBrainPostInit("spiderbrain", function(self)
    -- 在 brain 初始化后修改行为树
    -- 注意：这需要深入了解原 brain 结构
end)
```

---

## 6. 闭包/可修改参数

以下参数在行为节点内部是闭包变量，但可以通过构造函数传入来间接控制：
- `ChaseAndAttack.onattackfn` — 攻击回调函数
- `Follow._distsq` — 距离计算函数（局部函数，不可修改）
- `Wander.times` — 时间参数表（构造函数传入）
- `RunAway.GetRunAngle` 中的 `avoid_angle/avoid_time` — 躲避角度缓存
- `FindLight.LIGHTS_TAGS` — 光源标签（模块级局部变量，不可直接修改，但可通过构造函数参数影响搜索行为）
