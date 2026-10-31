# 饥荒创意工坊研读报告：鸣潮：爱弥斯扩展 (Wuthering Waves: Aemeath Expansion)

- **模组标识**：`3828900356`
- **作者**：LR
- **版本**：0.9.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：32 个 Lua 文件 / 共 7973 行；网络变量 5 处；RPC 2 处；注入钩子 5 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/aemeath_arrival_state.lua`
- `scripts/aemeath_attack_events.lua`
- `scripts/aemeath_character_tile.lua`
- `scripts/aemeath_dialogue_events.lua`
- `scripts/aemeath_flight.lua`
- `scripts/aemeath_flight_client.lua`
- `scripts/aemeath_hit_feedback.lua`
- `scripts/aemeath_inspect_portrait.lua`
- `scripts/aemeath_modeguards.lua`
- `scripts/aemeath_modestates.lua`
- `scripts/aemeath_morningstar_state.lua`
- `scripts/aemeath_morningstar_targeting.lua`
- `scripts/aemeath_native_weapon_grip.lua`
- `scripts/aemeath_polestar_glow.lua`
- `scripts/aemeath_portrait_card.lua`
- `scripts/aemeath_ui_v11.lua`
- `scripts/aemeath_work_controls.lua`
- `scripts/components/aemeath_ghost.lua`
- `scripts/components/aemeath_mech.lua`
- `scripts/components/aemeath_skill.lua`
- `scripts/prefabs/aemeath.lua`
- `scripts/prefabs/aemeath_arrival_fx.lua`
- `scripts/prefabs/aemeath_morningstar_flash.lua`
- `scripts/prefabs/aemeath_morningstar_reticule.lua`
- `scripts/prefabs/aemeath_none.lua`
- `scripts/prefabs/tunneler_mech.lua`
- `scripts/prefabs/wuwa_eternalflow.lua`
- `scripts/prefabs/wuwa_polestar.lua`
- `scripts/speech_aemeath.lua`
- `scripts/widgets/aemeath_hungerbadge.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `combat` | 3 |
| `AddComponentPostInit` | `playercontroller` | 2 |
| `AddComponentPostInit` | `aemeath_skill` | 1 |
| `AddComponentPostInit` | `inventory` | 1 |
| `AddPrefabPostInit` | `sword_lunarplant` | 1 |

## 三、关键代码片段

### AddComponentPostInit("combat")
```lua

AddComponentPostInit("combat", function(self)
    local old_calcdamage = self.CalcDamage
    self.CalcDamage = function(self, target, weapon, multiplier)
        local dmg, spdmg = old_calcdamage(self, target, weapon, multiplier)
        -- spdmg 是 SpDamageUtil 的 table（{planar=N}），不是数字，必须按表合并
        if self.inst ~= nil
            and self.inst:HasTag("aemeath_mech")
            and dmg ~= nil
            and dmg > 0 then
            local bonus = self.inst._aemeath_skill_planar or 0.15
            spdmg = SpDamageUtil.MergeSpDamage(spdmg, { planar = dmg * bonus })
```
### AddComponentPostInit("playercontroller")
```lua
modimport("scripts/aemeath_flight_client.lua")
AddComponentPostInit("playercontroller", require("aemeath_work_controls"))
AddPlayerPostInit(function(inst)
    if inst.prefab == "aemeath" and not TheNet:IsDedicated() then
        inst.CreateHungerBadge = function(owner)
            return require("widgets/aemeath_hungerbadge")(owner)
        end
    end
end)

modimport("scripts/aemeath_ui_v11.lua")

```
### AddComponentPostInit("aemeath_skill")
```lua
end)
AddComponentPostInit("aemeath_skill",function(self)
    -- Components are constructed before SpawnPrefab assigns inst.prefab.
    -- common_postinit has already added the character tag at this point.
    if not self.inst:HasTag("aemeath") then return end
    local blink=self.Blink
    self.Blink=function(skill,...)
        local success,reason=blink(skill,...)
        if success then Say(skill.inst,"ANNOUNCE_AEMEATH_BLINK") end
        return success,reason
    end
end)
```
### AddComponentPostInit("inventory")
```lua

AddComponentPostInit("inventory", function(self)
    local equip = self.Equip
    self.Equip = function(inv, item, ...)
        local mech = inv.inst.components.aemeath_mech
        if mech ~= nil and mech:IsActive() and item ~= mech.weapon then return false end
        local result = equip(inv, item, ...)
        -- Normal tools must retain native mouse work/attack routing. Only the
        -- two skill weapons may opt into the CASTAOE reticule input path.
        if inv.inst:HasTag("aemeath") and item ~= nil
            and (item.prefab == "wuwa_polestar" or item.prefab == "wuwa_eternalflow")
            and item.components.aoetargeting ~= nil then
```
### AddPrefabPostInit("sword_lunarplant")
```lua

AddPrefabPostInit("sword_lunarplant", function(inst)
    if not TheWorld.ismastersim then return end
    local function SetHold(aligned)
        for index, fx in ipairs({ inst.blade1, inst.blade2 }) do
            if fx ~= nil and fx:IsValid() then
                if aligned or fx._aemeath_grip_aligned then
                    local time = fx.AnimState:GetCurrentAnimationTime()
                    fx.AnimState:SetBank(aligned and "aemeath_sword_lunarplant_hold" or "sword_lunarplant")
                    fx.AnimState:PlayAnimation(index == 1 and "swap_loop1" or "swap_loop2", true)
                    fx.AnimState:SetTime(time)
                    fx._aemeath_grip_aligned = aligned or nil
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 5 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 2 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。