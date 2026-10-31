# Skill：史莱姆 Slime 架构复刻

- 来源：工坊 MOD `3824225798`（奶糖味果酱 / 0.4.0）
- 规模：56 文件 / 5894 行

## 可直接复用的写法

- `AddPrefabPostInit("world")`：该 MOD 用了 1 次，是它的主要切入点。
- `AddComponentPostInit("combat")`：该 MOD 用了 1 次，是它的主要切入点。
- `AddComponentPostInit("pickable")`：该 MOD 用了 1 次，是它的主要切入点。
- `AddComponentPostInit("temperature")`：该 MOD 用了 1 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中