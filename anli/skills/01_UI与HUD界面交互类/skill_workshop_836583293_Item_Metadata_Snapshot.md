# 饥荒一线工坊深度研读 Skill：纯客机物品元数据镜像缓存与动作隔离沙盒机制

- **工坊 ID**：836583293 (`Item Info`)
- **领域分类**：纯客机端预测（Client-Only）、静态元数据镜像快照（Metadata Snapshot Cache）、探针动作静默沙盒、位面攻防（Planar）解析
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在联机版客机环境开发物品提示或背包增强工具时，无法直接读取服务端的 `components`。最稳健的工业级方案是：
1. **动作注册静默切面**：拦截 `EntityScript.RegisterComponentActions`，防止临时生成的探针实体污染全局动作池；
2. **静态沙盒探针**：生成瞬态实体，克隆其关键组件元数据（伤害、护甲、位面属性、保温系数等）存入只读缓存表；
3. **即时销毁探针**：提取完毕后立即 `Remove()`，后续悬停查询直接走 $O(1)$ 内存缓存。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：纯客机物品元数据沙盒快照与安全缓存器 (scripts/tools/item_metadata_cache.lua)
-- ==============================================================================

local ItemMetadataCache = {}
local CACHED_METADATA = {}
local IS_PROBING = false

-- 1. 注入动作静默守卫：防止临时探针注册全局交互动作
AddGlobalClassPostConstruct("entityscript", "EntityScript", function(self)
    local old_RegisterComponentActions = self.RegisterComponentActions
    self.RegisterComponentActions = function(inst, name)
        if not IS_PROBING then
            return old_RegisterComponentActions(inst, name)
        end
        -- 探针生成期间彻底静默
    end
end)

-- 2. 提取并缓存目标物品的静态原型属性
function ItemMetadataCache.GetMetadata(prefab_name)
    if not prefab_name or type(prefab_name) ~= "string" then return nil end
    if CACHED_METADATA[prefab_name] then
        return CACHED_METADATA[prefab_name]
    end

    -- 开启沙盒隔离探针
    IS_PROBING = true
    local probe = GLOBAL.SpawnPrefab(prefab_name)
    IS_PROBING = false

    if not probe then return nil end

    local meta = {
        prefab = prefab_name,
        damage = 0,
        planar_damage = 0,
        absorb_percent = 0,
        insulation_winter = 0,
        insulation_summer = 0,
    }

    -- 提取武器物理与位面伤害
    if probe.components.weapon then
        meta.damage = probe.components.weapon.damage or 0
    end
    if probe.components.planardamage then
        meta.planar_damage = probe.components.planardamage:GetBaseDamage() or 0
    end

    -- 提取护甲与位面防御
    if probe.components.armor then
        meta.absorb_percent = probe.components.armor.absorb_percent or 0
    end

    -- 提取保温系数
    if probe.components.insulator then
        local val = probe.components.insulator.insulation or 0
        if probe.components.insulator.type == GLOBAL.SEASONS.WINTER then
            meta.insulation_winter = val
        else
            meta.insulation_summer = val
        end
    end

    -- 核心：即时销毁探针，绝不残留场景实体句柄
    probe:Remove()

    -- 写入全局缓存
    CACHED_METADATA[prefab_name] = meta
    return meta
end

return ItemMetadataCache
```

---

## 三、避坑与生产安全准则

1. **绝对禁止遗漏 `IS_PROBING` 守卫标志位**：
   - 如果在没有静默 `RegisterComponentActions` 的情况下在客机频繁生成探针实体，其它 Mod 挂载的动作钩子会尝试向探针注入行为，导致客户端出现瞬时微卡顿，甚至抛出网络协议不同步警告。
2. **只读元数据与动态状态的解耦**：
   - 探针提取的是**初始原型静态数据**（如基础最大攻击力）。当前剩余耐久或保鲜度百分比，必须在运行时结合客户端已有的 `replica.inventoryitem` 或网络分类实体动态乘算，严禁直接把当前实体的动态耐久存入缓存。
