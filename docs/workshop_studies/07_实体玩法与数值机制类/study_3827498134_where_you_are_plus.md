# 饥荒创意工坊研读报告：Where you are?plus

- **模组标识**：`3827498134`
- **作者**：CrushWater
- **版本**：1.2.5
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：6 个 Lua 文件 / 共 516 行；网络变量 0 处；RPC 1 处；注入钩子 4 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/prefabs/wya_beefalo.lua`
- `scripts/prefabs/wya_lightninggoat.lua`
- `scripts/prefabs/wya_tumbleweed.lua`
- `scripts/screens/creaturewidget.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `beefalo` | 1 |
| `AddPrefabPostInit` | `beefaloherd` | 1 |
| `AddPrefabPostInit` | `lightninggoatherd` | 1 |
| `AddPrefabPostInit` | `tumbleweedspawner` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("beefalo")
```lua
end
AddPrefabPostInit("beefalo", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:DoTaskInTime(FRAMES, function(inst)
        inst.UpdateDomestication = UpdateDomestication
    end)
end)

-- AddPrefabPostInit("beefaloherd", function(inst)
--     inst.entity:AddNetwork()
--     -- inst.entity:SetPristine()

```
### AddPrefabPostInit("beefaloherd")
```lua

-- AddPrefabPostInit("beefaloherd", function(inst)
--     inst.entity:AddNetwork()
--     -- inst.entity:SetPristine()

--     if not TheWorld.ismastersim then return inst end

--     inst:DoTaskInTime(FRAMES, function(inst)
--         local fx = SpawnPrefab("wya_beefalo")
--         fx.entity:SetParent(inst.entity)
--     end)
-- end)
```
### AddPrefabPostInit("lightninggoatherd")
```lua
---------------------------------------设置羊群刷新点在地图上显示-------------------------------------------
AddPrefabPostInit("lightninggoatherd", function(inst)
    inst.entity:AddNetwork()
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(FRAMES, function(inst)
        local fx = SpawnPrefab("wya_lightninggoat")
        fx.entity:SetParent(inst.entity)
    end)
end)
```
### AddPrefabPostInit("tumbleweedspawner")
```lua
---------------------------------------设置风滚草刷新点在地图上显示-------------------------------------------
AddPrefabPostInit("tumbleweedspawner", function(inst)

    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(FRAMES, function(inst)
        if inst.wya_spawner == nil or inst.wya_spawner == false then
            local fx = SpawnPrefab("wya_tumbleweed")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.wya_spawner = true
        end
    end)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。