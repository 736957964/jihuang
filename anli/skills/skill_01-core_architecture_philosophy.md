# 饥荒知识提炼 Skill：architecture_philosophy
- 来源目录：01-core\architecture_philosophy.md (核心引擎与Entity/Class底层)
- 提炼时间：2026-10-29 22:09:18

## 一、核心概念与API规范
﻿# 饥荒联机版（DST）核心架构决策、设计思想与源码哲学

> “代码只是结果，设计决策才是灵魂。” 本文档不堆砌具体业务案例，专门剖析饥荒底层引擎架构、顶流 Mod 作者的设计哲学、为什么必须这么设计，以及违背这些设计带来的隐性代价。

---

## 一、 为什么饥荒采用“纯组件化（ECS 变体）”而非传统 OOP 类继承？

### 1. 设计初衷与底层哲学
饥荒几乎所有的实体（Entity）都是由 `CreateEntity()` 创建的一个空壳容器，所有能力全部通过 `inst:AddComponent(...)` 动态组装：
- **为什么不写 `class Monster extends Character`？**
  - **现实维度**：在饥荒世界里，任何事物都具有极高的交叉属性。一头猪（Pigman）既是生物（`health`, `combat`, `locomotor`），又是可交易对象（`trader`），还可以被收买成为随从（`follower`），死后还会掉落肉（`lootdropper`），甚至可能发疯变成疯猪（形态切换）。如果用传统类继承，单继承无法处

## 二、生产级代码模版
```lua
-- 针对 architecture_philosophy 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 architecture_philosophy 进行安全切面扩展
end)
```
