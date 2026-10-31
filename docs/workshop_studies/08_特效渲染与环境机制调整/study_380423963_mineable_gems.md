# 饥荒创意工坊深度研读报告：Mineable Gems（动态掉落表融合与多 Mod 冲突防御架构）

- **模组标识**：`380423963` (`Mineable Gems / 可开采宝石与落石重构`)
- **作者**：star (Show Me 作者)
- **版本**：v2.20
- **领域分类**：服务端权威掉落修改（`TheNet:GetIsServer()`）、`LootTables` 全局表热补丁与切片注入、概率多重离散拆分（Discrete Chunk Slicing）、跨 Mod 掉落表保护协议（`SetSharedLootTable` 代理防覆盖）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua`、`MineableGems.lua` 与配置反向嗅探系统）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，挖掘岩石（`rock1`, `rock2`, `stalagmite` 等）通常只掉落基础矿物（石头、燧石、金块、硝石），各类珍贵宝石（红/蓝/紫/黄/橙/绿宝石）主要依赖地下遗迹或发条怪。

`Mineable Gems` 由饥荒泰斗级作者 **star** 精心架构：
1. **概率多重离散切片算法（Discrete Chunk Slicing）**：支持超过 100% 乃至 370% 的掉落概率配置，将其在数学上分解为多个单体掉落项（例如 $3.7$ 拆解为 3 个 100% 必掉项 + 1 个 70% 概率项）；
2. **跨 Mod 掉落表双向保护与冲突让步协议（Collaborative Loot Merging Protocol）**：建立 `mods.mine` 全局注册表，重写 `SetSharedLootTable`，当其他 Mod 试图覆写掉落表时，智能提取对方新增物品并保护自身注入数据不被抹除；
3. **老版本配置向后兼容与配置反向窃取（Config Backwards Compatibility）**：通过分析 `KnownModIndex:LoadModOverides()` 跨级嗅探重名配置与历史配置字段，避免玩家更新 Mod 后配置重置失效。

---

## 二、四大硬核核心技术解构

### 1. 掉落率离散切片分解（Discrete Chunk Slicing）
- **底层难点**：官方掉落机制 `lootdropper:GenerateLoot()` 内部使用 `math.random() <= chance` 判定。如果直接传入大于 1.0 的概率（例如 2.5），原生代码会将其实际等同于 100%，导致超出 100% 的期望多重掉落失效。
- **神级工程解法**：
  ```lua
  local AddLoot = function(prefab, loot, value)
      -- 递归展开预制体数组
      if type(prefab) == "table" then
          for _, v in ipairs(prefab) do AddLoot(v, loot, value) end
          return
      end
      if not LootTables[prefab] then LootTables[prefab] = {} end

      -- 核心离散拆分：大于 1 的部分循环拆解为单体 1.0，余数保留为微量概率
      while value > 0.0000001 do
          local val = value > 1 and 1 or value
          table.insert(LootTables[prefab], { loot, val })
          value = value - val
      end
  end
  ```
  例如传入 `value = 2.4`，会被精准切片为 `{loot, 1}`, `{loot, 1}`, `{loot, 0.4}` 三项独立判定，完美支持任意高倍率掉落！

### 2. `SetSharedLootTable` 防覆写合并代理（Loot Table Protection Proxy）
- **痛点**：若其他 Mod 在加载时调用 `SetSharedLootTable("rock1", {...})` 重新初始化全表，会导致本 Mod 注入的红宝石、蓝宝石瞬间被全量抹除。
- **解法**：
  ```lua
  local function NewSetSharedLootTable(name, tbl)
      if not (LootTables[name] and LootTables[name].protect) then
          LootTables[name] = tbl -- 未被保护的表正常放行
      else
          -- 核心：拦截覆盖！只允许对方追加新物品，保护本 Mod 的掉落物不被替换
          local protected_table = LootTables[name]
          for _, item in ipairs(tbl) do
              if not protected_table.protect.marks[item[1]] then
                  table.insert(protected_table, item)
              end
          end
      end
  end
  ```
  通过布尔哈希表 `protect.marks` 建立白名单防线，使不同作者的矿石掉落 Mod 能够实现完美的无冲突共存。

### 3. 地洞落石地震碎屑（Cave Quake Debris）权重动态重构
- 巧妙扩展洞穴地震掉落表。不仅能配置标准矿石，还能配置落石期间掉落齿轮、发光浆果、甚至活兔子的概率，将原版单调的地洞地震变成了高风险高收益的资源机制。

### 4. 纯服务端切面防护
- 在脚本入口通过：
  ```lua
  _G = _G or GLOBAL
  if not (_G.TheNet and _G.TheNet:GetIsServer()) then
      return
  end
  ```
  前置阻断客机多余逻辑，所有掉落表计算纯在专用服务器或主机本地内存中运行，客户端完全零负担。

---

## 三、避坑实战经验

1. **浮点精度截断阀（`value > 0.0000001`）**：
   - 在 Lua 中进行浮点减法运算时（如 $1.0 - 0.1$ 多次迭代），会产生类似 $0.00000000000004$ 的微量尾差。如果不加 `0.0000001` 终止条件，`while` 循环会死循环成千上万次，瞬间把服务器卡死。
2. **预制体列表解包（Table Unpack vs Recursive Iteration）**：
   - 在定义多个同类矿石（如高、中、低三个生长状态的钟乳石 `stalagmite`）时，采用递归遍历 `AddLoot`，比暴力硬编码调用多次性能更优、代码维护性成倍提升。
