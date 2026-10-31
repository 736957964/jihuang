# 饥荒创意工坊研读报告：Rework: Queen

- **模组标识**：`3820619234`
- **作者**：Venus_9
- **版本**：0.7.2
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：7 个 Lua 文件 / 共 1052 行；网络变量 0 处；RPC 0 处；注入钩子 11 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/queen_torch_aggro.lua`
- `scripts/queen_torch_destroy_state.lua`
- `scripts/queen_torch_noncombat.lua`
- `scripts/queen_torch_shadowspells.lua`
- `scripts/queen_torch_utilities.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `queen_torch` | 3 |
| `AddComponentPostInit` | `temperature` | 1 |
| `AddPrefabPostInit` | `queen_torchlight` | 1 |
| `AddPrefabPostInit` | `shadowprotector` | 1 |
| `AddPrefabPostInit` | `shadowduelist` | 1 |
| `AddComponentPostInit` | `combat` | 1 |
| `AddPrefabPostInit` | `lunarthrall_plant` | 1 |
| `AddPrefabPostInit` | `monkey` | 1 |
| `AddComponentPostInit` | `thief` | 1 |
| `AddPrefabPostInit` | `shadow_pillar_spell` | 1 |
| `AddComponentPostInit` | `playercontroller` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("queen_torch")
```lua

AddPrefabPostInit("queen_torch", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("equipped", OnEquipped)
end)

local function RefreshAreaTemperature(light)
    local overrider = light.components.temperatureoverrider
    local parent = light.entity:GetParent()
```
### AddComponentPostInit("temperature")
```lua
-- 沿用原版的温度同步及冰冻/过热事件，不占用原版 settemp 锁温状态。
AddComponentPostInit("temperature", function(self)
    local originalSetTemperature = self.SetTemperature
    self.SetTemperature = function(component, value, ...)
        if GetHeldQueenTorch(component.inst) ~= nil then
            value = TARGET_TEMPERATURE
        end
        return originalSetTemperature(component, value, ...)
    end
end)

local function RefreshHolderTemperature(owner)
```
### AddPrefabPostInit("queen_torchlight")
```lua

AddPrefabPostInit("queen_torchlight", function(inst)
    -- 与冰眼结晶器一致：两端创建网络组件，仅由服务器配置。
    inst:AddComponent("temperatureoverrider")
    queenTorchLights[inst] = true
    inst:ListenForEvent("onremove", function(light)
        queenTorchLights[light] = nil
    end)

    if not GLOBAL.TheWorld.ismastersim then
        return
    end
```
### AddPrefabPostInit("shadowprotector")
```lua

    AddPrefabPostInit("shadowprotector", InstallShadowMinionCombat)
    AddPrefabPostInit("shadowduelist", InstallShadowMinionCombat)

    local function InstallPlayerCombat(combat)
        if combat == nil then
            return
        end
        if combat.shouldavoidaggrofn ~= combat._rqt_avoid_aggro_fn
            or combat._rqt_avoid_aggro_fn == nil then
            local originalShouldAvoidAggro = combat.shouldavoidaggrofn
            combat._rqt_avoid_aggro_fn = function(attacker, target)
```
### AddPrefabPostInit("shadowduelist")
```lua
    AddPrefabPostInit("shadowprotector", InstallShadowMinionCombat)
    AddPrefabPostInit("shadowduelist", InstallShadowMinionCombat)

    local function InstallPlayerCombat(combat)
        if combat == nil then
            return
        end
        if combat.shouldavoidaggrofn ~= combat._rqt_avoid_aggro_fn
            or combat._rqt_avoid_aggro_fn == nil then
            local originalShouldAvoidAggro = combat.shouldavoidaggrofn
            combat._rqt_avoid_aggro_fn = function(attacker, target)
                if ShouldIgnoreTarget(attacker, target) then
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。