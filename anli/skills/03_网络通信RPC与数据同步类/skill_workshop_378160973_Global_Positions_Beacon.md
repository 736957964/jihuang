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



### 变体演进：GrimWorld - Colony Simulator [Fork] (Mod 3828850166)
- **变体场景与切面**：收录来自工坊 Mod 3828850166 (`GrimWorld - Colony Simulator [Fork]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3828850166)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:grim_colonist

AddPrefabPostInit("grim_colonist", function(inst)
    table.insert(_G.GrimPawns, inst)
    inst:ListenForEvent("onremove", function()
        for i, v in ipairs(_G.GrimPawns) do
            if v == inst then
                table.remove(_G.GrimPawns, i)
                break
            end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:grim_colonist_ghost

AddPrefabPostInit("grim_colonist_ghost", function(inst)
    table.insert(_G.GrimGhosts, inst)
    inst:ListenForEvent("onremove", function()
        for i, v in ipairs(_G.GrimGhosts) do
            if v == inst then
                table.remove(_G.GrimGhosts, i)
                break
            end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:firesuppressor

AddPrefabPostInit("firesuppressor", function(inst)
    local fd = inst.components ~= nil and inst.components.firedetector or nil
    if fd == nil or fd.onfindfire == nil then
        return
    end
    local oldfind = fd.onfindfire
    fd.onfindfire = function(self, pos, ...)
        if GrimIsCampFire(pos) then
            return -- leave the colony's own fire alone
        end
        return oldfind(self, pos, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:winona_catapult

AddPrefabPostInit("winona_catapult", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end
    inst:DoPeriodicTask(1, function()
        local combat = inst.components.combat
        if combat == nil or combat:HasTarget()
            or (inst.IsActiveMode ~= nil and not inst:IsActiveMode()) then
            return
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        local range = (_G.TUNING.WINONA_CATAPULT_MAX_RANGE or 15) + 3
        for _, c in ipairs(_G.TheSim:FindEntities(x, y, z, range, { "grim_colonist" })) do
            local t = c.components.combat ~= nil and c.components.combat.target or nil
            if t ~= nil and t:IsValid() and combat:CanTarget(t)
                and not (inst.IsTargetTooClose ~= nil and inst:IsTargetTooClose(t)) then
                combat:SuggestTarget(t)
                return
            end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:lucy
-- which no client is -- retarget to nil so everyone hears her quips.
AddPrefabPostInit("lucy", function(inst)
    if not _G.TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("onputininventory", function(inst, owner)
        if owner ~= nil and owner.components.inventoryitem ~= nil
            and owner.components.inventoryitem.owner ~= nil then
            owner = owner.components.inventoryitem.owner -- held inside a container
        end
        if owner ~= nil and owner:HasTag("grim_colonist") and inst.lucy_classified ~= nil then
            inst.lucy_classified:SetTarget(nil)
        end
    end)
end)

```



### 变体演进：【里程碑】 (Mod 3825943267)
- **变体场景与切面**：收录来自工坊 Mod 3825943267 (`【里程碑】`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3825943267)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：登仙灵石兑换丹药 (Mod 3490789139)
- **变体场景与切面**：收录来自工坊 Mod 3490789139 (`登仙灵石兑换丹药`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3490789139)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：掉落物计时删除 (Mod 3779699321)
- **变体场景与切面**：收录来自工坊 Mod 3779699321 (`掉落物计时删除`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3779699321)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:lootdropper
-- 监控掉落 lootdropper
AddComponentPostInit("lootdropper", function(self)
    local oldFlingItem = self.FlingItem -- 这个函数是 SpawnLootPrefab 里完成掉落物品生成之后
    function self:FlingItem(loot, pt)
        if loot ~= nil and loot:IsValid() then
            loot:DoTaskInTime(1, function()
                AdditemRemoveSetTitle(loot, GetModConfigData("zdscwp"), GetModConfigData("zdscwp_xssj"), 60) -- (物品, 倒计时, 倒计时开始显示, 颜色)
            end)
        end
        oldFlingItem(self, loot, pt)
    end
end)

```



### 变体演进：附近储物总览 (Mod 3814556768)
- **变体场景与切面**：收录来自工坊 Mod 3814556768 (`附近储物总览`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814556768)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:container
end
AddComponentPostInit("container",HSO_ORGANIZER.WrapContainer)
AddComponentPostInit("inventoryitem",HSO_ORGANIZER.WrapInventoryItem)
AddComponentPostInit("perishable",HSO_ORGANIZER.WrapPerishable)
AddClassPostConstruct("components/container_replica",function(self)
    local canopen=self.CanBeOpened
    if canopen~=nil then self.CanBeOpened=function(replica,...)
        return not replica.inst:HasTag("hso_sorting") and canopen(replica,...)
    end end
end)
for _,worldprefab in ipairs({"world","forest","cave"}) do
    AddPrefabPostInit(worldprefab,HSO_ORGANIZER.WrapWorld)
end

local MOD_NS = "HomeStorageOverview"

local CFG_RADIUS = GetModConfigData("scan_radius") or 40
local CFG_HOTKEY = GetModConfigData("hotkey") or "B"
local CFG_PERMISSION = GetModConfigData("use_permission") or "all"
local CFG_TAKE_LIMIT = GetModConfigData("take_limit") or 20

-- KU 白名单（逗号分隔）
local PERM_SET = {}
do
    local wl = GetModConfigData("ku_whitelist") or ""
    for id in string.gmatch(wl, "[^%s,]+") do
        PERM_SET[id] = true
    end
end

-- 使用权限判定（作用于拿取/整理；总览查看不受限）
local function HasPermission(player)
    if CFG_PERMISSION == "all" then
        return true
    end
    if player == nil or player.userid == nil then
        return false
    end
    if CFG_PERMISSION == "whitelist" then
        return PERM_SET[player.userid] == true
    elseif CFG_PERMISSION == "admin" then
        local net = player.Network
        return net ~= nil and net.IsServerAdmin ~= nil and net:IsServerAdmin()
    end
    return false
end

local CHUNK = 200       -- 单个 RPC 字符串参数的安全长度
local MAX_CHUNKS = 512  -- Bound large-base snapshots, including instance names/recipes.
local PACKETS_PER_TICK = 24
local SNAPSHOT_TTL = 15 -- Native inventory events invalidate the cache immediately.
local REQUEST_INTERVAL = .25 -- Coalesce repeated opens/refreshes before scanning.

local SCAN_CACHE = {}         -- userid -> { list = 容器列表, t = 时间 }
local SNAPSHOT_STREAMS = {}
local SNAPSHOT_REQUESTS = {}
local inventory_revision = 0
local ORGANIZE_COOLDOWN = {}  -- userid -> 上次整理时间
local OPEN_VIEWERS = {}       -- Only open panels renew their subscription by polling.
local PREVIEWS, FEATURE_REQUESTS = {}, {}
local FEATURE_STREAMS={}
local feature_serial=0
local VIEWER_TIMEOUT = 8      -- Allow two three-second polls plus delivery slack.
local SyncContainerEvents, RefreshViews, SendOrganizeState, SendBusy
local WATCHED_CONTAINERS, DIRTY_CONTAINERS = {}, {}
local EVENT_TASK, LEASE_TASK
HSO_ORGANIZER.OnPendingChanged=function(ent)
    inventory_revision=inventory_revision+1
    if RefreshViews~=nil then RefreshViews(nil,{[ent]=true}) end
end

-- 客户端数据状态（客户端/服务端都会注册，双端各持一份）
local HSO_STATE = { hash = nil, data = nil, pending = nil, busy = false, status = nil, listener = nil, onerror = nil }
local NOTICE_SECONDS=4
local function ClientStatus(busy,status)
    if HSO_STATE.busy==busy and HSO_STATE.status==status then return false end
    HSO_STATE.busy,HSO_STATE.status=busy,status
    HSO_STATE.status_until=not busy and type(status)=="string" and #status>0
        and ((GLOBAL.GetStaticTime or GLOBAL.GetTime)()+NOTICE_SECONDS) or nil
    return true
end

-- 玩家离开时清理其快照与冷却记录
AddPlayerPostInit(function(player)
    player:ListenForEvent("onremove", function()
        local job=HSO_ORGANIZER.active_job
        if job~=nil and job.player==player then HSO_ORGANIZER.Cancel(job,"disconnected") end
        local userid = player.userid
        if userid ~= nil then
            SCAN_CACHE[userid] = nil
            ORGANIZE_COOLDOWN[userid] = nil
            OPEN_VIEWERS[userid] = nil
            PREVIEWS[userid],FEATURE_REQUESTS[userid]=nil,nil
            local feature=FEATURE_STREAMS[userid]
            if feature~=nil and feature.task~=nil then feature.task:Cancel() end
            FEATURE_STREAMS[userid]=nil
            local stream=SNAPSHOT_STREAMS[userid]
            if stream~=nil and stream.task~=nil then stream.task:Cancel() end
            SNAPSHOT_STREAMS[userid]=nil
            local request=SNAPSHOT_REQUESTS[userid]
            if request~=nil and request.task~=nil then request.task:Cancel() end
            SNAPSHOT_REQUESTS[userid]=nil
            if SyncContainerEvents ~= nil then SyncContainerEvents() end
        end
    end)
end)

----------------------------------------------------------------
-- 通用
----------------------------------------------------------------

local function Say(player, msg)
    if player ~= nil and player:IsValid() and player.components ~= nil
        and player.components.talker ~= nil then
        player.components.talker:Say(Features.WrapText("[储物] "..Features.BriefStatus(msg),20),4)
    end
end

local function ItemCount(item)
    if item.components.stackable ~= nil then
        return item.components.stackable:StackSize()
    end
    return 1
end

----------------------------------------------------------------
-- 服务端：扫描容器
----------------------------------------------------------------

local function ScanContainers(player, for_organize)
    local scanned = Policy.Scan(player, CFG_RADIUS)
    if not for_organize then return scanned.containers end
    local out = {}
    for _, ent in ipairs(scanned.containers) do
        if Policy.CanOrganize(ent, player, CFG_RADIUS) then out[#out + 1] = ent end
    end
    return out
end

-- D carries names/recipe identities; c.t and A/I use the same selectable group key.
local function BuildContainerData(player)
    local containers = ScanContainers(player, false)
    local ok,cooking=pcall(require,"cooking")
    local ingredients=ItemRules.BuildIngredientSet(GLOBAL.AllRecipes,ok and cooking or nil)
    local payload = { v = 4, c = {}, D = {}, A = {}, I = {}, P = {}, Q = {}, K = {}, n = #containers, s = 0 }
    if not HasPermission(player) then payload.u=false end
    local groups = {}
    local held_by_source={}
    for item,rec in pairs(HSO_ORGANIZER.pending) do
        if item:IsValid() and item.components.inventoryitem.owner==nil then
            local held=held_by_source[rec.source]
            if held==nil then held={};held_by_source[rec.source]=held end
            held[#held+1]=item
        end
    end
    for idx, ent in ipairs(containers) do
        local cont = ent.components.container
        local t, unavailable, used = {}, {}, 0
        local function AddItem(item, held_remainder)
            if item ~= nil then
                local cnt = ItemCount(item)
                local meta = ItemInfo.Describe(item)
                local key = ItemInfo.GroupKey(meta)
                t[key] = (t[key] or 0) + cnt
                local quality=payload.Q[key] or {}
                Features.AddQuality(quality,item)
                if next(quality)~=nil then payload.Q[key]=quality end
                local inv=item.components.inventoryitem
                if (held_remainder or (inv~=nil and inv.islockedinslot)) and not cont.readonlycontainer then
                    unavailable[key]=(unavailable[key] or 0)+cnt
                end
                used = used + cnt   -- 计件数（与界面 "N 件物品" 对应）
                if groups[key] == nil then
                    groups[key] = meta
                    if ItemInfo.HasDetails(meta) then payload.D[key] = meta end
                    if ItemRules.PriorityRaw(meta,ingredients) then payload.P[key]=true end
                    local category=Features.Category(item,meta,payload.P[key])
                    if category~="other" then payload.K[key]=category end
                    payload.A[key], payload.I[key] = ItemInfo.InventoryImage(item)
                end
            end
        end
        for i=1,cont:GetNumSlots() do AddItem(cont:GetItemInSlot(i),false) end
        for _,item in ipairs(held_by_source[ent] or {}) do
            if item:IsValid() and item.components.inventoryitem.owner==nil then AddItem(item,true) end
        end
        if used > 0 then
            payload.s = payload.s + used
            local meta = ItemInfo.Describe(ent)
            table.insert(payload.c, { i = idx, p = ent.prefab,
                d = ItemInfo.HasDetails(meta) and meta or nil, t = t,
                g=ent.GUID,e=cont._hso_excluded or nil,w=Policy.OrganizeReason(ent,player,CFG_RADIUS),
                r = (cont.readonlycontainer or cont.canbeopened == false) and true or nil,
                a = next(unavailable) ~= nil and unavailable or nil })
        end
    end
    return payload, containers, groups
end

local function HashStr(s)
    local h = 5381
    for i = 1, #s do
        h = (h * 33 + string.byte(s, i)) % 4294967291
    end
    return tostring(h) .. "_" .. tostring(#s)
end

----------------------------------------------------------------
-- 服务端：跨箱整理
----------------------------------------------------------------

local function ReportOrganize(player,result)
    if result.error~=nil then print("[HSO] organize interrupted: "..result.error) end
    if result.incomplete then
        print(string.format("[HSO] organize stopped: reason=%s phase=%s stage=%s elapsed=%.2f containers=%d slots=%d records=%d groups=%d work=%d steps=%d pending=%d",
            tostring(result.reason),tostring(result.phase),tostring(result.stage),tonumber(result.elapsed) or 0,
            tonumber(result.containers) or 0,tonumber(result.slots) or 0,tonumber(result.records) or 0,tonumber(result.groups) or 0,
            tonumber(result.work) or 0,tonumber(result.steps) or 0,tonumber(result.pending) or 0))
    end
    if result.pending>0 then
        return string.format("归并 %d 件，合堆 %d 件；暂缓 %d 件恢复",result.moved,result.merged,result.pending)
    end
    if result.incomplete then
        local why=({paused="游戏暂停",timeout="时间超限",time_limit="时间超限",
            work_limit="工作量超限",scheduler="任务调度中断",
            disconnected="玩家离线",container_changed="容器状态变化",item_changed="物品状态变化"})[result.reason] or "库存或容器状态变化"
        return string.format("整理已停止：%s；归并 %d 件，物品已保留",why,result.moved)
    end
    if next(result.changed) ~= nil or result.left > 0 or result.skipped > 0 then
        local reasons={}
        for _,key in ipairs({"excluded","type","open","locked","readonly","unavailable"}) do
            local n=(result.reasons or {})[key]
            if n~=nil and n>0 then reasons[#reasons+1]=(Policy.REASONS[key] or key)..n.."个" end
        end
        return string.format("整理完成：归并 %d 件，释放 %d 格；跳过 %d 个%s",
            result.moved,result.freed or 0,result.skipped,#reasons>0 and ("（"..table.concat(reasons,"、").."）") or "")
    else
        return "物品已集中，无需移动"
    end
end

----------------------------------------------------------------
-- RPC 注册（客户端/服务端必须按相同顺序注册，保证 id 一致）
----------------------------------------------------------------

-- Requests use the known hash; completed actions push authoritative data directly.
local function SendSnapshot(player, client_hash, watching, force)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
        return
    end
    if player == nil or not player:IsValid() or type(player.userid)~="string" then
        return
    end
    if watching == false then
        OPEN_VIEWERS[player.userid] = nil
        local stream=SNAPSHOT_STREAMS[player.userid]
        if stream~=nil and stream.task~=nil then stream.task:Cancel() end
        SNAPSHOT_STREAMS[player.userid]=nil
        SyncContainerEvents()
        return
    elseif watching == true then
        OPEN_VIEWERS[player.userid] = { player = player, t = GLOBAL.GetStaticTime() }
    end
    local now=GLOBAL.GetStaticTime()
    local x,_,z=player.Transform:GetWorldPosition()
    local scan=SCAN_CACHE[player.userid]
    local busy=HSO_ORGANIZER.IsBusy()
    local reusable=scan~=nil and scan.encoded~=nil and (busy or (not force and watching==true
        and client_hash~=nil and client_hash~="" and scan.revision==inventory_revision
        and now-scan.built<SNAPSHOT_TTL and x==scan.x and z==scan.z))
    if not reusable then
        local payload,containers,groups=BuildContainerData(player)
        local encoded=json.encode(payload)
        scan={list=containers,groups=groups,t=now,built=now,x=x,z=z,revision=inventory_revision,
            encoded=encoded,hash=HashStr(encoded)}
        SCAN_CACHE[player.userid]=scan
        SyncContainerEvents()
    else scan.t=now end
    local s,h=scan.encoded,scan.hash
    local clientrpc = GLOBAL.GetClientModRPC(MOD_NS, "data")
    -- Every poll reconciles authoritative state, including a missed completion.
    SendOrganizeState(player,busy,HSO_ORGANIZER.Status())
    local viewer = OPEN_VIEWERS[player.userid]
    if viewer ~= nil then viewer.hash = h end
    local previous=SNAPSHOT_STREAMS[player.userid]
    if previous~=nil and previous.hash~=h then
        if previous.task~=nil then previous.task:Cancel() end
        SNAPSHOT_STREAMS[player.userid]=nil;previous=nil
    end

    if client_hash ~= nil and client_hash ~= "" and client_hash == h then
        SendModRPCToClient(clientrpc, player.userid, "same", h)
        return
    end

    local total = math.ceil(#s / CHUNK)
    if total > MAX_CHUNKS then
        SendModRPCToClient(clientrpc, player.userid, "err", "toomany")
        return
    end
    if previous~=nil and previous.hash==h and not force and client_hash~="" then return end
    if previous~=nil and previous.task~=nil then previous.task:Cancel() end
    local stream={hash=h,index=1};SNAPSHOT_STREAMS[player.userid]=stream
    SendModRPCToClient(clientrpc, player.userid, "begin", h, tostring(total))
    local function send_batch()
        if SNAPSHOT_STREAMS[player.userid]~=stream or not player:IsValid() then return end
        local last=math.min(total,stream.index+PACKETS_PER_TICK-1)
        for i=stream.index,last do
            SendModRPCToClient(clientrpc,player.userid,"chunk",tostring(i),s:sub((i-1)*CHUNK+1,i*CHUNK),h)
        end
        stream.index=last+1
        if stream.index>total then SNAPSHOT_STREAMS[player.userid]=nil
        elseif GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
            stream.task=GLOBAL.TheWorld:DoStaticTaskInTime(GLOBAL.FRAMES or (1/30),send_batch)
        else
            -- Offline fixtures lack a scheduler; real clients always use batches.
            while stream.index<=total do
                local i=stream.index;stream.index=i+1
                SendModRPCToClient(clientrpc,player.userid,"chunk",tostring(i),s:sub((i-1)*CHUNK+1,i*CHUNK),h)
            end
            SNAPSHOT_STREAMS[player.userid]=nil
        end
    end
    send_batch()
end
local function RequestSnapshot(player,client_hash,watching)
    if GLOBAL.TheWorld==nil or not GLOBAL.TheWorld.ismastersim or player==nil or not player:IsValid()
        or type(player.userid)~="string" or (client_hash~=nil and (type(client_hash)~="string" or #client_hash>64))
        or (watching~=nil and type(watching)~="boolean") then return end
    local userid=player.userid;local previous=SNAPSHOT_REQUESTS[userid]
    if watching==false then
        if previous~=nil and previous.task~=nil then previous.task:Cancel() end
        SNAPSHOT_REQUESTS[userid]=nil;SendSnapshot(player,client_hash,false);return
    end
    local now=GLOBAL.GetStaticTime()
    if previous~=nil and now-previous.t<REQUEST_INTERVAL and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        previous.player,previous.hash,previous.watching=player,client_hash,watching
        if previous.task==nil then
            previous.task=GLOBAL.TheWorld:DoStaticTaskInTime(REQUEST_INTERVAL-(now-previous.t),function()
                previous.task=nil
                if SNAPSHOT_REQUESTS[userid]~=previous or not previous.player:IsValid() then return end
                previous.t=GLOBAL.GetStaticTime()
                SendSnapshot(previous.player,previous.hash,previous.watching)
            end)
        end
        return
    end
    if previous~=nil and previous.task~=nil then previous.task:Cancel() end
    SNAPSHOT_REQUESTS[userid]={t=now}
    -- The force argument belongs to authoritative server updates. RPC callers
    -- request a fresh scan with an empty hash, subject to the coalescing above.
    SendSnapshot(player,client_hash,watching)
end
AddModRPCHandler(MOD_NS, "req", RequestSnapshot)

-- Server RPC handlers run to completion. Notify other active views after the
-- actual removals; their own nearby scan determines their new visible quantities.
RefreshViews = function(player, changed)
    if player~=nil then SendSnapshot(player,nil,nil,true) end
    local now = GLOBAL.GetStaticTime()
    for userid, viewer in pairs(OPEN_VIEWERS) do
        if not viewer.player:IsValid() or now - viewer.t > VIEWER_TIMEOUT then
            OPEN_VIEWERS[userid] = nil
        elseif player==nil or userid ~= player.userid then
            local scan = SCAN_CACHE[userid]
            if scan ~= nil then
                for _, ent in ipairs(scan.list) do
                    if changed[ent] then
                        SendSnapshot(viewer.player,viewer.hash,nil,true)
                        break
                    end
                end
            end
        end
    end
    SyncContainerEvents()
end

local function QueueContainerChange(ent)
    DIRTY_CONTAINERS[ent]=true
    inventory_revision=inventory_revision+1
    if HSO_ORGANIZER.IsBusy() then return end
    if EVENT_TASK~=nil then return end
    if GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        EVENT_TASK=GLOBAL.TheWorld:DoStaticTaskInTime(.1,function()
            EVENT_TASK=nil
            if HSO_ORGANIZER.IsBusy() then return end
            local changed=DIRTY_CONTAINERS;DIRTY_CONTAINERS={}
            RefreshViews(nil,changed)
        end)
    end
end

SyncContainerEvents = function()
    local needed={};local now=GLOBAL.GetStaticTime()
    for userid,viewer in pairs(OPEN_VIEWERS) do
        if not viewer.player:IsValid() or now-viewer.t>VIEWER_TIMEOUT then OPEN_VIEWERS[userid]=nil
        else
            local scan=SCAN_CACHE[userid]
            if scan~=nil then
                for _,ent in ipairs(scan.list) do
                    if Policy.CanView(ent,viewer.player,CFG_RADIUS) and ent.ListenForEvent~=nil then needed[ent]=true end
                end
            end
        end
    end
    for ent,watch in pairs(WATCHED_CONTAINERS) do
        if not needed[ent] then
            for _,event in ipairs({"itemget","itemlose","onremove"}) do
                pcall(ent.RemoveEventCallback,ent,event,watch.callback)
            end
            for item in pairs(watch.items) do pcall(ent.RemoveEventCallback,ent,"stacksizechange",watch.callback,item) end
            WATCHED_CONTAINERS[ent]=nil
        end
    end
    for ent in pairs(needed) do
        local watch=WATCHED_CONTAINERS[ent]
        if watch==nil then
            watch={items={},callback=function() QueueContainerChange(ent) end}
            WATCHED_CONTAINERS[ent]=watch
            for _,event in ipairs({"itemget","itemlose","onremove"}) do ent:ListenForEvent(event,watch.callback) end
        end
        local items={};local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and item.ListenForEvent~=nil then items[item]=true end
        end
        for item in pairs(watch.items) do
            if not items[item] then ent:RemoveEventCallback("stacksizechange",watch.callback,item) end
        end
        for item in pairs(items) do
            if not watch.items[item] then ent:ListenForEvent("stacksizechange",watch.callback,item) end
        end
        watch.items=items
    end
    if next(OPEN_VIEWERS)==nil then
        if EVENT_TASK~=nil then EVENT_TASK:Cancel();EVENT_TASK=nil end
        if LEASE_TASK~=nil then LEASE_TASK:Cancel();LEASE_TASK=nil end
        DIRTY_CONTAINERS={}
    elseif LEASE_TASK==nil and GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        LEASE_TASK=GLOBAL.TheWorld:DoStaticTaskInTime(2,function()
            LEASE_TASK=nil;SyncContainerEvents()
        end)
    end
end

-- Match the selected instance group, so different sketches/cards cannot be mixed up.
AddModRPCHandler(MOD_NS, "take", function(player, groupkey, takeall, amount, preference)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
        return
    end
    if player == nil or not player:IsValid() or type(player.userid)~="string" or type(groupkey) ~= "string"
        or #groupkey == 0 or #groupkey > 128 then
        return
    end
    if amount~=nil and (type(amount)~="number" or amount~=amount or amount<1 or amount>9999 or amount~=math.floor(amount)) then return end
    if preference~=nil and not Features.ValidPreference(preference) then return end
    preference=preference or "normal"
    if not HasPermission(player) then
        Say(player, "你没有使用拿取/整理功能的权限")
        return
    end
    if HSO_ORGANIZER.IsBusy() then
        Say(player,"整理进行中，请稍后拿取")
        return
    end
    takeall=takeall==true
    local scan = SCAN_CACHE[player.userid]
    if scan == nil or GLOBAL.GetStaticTime() - scan.t > 30 then
        -- 快照过期/缺失时按需重建，而不是静默失败（避免“点按钮没反应”）
        local _, containers, groups = BuildContainerData(player)
        scan = { list = containers, groups = groups, t = GLOBAL.GetStaticTime() }
        SCAN_CACHE[player.userid] = scan
    end
    local selected = scan.groups[groupkey]
    if selected == nil then
        Say(player, "物品已被取走或发生变化")
        SendSnapshot(player)
        return
    end
    local inv = player.components.inventory
    if inv == nil then
        return
    end
    local max_stacks = (CFG_TAKE_LIMIT > 0) and CFG_TAKE_LIMIT or math.huge
    local taken,units = 0,0
    local changed = {}
    local options={}
    for index,ent in ipairs(scan.list) do if Policy.CanTake(ent,player,CFG_RADIUS) then
        local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and item.prefab==selected.p and ItemInfo.GroupKey(ItemInfo.Describe(item))==groupkey
                and not (item.components.inventoryitem~=nil and item.components.inventoryitem.islockedinslot) then
                local fresh,durable=Features.Quality(item)
                options[#options+1]={ent=ent,c=c,slot=slot,item=item,n=ItemCount(item),index=index,
                    priority=preference=="fresh" and (fresh or 101) or preference=="durable" and -(durable or -1) or 0}
            end
        end
    end end
    table.sort(options,function(a,b)
        if a.priority~=b.priority then return a.priority<b.priority end
        if a.index~=b.index then return a.index<b.index end
        if a.n~=b.n then return a.n>b.n end
        return a.slot<b.slot
    end)
    for _,rec in ipairs(options) do
        local ent,cont,slot=rec.ent,rec.c,rec.slot
        while Policy.CanTake(ent,player,CFG_RADIUS) and ent.components.container==cont
            and cont:GetItemInSlot(slot)==rec.item do
            -- Every iteration rechecks the actual entity. Native infinite stacks
            -- can keep the source entity in the slot after yielding a real stack.
            if ItemInfo.GroupKey(ItemInfo.Describe(rec.item))~=groupkey
                or rec.item.components.inventoryitem~=nil and rec.item.components.inventoryitem.islockedinslot then break end
            local remaining=amount~=nil and amount-units or nil
            local item=HSO_ORGANIZER.ExtractForTake(cont,slot,remaining)
            changed[ent]=true
            if item==nil then break end
            local n=ItemCount(item)
            if not HSO_ORGANIZER.DeliverTaken(item,ent,slot,inv) then
                Say(player,"背包空间不足或拿取中断，余量已保留")
                RefreshViews(player,changed);return
            end
            taken,units=taken+1,units+n
            if amount~=nil and units>=amount or amount==nil and not takeall then
                RefreshViews(player,changed);return
            end
            if taken>=max_stacks then
                Say(player,string.format("已达单次上限（%d 组），稍后再拿",CFG_TAKE_LIMIT))
                RefreshViews(player,changed);return
            end
        end
    end
    if taken == 0 then Say(player, "物品已被取走或暂不可拿取") end
    RefreshViews(player, changed)
end)

-- 一键整理
local function SendFeature(player,value)
    if player==nil or not player:IsValid() then return end
    local data=json.encode(value)
    if #data>CHUNK*128 then return end
    feature_serial=feature_serial+1
    local id=tostring(feature_serial)
    local rpc=GLOBAL.GetClientModRPC(MOD_NS,"data")
    local total=math.ceil(#data/CHUNK);local userid=player.userid
    local old=FEATURE_STREAMS[userid]
    if old~=nil and old.task~=nil then old.task:Cancel() end
    local stream={index=1};FEATURE_STREAMS[userid]=stream
    SendModRPCToClient(rpc,userid,"feature_begin",id,tostring(total))
    local function send_batch()
        if FEATURE_STREAMS[userid]~=stream or not player:IsValid() then return end
        local last=math.min(total,stream.index+PACKETS_PER_TICK-1)
        for n=stream.index,last do
            SendModRPCToClient(rpc,userid,"feature_chunk",tostring(n),data:sub((n-1)*CHUNK+1,n*CHUNK),id)
        end
        stream.index=last+1
        if stream.index>total then FEATURE_STREAMS[userid]=nil
        elseif GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
            stream.task=GLOBAL.TheWorld:DoStaticTaskInTime(GLOBAL.FRAMES or (1/30),send_batch)
        else
            while stream.index<=total do
                local n=stream.index;stream.index=n+1
                SendModRPCToClient(rpc,userid,"feature_chunk",tostring(n),data:sub((n-1)*CHUNK+1,n*CHUNK),id)
            end
            FEATURE_STREAMS[userid]=nil
        end
    end
    send_batch()
end
local function FeatureAllowed(player,mutation)
    if GLOBAL.TheWorld==nil or not GLOBAL.TheWorld.ismastersim or player==nil or not player:IsValid()
        or type(player.userid)~="string" then return false end
    if mutation and not HasPermission(player) then Say(player,"你没有使用拿取/整理功能的权限");return false end
    local now=GLOBAL.GetStaticTime();local last=FEATURE_REQUESTS[player.userid]
    if last~=nil and now-last<.15 then return false end
    FEATURE_REQUESTS[player.userid]=now
    return true
end
local function BoxDescription(ent,player)
    local c=ent.components.container
    local meta=ItemInfo.Describe(ent)
    return {g=ent.GUID,p=ent.prefab,d=ItemInfo.HasDetails(meta) and meta or nil,
        distance=math.floor(math.sqrt(player:GetDistanceSqToInst(ent))*10+.5)/10,
        e=c._hso_excluded or nil,w=Policy.OrganizeReason(ent,player,CFG_RADIUS),slots=c:GetNumSlots()}
end
AddModRPCHandler(MOD_NS,"inspect",function(player,key,page)
    if type(key)~="string" or #key==0 or #key>128 or not FeatureAllowed(player,false) then return end
    page=type(page)=="number" and page==page and math.max(1,math.min(100000,math.floor(page))) or 1
    local rows,total,available,count,meta={},0,0,0,nil
    local containers=ScanContainers(player,false)
    for _,ent in ipairs(containers) do
        local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and ItemInfo.GroupKey(ItemInfo.Describe(item))==key then
                count=count+1;local n=ItemCount(item);total=total+n
                local takeable=HasPermission(player) and Policy.CanTake(ent,player,CFG_RADIUS)
                    and not (item.components.inventoryitem~=nil and item.components.inventoryitem.islockedinslot)
                if takeable then available=available+n end
                meta=meta or ItemInfo.Describe(item)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:inventoryitem
AddComponentPostInit("container",HSO_ORGANIZER.WrapContainer)
AddComponentPostInit("inventoryitem",HSO_ORGANIZER.WrapInventoryItem)
AddComponentPostInit("perishable",HSO_ORGANIZER.WrapPerishable)
AddClassPostConstruct("components/container_replica",function(self)
    local canopen=self.CanBeOpened
    if canopen~=nil then self.CanBeOpened=function(replica,...)
        return not replica.inst:HasTag("hso_sorting") and canopen(replica,...)
    end end
end)
for _,worldprefab in ipairs({"world","forest","cave"}) do
    AddPrefabPostInit(worldprefab,HSO_ORGANIZER.WrapWorld)
end

local MOD_NS = "HomeStorageOverview"

local CFG_RADIUS = GetModConfigData("scan_radius") or 40
local CFG_HOTKEY = GetModConfigData("hotkey") or "B"
local CFG_PERMISSION = GetModConfigData("use_permission") or "all"
local CFG_TAKE_LIMIT = GetModConfigData("take_limit") or 20

-- KU 白名单（逗号分隔）
local PERM_SET = {}
do
    local wl = GetModConfigData("ku_whitelist") or ""
    for id in string.gmatch(wl, "[^%s,]+") do
        PERM_SET[id] = true
    end
end

-- 使用权限判定（作用于拿取/整理；总览查看不受限）
local function HasPermission(player)
    if CFG_PERMISSION == "all" then
        return true
    end
    if player == nil or player.userid == nil then
        return false
    end
    if CFG_PERMISSION == "whitelist" then
        return PERM_SET[player.userid] == true
    elseif CFG_PERMISSION == "admin" then
        local net = player.Network
        return net ~= nil and net.IsServerAdmin ~= nil and net:IsServerAdmin()
    end
    return false
end

local CHUNK = 200       -- 单个 RPC 字符串参数的安全长度
local MAX_CHUNKS = 512  -- Bound large-base snapshots, including instance names/recipes.
local PACKETS_PER_TICK = 24
local SNAPSHOT_TTL = 15 -- Native inventory events invalidate the cache immediately.
local REQUEST_INTERVAL = .25 -- Coalesce repeated opens/refreshes before scanning.

local SCAN_CACHE = {}         -- userid -> { list = 容器列表, t = 时间 }
local SNAPSHOT_STREAMS = {}
local SNAPSHOT_REQUESTS = {}
local inventory_revision = 0
local ORGANIZE_COOLDOWN = {}  -- userid -> 上次整理时间
local OPEN_VIEWERS = {}       -- Only open panels renew their subscription by polling.
local PREVIEWS, FEATURE_REQUESTS = {}, {}
local FEATURE_STREAMS={}
local feature_serial=0
local VIEWER_TIMEOUT = 8      -- Allow two three-second polls plus delivery slack.
local SyncContainerEvents, RefreshViews, SendOrganizeState, SendBusy
local WATCHED_CONTAINERS, DIRTY_CONTAINERS = {}, {}
local EVENT_TASK, LEASE_TASK
HSO_ORGANIZER.OnPendingChanged=function(ent)
    inventory_revision=inventory_revision+1
    if RefreshViews~=nil then RefreshViews(nil,{[ent]=true}) end
end

-- 客户端数据状态（客户端/服务端都会注册，双端各持一份）
local HSO_STATE = { hash = nil, data = nil, pending = nil, busy = false, status = nil, listener = nil, onerror = nil }
local NOTICE_SECONDS=4
local function ClientStatus(busy,status)
    if HSO_STATE.busy==busy and HSO_STATE.status==status then return false end
    HSO_STATE.busy,HSO_STATE.status=busy,status
    HSO_STATE.status_until=not busy and type(status)=="string" and #status>0
        and ((GLOBAL.GetStaticTime or GLOBAL.GetTime)()+NOTICE_SECONDS) or nil
    return true
end

-- 玩家离开时清理其快照与冷却记录
AddPlayerPostInit(function(player)
    player:ListenForEvent("onremove", function()
        local job=HSO_ORGANIZER.active_job
        if job~=nil and job.player==player then HSO_ORGANIZER.Cancel(job,"disconnected") end
        local userid = player.userid
        if userid ~= nil then
            SCAN_CACHE[userid] = nil
            ORGANIZE_COOLDOWN[userid] = nil
            OPEN_VIEWERS[userid] = nil
            PREVIEWS[userid],FEATURE_REQUESTS[userid]=nil,nil
            local feature=FEATURE_STREAMS[userid]
            if feature~=nil and feature.task~=nil then feature.task:Cancel() end
            FEATURE_STREAMS[userid]=nil
            local stream=SNAPSHOT_STREAMS[userid]
            if stream~=nil and stream.task~=nil then stream.task:Cancel() end
            SNAPSHOT_STREAMS[userid]=nil
            local request=SNAPSHOT_REQUESTS[userid]
            if request~=nil and request.task~=nil then request.task:Cancel() end
            SNAPSHOT_REQUESTS[userid]=nil
            if SyncContainerEvents ~= nil then SyncContainerEvents() end
        end
    end)
end)

----------------------------------------------------------------
-- 通用
----------------------------------------------------------------

local function Say(player, msg)
    if player ~= nil and player:IsValid() and player.components ~= nil
        and player.components.talker ~= nil then
        player.components.talker:Say(Features.WrapText("[储物] "..Features.BriefStatus(msg),20),4)
    end
end

local function ItemCount(item)
    if item.components.stackable ~= nil then
        return item.components.stackable:StackSize()
    end
    return 1
end

----------------------------------------------------------------
-- 服务端：扫描容器
----------------------------------------------------------------

local function ScanContainers(player, for_organize)
    local scanned = Policy.Scan(player, CFG_RADIUS)
    if not for_organize then return scanned.containers end
    local out = {}
    for _, ent in ipairs(scanned.containers) do
        if Policy.CanOrganize(ent, player, CFG_RADIUS) then out[#out + 1] = ent end
    end
    return out
end

-- D carries names/recipe identities; c.t and A/I use the same selectable group key.
local function BuildContainerData(player)
    local containers = ScanContainers(player, false)
    local ok,cooking=pcall(require,"cooking")
    local ingredients=ItemRules.BuildIngredientSet(GLOBAL.AllRecipes,ok and cooking or nil)
    local payload = { v = 4, c = {}, D = {}, A = {}, I = {}, P = {}, Q = {}, K = {}, n = #containers, s = 0 }
    if not HasPermission(player) then payload.u=false end
    local groups = {}
    local held_by_source={}
    for item,rec in pairs(HSO_ORGANIZER.pending) do
        if item:IsValid() and item.components.inventoryitem.owner==nil then
            local held=held_by_source[rec.source]
            if held==nil then held={};held_by_source[rec.source]=held end
            held[#held+1]=item
        end
    end
    for idx, ent in ipairs(containers) do
        local cont = ent.components.container
        local t, unavailable, used = {}, {}, 0
        local function AddItem(item, held_remainder)
            if item ~= nil then
                local cnt = ItemCount(item)
                local meta = ItemInfo.Describe(item)
                local key = ItemInfo.GroupKey(meta)
                t[key] = (t[key] or 0) + cnt
                local quality=payload.Q[key] or {}
                Features.AddQuality(quality,item)
                if next(quality)~=nil then payload.Q[key]=quality end
                local inv=item.components.inventoryitem
                if (held_remainder or (inv~=nil and inv.islockedinslot)) and not cont.readonlycontainer then
                    unavailable[key]=(unavailable[key] or 0)+cnt
                end
                used = used + cnt   -- 计件数（与界面 "N 件物品" 对应）
                if groups[key] == nil then
                    groups[key] = meta
                    if ItemInfo.HasDetails(meta) then payload.D[key] = meta end
                    if ItemRules.PriorityRaw(meta,ingredients) then payload.P[key]=true end
                    local category=Features.Category(item,meta,payload.P[key])
                    if category~="other" then payload.K[key]=category end
                    payload.A[key], payload.I[key] = ItemInfo.InventoryImage(item)
                end
            end
        end
        for i=1,cont:GetNumSlots() do AddItem(cont:GetItemInSlot(i),false) end
        for _,item in ipairs(held_by_source[ent] or {}) do
            if item:IsValid() and item.components.inventoryitem.owner==nil then AddItem(item,true) end
        end
        if used > 0 then
            payload.s = payload.s + used
            local meta = ItemInfo.Describe(ent)
            table.insert(payload.c, { i = idx, p = ent.prefab,
                d = ItemInfo.HasDetails(meta) and meta or nil, t = t,
                g=ent.GUID,e=cont._hso_excluded or nil,w=Policy.OrganizeReason(ent,player,CFG_RADIUS),
                r = (cont.readonlycontainer or cont.canbeopened == false) and true or nil,
                a = next(unavailable) ~= nil and unavailable or nil })
        end
    end
    return payload, containers, groups
end

local function HashStr(s)
    local h = 5381
    for i = 1, #s do
        h = (h * 33 + string.byte(s, i)) % 4294967291
    end
    return tostring(h) .. "_" .. tostring(#s)
end

----------------------------------------------------------------
-- 服务端：跨箱整理
----------------------------------------------------------------

local function ReportOrganize(player,result)
    if result.error~=nil then print("[HSO] organize interrupted: "..result.error) end
    if result.incomplete then
        print(string.format("[HSO] organize stopped: reason=%s phase=%s stage=%s elapsed=%.2f containers=%d slots=%d records=%d groups=%d work=%d steps=%d pending=%d",
            tostring(result.reason),tostring(result.phase),tostring(result.stage),tonumber(result.elapsed) or 0,
            tonumber(result.containers) or 0,tonumber(result.slots) or 0,tonumber(result.records) or 0,tonumber(result.groups) or 0,
            tonumber(result.work) or 0,tonumber(result.steps) or 0,tonumber(result.pending) or 0))
    end
    if result.pending>0 then
        return string.format("归并 %d 件，合堆 %d 件；暂缓 %d 件恢复",result.moved,result.merged,result.pending)
    end
    if result.incomplete then
        local why=({paused="游戏暂停",timeout="时间超限",time_limit="时间超限",
            work_limit="工作量超限",scheduler="任务调度中断",
            disconnected="玩家离线",container_changed="容器状态变化",item_changed="物品状态变化"})[result.reason] or "库存或容器状态变化"
        return string.format("整理已停止：%s；归并 %d 件，物品已保留",why,result.moved)
    end
    if next(result.changed) ~= nil or result.left > 0 or result.skipped > 0 then
        local reasons={}
        for _,key in ipairs({"excluded","type","open","locked","readonly","unavailable"}) do
            local n=(result.reasons or {})[key]
            if n~=nil and n>0 then reasons[#reasons+1]=(Policy.REASONS[key] or key)..n.."个" end
        end
        return string.format("整理完成：归并 %d 件，释放 %d 格；跳过 %d 个%s",
            result.moved,result.freed or 0,result.skipped,#reasons>0 and ("（"..table.concat(reasons,"、").."）") or "")
    else
        return "物品已集中，无需移动"
    end
end

----------------------------------------------------------------
-- RPC 注册（客户端/服务端必须按相同顺序注册，保证 id 一致）
----------------------------------------------------------------

-- Requests use the known hash; completed actions push authoritative data directly.
local function SendSnapshot(player, client_hash, watching, force)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
        return
    end
    if player == nil or not player:IsValid() or type(player.userid)~="string" then
        return
    end
    if watching == false then
        OPEN_VIEWERS[player.userid] = nil
        local stream=SNAPSHOT_STREAMS[player.userid]
        if stream~=nil and stream.task~=nil then stream.task:Cancel() end
        SNAPSHOT_STREAMS[player.userid]=nil
        SyncContainerEvents()
        return
    elseif watching == true then
        OPEN_VIEWERS[player.userid] = { player = player, t = GLOBAL.GetStaticTime() }
    end
    local now=GLOBAL.GetStaticTime()
    local x,_,z=player.Transform:GetWorldPosition()
    local scan=SCAN_CACHE[player.userid]
    local busy=HSO_ORGANIZER.IsBusy()
    local reusable=scan~=nil and scan.encoded~=nil and (busy or (not force and watching==true
        and client_hash~=nil and client_hash~="" and scan.revision==inventory_revision
        and now-scan.built<SNAPSHOT_TTL and x==scan.x and z==scan.z))
    if not reusable then
        local payload,containers,groups=BuildContainerData(player)
        local encoded=json.encode(payload)
        scan={list=containers,groups=groups,t=now,built=now,x=x,z=z,revision=inventory_revision,
            encoded=encoded,hash=HashStr(encoded)}
        SCAN_CACHE[player.userid]=scan
        SyncContainerEvents()
    else scan.t=now end
    local s,h=scan.encoded,scan.hash
    local clientrpc = GLOBAL.GetClientModRPC(MOD_NS, "data")
    -- Every poll reconciles authoritative state, including a missed completion.
    SendOrganizeState(player,busy,HSO_ORGANIZER.Status())
    local viewer = OPEN_VIEWERS[player.userid]
    if viewer ~= nil then viewer.hash = h end
    local previous=SNAPSHOT_STREAMS[player.userid]
    if previous~=nil and previous.hash~=h then
        if previous.task~=nil then previous.task:Cancel() end
        SNAPSHOT_STREAMS[player.userid]=nil;previous=nil
    end

    if client_hash ~= nil and client_hash ~= "" and client_hash == h then
        SendModRPCToClient(clientrpc, player.userid, "same", h)
        return
    end

    local total = math.ceil(#s / CHUNK)
    if total > MAX_CHUNKS then
        SendModRPCToClient(clientrpc, player.userid, "err", "toomany")
        return
    end
    if previous~=nil and previous.hash==h and not force and client_hash~="" then return end
    if previous~=nil and previous.task~=nil then previous.task:Cancel() end
    local stream={hash=h,index=1};SNAPSHOT_STREAMS[player.userid]=stream
    SendModRPCToClient(clientrpc, player.userid, "begin", h, tostring(total))
    local function send_batch()
        if SNAPSHOT_STREAMS[player.userid]~=stream or not player:IsValid() then return end
        local last=math.min(total,stream.index+PACKETS_PER_TICK-1)
        for i=stream.index,last do
            SendModRPCToClient(clientrpc,player.userid,"chunk",tostring(i),s:sub((i-1)*CHUNK+1,i*CHUNK),h)
        end
        stream.index=last+1
        if stream.index>total then SNAPSHOT_STREAMS[player.userid]=nil
        elseif GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
            stream.task=GLOBAL.TheWorld:DoStaticTaskInTime(GLOBAL.FRAMES or (1/30),send_batch)
        else
            -- Offline fixtures lack a scheduler; real clients always use batches.
            while stream.index<=total do
                local i=stream.index;stream.index=i+1
                SendModRPCToClient(clientrpc,player.userid,"chunk",tostring(i),s:sub((i-1)*CHUNK+1,i*CHUNK),h)
            end
            SNAPSHOT_STREAMS[player.userid]=nil
        end
    end
    send_batch()
end
local function RequestSnapshot(player,client_hash,watching)
    if GLOBAL.TheWorld==nil or not GLOBAL.TheWorld.ismastersim or player==nil or not player:IsValid()
        or type(player.userid)~="string" or (client_hash~=nil and (type(client_hash)~="string" or #client_hash>64))
        or (watching~=nil and type(watching)~="boolean") then return end
    local userid=player.userid;local previous=SNAPSHOT_REQUESTS[userid]
    if watching==false then
        if previous~=nil and previous.task~=nil then previous.task:Cancel() end
        SNAPSHOT_REQUESTS[userid]=nil;SendSnapshot(player,client_hash,false);return
    end
    local now=GLOBAL.GetStaticTime()
    if previous~=nil and now-previous.t<REQUEST_INTERVAL and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        previous.player,previous.hash,previous.watching=player,client_hash,watching
        if previous.task==nil then
            previous.task=GLOBAL.TheWorld:DoStaticTaskInTime(REQUEST_INTERVAL-(now-previous.t),function()
                previous.task=nil
                if SNAPSHOT_REQUESTS[userid]~=previous or not previous.player:IsValid() then return end
                previous.t=GLOBAL.GetStaticTime()
                SendSnapshot(previous.player,previous.hash,previous.watching)
            end)
        end
        return
    end
    if previous~=nil and previous.task~=nil then previous.task:Cancel() end
    SNAPSHOT_REQUESTS[userid]={t=now}
    -- The force argument belongs to authoritative server updates. RPC callers
    -- request a fresh scan with an empty hash, subject to the coalescing above.
    SendSnapshot(player,client_hash,watching)
end
AddModRPCHandler(MOD_NS, "req", RequestSnapshot)

-- Server RPC handlers run to completion. Notify other active views after the
-- actual removals; their own nearby scan determines their new visible quantities.
RefreshViews = function(player, changed)
    if player~=nil then SendSnapshot(player,nil,nil,true) end
    local now = GLOBAL.GetStaticTime()
    for userid, viewer in pairs(OPEN_VIEWERS) do
        if not viewer.player:IsValid() or now - viewer.t > VIEWER_TIMEOUT then
            OPEN_VIEWERS[userid] = nil
        elseif player==nil or userid ~= player.userid then
            local scan = SCAN_CACHE[userid]
            if scan ~= nil then
                for _, ent in ipairs(scan.list) do
                    if changed[ent] then
                        SendSnapshot(viewer.player,viewer.hash,nil,true)
                        break
                    end
                end
            end
        end
    end
    SyncContainerEvents()
end

local function QueueContainerChange(ent)
    DIRTY_CONTAINERS[ent]=true
    inventory_revision=inventory_revision+1
    if HSO_ORGANIZER.IsBusy() then return end
    if EVENT_TASK~=nil then return end
    if GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        EVENT_TASK=GLOBAL.TheWorld:DoStaticTaskInTime(.1,function()
            EVENT_TASK=nil
            if HSO_ORGANIZER.IsBusy() then return end
            local changed=DIRTY_CONTAINERS;DIRTY_CONTAINERS={}
            RefreshViews(nil,changed)
        end)
    end
end

SyncContainerEvents = function()
    local needed={};local now=GLOBAL.GetStaticTime()
    for userid,viewer in pairs(OPEN_VIEWERS) do
        if not viewer.player:IsValid() or now-viewer.t>VIEWER_TIMEOUT then OPEN_VIEWERS[userid]=nil
        else
            local scan=SCAN_CACHE[userid]
            if scan~=nil then
                for _,ent in ipairs(scan.list) do
                    if Policy.CanView(ent,viewer.player,CFG_RADIUS) and ent.ListenForEvent~=nil then needed[ent]=true end
                end
            end
        end
    end
    for ent,watch in pairs(WATCHED_CONTAINERS) do
        if not needed[ent] then
            for _,event in ipairs({"itemget","itemlose","onremove"}) do
                pcall(ent.RemoveEventCallback,ent,event,watch.callback)
            end
            for item in pairs(watch.items) do pcall(ent.RemoveEventCallback,ent,"stacksizechange",watch.callback,item) end
            WATCHED_CONTAINERS[ent]=nil
        end
    end
    for ent in pairs(needed) do
        local watch=WATCHED_CONTAINERS[ent]
        if watch==nil then
            watch={items={},callback=function() QueueContainerChange(ent) end}
            WATCHED_CONTAINERS[ent]=watch
            for _,event in ipairs({"itemget","itemlose","onremove"}) do ent:ListenForEvent(event,watch.callback) end
        end
        local items={};local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and item.ListenForEvent~=nil then items[item]=true end
        end
        for item in pairs(watch.items) do
            if not items[item] then ent:RemoveEventCallback("stacksizechange",watch.callback,item) end
        end
        for item in pairs(items) do
            if not watch.items[item] then ent:ListenForEvent("stacksizechange",watch.callback,item) end
        end
        watch.items=items
    end
    if next(OPEN_VIEWERS)==nil then
        if EVENT_TASK~=nil then EVENT_TASK:Cancel();EVENT_TASK=nil end
        if LEASE_TASK~=nil then LEASE_TASK:Cancel();LEASE_TASK=nil end
        DIRTY_CONTAINERS={}
    elseif LEASE_TASK==nil and GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        LEASE_TASK=GLOBAL.TheWorld:DoStaticTaskInTime(2,function()
            LEASE_TASK=nil;SyncContainerEvents()
        end)
    end
end

-- Match the selected instance group, so different sketches/cards cannot be mixed up.
AddModRPCHandler(MOD_NS, "take", function(player, groupkey, takeall, amount, preference)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
        return
    end
    if player == nil or not player:IsValid() or type(player.userid)~="string" or type(groupkey) ~= "string"
        or #groupkey == 0 or #groupkey > 128 then
        return
    end
    if amount~=nil and (type(amount)~="number" or amount~=amount or amount<1 or amount>9999 or amount~=math.floor(amount)) then return end
    if preference~=nil and not Features.ValidPreference(preference) then return end
    preference=preference or "normal"
    if not HasPermission(player) then
        Say(player, "你没有使用拿取/整理功能的权限")
        return
    end
    if HSO_ORGANIZER.IsBusy() then
        Say(player,"整理进行中，请稍后拿取")
        return
    end
    takeall=takeall==true
    local scan = SCAN_CACHE[player.userid]
    if scan == nil or GLOBAL.GetStaticTime() - scan.t > 30 then
        -- 快照过期/缺失时按需重建，而不是静默失败（避免“点按钮没反应”）
        local _, containers, groups = BuildContainerData(player)
        scan = { list = containers, groups = groups, t = GLOBAL.GetStaticTime() }
        SCAN_CACHE[player.userid] = scan
    end
    local selected = scan.groups[groupkey]
    if selected == nil then
        Say(player, "物品已被取走或发生变化")
        SendSnapshot(player)
        return
    end
    local inv = player.components.inventory
    if inv == nil then
        return
    end
    local max_stacks = (CFG_TAKE_LIMIT > 0) and CFG_TAKE_LIMIT or math.huge
    local taken,units = 0,0
    local changed = {}
    local options={}
    for index,ent in ipairs(scan.list) do if Policy.CanTake(ent,player,CFG_RADIUS) then
        local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and item.prefab==selected.p and ItemInfo.GroupKey(ItemInfo.Describe(item))==groupkey
                and not (item.components.inventoryitem~=nil and item.components.inventoryitem.islockedinslot) then
                local fresh,durable=Features.Quality(item)
                options[#options+1]={ent=ent,c=c,slot=slot,item=item,n=ItemCount(item),index=index,
                    priority=preference=="fresh" and (fresh or 101) or preference=="durable" and -(durable or -1) or 0}
            end
        end
    end end
    table.sort(options,function(a,b)
        if a.priority~=b.priority then return a.priority<b.priority end
        if a.index~=b.index then return a.index<b.index end
        if a.n~=b.n then return a.n>b.n end
        return a.slot<b.slot
    end)
    for _,rec in ipairs(options) do
        local ent,cont,slot=rec.ent,rec.c,rec.slot
        while Policy.CanTake(ent,player,CFG_RADIUS) and ent.components.container==cont
            and cont:GetItemInSlot(slot)==rec.item do
            -- Every iteration rechecks the actual entity. Native infinite stacks
            -- can keep the source entity in the slot after yielding a real stack.
            if ItemInfo.GroupKey(ItemInfo.Describe(rec.item))~=groupkey
                or rec.item.components.inventoryitem~=nil and rec.item.components.inventoryitem.islockedinslot then break end
            local remaining=amount~=nil and amount-units or nil
            local item=HSO_ORGANIZER.ExtractForTake(cont,slot,remaining)
            changed[ent]=true
            if item==nil then break end
            local n=ItemCount(item)
            if not HSO_ORGANIZER.DeliverTaken(item,ent,slot,inv) then
                Say(player,"背包空间不足或拿取中断，余量已保留")
                RefreshViews(player,changed);return
            end
            taken,units=taken+1,units+n
            if amount~=nil and units>=amount or amount==nil and not takeall then
                RefreshViews(player,changed);return
            end
            if taken>=max_stacks then
                Say(player,string.format("已达单次上限（%d 组），稍后再拿",CFG_TAKE_LIMIT))
                RefreshViews(player,changed);return
            end
        end
    end
    if taken == 0 then Say(player, "物品已被取走或暂不可拿取") end
    RefreshViews(player, changed)
end)

-- 一键整理
local function SendFeature(player,value)
    if player==nil or not player:IsValid() then return end
    local data=json.encode(value)
    if #data>CHUNK*128 then return end
    feature_serial=feature_serial+1
    local id=tostring(feature_serial)
    local rpc=GLOBAL.GetClientModRPC(MOD_NS,"data")
    local total=math.ceil(#data/CHUNK);local userid=player.userid
    local old=FEATURE_STREAMS[userid]
    if old~=nil and old.task~=nil then old.task:Cancel() end
    local stream={index=1};FEATURE_STREAMS[userid]=stream
    SendModRPCToClient(rpc,userid,"feature_begin",id,tostring(total))
    local function send_batch()
        if FEATURE_STREAMS[userid]~=stream or not player:IsValid() then return end
        local last=math.min(total,stream.index+PACKETS_PER_TICK-1)
        for n=stream.index,last do
            SendModRPCToClient(rpc,userid,"feature_chunk",tostring(n),data:sub((n-1)*CHUNK+1,n*CHUNK),id)
        end
        stream.index=last+1
        if stream.index>total then FEATURE_STREAMS[userid]=nil
        elseif GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
            stream.task=GLOBAL.TheWorld:DoStaticTaskInTime(GLOBAL.FRAMES or (1/30),send_batch)
        else
            while stream.index<=total do
                local n=stream.index;stream.index=n+1
                SendModRPCToClient(rpc,userid,"feature_chunk",tostring(n),data:sub((n-1)*CHUNK+1,n*CHUNK),id)
            end
            FEATURE_STREAMS[userid]=nil
        end
    end
    send_batch()
end
local function FeatureAllowed(player,mutation)
    if GLOBAL.TheWorld==nil or not GLOBAL.TheWorld.ismastersim or player==nil or not player:IsValid()
        or type(player.userid)~="string" then return false end
    if mutation and not HasPermission(player) then Say(player,"你没有使用拿取/整理功能的权限");return false end
    local now=GLOBAL.GetStaticTime();local last=FEATURE_REQUESTS[player.userid]
    if last~=nil and now-last<.15 then return false end
    FEATURE_REQUESTS[player.userid]=now
    return true
end
local function BoxDescription(ent,player)
    local c=ent.components.container
    local meta=ItemInfo.Describe(ent)
    return {g=ent.GUID,p=ent.prefab,d=ItemInfo.HasDetails(meta) and meta or nil,
        distance=math.floor(math.sqrt(player:GetDistanceSqToInst(ent))*10+.5)/10,
        e=c._hso_excluded or nil,w=Policy.OrganizeReason(ent,player,CFG_RADIUS),slots=c:GetNumSlots()}
end
AddModRPCHandler(MOD_NS,"inspect",function(player,key,page)
    if type(key)~="string" or #key==0 or #key>128 or not FeatureAllowed(player,false) then return end
    page=type(page)=="number" and page==page and math.max(1,math.min(100000,math.floor(page))) or 1
    local rows,total,available,count,meta={},0,0,0,nil
    local containers=ScanContainers(player,false)
    for _,ent in ipairs(containers) do
        local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and ItemInfo.GroupKey(ItemInfo.Describe(item))==key then
                count=count+1;local n=ItemCount(item);total=total+n
                local takeable=HasPermission(player) and Policy.CanTake(ent,player,CFG_RADIUS)
                    and not (item.components.inventoryitem~=nil and item.components.inventoryitem.islockedinslot)
                if takeable then available=available+n end
                meta=meta or ItemInfo.Describe(item)
                if count>(page-1)*6 and count<=page*6 then

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:perishable
AddComponentPostInit("inventoryitem",HSO_ORGANIZER.WrapInventoryItem)
AddComponentPostInit("perishable",HSO_ORGANIZER.WrapPerishable)
AddClassPostConstruct("components/container_replica",function(self)
    local canopen=self.CanBeOpened
    if canopen~=nil then self.CanBeOpened=function(replica,...)
        return not replica.inst:HasTag("hso_sorting") and canopen(replica,...)
    end end
end)
for _,worldprefab in ipairs({"world","forest","cave"}) do
    AddPrefabPostInit(worldprefab,HSO_ORGANIZER.WrapWorld)
end

local MOD_NS = "HomeStorageOverview"

local CFG_RADIUS = GetModConfigData("scan_radius") or 40
local CFG_HOTKEY = GetModConfigData("hotkey") or "B"
local CFG_PERMISSION = GetModConfigData("use_permission") or "all"
local CFG_TAKE_LIMIT = GetModConfigData("take_limit") or 20

-- KU 白名单（逗号分隔）
local PERM_SET = {}
do
    local wl = GetModConfigData("ku_whitelist") or ""
    for id in string.gmatch(wl, "[^%s,]+") do
        PERM_SET[id] = true
    end
end

-- 使用权限判定（作用于拿取/整理；总览查看不受限）
local function HasPermission(player)
    if CFG_PERMISSION == "all" then
        return true
    end
    if player == nil or player.userid == nil then
        return false
    end
    if CFG_PERMISSION == "whitelist" then
        return PERM_SET[player.userid] == true
    elseif CFG_PERMISSION == "admin" then
        local net = player.Network
        return net ~= nil and net.IsServerAdmin ~= nil and net:IsServerAdmin()
    end
    return false
end

local CHUNK = 200       -- 单个 RPC 字符串参数的安全长度
local MAX_CHUNKS = 512  -- Bound large-base snapshots, including instance names/recipes.
local PACKETS_PER_TICK = 24
local SNAPSHOT_TTL = 15 -- Native inventory events invalidate the cache immediately.
local REQUEST_INTERVAL = .25 -- Coalesce repeated opens/refreshes before scanning.

local SCAN_CACHE = {}         -- userid -> { list = 容器列表, t = 时间 }
local SNAPSHOT_STREAMS = {}
local SNAPSHOT_REQUESTS = {}
local inventory_revision = 0
local ORGANIZE_COOLDOWN = {}  -- userid -> 上次整理时间
local OPEN_VIEWERS = {}       -- Only open panels renew their subscription by polling.
local PREVIEWS, FEATURE_REQUESTS = {}, {}
local FEATURE_STREAMS={}
local feature_serial=0
local VIEWER_TIMEOUT = 8      -- Allow two three-second polls plus delivery slack.
local SyncContainerEvents, RefreshViews, SendOrganizeState, SendBusy
local WATCHED_CONTAINERS, DIRTY_CONTAINERS = {}, {}
local EVENT_TASK, LEASE_TASK
HSO_ORGANIZER.OnPendingChanged=function(ent)
    inventory_revision=inventory_revision+1
    if RefreshViews~=nil then RefreshViews(nil,{[ent]=true}) end
end

-- 客户端数据状态（客户端/服务端都会注册，双端各持一份）
local HSO_STATE = { hash = nil, data = nil, pending = nil, busy = false, status = nil, listener = nil, onerror = nil }
local NOTICE_SECONDS=4
local function ClientStatus(busy,status)
    if HSO_STATE.busy==busy and HSO_STATE.status==status then return false end
    HSO_STATE.busy,HSO_STATE.status=busy,status
    HSO_STATE.status_until=not busy and type(status)=="string" and #status>0
        and ((GLOBAL.GetStaticTime or GLOBAL.GetTime)()+NOTICE_SECONDS) or nil
    return true
end

-- 玩家离开时清理其快照与冷却记录
AddPlayerPostInit(function(player)
    player:ListenForEvent("onremove", function()
        local job=HSO_ORGANIZER.active_job
        if job~=nil and job.player==player then HSO_ORGANIZER.Cancel(job,"disconnected") end
        local userid = player.userid
        if userid ~= nil then
            SCAN_CACHE[userid] = nil
            ORGANIZE_COOLDOWN[userid] = nil
            OPEN_VIEWERS[userid] = nil
            PREVIEWS[userid],FEATURE_REQUESTS[userid]=nil,nil
            local feature=FEATURE_STREAMS[userid]
            if feature~=nil and feature.task~=nil then feature.task:Cancel() end
            FEATURE_STREAMS[userid]=nil
            local stream=SNAPSHOT_STREAMS[userid]
            if stream~=nil and stream.task~=nil then stream.task:Cancel() end
            SNAPSHOT_STREAMS[userid]=nil
            local request=SNAPSHOT_REQUESTS[userid]
            if request~=nil and request.task~=nil then request.task:Cancel() end
            SNAPSHOT_REQUESTS[userid]=nil
            if SyncContainerEvents ~= nil then SyncContainerEvents() end
        end
    end)
end)

----------------------------------------------------------------
-- 通用
----------------------------------------------------------------

local function Say(player, msg)
    if player ~= nil and player:IsValid() and player.components ~= nil
        and player.components.talker ~= nil then
        player.components.talker:Say(Features.WrapText("[储物] "..Features.BriefStatus(msg),20),4)
    end
end

local function ItemCount(item)
    if item.components.stackable ~= nil then
        return item.components.stackable:StackSize()
    end
    return 1
end

----------------------------------------------------------------
-- 服务端：扫描容器
----------------------------------------------------------------

local function ScanContainers(player, for_organize)
    local scanned = Policy.Scan(player, CFG_RADIUS)
    if not for_organize then return scanned.containers end
    local out = {}
    for _, ent in ipairs(scanned.containers) do
        if Policy.CanOrganize(ent, player, CFG_RADIUS) then out[#out + 1] = ent end
    end
    return out
end

-- D carries names/recipe identities; c.t and A/I use the same selectable group key.
local function BuildContainerData(player)
    local containers = ScanContainers(player, false)
    local ok,cooking=pcall(require,"cooking")
    local ingredients=ItemRules.BuildIngredientSet(GLOBAL.AllRecipes,ok and cooking or nil)
    local payload = { v = 4, c = {}, D = {}, A = {}, I = {}, P = {}, Q = {}, K = {}, n = #containers, s = 0 }
    if not HasPermission(player) then payload.u=false end
    local groups = {}
    local held_by_source={}
    for item,rec in pairs(HSO_ORGANIZER.pending) do
        if item:IsValid() and item.components.inventoryitem.owner==nil then
            local held=held_by_source[rec.source]
            if held==nil then held={};held_by_source[rec.source]=held end
            held[#held+1]=item
        end
    end
    for idx, ent in ipairs(containers) do
        local cont = ent.components.container
        local t, unavailable, used = {}, {}, 0
        local function AddItem(item, held_remainder)
            if item ~= nil then
                local cnt = ItemCount(item)
                local meta = ItemInfo.Describe(item)
                local key = ItemInfo.GroupKey(meta)
                t[key] = (t[key] or 0) + cnt
                local quality=payload.Q[key] or {}
                Features.AddQuality(quality,item)
                if next(quality)~=nil then payload.Q[key]=quality end
                local inv=item.components.inventoryitem
                if (held_remainder or (inv~=nil and inv.islockedinslot)) and not cont.readonlycontainer then
                    unavailable[key]=(unavailable[key] or 0)+cnt
                end
                used = used + cnt   -- 计件数（与界面 "N 件物品" 对应）
                if groups[key] == nil then
                    groups[key] = meta
                    if ItemInfo.HasDetails(meta) then payload.D[key] = meta end
                    if ItemRules.PriorityRaw(meta,ingredients) then payload.P[key]=true end
                    local category=Features.Category(item,meta,payload.P[key])
                    if category~="other" then payload.K[key]=category end
                    payload.A[key], payload.I[key] = ItemInfo.InventoryImage(item)
                end
            end
        end
        for i=1,cont:GetNumSlots() do AddItem(cont:GetItemInSlot(i),false) end
        for _,item in ipairs(held_by_source[ent] or {}) do
            if item:IsValid() and item.components.inventoryitem.owner==nil then AddItem(item,true) end
        end
        if used > 0 then
            payload.s = payload.s + used
            local meta = ItemInfo.Describe(ent)
            table.insert(payload.c, { i = idx, p = ent.prefab,
                d = ItemInfo.HasDetails(meta) and meta or nil, t = t,
                g=ent.GUID,e=cont._hso_excluded or nil,w=Policy.OrganizeReason(ent,player,CFG_RADIUS),
                r = (cont.readonlycontainer or cont.canbeopened == false) and true or nil,
                a = next(unavailable) ~= nil and unavailable or nil })
        end
    end
    return payload, containers, groups
end

local function HashStr(s)
    local h = 5381
    for i = 1, #s do
        h = (h * 33 + string.byte(s, i)) % 4294967291
    end
    return tostring(h) .. "_" .. tostring(#s)
end

----------------------------------------------------------------
-- 服务端：跨箱整理
----------------------------------------------------------------

local function ReportOrganize(player,result)
    if result.error~=nil then print("[HSO] organize interrupted: "..result.error) end
    if result.incomplete then
        print(string.format("[HSO] organize stopped: reason=%s phase=%s stage=%s elapsed=%.2f containers=%d slots=%d records=%d groups=%d work=%d steps=%d pending=%d",
            tostring(result.reason),tostring(result.phase),tostring(result.stage),tonumber(result.elapsed) or 0,
            tonumber(result.containers) or 0,tonumber(result.slots) or 0,tonumber(result.records) or 0,tonumber(result.groups) or 0,
            tonumber(result.work) or 0,tonumber(result.steps) or 0,tonumber(result.pending) or 0))
    end
    if result.pending>0 then
        return string.format("归并 %d 件，合堆 %d 件；暂缓 %d 件恢复",result.moved,result.merged,result.pending)
    end
    if result.incomplete then
        local why=({paused="游戏暂停",timeout="时间超限",time_limit="时间超限",
            work_limit="工作量超限",scheduler="任务调度中断",
            disconnected="玩家离线",container_changed="容器状态变化",item_changed="物品状态变化"})[result.reason] or "库存或容器状态变化"
        return string.format("整理已停止：%s；归并 %d 件，物品已保留",why,result.moved)
    end
    if next(result.changed) ~= nil or result.left > 0 or result.skipped > 0 then
        local reasons={}
        for _,key in ipairs({"excluded","type","open","locked","readonly","unavailable"}) do
            local n=(result.reasons or {})[key]
            if n~=nil and n>0 then reasons[#reasons+1]=(Policy.REASONS[key] or key)..n.."个" end
        end
        return string.format("整理完成：归并 %d 件，释放 %d 格；跳过 %d 个%s",
            result.moved,result.freed or 0,result.skipped,#reasons>0 and ("（"..table.concat(reasons,"、").."）") or "")
    else
        return "物品已集中，无需移动"
    end
end

----------------------------------------------------------------
-- RPC 注册（客户端/服务端必须按相同顺序注册，保证 id 一致）
----------------------------------------------------------------

-- Requests use the known hash; completed actions push authoritative data directly.
local function SendSnapshot(player, client_hash, watching, force)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
        return
    end
    if player == nil or not player:IsValid() or type(player.userid)~="string" then
        return
    end
    if watching == false then
        OPEN_VIEWERS[player.userid] = nil
        local stream=SNAPSHOT_STREAMS[player.userid]
        if stream~=nil and stream.task~=nil then stream.task:Cancel() end
        SNAPSHOT_STREAMS[player.userid]=nil
        SyncContainerEvents()
        return
    elseif watching == true then
        OPEN_VIEWERS[player.userid] = { player = player, t = GLOBAL.GetStaticTime() }
    end
    local now=GLOBAL.GetStaticTime()
    local x,_,z=player.Transform:GetWorldPosition()
    local scan=SCAN_CACHE[player.userid]
    local busy=HSO_ORGANIZER.IsBusy()
    local reusable=scan~=nil and scan.encoded~=nil and (busy or (not force and watching==true
        and client_hash~=nil and client_hash~="" and scan.revision==inventory_revision
        and now-scan.built<SNAPSHOT_TTL and x==scan.x and z==scan.z))
    if not reusable then
        local payload,containers,groups=BuildContainerData(player)
        local encoded=json.encode(payload)
        scan={list=containers,groups=groups,t=now,built=now,x=x,z=z,revision=inventory_revision,
            encoded=encoded,hash=HashStr(encoded)}
        SCAN_CACHE[player.userid]=scan
        SyncContainerEvents()
    else scan.t=now end
    local s,h=scan.encoded,scan.hash
    local clientrpc = GLOBAL.GetClientModRPC(MOD_NS, "data")
    -- Every poll reconciles authoritative state, including a missed completion.
    SendOrganizeState(player,busy,HSO_ORGANIZER.Status())
    local viewer = OPEN_VIEWERS[player.userid]
    if viewer ~= nil then viewer.hash = h end
    local previous=SNAPSHOT_STREAMS[player.userid]
    if previous~=nil and previous.hash~=h then
        if previous.task~=nil then previous.task:Cancel() end
        SNAPSHOT_STREAMS[player.userid]=nil;previous=nil
    end

    if client_hash ~= nil and client_hash ~= "" and client_hash == h then
        SendModRPCToClient(clientrpc, player.userid, "same", h)
        return
    end

    local total = math.ceil(#s / CHUNK)
    if total > MAX_CHUNKS then
        SendModRPCToClient(clientrpc, player.userid, "err", "toomany")
        return
    end
    if previous~=nil and previous.hash==h and not force and client_hash~="" then return end
    if previous~=nil and previous.task~=nil then previous.task:Cancel() end
    local stream={hash=h,index=1};SNAPSHOT_STREAMS[player.userid]=stream
    SendModRPCToClient(clientrpc, player.userid, "begin", h, tostring(total))
    local function send_batch()
        if SNAPSHOT_STREAMS[player.userid]~=stream or not player:IsValid() then return end
        local last=math.min(total,stream.index+PACKETS_PER_TICK-1)
        for i=stream.index,last do
            SendModRPCToClient(clientrpc,player.userid,"chunk",tostring(i),s:sub((i-1)*CHUNK+1,i*CHUNK),h)
        end
        stream.index=last+1
        if stream.index>total then SNAPSHOT_STREAMS[player.userid]=nil
        elseif GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
            stream.task=GLOBAL.TheWorld:DoStaticTaskInTime(GLOBAL.FRAMES or (1/30),send_batch)
        else
            -- Offline fixtures lack a scheduler; real clients always use batches.
            while stream.index<=total do
                local i=stream.index;stream.index=i+1
                SendModRPCToClient(clientrpc,player.userid,"chunk",tostring(i),s:sub((i-1)*CHUNK+1,i*CHUNK),h)
            end
            SNAPSHOT_STREAMS[player.userid]=nil
        end
    end
    send_batch()
end
local function RequestSnapshot(player,client_hash,watching)
    if GLOBAL.TheWorld==nil or not GLOBAL.TheWorld.ismastersim or player==nil or not player:IsValid()
        or type(player.userid)~="string" or (client_hash~=nil and (type(client_hash)~="string" or #client_hash>64))
        or (watching~=nil and type(watching)~="boolean") then return end
    local userid=player.userid;local previous=SNAPSHOT_REQUESTS[userid]
    if watching==false then
        if previous~=nil and previous.task~=nil then previous.task:Cancel() end
        SNAPSHOT_REQUESTS[userid]=nil;SendSnapshot(player,client_hash,false);return
    end
    local now=GLOBAL.GetStaticTime()
    if previous~=nil and now-previous.t<REQUEST_INTERVAL and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        previous.player,previous.hash,previous.watching=player,client_hash,watching
        if previous.task==nil then
            previous.task=GLOBAL.TheWorld:DoStaticTaskInTime(REQUEST_INTERVAL-(now-previous.t),function()
                previous.task=nil
                if SNAPSHOT_REQUESTS[userid]~=previous or not previous.player:IsValid() then return end
                previous.t=GLOBAL.GetStaticTime()
                SendSnapshot(previous.player,previous.hash,previous.watching)
            end)
        end
        return
    end
    if previous~=nil and previous.task~=nil then previous.task:Cancel() end
    SNAPSHOT_REQUESTS[userid]={t=now}
    -- The force argument belongs to authoritative server updates. RPC callers
    -- request a fresh scan with an empty hash, subject to the coalescing above.
    SendSnapshot(player,client_hash,watching)
end
AddModRPCHandler(MOD_NS, "req", RequestSnapshot)

-- Server RPC handlers run to completion. Notify other active views after the
-- actual removals; their own nearby scan determines their new visible quantities.
RefreshViews = function(player, changed)
    if player~=nil then SendSnapshot(player,nil,nil,true) end
    local now = GLOBAL.GetStaticTime()
    for userid, viewer in pairs(OPEN_VIEWERS) do
        if not viewer.player:IsValid() or now - viewer.t > VIEWER_TIMEOUT then
            OPEN_VIEWERS[userid] = nil
        elseif player==nil or userid ~= player.userid then
            local scan = SCAN_CACHE[userid]
            if scan ~= nil then
                for _, ent in ipairs(scan.list) do
                    if changed[ent] then
                        SendSnapshot(viewer.player,viewer.hash,nil,true)
                        break
                    end
                end
            end
        end
    end
    SyncContainerEvents()
end

local function QueueContainerChange(ent)
    DIRTY_CONTAINERS[ent]=true
    inventory_revision=inventory_revision+1
    if HSO_ORGANIZER.IsBusy() then return end
    if EVENT_TASK~=nil then return end
    if GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        EVENT_TASK=GLOBAL.TheWorld:DoStaticTaskInTime(.1,function()
            EVENT_TASK=nil
            if HSO_ORGANIZER.IsBusy() then return end
            local changed=DIRTY_CONTAINERS;DIRTY_CONTAINERS={}
            RefreshViews(nil,changed)
        end)
    end
end

SyncContainerEvents = function()
    local needed={};local now=GLOBAL.GetStaticTime()
    for userid,viewer in pairs(OPEN_VIEWERS) do
        if not viewer.player:IsValid() or now-viewer.t>VIEWER_TIMEOUT then OPEN_VIEWERS[userid]=nil
        else
            local scan=SCAN_CACHE[userid]
            if scan~=nil then
                for _,ent in ipairs(scan.list) do
                    if Policy.CanView(ent,viewer.player,CFG_RADIUS) and ent.ListenForEvent~=nil then needed[ent]=true end
                end
            end
        end
    end
    for ent,watch in pairs(WATCHED_CONTAINERS) do
        if not needed[ent] then
            for _,event in ipairs({"itemget","itemlose","onremove"}) do
                pcall(ent.RemoveEventCallback,ent,event,watch.callback)
            end
            for item in pairs(watch.items) do pcall(ent.RemoveEventCallback,ent,"stacksizechange",watch.callback,item) end
            WATCHED_CONTAINERS[ent]=nil
        end
    end
    for ent in pairs(needed) do
        local watch=WATCHED_CONTAINERS[ent]
        if watch==nil then
            watch={items={},callback=function() QueueContainerChange(ent) end}
            WATCHED_CONTAINERS[ent]=watch
            for _,event in ipairs({"itemget","itemlose","onremove"}) do ent:ListenForEvent(event,watch.callback) end
        end
        local items={};local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and item.ListenForEvent~=nil then items[item]=true end
        end
        for item in pairs(watch.items) do
            if not items[item] then ent:RemoveEventCallback("stacksizechange",watch.callback,item) end
        end
        for item in pairs(items) do
            if not watch.items[item] then ent:ListenForEvent("stacksizechange",watch.callback,item) end
        end
        watch.items=items
    end
    if next(OPEN_VIEWERS)==nil then
        if EVENT_TASK~=nil then EVENT_TASK:Cancel();EVENT_TASK=nil end
        if LEASE_TASK~=nil then LEASE_TASK:Cancel();LEASE_TASK=nil end
        DIRTY_CONTAINERS={}
    elseif LEASE_TASK==nil and GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
        LEASE_TASK=GLOBAL.TheWorld:DoStaticTaskInTime(2,function()
            LEASE_TASK=nil;SyncContainerEvents()
        end)
    end
end

-- Match the selected instance group, so different sketches/cards cannot be mixed up.
AddModRPCHandler(MOD_NS, "take", function(player, groupkey, takeall, amount, preference)
    if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld.ismastersim then
        return
    end
    if player == nil or not player:IsValid() or type(player.userid)~="string" or type(groupkey) ~= "string"
        or #groupkey == 0 or #groupkey > 128 then
        return
    end
    if amount~=nil and (type(amount)~="number" or amount~=amount or amount<1 or amount>9999 or amount~=math.floor(amount)) then return end
    if preference~=nil and not Features.ValidPreference(preference) then return end
    preference=preference or "normal"
    if not HasPermission(player) then
        Say(player, "你没有使用拿取/整理功能的权限")
        return
    end
    if HSO_ORGANIZER.IsBusy() then
        Say(player,"整理进行中，请稍后拿取")
        return
    end
    takeall=takeall==true
    local scan = SCAN_CACHE[player.userid]
    if scan == nil or GLOBAL.GetStaticTime() - scan.t > 30 then
        -- 快照过期/缺失时按需重建，而不是静默失败（避免“点按钮没反应”）
        local _, containers, groups = BuildContainerData(player)
        scan = { list = containers, groups = groups, t = GLOBAL.GetStaticTime() }
        SCAN_CACHE[player.userid] = scan
    end
    local selected = scan.groups[groupkey]
    if selected == nil then
        Say(player, "物品已被取走或发生变化")
        SendSnapshot(player)
        return
    end
    local inv = player.components.inventory
    if inv == nil then
        return
    end
    local max_stacks = (CFG_TAKE_LIMIT > 0) and CFG_TAKE_LIMIT or math.huge
    local taken,units = 0,0
    local changed = {}
    local options={}
    for index,ent in ipairs(scan.list) do if Policy.CanTake(ent,player,CFG_RADIUS) then
        local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and item.prefab==selected.p and ItemInfo.GroupKey(ItemInfo.Describe(item))==groupkey
                and not (item.components.inventoryitem~=nil and item.components.inventoryitem.islockedinslot) then
                local fresh,durable=Features.Quality(item)
                options[#options+1]={ent=ent,c=c,slot=slot,item=item,n=ItemCount(item),index=index,
                    priority=preference=="fresh" and (fresh or 101) or preference=="durable" and -(durable or -1) or 0}
            end
        end
    end end
    table.sort(options,function(a,b)
        if a.priority~=b.priority then return a.priority<b.priority end
        if a.index~=b.index then return a.index<b.index end
        if a.n~=b.n then return a.n>b.n end
        return a.slot<b.slot
    end)
    for _,rec in ipairs(options) do
        local ent,cont,slot=rec.ent,rec.c,rec.slot
        while Policy.CanTake(ent,player,CFG_RADIUS) and ent.components.container==cont
            and cont:GetItemInSlot(slot)==rec.item do
            -- Every iteration rechecks the actual entity. Native infinite stacks
            -- can keep the source entity in the slot after yielding a real stack.
            if ItemInfo.GroupKey(ItemInfo.Describe(rec.item))~=groupkey
                or rec.item.components.inventoryitem~=nil and rec.item.components.inventoryitem.islockedinslot then break end
            local remaining=amount~=nil and amount-units or nil
            local item=HSO_ORGANIZER.ExtractForTake(cont,slot,remaining)
            changed[ent]=true
            if item==nil then break end
            local n=ItemCount(item)
            if not HSO_ORGANIZER.DeliverTaken(item,ent,slot,inv) then
                Say(player,"背包空间不足或拿取中断，余量已保留")
                RefreshViews(player,changed);return
            end
            taken,units=taken+1,units+n
            if amount~=nil and units>=amount or amount==nil and not takeall then
                RefreshViews(player,changed);return
            end
            if taken>=max_stacks then
                Say(player,string.format("已达单次上限（%d 组），稍后再拿",CFG_TAKE_LIMIT))
                RefreshViews(player,changed);return
            end
        end
    end
    if taken == 0 then Say(player, "物品已被取走或暂不可拿取") end
    RefreshViews(player, changed)
end)

-- 一键整理
local function SendFeature(player,value)
    if player==nil or not player:IsValid() then return end
    local data=json.encode(value)
    if #data>CHUNK*128 then return end
    feature_serial=feature_serial+1
    local id=tostring(feature_serial)
    local rpc=GLOBAL.GetClientModRPC(MOD_NS,"data")
    local total=math.ceil(#data/CHUNK);local userid=player.userid
    local old=FEATURE_STREAMS[userid]
    if old~=nil and old.task~=nil then old.task:Cancel() end
    local stream={index=1};FEATURE_STREAMS[userid]=stream
    SendModRPCToClient(rpc,userid,"feature_begin",id,tostring(total))
    local function send_batch()
        if FEATURE_STREAMS[userid]~=stream or not player:IsValid() then return end
        local last=math.min(total,stream.index+PACKETS_PER_TICK-1)
        for n=stream.index,last do
            SendModRPCToClient(rpc,userid,"feature_chunk",tostring(n),data:sub((n-1)*CHUNK+1,n*CHUNK),id)
        end
        stream.index=last+1
        if stream.index>total then FEATURE_STREAMS[userid]=nil
        elseif GLOBAL.TheWorld~=nil and GLOBAL.TheWorld.DoStaticTaskInTime~=nil then
            stream.task=GLOBAL.TheWorld:DoStaticTaskInTime(GLOBAL.FRAMES or (1/30),send_batch)
        else
            while stream.index<=total do
                local n=stream.index;stream.index=n+1
                SendModRPCToClient(rpc,userid,"feature_chunk",tostring(n),data:sub((n-1)*CHUNK+1,n*CHUNK),id)
            end
            FEATURE_STREAMS[userid]=nil
        end
    end
    send_batch()
end
local function FeatureAllowed(player,mutation)
    if GLOBAL.TheWorld==nil or not GLOBAL.TheWorld.ismastersim or player==nil or not player:IsValid()
        or type(player.userid)~="string" then return false end
    if mutation and not HasPermission(player) then Say(player,"你没有使用拿取/整理功能的权限");return false end
    local now=GLOBAL.GetStaticTime();local last=FEATURE_REQUESTS[player.userid]
    if last~=nil and now-last<.15 then return false end
    FEATURE_REQUESTS[player.userid]=now
    return true
end
local function BoxDescription(ent,player)
    local c=ent.components.container
    local meta=ItemInfo.Describe(ent)
    return {g=ent.GUID,p=ent.prefab,d=ItemInfo.HasDetails(meta) and meta or nil,
        distance=math.floor(math.sqrt(player:GetDistanceSqToInst(ent))*10+.5)/10,
        e=c._hso_excluded or nil,w=Policy.OrganizeReason(ent,player,CFG_RADIUS),slots=c:GetNumSlots()}
end
AddModRPCHandler(MOD_NS,"inspect",function(player,key,page)
    if type(key)~="string" or #key==0 or #key>128 or not FeatureAllowed(player,false) then return end
    page=type(page)=="number" and page==page and math.max(1,math.min(100000,math.floor(page))) or 1
    local rows,total,available,count,meta={},0,0,0,nil
    local containers=ScanContainers(player,false)
    for _,ent in ipairs(containers) do
        local c=ent.components.container
        for slot=1,c:GetNumSlots() do
            local item=c:GetItemInSlot(slot)
            if item~=nil and ItemInfo.GroupKey(ItemInfo.Describe(item))==key then
                count=count+1;local n=ItemCount(item);total=total+n
                local takeable=HasPermission(player) and Policy.CanTake(ent,player,CFG_RADIUS)
                    and not (item.components.inventoryitem~=nil and item.components.inventoryitem.islockedinslot)
                if takeable then available=available+n end
                meta=meta or ItemInfo.Describe(item)
                if count>(page-1)*6 and count<=page*6 then
                    local rec=BoxDescription(ent,player)

```



### 变体演进：欧皇模拟器 随机海钓 综合补丁 (Mod 3656655913)
- **变体场景与切面**：收录来自工坊 Mod 3656655913 (`欧皇模拟器 随机海钓 综合补丁`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3656655913)
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



### 变体演进：True Range (Mod 3817047528)
- **变体场景与切面**：收录来自工坊 Mod 3817047528 (`True Range`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3817047528)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
end
AddPrefabPostInit("world", function(w)
    if w.ismastersim and not CLIENT_ONLY then w:DoPeriodicTask(0, PoseTick) end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
    end)
    AddComponentPostInit("combat", function(self)
        self.inst:ListenForEvent("attacked", Learn.OnAttacked)
        Probe.WrapCombat(self)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ruinsnightmare_horn_attack
local horns = {}
AddPrefabPostInit("ruinsnightmare_horn_attack", function(inst) horns[#horns + 1] = inst end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:antman_warrior_egg
Predict.harmless_falls = GLOBAL.setmetatable({}, { __mode = "k" })
AddPrefabPostInit("antman_warrior_egg", function(inst) Predict.harmless_falls[inst] = true end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:fused_shadeling_quickfuse_bomb
-- (one short-lived, picked up as it's made - looked for only every .3 s, a red bomb's second was a third gone)
AddPrefabPostInit("fused_shadeling_quickfuse_bomb", function(inst) aggro_ents[#aggro_ents + 1] = inst end)

```



### 变体演进：食谱与批量烹饪（烹饪预览 | 批量堆叠） (Mod 3818348123)
- **变体场景与切面**：收录来自工坊 Mod 3818348123 (`食谱与批量烹饪（烹饪预览 | 批量堆叠）`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3818348123)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Buff Timer (Extended) (Mod 3781874198)
- **变体场景与切面**：收录来自工坊 Mod 3781874198 (`Buff Timer (Extended)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3781874198)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:eater
-- effect outside Eat, and the source is then unknown.
AddComponentPostInit("eater", function(component)
    if not component.inst:HasTag("player") then
        return
    end

    local old_eat = component.Eat
    component.Eat = function(self, food, ...)
        self.inst._buff_watch_eating = food
        local eaten = old_eat(self, food, ...)
        self.inst._buff_watch_eating = nil
        return eaten
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:temperature

AddComponentPostInit("temperature", function(component)
    if not component.inst:HasTag("player") then
        return
    end

    local old_set_temperature_in_belly = component.SetTemperatureInBelly
    component.SetTemperatureInBelly = function(self, delta, duration, ...)
        old_set_temperature_in_belly(self, delta, duration, ...)
        local icon = GetFoodIcon(self.inst._buff_watch_eating)
        self.inst:DoTaskInTime(0, function()
            TrackBellyTemperature(self, duration, icon)
        end)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified

AddPrefabPostInit("player_classified", function(inst)
    if inst.components.buff_watch_manager == nil then
        inst:AddComponent("buff_watch_manager")
    end
end)

```



### 变体演进：Crop Leveler (Mod 3646918484)
- **变体场景与切面**：收录来自工坊 Mod 3646918484 (`Crop Leveler`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3646918484)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:friendlyfruitfly
if GetModConfigData("enable_fruitfly_noblock") ~= false then
    AddPrefabPostInit("friendlyfruitfly", function(inst)
        inst:AddTag("NOBLOCK")
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:honeycomb
-- 蜜脾初始化为升级器
AddPrefabPostInit("honeycomb", function(inst)
    inst:AddTag("beeboxleveler_upgrader")
    inst:AddTag("cropleveler_upgrader")
    
    if not TheWorld.ismastersim then return end
    
    if not inst.components.upgrader then
        inst:AddComponent("upgrader")
    end
    inst.components.upgrader.upgradetype = UPGRADETYPES.BEEBOXLEVELER
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:beebox
-- 蜂箱初始化
AddPrefabPostInit("beebox", function(inst)
    if not TheWorld then return end
    
    inst:AddTag("beeboxleveler_upgradeable")
    inst:AddTag("cropleveler_upgradeable")
    
    SetupBeeboxNetworkVar(inst)
    SetupBeeboxDisplayNameFn(inst)
    
    if not TheWorld.ismastersim then return end
    
    local old_OnSave = inst.OnSave
    inst.OnSave = function(inst, data)
        if old_OnSave then
            old_OnSave(inst, data)
        end
        if inst.components.beeboxleveler then
            data.beeboxleveler = inst.components.beeboxleveler:OnSave()
        elseif inst._beeboxleveler_loaddata then
            data.beeboxleveler = inst._beeboxleveler_loaddata
        end
    end
    
    local old_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data, newents)
        if data and data.beeboxleveler then
            inst._beeboxleveler_loaddata = data.beeboxleveler
        end
        if old_OnLoad then
            old_OnLoad(inst, data, newents)
        end
    end
    
    inst:DoTaskInTime(0, function()
        if inst:IsValid() then
            SetupBeeboxLeveler(inst)
        end
    end)
end)


local _old_Upgrader_CanUpgrade_beebox = Upgrader.CanUpgrade
Upgrader.CanUpgrade = function(self, target, doer)
    -- 蜂箱升级
    if self.inst.prefab == "honeycomb" then
        if target and target.prefab == "beebox" and target.components.beeboxleveler then
            if target.components.beeboxleveler:CanUpgrade() then
                return true
            end
        end
        return false
    end
    
    return _old_Upgrader_CanUpgrade_beebox(self, target, doer)
end


local _old_UPGRADE_fn_beebox = ACTIONS.UPGRADE.fn
ACTIONS.UPGRADE.fn = function(act)
    -- 蜂箱升级
    if act.invobject and act.invobject.prefab == "honeycomb" and 
       act.target and act.target.prefab == "beebox" and
       act.target.components.beeboxleveler then
        local leveler = act.target.components.beeboxleveler
        
        if not leveler:CanUpgrade() then
            return false, "MAX_LEVEL"
        end
        
        local success, reason = leveler:Upgrade(act.doer, act.invobject)
        return success, reason
    end
    
    return _old_UPGRADE_fn_beebox(act)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:playercontroller

AddComponentPostInit("playercontroller", function(self)
    local old_DoActionAutoEquip = self.DoActionAutoEquip
    self.DoActionAutoEquip = function(self, buffaction)
        if buffaction and 
           buffaction.action == ACTIONS.UPGRADE and 
           buffaction.invobject and 
           buffaction.invobject.prefab == "bullkelp_root" then
            return -- 不自动装备海带根
        end
        return old_DoActionAutoEquip(self, buffaction)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:bullkelp_root
-- 海带根初始化
AddPrefabPostInit("bullkelp_root", function(inst)
    inst:AddTag("bullkelpleveler_upgrader")
    inst:AddTag("cropleveler_upgrader")
    
    if not TheWorld.ismastersim then return end
    
    if not inst.components.upgrader then
        inst:AddComponent("upgrader")
        inst.components.upgrader.upgradetype = UPGRADETYPES.BULLKELPLEVELER
    end
    
    
    inst:DoTaskInTime(0, function()
        if not inst:IsValid() then return end
        
        local x, y, z = inst.Transform:GetWorldPosition()
        local key = string.format("%.2f:%.2f", x, z)
        
        local pending = _pending_bullkelp_level[key]
        if pending and pending.level > 1 and GetTime() - pending.time < 0.5 then
            _pending_bullkelp_level[key] = nil
            
            for i = 1, pending.level - 1 do
                local extra_root = SpawnPrefab("bullkelp_root")
                if extra_root then
                    extra_root.Transform:SetPosition(
                        pending.x + math.random() * 0.5 - 0.25, 
                        0, 
                        pending.z + math.random() * 0.5 - 0.25
                    )
                end
            end
        end
        
        local now = GetTime()
        for k, v in pairs(_pending_bullkelp_level) do
            if now - v.time > 2 then
                _pending_bullkelp_level[k] = nil
            end
        end
    end)
end)

```



### 变体演进：Cy的黑店 2.0 (Mod 1095971442)
- **变体场景与切面**：收录来自工坊 Mod 1095971442 (`Cy的黑店 2.0`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1095971442)
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

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:researchlab2
end
AddPrefabPostInit("researchlab2",confn)

```



### 变体演进：Potap Trainer 2.0 (GUI) (Mod 3703073616)
- **变体场景与切面**：收录来自工坊 Mod 3703073616 (`Potap Trainer 2.0 (GUI)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3703073616)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Beefalo Scale Adjuster (Mod 3679089363)
- **变体场景与切面**：收录来自工坊 Mod 3679089363 (`Beefalo Scale Adjuster`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3679089363)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:beefalo

AddPrefabPostInit("beefalo", function(inst)
    inst._beefalo_scale_net = _G.net_byte(inst.GUID, "beefalo_scaler._scale", "beefalo_scaler_scaledirty")

    inst:ListenForEvent("beefalo_scaler_scaledirty", ApplyVisual)

    inst:DoTaskInTime(0, ApplyVisual)

    if not _G.TheWorld.ismastersim then
        return
    end

    inst:AddComponent("beefalo_scaler")
end)

```



### 变体演进：Crock Pot Guide (Mod 3814416924)
- **变体场景与切面**：收录来自工坊 Mod 3814416924 (`Crock Pot Guide`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3814416924)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:playercontroller

    AddComponentPostInit("playercontroller", function(self)
        -- Clicks on the panel are for the panel: never let one reach the world (fast clicking
        -- on a slot sometimes did, and the character walked there). Only presses are held
        -- back; releases still go through so nothing in progress gets stuck.
        for _, name in ipairs({ "OnLeftClick", "OnRightClick" }) do
            local old = self[name]
            if old ~= nil then
                self[name] = function(self, down, ...)
                    if down and MouseOverPanel() then
                        return
                    end
                    return old(self, down, ...)
                end
            end
        end

        local old_DoCameraControl = self.DoCameraControl
        self.DoCameraControl = function(self, ...)
            local hud = self.inst.HUD
            local menu = hud ~= nil and hud.controls ~= nil and hud.controls.craftingmenu or nil
            if menu ~= nil and not menu.focus then
                local ok, over = GLOBAL.pcall(function()
                    return GLOBAL.require("widgets/crockpotpanel").IsMouseOverAny()
                end)
                if ok and over then
                    menu.focus = true
                    local results = { GLOBAL.pcall(old_DoCameraControl, self, ...) }
                    menu.focus = false -- always put it back, even if the camera code failed
                    if not results[1] then
                        GLOBAL.error(results[2], 0)
                    end
                    return GLOBAL.unpack(results, 2)
                end
            end
            return old_DoCameraControl(self, ...)
        end
    end)

```



### 变体演进：吕布 (Mod 2918973258)
- **变体场景与切面**：收录来自工坊 Mod 2918973258 (`吕布`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2918973258)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddBrainPostInit:frogbrain
---給牛，獵犬和青蛙添加害怕的腦子
AddBrainPostInit("frogbrain", ScareBrain)
AddBrainPostInit("houndbrain", ScareBrain)
AddBrainPostInit("beefalobrain", ScareBrain)
AddBrainPostInit("beebrain", ScareBrain)

AddBrainPostInit("beeguardbrain", ScareBrain)
AddBrainPostInit("monkeybrain", ScareBrain)

AddBrainPostInit("killerbeebrain", ScareBrain)
AddBrainPostInit("krampusbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)
AddBrainPostInit("walrusbrain", ScareBrain)
AddBrainPostInit("catcoonbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)

AddBrainPostInit("beargerbrain", ScareBrain)
AddBrainPostInit("moosebrain", ScareBrain)
AddBrainPostInit("deerclopsbrain", ScareBrain)
AddBrainPostInit("dragonflybrain", ScareBrain)
AddBrainPostInit("klausbrain", ScareBrain)
AddBrainPostInit("beequeenbrain", ScareBrain)

AddBrainPostInit("knightbrain", ScareBrain)
AddBrainPostInit("shadow_knightbrain", ScareBrain)

AddBrainPostInit("bishopbrain", ScareBrain)
AddBrainPostInit("shadow_bishopbrain", ScareBrain)

AddBrainPostInit("rookbrain", ScareBrain)
AddBrainPostInit("shadow_rookbrain", ScareBrain)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:houndbrain
AddBrainPostInit("frogbrain", ScareBrain)
AddBrainPostInit("houndbrain", ScareBrain)
AddBrainPostInit("beefalobrain", ScareBrain)
AddBrainPostInit("beebrain", ScareBrain)

AddBrainPostInit("beeguardbrain", ScareBrain)
AddBrainPostInit("monkeybrain", ScareBrain)

AddBrainPostInit("killerbeebrain", ScareBrain)
AddBrainPostInit("krampusbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)
AddBrainPostInit("walrusbrain", ScareBrain)
AddBrainPostInit("catcoonbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)

AddBrainPostInit("beargerbrain", ScareBrain)
AddBrainPostInit("moosebrain", ScareBrain)
AddBrainPostInit("deerclopsbrain", ScareBrain)
AddBrainPostInit("dragonflybrain", ScareBrain)
AddBrainPostInit("klausbrain", ScareBrain)
AddBrainPostInit("beequeenbrain", ScareBrain)

AddBrainPostInit("knightbrain", ScareBrain)
AddBrainPostInit("shadow_knightbrain", ScareBrain)

AddBrainPostInit("bishopbrain", ScareBrain)
AddBrainPostInit("shadow_bishopbrain", ScareBrain)

AddBrainPostInit("rookbrain", ScareBrain)
AddBrainPostInit("shadow_rookbrain", ScareBrain)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:beefalobrain
AddBrainPostInit("houndbrain", ScareBrain)
AddBrainPostInit("beefalobrain", ScareBrain)
AddBrainPostInit("beebrain", ScareBrain)

AddBrainPostInit("beeguardbrain", ScareBrain)
AddBrainPostInit("monkeybrain", ScareBrain)

AddBrainPostInit("killerbeebrain", ScareBrain)
AddBrainPostInit("krampusbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)
AddBrainPostInit("walrusbrain", ScareBrain)
AddBrainPostInit("catcoonbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)

AddBrainPostInit("beargerbrain", ScareBrain)
AddBrainPostInit("moosebrain", ScareBrain)
AddBrainPostInit("deerclopsbrain", ScareBrain)
AddBrainPostInit("dragonflybrain", ScareBrain)
AddBrainPostInit("klausbrain", ScareBrain)
AddBrainPostInit("beequeenbrain", ScareBrain)

AddBrainPostInit("knightbrain", ScareBrain)
AddBrainPostInit("shadow_knightbrain", ScareBrain)

AddBrainPostInit("bishopbrain", ScareBrain)
AddBrainPostInit("shadow_bishopbrain", ScareBrain)

AddBrainPostInit("rookbrain", ScareBrain)
AddBrainPostInit("shadow_rookbrain", ScareBrain)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:beebrain
AddBrainPostInit("beefalobrain", ScareBrain)
AddBrainPostInit("beebrain", ScareBrain)

AddBrainPostInit("beeguardbrain", ScareBrain)
AddBrainPostInit("monkeybrain", ScareBrain)

AddBrainPostInit("killerbeebrain", ScareBrain)
AddBrainPostInit("krampusbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)
AddBrainPostInit("walrusbrain", ScareBrain)
AddBrainPostInit("catcoonbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)

AddBrainPostInit("beargerbrain", ScareBrain)
AddBrainPostInit("moosebrain", ScareBrain)
AddBrainPostInit("deerclopsbrain", ScareBrain)
AddBrainPostInit("dragonflybrain", ScareBrain)
AddBrainPostInit("klausbrain", ScareBrain)
AddBrainPostInit("beequeenbrain", ScareBrain)

AddBrainPostInit("knightbrain", ScareBrain)
AddBrainPostInit("shadow_knightbrain", ScareBrain)

AddBrainPostInit("bishopbrain", ScareBrain)
AddBrainPostInit("shadow_bishopbrain", ScareBrain)

AddBrainPostInit("rookbrain", ScareBrain)
AddBrainPostInit("shadow_rookbrain", ScareBrain)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddBrainPostInit:beeguardbrain

AddBrainPostInit("beeguardbrain", ScareBrain)
AddBrainPostInit("monkeybrain", ScareBrain)

AddBrainPostInit("killerbeebrain", ScareBrain)
AddBrainPostInit("krampusbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)
AddBrainPostInit("walrusbrain", ScareBrain)
AddBrainPostInit("catcoonbrain", ScareBrain)
AddBrainPostInit("tallbirdbrain", ScareBrain)

AddBrainPostInit("beargerbrain", ScareBrain)
AddBrainPostInit("moosebrain", ScareBrain)
AddBrainPostInit("deerclopsbrain", ScareBrain)
AddBrainPostInit("dragonflybrain", ScareBrain)
AddBrainPostInit("klausbrain", ScareBrain)
AddBrainPostInit("beequeenbrain", ScareBrain)

AddBrainPostInit("knightbrain", ScareBrain)
AddBrainPostInit("shadow_knightbrain", ScareBrain)

AddBrainPostInit("bishopbrain", ScareBrain)
AddBrainPostInit("shadow_bishopbrain", ScareBrain)

AddBrainPostInit("rookbrain", ScareBrain)
AddBrainPostInit("shadow_rookbrain", ScareBrain)

```



### 变体演进：True Range (Client) (Mod 3819645697)
- **变体场景与切面**：收录来自工坊 Mod 3819645697 (`True Range (Client)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3819645697)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
end
AddPrefabPostInit("world", function(w)
    if w.ismastersim and not CLIENT_ONLY then w:DoPeriodicTask(0, PoseTick) end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
    end)
    AddComponentPostInit("combat", function(self)
        self.inst:ListenForEvent("attacked", Learn.OnAttacked)
        Probe.WrapCombat(self)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:ruinsnightmare_horn_attack
local horns = {}
AddPrefabPostInit("ruinsnightmare_horn_attack", function(inst) horns[#horns + 1] = inst end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:antman_warrior_egg
Predict.harmless_falls = GLOBAL.setmetatable({}, { __mode = "k" })
AddPrefabPostInit("antman_warrior_egg", function(inst) Predict.harmless_falls[inst] = true end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:fused_shadeling_quickfuse_bomb
-- (one short-lived, picked up as it's made - looked for only every .3 s, a red bomb's second was a third gone)
AddPrefabPostInit("fused_shadeling_quickfuse_bomb", function(inst) aggro_ents[#aggro_ents + 1] = inst end)

```



### 变体演进：Itachi Uchiha (Mod 1818702536)
- **变体场景与切面**：收录来自工坊 Mod 1818702536 (`Itachi Uchiha`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1818702536)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:combat

AddComponentPostInit("combat", function(Combat, inst)
    local DoAttack_prev = Combat.DoAttack
    function Combat:DoAttack(target_override, weapon, ...)
        if weapon and weapon.HasAmmo then
            if weapon:HasAmmo(inst) then
                return DoAttack_prev(self, target_override, weapon, ...)
            end
            return
        end        
        return DoAttack_prev(self, target_override, weapon, ...)
    end
end) 

```



### 变体演进：Amethyst (Mod 2272337557)
- **变体场景与切面**：收录来自工坊 Mod 2272337557 (`Amethyst`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2272337557)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skinner

AddComponentPostInit("skinner", function(self)
	local _OnLoad = self.OnLoad
	function self:OnLoad(data, ...)
		_OnLoad(self, data, ...) --Hornet: The game checks if we own the item when we load in, But we don't really "own" the skins we are making
									--so we have to do a little hijack and put our skin item back on our character when they're loading in
		if SKINNABLE_CHARACTERS[self.inst.prefab] and data.skin_name ~= nil then
			self:SetSkinName(data.skin_name)
		end
	end
end)

local _IsDefaultSkinOwned = _G.IsDefaultSkinOwned
local _ValidateItemsLocal = _G.ValidateItemsLocal
local _SpawnNewPlayerOnServerFromSim = _G.SpawnNewPlayerOnServerFromSim
local _GetLockedSkinFilter = _G.GetLockedSkinFilter

function _G.IsDefaultSkinOwned(item_key, ...)
	local index = item_key:find("_")
	local character = item_key:sub(1, index - 1)
	if SKINNABLE_CHARACTERS[character] then
		return true
	end
	
	return _IsDefaultSkinOwned(item_key, ...)
end

--Hornet: Like I said, over and over. We technically don't "own" our skin, and the game gets rid of the base from our character, so we need to save
--the base, run the original function, and then put our base back in place
function _G.ValidateItemsLocal(currentcharacter, selected_skins)
	local _base = selected_skins["base"]

	_ValidateItemsLocal(currentcharacter, selected_skins)
	
	if _base ~= nil and SKINNABLE_CHARACTERS[currentcharacter] then
		selected_skins["base"] = _base 
	end
end

function _G.GetLockedSkinFilter()
	local _LockedFilter = _GetLockedSkinFilter()
	function LockedFilter(item_key)
		local index = item_key:find("_")
		local character = item_key:sub(1, index - 1)
		if SKINNABLE_CHARACTERS[character] then
			return true
		end
		
		return _LockedFilter(item_key)
	end
	
	return LockedFilter
end

function _G.SpawnNewPlayerOnServerFromSim(player_guid, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
	local player = _G.Ents[player_guid]
	if player ~= nil and SKINNABLE_CHARACTERS[player.prefab] then
		local skinner = player.components.skinner
		skinner:SetClothing(clothing_body)
		skinner:SetClothing(clothing_hand)
		skinner:SetClothing(clothing_legs)
		skinner:SetClothing(clothing_feet)
		skinner:SetSkinMode("normal_skin")
			
		player:DoTaskInTime(0, function()
			skinner:SetSkinName(player.components.skinner.skin_name)
		end)
	
		if player.OnNewSpawn ~= nil then
			player:OnNewSpawn()
			player.OnNewSpawn = nil
		end
		_G.TheWorld.components.playerspawner:SpawnAtNextLocation(_G.TheWorld, player)
		_G.SerializeUserSession(player, true)
	else
		_SpawnNewPlayerOnServerFromSim(player_guid, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
	end
end

AddModRPCHandler(modname, "moddedskins", function(inst, base)
	inst.components.skinner.skin_name = base
end)

function AddSkinnableCharacter(name)
	SKINNABLE_CHARACTERS[name] = true
end

```



### 变体演进：共同管理-历史玩家信息(GUI) (Mod 3170978132)
- **变体场景与切面**：收录来自工坊 Mod 3170978132 (`共同管理-历史玩家信息(GUI)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3170978132)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:shard_network

AddPrefabPostInit('shard_network', function(inst)
    if not inst.components.shard_serverinforecord then
        inst:AddComponent('shard_serverinforecord')

            
        if M.MOD_OUTOFDATE_HANDLER_ENABLED and TheShard:IsMaster() then
            
            local handler = shard_serverinforecord.mod_out_of_date_handler
            
            -- add callbacks
            handler:Add(function(mod)
                ExecuteCommandFromServer(M.COMMAND_ENUM.MODOUTOFDATE, true, nil) -- start a vote_state
                M.MOD_OUTOFDATE_VOTE_PASSED_FLAG = false
                if M.MOD_OUTOFDATE_VOTE_DEFAULT_ACTION then
                    execute_in_time_nonstatic(35, function()
                        -- do default action while vote is failed to pass
                        if not M.MOD_OUTOFDATE_VOTE_PASSED_FLAG then
                            -- vote failed to pass
                            ExecuteCommandFromServer(M.COMMAND_ENUM.MODOUTOFDATE, false, M.MOD_OUTOFDATE_VOTE_DEFAULT_ACTION)
                        end
                        M.MOD_OUTOFDATE_VOTE_PASSED_FLAG = nil
                    end)
                end
            end, true) -- trigger only once
            
        end
        
    end
end)


-- master only
if TheShard:IsMaster() then

-- listen for newplayerwall state change
AddPrefabPostInit('world', function(inst)
    inst:ListenForEvent('master_newplayerwallupdate', function(src, data)
        -- redirect MINIMUM level to USER
        local required_min_level = data.required_min_level == M.PERMISSION.MINIMUM and M.PERMISSION.USER or data.required_min_level
        if data.old_state == data.new_state then return end
        if data.new_state then
            -- allow new players to join
            M.announce(S.AUTO_NEW_PLAYER_WALL_STATE_ALLOW)
        else
            -- not allow new players to join
            M.announce_fmt(
                S.FMT_AUTO_NEW_PLAYER_WALL_STATE_NOT_ALLOW, 
                S.LEVEL_PRETTY_NAME[M.LevelEnumToName(required_min_level)]
            )
        end
    end)
end)


local OldFinishVote = UserCommands.FinishVote

-- is this really works?
UserCommands.FinishVote = function(commandname, params, voteresults)
    local passed = OldFinishVote(commandname, params, voteresults)
    dbg('on FinishVote: {commandname = }, {params = }, {voteresults = }, {passed = }')
    if not passed then

        -- vote not passed
        local command = UserCommands.GetCommandFromName(commandname)
        if command.votefailedserverfn then
            command.votefailedserverfn(params, nil)
        end
    end
end

end


-- Server codes end ------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
-- listen for newplayerwall state change
AddPrefabPostInit('world', function(inst)
    inst:ListenForEvent('master_newplayerwallupdate', function(src, data)
        -- redirect MINIMUM level to USER
        local required_min_level = data.required_min_level == M.PERMISSION.MINIMUM and M.PERMISSION.USER or data.required_min_level
        if data.old_state == data.new_state then return end
        if data.new_state then
            -- allow new players to join
            M.announce(S.AUTO_NEW_PLAYER_WALL_STATE_ALLOW)
        else
            -- not allow new players to join
            M.announce_fmt(
                S.FMT_AUTO_NEW_PLAYER_WALL_STATE_NOT_ALLOW, 
                S.LEVEL_PRETTY_NAME[M.LevelEnumToName(required_min_level)]
            )
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified
-- this should be call on both server & client 
AddPrefabPostInit('player_classified', function(inst)
    inst.net_permission_level = net_byte(inst.GUID, 'manage_together.permission_level', 'permission_level_changed')
    
    -- to tell the truth, I don't think the commands will more than 64 in the future...
    -- so we just make a happy hard code.
    -- lua integer size have 64 bits, however netver does not supports 64 bits integer type,
    -- so we should add 2 net_uint(32 bits) variables 
    inst.net_permission_masks = {
        net_uint(inst.GUID, 'manage_together.permission_masks[1]', 'permission_mask_changed'),
        net_uint(inst.GUID, 'manage_together.permission_masks[2]', 'permission_mask_changed')
    }
    inst.net_vote_permission_masks = {
        net_uint(inst.GUID, 'manage_together.vote_permission_masks[1]', 'vote_permission_mask_changed'),
        net_uint(inst.GUID, 'manage_together.vote_permission_masks[2]', 'vote_permission_mask_changed')
    }


    inst.net_suppress_mod_outofdate_announcement = net_bool(inst.GUID, 'manage_together.suppress_mod_outofdate_annoucement', 'suppress_mod_outofdate_annoucement_state_changed')


    inst.permission_level = M.PERMISSION.USER
    inst.permission_mask = 0
    inst.vote_permission_mask = 0
    inst.allow_new_players_to_connect = false
    inst.auto_new_player_wall_enabled = false
    inst.last_query_player_record_timestamp = nil
    inst.next_query_player_record_block_index = 1

    inst.suppress_mod_outofdate_annoucement = false

    inst:ListenForEvent('permission_level_changed', function()
        inst.permission_level = inst.net_permission_level:value()
        dbg('player_classified: permission_level_changed: ', inst.permission_level)
    end)
    
    inst:ListenForEvent('permission_mask_changed', function()
        inst.permission_mask = M.concatbit32to64(inst.net_permission_masks[1]:value(), inst.net_permission_masks[2]:value())
        dbg('player_classified: permission_mask_changed: ', inst.permission_mask)
    end)
    
    inst:ListenForEvent('vote_permission_mask_changed', function()
        inst.vote_permission_mask = M.concatbit32to64(inst.net_vote_permission_masks[1]:value(), inst.net_vote_permission_masks[2]:value())
        dbg('player_classified: vote_permission_mask_changed: ', inst.vote_permission_mask)
    end)

    inst:ListenForEvent('suppress_mod_outofdate_annoucement_state_changed', function()
        inst.suppress_mod_outofdate_annoucement = inst.net_suppress_mod_outofdate_announcement:value()

        if not TheWorld.ismastersim then
            GLOBAL.Networking_ModOutOfDateAnnouncement = inst.suppress_mod_outofdate_annoucement and function()end or original_mod_out_of_date_callback
        end
    end)


    if TheWorld then
        inst:ListenForEvent('player_record_sync_completed', function(src, has_more)
            if has_more then
                local last = inst.next_query_player_record_block_index
                inst.next_query_player_record_block_index = last and (last + 1) or 1
            else
                -- all of the existing records are received, 
                -- we just need to receive the updated reocrds now
                inst.next_query_player_record_block_index = nil
            end
        end, TheWorld)

        if TheWorld.ismastersim then
            --  server side of player_classified

            local recorder = TheWorld.shard.components.shard_serverinforecord

            if M.MOD_OUTOFDATE_HANDLER_ENABLED then
                 
                inst:ListenForEvent('ms_modoutofdate_announcement_state_changed', function()
                    dbg('player_classified: listened ms_modoutofdate_announcement_state_changed')
                    inst.net_suppress_mod_outofdate_announcement:set(recorder.mod_out_of_date_handler:GetSuppressAnnouncement())
                end, TheWorld.shard)
                
            end
        end
    end

    inst.HasPermission = has_permission
    inst.HasVotePermission = has_vote_permission
    inst.SetPermission = set_permission
    inst.QueryHistoryPlayers = query_history_players
    inst.QuerySnapshotInformations = query_snapshot_informations
    inst.QueryServerData = query_server_data
    inst.RequestToExecuteCommand = request_to_execute_command
    inst.RequestToExecuteVoteCommand = request_to_execute_vote_command
    inst.IsCommandApplicableForPlayer = is_command_applicable_for_player
    
    
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:forest_network

AddPrefabPostInit('forest_network', function(inst)
    inst:AddComponent('serverinforecord')
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cave_network

AddPrefabPostInit('cave_network', function(inst)
    inst:AddComponent('serverinforecord')
end)

```



### 变体演进：Sung Jin-woo (Solo Leveling) [Beta] (Mod 3818390299)
- **变体场景与切面**：收录来自工坊 Mod 3818390299 (`Sung Jin-woo (Solo Leveling) [Beta]`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3818390299)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:workable
-- shadow "works" stays untouched, except trees (CHOP_workable), which it may still fell.
AddComponentPostInit("workable", function(self)
    local original = self.WorkedBy
    self.WorkedBy = function(comp, worker, ...)
        if worker ~= nil and worker:HasTag("jinwoo_shadow") and not comp.inst:HasTag("CHOP_workable") then
            return
        end
        return original(comp, worker, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:leader

AddComponentPostInit("leader", function(self)
    local original = self.AddFollower
    self.AddFollower = function(comp, follower, ...)
        if comp.inst:HasTag("jinwoo_shadow") then
            return DropMinion(follower)
        end
        return original(comp, follower, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:follower

AddComponentPostInit("follower", function(self)
    local original = self.SetLeader
    self.SetLeader = function(comp, new_leader, ...)
        if new_leader ~= nil and new_leader:HasTag("jinwoo_shadow") then
            return DropMinion(comp.inst)
        end
        return original(comp, new_leader, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:commander

AddComponentPostInit("commander", function(self)
    local original = self.AddSoldier
    self.AddSoldier = function(comp, soldier, ...)
        if comp.inst:HasTag("jinwoo_shadow") then
            return DropMinion(soldier)
        end
        return original(comp, soldier, ...)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat

AddComponentPostInit("combat", function(self)
    local original = self.GetAttacked
    self.GetAttacked = function(comp, attacker, ...)
        if attacker ~= nil and attacker:HasTag("jinwoo_shadow") and IsFriendOfShadows(comp.inst) then
            return false
        end
        return original(comp, attacker, ...)
    end
end)

```



### 变体演进：血狩灵枪 (Mod 3762229232)
- **变体场景与切面**：收录来自工坊 Mod 3762229232 (`血狩灵枪`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3762229232)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Reset Insight (Mod 3794697781)
- **变体场景与切面**：收录来自工坊 Mod 3794697781 (`Reset Insight`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3794697781)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：More Craftables (Mod 2717158113)
- **变体场景与切面**：收录来自工坊 Mod 2717158113 (`More Craftables`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2717158113)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Storage Robot Upgrade (Mod 3347815582)
- **变体场景与切面**：收录来自工坊 Mod 3347815582 (`Storage Robot Upgrade`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3347815582)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Ranked DST (Mod 3575429214)
- **变体场景与切面**：收录来自工坊 Mod 3575429214 (`Ranked DST`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3575429214)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
  inst:DoTaskInTime(0, function(inst)
    inst:PushEvent("ms_setautosaveenabled", false)
  end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:miniflare
if DEBUG_MODE then
    AddRecipePostInit("miniflare", function(recipe)
        recipe.ingredients = {}
        recipe.numtogive = 10
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:yellowstaff
    local TECH = GLOBAL.TECH
    AddRecipePostInit("yellowstaff", function(recipe)
        recipe.ingredients = {}
        recipe.numtogive = 1
        recipe.level = TECH.NONE
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:archive_resonator_item

AddRecipePostInit("archive_resonator_item", function(recipe)
    recipe.level = GLOBAL.TECH.SCIENCE_ONE
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:winch

AddRecipePostInit("winch", function(recipe)
    recipe.level = GLOBAL.TECH.SCIENCE_ONE
end)

```



### 变体演进：Sort-O-Matic (Mod 3764896380)
- **变体场景与切面**：收录来自工坊 Mod 3764896380 (`Sort-O-Matic`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3764896380)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：lucy_damage (Mod 3686051763)
- **变体场景与切面**：收录来自工坊 Mod 3686051763 (`lucy_damage`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3686051763)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddRecipePostInit:wathgrithr_shield
if CRAFT_SHIELD then
    AddRecipePostInit("wathgrithr_shield", function(recipe)
        recipe.builder_tag = nil
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddRecipePostInit:spear_wathgrithr
if CRAFT_SPEAR then
    AddRecipePostInit("spear_wathgrithr", function(recipe)
        recipe.builder_tag = nil
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:lucy
end
AddPrefabPostInit("lucy", function(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.tool ~= nil then
        inst.components.tool:SetAction(ACTIONS.CHOP, 3)
    end
    inst:AddTag("chop_attack")
    if LUCY_SUMMON_TREE then

        if inst.components.spellcaster == nil then
            inst:AddComponent("spellcaster")
        end

        inst.components.spellcaster:SetSpellFn(SpawnTreeguard)
        inst.components.spellcaster.canuseonpoint = true
        inst.components.spellcaster.canonlyuseonpoint = true

    end
    if inst.components.equippable ~= nil then
        inst.components.equippable.dapperness = 0.1
    end
    if not inst.components.weapon then inst:AddComponent("weapon") end
    inst.components.weapon:SetDamage(LUCY_DAMAGE)
    inst.components.weapon:SetRange(LUCY_RANGE, LUCY_RANGE)
    if not inst.components.planardamage then inst:AddComponent("planardamage") end
    inst.components.planardamage:SetBaseDamage(LUCY_PLANAR)
    inst.fire_atk_enabled = false
    inst.ice_atk_enabled = false
    inst.shield_enabled = false
    local base_lifesteal = LUCY_LIFESTEAL
    local function OnAttack(inst, attacker, target)
        local current_lifesteal = base_lifesteal
        if inst.up_lv and inst.up_lv.batbat then
            current_lifesteal = current_lifesteal + (inst.up_lv.batbat * 0.5)
        end
        if current_lifesteal > 0 and attacker and attacker.components.health and not attacker.components.health:IsDead() then
            attacker.components.health:DoDelta(current_lifesteal)
        end
        if inst.fire_atk_enabled then
            if math.random(1,100) <= 30 then
                if target.fx_fire_atk == nil then
                    target.fx_fire_atk = SpawnPrefab('campfirefire')
                    target.fx_fire_atk.entity:SetParent(target.entity)
                    target.fx_fire_atk.entity:AddFollower()
                    target.fx_fire_atk.Follower:FollowSymbol(target.GUID, nil, 0,-20,0)
                end
                if target.task_fire_atk == nil then
                    target.task_fire_atk = target:DoPeriodicTask(1,function()
                        if target and target.components and target.components.combat and target.components.health and not target.components.health:IsDead() then
                            target.components.combat:GetAttacked(attacker, 10)
                        end
                    end)
                    target:DoTaskInTime(5,function()
                        if target.task_fire_atk ~= nil then
                            target.task_fire_atk:Cancel()
                            target.task_fire_atk = nil
                        end
                        if target.fx_fire_atk ~= nil then
                            target.fx_fire_atk:Remove()
                            target.fx_fire_atk = nil
                        end
                    end)
                end
            end
        end
        if inst.ice_atk_enabled then
            if math.random(1,100) <= 25 then
                if target.components.freezable then
                    target.components.freezable:AddColdness(1)
                    target.components.freezable:SpawnShatterFX()
                end
            end
        end
    end
    inst.components.weapon:SetOnAttack(OnAttack)
    if inst.components.equippable then inst.components.equippable.walkspeedmult = LUCY_SPEED end
    if LUCY_ARMOR > 0 then
        if not inst.components.armor then inst:AddComponent("armor") inst:AddTag("hide_percentage") end
        inst.components.armor:InitIndestructible(LUCY_ARMOR)
    end
    if LUCY_PLANAR_DEF > 0 then
        if not inst.components.planardefense then inst:AddComponent("planardefense") end
        inst.components.planardefense:SetBaseDefense(LUCY_PLANAR_DEF)
    end
    if LUCY_MINE then
        if not inst.components.tool then inst:AddComponent("tool") end
        inst.components.tool:SetAction(ACTIONS.MINE, 3)
        if LUCY_HEAVY_MINE then
            inst.components.tool:EnableToughWork(true)
        end
    end
    if LUCY_UPGRADE_ENABLE then
        inst.up_lv = { spear=0, boomerang=0, wathgrithr_spear=0, hambat=0, whip=0, batbat=0, tentaclespike=0, gunpowder=0, glasscutter=0, nightsword=0, brightsword=0, shadow_reaper=0, firestaff=false, icestaff=false, morningstar=false, shield=false }
        local function UpdateLucyStats(inst)
            local bonus_dmg = (inst.up_lv.spear * 1) + (inst.up_lv.wathgrithr_spear * 2) + (inst.up_lv.hambat * 2) + (inst.up_lv.gunpowder * 0.5) + (inst.up_lv.tentaclespike * 2) + (inst.up_lv.glasscutter * 3) + (inst.up_lv.nightsword * 3) + (inst.up_lv.shadow_reaper * 1)
            local bonus_planar = (inst.up_lv.gunpowder * 0.5) + (inst.up_lv.brightsword * 4) + (inst.up_lv.shadow_reaper * 3)
            local bonus_range = (inst.up_lv.boomerang * 0.1) + (inst.up_lv.whip * 0.2)
            inst.components.weapon:SetDamage(LUCY_DAMAGE + bonus_dmg)
            inst.components.planardamage:SetBaseDamage(LUCY_PLANAR + bonus_planar)
            inst.components.weapon:SetRange(LUCY_RANGE + bonus_range, LUCY_RANGE + bonus_range)
        end
        if not inst.components.trader then inst:AddComponent("trader") end
        local up_mats = { spear="spear", boomerang="boomerang", spear_wathgrithr="wathgrithr_spear", hambat="hambat", whip="whip", batbat="batbat", tentaclespike="tentaclespike", gunpowder="gunpowder", glasscutter="glasscutter", nightsword="nightsword", sword_lunarplant="brightsword", voidcloth_scythe="shadow_reaper", firestaff="firestaff", icestaff="icestaff", wathgrithr_shield="shield" }
        local up_limits = { spear=LUCY_UP_SPEAR, boomerang=LUCY_UP_BOOMERANG, wathgrithr_spear=LUCY_UP_WATHGRITHR_SPEAR, hambat=LUCY_UP_HAMBAT, whip=LUCY_UP_WHIP, batbat=LUCY_UP_BATBAT, tentaclespike=LUCY_UP_TENTACLESPIKE, gunpowder=LUCY_UP_GUNPOWDER, glasscutter=LUCY_UP_GLASSCUTTER, nightsword=LUCY_UP_NIGHTSWORD, brightsword=LUCY_UP_BRIGHTSWORD, shadow_reaper=LUCY_UP_SHADOW_REAPER, firestaff=LUCY_UP_FIRESTAFF, icestaff=LUCY_UP_ICESTAFF, shield=LUCY_UP_SHIELD }
        local up_names = { spear="长矛", boomerang="回旋镖", wathgrithr_spear="战斗长矛", hambat="火腿棒", whip="三尾猫鞭", batbat="蝙蝠棒", tentaclespike="触手尖刺", gunpowder="火药", glasscutter="玻璃刀", nightsword="暗夜剑", brightsword="亮茄剑", shadow_reaper="暗影收割者", firestaff="火魔杖", icestaff="冰魔杖", shield="战斗圆盾" }
        inst.components.trader:SetAcceptTest(function(inst, item)
            if not up_mats[item.prefab] then return false end
            local key = up_mats[item.prefab]
            if key == "firestaff" or key == "icestaff" or key == "shield" then
                return up_limits[key] and not inst.up_lv[key]
            else
                return true
            end
        end)
        inst.components.trader.onaccept = function(inst, giver, item)
            local key = up_mats[item.prefab]
            if key == "firestaff" then
                if up_limits.firestaff and not inst.up_lv.firestaff then
                    inst.up_lv.firestaff = true
                    inst.fire_atk_enabled = true
                    if giver.components.talker then giver.components.talker:Say("解锁火焰攻击！") end
                else
                    if giver.components.talker then giver.components.talker:Say("已经升级过了！") end
                end
            elseif key == "icestaff" then
                if up_limits.icestaff and not inst.up_lv.icestaff then
                    inst.up_lv.icestaff = true
                    inst.ice_atk_enabled = true
                    if giver.components.talker then giver.components.talker:Say("解锁冰冻攻击！") end
                else
                    if giver.components.talker then giver.components.talker:Say("已经升级过了！") end
                end
            elseif key == "shield" then
                if up_limits.shield and not inst.up_lv.shield then
                    inst.up_lv.shield = true
                    inst.shield_enabled = true
                    if giver.components.talker then giver.components.talker:Say("解锁格挡功能！按Z键格挡") end
                else
                    if giver.components.talker then giver.components.talker:Say("已经升级过了！") end
                end
            else
                if inst.up_lv[key] < up_limits[key] then
                    inst.up_lv[key] = inst.up_lv[key] + 1
                    UpdateLucyStats(inst)
                    if giver.components.talker then giver.components.talker:Say(up_names[key].."等级: "..inst.up_lv[key].."/"..up_limits[key]) end
                else
                    if giver.components.talker then giver.components.talker:Say(up_names[key].."等级已满！") end
                end
            end
        end
        inst.OnSave = function(inst, data)
            data.up_lv = inst.up_lv
            data.fire_atk_enabled = inst.fire_atk_enabled
            data.ice_atk_enabled = inst.ice_atk_enabled
            data.shield_enabled = inst.shield_enabled
        end
        inst.OnPreLoad = function(inst, data)
            if data and data.up_lv then
                inst.up_lv = data.up_lv
                UpdateLucyStats(inst)
                inst.fire_atk_enabled = data.fire_atk_enabled or false
                inst.ice_atk_enabled = data.ice_atk_enabled or false
                inst.shield_enabled = data.shield_enabled or false
            end
        end
    end
end)
local function OnParryKeyPressed(player)
    if not TheWorld.ismastersim then return end
    if not player or not player:HasTag("player") then return end
    local weapon = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if not weapon or weapon.prefab ~= "lucy" or not weapon.shield_enabled then
        if player.components.talker then player.components.talker:Say("需要装备已升级的露西斧") end
        return
    end
    if not weapon.components.aoetargeting then
        weapon:AddComponent("aoetargeting")
        weapon.components.aoetargeting:SetAlwaysValid(true)
        weapon.components.aoetargeting:SetAllowRiding(false)
        weapon.components.aoetargeting.reticule.reticuleprefab = "reticulearc"
        weapon.components.aoetargeting.reticule.pingprefab = "reticulearcping"
        weapon.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
        weapon.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
        weapon.components.aoetargeting.reticule.ease = true
        weapon.components.aoetargeting.reticule.mouseenabled = true
    end
    if not weapon.components.parryweapon then
        weapon:AddComponent("parryweapon")
        weapon.components.parryweapon:SetParryArc(120)
    end
    weapon.components.aoetargeting:SetEnabled(true)
    if player.components.talker then player.components.talker:Say("准备格挡！") end
end
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    if not inst.components.timer then inst:AddComponent("timer") end
end)
if TheInput then
    TheInput:AddKeyDownHandler(KEY_Z, function()
        local player = ThePlayer
        if player then SendModRPCToServer(MOD_RPC["lucy_parry"]["parry"]) end
    end)
end
AddModRPCHandler("lucy_parry", "parry", function(player) OnParryKeyPressed(player) end)
local mats_to_init = {"spear", "boomerang", "spear_wathgrithr", "hambat", "whip", "batbat", "tentaclespike", "gunpowder", "glasscutter", "nightsword", "sword_lunarplant", "voidcloth_scythe", "firestaff", "icestaff", "wathgrithr_shield"}
for _, m in ipairs(mats_to_init) do
    AddPrefabPostInit(m, function(inst) if not inst.components.tradable then inst:AddComponent("tradable") end end)
end

```



### 变体演进：横向状态条2.1 (Mod 3793827776)
- **变体场景与切面**：收录来自工坊 Mod 3793827776 (`横向状态条2.1`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3793827776)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Telelocator Station Selector (Mod 3809953054)
- **变体场景与切面**：收录来自工坊 Mod 3809953054 (`Telelocator Station Selector`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3809953054)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    Debug.Log("world side", inst.ismastersim and "server" or "client")
    if not inst.ismastersim then
        return
    end

    if inst.components.telelocatorstationregistry == nil then
        inst:AddComponent(
            "telelocatorstationregistry"
        )
    end
    Debug.Log("world registry/component created")
    inst:DoTaskInTime(0, function()
        local registry = inst.components.telelocatorstationregistry
        if not registry.rebuilt then registry:Rebuild() end
    end)

end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:telebase

AddPrefabPostInit("telebase", function(inst)
    -- Only the world owns ismastersim; ordinary prefab instances do not.
    if not IsMasterSim() then
        return
    end

    ---------------------------------------------------------------------------
    -- Persistent station component
    ---------------------------------------------------------------------------

    if inst.components.telelocatorstation == nil then
        inst:AddComponent(
            "telelocatorstation"
        )
    end
    Debug.Log("Focus server component added")

    ---------------------------------------------------------------------------
    -- Initialize station
    ---------------------------------------------------------------------------

    inst:DoTaskInTime(
        0,
        function()
            if not inst:IsValid() then
                return
            end

            local component =
                inst.components.telelocatorstation

            if component ~= nil then
                component:Initialize()
            end
        end
    )

    -- Coalesce socket trade/pick notifications; never poll every frame.
    local function StationChanged()
        if inst._telelocator_notify_task == nil then
            inst._telelocator_notify_task = inst:DoTaskInTime(0, function()
                inst._telelocator_notify_task = nil
                if inst:IsValid() then telelocator_teleport.NotifyStation(inst) end
            end)
        end
    end
    inst:ListenForEvent("telelocator_station_changed", function(_, data)
        telelocator_teleport.NotifyStation(inst, data ~= nil and data.removed)
    end)
    inst:ListenForEvent("onremove", function()
        telelocator_teleport.NotifyStation(inst, true)
        if inst._telelocator_notify_task ~= nil then inst._telelocator_notify_task:Cancel() end
    end)
    local spawner = inst.components.objectspawner
    if spawner ~= nil then
        local original = spawner.onnewobjectfn
        spawner.onnewobjectfn = function(base, socket, ...)
            if original ~= nil then original(base, socket, ...) end
            inst:ListenForEvent("trade", StationChanged, socket)
            inst:ListenForEvent("picked", StationChanged, socket)
            StationChanged()
        end
    end

    ---------------------------------------------------------------------------
    -- INFINITE FOCUS CHARGES
    ---------------------------------------------------------------------------

    if MOD_CONFIG.infinite_focus_charges then

        local vanilla_onteleto =
            inst.onteleto

        if type(vanilla_onteleto) == "function" then

            inst._telelocator_vanilla_onteleto =
                vanilla_onteleto

            inst.onteleto =
                function(self)

                    if not self:IsValid() then
                        return
                    end

                    local disabled_destroy_functions =
                        {}

                    local objectspawner =
                        self.components.objectspawner

                    if objectspawner ~= nil
                        and objectspawner.objects ~= nil then

                        for _, socket in pairs(
                            objectspawner.objects
                        ) do

                            if socket ~= nil
                                and socket.DestroyGemFn ~= nil then

                                disabled_destroy_functions[socket] =
                                    socket.DestroyGemFn

                                socket.DestroyGemFn =
                                    function()
                                        -- Infinite Focus charge.
                                    end
                            end
                        end
                    end

                    local ok, err =
                        pcall(
                            vanilla_onteleto,
                            self
                        )

                    ----------------------------------------------------------------
                    -- Restore original DestroyGemFn functions.
                    ----------------------------------------------------------------

                    for socket, destroyfn in pairs(
                        disabled_destroy_functions
                    ) do

                        if socket ~= nil
                            and socket:IsValid() then

                            socket.DestroyGemFn =
                                destroyfn
                        end
                    end

                    if not ok then
                        print(
                            "[TelelocatorSelector] "
                            .. "vanilla telebase:onteleto error:",
                            err
                        )
                    end
                end
        end
    end
end)

-------------------------------------------------------------------------------
-- TELELOCATOR STAFF
-------------------------------------------------------------------------------

AddPrefabPostInit("telestaff", function(inst)
    if not IsMasterSim() then
        return
    end

    inst:DoTaskInTime(
        0,
        function()
            if inst ~= nil
                and inst:IsValid() then

                telelocator_teleport.WrapStaffSpellFn(
                    inst
                )
            end
        end
    )
end)
Debug.Log("modmain loaded; world/Focus/staff hooks registered")

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:telestaff

AddPrefabPostInit("telestaff", function(inst)
    if not IsMasterSim() then
        return
    end

    inst:DoTaskInTime(
        0,
        function()
            if inst ~= nil
                and inst:IsValid() then

                telelocator_teleport.WrapStaffSpellFn(
                    inst
                )
            end
        end
    )
end)

```



### 变体演进：Mod 3678295700 (Mod 3678295700)
- **变体场景与切面**：收录来自工坊 Mod 3678295700 (`Mod 3678295700`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3678295700)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:talker
---
AddComponentPostInit("talker",function(self)
    local old_Say = self.Say
    function self:Say(script, ...)
      if type(script) == "string" and (string.find(script, "//张贴//", 1, true) or string.find(script, "//空白//", 1, true)) then
        return
      end
      old_Say(self, script, ...)
    end
end)

```



### 变体演进：Honeymoon Tent - Shared Sleep & Infinite Uses (Mod 3815339596)
- **变体场景与切面**：收录来自工坊 Mod 3815339596 (`Honeymoon Tent - Shared Sleep & Infinite Uses`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3815339596)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:tent

AddPrefabPostInit("tent", PatchTent)

if SIESTA_SUPPORT then
    AddPrefabPostInit("siestahut", PatchTent)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:siestahut
if SIESTA_SUPPORT then
    AddPrefabPostInit("siestahut", PatchTent)
end

```



### 变体演进：Laru (Mod 3517115798)
- **变体场景与切面**：收录来自工坊 Mod 3517115798 (`Laru`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3517115798)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：pzjg 骗子酒馆 (Mod 3484776980)
- **变体场景与切面**：收录来自工坊 Mod 3484776980 (`pzjg 骗子酒馆`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3484776980)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

-- AddPrefabPostInit("world", function(inst)
--     inst:DoWallTaskInTime(0, function() 
--         print("[DoWallTaskInTime]第一帧 GetTime =", GetTime())
--     end)
--     inst:DoWallTaskInTime(1, function() 
--         print("[DoWallTaskInTime]第一秒 GetTime =", GetTime())
--     end)
--     inst:DoTaskInTime(0, function() 
--         print("[DoTaskInTime]世界生成后的第一帧", GetTime())
--     end)
--     inst:DoTaskInTime(1, function() 
--         print("[DoTaskInTime]世界生成后的第一秒", GetTime())
--     end)
--     inst:ListenForEvent("serverpauseddirty", function(inst, data) 
--         print("p键暂停")
--         print(dumptable(data, 1, 5))
--     end,inst)
-- end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:player_classified

-- AddPrefabPostInit("player_classified", function(inst)
-- end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:sittable
-- 凳子类的
AddComponentPostInit("sittable", function(self)
	self.SetOccupier = createHookedFunction(self.SetOccupier, 
	function(self, occupier)
		if self.occupier and self.occupier:HasTag("player") and occupier == nil then
			local x, y, z = self.inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 8, {tag})
			if #ents >= 1 then
				ents[1]:PushEvent("exit_request_pzjg", self.occupier)
			end
		end
		return true
	end, 
	function()
		-- 是玩家且位于桌子附近 (生活需要一点点仪式感)
		-- print("执行了", self.occupier and self.occupier:HasTag("player") )
		if self.occupier and self.occupier:HasTag("player") then
			local x, y, z = self.inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 8, {tag})
			if #ents >= 1 then
				ents[1]:PushEvent("join_request_pzjg", self.occupier)
				-- 打开界面
				-- pzjg_RPCToClient(self.occupier.userid, "expand", nil, ents[1])
			end
		end
	end)
end)

```



### 变体演进：移除地面积雪 (Mod 3405222829)
- **变体场景与切面**：收录来自工坊 Mod 3405222829 (`移除地面积雪`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3405222829)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：星契纪行 (Mod 3817117428)
- **变体场景与切面**：收录来自工坊 Mod 3817117428 (`星契纪行`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3817117428)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:daywalker
    end
    env.AddPrefabPostInit("daywalker", Attach)
    env.AddPrefabPostInit("daywalker2", Attach)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:daywalker2
    env.AddPrefabPostInit("daywalker", Attach)
    env.AddPrefabPostInit("daywalker2", Attach)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:builder

    env.AddComponentPostInit("builder", function(self)
        local has, get = self.HasIngredients, self.GetIngredients
        self.HasIngredients = function(builder, recipe, ...) return Craft.Check(builder, recipe, has, ...) end
        self.GetIngredients = function(builder, name, ...) return Craft.Ingredients(builder, name, get, ...) end
    end)

```



### 变体演进：KEY (Mod 3008998415)
- **变体场景与切面**：收录来自工坊 Mod 3008998415 (`KEY`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3008998415)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：食物属性标签 (Mod 2952056226)
- **变体场景与切面**：收录来自工坊 Mod 2952056226 (`食物属性标签`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2952056226)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Craft From Chest [DST] Fixed (Mod 2797670225)
- **变体场景与切面**：收录来自工坊 Mod 2797670225 (`Craft From Chest [DST] Fixed`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2797670225)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:player_classified

AddPrefabPostInit("player_classified", function(inst)
	-- if TheNet:GetIsServer() then
		-- inst._found = _G.net_bool(inst.GUID, "_found")
        -- inst._found:set(false)
        -- inst._itype = _G.net_string(inst.GUID, "_itype")
        -- inst._itype:set("0")
        -- inst._amount = _G.net_shortint(inst.GUID, "_amount", "amountDirty")
        -- inst._amount:set(0)
        inst._itemTable = {}
        inst._items = _G.net_string(inst.GUID, "_items", "itemsDirty")
        inst._items:set("")
        inst:ListenForEvent("itemsDirty", itemsDirty)
        -- inst:ListenForEvent("amountDirty", amountDirty)
        -- inst:ListenForEvent("itemget", itemDirty)
        -- inst:ListenForEvent("itemlose", itemDirty)
        -- inst._chest = _G.net_bool(inst.GUID, "_chest", "chestDirty")
        -- inst._chest:set(true)
        -- inst:ListenForEvent("chestDirty", chestDirty)

        -- inst.setFound = setFound
        -- inst.chestChange = chestChange
        inst.allItemUpdate = allItemUpdate
        if _G.TheWorld.ismastersim then
            inst.smashtask = inst:DoPeriodicTask(.5, allItemUpdate)
        end
	-- end
end)

```



### 变体演进：坐着轮椅玩勋章2 (Mod 3786404160)
- **变体场景与切面**：收录来自工坊 Mod 3786404160 (`坐着轮椅玩勋章2`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3786404160)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:health

AddComponentPostInit("health", function(self)
	local inst = self.inst
	if inst == nil or not inst:HasTag("player") or inst.helper_fataldamage_hooked then return end
	inst.helper_fataldamage_hooked = true
	local oldSetVal = self.SetVal
	self.SetVal = function(self, val, cause, afflicter, ...)
		local old_health, min_health = self.currenthealth, self.minhealth or 0
		if val <= min_health and old_health > min_health then
			TryFatalDamageAutoEquip(self.inst)
		end
		return oldSetVal and oldSetVal(self, val, cause, afflicter, ...) or nil
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:medal_childishness_chest
--照伪动作流水线：先换装+记应佩戴，再用 RunWithEquipAlign 包原函数(缺佩剥假标签)
AddPrefabPostInit("medal_childishness_chest", function(inst)
	if not GLOBAL.TheNet:GetIsServer() then return end
	if inst.exchangeGift == nil or inst.helper_exchangegift_hooked then return end
	inst.helper_exchangegift_hooked = true
	local old_exchange = inst.exchangeGift
	inst.exchangeGift = function(self, player, ...)
		local expected = PseudoActionEquip(player, "MEDALEXCHANGEGIFT", self)
		if expected ~= nil and GLOBAL.RunWithEquipAlign ~= nil then
			return GLOBAL.RunWithEquipAlign(player, expected, "MEDALEXCHANGEGIFT", "fn", old_exchange, self, player, ...)
		end
		return old_exchange(self, player, ...)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:playerprox
--故用伪动作 NEARFIRENETTLE 承接，照普通动作流水线：先 TryAutoEquip 换装+记应佩戴，再用 RunWithEquipAlign 包原回调(缺佩剥假标签)
AddComponentPostInit("playerprox", function(self)
	if self.inst == nil or self.inst.prefab ~= "weed_firenettle" then return end
	local oldSetOnPlayerNear = self.SetOnPlayerNear
	if oldSetOnPlayerNear == nil then return end
	self.SetOnPlayerNear = function(self, fn, ...)
		local wrapped = function(inst_, player_, ...)
			--与动作fn层捕获同款：先换装(伪动作流水线)，再在对齐窗口内执行原回调(缺佩剥假标签)
			local expected = PseudoActionEquip(player_, "NEARFIRENETTLE", inst_)
			if expected ~= nil and GLOBAL.RunWithEquipAlign ~= nil then
				return GLOBAL.RunWithEquipAlign(player_, expected, "NEARFIRENETTLE", "fn", fn, inst_, player_, ...)
			end
			return fn(inst_, player_, ...)
		end
		return oldSetOnPlayerNear(self, wrapped, ...)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
--故用伪动作 NEAREYEPLANT 承接：重锁前把范围内玩家走一遍流水线，装备后成真plantkin即不被锁定
AddComponentPostInit("combat", function(self)
	--注意：引擎要等 prefab.fn() 返回后才设 inst.prefab(mainfunctions.lua:366)，而眼球草的 combat 是在 fn 内加的
	--(eyeplant.lua:116)，此刻 prefab 名还是 nil，故只能用标签判(eyeplant.lua:96 已先打"eyeplant"标签)
	if self.inst == nil or not self.inst:HasTag("eyeplant") then return end
	local oldSetRetargetFunction = self.SetRetargetFunction
	if oldSetRetargetFunction == nil then return end
	self.SetRetargetFunction = function(self, period, fn, ...)
		if fn == nil then return oldSetRetargetFunction(self, period, fn, ...) end
		local wrapped = function(inst, ...)
			local x, y, z = inst.Transform:GetWorldPosition()
			local targets
			for _, player in ipairs(TheSim:FindEntities(x, y, z, TUNING.EYEPLANT_ATTACK_DIST or 2.5, { "player" })) do
				local expected = PseudoActionEquip(player, "NEAREYEPLANT", inst)
				if expected ~= nil then
					targets = targets or {}
					table.insert(targets, { player = player, expected = expected })
				end
			end
			if targets ~= nil and GLOBAL.RunWithEquipAlignAll ~= nil then
				return GLOBAL.RunWithEquipAlignAll(targets, "NEAREYEPLANT", "fn", fn, inst, ...)
			end
			return fn(inst, ...)
		end
		return oldSetRetargetFunction(self, period, wrapped, ...)
	end
end)


-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:debuffable
if GLOBAL.TheNet:GetIsServer() then
	AddComponentPostInit("debuffable", function(self)
		local oldRemoveDebuff = self.RemoveDebuff
		self.RemoveDebuff = function(self, name, ...)
			local r = oldRemoveDebuff and oldRemoveDebuff(self, name, ...) or nil
			if name == "buff_medal_prophesy" and self.inst ~= nil then
				local p = self.inst
				if p.medal_group_enabled ~= nil and p.medal_group_enabled["seer"] == true
					and not p:HasTag("infinite_prophecy") then
					p:AddTag("infinite_prophecy")
					p:PushEvent("refreshcrafting")
				end
			end
			return r
		end
	end)

```



### 变体演进：防卡两招RR (Mod 2987343164)
- **变体场景与切面**：收录来自工坊 Mod 2987343164 (`防卡两招RR`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2987343164)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:stackable

--[[AddComponentPostInit('stackable', function(Stackable)
    local Get = Stackable.Get
    function Stackable:Get(...)
        local instance = Get(self, ...)
        if instance.xt_stack_task then
            instance.xt_stack_task:Cancel()
            instance.xt_stack_task = nil
        end
        return instance
    end
end)]]

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world

    AddPrefabPostInit("world", function(inst)
        inst:DoPeriodicTask(5 * TUNING.TOTAL_DAY_TIME, CleanDelay)
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:researchlab2

AddPrefabPostInit("researchlab2", labTrashWidget)
AddPrefabPostInit("researchlab3", labTrashWidget)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:researchlab3
AddPrefabPostInit("researchlab2", labTrashWidget)
AddPrefabPostInit("researchlab3", labTrashWidget)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:growable
-- 长到最高级停止生长，常青树、多枝树只生长到第三级（第四级为枯萎状态）
AddComponentPostInit("growable",
	function(self)
		local old_StartGrowing = self.StartGrowing
		function self:StartGrowing(time)
			-- 若为常青树、多枝树等树，到第三阶段后立即停止生长
			if (table_key_exists(plantregrowth_evergreen_list, self.inst.prefab) and self.stage >= (#self.stages-1)) 
				or (self.inst.prefab == "lg_litchi_tree" and self.stage == #self.stages)
			then
				self:StopGrowing()
			else
				old_StartGrowing(self,time)
			end
		end
	end

```



### 变体演进：Mod 3480275368 (Mod 3480275368)
- **变体场景与切面**：收录来自工坊 Mod 3480275368 (`Mod 3480275368`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3480275368)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：简易血条(重构版) (Mod 3759757365)
- **变体场景与切面**：收录来自工坊 Mod 3759757365 (`简易血条(重构版)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3759757365)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:wx78
    if debug_enabled(config) then
        api.AddPrefabPostInit("wx78", function(inst)
            if TheWorld ~= nil and TheWorld.ismastersim then
                install_wx_spin_diagnostic_listener(inst, config)
            end
        end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:health
    end
    api.AddComponentPostInit("health", function(health)
        if TheWorld ~= nil and TheWorld.ismastersim then
            log_server_diagnostic_ready(config)
            install_health_listener(health, config, api)
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat

    api.AddComponentPostInit("combat", function(combat)
        if TheWorld ~= nil and TheWorld.ismastersim then
            log_server_diagnostic_ready(config)
            install_combat_listener(combat, config, api)
        end
    end)

```



### 变体演进：󰀱 从试金石处无限复活 󰀱 (Mod 2911745605)
- **变体场景与切面**：收录来自工坊 Mod 2911745605 (`󰀱 从试金石处无限复活 󰀱`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2911745605)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：赌狗模拟器 (Mod 2896628129)
- **变体场景与切面**：收录来自工坊 Mod 2896628129 (`赌狗模拟器`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2896628129)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:container

AddComponentPostInit("container", function(self)
	function self:RemoveSingleItemBySlot(slot)
		if slot and self.slots[slot] then
			local item = self.slots[slot]
			return self:RemoveItem(item)
		end
	end
end)

```



### 变体演进：简易血条 (Mod 3582815384)
- **变体场景与切面**：收录来自工坊 Mod 3582815384 (`简易血条`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3582815384)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:combat

AddComponentPostInit("combat", function(_, inst)
    if G.TheWorld ~= nil and G.TheWorld.ismastersim and inst.components.combat ~= nil then
        hookCombat(inst.components.combat)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:health

AddComponentPostInit("health", function(_, inst)
    if G.TheWorld ~= nil and G.TheWorld.ismastersim and inst.components.health ~= nil then
        hookHealth(inst.components.health)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
-- ======================================================
AddPrefabPostInit("world", function(world)
    if type(world) ~= "table" then return end
    world.initShbTask = world:DoPeriodicTask(G.FRAMES, function()
        -- 专用服务器没有本地玩家，也必须应用配置（服务端生成决策依赖它）
        if G.TheNet ~= nil and G.TheNet:IsDedicated() then
            SHB.ApplyConfig()
            world.initShbTask:Cancel()
            world.initShbTask = nil
            return
        end

        local player = SHB.GetPlayer()
        if player == nil or player.HUD == nil then return end

        SHB.ApplyConfig()

        -- 清理可能残留的伤害数字实体
        local leftover = G.SpawnPrefab("dyc_damagedisplay")
        if leftover ~= nil then
            leftover:Remove()
        end

        world.initShbTask:Cancel()
        world.initShbTask = nil
    end)
end)

```



### 变体演进：DJPaul (Mod 1462979419)
- **变体场景与切面**：收录来自工坊 Mod 1462979419 (`DJPaul`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1462979419)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：Creeps in the Deeps (Mod 2085762931)
- **变体场景与切面**：收录来自工坊 Mod 2085762931 (`Creeps in the Deeps`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2085762931)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:cave

AddPrefabPostInit("cave", function(inst)
if GLOBAL.TheWorld.ismastersim then  
inst:AddComponent("underwaterspawner")
end

end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:burnable

AddComponentPostInit("burnable", function(self)
------------------------
function self:Ignite(immediate, source, doer)
local map = GLOBAL.TheWorld.Map
local x, y, z = self.inst.Transform:GetWorldPosition()
local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
if ground == GROUND.UNDERWATER_SANDY or ground == GROUND.UNDERWATER_ROCKY or (ground == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end	
------------------------
    if not (self.burning or self.inst:HasTag("fireimmune")) then
        self:StopSmoldering()

        self.burning = true
        self.inst:ListenForEvent("death", OnKilled)
        self:SpawnFX(immediate)

        self.inst:PushEvent("onignite", {doer = doer})
        if self.onignite ~= nil then
            self.onignite(self.inst)
        end

        if self.inst.components.fueled ~= nil then
            self.inst.components.fueled:StartConsuming()
        end

        if self.inst.components.propagator ~= nil then
            self.inst.components.propagator:StartSpreading(source)
        end

        self:ExtendBurning()
    end
end	
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:builder

AddComponentPostInit("builder", function(self)

self.brainjelly	= false

function self:GetMoney(inventory)
	local money = 0

	local hasoincs,oincamount = inventory:Has("oinc", 0)
	local hasoinc10s,oinc10amount = inventory:Has("oinc10", 0)
	local hasoinc100s,oinc100amount = inventory:Has("oinc100", 0)
		
	money = oincamount + (oinc10amount *10)+ (oinc100amount *100)
	return money
end

function self:PayMoney(inventory,cost)
	local hasoincs,oincamount = inventory:Has("oinc", 0)
	local hasoinc10s,oinc10amount = inventory:Has("oinc10", 0)
	local hasoinc100s,oinc100amount = inventory:Has("oinc100", 0)
	local debt = cost

	local oincused = 0
	local oinc10used = 0
	local oinc100used = 0
	local oincgained = 0
	local oinc10gained = 0	
		while debt > 0 do
			while debt > 0 and oincamount > 0 do
				oincamount = oincamount - 1
				debt = debt - 1
				oincused = oincused +1
			end		
			if debt > 0 then
				if oinc10amount >0 then
					oinc10amount = oinc10amount -1
					oinc10used = oinc10used +1
					for i=1,10 do
						oincamount = oincamount + 1
						oincgained = oincgained + 1
					end
				elseif oinc100amount > 0 then
					oinc100amount = oinc100amount -1
					oinc100used = oinc100used +1
					for i=1,10 do
						oinc10amount = oinc10amount + 1
						oinc10gained = oinc10gained + 1
					end
				end
			end
		end
		local oincresult = oincgained - oincused
		if oincresult > 0 then
			for i=1,oincresult do
				local coin = SpawnPrefab("oinc")
				inventory:GiveItem( coin )	
			end
		end
		if oincresult < 0 then
			for i=1,math.abs(oincresult)do
				inventory:ConsumeByName("oinc", 1 )
			end
		end
		local oinc10result = oinc10gained - oinc10used
		if oinc10result > 0 then
			for i=1,oinc10result do
				local coin = SpawnPrefab("oinc10")
				inventory:GiveItem( coin )	
			end
		end
		if oinc10result < 0 then
			for i=1,math.abs(oinc10result)do
				inventory:ConsumeByName("oinc10", 1 )
			end
		end
		local oinc100result = 0 -oinc100used 
		if oinc100result < 0 then
			for i=1,math.abs(oinc100result)do
				inventory:ConsumeByName("oinc100", 1 )
			end
		end
end

function self:RemoveIngredients(ingredients, recname)
local recipe = GetValidRecipe(recname)
if recipe == nil then return false end

for i, v in ipairs(recipe.ingredients) do
if v.type == "oinc" and not self.freebuildmode then
self:PayMoney(self.inst.components.inventory,v.amount)
end
end

    for item, ents in pairs(ingredients) do
        for k,v in pairs(ents) do
            for i = 1, v do
			if item ~= "oinc" then			
                local item = self.inst.components.inventory:RemoveItem(k, false)

                -- If the item we're crafting with is a container,
                -- drop the contained items onto the ground.
                if item.components.container ~= nil then
                    item.components.container:DropEverything(self.inst:GetPosition())
                end

                item:Remove()
			end
            end
        end
    end

    local recipe = AllRecipes[recname]
    if recipe then
        for k,v in pairs(recipe.character_ingredients) do
            if v.type == GLOBAL.CHARACTER_INGREDIENT.HEALTH then
                --Don't die from crafting!
                local delta = math.min(math.max(0, self.inst.components.health.currenthealth - 1), v.amount)
                self.inst:PushEvent("consumehealthcost")
                self.inst.components.health:DoDelta(-delta, false, "builder", true, nil, true)
            elseif v.type == GLOBAL.CHARACTER_INGREDIENT.MAX_HEALTH then
                self.inst:PushEvent("consumehealthcost")
                self.inst.components.health:DeltaPenalty(v.amount)
            elseif v.type == GLOBAL.CHARACTER_INGREDIENT.SANITY then
                self.inst.components.sanity:DoDelta(-v.amount)
            elseif v.type == GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY then
                --[[
                    Because we don't have any maxsanity restoring items we want to be more careful
                    with how we remove max sanity. Because of that, this is not handled here.
                    Removal of sanity is actually managed by the entity that is created.
                    See maxwell's pet leash on spawn and pet on death functions for examples.
                --]]
            end
        end
    end
    self.inst:PushEvent("consumeingredients")
end

local function GiveOrDropItem(self, recipe, item, pt)
	if recipe.dropitem then
		local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
		local r = item:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
		item.Transform:SetPosition(pt.x + r * math.cos(angle), pt.y, pt.z - r * math.sin(angle))
		item.components.inventoryitem:OnDropped()
	else
	    self.inst.components.inventory:GiveItem(item, nil, pt)
	end
end

function self:DoBuild(recname, pt, rotation, skin)
    local recipe = GetValidRecipe(recname)
    if recipe ~= nil and (self:IsBuildBuffered(recname) or self:CanBuild(recname)) then
        if recipe.placer ~= nil and
            self.inst.components.rider ~= nil and
            self.inst.components.rider:IsRiding() then
            return false, "MOUNTED"
        elseif recipe.level.ORPHANAGE > 0 and (
                self.inst.components.petleash == nil or
                self.inst.components.petleash:IsFull() or
                self.inst.components.petleash:HasPetWithTag("critter")
            ) then
            return false, "HASPET"
        elseif recipe.manufactured and (
                self.current_prototyper == nil or
                not self.current_prototyper:IsValid() or
                self.current_prototyper.components.prototyper == nil or
                not CanPrototypeRecipe(recipe.level, self.current_prototyper.components.prototyper.trees)
            ) then
            -- manufacturing stations requires the current active protyper in order to work
            return false
        end

		local is_buffered_build = self.buffered_builds[recname] ~= nil
        if is_buffered_build then
            self.buffered_builds[recname] = nil
            self.inst.replica.builder:SetIsBuildBuffered(recname, false)
        end

        if self.inst:HasTag("hungrybuilder") and not self.inst.sg:HasStateTag("slowaction") then
            local t = GetTime()
            if self.last_hungry_build == nil or t > self.last_hungry_build + TUNING.HUNGRY_BUILDER_RESET_TIME then
                self.inst.components.hunger:DoDelta(TUNING.HUNGRY_BUILDER_DELTA)
                self.inst:PushEvent("hungrybuild")
            end
            self.last_hungry_build = t
        end

        self.inst:PushEvent("refreshcrafting")

        if recipe.manufactured then
			local materials = self:GetIngredients(recname)
			self:RemoveIngredients(materials, recname)
            -- its up to the prototyper to implement onactivate and handle spawning the prefab
            return true
        end

if self.inst and self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("brainjelly") then
if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses then
self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses:Use(1)
end
end	
        local prod = SpawnPrefab(recipe.product, recipe.chooseskin or skin, nil, self.inst.userid) or nil
        if prod ~= nil then
            pt = pt or self.inst:GetPosition()

            if prod.components.inventoryitem ~= nil then
                if self.inst.components.inventory ~= nil then
					local materials = self:GetIngredients(recname)

					local wetlevel = self:GetIngredientWetness(materials)
					if wetlevel > 0 and prod.components.inventoryitem ~= nil then
						prod.components.inventoryitem:InheritMoisture(wetlevel, self.inst:GetIsWet())
					end

					if prod.onPreBuilt ~= nil then
						prod:onPreBuilt(self.inst, materials, recipe)
					end

					self:RemoveIngredients(materials, recname)

                    --self.inst.components.inventory:GiveItem(prod)
                    self.inst:PushEvent("builditem", { item = prod, recipe = recipe, skin = skin, prototyper = self.current_prototyper })
                    if self.current_prototyper ~= nil and self.current_prototyper:IsValid() then
                        self.current_prototyper:PushEvent("builditem", { item = prod, recipe = recipe, skin = skin }) -- added this back for the gorge.
                    end
                    GLOBAL.ProfileStatsAdd("build_"..prod.prefab)

                    if prod.components.equippable ~= nil
						and not recipe.dropitem
                        and self.inst.components.inventory:GetEquippedItem(prod.components.equippable.equipslot) == nil
                        and not prod.components.equippable:IsRestricted(self.inst) then
                        if recipe.numtogive <= 1 then
                            --The item is equippable. Equip it.
                            self.inst.components.inventory:Equip(prod)
                        elseif prod.components.stackable ~= nil then
                            --The item is stackable. Just increase the stack size of the original item.
                            prod.components.stackable:SetStackSize(recipe.numtogive)
                            self.inst.components.inventory:Equip(prod)
                        else
                            --We still need to equip the original product that was spawned, so do that.
                            self.inst.components.inventory:Equip(prod)
                            --Now spawn in the rest of the items and give them to the player.
                            for i = 2, recipe.numtogive do
                                local addt_prod = SpawnPrefab(recipe.product)
                                self.inst.components.inventory:GiveItem(addt_prod, nil, pt)
                            end
                        end
                    elseif recipe.numtogive <= 1 then
                        --Only the original item is being received.
						GiveOrDropItem(self, recipe, prod, pt)
                    elseif prod.components.stackable ~= nil then
                        --The item is stackable. Just increase the stack size of the original item.
                        prod.components.stackable:SetStackSize(recipe.numtogive)
						GiveOrDropItem(self, recipe, prod, pt)
                    else
                        --We still need to give the player the original product that was spawned, so do that.
						GiveOrDropItem(self, recipe, prod, pt)
                        --Now spawn in the rest of the items and give them to the player.
                        for i = 2, recipe.numtogive do
                            local addt_prod = SpawnPrefab(recipe.product)
							GiveOrDropItem(self, recipe, addt_prod, pt)
                        end
                    end

                    GLOBAL.NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

                    if self.onBuild ~= nil then
                        self.onBuild(self.inst, prod)
                    end
                    prod:OnBuilt(self.inst)

                    return true
				else
					prod:Remove()
					prod = nil
                end
            else
				if not is_buffered_build then -- items that have intermediate build items (like statues)
					local materials = self:GetIngredients(recname)
					self:RemoveIngredients(materials, recname)
				end	

                local spawn_pos = pt

                -- If a non-inventoryitem recipe specifies dropitem, position the created object
                -- away from the builder so that they don't overlap.
                if recipe.dropitem then
                    local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
                    local r = prod:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
                    spawn_pos = Vector3(
                        spawn_pos.x + r * math.cos(angle),
                        spawn_pos.y,
                        spawn_pos.z - r * math.sin(angle)
                    )
                end

                prod.Transform:SetPosition(spawn_pos:Get())
                --V2C: or 0 check added for backward compatibility with mods that
                --     have not been updated to support placement rotation yet
                prod.Transform:SetRotation(rotation or 0)
                self.inst:PushEvent("buildstructure", { item = prod, recipe = recipe, skin = skin })
                prod:PushEvent("onbuilt", { builder = self.inst, pos = pt })
                GLOBAL.ProfileStatsAdd("build_"..prod.prefab)
                GLOBAL.NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

                if self.onBuild ~= nil then
                    self.onBuild(self.inst, prod)
                end

                prod:OnBuilt(self.inst)

                return true
            end
        end
    end
end

function self:CanBuild(recname)
if self:IsBuildBuffered(recname) then return true end
    local recipe = GetValidRecipe(recname)
    if recipe == nil then return false
---------------		
    elseif self.brainjelly then
        for i, v in ipairs(recipe.ingredients) do
            if not self.inst.components.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self.ingredientmod))) then
                return false
            end
        end
---------------				
		
    elseif not self.freebuildmode then
        for i, v in ipairs(recipe.ingredients) do
		
		if v.type == "oinc" then
 		if self:GetMoney(self.inst.components.inventory) >= v.amount then
 				return true
 		end
		end
            if not self.inst.components.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self.ingredientmod))) then
                return false
            end
        end
    end
    for i, v in ipairs(recipe.character_ingredients) do
        if not self:HasCharacterIngredient(v) then
            return false
        end
    end
    for i, v in ipairs(recipe.tech_ingredients) do
        if not self:HasTechIngredient(v) then
            return false
        end
    end
    return true
end

function self:MakeRecipeAtPoint(recipe, pt, rot, skin)
----------------------------------------------------------
if recipe.product == "sprinkler1" and  (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then return self:MakeRecipe(recipe, pt, rot, skin) end
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
    if recipe.placer ~= nil and
--        self:KnowsRecipe(recipe.name) and
        self:IsBuildBuffered(recipe.name) and
        GLOBAL.TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot) then
        self:MakeRecipe(recipe, pt, rot, skin)
    end
end
	
end)


AddClassPostConstruct("components/builder_replica", function(self)
function self:GetMoney(inventory)
	local money = 0

	local hasoincs,oincamount = inventory:Has("oinc", 0)
	local hasoinc10s,oinc10amount = inventory:Has("oinc10", 0)
	local hasoinc100s,oinc100amount = inventory:Has("oinc100", 0)
		
	money = oincamount + (oinc10amount *10)+ (oinc100amount *100)
	return money
end

function self:CanBuild(recipename)
if self:IsBuildBuffered(recipename) then return true end
    if self.inst.components.builder ~= nil then
        return self.inst.components.builder:CanBuild(recipename)
    elseif self.classified ~= nil then
        local recipe = GetValidRecipe(recipename)
        if recipe == nil then
            return false
        elseif not self.classified.isfreebuildmode:value() then
            for i, v in ipairs(recipe.ingredients) do
		if v.type == "oinc" then
 		if self:GetMoney(self.inst.replica.inventory) >= v.amount then
 				return true
 		end			
		end		
                if not self.inst.replica.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self:IngredientMod()))) then
                    return false
                end
            end
        end
        for i, v in ipairs(recipe.character_ingredients) do
            if not self:HasCharacterIngredient(v) then
                return false
            end
        end
        for i, v in ipairs(recipe.tech_ingredients) do
            if not self:HasTechIngredient(v) then
                return false
            end
        end
        return true
    else
        return false
    end
end

function self:CanBuildAtPoint(pt, recipe, rot)
if recipe.product == "sprinkler1" and  (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then return true end

if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
if(GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
    return GLOBAL.TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot)
end

end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:minimap
    --Adding layers info for the minimap. Tiles will work without it, but the minimap will got empty spaces.
    AddPrefabPostInit("minimap", function(inst)
        for _, data in pairs( minimapGroundProperties ) do
            local tile_type, layer_properties = unpack( data )
            print(layer_properties.name, GroundAtlas( layer_properties.name ))
            local handle = _G.MapLayerManager:CreateRenderLayer(
                tile_type,
                resolvefilepath(GroundAtlas( layer_properties.name )),
                resolvefilepath(GroundImage( layer_properties.name )),
                resolvefilepath(layer_properties.noise_texture)
            )
            inst.MiniMap:AddRenderLayer( handle )
        end
    end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:terraformer
    
    AddComponentPostInit("terraformer", function(self) --overload terraformer component
        
        local _Terraform = self.Terraform   
        self.Terraform = function(self, pt, spawnturf)
            local tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt:Get())
            if _Terraform(self, pt, spawnturf) then
                if addedTilesTurfInfo[tile] then
                    for k, lootinfo in pairs(addedTilesTurfInfo[tile]) do
                        local min = lootinfo[2] or 1
                        local max = lootinfo[3] or min
                        for i = 1, math.random(min, max) do
                            local loot = GLOBAL.SpawnPrefab(lootinfo[1])
                            loot.Transform:SetPosition(pt:Get())
                            if loot.Physics ~= nil then
                                local angle = math.random() * 2 * GLOBAL.PI
                                loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
                            end
                        end
                    end 
                end
            else
                return false
            end
            return true
        end
    end)

```



### 变体演进：Language (Mod 1115709310)
- **变体场景与切面**：收录来自工坊 Mod 1115709310 (`Language`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1115709310)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:forest
--全局经济数据
AddPrefabPostInit("forest", function(inst) GLOBAL.TheWorld:AddComponent("seworldstatus") end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:cave
AddPrefabPostInit("forest", function(inst) GLOBAL.TheWorld:AddComponent("seworldstatus") end)
AddPrefabPostInit("cave", function(inst) GLOBAL.TheWorld:AddComponent("seworldstatus") end)

```



### 变体演进：Title (Mod 2210996709)
- **变体场景与切面**：收录来自工坊 Mod 2210996709 (`Title`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 2210996709)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:walrus
-- 单独海象
AddPrefabPostInit("walrus", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	local function siwanggongao(inst, data)	--击杀
		inst:RemoveEventCallback("attacked", siwanggongao)
		TheNet:Announce("〖 "..GetInstName(inst).." 〗"..Language["被"].."【 "..GetAttacker(inst, data).." 】"..Language["击杀"])
	end
	
	local function siwang(inst)
		inst:ListenForEvent("attacked", siwanggongao)
	end
	
	if k_gonggao then
		inst:ListenForEvent("death", siwang)
	end
	
	if k_hx then
		inst:DoTaskInTime(.5, function(inst)
			TheNet:Announce("〖 "..GetInstName(inst).." 〗"..Language["出现"])	--出现，刷新了
		end)
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:world
-- 猎犬袭击
AddPrefabPostInit("world", function(inst)
	if not inst.ismastersim then
		return inst
	end
	--监听世界状态
	-- inst:WatchWorldState("startday", check_startday)	--转天时
	-- inst:ListenForEvent("moonphasechanged2", check_state)	--月相变化事件
	if k_yongye then
		inst:WatchWorldState("moonphase", check_state)	--月相，官方月晷现成的
	end
	
	if k_hound == 1 then
		-- 定义需要触发的时间点（单位：秒）
		local h_warning_times = { 150, 120, 90, 60, 45, 30, 0 }
		local houndWarned = {}  -- 记录每个时间点是否已经触发
		
		-- 初始化 houndWarned 表
		for _, v in ipairs(h_warning_times) do
			houndWarned[v] = false	--取到表里的时间标记为false，并存到houndWarned表
		end
		
		-- 确保每次袭击只触发一次公告
		local announcementLock = false
		
		inst:DoPeriodicTask(1, function(inst)
			local battimean = TheWorld:HasTag("porkland") and TheWorld.components.batted and TheWorld.components.batted:GetDebugString():match("Next attack in:%s*(%d+%.?%d*)s")
			local timeToAttack = TheWorld.components.hounded and TheWorld.components.hounded:GetTimeToAttack() or tonumber(battimean)
			local seconds = type(timeToAttack) == "number" and math.floor(timeToAttack)
			local atk_type = TheWorld:HasTag("cave") and Language["蠕虫"]
				or TheWorld:HasTag("island") and Language["鳄狗"]
				or TheWorld:HasTag("porkland") and Language["蝙蝠"]
				or Language["猎犬"]
			
			for _, warn_time in ipairs(h_warning_times) do
				if seconds and seconds == warn_time and not houndWarned[warn_time] then
					-- 发送公告
					if warn_time == 45 and not announcementLock then
						TheNet:Announce(atk_type..string.format(Language["将在x秒后"]..Language["袭击"], warn_time))
						announcementLock = true
					elseif warn_time > 45 then
						announcementLock = false
					end

					-- 让所有玩家角色说话
					for _, player in ipairs(AllPlayers) do
						if player.components.talker ~= nil then
							if warn_time ~= 45 then
								if warn_time == 0 then
									player.components.talker:Say(atk_type .. Language["袭击中"])
									-- print("打印猎犬消息：", warn_time)
								elseif warn_time ~= 150 then
									player.components.talker:Say(atk_type .. string.format(Language["将在x秒后"]..Language["袭击"], warn_time))
								elseif TheWorld.state.cycles < 10 and warn_time == 150 then
									player.components.talker:Say(atk_type .. string.format(Language["将在x秒后"]..Language["袭击"], warn_time))
								end
							end 
						end
					end

					houndWarned[warn_time] = true  -- 标记已触发
				elseif seconds and seconds > warn_time then
					houndWarned[warn_time] = false  -- 重置标记，以便下次攻击可以再次触发
				end
			end
		end)
	end
end)

--BOSS袭击列表
local KnBOSS_CONFIG = {
    deerclops = {	--巨鹿
		name = Language["巨鹿"],
        timer_name = "deerclops_timetoattack",
        BossAttackTime = {90, 60, 30},  -- 警告时间点（秒）
    },
    bearger = {		--熊大
		name = Language["熊獾"],
        timer_name = "bearger_timetospawn", 
        BossAttackTime = {90, 60, 30},
    },
    toadstool = {		--毒菌蟾蜍
		name = Language["毒菌蟾蜍"],
        timer_name = "toadstool_respawntask", 
		spawner_ann = false,
        BossAttackTime = nil,
    },
    malbatross = {		--邪天翁
		name = Language["邪天翁"],
        timer_name = "malbatross_timetospawn", 
		spawner_ann = false,
        BossAttackTime = nil,
    },
    mock_dragonfly = {		--妥协龙蝇
		name = Language["时令龙蝇"],
        timer_name = "mockfly_timetoattack", 
        BossAttackTime = {90, 60, 30},
    },
    mothergoose = {		--鹅妈妈
		name = Language["鹅妈妈"],
        timer_name = "mothergoose_timetoattack", 
        BossAttackTime = {90, 60, 30},
    },
    twister = {		--飓风海豹
		name = Language["飓风海豹"],
        timer_name = "twister_timetoattack", 
        BossAttackTime = {90, 60, 30},
    },
    -- 可添加更多BOSS，只要有TheWorld GetTimeLeft定时器什么都好说
}
-- TheWorld.components.malbatrossspawner:GetDebugString()

-- 初始化公告状态表，定义一个变量来存储公告是否已经发送
local knwarning_states = {}
for k, _ in pairs(KnBOSS_CONFIG) do
    knwarning_states[k] = {}
	local KBC = KnBOSS_CONFIG[k].BossAttackTime
	if KBC and KBC ~= nil then
		for _, i in ipairs(KBC) do
			knwarning_states[k][i] = false
		end
	end
end

-- 主检测函数
local LandTsAn, LandKrAn = false, false
local LandVolcano60, LandVolcano30 = false, false
local function KnCheckBossWarnings()
	-- 获取世界计时器组件
    local worldsettingstimer = TheWorld.components.worldsettingstimer
	local announce_msg = Language["将在x秒后"] .. Language["袭击"]
	
	if TheWorld:HasTag("island") then
		local TigersharkerTime = TheWorld.components.tigersharker:TimeUntilRespawn()
		local KrakenerTime = TheWorld.components.krakener:TimeUntilCanSpawn()
		local volcano = TheWorld.components.volcanomanager and TheWorld.components.volcanomanager:GetNumSegmentsUntilEruption() or nil
		
		if TigersharkerTime and type(TigersharkerTime) == "number" then
			TigersharkerTime = math.floor(TigersharkerTime)
			if TigersharkerTime == 0 and not LandTsAn then
				TheNet:Announce(Language["虎鲨"] .. Language["已重生"])
				LandTsAn = true
			elseif TigersharkerTime > 0 then
				LandTsAn = false
			end
		end
		
		if KrakenerTime and type(KrakenerTime) == "number" then
			KrakenerTime = math.floor(KrakenerTime)
			if KrakenerTime == 0 and not LandKrAn then
				TheNet:Announce(Language["海妖"] .. Language["已重生"])
				LandKrAn = true
			elseif KrakenerTime > 0 then
				LandKrAn = false
			end
		end
		
		if TheWorld.state.isdry and volcano and type(volcano) == "number" then
			local volcanonum = volcano * 30
			if volcano == 2 and not LandVolcano60 then
				TheNet:Announce(Language["火山"] .. string.format(Language["将在x秒后"], volcanonum) .. Language["爆发"])
				LandVolcano60 = true
			elseif volcano == 1 and not LandVolcano30 then
				TheNet:Announce(Language["火山"] .. string.format(Language["将在x秒后"], volcanonum) .. Language["爆发"])
				LandVolcano30 = true
			elseif volcano > 2 then
				LandVolcano60 = false
			elseif volcano > 1 then
				LandVolcano30 = false
			end
		end
	end
	
	-- 检查计时器是否存在
    if not worldsettingstimer then
		return
	end

	--获取表KnBOSS_CONFIG键，例如n=deerclops
    for k, n in pairs(KnBOSS_CONFIG) do
		-- 获取定时器的剩余时间
        local timetoattack = worldsettingstimer:GetTimeLeft(n.timer_name)
        
        if timetoattack and type(timetoattack) == "number" then	--定时器不为nil时
			timetoattack = math.floor(timetoattack)
			if n.BossAttackTime ~= nil then
				for _, i in ipairs(n.BossAttackTime) do	--获取n.BossAttackTime表的设定公告时间
					--当定时器timetoattack <= i 则发送公告，例如 i = 60秒
					if timetoattack <= i and not knwarning_states[k][i] then
						TheNet:Announce(n.name .. string.format(announce_msg, i))
						knwarning_states[k][i] = true	--标记公告已发送
					elseif timetoattack > i then	--如果定时器时间都大于BossAttackTime表里的，那么初始化公告；
						knwarning_states[k][i] = false
					end
				end
			else
				if timetoattack < 1 and not spawner_ann then
					announce_msg = Language["已重生"]
					TheNet:Announce(n.name .. announce_msg)
					spawner_ann = true
				elseif timetoattack > 0 then
					spawner_ann = false
				end
			end
        end
    end
end

-- 在游戏启动时注册一个周期性的任务来检查
AddSimPostInit(function()
	if not TheWorld.ismastersim then
		return
	end
	if k_boss then
		TheWorld:DoPeriodicTask(1, KnCheckBossWarnings)
	end
end)

-- 仅对prefab里有worldsettingstimer定时器的
local BOSS_TIMERS = {
    antlion = {
        {
			name = Language["蚁狮"],
			TimerName = "rage",
			BossAttackTime = {30, 20, 10},
			text = Language["将在x秒后"],
			text2 = Language["地震"],
			-- custom_check = function(inst)  -- 可自定义条件
                -- return inst.components.health:GetPercent() < 0.5
            -- end,
		},
    },
    dragonfly_spawner = {
		{	
			name = Language["龙蝇"],
			TimerName = "regen_dragonfly",
			BossAttackTime = {10},
			text = Language["将在x秒后"],
			text2 = Language["重生"],
		},
    },
    -- 可以继续添加其他BOSS...
}

local dragonfly_spawner_ref = nil
-- 通用BOSS计时器监听函数
local function SetupBossTimerListener(prefab)
    AddPrefabPostInit(prefab, function(inst)
	
		if not TheWorld.ismastersim then
            return inst
        end
	
        if not inst.components.worldsettingstimer or not BOSS_TIMERS[prefab] then
            return
        end
		
		local timer = inst.components.worldsettingstimer
		dragonfly_spawner_ref = inst
		
		-- 初始化 announced 表（如果不存在）
        for _, v in ipairs(BOSS_TIMERS[prefab]) do
            if v.BossAttackTime and not v.announced then
                v.announced = {}  --添加 announced 表作为标记是否已公告
            end
        end
		
        inst:DoPeriodicTask(1, function()
            for _, v in ipairs(BOSS_TIMERS[prefab]) do
				local PrefabName = v.name
				local timer_name = v.TimerName	-- 计时器名称
				local custom_text = v.text	-- 自定义文案
				local custom_text2 = v.text2	-- 自定义文案
				local time_atk = v.BossAttackTime	-- 公告时间
				
                local time_left = timer:GetTimeLeft(timer_name)
				
				if time_left and type(time_left) == "number" then  -- 新增检查
					time_left = math.floor(time_left)
					
					for _, i in ipairs(time_atk) do
						if time_left == i and not v.announced[i] then
							TheNet:Announce(PrefabName..string.format(custom_text, time_left) .. custom_text2)
							v.announced[i] = true  -- 标记已触发
						elseif time_left > i then	--当定时器大于表里的重置标记
							v.announced[i] = false
						end
					end
                end
            end
        end)
    end)
end

-- 为所有BOSS注册监听
if k_boss then
	for k, _ in pairs(BOSS_TIMERS) do
		SetupBossTimerListener(k)
	end
end
-- BOSS 袭击END

-- 【 控制台查BOSS刷新时间，c_kanboss() 或 c_kanboss("deerclops") 】volcano_altar
local function ckbosstime(boss_key)
	
	--获取世界计时器组件
    local worldsettingstimer = TheWorld.components.worldsettingstimer
	-- print(TheWorld.components.worldsettingstimer:GetTimeLeft(""))	--:TimerExists true
	-- TheWorld.net.components.beargerspawner:GetDebugString()
    
    local function announce_boss_time(boss_data)
        local timetoattack = worldsettingstimer:GetTimeLeft(boss_data.timer_name)
		local IsPaused = worldsettingstimer:IsPaused(boss_data.timer_name) and Language["计时已暂停"] or ""
		
        if timetoattack and type(timetoattack) == "number" then
            -- local msg = timetoattack >= TUNING.TOTAL_DAY_TIME / 2 and "( " .. string.format("%0.2f", timetoattack / TUNING.TOTAL_DAY_TIME) .. Language["天"] .. " ) " or ""
            TheNet:Announce(boss_data.name .. Language["将在"] .. formatTime(timetoattack) .. formatDay(timetoattack) .. Language["出现"] .. IsPaused)
        else
            TheNet:Announce(boss_data.name .. Language["无计时器"])
        end
    end

    if boss_key then
		local key_volcano = TheWorld.components.volcanomanager and TheWorld.components.volcanomanager:GetNumSegmentsUntilEruption() or nil
        -- 有参数时，只公告指定的BOSS
		if KnBOSS_CONFIG[boss_key] then		--执行世界计时器表
			local boss_data = KnBOSS_CONFIG[boss_key]
			announce_boss_time(boss_data)
		elseif BOSS_TIMERS[boss_key] then	--执行prefab表
			local inst = TheSim:FindFirstEntityWithTag(boss_key)
			if not inst then	--当计时器实体与实际实体不一致时，直接获取AddPrefabPostInit缓存
				inst = dragonfly_spawner_ref
			end
            if inst and inst.components.worldsettingstimer then
                for _, i_data in ipairs(BOSS_TIMERS[boss_key]) do
					if i_data.TimerName == "rage" and not Antlion_IsSpawn then break end
                    local time_left = inst.components.worldsettingstimer:GetTimeLeft(i_data.TimerName)
                    if time_left and type(time_left) == "number" then
						local time_left = math.floor(time_left)
						TheNet:Announce(i_data.name .. Language["将在"] .. formatTime(time_left) .. formatDay(time_left) .. i_data.text2)
                    end
                end
			else
				TheNet:Announce(boss_key .. Language["无计时器"])
            end
		elseif TheWorld:HasTag("island") then	-- 参数是海难世界的
			local land_boss
			local LandBossName = ""
			if boss_key == "tigershark" then
				land_boss = TheWorld.components.tigersharker:TimeUntilRespawn()
				LandBossName = Language["虎鲨"]
			end
			if boss_key == "kraken" then
				land_boss = TheWorld.components.krakener:TimeUntilCanSpawn()
				LandBossName = Language["海妖"]
			end
			if land_boss and type(land_boss) == "number" and land_boss >= 1 then
				local land_boss = math.floor(land_boss)
				TheNet:Announce(LandBossName .. Language["将在"] .. formatTime(land_boss) .. formatDay(land_boss) .. Language["重生"])
			elseif land_boss <= 0 then
				TheNet:Announce(LandBossName .. Language["已重生"])
			else
				TheNet:Announce(LandBossName .. Language["无计时器"])
			end
			if boss_key == "volcano" and TheWorld.state.isdry and key_volcano and type(key_volcano) == "number" and key_volcano > 2 then
				key_volcano = key_volcano *30
				TheNet:Announce(Language["火山"] .. Language["将在"] .. formatTime(key_volcano) .. formatDay(key_volcano) .. Language["爆发"])
			else
				TheNet:Announce(Language["火山"] .. Language["无计时器"])
			end
		elseif boss_key == "hound" then	-- 参数是猎犬
			local battime = TheWorld:HasTag("porkland") and TheWorld.components.batted and TheWorld.components.batted:GetDebugString():match("Next attack in:%s*(%d+%.?%d*)s")
			local HoundAt = TheWorld.components.hounded and TheWorld.components.hounded:GetTimeToAttack() or tonumber(battime)
			local HoundType = TheWorld:HasTag("cave") and Language["蠕虫"]
				or TheWorld:HasTag("island") and Language["鳄狗"]
				or TheWorld:HasTag("porkland") and Language["蝙蝠"]
				or Language["猎犬"]
			if HoundAt and type(HoundAt) == "number" then
				local HoundAt = math.floor(HoundAt)
				TheNet:Announce(HoundType .. Language["将在"] .. formatTime(HoundAt) .. formatDay(HoundAt) .. Language["袭击"])
			else
				TheNet:Announce(HoundType .. Language["无计时器"])
			end
		else
			TheNet:Announce("c_kanboss(" .. "\"" ..boss_key.. "\"" .. ") * 当前世界无 ".. boss_key .." 计时器 或者 传入的参数有误 *")
            return
        end
    else	-- 无参数时
		-- 海难的
		local function LandBossQuery (timer, name)
			if timer and type(timer) == "number" and timer >= 1 then
				timer = math.floor(timer)
				TheNet:Announce(name .. Language["将在"] .. formatTime(timer) .. formatDay(timer) .. Language["重生"])
			elseif timer <= 0 then
				TheNet:Announce(name .. Language["已重生"])
			end
		end
		if TheWorld:HasTag("island") then
			local LandTs = TheWorld.components.tigersharker:TimeUntilRespawn()
			local LandKr = TheWorld.components.krakener:TimeUntilCanSpawn()
			local c_volcano = TheWorld.components.volcanomanager:GetNumSegmentsUntilEruption()
			
			LandBossQuery (LandTs, Language["虎鲨"])
			LandBossQuery (LandKr, Language["海妖"])
			if TheWorld.state.isdry and c_volcano and type(c_volcano) == "number" and c_volcano > 2 then
				c_volcano = c_volcano *30
				TheNet:Announce(Language["火山"] .. Language["将在"] .. formatTime(c_volcano) .. formatDay(c_volcano) .. Language["爆发"])
			end
		end
		-- 猎犬袭击时间
		if TheWorld:HasTag("porkland") and TheWorld.components.batted or TheWorld.components.hounded then
			local battime = TheWorld.components.batted and TheWorld.components.batted:GetDebugString():match("Next attack in:%s*(%d+%.?%d*)s")
			local HoundAt = TheWorld.components.hounded and TheWorld.components.hounded:GetTimeToAttack() or tonumber(battime)
			if HoundAt and type(HoundAt) == "number" then
				local HoundAt = math.floor(HoundAt)
				local HoundType = TheWorld:HasTag("cave") and Language["蠕虫"]
				or TheWorld:HasTag("island") and Language["鳄狗"]
				or TheWorld:HasTag("porkland") and Language["蝙蝠"]
				or Language["猎犬"]
				TheNet:Announce(HoundType .. Language["将在"] .. formatTime(HoundAt) .. formatDay(HoundAt) .. Language["袭击"])
			end
		end
		
        -- 公告表里全部有计时器的BOSS
        for k, v in pairs(KnBOSS_CONFIG) do	-- 世界定时器
			local kat_noval = worldsettingstimer:GetTimeLeft(v.timer_name)
			if kat_noval and type(kat_noval) == "number" then
				announce_boss_time(v)
			end
        end
		-- prefab 里的
		for prefab, _ in pairs(BOSS_TIMERS) do
			local inst = TheSim:FindFirstEntityWithTag(prefab)
            
			if not inst then
				inst = dragonfly_spawner_ref
			end
			
            if inst and inst.components.worldsettingstimer then
                for _, i_data in ipairs(BOSS_TIMERS[prefab]) do
					if i_data.TimerName == "rage" and not Antlion_IsSpawn then break end	-- 蚁狮不存在时跳出循环
                    local time_left = inst.components.worldsettingstimer:GetTimeLeft(i_data.TimerName)
                    if time_left and type(time_left) == "number" then
						local time_left = math.floor(time_left)
						TheNet:Announce(i_data.name .. Language["将在"] .. formatTime(time_left) .. formatDay(time_left) .. i_data.text2)
                    end
                end
            end
        end
    end
end

--GLOBAL.rawset(GLOBAL, "c_boss", Fn)
AddModRPCHandler("k_bossRPC", "k_btname", function(player, bossname)	--响应RPC函数的第一个参数必须是player
	local playerneme = player:GetDisplayName() or player
	local boss_name = ""
	if bossname then
		boss_name = bossname
	end
	if boss_name == "dragonfly_spawner" then
		boss_name = "dragonfly"
	end
	--TheNet:Announce(playerneme .. " 在本地的 控制台 执行了 c_kanboss(" .. "\"" .. boss_name .. "\"" .. ")")
	ckbosstime(bossname)
end)

GLOBAL.rawset(GLOBAL, "c_kanboss", function(bossname)	--将全局变量 c_kanboss 注册到控制台
-- GLOBAL.c_kanboss = function(bossname)
	if bossname and bossname == "dragonfly" then
		bossname = "dragonfly_spawner"
	end
	-- if dragonfly_spawner_ref then
        -- local time_left = dragonfly_spawner_ref.components.worldsettingstimer:GetTimeLeft("regen_dragonfly")
	-- end
	if TheNet:GetIsClient() then
		SendModRPCToServer(GetModRPC("k_bossRPC", "k_btname"), bossname)	--如果是客机执行，会通过RPC传到服务器执行公告
	else
		ckbosstime(bossname)
	end
end)
-- 【控制台查询 END】

--血量成长
if GetModConfigData("M_XLup") then
    AddComponentPostInit("health", function(self)
		if not TheWorld.ismastersim then
            return self
        end
	
		local xLuplv = type(GetModConfigData("M_XLup")) == "number" and GetModConfigData("M_XLup") > 0 and GetModConfigData("M_XLup") or 1
		local knSetMaxHealth = self.SetMaxHealth
		local knday = TheWorld.state.cycles
		local hpdata = string.format("%0.6f", knday / 70 * xLuplv)	--游戏天数 / 一年天数 * 成长值
		--local hpdata = string.sub(kndata, 1, 8)		--截取前1~8个字符串
		
		self.SetMaxHealth = function(self, amount)
			local inst = self.inst
			local set_amount
		
			if inst:HasTag("player") then
				return knSetMaxHealth(self, amount)
			end
			
			-- --if (inst:HasTag("epic") or inst:HasTag("shadowchesspiece") or inst:HasTag("crabking")) then	--BOSS成长倍率，一般BOSS都有epic标签
			-- return knSetMaxHealth(self, inst._set_health * hpdata)
			if not inst.kn_hpup then
				inst.kn_hpup = 0
			end
			
			if inst.kn_hpup >= 1 then
				if inst._set_health == nil then
					inst._set_health = amount	-- 将第一次变动的数据储存起来，以防后续变动导致无限增大
				end
				inst.kn_hpup = inst.kn_hpup + 1
				set_amount = inst._set_health * hpdata
				if set_amount < inst._set_health then
					set_amount = inst._set_health + set_amount	-- 当低于原血量则加上原血量
				end
				return knSetMaxHealth(self, set_amount)
			else	-- 第一次设置
				inst.kn_hpup = inst.kn_hpup + 1
				set_amount = amount * hpdata	-- 血量 * 成长值
				if set_amount < amount then		-- 当得出的血量低于原血量，那么就加上原血量
					set_amount = amount + set_amount
				end
				return knSetMaxHealth(self, set_amount)
			end
		end
	end)
end

--攻击成长
if GetModConfigData("M_atkup") then
    AddComponentPostInit("combat", function(self)
		if not TheWorld.ismastersim then
            return self
        end
		
		local atkSetDefaultDamage = self.SetDefaultDamage
		local atkuplv = type(GetModConfigData("M_atkup")) == "number" and GetModConfigData("M_atkup") > 0 and GetModConfigData("M_atkup") or 1
		local atkday = _G.TheWorld.state.cycles
		local atkdata = string.format("%0.2f", atkday / 70 * atkuplv)	-- 游戏天数除去一年天数
		
		self.SetDefaultDamage = function(self, damage)
			local inst = self.inst
			local set_combat
		
			if inst:HasTag("player") then	-- 玩家攻击不成长
				return atkSetDefaultDamage(self, damage)
			end
			
			if not inst.kn_dmgup then
				inst.kn_dmgup = 0
			end
			
			if inst.kn_dmgup >= 1 then
				-- 保存第一次变化的数据
				if inst._set_combat == nil then
					inst._set_combat = damage
				end
				
				inst.kn_dmgup = inst.kn_dmgup + 1
				set_combat = inst._set_combat * atkdata
				
				if set_combat < inst._set_combat then
					set_combat = inst._set_combat + set_combat	-- 当低于原数据则加上原数据
				end
				
				return atkSetDefaultDamage(self, set_combat)
			else	-- 第一次变化
				inst.kn_dmgup = inst.kn_dmgup + 1
				set_combat = damage * atkdata
				
				if set_combat < damage then
					set_combat = damage + set_combat
				end
				
				return atkSetDefaultDamage(self, set_combat)
			end
		end
	end)
end

local hplist = {
    -- 分组定义
    {prefab_table = {"bearger", "deerclops", "moose", "antlion", "twister", "tigershark", "moonmaw_dragonfly", "mock_dragonfly", "mothergoose"}, value = GetModConfigData("M_XueLiang")},
    {prefab_table = {"beequeen", "medal_beequeen"}, value = GetModConfigData("M_fhhp")},
    {prefab_table = {"toadstool", "toadstool_dark"}, value = GetModConfigData("M_hmhp")},
    {prefab_table = {"warg", "claywarg", "gingerbreadwarg"}, value = GetModConfigData("M_zuol")},
    {prefab_table = {"stalker_atrium", "stalker_forest", "stalker"}, value = GetModConfigData("M_ygbz")},
    {prefab_table = {"eyeofterror", "twinofterror1", "twinofterror2"}, value = GetModConfigData("M_teye")},
    {prefab_table = {"shadow_rook", "shadow_bishop", "shadow_knight"}, value = GetModConfigData("M_s_rbk")},
    {prefab_table = {"alterguardian_phase1", "alterguardian_phase2", "alterguardian_phase3"}, value = GetModConfigData("M_tiant")},
    {prefab_table = {"leif", "leif_sparse", "treeguard", "leif_palm", "leif_jungle", "jungletreeguard"}, value = GetModConfigData("M_shuj")},
    -- 其他组...
    
    -- 单独定义
    {prefab = "dragonfly", value = GetModConfigData("M_lyhp")},
    {prefab = "klaus", value = GetModConfigData("M_klshp")},
    {prefab = "malbatross", value = GetModConfigData("M_xtwhp")},
    {prefab = "minotaur", value = GetModConfigData("M_ygshhp")},

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:health
if GetModConfigData("M_XLup") then
    AddComponentPostInit("health", function(self)
		if not TheWorld.ismastersim then
            return self
        end
	
		local xLuplv = type(GetModConfigData("M_XLup")) == "number" and GetModConfigData("M_XLup") > 0 and GetModConfigData("M_XLup") or 1
		local knSetMaxHealth = self.SetMaxHealth
		local knday = TheWorld.state.cycles
		local hpdata = string.format("%0.6f", knday / 70 * xLuplv)	--游戏天数 / 一年天数 * 成长值
		--local hpdata = string.sub(kndata, 1, 8)		--截取前1~8个字符串
		
		self.SetMaxHealth = function(self, amount)
			local inst = self.inst
			local set_amount
		
			if inst:HasTag("player") then
				return knSetMaxHealth(self, amount)
			end
			
			-- --if (inst:HasTag("epic") or inst:HasTag("shadowchesspiece") or inst:HasTag("crabking")) then	--BOSS成长倍率，一般BOSS都有epic标签
			-- return knSetMaxHealth(self, inst._set_health * hpdata)
			if not inst.kn_hpup then
				inst.kn_hpup = 0
			end
			
			if inst.kn_hpup >= 1 then
				if inst._set_health == nil then
					inst._set_health = amount	-- 将第一次变动的数据储存起来，以防后续变动导致无限增大
				end
				inst.kn_hpup = inst.kn_hpup + 1
				set_amount = inst._set_health * hpdata
				if set_amount < inst._set_health then
					set_amount = inst._set_health + set_amount	-- 当低于原血量则加上原血量
				end
				return knSetMaxHealth(self, set_amount)
			else	-- 第一次设置
				inst.kn_hpup = inst.kn_hpup + 1
				set_amount = amount * hpdata	-- 血量 * 成长值
				if set_amount < amount then		-- 当得出的血量低于原血量，那么就加上原血量
					set_amount = amount + set_amount
				end
				return knSetMaxHealth(self, set_amount)
			end
		end
	end)
end

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:combat
if GetModConfigData("M_atkup") then
    AddComponentPostInit("combat", function(self)
		if not TheWorld.ismastersim then
            return self
        end
		
		local atkSetDefaultDamage = self.SetDefaultDamage
		local atkuplv = type(GetModConfigData("M_atkup")) == "number" and GetModConfigData("M_atkup") > 0 and GetModConfigData("M_atkup") or 1
		local atkday = _G.TheWorld.state.cycles
		local atkdata = string.format("%0.2f", atkday / 70 * atkuplv)	-- 游戏天数除去一年天数
		
		self.SetDefaultDamage = function(self, damage)
			local inst = self.inst
			local set_combat
		
			if inst:HasTag("player") then	-- 玩家攻击不成长
				return atkSetDefaultDamage(self, damage)
			end
			
			if not inst.kn_dmgup then
				inst.kn_dmgup = 0
			end
			
			if inst.kn_dmgup >= 1 then
				-- 保存第一次变化的数据
				if inst._set_combat == nil then
					inst._set_combat = damage
				end
				
				inst.kn_dmgup = inst.kn_dmgup + 1
				set_combat = inst._set_combat * atkdata
				
				if set_combat < inst._set_combat then
					set_combat = inst._set_combat + set_combat	-- 当低于原数据则加上原数据
				end
				
				return atkSetDefaultDamage(self, set_combat)
			else	-- 第一次变化
				inst.kn_dmgup = inst.kn_dmgup + 1
				set_combat = damage * atkdata
				
				if set_combat < damage then
					set_combat = damage + set_combat
				end
				
				return atkSetDefaultDamage(self, set_combat)
			end
		end
	end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:stinger
if GetModConfigData("g_haodanpao") then
	AddPrefabPostInit("stinger", function(inst)		-- 给蜂刺支持嚎弹炮
		inst:AddComponent("reloaditem")
		inst:AddTag("blowpipeammo")
		--inst:AddTag("stinger_ammo")
		inst:AddTag("reloaditem_ammo")
	end)

```



### 变体演进：\233\163\142\230\187\154\232\141\137\230\183\152\230\177\176\232\181\155 (Mod 3112231607)
- **变体场景与切面**：收录来自工坊 Mod 3112231607 (`\233\163\142\230\187\154\232\141\137\230\183\152\230\177\176\232\181\155`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3112231607)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```



### 变体演进：王国-核心包 (Mod 1869928570)
- **变体场景与切面**：收录来自工坊 Mod 1869928570 (`王国-核心包`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1869928570)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world
-- end
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    inst:ListenForEvent("entity_death", function(world, data)
        local victim = data.inst
        local afflicter = data.afflicter
        --print("让我看看谁嗝屁了",afflicter,victim)
        -- 存在死者和凶手，且凶手是自己的随从
        if victim and afflicter and afflicter:HasTag("oldfish_soldier") then
            -- 随从是否有主人
            if afflicter.components.follower and afflicter.components.follower:GetLeader() then
                local exp = CalculateExp(victim)
                if exp > 0 then
                    afflicter.components.follower:GetLeader():PushEvent("showExp", { value = exp })
                end
            end
        end
    end)
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:abigail

-- AddPrefabPostInit("abigail", function(inst)
--     inst:ListenForEvent("killed", function(inst, data)
--         for i, v in ipairs(STRINGS.EXP_TYPE) do
--             if data.victim.prefab == v.name then
--                 if inst.components.follower ~= nil and inst.components.follower:GetLeader() ~= nil then
--                     inst.components.follower:GetLeader():PushEvent("showExp", { value = v.value })
--                     break
--                 end
--             end
--         end
--     end)
-- end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddComponentPostInit:container

AddComponentPostInit("container", function(self)
    local oldgiveitem = self.GiveItem
    function self:GiveItem(item, slot, ...)
        if item ~= nil and item.prefab == "oldfish_manypeople_sign" then
            if slot ~= nil then
                if self.inst and self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetGrandOwner() ~= nil then
                    item:PushEvent("continueFollow", { player = self.inst.components.inventoryitem:GetGrandOwner() })
                else
                    item:PushEvent("stopFollow")
                end
            end
        end
        return oldgiveitem(self, item, slot, ...)
    end
end)

```



### 变体演进：Title (Mod 3473582283)
- **变体场景与切面**：收录来自工坊 Mod 3473582283 (`Title`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3473582283)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:skilltreeupdater
--if GLOBAL.KnownModIndex:IsModEnabled("workshop-1909182187") == true then--删掉这一句可以兼容自用勋章，这里为了不报错--这个本地居然没有，害惨我力
AddComponentPostInit("skilltreeupdater", extraskillcheck)
--[[AddPlayerPostInit(function(inst) 
	if inst.components.skilltreeupdater == nil then
		inst:AddComponent("skilltreeupdater")
	end
	local oldisactivated = inst.components.skilltreeupdater.IsActivated
	inst.components.skilltreeupdater.IsActivated = function(_self,_skill)
		if oldisactivated(_self,_skill) ~= true 
		then
		--print("brandnew")
			for i,v in pairs(skillmedaltab) do
				if checkcertificate(_self.inst,v.tag) == true
				and SKILLTREE_DEFS[v.skill][_skill] ~= nil
				then
					--print("step2")
					return true
				end
			end
			return false	
		else
			return oldisactivated(_self,_skill)
		end
	end
end)]]--

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:handy_certificate
------------------
AddPrefabPostInit("handy_certificate",function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	local oldonequip = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function(_inst,_owner,_from_ground)
		oldonequip(_inst,_owner,_from_ground)
		AddMedalComponent(_owner,"inspectaclesparticipant")--好用咱就用
		AddMedalComponent(_owner,"roseinspectableuser")
		AddMedalTag(_owner,"portableengineer")
		AddMedalTag(_owner,"inspectacleshatuser")
	end
	local oldonunequip = inst.components.equippable.onunequipfn
	inst.components.equippable.onunequipfn = function(_inst,_owner)
		oldonunequip(_inst,_owner)
		RemoveMedalComponent(_owner,"inspectaclesparticipant")
		RemoveMedalComponent(_owner,"roseinspectableuser")
		RemoveMedalTag(_owner,"portableengineer")
		RemoveMedalTag(_owner,"inspectacleshatuser")
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:merm_certificate
end)
AddPrefabPostInit("merm_certificate",function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	local oldonequip = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function(_inst,_owner,_from_ground)
		oldonequip(_inst,_owner,_from_ground)
		AddMedalTag(_owner,"merm_medal")
		AddMedalTag(_owner,SPELLTYPES.SHADOW_SWAMP_BOMB.."_spelluser")
		AddMedalTag(_owner,SPELLTYPES.LUNAR_SWAMP_BOMB.."_spelluser")
	end
	local oldonunequip = inst.components.equippable.onunequipfn
	inst.components.equippable.onunequipfn = function(_inst,_owner)
		oldonunequip(_inst,_owner)
		RemoveMedalTag(_owner,"merm_medal")
		RemoveMedalTag(_owner,SPELLTYPES.SHADOW_SWAMP_BOMB.."_spelluser")
		RemoveMedalTag(_owner,SPELLTYPES.LUNAR_SWAMP_BOMB.."_spelluser")
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:valkyrie_certificate
end)
AddPrefabPostInit("valkyrie_certificate",function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	local oldonequip = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function(_inst,_owner,_from_ground)
		oldonequip(_inst,_owner,_from_ground)
		AddMedalTag(_owner,"spear_lightning_upgradeuser")--好用咱就用,歌谱用不了，就不管了
		AddMedalTag(_owner,"wathgrithrshielduser")
		AddMedalTag(_owner,"valkyrie_medal")
		if _owner.prefab ~= "wathgrithr" then
			_owner.IsValidVictim = IsValidVictim
		end
	end
	local oldonunequip = inst.components.equippable.onunequipfn
	inst.components.equippable.onunequipfn = function(_inst,_owner)
		oldonunequip(_inst,_owner)
		RemoveMedalTag(_owner,"spear_lightning_upgradeuser")
		RemoveMedalTag(_owner,"wathgrithrshielduser")
		RemoveMedalTag(_owner,"valkyrie_medal")
		if _owner.prefab ~= "wathgrithr" then
			_owner.IsValidVictim = nil
		end
	end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:childlike_certificate
end)
AddPrefabPostInit("childlike_certificate",function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	local oldonequip = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function(_inst,_owner,_from_ground)
		oldonequip(_inst,_owner,_from_ground)
		AddMedalTag(_owner,"slingshotammocontaineruser")--好用咱就用
	end
	local oldonunequip = inst.components.equippable.onunequipfn
	inst.components.equippable.onunequipfn = function(_inst,_owner)
		oldonunequip(_inst,_owner)
		RemoveMedalTag(_owner,"slingshotammocontaineruser")
	end
end)

```



### 变体演进：快速传送与原地复活 | Fast Teleport & Instant Revive (Mod 3727304698)
- **变体场景与切面**：收录来自工坊 Mod 3727304698 (`快速传送与原地复活 | Fast Teleport & Instant Revive`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3727304698)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:world

AddPrefabPostInit("world", function(inst)
    print("[DST Shared Teleport] server_init registered by world prefab")
    if inst ~= nil and inst.ismastersim and inst.DoTaskInTime ~= nil then
        inst:DoTaskInTime(0, function(world)
            try_server_init("world prefab task", world)
        end)
    else
        try_server_init("world prefab", inst)
    end
end)

-- ----------------------------------------------------------------------------
-- 切面钩子：AddPrefabPostInit:skeleton
-- 1. 让死亡掉落的骨架在黑夜中发出清晰的微光（指引尸体位置并绝对防查理）
AddPrefabPostInit("skeleton", function(inst)
    -- 🚨 注意：这里绝对不能加 ismastersim 限制！
    -- C++ 底层光源必须在服务器（管逻辑防查理）和客户端（管画面渲染）同时初始化，玩家才能看到光圈
    if inst.Light == nil then
        inst.entity:AddLight()
    end
    
    inst.Light:Enable(true)
    inst.Light:SetRadius(4.5)     -- 辐射半径 4.5 码，范围非常清晰
    inst.Light:SetIntensity(0.8)  -- 中心亮度 0.8
    inst.Light:SetFalloff(0.45)   -- 完美的平滑衰减，让光线优雅地铺开
    
    inst.Light:SetColour(245/255, 165/255, 95/255) -- 温暖明亮的火光色
end)

```



### 变体演进：Korean Foods & Items (Warly seasoning compatible) (Mod 1736542280)
- **变体场景与切面**：收录来自工坊 Mod 1736542280 (`Korean Foods & Items (Warly seasoning compatible)`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 1736542280)
-- ============================================================================
local GLOBAL = GLOBAL

-- 暂无高频切面钩子
```

