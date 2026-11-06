# 联机版标准手持武器 Prefab 模版

## 概述

在开发饥荒联机版（DST）武器 MOD 时，武器 Prefab 必须兼顾客户端（网络同步、动画、物理碰撞）和服务端（战斗数值、攻击回调、伤害判定）。

缺少必要的网络组件或物理初始化，会导致实体在联机环境下不可见、浮空异常或客户端崩溃。

---

## 一、标准武器 Prefab 结构规范

标准武器通常位于 `scripts/prefabs/` 目录下，命名需与 Prefab ID 一致（如 `my_weapon.lua`）。

```lua
-- 1. 资源声明（动画与贴图）
local assets = {
    Asset("ANIM", "anim/spear.zip"),       -- 地面掉落动画
    Asset("ANIM", "anim/swap_spear.zip"),  -- 玩家手持覆盖动画
}

-- 2. 装备与脱下回调
local function onequip(inst, owner)
    -- 覆盖手部图层
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    -- 还原手部图层
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

-- 3. 攻击命中回调（可选）
local function onattack(inst, attacker, target)
    -- 在此处理附加特效、音效或额外状态
end

-- 4. 构造函数
local function fn()
    local inst = CreateEntity()

    -- 基础三件套与网络层（必须在服务端/客户端双端执行）
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- 物品物理包与动画
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("spear")
    inst.AnimState:PlayAnimation("idle")

    -- 标签设置（通常包含 sharp、pointy、weapon 等）
    inst:AddTag("sharp")
    inst:AddTag("pointy")

    -- 水上漂浮效果（DST专用）
    MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8}, true, -9)

    -- 网络实体初始化完成
    inst.entity:SetPristine()

    -- 关键隔离：以下组件仅服务端运行
    if not TheWorld.ismastersim then
        return inst
    end

    -- 武器组件
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(100) -- 设置基础攻击力
    inst.components.weapon:SetOnAttack(onattack)

    -- 检查组件
    inst:AddComponent("inspectable")

    -- 背包物品组件
    inst:AddComponent("inventoryitem")

    -- 可装备组件
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    -- 作祟逻辑
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("my_weapon", fn, assets)
```

---

## 二、关键要点说明

1. **`TheWorld.ismastersim` 隔离**：
   - 战斗伤害、背包存取、装备回调属于服务端逻辑，严禁在 `ismastersim` 检查之前挂载 `weapon` 或 `inventoryitem` 组件，否则客户端启动时会因缺失服务端环境而报错。
2. **`entity:SetPristine()` 的位置**：
   - 必须在挂载服务端独有组件之前调用，用于冻结网络初始数据包。
3. **动画通道重定向**：
   - 手持武器必须在 `onequip` 中使用 `OverrideSymbol` 替换人物的 `swap_object` 符号，并切换 `ARM_carry` / `ARM_normal` 的显隐。
