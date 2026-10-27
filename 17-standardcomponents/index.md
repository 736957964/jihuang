# 17 - StandardComponents 标准组件函数

> **源码位置**: `scripts/standardcomponents.lua` (1400+ 行)  
> **作用**: 提供标准化的 `Make*` / `Change*` 函数，用于在 Prefab 初始化中统一配置常用组件

## 1. 概述

`standardcomponents.lua` 是一系列**工厂函数**的集合，用于快速、一致地为实体添加和配置常见组件。这些函数被所有官方 Prefab 广泛使用，也是 Mod 开发中最常用的工具函数。

### 设计理念

- **DRY (Don't Repeat Yourself)**：避免在每个 Prefab 中重复写相同的组件初始化代码
- **一致性**：确保同类实体行为一致
- **便捷性**：一行调用替代多行组件配置

---

## 2. 燃烧系统 (Burnable + Propagator)

### 2.1 可燃烧 (Burnable)

```lua
-- 小型可燃烧 (燃烧时间 10s, FX 等级 2)
MakeSmallBurnable(inst, time, offset, structure, sym)

-- 中型可燃烧 (燃烧时间 20s, FX 等级 3)
MakeMediumBurnable(inst, time, offset, structure, sym)

-- 大型可燃烧 (燃烧时间 30s, FX 等级 4)
MakeLargeBurnable(inst, time, offset, structure, sym)
```

### 2.2 角色燃烧

```lua
-- 角色小型燃烧 (FX 等级 1, 燃烧时间 6s, 不可被点燃)
MakeSmallBurnableCharacter(inst, sym, offset)

-- 角色中型燃烧 (FX 等级 2, 燃烧时间 8s)
MakeMediumBurnableCharacter(inst, sym, offset)

-- 角色大型燃烧 (FX 等级 3, 燃烧时间 10s)
MakeLargeBurnableCharacter(inst, sym, offset, scale)
```

### 2.3 尸体燃烧

```lua
-- 小尸体燃烧 (燃烧时间 6s)
MakeSmallBurnableCorpse(inst, time, sym, offset, scale)

-- 中尸体燃烧 (燃烧时间 8s)
MakeMediumBurnableCorpse(inst, time, sym, offset, scale)

-- 大尸体燃烧 (燃烧时间 10s)
MakeLargeBurnableCorpse(inst, time, sym, offset, scale)
```

### 2.4 火焰传播 (Propagator)

```lua
-- 小型传播器 (闪点 5-10s, 范围 3-5, 热量 3-8)
MakeSmallPropagator(inst)

-- 中型传播器 (闪点 15-25s, 范围 5-7, 热量 5-12)
MakeMediumPropagator(inst)

-- 大型传播器 (闪点 45-55s, 范围 6-8, 热量 6-12)
MakeLargePropagator(inst)
```

### 2.5 默认回调函数

```lua
DefaultIgniteFn(inst)       -- 默认点燃回调
DefaultBurnFn(inst)         -- 默认燃烧回调（标记不持久）
DefaultBurntFn(inst)        -- 默认烧毁回调（移除组件）
DefaultExtinguishFn(inst)   -- 默认熄灭回调（恢复持久）
DefaultBurntStructureFn(inst) -- 建筑烧毁回调
DefaultBurntCorpseFn(inst)  -- 尸体烧毁回调
DefaultExtinguishCorpseFn(inst) -- 尸体熄灭回调
```

---

## 3. 冰冻系统 (Freezable)

```lua
-- 微小冰冻角色 (FX 等级 1)
MakeTinyFreezableCharacter(inst, sym, offset)

-- 小型冰冻角色 (FX 等级 2)
MakeSmallFreezableCharacter(inst, sym, offset)

-- 中型冰冻角色 (FX 等级 3, 抗性 2)
MakeMediumFreezableCharacter(inst, sym, offset)

-- 大型冰冻角色 (FX 等级 4, 抗性 3)
MakeLargeFreezableCharacter(inst, sym, offset)

-- 巨型冰冻角色 (FX 等级 5, 抗性 4)
MakeHugeFreezableCharacter(inst, sym, offset)
```

---

## 4. 物理系统 (Physics)

### 4.1 创建物理体

```lua
-- 物品物理 (碰撞组 ITEMS, 球形)
MakeInventoryPhysics(inst, mass, rad)

-- 弹射物理 (碰撞组 ITEMS, 仅与地面碰撞)
MakeProjectilePhysics(inst, mass, rad)

-- 角色物理 (碰撞组 CHARACTERS, 胶囊形)
MakeCharacterPhysics(inst, mass, rad)

-- 飞行角色物理 (碰撞组 FLYERS)
MakeFlyingCharacterPhysics(inst, mass, rad)

-- 微型飞行角色物理 (碰撞组 FLYERS, 不与其他碰撞)
MakeTinyFlyingCharacterPhysics(inst, mass, rad)

-- 巨型角色物理 (碰撞组 GIANTS)
MakeGiantCharacterPhysics(inst, mass, rad)

-- 飞行巨型角色物理 (碰撞组 GIANTS, 飞行)
MakeFlyingGiantCharacterPhysics(inst, mass, rad)

-- 幽灵物理 (碰撞组 CHARACTERS, 飞行)
MakeGhostPhysics(inst, mass, rad)

-- 微型幽灵物理
MakeTinyGhostPhysics(inst, mass, rad)
```

### 4.2 障碍物物理

```lua
-- 标准障碍物 (碰撞组 OBSTACLES)
MakeObstaclePhysics(inst, rad, height)

-- 水上障碍物 (附加 waterphysics 组件)
MakeWaterObstaclePhysics(inst, rad, height, restitution)

-- 小型障碍物 (碰撞组 SMALLOBSTACLES)
MakeSmallObstaclePhysics(inst, rad, height)

-- 重物障碍物 (可被搬运, 附带物品物理属性)
MakeHeavyObstaclePhysics(inst, rad, height)

-- 小型重物障碍物
MakeSmallHeavyObstaclePhysics(inst, rad, height)

-- 池塘物理
MakePondPhysics(inst, rad, height)
```

### 4.3 切换物理体

```lua
-- 切换为幽灵物理
ChangeToGhostPhysics(inst)

-- 切换为飞行角色物理
ChangeToFlyingCharacterPhysics(inst, mass, rad)

-- 切换为角色物理
ChangeToCharacterPhysics(inst, mass, rad)

-- 切换为巨型角色物理
ChangeToGiantCharacterPhysics(inst, mass, rad)

-- 切换为障碍物物理
ChangeToObstaclePhysics(inst, rad, height)

-- 切换为水上障碍物物理
ChangeToWaterObstaclePhysics(inst)

-- 切换为物品物理
ChangeToInventoryPhysics(inst)

-- 切换为物品项物理
ChangeToInventoryItemPhysics(inst, mass, rad)
```

### 4.4 碰撞器管理

```lua
-- 移除所有物理碰撞器
RemovePhysicsColliders(inst)

-- 与电场碰撞
MakeCollidesWithElectricField(inst)
ClearCollidesWithElectricField(inst)
```

---

## 5. 环境系统

### 5.1 积雪覆盖

```lua
-- 纯客户端初始化（在 Prefab fn 中调用）
MakeSnowCoveredPristine(inst)

-- 完整积雪覆盖（在主逻辑中调用）
MakeSnowCovered(inst)
```

### 5.2 月冰积累

```lua
-- 集成在 MakeSnowCovered 中自动调用
MakeLunarHailBuildup(inst)
RemoveLunarHailBuildup(inst)

-- 设置月冰积累量
SetLunarHailBuildupAmountSmall(inst)    -- 小型
SetLunarHailBuildupAmountMedium(inst)   -- 中型
SetLunarHailBuildupAmountLarge(inst)    -- 大型
```

### 5.3 冬季不生长

```lua
-- 使可采摘组件在冬季暂停
MakeNoGrowInWinter(inst)
```

---

## 6. 食物腐烂系统

### 6.1 小型易腐生物

```lua
-- 纯客户端初始化
MakeSmallPerishableCreaturePristine(inst)

-- 标准设置（饥饿时间, 在物品栏回调, 掉落回调）
MakeSmallPerishableCreature(inst, starvetime, oninventory, ondropped)

-- 始终腐烂（即使在物品栏中）
MakeSmallPerishableCreatureAlwaysPerishing(inst, starvetime, oninventory, ondropped)
```

### 6.2 小型可喂养生物

```lua
-- 纯客户端初始化
MakeFeedableSmallLivestockPristine(inst)

-- 标准设置
MakeFeedableSmallLivestock(inst, starvetime, oninventory, ondropped)
```

---

## 7. 鬼魂互动 (Hauntable)

### 7.1 弹飞

```lua
-- 可被鬼魂弹飞
MakeHauntableLaunch(inst, chance, speed, cooldown, haunt_value)

-- 可被鬼魂弹飞并破坏
MakeHauntableLaunchAndSmash(inst, launch_chance, smash_chance, speed, cooldown, launch_haunt_value, smash_haunt_value)
```

### 7.2 工作

```lua
-- 可被鬼魂触发工作
MakeHauntableWork(inst, chance, cooldown, haunt_value)

-- 可被鬼魂触发工作并点燃
MakeHauntableWorkAndIgnite(inst, work_chance, ignite_chance, cooldown, work_haunt_value, ignite_haunt_value)
```

### 7.3 状态变化

```lua
-- 可被鬼魂冰冻
MakeHauntableFreeze(inst, chance, cooldown, haunt_value)

-- 可被鬼魂点燃
MakeHauntableIgnite(inst, chance, cooldown, haunt_value)

-- 可被鬼魂弹飞并点燃
MakeHauntableLaunchAndIgnite(inst, launchchance, ignitechance, speed, cooldown, launch_haunt_value, ignite_haunt_value)

-- 可被鬼魂改变 Prefab
MakeHauntableChangePrefab(inst, newprefab, chance, haunt_value, nofx)

-- 可被鬼魂触发（自定义回调）
MakeHauntable(inst, cooldown, haunt_value)
```

### 7.4 特效

```lua
-- 可被鬼魂触发恐慌（Panic）
MakeHauntablePanic(inst, chance, cooldown, haunt_value)

-- 可被鬼魂触发电击
MakeHauntableShock(inst, chance, cooldown, haunt_value)

-- 可被鬼魂触发掉落
MakeHauntableDropLoot(inst, chance, cooldown, haunt_value)

-- 可被鬼魂触发变身
MakeHauntableTransform(inst, newprefab, chance, cooldown, haunt_value)
```

---

## 8. 物理特效

### 8.1 掉落

```lua
-- 制作物品掉落特效
MakeInventoryFloatable(inst, small, med, large)
-- 参数: 小/中/大 浮标偏移 (默认: Vector3(0, 0.1, 0))

-- 移除掉落特效
MakeInventoryFloatableRemoval(inst)
```

### 8.2 水面物理

```lua
-- 制作水面漂浮
MakeWaterFloatable(inst, small, med, large)
```

---

## 9. 声音与特效

### 9.1 声音

```lua
-- 制作可检查声音
MakeHauntableSound(inst, sound, chance, cooldown, haunt_value)
```

### 9.2 可擦除

```lua
-- 制作可随时间擦除
ErodeAway(inst, time)
```

---

## 10. 使用规范

### 10.1 常见组合模式

```lua
-- 典型物品 Prefab
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)          -- 物品物理
    MakeInventoryFloatable(inst)        -- 掉落特效
    MakeSmallBurnable(inst)             -- 小可燃
    MakeSmallPropagator(inst)           -- 小传播
    MakeHauntableLaunch(inst)           -- 鬼魂互动
    MakeSnowCovered(inst)               -- 积雪覆盖

    return inst
end
```

```lua
-- 典型生物 Prefab
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)      -- 角色物理
    MakeSmallBurnableCharacter(inst)         -- 角色燃烧
    MakeSmallFreezableCharacter(inst)        -- 角色冰冻
    MakeSmallPerishableCreature(inst)        -- 可腐烂（如果是小动物）

    return inst
end
```

```lua
-- 典型建筑 Prefab
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)             -- 障碍物物理
    MakeLargeBurnable(inst, nil, nil, true)  -- 大型可燃（建筑模式）
    MakeLargePropagator(inst)                -- 大型传播
    MakeSnowCovered(inst)                    -- 积雪覆盖

    return inst
end
```

### 10.2 Mod 中自定义

可以在 Mod 中直接调用这些函数，也可以自定义类似的工厂函数：

```lua
-- modmain.lua
local function MakeMyCustomSetup(inst)
    -- 调用标准函数
    MakeCharacterPhysics(inst, 100, .6)
    MakeLargeBurnableCharacter(inst)
    MakeMediumFreezableCharacter(inst)
    -- 添加自定义逻辑
    inst:AddComponent("my_custom_component")
end
```
