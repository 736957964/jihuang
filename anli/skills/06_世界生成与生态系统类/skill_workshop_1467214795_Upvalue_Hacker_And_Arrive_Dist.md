# 饥荒一线工坊深度研读 Skill：闭包穿透黑客（Upvalue Hacker）与跨边界到达距离补偿机制

- **工坊 ID**：1467214795 (`Island Adventures`)
- **领域分类**：函数深层闭包注入、跨地皮/海岸边界到达距离补偿（Arrive Dist）、热重载防御
- **研读基准**：Steam 创意工坊在线原版源码

在开发大型或深度修改游戏规则的 MOD 时，开发者常面临两大天花板：
1. **官方变量深锁闭包**：关键变量在某个本地函数内部定义，没有挂在组件上，普通 Hook 根本读写不到；
2. **跨地皮边界移动器卡死**：玩家在陆地（可通行），目标在水里/虚空边缘（不可通行），底层寻路（Locomotor）因为到达距离不足导致角色原地踱步抽搐。

`Island Adventures` 提供了两个标准的工业级解法。

```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

IAENV.AddPrefabPostInitAny(function(inst)
    if inst and TheWorld.ismastersim then
        if IsFloodImmune(inst) then inst:AddTag("flood_immune") end
        if inst.components.walkableplatform and IsIslandsWorld() then
            inst:AddComponent("mapwrapper")
            inst:AddComponent("bermudafx")
            inst.components.bermudafx:SetGetEntitiesFn(GetAllPlatformBermudaFollowers)
            inst.components.bermudafx.nobounce = true
        end
    end
end)
```

1. **Upvalue 深度穿透递归深度约束**：
   - Lua 闭包层级可能非常深甚至出现互相引用的复杂场景。检索时必须传入 `max_depth` 限制，严禁无限递归造成栈溢出崩溃。
2. **`extra_arrive_dist` 绝对不能无条件扩大**：
   - 必须通过 `TheWorld.Map:IsOceanTileAtPoint` 与 `doer:IsOnPassablePoint()` 双向交叉校验。若无脑扩大所有采集动作的到达距离，会导致玩家隔着高墙或长距离隔空吸取物品，彻底破坏游戏平衡与手感。

## 五、进阶拓扑演进与变体分支

### 变体演进：Slightly Cuter Wendy (Mod 3494013763)
- **变体场景与切面**：收录来自工坊 Mod 3494013763 (`Slightly Cuter Wendy`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

mods - список модов (и их элементов или обобщений).
mods.lib - список переменных (и функций) для экспорта в любое пространство имен, где это нужно.
mods.lib.version - версия библиотеки

if _silence == nil then
	print(_version,modinfo.name) --Show current version of lib
end

local old_lib = mods.lib or {} --При обращении, отсутствующие элементы будут nil

if old_lib._libStopWorking then
	old_lib._libStopWorking()
end

local IS_ACTIVE = true --Всегда тру, пока не станет фолс. Это случится при смене власти.
local function _libStopWorking()
	IS_ACTIVE = nil
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:forest

local EmptyFunction = function() end
```

### 变体演进：几何布局-汉化版 (Mod 3034588489)
- **变体场景与切面**：收录来自工坊 Mod 3034588489 (`几何布局-汉化版`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	if REDUCECHESTSPACING then
		local treasurechestrecipe = DST
			and GLOBAL.GetValidRecipe('treasurechest')
			or GLOBAL.GetRecipe('treasurechest')
		treasurechestrecipe.min_spacing = treasurechestrecipe.min_spacing - 0.1
	end

	local Prefabs = GLOBAL.Prefabs
	for veggie, data in pairs(GLOBAL.VEGGIES) do
		local seed_placer = veggie .. "_seeds_placer"
		if Prefabs[seed_placer] then
			ALLOW_PLACE_TEST[seed_placer] = true
			PLACER_SPACING_OVERRIDES[seed_placer] = TILL_SPACING
		end
	end
	for prefab, _ in pairs(Prefabs) do
		if type(prefab) == "string" and prefab:match("^pig_shop") and prefab:match("_placer$") then
			ALLOW_PLACE_TEST[prefab] = true
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:gridplacer
AddPrefabPostInit("gridplacer", ReplaceGridplacerAnim)
if DST then
	AddPrefabPostInit("tile_outline", ReplaceGridplacerAnim)
	AddPrefabPostInit("gridplacer_farmablesoil", ReplaceGridplacerAnim)

local function PlacerPostInit(self)
	local TheWorld = DST and GLOBAL.TheWorld or GLOBAL.GetWorld()
	TheCamera = GLOBAL.TheCamera
	ORIGIN_OFFSETS.tile = Vector3(TheWorld.Map:GetTileCenterPoint(0, 0, 0)) * -1
	if TheWorld.Flooding then
		ORIGIN_OFFSETS.flood = Vector3(TheWorld.Flooding:GetTileCenterPoint(0, 0, 0)) * -1
	end

	if not CONTROLLEROFFSET then
		GetPlayer().HUD.controls.groundactionhint:SetOffset(Vector3(0, 200, 0))
	end

	self.linked = self.linked or {}
	self.build_grid = nil
	self.build_grid_positions = nil
	self.refresh_queue = nil
	self.lastpt = nil
	self.placertype = "buildgridplacer"
	self.waiting_for_geometry = true -- to prevent the wrong geometry being used on the first update
	self.cursor_visible = true
	self.cursor_quantity_visible = true

	self.inst:ListenForEvent("onremove", function()
		self:RemoveBuildGrid()
		self:SetCursorVisibility(true)
		if self.tileinst then self.tileinst:Remove() end
		if self.gridinst then self.gridinst:Remove() end
		if self.controller_child then self.controller_child:Remove() end
end)

	self.inst:DoTaskInTime(0, function()
		local prefab = self.inst.prefab
		if prefab == "sprinkler_placer" then
			self.placeTestFn = sprinklerPlaceTestFn
		end
		self.showFirstLinked = PLACERS_SHOWFIRSTLINKED[prefab]
		if GRIDPLACER_PREFABS[prefab] then
			ReplaceGridplacerAnim(self.inst)
			local _oncanbuild = self.oncanbuild
			self.oncanbuild = function(inst, ...)
				if CTRL ~= TheInput:IsKeyDown(KEY_CTRL) then
					UndoReplaceGridplacerAnim(self.inst)
					return _oncanbuild(inst, ...)
				else
					ReplaceGridplacerAnim(self.inst)
				end
			end
			local _oncannotbuild = self.oncanbuild
			self.oncannotbuild = function(inst, ...)
				if CTRL ~= TheInput:IsKeyDown(KEY_CTRL) then
					UndoReplaceGridplacerAnim(self.inst)
					return _oncannotbuild(inst, ...)
				else
					ReplaceGridplacerAnim(self.inst)
				end
			end
		end
end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:tile_outline
AddPrefabPostInit("tile_outline", ReplaceGridplacerAnim)
	AddPrefabPostInit("gridplacer_farmablesoil", ReplaceGridplacerAnim)

local function PlacerPostInit(self)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:gridplacer_farmablesoil
AddPrefabPostInit("gridplacer_farmablesoil", ReplaceGridplacerAnim)
end

local function PlacerPostInit(self)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:placer
AddComponentPostInit("placer", PlacerPostInit)

local function BuilderReplicaPostConstruct(self)
	local OldCanBuildAtPoint = self.CanBuildAtPoint
	local function NewCanBuildAtPoint(self, pt, recipe, ...)
		if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldCanBuildAtPoint(self, pt, recipe, ...)
	end
	self.CanBuildAtPoint = NewCanBuildAtPoint
	local OldMakeRecipeAtPoint = self.MakeRecipeAtPoint
	local function NewMakeRecipeAtPoint(self, recipe, pt, ...)
		if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldMakeRecipeAtPoint(self, recipe, pt, ...)
	end
	self.MakeRecipeAtPoint = NewMakeRecipeAtPoint
end
end
end
```

### 变体演进：T键物品增加 (Mod 2763963752)
- **变体场景与切面**：收录来自工坊 Mod 2763963752 (`T键物品增加`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function (inst)
    inst:DoTaskInTime(0,function ()
        if not controls or not controls.TMI then
            return
        end
        local tmp=require "TMIP/debug"
        for k,v in ipairs(tmp)do
            if v.tittle and v.tittle== STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TEXT then
                table.insert(v.list,{
                    beta = false,
                    pos = 'all',
                    name = _G.TOOMANYITEMS.UI_LANGUAGE == 'cn' and STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.CARNIVAL or 'CARNIVAL',
                    tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TIPTEXT .. STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.CARNIVAL,
                    fn = {
                        'confirm',
                        'ApplySpecialEvent("crow_carnival") TheWorld.topology.overrides.specialevent = "crow_carnival" c_save() c_announce("' ..
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_RESETTIP ..
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TIPTEXT ..
                        STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.CARNIVAL ..
                        '") TheWorld:DoTaskInTime(5, function() if TheWorld ~= nil and TheWorld.ismastersim then TheNet:SendWorldRollbackRequestToServer(0) end end)',
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TIPTEXT .. STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.CARNIVAL,
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TEXTCHANGESTIP
                    }
                })
                table.insert(v.list,{
                    beta = false,
                    pos = 'all',
                    name = _G.TOOMANYITEMS.UI_LANGUAGE == 'cn' and STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.YOT_CATCOON or 'YOT_CATCOON',
                    tip = STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TIPTEXT .. STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.YOT_CATCOON,
                    fn = {
                        'confirm',
                        'ApplySpecialEvent("year_of_the_catcoon") TheWorld.topology.overrides.specialevent = "year_of_the_catcoon" c_save() c_announce("' ..
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_SERVER_RESETTIP ..
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TIPTEXT ..
                        STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.YOT_CATCOON ..
                        '") TheWorld:DoTaskInTime(5, function() if TheWorld ~= nil and TheWorld.ismastersim then TheNet:SendWorldRollbackRequestToServer(0) end end)',
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TIPTEXT .. STRINGS.UI.SANDBOXMENU.SPECIAL_EVENTS.YOT_CATCOON,
                        STRINGS.TOO_MANY_ITEMS_UI.DEBUG_EVENT_TEXTCHANGESTIP
                    }
                })
                break
            end
        end
        package.loaded["TMIP/debug"] = tmp
        if controls.TMI.debugshield then
            controls.TMI.debugshield:Kill()
        end
        controls.TMI:DebugMenu()
end)
end)
```

### 变体演进：skill_1 (Mod 3378500626)
- **变体场景与切面**：收录来自工坊 Mod 3378500626 (`skill_1`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:spellbookcooldown
AddPrefabPostInit("spellbookcooldown", function(inst)
        if _G.ThePlayer:HasTag("ghostlyfriend") then
            for k, v in ipairs(tiles) do
                v:SetChargePercent(0)
            end
    
            inst:ListenForEvent("pctdirty", function(inst)
                local pct = 1 - inst:GetPercent()
                for k, v in ipairs(tiles) do
                    if v.inst:IsValid() then
                        if math.abs(pct - v.rechargepct) > 0.05 then
                            if inst:GetSpellName() == _G.hash("do_ghost_attackat") then
                                if _G.ThePlayer.components.spellbookcooldowns:GetSpellCooldownPercent("ghostcommand") == nil then
                                    v:SetChargeTime(inst:GetLength())
                                    v:SetChargePercent(1 - inst:GetPercent())
                                    v.recharge:GetAnimState():SetMultColour(.2, .2, 0, 0.64) -- '额外冷却' 黄色
                                end
                            else
                                v:SetChargeTime(TUNING.WENDYSKILL_COMMAND_COOLDOWN)
                                v:SetChargePercent(1 - inst:GetPercent())
                                v.recharge:GetAnimState():SetMultColour(0, 0, 0.4, 0.64) -- '普通冷却' 蓝色
                            end
                        end
                    else
                        table.remove(tiles, k)
                    end
                end
end)
        end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world",function(inst) 
    inst:DoPeriodicTask(0.2+0.01*math.random(),function(inst)
        UpdatePlayerIndicators()
end)
end)
```

### 变体演进：1/10000 Chance for Withered Foxy Jumpscare Every Second [Server] (Mod 3527018254)
- **变体场景与切面**：收录来自工坊 Mod 3527018254 (`1/10000 Chance for Withered Foxy Jumpscare Every Second [Server]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world",function()
        if not GLOBAL.TheWorld.ismastersim then
            GLOBAL.TheFrontEnd.screenroot.inst:DoPeriodicTask(1,function()
                if math.random(1,10000) == 1 then
                    JumpscarePlayer()
                end
end)
        end
end)
```

