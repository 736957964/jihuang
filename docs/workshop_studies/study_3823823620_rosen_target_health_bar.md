# 饥荒创意工坊研读报告：RoseN Target Health Bar

- **模组标识**：`3823823620`
- **作者**：RoseN
- **版本**：1.6.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：3 个 Lua 文件 / 共 892 行；网络变量 8 处；RPC 0 处；注入钩子 1 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/widgets/rosen_targethealth.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `player_classified` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("player_classified")
```lua
local SLOT_SUFFIX = { "", "2" }
AddPrefabPostInit("player_classified", function(inst)
    for i, sx in ipairs(SLOT_SUFFIX) do
        inst["rosen_tgt" .. sx] = G.net_entity(inst.GUID, "rosen_hb.tgt" .. sx)
        inst["rosen_hp" .. sx] = G.net_float(inst.GUID, "rosen_hb.hp" .. sx)
        inst["rosen_max" .. sx] = G.net_float(inst.GUID, "rosen_hb.max" .. sx)
        inst["rosen_dmg" .. sx] = G.net_float(inst.GUID, "rosen_hb.dmg" .. sx)
        inst["rosen_dmgmine" .. sx] = G.net_bool(inst.GUID, "rosen_hb.dmgmine" .. sx)
        inst["rosen_dmgseq" .. sx] = G.net_byte(inst.GUID, "rosen_hb.dmgseq" .. sx)
        inst["rosen_phases" .. sx] = G.net_string(inst.GUID, "rosen_hb.phases" .. sx) -- "0.7500,0.5000" gibi
        inst["rosen_label" .. sx] = G.net_string(inst.GUID, "rosen_hb.label" .. sx)   -- "Phase 2/3" gibi
    end
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 8 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。