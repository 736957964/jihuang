# Skill：EmptyNull 架构复刻

- 来源：工坊 MOD `3050607025`（大大果汁、凉时白开、小瑾、天涯共此时、小花朵 / 2.8.25）
- 规模：15 文件 / 2747 行

## 可直接复用的写法

- `AddPrefabPostInit("world")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddComponentPostInit("stackable")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddPrefabPostInit("mermking")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddPrefabPostInit("pigking")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddPrefabPostInit("birdcage")`：该 MOD 用了 2 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中