# 饥荒知识提炼 Skill：builder
- 来源目录：02-components\builder\builder.md (核心Gameplay组件库 (combat, inventory, builder))
- 提炼时间：2026-10-30 00:00:03

## 一、核心概念与API规范
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
| `current_prototy

## 二、生产级代码模版
```lua
-- 针对 builder 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 builder 进行安全切面扩展
end)
```
