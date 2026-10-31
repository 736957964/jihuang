# 饥荒创意工坊研读报告：Craft Pot

- **模组标识**：`727774324`
- **作者**：IvanX
- **版本**：0.15.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：17 个 Lua 文件 / 共 2408 行；网络变量 0 处；RPC 0 处；注入钩子 1 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/knownfoods.lua`
- `scripts/cookingpots.lua`
- `scripts/foodatlas.lua`
- `scripts/ingredienttags.lua`
- `scripts/utils/getinventoryitematlas.lua`
- `scripts/utils/print_tbl.lua`
- `scripts/utils/resolvefoodtagassets.lua`
- `scripts/utils/resolveinventoryitemassets.lua`
- `scripts/utils/sanitizeassets.lua`
- `scripts/widgets/foodcrafting.lua`
- `scripts/widgets/foodingredientui.lua`
- `scripts/widgets/fooditem.lua`
- `scripts/widgets/foodrecipepopup.lua`
- `scripts/widgets/foodslot.lua`
- `scripts/widgets/mousefoodcrafting.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
  if IsDST() then
    env.AddPrefabPostInit("world", function(wrld)
      wrld:ListenForEvent("playeractivated", function(wlrd, player)
        if player == GLOBAL.ThePlayer then
          fn(player)
        end
      end)
    end)
  else
    env.AddPlayerPostInit(function(player)
      fn(player)
    end)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。