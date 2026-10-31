# 饥荒创意工坊研读报告：Rework: King

- **模组标识**：`3820595913`
- **作者**：Venus_9
- **版本**：1.12.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：20 个 Lua 文件 / 共 2371 行；网络变量 0 处；RPC 0 处；注入钩子 6 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/brains/king_cane_little_starbrain.lua`
- `scripts/king_cane_blue.lua`
- `scripts/king_cane_cast_fx.lua`
- `scripts/king_cane_corrupt_targets.lua`
- `scripts/king_cane_corruption.lua`
- `scripts/king_cane_green.lua`
- `scripts/king_cane_green_hint.lua`
- `scripts/king_cane_ice_freeze.lua`
- `scripts/king_cane_map_controls.lua`
- `scripts/king_cane_red.lua`
- `scripts/king_cane_rework.lua`
- `scripts/king_cane_sanity.lua`
- `scripts/king_cane_shadow_trail.lua`
- `scripts/prefabs/king_cane_corrupt_targets.lua`
- `scripts/prefabs/king_cane_ice_circle.lua`
- `scripts/prefabs/king_cane_little_star.lua`
- `scripts/prefabs/king_cane_shadow_trail.lua`
- `scripts/stategraphs/SGking_cane_little_star.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `playercontroller` | 1 |
| `AddStategraphPostInit` | `wilson` | 1 |
| `AddStategraphPostInit` | `wilson_client` | 1 |
| `AddPrefabPostInit` | `king_cane_fx` | 1 |
| `AddPrefabPostInit` | `telebase` | 1 |
| `AddPrefabPostInit` | `king_cane` | 1 |

## 三、关键代码片段

### AddComponentPostInit("playercontroller")
```lua
local cast_fx = require("king_cane_cast_fx")(G)
AddComponentPostInit("playercontroller", green.PatchController)

AddStategraphPostInit("wilson", mapcontrols.PatchStategraph)
AddStategraphPostInit("wilson_client", mapcontrols.PatchStategraph)
-- 地图装饰和鼠标动作提示属于本地界面，专用服务器不加载 Widget。
if not G.TheNet:IsDedicated() then
    AddClassPostConstruct("screens/mapscreen", mapcontrols.PatchMapScreen)
    AddClassPostConstruct("widgets/hoverer", green_hint.PatchHoverer)
end

AddPrefabPostInit("king_cane_fx", cast_fx.InstallFx)
```
### AddStategraphPostInit("wilson")
```lua

AddStategraphPostInit("wilson", mapcontrols.PatchStategraph)
AddStategraphPostInit("wilson_client", mapcontrols.PatchStategraph)
-- 地图装饰和鼠标动作提示属于本地界面，专用服务器不加载 Widget。
if not G.TheNet:IsDedicated() then
    AddClassPostConstruct("screens/mapscreen", mapcontrols.PatchMapScreen)
    AddClassPostConstruct("widgets/hoverer", green_hint.PatchHoverer)
end

AddPrefabPostInit("king_cane_fx", cast_fx.InstallFx)
AddPrefabPostInit("telebase", rework.TrackTelebase)
-- 双端使用原生目标标签，使房主和加入者看到同一个腐化动作。
```
### AddStategraphPostInit("wilson_client")
```lua
AddStategraphPostInit("wilson", mapcontrols.PatchStategraph)
AddStategraphPostInit("wilson_client", mapcontrols.PatchStategraph)
-- 地图装饰和鼠标动作提示属于本地界面，专用服务器不加载 Widget。
if not G.TheNet:IsDedicated() then
    AddClassPostConstruct("screens/mapscreen", mapcontrols.PatchMapScreen)
    AddClassPostConstruct("widgets/hoverer", green_hint.PatchHoverer)
end

AddPrefabPostInit("king_cane_fx", cast_fx.InstallFx)
AddPrefabPostInit("telebase", rework.TrackTelebase)
-- 双端使用原生目标标签，使房主和加入者看到同一个腐化动作。
for _, prefab in ipairs({ "shadowheart", "slingshot_band_tentacle", "pandoraschest",
```
### AddPrefabPostInit("king_cane_fx")
```lua

AddPrefabPostInit("king_cane_fx", cast_fx.InstallFx)
AddPrefabPostInit("telebase", rework.TrackTelebase)
-- 双端使用原生目标标签，使房主和加入者看到同一个腐化动作。
for _, prefab in ipairs({ "shadowheart", "slingshot_band_tentacle", "pandoraschest",
    "chest_mimic", "chest_mimic_revealed" }) do
    AddPrefabPostInit(prefab, corrupt_targets.TagTarget)
end

-- 先执行完整的原版腐化回调，再恢复交易；保留回调的返回值。
local function EnableAfterCorruption(inst, ...)
    local trader = inst.components.trader
```
### AddPrefabPostInit("telebase")
```lua
AddPrefabPostInit("king_cane_fx", cast_fx.InstallFx)
AddPrefabPostInit("telebase", rework.TrackTelebase)
-- 双端使用原生目标标签，使房主和加入者看到同一个腐化动作。
for _, prefab in ipairs({ "shadowheart", "slingshot_band_tentacle", "pandoraschest",
    "chest_mimic", "chest_mimic_revealed" }) do
    AddPrefabPostInit(prefab, corrupt_targets.TagTarget)
end

-- 先执行完整的原版腐化回调，再恢复交易；保留回调的返回值。
local function EnableAfterCorruption(inst, ...)
    local trader = inst.components.trader
    if trader ~= nil then
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。