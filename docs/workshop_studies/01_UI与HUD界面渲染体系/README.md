# UI与HUD界面渲染体系架构研读与功能速查

> 📊 **本领域收录标杆模组**：共 **20** 个模组深度解析
> 💡 **领域架构定义**：涵盖动态血条、状态信息、雷达小地图、轮盘菜单等界面层架构。重点提炼 Client/PlayerHud 挂载、Widget 层级管理、屏幕适配与防崩溃时序。

---

## 一、核心提炼：生产级底层精髓与可复用代码规范

- 【UI挂载安全时序】：严禁在全局脚本直接创建UI，必须通过 AddPlayerPostInit 监听 inst.HUD ~= nil 或 Hook controls.lua
- 【Widget屏幕自适应】：使用 inst.widget:SetHAnchor(ANCHOR_MIDDLE) 与 SetScaleMode(SCALEMODE_PROPORTIONAL)
- 【性能防卡顿】：大量HUD信息严禁每帧计算，必须绑定事件驱动回调（inst:ListenForEvent）

---

## 二、功能导向：模组深度拆解与实现快速跳转

| 序号 | 研读报告文件 | 核心技术亮点与查看入口 |
| :--- | :--- | :--- |
| 1 | `study_1185229307_epic_healthbar.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_1185229307_epic_healthbar.md) |
| 2 | `study_1185229307_food_values_display.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_1185229307_food_values_display.md) |
| 3 | `study_1207269058_simple_health_bar_dst.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_1207269058_simple_health_bar_dst.md) |
| 4 | `study_1207269292_simple_health_bar_server.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_1207269292_simple_health_bar_server.md) |
| 5 | `study_1595631294_epic_healthbar.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_1595631294_epic_healthbar.md) |
| 6 | `study_2438350724_combined_status.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_2438350724_combined_status.md) |
| 7 | `study_2477889104_beefalo_status_bar.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_2477889104_beefalo_status_bar.md) |
| 8 | `study_2849308125_ui_display.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_2849308125_ui_display.md) |
| 9 | `study_2968760008_mudrock_health.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_2968760008_mudrock_health.md) |
| 10 | `study_343753877_status_announcements.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_343753877_status_announcements.md) |
| 11 | `study_347079953_display_food_values.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_347079953_display_food_values.md) |
| 12 | `study_352373173_gesture_wheel.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_352373173_gesture_wheel.md) |
| 13 | `study_375859599_health_info.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_375859599_health_info.md) |
| 14 | `study_3807703087_alignment_plus.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3807703087_alignment_plus.md) |
| 15 | `study_3823823620_rosen_target_health_bar.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3823823620_rosen_target_health_bar.md) |
| 16 | `study_3824436828_entity_indicators_fixed.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3824436828_entity_indicators_fixed.md) |
| 17 | `study_3826562793_mudrock_health.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3826562793_mudrock_health.md) |
| 18 | `study_3829580550_hud.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3829580550_hud.md) |
| 19 | `study_3830394227_creature_health_modifier.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3830394227_creature_health_modifier.md) |
| 20 | `study_836583293_item_info.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_836583293_item_info.md) |

---

*持续更新中，由 8 并发工坊研读流水线动态归纳注入。*
