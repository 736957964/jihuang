# Mod 开发指南

## 概述

DST Mod 开发基于 Lua 脚本。Mod 目录结构：
```
my_mod/
├── modinfo.lua      # Mod 元信息（必需）
├── modmain.lua      # Mod 主逻辑（必需）
├── modicon.tex      # Mod 图标（必需，TEX格式）
├── modicon.xml      # Mod 图标 XML
├── scripts/         # Lua 脚本
│   ├── prefabs/     # 自定义预制体
│   └── components/  # 自定义组件
├── anim/            # 动画文件
├── images/          # 图片资源
├── sound/           # 音效资源
└── bigportraits/    # 大头像
```

---

## 一、modinfo.lua

```lua
name = "我的 Mod 名称"
description = "Mod 描述"
author = "作者名"
version = "1.0.0"

forumthread = ""
api_version = 10
api_version_dst = 10

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- 服务器配置选项
configuration_options = {
    {
        name = "difficulty",
        label = "难度",
        options = {
            { description = "简单", data = "easy" },
            { description = "普通", data = "normal" },
            { description = "困难", data = "hard" },
        },
        default = "normal",
    },
}

-- 服务器标签（影响搜索/匹配）
server_filter_tags = { "character", "item" }

-- 优先级（越大越后加载）
priority = 0
```

---

## 二、modmain.lua

### 基础结构

```lua
-- 引入依赖
local require = GLOBAL.require
local TUNING = GLOBAL.TUNING

-- Mod 初始化
local function OnLoad()
    -- 启动时执行
end

-- 修改预制体（最常用）
AddPrefabPostInit("wilson", function(inst)
    -- 对威尔逊进行修改
end)

-- 修改组件
AddComponentPostInit("health", function(self)
    -- 对 health 组件进行修改
end)
```

### GLOBAL 命名空间

```lua
-- 访问全局变量
local GLOBAL = GLOBAL
GLOBAL.SpawnPrefab("spear")
GLOBAL.TheWorld
GLOBAL.ThePlayer
GLOBAL.AllPlayers
GLOBAL.GetPlayer()
GLOBAL.STRINGS
GLOBAL.TUNING
GLOBAL.ACTIONS
GLOBAL.EQUIPSLOTS
```

---

## 三、PrefabPostInit 系列

### AddPrefabPostInit

```lua
-- 对已有预制体进行修改
AddPrefabPostInit("spear", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end
    inst.components.weapon:SetDamage(50)  -- 修改长矛伤害
end)

AddPrefabPostInit("wilson", function(inst)
    -- 修改威尔逊
    inst.components.health:SetMaxHealth(200)
end)

-- 对所有预制体生效
AddPrefabPostInitAny(function(inst)
    -- inst 是任何生成的预制体
    if inst:HasTag("monster") then
        inst.components.health:SetMaxHealth(
            inst.components.health.maxhealth * 2
        )
    end
end)
```

### AddPrefabPostInit 的加载顺序

```lua
-- 使用 priority 控制加载顺序
AddPrefabPostInit("spear", function(inst)
    -- 第二个执行
end, 1)  -- priority = 1

AddPrefabPostInit("spear", function(inst)
    -- 第一个执行
end, 0)  -- priority = 0
```

---

## 四、ComponentPostInit

```lua
-- 修改组件默认行为
AddComponentPostInit("health", function(self)
    -- 保存原始方法
    local old_DoDelta = self.DoDelta
    
    -- 覆盖方法
    function self:DoDelta(amount, overtime, cause, ...)
        -- 自定义逻辑
        if amount < 0 and self.inst:HasTag("my_tag") then
            amount = amount * 0.5  -- 减半伤害
        end
        -- 调用原始方法
        return old_DoDelta(self, amount, overtime, cause, ...)
    end
end)
```

---

## 五、自定义物品/生物

### 创建自定义预制体

```lua
-- 在 modmain.lua 中
local assets = {
    Asset("ANIM", "anim/my_item.zip"),
    Asset("ATLAS", "images/my_item.xml"),
}

local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("my_item")
    inst.AnimState:SetBuild("my_item")
    inst.AnimState:PlayAnimation("idle")
    
    -- 网络同步
    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/my_item.xml"
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(42)
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(150)
    inst.components.finiteuses:SetConsumption(ACTIONS.ATTACK, 1)
    
    return inst
end

return Prefab("my_item", fn, assets)
```

### 注册预制体

```lua
-- 在 modmain.lua 中
PrefabFiles = {
    "my_item",
    "my_creature",
}
```

---

## 六、自定义动作

```lua
-- 定义新动作
local MY_ACTION = AddAction("MY_ACTION", "我的动作", function(act)
    -- 动作执行逻辑（服务器）
    if act.target and act.doer then
        act.target:DoSomething()
    end
    return true
end)

-- 关联组件
AddComponentAction("USEITEM", "mycomponent", function(inst, doer, actions, right)
    if right then return end
    table.insert(actions, MY_ACTION)
end)
```

---

## 七、自定义配方

```lua
-- 添加配方
local my_recipe = AddRecipe("my_item", {
    Ingredient("twigs", 3),
    Ingredient("flint", 2),
}, RECIPETABS.WAR, TECH.SCIENCE_ONE)

-- 自定义配方属性
my_recipe.atlas = "images/my_item.xml"
my_recipe.image = "my_item.tex"

-- 使用 Ingredient 修饰符
AddRecipe("my_item", {
    Ingredient("twigs", 3),
    Ingredient("flint", 2, "images/flint.xml"),  -- 自定义图标
}, RECIPETABS.WAR, TECH.SCIENCE_ONE, nil, nil, nil, nil, "my_character")
```

---

## 八、modutil API

```lua
local modutil = require("modutil")

-- 检查 Mod 是否加载
modutil.HasMod("workshop-123456")

-- 获取 Mod 配置
modutil.GetModConfigData(modname, key)
```

---

## 九、常用 API 速查

```lua
-- 全局变量
TheWorld            -- 当前世界
ThePlayer           -- 当前玩家（仅客户端）
TheNet              -- 网络管理
TheSim              -- 模拟器
TheInput            -- 输入管理
AllPlayers          -- 所有玩家列表

-- 常用函数
SpawnPrefab(name)   -- 生成预制体
GetTime()           -- 获取游戏时间
GetPlayer()         -- 获取当前玩家

-- 实体方法
inst:AddTag(tag)
inst:RemoveTag(tag)
inst:HasTag(tag)
inst:AddComponent(name)
inst:RemoveComponent(name)
inst:ListenForEvent(event, fn)
inst:PushEvent(event, data)
inst:DoTaskInTime(time, fn)
inst:DoPeriodicTask(period, fn)
inst:GetPosition()
inst:GetDistanceSqToInst(other)

-- 世界方法
TheWorld.Map:IsPassableAtPoint(x, y, z)
TheWorld.Map:GetTileAtPoint(x, y, z)
TheWorld.state.isday
TheWorld.state.iswinter
TheWorld.state.temperature
```

---

## 十、发布到 Steam Workshop

1. 将 Mod 文件夹放入 `Dont Starve Together/mods/`
2. 在游戏中启用 Mod
3. 使用 `dontstarve_steam.exe -ugc` 命令启动上传工具
4. 或使用游戏内 Mod 管理器的"上传"功能
