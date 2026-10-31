# 饥荒创意工坊研读报告：mudrock_health

- **模组标识**：`2968760008`
- **作者**：未知
- **版本**：2.5
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：39 个 Lua 文件 / 共 3905 行；网络变量 5 处；RPC 2 处；注入钩子 6 处

## 一、代码结构与入口分布

顶层目录：`scripts/`

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`
- `scripts/brains/mudrock_colosuss_brain.lua`
- `scripts/components/mudrockbook.lua`
- `scripts/components/mudrockelite.lua`
- `scripts/components/mudrockreader.lua`
- `scripts/components/mudrockskill.lua`
- `scripts/components/mudrockward.lua`
- `scripts/main/mudrock_actions.lua`
- `scripts/main/mudrock_recipes.lua`
- `scripts/main/mudrock_sg.lua`
- `scripts/main/mudrock_skills.lua`
- `scripts/main/mudrock_str.lua`
- `scripts/main/mudrock_util.lua`
- `scripts/main/mudrock_widgets.lua`
- `scripts/prefabs/mudrock.lua`
- `scripts/prefabs/mudrock_background.lua`
- `scripts/prefabs/mudrock_cake.lua`
- `scripts/prefabs/mudrock_cake_buff.lua`
- `scripts/prefabs/mudrock_cake_covered.lua`
- `scripts/prefabs/mudrock_colosuss.lua`
- `scripts/prefabs/mudrock_dizzy_fx.lua`
- `scripts/prefabs/mudrock_elite_book.lua`
- `scripts/prefabs/mudrock_figure.lua`
- `scripts/prefabs/mudrock_figure_2.lua`
- `scripts/prefabs/mudrock_figure_buff.lua`
- `scripts/prefabs/mudrock_hammer.lua`
- `scripts/prefabs/mudrock_hammer_fx.lua`
- `scripts/prefabs/mudrock_hit_fx.lua`
- `scripts/prefabs/mudrock_juice.lua`
- `scripts/prefabs/mudrock_juice_buff.lua`
- `scripts/prefabs/mudrock_none.lua`
- `scripts/prefabs/mudrock_ward.lua`
- `scripts/prefabs/mudrock_ward_bubble.lua`
- `scripts/prefabs/mudrock_ward_fx.lua`
- `scripts/speech_mudrock.lua`
- `scripts/speech_mudrock_en.lua`
- `scripts/stategraphs/SGmudrock_colosuss.lua`
- `scripts/widgets/mudrock_skill_badge.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddStategraphPostInit` | `wilson` | 2 |
| `AddStategraphPostInit` | `wilson_client` | 1 |
| `AddComponentPostInit` | `armor` | 1 |
| `AddComponentPostInit` | `healer` | 1 |
| `AddComponentPostInit` | `combat` | 1 |
| `AddComponentPostInit` | `edible` | 1 |

## 三、关键代码片段

### AddStategraphPostInit("wilson")
```lua
end
AddStategraphPostInit("wilson", SGWilsonPostInit)
AddStategraphPostInit("wilson", function(sg)
    if sg.events and sg.events.attacked then
        local old_attacked = sg.events.attacked.fn
        sg.events.attacked.fn = function(inst, data)
            if (inst.sg and inst.sg:HasStateTag("nointerrupt") and inst.sg:HasStateTag("mudrock_splitter")) then
                return
            end
            return old_attacked(inst, data)
        end
    end
```
### AddStategraphPostInit("wilson_client")
```lua
end)
AddStategraphPostInit("wilson_client", SGWilsonClientPostInit)
```
### AddComponentPostInit("armor")
```lua
AddComponentPostInit("armor", function(self)
    local old_absorption = self.GetAbsorption
    function self:GetAbsorption(attacker, weapon, ...)
        local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetGrandOwner() or nil
        local absorption = old_absorption(self, attacker, weapon, ...)
        if absorption == nil then
            return absorption
        end
        if owner ~= nil and owner:HasTag("mudrock") then
            return absorption >= 1 and 1 or 0
        else
            return absorption
```
### AddComponentPostInit("healer")
```lua
end)
AddComponentPostInit("healer", function(self)
    local old_heal = self.Heal
    function self:Heal(target, doer, ...)
        if target:HasTag("mudrock") then
            if target.components.talker then
                target.components.talker:Say("这些对我并没有效果")
            end
            if self.onhealfn ~= nil then
                self.onhealfn(self.inst, target)
            end
            if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
```
### AddComponentPostInit("combat")
```lua
end)
AddComponentPostInit("combat", function(self)
    local old_get_attacked = self.GetAttacked
    function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
        if not self.inst:HasTag("mudrock") and self.inst:HasTag("mudrock_warded") then
            if self.inst.mudrock_ward then
                self.inst.components.health:DoDelta(self.inst.components.health:GetMaxWithPenalty() * 0.2)
                self.inst.components.debuffable:RemoveDebuff("mudrock_juice_buff")
            end
        else
            return old_get_attacked(self, attacker, damage, weapon, stimuli, spdamage, ...)
        end
```

## 四、复刻要点与风险提示

1. 该 MOD 使用了 5 处 `net_*` 网络变量，复刻时必须保证在 `inst.entity:AddNetwork()` 之后、`SetPristine()` 之前完成初始化，否则客户端实体不同步。
2. 注册了 2 处 RPC，客户端调用前必须做 `UserToPlayer` 与权限校验，避免被构造参数越权。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。