# 饥荒创意工坊研读报告：装备快捷栏 Equip Quick Slots

- **模组标识**：`3828629465`
- **作者**：lingzhi
- **版本**：1.1.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：6 个 Lua 文件 / 共 2269 行；网络变量 3 处；RPC 7 处；注入钩子 0 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/equipquickslot.lua`
- `scripts/components/equipquickslot_replica.lua`
- `scripts/prefabs/equipquickslot_classified.lua`
- `scripts/widgets/equipquickslots.lua`

## 二、注入钩子清单（真实提取）

未检测到标准 PostInit 系列钩子。

## 三、关键代码片段

```lua
-- 该 MOD 未使用标准 PostInit 钩子，多为资源/配置型改动
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 3 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 7 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。