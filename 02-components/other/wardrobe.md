# Wardrobe / WardrobeBase 衣柜组件

> 源码: `scripts/components/wardrobe.lua` / `scripts/components/wardrobebase.lua`

## 概述

Wardrobe 管理角色的皮肤/外观系统。WardrobeBase 是基类，提供通用的外观管理功能。

## 属性 (Wardrobe)

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `skins` | table | `{}` | 当前应用的皮肤表 |
| `onskinschanged` | function/nil | `nil` | 皮肤变更回调 |

## 方法 (Wardrobe)

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetSkin(slot, skin)` | — | 设置指定槽位的皮肤 |
| `GetSkin(slot)` | string/nil | 获取指定槽位的皮肤 |
| `GetSkins()` | table | 获取所有皮肤 |
| `SetOnSkinsChanged(fn)` | — | 设置皮肤变更回调 |
| `ApplySkins()` | — | 应用所有皮肤 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 方法 (WardrobeBase)

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetSkinnedBuild(build_name)` | — | 设置带皮肤的构建名 |
| `SetSkinnedScale(scale)` | — | 设置皮肤缩放 |

## 使用示例

### 设置皮肤

```lua
inst:AddComponent("wardrobe")
inst.components.wardrobe:SetSkin("body", "body_walrus")
inst.components.wardrobe:SetSkin("hand", "hand_cane")
inst.components.wardrobe:ApplySkins()
```

### 皮肤变更回调

```lua
inst.components.wardrobe:SetOnSkinsChanged(function(inst)
    -- 皮肤变更后刷新外观
    inst.AnimState:SetBuild("wilson_none")
    inst.components.wardrobe:ApplySkins()
end)
```

### WardrobeBase 使用

```lua
inst:AddComponent("wardrobebase")
inst.components.wardrobebase:SetSkinnedBuild("my_build")
inst.components.wardrobebase:SetSkinnedScale(1.2)
```
