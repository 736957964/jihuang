# 饥荒创意工坊研读报告：LANGUAGE

- **模组标识**：`3828782842`
- **作者**：幕夜之下
- **版本**：未声明
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：150 个 Lua 文件 / 共 12511 行；网络变量 5 处；RPC 3 处；注入钩子 17 处

## 一、代码结构与入口分布

顶层目录：`imports_of_best_woodie/`、`scripts/`、`test_fn/`

Lua 文件清单（最多 40 条）：

- `_API_Some_Sounds.lua`
- `_API_Special_func.lua`
- `_API_collection.lua`
- `_DST_API.lua`
- `imports_of_best_woodie/00_load_assets.lua`
- `imports_of_best_woodie/01_mod_config.lua`
- `imports_of_best_woodie/02_01_strings_ch.lua`
- `imports_of_best_woodie/02_02_strings_en.lua`
- `imports_of_best_woodie/03_strings_pre_init.lua`
- `imports_of_best_woodie/04_inventoryimages_icon_register.lua`
- `imports_of_best_woodie/05_minimap_icon_register.lua`
- `imports_of_best_woodie/06_load_sounds.lua`
- `imports_of_best_woodie/_all_imports_init.lua`
- `modinfo.lua`
- `modmain.lua`
- `scripts/_key_modules_of_best_woodie/00_others/00_debugging_hook.lua`
- `scripts/_key_modules_of_best_woodie/00_others/01_replica_register.lua`
- `scripts/_key_modules_of_best_woodie/00_others/02_hook_thesim.lua`
- `scripts/_key_modules_of_best_woodie/00_others/03_componentactions_crash_fix.lua`
- `scripts/_key_modules_of_best_woodie/00_others/04_rpc_event_register.lua`
- `scripts/_key_modules_of_best_woodie/00_others/05_client_data_api.lua`
- `scripts/_key_modules_of_best_woodie/00_others/06_the_input_upgrade.lua`
- `scripts/_key_modules_of_best_woodie/00_others/07_world_through_rpc_event.lua`
- `scripts/_key_modules_of_best_woodie/00_others/_all_others_init.lua`
- `scripts/_key_modules_of_best_woodie/01_player_prefab_hook/00_common_init.lua`
- `scripts/_key_modules_of_best_woodie/01_player_prefab_hook/01_best_woodie_classified_install.lua`
- `scripts/_key_modules_of_best_woodie/01_player_prefab_hook/_all_player_prefab_hook_init.lua`
- `scripts/_key_modules_of_best_woodie/01_player_prefab_hook/_excample.lua`
- `scripts/_key_modules_of_best_woodie/02_the_world_hook/00_world_common.lua`
- `scripts/_key_modules_of_best_woodie/02_the_world_hook/01_item_teleport_event.lua`
- `scripts/_key_modules_of_best_woodie/02_the_world_hook/_all_world_hook_init.lua`
- `scripts/_key_modules_of_best_woodie/02_the_world_hook/_excample.lua`
- `scripts/_key_modules_of_best_woodie/03_other_prefabs_hook/01_wood_edible.lua`
- `scripts/_key_modules_of_best_woodie/03_other_prefabs_hook/02_tree_seeds_quick_to_tool_slot.lua`
- `scripts/_key_modules_of_best_woodie/03_other_prefabs_hook/03_amulet.lua`
- `scripts/_key_modules_of_best_woodie/03_other_prefabs_hook/04_wereitems.lua`
- `scripts/_key_modules_of_best_woodie/03_other_prefabs_hook/05_cursed_monkey_token.lua`
- `scripts/_key_modules_of_best_woodie/03_other_prefabs_hook/_all_other_prefab_hook_init.lua`
- `scripts/_key_modules_of_best_woodie/04_origin_components_hook/00_excample_builder_replica_upgrade.lua`
- `scripts/_key_modules_of_best_woodie/04_origin_components_hook/00_excample_class_hook.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 6 |
| `AddPrefabPostInit` | `woodie` | 2 |
| `AddComponentPostInit` | `trader` | 1 |
| `AddComponentPostInit` | `heavyobstaclephysics` | 1 |
| `AddPrefabPostInit` | `leif` | 1 |
| `AddPrefabPostInit` | `bat` | 1 |
| `AddPrefabPostInit` | `frog` | 1 |
| `AddPrefabPostInit` | `butterfly` | 1 |
| `AddPrefabPostInit` | `amulet` | 1 |
| `AddPrefabPostInit` | `cursed_monkey_token` | 1 |
| `AddComponentPostInit` | `lootdropper` | 1 |
| `AddComponentPostInit` | `inventoryitem` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
--- 检查通报prefab加载失败
	AddPrefabPostInit("world",function(inst)
		if not TheWorld.ismastersim then
			return
		end
		if BESTWOODIE.__load_prefabs_error == true then
			inst:DoPeriodicTask(3,function()
				TheNet:Announce("best woodie ：加载Prefab遭遇错误。请前往查看日志")
			end)
		end
	end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
```
### AddPrefabPostInit("woodie")
```lua
    -- AddPlayerPostInit(function(inst)
    AddPrefabPostInit("woodie",function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("best_woodie_combat_CalcDamage_CMD",inventory_calc_event)
        inst:ListenForEvent("best_woodie_combat_CalcDamage_CMD_For_Target",inventory_calc_event_for_target)

    end)
```
### AddComponentPostInit("trader")
```lua
local player = GLOBAL.UserToPlayer(userid)
AddComponentPostInit("trader", function(Trader)    end) ---- 修改已有组件

inst:GetDistanceSqToInst(inst)
inst:IsNear(otherinst, dist)
inst:GetDistanceSqToPoint(x, y, z)
inst:IsNearPlayer(range, isalive)
inst:GetNearestPlayer(isalive)
inst:GetDistanceSqToClosestPlayer(isalive)
inst:FaceAwayFromPoint(dest, force)

--设置怪物大小
```
### AddComponentPostInit("heavyobstaclephysics")
```lua
AddClassPostConstruct("components/builder_replica", function(self) end)
AddComponentPostInit("heavyobstaclephysics", function(self) end)

NPC.components.debuffable:AddDebuff(NPC_ACION_DEBUFF, NPC_ACION_DEBUFF)
NPC.components.debuffable:RemoveDebuff(NPC_ACION_DEBUFF)
NPC:AddDebuff(NPC_ACION_DEBUFF, NPC_ACION_DEBUFF)
NPC:HasDebuff(DEBUFFNAME)
NPC:RemoveDebuff(DEBUFFNAME)

inst:HasTags(tags)
inst:HasOneOfTags(tags)

```
### AddPrefabPostInit("leif")
```lua
----- 怪物把玩家击飞（猪人活动的击飞倒地效果）
AddPrefabPostInit("leif", function(inst)
    local function OnHitOther(inst, other)
        other:PushEvent("knockback", {
            knocker = inst, -- 攻击者
            radius = 200, -- 击飞范围
            strengthmult = 1 -- 力量倍率
        })
    end
    if inst.components.combat ~= nil then
        inst.components.combat.onhitotherfn = OnHitOther
    end
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 5 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 3 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。