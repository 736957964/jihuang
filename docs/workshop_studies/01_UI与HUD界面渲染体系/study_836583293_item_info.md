# 饥荒创意工坊深度研读报告：Item Info（客机物品信息增强与静态元数据快照缓存）

- **模组标识**：`836583293` (`Item Info / 物品信息悬停增强`)
- **作者**：Ryuu
- **版本**：v0.54
- **领域分类**：纯客机端物品元数据镜像缓存（Client-Side Metadata Snapshot）、`RegisterComponentActions` 拦截器防御、位面攻防（Planar Damage/Defense）解析、独立 HUD 槽位跟随渲染
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含 290KB 控件架构、图集与缓存器源码）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，很多客机 Mod 想要显示物品的“基础攻击力、护甲吸收比、位面伤害、保质期、保温系数”等数据。然而在非主机的客户端环境，地面或背包里的实体**没有完整的 `components`（大部分组件只在服务端存在）**。

`Item Info` 作为数百万玩家装机必备的纯客户端（`client_only_mod = true`）现象级 Mod，其核心架构突破在于：**静态沙盒探针与元数据镜像缓存引擎（CacheItem Engine）**。
1. 在客户端启动或首次遇到物品时，在内存沙盒中生成该预制体的静态原型快照；
2. 剥离出其基础属性并持久驻留在 `CACHED_ITEMS` 字典中；
3. 鼠标悬停槽位时，直接以极速 $O(1)$ 复杂度读取字典，结合客户端已知的耐久/新鲜度百分比，实时计算并渲染出精美的属性图文面板！

---

## 二、四大硬核核心技术解构

### 1. 客户端轻量属性镜像缓存器（CacheItem Architecture）
- **痛点**：客机上的 `item.components.weapon` 或 `item.components.armor` 是 nil。如果每帧去向服务端发 RPC 查询，网络带宽将不堪重负。
- **解法**：通过 `iteminfo_cacheitem.lua`，提取预制体不可变的“基因数据”：
  ```lua
  self.components.weapon.damage = inst.components.weapon.damage
  self.components.planardamage.basedamage = inst.components.planardamage:GetBaseDamage()
  self.components.armor.absorb_percent = inst.components.armor.absorb_percent
  self.components.armor.maxcondition = inst.components.armor.maxcondition
  ```
  不仅支持原版攻击与防御，还无缝兼容了 DST 最新的**位面攻击（Planar Damage）与位面防御（Planar Defense）**！

### 2. 探针实例化过程中的动作注册拦截防御（SPAWNING_ITEM Guard）
- **致命陷阱**：在客户端为了提取属性而临时 `SpawnPrefab(name)` 模拟实体时，引擎默认会触发所有 Mod 的 `RegisterComponentActions`，这会导致动作系统误以为场景中真实生成了可交互物体，引发不可预知的空指针崩溃或动作覆盖。
- **神级拦截**：
  在 `modmain.lua` 中注入全局类切面：
  ```lua
  AddGlobalClassPostConstruct("entityscript", "EntityScript", function(self)
      local oldRegisterComponentActions = self.RegisterComponentActions
      self.RegisterComponentActions = function(self, name)
          -- 当处于 ItemInfo 属性嗅探生成期，彻底静默动作注册！
          if not GLOBAL.MOD_ITEMINFO.SPAWNING_ITEM then
              return oldRegisterComponentActions(self, name)
          end
      end
  end)
  ```
  保证了客户端沙盒探针在嗅探数据时**完全处于隔离无害状态**，展现了极其深厚的设计功底！

### 3. 脱离 ItemSlot 缩放陷阱的独立 HUD 挂载（HUD Controls Embedding）
- 原版物品栏槽位 `ItemSlot` 会随着 HUD 缩放设置动态变形。若将信息弹窗直接作为子控件挂在 `slot` 下，弹窗文字会被严重挤压变形。
- MOD 将信息弹窗直接挂载在 `ThePlayer.HUD.controls`（顶层绝对坐标层）：
  ```lua
  slot.iteminfo = GLOBAL.ThePlayer.HUD.controls:AddChild(ItemInfoDesc(slot))
  ```
  通过矩阵全局变换计算槽位在屏幕上的真实绝对像素坐标，弹窗保持恒定比例（`INFO_SCALE`），视觉清晰稳定。

### 4. 复合时间换算引擎（Hours vs Days Formatter）
- 支持“小时/分钟/秒”与“游戏内天数（Days）”的动态切换，并在生鲜食物腐烂（Perishable）计算中，精准区分“变质临界点（Stale）”与“彻底腐烂点（Spoil）”，给予玩家精准预警。

---

## 三、避坑实战经验

1. **`TheNet:IsDedicated()` 绝对防御**：
   - 专用服务器（Dedicated Server）绝不能加载此类 UI 插件，在 `modmain.lua` 头部必须显式判定：
     ```lua
     if DST and GLOBAL.TheNet:IsDedicated() then return end
     ```
     杜绝在专服无头环境下调用 `ThePlayer.HUD` 导致的致命空指针。
2. **探针实体的即时销毁（`inst:Remove()`）**：
   - 在客户端沙盒读取完 `CacheItem` 属性后，必须在当前物理帧立即执行 `inst:Remove()`，绝不能让模拟探针实体遗留在世界场景树中，否则会造成客户端句柄泄漏。
