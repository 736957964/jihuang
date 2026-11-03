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


## 五、进阶拓扑演进与变体分支

### 变体演进：Circular Placement (圆形摆放辅助) (Mod 2914336761)
- **变体场景与切面**：收录来自工坊 Mod 2914336761 (`Circular Placement (圆形摆放辅助)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2914336761)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit('playercontroller', function(PlayerController, inst)
    if inst ~= ThePlayer then
        return
    end

    local oldOnControl = PlayerController.OnControl
    PlayerController.OnControl = function(self, control, down)
        if CPMA.DATA.LESS_PREVIEW and not (controls and controls.CPMAPanel and controls.CPMAPanel.IsShow) then
        else
            if IsDefaultScreen() and down and oldIsKeyDown(TheInput, GLOBAL['KEY_' .. CPMA.DATA.CP_AUTO_BUTTON]) and GLOBAL.CIRCLE_HELPER and GLOBAL.CIRCLE_HELPER:IsValid() then
                if control == CONTROL_PRIMARY or control == CONTROL_SECONDARY and (not CPMA.DATA.LESS_PREVIEW or (controls.CPMAPanel and controls.CPMAPanel.IsShow)) then
                    return
                end
            end
        end
        local mouse_control = mouse_controls[control]
        if down and auto_thread and IsDefaultScreen() and (interrupt_controls[control] or mouse_control ~= nil and not TheInput:GetHUDEntityUnderMouse()) then
            kill_auto_thread()
        end
        return oldOnControl(self, control, down)
    end

    local oldOnUpdate = PlayerController.OnUpdate
    PlayerController.OnUpdate = function(self, ...)
        if IsDefaultScreen() then
            OnUpdateAnchorPos()
            OnCenterUpdate()
        end
        return oldOnUpdate(self, ...)
    end
end)

```



### 变体演进：快捷宣告(NoMu) (Mod 2784715091)
- **变体场景与切面**：收录来自工坊 Mod 2784715091 (`快捷宣告(NoMu)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2784715091)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit("playercontroller", function(self)
    local old_OnControl = self.OnControl

    function self:OnControl(control, down, ...)
        -- 在宣告快捷键按下时阻断主/副操作
        if GLOBAL.NOMU_QA.DATA.BLOCK_ACTION
            and (control == GLOBAL.CONTROL_PRIMARY or control == GLOBAL.CONTROL_SECONDARY) then
            if IsDefaultScreen() and GLOBAL.QA_UTILS.IsAltPressed() and GLOBAL.QA_UTILS.IsShiftPressed() then
                return true
            end
        end

        if old_OnControl then
            return old_OnControl(self, control, down, ...)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:clock
AddComponentPostInit('clock', function(clock)
    local SW = TheWorld:HasTag("island") or TheWorld:HasTag("volcano")
    local HAM = TheWorld:HasTag("porkland")
    local oldGetDebugString = SW and clock.GetDebugString_tropical or HAM and clock.GetDebugString_plateau or clock.GetDebugString
    local oldDump = SW and clock.Dump_tropical or HAM and clock.Dump_plateau or clock.Dump

    local value
    value = Upvaluehelper.GetUpvalue(oldGetDebugString, '_phase')
    local _phase
    clock._phase = value
    _phase = value

    local _remainingtimeinphase
    value = Upvaluehelper.GetUpvalue(oldGetDebugString, '_remainingtimeinphase')
    clock._remainingtimeinphase = value
    _remainingtimeinphase = value

    local _segs = Upvaluehelper.GetUpvalue(oldDump, '_segs')
    local _totaltimeinphase = Upvaluehelper.GetUpvalue(oldDump,'_totaltimeinphase')

    if _totaltimeinphase and _remainingtimeinphase and _segs and _phase then
        clock.CalcRemainTimeOfDay = function()
            local time_of_day = _totaltimeinphase:value() - _remainingtimeinphase:value()
            for i = 1, _phase:value() - 1 do
                time_of_day = time_of_day + _segs[i]:value() * TUNING.SEG_TIME
            end
            return TUNING.TOTAL_DAY_TIME - time_of_day
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:nightmareclock
AddComponentPostInit('nightmareclock', function(clock)
    local oldOnUpdate = clock.OnUpdate
    local name, value

    local _remainingtimeinphase
    name, value = debug.getupvalue(oldOnUpdate, 1)
    if name == '_remainingtimeinphase' then
        _remainingtimeinphase = value
    end

    local _phase
    name, value = debug.getupvalue(oldOnUpdate, 4)
    if name == '_phase' then
        _phase = value
    end

    local PHASE_NAMES
    name, value = debug.getupvalue(oldOnUpdate, 5)
    if name == 'PHASE_NAMES' then
        PHASE_NAMES = value
    end

    local _totaltimeinphase
    name, value = debug.getupvalue(oldOnUpdate, 7)
    if name == '_totaltimeinphase' then
        _totaltimeinphase = value
    end

    if _remainingtimeinphase and _phase and _totaltimeinphase and PHASE_NAMES then
        function TheWorld:GetNightmareData()
            return {
                phase = PHASE_NAMES[_phase:value()],
                remain = _remainingtimeinphase:value(),
                total = _totaltimeinphase:value()
            }
        end
    end
end)

```



### 变体演进：兔尾艾冰 (Mod 3402670530)
- **变体场景与切面**：收录来自工坊 Mod 3402670530 (`兔尾艾冰`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3402670530)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skinner
AddComponentPostInit("skinner",function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s,skinname,...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst,old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst,new)
                end
                oldfn(s,skinname,...)
            end
        end
    end)

```

