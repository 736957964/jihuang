# 饥荒创意工坊深度研读报告：Auto Tooth Trap Reset（Mine 组件触发切面与周期性任务注入）

- **模组标识**：`588560555` (`Auto Hound Reset / 狗牙陷阱自动重置`)
- **作者**：Cetex
- **版本**：v1.1
- **领域分类**：`mine` 地雷/陷阱组件扩展（`AddComponentPostInit("mine", ...)`）、触发爆炸回调拦截（`Explode`）、周期性安全任务调度（`DoPeriodicTask`）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与组件注入切面）

---

## 一、架构全貌与顶层设计思想

在饥荒基地防守与猎犬袭击（Hound Wave）防御阵地中，狗牙陷阱（Tooth Trap）是性价比最高的防御工事。然而每次犬潮过后，玩家必须走过密集雷区一个一个手动点击重置，极为费时费力且容易误踩。

`Auto Tooth Trap Reset` 以不可思议的简练与高稳定性著称，是饥荒工坊中**组件级切面代理与状态机自愈（Component Aspect Proxy & State Auto-Healing）**的典范：
- **`AddComponentPostInit("mine", ...)` 根切入**：直接针对所有基于 `mine` 组件的地雷与陷阱类实体进行切面增强，避免硬编码修改 `trap_teeth.lua` 预制体；
- **弹跳触发后注入周期自愈任务（Spring State Auto-Reset）**：在陷阱爆炸伤害结算（`Explode`）完成后，注入周期性定时器监测 `self.issprung` 状态，一旦满足条件便自动调用原生的 `self:Reset()`，全自动化恢复戒备状态。

---

## 二、四大硬核核心技术解构

### 1. `mine` 核心组件的侵入式方法重写
- 原生 `mine` 组件负责管理地雷的埋设、激活检测与引爆伤害。
- MOD 在组件构造切面中重写了 `Explode` 方法：
  ```lua
  local function TrapComponentPostInit(self)
      function self:Explode(target)
          self:StopTesting()
          self.target = target
          self.issprung = true
          self.inactive = false
          if self.onexplode then
              self.onexplode(self.inst, target)
          end
          
          -- 核心：引爆后安排 4 秒后自动自愈
          self.inst:DoPeriodicTask(4, function(inst)
              if self.issprung then
                  self:Reset()
              end
          end)
      end
  end
  AddComponentPostInit("mine", TrapComponentPostInit)
  ```
  在完美保留官方原有爆炸与伤害判定的前提下，悄无声息地植入了延迟自愈回调。

### 2. 状态防并发重置守护（`self.issprung` Guard）
- 在定时器触发时先判断 `if (self.issprung)`。若在这 4 秒内陷阱已经被玩家手动重置或者损坏，则不会发生重复重置，避免了由于竞态条件导致的状态机逻辑紊乱。

---

## 三、避坑与生产安全准则

1. **`DoPeriodicTask` vs `DoTaskInTime` 生命周期陷阱**：
   - 源码中使用了 `DoPeriodicTask(4, ...)`，如果在重置之后没有主动销毁该周期任务（`task:Cancel()`），该定时器将在后台每 4 秒持续执行一次判断，造成微量 GC 压力。在生产级代码中，应当使用 `DoTaskInTime(4, ...)` 一次性任务，或者在 `Reset()` 之后显式 `Cancel()` 掉周期任务。
2. **纯服务端切面防护**：
   - 地雷引爆与重置属于纯服务端物理与状态机逻辑。客机不应也不需要执行 `Explode` 的修改，应在入口处检查 `TheWorld.ismastersim`。
