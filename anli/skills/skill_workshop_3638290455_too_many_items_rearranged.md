# Skill：Too Many Items Rearranged 架构复刻

- 来源：工坊 MOD `3638290455`（未知 / 1.7.4）
- 规模：187 文件 / 62021 行

## 可直接复用的写法

- `AddPrefabPostInit("charlie_heckler")`：该 MOD 用了 1 次，是它的主要切入点。
- `AddComponentPostInit("playerhearing")`：该 MOD 用了 1 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中