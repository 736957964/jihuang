# 饥荒创意工坊深度研读报告：Bee Nice（生态仇恨抑制与闭包注入架构）

- **模组标识**：`361994110` (`Bee Nice / 采蜜不挨蛰与生态防卫重定向`)
- **作者**：Ryuu (original by =|:3)
- **版本**：v0.7
- **领域分类**：生态交互与仇恨重定向（Combat Retargeting）、UpvalueHacker 闭包劫持（`updatelevel`）、巢穴繁衍组件（`childspawner:ReleaseAllChildren`）、季节世界状态监听（`TheWorld.state.isspring`）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua` 与 RezCib 闭包遍历体系）

---

## 一、架构全貌与顶层设计思想

在饥荒世界中，蜜蜂与蜂箱（`beebox`）构成了最典型的“群体防御与资源产出”生态圈。原生逻辑中，玩家在收获蜂蜜（Harvest）的一瞬间，蜂箱组件会强制释放内部所有成年蜜蜂并将采集者（`picker`）设为第一仇恨目标；此外在春季，野生蜜蜂默认处于红温激怒状态（Aggressive），对周围一切非昆虫实体发动无差别攻击。

`Bee Nice` 展示了饥荒 Mod 中**极具启发性的“拟真伪装与生态交互降级（Biomimetic Pacification & Combat Soft-Fail）”**架构：
1. **闭包函数原样还原（Closure Level Upvalue Preservation）**：通过经典 `UpvalueHacker` 从 `Prefabs.beebox.fn` 内部精准剥离原厂的 `updatelevel` 贴图更新函数，避免因重写 `harvestable:SetUp` 导致蜂箱蜂蜜满载动画锁死的视觉 Bug；
2. **仇恨目标动态置空技巧（Nil Target Pacification）**：在调用 `childspawner:ReleaseAllChildren(picker)` 时，若玩家穿戴养蜂帽，则传入 `nil`，使蜜蜂离巢但绝不建立攻击仇恨，实现“蜜蜂散步而不叮人”的拟真质感；
3. **春季范围索敌过滤器动态重写（Spring Retarget Interception）**：覆写 `bee` 的 `combat:SetRetargetFunction`，在春季索敌闭包中注入 `HasBeehatEquipped(guy)` 豁免断言，实现全天候生态伪装。

---

## 二、四大硬核核心技术解构

### 1. 经典 UpvalueHacker 原理与深度递归遍历
- **技术难点**：官方在定义蜂箱预制体时，将蜂蜜阶段贴图动画函数 `local function updatelevel(inst)` 定义为内部私有闭包，未挂载在实体或组件上。普通 Mod 重写 `SetUp` 时无法调用该函数。
- **神级攻防**：
  ```lua
  local function FindUpvalueHelper(fn, name)
      local i = 1
      while debug.getupvalue(fn, i) and debug.getupvalue(fn, i) ~= name do
          i = i + 1
      end
      local name, value = debug.getupvalue(fn, i)
      return value, i
  end

  UpvalueHacker.FindUpvalue = function(fn, ...)
      local prv, i, prv_var = nil, nil, "(the starting point)"
      for j, var in ipairs({...}) do
          prv = fn
          prv_var = var
          fn, i = FindUpvalueHelper(fn, var)
      end
      return fn, i, prv
  end
  ```
  在 `AddPrefabPostInit("beebox")` 中，仅凭两行代码即可将藏在闭包深处的 `updatelevel` 动态提取，无侵入式重新注入新的 `harvestable:SetUp` 中！

### 2. 生态仇恨动态置空技巧（Target Nullification）
- 官方 `childspawner:ReleaseAllChildren(target)` 的源码设计是：
  - 若 `target ~= nil`，强制让释放出的子代实体 `combat:SuggestTarget(target)`；
  - 若 `target == nil`，子代实体仅被激发移出巢穴（Spawning Out），进入闲置警戒或游荡漫步状态。
- **MOD 巧妙分流**：
  ```lua
  local function BeeNiceFn(inst, picker)
      if HasBeehatEquipped(picker) then
          if ReleaseBees then
              inst.components.childspawner:ReleaseAllChildren(nil) -- 传 nil，和平出巢
          end
          if HatDecay then
              -- 扣除 2% 护甲耐久作为采蜜磨损代价
              local beehat = picker.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
              if beehat.components.armor then
                  beehat.components.armor:SetPercent(beehat.components.armor:GetPercent() - 0.02)
              end
          end
      else
          inst.components.childspawner:ReleaseAllChildren(picker) -- 原版愤怒反击
      end
  end
  ```
  既赋予了装备独特的战术价值，又提供了磨损开销选项，维持了硬核生存的平衡尺度。

### 3. 春季季节状态驱动的索敌过滤器覆写（Spring Retarget Override）
- 在春季，野生蜜蜂的行为树（Brain）会被红温状态接管。MOD 针对全图 `bee` 注入动态索敌过滤器：
  ```lua
  local function SpringBeeRetarget(inst)
      return GLOBAL.TheWorld.state.isspring and
          GLOBAL.FindEntity(inst, 4,
              function(guy)
                  -- 关键伪装判定：穿戴蜂帽的玩家直接豁免！
                  return not HasBeehatEquipped(guy) and inst.components.combat:CanTarget(guy)
              end,
              { "_combat", "_health" },
              { "insect", "INLIMBO" },
              { "character", "animal", "monster" })
          or nil
  end

  AddPrefabPostInit("bee", function(inst)
      if inst.components.combat then
          inst.components.combat:SetRetargetFunction(2, SpringBeeRetarget)
      end
  end)
  ```
  精准在 2 秒周期的索敌检测中实现动态目标剔除，零性能消耗。

### 4. 跨模组兼容性探测（Cross-Mod Compatibility Sniffing）
- 考虑到工坊热门模组（如 `DST Fish Farm` 鱼塘）也采用了类似的 `harvestable` 采集与警报机制，MOD 显式通过 `KnownModIndex:GetModActualName("DST Fish Farm")` 进行环境嗅探，并在确认装载后对 `w_pond` 实施同构闭包注入，展现了工业级模组优秀的生态共存意识。

---

## 三、避坑实战经验

1. **`harvestable:SetUp` 重写必须兼顾 `iswinter` 冬眠判定**：
   - 官方蜂箱在冬季是冻结休眠的（`TheWorld.state.iswinter == true`）。若重写 `onharvest` 回调时未判断冬季，会导致玩家冬天采蜜时蜜蜂强行在暴风雪中被释放，由于环境极寒蜜蜂会立刻原地冻结坠地死亡，破坏生态物种平衡。
2. **多模组重复引入 `UpvalueHacker` 的命名污染**：
   - 如果多个 Mod 在全局作用域声明 `GLOBAL.UpvalueHacker`，后加载的模块可能会覆盖先加载的模块的函数表。必须将 `UpvalueHacker` 严格限定在当前模块的 `local` 命名空间内部，绝对禁止污染 `GLOBAL`！
