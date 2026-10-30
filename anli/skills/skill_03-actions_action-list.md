# 饥荒知识提炼 Skill：action-list
- 来源目录：03-actions\detail\action-list.md (玩家动作Action注册与Handler绑定)
- 提炼时间：2026-10-30 04:00:03

## 一、核心概念与API规范
# 所有 ACTIONS 完整列表

> 共约 150+ 个 Action，按分类整理。`*` 表示没有特殊构造函数参数。

## 基础交互动作

| Action | 参数 | 说明 |
|--------|------|------|
| `WALKTO` | `priority=-4, ghost_valid, mount_valid, encumbered_valid` | 走到目标点（最低优先级） |
| `LOOKAT` | `priority=-3, instant, distance=3, ghost_valid, mount_valid, encumbered_valid` | 查看/检视目标 |
| `TALKTO` | `priority=3, instant, mount_valid, encumbered_valid` | 与目标对话 |
| `INTERACT_WITH` | `distance=1.5, mount_valid` | 与目标交互 |
| `TRAVEL` | `*` | 旅行（通过虫洞等） |
| `JUMPIN` | `ghost_val

## 二、生产级代码模版
```lua
-- 针对 action-list 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 action-list 进行安全切面扩展
end)
```
