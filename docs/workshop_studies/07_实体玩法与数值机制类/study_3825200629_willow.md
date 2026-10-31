# 饥荒创意工坊研读报告：薇洛的余烬收纳袋 · Willow

- **模组标识**：`3825200629`
- **作者**：努力成为NO.2
- **版本**：1.0.7
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：11 个 Lua 文件 / 共 2181 行；网络变量 4 处；RPC 1 处；注入钩子 7 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/emberpouch.lua`
- `scripts/emberpouch_collection.lua`
- `scripts/emberpouch_compat.lua`
- `scripts/emberpouch_skins.lua`
- `scripts/emberpouch_speech.lua`
- `scripts/emberpouch_spells.lua`
- `scripts/emberpouch_supply.lua`
- `scripts/emberpouch_ui.lua`
- `scripts/prefabs/willow_ember_pouch.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `lighter` | 2 |
| `AddComponentPostInit` | `builder` | 1 |
| `AddPrefabPostInit` | `reskin_tool` | 1 |
| `AddComponentPostInit` | `channelcastable` | 1 |
| `AddComponentPostInit` | `playercontroller` | 1 |
| `AddComponentPostInit` | `inventory` | 1 |
| `AddPrefabPostInit` | `willow_ember` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("lighter")
```lua
AddComponentAction("SCENE", "container", UI.FilterOpenAction)
AddPrefabPostInit("lighter", Compat.InstallLighter)
AddPrefabPostInit("lighter", Supply.InstallLighter)
AddPrefabPostInit("willow_ember", function(inst)
    P.InstallEmberReplica(inst)
    Spells.Install(inst)
    if G.TheWorld.ismastersim then P.InstallEmber(inst) end
end)

-- Register before Show Me builds its prefab monitor list, independent of load order.
G.TUNING.MONITOR_CHESTS = G.TUNING.MONITOR_CHESTS or {}
G.TUNING.MONITOR_CHESTS.willow_ember_pouch = true
```
### AddComponentPostInit("builder")
```lua
AddClassPostConstruct("widgets/redux/craftingmenu_skinselector", Skins.InstallSelector)
AddComponentPostInit("builder", Skins.InstallBuilder)
AddPrefabPostInit("reskin_tool", Skins.InstallSweeper)

G.STRINGS.NAMES.WILLOW_EMBER_POUCH = "缝火袋"
G.STRINGS.NAMES.WILLOW_EMBER_POUCH_UPGRADED = "无尽缝火袋"
G.STRINGS.RECIPE_DESC.WILLOW_EMBER_POUCH = "把余烬缝进自己的小口袋。"
Speech.Install(G.STRINGS, G.ACTIONS)

local containers = G.require("containers")
containers.params.willow_ember_pouch = {
    widget = {
```
### AddPrefabPostInit("reskin_tool")
```lua
AddComponentPostInit("builder", Skins.InstallBuilder)
AddPrefabPostInit("reskin_tool", Skins.InstallSweeper)

G.STRINGS.NAMES.WILLOW_EMBER_POUCH = "缝火袋"
G.STRINGS.NAMES.WILLOW_EMBER_POUCH_UPGRADED = "无尽缝火袋"
G.STRINGS.RECIPE_DESC.WILLOW_EMBER_POUCH = "把余烬缝进自己的小口袋。"
Speech.Install(G.STRINGS, G.ACTIONS)

local containers = G.require("containers")
containers.params.willow_ember_pouch = {
    widget = {
        slotpos = { G.Vector3(0, 0, 0) },
```
### AddComponentPostInit("channelcastable")
```lua
end)
AddComponentPostInit("channelcastable", Collection.InstallChannel)
AddComponentPostInit("playercontroller", Spells.InstallController)
AddComponentPostInit("inventory", Supply.InstallInventory)
AddClassPostConstruct("components/inventory_replica", Supply.InstallInventoryReplica)
AddModRPCHandler("willow_ember_pouch", "open_command_pouch", Spells.OpenCommandPouch)
AddClassPostConstruct("widgets/invslot", UI.InstallInvSlot)
AddClassPostConstruct("widgets/containerwidget", UI.InstallContainerWidget)
AddClassPostConstruct("screens/playerhud", UI.InstallHUD)
AddClassPostConstruct("widgets/hoverer", Compat.InstallHover)
AddComponentAction("USEITEM", "inventoryitem", UI.AddStoreAction)
AddComponentAction("INVENTORY", "container", UI.FilterOpenAction)
```
### AddComponentPostInit("playercontroller")
```lua
AddComponentPostInit("channelcastable", Collection.InstallChannel)
AddComponentPostInit("playercontroller", Spells.InstallController)
AddComponentPostInit("inventory", Supply.InstallInventory)
AddClassPostConstruct("components/inventory_replica", Supply.InstallInventoryReplica)
AddModRPCHandler("willow_ember_pouch", "open_command_pouch", Spells.OpenCommandPouch)
AddClassPostConstruct("widgets/invslot", UI.InstallInvSlot)
AddClassPostConstruct("widgets/containerwidget", UI.InstallContainerWidget)
AddClassPostConstruct("screens/playerhud", UI.InstallHUD)
AddClassPostConstruct("widgets/hoverer", Compat.InstallHover)
AddComponentAction("USEITEM", "inventoryitem", UI.AddStoreAction)
AddComponentAction("INVENTORY", "container", UI.FilterOpenAction)
AddComponentAction("SCENE", "container", UI.FilterOpenAction)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 4 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。