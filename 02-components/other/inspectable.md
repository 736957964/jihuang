# Inspectable 可检查组件

> 源码: `scripts/components/inspectable.lua`

## 概述

Inspectable 管理实体的"检查"交互。玩家右键点击实体时，会显示描述文本和状态信息。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `description` | string/table/function | — | 描述文本 |
| `getspecialdescription` | function/nil | `nil` | 特殊描述函数 |
| `nameoverride` | string/nil | `nil` | 检查时名称覆盖 |
| `getstatus` | function/nil | `nil` | 获取状态字符串的回调 |
| `recordview` | boolean | `false` | 是否记录查看行为 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetDescription(desc)` | — | 设置描述文本 |
| `SetNameOverride(name)` | — | 设置名称覆盖 |
| `RecordViews(state)` | — | 开启/关闭查看记录 |
| `GetStatus(viewer)` | string | 获取状态（DEAD/SLEEPING/BURNING等） |
| `GetDescription(viewer)` | string | 获取完整描述文本 |

## 自动状态

组件会自动检测以下状态并显示：

| 状态 | 检测来源 |
|------|----------|
| DEAD | `health:IsDead()` |
| SLEEPING | `sleeper:IsAsleep()` |
| BURNING | `burnable:IsBurning()` |
| PICKED | `pickable:CanBePicked()` |
| ONFIRE | `burnable:IsBurning()` |
| FULL | `inventoryitem` 堆叠满 |
| OPEN/CLOSED | `occupiable` 状态 |

## 使用示例

### 静态描述

```lua
inst:AddComponent("inspectable")
inst.components.inspectable:SetDescription("一棵普通的树。")
```

### 动态描述

```lua
inst:AddComponent("inspectable")
inst.components.inspectable:SetDescription(function(inst, viewer)
    if inst.components.hunger:GetPercent() < 0.3 then
        return "它看起来很饿。"
    end
    return "一只普通的猪人。"
end)
```

### 特殊描述

```lua
inst.components.inspectable.getspecialdescription = function(inst, viewer)
    if viewer.prefab == "wx78" then
        return "WX-78 对它有着独特的理解。"
    end
    return nil  -- 返回nil则使用默认描述
end
```

### 名称覆盖

```lua
inst.components.inspectable:SetNameOverride("远古守卫者")
-- 检查时显示 "远古守卫者" 而不是实体默认名
```

### 记录查看

```lua
inst.components.inspectable:RecordViews(true)
-- 检查后会在角色知识中记录
```
