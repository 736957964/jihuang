# TUNING 配置

> 源码: `scripts/tuning.lua`

## 概述

TUNING 是 DST 的全局配置表，包含所有游戏数值常量。在 `tuning.lua` 中定义，可在 Mod 中通过 `TUNING.XXX` 读取和修改。

## 重要：Mod 中修改 TUNING

```lua
-- 直接修改（全局生效）
TUNING.WILSON_HEALTH = 200

-- 或使用 AddTuningModifier
AddTuningModifier("WILSON_HEALTH", function(default_value)
    return default_value * 1.5
end)
```

---

## 时间常量

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `SEG_TIME` | `30` | 一个时间段的秒数 |
| `TOTAL_DAY_TIME` | `480` | 一天总秒数（16段） |
| `DAY_SEGS_DEFAULT` | `10` | 白天段数 |
| `DUSK_SEGS_DEFAULT` | `4` | 黄昏段数 |
| `NIGHT_SEGS_DEFAULT` | `2` | 夜晚段数 |
| `DAY_TIME_DEFAULT` | `300` | 白天秒数 |
| `DUSK_TIME_DEFAULT` | `120` | 黄昏秒数 |
| `NIGHT_TIME_DEFAULT` | `60` | 夜晚秒数 |
| `AUTOSAVE_INTERVAL` | `480` | 自动保存间隔（1天） |

## 角色属性

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `WILSON_HEALTH` | `150` | 威尔逊生命值 |
| `WILSON_HUNGER` | `150` | 威尔逊饥饿值 |
| `WILSON_SANITY` | `200` | 威尔逊理智值 |
| `WILSON_HUNGER_RATE` | `75/480` | 威尔逊饥饿速率 |
| `WILSON_ATTACK_PERIOD` | `0.4` | 威尔逊攻击间隔 |
| `BASE_SURVIVOR_ATTACK` | `34` | 基础幸存者攻击力 |
| `DEFAULT_CHARACTER_HEALTH` | `150` | 默认角色生命值 |
| `PLAYER_DAMAGE_TAKEN_MOD` | `1` | 玩家承受伤害倍率 |

## 工具耐久

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `AXE_USES` | `100` | 斧头耐久 |
| `PICKAXE_USES` | `33` | 镐子耐久 |
| `HAMMER_USES` | `75` | 锤子耐久 |
| `SHOVEL_USES` | `25` | 铲子耐久 |
| `SPEAR_USES` | `150` | 长矛耐久 |
| `SPIKE_USES` | `100` | 狼牙棒耐久 |
| `NIGHTSWORD_USES` | `100` | 暗影剑耐久 |
| `BUGNET_USES` | `10` | 捕虫网耐久 |
| `FISHINGROD_USES` | `9` | 钓竿耐久 |
| `TRAP_USES` | `8` | 陷阱耐久 |
| `BOOMERANG_USES` | `10` | 回旋镖耐久 |
| `ICESTAFF_USES` | `20` | 冰杖耐久 |
| `FIRESTAFF_USES` | `20` | 火杖耐久 |
| `TELESTAFF_USES` | `5` | 传送杖耐久 |
| `HAMBAT_USES` | `100` | 火腿棒耐久 |
| `BATBAT_USES` | `75` | 蝙蝠棒耐久 |
| `MULTITOOL_AXE_PICKAXE_USES` | `800` | 多功能工具耐久 |
| `BRUSH_USES` | `75` | 刷子耐久 |
| `FENCE_ROTATOR_USES` | `200` | 栅栏旋转器耐久 |

## 护符/宝石

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `REDAMULET_USES` | `20` | 红护符耐久 |
| `REDAMULET_CONVERSION` | `5` | 红护符生命转换 |
| `BLUEAMULET_FUEL` | `360` | 蓝护符冷却时间 |
| `PURPLEAMULET_FUEL` | `240` | 紫护符持续时间 |
| `YELLOWAMULET_FUEL` | `480` | 黄护符持续时间 |
| `ORANGEAMULET_USES` | `225` | 橙护符耐久 |
| `GREENAMULET_USES` | `5` | 绿护符耐久（建造半价） |
| `GREENAMULET_INGREDIENTMOD` | `0.5` | 绿护符材料减免 |

## 食物/腐烂

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `STALE_FOOD_HUNGER` | `2/3` | 不新鲜饥饿倍率 |
| `STALE_FOOD_HEALTH` | `1/3` | 不新鲜生命倍率 |
| `SPOILED_FOOD_HUNGER` | `1/2` | 腐烂饥饿倍率 |
| `SPOILED_FOOD_HEALTH` | `0` | 腐烂生命倍率 |
| `PERISH_FRESH` | `0.8` | 新鲜阈值 |
| `PERISH_STALE` | `0.2` | 不新鲜阈值 |
| `PERISH_FAST` | `360` | 快速腐烂时间（浆果） |
| `PERISH_MED` | `720` | 中速腐烂时间（肉） |
| `PERISH_SLOW` | `1440` | 慢速腐烂时间（蛋） |
| `PERISH_PRESERVED` | `5760` | 防腐腐烂时间 |
| `PERISH_SUPERSLOW` | `11520` | 超慢腐烂时间 |

## 理智

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `SANITY_BECOME_INSANE_THRESH` | `0.30` | 陷入疯狂阈值 |
| `SANITY_BECOME_SANE_THRESH` | `0.35` | 恢复理智阈值 |
| `SANITY_DAY_GAIN` | `0.1` | 白天理智恢复/秒 |
| `SANITY_NIGHT_LIGHT` | `0` | 亮光下理智变化 |
| `SANITY_NIGHT_MID` | `-0.05` | 中光下理智流失 |
| `SANITY_NIGHT_DARK` | `-0.08` | 黑暗中理智流失 |
| `SANITY_AURA_SEACH_RANGE` | `15` | 灵光搜索范围 |
| `SANITY_SMALL` | `5` | 小量理智 |
| `SANITY_MED` | `10` | 中量理智 |
| `SANITY_HUGE` | `20` | 大量理智 |
| `SANITY_HIGH_LIGHT` | `0.5` | 高光阈值 |
| `SANITY_LOW_LIGHT` | `0.2` | 低光阈值 |
| `SANITY_DAPPERNESS` | `1.0/30` | 装扮理智恢复速率 |
| `MOISTURE_SANITY_PENALTY_MAX` | `0.15` | 潮湿最大理智惩罚 |
| `SANITY_GHOST_PLAYER_DRAIN` | `0.15` | 幽灵理智流失 |
| `MAX_SANITY_GHOST_PLAYER_DRAIN_MULT` | `10` | 最大幽灵流失倍率 |

## 堆叠

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `STACK_SIZE_LARGEITEM` | `10` | 大物品堆叠上限 |
| `STACK_SIZE_MEDITEM` | `20` | 中物品堆叠上限 |
| `STACK_SIZE_SMALLITEM` | `40` | 小物品堆叠上限 |
| `STACK_SIZE_TINYITEM` | `60` | 微小物品堆叠上限 |
| `STACK_SIZE_PELLET` | `120` | 颗粒堆叠上限 |

## 环境

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `MAX_WETNESS` | `100` | 最大湿度 |
| `OCEAN_WETNESS` | `75` | 落水初始湿度 |
| `MAX_FIRE_DAMAGE_PER_SECOND` | `120` | 最大火焰伤害/秒 |

## 战斗

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `DEFAULT_ATTACK_RANGE` | `2` | 默认攻击范围 |
| `DEFAULT_HIT_RECOVERY` | `0.75` | 默认受击恢复时间 |
| `MULTIPLAYER_ATTACK_MODIFIER` | `1` | 多人攻击修正 |
| `MULTIPLAYER_ARMOR_DURABILITY_MODIFIER` | `0.7` | 多人防具耐久修正 |

## 电击

| 常量 | 默认值 | 说明 |
|------|--------|------|
| `ELECTRIC_DAMAGE_MULT` | `1.5` | 电击伤害倍率 |
| `ELECTRIC_WET_DAMAGE_MULT` | `1.0` | 潮湿电击额外倍率 |

## 常见树木/矿物

| 常量 | 说明 |
|------|------|
| `EVERGREEN_CHOPS_SMALL` | 小树砍伐次数 |
| `EVERGREEN_CHOPS_NORMAL` | 中树砍伐次数 |
| `EVERGREEN_CHOPS_TALL` | 大树砍伐次数 |
| `ROCK_MINE` | 岩石挖掘次数 |
| `GOLDNUGGET_MINE` | 金矿挖掘次数 |
| `MARBLEPILLAR_MINE` | 大理石柱挖掘次数 |

## Mod 中使用示例

```lua
-- 修改角色属性
TUNING.WILSON_HEALTH = 200
TUNING.WILSON_HUNGER = 200
TUNING.WILSON_SANITY = 300

-- 修改工具耐久
TUNING.AXE_USES = 200

-- 修改食物腐烂速度
TUNING.PERISH_FAST = 720  -- 从6分钟变为12分钟

-- 修改理智阈值
TUNING.SANITY_BECOME_INSANE_THRESH = 0.2  -- 更难疯狂

-- 使用 AddTuningModifier
AddTuningModifier("WILSON_HEALTH", function(default)
    return default * 2
end)
```
