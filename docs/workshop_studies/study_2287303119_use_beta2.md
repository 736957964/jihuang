# 饥荒创意工坊研读报告：use_beta2

- **模组标识**：`2287303119`
- **作者**：冰冰羊, 傳說覺悟, Star, +Serp
- **版本**：0.64.2
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：102 个 Lua 文件 / 共 10242 行；网络变量 8 处；RPC 5 处；注入钩子 7 处

## 一、代码结构与入口分布

顶层目录：`main/`、`scripts/`、`utils/`

Lua 文件清单（最多 40 条）：

- `main/buffs_timers.lua`
- `main/change_modsettings.lua`
- `main/check_mods.lua`
- `main/hint_system.lua`
- `main/item_highlight.lua`
- `main/language.lua`
- `main/renderers.lua`
- `main/showme_naughtiness.lua`
- `main/showme_range_indicators.lua`
- `main/temperature_client.lua`
- `main/tile_utils.lua`
- `modinfo.lua`
- `modmain.lua`
- `modmain2.lua`
- `scripts/prefabs/showme_range.lua`
- `scripts/showme_descriptors/appeasement.lua`
- `scripts/showme_descriptors/armor.lua`
- `scripts/showme_descriptors/beerpower.lua`
- `scripts/showme_descriptors/childspawner.lua`
- `scripts/showme_descriptors/combat.lua`
- `scripts/showme_descriptors/compostingbin.lua`
- `scripts/showme_descriptors/cooldown.lua`
- `scripts/showme_descriptors/crop.lua`
- `scripts/showme_descriptors/domesticatable.lua`
- `scripts/showme_descriptors/dryer.lua`
- `scripts/showme_descriptors/dryingrack.lua`
- `scripts/showme_descriptors/edible.lua`
- `scripts/showme_descriptors/equippable.lua`
- `scripts/showme_descriptors/farmplantstress.lua`
- `scripts/showme_descriptors/fertilizer.lua`
- `scripts/showme_descriptors/finiteuses.lua`
- `scripts/showme_descriptors/follower.lua`
- `scripts/showme_descriptors/friendlevels.lua`
- `scripts/showme_descriptors/fuel.lua`
- `scripts/showme_descriptors/fueled.lua`
- `scripts/showme_descriptors/gaspower.lua`
- `scripts/showme_descriptors/growable.lua`
- `scripts/showme_descriptors/harvestable.lua`
- `scripts/showme_descriptors/healer.lua`
- `scripts/showme_descriptors/health.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 3 |
| `AddComponentPostInit` | `farming_manager` | 2 |
| `AddPrefabPostInit` | `player_classified` | 2 |
| `AddPrefabPostInit` | `shadow_battleaxe` | 1 |
| `AddPrefabPostInit` | `inventory_classified` | 1 |
| `AddPrefabPostInit` | `gelblob_storage` | 1 |
| `AddComponentPostInit` | `kramped` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
local world_state
AddPrefabPostInit("world",function(inst)
    world_state = inst.state
end)

--容器
local function GetPerishTime(inst, c)
    local modifier = 1
    local owner = c.inventoryitem and c.inventoryitem.owner or nil
    if not owner and c.occupier then
        owner = c.occupier:GetOwner() --Для птичек?
    end
```
### AddComponentPostInit("farming_manager")
```lua
local farming_manager
AddComponentPostInit("farming_manager", function(self)
    if not (_G.TheWorld and _G.TheWorld.ismastersim) then return end
    farming_manager = self
    self.inst:ListenForEvent("worldmapsetsize", function(...)
        _nutrientgrid = Upvaluehelper.GetUpvalue(self.OnSave, "_nutrientgrid")
        _moisturegrid = Upvaluehelper.GetUpvalue(self.OnSave, "_moisturegrid")
        _drinkersgrid = Upvaluehelper.GetUpvalue(self.GetDebugString, "_drinkersgrid")
        _overlaygrid = Upvaluehelper.GetUpvalue(self.GetDebugString, "_overlaygrid")
    end)
end)

```
### AddPrefabPostInit("player_classified")
```lua
    -- showme_hint2 => "showme_hintbua." -- hash value: 78865, Ratio: 0.000078865
    AddPrefabPostInit("player_classified",function(inst)
        inst.showme_hint2 = ""
        inst.net_showme_hint2 = _G.net_string(inst.GUID, "showme_hintbua.", "showme_hint_dirty2")
        if show_naughtiness then
            inst.net_showme_kramped = {
                actions = _G.net_smallbyte(inst.GUID, "showme_kramped_actions", "showme_kramped_dirty"),
                threshold = _G.net_smallbyte(inst.GUID, "showme_kramped_threshold", "showme_kramped_dirty"),
            }
        end
        if CLIENT_SIDE then
            inst:ListenForEvent("showme_hint_dirty2",function(inst)
```
### AddPrefabPostInit("shadow_battleaxe")
```lua
    local max_level = #TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS
    AddPrefabPostInit("shadow_battleaxe", function(inst)
        inst.GetShowItemInfo = function()
            -- How many bosses we've killed on this threshold level.
            local this_level_boss_kills = 0
            -- The number of bosses that need to be killed to reach the next level.
            local boss_kills_for_next_level = 0
            if inst.level < max_level then
                this_level_boss_kills = inst.epic_kill_count - TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[inst.level]
                boss_kills_for_next_level = TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[inst.level + 1] - TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[inst.level]
            end
            local level_string = string.format(o_t.level .. "%s / %s",
```
### AddPrefabPostInit("inventory_classified")
```lua
        end
        AddPrefabPostInit("inventory_classified",function(inst)
            inst:ListenForEvent("activedirty", function(inst)
                --print("ACTIVE:",inst._active:value())
                _active = inst._active:value()
                _ing_prefab = nil --一旦拿走物品，配方就会立刻被遗忘。
                UpdateAllChestsAround() --会为每个活动物品或其取消的物品重新绘制所有箱子。
            end)
        end)

        local _ing_task
        local function UpdateIngredientView(player, prefab)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 8 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 5 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。