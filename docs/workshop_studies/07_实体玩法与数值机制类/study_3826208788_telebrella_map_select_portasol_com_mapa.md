# 饥荒创意工坊研读报告：Telebrella Map Select (Portasol com Mapa)

- **模组标识**：`3826208788`
- **作者**：Digi62 + IA
- **版本**：0.3.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 425 行；网络变量 0 处；RPC 1 处；注入钩子 2 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 1 |
| `AddComponentPostInit` | `remoteteleporter` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua

AddStategraphPostInit("wilson", function(sg)
    local state = sg.states ~= nil and sg.states["remote_teleport_pre"] or nil
    if state == nil or state.onenter == nil then
        print("[TeleSel] AVISO: estado remote_teleport_pre nao encontrado")
        return
    end
    local old_onenter = state.onenter
    state.onenter = function(inst, ...)
        if TryIntercept(inst) then return end
        return old_onenter(inst, ...)
    end
```
### AddComponentPostInit("remoteteleporter")
```lua

AddComponentPostInit("remoteteleporter", function(self)
    local old_Teleport = self.Teleport
    self.Teleport = function(comp, doer, ...)
        local sel = doer ~= nil and doer._telesel or nil
        if sel ~= nil then
            doer._telesel = nil
            if sel.pad:IsValid() and G.GetTime() <= sel.expire then
                dbg("teleporting to chosen pad")
                return CallWithTarget(comp, sel.pad, old_Teleport, doer, ...)
            end
        end
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。