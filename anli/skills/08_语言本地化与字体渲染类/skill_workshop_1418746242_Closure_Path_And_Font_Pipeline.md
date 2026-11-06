# 饥荒一线工坊深度研读 Skill：点分路径闭包穿透与引擎级字体热载技术

- **工坊 ID**：1418746242 (`Chinese++`)
- **领域分类**：点分路径 Upvalue 访问器（Path-based Upvalue Accessor）、引擎字体原子热重载（TheSim Font Hot-Swap）、正则模板逆向解构、全角字符匹配补丁
- **研读基准**：Steam 创意工坊在线原版源码

在对饥荒底层核心模块（如地图生成、事件台词、原生字体渲染、配置树）进行深层切面改造时，普通的 Hook 手段往往鞭长莫及。`Chinese++` 树立了顶级的元编程标杆：
1. **点分路径穿透器**：用形如 `"manager.cache.registry"` 的路径逐层下钻闭包；
2. **原子化字体注册序列**：`Unload -> RegisterPrefab -> LoadPrefabs -> LoadFont -> SetupFontFallbacks`；
3. **中文模式匹配 `%w` 扩展补丁**。

```lua
-- ==============================================================================
-- ==============================================================================

local ClosurePath = {}
function ClosurePath.Get(start_fn, path)
  if type(start_fn) ~= "function" or type(path) ~= "string" then return nil end

  local current = start_fn
  local parent = nil
  local target_idx = nil

  for segment in string.gmatch(path, "[^%.]+") do
      local i = 1
      local found = false
      while true do
          local name, val = debug.getupvalue(current, i)
          if not name then break end
          if name == segment then
              parent = current
              target_idx = i
              current = val
              found = true
              break
          end
          i = i + 1
      end
      if not found then return nil end
  end

  return current, target_idx, parent
end
function ClosurePath.Set(start_fn, path, new_value)
  local val, idx, parent = ClosurePath.Get(start_fn, path)
  if parent and idx then
      debug.setupvalue(parent, idx, new_value)
      return true
  end
  return false
end

-- ==============================================================================
-- ==============================================================================

local function HotReloadEngineFont(font_zip_path, font_name, font_fallback_table)
  local TheSim = GLOBAL.TheSim
  if not TheSim or GLOBAL.TheNet:IsDedicated() then return end

  TheSim:UnloadFont(font_name)
  TheSim:UnloadPrefabs({ "font_package_" .. font_name })

  local assets = { GLOBAL.Asset("FONT", font_zip_path) }
  TheSim:RegisterPrefab("font_package_" .. font_name, assets, {})
  TheSim:LoadPrefabs({ "font_package_" .. font_name })

  TheSim:LoadFont(font_zip_path, font_name)
  if font_fallback_table then
      TheSim:SetupFontFallbacks(font_name, font_fallback_table)
  end
end

-- ==============================================================================
-- ==============================================================================

local function PatchChinesePatternMatching()
  local old_match = string.match
  string.match = function(str, pattern, index)
      if pattern and string.find(pattern, "%%w") then
          pattern = string.gsub(pattern, "%%w", "[%%w一-鿕]")
      end
      return old_match(str, pattern, index)
  end
end

return {
  ClosurePath = ClosurePath,
  HotReloadEngineFont = HotReloadEngineFont,
  PatchChinesePatternMatching = PatchChinesePatternMatching,
}
end
```

1. **`UnloadFont` 后的 Fallback Table 重新绑定**：
   - 每次调用 `TheSim:LoadFont` 后，必须紧跟 `TheSim:SetupFontFallbacks`。若遗漏回退表设置，当文本中出现特殊标点、希腊字母或冷僻字时，整个字符串会静默变成完全不渲染的空白，极其隐蔽！
2. **点分路径断言防御**：
   - 官方游戏在小版本更新后可能会重命名局部变量。在生产代码中使用 `ClosurePath.Set` 之前，必须对返回值 `parent` 和 `idx` 做严格的 `if parent and idx then` 断言，严禁无检查调用 `debug.setupvalue` 导致游戏在启动阶段死锁。

## 五、进阶拓扑演进与变体分支

### 变体演进：Language (Mod 3671575756)
- **变体场景与切面**：收录来自工坊 Mod 3671575756 (`Language`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3671575756)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wendy
AddPrefabPostInit("wendy", function(inst)
  inst:DoTaskInTime(0, function(inst)	
		--inst.AnimState:SetBuild("wendy_l")
		if GLOBAL.ThePlayer then --inst.myabby then
          SetSkin(GLOBAL.ThePlayer)
      end	
	end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:walter
AddPrefabPostInit("walter", function(inst)
  inst:DoTaskInTime(0, function(inst)	
		inst:DoPeriodicTask(0.02, function(inst)
			--inst.AnimState:SetBuild("wendy_l")
			if inst then --inst.myabby then
				if not inst:HasTag("playerghost")
				then
					inst.AnimState:SetBuild("silencehunter_h")
				end
			end			
		end)	
		inst.soundsname = "wendy"
	end)
end)]]--

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:abigail
AddPrefabPostInit("abigail", function(inst) -- Run fuction PostInit for my sweet abby.
   PostInit(inst)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:lavaarena_abigail_l
AddPrefabPostInit("lavaarena_abigail_l", function(inst) -- Run fuction PostInit for fake abby form shitly forge.
   PostInit(inst)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified
AddPrefabPostInit('player_classified', function (inst)
	if not G.TheNet:IsDedicated() then
		inst:DoTaskInTime(0, function ()
			local player = G.ThePlayer
			hatPostInit(player)
		end)
	end
end)
```

### 变体演进：字体:补丁圆体/Font:Patched Rounded (Mod 3233442083)
- **变体场景与切面**：收录来自工坊 Mod 3233442083 (`字体:补丁圆体/Font:Patched Rounded`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3233442083)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wormwood
AddPrefabPostInit("wormwood",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(135/255, 169/255, 107/255) -- #87A96B Asparagus
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yotb_stage
AddPrefabPostInit("yotb_stage",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(124/255, 185/255, 232/255) -- #7CB9E8 Aero
  end
end)
```

### 变体演进：增加储存空间（汉化） (Mod 3020930104)
- **变体场景与切面**：收录来自工坊 Mod 3020930104 (`增加储存空间（汉化）`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3020930104)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:container_classified
AddPrefabPostInit("container_classified", addItemSlotNetvarsInContainer)

--Change size of Backpacks, Chests, Bundles, and Chester
local widgetsetup_Base = containers.widgetsetup or function() return true end
```

### 变体演进：ANNOUNCE_LANGUAGE (Mod 3358815211)
- **变体场景与切面**：收录来自工坊 Mod 3358815211 (`ANNOUNCE_LANGUAGE`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3358815211)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:ghostlybond
AddComponentPostInit("ghostlybond", function(self)
  if not IsUpgradeMode() then
      return
  end

  self.maxbondlevel = 10

  if self._abigail_power_setbondlevel_patched then
      return
  end
  self._abigail_power_setbondlevel_patched = true

  local old_SetBondLevel = self.SetBondLevel
  function self:SetBondLevel(level, time, isloading)
      self.maxbondlevel = 10
      return old_SetBondLevel(self, level, time, isloading)
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wendy
AddPrefabPostInit("wendy", function(inst)
  local function OnBondLevelDirty()
      if inst.HUD == nil then
          return
      end

      local bond_level = inst._bondlevel ~= nil and inst._bondlevel:value() or 1
      for i = 0, 10 do
          if i ~= 1 then
              inst:SetClientSideInventoryImageOverrideFlag("bondlevel" .. tostring(i), i == bond_level)
          end
      end

      if not inst:HasTag("playerghost") and bond_level > 1 and inst.HUD.wendyflowerover ~= nil then
          inst.HUD.wendyflowerover:Play(math.min(bond_level, 3))
      end
  end

  inst:ListenForEvent("_bondleveldirty", OnBondLevelDirty)
  inst:ListenForEvent("playeractivated", OnBondLevelDirty)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:abigail_flower
AddPrefabPostInit("abigail_flower", function(inst)
	-- 阿比盖尔花 4~10 级用3级的图层
  for i = 4, 10 do
      inst:SetClientSideInventoryImageOverride("bondlevel" .. tostring(i), "abigail_flower.tex", "abigail_flower_level3.tex")
  end

  if not _G.TheWorld.ismastersim then
      return
  end

  if inst.components.inspectable ~= nil then
      inst.components.inspectable.getstatus = function(flower, viewer)
          local level = flower._bond_level
          if flower.components.inventoryitem ~= nil and flower.components.inventoryitem.owner ~= nil then
              level = viewer ~= nil and viewer.components.ghostlybond ~= nil and viewer.components.ghostlybond.bondlevel or 0
          end
          return GetLevelStatus(level)
      end
  end

  inst.drawimageoverride = function(flower)
      local level = flower._bond_level or 0
      local skin_name = flower.GetSkinName ~= nil and (flower:GetSkinName() or "abigail_flower") or "abigail_flower"
      return skin_name .. ((level <= 1) and "" or ("_level" .. tostring(math.min(level, 3))))
  end

  local function RestartGroundTask(flower, random_delay)
      if flower._ongroundupdatetask ~= nil then
          flower._ongroundupdatetask:Cancel()
      end
      flower._bond_level = -1
      UpdateAbigailFlowerAnim(flower)
      flower._ongroundupdatetask = flower:DoPeriodicTask(0.5, UpdateAbigailFlowerAnim, random_delay or math.random() * 0.5)
  end

  local old_OnEntityWake = inst.OnEntityWake
  inst.OnEntityWake = function(flower)
      if old_OnEntityWake ~= nil then
          old_OnEntityWake(flower)
      end
      if not flower.inlimbo then
          RestartGroundTask(flower, math.random() * 0.5)
      end
  end

  local old_OnEntitySleep = inst.OnEntitySleep
  inst.OnEntitySleep = function(flower)
      if old_OnEntitySleep ~= nil then
          old_OnEntitySleep(flower)
      end
      if flower._ongroundupdatetask ~= nil then
          flower._ongroundupdatetask:Cancel()
          flower._ongroundupdatetask = nil
      end
  end

  inst:ListenForEvent("ondropped", function(flower)
      if not flower.inlimbo then
          RestartGroundTask(flower)
      end
  end)

  inst:ListenForEvent("onputininventory", function(flower)
      if flower._ongroundupdatetask ~= nil then
          flower._ongroundupdatetask:Cancel()
          flower._ongroundupdatetask = nil
      end
  end)

  if not inst.inlimbo then
      RestartGroundTask(inst)
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:abigail
AddPrefabPostInit("abigail", function(inst)
  if not _G.TheWorld.ismastersim then
      return
  end

  local old_LinkToPlayer = inst.LinkToPlayer
  inst.LinkToPlayer = function(ghost, player)
      local result = old_LinkToPlayer(ghost, player)

      if ghost._abigail_power_player ~= nil then
          ghost:RemoveEventCallback("ghostlybond_level_change", ghost._abigail_power_on_level_change, ghost._abigail_power_player)
      end

      ghost._abigail_power_player = player
      ghost._abigail_power_on_level_change = ghost._abigail_power_on_level_change or function(_, data)
          local level = data ~= nil and data.level or GetBondLevel(ghost)
          if IsUpgradeMode() then
              ApplyAbigailLevelStats(ghost, level)
          end
          UpdateAbigailDamage(ghost)
      end

      ghost:ListenForEvent("ghostlybond_level_change", ghost._abigail_power_on_level_change, player)

      local current_level = player ~= nil and player.components.ghostlybond ~= nil and player.components.ghostlybond.bondlevel or 1
      if IsUpgradeMode() then
          ApplyAbigailLevelStats(ghost, current_level)
      end
      UpdateAbigailDamage(ghost)

      return result
  end

  inst.UpdateDamage = UpdateAbigailDamage
  inst:WatchWorldState("phase", UpdateAbigailDamage)
  UpdateAbigailDamage(inst)

  if inst.components.inspectable ~= nil then
      inst.components.inspectable.getstatus = function(ghost)
          return GetLevelStatus(GetBondLevel(ghost))
      end
  end

	-- 阿比盖尔每秒回复
  if inst.components.health ~= nil then
      inst.components.health:StartRegen(GetModConfigData("ABIGAIL_REGENAMOUNT"), 1)
  end

	-- 阿比盖尔攻击影怪
  if GetModConfigData("ABIGAIL_CRAZY") and not inst:HasTag("crazy") then
      inst:AddTag("crazy")
      inst._abigail_power_on_entity_death = inst._abigail_power_on_entity_death or function(_, data)
          OnAbigailShadowKill(inst, data)
      end
      inst:ListenForEvent("entity_death", inst._abigail_power_on_entity_death, _G.TheWorld)
      inst:ListenForEvent("onremove", function(ghost)
          if ghost._abigail_power_on_entity_death ~= nil then
              ghost:RemoveEventCallback("entity_death", ghost._abigail_power_on_entity_death, _G.TheWorld)
          end
      end)
  end

	-- 阿比盖尔冬暖夏凉
  if GetModConfigData("ABIGAIL_WINTER_HEATER") or GetModConfigData("ABIGAIL_SUMMER_HEATER") then
      UpdateAbigailHeater(inst)
      inst:WatchWorldState("season", function() UpdateAbigailHeater(inst) end)
  end

	-- 阿比盖尔增加容器
  if GetModConfigData("ABIGAIL_CONTAINER") and inst.components.container == nil then
      inst:AddComponent("container")
      inst.components.container:WidgetSetup("abigail")
  end

	-- 阿比盖尔回san光环
  if GetModConfigData("ABIGAIL_SANITYAURA") and inst.components.sanityaura == nil then
      inst:RemoveTag("ghost")
      inst:AddComponent("sanityaura")
      inst.components.sanityaura.aurafn = function(_, observer)
          if observer.prefab == "wendy" then
              return _G.TUNING.SANITYAURA_SMALL
          end
          return 0
      end
  end
end)
```

### 变体演进：字体:补丁锦黑/Font:Patched JinHei (Mod 3243937568)
- **变体场景与切面**：收录来自工坊 Mod 3243937568 (`字体:补丁锦黑/Font:Patched JinHei`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3243937568)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wormwood
AddPrefabPostInit("wormwood",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(135/255, 169/255, 107/255) -- #87A96B Asparagus
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yotb_stage
AddPrefabPostInit("yotb_stage",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(124/255, 185/255, 232/255) -- #7CB9E8 Aero
  end
end)
```

### 变体演进：字体:补丁宋体/Font:Patched Mincho (Mod 3213841243)
- **变体场景与切面**：收录来自工坊 Mod 3213841243 (`字体:补丁宋体/Font:Patched Mincho`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3213841243)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wormwood
AddPrefabPostInit("wormwood",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(135/255, 169/255, 107/255) -- #87A96B Asparagus
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yotb_stage
AddPrefabPostInit("yotb_stage",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(124/255, 185/255, 232/255) -- #7CB9E8 Aero
  end
end)
```

### 变体演进：language (Mod 3142550624)
- **变体场景与切面**：收录来自工坊 Mod 3142550624 (`language`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3142550624)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:monkeyqueen
AddPrefabPostInit("monkeyqueen", function(inst)
  if not TheWorld.ismastersim then
      return inst
  end
  if SGMonkeyqueen and SGMonkeyqueen.states then
      local old_BLUEPRINT_LOOTS = upvaluehelper.Get(SGMonkeyqueen.states["getitem"].events["animover"].fn, "BLUEPRINT_LOOTS")
      if old_BLUEPRINT_LOOTS ~= nil then
          table.insert(old_BLUEPRINT_LOOTS, "do_dock_kit")
      end
  end
end)
```

### 变体演进：字体:补丁文楷/Font:Patched WenKai (Mod 3213320788)
- **变体场景与切面**：收录来自工坊 Mod 3213320788 (`字体:补丁文楷/Font:Patched WenKai`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3213320788)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wormwood
AddPrefabPostInit("wormwood",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(135/255, 169/255, 107/255) -- #87A96B Asparagus
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yotb_stage
AddPrefabPostInit("yotb_stage",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(124/255, 185/255, 232/255) -- #7CB9E8 Aero
  end
end)
```

### 变体演进：【高清】猫啃忘形圆 (Mod 3779287413)
- **变体场景与切面**：收录来自工坊 Mod 3779287413 (`【高清】猫啃忘形圆`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3779287413)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wormwood
AddPrefabPostInit("wormwood",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(135/255, 169/255, 107/255) -- #87A96B Asparagus
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yotb_stage
AddPrefabPostInit("yotb_stage",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(124/255, 185/255, 232/255) -- #7CB9E8 Aero
  end
end)
```

### 变体演进：字体:补丁像素/Font:Patched Pixel (Mod 3213835671)
- **变体场景与切面**：收录来自工坊 Mod 3213835671 (`字体:补丁像素/Font:Patched Pixel`) 的生产级切面。
- **核心切面代码**：

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3213835671)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wormwood
AddPrefabPostInit("wormwood",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(135/255, 169/255, 107/255) -- #87A96B Asparagus
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:yotb_stage
AddPrefabPostInit("yotb_stage",function(self)
  if self.components and self.components.talker then
      self.components.talker.colour = Vector3(124/255, 185/255, 232/255) -- #7CB9E8 Aero
  end
end)

```


