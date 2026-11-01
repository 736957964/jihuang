# 饥荒一线工坊深度研读 Skill：客机响应式 HUD 悬浮面板与 RPC 事务双向流

- **来源工程**：`蜘蛛纸牌 (spider_solitaire / 2680121051)`、`Sora 模组框架` 与 `smallAn.md 工业案例`
- **核心逻辑对应**：`scripts/widgets/screen.lua`、`scripts/widgets/controls.lua` Hook、`modmain.lua` 双端 RPC
- **领域分类**：现代 UI 控件系统、客机输入防穿透、ModRPC 网络协议与安全审计

---

## 一、核心实现原理与架构全貌

饥荒联机版的 UI 体系完全运行在客户端（Client），而游戏权威状态在服务端（Master Sim）。制作诸如拍卖行、快捷施法轮盘、纸牌小游戏等现代悬浮 UI 时，必须跨越三大技术鸿沟：

### 1. 客户端 UI 根节点的正确挂载点
- **痛点**：若直接在 `ThePlayer.HUD` 或当前根屏幕上通过 `AddChild` 添加控件，在玩家打开全屏地图（MapScreen）、制作配方列表（CraftingPopup）或暂停菜单（PauseScreen）时，会导致 UI 显示错乱、层级遮挡错误，甚至在分屏/窗口大小改变时坐标偏移。
- **解法**：在 `AddClassPostConstruct("widgets/controls", function(self) ... end)` 期间，必须挂载在 `self.top_root`。
  - `self.top_root` 会自动跟随游戏窗口比例进行矩阵缩放（`UpdatePosition`）；
  - 当游戏弹出模态对话框时，`top_root` 能够正确接收焦点分发。

### 2. 客户端向服务端发起 RPC（Client-to-Server RPC）
- 使用 `AddModRPCHandler("NAMESPACE", "RPC_NAME", function(player, arg1, ...) end)` 注册服务端回调。
- 客户端使用 `SendModRPCToServer(MOD_RPC["NAMESPACE"]["RPC_NAME"], arg1, ...)` 进行上报。
- **核心安全审计准则**：
  - 永远不要信任客户端传过来的任何状态！在服务端回调第一行必须校验：
    1. 实体有效性：`if not (player and player:IsValid()) then return end`
    2. 死亡/幽灵态校验：`if player:HasTag("playerghost") then return end`
    3. 距离与条件校验：如果操作涉及特定建筑或背包，必须计算与目标的距离平方（`player:GetDistanceSqToInst(target) < 64`）。

### 3. 客机幽灵态输入穿透与焦点捕获
- 玩家死亡变为幽灵（Ghost）后，屏幕并未销毁，如果不做事件隔离，玩家依然能够点击 UI 发送技能 RPC。因此在 UI 的 `SetOnClick` 中必须加入客户端本地前置断言：
  ```lua
  if ThePlayer == nil or ThePlayer:HasTag("playerghost") then
      return
  end
  ```

---

## 二、标准化生产级代码范式 (可直接复用)

```lua
-- ==============================================================================
-- 范式 1：modmain.lua 双端 RPC 注册与 controls 注入
-- ==============================================================================

GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- 1. 服务端 RPC 处理器 (带严格安全防御)
AddModRPCHandler("WHALE_UI", "ACTIVATE_FEATURE", function(player, feature_id, param)
    if not (player and player:IsValid()) then return end
    
    -- 防御 1：幽灵状态禁止操作
    if player:HasTag("playerghost") then return end
    
    -- 防御 2：业务状态与资源消耗断言
    if player.components.sanity and player.components.sanity.current >= 15 then
        player.components.sanity:DoDelta(-15)
        
        -- 执行核心业务
        if feature_id == 1 then
            if player.components.talker then
                player.components.talker:Say("法术已激活！")
            end
        end
    end
end)

-- 2. 客户端 controls 注入
AddClassPostConstruct("widgets/controls", function(self)
    local CustomHoverPanel = require("widgets/custom_hover_panel")
    self.whale_hover_panel = self.top_root:AddChild(CustomHoverPanel(self.owner))
    self.whale_hover_panel:SetPosition(-120, 80, 0)
end)


-- ==============================================================================
-- 范式 2：标准自定义悬浮控件 (scripts/widgets/custom_hover_panel.lua)
-- ==============================================================================

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"

local CustomHoverPanel = Class(Widget, function(self, owner)
    Widget._ctor(self, "CustomHoverPanel")
    self.owner = owner

    -- 根底图
    self.bg = self:AddChild(Image("images/global.xml", "square.tex"))
    self.bg:SetSize(180, 90)
    self.bg:SetTint(0.1, 0.1, 0.1, 0.8)

    -- 提示标签
    self.label = self:AddChild(Text(BODYTEXTFONT, 18, "快捷功能面板", { 1, 1, 1, 1 }))
    self.label:SetPosition(0, 25, 0)

    -- 交互按钮
    self.action_btn = self:AddChild(ImageButton())
    self.action_btn:SetPosition(0, -15, 0)
    self.action_btn:SetText("施法 (消耗15San)")
    self.action_btn:SetOnClick(function()
        -- 客户端前置拦截
        if self.owner == nil or self.owner:HasTag("playerghost") then
            return
        end
        
        -- 发送网络报文
        SendModRPCToServer(MOD_RPC["WHALE_UI"]["ACTIVATE_FEATURE"], 1, "custom_data")
    end)
end)

return CustomHoverPanel
```

---

## 三、踩坑与避错实战指南

1. **`top_root` 与 HUD 重建引发的内存泄漏**：
   - 当玩家更替角色（如 Despawn 重新选人）或洞穴/地表穿梭时，`widgets/controls` 会被销毁并重建。在自定义面板内部，如果监听了 `TheWorld` 或全局事件（`inst:ListenForEvent`），必须在控件的 `Kill` 函数中解绑，否则旧面板实体将永远常驻内存引发客户端闪退。
2. **多分辨率自适应（Anchor 锚定规范）**：
   - 悬浮在右上角的面板，切忌使用绝对屏幕坐标（如 `x = 1800`）。必须结合 `self:SetHAnchor(ANCHOR_RIGHT)` 与 `self:SetVAnchor(ANCHOR_TOP)` 进行动态相对锚定，确保在 1080P、2K 及超宽带鱼屏下始终精准吸附在屏幕边缘。
