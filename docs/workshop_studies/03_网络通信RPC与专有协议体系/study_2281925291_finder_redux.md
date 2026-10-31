# 饥荒创意工坊深度研读报告：Finder Redux（箱子物品反向追踪、材质高亮与客户端 RPC 寻物引擎）

- **模组标识**：`2281925291` (`Finder Redux / 物品寻找器重制版`)
- **作者**：Cunning fox
- **版本**：v1.1
- **领域分类**：客户端与服务端 RPC 协同寻物（`AddModRPCHandler` / `AddClientModRPCHandler`）、实体材质动态高亮（`ColourManager`）、鼠标悬停与光标物品拦截（`inventory:SetActiveItem`）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含解压后的 `main.lua` 与高亮管理器）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，随着基地规模越来越大，上百个箱子（Chests）堆满了各种材料。当玩家想要找某种特定矿石、食物或制造某个装备时，常常需要打开几十个箱子逐一翻找。

`Finder Redux` 是工坊中技术极其优雅的**双向 RPC 实体空间搜索与高亮渲染引擎（Bi-directional RPC Spatial Search & Highlight Engine）**：
1. **悬停联动寻物（UI Hover Interception）**：当玩家在制造栏的配方材料（`ingredientui`）上悬停鼠标，或者把光标拿起一个物品（`SetActiveItem`）时，客户端会自动向服务器发起 RPC 请求；
2. **空间半径实体扫描（`TheSim:FindEntities`）**：服务器在收到请求后，以玩家为中心在 20 码半径内检索所有带 `_container` 标签且可见的容器实体，逐个调用 `container:Has(item, 1)`；
3. **色彩通道动态高亮（`ColourManager` Push/Pop）**：服务器通过 `SendModRPCToClient` 将匹配的目标箱子传回客户端，客户端利用 `ColourManager` 对箱子实体施加动态材质 tint（白、黄、红、绿、蓝、粉等），让藏有目标物资的箱子在屏幕中闪耀发光。

---

## 二、四大硬核核心技术解构

### 1. 客户端悬停事件到服务端 RPC 的触发管线
- 模组通过对合成面板的材料小部件（`ingredientui`）注入 `OnGainFocus` 监听：
  ```lua
  AddClassPostConstruct("widgets/ingredientui", function(self, ...)
      local _OnGainFocus = self.OnGainFocus
      function self:OnGainFocus(...)
          if self.product then
              SendModRPCToServer(GetModRPC("FINDER_REDUX", "FIND"), self.product)
          end
          return _OnGainFocus(self, ...)
      end
  end
  ```
  当鼠标悬停在某个配方材料上时，瞬间将物品 Prefab 发往服务端。

### 2. 光标拿取物品（ActiveItem）即时追踪
- 除了制造栏，模组还拦截了玩家的背包组件 `inventory`：
  ```lua
  env.AddComponentPostInit("inventory", function(self)
      if not self.inst:HasTag("player") then return end
      local _SetActiveItem = self.SetActiveItem
      function self:SetActiveItem(item, ...)
          if item then
              SendModRPCToServer(GetModRPC("FINDER_REDUX", "FIND"), item.prefab, true)
          else
              SendModRPCToServer(GetModRPC("FINDER_REDUX", "FIND"), nil)
          end
          return _SetActiveItem(self, item, ...)
      end
  end)
  ```
  只要鼠标光标抓起任意物品，全场所有装有该物品的箱子就会被实时高亮标出。

### 3. 服务端空间密集检索（Spatial Entity Filtering）
- 服务端收到 `FIND` 请求后，使用高性能的 `TheSim:FindEntities` 进行空间过滤：
  ```lua
  local function FindItem(inst, item, active_item)
      local x, y, z = inst.Transform:GetWorldPosition()
      local ents = TheSim:FindEntities(x, y, z, 20, {"_container"}, {"player", "DECOR", "FX", "NOCLICK", "INLIMBO", "outofreach"})
      for _, ent in ipairs(ents) do
          if ent and ent:IsValid() and ent.entity:IsVisible() and
             ent.components.container and ent.components.container:Has(item, 1) then
              SendModRPCToClient(GetClientModRPC("FINDER_REDUX", "HIGHLIGHT"), inst, ent)
          end
      end
  end
  ```

---

## 三、避坑实战经验

1. **RPC 频繁调用的防抖与清理（Cleanup on Lose Focus）**：
   - 鼠标悬停（Focus）和移开（LoseFocus）必须成对出现。一旦鼠标移开，必须立刻向服务器发送 `FindItem(nil)` 以清空高亮缓存数组（`HIGHLITED_ENTS`），并调用 `ColourManager:PopColour` 恢复箱子原色，否则会导致地图上的箱子永久保持高亮状态（Highlighter Leak）。
2. **兼容第三方烹饪厨具 Mod（如 Craft Pot）**：
   - 源码中巧妙集成了 `pcall(require, "widgets/foodingredientui")`，自动适配复合烹饪配方的标签搜索（Tag Searching），体现了极高的代码鲁棒性。
