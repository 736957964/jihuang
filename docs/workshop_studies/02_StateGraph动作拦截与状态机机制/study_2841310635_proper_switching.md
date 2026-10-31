# 饥荒创意工坊深度研读报告：Proper Switching & Auto Re-Equip（纯客机无缝装备切换与备用武器自动续杯架构）

- **模组标识s**：`2841310635` (`Proper Switching & Auto Re-Equip Client Mod`)
- **作者**：Growth Mindset (Fidooop)
- **版本**：v1.5a
- **领域分类**：纯客机状态同步与事件监听（`itemget`/`itemlose`/`equip`/`unequip`）、异步动作序列循环模拟（`DoPeriodicTask(0, ...)`）、弹弓自动装填（Slingshot Auto-Reload）、装备损坏自动补位
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与核心事件拦截算法）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，纯客户端玩家在加入官方无洞穴服务器或延迟较高的专属服务器时，常常会遭遇两个痛点：
1. **装备槽位回溯错乱（Prevslot Desync / Wrong Swap Slot）**：当玩家在背包里把新装备拖到已穿戴的装备上进行互换时，原有的旧装备在卸下时经常找不到正确的原路返回格子，导致物品乱飞或掉落；
2. **武器耐久耗尽或弹弓打空时无法自动续杯（No Auto Re-Equip / Slingshot Dry Fire）**：打怪过程中武器突然耐久归零破碎（如眼球伞、战斗长矛、切斯特吹箭或旺达的钟表武器），角色直接进入空手状态，需要手动打开背包寻找备用武器。

`Proper Switching & Auto Re-Equip` 是工坊中技术极其深厚、堪称纯客机事件同步天花板的**高级客机事件拦截与状态机模拟（Client-Side Event Interception & State Mirroring）**巨作：
- **无缝格子追踪与自动归位（`auto_switch_slot`）**：在纯客户端通过监听 `equip`、`unequip`、`itemget`、`itemlose` 事件，实时维护背包和容器的虚拟映射表，在装备互换瞬间计算出最佳目标槽位并通过模拟点击（`try_put_active_item_to_slot`）将其归位；
- **武器破碎与弹弓自动续杯（`main_auto_equip` & `slingshot_auto_reload`）**：精准捕捉武器失效（`unequip` 且 `!IsValid()` 或带有 `NOCLICK` 投掷标签），在背包中通过 Prefab 匹配自动寻找同类备用武器并调用 `ControllerUseItemOnSelfFromInvTile` 实现“一键自动续杯”。

---

## 二、四大硬核核心技术解构

### 1. 纯客户端事件交叉监听与随机乱序应对
- 在客机上，`equip` 和 `itemget` 事件到达的先后顺序是不确定的（取决于网络延迟和封包）。作者巧妙地构建了一个不依赖帧延迟的双向校验器：
  ```lua
  local function auto_switch_slot(inst, obtained_item, slot_to_take_from, destination_slot, obtained_is_in_backpack, destination_is_in_backpack)
      -- 通过每帧 0 秒周期的微型协同器（DoPeriodicTask），动态驱动拾取和放入动作
      local function put_prompt()
          refresh_common_variables()
          if item_on_dest_slot == nil then
              try_put_active_item_to_slot(destination_slot, inventory_destination)
          else
              try_swap_active_item_with_slot(destination_slot, inventory_destination)
          end
      end
      -- ...
  end
  ```
  通过不断轮询和比对 `active_item` 是否已顺利抓取，在纯客户端模拟出极其丝滑的物品无缝对调。

### 2. 武器耐久归零与投掷物打空检测
- 如何判断一把武器是“被玩家主动卸下”还是“耐久耗尽破碎”？
  ```lua
  local function main_auto_equip(inst, unequipped_item, eslot, previous_is_projectile)
      local unequipped_is_invalid = not unequipped_item:IsValid() -- 物品失效（破碎）
      local unequipped_has_tag_noclick = unequipped_item:HasTag("NOCLICK") -- 投掷物用尽
      if not previous_is_projectile then
          if unequipped_is_invalid then autoequip_is_valid = true end
      else
          if unequipped_has_tag_noclick then autoequip_is_valid = true end
      end
      -- ...
  end
  ```
  如果判定为战斗中损坏，MOD 会立即扫描背包中是否有相同 Prefab 的备用武器，并自动执行穿戴动作。

### 3. 弹弓自动装填机制（Slingshot Auto-Reload）
- 对于旺达或沃姆wood的弹弓，当发射最后一颗石头时，监听 `itemlose` 并在 `Ents` 中匹配刚生成的投掷物实体（`_proj`），随后立刻扫描背包中的同种弹药并塞回弹弓容器槽位：
  ```lua
  local function slingshot_auto_reload(inst, ammo)
      local inventory = GLOBAL.ThePlayer.replica.inventory
      local tables_to_check = item_tables_to_check(GLOBAL.ThePlayer)
      local item_to_equip = next_same_prefab_item_from_tables(tables_to_check, ammo)
      if item_to_equip ~= nil then
          try_use_item_on_self(item_to_equip, inventory)
      end
  end
  ```

---

## 三、避坑实战经验

1. **绝对禁止在客户端直接调用无权限的 RPC 变更**：
   - 纯客户端 Mod（`client_only_mod = true`）无法直接操作服务端 Inventory 组件。该 MOD 所有的自动化替换均是通过模拟官方手柄/键鼠在格子上的控制器交互函数（如 `PutAllOfActiveItemInSlot`、`ControllerUseItemOnSelfFromInvTile`）向服务器发送标准操作封包实现的。
2. **防护高频递归死循环（Infinite Task Loop）**：
   - 在使用 `DoPeriodicTask(0, ...)` 模拟动作时，必须有明确的终止条件（如 `cancel_task` 或检测到目标槽位已满足条件），否则会导致客户端帧率暴跌至 0 并在数秒内内存溢出。
