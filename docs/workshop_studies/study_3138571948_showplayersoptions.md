# 饥荒创意工坊研读报告：SHOWPLAYERSOPTIONS

- **模组标识**：`3138571948`
- **作者**：clearlove, rezecib, Sarcen
- **版本**：2.4.6
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：14 个 Lua 文件 / 共 3142 行；网络变量 7 处；RPC 1 处；注入钩子 22 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/globalposition.lua`
- `scripts/components/globalpositions.lua`
- `scripts/components/maprevealoptimizer.lua`
- `scripts/components/shard_isgpsnewlyadded.lua`
- `scripts/components/smokeemitter.lua`
- `scripts/prefabs/globalmapicon_noproxy.lua`
- `scripts/prefabs/globalposition_classified.lua`
- `scripts/prefabs/pings.lua`
- `scripts/prefabs/smoketrail.lua`
- `scripts/widgets/maphoverer.lua`
- `scripts/widgets/pingbadge.lua`
- `scripts/widgets/pingwheel.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 3 |
| `AddComponentPostInit` | `maprevealer` | 2 |
| `AddPrefabPostInit` | `beefalo` | 2 |
| `AddPrefabPostInit` | `shard_network` | 1 |
| `AddComponentPostInit` | `mapspotrevealer` | 1 |
| `AddPrefabPostInit` | `wx78_drone_scout` | 1 |
| `AddPrefabPostInit` | `wx78_drone_delivery` | 1 |
| `AddPrefabPostInit` | `wx78_drone_delivery_small` | 1 |
| `AddPrefabPostInit` | `bernie_big` | 1 |
| `AddPrefabPostInit` | `bernie_inactive` | 1 |
| `AddPrefabPostInit` | `bernie_active` | 1 |
| `AddPrefabPostInit` | `beef_bell` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
-- ************************ add maprecorder to world as a buffer ************************
AddPrefabPostInit("world", function(inst)
    if USE_OPTIMIZER then
        inst:AddComponent("maprevealoptimizer")
    end
    -- Copied from Global Positions Remapped
    -- Fix to account for this not being a consumable item.
    inst:AddComponent("maprecorder")
    local function GetMapExplorer(target) -- Needed for SpecialTeachMap
        return target ~= nil and target.player_classified ~= nil and target.player_classified.MapExplorer or nil
    end

```
### AddComponentPostInit("maprevealer")
```lua

-- AddComponentPostInit("maprevealer", function(inst)
--     inst.RevealMapToPlayer = function(self, player)
-- 		if player._PostActivateHandshakeState_Server ~= GLOBAL.POSTACTIVATEHANDSHAKE.READY then
-- 			return -- Wait until the player client is ready and has received the world size info.
-- 		end

-- 		if USE_OPTIMIZER then
-- 			local x, y, z = self.inst.Transform:GetWorldPosition()
-- 			local optimizer = GLOBAL.TheWorld.components.maprevealoptimizer
			
-- 			-- If the optimizer exists and says the reveal is not necessary, skip it.
```
### AddPrefabPostInit("beefalo")
```lua
	-- TODO: perhaps only disable cache for domesticated beefalo, current may conflict with other mods (like those add icons for beefalo herds)
	AddPrefabPostInit("beefalo", function(inst) inst.MiniMapEntity:SetCanUseCache(false) end)
	-- AddPrefabPostInit("beefalo", function(inst)
	-- 	local old_updatedomestication = inst.UpdateDomestication
	-- 	inst.UpdateDomestication = function(self)
	-- 		print("updating domestication")
	-- 		if inst.components.domesticatable:IsDomesticated() then
	-- 			print("Do not cache")
	-- 			inst.MiniMapEntity:SetEnabled(false)
	-- 			inst.MiniMapEntity:SetCanUseCache(false)
	-- 			inst.MiniMapEntity:SetEnabled(true)
	-- 		else
```
### AddPrefabPostInit("shard_network")
```lua
-- GLOBAL.shardcomponent("shard_isgpsnewlyadded")
AddPrefabPostInit("shard_network", function(inst)
	inst:AddComponent("shard_isgpsnewlyadded")
end)

GLOBAL.world_data_is_empty = nil
GLOBAL.world_is_newly_created = false
-- GLOBAL.mod_newly_added_for_this_world = false
-- GLOBAL.maprecoder_load_func_called = false

-- ************************ Build event handler ************************
-- The world listen for the player spawn
```
### AddComponentPostInit("mapspotrevealer")
```lua
end
AddComponentPostInit("mapspotrevealer", function(self)
    -- local old_revealmap = self.RevealMap
    self.RevealMap = function(self, doer)
        local FRAMES = GLOBAL.FRAMES
        if self.prerevealfn ~= nil then
            local allow_mapreveal = self.prerevealfn(self.inst, doer)
    
            if allow_mapreveal == false then
                return true
            end
        end
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 7 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。