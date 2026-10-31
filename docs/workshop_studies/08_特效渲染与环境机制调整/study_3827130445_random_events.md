# 饥荒创意工坊研读报告：Random Events

- **模组标识**：`3827130445`
- **作者**：M1nX
- **版本**：1.2.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：26 个 Lua 文件 / 共 10451 行；网络变量 10 处；RPC 0 处；注入钩子 4 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/randomevents.lua`
- `scripts/components/randomevents_player.lua`
- `scripts/randomevents/arena.lua`
- `scripts/randomevents/challenge.lua`
- `scripts/randomevents/ev_helpers.lua`
- `scripts/randomevents/events_allies.lua`
- `scripts/randomevents/events_arena.lua`
- `scripts/randomevents/events_base.lua`
- `scripts/randomevents/events_buffs.lua`
- `scripts/randomevents/events_challenges.lua`
- `scripts/randomevents/events_extra.lua`
- `scripts/randomevents/events_items.lua`
- `scripts/randomevents/events_new_a.lua`
- `scripts/randomevents/events_new_c.lua`
- `scripts/randomevents/events_new_d.lua`
- `scripts/randomevents/events_world.lua`
- `scripts/randomevents/util.lua`
- `scripts/randomevents_list.lua`
- `scripts/randomevents_rarity.lua`
- `scripts/widgets/randomevents_banner.lua`
- `scripts/widgets/randomevents_buffs.lua`
- `scripts/widgets/randomevents_challenge.lua`
- `scripts/widgets/randomevents_fx.lua`
- `scripts/widgets/randomevents_timer.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `forest_network` | 1 |
| `AddPrefabPostInit` | `cave_network` | 1 |
| `AddPrefabPostInit` | `forest` | 1 |
| `AddPrefabPostInit` | `cave` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("forest_network")
```lua
end
AddPrefabPostInit("forest_network", AddNetVars)
AddPrefabPostInit("cave_network", AddNetVars)

-- Испытания у каждого игрока свои, поэтому их состояние хранится на самом игроке
AddPlayerPostInit(function(inst)
    inst.re_ch_text   = _G.net_string(inst.GUID, "randomevents.ch_text")     -- задание
    inst.re_ch_time   = _G.net_ushortint(inst.GUID, "randomevents.ch_time")  -- секунд осталось
    inst.re_ch_state  = _G.net_tinybyte(inst.GUID, "randomevents.ch_state")  -- 0 нет, 1 идёт, 2 успех, 3 провал
    inst.re_ch_result = _G.net_string(inst.GUID, "randomevents.ch_result")   -- текст награды/наказания
    inst.re_buffs     = _G.net_string(inst.GUID, "randomevents.buffs")       -- активные эффекты: «группа;секунд;название» построчно

```
### AddPrefabPostInit("cave_network")
```lua
AddPrefabPostInit("forest_network", AddNetVars)
AddPrefabPostInit("cave_network", AddNetVars)

-- Испытания у каждого игрока свои, поэтому их состояние хранится на самом игроке
AddPlayerPostInit(function(inst)
    inst.re_ch_text   = _G.net_string(inst.GUID, "randomevents.ch_text")     -- задание
    inst.re_ch_time   = _G.net_ushortint(inst.GUID, "randomevents.ch_time")  -- секунд осталось
    inst.re_ch_state  = _G.net_tinybyte(inst.GUID, "randomevents.ch_state")  -- 0 нет, 1 идёт, 2 успех, 3 провал
    inst.re_ch_result = _G.net_string(inst.GUID, "randomevents.ch_result")   -- текст награды/наказания
    inst.re_buffs     = _G.net_string(inst.GUID, "randomevents.buffs")       -- активные эффекты: «группа;секунд;название» построчно

    -- На сервере: сохранение эффектов и испытания игрока при перезаходе
```
### AddPrefabPostInit("forest")
```lua
end
AddPrefabPostInit("forest", AddServerComponent)
AddPrefabPostInit("cave", AddServerComponent)

--------------------------------------------------------------------------
-- Интерфейс: таймер и баннер события сверху по центру.
--------------------------------------------------------------------------
local TIMER_ROOTS =
{
    topleft     = { root = "topleft_root",     pos = { 130, -110 } },
    top         = { root = "top_root",         pos = { 0, -40 } },
    bottomright = { root = "bottomright_root", pos = { -130, 160 } },
```
### AddPrefabPostInit("cave")
```lua
AddPrefabPostInit("forest", AddServerComponent)
AddPrefabPostInit("cave", AddServerComponent)

--------------------------------------------------------------------------
-- Интерфейс: таймер и баннер события сверху по центру.
--------------------------------------------------------------------------
local TIMER_ROOTS =
{
    topleft     = { root = "topleft_root",     pos = { 130, -110 } },
    top         = { root = "top_root",         pos = { 0, -40 } },
    bottomright = { root = "bottomright_root", pos = { -130, 160 } },
}
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 10 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。