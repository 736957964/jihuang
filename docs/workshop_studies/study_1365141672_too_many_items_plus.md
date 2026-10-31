# 饥荒创意工坊研读报告：Too Many Items Plus

- **模组标识**：`1365141672`
- **作者**：CJB,GaRAnTuLA,Skull,TheMightyPikachu,Electroely,Tendy,乐十画
- **版本**：1.1.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：50 个 Lua 文件 / 共 422 行；网络变量 0 处；RPC 0 处；注入钩子 0 处

## 一、代码结构与入口分布

顶层目录：`language/`、`scripts/`

Lua 文件清单（最多 40 条）：

- `language/Stringslocalization_br.lua`
- `language/Stringslocalization_chs.lua`
- `language/Stringslocalization_cht.lua`
- `language/Stringslocalization_en.lua`
- `language/Stringslocalization_ru.lua`
- `language/Translation_template(CHS).lua`
- `language/Translation_template(EN).lua`
- `modinfo.lua`
- `modinfo_chs.lua`
- `modinfo_cht.lua`
- `modmain.lua`
- `scripts/TMIP/debug.lua`
- `scripts/TMIP/itemlistcontrol.lua`
- `scripts/TMIP/list/itemlist_animal.lua`
- `scripts/TMIP/list/itemlist_base.lua`
- `scripts/TMIP/list/itemlist_beta.lua`
- `scripts/TMIP/list/itemlist_boss.lua`
- `scripts/TMIP/list/itemlist_building.lua`
- `scripts/TMIP/list/itemlist_clothes.lua`
- `scripts/TMIP/list/itemlist_cooking.lua`
- `scripts/TMIP/list/itemlist_den.lua`
- `scripts/TMIP/list/itemlist_equip.lua`
- `scripts/TMIP/list/itemlist_event.lua`
- `scripts/TMIP/list/itemlist_farming.lua`
- `scripts/TMIP/list/itemlist_follower.lua`
- `scripts/TMIP/list/itemlist_food.lua`
- `scripts/TMIP/list/itemlist_gift.lua`
- `scripts/TMIP/list/itemlist_magic.lua`
- `scripts/TMIP/list/itemlist_material.lua`
- `scripts/TMIP/list/itemlist_natural.lua`
- `scripts/TMIP/list/itemlist_ore.lua`
- `scripts/TMIP/list/itemlist_plant.lua`
- `scripts/TMIP/list/itemlist_props.lua`
- `scripts/TMIP/list/itemlist_puppet.lua`
- `scripts/TMIP/list/itemlist_rot.lua`
- `scripts/TMIP/list/itemlist_ruins.lua`
- `scripts/TMIP/list/itemlist_sculpture.lua`
- `scripts/TMIP/list/itemlist_seeds.lua`
- `scripts/TMIP/list/itemlist_tool.lua`
- `scripts/TMIP/menu.lua`

## 二、注入钩子清单（真实提取）

未检测到标准 PostInit 系列钩子。

## 三、关键代码片段

```lua
-- 该 MOD 未使用标准 PostInit 钩子，多为资源/配置型改动
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。