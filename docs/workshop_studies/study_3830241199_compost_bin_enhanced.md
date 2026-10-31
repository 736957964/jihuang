# 饥荒创意工坊研读报告：堆肥桶重制 (Compost Bin Enhanced)

- **模组标识**：`3830241199`
- **作者**：狗熊岭-熊二
- **版本**：1.0.5
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 683 行；网络变量 0 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `compostingbin` | 1 |
| `AddPrefabPostInit` | `compostingbin_placer` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("compostingbin")
```lua

AddPrefabPostInit("compostingbin", function(inst)
    if G.TheWorld ~= nil and G.TheWorld.ismastersim then
        SetupCompostBin(inst)
    end
    return inst
end)

AddPrefabPostInit("compostingbin_placer", function(inst)
    if G.TheNet:IsDedicated() then
        return inst
    end
```
### AddPrefabPostInit("compostingbin_placer")
```lua

AddPrefabPostInit("compostingbin_placer", function(inst)
    if G.TheNet:IsDedicated() then
        return inst
    end

    local rangehelper = G.CreateEntity()
    rangehelper.entity:SetCanSleep(false)
    rangehelper.persists = false
    rangehelper.entity:AddTransform()
    rangehelper.entity:AddAnimState()
    rangehelper:AddTag("CLASSIFIED")
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。