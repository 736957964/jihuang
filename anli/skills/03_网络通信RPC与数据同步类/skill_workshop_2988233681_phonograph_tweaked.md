# 饥荒工业级最佳实践范式：Phonograph Tweaked
> 对应工坊权威基准：Mod 2988233681 (`Phonograph Tweaked`)
> 技术分类：03_网络通信RPC与数据同步类 | 源码规模：4 文件 / 891 行

---

## 一、架构背景与设计哲学
本范式旨在解决饥荒联机版中 Phonograph Tweaked 涉及的架构协同难题。
在官方源码机制下，原版逻辑对相关切面具备较强的封闭性。通过精准挂载钩子、隔离脏标记通信及遵循生命周期规范，实现无侵入式工业级扩展。

## 二、核心底层算法与网络拓扑机制
1. **系统注入切面与挂载拓扑**：
   - 提取到核心切面钩子：`['AddPrefabPostInit:phonograph', 'AddPrefabPostInit:world']`；
   - 依赖官方底层实体生命周期：在 `PreInit` 完成网络数据对齐，在 `PostInit` 挂载业务监听，确保跨客户端无缝通信。

## 三、标准化生产级代码范式（可直接移植）

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2988233681)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("phonograph", function(inst)
    inst.record_song = _G.net_string(inst.GUID, "phonograph.song", "phonographsongdirty")
    inst.record_playing = _G.net_bool(inst.GUID, "phonograph.playing", "phonographplayingdirty")
    inst.record_elapsed = _G.net_float(inst.GUID, "phonograph.elapsed", "phonographelapseddirty")
    inst.record_catchup_speed = _G.net_float(inst.GUID, "phonograph.catchupspeed", "phonographcatchupspeeddirty")
    inst.record_volume = _G.net_byte(inst.GUID, "phonograph.volume", "phonographvolumedirty")
    inst.record_repeat = _G.net_bool(inst.GUID, "phonograph.repeat", "phonographrepeatdirty")
    inst.record_loop = _G.net_byte(inst.GUID, "phonograph.loop", "phonographloopdirty")

    inst:ListenForEvent("phonographplayingdirty", ClientSyncPlayback)
    inst:ListenForEvent("phonographloopdirty", ClientSyncPlayback)

    if inst.record_playing:value() then
        ClientSyncPlayback(inst)
    end

    if not _G.TheWorld.ismastersim then
        return
    end

    inst.record_volume:set(100)

    inst.UpdatePlaybackState = function(inst)
        local playlist = GetActivePlaylist(inst)
        if playlist == nil or inst._playlist_start_walltime == nil then
            return
        end

        local total_elapsed = _G.os.time() - inst._playlist_start_walltime
        local song, offset = GetCurrentSongAndOffset(playlist, total_elapsed)

        inst.record_elapsed:set(offset)
        inst.record_catchup_speed:set(song.catchup_speed or PHONOGRAPH_DEFAULT_CATCHUP_SPEED)
        if song.event ~= inst.record_song:value() then
            inst.record_song:set(song.event)
            NextLoop(inst)
        end
        if not inst.record_playing:value() then
            inst.record_playing:set(true)
        end

        if inst._playback_update_task then
            inst._playback_update_task:Cancel()
        end
        inst._playback_update_task = inst:DoTaskInTime(math.max(song.length - offset, 1), inst.OnSongFinished)
    end

    inst.OnSongFinished = function(inst)
        NextLoop(inst)
        inst:UpdatePlaybackState()
    end

    inst.SendPlaybackPosition = function(inst, player)
        if player == nil or not inst.record_playing:value() then
            return
        end
        local song = inst.record_song:value()
        local offset = 0
        local speed = PHONOGRAPH_DEFAULT_CATCHUP_SPEED
        if inst._playlist ~= nil and inst._playlist_start_walltime ~= nil then
            inst:UpdatePlaybackState()
            local current, current_offset = GetCurrentSongAndOffset(GetActivePlaylist(inst), _G.os.time() - inst._playlist_start_walltime)
            song = current.event
            offset = current_offset
            speed = current.catchup_speed or PHONOGRAPH_DEFAULT_CATCHUP_SPEED
        end
        SendModRPCToClient(GetClientModRPC(MOD_RPC_NAMESPACE, "PlaybackPosition"), player.userid, inst, song, offset, speed, inst.record_loop:value())
    end

    inst.ChooseSongToPlay = function(inst, song_index)
        local record = inst.components.inventory and inst.components.inventory:GetItemsWithTag("phonograph_record")[1]
        if record == nil then
            return
        end

        local key = record.songToPlay_skin or record.songToPlay
        local playlist = _G.PHONOGRAPH_SONG_PLAYLISTS[key]
        if playlist == nil or playlist[song_index] == nil then
            return
        end

        inst._playlist = playlist
        inst._repeat_index = song_index

        local offset_into_playlist = 0
        if not inst.record_repeat:value() then
            for i = 1, song_index - 1 do
                offset_into_playlist = offset_into_playlist + playlist[i].length
            end
        end
        inst._playlist_start_walltime = _G.os.time() - offset_into_playlist

        if inst.components.machine:IsOn() then
            inst.components.machine:TurnOff()
        end
        inst.components.machine:TurnOn()
    end

    inst.SetPhonographVolume = function(inst, volume)
        if type(volume) ~= "number" then
            volume = 100
        end
        volume = math.floor(volume + 0.5)
        if volume < 0 then
            volume = 0
        elseif volume > 100 then
            volume = 100
        end
        inst.record_volume:set(volume)
    end

    local old_OnSave = inst.OnSave
    local old_OnLoad = inst.OnLoad

    inst.OnSave = function(inst, data)
        if old_OnSave then
            old_OnSave(inst, data)
        end
        if (inst.record_playing:value() or inst._waiting_for_player) and inst._playlist ~= nil and inst._playlist_start_walltime ~= nil then
            local record = inst.components.inventory and inst.components.inventory:GetItemsWithTag("phonograph_record")[1]
            if record ~= nil then
                data.chosen_key = record.songToPlay_skin or record.songToPlay
                data.playlist_start_walltime = inst._playlist_start_walltime
            end
        end
        data.volume = GetPhonographVolume(inst)
        data.repeat_one = inst.record_repeat:value()
        data.repeat_index = inst._repeat_index
    end

    inst.OnLoad = function(inst, data)
        if data ~= nil and data.volume ~= nil then
            inst.record_volume:set(data.volume)
        end

        if data ~= nil then
            inst.record_repeat:set(data.repeat_one == true)
            inst._repeat_index = data.repeat_index
        end

        if data ~= nil and data.chosen_key ~= nil and data.playlist_start_walltime ~= nil then
            local playlist = _G.PHONOGRAPH_SONG_PLAYLISTS[data.chosen_key]
            if playlist ~= nil then
                inst._playlist = playlist
                inst._playlist_start_walltime = data.playlist_start_walltime
            end
        end

        if old_OnLoad then
            old_OnLoad(inst, data)
        end

        if inst._playlist ~= nil then
            if inst.components.machine:IsOn() then
                inst.components.machine:TurnOff()
            end

            local function StartPlayback()
                inst._waiting_for_player = nil
                inst._playlist_start_walltime = _G.os.time() - GetSongStartOffset(GetActivePlaylist(inst), _G.os.time() - inst._playlist_start_walltime)
                inst.components.machine:TurnOn()
            end

            if #_G.AllPlayers > 0 then
                StartPlayback()
            else
                inst._waiting_for_player = true
                local function OnPlayerJoined()
                    inst:RemoveEventCallback("ms_playerjoined", OnPlayerJoined, _G.TheWorld)
                    StartPlayback()
                end
                inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, _G.TheWorld)
            end
        end
    end
end)

local old_turnon_fn = _G.ACTIONS.TURNON.fn
_G.ACTIONS.TURNON.fn = function(act)
    if act.target ~= nil and act.target.prefab == "phonograph" and act.doer ~= nil then
        local record = act.target.components.inventory and act.target.components.inventory:GetItemsWithTag("phonograph_record")[1]
        if record ~= nil then
            local key = record.songToPlay_skin or record.songToPlay
            local playlist = _G.PHONOGRAPH_SONG_PLAYLISTS[key]
            if playlist ~= nil then
                SendModRPCToClient(GetClientModRPC(MOD_RPC_NAMESPACE, "OpenSongScreen"), act.doer.userid, act.target, key)
                return true
            end
        end
    end
    return old_turnon_fn(act)
end

AddPrefabPostInit("world", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end

    local function StopPlayingRecord(inst)
        if inst._tend_update_task then
            inst._tend_update_task:Cancel()
            inst._tend_update_task = nil
        end

        if inst._playback_update_task then
            inst._playback_update_task:Cancel()
            inst._playback_update_task = nil
        end

        inst.record_playing:set(false)

        inst.AnimState:PlayAnimation("idle")
        inst.SoundEmitter:PlaySound("dontstarve/music/gramaphone_end")

        inst:PushEvent("turnedoff")

        inst.entity:SetCanSleep(true)

        inst.components.inventoryitem.canbepickedup = true
    end
    UpvalueHacker.SetUpvalue(_G.Prefabs.phonograph.fn, StopPlayingRecord, "StopPlayingRecord")


    local FARM_PLANT_TAGS = {"tendable_farmplant"}
    local function song_update(inst)
        local ix, iy, iz = inst.Transform:GetWorldPosition()
        local nearby_tendable_plants = TheSim:FindEntities(ix, iy, iz, TUNING.PHONOGRAPH_TEND_RANGE, FARM_PLANT_TAGS)
        for _, tendable_plant in pairs(nearby_tendable_plants) do
            tendable_plant.components.farmplanttendable:TendTo()
        end
    end

    local function TryToPlayRecord(inst)
        if inst.components.inventoryitem:IsHeld() then
            inst.components.machine.enabled = false
            return
        end

        if inst._playlist ~= nil and inst._playlist_start_walltime ~= nil then
            inst.components.machine.enabled = true
            inst.AnimState:PushAnimation("play_loop", true)
            NextLoop(inst)
            inst:UpdatePlaybackState()
            inst._tend_update_task = inst:DoPeriodicTask(TUNING.PHONOGRAPH_TEND_PERIOD, song_update, 1)
            inst.entity:SetCanSleep(false)
            inst.components.inventoryitem.canbepickedup = false
            return
        end

        local song = inst:GetRecordSong()
        if not song then
            inst.components.machine.enabled = false
            return
        end

        inst.components.machine.enabled = true
        inst.AnimState:PushAnimation("play_loop", true)
        inst.record_elapsed:set(0)
        inst.record_catchup_speed:set(PHONOGRAPH_DEFAULT_CATCHUP_SPEED)
        inst.record_song:set(song)
        NextLoop(inst)
        inst.record_playing:set(true)

        inst._tend_update_task = inst:DoPeriodicTask(TUNING.PHONOGRAPH_TEND_PERIOD, song_update, 1)

        inst.entity:SetCanSleep(false)

        inst.components.inventoryitem.canbepickedup = false
    end
    UpvalueHacker.SetUpvalue(_G.Prefabs.phonograph.fn, TryToPlayRecord, "TryToPlayRecord")


    local function OnGetItemFromPlayer(inst, giver, item)
        inst:DropRecord()
        inst.components.inventory:GiveItem(item)
        inst.AnimState:PlayAnimation("open")

        inst._playlist = nil
        inst._playlist_start_walltime = nil

        local key = item.songToPlay_skin or item.songToPlay
        local playlist = _G.PHONOGRAPH_SONG_PLAYLISTS[key]

        if playlist ~= nil then
            inst.components.machine.enabled = true
        else
            inst.components.machine.enabled = true
            if not inst.components.machine:IsOn() then
                inst.components.machine:TurnOn()
            end
        end
    end
    UpvalueHacker.SetUpvalue(_G.Prefabs.phonograph.fn, OnGetItemFromPlayer, "OnGetItemFromPlayer")

    local function OnDecorGiven(inst, item, giver)
        if not item then return end

        inst.SoundEmitter:PlaySound("wintersfeast2019/winters_feast/table/food")

        if item.Physics then item.Physics:SetActive(false) end
        if item.prefab == "phonograph" then inst.entity:SetCanSleep(false) end

        if item.Follower then item.Follower:FollowSymbol(inst.GUID, "swap_object") end
    end
    UpvalueHacker.SetUpvalue(_G.Prefabs.wood_table_round.fn, OnDecorGiven, "OnDecorGiven")

    local function OnDecorTaken(inst, item)
        if item then
            if item.Physics then item.Physics:SetActive(true) end
            if item.prefab == "phonograph" then inst.entity:SetCanSleep(true) end

            if item.Follower then item.Follower:StopFollowing() end
        end
    end
    UpvalueHacker.SetUpvalue(_G.Prefabs.wood_table_round.fn, OnDecorTaken, "OnDecorTaken")
end)
```

## 四、方案对比矩阵与权衡取舍（Trade-off Matrix）

| 技术选型方案 | 核心技术原理 | 优势与收益 | 代价与潜在风险 | 推荐适用场景 |
| :--- | :--- | :--- | :--- | :--- |
| **方案 A：PostInit 深度切面（本母本）** | 挂载官方标准生命周期注入点 | 原生兼容性高、零侵入、支持跨 Mod 协同 | 需精确处理加载先后时序 | 绝大多数公网联机与模组服 |
| **方案 B：全局暴力覆写（Anti-Pattern）** | 篡改全局函数或暴力替换 Class | 编写简单快速、无需排查依赖链 | 极易造成 Mod 相互排斥及坏档 | 个人单机测试环境 |

## 五、进阶拓扑演进与变体分支
- **分支 1（网络预测优化）**：若需支持客机零延迟预表现，可在客户端副本（Replica）装载本地预表现动画。
- **分支 2（高负载防抖截流）**：在高频 RPC 或高频网络事件中挂载脏标记脏池，防止包泛洪。

## 六、踩坑与反模式避错指南（防御性闭环）
1. **网络变量声明时机**：所有 `net_*` 必须在 `inst.entity:AddNetwork()` 后、`SetPristine()` 前注册，严禁在预制体后处理的尾部动态挂载。
2. **重入锁防御**：在复杂事件分发时，务必维护实体级别的布尔标记，防止死循环递归。
