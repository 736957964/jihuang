# EntityScript — 实体脚本

> 源码文件：`scripts/entityscript.lua`
> 
> `EntityScript` 是所有游戏实体的 Lua 端包装。每个实体（物品、生物、建筑等）在 Lua 中都是 `EntityScript` 的实例，通过 `inst` 变量访问。

## 构造函数

```lua
EntityScript = Class(function(self, entity)
    self.entity = entity
    self.components = {}
    self.lower_components_shadow = {}
    self.GUID = entity:GetGUID()
    self.spawntime = GetTime()
    self.persists = true
    self.inlimbo = false
    self.name = nil
    -- ... 更多初始化
end)
```

## 核心属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `inst.entity` | Entity | 引擎层实体对象 |
| `inst.GUID` | number | 实体全局唯一ID |
| `inst.prefab` | string | 预制体名称 |
| `inst.components` | table | 组件表，通过 `inst.components.xxx` 访问 |
| `inst.persists` | boolean | 是否持久化保存（默认true） |
| `inst.inlimbo` | boolean | 是否在limbo状态（移除场景） |
| `inst.name` | string | 实体显示名称 |
| `inst.sg` | StateGraphInstance | 状态机实例 |
| `inst.brain` | Brain | 大脑/行为树实例 |
| `inst.parent` | EntityScript | 父实体 |
| `inst.platform` | EntityScript | 所在平台 |
| `inst.bufferedaction` | BufferedAction | 当前缓冲动作 |
| `inst.replica` | table | 客户端同步副本组件（客户端用） |
| `inst.data` | table | 自定义数据存储 |
| `inst.children` | table | 子实体集合 |
| `inst.listeners` | table | 事件监听者 |
| `inst.event_listeners` | table | 广播事件的监听者 |
| `inst.event_listening` | table | 正在监听的事件 |
| `inst.spawntime` | number | 实体生成时间 |

## 组件操作

### inst:AddComponent(name)
添加一个组件到实体。

```lua
local health = inst:AddComponent("health")
health:SetMaxHealth(100)
```

**注意**：重复添加同名组件会打印警告并返回已有组件。

### inst:RemoveComponent(name)
移除一个组件。会触发 `OnRemoveFromEntity` 回调。

```lua
inst:RemoveComponent("burnable")
```

### 访问组件
```lua
inst.components.health:SetMaxHealth(100)
inst.components.inventory:GiveItem(item)

-- 客户端副本组件
inst.replica.health:GetCurrent()
inst.replica.inventoryitem:IsWet()
```

## 标签操作 (Tags)

### inst:AddTag(tag)
```lua
inst:AddTag("player")
inst:AddTag("monster")
```

### inst:RemoveTag(tag)
```lua
inst:RemoveTag("INLIMBO")
```

### inst:HasTag(tag) → boolean
```lua
if inst:HasTag("player") then
    -- 是玩家
end
```

### inst:HasTags(...) / inst:HasAllTags(...) → boolean
检查是否拥有所有指定标签。
```lua
if inst:HasTags("monster", "hostile") then
    -- 是敌意怪物
end
```

### inst:HasOneOfTags(...) / inst:HasAnyTag(...) → boolean
检查是否拥有任一标签。
```lua
if inst:HasOneOfTags("tree", "structure") then
    -- 是树或建筑
end
```

### inst:AddOrRemoveTag(tag, condition)
```lua
inst:AddOrRemoveTag("sleeping", shouldSleep)
```

## 事件系统

### inst:ListenForEvent(event, fn [, source])
监听事件。默认 source 是 self。
```lua
inst:ListenForEvent("healthdelta", function(inst, data)
    print("血量变化:", data.oldpercent, "->", data.newpercent)
end)

-- 监听世界事件
inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
```

### inst:RemoveEventCallback(event, fn [, source])
移除事件回调。fn 参数必填！
```lua
inst:RemoveEventCallback("healthdelta", myCallback)
```

### inst:RemoveAllEventCallbacks()
移除该实体的所有事件监听。

### inst:PushEvent(event [, data])
推送事件到自身。会通知所有监听者、SG 和 Brain。
```lua
inst:PushEvent("attacked", { attacker = monster, damage = 10 })
```

### inst:PushEventImmediate(event [, data])
立即推送事件（不经过 SG 队列）。

## 世界状态监视

### inst:WatchWorldState(var, fn)
监视世界状态变化（如季节、天气等）。
```lua
inst:WatchWorldState("iswinter", function(inst, iswinter)
    if iswinter then
        inst.AnimState:Hide("flower")
    else
        inst.AnimState:Show("flower")
    end
end)
```

### inst:StopWatchingWorldState(var, fn)
### inst:StopAllWatchingWorldStates()

## 位置与距离

### inst:GetPosition() → Point
```lua
local pos = inst:GetPosition()
print(pos.x, pos.y, pos.z)
```

### inst:GetRotation() → number
返回角度（度）。

### inst:GetDistanceSqToInst(other_inst) → number
返回与另一实体距离的平方。

### inst:IsNear(other_inst, dist) → boolean
```lua
if inst:IsNear(player, 5) then
    -- 距离玩家5单位以内
end
```

### inst:GetDistanceSqToPoint(x, y, z) → number
也支持传入 Point/Vector3 对象。

### inst:IsNearPlayer(range [, isalive]) → boolean
### inst:GetNearestPlayer([isalive]) → player_inst
### inst:GetDistanceSqToClosestPlayer([isalive]) → number

### inst:GetAngleToPoint(x, y, z) → number
返回朝向目标点的角度（度）。

### inst:FacePoint(x, y, z)
面朝目标点（busy状态下不会转向）。

### inst:ForceFacePoint(x, y, z)
强制面朝目标点。

### inst:FaceAwayFromPoint(dest [, force])

### inst:GetPositionAdjacentTo(target, distance) → Vector3

### inst:IsEntityInFrontConeSlice(other, arc_angle_degrees, max_dist, circle_dist) → boolean

## 地面与海洋

### inst:IsOnValidGround() → boolean
是否在有效地面上（不含船）。

### inst:IsOnPassablePoint([include_water], [floating_platforms_not_passable]) → boolean
是否在可通过点。

### inst:IsOnOcean([allow_boats]) → boolean
是否在海洋上。

### inst:GetCurrentPlatform() → platform
获取当前所在平台（船等）。

### inst:GetCurrentTileType() → tile, tileinfo
获取当前所在的地块类型。

### inst:PutBackOnGround([radius]) → boolean
将实体放回到有效地面上。

## 光照

### inst:IsInLight() → boolean
是否在光照中。

### inst:IsLightGreaterThan(lightThresh) → boolean
光照强度是否大于阈值。

## 湿润度

### inst:GetIsWet() → boolean
是否潮湿（客户端可用）。

### inst:GetWetMultiplier() → number (0-1)
潮湿程度（仅主端）。

### inst:IsAcidSizzling() → boolean
是否受到酸雨影响。

## 计时器与任务

### inst:DoTaskInTime(time, fn, ...) → task
延迟执行任务。
```lua
inst:DoTaskInTime(3, function(inst)
    inst:Remove()
end)
```

### inst:DoPeriodicTask(time, fn [, initialdelay], ...) → task
周期性执行任务。
```lua
inst:DoPeriodicTask(1, function(inst)
    print("每秒执行")
end)
```

### inst:DoStaticTaskInTime(time, fn, ...) → task
静态延迟任务（不受时间缩放影响）。

### inst:DoStaticPeriodicTask(time, fn [, initialdelay], ...) → task
静态周期性任务。

### inst:GetTaskInfo(time) → taskinfo
### inst:TimeRemainingInTask(taskinfo) → number
### inst:ResumeTask(time, fn, ...) → task, taskinfo

### inst:CancelAllPendingTasks()
取消所有待执行任务。

### inst:KillTasks()
杀死与该实体相关的所有协程。

### inst:StartThread(fn)
启动一个与实体生命周期绑定的协程。
```lua
inst:StartThread(function()
    while true do
        -- do something
        Sleep(1)
    end
end)
```

## BufferedAction（缓冲动作）

### inst:ClearBufferedAction()
清除当前缓冲动作。

### inst:PreviewBufferedAction(bufferedaction)
预执行缓冲动作。

### inst:PerformPreviewBufferedAction()
执行预缓冲动作。

### inst:PushBufferedAction(bufferedaction)
推送缓冲动作。

### inst:PerformBufferedAction()
执行缓冲动作。

### inst:GetBufferedAction() → BufferedAction | nil

## InherentAction（固有动作）

### inst:AddInherentAction(action)
添加固有动作（如 `ACTIONS.EQUIP`）。

### inst:RemoveInherentAction(action)

### inst:CanDoAction(action) → boolean
检查是否可以执行某动作。

## 场景进出 (Limbo)

### inst:RemoveFromScene()
将实体移出场景（进入limbo状态）。会自动暂停SG、Brain、Physics等。

### inst:ReturnToScene()
将实体返回场景。

### inst:IsInLimbo() → boolean

### inst:ForceOutOfLimbo(state)
强制保持在场景中。

## 睡眠/唤醒

### inst:IsAsleep() → boolean

## 名称与显示

### inst:SetPrefabName(name)
设置预制体名称。

### inst:SetPrefabNameOverride(nameoverride)
设置名称覆盖。

### inst:GetDisplayName() → string
获取完整显示名称（含形容词修饰）。

### inst:GetBasicDisplayName() → string
获取基础名称。

### inst:GetAdjectivedName() → string
获取带形容词的名称（如潮湿的、腐烂的等）。

### inst:GetAdjective() → string

## 皮肤

### inst:GetSkinBuild() → string
获取皮肤Build名称。

### inst:GetSkinName() → string
获取皮肤名称。

## 父子关系

### inst:AddChild(child)
添加子实体。

### inst:RemoveChild(child)
移除子实体。

### inst:SpawnChild(name) → child_inst
创建并添加子实体。

## 平台关系

### inst:AddPlatformFollower(child)
### inst:RemovePlatformFollower(child)
### inst:GetPlatformFollowers() → table

## 持久化 (Save/Load)

### inst:GetSaveRecord() → record, references
### inst:GetPersistData() → data, references
### inst:SetPersistData(data [, newents])
### inst:LoadPostPass(newents, savedata)

## 回调生命周期

以下方法在实体上定义，在特定时机自动调用：

| 回调 | 触发时机 |
|------|----------|
| `inst.OnSave(inst, data)` | 保存时 |
| `inst.OnLoad(inst, data)` | 加载时 |
| `inst.OnPreLoad(inst, data)` | 加载前 |
| `inst.OnLoadPostPass(inst, newents, savedata)` | 加载后处理 |
| `inst.OnBuilt(builder)` | 被建造时 |
| `inst.OnBuiltFn` | 被建造时（另一入口） |
| `inst.OnRemoveEntity()` | 被移除时 |
| `inst.OnEntitySleep()` | 实体睡眠时 |
| `inst.OnEntityWake()` | 实体唤醒时 |
| `inst.OnPhysicsWake()` | 物理唤醒时 |
| `inst.OnPhysicsSleep()` | 物理睡眠时 |
| `inst.OnLongUpdate(dt)` | 长时更新 |
| `inst.OnUsedAsItem(action, doer, target)` | 作为物品使用时 |

## 组件回调

组件中可定义以下回调：

| 回调 | 触发时机 |
|------|----------|
| `component:OnSave()` | 保存时，返回 data, refs |
| `component:OnLoad(data, newents)` | 加载时 |
| `component:LoadPostPass(newents, data)` | 加载后处理 |
| `component:OnRemoveFromEntity()` | 组件被移除时 |
| `component:OnRemoveEntity()` | 实体被移除时 |
| `component:OnEntitySleep()` | 实体睡眠时 |
| `component:OnEntityWake()` | 实体唤醒时 |
| `component:OnPhysicsWake()` | 物理唤醒时 |
| `component:OnPhysicsSleep()` | 物理睡眠时 |
| `component:LongUpdate(dt)` | 长时更新 |
| `component:OnBuilt(builder)` | 被建造时 |
| `component:OnUsedAsItem(action, doer, target)` | 作为物品使用时 |

## Brain（大脑）操作

### inst:SetBrain(brainfn)
设置大脑函数。

### inst:StopBrain(reason)
暂停大脑。

### inst:RestartBrain(reason)
重启大脑。

## StateGraph（状态机）操作

### inst:SetStateGraph(name)
设置状态机。

### inst:ClearStateGraph()
清除状态机。

## 更新组件管理

### inst:StartUpdatingComponent(cmp [, do_static_update])
开始更新某组件。

### inst:StopUpdatingComponent(cmp)
停止更新某组件。

### inst:StartWallUpdatingComponent(cmp)
开始墙上更新组件。

### inst:StopWallUpdatingComponent(cmp)
停止墙上更新组件。

### inst:GetComponentName(cmp) → string

## Debuff 系统

### inst:DebuffsEnabled() → boolean
### inst:HasDebuff(name) → boolean
### inst:GetDebuff(name) → debuff | nil
### inst:AddDebuff(name, prefab, data [, skip_test], [pre_buff_fn], [buffer]) → boolean
### inst:RemoveDebuff(name)

## 死亡掉落系统

### inst:SetDeathLootLevel(num)
### inst:GetDeathLootLevel() → number
### inst:DropDeathLoot()
### inst:GetDeathLoot() → table | nil

## 其他工具方法

### inst:Remove()
完全移除实体（触发所有清理逻辑）。

### inst:IsValid() → boolean
实体是否有效。

### inst:CanInteractWith(inst) → boolean
能否与另一实体交互。

### inst:GetTimeAlive() → number
实体存活时间（秒）。

### inst:GetPhysicsRadius(default) → number
获取物理半径。

### inst:SetPhysicsRadiusOverride(radius)
设置物理半径覆盖。

### inst:GetBoatIntersectingPhysics() → boat_inst | nil

### inst:GetDebugString() → string
获取调试信息。

### inst:GetBrainString() → string
获取大脑调试信息。

### inst:RunScript(name)
加载并执行脚本。

### inst:Hide() / inst:Show()
隐藏/显示实体。

### inst:SetDeployExtraSpacing(spacing)
### inst:SetDeploySmartRadius(radius)
### inst:SetTerraformExtraSpacing(spacing)
### inst:SetGroundTargetBlockerRadius(radius)

## SceneAction（场景动作）

### inst:SetInherentSceneAction(action)
### inst:SetInherentSceneAltAction(action)

## ClientSide Inventory Image

### inst:SetClientSideInventoryImageOverride(flagname, src, dest, destatlas)
### inst:HasClientSideInventoryImageOverrides() → boolean
### inst:GetClientSideInventoryImageOverride(imagenamehash)
### inst:SetClientSideInventoryImageOverrideFlag(name, value)

## 闭包/私有变量提示

以下变量定义在 `entityscript.lua` 中但**不在 EntityScript 类内部**（闭包内），无法通过 `inst` 直接访问但可以通过组件间接修改：

- `Components = {}` — 组件加载缓存
- `StateGraphs = {}` — SG 加载缓存
- `EventServerFiles = {}` — 事件服务端文件缓存
- `ClientSideInventoryImageFlags = {}` — 客户端库存图片标志
- `StopUpdatingComponents = {}` — 停止更新组件的临时表
- `modprefabinitfns = {}` — Mod PostInit 函数缓存（在 mainfunctions.lua 中）
