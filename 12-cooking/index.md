# 12 - Cooking 烹饪系统

> **源码位置**: `scripts/cooking.lua` — 食谱与配料定义  
> **核心组件**: `components/stewer.lua` — 烹饪锅逻辑  
> **相关文件**: `scripts/recipes.lua`、`scripts/recipes_filter.lua`、`scripts/cookbookdata.lua`

## 1. 烹饪系统概述

DST 的烹饪系统允许玩家将食材放入烹饪锅（Crock Pot）等烹饪器具中，经过一定时间后产出料理。系统通过**食材标签（tags）**和**优先级**来计算产出结果。

### 烹饪器具类型

| 器具 | Prefab | 食材槽 | 特点 |
|------|--------|--------|------|
| 烹饪锅 | `cookpot` | 4 | 标准烹饪 |
| 便携烹饪锅 | `portablecookpot` | 4 | Warly 专属 |
| 便携研磨器 | `portableblender` | 4 | Warly 专属调料 |
| 便携调味站 | `portablespicer` | 1+调料 | Warly 专属 |
| 晒肉架 | `meatrack` | 1 | 晾晒肉类 |

---

## 2. 食材标签系统

### 2.1 标签列表

所有食材标签定义在 `cooking.lua` 中：

| 标签 | 英文 | 含义 | 典型食材 |
|------|------|------|----------|
| `fruit` | 水果 | 水果类 | 浆果、石榴、火龙果、榴莲 |
| `veggie` | 蔬菜 | 蔬菜类 | 胡萝卜、玉米、南瓜、茄子 |
| `meat` | 肉类 | 肉类 | 大肉、小肉、怪物肉 |
| `fish` | 鱼类 | 鱼类 | 鱼、鳗鱼 |
| `egg` | 蛋类 | 蛋类 | 高脚鸟蛋、普通蛋 |
| `monster` | 怪物 | 怪物属性 | 怪物肉、榴莲 |
| `sweetener` | 甜味剂 | 甜味 | 蜂蜜、蜂王浆 |
| `fat` | 油脂 | 油脂 | 黄油 |
| `dairy` | 乳制品 | 乳制品 | 电羊奶 |
| `decoration` | 装饰 | 不可食用装饰 | 树枝 |
| `inedible` | 不可食用 | 非食材 | 骨片 |
| `seed` | 种子 | 种子类 | 各色种子 |
| `magic` | 魔法 | 魔法属性 | 噩梦燃料 |
| `precook` | 已烹饪 | 烹饪过 | 熟食 |
| `dried` | 已晒干 | 晾晒过 | 肉干 |

### 2.2 食材标签值

食材的标签值是**浮点数**，表示该食材在该标签上的权重：
- `fruit=1` 表示 1 个完整水果
- `fruit=0.5` 表示 0.5 个水果（如浆果）
- `sweetener=3` 表示 3 个甜味单位（蜂王浆）

### 2.3 食材注册 API

```lua
-- 注册食材标签
AddIngredientValues(names, tags, cancook, candry)

-- 示例：注册水果
local fruits = {"pomegranate", "dragonfruit", "cave_banana"}
AddIngredientValues(fruits, {fruit=1}, true) -- 可烹饪

-- 注册浆果（0.5 水果值）
AddIngredientValues({"berries"}, {fruit=.5}, true)

-- 注册蜂蜜
AddIngredientValues({"honey", "honeycomb"}, {sweetener=1}, true)
```

---

## 3. 食谱系统

### 3.1 食谱数据结构

```lua
-- 食谱定义
{
    name = "meatballs",           -- 食谱名称（对应 prefab 名）
    test = function(cooker, names, tags)
        -- 返回 true/false 表示是否满足条件
        return tags.meat and tags.meat > 0
    end,
    priority = -1,                -- 优先级（越小越优先，负数优先于正数）
    weight = 1,                   -- 权重
    foodtype = FOODTYPE.MEAT,     -- 食物类型
    health = TUNING.HEALING_SMALL, -- 生命恢复
    hunger = TUNING.CALORIES_MED,  -- 饥饿恢复
    sanity = TUNING.SANITY_TINY,   -- 精神恢复
    cooktime = .75,               -- 烹饪时间
    perishtime = TUNING.PERISH_MED, -- 腐烂时间
    floater = {"small", 0.05, 0.1}, -- 浮标动画
    oneat_desc = "美味",          -- 吃时描述
    -- 可选
    card_def = { owned = true },  -- 食谱卡默认状态
    no_cookbook = false,          -- 不加入食谱书
    -- 温度影响
    temperature = TUNING.HOT_FOOD_BONUS_TEMP, -- 加温
    temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
    -- 特殊效果
    potlevel = "high", -- 锅等级
}
```

### 3.2 食谱注册 API

```lua
-- 注册烹饪食谱
AddCookerRecipe("cookpot", {
    name = "myfood",
    test = function(cooker, names, tags)
        return tags.meat and tags.meat >= 1
    end,
    priority = 0,
    health = 20,
    hunger = 25,
    sanity = 5,
    cooktime = 1,
})

-- 注册食谱卡
AddRecipeCard("cookpot", { name = "myfood" })
```

### 3.3 食谱优先级

- **负数优先级**：优先匹配，通常是特定食材组合
- **0 优先级**：一般食谱
- **正数优先级**：低优先级，通常是默认失败结果

---

## 4. 烹饪流程

### 4.1 Stewer 组件 (`components/stewer.lua`)

烹饪锅使用 `stewer` 组件管理烹饪过程：

```lua
-- 核心方法
stewer:StartCooking()         -- 开始烹饪
stewer:StopCooking(reason)    -- 停止烹饪（"fire"表示烧毁）
stewer:Harvest(harvester)     -- 收获成品
stewer:IsCooking()            -- 是否在烹饪
stewer:IsDone()               -- 是否已完成
stewer:GetProduct()           -- 获取产出的 prefab 名

-- 属性
stewer.product                -- 产出的 prefab 名
stewer.spoiltime              -- 产出食物腐烂时间
stewer.cooktime               -- 烹饪所需时间
stewer.done                   -- 是否完成
```

### 4.2 烹饪匹配流程

1. 将 4 个食材槽的标签值求和
2. 排除 `inedible` 标签 >= 1 的食谱（防止树枝等污染）
3. 按优先级排序所有匹配的食谱
4. 选择最高优先级（最小数值）的食谱
5. 如果没有食谱匹配，产出 `wetgoop`（失败料理）

### 4.3 烹饪配方计算

```lua
-- 检查食材是否满足食谱条件
function CalculateRecipe(cooker, ingredients)
    local names = {}
    local tags = {}
    -- 求和所有食材标签
    for _, ingredient in ipairs(ingredients) do
        local data = cooking.ingredients[ingredient.prefab]
        if data then
            for tag, val in pairs(data.tags) do
                tags[tag] = (tags[tag] or 0) + val
            end
        end
    end
    -- 匹配食谱
    local best_priority = math.huge
    local best_recipe = nil
    for _, recipe in ipairs(cooking.recipes[cooker]) do
        if recipe.test(cooker, names, tags) then
            if recipe.priority < best_priority then
                best_priority = recipe.priority
                best_recipe = recipe
            end
        end
    end
    return best_recipe
end
```

---

## 5. 食物类型枚举

```lua
FOODTYPE = {
    GENERIC = "GENERIC",
    MEAT = "MEAT",       -- 肉类
    VEGGIE = "VEGGIE",   -- 蔬菜
    SEEDS = "SEEDS",     -- 种子
    ELEMENTAL = "ELEMENTAL", -- 元素
    INSECT = "INSECT",   -- 昆虫
    GEARS = "GEARS",     -- 齿轮
    HORRIBLE = "HORRIBLE", -- 恐怖
    WOOD = "WOOD",       -- 木材
    BURNT = "BURNT",     -- 烧焦
    ROUGHAGE = "ROUGHAGE", -- 粗纤维
    GOODIES = "GOODIES", -- 甜食
    RAW = "RAW",         -- 生食
}
```

---

## 6. 常见食谱示例

### 6.1 基础食谱

| 食谱 | 需求 | 优先级 |
|------|------|--------|
| 肉丸 (meatballs) | 任意肉 >= 1 | -1 |
| 肉汤 (bonestew) | 肉 >= 3 | 0 |
| 水果拼盘 (fruitmedley) | 水果 >= 3 | 0 |
| 蔬菜杂烩 (ratatouille) | 蔬菜 >= 1 | 0 |
| 蝴蝶松饼 (butterflymuffin) | 蝴蝶翅膀 + 蔬菜 >= 1 | 1 |
| 水饺 (perogies) | 蛋 + 肉 + 蔬菜 | 5 |

### 6.2 失败结果

- **失败料理 (wetgoop)**：没有食谱匹配时产出
- **怪物千层饼 (monsterlasagna)**：怪物肉 >= 2 时产出的特殊食谱

---

## 7. Mod 开发 — 自定义食谱

```lua
-- 在 modmain.lua 中
local cooking = require("cooking")

-- 1. 注册新食材标签（可选）
AddIngredientValues({"myspecial_food"}, {magic=2}, true)

-- 2. 注册新食谱
AddCookerRecipe("cookpot", {
    name = "mysuperfood",
    test = function(cooker, names, tags)
        return tags.magic and tags.magic >= 3
            and tags.meat and tags.meat >= 1
    end,
    priority = 10,
    health = TUNING.HEALING_HUGE,
    hunger = TUNING.CALORIES_HUGE,
    sanity = TUNING.SANITY_HUGE,
    cooktime = 2,
    weight = 1,
    floater = {"med", nil, 0.45},
})

-- 3. 注册食谱卡（用于烹饪书UI）
AddRecipeCard("cookpot", { name = "mysuperfood" })
```

---

## 8. 烹饪书 (Cookbook)

烹饪书记录玩家已经制作过的食谱：

```lua
-- cookbookdata.lua
-- 食谱分类
cookbook_categories = {
    "food",        -- 普通食物
    "warly",       -- Warly 专属
    "mod",         -- Mod 添加
}

-- 判断是否为 Mod 食物
IsModCookerFood(prefab)
HasModCookerFood()

-- 获取食谱数据
GetCookbookRecipes()
```

---

## 9. 晒肉架 (Drying Rack)

晒肉架通过 `dryer` 组件工作，不是烹饪系统的一部分，但与食物转化相关：

| 输入 | 输出 | 时间 |
|------|------|------|
| 大肉 | 大肉干 | 2天 |
| 小肉 | 小肉干 | 1天 |
| 怪物肉 | 怪物肉干 | 1天 |
| 鱼 | 小鱼干 | 1天 |
| 海带 | 干海带 | 0.5天 |
