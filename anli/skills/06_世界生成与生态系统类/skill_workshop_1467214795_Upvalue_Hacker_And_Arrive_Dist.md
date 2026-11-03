# 饥荒一线工坊深度研读 Skill：闭包穿透黑客（Upvalue Hacker）与跨边界到达距离补偿机制

- **工坊 ID**：1467214795 (`Island Adventures`)
- **领域分类**：函数深层闭包注入、跨地皮/海岸边界到达距离补偿（Arrive Dist）、热重载防御
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发大型或深度修改游戏规则的 MOD 时，开发者常面临两大天花板：
1. **官方变量深锁闭包**：关键变量在某个本地函数内部定义，没有挂在组件上，普通 Hook 根本读写不到；
2. **跨地皮边界移动器卡死**：玩家在陆地（可通行），目标在水里/虚空边缘（不可通行），底层寻路（Locomotor）因为到达距离不足导致角色原地踱步抽搐。

`Island Adventures` 提供了两个标准的工业级解法。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1467214795，完整闭包自闭环)
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

---

## 三、避坑与生产安全准则

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
-- 生产级架构复刻切面范式 (提取自 Mod 3494013763)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
а всякие w и state будут инициализированы только после срабатывания AddPrefabPostInit("world").

mods - список модов (и их элементов или обобщений).
mods.lib - список переменных (и функций) для экспорта в любое пространство имен, где это нужно.
mods.lib.version - версия библиотеки

--]]
if _silence == nil then
	print(_version,modinfo.name) --Show current version of lib
end


--[[
--Так нельзя делать, потому что, возможно, мы переопределяем старую библиотеку более новой с полной заменой функций и всего-всего.
if mods.lib then
	return
end
--]]

--[[
Итак, у нас возможны две ситуации:
	1) Это первая загрузка. Здесь всё просто - инициализируем.
	2) Это N-ая загрузка. Тут нам надо учесть опыт прошлой загрузки и не сломать ничего, и не потерять.
Поэтому мы определяем переменную old_lib. Из нее по возможности вытягиваем все определения. Если их нет, то создаём.
Стараемся сохранить всё, что можно (и нужно) сохранить. Остальное тупо заменяем.
--]]
local old_lib = mods.lib or {} --При обращении, отсутствующие элементы будут nil

--Далее делаем очень хитрый финт ушами. Сообщаем старому модулю, чтобы он отдыхал.
if old_lib._libStopWorking then
	old_lib._libStopWorking()
end

--А теперь оставляем такую возможноть для модулей, которые захотят также отправить на покой нас.
local IS_ACTIVE = true --Всегда тру, пока не станет фолс. Это случится при смене власти.
local function _libStopWorking()
	--Останавливает работу модуля. Все постиниты должны отказаться работать.
	--Естественно, кроме тех, что работают автономно, а не сообща.
	IS_ACTIVE = nil
	--Все общие функции обязаны вручную проверять эту переменную, если хотять разделять общие данные.
	--Ведь в конце должен остаться лишь один (обработчик).
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:forest
--AddPrefabPostInit("forest",world_init)
--По большому счету это рудимент, т.к. история с forest закончилась.


--Пустая функция. Иногда нужно заткнуть кого-то или что-то, чтоб они думали, что продолжают делать что-то важное.
local EmptyFunction = function() end

```



### 变体演进：几何布局-汉化版 (Mod 3034588489)
- **变体场景与切面**：收录来自工坊 Mod 3034588489 (`几何布局-汉化版`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3034588489)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
	-- This needs to be done in this post-init because the recipe loading code is not idempotent
	if REDUCECHESTSPACING then
		-- other geometry mods ignore the special case for chests that increases the spacing for them
		-- in Builder:CanBuildAtPoint; however, reducing the built-in spacing by just a little bit
		-- gives similar behavior in terms of which lattice points you can build the chest
		local treasurechestrecipe = DST
			and GLOBAL.GetValidRecipe('treasurechest')
			or GLOBAL.GetRecipe('treasurechest')
		treasurechestrecipe.min_spacing = treasurechestrecipe.min_spacing - 0.1
	end

	local Prefabs = GLOBAL.Prefabs
	-- Veggie seeds for Wormwood, their test is just checking for natural turf
	for veggie, data in pairs(GLOBAL.VEGGIES) do
		local seed_placer = veggie .. "_seeds_placer"
		if Prefabs[seed_placer] then
			ALLOW_PLACE_TEST[seed_placer] = true
			PLACER_SPACING_OVERRIDES[seed_placer] = TILL_SPACING
		end
	end
	-- Pig shops in Hamlet, their test just hides some AnimState symbols; could be put in placer-only logic when it exists
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
end

-- But these things do need to get built every time
local function PlacerPostInit(self)
	--there's gotta be a better place to put this; also may not be necessary, but it's safe and cheap
	local TheWorld = DST and GLOBAL.TheWorld or GLOBAL.GetWorld()
	TheCamera = GLOBAL.TheCamera
	ORIGIN_OFFSETS.tile = Vector3(TheWorld.Map:GetTileCenterPoint(0, 0, 0)) * -1
	if TheWorld.Flooding then
		ORIGIN_OFFSETS.flood = Vector3(TheWorld.Flooding:GetTileCenterPoint(0, 0, 0)) * -1
	end

	if not CONTROLLEROFFSET then
		--Then the ground action hints can get in the way; increase the offset
		-- note that these action hints only get used by controllers
		GetPlayer().HUD.controls.groundactionhint:SetOffset(Vector3(0, 200, 0))
	end

	--used in DST to track attachments to farm placers, telebase, etc;
	-- set to empty list if not present for simpler logic
	self.linked = self.linked or {}
	--keeps track of the build grid objects, indexed by lattice coordinates
	self.build_grid = nil
	--keeps track of the build grid positions, indexed by lattice coordinates
	self.build_grid_positions = nil
	--keep a queue of locations to check the collision for
	--Why did I do this as storing lattice coordinates instead of storing the buildgridplacer objects?
	-- because this way I don't have to worry about buildgridplacer objects going in multiple times
	-- if it pops one out and it's not in the grid, no big deal, that's way faster than testing the point
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

	-- Delay to capture the prefab name
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
end

-- But these things do need to get built every time
local function PlacerPostInit(self)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:gridplacer_farmablesoil
AddPrefabPostInit("gridplacer_farmablesoil", ReplaceGridplacerAnim)
end

-- But these things do need to get built every time
local function PlacerPostInit(self)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:placer
AddComponentPostInit("placer", PlacerPostInit)

--[[ Builder Component ]]
                          --
-- For DST
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

```



### 变体演进：Chinese++ Pro (Mod 2941527805)
- **变体场景与切面**：收录来自工坊 Mod 2941527805 (`Chinese++ Pro`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2941527805)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function(inst)
            inst:DoTaskInTime(5, function()
                local str = "[" .. modinfo.name .. "] 模组基础运行库缺失！你未开启此模组依赖的基础运行库模组，你必须去订阅才能继续使用本模组\n请前往创意工坊订阅并在【服务器】开启【冰冰羊的模组运行库】模组"
                c_announce(str)
            end)
        end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:focalpoint
AddComponentPostInit("focalpoint", function(self)
    local CameraUpdate = self.CameraUpdate
    self.CameraUpdate = function(self, ...) -- 原版添加焦点时会立即更新，在它改写跟随速度前记录原值
        if self.inst == TheFocalPoint and PrepareDroneView then
            PrepareDroneView()
        end
        return CameraUpdate(self, ...)
    end
    local Reset = self.Reset
    self.Reset = function(self, ...)
        -- 航海焦点退出/切换仍执行原版清理，但不重置OB视角的距离、FOV和位置锁定
        if self.inst ~= TheFocalPoint or not IsBoatFocus(self) or (PrepareDroneView and PrepareDroneView()) then
            return Reset(self, ...)
        end
        local cam = TheCamera
        local distance, distancetarget, fov = cam.distance, cam.distancetarget, cam.fov
        local position = cam.target == nil and cam.targetpos
        local function RestoreView(...)
            cam.distance, cam.distancetarget, cam.fov = distance, distancetarget, fov
            if position then cam.targetpos = position end
            return ...
        end
        return RestoreView(Reset(self, ...))
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:bermudatriangle
AddPrefabPostInit("bermudatriangle", function(inst)
    inst.MiniMapEntity:SetPriority(20)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)
    inst:DoTaskInTime(0.2, function() AddWormholeColor(inst, inst:GetPosition()) end)

    -- 主机环境 获取虫洞入口
    if TheWorld.ismastersim then
        inst:ListenForEvent("starttravelsound", function(inst, doer)
            if doer == ThePlayer then
                entrance = {inst = inst, pos = inst:GetPosition()}
            end
        end)
        -- 通过大饼船传送：暂不支持
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified
AddPrefabPostInit("player_classified", function(player_classified)
    world_type = GetWorldType()
    if world_type == "island" then -- 电光三角无法通过监听 wormholetraveldirty 来绑定虫洞，换个方法
        local PrefabPostInitFns = Upvaluehelper.Getmoddata("workshop-2831613121", "PrefabPostInit", "player_classified")
        if not PrefabPostInitFns and PrefabPostInitFns[1] then MOD_util:Warning("未获取到 PrefabPostInitFn") return end

        local SaveWormholePair = Upvaluehelper.GetUpvalue(PrefabPostInitFns[1], "SaveWormholePair")
        local WormholePositionExists = Upvaluehelper.GetUpvalue(PrefabPostInitFns[1], "WormholePositionExists")
        local GetWormhole = Upvaluehelper.GetUpvalue(PrefabPostInitFns[1], "GetWormhole")

        -- 删除原模组的监听事件
        local original_listener_1 = Upvaluehelper.GetEventHandle(player_classified, "wormholetraveldirty", "workshop%-2831613121/modmain")
        if original_listener_1 then
            player_classified:RemoveEventCallback("wormholetraveldirty", original_listener_1)
        end
        local original_listener_2 = Upvaluehelper.GetEventHandle(player_classified, "wormholetravel", "workshop%-2831613121/modmain")
        if original_listener_2 then
            player_classified:RemoveEventCallback("wormholetravel", original_listener_2)
        end

        if not TheWorld.ismastersim then
            local oldsend = SendRPCToServer
            local JUMPIN_CODE = ACTIONS.JUMPIN.code
            function GLOBAL.SendRPCToServer(player, action, x, z, target ,...) -- HOOK RPC来确定玩家是从哪个虫洞进入的
                if action == JUMPIN_CODE and checkentity(target) and wormhole_types[target.prefab] then
                    entrance = {inst = target, pos = target:GetPosition()}
                end
                return oldsend(player, action, x, z, target, ...)
            end
        end

        Upvaluehelper.SetUpvalue(AddWormholeColor, false, "GROUND_BORDERS") -- 关闭【在地面虫洞周围添加边框】功能

        player_classified:ListenForEvent("wormholetraveldirty", function()
            if entrance and not WormholePositionExists(entrance.pos) then
                _G.ThePlayer:DoTaskInTime(3, function()
                    local exit = GetWormhole()
                    if exit and not WormholePositionExists(exit.pos) then
                        SaveWormholePair(entrance, exit)
                        entrance = nil
                    end
                end)
            end
        end)
    end
end)

```



### 变体演进：T键物品增加 (Mod 2763963752)
- **变体场景与切面**：收录来自工坊 Mod 2763963752 (`T键物品增加`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2763963752)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function (inst)
    inst:DoTaskInTime(0,function ()
        if not controls or not controls.TMI then
            return
        end
        --增加鸦年华，浣猫年
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



### 变体演进：HEADER_GENERAL (Mod 3485366151)
- **变体场景与切面**：收录来自工坊 Mod 3485366151 (`HEADER_GENERAL`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3485366151)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:aoetargeting
AddComponentPostInit("aoetargeting", function(self)
    local old_CanRepeatCast = self.CanRepeatCast
    local old_ShouldRepeatCast = self.ShouldRepeatCast

    self.CanRepeatCast = function(self)
        if IsContinuousSpellEnabled() and ThePlayer and ThePlayer.continuous_spell_active then
            return true
        end
        return old_CanRepeatCast(self)
    end

    self.ShouldRepeatCast = function(self, doer)
        if IsContinuousSpellEnabled() and ThePlayer and ThePlayer.continuous_spell_active then
            return true
        end
        return old_ShouldRepeatCast(self, doer)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:spellbook
AddComponentPostInit("spellbook", function(self)
	local oldselectfn = self.SelectSpell
	self.SelectSpell = function(self, id)
		if not self.items then return false end
		return oldselectfn(self, id)
	end

	local oldfn = self.OpenSpellBook
	self.OpenSpellBook = function(self, user)
		ThePlayer.HUD.controls.spellwheel:SetPosition(0,0)
		return oldfn(self,user)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:spellbookcooldowns
AddComponentPostInit("spellbookcooldowns", function(inst)
    local oldregisterfn = inst.RegisterSpellbookCooldown
    inst.RegisterSpellbookCooldown = function(self, cd)
    	if self.inst and self.inst.components.huanyuecooldowntimer then
    		self.inst.components.huanyuecooldowntimer:OnCast(cd:GetLength())
    	end
    	mod.last_cast_time = GetTime()
        oldregisterfn(self,cd)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:focalpoint
AddComponentPostInit("focalpoint", function(self)
	local oldfn = self.StartFocusSource
	self.StartFocusSource = function(self, source, id, target, minrange, maxrange, priority, updater, ...)
		if source and source._remi_nofocus or target and target._remi_nofocus then return end
		oldfn(self, source, id, target, minrange, maxrange, priority, updater, ...)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wobysmall
AddPrefabPostInit("wobysmall", WobyPostInit)
AddPrefabPostInit("wobybig", WobyPostInit)

AddPrefabPostInit("winona_remote", function(inst)
	if inst.components and inst.components.spellbook then
		inst.components.spellbook:SetBgData()
	end
end)

```



### 变体演进：skill_1 (Mod 3378500626)
- **变体场景与切面**：收录来自工坊 Mod 3378500626 (`skill_1`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3378500626)
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



### 变体演进：open_config_key (Mod 3372819329)
- **变体场景与切面**：收录来自工坊 Mod 3372819329 (`open_config_key`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3372819329)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wortox_overloading_fx
AddPrefabPostInit("wortox_overloading_fx", function(inst)
    inst:DoTaskInTime(0, function()
        local parent = inst.entity:GetParent()
        if parent == nil or parent ~= ThePlayer or not GetConfig("overload_store") then
            return
        end

        local overload_time = TUNING.SKILLS.WORTOX
            and TUNING.SKILLS.WORTOX.NAUGHTY_OVERLOAD_STOP_TIME or 4

        inst:DoTaskInTime(math.max(overload_time - 0.5, 0), function()
            local stored = StoreExcessBeforeOverload(inst, 4)
            if stored > 0 and ThePlayer.components.talker then
                ThePlayer.components.talker:Say(
                    string.format(GetWortoxStrings().FEATURES.OVERLOAD_STORE.SUCCESS, stored))
            end
        end)
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wortox_soul_spawn
AddPrefabPostInit("wortox_soul_spawn", function(inst)
    inst:DoTaskInTime(0, function()
        inst._detection_task = inst:DoPeriodicTask(FRAMES, function()
            if inst:IsValid() and not inst._target_confirmed then
                DetectWortoxTarget(inst)
            end
        end, 1)

        inst:ListenForEvent("onremove", function()
            if my_attracted_souls[inst] then
                my_attracted_souls[inst] = nil
            end

            if inst._detection_task then
                inst._detection_task:Cancel()
                inst._detection_task = nil
            end
        end)
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function(world)
    LocationMemory.alldata = RW_util:LoadData(locationpatch) or {}
    print("[Wortox] 加载位置数据:", json.encode(LocationMemory.alldata))

    local a = true
    world:ListenForEvent("playeractivated", function()
        if a then
            a = false
            LocationMemory.worldid = TheWorld.net.components.shardstate and
                TheWorld.net.components.shardstate:GetMasterSessionId()
            if not LocationMemory.worldid then
                print("[Wortox] 错误: 无法获取世界ID")
                return
            end

            print("[Wortox] 当前世界ID:", LocationMemory.worldid)


            if LocationMemory.alldata[LocationMemory.worldid] and LocationMemory.alldata[LocationMemory.worldid].locations then
                saved_locations = LocationMemory.alldata[LocationMemory.worldid].locations
                print("[Wortox] 已加载位置数量:", #saved_locations)
            else
                saved_locations = {}
                print("[Wortox] 没有保存的位置，初始化为空")
            end


            LocationMemory.data_loaded = true
            print("[Wortox] 数据加载完成，允许保存")
        end
    end)


    world:WatchWorldState("cycles", function(inst)
        LocationMemory:SaveData("cycles")
    end)
end)

```



### 变体演进：1/10000 Chance for Withered Foxy Jumpscare Every Second [Server] (Mod 3527018254)
- **变体场景与切面**：收录来自工坊 Mod 3527018254 (`1/10000 Chance for Withered Foxy Jumpscare Every Second [Server]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3527018254)
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



### 变体演进：Beefalo Buck Timer (Mod 2858947939)
- **变体场景与切面**：收录来自工坊 Mod 2858947939 (`Beefalo Buck Timer`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2858947939)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
AddPrefabPostInit("player_classified", function(pc)
   pc:DoTaskInTime(GLOBAL.FRAMES*2, function()
      if pc._parent == GLOBAL.ThePlayer then
         pc:ListenForEvent("isperformactionsuccessdirty", function(pc) pc:DoTaskInTime(GLOBAL.FRAMES*2, checkFed) end)
      end
   end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:playercontroller
-- AddComponentPostInit("playercontroller", function(self, inst)
   -- if inst ~= _G.ThePlayer then return end
   -- ThePlayer = _G.ThePlayer
   -- TheWorld = _G.TheWorld
   -- EQUIPSLOTS = _G.EQUIPSLOTS

   -- local OriginalOnLeftClick = self.OnLeftClick

   -- self.OnLeftClick = function(self, down)
      -- if down or _G.TheInput:GetHUDEntityUnderMouse() or self:IsAOETargeting() or self.placer_recipe then
         -- return OriginalOnLeftClick(self, down)
      -- end
      -- -- print("Heyyyyy Left Click! " .. tostring(self:GetLeftMouseAction()))
      
      -- local act = self:GetLeftMouseAction()
      
      -- if not act or act.action ~= _G.ACTIONS.BRUSH then
         -- return OriginalOnLeftClick(self, down)
      -- end
      
      -- print("Brush Action: " .. tostring(act.action) .. " in " .. tostring(act.action.time_direct_walking or ThePlayer.player_classified.time_direct_walking))
      
      -- -- vv(act)
      -- -- vu(act)
      -- if act.doer == ThePlayer and act.target and act.target.components.bucktimer then
         -- -- act.target:DoTaskInTime(GLOBAL.FRAMES, function(inst)
            -- -- inst.components.bucktimer:OnBrushed()
         -- -- end)
      -- end
      -- return OriginalOnLeftClick(self, down)
   -- end
-- end)

-- AddPrefabPostInit("world", function(inst)
   -- inst:ListenForEvent("playeractivated", function(self)
      -- _G.ThePlayer.player_classified:ListenForEvent("isperformactionsuccessdirty", function(inst) print("isperformactionsuccessdirty") print(_G.ThePlayer:GetDebugString()) vv(inst) vu(inst) end)
      -- -- build_loop
   -- end)
-- end)

-- local _SendRPCToServer
-- AddPrefabPostInit("world", function(inst)
	-- if not inst.ismastersim then
		-- AddPlayerPostInit(function(inst)
			-- inst:DoTaskInTime(0, function(inst)
				-- if inst == _G.ThePlayer and inst.player_classified ~= nil then
					-- if _SendRPCToServer == nil then
						-- _SendRPCToServer = _G.SendRPCToServer
						-- _G.SendRPCToServer = function(...)
							-- local arg = { ... }

							-- if arg[2] == _G.ACTIONS.BRUSH.code then
                        -- print("here")
							-- end

							-- return _SendRPCToServer(...)
						-- end
               -- end
            -- end
         -- end)
      -- end)
   -- end
-- end)


AddPrefabPostInit("beefalo", function(inst)
   inst:AddComponent("bucktimer")
   inst:DoTaskInTime(1,function(inst)
      local bname = inst.components.bucktimer:GetBeefaloName(false)
      if not bname then
         return
      end
      if KnownBeefalo and KnownBeefalo[bname] then
         print("Beefalo loaded: " .. bname .. ", " .. KnownBeefalo[bname])
         inst.components.bucktimer:LoadKnown(KnownBeefalo[bname])
      end
   end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
-- AddPrefabPostInit("world", function(inst)
   -- inst:ListenForEvent("playeractivated", function(self)
      -- _G.ThePlayer.player_classified:ListenForEvent("isperformactionsuccessdirty", function(inst) print("isperformactionsuccessdirty") print(_G.ThePlayer:GetDebugString()) vv(inst) vu(inst) end)
      -- -- build_loop
   -- end)
-- end)

-- local _SendRPCToServer
-- AddPrefabPostInit("world", function(inst)
	-- if not inst.ismastersim then
		-- AddPlayerPostInit(function(inst)
			-- inst:DoTaskInTime(0, function(inst)
				-- if inst == _G.ThePlayer and inst.player_classified ~= nil then
					-- if _SendRPCToServer == nil then
						-- _SendRPCToServer = _G.SendRPCToServer
						-- _G.SendRPCToServer = function(...)
							-- local arg = { ... }

							-- if arg[2] == _G.ACTIONS.BRUSH.code then
                        -- print("here")
							-- end

							-- return _SendRPCToServer(...)
						-- end
               -- end
            -- end
         -- end)
      -- end)
   -- end
-- end)


AddPrefabPostInit("beefalo", function(inst)
   inst:AddComponent("bucktimer")
   inst:DoTaskInTime(1,function(inst)
      local bname = inst.components.bucktimer:GetBeefaloName(false)
      if not bname then
         return
      end
      if KnownBeefalo and KnownBeefalo[bname] then
         print("Beefalo loaded: " .. bname .. ", " .. KnownBeefalo[bname])
         inst.components.bucktimer:LoadKnown(KnownBeefalo[bname])
      end
   end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beefalo
AddPrefabPostInit("beefalo", function(inst)
   inst:AddComponent("bucktimer")
   inst:DoTaskInTime(1,function(inst)
      local bname = inst.components.bucktimer:GetBeefaloName(false)
      if not bname then
         return
      end
      if KnownBeefalo and KnownBeefalo[bname] then
         print("Beefalo loaded: " .. bname .. ", " .. KnownBeefalo[bname])
         inst.components.bucktimer:LoadKnown(KnownBeefalo[bname])
      end
   end)
end)

```



### 变体演进：消除脑残画面(Remove Insanity Vision) (Mod 1231473531)
- **变体场景与切面**：收录来自工坊 Mod 1231473531 (`消除脑残画面(Remove Insanity Vision)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1231473531)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function(inst)
        for _, v in pairs(inst.event_listeners.playeractivated[inst]) do
            if CollectShit(v, "OnOverrideCCTable") then
                EatShit(v, function()  end, "OnSanityDelta")
            end
        end
    end)

```

