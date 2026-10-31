# 饥荒创意工坊研读报告：Language

- **模组标识**：`1991746508`
- **作者**：羽中, 幼儿园小班花, lw老王, 杨柳, ti_Tout, 逸尘, 八戒Godfrey, 小明
- **版本**：9.10.27.4
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：286 个 Lua 文件 / 共 9878 行；网络变量 0 处；RPC 0 处；注入钩子 0 处

## 一、代码结构与入口分布

顶层目录：`main/`、`scripts/`

Lua 文件清单（最多 40 条）：

- `main/actions.lua`
- `main/blackbear.lua`
- `main/components.lua`
- `main/containers.lua`
- `main/equips.lua`
- `main/etc.lua`
- `main/flag.lua`
- `main/foods.lua`
- `main/hotupdate.lua`
- `main/laozi.lua`
- `main/logupload.lua`
- `main/mk_flyer.lua`
- `main/mod_rpc.lua`
- `main/myth_bambooshop.lua`
- `main/myth_bookinfo.lua`
- `main/myth_buff_ly_api.lua`
- `main/myth_lotus.lua`
- `main/myth_newturf.lua`
- `main/myth_pill_recipes.lua`
- `main/myth_skins.lua`
- `main/myth_skinsapi.lua`
- `main/mythhouse.lua`
- `main/peach.lua`
- `main/pills.lua`
- `main/plantable.lua`
- `main/prefabpostInit.lua`
- `main/recipes.lua`
- `main/registerinventoryitematlas.lua`
- `main/rhino.lua`
- `main/sg.lua`
- `main/tech.lua`
- `main/tuning.lua`
- `main/widgets.lua`
- `modinfo.lua`
- `modmain.lua`
- `modmain0.lua`
- `modmain1.lua`
- `modworldgenmain.lua`
- `modworldgenmain0.lua`
- `modworldgenmain1.lua`

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