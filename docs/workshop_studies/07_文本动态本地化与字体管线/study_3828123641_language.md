# 饥荒创意工坊研读报告：language

- **模组标识**：`3828123641`
- **作者**：Бобер
- **版本**：4.7.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：47 个 Lua 文件 / 共 19564 行；网络变量 51 处；RPC 30 处；注入钩子 8 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/bb_client.lua`
- `scripts/bb_driving.lua`
- `scripts/bb_lang.lua`
- `scripts/bb_quiz.lua`
- `scripts/bb_recipes.lua`
- `scripts/bb_spacechoices.lua`
- `scripts/bb_squad.lua`
- `scripts/bb_states.lua`
- `scripts/bb_tuning.lua`
- `scripts/brains/bb_antonbrain.lua`
- `scripts/brains/bb_pigeonbrain.lua`
- `scripts/components/bb_carmodule.lua`
- `scripts/components/bb_karate.lua`
- `scripts/components/bb_officer.lua`
- `scripts/components/bb_pigeongear.lua`
- `scripts/components/bb_pressure.lua`
- `scripts/components/bb_rideseat.lua`
- `scripts/components/bb_spaceflight.lua`
- `scripts/components/bb_vehicle.lua`
- `scripts/lang/bb_en.lua`
- `scripts/lang/bb_uk.lua`
- `scripts/prefabs/bb_creatures.lua`
- `scripts/prefabs/bb_devices.lua`
- `scripts/prefabs/bb_fx.lua`
- `scripts/prefabs/bb_items.lua`
- `scripts/prefabs/bb_loot.lua`
- `scripts/prefabs/bb_stations.lua`
- `scripts/prefabs/bb_structures.lua`
- `scripts/prefabs/bb_vadim.lua`
- `scripts/prefabs/bb_vehicle.lua`
- `scripts/prefabs/blobfish.lua`
- `scripts/prefabs/blobfish_none.lua`
- `scripts/prefabs/golub.lua`
- `scripts/prefabs/golub_none.lua`
- `scripts/prefabs/kaban.lua`
- `scripts/prefabs/kaban_none.lua`
- `scripts/screens/bb_codex.lua`
- `scripts/screens/bb_dashgame.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `builder` | 1 |
| `AddComponentPostInit` | `armor` | 1 |
| `AddBrainPostInit` | `birdbrain` | 1 |
| `AddBrainPostInit` | `pigbrain` | 1 |
| `AddPrefabPostInit` | `pigman` | 1 |
| `AddComponentPostInit` | `playeractionpicker` | 1 |
| `AddStategraphPostInit` | `wilson` | 1 |
| `AddStategraphPostInit` | `wilson_client` | 1 |

## 三、关键代码片段

### AddComponentPostInit("builder")
```lua

AddComponentPostInit("builder", function(self, inst)
    local _DoBuild = self.DoBuild
    function self:DoBuild(recname, pt, rotation, skin, ...)
        -- a plain roll every time: no counters, no streak protection
        if self.inst:HasTag("golub") and not self.freebuildmode and math.random() <= TUNING.BB.CRAFT_FAIL_CHANCE then
            local recipe = _G.GetValidRecipe(recname)
            if recipe ~= nil and (self:IsBuildBuffered(recname) or self:HasIngredients(recipe)) then
                -- the attempt fails after the normal crafting animation; ~30% of each ingredient is spoiled
                local inv = self.inst.components.inventory
                if not self:IsBuildBuffered(recname) and inv ~= nil then
                    for _, ing in ipairs(recipe.ingredients) do
```
### AddComponentPostInit("armor")
```lua

AddComponentPostInit("armor", function(self, inst)
    local _TakeDamage = self.TakeDamage
    function self:TakeDamage(damage_amount, ...)
        local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner or nil
        if owner ~= nil and owner:HasTag("kaban") and damage_amount ~= nil then
            damage_amount = damage_amount * TUNING.BB.ARMOR_WEAR
        end
        return _TakeDamage(self, damage_amount, ...)
    end
end)

```
### AddBrainPostInit("birdbrain")
```lua

AddBrainPostInit("birdbrain", function(brain)
    WalkTree(brain.bt ~= nil and brain.bt.root or nil, function(node)
        if node.name == "Threat Near" and node.fn ~= nil then
            node.fn = function() return BirdThreatNear(brain.inst) end
        end
    end)
end)

local function PigAngryAt(pig, kaban)
    local c = pig.components.combat
    if c ~= nil and c.target == kaban then return true end
```
### AddBrainPostInit("pigbrain")
```lua

AddBrainPostInit("pigbrain", function(brain)
    WalkTree(brain.bt ~= nil and brain.bt.root or nil, function(node)
        if node.huntertags ~= nil and node.huntertags[1] == "player" and #node.huntertags == 1 then
            local old = node.shouldrunfn
            node.shouldrunfn = function(hunter, inst)
                if hunter:HasTag("kaban") and not PigAngryAt(inst, hunter) then return false end
                return old == nil or old(hunter, inst)
            end
        end
    end)
end)
```
### AddPrefabPostInit("pigman")
```lua

AddPrefabPostInit("pigman", function(inst)
    if not _G.TheWorld.ismastersim then return end
    -- remembered for a while: a pig Kaban struck keeps its distance and fights like a pig would
    inst:ListenForEvent("attacked", function(i, data)
        if data ~= nil and data.attacker ~= nil and data.attacker:HasTag("kaban") then
            i.bb_kabanhit = _G.GetTime() + 120
        end
    end)
end)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 51 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 30 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。