# 饥荒一线工坊深度研读 Skill：生态防御降级与生物索敌过滤覆写技术

- **工坊 ID**：361994110 (`Bee Nice`)
- **领域分类**：战斗索敌切面（Combat Retargeting）、UpvalueHacker 闭包劫持还原、生态警报降级（Nil Target Spawning）、季节状态联动
- **研读基准**：Steam 创意工坊在线原版源码

---

## 一、核心实现原理与架构全貌

在开发“生物伪装服、生态图腾、巢穴无害化采集、特定派系免伤机制”时：
1. **闭包深度劫持**：用私有 `UpvalueHacker` 抓取原版未暴露的私有视图函数（如 `updatelevel`）；
2. **生成警报置空**：调用 `childspawner:ReleaseAllChildren(nil)`，使防卫生物涌出但不建立攻击仇恨；
3. **索敌过滤器拦截**：覆写 `combat:SetRetargetFunction`，在生物周期性寻敌闭包中注入玩家装备或 Buff 豁免断言。

---

## 二、标准化生产级代码范式 (可直接移植)

```lua
-- ==============================================================================
-- 范式 1：轻量私有级 Upvalue 闭包深度提取工具 (不污染 GLOBAL)
-- ==============================================================================

local function ExtractUpvalue(fn, target_name)
    if type(fn) ~= "function" then return nil end
    local i = 1
    while true do
        local name, val = GLOBAL.debug.getupvalue(fn, i)
        if not name then break end
        if name == target_name then
            return val, i
        end
        i = i + 1
    end
    return nil
end

-- ==============================================================================
-- 范式 2：生物巢穴伪装采集与防卫降级切面 (scripts/hooks/safe_harvest.lua)
-- ==============================================================================

--- 装备或专属 Buff 判定
local function IsDisguised(player)
    if not player or not player.components.inventory then return false end
    local head_item = player.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
    return head_item and head_item.prefab == "beehat"
end

--- 蜂箱/巢穴无害化安全采集 Hook
AddPrefabPostInit("beebox", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    -- 1. 从原厂预制体初始化闭包中精准捞出私有贴图刷新函数
    local orig_updatelevel = ExtractUpvalue(GLOBAL.Prefabs.beebox.fn, "updatelevel")

    local function SafeHarvestCallback(inst, picker)
        if inst:HasTag("burnt") then return end

        -- 还原原厂蜂蜜外观贴图
        if orig_updatelevel then
            orig_updatelevel(inst)
        end

        -- 核心防御与警报降级
        if inst.components.childspawner and not GLOBAL.TheWorld.state.iswinter then
            if IsDisguised(picker) then
                -- 玩家穿戴蜂帽：释放蜜蜂但不建立任何攻击目标 (散步和平模式)
                inst.components.childspawner:ReleaseAllChildren(nil)
            else
                -- 原版惩罚：蜜蜂出巢并疯狂追杀采集者
                inst.components.childspawner:ReleaseAllChildren(picker)
            end
        end
    end

    if inst.components.harvestable then
        inst.components.harvestable:SetUp("honey", 6, nil, SafeHarvestCallback, orig_updatelevel)
    end
end)

-- ==============================================================================
-- 范式 3：群体生物周期性寻敌索敌过滤器重写 (防误伤与伪装豁免)
-- ==============================================================================

local function DisguiseAwareRetarget(inst)
    -- 仅在春季激怒季节寻敌，同时豁免穿戴蜂帽的目标
    if not GLOBAL.TheWorld.state.isspring then return nil end

    return GLOBAL.FindEntity(inst, 4, function(target)
        -- 核心断言：穿戴伪装防具者直接豁免！
        return not IsDisguised(target) and inst.components.combat:CanTarget(target)
    end, { "_combat", "_health" }, { "insect", "INLIMBO" }, { "character", "animal", "monster" })
end

AddPrefabPostInit("bee", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    if inst.components.combat then
        -- 设置 2 秒周期的安全索敌检测
        inst.components.combat:SetRetargetFunction(2, DisguiseAwareRetarget)
    end
end)
```

---

## 三、避坑与生产安全准则

1. **绝对禁止在客户端运行战斗索敌逻辑**：
   - `combat:SetRetargetFunction` 与 `childspawner` 纯属 MasterSim 服务端权威组件。在客机执行会导致 `attempt to index nil value (combat)` 瞬间退服崩溃。必须始终在 `if TheWorld.ismastersim then` 守卫下调用。
2. **私有闭包提取必须做 `nil` 容错**：
   - 官方游戏在进行代码重构时可能会调整局部函数名。使用 `ExtractUpvalue` 提取函数后，在后续回调中必须加入 `if orig_updatelevel then orig_updatelevel(inst) end` 守卫，杜绝断言崩溃。
