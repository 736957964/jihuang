# 饥荒创意工坊研读报告：Cultivable weeds

- **模组标识**：`3823867907`
- **作者**：SteamUser
- **版本**：1.3.2
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：3 个 Lua 文件 / 共 390 行；网络变量 0 处；RPC 0 处；注入钩子 3 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/prefabs/weed_seeds.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `medal_ivy` | 1 |
| `AddPrefabPostInit` | `birdcage` | 1 |
| `AddPrefabPostInit` | `weed_ivy` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("medal_ivy")
```lua
-- 不会让物品变得能吃、也不会影响烹饪。
AddPrefabPostInit("medal_ivy", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	if inst.components.tradable == nil then
		inst:AddComponent("tradable")
	end
end)

local IVY_PRODUCT = "medal_ivy"
local IVY_SEED = "medal_ivy_seeds"
```
### AddPrefabPostInit("birdcage")
```lua

AddPrefabPostInit("birdcage", function(inst)
	local trader = inst.components.trader
	if trader == nil or trader._cultivable_ivy_hook then
		return
	end
	trader._cultivable_ivy_hook = true

	local vanilla_test = trader.test			-- 原版 ShouldAcceptItem
	local vanilla_accept = trader.onaccept		-- 原版 OnGetItem

	-- 让鸟笼收下旋花藤；其它物品照旧走原版判定
```
### AddPrefabPostInit("weed_ivy")
```lua
end
AddPrefabPostInit("weed_ivy", HookDirectSpawn)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。