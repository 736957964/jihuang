# 大脑/行为树系统 (Brains)

> 源码: `scripts/brains/*.lua`

## 概述

Brain 是 DST 中的 AI 系统，基于行为树（BehaviourTree）实现。每个 AI 生物都有一个 Brain 文件，定义了其决策逻辑：优先级、行为节点、条件判断等。

## 行为树基础

DST 行为树由以下节点组成：

### 组合节点

| 节点 | 说明 |
|------|------|
| `PriorityNode(children, period)` | 优先级节点（按顺序尝试子节点，成功则停止） |
| `ParallelNode(children, period)` | 并行节点（同时运行所有子节点） |
| `SequenceNode(children, period)` | 顺序节点（依次运行子节点） |
| `WhileNode(condition, child)` | 条件循环节点 |

### 动作节点

| 节点 | 说明 |
|------|------|
| `ActionNode(fn, ...)` | 执行动作 |
| `WaitNode(time)` | 等待 |
| `IfNode(fn, ...)` | 条件分支 |
| `LoopNode(children)` | 循环 |

### 装饰器节点

| 节点 | 说明 |
|------|------|
| `FailIf(fn)` | 条件失败则失败 |
| `SucceedIf(fn)` | 条件成功则成功 |
| `NotDecorator(child)` | 取反 |

## 行为树返回值

| 常量 | 说明 |
|------|------|
| `SUCCESS` | 成功 |
| `FAIL` | 失败 |
| `RUNNING` | 运行中 |

## 编写 Brain

```lua
require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/runaway"

local BrainCommon = require "brains/braincommon"

local MyCreatureBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function MyCreatureBrain:OnStart()
    -- 构建行为树根节点
    local root = PriorityNode(
    {
        -- 最高优先级：逃跑
        RunAway(self.inst, "scarytoprey", 15, 10),
        
        -- 攻击
        ChaseAndAttack(self.inst, 8, 10),
        
        -- 漫游
        Wander(self.inst),
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return MyCreatureBrain
```

## 常用行为 (Behaviours)

源码 `scripts/behaviours/` 目录下约 70+ 个行为模块：

| 行为文件 | 说明 |
|----------|------|
| `wander.lua` | 漫游 |
| `chaseandattack.lua` | 追踪攻击 |
| `runaway.lua` | 逃跑 |
| `follow.lua` | 跟随 |
| `standandattack.lua` | 站立攻击 |
| `leash.lua` | 范围限制（不离开区域） |
| `avoidlight.lua` | 避开光 |
| `attackwall.lua` | 攻击墙 |
| `guard.lua` | 守卫 |
| `eatfood.lua` | 吃食物 |
| `pickup.lua` | 拾取物品 |
| `sleep.lua` | 睡觉 |
| `gohome.lua` | 回家 |
| `inspectitem.lua` | 检查物品 |
| `hidefrom.lua` | 躲避 |
| `faceentity.lua` | 面向实体 |
| `facepoint.lua` | 面向点 |

## 常用 Brain 文件

| Brain 文件 | 对应生物 |
|-----------|----------|
| `spiderbrain.lua` | 蜘蛛 |
| `houndbrain.lua` | 猎犬 |
| `pigbrain.lua` | 猪人 |
| `beefalobrain.lua` | 牦牛 |
| `deerclopsbrain.lua` | 巨鹿 |
| `dragonflybrain.lua` | 龙蝇 |
| `beargerbrain.lua` | 熊大 |
| `tallbirdbrain.lua` | 高脚鸟 |
| `koalefantbrain.lua` | 考拉象 |
| `spiderqueenbrain.lua` | 蜘蛛女王 |
| `beequeenbrain.lua` | 蜂后 |
| `toadstoolbrain.lua` | 蟾蜍 |
| `klausbrain.lua` | 克劳斯 |

## 行为编写示例

```lua
-- 自定义追逐攻击
local function MyChaseAndAttack(inst, max_chase_time, max_chase_distance)
    local function ShouldAttack(target)
        return target ~= nil
            and inst.components.combat:CanTarget(target)
    end
    
    local function KeepAttacking(target)
        return target ~= nil
            and target:IsValid()
            and not target:HasTag("playerghost")
    end
    
    return ChaseAndAttack(inst, max_chase_time, max_chase_distance)
end

-- 自定义漫游
local function MyWander(inst)
    local wander = Wander(inst)
    -- 包装条件
    return WhileNode(function()
        return not inst.components.health:IsDead()
    end, "Wander", wander)
end
```

## Mod 中使用

```lua
-- 给生物添加 Brain
local brain = require("brains/mybossbrain")
inst:SetBrain(brain)

-- 修改现有 Brain（通过 PrefabPostInit）
AddPrefabPostInit("spider", function(inst)
    -- 重新设置 brain
    local MySpiderBrain = require("brains/spiderbrain")
    -- 可以继承后修改
end)

-- 自定义行为
-- 在 scripts/behaviours/ 下创建新文件
-- 然后在 brain 中引用
```
