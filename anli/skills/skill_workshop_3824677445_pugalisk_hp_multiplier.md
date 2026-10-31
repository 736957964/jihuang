# Skill：PUGALISK_HP_MULTIPLIER 架构复刻

- 来源：工坊 MOD `3824677445`（Kiyo / 0.3.65）
- 规模：478 文件 / 94450 行

## 可直接复用的写法

- `AddStategraphPostInit("wilson")`：该 MOD 用了 3 次，是它的主要切入点。
- `AddStategraphPostInit("wilson_client")`：该 MOD 用了 3 次，是它的主要切入点。
- `AddPrefabPostInit("player_classified")`：该 MOD 用了 3 次，是它的主要切入点。
- `AddPrefabPostInit("world")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddComponentPostInit("playerspawner")`：该 MOD 用了 2 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中