# 饥荒联机版（DST）经典 Mod 实战案例库

本案例库旨在提供可直接复制、结构标准、无废话的 Mod 开发参考模板。所有案例均经过主客机环境规范验证。

---

## 案例一：自定义武器与投射物（回旋镖/飞剑机制）

### 1. 核心需求
- 拥有独立耐久、攻击力
- 掷出后变为飞行投射物实体
- 飞行命中后反弹/折返，玩家可按空格（CATCH）捕获回手上

### 2. Prefab 源码：scripts/prefabs/custom_boomerang.lua

`lua
local assets = {
    Asset("ANIM", "anim/boomerang.zip"),
    Asset("ATLAS", "images/inventoryimages/custom_boomerang.xml"),
    Asset("IMAGE", "images/inventoryimages/custom_boomerang.tex"),
}

-- 掷出投射物回调
local function OnThrown(inst, owner, target)
    if owner.SoundEmitter then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    -- 暂存武器引用，避免飞行期间找不到原实体
    inst._original_owner = owner
end

-- 命中目标后折返
local function OnHit(inst, attacker, target)
    if target and target:IsValid() and attacker and attacker:IsValid() then
        -- 击中造成伤害后，将目标重定向为发射者，让投射物飞回
        inst.components.projectile:Throw(attacker, attacker)
    end
end

-- 被成功接住回调（CATCH 动作）
local function OnCaught(inst, catcher)
    if catcher and catcher.components.inventory then
        -- 重新直接装备在手上，若手上已满则进入背包
        catcher.components.inventory:Equip(inst)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("boomerang")
    inst.AnimState:SetBuild("boomerang")
    inst.AnimState:PlayAnimation("idle")

    -- 必须挂载投射物与捕获标签
    inst:AddTag("thrown")
    inst:AddTag("projectile")
    inst:AddTag("catchable")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    -- 背包与装备
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/custom_boomerang.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(function(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_boomerang", "swap_boomerang")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end)
    inst.components.equippable:SetOnUnequip(function(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end)

    -- 武器属性
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(45)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetProjectile("custom_boomerang")

    -- 投射物飞行组件
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(16)
    inst.components.projectile:SetCanCatch(true)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnCaughtFn(OnCaught)

    -- 耐久度
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(20)
    inst.components.finiteuses:SetUses(20)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    return inst
end

return Prefab("custom_boomerang", fn, assets)
`

---

## 案例二：技能树配置与属性联动（人物升级点技能）

详见 [14 - SkillTree 技能树系统](/14-skilltree/index) 中的第 9 节完整案例。

---

## 案例三：范围神器/法宝实战（以芭蕉扇/法杖为例）

### 1. 核心设计模式
在饥荒联机版中制作“大范围作用的法宝/神器”（如灭火、降温、群体击退、催眠、催熟等），**切忌在每帧或武器逻辑里死循环**。
官方与顶流 Mod（如《神话书说》ananafan.lua）的标准写法是：
1. **挂载专职动作组件**（如 an 扇子组件、spellcaster 施法组件、weapon 武器组件）；
2. **在回调中以目标/玩家为中心进行空间检索**（TheSim:FindEntities）；
3. **严格配置过滤标签（Tag Filter）**，排除掉无实体、特效与幽灵，只对目标组件（urnable、	emperature、combat 等）进行批处理。

### 2. 标准 Prefab 完整源码（scripts/prefabs/magic_aoe_fan.lua）

`lua
local assets = {
    Asset("ANIM", "anim/bananafan.zip"),
    Asset("ATLAS", "images/inventoryimages/magic_aoe_fan.xml"),
}

-- 核心生效逻辑回调
local function OnUse(inst, target)
    -- 1. 改变世界天气/湿度（联动世界状态）
    if TheWorld and not TheWorld.state.israining then
        TheWorld:PushEvent("ms_forceprecipitation", true) -- 强行降雨
    end

    -- 2. 获取使用点/目标的绝对世界坐标
    local x, y, z = (target or inst).Transform:GetWorldPosition()

    -- 3. 核心 API：TheSim:FindEntities(x, y, z, 搜索半径, 必须包含Tags, 必须排除Tags, 任意命中Tags)
    -- 排除 FX 特效、不可点击项、背包内实体、玩家幽灵，提升查询效率
    local must_have_tags = nil
    local cant_have_tags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }
    local one_of_tags = { "smolder", "fire", "player", "monster" }

    local ents = TheSim:FindEntities(x, y, z, 24, must_have_tags, cant_have_tags, one_of_tags)

    -- 4. 针对不同组件做安全检查与批量影响
    for _, ent in ipairs(ents) do
        -- (a) 扑灭火焰与冒烟
        if ent.components.burnable then
            if ent.components.burnable:IsBurning() then
                ent.components.burnable:Extinguish()
            elseif ent.components.burnable:IsSmoldering() then
                ent.components.burnable:SmotherSmolder()
            end
        end

        -- (b) 范围强制降温（防中暑）
        if ent.components.temperature then
            ent.components.temperature:DoDelta(-25)
        end

        -- (c) 针对敌对生物造成击退或硬直
        if ent.components.combat and ent:HasTag("monster") then
            ent.components.combat:GetAttacked(inst, 30, nil) -- 造成 30 点范围法术伤害
        end
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bananafan")
    inst.AnimState:SetBuild("bananafan")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fan")

    inst.entity:SetPristine()
    -- 主客机隔离边界：客机到此为止
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/magic_aoe_fan.xml"

    -- 核心扇子组件
    inst:AddComponent("fan")
    inst.components.fan:SetOnUseFn(OnUse)

    -- 有限耐久，每次使用消耗 1 点，用完销毁
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.FAN, 1)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("magic_aoe_fan", fn, assets)
`

### 3. 开发避坑点
1. **TheSim:FindEntities 严禁滥用**：该函数是在底层 C++ 引擎中做空间加速八叉树遍历，不要在 OnUpdate 每帧调用；只在触发动作或技能瞬间调用一次；
2. **INLIMBO 标签必须排除**：进入箱子或玩家背包的实体会被打上 INLIMBO 标签，如果不排除，搜寻半径内的玩家背包里的物品也会被检索并误伤！
