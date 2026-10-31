# 创意工坊权威模组案例速查：Island Adventures (海难联机版 / 1467214795)

> **模组标识**：`1467214795` (Island Adventures - Shipwrecked)  
> **作者**：The Island Adventures Team | **版本**：v1.0.63  
> **地位定位**：全网技术野心与工业深度第一的超大型全量 DLC 移植典范

---

## 🌟 模组核心架构总览

`Island Adventures` 将单机版《海难（Shipwrecked）》完整的海洋群岛生态、造船航行、热带季节与火山机制，**完全按照联机版主客机分离与网络预测规范**进行了工业级重构。

---

## 🧭 该模组贡献的核心技术专卷（点击直达对应知识点）

根据知识库顶层架构规范，该模组拆解出的所有深水区系统已分别归纳至对应系统专题库中，提供完整代码剖析、反例对比、代码骨架与版本断代：

| 技术知识点 | 对应系统专题 | 核心攻坚要点 | 直达专卷文档 |
| :--- | :--- | :--- | :--- |
| **航海物理与船舶操纵** | `10-networking` / `17-standardcomponents` | 载具主客机预测解耦、风帆动力学、法线防穿模 | [👉 查看专卷](/docs/workshop_studies/island_adventures/01_marine_physics_and_locomotion) |
| **潮汐水体与风浪动力学** | `13-world` / `19-fx` | 正弦潮汐时间轴、冲浪与迎角受损、动态水幕 | [👉 查看专卷](/docs/workshop_studies/island_adventures/02_ocean_tides_waves_dynamics) |
| **多世界火山与灾难调度** | `13-world` / `02-components` | 虚拟同图异构坐标舱、四段式陨石预警打击 | [👉 查看专卷](/docs/workshop_studies/island_adventures/03_volcano_world_and_disasters) |
| **跨陆海 Boss 与多阶 SG** | `06-stategraphs` / `07-brains` | 水陆双形态动画切换、从属触手阵列保活 | [👉 查看专卷](/docs/workshop_studies/island_adventures/04_marine_bosses_and_stategraph.md) |
| **群岛世界生成与生态链** | `13-world` / `16-constants` | 无陆桥拓扑生成、海洋深度梯度梯度腐蚀 | [👉 查看专卷](/docs/workshop_studies/island_adventures/05_archipelago_worldgen_biomes) |

---

## 🛠️ 生产级 Skill 沉淀速查
- `anli/skills/skill_workshop_1467214795_Upvalue_Hacker_And_Arrive_Dist.md` (闭包嗅探与越界拾取补丁)
- `anli/skills/skill_workshop_boss_stategraph_and_aggro_system.md` (海战 Boss 多阶段仇恨状态机)
- `anli/skills/skill_workshop_high_perf_wave_spawner_and_gc.md` (高性能海浪生成池)
