# 饥荒创意工坊研读报告：CH_LANG

- **模组标识**：`3353852416`
- **作者**：天涯，小花朵，Isosurface
- **版本**：1.5.6
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：12 个 Lua 文件 / 共 2248 行；网络变量 2 处；RPC 1 处；注入钩子 2 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/components/skintravelable.lua`
- `scripts/components/skintravelable_replica.lua`
- `scripts/lang/nana_teleport_cn.lua`
- `scripts/lang/nana_teleport_en.lua`
- `scripts/prefabs/skintravelable_classified.lua`
- `scripts/prefabs/teleportation.lua`
- `scripts/screens/skintravelscreen.lua`
- `scripts/skin/lantu.lua`
- `scripts/skin/nana_skin_list.lua`
- `scripts/skin/skinsapi.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddPrefabPostInit` | `reskin_tool` | 1 |
| `AddComponentPostInit` | `skinner` | 1 |

## 三、关键代码片段

### AddPrefabPostInit("reskin_tool")
```lua

AddPrefabPostInit("reskin_tool", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local oldSpellFn = inst.components.spellcaster.spell
    inst.components.spellcaster.spell = function(inst, target, pos, doer)
        oldSpellFn( inst, target, pos, doer)
        if target ~= nil then
            target:DoTaskInTime(FRAMES, function()
                target:PushEvent("reskinned")
            end)
```
### AddComponentPostInit("skinner")
```lua
    -- 人物皮肤的init_fn 和 clear_fn
    AddComponentPostInit("skinner", function(self)
        local oldfn = self.SetSkinName
        if oldfn then
            function self.SetSkinName(s, skinname, ...)
                local old = s.skin_name
                local new = skinname
                if characterskins[old] and characterskins[old].clear_fn then
                    characterskins[old].clear_fn(s.inst, old)
                end
                if characterskins[new] and characterskins[new].init_fn then
                    characterskins[new].init_fn(s.inst, new)
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 2 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 1 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。