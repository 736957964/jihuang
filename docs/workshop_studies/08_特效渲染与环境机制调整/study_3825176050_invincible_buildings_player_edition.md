# 饥荒创意工坊研读报告：Invincible Buildings - Player Edition / 建筑无敌（玩家可攻击版）

- **模组标识**：`3825176050`
- **作者**：asingingbird (original) / reworked
- **版本**：3.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 399 行；网络变量 0 处；RPC 0 处；注入钩子 18 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `combat` | 1 |
| `AddComponentPostInit` | `playercontroller` | 1 |
| `AddPrefabPostInit` | `fence` | 1 |
| `AddPrefabPostInit` | `fence_gate` | 1 |
| `AddPrefabPostInit` | `wall_wood` | 1 |
| `AddPrefabPostInit` | `wall_hay` | 1 |
| `AddPrefabPostInit` | `wall_stone` | 1 |
| `AddPrefabPostInit` | `wall_ruins` | 1 |
| `AddPrefabPostInit` | `wall_moonrock` | 1 |
| `AddPrefabPostInit` | `wall_scrap` | 1 |
| `AddPrefabPostInit` | `wall_dreadstone` | 1 |
| `AddPrefabPostInit` | `treasurechest` | 1 |

## 三、关键代码片段

### AddComponentPostInit("combat")
```lua
-- 这样 SetTarget、CanAttack、TryAttack、attackwall 都会失败，行为更接近原版。
AddComponentPostInit("combat", function(self)
	if self._playerprotectedfilter then
		return
	end
	self._playerprotectedfilter = true

	local function IsProtectedTarget(target)
		return target ~= nil and target.HasTag ~= nil and target:HasTag(PLAYER_PROTECTED_TAG)
	end

	local old_IsValidTarget = self.IsValidTarget
```
### AddComponentPostInit("playercontroller")
```lua

AddComponentPostInit("playercontroller", function(self)
	local function EnsureCombatFilter()
		local combat = self.inst.replica ~= nil and self.inst.replica.combat or nil
		if combat == nil or combat._playerprotectedauto then
			return
		end
		combat._playerprotectedauto = true

		local old_CanTarget = combat.CanTarget
		if old_CanTarget == nil then
			return
```
### AddPrefabPostInit("fence")
```lua

AddPrefabPostInit("fence", function(inst) Protect(inst, FENCE) end)
AddPrefabPostInit("fence_gate", function(inst) Protect(inst, FENCE_GATE) end)
AddPrefabPostInit("wall_wood", function(inst) Protect(inst, WALL_WOOD) end)
AddPrefabPostInit("wall_hay", function(inst) Protect(inst, WALL_HAY) end)
AddPrefabPostInit("wall_stone", function(inst) Protect(inst, WALL_STONE) end)
AddPrefabPostInit("wall_ruins", function(inst) Protect(inst, WALL_RUINS) end)
AddPrefabPostInit("wall_moonrock", function(inst) Protect(inst, WALL_MOONROCK) end)
AddPrefabPostInit("wall_scrap", function(inst) Protect(inst, WALL_SCRAP) end)
AddPrefabPostInit("wall_dreadstone", function(inst) Protect(inst, WALL_DREADSTONE) end)
AddPrefabPostInit("treasurechest", function(inst) Protect(inst, TREASURE_CHEST) end)
AddPrefabPostInit("homesign", function(inst) Protect(inst, HOME_SIGN) end)
```
### AddPrefabPostInit("fence_gate")
```lua
AddPrefabPostInit("fence", function(inst) Protect(inst, FENCE) end)
AddPrefabPostInit("fence_gate", function(inst) Protect(inst, FENCE_GATE) end)
AddPrefabPostInit("wall_wood", function(inst) Protect(inst, WALL_WOOD) end)
AddPrefabPostInit("wall_hay", function(inst) Protect(inst, WALL_HAY) end)
AddPrefabPostInit("wall_stone", function(inst) Protect(inst, WALL_STONE) end)
AddPrefabPostInit("wall_ruins", function(inst) Protect(inst, WALL_RUINS) end)
AddPrefabPostInit("wall_moonrock", function(inst) Protect(inst, WALL_MOONROCK) end)
AddPrefabPostInit("wall_scrap", function(inst) Protect(inst, WALL_SCRAP) end)
AddPrefabPostInit("wall_dreadstone", function(inst) Protect(inst, WALL_DREADSTONE) end)
AddPrefabPostInit("treasurechest", function(inst) Protect(inst, TREASURE_CHEST) end)
AddPrefabPostInit("homesign", function(inst) Protect(inst, HOME_SIGN) end)
AddPrefabPostInit("dragonflychest", function(inst) Protect(inst, DRAGONFLY_CHEST) end)
```
### AddPrefabPostInit("wall_wood")
```lua
AddPrefabPostInit("fence_gate", function(inst) Protect(inst, FENCE_GATE) end)
AddPrefabPostInit("wall_wood", function(inst) Protect(inst, WALL_WOOD) end)
AddPrefabPostInit("wall_hay", function(inst) Protect(inst, WALL_HAY) end)
AddPrefabPostInit("wall_stone", function(inst) Protect(inst, WALL_STONE) end)
AddPrefabPostInit("wall_ruins", function(inst) Protect(inst, WALL_RUINS) end)
AddPrefabPostInit("wall_moonrock", function(inst) Protect(inst, WALL_MOONROCK) end)
AddPrefabPostInit("wall_scrap", function(inst) Protect(inst, WALL_SCRAP) end)
AddPrefabPostInit("wall_dreadstone", function(inst) Protect(inst, WALL_DREADSTONE) end)
AddPrefabPostInit("treasurechest", function(inst) Protect(inst, TREASURE_CHEST) end)
AddPrefabPostInit("homesign", function(inst) Protect(inst, HOME_SIGN) end)
AddPrefabPostInit("dragonflychest", function(inst) Protect(inst, DRAGONFLY_CHEST) end)
AddPrefabPostInit("icebox", function(inst) Protect(inst, ICEBOX) end)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。