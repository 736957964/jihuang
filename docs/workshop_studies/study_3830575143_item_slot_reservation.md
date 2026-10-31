# 饥荒创意工坊研读报告：Item Slot Reservation

- **模组标识**：`3830575143`
- **作者**：未知
- **版本**：0.1.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：15 个 Lua 文件 / 共 2987 行；网络变量 0 处；RPC 2 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/isr_slotmarkstore.lua`
- `scripts/isr_candidates.lua`
- `scripts/isr_config.lua`
- `scripts/isr_debug.lua`
- `scripts/isr_env.lua`
- `scripts/isr_icons.lua`
- `scripts/isr_inventoryhooks.lua`
- `scripts/isr_markstores.lua`
- `scripts/isr_persistence.lua`
- `scripts/isr_placement.lua`
- `scripts/isr_slotmarks.lua`
- `scripts/isr_storage.lua`
- `scripts/isr_uihooks.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `container` | 3 |
| `AddComponentPostInit` | `inventory` | 2 |

## 三、关键代码片段

### AddComponentPostInit("container")
```lua

AddComponentPostInit("container", function(self)
    local old_GiveItem = self.GiveItem
    function self:GiveItem(item, slot, src_pos, drop_on_fail)
        local owner = ISR.ResolvePlayerStorageOwner(self, "container")
        if owner == nil then
            return old_GiveItem(self, item, slot, src_pos, drop_on_fail)
        end

        local container_guid = self.inst ~= nil and self.inst.GUID or nil
        local placement_context = ISR.MakePlacementContext({
            owner = owner,
```
### AddComponentPostInit("inventory")
```lua
local function AddPlayerInventoryPostInit(fn)
    AddComponentPostInit("inventory", function(self)
        if ISR.IsPlayerInventoryComponent(self) then
            fn(self)
        end
    end)
end

AddPlayerInventoryPostInit(function(self)
    local old_GetNextAvailableSlot = self.GetNextAvailableSlot
    function self:GetNextAvailableSlot(item)
        local slot, container = old_GetNextAvailableSlot(self, item)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
2. 注册了 2 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。