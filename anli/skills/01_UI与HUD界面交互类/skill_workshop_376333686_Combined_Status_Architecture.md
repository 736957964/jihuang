# 饥荒一线工坊深度研读 Skill：事件驱动型 HUD 状态数值注入与跨端状态嗅探

- **工坊 ID**：376333686 (`Combined Status`)
- **领域分类**：客户端 UI 强化、Badge 控件切面扩展、事件驱动高性能监听、客机实体状态安全 Getter
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在饥荒界面开发中，直接修改核心 Badge 控件是极其危险的，极易与其他人物 MOD 或界面美化 MOD 冲突。`Combined Status` 的规范示范了：**通过 Decorator 模式包装 `SetPercent`，结合饥荒事件总线（Event Bus）做只读数值渲染**。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 376333686，完整闭包自闭环)
-- ============================================================================
local GLOBAL = GLOBAL

if (CSW or HML) and SHOWSTATNUMBERS then
	AddPrefabPostInit("world", function()
		AddClassPostConstruct("widgets/boatbadge", BoatBadgePostConstruct)
	end)
```

---

## 三、避坑与生产安全准则

1. **绝对禁止在 UI 中直接读取非主机服务端的 `components`**：
   - 联机版客机上，`player.components.health` / `player.components.temperature` 默认不存在或不包含权威数值。必须优先读取 `player.replica.health:GetCurrent()` 或 `player:GetTemperature()`，严禁 `player.components.temperature.current`！
2. **事件监听必须指定所属监听器（`inst:ListenForEvent(..., target)`）**：
   - 监听玩家身上的变化事件（如 `temperaturedelta`）时，必须将玩家作为第三个参数传入：`badge.inst:ListenForEvent("temperaturedelta", callback, player)`。这样当玩家死亡或切人时，引擎会自动解除对销毁实体的回调引用，防止内存泄漏。
