# 饥荒一线工坊深度研读 Skill：背包底层拓扑动态扩容与网络实体变量注入技术

- **工坊 ID**：786556008 (`45 Inventory Slots`)
- **领域分类**：`inventory_classified` 网络实体变量扩展（`net_entity`）、`makereadonly` 只读沙盒穿透、双排矩阵布局算法、背包容器事件代理
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“大容量背包、自定义英雄额外栏位、特种装备扩展槽”等系统级 Mod 时：
1. **网络变量增量注入**：在 `inventory_classified` 预制体初始化切面中，按需补充 `net_entity` 列表，打通客机同步通道；
2. **只读保护前置拦截**：在官方执行 `makereadonly(self, "maxslots")` 之前，预先写入目标槽位值；
3. **UI 矩阵分行排版**：使用多 Widget 分层承载，避免单排槽位溢出视窗。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：inventory_classified 网络变量动态注入 (modmain.lua)
-- ==============================================================================

local TARGET_SLOTS = 25 -- 目标扩展槽位数

-- 1. 动态为分类代理注入 net_entity
AddPrefabPostInit("inventory_classified", function(inst)
    if #inst._items < TARGET_SLOTS then
        for i = #inst._items + 1, TARGET_SLOTS do
            local netvar = GLOBAL.net_entity(
                inst.GUID, 
                "inventory._items[" .. tostring(i) .. "]", 
                "items[" .. tostring(i) .. "]dirty"
            )
            table.insert(inst._items, netvar)
        end
    end
end)

-- ==============================================================================
-- 范式 2：官方只读安全沙盒规避与 Replica 同步 (modmain.lua)
-- ==============================================================================

local inventory = GLOBAL.require("components/inventory")
local inventory_replica = GLOBAL.require("components/inventory_replica")

-- 2. 拦截构造函数，赶在 makereadonly 之前改写上限
local old_inventory_ctor = inventory._ctor
inventory._ctor = function(self, inst)
    if old_inventory_ctor then old_inventory_ctor(self, inst) end
    self.maxslots = TARGET_SLOTS
    -- 官方随后会调用 makereadonly(self, "maxslots")，锁定新上限
end

-- 3. 拦截客户端 Replica，让制作栏与合成系统识别扩展槽位
local old_GetNumSlots = inventory_replica.GetNumSlots
function inventory_replica:GetNumSlots()
    return TARGET_SLOTS
end

-- ==============================================================================
-- 范式 3：双排自适应物品栏网格排版算法 (scripts/widgets/dual_row_inv.lua)
-- ==============================================================================

local function LayoutDualRowSlots(root_widget, slot_widgets, slot_size, spacing)
    local total = #slot_widgets
    local per_row = math.ceil(total / 2)
    
    local start_x = -((per_row - 1) * (slot_size + spacing)) / 2
    local row_height = slot_size + spacing

    for i, slot in ipairs(slot_widgets) do
        local is_bottom_row = i > per_row
        local col_index = is_bottom_row and (i - per_row - 1) or (i - 1)
        
        local x = start_x + col_index * (slot_size + spacing)
        local y = is_bottom_row and (-row_height) or 0
        
        slot:SetPosition(x, y, 0)
    end
end

return {
    LayoutDualRowSlots = LayoutDualRowSlots,
}
```

---

## 三、避坑与生产安全准则

1. **`net_entity` 命名格式不可篡改**：
   - 官方网络实体变量标识必须严格遵循 `"inventory._items[N]"` 与 `"items[N]dirty"` 的格式。如果命名存在拼写错误，客户端引擎底层 C++ 事件分发器将无法匹配到对应的网络包，引发严重的客机静默不同步。
2. **严防与多装备栏 Mod 的事件竞争**：
   - 如果玩家同时启用了 `Extra Equip Slots` 等模组，双方都会修改 `inventorybar` 的 `Rebuild`。在重构 UI 时，请务必保留 `self.equip` 与 `self.backpackinv` 的引用和原始位置计算，避免把对方的装备栏槽位给整体 `Kill` 掉。
