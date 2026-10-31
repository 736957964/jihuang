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

### 变体演进：无人自动重置单层世界 (Mod 3552197369)
- **变体场景与切面**：收录来自工坊 Mod 3552197369 (无人自动重置单层世界) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3552197369)
-- ============================================================================
local GLOBAL = GLOBAL


AddComponentPostInit("playerspawner", function(self)
	local _SpawnAtLocation = self.SpawnAtLocation
	self.SpawnAtLocation = function(self, inst, player, x, y, z, isloading, ...)
		_SpawnAtLocation(self, inst, player, x, y, z, isloading, ...)
		-- print("[无人自动重置单层世界] 有玩家到这个世界了！更新该世界最后活跃时间")

		TheWorld.components.AutoRegenerateShard:ResetTime()
	end
end)
`


### 变体演进：Nat (Mod 3661375684)
- **变体场景与切面**：收录来自工坊 Mod 3661375684 (Nat) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3661375684)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("world", function(inst)
    inst:WatchWorldState("season", CleanUp)
end)
`


### 变体演进：Backrooms alpha-v-0.1 (Mod 3786215888)
- **变体场景与切面**：收录来自工坊 Mod 3786215888 (Backrooms alpha-v-0.1) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3786215888)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("world", function(world)
    if not world.ismastersim then return end

    local b_objects_spawned = false

    local function TryPrefab(pref, chance, x, z)
        if math.random()*100 <= chance then
            local prefab = g.SpawnPrefab(pref)
            prefab.Transform:SetPosition(x, 0, z)
            ReadTypes(prefab)
        end
    end

    local function SpawnPrefs(x, z)
        local function getcoords()
            local x,y,z = g.TheWorld.Map:GetTileCenterPoint(x, z)

            return 
            x + math.random(-200, 200) / 100,
            z + math.random(-200, 200) / 100
        end
        
        --ents
        TryPrefab("grass", 2.7, getcoords())
        TryPrefab("marsh_bush", 1.9, getcoords())
        TryPrefab("sapling", .15, getcoords())
        TryPrefab("berrybush2", 1.5, getcoords())
        TryPrefab("halloweenpotion_sanity_small", .25, getcoords())
        TryPrefab("halloweenpotion_sanity_large", .1, getcoords())
        TryPrefab("seastack", .25, getcoords())
        TryPrefab("marsh_tree", 2.4, getcoords())
        TryPrefab("flower_evil", .5, getcoords())
        TryPrefab("bgroundrock", 2.8, getcoords())
        TryPrefab("pond", .5, getcoords())
        TryPrefab("marblepillar", .11, getcoords())
        TryPrefab("wall_scrap", .14, getcoords())
        TryPrefab("rock2", .15, getcoords())
        TryPrefab("rock1", .18, getcoords())
        TryPrefab("moonglass", .3, getcoords())
        TryPrefab("dropperweb", .07, getcoords())
        TryPrefab("pigtorch", .04, getcoords())
        TryPrefab("wood_chair", .02, getcoords())
        TryPrefab("wood_table_square", .02, getcoords())
        TryPrefab("bmaneken", .01, getcoords())
        TryPrefab("archive_centipede", .015, getcoords())
        TryPrefab("houndmound", .012, getcoords())
        TryPrefab("catcoonden", .016, getcoords())
        TryPrefab("deer_fire_circle", .013, getcoords())
    end

    world:DoTaskInTime(.1, function()
        if not b_objects_spawned then
            local map = world.Map
            local width, height = map:GetSize()

            GenerateBioms(TryPrefab)

            for x = 0, width - 1 do
                for y = 0, height - 1 do
                    if map:GetTile(x, y) == 11 then
                        SpawnPrefs(x, y)
                    end

                    if map:GetTile(x, y) ~= 1 then
                        TryPrefab("blight", 8, getcoords2(x, y))
                    end
                end
            end

            b_objects_spawned = true
        end
    end)

    local OldOnSave = world.OnSave
    world.OnSave = function(src, data)
        if OldOnSave then OldOnSave(src, data) end
        data.b_objects_spawned = b_objects_spawned
    end

    local OldOnLoad = world.OnLoad
    world.OnLoad = function(src, data)
        if OldOnLoad then OldOnLoad(src, data) end
        if data and data.b_objects_spawned ~= nil then
            b_objects_spawned = data.b_objects_spawned
        end
    end
end)
`


### 变体演进：共享位置 (Mod 3789721701)
- **变体场景与切面**：收录来自工坊 Mod 3789721701 (共享位置) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3789721701)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then return end
    inst:DoTaskInTime(0, function()
        SyncPlayersToClients()
        inst._remote_player_indicator_sync_task = inst:DoPeriodicTask(SYNC_INTERVAL, SyncPlayersToClients)
    end)
end)

local function GetRealPlayer(userid)
    for _, player in ipairs(AllPlayers) do
        if player:IsValid() and player.userid == userid then
            return player
        end
    end
end
`



### 变体演进：RoseN Farm Blueprints (Mod 3823475990)
- **变体场景与切面**：收录来自工坊 Mod 3823475990 (`RoseN Farm Blueprints`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3823475990)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
if not G.TheNet:IsDedicated() then
    AddPrefabPostInit("world", function(world)
        world:WatchWorldState("season", function(_, season) ApplySeason(season) end)
        -- oyuncu ve HUD hazir olunca bir kez daha (menu ilk acildiginda dogru sirada olsun)
        world:DoTaskInTime(0, function() ApplySeason(world.state.season) end)
        world:ListenForEvent("playeractivated", function() world:DoTaskInTime(0.5, function() ApplySeason(world.state.season) end) end)
    end)
end

```



### 变体演进：Speedrun Timer + Utility Mod (Mod 3765874168)
- **变体场景与切面**：收录来自工坊 Mod 3765874168 (`Speedrun Timer + Utility Mod`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3765874168)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
end
AddComponentPostInit("playercontroller", CleanController)

local function CleanMap(self) --mapwidget.lua
	if CONFIG.MAPCLEAN == "nofow" then return end
	self.bg:SetTexture("images/ui.xml", "white.tex")
	self.bg:SetTint(.05,.05,.05,1)
	self.bg.inst.ImageWidget:SetBlendMode(BLENDMODE.Premultiplied)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
end
AddPrefabPostInit("world", CleanMinimap)

AddPrefabPostInit("world", function(inst) -- ++Zoomzoombang
	if CONFIG.MAPCLEAN == "nohud" then return end
	inst:ListenForEvent("playeractivated", function(self, owner)
		local tw = TheWorld
		local mm = tw.minimap.MiniMap
		local fow = mm.DrawForgottenFogOfWar
		local efow = mm.EnableFogOfWar
		local tp = ThePlayer
		local tpc = tp.player_classified
		if owner ~= tp then return end
		fow(mm, false)
		tpc:ListenForEvent("MapExplorer.learnmap", function() -- Treasure maps
			tp:DoTaskInTime(FRAMES, function(inst)
				fow(mm, false)
				efow(mm, false)
			end)
		end)
		tpc:ListenForEvent("MapSpotRevealer.revealmapspot", function() -- Bottles
			tp:DoTaskInTime(FRAMES, function(inst)
				fow(mm, false)
				efow(mm, false)
			end)
		end)

		local me = tpc.MapExplorer -- Re-enable FoW whenever the map is revealed (from using TMIP+ reveal map function for example)
		if me then
			local oldRA = me.RevealArea
			getmetatable(me).__index.RevealArea = function(...)
				fow(mm, true)
				return oldRA(...)
			end
		end

		local dbgshield = ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls and ThePlayer.HUD.controls.TMI and ThePlayer.HUD.controls.TMI.debugshield and ThePlayer.HUD.controls.TMI.debugshield.children
		if not dbgshield then return end
		local showMapButton = nil
		for i,v in pairs(dbgshield) do
			if v.text and v.text.string == (GLOBAL.STRINGS.TOO_MANY_ITEMS_UI and GLOBAL.STRINGS.TOO_MANY_ITEMS_UI.DEBUG_MAP_SHOW or "Show full map") then
				showMapButton = v
			end
		end

		if not showMapButton then return end
		local onclick_old = showMapButton.onclick
		showMapButton.onclick = function(...) -- Add hack to onclick to force fog when "Show full map" button is clicked
			if TheWorld and TheWorld.minimap and TheWorld.minimap.MiniMap then
				fow(mm, true)
			end
			return onclick_old(...)
		end
	end)
end)

```



### 变体演进：Slash Command Trading (Mod 3007529410)
- **变体场景与切面**：收录来自工坊 Mod 3007529410 (`Slash Command Trading`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3007529410)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

	AddPrefabPostInit("world", ListenForPlayers)
	AddPrefabPostInit("world", FeeItemSetup)
end

--Mod support! Augments the below tables with modded materials should those mods be running
local function TableCombine(table1, table2)
	for k, v in ipairs(table2) do 	
		table1[#table1 + 1] = table2[k]
	end

```



### 变体演进：开局物品 (Mod 3012465209)
- **变体场景与切面**：收录来自工坊 Mod 3012465209 (`开局物品`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3012465209)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

	AddPrefabPostInit("world", function(inst)
		local steamlang = TheNet:GetLanguageCode() or nil
		if steamlang and steam_support_languages[steamlang] then
			print("<Starting NovicePacks> Get your language from steam!")
			modimport("translate_" .. steam_support_languages[steamlang])
		else
			local lang = _G.LanguageTranslator.defaultlang or nil
			if lang ~= nil and support_languages[lang] ~= nil then
				if support_languages[lang] ~= true then
					lang = support_languages[lang]
				end
				print("<Starting NovicePacks> Get your language from language mod!")
				modimport("translate_" .. lang)
			end
		end

		if MY_STRINGS_OVERRIDE ~= nil then
			for k, v in pairs(MY_STRINGS_OVERRIDE) do
				if MY_STRINGS[k] ~= nil then
					MY_STRINGS[k] = v
				end
			end
			MY_STRINGS_OVERRIDE = nil
		end
	end)

```



### 变体演进：超级保镖小Q (Mod 3829871506)
- **变体场景与切面**：收录来自工坊 Mod 3829871506 (`超级保镖小Q`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3829871506)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:xiaoq_body

AddPrefabPostInit("xiaoq_body", function(inst)
    manager:OnBodyPostInit(inst)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:xiaoq_controller

AddPrefabPostInit("xiaoq_controller", function(inst)
    manager:OnControllerPostInit(inst)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:chester
-- 一次性转换成独立 prefab；新存档不再使用原版切斯特。
AddPrefabPostInit("chester", function(inst)
    manager:OnLegacyChesterPostInit(inst)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:trinket_1

AddPrefabPostInit("trinket_1", function(inst)
    manager:OnRingPostInit(inst)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:teleportato_ring

AddPrefabPostInit("teleportato_ring", function(inst)
    manager:OnRingPostInit(inst)
end)

```



### 变体演进：AI NPC - Đừng Chết Đói :) (Mod 3809084975)
- **变体场景与切面**：收录来自工坊 Mod 3809084975 (`AI NPC - Đừng Chết Đói :)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3809084975)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then return end
    inst:AddComponent("ailangquanly")
end)

```



### 变体演进：WX-78 Teleport System (Mod 3780994170)
- **变体场景与切面**：收录来自工坊 Mod 3780994170 (`WX-78 Teleport System`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3780994170)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
    -- ============================================
    AddPrefabPostInit("world", function(world)
        WX78BodyBind.load()

        world:ListenForEvent("playeractivated", function()
            WX78BodyBind.load()

            GLOBAL.TheWorld:DoTaskInTime(0.5, function()
                for _, e in pairs(GLOBAL.Ents) do
                    if e:IsValid() and e.prefab == "wx78_backupbody" then
                        WX78BodyBind.HookSingleBody(e)
                    end
                    
                end
                if WX78BodyBind.HookAllBodies ~= nil then
                    WX78BodyBind.HookAllBodies()
                end
            end)
        end)
    end)

```



### 变体演进：Iridescent Insight (Mod 3658027558)
- **变体场景与切面**：收录来自工坊 Mod 3658027558 (`Iridescent Insight`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3658027558)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified
--------------------------------------------------------------------------------
AddPrefabPostInit("player_classified", function(inst)
    inst.insight_bonus = net_byte(inst.GUID, "insight_bonus", "insight_bonus_dirty")
    if not TheNet:GetIsServer() then
        inst:ListenForEvent("insight_bonus_dirty", function(inst)
            if inst._parent then
                inst._parent:PushEvent("newskillpointupdated")
                inst._parent:PushEvent("refreshskilltree")
            end
        end)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
    
    AddPrefabPostInit("world", function(inst)
        -- 初始化一个表，用来存所有玩家的数据： { ["KU_xxxx"] = 3, ["KU_yyyy"] = 1 }
        inst._insight_user_bank = {}

        -- A. 世界存档
        local old_OnSave = inst.OnSave
        inst.OnSave = function(inst)
            local data = (old_OnSave and old_OnSave(inst)) or {}
            data.insight_user_bank = inst._insight_user_bank
            return data
        end

        -- B. 世界读档
        local old_OnLoad = inst.OnLoad
        inst.OnLoad = function(inst, data)
            if old_OnLoad then old_OnLoad(inst, data) end
            if data and data.insight_user_bank then
                inst._insight_user_bank = data.insight_user_bank
            end
        end

        -- C. 玩家进入/重生监听 (不仅是Join，Respawn也会触发检查)
        inst:ListenForEvent("ms_playerjoined", function(src, player)
            if not player or not player.userid then return end
            
            -- 稍微延迟一点，确保玩家组件初始化完毕
            player:DoTaskInTime(0, function()
                if player.components.skilltreeupdater then
                    local bank = inst._insight_user_bank or {}
                    local saved_val = bank[player.userid] or 0
                    
                    -- 如果银行里有钱，直接覆盖玩家当前状态
                    if saved_val > 0 then
                        player.components.skilltreeupdater._insight_bonus = saved_val
                        SyncToClient(player, saved_val)
                        -- print("[InsightMod] Loaded " .. saved_val .. " points from World Bank for " .. player.userid)
                    end
                end
            end)
        end)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:skilltreeupdater
--------------------------------------------------------------------------------
AddComponentPostInit("skilltreeupdater", function(self)
    self._insight_bonus = 0

    -- 依然保留组件存档作为备份 (兼容旧数据)
    local old_OnSave = self.OnSave
    self.OnSave = function(self)
        local data = (old_OnSave and old_OnSave(self)) or {}
        if self._insight_bonus > 0 then
            data.insight_bonus = self._insight_bonus
        end
        return data
    end

    local old_OnLoad = self.OnLoad
    self.OnLoad = function(self, data)
        if old_OnLoad then old_OnLoad(self, data) end
        if data and data.insight_bonus then
            local val = math.min(data.insight_bonus, MAX_BONUS)
            self._insight_bonus = val
            SyncToClient(self.inst, val)
            
            -- 如果是从旧存档读出来的，立刻同步到世界银行，防止下次换人丢失
            DepositToBank(self.inst, val)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:opalpreciousgem

AddPrefabPostInit("opalpreciousgem", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end
    if not inst.components.healer then inst:AddComponent("healer") end
    inst.components.healer:SetHealthAmount(0)
    inst.components.healer:SetOnHealFn(function(inst, target)
        if target:HasTag("player") then
            local success = UseGemOnPlayer(inst, target)
            if not success then
                target:DoTaskInTime(0, function()
                    if target.components.inventory then
                        local gem = SpawnPrefab("opalpreciousgem")
                        if not target.components.inventory:GiveItem(gem) then
                            gem.Transform:SetPosition(target.Transform:GetWorldPosition())
                        end
                    end
                end)
            end
        end
    end)
end)

```



### 变体演进：Proximity Voice (Mumble Bridge) (Mod 3814261116)
- **变体场景与切面**：收录来自工坊 Mod 3814261116 (`Proximity Voice (Mumble Bridge)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814261116)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", StartTracking)
AddPrefabPostInit("forest", StartTracking)
AddPrefabPostInit("cave", StartTracking)

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0.5, function()
        if inst == GLOBAL.ThePlayer then
            StartTracking(inst)
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:forest
AddPrefabPostInit("world", StartTracking)
AddPrefabPostInit("forest", StartTracking)
AddPrefabPostInit("cave", StartTracking)

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0.5, function()
        if inst == GLOBAL.ThePlayer then
            StartTracking(inst)
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cave
AddPrefabPostInit("forest", StartTracking)
AddPrefabPostInit("cave", StartTracking)

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0.5, function()
        if inst == GLOBAL.ThePlayer then
            StartTracking(inst)
        end
    end)
end)

```



### 变体演进：海钓随机S (Mod 2948102707)
- **变体场景与切面**：收录来自工坊 Mod 2948102707 (`海钓随机S`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2948102707)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    if TheWorld.ismastersim then --判断是不是主机
    
        inst:AddComponent("daywalkerspawner") -- 添加噩梦猪人boss刷新组件

        if inst.components.worldstate and inst.components.worldstate.data and inst.components.worldstate.data.new_fishing == nil then --利用组件保存
            inst.components.worldstate.data.new_fishing = {} -- 仅第一次进入游戏
        end
        inst:ListenForEvent("ms_playerspawn", function(inst, player)
            local CurrentOnNewSpawn = player.OnNewSpawn or function() return true end -- 记录角色本身开局物品
            player.OnNewSpawn = function(...)
                if IsStart(player.userid) then
                    player.components.inventory.ignoresound = true
                    player.components.inventory:GiveItem(SpawnPrefab("boat_grass_item")) --船套装
                    player.components.inventory:GiveItem(SpawnPrefab("oar")) --桨
                    player.components.inventory:GiveItem(SpawnPrefab("wathgrithrhat")) --战斗头盔
                    player.components.inventory:GiveItem(SpawnPrefab("featheredtunic")) --羽饰外衣
                    player.components.inventory:GiveItem(SpawnPrefab("hambat"))--火腿棒
                    player.components.inventory:GiveItem(SpawnPrefab("amulet"))--复活
                end
                -- 赌狗模式 额外赠送火把
                if gambling_dog then
                    player.components.inventory:GiveItem(SpawnPrefab("torch")) --火把
                end
                -- 特殊的海钓竿
                local of = SpawnPrefab("oceanfishingrod")
                if of.components.binding == nil then
                    of:AddComponent("binding")
                end
                player.components.inventory:GiveItem(of) --海钓杆  

                return CurrentOnNewSpawn(...)
            end
        end)
        inst:DoTaskInTime(0,function()
            -- 记录岛id
            local lands = {}

            for i, id in ipairs(TheWorld.topology.ids) do -- 旧档新添加岛屿, 不会改变顺序
                local str = string.split(id,":")
                if str[1] == "StaticLayoutIsland" then
                    table.insert(lands,i)
                end
            end 
            -- 原本想就默认boss岛中间生成
            -- if string.find(TheWorld.topology.ids[i],"OceanBoss") then
            --     local node = TheWorld.topology.nodes[i]
            --     lunarrift_portal_point = {node.x, node.y}
            -- end

            TheWorld.topology.lands = lands
            if TheWorld.components.messagebottlemanager then 
                TheWorld.components.messagebottlemanager.lands = lands
            end
            
            -- 记录可选裂缝坐标
            if not TheWorld.lunarrift_portal_points then 
                TheWorld.lunarrift_portal_points = SelectArea(lands)
            end

            RIFTPORTAL_FNS.CreateRiftPortalDefinition("lunarrift_portal", {
                GetNextRiftSpawnLocation = function(_map, rift_def)
                    local points = TheWorld.lunarrift_portal_points or {}
                    shuffleArray(points) --洗牌打乱
                    local function existlunarrift(x,y)  -- 在60范围内存在裂缝
                        for i, v in ipairs(TheSim:FindEntities(x, 0, y, 60, {"lunarrift_portal"})) do
                            return true
                        end
                    end

                    for i, v in ipairs(points) do --可能存在非常差劲的情况, 毕竟岛小
                        if not existlunarrift(v[1], v[2]) then
                            return v[1], v[2]
                        end
                    end

                    -- 可能一个也没有
                end,
                Affinity = RIFTPORTAL_CONST.AFFINITY.LUNAR,
            })
        end)       
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:messagebottlemanager
-- messagebottlemanager -- 使得瓶子可以查看其他岛屿
AddComponentPostInit("messagebottlemanager",function(self)
    self.lands = nil
    -- 希望有兼容效果
    if self.player_lands == nil then
        self.player_lands = {} -- 记录玩家查看过的岛屿
        local old_UseMessageBottle = self.UseMessageBottle
        self.UseMessageBottle = function(self, bottle, doer, is_not_from_hermit)
            if self.player_lands[doer.userid] == nil then
                self.player_lands[doer.userid] = {}
            end
            for k,i in pairs(self.lands) do
                if table.reverselookup(self.player_lands[doer.userid],i) == nil then
                    table.insert(self.player_lands[doer.userid],i)

                    local node = TheWorld.topology.nodes[i]
                    -- local x,z = TheWorld.Map:GetRandomPointsForSite(node.x, node.y, node.poly, 1) --本来想随机一点的 出bug 就不要啦
                    -- return Vector3(x,0,z), "REVEAL_OTHER_ISLANDS"
                    return Vector3(node.x, 0, node.y), "REVEAL_OTHER_ISLANDS"
                end
            end
            return old_UseMessageBottle(self, bottle, doer, is_not_from_hermit)
        end

        local old_Save = self.OnSave
        local old_Load = self.OnLoad

        self.OnSave = function(self)
            local data = old_Save(self) or {}

            if next(self.player_lands) ~= nil then
                data.player_lands = self.player_lands
            end

            return data        
        end

        self.OnLoad = function(self,data)
            old_Load(self,data)
            if data ~= nil then
                if data.player_lands ~= nil and next(data.player_lands) ~= nil then
                    for k, v in pairs(data.player_lands) do
                        self.player_lands[k] = v
                    end
                end            
            end 
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:alterguardian_phase3dead
-- 清理当前世界上召唤天体英雄的组件，防止数量太多
AddPrefabPostInit("alterguardian_phase3dead", function(inst)
    inst:DoTaskInTime(0,function(inst)
        TheWorld:PushEvent("onremove_alterguardian")
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:alterguardian_phase3trap
-- 启迪陷阱 不要月亮碎片
AddPrefabPostInit("alterguardian_phase3trap",function(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:SetLoot({})
        -- inst.components.lootdropper.ifnotchanceloot = nil
        inst.components.lootdropper.chanceloottable = nil
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:trap_teeth_maxwell
-- 修改麦斯威尔的犬牙陷阱
AddPrefabPostInit("trap_teeth_maxwell", function(inst)
    if TheWorld.ismastersim then --判断是不是主机
        if inst.components.mine then
            inst.components.mine:SetRadius(1.5)
            inst.components.mine:SetTestTimeFn(function()return 0.75 end)
        end
    end
end)

```

