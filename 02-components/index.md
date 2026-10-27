# 02 - 组件系统（Components）

> 源码目录: `scripts/components/`  
> 总计约 815 个组件

组件是 DST 中最核心的可复用功能单元。每个组件封装一组相关逻辑，通过 `inst:AddComponent("componentname")` 添加到实体上，通过 `inst.components.componentname` 访问。

---

## 目录

| 分类 | 目录 | 说明 |
|------|------|------|
| [战斗](/02-components/combat/index) | `combat/` | combat, health, weapon, armor, aoeweapon_* 等 |
| [生存](/02-components/survival/index) | `survival/` | hunger, sanity, temperature, moisture, age 等 |
| [物品/容器](/02-components/inventory/index) | `inventory/` | inventory, inventoryitem, container, stackable, equippable 等 |
| 移动/导航 | `movement/` | locomotor, amphibiouscreature 等 |
| [工作/采集](/02-components/work/index) | `work/` | workable, harvestable, pickable, diggable, tool 等 |
| [食物/烹饪](/02-components/edible/index) | `edible/` | edible, cooker, cookable, stewer, perishable 等 |
| [建造/制作](/02-components/builder/index) | `builder/` | builder, deployable, craftingstation, prototyper 等 |
| [火/光/燃烧](/02-components/burnable/index) | `burnable/` | burnable, fueled, light, propagator 等 |
| [生物/生成](/02-components/creature/index) | `creature/` | childspawner, follower, spawner, herdmember 等 |
| [航海](/02-components/sailing/index) | `sailing/` | boatphysics, sail, anchor, boatleak, boatmagnet 等 |
| 技能树 | `skilltree/` | 各角色技能相关组件 |
| 世界/环境 | `world/` | worldstate, weather, seasons, clock, temperature 等 |
| [其他](/02-components/other/index) | `other/` | 不属以上分类的其余组件合集 |

---

## 组件通用模式

### 生命周期回调

```lua
-- 保存数据
function MyComponent:OnSave()
    return { key = self.value }
end

-- 加载数据
function MyComponent:OnLoad(data)
    if data and data.key then
        self.value = data.key
    end
end

-- 实体从世界移除
function MyComponent:OnRemoveEntity()
    -- 清理资源
end

-- 组件从实体移除
function MyComponent:OnRemoveFromEntity()
    -- 清理监听等
end
```

### 世界状态监视

```lua
-- 自动绑定到 self.inst，随实体移除自动解绑
function MyComponent:WatchWorldState(variable, fn)
function MyComponent:StopWatchingWorldState(variable, fn)
```

### 添加/移除组件

```lua
inst:AddComponent("health")           -- 添加组件
inst:RemoveComponent("health")        -- 移除组件
inst:HasComponent("health")           -- 检查是否有组件
inst.components.health                -- 访问组件实例
```

---

## 常用组件 API 速查

### 基础属性
| 组件 | 核心方法 |
|------|----------|
| `health` | `SetMaxHealth(v)`, `DoDelta(delta)`, `GetCurrent()`, `IsDead()`, `Kill()` |
| `combat` | `SetTarget(t)`, `SetDefaultDamage(v)`, `SetAttackPeriod(v)`, `SetRange(v)` |
| `sanity` | `SetMax(v)`, `DoDelta(delta)`, `GetPercent()` |
| `hunger` | `SetMax(v)`, `DoDelta(delta)`, `GetPercent()`, `SetRate(v)` |
| `temperature` | `SetCurrent(v)`, `GetCurrent()`, `SetMode(m)` |

### 物品/容器
| 组件 | 核心方法 |
|------|----------|
| `inventory` | `GiveItem(item)`, `DropItem(item)`, `HasItem(name, amount)`, `GetEquippedItem(slot)` |
| `inventoryitem` | `SetOnPutInInventoryFn(fn)`, `SetOnDroppedFn(fn)`, `IsHeld()` |
| `container` | `GiveItem(item)`, `DropEverything()`, `FindItem(fn)`, `IsOpen()`, `IsFull()` |
| `stackable` | `SetStackSize(n)`, `StackSize()`, `IsFull()` |
| `equippable` | `IsEquipped()`, `GetEquipSlot()`, `EquipSlot()`, `SetOnEquip(fn)` |

### 状态/行为
| 组件 | 核心方法 |
|------|----------|
| `workable` | `SetWorkLeft(v)`, `SetWorkAction(action)`, `WorkedBy(worker, amount)` |
| `burnable` | `Ignite()`, `Extinguish()`, `IsBurning()`, `SetOnBurntFn(fn)` |
| `fueled` | `SetMaxFuel(v)`, `StartConsuming()`, `StopConsuming()`, `GetPercent()` |
| `edible` | `GetHunger()`, `GetSanity()`, `GetHealth()`, `SetOnEatenFn(fn)` |
| `perishable` | `SetPerishTime(t)`, `StartPerishing()`, `StopPerishing()`, `SetPercent(p)` |
| `cookable` | `SetProduct(name)`, `SetOnCookedFn(fn)` |
| `cooker` | `StartCooking()`, `StopCooking()`, `GetDonePercent()` |
| `deployable` | `SetDeployMode(mode)`, `SetDeploySpacing(s)` |
| `tradable` | `SetPrice(item, qty)`, `SetOnAcceptFn(fn)` |
| `sleeper` | `GoToSleep(time)`, `WakeUp()`, `IsAsleep()` |
| `freezable` | `AddColdness(v)`, `IsFrozen()`, `Unfreeze()` |
| `heater` | `heatfn = function(inst) return temp end` |

### 生物
| 组件 | 核心方法 |
|------|----------|
| `locomotor` | `GoToPoint(x,y,z)`, `Stop()`, `WalkForward()`, `RunForward()` |
| `follower` | `SetLeader(inst)`, `IsNearLeader(range)` |
| `lootdropper` | `SetLoot(table)`, `GenerateLoot()`, `DropLoot(pos)` |
| `knownlocations` | `RememberLocation(key, loc)`, `GetLocation(key)` |
| `childspawner` | `StartSpawning()`, `SpawnChild()`, `ReleaseAllChildren()` |
| `homeseeker` | `SetHome(inst)` |

### 工具/武器
| 组件 | 核心方法 |
|------|----------|
| `weapon` | `SetDamage(v)`, `SetOnAttack(fn)`, `SetAttackCallback(fn)` |
| `armor` | `SetAbsorption(v)`, `SetCondition(v)`, `SetKeepOnFinished(b)` |
| `tool` | `SetAction(action)`, `SetOnWorkFinished(fn)` |
| `finiteuses` | `SetMaxUses(n)`, `Use(n)`, `SetPercent(p)`, `GetPercent()` |
| `repairable` | `SetOnRepaired(fn)`, `SetRepairMaterial(m)` |

## Mod 开发：组件回调

```lua
-- 对现有组件添加后处理
AddComponentPostInit("health", function(Health, inst)
    local old_DoDelta = Health.DoDelta
    Health.DoDelta = function(self, amount, ...)
        -- 修改伤害逻辑
        return old_DoDelta(self, amount, ...)
    end
end)
```
