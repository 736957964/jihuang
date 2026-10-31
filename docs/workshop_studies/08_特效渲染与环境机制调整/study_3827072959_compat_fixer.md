# 饥荒创意工坊研读报告：模组兼容修复 Compat Fixer

- **模组标识**：`3827072959`
- **作者**：萌萌的新
- **版本**：0.1.12
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：215 个 Lua 文件 / 共 19470 行；网络变量 3 处；RPC 14 处；注入钩子 34 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `modworldgenmain.lua`
- `scripts/compatfix/boot.lua`
- `scripts/compatfix/core/context.lua`
- `scripts/compatfix/core/loader.lua`
- `scripts/compatfix/core/log.lua`
- `scripts/compatfix/core/modscan.lua`
- `scripts/compatfix/core/registry.lua`
- `scripts/compatfix/core/util.lua`
- `scripts/compatfix/patches/_template_game.lua`
- `scripts/compatfix/patches/_template_mod.lua`
- `scripts/compatfix/patches/game/displayname_guard.lua`
- `scripts/compatfix/patches/index.lua`
- `scripts/compatfix/patches/mods/w1079538195.lua`
- `scripts/compatfix/patches/mods/w1084023218.lua`
- `scripts/compatfix/patches/mods/w1108032281.lua`
- `scripts/compatfix/patches/mods/w1120124958.lua`
- `scripts/compatfix/patches/mods/w1139925855.lua`
- `scripts/compatfix/patches/mods/w1157975551.lua`
- `scripts/compatfix/patches/mods/w1166220990.lua`
- `scripts/compatfix/patches/mods/w1173770304.lua`
- `scripts/compatfix/patches/mods/w1200745268.lua`
- `scripts/compatfix/patches/mods/w1207269058.lua`
- `scripts/compatfix/patches/mods/w1216718131.lua`
- `scripts/compatfix/patches/mods/w1275167632.lua`
- `scripts/compatfix/patches/mods/w1301033176.lua`
- `scripts/compatfix/patches/mods/w1364606782.lua`
- `scripts/compatfix/patches/mods/w1365141672.lua`
- `scripts/compatfix/patches/mods/w1367276577.lua`
- `scripts/compatfix/patches/mods/w1392778117.lua`
- `scripts/compatfix/patches/mods/w1405120786.lua`
- `scripts/compatfix/patches/mods/w1418746242.lua`
- `scripts/compatfix/patches/mods/w1467214795.lua`
- `scripts/compatfix/patches/mods/w1530801499.lua`
- `scripts/compatfix/patches/mods/w1540284567.lua`
- `scripts/compatfix/patches/mods/w1579421388.lua`
- `scripts/compatfix/patches/mods/w1595631294.lua`
- `scripts/compatfix/patches/mods/w1781410139.lua`
- `scripts/compatfix/patches/mods/w1803285852.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `world` | 8 |
| `AddComponentPostInit` | `combat` | 7 |
| `AddComponentPostInit` | `stackable` | 4 |
| `AddPrefabPostInit` | `skeleton` | 4 |
| `AddStategraphPostInit` | `wilson_client` | 2 |
| `AddPrefabPostInit` | `onemanband` | 2 |
| `AddPrefabPostInit` | `bee` | 2 |
| `AddComponentPostInit` | `milkable` | 2 |
| `AddPrefabPostInit` | `forest` | 2 |
| `AddComponentPostInit` | `inventory` | 2 |
| `AddComponentPostInit` | `diseaseable` | 2 |
| `AddPrefabPostInit` | `toadstool` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("world")
```lua
-- 核查记录（V-8fdbdb5a，判定误报，不修）：
--   审查曾断言 clean.lua:197 的 AddPrefabPostInit("world") 永不触发，经两轮证据证伪：
--   ① 当前版本(759671) prefabs/world.lua:555 在 MakeWorld 的 fn 里无条件执行
--      inst:SetPrefabName("world")，Klei 注释原文 "the actual prefab to load comes
--      from gamelogic.lua, this is for postinitfns"——该行存在的目的就是让 world
--      postinit 能挂到 forest/cave 世界上；② mainfunctions.lua:392-394 SpawnPrefab
--      按 inst.prefab(="world") 命中 modprefabinitfns["world"] 并执行，且 400-407 行
--      在 inst.prefab ~= 请求名时会再按请求名(forest/cave)补一次。
--   因此**不要**给这个模组补挂 forest/cave postinit：world+forest 双路径会重复
--   注册 10 天周期清理任务（清理频率翻倍）。滤镜RR(3115280970)的无头探针实证与此一致。

local origBeardShave
```
### AddComponentPostInit("combat")
```lua
            -- 根因（对照当前版本 scripts/components/combat.lua）：
            --   模组 modmain 用 AddComponentPostInit("combat") 只包装 Combat:GetAttacked 实现
            --   奇美拉形态穿甲：攻击者带 amiya_chimerabuff 标签或 stimuli=="amiya_chimerabuff" 时
            --   ① 撤销目标 externaldamagetakenmultipliers（<1 时先除回去，内部 :651 会再乘回来）
            --   ② 置 inst.amiya_ignoredebuff=true，让模组包装的 inventory:ApplyDamage（护甲）、
            --     damagetyperesist:GetResist、planarentity:AbsorbDamage、planardefense:GetDefense、
            --     saddler:ApplyDamage、health:DoDelta 全部放行。
            --   但现行 combat.lua 的 DoAttack(:1218)、反射伤害(:1235)、范围攻击(:1321/:1333)、
            --   redirect(:697) 均直接调用 Combat:GetAttacked_Internal，完全绕过 GetAttacked 包装
            --   → 奇美拉 buff 下阿米娅的近战攻击（amiya_atk 状态机走 combat:DoAttack）不穿甲。
            --   弹射物不受影响：amiyamagic:Hit 显式调 target.components.combat:GetAttacked。
            -- 修复思路：
```
### AddComponentPostInit("stackable")
```lua

-- 背景（审查 2026-10-27，游戏 760049）：模组用 AddComponentPostInit("stackable") 在组件添加时
-- 包装 ondestack、并给每个新堆叠物安排 DoTaskInTime(0.1) 做自动堆叠/自动拾取。两处与现行
-- 游戏源码交界有缺陷，见下面两条 fix 的注释。第三条审查发现（gilded knight 掉 horseshoe 崩服）
-- 经逐行对照当前源码确认全链路 nil 安全，判为误报，处置见适配记录 V-cda9ecaf。

return {
    id = "w1803285852",
    name = "Auto Stack and Pick Up",
    workshop_ids = { "1803285852" },  -- 创意工坊 id；也会匹配压力测试用的 dwmtest_<id> 文件夹
    versions = { "0.3.1" },
    tested_time_updated = 1778067424,          -- 编写补丁时目标模组在工坊的 time_updated，tools 用来提醒"模组已更新需复查"
```
### AddPrefabPostInit("skeleton")
```lua
--      "variable 'GetClock' is not declared"，工坊评论 "Wilton doesn't work ;_;"）。
--   2) 即使过 1)，modmain 的 AddPrefabPostInit('skeleton') 里 GetPlayer()（simutil.lua:26 返回 ThePlayer）
--      在专用服务器/世界生成阶段为 nil，索引 nil 崩服；且 components/resurrector 已不存在于当前源码。
--   3) AddSimPostInit 回调参数恒为 nil（gamelogic.lua:958 ModManager:SimPostInit(nil)），索引 nil 报错。
--   4) warmond.lua:107 用单机版 5 参 MakePlayerCharacter：fn 落进 common_postinit（客户端也执行、且在
--      组件创建之前，player_common.lua:2536 在 SetPristine 前、health 等组件 2754 行才添加），
--      inst.components.health 为 nil 必崩；start_inv 表被当 master_postinit 调用（2923 行）。
--   5) warmond.lua:91 inventory:GuaranteeItems 已删除（components/inventory.lua:117 注释 Deprecated）。
--   6) bonerang.lua:116 出生自毁检查 GetPlayer() 在专用服恒 nil，特色物品生成即消失。
--   7) warmond.lua:39 全局覆盖 GetSpecialCharacterString（stringutil.lua:224 处理 mime/ghost/wonkey/wilton），
--      模组版对其他角色返回 nil，全服原版特殊语音失效。
--   8) warmond.lua:79-80 eater.strongstomach/ignoresspoilage 字段机制已改为实体标签（actions.lua:2397-2398）。
```
### AddStategraphPostInit("wilson_client")
```lua
-- ④ 审查发现（V-1f3711fb，客户端路径，压测无法覆盖）：
--   wixie_postinit/stategraphs/SGwixie_client.lua（AddStategraphPostInit("wilson_client")，
--   modimport 于 init_postinit.lua:286，配置 wixie_walter 默认开启）注入的 claustrophobic
--   系/wixie_spawn 状态在客户端调用了 replica 上不存在的方法：现行 inventory_replica.lua
--   方法集无 Unequip/DropItem/Show/Hide（rider_replica.lua 无 ActualDismount，仅服务器
--   rider 组件有），且 :427 inst.components.sanity 未判空——player_common.lua 中 sanity/
--   inventory/rider 均在 SetPristine(:2611) 之后才 AddComponent，客户端玩家实体上恒 nil。
--   claustrophobic 由 RPC（modmain.lua:253，服务器执行）触发服务器端 SGwixie 版本（其
--   components.* 调用服务器侧合法），客户端副本静态分析未见入口，但按防御性修复全部加
--   存在性/判空守卫：方法存在时行为不变，不存在时跳过（客户端本就无法执行卸下/掉落，
--   真正逻辑由服务器端 SGwilson/SGwixie 版本完成）。
-- ⑤ 压测崩溃（run 20261027-172646-0e24，修复 ①③ 后 harness 走到字母序末尾才暴露）：
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 3 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 14 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。