# Skill：Charlie Puke Rainbow 架构复刻

- 来源：工坊 MOD `3821655636`（lulu / 10）
- 规模：2 文件 / 27 行

## 可直接复用的写法

- 无标准钩子，参考其数据表/资源配置的写法。

## 接入检查清单

- [ ] 服务端逻辑先加 `if not TheWorld.ismastersim then return end`
- [ ] 客户端逻辑放 `AddPlayerPostInit` 或 modmain 的客户端段
- [ ] 改共享目标时加自己的标记位，避免与同类 MOD 互相覆盖
- [ ] 改完用 `print` 打出实际注册结果，确认钩子真的命中