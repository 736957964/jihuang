# 饥荒创意工坊研读报告：STACK_FOOD

- **模组标识**：`3827133829`
- **作者**：lmsg
- **版本**：1.0.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：24 个 Lua 文件 / 共 4352 行；网络变量 3 处；RPC 4 处；注入钩子 4 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/dimension_archive_state.lua`
- `scripts/dimension_archive_access.lua`
- `scripts/dimension_archive_badge_config.lua`
- `scripts/dimension_archive_capacity.lua`
- `scripts/dimension_archive_coexist.lua`
- `scripts/dimension_archive_crafting_style.lua`
- `scripts/dimension_archive_display.lua`
- `scripts/dimension_archive_drag.lua`
- `scripts/dimension_archive_icon_bounds.lua`
- `scripts/dimension_archive_layout.lua`
- `scripts/dimension_archive_skins.lua`
- `scripts/dimension_archive_socket_y.lua`
- `scripts/dimension_archive_sockets.lua`
- `scripts/dimension_archive_storage.lua`
- `scripts/dimension_archive_strings.lua`
- `scripts/dimension_archive_theme.lua`
- `scripts/dimension_archive_ui_config.lua`
- `scripts/dimension_archive_upgrades.lua`
- `scripts/dimension_archive_world_config.lua`
- `scripts/prefabs/dimension_archive.lua`
- `scripts/prefabs/dimension_archive_core.lua`
- `scripts/widgets/dimension_archive_panel.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `dimension_archive_placer` | 1 |
| `AddPrefabPostInit` | `reskin_tool` | 1 |
| `AddPrefabPostInit` | `chestupgrade_stacksize` | 1 |
| `AddComponentPostInit` | `builder` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("dimension_archive_placer")
```lua
 end)
AddPrefabPostInit("dimension_archive_placer",function(inst)
 local style=require("dimension_archive_crafting_style").selected
 inst.AnimState:SetBuild((Skins.definitions[style]or Skins.definitions[1]).build)
end)
-- Each core advances exactly one native stage. No global capacity cheat/config.
AddRecipe2("dimension_archive_core",{G.Ingredient("redmooneye",1),G.Ingredient("bluemooneye",1),G.Ingredient("purplemooneye",1),G.Ingredient("feather_canary",1)},G.TECH.SCIENCE_TWO,
 {atlas="images/dimension_archive_core.xml",image="dimension_archive_core.tex"},{"CONTAINERS"})
AddPrefabPostInit("reskin_tool",Skins.Sweeper)
AddPrefabPostInit("chestupgrade_stacksize",require("dimension_archive_upgrades").AttachElastispacer)
AddComponentPostInit("builder",Skins.Builder)
AddPlayerPostInit(function(inst)inst:AddTag(Capacity.upgradetype.."_upgradeuser")end)
```
### AddPrefabPostInit("reskin_tool")
```lua
 {atlas="images/dimension_archive_core.xml",image="dimension_archive_core.tex"},{"CONTAINERS"})
AddPrefabPostInit("reskin_tool",Skins.Sweeper)
AddPrefabPostInit("chestupgrade_stacksize",require("dimension_archive_upgrades").AttachElastispacer)
AddComponentPostInit("builder",Skins.Builder)
AddPlayerPostInit(function(inst)inst:AddTag(Capacity.upgradetype.."_upgradeuser")end)
local function notify(player,key)
 if player.userid then G.SendModRPCToClient(G.GetClientModRPC("DimensionArchive","Notice"),player.userid,key)end
end
AddClientModRPCHandler("DimensionArchive","Notice",function(key)
 local p=G.ThePlayer;if p and p.components.talker and Strings[key]then p.components.talker:Say(Strings[key])end
end)
AddModRPCHandler("DimensionArchive","Sort",function(player,inst)
```
### AddPrefabPostInit("chestupgrade_stacksize")
```lua
AddPrefabPostInit("reskin_tool",Skins.Sweeper)
AddPrefabPostInit("chestupgrade_stacksize",require("dimension_archive_upgrades").AttachElastispacer)
AddComponentPostInit("builder",Skins.Builder)
AddPlayerPostInit(function(inst)inst:AddTag(Capacity.upgradetype.."_upgradeuser")end)
local function notify(player,key)
 if player.userid then G.SendModRPCToClient(G.GetClientModRPC("DimensionArchive","Notice"),player.userid,key)end
end
AddClientModRPCHandler("DimensionArchive","Notice",function(key)
 local p=G.ThePlayer;if p and p.components.talker and Strings[key]then p.components.talker:Say(Strings[key])end
end)
AddModRPCHandler("DimensionArchive","Sort",function(player,inst)
 if Access.Valid(player,inst)and not Storage.Sort(inst.components.container,mergefood)then notify(player,"BUSY")end
```
### AddComponentPostInit("builder")
```lua
AddPrefabPostInit("chestupgrade_stacksize",require("dimension_archive_upgrades").AttachElastispacer)
AddComponentPostInit("builder",Skins.Builder)
AddPlayerPostInit(function(inst)inst:AddTag(Capacity.upgradetype.."_upgradeuser")end)
local function notify(player,key)
 if player.userid then G.SendModRPCToClient(G.GetClientModRPC("DimensionArchive","Notice"),player.userid,key)end
end
AddClientModRPCHandler("DimensionArchive","Notice",function(key)
 local p=G.ThePlayer;if p and p.components.talker and Strings[key]then p.components.talker:Say(Strings[key])end
end)
AddModRPCHandler("DimensionArchive","Sort",function(player,inst)
 if Access.Valid(player,inst)and not Storage.Sort(inst.components.container,mergefood)then notify(player,"BUSY")end
end)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 3 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 4 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。