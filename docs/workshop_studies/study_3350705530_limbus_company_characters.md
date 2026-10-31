# 饥荒创意工坊研读报告：Limbus Company Characters 边狱巴士

- **模组标识**：`3350705530`
- **作者**：魔犬、 zzzzzzzs、 伊尹、 鬼针、 maotuki、 finn、马一甲
- **版本**：20260103
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：124 个 Lua 文件 / 共 16834 行；网络变量 4 处；RPC 2 处；注入钩子 9 处

## 一、代码结构与入口分布

顶层目录：`2521851770/`、`limbus/`、`scripts/`

Lua 文件清单（最多 40 条）：

- `2521851770/main/glassicrarity.lua`
- `2521851770/main/reskin_tool.lua`
- `2521851770/main/strings.lua`
- `2521851770/modclientmain.lua`
- `2521851770/modinfo.lua`
- `2521851770/modmain.lua`
- `2521851770/utils/skinhandler.lua`
- `2521851770/utils/slaxml.lua`
- `2521851770/utils/upvalueutil.lua`
- `limbus/actions.lua`
- `limbus/assets.lua`
- `limbus/boatsick.lua`
- `limbus/bugreport.lua`
- `limbus/characterhead.lua`
- `limbus/characters.lua`
- `limbus/common_modloader.lua`
- `limbus/controlledburn.lua`
- `limbus/create.lua`
- `limbus/dish.lua`
- `limbus/enkephalin_drop.lua`
- `limbus/food.lua`
- `limbus/fueled.lua`
- `limbus/imports.lua`
- `limbus/inventoryimages.lua`
- `limbus/language.lua`
- `limbus/languages/character.lua`
- `limbus/languages/main_en.lua`
- `limbus/languages/main_en2.lua`
- `limbus/languages/main_ja.lua`
- `limbus/languages/main_kr.lua`
- `limbus/languages/main_ru.lua`
- `limbus/languages/main_zh.lua`
- `limbus/languages/translate_clean.lua`
- `limbus/main.lua`
- `limbus/meursault.lua`
- `limbus/moisture_immune.lua`
- `limbus/nightvision.lua`
- `limbus/prefabgenerator.lua`
- `limbus/prefablist.lua`
- `limbus/prefabs/bean_band_cloth.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 2 |
| `AddStategraphPostInit` | `wilson_client` | 2 |
| `AddPrefabPostInit` | `reskin_tool` | 1 |
| `AddComponentPostInit` | `walkableplatform` | 1 |
| `AddPrefabPostInit` | `farm_plant_randomseed` | 1 |
| `AddComponentPostInit` | `locomotor` | 1 |
| `AddComponentPostInit` | `cursable` | 1 |
| `AddPrefabPostInit` | `klaus_sack` | 1 |
| `AddPrefabPostInit` | `world` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua
------------------ 主机 ---------------------------
AddStategraphPostInit("wilson", function(sg)
  local old_INTERACT_WITH = sg.actionhandlers[ACTIONS.INTERACT_WITH].deststate
  sg.actionhandlers[ACTIONS.INTERACT_WITH].deststate =
    function(inst, action, ...)
      if inst:HasTag("yisang") then
        inst:DoTaskInTime(0, function()
          if inst:GetBufferedAction() then inst:PerformBufferedAction() end
        end)
        return "talk"
      end
      return old_INTERACT_WITH(inst, action, ...)
```
### AddStategraphPostInit("wilson_client")
```lua
------------------ 客机 ---------------------------
AddStategraphPostInit("wilson_client", function(sg)
  local old_INTERACT_WITH = sg.actionhandlers[ACTIONS.INTERACT_WITH].deststate
  sg.actionhandlers[ACTIONS.INTERACT_WITH].deststate =
    function(inst, action, ...)
      if inst:HasTag("yisang") then return "previewaction" end
      return old_INTERACT_WITH(inst, action, ...)
    end
end)
-- honglu weed 80%概率杂草
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

```
### AddPrefabPostInit("reskin_tool")
```lua

AddPrefabPostInit("reskin_tool", function(inst)
	if not TheWorld.ismastersim then return end
	if inst.components.spellcaster then
		local can_cast_fn = inst.components.spellcaster.can_cast_fn
		inst.components.spellcaster:SetCanCastFn(function(doer, target, ...)
			local prefab_to_skin = target.prefab
			if table.contains(MODCHARACTERLIST, target.prefab) then
				if doer.userid == target.userid and target.components.beard and target.components.beard.is_skinnable then
					return validate_modchar_beard(doer, target)
				end
				return false
```
### AddComponentPostInit("walkableplatform")
```lua
AddComponentPostInit("walkableplatform", function(self)
  local old_AddPlayerOnPlatform = self.AddPlayerOnPlatform
  function self:AddPlayerOnPlatform(player)
    player:PushEvent("addplayeronplatform")
    old_AddPlayerOnPlatform(self, player)
  end
  -- 取消
  local old_RemovePlayerOnPlatform = self.RemovePlayerOnPlatform
  function self:RemovePlayerOnPlatform(player)
    player:PushEvent("removeplayeronplatform")
    old_RemovePlayerOnPlatform(self, player)
  end
```
### AddPrefabPostInit("farm_plant_randomseed")
```lua
end
AddPrefabPostInit("farm_plant_randomseed", function(inst)
  if not TheWorld.ismastersim then return end
  inst:ListenForEvent("on_planted", function(inst, data)
    if data ~= nil and data.doer ~= nil and data.doer:HasTag("honglu") and
      not inst.honglu_planted then
      inst.honglu_planted = true
      MakeWeed(inst)
    end
  end)
end)
-------突刺
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 4 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 2 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。