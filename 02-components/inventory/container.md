# Container 容器组件

> 源码: `scripts/components/container.lua`

## 概述

Container 组件赋予实体存储能力，管理物品槽位、开关容器、物品过滤等。是箱子、背包、烹饪锅等容器的基础组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `slots` | table | `{}` | 物品槽 `{[slot_num]=item}` |
| `numslots` | number | `0` | 槽位数量 |
| `canbeopened` | boolean | `true` | 是否可打开 |
| `acceptsstacks` | boolean | `true` | 是否接受堆叠物品 |
| `usespecificslotsforitems` | boolean | `false` | 是否使用特定槽位 |
| `issidewidget` | boolean | `false` | 是否侧边栏widget |
| `type` | string | `nil` | 容器类型 |
| `widget` | table | `nil` | widget配置 |
| `itemtestfn` | function | `nil` | 物品过滤函数 `fn(item, slot) -> bool` |
| `priorityfn` | function | `nil` | 优先级函数 |
| `openlist` | table | `{}` | 打开者列表 |
| `opencount` | number | `0` | 打开者数量 |
| `skipopensnd` | boolean | `false` | 跳过打开音效 |
| `skipclosesnd` | boolean | `false` | 跳过关闭音效 |
| `skipautoclose` | boolean | `false` | 跳过自动关闭 |
| `restrictedtag` | string | `nil` | 限制只有拥有此tag的实体可交互 |
| `thiefproof` | boolean | `nil` | 防偷窃 |
| `droponopen` | boolean | `false` | 打开时掉落物品 |
| `isexposed` | boolean | `false` | 是否暴露（不受雨水保护） |
| `ignorespoverflow` | boolean | `false` | 忽略特殊溢出 |
| `ignoreclosedspoverflow` | boolean | `false` | 忽略已关闭特殊溢出 |
| `ignoresound` | boolean | `false` | 忽略音效 |
| `ignoreoverstacked` | boolean | `false` | 忽略超堆叠 |

### 只读属性

| 属性名 | 说明 |
|--------|------|
| `infinitestacksize` | 无限堆叠大小 |
| `readonlycontainer` | 只读容器 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `Open(opener)` | — | 打开容器 |
| `Close(opener)` | — | 关闭容器 |
| `IsOpen()` | boolean | 是否已打开 |
| `IsOpenedBy(opener)` | boolean | 是否被特定实体打开 |
| `GetNumSlots()` | number | 获取槽位数 |
| `GetItemInSlot(slot)` | Entity/nil | 获取指定槽位物品 |
| `GetItems()` | table | 获取所有物品 |
| `GiveItem(item, slot, src_pos, check_full)` | boolean | 放入物品 |
| `RemoveItem(item, ...)` | Entity/nil | 移除物品 |
| `RemoveItemBySlot(slot)` | Entity/nil | 移除指定槽位物品 |
| `DropItemBySlot(slot)` | — | 掉落指定槽位物品 |
| `DropEverything()` | — | 掉落所有物品 |
| `DestroyContents()` | — | 销毁所有内容物 |
| `HasItem(item, checkcontainer)` | boolean | 是否包含某物品 |
| `FindItem(fn)` | Entity/nil | 查找物品 |
| `FindItems(fn)` | table | 查找所有匹配物品 |
| `Has(prefab, amount)` | boolean, number | 是否有足够某prefab物品 |
| `GetItemCount(prefab)` | number | 获取某prefab物品数量 |
| `CanAcceptItem(item)` | boolean | 能否接受某物品 |
| `IsFull()` | boolean | 是否已满 |
| `IsEmpty()` | boolean | 是否为空 |
| `SetCanBeOpened(canbeopened)` | — | 设置是否可打开 |
| `OnSave()` | data, references | 保存数据 |
| `OnLoad(data, newents)` | — | 加载数据 |
| `OnRemoveEntity()` | — | 关闭并清理 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `onopen` | 容器被打开 | `{doer}` |
| `onclose` | 容器被关闭 | `{doer}` |
| `onremove` | 容器被移除 | — |
| `itemget` | 物品放入 | `{item, slot}` |
| `itemlose` | 物品移出 | `{item, slot}` |

## 使用示例

### 基础箱子

```lua
inst:AddComponent("container")
inst.components.container.numslots = 9
inst.components.container.widget = {
    slotpos = {},
    animbank = "ui_chest_3x3",
    animbuild = "ui_chest_3x3",
}
```

### 限制物品类型

```lua
inst:AddComponent("container")
inst.components.container.numslots = 4
inst.components.container.itemtestfn = function(item, slot)
    return item:HasTag("book")  -- 只接受书
end
```

### 防偷窃

```lua
inst.components.container.thiefproof = true
```

### 只读容器

```lua
inst.components.container.readonlycontainer = true
```

### 特定实体才能打开

```lua
inst.components.container.restrictedtag = "my_character"
```

### 侧边栏容器（背包）

```lua
inst:AddComponent("container")
inst.components.container.numslots = 8
inst.components.container.issidewidget = true
inst.components.container.type = "backpack"
```
