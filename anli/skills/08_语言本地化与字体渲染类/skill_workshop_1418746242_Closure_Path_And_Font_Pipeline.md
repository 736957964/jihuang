# 饥荒一线工坊深度研读 Skill：点分路径闭包穿透与引擎级字体热载技术

- **工坊 ID**：1418746242 (`Chinese++`)
- **领域分类**：点分路径 Upvalue 访问器（Path-based Upvalue Accessor）、引擎字体原子热重载（TheSim Font Hot-Swap）、正则模板逆向解构、全角字符匹配补丁
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在对饥荒底层核心模块（如地图生成、事件台词、原生字体渲染、配置树）进行深层切面改造时，普通的 Hook 手段往往鞭长莫及。`Chinese++` 树立了顶级的元编程标杆：
1. **点分路径穿透器**：用形如 `"manager.cache.registry"` 的路径逐层下钻闭包；
2. **原子化字体注册序列**：`Unload -> RegisterPrefab -> LoadPrefabs -> LoadFont -> SetupFontFallbacks`；
3. **中文模式匹配 `%w` 扩展补丁**。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：点分路径闭包深度检索与修改器 (scripts/tools/closure_path_accessor.lua)
-- ==============================================================================

local ClosurePath = {}

--- 沿点分路径深入查找嵌套函数中的闭包变量 (Upvalue)
--- @param start_fn function 起始函数
--- @param path string 目标路径 (例如 "tasksets.grouplist" 或 "cache.items")
--- @return any 变量值
--- @return number 变量在闭包中的索引
--- @return function 包含该变量的父级函数句柄
function ClosurePath.Get(start_fn, path)
    if type(start_fn) ~= "function" or type(path) ~= "string" then return nil end

    local current = start_fn
    local parent = nil
    local target_idx = nil

    for segment in string.gmatch(path, "[^%.]+") do
        local i = 1
        local found = false
        while true do
            local name, val = debug.getupvalue(current, i)
            if not name then break end
            if name == segment then
                parent = current
                target_idx = i
                current = val
                found = true
                break
            end
            i = i + 1
        end
        if not found then return nil end
    end

    return current, target_idx, parent
end

--- 沿点分路径热修改嵌套闭包变量
function ClosurePath.Set(start_fn, path, new_value)
    local val, idx, parent = ClosurePath.Get(start_fn, path)
    if parent and idx then
        debug.setupvalue(parent, idx, new_value)
        return true
    end
    return false
end

-- ==============================================================================
-- 范式 2：引擎级字体原子化热重载序列 (scripts/tools/engine_font_swapper.lua)
-- ==============================================================================

local function HotReloadEngineFont(font_zip_path, font_name, font_fallback_table)
    local TheSim = GLOBAL.TheSim
    if not TheSim or GLOBAL.TheNet:IsDedicated() then return end

    -- 1. 卸载旧字体句柄与预制体缓存
    TheSim:UnloadFont(font_name)
    TheSim:UnloadPrefabs({ "font_package_" .. font_name })

    -- 2. 注册并装载包含新字体 ZIP 的虚拟 Prefab
    local assets = { GLOBAL.Asset("FONT", font_zip_path) }
    TheSim:RegisterPrefab("font_package_" .. font_name, assets, {})
    TheSim:LoadPrefabs({ "font_package_" .. font_name })

    -- 3. 加载新字体并装载回退字符集
    TheSim:LoadFont(font_zip_path, font_name)
    if font_fallback_table then
        TheSim:SetupFontFallbacks(font_name, font_fallback_table)
    end
end

-- ==============================================================================
-- 范式 3：Lua 模式匹配中文扩展补丁 (修复 %w 无法匹配中文)
-- ==============================================================================

local function PatchChinesePatternMatching()
    local old_match = string.match
    string.match = function(str, pattern, index)
        if pattern and string.find(pattern, "%%w") then
            -- 将 %w 扩展为包含汉字 Unicode 范围 (一-鿕)
            pattern = string.gsub(pattern, "%%w", "[%%w一-鿕]")
        end
        return old_match(str, pattern, index)
    end
end

return {
    ClosurePath = ClosurePath,
    HotReloadEngineFont = HotReloadEngineFont,
    PatchChinesePatternMatching = PatchChinesePatternMatching,
}
```

---

## 三、避坑与生产安全准则

1. **`UnloadFont` 后的 Fallback Table 重新绑定**：
   - 每次调用 `TheSim:LoadFont` 后，必须紧跟 `TheSim:SetupFontFallbacks`。若遗漏回退表设置，当文本中出现特殊标点、希腊字母或冷僻字时，整个字符串会静默变成完全不渲染的空白，极其隐蔽！
2. **点分路径断言防御**：
   - 官方游戏在小版本更新后可能会重命名局部变量。在生产代码中使用 `ClosurePath.Set` 之前，必须对返回值 `parent` 和 `idx` 做严格的 `if parent and idx then` 断言，严禁无检查调用 `debug.setupvalue` 导致游戏在启动阶段死锁。
