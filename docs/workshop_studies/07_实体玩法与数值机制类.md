# 实体玩法与数值增强类模组研读全景综述

> 📊 **本分类收录研读 MOD**：共 **69** 个模组
> 💡 **领域概述**：涵盖各类生物属性调整、特殊道具、技能与机制调整模组。核心解析 AddPrefabPostInit、组件参数重调与战斗公式魔改。

---

## 一、核心设计范式与公用底层机制

本类模组在饥荒（DST）引擎生态中具备极高的一致性特征与代码模式。通过横向对比各权威模组的实现方案，我们提炼出以下核心架构规范：

### 1. 典型钩子与生命周期管理
- 统一采用非侵入式 PostInit 扩展，严禁直接覆盖底层核心文件。
- 网络变量与 RPC 通信必须区分客户端与服务端边界，严格防范不同步与内存泄漏。

### 2. 经典避坑与生产级守则
- **空指针守卫**：客户端 UI 与实体可能存在初始化时序差异，任何访问必须具备 if inst ~= nil and inst:IsValid() 防护。
- **持久化隔离**：模组数据保存与读取必须挂载独立命名空间，避免与官服存档产生不可逆的耦合损坏。

---

## 二、已研读模组拆解索引表

| 序号 | 研读报告文件 | 核心技术亮点与查看入口 |
| :--- | :--- | :--- |
| 1 | study_1271089343_your_skeleton_respawn.md | [进入深度拆解报告](./study_1271089343_your_skeleton_respawn.md) |
| 2 | study_1365141672_too_many_items_plus.md | [进入深度拆解报告](./study_1365141672_too_many_items_plus.md) |
| 3 | study_1530801499_fast_travel_gui.md | [进入深度拆解报告](./study_1530801499_fast_travel_gui.md) |
| 4 | study_1595631294_smart_minisign.md | [进入深度拆解报告](./study_1595631294_smart_minisign.md) |
| 5 | study_2287303119_use_beta2.md | [进入深度拆解报告](./study_2287303119_use_beta2.md) |
| 6 | study_2525856394_burning_timer.md | [进入深度拆解报告](./study_2525856394_burning_timer.md) |
| 7 | study_2753774601_button_can_be_moved.md | [进入深度拆解报告](./study_2753774601_button_can_be_moved.md) |
| 8 | study_2795130977_abigail_pro_max_t_pluscup.md | [进入深度拆解报告](./study_2795130977_abigail_pro_max_t_pluscup.md) |
| 9 | study_3007715893_null.md | [进入深度拆解报告](./study_3007715893_null.md) |
| 10 | study_3050607025_emptynull.md | [进入深度拆解报告](./study_3050607025_emptynull.md) |
| 11 | study_3138571948_showplayersoptions.md | [进入深度拆解报告](./study_3138571948_showplayersoptions.md) |
| 12 | study_3210660797_fabin.md | [进入深度拆解报告](./study_3210660797_fabin.md) |
| 13 | study_3320235585_3320235585.md | [进入深度拆解报告](./study_3320235585_3320235585.md) |
| 14 | study_3342856488_sister_save_me.md | [进入深度拆解报告](./study_3342856488_sister_save_me.md) |
| 15 | study_3359995816_workshop_mod_3359995816.md | [进入深度拆解报告](./study_3359995816_workshop_mod_3359995816.md) |
| 16 | study_3371086303_fx_sound.md | [进入深度拆解报告](./study_3371086303_fx_sound.md) |
| 17 | study_3383078008_null.md | [进入深度拆解报告](./study_3383078008_null.md) |
| 18 | study_3430329066_3430329066.md | [进入深度拆解报告](./study_3430329066_3430329066.md) |
| 19 | study_3448135812_3448135812.md | [进入深度拆解报告](./study_3448135812_3448135812.md) |
| 20 | study_3597024951_workshop_mod_3597024951.md | [进入深度拆解报告](./study_3597024951_workshop_mod_3597024951.md) |
| 21 | study_3608400298_3608400298.md | [进入深度拆解报告](./study_3608400298_3608400298.md) |
| 22 | study_361994110_bee_nice.md | [进入深度拆解报告](./study_361994110_bee_nice.md) |
| 23 | study_362175979_wormhole_marks.md | [进入深度拆解报告](./study_362175979_wormhole_marks.md) |
| 24 | study_3638290455_too_many_items_rearranged.md | [进入深度拆解报告](./study_3638290455_too_many_items_rearranged.md) |
| 25 | study_3686629497_3686629497.md | [进入深度拆解报告](./study_3686629497_3686629497.md) |
| 26 | study_3746961192_volt_the_bun_evolent.md | [进入深度拆解报告](./study_3746961192_volt_the_bun_evolent.md) |
| 27 | study_3749566829_enable_condition_restriction.md | [进入深度拆解报告](./study_3749566829_enable_condition_restriction.md) |
| 28 | study_3760349961_workshop_mod_3760349961.md | [进入深度拆解报告](./study_3760349961_workshop_mod_3760349961.md) |
| 29 | study_3785241953_3785241953.md | [进入深度拆解报告](./study_3785241953_3785241953.md) |
| 30 | study_3800454247_enable_hitsound.md | [进入深度拆解报告](./study_3800454247_enable_hitsound.md) |
| 31 | study_380423963_mineable_gems.md | [进入深度拆解报告](./study_380423963_mineable_gems.md) |
| 32 | study_3807721041_3807721041.md | [进入深度拆解报告](./study_3807721041_3807721041.md) |
| 33 | study_3816314599_3816314599.md | [进入深度拆解报告](./study_3816314599_3816314599.md) |
| 34 | study_3817210465_3817210465.md | [进入深度拆解报告](./study_3817210465_3817210465.md) |
| 35 | study_3821655636_charlie_puke_rainbow.md | [进入深度拆解报告](./study_3821655636_charlie_puke_rainbow.md) |
| 36 | study_3822288190_hwei.md | [进入深度拆解报告](./study_3822288190_hwei.md) |
| 37 | study_3822763111_3822763111.md | [进入深度拆解报告](./study_3822763111_3822763111.md) |
| 38 | study_3824225798_slime.md | [进入深度拆解报告](./study_3824225798_slime.md) |
| 39 | study_3824677445_pugalisk_hp_multiplier.md | [进入深度拆解报告](./study_3824677445_pugalisk_hp_multiplier.md) |
| 40 | study_3824691743_take_out_eternal.md | [进入深度拆解报告](./study_3824691743_take_out_eternal.md) |
| 41 | study_3825200629_willow.md | [进入深度拆解报告](./study_3825200629_willow.md) |
| 42 | study_3825256021_hydrogemmy.md | [进入深度拆解报告](./study_3825256021_hydrogemmy.md) |
| 43 | study_3825722696_base_protection.md | [进入深度拆解报告](./study_3825722696_base_protection.md) |
| 44 | study_3826081908_yuesart.md | [进入深度拆解报告](./study_3826081908_yuesart.md) |
| 45 | study_3826208788_telebrella_map_select_portasol_com_mapa.md | [进入深度拆解报告](./study_3826208788_telebrella_map_select_portasol_com_mapa.md) |
| 46 | study_3826703014_that.md | [进入深度拆解报告](./study_3826703014_that.md) |
| 47 | study_3826753623_3826753623.md | [进入深度拆解报告](./study_3826753623_3826753623.md) |
| 48 | study_3826855460_3826855460.md | [进入深度拆解报告](./study_3826855460_3826855460.md) |
| 49 | study_3826859046_oracle_series.md | [进入深度拆解报告](./study_3826859046_oracle_series.md) |
| 50 | study_3827072959_compat_fixer.md | [进入深度拆解报告](./study_3827072959_compat_fixer.md) |
| 51 | study_3827105000_3827105000.md | [进入深度拆解报告](./study_3827105000_3827105000.md) |
| 52 | study_3827498134_where_you_are_plus.md | [进入深度拆解报告](./study_3827498134_where_you_are_plus.md) |
| 53 | study_3827532311_3827532311.md | [进入深度拆解报告](./study_3827532311_3827532311.md) |
| 54 | study_3827533681_warm_lantern.md | [进入深度拆解报告](./study_3827533681_warm_lantern.md) |
| 55 | study_3827681772_bulingbuling.md | [进入深度拆解报告](./study_3827681772_bulingbuling.md) |
| 56 | study_3827725768_togglekey.md | [进入深度拆解报告](./study_3827725768_togglekey.md) |
| 57 | study_3828142639_3828142639.md | [进入深度拆解报告](./study_3828142639_3828142639.md) |
| 58 | study_3828144951_workshop_mod_3828144951.md | [进入深度拆解报告](./study_3828144951_workshop_mod_3828144951.md) |
| 59 | study_3828853206_3828853206.md | [进入深度拆解报告](./study_3828853206_3828853206.md) |
| 60 | study_3828892015_mainline_guidebook.md | [进入深度拆解报告](./study_3828892015_mainline_guidebook.md) |
| 61 | study_3829345300_3829345300.md | [进入深度拆解报告](./study_3829345300_3829345300.md) |
| 62 | study_3829366302_3829366302.md | [进入深度拆解报告](./study_3829366302_3829366302.md) |
| 63 | study_3829943273_3829943273.md | [进入深度拆解报告](./study_3829943273_3829943273.md) |
| 64 | study_3830086941_workshop_mod_3830086941.md | [进入深度拆解报告](./study_3830086941_workshop_mod_3830086941.md) |
| 65 | study_3830355416_3830355416.md | [进入深度拆解报告](./study_3830355416_3830355416.md) |
| 66 | study_458940297_food_values_item_tooltips.md | [进入深度拆解报告](./study_458940297_food_values_item_tooltips.md) |
| 67 | study_462434129_restart.md | [进入深度拆解报告](./study_462434129_restart.md) |
| 68 | study_569043634_campfire_respawn.md | [进入深度拆解报告](./study_569043634_campfire_respawn.md) |
| 69 | study_727774324_craft_pot.md | [进入深度拆解报告](./study_727774324_craft_pot.md) |

---

*持续同步更新中，由 8 并发工坊研读流水线动态归纳注入。*
