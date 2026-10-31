# 饥荒创意工坊研读报告：Extra Equip Slots (NO-LI UPDATED)

- **模组标识**：`3830466017`
- **作者**：xVars (Modified by Magic, updated by Eetulfus)
- **版本**：2.3.0
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 927 行；网络变量 1 处；RPC 0 处；注入钩子 3 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `inventory` | 2 |
| `AddPrefabPostInit` | `inventory_classified` | 2 |
| `AddStategraphPostInit` | `wilson` | 1 |

## 三、关键代码片段

### AddComponentPostInit("inventory")
```lua

    AddComponentPostInit("inventory", function(self, inst)
        if inst:HasTag("player") and self.maxslots == DEFAULT_SLOTS and UsesDefaultSlots() then
            -- maxslots is made read-only once the player's inventory_classified exists;
            -- makereadonly keeps the value in the class property table
            local props = GLOBAL.rawget(self, "_")
            if props ~= nil and props.maxslots ~= nil then
                props.maxslots[1] = INVENTORY_SLOTS
            else
                self.maxslots = INVENTORY_SLOTS
            end
        end
```
### AddPrefabPostInit("inventory_classified")
```lua
    -- slot listeners are registered a frame later, so they pick these up)
    AddPrefabPostInit("inventory_classified", function(inst)
        if inst._items ~= nil and #inst._items == DEFAULT_SLOTS and UsesDefaultSlots() then
            for i = #inst._items + 1, INVENTORY_SLOTS do
                table.insert(inst._items, GLOBAL.net_entity(inst.GUID, "inventory._items["..tostring(i).."]", "items["..tostring(i).."]dirty"))
            end
        end
    end)

    -- clients have no inventory component to ask
    local InventoryReplica = require("components/inventory_replica")
    local GetNumSlots_base = InventoryReplica.GetNumSlots
```
### AddStategraphPostInit("wilson")
```lua
if NECK_SLOT then
    AddStategraphPostInit("wilson", function(sg)
        local state = sg.states.amulet_rebirth
        if state == nil then
            return
        end

        local onenter_base = state.onenter
        state.onenter = function(inst, ...)
            onenter_base(inst, ...)
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
            if item ~= nil and item.prefab == "amulet" then
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 1 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。