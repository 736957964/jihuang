# Burnable 可燃组件

> 源码: `scripts/components/burnable.lua`

## 概述

Burnable 组件赋予实体可燃属性，管理点燃、燃烧、熄灭、闷烧等火焰状态。是可燃物和篝火等的基础组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `burning` | boolean | `false` | 是否正在燃烧 |
| `smoldering` | boolean | `false` | 是否正在闷烧 |
| `canlight` | boolean | `true` | 是否可被点燃 |
| `flammability` | number | `1` | 易燃性（越大越容易着火） |
| `burntime` | number | `nil` | 燃烧剩余时间 |
| `extinguishimmediately` | boolean | `true` | 是否立即熄灭 |
| `lightningimmune` | boolean | `false` | 是否免疫雷击点燃 |
| `ignorefuel` | boolean | `false` | 是否忽略燃料消耗 |
| `stokeablefire` | boolean | `false` | 是否可被煽火 |
| `nocharring` | boolean | `false` | 是否不产生焦黑 |
| `fastextinguish` | boolean | `false` | 是否使用快速熄灭特效 |
| `fxlevel` | number | `1` | 火焰特效等级 |
| `fxdata` | table | `{}` | 火焰特效数据 |
| `fxchildren` | table | `{}` | 火焰子特效 |
| `fxoffset` | Vector3 | `nil` | 火焰特效偏移 |
| `smoldertimeremaining` | number | `nil` | 闷烧剩余时间 |

### 回调函数

| 属性名 | 说明 |
|--------|------|
| `onignite` | 点燃时回调 `fn(inst)` |
| `onextinguish` | 熄灭时回调 `fn(inst)` |
| `onburnt` | 烧尽时回调 `fn(inst)` |
| `onsmoldering` | 开始闷烧时回调 `fn(inst)` |
| `onstopsmoldering` | 停止闷烧时回调 `fn(inst)` |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Ignite(immediate, doer)` | boolean | 点燃（可立即点燃或先闷烧） |
| `Extinguish(immediate, doer)` | boolean | 熄灭 |
| `IsBurning()` | boolean | 是否正在燃烧 |
| `IsSmoldering()` | boolean | 是否正在闷烧 |
| `StartSmoldering()` | — | 开始闷烧 |
| `StopSmoldering()` | — | 停止闷烧 |
| `SetOnIgniteFn(fn)` | — | 设置点燃回调 |
| `SetOnBurntFn(fn)` | — | 设置烧尽回调 |
| `SetOnSmolderingFn(fn)` | — | 设置闷烧回调 |
| `SetOnStopSmolderingFn(fn)` | — | 设置停止闷烧回调 |
| `SetOnExtinguishFn(fn)` | — | 设置熄灭回调 |
| `SetFXLevel(level, offset)` | — | 设置火焰特效等级 |
| `OverrideBurningFXData(data)` | — | 覆盖燃烧特效数据 |
| `GetDebugString()` | string | 调试字符串 |
| `OnSave()` | table/nil | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |
| `OnRemoveFromEntity()` | — | 清理定时器和标签 |
| `LongUpdate(dt)` | — | 长时间更新 |
| `TransferComponent(newinst)` | — | 转移组件 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `onignite` | 点燃时 | — |
| `onextinguish` | 熄灭时 | — |
| `onburnt` | 烧尽时 | — |
| `onsmolder` | 开始闷烧时 | — |
| `stopsmoldering` | 停止闷烧时 | — |

## 标签

| 标签 | 说明 |
|------|------|
| `fire` | 燃烧时自动添加 |
| `smolder` | 闷烧时自动添加 |
| `canlight` | 可被点燃时自动添加 |
| `nolight` | 不可被点燃时自动添加 |
| `burnableignorefuel` | 忽略燃料消耗时 |
| `stokeablefire` | 可被煽火时 |

## 使用示例

### 可燃物品

```lua
inst:AddComponent("burnable")
inst.components.burnable:SetOnIgniteFn(function(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end)
inst.components.burnable:SetOnBurntFn(function(inst)
    inst:Remove()
end)
```

### 篝火

```lua
inst:AddComponent("burnable")
inst.components.burnable:SetFXLevel(3)  -- 大火特效
inst.components.burnable:Ignite(true)   -- 立即点燃
```

### 闷烧机制

```lua
inst:AddComponent("burnable")
inst.components.burnable.flammability = 2  -- 更易燃
inst.components.burnable:StartSmoldering()  -- 开始闷烧（不会立即着火）
```

### 免疫雷击

```lua
inst.components.burnable.lightningimmune = true
```

### 无焦黑

```lua
inst.components.burnable.nocharring = true  -- 烧完后不留焦黑残骸
```
