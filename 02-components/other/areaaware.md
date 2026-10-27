# AreaAware 区域感知组件

> 源码: `scripts/components/areaaware.lua`

## 概述

AreaAware 让实体感知当前所在区域类型（如沼泽、森林、洞穴等），可用于触发区域相关的行为或外观变化。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `current_area` | string/nil | `nil` | 当前区域类型 |
| `onareaenter` | function/nil | `nil` | 进入新区域回调 |
| `onareaexit` | function/nil | `nil` | 离开区域回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `GetCurrentArea()` | string/nil | 获取当前区域 |
| `SetOnAreaEnter(fn)` | — | 设置进入区域回调 |
| `SetOnAreaExit(fn)` | — | 设置离开区域回调 |
| `UpdateArea()` | — | 强制更新区域检测 |

## 使用示例

### 区域触发行为

```lua
inst:AddComponent("areaaware")
inst.components.areaaware:SetOnAreaEnter(function(inst, area)
    if area == GROUND.SWAMP then
        inst.components.combat.damagemultiplier = 1.5  -- 沼泽中伤害+50%
    end
end)

inst.components.areaaware:SetOnAreaExit(function(inst, area)
    if area == GROUND.SWAMP then
        inst.components.combat.damagemultiplier = 1.0  -- 离开沼泽恢复
    end
end)
```

### 检查当前区域

```lua
local area = inst.components.areaaware:GetCurrentArea()
if area == GROUND.FOREST then
    -- 森林中的特殊逻辑
end
```
