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



### 变体演进：Kitcoon Thing (Mod 2881794081)
- **变体场景与切面**：收录来自工坊 Mod 2881794081 (`Kitcoon Thing`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2881794081)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

Usually you'll want to be making these changes from an AddPrefabPostInit("world", function(inst) end),

```



### 变体演进：自动盾反 (Mod 3804641395)
- **变体场景与切面**：收录来自工坊 Mod 3804641395 (`自动盾反`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3804641395)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(world)
  Autoshield:CheckMods()
  world:ListenForEvent("playeractivated", function()
    if not TUNING.Shieldthread then
      Autoshield:autoshield(true)
    end
  end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:siving_boss_root
--子规突触
AddPrefabPostInit('siving_boss_root', function(self)
  self:DoTaskInTime(0, function()
    if math.sqrt(distsq(ThePlayer:GetPosition(), self:GetPosition())) < 2 then
      local boss = FindEntity(ThePlayer, 20,
        function(inst)
          return inst.prefab == "siving_foenix" or inst.prefab == "siving_moenix"
        end)
      self:DoTaskInTime(boss and (6 * FRAMES) or (5 * FRAMES), function()
        Autoshield:DoShield()
      end)
    end
  end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:siving_feather_line
--自动收回
AddPrefabPostInit("siving_feather_line", function(inst)
  inst:DoTaskInTime(5 * FRAMES, function()
    SendRPCToServer(RPC.RightClick, ACTIONS.RC_SKILL_L.code, ThePlayer:GetPosition().x,
      ThePlayer:GetPosition().z, nil, nil,
      nil, nil, nil, ACTIONS.RC_SKILL_L.mod_name, nil,
      false)
  end)
end)

```



### 变体演进：Mod 3273044599 (Mod 3273044599)
- **变体场景与切面**：收录来自工坊 Mod 3273044599 (`Mod 3273044599`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3273044599)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
end
AddPrefabPostInit("world", function()
	for prefab, soundfiles in pairs(PREFAB_SOUNDFILES) do 
		local fn = GLOBAL.Prefabs and GLOBAL.Prefabs[prefab]
		if fn and fn.assets then
			for k,v in ipairs(soundfiles) do
				table.insert(fn.assets, v)
			end
		end
	end

	RemapSoundEvent("dontstarve/creatures/perd/hurt", "perd_kun/perd_kun/hurt")
	RemapSoundEvent("dontstarve/creatures/perd/death", "perd_kun/perd_kun/death")
	RemapSoundEvent("dontstarve/creatures/perd/scream", "perd_kun/perd_kun/scream")

	RemapSoundEvent("dontstarve/creatures/pengull/attack", "penguin_qqcoin/penguin_qqcoin/attack")
--	RemapSoundEvent("dontstarve/creatures/pengull/taunt", "penguin_qqcoin/penguin_qqcoin/taunt")
end)

```



### 变体演进：Show Nicknames FIXED (Mod 3395794288)
- **变体场景与切面**：收录来自工坊 Mod 3395794288 (`Show Nicknames FIXED`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3395794288)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
 ,           modmain.lua,
  w  state      AddPrefabPostInit("world").

mods -   (    ).
mods.lib -   ( )      ,   .
mods.lib.version -  

--]]
if _silence == nil then
	print(_version,modinfo.name) --Show current version of lib
end


--[[
--  ,  , ,            -.
if mods.lib then
	return
end
--]]

--[[
,     :
	1)   .    - .
	2)  N- .           ,   .
    old_lib.       .   ,  .
  ,   ( ) .   .
--]]
local old_lib = mods.lib or {} -- ,    nil

--     .   ,   .
if old_lib._libStopWorking then
	old_lib._libStopWorking()
end

--      ,       .
local IS_ACTIVE = true -- ,    .     .
local function _libStopWorking()
	--  .     .
	--,  ,   ,   .
	IS_ACTIVE = nil
	--       ,     .
	--       ().
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:forest
AddPrefabPostInit("world",world_init)
--AddPrefabPostInit("forest",world_init)
--    , ..   forest .


-- .    -  -,   ,    - .
local EmptyFunction = function() end

```



### 变体演进：Moon Cycle Calendar (Mod 3776472552)
- **变体场景与切面**：收录来自工坊 Mod 3776472552 (`Moon Cycle Calendar`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3776472552)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(world)
	local observer = EnsureObserver(world)
	if observer ~= nil then
		world:ListenForEvent("playeractivated", function(_, player)
			if player == _G.ThePlayer then
				world:DoStaticTaskInTime(0, function()
					if world:IsValid() then
						observer:Sync()
						observer:CheckReminders()
					end
				end)
			end
		end)
	end
end)

```



### 变体演进：Withered Foxy Jumpscare Every Second [Server , Configurable , Commands] (Mod 3631087563)
- **变体场景与切面**：收录来自工坊 Mod 3631087563 (`Withered Foxy Jumpscare Every Second [Server , Configurable , Commands]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3631087563)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
if syncronized == false then --this is pretty much just an identical version of the original client-side mod, but set to all_clients_require.
    AddPrefabPostInit("world",function()
        if not GLOBAL.TheWorld.ismastersim then
            GLOBAL.TheFrontEnd.screenroot.inst:DoPeriodicTask(1,function()
                if math.random(1,prob) == 1 then
                    JumpscarePlayer()
                end
            end)
        end
    end)

```



### 变体演进：Popo (Mod 3768627730)
- **变体场景与切面**：收录来自工坊 Mod 3768627730 (`Popo`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3768627730)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller
-- own list of vanilla HUD cases. Mods load after it, so this gets the last word.
AddComponentPostInit("playercontroller", function(pc)
  local old_is_enabled = pc.IsEnabled
  pc.IsEnabled = function(self, ...)
    if CTRL.IsNavigating() then return false, true end
    return old_is_enabled(self, ...)
  end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(world)
  world:ListenForEvent("playeractivated", function(_, player)
    if player ~= _G.ThePlayer then return end
    -- Insight already serves exact closed-chest counts, so skip the disk file
    -- (session memory still runs, covering Insight's async lag on fresh moves).
    MEM.Configure({ persist = not InsightProvidesCounts(player) })
    MEM.Load()
    player:DoPeriodicTask(30, function() MEM.Save() end)
    player:ListenForEvent("onremove", function()
      EXE.Cancel()
      MEM.Save()
    end)
  end)
end)

```



### 变体演进：时钟险境 (Mod 3672713533)
- **变体场景与切面**：收录来自工坊 Mod 3672713533 (`时钟险境`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3672713533)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:forest_network

AddPrefabPostInit("forest_network", OnWorldNetworkPostInit)
AddPrefabPostInit("cave_network", OnWorldNetworkPostInit)

AddPrefabPostInit("world", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    local _orig_OnSave = inst.OnSave
    inst.OnSave = function(inst, data)
        if _orig_OnSave then
            _orig_OnSave(inst, data)
        end
        local save_data = Server.OnSave()
        if save_data then
            data.clock_peril = save_data
        end
    end

    local _orig_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if _orig_OnLoad then
            _orig_OnLoad(inst, data)
        end
        if data and data.clock_peril then
            Server.OnLoad(data.clock_peril)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cave_network
AddPrefabPostInit("forest_network", OnWorldNetworkPostInit)
AddPrefabPostInit("cave_network", OnWorldNetworkPostInit)

AddPrefabPostInit("world", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    local _orig_OnSave = inst.OnSave
    inst.OnSave = function(inst, data)
        if _orig_OnSave then
            _orig_OnSave(inst, data)
        end
        local save_data = Server.OnSave()
        if save_data then
            data.clock_peril = save_data
        end
    end

    local _orig_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if _orig_OnLoad then
            _orig_OnLoad(inst, data)
        end
        if data and data.clock_peril then
            Server.OnLoad(data.clock_peril)
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    local _orig_OnSave = inst.OnSave
    inst.OnSave = function(inst, data)
        if _orig_OnSave then
            _orig_OnSave(inst, data)
        end
        local save_data = Server.OnSave()
        if save_data then
            data.clock_peril = save_data
        end
    end

    local _orig_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if _orig_OnLoad then
            _orig_OnLoad(inst, data)
        end
        if data and data.clock_peril then
            Server.OnLoad(data.clock_peril)
        end
    end
end)

```



### 变体演进：Fabin (Mod 3760230465)
- **变体场景与切面**：收录来自工坊 Mod 3760230465 (`Fabin`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3760230465)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:dynamicmusic
	local TRIGGERED_DANGER_MUSIC
	env.AddComponentPostInit("dynamicmusic", function(self) 
		local inst, source, OnPlayerActivated = self.inst, "scripts/components/dynamicmusic.lua", nil
		for i, func in ipairs(inst.event_listeners["playeractivated"][inst]) do
			if _G.debug.getinfo(func, "S").source == source then
				OnPlayerActivated = inst.event_listeners["playeractivated"][inst][i]
				break
			end
		end
		
		local StartPlayerListeners 		= UpvalueHacker.GetUpvalue(OnPlayerActivated, "StartPlayerListeners")
		local StartTriggeredDanger 		= UpvalueHacker.GetUpvalue(StartPlayerListeners, "StartTriggeredDanger")
			  TRIGGERED_DANGER_MUSIC 	= UpvalueHacker.GetUpvalue(StartTriggeredDanger, "TRIGGERED_DANGER_MUSIC")
		
		if not (StartPlayerListeners and StartTriggeredDanger and TRIGGERED_DANGER_MUSIC) then return end
		
		----------------------------------------
		
		local shadowchess = 
		{
			"dontstarve/music/music_danger_ruins",						-- level 1 (Phase 1 Battle)
			"shadowchess/music/music_epicfight_shadowchess_2_stinger", 	-- level 2 (Phase 1->2 Intermission)
			"shadowchess/music/music_epicfight_shadowchess_2",			-- level 3 (Phase 2 Battle)
			"shadowchess/music/music_epicfight_shadowchess_3_stinger",  -- level 4 (Phase 2->3 Intermission)
			"shadowchess/music/music_epicfight_shadowchess_3",			-- level 5 (Phase 3 Battle)
		}
		
		local twinsofterror = {
			"dst_twins/music/music_main_tot"
		}
		
		local moonmaw = {
			"dst_moonmaw/music/music_epicfight_moonmaw"
		}
		--------------------
		
		TRIGGERED_DANGER_MUSIC.shadowchess = shadowchess
		TRIGGERED_DANGER_MUSIC.twinsofterror = twinsofterror
		TRIGGERED_DANGER_MUSIC.moonmaw = moonmaw
		table.insert(TRIGGERED_DANGER_MUSIC.wagboss, "dstust/music/music_epicfight_alterguardian_lunarrift")
		table.insert(TRIGGERED_DANGER_MUSIC.vault, "dstust/music/music_epicfight_pillarguard_intense")
	end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shadow_bishop

	env.AddPrefabPostInit("shadow_bishop", ForceMusic)
	env.AddPrefabPostInit("shadow_knight", ForceMusic)
	env.AddPrefabPostInit("shadow_rook", ForceMusic)

	--	[[			Twins Of Terror			]]

	local function TwinsPushMusic(inst)
		if _G.ThePlayer == nil or inst:HasTag("INLIMBO") then
			inst._playingmusic = false
		elseif _G.ThePlayer:IsNear(inst, inst._playingmusic and 60 or 20) then
			inst._playingmusic = true
			_G.ThePlayer:PushEvent("triggeredevent", { name = inst:HasTag("mech") and "twinsofterror" or "eyeofterror" })
		elseif inst._playingmusic and not _G.ThePlayer:IsNear(inst, 64) then
			inst._playingmusic = false
		end
	end

	local function TwinsOnMusicDirty(inst)
		if not _G.TheNet:IsDedicated() then
			if inst._musictask ~= nil then
				inst._musictask:Cancel()
			end
			inst._musictask = inst:DoPeriodicTask(1, TwinsPushMusic, 0.5)
		end
	end
	
	--	[[			Celestial Revenant			]]

	local function RevenantPushMusic(inst)
		if _G.ThePlayer == nil or inst:HasTag("nomusic") then
			inst._playingmusic = false
			return
		end

		if _G.ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
			inst._playingmusic = true
			local is_rift = inst.AnimState:GetBuild() == "alterguardian_phase1_lunarrift"
			
			local event = is_rift
				and { name = "wagboss", level = 4 }
				or  { name = "alterguardian_phase1", duration = 2 }
				
			_G.ThePlayer:PushEvent("triggeredevent", event)
		elseif inst._playingmusic and not _G.ThePlayer:IsNear(inst, 50) then
			inst._playingmusic = false
		end
	end
	
	--	[[			Pillar Guards			]]
	-- this one's really simple, since its just a component i can hook into!
	
	env.AddComponentPostInit("vaultmusiclistener", function(self)
		local OldOnUpdate = self.OnUpdate
		self.OnUpdate = function(self, dt)
			if dt < self.delay then
				OldOnUpdate(self, dt)
				return
			end

			local isaggro = false
			if self.lastaggrotime then
				if self.lastaggrotime + 1.5 > _G.GetTime() then
					isaggro = true
				else
					self.lastaggrotime = nil
				end
			end

			if isaggro then
				local x, y, z = self.inst.Transform:GetWorldPosition()
				
				local guards = _G.TheSim:FindEntities(x, y, z, 80, { "vault_pillar_guard" }, { "INLIMBO" })
				local guard_count = 0
				for _, guard in ipairs(guards) do
					if guard:IsValid() and not (guard.replica.health and guard.replica.health:IsDead()) then
						guard_count = guard_count + 1
					end
				end

				local SHADOW_MUSTHAVE_TAGS = { "shadowcreature", "monster", "hostile", "shadow" }
				local monsters = _G.TheSim:FindEntities(x, y, z, 80, SHADOW_MUSTHAVE_TAGS, { "INLIMBO" })
				local shadow_count = 0
				for _, monster in ipairs(monsters) do
					if monster:IsValid() and not (monster.replica.health and monster.replica.health:IsDead()) then
						shadow_count = shadow_count + 1
					end
				end

				if guard_count <= 2 or shadow_count >= 2 then
					if self.level == 3 then
						-- transition thru silence first??
						self.level = 2
						self.delay = 1
					else
						self.level = 4
						self.delay = 1
					end
					self.inst:PushEvent("triggeredevent", { name = "vault", level = self.level })
				else
					OldOnUpdate(self, dt)
				end
			else
				OldOnUpdate(self, dt)
			end
		end
	end)

	--	[[			Function Hacking			]]

	env.AddPrefabPostInit("world", function(inst)
		UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_bishop.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		-- UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_knight.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		-- UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_rook.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		
		UpvalueHacker.SetUpvalue(_G.Prefabs.eyeofterror.fn, TwinsPushMusic, "common_fn", "OnMusicDirty", "PushMusic")
		
		UpvalueHacker.SetUpvalue(_G.Prefabs.alterguardian_phase1.fn, RevenantPushMusic, "commonfn", "OnMusicDirty", "PushMusic")
	end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shadow_knight
	env.AddPrefabPostInit("shadow_bishop", ForceMusic)
	env.AddPrefabPostInit("shadow_knight", ForceMusic)
	env.AddPrefabPostInit("shadow_rook", ForceMusic)

	--	[[			Twins Of Terror			]]

	local function TwinsPushMusic(inst)
		if _G.ThePlayer == nil or inst:HasTag("INLIMBO") then
			inst._playingmusic = false
		elseif _G.ThePlayer:IsNear(inst, inst._playingmusic and 60 or 20) then
			inst._playingmusic = true
			_G.ThePlayer:PushEvent("triggeredevent", { name = inst:HasTag("mech") and "twinsofterror" or "eyeofterror" })
		elseif inst._playingmusic and not _G.ThePlayer:IsNear(inst, 64) then
			inst._playingmusic = false
		end
	end

	local function TwinsOnMusicDirty(inst)
		if not _G.TheNet:IsDedicated() then
			if inst._musictask ~= nil then
				inst._musictask:Cancel()
			end
			inst._musictask = inst:DoPeriodicTask(1, TwinsPushMusic, 0.5)
		end
	end
	
	--	[[			Celestial Revenant			]]

	local function RevenantPushMusic(inst)
		if _G.ThePlayer == nil or inst:HasTag("nomusic") then
			inst._playingmusic = false
			return
		end

		if _G.ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
			inst._playingmusic = true
			local is_rift = inst.AnimState:GetBuild() == "alterguardian_phase1_lunarrift"
			
			local event = is_rift
				and { name = "wagboss", level = 4 }
				or  { name = "alterguardian_phase1", duration = 2 }
				
			_G.ThePlayer:PushEvent("triggeredevent", event)
		elseif inst._playingmusic and not _G.ThePlayer:IsNear(inst, 50) then
			inst._playingmusic = false
		end
	end
	
	--	[[			Pillar Guards			]]
	-- this one's really simple, since its just a component i can hook into!
	
	env.AddComponentPostInit("vaultmusiclistener", function(self)
		local OldOnUpdate = self.OnUpdate
		self.OnUpdate = function(self, dt)
			if dt < self.delay then
				OldOnUpdate(self, dt)
				return
			end

			local isaggro = false
			if self.lastaggrotime then
				if self.lastaggrotime + 1.5 > _G.GetTime() then
					isaggro = true
				else
					self.lastaggrotime = nil
				end
			end

			if isaggro then
				local x, y, z = self.inst.Transform:GetWorldPosition()
				
				local guards = _G.TheSim:FindEntities(x, y, z, 80, { "vault_pillar_guard" }, { "INLIMBO" })
				local guard_count = 0
				for _, guard in ipairs(guards) do
					if guard:IsValid() and not (guard.replica.health and guard.replica.health:IsDead()) then
						guard_count = guard_count + 1
					end
				end

				local SHADOW_MUSTHAVE_TAGS = { "shadowcreature", "monster", "hostile", "shadow" }
				local monsters = _G.TheSim:FindEntities(x, y, z, 80, SHADOW_MUSTHAVE_TAGS, { "INLIMBO" })
				local shadow_count = 0
				for _, monster in ipairs(monsters) do
					if monster:IsValid() and not (monster.replica.health and monster.replica.health:IsDead()) then
						shadow_count = shadow_count + 1
					end
				end

				if guard_count <= 2 or shadow_count >= 2 then
					if self.level == 3 then
						-- transition thru silence first??
						self.level = 2
						self.delay = 1
					else
						self.level = 4
						self.delay = 1
					end
					self.inst:PushEvent("triggeredevent", { name = "vault", level = self.level })
				else
					OldOnUpdate(self, dt)
				end
			else
				OldOnUpdate(self, dt)
			end
		end
	end)

	--	[[			Function Hacking			]]

	env.AddPrefabPostInit("world", function(inst)
		UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_bishop.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		-- UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_knight.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		-- UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_rook.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		
		UpvalueHacker.SetUpvalue(_G.Prefabs.eyeofterror.fn, TwinsPushMusic, "common_fn", "OnMusicDirty", "PushMusic")
		
		UpvalueHacker.SetUpvalue(_G.Prefabs.alterguardian_phase1.fn, RevenantPushMusic, "commonfn", "OnMusicDirty", "PushMusic")
	end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shadow_rook
	env.AddPrefabPostInit("shadow_knight", ForceMusic)
	env.AddPrefabPostInit("shadow_rook", ForceMusic)

	--	[[			Twins Of Terror			]]

	local function TwinsPushMusic(inst)
		if _G.ThePlayer == nil or inst:HasTag("INLIMBO") then
			inst._playingmusic = false
		elseif _G.ThePlayer:IsNear(inst, inst._playingmusic and 60 or 20) then
			inst._playingmusic = true
			_G.ThePlayer:PushEvent("triggeredevent", { name = inst:HasTag("mech") and "twinsofterror" or "eyeofterror" })
		elseif inst._playingmusic and not _G.ThePlayer:IsNear(inst, 64) then
			inst._playingmusic = false
		end
	end

	local function TwinsOnMusicDirty(inst)
		if not _G.TheNet:IsDedicated() then
			if inst._musictask ~= nil then
				inst._musictask:Cancel()
			end
			inst._musictask = inst:DoPeriodicTask(1, TwinsPushMusic, 0.5)
		end
	end
	
	--	[[			Celestial Revenant			]]

	local function RevenantPushMusic(inst)
		if _G.ThePlayer == nil or inst:HasTag("nomusic") then
			inst._playingmusic = false
			return
		end

		if _G.ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
			inst._playingmusic = true
			local is_rift = inst.AnimState:GetBuild() == "alterguardian_phase1_lunarrift"
			
			local event = is_rift
				and { name = "wagboss", level = 4 }
				or  { name = "alterguardian_phase1", duration = 2 }
				
			_G.ThePlayer:PushEvent("triggeredevent", event)
		elseif inst._playingmusic and not _G.ThePlayer:IsNear(inst, 50) then
			inst._playingmusic = false
		end
	end
	
	--	[[			Pillar Guards			]]
	-- this one's really simple, since its just a component i can hook into!
	
	env.AddComponentPostInit("vaultmusiclistener", function(self)
		local OldOnUpdate = self.OnUpdate
		self.OnUpdate = function(self, dt)
			if dt < self.delay then
				OldOnUpdate(self, dt)
				return
			end

			local isaggro = false
			if self.lastaggrotime then
				if self.lastaggrotime + 1.5 > _G.GetTime() then
					isaggro = true
				else
					self.lastaggrotime = nil
				end
			end

			if isaggro then
				local x, y, z = self.inst.Transform:GetWorldPosition()
				
				local guards = _G.TheSim:FindEntities(x, y, z, 80, { "vault_pillar_guard" }, { "INLIMBO" })
				local guard_count = 0
				for _, guard in ipairs(guards) do
					if guard:IsValid() and not (guard.replica.health and guard.replica.health:IsDead()) then
						guard_count = guard_count + 1
					end
				end

				local SHADOW_MUSTHAVE_TAGS = { "shadowcreature", "monster", "hostile", "shadow" }
				local monsters = _G.TheSim:FindEntities(x, y, z, 80, SHADOW_MUSTHAVE_TAGS, { "INLIMBO" })
				local shadow_count = 0
				for _, monster in ipairs(monsters) do
					if monster:IsValid() and not (monster.replica.health and monster.replica.health:IsDead()) then
						shadow_count = shadow_count + 1
					end
				end

				if guard_count <= 2 or shadow_count >= 2 then
					if self.level == 3 then
						-- transition thru silence first??
						self.level = 2
						self.delay = 1
					else
						self.level = 4
						self.delay = 1
					end
					self.inst:PushEvent("triggeredevent", { name = "vault", level = self.level })
				else
					OldOnUpdate(self, dt)
				end
			else
				OldOnUpdate(self, dt)
			end
		end
	end)

	--	[[			Function Hacking			]]

	env.AddPrefabPostInit("world", function(inst)
		UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_bishop.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		-- UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_knight.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		-- UpvalueHacker.SetUpvalue(_G.Prefabs.shadow_rook.fn, OnMusicDirty, "commonfn", "OnMusicDirty")
		
		UpvalueHacker.SetUpvalue(_G.Prefabs.eyeofterror.fn, TwinsPushMusic, "common_fn", "OnMusicDirty", "PushMusic")
		
		UpvalueHacker.SetUpvalue(_G.Prefabs.alterguardian_phase1.fn, RevenantPushMusic, "commonfn", "OnMusicDirty", "PushMusic")
	end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:vaultmusiclistener
	
	env.AddComponentPostInit("vaultmusiclistener", function(self)
		local OldOnUpdate = self.OnUpdate
		self.OnUpdate = function(self, dt)
			if dt < self.delay then
				OldOnUpdate(self, dt)
				return
			end

			local isaggro = false
			if self.lastaggrotime then
				if self.lastaggrotime + 1.5 > _G.GetTime() then
					isaggro = true
				else
					self.lastaggrotime = nil
				end
			end

			if isaggro then
				local x, y, z = self.inst.Transform:GetWorldPosition()
				
				local guards = _G.TheSim:FindEntities(x, y, z, 80, { "vault_pillar_guard" }, { "INLIMBO" })
				local guard_count = 0
				for _, guard in ipairs(guards) do
					if guard:IsValid() and not (guard.replica.health and guard.replica.health:IsDead()) then
						guard_count = guard_count + 1
					end
				end

				local SHADOW_MUSTHAVE_TAGS = { "shadowcreature", "monster", "hostile", "shadow" }
				local monsters = _G.TheSim:FindEntities(x, y, z, 80, SHADOW_MUSTHAVE_TAGS, { "INLIMBO" })
				local shadow_count = 0
				for _, monster in ipairs(monsters) do
					if monster:IsValid() and not (monster.replica.health and monster.replica.health:IsDead()) then
						shadow_count = shadow_count + 1
					end
				end

				if guard_count <= 2 or shadow_count >= 2 then
					if self.level == 3 then
						-- transition thru silence first??
						self.level = 2
						self.delay = 1
					else
						self.level = 4
						self.delay = 1
					end
					self.inst:PushEvent("triggeredevent", { name = "vault", level = self.level })
				else
					OldOnUpdate(self, dt)
				end
			else
				OldOnUpdate(self, dt)
			end
		end
	end)

```



### 变体演进：Geometric Placement 几何放置 (Mod 3678114053)
- **变体场景与切面**：收录来自工坊 Mod 3678114053 (`Geometric Placement 几何放置`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3678114053)
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
									or  GLOBAL.GetRecipe('treasurechest')
		treasurechestrecipe.min_spacing = treasurechestrecipe.min_spacing - 0.1
	end
	
	local Prefabs = GLOBAL.Prefabs
	-- Veggie seeds for Wormwood, their test is just checking for natural turf
	for veggie,data in pairs(GLOBAL.VEGGIES) do
		local seed_placer = veggie.."_seeds_placer"
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
end
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
	ORIGIN_OFFSETS.tile = Vector3(TheWorld.Map:GetTileCenterPoint(0, 0, 0))*-1
	if TheWorld.Flooding then
		ORIGIN_OFFSETS.flood = Vector3(TheWorld.Flooding:GetTileCenterPoint(0, 0, 0))*-1
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
AddComponentPostInit("placer", PlacerPostInit)

--[[ Builder Component ]]--
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

-- For single-player; doesn't add the rotation stuff
local function BuilderPostInit(self)
	local OldCanBuildAtPoint = self.CanBuildAtPoint
	local function NewCanBuildAtPoint(self, pt, recipe, ...)
		if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldCanBuildAtPoint(self, pt, recipe, ...)
	end
	self.CanBuildAtPoint = NewCanBuildAtPoint
	local OldMakeRecipe = self.MakeRecipe
	local function NewMakeRecipe(self, recipe, pt, ...)
		if pt and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldMakeRecipe(self, recipe, pt, ...)
	end
	self.MakeRecipe = NewMakeRecipe
end

if DST then
	AddClassPostConstruct("components/builder_replica", BuilderReplicaPostConstruct)
else
	AddComponentPostInit("builder", BuilderPostInit)
end

--[[ Deployable Component ]]--
-- Tore this from RoG's deployable component; the mouseover messes up the grid for
--  things that use default_test as their main CanDeploy reporter (e.g. tooth traps)
local function default_test(inst, pt)
	local tiletype = GLOBAL.GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GLOBAL.GROUND.IMPASSABLE
	if ground_OK then
		-- local MouseCharacter = TheInput:GetWorldEntityUnderMouse()
		-- if MouseCharacter and not MouseCharacter:HasTag("player") then
			-- return false
		-- end
	    local ents = GLOBAL.TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, {'NOBLOCK', 'player', 'FX'}) -- or we could include a flag to the search?
		local min_spacing = inst.components.deployable.min_spacing or 2

	    for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				if GLOBAL.distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
			end
		end
		return true
	end
	return false
end

local function CanSnapDeployable(inst, mode)
	local DEPLOYMODE = GLOBAL.DEPLOYMODE
	if mode == DEPLOYMODE.CUSTOM then
		return inst:HasTag("deployedplant")
	end
	return mode ~= DEPLOYMODE.WALL and mode ~= DEPLOYMODE.TURF
end

-- Rewrote this a bit to no longer fully replace the old functions
-- instead, it just modifies the point that gets passed to them
local function DeployablePostInit(self)
	local function ShouldRound(self, deployer, player)
		local continue = false
		local grid_type = "default" --to remove when sandbag fix isn't needed
		if DST then
			if CanSnapDeployable(self.inst, self.mode) then
				continue = true
			end
		else
			if self.placer == nil or (self.placer ~= "gridplacer"
							and self.placer:sub(1,5) ~= "wall_"
							and self.placer:sub(1,5) ~= "mech_"
							)-- and self.placer:sub(1,12) ~= "sandbagsmall") --to add back in when sandbags are fixed
			then
				continue = true
				grid_type = (self.placer and self.placer:sub(1,12) == "sandbagsmall") and "flood" or "default"
			end
		end
		if continue then
			return CTRL == TheInput:IsKeyDown(KEY_CTRL) and (player == nil or deployer == player), grid_type
		else	
			return false, grid_type
		end
	end
	
	-- This only gets called on the host, so we need to modify inventoryitem too
	-- now that I've modified inventoryitem_replica, this may no longer be necessary
	local OldCanDeploy = self.CanDeploy
	if not DST then
		OldCanDeploy = function(self, ...)
			-- Shipwrecked version of this code
			if self.test then
				return self.test(self.inst, ...)
			else
				return default_test(self.inst, ...)
			end
			-- This is the vanilla version, but the Shipwrecked one above should be better.
			-- Specifically, the vanilla version lets you place where
			--   self.test fails but default_test succeeds (this was unintended)
			-- return self.test and self.test(self.inst, ...) or default_test(self.inst, ...)
		end
	end
	local function NewCanDeploy(self, pt, mouseover, ...)
		local player = GetPlayer()
		if ShouldRound(self, player, player) then
			pt = Snap(pt)
		end
		return OldCanDeploy(self, pt, nil, ...) --removing mouseover should help some DST things
	end
	self.CanDeploy = NewCanDeploy
	
	local OldDeploy = self.Deploy
	local function NewDeploy(self, pt, deployer, ...)
		local player = GetPlayer()
		-- if ShouldRound(self, deployer, player) then
			-- pt = Snap(pt)
		-- end
		--small fix for sandbags that I can hopefully remove at some point
		local round, grid_type = ShouldRound(self, deployer, player)
		if round then
			pt = Snap(pt, grid_type)
		end
		return OldDeploy(self, pt, deployer, ...)
	end
	self.Deploy = NewDeploy
end
AddComponentPostInit("deployable", DeployablePostInit)

local function InventoryItemReplicaPostConstruct(self)
	local OldCanDeploy = self.CanDeploy
	local function NewCanDeploy(self, pt, mouseover, ...)
		local mode = self.classified and self.classified.deploymode:value() or nil
		if CanSnapDeployable(self.inst, mode) then
			if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
				pt = Snap(pt)
			end
		end
		return OldCanDeploy(self, pt, nil, ...)
	end
	self.CanDeploy = NewCanDeploy
end
if DST then
	AddClassPostConstruct("components/inventoryitem_replica", InventoryItemReplicaPostConstruct)
end

if kleifileexists("scripts/components/farmtiller.lua") then
	FarmTiller = require("components/farmtiller")
	local _FarmTiller_Till = FarmTiller.Till
	function FarmTiller:Till(pt, doer, ...)
		-- Filter on ThePlayer to prevent host grid from overriding clients
		if rawget(GLOBAL, "ThePlayer") == doer and ACTION_ENABLED.TILL and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return _FarmTiller_Till(self, pt, doer, ...)
	end
end

-- Fixes deploying on clients in DST
-- This feels really hackish...... but there doesn't seem to be a better way to do it,
--  since this is directly called from the monstrous PlayerController functions
--  (PlayerController:OnRightClick and PlayerController:DoControllerActionButton)
if DST then
	local ACTIONS_TO_SNAP = {
		DEPLOY = function() return true end,
	}
	for action, _ in pairs(RMB_ACTION_GRID_SPACING) do
		ACTIONS_TO_SNAP[action] = function() return ACTION_ENABLED[action] end
	end
	local ACTION_CODES_TO_SNAP = {}
	for action, _ in pairs(ACTIONS_TO_SNAP) do
		if rawget(GLOBAL.ACTIONS, action) then
			ACTION_CODES_TO_SNAP[GLOBAL.ACTIONS[action].code] = function() return ACTIONS_TO_SNAP[action]() end
		end
	end
	local _SendRPCToServer = GLOBAL.SendRPCToServer
	function GLOBAL.SendRPCToServer(code, action_code, x, z, ...)
		if code == GLOBAL.RPC.RightClick -- We don't need ControllerActionButtonDeploy because it grabs the placer's location
		and ACTION_CODES_TO_SNAP[action_code] and ACTION_CODES_TO_SNAP[action_code]()
		and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			local ThePlayer = GLOBAL.ThePlayer
			local activeitem = ThePlayer and ThePlayer.replica
							and ThePlayer.replica.inventory
							and ThePlayer.replica.inventory.classified
							and ThePlayer.replica.inventory.classified:GetActiveItem()
			if not activeitem or not (
				   activeitem:HasTag("wallbuilder")
				or activeitem:HasTag("fencebuilder")
				or activeitem:HasTag("gatebuilder")
				or activeitem:HasTag("groundtile")
				) then
				x,_,z = Snap(Vector3(x, 0, z)):Get()
			end
		end
		_SendRPCToServer(code, action_code, x, z, ...)
	end
end

--[[ Menu/Option Systems ]]--

-- We want to make sure that chatting, or being in menus, etc, doesn't toggle
local function GetActiveScreenName()
	local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
	return screen and screen.name or ""
end
local function IsDefaultScreen()
	return GetActiveScreenName():find("HUD") and GetPlayer() and GetPlayer().components.playercontroller:IsEnabled()
end
local function IsScoreboardScreen()
	return GetActiveScreenName():find("PlayerStatusScreen") ~= nil
end

local COLOR_PRESETS = {
	redgreen			= {bad = "red",				good = "green"},
	redblue				= {bad = "red",				good = "blue"},
	blackwhite			= {bad = "black",			good = "white"},
	blackwhiteoutline	= {bad = "blackoutline",	good = "whiteoutline"},
}
local COLOR_PRESET_LOOKUP = {}
local color_type_ordering = {"GOOD", "BAD", "GOODTILE", "BADTILE", "GOODPLACER", "BADPLACER"}
for color_preset_name, color_preset in pairs(COLOR_PRESETS) do
	local preset_comparison_string = ""
	for _, color_type in ipairs(color_type_ordering) do
		local color_option = color_type:match("^GOOD") and "good" or "bad"
		preset_comparison_string = preset_comparison_string .. ResolveColor(color_type, color_preset[color_option])
	end
	COLOR_PRESET_LOOKUP[preset_comparison_string] = color_preset_name
end
local function get_preset_comparison_string()
	local preset_comparison_string = ""
	for _, color_type in ipairs(color_type_ordering) do
		local color = COLORS[color_type]
		preset_comparison_string = preset_comparison_string .. (COLOR_OPTION_LOOKUP[color] or color)
	end
	return preset_comparison_string
end
local IsKey = {}
local ignore_key = false
local function set_ignore() ignore_key = true end
local function PushOptionsScreen()
	if not SHOWMENU then
		CTRL = not CTRL
		return
	end
	local screen = GeometricOptionsScreen(modname, COLOR_OPTIONS, OUTLINED_OPTIONS)
	screen.IsOptionsMenuKey = IsKey.OptionsMenu
	screen.callbacks.save = function()
		local _print = GLOBAL.print
		GLOBAL.print = function() end --janky, but KnownModIndex functions kinda spam the logs
		local config = GLOBAL.KnownModIndex:LoadModConfigurationOptions(modname, true)
		local settings = {}
		local namelookup = {} --makes it more resilient if I shift the order of options
		for i,v in ipairs(config) do
			namelookup[v.name] = i
			table.insert(settings, {name = v.name, label = v.label, options = v.options, default = v.default, saved = v.saved})
		end
		settings[namelookup.CTRL].saved = CTRL
		settings[namelookup.GEOMETRY].saved = SAVED_GEOMETRY_NAME
		settings[namelookup.BUILDGRID].saved = BUILDGRID
		settings[namelookup.HIDEPLACER].saved = HIDEPLACER
		settings[namelookup.HIDECURSOR].saved = HIDECURSORQUANTITY and 1 or HIDECURSOR
		settings[namelookup.SMARTSPACING].saved = SMARTSPACING
		for color_type, color_option in pairs(COLORS) do
			settings[namelookup[color_type .. "COLOR"]].saved = COLOR_OPTION_LOOKUP[color_option] or color_option
		end
		for action, enabled in pairs(ACTION_ENABLED) do
			settings[namelookup["ACTION_"..action]].saved = enabled
		end
		settings[namelookup.TIMEBUDGET].saved = timebudget_percent
		settings[namelookup.SMALLGRIDSIZE].saved = GRID_SIZES.SMALL
		settings[namelookup.MEDGRIDSIZE].saved = GRID_SIZES.MED
		settings[namelookup.BIGGRIDSIZE].saved = GRID_SIZES.BIG
		--Note: don't need to include options that aren't in the menu,
		-- because they're already in there from the options load above
		GLOBAL.KnownModIndex:SaveConfigurationOptions(function() end, modname, settings, true)
		GLOBAL.print = _print --restore print functionality!
	end
	screen.callbacks.geometry = function(geometry)
		GRID_DIRTY = true
		GEOMETRY_DIRTY = true
		SAVED_LAST_GEOMETRY_NAME = SAVED_GEOMETRY_NAME
		SAVED_GEOMETRY_NAME = geometry
	end
	for name,button in pairs(screen.geometry_buttons) do
		if name:upper() == SAVED_GEOMETRY_NAME then
			if DST then button:Select() else button:Disable() end
		else
			if DST then button:Unselect() else button:Enable() end
		end
	end
	screen.callbacks.color = SetColor
	local function update_color_spinners_buttons()
		for color_type, color_option in pairs(COLORS) do
			local color_name = COLOR_OPTION_LOOKUP[color_option] or color_option
			screen.color_spinners[color_type]:SetSelected(color_name)
		end
		for _, button in pairs(screen.color_buttons) do
			if DST then button:Unselect() else button:Enable() end
		end
		local preset = COLOR_PRESET_LOOKUP[get_preset_comparison_string()]
		if preset then
			if DST then screen.color_buttons[preset]:Select() else screen.color_buttons[preset]:Disable() end
		end
	end
	update_color_spinners_buttons()
	screen.callbacks.color_update = update_color_spinners_buttons
	if CTRL then screen.toggle_button.onclick() end
	screen.callbacks.toggle = function(toggle) CTRL = not toggle end
	if not BUILDGRID then screen.grid_button.onclick() end
	screen.callbacks.grid = function(toggle)
		GRID_DIRTY = true
		BUILDGRID = toggle == 1
	end
	if HIDEPLACER then screen.placer_button.onclick() end
	screen.callbacks.placer = function(toggle) HIDEPLACER = toggle == 0 end
	if HIDECURSOR then screen.cursor_button.onclick() end
	if HIDECURSORQUANTITY then screen.cursor_button.onclick() end
	screen.callbacks.cursor = function(toggle)
		HIDECURSOR = toggle ~= 2
		HIDECURSORQUANTITY = toggle == 0
	end
	if not SMARTSPACING then screen.smart_spacing_button.onclick() end
	screen.callbacks.smart_spacing = function()
		SMARTSPACING = not SMARTSPACING
		GRID_DIRTY = true
		GEOMETRY_DIRTY = true
	end
	if screen.till_grid_button then
		if not ACTION_ENABLED.TILL then screen.till_grid_button.onclick() end
		screen.callbacks.till_grid = function()
			SetGridForRmbAction("TILL", not ACTION_ENABLED.TILL)
		end
	end
	screen.refresh:SetSelected(timebudget_percent)
	screen.callbacks.refresh = SetTimeBudget
	screen.smallgrid:SetSelected(GRID_SIZES.SMALL)
	screen.medgrid:SetSelected(GRID_SIZES.MED)
	screen.biggrid:SetSelected(GRID_SIZES.BIG)
	screen.callbacks.gridsize = SetGridSize
	screen.callbacks.ignore = set_ignore
	GLOBAL.TheFrontEnd:PushScreen(screen)
end

-- Keyboard controls
local function SwapGeometry()
	GRID_DIRTY = true
	GEOMETRY_DIRTY = true
	local _SAVED_GEOMETRY_NAME = SAVED_GEOMETRY_NAME
	SAVED_GEOMETRY_NAME = SAVED_LAST_GEOMETRY_NAME
	SAVED_LAST_GEOMETRY_NAME = _SAVED_GEOMETRY_NAME
end
IsKey.OptionsMenu = ModSettings.AddControl(
	modname,
	"KEYBOARDTOGGLEKEY",
	"Options Menu",
	"B",
	function()
		if IsDefaultScreen() then
			if ignore_key then
				ignore_key = false
			else
				PushOptionsScreen()				
			end
		end
	end,
	false
)
ModSettings.AddControl(
	modname,
	"GEOMETRYTOGGLEKEY",
	"Toggle Geometry",
	"V",
	function()
		if IsDefaultScreen() then
			SwapGeometry()
		end
	end,
	false
)
ModSettings.AddControl(
	modname,
	"SNAPGRIDKEY",
	"Snap Grid",
	"",
	function ()
		if IsDefaultScreen() then
			SnapGrid()
		end
	end,
	false
)

-- Controller controls
-- This is pressing the right stick in
-- CONTROL_MENU_MISC_3 is the same thing as CONTROL_OPEN_DEBUG_MENU
-- CONTROL_MENU_MISC_4 is the right stick click
local function IsOptionsMenuBound()
	return not IsKey.OptionsMenu()
end
local controller_control = DST and
	GLOBAL.CONTROL_MENU_MISC_3 or
	GLOBAL.CONTROL_OPEN_DEBUG_MENU
local controller_control_handler = DST and
	function(down)
		-- In DST, only let them do it on the scoreboard screen
		if IsOptionsMenuBound() and not down and IsScoreboardScreen() then
			local ss = GLOBAL.TheFrontEnd.screenstack
			ss[#ss]:ClearFocus()
			PushOptionsScreen()
		end
	end or function(down)
		-- In single-player, let them do it on the main screen
		if IsOptionsMenuBound() and not down and IsDefaultScreen() then
			PushOptionsScreen()
		end
	end
TheInput:AddControlHandler(controller_control, controller_control_handler)

if DST then
	local PlayerStatusScreen = require("screens/playerstatusscreen")
	local PlayerStatusScreen_GetHelpText = PlayerStatusScreen.GetHelpText
	function PlayerStatusScreen:GetHelpText(...)
		local control_string = SHOWMENU and " Geometric Placement Options  " or " Toggle Geometric Placement  "
		return TheInput:GetLocalizedControl(TheInput:GetControllerID(), GLOBAL.CONTROL_MENU_MISC_3)
			.. control_string .. PlayerStatusScreen_GetHelpText(self, ...)
	end
	-- This is only necessary because they added a thing to filter out CONTROL_OPEN_DEBUG_MENU on this screen,
	-- but CONTROL_OPEN_DEBUG_MENU happens to be the same value as CONTROL_MENU_MISC_3
	local PlayerStatusScreen_OnControl = PlayerStatusScreen.OnControl
	function PlayerStatusScreen:OnControl(control, down, ...)
		if control == controller_control and not down then
			return false
		end
		return PlayerStatusScreen_OnControl(self, control, down, ...)
	end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:tile_outline
if DST then
	AddPrefabPostInit("tile_outline", ReplaceGridplacerAnim)
	AddPrefabPostInit("gridplacer_farmablesoil", ReplaceGridplacerAnim)
end

-- But these things do need to get built every time
local function PlacerPostInit(self)
	--there's gotta be a better place to put this; also may not be necessary, but it's safe and cheap
	local TheWorld = DST and GLOBAL.TheWorld or GLOBAL.GetWorld()
	TheCamera = GLOBAL.TheCamera
	ORIGIN_OFFSETS.tile = Vector3(TheWorld.Map:GetTileCenterPoint(0, 0, 0))*-1
	if TheWorld.Flooding then
		ORIGIN_OFFSETS.flood = Vector3(TheWorld.Flooding:GetTileCenterPoint(0, 0, 0))*-1
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
AddComponentPostInit("placer", PlacerPostInit)

--[[ Builder Component ]]--
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

-- For single-player; doesn't add the rotation stuff
local function BuilderPostInit(self)
	local OldCanBuildAtPoint = self.CanBuildAtPoint
	local function NewCanBuildAtPoint(self, pt, recipe, ...)
		if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldCanBuildAtPoint(self, pt, recipe, ...)
	end
	self.CanBuildAtPoint = NewCanBuildAtPoint
	local OldMakeRecipe = self.MakeRecipe
	local function NewMakeRecipe(self, recipe, pt, ...)
		if pt and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldMakeRecipe(self, recipe, pt, ...)
	end
	self.MakeRecipe = NewMakeRecipe
end

if DST then
	AddClassPostConstruct("components/builder_replica", BuilderReplicaPostConstruct)
else
	AddComponentPostInit("builder", BuilderPostInit)
end

--[[ Deployable Component ]]--
-- Tore this from RoG's deployable component; the mouseover messes up the grid for
--  things that use default_test as their main CanDeploy reporter (e.g. tooth traps)
local function default_test(inst, pt)
	local tiletype = GLOBAL.GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GLOBAL.GROUND.IMPASSABLE
	if ground_OK then
		-- local MouseCharacter = TheInput:GetWorldEntityUnderMouse()
		-- if MouseCharacter and not MouseCharacter:HasTag("player") then
			-- return false
		-- end
	    local ents = GLOBAL.TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, {'NOBLOCK', 'player', 'FX'}) -- or we could include a flag to the search?
		local min_spacing = inst.components.deployable.min_spacing or 2

	    for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				if GLOBAL.distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
			end
		end
		return true
	end
	return false
end

local function CanSnapDeployable(inst, mode)
	local DEPLOYMODE = GLOBAL.DEPLOYMODE
	if mode == DEPLOYMODE.CUSTOM then
		return inst:HasTag("deployedplant")
	end
	return mode ~= DEPLOYMODE.WALL and mode ~= DEPLOYMODE.TURF
end

-- Rewrote this a bit to no longer fully replace the old functions
-- instead, it just modifies the point that gets passed to them
local function DeployablePostInit(self)
	local function ShouldRound(self, deployer, player)
		local continue = false
		local grid_type = "default" --to remove when sandbag fix isn't needed
		if DST then
			if CanSnapDeployable(self.inst, self.mode) then
				continue = true
			end
		else
			if self.placer == nil or (self.placer ~= "gridplacer"
							and self.placer:sub(1,5) ~= "wall_"
							and self.placer:sub(1,5) ~= "mech_"
							)-- and self.placer:sub(1,12) ~= "sandbagsmall") --to add back in when sandbags are fixed
			then
				continue = true
				grid_type = (self.placer and self.placer:sub(1,12) == "sandbagsmall") and "flood" or "default"
			end
		end
		if continue then
			return CTRL == TheInput:IsKeyDown(KEY_CTRL) and (player == nil or deployer == player), grid_type
		else	
			return false, grid_type
		end
	end
	
	-- This only gets called on the host, so we need to modify inventoryitem too
	-- now that I've modified inventoryitem_replica, this may no longer be necessary
	local OldCanDeploy = self.CanDeploy
	if not DST then
		OldCanDeploy = function(self, ...)
			-- Shipwrecked version of this code
			if self.test then
				return self.test(self.inst, ...)
			else
				return default_test(self.inst, ...)
			end
			-- This is the vanilla version, but the Shipwrecked one above should be better.
			-- Specifically, the vanilla version lets you place where
			--   self.test fails but default_test succeeds (this was unintended)
			-- return self.test and self.test(self.inst, ...) or default_test(self.inst, ...)
		end
	end
	local function NewCanDeploy(self, pt, mouseover, ...)
		local player = GetPlayer()
		if ShouldRound(self, player, player) then
			pt = Snap(pt)
		end
		return OldCanDeploy(self, pt, nil, ...) --removing mouseover should help some DST things
	end
	self.CanDeploy = NewCanDeploy
	
	local OldDeploy = self.Deploy
	local function NewDeploy(self, pt, deployer, ...)
		local player = GetPlayer()
		-- if ShouldRound(self, deployer, player) then
			-- pt = Snap(pt)
		-- end
		--small fix for sandbags that I can hopefully remove at some point
		local round, grid_type = ShouldRound(self, deployer, player)
		if round then
			pt = Snap(pt, grid_type)
		end
		return OldDeploy(self, pt, deployer, ...)
	end
	self.Deploy = NewDeploy
end
AddComponentPostInit("deployable", DeployablePostInit)

local function InventoryItemReplicaPostConstruct(self)
	local OldCanDeploy = self.CanDeploy
	local function NewCanDeploy(self, pt, mouseover, ...)
		local mode = self.classified and self.classified.deploymode:value() or nil
		if CanSnapDeployable(self.inst, mode) then
			if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
				pt = Snap(pt)
			end
		end
		return OldCanDeploy(self, pt, nil, ...)
	end
	self.CanDeploy = NewCanDeploy
end
if DST then
	AddClassPostConstruct("components/inventoryitem_replica", InventoryItemReplicaPostConstruct)
end

if kleifileexists("scripts/components/farmtiller.lua") then
	FarmTiller = require("components/farmtiller")
	local _FarmTiller_Till = FarmTiller.Till
	function FarmTiller:Till(pt, doer, ...)
		-- Filter on ThePlayer to prevent host grid from overriding clients
		if rawget(GLOBAL, "ThePlayer") == doer and ACTION_ENABLED.TILL and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return _FarmTiller_Till(self, pt, doer, ...)
	end
end

-- Fixes deploying on clients in DST
-- This feels really hackish...... but there doesn't seem to be a better way to do it,
--  since this is directly called from the monstrous PlayerController functions
--  (PlayerController:OnRightClick and PlayerController:DoControllerActionButton)
if DST then
	local ACTIONS_TO_SNAP = {
		DEPLOY = function() return true end,
	}
	for action, _ in pairs(RMB_ACTION_GRID_SPACING) do
		ACTIONS_TO_SNAP[action] = function() return ACTION_ENABLED[action] end
	end
	local ACTION_CODES_TO_SNAP = {}
	for action, _ in pairs(ACTIONS_TO_SNAP) do
		if rawget(GLOBAL.ACTIONS, action) then
			ACTION_CODES_TO_SNAP[GLOBAL.ACTIONS[action].code] = function() return ACTIONS_TO_SNAP[action]() end
		end
	end
	local _SendRPCToServer = GLOBAL.SendRPCToServer
	function GLOBAL.SendRPCToServer(code, action_code, x, z, ...)
		if code == GLOBAL.RPC.RightClick -- We don't need ControllerActionButtonDeploy because it grabs the placer's location
		and ACTION_CODES_TO_SNAP[action_code] and ACTION_CODES_TO_SNAP[action_code]()
		and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			local ThePlayer = GLOBAL.ThePlayer
			local activeitem = ThePlayer and ThePlayer.replica
							and ThePlayer.replica.inventory
							and ThePlayer.replica.inventory.classified
							and ThePlayer.replica.inventory.classified:GetActiveItem()
			if not activeitem or not (
				   activeitem:HasTag("wallbuilder")
				or activeitem:HasTag("fencebuilder")
				or activeitem:HasTag("gatebuilder")
				or activeitem:HasTag("groundtile")
				) then
				x,_,z = Snap(Vector3(x, 0, z)):Get()
			end
		end
		_SendRPCToServer(code, action_code, x, z, ...)
	end
end

--[[ Menu/Option Systems ]]--

-- We want to make sure that chatting, or being in menus, etc, doesn't toggle
local function GetActiveScreenName()
	local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
	return screen and screen.name or ""
end
local function IsDefaultScreen()
	return GetActiveScreenName():find("HUD") and GetPlayer() and GetPlayer().components.playercontroller:IsEnabled()
end
local function IsScoreboardScreen()
	return GetActiveScreenName():find("PlayerStatusScreen") ~= nil
end

local COLOR_PRESETS = {
	redgreen			= {bad = "red",				good = "green"},
	redblue				= {bad = "red",				good = "blue"},
	blackwhite			= {bad = "black",			good = "white"},
	blackwhiteoutline	= {bad = "blackoutline",	good = "whiteoutline"},
}
local COLOR_PRESET_LOOKUP = {}
local color_type_ordering = {"GOOD", "BAD", "GOODTILE", "BADTILE", "GOODPLACER", "BADPLACER"}
for color_preset_name, color_preset in pairs(COLOR_PRESETS) do
	local preset_comparison_string = ""
	for _, color_type in ipairs(color_type_ordering) do
		local color_option = color_type:match("^GOOD") and "good" or "bad"
		preset_comparison_string = preset_comparison_string .. ResolveColor(color_type, color_preset[color_option])
	end
	COLOR_PRESET_LOOKUP[preset_comparison_string] = color_preset_name
end
local function get_preset_comparison_string()
	local preset_comparison_string = ""
	for _, color_type in ipairs(color_type_ordering) do
		local color = COLORS[color_type]
		preset_comparison_string = preset_comparison_string .. (COLOR_OPTION_LOOKUP[color] or color)
	end
	return preset_comparison_string
end
local IsKey = {}
local ignore_key = false
local function set_ignore() ignore_key = true end
local function PushOptionsScreen()
	if not SHOWMENU then
		CTRL = not CTRL
		return
	end
	local screen = GeometricOptionsScreen(modname, COLOR_OPTIONS, OUTLINED_OPTIONS)
	screen.IsOptionsMenuKey = IsKey.OptionsMenu
	screen.callbacks.save = function()
		local _print = GLOBAL.print
		GLOBAL.print = function() end --janky, but KnownModIndex functions kinda spam the logs
		local config = GLOBAL.KnownModIndex:LoadModConfigurationOptions(modname, true)
		local settings = {}
		local namelookup = {} --makes it more resilient if I shift the order of options
		for i,v in ipairs(config) do
			namelookup[v.name] = i
			table.insert(settings, {name = v.name, label = v.label, options = v.options, default = v.default, saved = v.saved})
		end
		settings[namelookup.CTRL].saved = CTRL
		settings[namelookup.GEOMETRY].saved = SAVED_GEOMETRY_NAME
		settings[namelookup.BUILDGRID].saved = BUILDGRID
		settings[namelookup.HIDEPLACER].saved = HIDEPLACER
		settings[namelookup.HIDECURSOR].saved = HIDECURSORQUANTITY and 1 or HIDECURSOR
		settings[namelookup.SMARTSPACING].saved = SMARTSPACING
		for color_type, color_option in pairs(COLORS) do
			settings[namelookup[color_type .. "COLOR"]].saved = COLOR_OPTION_LOOKUP[color_option] or color_option
		end
		for action, enabled in pairs(ACTION_ENABLED) do
			settings[namelookup["ACTION_"..action]].saved = enabled
		end
		settings[namelookup.TIMEBUDGET].saved = timebudget_percent
		settings[namelookup.SMALLGRIDSIZE].saved = GRID_SIZES.SMALL
		settings[namelookup.MEDGRIDSIZE].saved = GRID_SIZES.MED
		settings[namelookup.BIGGRIDSIZE].saved = GRID_SIZES.BIG
		--Note: don't need to include options that aren't in the menu,
		-- because they're already in there from the options load above
		GLOBAL.KnownModIndex:SaveConfigurationOptions(function() end, modname, settings, true)
		GLOBAL.print = _print --restore print functionality!
	end
	screen.callbacks.geometry = function(geometry)
		GRID_DIRTY = true
		GEOMETRY_DIRTY = true
		SAVED_LAST_GEOMETRY_NAME = SAVED_GEOMETRY_NAME
		SAVED_GEOMETRY_NAME = geometry
	end
	for name,button in pairs(screen.geometry_buttons) do
		if name:upper() == SAVED_GEOMETRY_NAME then
			if DST then button:Select() else button:Disable() end
		else
			if DST then button:Unselect() else button:Enable() end
		end
	end
	screen.callbacks.color = SetColor
	local function update_color_spinners_buttons()
		for color_type, color_option in pairs(COLORS) do
			local color_name = COLOR_OPTION_LOOKUP[color_option] or color_option
			screen.color_spinners[color_type]:SetSelected(color_name)
		end
		for _, button in pairs(screen.color_buttons) do
			if DST then button:Unselect() else button:Enable() end
		end
		local preset = COLOR_PRESET_LOOKUP[get_preset_comparison_string()]
		if preset then
			if DST then screen.color_buttons[preset]:Select() else screen.color_buttons[preset]:Disable() end
		end
	end
	update_color_spinners_buttons()
	screen.callbacks.color_update = update_color_spinners_buttons
	if CTRL then screen.toggle_button.onclick() end
	screen.callbacks.toggle = function(toggle) CTRL = not toggle end
	if not BUILDGRID then screen.grid_button.onclick() end
	screen.callbacks.grid = function(toggle)
		GRID_DIRTY = true
		BUILDGRID = toggle == 1
	end
	if HIDEPLACER then screen.placer_button.onclick() end
	screen.callbacks.placer = function(toggle) HIDEPLACER = toggle == 0 end
	if HIDECURSOR then screen.cursor_button.onclick() end
	if HIDECURSORQUANTITY then screen.cursor_button.onclick() end
	screen.callbacks.cursor = function(toggle)
		HIDECURSOR = toggle ~= 2
		HIDECURSORQUANTITY = toggle == 0
	end
	if not SMARTSPACING then screen.smart_spacing_button.onclick() end
	screen.callbacks.smart_spacing = function()
		SMARTSPACING = not SMARTSPACING
		GRID_DIRTY = true
		GEOMETRY_DIRTY = true
	end
	if screen.till_grid_button then
		if not ACTION_ENABLED.TILL then screen.till_grid_button.onclick() end
		screen.callbacks.till_grid = function()
			SetGridForRmbAction("TILL", not ACTION_ENABLED.TILL)
		end
	end
	screen.refresh:SetSelected(timebudget_percent)
	screen.callbacks.refresh = SetTimeBudget
	screen.smallgrid:SetSelected(GRID_SIZES.SMALL)
	screen.medgrid:SetSelected(GRID_SIZES.MED)
	screen.biggrid:SetSelected(GRID_SIZES.BIG)
	screen.callbacks.gridsize = SetGridSize
	screen.callbacks.ignore = set_ignore
	GLOBAL.TheFrontEnd:PushScreen(screen)
end

-- Keyboard controls
local function SwapGeometry()
	GRID_DIRTY = true
	GEOMETRY_DIRTY = true
	local _SAVED_GEOMETRY_NAME = SAVED_GEOMETRY_NAME
	SAVED_GEOMETRY_NAME = SAVED_LAST_GEOMETRY_NAME
	SAVED_LAST_GEOMETRY_NAME = _SAVED_GEOMETRY_NAME
end
IsKey.OptionsMenu = ModSettings.AddControl(
	modname,
	"KEYBOARDTOGGLEKEY",
	"Options Menu",
	"B",
	function()
		if IsDefaultScreen() then
			if ignore_key then
				ignore_key = false
			else
				PushOptionsScreen()				
			end
		end
	end,
	false
)
ModSettings.AddControl(
	modname,
	"GEOMETRYTOGGLEKEY",
	"Toggle Geometry",
	"V",
	function()
		if IsDefaultScreen() then
			SwapGeometry()
		end
	end,
	false
)
ModSettings.AddControl(
	modname,
	"SNAPGRIDKEY",
	"Snap Grid",
	"",
	function ()
		if IsDefaultScreen() then
			SnapGrid()
		end
	end,
	false
)

-- Controller controls
-- This is pressing the right stick in
-- CONTROL_MENU_MISC_3 is the same thing as CONTROL_OPEN_DEBUG_MENU
-- CONTROL_MENU_MISC_4 is the right stick click
local function IsOptionsMenuBound()
	return not IsKey.OptionsMenu()
end
local controller_control = DST and
	GLOBAL.CONTROL_MENU_MISC_3 or
	GLOBAL.CONTROL_OPEN_DEBUG_MENU
local controller_control_handler = DST and
	function(down)
		-- In DST, only let them do it on the scoreboard screen
		if IsOptionsMenuBound() and not down and IsScoreboardScreen() then
			local ss = GLOBAL.TheFrontEnd.screenstack
			ss[#ss]:ClearFocus()
			PushOptionsScreen()
		end
	end or function(down)
		-- In single-player, let them do it on the main screen
		if IsOptionsMenuBound() and not down and IsDefaultScreen() then
			PushOptionsScreen()
		end
	end
TheInput:AddControlHandler(controller_control, controller_control_handler)

if DST then
	local PlayerStatusScreen = require("screens/playerstatusscreen")
	local PlayerStatusScreen_GetHelpText = PlayerStatusScreen.GetHelpText
	function PlayerStatusScreen:GetHelpText(...)
		local control_string = SHOWMENU and " Geometric Placement Options  " or " Toggle Geometric Placement  "
		return TheInput:GetLocalizedControl(TheInput:GetControllerID(), GLOBAL.CONTROL_MENU_MISC_3)
			.. control_string .. PlayerStatusScreen_GetHelpText(self, ...)
	end
	-- This is only necessary because they added a thing to filter out CONTROL_OPEN_DEBUG_MENU on this screen,
	-- but CONTROL_OPEN_DEBUG_MENU happens to be the same value as CONTROL_MENU_MISC_3
	local PlayerStatusScreen_OnControl = PlayerStatusScreen.OnControl
	function PlayerStatusScreen:OnControl(control, down, ...)
		if control == controller_control and not down then
			return false
		end
		return PlayerStatusScreen_OnControl(self, control, down, ...)
	end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:gridplacer_farmablesoil
	AddPrefabPostInit("tile_outline", ReplaceGridplacerAnim)
	AddPrefabPostInit("gridplacer_farmablesoil", ReplaceGridplacerAnim)
end

-- But these things do need to get built every time
local function PlacerPostInit(self)
	--there's gotta be a better place to put this; also may not be necessary, but it's safe and cheap
	local TheWorld = DST and GLOBAL.TheWorld or GLOBAL.GetWorld()
	TheCamera = GLOBAL.TheCamera
	ORIGIN_OFFSETS.tile = Vector3(TheWorld.Map:GetTileCenterPoint(0, 0, 0))*-1
	if TheWorld.Flooding then
		ORIGIN_OFFSETS.flood = Vector3(TheWorld.Flooding:GetTileCenterPoint(0, 0, 0))*-1
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
AddComponentPostInit("placer", PlacerPostInit)

--[[ Builder Component ]]--
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

-- For single-player; doesn't add the rotation stuff
local function BuilderPostInit(self)
	local OldCanBuildAtPoint = self.CanBuildAtPoint
	local function NewCanBuildAtPoint(self, pt, recipe, ...)
		if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldCanBuildAtPoint(self, pt, recipe, ...)
	end
	self.CanBuildAtPoint = NewCanBuildAtPoint
	local OldMakeRecipe = self.MakeRecipe
	local function NewMakeRecipe(self, recipe, pt, ...)
		if pt and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return OldMakeRecipe(self, recipe, pt, ...)
	end
	self.MakeRecipe = NewMakeRecipe
end

if DST then
	AddClassPostConstruct("components/builder_replica", BuilderReplicaPostConstruct)
else
	AddComponentPostInit("builder", BuilderPostInit)
end

--[[ Deployable Component ]]--
-- Tore this from RoG's deployable component; the mouseover messes up the grid for
--  things that use default_test as their main CanDeploy reporter (e.g. tooth traps)
local function default_test(inst, pt)
	local tiletype = GLOBAL.GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GLOBAL.GROUND.IMPASSABLE
	if ground_OK then
		-- local MouseCharacter = TheInput:GetWorldEntityUnderMouse()
		-- if MouseCharacter and not MouseCharacter:HasTag("player") then
			-- return false
		-- end
	    local ents = GLOBAL.TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, {'NOBLOCK', 'player', 'FX'}) -- or we could include a flag to the search?
		local min_spacing = inst.components.deployable.min_spacing or 2

	    for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				if GLOBAL.distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
			end
		end
		return true
	end
	return false
end

local function CanSnapDeployable(inst, mode)
	local DEPLOYMODE = GLOBAL.DEPLOYMODE
	if mode == DEPLOYMODE.CUSTOM then
		return inst:HasTag("deployedplant")
	end
	return mode ~= DEPLOYMODE.WALL and mode ~= DEPLOYMODE.TURF
end

-- Rewrote this a bit to no longer fully replace the old functions
-- instead, it just modifies the point that gets passed to them
local function DeployablePostInit(self)
	local function ShouldRound(self, deployer, player)
		local continue = false
		local grid_type = "default" --to remove when sandbag fix isn't needed
		if DST then
			if CanSnapDeployable(self.inst, self.mode) then
				continue = true
			end
		else
			if self.placer == nil or (self.placer ~= "gridplacer"
							and self.placer:sub(1,5) ~= "wall_"
							and self.placer:sub(1,5) ~= "mech_"
							)-- and self.placer:sub(1,12) ~= "sandbagsmall") --to add back in when sandbags are fixed
			then
				continue = true
				grid_type = (self.placer and self.placer:sub(1,12) == "sandbagsmall") and "flood" or "default"
			end
		end
		if continue then
			return CTRL == TheInput:IsKeyDown(KEY_CTRL) and (player == nil or deployer == player), grid_type
		else	
			return false, grid_type
		end
	end
	
	-- This only gets called on the host, so we need to modify inventoryitem too
	-- now that I've modified inventoryitem_replica, this may no longer be necessary
	local OldCanDeploy = self.CanDeploy
	if not DST then
		OldCanDeploy = function(self, ...)
			-- Shipwrecked version of this code
			if self.test then
				return self.test(self.inst, ...)
			else
				return default_test(self.inst, ...)
			end
			-- This is the vanilla version, but the Shipwrecked one above should be better.
			-- Specifically, the vanilla version lets you place where
			--   self.test fails but default_test succeeds (this was unintended)
			-- return self.test and self.test(self.inst, ...) or default_test(self.inst, ...)
		end
	end
	local function NewCanDeploy(self, pt, mouseover, ...)
		local player = GetPlayer()
		if ShouldRound(self, player, player) then
			pt = Snap(pt)
		end
		return OldCanDeploy(self, pt, nil, ...) --removing mouseover should help some DST things
	end
	self.CanDeploy = NewCanDeploy
	
	local OldDeploy = self.Deploy
	local function NewDeploy(self, pt, deployer, ...)
		local player = GetPlayer()
		-- if ShouldRound(self, deployer, player) then
			-- pt = Snap(pt)
		-- end
		--small fix for sandbags that I can hopefully remove at some point
		local round, grid_type = ShouldRound(self, deployer, player)
		if round then
			pt = Snap(pt, grid_type)
		end
		return OldDeploy(self, pt, deployer, ...)
	end
	self.Deploy = NewDeploy
end
AddComponentPostInit("deployable", DeployablePostInit)

local function InventoryItemReplicaPostConstruct(self)
	local OldCanDeploy = self.CanDeploy
	local function NewCanDeploy(self, pt, mouseover, ...)
		local mode = self.classified and self.classified.deploymode:value() or nil
		if CanSnapDeployable(self.inst, mode) then
			if CTRL == TheInput:IsKeyDown(KEY_CTRL) then
				pt = Snap(pt)
			end
		end
		return OldCanDeploy(self, pt, nil, ...)
	end
	self.CanDeploy = NewCanDeploy
end
if DST then
	AddClassPostConstruct("components/inventoryitem_replica", InventoryItemReplicaPostConstruct)
end

if kleifileexists("scripts/components/farmtiller.lua") then
	FarmTiller = require("components/farmtiller")
	local _FarmTiller_Till = FarmTiller.Till
	function FarmTiller:Till(pt, doer, ...)
		-- Filter on ThePlayer to prevent host grid from overriding clients
		if rawget(GLOBAL, "ThePlayer") == doer and ACTION_ENABLED.TILL and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			pt = Snap(pt)
		end
		return _FarmTiller_Till(self, pt, doer, ...)
	end
end

-- Fixes deploying on clients in DST
-- This feels really hackish...... but there doesn't seem to be a better way to do it,
--  since this is directly called from the monstrous PlayerController functions
--  (PlayerController:OnRightClick and PlayerController:DoControllerActionButton)
if DST then
	local ACTIONS_TO_SNAP = {
		DEPLOY = function() return true end,
	}
	for action, _ in pairs(RMB_ACTION_GRID_SPACING) do
		ACTIONS_TO_SNAP[action] = function() return ACTION_ENABLED[action] end
	end
	local ACTION_CODES_TO_SNAP = {}
	for action, _ in pairs(ACTIONS_TO_SNAP) do
		if rawget(GLOBAL.ACTIONS, action) then
			ACTION_CODES_TO_SNAP[GLOBAL.ACTIONS[action].code] = function() return ACTIONS_TO_SNAP[action]() end
		end
	end
	local _SendRPCToServer = GLOBAL.SendRPCToServer
	function GLOBAL.SendRPCToServer(code, action_code, x, z, ...)
		if code == GLOBAL.RPC.RightClick -- We don't need ControllerActionButtonDeploy because it grabs the placer's location
		and ACTION_CODES_TO_SNAP[action_code] and ACTION_CODES_TO_SNAP[action_code]()
		and CTRL == TheInput:IsKeyDown(KEY_CTRL) then
			local ThePlayer = GLOBAL.ThePlayer
			local activeitem = ThePlayer and ThePlayer.replica
							and ThePlayer.replica.inventory
							and ThePlayer.replica.inventory.classified
							and ThePlayer.replica.inventory.classified:GetActiveItem()
			if not activeitem or not (
				   activeitem:HasTag("wallbuilder")
				or activeitem:HasTag("fencebuilder")
				or activeitem:HasTag("gatebuilder")
				or activeitem:HasTag("groundtile")
				) then
				x,_,z = Snap(Vector3(x, 0, z)):Get()
			end
		end
		_SendRPCToServer(code, action_code, x, z, ...)
	end
end

--[[ Menu/Option Systems ]]--

-- We want to make sure that chatting, or being in menus, etc, doesn't toggle
local function GetActiveScreenName()
	local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
	return screen and screen.name or ""
end
local function IsDefaultScreen()
	return GetActiveScreenName():find("HUD") and GetPlayer() and GetPlayer().components.playercontroller:IsEnabled()
end
local function IsScoreboardScreen()
	return GetActiveScreenName():find("PlayerStatusScreen") ~= nil
end

local COLOR_PRESETS = {
	redgreen			= {bad = "red",				good = "green"},
	redblue				= {bad = "red",				good = "blue"},
	blackwhite			= {bad = "black",			good = "white"},
	blackwhiteoutline	= {bad = "blackoutline",	good = "whiteoutline"},
}
local COLOR_PRESET_LOOKUP = {}
local color_type_ordering = {"GOOD", "BAD", "GOODTILE", "BADTILE", "GOODPLACER", "BADPLACER"}
for color_preset_name, color_preset in pairs(COLOR_PRESETS) do
	local preset_comparison_string = ""
	for _, color_type in ipairs(color_type_ordering) do
		local color_option = color_type:match("^GOOD") and "good" or "bad"
		preset_comparison_string = preset_comparison_string .. ResolveColor(color_type, color_preset[color_option])
	end
	COLOR_PRESET_LOOKUP[preset_comparison_string] = color_preset_name
end
local function get_preset_comparison_string()
	local preset_comparison_string = ""
	for _, color_type in ipairs(color_type_ordering) do
		local color = COLORS[color_type]
		preset_comparison_string = preset_comparison_string .. (COLOR_OPTION_LOOKUP[color] or color)
	end
	return preset_comparison_string
end
local IsKey = {}
local ignore_key = false
local function set_ignore() ignore_key = true end
local function PushOptionsScreen()
	if not SHOWMENU then
		CTRL = not CTRL
		return
	end
	local screen = GeometricOptionsScreen(modname, COLOR_OPTIONS, OUTLINED_OPTIONS)
	screen.IsOptionsMenuKey = IsKey.OptionsMenu
	screen.callbacks.save = function()
		local _print = GLOBAL.print
		GLOBAL.print = function() end --janky, but KnownModIndex functions kinda spam the logs
		local config = GLOBAL.KnownModIndex:LoadModConfigurationOptions(modname, true)
		local settings = {}
		local namelookup = {} --makes it more resilient if I shift the order of options
		for i,v in ipairs(config) do
			namelookup[v.name] = i
			table.insert(settings, {name = v.name, label = v.label, options = v.options, default = v.default, saved = v.saved})
		end
		settings[namelookup.CTRL].saved = CTRL
		settings[namelookup.GEOMETRY].saved = SAVED_GEOMETRY_NAME
		settings[namelookup.BUILDGRID].saved = BUILDGRID
		settings[namelookup.HIDEPLACER].saved = HIDEPLACER
		settings[namelookup.HIDECURSOR].saved = HIDECURSORQUANTITY and 1 or HIDECURSOR
		settings[namelookup.SMARTSPACING].saved = SMARTSPACING
		for color_type, color_option in pairs(COLORS) do
			settings[namelookup[color_type .. "COLOR"]].saved = COLOR_OPTION_LOOKUP[color_option] or color_option
		end
		for action, enabled in pairs(ACTION_ENABLED) do
			settings[namelookup["ACTION_"..action]].saved = enabled
		end
		settings[namelookup.TIMEBUDGET].saved = timebudget_percent
		settings[namelookup.SMALLGRIDSIZE].saved = GRID_SIZES.SMALL
		settings[namelookup.MEDGRIDSIZE].saved = GRID_SIZES.MED
		settings[namelookup.BIGGRIDSIZE].saved = GRID_SIZES.BIG
		--Note: don't need to include options that aren't in the menu,
		-- because they're already in there from the options load above
		GLOBAL.KnownModIndex:SaveConfigurationOptions(function() end, modname, settings, true)
		GLOBAL.print = _print --restore print functionality!
	end
	screen.callbacks.geometry = function(geometry)
		GRID_DIRTY = true
		GEOMETRY_DIRTY = true
		SAVED_LAST_GEOMETRY_NAME = SAVED_GEOMETRY_NAME
		SAVED_GEOMETRY_NAME = geometry
	end
	for name,button in pairs(screen.geometry_buttons) do
		if name:upper() == SAVED_GEOMETRY_NAME then
			if DST then button:Select() else button:Disable() end
		else
			if DST then button:Unselect() else button:Enable() end
		end
	end
	screen.callbacks.color = SetColor
	local function update_color_spinners_buttons()
		for color_type, color_option in pairs(COLORS) do
			local color_name = COLOR_OPTION_LOOKUP[color_option] or color_option
			screen.color_spinners[color_type]:SetSelected(color_name)
		end
		for _, button in pairs(screen.color_buttons) do
			if DST then button:Unselect() else button:Enable() end
		end
		local preset = COLOR_PRESET_LOOKUP[get_preset_comparison_string()]
		if preset then
			if DST then screen.color_buttons[preset]:Select() else screen.color_buttons[preset]:Disable() end
		end
	end
	update_color_spinners_buttons()
	screen.callbacks.color_update = update_color_spinners_buttons
	if CTRL then screen.toggle_button.onclick() end
	screen.callbacks.toggle = function(toggle) CTRL = not toggle end
	if not BUILDGRID then screen.grid_button.onclick() end
	screen.callbacks.grid = function(toggle)
		GRID_DIRTY = true
		BUILDGRID = toggle == 1
	end
	if HIDEPLACER then screen.placer_button.onclick() end
	screen.callbacks.placer = function(toggle) HIDEPLACER = toggle == 0 end
	if HIDECURSOR then screen.cursor_button.onclick() end
	if HIDECURSORQUANTITY then screen.cursor_button.onclick() end
	screen.callbacks.cursor = function(toggle)
		HIDECURSOR = toggle ~= 2
		HIDECURSORQUANTITY = toggle == 0
	end
	if not SMARTSPACING then screen.smart_spacing_button.onclick() end
	screen.callbacks.smart_spacing = function()
		SMARTSPACING = not SMARTSPACING
		GRID_DIRTY = true
		GEOMETRY_DIRTY = true
	end
	if screen.till_grid_button then
		if not ACTION_ENABLED.TILL then screen.till_grid_button.onclick() end
		screen.callbacks.till_grid = function()
			SetGridForRmbAction("TILL", not ACTION_ENABLED.TILL)
		end
	end
	screen.refresh:SetSelected(timebudget_percent)
	screen.callbacks.refresh = SetTimeBudget
	screen.smallgrid:SetSelected(GRID_SIZES.SMALL)
	screen.medgrid:SetSelected(GRID_SIZES.MED)
	screen.biggrid:SetSelected(GRID_SIZES.BIG)
	screen.callbacks.gridsize = SetGridSize
	screen.callbacks.ignore = set_ignore
	GLOBAL.TheFrontEnd:PushScreen(screen)
end

-- Keyboard controls
local function SwapGeometry()
	GRID_DIRTY = true
	GEOMETRY_DIRTY = true
	local _SAVED_GEOMETRY_NAME = SAVED_GEOMETRY_NAME
	SAVED_GEOMETRY_NAME = SAVED_LAST_GEOMETRY_NAME
	SAVED_LAST_GEOMETRY_NAME = _SAVED_GEOMETRY_NAME
end
IsKey.OptionsMenu = ModSettings.AddControl(
	modname,
	"KEYBOARDTOGGLEKEY",
	"Options Menu",
	"B",
	function()
		if IsDefaultScreen() then
			if ignore_key then
				ignore_key = false
			else
				PushOptionsScreen()				
			end
		end
	end,
	false
)
ModSettings.AddControl(
	modname,
	"GEOMETRYTOGGLEKEY",
	"Toggle Geometry",
	"V",
	function()
		if IsDefaultScreen() then
			SwapGeometry()
		end
	end,
	false
)
ModSettings.AddControl(
	modname,
	"SNAPGRIDKEY",
	"Snap Grid",
	"",
	function ()
		if IsDefaultScreen() then
			SnapGrid()
		end
	end,
	false
)

-- Controller controls
-- This is pressing the right stick in
-- CONTROL_MENU_MISC_3 is the same thing as CONTROL_OPEN_DEBUG_MENU
-- CONTROL_MENU_MISC_4 is the right stick click
local function IsOptionsMenuBound()
	return not IsKey.OptionsMenu()
end
local controller_control = DST and
	GLOBAL.CONTROL_MENU_MISC_3 or
	GLOBAL.CONTROL_OPEN_DEBUG_MENU
local controller_control_handler = DST and
	function(down)
		-- In DST, only let them do it on the scoreboard screen
		if IsOptionsMenuBound() and not down and IsScoreboardScreen() then
			local ss = GLOBAL.TheFrontEnd.screenstack
			ss[#ss]:ClearFocus()
			PushOptionsScreen()
		end
	end or function(down)
		-- In single-player, let them do it on the main screen
		if IsOptionsMenuBound() and not down and IsDefaultScreen() then
			PushOptionsScreen()
		end
	end
TheInput:AddControlHandler(controller_control, controller_control_handler)

if DST then
	local PlayerStatusScreen = require("screens/playerstatusscreen")
	local PlayerStatusScreen_GetHelpText = PlayerStatusScreen.GetHelpText
	function PlayerStatusScreen:GetHelpText(...)
		local control_string = SHOWMENU and " Geometric Placement Options  " or " Toggle Geometric Placement  "
		return TheInput:GetLocalizedControl(TheInput:GetControllerID(), GLOBAL.CONTROL_MENU_MISC_3)
			.. control_string .. PlayerStatusScreen_GetHelpText(self, ...)
	end
	-- This is only necessary because they added a thing to filter out CONTROL_OPEN_DEBUG_MENU on this screen,
	-- but CONTROL_OPEN_DEBUG_MENU happens to be the same value as CONTROL_MENU_MISC_3
	local PlayerStatusScreen_OnControl = PlayerStatusScreen.OnControl
	function PlayerStatusScreen:OnControl(control, down, ...)
		if control == controller_control and not down then
			return false
		end
		return PlayerStatusScreen_OnControl(self, control, down, ...)
	end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:placer
end
AddComponentPostInit("placer", PlacerPostInit)

--[[ Builder Component ]]--
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



### 变体演进：Shadow Armory (Mod 3372658001)
- **变体场景与切面**：收录来自工坊 Mod 3372658001 (`Shadow Armory`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3372658001)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:waxwell

AddPrefabPostInit("waxwell", function(inst)
	if inst.components.builder then 
		inst.components.builder.magic_bonus = 1
	end 
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:researchlab4

AddRecipePostInit("researchlab4", function(self)
	self.level = require"techtree".Create{ MAGIC = 1 }
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:shadowhelm

AddPrefabPostInit("shadowhelm", function(inst)
	inst.lastmainshield = 0
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventory

AddComponentPostInit("inventory", function(self)
	local ApplyDamage = self.ApplyDamage
	self.ApplyDamage = function(self, damage, attacker, ...)
	
		if self.inst.shadowhelm and self.inst.components.sanity 
		and damage and (damage > TUNING.SHADOWHELM.LEFTOVER_DAMAGE_AGAINST_SHADOWS)
		and attacker and attacker:HasTag"shadow_aligned" then
			
			local reduction = damage - TUNING.SHADOWHELM.LEFTOVER_DAMAGE_AGAINST_SHADOWS
			self.inst.components.sanity:DoDelta(reduction * 
				TUNING.SHADOWHELM.SHADOW_DAMAGE_TO_SANITY)
				
			if self.inst.shadowhelm.components.armor then 
				self.inst.shadowhelm.components.armor.condition = 
					self.inst.shadowhelm.components.armor.condition - reduction
			end 
			
			local fx = SpawnPrefab("shadow_shield"..tostring(
				PickShield(self.inst.shadowhelm)))
				
			fx.entity:SetParent(self.inst.entity)
				
			damage = TUNING.SHADOWHELM.LEFTOVER_DAMAGE_AGAINST_SHADOWS
		end 
		
		return ApplyDamage(self, damage, attacker, ...)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ruinsnightmare

AddPrefabPostInit("ruinsnightmare", function(inst)
	inst:ListenForEvent('death', ruinsnightmare_death)
end)

```

