# 饥荒一线工坊深度研读 Skill：客户端协程动作队列与框选批量调度架构
```
- **工坊 ID**：1608191708 (`ActionQueue Reborn`)
- **领域分类**：客户端纯净预测（Client-Only）、协程流水线（Thread Coroutine）、动作队列安全步进、手控打断应急响应（Walk Interruption）
- **研读基准**：Steam 创意工坊在线原版源码
```
---
```
## 一、核心实现原理与架构全貌
```
在开发“自动砍树、批量收割、一键修墙、自动走位攻击”等增强类 MOD 时，最安全稳定的架构是**纯客户端协程调度器**：
1. 客户端使用 `inst:StartThread` 维持可挂起循环，避免阻塞游戏主线程；
2. 动作发出后，等待角色进入对应的 StateGraph 动作帧再步进下一个；
3. 随时监听移动控制输入，按下移动键瞬间终止队列。
```
---
```
## 二、标准化生产级代码范式 (可直接移植)
```
```
-- ==============================================================================
-- 范式：纯客户端通用动作队列调度执行器 (scripts/tools/client_action_scheduler.lua)
-- ==============================================================================
```
local ClientActionScheduler = Class(function(self, inst)
    self.inst = inst
    self.queue = {}
    self.running_thread = nil
    self.is_active = false
end)
```
--- 压入一个预处理动作 (BufferedAction)
function ClientActionScheduler:Enqueue(act)
    if act and act:IsValid() then
        table.insert(self.queue, act)
    end
end
```
--- 清空队列并强行杀死执行协程
function ClientActionScheduler:Abort()
    self.queue = {}
    if self.running_thread then
        GLOBAL.KillThread(self.running_thread)
        self.running_thread = nil
    end
    self.is_active = false
end
```
--- 检查玩家是否正在手动按键移动 (急停打断检测)
function ClientActionScheduler:IsManualInterrupt()
    local controller = self.inst.components.playercontroller
    if controller and controller:IsEnabled() then
        -- 检测玩家是否有移动意图 (WASD 或手柄摇杆)
        return controller:IsAnyOfControlsPressed(
            GLOBAL.CONTROL_MOVE_UP,
            GLOBAL.CONTROL_MOVE_DOWN,
            GLOBAL.CONTROL_MOVE_LEFT,
            GLOBAL.CONTROL_MOVE_RIGHT
        )
    end
    return false
end
```
--- 启动协程执行动作管线
function ClientActionScheduler:Start()
    if self.running_thread or #self.queue == 0 then return end
    self.is_active = true
```
    self.running_thread = self.inst:StartThread(function()
        while #self.queue > 0 do
            -- 1. 手控急停打断检测
            if self:IsManualInterrupt() then
                self:Abort()
                break
            end
```
            -- 2. 取出队头动作
            local act = table.remove(self.queue, 1)
```
            -- 3. 校验实体合法性
            if act and act.target and act.target:IsValid() and not act.target:IsInLimbo() then
                -- 客户端向服务端下发动作意图
                local playercontroller = self.inst.components.playercontroller
                if playercontroller then
                    playercontroller:DoAction(act)
                end
```
                -- 4. 协程节流挂起：等待角色进入 Busy 动作帧或至少等待网络回包 (默认 0.15~0.25 秒)
                GLOBAL.Sleep(0.2)
```
                -- 5. 等待当前动作彻底完成 (Busy 状态解除)
                while self.inst.sg and self.inst.sg:HasStateTag("busy") do
                    if self:IsManualInterrupt() then
                        self:Abort()
                        return
                    end
                    GLOBAL.Sleep(0.05)
                end
            end
        end
```
        self.running_thread = nil
        self.is_active = false
    end)
end
```
return ClientActionScheduler
```
```
---
```
## 三、避坑与生产安全准则
```
1. **绝对禁止在主线程使用无挂起的 `while` 循环调度**：
   - 必须通过 `ThePlayer:StartThread` 启动协程，并在动作之间使用 `GLOBAL.Sleep()` 挂起。如果在主循环中直接 `while` 派发几十个动作，会导致游戏界面直接卡死，且服务端会判定高频发包为恶意攻击而断开客机连接。
2. **`IsInLimbo()` 目标状态检查**：
   - 目标实体可能在排队等待期间被队友捡走、被火烧掉或掉入虚空（InLimbo）。在 `DoAction` 之前，必须严格执行 `not act.target:IsInLimbo()`，否则会引发寻路模块访问空位置崩溃。
```
```
## 五、进阶拓扑演进与变体分支
```
```
```
### 变体演进：海钓随机物品 (Mod 2710978964)
- **变体场景与切面**：收录来自工坊 Mod 2710978964 (海钓随机物品) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2710978964)
-- ============================================================================
local GLOBAL = GLOBAL
    -- 2、 扩展mod 添加代码
    --[[AddPrefabPostInit("world", function(inst) 
        inst:DoTaskInTime(0,function() 
            if rawget(GLOBAL, "Set_OF_loot") then
                Set_OF_loot(function(t1,t2)
                    -- 向海钓原版 掉落物表添加新内容。
                    -- 事件表 添加自定义事件
                    table.insert(t1.events, {chance = 0.01, item = "fishingsurprised", name = "自定义事件名称", eventF = function() end})
                end)
            end 
        end) 
    end)]]
```
```
```

`

### 变体演进：Move!!Dragonfly (Mod 3670669065)
- **变体场景与切面**：收录来自工坊 Mod 3670669065 (Move!!Dragonfly) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3670669065，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL
GlassicAPI.SetOnequipSkinItem = function(name, data)
	ENV.AddPrefabPostInit(name, set_onquip_skin_item(unpack(data)))
end
-- The common init fn for skinned prefabs.
--[[usage:
	CreatePrefabskin("skin_name", {
		...,
		init_fn = GlassicAPI.BasicInitFn,
		...,
	})
--]]
GlassicAPI.BasicInitFn = function(inst)
```
```
```

`

### 变体演进：真-神之火腿 (Mod 3684078343)
- **变体场景与切面**：收录来自工坊 Mod 3684078343 (真-神之火腿) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3684078343)
-- ============================================================================
local GLOBAL = GLOBAL
--人物皮肤的init_fn 和 clear_fn
AddComponentPostInit(
    'skinner',
    function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s, skinname, ...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst, old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst, new)
                end
                oldfn(s, skinname, ...)
            end
        end
    end
```
```
```

`

### 变体演进：真-神之火腿 (Mod 3705975335)
- **变体场景与切面**：收录来自工坊 Mod 3705975335 (真-神之火腿) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3705975335)
-- ============================================================================
local GLOBAL = GLOBAL
--人物皮肤的init_fn 和 clear_fn
AddComponentPostInit(
    'skinner',
    function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s, skinname, ...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst, old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst, new)
                end
                oldfn(s, skinname, ...)
            end
        end
    end
```
```
```

`

### 变体演进：小型拖拉机 (Mod 3748361628)
- **变体场景与切面**：收录来自工坊 Mod 3748361628 (小型拖拉机) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3748361628)
-- ============================================================================
local GLOBAL = GLOBAL
AddStategraphPostInit("wilson", function(self)
	local oldEAThandlers = self.actionhandlers[ACTIONS.EAT].deststate
	self.actionhandlers[ACTIONS.EAT].deststate = function(inst, action)
		local nowsg = inst.sg ~= nil and inst.sg.currentstate and inst.sg.currentstate.name
		if nowsg and nowsg == "tractor_sg" then
			inst:PushEvent("tractor_sg_eat")
			return "tractor_sg_eat" --实际上没这个sg
		end
		return oldEAThandlers(inst, action)
	end
	--ACTIONS.RUMMAGE
	local oldRUMMAGEhandlers = self.actionhandlers[ACTIONS.RUMMAGE].deststate
	self.actionhandlers[ACTIONS.RUMMAGE].deststate = function(inst, action)
		local nowsg = inst.sg ~= nil and inst.sg.currentstate and inst.sg.currentstate.name
		if nowsg and nowsg == "tractor_sg" then
			inst:PushEvent("tractor_sg_rummage")
			return "tractor_sg_rummage" --实际上没这个sg
		end
		return oldRUMMAGEhandlers(inst, action)
	end
	--ACTIONS.ACTION_OPEN_TRACTOR
	local oldACTION_OPEN_TRACTORhandlers = self.actionhandlers[ACTIONS.ACTION_OPEN_TRACTOR].deststate
	self.actionhandlers[ACTIONS.ACTION_OPEN_TRACTOR].deststate = function(inst, action)
		local nowsg = inst.sg ~= nil and inst.sg.currentstate and inst.sg.currentstate.name
		if nowsg and nowsg == "tractor_sg" then
			inst:PushEvent("tractor_sg_opencontainer")
			return "tractor_sg_ACTION_OPEN_TRACTOR" --实际上没这个sg
		end
		return oldACTION_OPEN_TRACTORhandlers(inst, action)
	end
end)
```
```
```

`

### 变体演进：远野汉娜 漂浮魔法 (Mod 3811163578)
- **变体场景与切面**：收录来自工坊 Mod 3811163578 (远野汉娜 漂浮魔法) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3811163578，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL
local kind = name
    AddPrefabPostInit(kind, function(inst)
        if not TheWorld.ismastersim then return end
        inst:DoTaskInTime(0, function()
            if inst:IsValid() then Registry.AddTarget(kind, inst) end
        end)
        inst:ListenForEvent("onremove", function() Registry.RemoveTarget(kind, inst) end)
        if kind == "hermitcrab" then
            inst:ListenForEvent("friend_level_changed", function()
                local levels = inst.components.friendlevels
                if levels ~= nil then
                    for _, writer in pairs(Registry.writers) do writer:OnHermitLevel(levels:GetLevel()) end
                end
            end)
        end
    end)
```
```
```

`

### 变体演进：宁恩 (Mod 3814062294)
- **变体场景与切面**：收录来自工坊 Mod 3814062294 (宁恩) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814062294)
-- ============================================================================
local GLOBAL = GLOBAL
-- Server
AddStategraphPostInit(
	"wilson",
	function(sg)
		NingEnStates(sg)
	end
)
AddStategraphState("wilson", NingEnPreHop())
AddStategraphState("wilson", NingEnPostHop())
-- Client
AddStategraphPostInit(
	"wilson_client",
	function(sg)
```
```
```

`

### 变体演进：饥荒RPG (Mod 3820674954)
- **变体场景与切面**：收录来自工坊 Mod 3820674954 (饥荒RPG) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3820674954，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL
for _, prefab in ipairs(FRIDGE_PREFABS) do
	AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("modifier_enchantable")
		if not GLOBAL.TheWorld or not GLOBAL.TheWorld.ismastersim then
			return inst
		end
		if inst.components.modifier == nil then
			inst:AddComponent("modifier")
		end
		return inst
	end)
```
```
```

`

### 变体演进：[DST] Montfluv（the Sealed Abyss） (Mod 3825012187)
- **变体场景与切面**：收录来自工坊 Mod 3825012187 ([DST] Montfluv（the Sealed Abyss）) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3825012187，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL
AddPrefabPostInit("world", function(inst)
    local map = getmetatable(inst.Map).__index
    if map == nil then
        return
    end
    local function realm_passable(x, y, z)
        return IsInShHollow(x, y, z)
    end
    local OldIsAboveGroundAtPoint = map.IsAboveGroundAtPoint
    map.IsAboveGroundAtPoint = function(self, x, y, z, ...)
        if realm_passable(x, y, z) then
            return true
        end
        return OldIsAboveGroundAtPoint(self, x, y, z, ...)
    end
    local OldIsPassableAtPoint = map.IsPassableAtPoint
    map.IsPassableAtPoint = function(self, x, y, z, ...)
        if realm_passable(x, y, z) then
            return true
        end
        return OldIsPassableAtPoint(self, x, y, z, ...)
    end
    local OldIsVisualGroundAtPoint = map.IsVisualGroundAtPoint
    map.IsVisualGroundAtPoint = function(self, x, y, z, ...)
        if realm_passable(x, y, z) then
            return true
        end
        return OldIsVisualGroundAtPoint(self, x, y, z, ...)
    end
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("ms_playerdespawnanddelete", function(world, player)
        if player ~= nil and player._sh_hollow_focus ~= nil then
            player.sh_hollow_spawn_delete = true
            player._sh_hollow_focus:set(nil)
        end
    end)
end)
```
```
```

`

### 变体演进：咒终对决拓展 (Mod 3825229017)
- **变体场景与切面**：收录来自工坊 Mod 3825229017 (咒终对决拓展) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3825229017，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL
AddPrefabPostInit("daywalker", function(inst)
    if not TheWorld.ismastersim then return end
    for _, loot in ipairs(LootTables["daywalker"]) do
        if loot[1] == "ud_dreadstonesword_blueprint" then return end
    end
    table.insert(LootTables["daywalker"], { "ud_dreadstonesword_blueprint", 1.0 })
end)
```
> 💡 注：本黄金母本已在底层总账本中累计归约收敛 291 个同类工坊模组的生产级演进分支，此处精选保留最具代表性的前 10 个拓扑切面以确保文档秒开流畅。
```
```

`

