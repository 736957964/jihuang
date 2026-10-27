# Builder 建造组件

> 源码: `scripts/components/builder.lua`

## 概述

Builder 组件赋予实体"建造/制作"能力，管理可制作的配方列表、科技树、材料消耗、原型机交互等。玩家角色核心挂载此组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `recipes` | table | `{}` | 已解锁配方表 `{[recipe_name]=true}` |
| `station_recipes` | table | `{}` | 站台配方表 |
| `accessible_tech_trees` | TechTree | — | 可访问科技树（含临时） |
| `accessible_tech_trees_no_temp` | TechTree | — | 可访问科技树（不含临时） |
| `old_accessible_tech_trees` | table | `{}` | 旧科技树（用于对比） |
| `current_prototyper` | Entity | `nil` | 当前使用的原型机 |
| `buffered_builds` | table | `{}` | 缓冲建造队列 `{[recipe_name]=count}` |
| `freebuildmode` | boolean | `false` | 是否自由建造模式（不消耗材料） |
| `ingredientmod` | number | `1` | 材料消耗修正（0.5=半价, 2=双倍） |
| `exclude_tags` | table | — | 排除标签（建造放置检测时忽略） |
| `last_hungry_build` | number | `nil` | 上次饥饿建造时间 |
| `last_hungry_build_pt` | Vector3 | `nil` | 上次饥饿建造位置 |

### 科技加成

对每个 `TechTree.BONUS_TECH`（如 SCIENCE, MAGIC, ANCIENT, CELESTIAL 等），动态创建属性：
- `{tech}_bonus` — 科技加成值
- `{tech}_tempbonus` — 临时科技加成值

## 方法

### 配方管理

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `CanLearn(recipe)` | boolean | 能否学习配方 |
| `LearnRecipe(recipe, ing, instant)` | boolean | 学习配方 |
| `ForgetRecipe(recipe)` | — | 忘记配方 |
| `KnowsRecipe(recipe)` | boolean | 是否已知配方 |
| `IsBuildBuffered(recipe)` | boolean | 配方是否在建造队列中 |

### 建造操作

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `MakeRecipe(recipe, pt, rotation, skin, ingredient)` | boolean | 执行建造 |
| `DoBuild(recipe, pt, rotation, skin, ingredient, rep, ...)` | Entity/nil | 执行建造（核心方法） |
| `MakeRecipeFromMenu(recipe, ...)` | — | 从菜单建造 |
| `AddRecipe(recipe, data)` | — | 添加配方到建造菜单 |
| `RemoveRecipe(recipe)` | — | 从菜单移除配方 |
| `MakeRecipeAtPoint(recipe, pt, rotation)` | boolean | 在指定点建造 |

### 科技树

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `IsBuildEnabled(tech)` | boolean | 是否可建造某科技等级 |
| `GetTechTrees()` | table | 获取科技树数据 |
| `GetTempTechBonuses()` | table | 获取临时科技加成 |

### 原型机

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `ActivateCurrentResearchMachine(recipe)` | — | 激活当前原型机 |
| `SetCurrentPrototyper(prototyper)` | — | 设置当前原型机 |
| `GetCurrentPrototyper()` | Entity/nil | 获取当前原型机 |

### 其他

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |
| `GetDebugString()` | string | 调试字符串 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `refreshbuildlist` | 刷新建造列表 | — |
| `builditem` | 建造完成 | `{item, recipe}` |
| `buildstructure` | 建筑建造完成 | `{recipe}` |
| `techlevelchange` | 科技等级变化 | — |

## 使用示例

### 学习配方

```lua
-- 让实体学会某配方
inst.components.builder:LearnRecipe("spear")
-- 检查是否已知
if inst.components.builder:KnowsRecipe("spear") then
    print("已学会长矛配方")
end
```

### 添加自定义配方

```lua
-- 在 modmain.lua 中
AddRecipe("my_sword", {
    Ingredient(INGREDIENT.TWIGS, 3),
    Ingredient(INGREDIENT.FLINT, 2)
}, RECIPETABS.WAR, TECH.SCIENCE_ONE)
```

### 设置科技等级

```lua
-- 直接修改科技加成
inst.components.builder.science_bonus = 1  -- 科学一级
inst.components.builder.magic_bonus = 2    -- 魔法二级
```

### 自由建造模式

```lua
inst.components.builder.freebuildmode = true  -- 不消耗材料
```

### 材料消耗修正

```lua
inst.components.builder.ingredientmod = 0.5  -- 半价建造
```

### 使用原型机

```lua
-- 设置当前原型机
inst.components.builder:SetCurrentPrototyper(science_machine)
-- 激活
inst.components.builder:ActivateCurrentResearchMachine("spear")
```
