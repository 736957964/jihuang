# 15 - UI 系统

> **源码位置**: `scripts/widgets/` (~180个文件)、`scripts/screens/` (~65个文件)  
> **核心基类**: `scripts/widgets/widget.lua` — Widget 基类  
> **屏幕基类**: `scripts/widgets/screen.lua` — Screen 基类

## 1. UI 系统概述

DST 的 UI 系统分为两层：
- **Widget**：可复用的 UI 控件（按钮、文本框、列表等）
- **Screen**：完整的游戏界面（主菜单、背包、地图等）

所有 UI 元素都基于 `Widget` 基类，每个 Widget 内部持有一个 Entity 实例。

---

## 2. Widget 基类

### 2.1 类定义 (`widget.lua`)

```lua
Widget = Class(function(self, name)
    name = name or "widget"
    self.children = {}       -- 子控件列表
    self.callbacks = {}      -- 回调函数
    self.name = name         -- 控件名
    self.inst = CreateEntity() -- 内部 Entity

    -- 暂停时继续更新
    self.inst.DoSimPeriodicTask = self.inst.DoPeriodicTask
    self.inst.DoSimTaskInTime = self.inst.DoTaskInTime
    self.inst.widget = self

    self.inst:AddTag("widget")
    self.inst:AddTag("UI")
    self.inst.entity:AddUITransform()
    self.inst:AddComponent("uianim")

    self:UpdateWhilePaused(true)

    self.enabled = true       -- 是否启用
    self.shown = true         -- 是否显示
    self.focus = false        -- 是否获得焦点
    self.focus_target = false
    self.can_fade_alpha = true
    self.focus_flow = {}      -- 焦点流方向
end)
```

### 2.2 核心方法

```lua
-- 生命周期
Widget:UpdateWhilePaused(boolean)  -- 设置暂停时是否更新
Widget:IsDeepestFocus() -> boolean -- 是否是最深焦点控件

-- 焦点系统
Widget:OnFocusMove(dir, down)      -- 焦点移动处理
Widget:OnMouseButton(button, down, x, y) -- 鼠标事件
Widget:SetFocus()                   -- 设置焦点
Widget:ClearFocus()                 -- 清除焦点

-- 显示控制
Widget:Show()                       -- 显示
Widget:Hide()                       -- 隐藏
Widget:IsVisible() -> boolean       -- 是否可见
Widget:Enable()                     -- 启用
Widget:Disable()                    -- 禁用

-- 层级控制
Widget:MoveToBack()                 -- 移到最底层
Widget:MoveToFront()                -- 移到最顶层

-- 子控件
Widget:AddChild(child)              -- 添加子控件
Widget:RemoveChild(child)           -- 移除子控件
Widget:GetChild(name) -> Widget     -- 获取子控件
Widget:Kill()                       -- 销毁控件
```

### 2.3 UIAnim 组件

每个 Widget 都有一个 `uianim` 组件用于动画控制：

```lua
inst.components.uianim:PlayAnimation(anim, loop)
inst.components.uianim:PushAnimation(anim, loop)
inst.components.uianim:SetBank(bank)
inst.components.uianim:SetBuild(build)
inst.components.uianim:UpdateWhilePaused(boolean)
```

---

## 3. Screen 基类

### 3.1 类定义 (`screens/screen.lua`)

```lua
Screen = Class(function(self, name)
    self.name = name
    self.root = nil  -- 根 Widget
end)

-- 生命周期方法
Screen:OnBecomeActive()     -- 屏幕激活时
Screen:OnBecomeInactive()   -- 屏幕失活时
Screen:OnUpdate(dt)         -- 每帧更新
Screen:OnDestroy()          -- 销毁时
Screen:DoInit()             -- 初始化
```

### 3.2 屏幕管理

```lua
-- 屏幕切换
TheFrontEnd:PushScreen(screen_instance)
TheFrontEnd:PopScreen()
TheFrontEnd:GetActiveScreen() -> Screen
TheFrontEnd:FadeToScreen(screen, time)

-- 常用屏幕
-- "hud"            - 游戏 HUD
-- "map"            - 地图
-- "playerinventory" - 玩家背包
-- "pausemenu"      - 暂停菜单
-- "serverlistingscreen" - 服务器列表
```

---

## 4. 常用 Widget 控件

### 4.1 基础控件

| Widget | 文件 | 描述 |
|--------|------|------|
| `Text` | `widgets/text.lua` | 文本显示 |
| `Image` | `widgets/image.lua` | 图片显示 |
| `ImageButton` | `widgets/imagebutton.lua` | 图片按钮 |
| `TextButton` | `widgets/textbutton.lua` | 文本按钮 |
| `UIAnim` | `widgets/uianim.lua` | 动画控件 |
| `UIAnimButton` | `widgets/uianimbutton.lua` | 动画按钮 |

### 4.2 输入控件

| Widget | 文件 | 描述 |
|--------|------|------|
| `TextEdit` | `widgets/textedit.lua` | 文本输入框 |
| `TextEditLinked` | `widgets/texteditlinked.lua` | 链接式文本编辑 |
| `Spinner` | `widgets/spinner.lua` | 数值选择器 |
| `Slider` | `widgets/slider.lua` | 滑动条 |

### 4.3 容器控件

| Widget | 文件 | 描述 |
|--------|------|------|
| `ScrollArea` | `widgets/scrollarea.lua` | 滚动区域 |
| `TrueScrollArea` | `widgets/truescrollarea.lua` | 真实滚动区域 |
| `TrueScrollList` | `widgets/truescrolllist.lua` | 真实滚动列表 |
| `ScrollableList` | `widgets/scrollablelist.lua` | 可滚动列表 |
| `TabGroup` | `widgets/tabgroup.lua` | 标签页组 |
| `Tab` | `widgets/tab.lua` | 单个标签页 |
| `Grid` | `widgets/grid.lua` | 网格布局 |
| `Panel` | `widgets/panel.lua` | 面板 |

### 4.4 HUD 控件

| Widget | 文件 | 描述 |
|--------|------|------|
| `StatusDisplays` | `widgets/statusdisplays.lua` | 状态显示（三维） |
| `SanityBadge` | `widgets/sanitybadge.lua` | 精神值徽章 |
| `HealthBadge` | `widgets/healthbadge.lua` | 生命值徽章 |
| `HungerBadge` | `widgets/hungerbadge.lua` | 饥饿值徽章 |
| `Controls` | `widgets/controls.lua` | 控制面板 |
| `CraftingMenu` | `widgets/redux/craftingmenu_hud.lua` | 制造菜单 |
| `MapWidget` | `widgets/mapwidget.lua` | 地图控件 |
| `SpeechBubble` | `widgets/speechbubble.lua` | 对话气泡 |
| `TeamStatusBars` | `widgets/teamstatusbars.lua` | 队伍状态栏 |
| `ResurrectButton` | `widgets/resurrectbutton.lua` | 复活按钮 |
| `VoteDialog` | `widgets/votedialog.lua` | 投票对话框 |

### 4.5 特色控件

| Widget | 文件 | 描述 |
|--------|------|------|
| `Wheel` | `widgets/wheel.lua` | 轮盘菜单 |
| `SkillTreeWidget` | `widgets/redux/skilltreewidget.lua` | 技能树 |
| `ScrapbookWidget` | `widgets/scrapbookwidget.lua` | 生物图鉴 |
| `CookbookWidget` | `widgets/redux/cookbookwidget.lua` | 烹饪书 |
| `SkinCollector` | `widgets/skincollector.lua` | 皮肤收集 |
| `WardrobeWidget` | `widgets/wardrobewidget.lua` | 衣橱 |
| `LoadoutSelect` | `widgets/redux/loadoutselect.lua` | 装备选择 |
| `SnapshotTab` | `widgets/snapshottab.lua` | 快照标签 |

---

## 5. 常用 Screen 界面

### 5.1 游戏界面

| Screen | 文件 | 描述 |
|--------|------|------|
| `PlayerHud` | `screens/playerhud.lua` | 游戏 HUD |
| `MapScreen` | `screens/mapscreen.lua` | 地图界面 |
| `PlayerInventoryScreen` | `screens/playerinventoryscreen.lua` | 背包界面 |

### 5.2 菜单界面

| Screen | 文件 | 描述 |
|--------|------|------|
| `MainScreen` | `screens/mainscreen.lua` | 主菜单 |
| `ServerListingScreen` | `screens/redux/serverlistingscreen.lua` | 服务器列表 |
| `ServerCreationScreen` | `screens/redux/servercreationscreen.lua` | 创建服务器 |
| `PauseScreen` | `screens/pausescreen.lua` | 暂停菜单 |
| `LobbyScreen` | `screens/redux/lobbyscreen.lua` | 大厅 |
| `PlayerInfoPopupScreen` | `screens/playerinfopopupscreen.lua` | 玩家信息 |
| `ModsScreen` | `screens/modsscreen.lua` | Mod 管理 |
| `WorldGenScreen` | `screens/worldgenscreen.lua` | 世界生成设置 |
| `CustomizationModalScreen` | `screens/redux/viewcustomizationmodalscreen.lua` | 自定义外观 |

---

## 6. UI 坐标系统

### 6.1 UITransform

```lua
local transform = widget.inst.UITransform

-- 位置
transform:SetPosition(x, y, z)      -- 设置位置
transform:GetPosition()              -- 获取位置

-- 缩放
transform:SetScale(x, y, z)         -- 设置缩放

-- 锚点
transform:SetAnchor(anchor)         -- 设置锚点
-- ANCHOR_MIDDLE = 0  (默认)
-- ANCHOR_LEFT = 1
-- ANCHOR_RIGHT = 2
-- ANCHOR_TOP = 1
-- ANCHOR_BOTTOM = 2

-- 父级控制
transform:SetParent(parent_transform) -- 设置父级变换

-- 层级
transform:MoveToBack()               -- 移到最底层
transform:MoveToFront()              -- 移到最顶层
```

### 6.2 缩放模式

```lua
-- 缩放模式常量
SCALEMODE_NONE = 0              -- 不缩放
SCALEMODE_FILLSCREEN = 1        -- 拉伸填充
SCALEMODE_PROPORTIONAL = 2      -- 等比缩放
SCALEMODE_FIXEDPROPORTIONAL = 3 -- 固定等比
SCALEMODE_FIXEDSCREEN_NONDYNAMIC = 4 -- 固定非动态
```

---

## 7. UI 文本系统

### 7.1 文本控件 (`text.lua`)

```lua
local text = screen.root:AddChild(Text("my_text"))
text:SetString("Hello World")
text:SetFont(FONT.BODYTEXT)
text:SetSize(24)
text:SetColour(1, 1, 1, 1)     -- RGBA
text:SetHAlign(ANCHOR_LEFT)     -- 水平对齐
text:SetVAlign(ANCHOR_MIDDLE)   -- 垂直对齐
text:SetRegionSize(w, h)        -- 区域大小
text:EnableWordWrap(true)       -- 自动换行
text:SetTruncate(true)          -- 截断
```

### 7.2 字体类型

```lua
FONT = {
    TITLE = "title",
    BODYTEXT = "bodytext",
    BUTTON = "button",
    CODE = "code",
    TALKING = "talking",
}
```

---

## 8. UI 事件系统

### 8.1 鼠标事件

```lua
widget:OnMouseButton(button, down, x, y)

-- 按钮常量
MOUSEBUTTON_LEFT = 1000
MOUSEBUTTON_RIGHT = 1001
MOUSEBUTTON_MIDDLE = 1002
MOUSEBUTTON_SCROLLUP = 1003
MOUSEBUTTON_SCROLLDOWN = 1004
```

### 8.2 焦点事件

```lua
-- 键盘/手柄焦点导航
widget:OnFocusMove(dir, down)
-- dir: MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT

-- 设置焦点流
widget.focus_flow[MOVE_DOWN] = next_widget
widget.focus_flow_args[MOVE_DOWN] = {}
```

### 8.3 文本输入

```lua
-- TextEdit 控件
textedit:OnTextInput(char)
textedit:OnTextInputComplete()
textedit:SetString(text)
textedit:GetString() -> string
```

---

## 9. 图像控件

### 9.1 Image 控件

```lua
local image = screen.root:AddChild(Image("my_image"))
image:SetTexture("images/xxx.xml", "xxx.tex")  -- atlas, texture
image:SetSize(w, h)
image:SetTint(r, g, b, a)                       -- 着色
image:SetUVScale(u, v)                           -- UV 缩放
```

### 9.2 ImageButton 控件

```lua
local btn = screen.root:AddChild(ImageButton("my_btn"))
btn:SetTextures(normal, hover, disabled, focus)
btn:SetOnClick(function() print("clicked!") end)
btn:SetOnGainFocus(function() ... end)
btn:SetOnLoseFocus(function() ... end)
btn:SetTooltip("提示文本")
```

---

## 10. Mod 开发 — 自定义 UI

### 10.1 添加 HUD 控件

```lua
-- modmain.lua
AddClassPostConstruct("screens/playerhud", function(hud)
    -- 创建自定义控件
    local my_widget = hud.root:AddChild(Text("my_widget"))
    my_widget:SetString("Hello!")
    my_widget:SetPosition(100, 100, 0)
    my_widget:SetSize(24)
end)
```

### 10.2 自定义屏幕

```lua
-- scripts/screens/myscreen.lua
local MyScreen = Class(Screen, function(self)
    Screen._ctor(self, "MyScreen")
    self.root = self:AddChild(Widget("root"))
end)

function MyScreen:DoInit()
    -- 添加控件
    local title = self.root:AddChild(Text("title"))
    title:SetString("我的屏幕")
    title:SetPosition(0, 100, 0)

    local close_btn = self.root:AddChild(TextButton("close"))
    close_btn:SetText("关闭")
    close_btn:SetPosition(0, -100, 0)
    close_btn:SetOnClick(function()
        TheFrontEnd:PopScreen()
    end)
end

return MyScreen
```

### 10.3 打开自定义屏幕

```lua
-- modmain.lua
local MyScreen = require("screens/myscreen")
TheFrontEnd:PushScreen(MyScreen())
```
