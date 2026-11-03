# 饥荒一线工坊深度研读 Skill：全局 TUNING 梯队注入与 AddPrefabPostInitAny 智能逼近

- **工坊 ID**：374550642 (`Increased Stack size`)
- **领域分类**：全局 TUNING 宏变量重写、`AddPrefabPostInitAny` 全局实体切面优化、非标离散数值区间逼近算法
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在饥荒模组开发中，很多全局性调整（如调整全服腐烂速度、全服堆叠上限、全服移动速度倍率）有两种流派：
1. **轻量流派（推荐首选）**：改写官方 `GLOBAL.TUNING` 表中的宏常量；
2. **强制穿透流派（防御第三方硬编码）**：借助 `AddPrefabPostInitAny` 拦截所有实例化实体并强行修正组件。

`Increased Stack Size` 提供了这两种流派融合的最佳实践。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：全局 TUNING 五级梯队宏覆盖 (modmain.lua)
-- ==============================================================================

local TUNING = GLOBAL.TUNING

-- 1. 覆写官方标准梯队 (侵入性最低，零运行时开销)
TUNING.STACK_SIZE_LARGEITEM = 40  -- 原版 10 (如大肉、原木)
TUNING.STACK_SIZE_MEDITEM   = 80  -- 原版 20 (如草、枝条、石头)
TUNING.STACK_SIZE_SMALLITEM = 99  -- 原版 40 (如浆果、花瓣)
TUNING.STACK_SIZE_TINYITEM  = 120 -- 原版 60 (如蜜蜂、蚊子)
TUNING.STACK_SIZE_PELLET    = 250 -- 原版 120 (如种子、火药)


-- ==============================================================================
-- 范式 2：针对硬编码第三方 Prefab 的智能区间逼近器 (scripts/tools/stack_approximator.lua)
-- ==============================================================================

local TARGET_TIERS = { 40, 80, 99, 120, 250 }

-- 离散区间逼近：将非标数值（如 50）智能平滑映射到最接近的高阶档位
local function ApproximateTier(val)
    if not val or type(val) ~= "number" then return TARGET_TIERS[2] end
    for _, tier in ipairs(TARGET_TIERS) do
        if val <= tier then
            return tier
        end
    end
    return TARGET_TIERS[#TARGET_TIERS]
end

-- 全局实体切面拦截 (高性能短路设计)
AddPrefabPostInitAny(function(inst)
    -- 仅服务端执行，客机依赖网络同步
    if not GLOBAL.TheWorld.ismastersim then return end

    local stackable = inst.components.stackable
    -- 核心性能守门员：90% 的实体没有 stackable，立即短路返回
    if stackable == nil then return end

    local current = stackable.maxsize
    local target = ApproximateTier(current)

    if target and target ~= current then
        stackable.maxsize = target
    end
end)
```

---

## 三、避坑与生产安全准则

1. **`AddPrefabPostInitAny` 性能陷阱**：
   - 绝不要在 `AddPrefabPostInitAny` 回调内执行 `TheSim:FindEntities`、字符串拼接、复杂正则表达式或大表遍历。实体生成每秒可能触发数十次，必须通过首行的 `if inst.components.xxx == nil then return end` 毫秒级退出。
2. **`replica` 客户端显示对齐**：
   - 饥荒的 `stackable` 组件在主客机同步时，`replica.stackable:MaxSize()` 会自动拉取服务端的最新容量。无需在客户端手动再去 Hook `replica`，避免引发客户端本地与网络包的状态竞争（Race Condition）。


## 五、进阶拓扑演进与变体分支

### 变体演进：Personal Chesters (Mod 463740026)
- **变体场景与切面**：收录来自工坊 Mod 463740026 (`Personal Chesters`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 463740026)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:personal_chester_eyebone
AddPrefabPostInit("personal_chester_eyebone", function(inst)
	inst.prefab = "chester_eyebone"
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:personal_chester
AddPrefabPostInit("personal_chester", function(inst)
	inst.prefab = "chester"
end)

```



### 变体演进：Save Equipment Slots (Mod 1598084686)
- **变体场景与切面**：收录来自工坊 Mod 1598084686 (`Save Equipment Slots`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1598084686)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:inventory
AddComponentPostInit("inventory", function(inventory)
    -- AddPlayerPostInit triggers after Inventory.OnLoad
    -- so we use AddComponentPostInit for this specific one
    if type(inventory.OnLoad) == "function" then
      inventory.OnLoad = fn.Inventory_OnLoad(inventory.OnLoad)
    end
  end)

  AddClassPostConstruct("widgets/inventorybar", fn.InitInventorybar)

  AddClassPostConstruct("widgets/invslot", function(invslot)
    fn.OnNextCycle(function()
      fn.RenderSlotIcons(invslot.num)
    end)
  end)

  fn.InitPlayerHud()
  fn.InitClasses()
  fn.InitConfig()
end

```



### 变体演进：Item Auto-Fuel Slots (Mod 2736043172)
- **变体场景与切面**：收录来自工坊 Mod 2736043172 (`Item Auto-Fuel Slots`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2736043172)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:lantern
AddPrefabPostInit("lantern", function(inst)
        local function OnTick(inst)
            if inst.components.container and inst.components.container:GetItemInSlot(1) then
                local owner = inst.components.inventoryitem.owner

                local fueltogive = inst.components.container:GetItemInSlot(1).components.fuel.fuelvalue
                local currentfuel = inst.components.fueled.currentfuel
                local maxfuel = inst.components.fueled.maxfuel

                if (maxfuel - currentfuel) > fueltogive then
                    local fuelitem = inst.components.container:GetItemInSlot(1).components.stackable:Get(1)
                    inst.components.fueled:TakeFuelItem(fuelitem, owner)
                end
            end
        end

        local function OnEquip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
        end

        local function OnUnequip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
        end
        
        -- Start Container stuff ---------
        local containers = GLOBAL.require("containers")
        params = containers.params

        params.lantern_inv =
        {
            widget =
            {
                slotpos =
                {
                    GLOBAL.Vector3(0,   32 + 4,  0),
                },
                animbank = "ui_cookpot_1x2",
                animbuild = "ui_cookpot_1x2",
                pos = GLOBAL.Vector3(0, 15, 0),
            },
            usespecificslotsforitems = true,
            type = "hand_inv",
        }
        
        function params.lantern_inv.itemtestfn(container, item, slot)
            return item:HasTag("cavefuel") -- Tag added by this mod, not in vanilla.
        end
        -- End Container -------
        

        if not GLOBAL.TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) 
                inst.replica.container:WidgetSetup("lantern_inv") 
            end

            return
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("lantern_inv")
        inst.components.container.canbeopened = false

        if TUNING.AFS_PERISH ~= 1 then
            inst:AddComponent("preserver")
            inst.components.preserver:SetPerishRateMultiplier(TUNING.AFS_PERISH)
        end

        inst.tick = inst:DoPeriodicTask(1/TUNING.AFS_RATE, OnTick)

        inst:ListenForEvent("equipped", OnEquip)
        inst:ListenForEvent("unequipped", OnUnequip)
        inst:ListenForEvent("itemget", OnTick)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:minerhat
AddPrefabPostInit("minerhat", function(inst)
        local function OnTick(inst)
            if inst.components.container and inst.components.container:GetItemInSlot(1) then
                local owner = inst.components.inventoryitem.owner

                local fueltogive = inst.components.container:GetItemInSlot(1).components.fuel.fuelvalue
                local currentfuel = inst.components.fueled.currentfuel
                local maxfuel = inst.components.fueled.maxfuel

                if (maxfuel - currentfuel) > fueltogive then
                    local fuelitem = inst.components.container:GetItemInSlot(1).components.stackable:Get(1)
                    inst.components.fueled:TakeFuelItem(fuelitem, owner)
                end
            end
        end

        local function OnEquip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
        end

        local function OnUnequip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
        end
        
        -- Start Container stuff ---------
        local containers = GLOBAL.require("containers")
        params = containers.params

        params.minerhat_inv =
        {
            widget =
            {
                slotpos =
                {
                    GLOBAL.Vector3(0,   32 + 4,  0),
                },
                animbank = "ui_cookpot_1x2",
                animbuild = "ui_cookpot_1x2",
                pos = GLOBAL.Vector3(0, 15, 0),
            },
            usespecificslotsforitems = true,
            type = "head_inv",
        }
        
        function params.minerhat_inv.itemtestfn(container, item, slot)
            return item:HasTag("cavefuel") -- Tag added by this mod, not in vanilla.
        end
        -- End Container -------
        

        if not GLOBAL.TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) 
                inst.replica.container:WidgetSetup("minerhat_inv") 
            end

            return
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("minerhat_inv")
        inst.components.container.canbeopened = false

        if TUNING.AFS_PERISH ~= 1 then
            inst:AddComponent("preserver")
            inst.components.preserver:SetPerishRateMultiplier(TUNING.AFS_PERISH)
        end

        inst.tick = inst:DoPeriodicTask(1/TUNING.AFS_RATE, OnTick)

        inst:ListenForEvent("equipped", OnEquip)
        inst:ListenForEvent("unequipped", OnUnequip)
        inst:ListenForEvent("itemget", OnTick)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:armorskeleton
AddPrefabPostInit("armorskeleton", function(inst)
        local function OnTick(inst)
            if inst.components.container and inst.components.container:GetItemInSlot(1) then
                local owner = inst.components.inventoryitem.owner

                local fueltogive = inst.components.container:GetItemInSlot(1).components.fuel.fuelvalue
                local currentfuel = inst.components.fueled.currentfuel
                local maxfuel = inst.components.fueled.maxfuel

                if (maxfuel - currentfuel) > fueltogive then
                    local fuelitem = inst.components.container:GetItemInSlot(1).components.stackable:Get(1)
                    inst.components.fueled:TakeFuelItem(fuelitem, owner)
                end
            end
        end

        local function OnEquip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
        end

        local function OnUnequip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
        end
        
        -- Start Container stuff ---------
        local containers = GLOBAL.require("containers")
        params = containers.params

        params.armorskel_inv =
        {
            widget =
            {
                slotpos =
                {
                    GLOBAL.Vector3(0,   32 + 4,  0),
                },
                animbank = "ui_cookpot_1x2",
                animbuild = "ui_cookpot_1x2",
                pos = GLOBAL.Vector3(0, 15, 0),
            },
            usespecificslotsforitems = true,
            type = "body_inv",
        }
        
        function params.armorskel_inv.itemtestfn(container, item, slot)
            return item:HasTag("nightmarefuel") -- Tag added by this mod, not in vanilla.
        end
        -- End Container -------
        

        if not GLOBAL.TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) 
                inst.replica.container:WidgetSetup("armorskel_inv") 
            end

            return
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("armorskel_inv")
        inst.components.container.canbeopened = false

        inst.tick = inst:DoPeriodicTask(1/TUNING.AFS_RATE, OnTick)

        inst:ListenForEvent("equipped", OnEquip)
        inst:ListenForEvent("unequipped", OnUnequip)
        inst:ListenForEvent("itemget", OnTick)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:molehat
AddPrefabPostInit("molehat", function(inst)
        local function OnTick(inst)
            if inst.components.container and inst.components.container:GetItemInSlot(1) then
                local owner = inst.components.inventoryitem.owner

                local fueltogive = inst.components.container:GetItemInSlot(1).components.fuel.fuelvalue
                local currentfuel = inst.components.fueled.currentfuel
                local maxfuel = inst.components.fueled.maxfuel

                if (maxfuel - currentfuel) > fueltogive then
                    local fuelitem = inst.components.container:GetItemInSlot(1).components.stackable:Get(1)
                    inst.components.fueled:TakeFuelItem(fuelitem, owner)
                end
            end
        end

        local function OnEquip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
        end

        local function OnUnequip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
        end
        
        -- Start Container stuff ---------
        local containers = GLOBAL.require("containers")
        params = containers.params

        params.moggles_inv =
        {
            widget =
            {
                slotpos =
                {
                    GLOBAL.Vector3(0,   32 + 4,  0),
                },
                animbank = "ui_cookpot_1x2",
                animbuild = "ui_cookpot_1x2",
                pos = GLOBAL.Vector3(0, 15, 0),
            },
            usespecificslotsforitems = true,
            type = "head_inv",
        }
        
        function params.moggles_inv.itemtestfn(container, item, slot)
            return item:HasTag("wormfuel") -- Tag added by this mod, not in vanilla.
        end
        -- End Container -------
        

        if not GLOBAL.TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) 
                inst.replica.container:WidgetSetup("moggles_inv") 
            end

            return
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("moggles_inv")
        inst.components.container.canbeopened = false

        if TUNING.AFS_PERISH ~= 1 then
            inst:AddComponent("preserver")
            inst.components.preserver:SetPerishRateMultiplier(TUNING.AFS_PERISH)
         end

        inst.tick = inst:DoPeriodicTask(1/TUNING.AFS_RATE, OnTick)

        inst:ListenForEvent("equipped", OnEquip)
        inst:ListenForEvent("unequipped", OnUnequip)
        inst:ListenForEvent("itemget", OnTick)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shieldofterror
AddPrefabPostInit("shieldofterror", function(inst)
        -- different ontick function for the shield, since it doesn't use the same system for durability as the other items covered in this mod
        local function OnTick(inst) 
            if inst.components.container and inst.components.container:GetItemInSlot(1) then
                local owner = inst.components.inventoryitem.owner
                local food = inst.components.container:GetItemInSlot(1)
                -- inst is shield

                if not food.components.edible then
                    return -- return if we aren't edible somehow
                end

                local armortogive = math.abs((food.components.edible.healthvalue * 4)) + math.abs((food.components.edible.hungervalue * 1.75))
                local currentarmor = inst.components.armor.condition
                local maxarmor = inst.components.armor.maxcondition

                if (maxarmor - currentarmor) > armortogive then
                    inst.components.eater:Eat(food, owner)
                end
            end
        end

        local function OnEquip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Open(owner)
            end
        end

        local function OnUnequip(inst, data)
            local owner = data.owner
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
        end
        
        -- Start Container stuff ---------
        local containers = GLOBAL.require("containers")
        params = containers.params

        params.shieldofterror_inv =
        {
            widget =
            {
                slotpos =
                {
                    GLOBAL.Vector3(0,   32 + 4,  0),
                },
                animbank = "ui_cookpot_1x2",
                animbuild = "ui_cookpot_1x2",
                pos = GLOBAL.Vector3(0, 15, 0),
            },
            usespecificslotsforitems = true,
            type = "hand_inv",
        }
        
        function params.shieldofterror_inv.itemtestfn(container, item, slot)
            for k, v in pairs(GLOBAL.FOODTYPE) do
                if item:HasTag("edible_"..v) then
                    return true
                end
            end

            return false
        end
        -- End Container -------
        

        if not GLOBAL.TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) 
                inst.replica.container:WidgetSetup("shieldofterror_inv") 
            end

            return
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("shieldofterror_inv")
        inst.components.container.canbeopened = false

        if TUNING.AFS_PERISH ~= 1 then
            inst:AddComponent("preserver")
            inst.components.preserver:SetPerishRateMultiplier(TUNING.AFS_PERISH)
        end

        inst.tick = inst:DoPeriodicTask(1/TUNING.AFS_RATE, OnTick)

        inst:ListenForEvent("equipped", OnEquip)
        inst:ListenForEvent("unequipped", OnUnequip)
        inst:ListenForEvent("itemget", OnTick)
        -- armordamaged added for improved visual feedback
        inst:ListenForEvent("armordamaged", OnTick)
    end)

```



### 变体演进：25 / 46 Inventory Slots (Mod 3710538435)
- **变体场景与切面**：收录来自工坊 Mod 3710538435 (`25 / 46 Inventory Slots`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3710538435)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:inventory_classified
AddPrefabPostInit("inventory_classified", AddItemSlotNetvarsInInventory)

local HUD_ATLAS = "images/hud.xml"
local W = 64
local SEP = 7
local INTERSEP = 15

--------------------------------------------------
-- WX-78 backup body container layout compatibility
-- Make the backup body use a real 25 / 46 / 47-slot container widget.
--------------------------------------------------

local function BuildCenteredRowSlotPositions(slotpos, slots, y, spacing)
    if slotpos == nil or slots == nil then
        return
    end

    local count = #slots
    if count <= 0 then
        return
    end

    local start_x = -((count - 1) * spacing) * 0.5
    for index, slot in ipairs(slots) do
        slotpos[slot] = Vector3(start_x + (index - 1) * spacing, y, 0)
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beefalo
AddPrefabPostInit("beefalo", function(inst)
    if _G.TheWorld ~= nil and _G.TheWorld.ismastersim then
        _G.rawget(_G, "TIDY2546_BEEF_BELL_GUARD"):InstallBeefaloPrefabPatch(inst)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wx78_backupbody
AddPrefabPostInit("wx78_backupbody", ConfigureWX78BackupBodyContainer)


--------------------------------------------------
-- WX-78 stacksize circuit inventory container sync
-- Fixes duplicate disabled wx78_inventorycontainer items after backup body swaps.
--------------------------------------------------

local WX78_STACKSIZE_MODULE_PREFAB = "wx78module_stacksize"
local WX78_STACKSIZE_CONTAINER_PREFAB = "wx78_inventorycontainer"

local function IsWX78StacksizeContainer(item)
    return item ~= nil and item.prefab == WX78_STACKSIZE_CONTAINER_PREFAB
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wx78_possessedbody
AddPrefabPostInit("wx78_possessedbody", InstallWX78StacksizeContainerSync)

AddComponentPostInit("upgrademoduleowner", function(self)
    local PushModule_base = self.PushModule
    if PushModule_base ~= nil and self._tidy_wx78_pushmodule_wrapped ~= true then
        self._tidy_wx78_pushmodule_wrapped = true
        self.PushModule = function(owner_self, ...)
            local result = PushModule_base(owner_self, ...)
            if owner_self.inst ~= nil
                and owner_self.is_swapping ~= true
                and owner_self.inst._backupbody_transferring ~= true then
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0)
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0.2)
            end
            return result
        end
    end

    local PopModule_base = self.PopModule
    if PopModule_base ~= nil and self._tidy_wx78_popmodule_wrapped ~= true then
        self._tidy_wx78_popmodule_wrapped = true
        self.PopModule = function(owner_self, ...)
            local result = PopModule_base(owner_self, ...)
            if owner_self.inst ~= nil
                and owner_self.is_swapping ~= true
                and owner_self.inst._backupbody_transferring ~= true then
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0)
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0.2)
            end
            return result
        end
    end

    local SwapUpgradeModules_base = self.SwapUpgradeModules
    if SwapUpgradeModules_base ~= nil and self._tidy_wx78_swapmodules_wrapped ~= true then
        self._tidy_wx78_swapmodules_wrapped = true
        self.SwapUpgradeModules = function(owner_self, other_owner, ...)
            local result = SwapUpgradeModules_base(owner_self, other_owner, ...)
            if owner_self.inst ~= nil then
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0)
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0.2)
            end
            if other_owner ~= nil and other_owner.inst ~= nil then
                ScheduleWX78StacksizeContainerSync(other_owner.inst, 0)
                ScheduleWX78StacksizeContainerSync(other_owner.inst, 0.2)
            end
            return result
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:upgrademoduleowner
AddComponentPostInit("upgrademoduleowner", function(self)
    local PushModule_base = self.PushModule
    if PushModule_base ~= nil and self._tidy_wx78_pushmodule_wrapped ~= true then
        self._tidy_wx78_pushmodule_wrapped = true
        self.PushModule = function(owner_self, ...)
            local result = PushModule_base(owner_self, ...)
            if owner_self.inst ~= nil
                and owner_self.is_swapping ~= true
                and owner_self.inst._backupbody_transferring ~= true then
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0)
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0.2)
            end
            return result
        end
    end

    local PopModule_base = self.PopModule
    if PopModule_base ~= nil and self._tidy_wx78_popmodule_wrapped ~= true then
        self._tidy_wx78_popmodule_wrapped = true
        self.PopModule = function(owner_self, ...)
            local result = PopModule_base(owner_self, ...)
            if owner_self.inst ~= nil
                and owner_self.is_swapping ~= true
                and owner_self.inst._backupbody_transferring ~= true then
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0)
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0.2)
            end
            return result
        end
    end

    local SwapUpgradeModules_base = self.SwapUpgradeModules
    if SwapUpgradeModules_base ~= nil and self._tidy_wx78_swapmodules_wrapped ~= true then
        self._tidy_wx78_swapmodules_wrapped = true
        self.SwapUpgradeModules = function(owner_self, other_owner, ...)
            local result = SwapUpgradeModules_base(owner_self, other_owner, ...)
            if owner_self.inst ~= nil then
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0)
                ScheduleWX78StacksizeContainerSync(owner_self.inst, 0.2)
            end
            if other_owner ~= nil and other_owner.inst ~= nil then
                ScheduleWX78StacksizeContainerSync(other_owner.inst, 0)
                ScheduleWX78StacksizeContainerSync(other_owner.inst, 0.2)
            end
            return result
        end
    end
end)

```



### 变体演进：Beefalo Storage (Mod 2519350133)
- **变体场景与切面**：收录来自工坊 Mod 2519350133 (`Beefalo Storage`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2519350133)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beefalo
AddPrefabPostInit("beefalo", BeefaloWidget)

local function AddTag(inst)
	inst:AddTag("healer")
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:bandage
AddPrefabPostInit("bandage", AddTag)
AddPrefabPostInit("healingsalve", AddTag)
AddPrefabPostInit("mosquitosack", AddTag)
AddPrefabPostInit("spidergland", AddTag)
AddPrefabPostInit("lifeinjector", AddTag)

local cant_eat =
{	
	-- Mineral
	"flint",
	"goldnugget",
	"rocks",
	"nitre",
	"saltrock",
	"moonrocknugget",
	"moonglass",
	"moonglass_charged",
	"thulecite",
	"thulecite_pieces",
	"dreadstone",
	-- Gems crafting
	"bluegem",
	"redgem",
	"purplegem",
	"yellowgem",
	"greengem",
	"orangegem",
	"opalpreciousgem",
	"bluemooneye",
	"greenmooneye",
	"redmooneye",
	"orangemooneye",
	"purplemooneye",
	"yellowmooneye",
	-- Veggie
	"red_cap",
	"red_cap_cooked",
	"blue_cap",
	"blue_cap_cooked",
	"green_cap",
	"green_cap_cooked",
	"moon_cap",
	"moon_cap_cooked",
	-- Seed
	"pinecone",
	"acorn",
	"acorn_cooked",
	"carrot_seeds",
	"corn_seeds",
	"dragonfruit_seeds",
	"durian_seeds",
	"eggplant_seeds",
	"pomegranate_seeds",
	"pumpkin_seeds",
	"watermelon_seeds",
	"asparagus_seeds",
	"tomato_seeds",
	"potato_seeds",
	"onion_seeds",
	"pepper_seeds",
	"garlic_seeds",
	--walter ammo
	"slingshotammo_rock",
	"slingshotammo_gold",
	"slingshotammo_marble",
	"slingshotammo_poop",
	"slingshotammo_freeze",
	"slingshotammo_slow",
	"slingshotammo_thulecite",
	--other
	"pigskin",
	"manrabbit_tail",
	"papyrus",
	"dustmeringue",
	"deerclops_eyeball",
	"lightbulb",
	"ice",
	"honey",
	"goatmilk",
	"royal_jelly",
	"foliage",
	"petals_evil",
	"succulent_picked",
}
-- CODE from Serpens 
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- Add click action if player holding a beefalo foodtype
	if target.prefab == "beefalo" then
        for k, v in pairs(GLOBAL.FOODTYPE) do
			if right and inst:HasTag("edible_"..v) and target:HasTag(v.."_eater") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- remove store action in right click
            end
        end
		if right and inst:HasTag("healer") and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- 
		end
		for k, v in pairs(cant_eat) do
			if not right and inst.prefab == v and target:HasTag("beefalo") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE) -- remove give action in left click
            end
        end
		--[[if not right and inst.prefab == "flint" and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE)
		end]]--
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:healingsalve
AddPrefabPostInit("healingsalve", AddTag)
AddPrefabPostInit("mosquitosack", AddTag)
AddPrefabPostInit("spidergland", AddTag)
AddPrefabPostInit("lifeinjector", AddTag)

local cant_eat =
{	
	-- Mineral
	"flint",
	"goldnugget",
	"rocks",
	"nitre",
	"saltrock",
	"moonrocknugget",
	"moonglass",
	"moonglass_charged",
	"thulecite",
	"thulecite_pieces",
	"dreadstone",
	-- Gems crafting
	"bluegem",
	"redgem",
	"purplegem",
	"yellowgem",
	"greengem",
	"orangegem",
	"opalpreciousgem",
	"bluemooneye",
	"greenmooneye",
	"redmooneye",
	"orangemooneye",
	"purplemooneye",
	"yellowmooneye",
	-- Veggie
	"red_cap",
	"red_cap_cooked",
	"blue_cap",
	"blue_cap_cooked",
	"green_cap",
	"green_cap_cooked",
	"moon_cap",
	"moon_cap_cooked",
	-- Seed
	"pinecone",
	"acorn",
	"acorn_cooked",
	"carrot_seeds",
	"corn_seeds",
	"dragonfruit_seeds",
	"durian_seeds",
	"eggplant_seeds",
	"pomegranate_seeds",
	"pumpkin_seeds",
	"watermelon_seeds",
	"asparagus_seeds",
	"tomato_seeds",
	"potato_seeds",
	"onion_seeds",
	"pepper_seeds",
	"garlic_seeds",
	--walter ammo
	"slingshotammo_rock",
	"slingshotammo_gold",
	"slingshotammo_marble",
	"slingshotammo_poop",
	"slingshotammo_freeze",
	"slingshotammo_slow",
	"slingshotammo_thulecite",
	--other
	"pigskin",
	"manrabbit_tail",
	"papyrus",
	"dustmeringue",
	"deerclops_eyeball",
	"lightbulb",
	"ice",
	"honey",
	"goatmilk",
	"royal_jelly",
	"foliage",
	"petals_evil",
	"succulent_picked",
}
-- CODE from Serpens 
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- Add click action if player holding a beefalo foodtype
	if target.prefab == "beefalo" then
        for k, v in pairs(GLOBAL.FOODTYPE) do
			if right and inst:HasTag("edible_"..v) and target:HasTag(v.."_eater") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- remove store action in right click
            end
        end
		if right and inst:HasTag("healer") and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- 
		end
		for k, v in pairs(cant_eat) do
			if not right and inst.prefab == v and target:HasTag("beefalo") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE) -- remove give action in left click
            end
        end
		--[[if not right and inst.prefab == "flint" and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE)
		end]]--
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:mosquitosack
AddPrefabPostInit("mosquitosack", AddTag)
AddPrefabPostInit("spidergland", AddTag)
AddPrefabPostInit("lifeinjector", AddTag)

local cant_eat =
{	
	-- Mineral
	"flint",
	"goldnugget",
	"rocks",
	"nitre",
	"saltrock",
	"moonrocknugget",
	"moonglass",
	"moonglass_charged",
	"thulecite",
	"thulecite_pieces",
	"dreadstone",
	-- Gems crafting
	"bluegem",
	"redgem",
	"purplegem",
	"yellowgem",
	"greengem",
	"orangegem",
	"opalpreciousgem",
	"bluemooneye",
	"greenmooneye",
	"redmooneye",
	"orangemooneye",
	"purplemooneye",
	"yellowmooneye",
	-- Veggie
	"red_cap",
	"red_cap_cooked",
	"blue_cap",
	"blue_cap_cooked",
	"green_cap",
	"green_cap_cooked",
	"moon_cap",
	"moon_cap_cooked",
	-- Seed
	"pinecone",
	"acorn",
	"acorn_cooked",
	"carrot_seeds",
	"corn_seeds",
	"dragonfruit_seeds",
	"durian_seeds",
	"eggplant_seeds",
	"pomegranate_seeds",
	"pumpkin_seeds",
	"watermelon_seeds",
	"asparagus_seeds",
	"tomato_seeds",
	"potato_seeds",
	"onion_seeds",
	"pepper_seeds",
	"garlic_seeds",
	--walter ammo
	"slingshotammo_rock",
	"slingshotammo_gold",
	"slingshotammo_marble",
	"slingshotammo_poop",
	"slingshotammo_freeze",
	"slingshotammo_slow",
	"slingshotammo_thulecite",
	--other
	"pigskin",
	"manrabbit_tail",
	"papyrus",
	"dustmeringue",
	"deerclops_eyeball",
	"lightbulb",
	"ice",
	"honey",
	"goatmilk",
	"royal_jelly",
	"foliage",
	"petals_evil",
	"succulent_picked",
}
-- CODE from Serpens 
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- Add click action if player holding a beefalo foodtype
	if target.prefab == "beefalo" then
        for k, v in pairs(GLOBAL.FOODTYPE) do
			if right and inst:HasTag("edible_"..v) and target:HasTag(v.."_eater") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- remove store action in right click
            end
        end
		if right and inst:HasTag("healer") and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- 
		end
		for k, v in pairs(cant_eat) do
			if not right and inst.prefab == v and target:HasTag("beefalo") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE) -- remove give action in left click
            end
        end
		--[[if not right and inst.prefab == "flint" and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE)
		end]]--
    end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:spidergland
AddPrefabPostInit("spidergland", AddTag)
AddPrefabPostInit("lifeinjector", AddTag)

local cant_eat =
{	
	-- Mineral
	"flint",
	"goldnugget",
	"rocks",
	"nitre",
	"saltrock",
	"moonrocknugget",
	"moonglass",
	"moonglass_charged",
	"thulecite",
	"thulecite_pieces",
	"dreadstone",
	-- Gems crafting
	"bluegem",
	"redgem",
	"purplegem",
	"yellowgem",
	"greengem",
	"orangegem",
	"opalpreciousgem",
	"bluemooneye",
	"greenmooneye",
	"redmooneye",
	"orangemooneye",
	"purplemooneye",
	"yellowmooneye",
	-- Veggie
	"red_cap",
	"red_cap_cooked",
	"blue_cap",
	"blue_cap_cooked",
	"green_cap",
	"green_cap_cooked",
	"moon_cap",
	"moon_cap_cooked",
	-- Seed
	"pinecone",
	"acorn",
	"acorn_cooked",
	"carrot_seeds",
	"corn_seeds",
	"dragonfruit_seeds",
	"durian_seeds",
	"eggplant_seeds",
	"pomegranate_seeds",
	"pumpkin_seeds",
	"watermelon_seeds",
	"asparagus_seeds",
	"tomato_seeds",
	"potato_seeds",
	"onion_seeds",
	"pepper_seeds",
	"garlic_seeds",
	--walter ammo
	"slingshotammo_rock",
	"slingshotammo_gold",
	"slingshotammo_marble",
	"slingshotammo_poop",
	"slingshotammo_freeze",
	"slingshotammo_slow",
	"slingshotammo_thulecite",
	--other
	"pigskin",
	"manrabbit_tail",
	"papyrus",
	"dustmeringue",
	"deerclops_eyeball",
	"lightbulb",
	"ice",
	"honey",
	"goatmilk",
	"royal_jelly",
	"foliage",
	"petals_evil",
	"succulent_picked",
}
-- CODE from Serpens 
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- Add click action if player holding a beefalo foodtype
	if target.prefab == "beefalo" then
        for k, v in pairs(GLOBAL.FOODTYPE) do
			if right and inst:HasTag("edible_"..v) and target:HasTag(v.."_eater") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- remove store action in right click
            end
        end
		if right and inst:HasTag("healer") and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.STORE) -- 
		end
		for k, v in pairs(cant_eat) do
			if not right and inst.prefab == v and target:HasTag("beefalo") then
				GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE) -- remove give action in left click
            end
        end
		--[[if not right and inst.prefab == "flint" and target:HasTag("beefalo") then
			GLOBAL.RemoveByValue(actions, GLOBAL.ACTIONS.GIVE)
		end]]--
    end

```

