# 饥荒知识提炼 Skill：entity
- 来源目录：01-core\entity.md (核心引擎与Entity/Class底层)
- 提炼时间：2026-10-29 22:09:18

## 一、核心概念与API规范
# EntityScript — 实体脚本

> 源码文件：`scripts/entityscript.lua`
> 
> `EntityScript` 是所有游戏实体的 Lua 端包装。每个实体（物品、生物、建筑等）在 Lua 中都是 `EntityScript` 的实例，通过 `inst` 变量访问。

## 构造函数

```lua
EntityScript = Class(function(self, entity)
    self.entity = entity
    self.components = {}
    self.lower_components_shadow = {}
    self.GUID = entity:GetGUID()
    self.spawntime = GetTime()
    self.persists = true
    self.inlimbo = false
    self.name = nil
    -- ... 更多初始化
end)
```

## 核心属性

| 属性 | 类型 | 说明 |
|------|--

## 二、生产级代码模版
```lua
-- 针对 entity 的标准扩展范式
AddPrefabPostInit("player", function(inst)
    if not TheWorld.ismastersim then return end
    -- 结合 entity 进行安全切面扩展
end)
```
