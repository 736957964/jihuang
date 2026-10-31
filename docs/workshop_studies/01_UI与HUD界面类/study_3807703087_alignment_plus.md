# 饥荒创意工坊研读报告：Alignment Plus

- **模组标识**：`3807703087`
- **作者**：Twdoor
- **版本**：0.1.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：9 个 Lua 文件 / 共 2046 行；网络变量 0 处；RPC 0 处；注入钩子 7 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/alignmentdefaults.lua`
- `scripts/alignmenthooks.lua`
- `scripts/alignmentstrings.lua`
- `scripts/components/axisaligner.lua`
- `scripts/prefabs/alignment_statue_placer.lua`
- `scripts/prefabs/sap_placerring.lua`
- `scripts/statueplacement.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `placer` | 1 |
| `AddPrefabPostInit` | `lightning_rod` | 1 |
| `AddPrefabPostInit` | `lightning_rod_placer` | 1 |
| `AddPrefabPostInit` | `mastupgrade_lightningrod` | 1 |
| `AddPrefabPostInit` | `storage_robot` | 1 |
| `AddPrefabPostInit` | `wendy_recipe_gravestone_placer` | 1 |
| `AddPrefabPostInit` | `world` | 1 |

## 三、关键代码片段

### AddComponentPostInit("placer")
```lua

AddComponentPostInit("placer",function(P) _G.GetModFns("SAP").PlacerPost(P) end)

local A=function(i,e)
	local a=i:HasTag("NOCLICK") and i.entity:GetParent()
	if e and (not i:HasTag("NOCLICK") or a and a:HasTag("mast")) then
		if i.helper==nil then
			i.helper=SpawnPrefab("sap_placerring")
			i.helper.AnimState:SetAddColour(0,.2,.5,0)
			i.helper.AnimState:SetSortOrder(2)
			i.helper:SetRadius(TUNING.LIGHTNINGSTRIKE_SEARCH_RANGE)
			i.helper.entity:SetParent(i.entity)
```
### AddPrefabPostInit("lightning_rod")
```lua
end
AddPrefabPostInit("lightning_rod",function(i)
	if not i.components.deployhelper and not i.helper then
		i:AddComponent("deployhelper")
		i.components.deployhelper.onenablehelper=A
	end
end)
AddPrefabPostInit("lightning_rod_placer",function(i)
	local P=i.components.placer
	if P then
		local p=SpawnPrefab("sap_placerring")
		p.AnimState:SetAddColour(0,.2,.5,0)
```
### AddPrefabPostInit("lightning_rod_placer")
```lua
end)
AddPrefabPostInit("lightning_rod_placer",function(i)
	local P=i.components.placer
	if P then
		local p=SpawnPrefab("sap_placerring")
		p.AnimState:SetAddColour(0,.2,.5,0)
		p.AnimState:SetSortOrder(3)
		p:SetRadius(TUNING.LIGHTNINGSTRIKE_SEARCH_RANGE)
		p.entity:SetParent(i.entity)
		P:LinkEntity(p)
	end
end)
```
### AddPrefabPostInit("mastupgrade_lightningrod")
```lua
end)
AddPrefabPostInit("mastupgrade_lightningrod",function(i)
	if not i.components.deployhelper then
		i:AddComponent("deployhelper")
		i.components.deployhelper.onenablehelper=A
	end
end)
AddPrefabPostInit("storage_robot",function(i)
	local d=i.components.deployhelper
	if d then
		local _=d.onenablehelper
		d.onenablehelper=function(inst,enabled,recipename,placerinst)
```
### AddPrefabPostInit("storage_robot")
```lua
end)
AddPrefabPostInit("storage_robot",function(i)
	local d=i.components.deployhelper
	if d then
		local _=d.onenablehelper
		d.onenablehelper=function(inst,enabled,recipename,placerinst)
			local s=tostring(inst.GUID)
			if recipename~=s then _(inst,enabled,s,placerinst) end
		end
	end
end)
AddPrefabPostInit("wendy_recipe_gravestone_placer",function(i)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。