# 饥荒一线工坊深度研读 Skill：闭包穿透黑客（Upvalue Hacker）与跨边界到达距离补偿机制

- **工坊 ID**：1467214795 (`Island Adventures`)
- **领域分类**：函数深层闭包注入、跨地皮/海岸边界到达距离补偿（Arrive Dist）、热重载防御
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发大型或深度修改游戏规则的 MOD 时，开发者常面临两大天花板：
1. **官方变量深锁闭包**：关键变量在某个本地函数内部定义，没有挂在组件上，普通 Hook 根本读写不到；
2. **跨地皮边界移动器卡死**：玩家在陆地（可通行），目标在水里/虚空边缘（不可通行），底层寻路（Locomotor）因为到达距离不足导致角色原地踱步抽搐。

`Island Adventures` 提供了两个标准的工业级解法。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：轻量无环 Upvalue 查找与热替换器 (scripts/tools/upvalue_hacker.lua)
-- ==============================================================================

local UpvalueHacker = {}

--- 递归检索指定函数内部的局部变量 (Upvalue)
--- @param target_fn function 目标函数句柄
--- @param var_name string 要查找的局部变量名
--- @param max_depth number? 最大递归深度 (默认 5)
function UpvalueHacker.GetUpvalue(target_fn, var_name, max_depth)
    max_depth = max_depth or 5
    if type(target_fn) ~= "function" or max_depth <= 0 then return nil end

    local i = 1
    while true do
        local name, val = debug.getupvalue(target_fn, i)
        if not name then break end
        if name == var_name then
            return val, i, target_fn
        end
        -- 若 upvalue 是函数，向深层递归
        if type(val) == "function" then
            local deep_val, deep_i, deep_fn = UpvalueHacker.GetUpvalue(val, var_name, max_depth - 1)
            if deep_val ~= nil then
                return deep_val, deep_i, deep_fn
            end
        end
        i = i + 1
    end
    return nil
end

--- 安全设置指定函数内部的局部变量
function UpvalueHacker.SetUpvalue(target_fn, var_name, new_val)
    local val, i, fn = UpvalueHacker.GetUpvalue(target_fn, var_name)
    if fn and i then
        debug.setupvalue(fn, i, new_val)
        return true
    end
    return false
end

-- ==============================================================================
-- 范式 2：跨地皮/海岸边缘动作到达距离安全补偿 (Shore-to-Ocean Pick Compensation)
-- ==============================================================================

local function RegisterArriveDistCompensation()
    local old_PICKextra_arrive_dist = ACTIONS.PICK.extra_arrive_dist

    ACTIONS.PICK.extra_arrive_dist = function(doer, dest, ...)
        -- 保留前置 Mod 的补偿距离
        local base_dist = old_PICKextra_arrive_dist and old_PICKextra_arrive_dist(doer, dest, ...) or 0

        if dest ~= nil and dest.inst and dest.inst:HasTag("mussel_farm") then
            local tx, ty, tz = dest:GetPoint()
            -- 判定执行者在陆地，目标位于海洋地皮
            if TheWorld.Map:IsOceanTileAtPoint(tx, 0, tz) 
                and not TheWorld.Map:IsPassableAtPoint(tx, 0, tz)
                and doer:IsOnPassablePoint() then
                return base_dist + 1.2 -- 给予额外 1.2 码容差，防止贴岸抽搐
            end
        end

        return base_dist
    end
end

return {
    UpvalueHacker = UpvalueHacker,
    RegisterArriveDistCompensation = RegisterArriveDistCompensation,
}
```

---

## 三、避坑与生产安全准则

1. **Upvalue 深度穿透递归深度约束**：
   - Lua 闭包层级可能非常深甚至出现互相引用的复杂场景。检索时必须传入 `max_depth` 限制，严禁无限递归造成栈溢出崩溃。
2. **`extra_arrive_dist` 绝对不能无条件扩大**：
   - 必须通过 `TheWorld.Map:IsOceanTileAtPoint` 与 `doer:IsOnPassablePoint()` 双向交叉校验。若无脑扩大所有采集动作的到达距离，会导致玩家隔着高墙或长距离隔空吸取物品，彻底破坏游戏平衡与手感。
