# 饥荒创意工坊研读报告：Volt, the Bun-evolent.

- **模组标识**：`3746961192`
- **作者**：Random452
- **版本**：1.2.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：32 个 Lua 文件 / 共 16086 行；网络变量 0 处；RPC 1 处；注入钩子 7 处

## 一、代码结构与入口分布

顶层目录：`patches/`、`scripts/`

Lua 文件清单（最多 40 条）：

- `modclientmain.lua`
- `modinfo.lua`
- `modmain.lua`
- `patches/redux_templates.lua`
- `scripts/brains/SGeverythingbunnyman.lua`
- `scripts/brains/SGnewbunnyman.lua`
- `scripts/brains/daybunnymanbrain.lua`
- `scripts/brains/everythingbunnymanbrain.lua`
- `scripts/brains/newbunnymanbrain.lua`
- `scripts/brains/pigbrain.lua`
- `scripts/brains/ultrabunnymanbrain.lua`
- `scripts/patches/redux_templates.lua`
- `scripts/prefabs/daybunnyhouse.lua`
- `scripts/prefabs/daybunnyman.lua`
- `scripts/prefabs/icespear.lua`
- `scripts/prefabs/newbunnyhouse.lua`
- `scripts/prefabs/newbunnyman.lua`
- `scripts/prefabs/rabbit.lua`
- `scripts/prefabs/skilltree_voltboi.lua`
- `scripts/prefabs/tactical_armor.lua`
- `scripts/prefabs/tactichelm.lua`
- `scripts/prefabs/ultrabunnyhouse.lua`
- `scripts/prefabs/ultrabunnyman.lua`
- `scripts/prefabs/voltboi.lua`
- `scripts/prefabs/voltboi_none.lua`
- `scripts/speech_voltboi.lua`
- `scripts/stategraphs/SGeverythingbunnyman.lua`
- `scripts/stategraphs/SGnewbunnyman.lua`
- `scripts/stategraphs/SGultrabunnyman.lua`
- `scripts/widgets/bonehealthbadge.lua`
- `skins_api.lua`
- `strings.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `rabbitking_aggressive` | 2 |
| `AddPrefabPostInit` | `bunnyman` | 2 |
| `AddPrefabPostInit` | `moonglass` | 2 |
| `AddPrefabPostInit` | `moonglass_charged` | 2 |
| `AddPrefabPostInit` | `lunarplant_husk` | 2 |
| `AddPrefabPostInit` | `purebrilliance` | 2 |
| `AddComponentPostInit` | `skinner` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("rabbitking_aggressive")
```lua

AddPrefabPostInit("rabbitking_aggressive", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("death", function()
        GLOBAL.TheGenericKV:SetKV("rabbitking_killed", "1")
        print("[Voltboi] Rabbit King slain — allegiance unlocked!")
    end)
end)

```
### AddPrefabPostInit("bunnyman")
```lua
-- Bunnymen ignore Voltboi
AddPrefabPostInit("bunnyman", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end

    if inst.components.combat ~= nil then
        local _OldRetargetFn = inst.components.combat.targetfn
        inst.components.combat:SetRetargetFunction(1, function(inst, ...)
            local target = _OldRetargetFn and _OldRetargetFn(inst, ...)
            if target ~= nil and target:HasTag("voltboi") then
                return nil
```
### AddPrefabPostInit("moonglass")
```lua

AddPrefabPostInit("moonglass", function(inst)
    MakeMoonGlassEdible(inst, 15, 0, -85)
end)

AddPrefabPostInit("moonglass_charged", function(inst)
    MakeMoonGlassEdible(inst, 15, 15, -155)
end)

AddPrefabPostInit("lunarplant_husk", function(inst)
    MakeMoonGlassEdible(inst, 55, 5, -85)
end)
```
### AddPrefabPostInit("moonglass_charged")
```lua

AddPrefabPostInit("moonglass_charged", function(inst)
    MakeMoonGlassEdible(inst, 15, 15, -155)
end)

AddPrefabPostInit("lunarplant_husk", function(inst)
    MakeMoonGlassEdible(inst, 55, 5, -85)
end)

AddPrefabPostInit("purebrilliance", function(inst)
    MakeMoonGlassEdible(inst, 50, 30, -255)
end)
```
### AddPrefabPostInit("lunarplant_husk")
```lua

AddPrefabPostInit("lunarplant_husk", function(inst)
    MakeMoonGlassEdible(inst, 55, 5, -85)
end)

AddPrefabPostInit("purebrilliance", function(inst)
    MakeMoonGlassEdible(inst, 50, 30, -255)
end)

-- Player-specific post init
AddPlayerPostInit(function(inst)
    if inst.prefab == "voltboi" then
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。