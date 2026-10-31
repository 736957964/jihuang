# 饥荒一线工坊深度研读 Skill：按需 RPC 属性查询与 ItemTile 悬停响应机制

- **工坊 ID**：458940297 (`Food Values - Item Tooltips`)
- **领域分类**：按需查询（On-Demand ModRPC）、`ItemTile` 悬浮监听与动态回填、防重监听泄漏守卫、潮湿调色板自适应
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发需要展示服务端权威数据（如料理营养、法宝剩余耐久、封印解开时间）的背包插件时，无差别全图同步会导致网络泛滥。标准解法是**按需轻量 RPC 交互**：
1. 客户端在 `ItemTile` 鼠标划入（`OnGainFocus`）时发送一次轻量 RPC 请求；
2. 服务端实时抓取权威组件数据，格式化后单播回传给请求玩家；
3. 客户端刷新 `SetTooltip` 并动态对齐 `WET_TEXT_COLOUR` 调色板。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：客户端 ItemTile 悬停响应与防重监听守卫 (scripts/widgets/itemtile_decorator.lua)
-- ==============================================================================

local function DecorateItemTile(ItemTileClass)
    local old_UpdateTooltip = ItemTileClass.UpdateTooltip

    ItemTileClass.UpdateTooltip = function(self)
        if old_UpdateTooltip then old_UpdateTooltip(self) end

        local item = self.item
        if not item or not item:IsValid() or not GLOBAL.ThePlayer then return end

        -- 1. 单例守卫：确保每个 ItemTile 仅绑定一次回传监听，杜绝内存泄漏
        if not self._has_rpc_listener then
            self._has_rpc_listener = true
            self.inst:ListenForEvent("custom_item_info_ready", function(inst, data)
                if self.focus and data and data.text then
                    -- 拼接并更新提示
                    local base_str = self:GetDescriptionString()
                    self:SetTooltip(base_str .. "\n" .. data.text)

                    -- 潮湿状态颜色自适应
                    if self.item and self.item:IsValid() and self.item:GetIsWet() then
                        self:SetTooltipColour(GLOBAL.unpack(GLOBAL.WET_TEXT_COLOUR))
                    else
                        self:SetTooltipColour(GLOBAL.unpack(GLOBAL.NORMAL_TEXT_COLOUR))
                    end
                end
            end, GLOBAL.ThePlayer)
        end

        -- 2. 按需向服务端发起查询 (带实体句柄)
        SendModRPCToServer(GLOBAL.MOD_RPC["ItemInfoMod"]["QueryDetails"], item)
    end
end

-- ==============================================================================
-- 范式 2：服务端数据提取与单播回传 (modmain.lua)
-- ==============================================================================

if GLOBAL.TheNet:GetIsServer() then
    AddModRPCHandler("ItemInfoMod", "QueryDetails", function(player, item)
        -- 核心防御：校验实体有效性与玩家距离
        if not player or not player:IsValid() or not item or not item:IsValid() then return end

        local detail_str = ""

        -- 动态嗅探食物三维
        if item.components.edible then
            local e = item.components.edible
            detail_str = string.format("Hunger: %+d | Health: %+d | Sanity: %+d", 
                math.floor(e.hungervalue or 0), 
                math.floor(e.healthvalue or 0), 
                math.floor(e.sanityvalue or 0)
            )
        end

        -- 动态嗅探武器攻击力
        if item.components.weapon then
            local w = item.components.weapon
            detail_str = detail_str .. string.format("\nDamage: %d", math.floor(w.damage or 0))
        end

        -- 单播回传给该玩家 (通过客户端专属 RPC 或客户端事件)
        SendModRPCToClient(GLOBAL.CLIENT_MOD_RPC["ItemInfoMod"]["ReceiveDetails"], player.userid, detail_str)
    end)
end

return {
    DecorateItemTile = DecorateItemTile,
}
```

---

## 三、避坑与生产安全准则

1. **绝对禁止在 `UpdateTooltip` 内无条件挂载匿名监听器**：
   - 鼠标每在物品上晃动一次就会触发一次 `UpdateTooltip`。如果写 `ThePlayer:ListenForEvent(...)` 而不设置 `_has_rpc_listener` 标志位，两分钟内就会挂接上万个闭包，造成严重的客户端掉帧卡顿。
2. **`SendModRPCToClient` 必须携带目标过滤**：
   - 服务端计算完某个物品的属性后，只应回传给发起请求的这名玩家（通过 `SendModRPCToClient` 指向特定 `player.userid`），切忌全服无差别广播，防止污染全服其他玩家当前的鼠标悬浮窗口。
