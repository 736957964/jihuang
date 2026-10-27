# Talker 说话组件

> 源码: `scripts/components/talker.lua`

## 概述

Talker 管理实体的对话/台词显示，包括周期性台词、特殊事件台词等。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `ontalk` | function/nil | `nil` | 说话时的回调 |
| `hibernatemode` | boolean | `true` | 休眠时是否停止说话 |
| `line` | string/nil | `nil` | 当前显示的台词 |
| `offset` | table | `{0, 0}` | 对话气泡偏移 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Say(script, time, noforce, force)` | — | 显示台词（自动从 STRINGS 查找） |
| `ShutUp()` | — | 清除当前台词 |
| `IgnoreAll(input)` | — | 忽略/恢复所有说话请求 |
| `SetOffset(x, y)` | — | 设置对话气泡偏移 |
| `GetOffset()` | table | 获取偏移值 |

## 使用示例

### 基础对话

```lua
inst:AddComponent("talker")
inst.components.talker:Say(STRINGS.PIG_TALK_FIND_FOOD)  -- 显示台词
```

### 定时台词

```lua
inst:AddComponent("talker")
inst:DoPeriodicTask(10, function(inst)
    if not inst.components.health:IsDead() then
        inst.components.talker:Say(STRINGS.PIG_TALK_LOOKATWILSON)
    end
end)
```

### 说话回调

```lua
inst.components.talker.ontalk = function(inst, script, time)
    -- 每次说话时触发
    inst.SoundEmitter:PlaySound("dontstarve/creatures/pigman/talk")
end
```

### 设置气泡偏移

```lua
inst.components.talker:SetOffset(0, 80)  -- 气泡上移80像素
```

### 禁用休眠暂停

```lua
inst.components.talker.hibernatemode = false
-- 即使屏幕外也会继续说话
```
