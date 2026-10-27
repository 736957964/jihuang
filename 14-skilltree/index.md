# 14 - SkillTree 技能树系统

> **源码位置**: `scripts/skilltreedata.lua` — 技能树核心数据类  
> **定义文件**: `scripts/prefabs/skilltree_defs.lua` — 各角色技能树定义  
> **核心组件**: `components/skilltreeupdater.lua` — 技能树同步更新  
> **UI**: `widgets/redux/skilltreewidget.lua`、`screens/redux/panels/skilltreepanel.lua`

## 1. 技能树概述

DST 的技能树系统允许玩家角色通过获取经验值来解锁技能点，然后投入技能树中解锁各种被动或主动能力。每个角色有自己独立的技能树。

### 核心概念

- **经验值 (XP)**：通过生存天数获取
- **技能点 (Skill Points)**：达到 XP 阈值后解锁
- **技能 (Skill)**：技能树中的节点，每个有独立效果
- **洞察 (Insight)**：技能树的另一种称呼

---

## 2. SkillTreeData 类

### 2.1 类定义

```lua
-- skilltreedata.lua
SkillTreeData = Class(function(self)
    self.activatedskills = {}  -- 已激活技能 {[characterprefab] = {[skill_id] = true}}
    self.skillxp = {}          -- 技能经验 {[characterprefab] = xp_value}
    NILDATA = NILDATA or self:EncodeSkillTreeData() -- 默认空数据
end)
```

### 2.2 核心方法

```lua
-- 判断技能是否激活
SkillTreeData:IsActivated(skill, characterprefab) -> boolean

-- 判断技能是否有效
SkillTreeData:IsValidSkill(skill, characterprefab) -> boolean

-- 获取角色技能经验
SkillTreeData:GetSkillXP(characterprefab) -> number

-- 获取最大可能经验值
SkillTreeData:GetMaximumExperiencePoints() -> number

-- 根据经验值计算可用技能点数
SkillTreeData:GetPointsForSkillXP(skillxp) -> number

-- 获取可用技能点数（总点数 - 已用点数）
SkillTreeData:GetAvailableSkillPoints(characterprefab) -> number

-- 重置技能（返还技能点）
SkillTreeData:RespecSkills(characterprefab)

-- 获取玩家的技能选择（用于网络同步）
SkillTreeData:GetPlayerSkillSelection(characterprefab)

-- 编码/解码技能树数据（用于存档）
SkillTreeData:EncodeSkillTreeData()
SkillTreeData:DecodeSkillTreeData(data)
```

### 2.3 经验值阈值

```lua
-- TUNING.SKILL_THRESHOLDS
-- 每个阈值代表解锁下一个技能点所需的 XP
TUNING.SKILL_THRESHOLDS = {
    120,    -- 第1个技能点需要 120 XP
    240,    -- 第2个技能点需要 240 XP
    480,    -- 第3个...
    960,    -- ...
    1920,   -- ...
    ...
}
```

---

## 3. 技能树定义 (skilltree_defs.lua)

### 3.1 数据结构

```lua
-- 技能树定义
SKILLTREE_DEFS = {
    [character_prefab] = {
        [skill_id] = {
            rpc_id = number,          -- RPC ID（用于网络同步）
            tag = "tag_name",         -- 激活时添加的 tag
            stat = "stat_name",       -- 关联的属性名
            desc = "描述",           -- 描述文本 key
            title = "标题",          -- 标题文本 key
            icon = "icon_path",      -- 图标路径
            maxlevel = 3,            -- 最大等级
            xp = function(inst, level) -- 升级所需 XP
                return level * 100
            end,
            activatesfn = function(inst, level)
                -- 激活时的效果
            end,
            deactivatesfn = function(inst, level)
                -- 取消激活时的效果
            end,
            activatesclientfn = function(inst, level)
                -- 客户端激活效果
            end,
            deactivatesclientfn = function(inst, level)
                -- 客户端取消激活效果
            end,
        },
    },
}
```

### 3.2 元信息

```lua
SKILLTREE_METAINFO = {
    [character_prefab] = {
        title = "技能树标题",
        desc = "技能树描述",
        icon = "图标路径",
    },
}
```

---

## 4. SkillTreeUpdater 组件

### 4.1 组件职责

`skilltreeupdater` 组件负责将玩家的技能选择同步到游戏状态：

```lua
-- components/skilltreeupdater.lua

-- 激活技能
skilltreeupdater:ActivateSkill(skill)

-- 取消激活技能
skilltreeupdater:DeactivateSkill(skill)

-- 检查技能是否激活（服务端安全）
skilltreeupdater:IsActivated(skill) -> boolean

-- 同步技能选择
skilltreeupdater:ApplySkillSelection()

-- 检查条件是否满足
skilltreeupdater:MeetsRequirements(skill) -> boolean
```

### 4.2 网络同步

技能树使用位字段（bitfield）进行网络同步，最多支持 32 个技能：

```lua
-- 同步槽位
SN_SKILLSELECTION  -- 技能选择网络同步
```

---

## 5. 技能节点类型

### 5.1 Tag 技能

最简单的技能类型，激活时添加 tag：

```lua
{
    rpc_id = 1,
    tag = "masterchef",
    title = "大厨",
    desc = "解锁高级烹饪能力",
    icon = "skill_chef",
    maxlevel = 1,
}
```

### 5.2 Stat 技能

激活时修改属性：

```lua
{
    rpc_id = 2,
    stat = "maxhealth",
    title = "强壮体魄",
    desc = "增加最大生命值",
    icon = "skill_health",
    maxlevel = 3,
    activatesfn = function(inst, level)
        inst.components.health:SetMaxHealth(150 + level * 25)
    end,
    deactivatesfn = function(inst, level)
        inst.components.health:SetMaxHealth(150)
    end,
}
```

### 5.3 主动技能

需要手动触发的技能：

```lua
{
    rpc_id = 3,
    title = "特殊攻击",
    desc = "解锁强力一击",
    icon = "skill_attack",
    maxlevel = 1,
    activatesfn = function(inst, level)
        inst:AddTag("special_attack")
        -- 绑定按键或动作
        inst:ListenForEvent("perform_special", OnSpecialAttack)
    end,
    deactivatesfn = function(inst, level)
        inst:RemoveTag("special_attack")
        inst:RemoveEventCallback("perform_special", OnSpecialAttack)
    end,
}
```

---

## 6. 技能树 UI

### 6.1 SkillTreeWidget

```lua
-- widgets/redux/skilltreewidget.lua
SkillTreeWidget = Class(function(self)
    self.root = ...
    self.skill_nodes = {}   -- 技能节点控件
    self.connections = {}   -- 连线控件
end)

-- 核心方法
SkillTreeWidget:SetSkillTree(skilltree_data)
SkillTreeWidget:Refresh()
SkillTreeWidget:OnSkillNodeClick(skill_id)
SkillTreeWidget:SetAvailablePoints(points)
```

### 6.2 SkillTreeBuilder

```lua
-- widgets/redux/skilltreebuilder.lua
-- 用于构建技能树的布局
SkillTreeBuilder = Class(function(self, data)
    self.nodes = {}     -- 节点位置
    self.edges = {}     -- 连线
end)

-- 构建布局
SkillTreeBuilder:Build(skilltree_def)
SkillTreeBuilder:GetNodePosition(skill_id)
SkillTreeBuilder:GetConnections()
```

---

## 7. Mod 开发 — 自定义技能树

### 7.1 为现有角色添加技能

```lua
-- modmain.lua
local skilltreedata_all = require("prefabs/skilltree_defs")
local SKILLTREE_DEFS = skilltreedata_all.SKILLTREE_DEFS

-- 添加新技能到 Wilson
SKILLTREE_DEFS.wilson.my_custom_skill = {
    rpc_id = 100,  -- 使用未占用的 ID
    tag = "custom_power",
    title = "我的自定义技能",
    desc = "一个示例技能",
    icon = "images/skill_icon.xml",
    maxlevel = 1,
    activatesfn = function(inst, level)
        inst.components.health:SetMaxHealth(
            inst.components.health.maxhealth + 50
        )
    end,
    deactivatesfn = function(inst, level)
        inst.components.health:SetMaxHealth(
            inst.components.health.maxhealth - 50
        )
    end,
}
```

### 7.2 为新角色创建技能树

```lua
-- scripts/prefabs/skilltree_defs.lua 中注册
SKILLTREE_DEFS.my_character = {
    skill_1 = {
        rpc_id = 1,
        tag = "my_tag_1",
        title = "技能一",
        desc = "第一个技能",
        icon = "my_icon_1",
        maxlevel = 3,
    },
    skill_2 = {
        rpc_id = 2,
        tag = "my_tag_2",
        title = "技能二",
        desc = "第二个技能",
        icon = "my_icon_2",
        maxlevel = 1,
    },
}

SKILLTREE_METAINFO.my_character = {
    title = "我的角色技能树",
    desc = "自定义技能树",
    icon = "my_skilltree_icon",
}
```

---

## 8. 经验值获取

### 8.1 获取方式

- **生存天数**：每存活一定天数获得经验
- **击败 Boss**：首次击败某些 Boss 可能获得额外经验

### 8.2 ExperienceCollector 组件

```lua
-- components/experiencecollector.lua
experiencecollector:AddXP(amount)          -- 增加经验
experiencecollector:GetXP()                -- 获取当前经验
experiencecollector:GetMaxXP()             -- 获取最大经验
experiencecollector:GetLevel()             -- 获取等级
experiencecollector:GetPoints()            -- 获取可用点数
experiencecollector:GetTotalPoints()       -- 获取总点数
```

---

## 9. 技能树实战案例库（Mod开发必查）

### 9.1 技能树前置依赖与解锁链（Requirements & Locks）

在实际角色 Mod 开发中，通常需要“点出前置技能才能点后续技能”，或者“投入达到一定点数才解锁大招”。官方通过 oot、group 和 locks 属性实现。

`lua
-- scripts/prefabs/skilltree_defs.lua 完整标准案例
local function BuildSkillsForCharacter()
    return {
        -- 根节点基础技能（无需前置）
        my_char_skill_base = {
            title = "战斗精通 I",
            desc = "提升基础物理攻击力 15%",
            icon = "my_char_skill_base",
            pos = { -60, 100 }, -- UI 画布坐标 {x, y}
            root = true,        -- 标记为树枝起点
            group = "combat",   -- 分组（不同分支）
            tags = { "combat_boost" },
            onactivate = function(inst)
                if inst.components.combat then
                    inst.components.combat.externaldamagemultipliers:SetModifier(inst, 1.15, "skill_boost")
                end
            end,
            ondeactivate = function(inst)
                if inst.components.combat then
                    inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "skill_boost")
                end
            end,
        },

        -- 进阶技能（需要前置技能激活）
        my_char_skill_upgrade = {
            title = "狂暴打击 II",
            desc = "攻击附带暴击几率",
            icon = "my_char_skill_upgrade",
            pos = { -60, 40 },
            group = "combat",
            locks = { "my_char_skill_base" }, -- 必须先激活 base 技能
            connects = { "my_char_skill_base" }, -- UI 画布绘制连接线
            tags = { "crit_boost" },
            onactivate = function(inst)
                inst:AddTag("can_crit_strike")
            end,
            ondeactivate = function(inst)
                inst:RemoveTag("can_crit_strike")
            end,
        },

        -- 终极终结技（需要本分支总投入至少 2 点）
        my_char_skill_ultimate = {
            title = "狂战战意",
            desc = "血量越低，移动与攻击速度越快",
            icon = "my_char_skill_ultimate",
            pos = { -60, -20 },
            group = "combat",
            locks = { "my_char_skill_upgrade" },
            connects = { "my_char_skill_upgrade" },
            onactivate = function(inst)
                -- 核心逻辑处理
            end,
        },
    }
end

-- 注册给全局定义
SKILLTREE_DEFS["my_character"] = BuildSkillsForCharacter()
`

### 9.2 客服端加点网络同步与 RPC 注册

技能树面板是在客户端（UI）上点击的，服务端必须能校验技能点有效性并同步应用效果：

`lua
-- 在 modmain.lua 中
-- 1. 声明角色拥有技能树支持
AddPrefabPostInit("my_character", function(inst)
    if not TheWorld.ismastersim then return end
    -- 服务端监听技能树加点事件
    inst:ListenForEvent("onactivateskill", function(inst, data)
        print("角色激活技能: ", data and data.skill)
    end)
    inst:ListenForEvent("ondeactivateskill", function(inst, data)
        print("角色重置/停用技能: ", data and data.skill)
    end)
end)

-- 2. 注册技能树专属 RPC 通信
AddModRPCHandler("MyMod_SkillTree", "LearnSkill", function(player, skill_name)
    if not player or not player.components.skilltreeupdater then return end
    if player.components.skilltreeupdater:CanActivateSkill(skill_name) then
        player.components.skilltreeupdater:ActivateSkill(skill_name)
    end
end)
`

### 9.3 避坑核心注意事项
1. **坐标与遮挡**：pos = { x, y } 是相对于当前角色技能树面板中心的相对坐标，相邻技能图标推荐 Y 轴间距在 60 ~ 80 之间，避免连线和图标重叠；
2. **状态重置（Respec）必须成对编写**：有 onactivate 就必须有对应的 ondeactivate！否则玩家重置技能点（洗点）时，添加的属性倍率、Tag 标签不会清除，导致玩家无限叠加属性；
3. **主客机判定**：属性修改逻辑（Health/Sanity/Combat/Inventory）只能在服务端（TheWorld.ismastersim）执行，客户端仅负责 UI 渲染与 RPC 触发。
