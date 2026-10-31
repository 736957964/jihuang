# 饥荒创意工坊深度研读报告：Smart Minisign（智能小木牌自动贴图与图集构建架构）

- **模组标识**：`1595631294` (`Smart Minisign / 智能小木牌自动贴图`)
- **作者**：小班花 mamjun1
- **版本**：v1.1.8
- **领域分类**：容器关闭事件驱动（`onclose`）、父子实体树链接绑定（`inst:AddChild` 与 `persists = false`）、跨 Mod 图集动态扫描构建（`ATLAS_BUILD` 注入）、包裹内容穿透解析（`unwrappable`）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 `modmain.lua`、`smart_minisign.lua` 组件与图集探测管线）

---

## 一、架构全貌与顶层设计思想

在饥荒联机版中，使用羽毛笔手动给小木牌（`minisign`）绘制箱子内的物品图案非常繁琐，且每次更换箱内存放的物资后都需要重新铲掉木牌重画。

`Smart Minisign` 是工坊中最经典的**自动化复合实体链接（Composite Entity Attachment）与全动态图集自建（Dynamic Atlas Compilation）**神作：
1. **复合实体父子树生命周期（Parent-Child Entity Tree）**：箱子创建时动态生成附属木牌，通过 `inst:AddChild(minisign)` 将木牌相对坐标锁定在箱体上，同时将木牌声明为 `persists = false`，仅保存箱子主体，彻底消除存盘重载时产生幽灵木牌的 Bug；
2. **容器 `onclose` 事件驱动贴图自动萃取**：监听玩家每次关闭箱子，自动取 1 号槽位的有效物品，提取其 `image` 与图集（`atlas`），直接注入小木牌的 `drawable` 组件完成自动画画；
3. **全工坊 Mod 动态图集编译引擎（Cross-Mod ATLAS_BUILD Compiler）**：拦截 `ModManager.RegisterPrefabs`，深度扫描全服已启用的所有 Mod 资源表，自动为普通 `ATLAS` 补齐小木牌渲染所需的 `ATLAS_BUILD` 格式，使第三方 Mod 物品也能被小木牌完美绘制！

---

## 二、四大硬核核心技术解构

### 1. 附属木牌的父子实体绑定与存盘隔离（`persists = false`）
- **传统劣质实现**：很多 Mod 生成木牌后独立保存在世界中，箱子被砸后木牌残留在空中；或者重载世界后箱子再次生成一个新木牌，导致成百上千个木牌重叠穿模。
- **神级工程解法**：
  ```lua
  function Smart_Minisign:LinkSign(minisign)
      self.sign = minisign
      self.inst:AddChild(minisign)
      minisign.Transform:SetPosition(0, 0, 0)
      -- 关键设计 1：标记不存盘！完全由箱子的 Smart_Minisign 组件在加载时重新 Spawn
      minisign.persists = false
      -- 关键设计 2：禁用原生可画标记，剥离燃烧与传播组件，防止引发次生火灾
      if minisign.components.drawable then
          minisign.components.drawable.candraw = false
      end
      if minisign.components.burnable then
          minisign:RemoveComponent("burnable")
      end
  end
  ```
  箱子烧毁时触发 `onburnt`，联动将附属木牌安全移除（`self.sign:Remove()`），父子实体状态机高度同步。

### 2. 全 Mod 图集动态扫描与 `ATLAS_BUILD` 自动编译
- **技术暗坑**：官方小木牌组件（`drawable`）要求贴图图集必须注册为 `ATLAS_BUILD`（包含 256x256 纹理图集元数据），而 99% 的第三方 Mod 仅注册了普通物品栏专用的 `ATLAS`，直接用在小木牌上会触发纹理缺失紫块崩溃。
- **解法**：在预制体注册阶段实施全局拦截编译：
  ```lua
  local oldRegisterPrefabs = GLOBAL.ModManager.RegisterPrefabs
  GLOBAL.ModManager.RegisterPrefabs = function(self)
      oldRegisterPrefabs(self)
      for _, modname in ipairs(enabledmods) do
          local mod = GLOBAL.ModManager:GetMod(modname)
          if mod.Assets then
              for _, v in ipairs(mod.Assets) do
                  if v.type == "ATLAS" and IsImageAtlas(v.file) then
                      -- 自动为普通图集补齐对应的 ATLAS_BUILD 注册！
                      local clean_path = string.gsub(v.file, "%.%./mods/[^/]+/", "", 1)
                      table.insert(Assets, Asset("ATLAS_BUILD", clean_path, 256))
                  end
              end
          end
      end
      -- 动态编译为全局虚拟 Prefab 并热装载入引擎显存
      GLOBAL.RegisterPrefabs(GLOBAL.Prefab("MOD_SMARTSIGNOTHER", nil, Assets, nil, true))
      GLOBAL.TheSim:LoadPrefabs({"MOD_SMARTSIGNOTHER"})
  end
  ```
  彻底打通了任意工坊 Mod 物品与原生小木牌渲染系统的底层壁垒！

### 3. 换肤物品即时生效（In-Place Skin Swapping）
- 若玩家将带皮肤的小木牌道具（`minisign_item`）丢入箱子，MOD 捕获到后立刻原地销毁当前木牌，并以该皮肤 ID 重新实例化：
  ```lua
  if changeskin and item.prefab == "minisign_item" then
      self.sign:Remove()
      local sign = SpawnPrefab("minisign", item.linked_skinname, item.skin_id)
      self:LinkSign(sign)
  end
  ```
  支持无成本切换小木牌外观造型。

### 4. 包裹穿透检测（Bundle Unwrapping Penetration）
- 当箱子中存放的是打包纸（Bundled Supplies / Gift Wrap）时，原生逻辑只能画出一个丑陋的包裹贴图。
- MOD 结合 `unwrappable` 组件穿透检查 `itemcomponents`，直接抓取包裹内部封存的第一件宝物的图集进行绘制，实现了“见图知物”的极致便利。

---

## 三、避坑实战经验

1. **复合子实体的 `persists = false` 铁律**：
   - 任何作为附属装饰（Attachment）生成的实体，必须显式赋值 `inst.persists = false`。若遗漏该语句，饥荒存盘时会将箱子和附属木牌分别作为两个独立实体写入存档文件，读档后父子链接丢失，箱子移走后木牌残留在原地，极度难以清理。
2. **`minisign.components.burnable` 必须移除**：
   - 由于木牌作为子实体与箱子坐标完全重叠，若保留木牌自带的 `burnable` 组件，在发生火灾时箱子和木牌会同时引燃并互相传火，导致火势扑灭难度呈指数级增加。主动移除子实体的引燃组件是标准防御范式。
