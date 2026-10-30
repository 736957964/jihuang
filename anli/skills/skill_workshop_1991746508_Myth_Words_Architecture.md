# 饥荒一线工坊深度研读 Skill：神话书说 (Myth Words) 顶尖架构与核心系统范式

- **工坊 ID**：1991746508 (`[DST] Myth Words / 神话书说`)
- **领域分类**：超大型 MOD 工业级架构、多态 Action 与 StateGraph 动态分发、容器全生命周期扩展、跨世界 Shard RPC 状态同步
- **研读源码**：`modmain.lua`、`main/actions.lua`、`main/containers.lua`、`main/components.lua`、`main/mod_rpc.lua`

---

## 一、核心实现原理与架构全貌

神话书说作为联机版饥荒社区体量最大、运行极其稳定的 MOD 之一，其代码体系堪称饥荒 Lua 开发的工业级教科书。本次研读深度拆解了其 4 大核心系统：

### 1. 动态多态 Action 调度与 StateGraph (SG) 双端无缝映射
- **痛点**：传统 MOD 为每个小功能定义一个 Action（如喝葫芦酒一个、取地灯一个、用照妖镜一个），导致 Action 数量爆炸，且多人联机下客户端动作预测容易出现 SG 状态不匹配（打滑、卡动作）。
- **神话解法**：采用统一的“抽象多态动作” `MYTH_USE_INVENTORY`。
  - Action 的 `strfn` 不写死，而是读取 `target.MYTH_USE_TYPE` 动态返回动作文本（如 `DRINK`, `QUDENG`, `MIRROR`, `COIN`）。
  - Action 的 `fn` 实行管道分发：依次探测目标挂载的组件（`myth_redlantern_ground`, `use_gourd`, `myth_use_inventory`），解耦具体道具与公共 Action。
  - **SG 映射技巧**：在 `wilson` 与 `wilson_client` 的 ActionHandler 中，不写死单一 State，而是优先读取物品自定义的 `target.onusesgname`，骑行状态自动降级为 `dolongaction`，通用则回退到 `give`。彻底解决一个动作适配数十种动作表现的问题。

### 2. 容器（Containers）注册的全局槽位安全对齐
- **痛点**：第三方容器直接注入 `params[prefab]` 会导致 `containers.MAXITEMSLOTS` 计算偏小，造成客户端 UI 渲染越界崩服或槽位不可交互。
- **神话解法**：
  - 动态计算最大槽位：
    ```lua
    for k, v in pairs(params) do
        containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
    end
    ```
  - 双端 Button RPC 防抖规范：`widget.buttoninfo.fn` 中服务端直接调用 `BufferedAction(doer, inst, ACTIONS.FUR_COOK):Do()`；客户端先判定 `not inst.replica.container:IsBusy()`，再通过 `SendRPCToServer(RPC.DoWidgetButtonAction, ...)` 上报。

### 3. 组件非破坏性拦截（Decorator / Pipeline 拦截模式）
- **核心准则**：绝不暴力覆盖官方组件函数，始终保留并透传 `oldFn(self, ...)`。
- **神话特色技巧**：
  - **惩罚值计算假装复原法**：在 `sanity:RecalculatePenalty` 中，如果玩家拥有防惩罚 Buff，先将其置 false 调用原函数，再立即置回 true，既保留官方内在惩罚重新计算的整套逻辑，又规避了多重 Hook 冲突。
  - **食用属性全局重定向**：在 `edible` 组件的 `GetSanity/GetHunger/GetHealth` 中拦截负值（`old > 0 and old or 0`），完美实现“吃坏东西不扣三维”的 Buff 特性。

### 4. 跨世界 Shard RPC 状态同步与持久化恢复
- 注册 `AddShardModRPCHandler` 处理洞穴与地表多世界切换，采用 `pcall(json.decode, value)` 保证主从世界广播即便受到脏数据也绝不炸服崩服。

---

## 二、标准化生产级代码范式 (可直接移植开发)

```lua
-- ==============================================================================
-- 范式 1：工业级多态抽象 Action 模式 (Polymorphic Action Pattern)
-- 适用：单个 MOD 内存在数十种具有“右键使用/地块交互”的独立法宝、道具、建筑
-- ==============================================================================

local MY_POLYMORPHIC_ACTION = Action({ priority = 1, mount_valid = true })
MY_POLYMORPHIC_ACTION.id = "MY_POLYMORPHIC_ACTION"

-- 动态显示动作文本
MY_POLYMORPHIC_ACTION.strfn = function(act)
    local target = act.invobject or act.target
    return (target and target.action_string_override) or "USE"
end

-- 管道化执行入口 (服务端执行)
MY_POLYMORPHIC_ACTION.fn = function(act)
    local target = act.invobject or act.target
    if not target then return false end
    
    -- 管道分发策略：各模块挂载专属组件
    if target.components.custom_consumable then
        return target.components.custom_consumable:OnUse(act.doer)
    elseif target.components.custom_interactable then
        return target.components.custom_interactable:OnInteract(act.doer)
    end
    return false
end
AddAction(MY_POLYMORPHIC_ACTION)

-- 背包栏/地上场景 双通道 Hook
AddComponentAction("INVENTORY", "custom_usable", function(inst, doer, actions)
    if inst:HasTag("can_use_in_inv") and (not inst.need_tag or doer:HasTag(inst.need_tag)) then
        table.insert(actions, ACTIONS.MY_POLYMORPHIC_ACTION)
    end
end)

AddComponentAction("SCENE", "custom_usable", function(inst, doer, actions, right)
    if right and inst:HasTag("can_use_in_scene") then
        table.insert(actions, ACTIONS.MY_POLYMORPHIC_ACTION)
    end
end)

-- 双端 SG 状态机映射 (自适应各种道具独有动作)
local function ResolveUseState(inst, action)
    local target = action.target or action.invobject
    if target and target.custom_sg_state ~= nil then
        return target.custom_sg_state
    end
    -- 骑牛检测兜底
    if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        return "dolongaction"
    end
    return "give"
end

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MY_POLYMORPHIC_ACTION, ResolveUseState))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MY_POLYMORPHIC_ACTION, ResolveUseState))


-- ==============================================================================
-- 范式 2：零崩服容器（Container）标准化安全注入
-- ==============================================================================
local containers = require "containers"
local params = containers.params

params.my_alchmy_box = {
    widget = {
        slotpos = {
            Vector3(0, 36, 0),
            Vector3(0, -36, 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo = {
            text = "炼制",
            position = Vector3(0, -100, 0),
            fn = function(inst, doer)
                if inst.components.container ~= nil then
                    BufferedAction(doer, inst, ACTIONS.MY_POLYMORPHIC_ACTION):Do()
                elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.MY_POLYMORPHIC_ACTION.code, inst, ACTIONS.MY_POLYMORPHIC_ACTION.mod_name)
                end
            end,
            validfn = function(inst)
                return inst.replica.container ~= nil and inst.replica.container:IsFull()
            end,
        }
    },
    acceptsstacks = false,
    type = "chest",
    itemtestfn = function(container, item, slot)
        -- 过滤不可替换物与特定禁入物
        return not item:HasTag("irreplaceable") and not item:HasTag("_container")
    end,
}

-- 严谨刷新全图最大槽位限制，杜绝 UI 截断
for _, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, (v.widget and v.widget.slotpos and #v.widget.slotpos) or 0)
end
```

---

## 三、踩坑与避错实战指南 (硬核一线经验)

1. **容器 Button RPC 狂点崩溃**：
   - 在客户端通过 `widget.buttoninfo.fn` 发送 RPC 时，千万不能直接发，**必须加 `not inst.replica.container:IsBusy()` 防抖**！否则玩家连点会导致服务端并发处理同一个容器事务，抛出 `attempt to index nil value`。
2. **多语言字符串热替换的 table/string 陷阱**：
   - 饥荒原生 `STRINGS.ACTIONS.ADDFUEL` 默认是一个 string。如果直接将其视为 table 写入 `STRINGS.ACTIONS.ADDFUEL.GOURD = ...` 会直接报尝试索引字符串的致命错误。必须像神话书说一样先做类型探测：
     ```lua
     if type(STRINGS.ACTIONS.ADDFUEL) == 'string' then 
         STRINGS.ACTIONS.ADDFUEL = { ADDFUEL = STRINGS.ACTIONS.ADDFUEL }
     end
     ```
3. **骑乘（Riding）状态下的动作兼容性**：
   - 许多 SG 状态（如 `construct`, `doshortaction`）在玩家骑乘皮弗娄牛时没有对应的动作动画，强行调用会导致角色瞬移、滑步或直接卡死在骑乘位。因此在 `AddStategraphActionHandler` 回调中，必须通过 `inst.replica.rider ~= nil and inst.replica.rider:IsRiding()` 判断，骑乘时强制降级为牛牛支持的 `dolongaction`。
