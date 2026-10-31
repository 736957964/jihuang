# 饥荒创意工坊研读报告：StarveBucks 饥巴克

- **模组标识**：`3827537804`
- **作者**：豪斯歪埃斯埃勒芬特
- **版本**：1.0.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：22 个 Lua 文件 / 共 7464 行；网络变量 0 处；RPC 0 处；注入钩子 6 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `modworldgenmain.lua`
- `scripts/components/sbmilkable.lua`
- `scripts/prefabs/sb_aged_cheese.lua`
- `scripts/prefabs/sb_bowl.lua`
- `scripts/prefabs/sb_buffs.lua`
- `scripts/prefabs/sb_coconut.lua`
- `scripts/prefabs/sb_coffee.lua`
- `scripts/prefabs/sb_coffeebeans.lua`
- `scripts/prefabs/sb_coffeeplant.lua`
- `scripts/prefabs/sb_curd.lua`
- `scripts/prefabs/sb_moonlight_cheese.lua`
- `scripts/prefabs/sb_prepared.lua`
- `scripts/prefabs/sb_rawmilk.lua`
- `scripts/sb_art.lua`
- `scripts/sb_coconut_common.lua`
- `scripts/sb_compat.lua`
- `scripts/sb_foodrecipes.lua`
- `scripts/sb_speed.lua`
- `scripts/sb_spicedfoods.lua`
- `scripts/sb_strings.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `tumbleweed` | 1 |
| `AddPrefabPostInit` | `beefalo` | 1 |
| `AddPrefabPostInit` | `ndnr_milk` | 1 |
| `AddPrefabPostInit` | `ash` | 1 |
| `AddComponentPostInit` | `knownfoods` | 1 |
| `AddComponentPostInit` | `explosive` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("tumbleweed")
```lua

AddPrefabPostInit("tumbleweed", function(inst)
    -- ⚠ modmain 跑在白名单环境里，裸写 TheWorld 是 nil（不是 false），
    --   必须从 G 取；否则守卫永远在第一步就 return，而且不会报错。
    local world = G.TheWorld
    if inst == nil
        or world == nil
        or not world.ismastersim
        or inst.loot == nil
        or inst.lootaggro == nil then
        return inst
    end
```
### AddPrefabPostInit("beefalo")
```lua
if not COMPAT.ndnr then
    AddPrefabPostInit("beefalo", BeefaloPostInit)
end

------------------------------------------------------------------------------
-- 9.1 富贵险中求：把它的牛奶接进本 mod 的奶酪线
--
-- 需求：鲜牛奶由富贵险中求的牛奶代替，并且【保留「过期变发酵凝乳」这条机制】。
--
-- 它的 ndnr_milk 原本 onperishreplacement = "spoiled_food"（腐烂物），
-- 这里改成 "curd"（本 mod 的发酵凝乳），于是：
--     牛奶放坏 → 发酵凝乳 → 4 份下锅 → 白奶酪 → 放坏 → 陈年白奶酪 → 喂月亮蘑菇 → 月光奶酪
```
### AddPrefabPostInit("ndnr_milk")
```lua
--
-- ⚠ 为什么用 AddPrefabPostInitAny 而不是 AddPrefabPostInit("ndnr_milk", ...)：
--   mainfunctions.lua:113 在【该 prefab 注册的那一刻】就把 postinit 列表抓走了
--   （modprefabinitfns[name] = ModManager:GetPostInitFns(...)）。
--   本 mod 的目录名 starvebucks 排在 workshop-2823458540 前面，
--   加载顺序上占不到便宜也说不准 —— 一旦对方先注册，具名 postinit 就永远不会跑，
--   而且【不报错】。Any 版本是在 SpawnPrefab 时才取表，跨 Mod 顺序稳定。
--
-- ⚠ 只在服务端改：perishable 是服务端组件，客户端那份没有它。
------------------------------------------------------------------------------

if COMPAT.ndnr then
```
### AddPrefabPostInit("ash")
```lua

AddPrefabPostInit("ash", function(inst)
    local world = GLOBAL.TheWorld
    if world ~= nil and world.ismastersim then
        if inst.components.fertilizer == nil then
            inst:AddComponent("fertilizer")
        end
        local f = inst.components.fertilizer
        if f ~= nil then
            f.fertilizervalue = 1
            f.withered_cycles = 1
            f.fertilize_sound = "dontstarve/common/fertilize"
```
### AddComponentPostInit("knownfoods")
```lua
if COMPAT.craftpot then
    AddComponentPostInit("knownfoods", function(self)
        local old = self.OnAfterLoad
        if type(old) ~= "function" then
            return
        end
        self.OnAfterLoad = function(component, ...)
            local result = old(component, ...)
            G.pcall(PatchCraftPotCheese, component)
            return result
        end
    end)
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。