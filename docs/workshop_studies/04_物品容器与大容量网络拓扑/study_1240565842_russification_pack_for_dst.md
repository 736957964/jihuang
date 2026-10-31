# 饥荒创意工坊研读报告：Russification Pack for DST

- **模组标识**：`1240565842`
- **作者**：Cunning fox, 何も, FruitShake, stew, F0xAn, MrM
- **版本**：3.7.4
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：35 个 Lua 文件 / 共 8857 行；网络变量 0 处；RPC 0 处；注入钩子 4 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/mod_rusification/main.lua`
- `scripts/mod_rusification/mods/archery_mod.lua`
- `scripts/mod_rusification/mods/beefalo_milk.lua`
- `scripts/mod_rusification/mods/defaults_item_pack.lua`
- `scripts/mod_rusification/mods/deluxe_campfires.lua`
- `scripts/mod_rusification/mods/pickle_it.lua`
- `scripts/mod_rusification/mods/steampunk.lua`
- `scripts/mod_rusification/mods/structures_and_more.lua`
- `scripts/mod_rusification/mods/too_many_items.lua`
- `scripts/mod_rusification/mods/waiter_101.lua`
- `scripts/mod_rusification/transl/hawaiian.lua`
- `scripts/mod_rusification/transl/loving_evil.lua`
- `scripts/mod_translator.lua`
- `scripts/po_updater.lua`
- `scripts/prefabs/rlp_fonts.lua`
- `scripts/prefabs/russian_assets.lua`
- `scripts/rlp_debug.lua`
- `scripts/rlp_fonts.lua`
- `scripts/rlp_main.lua`
- `scripts/rlp_mod_support.lua`
- `scripts/rlp_pugna_speech.lua`
- `scripts/rlp_settings.lua`
- `scripts/rlp_speech.lua`
- `scripts/screens/LanguageOptions.lua`
- `scripts/screens/update_screen.lua`
- `scripts/ver_checker.lua`
- `scripts/widgets/discord_btn.lua`
- `scripts/widgets/group_button.lua`
- `scripts/widgets/mod_settings_button.lua`
- `scripts/widgets/rlp_button.lua`
- `scripts/widgets/update_checker.lua`
- `scripts/widgets/vk_button.lua`
- `scripts/widgets/wiki_button.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 1 |
| `AddPrefabPostInit` | `skeleton_player` | 1 |
| `AddPrefabPostInit` | `blueprint` | 1 |
| `AddPrefabPostInit` | `lavaarena_boarlord` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
local after_init_trans = {} --А это функции, которые не подозревают, что в теле мода. Хитрая подстановка переменных.
env.AddPrefabPostInit("world", function(inst)
	for i,fn in ipairs(after_init) do
		fn()
	end
	local s1,s2 = _G, STRINGS --Запоминаем от греха подальше.
	STRINGS = {
		RECIPE_DESC={},
		NAMES = {}, --Эту мы просто пропускаем. Просто лень вырезать это.
		CHARACTERS={
			GENERIC={DESCRIBE={},ACTIONFAIL={}},
			WILLOW={DESCRIBE={}},
```
### AddPrefabPostInit("skeleton_player")
```lua
-- Жуть какая. Столько кода просто для перевода скелета
AddPrefabPostInit("skeleton_player", function(inst)
	local function reassignfn(inst) --функция переопределяет функцию. Туповато, но менять лень
		inst.components.inspectable.Oldgetspecialdescription=inst.components.inspectable.getspecialdescription
		function inst.components.inspectable.getspecialdescription(inst, viewer, ...)
			local oldGetDescription=GetDescription
			GetDescription=function(viewer1, inst1, tag)
				local ret=oldGetDescription(viewer1, inst1, tag)
				ret=t.ParseTranslationTags(ret, inst1.cause, nil, nil)
				return ret
			end
			local message=inst.components.inspectable.Oldgetspecialdescription(inst, viewer, ...)
```
### AddPrefabPostInit("blueprint")
```lua
-- TODO: проверить работу AddPrefabPostInit
AddPrefabPostInit("blueprint", function(inst)
	local function reassignfn(inst)
		if inst.recipetouse then
			local name = STRINGS.NAMES[string.upper(inst.recipetouse)] or STRINGS.NAMES[inst.recipetouse]
			if name then
				name = t.SpeechHashTbl.NAMES.Rus2Eng[name] or name
				inst.components.named:SetName(name.." Blueprint")
			end
		end
	end
	if inst.OnLoad and not inst.OldOnLoad then
```
### AddPrefabPostInit("lavaarena_boarlord")
```lua

	AddPrefabPostInit("lavaarena_boarlord", function(inst)
		local _ontalkfn = inst.components.talker.ontalkfn
		local function OnTalk(inst, data, ...)
			_ontalkfn(inst, data, ...)
			if data ~= nil and data.message ~= nil and inst.speechroot then
				if pugna_sayings[data.message] then
					inst.speechroot.SetBoarloadSpeechString(pugna_sayings[data.message])
				end
			end
		end

```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。