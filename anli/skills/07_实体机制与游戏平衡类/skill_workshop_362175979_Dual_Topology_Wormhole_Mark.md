# 饥荒一线工坊深度研读 Skill：实体拓扑对偶配对与 MiniMap 迷雾穿透标记范式

- **工坊 ID**：362175979 (`Wormhole Marks`)
- **领域分类**：实体对偶拓扑配对（Teleporter Pairing）、MiniMapEntity 动态改图、迷雾穿透（SetDrawOverFogOfWar）、世界级单例计数组件
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发传送门、双向地道、配对信标等需要**成对实体共享唯一标识/颜色**的系统时，最核心的逻辑是：
1. 依赖一个世界级单例（`TheWorld`）分发全局唯一递增 Sequence ID；
2. 借由 `teleporter.targetTeleporter` 属性在入口事件中“一次性同步标记两端”；
3. 借助 `MiniMapEntity:SetDrawOverFogOfWar(true)` 打破迷雾阻隔。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：世界级唯一序列分发组件 (scripts/components/network_pairing_counter.lua)
-- ==============================================================================

local NetworkPairingCounter = Class(function(self, inst)
    assert(TheWorld.ismastersim, "PairingCounter must be on MasterSim")
    self.inst = inst
    self.current_id = 1
end)

function NetworkPairingCounter:GetNextId()
    local id = self.current_id
    self.current_id = self.current_id + 1
    return id
end

function NetworkPairingCounter:OnSave()
    return { current_id = self.current_id }
end

function NetworkPairingCounter:OnLoad(data)
    if data and data.current_id then
        self.current_id = data.current_id
    end
end

return NetworkPairingCounter


-- ==============================================================================
-- 范式 2：实体双向对偶原子标记切面 (scripts/components/dual_marker.lua)
-- ==============================================================================

local DualMarker = Class(function(self, inst)
    self.inst = inst
    self.pair_id = nil
    self.is_marked = false
end)

function DualMarker:ApplyMarker(id, draw_over_fog)
    self.pair_id = id
    self.is_marked = true

    -- 动态更新小地图图标
    if self.inst.MiniMapEntity == nil then
        self.inst.entity:AddMiniMapEntity()
    end

    self.inst.MiniMapEntity:SetIcon("mark_" .. tostring(id) .. ".tex")
    if draw_over_fog then
        self.inst.MiniMapEntity:SetDrawOverFogOfWar(true)
    end
end

-- 原子触发器：在单侧激活时，联动对偶远端
function DualMarker:TriggerDualMark(draw_over_fog)
    if self.is_marked then return end

    local counter = TheWorld.components.network_pairing_counter
    if not counter then return end

    local next_id = counter:GetNextId()
    -- 1. 标记自身
    self:ApplyMarker(next_id, draw_over_fog)

    -- 2. 穿透标记对偶出口 (防止跨维度 nil 报错)
    if self.inst.components.teleporter then
        local remote = self.inst.components.teleporter.targetTeleporter
        if remote and remote:IsValid() and remote.components.dual_marker then
            remote.components.dual_marker:ApplyMarker(next_id, draw_over_fog)
        end
    end
end

function DualMarker:OnSave()
    return { pair_id = self.pair_id, is_marked = self.is_marked }
end

function DualMarker:OnLoad(data)
    if data and data.is_marked and data.pair_id then
        self:ApplyMarker(data.pair_id, true)
    end
end

return DualMarker
```

---

## 三、避坑与生产安全准则

1. **`targetTeleporter` 跨 Shard（洞穴/地表直通）防御**：
   - 官方多世界穿梭是通过世界 Migration 实现的，远端实体不在同一个 Lua 虚拟机中，此时 `targetTeleporter` 为 nil。必须始终保证 `if remote and remote:IsValid()`，否则直接解包必定崩服。
2. **`MiniMapEntity` 必须在 Prefab 定义期预载或在 OnLoad 中确保存在**：
   - 某些实体被动态 `AddMiniMapEntity()` 时，必须保证其材质图集已提前通过 `AddMinimapAtlas` 注册在客户端内存中，否则会导致该实体在小地图上渲染为紫黑丢失材质块。
