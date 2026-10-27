# 标签系统 (Tags)

> 标签是 DST 中最核心的实体分类和交互判定机制。通过 `inst:AddTag(tag)` / `inst:RemoveTag(tag)` / `inst:HasTag(tag)` 管理。

## 概述

DST 中的标签系统用于：
1. **实体分类** — 区分玩家、怪物、动物等
2. **交互判定** — 控制可工作、可装备、可攻击等
3. **状态标识** — 标记燃烧、冰冻、睡眠等状态
4. **阵营/势力** — 暗影阵营、月灵阵营等
5. **角色特性** — 各角色专属能力

## API

```lua
-- 添加标签
inst:AddTag("monster")

-- 移除标签
inst:RemoveTag("monster")

-- 检查标签
if inst:HasTag("monster") then
    -- ...
end

-- 检查任意标签
if inst:HasAnyTag("monster", "animal") then
    -- ...
end

-- 添加或移除
inst:AddOrRemoveTag("fire", is_burning)
```

---

## 一、实体类型标签

| 标签 | 说明 |
|------|------|
| `player` | 玩家 |
| `monster` | 怪物 |
| `character` | 角色 |
| `animal` | 动物 |
| `critter` | 小动物/宠物 |
| `small_livestock` | 小型家畜 |
| `NPC_workable` | NPC可工作对象 |
| `NPC_contestant` | NPC参赛者 |

## 二、阵营/势力标签

| 标签 | 说明 |
|------|------|
| `shadow_aligned` | 暗影阵营 |
| `lunar_aligned` | 月灵阵营 |
| `shadowminion` | 暗影仆从 |
| `lunarminion` | 月灵仆从 |
| `player_shadow_aligned` | 玩家暗影阵营 |
| `player_lunar_aligned` | 玩家月灵阵营 |
| `hostile` | 敌对（主动攻击） |
| `alwayshostile` | 始终敌对 |
| `companion` | 同伴（随从） |
| `player_aligned` | 玩家阵营 |
| `domesticated` | 已驯化 |

## 三、角色特性标签

| 标签 | 说明 | 角色 |
|------|------|------|
| `woodcutter` | 伐木工 | 伍迪 |
| `wereplayer` | 变身玩家 | 伍迪 |
| `beaver` | 海狸形态 | 伍迪 |
| `pyromaniac` | 纵火狂 | 薇洛 |
| `bernieowner` | 伯尼主人 | 薇洛 |
| `scientist` | 科学家 | 威尔逊 |
| `mime` | 哑剧 | 韦斯 |
| `balloonomancer` | 气球术士 | 韦斯 |
| `valkyrie` | 女武神 | 薇格弗德 |
| `masterchef` | 主厨 | 沃利 |
| `ghostlyfriend` | 幽灵朋友 | 温蒂 |
| `spiderwhisperer` | 蜘蛛低语者 | 韦伯 |
| `strongstomach` | 铁胃 | 韦伯/沃拓克斯 |
| `slingshot_sharpshooter` | 弹弓神射手 | 沃尔特 |
| `clockmaker` | 钟表匠 | 旺达 |
| `handyperson` | 巧手 | 薇诺娜 |
| `soulstealer` | 灵魂窃取者 | 沃拓克斯 |
| `magician` | 魔术师 | 麦斯威尔 |
| `reader` | 阅读者 | 薇克巴顿 |
| `merm` | 鱼人 | 沃特 |
| `plantkin` | 植物亲属 | 沃姆伍德 |
| `chessfriend` | 发条朋友 | WX-78 |
| `strongman` | 大力士 | 沃尔夫冈 |

## 四、状态标签

| 标签 | 说明 |
|------|------|
| `INLIMBO` | 在limbo中（不存在于世界） |
| `NOCLICK` | 不可点击 |
| `notarget` | 不可被选为目标 |
| `noattack` | 不可被攻击 |
| `noplayertarget` | 不可被玩家选为目标 |
| `invisible` | 不可见 |
| `flight` | 飞行状态 |
| `playerghost` | 玩家鬼魂 |
| `busy` | 忙碌中 |
| `sleeping` | 睡眠中 |
| `spawnprotection` | 生成保护 |
| `knockbackimmune` | 击退免疫 |
| `is_teleporting` | 传送中 |
| `nohasslers` | 无骚扰者 |
| `debugnoattack` | 调试禁止攻击 |

## 五、火焰/温度标签

| 标签 | 说明 |
|------|------|
| `fire` | 燃烧中 |
| `smolder` | 闷烧中 |
| `canlight` | 可被点燃 |
| `nolight` | 不可被点燃 |
| `burnt` | 已烧毁 |
| `extinguisher` | 灭火器 |
| `fireimmune` | 火免疫 |
| `heatresistant` | 耐热 |
| `HASHEATER` | 有加热器 |
| `freezable` | 可冻结 |
| `frozen` | 已冻结 |
| `icebox_valid` | 冰箱有效 |

## 六、武器/战斗标签

| 标签 | 说明 |
|------|------|
| `weapon` | 武器 |
| `sharp` | 锋利 |
| `rangedweapon` | 远程武器 |
| `projectile` | 投射物 |
| `extinguisher` | 灭火器 |
| `toughfighter` | 坚韧战士 |
| `aoeweapon_leap` | 跳跃AOE |
| `aoeweapon_lunge` | 冲刺AOE |
| `aoeweapon_mace` | 锤类AOE |
| `propweapon` | 道具武器 |
| `quickcast` | 快速施法 |
| `electric` | 电击 |
| `electricdamageimmune` | 电伤害免疫 |
| `alwaysblock` | 始终格挡 |
| `wall` | 墙壁 |
| `structure` | 建筑 |
| `object` | 物体 |

## 七、交互/工作标签

### Workable 标签（由 workable 组件动态生成）

| 标签 | 说明 |
|------|------|
| `CHOP_workable` | 可砍伐 |
| `MINE_workable` | 可挖掘 |
| `DIG_workable` | 可铲挖 |
| `HAMMER_workable` | 可锤击 |
| `NET_workable` | 可网捕 |
| `HACK_workable` | 可劈砍 |
| `workrepairable` | 可修复 |

### 物品交互

| 标签 | 说明 |
|------|------|
| `backpack` | 背包 |
| `portablestorage` | 便携存储 |
| `deckcontainer` | 甲板容器 |
| `thief` | 小偷（可偷物品） |
| `irreplaceable` | 不可替代 |
| `nonpotatoable` | 不可土豆化 |
| `nosteal` | 不可偷窃 |
| `cattoy` | 猫玩具 |
| `cattoyairborne` | 猫空中玩具 |

## 八、食物/烹饪标签

| 标签 | 说明 |
|------|------|
| `edible_{foodtype}` | 食物类型（如 `edible_MEAT`, `edible_VEGGIE`） |
| `badfood` | 坏食物 |
| `fresh` | 新鲜 |
| `stale` | 不新鲜 |
| `spoiled` | 腐烂 |
| `sweetener` | 甜味剂 |
| `icebox_valid` | 冰箱有效 |

## 九、建筑/部署标签

| 标签 | 说明 |
|------|------|
| `shelter` | 遮蔽所 |
| `structure` | 建筑 |
| `wall` | 墙壁 |
| `prototyper` | 原型机 |
| `researchlab` | 研究实验室 |
| `sciencemachine` | 科学机器 |
| `cooker` | 烹饪设备 |
| `stewer` | 炖锅 |
| `dryingrack` | 晾肉架 |
| `lightningrod` | 避雷针 |

## 十、生物/怪物标签

| 标签 | 说明 |
|------|------|
| `epic` | 史诗级（Boss） |
| `largecreature` | 大型生物 |
| `scarytoprey` | 吓猎物 |
| `prey` | 猎物 |
| `soulless` | 无魂 |
| `mech` | 机械 |
| `flying` | 飞行 |
| `ghost` | 幽灵 |
| `gestalt` | 月灵形态 |
| `shadowcreature` | 暗影生物 |
| `nightmarecreature` | 噩梦生物 |
| `noauradamage` | 无光环伤害 |
| `notraptrigger` | 不触发陷阱 |
| `noepicmusic` | 无史诗音乐 |

## 十一、装备标签

| 标签 | 说明 |
|------|------|
| `armor` | 防具 |
| `hat` | 帽子 |
| `body` | 身体装备 |
| `hand` | 手部装备 |
| `amulet` | 护符 |

## 十二、世界/环境标签

| 标签 | 说明 |
|------|------|
| `cave` | 洞穴 |
| `HASHEATER` | 有加热器 |
| `anticheat` | 反作弊 |
| `mastershard` | 主碎片 |
| `caveshard` | 洞穴碎片 |

## 十三、其他特殊标签

| 标签 | 说明 |
|------|------|
| `FX` | 特效（不被光环扫描） |
| `DECOR` | 装饰（不被光环扫描） |
| `INLIMBO` | 不存在于世界 |
| `NOCLICK` | 不可点击 |
| `locomotor` | 有移动能力 |
| `_combat` | 有战斗能力（内部） |
| `_container` | 有容器能力（内部） |
| `sanityaura` | 理智光环 |
| `stealth` | 潜行 |
| `hidden` | 隐藏 |
| `busy` | 忙碌 |
| `pocketdimension_container` | 口袋维度容器 |
| `usesdepleted` | 耐久耗尽 |
