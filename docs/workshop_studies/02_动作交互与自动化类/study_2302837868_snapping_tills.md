# 饥荒创意工坊研读报告：Snapping tills

- **模组标识**：`2302837868`
- **作者**：surg
- **版本**：1.1.9
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：6 个 Lua 文件 / 共 1185 行；网络变量 0 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/snaptiller.lua`
- `scripts/components/snaptillplacer.lua`
- `scripts/persistentdata.lua`
- `scripts/prefabs/snaptillplacer.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `placer` | 2 |
| `AddComponentPostInit` | `playercontroller` | 1 |

## 三、关键代码片段

### AddComponentPostInit("placer")
```lua

    AddComponentPostInit("placer", function(self, inst)
        -- so crazy, but no other way
        _G.print = function() end -- KnownModIndex functions kinda spam the logs
        local config = _G.KnownModIndex:LoadModConfigurationOptions("workshop-351325790", true)
        for _, v in ipairs(config) do
            if v.name == "CTRL" then
                is_on_geometricplacement = not v.saved
                break
            end
        end
        _G.print = original_print --restore print functionality!
```
### AddComponentPostInit("playercontroller")
```lua

AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end

    self.inst:AddComponent("snaptiller")

    if visiblesnaps then
        self.inst:AddComponent("snaptillplacer")
    end

    local version = datacontainer:GetValue("version")
    local snapmode = datacontainer:GetValue("snapmode")
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。