# 饥荒创意工坊研读报告：云霄国度-Above the Clouds

- **模组标识**：`3322803908`
- **作者**：Jerry, Tony, ziwbi, 亚丹, 鲁鲁, 小巫, 每年睡8760小时, 老王
- **版本**：1.0.50
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：807 个 Lua 文件 / 共 165915 行；网络变量 152 处；RPC 2 处；注入钩子 78 处

## 一、代码结构与入口分布

顶层目录：`main/`、`postinit/`、`scripts/`、`strings/`

Lua 文件清单（最多 40 条）：

- `main/RPC.lua`
- `main/actions.lua`
- `main/assets.lua`
- `main/commands.lua`
- `main/constants.lua`
- `main/containers.lua`
- `main/cooking.lua`
- `main/fx.lua`
- `main/pl_worldsettings_overrides.lua`
- `main/postinit.lua`
- `main/recipes.lua`
- `main/standardcomponents.lua`
- `main/strings.lua`
- `main/tiledefs.lua`
- `main/tileutil.lua`
- `main/toolutil.lua`
- `main/tuning.lua`
- `main/util.lua`
- `modcustomizeitems.lua`
- `modfrontendmain.lua`
- `modinfo.lua`
- `modmain.lua`
- `modservercreationmain.lua`
- `modworldgenmain.lua`
- `postinit/animstate.lua`
- `postinit/behaviours/chaseandattack.lua`
- `postinit/behaviours/runaway.lua`
- `postinit/behaviours/useshield.lua`
- `postinit/behaviours/wander.lua`
- `postinit/bufferedaction.lua`
- `postinit/cameras/followcamera.lua`
- `postinit/components/actionqueuer.lua`
- `postinit/components/ambientlighting.lua`
- `postinit/components/amphibiouscreature.lua`
- `postinit/components/areaaware.lua`
- `postinit/components/blinkstaff.lua`
- `postinit/components/builder.lua`
- `postinit/components/builder_replica.lua`
- `postinit/components/burnable.lua`
- `postinit/components/clock.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabRegisterPostInit` | `spoiled_food` | 2 |
| `AddComponentPostInit` | `health` | 2 |
| `AddPrefabPostInit` | `grass` | 2 |
| `AddComponentPostInit` | `actionqueuer` | 1 |
| `AddComponentPostInit` | `ambientlighting` | 1 |
| `AddComponentPostInit` | `amphibiouscreature` | 1 |
| `AddComponentPostInit` | `clock` | 1 |
| `AddComponentPostInit` | `colourcube` | 1 |
| `AddComponentPostInit` | `combat` | 1 |
| `AddComponentPostInit` | `container` | 1 |
| `AddComponentPostInit` | `equippable` | 1 |
| `AddComponentPostInit` | `floater` | 1 |

## 三、关键代码片段

### AddPrefabRegisterPostInit("spoiled_food")
```lua
-- ```lua
-- AddPrefabRegisterPostInit("spoiled_food", function(spoiled_food)
--     local spoiled_food_constructor = spoiled_food.fn
--     local food_OnIsRaining, food_mastersim_init, i = ToolUtil.GetUpvalue(spoiled_food_constructor, "food_mastersim_init.food_OnIsRaining")
--     if not food_OnIsRaining then
--         return
--     end
--     debug.setupvalue(food_mastersim_init, i, function(inst, israining, ...)
--         if inst:GetIsInInterior() then
--             inst.components.disappears:StopDisappear()
--             return
--         end
```
### AddComponentPostInit("health")
```lua

AddComponentPostInit("health", function(self)
    self.vulnerabletopoisondamage = true
    self.poison_damage_scale = 1
end)
```
### AddPrefabPostInit("grass")
```lua

AddPrefabPostInit("grass", function (inst)
    MakePickableBlowInWindGust(inst, TUNING.GRASS_WINDBLOWN_SPEED, TUNING.GRASS_WINDBLOWN_FALL_CHANCE)
end)

AddPrefabPostInit("depleted_grass", function (inst)
    MakePickableBlowInWindGust(inst, TUNING.GRASS_WINDBLOWN_SPEED, TUNING.GRASS_WINDBLOWN_FALL_CHANCE)
end)

AddPrefabPostInit("sapling", function (inst)
    MakePickableBlowInWindGust(inst, TUNING.SAPLING_WINDBLOWN_SPEED, TUNING.SAPLING_WINDBLOWN_FALL_CHANCE)
end)
```
### AddComponentPostInit("actionqueuer")
```lua
-- for client mod ActionQueue
AddComponentPostInit("actionqueuer", function(self)
    if self.AddActionList then
        self.AddActionList("allclick", "SHEAR", "HACK", "PAN", "DISLODGE")
        self.AddActionList("leftclick", "SHEAR", "HACK", "PAN", "REPAIRBOAT", "RETRIEVE", "DISLODGE")
        self.AddActionList("autocollect", "SHEAR", "HACK", "PAN", "DISLODGE")
        self.AddActionList("noworkdelay", "SHEAR", "HACK", "PAN", "DISLODGE")
    end
end)
```
### AddComponentPostInit("ambientlighting")
```lua

AddComponentPostInit("ambientlighting", function(self, inst)
    local _realcolour = ToolUtil.GetUpvalue(self.LongUpdate, "_realcolour")

    function self:GetRealColour()
        return _realcolour.currentcolour.x, _realcolour.currentcolour.y, _realcolour.currentcolour.z
    end

    local DoUpdateFlash = ToolUtil.GetUpvalue(self.OnUpdate, "DoUpdateFlash")
    local _overridecolour = ToolUtil.GetUpvalue(DoUpdateFlash, "_overridecolour")
    local ComputeTargetColour, scope_fn, i = ToolUtil.GetUpvalue(DoUpdateFlash, "ComputeTargetColour")

```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 152 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 2 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。