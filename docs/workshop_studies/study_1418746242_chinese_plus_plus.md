# 饥荒创意工坊深度研读报告：Chinese++（动态字体管线与国际化切面重写架构）

- **模组标识**：`1418746242` (`Chinese++ / 汉化增强与高清字体引擎`)
- **作者**：EvenMr
- **版本**：v1.2.1
- **领域分类**：底元字体引擎重置（TheSim Unload/LoadFont）、多层 Upvalue 路径检索（`getval/setval`）、国际化字符串表动态补丁（`TranslateStringTable`）、多 Mod 配置热融合（`mergeinfo`）
- **研读基准**：通过 `steamcmd` 实时拉取工坊原版文件（含完整解压后的 470 行纯纯干货 `modmain.lua` 与字体管线）

---

## 一、架构全貌与顶层设计思想

在饥荒模组生态中，语言包和字体增强 Mod 往往面临极高崩溃率：官方游戏字体加载时机极早，若粗暴替换 TTF 容易引发内存泄漏（OOM）；第三方 Mod 英文原版硬编码字符在进入游戏后无法被翻译；活动副本（如暴食 Quagmire / 熔炉 LavaArena）复杂的动态模板字符串在汉化后格式化占位符错位。

`Chinese++` 是饥荒工坊公认的**底层元编程（Metaprogramming）与引擎管线重构典范**：
1. **点阵与矢量字型管线热重载（Font Pipeline Hot-Reload）**：动态调用 `TheSim:UnloadFont` / `RegisterPrefab` / `SetupFontFallbacks`，在不重启游戏进程的前提下替换全服 17 种不同字号字体的渲染后端；
2. **多级 Upvalue 路径访问器（Path-based Upvalue Accessor）**：独创类似 XPath 的点分路径检索器（`getval(fn, "a.b.c")` 与 `setval`），精准穿透官方地图生成任务树与预设列表；
3. **活动上下文动态状态机翻译器（Contextual Speech Filter）**：针对带参数插值的非结构化 NPC 台词，通过正则掩码（`create_mask`）动态逆向还原语义并灌注译文。

---

## 二、四大硬核核心技术解构

### 1. 引擎级字体管线原子重载（TheSim Font Hot-Swap）
- **痛点**：直接覆盖全局字体变量会导致已实例化的 Text 控件继续持有旧纹理指针，引发紫块与内存泄露。
- **解法**：在 `Start` 与 `ModManager.RegisterPrefabs` 阶段触发全套原子重构：
  ```lua
  TheSim:UnloadFont("cnfont")
  TheSim:UnloadFont("cnfont_outline")
  TheSim:UnloadPrefabs({"cnfonts_"..modname})
  TheSim:RegisterPrefab("cnfonts_"..modname, Assets, {})
  TheSim:LoadPrefabs({"cnfonts_"..modname})
  TheSim:LoadFont(font_path, "cnfont")
  TheSim:SetupFontFallbacks("cnfont", GLOBAL.DEFAULT_FALLBACK_TABLE)
  ```
  完成加载后，批量将 `DEFAULTFONT`、`NUMBERFONT`、`TALKINGFONT` 等 17 种 UI 字体句柄平滑指向新字型，字体清晰度与抗锯齿提升数倍且永不漏字。

### 2. 点分路径多级闭包穿透器（Path-based Upvalue Accessor）
相较于普通 UpvalueHacker 只能找单层变量，`Chinese++` 实现了基于点分路径（Dot-Separated Path）的高级解析器：
```lua
function getval(fn, path)
    local val = fn
    for entry in path:gmatch("[^%.]+") do
        local i = 1
        while true do
            local name, value = debug.getupvalue(val, i)
            if name == entry then
                val = value
                break
            elseif name == nil then return nil end
            i = i + 1
        end
    end
    return val, i
end
```
借助该原语，MOD 可以在 `FrontEnd` 初始化阶段，仅用两行代码 `getval(tasksets.GetGenTaskLists, "taskgrouplist")`，直接抓取到藏在闭包深处的官方世界生成任务组并完成汉化补丁！

### 3. 多 Mod 配置热融合与元数据合并（`mergeinfo` Engine）
- 当多个第三方 Mod 未提供中文时，MOD 通过拦截 `KnownModIndex.InitializeModInfo`：
  - 自动嗅探第三方 Mod 的 `configuration_options`；
  - 将中文描述、Label、Hover 提示注入其配置树中（`mergeinfo`）；
  - 甚至在设置菜单中动态注入“全部汉化/仅设置汉化/不汉化”的级联开关，实现了真正的“Mod 管理器之上建立生态代理层”。

### 4. 正则模板反向推导器（Mask Reverse Formatter）
- 面对复杂台词（如暴食山羊妈妈的需求提示 `"I crave ... in ..."`）：
  通过 `create_mask` 将原始模板字串逆向构造为捕获组正则：
  ```lua
  local function create_mask(str)
      str = string.gsub(str, "%.", "%%.")
      str = string.gsub(str, "%b{}", "%(%.%+%)")
      str = string.gsub(str, "%%s", "%(%.%+%)")
      return "^" .. str .. "$"
  end
  ```
  实时从 NPC 发言中解构出关键食材与时间参数，再代入目标语言的 `STRINGS` 模板重新格式化，完美攻克非结构化文本的国际化难题！

---

## 三、避坑实战经验

1. **Dedicated 专服无头环境绝对静默**：
   - 字体加载与文字渲染完全是客户端功能。MOD 严格在头部判定 `if GLOBAL.TheNet:IsDedicated() then return end`，避免在无显卡的 Linux 专服上调用 `TheSim:LoadFont` 触发引擎 SIGSEGV 崩溃。
2. **Lua 字符串模式匹配中文支持补丁**：
   - 原版 Lua 5.1 的 `%w` 仅支持 ASCII 字母数字。为了防止正则匹配漏掉中文字符，MOD 注入了底层切面：
     ```lua
     local oldmatch = string.match
     function string.match(str, pattern, index)
         return oldmatch(str, pattern:gsub("%%w", "[%%w一-鿕]"), index)
     end
     ```
     彻底解决了在中文环境下用 `%w` 无法匹配汉字导致搜索和文本过滤失效的深坑。
