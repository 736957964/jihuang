# 饥荒创意工坊深度研读报告：Storm Cellar（超大容量地窖容器与布局切面）

- **模组标识**：`382177939` (`DST Storm Cellar / 风暴地窖`)
- **作者**：Afro1967
- **版本**：v1.9
- **领域分类**：超大容量容器切面（80 槽位）、`containers.widgetsetup` 动态注入、`MAXITEMSLOTS` 容量上限拓扑破界、冷藏（Fridge）保鲜标签
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与容器布局模型）

---

## 一、架构全貌与顶层设计思想

在饥荒原版中，箱子（Chest）默认只有 9 个槽位（3x3），即使是龙蝇箱也仅有 12 槽位。当开发者试图制作 60~80 槽位的超大型基地级仓储建筑（如地窖、军火库、冷库）时，面临极其严苛的引擎网络限制：
1. **`MAXITEMSLOTS` 越界崩溃**：官方底层 `containers.MAXITEMSLOTS` 默认写死，一旦槽位超过原版上限，客机打开容器时数组越界必定崩溃；
2. **矩阵网格坐标换算**：超大网格（如 5x16 或 8x10）如何居中并对齐屏幕；
3. **`containers.widgetsetup` 非破坏性注入**。

`Storm Cellar` 是饥荒史上第一款稳定支撑 **80 槽位超大容器**的现象级 Mod，其注入范式被后世无数仓储类 Mod 沿用至今。

---

## 二、四大硬核核心技术解构

### 1. `containers.MAXITEMSLOTS` 拓扑动态扩容
- **痛点**：客机在接收容器网络同步时，底层依赖 `containers.MAXITEMSLOTS` 来初始化网络插槽数组。若不修改该值，超过原版最大槽位（原版为 20~25）时，客机会抛出 `index out of range` 导致客户端断开连接。
- **解法**：在加载容器参数前，动态拉升全局槽位上限：
  ```lua
  local containers = _G.require "containers"
  containers.MAXITEMSLOTS = math.max(
      containers.MAXITEMSLOTS,
      params.cellar.widget.slotpos ~= nil and #params.cellar.widget.slotpos or 0
  )
  ```
  保证了客户端底层能容纳高达 80 个同步实体槽位。

### 2. 多重排布矩阵算法（5x16 与 8x10 动态算式）
为了兼顾不同显示器宽高比与玩家视觉偏好，MOD 实现了两种经典排布矩阵：
- **8 行 10 列模式（8x10）**：
  ```lua
  for y = 6.5, -0.5, -1 do
      for x = 0, 9 do
          table.insert(params.cellar.widget.slotpos, _G.Vector3(75 * x - 75 * 12 + 75, 75 * y - 75 * 6 + 75, 0))
      end
  end
  ```
- **5 行 16 列横向模式（5x16）**：
  通过以 75 像素为步长的网格偏移公式，将 80 个槽位均匀收拢在屏幕中央，完全不遮挡角色底部的快捷物品栏。

### 3. `containers.widgetsetup` 代理拦截模式（Proxy Interception）
- 不盲目修改官方 `containers.lua` 文件源码，而是代理 `containers.widgetsetup`：
  ```lua
  local old_widgetsetup = containers.widgetsetup
  function containers.widgetsetup(container, prefab, data)
      local pref = prefab or container.inst.prefab
      if pref == "cellar" then
          local t = params[pref]
          if t ~= nil then
              for k, v in pairs(t) do
                  container[k] = v
              end
              container:SetNumSlots(#container.widget.slotpos)
          end
      else
          return old_widgetsetup(container, prefab, data)
      end
  end
  ```
  精准命中自家建筑才做配置覆盖，其他官方或第三方容器原封不动回退给 `old_widgetsetup`，实现极致兼容。

### 4. 动态冰箱保鲜标签注入（`fridge` 机制）
- 饥荒底层的保鲜机制是由组件上的 Tag 驱动的：
  当开启冷藏配置时，在预制体初始化中加入 `inst:AddTag("fridge")`。容器内放入的食物腐烂速度自动乘上 `TUNING.PERISH_FRIDGE_MULT`（0.5 倍速慢速腐烂），无缝复用原版烹饪逻辑。

---

## 三、避坑实战经验

1. **`side_align_tip` 提示框错位**：
   - 当容器横向跨度极大（如 16 列宽，跨度超过 1200 像素）时，鼠标滑过边缘槽位会遮挡右侧或左侧的物品提示信息。必须在 `widget` 中配置 `side_align_tip = 160`，强行矫正悬停文字提示的锚点偏移。
2. **保存世界时的海量物品序列化压力**：
   - 80 槽位如果全部塞满单项不可堆叠物品，保存世界时的序列化数据量极大。必须避免在容器的 `onopenfn` / `onclosefn` 中做重度遍历计算，否则在开闭箱子时会出现瞬间微掉帧（Micro-stutter）。
