# AmbientLight 环境光组件

> 源码: `scripts/components/ambientlight.lua`

## 概述

AmbientLight 为实体提供环境光照效果，如发光生物、火把等。控制实体的光照范围和颜色。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `radius` | number | `0` | 光照半径 |
| `intensity` | number | `1` | 光照强度 |
| `falloff` | number | `0.5` | 光照衰减率 |
| `color` | table | `{1,1,1}` | 光照颜色（RGB） |
| `enabled` | boolean | `true` | 是否启用 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetRadius(radius)` | — | 设置光照半径 |
| `SetIntensity(intensity)` | — | 设置光照强度 |
| `SetFallOff(falloff)` | — | 设置衰减率 |
| `SetColor(r, g, b)` | — | 设置光照颜色 |
| `Enable(enable)` | — | 启用/禁用光照 |
| `GetRadius()` | number | 获取光照半径 |

## 使用示例

### 发光生物

```lua
inst:AddComponent("ambientlight")
inst.components.ambientlight:SetRadius(5)
inst.components.ambientlight:SetIntensity(0.7)
inst.components.ambientlight:SetColor(1, 0.8, 0.5)  -- 暖黄色光
```

### 彩色光

```lua
inst:AddComponent("ambientlight")
inst.components.ambientlight:SetRadius(3)
inst.components.ambientlight:SetColor(0, 0.5, 1)  -- 蓝色光
inst.components.ambientlight:SetIntensity(0.5)
```

### 动态开关

```lua
-- 夜晚发光
inst:WatchWorldState("isnight", function(inst, isnight)
    if isnight then
        inst.components.ambientlight:Enable(true)
    else
        inst.components.ambientlight:Enable(false)
    end
end)
```

### 渐隐效果

```lua
inst.components.ambientlight:SetFallOff(0.8)
-- 光照在边缘平滑衰减
```
