# 饥荒一线工坊深度研读 Skill：伴生网络信标（Classified Entity）与跨视距同步架构

- **工坊 ID**：378160973 (`Global Positions`)
- **领域分类**：联机网络同步机制、Classified 伴生轻量实体设计、远距离跨视距雷达穿透、团队迷雾序列化互通
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

饥荒联机版的实体系统具有严格的**网络休眠与视距裁剪机制**：离开玩家视距范围的实体不会向客机同步坐标。若要制作诸如“全图指示器、队友雷达、跨屏求救标记、甚至载具追踪”，最佳解法就是模仿官方与 `Global Positions` 采用的 **伴生微型信标（Classified Proxy Entity）**。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：轻量伴生网络信标预制体定义 (scripts/prefabs/my_beacon_classified.lua)
-- ==============================================================================

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:Hide() -- 视觉隐藏，仅作网络数据桥梁

    inst:AddTag("CLASSIFIED")
    inst.entity:SetCanSleep(false) -- 核心：常驻全图不休眠

    -- 网络变量 (NetVars) 定义
    inst.host_guid = net_entity(inst.GUID, "host_entity")
    inst.beacon_type = net_string(inst.GUID, "beacon_type")
    inst.is_active = net_bool(inst.GUID, "is_active", "activedirty")

    inst.entity:SetPristine()

    -- 客户端逻辑
    if not TheWorld.ismastersim then
        inst:ListenForEvent("activedirty", function()
            -- 触发客机雷达/小地图注册
            if ThePlayer and ThePlayer.HUD and inst.is_active:value() then
                ThePlayer.HUD:PushEvent("register_custom_beacon", { beacon = inst })
            end
        end)
        return inst
    end

    inst.persists = false -- 不持久化到硬盘，由宿主动态派生
    return inst
end

return Prefab("my_beacon_classified", fn)


-- ==============================================================================
-- 范式 2：宿主实体服务端伴生与坐标同步组件 (scripts/components/network_beacon.lua)
-- ==============================================================================

local NetworkBeacon = Class(function(self, inst)
    self.inst = inst
    self.classified = nil

    if TheWorld.ismastersim then
        self.inst:DoTaskInTime(0, function() self:SpawnClassified() end)
    end
end)

function NetworkBeacon:SpawnClassified()
    if self.classified ~= nil then return end

    local c = SpawnPrefab("my_beacon_classified")
    c.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    c.host_guid:set(self.inst)
    c.beacon_type:set(self.inst.prefab)
    c.is_active:set(true)

    -- 坐标跟随绑定
    self.inst:DoPeriodicTask(0.1, function()
        if self.inst:IsValid() and c:IsValid() then
            c.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        end
    end)

    self.classified = c
end

function NetworkBeacon:OnRemoveFromEntity()
    if self.classified and self.classified:IsValid() then
        self.classified.is_active:set(false)
        self.classified:Remove()
        self.classified = nil
    end
end

return NetworkBeacon
```

---

## 三、避坑与生产安全准则

1. **`persists = false` 是信标必须铁律**：
   - 伴生微型信标一旦漏写 `persists = false`，服务器保存世界时会把成百上千个脱离宿主的僵尸信标写入世界文件，导致读档后坐标错乱甚至坏档！
2. **伴随跟随频度（Throttle）**：
   - 不必在 `OnUpdate` 每帧（1/60s）同步一次信标坐标，使用 `DoPeriodicTask(0.1)`（每秒 10 次）甚至 `0.2` 秒同步一次坐标，客户端自身的插值系统（Transform Smoothing）即可呈现极其丝滑的平移轨迹，带宽节省 85% 以上。


## 五、进阶拓扑演进与变体分支

### 变体演进：Mod 2281925291 (Mod 2281925291)
- **变体场景与切面**：收录来自工坊 Mod 2281925291 (Mod 2281925291) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2281925291)
-- ============================================================================
local GLOBAL = GLOBAL

-- (the item in cursor)
env.AddComponentPostInit("inventory", function(self)
	if not self.inst:HasTag("player") then
		return
	end
	
	local _SetActiveItem = self.SetActiveItem
	function self:SetActiveItem(item, ...)
		if item then
			FindItem(self.inst, item.prefab or nil, true)
		else
			SendModRPCToClient(GetClientModRPC("FINDER_REDUX", "HIGHLIGHT_ACTIVEITEM"), self.inst, nil)
		end
		return _SetActiveItem(self, item, ...)
	end
end)
`


### 变体演进：[PTP]Shop OnLine (Mod 2958856329)
- **变体场景与切面**：收录来自工坊 Mod 2958856329 ([PTP]Shop OnLine) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2958856329)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
`


### 变体演进：Phonograph Tweaked (Mod 2988233681)
- **变体场景与切面**：收录来自工坊 Mod 2988233681 (Phonograph Tweaked) 的生产级切面。
- **核心切面代码**：
`lua
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
`


### 变体演进：小合集SS (Mod 3120638435)
- **变体场景与切面**：收录来自工坊 Mod 3120638435 (小合集SS) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3120638435)
-- ============================================================================
local GLOBAL = GLOBAL


AddPrefabPostInit("forest_network", function(inst) inst:AddComponent("globalpositions") end)
`


### 变体演进：全球定位RR (Mod 3163922068)
- **变体场景与切面**：收录来自工坊 Mod 3163922068 (全球定位RR) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3163922068)
-- ============================================================================
local GLOBAL = GLOBAL

    --Do this in a world postinit to make sure it runs after Global Positions loads
    AddPrefabPostInit("world", function(inst)
        --Add data for the target indicator's icon:
        -- (if you don't add this, it won't make indicators)
        -- You will have to make this image if it doesn't exist (standard procedure for images)
        GLOBAL._GLOBALPOSITIONS_TARGET_INDICATOR_ICONS.some_mod_prefab = {
                -- atlas is left nil if the image is in inventoryimages
                -- image is left nil if the image is just the key.tex (in this case, some_mod_prefab.tex)
                atlas = "images/some_mod_prefab.xml",
                image = nil,
            }
        --Tell GlobalPositions what minimap icon to use:
        -- (if you don't add this, it won't have a minimap icon, unless it already has one)
        -- You will have to make this icon if it doesn't exist (see other minimap icon mods)
        GLOBAL._GLOBALPOSITIONS_MAP_ICONS.some_mod_prefab = "some_mod_prefab.tex"
    end)
`


### 变体演进：Mod 3689239824 (Mod 3689239824)
- **变体场景与切面**：收录来自工坊 Mod 3689239824 (Mod 3689239824) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3689239824)
-- ============================================================================
local GLOBAL = GLOBAL

end
AddPrefabPostInit("world", function(inst)
	inst:DoTaskInTime(5, function(world)
		world:ListenForEvent("cycleschanged", function()
			local cycle_ratio = _G["TheWorld"]["state"]["cycles"] / clean_day_interval
			if math["floor"](cycle_ratio) == cycle_ratio then
				cleanup_ground_items()
			end
		end)
	end)
end)
`


### 变体演进：快捷物品栏 Quick Bar (Mod 3787501714)
- **变体场景与切面**：收录来自工坊 Mod 3787501714 (快捷物品栏 Quick Bar) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3787501714)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
`


### 变体演进：Fan Skins Collection (Mod 3827608591)
- **变体场景与切面**：收录来自工坊 Mod 3827608591 (Fan Skins Collection) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3827608591，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

for character, _ in pairs(TUNING.FSC_GHOST_BACK_LAYERED_PIGTAIL_CHARACTERS) do
    AddPrefabPostInit(character, PlayerGhostPigtailsPostInit)
end

------------ Mime skins. ------------
-------------------------------------

local function ToggleMimeBehaviour(inst)
`


### 变体演进：No More Cave Bug (Mod 3828908041)
- **变体场景与切面**：收录来自工坊 Mod 3828908041 (No More Cave Bug) 的生产级切面。
- **核心切面代码**：
`lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3828908041，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

AddComponentPostInit("playerspawner", function(self, inst)
    local Shard = _G.getmetatable(_G.TheShard).__index
    StartMigration = Shard.StartMigration
    Shard.StartMigration = QueueMigration

    inst:ListenForEvent("ms_clientauthenticationcomplete", function(world, data)
        authed[data.userid] = true
        NotifyArrived(data.userid)
    end)

    inst:ListenForEvent("ms_clientdisconnected", function(world, data)
        authed[data.userid] = nil
        gated[data.userid] = nil
    end)

    if _G.Shard_IsMaster() then
        inst:ListenForEvent("ms_playerjoined", function(world, player)
            Arrived(player.userid, MASTER, true)
        end)
    end
end)
`



### 变体演进：Nice Utils (Mod 3753657277)
- **变体场景与切面**：收录来自工坊 Mod 3753657277 (`Nice Utils`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3753657277)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:winona_battery_low_item_placer
end
AddPrefabPostInit("winona_battery_low_item_placer", ScaleBatteryPlacer)
AddPrefabPostInit("winona_battery_high_item_placer", ScaleBatteryPlacer)

-- 6. HOOK PLACED BATTERIES & GADGETS TO SCALE THEIR DEPLOY HELPERS DYNAMICALLY
local function HookBatteryHelper(inst)
    if inst.components.deployhelper ~= nil and inst.components.deployhelper.onenablehelper ~= nil then
        local old_onenablehelper = inst.components.deployhelper.onenablehelper
        inst.components.deployhelper.onenablehelper = function(inst, enabled, recipename, placerinst)
            old_onenablehelper(inst, enabled, recipename, placerinst)
            if enabled and inst.helper ~= nil then
                local gen_mult = _G.TUNING.WINONA_GENERATOR_RANGE_MULT or 1.0
                if inst.helper.AnimState ~= nil then
                    inst.helper.AnimState:SetScale(1.5 * gen_mult, 1.5 * gen_mult)
                end
            end
        end
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:winona_battery_high_item_placer
AddPrefabPostInit("winona_battery_low_item_placer", ScaleBatteryPlacer)
AddPrefabPostInit("winona_battery_high_item_placer", ScaleBatteryPlacer)

-- 6. HOOK PLACED BATTERIES & GADGETS TO SCALE THEIR DEPLOY HELPERS DYNAMICALLY
local function HookBatteryHelper(inst)
    if inst.components.deployhelper ~= nil and inst.components.deployhelper.onenablehelper ~= nil then
        local old_onenablehelper = inst.components.deployhelper.onenablehelper
        inst.components.deployhelper.onenablehelper = function(inst, enabled, recipename, placerinst)
            old_onenablehelper(inst, enabled, recipename, placerinst)
            if enabled and inst.helper ~= nil then
                local gen_mult = _G.TUNING.WINONA_GENERATOR_RANGE_MULT or 1.0
                if inst.helper.AnimState ~= nil then
                    inst.helper.AnimState:SetScale(1.5 * gen_mult, 1.5 * gen_mult)
                end
            end
        end
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:winona_battery_low
end
AddPrefabPostInit("winona_battery_low", HookBatteryHelper)
AddPrefabPostInit("winona_battery_high", HookBatteryHelper)
AddPrefabPostInit("winona_teleport_pad", HookBatteryHelper)

-- 7. APPLY DURABILITY & USES CONFIGURATIONS
if heatrock_durability_mult == "infinite" then
    AddPrefabPostInit("heatrock", function(inst)
        if _G.TheWorld.ismastersim then
            if inst.components.fueled then
                inst.components.fueled.SetPercent = function() end
            end
        end
    end)
else
    _G.TUNING.HEATROCK_NUMUSES = (_G.TUNING.HEATROCK_NUMUSES or 8) * heatrock_durability_mult
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:winona_battery_high
AddPrefabPostInit("winona_battery_low", HookBatteryHelper)
AddPrefabPostInit("winona_battery_high", HookBatteryHelper)
AddPrefabPostInit("winona_teleport_pad", HookBatteryHelper)

-- 7. APPLY DURABILITY & USES CONFIGURATIONS
if heatrock_durability_mult == "infinite" then
    AddPrefabPostInit("heatrock", function(inst)
        if _G.TheWorld.ismastersim then
            if inst.components.fueled then
                inst.components.fueled.SetPercent = function() end
            end
        end
    end)
else
    _G.TUNING.HEATROCK_NUMUSES = (_G.TUNING.HEATROCK_NUMUSES or 8) * heatrock_durability_mult
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:winona_teleport_pad
AddPrefabPostInit("winona_battery_high", HookBatteryHelper)
AddPrefabPostInit("winona_teleport_pad", HookBatteryHelper)

-- 7. APPLY DURABILITY & USES CONFIGURATIONS
if heatrock_durability_mult == "infinite" then
    AddPrefabPostInit("heatrock", function(inst)
        if _G.TheWorld.ismastersim then
            if inst.components.fueled then
                inst.components.fueled.SetPercent = function() end
            end
        end
    end)
else
    _G.TUNING.HEATROCK_NUMUSES = (_G.TUNING.HEATROCK_NUMUSES or 8) * heatrock_durability_mult
end

```



### 变体演进：RoseN Attack Warnings (Mod 3824108366)
- **变体场景与切面**：收录来自工坊 Mod 3824108366 (`RoseN Attack Warnings`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3824108366)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:fossilspike
-- Fuelweaver kafes dikeni: RestartSpike(gecikme) ile kalkar ve aninda vurur
AddPrefabPostInit("fossilspike", function(inst)
    local restart = inst.RestartSpike
    if restart == nil then return end
    inst.RestartSpike = function(inst, delay, ...)
        G.pcall(function()
            local x, y, z = inst.Transform:GetWorldPosition()
            Make(nil, { kind = "circle", r = 0.2 + BODY, delay = math.max(0.05, delay or 0), x = x, z = z })
        end)
        return restart(inst, delay, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:alterguardian_phase3
local METEOR_R = 2.25 + BODY
AddPrefabPostInit("alterguardian_phase3", function(inst)
    if not G.TheWorld.ismastersim then return end
    local dotraps = inst.DoTraps
    if dotraps == nil then return end
    inst.DoTraps = function(inst, ...)
        -- oyun konumlari secer ve ilk meteoru 0.5 sn sonraya kurar: o listeyi yakala
        local orig = inst.DoTaskInTime
        local captured
        inst.DoTaskInTime = function(self, t, fn, list, ...)
            if captured == nil and type(list) == "table" and list[1] ~= nil and type(list[1]) == "table"
                and list[1].x ~= nil then
                captured = { t = t, list = {} }
                for i, p in ipairs(list) do captured.list[i] = { p.x, p.z } end
            end
            return orig(self, t, fn, list, ...)
        end
        local ok, a, b, c = G.pcall(dotraps, inst, ...)
        inst.DoTaskInTime = orig
        G.pcall(function()
            if captured == nil then return end
            local n = #captured.list
            for j = 1, n do
                -- oyun listenin sonundan baslar: j. meteor 0.5*j sn sonra duser, 31 kare sonra vurur
                local p = captured.list[n - j + 1]
                Make(nil, { kind = "circle", r = METEOR_R, x = p[1], z = p[2],
                    delay = captured.t + 0.5 * (j - 1) + 31 * FRAMES })
            end
        end)
        if not ok then G.error(a, 0) end
        return a, b, c
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:alterguardian_phase3trap
-- yerdeki tuzak: uyutan dalgalar basladiginda dalga suresince halka
AddPrefabPostInit("alterguardian_phase3trap", function(inst)
    if not G.TheWorld.ismastersim then return end
    inst:ListenForEvent("timerdone", function(inst, data)
        G.pcall(function()
            if data == nil or data.name ~= "start_pulse" then return end
            local timer = inst.components.timer
            if timer == nil then return end
            local first = timer:GetTimeLeft("pulse")
            local finish = timer:GetTimeLeft("finish_pulse")
            if first == nil or finish == nil then return end
            local x, y, z = inst.Transform:GetWorldPosition()
            Make(inst, { kind = "circle", r = (G.TUNING.ALTERGUARDIAN_PHASE3_TRAP_AOERANGE or 3) + BODY,
                x = x, z = z, delay = first, period = 24 * FRAMES, continuous = true,
                life = math.max(0, finish - first), keep = true })
        end)
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:junkball_fx
}
AddPrefabPostInit("junkball_fx", function(inst)
    if not G.TheWorld.ismastersim then return end
    local setup = inst.SetupJunkTossAttack
    if setup == nil then return end
    inst.SetupJunkTossAttack = function(inst, ...)
        local r1, r2 = setup(inst, ...)
        G.pcall(function()
            if inst.x == nil or inst.dir == nil or inst.dist == nil then return end
            local c, sn = math.cos(inst.dir), -math.sin(inst.dir)
            Make(inst, { kind = "path", r = 1.5 + BODY, x = inst.x, z = inst.z,
                pts = { { inst.x, inst.z }, { inst.x + c * inst.dist, inst.z + sn * inst.dist } },
                delay = AnimLen(inst), hold = 0.5, keep = true })
        end)
        return r1, r2
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:alterguardian_phase2spiketrail
local SPIKE_R = 1.1 + 0.25 + BODY
AddPrefabPostInit("alterguardian_phase2spiketrail", function(inst)
    if not G.TheWorld.ismastersim then return end
    local setowner = inst.SetOwner
    if setowner == nil then return end
    inst.SetOwner = function(inst, ...)
        setowner(inst, ...)
        G.pcall(function()
            local T = 0.75
            local task = inst._emerge_task
            if task ~= nil and task.NextTime ~= nil then
                T = math.max(0.05, task:NextTime() - G.GetTime())
            end
            local x, y, z = inst.Transform:GetWorldPosition()
            local a = inst.Transform:GetRotation() * DEGREES
            local fx, fz = math.cos(a), -math.sin(a)
            local px, pz = fz, -fx
            local ex, ez = x + fx * 20 * T, z + fz * 20 * T
            local W, B = 6 * 1.35, 6 * 0.4
            Make(inst, { kind = "path", r = SPIKE_R, x = ex, z = ez,
                pts = { { ex + px * W - fx * B, ez + pz * W - fz * B }, { ex, ez },
                    { ex - px * W - fx * B, ez - pz * W - fz * B } },
                delay = T, hold = 6 * 5 * FRAMES, keep = true })
        end)
    end
end)

```



### 变体演进：沃利技能树 WarlySkillTree (Mod 3821278255)
- **变体场景与切面**：收录来自工坊 Mod 3821278255 (`沃利技能树 WarlySkillTree`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3821278255)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:builder

AddComponentPostInit("builder", function(self)
    local old_build = self.DoBuild
    self.DoBuild = function(self2, recname, pt, rot, skin)
        local previous = pending_craft_spice
        if IsWarly(self2.inst) and GLOBAL.table.contains(SPICE_PREFABS, recname) then
            pending_craft_spice = {
                s2 = HasSkill(self2.inst, "warly_cooking_spice_2"),
                s3 = HasSkill(self2.inst, "warly_cooking_spice_3"),
            }
        end
        local ok, result, reason = GLOBAL.pcall(old_build, self2, recname, pt, rot, skin)
        pending_craft_spice = previous
        if not ok then GLOBAL.error(result, 0) end
        return result, reason
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:monstermeat
end
AddPrefabPostInit("monstermeat", MakeMonsterMeatFuel)












do
    local old_addfuel = GLOBAL.ACTIONS.ADDFUEL.fn
    GLOBAL.ACTIONS.ADDFUEL.fn = function(act)
        local target    = act ~= nil and act.target or nil
        local invobject = act ~= nil and act.invobject or nil
        local doer      = act ~= nil and act.doer or nil





        if target ~= nil and target.Warly_RepairWeapon ~= nil
            and invobject ~= nil and invobject:HasTag("MAGIC_fuel")
            and doer ~= nil and doer.components.inventory ~= nil
            and IsWarly(doer)
        then
            local fuel = doer.components.inventory:RemoveItem(invobject)
            if fuel ~= nil then
                fuel:Remove()
                target:Warly_RepairWeapon(1)
                if target.SoundEmitter ~= nil then
                    target.SoundEmitter:PlaySound("dontstarve/wilson/hambat_hit")
                end
                return true
            end
            return false
        end
        return old_addfuel(act)
    end
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:edible

AddComponentPostInit("edible", function(self)






    if pending_food_mark ~= nil then
        self.warly_made          = true
        self.warly_halved        = pending_food_mark.magic2 or pending_food_mark.halved or nil
        self.warly_resolve_boost = pending_food_mark.resolve or nil
        self.warly_magic1        = pending_food_mark.magic1  or nil
        self.warly_self3         = pending_food_mark.self3   or nil
        self.warly_spice2        = pending_food_mark.spice2  or nil
        self.warly_spice3        = pending_food_mark.spice3  or nil
    end






    local old_save = self.OnSave
    self.OnSave = function(self2)
        local data = old_save ~= nil and old_save(self2) or nil
        if self2.warly_made or self2.spice ~= nil or self2.warly_halved
            or self2.warly_resolve_boost or self2.warly_magic1 or self2.warly_self3
            or self2.warly_spice2 or self2.warly_spice3 then
            data = data or {}
            data.warly_made = self2.warly_made or nil
            data.warly_spice = self2.spice
            data.warly_halved = self2.warly_halved or nil
            data.warly_resolve_boost = self2.warly_resolve_boost or nil
            data.warly_magic1 = self2.warly_magic1 or nil
            data.warly_self3 = self2.warly_self3 or nil
            data.warly_spice2 = self2.warly_spice2 or nil
            data.warly_spice3 = self2.warly_spice3 or nil
        end
        return data
    end
    local old_load = self.OnLoad
    self.OnLoad = function(self2, data)
        if old_load ~= nil then
            old_load(self2, data)
        end
        if type(data) == "table" then
            self2.warly_made = data.warly_made
            self2.warly_halved = data.warly_halved
            self2.warly_resolve_boost = data.warly_resolve_boost
            self2.warly_magic1 = data.warly_magic1
            self2.warly_self3 = data.warly_self3
            self2.warly_spice2 = data.warly_spice2
            self2.warly_spice3 = data.warly_spice3
            if data.warly_spice ~= nil then
                self2.spice = data.warly_spice
            end
        end
    end


    local old_oneaten = self.OnEaten
    self.OnEaten = function(self2, eater)
        local prior_mult = eater ~= nil and eater.warly_pending_buff_mult or nil
        local prior_time = eater ~= nil and eater.warly_pending_buff_mult_time or nil
        if eater ~= nil then
            local spice = self2.spice
            local mult = 1




            if self2.warly_spice2 then
                mult = mult * 1.5
            end




            if self2.warly_self3 and (spice ~= nil or self2.oneaten ~= nil) then
                mult = mult * 2
            end
            eater.warly_pending_buff_mult = mult
            eater.warly_pending_buff_mult_time = GetTime()


            if spice ~= nil and self2.warly_spice3 then
                ApplySpiceMastery(eater, spice, mult)
            end
        end
        local temperature_duration = self2.temperatureduration
        if self2.warly_self3 and type(temperature_duration) == "number" then
            self2.temperatureduration = temperature_duration * 2
        end
        old_oneaten(self2, eater)
        self2.temperatureduration = temperature_duration
        if eater ~= nil then
            eater.warly_pending_buff_mult = prior_mult
            eater.warly_pending_buff_mult_time = prior_time
        end
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:stackable

AddComponentPostInit("stackable", function(self)
    local inst = self.inst


    local old_get = self.Get
    self.Get = function(self2, ...)
        local split = old_get(self2, ...)
        if split ~= nil and split ~= self2.inst and split:IsValid() then
            local source = self2.inst
            local a = source.components.edible
            local b = split.components.edible
            if a ~= nil and b ~= nil then
                for _, key in ipairs({ "warly_made", "warly_halved", "warly_resolve_boost",
                    "warly_magic1", "warly_self3", "warly_spice2", "warly_spice3" }) do
                    b[key] = a[key]
                end
            end
            split.warly_spice2 = source.warly_spice2
            split.warly_spice3 = source.warly_spice3
            local pa, pb = source.components.perishable, split.components.perishable
            if pa ~= nil and pb ~= nil and pa.warly_perish_bonus then

                local remaining = pb.perishremainingtime
                pb:SetPerishTime(pa.perishtime)
                pb.perishremainingtime = remaining
                pb.warly_perish_bonus = true
            end
        end
        return split
    end
    local old_canstack = inst.stackable_CanStackWithFn
    inst.stackable_CanStackWithFn = function(item, other)
        if old_canstack ~= nil and not old_canstack(item, other) then return false end
        local a = item.components.edible
        local b = other.components.edible
        if a ~= nil and b ~= nil then
            for _, key in ipairs({ "warly_halved", "warly_resolve_boost", "warly_magic1",
                "warly_self3", "warly_spice2", "warly_spice3" }) do
                if (a[key] == true) ~= (b[key] == true) then return false end
            end
        end
        if (item.warly_spice2 == true) ~= (other.warly_spice2 == true)
            or (item.warly_spice3 == true) ~= (other.warly_spice3 == true) then return false end
        local pa, pb = item.components.perishable, other.components.perishable
        if pa ~= nil and pb ~= nil and (pa.warly_perish_bonus or pb.warly_perish_bonus)
            and pa.perishtime ~= pb.perishtime then return false end
        return true
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:stewer

AddComponentPostInit("stewer", function(self)
    local old_save = self.OnSave
    self.OnSave = function(self2, ...)
        local data = old_save ~= nil and old_save(self2, ...) or nil
        if self2.warly_mark ~= nil and self2.product ~= nil then
            data = data or {}
            data.warly_mark = shallowcopy(self2.warly_mark)
        end
        return data
    end
    local old_load = self.OnLoad
    self.OnLoad = function(self2, data, ...)
        if old_load ~= nil then old_load(self2, data, ...) end
        self2.warly_mark = data ~= nil and type(data.warly_mark) == "table"
            and shallowcopy(data.warly_mark) or nil
    end
    local old_startcooking = self.StartCooking

    self.StartCooking = function(self2, doer)


        local old_mult = self2.cooktimemult
        if doer ~= nil
            and self2.inst.prefab == "portablecookpot"
            and HasSkill(doer, "warly_cooking_self_1") then
            self2.cooktimemult = self2.cooktimemult * 0.7
        end






        if self2.targettime == nil and self2.inst.components.container ~= nil then
            local ing = {}
            for _, v in pairs(self2.inst.components.container.slots) do
                table.insert(ing, v.prefab)
            end
            do
                local wouldbe = cooking.CalculateRecipe(self2.inst.prefab, ing)


                if wouldbe == nil or cooking.GetRecipe(self2.inst.prefab, wouldbe) == nil then
                    self2.cooktimemult = old_mult
                    print(string.format("[WarlySkillTree] 取消无配方制作：%s [%s]",
                        self2.inst.prefab, table.concat(ing, ",")))
                    if doer ~= nil and doer.components ~= nil and doer.components.talker ~= nil then
                        doer.components.talker:Say("这组食材或调料还不能搭配。")
                    end
                    return
                end
                if doer ~= nil and SIGNATURE_DISHES[wouldbe]
                    and not HasSkill(doer, "warly_cooking_signature") then

                    self2.cooktimemult = old_mult
                    return
                end
            end
        end




        local inherit2, inherit3 = false, false
        local seasoning = self2.inst.prefab == "portablespicer"
        local inherited_food = {}
        if seasoning
            and self2.inst.components.container ~= nil then
            for _, v in pairs(self2.inst.components.container.slots) do
                if v.warly_spice2 then inherit2 = true end
                if v.warly_spice3 then inherit3 = true end
                local edible = v.components ~= nil and v.components.edible or nil
                if edible ~= nil and v:HasTag("preparedfood") then
                    inherited_food.resolve = edible.warly_resolve_boost
                    inherited_food.magic1 = edible.warly_magic1
                    inherited_food.halved = edible.warly_halved
                    inherited_food.self3 = edible.warly_self3
                end
            end
        end

        old_startcooking(self2, doer)
        self2.cooktimemult = old_mult

        if self2.targettime == nil or doer == nil then
            return
        end


        if self2.product_spoilage ~= nil and HasSkill(doer, "warly_cooking_self_2") then
            self2.product_spoilage = 1
        end

        local product = self2.product
        if product == nil then
            return
        end




        if HasSkill(doer, "warly_life_seasoning") and product ~= "warly_grandfeast" then
            if not DishHasSpecialEffect(self2.inst.prefab, product)
                and GetIngredientMeat(self2.ingredient_prefabs) >= 1
                and math.random() < SEASONING_CHANCE then
                EnsureGrandfeastRecipe(self2.inst.prefab)
                self2.product = "warly_grandfeast"
            end
        end


        if HasSkill(doer, "warly_life_love_2") then
            doer:Warly_AddLoveSanityStack()
        end



















        do
            local final = self2.product
            if final == nil or type(final) ~= "string" then
                self2.warly_mark = nil
                return
            end


            local resolved = inherited_food.resolve or false
            if not seasoning and HasSkill(doer, "warly_life_resolve") then
                if final == "wetgoop" then
                    doer.warly_resolve_pending = true
                elseif doer.warly_resolve_pending then
                    doer.warly_resolve_pending = nil
                    resolved = true
                end
            end










            local spiced = final:find("_spice_") ~= nil

            local sfx = "_spice_stonefruit"
            self2.warly_mark = {
                resolve = resolved,
                magic1  = inherited_food.magic1 or HasSkill(doer, "warly_life_magic_1"),

                halved  = inherited_food.halved or nil,
                magic2  = not seasoning and final ~= "wetgoop" and HasSkill(doer, "warly_life_magic_2")
                          and MagicWheel.IsEnabled(doer),
                self3   = inherited_food.self3 or (HasSkill(doer, "warly_cooking_self_3")
                          and DishHasSpecialEffect(self2.inst.prefab, final)),
                spice2  = spiced and (HasSkill(doer, "warly_cooking_spice_2") or inherit2) or nil,
                spice3  = spiced and (HasSkill(doer, "warly_cooking_spice_3") or inherit3) or nil,
                perishmult = (final:sub(-#sfx) == sfx
                              and (HasSkill(doer, "warly_cooking_spice_3") or inherit3))
                             and (CUSTOM_SPICE_PERISH_MULT_MAX / CUSTOM_SPICE_PERISH_MULT)
                             or nil,
            }
        end
    end









    local old_harvest = self.Harvest
    self.Harvest = function(self2, harvester)
        local previous_food_mark = pending_food_mark
        local product = self2.product
        local mark = self2.warly_mark



        if mark ~= nil and product ~= nil and type(product) == "string" then
            pending_food_mark = mark
        end























        local mastersim = GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim
        local inv = (harvester ~= nil and harvester.components ~= nil)
            and harvester.components.inventory or nil

        local loot, loot_pos = nil, nil
        local ok
        local function RunHarvest(restore)
            local success, result = GLOBAL.pcall(old_harvest, self2, harvester)
            if restore ~= nil then restore() end
            if not success then
                pending_food_mark = previous_food_mark
                GLOBAL.error(result, 0)
            end
            return result
        end
        local split_food = mark ~= nil and mark.magic2 and mastersim and product ~= "wetgoop"
        if not split_food then
            ok = RunHarvest()
        elseif inv ~= nil then
            local old_give = inv.GiveItem
            inv.GiveItem = function(inv2, item, slot, pos)
                if loot == nil and item ~= nil and item.prefab == product and pending_food_mark == mark then
                    loot = item
                    loot_pos = pos


                    return false
                end
                return old_give(inv2, item, slot, pos)
            end
            ok = RunHarvest(function() inv.GiveItem = old_give end)
        elseif GLOBAL.rawget(GLOBAL, "LaunchAt") ~= nil then


            local old_launch = GLOBAL.LaunchAt
            GLOBAL.LaunchAt = function(item, ...)
                if loot == nil and item ~= nil and item.prefab == product and pending_food_mark == mark then
                    loot = item
                end
                return old_launch(item, ...)
            end
            ok = RunHarvest(function() GLOBAL.LaunchAt = old_launch end)
        else
            ok = RunHarvest()
        end






        if mark ~= nil and mark.magic2 and mastersim and product ~= "wetgoop" then



            if loot == nil or not loot:IsValid() or loot.components == nil
                or loot.components.edible == nil then
                print(string.format(
                    "[WarlySkillTree] 魔术手法贰：没拿到成品实体，本盘不拆分（product=%s）",
                    tostring(product)))
            else



                HalveEdible(loot)

                local extra = SpawnPrefab(loot.prefab, loot.skinname, loot.skin_id, nil)
                if extra ~= nil then
                    local srcstack = loot.components.stackable
                    if srcstack ~= nil and extra.components.stackable ~= nil then
                        extra.components.stackable:SetStackSize(srcstack:StackSize())
                    end
                    local srcperish = loot.components.perishable
                    if srcperish ~= nil and extra.components.perishable ~= nil then
                        extra.components.perishable:SetPercent(srcperish:GetPercent())
                    end
                    HalveEdible(extra)




                    if inv ~= nil then
                        if not inv:GiveItem(extra) and extra:IsValid() then

                            extra.Transform:SetPosition(harvester:GetPosition():Get())
                        end
                    else

                        extra.Transform:SetPosition(self2.inst:GetPosition():Get())
                    end
                end



                if inv ~= nil and loot:IsValid() then
                    if not inv:GiveItem(loot, nil, loot_pos or harvester:GetPosition()) and loot:IsValid() then
                        loot.Transform:SetPosition(harvester:GetPosition():Get())
                    end
                end
            end
        end

        pending_food_mark = previous_food_mark
        self2.warly_mark  = nil
        return ok
    end
end)


AddComponentPostInit("perishable", function(self)
    local old_save = self.OnSave
    self.OnSave = function(self2, ...)
        local data = old_save ~= nil and old_save(self2, ...) or nil
        if self2.warly_perish_bonus then
            data = data or {}
            data.warly_perishtime = self2.perishtime
        end
        return data
    end
    local old_load = self.OnLoad
    self.OnLoad = function(self2, data, ...)
        if data ~= nil and type(data.warly_perishtime) == "number"
            and data.warly_perishtime > 0 then
            self2.warly_perish_bonus = true
            self2:SetPerishTime(data.warly_perishtime)
        end
        if old_load ~= nil then return old_load(self2, data, ...) end
    end
    if pending_food_mark == nil or pending_food_mark.perishmult == nil then
        return
    end
    local mult = pending_food_mark.perishmult
    local old_set = self.SetPerishTime
    self.SetPerishTime = function(self2, time, ...)
        self2.SetPerishTime = old_set
        self2.warly_perish_bonus = true
        return old_set(self2, time * mult, ...)
    end
end)


AddComponentPostInit("lootdropper", function(self)
    local old_generate = self.GenerateLoot
    self.GenerateLoot = function(self2)
        local loots = old_generate(self2)
        local inst = self2.inst


        if inst.warly_murder_double then
            inst.warly_murder_double = nil
            local doubled = {}
            for _, v in ipairs(loots) do
                table.insert(doubled, v)
                table.insert(doubled, v)
            end
            loots = doubled
        end









        local lucky = inst.warly_butcher_lucky
        inst.warly_butcher_lucky = nil
        if not lucky then
            local killer = inst.components.health ~= nil and inst.components.health.causeofdeath or nil
            lucky = killer ~= nil and HasSkill(killer, "warly_butcher_2")
        end
        if lucky then

            if inst:HasTag("pig") then
                table.insert(loots, "pigskin")
            end


            local rare = inst:HasTag("beefalo") and "horn"
                or (inst:HasTag("lightninggoat") and "lightninggoathorn")
                or nil
            if rare ~= nil and not table.contains(loots, rare) then
                table.insert(loots, rare)
            end
        end






        return loots
    end
end)










AddComponentPostInit("combat", function(self)
    local old_getattacked = self.GetAttacked
    self.GetAttacked = function(self2, attacker, damage, weapon, stimuli, spdamage)
        local inst = self2.inst
        local untiltime = inst.warly_garlic_block_time
        if untiltime ~= nil then
            if GetTime() < untiltime then
                if GetTime() >= (inst.warly_garlic_block_cd or 0)
                    and math.random() < GARLIC_BLOCK_CHANCE then
                    inst.warly_garlic_block_cd = GetTime() + 0.5
                    DoBoneShieldFX(inst)
                    inst:PushEvent("blocked", {
                        attacker = attacker,
                        damage = damage,
                        spdamage = spdamage,
                    })
                    return true
                end
            else
                inst.warly_garlic_block_time = nil
            end
        end
        return old_getattacked(self2, attacker, damage, weapon, stimuli, spdamage)
    end
end)


AddPlayerPostInit(function(inst)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then return end





    if inst.components.workmultiplier == nil then
        inst:AddComponent("workmultiplier")
    end
    local previous_special = inst.components.workmultiplier.specialfn
    inst.components.workmultiplier:SetSpecialMultiplierFn(
        function(inst2, action, target, tool, numworks, recoil)
            if previous_special ~= nil then
                numworks = previous_special(inst2, action, target, tool, numworks, recoil)
            end
            if recoil or numworks == nil or numworks == 0 then
                return numworks
            end
            local t = inst2.warly_sugar_crit_time
            if t ~= nil and GetTime() < t and math.random() < SUGAR_CRIT_CHANCE then
                if inst2.player_classified ~= nil then
                    inst2.player_classified.playworkcritsound:push()
                end
                return 99999
            end
            return numworks
        end)
















    function inst:Warly_ApplyNightmareGift(food)
        if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
            return
        end
        self.warly_nightmaregift_until =
            GetTime() + NIGHTMAREGIFT_TIME * GLOBAL.WARLY_SPECIAL_DURATION_MULT(food)
    end

    inst:ListenForEvent("attacked", function(inst2)
        local untiltime = inst2.warly_nightmaregift_until
        if untiltime == nil then
            return
        end
        if GetTime() >= untiltime then
            inst2.warly_nightmaregift_until = nil
            return
        end


        local fx = SpawnPrefab("bramblefx_armor")
        if fx ~= nil then
            if fx.SetFXOwner ~= nil then
                fx:SetFXOwner(inst2)
            else
                fx:Remove()
            end
        end
    end)





    function inst:Warly_ApplyOnionRollSpeed(food)
        if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
            return
        end
        if self.components.locomotor == nil then
            return
        end
        self.components.locomotor:SetExternalSpeedMultiplier(self, "warly_onionroll", 1.25)
        if self.warly_onionroll_task ~= nil then
            self.warly_onionroll_task:Cancel()
        end
        self.warly_onionroll_task = self:DoTaskInTime(
            ONIONROLL_TIME * GLOBAL.WARLY_SPECIAL_DURATION_MULT(food), function(inst2)
            inst2.warly_onionroll_task = nil
            if inst2.components.locomotor ~= nil then
                inst2.components.locomotor:RemoveExternalSpeedMultiplier(
                    inst2, "warly_onionroll")
            end
        end)
    end










    function inst:Warly_OnEatCustomSpiceFood(spice, foodinst)
        if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
            return
        end

        local ed = (foodinst ~= nil and foodinst.components ~= nil)
            and foodinst.components.edible or nil






        local durmult = ((ed ~= nil and ed.warly_spice2) and 1.5 or 1)
            * GLOBAL.WARLY_SPECIAL_DURATION_MULT(foodinst)

        if spice == SPICE_HORROR or spice == SPICE_BRILLIANCE then


            local buff = WARLY_SPICE_BUFF_PREFAB[spice]
            self:AddDebuff(buff, buff, { duration = 240 * durmult })
        elseif spice == SPICE_GLOW then


            if self.wormlight ~= nil then
                if self.wormlight.prefab == "wormlight_light" then
                    local sp2 = self.wormlight.components.spell
                    if sp2.warly_base_duration == nil then
                        sp2.warly_base_duration = sp2.duration
                    end
                    sp2.duration = sp2.warly_base_duration * durmult
                    self.wormlight.components.spell.lifetime = 0
                    self.wormlight.components.spell:ResumeSpell()
                    return
                else
                    self.wormlight.components.spell:OnFinish()
                end

```



### 变体演进：欧皇模拟器 随机海钓 综合补丁 (Mod 3702321518)
- **变体场景与切面**：收录来自工坊 Mod 3702321518 (`欧皇模拟器 随机海钓 综合补丁`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3702321518)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
-- 注入金币爆率倍率逻辑
AddPrefabPostInit("world", function(inst)
    inst:DoTaskInTime(0, function()
        if dh_coins_explosion_rate_mult ~= 1.0 then
            if GLOBAL.TUNING.SLOTMACHINE_MODCONFIGDATA and GLOBAL.TUNING.SLOTMACHINE_MODCONFIGDATA["CoinsExplosionRate"] then
                GLOBAL.TUNING.SLOTMACHINE_MODCONFIGDATA["CoinsExplosionRate"] = GLOBAL.TUNING.SLOTMACHINE_MODCONFIGDATA["CoinsExplosionRate"] * dh_coins_explosion_rate_mult
            end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:lootdropper
if kill_to_deposit_enabled then
    AddComponentPostInit("lootdropper", function(self)
        -- 用于缓存同一帧内拦截到的金币总数
        self._intercepted_count = 0
        self._deposit_batch_task = nil
        
        -- 先定义变量名，确保闭包可以引用到
        local old_FlingItem = nil

        local function queue_intercept(amount)
            self._intercepted_count = self._intercepted_count + amount
            if not self._deposit_batch_task then
                -- 必须在当前帧获取参与者，因为下一帧生物实体可能就被移除了
                local participants = GetCombatParticipants(self.inst)
                local victim_pos = self.inst:GetPosition()

                -- 使用 TheWorld 发起任务，确保即使生物实体消失也能完成结算
                self._deposit_batch_task = GLOBAL.TheWorld:DoTaskInTime(0, function()
                    if self._intercepted_count > 0 then
                        local has_rewarded = false
                        if #participants > 0 then
                            for _, player in ipairs(participants) do
                                if player:IsValid() and player.components.moneymanager then
                                    player.components.moneymanager:AddFunds("击杀掉落", self._intercepted_count)
                                    has_rewarded = true
                                end
                            end
                        end

                        -- 如果没人领（参与者都不在线或无效），则回退到原地掉落实体金币
                        if not has_rewarded then
                            for i = 1, self._intercepted_count do
                                local loot = GLOBAL.SpawnPrefab("dubloon")
                                if loot then
                                    -- 这里引用闭包内的 old_FlingItem
                                    if old_FlingItem then
                                        old_FlingItem(self, loot, victim_pos)
                                    else
                                        self.inst:DoTaskInTime(0, function() loot:Remove() end) -- 彻底兜底
                                    end
                                end
                            end
                        end
                    end
                    self._intercepted_count = 0
                    self._deposit_batch_task = nil
                end)
            end
        end

        -- 拦截 FlingItem (处理某些 BOSS 直接使用 SpawnPrefab + FlingItem 抛出金币的情况)
        old_FlingItem = self.FlingItem
        self.FlingItem = function(self, loot, pt, dropper)
            if loot and loot.prefab == "dubloon" then
                local stacksize = (loot.components.stackable and loot.components.stackable:StackSize()) or 1
                queue_intercept(stacksize)
                loot:Remove() -- 直接移除实体，杜绝渲染和物理计算产生的卡顿
                return
            end
            return old_FlingItem(self, loot, pt, dropper)
        end

        -- 拦截 SpawnLootPrefab (处理大多数基于 LootTable 的常规掉落)
        local old_SpawnLootPrefab = self.SpawnLootPrefab
        self.SpawnLootPrefab = function(self, loot, pt)
            if loot == "dubloon" then
                queue_intercept(1)
                return nil -- 返回 nil 表示不生成 Prefab，从源头上删去产出过程
            end
            return old_SpawnLootPrefab(self, loot, pt)
        end
    end)

```

