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


<a id="case-4"></a>

## 案例 4：高阶 BOSS 阶段转换与仇恨锁定（神话书说·黑风怪/辟寒大王）

> 来源工程：`神话书说 (1991746508)` / 核心文件：`scripts/prefabs/blackbear.lua` 与 `scripts/brains/blackbearbrain.lua`

### 1. 业务目标
实现多阶段 BOSS（血量阈值触发转阶段、狂暴吼叫全屏震慑、周期性特定技能冲撞、以及脱战回血软锁定）。

### 2. 核心架构设计
1. **血量监听与阶段切换**：利用 `health:SetOnHealthChangedFn` 监测血量百分比（如 < 50% 触发转阶段）；
2. **专属状态机注入（StateGraph）**：通过 `sg:GoToState("roar")` 强制打断当前所有动作进入咆哮无敌帧；
3. **行为树权重调度（Brain）**：使用 `PriorityNode` 分流攻击、放技能、冲刺与脱战逻辑。

### 3. 标准工程源码实现

```lua
-- scripts/prefabs/custom_boss.lua (主客机预制体)
local assets = {
    Asset("ANIM", "anim/bearger_build.zip"),
    Asset("ANIM", "anim/bearger_basic.zip"),
    Asset("SOUND", "sound/bearger.fsb"),
}

local prefabs = {
    "groundpound_fx",
    "collapse_small",
}

-- 阶段切换核心回调
local function OnHealthChanged(inst, data)
    if not inst.components.health:IsDead() then
        local percent = data.newpercent
        -- 触发 50% 狂暴阶段（仅触发一次）
        if percent < 0.5 and not inst.is_enraged then
            inst.is_enraged = true
            -- 强制切入咆哮无敌状态，震落周围玩家武器
            inst.sg:GoToState("roar")
            -- 狂暴数值强化
            inst.components.combat:SetDefaultDamage(150)
            inst.components.locomotor.runspeed = 10
            inst.components.combat:SetAttackPeriod(2.0)
        end
    end
end

-- 范围地震伤害判定（排除虚空和无敌目标）
local function DoGroundPound(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 8, { "_combat" }, { "INLIMBO", "flight", "FX" })
    for _, ent in ipairs(ents) do
        if ent:IsValid() and not ent:IsInLimbo() and ent ~= inst then
            if inst.components.combat:CanTarget(ent) then
                ent.components.combat:GetAttacked(inst, 80, nil, "groundpound")
                if ent.components.inventory and math.random() < 0.3 then
                    ent.components.inventory:DropEverything(false, true) -- 震落手持武器
                end
            end
        end
    end
    SpawnPrefab("groundpound_fx").Transform:SetPosition(x, y, z)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1000, 1.5)

    inst.AnimState:SetBank("bearger")
    inst.AnimState:SetBuild("bearger_build")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 服务端组件
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(6000)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(100)
    inst.components.combat:SetAttackPeriod(3.0)
    inst.components.combat:SetRange(4, 5)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 8

    inst:AddComponent("inspectable")

    -- 挂载状态机与行为树
    inst:SetStateGraph("SGcustom_boss")
    inst:SetBrain(require("brains/custom_bossbrain"))

    -- 监听血量变化
    inst:ListenForEvent("healthdelta", OnHealthChanged)
    inst.DoGroundPound = DoGroundPound

    return inst
end

return Prefab("custom_boss", fn, assets, prefabs)
```

```lua
-- scripts/brains/custom_bossbrain.lua (行为树逻辑)
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"

local CustomBossBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function CustomBossBrain:OnStart()
    local root = PriorityNode({
        -- 1. 狂暴状态下优先冲撞/地裂
        WhileNode(function() return self.inst.is_enraged and not self.inst.sg:HasStateTag("busy") end, "EnragedPound",
            DoAction(self.inst, function()
                if self.inst.components.combat.target and self.inst:GetDistanceSqToInst(self.inst.components.combat.target) < 64 then
                    self.inst.sg:GoToState("groundpound")
                end
            end)
        ),
        -- 2. 正常追击与普攻
        ChaseAndAttack(self.inst, 30, 40),
        -- 3. 闲置巡逻漫步
        Wander(self.inst, function() return self.inst:GetPosition() end, 15),
    }, 0.5)

    self.bt = BT(self.inst, root)
end

return CustomBossBrain
```

### 4. 关键踩坑点
1. **咆哮无敌帧状态标签**：在 SG 中必须给 roar 状态打上 `inst.sg:AddStateTag("busy")` 和 `inst.sg:AddStateTag("nosleep")`，防止在转阶段瞬间被催眠/冰冻打断导致状态永久卡死；
2. **脱战仇恨清理**：在 `ChaseAndAttack` 之外，必须在预制体中配置 `inst.components.combat:SetRetargetFunction(3, RetargetFn)`，并在失去视野时正确注销 `target`，否则 BOSS 会无限跨越地图追击玩家引发卡顿。

<a id="case-5"></a>

## 案例 5：现代客机响应式 HUD 悬浮面板与自定义 RPC 通信

> 来源工程：`蜘蛛纸牌 (spider_solitaire)` 与 `Sora 框架` / 核心文件：`scripts/widgets/screen.lua` 与 `modmain.lua`

### 1. 业务目标
实现一个客户端专属的 UI 面板（可拖拽、点击按钮触发服务器动作、服务端数据向客户端回传实时刷新）。

### 2. 核心架构设计
1. **客户端层级注入**：在 `AddClassPostConstruct("widgets/controls", ...)` 中向 `inst.top_root` 挂载根节点，保证不受缩放异常影响；
2. **客向主 RPC（User Action）**：通过 `SendModRPCToServer(MOD_RPC["MYMOD"]["CLICK_BTN"], ...)` 提交合法操作；
3. **���向客 RPC / NetVar 同步**：重要数值使用 `net_shortint` 等网络变量自动同步，避免频繁 RPC 丢包。

### 3. 标准工程源码实现

```lua
-- modmain.lua (注册 RPC 与网络交互)
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- 1. 注册客户端 -> 服务端 RPC
AddModRPCHandler("MY_MOD_UI", "TRIGGER_SKILL", function(player, skill_id)
    if player and player:IsValid() and not player:HasTag("playerghost") then
        -- 服务端校验：技能冷却与消耗
        if player.components.hunger and player.components.hunger.current >= 10 then
            player.components.hunger:DoDelta(-10)
            player.components.talker:Say("技能释放成功！消耗10饱食度")
        end
    end
end)

-- 2. 注入客机 HUD
AddClassPostConstruct("widgets/controls", function(self)
    local CustomPanel = require("widgets/custom_panel")
    self.custom_panel = self.top_root:AddChild(CustomPanel(self.owner))
    self.custom_panel:SetPosition(-100, 50, 0)
end)
```

```lua
-- scripts/widgets/custom_panel.lua (UI 控件实现)
local Widget = require("widgets/widget")
local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Text = require("widgets/text")

local CustomPanel = Class(Widget, function(self, owner)
    Widget._ctor(self, "CustomPanel")
    self.owner = owner

    -- 根背景底图
    self.bg = self:AddChild(Image("images/global.xml", "square.tex"))
    self.bg:SetSize(200, 100)
    self.bg:SetTint(0, 0, 0, 0.7)

    -- 标题文字
    self.title = self:AddChild(Text(BODYTEXTFONT, 20, "阿鲸快捷操作面板", { 1, 1, 1, 1 }))
    self.title:SetPosition(0, 30, 0)

    -- 触发按钮
    self.btn = self:AddChild(ImageButton())
    self.btn:SetPosition(0, -20, 0)
    self.btn:SetText("释放法术 (-10饱食)")
    self.btn:SetOnClick(function()
        -- 发送客机 RPC 到服务器执行业务
        SendModRPCToServer(MOD_RPC["MY_MOD_UI"]["TRIGGER_SKILL"], 1)
    end)
end)

return CustomPanel
```

### 4. 关键踩坑点
1. **客机幽灵态输入穿透**：玩家死亡变成幽灵（`playerghost`）时，UI 仍可能被点击，服务端处理 RPC 前**必须严密校验 `not player:HasTag("playerghost")`**；
2. **层级与遮罩冲突**：自定义面板不要直接挂在 `self`，必须挂在 `self.top_root` 下，否则打开暂停菜单（PauseScreen）或地图（MapScreen）时会导致渲染层级穿帮。

<a id="case-6"></a>

## 案例 6：高性能定时周期刷怪点与防卡顿清理机制（十面埋伏）

> 来源工程：`十面埋伏 (#MOD-shimianmaifu)` / 核心文件：`scripts/components/rp_monster_point.lua` 与 `rp_autodelete.lua`

### 1. 业务目标
实现类似塔防/入侵式的周期波次刷怪系统，同时确保实体超出距离或脱战超时时能够平滑自杀清理，防止服务器实体数量爆炸卡死。

### 2. 核心架构设计
1. **轻量级周期调度器**：利用 `inst:DoPeriodicTask` 或 `components/timer` 控制波次刷新；
2. **玩家密度与地皮安全检测**：在 `TheWorld.Map:IsPassableAtPoint` 校验合法刷怪坐标，避免刷在虚空或海面；
3. **带缓释特���的自动回收（`autodelete`）**：离开玩家视距超过 N 秒后触发溶解淡出并执行 `Remove()`。

### 3. 标准工程源码实现

```lua
-- scripts/components/wave_spawner.lua (服务端波次生成器)
local WaveSpawner = Class(function(self, inst)
    self.inst = inst
    self.wave_interval = 30 -- 每 30 秒一波
    self.max_alive = 10     -- 场上最大同屏存活
    self.spawned_monsters = {}
    self.is_active = false
end)

function WaveSpawner:Start()
    if self.task == nil then
        self.task = self.inst:DoPeriodicTask(self.wave_interval, function() self:SpawnWave() end)
    end
end

function WaveSpawner:SpawnWave()
    -- 清理已死亡或销毁的无效引用
    for k = #self.spawned_monsters, 1, -1 do
        local m = self.spawned_monsters[k]
        if not m:IsValid() or (m.components.health and m.components.health:IsDead()) then
            table.remove(self.spawned_monsters, k)
        end
    end

    if #self.spawned_monsters >= self.max_alive then
        return -- 达到上限，放弃本波生成防止崩服
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()
    local angle = math.random() * 2 * PI
    local radius = math.random(5, 12)
    local sx, sz = x + radius * math.cos(angle), z + radius * math.sin(angle)

    -- 必须校验地皮可通行性，防止生成在虚空或海中
    if TheWorld.Map:IsPassableAtPoint(sx, 0, sz) then
        local monster = SpawnPrefab("spider")
        monster.Transform:SetPosition(sx, 0, sz)

        -- 挂载自杀销毁组件，防止玩家逃跑后实体永久残留
        if monster.components.health then
            monster:DoTaskInTime(120, function()
                if monster:IsValid() and not monster.components.combat.target then
                    SpawnPrefab("small_puff").Transform:SetPosition(monster.Transform:GetWorldPosition())
                    monster:Remove()
                end
            end)
        end

        table.insert(self.spawned_monsters, monster)
    end
end

function WaveSpawner:OnRemoveFromEntity()
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

return WaveSpawner
```

### 4. 关键踩坑点
1. **防止 `table` 引用内存泄漏**：在记录生成的怪时，必须定期用逆序循环（`for k = #list, 1, -1`）清洗掉已经死亡或 `Remove()` 的无效实体句柄；
2. **生成前坐标校验（IsPassableAtPoint）**：许多刷怪 Mod 在地下或沿海区域刷怪时直接报错或掉落虚空，就是漏了地皮阻挡与海水判定。