# 饥荒知识提炼 Skill：burnable
- 来源目录：02-components\burnable\burnable.md (核心Gameplay组件库 (combat, inventory, builder))
- 提炼时间：2026-10-30 00:00:03

## 一、核心概念与API规范
# Burnable 可燃组件

> 源码: `scripts/components/burnable.lua`

## 概述

Burnable 组件赋予实体可燃属性，管理点燃、燃烧、熄灭、闷烧等火焰状态。是可燃物和篝火等的基础组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `burning` | boolean | `false` | 是否正在燃烧 |
| `smoldering` | boolean | `false` | 是否正在闷烧 |
| `canlight` | boolean | `true` | 是否可被点燃 |
| `flammability` | number | `1` | 易燃性（越大越容易着火） |
| `burntime` | number | `nil` | 燃烧剩余时间 |
| `extinguishimmediately` | boolean | `true` | 是否立即熄灭 |
| `lightningimmune` | boolean | `fals

## 二、生产级代码模版
```lua
-- 针对 burnable 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 burnable 进行安全切面扩展
end)
```
