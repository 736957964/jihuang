# 饥荒一线工坊深度研读 Skill：极坐标轮盘交互与手柄模拟量差分采样技术

- **工坊 ID**：352373173 (`Gesture Wheel`)
- **领域分类**：极坐标扇区分布（Polar Coordinate Mapping）、手柄摇杆差分矢量采样、最近邻命中算法、鼠标光标空间还原
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“战术轮盘、装备快选环、法术轮盘、快捷表情”等沉浸式全屏圆环 UI 时：
1. **等分极坐标布局**：通过 $\theta = \frac{2\pi \cdot i}{N}$ 快速解算出子项在二维平面的相对向量；
2. **手柄模拟量差分采样**：通过对相反控制轴做差值，得出归一化二维输入矢量；
3. **最近邻判定与光标还原**：使用距离平方比较代替繁重的几何遮罩，并在交互结束瞬间还原玩家鼠标指针。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：极坐标多项环形轮盘布局组件 (scripts/widgets/radial_menu.lua)
-- ==============================================================================

local Widget = GLOBAL.require("widgets/widget")

local RadialMenu = GLOBAL.Class(Widget, function(self, radius)
    Widget._ctor(self, "RadialMenu")
    self.radius = radius or 200
    self.items = {}
    self.selected_index = nil

    -- 核心：穿透点击，不阻挡下层游戏世界
    self:SetClickable(false)
end)

--- 批量挂载扇区子项并执行极坐标排列
--- @param item_widgets table 已实例化的 Widget 数组
function RadialMenu:SetItems(item_widgets)
    self:KillAllChildren()
    self.items = item_widgets

    local count = #item_widgets
    if count == 0 then return end

    local delta_angle = (2 * math.pi) / count
    local angle = 0

    for i, widget in ipairs(item_widgets) do
        self:AddChild(widget)
        -- 极坐标转笛卡尔直角坐标 (x = r*cos, y = r*sin)
        local x = self.radius * math.cos(angle)
        local y = self.radius * math.sin(angle)
        widget:SetPosition(x, y, 0)
        angle = angle + delta_angle
    end
end

--- 根据屏幕鼠标位置匹配最近邻扇区 (欧氏距离平方比较)
function RadialMenu:UpdateSelectionFromMouse(mouse_x, mouse_y)
    local best_idx = nil
    local min_dist_sq = math.huge

    local center = self:GetPosition()

    for idx, widget in ipairs(self.items) do
        local pos = widget:GetPosition()
        local abs_x = center.x + pos.x
        local abs_y = center.y + pos.y

        local dx = abs_x - mouse_x
        local dy = abs_y - mouse_y
        local dist_sq = dx * dx + dy * dy

        if dist_sq < min_dist_sq then
            min_dist_sq = dist_sq
            best_idx = idx
        end
    end

    self.selected_index = best_idx
    return best_idx
end

-- ==============================================================================
-- 范式 2：手柄模拟量摇杆差分与盲区过滤器 (scripts/tools/controller_analog.lua)
-- ==============================================================================

local function GetAnalogStickVector(use_right_stick)
    local TheInput = GLOBAL.TheInput
    local x, y = 0, 0

    if use_right_stick then
        -- 右摇杆：通常映射在库存控制轴
        x = TheInput:GetAnalogControlValue(GLOBAL.CONTROL_INVENTORY_RIGHT) - TheInput:GetAnalogControlValue(GLOBAL.CONTROL_INVENTORY_LEFT)
        y = TheInput:GetAnalogControlValue(GLOBAL.CONTROL_INVENTORY_UP) - TheInput:GetAnalogControlValue(GLOBAL.CONTROL_INVENTORY_DOWN)
    else
        -- 左摇杆：主移动轴
        x = TheInput:GetAnalogControlValue(GLOBAL.CONTROL_MOVE_RIGHT) - TheInput:GetAnalogControlValue(GLOBAL.CONTROL_MOVE_LEFT)
        y = TheInput:GetAnalogControlValue(GLOBAL.CONTROL_MOVE_UP) - TheInput:GetAnalogControlValue(GLOBAL.CONTROL_MOVE_DOWN)
    end

    local len_sq = x * x + y * y
    local DEADZONE = 0.25 -- 摇杆盲区防漂移阈值

    if len_sq < (DEADZONE * DEADZONE) then
        return nil -- 处于死区内，视作未推动
    end

    return GLOBAL.Vector3(x, y, 0):GetNormalized()
end

-- ==============================================================================
-- 范式 3：光标硬件级居中与记忆还原流水线
-- ==============================================================================

local SAVED_MOUSE_POS = nil

local function OpenRadialWithCursorCapture(screen_center_x, screen_center_y)
    -- 1. 记忆原始鼠标绝对屏幕坐标
    SAVED_MOUSE_POS = GLOBAL.TheInput:GetScreenPosition()

    -- 2. 硬件级移至轮盘中心
    GLOBAL.TheSim:SetMousePos(screen_center_x, screen_center_y)
end

local function CloseRadialAndRestoreCursor()
    if SAVED_MOUSE_POS then
        -- 3. 毫秒级还原至打开前的坐标，消除误触
        GLOBAL.TheSim:SetMousePos(SAVED_MOUSE_POS.x, SAVED_MOUSE_POS.y)
        SAVED_MOUSE_POS = nil
    end
end

return {
    RadialMenu = RadialMenu,
    GetAnalogStickVector = GetAnalogStickVector,
    OpenRadialWithCursorCapture = OpenRadialWithCursorCapture,
    CloseRadialAndRestoreCursor = CloseRadialAndRestoreCursor,
}
```

---

## 三、避坑与生产安全准则

1. **手柄输入必须设置死区阈值（Deadzone）**：
   - 现代手柄不同程度存在物理摇杆轻微漂移（Drift）。若不设置 `len_sq < 0.0625` 的过滤断言，玩家在静止状态下轮盘也会疯狂高频跳变，带来极其恶劣的误触体验。
2. **`TheSim:SetMousePos` 仅限单人或前端客户端调用**：
   - 这是引擎原生视窗鼠标控制 API，只能在客户端生效。如果试图在服务端脚本中调用该接口，会直接报 `attempt to call field 'SetMousePos' (a nil value)` 报错。
