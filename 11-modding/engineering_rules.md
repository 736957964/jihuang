# 饥荒联机版（DST）核心 Mod 开发实战工程指南

> 本指南彻底抛弃学院派的抽象八股文，聚焦一线开发者最关心的四大核心工程问题：主客机同步、实体生命周期、网络 RPC 校验与组件 Hook。所有原则均附带可直接运行的 Lua 代码示范。

---

## 一、 主客机网络架构与数据同步铁律

在 DST 中，客机（Client）和主机（Master Sim / Dedicated Server）分别运行独立的代码环境。

### 1. 常见致命错误（直接崩溃或双端不同步）
```lua
-- ❌ 错误示范：在客机端直接调用服务器专属组件，客机直接闪退！
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    
    -- 错误！combat / health 是纯服务器组件，客机根本不存在这个表，访问为 nil 导致崩溃！
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(50)
    
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end
end
```

### 2. 标准规范做法（双端分离与网络同步）
```lua
-- ✅ 正确示范：严格以 `TheWorld.ismastersim` 划分主客机职责
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- 1. 双端共享数据：使用 Network 变量进行轻量级同步（客机可读）
    inst._is_special = net_bool(inst.GUID, "custom_inst._is_special", "special_dirty")

    -- 2. 客机动作预测（Action Picker）所需的标签，必须打在 Pristine 之前
    inst:AddTag("custom_interactable")

    inst.entity:SetPristine()

    -- 3. 客机在 Pristine 之后直接返回，绝不执行服务端逻辑
    if not TheWorld.ismastersim then
        return inst
    end

    -- 4. 服务端专属逻辑（组件、血量、攻击）
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(50)

    return inst
end
```

---

## 二、 实体生命周期管理（防内存泄漏与孤儿监听器）

### 1. 规则：动态监听器必须成对注销
Mod 经常向 `TheWorld` 或玩家监听全局事件。实体被移除时若不清理，会导致实体虽然销毁，但回调仍在运行，引发空指针异常。

```lua
-- ✅ 正确示范：监听全局事件必须绑定 OnRemove 清理
local function OnEntityInit(inst)
    local function OnSeasonChange(world, data)
        if inst:IsValid() then
            -- 业务逻辑
        end
    end

    -- 监听世界季节变化
    inst:ListenForEvent("seasonchange", OnSeasonChange, TheWorld)

    -- 实体销毁时必须从 TheWorld 取消监听！
    inst:ListenForEvent("onremove", function()
        inst:RemoveEventCallback("seasonchange", OnSeasonChange, TheWorld)
    end)
end
```

---

## 三、 自定义 Mod RPC 安全校验铁律

通过 `SendModRPCToServer` 提交玩家操作时，**绝不能无条件信任客机发来的数据**。

```lua
-- ✅ 正确示范：服务端 Mod RPC 严格防刷校验
AddModRPCHandler("MY_MOD", "UPGRADE_ITEM", function(player, target_guid, item_slot)
    -- 1. 基础校验：玩家有效且不是幽灵
    if not player or not player:IsValid() or player:HasTag("playerghost") then
        return
    end

    -- 2. 距离合法性校验：防止外挂超远距离触发
    local target = Ents[target_guid]
    if not target or not target:IsValid() or player:GetDistanceSqToInst(target) > 36 then
        return
    end

    -- 3. 资源合法性校验
    local item = player.components.inventory:GetItemInSlot(item_slot)
    if item and item.prefab == "goldnugget" and item.components.stackable.stacksize >= 5 then
        item.components.stackable:Get(5):Remove()
        -- 执行升级逻辑
        player.components.talker:Say("强化成功！")
    end
end)
```

---

## 四、 原版组件与函数的安全 Hook 准则

避免直接覆盖原版函数（如 `inst.fn = my_fn` 会导致其他 Mod 的改动被踩死）。

```lua
-- ✅ 正确示范：采用包装式（Wrapper）安全 Hook
local function SafeHookComponent(inst)
    if inst.components.combat then
        local _GetAttacked = inst.components.combat.GetAttacked
        inst.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage)
            -- 拦截或前置逻���
            if self.inst.has_shield then
                damage = damage * 0.5 -- 护盾减伤 50%
            end
            -- 调用原始函数，保持向后兼容
            return _GetAttacked(self, attacker, damage, weapon, stimuli, spdamage)
        end
    end
end
```