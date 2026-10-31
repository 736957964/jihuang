# 饥荒创意工坊研读报告：gd_language

- **模组标识**：`3828925092`
- **作者**：Bishop
- **版本**：1.2.27
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：114 个 Lua 文件 / 共 52846 行；网络变量 21 处；RPC 3 处；注入钩子 20 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/brains/friend_hand_brain.lua`
- `scripts/brains/friend_horn_brain.lua`
- `scripts/brains/friend_mouth_brain.lua`
- `scripts/brains/friend_wing_brain.lua`
- `scripts/brains/shadowwaxwellbrain_void.lua`
- `scripts/character_assets.lua`
- `scripts/components/gd_extended_eater.lua`
- `scripts/components/pocketwatch_shrouden_fx.lua`
- `scripts/components/shrouden_aurainverter.lua`
- `scripts/components/shrouden_clawborn.lua`
- `scripts/components/shrouden_combat.lua`
- `scripts/components/shrouden_dreadbuff.lua`
- `scripts/components/shrouden_hiddenstate.lua`
- `scripts/components/shrouden_hook_tetherer.lua`
- `scripts/components/shrouden_shadowpower.lua`
- `scripts/components/shrouden_shadowpower_replica.lua`
- `scripts/components/shrouden_shroud.lua`
- `scripts/components/shrouden_spellwheel.lua`
- `scripts/components/shrouden_stealth_state.lua`
- `scripts/components/shrouden_traits.lua`
- `scripts/components/shrouden_vision.lua`
- `scripts/components/shrouden_vision_replica.lua`
- `scripts/components_replica/shrouden_shadowpower.lua`
- `scripts/components_replica/shrouden_vision.lua`
- `scripts/hooks/alter_lunacy_ui.lua`
- `scripts/hooks/shrouden_shadowpower_ui.lua`
- `scripts/inventory_assets.lua`
- `scripts/languages/speech_c_alter.lua`
- `scripts/languages/speech_c_alter_chs.lua`
- `scripts/languages/speech_c_alter_en.lua`
- `scripts/languages/speech_c_shrouden_chs.lua`
- `scripts/languages/speech_c_shrouden_en.lua`
- `scripts/languages/strings_chs.lua`
- `scripts/languages/strings_en.lua`
- `scripts/main/changes.lua`
- `scripts/main/custom_spin_init.lua`
- `scripts/main/gd_assets.lua`
- `scripts/main/gd_character_ingredients.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 8 |
| `AddStategraphPostInit` | `wilson_client` | 6 |
| `AddPrefabPostInit` | `c_shrouden` | 2 |
| `AddComponentPostInit` | `playercontroller` | 2 |
| `AddPrefabPostInit` | `gestalt` | 1 |
| `AddPrefabPostInit` | `gestalt_guard` | 1 |
| `AddComponentPostInit` | `spellbook` | 1 |
| `AddPrefabPostInit` | `vault_decon_mister` | 1 |
| `AddPrefabPostInit` | `mindcontroller` | 1 |
| `AddPrefabPostInit` | `nightmarefuel` | 1 |
| `AddPrefabPostInit` | `horrorfuel` | 1 |
| `AddPrefabPostInit` | `waxwell_shadow_book_fx` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua
----------------------------------------------------------------
AddStategraphPostInit("wilson", function(sg)
    -- 拦截普通 idle 状态（阻止抱头、难受等启蒙动作）
    local old_idle_onenter = sg.states["idle"].onenter
    sg.states["idle"].onenter = function(inst, pushanim)
        if inst.prefab == C_ALTER_PREFAB and inst.components.sanity then
            local old_IsEnlightened = inst.components.sanity.IsEnlightened
            inst.components.sanity.IsEnlightened = function() return false end
            
            old_idle_onenter(inst, pushanim)
            
            inst.components.sanity.IsEnlightened = old_IsEnlightened
```
### AddStategraphPostInit("wilson_client")
```lua
-- 客户端：注入预测状态
AddStategraphPostInit("wilson_client", function(sg)
    SGcustom_spin.AddClientStates(sg.states)

    local attack_handler = sg.actionhandlers[GLOBAL.ACTIONS.ATTACK]
    if attack_handler ~= nil then
        local _old_deststate = attack_handler.deststate
        attack_handler.deststate = function(inst, action)
            local combat = inst.replica.combat
            local weapon = combat and combat:GetWeapon()
            if weapon ~= nil and weapon.prefab == YOUR_WEAPON_NAME and action.target then
                if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or GLOBAL.IsEntityDead(inst)) then
```
### AddPrefabPostInit("c_shrouden")
```lua
-- 原版展示钩子在接收端解析稳定消息，避免服务器语言覆盖客机提示。
AddPrefabPostInit("c_shrouden", function(inst)
    local talker = inst.components.talker
    if talker ~= nil and not talker._gd_language_installed then
        talker._gd_language_installed = true
        local previous = talker.mod_str_fn
        talker.mod_str_fn = function(message)
            if message == G.STRINGS.GODS_DOWNFALL.NETWORK.NO_SHADOWPOWER then
                message = G.STRINGS.GODS_DOWNFALL.TEXT.NO_SHADOWPOWER
            end
            if previous ~= nil then
                return previous(message)
```
### AddComponentPostInit("playercontroller")
```lua

AddComponentPostInit("playercontroller", function(self)

    local old_left = self.OnRemoteLeftClick

    self.OnRemoteLeftClick = function(pc, actioncode, position, target, isreleased, controlmodscode, noforce, mod_name, spellbook, spell_id)

        if spellbook ~= pc.inst or not pc.inst:HasTag("c_shrouden") then

            return old_left(pc, actioncode, position, target, isreleased, controlmodscode, noforce, mod_name, spellbook, spell_id)

        end
```
### AddPrefabPostInit("gestalt")
```lua
----------------------------------------------------------------
AddPrefabPostInit("gestalt", function(inst)
    if not GLOBAL.TheWorld or not GLOBAL.TheWorld.ismastersim then
        return
    end

    GLOBAL.MakeFeedableSmallLivestockPristine(inst)
    if inst.components.combat then
        inst.components.combat:SetRetargetFunction(1, function()
            -- 如果没有追踪目标、处于冷却或距离太远，不作为目标
            if inst.tracking_target == nil
                or inst.components.combat:InCooldown()
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 21 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 3 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。