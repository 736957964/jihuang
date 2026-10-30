# 饥荒知识提炼 Skill：index
- 来源目录：01-core\index.md (核心引擎与Entity/Class底层)
- 提炼时间：2026-10-29 22:09:18

## 一、核心概念与API规范
# 01 - 核心系统

DST 的核心系统包含实体管理、预制体注册、类系统、全局函数和全局变量。

## 子目录

- [EntityScript](entity.md) — 实体脚本，所有 `inst` 可用的方法和属性
- [Prefab 系统](prefab.md) — 预制体创建、注册、Asset、依赖
- [Class 类系统](class.md) — 面向对象类定义与继承
- [全局函数](mainfunctions.md) — SpawnPrefab、SavePersistentString 等
- [全局变量](globals.md) — TheWorld、ThePlayer、TheSim、TheNet 等


## 二、生产级代码模版
```lua
-- 针对 index 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 index 进行安全切面扩展
end)
```
