# Boss战斗与复杂AI行为树机制研读与功能速查

> 📊 **本领域收录标杆模组**：共 **3** 个模组深度解析
> 💡 **领域架构定义**：涵盖首领级怪物行为树(Brain)、仇恨动态索敌、阶段性技能狂暴与范围伤害判定。重点提炼 Brain 优先级节点、Combat:SetRetargetFunction。

---

## 一、核心提炼：生产级底层精髓与可复用代码规范

- 【行为树优先级选择】：利用 PriorityNode 组合 ChaseAndAttack、Wander、Panic 等经典节点
- 【动态仇恨索敌机制】：通过 Combat:SetRetargetFunction(period, fn) 动态计算范围目标威胁度
- 【AOE与物理碰撞盒】：利用 FindEntities + 扇形夹角公式实现高精度打击判定

---

## 二、功能导向：模组深度拆解与实现快速跳转

| 序号 | 研读报告文件 | 核心技术亮点与查看入口 |
| :--- | :--- | :--- |
| 1 | `study_2795130977_abigail_pro_max_t_pluscup.md` | [👉 进入该模组技术拆解](./study_2795130977_abigail_pro_max_t_pluscup.md) |
| 2 | `study_3824225798_slime.md` | [👉 进入该模组技术拆解](./study_3824225798_slime.md) |
| 3 | `study_3824677445_pugalisk_hp_multiplier.md` | [👉 进入该模组技术拆解](./study_3824677445_pugalisk_hp_multiplier.md) |

---

*持续更新中，由 8 并发工坊研读流水线动态归纳注入。*
