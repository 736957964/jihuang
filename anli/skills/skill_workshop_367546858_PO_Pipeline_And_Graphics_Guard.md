# 饥荒一线工坊深度研读 Skill：GNU gettext PO 字典驱动与图形管线保护切面

- **工坊 ID**：367546858 (`中文语言包`)
- **领域分类**：C++ 级 GNU gettext PO 字典管道（`LoadPOFile`）、全量字符串表遍历覆写（`TranslateStringTable`）、图形选项防崩保护（`SmallTexturesMode`）
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发多语言国际化大型 Mod 或生态级语言包时，直接在 Lua 层写庞大的字串表不仅效率低下，且极易引发内存泄漏与版本冲突。官方推荐的标准架构为：
1. **PO 字典文件加载**：调用底层引擎 API `LoadPOFile(filename, lang_code)`；
2. **全量字串映射刷新**：调用 `GLOBAL.TranslateStringTable(target_table)`；
3. **显存纹理安全保护**：拦截图形设置，规避特定分辨率下的纹理贴图崩溃。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：国际化 PO 字典加载器与 Steam 语言自动握手 (modmain.lua)
-- ==============================================================================

local function InitInternationalization()
    local TheNet = GLOBAL.TheNet
    if not TheNet then return end

    -- 1. 嗅探 Steam 客户端环境语言
    local steam_lang = TheNet:GetLanguageCode() or "en"
    local target_lang = "chs"

    if steam_lang == "tchinese" or steam_lang == "zht" then
        target_lang = "cht"
    elseif steam_lang == "schinese" or steam_lang == "zh_CN" or steam_lang == "chs" then
        target_lang = "chs"
    end

    -- 2. 调用 Klei 底层 C++ PO 解析通道 (速度极快，内存占用几乎为零)
    local po_file = "languages/" .. target_lang .. ".po"
    if GLOBAL.LoadPOFile then
        GLOBAL.LoadPOFile(po_file, target_lang)
    end

    -- 3. 递归遍历翻译目标表 (将全局 STRINGS 批量转换为对应语言)
    if GLOBAL.TranslateStringTable and GLOBAL.STRINGS then
        GLOBAL.TranslateStringTable(GLOBAL.STRINGS)
    end
end

-- ==============================================================================
-- 范式 2：针对自定义 Mod 独立文本表的动态增量汉化
-- ==============================================================================

local function TranslateCustomModStrings(my_strings_table)
    if not my_strings_table or type(my_strings_table) ~= "table" then return end

    -- 借助原生 TranslateStringTable 对任意嵌套 Table 进行批量翻译
    if GLOBAL.TranslateStringTable then
        GLOBAL.TranslateStringTable(my_strings_table)
    end
end

-- ==============================================================================
-- 范式 3：图形选项小型纹理抗崩溃守卫 (防显存溢出与字库模糊)
-- ==============================================================================

local function ProtectGraphicsTextureMode()
    -- 严格防御：专服环境下不执行任何图形设置，防止空指针崩溃
    if GLOBAL.TheNet:IsDedicated() then return end

    AddClassPostConstruct("widgets/widget", function()
        local front_end = GLOBAL.TheFrontEnd
        if front_end and front_end:GetGraphicsOptions() then
            local gfx = front_end:GetGraphicsOptions()
            -- 若开启了容易引起汉字点阵贴图溢出的小型纹理，强制安全关闭
            if gfx:IsSmallTexturesMode() then
                gfx:SetSmallTexturesMode(false)
            end
        end
    end)
end

-- 启动初始化序列
InitInternationalization()
ProtectGraphicsTextureMode()

return {
    InitInternationalization = InitInternationalization,
    TranslateCustomModStrings = TranslateCustomModStrings,
}
```

---

## 三、避坑与生产安全准则

1. **`TheNet:IsDedicated()` 必须置于任何 UI / 显卡设置之前**：
   - 专服没有显卡上下文，调用 `TheFrontEnd:GetGraphicsOptions()` 会直接因为 `TheFrontEnd == nil` 引发服务器瞬间退服。因此客户端特性的代码必须加入严格的无头环境短路。
2. **PO 词典格式必须符合 GNU gettext 规范**：
   - `msgid` 与 `msgstr` 必须成对出现，且编码必须为严苛的 **UTF-8 No BOM** 格式。如果文件头部带 UTF-8 BOM（`\xEF\xBB\xBF`），Klei 引擎的 C++ 解析器会把第一行的词条视作乱码而直接跳过。
