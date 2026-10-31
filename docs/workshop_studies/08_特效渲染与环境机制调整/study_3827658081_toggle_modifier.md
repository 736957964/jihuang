# 饥荒创意工坊研读报告：toggle_modifier

- **模组标识**：`3827658081`
- **作者**：未知
- **版本**：未声明
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：63 个 Lua 文件 / 共 4609 行；网络变量 0 处；RPC 0 处；注入钩子 0 处

## 一、代码结构与入口分布

顶层目录：`special_range/`

Lua 文件清单（最多 40 条）：

- `keybind.lua`
- `modinfo.lua`
- `modmain.lua`
- `special_range/alterguardian_phase1/init.lua`
- `special_range/alterguardian_phase1/range.lua`
- `special_range/alterguardian_phase1_lunarrift/init.lua`
- `special_range/alterguardian_phase2/init.lua`
- `special_range/alterguardian_phase2/summons.lua`
- `special_range/alterguardian_phase3/init.lua`
- `special_range/alterguardian_phase3/laser.lua`
- `special_range/alterguardian_phase3/outline.lua`
- `special_range/alterguardian_phase3/traps.lua`
- `special_range/alterguardian_phase4_lunarrift/dash.lua`
- `special_range/alterguardian_phase4_lunarrift/init.lua`
- `special_range/alterguardian_phase4_lunarrift/slam.lua`
- `special_range/alterguardian_phase4_lunarrift/supernova.lua`
- `special_range/bearger/init.lua`
- `special_range/bearger/range.lua`
- `special_range/bishop/init.lua`
- `special_range/bishop/range.lua`
- `special_range/charlie_boss/init.lua`
- `special_range/charlie_boss/range.lua`
- `special_range/common.lua`
- `special_range/deerclops/init.lua`
- `special_range/deerclops/range.lua`
- `special_range/eyeofterror/init.lua`
- `special_range/eyeofterror/range.lua`
- `special_range/init.lua`
- `special_range/leif/init.lua`
- `special_range/leif_sparse/init.lua`
- `special_range/minotaur/init.lua`
- `special_range/minotaur/jump.lua`
- `special_range/minotaur/obstacles.lua`
- `special_range/minotaur/range.lua`
- `special_range/minotaur/tentacle.lua`
- `special_range/mutatedbearger/init.lua`
- `special_range/mutatedbearger/range.lua`
- `special_range/mutateddeerclops/init.lua`
- `special_range/mutateddeerclops/range.lua`
- `special_range/mutatedwarg/init.lua`

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