# 饥荒创意工坊研读报告：Too Many Items Rearranged

- **模组标识**：`3638290455`
- **作者**：未知
- **版本**：1.7.4
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：187 个 Lua 文件 / 共 62021 行；网络变量 0 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`language/`、`scripts/`、`tests/`

Lua 文件清单（最多 40 条）：

- `language/TMIR_cn_circle_commands.lua`
- `language/TMIR_cn_debug_commands.lua`
- `language/TMIR_cn_item_commands.lua`
- `language/TMIR_cn_names.lua`
- `language/TMIR_cn_ui.lua`
- `language/TMIR_en_circle_commands.lua`
- `language/TMIR_en_debug_commands.lua`
- `language/TMIR_en_item_commands.lua`
- `language/TMIR_en_names.lua`
- `language/TMIR_en_ui.lua`
- `language/TMIR_ru_circle_commands.lua`
- `language/TMIR_ru_debug_commands.lua`
- `language/TMIR_ru_item_commands.lua`
- `language/TMIR_ru_names.lua`
- `language/TMIR_ru_ui.lua`
- `modinfo.lua`
- `modmain.lua`
- `scripts/TMIR/circle_button_list.lua`
- `scripts/TMIR/circle_commands/characters/command_beard.lua`
- `scripts/TMIR/circle_commands/characters/command_walter.lua`
- `scripts/TMIR/circle_commands/characters/command_wendy.lua`
- `scripts/TMIR/circle_commands/characters/command_wigfrid.lua`
- `scripts/TMIR/circle_commands/characters/command_wolfgang.lua`
- `scripts/TMIR/circle_commands/characters/command_woody.lua`
- `scripts/TMIR/circle_commands/characters/command_wormwood.lua`
- `scripts/TMIR/circle_commands/characters/command_wurt.lua`
- `scripts/TMIR/circle_commands/characters/command_wx78.lua`
- `scripts/TMIR/circle_commands/circle_commands_common.lua`
- `scripts/TMIR/circle_commands/common/commands_aoeattack.lua`
- `scripts/TMIR/circle_commands/common/commands_armormode.lua`
- `scripts/TMIR/circle_commands/common/commands_clearbackpack.lua`
- `scripts/TMIR/circle_commands/common/commands_cleardebuff.lua`
- `scripts/TMIR/circle_commands/common/commands_clearinventory.lua`
- `scripts/TMIR/circle_commands/common/commands_creativemode.lua`
- `scripts/TMIR/circle_commands/common/commands_critwork.lua`
- `scripts/TMIR/circle_commands/common/commands_forgetfood.lua`
- `scripts/TMIR/circle_commands/common/commands_ghostmode.lua`
- `scripts/TMIR/circle_commands/common/commands_godmode.lua`
- `scripts/TMIR/circle_commands/common/commands_health.lua`
- `scripts/TMIR/circle_commands/common/commands_healthlock.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `charlie_heckler` | 1 |
| `AddComponentPostInit` | `playerhearing` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("charlie_heckler")
```lua
-- tmir_payload.lua before calling Talker:Say.
AddPrefabPostInit("charlie_heckler", function(inst)
    local talker = inst.components ~= nil and inst.components.talker or nil
    if talker == nil or talker._tmir_dps_style_wrapped then
        return
    end

    local original_say = talker.Say
    talker._tmir_dps_style_wrapped = true
    talker.Say = function(self, script, ...)
        if inst:HasTag("TMIR_DPS_FEEDBACK_SPEAKER") then
            MarkDpsSpeakerStyleReady(inst)
```
### AddComponentPostInit("playerhearing")
```lua

AddComponentPostInit("playerhearing", function(self)
    local old_OnRemoveFromEntity = self.OnRemoveFromEntity

    function self:OnRemoveFromEntity()
        TMIR_RemovePlayerHearingListeners(self.inst)

        if old_OnRemoveFromEntity ~= nil then
            return old_OnRemoveFromEntity(self)
        end
    end
end)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。