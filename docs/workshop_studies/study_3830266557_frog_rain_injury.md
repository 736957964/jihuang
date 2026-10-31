# 饥荒创意工坊研读报告：青蛙雨摔伤 / Frog Rain Injury

- **模组标识**：`3830266557`
- **作者**：1COIN
- **版本**：1.4
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 329 行；网络变量 0 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `frograin` | 1 |
| `AddStategraphPostInit` | `frog` | 1 |

## 三、关键代码片段

### AddComponentPostInit("frograin")
```lua
----------------------------------------------------------------------------
AddComponentPostInit("frograin", function(self)
    if not TheWorld.ismastersim or rawget(self, "_frogfall2_hooked") then
        return
    end
    rawset(self, "_frogfall2_hooked", true)

    local OldStartTracking = self.StartTracking
    if OldStartTracking == nil then
        return
    end

```
### AddStategraphPostInit("frog")
```lua
----------------------------------------------------------------------------
AddStategraphPostInit("frog", function(sg)
    local fall = sg.states ~= nil and sg.states.fall or nil
    if fall == nil or fall.onupdate == nil then
        return
    end

    local OldFallUpdate = fall.onupdate

    fall.onupdate = function(inst, ...)
        -- 不是青蛙雨掉的：原样
        if not rawget(inst, MARK_PENDING) then
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。