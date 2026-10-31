# 饥荒创意工坊深度研读报告：Quick Pick（Pickable.quickpick 组件标志与动作状态机短路优化）

- **模组标识**：`501385076` (`Quick Pick / 极速采摘`)
- **作者**：辣椒小皇纸
- **版本**：v1.4.0
- **领域分类**：`pickable` 组件扩展（`quickpick = true`）、状态机动作映射劫持（`AddStategraphPostInit` 与 `ActionHandler` 替换为 `"doshortaction"`）、跨 Mod 兼容嗅探（`KnownModIndex:IsModEnabled`）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与配置映射）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，采集浆果、砍树枝、采摘芦苇以及从烹饪锅和晒肉架上收成食物时，角色往往会播放一个较长且繁琐的弯腰鞠躬动画（如 `doshortaction` 或更长的采集动画），在频繁采集大量农作物或批量收菜时极大地消耗玩家的真实时间。

`Quick Pick` 是工坊中技术极度精炼、堪称教科书级别的**状态机动作重定向与组件属性短路（Action StateGraph Redirection & Component Flagging）**标杆：
1. **组件级闪电采摘标志（`pickable.quickpick = true`）**：针对树枝（`sapling`）、草（`grass`）、浆果丛（`berrybush`）、仙人掌（`cactus`）、洞穴蘑菇等几十种植物，在 `AddPrefabPostInit` 阶段直接开启 `quickpick` 开关。原生 `pickable` 组件检测到该标志后，会跳过繁琐的捡拾判定，实现瞬间秒采；
2. **动作处理器状态机重定向（`ActionHandler` Overwrite）**：通过 `AddStategraphPostInit("wilson", ...)` 将官方采集（`HARVEST`）和烹饪火堆烤制（`COOK`）动作的处理函数直接绑定到高速短动作状态（`"doshortaction"`），强行剥离漫长的等待动作。

---

## 二、四大硬核核心技术解构

### 1. `pickable.quickpick = true` 组件属性穿透
- 饥荒原生 `pickable` 组件在初始化时支持一个名为 `quickpick` 的布尔字段。如果该字段为 `true`，角色在执行 `PICK` 动作时将直接完成物品转移并省去中间的过渡硬直：
  ```lua
  local quick_pick_list = {
      "sapling", "marsh_bush", "reeds", "grass", "berrybush2", "berrybush",
      "flower_cave", "red_mushroom", "green_mushroom", "blue_mushroom",
      "wormlight_plant", "rock_avocado_bush", "bullkelp_plant", "carrat_planted", "sapling_moon"
  }

  for _, prefab in ipairs(quick_pick_list) do
      AddPrefabPostInit(prefab, function(inst)
          if inst.components.pickable then
              inst.components.pickable.quickpick = true
          end
      end)
  end
  ```
  这种做法极其干净，不需要重写任何复杂的交互逻辑，纯粹利用官方预留的底层属性开关。

### 2. 状态机动作处理器劫持（StateGraph ActionHandler Redirection）
- 针对无法直接通过 `pickable` 解决的收成行为（如锅中取食、晒架收肉、火堆烤制），MOD 直接切入威尔逊（Wilson）及所有角色的状态机（StateGraph）：
  ```lua
  if GetModConfigData("quick_harvest") then
      AddStategraphPostInit("wilson", function(sg)
          local actionhandler = GLOBAL.ActionHandler(GLOBAL.ACTIONS.HARVEST, "doshortaction")
          sg.actionhandlers[GLOBAL.ACTIONS.HARVEST] = actionhandler
      end)
  end

  if GetModConfigData("quick_cook_on_fire") then
      AddStategraphPostInit("wilson", function(sg)
          local actionhandler = GLOBAL.ActionHandler(GLOBAL.ACTIONS.COOK, "doshortaction")
          sg.actionhandlers[GLOBAL.ACTIONS.COOK] = actionhandler
      end)
  end
  ```
  通过将 `ACTIONS.HARVEST` 与 `ACTIONS.COOK` 强行映射到 `"doshortaction"` 状态，玩家在收菜和烤肉时身体不再僵硬罚站。

### 3. 动态兼容第三方拓展模组（`KnownModIndex:IsModEnabled`）
- 模组考虑到了热门扩展（如咖啡种植 Mod `workshop-1463489316`）：
  ```lua
  if GLOBAL.KnownModIndex:IsModEnabled("workshop-1463489316") then
      table.insert(quick_pick_list, "coffeebush")
  end
  ```
  动态探测环境中的其他植物类 Mod，若其处于启用状态则自动将其加入闪电采摘白名单。

---

## 三、避坑实战经验

1. **`AddStategraphPostInit` 必须覆盖所有角色状态机（或继承 Wilson）**：
   - 饥荒中绝大多数人物（Wigfrid, Wolfgang, WX-78 等）的状态机均继承自主角 `wilson` 或与其共享 `wilson` 状态机。通过修改 `"wilson"` 的 `sg.actionhandlers` 可以一劳永逸地作用于全员，避免为每个 DLC 角色单独写一遍补丁。
2. **严防客户端与服务端行为不一致（Mismatch State）**：
   - 修改 `ActionHandler` 属于客户端表现层与预测层优化。如果服务端状态机与客户端动画时长不匹配，可能会造成极少数情况下物品已经到手但客户端动作还在重复播出的视觉残影，合理搭配 `doshortaction` 可以完美契合服务端的同步回包。
