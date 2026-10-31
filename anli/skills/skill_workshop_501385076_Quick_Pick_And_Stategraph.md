# 饥荒一线工坊深度研读 Skill：Pickable 组件属性注入与 StateGraph 动作状态机重定向技术

- **工坊 ID**：501385076 (`Quick Pick`)
- **领域分类**：`pickable.quickpick` 标志位注入、`AddStategraphPostInit` 动作处理器劫持（`ActionHandler`）、跨 Mod 依赖探测
- **研读基准**：Steam 创意工坊在线原版源码

---

---

## 一、核心实现原理与架构全貌

在开发“一键收菜、加速采集、自动化农业、懒人交互”类 Mod 时：
1. **组件标志短路**：直接利用官方 `pickable` 组件内置的 `quickpick = true` 属性，免去繁琐的自定义状态机；
2. **状态机动作用途重定向**：通过 `AddStategraphPostInit` 动态替换 `ActionHandler`，将原本漫长的采集/烹饪动作映射为极速短动作（`doshortaction`）。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：批量为植物组件注入闪电采摘属性 (modmain.lua)
-- ==============================================================================

local function EnableQuickPickForPrefabs(prefab_list)
    for _, prefab_name in ipairs(prefab_list) do
        GLOBAL.AddPrefabPostInit(prefab_name, function(inst)
            -- 核心：激活官方内置的闪电采集标志
            if inst.components.pickable then
                inst.components.pickable.quickpick = true
            end
        end)
    end
end

-- 注册常见植物
EnableQuickPickForPrefabs({
    "sapling", "grass", "berrybush", "berrybush2", "reeds", "marsh_bush"
})

-- ==============================================================================
-- 范式 2：StateGraph 动作状态机极速短动作劫持 (modmain.lua)
-- ==============================================================================

local function RedirectActionToShort(action_enum)
    GLOBAL.AddStategraphPostInit("wilson", function(sg)
        if sg.actionhandlers and GLOBAL.ACTIONS[action_enum] then
            local action_obj = GLOBAL.ACTIONS[action_enum]
            -- 将官方默认的长动作重定向为 "doshortaction"
            sg.actionhandlers[action_obj] = GLOBAL.ActionHandler(action_obj, "doshortaction")
        end
    end)
end

-- 应用收成动作与烹饪动作加速
RedirectActionToShort("HARVEST")
RedirectActionToShort("COOK")
```

---

## 三、避坑与生产安全准则

1. **`pickable` 校验不可或缺**：
   - 在 `AddPrefabPostInit` 中操作组件前必须先做 `if inst.components.pickable then` 判空断言。部分官方变体或模组实体在特定季节或状态下会动态剥离 `pickable` 组件，盲目赋值会导致 Lua 报错崩溃。
2. **动作用途枚举检查**：
   - 使用 `GLOBAL.ACTIONS[action_enum]` 时，确保该动作在当前游戏版本（单机/联机/DLC）中真实存在，否则会返回 `nil` 并导致 `sg.actionhandlers` 键值注入异常。
