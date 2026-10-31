# 饥荒创意工坊研读报告：十二生肖符咒 (Zodiac Talismans)

- **模组标识**：`3816296964`
- **作者**：安乐
- **版本**：2.6.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：3 个 Lua 文件 / 共 2552 行；网络变量 3 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/prefabs/zodiac_talismans.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 1 |
| `AddStategraphPostInit` | `wilson_client` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua

AddStategraphPostInit("wilson", ZodiacCastSpeedPatch)
AddStategraphPostInit("wilson_client", ZodiacCastSpeedPatch)

------------------------------------------------------------------
-- 游戏内文本
------------------------------------------------------------------
local names =
{
    TAL_RAT     = "鼠符咒",
    TAL_OX      = "牛符咒",
    TAL_TIGER   = "虎符咒",
```
### AddStategraphPostInit("wilson_client")
```lua
AddStategraphPostInit("wilson", ZodiacCastSpeedPatch)
AddStategraphPostInit("wilson_client", ZodiacCastSpeedPatch)

------------------------------------------------------------------
-- 游戏内文本
------------------------------------------------------------------
local names =
{
    TAL_RAT     = "鼠符咒",
    TAL_OX      = "牛符咒",
    TAL_TIGER   = "虎符咒",
    TAL_RABBIT  = "兔符咒",
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 3 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。