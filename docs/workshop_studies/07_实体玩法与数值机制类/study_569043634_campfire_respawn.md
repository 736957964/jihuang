# 饥荒创意工坊研读报告：Campfire Respawn

- **模组标识**：`569043634`
- **作者**：Onidotmoe
- **版本**：1.6.10
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 577 行；网络变量 0 处；RPC 3 处；注入钩子 5 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `skeleton_player` | 2 |
| `AddPrefabPostInit` | `multiplayer_portal` | 1 |
| `AddPrefabPostInit` | `reviver` | 1 |
| `AddPrefabPostInit` | `skeleton` | 1 |
| `AddComponentPostInit` | `inventory` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("skeleton_player")
```lua
    AddPrefabPostInit("skeleton",        AddResurrector)
    AddPrefabPostInit("skeleton_player", AddResurrector)
end

if IsEnabled("usetags") then
    -- Runs on all prefabs as i couldn't find a way to iterate through all prefabs post-all mods initialization
    AddPrefabPostInitAny(function(Prefab)
        -- Do not try to add "resurrector" if it's already there
        if ((Prefab ~= nil) and (Prefab.components ~= nil) and Prefab:HasTag("campfire") and (not Prefab:HasTag("resurrector"))) then
            AddResurrector(Prefab)
        end
    end)
```
### AddPrefabPostInit("multiplayer_portal")
```lua
if (IsEnabled("KeepInventory") and IsEnabled("KeepInventory_BugFix")) then
    AddPrefabPostInit("multiplayer_portal", function (Prefab)
        if (Prefab.components.hauntable ~= nil) then
            local Old_onhaunt = Prefab.components.hauntable.onhaunt

            Prefab.components.hauntable:SetOnHauntFn(function (inst, haunter)
                -- The vanilla game doesn't have anything in onhaunt for the portal but a mod might have added something
                if (Old_onhaunt ~= nil) then
                    Old_onhaunt(inst, haunter)
                end

                -- There needs to be a delay specific for the portal to allow all it's AnimState to be set before we modify them afterwards
```
### AddPrefabPostInit("reviver")
```lua
if IsEnabled("reviver") then
    AddPrefabPostInit("reviver", AddResurrector)
end

if IsEnabled("skeleton") then
    AddPrefabPostInit("skeleton",        AddResurrector)
    AddPrefabPostInit("skeleton_player", AddResurrector)
end

if IsEnabled("usetags") then
    -- Runs on all prefabs as i couldn't find a way to iterate through all prefabs post-all mods initialization
    AddPrefabPostInitAny(function(Prefab)
```
### AddPrefabPostInit("skeleton")
```lua
if IsEnabled("skeleton") then
    AddPrefabPostInit("skeleton",        AddResurrector)
    AddPrefabPostInit("skeleton_player", AddResurrector)
end

if IsEnabled("usetags") then
    -- Runs on all prefabs as i couldn't find a way to iterate through all prefabs post-all mods initialization
    AddPrefabPostInitAny(function(Prefab)
        -- Do not try to add "resurrector" if it's already there
        if ((Prefab ~= nil) and (Prefab.components ~= nil) and Prefab:HasTag("campfire") and (not Prefab:HasTag("resurrector"))) then
            AddResurrector(Prefab)
        end
```
### AddComponentPostInit("inventory")
```lua
if IsEnabled("KeepInventory") then
    AddComponentPostInit("inventory", function (self)
        if self.inst:HasTag("player") then
            local Old_DropEverything = self.DropEverything

            self.DropEverything = function(self, ondeath, keepequip)
                if (ondeath) then
                    -- For WX-78's modules, they will be dropped!
                    if (self.inst.components.upgrademoduleowner ~= nil) then
                        -- The game pushes their modules into the ActiveItem slot(the mouse cursor), this prevents them from respawning correctly.
                        -- So drop it!
                        self.inst.components.inventory:DropActiveItem()
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
2. 注册了 3 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。