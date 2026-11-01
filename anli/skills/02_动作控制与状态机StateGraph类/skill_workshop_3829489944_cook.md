# 饥荒工业级最佳实践范式：Cook
> 对应工坊权威基准：Mod 3829489944 (`Cook`)
> 技术分类：02_动作控制与状态机StateGraph类 | 源码规模：2 文件 / 352 行

---

## 一、架构背景与设计哲学
本范式旨在解决饥荒联机版中 Cook 涉及的架构协同难题。
在官方源码机制下，原版逻辑对相关切面具备较强的封闭性。通过精准挂载钩子、隔离脏标记通信及遵循生命周期规范，实现无侵入式工业级扩展。

## 二、核心底层算法与网络拓扑机制
1. **系统注入切面与挂载拓扑**：
   - 提取到核心切面钩子：`['AddComponentPostInit:cookable', 'AddComponentPostInit:stewer', 'AddPrefabPostInit:fishingrod']`；
   - 依赖官方底层实体生命周期：在 `PreInit` 完成网络数据对齐，在 `PostInit` 挂载业务监听，确保跨客户端无缝通信。

## 三、标准化生产级代码范式（可直接移植）

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3829489944，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

if GetModConfigData("Fish") then
    AddPrefabPostInit("fishingrod", function(inst)
        local fr = inst.components.fishingrod
        if fr then
            if fr.waittime then
                fr.waittime = math.max(0.1, fr.waittime * 0.8)
            end
            if fr.reeltime then
                fr.reeltime = math.max(0.1, fr.reeltime * 0.8)
            end
        end
    end)
```

## 四、方案对比矩阵与权衡取舍（Trade-off Matrix）

| 技术选型方案 | 核心技术原理 | 优势与收益 | 代价与潜在风险 | 推荐适用场景 |
| :--- | :--- | :--- | :--- | :--- |
| **方案 A：PostInit 深度切面（本母本）** | 挂载官方标准生命周期注入点 | 原生兼容性高、零侵入、支持跨 Mod 协同 | 需精确处理加载先后时序 | 绝大多数公网联机与模组服 |
| **方案 B：全局暴力覆写（Anti-Pattern）** | 篡改全局函数或暴力替换 Class | 编写简单快速、无需排查依赖链 | 极易造成 Mod 相互排斥及坏档 | 个人单机测试环境 |

## 五、进阶拓扑演进与变体分支
- **分支 1（网络预测优化）**：若需支持客机零延迟预表现，可在客户端副本（Replica）装载本地预表现动画。
- **分支 2（高负载防抖截流）**：在高频 RPC 或高频网络事件中挂载脏标记脏池，防止包泛洪。

## 六、踩坑与反模式避错指南（防御性闭环）
1. **网络变量声明时机**：所有 `net_*` 必须在 `inst.entity:AddNetwork()` 后、`SetPristine()` 前注册，严禁在预制体后处理的尾部动态挂载。
2. **重入锁防御**：在复杂事件分发时，务必维护实体级别的布尔标记，防止死循环递归。
