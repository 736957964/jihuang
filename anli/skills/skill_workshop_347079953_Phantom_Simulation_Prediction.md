# 饥荒一线工坊深度研读 Skill：虚拟沙盒预演（Phantom Simulation）与状态机前瞻运算

- **工坊 ID**：347079953 (`Display food values`)
- **领域分类**：瞬态脱离场景预演（`RemoveFromScene`）、配方转换前瞻模拟（`cookable:Cook`）、角色 Eater 特性透传、`net_string` 脏同步
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在需要向玩家揭示“物品未来形态（如烤制后三维、精炼后产物、附魔后词条）”的 Mod 研发中，直接修改真实物品会造成极其严重的副作用。标准工程范式是**内存沙盒预演（Phantom Entity Simulation）**：
1. **脱离场景生成**：`inst = SpawnPrefab(...)` 后立即 `inst:RemoveFromScene()`；
2. **在隔离区触发行为**：调用官方组件的变换方法（如 `cookable:Cook`）；
3. **读取预测属性后彻底销毁**：提取所需数值后立刻 `inst:Remove()`，达成零副作用。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：轻量内存沙盒预演探针 (scripts/tools/phantom_simulation.lua)
-- ==============================================================================

local PhantomSimulation = {}

--- 在服务端内存中创建一个不参与物理和渲染的虚拟实体镜像
--- @param prefab_name string 预制体名称
--- @return table|nil 虚拟实体句柄
function PhantomSimulation.CreatePhantom(prefab_name)
    if not GLOBAL.TheWorld.ismastersim then return nil end

    local inst = GLOBAL.SpawnPrefab(prefab_name)
    if inst then
        -- 核心隔离 1：从物理与渲染场景中彻底剥离
        inst:RemoveFromScene()
        -- 核心隔离 2：标记不持久化保存，防止存盘
        inst.persists = false
    end
    return inst
end

--- 预测某物品在烤制后的真实三维属性
--- @param raw_item_prefab string 生食预制体名称
--- @param eater_player table 食用者角色实体 (用于结合特性计算加成)
--- @return table 预测结果 { hunger = number, health = number, sanity = number }
function PhantomSimulation.PredictCookedValues(raw_item_prefab, eater_player)
    local raw_inst = PhantomSimulation.CreatePhantom(raw_item_prefab)
    if not raw_inst then return { hunger = 0, health = 0, sanity = 0 } end

    local result = { hunger = 0, health = 0, sanity = 0 }

    -- 检查是否可烤制
    if raw_inst.components.cookable then
        local campfire = PhantomSimulation.CreatePhantom("campfire")
        local cooked_inst = raw_inst.components.cookable:Cook(campfire, eater_player)

        if cooked_inst and cooked_inst.components.edible then
            -- 传入真实玩家，使角色特异性乘数 (如女武神、大力士) 生效
            result.hunger = math.floor(cooked_inst.components.edible:GetHunger(eater_player) * 10 + 0.5) / 10
            result.health = math.floor(cooked_inst.components.edible:GetHealth(eater_player) * 10 + 0.5) / 10
            result.sanity = math.floor(cooked_inst.components.edible:GetSanity(eater_player) * 10 + 0.5) / 10
            
            cooked_inst:Remove() -- 销毁熟食镜像
        end

        if campfire then campfire:Remove() end
    end

    raw_inst:Remove() -- 销毁生食镜像
    return result
end

-- ==============================================================================
-- 范式 2：基于 net_string 的单播属性广播通道 (scripts/components/food_predictor.lua)
-- ==============================================================================

local FoodPredictor = GLOBAL.Class(function(self, inst)
    self.inst = inst
    -- 网络脏标记字符串 (最大支持 255 字节紧凑富文本)
    self.preview_dirty = GLOBAL.net_string(self.inst.GUID, "food_preview", "on_food_preview_dirty")
end)

function FoodPredictor:UpdatePreview(player, item_prefab, is_cooked_preview)
    if not GLOBAL.TheWorld.ismastersim then return end

    local vals = is_cooked_preview 
        and PhantomSimulation.PredictCookedValues(item_prefab, player)
        or { hunger = 0, health = 0, sanity = 0 }

    local formatted_str = string.format("Hunger: %+0.1f | Health: %+0.1f | Sanity: %+0.1f", 
        vals.hunger, vals.health, vals.sanity)

    -- 触发客户端事件监听
    self.preview_dirty:set(formatted_str)
end

return {
    PhantomSimulation = PhantomSimulation,
    FoodPredictor = FoodPredictor,
}
```

---

## 三、避坑与生产安全准则

1. **虚拟预制体严防内存泄漏（Phantom Memory Leak）**：
   - 任何调用 `CreatePhantom` 产生的实体，在当前函数返回前**必须严格调用 `inst:Remove()`**。若忘记销毁，成千上万个不可见实体将堆积在 Lua 内存与 C++ 场景管理树中，数分钟即可将服务器内存撑爆崩溃。
2. **`edible:GetHunger(player)` 必须传入 `player` 实例**：
   - 原版很多新手直接读取 `item.components.edible.hungervalue`。这会导致沃斯（鱼人）吃蔬菜没有加成、温蒂吃阿比盖尔之花不会扣血等严重的机制计算失真。必须调用带角色的 Getter 方法。
