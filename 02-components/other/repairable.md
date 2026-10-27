# Repairable 可修复组件

> 源码: `scripts/components/repairable.lua`

## 概述

Repairable 允许使用修理材料恢复物品耐久度。需要配合 `finiteuses` 组件使用。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `repairmaterial` | string | — | 修理材料 prefab 名 |
| `repairvalue` | number | — | 每次修理恢复的耐久值 |
| `announcecanfix` | boolean | `false` | 是否可以公布可修复 |
| `onrepaired` | function/nil | `nil` | 修复完成回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetRepairMaterial(material)` | — | 设置修理材料 |
| `SetRepairValue(value)` | — | 设置每次修理恢复量 |
| `SetOnRepaired(fn)` | — | 设置修复回调 |
| `Repair(doer, repair_item)` | boolean | 执行修理 |

## 使用示例

### 基础修理物品

```lua
inst:AddComponent("finiteuses")
inst.components.finiteuses:SetMaxUses(200)

inst:AddComponent("repairable")
inst.components.repairable.repairmaterial = "rope"  -- 用绳子修理
inst.components.repairable.repairvalue = 50           -- 每次恢复50耐久
```

### 修复回调

```lua
inst:AddComponent("repairable")
inst.components.repairable:SetOnRepaired(function(inst, doer, item)
    doer.components.sanity:DoDelta(5)  -- 修复后回复5理智
end)
```

### 多种修理材料

```lua
inst:AddComponent("repairable")
inst.components.repairable.repairmaterial = MATERIALS.WOOD  -- 使用木头类材料
inst.components.repairable.repairvalue = 25
```
