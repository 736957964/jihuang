# KnownLocations 已知位置组件

> 源码: `scripts/components/knownlocations.lua`

## 概述

KnownLocations 管理实体"知道"的位置信息，用于AI寻路、兴趣点追踪等。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `locations` | table | `{}` | 已知位置表 `{[type]=position}` |
| `remembertime` | number | — | 记忆持续时间 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `RememberLocation(key, pos, time)` | — | 记录位置（可选超时） |
| `ForgetLocation(key)` | — | 忘记位置 |
| `GetLocation(key)` | table/nil | 获取位置 |
| `IsRemembered(key)` | boolean | 是否记录 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

### AI 记忆位置

```lua
inst:AddComponent("knownlocations")
-- 记录最近攻击者的位置
inst.components.knownlocations:RememberLocation("last_attacker", attacker_pos)

-- 获取并走向位置
local pos = inst.components.knownlocations:GetLocation("last_attacker")
if pos then
    inst.components.locomotor:GoToPoint(pos)
end
```

### 超时遗忘

```lua
inst.components.knownlocations:RememberLocation("food_source", pos, 30)
-- 30秒后自动遗忘
```
