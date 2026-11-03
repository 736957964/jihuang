# 饥荒一线工坊深度研读 Skill：HUD 矩阵反缩放自适应与视口输入隔离机制

- **工坊 ID**：345692228 (`Minimap HUD`)
- **领域分类**：客户端 UI 工程、HUD 矩阵逆缩放坐标系对齐、窗口动态重排、摄像机与输入冲突隔离
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发饥荒联机版的悬浮窗口、状态栏或雷达时，开发者常面临：
1. 玩家调整了游戏系统设置中的 **HUD 缩放比例**，导致控件溢出屏幕边缘；
2. 玩家**拖动窗口边框**或在全屏/无边框窗口间切换，UI 错位；
3. 鼠标悬停在 UI 上滚动滚轮，误触发游戏视角拉近拉远。

`Minimap HUD` 提炼了一套纯数学且极其轻量的防御框架。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- ==============================================================================

local Widget = require "widgets/widget"

local ResponsiveContainer = Class(Widget, function(self, owner)
    Widget._ctor(self, "ResponsiveContainer")
    self.owner = owner
    self.camera_lock = false
end)

function ResponsiveContainer:Reposition(controls, align_x, align_y, margin_x, margin_y)
    local hudscale = controls.top_root:GetScale()
    local screenw_full, screenh_full = GLOBAL.TheSim:GetScreenSize()
    
    local screenw = screenw_full / hudscale.x
    local screenh = screenh_full / hudscale.y

    local target_x = 0
    local target_y = 0

    if align_x == "right" then
        target_x = (screenw * 0.5) - margin_x
    elseif align_x == "left" then
        target_x = -(screenw * 0.5) + margin_x
    end

    if align_y == "top" then
        target_y = (screenh * 0.5) - margin_y
    elseif align_y == "bottom" then
        target_y = -(screenh * 0.5) + margin_y
    end

    self:SetPosition(target_x, target_y, 0)
end

function ResponsiveContainer:OnGainFocus()
    ResponsiveContainer._base.OnGainFocus(self)
    if GLOBAL.TheCamera and GLOBAL.TheCamera:IsControllable() then
        self.camera_lock = true
        GLOBAL.TheCamera:SetControllable(false)
    end
end

function ResponsiveContainer:OnLoseFocus()
    ResponsiveContainer._base.OnLoseFocus(self)
    if self.camera_lock and GLOBAL.TheCamera then
        GLOBAL.TheCamera:SetControllable(true)
        self.camera_lock = false
    end
end

function ResponsiveContainer:OnControl(control, down)
    if ResponsiveContainer._base.OnControl(self, control, down) then return true end
    if control == GLOBAL.CONTROL_MAP_ZOOM_IN or control == GLOBAL.CONTROL_MAP_ZOOM_OUT then
        return true
    end
    return false
end

return ResponsiveContainer
end
end```

---

## 三、避坑与生产安全准则

1. **`OnLoseFocus` 必须兜底防漏**：
   - 如果用户在悬停该 UI 的瞬间按下了 ESC 键切出菜单，或者切回桌面，可能会跳过 `OnLoseFocus`。建议在控件的 `Kill` 和 `Hide` 方法中，同样加入对 `TheCamera:SetControllable(true)` 的安全恢复调用，防止玩家摄像机被永久锁死。
2. **`controls.OnUpdate` 增量轻量比较**：
   - 监听窗口分辨率变化时，切忌每帧去调用复杂的布局计算。只在 `w ~= last_w or h ~= last_h` 时才触发一次 `Reposition`。

## 五、进阶拓扑演进与变体分支

### 变体演进：Minecraft HUD (Mod 3649427234)
- **变体场景与切面**：收录来自工坊 Mod 3649427234 (`Minecraft HUD`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)```

### 变体演进：keep_hud_ui (Mod 2056032273)
- **变体场景与切面**：收录来自工坊 Mod 2056032273 (`keep_hud_ui`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:colourcube
AddComponentPostInit("colourcube", function(self, inst)
    if GetModConfigData("autumn_cc_only") and not inst:HasTag("cave") then
        inst:PushEvent("overridecolourcube", "images/colour_cubes/day05_cc.tex")
    end

    for _, fn in ipairs(TheWorld.event_listeners["playeractivated"][TheWorld]) do
        local OnSanityDelta = UpvalueUtil.GetUpvalue(fn, "OnSanityDelta")
        if OnSanityDelta then
            UpvalueUtil.SetUpvalue(fn, "OnSanityDelta", function(player, data)
                local easing = require("easing")
                PostProcessor:SetColourCubeLerp(1, 0)
                PostProcessor:SetDistortionFactor(1)
                UpvalueUtil.SetUpvalue(OnSanityDelta, "_fxspeed", easing.outQuad(0, 0, .2, 1))
end)
        end
    end
end)```

### 变体演进：[DST] Nautical HUD (Mod 2226345952)
- **变体场景与切面**：收录来自工坊 Mod 2226345952 (`[DST] Nautical HUD`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)```

### 变体演进：[DST] Archive HUD (Mod 3456159081)
- **变体场景与切面**：收录来自工坊 Mod 3456159081 (`[DST] Archive HUD`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)```

### 变体演进：[DST] Mystery HUD (Mod 3548608555)
- **变体场景与切面**：收录来自工坊 Mod 3548608555 (`[DST] Mystery HUD`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)```

### 变体演进：Soul Infused HUD (Mod 2954087809)
- **变体场景与切面**：收录来自工坊 Mod 2954087809 (`Soul Infused HUD`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)```

### 变体演进：Redux UI (Mod 3454549303)
- **变体场景与切面**：收录来自工坊 Mod 3454549303 (`Redux UI`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:sewing_mannequin
AddPrefabPostInit("sewing_mannequin", function(inst)
    inst._voidclothhattask = inst:DoPeriodicTask(GLOBAL.FRAMES, checkEntityTask, 0, inst)
end)
-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:voidclothhat_fx
AddPrefabPostInit("voidclothhat_fx", function(inst)
    local has_face_symbol = nil

    inst:DoTaskInTime(0, function()
        local parent = inst.entity:GetParent() or nil

        if inst.fx ~= nil and parent then
            for k, v in pairs(inst.fx) do
                if v.AnimState and parent ~= nil then
                    local voidclothbuild = parent.prefab .. "_voidclothhat"
                    v.AnimState:SetBuild(voidclothbuild)
                    local hasvoidbuild = v.AnimState:GetBuild() == parent.prefab .. "_voidclothhat"

                    if hasvoidbuild then
                        v.AnimState:SetBuild("hat_voidcloth_new")
                        v.AnimState:OverrideSkinSymbol("fx_fabric", "hat_voidcloth", "fx_fabric")
                    else
                        v.AnimState:SetBuild("hat_voidcloth")
                    end
                end
            end
        end
end)
-- ----------------------------------------------------------------------------
end)```

### 变体演进：[Forge] The Battle Arena HUD (Mod 1824509831)
- **变体场景与切面**：收录来自工坊 Mod 1824509831 (`[Forge] The Battle Arena HUD`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1824509831)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)

```

