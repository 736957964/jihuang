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



### 变体演进：Wolemorm, Mineral Edition (Mod 2313039145)
- **变体场景与切面**：收录来自工坊 Mod 2313039145 (`Wolemorm, Mineral Edition`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2313039145)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:edible
AddComponentPostInit("edible", function(self)
	local oldGetStat = { health = self.GetHealth, hunger = self.GetHunger, sanity = self.GetSanity }
	local oldOnEaten = self.OnEaten
	
	local function getstat(self, eater, statname)
		local stat = oldGetStat[statname](self, eater)
		if eater and eater.extrafoodstats then
			stat = stat + (eater.extrafoodstats[self.inst.prefab] and eater.extrafoodstats[self.inst.prefab][statname] or 0)
		end
		return stat
	end
	
	function self:GetHealth(eater)
		return getstat(self, eater, "health")
	end
	
	function self:GetHunger(eater)
		return getstat(self, eater, "hunger")
	end
	
	function self:GetSanity(eater)
		return getstat(self, eater, "sanity")
	end
	
	function self:OnEaten(eater)
		oldOnEaten(self, eater)
		
		if eater and eater.extrafoodstats and eater.extrafoodstats[self.inst.prefab] and eater.extrafoodstats[self.inst.prefab].fn then
			eater.extrafoodstats[self.inst.prefab].fn(self.inst, eater)
		end
	end
end)

```



### 变体演进：Large boats Fix (Mod 3127245589)
- **变体场景与切面**：收录来自工坊 Mod 3127245589 (`Large boats Fix`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3127245589)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:boatphysics
AddComponentPostInit("boatphysics",function(self,inst)
    self.sizespeedmultiplier=1
    local oaf=self.ApplyForce
    function self:ApplyForce(dir_x, dir_z, force)
        local force=(force and force or 0)*self.sizespeedmultiplier
        oaf(self,dir_x, dir_z, force)
    end
    local oam=self.AddMast
    function self:AddMast(mast)
        mast.sail_force=mast.sail_force*self.sizespeedmultiplier
        oam(self, mast)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world",function()
    local WALKABLE_PLATFORM_TAGS={"walkableplatform"}
    GLOBAL.Map.GetPlatformAtPoint=function(self,pos_x,pos_y, pos_z, extra_radius)
        if pos_z == nil then
            pos_z = pos_y
            pos_y = 0
        end
        local entities = TheSim:FindEntities(pos_x, pos_y, pos_z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS*5 + (extra_radius or 0), WALKABLE_PLATFORM_TAGS)
        for i, v in ipairs(entities) do
            if v.components.walkableplatform~=nil and math.sqrt(v:GetDistanceSqToPoint(pos_x, 0, pos_z))<=v.components.walkableplatform.platform_radius then
                return v 
            end
        end
        return nil
    end
    GLOBAL.Map.IsPassableAtPointWithPlatformRadiusBias=function(self,x, y, z, allow_water, exclude_boats, platform_radius_bias, ignore_land_overhang)
        local valid_tile = self:IsAboveGroundAtPoint(x, y, z, allow_water) or ((not ignore_land_overhang) and self:IsVisualGroundAtPoint(x,y,z) or false)
        if not allow_water and not valid_tile then
            if not exclude_boats then
                local entities = TheSim:FindEntities(x, 0, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS*5 + platform_radius_bias, WALKABLE_PLATFORM_TAGS)
                for i, v in ipairs(entities) do
                    local walkable_platform = v.components.walkableplatform 
                    if walkable_platform~=nil and math.sqrt(v:GetDistanceSqToPoint(x, 0, z))<=(walkable_platform.platform_radius+platform_radius_bias) then
                        local platform_x, platform_y, platform_z = v.Transform:GetWorldPosition()
                        local distance_sq = GLOBAL.VecUtil_LengthSq(x - platform_x, z - platform_z)
                        return distance_sq <= walkable_platform.platform_radius * walkable_platform.platform_radius
                    end
                end
            end
            return false
        end
        return valid_tile
    end
    GLOBAL.Map.CanDeployAtPointInWater=function(self,pt, inst, mouseover, data)
        local tile = self:GetTileAtPoint(pt.x, pt.y, pt.z)
        if tile == GROUND.IMPASSABLE or tile == GROUND.INVALID then
            return false
        end

        -- check if there's a boat in the way
        local min_distance_from_boat = (data and data.boat) or 0
        local radius = (data and data.radius) or 0
        local entities = TheSim:FindEntities(pt.x, 0, pt.z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS*5 + radius + min_distance_from_boat, WALKABLE_PLATFORM_TAGS)
        for i, v in ipairs(entities) do
            if v.components.walkableplatform~=nil and math.sqrt(v:GetDistanceSqToPoint(pt.x, 0, pt.z))<=(v.components.walkableplatform.platform_radius+radius+min_distance_from_boat) then
                return false
            end
        end

        local min_distance_from_land = (data and data.land) or 0

        return (mouseover == nil or mouseover:HasTag("player"))
            and self:IsDeployPointClear(pt, nil, min_distance_from_boat + radius)
            and self:IsSurroundedByWater(pt.x, pt.y, pt.z, min_distance_from_land + radius)
    end
end)

```



### 变体演进：Parryable Shield of Terror (Mod 3135193800)
- **变体场景与切面**：收录来自工坊 Mod 3135193800 (`Parryable Shield of Terror`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3135193800)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:shieldofterror
AddPrefabPostInit("shieldofterror", function(inst)

  inst:AddTag("battleshield")
	inst:AddTag("shield")

  inst:AddTag("parryweapon")

  inst:AddTag("rechargeable")

  inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
    inst.components.aoetargeting:SetAllowRiding(false)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticulearc"
    inst.components.aoetargeting.reticule.pingprefab = "reticulearcping"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true
    --inst.components.aoetargeting.range = 100 --idk why ReticuleMouseTargetFn crashes 

	if not GLOBAL.TheWorld.ismastersim then return inst end
  --inst.components.equippable.restrictedtag = "wathgrithrshieldmaker"

  inst:AddComponent("aoespell")
  inst.components.aoespell:SetSpellFn(SpellFn)

  inst:AddComponent("parryweapon")
  inst.components.parryweapon:SetParryArc(TUNING.WATHGRITHR_SHIELD_PARRY_ARC)
  --inst.components.parryweapon:SetOnPreParryFn(OnPreParry)
  inst.components.parryweapon:SetOnParryFn(OnParry)

  inst:AddComponent("rechargeable")
  inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
  inst.components.rechargeable:SetOnChargedFn(OnCharged)

  --my own component
  inst:AddComponent("shieldbite")
  inst.components.shieldbite:IsMultAffected(parryMult)
  inst.components.shieldbite:SetDamage(parryDamage)
  inst.components.shieldbite:SetRepair(parryRepair)
  inst.components.shieldbite:SetSprites("swap_shield", "swap_shieldofterror_parry", "swap_shieldofterror_bite")


  if inst.components.rechargeable:GetTimeToCharge() < TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONEQUIP then
    inst.components.rechargeable:Discharge(TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONEQUIP)
  end

  inst.components.equippable:SetOnEquip(OnEquip)
  inst.components.equippable:SetOnUnequip(OnUnequip)
  --MakeHauntableLaunch(inst)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:wortox
AddPrefabPostInit("wortox", function(inst)
	local _GetPointSpecialActions = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.wortox.fn, "common_postinit", "OnSetOwner", "GetPointSpecialActions")
	local GetPointSpecialActions = function(inst, pos, useitem, ...)
		local equipitem = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		local ret = _GetPointSpecialActions(inst, pos, useitem, ...)
		if ret ~= nil and #ret > 0 and equipitem ~= nil and equipitem.prefab == "shieldofterror" then
      if equipitem.components.aoetargeting:IsEnabled() == false then return ret end
			ret = {}
		end
		return ret
	end
	UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.wortox.fn, GetPointSpecialActions, "common_postinit", "OnSetOwner", "GetPointSpecialActions")
end)

```



### 变体演进：Wolemorm, Recorrupted Edition (Mod 2293195234)
- **变体场景与切面**：收录来自工坊 Mod 2293195234 (`Wolemorm, Recorrupted Edition`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2293195234)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:lightbulb
AddPrefabPostInit("lightbulb", function(inst) -- I checked all of these and it works
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = PositiveSanity
end)

```



### 变体演进：Mod 2483322788 (Mod 2483322788)
- **变体场景与切面**：收录来自工坊 Mod 2483322788 (`Mod 2483322788`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2483322788)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:sisturn
AddPrefabPostInit("sisturn", function(inst)
    -- 延迟确保组件加载完成
    inst:DoTaskInTime(0, function()
        if inst.components.preserver then
            -- 立即设置保鲜倍率
            inst.components.preserver:SetPerishRateMultiplier(sisturn_freeze)
            
            -- 劫持原始方法，永久锁定保鲜参数
            local old_SetPRM = inst.components.preserver.SetPerishRateMultiplier
            inst.components.preserver.SetPerishRateMultiplier = function(self, ...)
                old_SetPRM(self, sisturn_freeze) -- 强制参数
            end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:portablespicer
AddPrefabPostInit("portablespicer", function(inst)
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(spicer_inside_freeze)

    if spicer_outside_freeze then
        if inst.components.stewer then
            inst.components.stewer.onspoil = nil
            inst.components.stewer.GetTimeToSpoil = function(self)
                return self.done and (self.spoiltime or 99) or 0
            end
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
AddPrefabPostInit("world", function()
        local levels = CollectFood(GLOBAL.Prefabs.mushroom_farm.fn, "updatelevel", "levels")
        local setlevel = CollectFood(GLOBAL.Prefabs.mushroom_farm.fn, "updatelevel", "setlevel")

        local function updatelevel(inst, dotransition)
            if not inst:HasTag("burnt") then
                for k, v in pairs(levels) do
                    if inst.components.harvestable.produce >= v.amount then
                        setlevel(inst, v, dotransition)
                        break
                    end
                end
            end
        end

        EatFood(GLOBAL.Prefabs.mushroom_farm.fn, updatelevel, "updatelevel")
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ocean_trawler
AddPrefabPostInit("ocean_trawler", function(inst)
        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(0)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:chester
AddPrefabPostInit("chester", function(inst)
    if inst.components.preserver == nil then
        inst:AddComponent("preserver")
    end
    inst.components.preserver:SetPerishRateMultiplier(chester_freeze)

    ChesterState = CollectFood(inst.OnLoadPostPass, "ChesterState")
    ToggleBreath = CollectFood(GLOBAL.Prefabs.chester.fn, "OnClientChesterStateDirty", "ToggleBreath")
    EatFood(inst.OnPreLoad, MorphSnowChester, "MorphSnowChester")
end)

```

