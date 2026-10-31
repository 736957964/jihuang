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
-- 范式：自适应 HUD 挂载与输入隔离容器 (scripts/widgets/responsive_hud_container.lua)
-- ==============================================================================

local Widget = require "widgets/widget"

local ResponsiveContainer = Class(Widget, function(self, owner)
    Widget._ctor(self, "ResponsiveContainer")
    self.owner = owner
    self.camera_lock = false
end)

-- 1. 矩阵逆缩放贴边算法 (支持九宫格锚定)
function ResponsiveContainer:Reposition(controls, align_x, align_y, margin_x, margin_y)
    local hudscale = controls.top_root:GetScale()
    local screenw_full, screenh_full = GLOBAL.TheSim:GetScreenSize()
    
    -- 反向求出真实逻辑视口坐标
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

-- 2. 鼠标滚轮焦点与摄像机缩放阻断
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

-- 3. 消费滚轮与控制事件，防止穿透到底层世界
function ResponsiveContainer:OnControl(control, down)
    if ResponsiveContainer._base.OnControl(self, control, down) then return true end
    if control == GLOBAL.CONTROL_MAP_ZOOM_IN or control == GLOBAL.CONTROL_MAP_ZOOM_OUT then
        -- 内部消费滚轮缩放事件
        return true
    end
    return false
end

return ResponsiveContainer
```

---

## 三、避坑与生产安全准则

1. **`OnLoseFocus` 必须兜底防漏**：
   - 如果用户在悬停该 UI 的瞬间按下了 ESC 键切出菜单，或者切回桌面，可能会跳过 `OnLoseFocus`。建议在控件的 `Kill` 和 `Hide` 方法中，同样加入对 `TheCamera:SetControllable(true)` 的安全恢复调用，防止玩家摄像机被永久锁死。
2. **`controls.OnUpdate` 增量轻量比较**：
   - 监听窗口分辨率变化时，切忌每帧去调用复杂的布局计算。只在 `w ~= last_w or h ~= last_h` 时才触发一次 `Reposition`。


## 五、进阶拓扑演进与变体分支

### 变体演进：Mod 2880540712 (Mod 2880540712)
- **变体场景与切面**：收录来自工坊 Mod 2880540712 (`Mod 2880540712`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2880540712)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:inventory
AddComponentPostInit("inventory", function(self,inst)
    local original_Equip = self.Equip
    self.Equip = function(self, item, old_to_active, no_animation)
        local eslot = item.components.equippable.equipslot
        if item ~= nil and
            self.equipslots[eslot] ~= nil and
            item.components.inventoryitem.owner ~= nil then --可执行
            if item.components.inventoryitem.owner.components.container ~= nil then --存放在背包/其他容器内
                self.equipslots[eslot].prevcontainer = item.components.inventoryitem.owner.components.container
                if item.components.inventoryitem.owner.components.inventoryitem ~= nil then --背包
                    self.equipslots[eslot].prevslot = item.components.inventoryitem.owner.components.container:GetItemSlot(item)
                else --其他
                    self.equipslots[eslot].prevslot = item.components.inventoryitem.owner.components.container:GetItemSlot(item)
                end
            else --存放在物品栏中
                self.equipslots[eslot].prevcontainer = item.prevcontainer
                self.equipslots[eslot].prevslot = self:GetItemSlot(item)
            end
        end
        return original_Equip(self, item, old_to_active, no_animation)
    end
end)

```



### 变体演进：Quick Pick (Mod 2923790645)
- **变体场景与切面**：收录来自工坊 Mod 2923790645 (`Quick Pick`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2923790645)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:sapling

AddPrefabPostInit("sapling", pick)
AddPrefabPostInit("marsh_bush", pick)
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:marsh_bush
AddPrefabPostInit("sapling", pick)
AddPrefabPostInit("marsh_bush", pick)
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:reeds
AddPrefabPostInit("marsh_bush", pick)
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:grass
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:berrybush2
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush_snake", pick)
AddPrefabPostInit("berrybush2_snake", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)
AddPrefabPostInit("seaweed_planted", pick)
AddPrefabPostInit("limpetrock", pick)
AddPrefabPostInit("grass_water", pick)

```

