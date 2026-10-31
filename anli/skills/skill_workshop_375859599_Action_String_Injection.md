# 饥荒一线工坊深度研读 Skill：非侵入式动作提示拦截与瞬态生命周期注入技术

- **工坊 ID**：375859599 (`Health Info`)
- **领域分类**：动作文本切面拦截（`BufferedAction:GetActionString`）、瞬态生命周期标记（Transient Context Flag）、黑白名单哈希分流、递归栈溢出防护
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“悬浮信息查看器、战力评估雷达、装备耐久感知”等信息类 Mod 时，直接篡改实体的 `GetDisplayName` 是极其危险的坏味道代码，极易导致官方逻辑因名字被改而崩服。正确且优雅的标准解法是：
1. **瞬态上下文标记**：在 `playercontroller:GetLeftMouseAction` 捕获到目标时开启标记；
2. **动作文本渲染切面**：在 `BufferedAction:GetActionString` 中消费标记并格式化属性；
3. **安全闭环重置**：在 `DoAction` 与 `GetRightMouseAction` 中确保标记彻底销毁。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：非侵入式动作文本瞬态注入器 (scripts/tools/action_string_injector.lua)
-- ==============================================================================

local ActionStringInjector = {}
local SHOULD_INJECT = false
local INJECT_LOCK = 0 -- 防递归死循环锁

--- 安全函数拦截代理
local function HookFunction(tbl, fn_name, wrapper_fn)
    local old_fn = tbl[fn_name]
    if not old_fn then return end
    tbl[fn_name] = function(self, ...)
        local result = old_fn(self, ...)
        return wrapper_fn(result, self, ...)
    end
end

--- 安装核心交互拦截切面
function ActionStringInjector.Install()
    local controller = GLOBAL.require("components/playercontroller")
    local BufferedAction = GLOBAL.BufferedAction

    -- 1. 左键动作评估：仅当鼠标聚焦于有效非自身目标时，激发瞬态标记
    HookFunction(controller, "GetLeftMouseAction", function(lmb, self)
        if lmb and lmb.target and lmb.target ~= lmb.doer and lmb.invobject == nil then
            SHOULD_INJECT = true
        end
        return lmb
    end)

    -- 2. 状态机闭环安全重置 (右键点击或执行动作时立即清理)
    HookFunction(controller, "GetRightMouseAction", function(rmb)
        SHOULD_INJECT = false
        return rmb
    end)
    HookFunction(controller, "DoAction", function(res)
        SHOULD_INJECT = false
        return res
    end)

    -- 3. 拦截动作显示文本：仅在渲染屏幕提示时动态注入，不改变 Entity 的原始 DisplayName
    HookFunction(BufferedAction, "GetActionString", function(str, self)
        if SHOULD_INJECT and INJECT_LOCK == 0 then
            INJECT_LOCK = INJECT_LOCK + 1
            if self.target and self.target:IsValid() then
                -- 从目标实体读取权威血量数据 (优先读取客机同步的轻量网络字段)
                local hp = self.target.health_info or (self.target.components.health and self.target.components.health.currenthealth)
                local max_hp = self.target.health_info_max or (self.target.components.health and self.target.components.health.maxhealth)

                if hp and max_hp then
                    str = string.format("%s <%d / %d>", str, math.floor(hp + 0.5), math.floor(max_hp + 0.5))
                end
            end
            INJECT_LOCK = INJECT_LOCK - 1
            SHOULD_INJECT = false -- 单次消费后立刻释放
        end
        return str
    end)
end

-- ==============================================================================
-- 范式 2：O(1) 黑名单高效实体过滤管线 (scripts/tools/entity_filter_pipeline.lua)
-- ==============================================================================

local BLACKLIST_PREFABS = {
    ["debris"] = true,
    ["fx"] = true,
    ["shadowhand"] = true,
    ["marsh_plant"] = true,
}

--- 极速过滤无需展示状态信息的实体
local function ShouldIgnoreEntity(inst)
    if not inst or not inst:IsValid() then return true end
    -- 1. 静态哈希黑名单判定 (毫秒级短路)
    if BLACKLIST_PREFABS[inst.prefab] then return true end
    -- 2. 物理与网络标识过滤
    if inst:HasTag("FX") or inst:HasTag("INLIMBO") or inst:HasTag("DECOR") then
        return true
    end
    return false
end

return {
    ActionStringInjector = ActionStringInjector,
    ShouldIgnoreEntity = ShouldIgnoreEntity,
}
```

---

## 三、避坑与生产安全准则

1. **防递归死循环锁 `INJECT_LOCK` 必不可少**：
   - 某些第三方 UI 模组或输入扩展插件可能会在自己的处理函数内再次调用 `BufferedAction:GetActionString()`。如果缺少 `INJECT_LOCK`，两次连续调用会引发死循环，瞬间撑爆 Lua 调用栈。
2. **严禁在 `GetActionString` 中修改实体状态**：
   - 动作字符串获取函数是纯渲染读取层，每帧都在高频触发。绝对不要在其中调用任何可能改变游戏逻辑状态的函数（如 `inst:AddTag`、`PushEvent`），否则会在多线程或网络同步时引发灾难级的不同步现象。
