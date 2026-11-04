# 饥荒一线工坊深度研读 Skill：客户端协程动作队列与框选批量调度架构

- **工坊 ID**：1608191708 (`ActionQueue Reborn`)
- **领域分类**：客户端纯净预测（Client-Only）、协程流水线（Thread Coroutine）、动作队列安全步进、手控打断应急响应（Walk Interruption）
- **研读基准**：Steam 创意工坊在线原版源码

在开发“自动砍树、批量收割、一键修墙、自动走位攻击”等增强类 MOD 时，最安全稳定的架构是**纯客户端协程调度器**：
1. 客户端使用 `inst:StartThread` 维持可挂起循环，避免阻塞游戏主线程；
2. 动作发出后，等待角色进入对应的 StateGraph 动作帧再步进下一个；
3. 随时监听移动控制输入，按下移动键瞬间终止队列。

```lua
-- ==============================================================================
-- ==============================================================================

local ClientActionScheduler = Class(function(self, inst)
    self.inst = inst
    self.queue = {}
    self.running_thread = nil
    self.is_active = false
end)
function ClientActionScheduler:Enqueue(act)
    if act and act:IsValid() then
        table.insert(self.queue, act)
    end
end
function ClientActionScheduler:Abort()
    self.queue = {}
    if self.running_thread then
        GLOBAL.KillThread(self.running_thread)
        self.running_thread = nil
    end
    self.is_active = false
end
function ClientActionScheduler:IsManualInterrupt()
    local controller = self.inst.components.playercontroller
    if controller and controller:IsEnabled() then
        return controller:IsAnyOfControlsPressed(
            GLOBAL.CONTROL_MOVE_UP,
            GLOBAL.CONTROL_MOVE_DOWN,
            GLOBAL.CONTROL_MOVE_LEFT,
            GLOBAL.CONTROL_MOVE_RIGHT
        )
    end
    return false
end
function ClientActionScheduler:Start()
    if self.running_thread or #self.queue == 0 then return end
    self.is_active = true

    self.running_thread = self.inst:StartThread(function()
        while #self.queue > 0 do
            if self:IsManualInterrupt() then
                self:Abort()
                break
            end

            local act = table.remove(self.queue, 1)

            if act and act.target and act.target:IsValid() and not act.target:IsInLimbo() then
                local playercontroller = self.inst.components.playercontroller
                if playercontroller then
                    playercontroller:DoAction(act)
                end

                GLOBAL.Sleep(0.2)

                while self.inst.sg and self.inst.sg:HasStateTag("busy") do
                    if self:IsManualInterrupt() then
                        self:Abort()
                        return
                    end
                    GLOBAL.Sleep(0.05)
                end
            end
        end

        self.running_thread = nil
        self.is_active = false
end)
end

return ClientActionScheduler
```

1. **绝对禁止在主线程使用无挂起的 `while` 循环调度**：
   - 必须通过 `ThePlayer:StartThread` 启动协程，并在动作之间使用 `GLOBAL.Sleep()` 挂起。如果在主循环中直接 `while` 派发几十个动作，会导致游戏界面直接卡死，且服务端会判定高频发包为恶意攻击而断开客机连接。
2. **`IsInLimbo()` 目标状态检查**：
   - 目标实体可能在排队等待期间被队友捡走、被火烧掉或掉入虚空（InLimbo）。在 `DoAction` 之前，必须严格执行 `not act.target:IsInLimbo()`，否则会引发寻路模块访问空位置崩溃。

## 五、进阶拓扑演进与变体分支

### 变体演进：󰀍 Cherry Forest 󰀍 (Mod 1289779251)
- **变体场景与切面**：收录来自工坊 Mod 1289779251 (`󰀍 Cherry Forest 󰀍`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:cherry_birdhouse
AddPrefabPostInit("cherry_birdhouse", function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		
		if TheWorld:HasTag("island") then
			if birdhouse_items_sw == nil and inst.birdhouse_items then
				birdhouse_items_sw = inst.birdhouse_items
				SetSWBirdhouseItems()
			end
			
			inst.birdhouse_items = birdhouse_items_sw
		end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ballphin
AddPrefabPostInit("ballphin", function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.WirlyBefriend = WirlyBallphinFn
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wildbore
AddPrefabPostInit("wildbore", function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.WirlyBefriend = WirlyWildboreFn
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:palmtree
AddPrefabPostInit("palmtree", function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("cherrybookmutable")
		inst.components.cherrybookmutable:SetOnMutateFn(MakeLeif)
		inst.components.cherrybookmutable.points = 10
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:leif_palm
AddPrefabPostInit("leif_palm", function(inst)
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("cherrybookmutable")
		inst.components.cherrybookmutable:SetOnMutateFn(MakeTree)
		inst.components.cherrybookmutable.points = 5
end)
```

### 变体演进：Quick Work (Mod 1200745268)
- **变体场景与切面**：收录来自工坊 Mod 1200745268 (`Quick Work`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:cave_banana_tree
local trees = {"cave_banana_tree", "marsh_tree", "livingtree"}
for _, t in ipairs(trees) do
    AddPrefabPostInit(t, QuickChop)
end

if GetModConfigData("MineTimes") ~= 999 then
    GLOBAL.TUNING.ICE_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ICE_MINE)
    GLOBAL.TUNING.ROCKS_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE)
    GLOBAL.TUNING.ROCKS_MINE_MED = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE_MED)
    GLOBAL.TUNING.ROCKS_MINE_LOW = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE_LOW)
    local function QuickMine(inst)
        if inst.components.workable then
            inst.components.workable:SetWorkLeft(GetIntegerSettingTimes("MineTimes", inst.components.workable.workleft))
        end
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:marsh_tree
AddPrefabPostInit("marsh_tree", QuickChop)
    AddPrefabPostInit("livingtree", QuickChop)

if GetModConfigData("MineTimes") ~= 999 then
    GLOBAL.TUNING.ICE_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ICE_MINE)
    GLOBAL.TUNING.ROCKS_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE)
    GLOBAL.TUNING.ROCKS_MINE_MED = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE_MED)
    GLOBAL.TUNING.ROCKS_MINE_LOW = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE_LOW)
    local function QuickMine(inst)
        if inst.components.workable then
            inst.components.workable:SetWorkLeft(GetIntegerSettingTimes("MineTimes", inst.components.workable.workleft))
        end
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:livingtree
AddPrefabPostInit("livingtree", QuickChop)

if GetModConfigData("MineTimes") ~= 999 then
    GLOBAL.TUNING.ICE_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ICE_MINE)
    GLOBAL.TUNING.ROCKS_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE)
    GLOBAL.TUNING.ROCKS_MINE_MED = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE_MED)
    GLOBAL.TUNING.ROCKS_MINE_LOW = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.ROCKS_MINE_LOW)
    local function QuickMine(inst)
        if inst.components.workable then
            inst.components.workable:SetWorkLeft(GetIntegerSettingTimes("MineTimes", inst.components.workable.workleft))
        end
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:archive_props
AddPrefabPostInit("archive_props", QuickMine)
    AddPrefabPostInit("marblepillar", QuickMine)
    AddPrefabPostInit("statue_marble", QuickMine)
    AddPrefabPostInit("statueharp", QuickMine)
    AddPrefabPostInit("statueharp_hedgespawner", QuickMine)
    AddPrefabPostInit("statuemaxwell", QuickMine)
    AddPrefabPostInit("ruins_statue_head", QuickMine)
    AddPrefabPostInit("ruins_statue_head_nogem", QuickMine)
    AddPrefabPostInit("ruins_statue_mage", QuickMine)
    AddPrefabPostInit("ruins_statue_mage_nogem", QuickMine)
    GLOBAL.TUNING.MARBLETREE_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLETREE_MINE)
    GLOBAL.TUNING.MARBLESHRUB_MINE_SMALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLESHRUB_MINE_SMALL)
    GLOBAL.TUNING.MARBLESHRUB_MINE_NORMAL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLESHRUB_MINE_NORMAL)
    GLOBAL.TUNING.MARBLESHRUB_MINE_TALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLESHRUB_MINE_TALL)
    GLOBAL.TUNING.PETRIFIED_TREE_SMALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.PETRIFIED_TREE_SMALL)
    GLOBAL.TUNING.PETRIFIED_TREE_NORMAL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.PETRIFIED_TREE_NORMAL)
    GLOBAL.TUNING.PETRIFIED_TREE_TALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.PETRIFIED_TREE_TALL)
    GLOBAL.TUNING.GARGOYLE_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.GARGOYLE_MINE)
    GLOBAL.TUNING.GARGOYLE_MINE_LOW = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.GARGOYLE_MINE_LOW)
    GLOBAL.TUNING.CAVEIN_BOULDER_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.CAVEIN_BOULDER_MINE)
    GLOBAL.TUNING.SPILAGMITE_SPAWNER = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SPILAGMITE_SPAWNER)
    GLOBAL.TUNING.SPILAGMITE_ROCK = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SPILAGMITE_ROCK)
    GLOBAL.TUNING.SCULPTURE_COVERED_WORK = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SCULPTURE_COVERED_WORK)
    GLOBAL.TUNING.SEASTACK_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SEASTACK_MINE)
    GLOBAL.TUNING.SHELL_CLUSTER_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SHELL_CLUSTER_MINE)
    GLOBAL.TUNING.MOONALTAR_ROCKS_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MOONALTAR_ROCKS_MINE)
    GLOBAL.TUNING.SALTSTACK_WORK_REQUIRED = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SALTSTACK_WORK_REQUIRED)
if GetModConfigData(\"Cooking\") then
    ChangeAction(GLOBAL.ACTIONS.COOK, "doshortaction")
    ChangeAction(GLOBAL.ACTIONS.SALT, "doshortaction")
end

if GetModConfigData("CookingTime") ~= 999 then
    GLOBAL.TUNING.BASE_COOK_TIME = GetModConfigData("CookingTime") * GLOBAL.TUNING.BASE_COOK_TIME
end

if GetModConfigData("FishTime") ~= 999 then
    local function QuickFishing(inst)
        if inst.components.fishingrod then
            inst.components.fishingrod:SetWaitTimes(GetModConfigData("FishTime"), GetModConfigData("FishTime"))
        end
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:marblepillar
AddPrefabPostInit("marblepillar", QuickMine)
    AddPrefabPostInit("statue_marble", QuickMine)
    AddPrefabPostInit("statueharp", QuickMine)
    AddPrefabPostInit("statueharp_hedgespawner", QuickMine)
    AddPrefabPostInit("statuemaxwell", QuickMine)
    AddPrefabPostInit("ruins_statue_head", QuickMine)
    AddPrefabPostInit("ruins_statue_head_nogem", QuickMine)
    AddPrefabPostInit("ruins_statue_mage", QuickMine)
    AddPrefabPostInit("ruins_statue_mage_nogem", QuickMine)
    GLOBAL.TUNING.MARBLETREE_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLETREE_MINE)
    GLOBAL.TUNING.MARBLESHRUB_MINE_SMALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLESHRUB_MINE_SMALL)
    GLOBAL.TUNING.MARBLESHRUB_MINE_NORMAL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLESHRUB_MINE_NORMAL)
    GLOBAL.TUNING.MARBLESHRUB_MINE_TALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MARBLESHRUB_MINE_TALL)
    GLOBAL.TUNING.PETRIFIED_TREE_SMALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.PETRIFIED_TREE_SMALL)
    GLOBAL.TUNING.PETRIFIED_TREE_NORMAL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.PETRIFIED_TREE_NORMAL)
    GLOBAL.TUNING.PETRIFIED_TREE_TALL = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.PETRIFIED_TREE_TALL)
    GLOBAL.TUNING.GARGOYLE_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.GARGOYLE_MINE)
    GLOBAL.TUNING.GARGOYLE_MINE_LOW = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.GARGOYLE_MINE_LOW)
    GLOBAL.TUNING.CAVEIN_BOULDER_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.CAVEIN_BOULDER_MINE)
    GLOBAL.TUNING.SPILAGMITE_SPAWNER = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SPILAGMITE_SPAWNER)
    GLOBAL.TUNING.SPILAGMITE_ROCK = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SPILAGMITE_ROCK)
    GLOBAL.TUNING.SCULPTURE_COVERED_WORK = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SCULPTURE_COVERED_WORK)
    GLOBAL.TUNING.SEASTACK_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SEASTACK_MINE)
    GLOBAL.TUNING.SHELL_CLUSTER_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SHELL_CLUSTER_MINE)
    GLOBAL.TUNING.MOONALTAR_ROCKS_MINE = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.MOONALTAR_ROCKS_MINE)
    GLOBAL.TUNING.SALTSTACK_WORK_REQUIRED = GetIntegerSettingTimes("MineTimes", GLOBAL.TUNING.SALTSTACK_WORK_REQUIRED)
if GetModConfigData(\"Cooking\") then
    ChangeAction(GLOBAL.ACTIONS.COOK, "doshortaction")
    ChangeAction(GLOBAL.ACTIONS.SALT, "doshortaction")
end

if GetModConfigData("CookingTime") ~= 999 then
    GLOBAL.TUNING.BASE_COOK_TIME = GetModConfigData("CookingTime") * GLOBAL.TUNING.BASE_COOK_TIME
end

if GetModConfigData("FishTime") ~= 999 then
    local function QuickFishing(inst)
        if inst.components.fishingrod then
            inst.components.fishingrod:SetWaitTimes(GetModConfigData("FishTime"), GetModConfigData("FishTime"))
        end
    end
end
end
end
end
```

### 变体演进：角色-以斯拉 (Mod 3694914776)
- **变体场景与切面**：收录来自工坊 Mod 3694914776 (`角色-以斯拉`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skinner
AddComponentPostInit("skinner", function(self)
    local oldfn = self.SetSkinName
    if oldfn then
        function self.SetSkinName(s, skinname, ...)
            local old = s.skin_name
            local new = skinname
            if characterskins[old] and characterskins[old].clear_fn then characterskins[old].clear_fn(s.inst, old) end
            if characterskins[new] and characterskins[new].init_fn then characterskins[new].init_fn(s.inst, new) end
            oldfn(s, skinname, ...)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
AddComponentPostInit("combat", function(self)
        self.dstlan_atkperiodmodifiers = SourceModifierList(self.inst)
        self.dstlan_orig_min_attack_period = self.min_attack_period
        local p = rawget(self, "_")["min_attack_period"]
        local old_on_map = p[2]
        p[2] = function(self, map)
            if old_on_map ~= nil then
                old_on_map(self, map)
            end
            if self.inst.replica.combat and self.inst.replica.combat.dstlan_atkperiodmult then
                self.inst.replica.combat.dstlan_atkperiodmult:set(self.dstlan_atkperiodmodifiers:Get())
            end
        end

        function self:SetAttackPeriod(val)
            self.dstlan_orig_min_attack_period = val
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end

        function self:SetAtkPeriodModifier(source, mult, key)
            self.dstlan_atkperiodmodifiers:SetModifier(source, mult, key)
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end

        function self:RemoveAtkPeriodModifier(source, key)
            self.dstlan_atkperiodmodifiers:RemoveModifier(source, key)
            self.min_attack_period = self.dstlan_orig_min_attack_period / self.dstlan_atkperiodmodifiers:Get()
        end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson
AddStategraphPostInit("wilson", function(sg)
        local old_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function (inst,...)
            local res = old_onenter ~= nil and {old_onenter(inst,...)} or {}
            local combat = inst.components.combat
            local timeout = (math.floor(13/(combat.dstlan_atkperiodmodifiers:Get())))*FRAMES
            inst.sg:SetTimeout(timeout)
            inst.AnimState:SetDeltaTimeMultiplier(combat.dstlan_atkperiodmodifiers:Get())
            return unpack(res)
        end

        local old_ontimeout = sg.states["attack"].ontimeout
        sg.states["attack"].ontimeout = function (inst,...)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag('abouttoattack')
            return old_ontimeout(inst,...)
        end

        local old_onexit = sg.states["attack"].onexit
        sg.states["attack"].onexit = function (inst,...)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            return old_onexit(inst,...)
        end

end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
AddStategraphPostInit("wilson_client", function(sg)
        local old_onenter = sg.states["attack"].onenter
        sg.states["attack"].onenter = function (inst,...)
            local res = old_onenter ~= nil and {old_onenter(inst,...)} or {}
            local timeout = (math.floor(13/inst.replica.combat.dstlan_atkperiodmult:value()))*FRAMES
            inst.sg:SetTimeout(timeout)
            inst.AnimState:SetDeltaTimeMultiplier(inst.replica.combat.dstlan_atkperiodmult:value())
            return unpack(res)
        end

        local old_ontimeout = sg.states["attack"].ontimeout
        sg.states["attack"].ontimeout = function (inst,...)
            inst:PerformPreviewBufferedAction()
            inst.sg:RemoveStateTag('abouttoattack')
            return old_ontimeout(inst,...)
        end

        local old_onexit = sg.states["attack"].onexit
        sg.states["attack"].onexit = function (inst,...)
            inst.AnimState:SetDeltaTimeMultiplier(1)
            return old_onexit(inst,...)
        end

end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cook_certificate
AddPrefabPostInit('cook_certificate',function (inst)
        if not TheWorld.ismastersim then
            return inst
        end

        local old_HarvestFoodFn = inst.HarvestFoodFn
        ---@diagnostic disable-next-line: inject-field
        inst.HarvestFoodFn = function(inst,foodname,harvester,cookpotname,...)
            local fuelnum = GetThisMODDishConsume(foodname)
            if foodname and fuelnum > 0 and not table.contains(inst.foodlist,foodname) then
                if inst.components.finiteuses then
                    inst.components.finiteuses:Use(fuelnum)
                    inst.foodlist[#inst.foodlist+1]=foodname
                    setFoodList(inst,harvester)--同步料理列表
                    if not RewardToiler(harvester,0.1) then--天道酬勤
                        SpawnMedalTips(harvester,fuelnum,10)--弹幕提示
                    end
                end
            end
            return old_HarvestFoodFn ~= nil and old_HarvestFoodFn(inst,foodname,harvester,cookpotname,...) or nil
        end
end)
```

### 变体演进：Mystery, The Necromancer (Mod 3417353600)
- **变体场景与切面**：收录来自工坊 Mod 3417353600 (`Mystery, The Necromancer`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function(inst)
    if inst.ismastersim then
        inst:AddComponent("worldwysteryskills") -- Attach the components to the world
        inst:AddComponent("world_soulregenerator")
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:forest_network
AddPrefabPostInit("forest_network", SetupRiftsNetVar)
AddPrefabPostInit("cave_network", SetupRiftsNetVar)

AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then return end

    inst:DoTaskInTime(0, function()
        local riftspawner = inst.components.riftspawner
        if not riftspawner then return end

        local function SyncRiftsActive()
            local enabled = riftspawner:GetEnabled() == true
            if inst.net and inst.net._wystery_rifts_active then
                inst.net._wystery_rifts_active:set(enabled)
            end
        end

        SyncRiftsActive()

        local _EnableLunar = riftspawner.EnableLunarRifts
        riftspawner.EnableLunarRifts = function(self, src)
            _EnableLunar(self, src)
            SyncRiftsActive()
        end
        local _EnableShadow = riftspawner.EnableShadowRifts
        riftspawner.EnableShadowRifts = function(self, src)
            _EnableShadow(self, src)
            SyncRiftsActive()
        end
        local _SetEnabled = riftspawner.SetEnabledSetting
        riftspawner.SetEnabledSetting = function(self, src, val)
            _SetEnabled(self, src, val)
            SyncRiftsActive()
        end
        local _SetEnabledCave = riftspawner.SetEnabledSettingCave
        riftspawner.SetEnabledSettingCave = function(self, src, val)
            _SetEnabledCave(self, src, val)
            SyncRiftsActive()
        end
end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cave_network
AddPrefabPostInit("cave_network", SetupRiftsNetVar)

AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then return end

    inst:DoTaskInTime(0, function()
        local riftspawner = inst.components.riftspawner
        if not riftspawner then return end

        local function SyncRiftsActive()
            local enabled = riftspawner:GetEnabled() == true
            if inst.net and inst.net._wystery_rifts_active then
                inst.net._wystery_rifts_active:set(enabled)
            end
        end

        SyncRiftsActive()

        local _EnableLunar = riftspawner.EnableLunarRifts
        riftspawner.EnableLunarRifts = function(self, src)
            _EnableLunar(self, src)
            SyncRiftsActive()
        end
        local _EnableShadow = riftspawner.EnableShadowRifts
        riftspawner.EnableShadowRifts = function(self, src)
            _EnableShadow(self, src)
            SyncRiftsActive()
        end
        local _SetEnabled = riftspawner.SetEnabledSetting
        riftspawner.SetEnabledSetting = function(self, src, val)
            _SetEnabled(self, src, val)
            SyncRiftsActive()
        end
        local _SetEnabledCave = riftspawner.SetEnabledSettingCave
        riftspawner.SetEnabledSettingCave = function(self, src, val)
            _SetEnabledCave(self, src, val)
            SyncRiftsActive()
        end
end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
AddStategraphPostInit("wilson_client", function(inst)
    local _OldPstRunState = inst.states["run_stop"].onenter
	inst.states["run_stop"].onenter = function(inst)
        local val = _OldPstRunState(inst)
        local isshark = inst.replica.rider and inst.replica.rider:GetMount() and inst.replica.rider:GetMount():HasTag("shark")
        if isshark then
            inst.AnimState:PlayAnimation("sail_pst")
            return
        end

        if inst:HasTag("wraithform") then
            inst.AnimState:PlayAnimation(inst:HasTag("rictusform") and "bite_pst" or "walk_pst")
            return
        end
		return val
	end
    local _OldPreRunState = inst.states["run_start"].onenter
	inst.states["run_start"].onenter = function(inst)
        local val = _OldPreRunState(inst)
        local isshark = inst.replica.rider and inst.replica.rider:GetMount() and inst.replica.rider:GetMount():HasTag("shark")

        if isshark then
            inst.AnimState:PlayAnimation("sail_pre")
            return
        end

        if inst:HasTag("wraithform") then
            inst.AnimState:PlayAnimation(inst:HasTag("rictusform") and "bite_pre" or "walk_pre")
            return
        end
		return val
	end
	local _OldRunState = inst.states["run"].onenter
	inst.states["run"].onenter = function(inst)
		local anim = GetRunStateAnim(inst)
        if anim == "run" then
			if inst:HasTag("wraithform") then
				anim = inst:HasTag("rictusform") and "bite_loop" or "walk_loop"
				
				if not inst.AnimState:IsCurrentAnimation(anim) then
					inst.AnimState:PlayAnimation(anim, true)
				    return
				end
			else
                local isshark = inst.replica.rider and inst.replica.rider:GetMount() and inst.replica.rider:GetMount():HasTag("shark")
                if isshark then
                    inst.AnimState:PlayAnimation("sail_loop", true)
                    return
                end
				anim = "run_loop"
			end
		end

		return _OldRunState(inst)
	end
    
    local _OldIdleState = inst.states["idle"].onenter
	inst.states["idle"].onenter = function(inst, ...)
        if inst:HasTag("wraithform")then
            if inst:HasTag("rictusform") then
                inst.sg:GoToState("rictusidle")
            else
                inst.sg:GoToState("wraithidle")
            end
            return
        end
		return _OldIdleState(inst, ...)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory
AddComponentPostInit("inventory", function(self)
	local _DropEverything = self.DropEverything
	self.DropEverything = function(self, ondeath, ...)
		local inst = self.inst
		local binding = inst and inst.cross_shard_effigy_binding
		if ondeath and binding ~= nil
			and binding.shard_id ~= nil
			and binding.shard_id ~= TheShard:GetShardId() then
			return
		end
		if ondeath then
		end
		return _DropEverything(self, ondeath, ...)
	end
end)
```

### 变体演进：[Arknights]明日方舟-维什戴尔Wiš (Mod 3627500499)
- **变体场景与切面**：收录来自工坊 Mod 3627500499 (`[Arknights]明日方舟-维什戴尔Wiš`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddStategraphPostInit:wilson
AddStategraphPostInit("wilson", stateidle)
AddStategraphPostInit("wilson_client", stateidle)
local function statefunnyidle(sg)
    local old_state_onenter = sg.states.funnyidle.onenter
    sg.states.funnyidle.onenter = function(inst, ...)
        if IsNoe(inst) then
            inst.sg:GoToState("idle")
            return
        end
        if old_state_onenter then
            old_state_onenter(inst, ...)
        end
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddStategraphPostInit:wilson_client
AddStategraphPostInit("wilson_client", stateidle)
local function statefunnyidle(sg)
    local old_state_onenter = sg.states.funnyidle.onenter
    sg.states.funnyidle.onenter = function(inst, ...)
        if IsNoe(inst) then
            inst.sg:GoToState("idle")
            return
        end
        if old_state_onenter then
            old_state_onenter(inst, ...)
        end
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:slipperyfeet
AddComponentPostInit("slipperyfeet", function(self)
    local olddodelta = self.DoDelta
    function self:DoDelta(delta)
        if (self.inst:HasTag("wisadel") and self.inst:HasTag("flying")) then
            self:SetCurrent(0)
            return
        end
        olddodelta(self, delta)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:locomotor
AddComponentPostInit("locomotor", function(self)
    local oldupdategroundspeedmultiplier = self.UpdateGroundSpeedMultiplier
    function self:UpdateGroundSpeedMultiplier()
        if (self.inst:HasTag("wisadel") and self.inst:HasTag("flying")) then
            self.groundspeedmultiplier = 1
            return
        end
        oldupdategroundspeedmultiplier(self)
    end

    local oldstarthopping = self.StartHopping
    function self:StartHopping(x,z,target_platform)
        if (self.inst:HasTag("wisadel") and self.inst:HasTag("flying")) then
            return
        end
        oldstarthopping(self, x, z, target_platform)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:health
AddComponentPostInit("health", function(self)
    local old = self.SetVal
    self.SetVal = function(s, ...)
        local oldhealth = s.currenthealth
        old(s, ...)
        if s.inst and s.currenthealth <= oldhealth and oldhealth > 0 then
            if s.inst:HasTag("wisadel") then
                local count = s.inst.wis_shard_hp_count or 0
                if count + (oldhealth - s.currenthealth) < 50 then
                    s.inst.wis_shard_hp_count = count + (oldhealth - s.currenthealth)
                else
                    if s.inst.components.inventory then
                        s.inst.components.inventory:GiveItem(SpawnPrefab("arknights_originium_shard"))
                        s.inst.wis_shard_hp_count = 0
                    end
                end
            elseif s.currenthealth <= 0 and not s.inst:HasOneOfTags(no_tags) then
                local x, y, z = s.inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 10, {'wisadel'})
                for k, v in pairs(ents) do
                    if v.components.sanity then
                        v.components.sanity:DoDelta(2.5)
                    end
                end
            end
        end
    end
end)

AddComponentPostInit(
    'combat',
    function(self, inst)
        local oldGetAttacked_Internal = self.GetAttacked_Internal
        function self:GetAttacked_Internal(attacker, damage, weapon, stimuli, spdamage, from_doattack)
            if self.inst and (self.inst.components.arknights_buff and self.inst.components.arknights_buff:isBuffKey("stun")) and not self.inst:HasOneOfTags({"player", "companion", "wall"}) then
                if  
                    FindEntity(self.inst, 16, nil, {"wisadel_elite_2"})
                then
                    local mult = .1
                    if damage then
                        damage = damage * (1 + mult)
                    end
                end
            end

            if self.inst and not self.inst:HasOneOfTags({"player", "companion", "wall"}) then
                local wisadel = FindEntity(self.inst, 10, nil, {"wisadel"})
                if  
                    wisadel and wisadel:IsValid() and (wisadel.components.arknights_lv and wisadel.components.arknights_lv.elitelv >= 1)
                then
                    local mult = wisadel.wis_armor_bonuspercent or 0
                    if damage then
                        damage = damage * (1 + mult)
                    end
                end
            end

            if self.inst and (attacker and attacker.components.arknights_lv) and (weapon and weapon:HasTag("wis_cannon_skill")) then
                local skilllv = attacker.components.arknights_lv.skilllv
                local multiple = 2.1
                multiple = multiple + (skilllv * .1)
                if damage then
                    damage = damage * multiple
                end
            end

            if self.inst and attacker and type(attacker) == "table" and attacker.IsValid and attacker:IsValid() and attacker:HasTag("wis_drone") then
                if attacker._playerlink then
                    attacker = attacker._playerlink
                end
            end

            

            return oldGetAttacked_Internal(self, attacker, damage, weapon, stimuli, spdamage, from_doattack)
        end
    end
end
```



### 变体演进：capacity (Mod 3831535302)
- **变体场景与切面**：收录来自工坊 Mod 3831535302 (`capacity`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3831535302)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：会飞的梅宝 (Mod 3824334327)
- **变体场景与切面**：收录来自工坊 Mod 3824334327 (`会飞的梅宝`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3824334327)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Lux (Mod 1494505371)
- **变体场景与切面**：收录来自工坊 Mod 1494505371 (`Lux`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1494505371)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：刘辩 (Mod 3577718127)
- **变体场景与切面**：收录来自工坊 Mod 3577718127 (`刘辩`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3577718127)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:combat
AddComponentPostInit("combat",function(self)
	local old_SetRetargetFunction = self.SetRetargetFunction
	function self:SetRetargetFunction(...)
		old_SetRetargetFunction(self,...)
		if self.targetfn ~= nil then
			local old_targetfn = self.targetfn
			self.targetfn = function(...)
				local newtarget, forcechange = old_targetfn(...)
				if newtarget then
					if isnottoadstool(self.inst) and isnotvalidtarget(newtarget) then
						newtarget = nil
					end
				end
				return newtarget, forcechange
			end
		end
	end
	local old_ShareTarget = self.ShareTarget
	function self:ShareTarget(target,...)
		if isnottoadstool(self.inst) and isnotvalidtarget(target) then
			return
		end
		old_ShareTarget(self,target,...)
	end

	local old_SuggestTarget = self.SuggestTarget
	function self:SuggestTarget(target,...)
		if isnottoadstool(self.inst) and  isnotvalidtarget(target) then
			return
		end
		old_SuggestTarget(self,target,...)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:koalefantbrain
AddBrainPostInit("koalefantbrain", function(self)
	for k, v in ipairs(self.bt.root.children) do
		if type(v) == "table" then
			findhunter(v,{"liubian_amulet_equipped"})
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:babybeefalobrain
AddBrainPostInit("babybeefalobrain", function(self)
	for k, v in ipairs(self.bt.root.children) do
		if type(v) == "table" then
			findhunter(v,{"liubian_amulet_equipped"})
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:rabbitbrain
AddBrainPostInit("rabbitbrain", function(self)
	for k, v in ipairs(self.bt.root.children) do
		if type(v) == "table" then
			findhunter(v,{"liubian_amulet_equipped"})
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:perdbrain
AddBrainPostInit("perdbrain", function(self)
	for k, v in ipairs(self.bt.root.children) do
		if type(v) == "table" then
			findhunter(v,{"liubian_amulet_equipped"})
		end
	end
end)

```



### 变体演进：无线存储终端 (Mod 3697123554)
- **变体场景与切面**：收录来自工坊 Mod 3697123554 (`无线存储终端`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3697123554)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function(inst)
    if inst ~= nil and inst.ismastersim and inst.DoTaskInTime ~= nil then
        inst:DoTaskInTime(0, function()
            local core = EnsureSharedStorageCore()
            if core ~= nil then
                if inst.ismastershard then
                    DebugPrint("Shared storage core ready for shard", "Master")
                else
                    DebugPrint("Shared storage authority proxy ready for shard", GetCurrentShardId())
                end
            end
        end)

        local ls = StorageDefs.EnsureLiuStorageWorldState(inst)
        if inst.DoPeriodicTask ~= nil and ls.pending_sweep_task == nil then
            ls.pending_sweep_task = inst:DoPeriodicTask(
                STORAGE_REQUEST_TIMEOUT_SWEEP_INTERVAL,
                Shard.SweepExpiredSharedStorageRequests
            )
        end

        inst:ListenForEvent("onremove", function()
            local ls = StorageDefs.EnsureLiuStorageWorldState(inst)
            local core = (ls ~= nil and ls.core) or FindSharedStorageCore()
            if core ~= nil then
                CancelSharedStorageFlushTask(core)
            end
            if ls ~= nil and ls.pending_sweep_task ~= nil then
                ls.pending_sweep_task:Cancel()
                ls.pending_sweep_task = nil
            end
        end)
    end
end)

```

