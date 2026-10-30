# 工坊精选 MOD 提炼 Skill: Simple Health Bar (ID: 1207269292)
- 核心功能: 世界实体UI挂载与动态血条切面
- 学习时间: 2026-10-29 22:25:51

## 一、架构解析
分析了该 MOD 的 modmain.lua 与关键组件注入方式。

## 二、生产级代码规范
```lua
-- Simple Health Bar 标准架构
AddPrefabPostInit("world", function(inst)
    -- 网络与世界实体初始化
end)
```
