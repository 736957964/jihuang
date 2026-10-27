# InventoryItem 库存物品组件

> 源码: `scripts/components/inventoryitem.lua`

## 概述

InventoryItem 是大多数可携带物品的基础组件，管理物品在背包/容器中的状态。任何可以被捡起来放进背包的物品都需要挂载此组件。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `owner` | Entity/nil | `nil` | 持有该物品的实体 |
| `canbepickedup` | boolean | `true` | 是否可被拾取 |
| `canbepickedupalive` | boolean | `false` | 活体是否可拾取（如兔子陷阱） |
| `cangoincontainer` | boolean | `true` | 能否放入容器 |
| `canonlygoinpocket` | boolean | `false` | 只能放入玩家口袋 |
| `canonlygoinpocketorpocketcontainers` | boolean | `false` | 只能放入口袋或口袋容器 |
| `islockedinslot` | boolean | `false` | 是否锁定在槽位中 |
| `keepondeath` | boolean | `false` | 死亡时是否保留 |
| `atlasname` | string/nil | `nil` | 物品图标 atlas |
| `imagename` | string/nil | `nil` | 物品图标文件名 |
| `trappable` | boolean | `true` | 是否可被陷阱捕获 |
| `sinks` | boolean | `false` | 是否沉入水中 |
| `droprandomdir` | boolean | `true` | 丢弃时是否随机方向 |
| `pushlandedevents` | boolean | `false` | 是否推送着陆事件 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SetLanded(landed, ...)` | — | 设置着陆状态（物品掉落） |
| `EnableMoisture(enable)` | — | 启用湿度跟踪 |
| `GetMoisture()` | number | 获取当前湿度值 |
| `AddMoisture(amount)` | — | 增加湿度 |
| `EnableTemperature(enable)` | — | 启用温度跟踪 |
| `GetTemperature()` | number | 获取当前温度 |
| `IsHeld()` | boolean | 是否被某个实体持有 |
| `GetContainer()` | Entity/nil | 获取所在容器 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |

## 事件

| 事件名 | 触发时机 | 数据 |
|--------|----------|------|
| `stacksizechange` | 堆叠数变化时（转发给owner） | `{stacksize}` |
| `onputininventory` | 物品放入背包时 | `{owner}` |
| `ondropped` | 物品丢弃时 | — |
| `onpickup` | 物品被拾取时 | `{owner}` |

## 使用示例

### 创建可拾取物品

```lua
local function MakePickableItem()
    local inst = CreateEntity()
    -- ... 其他组件 ...
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/myitem.xml"
    inst.components.inventoryitem.imagename = "myitem"
    return inst
end
```

### 死亡不掉落

```lua
inst:AddComponent("inventoryitem")
inst.components.inventoryitem.keepondeath = true  -- 死亡保留
```

### 仅限口袋

```lua
inst.components.inventoryitem.canonlygoinpocket = true
-- 物品只能放入玩家口袋，不能放入箱子等容器
```

### 启用湿度系统

```lua
inst.components.inventoryitem:EnableMoisture(true)
-- 之后可以通过 GetMoisture() / AddMoisture() 管理湿度
```

### 禁用随机丢弃方向

```lua
inst.components.inventoryitem.droprandomdir = false
-- 丢弃时物品不会随机散开
```
