# 饥荒一线工坊深度研读 Skill：全局 TUNING 梯队注入与 AddPrefabPostInitAny 智能逼近

- **工坊 ID**：374550642 (`Increased Stack size`)
- **领域分类**：全局 TUNING 宏变量重写、`AddPrefabPostInitAny` 全局实体切面优化、非标离散数值区间逼近算法
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在饥荒模组开发中，很多全局性调整（如调整全服腐烂速度、全服堆叠上限、全服移动速度倍率）有两种流派：
1. **轻量流派（推荐首选）**：改写官方 `GLOBAL.TUNING` 表中的宏常量；
2. **强制穿透流派（防御第三方硬编码）**：借助 `AddPrefabPostInitAny` 拦截所有实例化实体并强行修正组件。

`Increased Stack Size` 提供了这两种流派融合的最佳实践。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：全局 TUNING 五级梯队宏覆盖 (modmain.lua)
-- ==============================================================================

local TUNING = GLOBAL.TUNING

-- 1. 覆写官方标准梯队 (侵入性最低，零运行时开销)
TUNING.STACK_SIZE_LARGEITEM = 40  -- 原版 10 (如大肉、原木)
TUNING.STACK_SIZE_MEDITEM   = 80  -- 原版 20 (如草、枝条、石头)
TUNING.STACK_SIZE_SMALLITEM = 99  -- 原版 40 (如浆果、花瓣)
TUNING.STACK_SIZE_TINYITEM  = 120 -- 原版 60 (如蜜蜂、蚊子)
TUNING.STACK_SIZE_PELLET    = 250 -- 原版 120 (如种子、火药)


-- ==============================================================================
-- 范式 2：针对硬编码第三方 Prefab 的智能区间逼近器 (scripts/tools/stack_approximator.lua)
-- ==============================================================================

local TARGET_TIERS = { 40, 80, 99, 120, 250 }

-- 离散区间逼近：将非标数值（如 50）智能平滑映射到最接近的高阶档位
local function ApproximateTier(val)
    if not val or type(val) ~= "number" then return TARGET_TIERS[2] end
    for _, tier in ipairs(TARGET_TIERS) do
        if val <= tier then
            return tier
        end
    end
    return TARGET_TIERS[#TARGET_TIERS]
end

-- 全局实体切面拦截 (高性能短路设计)
AddPrefabPostInitAny(function(inst)
    -- 仅服务端执行，客机依赖网络同步
    if not GLOBAL.TheWorld.ismastersim then return end

    local stackable = inst.components.stackable
    -- 核心性能守门员：90% 的实体没有 stackable，立即短路返回
    if stackable == nil then return end

    local current = stackable.maxsize
    local target = ApproximateTier(current)

    if target and target ~= current then
        stackable.maxsize = target
    end
end)
```

---

## 三、避坑与生产安全准则

1. **`AddPrefabPostInitAny` 性能陷阱**：
   - 绝不要在 `AddPrefabPostInitAny` 回调内执行 `TheSim:FindEntities`、字符串拼接、复杂正则表达式或大表遍历。实体生成每秒可能触发数十次，必须通过首行的 `if inst.components.xxx == nil then return end` 毫秒级退出。
2. **`replica` 客户端显示对齐**：
   - 饥荒的 `stackable` 组件在主客机同步时，`replica.stackable:MaxSize()` 会自动拉取服务端的最新容量。无需在客户端手动再去 Hook `replica`，避免引发客户端本地与网络包的状态竞争（Race Condition）。
