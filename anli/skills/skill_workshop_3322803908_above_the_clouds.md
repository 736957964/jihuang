# Skill：云霄国度-Above the Clouds 架构复刻

- 来源：工坊 MOD `3322803908`（Jerry, Tony, ziwbi, 亚丹, 鲁鲁, 小巫, 每年睡8760小时, 老王 / 1.0.50）
- 规模：807 文件 / 165915 行

## 可直接复用的写法

- `AddPrefabRegisterPostInit("spoiled_food")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddComponentPostInit("health")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddPrefabPostInit("grass")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddComponentPostInit("actionqueuer")`：该 MOD 用了 1 次，是它的主要切入点。
- `AddComponentPostInit("ambientlighting")`：该 MOD 用了 1 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中