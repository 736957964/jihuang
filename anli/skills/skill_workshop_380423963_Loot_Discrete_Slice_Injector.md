# 饥荒一线工坊深度研读 Skill：LootTables 离散切片分解与跨 Mod 掉落表防覆写代理技术

- **工坊 ID**：380423963 (`Mineable Gems`)
- **领域分类**：`LootTables` 动态切片与注入、高倍率概率离散化拆分、跨 Mod 掉落表代理合并、浮点微差截断阀
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“掉落增强、Boss 战利品掉落倍率、矿物开采附加物、特殊活动宝箱”等掉落类 Mod 时：
1. **超额倍率离散化**：将大于 1.0 的期望倍率循环拆解为若干个 100% 独立项与末尾小数项，契合原生 `math.random() <= chance` 判定；
2. **防覆写代理**：拦截官方 `SetSharedLootTable`，建立哈希标记，防御其他 Mod 暴力重置整个掉落表；
3. **浮点死循环熔断**：通过 `while value > 0.0000001` 截断微量浮点尾差。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：工业级通用掉落表离散注入器 (scripts/tools/loot_injector.lua)
-- ==============================================================================

local LootInjector = {}

--- 向全局共享掉落表注入或叠加物品掉落判定
--- @param target_prefabs string|table 目标预制体名称或数组
--- @param item_prefab string 掉落物预制体名称
--- @param chance_or_weight number 掉落几率 (如 0.25 或 2.5)
function LootInjector.AddLoot(target_prefabs, item_prefab, chance_or_weight)
    if not GLOBAL.TheWorld or not GLOBAL.TheWorld.ismastersim then return end

    -- 递归解包预制体数组
    if type(target_prefabs) == "table" then
        for _, name in ipairs(target_prefabs) do
            LootInjector.AddLoot(name, item_prefab, chance_or_weight)
        end
        return
    end

    local LootTables = GLOBAL.LootTables
    if not LootTables then return end

    if not LootTables[target_prefabs] then
        LootTables[target_prefabs] = {}
    end

    local target_table = LootTables[target_prefabs]

    -- 初始化防覆盖保护头
    if not target_table._protected_marks then
        target_table._protected_marks = {}
        for _, existing_entry in ipairs(target_table) do
            target_table._protected_marks[existing_entry[1]] = true
        end
    end

    -- 核心：离散切片算法，将大倍率拆为多个 1.0 + 小数部分
    local remaining = chance_or_weight
    while remaining > 0.0000001 do
        local chunk = (remaining > 1) and 1.0 or remaining
        table.insert(target_table, { item_prefab, chunk })
        remaining = remaining - chunk
    end

    target_table._protected_marks[item_prefab] = true
end

-- ==============================================================================
-- 范式 2：官方 SetSharedLootTable 冲突让步代理 (modmain.lua)
-- ==============================================================================

local function InstallLootTableConflictDefense()
    if not GLOBAL.TheNet or not GLOBAL.TheNet:GetIsServer() then return end

    local LootTables = GLOBAL.LootTables
    local old_SetSharedLootTable = GLOBAL.SetSharedLootTable

    GLOBAL.SetSharedLootTable = function(name, new_table)
        local existing = LootTables and LootTables[name]

        -- 如果该表已被本 Mod 注入并打上了保护印记
        if existing and existing._protected_marks then
            -- 融合对方的新增项，保留本 Mod 的独立掉落项
            for _, entry in ipairs(new_table) do
                local item_name = entry[1]
                if not existing._protected_marks[item_name] then
                    table.insert(existing, entry)
                end
            end
        else
            -- 正常放行官方或第三方初始调用
            if old_SetSharedLootTable then
                old_SetSharedLootTable(name, new_table)
            else
                LootTables[name] = new_table
            end
        end
    end
end

InstallLootTableConflictDefense()

return {
    LootInjector = LootInjector,
}
```

---

## 三、避坑与生产安全准则

1. **绝对禁止在客户端执行掉落表修改**：
   - 掉落计算纯属服务端物理与状态机逻辑。客机执行此类代码毫无意义，且若客机修改了全局变量还会造成脏数据污染，必须用 `TheWorld.ismastersim` 前置截断。
2. **`while` 循环截断阈值不可设为 `> 0`**：
   - 计算机由于 IEEE 754 浮点误差，执行 `remaining = remaining - 1` 之后往往会留下 $1.421 \times 10^{-14}$ 这类非零极小量。若只写 `while remaining > 0`，将直接陷入无限死循环并触发服务端冻结崩溃。
