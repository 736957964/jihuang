# simutil.lua — 模拟工具函数

> 源码: `scripts/simutil.lua` (34KB, 64+ 函数)
> simutil 是 DST Mod 开发中最常用的工具函数集合，提供实体查找、玩家查询、位置计算、环境检测等功能。

---

## 1. 实体查找 (Entity Finding)

### FindEntity
```lua
FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags) → Entity | nil
```
在 inst 周围 radius 范围内查找第一个满足条件的实体。

| 参数 | 类型 | 说明 |
|------|------|------|
| `inst` | Entity | 搜索中心实体 |
| `radius` | number | 搜索半径 |
| `fn` | function(v, inst) | 额外过滤函数 |
| `musttags` | table | 必须全部拥有的标签 |
| `canttags` | table | 不能拥有的标签 |
| `mustoneoftags` | table | 至少拥有一个的标签 |

```lua
-- 查找最近的食物
local food = FindEntity(inst, 20, nil, {"food"}, {"spoiled"})
```

### FindClosestEntity
```lua
FindClosestEntity(inst, radius, ignoreheight, musttags, canttags, mustoneoftags, fn) → Entity, distsq
```
查找最近的实体（返回实体和距离平方）。

### GetRandomInstWithTag
```lua
GetRandomInstWithTag(tag, inst, radius) → Entity | nil
```
随机获取范围内有指定标签的实体。

### GetClosestInstWithTag
```lua
GetClosestInstWithTag(tag, inst, radius) → Entity | nil
```
获取范围内最近的有指定标签的实体。

### DeleteCloseEntsWithTag
```lua
DeleteCloseEntsWithTag(tag, inst, radius)
```
删除范围内所有带指定标签的实体。

---

## 2. 玩家查找 (Player Finding)

### FindClosestPlayer
```lua
FindClosestPlayer(x, y, z, isalive) → Player | nil
```
查找距离坐标最近的玩家。

### FindClosestPlayerToInst
```lua
FindClosestPlayerToInst(inst, range, isalive) → Player | nil
```
查找离实体最近的玩家。

### FindClosestPlayerOnLandInRangeSq
```lua
FindClosestPlayerOnLandInRangeSq(x, y, z, rangesq, isalive) → Player | nil
```
查找陆地上的最近玩家（排除海洋/船上）。

### FindPlayersInRange
```lua
FindPlayersInRange(x, y, z, range, isalive) → table
```
获取范围内所有玩家列表。

### FindPlayersInRangeSortedByDistance
```lua
FindPlayersInRangeSortedByDistance(x, y, z, range, isalive) → table
```
获取范围内所有玩家，按距离排序。

### IsAnyPlayerInRange
```lua
IsAnyPlayerInRange(x, y, z, range, isalive) → boolean
```
检查范围内是否有玩家。

### IsAnyOtherPlayerNearInst
```lua
IsAnyOtherPlayerNearInst(inst, rangesq, isalive) → boolean
```
检查实体附近是否有其他玩家（排除自身）。

---

## 3. 位置查找 (Position Finding)

### FindWalkableOffset ⭐ 核心
```lua
FindWalkableOffset(position, start_angle, radius, attempts, check_los, ignore_walls, customcheckfn, allow_water, allow_boats, ignore_teleportchecks) → offset, angle, deflected
```
从 position 出发，向 start_angle 方向，以扇形搜索一个可行走的位置。

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `position` | Vector3 | | 起始位置 |
| `start_angle` | number | | 起始角度（弧度） |
| `radius` | number | | 搜索半径 |
| `attempts` | number | | 搜索尝试次数（扇形分割数） |
| `check_los` | boolean | | 是否检查视线（路径畅通） |
| `ignore_walls` | boolean | | 是否忽略墙壁 |
| `customcheckfn` | function | | 自定义检查函数 |
| `allow_water` | boolean | | 是否允许水上位置 |
| `allow_boats` | boolean | | 是否允许船上位置 |
| `ignore_teleportchecks` | boolean | | 是否忽略传送检查 |

返回值：
- `offset` — 有效偏移位置 Vector3（nil 表示未找到）
- `angle` — 有效方向角度（弧度）
- `deflected` — 是否偏离了原始方向

```lua
-- 找一个安全的传送位置
local offset, angle = FindWalkableOffset(pos, math.random() * TWOPI, 5, 8, true, true)
if offset then
    inst.Transform:SetPosition(pos.x + offset.x, 0, pos.z + offset.z)
end
```

### FindSwimmableOffset
```lua
FindSwimmableOffset(position, start_angle, radius, attempts, check_los, ignore_walls, customcheckfn, allow_boats) → offset, angle, deflected
```
类似 FindWalkableOffset，但只搜索水域位置。

### FindValidPositionByFan
```lua
FindValidPositionByFan(start_angle, radius, attempts, test_fn) → offset, angle, deflected
```
通用扇形搜索，test_fn(offset) 返回 true 表示位置有效。

### FindSafeSpawnLocation
```lua
FindSafeSpawnLocation(x, y, z) → x, y, z
```
寻找安全的生成位置（优先最近玩家位置，其次玩家生成点，最后原点）。

### FindNearbyLand
```lua
FindNearbyLand(position, range) → Vector3 | nil
```
在 position 附近找到一块陆地。

### FindNearbyOcean
```lua
FindNearbyOcean(position, range) → Vector3 | nil
```
在 position 附近找到一片海洋。

### FindCharlieRezSpotFor
```lua
FindCharlieRezSpotFor(inst) → x, y, z
```
为 inst 找查理复活点（优先夜灯位置，其次生成点）。

### FindPickupableItem
```lua
FindPickupableItem(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, worker, extra_filter, inventoryoverride) → item, ispickable
```
在范围内寻找可拾取的物品。

| 参数 | 说明 |
|------|------|
| `owner` | 拾取者实体 |
| `radius` | 搜索半径 |
| `furthestfirst` | 从远到近搜索 |
| `positionoverride` | 替代搜索位置 |
| `ignorethese` | 忽略的实体表 |
| `onlytheseprefabs` | 只拾取特定 prefab |
| `allowpickables` | 是否允许 pickable（植物类） |
| `worker` | 工作实体 |
| `extra_filter` | 额外过滤函数 |
| `inventoryoverride` | 替代物品栏 |

**自动排除**: 燃烧中的、盔甲、武器、工具、装备品、容器、捆绑包、诱饵（在陷阱中的）、已布置的陷阱等。

---

## 4. 环境检测 (Environment)

### CanEntitySeeInDark
```lua
CanEntitySeeInDark(inst) → boolean
```
实体是否能在黑暗中看到（nightvision 标签或装备）。

### CanEntitySeeInStorm
```lua
CanEntitySeeInStorm(inst) → boolean
```
实体是否能在沙尘暴中看到（goggles 标签或装备）。

### CanEntitySeePoint
```lua
CanEntitySeePoint(inst, x, y, z) → boolean
```
实体能否看到指定位置（综合检查光照、夜视、沙尘暴）。

### CanEntitySeeTarget
```lua
CanEntitySeeTarget(inst, target) → boolean
```
实体能否看到目标实体。

---

## 5. 效果与动画 (Effects & Animation)

### ShakeAllCameras
```lua
ShakeAllCameras(mode, duration, speed, scale, source_or_pt, maxDist)
```
震动所有玩家的相机。

| 参数 | 类型 | 说明 |
|------|------|------|
| `mode` | string | 震动模式 ("FULL", "SIDE", "VERTICAL") |
| `duration` | number | 持续时间 |
| `speed` | number | 震动速度 |
| `scale` | number | 震动强度 |
| `source_or_pt` | Entity/Vector3 | 震源位置 |
| `maxDist` | number | 最大影响距离 |

### ShakeAllCamerasWithFilter
```lua
ShakeAllCamerasWithFilter(filterfn, mode, duration, speed, scale, source_or_pt, maxDist)
```
带过滤的相机震动，filterfn(player) 返回 true 才震动。

### ShakeAllCamerasOnPlatform
```lua
ShakeAllCamerasOnPlatform(mode, duration, speed, scale, platform)
```
只震平台上玩家的相机。

### AnimateUIScale
```lua
AnimateUIScale(item, total_time, start_scale, end_scale)
```
UI 缩放动画（协程方式）。

---

## 6. 其他工具函数

### SpringCombatMod
```lua
SpringCombatMod(amount, forced) → number
```
春天战斗伤害修正（默认乘 TUNING.SPRING_COMBAT_MOD）。

### SpringGrowthMod
```lua
SpringGrowthMod(amount, forced) → number
```
春天生长速度修正。

### TemporarilyRemovePhysics
```lua
TemporarilyRemovePhysics(obj, time)
```
临时移除实体碰撞（保留 WORLD 碰撞），time 秒后恢复。

### ErodeAway
```lua
ErodeAway(inst, erode_time)
```
实体逐渐消散（淡出动画 + 移除）。常用于掉落物、冰块融化等。

### ErodeCB
```lua
ErodeCB(inst, erode_time, cb, restore)
```
带回调的消散效果。

### ApplySpecialEvent
```lua
ApplySpecialEvent(event)
```
应用特殊事件（如 Winter's Feast 等）。

### ApplyExtraEvent
```lua
ApplyExtraEvent(event)
```
应用额外事件。

---

## 7. 资源注册 (Asset Registration)

### RegisterInventoryItemAtlas
```lua
RegisterInventoryItemAtlas(atlas, imagename)
```
注册物品栏图标图集。

### GetInventoryItemAtlas
```lua
GetInventoryItemAtlas(imagename, no_fallback) → atlas
```
获取物品栏图标图集。

### GetMinimapAtlas
```lua
GetMinimapAtlas(imagename) → atlas
```
获取小地图图标图集。

### RegisterScrapbookIconAtlas
```lua
RegisterScrapbookIconAtlas(atlas, imagename)
```
注册剪贴簿图标图集。

### GetScrapbookIconAtlas
```lua
GetScrapbookIconAtlas(imagename) → atlas
```
获取剪贴簿图标图集。

### RegisterSkilltreeBGAtlas
```lua
RegisterSkilltreeBGAtlas(atlas, imagename)
```
注册技能树背景图集。

### GetSkilltreeBG
```lua
GetSkilltreeBG(imagename) → atlas
```
获取技能树背景图集。

---

## 8. 弃用函数

```lua
GetWorld()  -- 已弃用，请使用 TheWorld 全局变量
GetPlayer() -- 已弃用，请使用 ThePlayer 全局变量
CalledFrom() -- 调试用，获取调用位置信息
```

---

## 9. 常用代码模式

### 查找最近玩家
```lua
local player = FindClosestPlayerToInst(inst, 20, true)  -- 20 范围，仅存活
if player then
    -- 对玩家做些什么
end
```

### 查找范围内怪物
```lua
local monster = FindEntity(inst, 30, nil, {"monster"}, {"player", "wall"})
```

### 安全传送
```lua
local x, y, z = inst.Transform:GetWorldPosition()
local offset = FindWalkableOffset(Vector3(x, y, z), math.random() * TWOPI, 4, 8, true, true)
if offset then
    inst.Transform:SetPosition(x + offset.x, 0, z + offset.z)
end
```

### 屏幕震动
```lua
ShakeAllCameras(CAMERASHAKE.FULL, 0.5, 0.02, 0.5, inst, 40)
```
