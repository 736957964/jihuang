# 语言汉化与本地化支持类模组研读全景综述

> 📊 **本分类收录研读 MOD**：共 **7** 个模组
> 💡 **领域概述**：涵盖多语言包、字体动态注入、PO文件流水线与字符串重映射技术。

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
| 1 | study_1418746242_chinese_plus_plus.md | [进入深度拆解报告](docs/workshop_studies/README/study_1418746242_chinese_plus_plus.md) |
| 2 | study_1991746508_language.md | [进入深度拆解报告](docs/workshop_studies/README/study_1991746508_language.md) |
| 3 | study_1991746508_myth_words_architecture.md | [进入深度拆解报告](docs/workshop_studies/README/study_1991746508_myth_words_architecture.md) |
| 4 | study_3353852416_ch_lang.md | [进入深度拆解报告](docs/workshop_studies/README/study_3353852416_ch_lang.md) |
| 5 | study_3810943420_language.md | [进入深度拆解报告](docs/workshop_studies/README/study_3810943420_language.md) |
| 6 | study_3826531367_tradu_o_pt_br_don.md | [进入深度拆解报告](docs/workshop_studies/README/study_3826531367_tradu_o_pt_br_don.md) |
| 7 | study_3828925092_gd_language.md | [进入深度拆解报告](docs/workshop_studies/README/study_3828925092_gd_language.md) |

---

*持续同步更新中，由 8 并发工坊研读流水线动态归纳注入。*
