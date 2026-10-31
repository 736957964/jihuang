# 饥荒一线工坊深度研读 Skill：Insight 全域实体描述符反射与网络分类器同步架构

- **工坊 ID**：2189004162 (`Insight (Show Me+)`)
- **领域分类**：模块化组件描述符模式（Descriptor Reflection）、专用网络实体分类器（`insight_classified`）、多层悬浮窗富文本聚合、范围指示圈投影渲染
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“全能信息显示、基地审计、实体深度属性透视、地面范围圈绘制”类大型 Mod 时：
1. **组件描述符插件化（Component Descriptors）**：将每个游戏组件（如 `armor`, `crop`, `dryer`, `combat`）的文字解析逻辑独立拆分为单文件，实现高内聚低耦合；
2. **专属分类器实体同步（Classified Sync）**：利用服务端派发的辅助网络实体同步原本客户端不可见的隐藏数值（如驯化度、水分、肥料值）；
3. **地面范围圈投影（Range Indicators）**：利用透明环形贴图（Ring Texture）在地面平铺渲染攻击/保护半径。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：模块化组件描述符注册中心 (scripts/descriptors/manager.lua)
-- ==============================================================================

local DescriptorRegistry = {}
local Descriptors = {}

--- 注册特定组件的信息解析器
function DescriptorRegistry.Register(component_name, parse_fn)
    Descriptors[component_name] = parse_fn
end

--- 扫描实体身上的所有组件并提取描述信息数组
function DescriptorRegistry.InspectEntity(inst)
    if not inst or not inst:IsValid() then return nil end

    local lines = {}
    for comp_name, parse_fn in pairs(Descriptors) do
        local comp = inst.components and inst.components[comp_name]
        if comp then
            local info_line = parse_fn(comp, inst)
            if info_line then
                table.insert(lines, info_line)
            end
        end
    end
    return #lines > 0 and lines or nil
end

-- 注册耐久度描述符
DescriptorRegistry.Register("finiteuses", function(comp, inst)
    local current = comp:GetUses()
    local max = comp.total
    local pct = math.floor((current / max) * 100)
    return string.format("耐久: %d/%d (%d%%)", current, max, pct)
end)

-- 注册攻击力描述符
DescriptorRegistry.Register("weapon", function(comp, inst)
    local damage = comp.damage
    return string.format("基础伤害: %0.1f", damage)
end)

-- ==============================================================================
-- 范式 2：地面技能/保护半径指示器实体 (scripts/prefabs/range_indicator.lua)
-- ==============================================================================

local function MakeRangeIndicator(name, radius, color)
    local function fn()
        local inst = GLOBAL.CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst:AddTag("NOCLICK")
        inst:AddTag("FX")

        inst.AnimState:SetBank("firefighter_placement")
        inst.AnimState:SetBuild("firefighter_placement")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetOrientation(GLOBAL.ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(GLOBAL.ANIM_LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)

        -- 缩放调整贴合实际半径
        local scale = radius / 15.0 -- 假设贴图基准半径为 15
        inst.Transform:SetScale(scale, scale, scale)

        if color then
            inst.AnimState:SetMultColour(unpack(color))
        end

        inst.persists = false
        return inst
    end

    return GLOBAL.Prefab(name, fn)
end
```

---

## 三、避坑与生产安全准则

1. **悬停解析的节流控制（Throttling）**：
   - 绝不可在 `Hoverer:OnUpdate` 中每帧对鼠标指向的实体执行深拷贝或全量正则解析。必须为相同目标缓存 0.2~0.5 秒的解析快照，仅在数据变动时刷新。
2. **客机端安全判空断言**：
   - 在客户端读取 `inst.components` 时必须谨记：大部分组件在客机端不存在（只有 replica）。对于纯客机透视，必须基于 `inst.replica` 进行反射或依赖服务端专属的 `Classified` 实体下发数据。
