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

