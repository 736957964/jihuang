# 网络同步与RPC辅助类模组研读全景综述

> 📊 **本分类收录研读 MOD**：共 **6** 个模组
> 💡 **领域概述**：涵盖全球定位(Global Positions)、Show Me、Insight、Finder等。核心解析 AddClientRPC/AddModRPCHandler、专有数据压缩协议、客户端预测与服务端广播。

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
| 1 | study_2189004162_insight.md | [进入深度拆解报告](docs/workshop_studies/04_网络同步与RPC辅助类/study_2189004162_insight.md) |
| 2 | study_2281925291_finder_redux.md | [进入深度拆解报告](docs/workshop_studies/04_网络同步与RPC辅助类/study_2281925291_finder_redux.md) |
| 3 | study_2657513551_global_positions_fix.md | [进入深度拆解报告](docs/workshop_studies/04_网络同步与RPC辅助类/study_2657513551_global_positions_fix.md) |
| 4 | study_378160973_global_positions.md | [进入深度拆解报告](docs/workshop_studies/04_网络同步与RPC辅助类/study_378160973_global_positions.md) |
| 5 | study_666155465_show_me.md | [进入深度拆解报告](docs/workshop_studies/04_网络同步与RPC辅助类/study_666155465_show_me.md) |
| 6 | study_758532836_insight_protocol.md | [进入深度拆解报告](docs/workshop_studies/04_网络同步与RPC辅助类/study_758532836_insight_protocol.md) |

---

*持续同步更新中，由 8 并发工坊研读流水线动态归纳注入。*
