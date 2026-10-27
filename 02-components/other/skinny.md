# Skinny 外观组件

> 源码: `scripts/components/skinny.lua`

## 概述

Skinny 管理实体的皮肤/外观数据，与 Wardrobe 协同工作。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `skin_id` | string/nil | `nil` | 皮肤ID |
| `base_skin_id` | string/nil | `nil` | 基础皮肤ID |
| `onskinchanged` | function/nil | `nil` | 皮肤变更回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetSkin(skin_id)` | — | 设置皮肤 |
| `GetSkin()` | string/nil | 获取当前皮肤 |
| `SetBaseSkin(skin_id)` | — | 设置基础皮肤 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

```lua
inst:AddComponent("skinny")
inst.components.skinny:SetSkin("skin_wilson_formal")
inst.components.skinny.onskinchanged = function(inst)
    inst.components.wardrobe:ApplySkins()
end
```
