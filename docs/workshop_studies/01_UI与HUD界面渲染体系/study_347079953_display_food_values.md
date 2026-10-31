# 饥荒创意工坊深度研读报告：Display Food Values（虚拟预演烘焙与网络事件流架构）

- **模组标识**：`347079953` (`Display Food Values / 食物属性与烤制预演`)
- **作者**：alks, gregdwilson
- **版本**：v1.61
- **领域分类**：服务端瞬态沙盒生成（`SpawnPrefabAsServerAndRemoveFromWorld`）、烤制状态前瞻运算（`cookable:Cook`）、`net_string` 脏同步管道、多国语言紧凑符号排版
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `foodvalues.lua` 组件与背包栏交互切面）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，食物拥有生食、烤制（Cooked）、干燥（Dried）等多种形态，其三维属性（饱食度、生命值、理智值）往往差异巨大（如生肉吃下扣理智甚至掉血，烤肉则提供大量恢复；毒蘑菇烤熟后能回血）。

`Display Food Values` 是饥荒工坊早期最开创性的**沙盒虚拟预演运算（Virtual Simulation Sandbox）**典范：
1. **瞬态无实体沙盒演化（Phantom Entity Simulation）**：独创 `SpawnPrefabAsServerAndRemoveFromWorld` 技术，在服务端内存中实例化虚拟预制体并立即从场景中摘除（脱离物理渲染），用于安全探测其三维属性；
2. **按键驱动的烤制前瞻预测（If-Cooked Predictive Branch）**：当玩家按下特定热键（`keydown`）查看生食时，服务端动态在内存中生成虚拟营火（`campfire`）并调用 `cookable:Cook`，提前向客户端揭示该食物烤熟后的预期三维恢复量；
3. **角色进食特性（`monsterimmune` / `DoFoodEffects`）特化适配**：深入结合 `player.components.eater` 状态机，根据食用者是普通人还是怪物肉免疫角色（如沃柏特、韦伯），动态计算扣血或免伤。

---

## 二、四大硬核核心技术解构

### 1. 瞬态内存沙盒预演技术（Phantom Entity Sandbox）
- **传统难题**：在服务端直接读取真实物品时，由于堆叠数量、新鲜度腐烂、容器所有权等问题，执行 `Cook()` 会导致真实物品被消耗或状态损坏。
- **神级解法**：
  ```lua
  function FoodValues:SpawnPrefabAsServerAndRemoveFromWorld(prefab)
      local inst = GLOBAL.SpawnPrefab(prefab)
      if inst ~= nil then
          inst:RemoveFromScene()
          -- 标记为瞬态虚拟实体，防止被全图扫描逻辑命中
          inst.persists = false
      end
      return inst
  end
  ```
  在内存中创建一个纯净镜像，计算完成后立即销毁（`inst:Remove()`），既完全隔绝了对真实玩家背包中物品的副作用，又保证了计算结果与官方配方 100% 绝对一致！

### 2. 交互式烤制状态机前瞻（Cookable State Branching）
- 当玩家悬停在一块生大肉上时：
  ```lua
  if keydown and self.item.components.cookable ~= nil then
      local campfire = self:SpawnPrefabAsServerAndRemoveFromWorld("campfire")
      self.item = self.item.components.cookable:Cook(campfire, player)
      self.string = "\n" .. strings.DFV_IFCOOKED
      campfire:Remove()
  end
  ```
  直接将生肉在内存中与营火进行虚拟碰撞生成熟肉实体，进而提取熟肉的生命恢复属性，并在提示栏加上前缀 `[Si cuits / If Cooked]`。

### 3. 食用者（Eater）角色特性抗性与负增益过滤
- 不同的饥荒角色对食物的响应完全不同。例如韦伯吃怪物肉不扣理智和生命，普通角色吃怪物肉则受到严厉惩罚。
- MOD 在计算数值时，直接传入当前 `player` 句柄：
  ```lua
  self.hungervalue = math.floor(self.item.components.edible:GetHunger(player) * 10 + 0.5) / 10
  self.healthvalue = math.floor(self.item.components.edible:GetHealth(player) * 10 + 0.5) / 10
  self.sanityvalue = math.floor(self.item.components.edible:GetSanity(player) * 10 + 0.5) / 10
  ```
  调用官方 `GetHunger(player)` 接口，让角色自带的倍率乘数（如沃夫冈大力士、维格弗利德纯肉食主义）自动生效，彻底避免了硬编码属性导致的计算偏差。

### 4. `net_string` 变长网络脏标记管道
- 服务端挂载 `self.string_dirty = net_string(self.inst.GUID, "string", "string_changed_dirty")`；
- 每次计算完成后，将格式化好的字符串（支持九国语言以及紧凑图标排版）推入 `string_dirty`；
- 客户端监听 `string_changed_dirty` 事件，单播刷新悬停文本，网络吞吐极为轻量。

---

## 三、避坑实战经验

1. **虚拟实体必须 `RemoveFromScene()` 与 `Remove()`**：
   - 使用 `SpawnPrefab` 探测属性时，若忘记调用 `inst:RemoveFromScene()`，该实体会出现在世界原点 $(0,0,0)$ 并参与物理碰撞；若计算完后忘记调用 `inst:Remove()`，每移动一次鼠标就会向世界增加一个实体，几分钟内就会引发游戏严重掉帧乃至崩溃。
2. **`edible` 属性四舍五入防浮点误差**：
   - 官方游戏内部的生命回复往往带有微量浮点（如 $12.49999999$）。必须使用 `math.floor(val * 10 + 0.5) / 10` 进行规范的保留一位小数四舍五入，防止 UI 显示出 `+12.499999999999 Hunger` 极其丑陋的排版穿帮。
