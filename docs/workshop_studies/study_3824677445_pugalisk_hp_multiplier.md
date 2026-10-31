# 饥荒创意工坊研读报告：PUGALISK_HP_MULTIPLIER

- **模组标识**：`3824677445`
- **作者**：Kiyo
- **版本**：0.3.65
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：478 个 Lua 文件 / 共 94450 行；网络变量 94 处；RPC 6 处；注入钩子 105 处

## 一、代码结构与入口分布

顶层目录：`overlay/`、`retained/`、`scripts/`、`strings/`

Lua 文件清单（最多 40 条）：

- `baseline.lua`
- `bootstrap.lua`
- `compat.lua`
- `managed_runtime.lua`
- `modfrontendmain.lua`
- `modinfo.lua`
- `modmain.lua`
- `modservercreationmain.lua`
- `modworldgenmain.lua`
- `overlay/core/main/RPC.lua`
- `overlay/core/main/assets.lua`
- `overlay/core/main/componentactions.lua`
- `overlay/core/main/componentutil.lua`
- `overlay/core/main/constants.lua`
- `overlay/core/main/ia_corpses_defs.lua`
- `overlay/core/main/ia_preparedfoods.lua`
- `overlay/core/main/ocean_util.lua`
- `overlay/core/main/postinit.lua`
- `overlay/core/main/recipes.lua`
- `overlay/core/main/spawnutil.lua`
- `overlay/core/main/standardcomponents.lua`
- `overlay/core/main/tuning.lua`
- `overlay/core/main/util.lua`
- `overlay/core/postinit/components/blinkstaff.lua`
- `overlay/core/postinit/components/clock.lua`
- `overlay/core/postinit/components/combat.lua`
- `overlay/core/postinit/components/dynamicmusic.lua`
- `overlay/core/postinit/components/edible.lua`
- `overlay/core/postinit/components/equippable.lua`
- `overlay/core/postinit/components/hounded.lua`
- `overlay/core/postinit/components/kramped.lua`
- `overlay/core/postinit/components/locomotor.lua`
- `overlay/core/postinit/components/playervision.lua`
- `overlay/core/postinit/components/skinner.lua`
- `overlay/core/postinit/components/wavemanager.lua`
- `overlay/core/postinit/entityscript.lua`
- `overlay/core/postinit/package/map.lua`
- `overlay/core/postinit/player.lua`
- `overlay/core/postinit/prefabs/allow_impassable_item.lua`
- `overlay/core/postinit/prefabs/multiplayer_portal.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 3 |
| `AddStategraphPostInit` | `wilson_client` | 3 |
| `AddPrefabPostInit` | `player_classified` | 3 |
| `AddPrefabPostInit` | `world` | 2 |
| `AddComponentPostInit` | `playerspawner` | 2 |
| `AddComponentPostInit` | `clock` | 2 |
| `AddComponentPostInit` | `combat` | 2 |
| `AddComponentPostInit` | `equippable` | 2 |
| `AddComponentPostInit` | `locomotor` | 2 |
| `AddComponentPostInit` | `playervision` | 2 |
| `AddPrefabPostInit` | `pocketwatch_recall` | 2 |
| `AddPrefabPostInit` | `pocketwatch_portal` | 2 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua

AddStategraphPostInit("wilson", function(sg)
    if config.route_sailing then sailing_dispatcher.InstallStategraph(G, sg, false) end
end)
AddStategraphPostInit("wilson_client", function(sg)
    if config.route_sailing then sailing_dispatcher.InstallStategraph(G, sg, true) end
end)

AddComponentPostInit("boatjumper", function(self)
    if config.route_sailing then sailing_dispatcher.InstallBoatJumper(self) end
    if config.route_sailing then require("threeworld_shore_landing").Install(G, self) end
end)
```
### AddStategraphPostInit("wilson_client")
```lua
end)
AddStategraphPostInit("wilson_client", function(sg)
    if config.route_sailing then sailing_dispatcher.InstallStategraph(G, sg, true) end
end)

AddComponentPostInit("boatjumper", function(self)
    if config.route_sailing then sailing_dispatcher.InstallBoatJumper(self) end
    if config.route_sailing then require("threeworld_shore_landing").Install(G, self) end
end)

-- Register after both original modules, on clients and servers alike.
if config.route_sailing then
```
### AddPrefabPostInit("player_classified")
```lua

IAENV.AddPrefabPostInit("player_classified", function(inst)
    inst.isjellybrainhat = net_bool(inst.GUID, "builder.jellybrainhat", "recipesdirty")--todo

    inst.hasmomentum = net_bool(inst.GUID, "locomotor.hasmomentum")
    inst.hasoverride_angle = net_bool(inst.GUID, "locomotor.hasoverride_angle")
    inst.externalspeedadder = net_float(inst.GUID, "locomotor.externalspeedadder")
    inst.externalaccelerationadder = net_float(inst.GUID, "locomotor.externalaccelerationadder")
    inst.externalaccelerationmultiplier = net_float(inst.GUID, "locomotor.externalaccelerationmultiplier")
    inst.externaldecelerationadder = net_float(inst.GUID, "locomotor.externaldecelerationadder")
    inst.externaldecelerationmultiplier = net_float(inst.GUID, "locomotor.externaldecelerationmultiplier")
    inst.windspeedmult = net_float(inst.GUID, "locomotor.windspeedmult")
```
### AddPrefabPostInit("world")
```lua
    if installed then
        AddPrefabPostInit("world", function(inst) particle.InstallWorldListeners(G, inst) end)
    end
end


-- Preserve source-world stored boats on failed restore or portal dismantling.
AddComponentPostInit("migratorboatstorage", function(self)
    require("threeworld_migrator_boat_storage").Install(GLOBAL, self)
end)

-- Both modules define wave_ripple/wave_rogue with different author rules.
```
### AddComponentPostInit("playerspawner")
```lua

AddComponentPostInit("playerspawner", function(self)
    require("twc_spawn_reset").Install(self, G.TheNet:IsDedicated())
end)

local function InstallClockAlignment(self)
    if self.twc_alignment_installed then return end
    self.twc_alignment_installed = true
    local previous_load = self.OnLoad
    local alignment = require("twc_clock_alignment")
    function self:OnLoad(data, ...)
        local active = self.current_clock == "default" and "" or self.current_clock
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 94 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 6 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。