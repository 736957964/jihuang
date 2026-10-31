# 饥荒一线工坊深度研读 Skill：网络装备槽位扩展与背包溢出预测注入规范

- **工坊 ID**：375850593 (`Extra Equip Slots`)
- **领域分类**：网络槽位协议扩展（EQUIPSLOTS）、`inventory_classified` 客户端预测穿透、溢出容器（Overflow）网络事件绑定
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在饥荒联机版中为角色新增独立装备插槽（如专属饰品槽、背部挂件、副手武器槽），不能仅仅修改 UI，必须完成全套数据与网络管线贯通：
1. **网络 ID 重新编址**：更新 `EQUIPSLOT_IDS`，使引擎网络层支持双端识别；
2. **`setoverflow` 事件分发**：保证带容器属性的装备穿上时能够弹出侧边栏；
3. **`inventory_classified` 穿透**：修改客机物品持有检测（`Has`），使制作系统支持跨槽位材料消耗。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：全局装备槽位增量安全注册器 (scripts/tools/equipslot_registry.lua)
-- ==============================================================================

local EquipSlotRegistry = {}

function EquipSlotRegistry.RegisterSlot(slot_key, slot_name)
    slot_key = string.upper(slot_key)
    slot_name = string.lower(slot_name)

    -- 1. 增量写入全局 EQUIPSLOTS
    GLOBAL.EQUIPSLOTS[slot_key] = slot_name

    -- 2. 重建自增连续 ID 映射 (C++ 序列化依赖)
    GLOBAL.EQUIPSLOT_IDS = {}
    local id = 0
    for k, v in pairs(GLOBAL.EQUIPSLOTS) do
        id = id + 1
        GLOBAL.EQUIPSLOT_IDS[v] = id
    end
end

-- ==============================================================================
-- 范式 2：背包容器穿戴事件与客户端合成穿透切面
-- ==============================================================================

-- 1. 服务端库存组件拦截：绑定背部容器的 setoverflow 事件
AddComponentPostInit("inventory", function(self, inst)
    local old_Equip = self.Equip
    self.Equip = function(inv, item, old_to_active)
        local ret = old_Equip(inv, item, old_to_active)
        if ret and item and item.components and item.components.equippable then
            local eslot = item.components.equippable.equipslot
            -- 当穿戴在自定义背部槽位且具备容器组件时，向客机广播展开侧边背包栏
            if eslot == GLOBAL.EQUIPSLOTS.BACK and item.components.container then
                inv.inst:PushEvent("setoverflow", { overflow = item })
            end
        end
        return ret
    end

    -- 覆盖官方获取溢出容器的接口
    self.GetOverflowContainer = function(inv)
        if inv.ignoreoverflow then return nil end
        local item = inv:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
        return item and item.components and item.components.container or nil
    end
end)

-- 2. 客户端网络分类实体切面：合成制作材料穿透
AddPrefabPostInit("inventory_classified", function(inst)
    local old_GetOverflowContainer = inst.GetOverflowContainer
    inst.GetOverflowContainer = function(classified)
        local item = classified.GetEquippedItem(classified, GLOBAL.EQUIPSLOTS.BACK)
        return item and item.replica and item.replica.container or nil
    end
end)

return EquipSlotRegistry
```

---

## 三、避坑与生产安全准则

1. **`setoverflow` 事件必须携带 `{ overflow = item }` 载荷**：
   - 官方底层客户端 UI 监听 `setoverflow` 事件时，会从 `data.overflow` 中直接解包容器对象并挂载到物品栏左侧。如果只发空事件，客户端不仅无法弹出背包格子，还会报错 `attempt to index field 'overflow' (a nil value)`。
2. **`EQUIPSLOT_IDS` 必须保证为紧凑正整数**：
   - 引擎在利用 NetVar 序列化玩家穿戴的装备槽时，只读取 `EQUIPSLOT_IDS` 中的数字索引。绝不能在字典中出现负数、小数或跳跃间断的 ID，否则会导致客机在装备时报越界断网。
