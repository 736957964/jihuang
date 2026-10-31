# 饥荒创意工坊研读报告：enable_lazy_explorer

- **模组标识**：`3828108612`
- **作者**：dxwy
- **版本**：1.2.4
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：10 个 Lua 文件 / 共 1282 行；网络变量 0 处；RPC 0 处；注入钩子 6 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/morerepairableitems/chilledamulet.lua`
- `scripts/morerepairableitems/lazyforager.lua`
- `scripts/morerepairableitems/lifeamulet.lua`
- `scripts/morerepairableitems/magiluminescence.lua`
- `scripts/morerepairableitems/main.lua`
- `scripts/morerepairableitems/nightmareamulet.lua`
- `scripts/morerepairableitems/staff.lua`
- `scripts/morerepairableitems/util.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `blueamulet` | 1 |
| `AddPrefabPostInit` | `orangeamulet` | 1 |
| `AddPrefabPostInit` | `amulet` | 1 |
| `AddPrefabPostInit` | `yellowamulet` | 1 |
| `AddPrefabPostInit` | `purpleamulet` | 1 |
| `AddPrefabPostInit` | `orangestaff` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("blueamulet")
```lua
local function Install(api, config)
    api.AddPrefabPostInit("blueamulet", function(inst)
        if not U.IsServerSide() then
            return inst
        end
        local fueled = inst.components.fueled
        local equippable = inst.components.equippable
        if fueled == nil or equippable == nil then
            return inst
        end

        inst._mri_onequip = equippable.onequipfn
```
### AddPrefabPostInit("orangeamulet")
```lua
local function Install(api, config)
    api.AddPrefabPostInit("orangeamulet", function(inst)
        if not U.IsServerSide() then
            return inst
        end
        local finiteuses = inst.components.finiteuses
        local equippable = inst.components.equippable
        if finiteuses == nil or equippable == nil then
            return inst
        end

        inst._mri_onequip = equippable.onequipfn
```
### AddPrefabPostInit("amulet")
```lua
local function Install(api, config)
    api.AddPrefabPostInit("amulet", function(inst)
        if not U.IsServerSide() then
            return inst
        end
        local finiteuses = inst.components.finiteuses
        local equippable = inst.components.equippable
        if finiteuses == nil or equippable == nil then
            return inst
        end

        inst._mri_onequip = equippable.onequipfn
```
### AddPrefabPostInit("yellowamulet")
```lua
local function Install(api, config)
    api.AddPrefabPostInit("yellowamulet", function(inst)
        if not U.IsServerSide() then
            return inst
        end
        local equippable = inst.components.equippable
        local fueled = inst.components.fueled
        if equippable == nil or fueled == nil then
            return inst
        end

        inst._mri_onequip = equippable.onequipfn
```
### AddPrefabPostInit("purpleamulet")
```lua
local function Install(api, config)
    api.AddPrefabPostInit("purpleamulet", function(inst)
        if not U.IsServerSide() then
            return inst
        end
        local fueled = inst.components.fueled
        local equippable = inst.components.equippable
        if fueled == nil or equippable == nil then
            return inst
        end

        inst._mri_onequip = equippable.onequipfn
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。