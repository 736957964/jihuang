# Stackable 堆叠组件

> 源码: `scripts/components/stackable.lua`

## 概述

Stackable 管理物品的堆叠数量。同 prefab + 同 skin 的物品可以合并堆叠。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `stacksize` | number | `1` | 当前堆叠数量 |
| `maxsize` | number | `TUNING.STACK_SIZE_MEDITEM` | 最大堆叠数量 |
| `originalmaxsize` | number | 同 `maxsize` | 忽略限制前的原始最大值 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetIgnoreMaxSize(ignore)` | — | 设置是否忽略最大堆叠限制 |
| `IsStack()` | boolean | 堆叠数 > 1 返回 true |
| `StackSize()` | number | 返回当前堆叠数 |
| `IsFull()` | boolean | 是否已满 |
| `IsOverStacked()` | boolean | 是否超出原始堆叠限制 |
| `CanStackWith(item)` | boolean | 检查是否可与另一物品堆叠 |
| `SetStackSize(size)` | — | 设置堆叠数 |
| `GetStackSize()` | number | 获取堆叠数 |
| `Put(item)` | boolean | 尝试合并另一物品堆叠 |
| `Get(num)` | Entity/nil | 从堆叠中分离指定数量 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `stacksizechange` | 堆叠数变化 | `{stacksize}` |

## 使用示例

### 可堆叠物品

```lua
inst:AddComponent("stackable")
inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM  -- 大堆叠上限
```

### 修改堆叠数

```lua
inst.components.stackable:SetStackSize(20)  -- 设为20个
local size = inst.components.stackable:StackSize()  -- 获取当前数量
```

### 检查是否已满

```lua
if inst.components.stackable:IsFull() then
    print("已满，无法继续堆叠")
end
```

### 合并物品

```lua
if item1.components.stackable:CanStackWith(item2) then
    item1.components.stackable:Put(item2)
end
```

### 从堆叠中分离

```lua
local split_item = inst.components.stackable:Get(5)  -- 分离5个出来
```
