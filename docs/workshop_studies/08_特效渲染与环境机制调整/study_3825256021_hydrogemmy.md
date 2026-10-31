# 饥荒创意工坊研读报告：氢瑶薄赋Hydrogemmy

- **模组标识**：`3825256021`
- **作者**：氢瑶薄赋
- **版本**：1.0.3
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：14 个 Lua 文件 / 共 7666 行；网络变量 9 处；RPC 3 处；注入钩子 3 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/hydrogemmy_abilities.lua`
- `scripts/hydrogemmy_config.lua`
- `scripts/hydrogemmy_teleport.lua`
- `scripts/hydrogemmy_timestop.lua`
- `scripts/prefabs/hydrogemmy.lua`
- `scripts/prefabs/hydrogemmy_crimson_king.lua`
- `scripts/prefabs/hydrogemmy_crown.lua`
- `scripts/prefabs/hydrogemmy_hourglass_ring.lua`
- `scripts/prefabs/hydrogemmy_jade_crown.lua`
- `scripts/prefabs/hydrogemmy_none.lua`
- `scripts/prefabs/hydrogemmy_star_sword.lua`
- `scripts/speech_hydrogemmy.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `birdspawner` | 1 |
| `AddComponentPostInit` | `spawner` | 1 |
| `AddPrefabPostInit` | `world` | 1 |

## 三、关键代码片段

### AddComponentPostInit("birdspawner")
```lua
-- 鸟：生成前检查落点
AddComponentPostInit("birdspawner", function(self)
    local old_SpawnBird = self.SpawnBird
    if old_SpawnBird == nil then
        return
    end

    self.SpawnBird = function(self, spawnpoint, ignorebait)
        if spawnpoint ~= nil and HydroTimeStop:IsPointBlocked(spawnpoint.x, spawnpoint.z) then
            return
        end
        return old_SpawnBird(self, spawnpoint, ignorebait)
```
### AddComponentPostInit("spawner")
```lua
-- 巢穴类：生成延迟被拦住
AddComponentPostInit("spawner", function(self)
    local old_SpawnWithDelay = self.SpawnWithDelay
    if old_SpawnWithDelay == nil then
        return
    end

    self.SpawnWithDelay = function(self, delay)
        local x, _, z = self.inst.Transform:GetWorldPosition()
        if HydroTimeStop:IsPointBlocked(x, z) then
            return
        end
```
### AddPrefabPostInit("world")
```lua
--   世界上的食物腐烂、植物生长、火堆、天气、怪物刷新计时都会照常前进。
AddPrefabPostInit("world", function(inst)
    inst.HydrogemmyCrimsonJump = function(self, seconds)
        GLOBAL.LongUpdate(seconds, true)
    end
end)

------------------------------------------------------------------
-- 反鲜：给玩家挂 preserver，而不是给每件物品改倍率
--
--   perishable.lua:68/78
--     local owner = inst.components.inventoryitem.owner
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 9 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 3 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。