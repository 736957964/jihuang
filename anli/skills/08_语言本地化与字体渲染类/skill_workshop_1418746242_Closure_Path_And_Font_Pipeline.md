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


## 五、进阶拓扑演进与变体分支

### 变体演进：LANGUAGE (Mod 3736719605)
- **变体场景与切面**：收录来自工坊 Mod 3736719605 (`LANGUAGE`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3736719605)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddComponentPostInit:talker

AddComponentPostInit('talker', function(Talker)
    local _ShutUp = Talker.ShutUp
    function Talker:ShutUp(...)
        if self.inst.components.wordplayer then
            self.inst.components.wordplayer:Stop()
        end
        return _ShutUp(self, ...)
    end
end)

```



### 变体演进：LANGUAGE (Mod 3789703667)
- **变体场景与切面**：收录来自工坊 Mod 3789703667 (`LANGUAGE`) 的生产级切面。
- **核心切面代码**：
```lua
-- ============================================================================
-- 生产级架构复刻切面范式 (提取自 Mod 3789703667)
-- ============================================================================
local GLOBAL = GLOBAL

-- 切面钩子：AddPrefabPostInit:cave_exit

AddPrefabPostInit("cave_exit", function(inst)
    if not TheWorld.ismastersim or not TheWorld:HasTag("cave") then
        return inst
    end

    inst:DoTaskInTime(0, function ()

        CAVE_ENTRANCE_COUNT = CAVE_ENTRANCE_COUNT + 1
        local sunken_boat, balloon_basket
        TheWorld.meta.patcher = TheWorld.meta.patcher or {}
        if TheWorld.meta.patcher.iac_spawnedsunken_boat then
            if TheWorld.meta.patcher.iac_spawneddeflated_balloon then
                return -- 都生成过了直接返回
            end
            sunken_boat = true -- 标记只生成了沉船
        end
        -- 寻找洞口附近天光
        local cavelight = FindEntity(inst, 20,
            function(ent)
                if ent.prefab ~= "cavelight" then
                    return false
                end
                -- 到第7个楼梯还没生成，那就不管周围有没有物品了
                if CAVE_ENTRANCE_COUNT >= 8 then
                    return true
                end
                -- 且该天光范围内不能有其他非天光也非楼梯的实体
                if not FindEntity(ent, 4, function (item) return item.prefab ~= "cave_exit" end, 
                nil, {"daylight", "INLIMBO", "FX", "NOCLICK"}) then
                    return true
                end
                return false
            end,
            {"daylight", "sinkhole"}
        )
        -- 生成 沉船 / 泄气气球&柳条篮
        if cavelight and cavelight:IsValid() then
            local pos = cavelight:GetPosition()
            if not sunken_boat then
                -- 沉船
                sunken_boat = SpawnPrefab("sunken_boat")
                sunken_boat.Transform:SetPosition(pos.x, 0, pos.z)
                TheWorld.meta.patcher.iac_spawnedsunken_boat = true
                print("[IAC] Spawned the sunken_boat in cave; Exit NO." .. tostring(CAVE_ENTRANCE_COUNT))
                -- 眼骨
                if IAC_CHESTER_EYEBONE then
                    local theta = math.random() * TWOPI
                    local radius = 4
                    local pt = pos
                    local offset = FindWalkableOffset(pt, theta, radius, 12, true)

                    if offset then
                        local newPos = pt + offset
                        if TheWorld.Map:IsVisualGroundAtPoint(newPos.x, 0, newPos.z) then
                            local chester_eyebone = SpawnPrefab("chester_eyebone")
                            chester_eyebone.Transform:SetPosition(newPos:Get())
                            print("[IAC] Spawned the chester_eyebone in cave; Exit NO." .. tostring(CAVE_ENTRANCE_COUNT))
                        end
                    end
                end
            else-- 柳条篮
                balloon_basket = SpawnPrefab("deflated_balloon_basket")
                balloon_basket.Transform:SetPosition(pos.x, 0, pos.z)
                TheWorld.meta.patcher.iac_spawneddeflated_balloon = true
                print("[IAC] Spawned the deflated_balloon_basket in cave; Exit NO." .. tostring(CAVE_ENTRANCE_COUNT))
                -- 泄气气球
                local theta = math.random() * TWOPI
                local radius = 7
                local pt = pos
                local offset = FindWalkableOffset(pt, theta, radius, 12, true)

                if offset then
                    local newPos = pt + offset
                    if TheWorld.Map:IsVisualGroundAtPoint(newPos.x, 0, newPos.z) then
                        local basket = SpawnPrefab("deflated_balloon")
                        basket.Transform:SetPosition(newPos:Get())
                        print("[IAC] Spawned the deflated_balloon in cave; Exit NO." .. tostring(CAVE_ENTRANCE_COUNT))
                    end
                end
            end
        end
        -- 最后一个洞穴出口汇报失败 (别问，问就是官方硬编码楼梯数量为10)
        if CAVE_ENTRANCE_COUNT == 10 then
            if not TheWorld.meta.patcher.iac_spawnedsunken_boat then
                print("[IAC] UH OH! We couldn't find a spot in the world for the sunken_boat in cave!")
            end
            if not TheWorld.meta.patcher.iac_spawneddeflated_balloon then
                print("[IAC] UH OH! We couldn't find a spot in the world for the deflated_balloon_basket in cave!")
            end
        end

    end)
end)

```

