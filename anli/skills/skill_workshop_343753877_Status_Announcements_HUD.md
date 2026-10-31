# 饥荒一线工坊深度研读 Skill：HUD 鼠标键盘事件拦截与聊天广播重定向技术

- **工坊 ID**：343753877 (`Status Announcements`)
- **领域分类**：HUD 类 UI 控件控制拦截（`SlotClass:OnControl`）、组合键状态判定、聊天栏历史过滤（`ChatHistory`）、多语言递归合并（Deep Merge）
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“一键通告、社交增强、配方广播、快捷聊天”类 Mod 时：
1. **UI 控件控制拦截（Widget OnControl Override）**：通过覆写 `invslot`、`equipslot` 及 `PlayerHud` 的 `OnControl` 方法，捕获鼠标左键/右键与修饰键（如 `Ctrl`、`Shift`）的组合事件；
2. **底层聊天记录清洗（ChatHistory Hook）**：通过切面拦截 `ChatHistory:AddToHistory`，实现状态通告的定制化展示或静默过滤；
3. **多语言字典热融合**：启动时扫描环境并加载对应语言包，与全局 `STRINGS` 进行递归合并。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：物品栏格子组合键点击广播通告核心切面 (modmain.lua)
-- ==============================================================================

local function AnnounceInventoryItem(slot_widget)
    if not slot_widget or not slot_widget.tile then return false end
    
    local item = slot_widget.tile.item
    if not item or not item:IsValid() then return false end

    local item_name = item.name or "神秘物品"
    local announcement_text = string.string or string.format("我发现了物品：%s！", item_name)

    -- 向聊天频道发送通告（调用官方 Networking_Say）
    if GLOBAL.TheNet and GLOBAL.TheNet.Talker then
        -- 实际开发中可封装为标准聊天广播
        GLOBAL.TheNet:Say(announcement_text)
    end

    return true -- 拦截事件，防止触发原生拾取或使用动作
end

-- 针对装备槽与物品槽注入点击拦截
for _, classname in ipairs({ "invslot", "equipslot" }) do
    local SlotClass = GLOBAL.require("widgets/" .. classname)
    if SlotClass and SlotClass.OnControl then
        local old_OnControl = SlotClass.OnControl
        SlotClass.OnControl = function(self, control, down, ...)
            -- 判断：当按下左键 且 按住强制检查组合键（如 Ctrl）
            if down and control == GLOBAL.CONTROL_ACCEPT 
               and GLOBAL.TheInput:IsControlPressed(GLOBAL.CONTROL_FORCE_INSPECT) then
                if AnnounceInventoryItem(self) then
                    return true -- 成功拦截
                end
            end
            return old_OnControl(self, control, down, ...)
        end
    end
end
```

---

## 三、避坑与生产安全准则

1. **组合键防误触保护**：
   - 绝不能仅仅通过 `CONTROL_ACCEPT`（鼠标左键点击）就触发广播，必须结合 `CONTROL_FORCE_INSPECT`（Ctrl键）或专属修饰键，否则玩家在整理背包、搬运物品时会不断误触发通告，导致严重的游玩体验干扰。
2. **客户端与服务端通信权限**：
   - 客户端通告文本必须通过官方安全的 RPC 通道或 `TheNet:Say` 发送，不能在客户端直接修改其他玩家的视图状态。
