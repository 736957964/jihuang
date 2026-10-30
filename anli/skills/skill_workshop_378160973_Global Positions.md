# 工坊精选 MOD 提炼 Skill: Global Positions (ID: 378160973)
- 核心功能: 网络同步与大地图跨玩家图标渲染
- 学习时间: 2026-10-29 22:25:51

## 一、架构解析
分析了该 MOD 的 modmain.lua 与关键组件注入方式。

## 二、生产级代码规范
```lua
-- Global Positions 标准架构
AddPrefabPostInit("world", function(inst)
    -- 网络与世界实体初始化
end)
```
