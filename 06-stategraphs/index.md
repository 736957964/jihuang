# 状态机系统 (StateGraphs)

> 源码: `scripts/stategraph.lua` + `scripts/stategraphs/*.lua`

## 概述

StateGraph（SG）是 DST 中的状态机系统，控制所有实体的行为动画、状态切换和事件响应。每个实体可以挂载一个 SG，SG 定义了该实体所有可能的状态和状态转换规则。

## StateGraph 类

### 创建 SG

```lua
local StateGraph = require("stategraph")

local function GetMyStateGraph()
    local sg = StateGraph("my_sg_name")
    
    -- 定义状态
    sg:AddState("idle", State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle")
        end,
        events = {
            EventHandler("attacked", function(inst)
                sg:GoToState("hit")
            end),
        },
        timeline = {
            TimeEvent(10 * FRAMES, function(inst)
                -- 10帧后执行
            end),
        },
    })
    
    return sg
end

-- 在实体上使用
inst:SetStateGraph(GetMyStateGraph())
```

### State 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `name` | string | 状态名称 |
| `tags` | table | 状态标签（如 "busy", "idle", "nopredict"） |
| `onenter` | function | 进入状态回调 `fn(inst, pushanim)` |
| `onupdate` | function | 每帧更新回调 `fn(inst, dt)` |
| `onexit` | function | 退出状态回调 `fn(inst)` |
| `ontimeout` | function | 超时回调 |
| `events` | table | 事件处理器列表 |
| `timeline` | table | 时间线事件列表 |

### EventHandler

```lua
EventHandler("eventname", function(inst, data)
    -- 处理事件
end)
```

### TimeEvent

```lua
TimeEvent(frame_count, function(inst)
    -- 帧数后执行
end)
```

## StateGraph 方法

| 方法 | 说明 |
|------|------|
| `sg:GoToState(state, params)` | 切换到指定状态 |
| `sg:HasStateTag(tag)` | 当前状态是否有指定标签 |
| `sg:AddStateTag(tag)` | 添加状态标签 |
| `sg:RemoveStateTag(tag)` | 移除状态标签 |
| `sg:SetTimeout(time)` | 设置超时时间 |
| `sg:ClearTimeout()` | 清除超时 |
| `sg:PushState(state)` | 推入状态栈 |
| `sg:PopState()` | 弹出状态栈 |
| `sg:GetState()` | 获取当前状态 |

## 通用状态标签

| 标签 | 说明 |
|------|------|
| `busy` | 忙碌（不可中断） |
| `idle` | 空闲 |
| `canrotate` | 可旋转 |
| `nopredict` | 客户端不预测 |
| `nomorph` | 不变形 |
| `pausepredict` | 暂停预测 |
| `attack` | 攻击中 |
| `hit` | 受击中 |
| `sleeping` | 睡眠中 |
| `dead` | 死亡 |
| `hiding` | 隐藏 |
| `iframeskeepaggro` | 无敌帧保持仇恨 |
| `nointerrupt` | 不可中断 |

## 常用 SG 文件列表

源码中有约 261 个 SG 文件，以下是最常用的：

| SG 文件 | 对应实体 |
|---------|----------|
| `SGwilson.lua` | 威尔逊（基础人类 SG） |
| `SGspider.lua` | 蜘蛛 |
| `SGhound.lua` | 猎犬 |
| `SGdeerclops.lua` | 巨鹿 |
| `SGbearger.lua` | 熊大 |
| `SGdragonfly.lua` | 龙蝇 |
| `SGbeefalo.lua` | 牦牛 |
| `SGpigman.lua` | 猪人 |
| `SGtallbird.lua` | 高脚鸟 |
| `SGkoalefant.lua` | 考拉象 |
| `SGspiderqueen.lua` | 蜘蛛女王 |
| `SGtoadstool.lua` | 蟾蜍 |
| `SGbee.lua` | 蜜蜂 |
| `SGkillerbee.lua` | 杀人蜂 |
| `SGmoose.lua` | 鹿鹅 |
| `SGantlion.lua` | 蚁狮 |
| `SGklaus.lua` | 克劳斯 |

## 编写 SG 示例

```lua
-- 自定义生物 SG
local function GetMySG()
    local sg = StateGraph("SGmycreature")
    
    -- 空闲状态
    sg:AddState("idle", State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
        events = {
            EventHandler("locomote", function(inst)
                if inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("busy") then
                    sg:GoToState("walk")
                end
            end),
            EventHandler("attacked", function(inst)
                sg:GoToState("hit")
            end),
            EventHandler("doattack", function(inst, data)
                if data.target and inst:IsValid() then
                    sg:GoToState("attack", data.target)
                end
            end),
        },
    })
    
    -- 行走状态
    sg:AddState("walk", State{
        name = "walk",
        tags = {"moving", "canrotate"},
        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
            inst.AnimState:PushAnimation("walk_loop", true)
        end,
        onexit = function(inst)
            inst.components.locomotor:Stop()
        end,
        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    sg:GoToState("idle")
                end
            end),
        },
    })
    
    -- 攻击状态
    sg:AddState("attack", State{
        name = "attack",
        tags = {"attack", "busy"},
        onenter = function(inst, target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("attack")
            inst.sg.statemem.target = target
        end,
        timeline = {
            TimeEvent(10 * FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
        },
        events = {
            EventHandler("animdone", function(inst)
                sg:GoToState("idle")
            end),
        },
    })
    
    -- 受击状态
    sg:AddState("hit", State{
        name = "hit",
        tags = {"busy", "hit"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.components.locomotor:Stop()
        end,
        events = {
            EventHandler("animdone", function(inst)
                sg:GoToState("idle")
            end),
        },
    })
    
    -- 死亡状态
    sg:AddState("death", State{
        name = "death",
        tags = {"busy", "dead"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("death")
            inst:AddTag("NOCLICK")
        end,
        timeline = {
            TimeEvent(60 * FRAMES, function(inst)
                inst:Remove()
            end),
        },
    })
    
    return sg
end

-- 使用
inst:SetStateGraph(GetMySG())
```

## Mod 中修改 SG

```lua
-- 使用 AddStategraphPostInit 修改现有 SG
AddStategraphPostInit("SGwilson", function(sg)
    -- 添加新状态
    sg:AddState("my_state", State{...})
    
    -- 修改现有状态
    -- sg.states["idle"].onenter = ...
end)

-- 添加状态动作处理器
AddStategraphActionHandler("SGwilson", function(inst, action)
    -- 返回要切换的状态名
end)

-- 添加状态事件处理器
AddStategraphEventHandler("SGwilson", function(inst, data)
    -- 返回要切换的状态名
end)
```
