# 饥荒创意工坊研读报告：囤货鼠 - Stockpile Rat

- **模组标识**：`3829996901`
- **作者**：宫檐龙泫
- **版本**：1.0.1
- **研读方式**：SteamCMD 拉取工坊原版 -> 本地静态解析 Lua 源码
- **规模**：2 个 Lua 文件 / 共 1307 行；网络变量 0 处；RPC 0 处；注入钩子 13 处

## 一、代码结构与入口分布

Lua 文件清单（最多 40 条）：

- `modinfo.lua`
- `modmain.lua`

## 二、注入钩子清单（真实提取）

| 钩子 API | 目标 | 出现次数 |
| :--- | :--- | :--- |
| `AddComponentPostInit` | `tool` | 1 |
| `AddStategraphPostInit` | `wilson` | 1 |
| `AddComponentPostInit` | `sanity` | 1 |
| `AddComponentPostInit` | `hunger` | 1 |
| `AddComponentPostInit` | `combat` | 1 |
| `AddComponentPostInit` | `moisture` | 1 |
| `AddComponentPostInit` | `lootdropper` | 1 |
| `AddComponentPostInit` | `pickable` | 1 |
| `AddComponentPostInit` | `locomotor` | 1 |
| `AddComponentPostInit` | `temperature` | 1 |
| `AddComponentPostInit` | `freezable` | 1 |
| `AddPrefabPostInit` | `world` | 1 |

## 三、关键代码片段

### AddComponentPostInit("tool")
```lua
    -- ── 5.1 工作效率（绿宝石）—— Hook 工具的 GetEffectiveness，倍乘 numworks 让 WorkedBy 自然消减 workleft ──
    AddComponentPostInit("tool", function(self)
        if self._sr_tool_hooked then return end
        self._sr_tool_hooked = true
        local _GetEffectiveness = self.GetEffectiveness
        function self:GetEffectiveness(action, ...)
            local base = _GetEffectiveness(self, action, ...)
            if self.inst.components.inventoryitem then
                local owner = self.inst.components.inventoryitem.owner
                if owner and owner._sr_work and owner._sr_work > 0 then
                    return base * (1 + owner._sr_work)
                end
```
### AddStategraphPostInit("wilson")
```lua
    -- ── 5.1b 制作加速（绿宝石）—— BUILD 动作：≥10颗绿宝石解锁快速制作 ──
    AddStategraphPostInit("wilson", function(sg)
        local build = sg.actionhandlers[GLOBAL.ACTIONS.BUILD]
        if not build then return end
        local oldbuild = build.deststate
        build.deststate = function(inst, action, ...)
            if inst._sr_fast_craft then
                return "doshortaction"
            end
            return oldbuild(inst, action, ...)
        end
    end)
```
### AddComponentPostInit("sanity")
```lua
    -- ── 5.2 精神恢复放大（燧石） ──
    AddComponentPostInit("sanity", function(self)
        local _DoDelta = self.DoDelta
        function self:DoDelta(delta, ...)
            if delta > 0 and self.inst._sr_sanity_gain and self.inst._sr_sanity_gain > 0 then
                delta = delta * (1 + self.inst._sr_sanity_gain)
            end
            return _DoDelta(self, delta, ...)
        end
    end)

    -- ── 5.3 饥饿恢复放大（硝石） ──
```
### AddComponentPostInit("hunger")
```lua
    -- ── 5.3 饥饿恢复放大（硝石） ──
    AddComponentPostInit("hunger", function(self)
        local _DoDelta = self.DoDelta
        function self:DoDelta(delta, ...)
            if delta > 0 and self.inst._sr_hunger_gain and self.inst._sr_hunger_gain > 0 then
                delta = delta * (1 + self.inst._sr_hunger_gain)
            end
            return _DoDelta(self, delta, ...)
        end
    end)

    -- ── 5.4 伤害增强 + 真伤（纯粹辉煌）+ 暴击（黄/橙宝石） ──
```
### AddComponentPostInit("combat")
```lua
    -- ── 5.4 伤害增强 + 真伤（纯粹辉煌）+ 暴击（黄/橙宝石） ──
    AddComponentPostInit("combat", function(self)
        if self._sr_combat_hooked then return end
        self._sr_combat_hooked = true

        -- ── CalcDamage ──
        -- 注意：原生返回 (damage, spdamage)，必须保留两个返回值
        local _CalcDamage = self.CalcDamage
        function self:CalcDamage(target, weapon, multiplier, ...)
            local dmg, spdamage = _CalcDamage(self, target, weapon, multiplier, ...)
            if self.inst._sr_damage then
                dmg = dmg * self.inst._sr_damage
```

## 四、复刻要点与风险提示

1. 未使用网络变量，属纯客户端/纯主机逻辑，注意区分 `TheWorld.ismastersim` 分支，别把服务端逻辑写到客户端段。
3. 与改动同一目标的其它 MOD 有冲突风险，接入前先跑一遍钩子目标对照。

---

> 本文由 8 并发研读流水线生成，结论全部来自工坊原版源码静态解析，未做臆测补全。