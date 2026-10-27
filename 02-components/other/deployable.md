# Deployable 可部署组件

> 源码: `scripts/components/deployable.lua`

## 概述

Deployable 管理物品的"放置到世界"功能。如建筑、陷阱、帐篷等需要从背包中部署到地面的物品。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `mode` | string/nil | `DEPLOYMODE.DEFAULT` | 部署模式 |
| `spacing` | string/nil | `DEPLOYSPACING.DEFAULT` | 部署间距 |
| `restrictedtag` | string/nil | `nil` | 限制只有特定tag实体可部署 |
| `usegridplacer` | boolean | `false` | 是否使用网格放置器 |
| `ondeploy` | function/nil | `nil` | 部署回调 |
| `keep_in_inventory_on_deploy` | boolean | `false` | 部署后是否保留在背包 |
| `cantdeployonoffscreen` | boolean | `true` | 是否不能部署到屏幕外 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetDeployMode(mode)` | — | 设置部署模式 |
| `GetDeployMode()` | string | 获取部署模式 |
| `SetDeploySpacing(spacing)` | — | 设置部署间距 |
| `DeploySpacingRadius()` | number | 获取部署间距半径 |
| `SetUseGridPlacer(flag)` | — | 设置是否使用网格放置 |
| `SetOnDeploy(fn)` | — | 设置部署回调 |
| `CanDeploy(pt)` | boolean | 检查是否可以在指定位置部署 |
| `Deploy(pt, deployer)` | — | 在指定位置部署 |

## 部署模式

| 模式 | 说明 |
|------|------|
| `DEPLOYMODE.DEFAULT` | 默认模式 |
| `DEPLOYMODE.WATER` | 只能在水上部署 |
| `DEPLOYMODE.LAND` | 只能在陆地上部署 |
| `DEPLOYMODE.CUSTOM` | 自定义部署规则 |

## 使用示例

### 基础可部署物品

```lua
inst:AddComponent("deployable")
inst.components.deployable:SetOnDeploy(function(inst, pt, deployer)
    local structure = SpawnPrefab("my_structure")
    structure.Transform:SetPosition(pt.x, 0, pt.z)
    inst:Remove()
end)
```

### 仅限陆地部署

```lua
inst:AddComponent("deployable")
inst.components.deployable.mode = DEPLOYMODE.LAND
```

### 使用网格放置器

```lua
inst:AddComponent("deployable")
inst.components.deployable.usegridplacer = true
-- 放置时显示网格预览
```

### 部署后保留物品

```lua
inst.components.deployable.keep_in_inventory_on_deploy = true
-- 部署后物品仍在背包（如种子种植）
```
