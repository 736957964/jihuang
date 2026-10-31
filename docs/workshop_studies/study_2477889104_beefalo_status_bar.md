# 饥荒创意工坊研读报告：Beefalo Status Bar

- **模组标识**：`2477889104`
- **作者**：MNK
- **版本**：1.4.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：4 个 Lua 文件 / 共 805 行；网络变量 4 处；RPC 0 处；注入钩子 1 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/widgets/beefaloBadge.lua`
- `scripts/widgets/beefaloStatusBar.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `player_classified` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("player_classified")
```lua

AddPrefabPostInit("player_classified", function(inst)
    inst.beefaloData = GLOBAL.net_string(inst.GUID, "beefaloData", "beefaloDataDirty")
    inst.beefaloHealth = GLOBAL.net_ushortint(inst.GUID, "beefaloHealth", "beefaloHealthDirty")
    inst.beefaloDomestication = GLOBAL.net_string(inst.GUID, "beefaloDomestication", "beefaloDomesticationDirty")
    inst.beefaloObedience = GLOBAL.net_byte(inst.GUID, "beefaloObedience", "beefaloObedienceDirty")
    inst.beefaloBuckTime = GLOBAL.net_float(inst.GUID, "beefaloBuckTime", "beefaloBuckTimeDirty")
    inst.beefaloHunger = GLOBAL.net_ushortint(inst.GUID, "beefaloHunger", "beefaloHungerDirty")
    
    if not GLOBAL.TheWorld.ismastersim then return end

    inst.OnBeefaloHealthDelta = function(beefalo, data)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 4 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。