# 饥荒一线工坊深度研读 Skill：Mine 组件触发切面与一次性安全自愈调度技术

- **工坊 ID**：588560555 (`Auto Tooth Trap Reset`)
- **领域分类**：`mine` 地雷组件拦截、`Explode` 爆炸回调注入、防重复重置状态检查、定时器安全销毁机制
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“自动重置陷阱、延迟恢复机制、阵地工事自愈”等防御系统时：
1. **组件方法劫持**：通过 `AddComponentPostInit("mine", ...)` 包装原版 `Explode` 方法；
2. **一次性安全调度**：使用 `DoTaskInTime` 替代易造成常驻后台泄露的 `DoPeriodicTask`；
3. **状态守卫检查**：重置前确认 `issprung` 标志位，确保状态一致性。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式：无内存泄露版地雷自愈切面组件 (modmain.lua)
-- ==============================================================================

local RESET_DELAY = 4.0 -- 触发后自动重置的秒数

local function PatchMineComponent(self)
    local old_Explode = self.Explode

    function self:Explode(target)
        -- 1. 执行官方原版爆炸、音效、伤害与受害者判定
        if old_Explode then
            old_Explode(self, target)
        end

        -- 2. 仅在服务端执行自动化重置任务调度
        if not GLOBAL.TheWorld.ismastersim then return end

        -- 3. 安全清理前一个未执行完毕的任务引用
        if self._auto_reset_task then
            self._auto_reset_task:Cancel()
            self._auto_reset_task = nil
        end

        -- 4. 采用 DoTaskInTime 一次性任务，避免 DoPeriodicTask 产生永动 GC 负担
        self._auto_reset_task = self.inst:DoTaskInTime(RESET_DELAY, function(inst)
            self._auto_reset_task = nil
            -- 状态守卫：仅当确实处于被引爆弹开状态时才执行重置
            if self.issprung and self.Reset then
                self:Reset()
            end
        end)
    end

    -- 实体销毁时同步清理定时器
    local old_OnRemoveFromEntity = self.OnRemoveFromEntity
    function self:OnRemoveFromEntity(...)
        if self._auto_reset_task then
            self._auto_reset_task:Cancel()
            self._auto_reset_task = nil
        end
        if old_OnRemoveFromEntity then
            return old_OnRemoveFromEntity(self, ...)
        end
    end
end

GLOBAL.AddComponentPostInit("mine", PatchMineComponent)
```

---

## 三、避坑与生产安全准则

1. **必须妥善管理 Task 句柄**：
   - 绝不可像早期简单 Mod 那样无脑写 `DoPeriodicTask` 且不保留引用。成百上千个狗牙陷阱若同时挂着每 4 秒空转的定时任务，会造成极其显著的服务器 CPU 软中断抖动。
2. **`self.issprung` 状态断言**：
   - 在定时器触发的瞬间，陷阱可能已经被其他生物彻底踩碎、被锤子敲掉或被玩家收回背包。通过 `self.issprung and self.Reset` 检查是防止 `attempt to call method 'Reset' (a nil value)` 崩溃的关键护盾。
