# 饥荒创意工坊研读报告：DST Sophisticated Backpacks | 精妙背包 v0.5.6.5 终极升级链

- **模组标识**：`3825332710`
- **作者**：DST Sophisticated Backpacks Project
- **版本**：0.5.6.5-test
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：19 个 Lua 文件 / 共 3601 行；网络变量 0 处；RPC 0 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`scripts/`、`tools/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/prefabs/sb_backpacks.lua`
- `scripts/prefabs/sb_modules.lua`
- `scripts/prefabs/sb_ultimate_cores.lua`
- `scripts/sb_autocraft.lua`
- `scripts/sb_backpack_defs.lua`
- `scripts/sb_cooking_v0553.lua`
- `scripts/sb_equip_compat.lua`
- `scripts/sb_generated_icons.lua`
- `scripts/sb_gramophone.lua`
- `scripts/sb_module_defs.lua`
- `scripts/sb_module_runtime.lua`
- `scripts/sb_ultimate_core_defs.lua`
- `tools/backpack_ground_sources/sb_backpacks_after_compile.lua`
- `tools/ground_anim_sources/sb_modules_after_compile.lua`
- `tools/ground_anim_sources/sb_ultimate_core_defs_after_compile.lua`
- `tools/upgrade_kit_ground_sources/sb_backpacks_with_kits_after_compile.lua`
- `tools/upgrade_kit_ground_sources/sb_backpacks_with_ultimate_ground_after_compile.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `inventory` | 1 |
| `AddPrefabPostInit` | `inventory_classified` | 1 |

## 三、关键代码片段

### AddComponentPostInit("inventory")
```lua
-- Sophisticated Backpack serve as the overflow backpack (regardless of slot).
AddComponentPostInit("inventory", function(self)
    local oldGetOverflowContainer = self.GetOverflowContainer
    if oldGetOverflowContainer == nil then return end
    self.GetOverflowContainer = function(inv, ...)
        local existing = oldGetOverflowContainer(inv, ...)
        if existing ~= nil or inv.ignoreoverflow then
            return existing
        end
        local bag = equipcompat.FindEquippedBackpack(inv)
        local container = bag ~= nil and bag.components ~= nil and bag.components.container or nil
        return container ~= nil and container.canbeopened and container or nil
```
### AddPrefabPostInit("inventory_classified")
```lua
-- Deliberately does NOT rewrite the classified's private Has/Consume logic.
AddPrefabPostInit("inventory_classified", function(inst)
    if G.TheWorld.ismastersim or inst.GetOverflowContainer == nil then return end
    local oldGetOverflowContainer = inst.GetOverflowContainer
    inst.GetOverflowContainer = function(classified, ...)
        local existing = oldGetOverflowContainer(classified, ...)
        if existing ~= nil or classified.ignoreoverflow then return existing end
        if classified.GetEquips ~= nil then
            for _, item in pairs(classified:GetEquips() or {}) do
                if equipcompat.IsBackpack(item)
                    and item.replica ~= nil and item.replica.container ~= nil then
                    return item.replica.container
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。