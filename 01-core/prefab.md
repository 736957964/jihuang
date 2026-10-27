# Prefab 系统

> 源码文件：`scripts/prefabs.lua`、`scripts/mainfunctions.lua`

## Prefab 类定义

```lua
-- scripts/prefabs.lua
Prefab = Class(function(self, name, fn, assets, deps, force_path_search)
    self.name = name      -- 预制体名称
    self.desc = ""        -- 描述
    self.fn = fn          -- 构造工厂函数 function(Sim) → inst
    self.assets = assets or {}  -- 资源列表
    self.deps = deps or {}      -- 依赖的预制体列表
    self.force_path_search = force_path_search or false
end)
```

## Asset 类

```lua
Asset = Class(function(self, type, file, param)
    self.type = type   -- 资源类型，如 "ANIM", "SOUND", "IMAGE" 等
    self.file = file   -- 资源文件路径
    self.param = param -- 额外参数
end)
```

### 常见 Asset 类型

| type | 说明 | 示例 |
|------|------|------|
| `"ANIM"` | 动画文件 (.zip) | `Asset("ANIM", "anim/player.zip")` |
| `"SOUND"` | 声音文件 | `Asset("SOUND", "sound/player.fsb")` |
| `"SOUNDPACKAGE"` | 声音包 | `Asset("SOUNDPACKAGE", "sound/player.fev")` |
| `"IMAGE"` | 图片 | `Asset("IMAGE", "images/inventoryimages.xml")` |
| `"ATLAS"` | 图集 | `Asset("ATLAS", "images/inventoryimages.xml")` |
| `"PKGREF"` | 包引用 | `Asset("PKGREF", "anim/dynamic.zip")` |
| `"INV_IMAGE"` | 库存图片（不会被resolve） | `Asset("INV_IMAGE", "myitem")` |
| `"MINIMAP_IMAGE"` | 小地图图标 | `Asset("MINIMAP_IMAGE", "myitem")` |

## 预制体注册

### RegisterPrefabs(...)
批量注册预制体。
```lua
RegisterPrefabs(
    Prefab("myitem", fn, assets, deps),
    Prefab("mymob", fn2, assets2, deps2)
)
```

### RegisterSinglePrefab(prefab)
注册单个预制体。

### RegisterPrefabsImpl(prefab, resolve_fn)
内部注册函数。

## 预制体加载

### LoadPrefabFile(filename [, async_batch_validation], [search_asset_first_path])
加载预制体文件。
```lua
LoadPrefabFile("prefabs/01_wilson.lua")
```

### PREFABDEFINITIONS
全局表，存储所有已注册的预制体定义。key 为预制体名称。
```lua
PREFABDEFINITIONS["wilson"].fn  -- Wilson 的工厂函数
```

## 预制体工厂函数标准模板

```lua
local assets = {
    Asset("ANIM", "anim/myitem.zip"),
    Asset("IMAGE", "images/inventoryimages.xml"),
    Asset("ATLAS", "images/inventoryimages.xml"),
}

local function fn(Sim)
    local inst = CreateEntity()  -- 创建实体
    
    -- 添加变换组件
    inst.entity:AddTransform()
    -- 添加动画状态
    inst.entity:AddAnimState()
    -- 添加音效发射器
    inst.entity:AddSoundEmitter()
    -- 添加小地图图标
    inst.entity:AddMiniMapEntity()
    -- 添加网络组件
    inst.entity:AddNetwork()
    
    -- 设置动画
    inst.AnimState:SetBank("myitem")
    inst.AnimState:SetBuild("myitem")
    inst.AnimState:PlayAnimation("idle")
    
    -- 添加自定义组件
    inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")
    
    -- 设置网络同步
    if not TheWorld.ismastersim then
        return inst
    end
    
    -- 主端专属逻辑
    inst:AddComponent("fueled")
    inst.components.fueled:SetMaxFuel(100)
    
    return inst
end

return Prefab("myitem", fn, assets)
```

## CreateEntity

### CreateEntity([name]) → EntityScript
创建实体。会自动分配 GUID 并加入 `Ents` 表。
```lua
local inst = CreateEntity("自定义名称")
```

## 实体生成

### SpawnPrefab(name [, skin], [skin_id], [creator], [skin_custom]) → EntityScript
生成预制体实例。
```lua
local item = SpawnPrefab("axe")
item.Transform:SetPosition(x, y, z)
```

### SpawnPrefabFromSim(name) → GUID
从引擎层生成预制体（返回 GUID）。
```lua
local guid = SpawnPrefabFromSim("axe")
local inst = Ents[guid]
```

### ReplacePrefab(original_inst, name [, skin], [skin_id], [creator]) → EntityScript
替换实体（保持原位置）。
```lua
local new_inst = ReplacePrefab(old_tree, "tree_stump")
```

### PrefabExists(name) → boolean
检查预制体是否存在。
```lua
if PrefabExists("my_custom_item") then
    SpawnPrefab("my_custom_item")
end
```

## 存档加载

### SpawnSaveRecord(saved [, newents]) → EntityScript
从存档记录生成实体。

## Mod 前端资源

### ModReloadFrontEndAssets(assets, modname)
重新加载 Mod 前端资源。

### ModUnloadFrontEndAssets([modname])
卸载 Mod 前端资源。

### ModPreloadAssets(assets, modname)
预加载 Mod 资源。

### ModUnloadPreloadAssets([modname])
卸载预加载资源。

## Prefab 依赖 (deps)

依赖列表中的预制体会在目标预制体加载前先被加载：
```lua
local prefab = Prefab("myitem", fn, assets, {"axe", "pickaxe"})
```

## Prefab 皮肤

### PREFAB_SKINS
全局表，存储每个预制体可用的皮肤列表。
```lua
-- prefabskins.lua 中定义
PREFAB_SKINS["axe"] = {"axe_golden", "axe_lucy"}
```

## 预制体 PostInit

Mod 可以通过以下方式在预制体创建后注入逻辑：

### AddPrefabPostInit(prefab_name, fn)
```lua
-- modmain.lua
AddPrefabPostInit("wilson", function(inst)
    inst:AddComponent("mycomponent")
end)
```

### AddPrefabPostInitAny(fn)
对所有预制体执行。
```lua
AddPrefabPostInitAny(function(inst)
    if inst:HasTag("monster") then
        inst:AddComponent("mycomponent")
    end
end)
```

## 标准预制体模板参考

Klei 通常将同一类预制体放在同一个 lua 文件中，文件返回一个或多个 `Prefab` 对象的数组：

```lua
-- 单预制体文件
return Prefab("axe", fn, assets)

-- 多预制体文件
return Prefab("grass", fn1, assets1),
       Prefab("sapling", fn2, assets2)
```

## 预制体分类统计

| 分类 | 数量 | 示例 |
|------|------|------|
| 角色 | ~20 | wilson, willow, wendy, wx78... |
| 生物 | ~200 | spider, beefalo, hound, deerclops... |
| 物品 | ~500+ | axe, spear, backpack, amulet... |
| 建筑 | ~200+ | campfire, chest, sciencemachine... |
| 植物 | ~100+ | grass, sapling, tree, berrybush... |
| 特效 | ~300+ | fire, smoke, splash, sparkle... |
| 其他 | ~200+ | 地面、天空、全局对象等 |
