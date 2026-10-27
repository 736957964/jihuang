# 08-prefabs — 生物/角色 Prefab 详细参考

> 源码: `scripts/prefabs/` (1583 个文件)
> 本文档列出所有主要的角色和生物 Prefab，包含关键参数和使用方式。

---

## 1. 角色 Prefabs (Characters)

角色 Prefab 位于 `scripts/prefabs/` 中，每个角色有独立文件。

### 1.1 基础角色

| Prefab | 文件 | 说明 | 特殊机制 |
|--------|------|------|----------|
| `wilson` | `wilson.lua` | 威尔逊 | 胡子生长 |
| `willow` | `willow.lua` | 薇洛 | 伯尼熊、火焰抗性 |
| `wolfgang` | `wolfgang.lua` | 沃尔夫冈 | 力量值系统 |
| `wendy` | `wendy.lua` | 温蒂 | 阿比盖尔 |
| `wx78` | `wx78.lua` | WX-78 | 电路系统、齿轮升级 |
| `wickerbottom` | `wickerbottom.lua` | 薇克巴顿 | 书籍制作 |
| `woodie` | `woodie.lua` | 伍迪 | 变身（海狸/麋鹿/鹅） |
| `wes` | `wes.lua` | 韦斯 | 气球、沉默 |
| `maxwell` | `maxwell.lua` | 麦斯威尔 | 暗影傀儡、暗影法典 |
| `wigfrid` | `wigfrid.lua` | 薇格弗德 | 只吃肉、战斗加成 |
| `webber` | `webber.lua` | 韦伯 | 蜘蛛友好、蜘蛛巢 |

### 1.2 DLC/更新角色

| Prefab | 说明 | 特殊机制 |
|--------|------|----------|
| `winona` | 薇诺娜 | 投石机、胶带 |
| `wortox` | 沃拓克斯 | 灵魂跳跃、灵魂治疗 |
| `wormwood` | 沃姆伍德 | 种植、开花、不能食物治疗 |
| `wurt` | 沃特 | 鱼人友好、沼泽之王 |
| `walter` | 沃尔特 | 弹弓、沃比、营地故事 |
| `wanda` | 旺达 | 年龄系统、回溯表、传送 |
| `warly` | 沃利 | 厨师袋、特殊食谱 |

### 1.3 角色 Prefab 通用结构

```lua
-- 角色 prefab 通用结构
local fn = function()
    local inst = CreateEntity()
    -- 添加基础组件
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    -- 设置动画
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wilson")
    inst.AnimState:PlayAnimation("idle")

    -- 添加标签
    inst:AddTag("player")
    inst:AddTag("character")

    -- 网络同步
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    -- 添加组件
    inst:AddComponent("health")
    inst:AddComponent("hunger")
    inst:AddComponent("sanity")
    inst:AddComponent("inventory")
    inst:AddComponent("playercontroller")
    -- ... 更多组件

    -- 自定义属性
    inst.custom_variable = 0

    return inst
end

return Prefab("character_name", fn, assets)
```

---

## 2. Boss 生物 Prefabs

### 2.1 地表 Boss

| Prefab | 文件 | 生命值 | 说明 |
|--------|------|--------|------|
| `deerclops` | `deerclops.lua` | 4000 | 独眼巨鹿（冬季） |
| `bearger` | `bearger.lua` | 6000 | 熊獾（秋季） |
| `dragonfly` | `dragonfly.lua` | 27500 | 蜻蜓龙（夏季沙漠） |
| `moose` | `moose.lua` | 3000 | 麋鹿鹅（春季） |
| `klaus` | `klaus.lua` | 10000+ | 克劳斯（冬季，赃物袋） |
| `beequeen` | `beequeen.lua` | 22500 | 蜂后 |
| `antlion` | `antlion.lua` | 6000 | 蚁狮（夏季绿洲） |
| `malbatross` | `malbatross.lua` | 5000 | 邪天翁（海洋） |
| `crabking` | `crabking.lua` | 20000+ | 螃蟹王（海洋） |

### 2.2 洞穴 Boss

| Prefab | 说明 |
|--------|------|
| `stalker` | 远古织影者（中庭） |
| `toadstool` | 蟾蜍王（洞穴） |
| `minotaur` | 远古守护者（遗迹） |
| `nightmarecreature` | 暗影生物 |

### 2.3 月岛/特殊 Boss

| Prefab | 说明 |
|--------|------|
| `alterguardian_phase1/2/3` | 天体守护者（三阶段） |
| `eyeofterror` | 恐怖之眼 |
| `daywalker` | 昼行者 |
| `shadow_chesspieces` | 暗影棋子（三件套） |

### 2.4 Boss Prefab 通用结构

```lua
local function fn()
    local inst = CreateEntity()
    -- ... 基础实体设置 ...

    -- Boss 特有组件
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BOSS_HP)
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.BOSS_DMG)
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"meat", "boss_item"})
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_LARGE

    -- Boss 特殊机制
    inst:AddComponent("timer")  -- 阶段切换计时器
    inst:AddComponent("groundpounder")  -- 地面震动

    return inst
end
```

---

## 3. 普通生物 Prefabs

### 3.1 中立生物

| Prefab | 文件 | 说明 |
|--------|------|------|
| `beefalo` | `beefalo.lua` | 牛（可驯服） |
| `pig` | `pigman.lua` | 猪人 |
| `bunnyman` | `bunnyman.lua` | 兔人 |
| `koalefant` | `koalefant.lua` | 考拉象 |
| `chester` | `chester.lua` | 切斯特 |
| `glommer` | `glommer.lua` | 格罗姆 |
| `catcoon` | `catcoon.lua` | 浣熊猫 |
| `mole` | `mole.lua` | 鼹鼠 |
| `rabbit` | `rabbit.lua` | 兔子 |
| `butterfly` | `butterfly.lua` | 蝴蝶 |
| `bee` | `bee.lua` | 蜜蜂 |
| `perd` | `perd.lua` | 火鸡 |
| `penguin` | `penguin.lua` | 企鹅 |
| `tallbird` | `tallbird.lua` | 高鸟 |
| `smallbird` | `smallbird.lua` | 小鸟 |
| `rocky` | `rocky.lua` | 岩石龙虾 |

### 3.2 敌对生物

| Prefab | 文件 | 说明 |
|--------|------|------|
| `spider` | `spider.lua` | 蜘蛛 |
| `spiderqueen` | `spiderqueen.lua` | 蜘蛛女王 |
| `hound` | `hound.lua` | 猎犬 |
| `warg` | `warg.lua` | 座狼 |
| `frog` | `frog.lua` | 青蛙 |
| `tentacle` | `tentacle.lua` | 触手 |
| `merm` | `merm.lua` | 鱼人 |
| `krampus` | `krampus.lua` | 坎普斯 |
| `bat` | `bat.lua` | 蝙蝠 |
| `mosquito` | `mosquito.lua` | 蚊子 |
| `leif` | `leif.lua` | 树精 |
| `slurtle` | `slurtle.lua` | 蜗牛龟 |
| `worm` | `worm.lua` | 洞穴蠕虫 |
| `spat` | `spat.lua` | 唾鱼 |
| `cookiecutter` | `cookiecutter.lua` | 饼干切割机 |
| `shark` | `shark.lua` | 鲨鱼 |
| `gnarwail` | `gnarwail.lua` | 独角鲸 |

### 3.3 暗影生物

| Prefab | 说明 |
|--------|------|
| `shadowcreature` | 暗影生物（影怪） |
| `shadowtentacle` | 暗影触手 |
| `shadow_knight` | 暗影骑士 |
| `shadow_bishop` | 暗影主教 |
| `shadow_rook` | 暗影战车 |
| `shadowwaxwell` | 暗影麦斯威尔 |
| `shadow_leech` | 暗影水蛭 |
| `fused_shadeling` | 融合暗影 |

### 3.4 月岛生物

| Prefab | 说明 |
|--------|------|
| `gestalt` | 格斯特 |
| `lunar_grazer` | 月面食草者 |
| `moonbeast` | 月兽 |
| `dustmoth` | 尘蛾 |
| `fruitfly` | 果蝇 |

### 3.5 海洋生物

| Prefab | 说明 |
|--------|------|
| `oceanfish` | 海鱼（通用） |
| `squid` | 乌贼 |
| `wobster` | 龙虾 |
| `lightcrab` | 光蟹 |
| `hermitcrab` | 寄居蟹 |

### 3.6 随从/宠物

| Prefab | 说明 |
|--------|------|
| `abigail` | 阿比盖尔（温蒂） |
| `bernie_active` | 伯尼（薇洛） |
| `wobybig` / `wobysmall` | 沃比（沃尔特） |
| `critter_*` | 各种小动物宠物 |
| `chester` | 切斯特 |

---

## 4. 建筑 Prefabs

### 4.1 科学/魔法建筑

| Prefab | 说明 |
|--------|------|
| `researchlab` | 科学机器 |
| `researchlab2` | 炼金引擎 |
| `researchlab3` | 暗影操纵器 |
| `researchlab4` | 天体祭坛 |
| `cartographydesk` | 制图桌 |
| `bookstation` | 书架（薇克巴顿） |

### 4.2 生存建筑

| Prefab | 说明 |
|--------|------|
| `campfire` | 营火 |
| `firepit` | 火坑 |
| `endothermfire` | 吸热火坑 |
| `endothermfirepit` | 吸热营火 |
| `tent` | 帐篷 |
| `siestahut` | 午睡棚 |
| `bedroll_*` | 睡袋系列 |

### 4.3 存储/制作建筑

| Prefab | 说明 |
|--------|------|
| `treasurechest` | 箱子 |
| `icebox` | 冰箱 |
| `cookpot` | 烹饪锅 |
| `dryingrack` | 晾肉架 |
| `birdcage` | 鸟笼 |

### 4.4 农场建筑

| Prefab | 说明 |
|--------|------|
| `farmplot` | 农场 |
| `beebox` | 蜂箱 |
| `meatrack` | 晾肉架 |
| `saltlick` | 舔盐块 |

### 4.5 防御建筑

| Prefab | 说明 |
|--------|------|
| `wall_*` | 各种墙壁 |
| `fence_*` | 栅栏 |
| `toothtrap` | 牙齿陷阱 |
| `beemine` | 蜜蜂地雷 |

---

## 5. 物品 Prefabs

### 5.1 工具

| Prefab | 说明 |
|--------|------|
| `axe` | 斧头 |
| `pickaxe` | 镐子 |
| `shovel` | 铲子 |
| `hammer` | 锤子 |
| `bugnet` | 捕虫网 |
| `fishingrod` | 钓鱼竿 |
| `razor` | 剃刀 |

### 5.2 武器

| Prefab | 说明 |
|--------|------|
| `spear` | 长矛 |
| `tentaclespike` | 触手尖刺 |
| `hambat` | 火腿棒 |
| `nightsword` | 暗影剑 |
| `batbat` | 蝙蝠棒 |
| `boomerang` | 回旋镖 |
| `blowdart_*` | 吹箭系列 |
| `whip` | 鞭子 |

### 5.3 盔甲/服装

| Prefab | 说明 |
|--------|------|
| `armor_wood` | 木甲 |
| `armor_grass` | 草甲 |
| `armor_marble` | 大理石甲 |
| `armor_ruins` | 铥矿甲 |
| `armor_dragonfly` | 鳞甲 |
| `footballhat` | 足球头盔 |
| `beekeeperhat` | 养蜂帽 |

### 5.4 食物

参考 [12-cooking](/12-cooking/index) 烹饪系统文档。

---

## 6. 植物 Prefabs

| Prefab | 说明 |
|--------|------|
| `evergreen` | 常青树 |
| `deciduoustree` | 落叶树 |
| `marsh_tree` | 沼泽树 |
| `berrybush` | 浆果丛 |
| `grass` | 草 |
| `sapling` | 树枝苗 |
| `flower` | 花 |
| `reeds` | 芦苇 |
| `cactus` | 仙人掌 |
| `mushroom_*` | 各种蘑菇 |
| `rock_*` | 各种岩石 |
| `pond` | 池塘 |
| `spiderden` | 蜘蛛巢 |

---

## 7. 特效 Prefabs

参考 [19-fx](/19-fx/index) 特效系统文档。

---

## 8. 编写自定义 Prefab

### 8.1 简单物品

```lua
local assets = {
    Asset("ANIM", "anim/my_item.zip"),
    Asset("ATLAS", "images/inventoryimages/my_item.xml"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("my_item")
    inst.AnimState:SetBuild("my_item")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("misc")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    return inst
end

return Prefab("my_item", fn, assets)
```

### 8.2 简单生物

```lua
local brain = require("brains/mycreaturebrain")

local function fn()
    local inst = CreateEntity()
    -- ... 实体设置 ...
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst:AddComponent("locomotor")
    inst:AddComponent("lootdropper")

    inst:SetBrain(brain)
    inst:SetStateGraph("SGmycreature")

    return inst
end
```

### 8.3 在 Mod 中添加 Prefab

```lua
-- modmain.lua
PrefabFiles = { "my_item", "my_creature" }

-- 或动态注册
AddPrefabPostInit("spider", function(inst)
    -- 修改已有 prefab
end)
```
