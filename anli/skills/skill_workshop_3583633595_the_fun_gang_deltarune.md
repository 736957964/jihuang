# Skill：The Fun Gang (DELTARUNE) 架构复刻

- 来源：工坊 MOD `3583633595`（mizartz / 1.1.9）
- 规模：54 文件 / 46039 行

## 可直接复用的写法

- `AddStategraphPostInit("wilson")`：该 MOD 用了 3 次，是它的主要切入点。
- `AddComponentPostInit("stageactingprop")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddStategraphPostInit("wilson_client")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddComponentPostInit("edible")`：该 MOD 用了 1 次，是它的主要切入点。
- `AddPrefabPostInit("horrorfuel")`：该 MOD 用了 1 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中