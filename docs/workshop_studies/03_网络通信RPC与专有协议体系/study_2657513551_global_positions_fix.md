# 饥荒创意工坊研读报告：GLOBAL_POSITIONS_FIX

- **模组标识**：`2657513551`
- **作者**：老王天天写bug
- **版本**：1.2.44
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：42 个 Lua 文件 / 共 10261 行；网络变量 0 处；RPC 0 处；注入钩子 34 处

## 一、代码结构与入口分布

顶层目录：`modmain/`、`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `modmain/debug_tracer.lua`
- `modmain/dumper_macos.lua`
- `modmain/log.lua`
- `modmain/mainfunctions.lua`
- `modmain/misc.lua`
- `modmain/printinfo.lua`
- `modmain/profiler.lua`
- `modmain/profiler_0.lua`
- `modmain/recipe_opt.lua`
- `modmain/recovery.lua`
- `modmain/reset.lua`
- `modmain/save.lua`
- `modmain/servercreation.lua`
- `modmain/shard.lua`
- `modmain/shardrpc.lua`
- `modmain/snapshot.lua`
- `modmain/strings.lua`
- `modmain/sync.lua`
- `modmain/trap.lua`
- `modworldgenmain.lua`
- `scripts/components/dsa_antlion_proxy.lua`
- `scripts/components/dsa_bearger_proxy.lua`
- `scripts/components/dsa_cavelocation_proxy.lua`
- `scripts/components/dsa_clock_proxy.lua`
- `scripts/components/dsa_clocksync.lua`
- `scripts/components/dsa_cpu_profiler.lua`
- `scripts/components/dsa_daywalker_proxy.lua`
- `scripts/components/dsa_deerclops_proxy.lua`
- `scripts/components/dsa_klaussack_proxy.lua`
- `scripts/components/dsa_shard_proxy.lua`
- `scripts/components/dsa_trapfumaroleburning_proxy.lua`
- `scripts/dsa_unused/README.lua`
- `scripts/dsa_unused/commands.lua`
- `scripts/dsa_unused/loadingchain.note.lua`
- `scripts/dsa_unused/preparedfoods.backup.lua`
- `scripts/dsa_unused/saveindex.note.lua`
- `scripts/dsa_unused/shardindex.note.lua`
- `scripts/dsa_unused/shardsaveindex.note.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 5 |
| `AddComponentPostInit` | `container` | 2 |
| `AddComponentPostInit` | `dsa_clocksync` | 2 |
| `AddComponentPostInit` | `clock` | 2 |
| `AddComponentPostInit` | `harvestable` | 2 |
| `AddComponentPostInit` | `perishable` | 1 |
| `AddPrefabPostInit` | `wx` | 1 |
| `AddComponentPostInit` | `targettracker` | 1 |
| `AddPrefabPostInit` | `mihobell` | 1 |
| `AddPrefabPostInit` | `acidsmoke_endless` | 1 |
| `AddComponentPostInit` | `riftspawner` | 1 |
| `AddComponentPostInit` | `itemmimic` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
		}
		AddPrefabPostInit("world", function(inst)
			local old_debug = inst.GetDebugString
			function inst:GetDebugString()
				local old_cmp = inst.components
				local new_cmp = {}
				for k,v in pairs(old_cmp)do
					if k:match("^dsa_") or debug_components[k] then
						new_cmp[k] = v
					end
				end

```
### AddComponentPostInit("container")
```lua
-- fix container owner
AddComponentPostInit("container", function(self)
	local old_open = self.Open
	function self:Open(doer, ...)
		if doer == ThePlayer then
			self.opener = ThePlayer
		else
			self.opener = nil
		end
		return old_open(self, doer, ...)
	end
end)
```
### AddComponentPostInit("dsa_clocksync")
```lua

AddComponentPostInit("dsa_clocksync", function(self)
	-- 将时间同步组件切换到恢复模式 (仍将读取时间并触发长更新)
	self.OnWorldNetLoad = self.OnWorldNetLoad_Recovery
	self.OnPostInit 	= self.OnPostInit_Recovery
end)

-- TODO: 恢复失败获取报错
```
### AddComponentPostInit("clock")
```lua
AddPrefabPostInit("shard_network", function(inst)
    -- see AddComponentPostInit("clock")
    if TheWorld ~= nil then
        TheWorld.components.dsa_clocksync:OnWorldNetLoad()
    end
end)

AddComponentPostInit("clock", function(self)
    -- 修改读档函数, 这个地方修改的是self.inst
    -- 我们需要在世界加载后/其他物体加载前 计算需要长更新的时间
    local inst = self.inst
    -- local old_set = inst.SetPersistData
```
### AddComponentPostInit("harvestable")
```lua
-- TheWorld.components.dsa_clocksync.elapsedtime is delta time in another shard.
AddComponentPostInit("harvestable", function(self)
    local old_onload = self.OnLoad
    function self:OnLoad(data, ...)
        if self.LongUpdate ~= nil or env.loadingplayer then
            return old_onload(self, data, ...)
        end

        local time = TheWorld.components.dsa_clocksync.elapsedtime
        if time and data and data.time then
            data.time = math.max(0, data.time - time)
        end
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。