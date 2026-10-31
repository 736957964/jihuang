# 饥荒创意工坊研读报告：The Winterlands

- **模组标识**：`3383047161`
- **作者**：ADM, Feything, Gearless, LukaS, Notka 󰀃
- **版本**：1.4.10
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：508 个 Lua 文件 / 共 89616 行；网络变量 47 处；RPC 4 处；注入钩子 76 处

## 一、代码结构与入口分布

顶层目录：`init/`、`postinit/`、`scripts/`

Lua 文件清单（最多 40 条）：

- `init/fx.lua`
- `init/init_actions.lua`
- `init/init_assets.lua`
- `init/init_cooking.lua`
- `init/init_prefabs.lua`
- `init/init_recipes.lua`
- `init/init_retrofit.lua`
- `init/init_skins.lua`
- `init/init_tiles.lua`
- `init/init_tuning.lua`
- `init/init_widgets.lua`
- `init/init_worldgen.lua`
- `modinfo.lua`
- `modmain.lua`
- `modservercreationmain.lua`
- `modworldgenmain.lua`
- `postinit/brains/penguin.lua`
- `postinit/brains/walrus.lua`
- `postinit/components/ambientsound.lua`
- `postinit/components/birdspawner.lua`
- `postinit/components/brushable.lua`
- `postinit/components/builder.lua`
- `postinit/components/butterflyspawner.lua`
- `postinit/components/combat.lua`
- `postinit/components/container.lua`
- `postinit/components/debuffable.lua`
- `postinit/components/deerclopsspawner.lua`
- `postinit/components/deployable.lua`
- `postinit/components/drawable.lua`
- `postinit/components/dynamicmusic.lua`
- `postinit/components/eater.lua`
- `postinit/components/edible.lua`
- `postinit/components/expertsailor.lua`
- `postinit/components/explosive.lua`
- `postinit/components/follower.lua`
- `postinit/components/freezable.lua`
- `postinit/components/frograin.lua`
- `postinit/components/groundpounder.lua`
- `postinit/components/health.lua`
- `postinit/components/hounded.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `ambientsound` | 1 |
| `AddComponentPostInit` | `dynamicmusic` | 1 |
| `AddComponentPostInit` | `hunter` | 1 |
| `AddComponentPostInit` | `moonstormmanager` | 1 |
| `AddComponentPostInit` | `playerspawner` | 1 |
| `AddComponentPostInit` | `playervision` | 1 |
| `AddComponentPostInit` | `regrowthmanager` | 1 |
| `AddComponentPostInit` | `retrofitforestmap_anr` | 1 |
| `AddComponentPostInit` | `sandstorms` | 1 |
| `AddComponentPostInit` | `moonstorms` | 1 |
| `AddComponentPostInit` | `shadowcreaturespawner` | 1 |
| `AddComponentPostInit` | `slipperyfeet` | 1 |

## 三、关键代码片段

### AddComponentPostInit("ambientsound")
```lua

ENV.AddComponentPostInit("ambientsound", function(self)
	local AMBIENT_SOUNDS, SOUND = PolarUpvalue(self.OnUpdate, "AMBIENT_SOUNDS")
	
	if SOUND then
		for k, v in pairs(POLAR_AMBIENT_SOUND) do
			AMBIENT_SOUNDS[k] = POLAR_AMBIENT_SOUND[k]
		end
	end
end)
```
### AddComponentPostInit("dynamicmusic")
```lua

ENV.AddComponentPostInit("dynamicmusic", function(self)
	--	Work Music
	
	function self:UpdatePolarMusic(self, ignore)
		if ThePlayer == nil or ignore then
			return
		end

		local x, y, z = ThePlayer.Transform:GetWorldPosition()
		local setpolar = GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil or nil
		
```
### AddComponentPostInit("hunter")
```lua

ENV.AddComponentPostInit("hunter", function(self)
	local OldSpawnHuntedBeast = PolarUpvalue(self.OnDirtInvestigated, "SpawnHuntedBeast")
	local OldGetHuntedBeast = PolarUpvalue(OldSpawnHuntedBeast, "GetHuntedBeast")
	local ALTERNATE_BEASTS = PolarUpvalue(OldGetHuntedBeast, "ALTERNATE_BEASTS")
	
	self._beastsnopolaroverride = {"claywarg", "yots_worm_lantern_spawner"} -- Beasts that are allowed to spawn, bypassing Winterlands ruleset
	
	local function GetHuntedBeast(hunt, spawn_pt, ...)
		local beast = OldGetHuntedBeast(hunt, spawn_pt, ...)
		
		if beast and not self._overridepolar and not table.contains(self._beastsnopolaroverride, beast)
```
### AddComponentPostInit("moonstormmanager")
```lua

ENV.AddComponentPostInit("moonstormmanager", function(self)
	local OldNodeCanHaveMoonstorm = PolarUpvalue(self.CalcNewMoonstormBaseNodeIndex, "NodeCanHaveMoonstorm")
	local function NodeCanHaveMoonstorm(node, ...)
		local test
		if OldNodeCanHaveMoonstorm then
			test = OldNodeCanHaveMoonstorm(node, ...)
		end
		
		return not table.contains(node.tags, "polararea") and test
	end
	
```
### AddComponentPostInit("playerspawner")
```lua

ENV.AddComponentPostInit("playerspawner", function(self)
	local _polarpts = {}
	
	local function UnregisterPolarPoint(spawnpt)
		table.removearrayvalue(_polarpts, spawnpt)
	end
	
	local function OnRegisterPolarPoint(inst, spawnpt)
		if not table.contains(_polarpts, spawnpt) then
			table.insert(_polarpts, spawnpt)
		end
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 47 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 4 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。