# Skill：植物大战饥荒 Plants vs. DST 架构复刻

- 来源：工坊 MOD `3513671528`（Loong / 未声明）
- 规模：188 文件 / 38971 行

## 可直接复用的写法

- `AddPrefabPostInit("world")`：该 MOD 用了 4 次，是它的主要切入点。
- `AddComponentPostInit("playercontroller")`：该 MOD 用了 4 次，是它的主要切入点。
- `AddComponentPostInit("combat")`：该 MOD 用了 3 次，是它的主要切入点。
- `AddStategraphPostInit("wilson")`：该 MOD 用了 2 次，是它的主要切入点。
- `AddComponentPostInit("playeractionpicker")`：该 MOD 用了 2 次，是它的主要切入点。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中