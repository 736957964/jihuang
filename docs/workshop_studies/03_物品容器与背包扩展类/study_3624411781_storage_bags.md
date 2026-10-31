# 饥荒创意工坊研读报告：Storage Bags

- **模组标识**：`3624411781`
- **作者**：ret
- **版本**：1.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：4 个 Lua 文件 / 共 680 行；网络变量 0 处；RPC 1 处；注入钩子 1 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/minecraftbundle.lua`
- `scripts/prefabs/ret_slurperbag.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `wortox_souljar` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("wortox_souljar")
```lua

    AddPrefabPostInit("wortox_souljar", function(inst)
        inst:AddTag("nowidget")
        inst:AddTag("quicksnatch")
        if not GLOBAL.TheWorld.ismastersim then return inst end

        inst:AddComponent("minecraftbundle")
        inst.components.minecraftbundle.canstorefrom_fn = SoulJarCanStore
        inst.components.minecraftbundle.snatchtest_fn   = SoulJarSnatchTest
    end)
end
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。