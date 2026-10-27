# FiniteUses 有限使用组件

> 源码: `scripts/components/finiteuses.lua`

## 概述

FiniteUses 组件管理物品的耐久度系统。工具、武器等有限使用次数的物品挂载此组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `total` | number | `100` | 总耐久度 |
| `current` | number | `100` | 当前耐久度 |
| `consumption` | table | `{}` | 消耗表 `{[ACTION]=uses}` |
| `ignorecombatdurabilityloss` | boolean | `false` | 是否忽略战斗耐久损耗 |
| `onfinished` | function | `nil` | 耐久耗尽回调 `fn(inst)` |
| `doesnotstartfull` | boolean | `nil` | 是否不以满耐久开始 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Use(action, amount)` | — | 使用（扣耐久），action 可选 |
| `GetUses()` | number | 获取当前耐久 |
| `GetPercent()` | number | 获取耐久百分比（0~1） |
| `SetUses(val)` | — | 设置当前耐久（耗尽触发onfinished） |
| `SetMaxUses(val)` | — | 设置最大耐久 |
| `SetConsumption(action, uses)` | — | 设置特定动作的消耗量 |
| `ClearAllConsumptions()` | — | 清除所有消耗设置 |
| `SetDoesNotStartFull(enabled)` | — | 设置不以满耐久开始 |
| `IgnoresCombatDurabilityLoss()` | boolean | 是否忽略战斗损耗 |
| `OnSave()` | table/nil | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |
| `OnRemoveFromEntity()` | — | 清理标签 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `percentusedchange` | 耐久度变化 | `{percent}` |
| `finishedwork` | 耐久耗尽 | — |

## 标签

| 标签 | 说明 |
|------|------|
| `usesdepleted` | 耐久耗尽时自动添加 |

## 使用示例

### 基础工具

```lua
inst:AddComponent("finiteuses")
inst.components.finiteuses:SetMaxUses(TUNING.AXE_USES)
inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
inst.components.finiteuses:SetOnFinished(function(inst)
    inst:Remove()  -- 耗尽后消失
end)
```

### 多用途工具

```lua
inst:AddComponent("finiteuses")
inst.components.finiteuses:SetMaxUses(200)
inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 2)  -- 挖矿消耗2点
inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 3) -- 锤击消耗3点
```

### 忽略战斗损耗

```lua
inst.components.finiteuses.ignorecombatdurabilityloss = true
-- 武器攻击不消耗耐久，只有工具使用才消耗
```

### 手动使用耐久

```lua
inst.components.finiteuses:Use(ACTIONS.CHOP, 2)  -- 消耗2点耐久
inst.components.finiteuses:Use(nil, 5)  -- 消耗5点耐久（无特定动作）
```

### 按百分比设置

```lua
inst.components.finiteuses:SetUses(inst.components.finiteuses.total * 0.5)  -- 设为50%
```
