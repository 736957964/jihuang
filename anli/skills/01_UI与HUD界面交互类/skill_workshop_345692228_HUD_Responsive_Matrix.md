# 饥荒一线工坊深度研读 Skill：HUD 矩阵反缩放自适应与视口输入隔离机制

- **工坊 ID**：345692228 (`Minimap HUD`)
- **领域分类**：客户端 UI 工程、HUD 矩阵逆缩放坐标系对齐、窗口动态重排、摄像机与输入冲突隔离
- **研读基准**：Steam 创意工坊在线原版源码

在开发饥荒联机版的悬浮窗口、状态栏或雷达时，开发者常面临：
1. 玩家调整了游戏系统设置中的 **HUD 缩放比例**，导致控件溢出屏幕边缘；
2. 玩家**拖动窗口边框**或在全屏/无边框窗口间切换，UI 错位；
3. 鼠标悬停在 UI 上滚动滚轮，误触发游戏视角拉近拉远。

`Minimap HUD` 提炼了一套纯数学且极其轻量的防御框架。

```lua
-- ==============================================================================
-- ==============================================================================

local Widget = require "widgets/widget"

local ResponsiveContainer = Class(Widget, function(self, owner)
  Widget._ctor(self, "ResponsiveContainer")
  self.owner = owner
  self.camera_lock = false
end)

function ResponsiveContainer:Reposition(controls, align_x, align_y, margin_x, margin_y)
  local hudscale = controls.top_root:GetScale()
  local screenw_full, screenh_full = GLOBAL.TheSim:GetScreenSize()
  
  local screenw = screenw_full / hudscale.x
  local screenh = screenh_full / hudscale.y

  local target_x = 0
  local target_y = 0

  if align_x == "right" then
      target_x = (screenw * 0.5) - margin_x
  elseif align_x == "left" then
      target_x = -(screenw * 0.5) + margin_x
  end

  if align_y == "top" then
      target_y = (screenh * 0.5) - margin_y
  elseif align_y == "bottom" then
      target_y = -(screenh * 0.5) + margin_y
  end

  self:SetPosition(target_x, target_y, 0)
end

function ResponsiveContainer:OnGainFocus()
  ResponsiveContainer._base.OnGainFocus(self)
  if GLOBAL.TheCamera and GLOBAL.TheCamera:IsControllable() then
      self.camera_lock = true
      GLOBAL.TheCamera:SetControllable(false)
  end
end

function ResponsiveContainer:OnLoseFocus()
  ResponsiveContainer._base.OnLoseFocus(self)
  if self.camera_lock and GLOBAL.TheCamera then
      GLOBAL.TheCamera:SetControllable(true)
      self.camera_lock = false
  end
end

function ResponsiveContainer:OnControl(control, down)
  if ResponsiveContainer._base.OnControl(self, control, down) then return true end
  if control == GLOBAL.CONTROL_MAP_ZOOM_IN or control == GLOBAL.CONTROL_MAP_ZOOM_OUT then
      return true
  end
  return false
end

return ResponsiveContainer
end
end
```

1. **`OnLoseFocus` 必须兜底防漏**：
   - 如果用户在悬停该 UI 的瞬间按下了 ESC 键切出菜单，或者切回桌面，可能会跳过 `OnLoseFocus`。建议在控件的 `Kill` 和 `Hide` 方法中，同样加入对 `TheCamera:SetControllable(true)` 的安全恢复调用，防止玩家摄像机被永久锁死。
2. **`controls.OnUpdate` 增量轻量比较**：
   - 监听窗口分辨率变化时，切忌每帧去调用复杂的布局计算。只在 `w ~= last_w or h ~= last_h` 时才触发一次 `Reposition`。

## 五、进阶拓扑演进与变体分支

### 变体演进：Minecraft HUD (Mod 3649427234)
- **变体场景与切面**：收录来自工坊 Mod 3649427234 (`Minecraft HUD`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)
```

### 变体演进：keep_hud_ui (Mod 2056032273)
- **变体场景与切面**：收录来自工坊 Mod 2056032273 (`keep_hud_ui`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:colourcube
AddComponentPostInit("colourcube", function(self, inst)
  if GetModConfigData("autumn_cc_only") and not inst:HasTag("cave") then
      inst:PushEvent("overridecolourcube", "images/colour_cubes/day05_cc.tex")
  end

  for _, fn in ipairs(TheWorld.event_listeners["playeractivated"][TheWorld]) do
      local OnSanityDelta = UpvalueUtil.GetUpvalue(fn, "OnSanityDelta")
      if OnSanityDelta then
          UpvalueUtil.SetUpvalue(fn, "OnSanityDelta", function(player, data)
              local easing = require("easing")
              PostProcessor:SetColourCubeLerp(1, 0)
              PostProcessor:SetDistortionFactor(1)
              UpvalueUtil.SetUpvalue(OnSanityDelta, "_fxspeed", easing.outQuad(0, 0, .2, 1))
end)
      end
  end
end)
```

### 变体演进：[DST] Nautical HUD (Mod 2226345952)
- **变体场景与切面**：收录来自工坊 Mod 2226345952 (`[DST] Nautical HUD`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)
```

### 变体演进：[DST] Archive HUD (Mod 3456159081)
- **变体场景与切面**：收录来自工坊 Mod 3456159081 (`[DST] Archive HUD`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)
```

### 变体演进：[DST] Mystery HUD (Mod 3548608555)
- **变体场景与切面**：收录来自工坊 Mod 3548608555 (`[DST] Mystery HUD`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player
AddPrefabPostInit("player", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", BadgePostConstruct)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if GLOBAL.softresolvefilepath("scripts/widgets/minibadge.lua") then
		AddClassPostConstruct("widgets/minibadge", WetBadgePostConstruct)
	end
end)
```

### 变体演进：DST Auto. Factories (Mod 2797957878)
- **变体场景与切面**：收录来自工坊 Mod 2797957878 (`DST Auto. Factories`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2797957878)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:mushroom_farm
AddPrefabPostInit("mushroom_farm", function(inst)
   inst._workingtask = inst:DoPeriodicTask(10,MushroomFarm)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beebox
AddPrefabPostInit("beebox", function(inst)
   inst._workingtask = inst:DoPeriodicTask(10,BeeBox)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:medal_beebox
AddPrefabPostInit("medal_beebox", function(inst)
   inst._workingtask = inst:DoPeriodicTask(10,BeeBox)
end)
```

### 变体演进：妥善换装与自动续装（本地稳定修正版） / Proper Switching & Auto Re-Equip (Local Stable Fix) (Mod 3785718996)
- **变体场景与切面**：收录来自工坊 Mod 3785718996 (`妥善换装与自动续装（本地稳定修正版） / Proper Switching & Auto Re-Equip (Local Stable Fix)`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3785718996)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
AddComponentPostInit("playercontroller", function(self)
  if self.inst ~= GLOBAL.ThePlayer then
      return
  end
  local old_OnRemoveFromEntity = self.OnRemoveFromEntity
  if not self.ismastersim then
      self.inst:DoTaskInTime(0, initialize_client)
      self.OnRemoveFromEntity = function(self, ...)
          ClientRemoveEventCallbacks(self.inst)
          return old_OnRemoveFromEntity(self, ...)
      end

  else
      self.inst:DoTaskInTime(0, initialize_equips) -- may also use same client side logic with unequip update delayed, but below ComponentPostInit is better
      self.inst:ListenForEvent("equip", OnEquip)
      self.inst:ListenForEvent("unequip", OnUnequip)
      self.OnRemoveFromEntity = function(self, ...)
          self.inst:RemoveEventCallback("equip", OnEquip)
          self.inst:RemoveEventCallback("unequip", OnUnequip)
          return old_OnRemoveFromEntity(self, ...)
      end

  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory
AddComponentPostInit("inventory", function(self) --for hosting cave-less worlds without affecting other players, or Don't Starve Alone mod
  local world = GLOBAL.TheWorld
  if world == nil or not world.ismastersim then
      return
  end
	local old_Equip = self.Equip
	self.Equip = function(self, item, old_to_active, ...)
      if item == nil or item.components == nil or item.components.equippable == nil or
         item.components.inventoryitem == nil or not item:IsValid() or
         item.components.equippable:IsRestricted(self.inst) or
         (self.noheavylifting and item:HasTag("heavy")) then
          return old_Equip(self, item, old_to_active, ...)
      end

      local player = GLOBAL.ThePlayer
      local player_inventory = player and player.components and player.components.inventory
      if player_inventory == nil then
          return old_Equip(self, item, old_to_active, ...)
      end

      local owner = item.components.inventoryitem.owner
      local container = owner and owner.components and owner.components.container
      local overflow_container = player_inventory:GetOverflowContainer()

      if owner ~= player and --Inventory:Equip patch modification fires only when the item to equip is already held by ThePlayer
         container ~= overflow_container then
          return old_Equip(self, item, old_to_active, ...)
      end
      local prevslot = self:GetItemSlot(item)
      local prevcontainer = nil
      if prevslot == nil and container ~= nil then
          prevslot = container:GetItemSlot(item)
          prevcontainer = container
      end

      local eslot = item.components.equippable.equipslot
      local olditem = self:GetEquippedItem(eslot)
      local leftovers_condition = item.components.stackable ~= nil and item.components.stackable:IsStack() and not item.components.equippable.equipstack
      --checking mid-Equip if prevslot is occupied is better, but impossible via function patching

      if olditem ~= nil and not leftovers_condition and not old_to_active then
          local cant_hold_olditem = olditem.components.inventoryitem~=nil and not olditem.components.inventoryitem.cangoincontainer and not self.ignorescangoincontainer
          if not cant_hold_olditem then
              olditem.prevslot = prevslot
              olditem.prevcontainer = prevcontainer
          end
      end

		return old_Equip(self, item, old_to_active, ...)
	end
end)
```

### 变体演进：Better Equipment (Mod 3785105068)
- **变体场景与切面**：收录来自工坊 Mod 3785105068 (`Better Equipment`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3785105068)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:lantern
AddPrefabPostInit("lantern", function(inst)
  IncreaseFuelCapacity(inst, 20)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:minerhat
AddPrefabPostInit("minerhat", function(inst)
  IncreaseFuelCapacity(inst, 10)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cane
AddPrefabPostInit("cane", function(inst)
  local function ApplyDamage()
      if inst.components.weapon == nil then
          inst:AddComponent("weapon")
      end
      inst.components.weapon:SetDamage(WALKING_CANE_DAMAGE)
  end

  ApplyDamage()
  function inst:OnLoad(data, newents)
      ApplyDamage()
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:icestaff
AddPrefabPostInit("icestaff", function(inst)
  local function ApplyStats()
      -- 伤害
      if inst.components.weapon ~= nil then
          inst.components.weapon:SetDamage(ICE_STAFF_DAMAGE)
      end

      -- 无限耐久
      if inst.components.finiteuses ~= nil then
          inst.components.finiteuses:SetMaxUses(INFINITE_USES)
          inst.components.finiteuses:SetUses(INFINITE_USES)
      end
  end

  ApplyStats()
  function inst:OnLoad(data, newents)
      ApplyStats()
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:spear
AddPrefabPostInit("spear", function(inst)
  if inst.components.weapon == nil then
      inst:AddComponent("weapon")
  end

  function inst:OnSave(data)
      data.rarity_data = self.rarity_data
      return nil
  end

  function inst:OnLoad(data, newents)
      if data and data.rarity_data then
          self.rarity_data = data.rarity_data
          ApplyRandomStats(self)
      end
  end
end)
```

### 变体演进：Auto Unequip (Mod 2970317405)
- **变体场景与切面**：收录来自工坊 Mod 2970317405 (`Auto Unequip`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2970317405)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:inventoryitem_classified
AddPrefabPostInit("inventoryitem_classified", function(inst)
   inst:DoTaskInTime(0, function()
        if inst._parent and ShouldCheck(inst._parent) then
             inst:ListenForEvent("percentuseddirty", function() AutoUnequip(inst) end)
        end
   end)
end)
```

### 变体演进：Aligned Placement 对齐建造 (Mod 2012800429)
- **变体场景与切面**：收录来自工坊 Mod 2012800429 (`Aligned Placement 对齐建造`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2012800429)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
-- AddComponentPostInit("playercontroller", controller.PostInit)

AddComponentPostInit("placer", function(placer)
  controller.SetupFollower(placer)
  placer.OnUpdate = function(self, dt)
      PlacerUpdate(self, dt, Snap, controller)
  end

  placer.inst:ListenForEvent("onremove", function()
      RemoveHilightColors(placer)
  end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:placer
AddComponentPostInit("placer", function(placer)
  controller.SetupFollower(placer)
  placer.OnUpdate = function(self, dt)
      PlacerUpdate(self, dt, Snap, controller)
  end

  placer.inst:ListenForEvent("onremove", function()
      RemoveHilightColors(placer)
  end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:builder
AddComponentPostInit("builder", function(builder)
  local CanBuildAtPoint, MakeRecipe = builder.CanBuildAtPoint, builder.MakeRecipe

  function builder:CanBuildAtPoint(pt, recipe, ...)
      local filter = FILTERS[recipe.name]
      local aligned = SnapToEntities(pt, filter)
      return CanBuildAtPoint(self, aligned, recipe, ...)
  end

  function builder:MakeRecipe(recipe, pt, ...)
      local filter = FILTERS[recipe.name]
      local aligned = SnapToEntities(pt, filter)
      return MakeRecipe(self, recipe, aligned, ...)
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:deployable
AddComponentPostInit("deployable", function(deployable)
  local CanDeploy, Deploy = deployable.CanDeploy, deployable.Deploy
  function deployable:CanDeploy(pt, ...)
      local filter = FILTERS[self.inst.prefab]
      local aligned = SnapToEntities(pt, filter)
      return CanDeploy(self, aligned, ...)
  end

  function deployable:Deploy(pt, deployer, ...)
      local filter = FILTERS[self.inst.prefab]
      local aligned = SnapToEntities(pt, filter)
      return Deploy(self, aligned, deployer, ...)
  end
end)
```


