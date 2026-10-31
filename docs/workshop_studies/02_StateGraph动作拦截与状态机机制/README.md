# StateGraph动作拦截与动作优先级机制研读与功能速查

> 📊 **本领域收录标杆模组**：共 **7** 个模组深度解析
> 💡 **领域架构定义**：涵盖角色与生物动作替换、行为队列(ActionQueue)、强制中断与动作优先级。重点提炼 SG 状态注入、ActionHandler、BufferedAction 调度精髓。

---

## 一、核心提炼：生产级底层精髓与可复用代码规范

- 【双端SG一致性】：双端联机模式下必须同时修改 wilson.lua（服务端）与 wilson_client.lua（客户端预表现）
- 【无缝动作替换】：通过 AddStategraphActionHandler 动态注入或覆盖原有动作的 SG 状态跳转
- 【动作流水线调度】：采用 BufferedAction 队列化处理连续交互，在 action:DoAction 完成后自动拉取下个任务

---

## 二、功能导向：模组深度拆解与实现快速跳转

| 序号 | 研读报告文件 | 核心技术亮点与查看入口 |
| :--- | :--- | :--- |
| 1 | `study_1608191708_action_queue_reborn.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_1608191708_action_queue_reborn.md) |
| 2 | `study_2302837868_snapping_tills.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_2302837868_snapping_tills.md) |
| 3 | `study_2841310635_proper_switching.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_2841310635_proper_switching.md) |
| 4 | `study_2873533916_actionqueue_rb3.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_2873533916_actionqueue_rb3.md) |
| 5 | `study_3018652965_actionqueue_rb3.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3018652965_actionqueue_rb3.md) |
| 6 | `study_3830601380_actionqueue_rb3.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3830601380_actionqueue_rb3.md) |
| 7 | `study_501385076_quick_pick.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_501385076_quick_pick.md) |

---

*持续更新中，由 8 并发工坊研读流水线动态归纳注入。*
