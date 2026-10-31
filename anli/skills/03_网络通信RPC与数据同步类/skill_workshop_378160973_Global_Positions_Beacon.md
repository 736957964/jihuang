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

