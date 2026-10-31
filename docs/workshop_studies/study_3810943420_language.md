# 饥荒创意工坊研读报告：Language

- **模组标识**：`3810943420`
- **作者**：Lilith
- **版本**：1.0.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：5 个 Lua 文件 / 共 1253 行；网络变量 0 处；RPC 0 处；注入钩子 3 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/add_containers.lua`
- `scripts/main/action/kce_instantspell.lua`
- `scripts/prefabs/modstaff_common.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `king_cane` | 1 |
| `AddPrefabPostInit` | `king_cane_fx` | 1 |
| `AddPrefabPostInit` | `vault_orb_refined` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("king_cane")
```lua
end
AddPrefabPostInit("king_cane",addenhance)

local function fx_OnGemFxDirty(inst)
    local gemtype = inst.gem:value()
    if gemtype ~= "" then
        inst.gemfx.AnimState:OverrideSymbol("swap_gem", "king_cane_mod", "swap_"..gemtype)
    else
        inst.gemfx.AnimState:ClearOverrideSymbol("swap_gem")
    end
end

```
### AddPrefabPostInit("king_cane_fx")
```lua

AddPrefabPostInit("king_cane_fx",function(inst) 
	inst:DoTaskInTime(0,function()
		inst.AnimState:SetBank("king_cane_mod")
		inst.AnimState:SetBuild("king_cane_mod")
		inst.AnimState:PlayAnimation("swap_loop1", true) 
	end)
	if not TheWorld.ismastersim then
        inst.OnEntityReplicated = fx_OnEntityReplicated
        inst:ListenForEvent("gemdirty", fx_OnGemFxDirty)
        return inst
    end
```
### AddPrefabPostInit("vault_orb_refined")
```lua
end)
AddPrefabPostInit("vault_orb_refined",function(inst) inst:AddTag("vault_orb_refined") end)
for k,v in pairs(skilltab) do
	if v.name ~= "consume" then
		AddPrefabPostInit(v.name,function(inst) inst:AddTag(v.name) end)
	end
end 
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。