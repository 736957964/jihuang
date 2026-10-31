# 饥荒一线工坊深度研读 Skill：超大容量容器切面与多阵列网格对齐规范

- **工坊 ID**：382177939 (`DST Storm Cellar`)
- **领域分类**：超大容量容器拓展、`MAXITEMSLOTS` 容量上限破界、`containers.widgetsetup` 非侵入代理、矩阵式槽位生成器
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在饥荒制作大容量背包、宝箱、储物柜或冷库时，官方原版的限制主要在 `containers` 模块。标准流程为：
1. 动态拓宽 `containers.MAXITEMSLOTS` 防止客户端网络越界崩溃；
2. 用行列双重循环生成 `slotpos` 向量矩阵；
3. 代理 `containers.widgetsetup` 挂接自定义参数。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：工业级超大容器参数配置与安全注入器 (scripts/tools/container_injector.lua)
-- ==============================================================================

local ContainerInjector = {}

--- 自动生成规则矩阵槽位坐标
--- @param rows number 行数
--- @param cols number 列数
--- @param spacing number 槽位间距 (推荐 75 或 80)
--- @param origin_y number 基础垂直高度偏移
local function GenerateGridSlots(rows, cols, spacing, origin_y)
    local slotpos = {}
    local start_x = -((cols - 1) * spacing) / 2
    local start_y = origin_y + ((rows - 1) * spacing) / 2

    for r = 0, rows - 1 do
        for c = 0, cols - 1 do
            local x = start_x + (c * spacing)
            local y = start_y - (r * spacing)
            table.insert(slotpos, GLOBAL.Vector3(x, y, 0))
        end
    end
    return slotpos
end

--- 注入自定义容器参数
--- @param prefab_name string 预制体名字
--- @param rows number 行数 (如 4)
--- @param cols number 列数 (如 10)
--- @param is_fridge boolean 是否具备冷藏保鲜效果
function ContainerInjector.RegisterCustomChest(prefab_name, rows, cols, is_fridge)
    local containers = GLOBAL.require("containers")
    local slotpos = GenerateGridSlots(rows, cols, 75, 200)

    -- 1. 突破客机网络数组最大槽位限制 (核心防御)
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, #slotpos)

    local custom_param = {
        widget = {
            slotpos = slotpos,
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_3x3",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }

    -- 2. 代理 widgetsetup 模式 (保证跨 Mod 兼容)
    local old_widgetsetup = containers.widgetsetup
    containers.widgetsetup = function(container, prefab, data)
        local target_name = prefab or (container.inst and container.inst.prefab)
        if target_name == prefab_name then
            for k, v in pairs(custom_param) do
                container[k] = v
            end
            container:SetNumSlots(#slotpos)
        else
            return old_widgetsetup(container, prefab, data)
        end
    end
end

return ContainerInjector
```

---

## 三、避坑与生产安全准则

1. **`containers.MAXITEMSLOTS` 必须在模块加载时立即提升**：
   - 如果等到玩家右键点击打开箱子时再去修改 `MAXITEMSLOTS`，客机在连接入服初始化网络组件时就已经按照旧的上限实例化了数组，后续动态开箱依然会触发内存越界报错。必须在 `modmain.lua` 顶层加载期完成拓宽。
2. **`side_align_tip` 边缘边界自适应**：
   - 当水平列数大于 8 时，悬停提示窗（Hover Tip）若不配置 `side_align_tip`，鼠标指在最右侧槽位时，提示框会直接溢出到屏幕视口之外，导致玩家看不见物品属性。
