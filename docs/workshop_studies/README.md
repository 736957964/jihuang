# 饥荒联机版（DST）创意工坊权威模组研读全景知识库

本专栏由 **自动化工坊研读流水线** 持续驱动生成，提供兼具**技术深度、架构解构、避坑指南、生产级底层精髓**的全面实战参考。

> 📊 **全量研读统计**：已累计完成深度研读并分类归纳 **206** 个工坊 MOD！
> 🎯 **功能导向查阅**：按照老爹权威指示，文档全面转向**【按功能体系分类查阅】**，每个专题均横向提炼了**生产级精髓、底层代码模式与避坑守则**，跳过纯数值水文档，直达硬核干货！

---

## 🗂️ 八大核心功能技术专题与全景综述入口

| 分类目录 | 领域类别 | 收录模组数 | 核心架构精髓与索引入口 |
| :--- | :--- | :--- | :--- |
| [`01_UI与HUD界面渲染体系/`](./01_UI与HUD界面渲染体系/) | **UI与HUD界面渲染体系** | 17 个 | [👉 进入《UI与HUD界面渲染体系全景综述与精髓速查》](./01_UI与HUD界面渲染体系/README.md) |
| [`02_StateGraph动作拦截与状态机机制/`](./02_StateGraph动作拦截与状态机机制/) | **StateGraph动作拦截与动作优先级机制** | 7 个 | [👉 进入《StateGraph动作拦截与动作优先级机制全景综述与精髓速查》](./02_StateGraph动作拦截与状态机机制/README.md) |
| [`03_网络通信RPC与专有协议体系/`](./03_网络通信RPC与专有协议体系/) | **网络通信RPC与专有数据同步体系** | 7 个 | [👉 进入《网络通信RPC与专有数据同步体系全景综述与精髓速查》](./03_网络通信RPC与专有协议体系/README.md) |
| [`04_物品容器与大容量网络拓扑/`](./04_物品容器与大容量网络拓扑/) | **物品容器与大容量网络拓扑** | 13 个 | [👉 进入《物品容器与大容量网络拓扑全景综述与精髓速查》](./04_物品容器与大容量网络拓扑/README.md) |
| [`05_Boss战斗与复杂AI决策行为树/`](./05_Boss战斗与复杂AI决策行为树/) | **Boss战斗与复杂AI行为树机制** | 3 个 | [👉 进入《Boss战斗与复杂AI行为树机制全景综述与精髓速查》](./05_Boss战斗与复杂AI决策行为树/README.md) |
| [`06_世界生成与大型生态扩展/`](./06_世界生成与大型生态扩展/) | **世界生成与大型生态扩展** | 7 个 | [👉 进入《世界生成与大型生态扩展全景综述与精髓速查》](./06_世界生成与大型生态扩展/README.md) |
| [`07_文本动态本地化与字体管线/`](./07_文本动态本地化与字体管线/) | **文本动态本地化与字体渲染管线** | 7 个 | [👉 进入《文本动态本地化与字体渲染管线全景综述与精髓速查》](./07_文本动态本地化与字体管线/README.md) |
| [`08_特效渲染与环境机制调整/`](./08_特效渲染与环境机制调整/) | **特效视觉渲染与环境机制调整** | 99 个 | [👉 进入《特效视觉渲染与环境机制调整全景综述与精髓速查》](./08_特效渲染与环境机制调整/README.md) |

---

## 📑 全量功能专题模组拆解索引（直接点击查看）

### 🔹 UI与HUD界面渲染体系（共 17 个）
> 💡 **核心精髓**：动态血条、状态信息、雷达小地图、轮盘菜单等界面层架构与防崩溃时序 [👉 查看该专题核心精髓总结报告](./01_UI与HUD界面渲染体系/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_1185229307_epic_healthbar.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_1185229307_epic_healthbar.md) |
| 2 | `study_1185229307_food_values_display.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_1185229307_food_values_display.md) |
| 3 | `study_1207269058_simple_health_bar_dst.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_1207269058_simple_health_bar_dst.md) |
| 4 | `study_1207269292_simple_health_bar_server.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_1207269292_simple_health_bar_server.md) |
| 5 | `study_1595631294_epic_healthbar.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_1595631294_epic_healthbar.md) |
| 6 | `study_2438350724_combined_status.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_2438350724_combined_status.md) |
| 7 | `study_2477889104_beefalo_status_bar.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_2477889104_beefalo_status_bar.md) |
| 8 | `study_2849308125_ui_display.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_2849308125_ui_display.md) |
| 9 | `study_2968760008_mudrock_health.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_2968760008_mudrock_health.md) |
| 10 | `study_343753877_status_announcements.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_343753877_status_announcements.md) |
| 11 | `study_347079953_display_food_values.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_347079953_display_food_values.md) |
| 12 | `study_352373173_gesture_wheel.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_352373173_gesture_wheel.md) |
| 13 | `study_375859599_health_info.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_375859599_health_info.md) |
| 14 | `study_3807703087_alignment_plus.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_3807703087_alignment_plus.md) |
| 15 | `study_3823823620_rosen_target_health_bar.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_3823823620_rosen_target_health_bar.md) |
| 16 | `study_3826562793_mudrock_health.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_3826562793_mudrock_health.md) |
| 17 | `study_836583293_item_info.md` | [👉 查看源码剖析](./01_UI与HUD界面渲染体系/study_836583293_item_info.md) |

### 🔹 StateGraph动作拦截与动作优先级机制（共 7 个）
> 💡 **核心精髓**：角色与生物动作替换、ActionQueue、动作流水线与BufferedAction调度 [👉 查看该专题核心精髓总结报告](./02_StateGraph动作拦截与状态机机制/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_1608191708_action_queue_reborn.md` | [👉 查看源码剖析](./02_StateGraph动作拦截与状态机机制/study_1608191708_action_queue_reborn.md) |
| 2 | `study_2302837868_snapping_tills.md` | [👉 查看源码剖析](./02_StateGraph动作拦截与状态机机制/study_2302837868_snapping_tills.md) |
| 3 | `study_2841310635_proper_switching.md` | [👉 查看源码剖析](./02_StateGraph动作拦截与状态机机制/study_2841310635_proper_switching.md) |
| 4 | `study_2873533916_actionqueue_rb3.md` | [👉 查看源码剖析](./02_StateGraph动作拦截与状态机机制/study_2873533916_actionqueue_rb3.md) |
| 5 | `study_3018652965_actionqueue_rb3.md` | [👉 查看源码剖析](./02_StateGraph动作拦截与状态机机制/study_3018652965_actionqueue_rb3.md) |
| 6 | `study_3830601380_actionqueue_rb3.md` | [👉 查看源码剖析](./02_StateGraph动作拦截与状态机机制/study_3830601380_actionqueue_rb3.md) |
| 7 | `study_501385076_quick_pick.md` | [👉 查看源码剖析](./02_StateGraph动作拦截与状态机机制/study_501385076_quick_pick.md) |

### 🔹 网络通信RPC与专有数据同步体系（共 7 个）
> 💡 **核心精髓**：跨端数据同步、全球定位、Show Me、按位压缩与带宽防爆 [👉 查看该专题核心精髓总结报告](./03_网络通信RPC与专有协议体系/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_2189004162_insight.md` | [👉 查看源码剖析](./03_网络通信RPC与专有协议体系/study_2189004162_insight.md) |
| 2 | `study_2281925291_finder_redux.md` | [👉 查看源码剖析](./03_网络通信RPC与专有协议体系/study_2281925291_finder_redux.md) |
| 3 | `study_2657513551_global_positions_fix.md` | [👉 查看源码剖析](./03_网络通信RPC与专有协议体系/study_2657513551_global_positions_fix.md) |
| 4 | `study_378160973_global_positions.md` | [👉 查看源码剖析](./03_网络通信RPC与专有协议体系/study_378160973_global_positions.md) |
| 5 | `study_3830062049_container_lag_fix.md` | [👉 查看源码剖析](./03_网络通信RPC与专有协议体系/study_3830062049_container_lag_fix.md) |
| 6 | `study_666155465_show_me.md` | [👉 查看源码剖析](./03_网络通信RPC与专有协议体系/study_666155465_show_me.md) |
| 7 | `study_758532836_insight_protocol.md` | [👉 查看源码剖析](./03_网络通信RPC与专有协议体系/study_758532836_insight_protocol.md) |

### 🔹 物品容器与大容量网络拓扑（共 13 个）
> 💡 **核心精髓**：超大背包、多格箱子、大堆叠、专属收纳与Container网络变量 [👉 查看该专题核心精髓总结报告](./04_物品容器与大容量网络拓扑/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_1240565842_russification_pack_for_dst.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_1240565842_russification_pack_for_dst.md) |
| 2 | `study_3624411781_storage_bags.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_3624411781_storage_bags.md) |
| 3 | `study_367546858_chinese_pack.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_367546858_chinese_pack.md) |
| 4 | `study_374550642_increased_stack_size.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_374550642_increased_stack_size.md) |
| 5 | `study_375850593_extra_equip_slots.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_375850593_extra_equip_slots.md) |
| 6 | `study_382177939_storm_cellar.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_382177939_storm_cellar.md) |
| 7 | `study_3825146333_maxstack.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_3825146333_maxstack.md) |
| 8 | `study_3825332710_dst_sophisticated_backpacks_v0_5_6_5.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_3825332710_dst_sophisticated_backpacks_v0_5_6_5.md) |
| 9 | `study_3827133829_stack_food.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_3827133829_stack_food.md) |
| 10 | `study_3830221580_upgradeable_backpacks.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_3830221580_upgradeable_backpacks.md) |
| 11 | `study_3830466017_extra_equip_slots_no_li_updated.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_3830466017_extra_equip_slots_no_li_updated.md) |
| 12 | `study_3830575143_item_slot_reservation.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_3830575143_item_slot_reservation.md) |
| 13 | `study_786556008_45_inventory_slots.md` | [👉 查看源码剖析](./04_物品容器与大容量网络拓扑/study_786556008_45_inventory_slots.md) |

### 🔹 Boss战斗与复杂AI行为树机制（共 3 个）
> 💡 **核心精髓**：首领怪行为树(Brain)、动态索敌、阶段性技能狂暴与范围判定 [👉 查看该专题核心精髓总结报告](./05_Boss战斗与复杂AI决策行为树/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_2795130977_abigail_pro_max_t_pluscup.md` | [👉 查看源码剖析](./05_Boss战斗与复杂AI决策行为树/study_2795130977_abigail_pro_max_t_pluscup.md) |
| 2 | `study_3824225798_slime.md` | [👉 查看源码剖析](./05_Boss战斗与复杂AI决策行为树/study_3824225798_slime.md) |
| 3 | `study_3824677445_pugalisk_hp_multiplier.md` | [👉 查看源码剖析](./05_Boss战斗与复杂AI决策行为树/study_3824677445_pugalisk_hp_multiplier.md) |

### 🔹 世界生成与大型生态扩展（共 7 个）
> 💡 **核心精髓**：海难/群岛世界、冬原、独立地形生成(WorldGen)与水域物理载具 [👉 查看该专题核心精髓总结报告](./06_世界生成与大型生态扩展/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_1467214795_island_adventures.md` | [👉 查看源码剖析](./06_世界生成与大型生态扩展/study_1467214795_island_adventures.md) |
| 2 | `study_3322803908_above_the_clouds.md` | [👉 查看源码剖析](./06_世界生成与大型生态扩展/study_3322803908_above_the_clouds.md) |
| 3 | `study_3350705530_limbus_company_characters.md` | [👉 查看源码剖析](./06_世界生成与大型生态扩展/study_3350705530_limbus_company_characters.md) |
| 4 | `study_3383047161_the_winterlands.md` | [👉 查看源码剖析](./06_世界生成与大型生态扩展/study_3383047161_the_winterlands.md) |
| 5 | `study_3513671528_plants_vs_dst.md` | [👉 查看源码剖析](./06_世界生成与大型生态扩展/study_3513671528_plants_vs_dst.md) |
| 6 | `study_3583633595_the_fun_gang_deltarune.md` | [👉 查看源码剖析](./06_世界生成与大型生态扩展/study_3583633595_the_fun_gang_deltarune.md) |
| 7 | `study_3828900356_wuthering_waves_aemeath_expansion.md` | [👉 查看源码剖析](./06_世界生成与大型生态扩展/study_3828900356_wuthering_waves_aemeath_expansion.md) |

### 🔹 文本动态本地化与字体渲染管线（共 7 个）
> 💡 **核心精髓**：多语言包、PO文件解析、动态字符串注入与字体闭包劫持 [👉 查看该专题核心精髓总结报告](./07_文本动态本地化与字体管线/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_1418746242_chinese_plus_plus.md` | [👉 查看源码剖析](./07_文本动态本地化与字体管线/study_1418746242_chinese_plus_plus.md) |
| 2 | `study_1991746508_myth_words_architecture.md` | [👉 查看源码剖析](./07_文本动态本地化与字体管线/study_1991746508_myth_words_architecture.md) |
| 3 | `study_3353852416_ch_lang.md` | [👉 查看源码剖析](./07_文本动态本地化与字体管线/study_3353852416_ch_lang.md) |
| 4 | `study_3810943420_language.md` | [👉 查看源码剖析](./07_文本动态本地化与字体管线/study_3810943420_language.md) |
| 5 | `study_3828123641_language.md` | [👉 查看源码剖析](./07_文本动态本地化与字体管线/study_3828123641_language.md) |
| 6 | `study_3828782842_language.md` | [👉 查看源码剖析](./07_文本动态本地化与字体管线/study_3828782842_language.md) |
| 7 | `study_3828925092_gd_language.md` | [👉 查看源码剖析](./07_文本动态本地化与字体管线/study_3828925092_gd_language.md) |

### 🔹 特效视觉渲染与环境机制调整（共 99 个）
> 💡 **核心精髓**：打击音效、全屏着色、照明光源、环境监听与基础玩法调整 [👉 查看该专题核心精髓总结报告](./08_特效渲染与环境机制调整/README.md)

| 序号 | 模组研读文件 | 深度拆解快速跳转 |
| :--- | :--- | :--- |
| 1 | `study_1530801499_fast_travel_gui.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_1530801499_fast_travel_gui.md) |
| 2 | `study_1595631294_smart_minisign.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_1595631294_smart_minisign.md) |
| 3 | `study_2287303119_use_beta2.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_2287303119_use_beta2.md) |
| 4 | `study_2525856394_burning_timer.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_2525856394_burning_timer.md) |
| 5 | `study_2995399263_orange.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_2995399263_orange.md) |
| 6 | `study_3007715893_null.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3007715893_null.md) |
| 7 | `study_3050607025_emptynull.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3050607025_emptynull.md) |
| 8 | `study_3138571948_showplayersoptions.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3138571948_showplayersoptions.md) |
| 9 | `study_3320235585_3320235585.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3320235585_3320235585.md) |
| 10 | `study_3342856488_sister_save_me.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3342856488_sister_save_me.md) |
| 11 | `study_3371086303_fx_sound.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3371086303_fx_sound.md) |
| 12 | `study_3383078008_null.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3383078008_null.md) |
| 13 | `study_3597024951_workshop_mod_3597024951.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3597024951_workshop_mod_3597024951.md) |
| 14 | `study_3608400298_3608400298.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3608400298_3608400298.md) |
| 15 | `study_361994110_bee_nice.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_361994110_bee_nice.md) |
| 16 | `study_362175979_wormhole_marks.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_362175979_wormhole_marks.md) |
| 17 | `study_3638290455_too_many_items_rearranged.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3638290455_too_many_items_rearranged.md) |
| 18 | `study_3686629497_3686629497.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3686629497_3686629497.md) |
| 19 | `study_3746961192_volt_the_bun_evolent.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3746961192_volt_the_bun_evolent.md) |
| 20 | `study_3760349961_workshop_mod_3760349961.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3760349961_workshop_mod_3760349961.md) |
| 21 | `study_3785241953_3785241953.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3785241953_3785241953.md) |
| 22 | `study_3788634380_shadow_maul_plus.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3788634380_shadow_maul_plus.md) |
| 23 | `study_3800454247_enable_hitsound.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3800454247_enable_hitsound.md) |
| 24 | `study_3803593563_3803593563.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3803593563_3803593563.md) |
| 25 | `study_380423963_mineable_gems.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_380423963_mineable_gems.md) |
| 26 | `study_3807021979_dst.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3807021979_dst.md) |
| 27 | `study_3814479332_workshop_mod_3814479332.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3814479332_workshop_mod_3814479332.md) |
| 28 | `study_3816296964_zodiac_talismans.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3816296964_zodiac_talismans.md) |
| 29 | `study_3816314599_3816314599.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3816314599_3816314599.md) |
| 30 | `study_3817131769_3817131769.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3817131769_3817131769.md) |
| 31 | `study_3817210465_3817210465.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3817210465_3817210465.md) |
| 32 | `study_3819792555_cold_mode.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3819792555_cold_mode.md) |
| 33 | `study_3820595913_rework_king.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3820595913_rework_king.md) |
| 34 | `study_3820619234_rework_queen.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3820619234_rework_queen.md) |
| 35 | `study_3821465478_3821465478.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3821465478_3821465478.md) |
| 36 | `study_3822124366_dst.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3822124366_dst.md) |
| 37 | `study_3822288190_hwei.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3822288190_hwei.md) |
| 38 | `study_3822759369_3822759369.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3822759369_3822759369.md) |
| 39 | `study_3822763111_3822763111.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3822763111_3822763111.md) |
| 40 | `study_3823867907_cultivable_weeds.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3823867907_cultivable_weeds.md) |
| 41 | `study_3824347195_dj.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3824347195_dj.md) |
| 42 | `study_3824691743_take_out_eternal.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3824691743_take_out_eternal.md) |
| 43 | `study_3825063665_3825063665.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3825063665_3825063665.md) |
| 44 | `study_3825176050_invincible_buildings_player_edition.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3825176050_invincible_buildings_player_edition.md) |
| 45 | `study_3825200629_willow.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3825200629_willow.md) |
| 46 | `study_3825256021_hydrogemmy.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3825256021_hydrogemmy.md) |
| 47 | `study_3825722696_base_protection.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3825722696_base_protection.md) |
| 48 | `study_3825980716_3825980716.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3825980716_3825980716.md) |
| 49 | `study_3826197611_queen.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3826197611_queen.md) |
| 50 | `study_3826208788_telebrella_map_select_portasol_com_mapa.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3826208788_telebrella_map_select_portasol_com_mapa.md) |
| 51 | `study_3826338483_4_5_6_2798599672_bugfix.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3826338483_4_5_6_2798599672_bugfix.md) |
| 52 | `study_3826703014_that.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3826703014_that.md) |
| 53 | `study_3826855460_3826855460.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3826855460_3826855460.md) |
| 54 | `study_3826859046_oracle_series.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3826859046_oracle_series.md) |
| 55 | `study_3826954880_3826954880.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3826954880_3826954880.md) |
| 56 | `study_3827053397_3827053397.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827053397_3827053397.md) |
| 57 | `study_3827072959_compat_fixer.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827072959_compat_fixer.md) |
| 58 | `study_3827105000_3827105000.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827105000_3827105000.md) |
| 59 | `study_3827130445_random_events.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827130445_random_events.md) |
| 60 | `study_3827498134_where_you_are_plus.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827498134_where_you_are_plus.md) |
| 61 | `study_3827532311_3827532311.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827532311_3827532311.md) |
| 62 | `study_3827537804_starvebucks.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827537804_starvebucks.md) |
| 63 | `study_3827611622_3827611622.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827611622_3827611622.md) |
| 64 | `study_3827681772_bulingbuling.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827681772_bulingbuling.md) |
| 65 | `study_3827702076_3827702076.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827702076_3827702076.md) |
| 66 | `study_3827725768_togglekey.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3827725768_togglekey.md) |
| 67 | `study_3828108612_enable_lazy_explorer.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828108612_enable_lazy_explorer.md) |
| 68 | `study_3828142639_3828142639.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828142639_3828142639.md) |
| 69 | `study_3828144951_workshop_mod_3828144951.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828144951_workshop_mod_3828144951.md) |
| 70 | `study_3828241056_wurt.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828241056_wurt.md) |
| 71 | `study_3828490943_3828490943.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828490943_3828490943.md) |
| 72 | `study_3828742378_3828742378.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828742378_3828742378.md) |
| 73 | `study_3828762672_start_key.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828762672_start_key.md) |
| 74 | `study_3828771908_amount.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828771908_amount.md) |
| 75 | `study_3828863371_3828863371.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3828863371_3828863371.md) |
| 76 | `study_3829104367_3829104367.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3829104367_3829104367.md) |
| 77 | `study_3829345300_3829345300.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3829345300_3829345300.md) |
| 78 | `study_3829443954_gekko_trap_advanced.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3829443954_gekko_trap_advanced.md) |
| 79 | `study_3829641226_3829641226.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3829641226_3829641226.md) |
| 80 | `study_3829645807_range.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3829645807_range.md) |
| 81 | `study_3829943273_3829943273.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3829943273_3829943273.md) |
| 82 | `study_3829996901_stockpile_rat.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3829996901_stockpile_rat.md) |
| 83 | `study_3830086941_workshop_mod_3830086941.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830086941_workshop_mod_3830086941.md) |
| 84 | `study_3830162539_lunar_idle_fix_server.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830162539_lunar_idle_fix_server.md) |
| 85 | `study_3830179607_3830179607.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830179607_3830179607.md) |
| 86 | `study_3830188483_3830188483.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830188483_3830188483.md) |
| 87 | `study_3830216175_3830216175.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830216175_3830216175.md) |
| 88 | `study_3830232103_3830232103.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830232103_3830232103.md) |
| 89 | `study_3830241199_compost_bin_enhanced.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830241199_compost_bin_enhanced.md) |
| 90 | `study_3830251621_3830251621.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830251621_3830251621.md) |
| 91 | `study_3830266557_frog_rain_injury.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830266557_frog_rain_injury.md) |
| 92 | `study_3830318655_everything_chop.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830318655_everything_chop.md) |
| 93 | `study_3830585648_3830585648.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830585648_3830585648.md) |
| 94 | `study_3830597655_null.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_3830597655_null.md) |
| 95 | `study_458940297_food_values_item_tooltips.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_458940297_food_values_item_tooltips.md) |
| 96 | `study_462434129_restart.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_462434129_restart.md) |
| 97 | `study_569043634_campfire_respawn.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_569043634_campfire_respawn.md) |
| 98 | `study_588560555_auto_tooth_trap_reset.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_588560555_auto_tooth_trap_reset.md) |
| 99 | `study_727774324_craft_pot.md` | [👉 查看源码剖析](./08_特效渲染与环境机制调整/study_727774324_craft_pot.md) |

---

*持续更新中，8 并发流水线 24 小时自动巡检工坊榜单并推进。*
