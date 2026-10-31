# 饥荒创意工坊深度研读报告：Extra Equip Slots（额外装备槽与背包护甲共存架构）

- **模组标识**：`375850593` (`Extra Equip Slots / 额外装备槽·背包护甲共存`)
- **作者**：xVars
- **版本**：v1.8.0
- **领域分类**：网络槽位协议重塑（`EQUIPSLOTS`）、`inventory_classified` 客户端预测穿透、`GetOverflowContainer` 溢出容器劫持、复活护符（Resurrectable）槽位重定向
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与槽位图集）

---

## 一、架构全貌与顶层设计思想

在饥荒原版中，背包与身体护甲（木甲/大理石甲）共用同一个槽位（`EQUIPSLOTS.BODY`），穿护甲就必须脱背包，背背包就无法穿甲。这个硬核设计虽然维持了生存张力，但在联机体验中极受争议。

`Extra Equip Slots` 是饥荒史上订阅量与影响力最大的核心机制重塑 Mod。其核心架构难点在于：
1. **网络协议层突破**：联机版客机与服务端的装备槽位映射是一一对应的数字 ID；
2. **`inventory_classified` 客机预测同步**：背包（Overflow Container）在客机端如何被正确识别为独立容器，保证配方制作（Builder）能直接扣减背包内的材料；
3. **死者复生链路（Resurrectable）**：当生命护符被装备在全新的“颈部（NECK）”槽位时，玩家死亡瞬间如何拦截并触发原生重生动画。

---

## 二、四大硬核核心技术解构

### 1. 全局 `EQUIPSLOTS` 拓扑与 ID 映射数组重构
- 饥荒底层的网络实体要求每一个装备槽位必须对应一个严格的正整数 ID（1~N）：
  ```lua
  GLOBAL.EQUIPSLOTS = {
      HANDS = "hands",
      HEAD = "head",
      BODY = "body",
      BACK = "back",   -- 新增背包槽
      NECK = "neck",   -- 新增护符槽
  }
  GLOBAL.EQUIPSLOT_IDS = {}
  local slot = 0
  for k, v in pairs(GLOBAL.EQUIPSLOTS) do
      slot = slot + 1
      GLOBAL.EQUIPSLOT_IDS[v] = slot
  end
  ```
  在启动初期即重建 `EQUIPSLOT_IDS` 映射表，使新槽位能够无缝被引擎 C++ 序列化器识别。

### 2. `inventory_classified` 客户端物品统计与溢出容器穿透（Overflow Injection）
- **痛点**：玩家打开制作栏（Crafting Menu）制造火把或长矛时，客机需要预先计算身上是否有足够的草和枝条。原版官方只把 `BODY` 槽位判定为背包。
- **解法**：在 `inventory_classified` 注入自定义溢出容器嗅探：
  ```lua
  function GetOverflowContainer(inst)
      local item = inst.GetEquippedItem(inst, GLOBAL.EQUIPSLOTS.BACK)
      return item ~= nil and item.replica.container or nil
  end
  ```
  并在 `Has(inst, prefab, amount)` 中显式递归查询 `overflow:Has(prefab, amount)`，保证了客机在背包塞满材料时，制作栏依然能秒亮合成图标，预测零延迟！

### 3. `widgets/inventorybar` 动态伸缩与自检按钮动态居中
- 原版物品栏底图（`bg` 与 `bgcover`）是固定宽度的。加入两个新槽位后，必须动态拉伸底板：
  ```lua
  self.bg:SetScale(1.35, 1, 1.25)
  self.bgcover:SetScale(1.35, 1, 1.25)
  ```
  同时动态重算原生自检按钮（Inspect Button）的世界绝对 X 轴偏移，保证在各种分辨率下，自检放大镜精准居于新增槽位的右侧，严丝合缝。

### 4. 颈部复活护符监听与死亡状态机劫持（Resurrectable Hook）
- 原版 `resurrectable` 组件在死亡瞬间只检索 `BODY` 槽位是否有重生护符。
- MOD 在 `resurrectable` 注入代理：
  ```lua
  self.CanResurrect = function(self)
      if IsServer and self.inst.components.inventory then
          local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
          if item and item.prefab == "amulet" then
              return true
          end
      end
      return original_CanResurrect(self)
  end
  ```
  并在 `DoResurrect` 中平滑将角色切入 `amulet_rebirth` 状态机，保证了护符从身体槽剥离后，原生重生功能百分百完美保留。

---

## 三、避坑实战经验

1. **`setoverflow` 事件的网络触发时序**：
   - 当背包被穿戴到 `BACK` 槽位时，不仅要赋值 `self.equipslots[eslot] = item`，还必须显式向玩家实体广播 `self.inst:PushEvent("setoverflow", { overflow = item })`。漏发该事件会导致客户端的左侧背包栏无法弹出。
2. **多 MOD 槽位注入冲突防范**：
   - 如果同时安装了其它增加腰带或副手槽的 MOD，直接覆盖 `GLOBAL.EQUIPSLOTS` 会导致对方槽位被抹除。标准姿态是在原表上做增量追加（`GLOBAL.EQUIPSLOTS.BACK = "back"`），并动态遍历计算自增 ID，避免硬编码覆写。
