# ChildSpawner 子代生成组件

> 源码: `scripts/components/childspawner.lua`

## 概述

ChildSpawner 组件管理实体的子代生成系统，用于蜘蛛巢、蜂巢、猎犬窝等生物巢穴。控制子代的生成、回收、再生和紧急生成等。

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `childname` | string | `""` | 子代prefab名 |
| `rarechild` | string/table | `nil` | 稀有子代prefab名 |
| `rarechildchance` | number | `0.1` | 稀有子代生成概率 |
| `childreninside` | number | `1` | 当前内部子代数量 |
| `childrenoutside` | table | `{}` | 外部子代引用表 `{[child]=child}` |
| `numchildrenoutside` | number | `0` | 外部子代数量 |
| `maxchildren` | number | `0` | 最大子代总数 |
| `spawning` | boolean | `false` | 是否正在生成 |
| `queued_spawn` | boolean | `false` | 是否有排队的生成 |
| `regening` | boolean | `true` | 是否正在再生 |
| `timetonextspawn` | number | `0` | 下次生成倒计时 |
| `spawnperiod` | number | `20` | 生成周期（秒） |
| `spawnvariance` | number | `2` | 生成周期随机偏差 |
| `timetonextregen` | number | `0` | 下次再生倒计时 |
| `regenperiod` | number | `20` | 再生周期（秒） |
| `regenvariance` | number | `2` | 再生周期随机偏差 |
| `spawnoffscreen` | boolean | `false` | 是否离屏生成 |
| `emergencychildrenoutside` | table | `{}` | 紧急子代表 |
| `numemergencychildrenoutside` | number | `0` | 紧急子代数量 |
| `maxemergencychildren` | number | `nil` | 最大紧急子代数 |
| `emergencyprioritytest` | function | `nil` | 紧急生成优先测试 |

### 回调函数

| 属性名 | 说明 |
|--------|------|
| `onvacate` | 巢穴清空时回调 |
| `onoccupied` | 巢穴被占用回调 |
| `onspawned` | 子代生成后回调 `fn(inst, child)` |
| `ontakeownership` | 接管子代回调 |
| `ongohome` | 子代回家回调 |

## 方法

| 方法签名 | 返回值 | 说明 |
|----------|--------|------|
| `SpawnChild(child, ...)` | Entity/nil | 生成一个子代 |
| `SpawnFirstChild(...)` | Entity/nil | 生成第一个子代（到外部） |
| `ReleaseChild(child)` | — | 释放子代到外部 |
| `KillChild(child)` | — | 杀死子代 |
| `GoHome(child)` | boolean | 子代回家 |
| `TakeOwnership(child)` | — | 接管子代 |
| `HasPendingEmergency()` | boolean | 是否有待处理的紧急 |
| `IsEmergencyChild(child)` | boolean | 是否是紧急子代 |
| `CountChildrenOutside()` | number | 获取外部子代数量 |
| `CountChildrenInside()` | number | 获取内部子代数量 |
| `GetAllChildren()` | table | 获取所有子代（内外） |
| `GetChildrenOutside()` | table | 获取外部子代 |
| `GetMaxChildren()` | number | 获取最大子代数 |
| `SetMaxChildren(max)` | — | 设置最大子代数 |
| `SetSpawnPeriod(period, variance)` | — | 设置生成周期 |
| `SetRegenPeriod(period, variance)` | — | 设置再生周期 |
| `StartSpawning()` | — | 开始生成 |
| `StopSpawning()` | — | 停止生成 |
| `StartRegening()` | — | 开始再生 |
| `StopRegening()` | — | 停止再生 |
| `OnChildKilled(child)` | — | 子代死亡处理（内部） |
| `SetSpawning(spawning)` | — | 设置生成状态 |
| `OnSave()` | table | 保存数据 |
| `OnLoad(data)` | — | 加载数据 |
| `OnEntitySleep()` | — | 休眠处理 |
| `OnEntityWake()` | — | 唤醒处理 |

## 事件

### 子代事件

| 事件名 | 说明 |
|--------|------|
| `ontrapped` | 子代被困 |
| `death` | 子代死亡 |
| `onremove` | 子代移除 |
| `detachchild` | 子代脱离 |

## 使用示例

### 蜘蛛巢

```lua
inst:AddComponent("childspawner")
inst.components.childspawner.childname = "spider"
inst.components.childspawner:SetMaxChildren(4)
inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_SPIDER_TIME)
inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
inst.components.childspawner:StartRegening()
inst.components.childspawner:StartSpawning()
```

### 稀有子代

```lua
inst.components.childspawner.rarechild = "spider_warrior"
inst.components.childspawner.rarechildchance = 0.2  -- 20%概率生成战士蜘蛛
```

### 紧急生成

```lua
inst.components.childspawner.maxemergencychildren = 2
inst.components.childspawner.emergencyprioritytest = function(target, inst)
    return target and target:HasTag("player")
end
```

### 生成回调

```lua
inst.components.childspawner.onspawned = function(inst, child)
    -- 生成后给子代加标签
    child:AddTag("my_spider")
end
```
