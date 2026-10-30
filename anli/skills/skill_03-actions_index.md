# 饥荒知识提炼 Skill：index
- 来源目录：03-actions\index.md (玩家动作Action注册与Handler绑定)
- 提炼时间：2026-10-30 04:00:03

## 一、核心概念与API规范
# 03 - 动作系统（Actions）

> **源码位置**: `scripts/actions.lua` + `scripts/componentactions.lua`

动作系统是 DST 中所有玩家交互行为的核心机制。每个 `Action` 实例代表一种可执行的操作（如攻击、拾取、建造、烹饪等），`COMPONENT_ACTIONS` 表则将实体的组件与可用的动作关联起来。

---

## 目录

- [Action 类定义](#1-action-类定义)
- [所有 ACTIONS 列表](/03-actions/detail/action-list)
- ACTIONS.fn 详解（待补充）
- COMPONENT_ACTIONS 详解（待补充）
- Mod 自定义动作指南（待补充）

---

## 1. Action 类定义

### 1.1 构造函数

```lua
Action = Class(function(self, data, instant, rmb, distance, ghost_valid, ghost_exclusive, canforce,

## 二、生产级代码模版
```lua
-- 针对 index 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 index 进行安全切面扩展
end)
```
