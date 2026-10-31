# 饥荒创意工坊研读报告：Upgradeable Backpacks

- **模组标识**：`3830221580`
- **作者**：Rookie
- **版本**：1.0.2
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：5 个 Lua 文件 / 共 770 行；网络变量 0 处；RPC 0 处；注入钩子 1 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/prefabs/ubp_backpacks.lua`
- `scripts/ubp_backvisual.lua`
- `scripts/ubp_upgrade.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `inventory_classified` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("inventory_classified")
```lua
    local classified_patched = false
    AddPrefabPostInit("inventory_classified", function(inst)
        if classified_patched or _G.TheWorld.ismastersim or inst.Has == nil then
            return
        end
        classified_patched = true
        local debug = _G.debug
        local original = inst.GetOverflowContainer
        local function GetOverflowContainer(classified)
            if classified.ignoreoverflow then
                return
            end
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。