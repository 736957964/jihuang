# 饥荒联机版（DST）Mod 开发工程核心规范与底层契约

> 本规范提炼自官方原版生命周期、状态机以及成熟工业级 Mod 实战经验，专为开发者查阅与 Agent 任务执行设计。


---

## 专题：FRAMEWORK 核心规则

# rule · v0.1.1



## RULE-FRAMEWORK-001 — 共享 API 应有可追溯的有限出口和初始化条件。


共享 API 应有可追溯的有限出口和初始化条件。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

共享 API 应有可追溯的有限出口和初始化条件。

### Why

整个可写环境作为 API 会隐藏依赖与覆盖。

### Applies When

模块增多或多人维护。

### Does Not Mean

不是禁止共享工具表或要求引入依赖注入容器。

### Evidence

- [REPORT-R5](<../review-support/reports/SoraFramework_DeepDive_20260928.txt>) · interpretation · 2–5；14–15

### Counterexample

适用边界示例（未作为独立项目证据）：少量稳定、只读式公共工具可简单共享。

### Failure If Violated

顺序依赖、同名覆盖、接口面无控制增长。

### Detection Questions

- 符号在哪里定义，何时可用，谁能写？

### Related Patterns

- [PATTERN-FRAMEWORK-001](../patterns/PATTERN-FRAMEWORK-001.md#pattern-framework-001)

### Related Anti Patterns

- [ANTI-FRAMEWORK-001](../anti-patterns/case001.md#anti-framework-001)

### Origin Round6 Rule

未记录 / null

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- framework
  - hooks
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：无 / 未建立

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-FRAMEWORK-001](../anti-patterns/case001.md#anti-framework-001)

### sources

- [REPORT-R5](<../review-support/reports/SoraFramework_DeepDive_20260928.txt>) · interpretation · 2–5；14–15

### related

- [PATTERN-FRAMEWORK-001](../patterns/PATTERN-FRAMEWORK-001.md#pattern-framework-001)
- [ANTI-FRAMEWORK-001](../anti-patterns/case001.md#anti-framework-001)


---

## 专题：HOOK 核心规则

# rule · v0.1.1



## RULE-HOOK-001 — 先确认原版消费、保存和卸载契约，再扩展接口。


先确认原版消费、保存和卸载契约，再扩展接口。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

先确认原版消费、保存和卸载契约，再扩展接口。

### Why

名称与示意图不能代表真实顺序。

### Applies When

接入已有 API。

### Does Not Mean

不是永远禁止自定义实现。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 9–11；16

### Counterexample

适用边界示例（未作为独立项目证据）：原版确实缺少机制时应写明缺口。

### Failure If Violated

依赖错序、访问已清空组件、材料计划不兼容。

### Detection Questions

- 被调用方如何处理参数/所有权/返回值？

### Related Patterns

- [PATTERN-FRAMEWORK-001](../patterns/PATTERN-FRAMEWORK-001.md#pattern-framework-001)

### Related Anti Patterns

- [ANTI-HOOK-001](../anti-patterns/case001.md#anti-hook-001)

### Origin Round6 Rule

14

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- hooks
  - compatibility
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：无 / 未建立

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-HOOK-001](../anti-patterns/case001.md#anti-hook-001)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 9–11；16

### related

- [PATTERN-FRAMEWORK-001](../patterns/PATTERN-FRAMEWORK-001.md#pattern-framework-001)
- [ANTI-HOOK-001](../anti-patterns/case001.md#anti-hook-001)


## RULE-HOOK-002 — 临时替换必须在异常退出时恢复，并避免覆盖后来的拥有者。


临时替换必须在异常退出时恢复，并避免覆盖后来的拥有者。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

临时替换必须在异常退出时恢复，并避免覆盖后来的拥有者。

### Why

old(...) 抛错会跳过普通赋值恢复。

### Applies When

绕现有调用临时改方法/上下文。

### Does Not Mean

不是每个一次性启动赋值都要可热卸载。

### Evidence

- [REPORT-R5](<../review-support/reports/SoraFramework_DeepDive_20260928.txt>) · interpretation · 12–13

### Counterexample

适用边界示例（未作为独立项目证据）：会话级固定替换可显式声明不可卸载，并仍审查异常。

### Failure If Violated

替换残留、其他 Mod 包装被抹掉。

### Detection Questions

- 恢复时目标仍等于自己装的 wrapper 吗？

### Related Patterns

- [PATTERN-FRAMEWORK-001](../patterns/PATTERN-FRAMEWORK-001.md#pattern-framework-001)

### Related Anti Patterns

- [ANTI-HOOK-001](../anti-patterns/case001.md#anti-hook-001)

### Origin Round6 Rule

未记录 / null

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- hooks
  - compatibility
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：无 / 未建立

### Typed Relations

---

## 专题：LIFE 核心规则

# rule · v0.1.1



## RULE-LIFE-001 — Task、Listener、临时状态和 Hook 都要有可追踪的生命周期 Owner。


Task、Listener、临时状态和 Hook 都要有可追踪的生命周期 Owner。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

Task、Listener、临时状态和 Hook 都要有可追踪的生命周期 Owner。

### Why

短命对象注销不自动清理挂在长命实体上的资源。

### Applies When

绑定玩家、UI、世界服务。

### Does Not Mean

不是实体正常 Remove 后仍需重复手动清所有引擎资源。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 16–17

### Counterexample

适用边界示例（未作为独立项目证据）：任务本来就属于整世界时可持续运行。

### Failure If Violated

旧闭包、旧监听或临时字段继续影响会话。

### Detection Questions

- 注销谁时应取消哪一个句柄？

### Related Patterns

- [PATTERN-NET-001](../patterns/PATTERN-NET-001.md#pattern-net-001)

### Related Anti Patterns

- [ANTI-LIFE-001](../anti-patterns/case001.md#anti-life-001)

### Origin Round6 Rule

13

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- lifecycle
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：无 / 未建立

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-LIFE-001](../anti-patterns/case001.md#anti-life-001)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 16–17

### related

- [PATTERN-NET-001](../patterns/PATTERN-NET-001.md#pattern-net-001)
- [ANTI-LIFE-001](../anti-patterns/case001.md#anti-life-001)


---

## 专题：NET 核心规则

# rule · v0.1.1



## RULE-NET-001 — Client 提交 Intent，服务端决定权威数量/材料。


Client 提交 Intent，服务端决定权威数量/材料。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

Client 提交 Intent，服务端决定权威数量/材料。

### Why

伪造最终余额会跳过合法性检查。

### Applies When

客户端请求影响 gameplay。

### Does Not Mean

不要求所有操作自建 RPC；可复用原版 Action/Builder/Replica。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 4–5；9

### Counterexample

适用边界示例（未作为独立项目证据）：纯本地光效可由客户端决定。

### Failure If Violated

客户端越权设置结果。

### Detection Questions

- 谁根据当前真实状态计算结果？

### Related Patterns

- [PATTERN-NET-001](../patterns/PATTERN-NET-001.md#pattern-net-001)

### Related Anti Patterns

- [ANTI-NET-001](../anti-patterns/case001.md#anti-net-001)

### Origin Round6 Rule

1

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- networking
  - UI
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：- server
  - client

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-NET-001](../anti-patterns/case001.md#anti-net-001)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 4–5；9

### related

- [PATTERN-NET-001](../patterns/PATTERN-NET-001.md#pattern-net-001)
- [ANTI-NET-001](../anti-patterns/case001.md#anti-net-001)


## RULE-NET-002 — Host 快路径应保留与 Remote 相同的业务验证。


Host 快路径应保留与 Remote 相同的业务验证。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

Host 快路径应保留与 Remote 相同的业务验证。

### Why

优化 transport 容易一起绕过 Adapter。

### Applies When

本地直调与远程 Handler 并存。

### Does Not Mean

不是禁止 Host 直调或要求回环网络包。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 4.3；8.1；9

### Counterexample

适用边界示例（未作为独立项目证据）：纯本地 UI 不涉及服务端权限。

### Failure If Violated

Host 正常而 Remote 拒绝，或权限条件不同。

### Detection Questions

- 两条路径在哪里汇合验证？

### Related Patterns

- [PATTERN-NET-001](../patterns/PATTERN-NET-001.md#pattern-net-001)

### Related Anti Patterns

- [ANTI-NET-001](../anti-patterns/case001.md#anti-net-001)

### Origin Round6 Rule

5

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- networking
  - UI
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：- server
  - client

---

## 专题：PERSIST 核心规则

# rule · v0.1.1



## RULE-PERSIST-001 — 可从真实实体重建的 Registry/Cache 通常不独立持久化。


可从真实实体重建的 Registry/Cache 通常不独立持久化。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

可从真实实体重建的 Registry/Cache 通常不独立持久化。

### Why

保存两份关联需修复 GUID 与初始化顺序。

### Applies When

派生实体注册表、候选缓存。

### Does Not Mean

不能把用户选择/进度一律归类成缓存丢弃。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 7；15–16

### Counterexample

适用边界示例（未作为独立项目证据）：跨重启必须保留的排程/租约需单独设计保存。

### Failure If Violated

读档遗留失效引用或丢失不可重建意图。

### Detection Questions

- 这是重算能等价恢复，还是只重置默认？

### Related Patterns

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)

### Related Anti Patterns

- [ANTI-LIFE-001](../anti-patterns/case001.md#anti-life-001)

### Origin Round6 Rule

9

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- persistence
  - lifecycle
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：无 / 未建立

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-LIFE-001](../anti-patterns/case001.md#anti-life-001)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 7；15–16

### related

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)
- [ANTI-LIFE-001](../anti-patterns/case001.md#anti-life-001)


---

## 专题：RESOURCE 核心规则

# rule · v0.1.1



## RULE-RESOURCE-001 — 多个资源 Provider 必须按实体身份和剩余预算组合。


多个资源 Provider 必须按实体身份和剩余预算组合。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

多个资源 Provider 必须按实体身份和剩余预算组合。

### Why

同一实体可以从多个来源被发现。

### Applies When

合并多个 Entity→amount 查询结果。

### Does Not Mean

不是简单把重复项改成相加就修好。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 11.3

### Counterexample

适用边界示例（未作为独立项目证据）：证明来源集合互斥时可直接组合。

### Failure If Violated

重复预算或覆盖已分配数量而少扣材料。

### Detection Questions

- Provider B 知道 A 已分配哪些实体多少吗？

### Related Patterns

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)

### Related Anti Patterns

- [ANTI-RESOURCE-001](../anti-patterns/case001.md#anti-resource-001)

### Origin Round6 Rule

10

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- world
  - resources
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：- server

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-RESOURCE-001](../anti-patterns/case001.md#anti-resource-001)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 11.3

### related

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)
- [ANTI-RESOURCE-001](../anti-patterns/case001.md#anti-resource-001)


## RULE-RESOURCE-002 — Query/分配建议不等于 reservation 或扣款。


Query/分配建议不等于 reservation 或扣款。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

Query/分配建议不等于 reservation 或扣款。

### Why

查询到执行之间可以有排队和同步回调。

### Applies When

延后执行、回调可变或共享资源。

### Does Not Mean

不是断言 Lua 每行会被其他任务抢占。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 10.3；11.4

### Counterexample

适用边界示例（未作为独立项目证据）：无回调、无让出且立即执行的小操作可保持简单。

### Failure If Violated

旧计划被当作承诺，扣款失败无补偿。

### Detection Questions

- 执行前还有哪些状态变化点？

### Related Patterns

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)

### Related Anti Patterns

- [ANTI-RESOURCE-001](../anti-patterns/case001.md#anti-resource-001)

### Origin Round6 Rule

11

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- world
  - resources
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：- server

### Typed Relations

---

## 专题：SHARD 核心规则

# rule · v0.1.1



## RULE-SHARD-001 — 跨 Shard 稀缺资源应先定义写入权威和冲突语义。


跨 Shard 稀缺资源应先定义写入权威和冲突语义。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

跨 Shard 稀缺资源应先定义写入权威和冲突语义。

### Why

基于同一旧值的完整 Set 会覆盖并行修改。

### Applies When

共享库存、积分等需要守恒。

### Does Not Mean

不等于任何广播完整值都错误。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 6–7

### Counterexample

适用边界示例（未作为独立项目证据）：唯一写者广播可覆盖的显示配置通常合理。

### Failure If Violated

丢更新、余额分歧、合计超提。

### Detection Questions

- 操作是 delta 还是最终值？谁能拒绝旧写？

### Related Patterns

- [PATTERN-SHARD-001](../patterns/PATTERN-SHARD-001.md#pattern-shard-001)

### Related Anti Patterns

- [ANTI-SHARD-002](../anti-patterns/case001.md#anti-shard-002)

### Origin Round6 Rule

7

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- shard
  - networking
  - state
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：- server
  - client
  - shard

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-SHARD-002](../anti-patterns/case001.md#anti-shard-002)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 6–7

### related

- [PATTERN-SHARD-001](../patterns/PATTERN-SHARD-001.md#pattern-shard-001)
- [ANTI-SHARD-002](../anti-patterns/case001.md#anti-shard-002)


---

## 专题：STATE 核心规则

# rule · v0.1.1



## RULE-STATE-001 — 每个状态写清“相对于谁权威”。


每个状态写清“相对于谁权威”。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

每个状态写清“相对于谁权威”。

### Why

客户端权威边界不等于 Shard 间一致性。

### Applies When

多端或多分片状态。

### Does Not Mean

不是所有数据都需要主世界集中持有。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 3；7

### Counterexample

适用边界示例（未作为独立项目证据）：互不共享的每世界天气配置可各自权威。

### Failure If Violated

把多个可写副本误当唯一账本。

### Detection Questions

- 谁能写？离线副本还能写吗？

### Related Patterns

- [PATTERN-SHARD-001](../patterns/PATTERN-SHARD-001.md#pattern-shard-001)

### Related Anti Patterns

- [ANTI-SHARD-002](../anti-patterns/case001.md#anti-shard-002)

### Origin Round6 Rule

2

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- state
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：无 / 未建立

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-SHARD-002](../anti-patterns/case001.md#anti-shard-002)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 3；7

### related

- [PATTERN-SHARD-001](../patterns/PATTERN-SHARD-001.md#pattern-shard-001)
- [ANTI-SHARD-002](../anti-patterns/case001.md#anti-shard-002)


## RULE-STATE-002 — 分别记录 Owner、Server View、Client Cache 和 Display。


分别记录 Owner、Server View、Client Cache 和 Display。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

分别记录 Owner、Server View、Client Cache 和 Display。

### Why

相同键名不代表相同存储职责。

### Applies When

有映射/缓存/界面的业务。

### Does Not Mean

不是强迫每层各建一个类或复制一份数据。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 3；5

### Counterexample

适用边界示例（未作为独立项目证据）：小业务可直接读取已有 Replica。

### Failure If Violated

UI 或副本被当作保存真相。

### Detection Questions

- View 是函数还是一份副本？

### Related Patterns

- [PATTERN-NET-001](../patterns/PATTERN-NET-001.md#pattern-net-001)

### Related Anti Patterns

- [ANTI-FRAMEWORK-001](../anti-patterns/case001.md#anti-framework-001)

### Origin Round6 Rule

3

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- state
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：无 / 未建立

### Typed Relations

1. **type**：mitigates

---

## 专题：WORLD 核心规则

# rule · v0.1.1



## RULE-WORLD-001 — 真实物品留给 Container/Item；Manager 可持有成员和候选。


真实物品留给 Container/Item；Manager 可持有成员和候选。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

真实物品留给 Container/Item；Manager 可持有成员和候选。

### Why

重复库存账本增加一致性责任。

### Applies When

世界级实体查询和协调。

### Does Not Mean

不是禁止经测量后维护数量索引。

### Evidence

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 10.2–10.4

### Counterexample

适用边界示例（未作为独立项目证据）：大量高频聚合可用有明确失效协议的索引。

### Failure If Violated

Manager 数字与实际实体分离。

### Detection Questions

- 查询读的是当前 Stack 还是另存的数量？

### Related Patterns

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)

### Related Anti Patterns

- [ANTI-WORLD-001](../anti-patterns/case001.md#anti-world-001)

### Origin Round6 Rule

8

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- world
  - lifecycle
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：- server

### Typed Relations

1. **type**：mitigates
   - **target**：[ANTI-WORLD-001](../anti-patterns/case001.md#anti-world-001)

### sources

- [REPORT-R6](<../review-support/reports/SoraBusinessIntegration_20260928.txt>) · interpretation · 10.2–10.4

### related

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)
- [ANTI-WORLD-001](../anti-patterns/case001.md#anti-world-001)


## RULE-WORLD-002 — 注册与失效管理先正确，再按测量选择 Active Set/索引。


注册与失效管理先正确，再按测量选择 Active Set/索引。

**Scope**：CASE-001 静态证据及其原版快照；迁移到其他 Mod/游戏版本须重新确认适用条件。

### Statement

注册与失效管理先正确，再按测量选择 Active Set/索引。

### Why

一个 Manager 仍可能每秒遍历全部对象。

### Applies When

多个实体参与周期工作。

### Does Not Mean

不是一定需要任务队列或把所有查询变 O(1)。

### Evidence

- [REPORT-R4](<../review-support/reports/sorachestmanager_DeepDive_20260928.txt>) · interpretation · 6；8；13；15

### Counterexample

适用边界示例（未作为独立项目证据）：小规模稀疏工作保持简单遍历更易维护。

### Failure If Violated

优化了任务数量，却仍有高扫描成本或漏注册。

### Detection Questions

- 空闲时扫描什么？注销是否使缓存失效？

### Related Patterns

- [PATTERN-WORLD-001](../patterns/PATTERN-WORLD-001.md#pattern-world-001)

### Related Anti Patterns

- [ANTI-WORLD-001](../anti-patterns/case001.md#anti-world-001)

### Origin Round6 Rule

未记录 / null

### Needs More Cases

是

### Structured Scope

- **game**：Don't Starve Together
- **cases**：- [CASE-001](../cases/CASE-001-sora/README.md#case-001)
- **domains**：- world
  - lifecycle
- **evidence_modes**：- static_analysis
- **runtime_environments**：无 / 未建立
- **sides**：- server

### Typed Relations
