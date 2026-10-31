# 饥荒创意工坊研读报告：GLINA & FORKISS — Inkbound

- **模组标识**：`3828411229`
- **作者**：Glina & Forkiss concept by the user; implementation and new assets with Codex
- **版本**：0.9.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：20 个 Lua 文件 / 共 1037 行；网络变量 4 处；RPC 1 处；注入钩子 0 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/gf_artist.lua`
- `scripts/components/gf_tool.lua`
- `scripts/gf/actions.lua`
- `scripts/gf/character.lua`
- `scripts/gf/defs.lua`
- `scripts/gf/frontend.lua`
- `scripts/gf/localization.lua`
- `scripts/gf/recipes.lua`
- `scripts/gf/rules.lua`
- `scripts/gf/strings_en.lua`
- `scripts/gf/strings_ru.lua`
- `scripts/gf/util.lua`
- `scripts/prefabs/forkiss.lua`
- `scripts/prefabs/gf_fx.lua`
- `scripts/prefabs/gf_items.lua`
- `scripts/prefabs/gf_skins.lua`
- `scripts/prefabs/glina.lua`
- `scripts/widgets/gf_badge.lua`

## 二、注入钩子清单（真实提取）

未检测到标准 PostInit 系列钩子。

## 三、关键代码片段

```lua
-- 该 MOD 未使用标准 PostInit 钩子，多为资源/配置型改动
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 4 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。