# Perishable 腐烂组件

> 源码: `scripts/components/perishable.lua`

## 概述

Perishable 组件管理物品的腐烂系统，控制食物的新鲜度变化。影响食物的标签（fresh/stale/spoiled）和可食用属性。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `perishtime` | number | `nil` | 总腐烂时间（秒） |
| `perishremainingtime` | number | `nil` | 剩余腐烂时间 |
| `targettime` | number | `nil` | 目标腐烂时间点 |
| `frozenfiremult` | boolean | `false` | 冰火是否影响腐烂速率 |
| `localPerishMultiplyer` | number | `1` | 本地腐烂倍率修正 |
| `perishfn` | function | `nil` | 腐烂完成回调 `fn(inst)` |
| `onperishreplacement` | string | `nil` | 腐烂后替换为的prefab名 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetPerishTime(time)` | — | 设置总腐烂时间 |
| `GetPercent()` | number | 获取新鲜度百分比 |
| `SetPercent(percent)` | — | 设置新鲜度百分比 |
| `IsStale()` | boolean | 是否不新鲜 |
| `IsSpoiled()` | boolean | 是否腐烂 |
| `IsFresh()` | boolean | 是否新鲜 |
| `StartPerishing()` | — | 开始腐烂计时 |
| `StopPerishing()` | — | 停止腐烂计时 |
| `LongUpdate(dt)` | — | 长时间更新 |
| `OnSave()` | table/nil | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |
| `OnRemoveFromEntity()` | — | 清理标签 |
| `OnRemoveEntity()` | — | 停止腐烂计时 |

## 标签

| 标签 | 条件 |
|------|------|
| `fresh` | 新鲜（>80%） |
| `stale` | 不新鲜（20%~80%） |
| `spoiled` | 腐烂（<20%） |

## 腐烂阈值

| 阈值 | 常量 | 说明 |
|------|------|------|
| 新鲜 | `TUNING.PERISH_FRESH` | >0.8 |
| 不新鲜 | `TUNING.PERISH_STALE` | >0.2 |
| 腐烂 | < `TUNING.PERISH_STALE` | <0.2 |

## 腐烂速率影响因素

- **环境温度**：高温加速，低温减缓
- **冰箱**：大幅减缓（`preserver` 组件）
- **冰火**：减缓（需 `frozenfiremult = true`）
- **口袋容器**：使用世界温度
- **本地倍率**：`localPerishMultiplyer`

## 使用示例

### 基础食物

```lua
inst:AddComponent("perishable")
inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)  -- 快速腐烂
-- TUNING.PERISH_FAST / PERISH_MED / PERISH_SLOW / PERISH_PRESERVED / PERISH_SUPERSLOW
```

### 冰箱中的食物

```lua
-- 冰箱有 preserver 组件，会自动减缓腐烂
-- 不需要额外设置
```

### 腐烂后替换

```lua
inst.components.perishable.onperishreplacement = "spoiled_food"  -- 腐烂后变为腐烂食物
```

### 自定义腐烂回调

```lua
inst.components.perishable.perishfn = function(inst)
    -- 腐烂后的自定义处理
    inst:Remove()
end
```

### 冰火影响

```lua
inst.components.perishable.frozenfiremult = true  -- 允许冰火减缓腐烂
```
