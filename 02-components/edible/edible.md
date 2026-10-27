# Edible 食物组件

> 源码: `scripts/components/edible.lua`

## 概述

Edible 组件赋予物品可食用属性，定义食物的营养价值（生命、饥饿、理智）、食物类型、温度效果、调味料等。所有可食用的物品都需要此组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `healthvalue` | number | `10` | 生命恢复值（负值=扣血） |
| `hungervalue` | number | `10` | 饥饿恢复值 |
| `sanityvalue` | number | `0` | 理智恢复值（负值=扣理智） |
| `foodtype` | FOODTYPE | `FOODTYPE.GENERIC` | 食物类型（影响食谱判定） |
| `secondaryfoodtype` | FOODTYPE | `nil` | 次要食物类型 |
| `temperaturedelta` | number | `0` | 体温变化量 |
| `temperatureduration` | number | `0` | 体温效果持续时间 |
| `chill` | number | `0` | 降温比例（0~1，占temperatureduration的百分比） |
| `nochill` | boolean | `nil` | 是否不受降温效果影响 |
| `degrades_with_spoilage` | boolean | `true` | 是否随腐烂降低品质 |
| `stale_hunger` | number | `TUNING.STALE_FOOD_HUNGER` | 不新鲜时饥饿倍率 |
| `stale_health` | number | `TUNING.STALE_FOOD_HEALTH` | 不新鲜时生命倍率 |
| `spoiled_hunger` | number | `TUNING.SPOILED_FOOD_HUNGER` | 腐烂时饥饿倍率 |
| `spoiled_health` | number | `TUNING.SPOILED_FOOD_HEALTH` | 腐烂时生命倍率 |
| `spice` | string | `nil` | 调味料类型 |
| `oneaten` | function | `nil` | 食用后回调 `fn(inst, eater)` |
| `gethealthfn` | function | `nil` | 自定义生命值计算 `fn(inst, eater)` |
| `getsanityfn` | function | `nil` | 自定义理智值计算 `fn(inst, eater)` |
| `handleremovefn` | function | `nil` | 自定义移除处理 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `GetHealth(eater)` | number | 获取生命恢复值（含腐烂/调味修正） |
| `GetHunger(eater)` | number | 获取饥饿恢复值（含腐烂/调味修正） |
| `GetSanity(eater)` | number | 获取理智恢复值（含腐烂/调味修正） |
| `GetWoodiness(eater)` | number | **已弃用**，返回0 |
| `OnRemoveFromEntity()` | — | 清理标签 |

## 事件

无独立事件（通过 `eater` 组件的 `oneat` 触发）

## 食物类型 (FOODTYPE)

| 枚举值 | 说明 |
|--------|------|
| `GENERIC` | 通用（默认） |
| `MEAT` | 肉类 |
| `VEGGIE` | 蔬菜 |
| `SEEDS` | 种子 |
| `SWEETENER` | 甜味剂 |
| `GOODIES` | 甜食 |
| `INSECT` | 昆虫 |
| `HORRIBLE` | 可怕食物 |
| `WOOD` | 木材类 |
| `MONSTER` | 怪物肉 |
| `BERRY` | 浆果（通过tag标记） |

## 调味料 (SPICE)

| 值 | 效果 |
|----|------|
| `"spice_chili"` | 辣椒：增加生命值 |
| `"spice_garlic"` | 大蒜：增加防御 |
| `"spice_salt"` | 盐：增加理智值 |
| `"spice_sugar"` | 糖：增加工作效率 |
| `"spice_voltgoat"` | 电羊：电击效果 |

## 使用示例

### 基础食物

```lua
inst:AddComponent("edible")
inst.components.edible.healthvalue = 3
inst.components.edible.hungervalue = 12.5
inst.components.edible.sanityvalue = 0
inst.components.edible.foodtype = FOODTYPE.VEGGIE
```

### 肉类

```lua
inst:AddComponent("edible")
inst.components.edible.healthvalue = 1
inst.components.edible.hungervalue = 25
inst.components.edible.sanityvalue = -15
inst.components.edible.foodtype = FOODTYPE.MEAT
```

### 带温度效果的食物

```lua
inst:AddComponent("edible")
inst.components.edible.hungervalue = 10
inst.components.edible.temperaturedelta = 40  -- 升温40度
inst.components.edible.temperatureduration = 10  -- 持续10秒
```

### 带食用效果的食物

```lua
inst:AddComponent("edible")
inst.components.edible.hungervalue = 20
inst.components.edible.oneaten = function(inst, eater)
    -- 食用后获得加速效果
    if eater.components.locomotor then
        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "my_food", 1.5)
        eater:DoTaskInTime(30, function(eater)
            eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "my_food")
        end)
    end
end
```

### 动态数值

```lua
inst:AddComponent("edible")
inst.components.edible.gethealthfn = function(inst, eater)
    -- 根据食用者状态动态决定生命恢复
    if eater and eater.components.health then
        local hp_percent = eater.components.health:GetPercent()
        return hp_percent < 0.5 and 20 or 5
    end
    return 10
end
```

### 调味

```lua
inst.components.edible.spice = "spice_chili"
```

## 腐烂影响

- **新鲜**（>50%）：满值
- **不新鲜**（20%~50%）：生命 × `stale_health`，饥饿 × `stale_hunger`，理智归0
- **腐烂**（<20%）：生命 × `spoiled_health`，饥饿 × `spoiled_hunger`，理智 = `-TUNING.SANITY_SMALL`
