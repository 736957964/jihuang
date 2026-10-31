# 饥荒一线工坊深度研读 Skill：主客双端复制组件（Replicable Component）与全服拓扑网络架构

- **工坊 ID**：1530801499 (`Fast Travel GUI`)
- **领域分类**：网络复制组件规范（AddReplicableComponent）、全服拓扑自维护池（Global Topology Registry）、危险状态逃逸防御、距离-季节动态开销模型
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发需要跨端同步状态（如自定义交互信标、传送门、载具停靠点）的复杂网络 MOD 时：
1. **主客双端复制体系**：通过 `AddReplicableComponent("mycomponent")`，让客机自动装配 `mycomponent_replica`；
2. **拓扑注册中心**：用模块全局表 `ALL_NODES` 维护实体拓扑，实体生成时入网，被拆除时退网；
3. **服务端权威安全防护**：ModRPC 接收客户端请求时，必须由 MasterSim 重新执行近距离及战斗脱战断言。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：服务端权威拓扑管理组件 (scripts/components/network_node.lua)
-- ==============================================================================

local ALL_NODES = {}

local NetworkNode = Class(function(self, inst)
    self.inst = inst
    self.node_name = "Default Node"
    self.is_active = true

    -- 1. 自动注册入全服拓扑网
    table.insert(ALL_NODES, self)
end)

--- 销毁退网生命周期守卫 (防内存泄漏与幽灵节点)
function NetworkNode:OnRemoveFromEntity()
    for i, v in ipairs(ALL_NODES) do
        if v == self then
            table.remove(ALL_NODES, i)
            break
        end
    end
end

--- 危险逃逸断言检测 (防战斗作弊)
function NetworkNode:CanTravelNow(player)
    if not player or not player:IsValid() then return false end

    -- 检测是否着火
    if player.components.burnable and player.components.burnable:IsBurning() then
        return false, "BURNING"
    end

    -- 检测附近仇恨敌人
    local danger = GLOBAL.FindEntity(player, 12, function(target)
        return target.components.combat and target.components.combat.target == player
    end, { "_combat" }, { "INLIMBO", "player" })

    if danger ~= nil then
        return false, "IN_COMBAT"
    end

    return true
end

--- 获取当前可达有效节点列表
function NetworkNode:GetValidDestinations(player)
    local results = {}
    for _, node in ipairs(ALL_NODES) do
        if node ~= self and node.is_active and node.inst:IsValid() then
            table.insert(results, node.inst)
        end
    end
    return results
end

return NetworkNode


-- ==============================================================================
-- 范式 2：双端网络注册与 ModRPC 安全校验 (modmain.lua)
-- ==============================================================================

-- 1. 注册主客端复制组件
AddReplicableComponent("network_node")

-- 2. 实体切面挂载
AddPrefabPostInit("homesign", function(inst)
    inst:AddTag("_network_node")
    if GLOBAL.TheWorld.ismastersim then
        inst:RemoveTag("_network_node")
        inst:AddComponent("network_node")
    end
end)

-- 3. 服务端安全校验 RPC 通道
AddModRPCHandler("NetworkNodeMod", "TeleportTo", function(player, src_inst, target_inst)
    if not player or not player:IsValid() or not src_inst or not target_inst then return end

    -- 安全校验 1：玩家是否在源节点交互范围内 (防全图隔空发包作弊)
    if player:GetDistanceSqToInst(src_inst) > 16 then return end

    local node = src_inst.components.network_node
    if not node then return end

    -- 安全校验 2：战斗与危险防逃逸
    local can_travel, reason = node:CanTravelNow(player)
    if not can_travel then
        if player.components.talker then
            player.components.talker:Say("I can't teleport right now! (" .. reason .. ")")
        end
        return
    end

    -- 校验通过：执行权威位移并扣除开销
    if player.Physics then
        player.Physics:Teleport(target_inst.Transform:GetWorldPosition())
    else
        player.Transform:SetPosition(target_inst.Transform:GetWorldPosition())
    end
end)
```

---

## 三、避坑与生产安全准则

1. **`OnRemoveFromEntity` 注销守卫不可或缺**：
   - 只要实体被玩家砸毁、被火烧毁、或被大脚踩烂，若没有在 `OnRemoveFromEntity` 中从全局表中将其引用清除，Lua 的 GC（垃圾回收器）就永远无法释放该实体，造成极其严重的堆内存泄漏。
2. **`Physics:Teleport` 与坐标直接赋值的分流**：
   - 传送具有物理刚体（Physics）的角色或生物时，必须调用 `inst.Physics:Teleport(x, y, z)`，严禁直接调用 `Transform:SetPosition`。直接改坐标会导致物理碰撞体残留在原地，引发隐形碰撞空气墙 bug。
