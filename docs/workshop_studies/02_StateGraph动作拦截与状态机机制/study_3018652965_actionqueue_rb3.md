# 饥荒创意工坊研读报告：ActionQueue RB3汉化版

- **模组标识**：`3018652965`
- **作者**：Cutlass / null / eXiGe / simplex(Original Author)
- **版本**：3.2
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：4 个 Lua 文件 / 共 1703 行；网络变量 0 处；RPC 0 处；注入钩子 3 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/actionqueuer.lua`
- `scripts/utils/geoutil.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `playercontroller` | 1 |
| `AddComponentPostInit` | `highlight` | 1 |
| `AddComponentPostInit` | `placer` | 1 |

## 三、关键代码片段

### AddComponentPostInit("playercontroller")
```lua
local always_clear_queue = GetModConfigData("always_clear_queue")
AddComponentPostInit("playercontroller", function(self, inst)
    if inst ~= _G.ThePlayer then return end
    ThePlayer = _G.ThePlayer
    TheWorld = _G.TheWorld
    ActionQueuerInit()

    local PlayerControllerOnControl = self.OnControl
    self.OnControl = function(self, control, down)
        local mouse_control = mouse_controls[control]
        if mouse_control ~= nil then
            if down then
```
### AddComponentPostInit("highlight")
```lua

AddComponentPostInit("highlight", function(self, inst)
    local HighlightHighlight = self.Highlight
    self.Highlight = function(self, ...)
        if ActionQueuer.selection_thread or ActionQueuer:IsSelectedEntity(inst) then return end
        HighlightHighlight(self, ...)
    end
    local HighlightUnHighlight = self.UnHighlight
    self.UnHighlight = function(self)
        if ActionQueuer:IsSelectedEntity(inst) then return end
        HighlightUnHighlight(self)
    end
```
### AddComponentPostInit("placer")
```lua
--hides the geo grid during an action queue
AddComponentPostInit("placer", function(self, inst)
    local PlacerOnUpdate = self.OnUpdate
    self.OnUpdate = function(self, ...)
        self.disabled = ActionQueuer.action_thread ~= nil
        PlacerOnUpdate(self, ...)
    end
end)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。