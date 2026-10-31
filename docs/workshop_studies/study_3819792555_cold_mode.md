# 饥荒创意工坊研读报告：cold_mode

- **模组标识**：`3819792555`
- **作者**：未知
- **版本**：1.1.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：31 个 Lua 文件 / 共 3361 行；网络变量 9 处；RPC 3 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `modservercreationmain.lua`
- `scripts/components/dukefishron_passives.lua`
- `scripts/components/dukefishron_skills.lua`
- `scripts/dukefishron_bubbles.lua`
- `scripts/dukefishron_dash.lua`
- `scripts/dukefishron_dashfx.lua`
- `scripts/dukefishron_heatover.lua`
- `scripts/dukefishron_locale.lua`
- `scripts/dukefishron_rules.lua`
- `scripts/dukefishron_skilldefs.lua`
- `scripts/dukefishron_skillhud.lua`
- `scripts/dukefishron_skilltext.lua`
- `scripts/dukefishron_targets.lua`
- `scripts/dukefishron_temperature.lua`
- `scripts/dukefishron_tornadoes.lua`
- `scripts/dukefishron_waterwalk.lua`
- `scripts/prefabs/dukefishron.lua`
- `scripts/prefabs/dukefishron_bubble.lua`
- `scripts/prefabs/dukefishron_bubble_splash.lua`
- `scripts/prefabs/dukefishron_dash_hit.lua`
- `scripts/prefabs/dukefishron_none.lua`
- `scripts/prefabs/dukefishron_tornado.lua`
- `scripts/prefabs/tuffle_worm.lua`
- `scripts/speech_dukefishron.lua`
- `scripts/speech_dukefishron_en.lua`
- `scripts/speech_dukefishron_zh.lua`
- `scripts/widgets/dukefishron_roundpanel.lua`
- `scripts/widgets/dukefishron_skillbar.lua`
- `scripts/widgets/dukefishron_skilltip.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 1 |
| `AddPrefabPostInit` | `oasislake` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua
local TemperatureRules = GLOBAL.require("dukefishron_temperature")
AddStategraphPostInit("wilson", TemperatureRules.InstallIdle)
GLOBAL.TUNING.DUKEFISHRON_HUNGER = 250
GLOBAL.TUNING.DUKEFISHRON_SANITY = 125

PrefabFiles = { "dukefishron", "dukefishron_none", "tuffle_worm", "dukefishron_dash_hit", "dukefishron_bubble", "dukefishron_bubble_splash", "dukefishron_tornado" }

Assets = {}
Assets[#Assets + 1] = Asset("ANIM", "anim/recharge_meter.zip")
Assets[#Assets + 1] = Asset("ATLAS", "images/button_icons.xml")
Assets[#Assets + 1] = Asset("IMAGE", "images/button_icons.tex")
local atlases = {
```
### AddPrefabPostInit("oasislake")
```lua
local Waterwalk = GLOBAL.require("dukefishron_waterwalk")
AddPrefabPostInit("oasislake", Waterwalk.OasisPostInit)
for _, pond in ipairs({ "pond", "pond_mos", "pond_cave" }) do
    AddPrefabPostInit(pond, Waterwalk.PondPostInit)
end
GLOBAL.TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.DUKEFISHRON = {
    "icehat", "blue_cap", "blue_cap", "blue_cap",
}
STRINGS.NAMES.TUFFLE_WORM = L.Text("松露虫", "Truffle Worm")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TUFFLE_WORM = L.Text("很有营养，但这味道实在难以接受。", "Nutritious, but that taste is hard to stomach.")
STRINGS.RECIPE_DESC.TUFFLE_WORM = L.Text("猪鲨眼中的珍馐美味。", "A delicacy fit for Duke Fishron.")
-- Load after shared item strings; custom speech owns a separate fallback copy.
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 9 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 3 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。