# 饥荒创意工坊研读报告：基地防护 | Base Protection

- **模组标识**：`3825722696`
- **作者**：rebecca graem
- **版本**：1.0.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 236 行；网络变量 0 处；RPC 0 处；注入钩子 8 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `workable` | 1 |
| `AddComponentPostInit` | `combat` | 1 |
| `AddComponentPostInit` | `health` | 1 |
| `AddComponentPostInit` | `burnable` | 1 |
| `AddBrainPostInit` | `deerclopsbrain` | 1 |
| `AddBrainPostInit` | `beargerbrain` | 1 |
| `AddBrainPostInit` | `krampusbrain` | 1 |
| `AddPrefabPostInit` | `antlion_sinkhole` | 1 |

## 三、关键代码片段

### AddComponentPostInit("workable")
```lua
-- No work events or finish callbacks run for blocked work (container contents stay put).
AddComponentPostInit("workable", function(self)
    for _, name in G.ipairs({ "Destroy", "WorkedBy", "WorkedBy_Internal" }) do
        local old = self[name]
        self[name] = function(component, worker, ...)
            if BlockWork(component.inst, worker) then return end
            return old(component, worker, ...)
        end
    end
end)

AddComponentPostInit("combat", function(self)
```
### AddComponentPostInit("combat")
```lua

AddComponentPostInit("combat", function(self)
    local can = self.CanTarget
    self.CanTarget = function(component, target, ...)
        if not IsPlayer(component.inst) and IsProtected(target) then return false end
        return can(component, target, ...)
    end
    local attacked = self.GetAttacked_Internal
    self.GetAttacked_Internal = function(component, attacker, ...)
        if BlockWork(component.inst, attacker) then return false end
        return attacked(component, attacker, ...)
    end
```
### AddComponentPostInit("health")
```lua

AddComponentPostInit("health", function(self)
    local fire_damage = self.DoFireDamage
    local in_fire_damage = false
    self.DoFireDamage = function(component, ...)
        if IsProtected(component.inst) then
            if FIRE then return end
            -- Fire OFF: attributed fire damage must also bypass the physical-damage guard.
            local previous = in_fire_damage
            in_fire_damage = true
            local result = fire_damage(component, ...)
            in_fire_damage = previous
```
### AddComponentPostInit("burnable")
```lua
if FIRE then
    AddComponentPostInit("burnable", function(self)
        for _, name in G.ipairs({ "Ignite", "StartWildfire" }) do
            local old = self[name]
            self[name] = function(component, ...)
                if DestructiveBurnable(component) and IsProtected(component.inst) then return end
                return old(component, ...)
            end
        end
    end)
end

```
### AddBrainPostInit("deerclopsbrain")
```lua

AddBrainPostInit("deerclopsbrain", function(brain)
    ExcludeTag(brain.OnStart, "BASEDESTROY_CANT_TAGS", TAG)
end)
AddBrainPostInit("beargerbrain", function(brain)
    ExcludeTag(brain.OnStart, "NO_TAGS", STORAGE_TAG)
end)
local krampus_patched = false
AddBrainPostInit("krampusbrain", function(brain)
    if krampus_patched then return end
    local owner, index, old = FindUpvalue(brain.OnStart, "CanHammer")
    if G.type(old) ~= "function" then
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。