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

