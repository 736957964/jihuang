# 饥荒创意工坊研读报告：[Bulingbuling]不灵小姐似乎在绝赞遇难中

- **模组标识**：`3827681772`
- **作者**：Dladm
- **版本**：4.4.9-dst-port
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：131 个 Lua 文件 / 共 37990 行；网络变量 26 处；RPC 7 处；注入钩子 15 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `modworldgenmain.lua`
- `scripts/brains/buling_ancient_robotbrain.lua`
- `scripts/brains/buling_citypigbrain.lua`
- `scripts/brains/buling_companionbrain.lua`
- `scripts/brains/buling_dragoonbrain.lua`
- `scripts/brains/buling_enemybrain.lua`
- `scripts/brains/buling_frog_poisonbrain.lua`
- `scripts/brains/buling_hippopotamoosebrain.lua`
- `scripts/brains/buling_mermfisherbrain.lua`
- `scripts/brains/buling_supportfollowerbrain.lua`
- `scripts/brains/buling_vampirebatbrain.lua`
- `scripts/buling_airship_defs.lua`
- `scripts/buling_chip_visibility.lua`
- `scripts/buling_clothing_actions.lua`
- `scripts/buling_container_layouts.lua`
- `scripts/buling_content.lua`
- `scripts/buling_device_ranges.lua`
- `scripts/buling_exoskeleton_actions.lua`
- `scripts/buling_extraction_recipes.lua`
- `scripts/buling_food_ai.lua`
- `scripts/buling_food_allies.lua`
- `scripts/buling_gun_attack.lua`
- `scripts/buling_gun_rapid.lua`
- `scripts/buling_gun_rapid_input.lua`
- `scripts/buling_inventory_icons.lua`
- `scripts/buling_localization.lua`
- `scripts/buling_original_strings.lua`
- `scripts/buling_owner_restrictions.lua`
- `scripts/buling_performance.lua`
- `scripts/buling_planet_defs.lua`
- `scripts/buling_planet_permadeath.lua`
- `scripts/buling_portable_power_actions.lua`
- `scripts/buling_powergrid.lua`
- `scripts/buling_prefab_dependency_policy.lua`
- `scripts/buling_range_placer.lua`
- `scripts/buling_recovery_pulses.lua`
- `scripts/buling_rocky_attack.lua`
- `scripts/buling_rocky_health.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 2 |
| `AddStategraphPostInit` | `wilson` | 2 |
| `AddPrefabPostInit` | `rain` | 1 |
| `AddPrefabPostInit` | `player_classified` | 1 |
| `AddPrefabPostInit` | `slurper` | 1 |
| `AddPrefabPostInit` | `buling_zhongziding` | 1 |
| `AddBrainPostInit` | `monkeybrain` | 1 |
| `AddBrainPostInit` | `powdermonkeybrain` | 1 |
| `AddBrainPostInit` | `pigguardbrain` | 1 |
| `AddStategraphPostInit` | `powdermonkey` | 1 |
| `AddPrefabPostInit` | `monkey` | 1 |
| `AddPrefabPostInit` | `powder_monkey` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua

AddPrefabPostInit("world", function(inst)
    if GLOBAL.TheWorld.ismastersim and inst.components.buling_airship_manager == nil then
        inst:AddComponent("buling_airship_manager")
    end
    if GLOBAL.TheWorld.ismastersim and inst.components.buling_planet_manager == nil then
        inst:AddComponent("buling_planet_manager")
    end
    if GLOBAL.TheWorld.ismastersim and inst.components.buling_moon_volcano == nil then
        inst:AddComponent("buling_moon_volcano")
    end
    if GLOBAL.TheWorld.ismastersim and inst.components.buling_cave_manager == nil then
```
### AddStategraphPostInit("wilson")
```lua
-- player's shared DST state graph.
AddStategraphPostInit("wilson", function(sg)
    local attack = sg.states ~= nil and sg.states.attack or nil
    if attack == nil or attack.onenter == nil or attack._buling_attack_wrapped then
        return
    end
    local old_onenter = attack.onenter
    attack.onenter = function(inst, ...)
        old_onenter(inst, ...)
        if inst.prefab == "bulingbuling" then
            inst:PushEvent("buling_attack")
        end
```
### AddPrefabPostInit("rain")
```lua

AddPrefabPostInit("rain", function(inst)
    if GLOBAL.TheNet:IsDedicated() then return end
    inst:DoPeriodicTask(0, function(fx)
        local key = GetBulingEnvironmentKey(GLOBAL.ThePlayer)
        if fx._buling_local_planet_rain then
            local rate = key == "storm" and .9 or (key == "eden" and .35 or 0)
            fx.particles_per_tick = 5 * rate
            fx.splashes_per_tick = 2 * rate
        elseif key ~= nil then
            -- Suppress the home shard's weather renderer inside every
            -- isolated destination. Wet planets use the local renderer above.
```
### AddPrefabPostInit("player_classified")
```lua

AddPrefabPostInit("player_classified", function(inst)
    GLOBAL.require("buling_recovery_pulses").InstallClassified(inst)
    inst.buling_poisonpulse = GLOBAL.net_event(inst.GUID, "buling.poisonpulse")
    inst.buling_storyalerttype = GLOBAL.net_tinybyte(inst.GUID, "buling.storyalerttype")
    inst.buling_storyalertpulse = GLOBAL.net_event(inst.GUID, "buling.storyalertpulse")
    inst.buling_planet_id = GLOBAL.net_tinybyte(inst.GUID,
        "buling.planetid", "buling.planetclockdirty")
    inst.buling_planet_clocktime = GLOBAL.net_float(inst.GUID,
        "buling.planetclocktime", "buling.planetclockdirty")
    inst.buling_planet_clockcycles = GLOBAL.net_uint(inst.GUID,
        "buling.planetclockcycles", "buling.planetclockdirty")
```
### AddPrefabPostInit("slurper")
```lua

AddPrefabPostInit("slurper", function(inst)
    GLOBAL.require("buling_vehicle_cabin").InstallSlurper(inst)
end)

AddClassPostConstruct("widgets/beefbloodover", function(self)
    GLOBAL.require("buling_vehicle_cabin").InstallMountBloodOverlay(self)
end)

AddClassPostConstruct("widgets/healthbadge", function(self)
    local old_OnUpdate = self.OnUpdate
    function self:OnUpdate(dt)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 26 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 7 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。