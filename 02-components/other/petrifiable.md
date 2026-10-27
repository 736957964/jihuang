# Petrifiable 可石化组件

> 源码: `scripts/components/petrifiable.lua`

## 概述

Petrifiable 管理实体石化的过程（如树木石化变成石树）。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `petrifytime` | number | — | 石化所需时间 |
| `petrified` | boolean | `false` | 是否已石化 |
| `onpetrifiedfn` | function/nil | `nil` | 石化完成回调 |
| `onunpetrifiedfn` | function/nil | `nil` | 解除石化回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Petrify()` | — | 执行石化 |
| `Unpetrify()` | — | 解除石化 |
| `IsPetrified()` | boolean | 是否已石化 |
| `SetPetrifyTime(time)` | — | 设置石化时间 |
| `SetOnPetrified(fn)` | — | 设置石化回调 |
| `SetOnUnpetrified(fn)` | — | 设置解除回调 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 使用示例

### 树木石化

```lua
inst:AddComponent("petrifiable")
inst.components.petrifiable:SetPetrifyTime(TUNING.TOTAL_DAY_TIME * 30)  -- 30天后石化
inst.components.petrifiable:SetOnPetrified(function(inst)
    inst.AnimState:SetBuild("petrified_tree")
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("workable")
end)
```

### 手动石化

```lua
if not inst.components.petrifiable:IsPetrified() then
    inst.components.petrifiable:Petrify()
end
```
