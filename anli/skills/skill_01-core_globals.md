# 饥荒知识提炼 Skill：globals
- 来源目录：01-core\globals.md (核心引擎与Entity/Class底层)
- 提炼时间：2026-10-29 22:09:18

## 一、核心概念与API规范
# 全局变量

DST 中有大量全局变量，以下是按分类整理的列表。

## 核心引擎全局

| 变量 | 说明 | 可用时机 |
|------|------|----------|
| `TheSim` | 引擎层接口，最底层的全局对象 | 始终可用 |
| `TheNet` | 网络接口，控制连接、网络状态 | 始终可用 |
| `TheInput` | 输入管理 | 始终可用 |
| `TheInputProxy` | 输入代理（多设备支持） | 始终可用 |
| `TheFrontEnd` | 前端UI管理器 | 启动后 |
| `TheHaptics` | 触觉反馈（手柄震动） | 始终可用 |
| `TheMixer` | 音频混音器 | 始终可用 |
| `TheGameService` | 平台游戏服务（成就等） | 始终可用 |
| `TheSystemService` | 系统服务（服务器管理等） | 始终可用 |
| `TheInventory` | 皮肤库存系统 | 始终可用 |
| `TheSkillTree` | 技能树系统 | 始终可用 |
| `TheC

## 二、生产级代码模版
```lua
-- 针对 globals 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 globals 进行安全切面扩展
end)
```
