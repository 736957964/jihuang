# 饥荒创意工坊研读报告：maxstack

- **模组标识**：`3825146333`
- **作者**：DreamSimulator
- **版本**：1.4.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：3 个 Lua 文件 / 共 398 行；网络变量 1 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/sdrf_stacklimit.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `dryingrack` | 1 |
| `AddComponentPostInit` | `wobyrack` | 1 |

## 三、关键代码片段

### AddComponentPostInit("dryingrack")
```lua

AddComponentPostInit("dryingrack", InstallCompletion)

local function RefreshPreserver(self)
    local inst = self:GetContainer().inst
    local preserver = inst.components.preserver or inst:AddComponent("preserver")
    preserver:SetPerishRateMultiplier(self._dryingperishratefn)
end

local function ConfigurePreservation(self)
    local original_rate = self._dryingperishratefn
    self._dryingperishratefn = function(containerinst, item)
```
### AddComponentPostInit("wobyrack")
```lua

AddComponentPostInit("wobyrack", function(self)
    InstallCompletion(self)
    LimitStacks(self:GetContainer(), stack_limit)
    ConfigurePreservation(self)
    -- Big Woby enables vanilla drying immediately after this hook. Small Woby
    -- keeps drying disabled and therefore never gets vanilla's preserver.
    -- Install preservation after either initialization path has finished.
    self.inst:DoTaskInTime(0, function() RefreshPreserver(self) end)
end)

local function ConfigureDrying(self)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 1 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。