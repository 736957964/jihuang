# 饥荒创意工坊研读报告：神谕系列 / Oracle Series

- **模组标识**：`3826859046`
- **作者**：Roomcar
- **版本**：1.0.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：17 个 Lua 文件 / 共 2171 行；网络变量 3 处；RPC 2 处；注入钩子 1 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/brains/spider_godbrain.lua`
- `scripts/components/oracle_recruitment.lua`
- `scripts/godhatvisuals.lua`
- `scripts/oracle_strings.lua`
- `scripts/oraclecolours.lua`
- `scripts/oraclecontainment.lua`
- `scripts/oracleeffects.lua`
- `scripts/oracleperformance.lua`
- `scripts/oraclesentinel_equipment.lua`
- `scripts/prefabs/godhat.lua`
- `scripts/prefabs/spider_god.lua`
- `scripts/prefabs/spider_god_bone.lua`
- `scripts/stategraphs/SGoraclesentinel.lua`
- `scripts/widgets/oraclecontainerpanel.lua`
- `scripts/widgets/oracleequipmentpanel.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `container` | 1 |

## 三、关键代码片段

### AddComponentPostInit("container")
```lua
containers.params.spider_god.itemtestfn = function(container, item) return not Containment.WouldCycle(container.inst, item) end
AddComponentPostInit("container", Containment.WrapContainer)


AddModRPCHandler("RoomcarOracle", "Equipment", function(player, guid, index, removeonly)
    if type(guid) ~= "number" or type(index) ~= "number" then return end
    local guard = GLOBAL.Ents[guid]
    require("oraclesentinel_equipment").HandleClick(player, guard, index, removeonly == true)
end)

AddModRPCHandler("RoomcarOracle", "Colour", function(player, guid)
    if type(guid) ~= "number" then return end
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 3 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 2 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。