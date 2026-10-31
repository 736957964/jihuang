# 世界生成与大型生态机制扩展研读与功能速查

> 📊 **本领域收录标杆模组**：共 **8** 个模组深度解析
> 💡 **领域架构定义**：涵盖海难/群岛世界、冬原、独立地形生成(WorldGen)、独立物理系统与水域载具。重点提炼 地形规则、TaskSet、独立物理碰撞层。

---

## 一、核心提炼：生产级底层精髓与可复用代码规范

- 【WorldGen规则注入】：利用 AddRoom / AddLevel 挂载自定义生物群系与地形房间预制件
- 【物理碰撞掩码】：自定义载具需通过 inst.Physics:SetCollisionMask 实现陆水边界穿越
- 【大型模组解耦】：采用模块化 feature 目录加载，严格遵循组件动态装配机制

---

## 二、功能导向：模组深度拆解与实现快速跳转

| 序号 | 研读报告文件 | 核心技术亮点与查看入口 |
| :--- | :--- | :--- |
| 1 | `study_1467214795_island_adventures.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_1467214795_island_adventures.md) |
| 2 | `study_3322803908_above_the_clouds.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3322803908_above_the_clouds.md) |
| 3 | `study_3350705530_limbus_company_characters.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3350705530_limbus_company_characters.md) |
| 4 | `study_3383047161_the_winterlands.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3383047161_the_winterlands.md) |
| 5 | `study_3513671528_plants_vs_dst.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3513671528_plants_vs_dst.md) |
| 6 | `study_3583633595_the_fun_gang_deltarune.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3583633595_the_fun_gang_deltarune.md) |
| 7 | `study_3828013221_lor_limbus_music.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3828013221_lor_limbus_music.md) |
| 8 | `study_3828900356_wuthering_waves_aemeath_expansion.md` | [👉 进入该模组技术拆解](docs/workshop_studies/README/study_3828900356_wuthering_waves_aemeath_expansion.md) |

---

*持续更新中，由 8 并发工坊研读流水线动态归纳注入。*
