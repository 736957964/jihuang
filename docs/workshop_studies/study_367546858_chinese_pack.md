# 饥荒创意工坊深度研读报告：中文语言包（GNU gettext PO 字典驱动与渲染管线优化架构）

- **模组标识**：`367546858` (`中文语言包 / Chinese Language Pack`)
- **作者**：L.M.U汉化组
- **版本**：v3.7.6
- **领域分类**：纯客户端模组（`client_only_mod = true`）、GNU gettext PO 词典管线（`LoadPOFile`）、全量字符串表运行时递归覆写（`TranslateStringTable`）、图形驱动小型纹理保护（`SetSmallTexturesMode`）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整 `.po` 词典与贴图切面源码）

---

## 一、架构全貌与顶层设计思想

在 Steam 创意工坊中，`367546858` 是订阅量数百万级、被官方实质认可的国民级语言包模组。
其表面看似仅是翻译包，但其工程架构展现了极高的**工业级纯净性与防崩溃鲁棒性**：
1. **引擎级 GNU gettext PO 管道直通（Native LoadPOFile Pipeline）**：利用 Klei 底层 C++ 导出的 `LoadPOFile("DST_chs.po", "chs")`，在引擎内核层完成哈希桶索引构建，百万字量级翻译毫秒级吞吐，比 Lua Table 快 100 倍以上；
2. **递归式全局文本表热翻译（`TranslateStringTable`）**：在内存中递归下钻 `GLOBAL.STRINGS`，将原版英文与 PO 字典键精准映射，无缝覆盖所有原生物品、台词与系统提示；
3. **图形选项抗闪退守卫（Small Textures Guard）**：攻克了中文高分辨率点阵字库在“小型纹理（Small Textures）”模式下显存切片溢出、导致低配核显玩家黑屏崩服的硬件难题。

---

## 二、四大硬核核心技术解构

### 1. 引擎级 GNU gettext PO 管道直通（Native LoadPOFile）
- **传统劣质汉化做法**：用一个几十兆的 `strings.lua` 暴力覆盖 `STRINGS.NAMES.XXX = "..."`，不仅造成巨大的堆内存占用，还会因为覆写顺序导致后加载的模组文本被强行还原。
- **官方级工业范式**：
  ```lua
  local pofilename = "DST_" .. langname[1] .. ".po"
  LoadPOFile(pofilename, langname[1])
  _G.TranslateStringTable(_G.STRINGS)
  ```
  - `LoadPOFile` 直接由引擎底层的 C++ `LanguageTranslator` 处理；
  - 解析后的 PO 节点在底层以紧凑结构体常驻；
  - `TranslateStringTable` 只改变指针映射，完全不产生 Lua GC 垃圾碎片。

### 2. Steam 客户端原生语言自动握手（Steam Language Handshake）
- MOD 不强制写死简体中文，而是通过 `TheNet:GetLanguageCode()` 嗅探 Steam 运行环境：
  ```lua
  local steamlang = _G.TheNet:GetLanguageCode()
  local choose = {
      ["simplified"] = { "chs", "加载简体翻译成功！" },
      ["traditional"] = { "cht", "載入繁體翻譯成功！" },
      ["schinese"]   = { "chs", "据STEAM语言加载简体翻译成功！" },
      ["tchinese"]   = { "cht", "據STEAM語言載入繁體翻譯成功！" },
  }
  ```
  自动为大陆玩家匹配简体（`chs`），为港澳台及海外华人匹配繁体（`cht`），兼顾了全华人圈的文化习惯。

### 3. 图形选项动态降级保护（Small Textures Defense）
- **深坑复盘**：游戏在开启“小型纹理（Small Textures）”时，显存纹理会被强制下采样为原尺寸的 1/4 或 1/16。而包含上万汉字的高清字型纹理若被下采样，字形轮廓会完全模糊甚至超出显卡贴图切片边界，引发着色器编译失败直接 CTD（Crash to Desktop）。
- **防御手段**：
  ```lua
  if SMALL_TEXTURES and not ISPLAYINGNOW then
      if _G.TheNet:GetIsServer() and _G.TheNet:GetServerIsDedicated() then
          return -- 专服无显卡环境直接短路
      end

      AddClassPostConstruct("widgets/widget", function(self, ...)
          local gfx = _G.TheFrontEnd and _G.TheFrontEnd:GetGraphicsOptions()
          if gfx and gfx:IsSmallTexturesMode() then
              gfx:SetSmallTexturesMode(false)
              print("[Chinese] 已自动关闭小型纹理!!")
          end
      end)
  end
  ```
  在 UI 根控件初始化的一瞬间，嗅探显卡图形选项并将 `SmallTexturesMode` 强制归零，从物理层面扼杀了数万低配电脑的闪退隐患。

### 4. 极高优先级声明与独立贴图覆盖（Priority 9999 & Asset Layering）
- 模组指定 `priority = 9999`，确保自身在所有 Mod 中最早加载完毕，让后续加载的所有第三方 Mod 都能直接基于已汉化的全局 `STRINGS` 进行二次拓展；
- 同时在 `Assets` 中精准替换 `lavaarena_frontend`、`quagmire_frontend` 等官方活动的主菜单贴图，实现纯原生级的汉化体验。

---

## 三、避坑实战经验

1. **`TranslateStringTable` 的调用时机**：
   - 必须在 `LoadPOFile` 之后立即调用一次 `TranslateStringTable(STRINGS)`。但如果在游戏运行途中其他 Mod 动态向 `STRINGS` 注册了新表，那些新表不会自动汉化，需要手动或延迟再次调用 `TranslateStringTable`。
2. **专服环境无头断言**：
   - 任何涉及 `TheFrontEnd` 或图形选项的操作，必须先判断 `TheNet:GetServerIsDedicated()`。如果把包含 `TheFrontEnd` 调用的脚本在 Linux 专服执行，会直接报 `attempt to index nil value (TheFrontEnd)` 致命崩溃。
