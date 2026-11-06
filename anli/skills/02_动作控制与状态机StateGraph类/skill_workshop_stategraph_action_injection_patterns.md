# 饥荒工业级最佳实践范式：动作状态机轻量切面注入与跨端表现范式

> 权威基准整合：Mod 3670669065 (`Move!!Dragonfly 动作提速`)、Mod 3828396407 (`Real Witch 施法动作`)、Mod 3829489944 (`Cook 料理连打动作`)、Mod 3825229017 (`咒终动作拓展`)、Mod 3684078343 (`神之火腿攻击动作`)
> 技术分类：02_动作控制与状态机StateGraph类 | 领域涵盖：StateGraph 状态注入、ActionHandler 动态绑定、双端客户端预表现

本母本系统阐述饥荒联机版中**向现有角色/生物注入自定义动作（Action）以及挂载专属状态机表现（StateGraph State）**的标准化工程路径。

---

## 一、核心原理与双端时序机制

饥荒联机版动作的执行链路包含三个核心环：
1. **Action 注册**：通过 `AddAction(action)` 声明一个可交互的动作名；
2. **SG 处理器挂载**：通过 `AddStategraphActionHandler(sg_name, action_handler)` 告知状态机该动作触发后应跳转到哪个 State；
3. **双端同步**：`wilson.lua`（服务端主状态机）与 `wilson_client.lua`（客户端预表现状态机）必须**成对编写**，否则会导致客机动作卡顿或回弹！

---

## 二、标准化生产级代码范式（包含完整三步闭环）

```lua
local GLOBAL = GLOBAL
local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler

-- 1. 注册核心通用动作
local CUSTOM_INTERACT = Action({ mount_valid = true })
CUSTOM_INTERACT.id = "CUSTOM_INTERACT"
CUSTOM_INTERACT.str = "执行互动"
CUSTOM_INTERACT.fn = function(act)
    if act.doer and act.target and act.doer.components.combat then
        -- 核心业务逻辑实现
        return true
    end
    return false
end
AddAction(CUSTOM_INTERACT)

-- 2. 状态机动作处理器绑定（服务端 + 客机端双端注册）
local custom_handler = ActionHandler(CUSTOM_INTERACT, "custom_action_state")

AddStategraphActionHandler("wilson", custom_handler)
AddStategraphActionHandler("wilson_client", custom_handler)

-- 3. 动态注入专属 StateGraph 状态（以快速施法/连打为例）
local function AddCustomState(sg)
    local state = GLOBAL.State({
        name = "custom_action_state",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_unique")
            inst.sg:SetTimeout(10 * GLOBAL.FRAMES)
        end,

        timeline = {
            GLOBAL.TimeEvent(4 * GLOBAL.FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            GLOBAL.TimeEvent(6 * GLOBAL.FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,

        events = {
            GLOBAL.EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    })
    
    sg.states["custom_action_state"] = state
end

AddStategraphPostInit("wilson", AddCustomState)
AddStategraphPostInit("wilson_client", AddCustomState)
```

---

## 三、工坊五大代表性变体演进与技术剖析

1. **变体 1：BOSS/生物特定动作提速（以 Move!!Dragonfly 为例）**
   - 针对龙蝇 `dragonfly` 的状态机 `sg_dragonfly`，通过在 `onenter` 阶段修改 `inst.Physics:SetMotorVelOverride` 突破默认动作前后摇；
2. **变体 2：连续烹饪与料理连击（以 Cook 为例）**
   - 移除动作状态中的 `"busy"` 标签，使玩家无需等待完整动画结束即可流水线式将食材投入锅中；
3. **变体 3：自定义武器专属挥舞与状态切换（以神之火腿为例）**
   - 在 `ActionHandler` 中判定 `doer.replica.combat:GetWeapon()`，根据手持武器类型动态派发至重击或轻挑动作；
4. **变体 4：纯客户端预表现动画（以 Real Witch 为例）**
   - 利用 `wilson_client` 提前 0.1 秒渲染施法光圈，消除公网 100ms+ 网络延迟带来的割裂感。

---

## 四、防御性编程与避坑准则
1. **PerformBufferedAction 触发时机**：严禁在 `onenter` 第一帧直接调用，必须设置在动作动画命中帧（如 `timeline` 的第 4~8 帧），否则极易导致客户端动作未渲染直接结算；
2. **busy 标签死锁防御**：任何带有 `"busy"` 标签的 State，**必须配置 `ontimeout` 兜底跳转 `idle`**，防止因被怪物攻击打断动画后，角色永久卡死无法走位。
