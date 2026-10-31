# Skill：SHOWPLAYERSOPTIONS 架构复刻

- 来源：工坊 MOD `3138571948`（clearlove, rezecib, Sarcen / 2.4.6）
- 规模：14 文件 / 3142 行

## 可直接复用的写法

- `AddPrefabPostInit("world")`：该 MOD 用了 3 次，是它的主要切入点。
- `AddComponentPostInit("maprevealer")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddPrefabPostInit("beefalo")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddPrefabPostInit("shard_network")`：该 MOD 用了 1 次，是它的主要切入点。
- `AddComponentPostInit("mapspotrevealer")`：该 MOD 用了 1 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中