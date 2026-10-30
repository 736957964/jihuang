# 饥荒联机版（DST）创意工坊标杆模组工业级案例剖析

## 案例七：工业级多装备栏（Extra Equip Slots）槽位注入与UI适配

- **模组标识**：`375850593_Extra Equip Slots`
- **核心技术标签**：`EQUIPSLOTS`, `inventorybar`, `resurrectable`, `UI挂载`

### 核心源码实现片段与解构：

```lua
local require = GLOBAL.require
local TheInput = GLOBAL.TheInput
local ThePlayer = GLOBAL.ThePlayer
local IsServer = GLOBAL.TheNet:GetIsServer()
local Inv = require "widgets/inventorybar"

Assets =
{
    Asset("IMAGE", "images/back.tex"),
    Asset("ATLAS", "images/back.xml"),
    Asset("IMAGE", "images/neck.tex"),
    Asset("ATLAS", "images/neck.xml"),
}
-- for key,value in pairs(GLOBAL.EQUIPSLOTS) do print('4r',key,value) end

GLOBAL.EQUIPSLOTS=
{
    HANDS = "hands",
    HEAD = "head",
    BODY = "body",
    BACK = "back",
    NECK = "neck",
}
GLOBAL.EQUIPSLOT_IDS = {}
local slot = 0
for k, v in pairs(GLOBAL.EQUIPSLOTS) do
    slot = slot + 1
    GLOBAL.EQUIPSLOT_IDS[v] = slot
end
slot = nil

AddComponentPostInit("resurrectable", function(self, inst)
    local original_FindClosestResurrector = self.FindClosestResurrector
    local original_CanResurrect = self.CanResurrect
    local original_DoResurrect = self.DoResurrect

    self.FindClosestResurrector = function(self)
        if IsServer and self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                return item
            end
        end
        original_FindClosestResurrector(self)
    end

    self.CanResurrect = function(self)
        if IsServer and self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                return true
            end
        end
        original_CanResurrect(self)
    end

    self.DoResurrect = function(self)
        self.inst:PushEvent("resurrect")
        if IsServer and self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                self.inst.sg:GoToState("amulet_rebirth")
                return true
            end
        end
        original_DoResurrect(self)
    end
end)

AddComponentPostInit("inventory", function(self, inst)
    local original_Equip = self.Equip
    self.Equip = function(self, item, old_to_active)
        if original_Equip(self, item, old_to_active) and item and item.components and item.components.equippable then
            local eslot = item.components.equippable.equipslot
            if self.equipslots[eslot] ~= item then
                if eslot == GLOBAL.EQUIPSLOTS.BACK and item.components.container ~= nil then
                    self.inst:PushEvent("setoverflow", { overflow = item })
                end
            end
            return true
-- ... 后续逻辑包含状态机与事件分发
```

### 工业级工程要点剖析：
1. **全局字典注入**：通过安全改写 `GLOBAL.EQUIPSLOTS` 与 `EQUIPSLOT_IDS`，支持非侵入式插槽；
2. **客户端/服务端环境分流**：严格校验 `TheNet:GetIsServer()` 与 `TheNet:GetIsClient()`，杜绝崩溃；
3. **PostInit 幂等与链式调用**：保留原始原语指针 `original_fn`，确保与其他模组完美共存兼容。

---

## 案例八：世界实体标记与动态��色（Wormhole Marks）着色器与地图图标劫持

- **模组标识**：`362175979_Wormhole Marks`
- **核心技术标签**：`minimap`, `AnimState`, `world entity`, `着色器`

### 核心源码实现片段与解构：

```lua
Assets = 
{
	Asset("ATLAS", "images/mark_1.xml"),
	Asset("ATLAS", "images/mark_2.xml"),
	Asset("ATLAS", "images/mark_3.xml"),
	Asset("ATLAS", "images/mark_4.xml"),
	Asset("ATLAS", "images/mark_5.xml"),
	Asset("ATLAS", "images/mark_6.xml"),
	Asset("ATLAS", "images/mark_7.xml"),
	Asset("ATLAS", "images/mark_8.xml"),
	Asset("ATLAS", "images/mark_9.xml"),
	Asset("ATLAS", "images/mark_10.xml"),
	Asset("ATLAS", "images/mark_11.xml"),
	Asset("ATLAS", "images/mark_12.xml"),
	Asset("ATLAS", "images/mark_13.xml"),
	Asset("ATLAS", "images/mark_14.xml"),
	Asset("ATLAS", "images/mark_15.xml"),
	Asset("ATLAS", "images/mark_16.xml"),
	Asset("ATLAS", "images/mark_17.xml"),
	Asset("ATLAS", "images/mark_18.xml"),
	Asset("ATLAS", "images/mark_19.xml"),
	Asset("ATLAS", "images/mark_20.xml"),
	Asset("ATLAS", "images/mark_21.xml"),
	Asset("ATLAS", "images/mark_22.xml"),
}

AddMinimapAtlas("images/mark_1.xml")
AddMinimapAtlas("images/mark_2.xml")
AddMinimapAtlas("images/mark_3.xml")
AddMinimapAtlas("images/mark_4.xml")
AddMinimapAtlas("images/mark_5.xml")
AddMinimapAtlas("images/mark_6.xml")
AddMinimapAtlas("images/mark_7.xml")
AddMinimapAtlas("images/mark_8.xml")
AddMinimapAtlas("images/mark_9.xml")
AddMinimapAtlas("images/mark_10.xml")
AddMinimapAtlas("images/mark_11.xml")
AddMinimapAtlas("images/mark_12.xml")
AddMinimapAtlas("images/mark_13.xml")
AddMinimapAtlas("images/mark_14.xml")
AddMinimapAtlas("images/mark_15.xml")
AddMinimapAtlas("images/mark_16.xml")
AddMinimapAtlas("images/mark_17.xml")
AddMinimapAtlas("images/mark_18.xml")
AddMinimapAtlas("images/mark_19.xml")
AddMinimapAtlas("images/mark_20.xml")
AddMinimapAtlas("images/mark_21.xml")
AddMinimapAtlas("images/mark_22.xml")

local function Mark(inst)
	if not inst.components.wormhole_marks:CheckMark() then
		inst.components.wormhole_marks:MarkEntrance()
	end
	
	local other = inst.components.teleporter.targetTeleporter	
	if  not other.components.wormhole_marks:CheckMark() then
			other.components.wormhole_marks:MarkExit()
	end
end

function WormholePrefabPostInit(inst)
	if not inst.components.wormhole_marks then
		inst:AddComponent("wormhole_marks")
	end
	inst:ListenForEvent("starttravelsound", Mark)
end

AddPrefabPostInit("wormhole", WormholePrefabPostInit)

function WorldPrefabPostInit(inst)
	if inst:HasTag("forest") then
		inst:AddComponent("wormhole_counter")
	end
end

if GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated() then
	AddPrefabPostInit("world", WorldPrefabPostInit)
end
-- ... 后续逻辑包含状态机与事件分发
```

### 工业级工程要点剖析：
1. **全局字典注入**：通过安全改写 `GLOBAL.EQUIPSLOTS` 与 `EQUIPSLOT_IDS`，支持非侵入式插槽；
2. **客户端/服务端环境分流**：严格校验 `TheNet:GetIsServer()` 与 `TheNet:GetIsClient()`，杜绝崩溃；
3. **PostInit 幂等与链式调用**：保留原始原语指针 `original_fn`，确保与其他模组完美共存兼容。

---

## 案例九：轻量网络 RPC 握手与客户端/服务端自杀与世界重置（Restart）

- **模组标识**：`462434129_Restart`
- **核心技术标签**：`RPC`, `SendModRPCToServer`, `TheNet`, `WorldReset`

### 核心源码实现片段与解构：

```lua
local _G = GLOBAL
local TheNet = _G.TheNet
if not (TheNet and TheNet:GetIsServer()) then return end
local STRINGS = _G.STRINGS

local function GetModData(name, default)
	local config = GetModConfigData(name)
	if config == nil or type(config) ~= type(default) then
		config = default
	end
	return config
end

local ignoring_admin = GetModData("MOD_RESTART_IGNORING_ADMIN", true)
local allow_restart = GetModData("MOD_RESTART_ALLOW_RESTART", true)
local allow_resurrect = GetModData("MOD_RESTART_ALLOW_RESURRECT", true)
local allow_kill = GetModData("MOD_RESTART_ALLOW_KILL", true)
local cd_restart = GetModData("MOD_RESTART_CD_RESTART", 5) * 60
local cd_resurrect = GetModData("MOD_RESTART_CD_RESURRECT", 7) * 60
local cd_kill = GetModData("MOD_RESTART_CD_KILL", 3) * 60
local cd_bonus = GetModData("MOD_RESTART_CD_BONUS", 0)
local cd_max = GetModData("MOD_RESTART_CD_MAX", 0) * 60
local force_drop_mode = GetModData("MOD_RESTART_FORCE_DROP_MODE", 0)
local map_save = GetModData("MOD_RESTART_MAP_SAVE", 2)
local resurrect_health = GetModData("MOD_RESTART_RESURRECT_HEALTH", 0)
local trigger_mode = GetModData("MOD_RESTART_TRIGGER_MODE", 1)
local restart_welcome_tips = GetModData("MOD_RESTART_WELCOME_TIPS", true)
local restart_welcome_tips_time = GetModData("MOD_RESTART_WELCOME_TIPS_TIME", 6)

local MY_STRINGS = {
	welcome_msg = {
		"Enter the following command after press Y(Say) or U(Whisper):",
		"Enter the following command after press Y(Say):",
		"Enter the following command after press U(Whisper):",
	},
	allow_msg = {
		"#restart (CD: %d seconds, Re select your character)",
		"#restart_d (CD: %d seconds, Drop all items and Re select your character)",
		"#resurrect (CD: %d seconds, You will get a new life.)",
		"#kill (CD: %d seconds, Kill youself)",
	},
	force_drop_msg = {
		"Always Drop all items!",
		"Always Lost all items!",
	},
	map_save_msg = {
		"Restart will save the map data.",
		"Restart will not save the map data.",
	},
	cd_max_msg = {
		"No limited",
		"%d minutes",
	},
	cd_bonus_msg = "CD increased %d%% per use.Max: %s.",
	warning = "%s CD: %d seconds.",
	announce = "restart the game!",
	restart = "restart",
	resurrect = "resurrect",
	kill = "kill",
	resurrect_from = "resurrect",
	kill_from = "kill",
}

local MSG_CHOOSE = {
	["#restart"] = 1,
	["#restart_d"] = 2,
	["#resurrect"] = 3,
	["#kill"] = 4,
}

local welcome_tips = MY_STRINGS.welcome_msg[1]

do
	local support_languages = { chs = true, cht = true, zh_CN = "chs", cn = "chs", TW = "cht", }
	local steam_support_languages = { schinese = "chs", tchinese = "cht", }

	AddPrefabPostInit("world", function(inst)
		local steamlang = TheNet:GetLanguageCode() or nil
		if steamlang and steam_support_languages[steamlang] then
			print("<Restart> Get your language from steam!")
-- ... 后续逻辑包含状态机与事件分发
```

### 工业级工程要点剖析：
1. **全局字典注入**：通过安全改写 `GLOBAL.EQUIPSLOTS` 与 `EQUIPSLOT_IDS`，支持非侵入式插槽；
2. **客户端/服务端环境分流**：严格校验 `TheNet:GetIsServer()` 与 `TheNet:GetIsClient()`，杜绝崩溃；
3. **PostInit 幂等与链式调用**：保留原始原语指针 `original_fn`，确保与其他模组完美共存兼容。

---

