# 08 - Prefabs 预制体参考

> **源码位置**: `scripts/prefabs/` (1583个文件)  
> **核心机制**: `scripts/prefabs.lua` — Prefab 类定义  
> **全局API**: `scripts/mainfunctions.lua` 中的 `PrefabFiles`、`RegisterPrefabs` 等

## 1. Prefab 概述

**Prefab（预制体）** 是 DST 中所有游戏实体的模板定义。每个物品、生物、建筑、角色都是一个 Prefab。Prefab 定义了实体的初始化逻辑，包括添加组件、设置属性、绑定事件等。

### 1.1 Prefab 类定义 (`prefabs.lua`)

```lua
-- Prefab 类
Prefab = Class(function(self, name, fn, assets, deps, force_path_search)
    self.name = name          -- Prefab 名称（去除路径前缀）
    self.desc = ""            -- 描述
    self.fn = fn              -- 初始化函数 function(inst)
    self.assets = assets      -- 资源列表 {Asset(...), ...}
    self.deps = deps          -- 依赖的其他 Prefab
    self.force_path_search = force_path_search
end)
```

### 1.2 Asset 资源类型

```lua
-- 资源定义
Asset("ANIM", "anim/xxx.zip")          -- 动画资源
Asset("ATLAS", "images/xxx.xml")        -- 图集资源
Asset("IMAGE", "images/xxx.tex")        -- 贴图资源
Asset("SOUND", "sound/xxx.fsb")         -- 音效资源
Asset("SOUNDPACKAGE", "sound/xxx.fev")  -- 音效包
Asset("PKGREF", "anim/dynamic/xxx.dyn") -- 动态资源引用
Asset("INV_IMAGE", "xxx")              -- 物品栏贴图
Asset("SCRIPT", "scripts/prefabs/xxx.lua") -- 脚本文件
```

### 1.3 注册 Prefab

```lua
-- 方法1: 直接注册
return Prefab("myitem", fn, assets, deps)

-- 方法2: 使用 PrefabFiles（在 modmain.lua 中）
PrefabFiles = {
    "myitem",
    "mycreature",
}

-- 方法3: 使用 RegisterPrefabs
RegisterPrefabs(
    Prefab("myitem", myitem_fn, assets),
    Prefab("mycreature", mycreature_fn, assets),
)
```

---

## 2. Prefab 分类目录

### 2.1 Characters 角色 (20+)

| Prefab | 描述 |
|--------|------|
| `wilson` | 威尔逊 — 初始角色 |
| `willow` | 薇洛 — 火免疫、伯尼熊 |
| `wolfgang` | 沃尔夫冈 — 力量值系统 |
| `wendy` | 温蒂 — 阿比盖尔 |
| `wx78` | WX-78 — 齿轮升级 |
| `wickerbottom` | 薇克巴顿 — 书籍系统 |
| `woodie` | 伍迪 — 变身系统 |
| `wes` | 韦斯 — 挑战角色 |
| `maxwell` | 麦斯威尔 — 影子分身 |
| `wigfrid` | 薇格弗德 — 战斗角色 |
| `webber` | 韦伯 — 蜘蛛友好 |
| `winona` | 薇诺娜 — 建造专精 |
| `wortox` | 沃托克斯 — 灵魂系统 |
| `wormwood` | 沃姆伍德 — 植物亲和 |
| `wurt` | 沃特 — 鱼人王 |
| `walter` | 沃尔特 — 弹弓+沃比 |
| `wanda` | 旺达 — 时间魔法 |
| `warly` | 沃利 — 专属厨具 |
| `waxwell` | 老麦 — 同 maxwell |

**角色通用组件**：
- `health`, `hunger`, `sanity` — 三维
- `inventory`, `builder`, `talker` — 基础交互
- `temperature`, `moisture` — 环境
- `playercontroller` — 玩家控制
- `skilltreeupdater` — 技能树（DLC）

### 2.2 Creatures 生物 (500+)

#### 2.2.1 被动生物
- `rabbit`, `beardling` — 兔人/胡须兔
- `butterfly` — 蝴蝶
- `bee`, `killerbee` — 蜜蜂/杀人蜂
- `mole`, `mole_move` — 鼹鼠
- `perd`, `crow`, `robin` — 鸟
- `koalefant_summer`, `koalefant_winter` — 大象
- `fireflies` — 萤火虫
- `glommer`, `chester` — 跟随生物

#### 2.2.2 中立生物
- `pigman`, `pigguard` — 猪人/猪守卫
- `bunnyman` — 兔人
- `beefalo` — 皮弗娄牛
- `rocky`, `rockyherd` — 岩石龙虾
- `walrus`, `little_walrus` — 海象父子
- `catcoon` — 猫浣熊
- `voltgoat` — 伏特山羊

#### 2.2.3 敌对生物
- `spider`, `spider_warrior` — 蜘蛛
- `hound`, `firehound`, `icehound` — 猎犬
- `tentacle` — 触手
- `merm`, `mermguard` — 鱼人
- `frog` — 青蛙
- `tallbird` — 高脚鸟
- `worm` — 洞穴蠕虫
- `slurtle`, `snurtle` — 蜗牛
- `mosquito` — 蚊子
- `bat` — 蝙蝠
- `leif` — 树精
- `krampus` — 坎普斯
- `penguin` — 企鹅
- `shadowcreature`, `terrorbeak` — 暗影生物

### 2.3 Bosses 首领 (30+)

| Boss | 来源 | 生命值 | 掉落物 |
|------|------|--------|--------|
| `deerclops` | 冬季 | 4000 | Deerclops Eyeball |
| `bearger` | 秋季 | 6000 | Thick Fur |
| `moose`, `mosling` | 春季 | 6000 | Down Feather |
| `dragonfly` | 夏季 | 27500 | Scales |
| `klaus` | 冬季 | 10000+ | Loot Stash |
| `beequeen` | 蜂后 | 22500 | Honeycomb |
| `toadstool` | 洞穴 | 52500 | Shroom Skin |
| `minotaur` | 迷宫 | 2500 | Guardian Horn |
| `stalker` | 洞穴 | 12000+ | Bone Armor |
| `antlion` | 夏季 | 6000 | Desert Stone |
| `daywalkerl`, `daywalker2` | 月岛 | 5000+ | Pure Brilliance |
| `crabking` | 海洋 | 20000+ | Strident Trident |
| `shadow_rook/bishop/knight` | 暗影 | 10000+ | Dark Tatters |
| `eyeofterror` | 森林 | 5000 | Eye of Terror |
| `stalker_atrium` | 中庭 | 16000 | Bone Helm |

### 2.4 Structures 建筑 (200+)

| 类别 | Prefab 示例 |
|------|------------|
| **科技** | `researchlab`, `researchlab2`, `researchlab3`, `researchlab4` |
| **光源** | `campfire`, `firepit`, `coldfire`, `coldfirepit`, `mushroom_light` |
| **存储** | `treasurechest`, `icebox`, `dragonflychest`, `saltbox` |
| **烹饪** | `cookpot`, `meatrack`, `birdcage`, `portablecookpot` |
| **农场** | `slow_farmplot`, `fast_farmplot`, `wormlight_plant` |
| **防御** | `wall_stone`, `wall_hay`, `wall_wood`, `wall_moonrock`, `houndmound` |
| **魔法** | `resurrectionstone`, `nightlight`, `telebase`, `pandoraschest` |
| **雕像** | `statue_marble`, `statueglommer`, `statuemaxwell` |
| **遗迹** | `ruins_statue`, `ruins_vase`, `ruins_chair` |
| **船只** | `boat`, `mast`, `anchor`, `steeringwheel` |
| **其他** | `tent`, `siestahut`, `rainometer`, `winterometer`, `lightning_rod` |

### 2.5 Items 物品 (500+)

| 类别 | Prefab 示例 |
|------|------------|
| **工具** | `axe`, `pickaxe`, `shovel`, `hammer`, `razor` |
| **武器** | `spear`, `tentaclespike`, `hambat`, `nightsword`, `ruins_bat` |
| **护甲** | `armorwood`, `armorgrass`, `armormarble`, `armorruins` |
| **帽子** | `strawhat`, `footballhat`, `beefalohat`, `tophat`, `earmuffshat` |
| **食物** | `meat`, `monstermeat`, `carrot`, `berries`, `honey`, `butterflywings` |
| **资源** | `log`, `cutstone`, `boards`, `rope`, `goldnugget`, `flint`, `rocks` |
| **宝石** | `redgem`, `bluegem`, `purplegem`, `orangegem`, `yellowgem`, `greengem` |
| **书籍** | `book_birds`, `book_tentacles`, `book_sleep`, `book_gardening` |
| **蓝图** | `blueprint` |
| **饰品** | `trinket_1` ~ `trinket_37` |
| **航海** | `oar`, `driftwood_oar`, `boatpatch`, `boat_item` |

### 2.6 Plants 植物 (100+)

| Prefab | 描述 |
|--------|------|
| `evergreen`, `evergreen_sparse` | 常青树 |
| `deciduoustree` | 落叶树 |
| `marsh_tree` | 沼泽树 |
| `mushtree_tall/medium/small` | 蘑菇树 |
| `flower`, `flower_evil` | 花/恶魔花 |
| `sapling` | 树苗 |
| `grass` | 草 |
| `berrybush`, `berrybush2` | 浆果丛 |
| `reeds` | 芦苇 |
| `spiky_bush`, `spiky_tree` | 荆棘丛 |
| `cactus`, `oasis_cactus` | 仙人掌 |
| `marbletree`, `marblebean_sprout` | 大理石树 |
| `moon_tree`, `moon_tree_blossom` | 月树 |
| `lichen`, `cave_fern` | 洞穴植物 |
| `kelp`, `bullkelp_root` | 海藻 |

### 2.7 FX 特效 (50+)

| Prefab | 描述 |
|--------|------|
| `firesuppressor_fx` | 灭火器特效 |
| `forcefieldfx` | 力场特效 |
| `shadow_tentacle` | 暗影触手 |
| `groundpound_fx` | 地震特效 |
| `sandstorm_fx` | 沙尘暴 |
| `sinkhole_spawn_fx` | 天坑生成 |
| `spider_web` | 蜘蛛网 |
| `perdfx` | 鸟类飞行特效 |
| `cavein_boulder` | 洞穴落石 |

---

## 3. Prefab 编写规范

### 3.1 基本结构

```lua
local assets = {
    Asset("ANIM", "anim/myitem.zip"),
    Asset("IMAGE", "images/inventoryimages/myitem.tex"),
    Asset("ATLAS", "images/inventoryimages/myitem.xml"),
}

local function fn()
    local inst = CreateEntity()
    -- 添加Transform
    inst.entity:AddTransform()
    -- 添加动画
    inst.entity:AddAnimState()
    -- 设置bank和build
    inst.AnimState:SetBank("myitem")
    inst.AnimState:SetBuild("myitem")
    inst.AnimState:PlayAnimation("idle")

    -- 添加网络同步
    inst.entity:AddNetwork()

    -- 添加组件
    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab("myitem", fn, assets)
```

### 3.2 Make- 函数约定

游戏提供了大量 `Make*` 开头的标准组件配置函数（见 `standardcomponents.lua`），用于统一初始化常见组件：

```lua
-- 燃烧物
MakeSmallBurnable(inst)          -- 小型可燃烧
MakeMediumBurnable(inst)         -- 中型可燃烧
MakeLargeBurnable(inst)          -- 大型可燃烧
MakeSmallBurnableCharacter(inst) -- 角色小型燃烧

-- 物理体
MakeCharacterPhysics(inst, 75, .5)      -- 角色物理
MakeInventoryPhysics(inst, 1, .5)       -- 物品物理
MakeObstaclePhysics(inst, 1, 2)         -- 障碍物物理
MakeHeavyObstaclePhysics(inst, 1, 2)    -- 重物物理

-- 冰封
MakeSmallFreezableCharacter(inst)  -- 可冰冻
MakeMediumFreezableCharacter(inst)

-- 食物腐烂
MakeSmallPerishableCreature(inst, TUNING.PERISH_SUPERSLOW)

-- 鬼魂互动
MakeHauntableLaunch(inst)         -- 可被鬼魂弹飞
MakeHauntableWork(inst)           -- 可被鬼魂触发工作
MakeHauntableIgnite(inst)         -- 可被鬼魂点燃

-- 积雪
MakeSnowCovered(inst)             -- 积雪覆盖

-- 物理切换
ChangeToGhostPhysics(inst)        -- 切为鬼魂物理
ChangeToCharacterPhysics(inst)    -- 切为角色物理
ChangeToInventoryPhysics(inst)    -- 切为物品物理
```

### 3.3 网络同步注意事项

- 服务端逻辑放在 `if TheWorld.ismastersim then ... end` 中
- 客户端逻辑放在 `if not TheWorld.ismastersim then ... end` 中
- `inst.entity:AddNetwork()` 必须在组件添加之前
- 使用 `inst.entity:SetPristine()` 判断是否是初始创建
- 用 `MakeSnowCoveredPristine(inst)` 处理纯客户端初始化

---

## 4. 常见 Prefab 模式

### 4.1 简单物品

```lua
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank("myitem")
    inst.AnimState:SetBuild("myitem")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryFloatable(inst) -- 水上漂浮
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable") -- 可堆叠
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)
    return inst
end
```

### 4.2 生物

```lua
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    MakeCharacterPhysics(inst, 10, .5)
    inst.AnimState:SetBank("mycreature")
    inst.AnimState:SetBuild("mycreature")
    inst.AnimState:PlayAnimation("idle", true)
    -- 服务端逻辑
    inst:AddTag("animal")
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst:AddComponent("locomotor")
    inst:AddComponent("inspectable")
    inst:SetStateGraph("SGmycreature")
    inst:SetBrain(require("brains/mycreaturebrain"))
    return inst
end
```

### 4.3 建筑

```lua
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeObstaclePhysics(inst, 1)
    inst.AnimState:SetBank("mystructure")
    inst.AnimState:SetBuild("mystructure")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("structure")
    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    MakeLargeBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
    MakeHauntableWork(inst)
    return inst
end
```

---

## 5. 目录文件说明

- `characters/` — 玩家角色 Prefab 详细文档
- `creatures/` — 生物 Prefab 详细文档
- `bosses/` — Boss Prefab 详细文档
- `items/` — 物品 Prefab 详细文档
- `structures/` — 建筑 Prefab 详细文档
- `plants/` — 植物 Prefab 详细文档
- `fx/` — 特效 Prefab 详细文档
