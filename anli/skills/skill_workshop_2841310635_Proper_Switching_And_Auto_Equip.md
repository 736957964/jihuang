# 饥荒一线工坊深度研读 Skill：纯客机物品槽位无缝追踪与战斗装备自动续杯技术

- **工坊 ID**：2841310635 (`Proper Switching & Auto Re-Equip`)
- **领域分类**：纯客机状态同步与事件交叉监听、背包虚拟映射表维护、`DoPeriodicTask(0)` 动作模拟驱动、武器破碎/弹弓自动装填
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“客户端增强、一键换装优化、自动补货、战斗武器续杯”类 Mod 时：
1. **格子虚拟映射（Virtual Slot Mapping）**：在纯客户端通过监听 `itemget`/`itemlose`/`equip`/`unequip` 事件，动态建立背包与装备槽的前后对照表；
2. **零延迟模拟交互**：利用 `DoPeriodicTask(0, ...)` 配合格子操作 API（如 `PutAllOfActiveItemInSlot`），在纯客户端模拟控制器操作，实现无缝换装；
3. **破碎与弹药自愈**：通过检测 `!IsValid()`（武器耐久打碎）或 `NOCLICK` 标签（投掷物/弹弓用尽），自动寻找背包同类物品进行续杯。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：纯客机武器自动续杯与模拟穿戴核心切面 (modmain.lua)
-- ==============================================================================

local function TryUseItemOnSelf(item, inventory)
    if inventory and inventory.ControllerUseItemOnSelfFromInvTile then
        -- 临时禁用部署模式，防止客户端动作冲突
        local pc = GLOBAL.ThePlayer and GLOBAL.ThePlayer.components.playercontroller
        local old_dmode = pc and pc.deploy_mode
        if pc then pc.deploy_mode = false end

        inventory:ControllerUseItemOnSelfFromInvTile(item)

        if pc then pc.deploy_mode = old_dmode end
    end
end

-- 扫描背包及容器寻找同 Prefab 备用武器
local function FindBackupItemByPrefab(player, target_prefab)
    local inv = player.replica.inventory
    if not inv then return nil end

    -- 1. 扫描主背包
    local numslots = inv:GetNumSlots()
    for slot = 1, numslots do
        local item = inv:GetItemInSlot(slot)
        if item and item.prefab == target_prefab and item:IsValid() then
            return item
        end
    end

    -- 2. 扫描打开的容器（如背包、切斯特）
    local open_containers = inv:GetOpenContainers()
    if open_containers then
        for container_obj in pairs(open_containers) do
            local container_replica = container_obj and container_obj.replica.container
            if container_replica then
                for slot = 1, container_replica:GetNumSlots() do
                    local item = container_replica:GetItemInSlot(slot)
                    if item and item.prefab == target_prefab and item:IsValid() then
                        return item
                    end
                end
            end
        end
    end
    return nil
end

-- 武器破损自动替换逻辑
local function AutoReEquipBrokenWeapon(player, unequipped_item, equip_slot)
    if not unequipped_item or not equip_slot then return end

    -- 判断是否为耐久耗尽（无效实体）或投掷物用尽
    local is_broken = not unequipped_item:IsValid()
    if not is_broken then return end

    local inv = player.replica.inventory
    if not inv then return end

    -- 确保当前槽位为空
    if inv:GetEquippedItem(equip_slot) ~= nil then return end

    -- 寻找同种备用武器
    local backup_item = FindBackupItemByPrefab(player, unequipped_item.prefab)
    if backup_item then
        TryUseItemOnSelf(backup_item, inv)
    end
end

GLOBAL.AddComponentPostInit("playercontroller", function(self)
    if self.inst ~= GLOBAL.ThePlayer then return end

    self.inst:ListenForEvent("unequip", function(inst, data)
        if type(data) ~= "table" then return end
        local eslot = data.eslot
        -- 这里简化演示手部武器自动续杯
        if eslot == GLOBAL.EQUIPSLOTS.HANDS and data.item then
            -- 延时 1 帧确保状态稳定后触发
            inst:DoTaskInTime(0, function()
                AutoReEquipBrokenWeapon(inst, data.item, eslot)
            end)
        end
    end)
end)
```

---

## 三、避坑与生产安全准则

1. **客户端模拟操作的安全性**：
   - 纯客机 Mod 无法直接调用服务端的 `inventory:Equip(item)`。必须通过调用 `ControllerUseItemOnSelfFromInvTile` 等官方预留的 UI 交互接口向服务器发送标准 RPC 请求，由服务端最终裁决。
2. **防并发与递归保护**：
   - 在进行自动续杯时，必须先检查 `inv:GetEquippedItem(equip_slot) ~= nil`。若当前槽位已经有新装备穿上，切勿再次触发替换，避免陷入无限循环换装的网络风暴。
