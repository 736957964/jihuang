# 饥荒创意工坊研读报告：Burning Timer

- **模组标识**：`2525856394`
- **作者**：Viktor
- **版本**：1.1.5
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：7 个 Lua 文件 / 共 1065 行；网络变量 0 处；RPC 0 处；注入钩子 9 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/bt_revealer.lua`
- `scripts/components/burningtimer.lua`
- `scripts/components/campfiretimer.lua`
- `scripts/components/lanterntimer.lua`
- `scripts/components/startimer.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `fire` | 1 |
| `AddPrefabPostInit` | `campfirefire` | 1 |
| `AddPrefabPostInit` | `coldfirefire` | 1 |
| `AddPrefabPostInit` | `nightlight_flame` | 1 |
| `AddPrefabPostInit` | `pigtorch_flame` | 1 |
| `AddPrefabPostInit` | `obsidianfirefire` | 1 |
| `AddPrefabPostInit` | `lanternlight` | 1 |
| `AddPrefabPostInit` | `stafflight` | 1 |
| `AddPrefabPostInit` | `staffcoldlight` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("fire")
```lua
if GetModConfigData("showBurningTimer") then
	AddPrefabPostInit("fire", function(inst)
		inst:DoTaskInTime(0.01, function()
			inst:AddComponent("burningtimer")
		end)
		return
	end)
end

-- Campfire Timer --
local function campfireTimer(inst)
	inst:DoTaskInTime(0.1, function()
```
### AddPrefabPostInit("campfirefire")
```lua
if GetModConfigData("showCampfireTimer") then
	AddPrefabPostInit("campfirefire",     function(inst) return campfireTimer(inst) end)
	AddPrefabPostInit("coldfirefire",     function(inst) return campfireTimer(inst) end)
	AddPrefabPostInit("nightlight_flame", function(inst) return campfireTimer(inst) end)
	--AddPrefabPostInit("pigtorch_flame", function(inst) return campfireTimer(inst) end) -- It works for pig torches but their light range does not depend on their available fuel so this mod will show obviously invalid numbers
	AddPrefabPostInit("obsidianfirefire", function(inst) return campfireTimer(inst) end) -- From Tropical Experience mod
end

-- Lantern Timer --
local function lanternTimer(inst)
	inst:DoTaskInTime(0.01, function()
		inst:AddComponent("lanterntimer")
```
### AddPrefabPostInit("coldfirefire")
```lua
	AddPrefabPostInit("campfirefire",     function(inst) return campfireTimer(inst) end)
	AddPrefabPostInit("coldfirefire",     function(inst) return campfireTimer(inst) end)
	AddPrefabPostInit("nightlight_flame", function(inst) return campfireTimer(inst) end)
	--AddPrefabPostInit("pigtorch_flame", function(inst) return campfireTimer(inst) end) -- It works for pig torches but their light range does not depend on their available fuel so this mod will show obviously invalid numbers
	AddPrefabPostInit("obsidianfirefire", function(inst) return campfireTimer(inst) end) -- From Tropical Experience mod
end

-- Lantern Timer --
local function lanternTimer(inst)
	inst:DoTaskInTime(0.01, function()
		inst:AddComponent("lanterntimer")
	end)
```
### AddPrefabPostInit("nightlight_flame")
```lua
	AddPrefabPostInit("coldfirefire",     function(inst) return campfireTimer(inst) end)
	AddPrefabPostInit("nightlight_flame", function(inst) return campfireTimer(inst) end)
	--AddPrefabPostInit("pigtorch_flame", function(inst) return campfireTimer(inst) end) -- It works for pig torches but their light range does not depend on their available fuel so this mod will show obviously invalid numbers
	AddPrefabPostInit("obsidianfirefire", function(inst) return campfireTimer(inst) end) -- From Tropical Experience mod
end

-- Lantern Timer --
local function lanternTimer(inst)
	inst:DoTaskInTime(0.01, function()
		inst:AddComponent("lanterntimer")
	end)
	return
```
### AddPrefabPostInit("pigtorch_flame")
```lua
	AddPrefabPostInit("nightlight_flame", function(inst) return campfireTimer(inst) end)
	--AddPrefabPostInit("pigtorch_flame", function(inst) return campfireTimer(inst) end) -- It works for pig torches but their light range does not depend on their available fuel so this mod will show obviously invalid numbers
	AddPrefabPostInit("obsidianfirefire", function(inst) return campfireTimer(inst) end) -- From Tropical Experience mod
end

-- Lantern Timer --
local function lanternTimer(inst)
	inst:DoTaskInTime(0.01, function()
		inst:AddComponent("lanterntimer")
	end)
	return
end
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。