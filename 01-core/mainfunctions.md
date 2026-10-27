# 全局函数

> 源码文件：`scripts/mainfunctions.lua`（及 `main.lua` 中声明的其他全局函数）

## 实体相关

### CreateEntity([name]) → EntityScript
创建实体。
```lua
local inst = CreateEntity("自定义名字")
```

### SpawnPrefab(name [, skin], [skin_id], [creator], [skin_custom]) → EntityScript
生成预制体实例。最常用的函数。
```lua
local tree = SpawnPrefab("evergreen")
tree.Transform:SetPosition(10, 0, 10)
```

### SpawnPrefabFromSim(name) → GUID
从引擎层生成预制体（返回 GUID）。

### ReplacePrefab(original_inst, name [, skin], [skin_id], [creator]) → EntityScript
替换实体。

### PrefabExists(name) → boolean
检查预制体是否存在。

### SpawnSaveRecord(saved [, newents]) → EntityScript
从存档记录生成实体。

### OnRemoveEntity(entityguid)
内部函数，实体移除时的清理。

### RemoveEntity(guid)
移除实体。

### PushEntityEvent(guid, event, data)
向指定 GUID 的实体推送事件。

### GetEntityDisplayName(guid) → string
获取实体显示名称。

### GetEntityString(guid) → string
获取实体调试字符串。

## 预制体注册

### RegisterPrefabs(...)
批量注册预制体。

### RegisterSinglePrefab(prefab)
注册单个预制体。

### LoadPrefabFile(filename [, async_batch_validation], [search_asset_first_path])
加载预制体文件。

### RegisterAchievements(achievements)
注册成就。

### LoadAchievements(filename)
加载成就文件。

## 时间函数

### GetTime() → number
获取游戏时间（受时间缩放影响）。单位：秒。
```lua
local now = GetTime()
```

### GetTickTime() → number
获取每 Tick 的时间（秒）。

### GetStaticTime() → number
获取静态时间（不受时间缩放影响）。

### GetTick() → number
获取当前 Tick 数。

### GetStaticTick() → number
获取静态 Tick 数。

### GetTimeReal() → number
获取真实时间（毫秒）。

### GetTimeRealSeconds() → number
获取真实时间（秒）。

## 持久化

### SavePersistentString(name, data, encode, callback)
保存持久化字符串。
```lua
SavePersistentString("mymod_data", json.encode(data), false, function()
    print("保存完成")
end)
```

### ErasePersistentString(name [, callback])
删除持久化字符串。

### SaveGame([isshutdown], [cb])
保存游戏。

### ParseUserSessionData(data) → playerdata, prefab
解析用户会话数据。

### ResumeExistingUserSession(data, guid)
恢复用户会话。

### RestoreSnapshotUserSession(sessionid, userid)
恢复快照用户会话。

## 暂停控制

### SetPause(val [, reason])
设置游戏暂停状态。

### IsPaused() → boolean
游戏是否暂停。

### IsSimPaused() → boolean
模拟是否暂停。

### SetServerPaused(pause)
设置服务端暂停。

### SetAutopaused(autopause)
设置自动暂停。

### SetCraftingAutopaused(autopause)
设置制作自动暂停。

### SetConsoleAutopaused(autopause)
设置控制台自动暂停。

### SetDefaultTimeScale(scale)
设置默认时间缩放。

## 网络

### ReplicateEntity(guid)
复制实体到客户端。

### DisableLoadingProtection(guid)
禁用加载保护。

### OnPlayerLeave(player_guid, expected)
玩家离开时的回调。

### OnNetworkDisconnect(message, should_reset, force_immediate_reset, details, miscdata)
网络断开回调。

### OnPushPopupDialog(message)
接收弹出对话框消息。

### OnDemoTimeout()
试玩超时。

## 世界生成

### NotifyLoadingState(loading_state, match_results)
通知加载状态。

## UI / 前端

### ShowBadHashUI()
显示文件哈希错误UI。

### TintBackground(bg)
背景着色。

### LoadFonts() / UnloadFonts()
加载/卸载字体。

### DisplayAntiAddictionNotification(notification)
显示防沉迷通知。

## 程序控制

### Start()
游戏启动入口。

### GlobalInit()
全局初始化（只调用一次）。

### SimReset(instanceparameters)
模拟重置。

### Shutdown()
关闭模拟。

### RequestShutdown()
请求关闭。

### DoRestart(save)
执行重启。

### DoLoadingPortal(cb)
执行加载过渡。

### LoadMapFile(map_name)
加载地图文件。

### StartNextInstance(in_params)
启动下一个实例。

### ForceAssetReset()
强制资源重置。

### ExecuteConsoleCommand(fnstr, guid, x, z)
执行控制台命令。

### DisplayError(error)
显示错误界面。

## NIS（非交互场景）

### PlayNIS(nisname, lines) → inst
播放 NIS 场景。
```lua
local nis_inst = PlayNIS("intro", lines)
```

## 世界状态标签

### CreateWorldStateTag(namespace, atlas) → WorldStateTagObject
创建世界状态标签命名空间。

### GetWorldStateTagObjectFromNamespace(namespace) → object
### GetWorldStateTagObjectFromTag(tag) → object
### ForEachWorldStateTagObject(fn, ...)

## 声音

### CreateRepeatedSoundVolumeReduction(repeat_time, lowered_volume_percent) → function
创建重复声音音量衰减函数。

## 工具函数

### Print(msg_verbosity, ...)
条件打印。只在 verbosity 级别满足时输出。

### SecondsToTimeString(total_seconds) → string
秒数转时间字符串。

### ShouldIgnoreResolve(filename, assettype) → boolean
判断是否需要忽略资源解析。

### InGamePlay() → boolean
是否在游戏中。

### IsMigrating() → boolean
是否正在迁移。

### IsInFrontEnd() → boolean
是否在前端界面。

### JapaneseOnPS4() → boolean

## 成就

### AwardFrontendAchievement(name)
### AwardPlayerAchievement(name, player)
### NotifyPlayerProgress(name, value, player)
### NotifyPlayerPresence(name, level, days, player)
### AwardRadialAchievement(name, pos, radius)

## 文件完整性

### BeginDataBundleFileHashes()
### DataBundleFileHashes(calculatedhashes)

## 账号

### RegisterOnAccountEventListener(listener)
### RemoveOnAccountEventListener(listener_to_remove)
### OnAccountEvent(success, event_code, custom_message)
