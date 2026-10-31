# 饥荒创意工坊研读报告：The Fun Gang (DELTARUNE)

- **模组标识**：`3583633595`
- **作者**：mizartz
- **版本**：1.1.9
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：54 个 Lua 文件 / 共 46039 行；网络变量 1 处；RPC 0 处；注入钩子 5 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modclientmain.lua`
- `modinfo.lua`
- `modmain.lua`
- `scripts/brains/drfriendbrain.lua`
- `scripts/brains/lancer_mbrain.lua`
- `scripts/components/delta_upgrade.lua`
- `scripts/components/drfriendspawner.lua`
- `scripts/components/kris_headband.lua`
- `scripts/components/kris_savepoint.lua`
- `scripts/components/lancer_pickup.lua`
- `scripts/components/tensionpoints.lua`
- `scripts/components/transparentonkris.lua`
- `scripts/components/weirdroute.lua`
- `scripts/delta_strings.lua`
- `scripts/delta_tuning.lua`
- `scripts/lang/ch/delta_strings.lua`
- `scripts/lang/ch/speech_kris_m.lua`
- `scripts/lang/ch/speech_ralsei_m.lua`
- `scripts/lang/ch/speech_susie_m.lua`
- `scripts/prefabs/delta_common.lua`
- `scripts/prefabs/delta_fx.lua`
- `scripts/prefabs/delta_reticule.lua`
- `scripts/prefabs/delta_skins.lua`
- `scripts/prefabs/delta_weapons.lua`
- `scripts/prefabs/drfriend.lua`
- `scripts/prefabs/kris_headband.lua`
- `scripts/prefabs/kris_m.lua`
- `scripts/prefabs/kris_savepoint.lua`
- `scripts/prefabs/kris_shield_fx.lua`
- `scripts/prefabs/krisact_defs.lua`
- `scripts/prefabs/lancer_m.lua`
- `scripts/prefabs/lancer_m_item.lua`
- `scripts/prefabs/lancer_projectile.lua`
- `scripts/prefabs/ralsei_blush_fx.lua`
- `scripts/prefabs/ralsei_cakes.lua`
- `scripts/prefabs/ralsei_cauldron.lua`
- `scripts/prefabs/ralsei_defend_fx.lua`
- `scripts/prefabs/ralsei_m.lua`
- `scripts/prefabs/ralsei_scarf_fx.lua`
- `scripts/prefabs/ralseimagic_defs.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 3 |
| `AddComponentPostInit` | `stageactingprop` | 2 |
| `AddStategraphPostInit` | `wilson_client` | 2 |
| `AddComponentPostInit` | `edible` | 1 |
| `AddPrefabPostInit` | `horrorfuel` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua
if TUNING.KRIS_M_GROGGINESS_LENGTH then
	AddStategraphPostInit("wilson", Kris_Wakeup)
end


----------------------------------------------------------------------------
AddStategraphState("wilson",
	State {
	name = "susie_refuse",
	tags = { "susie_refuseing", "busy", "nopredict", "nomorph"},
	
	onenter = function(inst)
```
### AddComponentPostInit("stageactingprop")
```lua

AddComponentPostInit("stageactingprop", function(inst)
	inst:AddGeneralScript("RALSEI_M1", SCRIPT_RALSEI_M1)
	inst:AddGeneralScript("SUSIE_M1", SCRIPT_SUSIE_M1)
	inst:AddGeneralScript("KRIS_M1", SCRIPT_KRIS_M1) 
end)
```
### AddStategraphPostInit("wilson_client")
```lua
AddStategraphPostInit("wilson", ChangeSpellAnim)
AddStategraphPostInit("wilson_client", ChangeSpellAnim) --ok fine we need clients :/


local old_usespellbookstrfn = GLOBAL.ACTIONS.USESPELLBOOK.strfn   
GLOBAL.ACTIONS.USESPELLBOOK.strfn = function(act)
	return (act.doer:HasTag("kristag") and "KRIS_SPELLBOOK")
	or ((act.doer:HasTag("susietag") or act.doer:HasTag("ralseitag")) and "RALSUSIE_SPELLBOOK")
	or old_usespellbookstrfn ~= nil and old_usespellbookstrfn(act)
	or "BOOK"
end

```
### AddComponentPostInit("edible")
```lua
--why did klei add configurable values for health and hunger sanity penalties but not sanity. why why why why why
AddComponentPostInit("edible", function(inst)
    local _oldGetSanity = inst.GetSanity
    inst.GetSanity = function(self, eater)
		
        if (eater and eater.prefab == "susie_m") and self.inst.components.perishable
		and not self.inst.components.perishable:IsFresh() then
			local sanityvalue = self.getsanityfn ~= nil and self.getsanityfn(self.inst, eater) or self.sanityvalue
			local multiplier = 1
			
			if self.inst.components.perishable:IsStale() then
				sanityvalue = sanityvalue * TUNING.SUSIE_M_STALE_SANITY
```
### AddPrefabPostInit("horrorfuel")
```lua
if TUNING.HORRORFUEL_UPGRADE then
    AddPrefabPostInit("horrorfuel", AddDeltaComponent)
end
----------------------------------------------------------------------------
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 1 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。