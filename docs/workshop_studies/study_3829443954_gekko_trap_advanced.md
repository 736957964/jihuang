# 饥荒创意工坊研读报告：Gekko Trap: Advanced

- **模组标识**：`3829443954`
- **作者**：DevLicious
- **版本**：1.0.2
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 528 行；网络变量 0 处；RPC 0 处；注入钩子 3 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `trap` | 1 |
| `AddStategraphPostInit` | `grassgekko` | 1 |
| `AddPrefabPostInit` | `grassgekko` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("trap")
```lua

AddPrefabPostInit("trap", function(inst)
    local trap = inst.components.trap
    if trap == nil then
        return
    end

    local old_do_trigger_on = trap.DoTriggerOn
    trap.DoTriggerOn = function(self, target)
        if target ~= nil and target:IsValid() and target.prefab == "grassgekko" then
            local can_capture = not is_running_or_panicked(target)
            self.grass_gekko_trap_capture_pending = can_capture
```
### AddStategraphPostInit("grassgekko")
```lua

AddStategraphPostInit("grassgekko", function(sg)
    local scare = sg.states.scare
    if scare ~= nil then
        local old_onenter = scare.onenter
        scare.onenter = function(inst, ...)
            if inst.grass_gekko_trap_tail_lost then
                make_tailless(inst)
            end

            if old_onenter ~= nil then
                return old_onenter(inst, ...)
```
### AddPrefabPostInit("grassgekko")
```lua

AddPrefabPostInit("grassgekko", setup_grass_gekko)

AddSimPostInit(function()
    local native_c_give = GLOBAL.c_give
    if native_c_give == nil then
        return
    end

    GLOBAL.c_give = function(prefab, count, dontselect)
        if type(prefab) ~= "string" or string.lower(prefab) ~= "grassgekko" then
            return native_c_give(prefab, count, dontselect)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。