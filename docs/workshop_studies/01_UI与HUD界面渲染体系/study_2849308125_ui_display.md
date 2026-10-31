# 饥荒创意工坊研读报告：UI_DISPLAY

- **模组标识**：`2849308125`
- **作者**：川小胖 & Fengying(original author)
- **版本**：3.8.2
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：26 个 Lua 文件 / 共 8133 行；网络变量 0 处；RPC 1 处；注入钩子 1 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/ngl_astarpathfinder.lua`
- `scripts/components/ngl_custompfwalls.lua`
- `scripts/components/ngl_floodpfwalls.lua`
- `scripts/components/ngl_fusedpathfinder.lua`
- `scripts/components/ngl_obstaclepfwalls.lua`
- `scripts/components/ngl_pathfinder.lua`
- `scripts/components/ngl_pathfollower.lua`
- `scripts/components/ngl_pathfollower_old.lua`
- `scripts/misc/custom_bypass_prefab_defs.lua`
- `scripts/misc/foolsday_joke.lua`
- `scripts/misc/pathfinding_bypass.lua`
- `scripts/ngl_movemodes.lua`
- `scripts/postInits/mapscreenPostInit.lua`
- `scripts/postInits/minimapwidgetPostInit.lua`
- `scripts/postInits/playercontrollerPostInit.lua`
- `scripts/postInits/smallmapPostInit.lua`
- `scripts/utils/astar_util.lua`
- `scripts/utils/bidir_astar_util.lua`
- `scripts/utils/binaryheap.lua`
- `scripts/utils/trailblazer.lua`
- `scripts/utils/userdatahook.lua`
- `scripts/widgets/ngl_desticon.lua`
- `scripts/widgets/ngl_pathlinegroup.lua`
- `scripts/widgets/ngl_pathlinegroup_old.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `playercontroller` | 3 |

## 三、关键代码片段

### AddComponentPostInit("playercontroller")
```lua

AddComponentPostInit("playercontroller", function(self, player)
	if ThePlayer ~= nil and player == ThePlayer then
		-- add lua pathfinder
		if player.components.ngl_astarpathfinder == nil then
			player:AddComponent("ngl_astarpathfinder")
		end

		-- add official pathfinder
		if player.components.ngl_pathfinder == nil then
			player:AddComponent("ngl_pathfinder")
		end
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。