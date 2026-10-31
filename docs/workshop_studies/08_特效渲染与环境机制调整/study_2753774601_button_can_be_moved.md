# 饥荒创意工坊研读报告：button_can_be_moved

- **模组标识**：`2753774601`
- **作者**：未知
- **版本**：未声明
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：11 个 Lua 文件 / 共 1880 行；网络变量 2 处；RPC 4 处；注入钩子 0 处

## 一、代码结构与入口分布

顶层目录：`modmain/`、`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `modmain/common.lua`
- `modmain/revive_button.lua`
- `modmain/transfer_button.lua`
- `scripts/components/rt_transfer.lua`
- `scripts/components/rt_transfer_replica.lua`
- `scripts/rtbuttons/changscripts/dsts/rt_api.lua`
- `scripts/screens/rt/transfer_panel.lua`
- `scripts/widgets/rt/revive_button.lua`
- `scripts/widgets/rt/transfer_button.lua`

## 二、注入钩子清单（真实提取）

未检测到标准 PostInit 系列钩子。

## 三、关键代码片段

```lua
-- 该 MOD 未使用标准 PostInit 钩子，多为资源/配置型改动
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 2 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 4 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。