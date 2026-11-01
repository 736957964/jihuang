# 饥荒一线工坊深度研读 Skill：事件驱动型 HUD 状态数值注入与跨端状态嗅探

- **工坊 ID**：376333686 (`Combined Status`)
- **领域分类**：客户端 UI 强化、Badge 控件切面扩展、事件驱动高性能监听、客机实体状态安全 Getter
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在饥荒界面开发中，直接修改核心 Badge 控件是极其危险的，极易与其他人物 MOD 或界面美化 MOD 冲突。`Combined Status` 的规范示范了：**通过 Decorator 模式包装 `SetPercent`，结合饥荒事件总线（Event Bus）做只读数值渲染**。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：状态徽章（Badge）非侵入式数字渲染注入 (scripts/tools/badge_number_decorator.lua)
-- ==============================================================================

local Text = require "widgets/text"
local NUMBERFONT = GLOBAL.NUMBERFONT

local function InjectStatusNumber(badge, config)
    if not badge or badge._has_injected_number then return end
    badge._has_injected_number = true

    -- 1. 创建挂载在 Badge 底层的数字文本
    local num = badge:AddChild(Text(NUMBERFONT, config and config.size or 24))
    num:SetHAlign(GLOBAL.ANCHOR_MIDDLE)
    num:SetPosition(0, -38, 0)
    num:SetScale(1, 0.8, 1)
    num:MoveToFront()
    badge.injected_num = num

    -- 2. 拦截 SetPercent 原语
    local old_SetPercent = badge.SetPercent
    badge.SetPercent = function(self, val, max, penaltypercent)
        old_SetPercent(self, val, max, penaltypercent)
        
        -- 安全格式化：支持详细模式或简易模式
        if self.injected_num then
            local current = math.ceil(val * (max or 100))
            if config and config.show_max and max then
                self.injected_num:SetString(string.format("%d/%d", current, math.floor(max)))
            else
                self.injected_num:SetString(tostring(current))
            end
        end
    end
end

-- ==============================================================================
-- 范式：客户端只读状态安全提取器 (Client-Safe Status Getter)
-- ==============================================================================

local function GetSafePlayerStatus(player)
    if not player or not player:IsValid() then return nil end

    local is_dst = GLOBAL.TheSim.GetGameID ~= nil and GLOBAL.TheSim:GetGameID() == "DST"

    -- 温度安全获取 (避免客户端 components 为 nil 崩溃)
    local temperature = 0
    if is_dst and player.GetTemperature then
        temperature = player:GetTemperature()
    elseif player.components and player.components.temperature then
        temperature = player.components.temperature.current
    end

    -- 湿度安全获取
    local moisture = 0
    if is_dst and player.GetMoisture then
        moisture = player:GetMoisture()
    elseif player.components and player.components.moisture then
        moisture = player.components.moisture:GetMoisture()
    end

    return {
        temperature = math.floor(temperature + 0.5),
        moisture = math.floor(moisture + 0.5),
    }
end

return {
    InjectStatusNumber = InjectStatusNumber,
    GetSafePlayerStatus = GetSafePlayerStatus,
}
```

---

## 三、避坑与生产安全准则

1. **绝对禁止在 UI 中直接读取非主机服务端的 `components`**：
   - 联机版客机上，`player.components.health` / `player.components.temperature` 默认不存在或不包含权威数值。必须优先读取 `player.replica.health:GetCurrent()` 或 `player:GetTemperature()`，严禁 `player.components.temperature.current`！
2. **事件监听必须指定所属监听器（`inst:ListenForEvent(..., target)`）**：
   - 监听玩家身上的变化事件（如 `temperaturedelta`）时，必须将玩家作为第三个参数传入：`badge.inst:ListenForEvent("temperaturedelta", callback, player)`。这样当玩家死亡或切人时，引擎会自动解除对销毁实体的回调引用，防止内存泄漏。
