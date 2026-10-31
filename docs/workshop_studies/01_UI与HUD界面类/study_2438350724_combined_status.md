# 饥荒创意工坊研读报告：Combined Status

- **模组标识**：`2438350724`
- **作者**：rezecib, Kiopho, Soilworker, hotmatrixx, penguin0616【汉化者：zhonger】
- **版本**：1.9.2C
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：5 个 Lua 文件 / 共 1908 行；网络变量 0 处；RPC 0 处；注入钩子 3 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/widgets/minibadge.lua`
- `scripts/widgets/playerbadge_combined_status.lua`
- `scripts/widgets/seasonclock.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 2 |
| `AddComponentPostInit` | `kramped` | 1 |
| `AddComponentPostInit` | `clock` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
if (CSW or HML or HAS_MOD.TROPICAL) and SHOWSTATNUMBERS then
	AddPrefabPostInit("world", function()
		AddClassPostConstruct("widgets/boatbadge", BoatBadgePostConstruct)
	end)
end
local function BoatMeterPostConstruct(self)
	self.active = false
	BadgePostConstruct(self)
	self.inst:ListenForEvent("open_meter", function()
		self.active = true
		self.bg:Show()
		self.num:Show()
```
### AddComponentPostInit("kramped")
```lua
if SHOWNAUGHTINESS and not DST then
	AddComponentPostInit('kramped', KrampedPostInit)
end

local function StatusPostConstruct(self)
	self.brain:SetPosition(0, SHOWSEASONCLOCK and 35 or 10)
	self.stomach:SetPosition(-62, 35)
	self.heart:SetPosition(62, 35)
	if DST then
		self.heart.effigyanim:SetPosition(45, 50)
		self.resurrectbutton:SetPosition(0, 25)
	end
```
### AddComponentPostInit("clock")
```lua
	end
	AddComponentPostInit("clock", ClockPostInit)
end

AddClassPostConstruct("screens/playerhud", function(self)
	if GLOBAL.softresolvefilepath("scripts/widgets/beefalowidget.lua") then
		AddClassPostConstruct("widgets/beefalowidget", function(self)
			if self.health and self.hunger and self.hunger.anim then
				self.health:SetScale(1,1,1)
				self.health:SetPosition(80, 164)
				self.hunger:SetScale(1,1,1)
				self.hunger:SetPosition(-3, 164)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。